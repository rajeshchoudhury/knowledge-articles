# D2.3 — Tool Distribution & Selection

> "Give an agent too many tools and selection quality falls off a cliff."
> The exam's favorite framing of this topic: **the 18-tool question**.

## 1. The 18-Tool Trap

A representative exam stem:

> An agent has 18 tools available. It is selecting the wrong one ~30 % of the time. What should you do?
> (a) Make each tool description longer
> (b) Switch to a larger model (Opus instead of Sonnet)
> (c) **Redistribute the tools across specialized subagents with 4–5 tools each**
> (d) Fine-tune the model on tool-selection tasks

**Correct answer**: (c). The others don't fix the root cause. More descriptions bloat context. A bigger model costs more but still suffers from selection degradation. Fine-tuning is overkill (and Foundations doesn't test it).

Anthropic's research and independent benchmarks converge on this: **selection accuracy degrades sharply above ~5 tools per agent**. Below 5, it's near-ceiling. Above 10, it's visibly degraded. At 18+, the agent is basically guessing on ambiguous prompts.

## 2. Why More Tools Hurt

Four compounding effects:

1. **Combinatorial comparison.** Claude reads every description and compares to the current user intent. With more tools, the field becomes harder to rank.
2. **Similarity ambiguity.** With 18 tools, the likelihood of two having overlapping intents goes up (`search_customer`, `find_user`, `lookup_account`).
3. **Context bloat.** More tool descriptions = more tokens = "lost in the middle" effects (see D5.1).
4. **Weak-attention edges.** The model's attention over tool descriptions is not uniform; edges (first and last) get more weight than middle tools.

## 3. The 4–5 Rule

**Practical guideline**: every agent should have **≤ 5 tools** in its active list.

- Coordinators: 3 – 4 tools (`Task`, `summarize`, `format`, maybe `escalate`).
- Specialized subagents: 4 – 5 tools each.
- A truly mission-critical subagent sometimes tolerates 6 – 7, but it's the upper bound.

## 4. The Distribution Pattern

Given 18 tools, partition them by **specialization boundary**:

```
18 tools flat                        →   Hub-and-spoke (correct)
┌───────────────────────────┐            coordinator        3 tools
│ lookup_customer            │            ├── customer_agent  4 tools
│ update_account             │            ├── order_agent     4 tools
│ verify_identity            │            ├── comms_agent     4 tools
│ check_status               │            └── ops_agent       3 tools
│ find_order                 │
│ process_refund             │
│ update_shipping            │
│ track_package              │
│ send_email                 │
│ send_sms                   │
│ create_ticket              │
│ escalate_human             │
│ search_kb                  │
│ check_inventory            │
│ apply_coupon               │
│ schedule_callback          │
│ log_interaction            │
│ update_preferences         │
└───────────────────────────┘
```

Partitioning rules:
- Group by **domain** (customer, order, comms, ops), not by tool action.
- Ensure every subagent's tools **belong together** — no "misc" bucket.
- Move general-purpose tools (e.g., `send_email`) into a dedicated subagent that everyone can call via `Task`.

## 5. `tool_choice` — the Three Modes

| Mode | Effect | Use when |
|---|---|---|
| `"auto"` (default) | Claude decides whether to use a tool and which one | General conversation; open-ended tasks |
| `"any"` | Claude must use a tool, but can pick which | Gating responses through tools (e.g., always log) |
| `{"type": "tool", "name": "X"}` | Force a specific tool | Structured extraction; deterministic workflows |

### Example: forcing extraction
```python
client.messages.create(
    model="claude-sonnet-4-20250514",
    tools=[extract_invoice],
    tool_choice={"type": "tool", "name": "extract_invoice"},
    messages=[{"role": "user", "content": f"Extract: {doc}"}]
)
```
This guarantees the response will include a call to `extract_invoice` with a schema-compliant payload (see D4.3).

## 6. Token-Level Cost of Tools

