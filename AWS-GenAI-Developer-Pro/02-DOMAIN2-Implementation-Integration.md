# Domain 2: Implementation and Integration (26% of Exam)

## AWS Certified Generative AI Developer – Professional (AIP-C01)

---

> **Exam Weight:** This domain accounts for **26%** of the total exam score — roughly 17-18 questions out of 65. It is the most hands-on, code-oriented domain and tests your ability to build, deploy, and integrate generative AI systems using AWS services. Expect scenario-based questions requiring you to choose the right service, pattern, or architecture.

---

## Table of Contents

- [Task 2.1: Implement Agentic AI Solutions and Tool Integrations](#task-21-implement-agentic-ai-solutions-and-tool-integrations)
- [Task 2.2: Implement Model Deployment Strategies](#task-22-implement-model-deployment-strategies)
- [Task 2.3: Design and Implement Enterprise Integration Architectures](#task-23-design-and-implement-enterprise-integration-architectures)
- [Task 2.4: Implement FM API Integrations](#task-24-implement-fm-api-integrations)
- [Task 2.5: Implement Application Integration Patterns and Development Tools](#task-25-implement-application-integration-patterns-and-development-tools)

---

# Task 2.1: Implement Agentic AI Solutions and Tool Integrations

Agentic AI is the paradigm where foundation models act as autonomous reasoning engines — they plan, execute tools, observe results, and iterate until a goal is met. AWS provides a rich ecosystem for building these systems.

## Strands Agents SDK

**Strands Agents** is an open-source SDK from AWS for building agentic AI applications. It follows a model-driven approach where the FM itself orchestrates tool use rather than relying on rigid workflow definitions.

### Core Architecture

```
┌──────────────────────────────────────────────────────────────────────┐
│                        Strands Agent                                 │
│                                                                      │
│  ┌─────────────┐    ┌──────────────┐    ┌────────────────────────┐  │
│  │   System     │    │  Foundation   │    │     Tool Registry      │  │
│  │   Prompt     │───▶│    Model      │───▶│                        │  │
│  │              │    │  (Reasoning)  │    │  ┌──────┐ ┌─────────┐ │  │
│  └─────────────┘    └──────┬───────┘    │  │ RAG  │ │ Lambda  │ │  │
│                            │            │  └──────┘ └─────────┘ │  │
│                            │            │  ┌──────┐ ┌─────────┐ │  │
│                            ▼            │  │ HTTP │ │ Custom  │ │  │
│                     ┌──────────────┐    │  └──────┘ └─────────┘ │  │
│                     │  Agent Loop  │    │  ┌──────┐ ┌─────────┐ │  │
│                     │  (Plan →     │◀──▶│  │ MCP  │ │  Code   │ │  │
│                     │   Act →      │    │  └──────┘ └─────────┘ │  │
│                     │   Observe →  │    └────────────────────────┘  │
│                     │   Repeat)    │                                 │
│                     └──────────────┘                                 │
│                                                                      │
│  ┌─────────────────┐    ┌──────────────────────────────────────┐    │
│  │  Conversation    │    │          Callback Hooks              │    │
│  │  Memory / State  │    │  (on_tool_start, on_tool_end,       │    │
│  │                  │    │   on_message, on_error)              │    │
│  └─────────────────┘    └──────────────────────────────────────┘    │
└──────────────────────────────────────────────────────────────────────┘
```

### Key Concepts

| Concept | Description |
|---------|-------------|
| **Agent** | The top-level orchestrator — wraps a model, tools, system prompt, and memory |
| **Tool** | A Python function decorated with `@tool` that the agent can invoke |
| **Model** | The FM backend (Bedrock, SageMaker, or any LiteLLM-compatible endpoint) |
| **Agent Loop** | The iterative cycle: the model reasons, selects a tool, executes it, observes the result, and decides the next step |
| **Callback** | Hooks into the agent lifecycle for logging, tracing, or custom behavior |

### Strands Agent Code Pattern

```python
from strands import Agent, tool
from strands.models.bedrock import BedrockModel

@tool
def get_weather(city: str) -> dict:
    """Retrieve current weather for a city."""
    # Call external API
    return {"city": city, "temp": "22°C", "condition": "sunny"}

@tool
def book_flight(origin: str, destination: str, date: str) -> dict:
    """Book a flight between two cities."""
    return {"confirmation": "FL-12345", "status": "booked"}

model = BedrockModel(
    model_id="anthropic.claude-sonnet-4-20250514",
    region_name="us-east-1"
)

agent = Agent(
    model=model,
    tools=[get_weather, book_flight],
    system_prompt="You are a travel assistant. Help users plan trips."
)

response = agent("Plan a trip from NYC to London next Friday")
```

The Strands Agent handles the full Plan-Act-Observe loop. The model decides which tools to call, in what order, and when it has enough information to respond.

### Tool Definition Deep Dive

Strands tools use Python type hints and docstrings to generate the tool schema automatically. The FM sees this schema and decides when/how to invoke the tool.

```python
@tool
def search_knowledge_base(
    query: str,
    max_results: int = 5,
    filters: dict = None
) -> list:
    """Search the enterprise knowledge base for relevant documents.
    
    Args:
        query: The search query string
        max_results: Maximum number of results to return (default 5)
        filters: Optional metadata filters like {"department": "engineering"}
    
    Returns:
        List of matching documents with scores
    """
    bedrock_agent = boto3.client("bedrock-agent-runtime")
    response = bedrock_agent.retrieve(
        knowledgeBaseId="KB-XXXXX",
        retrievalQuery={"text": query},
        retrievalConfiguration={
            "vectorSearchConfiguration": {
                "numberOfResults": max_results,
                "filter": filters or {}
            }
        }
    )
    return response["retrievalResults"]
```

> **EXAM TIP:** Strands Agents use a *model-driven* orchestration approach — the model itself decides the workflow at runtime. This contrasts with *code-defined* orchestration (like Step Functions) where the developer pre-defines the workflow. Know when to use each: model-driven for flexible, conversational tasks; code-defined for deterministic, auditable workflows.

---

## AWS Agent Squad (Multi-Agent Systems)

AWS Agent Squad (formerly Multi-Agent Orchestrator) enables you to build systems where multiple specialized agents collaborate to solve complex problems.

### Multi-Agent System Topology

```
                         ┌─────────────────────────┐
                         │      User Request        │
                         └────────────┬────────────┘
                                      │
                                      ▼
                    ┌─────────────────────────────────────┐
                    │         Agent Squad Orchestrator      │
                    │                                       │
                    │  ┌─────────────────────────────────┐ │
                    │  │    Intent Classifier (FM)        │ │
                    │  │    Routes to best agent          │ │
                    │  └──────────────┬──────────────────┘ │
                    │                 │                     │
                    │    ┌────────────┼────────────┐       │
                    │    ▼            ▼            ▼       │
                    │ ┌───────┐ ┌─────────┐ ┌──────────┐  │
                    │ │ Agent │ │  Agent  │ │  Agent   │  │
                    │ │  A    │ │   B     │ │   C      │  │
                    │ │(Code) │ │(Travel) │ │(Finance) │  │
                    │ └───┬───┘ └────┬────┘ └─────┬────┘  │
                    │     │          │             │        │
                    │     ▼          ▼             ▼        │
                    │  ┌─────────────────────────────────┐ │
                    │  │     Shared Context / Memory      │ │
                    │  │    (DynamoDB / In-Memory)        │ │
                    │  └─────────────────────────────────┘ │
                    └─────────────────────────────────────┘
                                      │
                                      ▼
                         ┌─────────────────────────┐
                         │    Aggregated Response    │
                         └─────────────────────────┘
```

### Agent Squad Patterns

**Supervisor Pattern:** A supervisor agent receives all requests and delegates to specialist agents. The supervisor synthesizes their outputs.

```python
from agent_squad import AgentSquad, Agent, BedrockAgent

code_agent = Agent(
    name="CodeExpert",
    description="Handles coding questions, debugging, and code review",
    model_id="anthropic.claude-sonnet-4-20250514"
)

data_agent = Agent(
    name="DataAnalyst", 
    description="Handles data analysis, SQL queries, and visualization",
    model_id="anthropic.claude-sonnet-4-20250514"
)

squad = AgentSquad(
    agents=[code_agent, data_agent],
    classifier_model_id="anthropic.claude-haiku-3-20250722",
    storage=DynamoDBStorage(table_name="agent-sessions")
)

response = await squad.route_request(
    user_input="Analyze the sales CSV and write a Python script to visualize it",
    user_id="user-123",
    session_id="session-456"
)
```

**Key Architecture Decisions:**

| Pattern | When to Use | AWS Implementation |
|---------|-------------|-------------------|
| **Supervisor** | Single entry point, clear delegation | Agent Squad with classifier |
| **Peer-to-Peer** | Agents need to collaborate laterally | Strands agents calling other Strands agents as tools |
| **Hierarchical** | Complex tasks with sub-task decomposition | Nested Agent Squads or Step Functions orchestrating agents |
| **Pipeline** | Sequential processing stages | Step Functions with agent invocations at each step |

> **EXAM TIP:** Agent Squad uses an FM-based **classifier** to route requests to the right agent. The classifier sees each agent's name and description to decide. Well-written agent descriptions are critical for accurate routing. On the exam, if routing is incorrect, the fix is usually improving agent descriptions, not changing the classifier model.

---

## Model Context Protocol (MCP)

MCP is an open standard (originated by Anthropic) for connecting AI agents to external tools and data sources through a standardized interface. Think of it as "USB-C for AI tools."

### MCP Architecture

```
┌──────────────────────────────────────────────────────┐
│                   MCP Host (Agent)                    │
│                                                       │
│  ┌─────────────┐   ┌─────────────┐                   │
│  │  MCP Client  │   │  MCP Client  │                  │
│  │  (Server A)  │   │  (Server B)  │                  │
│  └──────┬───────┘   └──────┬───────┘                  │
└─────────┼──────────────────┼──────────────────────────┘
          │                  │
          ▼                  ▼
   ┌──────────────┐   ┌──────────────┐
   │  MCP Server  │   │  MCP Server  │
   │  (Lambda)    │   │  (ECS)       │
   │              │   │              │
   │  Tools:      │   │  Tools:      │
   │  - search    │   │  - query_db  │
   │  - retrieve  │   │  - run_sql   │
   │              │   │              │
   │  Resources:  │   │  Resources:  │
   │  - docs      │   │  - schemas   │
   │              │   │              │
   │  Prompts:    │   │  Prompts:    │
   │  - templates │   │  - workflows │
   └──────────────┘   └──────────────┘
```

### MCP Primitives

| Primitive | Direction | Description |
|-----------|-----------|-------------|
| **Tools** | Server → Client | Functions the agent can invoke (e.g., `search_database`) |
| **Resources** | Server → Client | Read-only data the agent can access (e.g., file contents, DB schemas) |
| **Prompts** | Server → Client | Reusable prompt templates for common workflows |
| **Sampling** | Client → Server | Allows the server to request FM completions from the client |

### MCP Server Deployment on AWS

**Lambda for Stateless MCP Servers:**

Lambda is ideal for MCP servers that handle independent, stateless tool calls — API lookups, database queries, document retrieval.

```python
# Lambda-based MCP server using streamable HTTP transport
from mcp.server import Server
from mcp.server.transports import StreamableHTTPTransport

server = Server("knowledge-base-server")

@server.tool("search_docs")
async def search_docs(query: str, top_k: int = 5) -> list:
    """Search the knowledge base for relevant documents."""
    kb_client = boto3.client("bedrock-agent-runtime")
    result = kb_client.retrieve(
        knowledgeBaseId=os.environ["KB_ID"],
        retrievalQuery={"text": query},
        retrievalConfiguration={
            "vectorSearchConfiguration": {"numberOfResults": top_k}
        }
    )
    return [r["content"]["text"] for r in result["retrievalResults"]]

@server.resource("schema://database")
async def get_schema() -> str:
    """Expose database schema as a resource."""
    return load_schema_from_glue_catalog()
```

**ECS for Complex/Stateful MCP Servers:**

Use ECS (Fargate) when the MCP server needs persistent connections, large memory, long-running operations, or maintains state across tool calls.

```
┌──────────────────────────────────────────────┐
│  ECS Fargate Service                          │
│                                               │
│  ┌─────────────────────────────────────────┐ │
│  │  MCP Server Container                    │ │
│  │                                          │ │
│  │  - WebSocket/SSE transport               │ │
│  │  - Persistent DB connections             │ │
│  │  - In-memory caching                     │ │
│  │  - Session state management              │ │
│  │  - Complex tool orchestration            │ │
│  └─────────────────────────────────────────┘ │
│                                               │
│  ALB ← Agent connects via WebSocket           │
└──────────────────────────────────────────────┘
```

| MCP Server Type | Hosting | Transport | Use Case |
|-----------------|---------|-----------|----------|
| Stateless tools | Lambda + Function URL | Streamable HTTP | API lookups, KB search, simple CRUD |
| Stateful tools | ECS Fargate | WebSocket / SSE | DB sessions, file operations, long workflows |
| High-throughput | ECS on EC2 (GPU) | Streamable HTTP | Model inference, embedding generation |
| Internal-only | Lambda in VPC | Streamable HTTP | Private resource access behind VPC |

### MCP Client Integration with Strands

```python
from strands import Agent
from strands.tools.mcp import MCPClient
from mcp.client.streamable_http import StreamableHTTPTransport

mcp_client = MCPClient(
    transport=StreamableHTTPTransport(
        url="https://mcp-server.example.com/mcp"
    )
)

with mcp_client:
    agent = Agent(
        tools=[mcp_client],  # All MCP tools become available
        system_prompt="You have access to enterprise tools via MCP."
    )
    response = agent("Find all open tickets assigned to me")
```

> **EXAM TIP:** MCP uses a **client-server** architecture. The agent hosts MCP clients, each connecting to one MCP server. A single agent can connect to multiple MCP servers simultaneously. Lambda is the default for stateless servers; ECS for stateful. The exam will test you on choosing the right hosting option based on statefulness and connection requirements.

---

## Memory and State Management for Autonomous Agents

Agents need memory to maintain context across interactions and state to track progress within a task.

### Memory Types

| Memory Type | Scope | Implementation | Use Case |
|-------------|-------|----------------|----------|
| **Conversation Memory** | Single session | In-memory list, DynamoDB | Chat history within a session |
| **Session Memory** | Cross-session | DynamoDB, ElastiCache | Remembering user preferences across visits |
| **Semantic Memory** | Long-term | Knowledge Bases for Bedrock (vector store) | Learned facts and relationships |
| **Episodic Memory** | Long-term | S3 + metadata in DynamoDB | Past task execution traces for learning |
| **Working Memory** | Current task | Agent internal state | Intermediate results during multi-step reasoning |

### State Management Patterns

**DynamoDB for Session State:**

```python
import boto3
from datetime import datetime, timedelta

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("agent-sessions")

def save_state(session_id: str, state: dict):
    table.put_item(Item={
        "session_id": session_id,
        "state": state,
        "ttl": int((datetime.now() + timedelta(hours=24)).timestamp()),
        "updated_at": datetime.now().isoformat()
    })

def load_state(session_id: str) -> dict:
    response = table.get_item(Key={"session_id": session_id})
    return response.get("Item", {}).get("state", {})
```

**Amazon Bedrock Memory (Managed):**

Bedrock provides built-in memory for agents that automatically summarizes and persists conversation context.

```python
bedrock_agent = boto3.client("bedrock-agent-runtime")

response = bedrock_agent.invoke_agent(
    agentId="AGENT_ID",
    agentAliasId="ALIAS_ID",
    sessionId="session-123",  # Bedrock manages memory per session
    memoryId="memory-456",    # Long-term memory across sessions
    inputText="What did we discuss last week about the migration?"
)
```

> **EXAM TIP:** DynamoDB with TTL is the go-to for session state in agentic systems. For long-term semantic memory, use Knowledge Bases for Amazon Bedrock (vector store). The exam often presents scenarios where you need to choose between short-term (DynamoDB) and long-term (vector store) memory.

---

## ReAct Patterns: Step Functions and Chain-of-Thought Reasoning

**ReAct** (Reasoning + Acting) is the dominant pattern for agentic AI. The agent alternates between reasoning about the current situation and taking actions to gather information or change state.

### ReAct Loop

```
┌─────────────────────────────────────────────────────┐
│                    ReAct Loop                        │
│                                                      │
│   ┌──────────┐     ┌──────────┐     ┌──────────┐   │
│   │ THOUGHT  │────▶│  ACTION  │────▶│OBSERVATION│   │
│   │          │     │          │     │           │   │
│   │ "I need  │     │ Call     │     │ "Results  │   │
│   │  to find │     │ search   │     │  show 3   │   │
│   │  the     │     │ tool     │     │  matching │   │
│   │  latest  │     │          │     │  docs"    │   │
│   │  sales"  │     │          │     │           │   │
│   └──────────┘     └──────────┘     └─────┬─────┘   │
│        ▲                                   │         │
│        │                                   │         │
│        └───────────────────────────────────┘         │
│                                                      │
│   Repeat until: answer found OR max iterations       │
│                  OR stopping condition met            │
└─────────────────────────────────────────────────────┘
```

### Step Functions for Deterministic ReAct

When you need auditability, retry logic, or deterministic control over the agent loop, use Step Functions.

```json
{
  "Comment": "ReAct Agent with Step Functions",
  "StartAt": "Reason",
  "States": {
    "Reason": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:123456789:function:reason",
      "Next": "CheckIfDone",
      "TimeoutSeconds": 30,
      "Retry": [{
        "ErrorEquals": ["ThrottlingException"],
        "IntervalSeconds": 2,
        "MaxAttempts": 3,
        "BackoffRate": 2.0
      }]
    },
    "CheckIfDone": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.status",
          "StringEquals": "FINAL_ANSWER",
          "Next": "ReturnAnswer"
        },
        {
          "Variable": "$.iteration",
          "NumericGreaterThan": 10,
          "Next": "MaxIterationsReached"
        }
      ],
      "Default": "Act"
    },
    "Act": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:123456789:function:execute-tool",
      "Next": "Observe",
      "TimeoutSeconds": 60,
      "Catch": [{
        "ErrorEquals": ["ToolExecutionError"],
        "Next": "HandleToolError"
      }]
    },
    "Observe": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:123456789:function:observe",
      "Next": "Reason"
    },
    "HandleToolError": {
      "Type": "Pass",
      "Result": {"observation": "Tool failed, trying alternative"},
      "Next": "Reason"
    },
    "MaxIterationsReached": {
      "Type": "Fail",
      "Cause": "Agent exceeded maximum iterations"
    },
    "ReturnAnswer": {
      "Type": "Succeed"
    }
  }
}
```

> **EXAM TIP:** Step Functions provide **deterministic** ReAct loops with built-in timeout, retry, and error handling. Use Step Functions when you need auditability (every state transition is logged), cost control (bounded iterations), or regulatory compliance. Use Strands/Bedrock agents when you need flexible, model-driven reasoning. The exam loves testing when to use each.

---

## Stopping Conditions, Timeouts, and Safety Mechanisms

### Stopping Conditions

| Mechanism | Purpose | Implementation |
|-----------|---------|----------------|
| **Max Iterations** | Prevent infinite loops | Counter in agent loop or Step Functions Choice state |
| **Timeout** | Bound execution time | Step Functions `TimeoutSeconds`, Lambda timeout |
| **Token Budget** | Control cost | Track cumulative tokens; stop when budget exceeded |
| **Confidence Threshold** | Quality gate | Agent self-assesses confidence; stop if above threshold |
| **Circuit Breaker** | Fail fast on persistent errors | Track consecutive failures; open circuit after N failures |
| **Human Escalation** | Safety net | Route to human when agent is uncertain or task is high-risk |

### Circuit Breaker Pattern

```python
class CircuitBreaker:
    def __init__(self, failure_threshold=5, reset_timeout=60):
        self.failure_count = 0
        self.failure_threshold = failure_threshold
        self.reset_timeout = reset_timeout
        self.last_failure_time = None
        self.state = "CLOSED"  # CLOSED, OPEN, HALF_OPEN
    
    def call(self, func, *args, **kwargs):
        if self.state == "OPEN":
            if time.time() - self.last_failure_time > self.reset_timeout:
                self.state = "HALF_OPEN"
            else:
                raise CircuitOpenError("Circuit breaker is open")
        
        try:
            result = func(*args, **kwargs)
            if self.state == "HALF_OPEN":
                self.state = "CLOSED"
                self.failure_count = 0
            return result
        except Exception as e:
            self.failure_count += 1
            self.last_failure_time = time.time()
            if self.failure_count >= self.failure_threshold:
                self.state = "OPEN"
            raise
```

### IAM Resource Boundaries

Agents must operate with least privilege. Each tool/action should have scoped IAM permissions.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "BedrockInvokeOnly",
            "Effect": "Allow",
            "Action": [
                "bedrock:InvokeModel",
                "bedrock:InvokeModelWithResponseStream"
            ],
            "Resource": "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-sonnet-4-20250514"
        },
        {
            "Sid": "KBRetrieveOnly",
            "Effect": "Allow",
            "Action": "bedrock:Retrieve",
            "Resource": "arn:aws:bedrock:us-east-1:123456789:knowledge-base/KB-XXXX"
        },
        {
            "Sid": "DenyDestructiveActions",
            "Effect": "Deny",
            "Action": [
                "s3:DeleteObject",
                "dynamodb:DeleteTable",
                "bedrock:DeleteAgent"
            ],
            "Resource": "*"
        }
    ]
}
```

> **EXAM TIP:** The exam will test you on **layered safety**: (1) IAM for resource boundaries, (2) circuit breakers for resilience, (3) max iterations/timeouts for cost control, (4) human-in-the-loop for high-stakes decisions. Know all four layers and when each applies.

---

## Model Coordination and Selection

### Model Ensembles and Specialization

Different FMs excel at different tasks. A well-architected agentic system uses the right model for each sub-task.

| Task | Recommended Model Tier | Rationale |
|------|----------------------|-----------|
| Intent classification / routing | Small (Haiku, Lite) | Fast, cheap, sufficient accuracy for classification |
| Tool parameter extraction | Medium (Sonnet) | Needs structured output accuracy |
| Complex reasoning / planning | Large (Opus, Sonnet) | Requires deep reasoning chains |
| Code generation | Code-specialized (Claude, CodeLlama) | Domain-specific training |
| Summarization | Medium (Sonnet, Llama) | Good balance of quality and cost |
| Embedding generation | Embedding models (Titan, Cohere) | Purpose-built for vector representations |

### Model Selection Framework

```python
class ModelSelector:
    """Route requests to the optimal model based on task characteristics."""
    
    ROUTING_TABLE = {
        "classification": {
            "model_id": "anthropic.claude-3-haiku-20240307",
            "max_tokens": 100,
            "reason": "Fast classification, low cost"
        },
        "reasoning": {
            "model_id": "anthropic.claude-sonnet-4-20250514",
            "max_tokens": 4096,
            "reason": "Complex multi-step reasoning"
        },
        "code_generation": {
            "model_id": "anthropic.claude-sonnet-4-20250514",
            "max_tokens": 8192,
            "reason": "Strong code generation capability"
        },
        "simple_qa": {
            "model_id": "amazon.titan-text-lite-v1",
            "max_tokens": 500,
            "reason": "Simple factual answers, lowest cost"
        }
    }
    
    def select(self, task_type: str, complexity: str = "medium") -> dict:
        config = self.ROUTING_TABLE.get(task_type, self.ROUTING_TABLE["reasoning"])
        if complexity == "high":
            config["model_id"] = "anthropic.claude-sonnet-4-20250514"
        return config
```

### Model Cascading

Model cascading uses a smaller/cheaper model first and only escalates to a larger model when the smaller one lacks confidence.

```
Request ──▶ Small Model (Haiku) ──▶ Confidence Check
                                         │
                                    High  │  Low
                                    ▼     │  ▼
                               Return     │  Large Model (Sonnet) ──▶ Return
                               Result     │  
```

```python
def cascading_invoke(prompt: str, confidence_threshold: float = 0.8):
    # Try small model first
    small_response = invoke_model("anthropic.claude-3-haiku-20240307", prompt)
    
    confidence = assess_confidence(small_response)
    if confidence >= confidence_threshold:
        return small_response
    
    # Escalate to larger model
    large_response = invoke_model("anthropic.claude-sonnet-4-20250514", prompt)
    return large_response
```

> **EXAM TIP:** Model cascading is a **cost optimization** strategy. The exam will present scenarios where you need to reduce costs without sacrificing quality — cascading is the answer. Remember: small model first → confidence check → escalate only if needed.

---

## Human-in-the-Loop Patterns

### Step Functions for Approval Workflows

```
┌──────────┐    ┌──────────────┐    ┌────────────┐    ┌──────────────┐
│  Agent    │───▶│  Propose     │───▶│  Wait for  │───▶│  Execute     │
│  Reasons  │    │  Action      │    │  Approval  │    │  Action      │
└──────────┘    └──────────────┘    │  (Task     │    └──────────────┘
                                     │   Token)   │
                                     └─────┬──────┘
                                           │
                                     ┌─────▼──────┐
                                     │  Human     │
                                     │  Reviews   │
                                     │  via UI    │
                                     └────────────┘
```

Step Functions **Task Tokens** enable human-in-the-loop by pausing execution until an external system (the human reviewer) sends a success or failure callback.

```python
# Lambda that pauses for human approval
def request_approval(event, context):
    task_token = event["taskToken"]
    proposed_action = event["proposedAction"]
    
    # Store task token and send notification to reviewer
    sns = boto3.client("sns")
    sns.publish(
        TopicArn="arn:aws:sns:us-east-1:123456789:approval-requests",
        Message=json.dumps({
            "action": proposed_action,
            "task_token": task_token,
            "approval_url": f"https://app.example.com/approve/{task_token}"
        })
    )

# Human approves via API Gateway endpoint
def approve_action(event, context):
    body = json.loads(event["body"])
    sfn = boto3.client("stepfunctions")
    
    if body["approved"]:
        sfn.send_task_success(
            taskToken=body["task_token"],
            output=json.dumps({"approved": True, "reviewer": body["reviewer"]})
        )
    else:
        sfn.send_task_failure(
            taskToken=body["task_token"],
            error="RejectedByHuman",
            cause=body.get("reason", "No reason provided")
        )
```

### API Gateway for Feedback Collection

```python
# API Gateway + Lambda for collecting user feedback on agent responses
def collect_feedback(event, context):
    body = json.loads(event["body"])
    
    dynamodb = boto3.resource("dynamodb")
    table = dynamodb.Table("agent-feedback")
    table.put_item(Item={
        "interaction_id": body["interaction_id"],
        "rating": body["rating"],  # thumbs_up / thumbs_down
        "comment": body.get("comment", ""),
        "timestamp": datetime.now().isoformat(),
        "agent_response": body["response_text"],
        "model_id": body["model_id"]
    })
    
    return {"statusCode": 200, "body": json.dumps({"status": "recorded"})}
```

> **EXAM TIP:** For human-in-the-loop, Step Functions with **Task Tokens** is the exam's preferred pattern. The workflow pauses at a Task state using `.waitForTaskToken`, and resumes when the human sends `SendTaskSuccess` or `SendTaskFailure`. This is testable content — know the API calls.

---

# Task 2.2: Implement Model Deployment Strategies

## Lambda Functions for On-Demand FM Invocation

Lambda is the simplest deployment pattern for FM access — no infrastructure management, pay-per-invocation.

```python
import boto3
import json

bedrock = boto3.client("bedrock-runtime", region_name="us-east-1")

def lambda_handler(event, context):
    response = bedrock.invoke_model(
        modelId="anthropic.claude-sonnet-4-20250514",
        contentType="application/json",
        accept="application/json",
        body=json.dumps({
            "anthropic_version": "bedrock-2023-05-31",
            "messages": [{"role": "user", "content": event["prompt"]}],
            "max_tokens": 1024,
            "temperature": 0.7
        })
    )
    
    result = json.loads(response["body"].read())
    return {
        "statusCode": 200,
        "body": json.dumps({
            "response": result["content"][0]["text"],
            "usage": result["usage"]
        })
    }
```

### Lambda Considerations for FM Invocation

| Factor | Recommendation |
|--------|---------------|
| **Timeout** | Set to 5-15 minutes for large model invocations (max 15 min) |
| **Memory** | 512 MB - 1 GB typically sufficient (Bedrock API call, not model hosting) |
| **Concurrency** | Use reserved concurrency to match Bedrock quotas |
| **Cold Start** | Use provisioned concurrency for latency-sensitive applications |
| **Retry** | Configure dead-letter queue for failed invocations |

> **EXAM TIP:** Lambda invoking Bedrock is fundamentally different from Lambda hosting a model. Lambda + Bedrock = API call (low memory, fast). Lambda + SageMaker endpoint = API call. Lambda cannot host LLMs directly due to size/GPU constraints. The exam will test this distinction.

---

## Amazon Bedrock Provisioned Throughput

Provisioned throughput reserves dedicated model capacity, guaranteeing consistent performance and enabling cost savings at scale.

### On-Demand vs. Provisioned vs. Batch

| Mode | Latency | Cost Model | Use Case |
|------|---------|------------|----------|
| **On-Demand** | Variable (shared capacity) | Per-token | Prototyping, variable traffic |
| **Provisioned Throughput** | Consistent (dedicated) | Hourly rate per model unit | Production, predictable traffic |
| **Batch Inference** | Hours | ~50% discount | Bulk processing, non-real-time |
| **Cross-Region Inference** | Variable | Per-token, multi-region | High availability, traffic overflow |

### Provisioned Throughput Configuration

```python
bedrock = boto3.client("bedrock")

# Create provisioned throughput
response = bedrock.create_provisioned_model_throughput(
    modelUnits=1,  # Number of model units
    provisionedModelName="my-claude-dedicated",
    modelId="anthropic.claude-sonnet-4-20250514",
    commitmentDuration="OneMonth"  # or "SixMonths" or "NoCommitment"
)

provisioned_arn = response["provisionedModelArn"]

# Invoke using provisioned ARN
bedrock_runtime = boto3.client("bedrock-runtime")
response = bedrock_runtime.invoke_model(
    modelId=provisioned_arn,  # Use provisioned ARN, not base model ID
    body=json.dumps({...})
)
```

### Cross-Region Inference

Cross-region inference automatically routes requests to available capacity across regions, providing higher throughput and availability without code changes.

```python
# Create inference profile for cross-region
bedrock = boto3.client("bedrock")

# Use system-defined cross-region inference profile
response = bedrock_runtime.invoke_model(
    modelId="us.anthropic.claude-sonnet-4-20250514",  # "us." prefix = cross-region
    body=json.dumps({...})
)
```

> **EXAM TIP:** Cross-region inference uses a region prefix (`us.`, `eu.`) before the model ID. It distributes requests across regions transparently. Know that data may traverse regions — this has compliance implications for regulated industries. The exam may test scenarios where cross-region inference is inappropriate (e.g., data residency requirements).

---

## SageMaker AI Endpoints for Hybrid Solutions

SageMaker endpoints provide full control over model hosting — custom models, fine-tuned models, or models not available on Bedrock.

### Endpoint Types

| Type | Scaling | Cost | Use Case |
|------|---------|------|----------|
| **Real-time** | Auto-scaling (1+ instances always running) | Per-instance-hour | Low-latency production |
| **Serverless** | Scale to zero | Per-invocation + cold start | Intermittent traffic |
| **Async** | Queue-based | Per-instance-hour | Large payloads, batch-like |

### Deploying a Custom FM on SageMaker

```python
import sagemaker
from sagemaker.huggingface import HuggingFaceModel

role = sagemaker.get_execution_role()

model = HuggingFaceModel(
    model_data="s3://my-bucket/models/my-fine-tuned-llm/model.tar.gz",
    role=role,
    transformers_version="4.37",
    pytorch_version="2.1",
    py_version="py310",
    env={
        "HF_MODEL_ID": "my-model",
        "SM_NUM_GPUS": "4",
        "MAX_INPUT_LENGTH": "4096",
        "MAX_TOTAL_TOKENS": "8192",
        "MAX_BATCH_PREFILL_TOKENS": "8192"
    }
)

predictor = model.deploy(
    initial_instance_count=1,
    instance_type="ml.g5.12xlarge",
    endpoint_name="my-custom-fm-endpoint",
    container_startup_health_check_timeout=600
)
```

---

## Container-Based Deployment for LLMs

### Model Deployment Decision Tree

```
                        Deploy an FM?
                            │
                ┌───────────┼───────────────┐
                ▼           ▼               ▼
          Available on   Custom /        Edge /
          Bedrock?       Fine-tuned?     On-prem?
                │           │               │
           Yes  │     Yes   │          Yes  │
                ▼           ▼               ▼
          ┌──────────┐  ┌────────────┐  ┌────────────────┐
          │ Bedrock  │  │ SageMaker  │  │ ECS/EKS on     │
          │ (On-     │  │ Endpoint   │  │ Outposts or    │
          │  Demand  │  │            │  │ Wavelength     │
          │  or PT)  │  │            │  └────────────────┘
          └──────────┘  └────────────┘
                │           │
          Need dedicated    │
          capacity?         │
                │           │
           Yes  │  No       │
                ▼  ▼        │
          PT    On-Demand   │
                            │
                      ┌─────┼──────────┐
                      ▼     ▼          ▼
               Real-time  Serverless  Async
               (low       (variable   (batch
                latency)   traffic)    jobs)
```

### GPU and Memory Considerations

| Model Size | GPU Memory Needed | Recommended Instance | Notes |
|------------|------------------|---------------------|-------|
| 7B params | ~14 GB (FP16) | ml.g5.2xlarge (24 GB) | Single GPU sufficient |
| 13B params | ~26 GB (FP16) | ml.g5.4xlarge (24 GB) or ml.g5.12xlarge (96 GB) | May need quantization for single GPU |
| 70B params | ~140 GB (FP16) | ml.p4d.24xlarge (8x40 GB) | Multi-GPU with tensor parallelism |
| 70B quantized (INT4) | ~35 GB | ml.g5.12xlarge (96 GB) | Quantization reduces memory 4x |

### Model Loading Strategies

| Strategy | Description | Trade-off |
|----------|-------------|-----------|
| **Eager Loading** | Load full model into GPU memory at startup | Slow startup, fast inference |
| **Lazy Loading** | Load model layers on demand | Fast startup, slower first inference |
| **Streaming from S3** | Stream model weights directly from S3 | Reduces local storage needs |
| **Model Caching** | Cache model in instance storage after first load | Fast subsequent startups |
| **Quantization** | Reduce precision (FP32 → FP16 → INT8 → INT4) | Reduces memory and improves throughput at slight quality cost |

> **EXAM TIP:** For container-based deployment, remember: **model parameters × bytes per parameter = GPU memory needed**. FP16 = 2 bytes/param, INT8 = 1 byte/param, INT4 = 0.5 bytes/param. A 70B model in FP16 needs ~140 GB GPU memory. The exam loves this calculation.

---

## Model Cascading in Production

```python
class ModelCascade:
    """Route queries through increasingly capable (and expensive) models."""
    
    def __init__(self):
        self.bedrock = boto3.client("bedrock-runtime")
        self.tiers = [
            {
                "model_id": "amazon.titan-text-lite-v1",
                "max_tokens": 512,
                "cost_per_1k_tokens": 0.0003,
                "capabilities": ["simple_qa", "classification"]
            },
            {
                "model_id": "anthropic.claude-3-haiku-20240307",
                "max_tokens": 2048,
                "cost_per_1k_tokens": 0.00025,
                "capabilities": ["moderate_reasoning", "summarization"]
            },
            {
                "model_id": "anthropic.claude-sonnet-4-20250514",
                "max_tokens": 4096,
                "cost_per_1k_tokens": 0.003,
                "capabilities": ["complex_reasoning", "code_generation", "analysis"]
            }
        ]
    
    def invoke(self, prompt: str, task_complexity: str = "auto"):
        if task_complexity == "auto":
            complexity = self._classify_complexity(prompt)
        else:
            complexity = task_complexity
        
        for tier in self.tiers:
            if complexity in tier["capabilities"]:
                return self._invoke_model(tier["model_id"], prompt, tier["max_tokens"])
        
        return self._invoke_model(self.tiers[-1]["model_id"], prompt, 4096)
```

> **EXAM TIP:** Model cascading and model routing are distinct concepts. **Cascading** = try small first, escalate if needed (serial). **Routing** = classify the request upfront and send to the right model (parallel paths). Both optimize cost, but cascading adds latency for escalated requests.

---

# Task 2.3: Design and Implement Enterprise Integration Architectures

## Enterprise Integration Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        Enterprise Integration Layer                          │
│                                                                              │
│  ┌──────────────┐  ┌───────────────┐  ┌────────────────┐  ┌─────────────┐  │
│  │  Legacy ERP  │  │  CRM System   │  │  Data Lake     │  │  SaaS Apps  │  │
│  │  (REST API)  │  │  (Webhook)    │  │  (S3 + Glue)   │  │  (OAuth)    │  │
│  └──────┬───────┘  └───────┬───────┘  └───────┬────────┘  └──────┬──────┘  │
│         │                  │                   │                   │         │
│         ▼                  ▼                   ▼                   ▼         │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │                     API Gateway (REST / WebSocket)                    │   │
│  │    - Authentication (Cognito / IAM / Lambda Authorizer)              │   │
│  │    - Rate Limiting    - Request Validation    - CORS                 │   │
│  └──────────────────────────────┬───────────────────────────────────────┘   │
│                                 │                                            │
│         ┌───────────────────────┼───────────────────────┐                   │
│         ▼                       ▼                       ▼                   │
│  ┌──────────────┐    ┌──────────────────┐    ┌──────────────────┐          │
│  │   Lambda     │    │   EventBridge    │    │   Step Functions │          │
│  │  (Sync API)  │    │  (Async Events)  │    │  (Orchestration) │          │
│  └──────┬───────┘    └────────┬─────────┘    └────────┬─────────┘          │
│         │                     │                        │                    │
│         └─────────────────────┼────────────────────────┘                    │
│                               ▼                                             │
│                    ┌──────────────────────┐                                  │
│                    │   GenAI Gateway      │                                  │
│                    │   (Centralized FM    │                                  │
│                    │    Access Layer)     │                                  │
│                    └──────────┬───────────┘                                  │
│                               │                                             │
│              ┌────────────────┼────────────────┐                            │
│              ▼                ▼                 ▼                            │
│       ┌───────────┐   ┌────────────┐   ┌──────────────┐                    │
│       │  Bedrock  │   │  SageMaker │   │  External    │                    │
│       │  Models   │   │  Endpoints │   │  FM APIs     │                    │
│       └───────────┘   └────────────┘   └──────────────┘                    │
└─────────────────────────────────────────────────────────────────────────────┘
```

## API-Based Integrations with Legacy Systems

### REST API Integration Pattern

```python
# Lambda function bridging legacy ERP with GenAI
def erp_integration_handler(event, context):
    """Bridge between legacy ERP REST API and GenAI agent."""
    
    # Validate and transform incoming request
    request_body = json.loads(event["body"])
    
    # Call legacy ERP API
    erp_response = requests.get(
        f"{ERP_BASE_URL}/api/v1/orders/{request_body['order_id']}",
        headers={"Authorization": f"Bearer {get_erp_token()}"},
        timeout=30
    )
    
    if erp_response.status_code != 200:
        return {"statusCode": 502, "body": "ERP system unavailable"}
    
    order_data = erp_response.json()
    
    # Enrich with GenAI analysis
    bedrock = boto3.client("bedrock-runtime")
    analysis = bedrock.invoke_model(
        modelId="anthropic.claude-sonnet-4-20250514",
        body=json.dumps({
            "anthropic_version": "bedrock-2023-05-31",
            "messages": [{
                "role": "user",
                "content": f"Analyze this order for anomalies: {json.dumps(order_data)}"
            }],
            "max_tokens": 1024
        })
    )
    
    return {
        "statusCode": 200,
        "body": json.dumps({
            "order": order_data,
            "ai_analysis": json.loads(analysis["body"].read())["content"][0]["text"]
        })
    }
```

## Event-Driven Architectures

### EventBridge for Loose Coupling

```python
# Publishing GenAI events to EventBridge
eventbridge = boto3.client("events")

def publish_inference_event(model_id, prompt, response, latency_ms):
    eventbridge.put_events(Entries=[{
        "Source": "genai.inference",
        "DetailType": "InferenceCompleted",
        "Detail": json.dumps({
            "model_id": model_id,
            "prompt_tokens": count_tokens(prompt),
            "response_tokens": count_tokens(response),
            "latency_ms": latency_ms,
            "timestamp": datetime.now().isoformat()
        }),
        "EventBusName": "genai-events"
    }])

# EventBridge rule for routing
# Rule: Route all inference events to analytics
{
    "source": ["genai.inference"],
    "detail-type": ["InferenceCompleted"],
    "detail": {
        "latency_ms": [{"numeric": [">", 5000]}]
    }
}
# Target: SNS topic for alerting on slow inferences
```

### Data Synchronization Patterns

| Pattern | Implementation | Use Case |
|---------|---------------|----------|
| **Request-Reply** | API Gateway → Lambda → Bedrock → Response | Synchronous user interactions |
| **Event-Sourcing** | EventBridge → Lambda → S3 (event log) | Audit trail for all FM interactions |
| **CQRS** | Write: SQS → Lambda → DynamoDB; Read: DynamoDB → API | Separate read/write for high-throughput |
| **Saga** | Step Functions orchestrating distributed transactions | Multi-system updates with compensation |
| **CDC** | DynamoDB Streams → Lambda → Knowledge Base sync | Keep vector store in sync with operational DB |

---

## Identity Federation and Access Control

### Role-Based Access Control for FM Access

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "DataScientistAccess",
            "Effect": "Allow",
            "Action": [
                "bedrock:InvokeModel",
                "bedrock:InvokeModelWithResponseStream"
            ],
            "Resource": [
                "arn:aws:bedrock:*::foundation-model/anthropic.claude-*",
                "arn:aws:bedrock:*::foundation-model/amazon.titan-*"
            ],
            "Condition": {
                "StringEquals": {
                    "aws:PrincipalTag/Department": "data-science"
                },
                "NumericLessThanEquals": {
                    "bedrock:MaxTokens": "4096"
                }
            }
        },
        {
            "Sid": "DenyExpensiveModels",
            "Effect": "Deny",
            "Action": "bedrock:InvokeModel",
            "Resource": "arn:aws:bedrock:*::foundation-model/anthropic.claude-opus-*",
            "Condition": {
                "StringNotEquals": {
                    "aws:PrincipalTag/Role": "senior-architect"
                }
            }
        }
    ]
}
```

### Cognito Integration for User-Scoped FM Access

```python
# API Gateway with Cognito authorizer for FM access
# Each user gets scoped permissions based on Cognito groups

