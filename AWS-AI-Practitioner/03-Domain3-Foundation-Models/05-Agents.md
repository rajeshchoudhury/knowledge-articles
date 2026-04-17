# 3.5 — Agents and Orchestration

## 1. What Is an Agent?

An **AI agent** is an LLM-driven system that can:
- **Reason** about a goal.
- **Plan** multi-step actions.
- **Act** by calling tools / APIs / functions.
- **Observe** results and re-plan.
- **Finish** when the goal is met.

Instead of producing text and stopping, an agent iteratively **does things** in the real world.

---

## 2. The ReAct Loop

```
┌──────── Goal / User request ─────────┐
│                                      │
▼                                      │
Thought ─▶ Action (tool call) ─▶ Observation ─▶ Thought ...
                                      │
                                      ▼
                            Final Answer / Done
```

The LLM emits interleaved **Thought**, **Action**, **Observation** steps until it decides the task is complete.

---

## 3. Agents for Amazon Bedrock

A **managed agent** with:
- **Foundation model** driving reasoning.
- **Instructions** (system prompt describing agent's purpose and style).
- **Action groups** — APIs the agent can call. Defined by:
  - An **OpenAPI 3.0 schema** or a **function definition**.
  - Backed by **AWS Lambda** (most common) or RETURN_CONTROL (app handles it).
- **Knowledge bases** — attached KBs for RAG.
- **Guardrails** — safety layer.
- **Session memory** — short-term per session; can be persisted for long-term memory.
- **Prompt templates** — agent's orchestration prompts (customizable).

### Agent workflow with Bedrock
```
Client ──▶ InvokeAgent ──▶ Agent Orchestrator
                                │
                     ┌──────────┼──────────┐
                     ▼          ▼          ▼
              Knowledge Base  Action Group  Guardrail
              (RAG)          (Lambda)       (filter)
                     │          │          │
                     └──────────▶──────────┘
                                │
                          Final answer
```

### Key agent features
- **Multi-step orchestration** — the model decides tool use, not you.
- **Chain-of-thought exposed** — you can see trace of reasoning and tool calls.
- **User confirmation** — for sensitive actions you can force a human confirmation step.
- **Streaming** — responses can stream.
- **Multi-agent collaboration** — a **supervisor** agent delegates to **specialist** agents (e.g., HR agent, Finance agent), orchestrating collaboration.
- **Code interpretation** — built-in sandbox for simple code/math execution.

---

## 4. Designing an Agent

1. **Define the goal** — what tasks does this agent handle?
2. **Write clear instructions** — persona, tone, do/don'ts, success criteria.
3. **Identify tools** — which APIs does the agent need?
4. **Define schemas** — precise OpenAPI or function definitions; descriptions matter a lot (the LLM decides based on them).
5. **Implement Lambdas** — least privilege IAM, validate inputs, handle errors, return structured outputs.
6. **Attach knowledge bases** for grounded facts.
7. **Apply guardrails** — especially for external-facing agents.
8. **Test extensively** — edge cases, prompt injection from user/doc content, tool failure handling.
9. **Monitor** — CloudWatch trace logs; review tool call distributions.

---

## 5. When to Use an Agent vs Plain RAG vs Chain

| You need | Use |
|----------|-----|
| Just answer questions from docs | **RAG (Knowledge Base)** |
| A chat bot with tone | **Converse API** |
| Multi-step task that must call external APIs | **Agent** |
| Predefined, linear workflow with some LLM steps | **Bedrock Flows** or **Step Functions** |
| Ask users to approve destructive actions | Agent + **user confirmation** |
| Several specialist agents coordinate | **Multi-agent collaboration** |

---

## 6. Function Calling vs Tool Use

- **Function calling** (Converse API `toolConfig`) — direct: you pass a tool spec, the model returns a structured `tool_use` block, you execute it, feed back `tool_result`. Good for simpler stateless flows.
- **Agents for Bedrock** — managed loop that handles function calling, retries, planning, RAG, guardrails, memory.

Function calling is a primitive; an agent is a higher-level orchestrator built on top of it.

---

## 7. Bedrock Flows

Visual DAG of:
- **Prompt nodes** (managed prompts from Prompt Management).
- **Knowledge Base nodes**.
- **Agent nodes**.
- **Lambda nodes**.
- **Condition nodes**.
- **Iterator / collector nodes**.
- **S3 retrieval / storage nodes**.

Use cases: structured pipelines where you want deterministic control + some LLM reasoning.

Think of Flows as "**Step Functions for GenAI**" with first-class Bedrock nodes.

---

## 8. Memory

- **Short-term (session)** memory — in-context conversation history.
- **Long-term memory** — summaries of prior sessions persisted in a KB or DynamoDB.
- **Entity memory** — track stable facts about a user across sessions.

Bedrock Agents support configurable memory that stores session summaries across conversations, up to a retention period.

---

## 9. Guardrails + Agents

Guardrails can be applied:
- To every FM call inside the agent.
- To block denied topics.
- To redact PII before tool calls / after tool responses.
- To enforce contextual grounding on KB-backed responses.
- Automated Reasoning Checks can verify agent actions against policy.

---

## 10. Common Agent Patterns

### Customer support agent
- Tools: order lookup, issue refund (with confirmation), create ticket.
- KBs: help articles, product docs.
- Guardrails: no financial advice; redact PII.

### Ops/SRE agent
- Tools: query CloudWatch, run runbooks (limited), create incident.
- KBs: runbooks, architecture docs.
- Human-in-the-loop for destructive actions.

### Sales assistant
- Tools: CRM query, quote generation, calendar booking.
- KB: product catalog, pricing.
- Guardrails: word filters for off-brand claims.

### Data analyst agent
- Tools: run SQL (read-only), summarize results.
- KB: schema docs, analysis templates.
- Optionally chart generation via Lambda.

---

## 11. Risks of Agents

- **Unbounded tool calls** — runaway loops; set max iterations.
- **Prompt injection via tool output** — tool returns malicious text that hijacks agent; sanitize/escape.
- **Over-privileged tools** — each Lambda should be least-privilege.
- **Hallucinated tool calls** — model invents functions; strict schemas and unknown-function refusal.
- **Cost** — each step = another FM call.
- **Latency** — multi-step loops take seconds-minutes.
- **Traceability** — treat trace logs as audit evidence.

---

## 12. Exam Cues

| Clue | Answer |
|------|--------|
| "Multi-step task that calls external APIs" | **Bedrock Agent** |
| "Model returns a structured function call in chat" | **Function calling / `toolConfig`** |
| "Visual pipeline of prompts, KBs, Lambdas" | **Bedrock Flows** |
| "Orchestrate multiple specialized agents" | **Multi-agent collaboration** |
| "Force user approval before irreversible action" | **Agent user confirmation** |
| "Safe LLM responses within the agent" | **Guardrails** |
| "Agent that recalls past sessions" | **Memory retention (Bedrock Agent memory)** |

> You are done with Domain 3. Continue to Domain 4 — [Responsible AI](../04-Domain4-Responsible-AI/01-Responsible-AI.md).
