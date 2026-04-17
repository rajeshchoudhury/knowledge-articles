# Article 23: Kafka Connect Overview

## What is Kafka Connect?

A **framework** for integrating Kafka with external systems via pluggable **connectors**. Think of it as a scalable, fault-tolerant engine for data integration.

Two roles:
- **Source connector** — pulls data from an external system and produces to Kafka.
- **Sink connector** — consumes from Kafka and pushes to an external system.

Connect is written in Java and runs as a separate process (or cluster of processes). It's part of the Apache Kafka distribution.

**Key benefits:**
- No custom code needed for common integrations (JDBC, S3, Elastic, MongoDB, Salesforce, etc.).
- Built-in fault tolerance, scaling, offset management, and monitoring.
- Standardized REST API and config model.

## Standalone vs Distributed Mode

### Standalone

- Single process.
- Config: properties files (connector + worker).
- Offsets stored in a **local file**.
- No fault tolerance.
- Use for development, testing, one-off jobs.

```bash
bin/connect-standalone.sh config/worker.properties config/connector-1.properties
```

### Distributed

- One or more worker processes forming a cluster.
- Config: REST API (connector configs live in Kafka topics).
- Offsets, statuses, configs persisted in **Kafka internal topics**.
- Automatic failover: if a worker dies, its tasks are redistributed.
- **Production standard.**

```bash
bin/connect-distributed.sh config/worker.properties
```

## Architecture

```
┌───────────────────────────────────────────────────────┐
│               Connect Worker Cluster                   │
│    ┌────────────┐ ┌────────────┐ ┌────────────┐       │
│    │  Worker 1  │ │  Worker 2  │ │  Worker 3  │       │
│    │  tasks:    │ │  tasks:    │ │  tasks:    │       │
│    │  C1-t1,    │ │  C1-t2,    │ │  C2-t1,    │       │
│    │  C3-t1     │ │  C3-t2     │ │  C1-t3     │       │
│    └────────────┘ └────────────┘ └────────────┘       │
│                       ↓                                │
│    Internal Topics: connect-configs (compact)          │
│                     connect-offsets (compact)          │
│                     connect-status (compact)           │
└───────────────────────────────────────────────────────┘
            ↓            ↓            ↓
        Kafka      External      External
        Topics     Systems (Source/Sink)
```

- **Workers** are JVM processes; each can run multiple tasks.
- **Connectors** are the logical integration definitions.
- **Tasks** are the runtime units; each task reads/writes a share of the data.
- Each task is a thread.

## Connectors and Tasks

A **connector** is a Java class (e.g., `JdbcSourceConnector`, `S3SinkConnector`) configured via key-value properties. When you POST the config:

1. The connector's `taskConfigs(maxTasks)` produces a list of task configurations.
2. Each task is assigned to a worker.
3. Tasks pull/push data independently.

`tasks.max` is a connector-level setting: the desired parallelism. The actual number may be less (e.g., if a JDBC source has 2 tables, only 2 tasks are useful regardless of `tasks.max=10`).

Reconfiguring `tasks.max` triggers a rebalance.

## REST API (Distributed)

Base: `http://connect-host:8083/`

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/` | Cluster info |
| GET | `/connectors` | List connectors |
| POST | `/connectors` | Create a connector |
| PUT | `/connectors/{name}/config` | Update config (creates if absent) |
| GET | `/connectors/{name}` | Get config |
| GET | `/connectors/{name}/status` | Status + task states |
| GET | `/connectors/{name}/tasks` | List tasks |
| GET | `/connectors/{name}/tasks/{id}/status` | Task status |
| POST | `/connectors/{name}/restart` | Restart the connector |
| POST | `/connectors/{name}/tasks/{id}/restart` | Restart a task |
| PUT | `/connectors/{name}/pause` | Pause |
| PUT | `/connectors/{name}/resume` | Resume |
| DELETE | `/connectors/{name}` | Delete |
| GET | `/connector-plugins` | List installed plugin classes |
| PUT | `/connector-plugins/{type}/config/validate` | Validate config without creating |

## Connector Config

Minimum viable config:

```json
{
  "name": "orders-to-s3",
  "config": {
    "connector.class": "io.confluent.connect.s3.S3SinkConnector",
    "tasks.max": "4",
    "topics": "orders",
    "s3.bucket.name": "my-bucket",
    "s3.region": "us-east-1",
    "format.class": "io.confluent.connect.s3.format.avro.AvroFormat",
    "key.converter": "org.apache.kafka.connect.storage.StringConverter",
    "value.converter": "io.confluent.connect.avro.AvroConverter",
    "value.converter.schema.registry.url": "http://schema-registry:8081"
  }
}
```

POST to `http://connect:8083/connectors`.

