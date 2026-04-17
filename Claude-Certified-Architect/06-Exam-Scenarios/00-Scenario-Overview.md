# Exam Scenarios — Overview

The CCA-F exam randomly selects **4 of 6** scenarios on exam day. Each scenario threads across multiple domains, so you're tested on integration, not just memorization.

## The Six Scenarios

| # | Scenario | Core Domains Tested |
|---|---|---|
| 1 | Customer Support Agent | Agentic loop, hooks, escalation, context management |
| 2 | Code Review Automation | Prompt eng, validation-retry, multi-pass review, CI/CD |
| 3 | Document / Invoice Processing | tool_use schema, few-shot, batch API, stratified metrics |
| 4 | Multi-Agent Research | Hub-and-spoke, Task tool, fork_session, context isolation |
| 5 | DevOps / CI-CD Workflow | Claude Code, -p / JSON output, separate-session review, MCP |
| 6 | Data Extraction / ETL Pipeline | Batch API, error propagation, provenance, retry loops |

## How to Study Each Scenario

For each scenario:
1. Read the **context summary** (what the business wants).
2. Identify **which domains are in play**.
3. Walk through the **correct design** step by step.
4. Study the **distractor answers** and why they're wrong.
5. Review the **exam tells** — phrases that signal which domain concept is being tested.

## How Scenarios Appear on the Exam

The exam will present a scenario, then ask ~10 questions that reference the scenario. Questions ramp in complexity:
- Early: facts about the scenario / basic application.
- Middle: pick the best design from 4 options.
- Late: spot the anti-pattern OR pick between two plausible answers where one has a subtle defect.

## The "Two-Right-Looking" Question Pattern

The exam's hallmark is questions where two answers look reasonable but one has a subtle defect. To beat them:
- **Read every word** of both candidate answers.
- Look for words like "all", "always", "never", "every" — often the tell.
- Match against your **golden laws**: objective escalation? measurable criteria? separate sessions?
- Trust the more **specific** answer over the more general one (specific is usually closer to best practice).

## Scenario Files
- `01-Customer-Support-Agent.md`
- `02-Code-Review-Automation.md`
- `03-Document-Processing-Pipeline.md`
- `04-Multi-Agent-Research.md`
- `05-DevOps-CICD-Workflow.md`
- `06-Data-Extraction-ETL.md`
