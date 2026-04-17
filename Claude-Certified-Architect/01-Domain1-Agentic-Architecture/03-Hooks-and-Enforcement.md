# D1.3 — Hooks & Programmatic Enforcement

> **Central insight of this topic**: *Prompts are probabilistic. Hooks are deterministic. Never use a prompt where a hook belongs.*

## 1. Why the Exam Cares So Much

If you had to boil the entire certification down to one exam-grade insight, it would be this one. The exam returns to it through multiple scenarios — every time a question mentions "a critical business rule," "refund limit," "compliance," "never allow," or "security constraint," hooks are almost always the correct answer.

## 2. The Determinism Spectrum

```
  DETERMINISTIC                                  PROBABILISTIC
  ←──────────────────────────────────────────────────────→
  hooks      API guards      function code       prompts

  100 %      ≈100 %           100 %               75–99 %
  reliable   reliable         reliable            reliable
```

- **Code** (hooks, `try/except`, API validation) runs the same way every time.
- **Prompts** give the model "strong preferences" that it *usually* follows — but there is always a non-zero chance it ignores them.

For critical rules the word **"usually"** is disqualifying.

## 3. What a Hook Actually Is

In the Claude Agent SDK, a hook is a **function or shell command** that fires on a specific lifecycle event and can **block, modify, or observe** Claude's actions.

| Hook event | Fires when… | Typical use cases |
|---|---|---|
| `PreToolUse` | **Before** Claude executes a tool call | Block dangerous operations, validate inputs, inject defaults, enforce policies, scan for secrets |
| `PostToolUse` | **After** Claude executes a tool call | Normalize results, apply business rules, log, auto-lint, auto-test |
| `Notification` | Claude sends a notification | Desktop alert, Slack message, analytics |
| `Stop` | Claude finishes a task (`end_turn`) | Run final validation, generate summary, trigger CI |

Two of these (`PreToolUse`, `PostToolUse`) are the ones most heavily tested.

## 4. The Exit-Code Contract

Hooks are processes (or SDK functions). Their **exit codes** decide what Claude sees next:

| Exit code | `PreToolUse` | `PostToolUse` |
|---|---|---|
| `0` | Allow the tool call (stderr ignored) | Pass result through as-is |
| `1` | **Block** the tool call; Claude receives the stderr as feedback and tries a different path | **Error** reported to Claude; Claude may fix and retry |
| `2` | Soft fail — hook's error is silently ignored, Claude continues | Same — ignored |

Use exit code `2` for **non-critical** hooks (e.g., "auto-lint — but don't stop the world if ESLint crashes"). Use exit code `1` for **enforcement** hooks (e.g., "refund > $500 is BLOCKED").

## 5. The Canonical Enforcement Example: $500 Refund Limit

### 5.1 Business rule
"Agents may issue refunds up to $500 autonomously. Anything above $500 must be escalated to a human."

### 5.2 Prompt-based enforcement (❌ WRONG)

```
System prompt:
You are a customer service agent. If a refund request is for more than
$500, you MUST escalate to a human. Do NOT process it yourself.
```

**Why wrong**:
- The model "mostly" obeys — but "mostly" is not compliance.
- One failure → news headline: *"AI issues $12 000 unauthorized refund."*
- The rule is not auditable or testable.

### 5.3 Hook-based enforcement (✅ CORRECT)

```python
from claude_agent import Agent, Hook

def refund_limit_hook(tool_name, tool_input, tool_output):
    if tool_name == "process_refund":
        amount = tool_input.get("amount", 0)
        if amount > 500:
            return {
                "blocked": True,
                "reason": f"Refund ${amount:,.2f} exceeds $500 agent limit",
                "action": "escalate_to_human",
                "context": {
                    "customer_id":     tool_input.get("customer_id"),
                    "requested_amount": amount,
                    "agent_limit":      500,
                    "case_id":          generate_case_id(),
                }
            }
    return tool_output  # Pass through all other tool calls

agent = Agent(
    model="claude-sonnet-4-20250514",
    tools=[lookup_customer, check_order, process_refund],
    hooks={"PostToolUse": [refund_limit_hook]},
)
```

**Why right**:
- Refund enforcement runs as **code**, 100 % reliable.
- The hook returns structured context that Claude can act on (escalate, not retry).
- Auditable: the hook's code is reviewable, testable, version-controlled.

