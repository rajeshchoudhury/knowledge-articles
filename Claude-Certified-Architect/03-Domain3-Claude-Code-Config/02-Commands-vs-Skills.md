# D3.2 — Commands vs. Skills

> The exam tests the commands-vs-skills distinction the same way it tests Write-vs-Edit: by asking which one applies when context isolation or tool restriction matters.

## 1. Two Extension Mechanisms

Claude Code has two ways to package reusable behavior:

| | **Commands** | **Skills** |
|---|---|---|
| Folder | `.claude/commands/` | `.claude/skills/` |
| File | One `.md` per command | `SKILL.md` + optional assets |
| Invocation | Slash command: `/review` | Skill is auto-discovered and used when relevant, or invoked by name |
| Context | **Runs in the current session** | **Can fork into an isolated context** |
| Tool restriction | ❌ Not built-in | ✅ `allowed-tools` frontmatter |
| Best for | Quick one-step actions | Complex multi-step, isolation-critical work |

## 2. When to Pick Which

**Use a command when:**
- The operation is simple (one or two tool calls).
- No isolation is needed — it's fine for exploration noise to stay in the main session.
- You just want a shortcut.

**Use a skill when:**
- The operation is complex (many tool calls, exploration).
- You need **context isolation** (don't pollute the main session).
- You need **tool restriction** (lock down to read-only, etc.).
- You want **reusable behaviors** shipped with assets (prompts, diagrams, templates).

### Examples

| Task | Pick |
|---|---|
| `/lint` — run linter and summarize | Command |
| `/deploy` — run `npm run deploy` | Command |
| `/status` — git status + branch info | Command |
| Refactor a module to use dependency injection | **Skill** (explore, plan, apply, verify — isolation helps) |
| Audit the codebase for unused exports | **Skill** (verbose exploration, restricted tool access) |
| Generate API docs from JSDoc comments | **Skill** (multi-file output, consistent template) |

## 3. Creating a Command

A command lives at `.claude/commands/<name>.md`:

```markdown
# .claude/commands/review.md

Review the current git diff for:
1. Functions over 50 lines
2. Missing error handling on async operations
3. Hardcoded strings matching API-key patterns (sk-, pk-, key-)
4. Public functions missing JSDoc

Output findings as a Markdown table with columns:
| File | Line | Issue | Severity | Fix |
```

Usage:
```
/review
```

The command's markdown is pasted into Claude's context as if the user wrote it.

## 4. Creating a Skill — SKILL.md Frontmatter

A skill lives at `.claude/skills/<name>/SKILL.md`, with optional sibling assets:

```markdown
---
context: fork
allowed-tools:
  - Read
  - Edit
  - Grep
argument-hint: "file or directory to refactor"
---

# Refactoring Skill

When asked to refactor code, follow these steps:

1. **Analyze** — use Read and Grep to understand structure.
2. **Identify** patterns that violate SOLID.
3. **Plan** — write out the refactoring approach before applying.
4. **Apply** incrementally with Edit (never Write — keep existing files).
5. **Verify** each change preserves existing behavior.

## Rules
- Never delete existing tests.
- Preserve all public API signatures.
- Add JSDoc comments to refactored public functions.
- If any step is unclear, stop and ask.
```

### Frontmatter fields

| Field | Meaning |
|---|---|
| `context: fork` | Run in an isolated sub-session. Exploration and tool calls stay in the fork. |
| `allowed-tools` | Restricted tool list — skill can use only these. |
| `argument-hint` | UI hint describing the expected invocation argument. |
| `description` | (optional) Human-readable skill summary |
| `triggers` | (optional) Conditions under which Claude should auto-apply the skill |

## 5. The Forked Context — Why It Matters

`context: fork` is the feature that makes skills dramatically more useful than commands for complex work. The fork:

- **Inherits** the parent session's context at the point of invocation.
- **Isolates** all subsequent reasoning and tool calls.
- **Returns** only the skill's final output to the parent session.

Consequences:
- The main session stays focused — no 200 tool calls polluting it.
- Skills can do exploratory work (inspect 50 files) without bloating the parent.
- A skill's errors don't crash the main session.

## 6. `allowed-tools` — Least Privilege for Skills

A skill that refactors code should not be able to:
- Run `Bash` (could execute arbitrary commands)
- `Write` new files (could overwrite unexpected paths)
- Access MCP servers (could hit external services)

Lock it down:
```yaml
---
context: fork
allowed-tools: [Read, Edit, Grep]
---
```

Now the skill *physically cannot* go beyond read/edit/grep. This is **enforced at the SDK level**, not just suggested.

## 7. Common Skill Templates

### 7.1 Refactor
```yaml
context: fork
allowed-tools: [Read, Edit, Grep]
argument-hint: "file or directory"
```

### 7.2 Audit (read-only)
```yaml
context: fork
allowed-tools: [Read, Grep, Glob]
argument-hint: "what to audit (e.g., 'unused exports', 'TODO comments')"
```

### 7.3 Test-Writer
```yaml
context: fork
allowed-tools: [Read, Write, Edit, Bash]
argument-hint: "function or module to test"
```

### 7.4 Migrate
```yaml
context: fork
allowed-tools: [Read, Write, Edit, Bash, Grep, Glob]
argument-hint: "migration spec"
```

## 8. Command + Skill Combos

You can combine them:
- A **command** `/start-refactor` that invokes the **skill** `refactor`:
```markdown
# .claude/commands/start-refactor.md
Use the `refactor` skill to refactor the argument passed to this command.
```

This gives a user-friendly entry point (`/start-refactor foo/bar.ts`) backed by a strictly-scoped skill.

## 9. Common Anti-Patterns

| Anti-pattern | Why wrong |
|---|---|
| Using a command for a complex, multi-step exploration | Pollutes main session; no tool restrictions |
| Skill without `allowed-tools` | Wide-open permissions; one mistake = disaster |
| Skill without `context: fork` | Defeats the isolation benefit |
| Over-engineering a simple `/lint` as a skill | Too heavy; a command is enough |
| Two skills with overlapping responsibilities | Claude gets confused about which to invoke |

## 10. Discoverability

Claude Code auto-discovers:
- Commands in `.claude/commands/` → invokable as `/command-name`.
- Skills in `.claude/skills/` → used when relevant, invokable explicitly.

Best practice: put a short index in `CLAUDE.md`:
```markdown
## Commands
- `/review` — review the git diff
- `/deploy` — push to staging
- `/lint` — lint + format

## Skills
- `refactor` — multi-step DI refactor (forked context, read/edit/grep only)
- `audit` — read-only codebase audit
```

## 11. Versioning & Team Collaboration

- Commit `.claude/commands/` and `.claude/skills/` to git.
- Treat them as first-class code: reviews, PRs, tests.
- Keep commands small (≤ 30 lines). Anything longer → promote to a skill.

## 12. Exam Self-Check

1. *A task requires 50+ tool calls of exploration and should NOT pollute the main session. Command or skill?*
   → **Skill**, with `context: fork`.
2. *A read-only audit skill — what `allowed-tools` should it have?*
   → `[Read, Grep, Glob]` — no writes, no Bash.
3. *A simple `/status` that shows git branch and last commit — command or skill?*
   → **Command** — it's simple and doesn't need isolation.
4. *You see a skill without `allowed-tools`. Issue?*
   → Permissive — any tool is usable. Always scope.

---

### Key Takeaways
- ✅ Commands for quick, single-step actions.
- ✅ Skills for complex, multi-step work that needs isolation.
- ✅ `context: fork` for isolated skill execution.
- ✅ `allowed-tools` to restrict skill capabilities.
- ❌ Don't use a command for a 50-tool-call refactor.
- ❌ Don't ship a skill without `allowed-tools`.

Next → [`03-Plan-Mode-Iteration.md`](03-Plan-Mode-Iteration.md)
