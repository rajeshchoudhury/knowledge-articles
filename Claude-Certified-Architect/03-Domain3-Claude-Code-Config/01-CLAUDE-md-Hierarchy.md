# D3.1 — CLAUDE.md Hierarchy & Configuration

> `CLAUDE.md` is the highest-leverage file you can add to a project. The exam's Scenario 2 pivots on understanding its hierarchy.

## 1. What CLAUDE.md Is

`CLAUDE.md` is a Markdown file that **Claude Code reads at session start** and incorporates into its system prompt. It tells Claude:
- What this codebase is (stack, purpose).
- What commands to use (build, test, lint).
- What conventions to follow (naming, patterns).
- What rules to obey (never modify migrations; always use server actions).
- What types/patterns are canonical.

Think: `.editorconfig`, but for a collaborator's brain.

## 2. The Three Hierarchical Layers

| Level | Path | Scope | Shared? | Typical content |
|---|---|---|---|---|
| **User** | `~/.claude/CLAUDE.md` | All projects on this machine | ❌ Personal | Editor preferences, keybindings, UI themes |
| **Project** | `./CLAUDE.md` or `./.claude/CLAUDE.md` | This repo | ✅ Committed | Stack, conventions, architecture, commands |
| **Directory** | e.g. `./src/api/CLAUDE.md` | That directory and below | ✅ Committed | Scoped rules (e.g., API-specific patterns) |

### Precedence
**More specific wins.** Directory > Project > User.

When multiple CLAUDE.md files exist, Claude Code **merges** them with the most specific taking priority if rules conflict.

## 3. Anti-Pattern: Personal Prefs in Project Config

A classic exam trap:

### ❌ Wrong
```
# project/.claude/CLAUDE.md
Use vim keybindings.
Prefer dark theme.
Use TypeScript with strict mode.
Follow ESLint airbnb.
```
The first two bits are **personal preferences**. They shouldn't be imposed on the team.

### ✅ Right
```
# ~/.claude/CLAUDE.md  (user-level, personal)
Use vim keybindings.
Prefer dark theme.

# project/.claude/CLAUDE.md  (project-level, shared)
Use TypeScript with strict mode.
Follow ESLint airbnb.
```

## 4. The Canonical Project-Level Template

```markdown
# CLAUDE.md

This is a Next.js 16 SaaS application using TypeScript, Tailwind CSS 4,
Drizzle ORM with PostgreSQL, and NextAuth for authentication. The app
provides real-time collaboration features via WebSockets.

## Commands
- `npm run dev` — Start dev server on port 3000
- `npm run build` — Production build
- `npm run test` — Vitest test suite
- `npm run test:unit -- path/to/file` — Single-file test
- `npm run lint` — ESLint check
- `npm run db:migrate` — Drizzle migrations
- `npm run db:seed` — Seed dev data

## Architecture
- `src/app/`              — Next.js App Router pages and layouts
- `src/components/ui/`    — Shared UI primitives (shadcn/ui)
- `src/components/features/` — Feature-specific components
- `src/lib/`              — Utilities, types, shared logic
- `src/server/`           — Server-only code (API routes, DB queries)

## Conventions
- Use named exports, not default exports
- Components use PascalCase filenames (`UserCard.tsx`)
- Utilities use camelCase filenames (`formatDate.ts`)
- All DB queries go through `src/server/db/`
- Use `cn()` from `@/lib/utils` for conditional classNames

## Rules
- NEVER modify migration files after they've been committed
- Always use server actions instead of API routes for mutations
- Do not add dependencies without asking first
- Keep components under 200 lines — extract sub-components early
- All user-facing strings must use `t()` (the i18n system)

## Key Types
Core domain types in `src/lib/types.ts`:
- `Workspace` — Top-level organization unit
- `Project` — Contains documents and members
- `Document` — Primary content entity with versioning
```

**Five sections** — same as in the public guides:
1. Project overview
2. Commands
3. Architecture
4. Conventions
5. Rules

## 5. Modular Configuration with `@import` and `.claude/rules/`

A CLAUDE.md exceeding ~200 lines gets hard to maintain. Split into modular rule files.

### Layout
```
project/.claude/
├── CLAUDE.md            # 30 lines — overview + imports
├── rules/
│   ├── typescript.md    # TypeScript rules
│   ├── testing.md       # Test conventions
│   ├── api-design.md    # REST/API rules
│   ├── security.md      # Security guidelines
│   └── accessibility.md # Accessibility standards
├── commands/
│   ├── review.md        # /review slash command
│   └── deploy.md        # /deploy slash command
└── skills/
    └── refactor/
        └── SKILL.md     # Forked-context refactor skill
```

### `@import` syntax
```markdown
# CLAUDE.md

This is a Next.js 16 SaaS app.

@import ./rules/typescript.md
@import ./rules/testing.md
@import ./rules/api-design.md
```