def invoke_with_user_context(event, context):
    claims = event["requestContext"]["authorizer"]["claims"]
    user_groups = claims.get("cognito:groups", "").split(",")
    
    # Determine model access based on user group
    allowed_models = {
        "basic-users": ["amazon.titan-text-lite-v1"],
        "power-users": ["amazon.titan-text-lite-v1", "anthropic.claude-3-haiku-20240307"],
        "admins": ["anthropic.claude-sonnet-4-20250514", "anthropic.claude-3-haiku-20240307"]
    }
    
    requested_model = json.loads(event["body"])["model_id"]
    user_allowed = any(
        requested_model in allowed_models.get(group, [])
        for group in user_groups
    )
    
    if not user_allowed:
        return {"statusCode": 403, "body": "Model access denied for your user group"}
    
    # Proceed with invocation
    ...
```

> **EXAM TIP:** The exam heavily tests **least privilege** for FM access. Use IAM conditions like `bedrock:MaxTokens` and resource-level permissions scoped to specific model ARNs. Cognito user pool groups map to IAM roles, enabling user-tier-based model access. Know this pattern cold.

---

## Edge and On-Premises Deployments

### AWS Outposts for On-Premises Data

When data cannot leave the premises (regulatory, sovereignty), use Outposts to run SageMaker endpoints on-prem while still using AWS management APIs.

### AWS Wavelength for Edge

Wavelength zones place compute at 5G carrier edge locations — use for ultra-low-latency inference at the edge (e.g., real-time AR/VR with GenAI).

| Service | Location | Use Case |
|---------|----------|----------|
| **Outposts** | Customer data center | Data sovereignty, air-gapped environments |
| **Wavelength** | 5G carrier edge | Ultra-low latency mobile inference |
| **Local Zones** | Metro areas | Regional low-latency inference |
| **Hybrid (VPN/Direct Connect)** | Split | On-prem data + cloud inference |

---

## CI/CD Pipelines for Generative AI

### GenAI CI/CD Pipeline Architecture

```
┌──────────────────────────────────────────────────────────────────────────┐
│                    GenAI CI/CD Pipeline                                    │
│                                                                           │
│  ┌─────────┐    ┌──────────────┐    ┌──────────────┐    ┌────────────┐  │
│  │  Source  │───▶│    Build     │───▶│    Test      │───▶│   Deploy   │  │
│  │         │    │              │    │              │    │            │  │
│  │ CodeCommit│    │  CodeBuild   │    │  CodeBuild   │    │ CodeDeploy │  │
│  │ / GitHub │    │              │    │              │    │ / CFN      │  │
│  └─────────┘    └──────────────┘    └──────────────┘    └────────────┘  │
│       │               │                    │                  │          │
│       │          ┌────┴─────┐        ┌─────┴──────┐    ┌────┴─────┐    │
│       │          │ Package  │        │ Prompt     │    │ Canary / │    │
│       │          │ Lambda   │        │ Regression │    │ Blue-    │    │
│       │          │ / Docker │        │ Tests      │    │ Green    │    │
│       │          └──────────┘        │            │    └──────────┘    │
│       │                              │ Model Eval │                    │
│       │                              │ Tests      │                    │
│       │                              │            │                    │
│       │                              │ Integration│                    │
│       │                              │ Tests      │                    │
│       │                              └────────────┘                    │
│       │                                                                │
│  ┌────┴──────────────────────────────────────────────────────────┐     │
│  │              CodePipeline (Orchestration)                      │     │
│  │                                                                │     │
│  │  Source ──▶ Build ──▶ PromptTest ──▶ ModelEval ──▶ Deploy     │     │
│  │                                          │                     │     │
│  │                                    ┌─────▼──────┐              │     │
│  │                                    │  Manual     │              │     │
│  │                                    │  Approval   │              │     │
│  │                                    │  Gate       │              │     │
│  │                                    └────────────┘              │     │
│  └────────────────────────────────────────────────────────────────┘     │
└──────────────────────────────────────────────────────────────────────────┘
```

### GenAI-Specific Testing Stages

```yaml
# buildspec.yml for prompt regression testing
version: 0.2
phases:
  install:
    commands:
      - pip install boto3 pytest deepeval
  build:
    commands:
      # Run prompt regression tests
      - pytest tests/prompt_regression/ -v --junitxml=reports/prompt_tests.xml
      
      # Run model evaluation suite
      - python scripts/evaluate_model.py \
          --model-id anthropic.claude-sonnet-4-20250514 \
          --test-suite tests/eval_suite.json \
          --threshold 0.85 \
          --output reports/eval_results.json
      
      # Run integration tests against staging
      - pytest tests/integration/ -v --junitxml=reports/integration_tests.xml

