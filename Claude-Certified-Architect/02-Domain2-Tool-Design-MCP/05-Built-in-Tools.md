# D2.5 — Built-in Tools (Read, Write, Edit, Bash, Grep, Glob)

> Claude Code ships with **six built-in tools**. Know when to use each — and especially when NOT to use `Bash` as a crutch. Scenario 4 tests this hard.

## 1. The Six Tools At a Glance

| Tool | Purpose |
|---|---|
| **Read** | Read the contents of a file |
| **Write** | Create a **new** file (overwrites entire file!) |
| **Edit** | Modify an existing file with targeted changes |
| **Bash** | Run shell commands |
| **Grep** | Search for **text patterns inside files** |
| **Glob** | Find **file paths matching a pattern** |

Memorize these six. They appear on multiple questions per exam.

## 2. Write vs Edit — the Most Tested Distinction

### The rule
- **Write** = new file. Replaces the ENTIRE file if it already exists.
- **Edit** = targeted change to an existing file. Preserves everything else.

### Why it matters
If you use `Write` to make one small change in a 500-line file, the other 499 lines must be in your content. Miss any? You silently delete them.

### ❌ Anti-pattern
```
Task: "Fix the typo in line 42 of server.ts"
Agent uses: Write("server.ts", <some content you hope is right>)
Result: rest of the file possibly gone.
```

### ✅ Correct
```
Task: "Fix the typo in line 42 of server.ts"
Agent uses: Edit("server.ts", "heelo world", "hello world")
Result: only the typo is changed.
```

### Edit's API (simplified)
- `old_string`: exact text to replace (must be unique in the file, or use `replace_all=true`).
- `new_string`: replacement.
- `replace_all`: boolean — apply to every occurrence?

For renames across a file ("rename `getCwd` to `getCurrentWorkingDirectory`"), use `replace_all: true`.

## 3. Bash — The "Last Resort" Tool

`Bash` runs arbitrary shell commands. It's powerful and tempting — and that's why it's dangerous.

### Rule: never use `Bash` when a dedicated tool exists.

| Task | Wrong (uses Bash) | Right (uses built-in) |
|---|---|---|
| Read a config file | `Bash("cat config.json")` | `Read("config.json")` |
| Write a new test | `Bash("echo '...' > tests/new.ts")` | `Write("tests/new.ts", content)` |
| Modify a file | `Bash("sed -i 's/a/b/' file.ts")` | `Edit("file.ts", "a", "b")` |
| Find files by name | `Bash("find . -name '*.test.ts'")` | `Glob("**/*.test.ts")` |
| Search content in files | `Bash("grep -r 'TODO' src/")` | `Grep("TODO", path="src/")` |
| Run tests | `Bash("npm test")` | `Bash("npm test")` ✅ (no alternative) |
| Build project | `Bash("make build")` | `Bash("make build")` ✅ |
| Install a package | `Bash("npm install lodash")` | `Bash("npm install lodash")` ✅ |

When a built-in exists, it's better because:
- It returns **structured output** (text, with metadata).
- It doesn't risk shell-injection bugs.
- It's **faster** (no process spawn).
- It's **auditable** (hooks can match on tool name).
- It's **sandboxable** via `allowed-tools`.

Use `Bash` for things that are **genuinely shell-native**: running tests, building, installing deps, git operations, service checks (`curl`, `ping`).

## 4. Grep vs Glob — the Second Most Tested Distinction

| | Grep | Glob |
|---|---|---|
| Searches | **Inside** files (content) | File **paths** (names) |
| Pattern | Regex against file *content* | Glob against file *paths* |
| Example | `Grep("TODO", path="src/")` — find "TODO" comments | `Glob("**/*.test.ts")` — find all test files |
| Returns | Matching lines (with path/line number) | List of file paths |

