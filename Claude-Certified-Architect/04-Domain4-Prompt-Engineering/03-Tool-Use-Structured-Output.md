# D4.3 — Tool-Use for Structured Output

> **The single most important distinction in Domain 4**: `tool_use` guarantees **structure**, not **semantics**. Every exam question on extraction will test this.

## 1. What `tool_use` Is (for structured output)

Anthropic's `tool_use` API was originally for calling tools. But it doubles as **the most reliable way to get structured output** — because the API server validates Claude's tool-call payload against your JSON schema before returning it.

Pattern:
1. Define a "fake" tool whose `input_schema` is your desired output shape.
2. Force Claude to call that tool with `tool_choice={"type":"tool","name":"..."}`.
3. The API guarantees the payload matches the schema.

## 2. The Critical Distinction — Structure ≠ Semantics

> **`tool_use` guarantees structure. It does NOT guarantee semantic correctness.**

| Layer | Guaranteed by `tool_use`? |
|---|---|
| All required fields present | ✅ Yes |
| Types match the schema | ✅ Yes |
| Enum values are valid | ✅ Yes |
| Values are **correct** for the input | ❌ NO |
| Numbers add up | ❌ NO |
| Dates are right | ❌ NO |
| Vendor name is the actual vendor | ❌ NO |

**You still need semantic validation.** The exam will offer a distractor claiming `tool_use` eliminates all errors. It does not.

## 3. Full Canonical Example

```python
import anthropic, json
client = anthropic.Anthropic()

extract_invoice = {
    "name": "extract_invoice",
    "description": "Extract structured data from an invoice.",
    "input_schema": {
        "type": "object",
        "properties": {
            "vendor_name":    {"type": "string"},
            "invoice_number": {"type": "string"},
            "date":           {"type": "string",
                               "description": "ISO 8601 date YYYY-MM-DD"},
            "total":          {"type": "number"},
            "currency":       {"type": "string",
                               "description": "ISO-4217 3-letter code"},
            "document_type": {
                "type": "string",
                "enum": ["standard_invoice", "credit_note", "proforma", "other"]
            },
            "document_type_detail": {
                "type": "string",
                "description": "Required if document_type == 'other'"
            },
            "line_items": {
                "type": "array",
                "items": {
                    "type": "object",
                    "properties": {
                        "description": {"type": "string"},
                        "quantity":    {"type": "number"},
                        "unit_price":  {"type": "number"},
                        "total":       {"type": "number"}
                    },
                    "required": ["description", "quantity", "unit_price", "total"]
                }
            }
        },
        "required": ["vendor_name", "invoice_number", "date",
                     "total", "currency", "document_type"]
    }
}

response = client.messages.create(
    model="claude-sonnet-4-20250514",
    tools=[extract_invoice],
    tool_choice={"type": "tool", "name": "extract_invoice"},
    messages=[{"role": "user", "content": f"Extract data from: {INVOICE_TEXT}"}]
)

tool_block = next(b for b in response.content if b.type == "tool_use")
data = tool_block.input   # guaranteed to match the schema
```

## 4. `tool_choice` — the Three Modes (recap)

| Mode | Effect | Use for |
|---|---|---|
| `"auto"` (default) | Claude picks whether to call a tool | General conversation |
| `"any"` | Must call a tool, but picks which | Always-call-a-tool enforcement |
| `{"type": "tool", "name": "X"}` | Force this exact tool | Structured extraction, deterministic workflows |

For extraction pipelines, **always force a specific tool**.

## 5. Why JSON-Mode Prompts Are Not Enough

A common incorrect answer: "Just prompt Claude with 'output as JSON' and it will comply." It mostly does, but:
- The model may wrap JSON in markdown fences you must strip.
- The model may include comments (`//`) that break parsers.
- The model may drift field names (`vendor` vs. `vendor_name`).
- The model may miss required fields silently.

`tool_use` eliminates **all** of these at the API boundary.

## 6. Schema Design Principles

### 6.1 Required vs optional
- Mark *truly mandatory* fields as `required`.
- Over-marking required → extraction fails when a field is genuinely absent.
- Under-marking → Claude can omit fields and you silently lose data.

### 6.2 Enum with `"other"` escape hatch
Always include an "other" value for any categorical field the world can expand:

```json
"document_type": {
  "type": "string",
  "enum": ["standard_invoice", "credit_note", "proforma", "receipt", "other"]
},
"document_type_detail": {
  "type": "string",
  "description": "Required when document_type == 'other'"
}
```

Without "other", unexpected inputs force misclassification.