## 6. `PreToolUse` vs `PostToolUse` — When to Pick Which

| Question | `PreToolUse` | `PostToolUse` |
|---|---|---|
| "Block before it runs" | ✅ | ❌ |
| "Inspect / modify output" | ❌ | ✅ |
| "Scan the `Write` content for secrets" | ✅ | ❌ |
| "Normalize the data the tool returned" | ❌ | ✅ |
| "Enforce amount limit before hitting the payment API" | ✅ | ❌ |
| "Run ESLint on the file Claude just wrote" | ❌ | ✅ |
| "Block `Bash` commands containing `rm -rf /`" | ✅ | ❌ |

Rule of thumb:
- If the **action itself is dangerous** → `PreToolUse`.
- If the **output needs treatment** → `PostToolUse`.

Sometimes you need both (block bad inputs + lint outputs).

## 7. Claude Code `.claude/settings.json` Hook Config

Claude Code (as distinct from the raw Agent SDK) configures hooks via JSON:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hook": {
          "type": "command",
          "command": "grep -nEi '(api[_-]?key|secret|password|token)\\s*[:=]\\s*[\"\\'][^\"\\'{}$]+[\"\\']' /dev/stdin | head -5 && echo 'BLOCKED: Potential secret detected' >&2 && exit 1 || exit 0"
        }
      },
      {
        "matcher": "Bash",
        "hook": {
          "type": "command",
          "command": "echo \"$CLAUDE_TOOL_INPUT\" | grep -qE 'rm -rf /|DROP TABLE' && echo 'BLOCKED: Dangerous command' >&2 && exit 1 || exit 0"
        }
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hook": {
          "type": "command",
          "command": "npx eslint --fix \"$CLAUDE_FILE_PATH\" 2>/dev/null; exit 0"
        }
      }
    ],
    "Stop": [
      {
        "matcher": ".*",
        "hook": {
          "type": "command",
          "command": "npm test 2>&1 | tail -20"
        }
      }
    ]
  }
}
```

### Key fields
- `matcher` — regex against tool name. Combine with `|` (pipe).
- `hook.type` — always `"command"`.
- `hook.command` — shell command. Inputs come via:
  - `$CLAUDE_FILE_PATH` — path of file being modified
  - `$CLAUDE_TOOL_INPUT` — raw tool input (often JSON)
  - **stdin** — full tool input

### Best practices
- Keep hooks **fast** (< 500 ms ideally). They run synchronously.
- Use `; exit 0` at the end of `PostToolUse` to avoid halting Claude for minor failures.
- Write block messages to **stderr** (`>&2`) — that's what Claude sees.
- Prefer `grep -q` for silent matches, with explicit exit codes.

## 8. Escalation Triggers — the Interview-Style Exam Set-Piece

A scenario question will list 5 – 7 possible escalation triggers and ask you to select the correct ones. **Memorize the table below.**

### Valid triggers (✅ these should escalate)
| Trigger | Why it's objective |
|---|---|
| Customer explicitly requests a human | Explicit intent, not inference |
| Policy gap — no rule covers this case | Programmatic check against policy table |
| Task exceeds agent capabilities | e.g., agent lacks the tool; deterministic |
| Business threshold exceeded (refund > $500, transaction > $10 k, PII release, etc.) | **Hook-enforced**, auditable |
| Repeated failures after structured retries | After N retries with distinct error signatures |

### Invalid triggers (❌ anti-patterns)
| Trigger | Why it's wrong |
|---|---|
| **Negative sentiment** (customer is angry) | Sentiment ≠ task complexity. An angry customer with a simple address change does not need a human. |
| **Self-reported confidence** (`model_confidence < 0.7`) | Model confidence scores are not well-calibrated; unreliable for decisions. |
| **Long message length** (customer wrote a paragraph) | Length ≠ complexity. |
| **Retry count** as a lone trigger without analyzing the error | You might escalate simple transient timeouts. |

> **Exam pattern**: The wrong answers will always include sentiment, confidence, or length. The right answer uses policy gaps, capability limits, and business thresholds.

## 9. Data Normalization & Augmentation

`PostToolUse` hooks are also the right place for **data normalization**. Example: a tool returns phone numbers in mixed formats; the hook normalizes to E.164 before Claude sees the output.

```python
def normalize_phone(output):
    if "phone" in output:
        output["phone"] = convert_to_e164(output["phone"])
    return output

