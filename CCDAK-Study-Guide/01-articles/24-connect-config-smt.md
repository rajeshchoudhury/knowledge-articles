# Article 24: Connect Configuration & Single Message Transforms (SMTs)

## Worker Configuration

A Connect worker's properties file controls cluster-level behavior.

### Core Configs (Distributed Mode)

| Config | Purpose |
|--------|---------|
| `bootstrap.servers` | Kafka cluster |
| `group.id` | Unique per Connect cluster (not a consumer group ID reuse) |
| `config.storage.topic` | Default: `connect-configs` |
| `offset.storage.topic` | Default: `connect-offsets` |
| `status.storage.topic` | Default: `connect-status` |
| `config.storage.replication.factor` | Default 3 |
| `offset.storage.replication.factor` | Default 3 |
| `status.storage.replication.factor` | Default 3 |
| `offset.storage.partitions` | Default 25 |
| `status.storage.partitions` | Default 5 |
| `config.storage.partitions` | **Must be 1** (Connect relies on this) |
| `key.converter` / `value.converter` | Worker-level default converters |
| `internal.key.converter` / `internal.value.converter` | For internal topics (default `JsonConverter` without schemas) |
| `plugin.path` | Where connector jars live (CSV of paths) |
| `rest.host.name`, `rest.port` | REST API endpoint |
| `listeners` | Alternative to host/port |

### Producer / Consumer Overrides

Workers use internal producers (for sources) and consumers (for sinks). Override with prefixes:

```
producer.acks=all
producer.compression.type=lz4
consumer.max.poll.records=500
consumer.auto.offset.reset=earliest
```

Per-connector overrides (added 2.3+):

```
producer.override.compression.type=zstd
consumer.override.auto.offset.reset=latest
```

Requires worker config `connector.client.config.override.policy=All` (or `Principal` / `None`).

## Connector Configuration (Detail)

### Required (all)

- `name` — unique within the cluster
- `connector.class` — FQN of the connector class
- `tasks.max` — desired parallelism

### Source connector additions

- Source-system-specific (connection URL, table list, etc.)
- `topic` or `topics.prefix` — where to write
- `transforms` — pipeline of SMTs

### Sink connector additions

- `topics` or `topics.regex` — sources
- Target-system-specific (bucket, URL, etc.)

## Single Message Transforms (SMTs)

Modify records as they pass through Connect — before serialization (source) or after deserialization (sink).

### Invocation

```
transforms=insertHost,renameField,castInt
transforms.insertHost.type=org.apache.kafka.connect.transforms.InsertField$Value
transforms.insertHost.static.field=host
transforms.insertHost.static.value=prod-001

transforms.renameField.type=org.apache.kafka.connect.transforms.ReplaceField$Value
transforms.renameField.renames=old:new

transforms.castInt.type=org.apache.kafka.connect.transforms.Cast$Value
transforms.castInt.spec=id:int64
```

Key points:
- `transforms=x,y,z` is an **ordered pipeline**.
- Each transform has a `type` and its own prefixed configs.
- `$Key` vs `$Value` suffixes: operate on the record's key or value.

### Built-in SMTs

| SMT | Purpose |
|-----|---------|
| `InsertField` | Add a static field or metadata (topic, offset, partition, timestamp) |
| `ReplaceField` | Rename fields, include/exclude by whitelist/blacklist |
| `MaskField` | Mask PII fields |
| `ValueToKey` | Copy value fields to key |
| `HoistField` | Wrap primitive in struct |
| `ExtractField` | Extract single field from struct |
| `SetSchemaMetadata` | Change schema name/version |
| `TimestampRouter` | Route to topic based on timestamp |
| `RegexRouter` | Rename topic via regex |
| `Cast` | Change field types |
| `TimestampConverter` | Convert string ↔ epoch millis ↔ Date |
| `Filter` (2.6+) | Drop records matching condition |
| `Flatten` | Flatten nested structs to dotted keys |
| `HeaderFrom` | Move fields to headers |
| `DropHeaders` | Remove specified headers |

### Predicate Support

Transforms can be conditioned with `predicates`:

```
predicates=hasError
predicates.hasError.type=org.apache.kafka.connect.transforms.predicates.HasHeaderKey
predicates.hasError.name=error

transforms=dropErrors
transforms.dropErrors.type=org.apache.kafka.connect.transforms.Filter
transforms.dropErrors.predicate=hasError
```

### SMT Pipeline Order

Transforms run in order. A source connector's record passes through:

