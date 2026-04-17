# Flashcards: Kafka Streams

---

Q: What is Kafka Streams?
A: A Java library for stream processing on Kafka. Not a cluster — just a dependency you add to your application.

---

Q: What's the one required config for a Streams app?
A: `application.id` — it's the Streams equivalent of a consumer group id, prefix for changelog topics, and base of the transactional id.

---

Q: What are the three abstractions in Streams?
A: KStream (event log), KTable (changelog snapshot), GlobalKTable (fully replicated changelog).

---

Q: What is a task in Kafka Streams?
A: An instance of a sub-topology processing one input partition. The unit of parallelism.

---

Q: What is the max parallelism of a Streams app?
A: The maximum number of partitions across input topics per sub-topology.

---

Q: Where does Streams store state locally?
A: In RocksDB (default), rooted at `state.dir` (default `/tmp/kafka-streams`).

---

Q: What backs up the state store?
A: A changelog topic named `<application.id>-<store-name>-changelog`, with `cleanup.policy=compact`.

---

Q: What is `num.standby.replicas`?
A: Number of hot backup copies of each state store on other instances. Enables fast failover.

---

Q: Default `num.standby.replicas`?
A: 0.

---

Q: What is a GlobalKTable?
A: A KTable fully replicated on every Streams instance. Enables non-co-partitioned lookups.

---

Q: When does a stream-table join require co-partitioning?
A: Always — unless it's a join with a GlobalKTable.

---

Q: When does a stream-stream join require a window?
A: Always. Specify `JoinWindows.ofTimeDifferenceWithNoGrace(...)` or with a grace period.

---

Q: What's the default `processing.guarantee`?
A: `at_least_once`.

---

Q: What's the recommended value for EOS?
A: `exactly_once_v2` (since Kafka 2.5).

---

Q: What does `commit.interval.ms` default to with EOS?
A: 100 ms (vs 30,000 ms for at-least-once).

---

Q: Why is EOS v2 better than v1?
A: v2 uses one producer per **thread**, while v1 used one per task — much more scalable.

---

Q: What does a null value mean in a KTable?
A: A tombstone — delete the key from the table.

---

Q: What does a null key mean in a KStream?
A: A skippable event in many DSL operations. Not allowed for operations that require keying (like `groupByKey`).

---

Q: What is `selectKey()` in a stream?
A: Changes the key of each record. If followed by a stateful op (`groupByKey`, `join`), Streams will auto-create a repartition topic.

---

Q: What's a repartition topic named?
A: `<application.id>-<operator-name>-repartition`.

---

Q: What's the difference between `groupByKey()` and `groupBy(kvmapper)`?
A: `groupByKey()` uses the existing key without repartitioning. `groupBy()` lets you pick a new grouping key — triggers a repartition.

---

Q: What window types does Streams support?
A: Tumbling, Hopping, Sliding, Session.

---

Q: What's a tumbling window?
A: Fixed size, non-overlapping, time-aligned to epoch.

---

Q: What's a hopping window?
A: Fixed size with an advance (hop). Each record belongs to `size/advance` windows.

---

Q: What's a sliding window?
A: A window whose boundaries are anchored to each record's timestamp; record defines its own window.

---

Q: What's a session window?
A: A window based on gaps of inactivity. No fixed duration.

---

Q: What is grace period?
A: Allowed lateness window; records with timestamps older than `stream_time - window_end - grace` are dropped.

---

Q: What happens to records arriving after the grace period?
A: They are dropped silently.

---

Q: What does `suppress(untilWindowCloses(...))` do?
A: Suppresses per-update emissions and emits only once per window when stream time passes window end + grace.

---

Q: What does `mapValues` do?
A: Transforms value only; keeps the key. Does NOT trigger a repartition.

---

Q: What's the difference between `to()` and `through()`?
A: `to()` writes to a topic and terminates the flow. `through()` writes and returns a KStream reading from the same topic (deprecated; use `repartition()` + `to()`).

---

Q: Can you join two KStreams without a window?
A: No. Window is mandatory for stream-stream joins.

---

Q: Can you join two KTables without a window?
A: Yes. The result is updated whenever either side updates.

---

