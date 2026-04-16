/*
 * gateway_task.cpp — LoRa RX + AES-GCM decrypt + OLED + LED (Core 0)
 *
 * Listens for encrypted packets from Batear detectors.
 * Shows status on SSD1306 OLED, lights LED on ALARM.
 *
 * Board: Heltec WiFi LoRa 32 V3 (ESP32-S3 + SX1262 + SSD1306)
 */

#include "gateway_task.h"
#include "mqtt_task.h"
#include "lora_crypto.h"
#include "lorawan_provision.h"
#include "EspIdfHal.h"
#include "pin_config.h"
#include "oled.h"

#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_log.h"
#include "esp_timer.h"
#include "driver/gpio.h"
#include <RadioLib.h>

static const char *TAG = "gw";

/* LoRa RF — must match detector (freq and sync_word come from NVS at runtime) */
#define LORA_BW_KHZ         125.0f
#define LORA_SF             10
#define LORA_CR             5
#define LORA_TX_DBM         22

#define GW_MAX_CONSECUTIVE_ERRORS  5

/* Per-device state */
typedef struct {
    bool     seen;
    bool     alarm;
    uint16_t last_seq;
} device_state_t;

#define MAX_DEVICES 256
static device_state_t s_devices[MAX_DEVICES];
static uint32_t s_rx_count;
static uint32_t s_reject_count;

/* ---- radio management ---- */

static EspIdfHal *s_hal   = nullptr;
static Module    *s_mod   = nullptr;
static SX1262    *s_radio = nullptr;

static bool gw_radio_init(void)
{
    const lorawan_keys_t *keys = lorawan_get_keys();
    float freq_mhz = keys->lora_freq_khz / 1000.0f;
    uint8_t sync_word = keys->lora_sync_word;

    s_hal   = new EspIdfHal(PIN_LORA_SCK, PIN_LORA_MISO, PIN_LORA_MOSI);
    s_mod   = new Module(s_hal, PIN_LORA_CS, PIN_LORA_DIO1,
                         PIN_LORA_RST, PIN_LORA_BUSY);
    s_radio = new SX1262(s_mod);

    int16_t state = s_radio->begin(freq_mhz, LORA_BW_KHZ, LORA_SF, LORA_CR,
                                    sync_word, LORA_TX_DBM);
    if (state != RADIOLIB_ERR_NONE) {
        ESP_LOGE(TAG, "begin() failed: %d", state);
        return false;
    }
    s_radio->setTCXO(BOARD_LORA_TCXO_V);
    s_radio->setDio2AsRfSwitch(BOARD_LORA_DIO2_AS_RF);

    ESP_LOGI(TAG, "SX1262 ready  freq=%.1f MHz  SF=%d  BW=%.0f kHz  sw=0x%02X",
             freq_mhz, LORA_SF, LORA_BW_KHZ, sync_word);
    return true;
}

static bool gw_radio_reinit(void)
{
    ESP_LOGW(TAG, "attempting radio reinit after consecutive errors");

    delete s_radio; s_radio = nullptr;
    delete s_mod;   s_mod   = nullptr;
    delete s_hal;   s_hal   = nullptr;

    vTaskDelay(pdMS_TO_TICKS(100));
    return gw_radio_init();
}

/* ---- display helpers ---- */

static void display_idle(void)
{
    oled_clear();
    oled_print(0, 0, "BATEAR GATEWAY");
    oled_print(0, 2, "Listening...");
    char line[22];
    snprintf(line, sizeof(line), "rx:%lu bad:%lu",
             (unsigned long)s_rx_count, (unsigned long)s_reject_count);
    oled_print(0, 7, line);
    oled_flush();
}

static void display_event(const lora_plaintext_t *pt, float rssi, float snr)
{
    char line[22];
    oled_clear();
    oled_print(0, 0, "BATEAR GATEWAY");

    snprintf(line, sizeof(line), "Dev %02X: %s",
             pt->device_id,
             pt->event_type == 0x01 ? "!! ALARM !!" : "CLEAR");
    oled_print(0, 2, line);

    snprintf(line, sizeof(line), "RSSI:%d  SNR:%.1f", (int)rssi, snr);
    oled_print(0, 4, line);

    snprintf(line, sizeof(line), "rms:%udB  f0bin:%u",
             pt->rms_db, pt->f0_bin);
    oled_print(0, 5, line);

    snprintf(line, sizeof(line), "seq:%u", pt->seq);
    oled_print(0, 6, line);

    snprintf(line, sizeof(line), "rx:%lu bad:%lu",
             (unsigned long)s_rx_count, (unsigned long)s_reject_count);
    oled_print(0, 7, line);
    oled_flush();
}

