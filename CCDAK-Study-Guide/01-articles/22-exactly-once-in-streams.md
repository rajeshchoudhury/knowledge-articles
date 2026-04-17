# Article 22: Exactly-Once Semantics in Kafka Streams

## The Guarantee

End-to-end exactly-once in Kafka Streams means:

> For every input record read from Kafka, every derived output record is written to Kafka, every state update is applied, and the input offset is committed — **all or nothing**.

Crashes, restarts, and rebalances do not produce duplicates or lose data.

## Three Guarantee Levels

`processing.guarantee` property:

| Value | Description |
|-------|-------------|
| `at_least_once` (default) | Records may be processed more than once on failure. Output may have duplicates. |
| `exactly_once_v2` (since 2.5+) | End-to-end EOS using transactional producers across all tasks. Replaces the older `exactly_once`. |
| `exactly_once` (legacy) | EOS v1. Requires one producer per task; less efficient. Superseded by v2. |

**Always use `exactly_once_v2` for EOS in production.**

## How EOS v2 Works Under the Hood

EOS in Streams sits on top of Kafka's transactional producer:

1. **One shared producer per stream thread** (EOS v2); in v1 it was one per task (expensive).
2. Producer has a stable `transactional.id` of the form `<application.id>-<stream-thread-id>-<epoch>`.
3. At poll:
   - `beginTransaction()`.
4. For each record:
   - Process (may update state stores, producing changelog records).
   - Emit downstream records.
5. At commit (every `commit.interval.ms = 100ms` for EOS, 30000ms default for at-least-once):
   - Write consumer offsets via `sendOffsetsToTransaction(offsets, consumer.groupMetadata())`.
   - `commitTransaction()`.

On crash:
- The transaction is aborted by the coordinator after `transaction.timeout.ms`.
- A new instance picks up the task; the new producer fences the old one via a higher epoch.
- Any partially-written output records are invisible to `isolation.level=read_committed` consumers.

## Requirements

To enable EOS:

1. `processing.guarantee=exactly_once_v2`
2. Brokers: minimum version **2.5** for v2 (2.5+ all functions required; Confluent platform 5.5+).
3. Brokers must have `__transaction_state` topic with `min.insync.replicas=2` and RF=3.
4. `commit.interval.ms` is automatically set to 100 ms when EOS is enabled.
5. Downstream consumers must use `isolation.level=read_committed` to honor transaction boundaries.

## What EOS Does NOT Cover

- **Side effects in user code**: database calls, HTTP calls, etc. are NOT atomic with Kafka writes. If you `processor.process()` calls `database.insert()`, a crash could leave the DB inconsistent even with EOS enabled.
- **External state**: if you maintain state outside RocksDB, it isn't transactional.

For Kafka-to-Database EOS, you need a sink connector with idempotent writes or a transaction manager like Kafka Connect with `dataloss=none` and a compatible sink.

## Why EOS v2 Is Better Than v1

EOS v1 used one transactional producer **per task**. In a large application with many tasks, this meant:
- Thousands of producers per JVM.
- Thousands of transaction coordinators.
- Extremely high overhead.

EOS v2 uses **one producer per stream thread**. The transactions span multiple tasks' output records but commit atomically — because they're all on the same producer.

This was enabled by KIP-447 (fetch-from-follower support for rebalances). It's safe because:
- A rebalance ends the current transaction cleanly.
- The next transaction starts on the new task assignment.

## The Standby Replica Problem

With EOS, a standby replica must not produce downstream records or commit offsets — it only updates its local copy of the state store. Streams handles this transparently.

When a standby is promoted, it takes over transaction ownership; the old owner is fenced.

## Interaction with Caching

The Streams cache flushes on commit (every 100 ms in EOS). This means:
- Downstream emissions happen at ~100 ms intervals, not per record.
- If downstream consumers see "bursts", this is the reason.

For lower latency, reduce `commit.interval.ms` (but not below ~30 ms practically).

## Idempotent vs Transactional

| Level | Guarantees |
|-------|-----------|
| Idempotent producer | No duplicates per partition, per session |
| Transactional producer | Atomic across partitions, across sessions |
| EOS v2 in Streams | End-to-end atomic: input offsets + state changelogs + output records |

## Common Traps

1. **EOS without `isolation.level=read_committed` downstream** → consumers see aborted records. Rare in Streams topologies (other sub-topologies in the same app are Streams and read correctly), but external consumers must be configured correctly.
2. **EOS with side effects in user code** → kinds of "partial work" on failure.
3. **Setting `processing.guarantee=exactly_once_v2` on a < 2.5 broker** → falls back or fails.
4. **Forgetting that EOS lowers throughput by ~10-30%** due to per-100ms transaction overhead.

## Configuration Example

```properties
application.id=payment-pipeline
bootstrap.servers=broker:9092
processing.guarantee=exactly_once_v2
num.stream.threads=4
replication.factor=3
min.insync.replicas=2
```

Plus broker-side (for the `__transaction_state` topic):
```
transaction.state.log.replication.factor=3
transaction.state.log.min.isr=2
transaction.max.timeout.ms=900000   # 15 min
```

## Recovery Timeline

If an instance dies mid-transaction:

1. At time T: node crashes.
2. At T + `session.timeout.ms`: coordinator detects dead member, triggers rebalance.
3. New owner assigns. Previous producer's transaction eventually aborts at `transaction.timeout.ms` (default 60s — can be tuned).
4. New owner begins processing with a new transactional ID epoch, fencing the old one permanently.

## Exam Pointers

- EOS v2 is the default/preferred setting for exactly-once in modern Streams.
- EOS requires broker 2.5+ and `min.insync.replicas=2` with RF=3 for `__transaction_state`.
- `commit.interval.ms` is **100 ms** under EOS (was 30 s under at-least-once).
- EOS does NOT protect external side effects (DB writes outside Kafka).
- Under EOS, the consumer's `isolation.level=read_committed` is implicit within the Streams topology.
- EOS v2 uses one producer per **thread**, not per task — a scalability improvement over v1.
- EOS lowers throughput by ~10–30%.
