# Hardware

## Detector

| Component | Notes |
|:---|:---|
| Heltec WiFi LoRa 32 V3 / V4 | ESP32-S3 + SX1262 on-board |
| ICS-43434 I2S MEMS microphone | 3.3 V, L/R → GND (left channel) |

### Wiring (ICS-43434 → Heltec V3 / V4)

| ICS-43434 | GPIO | Function |
|:---|:---|:---|
| VDD | 3.3V | Power |
| GND | GND | Ground |
| SCK | 4 | I2S bit clock (BCLK) |
| WS | 5 | I2S word select (LRCLK) |
| SD | 6 | I2S data input (DIN) |
| L/R | GND | Left channel select |

### Battery monitoring (optional)

Heltec V3 / V4 ship with an on-board LiPo jack, charger, and a resistor divider that taps VBAT onto **GPIO1 (ADC1_CH0)**, gated by **GPIO37 (ADC_Ctrl, active low)**. The firmware drives the gate low only during a ~2 ms measurement window on every LoRa TX, so the divider's ~100 µA current drain is effectively eliminated between reads.

No extra wiring is required — plug a 1S LiPo into the JST connector and the detector reports `battery_v` (plus a low-battery flag below 3.4 V) in every telemetry packet. Boards without this divider can simply leave `BOARD_HAS_VBAT` at `0` in `pin_config.h` and the battery module compiles down to no-ops (readings are reported as 0 V).

## Gateway

| Component | Notes |
|:---|:---|
| Heltec WiFi LoRa 32 V3 / V4 | Uses on-board SX1262, SSD1306 OLED, and LED |

No external wiring needed — everything is on-board.

