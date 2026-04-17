# Article 6: Log Compaction

## The Use Case

Traditional retention deletes old data after some time or size. But often you want to keep the **latest value for each key forever**, like a database table:

| Key | Value |
|-----|-------|
| user-42 | `{name: "Alice", tier: "Gold"}` |
| user-43 | `{name: "Bob", tier: "Silver"}` |

Log compaction gives you exactly this: a topic that acts as a **changelog** with a dense, latest-value-per-key snapshot.

**Canonical examples:**
- Kafka's own `__consumer_offsets` (keyed by group + topic + partition).
- Schema Registry's `_schemas` topic.
- Kafka Streams KTable state store changelogs.
- User profile tables, config tables, current-position tables.

## Requirements

1. Every record MUST have a key. Compaction cannot process null-keyed records.
2. Set `cleanup.policy=compact` (or `compact,delete`).
3. Use a durable RF (at least 3 for production).

## The Semantic Guarantee

For any consumer reading the topic from the beginning after compaction has occurred:

- The **latest value** for every key is **always present**.
- A key with a **tombstone** (value=null) may eventually be completely removed.
- **Order is preserved** within a partition — earlier-offset records of the same key may be absent, but the latest is there, and records of different keys keep their relative order.

## The Dirty and Clean Sections

Every log is split into two halves:

```
┌──────────────── CLEAN ──────────────┐┌──── DIRTY ────┐┌ ACTIVE ┐
│  already compacted, at most         ││ never cleaned ││ never  │
│  one record per key                 ││               ││ cleaned│
└─────────────────────────────────────┘└──────────────┘└───────┘
  offset 0            ...    cleanerCheckpoint     activeBase   LEO
```

- The **active segment** is never compacted.
- The **clean section** has already been compacted.
- The **dirty section** is the candidate for the next compaction pass.

The cleaner wakes up when:

```
dirty_bytes / (clean_bytes + dirty_bytes) >= min.cleanable.dirty.ratio   (default 0.5)
```

## Compaction Algorithm (Simplified)

1. **Build offset map.** The cleaner reads the dirty section, building a hash map `key → latestOffset` of the highest offset per key.
2. **Scan clean section.** For each record, if its key exists in the map AND its offset < `map[key]`, drop it. Otherwise, copy it.
3. **Scan dirty section.** For each record, if its offset < `map[key]`, drop it. Otherwise, copy it.
4. **Atomically swap** the new cleaned segments in for the old ones.
5. **Advance the cleaner checkpoint** to the end of the dirty section.

The offset map is bounded by `log.cleaner.dedupe.buffer.size` (default 128 MB). If it overflows, compaction continues but processes less at a time.

## Tombstones

A tombstone is a record with a non-null key and a **null** value. It signals: "Forget this key."

Lifecycle:
1. Tombstone is produced.
2. Compaction passes run, removing older values for this key.
3. After `delete.retention.ms` (default 24 hours) from the time of tombstone creation, the tombstone itself is removed.
4. The key is now permanently gone from the log.

**Critical nuance:** `delete.retention.ms` is measured from when the tombstone enters the **clean** section, not when it's produced. The purpose of the delay is to give slow consumers a chance to see the tombstone before it's erased.

## Configuration

| Config | Default | Purpose |
|--------|---------|---------|
| `cleanup.policy` | `delete` | Set to `compact` to enable |
| `min.cleanable.dirty.ratio` | 0.5 | Trigger for compaction |
| `segment.ms` | 7 days | Active segment rolls after this age even if unfilled (important for compaction to reach it) |
| `min.compaction.lag.ms` | 0 | Minimum age before a record is eligible |
| `max.compaction.lag.ms` | `Long.MAX_VALUE` | Maximum age at which compaction must happen |
| `delete.retention.ms` | 86400000 | How long tombstones survive after compaction |
| `log.cleaner.threads` | 1 | Cleaner thread pool size |
| `log.cleaner.io.max.bytes.per.second` | inf | Throttle cleaner I/O |
| `log.cleaner.dedupe.buffer.size` | 128MB | Memory per cleaner thread |

## Combining Compaction and Deletion

`cleanup.policy=compact,delete` means:

- Old duplicates per key are removed (compaction).
- AND segments older than `retention.ms` (or over `retention.bytes`) are wholesale deleted.

Use case: a changelog topic where you only want the last 30 days of history, and only the latest per key within that window.

## Common Trap: Compaction vs Storage Size

Compaction does not immediately reduce disk usage:

- The active segment is never compacted.
- Dirty ratio must cross `min.cleanable.dirty.ratio`.
- Tombstones extend size for at least `delete.retention.ms`.

In steady state with many updates per key, compacted storage converges to the **size of the key space × average record size**, plus open-segment overhead.

## Practical Example

Produce to a compacted topic `users`:

```
(k=1, v=A)       offset 0
(k=2, v=B)       offset 1
(k=1, v=C)       offset 2
(k=3, v=D)       offset 3
(k=2, v=E)       offset 4
(k=1, v=null)    offset 5   ← tombstone for k=1
(k=4, v=F)       offset 6
(k=2, v=G)       offset 7
```

After full compaction (once everything except the active segment is clean):

```
(k=1, v=null)    offset 5   (tombstone — still retained)
(k=3, v=D)       offset 3
(k=4, v=F)       offset 6
(k=2, v=G)       offset 7
```

After `delete.retention.ms` passes:

```
(k=3, v=D)       offset 3
(k=4, v=F)       offset 6
(k=2, v=G)       offset 7
```

Note: offsets are **preserved** from the original log — compaction doesn't renumber records. Downstream consumers still see consistent monotonic offsets, though they'll see "holes" where deleted records used to be.

## Exam Pointers

- **Null key + compacted topic** = problem. The cleaner cannot dedupe by key if the key is null.
- **Null value = tombstone**, applicable only for compacted topics.
- Compaction **does not re-order** records — only deletes them.
- `__consumer_offsets`, `__transaction_state`, `_schemas` are compacted; memorize these three.
- Kafka Streams changelog topics for state stores are compacted — enabling stateful processing recovery.
- The **active segment is never compacted**. If a topic has only one segment (never rolled), compaction does nothing.
- `min.cleanable.dirty.ratio=0` does NOT mean "compact immediately" — it means "compact as soon as there is any dirt", which requires the active segment to roll first.
