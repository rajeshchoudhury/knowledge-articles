# D1.4 — Session Management & Workflows

> *Sessions are the "memory" of your agent. Mismanage them and your agent forgets, repeats, or remembers the wrong things.*

## 1. Why This Matters

Production Claude systems are rarely one-shot. A user might return to a half-finished task an hour later; a nightly CI job might need to resume a long analysis; a complex research workflow might need to spawn exploratory branches without polluting the main thread. **Sessions** are the primitive that makes these workflows possible.

The exam tests:
- When to **resume** vs. **fork**
- How to detect and mitigate **stale context**
- How to use **named sessions** for multi-pipeline work
- Decomposition strategies: **prompt chaining** vs **dynamic adaptive**

## 2. The Four Session Primitives

| Primitive | Flag / call | Effect |
|---|---|---|
| **Start new** | `claude` (no flags) | Fresh session, empty context |
| **Resume** | `claude --resume` | Continue previous session, FULL context preserved |
| **Named** | `claude --session-name "feature-x"` | Organize multi-session workflows with labels |
| **Fork** | `fork_session --reason "…"` | Branch into an isolated copy; inherits context, changes don't affect parent |

### 2.1 `--resume`
```bash
claude --resume                                    # last session
claude --resume --session-name "auth-redesign"     # specific named session
```
- The entire conversation reappears.
- Costs the entire conversation's tokens each turn (context grows).
- Correct when: "I want to continue exactly where I left off."

### 2.2 `fork_session`
```bash
claude fork_session --reason "Trying GraphQL alternative"
```
- A new session is created that starts with the parent's current context.
- **Changes in the fork do NOT affect the parent.**
- Correct when: "I want to try something without risking the main thread."

### 2.3 Named sessions
```bash
claude --session-name "sprint-47-backend"
```
- Attaches a stable label; you can resume by name later.
- Correct when: You run multiple concurrent workflows you want to keep separate.

## 3. Resume vs. Fork — the Decision Matrix

| Situation | Use `--resume` | Use `fork_session` |
|---|---|---|
| Continue yesterday's analysis | ✅ | ❌ |
| Try 2 API designs in parallel | ❌ | ✅ (fork once per alternative) |
| Long-running research job (restart after crash) | ✅ | ❌ |
| Explore "what if we used SQS instead of Kinesis?" | ❌ | ✅ |
| CI/CD pipeline continuation between jobs | ✅ | ❌ |
| A/B testing two prompt strategies | ❌ | ✅ |

## 4. Stale Context — the Silent Killer

In long-running sessions, data retrieved early can become **stale**:
- User profile retrieved at 9 AM → used at 5 PM → user updated their address at noon.
- Inventory count retrieved → 200 more orders came in since.
- API docs retrieved → API version was bumped.

Claude has **no way to know** the data is stale unless you signal it.

### Mitigation strategies

1. **Re-fetch critical data at boundaries.** At the start of each major task, re-fetch anything that could have changed.
2. **Scratchpad files** (see D5.3). Persist intermediate state to files; re-read them after long gaps.
3. **Freshness metadata.** Tag each retrieved item with a retrieval timestamp; prompt the agent to re-fetch if older than N minutes.
4. **`/compact` periodically** to force Claude to re-derive inferences from scratch.
5. **Periodic coordinator → subagent handoff** with explicit re-fetch instructions.

## 5. `/compact` — Compressing the Conversation

When the context window is filling up but the task isn't done, `/compact` compresses the conversation:

```
/compact
```

Effect:
- Claude summarizes the recent conversation into a compressed form.
- Earlier detailed turns disappear; the summary replaces them.
- The current question is preserved verbatim.

**Trade-off**: You gain context space; you lose detail. Critical data should be in **case facts blocks** (D5.1) before you `/compact`, otherwise it will be lost.

### `/compact` vs. scratchpads

| | `/compact` | Scratchpad file |
|---|---|---|
| Persists across sessions | No | Yes |
| Preserves detail | No (summarizes) | Yes (verbatim if written) |
| Requires writing discipline | No (Claude does it) | Yes (you must write to file) |
| Best for | In-session space reclamation | Cross-session continuity, high-stakes data |

**Best practice**: Before running `/compact`, write critical findings to a scratchpad (`progress.md`). After `/compact`, re-read `progress.md`.

## 6. Task Decomposition Strategies

Decomposition is how you break a big task into agent-friendly chunks. Two dominant strategies:

### 6.1 Prompt chaining (static)

```
Step 1: Extract data from input.md
Step 2: Validate the extracted data against schema.json
Step 3: Load valid rows into the database
Step 4: Email a summary to the owner
```

- **Predictable** — same steps every time, regardless of input.
- **Easy to test** — each step is an independent unit.
- **Works when**: ETL pipelines, fixed workflows, onboarding flows.
- **Breaks when**: the input is unexpected (no rows to extract? step 2 has nothing to validate). Without explicit fall-throughs, the chain stalls.

