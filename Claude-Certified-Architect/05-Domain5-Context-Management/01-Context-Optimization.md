# D5.1 — Context Optimization & the Lost-in-the-Middle Effect

> The context window is a **limited budget**, not a recycle bin. Domain 5 tests whether you treat it as such.

## 1. The Core Problem

Long-running Claude sessions accumulate:
- Tool-call outputs (often huge and mostly irrelevant).
- Repeated read-backs of the same files.
- Verbose system messages from prior failed runs.
- Natural language meandering between tasks.

Eventually context hits:
- **Token cost** — every turn pays for the whole context.
- **Latency** — longer contexts = slower responses.
- **Quality degradation** — the model forgets or mis-weights earlier content.
- **The "lost in the middle" effect** — content in the middle of context gets the least attention.

## 2. The Lost-in-the-Middle Effect

Research across LLMs shows a U-shaped attention curve:

```
Attention
  ^
  |█████               █████
  |█████               █████
  |█████     ░░░░░     █████
  |█████     ░░░░░     █████
  +-----------------------> Position in context
  start    middle      end
```

- Models attend **strongly** to the beginning (system prompt, instructions).
- Models attend **strongly** to the end (most-recent messages).
- Models attend **weakly** to the middle.

Practical implications:
- Critical rules → system prompt (beginning).
- Evolving state → end (pinned / most recent).
- Nice-to-have reference material → middle (acceptable).
- Never bury critical constraints mid-conversation.

## 3. "Case Facts" Blocks — the Correct Pattern

A **case facts block** is a small, curated block of key information about the task, maintained at a stable location (usually right after the system prompt, or as a recurring pinned block).

Example (customer-support agent):

```
## Case Facts
- Customer ID: C-42119
- Tier: enterprise
- Current refund total: $1,250
- Refund cap for this tier: $2,000
- Products affected: Acme-Pro (order #O-998)
- Policy overrides granted: none
- Escalation required: none
- Open investigations: none
```

This is ~80 tokens. It sits high in the context, is pinned there, and is updated as the conversation progresses. Every turn reads it.

### Benefits
- **Compact** — facts, not prose.
- **Structured** — easy to update programmatically.
- **Auditable** — clear state at any point.
- **Resistant to lost-in-the-middle** — pinned near the top.

## 4. Progressive Summarization — a Nuanced Anti-Pattern

Progressive summarization: "every 10 turns, summarize the conversation so far."

### The trap
This is **common advice** but has real downsides:
- Summarization introduces **drift** — the summary is Claude's paraphrase, not the source.
- Repeated summarization compounds drift (summary-of-summary-of-summary…).
- Key literal facts (exact IDs, exact quotes, monetary amounts) get lost in paraphrasing.

### When progressive summarization is OK
- For **irrelevant** content — old unrelated threads you'd drop anyway.
- For **narrative flow** context — "user asked about X, then Y, then Z."

### When it's WRONG
- For **key facts** — IDs, amounts, dates, names, policy quotes.
- For **evidence** — direct tool outputs that may need to be re-cited.
- For **decisions** — never summarize what should be a permanent ledger.

### Better than progressive summarization
- **Case facts blocks** — curated key facts, not paraphrased.
- **Scratchpad files** — persistent notes file that the agent writes/reads.
- **Session forking** (`fork_session`) — branch off rather than compact.

## 5. Context Decomposition

If context is bloated, don't compress — **split**:
- Use the `Task` tool to delegate a subtask to a subagent with its own fresh context.
- Move long reference material to a **file** (scratchpad / docs) and read it on demand.
- Offload tool outputs you only need once to disk.

Decomposition (separate sessions) is usually better than compaction (same session, less content).

## 6. `/compact` vs. `/clear` vs. Fork

| Action | Effect | When to use |
|---|---|---|
| `/compact` | Claude summarizes then drops earlier messages | Mid-session, lightly useful |
| `/clear` | Drops all prior context | Starting fresh in same session |
| `fork_session` | Branches into new session from a point | Exploration / parallel paths |
| `--resume <id>` | Exact continuation of prior session | Resuming a long-running task |

