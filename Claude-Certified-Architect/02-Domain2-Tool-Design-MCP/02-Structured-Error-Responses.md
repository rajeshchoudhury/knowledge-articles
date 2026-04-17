# D2.2 — Structured Error Responses

> The single concept most commonly tested in Domain 2: **access failure is not the same as empty result**.

## 1. The Core Distinction

Claude is given a tool. The tool "returns something." Claude's next action depends entirely on whether that something says:
- "I checked and found nothing" (**empty result**), or
- "I could not even check" (**access failure**).

These are fundamentally different states, and they lead to **opposite** decisions:

| State | Claude's next action |
|---|---|
| Empty result (`isError: false`, `results: []`) | Believe it. "No customer with that email exists." |
| Access failure (`isError: true`, `isRetryable: true`) | Retry, or try an alternative, or escalate. |

If your tool silently returns `[]` when it failed to connect, Claude draws a **catastrophically wrong** conclusion: "There are no customers named John Smith" — when the real fact is "we couldn't talk to the DB."

## 2. The Canonical Structured Error Shape

```json
{
  "isError":        true,
  "errorCategory":  "timeout",
  "isRetryable":    true,
  "context": {
    "attempted":  "Customer lookup by email: [email protected]",
    "service":    "customer-db",
    "timeout_ms": 5000,
    "suggestion": "Retry after 2s or try account_id lookup instead"
  }
}
```

### Field-by-field

| Field | Purpose | Values |
|---|---|---|
| `isError` | Is this a failure? | `true` / `false` |
| `errorCategory` | What kind of failure? | `"timeout"`, `"auth"`, `"not_found"`, `"rate_limit"`, `"validation"`, `"permission"`, `"internal"` |
| `isRetryable` | Should the agent try again? | `true` for transient (timeout, rate_limit), `false` for persistent (auth, permission) |
| `context` | What was attempted + what specifically failed | Free-form object, include enough to act on |
| `context.suggestion` | (optional but recommended) What the agent should do next | "Retry after 2s", "Try alternative lookup", "Escalate" |

### Empty-result shape (NOT an error)

```json
{
  "isError": false,
  "customers": [],
  "metadata": {
    "searched_by": "email",
    "query":       "[email protected]",
    "results_count": 0,
    "searched_at": "2026-04-17T14:32:00Z"
  }
}
```

The metadata block is extra — it's not required, but it gives the agent confidence that the search actually ran.

## 3. The Six Error Categories You Must Know

| Category | Typical cause | Retryable? | Agent's best response |
|---|---|---|---|
| `timeout` | Network slow, service overloaded | ✅ usually | Exponential backoff retry |
| `rate_limit` | Exceeded API quota | ✅ after delay | Wait, then retry; escalate if persistent |
| `auth` | Token expired / invalid | ❌ | Escalate; do NOT retry |
| `permission` | Token valid but scope insufficient | ❌ | Escalate; document the scope gap |
| `not_found` | Resource genuinely missing | ❌ | Accept; decide if user needs to create |
| `validation` | Input wrong shape | ❌ | Fix the input, retry with corrected input |
| `internal` | Server error, unexpected | ✅ once | Retry once; escalate if persistent |

These six cover ~95 % of real-world tool errors. The exam may throw additional categories, but the fundamentals (retryable vs. not, fix vs. escalate) always hold.

## 4. Why Generic Errors Are Disqualified

Compare the two:

```json
{ "error": "Operation failed" }
```
vs.
```json
{
  "isError": true,
  "errorCategory": "rate_limit",
  "isRetryable": true,
  "context": {"retry_after_ms": 30000, "service": "crm-api"}
}
```

With the first, Claude has no idea:
- Whether to retry (waste of tokens)
- When to retry (blind backoff)
- Whether to try an alternative tool
- Whether to escalate

The agent ends up guessing — usually the wrong guess.

## 5. The Silent-Suppression Anti-Pattern

Most production bugs from Claude agents trace back to this:

```python
# DEFINITELY DON'T DO THIS
def lookup_customer(email):
    try:
        return db.query("SELECT * FROM customers WHERE email = %s", email)
    except Exception:
        return []          # Silently swallowed — Claude thinks "no customer"
```

The fix:

```python
def lookup_customer(email):
    try:
        rows = db.query("SELECT * FROM customers WHERE email = %s", email)
        return {"isError": False, "customers": rows}
    except TimeoutError as e:
        return {
            "isError": True,
            "errorCategory": "timeout",
            "isRetryable": True,
            "context": {
                "attempted": f"Customer lookup by email={email}",
                "service":   "customer-db",
                "timeout_ms": 5000,
                "suggestion": "Retry after 2s or try account_id lookup"
            }
        }
    except AuthError as e:
        return {
            "isError": True,
            "errorCategory": "auth",
            "isRetryable": False,
            "context": {"attempted": ..., "suggestion": "Escalate for credential refresh"}
        }
```