### 6.2 Dynamic adaptive decomposition

```
Analyze the codebase. For each issue you find:
  - Assess severity and complexity.
  - If simple: fix directly.
  - If complex: create a plan first, then apply it.
  - After each fix: run relevant tests.
  - Adapt next steps based on results.
```

- **Runtime tree shape** — the agent decides how deep to go.
- **Requires dynamic adaptive** — a good reasoning model (Sonnet/Opus).
- **Works when**: exploratory/unknown tasks (codebase analysis, research, debugging).
- **Breaks when**: you need guaranteed reproducibility (you'll get slightly different results each run).

### 6.3 Choosing between them

| Signal | Use chaining | Use adaptive |
|---|---|---|
| Input shape is known | ✅ | |
| Workflow is deterministic | ✅ | |
| Success criteria are fixed | ✅ | |
| Input is open-ended | | ✅ |
| Solution path depends on findings | | ✅ |
| You'll iterate on the plan | | ✅ |

Many real systems use **hybrid**: a chained outer skeleton (extract → process → emit) with adaptive reasoning inside each step.

## 7. Workflow Patterns

### 7.1 The Research Workflow
```
coordinator (adaptive)
 ├─ dispatch N research subagents (adaptive each)
 │    └─ each uses chained steps internally: fetch → extract → cite
 ├─ synthesize (adaptive)
 └─ format (chained: outline → prose → citations)
```

### 7.2 The Code-Review Workflow (chained)
```
pass 1: per-file local review (N parallel subagents, chained)
pass 2: cross-file integration review (single coordinator, adaptive)
pass 3: synthesis & emit (chained)
```

### 7.3 The Incident-Response Workflow (hybrid)
```
coordinator (adaptive, because incident shape unknown)
 ├─ parallel probes: Sentry, Datadog, pod logs, recent deploys
 │    (each probe is chained: query → parse → summarize)
 └─ synthesis & mitigation plan (adaptive)
```

## 8. Sessions in CI/CD

CI systems run **non-interactively** — sessions matter differently there:

- Use `-p "prompt"` to run one-shot.
- Use `--resume` to continue a named session across pipeline stages (e.g., generator pipeline → reviewer pipeline).
- **Always** isolate generator and reviewer into **separate** sessions (see §10 and D3/D4).

Example: Two-stage pipeline
```bash
# Stage 1: Generator (session A)
claude -p "Implement feature X" --session-name "feat-x-gen"

# Stage 2: Reviewer (session B — SEPARATE)
claude -p "Review PR #123 for bugs." \
       --output-format json \
       --json-schema '...'
# NOTE: no --resume, no shared session
```

## 9. Long-Running Sessions — Best Practices

1. **Plan for restart.** Assume the process will crash/drop. Write state to files so `--resume` + re-read = full recovery.
2. **Tag every retrieved datum with a timestamp.** Re-fetch anything older than your freshness SLA.
3. **Compress early, not late.** Don't wait for the context to hit 95 % — `/compact` at 60 % keeps responses sharp.
4. **Scratchpads.** See D5.3.
5. **Subagent delegation** for verbose tasks (see D1.2) — keeps the main session's context clean.
6. **Periodic "re-orient" prompts.** In very long sessions, periodically remind the agent of the goal ("Our goal is still to produce a 1-page brief on X. Recap your findings so far.").

## 10. Session Isolation for Self-Review (preview — see D3/D4)

Same-session self-review is an **anti-pattern** (confirmation bias). The correct pattern:

| Step | Session | Notes |
|---|---|---|
| 1. Generate code | Session A | Claude writes code |
| 2. Review code | **Session B** | Fresh context, no reasoning carryover |

This is the core pattern for CI-driven code review and one of the top-tested ideas on the exam.

## 11. Exam Self-Check

1. *You want to explore two alternative API designs without risking the main thread. Which session primitive?*
   → `fork_session`, once per alternative.
2. *A long-running session is degrading — responses are generic. Which three mitigations apply?*
   → (a) `/compact`, (b) write critical state to a scratchpad file, (c) delegate verbose tasks to subagents.
3. *Prompt chaining or adaptive decomposition for "analyze a codebase and identify the top 3 architectural issues"?*
   → Adaptive — the tree shape (what issues, how deep to go) is unknown.
4. *`--resume` or `fork_session` for continuing a long research job the next morning?*
   → `--resume` — you want to continue, not branch.

---

### Key Takeaways
- ✅ `--resume` continues; `fork_session` branches.
- ✅ Named sessions organize parallel workflows.
- ✅ `/compact` buys space; scratchpads preserve detail across resets.
- ✅ Tag retrieved data with timestamps; re-fetch anything stale.
- ✅ Use prompt chaining for predictable flows; adaptive decomposition for exploratory ones.
- ❌ Never use `fork_session` when you just wanted to continue.
- ❌ Never let a long-running session drift — compress early, delegate, persist.

Next → [`05-Task-Decomposition.md`](05-Task-Decomposition.md)
