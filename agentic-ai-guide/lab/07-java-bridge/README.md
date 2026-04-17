# Lab 07 — Calling the Agent from Java (Spring Boot)

In production you'll usually have a **Java microservice** calling the agent.
Two clean options:

1. **HTTP sidecar** — expose the Python agent as a tiny FastAPI service; the
   Spring Boot app calls it over HTTP. *(This lab.)*
2. **LangChain4j (pure Java)** — build the agent natively in Java. Good when
   you don't want a Python process at all.

We'll do option 1 first (fastest), then show a minimal LangChain4j sketch.

---

## Part A — Python agent as a REST sidecar

### 1. Run the FastAPI agent server

```bash
cd agentic-ai-guide/lab
source .venv/bin/activate
uvicorn agent_server:app --port 8000 --reload
```

Test it:

```bash
curl -X POST http://localhost:8000/chat \
     -H 'content-type: application/json' \
     -d '{"thread_id":"demo","message":"What is policy P-1001?"}'
```

### 2. Call it from Spring Boot

See `SpringClient.java` — a minimal `RestClient` wrapper:

```java
@RestController
@RequestMapping("/assist")
public class HelpdeskController {

    private final RestClient agent = RestClient.create("http://localhost:8000");

    @PostMapping
    public Map<String,Object> ask(@RequestBody Map<String,String> body) {
        return agent.post().uri("/chat")
            .contentType(MediaType.APPLICATION_JSON)
            .body(body)
            .retrieve()
            .body(Map.class);
    }
}
```

### Architecture

```
 ┌──────────────┐      HTTP       ┌──────────────────┐
 │ Spring Boot  │ ──────────────▶ │  Python agent    │
 │ (REST / UI)  │                 │  (FastAPI +      │
 └──────────────┘                 │   LangGraph /    │
                                  │   Strands)       │
                                  └────────┬─────────┘
                                           │
                                  ┌────────▼─────────┐
                                  │  LLM + Tools +   │
                                  │  MCP + Memory    │
                                  └──────────────────┘
```

Pros: zero coupling, easy to scale the Python service independently, keeps
Java layer unchanged.
Cons: one more process to operate.

---

## Part B — Pure Java with LangChain4j

If you prefer all-Java, [LangChain4j](https://docs.langchain4j.dev) offers
the same primitives (ChatModel, Tools, Memory, RAG, MCP client).

Minimal sketch (Maven coords at end):

```java
public interface HelpdeskAssistant {
    String chat(String userMessage);
}

@Tool("Return the policy record for a given policy_id")
String getPolicy(String policyId) { ... }

var model = BedrockChatModel.builder()
    .modelId("us.anthropic.claude-sonnet-4-5-20250929-v1:0")
    .region(Region.US_EAST_1)
    .build();

HelpdeskAssistant assistant = AiServices.builder(HelpdeskAssistant.class)
    .chatLanguageModel(model)
    .tools(new PolicyTools())
    .chatMemory(MessageWindowChatMemory.withMaxMessages(20))
    .build();

System.out.println(assistant.chat("What is on policy P-1001?"));
```

Dependencies (Gradle):

```gradle
implementation 'dev.langchain4j:langchain4j:0.36.2'
implementation 'dev.langchain4j:langchain4j-bedrock:0.36.2'
implementation 'dev.langchain4j:langchain4j-mcp:0.36.2'
```

LangChain4j also has an **MCP client** — so a Java agent can consume the
very same MCP servers you used in Lab 05.
