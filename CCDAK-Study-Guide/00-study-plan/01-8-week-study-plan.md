# 8-Week CCDAK Study Plan

A deliberate, progressive plan designed for an architect who has some Kafka exposure but wants to pass the exam comfortably (targeting **> 85%** on the real exam).

**Daily commitment:** 1.5–2 hours weekdays, 3–4 hours weekends.
**Total hours:** ~90–110.

---

## Week 1 — Foundations

**Goal:** Build rock-solid mental model of Kafka's storage & distribution model.

| Day | Activity | Deliverable |
|----:|----------|------------|
| 1 | Read `01-articles/01-kafka-introduction.md` and `02-kafka-architecture-deep-dive.md` | Draw the commit log from memory |
| 2 | Read `03-brokers-controllers-kraft.md` | List 5 controller responsibilities |
| 3 | Read `04-topics-partitions-replication.md` | Explain ISR vs OSR |
| 4 | Read `05-log-segments-retention.md` | Explain active vs closed segment |
| 5 | Read `06-log-compaction.md` | Describe tombstone lifecycle |
| 6 | Flashcards: `01-fundamentals.md` (50 cards) | 90% recall |
| 7 | Review + Quiz `07-topic-quizzes/01-fundamentals-quiz.md` | Score |

**Hands-on:** Install Confluent Platform locally (or Kafka in Docker). Create topics, produce/consume with console tools.

---

## Week 2 — Producer API

**Goal:** Master producer internals, delivery semantics, and tuning.

| Day | Activity |
|----:|----------|
| 1 | `07-producer-api-deep-dive.md` — Read twice |
| 2 | `08-producer-configuration.md` — Build flashcards of every config default |
| 3 | `09-idempotent-transactional-producer.md` — Understand PID, epoch, sequence number |
| 4 | Flashcards: `02-producer.md` + `09-configuration.md` (producer sections) |
| 5 | Code: run `04-code-examples/java/01-basic-producer` through `04-custom-partitioner` |
| 6 | Code: run `java/03-transactional-producer` end-to-end with a consumer using `isolation.level=read_committed` |
| 7 | Quiz `07-topic-quizzes/02-producer-quiz.md`; review weak areas |

---

## Week 3 — Consumer API

**Goal:** Understand group coordination, rebalances, and commit semantics deeply.

| Day | Activity |
|----:|----------|
| 1 | `10-consumer-api-deep-dive.md` |
| 2 | `11-consumer-groups-rebalancing.md` |
| 3 | `12-offset-management.md` — Trace every commit path |
| 4 | Flashcards: `03-consumer.md` + `09-configuration.md` (consumer sections) |
| 5 | Code: `java/05-basic-consumer`, `java/06-manual-commit`, `java/07-exactly-once-consumer` |
| 6 | Experiment: kill a consumer mid-poll and observe rebalance with Eager vs CooperativeSticky |
| 7 | Quiz `07-topic-quizzes/03-consumer-quiz.md` |

---

## Week 4 — Schema Registry & Serialization

**Goal:** Deeply understand Avro compatibility rules and the wire format.

| Day | Activity |
|----:|----------|
| 1 | `13-serialization-deserialization.md` |
| 2 | `14-schema-registry-deep-dive.md` |
| 3 | `15-schema-compatibility-evolution.md` — memorize the matrix |
| 4 | Flashcards: `06-schema-registry.md` |
| 5 | Code: evolve an Avro schema through BACKWARD, FORWARD, FULL |
| 6 | Practice: draw the wire format from memory (magic byte, schema id, payload) |
| 7 | Quiz `07-topic-quizzes/04-schema-registry-quiz.md` |

---

## Week 5 — Kafka Streams

**Goal:** Be fluent in the DSL, topologies, windowing, and joins.

| Day | Activity |
|----:|----------|
| 1 | `17-kafka-streams-fundamentals.md` + `18-kstream-ktable-globalktable.md` |
| 2 | `19-stateful-operations-state-stores.md` |
| 3 | `20-windowing-in-streams.md` |
| 4 | `21-joins-in-streams.md` — memorize the join matrix |
| 5 | `22-exactly-once-in-streams.md` |
| 6 | Code: run all `streams/*` examples; write your own aggregation |
| 7 | Quiz `07-topic-quizzes/05-streams-quiz.md` |

---

## Week 6 — Connect, ksqlDB, Security

**Goal:** Round out remaining domains.

| Day | Activity |
|----:|----------|
| 1 | `23-kafka-connect-overview.md` + `24-connect-config-smt.md` |
| 2 | `25-ksqldb-deep-dive.md` |
| 3 | `26-security-ssl-sasl.md` |
| 4 | `27-acls-authorization.md` |
| 5 | Flashcards: `05-connect.md`, `07-security.md` |
| 6 | Code: configure a Connect distributed worker + deploy a JDBC source with SMTs |
| 7 | Quiz `07-topic-quizzes/06-connect-quiz.md` and `07-security-quiz.md` |

---

## Week 7 — Operations & Advanced Topics

**Goal:** CLI fluency, monitoring, advanced topics.

| Day | Activity |
|----:|----------|
| 1 | `28-administration-cli.md` — run every CLI command |
| 2 | `29-monitoring-jmx.md` |
| 3 | `30-performance-tuning.md` |
| 4 | `31-mirrormaker2-cluster-linking.md` + `32-rest-proxy.md` |
| 5 | Flashcards: `08-administration.md`, `10-commands-cli.md` |
| 6 | Work through `08-scenarios/` problems 1–8 |
| 7 | Work through `08-scenarios/` problems 9–15 |

---

## Week 8 — Practice Exams & Final Review

**Goal:** Build endurance and close gaps.

| Day | Activity | Target Score |
|----:|----------|-------------:|
| 1 | Practice Exam 1 + detailed review | 70% |
| 2 | Practice Exam 2 + detailed review | 72% |
| 3 | Practice Exam 3 + detailed review | 75% |
| 4 | Practice Exam 4, 5 (shorter rest) | 78%+ |
| 5 | Practice Exam 6, 7 | 80%+ |
| 6 | Practice Exam 8, 9 | 82%+ |
| 7 | Practice Exam 10 — simulate real exam conditions | 85%+ |

**Final 48 hours:**
- Re-read all `05-cheat-sheets/` (30 minutes each morning).
- Re-drill any flashcard deck with <95% recall.
- Read `33-troubleshooting.md` and `34-exam-day-tips.md`.

**Night before exam:**
- Sleep 8 hours.
- Do *not* learn new material.
- Review the one-page `05-cheat-sheets/00-one-pager.md` once.

---

## Grading Your Readiness

You are exam-ready when ALL of the following are true:

1. ≥ 85% on 3 consecutive full practice exams.
2. You can recite (unprompted) the defaults of these configs: `acks`, `retries`, `enable.idempotence`, `max.in.flight.requests.per.connection`, `delivery.timeout.ms`, `request.timeout.ms`, `linger.ms`, `batch.size`, `compression.type`, `auto.offset.reset`, `enable.auto.commit`, `session.timeout.ms`, `heartbeat.interval.ms`, `max.poll.interval.ms`, `max.poll.records`, `fetch.min.bytes`, `fetch.max.wait.ms`, `isolation.level`, `min.insync.replicas`, `replication.factor`.
3. You can draw from memory: producer send path, consumer poll loop, Streams topology, Connect architecture, Schema Registry compatibility matrix.
4. You can solve any scenario in `08-scenarios/` within 4 minutes.
