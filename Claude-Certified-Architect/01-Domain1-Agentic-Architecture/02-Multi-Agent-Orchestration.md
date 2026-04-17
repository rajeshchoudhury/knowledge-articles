# D1.2 — Multi-Agent Orchestration

> This is **the hardest sub-topic** in the highest-weighted domain on the exam. Scenario 3 (Multi-Agent Research System) hammers on it. Expect 4 – 6 questions.

## 1. The Architectural Shift

A single agent with one set of tools works fine for narrow tasks. But real systems have to:
- Run **multiple sub-tasks in parallel**.
- Keep **specialized knowledge** in each role.
- Avoid **context pollution** across unrelated sub-tasks.
- **Scale to more domains** without degrading tool selection.

The answer to all four is the **hub-and-spoke** multi-agent pattern, where a **coordinator** delegates specialized work to **subagents**.

## 2. Hub-and-Spoke vs. Flat Architectures

### Flat (anti-pattern)
```
           ┌──────────────┐
           │   Mega-Agent │  ← one agent, 18 tools, one shared context
           └──────┬───────┘
          ┌───────┼───────┐
       web      DB      email
      search  query    sender
       ... 15 more tools ...
```
**Problems:**
- Tool selection accuracy degrades sharply > 5 tools.
- Context gets polluted with irrelevant details from other sub-tasks.
- No parallelism — everything serializes on one conversation.
- One poorly phrased instruction drifts every sub-task.

### Hub-and-Spoke (correct pattern)
```
                 ┌─────────────────┐
                 │   Coordinator   │   tools: [Task, summarize, format_report]
                 │   (3 tools)     │
                 └────────┬────────┘
                          │ Task delegations
          ┌───────────────┼───────────────┐
          ▼               ▼               ▼
 ┌──────────────┐ ┌─────────────┐ ┌────────────────┐
 │Market Agent  │ │Tech Agent   │ │Finance Agent   │   each has 4-5 tools,
 │4 tools       │ │4 tools      │ │4 tools         │   isolated context
 └──────────────┘ └─────────────┘ └────────────────┘
```

### Why hub-and-spoke wins
| Dimension | Flat | Hub-and-spoke |
|---|---|---|
| Tool selection accuracy | Low (18 choices) | High (4 – 5 choices) |
| Context pollution | High | Isolated per subagent |
| Parallelism | None | Native (multiple `Task` calls) |
| Specialization | One prompt does everything | Each subagent's system prompt can be narrow |
| Failure blast radius | Whole session | One subagent |

## 3. The `Task` Tool — How Subagents Are Spawned

In the Agent SDK, the **`Task` tool** is the mechanism by which a coordinator creates subagents.

### 3.1 Enabling `Task`
Your coordinator must list `Task` in `allowedTools`:

```python
from claude_agent import Agent, Task

coordinator = Agent(
    model="claude-sonnet-4-20250514",
    allowed_tools=[Task, summarize, format_report],   # Task MUST be here
    system="You coordinate research across specialized subagents."
)
```

> **Exam trap**: If a coordinator question says "the agent cannot spawn subagents," the cause is nearly always that `Task` is missing from `allowedTools`.

### 3.2 A `Task` call

When Claude (as coordinator) calls `Task`, the call includes:

```json
{
  "prompt": "Research the AI infrastructure market: size, growth, top vendors.",
  "context": "Focus on USD, YoY growth, the top 3 vendors by revenue.",
  "tools": ["web_search", "read_doc", "extract_data", "format_citation"],
  "model": "claude-sonnet-4-20250514"
}
```

Key fields:
- `prompt` — the subagent's instruction.
- `context` — a targeted slice of information (see §4).
- `tools` — the subagent's **own, scoped** tool list (4 – 5 tools).
- `model` — may differ from coordinator (e.g., Haiku for cheap subtasks).

### 3.3 Parallel execution

**Multiple `Task` calls in a single assistant response** run in parallel:

```json
{
  "content": [
    {"type": "text", "text": "Dispatching three researchers..."},
    {"type": "tool_use", "name": "Task", "input": {"prompt": "Market research", ...}},
    {"type": "tool_use", "name": "Task", "input": {"prompt": "Tech analysis",  ...}},
    {"type": "tool_use", "name": "Task", "input": {"prompt": "Financials",     ...}}
  ]
}
```

The SDK fires all three subagents concurrently and collects results before the coordinator's next turn.

