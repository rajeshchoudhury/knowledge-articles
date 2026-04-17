# Article 21: Joins in Kafka Streams

Joins are one of the most exam-tested topics. Master the matrix.

## The Join Matrix

| Join Type | Requires Co-partitioning? | Windowed? | State Store? | Inner / Left / Outer |
|-----------|:-------------------------:|:---------:|:------------:|:--------------------:|
| KStream-KStream | Yes | **Yes** (JoinWindows) | Yes | Inner, Left, Outer |
| KStream-KTable | Yes | No | Uses KT store | Inner, Left |
| KStream-GlobalKTable | **No** | No | GlobalKTable | Inner, Left |
| KTable-KTable | Yes | No | Both stores | Inner, Left, Outer |
| KTable-GlobalKTable (FK) | No | No | — | Inner, Left |

## Co-partitioning

Co-partitioning means two topics have:

1. **Same number of partitions.**
2. **Same partitioner** (same key hashing — typically DefaultPartitioner for both).
3. **Same key type and serialization.**

Why: when a task for partition 5 wants to join, it expects data with the same key to also be on partition 5 of the other side.

If not co-partitioned, the join produces wrong results. Streams auto-detects via a check of partition counts but can't detect different partitioners — it's the developer's responsibility.

**Fix**: explicitly repartition the smaller side to match the partition count:

```java
KStream<K,V> rePartitioned = smallerStream.repartition(
    Repartitioned.numberOfPartitions(targetCount).with(keySerde, valueSerde)
);
```

### GlobalKTable bypasses co-partitioning

Because every instance has the entire table, a record on any partition can still find its match locally. This is the **killer feature** of GlobalKTable.

## KStream-KStream Join

Windowed join. Records match if their timestamps fall within the join window.

```java
KStream<K,V3> joined = leftStream.join(
    rightStream,
    (l, r) -> combine(l, r),
    JoinWindows.ofTimeDifferenceAndGrace(Duration.ofMinutes(5), Duration.ofSeconds(30)),
    StreamJoined.with(keySerde, leftSerde, rightSerde)
);
```

Each side is buffered in a window store. On a new left record, the store is scanned for matching right records within the window (and vice versa).

- **Inner join**: emits only on pair match.
- **Left join**: emits pairs; for unmatched lefts, emits `(left, null)` **after the window closes**.
- **Outer join**: both sides emit with null when unmatched, after window close.

## KStream-KTable Join

**Asymmetric**: joins a **stream event** with the **current value** of a table key.

```java
KStream<K, Enriched> enriched = stream.join(
    table,
    (streamVal, tableVal) -> enrich(streamVal, tableVal)
);
```

Semantics:
- Stream record arrives → look up key in table → emit.
- Table update → does **NOT** emit anything. Old stream records aren't re-joined.
- If the key isn't in the table: `join` drops; `leftJoin` emits `(streamVal, null)`.

Use when: enriching a high-volume event stream with a slowly-changing reference table.

## KStream-GlobalKTable Join

Like KS-KT but with two differences:

1. **No co-partitioning required.**
2. You supply a `KeyValueMapper` to derive the global table's lookup key from the stream record — supporting **non-key joins** ("foreign key" joins on the stream side).

```java
KStream<K, Enriched> enriched = stream.join(
    globalTable,
    (streamKey, streamVal) -> streamVal.getLookupKey(),   // key selector
    (streamVal, globalVal) -> enrich(streamVal, globalVal)
);
```

Trade-off: requires every instance to load the whole table.

## KTable-KTable Join

**Symmetric**. Both sides are tables keyed by the same key. Emits on any update of either side.

```java
KTable<K, Merged> merged = leftTable.join(
    rightTable,
    (l, r) -> merge(l, r)
);
```

- **Inner**: both sides must have a value.
- **Left**: emits when left has a value (right may be null).
- **Outer**: emits on any update.

Internally, maintains state from both sides; scans the other side on each update.

## Foreign Key Joins (KTable-KTable FK)

Kafka 2.4+ introduced foreign-key joins **between two KTables** where the FK is extracted from the left side:

```java
KTable<String, Joined> joined = leftTable.join(
    rightTable,
    leftVal -> leftVal.getForeignKey(),   // FK extractor
    (leftVal, rightVal) -> combine(leftVal, rightVal)
);
```

Under the hood: automatically repartitions left by the FK, joins, and repartitions back. Don't worry about co-partitioning.

## Null Values and Tombstones

| Side | Null Value Meaning |
|------|--------------------|
| KStream in join | Record skipped |
| KTable in join | Delete the key (tombstone); join emits null |
| GlobalKTable | Same as KTable |

For stream-table joins, a null table value means the key has been deleted — the stream-side lookup returns null, and `leftJoin` emits `(streamVal, null)`.

## Order-of-Arrival and KS-KT Join

A classic trap: the join executes per stream event, at the timestamp-ordered processing moment. If the table record arrives **after** the stream record, the stream record sees a null for that key (for the time being).

Fix: ensure the table is "warmed up" before stream processing starts, via `GlobalKTable` or by controlling publication order.

## Stream-Stream Join Buffer

Internally:
- Left side store: `<app-id>-<left-name>-this-store-changelog`.
- Right side store: `<app-id>-<right-name>-other-store-changelog`.
- Retention = window size + grace period (approximate).

## Join Configuration Summary

| Join | Key Requirement | State Store | Time Element |
|------|-----------------|-------------|--------------|
| KStream-KStream | Same key, co-partitioned | Window store, both sides | **JoinWindows** required |
| KStream-KTable | Same key, co-partitioned | Table's store | None |
| KStream-GlobalKTable | Mapper for key lookup | GlobalKTable local | None |
| KTable-KTable | Same key, co-partitioned | Both stores | None |
| KTable-KTable (FK) | FK extractor | Both stores + repartition | None |

## Exam Pointers

- **GlobalKTable joins do NOT require co-partitioning**.
- **Stream-stream joins REQUIRE a JoinWindow**.
- KTable updates do not retroactively re-trigger KS-KT joins.
- Co-partitioning requires same partition count AND same partitioner.
- Foreign-key joins (KT-KT FK) handle repartitioning for you.
- A KS-KT left join with a null table entry emits `(streamVal, null)` immediately.
- A KS-KS left join with no match emits `(left, null)` only **after the window closes**.
- Null value in a KTable is a **tombstone** (delete).
