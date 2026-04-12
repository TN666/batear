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

## Gateway

| Component | Notes |
|:---|:---|
| Heltec WiFi LoRa 32 V3 / V4 | Uses on-board SX1262, SSD1306 OLED, and LED |

No external wiring needed — everything is on-board.