The exam tests that **`/compact` uses summarization and therefore has the drift risk**. `fork_session` doesn't summarize; it branches context at a specific point.

## 7. Scratchpad Files — the Best Long-Running Pattern

Write long working notes to a file (e.g., `.agent/scratchpad.md`):

```markdown
# Scratchpad (task: migrate auth service)

## Status
- Inspected auth.py, found legacy JWT logic on lines 120-180
- Identified 7 call sites (see tools/call_sites.json)

## Decisions
- Preserve old endpoint for 90 days (compatibility)
- New token format: JWT with new signing key, kid rotation

## Open questions
- Refresh-token flow: blue/green cutover or soft migration?
```

Advantages:
- **Persistent across sessions** — survives a `--resume`.
- **Shareable** — humans can review.
- **Grep-able** — Claude can Grep its own notes.
- **Durable** — no drift from summarization.

## 8. Chunking Large Documents

If a document doesn't fit in context:
- **Semantic chunks** (by section / function / heading) not byte-chunks.
- **Overlapping chunks** (10 – 20 % overlap) to preserve cross-chunk references.
- **Index chunks** with metadata (source, position, type).
- **Fetch chunks on demand** via tools, don't preload all.

## 9. Caching (Prompt Caching)

Anthropic's **prompt caching** lets you mark the static portion of your prompt (system prompt, large reference docs) so the model reuses cached KV state:

```python
messages.append({
  "role": "system",
  "content": [
    {"type": "text", "text": BIG_DOCS, "cache_control": {"type": "ephemeral"}},
    {"type": "text", "text": DYNAMIC_INSTRUCTIONS}
  ]
})
```

Benefits:
- **Up to 90 % cost savings** on cached tokens.
- **Lower latency**.
- Works best for stable context (docs, long system prompt).

Doesn't solve lost-in-the-middle — still order your stable stuff cleverly.

## 10. Model-Selection by Context Budget

| Budget | Model | Notes |
|---|---|---|
| ≤ 200K tokens | Sonnet 4 / Opus 4 | Full quality; standard |
| ≤ 1M tokens | Sonnet 4 (1M beta) | Longer reference; watch cost |
| Larger | Split into multiple sessions | No single session approach wins |

Don't squeeze more tokens in; **decompose**.

## 11. Diagnosing a Bloated Context

Symptoms:
- Each turn >10 s slower than the first turn.
- Model repeats itself or forgets recent instructions.
- Model mis-references facts from 30 turns ago but misses something 5 turns ago.
- Token bill is climbing linearly with turn count.

Interventions, in order:
1. Write a scratchpad; reduce in-context notes.
2. Add / update the case-facts block.
3. `fork_session` for any new subtask direction.
4. Move stable reference material behind prompt caching.
5. Decompose via subagents (Task tool).
6. Last resort: `/compact` (accepts the drift risk).

## 12. Anti-Patterns

| Anti-pattern | Why wrong |
|---|---|
| Burying key facts mid-conversation | Lost in the middle |
| Relying on progressive summarization for exact facts | Summarization drift |
| Using `/compact` as a first reflex | Drift + data loss |
| Ignoring prompt caching on stable docs | Wasted tokens / money |
| Single mega-session for everything | Context degradation; split! |

## 13. Exam Self-Check

1. *Where do models attend most, and where least?*
   → Beginning and end; least in the middle.
2. *Key facts need to persist across 40 turns. Best approach?*
   → Case-facts block near the top, updated each turn. Plus scratchpad file.
3. *A session is drifting after `/compact` was run twice. Why?*
   → Summarization drift accumulated.
4. *How to handle a 400-turn exploratory session with diverging paths?*
   → Fork sessions per path; scratchpad per path.

---

### Key Takeaways
- ✅ Case facts block > progressive summarization.
- ✅ Scratchpad files > in-context notes.
- ✅ Decompose (subagents, fork) rather than compact.
- ✅ Use prompt caching for stable system content.
- ❌ Never bury critical constraints mid-conversation.
- ❌ Don't lean on `/compact` for important facts.

Next → [`02-Escalation-Triggers.md`](02-Escalation-Triggers.md)