reports:
  prompt-tests:
    files:
      - reports/prompt_tests.xml
    file-format: JUNITXML
```

### Prompt Version Management

```python
# Store prompts in SSM Parameter Store with versioning
ssm = boto3.client("ssm")

def deploy_prompt(name: str, prompt_text: str, version_note: str):
    ssm.put_parameter(
        Name=f"/genai/prompts/{name}",
        Value=prompt_text,
        Type="String",
        Overwrite=True,
        Description=version_note
    )

def get_prompt(name: str, version: int = None) -> str:
    params = {"Name": f"/genai/prompts/{name}"}
    if version:
        params["Name"] += f":{version}"
    response = ssm.get_parameter(**params)
    return response["Parameter"]["Value"]
```

> **EXAM TIP:** GenAI CI/CD adds **prompt regression testing** and **model evaluation** stages that don't exist in traditional CI/CD. Prompts should be versioned (SSM Parameter Store or S3), and every pipeline should include automated evaluation against a golden test set. The exam tests your understanding of what makes GenAI CI/CD different from standard CI/CD.

---

## GenAI Gateway Architecture

A GenAI gateway is a centralized layer that mediates all FM access across the organization.

```
┌──────────────────────────────────────────────────────────────┐
│                     GenAI Gateway                             │
│                                                               │
│  ┌─────────────┐  ┌──────────────┐  ┌────────────────────┐  │
│  │   Auth &    │  │   Rate       │  │   Cost Tracking    │  │
│  │   RBAC      │  │   Limiting   │  │   & Metering       │  │
│  └─────────────┘  └──────────────┘  └────────────────────┘  │
│                                                               │
│  ┌─────────────┐  ┌──────────────┐  ┌────────────────────┐  │
│  │   Request   │  │   PII        │  │   Model Routing    │  │
│  │   Logging   │  │   Filtering  │  │   & Fallback       │  │
│  └─────────────┘  └──────────────┘  └────────────────────┘  │
│                                                               │
│  ┌─────────────┐  ┌──────────────┐  ┌────────────────────┐  │
│  │   Prompt    │  │   Response   │  │   Guardrails       │  │
│  │   Caching   │  │   Caching    │  │   Enforcement      │  │
│  └─────────────┘  └──────────────┘  └────────────────────┘  │
└───────────────────────────┬──────────────────────────────────┘
                            │
               ┌────────────┼────────────┐
               ▼            ▼            ▼
         ┌──────────┐ ┌──────────┐ ┌──────────┐
         │ Bedrock  │ │ SageMaker│ │ External │
         │ Models   │ │ Endpoints│ │ APIs     │
         └──────────┘ └──────────┘ └──────────┘