## 6. Is-Retryable — How Claude Uses It

`isRetryable` gives the agent a structured decision:

```
if response.isError:
    if response.isRetryable:
        if attempt < MAX_RETRIES:
            backoff_and_retry()
        else:
            escalate_with_context()
    else:
        # Not worth retrying — pick alternative or escalate
        try_alternative_tool() or escalate()
```

An agent with well-labeled retryability:
- Never retries auth errors (wasted effort).
- Always retries transient timeouts (correct behavior).
- Escalates when alternatives and retries fail.

## 7. Enriching Errors with `context.suggestion`

Include actionable next-step hints:

| `errorCategory` | Good `suggestion` value |
|---|---|
| `timeout` | "Retry after 2 seconds with exponential backoff" |
| `rate_limit` | "Wait 30s or escalate if burst continues" |
| `auth` | "Escalate — credentials need refresh, do not retry" |
| `permission` | "Request scope X; escalate to admin" |
| `not_found` | "Try alternative lookup method (account_id)" or "Offer to create resource" |
| `validation` | "Fix field X (expected YYYY-MM-DD, got '2-13-2025') and retry" |

These hints turn a passive error message into a **programmable recovery plan**.

## 8. Access Failure vs. Empty Result — the Decision Table

| Situation | Tool response shape |
|---|---|
| Connection to DB timed out | `{ isError: true, errorCategory: "timeout", isRetryable: true, ... }` |
| Connected, query ran, returned 0 rows | `{ isError: false, results: [], metadata: {...} }` |
| Connected, query returned 5 rows | `{ isError: false, results: [...], metadata: {...} }` |
| Auth token rejected | `{ isError: true, errorCategory: "auth", isRetryable: false, ... }` |
| Payload malformed | `{ isError: true, errorCategory: "validation", isRetryable: false, context: {which_field, why} }` |
| 429 Too Many Requests | `{ isError: true, errorCategory: "rate_limit", isRetryable: true, context: {retry_after_ms} }` |

Print this table. Tape it to your desk.

## 9. Errors in Multi-Agent Systems (Preview of D5.2)

When a subagent errors, it must **propagate structured context** back up:

```
Subagent error → {isError, errorCategory, context}
        ↓
Coordinator sees: "Subagent A failed with `rate_limit`, isRetryable=true"
        ↓
Coordinator decides: retry A, or dispatch B with alternative source, or escalate
```

Never have a subagent return `null` or an empty object on failure — coordinators can't tell the difference between "subagent checked and found nothing" and "subagent never got off the ground."

## 10. Partial Success — a Common Exam Trap

Sometimes a tool partially succeeds. Example: you're fetching 100 customer records; 87 succeed, 13 time out.

### ❌ Wrong shape
```json
{ "customers": [...87 records...] }
```
Claude thinks it got the full 100 or doesn't know.

### ✅ Correct shape
```json
{
  "isError": false,
  "customers": [...87 records...],
  "partial": true,
  "errors": [
    {
      "id": "ACC-12345",
      "errorCategory": "timeout",
      "isRetryable": true,
      "context": {"suggestion": "Retry these IDs individually"}
    },
    ...
  ],
  "summary": {"requested": 100, "succeeded": 87, "failed": 13}
}
```

Now Claude can decide: retry the 13 failures, fall back to an alternative, or escalate if the failure rate is anomalous.

## 11. Exam Self-Check

1. *A customer-lookup tool fails to reach the DB. Which shape should it return?*
   → `{ isError: true, errorCategory: "timeout", isRetryable: true, context: {...} }`
2. *A customer-lookup tool runs successfully but finds no customer. Shape?*
   → `{ isError: false, customers: [] }`
3. *An auth error — is it retryable?*
   → **No**, `isRetryable: false`. Claude should escalate.
4. *Your tool returned `{ "customers": [] }` when the DB was actually down. What category of bug?*
   → Silent suppression. The agent will believe there are no customers. Fix: always distinguish access failures from empty results.

---

### Key Takeaways
- ✅ Every tool response includes `isError` (true/false).
- ✅ Errors include `errorCategory`, `isRetryable`, and `context`.
- ✅ Distinguish access failure (`isError: true`) from empty result (`isError: false, results: []`).
- ✅ Include actionable `context.suggestion` to guide agent's next step.
- ✅ Partial successes must flag `partial: true` with per-item errors.
- ❌ Never return a generic `"Operation failed"` string.
- ❌ Never swallow errors into an empty collection.

Next → [`03-Tool-Distribution.md`](03-Tool-Distribution.md)
