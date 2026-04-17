# D4.5 — Validation-Retry Loops & Multi-Pass Review

> "Retry with specific errors" is one of the most-tested patterns. Anti-pattern: generic "please try again."

## 1. Why Validation-Retry Loops Exist

`tool_use` guarantees schema compliance. But **semantic correctness** — "is the vendor name actually that vendor?", "does the total match the line items?" — is model-dependent. On a single pass, errors slip through.

The **validation-retry loop** catches those errors, appends specific feedback, and retries — the model self-corrects far more reliably than on one shot.

## 2. The Canonical Loop

```python
def extract_with_validation(document, max_retries=3):
    messages = [{"role": "user", "content": f"Extract data from: {document}"}]

    for attempt in range(max_retries):
        response = client.messages.create(
            model="claude-sonnet-4-20250514",
            tools=[extract_tool],
            tool_choice={"type": "tool", "name": "extract_invoice"},
            messages=messages,
        )

        data = parse_tool_response(response)
        errors = validate(data)       # SEMANTIC validation

        if not errors:
            return data

        # CRITICAL: append SPECIFIC errors
        messages.append({"role": "assistant", "content": response.content})
        messages.append({
            "role": "user",
            "content": (
                "Validation failed. Fix these SPECIFIC errors:\n"
                + "\n".join(f"- {e}" for e in errors)
                + "\nRe-extract with corrections."
            )
        })

    raise ExtractionError(f"Failed after {max_retries} attempts", errors)
```

## 3. "Specific" Is the Keyword

### ❌ Generic feedback (anti-pattern)
```
Validation failed. Please try again.
```

The model has no signal about **what** to fix. Next attempt is a coin flip.

### ✅ Specific feedback
```
Validation failed. Fix these errors:
- Field `date` has value "2-13-2025" which is not ISO 8601. Expected YYYY-MM-DD.
- Line items total ($450.00) does not match subtotal ($500.00). Re-examine.
- Field `currency` is "dollars" but schema requires ISO-4217 code (e.g., "USD").
```

The model now has a clear correction target. It will fix each error individually.

## 4. What to Validate (semantic checks)

| Domain | Examples |
|---|---|
| Dates | ISO 8601 format, in valid range, not future |
| Numbers | positive / in bounds / arithmetic consistency (totals = Σ items) |
| Strings | matches pattern, non-empty, not "N/A" or "unknown" |
| Enums | in allowed set (schema does this, but check your enrichment) |
| Cross-field | `document_type == 'other'` → `document_type_detail` required |
| References | IDs exist in your DB / whitelist |
| Business rules | e.g., `country='US'` ⇒ `state` required |

## 5. When to Retry vs When to Escalate

Not every failure is retry-worthy:

| Error | Retry? |
|---|---|
| Extraction missed a field | ✅ Retry with specific mention |
| Date format wrong | ✅ Retry |
| Total mismatch | ✅ Retry (model can re-examine) |
| Document is illegible / blurry | ❌ Escalate — model can't fix unseen data |
| Schema says document is "invoice" but content is "shipping label" | ❌ Escalate — wrong doc type routed |

After `max_retries`, escalate with structured context (next section).

## 6. Multi-Pass Review

**Multi-pass** is a related pattern: split one large review into multiple smaller passes.

### 6.1 Per-file local pass + cross-file integration pass

Classic pattern for codebase review:

```
Pass 1 (local): Review each file independently
  - Catches: syntax, naming, missing error handling, per-file quality
  - Runs in parallel (one subagent per file)

Pass 2 (integration): Review the collection as a whole
  - Catches: broken imports, interface mismatches, circular deps
  - Runs with output of Pass 1 as input
```

This beats single-pass review because:
- Per-file review is focused and parallelizable.
- Cross-file review sees the whole picture.
- Each pass has distinct criteria (single-file vs. multi-file).

### 6.2 Per-section review

For long documents (contracts, legal):
- Pass 1: review each section individually (terms, indemnity, IP, liability).
- Pass 2: review how sections interact (is there a conflict between §3 and §7?).

## 7. Self-Review in the Same Session — Anti-Pattern

> **Same-session self-review is the #1 multi-pass anti-pattern.**

If the same session generates code AND reviews it:
- The reviewer retains the generator's reasoning context.
- **Confirmation bias** — the reviewer mentally defends the code.
- Findings are softer, rarer, and less critical.

### ✅ Correct
```
Session A: Generate code
Session B (fresh): Review the diff from Session A
```

Session B must have **no context** from Session A — only the diff itself.

## 8. The `detected_pattern` Field

For systemic errors (same issue across many extractions), add a `detected_pattern` field to your output:

```json
{
  "issues": [...],
  "detected_pattern": {
    "description": "Field `date` fails ISO 8601 in 70% of invoices",
    "confidence": "high"
  }
}
```

This lets the upstream system fix the root cause (e.g., upgrade the extractor prompt) rather than retrying each failure individually.

## 9. Stratified Metrics (preview of D5)

When tracking success of your validation loop, **don't aggregate**:

```
Overall accuracy: 95 %       ← LOOKS GREAT
Invoices:  70 %              ← PROBLEM HIDING HERE
Receipts:  99 %
Contracts: 100 %
```

Track accuracy per document type (stratified metrics). Aggregate always masks at least one category failing.

## 10. Sync vs Batch in the Retry Loop

- **Blocking flows** (real-time extraction): synchronous retries with short backoffs.
- **Non-urgent flows** (nightly extraction): retry into the next batch; 50% cost savings.
- Mixed: synchronous for first attempt, batch for retries if failure rate high.

## 11. Retries and Max Attempts

- **3 retries** is the practical sweet spot.
- Beyond 3, you're usually hitting a systemic issue (bad input, schema mismatch, degraded model).
- Log each retry's attempt and reason — feed into stratified metrics.

## 12. Anti-Patterns Summary

| Anti-pattern | Why wrong | Fix |
|---|---|---|
| Generic "please try again" | No signal; same error repeats | Append specific errors |
| Same-session self-review | Confirmation bias | Separate sessions |
| Single-pass review on a large codebase | Misses cross-file issues | Multi-pass (local + integration) |
| Aggregate accuracy metrics | Masks per-category failure | Stratified metrics |
| Unbounded retries | Wastes tokens; never catches systemic | Cap at 3; log to metrics |
| Retrying semantically impossible failures (illegible doc) | Never converges | Escalate after N attempts |

## 13. Exam Self-Check

1. *A retry loop sends "There were errors, try again." Fix?*
   → Append specific errors (which field, what's wrong, expected vs actual).
2. *Same session generates code and reviews it. Problem?*
   → Confirmation bias — reviewer retains generator's reasoning.
3. *A codebase-wide review runs as one giant prompt. Better approach?*
   → Multi-pass: per-file local + cross-file integration.
4. *Overall accuracy 96 % but users complain. How to diagnose?*
   → Stratified metrics: break down per category; likely one is underperforming.

---

### Key Takeaways
- ✅ Retries append **specific** errors (field, reason, expected/actual).
- ✅ Multi-pass = per-file local + cross-file integration.
- ✅ **Separate sessions** for generator and reviewer.
- ✅ Cap retries (~3) and escalate beyond.
- ✅ Track **stratified** (per-category) metrics.
- ❌ Never retry with "please try again."
- ❌ Never self-review in the same session.

→ You have now finished Domain 4. Continue to [`../05-Domain5-Context-Management/01-Context-Optimization.md`](../05-Domain5-Context-Management/01-Context-Optimization.md).
