# D4.4 — JSON Schema Design for Tool Use

> This file drills deeper into schema craft. The exam tests schema *design judgement*, not just surface syntax.

## 1. The Minimal Schema

```json
{
  "type": "object",
  "properties": {
    "name":   {"type": "string"},
    "email":  {"type": "string"},
    "age":    {"type": "integer"}
  },
  "required": ["name", "email"]
}
```

This works, but a production-grade schema adds **constraints**, **descriptions**, **nullability**, and **escape hatches**.

## 2. The Production-Grade Schema

```json
{
  "type": "object",
  "properties": {
    "name":  { "type": "string", "minLength": 1, "maxLength": 200,
               "description": "Full legal name as shown on the document." },
    "email": { "type": "string", "format": "email",
               "description": "Contact email; must contain @." },
    "age":   { "type": ["integer", "null"], "minimum": 0, "maximum": 130,
               "description": "Age in years; null if not provided." },
    "tier":  { "type": "string",
               "enum": ["free", "pro", "enterprise", "other"],
               "description": "Account tier. Use 'other' for unknown tiers." },
    "tier_detail": { "type": ["string", "null"],
               "description": "Required when tier=='other'." },
    "signed_up_at": { "type": "string", "format": "date-time",
               "description": "ISO 8601 UTC timestamp." }
  },
  "required": ["name", "email", "tier"]
}
```

Every field is:
- **Typed** precisely.
- **Constrained** with ranges, lengths, patterns.
- **Documented** with a `description`.
- **Nullable** where appropriate.
- **Enum-safe** with an "other" escape hatch.

## 3. Required vs Optional vs Nullable

Three options for "the field might not be there":

### 3.1 Required (always present)
```json
"name": {"type": "string"}
// in required: ["name", ...]
```

### 3.2 Optional (may be absent entirely)
```json
"address": {"type": "string"}
// NOT in required
```

### 3.3 Nullable (always present but may be null)
```json
"manager_id": {"type": ["string", "null"]}
// in required: ["manager_id", ...]
```

### Guidance
- **Required** for essentials.
- **Nullable** is usually better than optional — forces Claude to explicitly acknowledge absence.
- **Optional** for fields that may or may not make sense for a given input (e.g., line items only in some invoices).

## 4. Enums — the Right Way

### 4.1 Closed enum (future-proof)
```json
{"type": "string", "enum": ["draft", "published", "archived"]}
```
Use when the set is **stable** — deprecation is not an option.

### 4.2 Open enum with "other" escape hatch
```json
{
  "type": "string",
  "enum": ["invoice", "credit_note", "receipt", "other"]
}
```
Plus a sibling detail field:
```json
"type_detail": {"type": "string",
                "description": "Required when type == 'other'."}
```

Use when the set **can evolve** — unknown values go to "other" with detail, no misclassification.

### 4.3 Never: unbounded freeform where an enum belongs
```json
{"type": "string"}   // for a severity field
```
Without an enum, you'll see `"high"`, `"High"`, `"critical"`, `"Critical"`, `"SEV-1"` all over your data.

## 5. Patterns & Formats

### Supported formats (partial list)
- `"format": "email"`
- `"format": "uri"`
- `"format": "date-time"` (ISO 8601 with timezone)
- `"format": "date"` (YYYY-MM-DD)
- `"format": "time"`
- `"format": "uuid"`

### Custom patterns
```json
"ein":        {"type": "string", "pattern": "^\\d{2}-\\d{7}$"}
"phone_e164": {"type": "string", "pattern": "^\\+[1-9]\\d{1,14}$"}
"account_id": {"type": "string", "pattern": "^ACC-\\d{5,10}$"}
```

## 6. Numeric Bounds

```json
"quantity":  {"type": "integer", "minimum": 1, "maximum": 1000000}
"price":     {"type": "number",  "minimum": 0, "exclusiveMinimum": 0}
"discount":  {"type": "number",  "minimum": 0, "maximum": 1,
              "description": "Decimal 0–1 (0.15 = 15%)."}
```

Bound what you can. It's free error-reduction.

## 7. Arrays — Always Constrain

```json
"tags": {
  "type": "array",
  "minItems": 0,
  "maxItems": 20,
  "uniqueItems": true,
  "items": {
    "type": "string",
    "minLength": 1,
    "maxLength": 64
  }
}
```

## 8. Objects — Use `additionalProperties`

By default, JSON Schema allows unknown properties. For strict schemas:

```json
{
  "type": "object",
  "properties": {...},
  "required": [...],
  "additionalProperties": false
}
```

Prevents Claude from inventing fields.

## 9. `$defs` for Reuse

When a substructure repeats:

```json
{
  "type": "object",
  "properties": {
    "billing_address":  {"$ref": "#/$defs/address"},
    "shipping_address": {"$ref": "#/$defs/address"}
  },
  "$defs": {
    "address": {
      "type": "object",
      "properties": {
        "street": {"type": "string"},
        "city":   {"type": "string"},
        "country":{"type": "string", "pattern": "^[A-Z]{2}$"}
      },
      "required": ["street", "city", "country"]
    }
  }
}
```

Keeps schemas DRY.

## 10. Descriptions — the Hidden Lever

Claude reads descriptions. **Write them like you're teaching an intern**.

```json
"confidence": {
  "type": "string",
  "enum": ["high", "medium", "low"],
  "description": "high = directly stated in the text; medium = strongly implied; low = inferred or guess. Prefer 'low' over wrong enum values."
}
```

Descriptions are where you sneak in calibration and guardrails.

## 11. Depth — Don't Go Deeper Than 4 Levels

Deeply nested schemas (5 – 6 levels) produce worse compliance. If you're going deep, consider:
- **Flatten** into two-level structures.
- **Split into multiple tools** — one for the parent, one for each child collection.
- **Use `$defs`** to at least keep the author's sanity.

## 12. Testing Your Schema

Before shipping, run:
1. **10 representative inputs** → check output compliance.
2. **Edge-case inputs** (sarcasm, missing fields, unusual formats) → check graceful degradation.
3. **Programmatic validator** (e.g., `jsonschema` in Python) over every production output → catch regressions.

## 13. Schema-Change Discipline

Schemas are APIs. Treat changes like breaking-change API changes:
- **Adding a field**: backward-compatible if optional; non-backward if required.
- **Removing a field**: always breaking; use deprecation window.
- **Changing enum**: adding a value is breaking for strict downstream; removing is always breaking.
- **Renaming a field**: always breaking — do a two-step migration (add new, deprecate old, then remove).

## 14. Exam Self-Check

1. *Should severity be a plain string or an enum?*
   → Enum.
2. *The enum is `["low","medium","high"]`. A new input category "critical" appears. What do you do?*
   → Add `"other"` (safer retroactively) or extend the enum with `"critical"`; signal upstream consumers.
3. *A field may be absent. Required + nullable, or simply optional?*
   → Usually nullable + required — forces explicit acknowledgement.
4. *A nested 6-level schema is producing compliance errors. Fix?*
   → Flatten, split into multiple tools, or use `$defs`.

---

### Key Takeaways
- ✅ Type + constrain + describe + null-handle + enum-with-other.
- ✅ Use `format` and `pattern` liberally.
- ✅ `additionalProperties: false` for strict schemas.
- ✅ `$defs` for repeated substructures.
- ✅ Keep depth ≤ 4.
- ❌ Don't ship an unconstrained `{"type":"string"}` where an enum belongs.
- ❌ Don't silently break schemas — treat them as APIs.

Next → [`05-Validation-Retry-Loops.md`](05-Validation-Retry-Loops.md)
