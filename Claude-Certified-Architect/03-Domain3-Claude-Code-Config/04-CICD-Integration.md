# D3.4 — CI/CD Integration

> Scenario 5 (Claude Code for CI/CD) is entirely this page. Know the `-p` flag, structured output, and session isolation *cold*.

## 1. The `-p` Flag — Non-Interactive Mode

For CI, Claude Code must run **without user interaction**:

```bash
claude -p "Run a static analysis of this repo and output findings as JSON."
```

- `-p <prompt>` sends a prompt and exits after Claude completes.
- **Required in CI.** Interactive mode will block on prompts and fail the pipeline.
- **Exits with code 0** on success, non-zero on error.

## 2. Structured Output — `--output-format json`

The default output is human-readable text. In CI, you want machine-parseable output:

```bash
claude -p "$PROMPT" --output-format json
```

### Example output
```json
{
  "session_id": "sess_abc123",
  "started_at": "2026-04-17T10:00:00Z",
  "finished_at":"2026-04-17T10:00:45Z",
  "messages": [
    {"role": "user", "content": "..."},
    {"role": "assistant", "content": [{"type": "text", "text": "..."}]}
  ],
  "tool_calls": [...],
  "stop_reason": "end_turn",
  "usage": {"input_tokens": 1234, "output_tokens": 567}
}
```

Parseable with `jq`, Python, anything.

## 3. Enforcing Output Shape — `--json-schema`

The killer feature. You tell Claude exactly what the output must look like:

```bash
claude -p "$REVIEW_PROMPT" \
  --output-format json \
  --json-schema '{
    "type": "object",
    "properties": {
      "issues": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "file":        {"type": "string"},
            "line":        {"type": "integer"},
            "severity":    {"type": "string", "enum": ["critical","warning","info"]},
            "description": {"type": "string"}
          },
          "required": ["file","line","severity","description"]
        }
      }
    },
    "required": ["issues"]
  }'
```

Claude's output **will match** this schema. You can pipe it into a bug tracker, a PR comment bot, or a custom reporter without regex acrobatics.

## 4. Session Isolation for Generator vs. Reviewer

> **The most-tested rule in CI/CD**: the code generator and the code reviewer **must run in separate sessions**.

### Why
If the same session generates code and reviews it, the reviewer retains the generator's reasoning context. This creates **confirmation bias** — the reviewer mentally defends the code rather than critiquing it.

### ❌ Wrong
```bash
# Same session — BAD
claude -p "Write auth module"           # Session A
claude --resume -p "Review your code"   # SAME Session A
```

### ✅ Right
```bash
# Separate sessions — GOOD
claude -p "Write auth module"           # Session A
claude -p "Review this diff: $DIFF"     # Session B, fresh
```

The reviewer in Session B sees the code **cold**, with no preconceptions about why certain choices were made.

### Another framing
Think of it like pair programming: a fresh pair of eyes always catches more than the author reviewing their own work.

## 5. End-to-End GitHub Actions Example

```yaml
# .github/workflows/claude-review.yml
name: Claude Code Review

on: [pull_request]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with: { fetch-depth: 0 }

      - name: Get diff
        id: diff
        run: |
          echo "diff<<EOF" >> $GITHUB_OUTPUT
          git diff origin/main...HEAD >> $GITHUB_OUTPUT
          echo "EOF" >> $GITHUB_OUTPUT

      - name: Claude Review
        id: claude
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: |
          claude -p "Review this PR diff. Flag: (1) functions >50 LOC, (2) missing error handling on async ops, (3) hardcoded credentials, (4) missing tests for new functions. Output findings as JSON." \
            --output-format json \
            --json-schema '{"type":"object","properties":{"issues":{"type":"array","items":{"type":"object","properties":{"file":{"type":"string"},"line":{"type":"integer"},"severity":{"type":"string"},"description":{"type":"string"}}}}}}' \
            > review.json

      - name: Post as PR comment
        uses: actions/github-script@v7
        with:
          script: |
            const review = require('./review.json');
            const body = review.issues.length === 0
              ? "✅ Claude found no issues."
              : review.issues.map(i => `- **${i.severity}** \`${i.file}:${i.line}\` — ${i.description}`).join("\n");
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body
            });
