# Exam Overview — Claude Certified Architect – Foundations

## 1. The 60-Second Elevator Pitch

The **Claude Certified Architect – Foundations (CCA-F)** exam is Anthropic's first official technical certification, launched **March 12, 2026**, administered through **Anthropic Academy on Skilljar**. It validates your ability to *design, deploy, and operate production-grade systems built on Claude*.

It is **not** a prompt-engineering trivia test. It is an architecture exam, closer in spirit to the AWS Solutions Architect Associate or the Google Professional Cloud Architect exam, both of which give you messy real-world scenarios and ask you to choose between several plausible designs.

## 2. Exam Logistics (All the Hard Numbers)

| Spec | Value | Notes |
|------|-------|-------|
| Questions | **60** | All multiple choice / multiple select |
| Duration | **120 minutes** | ≈ 2 min/question — very reasonable |
| Passing score | **720 / 1000** scaled | So ≈ 72 % raw, but it is scaled |
| Scenario count | **4 of 6** randomly selected | See §4 below |
| Proctoring | **Strict online proctoring** | Camera on, screen-shared, no other apps |
| Materials allowed | **None** | No Claude, no ChatGPT, no Google, no notes, no textbook |
| Attempts | 1 free (partner), retakes after 14 days | Additional fees for retakes may apply |
| Price | **$99 USD** | Free for first 5 000 partner-network employees |
| Delivery | **Anthropic Academy on Skilljar** | https://anthropic.skilljar.com |
| Validity | Assumed **2 years** (matches industry norm; Anthropic has not yet published the policy) | |
| ID required | Government-issued photo ID | |

## 3. Domain Weights (memorize, tattoo, live by)

```
D1 Agentic Architecture & Orchestration    ████████████████████████████  27 %
D2 Claude Code Configuration & Workflows   ████████████████████         20 %
D3 Prompt Engineering & Structured Output  ████████████████████         20 %
D4 Tool Design & MCP Integration           ██████████████████           18 %
D5 Context Management & Reliability        ███████████████              15 %
```

> **Nuance**: Different sources (the-ai-corner, claudecertifications.com, claudedirectory) cite *very* slightly different weights — 25 % vs 27 %, 18 % vs 20 % — because Anthropic originally published "approximate" percentages. The **relative ordering** is correct and stable. Agentic Architecture is always largest. Context/Reliability is always smallest.

### What each domain actually tests

- **D1 Agentic Architecture** — Whether you understand agentic *loops* (not one-shot calls), multi-agent orchestration (hub-and-spoke), deterministic enforcement via hooks (not prompts), session lifecycle (`--resume`, `fork_session`), and **task decomposition** strategies.
- **D2 Claude Code Config** — Whether you can configure a Claude Code installation for a 20-person engineering team: `CLAUDE.md` hierarchy, custom slash commands vs. skills, plan mode, iterative refinement, CI/CD non-interactive (`-p`) flag, Message Batches API for nightly scans.
- **D3 Prompt Engineering & Structured Output** — Whether you can get *reliable, parseable* output at scale using explicit criteria, few-shot examples (2–4), `tool_use` JSON schemas, validation-retry loops, multi-pass review.
- **D4 Tool Design & MCP Integration** — Whether your tool descriptions help Claude select the right tool, your errors are structured (`isError`, `errorCategory`, `isRetryable`), your tools are *distributed* across focused subagents, and your MCP servers are configured securely (`${ENV_VAR}`).
- **D5 Context Management & Reliability** — Whether you know that progressive summarization silently destroys critical data, that sentiment ≠ complexity, and that provenance metadata (source, confidence, timestamp) is the only correct way to resolve multi-agent conflicts.

## 4. Scenarios — 4 of 6 selected per sitting

Each question block is embedded in a realistic **business scenario**. The exam engine randomly selects 4 of 6 possible scenarios. You cannot choose. You *must* be comfortable with **all 6**:

| # | Scenario | Primary domains |
|---|----------|-----------------|
| 1 | Customer Support Resolution Agent | D1, D4, D5 |
| 2 | Code Generation with Claude Code | D2, D3 |
| 3 | Multi-Agent Research System | D1, D5 |
| 4 | Developer Productivity with Claude | D2, D4 |
| 5 | Claude Code for CI/CD | D2, D3 |
| 6 | Structured Data Extraction | D3, D5 |

Each scenario comes with a **paragraph of business context**, then 8 – 12 questions that reference it. Read the scenario twice before answering. The stakes the scenario establishes (latency, cost, compliance, scale) determine which answer is "most correct."

## 5. Question Styles (what to expect)

### Style 1 — The classic "pick the best design"
> You are designing a customer-support agent that must enforce a $500 refund cap. Which approach is most reliable?
> 1. Put "never refund above $500" in the system prompt
> 2. Use a `PostToolUse` hook that blocks refund tool calls above $500
> 3. Ask Claude to self-check before calling `process_refund`
> 4. Rely on `tool_choice: "auto"` filtering