```

### Gateway Implementation

```python
# API Gateway + Lambda as GenAI Gateway
def gateway_handler(event, context):
    body = json.loads(event["body"])
    user_context = extract_user_context(event)
    
    # 1. Authentication & Authorization
    if not authorize_user(user_context, body["model_id"]):
        return {"statusCode": 403, "body": "Unauthorized model access"}
    
    # 2. Rate limiting (using DynamoDB or ElastiCache)
    if is_rate_limited(user_context["user_id"], body["model_id"]):
        return {"statusCode": 429, "body": "Rate limit exceeded"}
    
    # 3. PII detection and filtering
    sanitized_prompt = detect_and_mask_pii(body["prompt"])
    
    # 4. Guardrails check
    guardrail_result = apply_bedrock_guardrails(sanitized_prompt)
    if guardrail_result["action"] == "BLOCKED":
        return {"statusCode": 400, "body": "Content policy violation"}
    
    # 5. Check cache
    cache_key = compute_cache_key(body["model_id"], sanitized_prompt)
    cached_response = check_cache(cache_key)
    if cached_response:
        return {"statusCode": 200, "body": cached_response}
    
    # 6. Route to model
    response = invoke_model(body["model_id"], sanitized_prompt, body.get("params", {}))
    
    # 7. Log for observability
    log_inference(user_context, body, response)
    
    # 8. Track cost
    track_cost(user_context["team_id"], body["model_id"], response["usage"])
    
    # 9. Cache response
    cache_response(cache_key, response)
    
    return {"statusCode": 200, "body": json.dumps(response)}