Q: How does a foreign-key join (KT-KT FK) work?
A: You provide a `foreignKeyExtractor` on the left table; Streams automatically repartitions to satisfy the join, then joins.

---

Q: What is `application.server`?
A: A host:port string published so other instances can route interactive queries to the one holding a specific partition's state.

---

Q: What is a TopologyTestDriver?
A: An in-process simulator for unit-testing Streams topologies without a broker.

---

Q: Can Streams commit offsets via transactions?
A: Yes, when `processing.guarantee=exactly_once_v2`. Streams uses `sendOffsetsToTransaction`.

---

Q: What's the default `cache.max.bytes.buffering` / `statestore.cache.max.bytes`?
A: 10 MB (per app, shared across stores).

---

Q: What does the state store cache do?
A: Absorbs rapid updates per key and flushes periodically, rate-limiting downstream records.

---

Q: What's a good reason to disable state store caching?
A: When you want every state change emitted as a downstream event (e.g., for a low-throughput, change-sensitive pipeline).

---

Q: How do you disable logging (changelog) for a state store?
A: `Materialized.withLoggingDisabled()` — state becomes non-restorable; use sparingly.

---

Q: Can you query a state store from outside the app?
A: Via **Interactive Queries**: call `streams.store(...)` inside the JVM, or expose a REST endpoint and route queries to the correct instance using `queryMetadataForKey`.

---

Q: What's the signature of `aggregate`?
A: `.aggregate(initializer, aggregator[, merger], materialized)`. Merger is for session windows (combines two sessions).

---

Q: What's `reduce`'s limitation?
A: Input and output types must be the same — it's a binary V × V → V function.

---

Q: What's a Processor API?
A: Lower-level API where you define `Processor` classes, state stores, and topology connections explicitly.

---

Q: What's the difference between `Processor` and `Transformer`?
A: `Transformer` can return a KeyValue to downstream; older API. `Processor` uses `context.forward()` to emit; newer API.

---

Q: What's a "sub-topology"?
A: A connected component of the topology — separated by repartition topics or through() calls.

---

Q: Is each sub-topology a separate consumer group?
A: No. All sub-topologies share one consumer group (`application.id`), but each task has its own assignment of partitions.

---

Q: Does `through()` (deprecated) cause a repartition?
A: Yes — it writes to and re-reads the topic, effectively repartitioning.

---

Q: What's the preferred modern replacement for `through()`?
A: `repartition(Repartitioned.numberOfPartitions(N)).to(topic)` or just `stream.repartition(...)` if you want Streams to name the topic.

---

Q: What's a "changelog topic" used for?
A: Backing up state store contents. Compacted, so latest value per key is retained.

---

Q: What's the default cleanup policy for changelog topics Streams creates?
A: `compact` (for key-value stores); `compact,delete` for window stores (so old windows expire).

---

Q: What's `min.in.sync.replicas` for auto-created changelog topics?
A: Driven by Streams `replication.factor` config default (1). Override for production.

---

Q: What config changes the replication factor for Streams-created topics?
A: `replication.factor` (default 1). For production set to 3.

---

Q: What's `num.stream.threads`?
A: Number of threads in each Streams instance that run tasks. Default 1.

---

Q: Does scaling threads help beyond number of tasks?
A: No. Extra threads are idle.

---

Q: What's `state.cleanup.delay.ms`?
A: How long after a task moves off this instance before the local state is deleted. Default 600,000 ms.

---

Q: What is a "standby replica"?
A: A non-primary copy of a task's state store that continuously replays the changelog on another instance, ready for fast failover.

---

Q: Can Kafka Streams run EOS without a transaction-capable broker?
A: No. Brokers must be 2.5+ and `__transaction_state` must be correctly configured.

---

Q: What does `KafkaStreams.cleanUp()` do?
A: Deletes local state. Must be called BEFORE `start()` (not during running).

---

Q: What happens on `streams.close()`?
A: Stops stream threads, commits offsets, releases state stores, and leaves the consumer group.

---

Q: How is the `transactional.id` derived in Streams EOS v2?
A: `<application.id>-<thread-id>-<epoch>`.

---

Q: What's the "poison pill" problem?
A: A deserialization error on a single record blocks the entire thread. Mitigate with `default.deserialization.exception.handler=LogAndContinueExceptionHandler`.

---