static void update_led(void)
{
    bool any = false;
    for (int i = 0; i < MAX_DEVICES; i++) {
        if (s_devices[i].seen && s_devices[i].alarm) { any = true; break; }
    }
    gpio_set_level((gpio_num_t)PIN_LED, any ? 1 : 0);
}

/* ---- task entry ---- */

extern "C" void GatewayTask(void *pvParameters)
{
    (void)pvParameters;
    ESP_LOGI(TAG, "GatewayTask start (core %d)", xPortGetCoreID());

#if BOARD_HAS_VEXT
    gpio_config_t vext_cfg = {};
    vext_cfg.pin_bit_mask = (1ULL << PIN_VEXT);
    vext_cfg.mode = GPIO_MODE_OUTPUT;
    gpio_config(&vext_cfg);
    gpio_set_level((gpio_num_t)PIN_VEXT, 0);
    vTaskDelay(pdMS_TO_TICKS(50));
#endif

    /* OLED */
    oled_init(PIN_OLED_SDA, PIN_OLED_SCL, PIN_OLED_RST);
    oled_clear();
    oled_print(0, 0, "BATEAR GATEWAY");
    oled_print(0, 2, "Initializing...");
    oled_flush();

    /* LED */
    gpio_config_t led_cfg = {};
    led_cfg.pin_bit_mask = (1ULL << PIN_LED);
    led_cfg.mode = GPIO_MODE_OUTPUT;
    gpio_config(&led_cfg);
    gpio_set_level((gpio_num_t)PIN_LED, 0);

    /* LoRa */
    if (!gw_radio_init()) {
        oled_clear();
        oled_print(0, 0, "RADIO FAIL");
        oled_flush();
        vTaskSuspend(NULL);
        return;
    }

    display_idle();

    uint8_t rx_buf[64];
    int consecutive_errors = 0;

    for (;;) {
        int16_t state = s_radio->receive(rx_buf, sizeof(rx_buf));

        if (state == RADIOLIB_ERR_RX_TIMEOUT) {
            consecutive_errors = 0;
            continue;
        }

        if (state != RADIOLIB_ERR_NONE) {
            ESP_LOGW(TAG, "receive error: %d", state);
            s_reject_count++;
            consecutive_errors++;
            if (consecutive_errors >= GW_MAX_CONSECUTIVE_ERRORS) {
                if (gw_radio_reinit()) {
                    consecutive_errors = 0;
                    display_idle();
                }
            }
            vTaskDelay(pdMS_TO_TICKS(100));
            continue;
        }

        consecutive_errors = 0;

        size_t len  = s_radio->getPacketLength();
        float  rssi = s_radio->getRSSI();
        float  snr  = s_radio->getSNR();

        if (len != sizeof(lora_packet_t)) {
            s_reject_count++;
            display_idle();
            continue;
        }

        lora_plaintext_t pt;
        const uint8_t *net_key = lorawan_get_keys()->app_key;
        if (!lora_decrypt(net_key, reinterpret_cast<lora_packet_t *>(rx_buf), &pt)) {
            ESP_LOGW(TAG, "decrypt FAILED — wrong key or forged");
            s_reject_count++;
            display_idle();
            continue;
        }

        device_state_t *dev = &s_devices[pt.device_id];
        if (dev->seen && pt.seq <= dev->last_seq) {
            ESP_LOGW(TAG, "REPLAY dev=0x%02X seq=%u", pt.device_id, pt.seq);
            s_reject_count++;
            display_idle();
            continue;
        }

        s_rx_count++;
        dev->seen     = true;
        dev->last_seq = pt.seq;
        dev->alarm    = (pt.event_type == 0x01);

        ESP_LOGI(TAG, "dev=0x%02X %s seq=%u f0bin=%u rms=%udB RSSI=%.0f SNR=%.1f",
                 pt.device_id, dev->alarm ? "ALARM" : "CLEAR",
                 pt.seq, pt.f0_bin, pt.rms_db, rssi, snr);

        update_led();
        display_event(&pt, rssi, snr);

        if (g_mqtt_event_queue) {
            MqttEvent_t mev = {};
            mev.device_id = pt.device_id;
            mev.alarm     = (pt.event_type == 0x01);
            mev.rssi      = rssi;
            mev.snr       = snr;
            mev.rms_db    = pt.rms_db;
            mev.f0_bin    = pt.f0_bin;
            mev.seq       = pt.seq;
            if (xQueueSend(g_mqtt_event_queue, &mev, 0) != pdTRUE) {
                ESP_LOGW(TAG, "MQTT queue full — event dropped");
            }
        }
    }
}
