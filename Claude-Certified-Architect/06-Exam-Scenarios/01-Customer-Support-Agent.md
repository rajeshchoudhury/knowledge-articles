# Scenario 1 — Customer Support Agent

## Business Context
A SaaS company wants an AI customer-support agent that can:
- Answer tier-1 questions (billing, shipping, usage).
- Issue refunds (up to a tier-dependent cap).
- Look up customer orders, tickets, and account status.
- Escalate to a human when appropriate.

## Domains Tested
- **D1**: Agentic loop, hooks, escalation, session management.
- **D2**: Tool set for CRM / billing / refund.
- **D5**: Context management across long conversations, error propagation, stratified metrics.

## Correct Design — End to End

### 1. System prompt
```
You are an AI support agent for Acme SaaS.

Policies:
- Refunds ≤ $500 may be issued by the agent.
- Refunds > $500 MUST be escalated.
- Never respond with "I'm an AI" unless asked.
- Always cite the source of any factual claim.

Capabilities:
- Look up customer info via CRM tools.
- Issue refunds via the refund tool.
- Create support tickets.
- Escalate to human via the escalation tool.
```

### 2. Tools (4 – 5, scoped)
- `get_customer_profile(customer_id)`
- `get_order_history(customer_id, limit=10)`
- `issue_refund(customer_id, order_id, amount, reason)`
- `create_ticket(customer_id, subject, body, priority)`
- `escalate_to_human(reason, context)`

### 3. Hooks (deterministic enforcement)
```python
def preToolUse_refund_cap(tool, params, ctx):
    if tool == "issue_refund" and params["amount"] > 500:
        return {"allow": False,
                "message": "Amount > $500 requires escalation."}
    return {"allow": True}
```

Plus `preToolUse_pii_redaction` on outbound writes if needed.

### 4. Case facts block (pinned)
```
## Case Facts
- Customer ID: C-42119
- Tier: enterprise
- Open tickets: 2
- Refunds YTD: $450
- Refund cap for this tier: $500
- Escalation flags: none
```

Updated after every tool call.

### 5. Escalation triggers (D5.2)
- Explicit human request.
- Policy gap (no rule applies).
- Capability limit (tool denied).
- Threshold breach (refund > $500).

Enforced by hook, not by the prompt.

### 6. Session management
- Each new conversation = new session.
- Long-running customer case → `--resume <session_id>`.
- Exploratory branches (multiple solution paths) → `fork_session`.
- Summarize only via scratchpad file, not `/compact`.

### 7. Provenance
Every factual claim cites CRM/tool source + timestamp.

### 8. Stratified metrics
- Resolution rate **by tier** (free / pro / enterprise).
- Escalation rate **by trigger**.
- Refund volume **by tier and amount band**.

## Likely Exam Questions — Sample

### Q: A customer tweets "@Acme your agent is useless!!!" and the session has 15 messages. Should the agent escalate now?
**Correct**: Only if the customer explicitly requests a human OR a threshold / capability / policy trigger has fired. Sentiment alone is NOT a valid trigger. (D5.2)

**Distractor**: "Yes — the customer is clearly frustrated." — sentiment-based; invalid.

### Q: The refund tool's description says "Issues a refund to the customer." Is that sufficient?
**Correct**: No. Must include limit, required inputs, edge cases (partial refunds?), when NOT to use. (D2.1)

### Q: After 40 turns, the agent is forgetting the customer's tier. Best remediation?
**Correct**: Pin a case-facts block + scratchpad file. (D5.4)

**Distractor**: `/compact` every 10 turns. — compounds summarization drift.

### Q: A refund of $1,200 is requested. Design the refund tool path correctly.
**Correct**: PreToolUse hook blocks → escalate_to_human with structured context (reason: threshold_breach, amount, customer, policy quote). (D1 hooks + D5.2 escalation)

**Distractor**: Agent prompt says "don't refund > $500". — suggestion, not enforcement.

### Q: Error case — CRM is down. What does `get_customer_profile` return?
**Correct**: `{isError:true, errorCategory:"service_unavailable", isRetryable:true, message:"CRM unreachable", context:{}}`. Agent retries or escalates. (D5.3)

**Distractor**: Returns `{}` with no error flag. — silent suppression; leads to wrong answers.

## Exam Tells In This Scenario
- "Customer seems frustrated" → sentiment trigger → INVALID.
- "Refund > $X" → threshold → must be hook-enforced.
- "Long conversation / many turns" → context degradation → case facts + scratchpad.
- "DB unreachable" → service_unavailable, retryable.
- "No rows found" → empty result, `isError:false, isEmpty:true`.

## Anti-Pattern Summary
1. Prompt-only escalation rules.
2. Sentiment-based escalation.
3. `/compact` as the go-to context fix.
4. `return None` or silent suppression on tool errors.
5. One refund tool with a $500 soft guideline in text.
6. Aggregate resolution rate without stratification.

## 10-Point Checklist for This Scenario
- [ ] 4–5 tools, not more.
- [ ] Descriptive tool descriptions with examples, edge cases.
- [ ] Structured error responses (isError, errorCategory, isRetryable).
- [ ] PreToolUse hook for refund threshold.
- [ ] Explicit escalation function with structured payload.
- [ ] Case facts block + scratchpad for long sessions.
- [ ] Stratified metrics by tier.
- [ ] Provenance on cited facts.
- [ ] Human review on all escalations; random audit on 1% of tier-1 closures.
- [ ] Never trigger on sentiment / self-confidence / turn count.
