/*
 * pin_config.h — board-specific GPIO and hardware trait definitions
 *
 * All board-specific constants live here, selected by BATEAR_BOARD Kconfig.
 * No other source file should hard-code pin numbers or board constants.
 *
 * To add a new board:
 *   1. Kconfig.projbuild  — add a config entry under BATEAR_BOARD
 *   2. This file           — add an #elif block with all PIN_* and BOARD_* macros
 *   3. sdkconfig.detector / sdkconfig.gateway — set board + flash size
 *   4. Build               — use `set-target <BOARD_IDF_TARGET>` for the chip
 *   See README.md "Adding a New Board" for the full guide.
 */
#pragma once

/* =====================================================================
 * Board: Heltec WiFi LoRa 32 V3 / V4  (ESP32-S3 + SX1262 + SSD1306)
 * =====================================================================
 *
 * V4 is pin-compatible with V3 (adds GC1109 FEM, 16 MB flash, solar
 * input).  The same GPIO map works for both boards.
 *
 * Occupied by on-board hardware — do NOT use for I2S:
 *   GPIO 8..14  — SX1262 SPI + control
 *   GPIO 17,18,21 — OLED I2C + RST
 *   GPIO 19,20  — USB
 *   GPIO 35     — LED
 *   GPIO 36     — Vext power
 *   GPIO 43,44  — UART0
 *
 * Free pins for I2S mic:
 *   GPIO 2..7, 26, 33..34, 37..42, 45..48
 * ===================================================================== */
#if defined(CONFIG_BATEAR_BOARD_HELTEC_V3) || defined(CONFIG_BATEAR_BOARD_HELTEC_V4)

#define BOARD_IDF_TARGET    "esp32s3"
#define BOARD_FLASH_SIZE    "8MB"

/* I2S microphone (ICS-43434) */
#define PIN_I2S_BCLK     4
#define PIN_I2S_WS       5
#define PIN_I2S_DIN      6

/* LoRa SX1262 SPI — fixed on-board wiring */
#define PIN_LORA_SCK     9
#define PIN_LORA_MISO   11
#define PIN_LORA_MOSI   10
#define PIN_LORA_CS      8
#define PIN_LORA_DIO1   14
#define PIN_LORA_RST    12
#define PIN_LORA_BUSY   13

/* Gateway peripherals */
#define PIN_OLED_SDA    17
#define PIN_OLED_SCL    18
#define PIN_OLED_RST    21
#define PIN_LED         35
#define PIN_VEXT        36
#define BOARD_HAS_VEXT   1
#define BOARD_HAS_OLED   1

/* LoRa RF traits */
#define BOARD_LORA_TCXO_V       1.8f
#define BOARD_LORA_DIO2_AS_RF   true

/* =====================================================================
 * Add new boards here.  Example:
 *
 * #elif defined(CONFIG_BATEAR_BOARD_TTGO_LORA32_V21)
 *   #define BOARD_IDF_TARGET  "esp32"
 *   #define BOARD_FLASH_SIZE  "4MB"
 *   #define PIN_I2S_BCLK   26
 *   ...
 *   #define BOARD_HAS_VEXT  0
 *   #define BOARD_LORA_TCXO_V      0.0f
 *   #define BOARD_LORA_DIO2_AS_RF  false
 * ===================================================================== */

#else
#error "No board selected — set BATEAR_BOARD in menuconfig or sdkconfig"
#endif

/* -------------------------------------------------------------------
 * LoRa network config (board-independent)
 * ----------------------------------------------------------------- */

#define _HEX_NIBBLE(c) \
    (((c) >= '0' && (c) <= '9') ? ((c) - '0') : \
     ((c) >= 'A' && (c) <= 'F') ? ((c) - 'A' + 10) : \
     ((c) >= 'a' && (c) <= 'f') ? ((c) - 'a' + 10) : 0)

#define _HEX_BYTE(s, i) \
    (uint8_t)((_HEX_NIBBLE((s)[2*(i)]) << 4) | _HEX_NIBBLE((s)[2*(i)+1]))

#define BATEAR_NET_KEY { \
    _HEX_BYTE(CONFIG_BATEAR_NET_KEY, 0), _HEX_BYTE(CONFIG_BATEAR_NET_KEY, 1), \
    _HEX_BYTE(CONFIG_BATEAR_NET_KEY, 2), _HEX_BYTE(CONFIG_BATEAR_NET_KEY, 3), \
    _HEX_BYTE(CONFIG_BATEAR_NET_KEY, 4), _HEX_BYTE(CONFIG_BATEAR_NET_KEY, 5), \
    _HEX_BYTE(CONFIG_BATEAR_NET_KEY, 6), _HEX_BYTE(CONFIG_BATEAR_NET_KEY, 7), \
    _HEX_BYTE(CONFIG_BATEAR_NET_KEY, 8), _HEX_BYTE(CONFIG_BATEAR_NET_KEY, 9), \
    _HEX_BYTE(CONFIG_BATEAR_NET_KEY, 10), _HEX_BYTE(CONFIG_BATEAR_NET_KEY, 11), \
    _HEX_BYTE(CONFIG_BATEAR_NET_KEY, 12), _HEX_BYTE(CONFIG_BATEAR_NET_KEY, 13), \
    _HEX_BYTE(CONFIG_BATEAR_NET_KEY, 14), _HEX_BYTE(CONFIG_BATEAR_NET_KEY, 15), \
}
