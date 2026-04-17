# D5.2 — Escalation Triggers — Objective vs Subjective

> The exam will give you a list of escalation triggers and ask which are **valid**. The rule: **only objective, verifiable triggers are valid**. Sentiment and confidence are always invalid.

## 1. The Core Rule

> **Escalation must fire on objective criteria. Never on the model's self-reported confidence or on customer sentiment.**

Why? Because LLMs:
- Are **miscalibrated** on confidence (model "high confidence" ≠ actual correctness).
- **Mis-read** sentiment (sarcasm, cultural differences, terse writing).
- Have **strong prior biases** that drift with prompt phrasing.

Objective triggers, by contrast, are:
- **Verifiable** (a threshold number, a keyword match).
- **Deterministic** (same input → same output).
- **Auditable** (easy to log / explain).

## 2. The Four Valid Escalation Triggers

### 2.1 Explicit customer request
> "Please transfer me to a human." / "I want to speak to a manager."

Trigger: exact or near-exact phrases like `speak to human`, `talk to manager`, `agent`, `representative`.

### 2.2 Policy gap
The request falls outside any documented policy. The agent has no rule that applies.

Trigger: when the decision path in the policy tree hits an "undefined" leaf.

### 2.3 Capability limit
The required action exceeds what the tools / permissions allow.

Trigger: tool returns `isError: true, errorCategory: "permission_denied"` or `"unsupported_action"`.

### 2.4 Threshold breach
A hard numeric or policy threshold is crossed — e.g., refund > $500, discount > 25 %, account change requires VP approval.

Trigger: quantitative check on a known field.

## 3. Invalid Triggers (never use)

| Trigger | Why invalid |
|---|---|
| **Customer sentiment / anger** | Sentiment detection is unreliable; also penalizes upset customers arbitrarily |
| **Model's self-reported confidence** | Miscalibrated; confident wrong >> uncertain right |
| **Message length** | Long ≠ complex; short ≠ simple |
| **Number of turns so far** | Turn count ≠ difficulty |
| **"Looks suspicious"** | Vague and model-subjective |
| **"Customer seems confused"** | Sentiment again |

### Memorable exam phrasing

> "Customer sentiment, message length, and model-reported confidence are **never** valid escalation triggers."

## 4. Canonical Example

```python
def should_escalate(request, decision, policy):
    # 4 VALID triggers
    if contains_explicit_human_request(request):
        return True, "explicit_human_request"
    if policy.applies_to(request) is None:
        return True, "policy_gap"
    if decision.requires_tool and decision.tool_access_denied:
        return True, "capability_limit"
    if decision.refund_amount and decision.refund_amount > REFUND_CAP:
        return True, "threshold_breach"
    # Explicitly NOT escalating on:
    # - customer sentiment
    # - model confidence
    # - message length / turn count
    return False, None
```

Tests can cover every path deterministically.

## 5. Escalation Must Be Enforced by Hooks (D1 tie-in)

Because escalation criteria are deterministic, they belong in a **`PreToolUse` hook** or similar gate, **not** buried in the prompt.

```python
def preToolUse_refund_hook(tool_name, params, context):
    if tool_name == "issue_refund" and params["amount"] > 500:
        return {
            "allow": False,
            "message": "Amount > $500 requires escalation to manager approval.",
            "escalationReason": "threshold_breach",
        }
    return {"allow": True}
```

Prompt text saying "escalate if amount > $500" is a **suggestion**. A hook is **enforcement**.

## 6. Structured Escalation Payload

When escalating, don't just hand off — hand off **with context**:

```json
{
  "reason": "threshold_breach",
  "decision_requested": {
    "action": "issue_refund",
    "amount": 1200,
    "customer_id": "C-123",
    "case_id": "CS-98123"
  },
  "case_summary": "Customer purchased Acme-Pro, product arrived damaged, prior refunds=$0, tier=enterprise",
  "facts": { "order_id": "O-998", "damage_photos": ["..."] },
  "policy_quotes": ["Refund > $500 requires manager approval (§3.2)"],
  "suggested_action": "Approve if manager agrees damage is substantive",
  "audit_trail": "/cases/CS-98123/log"
}
```

Humans should be able to resolve from the payload alone.

## 7. Escalation UX Principles

- **Respectful language** ("Connecting you with a specialist who can help…").
- **Explain why** briefly ("This needs manager approval per our refund policy").
- **Don't mention AI limits** awkwardly ("I can't do that" is fine; "I am an AI" is usually not necessary).
- **Preserve context** — don't make the human re-ask the customer for info already provided.

## 8. "Escalate or Not" Decision Tree

```
Incoming request/decision
      |
      v
[Explicit human request?] -- yes --> ESCALATE (explicit_human_request)
      | no
      v
[Policy applies?] -- no --> ESCALATE (policy_gap)
      | yes
      v
[Capability available?] -- no --> ESCALATE (capability_limit)
      | yes
      v
[Crosses threshold?] -- yes --> ESCALATE (threshold_breach)
      | no
      v
[Proceed autonomously]
```

Four checks, all deterministic. Memorize the tree.

## 9. Common Exam Distractors

| Distractor | Why wrong |
|---|---|
| "Escalate when customer seems frustrated" | Sentiment-based; invalid |
| "Escalate when model confidence is < 0.7" | Self-reported confidence; miscalibrated |
| "Escalate after 5+ messages" | Turn count; unrelated to complexity |
| "Escalate on every refund" | Overly aggressive; defeats automation |
| "Let the model decide when to escalate" | Non-deterministic; unreviewable |

## 10. Anti-Pattern Narratives to Recognize

**Narrative 1**: "Our agent escalates when it senses the customer is upset."
→ Invalid — sentiment-based escalation.

**Narrative 2**: "Our agent escalates whenever its confidence drops below 70 %."
→ Invalid — model confidence is unreliable.

**Narrative 3**: "We escalate all refunds." 
→ Too aggressive — defeats the automation's purpose.

**Narrative 4**: "We escalate when the refund exceeds $500 or our policy has no defined rule."
→ ✅ Valid — two objective triggers (threshold + policy gap).

## 11. Escalation Metrics

Track:
- **Escalation rate per trigger** (should NOT be dominated by any single trigger except explicit human request at ~ baseline).
- **Escalation resolution time** (time from handoff to human decision).
- **Post-escalation outcomes** (did the human agree with the handoff?).

If threshold_breach escalations are rising sharply, your threshold may be too tight; if capability_limit is dominant, you need more tools (or better docs).

## 12. Exam Self-Check

1. *Valid escalation triggers?*
   → Explicit request, policy gap, capability limit, threshold breach.
2. *Invalid triggers?*
   → Customer sentiment, model confidence, message length, turn count.
3. *Where should escalation checks be enforced — prompt or hook?*
   → Hook (deterministic).
4. *Escalation hands off to a human. What payload fields are mandatory?*
   → reason, decision_requested, case_summary, policy quotes, facts.

---

### Key Takeaways
- ✅ 4 valid triggers: explicit request, policy gap, capability limit, threshold.
- ✅ Enforce with hooks, not prompts.
- ✅ Always hand off with full structured context.
- ❌ Never escalate on sentiment / confidence / turn count.

Next → [`03-Error-Propagation.md`](03-Error-Propagation.md)