```

> **EXAM TIP:** A GenAI gateway provides: (1) centralized auth, (2) rate limiting, (3) cost tracking per team/user, (4) PII filtering, (5) guardrails enforcement, (6) model routing/fallback, (7) caching, (8) observability. The exam will test scenarios where a gateway solves organizational governance challenges around FM usage.

---

# Task 2.4: Implement FM API Integrations

## Amazon Bedrock APIs

### Synchronous Invocation

```python
bedrock_runtime = boto3.client("bedrock-runtime")

# Synchronous invoke
response = bedrock_runtime.invoke_model(
    modelId="anthropic.claude-sonnet-4-20250514",
    contentType="application/json",
    accept="application/json",
    body=json.dumps({
        "anthropic_version": "bedrock-2023-05-31",
        "messages": [
            {"role": "user", "content": "Explain quantum computing in simple terms"}
        ],
        "max_tokens": 1024,
        "temperature": 0.7,
        "top_p": 0.9,
        "stop_sequences": ["\n\nHuman:"]
    })
)

result = json.loads(response["body"].read())
print(result["content"][0]["text"])
print(f"Input tokens: {result['usage']['input_tokens']}")
print(f"Output tokens: {result['usage']['output_tokens']}")
```

### Converse API (Unified Interface)

The Converse API provides a model-agnostic interface — same code works across all Bedrock models.

```python
response = bedrock_runtime.converse(
    modelId="anthropic.claude-sonnet-4-20250514",
    messages=[
        {
            "role": "user",
            "content": [
                {"text": "Describe this architecture diagram"},
                {
                    "image": {
                        "format": "png",
                        "source": {"bytes": image_bytes}
                    }
                }
            ]
        }
    ],
    inferenceConfig={
        "maxTokens": 2048,
        "temperature": 0.5,
        "topP": 0.9,
        "stopSequences": []
    },
    toolConfig={
        "tools": [{
            "toolSpec": {
                "name": "get_weather",
                "description": "Get current weather for a location",
                "inputSchema": {
                    "json": {
                        "type": "object",
                        "properties": {
                            "location": {"type": "string", "description": "City name"}
                        },
                        "required": ["location"]
                    }
                }
            }
        }]
    }
)
```

> **EXAM TIP:** Know the difference between `InvokeModel` and `Converse` APIs. **InvokeModel** uses model-specific request/response formats. **Converse** uses a unified format across all models. For new applications, AWS recommends the Converse API. On the exam, if you need model portability or multi-model support, Converse is the answer.

### Async Processing with SQS

```python
# Producer: Queue FM requests
sqs = boto3.client("sqs")

def queue_inference_request(request_id, prompt, model_id):
    sqs.send_message(
        QueueUrl=QUEUE_URL,
        MessageBody=json.dumps({
            "request_id": request_id,
            "prompt": prompt,
            "model_id": model_id,
            "timestamp": datetime.now().isoformat()
        }),
        MessageGroupId=model_id,  # FIFO queue, group by model
        MessageDeduplicationId=request_id
    )

# Consumer: Lambda triggered by SQS
def process_inference(event, context):
    for record in event["Records"]:
        message = json.loads(record["body"])
        
        response = bedrock_runtime.invoke_model(
            modelId=message["model_id"],
            body=json.dumps({
                "anthropic_version": "bedrock-2023-05-31",
                "messages": [{"role": "user", "content": message["prompt"]}],
                "max_tokens": 1024
            })
        )
        
        # Store result
        dynamodb.put_item(
            TableName="inference-results",
            Item={
                "request_id": message["request_id"],
                "result": json.loads(response["body"].read())["content"][0]["text"],
                "completed_at": datetime.now().isoformat()
            }
        )
