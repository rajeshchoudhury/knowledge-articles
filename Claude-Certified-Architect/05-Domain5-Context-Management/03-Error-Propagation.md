# D5.3 — Error Propagation & Reliability

> Reliability hinges on one distinction Claude is bad at on its own: **access failure vs empty result**. You must make the distinction loud in your tool responses.

## 1. The Access-Failure vs Empty-Result Distinction (recap from D2)

| Situation | `isError` | Meaning to Claude |
|---|---|---|
| DB unreachable | `true` | "I could not find out." |
| DB reachable, no rows match | `false` | "I found out: there are zero rows." |

Conflating these → silent data corruption.

## 2. Why Propagation Matters

Errors don't stay local. They propagate **through the agentic loop**:

```
Tool error → Claude sees the error → Claude may retry / give up / invent
Claude's reaction → downstream systems → user experience
```

If you suppress errors, Claude doesn't know anything failed. It proceeds with partial / fabricated data, and the user sees a confident, wrong answer.

## 3. Correct Propagation — Through All Layers

### 3.1 Tool layer
- Return `{isError:true, errorCategory, isRetryable, message, context}`.
- Never `return null` on failure.
- Never `raise` a generic exception and let the framework swallow it.

### 3.2 Agent layer
- Read `isError` and branch:
  - `isRetryable=true` → schedule retry with backoff.
  - `errorCategory="access_denied"` → escalate (capability limit).
  - `errorCategory="validation"` → correct inputs and retry.
  - `errorCategory="not_found"` → DIFFERENT from access failure; tool returned isError=false with empty result.

### 3.3 Orchestration layer
- Surface errors in subagent results.
- Don't let a subagent hide a failure with a happy-looking summary.

### 3.4 User-facing layer
- Tell the user honestly: "I couldn't verify X due to a temporary system issue. I'll retry."
- NEVER silently drop the field.

## 4. The Silent-Suppression Trap

```python
try:
    data = fetch_order(order_id)
except Exception:
    data = {}   # ← BUG — now looks like "no data"
```

Claude later sees `data = {}` and says "I see you have no orders" — the user gets a confidently wrong answer.

### Fix
```python
try:
    data = fetch_order(order_id)
    return {"isError": False, "isEmpty": not data, "result": data}
except OrderServiceDown:
    return {"isError": True,
            "errorCategory": "service_unavailable",
            "isRetryable": True,
            "message": "Order service temporarily unreachable",
            "context": {"order_id": order_id}}
```

## 5. Partial Success

Tools that batch multiple operations should report partial success:

```json
{
  "isError": false,
  "result": {
    "succeeded": ["A-1", "A-2", "A-4"],
    "failed": [
      {"id": "A-3", "reason": "not_found"},
      {"id": "A-5", "reason": "permission_denied"}
    ]
  }
}
```

- Whole response isn't an error (three things worked).
- But failed list is explicit — Claude can reason about it.

## 6. Retry Semantics

`isRetryable: true` is not a promise that retrying will succeed — it's a **hint**:

| `isRetryable` | Reason |
|---|---|
| `true` | Transient: timeout, rate-limit, 5xx |
| `false` | Permanent: 404, permission denied, validation |

Claude uses this signal to decide between immediate retry, backoff, or abandonment.

## 7. Error Categories — Canonical List

```
- timeout
- rate_limit
- service_unavailable
- access_denied
- permission_denied     (subset of access_denied; agent lacks permission)
- not_found             (when semantically an error, not empty result)
- validation            (bad inputs, retryable with corrections)
- conflict              (concurrent update; caller can refresh and retry)
- unsupported_operation (capability limit → escalate)
- internal_error        (unknown; log and surface)
```

Standardize across tools. The agent's decision logic becomes a clean switch.

## 8. Error Context — What to Include

Beyond the category and message, include **actionable context**:

```json
{
  "isError": true,
  "errorCategory": "rate_limit",
  "isRetryable": true,
  "message": "Rate limit exceeded",
  "context": {
    "retry_after_ms": 60000,
    "remaining_quota": 0,
    "quota_reset_at": "2025-10-07T18:00:00Z",
    "suggestion": "Wait 60s before retrying or upgrade plan"
  }
}
```

Claude can craft a meaningful response: "I'll pause for a minute and retry."

## 9. Distinguishing Error Causes in Long Pipelines

When multiple tools fail in a pipeline:
- Each failure keeps its category.
- Orchestrator records **which step** failed, not just "something failed."
- Aggregate report: `{stage: "x", succeeded, failed, errors: [...]}`.

Claude can then ask: "Steps 1 – 3 succeeded; step 4 is rate-limited; step 5 requires your authorization. Shall I retry step 4 after a pause, and escalate step 5?"

## 10. Testing Error Paths

For every tool, write:
- ✅ Happy path.
- ✅ Empty result (`isError=false`, `isEmpty=true`).
- ✅ Transient failure (`isRetryable=true`).
- ✅ Permanent failure (`isRetryable=false`).
- ✅ Permission denied (`errorCategory="permission_denied"`).
- ✅ Validation error (should retry with correction).
- ✅ Partial success (for batch tools).

If a test is missing, the path is a lurking production bug.

## 11. Escalation From Errors

Certain errors trigger escalation (capability limit):

| Error | Escalate? |
|---|---|
| `timeout` | No — retry |
| `rate_limit` | No — backoff and retry |
| `validation` | No — fix inputs |
| `access_denied` | ✅ Yes — capability limit |
| `unsupported_operation` | ✅ Yes — capability limit |
| `not_found` for required entity | Depends — retry or escalate |

Hook it to D5.2's escalation framework.

## 12. Anti-Patterns

| Anti-pattern | Problem |
|---|---|
| `return None` on error | Claude assumes data absent, not failure |
| `raise Exception("Tool failed")` | Stack trace leaks; no structured fields |
| No `isRetryable` field | Claude defaults to "give up" or retries forever |
| Same category for all errors | Claude can't distinguish causes |
| Error shown only in `message` (prose) | Harder to route; easy to mis-parse |
| Suppressing errors to "be helpful" | Produces confident wrong answers |

## 13. Exam Self-Check

1. *Database is unreachable. What should the tool return?*
   → `isError: true, errorCategory: "service_unavailable", isRetryable: true`.
2. *Database is reachable but no matching rows. What should the tool return?*
   → `isError: false, isEmpty: true` (or equivalent).
3. *A tool returns `null` on failure. Why is this wrong?*
   → Indistinguishable from "legitimately null." Causes silent wrong answers.
4. *`isRetryable: false` — what does Claude typically do?*
   → Escalate or abandon. Do not retry.

---

### Key Takeaways
- ✅ `isError` distinguishes access failure from empty result.
- ✅ `errorCategory`, `isRetryable`, `context.suggestion` let Claude act sensibly.
- ✅ Propagate through tool → agent → orchestrator → user.
- ❌ Never silently suppress errors.
- ❌ Never conflate access failure with "no data."

Next → [`04-Context-Degradation.md`](04-Context-Degradation.md)
