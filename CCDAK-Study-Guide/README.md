# Confluent Certified Developer for Apache Kafka (CCDAK) — Complete Study Guide

> A comprehensive, architect-grade study package designed to be **sufficient on its own** to pass the CCDAK certification with confidence.

---

## About the Certification

- **Official Name:** Confluent Certified Developer for Apache Kafka (CCDAK)
- **Target Audience:** Developers, architects, and engineers who design, build, and test applications using Apache Kafka and the Confluent Platform.
- **Format:** Multiple choice / multiple response
- **Number of Questions:** ~60
- **Duration:** 90 minutes
- **Passing Score:** ~70% (Confluent does not publish an exact number; most sources place it between 68–75%)
- **Delivery:** Online, proctored (Examity / PSI)
- **Recertification:** Every 2 years
- **Prerequisite Knowledge:** 6–12 months of hands-on Kafka development
- **Cost:** USD 150 (at time of writing)

### Exam Domains (Approximate Weights)

| Domain | Approx. Weight |
|-------|---------------:|
| Application Design | 40% |
| Development | 30% |
| Deployment / Testing / Monitoring | 30% |

The exam is heavily developer-focused. Unlike the Administrator exam, CCDAK focuses on **client-side** concerns: producers, consumers, Streams, Connect, Schema Registry, ksqlDB, serialization, client configuration, error handling, and testing — with just enough cluster/broker knowledge to reason about client behavior.

---

## How to Use This Study Guide

This guide is organized as an end-to-end preparation path:

```
CCDAK-Study-Guide/
├── 00-study-plan/        ← Start here: the 8-week plan
├── 01-articles/          ← 30+ deep-dive topic articles
├── 02-flashcards/        ← 500+ spaced-repetition flashcards
├── 03-diagrams/          ← Mermaid & ASCII architecture diagrams
├── 04-code-examples/     ← Java, Python, and config snippets
├── 05-cheat-sheets/      ← One-page quick references
├── 06-practice-exams/    ← 10 full practice exams (600+ Qs)
├── 07-topic-quizzes/     ← Domain-focused mini-quizzes
└── 08-scenarios/         ← Scenario-based architecture problems
```

### Recommended Path

1. **Week 0 — Orientation:** Read `00-study-plan/00-exam-blueprint.md` and `00-study-plan/01-8-week-study-plan.md`.
2. **Weeks 1–6 — Content Mastery:** Work through `01-articles/` in order; drill `02-flashcards/` daily; study the diagrams.
3. **Week 7 — Hands-On Labs:** Run every snippet in `04-code-examples/`. Deploy a local cluster, produce/consume, run Streams apps, and configure Connect.
4. **Week 8 — Practice & Gap-Fill:** Take all 10 practice exams; retake weak domains via `07-topic-quizzes/`; review `05-cheat-sheets/`.

---

## Topic Coverage Map

### Fundamentals & Architecture
- Brokers, controllers, KRaft vs ZooKeeper
- Topics, partitions, replicas, ISR
- Log segments, retention, compaction
- Leader election & high watermark

### Producer API
- Delivery semantics: at-most-once, at-least-once, exactly-once
- `acks`, `retries`, `enable.idempotence`, `max.in.flight.requests.per.connection`
- Batching: `linger.ms`, `batch.size`, compression
- Partitioning strategies (DefaultPartitioner, UniformSticky, custom)
- Transactions & read-process-write patterns

### Consumer API
- Consumer groups, group coordinator, static membership
- Poll loop, `max.poll.interval.ms`, `max.poll.records`
- Rebalance protocols: Eager, Cooperative Sticky, Incremental
- Offset commit: auto vs sync vs async; `isolation.level`
- Fetch tuning: `fetch.min.bytes`, `fetch.max.wait.ms`

### Schema Registry
- Avro, Protobuf, JSON Schema
- Subject naming strategies (TopicName, RecordName, TopicRecordName)
- Compatibility modes: BACKWARD, BACKWARD_TRANSITIVE, FORWARD, FORWARD_TRANSITIVE, FULL, FULL_TRANSITIVE, NONE
- Schema evolution rules per serializer

### Kafka Streams
- KStream, KTable, GlobalKTable semantics
- Stateless vs stateful operations
- Windowing: tumbling, hopping, sliding, session
- Joins: KS-KS, KS-KT, KS-GKT, KT-KT
- State stores, RocksDB, standby replicas
- Exactly-once processing guarantees (EOS v1/v2)
- Topology, sub-topologies, tasks, threads

### Kafka Connect
- Source vs Sink connectors
- Standalone vs Distributed mode
- Converters (Avro, JSON, String, ByteArray)
- Single Message Transforms (SMTs)
- Dead Letter Queue (DLQ) & error handling
- REST API

### ksqlDB
- STREAM vs TABLE
- Pull vs Push queries
- Materialized views, CTAS/CSAS

### Security
- SSL/TLS encryption & mutual auth
- SASL: PLAIN, SCRAM-SHA-256/512, GSSAPI, OAUTHBEARER
- ACLs & Role-Based Access Control (RBAC)
- Principal resolution

### Administration & Tooling
- CLI: `kafka-topics`, `kafka-console-*`, `kafka-consumer-groups`, `kafka-configs`, `kafka-acls`, `kafka-reassign-partitions`
- Dynamic config updates
- MirrorMaker 2 & Cluster Linking
- REST Proxy

### Monitoring & Performance
- Key JMX metrics (producer, consumer, broker)
- Under-replicated partitions, request latencies
- Client-side tuning

---

## Quick Index

| File | What It Contains |
|------|------------------|
| [`00-study-plan/00-exam-blueprint.md`](00-study-plan/00-exam-blueprint.md) | Official objectives mapped to study resources |
| [`00-study-plan/01-8-week-study-plan.md`](00-study-plan/01-8-week-study-plan.md) | Day-by-day study schedule |
| [`00-study-plan/02-exam-day-checklist.md`](00-study-plan/02-exam-day-checklist.md) | What to do 24 hours before and during the exam |
| [`01-articles/`](01-articles/) | 30+ deep-dive articles |
| [`02-flashcards/`](02-flashcards/) | Topical flashcard decks (500+ cards) |
| [`03-diagrams/`](03-diagrams/) | Architectural Mermaid diagrams |
| [`04-code-examples/`](04-code-examples/) | Runnable Java/Python/YAML examples |
| [`05-cheat-sheets/`](05-cheat-sheets/) | Configuration & CLI quick references |
| [`06-practice-exams/`](06-practice-exams/) | 10 full-length practice exams |
| [`07-topic-quizzes/`](07-topic-quizzes/) | Domain-focused drills |
| [`08-scenarios/`](08-scenarios/) | Scenario-based architecture problems |

---

## Study Philosophy

The CCDAK exam rewards **precise knowledge of defaults, failure modes, and configuration interactions**. Memorizing isolated facts is not enough; you must be able to reason about:

- Why `acks=all + min.insync.replicas=2 + enable.idempotence=true` gives exactly-once-per-partition at the producer side.
- Why a consumer group with 4 consumers on a 3-partition topic wastes one consumer.
- Why a `KTable.join(KTable)` needs co-partitioning but a join with a `GlobalKTable` does not.
- When a `FULL_TRANSITIVE` schema compatibility is needed over `FULL`.
- What happens to offsets when `auto.offset.reset=earliest` and a new group connects to an existing topic.

Every article in this guide emphasizes these **interaction effects** and is punctuated by worked examples.

Good luck — and remember: the exam tests the *mental model*, not trivia. If you understand the protocol, the answers follow.
