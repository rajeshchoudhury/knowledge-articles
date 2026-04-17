# The Complete 12-Week Study Plan

> Total commitment: **≈ 84 hours** over **12 weeks** at **~1 hour/day** (7 d/wk, with one rest day).
> This plan assumes you are an experienced software architect with **zero prior Claude exposure**. If you already use Claude Code daily, you can compress weeks 1 – 4 into 2 weeks.

Each week is structured as **5 study days + 1 practice test + 1 rest day**. Stick to the rhythm — the rest day is when memory consolidates.

---

## Phase 1 — Foundations (Weeks 1 – 4)

Goal: Build a rock-solid mental model of agentic systems, multi-agent orchestration, hooks, and MCP tooling. By the end of Phase 1, you can *draw* a production Claude system on a whiteboard without looking anything up.

### Week 1 — Agentic Loops & Core API  (Domain 1.1)

| Day | Task | Time | File |
|---|---|---|---|
| **1** | Read `Exam-Overview.md` + `Quick-Reference-Cheatsheet.md` | 60 min | `00-Study-Plan/01-Exam-Overview.md`, `02-Quick-Reference-Cheatsheet.md` |
| **2** | Read `01-Agentic-Loops.md` (deep dive) | 60 min | `01-Domain1-Agentic-Architecture/01-Agentic-Loops.md` |
| **3** | Install Anthropic Python SDK, run `09-Code-Samples/01-Agent-SDK-Basics.py`; modify to call 2 tools back-to-back | 90 min | `09-Code-Samples/01-Agent-SDK-Basics.py` |
| **4** | Study anti-patterns: *parsing natural language for termination*, *arbitrary iteration caps* | 45 min | `10-Anti-Patterns/01-Cheatsheet.md` (D1 section) |
| **5** | Practice Test 1 — 15 D1.1 questions, then review every wrong answer | 75 min | `11-Sample-Questions/01-Domain1-Questions.md` (Qs 1 – 15) |
| **6** | Draw the agentic loop from memory; compare to the Mermaid diagram | 30 min | `08-Diagrams/01-Agentic-Loop.md` |
| **7** | **Rest** | — | — |

**End-of-week gut check**: *Can you explain the difference between `stop_reason = "tool_use"` and `stop_reason = "end_turn"` without notes? Can you describe why iteration caps are an anti-pattern?*

---

### Week 2 — Multi-Agent Orchestration  (Domain 1.2)

| Day | Task | Time | File |
|---|---|---|---|
| 1 | Read `02-Multi-Agent-Orchestration.md` | 60 min | `01-Domain1-Agentic-Architecture/02-Multi-Agent-Orchestration.md` |
| 2 | Study hub-and-spoke pattern, `Task` tool, context isolation | 45 min | same + `08-Diagrams/02-Hub-and-Spoke.md` |
| 3 | Build: coordinator + 2 subagents. Each subagent has 4 tools, ALL context is passed *explicitly*. | 90 min | `09-Code-Samples/02-Multi-Agent-System.py` |
| 4 | Study `fork_session` vs `--resume`; experiment with branching an exploration session | 60 min | `01-Domain1-Agentic-Architecture/04-Session-Management.md` |
| 5 | Practice Test 2 — 15 D1.2 questions | 75 min | `11-Sample-Questions/01-Domain1-Questions.md` (Qs 16 – 30) |
| 6 | Re-draw the hub-and-spoke diagram; identify *where* context leaks occur | 45 min | `08-Diagrams/02-Hub-and-Spoke.md` |
| 7 | **Rest** | — | — |

---

### Week 3 — Hooks, Workflows & Sessions  (Domain 1.3 – 1.4)

| Day | Task | Time | File |
|---|---|---|---|
| 1 | Read `03-Hooks-and-Enforcement.md` in full | 60 min | `01-Domain1-Agentic-Architecture/03-Hooks-and-Enforcement.md` |
| 2 | Memorize the two hook categories: `PreToolUse`, `PostToolUse`. Run `09-Code-Samples/03-Hooks.py` | 60 min | `09-Code-Samples/03-Hooks.py` |
| 3 | Build a hook that blocks refunds > $500 and redirects to escalation queue | 90 min | same + `01-Domain1-Agentic-Architecture/03-Hooks-and-Enforcement.md` |
| 4 | Study `05-Task-Decomposition.md`: prompt chaining vs dynamic adaptive | 60 min | `01-Domain1-Agentic-Architecture/05-Task-Decomposition.md` |
| 5 | Practice Test 3 — 15 questions mixing hooks, sessions, decomposition | 75 min | `11-Sample-Questions/01-Domain1-Questions.md` (Qs 31 – 40) |
| 6 | Review wrong answers deeply — aim to recognize the anti-pattern by name | 45 min | `10-Anti-Patterns/01-Cheatsheet.md` |
| 7 | **Rest** | — | — |