1. Raw data from source system.
2. Connector converts to `SchemaAndValue`.
3. Transforms apply in order.
4. Converter serializes to bytes.
5. Producer sends.

For sinks, reverse order (but SMTs still run left-to-right).

## Converter Detail

### JsonConverter with Schemas

```
value.converter=org.apache.kafka.connect.json.JsonConverter
value.converter.schemas.enable=true
```

Output:
```json
{
  "schema": {"type": "struct", "fields": [...]},
  "payload": {"id": 1, "name": "Alice"}
}
```

Pros: no schema registry needed.
Cons: verbose; schemas on every record.

### JsonConverter without Schemas

```
value.converter=org.apache.kafka.connect.json.JsonConverter
value.converter.schemas.enable=false
```

Output:
```json
{"id": 1, "name": "Alice"}
```

Pros: compact.
Cons: downstream consumers can't reconstruct types.

### AvroConverter

```
value.converter=io.confluent.connect.avro.AvroConverter
value.converter.schema.registry.url=http://schema-registry:8081
value.converter.basic.auth.user.info=user:pass
value.converter.basic.auth.credentials.source=USER_INFO
```

Uses Schema Registry — compact and evolution-friendly.

## Dead Letter Queue (DLQ) Configuration

```
errors.tolerance=all
errors.deadletterqueue.topic.name=orders.dlq
errors.deadletterqueue.topic.replication.factor=3
errors.deadletterqueue.context.headers.enable=true
errors.log.enable=true
errors.log.include.messages=true
```

With `context.headers.enable=true`, the DLQ record has headers like `__connect.errors.topic`, `__connect.errors.partition`, `__connect.errors.offset`, `__connect.errors.exception.class.name`, `__connect.errors.exception.message`, `__connect.errors.exception.stacktrace`.

## Monitoring Connectors

### Via REST:

```bash
curl http://connect:8083/connectors/orders-to-s3/status
```

Returns:
```json
{
  "name": "orders-to-s3",
  "connector": {"state": "RUNNING", "worker_id": "host1:8083"},
  "tasks": [
    {"id": 0, "state": "RUNNING", "worker_id": "host1:8083"},
    {"id": 1, "state": "FAILED", "worker_id": "host2:8083", "trace": "..."}
  ]
}
```

### Via JMX

- `connect-worker-metrics` — task counts, worker rebalance info.
- `connect-connector-metrics` — records processed, errors.
- `connect-source-task-metrics` — source-specific.
- `connect-sink-task-metrics` — sink-specific.

## Common Configuration Recipes

### JDBC Source (Polling)

```json
{
  "name": "mysql-source",
  "config": {
    "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector",
    "tasks.max": "3",
    "connection.url": "jdbc:mysql://db:3306/sales",
    "connection.user": "user",
    "connection.password": "pass",
    "table.whitelist": "orders,customers",
    "mode": "timestamp+incrementing",
    "timestamp.column.name": "updated_at",
    "incrementing.column.name": "id",
    "topic.prefix": "mysql-",
    "poll.interval.ms": "5000"
  }
}
```

### S3 Sink

```json
{
  "name": "s3-sink",
  "config": {
    "connector.class": "io.confluent.connect.s3.S3SinkConnector",
    "tasks.max": "6",
    "topics": "orders",
    "s3.bucket.name": "kafka-archive",
    "s3.region": "us-east-1",
    "storage.class": "io.confluent.connect.s3.storage.S3Storage",
    "format.class": "io.confluent.connect.s3.format.parquet.ParquetFormat",
    "partitioner.class": "io.confluent.connect.storage.partitioner.TimeBasedPartitioner",
    "partition.duration.ms": "3600000",
    "path.format": "'year'=YYYY/'month'=MM/'day'=dd/'hour'=HH",
    "timezone": "UTC",
    "locale": "en-US",
    "flush.size": "10000",
    "rotate.interval.ms": "60000"
  }
}
```

## Exam Pointers

- SMTs run in **order** as specified in `transforms=` CSV.
- SMTs have `$Key` or `$Value` suffix; default is `$Value`.
- Predicates gate whether an SMT runs for a given record.
- DLQ config only applies to **sink connectors**.
- `errors.tolerance=all` without a DLQ silently drops bad records.
- `config.storage.partitions` **must be 1** (never tunable beyond that).
- Converter settings cascade: worker-level → connector-level overrides.
- Schema-Registry-backed converters need URL + auth config on the converter.