Each tool description lives in every request's system message. For a 500-word description × 18 tools:

- ≈ 9 000 tokens per request, just for tool descriptions.
- Same 9 000 tokens sent for *every* turn in the loop.
- 10-turn agent → 90 000 tokens of description baseline.

Distributing reduces this to:
- Coordinator: 3 × 500 = 1 500 tokens.
- Subagent: 4 × 500 = 2 000 tokens per subagent, independent.

The cost savings are real, and so is the attention benefit.

## 7. Tool Overlap — the Silent Bug

Two tools whose descriptions could plausibly answer the same user intent will produce a **coin-flip**. Spot the overlap:

- `find_customer(email)` and `search_customers(query)` — do both take email? Which one do you use?
- `create_ticket` and `escalate_human` — both surface a case to a human; when to pick which?

Fix: **Differentiate or merge**.

- Merge: `lookup_customer(email|phone|account_id)` — one tool, one entry point.
- Differentiate: make `create_ticket` internal (log-only) and `escalate_human` external (notify + pause).

## 8. `allowed_tools` in Claude Code

In Claude Code sessions, you can restrict the active tool list via:
- `CLAUDE.md` directives ("Use only Read, Edit, Grep in this project").
- Skill-level `allowed-tools` YAML frontmatter (`.claude/skills/refactor/SKILL.md`).
- Command-line `--allowed-tools Read,Edit`.

Principle of least privilege: **scope tools to the job**. A "refactor" skill does not need `Bash` or `Write`.

## 9. Scoping Across an Agent Fleet

Real production systems have:
- Agents for **internal employees** (broad tool access).
- Agents for **end users** (narrow tool access, PII restrictions).
- Agents for **nightly batch jobs** (read-only tool access).

Design the tool distribution so **each agent archetype has its own list**. The 4–5 rule still holds; the difference is *which* 4–5.

## 10. Performance Monitoring

Metrics to track per agent:
- **Tool-selection accuracy** — does the agent pick the "right" tool for a representative eval set?
- **Tool-call success rate** — % of tool calls returning `isError: false`.
- **Avg tools-per-turn** — high values indicate unnecessary calls.
- **Duplicate tool calls** — repeated `lookup_customer` with same email = sign of memory / context issues.

When tool-selection accuracy drops below ~90 %, it's almost always a distribution problem.

## 11. Migration Playbook — Breaking Up an 18-Tool Agent

1. **Inventory** the 18 tools. Write each one's **primary action** and **domain**.
2. **Cluster** by domain (customer / order / comms / ops / etc.).
3. **Check** each cluster has 3 – 5 tools and no overlap.
4. **Promote** any cross-cutting tools (e.g., `log_interaction`) into a shared subagent.
5. **Instantiate** a coordinator with 3 tools (`Task`, `summarize`, `format`).
6. **Instantiate** each subagent with its 4 – 5 scoped tools.
7. **Test** with a representative eval set; expect a 10 – 20 pp accuracy gain.

## 12. Exam Self-Check

1. *18-tool agent, degraded selection. Best fix?*
   → Redistribute across subagents (4–5 tools each).
2. *What's the optimal tools-per-agent count?*
   → 4 – 5.
3. *`tool_choice` to guarantee a specific tool is invoked?*
   → `{"type": "tool", "name": "X"}`.
4. *Two tools with near-identical descriptions. What's the root cause and fix?*
   → Ambiguity → merge or differentiate the tools so each has a unique purpose.

---

### Key Takeaways
- ✅ 4–5 tools per agent. Period.
- ✅ Distribute across subagents by domain.
- ✅ Use `tool_choice` to force extractions.
- ✅ Eliminate tool overlap — merge or differentiate.
- ✅ Apply least privilege (`allowed-tools` in Claude Code).
- ❌ Don't stuff 18 tools into one agent and hope for the best.

Next → [`04-MCP-Server-Configuration.md`](04-MCP-Server-Configuration.md)
