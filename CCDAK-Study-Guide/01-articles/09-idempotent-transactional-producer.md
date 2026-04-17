# Article 9: Idempotent and Transactional Producers — Exactly-Once Semantics

## Why Not Just At-Least-Once?

`acks=all` + `retries > 0` gives you at-least-once delivery. But:

- **Duplicates** occur when a retry succeeds after a prior send that the client *thought* failed (e.g., network glitch before the ACK arrived).
- Order may be **broken** when multiple in-flight requests retry independently.

Idempotent and transactional producers fix these.

## Idempotent Producer

### Mechanism

When `enable.idempotence=true`:

1. On first `send()`, producer issues `InitProducerId` to the transaction coordinator (or to any broker if non-transactional) and gets:
   - **PID** (producer ID, long)
   - **Producer epoch** (short)
2. Each record carries `(PID, epoch, sequence_number_per_partition)`.
3. Broker maintains a **5-element sliding window** of last seen sequences per (PID, partition).
4. On retry:
   - Duplicate sequence → silently ACK.
   - Next expected sequence → append.
   - Gap in sequence → `OutOfOrderSequenceException` (fatal for this producer).

### Guarantees

- **No duplicate records per partition** even across retries.
- **Order preserved per partition** even with `max.in.flight.requests.per.connection=5`.
- **Per-producer-session only**. When the producer restarts (new PID), the broker has no way to recognize the new producer as the same logical writer. Duplicate messages from a restart are possible.

### Requirements (enforced from 3.0+)

- `acks=all`
- `retries > 0` (default MAX)
- `max.in.flight.requests.per.connection ≤ 5`

### Limitations

- Scope is **per partition**. If your transaction crosses partitions, idempotence alone won't deduplicate.
- Scope is **per producer session**. Restarts create a fresh PID.

## Transactional Producer

Transactions extend idempotence with:

- **Atomicity across partitions** — either all writes commit or all abort.
- **Producer fencing** — if two processes share the same `transactional.id`, only the latest one can commit.
- **Exactly-once across a read-process-write cycle** — when combined with a consumer's `isolation.level=read_committed`.

### Transactional API

```java
producer.initTransactions();   // once, at startup

try {
    producer.beginTransaction();
    producer.send(rec1);
    producer.send(rec2);
    producer.sendOffsetsToTransaction(offsets, consumerGroupMetadata);
    producer.commitTransaction();
} catch (ProducerFencedException | OutOfOrderSequenceException | AuthorizationException e) {
    producer.close();   // fatal
} catch (KafkaException e) {
    producer.abortTransaction();
}
```

### The `transactional.id`

- Must be **stable across restarts** for fencing to work.
- Must be **unique per logical producer**. If two processes use the same ID, one is fenced.
- For Kafka Streams, the ID is auto-generated as `application.id + task-id` (one per stream task).

### Fencing

When a producer with `transactional.id=X` calls `initTransactions()`:

1. Transaction coordinator finds any prior record of `X`.
2. Increments the epoch.
3. Any older producer with an earlier epoch is now **fenced** — its commits fail with `ProducerFencedException`.

This prevents **zombie producers** (e.g., a partitioned-off node that comes back and tries to commit an old transaction).

### Transaction Coordinator

Each transactional producer is assigned a coordinator by hashing `transactional.id` to a partition of `__transaction_state`. The broker hosting that partition's leader is the coordinator for this producer. The coordinator:

- Persists PID, epoch, and in-progress partition set in `__transaction_state` (compacted).
- Writes **transaction markers** (COMMIT/ABORT) to every involved partition when the producer commits/aborts.
- Fences zombies on new `initTransactions()`.

### Transaction Markers

Transaction markers are control records — they're invisible to normal consumers but delimit the ranges of records produced within a transaction. They consume offsets (the "hole" in offsets you sometimes see).

With `isolation.level=read_committed`, the consumer skips over aborted records and stops at the **Last Stable Offset (LSO)** — the offset before the first open transaction.

