# Article 13: Serialization and Deserialization

## The Role of Serializers

Kafka brokers store **bytes**. They do not understand or care about your data types. Serialization turns your application objects into `byte[]`, and deserialization reverses the process.

Serializers run in the producer; deserializers run in the consumer. The broker is blissfully neutral.

```
Producer: T → Serializer → byte[] → Broker
Broker: bytes persisted
Consumer: byte[] → Deserializer → T
```

## Built-in Serializers

In `org.apache.kafka.common.serialization`:

| Serializer | Deserializer | Use Case |
|------------|-------------|----------|
| `StringSerializer` | `StringDeserializer` | UTF-8 strings |
| `IntegerSerializer` | `IntegerDeserializer` | 32-bit big-endian ints |
| `LongSerializer` | `LongDeserializer` | 64-bit big-endian longs |
| `DoubleSerializer` | `DoubleDeserializer` | IEEE 754 doubles |
| `FloatSerializer` | `FloatDeserializer` | IEEE 754 floats |
| `ByteArraySerializer` | `ByteArrayDeserializer` | Passes bytes through |
| `ByteBufferSerializer` | `ByteBufferDeserializer` | NIO ByteBuffer |
| `BytesSerializer` | `BytesDeserializer` | Kafka's `Bytes` wrapper |
| `UUIDSerializer` | `UUIDDeserializer` | java.util.UUID |
| `VoidSerializer` | `VoidDeserializer` | null-only |
| `ShortSerializer` | `ShortDeserializer` | 16-bit ints |

## Common Trap: Mismatch

If the producer uses `IntegerSerializer` and the consumer uses `StringDeserializer`, the consumer gets garbled strings or a `SerializationException`. The consumer has no idea what type was sent.

This is why schema-based serializers + a registry matter: they add type safety.

## Custom Serializers

```java
public class OrderSerializer implements Serializer<Order> {
    private final ObjectMapper mapper = new ObjectMapper();

    @Override
    public byte[] serialize(String topic, Order order) {
        try {
            return mapper.writeValueAsBytes(order);
        } catch (IOException e) {
            throw new SerializationException(e);
        }
    }
}
```

Corresponding deserializer:

```java
public class OrderDeserializer implements Deserializer<Order> {
    private final ObjectMapper mapper = new ObjectMapper();

    @Override
    public Order deserialize(String topic, byte[] data) {
        try {
            return mapper.readValue(data, Order.class);
        } catch (IOException e) {
            throw new SerializationException(e);
        }
    }
}
```

Drawbacks of raw JSON:
- No schema enforcement.
- Breaking changes silently break consumers.
- Verbose on the wire.

## Schema-Based Serialization Options

### Avro

Binary, compact, schema-evolution friendly.

- Schemas defined in Avro JSON (`.avsc` files).
- Generated Java classes via the Avro Maven plugin (or use GenericRecord).
- Best compression/speed; native support in Kafka ecosystem.

### Protobuf

Google's Protocol Buffers.

- Schemas in `.proto` files.
- Generated classes via protoc.
- Great for polyglot systems.

### JSON Schema

Validates JSON against a schema.

- Schemas in JSON Schema format.
- Widely understood but verbose on the wire.
- Used when readability matters more than efficiency.

### Comparison

| Format | Size | Speed | Language Support | Readable |
|--------|------|-------|------------------|----------|
| Avro | Small | Fast | Good | No |
| Protobuf | Small | Very fast | Excellent | No |
| JSON Schema | Large | Slow | Excellent | Yes |
| Raw JSON | Largest | Slow | Universal | Yes |

## Confluent Schema Registry Integration

The Confluent serializers (`KafkaAvroSerializer`, etc.) send bytes prefixed with a schema ID. The registry stores the schema; the ID lets deserializers look up the schema without transmitting it every message.

### Wire Format

```
┌────┬────────────┬──────────────────────────────┐
│ 0  │ schema id  │  serialized payload          │
│1byt│  4 bytes   │   variable                   │
└────┴────────────┴──────────────────────────────┘
```

- **Byte 0**: magic byte, always `0x00`.
- **Bytes 1-4**: big-endian 32-bit schema ID.
- **Bytes 5+**: payload (Avro binary, Protobuf wire format, or JSON).

Deserializer:

1. Reads magic byte — reject if not 0.
2. Reads schema ID.
3. Fetches schema from registry (caches).
4. Deserializes payload with that schema.

### Required Configs for KafkaAvroSerializer

```
key.serializer=io.confluent.kafka.serializers.KafkaAvroSerializer
value.serializer=io.confluent.kafka.serializers.KafkaAvroSerializer
schema.registry.url=http://schema-registry:8081
auto.register.schemas=true          (default; register if new)
use.latest.version=false            (default; use writer's schema)
```

### Required Configs for KafkaAvroDeserializer

```
key.deserializer=io.confluent.kafka.serializers.KafkaAvroDeserializer
value.deserializer=io.confluent.kafka.serializers.KafkaAvroDeserializer
schema.registry.url=http://schema-registry:8081
specific.avro.reader=true           (false to use GenericRecord; true for generated classes)
```

## GenericRecord vs SpecificRecord

| Style | How | Pros | Cons |
|-------|-----|------|------|
| GenericRecord | `Schema.Parser.parse(...)`, build records via `.put(fieldName, value)` | No code generation; flexible | No compile-time type safety |
| SpecificRecord | Generate classes via avro-maven-plugin | Type safety; IDE completion | Build-time dependency |

Set `specific.avro.reader=true` in the deserializer config to materialize generated classes on the consumer side.

## Serde (Streams Short-form)

Kafka Streams needs both a serializer and a deserializer for every `KStream/KTable` operation. It uses the `Serde<T>` interface:

```java
Serdes.String()
Serdes.Integer()
Serdes.Long()
Serdes.ByteArray()
new GenericAvroSerde()            // requires schema registry config
new SpecificAvroSerde<Order>()
```

Passed to operations like `to()`, `through()`, `groupByKey(Grouped.with(...))`, `stream(...)`.

## Error Handling in Deserialization

Bad bytes on a topic can crash a consumer. Options:

### At the consumer:
- Default: `SerializationException` propagates; the next `poll()` returns the same bytes — **infinite loop**.
- Fix: wrap deserialization in try/catch, or use `Deserializer` that handles errors internally.

### At Kafka Streams:
- `default.deserialization.exception.handler`:
  - `LogAndContinueExceptionHandler` — logs, skips.
  - `LogAndFailExceptionHandler` (default) — fails the thread.
  - Custom handler.

- For Avro with bad data: `KafkaAvroDeserializer` throws `SerializationException` on wrong magic byte, missing schema ID, or payload mismatch.

### At Kafka Connect:
- `errors.tolerance=all` + `errors.deadletterqueue.topic.name=dlq.topic` routes bad records to a DLQ instead of failing the connector.

## Exam Pointers

- **Magic byte is 0**, **4-byte schema ID**, big-endian.
- Confluent serializers use the Schema Registry; without it, bytes have no meaning.
- Matching **key** and **value** (de)serializer are required on both ends.
- `specific.avro.reader=true` gives you generated classes; otherwise you get `GenericRecord`.
- `auto.register.schemas=true` is default — dangerous in prod (typos become new schemas).
- Serialization errors on the consumer can cause an **infinite poll loop** unless handled.
- Kafka Streams uses `Serde<T>` (serializer + deserializer combined).
