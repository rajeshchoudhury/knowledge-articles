# Article 8: Producer Configuration Reference

Memorize every default. The exam loves asking "what happens with the default value of X?"

## Durability Configs

| Config | Default (3.x+) | Allowed Values | Notes |
|--------|---------------|----------------|-------|
| `acks` | `all` | `0`, `1`, `all` / `-1` | 0 = no ack, 1 = leader only, all = leader + ISR |
| `retries` | `Integer.MAX_VALUE` (2147483647) | 0–MAX | Number of retry attempts |
| `retry.backoff.ms` | 100 | any | Wait between retries |
| `delivery.timeout.ms` | 120000 (2 min) | ≥ `linger.ms + request.timeout.ms` | Total time cap from `send()` to delivery |
| `request.timeout.ms` | 30000 | — | Per-request timeout |
| `enable.idempotence` | `true` | true/false | Requires acks=all, retries>0, max.in.flight≤5 |

### The `delivery.timeout.ms` Trump Card

Before 2.1, Kafka used `retries` to bound the retry loop. Now the effective bound is `delivery.timeout.ms`. Even if `retries = MAX`, the producer will give up when this timeout elapses.

Practical rule: configure `delivery.timeout.ms` based on your SLA; let `retries = Integer.MAX_VALUE`.

### acks Details

| acks | Durability | Latency | Throughput |
|------|-----------|---------|-----------|
| `0` | None. Producer doesn't wait for any ack. Records may be lost even if broker is up. | Lowest | Highest |
| `1` | Leader has written to its local log. Data loss if leader fails before follower replicates. | Medium | High |
| `all` (or `-1`) | All ISR members have appended. `min.insync.replicas` enforced. | Highest | Lower |

## Batching & Compression

| Config | Default | Notes |
|--------|---------|-------|
| `batch.size` | 16384 (16 KB) | Max bytes per batch per partition |
| `linger.ms` | 0 | How long to wait for batch to fill |
| `buffer.memory` | 33554432 (32 MB) | Total accumulator buffer |
| `max.block.ms` | 60000 | Block duration when buffer is full |
| `compression.type` | `none` | `none`, `gzip`, `snappy`, `lz4`, `zstd` |
| `max.request.size` | 1048576 (1 MB) | Max bytes per request (one or more batches) |

### Compression Trade-offs

| Codec | CPU | Ratio | Speed |
|-------|----:|------:|------:|
| `gzip` | High | Best | Slowest |
| `snappy` | Low | Medium | Fast |
| `lz4` | Low | Medium | Fastest |
| `zstd` | Medium | Best | Fast (since 2.1) |

`zstd` is generally the best trade-off in modern Kafka clusters.

### Compression Applies to Batches

A single record with `compression.type=gzip` gets zero benefit — gzip overhead exceeds gains. Compression shines only when many records are batched together.

Combine with `linger.ms` (e.g., 5-20 ms) to build bigger batches.

## Network & In-Flight

| Config | Default | Notes |
|--------|---------|-------|
| `max.in.flight.requests.per.connection` | 5 | Requests sent without ACK |
| `connections.max.idle.ms` | 540000 (9 min) | Idle connection timeout |
| `reconnect.backoff.ms` | 50 | Wait before reconnect |
| `reconnect.backoff.max.ms` | 1000 | Max wait (exponential backoff) |
| `metadata.max.age.ms` | 300000 (5 min) | Metadata refresh interval |
| `send.buffer.bytes` | 131072 (128 KB) | SO_SNDBUF |
| `receive.buffer.bytes` | 32768 (32 KB) | SO_RCVBUF |

## Serializers

| Config | Required |
|--------|---------|
| `key.serializer` | YES |
| `value.serializer` | YES |

