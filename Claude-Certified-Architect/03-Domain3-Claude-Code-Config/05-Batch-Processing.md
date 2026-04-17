# D3.5 — Batch Processing (Message Batches API)

> Memorize the three magic numbers: **50 %** savings, **24-hour** window, `custom_id` for tracking.

## 1. What the Batch API Is

Anthropic's **Message Batches API** lets you submit many Claude requests in a single batch. The trade-off:

- **Savings**: 50 % off the token cost.
- **Latency**: Up to 24 hours to complete (usually much less in practice).
- **Shape**: Each request must be independent; they run in parallel.

This is the obvious choice for **large-volume, non-urgent** workloads.

## 2. When to Use It

### ✅ Great fit
- Nightly code audits across an entire repo.
- Weekly compliance scans over documents.
- Data-enrichment pipelines (embed 100 k rows).
- Bulk data extraction (extract from 50 k invoices overnight).
- Back-fills of historical data.

### ❌ Bad fit
- Blocking PR reviews (you need feedback in minutes, not hours).
- Customer-facing agents (latency-sensitive).
- Real-time chat.
- Interactive dev workflows.

## 3. Anatomy of a Batch Request

```python
from anthropic import Anthropic

client = Anthropic()

batch = client.messages.batches.create(
    requests=[
        {
            "custom_id": "invoice_00001",
            "params": {
                "model": "claude-sonnet-4-20250514",
                "max_tokens": 1024,
                "tools": [extract_tool],
                "tool_choice": {"type": "tool", "name": "extract_invoice"},
                "messages": [{"role": "user", "content": f"Extract: {INVOICE_00001}"}],
            }
        },
        {
            "custom_id": "invoice_00002",
            "params": { ... }
        },
        # up to 10,000 per batch
    ]
)

print(batch.id)
```

### Key fields
- `custom_id` — your identifier for this request. **Required**. Use it to reconcile results.
- `params` — the normal `messages.create(...)` params.
- Up to **10 000 requests per batch**, **32 MB total**.

## 4. Polling / Awaiting Results

```python
import time

while True:
    batch = client.messages.batches.retrieve(batch.id)
    if batch.processing_status == "ended":
        break
    time.sleep(60)

# Fetch results (stream or download)
for result in client.messages.batches.results(batch.id):
    custom_id = result.custom_id
    if result.result.type == "succeeded":
        response = result.result.message
        handle(custom_id, response)
    else:
        handle_error(custom_id, result.result.error)
```

### Status values
- `in_progress` — running
- `canceling` — cancellation requested
- `ended` — done (may include successes, failures, and expirations)

## 5. The 50 % Savings — What They Mean

Anthropic charges **~50 %** of list-price per token for batched requests. On a 1-million-request/month pipeline:

- Synchronous: $X
- Batch: **$X/2**

Over a year on a 10k/day pipeline, the savings can easily be 5–6 figures. For any latency-tolerant workload, Batch is the architectural default.

## 6. The 24-Hour SLA

Anthropic commits to completing batches within 24 hours. In practice most batches complete in **minutes to an hour** — but design your system around the 24h SLA:

- Workloads that can tolerate **tomorrow-morning results** (nightly reports).
- Workloads that tolerate **same-week completion** for very large batches.
- Workloads that fail fast if 24h elapses (your consumer should set its own deadline).

## 7. Decision Tree — Sync vs Batch

```
Is latency < 1 hour required?     YES → synchronous
                                  NO  ↓
Is the workload > 100 requests?   YES → batch
                                  NO  → either (synchronous is fine)
Will you re-run this daily/weekly? YES → batch
                                  NO  → either
Can you tolerate 24h SLA?         NO  → synchronous
                                  YES ↓
Cost-sensitive?                   YES → **BATCH (50% off)**
                                  NO  → either
```

## 8. Patterns in the Wild

### 8.1 Nightly code audit
```
cron: 2 AM
  ↓
Walk repo → group files into 5 000 requests → submit as one batch
  ↓
Wait overnight
  ↓
Process results → post summary to Slack at 9 AM
```
Typical savings vs synchronous: 50 % on ~5 M tokens/night.

### 8.2 Weekly doc extraction
```
Sunday night: 50 000 new documents arrive
  ↓
Chunk into 5 batches of 10 000 → submit all
  ↓
Monday AM: results in data warehouse
```

### 8.3 Back-fill historical
```
One-time: re-classify 2 M historical customer tickets
  ↓
Chunk into 200 batches of 10 000 → submit staggered over 2 days
  ↓
Results flow into BI
```

## 9. Structuring Results with `custom_id`

Always use **structured, reproducible `custom_id`s**:

| Pattern | Example |
|---|---|
| `{entity}_{id}` | `invoice_00042`, `ticket_95123` |
| `{batch}_{index}` | `run_2026-04-17_042` |
| `{domain}_{hash}` | `sku_a1b2c3d4` |

- Never random UUIDs if you want to correlate back to source.
- `custom_id` shows up in both the result records and the billing CSV — use it as your primary key throughout the pipeline.

## 10. Error Handling in Batches

Batches are best-effort; individual requests can fail without sinking the batch. Expect:

- `succeeded` — normal response
- `errored` — API-level error (rate_limit, context_length, invalid_params)
- `canceled` — batch was canceled
- `expired` — exceeded 24h SLA

Your consumer pattern:
```python
for result in client.messages.batches.results(batch.id):
    match result.result.type:
        case "succeeded": store(result.custom_id, result.result.message)
        case "errored":   log_error(result.custom_id, result.result.error)
        case "expired":   re_enqueue_synchronously(result.custom_id)
        case "canceled":  ignore()
```

## 11. Combining Batch with Other Patterns

- **Tool use** works in batch — each request can force a tool (`tool_choice: {"type": "tool", "name": ...}`).
- **Validation-retry** (D4.4): if a batch result fails validation, you can either (a) retry that item synchronously with specific errors appended, or (b) re-enqueue into the next overnight batch.
- **Batch + hooks**: hooks run on tool calls; in batch mode tools still fire, so your hooks enforce rules at scale.

## 12. Anti-Patterns

| Anti-pattern | Why wrong |
|---|---|
| Synchronous for nightly jobs | 2× the cost for no latency benefit |
| Batch for blocking PR reviews | Users wait 24 h — unusable |
| Random UUID `custom_id`s | Hard to reconcile back to source |
| Not handling `expired` results | Lost data on SLA boundaries |
| Over-batching (> 10 k items per batch) | Hits limits; split into multiple |
| No monitoring of batch throughput | Silent backlogs |

## 13. Exam Self-Check

1. *Nightly code audit of the whole repo — sync or batch?*
   → **Batch**. Non-urgent, large volume.
2. *Latency to feedback in a PR review that opens every 15 min — sync or batch?*
   → **Sync**. PR review is blocking.
3. *How much do you save with the Batch API?*
   → ~50 %.
4. *Maximum batch SLA?*
   → 24 hours.
5. *What do you use to track individual requests in a batch?*
   → `custom_id`.

---

### Key Takeaways
- ✅ Batch API = 50 % off, 24 h SLA.
- ✅ Use for non-urgent, high-volume work.
- ✅ Always supply a meaningful `custom_id`.
- ✅ Handle `succeeded`, `errored`, `expired`, `canceled` in your consumer.
- ❌ Never use Batch for blocking UX.
- ❌ Never use Synchronous for nightly/back-fill jobs.

→ You have now finished Domain 3. Continue to [`../04-Domain4-Prompt-Engineering/01-Explicit-Criteria.md`](../04-Domain4-Prompt-Engineering/01-Explicit-Criteria.md).
