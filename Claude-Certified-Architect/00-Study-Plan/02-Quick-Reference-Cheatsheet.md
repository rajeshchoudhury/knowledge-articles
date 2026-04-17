# Quick-Reference Cheatsheet (Print Me)

One page to skim 15 minutes before the exam. If this is the only document you memorize, you will clear 75–80 % of the exam.

---

## The 10 Golden Laws

1. Loop control → **always check `stop_reason`** (`"tool_use"` → continue, `"end_turn"` → exit). Never parse text. Never use iteration caps as primary stop.
2. Critical business rules → **hooks**, never prompts. `PreToolUse` blocks *before* execution; `PostToolUse` intercepts *after*.
3. **4 – 5 tools per agent**. More → distribute to specialized subagents via the `Task` tool.
4. `tool_use` guarantees **structure only**, not semantics. Always validate content after extraction.
5. **Escalate on** explicit request, policy gap, capability limit, threshold breach. **Never on** sentiment or self-reported confidence.
6. **Access failure ≠ empty result**. A failed DB lookup returns `isError: true, errorCategory: "timeout", isRetryable: true`, not `[]`.
7. **Case-facts blocks** (front-of-context, immutable) > progressive summarization.
8. **Separate sessions** for code generation and code review. Same-session = confirmation bias.
9. `.mcp.json` = project (committed); `~/.claude.json` = user (personal). **Secrets via `${ENV_VAR}`**, never hard-coded.
10. **Batch API** = 50 % cheaper, 24 h SLA. Use for non-urgent. Synchronous for blocking.

---

## Domain Weights

| D1 Agentic | D2 Tool/MCP | D3 Claude Code | D4 Prompt Eng | D5 Context |
|---|---|---|---|---|
| 27 % | 18 % | 20 % | 20 % | 15 % |

---

## The 6 Built-in Tools (Claude Code)

| Tool | Use for | Don't use for |
|---|---|---|
| **Read** | Reading file contents | Anything else |
| **Write** | Creating **new** files only | Modifying existing (replaces entire file!) |
| **Edit** | Targeted edits to **existing** files | Creating new files |
| **Bash** | Shell commands (tests, builds, installs) | File I/O (use Read/Write/Edit), searching (use Grep/Glob) |
| **Grep** | Searching file **contents** (patterns inside files) | Finding files by name (use Glob) |
| **Glob** | Finding files by **name pattern** | Searching contents |

---

## Agentic Loop — the Canonical Snippet

```python
while True:
    response = client.messages.create(model=..., tools=tools, messages=messages)
    if response.stop_reason == "end_turn":
        break                               # DONE
    if response.stop_reason == "tool_use":
        tool = next(b for b in response.content if b.type == "tool_use")
        result = execute_tool(tool.name, tool.input)
        messages.append({"role": "assistant", "content": response.content})
        messages.append({"role": "user",
                         "content": [{"type": "tool_result",
                                      "tool_use_id": tool.id,
                                      "content": result}]})
```

---

## CLAUDE.md Hierarchy (precedence bottom-up)

```
~/.claude/CLAUDE.md            ← user-level (personal, NOT shared)
project/.claude/CLAUDE.md      ← project-level (SHARED via git)
project/src/api/CLAUDE.md      ← directory-level (scoped, most specific wins)
```

Modular layout:

```
project/.claude/
  CLAUDE.md                    ← imports other rule files
  rules/
    typescript.md              ← auto-loaded
    testing.md                 ← auto-loaded
    api-design.md              ← imported with @import
  commands/
    review.md                  ← /review slash command
  skills/
    refactor/
      SKILL.md                 ← forked context, restricted tools
```

`SKILL.md` YAML frontmatter:
```yaml
---
context: fork                  # runs in isolated context window
allowed-tools: [Read, Edit, Grep]   # scoped access
argument-hint: "file or directory"
---
```

---

## Structured Error Response (canonical)

```json
{
  "isError": true,
  "errorCategory": "timeout | auth | not_found | rate_limit | validation",
  "isRetryable": true,
  "context": {
    "attempted": "Customer lookup by email",
    "service":   "customer-db",
    "suggestion":"Retry after 2s or try account_id lookup"
  }
}
```

Empty result is NOT an error:
```json
{ "isError": false, "customers": [], "metadata": { "searched_by": "email" } }
```

---

## `tool_use` Structured Output Pattern

```python
extract_tool = {
  "name": "extract_invoice",
  "description": "Extract structured invoice data",
  "input_schema": {
    "type": "object",
    "properties": {
      "vendor":  {"type": "string"},
      "total":   {"type": "number"},
      "type":    {"type": "string",
                  "enum": ["invoice","credit_note","proforma","other"]},
      "type_detail": {"type": "string"}      # required if type == "other"
    },
    "required": ["vendor","total","type"]
  }
}

resp = client.messages.create(
   tools=[extract_tool],
   tool_choice={"type":"tool","name":"extract_invoice"},   # FORCED
   messages=[...]
)
```