Built-in serializers in `org.apache.kafka.common.serialization`:
- `StringSerializer`
- `IntegerSerializer` / `LongSerializer` / `ShortSerializer`
- `ByteArraySerializer`
- `ByteBufferSerializer`
- `BytesSerializer`
- `UUIDSerializer`
- `VoidSerializer`
- `DoubleSerializer` / `FloatSerializer`

Confluent's schema-based serializers (in `io.confluent.kafka.serializers`):
- `KafkaAvroSerializer`
- `KafkaProtobufSerializer`
- `KafkaJsonSchemaSerializer`
- `KafkaJsonSerializer` (schemaless)

## Transactions

| Config | Default | Notes |
|--------|---------|-------|
| `transactional.id` | null | A stable ID enabling transactions; uniquely identifies this producer to fence zombies |
| `transaction.timeout.ms` | 60000 | Max time a transaction can remain open |

Requires `enable.idempotence=true` (implicit when set).

## Client Identity / Metadata

| Config | Default | Notes |
|--------|---------|-------|
| `client.id` | `producer-<n>` | Helpful in server logs and metrics |
| `bootstrap.servers` | — | CSV of `host:port`; must include at least one reachable broker |
| `partitioner.class` | null → DefaultPartitioner | Custom `Partitioner` implementation |
| `interceptor.classes` | [] | `ProducerInterceptor` plugins |

## Partitioning-Specific (Kafka 3.3+)

| Config | Default | Notes |
|--------|---------|-------|
| `partitioner.ignore.keys` | false | If true, treats every key as null (uniform sticky) |
| `partitioner.adaptive.partitioning.enable` | true | Sticky partitioner adapts to broker load |
| `partitioner.availability.timeout.ms` | 0 | Duration to exclude a slow broker from the partitioner |

## Security

| Config | Notes |
|--------|-------|
| `security.protocol` | `PLAINTEXT`, `SSL`, `SASL_PLAINTEXT`, `SASL_SSL` |
| `ssl.truststore.location`, `ssl.truststore.password` | For SSL |
| `ssl.keystore.location`, `ssl.keystore.password`, `ssl.key.password` | For mutual TLS |
| `sasl.mechanism` | `PLAIN`, `SCRAM-SHA-256`, `SCRAM-SHA-512`, `GSSAPI`, `OAUTHBEARER` |
| `sasl.jaas.config` | JAAS module config |

## Common Config Recipes

### Minimum-latency producer
```
acks=1
linger.ms=0
batch.size=16384
compression.type=none
```

### Maximum-throughput producer
```
acks=all
linger.ms=20
batch.size=131072
compression.type=lz4
buffer.memory=67108864
```

### Maximum-durability / ordered producer
```
acks=all
enable.idempotence=true
retries=Integer.MAX_VALUE
delivery.timeout.ms=300000
max.in.flight.requests.per.connection=5
```

### Transactional producer
```
transactional.id=payment-writer-1
enable.idempotence=true   (implicit)
acks=all                  (implicit)
transaction.timeout.ms=60000
```

## Configuration Validation Rules

Since Kafka 3.0 the client rejects invalid combinations at startup:

1. `enable.idempotence=true` AND `acks != all` → `ConfigException`
2. `enable.idempotence=true` AND `retries == 0` → `ConfigException`
3. `enable.idempotence=true` AND `max.in.flight.requests.per.connection > 5` → `ConfigException`
4. `transactional.id != null` AND `enable.idempotence=false` → `ConfigException`

## Exam Pointers

- `acks` default is now `all` (Kafka 3.0+). Pre-3.0 it was `1`.
- `enable.idempotence=true` is the default in Kafka 3.0+.
- Idempotence requires `acks=all`, `retries>0`, `max.in.flight≤5`.
- `linger.ms=0` (default) means "flush immediately" — no waiting for more records.
- `max.in.flight.requests.per.connection > 1` without idempotence breaks ordering on retry.
- `delivery.timeout.ms` trumps `retries` as the real retry budget.
- `compression.type=producer` on the topic means "keep whatever the producer sent".
