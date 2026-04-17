# Article 32: Confluent REST Proxy

## What Is It?

A HTTP/JSON API in front of Kafka, enabling clients that can't (or shouldn't) use the native binary protocol. Examples:

- Browser-side JavaScript
- Ops scripts in Bash or Python
- Languages without a great Kafka client
- Quick-and-dirty integrations

It is a separate process (JVM) that speaks HTTP on port 8082 and Kafka protocol on its backend.

## Endpoints

| Method | Path | Purpose |
|--------|------|---------|
| GET | `/topics` | List topics |
| GET | `/topics/{topic}` | Topic info |
| POST | `/topics/{topic}` | Produce records |
| POST | `/topics/{topic}/partitions/{id}` | Produce to a specific partition |
| GET | `/consumers` | List consumer groups (v3 API) |
| POST | `/consumers/{group}` | Create a consumer instance |
| POST | `/consumers/{group}/instances/{name}/subscription` | Subscribe |
| POST | `/consumers/{group}/instances/{name}/positions/beginning` | Seek to beginning |
| GET | `/consumers/{group}/instances/{name}/records` | Poll for records |
| POST | `/consumers/{group}/instances/{name}/offsets` | Commit offsets |
| DELETE | `/consumers/{group}/instances/{name}` | Close |
| GET | `/brokers` | List brokers |
| GET | `/brokers/{id}` | Broker info |
| POST | `/v3/clusters/{cluster-id}/topics` | v3 admin API |

## API Versions

- **v1** — legacy.
- **v2** — used by most clients; consumer instance model.
- **v3** — admin operations, aligned with AdminClient.

Accept header controls version:
```
Accept: application/vnd.kafka.v2+json
Accept: application/vnd.kafka.json.v2+json
Accept: application/vnd.kafka.avro.v2+json
Accept: application/vnd.kafka.protobuf.v2+json
```

## Producing JSON

```bash
curl -X POST \
  -H "Content-Type: application/vnd.kafka.json.v2+json" \
  -H "Accept: application/vnd.kafka.v2+json" \
  --data '{"records":[{"key":"k1","value":{"id":1,"name":"Alice"}}]}' \
  http://rest-proxy:8082/topics/users
```

Response:
```json
{
  "key_schema_id": null,
  "value_schema_id": null,
  "offsets": [{"partition": 3, "offset": 42}]
}
```

## Producing Avro

```bash
curl -X POST \
  -H "Content-Type: application/vnd.kafka.avro.v2+json" \
  -H "Accept: application/vnd.kafka.v2+json" \
  --data '{
    "value_schema": "{\"type\":\"record\",\"name\":\"User\",\"fields\":[{\"name\":\"id\",\"type\":\"int\"},{\"name\":\"name\",\"type\":\"string\"}]}",
    "records": [{"value": {"id": 1, "name": "Alice"}}]
  }' \
  http://rest-proxy:8082/topics/users
```

You can alternatively send `value_schema_id` to reuse an existing schema.

## Consuming Records

```bash
# 1. Create instance
curl -X POST -H "Content-Type: application/vnd.kafka.v2+json" \
  --data '{"name":"c1","format":"json","auto.offset.reset":"earliest"}' \
  http://rest-proxy:8082/consumers/my-group

# 2. Subscribe
curl -X POST -H "Content-Type: application/vnd.kafka.v2+json" \
  --data '{"topics":["users"]}' \
  http://rest-proxy:8082/consumers/my-group/instances/c1/subscription

# 3. Poll
curl -X GET -H "Accept: application/vnd.kafka.json.v2+json" \
  http://rest-proxy:8082/consumers/my-group/instances/c1/records

# 4. Commit (optional)
curl -X POST -H "Content-Type: application/vnd.kafka.v2+json" \
  http://rest-proxy:8082/consumers/my-group/instances/c1/offsets

# 5. Delete instance (important! releases resources)
curl -X DELETE -H "Accept: application/vnd.kafka.v2+json" \
  http://rest-proxy:8082/consumers/my-group/instances/c1
```

## Stateless Consumer Model

REST Proxy holds a consumer instance in memory for the lifetime of the HTTP session. The **instance name** (`c1` above) is the handle.

- Instances idle out after `consumer.instance.timeout.ms` (default 5 min).
- Each instance uses one Kafka consumer.
- Horizontal scaling: multiple REST Proxy nodes with a load balancer; but consumer instances must be sticky to their creator.

## Configuration

```properties
# Cluster
bootstrap.servers=broker:9092

# REST settings
listeners=http://0.0.0.0:8082
host.name=rest-proxy.acme.com

# Consumer instance timeout
consumer.instance.timeout.ms=300000

# Schema Registry
schema.registry.url=http://sr:8081

# Security
security.protocol=SASL_SSL
sasl.mechanism=SCRAM-SHA-512
sasl.jaas.config=...
```

## Authentication Modes

1. **Anonymous** — the REST Proxy has its own credentials; requests aren't per-user.
2. **Client Authentication** — forwards an HTTP auth header (Basic/Bearer) and authenticates as the user.

Option 2 requires:
```
rest.authentication.method=BASIC
rest.authentication.realm=KafkaRealm
kafka.rest.resource.extension.class=io.confluent.kafkarest.security.KafkaRestSecurityResourceExtension
```

## When to Use (and Not)

**Use:**
- Lightweight producers/consumers from scripts.
- Languages without a good Kafka client.
- Browser / mobile integrations.
- Low-throughput scenarios.

**Avoid:**
- High throughput (HTTP overhead is significant).
- Low-latency use cases (extra hop adds 10s of ms).
- Applications that need advanced features like transactions or exactly-once.

## Exam Pointers

- REST Proxy runs on port **8082** by default.
- Three content types: `json`, `avro`, `protobuf` (plus `jsonschema`).
- Consumer instance model: create → subscribe → poll → commit → delete.
- Schema Registry integration is automatic for Avro/Protobuf endpoints.
- It's a stateful process — load balancing requires session affinity.
- HTTP overhead makes it slower than native clients; not for high-throughput.
