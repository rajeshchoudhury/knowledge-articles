# Flashcards: Fundamentals

---

Q: What is a Kafka partition?
A: An ordered, append-only, immutable log of records; the unit of parallelism and the basic storage primitive within a topic.

---

Q: Is record order guaranteed across partitions of a topic?
A: No. Order is guaranteed only **within** a single partition.

---

Q: What is an "offset" in Kafka?
A: A monotonically increasing integer that uniquely identifies each record within a partition.

---

Q: What is the role of the Kafka controller?
A: Manages cluster-wide metadata: partition leader elections, ISR updates, topic create/delete, metadata propagation to all brokers.

---

Q: How many controllers are active at a time?
A: Exactly one per cluster (ZooKeeper mode). In KRaft, a small quorum of dedicated controllers; only one is the leader.

---

Q: What is KRaft?
A: The Kafka Raft metadata mode, which replaces ZooKeeper. Metadata is stored in the internal `__cluster_metadata` topic and managed by a Raft quorum of controllers.

---

Q: What is ISR?
A: In-Sync Replicas — the set of partition replicas currently caught up with the leader (within `replica.lag.time.max.ms`).

---

Q: What is the high watermark (HW)?
A: The highest offset that has been replicated to all ISR members; it is the maximum offset a standard consumer can read.

---

Q: What is the log end offset (LEO)?
A: The offset of the next record to be appended to a partition.

---

Q: What does `min.insync.replicas=2` do?
A: When a producer uses `acks=all`, the write is only acknowledged if at least 2 ISR members have accepted it. If ISR shrinks below 2, writes fail.

---

Q: Does `min.insync.replicas` matter with `acks=1` or `acks=0`?
A: No. It is only enforced when `acks=all`.

---

Q: What is "unclean leader election"?
A: Allowing an out-of-sync replica to become leader if no ISR member is available. Restores availability at the cost of data loss. Disabled by default.

---

Q: What is the default `unclean.leader.election.enable`?
A: `false` (since Kafka 0.11).

---

Q: How do followers fetch data from the leader?
A: Followers send Fetch requests to the leader — the same API the consumer uses. Replication is pull-based.

---

Q: What's the difference between a segment and a partition?
A: A partition is the logical log; a segment is one physical file on disk within the partition's directory.

---

Q: When does a new segment roll?
A: When the active segment exceeds `segment.bytes` (default 1 GB) OR its age exceeds `segment.ms` (default 7 days).

---

Q: Can retention delete records from the active segment?
A: No. Only **closed** (non-active) segments are eligible for deletion or compaction.

---

Q: What is log compaction?
A: A cleanup policy that keeps at least the latest value per key. Older records with the same key are discarded.

---

Q: What is a tombstone?
A: A record with a non-null key and `value=null` that signals deletion of the key in a compacted topic.

---

Q: How long do tombstones persist?
A: Until `delete.retention.ms` elapses after the last compaction pass (default 24 hours).

---

Q: What cleanup policies exist?
A: `delete` (default), `compact`, or `compact,delete` (both).

---

Q: What is `auto.create.topics.enable`?
A: Broker config allowing producers/consumers to auto-create topics on first reference. Defaults to `true`; recommended to disable in production.

---

Q: Why would you disable auto topic creation?
A: To prevent typos from creating stray topics with default (likely wrong) configuration, especially replication factor = 1.

---

Q: What is the default replication factor for `__consumer_offsets`?
A: 3 — requires at least 3 brokers. On a single-broker cluster, you must lower `offsets.topic.replication.factor` to 1.

---

Q: What is rack awareness?
A: Setting `broker.rack=<id>` makes the controller place replicas across different racks for fault tolerance.

---