### 6.3 Nullable fields
If a field can be missing, mark its type `["string", "null"]` rather than making it optional:

```json
"shipping_address": { "type": ["string", "null"] }
```

This way Claude must explicitly emit `null`, not silently drop the field.

### 6.4 Array items with their own schema
Always specify `items` for arrays:

```json
"line_items": {
  "type": "array",
  "items": { "type": "object", "properties": {...}, "required": [...] }
}
```

### 6.5 Descriptions everywhere
Claude reads `description` at every level. Write descriptions for properties, for enums, for arrays, for nested objects.

### 6.6 Pattern / format
Use `pattern` or `format` for structured strings:
```json
"email": {"type": "string", "format": "email"},
"ein":   {"type": "string", "pattern": "^\\d{2}-\\d{7}$"}
```

## 7. Validation — What You MUST Do After `tool_use`

The schema ensures structural compliance. Now you must validate semantics.

```python
from dateutil.parser import isoparse

def validate_invoice(data):
    errors = []
    # Date shape
    try:
        isoparse(data["date"])
    except Exception:
        errors.append(f"date not ISO 8601: {data['date']!r}")
    # Totals sanity
    if data["total"] <= 0:
        errors.append(f"total must be positive, got {data['total']}")
    # Currency enum
    if data["currency"] not in {"USD","EUR","GBP","INR","CAD","AUD","JPY"}:
        errors.append(f"unsupported currency: {data['currency']}")
    # Line-items vs subtotal
    li_sum = sum(li["total"] for li in data.get("line_items", []))
    if data.get("subtotal") and abs(li_sum - data["subtotal"]) > 0.01:
        errors.append(f"line items sum {li_sum} ≠ subtotal {data['subtotal']}")
    # Document type consistency
    if data["document_type"] == "other" and not data.get("document_type_detail"):
        errors.append("document_type='other' requires document_type_detail")
    return errors
```

If `validate_invoice(data)` returns errors, feed them back (validation-retry loop — see D4.4).

## 8. Combining `tool_use` with Few-Shot

Include 2 – 4 few-shot examples showing the tool being called with edge cases:

```
Example 1: standard invoice → tool call with document_type="standard_invoice"
Example 2: credit note → tool call with document_type="credit_note"
Example 3: "DEBIT NOTE" → tool call with document_type="other", detail="debit note"
Example 4: amended invoice → tool call with document_type="other", detail="amended invoice"

Now extract from: {doc}
```

`tool_use` guarantees the structure; few-shot guides the classification judgement.

## 9. Common Schema Mistakes

| Mistake | Symptom | Fix |
|---|---|---|
| Missing `required` | Fields silently dropped | Add to `required` |
| Enum without "other" | Unexpected values force bad classification | Add "other" + detail field |
| No descriptions | Claude guesses at intent | Write per-property descriptions |
| Over-nested schema (5+ deep) | Claude gets confused; validation errors | Flatten; extract separate tools if needed |
| Schema doesn't match validator | Claude passes schema, you reject | Keep schema and validator co-located/tested |

## 10. Anti-Patterns on the Exam

| Distractor you'll see | What's wrong |
|---|---|
| "Just prompt 'output as JSON'" | Not guaranteed; no schema enforcement |
| "Use tool_choice='auto'" for extraction | Claude may not call the tool at all |
| "`tool_use` guarantees correctness" | Guarantees structure only |
| "Post-process with regex" | Fragile; `tool_use` + validation is better |
| "Use a bigger model" | Doesn't fix schema compliance; use `tool_use` |

## 11. Exam Self-Check

1. *What does `tool_use` guarantee?*
   → Structural compliance with your JSON schema. Not semantic correctness.
2. *Best `tool_choice` for guaranteed extraction?*
   → `{"type": "tool", "name": "<your_extract_tool>"}`.
3. *A field might be missing in some inputs. Required or nullable type?*
   → **Nullable** (`["string", "null"]`) — keeps it in the schema; explicit about absence.
4. *Why include `"other"` in an enum?*
   → To handle unexpected real-world values without forcing misclassification.
5. *After `tool_use` returns, what's next?*
   → Validate semantics (dates, totals, cross-field invariants).

---

### Key Takeaways
- ✅ `tool_use` + forced `tool_choice` = reliable structured output.
- ✅ Include `"other"` + detail field in enums.
- ✅ Use nullable types for optional fields.
- ✅ Always validate semantics after extraction.
- ❌ Don't rely on "output as JSON" prompts.
- ❌ Don't treat `tool_use` as a correctness guarantee.

Next → [`04-JSON-Schema-Design.md`](04-JSON-Schema-Design.md)
