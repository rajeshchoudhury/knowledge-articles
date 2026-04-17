# Article 10: Consumer API Deep Dive

## The Poll Loop

The central abstraction of a Kafka consumer is the **poll loop**:

```java
KafkaConsumer<String,String> consumer = new KafkaConsumer<>(props);
consumer.subscribe(List.of("orders"));

try {
    while (running) {
        ConsumerRecords<String,String> records = consumer.poll(Duration.ofMillis(100));
        for (ConsumerRecord<String,String> rec : records) {
            process(rec);
        }
        consumer.commitSync();
    }
} finally {
    consumer.close();
}
```

`poll()` does many things:

1. If first call: runs the group protocol (`JoinGroup`, `SyncGroup`) — assigns partitions.
2. Sends `Heartbeat` on a background thread.
3. Fetches records from the brokers (may trigger `Fetch` if buffer is low).
4. Runs rebalance listeners if a rebalance is in progress.
5. Auto-commits offsets (if `enable.auto.commit=true`).
6. Returns the buffered records.

**`poll()` is the lifeline.** Skipping it for too long makes the consumer appear dead to the coordinator.

## Subscribe vs Assign

Two ways to get partitions:

### `subscribe(topics)` — Dynamic Assignment via Consumer Groups

- Consumer joins a group (identified by `group.id`).
- The group coordinator assigns partitions across group members.
- Rebalances happen on member join/leave.
- Offsets are committed to `__consumer_offsets` per group.

### `assign(partitions)` — Manual Assignment

- Consumer directly specifies `TopicPartition` objects to consume.
- **No group coordination, no rebalance, no auto-commit**.
- Used for specialized cases: static assignments, offset reprocessing, Kafka Connect source task logic.

You cannot use both on the same consumer.

## Consumer Groups

A **consumer group** is a set of consumers sharing the load of a topic:

- Each partition is assigned to **exactly one consumer** in the group.
- If `numConsumers > numPartitions`, extras are **idle**.
- A new consumer joining triggers a **rebalance**.
- Different groups are independent — same topic consumed in parallel by multiple groups yields independent offsets.

## ConsumerRecord Anatomy

```java
public class ConsumerRecord<K,V> {
    String topic;
    int partition;
    long offset;
    long timestamp;
    TimestampType timestampType;   // CREATE_TIME or LOG_APPEND_TIME
    Headers headers;
    K key;
    V value;
    int serializedKeySize;
    int serializedValueSize;
    Optional<Integer> leaderEpoch;
}
```

## Background Thread vs Main Thread

A `KafkaConsumer` has two threads:

- **Main thread** (yours) — calls `poll()`, `commitSync()`, `close()`.
- **Heartbeat thread** (internal) — sends heartbeats every `heartbeat.interval.ms` (default 3s) to the group coordinator.

**KafkaConsumer is NOT thread-safe.** Never share a single consumer across threads. If you need parallel processing within a JVM, either:

- Use multiple consumers each with its own group membership, OR
- Use a single consumer and dispatch records to a thread pool (carefully managing commit semantics).

## Three Timeouts That Matter

| Config | Default | Meaning |
|--------|---------|---------|
| `session.timeout.ms` | 45000 | Time since last heartbeat before coordinator marks consumer dead |
| `heartbeat.interval.ms` | 3000 | How often background thread heartbeats |
| `max.poll.interval.ms` | 300000 (5 min) | Max time between `poll()` calls |

- If the **heartbeat** thread can't reach the coordinator for `session.timeout.ms`, consumer is removed.
- If the **main** thread takes longer than `max.poll.interval.ms` between polls (e.g., long processing inside the loop), the consumer **leaves the group** and triggers a rebalance — even though heartbeats are still going.

The second case is a subtle killer. If your processing is slow:

1. Raise `max.poll.interval.ms`, OR
2. Lower `max.poll.records` so each batch is smaller, OR
3. Process asynchronously and decouple from the poll loop.

