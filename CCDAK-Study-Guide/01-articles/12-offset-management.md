# Article 12: Offset Management

Mastering offsets is the key to correctness. The exam asks many scenario questions where the right answer hinges on *when* an offset is committed.

## Offsets at a Glance

- **Offset** — Monotonically increasing integer per partition.
- **Current Position** — Offset the consumer will fetch next. In-memory.
- **Committed Offset** — Offset stored in `__consumer_offsets` for the group.
- **Log Start Offset** — Earliest offset still retained in the log.
- **Log End Offset (LEO)** — One past the last record.
- **High Watermark (HW)** — Highest offset replicated to all ISR members.
- **Last Stable Offset (LSO)** — HW minus any open transactions (relevant for `read_committed`).

## The `__consumer_offsets` Topic

- 50 partitions by default (config: `offsets.topic.num.partitions`).
- Replication factor: 3 by default (`offsets.topic.replication.factor`).
- Cleanup policy: `compact`.
- Key: `(group, topic, partition)` encoded.
- Value: `(offset, metadata, timestamp, leader_epoch)`.

Each commit is an append; compaction keeps the latest offset per key.

**Exam trap:** On a single-broker dev cluster, `offsets.topic.replication.factor=3` is invalid — the topic creation fails. Lower it to 1 for dev.

## Commit Modes

### Auto-commit

```
enable.auto.commit=true
auto.commit.interval.ms=5000
```

The consumer's background thread commits the current position **every 5 seconds**. Committed offset = offset of the record AFTER the last one returned by `poll()`.

**Risk:** You commit before processing. If the consumer crashes after commit but before processing completes, you lose data. This is at-most-once-ish.

**More common problem:** on rebalance, records already committed but not yet processed by anyone are skipped.

**When to use:** simple, non-critical pipelines where occasional loss is acceptable.

### Manual Sync Commit

```java
consumer.commitSync();   // commits the offsets returned by the last poll()
```

Blocks until broker confirms. Retries on retriable errors automatically.

- **commitSync()** commits the offsets of *the last records returned by poll()*, not the current position of the consumer.
- You typically call this after processing is complete.

### Manual Async Commit

```java
consumer.commitAsync((offsets, exception) -> {
    if (exception != null) log.error(...);
});
```

Non-blocking. Does **not retry** on failure (retrying could commit a lower offset after a higher one succeeded).

Combine:

```java
try {
    while (running) {
        records = consumer.poll(...);
        process(records);
        consumer.commitAsync();
    }
} finally {
    try {
        consumer.commitSync();   // final sync commit before exit
    } finally {
        consumer.close();
    }
}
```

### Explicit Offsets

```java
Map<TopicPartition, OffsetAndMetadata> offsets = Map.of(
    new TopicPartition("orders", 0), new OffsetAndMetadata(1234L)
);
consumer.commitSync(offsets);
```

The committed value is the offset of the **next** record to consume — one past the last one you processed.

## Committing Inside a Transaction

For exactly-once read-process-write, commit via the producer, not the consumer:

```java
producer.sendOffsetsToTransaction(offsets, consumer.groupMetadata());
```

This folds the offset commit into the transaction: if the commit fails, the output records also don't commit.

## Storing Offsets Externally

For full EOS control, you can store offsets in the same database where you write processed records:

```
consumer.subscribe(topics, new ConsumerRebalanceListener() {
    onPartitionsAssigned: for each partition, read offset from DB, consumer.seek(partition, offset)
    onPartitionsRevoked: nothing (DB already has the offset)
});
while (true) {
    records = consumer.poll(...);
    BEGIN TXN
      for (rec : records) write to DB
      write offsets to DB
    COMMIT TXN
}
```

Here, offsets and data are committed together — the consumer never commits to Kafka.

## `auto.offset.reset` Revisited

| Value | Behavior |
|-------|----------|
| `earliest` | First fetch starts at log-start (0 or compacted start) |
| `latest` (default) | First fetch starts at log-end (records produced in the future) |
| `none` | `NoOffsetForPartitionException` thrown |

Applies ONLY when there is no committed offset. Once any offset exists for the group, this is ignored.

**Mistake:** Developers believe `auto.offset.reset=earliest` reprocesses everything on every restart. It does not — only on the very first join, or after `offsets.retention.minutes` expires.

## Offset Retention

Offsets expire after `offsets.retention.minutes` (default 7 days). If a consumer group is inactive for longer, its offsets are deleted; on reconnect, `auto.offset.reset` kicks in.

## Common Patterns

### 1. At-least-once: commit AFTER processing

```java
records = consumer.poll();
process(records);
consumer.commitSync();   // duplicates possible if crash after process, before commit
```

### 2. At-most-once: commit BEFORE processing

```java
records = consumer.poll();
consumer.commitSync();   // commit first
process(records);        // if crash now, records are lost
```

### 3. Exactly-once: external state + transactional write

Use `sendOffsetsToTransaction` (Kafka-to-Kafka) or store offsets in the sink DB (Kafka-to-DB).

## Batch Commit vs Per-Record Commit

Committing per record is safe but slow. Typical pattern:

```java
int processed = 0;
for (ConsumerRecord rec : records) {
    process(rec);
    processed++;
    if (processed % 100 == 0) {
        consumer.commitSync();
    }
}
consumer.commitSync();   // final flush
```

## `seek()` and Offset Reset

`seek()` only changes the *in-memory* position. It is not persisted until the next commit. If the consumer restarts without committing, it returns to the stored offset.

## Offset Inspection CLI

```bash
kafka-consumer-groups --bootstrap-server localhost:9092 --describe --group billing

GROUP    TOPIC   PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG  CONSUMER-ID  HOST  CLIENT-ID
billing  orders  0          4782            4900            118  c1-abc...    ...   consumer-1
```

- `CURRENT-OFFSET` — last committed offset.
- `LOG-END-OFFSET` — end of the partition.
- `LAG` = `LOG-END-OFFSET - CURRENT-OFFSET`.

## Reset Offsets CLI

```bash
kafka-consumer-groups --bootstrap-server localhost:9092 \
  --group billing --topic orders \
  --reset-offsets --to-earliest --execute

--to-latest                     # end of log
--to-earliest                   # start of log
--to-offset 1000                # specific offset
--to-datetime 2025-01-01T00:00:00.000
--shift-by -500                 # relative shift
```

The group must have **no active members** for a reset to succeed.

## Exam Pointers

- `commitSync()` commits offsets for records returned by the **latest** `poll()`.
- `commitAsync()` does NOT retry on failure.
- `auto.offset.reset` is only consulted when NO committed offset exists.
- Offsets are stored per group in `__consumer_offsets` (compacted topic).
- Offsets expire after 7 days of group inactivity by default.
- `seek()` does not commit — it only changes the in-memory position.
- `sendOffsetsToTransaction` ties the offset commit into the producer transaction (the EOS glue).
- Extra consumers in a group don't get partitions but DO commit nothing.