Remember: schema = structure only. **Still validate semantics**.

---

## Escalation Decision Tree (memorize)

```
Is there a policy gap? ─────────── YES → escalate
Does customer explicitly ask? ──── YES → escalate
Does task exceed capability? ───── YES → escalate
Is amount > business threshold? ── YES → escalate  (enforced by hook!)
                                    NO → handle
ANTI-PATTERNS (never escalate on):
 × negative sentiment
 × self-reported confidence < threshold
```

---

## Case Facts Block (D5)

```markdown
## CASE FACTS (immutable — do not summarize)
| Field          | Value                     |
|----------------|---------------------------|
| Customer       | John Smith                |
| Account ID     | ACC-12345                 |
| Order          | #98765                    |
| Expected price | $99.99 (promo SUMMER2026) |
| Charged price  | $150.00                   |
| Overcharge     | $50.01                    |
```
Placed at **START** of context → high-recall position, survives `/compact`.

---

## CI/CD Cheat Line

```bash
claude -p "$PROMPT" \
  --output-format json \
  --json-schema '{"type":"object","properties":{...},"required":[...]}'
```

- `-p` → non-interactive (**required** for CI)
- `--output-format json` → parseable output
- `--json-schema` → enforced shape
- **Never** same-session for generator + reviewer

---

## Batch API (Message Batches)

| Metric | Value |
|---|---|
| Cost savings | **50 %** |
| Max processing window | **24 h** |
| Per-request tracking | `custom_id` |
| Use when | Latency-tolerant (nightly audit, weekly scan) |
| Don't use when | Blocking PR review, real-time feedback |

---

## Session Commands

| Command | Effect |
|---|---|
| `claude --resume` | Continue previous session with full context |
| `claude --resume --session-name "feature-x"` | Resume a named session |
| `claude fork_session --reason "..."` | Branch into an isolated exploration that inherits context |
| `/compact` | Compress current conversation to reclaim context space |

---

## `.mcp.json` (project-level, canonical)

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": { "POSTGRES_URL": "${DATABASE_URL}" }
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}" }
    }
  }
}
```

**Never hardcode secrets**. Always `${ENV_VAR}`.

---

## Hooks (`.claude/settings.json`)

```json
{
  "hooks": {
    "PreToolUse":  [{"matcher": "Write|Edit",
                     "hook": {"type":"command","command":"./guard-secrets.sh"}}],
    "PostToolUse": [{"matcher": "Write|Edit",
                     "hook": {"type":"command","command":"npx eslint --fix $CLAUDE_FILE_PATH"}}],
    "Notification":[{"matcher": ".*",
                     "hook": {"type":"command","command":"osascript -e '...'"}}],
    "Stop":        [{"matcher": ".*",
                     "hook": {"type":"command","command":"npm test"}}]
  }
}
```

Exit codes:
- `0` → success, continue
- `1` on `PreToolUse` → **block** action (Claude sees stderr)
- `1` on `PostToolUse` → feedback error to Claude
- `2` → silent failure, continue

---

## Few-Shot Rules

- **2 – 4 examples** is the sweet spot.
- All examples use the **same output format**.
- **Cover at least one edge case** (sarcasm, mixed sentiment, ambiguous type).
- `> 6 examples` → bloat without benefit.

---

## Validation-Retry Loop (pseudocode)

```
for attempt in 1..3:
    output = extract_with_tool_use()
    errors = validate_semantics(output)         # NOT just schema
    if not errors: return output
    append_user_msg(SPECIFIC errors — which field, expected vs actual)
raise ExtractionError
```

Generic "please try again" = anti-pattern. Specific errors = golden.

---

## Stratified Metrics

```
Aggregate:    95 %  (LOOKS GREAT)
Invoices:     70 %  (ACTUALLY FAILING)
Receipts:     98 %
Contracts:   100 %
```
Track per-category accuracy. Aggregate always hides at least one failing cohort.

---

## Provenance Schema

```python
@dataclass
class DataWithProvenance:
    value:        Any
    source:       str         # "financial-db", "quarterly-pdf"
    confidence:   Literal["verified","extracted","inferred","estimated"]
    retrieved_at: datetime
    agent_id:     str
```

Conflict resolution → highest-ranked `confidence` wins; always log the conflict.

---

## 5-Minute Exam-Day Mantra

Whisper to yourself 3 times:

> *"Stop reason. Hooks not prompts. 4-5 tools. Structure not semantics. Case facts. Access-failure not empty. Separate sessions. ENV VAR. Batch 50 %. Sentiment is never a trigger."*

That covers ~80 % of what will be on the exam.

---

**Good luck.** Now close this tab and go sleep.
