# D1.5 — Task Decomposition Patterns

> Task decomposition is where agentic architecture starts to feel like software architecture: you are choosing **how to split work** across actors, how to pass information between them, and how to recover when parts fail.

## 1. The Spectrum

```
Static ←————————————————————————————————————————————→ Dynamic
Prompt      Scripted      Template-driven     Adaptive       Fully
chain       chain         flows               decomposition  autonomous
                                              (planner-doer)  (multi-agent)

DETERMINISTIC                                          UNPREDICTABLE
EASY TO TEST                                           HARD TO TEST
CHEAP                                                  EXPENSIVE
```

Your job as the architect is to pick the point on the spectrum that matches the task's **shape**.

## 2. Pattern 1 — Prompt Chaining (Scripted)

### Definition
A fixed sequence of prompts, each consuming the previous output.

### Canonical shape
```python
def scripted_pipeline(input_doc):
    extracted  = claude("Extract fields from:" + input_doc)
    validated  = claude("Validate these fields:" + extracted)
    summarized = claude("Summarize the validated fields:" + validated)
    return summarized
```

### When to use
- Input shape is **predictable**.
- Success criteria are **fixed**.
- You want **reproducibility and auditability**.
- The flow will run in production at high volume.

### Strengths
- Each step is **testable in isolation**.
- Easy to reason about.
- Cheap and fast (few tokens per step).
- Failures are localized.

### Weaknesses
- Brittle if input shape changes.
- Can't handle branching ("if the extraction finds no table, then …").
- Dead-ends if a step returns nothing.

## 3. Pattern 2 — Template-Driven Flows

### Definition
A fixed decision tree where each branch is a prompt sequence.

```python
if input.type == "invoice":
    return invoice_flow(input)
elif input.type == "contract":
    return contract_flow(input)
else:
    return fallback_flow(input)
```

- Still deterministic in terms of *which* flow, but the flow is selected at runtime.
- Works when the **set of input types is enumerable**.

## 4. Pattern 3 — Adaptive Decomposition (Planner-Doer)

### Definition
A two-phase pattern where the agent first **plans** the decomposition, then **executes** it.

```
System: Given a task, first output a plan as a JSON list of steps.
Then execute each step, recording its output.
If a step fails, revise the plan for remaining steps.
```

### When to use
- Input is **unpredictable**.
- Solution path **branches** based on findings.
- The number of steps is not known in advance.

### Example: Codebase refactor
```
User: "Refactor this module to use dependency injection."
Claude:
  Plan:
    1. Read module structure
    2. Identify current coupling points
    3. For each, extract interface
    4. Replace direct construction with injection
    5. Update tests
    6. Run tests; if fail, iterate on step 4/5
  Execution: [runs plan, adapts as results come in]
```

This is still **one agent**, but it has internal planning and mid-flight replanning.

### Strengths
- Handles novelty well.
- Adapts to input quirks.

### Weaknesses
- Less reproducible.
- Harder to test (plan can vary).
- More tokens.

## 5. Pattern 4 — Hub-and-Spoke Multi-Agent Decomposition

Covered in depth in [`02-Multi-Agent-Orchestration.md`](02-Multi-Agent-Orchestration.md). Summary:

- **Coordinator** decomposes the task into subtasks and delegates.
- **Subagents** execute in parallel, each with focused tools.
- **Coordinator** synthesizes.

### When to use
- Subtasks are **independent** (can run in parallel).
- Subtasks have **specialized tool requirements**.
- The workload is large enough that parallelism matters.

## 6. Decomposition Mistakes — the Exam Favourites

### 6.1 Over-narrow decomposition (coverage gaps)

**Example:** A customer-support agent's task is "resolve the customer's issue." A naive decomposition:
- Subtask 1: Look up account
- Subtask 2: Look up order
- Subtask 3: Process refund

**Gap**: The customer may have a **billing** issue (not a refund) or a **shipping address** change. Neither subtask covers it.

**Fix**: Decompose along **user intents**, not mechanical steps:
- Classify intent → account / billing / shipping / refund / escalation
- Dispatch to a subagent specialized in that intent.

### 6.2 Over-broad decomposition (a mini mega-agent)

**Example:** "Subagent A: do everything related to accounts, orders, refunds, emails, notifications, and escalations."

**Problem**: The subagent now has 18 tools, same as the anti-pattern from D2. The isolation gains vanish.

**Fix**: Push refinement further. Orders, emails, refunds each deserve their own subagent.

### 6.3 Serial where parallel is possible

**Example:** Research three independent market segments one after the other.

**Problem**: 3× the latency for no reason.

**Fix**: Fire all three as parallel `Task` calls in the same coordinator turn.

### 6.4 Unpassed constraints

