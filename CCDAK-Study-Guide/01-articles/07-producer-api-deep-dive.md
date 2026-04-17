# Article 7: Producer API Deep Dive

## The Journey of a `producer.send()` Call

Follow a single record from `send()` to acknowledged disk write:

```
┌──────────────────────────────────────────────────────────────┐
│ 1. send(record) called on application thread                 │
│    → serializer(key), serializer(value)                      │
│    → partitioner.partition(topic, key, value, ...)           │
│    → Accumulate in RecordAccumulator (per partition deque)   │
└──────────────────────────────────────────────────────────────┘
                         │ (non-blocking; returns Future)
                         ▼
┌──────────────────────────────────────────────────────────────┐
│ 2. Sender (I/O) thread drains the accumulator                │
│    → groups records by leader broker                         │
│    → constructs ProduceRequest(s) per broker                 │
│    → sends over TCP                                          │
└──────────────────────────────────────────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────────────────┐
│ 3. Broker appends to partition log                           │
│    → Flushes to OS page cache (NOT fsync by default)         │
│    → Replicates to followers (if RF > 1)                     │
│    → Waits for min.insync.replicas if acks=all               │
│    → Sends ProduceResponse                                   │
└──────────────────────────────────────────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────────────────┐
│ 4. Sender marks the Future complete with RecordMetadata      │
│    → callback.onCompletion(metadata, exception) invoked      │
│    → application thread can call get() on Future             │
└──────────────────────────────────────────────────────────────┘
```

## The Two-Thread Model

A `KafkaProducer` instance has:

- **Application threads** calling `send()`. These serialize, partition, and enqueue the record into the `RecordAccumulator`. They do NOT do I/O.
- **One Sender thread** per producer. It wakes on a new batch or on `linger.ms` timeout, bundles batches into `ProduceRequest`, sends them, and processes responses.

This means:
- `send()` is fast; it doesn't block on the network.
- Throughput is bounded by the Sender thread's ability to pack and drain batches.

## The RecordAccumulator

A bounded-size buffer in memory (default `buffer.memory = 32 MB`) that stores pending batches. When it's full:

- `send()` blocks for up to `max.block.ms` (default 60s).
- After timeout, `send()` throws `BufferExhaustedException` (technically `TimeoutException`).

Each partition has its own deque of batches in the accumulator. A batch is closed when:
1. It reaches `batch.size` bytes (default 16 KB).
2. `linger.ms` has elapsed since the first record entered it.
3. The producer is flushed/closed.

## Send Method Variants

```java
// 1. Fire-and-forget (returns a Future you ignore)
producer.send(record);

// 2. Synchronous (wait for ack)
producer.send(record).get();   // blocks

// 3. Asynchronous with callback
producer.send(record, (metadata, exception) -> {
    if (exception != null) { /* handle */ }
    else { /* log metadata.offset(), metadata.partition() */ }
});
```

Patterns:
- Fire-and-forget has **no durability guarantee** even with `acks=all` because you never see the exception.
- Synchronous is simple but limits throughput to one record per round-trip.
- Async with callback is the recommended production pattern.

## ProducerRecord Anatomy

```java
public class ProducerRecord<K, V> {
    String topic;              // required
    Integer partition;         // optional; if set, partitioner is bypassed
    Headers headers;           // optional; list of byte[] headers
    K key;                     // optional (but required for compacted topics!)
    V value;                   // nullable (null = tombstone for compacted topics)
    Long timestamp;            // optional; defaults to System.currentTimeMillis()
}
```

## Key Configurations (Digest)

Details are in the next article. Preview:

| Config | Default | Exam-Critical? |
|--------|---------|----------------|
| `acks` | `all` (since 3.0; was `1` before) | YES |
| `retries` | `Integer.MAX_VALUE` | YES |
| `enable.idempotence` | `true` (since 3.0) | YES |
| `max.in.flight.requests.per.connection` | 5 | YES |
| `delivery.timeout.ms` | 120000 | YES |
| `request.timeout.ms` | 30000 | YES |
| `linger.ms` | 0 | YES |
| `batch.size` | 16384 | YES |
| `compression.type` | `none` | YES |
| `buffer.memory` | 33554432 (32 MB) | YES |
| `max.block.ms` | 60000 | Moderate |
| `max.request.size` | 1048576 (1 MB) | Moderate |
| `transactional.id` | null | YES (for EOS) |