Q: What are the three key compacted internal topics?
A: `__consumer_offsets`, `__transaction_state`, and `_schemas` (Schema Registry's backing store).

---

Q: Where does the controller keep its state in KRaft mode?
A: In the internal `__cluster_metadata` Kafka topic, replicated via Raft.

---

Q: What is the preferred leader?
A: The first replica listed in a partition's replica set. Kafka periodically re-balances leadership to preferred leaders.

---

Q: What triggers preferred leader election?
A: Automatic (`auto.leader.rebalance.enable=true` by default) or manual via `kafka-leader-election`.

---

Q: Can partitions be reduced in number after creation?
A: No. Partitions can only be increased. Reducing requires recreating the topic.

---

Q: What's the caveat when increasing partition count?
A: Existing keys get rehashed — records that used to go to partition X may now go to partition Y, breaking per-key ordering.

---

Q: What is `replica.lag.time.max.ms`?
A: Default 30,000 ms. If a follower doesn't fetch up to the leader's LEO within this time, it's removed from ISR.

---

Q: What is an "under-replicated partition"?
A: A partition where the ISR size is less than the replication factor.

---

Q: What is an "under-min-ISR" partition?
A: A partition where the ISR size is less than `min.insync.replicas` — producers with `acks=all` will fail.

---

Q: What does `kafka-topics --under-replicated-partitions` show?
A: Lists partitions where ISR < replication factor — a sign of broker/network issues.

---

Q: What happens if you shut down a broker that holds a leader replica?
A: The controller elects a new leader from the ISR. If no ISR member exists and `unclean.leader.election.enable=false`, the partition is unavailable.

---

Q: What does `delete.topic.enable` control?
A: Whether topic deletion is permitted. Default is true in recent Kafka versions.

---

Q: What is a Kafka "cluster ID"?
A: A unique identifier (UUID) generated at cluster creation, stored in ZK or the KRaft metadata log. Prevents cross-cluster mistakes.

---

Q: What is `broker.id` vs `node.id`?
A: In ZK mode, `broker.id` identifies the broker. In KRaft, `node.id` serves the same role (plus may reference a controller-only node).

---

Q: How is metadata distributed to brokers?
A: The controller sends `UpdateMetadata` and `LeaderAndIsr` requests. Brokers respond to `Metadata` requests from clients.

---

Q: Do clients connect only to `bootstrap.servers`?
A: No. `bootstrap.servers` is just for initial discovery. After the metadata response, clients connect directly to the leader broker for each partition.

---

Q: What is `advertised.listeners` for?
A: The externally reachable host:port that brokers advertise in metadata responses. Differs from `listeners` (what the broker actually binds to).

---

Q: What is a "listener" in Kafka?
A: A named host:port + security protocol combination the broker listens on. Multiple listeners can coexist.

---

Q: What is the default port for a Kafka broker?
A: 9092 for PLAINTEXT, 9093 for SSL, 9094 commonly for SASL_SSL (configurable).

---

Q: What is the Schema Registry default port?
A: 8081.

---

Q: What is the REST Proxy default port?
A: 8082.

---

Q: What is Confluent Control Center's default port?
A: 9021.

---

Q: What is ksqlDB's default server port?
A: 8088.

---

Q: What is Kafka Connect's default REST port?
A: 8083.

---

Q: What are the three broker thread pools?
A: Network threads (`num.network.threads`), I/O threads (`num.io.threads`), and replica fetcher threads (`num.replica.fetchers`).

---

Q: What is zero-copy transfer?
A: The broker's use of `sendfile()` to transfer bytes from page cache directly to the socket, bypassing user space. Essential for Kafka's high throughput.

---

Q: Why does Kafka rely on the OS page cache?
A: Writes go to the OS cache, then disk asynchronously. Reads usually hit the cache. This is why the JVM heap should NOT be oversized.

---

Q: What is `log.retention.check.interval.ms`?
A: How often the broker scans logs for segments eligible for deletion. Default 300,000 ms (5 min).

---

Q: What is `log.flush.interval.messages`?
A: Number of messages before forcing an fsync. Default is huge (~9 quintillion) — Kafka relies on OS flush + replication, not fsync, for durability.

---

Q: What is `message.timestamp.type`?
A: Topic-level config: `CreateTime` (producer's timestamp) or `LogAppendTime` (broker overwrites with its time).

---

Q: Under `LogAppendTime`, what timestamp is used for retention?
A: The broker's append time (since it's the only timestamp recorded on the segment).

---

Q: What is `max.message.bytes`?
A: Topic-level max record batch size. Default 1,048,588 bytes (~1 MB).

---

Q: What's the difference between record and batch?
A: A record is a single key/value/headers unit. A batch is a group of records sent together — the unit of compression, replication, and protocol-level produce requests.

---

Q: Is compression per-record or per-batch?
A: Per batch. A single-record batch gets minimal compression benefit.

---

Q: What is a "leader epoch"?
A: An integer incremented each time a partition's leader changes. Used for accurate log truncation after leader failover.

---

Q: Where is the leader epoch stored on disk?
A: In the `leader-epoch-checkpoint` file inside each partition's directory.

---

Q: What is the log start offset?
A: The earliest retained offset in the log. Can be advanced by retention or by `kafka-delete-records`.

---
