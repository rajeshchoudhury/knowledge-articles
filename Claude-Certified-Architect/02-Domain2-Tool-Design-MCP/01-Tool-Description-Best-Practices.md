# D2.1 — Tool Description Best Practices

> Tool descriptions are the documentation *Claude itself reads*. They are the single biggest predictor of tool-selection quality. The exam tests this relentlessly.

## 1. Why Descriptions Matter More Than You Think

When a user asks "Find customer John Smith," Claude does not look up tools in a database by name. It **reads every tool's description**, weighs the current conversation against each, and picks the one with the highest relevance. **The description is the tool's only audition.**

Consequences:
- A vague description → wrong tool picked or no tool picked.
- A mis-worded description → tool picked at the wrong time.
- Duplicate descriptions across tools → coin-flip.
- A perfect description → Claude picks the right tool every time, passes correct inputs, and handles edge cases gracefully.

## 2. The Anatomy of a Great Description

Every production-grade tool description contains five elements:

| # | Element | Purpose |
|---|---------|---------|
| 1 | **Purpose** | One sentence: what the tool does |
| 2 | **Input specification** | Exact types, formats, ranges, constraints |
| 3 | **Examples** | Concrete input/output pairs for common cases |
| 4 | **Edge cases** | What happens with empty inputs, missing data, boundary values |
| 5 | **When NOT to use** | Explicit bounds to prevent misuse |

### 2.1 Purpose
- "Search for a customer." ❌ — too vague
- "Search for a customer by email, phone, or account ID, returning their profile." ✅

### 2.2 Input specification
- "Email" ❌
- "Email must contain @; phone must be E.164 format (+15551234567); account_id must start with `ACC-`." ✅

### 2.3 Examples
Include at least one example in the description:
```
Example 1: email="[email protected]" → returns customer with name, account status.
Example 2: phone="+15551234567" → same output.
```

### 2.4 Edge cases
- "Returns empty array if no customer matches. Empty result is NOT an error."
- "Returns `isError: true` with `errorCategory: 'auth'` if auth fails."

### 2.5 When NOT to use
- "Do NOT use this for bulk lookups — use `batch_lookup_customers` for ≥ 10 IDs."
- "Do NOT use this for creating customers — use `create_customer`."

## 3. Good vs. Bad — a Complete Example

### ❌ Bad description
```json
{
  "name": "search",
  "description": "Searches for stuff",
  "input_schema": {
    "type": "object",
    "properties": {
      "query": { "type": "string" }
    }
  }
}
```
Problems:
- Name is generic.
- "Stuff" is meaningless.
- No input format hints.
- No edge case documentation.
- Nothing to distinguish it from `find`, `lookup`, or `retrieve`.

### ✅ Good description
```json
{
  "name": "lookup_customer",
  "description": "Search for a customer by email, phone number, or account ID. Returns the customer profile including name, account status, and order-history summary. Input: exactly ONE of email, phone, or account_id. Email must contain @. Phone must be in E.164 format (e.g., +15551234567). Account ID must start with 'ACC-'. Returns a customer object on match, or an empty array on no match. Note: an empty array means NOT FOUND, not an error. Access failures (timeout, auth) return isError=true. Use batch_lookup_customers for >=10 IDs.",
  "input_schema": {
    "type": "object",
    "properties": {
      "email":     {"type": "string", "description": "Customer email, must contain @."},
      "phone":     {"type": "string", "description": "E.164 format, e.g., +15551234567."},
      "account_id":{"type": "string", "description": "Account ID starting with 'ACC-', e.g., ACC-12345."}
    }
  }
}
```

What makes it good:
- Specific purpose.
- Exact input formats.
- Edge case (empty array vs isError).
- Boundary guidance ("use batch for >=10 IDs").

## 4. Naming Conventions

| Convention | Example |
|---|---|
| **Snake_case**, verb-first | `lookup_customer`, `process_refund`, `send_email` |
| Noun/verb match intent | `get_order_status`, not `order_status_getter` |
| Distinct per tool | Avoid near-synonyms: don't have `find_customer` AND `lookup_customer` AND `search_customers` |
| Include the domain in the name if the agent has many tools | `billing.process_refund`, `comms.send_email` |

Ambiguity between tools is the silent killer. If two tool names + descriptions could plausibly apply to the same user intent, Claude will coin-flip.

## 5. Input Schema — the JSON Schema Rules That Matter

