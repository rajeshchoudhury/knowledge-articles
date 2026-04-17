# Article 1: Introduction to Apache Kafka and the Confluent Platform

## Why Kafka Exists

Apache Kafka was originally built at LinkedIn (2010) to solve a problem that traditional message brokers could not: **reliably moving extremely high volumes of event data between a growing number of producing and consuming systems**, while offering **replayability** and **horizontal scalability**.

Classical message brokers (ActiveMQ, RabbitMQ, IBM MQ) were optimized for:

- Low latency for small volumes
- Complex routing (exchanges, topics hierarchies)
- Per-message acknowledgements that deleted the message after consumption

Kafka flipped these assumptions:

| Traditional Broker | Kafka |
|--------------------|-------|
| Message deleted on ACK | Messages retained for a configured period (time or size) |
| Routing via exchanges | Flat partitioned log per topic |
| Consumer tracks what to read next | Broker stores offsets; consumer controls its own position |
| JMS-style queues/topics | Append-only distributed commit log |
| Push to consumer | Pull from broker |
| Smart broker, dumb consumer | Dumb broker, smart consumer |

## The Distributed Commit Log

The single most important mental model is this: **Kafka is a distributed commit log**.

A commit log is a file where records are appended in order and never mutated. Each record has an offset (a monotonic integer). Kafka takes this primitive and:

1. **Partitions** it so each topic can have many logs running in parallel.
2. **Replicates** each partition across brokers for durability.
3. **Exposes** producer and consumer APIs so clients can append and read.

```
topic "orders" with 3 partitions
┌──────────────────────────────────────────────────────┐
│ Partition 0:  [0][1][2][3][4][5][6][7][8] ...          │
│ Partition 1:  [0][1][2][3][4][5] ...                   │
│ Partition 2:  [0][1][2][3][4][5][6][7] ...             │
└──────────────────────────────────────────────────────┘
```

Each partition's offsets are **independent**. Offset 5 in partition 0 has no relationship with offset 5 in partition 1.

## Key Concepts in 60 Seconds

| Term | Definition |
|------|-----------|
| **Record** | A key/value/headers/timestamp unit written to and read from Kafka |
| **Topic** | Named stream of records, split into partitions |
| **Partition** | Ordered, append-only log; basic unit of parallelism |
| **Offset** | Monotonically increasing ID of a record within a partition |
| **Broker** | A Kafka server process that hosts partition replicas |
| **Cluster** | A set of brokers coordinated by a controller |
| **Producer** | Application that writes records to topics |
| **Consumer** | Application that reads records from topics |
| **Consumer Group** | Set of consumers sharing the load of a topic; each partition consumed by exactly one consumer in the group |
| **Replica** | Copy of a partition on a different broker (for fault tolerance) |
| **ISR** | "In-Sync Replicas" — replicas up-to-date with the leader |
| **Leader** | The replica all reads/writes go through |
| **Follower** | Replicas that fetch from the leader |
| **Controller** | The broker that manages partition leadership and cluster metadata |

## The Confluent Platform

Apache Kafka ships the core brokers and a handful of clients. The **Confluent Platform** is a commercial/enterprise-grade superset with:

| Component | Purpose |
|-----------|---------|
| Kafka Brokers | Core storage/distribution layer |
| ZooKeeper / KRaft | Metadata / leader election (ZK being phased out for KRaft in 3.x+) |
| Schema Registry | Centralized schema management for Avro / Protobuf / JSON Schema |
| Kafka Connect | Framework for streaming data in/out of Kafka via connectors |
| Kafka Streams | Java client library for stream processing |
| ksqlDB | SQL engine on top of Kafka Streams |
| Control Center | GUI for cluster monitoring/management |
| REST Proxy | HTTP API for produce/consume |
| MirrorMaker 2 / Cluster Linking | Cross-cluster replication |
| RBAC / Audit Log | Enterprise security features |

**The CCDAK exam tests:** brokers + producers + consumers + Streams + Connect + Schema Registry + ksqlDB + security basics + CLI. Control Center, RBAC, and Audit Log have only light coverage.

## Key Use Cases

| Pattern | Example |
|---------|---------|
| Messaging | Decoupling microservices |
| Activity tracking | Website clickstream |
| Metrics pipeline | Aggregating ops metrics |
| Log aggregation | Shipping logs to Elastic/Splunk |
| Stream processing | Fraud detection, alerting |
| Event sourcing | Storing every state change as an event |
| Commit log for DBs | Change Data Capture (CDC) via Debezium |

## Delivery Semantics Preview

Kafka supports three delivery semantics between a producer, broker, and consumer:

| Semantic | Description | How to Achieve |
|----------|-------------|----------------|
| **At-most-once** | Data may be lost; never duplicated | `acks=0` or commit before processing |
| **At-least-once** | Data may be duplicated; never lost | `acks=all`, `retries > 0`, manual commits after processing |
| **Exactly-once** | No loss, no duplication | Idempotent producer + transactions + `isolation.level=read_committed` on consumer |

Later articles deeply unpack each.

## Kafka is NOT...

- **Not a database** — no secondary indexes, no ad-hoc queries (ksqlDB is the closest you get).
- **Not a file system** — although it stores bytes durably.
- **Not a work queue** — although it can be used as one with consumer groups.
- **Not synchronous RPC** — it is fundamentally async.

## Exam Pointers

- The CCDAK exam repeatedly tests that **offsets are per-partition** — there is no global order across a topic.
- The exam expects you to know that **ordering is guaranteed within a partition, never across partitions** (unless there is only one partition).
- The exam treats "topic" and "partition" distinctly — a partition can have at most one leader; a topic has as many leaders as partitions.
- **Brokers don't push** — consumers always pull (via fetch requests).
