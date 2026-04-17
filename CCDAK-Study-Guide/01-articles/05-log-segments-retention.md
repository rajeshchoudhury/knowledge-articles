# Article 5: Log Segments, Retention, and Log Layout

## Physical Layout of a Partition

Each partition replica on a broker is a directory named `<topic>-<partition>` inside one of the `log.dirs`. Within it:

```
orders-0/
├── 00000000000000000000.log          ← earliest segment, closed (if not the only one)
├── 00000000000000000000.index
├── 00000000000000000000.timeindex
├── 00000000000000123456.log          ← later segment
├── 00000000000000123456.index
├── 00000000000000123456.timeindex
├── 00000000000000987654.log          ← active segment
├── 00000000000000987654.index
├── 00000000000000987654.timeindex
├── leader-epoch-checkpoint
└── partition.metadata
```

- The file name's number is the **base offset** of the first record in that segment.
- `.log` — the actual record data (batches of records, Kafka v2 format).
- `.index` — sparse offset → byte position index.
- `.timeindex` — sparse timestamp → offset index.
- `leader-epoch-checkpoint` — tracks leader epochs for accurate truncation after failovers.

Only **one segment is active** (the newest). Records are always appended to it. Once an active segment reaches `segment.bytes` (1 GB default) or `segment.ms` (7 days default), it is closed and a new active segment is created.

## Record Batch Format (v2)

A single `.log` file consists of a sequence of **record batches**. Each batch has:

- base offset (8 bytes)
- batch length (4 bytes)
- partition leader epoch (4 bytes)
- magic byte (v2 = 2)
- CRC (4 bytes)
- attributes: compression type (bits 0-2), timestamp type (bit 3), transactional flag (bit 4), control batch flag (bit 5)
- last offset delta (4 bytes)
- first timestamp (8 bytes)
- max timestamp (8 bytes)
- producer ID (8 bytes)
- producer epoch (2 bytes)
- base sequence (4 bytes)
- records (variable, possibly compressed as a whole)

Key takeaway: the **whole batch is compressed as a unit**. Individual records within a batch aren't individually compressed.

## Retention Policies

The `cleanup.policy` property controls what happens to old segments.

| cleanup.policy | Behavior |
|----------------|---------|
| `delete` (default) | Old segments are deleted based on time or size |
| `compact` | Old records per key are deleted; only the most recent record per key is kept |
| `compact,delete` | Both — compaction runs, and segments older than retention are deleted (useful for changelog topics with bounded history) |

### `delete` Policy

Deletion happens when a **closed** segment exceeds:

- `retention.ms` (default 604800000 = 7 days) — Age of the most recent record in the segment.
- `retention.bytes` (default -1 = unlimited) — Total size of all segments exceeds this threshold. The broker deletes the oldest segments until under the threshold.

Key point: Kafka deletes at **segment granularity**, not record granularity. A record is retained until its entire segment is old enough AND past the threshold.

The deletion process runs periodically (every `log.retention.check.interval.ms` = 5 minutes).

### `retention.ms = -1`

Setting retention to -1 means **never delete**. Useful for compacted topics or topics where downstream consumers may be arbitrarily slow.

### Size-Triggered vs Time-Triggered

Both are evaluated independently; whichever triggers first deletes the segment.

## Timestamp Semantics

Every record has a timestamp. How it's assigned depends on:

`message.timestamp.type` (broker or topic):
- `CreateTime` (default) — the producer's timestamp (from `ProducerRecord`) is kept.
- `LogAppendTime` — the broker overwrites the timestamp with its current time.

If `CreateTime`, the broker enforces `message.timestamp.difference.max.ms` — reject records whose timestamp is too far from broker time. Default is `Long.MAX_VALUE` (no enforcement).

Retention is based on the **max timestamp in the segment** (under CreateTime) or the append time (under LogAppendTime).

## Log Compaction Basics (see next article for details)

- Applies only when `cleanup.policy` includes `compact`.
- Guarantees that for every key, at least the **latest** value is retained.
- Older records with duplicate keys may be removed.
- A **tombstone** (record with `value = null`) marks a key for deletion — after `delete.retention.ms` (default 24 hours), the tombstone itself is also removed.
- A compacted topic's `__consumer_offsets` analog uses this mechanism: only the most recent offset per `(group, topic, partition)` key is kept.

## The Log Cleaner

A background thread pool (`log.cleaner.threads` = 1 by default) performs compaction on segments whose dirty-ratio exceeds `min.cleanable.dirty.ratio` (default 0.5). The cleaner:

1. Builds an in-memory offset map for the dirty section of the log.
2. Scans older clean segments, copying only records whose key has no newer entry.
3. Replaces the old segments with the cleaned versions.

The cleaner never touches the **active segment** (to avoid races with producers).

## Disk Usage Expectations

Estimate disk per broker:

```
disk = Σ over partitions (records_per_day × avg_record_size × retention_days × RF / broker_count)
```

With RF=3 and 10 brokers, each broker holds `3/10` of the cluster-wide data (plus overhead for indexes and compression ratios).

## Configuration Reference Table

| Config | Default | Scope | Purpose |
|--------|---------|-------|---------|
| `cleanup.policy` | `delete` | Topic | `delete` / `compact` / `compact,delete` |
| `retention.ms` | 604800000 (7d) | Topic | Time-based retention |
| `retention.bytes` | -1 | Topic | Size-based retention per partition |
| `segment.bytes` | 1073741824 (1GB) | Topic | Segment size |
| `segment.ms` | 604800000 (7d) | Topic | Max segment age |
| `segment.jitter.ms` | 0 | Topic | Randomness in segment rolls (avoid thundering herd) |
| `min.cleanable.dirty.ratio` | 0.5 | Topic | Trigger compaction when dirty / total > ratio |
| `delete.retention.ms` | 86400000 (24h) | Topic | How long tombstones persist after compaction |
| `min.compaction.lag.ms` | 0 | Topic | Minimum age before a record is eligible for compaction |
| `max.compaction.lag.ms` | Long.MAX | Topic | Maximum age before a record MUST be compacted |
| `max.message.bytes` | 1048588 (~1MB) | Topic | Max size of a record batch |
| `message.timestamp.type` | `CreateTime` | Topic | Who sets the timestamp |
| `compression.type` | `producer` | Topic | Broker-side compression override |

## Exam Pointers

- Retention is **per partition per segment**; it is not per record.
- A record can live *longer* than `retention.ms` because the segment must finish filling up or age out first.
- **Tombstones persist for `delete.retention.ms`** after the last compaction pass — this is a common trick question.
- `compression.type=producer` means the broker stores whatever the producer sent. Any other value forces the broker to recompress.
- Disabling retention entirely means setting BOTH `retention.ms=-1` AND `retention.bytes=-1`.
- If `log.retention.hours` and `log.retention.ms` are both set, the `ms` version wins.
