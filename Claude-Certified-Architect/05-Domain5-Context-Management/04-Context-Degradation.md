# D5.4 — Context Degradation — Detection & Remediation

> Every long-running session drifts. The exam tests your ability to recognize degradation and apply the right remediation.

## 1. What Context Degradation Looks Like

Symptoms during a long session:
- Claude references facts wrong ("your Silver tier" when customer is Gold).
- Claude forgets an instruction given 20 turns ago.
- Claude contradicts an earlier decision.
- Claude repeats itself or re-asks for information already provided.
- Quality declines from turn 1 → turn 50.

## 2. Three Root Causes

### 2.1 Token-pressure (context nearing the limit)
The context is approaching or exceeding the effective window. Old messages get dropped or attention is spread too thin.

### 2.2 Noise drowning signal
Tool outputs or side-chatter dwarf the actual task state. Key facts get lost in the noise.

### 2.3 Summarization drift
Prior `/compact` or in-model summarization has paraphrased critical facts, introducing errors that compound.

## 3. The Remediation Decision Tree

```
[Context degrading]
    |
    v
[Is the task exploratory with divergent paths?]
    | yes
    v
[fork_session per path] --> DONE
    | no
    v
[Are key facts being forgotten?]
    | yes
    v
[Write a case facts block + scratchpad file] --> DONE
    | no
    v
[Is token pressure the issue?]
    | yes
    v
[Split via subagents (Task tool)] --> DONE
    | no
    v
[Last resort: /compact] (accept drift risk)
```

## 4. Remediation Catalog

### 4.1 Case facts block (D5.1)
A pinned block at the top of each turn with essential facts.

**Use when**: key facts are being forgotten but the overall task is still coherent.

### 4.2 Scratchpad file
Externalize the working state to a file the agent writes/reads.

**Use when**: session crosses sessions or might need to resume later.

```markdown
# scratchpad.md
## Status: 40% done
## Findings:
- 7 call sites of legacy_auth
- 3 tests need updating
## Next steps:
- Replace legacy_auth in routes/api.ts
- Update integration tests
```

### 4.3 Session forking (`fork_session`)
Branch into a new session from the current point.

**Use when**: exploring alternative approaches; each branch is a distinct direction.

### 4.4 Subagent delegation (Task tool)
Delegate a subtask to a subagent with fresh context.

**Use when**: the subtask is isolatable and context is bloated.

### 4.5 Prompt caching
Mark the stable part of the prompt as cached.

**Use when**: system prompt or reference docs are stable and long.

### 4.6 `/compact` (last resort)
Claude summarizes then drops earlier messages.

**Use when**: nothing else works; accept drift risk.

### 4.7 `/clear` + `--resume <id>` hybrid
In Claude Code: `/clear` current context, then resume a specific prior session to get a clean slate with pinned history.

## 5. The "Case Facts + Scratchpad" Combo

The most durable pattern for long-running agents:

1. **Case facts block** at top of every turn — a few dozen tokens of structured state.
2. **Scratchpad file** written after every major step — a persistent, auditable log.
3. **Subagent delegation** for heavy subtasks — keeps the main session clean.
4. **Fork** when the path bifurcates.

## 6. Pinning Patterns

### 6.1 System-prompt pinning
Put stable rules in the system prompt. Once. Don't re-paste per-turn.

### 6.2 Recurring pin block
Some orchestrators inject a "pinned facts" block at the top of every user turn automatically. (Implement this yourself if needed.)

### 6.3 End-of-context mirroring
Since attention is strong at the end too, briefly mirror the critical facts at the very end of each turn's injected content.

```
<pinned facts>
...top of context...

<most recent tool outputs>

<pinned facts restated compactly>
<current user question>
```

Overkill for short contexts; valuable past ~50 turns.

## 7. Degradation Early-Warning Signals

Set up monitoring to detect degradation **before** the user notices:
- Turn number threshold (e.g., alert at turn 40).
- Context size threshold (e.g., alert at 75 % of window).
- Drift detector (hash key facts each turn; alert if they change unexpectedly).
- User-correction rate (if the user is correcting the model more often, context is degrading).

## 8. Testing For Degradation

**Session-length tests**: simulate 50/100/200-turn sessions with a fixed scenario. Check:
- Does Claude preserve the initial user ID?
- Does it remember policy constraints stated early?
- Does it contradict itself late in the session?

Run these tests as a regression suite. They catch degradation bugs you'd otherwise only find in production.

## 9. The Lost-in-the-Middle Recap (from D5.1)

Since critical facts in the middle of the context decay in attention:
- Pin them at the top (system prompt / case facts).
- Mirror them at the end (recurring pin).
- Never let key constraints be stranded mid-conversation.

## 10. `/compact` — a Closer Look

`/compact` triggers an in-model summarization of earlier context, then drops earlier messages.

**Pros**:
- Immediate token relief.
- Works in-place; no session restart.

**Cons (important for the exam)**:
- Summarization drift — facts paraphrased, possibly incorrectly.
- Loss of exact quotes/IDs/amounts.
- Repeated `/compact` compounds the drift.

**Guidance**: Use as a last resort. Prefer scratchpad/fork/delegation.

## 11. `fork_session` — a Closer Look

`fork_session` branches the context at the current point into a **new** session ID. Both sessions exist independently.

**Pros**:
- No summarization; no drift.
- Multiple branches can be explored in parallel.
- Easy to abandon an unfruitful branch.

**Cons**:
- Doubles token cost (both branches are full-weight).
- Requires explicit tracking of which branch "wins."

Use when the task is inherently exploratory.

## 12. The Stale-Context Anti-Pattern

Long-running sessions often have **stale context** — early outputs that are no longer relevant but still present.

- Tool outputs from 50 turns ago clutter attention.
- Old user questions (answered and resolved) still take tokens.
- Prior subtask chatter is now noise.

**Fix**: move irrelevant content to files; Claude can re-read if needed.

## 13. Anti-Patterns

| Anti-pattern | Why wrong |
|---|---|
| `/compact` every 10 turns | Drift compounds; facts lost |
| Long single session for everything | Context degrades; should split |
| Relying on Claude's memory of early turns | Lost in the middle |
| No pinning of key facts | Model forgets them |
| No scratchpad for long-running work | No durability across resumes |
| Treating tool outputs as ephemeral context | They're consuming attention forever unless pruned |

## 14. Exam Self-Check

1. *Key facts being forgotten after 30 turns. First remediation?*
   → Case facts block at top + scratchpad file.
2. *Token pressure, heavy tool outputs. Remediation?*
   → Subagent delegation (Task tool) + prompt caching for stable parts.
3. *You need to explore three design alternatives in parallel. Remediation?*
   → `fork_session` per alternative.
4. *Why is `/compact` a last resort?*
   → Summarization drift compounds; critical exact facts may be lost.

---

### Key Takeaways
- ✅ Case facts + scratchpad = durable memory.
- ✅ Fork for exploration; subagents for isolation.
- ✅ Pin critical facts at top (and mirror at end if very long).
- ✅ Monitor turn count / context size as early warnings.
- ❌ Don't reflex-compact.
- ❌ Don't trust the model's memory of mid-context content.

Next → [`05-Human-Review-and-Provenance.md`](05-Human-Review-and-Provenance.md)
