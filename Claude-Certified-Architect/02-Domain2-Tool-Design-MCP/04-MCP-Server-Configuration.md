# D2.4 — MCP Server Configuration

> Model Context Protocol (MCP) is Anthropic's **open standard** for connecting AI assistants to external tools and data. The exam tests your ability to configure, secure, and scope MCP servers correctly.

## 1. MCP in One Paragraph

MCP is a **USB-C for AI**: a uniform way for a model to plug into any external system — databases, SaaS tools, code hosts, ticketing systems. An MCP **server** exposes tools (functions Claude can call), resources (data Claude can read), and prompts (templates) over a standardized protocol. An MCP **client** (Claude Desktop, Claude Code, or your own Agent SDK app) discovers the server's capabilities and integrates them into Claude's available toolset.

Three things to remember:
- **Tools** — function invocations Claude can request (e.g., `query_database`, `create_github_issue`).
- **Resources** — read-only data Claude can pull (e.g., database schemas, API docs).
- **Prompts** — pre-written prompt templates shipped by the server.

## 2. Configuration Layers — Project vs User

| File | Scope | Shared with team? | Use for |
|---|---|---|---|
| `.mcp.json` at project root | Project-level | ✅ Yes (commit to git) | Team-wide tools: DB, GitHub, Jira, project-specific APIs |
| `~/.claude.json` (or `~/.claude/settings.json`) | User-level | ❌ No (personal) | Personal tools: web search, personal notes, your own experiments |

**Exam rule**: Team-wide MCP integrations always go in `.mcp.json`. Personal-only MCPs always go in `~/.claude.json`. Mixing them up is an anti-pattern (§5).

## 3. The Canonical `.mcp.json` Shape

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args":    ["-y", "@modelcontextprotocol/server-github"],
      "env":     { "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}" }
    },
    "postgres": {
      "command": "npx",
      "args":    ["-y", "@modelcontextprotocol/server-postgres", "--read-only"],
      "env":     { "POSTGRES_URL": "${DATABASE_URL}" }
    },
    "slack": {
      "command": "npx",
      "args":    ["-y", "@modelcontextprotocol/server-slack"],
      "env":     { "SLACK_BOT_TOKEN": "${SLACK_BOT_TOKEN}" }
    }
  }
}
```

### Fields

| Field | Purpose |
|---|---|
| `command` | How to launch the server (`npx`, `uvx`, `node`, `python`, `docker`, `bash`) |
| `args` | CLI args |
| `env` | Environment variables — **always use `${VAR}` substitution** |

## 4. Secret Management — the Hard Rule

> **NEVER HARDCODE SECRETS IN `.mcp.json`.**

The file is committed to the repo. Hardcoded secrets = leaked secrets. This is a direct exam anti-pattern.

### ❌ Wrong
```json
{ "env": { "JIRA_TOKEN": "jira-abc123actualsecret" } }
```

### ✅ Right
```json
{ "env": { "JIRA_TOKEN": "${JIRA_TOKEN}" } }
```

Then set `JIRA_TOKEN` in your shell profile, your CI secrets, or your `.env` file (which is in `.gitignore`).

## 5. Project vs User — Don't Mix Them

Anti-patterns:
- Personal web-search MCP in `.mcp.json` → other team members don't need your Brave Search API key.
- Team's database MCP in `~/.claude.json` → teammates who clone the repo can't run it.

Rule of thumb:
- **Would my colleagues need this tool to work on this repo?** → `.mcp.json`.
- **Is this tied to my personal account or preference?** → `~/.claude.json`.

## 6. Common MCP Servers (know the Top 10)

The exam may reference specific servers by name. Know what each provides.

### Essentials
1. **GitHub** — `@modelcontextprotocol/server-github` — issues, PRs, code, repos.
2. **Postgres** — `@modelcontextprotocol/server-postgres` — schema inspection + parameterized queries.
3. **Filesystem** — `@modelcontextprotocol/server-filesystem` — scoped access to directories outside the project.

### Productivity
4. **Slack** — message posting, channel reads.
5. **Linear** — issue/project management.
6. **Notion** — docs, databases.
7. **Figma** — design read access.

### Infrastructure
8. **AWS** — resource inspection.
9. **Kubernetes** — pod logs, cluster state.
10. **Docker** — container control.

### Data
11. **MongoDB**, **Redis**, **Supabase**, **BigQuery**, **Snowflake**

### Search
12. **Brave Search**, **Exa**, **Context7**

## 7. Scoping & Permissions

MCP servers often take CLI args that scope their access:

```json
"postgres": {
  "command": "npx",
  "args":    ["-y", "@modelcontextprotocol/server-postgres", "--read-only"],
  "env":     { "POSTGRES_URL": "${DATABASE_URL}" }
}
```

The `--read-only` flag prevents Claude from running `INSERT`, `UPDATE`, `DELETE`. Always scope downward.

### Scoping principles
- **Read-only first.** Write access only when necessary.
- **Least privilege.** GitHub token with `repo` scope, not `admin:org`.
- **Dedicated service accounts.** Not your personal token.
- **Separate prod from dev.** Use dev/staging DSNs during development.

## 8. Running Servers via Docker

Some MCP servers have complex dependencies; Docker keeps your local environment clean:

```json
"playwright": {
  "command": "docker",
  "args":    ["run", "-i", "--rm", "mcr.microsoft.com/playwright/mcp"]
}
```

Pros: isolation, reproducibility. Cons: higher startup latency, more moving parts.

## 9. Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| `Server not found` | Package name typo, not installed | Run `npx -y <pkg>` manually |
| `Permission denied` | Token scope too narrow | Widen the scope or use a different token |
| Server starts, tools don't appear | `.mcp.json` changes need a restart | Restart Claude Code |
| Slow startup | `npx` downloading on first run | `npm install -g <pkg>` then use direct command |
| Tool returns `isError: true` | Access failure — check `context.service` | Inspect the server's own logs |

Diagnostic: inside Claude Code run `/mcp` to see server status.

## 10. Team Strategy

For a 20-person engineering team:

| Layer | File | Content |
|---|---|---|
| Shared-essential | `.mcp.json` | GitHub, Postgres (read-only), Slack |
| Shared-optional | `.claude/settings.json` | Instructions on how to install + optional servers |
| Personal | `~/.claude.json` | Each dev's web search, personal notes |

Document the shared-essential set in a `README.md` section titled "Claude Tooling" so new joiners can set up their env vars in five minutes.

## 11. Building Your Own MCP Server

When the 60+ published servers don't cover your case, build one:

```typescript
// src/mcp-server.ts
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";