### Transaction Timeout

`transaction.timeout.ms` (default 60s) caps how long a transaction can be open. If exceeded, the coordinator aborts it and fences the producer. Must be ≤ `transaction.max.timeout.ms` on the broker (default 15 minutes).

## Read-Process-Write Pattern

The canonical EOS use case: consume from topic A, process, produce to topic B, commit consumer offsets — all atomically.

```java
consumer.subscribe(List.of("input"));
producer.initTransactions();

while (true) {
    ConsumerRecords<K,V> records = consumer.poll(...);
    producer.beginTransaction();

    for (ConsumerRecord<K,V> rec : records) {
        ProducerRecord<K,V> out = transform(rec);
        producer.send(out);   // to "output"
    }

    Map<TopicPartition, OffsetAndMetadata> offsets = ...;   // from consumer
    producer.sendOffsetsToTransaction(offsets, consumer.groupMetadata());

    producer.commitTransaction();
}
```

Key points:

- Consumer's `enable.auto.commit` must be **false**.
- Consumer's `isolation.level=read_committed`.
- Consumer's group metadata (via `consumer.groupMetadata()`) must be passed to `sendOffsetsToTransaction` — this is what ties the offset commit into the transaction.
- On abort, neither the output records NOR the offset commit take effect.

## Producer Startup Scenarios

| Scenario | What Happens |
|----------|--------------|
| First ever `initTransactions()` for `transactional.id=X` | New PID allocated, epoch = 0 |
| Restart after clean shutdown | Same PID preserved by coordinator, epoch +1 |
| Restart while old producer still alive (split brain) | New epoch fences old one on commit |
| Transaction in-flight from previous incarnation | Coordinator aborts it after timeout |

## EOS Guarantees Summary

| Component | Property |
|-----------|----------|
| Idempotent producer | No duplicates **per partition, per session** |
| Transactional producer | Atomic writes **across partitions, across sessions** (via fencing) |
| `isolation.level=read_committed` | Reader sees only committed transactional data |
| Kafka Streams EOS | End-to-end EOS built on all of the above |

## Common Pitfalls

1. **Reusing `transactional.id`** across multiple active instances: one fences the other repeatedly.
2. **Using idempotence to deduplicate across restarts**: it doesn't — PID changes.
3. **Forgetting `read_committed` on the consumer**: it reads aborted data as if it were real.
4. **`sendOffsetsToTransaction` without `groupMetadata()`**: does not join the offset commit to the txn.
5. **Long-running transactions**: exceed `transaction.timeout.ms` and get aborted + fenced.

## Performance Considerations

Transactions add overhead:
- Every commit writes to `__transaction_state` and places markers in every involved partition.
- Latency typically increases by 10–30 ms per commit.

Best practice: batch many records per transaction, commit every 50–500 ms rather than per-record.

## Config Cheat Sheet (Transactional)

Producer:
```
transactional.id=unique-stable-id
enable.idempotence=true         (implicit)
acks=all                        (implicit)
retries=Integer.MAX_VALUE
max.in.flight.requests.per.connection=5
transaction.timeout.ms=60000
```

Consumer:
```
enable.auto.commit=false
isolation.level=read_committed
```

Broker (typical):
```
transaction.state.log.replication.factor=3
transaction.state.log.min.isr=2
transaction.max.timeout.ms=900000   (15 min)
```

## Exam Pointers

- The **scope of idempotence is per-partition, per-session**. It does NOT cross restarts or partitions.
- Transactions require a **stable `transactional.id`** — volatile/random IDs defeat fencing.
- `ProducerFencedException` is **fatal** — you cannot recover; the producer must exit.
- `sendOffsetsToTransaction` is the glue for read-process-write.
- Consumer must use `isolation.level=read_committed` to honor transaction boundaries.
- `transaction.timeout.ms` must be ≤ broker's `transaction.max.timeout.ms`.
