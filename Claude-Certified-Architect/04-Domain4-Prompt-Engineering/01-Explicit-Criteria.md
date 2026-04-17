# D4.1 — Explicit Criteria & Instruction Design

> "Be thorough" is a prompt anti-pattern. Every production Claude system must use **measurable, objective criteria**. Learn to spot vague distractors instantly.

## 1. Why Vagueness Kills Production Systems

Imagine two teams shipping Claude-powered PR review bots.

- **Team A's prompt**: "Review this PR for bugs, style issues, and anything else suspicious."
- **Team B's prompt**: "Review this PR. Flag (1) functions > 50 LOC, (2) async calls without try/catch, (3) strings matching `sk-`, `pk-`, `key-`, (4) public functions without JSDoc. Output JSON with file, line, severity, description."

A month later:

- **Team A**: 40 findings per PR. Devs ignore them. Alert fatigue. Eventually, the bot gets turned off.
- **Team B**: 2–3 actionable findings per PR. Devs trust them. The bot becomes part of the workflow.

Same model. Same repo. Different prompts. Completely different outcomes.

## 2. The False-Positive Problem

Vague prompts produce **too many false positives**. This is one of the most heavily tested exam ideas. Mechanics:

1. Vague criteria → model over-flags edge cases.
2. Over-flagging → developers see "CI review = noise."
3. Noise → real issues are ignored along with the fakes.
4. Tool loses trust → gets silenced / disabled.

The economic cost: every false positive costs developer attention. Cross a threshold and the tool is net-negative.

## 3. The Explicit-Criteria Rulebook

Every production prompt's instructions should follow these rules:

### 3.1 Make criteria measurable
- ❌ "Flag long functions."
- ✅ "Flag functions exceeding 50 lines of code (excluding comments and blank lines)."

### 3.2 Specify the output shape
- ❌ "Output your findings."
- ✅ "For each finding: `{file:string, line:int, severity:'critical'|'warning'|'info', description:string, suggested_fix:string}`."

### 3.3 Bound the scope
- ❌ "Review everything you can."
- ✅ "Review ONLY changes in this diff. Do not flag code outside the diff."

### 3.4 Prioritize categories
- ❌ "Note security issues."
- ✅ "Categories in priority order: (1) hardcoded credentials, (2) SQL injection, (3) missing input validation. Do not flag issues outside these categories."

### 3.5 Include severity rubrics
- ❌ "Mark severity."
- ✅ "Severity: critical = exposes secrets or allows injection; warning = correctness risk; info = style."

### 3.6 Name the anti-examples
- ❌ (implicit)
- ✅ "Do NOT flag: intentionally-long pure functions, string constants used as error codes, console.log in test files."

## 4. Template — the Explicit-Criteria Prompt

```
Role: You are a senior code reviewer.

Task: Review the diff below and flag issues.

Criteria (flag ONLY these):
1. Functions exceeding 50 lines of code (LOC excludes comments/blank lines)
2. Async operations missing try/catch or .catch() error handling
3. Hardcoded strings matching ^(sk-|pk-|key-|token-)
4. Public functions missing JSDoc

Severity rubric:
- critical: (3) hardcoded secrets
- warning:  (1), (2)
- info:     (4)

Output format: JSON array, each element:
  {"file":"...", "line":N, "rule":1|2|3|4, "severity":"...", "description":"...", "fix":"..."}

Scope: ONLY the diff. Do NOT flag code outside the diff.

Anti-examples (do NOT flag):
- Long pure functions intentionally structured that way (comment includes "/* intentionally long */")
- console.log in files under `tests/`
- Missing JSDoc on private functions

Diff:
{DIFF}
```

This is ~300 tokens — compact, deterministic, testable.

## 5. Measurable vs. Unmeasurable