const server = new McpServer({ name: "internal-api", version: "1.0.0" });

server.tool(
  "get_user",
  "Fetch a user by ID from the internal API. Returns {id, name, email, tier}. Returns isError=true with errorCategory on failure.",
  { userId: z.string().regex(/^USR-\d+$/) },
  async ({ userId }) => {
    try {
      const user = await fetch(`${process.env.API_URL}/users/${userId}`).then(r => r.json());
      return { content: [{ type: "text", text: JSON.stringify(user) }] };
    } catch (e) {
      return {
        content: [{
          type: "text",
          text: JSON.stringify({
            isError: true,
            errorCategory: "internal",
            isRetryable: true,
            context: { attempted: `GET /users/${userId}`, service: "internal-api" }
          })
        }],
        isError: true,
      };
    }
  }
);
```

Expose it via `.mcp.json`:
```json
"internal-api": {
  "command": "node",
  "args":    ["./dist/mcp-server.js"],
  "env":     { "API_URL": "${INTERNAL_API_URL}" }
}
```

## 12. Performance Considerations

- **Tools list time.** Each MCP server adds startup overhead (50 ms – 2 s).
- **Only enable what you use.** Turn off dormant servers.
- **Pre-install heavy packages** globally to skip `npx` download time.
- **Profile** startup with `claude --debug` when sessions are slow to initialize.

## 13. Exam Self-Check

1. *A teammate's `.mcp.json` hardcodes a Jira token. Problem?*
   → Leaked secret on commit. Use `${JIRA_TOKEN}` env expansion.
2. *Where should your team's shared Postgres MCP config live?*
   → `.mcp.json` at project root.
3. *Where should your personal web-search MCP config live?*
   → `~/.claude.json`.
4. *How do you grant read-only DB access via MCP?*
   → Scope through the server's args (e.g., `--read-only`) AND use a DB user with read-only grants.

---

### Key Takeaways
- ✅ `.mcp.json` (project) for team tools; `~/.claude.json` (user) for personal.
- ✅ Secrets always via `${ENV_VAR}`.
- ✅ Scope MCP servers down (`--read-only`, tight token scopes).
- ✅ Separate prod / dev / staging credentials.
- ❌ Never hardcode secrets in committed files.
- ❌ Don't put personal tools in `.mcp.json` (pollutes the team's setup).

Next → [`05-Built-in-Tools.md`](05-Built-in-Tools.md)