**Example:** Coordinator delegates "research market size" but doesn't pass the cadence (YoY vs QoQ), units (USD vs local), or time range (last 5 years).

**Problem**: The subagent makes assumptions; outputs can't be combined.

**Fix**: Always pass **format constraints** (units, time range, depth, citation style) explicitly.

## 7. The Context-Passing Contract

When a coordinator delegates, always pass **4 pieces of information**:

| Piece | Example |
|---|---|
| **Goal** | "Research AI infrastructure market size." |
| **Deliverable format** | "Return `{size_usd, cagr, top_vendors[]}` with sources." |
| **Constraints** | "USD only, last 5 years, ≥3 independent sources per claim." |
| **Known data points** | "Coordinator has already established the scope is 'enterprise', not 'consumer'." |

Missing any piece produces wandering subagent output.

## 8. Failure Handling Across Decompositions

### 8.1 Scripted chains
If step N fails:
- Retry with backoff.
- If still failing, abort and propagate error.
- Do **not** silently skip — use **access-failure vs empty-result** discipline (D2.2, D5.2).

### 8.2 Adaptive decomposition
If a step fails:
- **Replan** around it if possible.
- Use **local recovery** first (retry with alternative tool).
- If still failing, escalate *with structured context*.

### 8.3 Multi-agent
If a subagent fails:
- Coordinator may reassign to a different subagent.
- Coordinator may re-scope the task.
- Coordinator **may not** silently drop the subagent's result — must propagate the failure clearly.

## 9. Cost & Latency Trade-offs

| Pattern | Relative cost | Relative latency | Reliability ceiling |
|---|---|---|---|
| Scripted chain | ★ | ★ | ★★★★★ |
| Template-driven | ★★ | ★★ | ★★★★ |
| Adaptive (single agent) | ★★★ | ★★★ | ★★★ |
| Hub-and-spoke multi-agent | ★★★★ | ★★ (parallel!) | ★★★★ |
| Fully autonomous network | ★★★★★ | unpredictable | ★★ (for now) |

**Exam tip**: When cost or reproducibility is stressed, the scripted end is the answer. When the task is open-ended, adaptive. When parallelism is important, hub-and-spoke.

## 10. Picking the Right Pattern — Decision Tree

```
Is the workflow input shape predictable?
  ├─ YES →  Is success criteria fixed?
  │          ├─ YES →  Prompt chaining / scripted
  │          └─ NO  →  Template-driven flow
  └─ NO  →  Does the task have independent subtasks?
             ├─ YES →  Hub-and-spoke multi-agent
             └─ NO  →  Adaptive decomposition (planner-doer)
```

## 11. Worked Example — Picking a Pattern per Use Case

| Use case | Correct pattern | Reason |
|---|---|---|
| Monthly billing extraction from 10 vendor invoice formats | Template-driven | Vendors fixed; per-vendor flow optimal |
| Incident response ("we have an outage, find root cause") | Adaptive (single-agent) | Shape unknown |
| Research the competitive landscape for product X | Hub-and-spoke | Independent subtasks (market/tech/finance) |
| Lint + format + type-check every file Claude edits | Scripted (chain of hooks) | Fixed steps, deterministic |
| Answer a customer's question | Adaptive single-agent w/ tools | Intent unknown until analyzed |
| Generate annual report from 5 data sources | Hub-and-spoke | Parallel subagents per source |

## 12. Exam Self-Check

1. *Monthly ETL that always follows the same 7 steps — pattern?*
   → Scripted prompt chain.
2. *Research the top 3 vendors in a market, compute their financial ratios, write a brief — pattern?*
   → Hub-and-spoke: 3 subagents (one per vendor) + coordinator synthesis.
3. *"Debug this flaky integration test" — pattern?*
   → Adaptive decomposition — you can't script debugging.
4. *A decomposition where every subtask is "Google for X", "Google for Y", "Google for Z" — why is this wrong?*
   → Coverage gaps. Decompose along **domain boundaries**, not mechanical search terms.

---

### Key Takeaways
- ✅ Match the decomposition pattern to the **task shape**.
- ✅ Pass goal + format + constraints + known data to every subagent.
- ✅ Prefer parallel when subtasks are independent.
- ✅ Scripted chains are perfect for predictable, high-volume ETL.
- ❌ Don't decompose too narrowly (gaps) or too broadly (mega-subagent).
- ❌ Don't use adaptive when scripted would be just as good (cheaper, faster, testable).

→ You have now finished Domain 1. Continue to [`../02-Domain2-Tool-Design-MCP/01-Tool-Description-Best-Practices.md`](../02-Domain2-Tool-Design-MCP/01-Tool-Description-Best-Practices.md).