```

---

## Streaming APIs

### Streaming API Architecture

```
┌────────────┐    ┌─────────────────┐    ┌──────────────┐    ┌────────────┐
│            │    │                 │    │              │    │            │
│   Client   │◀══▶│   API Gateway   │◀══▶│    Lambda    │◀──▶│  Bedrock   │
│  (Browser) │    │   (WebSocket)   │    │  (Streaming) │    │ (Streaming)│
│            │    │                 │    │              │    │            │
└────────────┘    └─────────────────┘    └──────────────┘    └────────────┘
     │                    │                     │                    │
     │   WebSocket        │    Lambda invoke    │   InvokeModel     │
     │   Connection       │    Response Stream  │   WithResponse    │
     │◀──────────────────▶│◀───────────────────▶│   Stream          │
     │                    │                     │◀──────────────────▶│
     │   Chunked tokens   │                     │   Token chunks    │
     │◀══════════════════╗│                     │◀═════════════════╗│
     │                   ║│                     │                  ║│
     │   "The"           ║│                     │                  ║│
     │   "The quick"     ║│                     │                  ║│
     │   "The quick brown║│                     │                  ║│
     │   ...             ║│                     │                  ║│
     │                   ║│                     │                  ║│
     └───────────────────╝└─────────────────────┘──────────────────╝│
```

### Bedrock Streaming with Python

```python
# Streaming with invoke_model_with_response_stream
response = bedrock_runtime.invoke_model_with_response_stream(
    modelId="anthropic.claude-sonnet-4-20250514",
    body=json.dumps({
        "anthropic_version": "bedrock-2023-05-31",
        "messages": [{"role": "user", "content": "Write a long essay about AI"}],
        "max_tokens": 4096
    })
)

# Process stream chunks
full_response = ""
for event in response["body"]:
    chunk = json.loads(event["chunk"]["bytes"])
    if chunk["type"] == "content_block_delta":
        text = chunk["delta"]["text"]
        full_response += text
        print(text, end="", flush=True)  # Real-time output
    elif chunk["type"] == "message_stop":
        break
```

### Converse Stream API

```python
response = bedrock_runtime.converse_stream(
    modelId="anthropic.claude-sonnet-4-20250514",
    messages=[{"role": "user", "content": [{"text": "Explain transformers"}]}],
    inferenceConfig={"maxTokens": 2048}
)

for event in response["stream"]:
    if "contentBlockDelta" in event:
        text = event["contentBlockDelta"]["delta"]["text"]
        print(text, end="", flush=True)
    elif "messageStop" in event:
        print("\n[Stream complete]")
    elif "metadata" in event:
        usage = event["metadata"]["usage"]
        print(f"\nTokens: {usage['inputTokens']} in, {usage['outputTokens']} out")
```

### WebSocket Streaming via API Gateway

```python
# Lambda function handling WebSocket messages
import boto3

apigw = boto3.client("apigatewaymanagementapi",
                      endpoint_url=f"https://{API_ID}.execute-api.{REGION}.amazonaws.com/{STAGE}")

def handle_message(event, context):
    connection_id = event["requestContext"]["connectionId"]
    body = json.loads(event["body"])
    
    response = bedrock_runtime.invoke_model_with_response_stream(
        modelId=body["model_id"],
        body=json.dumps({
            "anthropic_version": "bedrock-2023-05-31",
            "messages": body["messages"],
            "max_tokens": body.get("max_tokens", 1024)
        })
    )
    
    for event_chunk in response["body"]:
        chunk = json.loads(event_chunk["chunk"]["bytes"])
        if chunk["type"] == "content_block_delta":
            apigw.post_to_connection(
                ConnectionId=connection_id,
                Data=json.dumps({
                    "type": "token",
                    "text": chunk["delta"]["text"]
                })
            )
    
    apigw.post_to_connection(
        ConnectionId=connection_id,
        Data=json.dumps({"type": "done"})
    )
```

### Server-Sent Events (SSE) Pattern

```python
# Lambda function URL with response streaming for SSE
def handler(event, context):
    prompt = json.loads(event["body"])["prompt"]
    
    response = bedrock_runtime.invoke_model_with_response_stream(
        modelId="anthropic.claude-sonnet-4-20250514",
        body=json.dumps({
            "anthropic_version": "bedrock-2023-05-31",
            "messages": [{"role": "user", "content": prompt}],
            "max_tokens": 2048
        })
    )
    
    def generate():
        for event_chunk in response["body"]:
            chunk = json.loads(event_chunk["chunk"]["bytes"])
            if chunk["type"] == "content_block_delta":
                yield f"data: {json.dumps({'text': chunk['delta']['text']})}\n\n"
        yield "data: [DONE]\n\n"
    
    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "text/event-stream",
            "Cache-Control": "no-cache",
            "Connection": "keep-alive"
        },
        "body": generate(),
        "isBase64Encoded": False
    }
```

> **EXAM TIP:** Know the three streaming approaches: (1) **Lambda Function URL** with response streaming for SSE — simplest, (2) **API Gateway WebSocket** — bidirectional, persistent connections, (3) **API Gateway REST + chunked transfer encoding** — limited streaming support. For real-time chat, WebSocket is preferred. For one-way streaming, SSE via Lambda Function URL is simplest.

---

## Resilient FM Systems

### Exponential Backoff with Jitter

```python
import time
import random

def invoke_with_retry(model_id, body, max_retries=5, base_delay=1.0):
    for attempt in range(max_retries):
        try:
            response = bedrock_runtime.invoke_model(
                modelId=model_id, body=json.dumps(body)
            )
            return json.loads(response["body"].read())
        
        except bedrock_runtime.exceptions.ThrottlingException:
            if attempt == max_retries - 1:
                raise
            delay = base_delay * (2 ** attempt) + random.uniform(0, 1)
            time.sleep(delay)
        
        except bedrock_runtime.exceptions.ModelTimeoutException:
            if attempt == max_retries - 1:
                raise
            delay = base_delay * (2 ** attempt)
            time.sleep(delay)
        
        except bedrock_runtime.exceptions.ServiceUnavailableException:
            # Fallback to alternative model
            return invoke_fallback_model(body)
```

### Rate Limiting with Token Bucket

```python
import time

class TokenBucketRateLimiter:
    """Rate limiter for FM API calls using token bucket algorithm."""
    
    def __init__(self, rate_per_second: float, burst_size: int):
        self.rate = rate_per_second
        self.burst_size = burst_size
        self.tokens = burst_size
        self.last_refill = time.time()
    
    def acquire(self) -> bool:
        now = time.time()
        elapsed = now - self.last_refill
        self.tokens = min(self.burst_size, self.tokens + elapsed * self.rate)
        self.last_refill = now
        
        if self.tokens >= 1:
            self.tokens -= 1
            return True
        return False
    
    def wait_and_acquire(self):
        while not self.acquire():
            time.sleep(0.1)

rate_limiter = TokenBucketRateLimiter(rate_per_second=10, burst_size=20)

def rate_limited_invoke(model_id, body):
    rate_limiter.wait_and_acquire()
    return bedrock_runtime.invoke_model(modelId=model_id, body=json.dumps(body))
```

### Fallback Mechanisms

```python
class ModelFallbackChain:
    """Try models in order; fall back to next on failure."""
    
    def __init__(self):
        self.chain = [
            {"model_id": "anthropic.claude-sonnet-4-20250514", "priority": 1},
            {"model_id": "anthropic.claude-3-haiku-20240307", "priority": 2},
            {"model_id": "amazon.titan-text-express-v1", "priority": 3},
        ]
    
    def invoke(self, messages, max_tokens=1024):
        last_error = None
        for model_config in self.chain:
            try:
                response = bedrock_runtime.converse(
                    modelId=model_config["model_id"],
                    messages=messages,
                    inferenceConfig={"maxTokens": max_tokens}
                )
                return response, model_config["model_id"]
            except Exception as e:
                last_error = e
                continue
        raise last_error
```

### X-Ray Tracing for FM Calls

```python
from aws_xray_sdk.core import xray_recorder
from aws_xray_sdk.core import patch_all

patch_all()  # Auto-instrument boto3 calls

@xray_recorder.capture("invoke_fm")
def invoke_fm(prompt: str, model_id: str):
    subsegment = xray_recorder.current_subsegment()
    subsegment.put_metadata("model_id", model_id)
    subsegment.put_metadata("prompt_length", len(prompt))
    
    start = time.time()
    response = bedrock_runtime.invoke_model(
        modelId=model_id,
        body=json.dumps({
            "anthropic_version": "bedrock-2023-05-31",
            "messages": [{"role": "user", "content": prompt}],
            "max_tokens": 1024
        })
    )
    latency = time.time() - start
    
    result = json.loads(response["body"].read())
    subsegment.put_metadata("latency_seconds", latency)
    subsegment.put_metadata("input_tokens", result["usage"]["input_tokens"])
    subsegment.put_metadata("output_tokens", result["usage"]["output_tokens"])
    subsegment.put_annotation("model_id", model_id)
    
    return result
```

> **EXAM TIP:** X-Ray annotations are **indexed and searchable** (use for model_id, user_id). X-Ray metadata is **not indexed** (use for large payloads like prompts/responses). The exam will test whether you use annotations vs. metadata correctly. Also: `patch_all()` auto-instruments boto3 — no need to manually trace Bedrock calls.

---

## Model Routing

### Static Routing

```python
# Route based on predefined rules
ROUTING_RULES = {
    "code": "anthropic.claude-sonnet-4-20250514",
    "creative": "anthropic.claude-sonnet-4-20250514",
    "simple": "amazon.titan-text-lite-v1",
    "translation": "amazon.titan-text-express-v1",
}

def static_route(task_type: str) -> str:
    return ROUTING_RULES.get(task_type, "anthropic.claude-3-haiku-20240307")
```

### Dynamic Routing with Step Functions

```json
{
  "StartAt": "ClassifyRequest",
  "States": {
    "ClassifyRequest": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:123456789:function:classify-request",
      "Next": "RouteToModel"
    },
    "RouteToModel": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.classification",
          "StringEquals": "complex",
          "Next": "InvokeLargeModel"
        },
        {
          "Variable": "$.classification",
          "StringEquals": "simple",
          "Next": "InvokeSmallModel"
        }
      ],
      "Default": "InvokeMediumModel"
    },
    "InvokeLargeModel": {
      "Type": "Task",
      "Resource": "arn:aws:states:::bedrock:invokeModel",
      "Parameters": {
        "ModelId": "anthropic.claude-sonnet-4-20250514",
        "Body": {"S.$": "$.prompt"}
      },
      "End": true
    },
    "InvokeSmallModel": {
      "Type": "Task",
      "Resource": "arn:aws:states:::bedrock:invokeModel",
      "Parameters": {
        "ModelId": "amazon.titan-text-lite-v1",
        "Body": {"S.$": "$.prompt"}
      },
      "End": true
    },
    "InvokeMediumModel": {
      "Type": "Task",
      "Resource": "arn:aws:states:::bedrock:invokeModel",
      "Parameters": {
        "ModelId": "anthropic.claude-3-haiku-20240307",
        "Body": {"S.$": "$.prompt"}
      },
      "End": true
    }
  }
}
```

### Intelligent Routing Based on Metrics

```python
class IntelligentRouter:
    """Route to models based on real-time performance metrics."""
    
    def __init__(self):
        self.cloudwatch = boto3.client("cloudwatch")
        self.models = [
            "anthropic.claude-sonnet-4-20250514",
            "anthropic.claude-3-haiku-20240307",
            "amazon.titan-text-express-v1"
        ]
    
    def get_model_health(self, model_id: str) -> dict:
        metrics = self.cloudwatch.get_metric_data(
            MetricDataQueries=[
                {
                    "Id": "latency",
                    "MetricStat": {
                        "Metric": {
                            "Namespace": "AWS/Bedrock",
                            "MetricName": "InvocationLatency",
                            "Dimensions": [{"Name": "ModelId", "Value": model_id}]
                        },
                        "Period": 300,
                        "Stat": "p99"
                    }
                },
                {
                    "Id": "errors",
                    "MetricStat": {
                        "Metric": {
                            "Namespace": "AWS/Bedrock",
                            "MetricName": "InvocationThrottles",
                            "Dimensions": [{"Name": "ModelId", "Value": model_id}]
                        },
                        "Period": 300,
                        "Stat": "Sum"
                    }
                }
            ],
            StartTime=datetime.now() - timedelta(minutes=5),
            EndTime=datetime.now()
        )
        return {
            "latency_p99": metrics["MetricDataResults"][0]["Values"][0] if metrics["MetricDataResults"][0]["Values"] else 0,
            "throttles": metrics["MetricDataResults"][1]["Values"][0] if metrics["MetricDataResults"][1]["Values"] else 0
        }
    
    def select_model(self, task_type: str) -> str:
        health_scores = {}
        for model_id in self.models:
            health = self.get_model_health(model_id)
            score = 1.0 / (1.0 + health["latency_p99"] / 1000) * (1.0 / (1.0 + health["throttles"]))
            health_scores[model_id] = score
        
        return max(health_scores, key=health_scores.get)
