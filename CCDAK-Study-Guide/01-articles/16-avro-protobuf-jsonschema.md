# Article 16: Avro, Protobuf, and JSON Schema — Detailed Comparison

## Avro

A binary row-based serialization format with JSON-based schema definitions. Developed as part of Hadoop. Kafka's most popular schema format.

### Strengths

- **Compact binary encoding.** No field names on the wire (just values in schema order).
- **Schema evolution** with reader/writer schema resolution.
- **Cross-language support** (Java, Python, C++, Go, Rust, etc.).
- **Self-describing files** (schema in file header — for Avro files, not Kafka records).

### Schema Example

```json
{
  "type": "record",
  "namespace": "com.acme",
  "name": "Order",
  "fields": [
    {"name": "id", "type": "string"},
    {"name": "userId", "type": "int"},
    {"name": "amount", "type": "double"},
    {"name": "currency", "type": {"type": "enum", "name": "Currency", "symbols": ["USD","EUR","GBP"]}},
    {"name": "items", "type": {"type": "array", "items": "string"}, "default": []},
    {"name": "notes", "type": ["null", "string"], "default": null}
  ]
}
```

### Primitive Types

`null`, `boolean`, `int` (32-bit), `long` (64-bit), `float`, `double`, `bytes`, `string`.

### Complex Types

- `record` — struct with named fields.
- `enum` — finite set of symbols.
- `array` — list of homogeneous values.
- `map` — keys are strings, values of one type.
- `union` — one of several types (e.g., `["null","string"]` for optional).
- `fixed` — byte array of fixed length.

### Defaults and Nulls

For a field to be nullable, use a union: `["null", "string"]` with `"default": null`.

Order matters in unions — when the default is `null`, `null` must be the first type in the union.

### Logical Types

Avro 1.8+ supports logical types (semantic hints):
- `timestamp-millis` — long millis since epoch.
- `timestamp-micros` — long micros.
- `date` — int days since epoch.
- `time-millis`, `time-micros`.
- `decimal` — fixed-precision.
- `uuid`.

Example:
```json
{"name": "created_at", "type": {"type": "long", "logicalType": "timestamp-millis"}}
```

### Reader vs Writer Schema

Avro's killer feature: during deserialization, the reader schema can differ from the writer's as long as they are compatible.

- Fields in writer but not reader → dropped.
- Fields in reader but not writer → filled with default (or error if no default).
- Type promotions allowed: `int → long → float → double`, `string ↔ bytes`.

## Protobuf

Google's Protocol Buffers. Field-number-based encoding. Widely used at Google.

### Strengths

- **Extremely compact.** Varint encoding for integers; field numbers instead of names.
- **Very fast** ser/deser.
- **Excellent language support** (C++, Java, Python, Go, TS, Rust, etc.).
- **Backward/forward compatibility built-in** via field numbers.

### Schema Example

```proto
syntax = "proto3";
package com.acme;

message Order {
  string id = 1;
  int32 user_id = 2;
  double amount = 3;
  Currency currency = 4;
  repeated string items = 5;
  optional string notes = 6;
}

enum Currency {
  USD = 0;
  EUR = 1;
  GBP = 2;
}
```

### Field Numbers

Each field has a **unique, never-reused, never-renumbered** field number. This is how Protobuf achieves bidirectional compatibility:

- Adding new fields: append with new numbers. Old readers ignore them.
- Removing fields: keep the field number reserved (`reserved 5;`) so a new field doesn't reuse it.
- Renaming fields: allowed (the wire format uses numbers).
- Changing types: generally NOT allowed.

### proto3 vs proto2

- proto3 (recommended): simpler, no required fields, all fields are implicitly optional, defaults are zero values.
- proto2 (legacy): had `required` fields (removed for compatibility reasons).

### Default Values

In proto3, defaults are type zero (0, "", empty array, enum value 0). A missing field and a field set to the default are **indistinguishable on the wire**. This matters for semantics.

## JSON Schema

A specification for describing JSON document structure. Draft-07 is the most common.

### Strengths

- **Human-readable** — it's just JSON.
- **Language-agnostic** — every major language has a JSON Schema validator.
- **Expressive** — can validate constraints beyond types (regex patterns, numeric ranges, conditional logic).

### Schema Example

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "id": {"type": "string"},
    "userId": {"type": "integer"},
    "amount": {"type": "number", "minimum": 0},
    "currency": {"type": "string", "enum": ["USD","EUR","GBP"]},
    "items": {"type": "array", "items": {"type": "string"}},
    "notes": {"type": ["string","null"]}
  },
  "required": ["id","userId","amount","currency"],
  "additionalProperties": false
}
```

### Wire Format

The payload is plain JSON — much larger than Avro or Protobuf binary.

## Head-to-Head

| Criterion | Avro | Protobuf | JSON Schema |
|-----------|------|----------|-------------|
| Wire size | Small | Smallest | Largest |
| Speed (ser/de) | Fast | Very fast | Slow |
| Schema in wire | No (ID only) | No (field numbers) | No (ID only, when using Confluent's serializer) |
| Schema evolution | Reader/writer resolution | Field numbers | Strict |
| Tooling | Kafka ecosystem | Google ecosystem | Web/API ecosystem |
| Readability | No | No | Yes (JSON) |
| Compact numbers | Regular | Varint (very small) | Text |
| Nullable fields | Union with null | Optional (proto3) | Multi-type |
| Language support | Good | Excellent | Excellent |

## Choosing Format

| Situation | Recommended |
|-----------|-------------|
| Kafka-only pipeline, many languages, performance matters | **Avro** |
| Polyglot systems with strict schemas, Google stack | **Protobuf** |
| HTTP + event streaming, human debuggability, external APIs | **JSON Schema** |
| Legacy JSON with gradual typing | JSON Schema or plain JSON |

## Schema Registry Integration

All three are supported by Confluent Schema Registry:

- `KafkaAvroSerializer`
- `KafkaProtobufSerializer`
- `KafkaJsonSchemaSerializer`

Each uses the **same wire format** (`[0x00][schema ID: 4 bytes][payload]`), but the payload differs per format.

## Evolution Rules Per Format

### Avro

- Add a field with default → BACKWARD.
- Remove a field with default → FORWARD.
- Add/remove optional field (null default) → FULL.
- Type promotion (int→long) → BACKWARD.

### Protobuf

- Add new field number → BACKWARD + FORWARD.
- Remove field and reserve → BACKWARD + FORWARD.
- Reuse field number → **BREAKING**.
- Change type of existing field → BREAKING.
- Add an `optional` keyword (proto3 optional) → compatible.

### JSON Schema

- Add optional property → BACKWARD.
- Add required property → BREAKING under BACKWARD (old data won't have it).
- Widen type (e.g., number to integer|number) → BACKWARD.
- Restrict validation (add `minimum`) → BREAKING (old data may violate).

## Exam Pointers

- **Avro is default** for Confluent Kafka pipelines.
- Wire format is **the same** for all three (`[0][4-byte ID][payload]`).
- Avro unions `["null","string"]` is idiomatic for optional fields.
- Protobuf: **never reuse field numbers**; use `reserved` when removing.
- JSON Schema is larger on the wire but human-readable.
- All three support compatibility modes in Schema Registry.
- Avro's reader/writer resolution is unique among the three.