### Common confusion
- "Find all test files" → **Glob** (you want file paths).
- "Find all files that contain `console.log`" → **Grep** (you're searching contents).
- "Find all `*.tsx` files that mention `useState`" → **combine**: Glob first, then Grep the results.

## 5. Read — What to Know

- Can read any text file.
- Supports optional `offset` and `limit` for long files.
- Lines are numbered in output (for easy line references).
- For PDFs, text is extracted automatically.
- For images, the file is attached as-is (if the model supports vision).

Best practice: **read whole files** by default; use `offset`/`limit` only for very large files.

## 6. Common Workflow Patterns

### Pattern 1 — find then read
```
1. Glob("**/*.config.*")            → list of config files
2. For each path: Read(path)         → inspect contents
```

### Pattern 2 — find then edit
```
1. Grep("deprecatedFunc", path="src/")  → find call sites
2. For each: Edit(path, "deprecatedFunc(", "newFunc(")
```

### Pattern 3 — generate then verify
```
1. Write("src/feature.ts", new_code)    → create file
2. Bash("npm run test -- feature.test.ts")  → verify
```

### Pattern 4 — scoped rename
```
1. Glob("src/**/*.ts")
2. For each: Edit(path, "oldName", "newName", replace_all=true)
3. Bash("npm run type-check")
```

## 7. Tool Selection — Quick Decision Rules

1. **Modify existing file?** → `Edit`.
2. **Create new file?** → `Write`.
3. **Inspect a file's contents?** → `Read`.
4. **Find files by name/path?** → `Glob`.
5. **Search for text across files?** → `Grep`.
6. **Run build/test/install/git?** → `Bash`.
7. **Anything file-related not in the list above?** → It's probably one of Read/Write/Edit.

## 8. Tool Restrictions via `allowed-tools`

Skills and project configs can restrict which built-in tools are available:

```yaml
# .claude/skills/refactor/SKILL.md
---
context: fork
allowed-tools: [Read, Edit, Grep]    # NO Write, NO Bash, NO Glob
---
```

A refactor skill doesn't need to create new files or execute shell commands. Locking it down prevents accidental damage.

### Typical allowed-tool sets

| Skill | Allowed tools |
|---|---|
| `refactor` | `Read`, `Edit`, `Grep` |
| `migrate-db` | `Read`, `Write`, `Edit`, `Bash` |
| `audit` | `Read`, `Grep`, `Glob` (no write!) |
| `test-writer` | `Read`, `Write`, `Edit`, `Bash` |

## 9. Edge Cases & Gotchas

### 9.1 `Write` on an existing file silently overwrites
Claude does not warn. The file is gone. Always `Read` → compare → `Edit` for existing files.

### 9.2 `Edit` requires unique `old_string`
If the old_string appears multiple times and `replace_all` is false, the call fails. Provide more context in the `old_string` (surrounding lines) to make it unique, or use `replace_all=true`.

### 9.3 `Grep` regex dialect
`Grep` uses ripgrep (modern regex). Don't assume grep-1970 syntax — `\d`, `\w`, `(?:…)` all work; literal braces need escaping.

### 9.4 `Glob` patterns are greedy
- `*.ts` → matches `foo.ts` but not `src/foo.ts` (unless the tool auto-prepends `**/`)
- `**/*.ts` → recursive, matches anywhere

### 9.5 `Bash` and working directory
Commands run in a stateful shell; `cd` persists. Prefer running commands with absolute paths or `working_directory` params to avoid accidents.

## 10. Exam Self-Check

1. *Task: "Fix the typo in one function in utils.ts." Right tool?*
   → `Edit` (targeted change).
2. *Task: "Create tests/new.spec.ts." Right tool?*
   → `Write` (new file).
3. *Task: "Find every file with the extension `.proto`." Right tool?*
   → `Glob("**/*.proto")`.
4. *Task: "Find every file containing the string `password =`." Right tool?*
   → `Grep("password\\s*=")`.
5. *Task: "Run tests." Right tool?*
   → `Bash("npm test")` (no built-in alternative).
6. *Claude writes `Bash("cat config.json")`. What's the issue?*
   → Anti-pattern — should be `Read("config.json")`. `Bash` should never replace a built-in.

---

### Key Takeaways
- ✅ `Write` for new files; `Edit` for existing files.
- ✅ `Grep` for content; `Glob` for paths.
- ✅ `Bash` only when no built-in applies.
- ✅ Use `allowed-tools` in skills to enforce least privilege.
- ❌ Don't use `Write` to modify existing files (destroys content).
- ❌ Don't use `Bash` as a crutch when a built-in exists.

→ You have now finished Domain 2. Continue to [`../03-Domain3-Claude-Code-Config/01-CLAUDE-md-Hierarchy.md`](../03-Domain3-Claude-Code-Config/01-CLAUDE-md-Hierarchy.md).