---

### Week 4 — Tool Design & MCP  (Domain 2 — entire domain)

| Day | Task | Time | File |
|---|---|---|---|
| 1 | Read `01-Tool-Description-Best-Practices.md` and `05-Built-in-Tools.md` | 75 min | `02-Domain2-Tool-Design-MCP/01-...`, `05-...` |
| 2 | Read `02-Structured-Error-Responses.md` and `03-Tool-Distribution.md` | 75 min | `02-Domain2-Tool-Design-MCP/02-...`, `03-...` |
| 3 | Read `04-MCP-Server-Configuration.md` and stand up a local MCP server (`09-Code-Samples/04-MCP-Server.ts`) | 120 min | `09-Code-Samples/04-MCP-Server.ts` |
| 4 | Drill the **access failure vs empty result** distinction until it is automatic | 45 min | `10-Anti-Patterns/01-Cheatsheet.md` (D2) |
| 5 | Practice Test 4 — 20 D2 questions | 90 min | `11-Sample-Questions/02-Domain2-Questions.md` (Qs 1 – 20) |
| 6 | Review wrong answers; memorize the 6 built-in tools and their correct use cases | 45 min | `02-Domain2-Tool-Design-MCP/05-Built-in-Tools.md` |
| 7 | **Rest** | — | — |

**Phase 1 gate**: *Score ≥ 70 % on Practice Tests 1 – 4*. If not, repeat the weakest week before moving on. Don't skip this gate.

---

## Phase 2 — Applied Knowledge (Weeks 5 – 8)

Goal: Configure Claude Code, design prompts that produce reliable output at scale, and integrate Claude into CI/CD.

### Week 5 — Claude Code Configuration  (Domain 3.1 – 3.2)

| Day | Task | Time |
|---|---|---|
| 1 | Read `01-CLAUDE-md-Hierarchy.md` — understand the 3 levels | 60 min |
| 2 | Read `02-Commands-vs-Skills.md` — memorize the fork/allowed-tools pattern | 60 min |
| 3 | Set up a `.claude/` directory in a real project. Add `CLAUDE.md`, one slash command (`/review`), one skill (`refactor/`). | 90 min |
| 4 | Study path-specific rules with YAML frontmatter + glob patterns | 45 min |
| 5 | Practice Test 5 — 20 D3.1 – 3.2 questions | 90 min |
| 6 | Review; redraw the 3-layer hierarchy from memory | 45 min |
| 7 | **Rest** | — |

### Week 6 — Plan Mode, Iteration & CI/CD  (Domain 3.3 – 3.4)

| Day | Task | Time |
|---|---|---|
| 1 | Read `03-Plan-Mode-Iteration.md` | 60 min |
| 2 | Read `04-CICD-Integration.md` and `05-Batch-Processing.md` | 90 min |
| 3 | Build a GitHub Actions workflow that runs `claude -p "..." --output-format json --json-schema '...'` on every PR | 120 min |
| 4 | Study the Batch API — when to use it, cost savings, `custom_id` pattern | 45 min |
| 5 | Practice Test 6 — 20 D3.3 – 3.4 questions | 90 min |
| 6 | Memorize: `-p`, `--output-format json`, `--json-schema`, `--resume`, `fork_session`, `/compact` | 30 min |
| 7 | **Rest** | — |

### Week 7 — Prompt Engineering & Structured Output  (Domain 4.1 – 4.2)

| Day | Task | Time |
|---|---|---|
| 1 | Read `01-Explicit-Criteria.md` and `02-Few-Shot-Prompting.md` | 75 min |
| 2 | Rewrite 3 vague prompts from past projects into explicit, measurable criteria | 60 min |
| 3 | Build: a sentiment classifier with 4 few-shot examples (1 positive, 1 negative, 1 mixed, 1 sarcastic) | 75 min |
| 4 | Read `03-Tool-Use-Structured-Output.md` and `04-JSON-Schema-Design.md` | 75 min |
| 5 | Practice Test 7 — 20 D4.1 – 4.2 questions | 90 min |
| 6 | Review; memorize `tool_choice` options (`auto` / `any` / forced) | 30 min |
| 7 | **Rest** | — |

### Week 8 — Validation, Batch & Multi-Pass  (Domain 4.3 – 4.4)

| Day | Task | Time |
|---|---|---|
| 1 | Read `05-Validation-Retry-Loops.md` | 60 min |
| 2 | Build: `09-Code-Samples/06-Validation-Retry.py` — extract invoice data, validate, retry with SPECIFIC error messages | 120 min |
| 3 | Study multi-pass review: per-file local pass + cross-file integration pass | 60 min |
| 4 | Study why same-session self-review is an anti-pattern (context retention → confirmation bias) | 45 min |
| 5 | Practice Test 8 — 20 D4.3 – 4.4 questions | 90 min |
| 6 | Review; rebuild the validation-retry diagram from memory | 45 min |
| 7 | **Rest** | — |