Rules in `rules/` may also be **auto-loaded** — any `.md` file in `.claude/rules/` is included by default. `@import` is only needed when you want to include a rule file from outside `rules/`.

## 6. Path-Specific Rules via YAML Frontmatter

A rule can be **scoped to specific file paths** using a `paths` glob:

```markdown
---
paths:
  - "src/api/**/*.ts"
  - "src/server/**/*.ts"
---

# API Rules

- Every endpoint must validate auth tokens
- Use Zod schemas for request validation
- Never `console.log` in production paths
```

This rule applies **only** when Claude is editing files matching those globs. It won't pollute the frontend-only Claude sessions.

## 7. Directory-Level CLAUDE.md

In large projects, use a directory-level `CLAUDE.md` for scoped guidance:

```
src/api/CLAUDE.md         # API-specific rules
src/ui/CLAUDE.md          # UI-specific rules
tests/CLAUDE.md           # Testing-specific rules
```

Claude Code reads the **most specific** CLAUDE.md for each file. When editing `src/api/auth.ts`, Claude merges:

1. `~/.claude/CLAUDE.md` (user)
2. `./CLAUDE.md` (project root)
3. `./src/CLAUDE.md` (if present)
4. `./src/api/CLAUDE.md` (most specific, highest priority)

## 8. Monorepo Pattern

```
my-monorepo/
├── CLAUDE.md                    # Shared monorepo setup (deployment, CI, shared tooling)
├── packages/
│   ├── api/
│   │   ├── CLAUDE.md           # API-specific rules
│   │   └── .claude/rules/
│   │       └── fastify.md
│   ├── web/
│   │   ├── CLAUDE.md           # Frontend-specific rules
│   │   └── .claude/rules/
│   │       └── next.md
│   └── shared/
│       └── CLAUDE.md
```

Each package has its own rules while sharing global conventions from the monorepo root.

## 9. Anti-Patterns (Memorize for the Exam)

| Anti-pattern | Why wrong | Fix |
|---|---|---|
| One 800-line CLAUDE.md mixing everything | Unmaintainable, conflicting sections | Modular: `rules/` + `@import` |
| Personal prefs (vim, theme) in project CLAUDE.md | Imposes on team | User-level `~/.claude/CLAUDE.md` |
| API rules in project root (affects all files) | Creates false constraints for non-API code | Directory-level `src/api/CLAUDE.md` |
| Missing `## Commands` section | Claude guesses build scripts wrongly | Always list top commands |
| Stale instructions (migrated from Jest → Vitest but CLAUDE.md still says Jest) | Wrong test runner invoked | Treat CLAUDE.md as a first-class repo file; update with code |
| Not committed to git | Teammates lose context; drift | `git add CLAUDE.md` |

## 10. Measuring Impact

How do you know your CLAUDE.md is working?

- **Fewer corrections.** You stop saying "that's not how we do it here."
- **Correct commands.** Claude runs `npm run test:unit` not `npm test`.
- **Consistent style.** No more "please use named exports" reminders.
- **Less context-setting.** New sessions are productive in seconds.

Track these qualitatively. When Claude starts making rookie mistakes, your CLAUDE.md probably drifted.

## 11. `.claude/settings.json` vs CLAUDE.md

| | `.claude/settings.json` | `CLAUDE.md` |
|---|---|---|
| Format | JSON | Markdown |
| Purpose | **Behavioral config** — hooks, permissions, MCP | **Instruction context** — conventions, commands, rules |
| Example | `{"hooks": {...}}` | `"Always use named exports"` |
| Enforcement | Programmatic (hooks, tool allow-lists) | Probabilistic (Claude reads as guidance) |

Use both. `CLAUDE.md` tells Claude *what to know*. `settings.json` enforces *what must happen*.

## 12. Exam Self-Check

1. *Team coding standards in the project's CLAUDE.md or user-level CLAUDE.md?*
   → **Project** — shared via git.
2. *"Use vim keybindings" — where does this rule go?*
   → **User** (`~/.claude/CLAUDE.md`) — it's personal.
3. *API-only rules — best placement?*
   → Directory-level CLAUDE.md in `src/api/` (or path-specific rule with `paths:` frontmatter).
4. *A CLAUDE.md hits 800 lines. How do you refactor?*
   → Split into `.claude/rules/*.md` files; import or let auto-load.

---

### Key Takeaways
- ✅ User / Project / Directory — three layers, most-specific wins.
- ✅ Personal prefs → user; team standards → project; module-specific → directory.
- ✅ Modularize with `@import` and `.claude/rules/`.
- ✅ Use YAML frontmatter `paths:` for scoped rules.
- ❌ Don't put personal prefs in project config.
- ❌ Don't let CLAUDE.md exceed ~200 lines without modularizing.
- ❌ Don't let CLAUDE.md drift — keep it current with the codebase.

Next → [`02-Commands-vs-Skills.md`](02-Commands-vs-Skills.md)
