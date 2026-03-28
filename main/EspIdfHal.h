/*
 * EspIdfHal.h — RadioLibHal implementation for pure ESP-IDF 5.x / 6.x
 *
 * RadioLib's component-registry build ships without an ESP-IDF HAL, so we
 * provide one here.  It wraps:
 *   • ESP-IDF SPI master driver  (driver/spi_master.h)
 *   • ESP-IDF GPIO driver        (driver/gpio.h)
 *   • esp_timer                  (esp_timer.h)
 *   • FreeRTOS vTaskDelay        for delay()
 *   • esp_rom_delay_us           for delayMicroseconds()
 */
#pragma once

#include <RadioLib.h>
#include "driver/spi_master.h"
#include "driver/gpio.h"

class EspIdfHal : public RadioLibHal {
public:
    /*
     * sck / miso / mosi are the SPI bus pins.
     * The CS, RST, BUSY, and DIO1 pins are passed to Module() separately and
     * driven by RadioLib through this HAL's pinMode() / digitalWrite() methods.
     */
    EspIdfHal(uint8_t sck, uint8_t miso, uint8_t mosi);

    /* ---- Lifecycle (called by RadioLib Module::init / ~Module) ---- */
    void init() override;
    void term() override;

    /* ---- GPIO ---- */
    void     pinMode(uint32_t pin, uint32_t mode) override;
    void     digitalWrite(uint32_t pin, uint32_t value) override;
    uint32_t digitalRead(uint32_t pin) override;

    /* ---- Interrupts ---- */
    void attachInterrupt(uint32_t interruptNum,
                         void (*interruptCb)(void),
                         uint32_t mode) override;
    void detachInterrupt(uint32_t interruptNum) override;

    /* ---- Timing ---- */
    void          yield() override;
    void          delay(RadioLibTime_t ms) override;
    void          delayMicroseconds(RadioLibTime_t us) override;
    RadioLibTime_t millis() override;
    RadioLibTime_t micros() override;
    long          pulseIn(uint32_t pin, uint32_t state,
                          RadioLibTime_t timeout) override;

    /* ---- SPI ---- */
    void spiBegin() override;
    void spiBeginTransaction() override;
    void spiTransfer(uint8_t *out, size_t len, uint8_t *in) override;
    void spiEndTransaction() override;
    void spiEnd() override;

private:
    const uint8_t        _sck;
    const uint8_t        _miso;
    const uint8_t        _mosi;
    spi_device_handle_t  _spi_device = nullptr;
    bool                 _isr_service_installed = false;
    bool                 _spi_error_logged = false;
};
