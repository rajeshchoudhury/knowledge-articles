# Article 14: Schema Registry Deep Dive

## What Is Schema Registry?

A standalone HTTP service (port 8081 by default) that:

- Stores schemas by **subject**.
- Assigns a **global monotonic schema ID** to each unique schema.
- Enforces a **compatibility mode** when evolving schemas.
- Exposes a REST API.

The registry itself is backed by a compacted Kafka topic: `_schemas`. The registry is stateless from the operator's perspective — all persistent state is in Kafka.

## Subjects

A **subject** is a named grouping of schemas. By convention, subjects map to topics:

- `orders-value` — schemas for the value of topic `orders`.
- `orders-key` — schemas for the key of topic `orders`.

This convention is the default (`TopicNameStrategy`). Others exist (see below).

Within a subject, schemas are **versioned** (1, 2, 3, ...). The registry enforces the compatibility rule when a new version is registered.

## REST API Essentials

| Endpoint | Purpose |
|----------|---------|
| `POST /subjects/{subject}/versions` | Register a new schema |
| `GET /subjects/{subject}/versions` | List version numbers |
| `GET /subjects/{subject}/versions/{id}` | Get a specific version (use `latest` for the latest) |
| `GET /schemas/ids/{id}` | Get schema by global ID |
| `GET /subjects` | List all subjects |
| `DELETE /subjects/{subject}` | Soft-delete |
| `DELETE /subjects/{subject}?permanent=true` | Hard-delete |
| `GET /config` | Global compatibility |
| `PUT /config` | Set global compatibility |
| `GET /config/{subject}` | Subject-level compatibility |
| `PUT /config/{subject}` | Set subject-level compatibility |
| `POST /compatibility/subjects/{subject}/versions/{id}` | Check without registering |
| `GET /mode`, `PUT /mode` | READWRITE / READONLY / IMPORT |

## Example: Registering a Schema

```bash
curl -X POST http://schema-registry:8081/subjects/orders-value/versions \
  -H "Content-Type: application/vnd.schemaregistry.v1+json" \
  -d '{
    "schemaType": "AVRO",
    "schema": "{\"type\":\"record\",\"name\":\"Order\",\"fields\":[{\"name\":\"id\",\"type\":\"string\"}]}"
}'
```

Response:
```json
{"id": 42}
```

## Subject Naming Strategies

Configured on the producer's serializer:

| Strategy | Subject Format | Use Case |
|----------|---------------|----------|
| `TopicNameStrategy` (default) | `<topic>-value` / `<topic>-key` | One schema per topic |
| `RecordNameStrategy` | `<fully.qualified.record.name>` | Multiple record types across topics |
| `TopicRecordNameStrategy` | `<topic>-<fully.qualified.record.name>` | Multiple record types per topic, but versioned per topic |

Configured via:

```
value.subject.name.strategy=io.confluent.kafka.serializers.subject.TopicNameStrategy
key.subject.name.strategy=io.confluent.kafka.serializers.subject.TopicNameStrategy
```

### TopicNameStrategy

```
topic "orders" →
  subject "orders-value" (for values)
  subject "orders-key" (for keys)
```

Simplest and most common. Forces one schema per topic — great for event stream homogeneity.

### RecordNameStrategy

```
record com.acme.Order → subject "com.acme.Order"
```

Lets you produce different record types to the same topic (event-sourcing style). Subject is decoupled from topic name.

### TopicRecordNameStrategy

```
topic "orders" + record com.acme.OrderCreated →
  subject "orders-com.acme.OrderCreated"
```

Best of both: multiple record types per topic, still discoverable by topic.

## Client-Side Workflow

### Producer side (`KafkaAvroSerializer`):

1. Serialize the payload with Avro.
2. Compute subject name using the configured strategy.
3. Check the local cache for this schema.
4. If not cached:
   - If `auto.register.schemas=true`: POST `/subjects/{subject}/versions`, get ID.
   - If `use.latest.version=true`: GET `/subjects/{subject}/versions/latest` and use that schema's ID (and serialize with it).
   - Otherwise: fail.
5. Prepend magic byte + 4-byte schema ID to the payload.

### Consumer side (`KafkaAvroDeserializer`):

1. Read magic byte — fail if not 0.
2. Read 4-byte schema ID.
3. Check local cache.
4. If not cached: GET `/schemas/ids/{id}`, fetch the schema.
5. If `specific.avro.reader=true`: instantiate the generated class.
6. Use the consumer's schema (if configured) for Avro's **schema resolution** — allowing reader ≠ writer.

## Reader vs Writer Schema (Avro Specific)

Avro famously supports reader/writer schema resolution:

- **Writer schema** — the schema used when the record was serialized.
- **Reader schema** — the schema the consumer wants to read with.

Avro resolves type compatibility at deserialization. Field added in writer but not in reader → dropped. Field in reader but not writer → filled with default (or error if no default).

Reader schema is set via `KafkaAvroDeserializer` options (or implicitly by the generated class version used).

## Schema Registry Modes

| Mode | Behavior |
|------|----------|
| `READWRITE` (default) | Normal read/write |
| `READONLY` | No schema registration allowed |
| `READONLY_OVERRIDE` | Subject-level override |
| `IMPORT` | Allows schema import with a specified ID (used during migration) |

## Global vs Subject Compatibility

Compatibility can be set globally (applies to all subjects unless overridden) or per subject.

```bash
# global
curl -X PUT -H "Content-Type: application/vnd.schemaregistry.v1+json" \
  --data '{"compatibility": "BACKWARD"}' \
  http://schema-registry:8081/config

# subject
curl -X PUT -H "Content-Type: application/vnd.schemaregistry.v1+json" \
  --data '{"compatibility": "FULL_TRANSITIVE"}' \
  http://schema-registry:8081/config/orders-value
```

## Soft vs Hard Delete

- **Soft delete** (`DELETE /subjects/{subject}`) — marks as deleted but keeps it for lookup by ID. Schema can be restored.
- **Hard delete** (`DELETE /subjects/{subject}?permanent=true`) — removes permanently. Requires soft-delete first.

**Warning:** deleting schemas in production breaks existing consumers that fetch the schema by ID. Always prefer soft-delete.

## HA / Security

- Deploy ≥ 2 instances; one is the leader, others are followers (automatic via ZK or Kafka).
- Authentication: Basic Auth, mTLS, or via a reverse proxy.
- Authorization: schemas can be protected by ACLs on the `_schemas` topic.

## Common Configurations

Producer:
```
schema.registry.url=http://schema-registry:8081
basic.auth.credentials.source=USER_INFO
basic.auth.user.info=user:password
auto.register.schemas=true
use.latest.version=false
max.schemas.per.subject=1000
```

Registry (server):
```
kafkastore.bootstrap.servers=PLAINTEXT://broker:9092
kafkastore.topic=_schemas
listeners=http://0.0.0.0:8081
host.name=schema-registry.acme.com
```

## Exam Pointers

- `TopicNameStrategy` is the default → subjects are `<topic>-value` and `<topic>-key`.
- `auto.register.schemas=true` is default → risky in production (use `false` + CI-based registration).
- `_schemas` is a **compacted** topic; don't enable delete retention.
- Schema IDs are **global** (not per-subject) — the same schema registered twice in different subjects gets the same ID.
- Soft delete keeps the schema discoverable by ID for consumer backward compatibility.
- Wire format: `[0x00][schema ID: 4 bytes][payload]`.
- Schema Registry itself is backed by Kafka — no separate storage.
