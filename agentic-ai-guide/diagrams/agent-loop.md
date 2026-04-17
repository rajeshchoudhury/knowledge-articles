# Diagrams — Agent Internals

These are Mermaid diagrams. Paste them into any Markdown viewer that supports
Mermaid (GitHub, Cursor preview, Obsidian) to render.

---

## 1. High-level Architecture

```mermaid
flowchart LR
    U[User / UI] -->|prompt| A[Agent Runtime]
    A -->|reason| LLM[(LLM)]
    A -->|act| T[Tools]
    A -->|remember| M[(Memory)]
    T --> MCP[MCP Servers]
    T --> CUST[Custom Tools]
    T --> PRE[Prebuilt Tools / Skills]
    LLM --> A
    T --> A
    A -->|answer| U
```

---

## 2. ReAct State Machine

```mermaid
stateDiagram-v2
    [*] --> THINK: user prompt
    THINK --> CALL_TOOL: tool_call emitted
    CALL_TOOL --> OBSERVE: tool result
    OBSERVE --> THINK
    THINK --> RESPOND: final answer
    RESPOND --> [*]
```

---

## 3. Multi-turn Conversation with Memory

```mermaid
sequenceDiagram
    participant U as User
    participant A as Agent
    participant M as Memory
    participant L as LLM
    participant T as Tool

    U->>A: "My policy is P-1001"
    A->>M: append user msg
    A->>L: messages[]
    L-->>A: "Got it, Alice."
    A->>M: append assistant msg
    A-->>U: reply

    U->>A: "What does it cover?"
    A->>M: load history
    A->>L: messages[] (with history)
    L-->>A: tool_call: kb_search("AUTO cover")
    A->>T: kb_search
    T-->>A: chunks
    A->>L: observation
    L-->>A: final answer
    A-->>U: reply
```

---

## 4. MCP Tool Discovery

```mermaid
sequenceDiagram
    participant A as Agent
    participant C as MCP Client
    participant S as MCP Server

    A->>C: start()
    C->>S: initialize
    S-->>C: capabilities
    C->>S: listTools
    S-->>C: [tool schemas]
    C-->>A: tools registered
    A->>C: callTool("read_file", {path:"x"})
    C->>S: JSON-RPC invoke
    S-->>C: result
    C-->>A: result
```

---

## 5. LangGraph Explicit Graph

```mermaid
flowchart TD
    START((start)) --> AGENT[agent node: LLM]
    AGENT -->|tool_call| TOOLS[tool node]
    TOOLS --> AGENT
    AGENT -->|final answer| END((end))
```

---

## 6. Production Deployment Topology

```mermaid
flowchart LR
    subgraph Client
      UI[Web / Mobile]
    end
    subgraph JavaTier[Java Tier]
      API[Spring Boot API]
    end
    subgraph AgentTier[Agent Tier]
      AG[Agent Runtime<br/>LangGraph / Strands]
    end
    subgraph AWS
      BR[(Bedrock LLM)]
      KB[(Vector DB)]
    end
    subgraph Tools
      MCP1[MCP: Postgres]
      MCP2[MCP: Jira]
      CUST[Custom REST tools]
    end
    UI --> API --> AG
    AG --> BR
    AG --> KB
    AG --> MCP1
    AG --> MCP2
    AG --> CUST
```