```

> **EXAM TIP:** The exam distinguishes three routing levels: (1) **Static** — hardcoded rules, simplest, (2) **Dynamic** — Step Functions Choice state routing based on request classification, (3) **Intelligent** — real-time metrics-based routing using CloudWatch. Know when each is appropriate: static for fixed workloads, dynamic for varied request types, intelligent for high-availability production systems.

---

# Task 2.5: Implement Application Integration Patterns and Development Tools

## API Gateway for FM Applications

### Token Limit Management

```python
# API Gateway request transformation with Lambda authorizer
def token_limit_authorizer(event, context):
    """Enforce per-user token limits at the API Gateway layer."""
    
    token = event["authorizationToken"]
    user = validate_jwt(token)
    
    # Check remaining token budget
    dynamodb = boto3.resource("dynamodb")
    table = dynamodb.Table("user-token-budgets")
    budget = table.get_item(Key={"user_id": user["sub"]})["Item"]
    
    if budget["remaining_tokens"] <= 0:
        return generate_deny_policy(user["sub"], event["methodArn"])
    
    return generate_allow_policy(
        user["sub"],
        event["methodArn"],
        context={
            "remaining_tokens": str(budget["remaining_tokens"]),
            "max_tokens_per_request": str(budget["max_tokens_per_request"]),
            "user_tier": budget["tier"]
        }
    )
```

### Retry Strategies at API Gateway Level

```yaml
# API Gateway with usage plans for rate limiting
Resources:
  GenAIApi:
    Type: AWS::ApiGateway::RestApi
    Properties:
      Name: GenAI-API
  
  UsagePlan:
    Type: AWS::ApiGateway::UsagePlan
    Properties:
      UsagePlanName: BasicTier
      Throttle:
        BurstLimit: 10
        RateLimit: 5
      Quota:
        Limit: 1000
        Period: DAY
      ApiStages:
        - ApiId: !Ref GenAIApi
          Stage: prod

  PremiumUsagePlan:
    Type: AWS::ApiGateway::UsagePlan
    Properties:
      UsagePlanName: PremiumTier
      Throttle:
        BurstLimit: 100
        RateLimit: 50
      Quota:
        Limit: 50000
        Period: DAY
```

---

## AWS Amplify for GenAI UIs

Amplify provides declarative React components that integrate with Bedrock and other AWS services.

```typescript
// Amplify AI Kit - declarative chat UI with Bedrock backend
import { AIConversation } from "@aws-amplify/ui-react-ai";
import { generateClient } from "aws-amplify/api";
import { Schema } from "../amplify/data/resource";

const client = generateClient<Schema>();

export default function ChatPage() {
  const [
    { data: { messages }, isLoading },
    handleSendMessage
  ] = client.conversations.chat.useConversation();

  return (
    <AIConversation
      messages={messages}
      isLoading={isLoading}
      handleSendMessage={handleSendMessage}
      suggestedPrompts={[
        { header: "Summarize", inputText: "Summarize the latest report" },
        { header: "Analyze", inputText: "Analyze sales trends" }
      ]}
    />
  );
}
```

```typescript
// Amplify backend definition
// amplify/data/resource.ts
import { a, defineData } from "@aws-amplify/backend";

const schema = a.schema({
  chat: a.conversation({
    aiModel: a.ai.model("Claude 3.5 Sonnet"),
    systemPrompt: "You are a helpful business analyst assistant.",
    tools: [
      a.ai.dataTool({
        name: "searchKnowledgeBase",
        description: "Search internal documents",
        model: a.ref("Document"),
        modelOperation: "list"
      })
    ]
  }),
  
  Document: a.model({
    title: a.string(),
    content: a.string(),
    department: a.string()
  }).authorization(allow => [allow.authenticated()])
});

export type Schema = ReturnType<typeof schema>;
export const data = defineData({ schema });
```

> **EXAM TIP:** Amplify AI Kit provides **two patterns**: (1) `a.conversation()` for multi-turn chat interfaces with built-in streaming and tool use, (2) `a.generation()` for single-turn generation (e.g., summarize a document). Know which to use: conversation for chat UIs, generation for one-shot tasks.

---

## OpenAPI Specifications for API-First Development

```yaml
openapi: 3.0.3
info:
  title: GenAI Inference API
  version: 1.0.0
  description: API for invoking foundation models

paths:
  /invoke:
    post:
      summary: Invoke a foundation model
      operationId: invokeModel
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/InvokeRequest'
      responses:
        '200':
          description: Successful invocation
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/InvokeResponse'
        '429':
          description: Rate limit exceeded
        '503':
          description: Model unavailable

  /invoke/stream:
    post:
      summary: Invoke with streaming response
      operationId: invokeModelStream
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/InvokeRequest'
      responses:
        '200':
          description: Streaming response
          content:
            text/event-stream:
              schema:
                type: string

components:
  schemas:
    InvokeRequest:
      type: object
      required: [model_id, messages]
      properties:
        model_id:
          type: string
          enum:
            - anthropic.claude-sonnet-4-20250514
            - anthropic.claude-3-haiku-20240307
            - amazon.titan-text-express-v1
        messages:
          type: array
          items:
            $ref: '#/components/schemas/Message'
        max_tokens:
          type: integer
          minimum: 1
          maximum: 4096
          default: 1024
        temperature:
          type: number
          minimum: 0
          maximum: 1
          default: 0.7

    Message:
      type: object
      required: [role, content]
      properties:
        role:
          type: string
          enum: [user, assistant]
        content:
          type: string

    InvokeResponse:
      type: object
      properties:
        response:
          type: string
        model_id:
          type: string
        usage:
          type: object
          properties:
            input_tokens:
              type: integer
            output_tokens:
              type: integer
```

Use OpenAPI specs with API Gateway for request validation, SDK generation, and documentation.

---

## Amazon Bedrock Prompt Flows

Prompt Flows provide a visual, no-code interface for building multi-step FM workflows.

### Key Node Types

| Node Type | Purpose | Example |
|-----------|---------|---------|
| **Input** | Entry point, receives user input | User query |
| **Prompt** | Invokes an FM with a prompt template | Classify intent |
| **Condition** | Branches based on FM output | Route by sentiment |
| **Knowledge Base** | Retrieves from vector store | RAG retrieval |
| **Lambda** | Custom processing | Data transformation |
| **Collector** | Gathers outputs from multiple branches | Merge results |
| **Iterator** | Loops over a list | Process each document |
| **Output** | Returns final result | Formatted response |

### Flow Definition (API)

```python
bedrock_agent = boto3.client("bedrock-agent")

response = bedrock_agent.create_flow(
    name="document-analyzer",
    description="Analyzes documents with multi-step FM processing",
    executionRoleArn="arn:aws:iam::123456789:role/BedrockFlowRole",
    definition={
        "nodes": [
            {
                "name": "input",
                "type": "Input",
                "configuration": {
                    "input": {"document": {"type": "String"}}
                }
            },
            {
                "name": "classify",
                "type": "Prompt",
                "configuration": {
                    "prompt": {
                        "sourceConfiguration": {
                            "inline": {
                                "modelId": "anthropic.claude-3-haiku-20240307",
                                "templateType": "TEXT",
                                "templateConfiguration": {
                                    "text": {
                                        "text": "Classify this document: {{document}}\nCategories: technical, business, legal",
                                        "inputVariables": [{"name": "document"}]
                                    }
                                }
                            }
                        }
                    }
                }
            },
            {
                "name": "route",
                "type": "Condition",
                "configuration": {
                    "conditions": [
                        {"name": "isTechnical", "expression": "classification == 'technical'"},
                        {"name": "isBusiness", "expression": "classification == 'business'"}
                    ]
                }
            }
        ],
        "connections": [
            {"name": "c1", "source": "input", "target": "classify", "type": "Data"},
            {"name": "c2", "source": "classify", "target": "route", "type": "Data"}
        ]
    }
)
```

> **EXAM TIP:** Prompt Flows is the **no-code/low-code** answer for orchestrating FM workflows. If an exam question mentions business analysts or non-developers building FM workflows, Prompt Flows is the answer. For developers needing full control, use Strands Agents or Step Functions.

---

## Amazon Q Business

Amazon Q Business connects FMs to enterprise data sources for internal knowledge access.

### Supported Data Sources

| Category | Sources |
|----------|---------|
| **AWS** | S3, RDS, Aurora, DynamoDB, CloudWatch Logs |
| **Collaboration** | Slack, Microsoft Teams, Confluence, SharePoint |
| **Productivity** | Google Drive, OneDrive, Salesforce, Zendesk |
| **Code** | GitHub, GitLab, Bitbucket |
| **Databases** | PostgreSQL, MySQL, Oracle |

### Configuration

```python
qbusiness = boto3.client("qbusiness")

# Create application
app = qbusiness.create_application(
    displayName="Engineering Knowledge Base",
    roleArn="arn:aws:iam::123456789:role/QBusinessRole",
    identityCenterInstanceArn="arn:aws:sso:::instance/ssoins-XXXXX"
)

# Add data source
qbusiness.create_data_source(
    applicationId=app["applicationId"],
    indexId=index_id,
    displayName="Confluence Engineering Docs",
    configuration={
        "type": "CONFLUENCE",
        "confluenceConfiguration": {
            "sourceConfiguration": {
                "hostUrl": "https://mycompany.atlassian.net",
                "authType": "OAUTH2"
            },
            "spaceConfiguration": {
                "spaceFilter": ["ENG", "ARCH", "OPS"]
            }
        }
    },
    roleArn="arn:aws:iam::123456789:role/QBusinessDataSourceRole"
)
```

> **EXAM TIP:** Amazon Q Business provides **enterprise search with access control**. It respects the ACLs of the original data source — a user can only see search results from documents they have permission to access in the source system (e.g., Confluence, SharePoint). This is a key differentiator from building your own RAG.

---

## Amazon Bedrock Data Automation

Bedrock Data Automation extracts structured data from unstructured documents (PDFs, images, videos) using FMs.

```python
bedrock_data = boto3.client("bedrock-data-automation")