```

This workflow:
1. Runs on every PR.
2. Gets the diff.
3. Runs a Claude review in a fresh session with JSON output.
4. Posts findings as a PR comment.

## 6. Secrets & API Keys

Standard CI/CD secrets hygiene applies:
- `ANTHROPIC_API_KEY` in GitHub Actions secrets (not in the YAML).
- Rotate keys quarterly.
- Scope with least privilege (use a service account key, not your personal).
- For MCP servers in CI, each token gets its own secret.

## 7. Failure Handling

If Claude's output doesn't match the schema (very rare), the command errors. In CI:

```bash
set -o pipefail
claude -p "..." --output-format json --json-schema '...' | jq . > review.json \
  || { echo "Claude review failed"; exit 1; }
```

Always pipe to `jq .` to validate the JSON is well-formed before downstream use.

## 8. Cost Considerations

- Every PR review is a tokenized API call.
- Monitor: most small-to-medium PRs run ≈ 10–30 k input tokens.
- For very large PRs, consider chunking by file or by domain.
- For non-urgent reviews (nightly audit), use the **Batch API** (50 % savings — see next topic).

## 9. Other CI/CD Use Cases

Beyond PR review, Claude Code is used in pipelines for:

| Use case | Notes |
|---|---|
| **Auto-generate release notes** | Diff the last two tags; output structured JSON |
| **Documentation drift check** | Compare code and docs; flag inconsistencies |
| **Test coverage gap analysis** | Identify files with no or low test coverage |
| **Spec-to-code compliance** | Given a spec and a commit, check coverage |
| **Changelog generation** | Categorize commits (feat/fix/docs) per Conventional Commits |
| **Merge-conflict resolver** | Resolve trivial conflicts; escalate complex ones |
| **Dependency bump reviewer** | Analyse breaking changes in changelogs |

## 10. Plan Mode in CI

Two workflows:

### Dry-run: generate a plan, post as PR comment
```bash
claude -p "Plan how you would refactor this module to use DI." \
  --plan \
  --output-format json > plan.json
# Post plan.json as a PR comment for review
```

### Approved plan: execute after human sign-off
```bash
# Stored plan.json already human-approved
claude -p "$(cat plan.json | jq .plan)" --apply
```

Plan mode in CI lets you gate execution behind human approval.

## 11. Anti-Patterns in CI/CD

| Anti-pattern | Why wrong |
|---|---|
| Same session generator + reviewer | Confirmation bias |
| Missing `-p` | Interactive mode blocks CI |
| Parsing unstructured text output | Fragile regex; prefer `--json-schema` |
| Hardcoded API key in workflow YAML | Leaked on every commit |
| No error handling on Claude command | CI gets silent passes |
| Blocking PR review via synchronous request when the queue is 500+ PRs/day | Use Batch API instead |

## 12. Exam Self-Check

1. *Required flag for running Claude Code in CI?*
   → `-p` (non-interactive).
2. *Why is same-session generator + reviewer wrong?*
   → Confirmation bias — reviewer retains generator's reasoning.
3. *How do you guarantee parseable output from a CI Claude run?*
   → `--output-format json` + `--json-schema '...'`.
4. *Where should `ANTHROPIC_API_KEY` live in GitHub Actions?*
   → Encrypted repo secret; referenced via `${{ secrets.ANTHROPIC_API_KEY }}`.

---

### Key Takeaways
- ✅ `-p` for non-interactive CI runs.
- ✅ `--output-format json` + `--json-schema` for parseable output.
- ✅ **Separate sessions** for code generation and code review.
- ✅ Store API keys in CI secrets; never hardcode.
- ❌ Never same-session self-review.
- ❌ Never parse free-form text with regex when a schema is available.

Next → [`05-Batch-Processing.md`](05-Batch-Processing.md)