## Converters

Convert Connect's internal data representation (`SchemaAndValue`) to/from Kafka bytes.

| Converter | Class | Schema Registry |
|-----------|-------|-----------------|
| String | `org.apache.kafka.connect.storage.StringConverter` | No |
| ByteArray | `org.apache.kafka.connect.converters.ByteArrayConverter` | No |
| JSON (without schema) | `org.apache.kafka.connect.json.JsonConverter` with `schemas.enable=false` | No |
| JSON (with schema) | `JsonConverter` with `schemas.enable=true` | No (schema embedded inline) |
| Avro | `io.confluent.connect.avro.AvroConverter` | YES |
| Protobuf | `io.confluent.connect.protobuf.ProtobufConverter` | YES |
| JSON Schema | `io.confluent.connect.json.JsonSchemaConverter` | YES |

Key and value converters are set independently:

```
key.converter=org.apache.kafka.connect.storage.StringConverter
value.converter=io.confluent.connect.avro.AvroConverter
value.converter.schema.registry.url=http://schema-registry:8081
```

## Error Handling

| Config | Default | Effect |
|--------|---------|--------|
| `errors.tolerance` | `none` | `none` = fail; `all` = skip/redirect |
| `errors.log.enable` | false | Log errors |
| `errors.log.include.messages` | false | Include full record in logs (sensitive!) |
| `errors.deadletterqueue.topic.name` | — | DLQ topic (sink only) |
| `errors.deadletterqueue.context.headers.enable` | false | Add error context to DLQ record headers |
| `errors.deadletterqueue.topic.replication.factor` | 3 | |
| `errors.retry.timeout` | 0 | Retry on retriable errors |
| `errors.retry.delay.max.ms` | 60000 | Max backoff |

DLQ only applies to **sink** connectors. It captures records that cannot be deserialized or cannot be written to the target.

## Internal Topics (Distributed Mode)

| Topic | Purpose |
|-------|---------|
| `connect-configs` | Connector configs |
| `connect-offsets` | Source connector offsets |
| `connect-status` | Connector/task status |

All are **compacted** and must have `cleanup.policy=compact`.

Group ID (`group.id` in worker config) must be unique per Connect cluster — not shared with consumer groups.

## Offset Management

### Source connectors

Offsets are source-system specific (e.g., database rowid, file byte offset, Kinesis sequence number). Connect stores them in `connect-offsets` keyed by `(connector, partition)`.

### Sink connectors

Sink connectors use Kafka consumer offsets — they participate in a consumer group named `connect-<connector-name>` by default.

## Common Connectors

| Connector | Type | Use |
|-----------|------|-----|
| JDBC Source/Sink | Both | RDBMS integration |
| Debezium (various DBs) | Source | Change Data Capture |
| S3 Source/Sink | Both | Data lake integration |
| Elasticsearch Sink | Sink | Search indexing |
| HDFS Source/Sink | Both | Big data warehouse |
| MongoDB Source/Sink | Both | MongoDB integration |
| Salesforce Source/Sink | Both | Salesforce CDC / push |
| HTTP Sink | Sink | Push to HTTP endpoints |
| FileStream Source/Sink | Both | Dev/test only — not for prod |

## Exam Pointers

- **Distributed mode** is production-standard; standalone is dev-only.
- Offsets for source connectors are in `connect-offsets`; for sink connectors, in `__consumer_offsets` under a `connect-<name>` group.
- Three internal topics: `connect-configs`, `connect-offsets`, `connect-status` — all **compacted**.
- **DLQ only applies to sink connectors** (`errors.deadletterqueue.topic.name`).
- `key.converter` and `value.converter` are set independently.
- Confluent's Avro/Protobuf/JSON Schema converters REQUIRE `schema.registry.url`.
- Connect runs as its own process, not inside brokers.
- `tasks.max` is a hint; the connector can choose fewer tasks.