### Rule of Thumb

```
heartbeat.interval.ms ≈ session.timeout.ms / 3
```

## Fetch Configuration

| Config | Default | Purpose |
|--------|---------|---------|
| `fetch.min.bytes` | 1 | Broker waits until this much data is available |
| `fetch.max.bytes` | 52428800 (50 MB) | Per-fetch response size limit |
| `max.partition.fetch.bytes` | 1048576 (1 MB) | Per-partition response limit |
| `fetch.max.wait.ms` | 500 | Max wait time to accumulate `fetch.min.bytes` |
| `max.poll.records` | 500 | Max records returned per poll |

### The Fetch Loop

Independently of poll, the consumer maintains a **fetch buffer**:

- The consumer issues fetch requests proactively to keep the buffer full.
- `poll()` returns up to `max.poll.records` from the buffer.

If your processing is slow, the buffer may saturate, and the consumer sends fewer fetch requests — which is fine.

## `fetch.min.bytes` Tuning

| Setting | Effect |
|---------|--------|
| 1 | Low latency; records flow immediately |
| Larger (e.g., 1 MB) | Bigger batches, higher throughput, higher latency |

Pair with `fetch.max.wait.ms` as a safety timeout so brokers don't wait forever.

## Offset Reset

`auto.offset.reset`: what to do when there is no committed offset for the group:

- `earliest` — start at the beginning of the partition.
- `latest` (default) — start from the end, skipping old messages.
- `none` — throw an exception.

**Critical:** This applies only when there is NO committed offset. Once offsets exist, they take precedence.

## Consumer Position vs Committed Offset

- **Position** — the offset the consumer will next fetch. In-memory, per consumer.
- **Committed offset** — the offset persisted in `__consumer_offsets`. Survives restarts.

A restart without a commit causes reprocessing from the last committed offset.

## Seeking

```java
consumer.seek(partition, offset);
consumer.seekToBeginning(partitions);
consumer.seekToEnd(partitions);
```

After a `seek()`, the next `poll()` starts from the new position.

**Gotcha:** `seek()` on a partition you're not assigned to throws `IllegalStateException`. If you've just `subscribe()`d, you must call `poll()` at least once to trigger assignment before seeking.

### Seeking by Timestamp

```java
Map<TopicPartition, Long> query = Map.of(tp, System.currentTimeMillis() - 3600_000L);
Map<TopicPartition, OffsetAndTimestamp> offsets = consumer.offsetsForTimes(query);
consumer.seek(tp, offsets.get(tp).offset());
```

Kafka returns the offset of the earliest record with timestamp >= the queried time.

## Pause and Resume

```java
consumer.pause(partitions);
consumer.resume(partitions);
```

While paused, `poll()` does not return records for those partitions. Heartbeats continue. Use this to throttle specific partitions (e.g., slow downstream for one customer).

## Wakeup

To cleanly stop a consumer from another thread:

```java
consumer.wakeup();   // causes the next poll() to throw WakeupException
```

Common pattern:

```java
Runtime.getRuntime().addShutdownHook(new Thread(consumer::wakeup));
```

Catch `WakeupException` outside the poll loop and call `close()`.

## Consumer Metrics Worth Knowing

- `records-consumed-rate` — records/sec
- `records-lag-max` — largest lag across assigned partitions
- `fetch-rate` — fetch requests/sec
- `commit-latency-avg`
- `time-between-poll-avg` — your processing duration

## Exam Pointers

- `poll()` is the only way to get records. You must call it regularly.
- `session.timeout.ms` times out **heartbeats**; `max.poll.interval.ms` times out **processing**.
- `auto.offset.reset` only kicks in when no committed offset exists.
- KafkaConsumer is **not thread-safe**.
- **Extra consumers** in a group (beyond partition count) are idle — this is a common trap.
- `subscribe` + `assign` are mutually exclusive.
- `group.id` is required for `subscribe`; not required for `assign` unless you want to commit offsets.
