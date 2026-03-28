/*
 * audio_task.c — I2S + Goertzel acoustic drone detector (Core 1)
 *
 * DSP logic is unchanged from the original monolithic main.c.
 * The only addition is xQueueSend() calls on alarm state transitions.
 */

#include "audio_task.h"
#include "drone_detector.h"
#include "pin_config.h"

#include <math.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/queue.h"
#include "esp_log.h"
#include "esp_timer.h"
#include "driver/i2s_std.h"

static const char *TAG = "audio";

/* =========================================================================
 * Hardware — pin numbers sourced from pin_config.h, cast to gpio_num_t
 * ====================================================================== */
#define I2S_MIC_BCLK_GPIO   ((gpio_num_t)PIN_I2S_BCLK)
#define I2S_MIC_WS_GPIO     ((gpio_num_t)PIN_I2S_WS)
#define I2S_MIC_DIN_GPIO    ((gpio_num_t)PIN_I2S_DIN)

/* =========================================================================
 * DSP parameters  (calibrate per drone type / deployment environment)
 * ====================================================================== */
#define SAMPLE_RATE_HZ      16000
#define FRAME_SAMPLES       512
#define HOP_MS              100

#define GOERTZEL_FREQS      6
static const float k_target_hz[GOERTZEL_FREQS] = {
    200.f, 400.f, 800.f, 1200.f, 2400.f, 4000.f
};

#define FREQ_RATIO_ON       0.008f   /* EMA ratio above which a freq is "active"  */
#define FREQ_RATIO_OFF      0.004f   /* EMA ratio below which a freq is "quiet"   */
#define EMA_ALPHA           0.25f    /* 0.3 = fast response, lower = smoother     */
#define FREQS_NEEDED        1        /* bins that must be active to trigger alarm  */
#define SUSTAIN_FRAMES_ON   2        /* consecutive active frames before ALARM     */
#define SUSTAIN_FRAMES_OFF  8        /* consecutive quiet  frames before CLEAR     */
#define RMS_MIN             0.001f   /* skip frames below this noise floor         */

/* =========================================================================
 * Module-private state  (all lives on Core 1; no mutex required)
 * ====================================================================== */
static float             s_window[FRAME_SAMPLES];
static float             s_audio[FRAME_SAMPLES];
static i2s_chan_handle_t s_rx = NULL;

typedef struct {
    float coeff;
    float cos_omega;
    float sin_omega;
} goertzel_coeff_t;

static goertzel_coeff_t s_goertzel[GOERTZEL_FREQS];
static float            s_freq_ema[GOERTZEL_FREQS];

/* =========================================================================
 * DSP helpers  (identical to original main.c)
 * ====================================================================== */

static void init_hanning(void)
{
    const int n = FRAME_SAMPLES;
    for (int i = 0; i < n; i++) {
        s_window[i] = 0.5f * (1.f - cosf(2.f * (float)M_PI * i / (float)(n - 1)));
    }
}

static void init_goertzel_coeffs(void)
{
    for (int f = 0; f < GOERTZEL_FREQS; f++) {
        float k = roundf(k_target_hz[f] * FRAME_SAMPLES / (float)SAMPLE_RATE_HZ);
        if (k < 1.f) k = 1.f;
        const float omega       = 2.f * (float)M_PI * k / (float)FRAME_SAMPLES;
        s_goertzel[f].coeff     = 2.f * cosf(omega);
        s_goertzel[f].cos_omega = cosf(omega);
        s_goertzel[f].sin_omega = sinf(omega);
    }
}

static float goertzel_power(const float *x, int n, const goertzel_coeff_t *gc)
{
    float s = 0.f, s_prev = 0.f, s_prev2 = 0.f;
    for (int i = 0; i < n; i++) {
        s       = x[i] + gc->coeff * s_prev - s_prev2;
        s_prev2 = s_prev;
        s_prev  = s;
    }
    const float real = s_prev - s_prev2 * gc->cos_omega;
    const float imag = s_prev2 * gc->sin_omega;
    return real * real + imag * imag;
}