# Create a data automation project
project = bedrock_data.create_data_automation_project(
    projectName="invoice-processor",
    projectDescription="Extract data from invoices",
    standardOutputConfiguration={
        "document": {
            "extractionGranularity": {"types": ["DOCUMENT", "PAGE", "ELEMENT"]},
            "boundingBox": {"state": "ENABLED"}
        }
    },
    customOutputConfiguration={
        "blueprints": [{
            "blueprintArn": "arn:aws:bedrock:us-east-1:123456789:blueprint/invoice-extraction",
            "blueprintStage": "LIVE"
        }]
    }
)
```

---

## Amazon Q Developer

Q Developer assists with code generation, debugging, and GenAI-specific development.

### Key Capabilities for the Exam

| Feature | Description |
|---------|-------------|
| **Code Generation** | Generates code from natural language descriptions |
| **Code Transformation** | Upgrades code between language versions (e.g., Java 8 → 17) |
| **Security Scanning** | Identifies vulnerabilities in generated code |
| **Test Generation** | Creates unit tests for existing code |
| **Error Pattern Recognition** | Identifies GenAI-specific error patterns in logs |
| **Inline Chat** | Context-aware code suggestions in IDE |

### GenAI-Specific Error Pattern Recognition

Q Developer can analyze CloudWatch logs to identify patterns specific to GenAI workloads:

- **Token limit exceeded** errors and suggest prompt optimization
- **Throttling patterns** and recommend provisioned throughput
- **Model timeout** patterns and suggest async processing
- **Malformed response** patterns and suggest output parsing improvements

> **EXAM TIP:** Amazon Q Developer is positioned as the AI coding assistant for AWS. For the exam, know that it can: (1) generate Bedrock API integration code, (2) transform code between versions, (3) scan for security issues in AI code, (4) analyze GenAI-specific error patterns. It integrates with IDEs and the AWS Console.

---

## Step Functions for Agent Design Patterns

### Parallel Execution Pattern

```json
{
  "StartAt": "ParallelAnalysis",
  "States": {
    "ParallelAnalysis": {
      "Type": "Parallel",
      "Branches": [
        {
          "StartAt": "SentimentAnalysis",
          "States": {
            "SentimentAnalysis": {
              "Type": "Task",
              "Resource": "arn:aws:states:::bedrock:invokeModel",
              "Parameters": {
                "ModelId": "anthropic.claude-3-haiku-20240307",
                "Body": {
                  "anthropic_version": "bedrock-2023-05-31",
                  "messages": [{"role": "user", "content.$": "States.Format('Analyze sentiment: {}', $.text)"}],
                  "max_tokens": 200
                }
              },
              "End": true
            }
          }
        },
        {
          "StartAt": "EntityExtraction",
          "States": {
            "EntityExtraction": {
              "Type": "Task",
              "Resource": "arn:aws:states:::bedrock:invokeModel",
              "Parameters": {
                "ModelId": "anthropic.claude-3-haiku-20240307",
                "Body": {
                  "anthropic_version": "bedrock-2023-05-31",
                  "messages": [{"role": "user", "content.$": "States.Format('Extract entities: {}', $.text)"}],
                  "max_tokens": 500
                }
              },
              "End": true
            }
          }
        }
      ],
      "Next": "MergeResults"
    },
    "MergeResults": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:123456789:function:merge-analysis",
      "End": true
    }
  }
}
```

### Map State for Batch Processing

```json
{
  "StartAt": "ProcessDocuments",
  "States": {
    "ProcessDocuments": {
      "Type": "Map",
      "ItemsPath": "$.documents",
      "MaxConcurrency": 5,
      "Iterator": {
        "StartAt": "AnalyzeDocument",
        "States": {
          "AnalyzeDocument": {
            "Type": "Task",
            "Resource": "arn:aws:states:::bedrock:invokeModel",
            "Parameters": {
              "ModelId": "anthropic.claude-3-haiku-20240307",
              "Body": {
                "anthropic_version": "bedrock-2023-05-31",
                "messages": [{
                  "role": "user",
                  "content.$": "States.Format('Summarize: {}', $.content)"
                }],
                "max_tokens": 500
              }
            },
            "End": true,
            "Retry": [{
              "ErrorEquals": ["ThrottlingException"],
              "IntervalSeconds": 2,
              "MaxAttempts": 3,
              "BackoffRate": 2.0
            }]
          }
        }
      },
      "End": true
    }
  }
}
```

> **EXAM TIP:** Step Functions has **native Bedrock integration** (`arn:aws:states:::bedrock:invokeModel`). You don't need a Lambda function to call Bedrock from Step Functions. Use Parallel state for concurrent FM calls, Map state for batch processing, and Choice state for routing. This is frequently tested.

---

## Observability for GenAI Applications

### CloudWatch Logs Insights for Prompt/Response Analysis

```
# Query to analyze prompt/response patterns
fields @timestamp, @message
| filter @message like /InvokeModel/
| parse @message '"input_tokens":*,' as input_tokens
| parse @message '"output_tokens":*,' as output_tokens
| parse @message '"modelId":"*"' as model_id
| stats avg(input_tokens) as avg_input, 
        avg(output_tokens) as avg_output,
        count(*) as invocations,
        sum(input_tokens + output_tokens) as total_tokens
  by model_id, bin(1h)
| sort total_tokens desc
```

```
# Query for slow inference detection
fields @timestamp, @message
| filter @message like /InvokeModel/
| parse @message '"latency":*,' as latency_ms
| filter latency_ms > 5000
| stats count(*) as slow_calls, avg(latency_ms) as avg_latency
  by bin(15m)
| sort @timestamp desc
```

### X-Ray Tracing for FM API Call Chains

```
┌──────────────────────────────────────────────────────────────────┐
│  X-Ray Service Map for GenAI Application                         │
│                                                                   │
│  Client ──▶ API GW ──▶ Lambda ──┬──▶ Bedrock (Claude)           │
│                                  │                                │
│                                  ├──▶ DynamoDB (session)         │
│                                  │                                │
│                                  ├──▶ Bedrock KB (retrieve)      │
│                                  │                                │
│                                  └──▶ S3 (documents)             │
│                                                                   │
│  Annotations: model_id, user_id, session_id                      │
│  Metadata: prompt, response, token_count                          │
└──────────────────────────────────────────────────────────────────┘
```

### Custom Metrics for GenAI

```python
cloudwatch = boto3.client("cloudwatch")

def publish_genai_metrics(model_id, input_tokens, output_tokens, latency_ms, cost_usd):
    cloudwatch.put_metric_data(
        Namespace="GenAI/Inference",
        MetricData=[
            {
                "MetricName": "InputTokens",
                "Value": input_tokens,
                "Unit": "Count",
                "Dimensions": [{"Name": "ModelId", "Value": model_id}]
            },
            {
                "MetricName": "OutputTokens",
                "Value": output_tokens,
                "Unit": "Count",
                "Dimensions": [{"Name": "ModelId", "Value": model_id}]
            },
            {
                "MetricName": "InvocationLatency",
                "Value": latency_ms,
                "Unit": "Milliseconds",
                "Dimensions": [{"Name": "ModelId", "Value": model_id}]
            },
            {
                "MetricName": "InferenceCost",
                "Value": cost_usd,
                "Unit": "None",
                "Dimensions": [{"Name": "ModelId", "Value": model_id}]
            }
        ]
    )
```

---

## Summary: Key Service-to-Pattern Mapping

| Scenario | Primary Service | Supporting Services |
|----------|----------------|-------------------|
| Build autonomous agent | Strands Agents SDK | Bedrock, Lambda, DynamoDB |
| Multi-agent orchestration | AWS Agent Squad | Strands Agents, DynamoDB |
| Agent-tool integration | MCP servers | Lambda, ECS, Strands MCP client |
| Deterministic workflows | Step Functions | Lambda, Bedrock, SNS |
| API exposure | API Gateway | Lambda, Cognito, WAF |
| Event-driven processing | EventBridge | Lambda, SQS, SNS |
| Real-time streaming | API Gateway WebSocket | Lambda, Bedrock streaming |
| Enterprise search | Amazon Q Business | IAM Identity Center, S3, Confluence |
| CI/CD for GenAI | CodePipeline + CodeBuild | SSM (prompt versions), S3, CloudFormation |
| Cost optimization | Model cascading | CloudWatch, Lambda |
| Observability | X-Ray + CloudWatch | CloudWatch Logs Insights |
| GenAI gateway | API Gateway + Lambda | DynamoDB, ElastiCache, Bedrock Guardrails |
| No-code FM workflows | Bedrock Prompt Flows | Bedrock, Lambda |
| Document processing | Bedrock Data Automation | S3, Lambda |
| Developer productivity | Amazon Q Developer | IDE integration |
| Edge deployment | Wavelength / Outposts | SageMaker, ECS |

---

## Final Exam Tips for Domain 2

1. **Strands vs. Step Functions vs. Prompt Flows:** Strands = model-driven, flexible, code-first. Step Functions = deterministic, auditable, workflow-defined. Prompt Flows = no-code, visual, business-user friendly. The exam will present a scenario and expect you to choose the right orchestration tool.

2. **Bedrock API vs. Converse API:** InvokeModel uses model-specific formats; Converse uses a unified format. Always prefer Converse for new applications and multi-model support.

3. **Streaming:** Lambda Function URL for SSE, API Gateway WebSocket for bidirectional, API Gateway REST for non-streaming. Know the latency and complexity trade-offs.

4. **Cost Optimization:** On-demand → provisioned throughput → batch inference is the cost optimization spectrum. Model cascading (small → large) reduces per-request cost. Cross-region inference improves availability but may cross data boundaries.

5. **Security Layers:** IAM (resource access) → Cognito (user authentication) → API Gateway (rate limiting) → Bedrock Guardrails (content filtering) → VPC endpoints (network isolation). All five layers should be in your mental model.

6. **X-Ray vs. CloudWatch:** X-Ray for distributed tracing across services, CloudWatch Logs Insights for log analytics, CloudWatch Metrics for dashboards/alarms. Use annotations (indexed) for filter fields, metadata (not indexed) for payloads.

7. **MCP Hosting:** Lambda for stateless → ECS for stateful → EC2 for GPU-intensive. The transport matters: streamable HTTP for Lambda, WebSocket for long-lived connections on ECS.

8. **Human-in-the-Loop:** Step Functions Task Tokens for synchronous approval gates. SNS/SES for notifications. API Gateway for the approval callback endpoint.

9. **Memory types matter:** Short-term = DynamoDB with TTL. Long-term semantic = Knowledge Bases (vector store). Working memory = agent internal state. Session memory = DynamoDB or ElastiCache.

10. **GenAI CI/CD is different:** Standard CI/CD + prompt regression testing + model evaluation + prompt versioning (SSM Parameter Store). Manual approval gates before production deployment of prompt changes.

---

*End of Domain 2: Implementation and Integration*
