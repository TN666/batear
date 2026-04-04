/*
 * mqtt_task.h — WiFi + MQTT + Home Assistant discovery (gateway only)
 *
 * MqttTask runs on Core 1, receives detection events from
 * GatewayTask via a FreeRTOS queue and publishes to MQTT.
 */
#pragma once

#include <stdint.h>
#include <stdbool.h>
#include "freertos/FreeRTOS.h"
#include "freertos/queue.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
    uint8_t  device_id;
    bool     alarm;
    float    rssi;
    float    snr;
    uint8_t  rms_db;
    uint8_t  f0_bin;
    uint16_t seq;
} MqttEvent_t;

/* Queue populated by GatewayTask, consumed by MqttTask. */
extern QueueHandle_t g_mqtt_event_queue;

void MqttTask(void *pvParameters);

#ifdef __cplusplus
}
#endif
