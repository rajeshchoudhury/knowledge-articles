# Article 15: Schema Compatibility and Evolution — The Matrix You Must Memorize

Compatibility modes determine what schema changes are allowed. This is the **most frequently tested** Schema Registry topic on CCDAK.

## The 8 Compatibility Modes

| Mode | Allowed Changes |
|------|----------------|
| `NONE` | Anything — no check |
| `BACKWARD` (default) | New schema can read data written with the previous schema |
| `BACKWARD_TRANSITIVE` | New schema can read data written with **any** previous schema |
| `FORWARD` | Previous schema can read data written with the new schema |
| `FORWARD_TRANSITIVE` | All previous schemas can read data written with the new schema |
| `FULL` | BACKWARD + FORWARD between new and previous |
| `FULL_TRANSITIVE` | BACKWARD + FORWARD between new and **all** previous |

## Compatibility Direction Intuition

- **BACKWARD** → **consumers upgrade first, then producers**. New consumers (reading with the new schema) can still deserialize old data.
- **FORWARD** → **producers upgrade first, then consumers**. Old consumers can still read new data.
- **FULL** → everyone can upgrade in any order.
- **NONE** → total freedom, but total risk.

Mnemonic:
- **B**ACKWARD reads **B**ackward-in-time data → Consumer first.
- **F**ORWARD reads **F**uture data → Producer first.

## Allowed Avro Changes Per Mode

| Change | BACKWARD | FORWARD | FULL | NONE |
|--------|:--------:|:-------:|:----:|:----:|
| Add optional field (with default) | ✅ | ❌ | ❌ | ✅ |
| Add required field (no default) | ❌ | ✅ | ❌ | ✅ |
| Remove optional field (had default) | ❌ | ✅ | ❌ | ✅ |
| Remove required field | ✅ | ❌ | ❌ | ✅ |
| Rename field | ❌ | ❌ | ❌ | ✅ |
| Change field type (promote int → long) | ✅* | ❌ | ❌ | ✅ |
| Add enum symbol | ✅ (if default) | ❌ | ❌ | ✅ |
| Remove enum symbol | ❌ | ✅ (if default) | ❌ | ✅ |

*Avro allows specific type promotions: int → long → float → double, string → bytes, etc.

### Why BACKWARD blocks "add required field"?

Old data does not have the field. The new consumer expects it. Since no default exists to fill in, the reader cannot deserialize old data → incompatible.

### Why FORWARD blocks "add optional field"?

The old consumer's schema doesn't know about the new field. Avro's old schema (reader) sees a field in the new writer's data it doesn't recognize → drops it silently (Avro can ignore extra fields). Technically allowed, BUT:

**Subtle distinction in Confluent Schema Registry**: "adding an optional field" is categorized as BACKWARD compatible because BACKWARD is about reading old data with the new schema. The matrix above reflects Confluent's enforcement.

## Memorize This Table (Confluent Documentation)

| Change | BACKWARD | FORWARD | FULL |
|--------|:--------:|:-------:|:----:|
| Delete a field with a default | ❌ | ✅ | ❌ |
| Add a field with a default | ✅ | ❌ | ❌ |
| Add a field without a default | ❌ | ❌ | ❌ |
| Delete a field without a default | ✅ | ❌ | ❌ |

**FULL** requires the change to be **both** BACKWARD and FORWARD — which excludes most individual changes. Only changes that are simultaneously reader-forgiving and writer-forgiving are FULL compatible, which generally means changes that don't alter the field set.

## Transitive vs Non-Transitive

- **Non-transitive** (e.g., `BACKWARD`) — only checks the new schema against the **most recent** schema.
- **Transitive** (e.g., `BACKWARD_TRANSITIVE`) — checks against **ALL previous** schemas.

### Why does this matter?

Example with `BACKWARD`:
- v1: {name}
- v2: {name, age=defaults to 0}   ← v2 can read v1 data (age defaulted). OK.
- v3: {name, surname}              ← v3 can read v2 data (surname defaulted... wait, no default? Incompatible.) Or assume v3: {name, surname="default"} → OK.
- But now, can v3 read v1? V1 has name. V3 expects name + surname. V3 can default surname, so YES. But BACKWARD only checked against v2.

Non-transitive is cheap but can let "almost-incompatible" chains through. Transitive catches everything.

## Schema Compatibility with Different Serializers

### Avro

Avro has native schema resolution. Most flexible of the three. Supports reader ≠ writer schema transparently.

### Protobuf

Protobuf's rule: **never reuse field numbers**, never change types in place. Adding a new field is always BACKWARD-compatible if the field is optional (default in proto3). Removing a required field is BACKWARD-compatible if you **reserve** the field number.

### JSON Schema

JSON Schema allows additional properties by default. Adding a field is backward compatible. Removing or renaming requires care.

Compatibility checks can be more restrictive; Confluent's implementation validates these per-format.

## How to Use Compatibility in Practice

1. **Choose mode per subject** based on who upgrades first:

   - Backend consumers are upgraded before producers? → `BACKWARD` (default).
   - New producers deploy before consumers upgrade? → `FORWARD`.
   - Independent upgrades? → `FULL_TRANSITIVE`.

2. **Register schemas via CI/CD.** Disable `auto.register.schemas` in production.

3. **Use the `/compatibility` endpoint** to validate schema changes in PR checks.

```bash
curl -X POST http://schema-registry:8081/compatibility/subjects/orders-value/versions/latest \
  -H "Content-Type: application/vnd.schemaregistry.v1+json" \
  -d @new-schema.json
```

Response: `{"is_compatible": true}` or `{"is_compatible": false, "messages": [...]}`.

## Worked Example: Adding `email` Field Under BACKWARD

v1 schema:
```json
{"type": "record", "name": "User", "fields": [
  {"name": "id", "type": "string"},
  {"name": "name", "type": "string"}
]}
```

v2 change — add `email` with default:
```json
{"type": "record", "name": "User", "fields": [
  {"name": "id", "type": "string"},
  {"name": "name", "type": "string"},
  {"name": "email", "type": ["null","string"], "default": null}
]}
```

Compatibility check: BACKWARD asks "can v2 read v1 data?" V1 data has no `email`. V2 reader fills in `null` (default). ✅ Compatible.

If instead we added `email` without a default:
```json
{"name": "email", "type": "string"}
```
V2 reader needs `email` but v1 data doesn't have it. ❌ Incompatible.

## Worked Example: Removing a Field Under FORWARD

v1: `{id, name, email}`. v2: `{id, name}` (dropped email).

FORWARD asks "can v1 read v2 data?" V2 data has {id, name}. V1 reader expects `email` too. If `email` had a default in v1, the V1 reader fills it in. ✅. If `email` was required in v1 with no default, ❌.

## Exam Pointers

- **BACKWARD default** — remember the direction: new schema reads old data → consumer upgrades first.
- **FORWARD is producer-first** — old consumers can read new data.
- **FULL** = BACKWARD + FORWARD.
- **TRANSITIVE** extends the check across all historical versions, not just the most recent.
- **Adding a field with a default** = BACKWARD compatible.
- **Removing a field without a default** = BACKWARD compatible (old data still has it; new schema can drop it).
- **Adding a required field** is only safe under `FORWARD`.
- The default global compatibility is `BACKWARD` — memorize this.
- Compatibility is validated when **registering**, not when reading. Once registered, a schema is fixed.
