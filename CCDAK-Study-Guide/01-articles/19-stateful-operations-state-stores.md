# Article 19: Stateful Operations and State Stores

## What Is a State Store?

A **state store** is a **local** key-value store (RocksDB by default) that holds intermediate data for a task. Each stateful operator maintains its own state store, scoped to a single partition.

Key characteristics:

- **Local** — lives on the same JVM as the task.
- **Durable** — backed by a Kafka topic (**changelog topic**).
- **Restorable** — if the task moves or the instance restarts, the store is rebuilt from the changelog.
- **Partitioned** — each partition has its own store; stores are NOT shared across tasks.

## Default: RocksDB

RocksDB is an embedded persistent key-value store. Streams uses it by default because:

- Unbounded data size (spills to disk).
- Fast writes and prefix-based reads.
- Snapshottable.

Alternative stores:
- `InMemoryKeyValueStore` — memory-only, faster, bounded by heap size.
- Custom `StoreSupplier`.

## The Changelog Topic

Every persistent state store has a paired **changelog topic**:

- Named `<application.id>-<store-name>-changelog`.
- `cleanup.policy=compact` so the latest value per key is always retained.
- Replication factor = `replication.factor` config (default 1 — **set this higher in production!**).
- Written to by the task on every state update.

On recovery:
1. Task loads the local RocksDB (if present).
2. Compares current offset against the changelog; replays any missing records.
3. Resumes processing.

If RocksDB is gone (fresh instance, `cleanUp()` ran), full replay from the beginning of the changelog.

**Size** of the changelog = size of the state store (in key-value semantics). Compaction keeps it bounded.

## Materialized Views

Most stateful DSL operators accept a `Materialized<K,V,S>` parameter to control the state store's name, key/value Serdes, and caching behavior:

```java
builder.stream("input")
    .groupByKey()
    .count(Materialized.<String, Long, KeyValueStore<Bytes, byte[]>>as("word-counts")
        .withKeySerde(Serdes.String())
        .withValueSerde(Serdes.Long())
        .withCachingEnabled()
        .withLoggingEnabled(Map.of("retention.ms", "604800000"))
    );
```

Options on Materialized:
- `as(name)` — name the store (required for interactive queries).
- `with(keySerde, valueSerde)`
- `withCachingEnabled()` / `withCachingDisabled()` — local caches before the store (KIP-557).
- `withLoggingEnabled(configs)` — tune changelog topic configs.
- `withLoggingDisabled()` — no changelog; state is NOT restorable (rare, for in-memory-only use cases).
- `withRetention(duration)` — for window stores.

## Stateful Operators

### Aggregations (over KGroupedStream / KGroupedTable)

| Op | Semantics |
|----|-----------|
| `count()` | Count records per key |
| `reduce(reducer)` | Combine values with a binary function (V × V → V) |
| `aggregate(init, aggregator)` | Combine into a different type (V_out × V_in → V_out) |
| Windowed variants | Same but bucketed by window |

### Joins
See dedicated article.

### Process API

Lower-level: define custom `Processor<K,V,KOut,VOut>` or `Transformer<K,V,R>` classes with explicit state store access.

```java
Topology topology = new Topology();
topology.addSource("src", "input");
topology.addProcessor("counter", () -> new CounterProcessor(), "src");
topology.addStateStore(
    Stores.keyValueStoreBuilder(
        Stores.persistentKeyValueStore("counts"),
        Serdes.String(), Serdes.Long()
    ),
    "counter"
);
topology.addSink("sink", "output", "counter");
```

Inside the processor:
```java
public class CounterProcessor implements Processor<String, String, String, Long> {
    private KeyValueStore<String, Long> store;

    @Override
    public void init(ProcessorContext<String, Long> ctx) {
        this.store = ctx.getStateStore("counts");
    }

    @Override
    public void process(Record<String, String> record) {
        Long current = store.get(record.key());
        Long updated = (current == null ? 0L : current) + 1L;
        store.put(record.key(), updated);
        context.forward(new Record<>(record.key(), updated, record.timestamp()));
    }
}
```

## Standby Replicas

Set `num.standby.replicas=N` to maintain N hot copies of each state store on other instances.

- Each standby continuously consumes the changelog and keeps its local RocksDB up to date.
- On failover, the standby is promoted; recovery is near-instant.
- Cost: N× disk and memory.

Without standbys, a failover requires replaying the entire changelog — can take minutes for large stores.

## Caching

Kafka Streams has an in-memory cache in front of each state store:

- `cache.max.bytes.buffering` (total, across all stores; default 10 MB). Renamed to `statestore.cache.max.bytes` in 3.4+.
- **Purpose**: rate-limit downstream updates ("emit rate limiting"). Same key updated 100× only emits once after flush.
- **Flushed** on commit interval (`commit.interval.ms`) or when full.

With EOS, `commit.interval.ms=100` means caching is short — you get near-real-time updates.

Without caching, every state update emits downstream immediately (high load).

## Session Stores and Window Stores

In addition to plain key-value stores, two specialized stores exist:

- **WindowStore** — keyed by `(K, windowStartTime)`. Used for `TimeWindows`, `SlidingWindows`, `JoinWindows`.
- **SessionStore** — keyed by `(K, sessionStart, sessionEnd)`. Used for `SessionWindows`.

Both support time-bounded retention (`Materialized.withRetention(...)`).

## Retention and Window Stores

A window store keeps records for its **retention time** (default = window size + grace period, but configurable). After retention, old windows are deleted.

If you query a window that has been purged, you get null.

## Interactive Queries (Revisited)

Interactive queries let external clients read from state stores:

```java
ReadOnlyKeyValueStore<String, Long> store =
    streams.store(StoreQueryParameters.fromNameAndType("word-counts",
        QueryableStoreTypes.keyValueStore()));

Long count = store.get("hello");
KeyValueIterator<String, Long> all = store.all();
KeyValueIterator<String, Long> range = store.range("a", "m");
```

Ideal for providing a real-time view of aggregated data without re-deriving it from Kafka.

## Fault Tolerance Details

When a stateful task fails:
1. The coordinator detects (heartbeat loss, poll timeout).
2. Partitions re-assign (rebalance).
3. New owner seeks to committed offset in input topic.
4. New owner starts to restore state store:
   - Consumes from local RocksDB's offset to changelog LEO.
   - Or, from changelog offset 0 if no local state.
5. Normal processing resumes.

During recovery, the task is **not running the topology** — it's in a restoration state. Metric `standby-update-ratio` and `restore-remaining-records-total` surface this.

## Exam Pointers

- State stores are **local** per task partition, backed by a **compacted changelog topic**.
- Default store = **RocksDB** (persistent). In-memory variant exists.
- `num.standby.replicas=N` → N hot backups, faster failover.
- Changelog topic replication factor = `replication.factor` (default 1!) — production must raise this.
- **Null value in a state update = delete** (tombstone).
- Disabling logging (`withLoggingDisabled()`) means state is not restorable — rarely used.
- `statestore.cache.max.bytes` rate-limits downstream update emission.
- Interactive queries expose state stores as a real-time view.