Claude reads the `input_schema` AND the natural-language description. Both must agree.

### Must-haves in a production schema
- `type: "object"` at the top level.
- `properties` with **per-property `description`**.
- `required` list for mandatory fields.
- `enum` for fixed value sets.
- `pattern` or `format` (e.g., `"format": "email"`, `"pattern": "^ACC-\\d+$"`).

### Nice-to-haves
- `minLength` / `maxLength` for strings.
- `minimum` / `maximum` for numbers.
- `default` for optional parameters (Claude will include it when unsure).
- Nested `$defs` / `$ref` for complex schemas (supported by Anthropic's JSON schema subset).

### Enum with `"other"` escape hatch
For categorical fields where you can't enumerate all future values:
```json
"document_type": {
  "type": "string",
  "enum": ["invoice", "credit_note", "receipt", "other"]
},
"document_type_detail": {
  "type": "string",
  "description": "Required when document_type = 'other'; free-text description."
}
```
This prevents the agent from getting stuck when an unexpected document type arrives.

## 6. The Four Description Anti-Patterns

| Anti-pattern | Example | Fix |
|---|---|---|
| **Vagueness** | "Searches for stuff" | State the exact output, inputs, and scope |
| **Missing edge cases** | No doc for "what if no matches" | Document the empty-result contract explicitly |
| **Underspecified inputs** | "phone: string" | Add format/pattern/examples |
| **Duplicate/overlapping tools** | `find_user`, `lookup_user`, `search_user` | Merge or differentiate clearly |

## 7. Tool Grouping for Very Large Toolboxes

When your system has 40+ tools (enterprise-scale), **describe** them in **groups** in your system prompt so Claude mentally partitions them:

```
Available tool groups:
- billing/*    — customer account, invoice, refund, payment (~8 tools)
- comms/*      — email, sms, chat, ticket (~5 tools)
- inventory/*  — stock, warehouse, shipping (~6 tools)

Within each group, each tool has a focused description.
```

But — this is a *distribution* problem, not a *description* problem. The real fix is hub-and-spoke (D2.3, D1.2), not more descriptions.

## 8. Descriptions in MCP-Exposed Tools

When tools come from an MCP server, the server owns the description (it's returned in the MCP `tools/list` response). Best practices:
- Your MCP server should emit **the same 5-element descriptions** as internal tools.
- Don't let an MCP server ship with "Run a query" as a description — wrap or rewrite if the upstream is lazy.
- For customizable MCP servers, set environment-driven description prefixes to disambiguate multiple instances of the same server (e.g., `db_prod.query` vs `db_staging.query`).

## 9. Testing Your Descriptions

A description is good only if it survives the **"swap test"**:

1. Show Claude only the list of tool names, no descriptions.
2. Ask it to pick one for a given user intent.
3. Compare to when descriptions are present.

If the description changes the answer, you have a real signal. If it doesn't, your descriptions are either redundant with names or not differentiating.

### Automated regression tests
```python
def test_tool_selection():
    for intent, expected_tool in [
        ("Find [email protected]",          "lookup_customer"),
        ("Refund order #123 $50",      "process_refund"),
        ("Email support about ticket", "send_email"),
    ]:
        chosen = pick_tool(intent, tools)
        assert chosen == expected_tool, f"{intent} → {chosen}"
```
Run on every CI build. Bad descriptions show up as broken tests.

## 10. Exam Self-Check

1. *Which description is best? (a) "Search" (b) "Search for customer records" (c) "Search for customer by email/phone/account; returns customer profile; empty array if no match (not an error)."*
   → c — specific inputs + edge case.
2. *Your agent occasionally picks the wrong tool between `find_customer` and `lookup_user`. Root cause?*
   → Overlapping name + description. Merge or differentiate by scope.
3. *Should `document_type` be a plain `enum`?*
   → Include `"other"` with a `document_type_detail` field for robustness.

---

### Key Takeaways
- ✅ Five elements: purpose, inputs, examples, edge cases, when-not-to-use.
- ✅ Snake_case verb-first names; no near-synonyms.
- ✅ Enum + `"other"` escape hatch for fields that may evolve.
- ✅ Write descriptions as if you are onboarding a new engineer to the tool.
- ❌ Never ship `"searches for stuff"` or equivalent.

Next → [`02-Structured-Error-Responses.md`](02-Structured-Error-Responses.md)