| ❌ Unmeasurable | ✅ Measurable |
|---|---|
| "be thorough" | "flag exactly the 5 categories below" |
| "improve code quality" | "reduce cyclomatic complexity below 10" |
| "write clean code" | "each function ≤ 20 lines, ≤ 4 parameters" |
| "add good tests" | "cover at least 1 happy path + 2 failure modes per function" |
| "write detailed docs" | "each public function: 1-line summary + `@param`/`@returns` lines" |
| "make it more modular" | "split any file > 300 lines into feature-named modules ≤ 150 lines each" |

You can audit measurable criteria programmatically. You cannot audit "be thorough."

## 6. Rubrics — Adding Rigor

A **rubric** is an explicit scoring system. For structured review tasks:

```
Rubric:
- Clarity (0-3):    0 = unreadable, 3 = self-explanatory
- Correctness (0-3): 0 = broken, 3 = proven correct
- Coverage (0-3):   0 = untested, 3 = all paths covered
- Simplicity (0-3): 0 = over-engineered, 3 = minimal

For each dimension, cite specific evidence from the code.
```

Adding a rubric pushes Claude from opinion to argument.

## 7. Worked Examples

### 7.1 Customer-support intent classifier

❌ Bad
```
Classify the customer's message into a category.
```

✅ Good
```
Classify the customer's message into EXACTLY ONE of:
- billing_question       — questions about charges, invoices, payments
- shipping_inquiry       — questions about delivery, tracking, returns
- product_support        — usage, setup, how-to
- complaint              — explicit dissatisfaction about something specific
- other

If the message mixes two categories, pick the PRIMARY one (the action the customer most wants resolved first).

Output JSON: { "category": "...", "primary_action_needed": "...", "confidence": "high|medium|low" }
```

### 7.2 Invoice field extractor

❌ Bad
```
Extract the invoice data.
```

✅ Good
```
Extract the following fields from the invoice:
- vendor_name       (string, the entity issuing the invoice)
- invoice_number    (string, usually top-right, may contain letters and digits)
- issue_date        (ISO 8601 date, YYYY-MM-DD)
- total_amount      (number, in base currency units)
- currency          (3-letter ISO-4217 code)
- line_items        (array of {description, quantity, unit_price, subtotal})

If a field is missing: use null (not an empty string).
If the currency isn't stated: use "USD" and set `currency_inferred: true`.
```

## 8. Measuring False-Positive Rate

For any production prompt, track:

- **True positives** (TP) — real issues flagged correctly.
- **False positives** (FP) — noise flagged as issues.
- **False negatives** (FN) — real issues missed.

Report **precision** = TP / (TP + FP) and **recall** = TP / (TP + FN).

If precision < 80 %, tighten criteria. If recall < 80 %, loosen or add criteria.

## 9. Anti-Patterns

| Anti-pattern | Why wrong |
|---|---|
| "Be thorough" / "find all issues" | Unbounded scope → alert fatigue |
| No severity rubric | All findings look equal; can't triage |
| Vague output format | Unparseable; breaks downstream automation |
| No anti-examples | Over-flags edge cases you explicitly don't care about |
| Criteria named but not bounded | "Flag hardcoded secrets" without patterns → too many false positives |

## 10. Exam Self-Check

1. *A code-review bot produces 40 findings per PR, mostly irrelevant. Root cause?*
   → Vague criteria → alert fatigue → false positives.
2. *Compare two prompts: "Be thorough" vs. "Flag functions > 50 LOC, async without try/catch, hardcoded sk-/pk-/key- strings." Which is correct?*
   → The explicit, measurable one.
3. *A production prompt has no anti-examples. What risk does this introduce?*
   → Over-flagging intentional patterns (e.g., `console.log` in tests).

---

### Key Takeaways
- ✅ Criteria must be measurable and bounded.
- ✅ Specify output format precisely.
- ✅ Include severity rubrics.
- ✅ Name anti-examples to suppress false positives.
- ❌ Never use "be thorough" / "find issues" / "make it better."
- ❌ Never ship a prompt you can't measure precision on.

Next → [`02-Few-Shot-Prompting.md`](02-Few-Shot-Prompting.md)
