# Article 18: KStream, KTable, and GlobalKTable

The three core abstractions of Kafka Streams. The differences are subtle but vital.

## KStream — The Record Stream

A `KStream<K,V>` models an **infinite sequence of events**. Each record is an independent fact.

- Appending a new record does **not** overwrite an earlier record with the same key.
- Aggregations sum, count, or combine all records.

Example use cases:
- Clickstream events
- Transactions
- Sensor readings
- Logs

```java
KStream<String, Purchase> purchases = builder.stream("purchases");
```

Mental model: an **append-only log**.

## KTable — The Changelog Stream

A `KTable<K,V>` models a **snapshot of state**. Each record with a given key **overwrites** the previous value for that key.

- A null value means "delete this key" (a tombstone).
- Aggregations operate on the current state, not all historical events.

Example use cases:
- User profiles (each update overwrites)
- Inventory counts
- Configuration tables

```java
KTable<String, UserProfile> users = builder.table("users");
```

Backed by a local state store named after the input topic (unless overridden). The source topic is treated as the changelog.

**Best practice**: the source topic should be `cleanup.policy=compact` so that restarting the app doesn't require reading eternal history.

## GlobalKTable — Replicated Everywhere

A `GlobalKTable<K,V>` is like a KTable, but **every instance of your app holds the FULL table** — not just its share.

- **Every instance consumes ALL partitions** of the source topic on startup.
- Lookups are local, no network hop.
- No rebalance migration of state.
- **Join with GlobalKTable does NOT require co-partitioning.**

```java
GlobalKTable<String, Currency> currencies = builder.globalTable("currencies");
```

Trade-offs:
- Memory-heavy: suitable only for small reference tables.
- Always fully loaded at startup.
- Updates flow to all instances concurrently.

## Side-by-Side Comparison

| Aspect | KStream | KTable | GlobalKTable |
|--------|---------|--------|-------------|
| Semantics | Append log | Changelog (updates by key) | Changelog (updates by key) |
| Distribution | Partitioned across tasks | Partitioned across tasks | Fully replicated in every instance |
| Co-partitioning required for join | Yes (for KS-KS) | Yes (for KS-KT, KT-KT) | **No** |
| State store | None (unless aggregated) | Local (share per partition) | Local (full copy per instance) |
| Join semantics | — | Inner, Left (NOT foreign key without extra) | Foreign key supported via `KeyValueMapper` in join |
| Tombstones | Ignored | Delete key | Delete key |
| Null key | Allowed (skipped in many ops) | Skipped | Skipped |

## Null Values and Tombstones

For a `KStream`, a record with `value=null` is a normal event.

For a `KTable`, `value=null` is a **delete signal** (tombstone). The record is removed from the internal state store. Downstream KTables propagate the delete.

For a `GlobalKTable`, same as KTable.

## Conversions

### KStream → KTable

```java
KTable<String, Long> t = stream.toTable();
```

Converts an append-only stream into a table semantics view, keyed by record key. Requires the key to be non-null.

Alternative: aggregation (explicit reduction):

```java
KTable<String, Long> counts = stream
    .groupByKey()
    .count();
```

### KTable → KStream

```java
KStream<String, Long> s = table.toStream();
```

Produces the changelog as an event stream — one event per update.

## KStream Operations (Selected)

### Stateless

| Op | Signature | What |
|----|-----------|------|
| `map` | `(K,V) → (K2,V2)` | Transform both key and value |
| `mapValues` | `V → V2` | Transform value only |
| `flatMap` | `(K,V) → Iterable<(K2,V2)>` | 1:N transform |
| `flatMapValues` | `V → Iterable<V2>` | 1:N values |
| `filter` | predicate | Keep matching |
| `filterNot` | predicate | Drop matching |
| `selectKey` | `(K,V) → K2` | New key (triggers repartition if next op is stateful) |
| `branch` | predicates[] | Split into multiple streams |
| `merge` | other KStream | Combine two streams |
| `peek` | consumer | Side-effect without changing flow |
| `foreach` | consumer | Terminal op |
| `to` | topic | Write to a sink topic |
| `through` | topic | Write and continue (deprecated → use `repartition` + `to`) |

### Stateful

| Op | Result | Notes |
|----|--------|-------|
| `groupByKey()` | KGroupedStream | No repartition if key unchanged |
| `groupBy(kvmapper)` | KGroupedStream | Repartitions |
| `count()` | KTable | Count per key |
| `reduce(reducer)` | KTable | Binary combine |
| `aggregate(init, agg)` | KTable | General aggregation |
| `windowedBy(...)` | TimeWindowedKStream | Apply windowing |
| `join / leftJoin / outerJoin` | KStream | See join article |

## KTable Operations (Selected)

| Op | Result | Notes |
|----|--------|-------|
| `filter`, `filterNot` | KTable | Preserves table semantics |
| `mapValues` | KTable | Transform values |
| `join / leftJoin / outerJoin` | KTable | KT-KT or KT-GKT |
| `toStream()` | KStream | Convert to event stream |

Note: KTable does NOT have `map` (changing the key) — that would break table semantics. Use `toStream().map(...).toTable()`.

## Use Case Patterns

### Enrichment

Join a high-volume event stream with a small reference table.

- If reference is small and static → `GlobalKTable`.
- If reference is large or dynamic per partition → `KTable` (with co-partitioning).

### Aggregation

```java
KTable<String, Long> orderCountPerUser = orders
    .selectKey((k,v) -> v.getUserId())
    .groupByKey()
    .count();
```

### Windowed Aggregation

```java
KTable<Windowed<String>, Long> hourlySales = sales
    .groupByKey()
    .windowedBy(TimeWindows.ofSizeWithNoGrace(Duration.ofHours(1)))
    .count();
```

## The Repartition Trap

Anytime you change the key of a stream and then perform a stateful operation, a **repartition** happens — an intermediate topic is written to and read back.

Symptoms:
- Extra topics appearing: `<app-id>-KSTREAM-XXXXXX-repartition`.
- Duplicated I/O.
- Latency increase.

Mitigation: design input topic keys to match your processing needs. Or if you must re-key, ensure all downstream stateful ops happen after one repartition, not multiple.

## Exam Pointers

- **KStream = event log, KTable = changelog snapshot, GlobalKTable = fully replicated**.
- **Null value in KTable = tombstone** (deletes the key).
- **GlobalKTable** does NOT require co-partitioning on join.
- Input topic for a KTable should be **compacted** for robust restart.
- A `selectKey` + `groupByKey` + aggregation requires a repartition topic.
- You cannot `map` a KTable (would break semantics).
- GlobalKTable is fully loaded **at startup** on every instance — small tables only.