## 4. Context Isolation — the Single Most-Tested Idea

> **Exam rule**: Subagents receive ONLY the context they need. Sharing the coordinator's full conversation history is **always wrong**.

### 4.1 Why
- The subagent pays tokens for every word you send.
- Irrelevant information degrades focus (the "haystack" problem).
- Sensitive information in the coordinator (e.g., PII) shouldn't reach every subagent.

### 4.2 What to pass
- The **goal** of the subtask, written as a standalone brief.
- The **deliverable format** — e.g., "return a list of {vendor, revenue, growth} tuples."
- **Constraints** — e.g., "only data from 2024 onwards, USD."
- **Any specific data points** the subagent needs to ground its work.

### 4.3 What NOT to pass
- The coordinator's system prompt.
- Previous subagents' outputs unless they are direct inputs.
- Conversation chit-chat.
- Full tool-call history.

### 4.4 Code comparison

**❌ Anti-pattern**
```python
Task(
    prompt="Summarize the findings.",
    context=coordinator.full_conversation_history,   # 40k tokens, 90% irrelevant
)
```

**✅ Correct**
```python
Task(
    prompt="Summarize the findings into 5 bullet points with citations.",
    context=json.dumps({
        "findings": [market_result, tech_result, finance_result],
        "audience": "executive briefing, < 200 words",
        "citation_format": "APA"
    }),
)
```

## 5. Synthesis & Result Handling

A subagent's return value goes back to the coordinator as a **single assistant message**. The coordinator then:

1. **Reads** the subagent outputs.
2. **Reconciles** conflicting information (see D5 Provenance).
3. **Synthesizes** a final answer.
4. **Formats** the deliverable.

Synthesis is where `format_report` / `summarize` coordinator tools come in. They rarely need more than 3 – 5 coordinator-level tools:

- `Task` — spawn subagents
- `summarize_results` — consolidate subagent outputs
- `format_report` — produce final user-facing output
- optionally `escalate_human` — if no subagent can complete

## 6. Task Decomposition — Getting the Split Right

### 6.1 Overly narrow decomposition (anti-pattern)
Splitting into too-fine-grained subtasks creates **coverage gaps**:

```
Subtask 1: Search Google for "AI market size"
Subtask 2: Search Google for "AI market growth"
Subtask 3: Search Google for "AI vendor share"
```
None of these checks whether Bing has better results, none follows up on broken links, and none notices that "market" and "industry" are used interchangeably in sources. The gap is real.

### 6.2 Overly broad decomposition (anti-pattern)
The opposite mistake — one subagent is asked to do three subtasks and becomes a mini mega-agent, losing all the benefits of isolation.

### 6.3 Good decomposition
Split along **natural domain boundaries**, not mechanical ones:

```
Subtask 1: Market landscape (size, growth, segments)
Subtask 2: Technology landscape (leading architectures, open-source activity)
Subtask 3: Competitive landscape (top 5 vendors, differentiators)
```
Each subtask has a clear goal, its own context, 4 – 5 tools, and no overlap.

## 7. Prompt Chaining vs. Dynamic Adaptive Decomposition

| | Prompt chaining | Dynamic adaptive |
|---|---|---|
| Path | **Predefined, linear** | Decided at runtime by the agent |
| Suits | Predictable workflows (ETL, fixed pipelines) | Exploratory, unknown-shape tasks |
| Example | "Step 1 extract. Step 2 validate. Step 3 load." | "Analyse the codebase. Depending on what you find, decide whether to refactor, rewrite, or propose new architecture." |
| Exam key | Use when steps are always the same | Use when the tree depth/shape is unknown |

Concrete dynamic adaptive prompt:
```
Analyse the codebase and identify all issues. For each issue:
  - Assess severity and complexity.
  - If simple: fix directly.
  - If complex: create a plan first, then apply it.
  - After each fix: run the relevant tests.
Adapt your approach based on what you find.
```

## 8. `fork_session` — Parallel Exploration Without Context Pollution

Sometimes the coordinator itself wants to **branch** — e.g., explore two alternative API designs and compare.

- `fork_session` creates a **new branched session** that inherits the parent's context but diverges thereafter.
- Changes in the fork do **not** affect the main session.
- Used for **exploration**, A/B alternatives, what-ifs.

```bash
# Command-line
claude fork_session --reason "Trying GraphQL alternative to REST"
```

