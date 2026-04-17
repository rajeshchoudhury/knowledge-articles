# CCDAK Exam Blueprint — Official Objectives Mapped

## Scoring Weights (Approximate)

| Domain | Weight | What It Tests |
|--------|-------:|---------------|
| **Application Design** | 40% | Architecting producers/consumers, choosing serialization, designing for EOS, topic/partition design, schema governance, consumer group design |
| **Development** | 30% | Writing producer/consumer/Streams code, Connect config, testing with TopologyTestDriver, embedded Kafka, error handling |
| **Deployment / Testing / Monitoring** | 30% | Client config tuning, monitoring metrics, diagnosing issues, CLI usage, security configuration, connectors in production |

## Detailed Objectives → Study Map

### 1. Apache Kafka Fundamentals

| Objective | Articles | Flashcards | Code |
|-----------|----------|------------|------|
| Understand the Kafka distributed commit log | 01-01, 01-02 | 01-fundamentals | — |
| Brokers, controllers, KRaft vs ZooKeeper | 01-03 | 01-fundamentals | — |
| Topics, partitions, replicas, ISR | 01-04, 01-05 | 01-fundamentals | — |
| Log segments, retention, compaction, tombstones | 01-06 | 01-fundamentals | — |

### 2. Producer API

| Objective | Articles | Flashcards | Code |
|-----------|----------|------------|------|
| Producer architecture: RecordAccumulator, Sender | 01-07 | 02-producer | java/01-basic-producer |
| Configuration: acks, retries, timeouts | 01-07, 01-08 | 02-producer, 09-configuration | java/02-tuned-producer |
| Idempotence, transactions | 01-09 | 02-producer | java/03-transactional-producer |
| Serializers, custom partitioners | 01-08 | 02-producer | java/04-custom-partitioner |
| Delivery semantics (at-most-once, at-least-once, EOS) | 01-09, 01-23 | 02-producer | — |

### 3. Consumer API

| Objective | Articles | Flashcards | Code |
|-----------|----------|------------|------|
| Consumer groups, group coordinator | 01-10 | 03-consumer | java/05-basic-consumer |
| Rebalance protocols (Eager, CooperativeSticky) | 01-11 | 03-consumer | — |
| Offset management, isolation.level | 01-12 | 03-consumer | java/06-manual-commit |
| Poll loop mechanics, max.poll.interval.ms | 01-10 | 03-consumer, 09-configuration | — |
| Static group membership | 01-11 | 03-consumer | — |

### 4. Schema Registry & Serialization

| Objective | Articles | Flashcards | Code |
|-----------|----------|------------|------|
| Avro/Protobuf/JSON Schema serialization | 01-13, 01-14 | 06-schema-registry | java/07-avro-producer |
| Compatibility modes & evolution rules | 01-15 | 06-schema-registry | — |
| Subject naming strategies | 01-15 | 06-schema-registry | configs/ |
| Wire format (magic byte + schema id) | 01-14 | 06-schema-registry | — |

### 5. Kafka Streams

| Objective | Articles | Flashcards | Code |
|-----------|----------|------------|------|
| KStream, KTable, GlobalKTable | 01-17, 01-18 | 04-streams | streams/01-word-count |
| Stateful vs stateless transformations | 01-19 | 04-streams | streams/02-aggregation |
| Windowing (tumbling/hopping/sliding/session) | 01-20 | 04-streams | streams/03-windowing |
| Joins (KS-KS, KS-KT, KS-GKT, KT-KT) | 01-21 | 04-streams | streams/04-joins |
| Exactly-once semantics | 01-22 | 04-streams | streams/05-eos |
| State stores, standby replicas | 01-19 | 04-streams | — |
| Interactive queries | 01-17 | 04-streams | — |
| Testing with TopologyTestDriver | 01-17 | 04-streams | streams/06-test |

### 6. Kafka Connect

| Objective | Articles | Flashcards | Code |
|-----------|----------|------------|------|
| Source vs Sink connectors | 01-23 | 05-connect | connect/ |
| Standalone vs Distributed mode | 01-23 | 05-connect | — |
| Converters, SMTs, DLQ | 01-24 | 05-connect | connect/ |
| REST API for management | 01-24 | 05-connect | — |

### 7. ksqlDB

| Objective | Articles | Flashcards | Code |
|-----------|----------|------------|------|
| Streams vs Tables | 01-25 | 04-streams | — |
| Pull vs Push queries, CTAS/CSAS | 01-25 | 04-streams | — |

### 8. Security

| Objective | Articles | Flashcards | Code |
|-----------|----------|------------|------|
| SSL/TLS with mutual auth | 01-26 | 07-security | configs/ |
| SASL (PLAIN, SCRAM, GSSAPI, OAUTHBEARER) | 01-26 | 07-security | configs/ |
| ACLs & RBAC | 01-27 | 07-security | — |

### 9. Administration / Operations

| Objective | Articles | Flashcards | Code |
|-----------|----------|------------|------|
| CLI tools | 01-28 | 08-administration, 10-commands-cli | — |
| MirrorMaker 2, Cluster Linking | 01-31 | 08-administration | — |
| REST Proxy | 01-32 | 08-administration | — |

### 10. Monitoring & Performance

| Objective | Articles | Flashcards | Code |
|-----------|----------|------------|------|
| JMX metrics | 01-29 | 08-administration | — |
| Client tuning | 01-30 | 02-producer, 03-consumer | — |
| Troubleshooting | 01-33 | All decks | — |

## Key Skills Checklist

Before sitting the exam, confirm you can:

- [ ] Explain end-to-end what happens when `producer.send()` is called with `acks=all` and `enable.idempotence=true`.
- [ ] Sketch how a consumer group rebalances when one consumer dies under Cooperative Sticky.
- [ ] Choose between KTable and GlobalKTable for a join given co-partitioning constraints.
- [ ] Compute the maximum parallelism for a topology with N sub-topologies and P partitions.
- [ ] List all side effects of adding a field with default = null to an Avro schema under BACKWARD vs FORWARD compatibility.
- [ ] Interpret `__consumer_offsets`, `__transaction_state`, `_schemas`, `_confluent-command` internal topics.
- [ ] Configure a transactional producer + read_committed consumer with correct `transactional.id` and `isolation.level`.
- [ ] Recognize the four SMT types and when to use them.
- [ ] Name every client configuration needed for SASL/SCRAM + SSL mutual auth.
- [ ] Decide when `ERROR`/`NONE` log behavior should trigger a DLQ in Connect.