**Right answer: 2.** Classic hook-vs-prompt distractor (D1).

### Style 2 — The "spot the anti-pattern"
> Which of the following signals should trigger escalation to a human agent? (Select ALL that apply)
> - [ ] Customer explicitly asks for a human
> - [ ] Refund amount exceeds $500
> - [ ] Customer's last message contains profanity
> - [ ] Agent's internal confidence score is < 0.7
> - [ ] No existing policy covers the case

**Right answer: boxes 1, 2, 5.** Sentiment and self-reported confidence are anti-patterns.

### Style 3 — The "two right-looking options"
> Your team wants every Claude Code session to auto-lint modified files. Which configuration is correct?
> 1. Add a line to `CLAUDE.md` saying "Always run ESLint after edits."
> 2. Configure a `PostToolUse` hook for `Write|Edit` in `.claude/settings.json`.

Both *could* arguably work — but the question is about **reliability**. Hooks are deterministic. Instructions in `CLAUDE.md` are probabilistic. Right answer: 2.

### Style 4 — The "multi-concept chain"
> An extraction pipeline is missing 30 % of vendor names on invoices. Which combination of changes will most improve accuracy? (Select TWO)
> - [ ] Switch from `tool_choice: "auto"` to forcing the `extract_invoice` tool
> - [ ] Increase `max_tokens` from 4 096 to 16 384
> - [ ] Add 2–3 few-shot examples of invoices with unusual vendor layouts
> - [ ] Append the 30 % failure's specific validation errors to the retry prompt
> - [ ] Use a single large prompt instead of the validation-retry loop

**Right answer: boxes 1 and 3** (or 1 and 4 depending on the scenario). Several choices look right — but only two attack the *root cause*.

## 6. Scoring & Passing

- Raw scores are normalized to a **1000-point scale** with **720 = pass**.
- Each question is scored independently; there is **no negative marking** — always answer every question.
- The exam uses **item-response theory (IRT)**-style weighting, meaning harder questions contribute more. A strong performance on scenario questions often matters more than answering every gimme correctly.
- **Partial credit** on multi-select: Anthropic has not officially disclosed whether partial credit is awarded. Assume all-or-nothing on multi-select — **read carefully and mark every correct box**.

## 7. Registration & Prerequisites

- Apply for the Partner Network at https://claude.com/partners (free, ≈ 48-hour turnaround).
- Partner employees are invited to https://anthropic.skilljar.com/claude-certified-architect-foundations-access-request.
- Non-partner individuals can register for $99 once seats re-open.
- There are **no formal prerequisites**, but Anthropic strongly recommends:
  - ≥ 6 months hands-on Claude experience
  - Completion of **"Building with the Claude API"** (8.1 h) on Anthropic Academy
  - At least one shipped production system using Claude

## 8. What's NOT on the Exam (nice-to-know)

- Model-weights internals, training dynamics, RLHF theory — **out of scope**.
- Specific token prices or rate-limit numbers (beyond "Batch = 50 % cheaper") — not heavily tested.
- Exact MCP wire protocol (JSON-RPC frame format) — not tested at architecture level.
- Competitor models (GPT-4, Gemini, Llama) — not tested.
- Safety/RLHF alignment deep dives — out of scope for Foundations.

## 9. Recommended Reading/Watching Before You Open This Pack

Complete these **before** diving into the domain deep dives — it will make every subsequent page click into place:

1. **Anthropic Academy: "Building with the Claude API"** (8.1 h) — the single best free course.
2. **Anthropic Academy: "Introduction to MCP"** (90 min).
3. **Claude Code docs** — read the whole thing, it's < 50 pages.
4. **MCP spec overview** — `modelcontextprotocol.io`, the first 10 pages.
5. Build **one tiny agent** — even a "weather + joke generator" — so the loop feels tangible.

## 10. A Blunt Success Framework

- **Weeks 1 – 4**: Foundations (read, build, fail, rebuild).
- **Weeks 5 – 8**: Applied knowledge (write code that runs in CI, ship an MCP server).
- **Weeks 9 – 10**: Practice-test heavy, review wrong answers ruthlessly.
- **Weeks 11 – 12**: Full-length mock exams under timed, proctored-simulation conditions.

The people who fail the exam usually do one of three things:
1. Treat it like an API-syntax trivia exam and memorize function signatures.
2. Skip the scenarios and focus only on the highest-weighted domain.
3. Study without building anything real.

Don't do any of those.

---

Next → [`02-Quick-Reference-Cheatsheet.md`](02-Quick-Reference-Cheatsheet.md) or jump to [`00-12-Week-Study-Plan.md`](00-12-Week-Study-Plan.md).
