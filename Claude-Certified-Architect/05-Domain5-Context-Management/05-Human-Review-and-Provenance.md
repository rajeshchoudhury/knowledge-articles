# D5.5 — Human Review, Provenance, and Stratified Metrics

> Production reliability requires three things most teams skip: well-timed human review, full information provenance, and metrics you can actually trust.

## 1. Human Review — When and How

Human-in-the-loop (HITL) review is appropriate when:

- **Irreversible actions** are about to happen (payments, deletions, account changes).
- **High-stakes decisions** with legal / compliance impact (contracts, medical, financial).
- **New behaviors** being rolled out (canary HITL first).
- **Escalation triggers fired** (D5.2).
- **Confidence-adjacent proxies**: NOT the model's self-confidence, but signals like "validation retries hit the cap" or "rule conflict detected."

### Anti-pattern: HITL on everything
- Adds latency.
- Fatigues reviewers.
- Creates the perception that AI is unreliable.

HITL should be a **targeted gate**, not a blanket filter.

## 2. Design Patterns

### 2.1 Pre-action approval (blocking)
```
Claude proposes action → Hook pauses → Human approves / rejects → Action executes
```

Use for: refunds, sends, writes to production.

### 2.2 Post-action review (non-blocking)
```
Claude completes action → Logs to review queue → Human audits async
```

Use for: informational responses, internal reports.

### 2.3 Sampled audit
```
1 / N actions are flagged for human review, randomly.
```

Use for: high-volume tasks where per-item review is infeasible but quality assurance is needed.

### 2.4 Confidence-like triggers (but deterministic)
```
if validation_retries == max and still_failing:
    route_to_human()
```

Based on **deterministic** signals (retry count), not model confidence.

## 3. Provenance — Know Where Every Datum Came From

**Provenance** = the documented lineage of each piece of information Claude cites.

### 3.1 Minimum provenance fields
```json
{
  "value": "$1,250",
  "source": "CRM.order_table",
  "source_id": "O-998",
  "retrieved_at": "2025-10-06T14:32:11Z",
  "retrieved_by_tool": "get_order",
  "confidence": "high"
}
```

### 3.2 When Claude speaks, it should cite
- "Your last refund was **$1,250** [CRM, O-998, retrieved just now]."
- "Per policy §3.2, refunds > $500 require manager approval [policy_doc v2.4]."

### 3.3 Why provenance matters
- **Auditability** — can reconstruct any decision after the fact.
- **Debuggability** — when something's wrong, you can find the source.
- **Trust** — humans can verify cited information.
- **Staleness detection** — a source retrieved 30 days ago may be stale.

## 4. Confidence — Not the Model's Self-Confidence

The exam is clear: **LLM self-reported confidence is miscalibrated and should not drive decisions**.

What you **can** use for a proxied confidence:
- **Source reliability** — "CRM" = high; "user's paraphrase" = low.
- **Recency** — "retrieved 10 s ago" = high; "30 days ago" = low.
- **Corroboration** — 2 independent sources agree = high.
- **Validation results** — passed schema + semantic checks = high.

Combine into a **confidence score** that is deterministic and reviewable.

## 5. Stratified Metrics — Don't Aggregate

Aggregated metrics hide failures. Example:

```
Overall accuracy: 95 %  ← LOOKS GREAT
```

Stratified:

```
By document type:
  invoices:   70 %  ← PROBLEM
  receipts:   99 %
  contracts:  100 %

By region:
  US:  98 %
  EU:  92 %
  APAC: 85 %  ← PROBLEM

By amount band:
  < $100:   99 %
  $100–$1K: 95 %
  > $1K:    80 %  ← PROBLEM (high-value!)
```

**Exam mantra**: Stratify by dimensions that matter to the business — document type, region, amount band, user tier, time window.

## 6. Metric Design

Track:
- **Precision** (true positives / positives produced).
- **Recall** (true positives / actual positives).
- **Escalation rate** (and per-trigger breakdown).
- **Retry rate** (and avg retries per task).
- **Average latency** (p50, p95, p99 — p99 is often the actual user experience).
- **Tool-call error rates** (per tool, per error category).
- **Human-review outcomes** — approve vs. reject ratio; what percentage flipped by humans?

## 7. Dashboards That Matter

Minimum dashboard for a production agent:
1. **Task success rate** — stratified by task type.
2. **Escalation rate** — stratified by trigger.
3. **Retry distribution** — number of retries per task.
4. **Latency percentiles** — p50 / p95 / p99.
5. **Cost per task** — tokens, by model.
6. **Human override rate** — when humans disagreed with the agent.

Review weekly. Alert on anomalies.

## 8. Error & Escalation Replay

Build the ability to **replay** any flagged decision:
- Full session transcript.
- All tool calls and responses.
- Provenance of every cited fact.
- Policy version active at time of decision.

This is what lets you debug, audit, and improve without hand-waving.

## 9. Policy Versioning

Policies change. Provenance should include the policy version:
```json
"policy_quotes": [
  {
    "text": "Refunds > $500 require manager approval",
    "policy_id": "refund_policy",
    "version": "v2.4",
    "retrieved_at": "2025-10-06T14:32:11Z"
  }
]
```

Auditability = "What policy was in effect when Claude made this decision?"

## 10. The Feedback Loop

Close the loop: every human override should feed back into:
- **Prompt improvements** — add anti-examples.
- **Policy clarifications** — update the source policy doc.
- **Escalation threshold tuning** — maybe the threshold is too loose / tight.
- **Stratified metric tracking** — does the failure cluster?

Agents that don't close the loop drift into irrelevance.

## 11. Common Anti-Patterns

| Anti-pattern | Why wrong |
|---|---|
| HITL for every action | Too slow; reviewer fatigue |
| No HITL ever | Missing critical gates for irreversible actions |
| Using model's self-confidence to gate actions | Miscalibrated |
| Aggregate accuracy only | Masks category failures |
| No provenance on cited facts | Unauditable; unverifiable |
| No policy version tracking | Can't explain past decisions |
| No replay capability | Bug fixes are guesswork |

## 12. Exam Self-Check

1. *HITL is required on every agent action. Problem?*
   → Too slow; reviewer fatigue; defeats automation.
2. *"Overall 95 % accuracy." What's wrong with this reporting?*
   → Aggregated; mask per-category failures. Demand stratified metrics.
3. *A fact cited by the agent is later disputed. What do you need to resolve?*
   → Provenance (source, retrieved_at, retrieved_by_tool).
4. *Acceptable "confidence" signals?*
   → Deterministic proxies: source reliability, recency, corroboration, validation pass.
5. *Inappropriate "confidence" signals?*
   → Model's self-reported confidence.

---

### Key Takeaways
- ✅ HITL = targeted gate (irreversible / high-stakes / new behavior / escalation).
- ✅ Full provenance on every cited fact (source, timestamp, tool, version).
- ✅ Deterministic confidence proxies, not model self-confidence.
- ✅ Stratified metrics (per type / region / amount / tier).
- ✅ Close the loop: humans' overrides feed back into the system.
- ❌ HITL on everything = broken UX.
- ❌ Aggregate-only metrics = blind to category failures.

→ You've finished Domain 5 and all core study material. Continue to [`../06-Exam-Scenarios/`](../06-Exam-Scenarios/) for the six exam scenario deep-dives.