**Phase 2 gate**: *Score ≥ 75 % on Practice Tests 5 – 8*.

---

## Phase 3 — Exam Preparation (Weeks 9 – 12)

Goal: Master Domain 5 (context, escalation, provenance), run full-length mock exams, and ruthlessly eliminate knowledge gaps.

### Week 9 — Context Optimization & Escalation  (Domain 5.1 – 5.2)

| Day | Task | Time |
|---|---|---|
| 1 | Read `01-Context-Optimization.md` | 60 min |
| 2 | Study "lost in the middle" effect; memorize **case facts blocks** pattern | 60 min |
| 3 | Read `02-Escalation-Error-Propagation.md` | 60 min |
| 4 | Memorize the 4 VALID escalation triggers and the 2 INVALID ones | 45 min |
| 5 | Practice Test 9 — 15 D5.1 – 5.2 questions | 75 min |
| 6 | Review; memorize **access failure vs empty result** dichotomy | 30 min |
| 7 | **Rest** | — |

### Week 10 — Extended Sessions, Human Review, Provenance  (Domain 5.3 – 5.4)

| Day | Task | Time |
|---|---|---|
| 1 | Read `03-Extended-Sessions.md` — `/compact`, scratchpad files | 60 min |
| 2 | Read `04-Human-Review.md` + `05-Information-Provenance.md` | 75 min |
| 3 | Build a data merge with provenance tracking (source, confidence, timestamp) | 90 min |
| 4 | Study **stratified metrics** — per-document-type tracking vs aggregate | 45 min |
| 5 | Practice Test 10 — 15 D5.3 – 5.4 questions | 75 min |
| 6 | Review; build the escalation decision tree from memory | 45 min |
| 7 | **Rest** | — |

### Week 11 — Integration & Hands-On Scenarios

| Day | Task | Time |
|---|---|---|
| 1 | Scenario 1 deep dive + exercise (Customer Support Agent) | 90 min |
| 2 | Scenario 2 deep dive + exercise (Code Generation) | 90 min |
| 3 | Scenario 3 deep dive + exercise (Multi-Agent Research) | 90 min |
| 4 | Scenario 4 deep dive + exercise (Developer Productivity) | 90 min |
| 5 | **Full Mock Exam #1** — 60 Qs in 120 min, strict conditions | 135 min |
| 6 | Review all wrong answers, map each to a specific anti-pattern | 90 min |
| 7 | **Rest** | — |

### Week 12 — Final Sprint

| Day | Task | Time |
|---|---|---|
| 1 | Scenario 5 deep dive + exercise (CI/CD) | 90 min |
| 2 | Scenario 6 deep dive + exercise (Structured Data Extraction) | 90 min |
| 3 | **Full Mock Exam #2** — 60 Qs, timed, proctor-simulation | 135 min |
| 4 | Deep review of Mock #2; rebuild key diagrams from memory | 90 min |
| 5 | **Full Mock Exam #3** — 60 Qs, timed | 135 min |
| 6 | Light review: cheat sheets, golden laws, top anti-patterns. Early bed. | 45 min |
| 7 | **EXAM DAY** | 120 min |

---

## How to Use Practice Tests Effectively

1. **Time-box strictly.** 120 min for 60 Qs = 2 min/Q. If you're over, practice with 100 min for 60 Qs.
2. **Flag, don't guess.** Flag uncertain answers; come back at the end.
3. **On multi-select, mark every correct option** — partial credit is not guaranteed.
4. **For every wrong answer, write a sentence** explaining the anti-pattern you missed. Keep a growing "miss log."
5. **Re-take within 3 days.** Spaced repetition beats cramming.

## Common Failure Modes (and how to avoid them)

| Failure mode | Symptom | Fix |
|---|---|---|
| **"I know this, so I'll skip Phase 1"** | 60 % on Mock #1 | Go back and do the fundamentals |
| **Memorize syntax, not architecture** | Fail on scenario questions | Re-do every scenario walkthrough end-to-end |
| **Skip the anti-patterns** | Fall for distractors every time | Print the anti-pattern sheet, tape it to your monitor |
| **No hands-on** | Can recite the docs but can't apply them | Build ONE real system before exam week |
| **Cramming Week 12** | Burnout, panic, low score | Stop studying 18 h before the exam |

---

Next → [`02-Quick-Reference-Cheatsheet.md`](02-Quick-Reference-Cheatsheet.md)