agent = Agent(
    tools=[lookup_customer],
    hooks={"PostToolUse": [normalize_phone]},
)
```

Benefits:
- Claude never sees inconsistent data.
- The normalization logic is **central** — fix once, applies everywhere.
- Downstream tools that consume the phone number get a consistent format.

## 10. Audit & Observability Hooks

Hooks are the ideal place to **log** tool usage for audit trails:

```python
def audit_log(tool_name, tool_input, tool_output):
    log_entry = {
        "timestamp": datetime.utcnow().isoformat(),
        "tool":       tool_name,
        "input":      redact_pii(tool_input),
        "status":     "ok" if tool_output and not tool_output.get("isError") else "error",
    }
    emit_to_datadog(log_entry)
    return tool_output    # pass-through
```

This gives SRE/Compliance a complete audit trail with zero code changes elsewhere.

## 11. Security Hooks

Hooks are the **primary** defense against Claude accidentally leaking secrets or executing dangerous commands.

Essential security hooks:
1. **Secret scanner** on `Write|Edit` — block files containing API keys / tokens.
2. **Dangerous-command blocker** on `Bash` — block `rm -rf /`, `DROP TABLE`, `sudo`.
3. **Protected-path blocker** on `Write|Edit` — block `.env`, `.git/`, `package-lock.json`.
4. **Network-egress blocker** on `Bash` — block `curl | sh` or `wget ... | bash` patterns.

Treat these as the equivalent of a pre-commit hook on a git repo: they are lightweight, they run every time, they save you from the one bad day.

## 12. Hooks vs CLAUDE.md — Which to Use When

| Use a hook when… | Use `CLAUDE.md` when… |
|---|---|
| Compliance / critical | Style guidance |
| Mechanical check | Contextual judgement |
| Binary pass/fail | Requires reasoning |
| Need guaranteed enforcement | Need gentle steering |
| Speed matters | Context matters |

Best practice: use **both**. `CLAUDE.md` defines *how* (architecture, style). Hooks enforce *what* (security, thresholds, formatting).

## 13. Worked Scenario — Customer Support Agent

You are asked: "Design an agent that issues refunds up to $500, escalates otherwise, and logs everything for compliance." Here's the full set of hooks:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "process_refund",
        "hook": {"type":"command","command":"./guards/refund-amount-check.sh"}
      },
      {
        "matcher": "send_email",
        "hook": {"type":"command","command":"./guards/pii-redactor.sh"}
      }
    ],
    "PostToolUse": [
      {
        "matcher": ".*",
        "hook": {"type":"command","command":"./audit/log-tool-call.sh"}
      },
      {
        "matcher": "lookup_customer",
        "hook": {"type":"command","command":"./normalizers/e164-phones.sh"}
      }
    ],
    "Stop": [
      {
        "matcher": ".*",
        "hook": {"type":"command","command":"./audit/session-summary.sh"}
      }
    ]
  }
}
```

Notice that this single config provides:
- **Enforcement** (refund cap)
- **Security** (PII redaction before sending email)
- **Compliance** (audit log of every tool call)
- **Data quality** (phone normalization)
- **Observability** (session summary on Stop)

All deterministic. All testable. All out of the prompt.

## 14. Exam Self-Check

1. *An exam stem says "every refund > $1000 must be escalated." What's the correct answer?*
   → A `PostToolUse` or `PreToolUse` hook on the refund tool. Never a prompt instruction.
2. *What exit code from a `PreToolUse` hook blocks Claude's action?*
   → `1` (writes block reason to stderr).
3. *Valid escalation triggers — which are correct? (a) negative sentiment (b) customer asks for human (c) confidence < 0.6 (d) refund > $500*
   → b and d.
4. *Best place for per-tool audit logging?*
   → `PostToolUse` hook, pass-through, log the redacted input and status.

---

### Key Takeaways
- ✅ Hooks for critical rules — **deterministic**.
- ✅ Prompts for style / preferences — probabilistic.
- ✅ `PreToolUse` blocks; `PostToolUse` modifies output.
- ✅ Exit 1 = block (stderr → Claude); exit 0 = allow.
- ✅ Escalate on objective criteria: explicit request, policy gap, capability, threshold.
- ❌ Never escalate on sentiment or self-reported confidence.
- ❌ Never put compliance rules in the system prompt.

Next → [`04-Session-Management.md`](04-Session-Management.md)
