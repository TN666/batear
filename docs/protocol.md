# LoRa Packet Protocol

AES-128-GCM encrypted, **36 bytes on the wire**:

```
[4B nonce] [16B ciphertext] [16B GCM auth tag]
```

The 4-byte nonce is the packet sequence number in little-endian. The 12-byte GCM IV is assembled on both ends from `[8B key prefix][4B nonce]`, so the key doubles as an implicit IV salt — forging a valid packet requires knowing the full network key.

## Plaintext format (16 bytes)

| Offset | Size | Field | Notes |
|:---|:---|:---|:---|
| 0 | 2 | `seq` | Monotonic per-detector packet counter; also the GCM nonce |
| 2 | 1 | `device_id` | 0–255, unique per detector |
| 3 | 1 | `event_type` | `0x00` CLEAR, `0x01` ALARM, `0x02` TELEMETRY (heartbeat) |
| 4 | 1 | `f0_bin` | Harmonic fundamental bin index (`0` on heartbeat) |
| 5 | 1 | `rms_db` | Frame RMS, dBFS + 96 offset (`0` on heartbeat) |
| 6 | 1 | `vbat_cv` | Battery voltage: `V = 2.50 + vbat_cv × 0.01`, range 2.50–5.05 V |
| 7 | 1 | `fw_major` | Parsed from `esp_app_get_description()` |
| 8 | 1 | `fw_minor` | |
| 9 | 1 | `fw_patch` | |
| 10 | 2 | `uptime_min` | Minutes since boot, clamped to 65535 (~45 days) |
| 12 | 2 | `free_heap_kb` | `esp_get_free_heap_size() / 1024` |
| 14 | 1 | `tx_fail_count` | Monotonic local TX failure counter, clamped to 255 |
| 15 | 1 | `flags` | Bit 0 = low battery (<3.4 V), bit 1 = USB present (reserved) |

Every packet type (CLEAR / ALARM / TELEMETRY) carries the full 16-byte plaintext. Alarm/clear events piggyback telemetry so Home Assistant gets a fresh battery/heap/uptime reading on every state transition, at zero extra airtime.

## Event delivery

### Alarm and clear events

Sent the instant the audio state machine transitions between SAFE and ALARM. These events are latency-sensitive and get **one local retry** on a randomised 150–300 ms backoff if `SX1262->transmit()` returns a local error (SPI busy, TCXO not settled, etc.). The retry reuses the **same `seq` and the same ciphertext**, so if the first packet actually made it over the air but was mis-reported locally, the gateway's replay counter dedupes the duplicate.

### Telemetry heartbeat

Sent every `CONFIG_BATEAR_TELEMETRY_HEARTBEAT_MIN` minutes (default **30**) during silent periods, with a **±10% uniform jitter** applied per cycle so a fleet of detectors booted together desynchronises instead of colliding on shared airtime.

Heartbeats are **fire-and-forget** — no retry. The next interval carries a fresh snapshot, so retrying would only waste airtime and risk correlated collisions with the main heartbeat wave.

## No ACK, by design

The gateway is a passive receiver. There is no PHY-level acknowledgement:

- `transmit()=OK` only guarantees the bits left the SX1262. The detector cannot know whether the packet was received, decrypted, or dropped in flight.
- Adding ACKs would triple the network's airtime (detector TX → gateway TX ACK → detector RX window), block the gateway from hearing other nodes during its TX burst, and scale poorly past a handful of detectors.
- Instead, **idempotency and reliability come from the sequence counter**: the gateway tracks `last_seq` per detector and discards any packet whose `seq <= last_seq`. Retried packets that arrive twice are dedup'd; a permanently lost packet is covered by the next state transition (for alarm/clear) or the next heartbeat (for telemetry).

## Airtime budget

At SF10 / BW125 / CR4/5 the 36-byte packet is ~494 ms on air. The default 30 min heartbeat puts each detector at ~1 s/hour of TX time (0.028% duty cycle), leaving generous headroom for the EU 868 MHz 1%/hour cap and essentially unlimited room on the US/AS 915 MHz ISM bands.

## Security features

- **Sequence counter** prevents replay attacks and deduplicates retries.
- **GCM auth tag** ensures integrity and authenticity — a tampered or forged packet fails the tag check and is dropped.
- **Sync word** provides RF-level channel isolation so neighbouring batear networks (or unrelated LoRa traffic with a different sync word) never reach the decrypt stage.
