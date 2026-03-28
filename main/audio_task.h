/*
 * audio_task.h — AudioTask declaration (pinned to Core 1)
 */
#pragma once

#ifdef __cplusplus
extern "C" {
#endif

/*
 * Entry point for the audio engine task.
 * Launched via xTaskCreatePinnedToCore() in main.cpp.
 * pvParameters is unused (pass NULL).
 */
void AudioTask(void *pvParameters);

#ifdef __cplusplus
}
#endif