### `fork_session` vs. `--resume`
| | `fork_session` | `--resume` |
|---|---|---|
| Creates new branch? | **Yes** | No, same thread |
| Changes affect parent? | **No** | Yes |
| Use for | Exploration, A/B | Continuing work |

## 9. Multi-Model Strategies

Different subagents can use **different Claude models** based on cost and capability needs:

| Role | Typical model |
|---|---|
| Coordinator (reasons about everything) | **Claude Sonnet 4** |
| Heavy synthesis / legal review / architecture | **Claude Opus 4** |
| Simple extraction / classification / summary | **Claude Haiku 3.5** |

Pattern:
```python
heavy_reasoner = Agent(model="claude-opus-4-20250514", ...)
cheap_extractor = Agent(model="claude-haiku-3-5-20250101", tools=[extract])
```

Exam tip: If a question asks how to optimize cost in a 100 000-doc/day pipeline, the answer often involves **Haiku for the extraction step** and Sonnet/Opus only for reasoning passes.

## 10. Architectural Anti-Patterns Summary

| Anti-pattern | Why wrong | Correct approach |
|---|---|---|
| Flat 18-tool agent | Degrades tool selection | Hub-and-spoke with 4 – 5 tools per subagent |
| Sharing full coordinator context with subagents | Wastes tokens, confuses subagent | Pass only task-relevant context |
| Too-narrow decomposition | Coverage gaps | Split along domain boundaries |
| Coordinator without `Task` in `allowedTools` | Can't spawn subagents | Include `Task` |
| Using `fork_session` to resume work | Loses main-thread progress | Use `--resume` instead |
| Subagent gets subtask's prompt but NO constraints/format | Non-deterministic output | Include deliverable format + constraints in context |

## 11. End-to-End Worked Example

Build a **competitive research agent** for product managers.

```python
from claude_agent import Agent, Task

# Subagents
market_researcher = Agent(
    model="claude-sonnet-4-20250514",
    tools=[web_search, read_doc, extract_data, format_citation],
    system=("You are a market researcher. Deliverable: {size_usd, "
            "cagr, top_vendors[]} with sources.")
)

tech_analyst = Agent(
    model="claude-sonnet-4-20250514",
    tools=[read_code, grep_patterns, analyze_deps, format_report],
    system="You are a technology analyst. Focus on architecture patterns."
)

finance_analyst = Agent(
    model="claude-haiku-3-5-20250101",   # cheap model for financial ratios
    tools=[query_financials, compute_ratio, format_table],
    system="You are a finance analyst. Compute standard ratios."
)

# Coordinator
coordinator = Agent(
    model="claude-sonnet-4-20250514",
    allowed_tools=[Task, summarize_results, format_report],
    system="You coordinate parallel research; synthesize findings."
)

result = coordinator.run("""
Build a one-page brief on the AI infrastructure market. Delegate:
  1. Market landscape      → market_researcher
  2. Technology landscape  → tech_analyst
  3. Top 3 vendors' finance → finance_analyst
Pass EXPLICIT, MINIMAL context to each. Synthesize findings into a
one-page brief with citations.
""")
```

## 12. Exam Self-Check

1. *Your coordinator has 12 tools. It keeps calling the wrong one. What's the fix?*
   → Redistribute: 3 coordinator tools, 3 subagents each with 4 tools.
2. *Why is passing `coordinator.full_conversation_history` to a subagent wrong?*
   → Wastes tokens, pollutes the subagent's focus, leaks irrelevant PII.
3. *What's the difference between `fork_session` and `--resume`?*
   → `fork_session` creates an isolated branch; `--resume` continues the same thread.
4. *Is static prompt chaining or dynamic adaptive decomposition better for exploring an unknown codebase?*
   → Dynamic adaptive, because the tree shape is unknown in advance.

---

### Key Takeaways
- ✅ Hub-and-spoke > flat architectures, always.
- ✅ 4 – 5 tools per subagent, 3 – 5 for the coordinator.
- ✅ Pass only task-relevant context to each subagent.
- ✅ Use `fork_session` for exploration, `--resume` for continuation.
- ✅ Pick models per subagent based on reasoning needs and cost.
- ❌ Never share full coordinator context with subagents.
- ❌ Never decompose so narrowly that coverage gaps emerge.
- ❌ Don't forget `Task` in `allowedTools`.

Next → [`03-Hooks-and-Enforcement.md`](03-Hooks-and-Enforcement.md)
