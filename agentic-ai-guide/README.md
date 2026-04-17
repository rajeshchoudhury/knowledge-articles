# Building Agentic AI: A Hands-On Guide for Java Engineers

> A practical, diagram-rich walkthrough of how to design, build, and run an
> **Agentic AI** using **LangChain** or **AWS Strands**, combined with **LLMs,
> Tools, Memory, Skills, MCP,** and **Custom Tools** — from zero to a working
> lab.

---

## Table of Contents

1. [What Is an Agentic AI?](#1-what-is-an-agentic-ai)
2. [Anatomy of an Agent](#2-anatomy-of-an-agent)
3. [The Agent Loop & State Transitions](#3-the-agent-loop--state-transitions)
4. [LangChain vs Strands — When to Choose Which](#4-langchain-vs-strands--when-to-choose-which)
5. [LLM: The Reasoning Engine](#5-llm-the-reasoning-engine)
6. [Tools: Giving the Agent Hands](#6-tools-giving-the-agent-hands)
7. [Memory: Short- and Long-Term](#7-memory-short--and-long-term)
8. [Skills: Reusable Capability Bundles](#8-skills-reusable-capability-bundles)
9. [MCP (Model Context Protocol)](#9-mcp-model-context-protocol)
10. [Architecture Blueprint](#10-architecture-blueprint)
11. [Step-by-Step Lab](#11-step-by-step-lab)
12. [Mental Model for Java Engineers](#12-mental-model-for-java-engineers)
13. [Production Checklist](#13-production-checklist)

---

## 1. What Is an Agentic AI?

A traditional LLM call is a **single-shot request/response** — like calling a
stateless REST API. An **agent** wraps the LLM in a loop that can **plan,
act, observe, and re-plan** until a goal is achieved.

### Spring-Boot Analogy

| Spring Boot Concept             | Agent Concept                     |
| ------------------------------- | --------------------------------- |
| `@RestController`               | Agent entrypoint (`invoke`)       |
| `@Service` beans                | Tools                             |
| `HttpSession` / `Redis`         | Memory                            |
| `@Configuration`                | Skill pack / system prompt        |
| Interceptors / filters          | Guardrails                        |
| Service mesh (Istio)            | MCP server                        |
| Event loop in Netty             | Agent ReAct loop                  |

### Request/Response vs Agent Loop

```
Classical LLM Call:
   user ──▶ [LLM] ──▶ answer

Agent Call:
   user ──▶ [LLM] ──▶ decide tool ──▶ [Tool] ──▶ observation
                ▲                                     │
                └─────────────  loop  ────────────────┘
                       until goal reached
```

---

## 2. Anatomy of an Agent

```
                      ┌─────────────────────────────────────────┐
                      │              AGENT RUNTIME              │
                      │                                         │
   user prompt  ─────▶│  ┌──────────┐   plan   ┌─────────────┐  │
                      │  │  Planner │ ───────▶ │  Executor   │  │
                      │  │  (LLM)   │          │ (tool call) │  │
                      │  └────▲─────┘          └──────┬──────┘  │
                      │       │ observation           │         │
                      │       └───────────────────────┘         │
                      │                                         │
                      │   ┌────────┐  ┌────────┐  ┌──────────┐  │
                      │   │ Memory │  │ Tools  │  │  Skills  │  │
                      │   └────────┘  └────────┘  └──────────┘  │
                      │                                         │
                      │   ┌──────────────────────────────────┐  │
                      │   │   MCP Clients (external tools)   │  │
                      │   └──────────────────────────────────┘  │
                      └─────────────────────────────────────────┘
                                         │
                                         ▼
                                   final answer
```

The **5 pillars** every agent needs:

1. **LLM** — the brain that reasons and decides the next action.
2. **Tools** — functions the agent can call (APIs, DB, calculators…).
3. **Memory** — short-term (conversation) + long-term (vector store).
4. **Skills** — packaged prompts + tools + examples for a capability.
5. **Orchestration loop** — the code that runs *plan → act → observe*.

---

## 3. The Agent Loop & State Transitions

Agents are **state machines**. The most common pattern is **ReAct**
(Reason + Act):

### State Diagram

```
         ┌─────────┐
         │  START  │
         └────┬────┘
              │ user prompt
              ▼
         ┌─────────┐    need info?    ┌─────────────┐
    ┌───▶│  THINK  │─────────────────▶│  CALL TOOL  │
    │    └────┬────┘                  └──────┬──────┘
    │         │ final answer ready           │ tool result
    │         ▼                              │
    │    ┌─────────┐                         │
    │    │ RESPOND │                         │
    │    └────┬────┘                         │
    │         │                              │
    │         ▼                              │
    │    ┌─────────┐                         │
    │    │   END   │                         │
    │    └─────────┘                         │
    │                                        │
    └────────────────── OBSERVE ◀────────────┘
```

### States Explained

| State        | What happens                                             |
| ------------ | -------------------------------------------------------- |
| **THINK**    | LLM decides: answer now, or call a tool?                 |
| **CALL TOOL**| Framework invokes the tool with JSON arguments           |
| **OBSERVE**  | Tool result is appended to context                       |
| **RESPOND**  | LLM produces the final user-facing answer                |
| **END**      | Loop terminates; response returned                       |

### ReAct Trace Example

```
User: "What is the weather in Tokyo in Celsius, and is it warmer than London?"

THINK  → "I need current weather for Tokyo and London."
ACT    → get_weather(city="Tokyo")
OBSERVE← {"temp_c": 22}
THINK  → "Now London."
ACT    → get_weather(city="London")
OBSERVE← {"temp_c": 14}
THINK  → "I can answer now."
RESPOND→ "Tokyo is 22°C, London is 14°C. Tokyo is 8°C warmer."
```

---

## 4. LangChain vs Strands — When to Choose Which

### LangChain / LangGraph (Python, JS/TS)

- **Mature**, huge ecosystem, 1000+ integrations.
- **LangGraph** adds explicit stateful graph orchestration (nodes = functions,
  edges = transitions). Great for complex multi-agent flows.
- Model-agnostic: OpenAI, Anthropic, Bedrock, Ollama, Groq, etc.

### AWS Strands Agents SDK

- **AWS-native, model-driven** agent framework (open source, 2025).
- Minimal boilerplate: `Agent(model, tools).invoke(prompt)`.
- First-class support for **Bedrock** models, **MCP**, streaming, tracing.
- Built-in `strands_tools` library (shell, file IO, HTTP, calculator,
  retrieval, memory).
- Runs anywhere — laptop, Lambda, ECS, Fargate, EKS, or EC2.

### Quick Comparison

| Feature                 | LangChain / LangGraph           | Strands                          |
| ----------------------- | ------------------------------- | -------------------------------- |
| Language support        | Python, JS/TS                   | Python (Java SDK emerging)       |
| Model providers         | 50+                             | Bedrock, Anthropic, OpenAI, …    |
| Orchestration style     | Chains + Graphs (explicit)      | Model-driven loop (implicit)     |
| Learning curve          | Medium → High                   | Low                              |
| Best for                | Complex multi-step workflows    | Fast production agents on AWS    |
| MCP support             | Yes (via adapter)               | Yes (native)                     |

**Rule of thumb**
- Need a graph of specialists, retries, branching? → **LangGraph**
- Want minimal code and AWS deployment? → **Strands**

---

## 5. LLM: The Reasoning Engine

The LLM is the agent's "CPU". For Java engineers, think of it as a
**stateless microservice** that takes messages and returns either:
- a final text answer, **or**
- a structured `tool_call` (JSON) the framework must execute.

```
┌──────────── messages[] ────────────┐
│ system: "You are a finance bot…"   │
│ user:   "Loan EMI for 20L @ 9%?"   │
│ assistant(tool_call): calc_emi(…)  │
│ tool:   {"emi": 17995}             │
│ assistant: "Your EMI is ₹17,995."  │
└────────────────────────────────────┘
```

Common choices:

| Provider       | Model examples                              |
| -------------- | ------------------------------------------- |
| AWS Bedrock    | Claude Sonnet 4.5, Nova, Llama 3            |
| OpenAI         | GPT-4o, GPT-4.1                             |
| Anthropic      | Claude 3.7/4 Sonnet/Opus                    |
| Local / self   | Llama 3.1, Mistral via Ollama               |

---

## 6. Tools: Giving the Agent Hands

**A tool = a typed function the LLM may call.**
In Java terms: a `@Service` method whose signature is exposed as JSON Schema
to the LLM.

### Three Flavors of Tools

```
┌─────────────────────────────────────────────────────────────┐
│                         TOOL UNIVERSE                       │
│                                                             │
│  ┌───────────────┐   ┌───────────────┐   ┌───────────────┐  │
│  │  PREBUILT     │   │  CUSTOM       │   │  MCP REMOTE   │  │
│  │  (library)    │   │  (your code)  │   │  (protocol)   │  │
│  ├───────────────┤   ├───────────────┤   ├───────────────┤  │
│  │ calculator    │   │ get_policy    │   │ jira_create   │  │
│  │ web_search    │   │ submit_claim  │   │ gh_list_prs   │  │
│  │ file_read     │   │ send_email    │   │ db_query      │  │
│  │ http_request  │   │ kb_lookup     │   │ k8s_pods      │  │
│  └───────────────┘   └───────────────┘   └───────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### Tool Anatomy (LangChain)

```python
from langchain.tools import tool

@tool
def get_policy(policy_id: str) -> dict:
    """Return the policy record for a given policy_id."""
    return policy_db.find(policy_id)
```

### Tool Anatomy (Strands)

```python
from strands import tool

@tool
def get_policy(policy_id: str) -> dict:
    """Return the policy record for a given policy_id."""
    return policy_db.find(policy_id)
```

Both frameworks auto-generate the JSON Schema from type hints + docstring.

### Tool Call Sequence

```
LLM ──▶ {"tool":"get_policy","args":{"policy_id":"P-1234"}}
         │
         ▼
Runtime validates args against schema
         │
         ▼
Python function executes
         │
         ▼
Result JSON fed back into messages[]
         │
         ▼
LLM continues reasoning
```

---

## 7. Memory: Short- and Long-Term

```
┌──────────────────────────────────────────────────────────┐
│                      AGENT MEMORY                        │
│                                                          │
│   SHORT-TERM (context window)       LONG-TERM            │
│   ─────────────────────────────     ───────────────────  │
│   last N turns of conversation      Vector DB (pgvector, │
│   scratchpad for ReAct steps        OpenSearch, Pinecone)│
│   "session state"                   Episodic memory      │
│                                     User profile / facts │
└──────────────────────────────────────────────────────────┘
```

### Short-term

- LangChain: `ConversationBufferMemory`, `MessagesState` (LangGraph).
- Strands: automatic `messages` list inside `Agent`.

### Long-term (RAG pattern)

```
user query ─▶ embed ─▶ vector search ─▶ top-k chunks ─▶ prompt ─▶ LLM
```

---

## 8. Skills: Reusable Capability Bundles

A **Skill** is a *packaged capability* — a system prompt, a set of tools, and
few-shot examples — that can be plugged into any agent.

Think of it as a **Spring Boot Starter**:
- `spring-boot-starter-web` → brings in Tomcat + Jackson + Spring MVC
- `claims-intake-skill` → brings in intake prompt + FNOL tools + examples

```
Skill = {
  name:    "claims-intake",
  prompt:  "You collect FNOL details politely…",
  tools:   [get_policy, validate_vin, create_fnol],
  fewshot: [...]
}
```

Strands ships a library `strands_tools` that behaves like skill packs
(`memory`, `file_ops`, `http_request`, `shell`, `calculator`, `retrieve`,
`current_time`, `python_repl`, etc.).

---

## 9. MCP (Model Context Protocol)

MCP is **"USB-C for AI tools"** — an open protocol (Anthropic, 2024) that
lets any agent talk to any tool server over a standard interface.

```
┌──────────┐    JSON-RPC    ┌──────────────┐
│  AGENT   │◀──────────────▶│  MCP SERVER  │
│ (client) │  stdio / HTTP  │ (tools,      │
└──────────┘                │  resources)  │
                            └──────────────┘
```

### Why Java engineers will love it

- **Decoupling**: tool teams publish MCP servers independently of the agent.
- **Polyglot**: server can be written in Node, Python, Go, **Java**.
- **Discoverable**: `listTools`, `listResources` endpoints return schemas.
- **Secure**: each server has its own auth & sandbox.

### Popular MCP servers

`filesystem`, `git`, `github`, `postgres`, `slack`, `puppeteer`,
`aws-knowledge-base`, `jira`, `confluence`.

### Connecting an MCP server (Strands)

```python
from strands import Agent
from strands.tools.mcp import MCPClient
from mcp import stdio_client, StdioServerParameters

gh = MCPClient(lambda: stdio_client(
    StdioServerParameters(command="npx",
                          args=["-y","@modelcontextprotocol/server-github"])))

with gh:
    agent = Agent(tools=gh.list_tools_sync())
    agent("List my open PRs in repo acme/widgets")
```

---

## 10. Architecture Blueprint

```
                          ┌───────────────────┐
                          │     User / UI     │
                          └─────────┬─────────┘
                                    │ prompt
                                    ▼
                  ┌─────────────────────────────────┐
                  │         AGENT RUNTIME           │
                  │  (LangGraph | Strands)          │
                  │                                 │
                  │   plan ─▶ act ─▶ observe loop   │
                  └───┬─────────┬───────────┬───────┘
                      │         │           │
         ┌────────────┘         │           └─────────────┐
         ▼                      ▼                         ▼
   ┌──────────┐          ┌────────────┐            ┌────────────┐
   │   LLM    │          │   TOOLS    │            │   MEMORY   │
   │ Bedrock  │          │  custom +  │            │ vector DB  │
   │ OpenAI   │          │  prebuilt  │            │  session   │
   └──────────┘          └─────┬──────┘            └────────────┘
                               │
                               ▼
                        ┌─────────────┐
                        │ MCP SERVERS │
                        │  jira, git, │
                        │  postgres…  │
                        └─────────────┘
```

---

## 11. Step-by-Step Lab

Full working code lives in [`lab/`](./lab). Here's the roadmap:

| Step | File                             | What you build                         |
| ---- | -------------------------------- | -------------------------------------- |
| 0    | `lab/00-setup.md`                | Environment + dependencies             |
| 1    | `lab/01-hello-llm.py`            | Plain LLM call (no agent)              |
| 2    | `lab/02-langchain-agent.py`      | First ReAct agent with custom tools    |
| 3    | `lab/03-strands-agent.py`        | Same agent rewritten in Strands        |
| 4    | `lab/04-agent-with-memory.py`    | Add conversation + vector memory       |
| 5    | `lab/05-agent-with-mcp.py`       | Plug in an MCP server                  |
| 6    | `lab/06-langgraph-state.py`      | Explicit state machine with LangGraph  |
| 7    | `lab/07-java-bridge/`            | Call the agent from a Spring Boot app  |

Start with [`lab/00-setup.md`](./lab/00-setup.md).

---

## 12. Mental Model for Java Engineers

Carry this picture in your head when you write agent code:

```
┌──────────────────────────────────────────────────────────────┐
│                   AGENT  ≈  "Smart Controller"               │
│                                                              │
│   @RestController   →   Agent(..)                            │
│   @Autowired Tools  →   tools=[...]                          │
│   Session / Redis   →   Memory / Checkpointer                │
│   application.yml   →   system_prompt + model config         │
│   Circuit breaker   →   Guardrails / max_iterations          │
│   Actuator logs     →   Traces (LangSmith / OTel)            │
└──────────────────────────────────────────────────────────────┘
```

**Key shift in mindset**: instead of *you* writing the orchestration (if/else,
switch, try/catch), the **LLM writes the orchestration at runtime** by
choosing which tool to call next. Your job is to:

1. Provide **good tools** with clear docstrings.
2. Provide a **good system prompt** (the contract).
3. Provide **guardrails** (max steps, allowed tools, input validation).
4. Provide **observability** (logs, traces, evals).

---

## 13. Production Checklist

- [ ] **Deterministic tests** — snapshot tool call sequences for fixed inputs.
- [ ] **Max iterations / timeout** — never let the loop run unbounded.
- [ ] **Structured outputs** — force JSON schema for final answer.
- [ ] **Guardrails** — PII masking, prompt-injection filters.
- [ ] **Tracing** — LangSmith, OpenTelemetry, CloudWatch.
- [ ] **Cost budget per session** — token caps + circuit breaker.
- [ ] **Human-in-the-loop** — approval step for destructive tools.
- [ ] **Fallback model** — cheap/fast model as retry.
- [ ] **Eval suite** — golden prompts + LLM-as-judge.
- [ ] **Versioned prompts & skills** — treat them like code.

---

## Next Steps

1. Read [`lab/00-setup.md`](./lab/00-setup.md) and set up your environment.
2. Run `lab/02-langchain-agent.py` — see the ReAct loop in your terminal.
3. Swap to `lab/03-strands-agent.py` — notice the boilerplate disappear.
4. Extend it: add your own MCP server in Java (see `lab/07-java-bridge/`).

Happy building!
