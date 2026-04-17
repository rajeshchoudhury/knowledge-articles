# D3.3 — Plan Mode & Iterative Refinement

> Plan mode is the architectural thinking lane. Use it for complex work. Skip it for trivial work. Mis-applying either direction is an exam-tested anti-pattern.

## 1. What Plan Mode Is

**Plan mode** tells Claude to **think and outline an approach before executing**. Instead of jumping straight into tool calls and edits, Claude:
1. Reads relevant context.
2. Writes out a **step-by-step plan**.
3. Presents the plan for review.
4. Only then executes (usually after you approve or tweak the plan).

Plan mode is a **meta-prompt**, not a separate API mode. Under the hood, it wires in instructions like "Before acting, produce a plan. Wait for approval or critique before executing."

## 2. When to Use Plan Mode

### ✅ Use plan mode when…
- The task touches **many files** (≥ 3) or components.
- The **approach is ambiguous** (multiple valid ways).
- Mistakes are **expensive to undo** (migrations, schema changes).
- It's a **new feature** requiring design choices.
- You need stakeholder review before execution.

### ❌ Skip plan mode when…
- The task is **trivial and well-scoped** (fix a typo, add a log line).
- You've done this change 20 times before.
- Speed matters and the risk is low.
- You want Claude to "just do it."

### Exam phrasing
The exam gives you a scenario like:
> "A junior engineer is asked to fix a typo in line 42 of `server.ts`. Should Claude use plan mode?"
> **No.** Plan mode is overhead for trivial work.

Or:
> "Claude is asked to migrate a database from MongoDB to Postgres. Should it use plan mode?"
> **Yes.** Architectural changes need a plan.

## 3. The Three Canonical Iteration Patterns

Once execution starts, there are three canonical ways to iterate toward the right output.

### 3.1 Concrete-Example Pattern
Give Claude a concrete example of what you want:
```
Here's what I want my function to look like:

```ts
export function toSlug(s: string): string {
  return s.toLowerCase()
          .replace(/[^a-z0-9]+/g, '-')
          .replace(/^-+|-+$/g, '');
}
```

Now implement `toSnakeCase` following the same style.
```
Use when: style/format consistency is the goal. Works best for transformations, formatters, and small utilities.

### 3.2 TDD Iteration Pattern
The **gold standard** for refinement. Tests define the target; implementation converges.

```
Step 1: Write a test for getUserById that:
  - Returns {id, name, email} when the user exists
  - Throws NotFoundError when the user doesn't exist
  - Validates that id is a positive integer
Step 2: Run the test (it should fail).
Step 3: Implement getUserById.
Step 4: Run the tests (they should pass).
Step 5: Refine for style, keeping tests green.
```

Benefits:
- Claude has a **concrete, verifiable goal** at every step.
- Prevents drift and scope-creep.
- Produces self-documenting code (tests ARE the spec).
- Catches regressions from refactors immediately.

### 3.3 Interview Pattern
Ask Claude to **ask you questions** before starting:

```
Before you start, ask me three questions about this feature.
```

Use when:
- Requirements are fuzzy.
- You don't know the full scope yet.
- You want Claude to surface assumptions before building on them.

## 4. Plan Mode vs Direct Execution — Decision Table

| Signal | Plan mode | Direct |
|---|---|---|
| Multiple files affected | ✅ | |
| Ambiguous requirements | ✅ | |
| Irreversible changes (migrations) | ✅ | |
| New architecture | ✅ | |
| Typo fix | | ✅ |
| Add a log line | | ✅ |
| Bump version in package.json | | ✅ |
| Add a missing test case | | ✅ (often) |

## 5. Plan Mode + Skills — a Powerful Combo

Inside a skill's `SKILL.md`, you can embed plan-mode instructions:

```markdown
# Refactoring Skill

## Approach
1. **Plan** — output a step-by-step refactoring plan (do NOT edit yet).
2. **Pause** — stop and wait for confirmation.
3. **Apply** — only after confirmation, execute the plan.
4. **Verify** — run tests after each step.
```

This turns every `refactor` invocation into a plan-gated workflow by default.

## 6. Iterating on Claude's Plan

A well-produced plan is usually ~80 % right. Improve it by:

1. **Pointing out missing steps.** "You didn't include 'update the README'."
2. **Correcting tool choices.** "Use Edit, not Write — the file already exists."
3. **Tightening scope.** "Scope this to `src/api/` only; ignore `src/ui/`."
4. **Adding constraints.** "All migrations must be backwards-compatible."

Then: "Apply the revised plan."

## 7. The Antithesis — "Vague Iteration"

A common mistake: iterating without explicit criteria.

### ❌ Bad iteration
- User: "Implement feature X."
- Claude: [implements]
- User: "Make it better."
- Claude: [rewrites differently]
- User: "Still not quite right…"

Without measurable criteria, every iteration is a coin flip.

### ✅ Good iteration
- User: "Implement feature X. Acceptance: all tests in `feature-x.test.ts` pass."
- Claude: [implements]
- User: "Run the tests."
- Claude: [runs; 5/7 pass]
- User: "Fix the 2 failing tests. Keep the others green."
- Claude: [fixes, verifies]

## 8. Plan-Mode Failure Modes

| Failure mode | Symptom | Fix |
|---|---|---|
| **Plan without verification** | Plan looks great; execution drifts | Insert "after each step, run the tests" |
| **Over-planning** | 50-bullet plan for a 3-line change | Skip plan mode for trivial work |
| **Under-planning** | "Here's my plan: do the thing." | Demand concrete steps + verification |
| **Unbounded scope** | Plan touches 30 files | Tighten the task statement first |

## 9. Plan Mode in CI/CD

In CI, plan mode usually runs **non-interactively**:
```bash
claude -p "$PROMPT" \
  --plan \
  --output-format json
```
The `--plan` flag returns the plan without executing. Use this to:
- Review planned changes before running them.
- Store plans in PRs for audit.
- Combine with human-in-the-loop approval gates.

## 10. Anti-Patterns Summary

| Anti-pattern | Why wrong |
|---|---|
| Always using plan mode | Wasteful for trivial tasks |
| Never using plan mode | Risky for complex changes |
| Vague iteration instructions ("make it better") | No convergence |
| Skipping verification steps | Plans drift at execution time |

## 11. Exam Self-Check

1. *Junior asks to fix a typo in one file. Plan mode?*
   → No — trivial work.
2. *Migrating a 5-microservice backend to a new auth system. Plan mode?*
   → Yes — high-impact, architectural.
3. *Best iteration pattern for a formatter function?*
   → Concrete-example pattern.
4. *Best iteration pattern for a new API endpoint with unclear requirements?*
   → TDD iteration (tests define the goal) **or** interview pattern first to clarify.
5. *Claude's plan is missing a "run tests" step. What do you do?*
   → Tell Claude to revise the plan to include verification, then proceed.

---

### Key Takeaways
- ✅ Plan mode for complex, ambiguous, or irreversible changes.
- ✅ Direct execution for trivial, well-scoped changes.
- ✅ TDD iteration is the strongest refinement pattern.
- ✅ Concrete examples teach style.
- ✅ Interview pattern clarifies fuzzy requirements before building.
- ❌ Don't use plan mode for typos.
- ❌ Don't iterate vaguely — always include measurable criteria.

Next → [`04-CICD-Integration.md`](04-CICD-Integration.md)