static esp_err_t i2s_microphone_init(void)
{
    i2s_chan_config_t chan_cfg = I2S_CHANNEL_DEFAULT_CONFIG(I2S_NUM_AUTO, I2S_ROLE_MASTER);
    chan_cfg.dma_desc_num  = 6;
    chan_cfg.dma_frame_num = 256;

    esp_err_t err = i2s_new_channel(&chan_cfg, NULL, &s_rx);
    if (err != ESP_OK) return err;

    i2s_std_config_t std_cfg = {
        .clk_cfg  = I2S_STD_CLK_DEFAULT_CONFIG(SAMPLE_RATE_HZ),
        .slot_cfg = I2S_STD_PHILIPS_SLOT_DEFAULT_CONFIG(I2S_DATA_BIT_WIDTH_32BIT,
                                                         I2S_SLOT_MODE_MONO),
        .gpio_cfg = {
            .mclk  = I2S_GPIO_UNUSED,
            .bclk  = I2S_MIC_BCLK_GPIO,
            .ws    = I2S_MIC_WS_GPIO,
            .dout  = I2S_GPIO_UNUSED,
            .din   = I2S_MIC_DIN_GPIO,
            .invert_flags = {
                .mclk_inv = false,
                .bclk_inv = false,
                .ws_inv   = false,
            },
        },
    };
    std_cfg.slot_cfg.slot_mask     = I2S_STD_SLOT_LEFT;
    std_cfg.clk_cfg.mclk_multiple = I2S_MCLK_MULTIPLE_384;

    err = i2s_channel_init_std_mode(s_rx, &std_cfg);
    if (err != ESP_OK) {
        i2s_del_channel(s_rx);
        s_rx = NULL;
        return err;
    }
    return i2s_channel_enable(s_rx);
}

static void read_pcm_frame(float *out, int n)
{
    static int32_t raw[FRAME_SAMPLES];
    size_t         bytes_read = 0;
    const size_t   need       = (size_t)n * sizeof(int32_t);

    while (i2s_channel_read(s_rx, raw, need, &bytes_read, pdMS_TO_TICKS(1000)) == ESP_OK) {
        if (bytes_read >= need) break;
    }

    for (int i = 0; i < n; i++) {
        float v  = (float)raw[i] / 2147483648.0f;
        out[i]   = v * s_window[i];
    }
}

/* =========================================================================
 * Helper: push a DroneEvent_t to the shared queue without blocking.
 *
 * AudioTask must NEVER stall — xQueueSend with timeout=0 drops the event
 * if LoRaTask is mid-transmission and the queue is temporarily full.
 * The queue depth (set in main.cpp) is chosen to absorb normal burst rate.
 * ====================================================================== */
static void push_event(DroneEventType type, float ratio, int active, float rms)
{
    DroneEvent_t ev = {
        .type         = type,
        .peak_ratio   = ratio,
        .active_freqs = active,
        .rms          = rms,
        .timestamp_ms = (uint32_t)(xTaskGetTickCount() * portTICK_PERIOD_MS),
    };
    if (xQueueSend(g_drone_event_queue, &ev, 0) != pdTRUE) {
        ESP_LOGW(TAG, "event queue full — dropped 0x%02X", (unsigned)type);
    }
}

/* =========================================================================
 * AudioTask — entry point, pinned to Core 1 by xTaskCreatePinnedToCore()
 * ====================================================================== */