## Idempotence in Brief

With `enable.idempotence=true`:

1. Producer requests a **Producer ID (PID)** via `InitProducerId` RPC.
2. Every record carries: PID, epoch, and a **sequence number** per partition.
3. Broker keeps the last 5 sequences per (PID, partition).
4. If a retry sends a duplicate sequence number, the broker ignores it (returns success).
5. Gaps in sequence numbers cause `OutOfOrderSequenceException`.

**Requirements for `enable.idempotence=true`:**
- `acks=all`
- `retries > 0`
- `max.in.flight.requests.per.connection <= 5`

If you set `enable.idempotence=true` and violate these, since Kafka 3.0 you get a `ConfigException`. Before 3.0, they were silently adjusted.

## Callbacks and Ordering

Callbacks run on the **Sender thread** (not the application thread). Multiple callbacks from the same partition run in offset order.

Across partitions, no ordering is guaranteed.

### Anti-pattern: long work in callbacks

```java
producer.send(record, (md, ex) -> {
    longRunningDbWrite();   // BAD: blocks Sender thread, kills throughput
});
```

Use a separate executor or queue for heavy post-processing.

## Error Classes

The callback receives exceptions in two families:

### Retriable (transient) exceptions
- `NotEnoughReplicasException`
- `NotLeaderForPartitionException`
- `LeaderNotAvailableException`
- `NetworkException`
- `TimeoutException` (sometimes retriable)

With `retries > 0`, the producer retries these automatically.

### Non-retriable (fatal) exceptions
- `SerializationException`
- `RecordTooLargeException`
- `InvalidTopicException`
- `AuthenticationException`
- `AuthorizationException`
- `OutOfOrderSequenceException` (for idempotent producers — indicates a bug)
- `ProducerFencedException` (for transactional producers — your `transactional.id` was reused)

## The Importance of `max.in.flight.requests.per.connection`

With more than 1 in-flight request per connection, retries can reorder messages:

```
Record 1 sent → network failure
Record 2 sent → succeeds
Record 1 retried → succeeds
   RESULT: Record 2 stored at offset N, Record 1 at offset N+1
```

With `enable.idempotence=true`, the broker uses sequence numbers to **preserve order regardless** — up to 5 in-flight are safe.

With idempotence OFF, you must set `max.in.flight.requests.per.connection=1` to preserve order under retries.

| Setting | Order Preserved on Retry? | Throughput |
|---------|---------------------------|------------|
| idempotence=false, max.in.flight=1 | Yes | Low |
| idempotence=false, max.in.flight=5 | No | High |
| idempotence=true, max.in.flight ≤ 5 | Yes (broker enforces) | High |

## Close and Flush

```java
producer.flush();   // block until all pending records are acked (or failed)
producer.close();   // flushes, then releases resources
producer.close(Duration.ofSeconds(5));  // with timeout
```

If you close abruptly (e.g., `kill -9`), any pending records in the accumulator are **lost**. Always drain with `close()` or `flush()`.

## Metrics Worth Knowing

- `record-send-rate` — records per second sent
- `request-latency-avg` — average ProduceRequest latency
- `batch-size-avg` — average batch size (if ≪ `batch.size`, you could increase `linger.ms`)
- `record-error-rate`, `record-retry-rate` — error signals
- `buffer-available-bytes` — free space in RecordAccumulator

## Exam Pointers

- Since Kafka 3.0, `acks=all` and `enable.idempotence=true` are defaults.
- `max.in.flight.requests.per.connection=1` guarantees order without idempotence — but slows throughput.
- `linger.ms=0` means "send immediately"; low latency, low throughput.
- Increasing `linger.ms` and `batch.size` together improves throughput at the cost of added latency.
- `flush()` is a blocking drain — use it before shutdown or transaction commit.
- A long-running callback blocks the Sender thread and cripples throughput — this is a common trap.
