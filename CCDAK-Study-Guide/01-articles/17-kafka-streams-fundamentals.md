# Article 17: Kafka Streams Fundamentals

## What Is Kafka Streams?

A **Java client library** for building stream-processing applications on top of Kafka. It is *not* a server; there is no cluster to operate. Your app is just a JVM process that reads, transforms, and writes Kafka topics.

Key properties:

- **Embedded** — just a dependency; no external processing cluster.
- **Scales horizontally** — run multiple instances; Kafka's consumer-group protocol distributes partitions.
- **Stateful** — built-in local state stores (RocksDB by default).
- **Exactly-once semantics** — EOS v2 (alpha/beta) by default.
- **High-level DSL** + low-level Processor API.
- **Interactive Queries** — read state store contents via API.
- **TopologyTestDriver** — unit-test topologies without a running broker.

## High-level Architecture

```
┌─────────────────────────────────────────────┐
│       Your Streams Application (JVM)        │
│                                             │
│   ┌────────────────────────────────────┐    │
│   │  StreamsBuilder DSL / Processor API │    │
│   │         ↓                           │    │
│   │     Topology                        │    │
│   │         ↓                           │    │
│   │     StreamThread(s)                 │    │
│   │         ↓                           │    │
│   │      Task(s) → StateStores          │    │
│   └────────────────────────────────────┘    │
│                                             │
│          uses standard                      │
│          KafkaProducer / KafkaConsumer      │
└─────────────────────────────────────────────┘
                   ↕
             Kafka Cluster
```

## Core Concepts

| Concept | Definition |
|---------|------------|
| **Topology** | The DAG of processing steps |
| **Source processor** | Reads from a Kafka topic |
| **Sink processor** | Writes to a Kafka topic |
| **Stream processor** | Stateless or stateful transformation |
| **Sub-topology** | A connected component of the topology, typically separated by `through()` or a repartition |
| **Task** | An instance of a sub-topology assigned to one partition |
| **Stream thread** | A thread executing one or more tasks |
| **State store** | Local, persistent key-value store (RocksDB by default) |
| **Changelog topic** | Kafka topic used to back up a state store's contents |
| **Standby replica** | A hot copy of a task's state store on another instance, enabling faster failover |

### Tasks, Threads, Instances

```
parallelism_ceiling = sum over sub-topologies of max(input_partitions)
```

- A sub-topology reading from a 10-partition topic has 10 tasks.
- Each stream thread runs one or more tasks.
- Multiple instances split the total task set.

If your app has 10 tasks and you run 2 instances with 5 threads each, each thread runs 1 task.

If you run 3 instances with 10 threads each (30 total), only 10 threads do work; the rest are idle.

## StreamsBuilder Example

```java
StreamsBuilder builder = new StreamsBuilder();

KStream<String, String> words = builder.stream("text-input");

KTable<String, Long> counts = words
    .flatMapValues(line -> Arrays.asList(line.toLowerCase().split(" ")))
    .groupBy((key, word) -> word)
    .count(Materialized.as("word-counts"));

counts.toStream().to("word-count-output", Produced.with(Serdes.String(), Serdes.Long()));

KafkaStreams streams = new KafkaStreams(builder.build(), props);
streams.start();
```

## Required Configuration

| Config | Required? | Notes |
|--------|-----------|-------|
| `application.id` | YES | Acts as consumer group ID, transactional ID prefix, state store namespace, changelog topic prefix |
| `bootstrap.servers` | YES | |
| `default.key.serde` | Usually | Default Serde for keys |
| `default.value.serde` | Usually | Default Serde for values |
| `processing.guarantee` | `at_least_once` (default) or `exactly_once_v2` | |
| `state.dir` | `/tmp/kafka-streams` | Where RocksDB lives |
| `num.stream.threads` | 1 | How many threads per instance |
| `commit.interval.ms` | 30000 (at_least_once) or 100 (EOS) | How often to commit offsets |

**Critical:** `application.id` uniquely identifies the streams app. Changing it resets everything — new consumer group, new state stores, new changelog topics.

## Stateful vs Stateless Operations

### Stateless (no state store):
- `map`, `mapValues`
- `flatMap`, `flatMapValues`
- `filter`, `filterNot`
- `peek`, `foreach`
- `branch` (split)
- `merge`
- `selectKey`
- `to` (sink)

### Stateful (require state store and changelog):
- `groupByKey`, `groupBy` (repartition if key changes)
- `count`, `aggregate`, `reduce`
- `windowedBy` + aggregations
- `join` (when not with GlobalKTable)

Stateful ops create RocksDB stores + changelog topics named `<application.id>-<operator>-changelog`.

## Repartitioning

When a transformation changes the **key** (e.g., `selectKey`, `map`), subsequent stateful ops need the records **re-routed by the new key**. Streams auto-creates a repartition topic: `<application.id>-<operator>-repartition`. You pay double I/O for this.

Avoid unnecessary repartitions by:
- Grouping by the existing key when possible.
- Using `groupByKey()` instead of `groupBy(key)` when key hasn't changed.

## Failure & Recovery

When a task fails or a thread dies:
1. The coordinator rebalances; another thread/instance picks up the task.
2. The new owner restores state from:
   - Local RocksDB (if present and matching changelog offset).
   - Otherwise, replays changelog topic from start of the relevant offset range.
3. Processing resumes.

**Standby replicas** (`num.standby.replicas > 0`) keep a hot copy of the state on other instances, dramatically shortening recovery time.

## Testing with TopologyTestDriver

```java
TopologyTestDriver testDriver = new TopologyTestDriver(builder.build(), props);

TestInputTopic<String, String> input = testDriver.createInputTopic("text-input",
    Serdes.String().serializer(), Serdes.String().serializer());
TestOutputTopic<String, Long> output = testDriver.createOutputTopic("word-count-output",
    Serdes.String().deserializer(), Serdes.Long().deserializer());

input.pipeInput("k1", "hello world hello");
assertEquals(Map.of("hello", 2L, "world", 1L), output.readKeyValuesToMap());
```

TopologyTestDriver:
- Runs entirely in memory.
- No broker required.
- Advances time manually via `testDriver.advanceWallClockTime(...)`.
- Ideal for unit tests.

## Interactive Queries

Query state stores from within the application process:

```java
ReadOnlyKeyValueStore<String, Long> store =
    streams.store(StoreQueryParameters.fromNameAndType("word-counts",
        QueryableStoreTypes.keyValueStore()));

Long count = store.get("hello");
```

Since state is distributed across instances, you also need a way to route queries to the right instance:

```java
KeyQueryMetadata meta = streams.queryMetadataForKey("word-counts", "hello", Serdes.String().serializer());
HostInfo activeHost = meta.activeHost();   // use e.g. REST to query that host
```

## Lifecycle

```java
streams.cleanUp();     // only before start; removes local state
streams.start();
// ...
streams.close(Duration.ofSeconds(10));
```

`cleanUp()` deletes local state — use rarely, only after changing the topology significantly.

## Exam Pointers

- `application.id` is **required** and multipurpose (group ID, state dir, changelog prefix, transactional ID prefix).
- Streams = client library; no separate cluster.
- Stateful operations use **RocksDB** + **changelog topics** (compacted, named `<app-id>-<store>-changelog`).
- `selectKey`/`map` that changes the key + a subsequent `groupByKey` triggers a **repartition topic**.
- Maximum parallelism = max input partitions per sub-topology.
- `TopologyTestDriver` is the exam-standard way to test topologies.
- Default `processing.guarantee` is `at_least_once`; set `exactly_once_v2` for EOS.