void AudioTask(void *pvParameters)
{
    (void)pvParameters;

    ESP_LOGI(TAG, "AudioTask start (core %d)", xPortGetCoreID());

    init_hanning();
    init_goertzel_coeffs();

    esp_err_t err = i2s_microphone_init();
    if (err != ESP_OK) {
        ESP_LOGE(TAG, "I2S init failed: %s — suspending", esp_err_to_name(err));
        vTaskSuspend(NULL);
        return;
    }
    ESP_LOGI(TAG, "I2S OK — BCLK=%d WS=%d DIN=%d",
             PIN_I2S_BCLK, PIN_I2S_WS, PIN_I2S_DIN);

    int  sustain_on      = 0;
    int  sustain_off     = 0;
    bool alarm           = false;
    int  detection_count = 0;

    for (;;) {
        read_pcm_frame(s_audio, FRAME_SAMPLES);

        /* --- RMS energy gate -------------------------------------------- */
        float sum_sq = 0.f;
        for (int i = 0; i < FRAME_SAMPLES; i++) {
            sum_sq += s_audio[i] * s_audio[i];
        }
        float rms = sqrtf(sum_sq / (float)FRAME_SAMPLES);

        int   active_freqs = 0;
        float freq_ratios[GOERTZEL_FREQS];

        if (rms < RMS_MIN) {
            /* Too quiet — decay EMA and handle sustain-off while silent */
            for (int f = 0; f < GOERTZEL_FREQS; f++) {
                s_freq_ema[f] *= (1.f - EMA_ALPHA);
                freq_ratios[f] = s_freq_ema[f];
            }
            if (alarm) {
                sustain_off++;
                if (sustain_off >= SUSTAIN_FRAMES_OFF) {
                    alarm = false;
                    ESP_LOGI(TAG, "CLEAR (silent)");
                    push_event(DRONE_EVENT_CLEAR, 0.f, 0, rms);
                }
            }
        } else {
            /* --- Goertzel filter bank ----------------------------------- */
            const float denom = sum_sq * (float)FRAME_SAMPLES + 1e-12f;

            for (int f = 0; f < GOERTZEL_FREQS; f++) {
                float r       = goertzel_power(s_audio, FRAME_SAMPLES, &s_goertzel[f]) / denom;
                s_freq_ema[f] = EMA_ALPHA * r + (1.f - EMA_ALPHA) * s_freq_ema[f];
                freq_ratios[f] = s_freq_ema[f];
                if (s_freq_ema[f] > FREQ_RATIO_ON) active_freqs++;
            }

            /* --- Hysteresis state machine ------------------------------- */
            if (!alarm) {
                if (active_freqs >= FREQS_NEEDED) {
                    sustain_on++;
                    sustain_off = 0;
                    if (sustain_on >= SUSTAIN_FRAMES_ON) {
                        alarm = true;
                        detection_count++;
                        ESP_LOGW(TAG, "ALARM #%d: %d/%d freqs active, rms=%.5f",
                                 detection_count, active_freqs, GOERTZEL_FREQS, rms);
                        push_event(DRONE_EVENT_ALARM,
                                   freq_ratios[0],
                                   active_freqs, rms);
                    }
                } else {
                    sustain_on = 0;
                }
            } else {
                int active_off = 0;
                for (int f = 0; f < GOERTZEL_FREQS; f++) {
                    if (freq_ratios[f] > FREQ_RATIO_OFF) active_off++;
                }
                if (active_off < FREQS_NEEDED) {
                    sustain_off++;
                    sustain_on = 0;
                    if (sustain_off >= SUSTAIN_FRAMES_OFF) {
                        alarm = false;
                        ESP_LOGI(TAG, "CLEAR (active_freqs=%d)", active_off);
                        push_event(DRONE_EVENT_CLEAR, freq_ratios[0], active_off, rms);
                    }
                } else {
                    sustain_off = 0;
                }
            }
        }

        /* --- 1 Hz calibration log (only while alarm active) ------------- */
        static int64_t last_cal_us = 0;
        const  int64_t now_us      = esp_timer_get_time();
        if (alarm && now_us - last_cal_us > 1000000LL) {
            ESP_LOGI(TAG, "cal: active=%d/%d [%.3f %.3f %.3f %.3f %.3f %.3f] rms=%.5f",
                     active_freqs, GOERTZEL_FREQS,
                     freq_ratios[0], freq_ratios[1], freq_ratios[2],
                     freq_ratios[3], freq_ratios[4], freq_ratios[5],
                     rms);
            last_cal_us = now_us;
        }

        vTaskDelay(pdMS_TO_TICKS(HOP_MS));
    }
}
