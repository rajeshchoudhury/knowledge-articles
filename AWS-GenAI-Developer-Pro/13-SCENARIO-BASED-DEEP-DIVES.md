# 13 — Scenario-Based Deep Dives: 15 Real-World GenAI Case Studies

> Each scenario is a self-contained mini-case-study covering requirements, architecture, tradeoffs, and exam-relevant takeaways.

---

## Scenario 1: Building an Enterprise Customer Support Chatbot

### Business Context

A global SaaS company receives 50,000 support tickets per month across 12 languages. They want to deflect 60% of Tier-1 inquiries with an AI chatbot while maintaining human handoff for complex cases. Response latency must stay under 3 seconds.

### Requirements Gathering

| Requirement | Detail |
|---|---|
| Data sources | 8,000 FAQ pages, 200 product manuals (PDF), 15 policy documents, Zendesk ticket history |
| Languages | English primary, 11 additional languages |
| Security | PII must never appear in responses; SOC 2 compliance |
| SLA | P99 latency < 3 s, 99.9% availability |
| Integration | Zendesk, Slack, web widget, mobile SDK |

### Architecture Design

```
User → API Gateway (WebSocket) → Lambda → Bedrock Agent
                                              │
                                  ┌───────────┼───────────┐
                                  ▼           ▼           ▼
                           Knowledge Base   Action Group   Guardrails
                           (FAQ + Docs)     (Zendesk API)  (PII filter)
                                  │
                                  ▼
                           OpenSearch Serverless
                           (Vector Store)
```

**Core components:**

- **Bedrock Knowledge Base** — RAG over FAQ and product documentation stored in S3.
- **Bedrock Agent** — Orchestrates retrieval, external API calls (Zendesk ticket creation), and response generation.
- **Bedrock Guardrails** — Applied to both input and output for PII redaction, denied topics, and content filtering.
- **API Gateway WebSocket** — Enables streaming responses for real-time chat experience.

### Vector Store Selection: OpenSearch Serverless vs Aurora pgvector

| Factor | OpenSearch Serverless | Aurora pgvector |
|---|---|---|
| Scale | Handles billions of vectors natively | Good for < 10M vectors |
| Managed by KB | First-class integration | Supported but requires Aurora setup |
| Hybrid search | BM25 + kNN in one query | Requires application-level merging |
| Cost at idle | OCU minimum (~$700/mo) | Serverless v2 scales near-zero |
| Filtering | Rich metadata filtering | SQL-based filtering (very flexible) |

**Decision:** OpenSearch Serverless — the hybrid search (keyword + semantic) dramatically improves FAQ retrieval accuracy. The OCU cost is justified at 50K tickets/month volume.

### Chunking Strategy

Different document types require different chunking:

- **FAQ pages** — Fixed-size chunks of 300 tokens with 50-token overlap. Each FAQ is short; small chunks keep answers precise.
- **Product manuals (PDF)** — Hierarchical chunking. Split by section headings first, then into 500-token chunks. Preserve heading metadata for context.
- **Policy documents** — Semantic chunking based on paragraph boundaries. Policy clauses must not be split mid-sentence.

**Metadata enrichment:** Attach `document_type`, `product_name`, `language`, and `last_updated` as filterable metadata fields on every chunk.

### Guardrails Configuration

```json
{
  "contentPolicyConfig": {
    "filtersConfig": [
      { "type": "HATE", "inputStrength": "HIGH", "outputStrength": "HIGH" },
      { "type": "VIOLENCE", "inputStrength": "HIGH", "outputStrength": "HIGH" }
    ]
  },
  "sensitiveInformationPolicyConfig": {
    "piiEntitiesConfig": [
      { "type": "EMAIL", "action": "ANONYMIZE" },
      { "type": "PHONE", "action": "ANONYMIZE" },
      { "type": "SSN", "action": "BLOCK" },
      { "type": "CREDIT_DEBIT_CARD_NUMBER", "action": "BLOCK" }
    ]
  },
  "topicPolicyConfig": {
    "topicsConfig": [
      {
        "name": "competitor-comparisons",
        "definition": "Questions asking to compare our product with competitor products",
        "type": "DENY"
      }
    ]
  }
}
```

**Key guardrail behaviors:**
- PII in user input is **anonymized** before reaching the model (email/phone replaced with placeholders).
- SSN/credit card numbers **block** the entire request.
- Denied topics return a canned response: "I can help with questions about our products. For comparisons, please speak with our sales team."

### Multi-Language Support

**Approach: Translate-then-retrieve vs native multilingual embeddings**

- **Option A (chosen):** Use Titan Multimodal Embeddings (supports 25+ languages natively). User queries are embedded in their native language and matched against a unified multilingual index. Response generation uses Claude with a system prompt specifying the user's detected language.
- **Option B (alternative):** Translate user query to English → retrieve → translate response back. Adds latency and can lose nuance.

**Language detection:** Amazon Comprehend `DetectDominantLanguage` API on first message; cached for the session.

### Monitoring and Evaluation

| Metric | Source | Alarm Threshold |
|---|---|---|
| Invocation latency | CloudWatch `InvocationLatency` | P99 > 3000 ms |
| Throttled requests | CloudWatch `InvocationThrottles` | > 0 sustained 5 min |
| Guardrail interventions | CloudWatch `GuardrailBlocked` | Spike > 2× baseline |
| User satisfaction | Custom metric (thumbs up/down) | CSAT < 80% |
| Retrieval relevance | Bedrock KB evaluation job | RAGAS faithfulness < 0.7 |

**Automated evaluation pipeline:** Weekly Bedrock evaluation jobs using a curated test set of 500 question-answer pairs. Measures faithfulness, relevance, and hallucination rate. Results feed a CloudWatch dashboard.

### Cost Optimization

- **Prompt caching:** Enable Bedrock prompt caching for the system prompt (which includes company tone guidelines and formatting rules). Saves ~80% on the 2,000-token system prompt for returning users.
- **Model cascading:** Route simple FAQs ("What's your refund policy?") to Haiku; escalate complex multi-step reasoning to Sonnet.
- **Provisioned Throughput:** At 50K tickets/month with predictable patterns, provisioned throughput for peak hours (9 AM–5 PM) reduces cost by 30%.
- **Context window management:** Summarize conversation history after 10 turns instead of sending full history.

### Exam-Relevant Takeaways

1. **Bedrock Knowledge Base is the default for RAG** — don't reach for SageMaker unless you need custom embeddings not available in Bedrock.
2. **OpenSearch Serverless is preferred for hybrid search** at scale; Aurora pgvector for smaller workloads or when you already have Aurora.
3. **Guardrails apply to both input AND output** — configure `inputStrength` and `outputStrength` independently.
4. **Prompt caching reduces cost for repetitive system prompts** — a classic exam optimization question.
5. **Bedrock Agents handle the orchestration** — no need to hand-roll ReAct loops in Lambda.

---

## Scenario 2: Implementing a Document Processing Pipeline

### Business Context

An insurance company processes 10,000 claims documents daily — forms, medical records, invoices, and handwritten notes. They need automated extraction, classification, entity recognition, and summarization. Documents arrive in S3 via a partner portal.

### Architecture

```
S3 (Landing)
    │
    ▼
EventBridge → Step Functions Workflow
                 │
    ┌────────────┼─────────────┬──────────────┐
    ▼            ▼             ▼              ▼
 Textract    Comprehend     Bedrock        Bedrock
 (Extract)   (Entities)    (Classify)     (Summarize)
    │            │             │              │
    └────────────┴─────────────┴──────────────┘
                 │
                 ▼
           DynamoDB (Metadata) + S3 (Processed Output)
                 │
                 ▼
           SNS → Downstream Systems
```

### Stage 1: Document Extraction with Textract

**Service selection by document type:**

| Document Type | Textract API | Why |
|---|---|---|
| Structured forms | `AnalyzeDocument` (FORMS) | Extracts key-value pairs from checkboxes, fields |
| Tables (invoices) | `AnalyzeDocument` (TABLES) | Preserves row/column structure |
| Handwritten notes | `DetectDocumentText` | OCR for handwritten content |
| Multi-page PDFs | `StartDocumentAnalysis` (async) | Asynchronous for documents > 1 page |

**Key design decision:** Use asynchronous Textract APIs for all documents. Even single-page documents benefit from the async pattern because it decouples extraction from the Step Functions workflow, enabling retries without blocking.

**Output handling:** Textract publishes completion to an SNS topic. The Step Functions workflow uses a `.waitForTaskToken` integration to pause until Textract completes.

### Stage 2: Entity Recognition with Comprehend

After text extraction, Amazon Comprehend identifies:
- **Named entities:** Person names, organizations, dates, monetary amounts
- **PII detection:** SSNs, addresses, medical record numbers
- **Custom entities:** Policy numbers, claim IDs (trained via Comprehend custom entity recognizer)

**Custom entity recognizer training:**
- Training data: 5,000 annotated claim documents with policy numbers labeled
- Entity list: CSV of known policy number patterns
- Deployed as a real-time endpoint for low-latency processing

### Stage 3: Classification with Bedrock

```
System: You are a document classifier for an insurance company.
Classify the following document into exactly one category:
- MEDICAL_CLAIM
- AUTO_CLAIM
- PROPERTY_CLAIM
- INVOICE
- CORRESPONDENCE
- UNKNOWN

Respond with only the category name, nothing else.

Document text:
{extracted_text_first_500_tokens}
```

**Why Bedrock over Comprehend Custom Classifier?**
- Zero training data required for initial deployment
- Easy to add new categories without retraining
- Comprehend classifier is better when you have > 1,000 labeled examples per category and need sub-100ms latency

### Stage 4: Summarization with Bedrock

Generate a structured summary for claims adjusters:

```
System: Summarize the following insurance claim document.
Output a JSON object with these fields:
- claimant_name
- date_of_loss
- claim_type
- damage_description (2-3 sentences)
- estimated_amount (if mentioned)
- key_findings (bullet points)

Document:
{full_extracted_text}
```

**Model selection:** Claude Haiku for cost efficiency — summaries don't require deep reasoning.

### Step Functions Orchestration

```json
{
  "StartAt": "ExtractDocument",
  "States": {
    "ExtractDocument": {
      "Type": "Task",
      "Resource": "arn:aws:states:::textract:startDocumentAnalysis.waitForTaskToken",
      "Retry": [
        {
          "ErrorEquals": ["Textract.ThrottlingException"],
          "IntervalSeconds": 5,
          "MaxAttempts": 3,
          "BackoffRate": 2.0
        }
      ],
      "Catch": [
        {
          "ErrorEquals": ["States.ALL"],
          "Next": "HandleExtractionError"
        }
      ],
      "Next": "ParallelProcessing"
    },
    "ParallelProcessing": {
      "Type": "Parallel",
      "Branches": [
        { "StartAt": "DetectEntities" },
        { "StartAt": "ClassifyDocument" }
      ],
      "Next": "SummarizeDocument"
    },
    "SummarizeDocument": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:...:summarize-function",
      "Next": "StoreResults"
    }
  }
}
```

**Key patterns:**
- **Parallel state** runs entity detection and classification simultaneously.
- **Retry with exponential backoff** for Textract throttling.
- **Catch blocks** route failures to error-handling states that log to DynamoDB and send alerts.

### Error Handling and Retry Logic

| Error Type | Strategy |
|---|---|
| Textract throttling | Exponential backoff, 3 retries, max 60s wait |
| Bedrock model timeout | Retry once, then fall back to smaller model |
| Corrupt PDF | Route to dead-letter queue, notify human operator |
| Comprehend endpoint down | Circuit breaker → queue documents for batch processing later |

**Dead letter queue:** Failed documents land in an SQS DLQ. A daily Lambda processes the DLQ, retrying or flagging for manual review.

### Exam-Relevant Takeaways

1. **Textract for extraction, Comprehend for NLP, Bedrock for generation** — know which service handles which stage.
2. **Step Functions is the orchestrator** — not Lambda calling Lambda.
3. **Async Textract with `.waitForTaskToken`** is the correct Step Functions integration pattern.
4. **Comprehend Custom Entity Recognizer** when you need domain-specific entities (policy numbers, claim IDs).
5. **Retry + Catch in Step Functions** is the error handling pattern — not try/catch in Lambda code.

---

## Scenario 3: Multi-Agent Research Assistant

### Business Context

A consulting firm wants an AI research assistant that can search internal knowledge bases, browse the web for market data, perform quantitative analysis, and compile reports — with human approval before sending to clients.

### Agent Architecture with Strands Agents SDK

```
Supervisor Agent (Orchestrator)
       │
       ├── Knowledge Base Agent
       │     └── Searches internal Bedrock KB (reports, case studies)
       │
       ├── Web Research Agent
       │     └── Web search tool, URL fetching, data extraction
       │
       ├── Analysis Agent
       │     └── Python code execution, data visualization
       │
       └── Report Writer Agent
             └── Compiles findings into structured document
```

**Why Strands Agents SDK (not Bedrock Agents)?**
- Need fine-grained control over agent-to-agent communication
- Custom tool definitions with complex input/output schemas
- Open-source SDK allows local development and testing
- Can still use Bedrock models as the underlying LLM

**When to prefer Bedrock Agents instead:**
- Simpler orchestration (single agent, multiple action groups)
- Need managed infrastructure (no servers to run)
- Built-in session management and memory

### Agent Definitions

**Knowledge Base Agent:**
```python
from strands import Agent
from strands.tools import tool

@tool
def search_knowledge_base(query: str, filters: dict = None) -> str:
    """Search internal knowledge base using Bedrock KB RetrieveAndGenerate."""
    client = boto3.client("bedrock-agent-runtime")
    response = client.retrieve_and_generate(
        input={"text": query},
        retrieveAndGenerateConfiguration={
            "type": "KNOWLEDGE_BASE",
            "knowledgeBaseConfiguration": {
                "knowledgeBaseId": KB_ID,
                "modelArn": "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-sonnet-4-20250514",
                "retrievalConfiguration": {
                    "vectorSearchConfiguration": {
                        "filter": filters
                    }
                }
            }
        }
    )
    return response["output"]["text"]

kb_agent = Agent(
    model="us.anthropic.claude-sonnet-4-20250514-v1:0",
    system_prompt="You are a knowledge base search specialist...",
    tools=[search_knowledge_base]
)
```

**Web Research Agent:**
```python
@tool
def web_search(query: str) -> str:
    """Search the web for current information."""
    # Uses an MCP server for web search capability
    ...

@tool
def fetch_url(url: str) -> str:
    """Fetch and parse content from a URL."""
    ...

web_agent = Agent(
    model="us.anthropic.claude-sonnet-4-20250514-v1:0",
    system_prompt="You are a web research specialist...",
    tools=[web_search, fetch_url]
)
```

### MCP Server for Tool Access

The agents connect to tools through Model Context Protocol (MCP) servers:

```python
from strands.tools.mcp import MCPClient

mcp_client = MCPClient(
    transport="stdio",
    command=["python", "mcp_server.py"]
)

# MCP server exposes tools like:
# - web_search(query) → search results
# - fetch_url(url) → page content
# - execute_python(code) → code output
# - create_chart(data, chart_type) → image URL
```

**Why MCP?**
- Standardized tool interface across all agents
- Tools can be shared, versioned, and tested independently
- Agents discover available tools dynamically
- MCP servers can run locally or remotely

### Human-in-the-Loop for Approval

```
Research complete → Draft report generated
        │
        ▼
  SNS notification → Reviewer email/Slack
        │
        ▼
  API Gateway endpoint ← Reviewer clicks Approve/Reject
        │
        ▼
  Step Functions resume (.waitForTaskToken)
        │
        ├── Approved → Send to client
        └── Rejected → Route back to Report Writer with feedback
```

**Implementation:** Step Functions `.waitForTaskToken` pauses the workflow. The task token is embedded in the approval URL. When the reviewer clicks Approve, a Lambda returns the token to Step Functions, which resumes execution.

### Cost Management with Model Cascading

| Task | Model | Rationale |
|---|---|---|
| Query routing | Haiku | Simple classification, lowest cost |
| KB search synthesis | Sonnet | Good balance of quality and cost |
| Web content extraction | Haiku | Parsing/extraction doesn't need strong reasoning |
| Quantitative analysis | Sonnet | Needs reasoning for data interpretation |
| Final report writing | Sonnet | Quality matters for client deliverable |
| Complex financial modeling | Opus (fallback) | Only when Sonnet produces low-confidence output |

**Estimated monthly cost (500 research requests/month):** ~$1,200 with cascading vs ~$4,500 with Opus-only.

### Exam-Relevant Takeaways

1. **Strands Agents SDK for complex multi-agent orchestration** — Bedrock Agents for simpler single-agent setups.
2. **MCP is the standardized tool protocol** — know that it enables tool sharing across agents.
3. **Human-in-the-loop uses Step Functions `.waitForTaskToken`** — this is the managed, serverless pattern.
4. **Model cascading reduces cost** — route tasks to the cheapest model that can handle them.
5. **Bedrock Agents vs Strands Agents** is a key exam distinction: managed vs custom, simple vs complex.

---

## Scenario 4: Real-Time Content Moderation System

### Business Context

A social media platform needs to moderate user-generated content in real-time — text posts, comments, and image captions. Content must be classified within 500 ms. The platform sees 100,000 posts per hour at peak.

### Architecture

```
User Post → API Gateway → Lambda (Router)
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
        Comprehend        Bedrock          Custom Lambda
        (Toxicity)      (Guardrails)     (Domain Rules)
              │               │               │
              └───────────────┴───────────────┘
                              │
                              ▼
                     Decision Aggregator (Lambda)
                              │
                    ┌─────────┼─────────┐
                    ▼         ▼         ▼
                 ALLOW      REVIEW     BLOCK
                    │         │         │
                    ▼         ▼         ▼
                 Publish   SQS Queue   User Notified
                           (Human)
```

### Bedrock Guardrails for Content Filtering

**ApplyGuardrail API (independent of model invocation):**

```python
response = bedrock_runtime.apply_guardrail(
    guardrailIdentifier="gr-content-mod-v1",
    guardrailVersion="3",
    source="INPUT",
    content=[
        {
            "text": {
                "text": user_post_text,
                "qualifiers": ["query"]
            }
        }
    ]
)

if response["action"] == "GUARDRAIL_INTERVENED":
    # Content blocked — extract which policies triggered
    for assessment in response["assessments"]:
        log_violation(assessment)
```

**Why `ApplyGuardrail` instead of inline with `InvokeModel`?**
- Content moderation doesn't need model generation — just classification
- `ApplyGuardrail` is cheaper (no model invocation cost)
- Lower latency (no model inference)
- Can process content that will never go to a model

### Comprehend for Toxicity Detection

```python
response = comprehend.detect_toxic_content(
    TextSegments=[{"Text": user_post_text}],
    LanguageCode="en"
)

toxicity_score = response["ResultList"][0]["Toxicity"]
labels = response["ResultList"][0]["Labels"]
# Labels: HATEFUL, THREAT, INSULT, PROFANITY, SEXUAL, GRAPHIC, HARASSMENT
```

**Comprehend vs Guardrails for toxicity:**

| Aspect | Comprehend | Bedrock Guardrails |
|---|---|---|
| Granularity | 7 specific toxicity labels with scores | Broader categories (HATE, INSULTS, SEXUAL, VIOLENCE) |
| Latency | ~50 ms | ~200 ms |
| Cost | $0.0001 per unit | $0.75 per 1K text units (guardrail pricing) |
| Customization | No custom categories | Custom denied topics, word filters |

**Decision:** Use both in parallel. Comprehend for fast toxicity scoring; Guardrails for custom policy enforcement (brand-specific denied topics, competitor mentions).

### Custom Lambda for Domain-Specific Rules

```python
def evaluate_domain_rules(post):
    violations = []

    # Rule: No external links in first 24 hours
    if user_age_hours < 24 and contains_url(post.text):
        violations.append("NEW_USER_LINK")

    # Rule: No cryptocurrency promotion
    if matches_crypto_pattern(post.text):
        violations.append("CRYPTO_PROMOTION")

    # Rule: Rate limit on @mentions
    if count_mentions(post.text) > 10:
        violations.append("MENTION_SPAM")

    return violations
```

### Streaming Response Validation

For real-time chat features where the platform uses Bedrock to generate AI responses:

```python
response = bedrock_runtime.invoke_model_with_response_stream(
    modelId="anthropic.claude-sonnet-4-20250514-v1:0",
    body=json.dumps({"prompt": user_message}),
    guardrailIdentifier="gr-chat-v1",
    guardrailVersion="DRAFT"
)

# Guardrails validate streaming chunks
# If violation detected mid-stream:
# - Stream is terminated
# - Guardrail intervention message replaces partial output
# - StreamCompleteEvent includes guardrail trace
```

**Key behavior:** With streaming + guardrails, Bedrock buffers enough tokens to evaluate content policy before releasing chunks to the client. This adds slight latency but prevents policy violations from reaching the user mid-stream.

### Audit Logging

**CloudTrail** captures all API calls:
- `ApplyGuardrail` invocations with request/response
- `InvokeModel` calls with guardrail results
- Guardrail version changes and configuration updates

**Custom audit log (DynamoDB):**

| Field | Value |
|---|---|
| post_id | Unique post identifier |
| timestamp | ISO 8601 |
| comprehend_toxicity | 0.0–1.0 score |
| guardrail_action | ALLOW / INTERVENED |
| guardrail_policies | List of triggered policies |
| domain_rules | List of violated rules |
| final_decision | ALLOW / REVIEW / BLOCK |
| reviewer_override | null / ALLOW / BLOCK (if human reviewed) |

### Dashboard with CloudWatch

**Custom metrics emitted:**
- `ContentModeration/PostsProcessed` (count)
- `ContentModeration/PostsBlocked` (count, dimension: `reason`)
- `ContentModeration/PostsInReview` (count)
- `ContentModeration/ModerationLatencyMs` (P50, P99)
- `ContentModeration/FalsePositiveRate` (from reviewer overrides)

**Alarms:**
- Block rate > 15% sustained 15 min → investigate potential attack
- Review queue depth > 1,000 → scale human reviewers
- Latency P99 > 500 ms → check Comprehend/Guardrail throttling

### Exam-Relevant Takeaways

1. **`ApplyGuardrail` API works independently of model invocation** — use it for content moderation without model calls.
2. **Comprehend toxicity detection is faster and cheaper** than Guardrails for simple toxic content scoring.
3. **Guardrails with streaming** buffer tokens before releasing — know the latency tradeoff.
4. **CloudTrail logs all Bedrock API calls** — this is the audit mechanism for compliance.
5. **Combine Comprehend + Guardrails + custom rules** for defense-in-depth moderation.

---

## Scenario 5: Migrating from OpenAI to Amazon Bedrock

### Business Context

A Series B startup has built their product on OpenAI's API (GPT-4, text-embedding-ada-002). They want to migrate to Amazon Bedrock for better AWS integration, data residency control, and cost predictability. They process 2 million API calls per month.

### API Compatibility Mapping

| OpenAI | Bedrock Equivalent | Notes |
|---|---|---|
| `chat.completions.create()` | `Converse` / `ConverseStream` | Standardized across all Bedrock models |
| `embeddings.create()` | `InvokeModel` (Titan Embeddings) | Model-specific request format |
| GPT-4 | Claude Sonnet / Claude Opus | Closest capability match |
| GPT-4 Vision | Claude (vision) | Supports image input via Converse API |
| text-embedding-ada-002 | Titan Text Embeddings V2 | 1024 dimensions (configurable) |
| Function calling | Converse API `toolConfig` | Same concept, different format |
| JSON mode | Converse API with tool use trick / prompt engineering | No direct equivalent; use structured prompts |
| Assistants API | Bedrock Agents | Different abstraction, similar capability |

### Prompt Adaptation Strategies

**System prompt differences:**

```python
# OpenAI format
messages = [
    {"role": "system", "content": "You are a helpful assistant..."},
    {"role": "user", "content": "What is..."}
]

# Bedrock Converse API format (works the same!)
messages = [
    {"role": "user", "content": [{"text": "What is..."}]}
]
system = [{"text": "You are a helpful assistant..."}]

response = bedrock.converse(
    modelId="anthropic.claude-sonnet-4-20250514-v1:0",
    messages=messages,
    system=system
)
```

**Prompt behavior differences to watch for:**
- Claude tends to be more verbose; add "Be concise" to system prompts
- Claude follows instructions more literally; be precise about output format
- Temperature ranges differ (OpenAI 0-2, Bedrock 0-1 for most models)
- Claude supports `<xml>` tags in prompts for structured sections — leverage this

**Embedding migration:**
- OpenAI ada-002 outputs 1536 dimensions; Titan V2 outputs 1024 (default)
- **You must re-embed your entire corpus** — embeddings are not interchangeable
- Plan for a parallel-run period where both old and new indexes serve traffic

### Converse API for Standardized Interactions

The Converse API is the migration accelerator:

```python
# One API format works across Claude, Llama, Mistral, Titan
response = bedrock.converse(
    modelId=model_id,   # swap models without code changes
    messages=messages,
    inferenceConfig={
        "maxTokens": 1024,
        "temperature": 0.7,
        "topP": 0.9
    },
    toolConfig={
        "tools": [{
            "toolSpec": {
                "name": "get_weather",
                "description": "Get current weather",
                "inputSchema": {
                    "json": {
                        "type": "object",
                        "properties": {
                            "location": {"type": "string"}
                        }
                    }
                }
            }
        }]
    }
)
```

**Key Converse API benefits for migration:**
- Tool/function calling uses the same mental model as OpenAI
- Model-agnostic: switch between Claude, Llama, Mistral without code changes
- Built-in token counting in the response metadata
- Streaming variant (`ConverseStream`) available

### Cost Comparison and Optimization

| Dimension | OpenAI GPT-4 | Bedrock Claude Sonnet |
|---|---|---|
| Input tokens (per 1M) | $30.00 | $3.00 |
| Output tokens (per 1M) | $60.00 | $15.00 |
| Embeddings (per 1M tokens) | $0.10 | $0.02 (Titan V2) |
| Rate limits | Tier-based | Account-based, adjustable |
| Committed pricing | None | Provisioned Throughput (1-6 mo) |

**At 2M calls/month (avg 500 input, 200 output tokens per call):**
- OpenAI: ~$54,000/month
- Bedrock (Sonnet on-demand): ~$9,000/month
- Bedrock (Sonnet provisioned): ~$6,500/month

### Performance Benchmarking

**Benchmark framework:**

```python
test_suite = [
    {"category": "summarization", "prompts": load_prompts("summarization.jsonl")},
    {"category": "code_generation", "prompts": load_prompts("code.jsonl")},
    {"category": "classification", "prompts": load_prompts("classification.jsonl")},
    {"category": "reasoning", "prompts": load_prompts("reasoning.jsonl")},
]

for category in test_suite:
    for prompt in category["prompts"]:
        openai_result = call_openai(prompt)
        bedrock_result = call_bedrock(prompt)
        evaluate(openai_result, bedrock_result, human_baseline=prompt["expected"])
```

**Metrics tracked:**
- Quality score (human evaluation 1-5 scale)
- Latency (TTFB and total)
- Token efficiency (same task, fewer output tokens = more efficient)
- Tool calling accuracy (correct function selection and parameters)

### Gradual Rollout with A/B Testing

**Phase 1 (Week 1-2): Shadow mode**
- All traffic goes to OpenAI (production)
- Mirror 100% of requests to Bedrock (shadow)
- Compare outputs, measure quality and latency
- No user impact

**Phase 2 (Week 3-4): Canary**
- Route 5% of traffic to Bedrock
- Monitor error rates, latency, user satisfaction
- Gradually increase to 25%

**Phase 3 (Week 5-6): Majority migration**
- Route 75% to Bedrock, 25% to OpenAI (fallback)
- OpenAI serves as automatic fallback on Bedrock errors

**Phase 4 (Week 7+): Full migration**
- 100% Bedrock, decommission OpenAI integration
- Keep OpenAI credentials active for 30 days as emergency fallback

### Exam-Relevant Takeaways

1. **Converse API is the standard** — use it for all new Bedrock integrations; it abstracts model-specific formats.
2. **Embeddings are NOT portable** — migrating vector stores requires re-embedding the entire corpus.
3. **Tool use in Converse API** maps directly to OpenAI function calling — same concept, different JSON structure.
4. **Provisioned Throughput** for committed, predictable workloads — the exam loves this cost optimization.
5. **Bedrock doesn't have a direct "JSON mode"** — use structured prompts or tool use to get JSON output.

---

## Scenario 6: Building a Secure Healthcare GenAI Application (HIPAA)

### Business Context

A health tech company wants to build an AI assistant that helps physicians summarize patient records, suggest diagnoses, and draft referral letters. The application handles Protected Health Information (PHI) and must comply with HIPAA.

### Security Architecture

```
Physician (Browser)
      │
      ▼
CloudFront → ALB (in VPC)
                │
                ▼
         ECS Fargate (App Layer, Private Subnet)
                │
                ├── VPC Endpoint ──→ Bedrock Runtime
                ├── VPC Endpoint ──→ S3 (Patient Records)
                ├── VPC Endpoint ──→ DynamoDB (Session Data)
                └── VPC Endpoint ──→ KMS (Encryption Keys)

No traffic leaves the VPC to reach AWS services.
```

### VPC Endpoints and Network Isolation

**Required VPC endpoints:**
- `com.amazonaws.us-east-1.bedrock-runtime` — Model invocation
- `com.amazonaws.us-east-1.bedrock-agent-runtime` — KB retrieval
- `com.amazonaws.us-east-1.s3` — Gateway endpoint for records
- `com.amazonaws.us-east-1.dynamodb` — Gateway endpoint for metadata
- `com.amazonaws.us-east-1.kms` — Encryption operations

**VPC endpoint policy (restrict to specific models):**

```json
{
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {"AWS": "arn:aws:iam::123456789012:role/physician-app-role"},
      "Action": "bedrock:InvokeModel",
      "Resource": "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-sonnet-*"
    },
    {
      "Effect": "Deny",
      "Principal": "*",
      "Action": "bedrock:InvokeModel",
      "Resource": "arn:aws:bedrock:*::foundation-model/meta.*"
    }
  ]
}
```

### Encryption

| Layer | Mechanism |
|---|---|
| Data at rest (S3) | SSE-KMS with customer-managed key |
| Data at rest (DynamoDB) | AWS-managed KMS key |
| Data in transit | TLS 1.2+ (enforced via VPC endpoint policy) |
| Model I/O | Bedrock encrypts inference data in transit; no data stored by default |
| Session data | AES-256 encryption in application layer before DynamoDB write |

**Critical HIPAA requirement:** Bedrock does NOT store or log prompts/completions by default. This is the key differentiator vs self-hosted models where you must manage data lifecycle.

### PHI Protection with Bedrock Guardrails

```json
{
  "sensitiveInformationPolicyConfig": {
    "piiEntitiesConfig": [
      { "type": "NAME", "action": "ANONYMIZE" },
      { "type": "ADDRESS", "action": "ANONYMIZE" },
      { "type": "PHONE", "action": "ANONYMIZE" },
      { "type": "EMAIL", "action": "ANONYMIZE" },
      { "type": "SSN", "action": "BLOCK" },
      { "type": "US_INDIVIDUAL_TAX_IDENTIFICATION_NUMBER", "action": "BLOCK" }
    ],
    "regexesConfig": [
      {
        "name": "MedicalRecordNumber",
        "description": "Hospital MRN format",
        "pattern": "MRN-\\d{8}",
        "action": "ANONYMIZE"
      }
    ]
  }
}
```

**Guardrails placement:**
- **Input guardrail:** Applied, but PHI in physician input is expected and necessary for summarization. Configure to ANONYMIZE in logging but ALLOW in model input.
- **Output guardrail:** Ensure model responses don't leak PHI from other patients (hallucination risk). Block SSNs/tax IDs in output.

### Audit Logging Requirements

| Log Type | Service | Retention |
|---|---|---|
| API calls | CloudTrail | 7 years (HIPAA) |
| Model invocations | CloudTrail data events | 7 years |
| Application access | CloudWatch Logs (VPC flow logs) | 7 years |
| User activity | Custom audit log (DynamoDB) | 7 years |
| Guardrail interventions | CloudWatch Logs | 7 years |

**CloudTrail configuration:**
- Enable data events for Bedrock
- Log to S3 bucket with Object Lock (WORM compliance)
- Encrypt logs with separate KMS key
- Enable CloudTrail Lake for SQL-based audit queries

### Data Residency Requirements

- All data must remain in `us-east-1` (or another specific region)
- **Bedrock Cross-Region Inference must be DISABLED** — use inference profiles locked to a single region
- S3 bucket policy denies cross-region replication
- VPC endpoint ensures traffic never traverses the public internet

### Model Selection for Medical Accuracy

| Use Case | Model | Why |
|---|---|---|
| Patient record summarization | Claude Sonnet | Strong instruction following, good at structured medical text |
| Differential diagnosis suggestion | Claude Opus | Complex reasoning needed; must handle nuance |
| Referral letter drafting | Claude Haiku | Template-based, lower complexity |
| Medical coding (ICD-10) | Fine-tuned model | Domain-specific accuracy needed |

**Evaluation for medical applications:**
- Partner with clinical team for evaluation dataset
- Measure hallucination rate specifically for medical facts
- Human-in-the-loop for all diagnosis suggestions (physician must review)
- Never present AI output as definitive medical advice

### Exam-Relevant Takeaways

1. **VPC endpoints keep Bedrock traffic private** — this is the #1 HIPAA networking answer.
2. **Bedrock does not store prompts/completions by default** — critical for compliance.
3. **VPC endpoint policies** can restrict which models and principals can invoke Bedrock.
4. **Guardrails regex patterns** for custom PHI formats (MRN, custom patient IDs).
5. **Cross-Region Inference must be disabled** for data residency — use single-region inference profiles.
6. **CloudTrail with data events** captures model invocation details for audit.

---

## Scenario 7: E-Commerce Product Recommendation Engine

### Business Context

An online retailer with 500K SKUs and 10M monthly active users wants personalized product recommendations powered by GenAI. Recommendations appear on product pages, in email campaigns, and in a conversational shopping assistant.

### Architecture

```
User browsing behavior → Kinesis Data Streams → Lambda → User Profile (DynamoDB)
                                                              │
Product catalog ──→ S3 ──→ Bedrock KB (embeddings) ←─────────┘
                                                              │
                                                              ▼
                                                    Bedrock (Claude Haiku)
                                                              │
                                    ┌─────────────────────────┼───────────┐
                                    ▼                         ▼           ▼
                             Product Page                  Email API    Chat Bot
                             (API Gateway)                (SES + Lambda) (Agent)
```

### RAG with Product Catalog

**Product catalog as a knowledge base:**
- Each product becomes a document: title, description, features, category, price range, reviews summary
- Embeddings: Titan Text Embeddings V2 (1024 dimensions)
- Vector store: OpenSearch Serverless (need metadata filtering by category, price, availability)

**Chunk design for products:**

```
Product: Sony WH-1000XM5 Wireless Headphones
Category: Electronics > Audio > Headphones
Price: $349.99
Rating: 4.7/5 (2,341 reviews)
Key Features: Active noise cancellation, 30-hour battery life, 
multipoint Bluetooth, speak-to-chat, adaptive sound control.
Description: Premium wireless headphones with industry-leading 
noise cancellation. Two processors control 8 microphones...
Top Review Themes: Excellent ANC, comfortable for long wear, 
premium build quality, call quality could be better.
```

Each product is a single chunk (~200-400 tokens). No splitting needed — keeps product context intact.

### Real-Time Inventory Integration

The recommendation engine must not suggest out-of-stock products:

```python
# Bedrock Agent action group for inventory check
def check_inventory(product_ids: list[str]) -> dict:
    """Check real-time inventory for recommended products."""
    response = dynamodb.batch_get_item(
        RequestItems={
            "inventory": {
                "Keys": [{"product_id": {"S": pid}} for pid in product_ids]
            }
        }
    )
    return {
        item["product_id"]["S"]: int(item["stock_count"]["N"]) > 0
        for item in response["Responses"]["inventory"]
    }
```

**Two-stage recommendation:**
1. Bedrock KB retrieves top-20 similar products (semantic search)
2. Filter by inventory availability, user purchase history (exclude already-owned)
3. Claude Haiku re-ranks and generates personalized explanation

### A/B Testing for Recommendation Quality

| Variant | Approach | Metric |
|---|---|---|
| Control | Existing collaborative filtering | Click-through rate, conversion |
| Treatment A | RAG-only (semantic similarity) | Click-through rate, conversion |
| Treatment B | RAG + user profile context | Click-through rate, conversion |
| Treatment C | RAG + user profile + personalized explanation | Click-through rate, conversion |

**Implementation:** API Gateway stage variables route traffic percentages. CloudWatch custom metrics track per-variant performance. Statistical significance calculated after 2 weeks.

### Cost Optimization at Scale

**10M users × avg 5 page views × 30 days = 1.5B recommendation requests/month**

This volume requires aggressive optimization:

1. **Caching layer (ElastiCache Redis):**
   - Cache product embeddings lookup results (TTL: 1 hour)
   - Cache popular product recommendations (TTL: 15 minutes)
   - Expected cache hit rate: 70% (popular products concentrate views)

2. **Model selection:**
   - Haiku for recommendation explanation (cheapest model)
   - Pre-compute recommendations for top 10K products (batch nightly)

3. **Tiered approach:**
   - Popular products (80% of views): Pre-computed, served from cache
   - Long-tail products (20% of views): Real-time RAG + Haiku
   - Conversational assistant: Sonnet (higher quality needed for dialogue)

4. **Provisioned Throughput** for the consistent base load.

### Exam-Relevant Takeaways

1. **Bedrock KB for product catalog search** — semantic search finds similar products better than keyword search.
2. **Metadata filtering** in vector search to narrow by category, price range, availability.
3. **Caching is essential at scale** — ElastiCache for pre-computed recommendations.
4. **Model cascading**: Haiku for simple generation, Sonnet for conversational quality.
5. **Pre-compute where possible** — batch offline for popular items, real-time for long tail.

---

## Scenario 8: Financial Document Analysis Platform

### Business Context

A financial services firm processes quarterly earnings reports, SEC filings (10-K, 10-Q), and internal financial documents. Analysts need automated extraction, summarization, and trend analysis across thousands of documents.

### Architecture

```
Document Ingestion (S3)
        │
        ▼
  Textract (Tables, Forms)
        │
        ▼
  Lambda (Structured Data Extraction)
        │
        ├──→ DynamoDB (Financial Metrics)
        ├──→ Bedrock KB (Full Document Embeddings)
        └──→ Bedrock (Summarization + Analysis)
                │
                ▼
        Analyst Dashboard (QuickSight)
```

### Textract + Bedrock for Financial Documents

**Stage 1: Textract for structured data**

```python
# Extract tables from financial statements
response = textract.analyze_document(
    Document={"S3Object": {"Bucket": bucket, "Name": key}},
    FeatureTypes=["TABLES", "FORMS"]
)

# Parse Textract table response into structured format
tables = parse_tables(response)
# Result: List of tables with headers and cell values
# e.g., [{"header": ["Q1", "Q2", "Q3", "Q4"], "rows": [["Revenue", "1.2B", "1.3B", ...]]}]
```

**Stage 2: Bedrock for interpretation**

```
System: You are a financial analyst. Given the following extracted table 
from a 10-K filing, provide:
1. Key financial metrics (revenue, net income, EPS, operating margin)
2. Year-over-year trends
3. Notable observations or anomalies
4. Risk factors mentioned in context

Output as structured JSON.

Table data:
{textract_table_output}

Surrounding context:
{textract_text_output}
```

### Compliance Requirements (SOX, Regulatory)

| Requirement | Implementation |
|---|---|
| Data integrity | S3 Object Lock (governance mode) for original documents |
| Access control | IAM roles per team; attribute-based access control (ABAC) for document classification level |
| Audit trail | CloudTrail data events for all S3 and Bedrock access |
| Data retention | S3 Lifecycle rules: 7-year retention for SEC filings |
| Encryption | KMS CMK with key rotation enabled; separate keys for different data classifications |
| Segregation of duties | Separate IAM roles for ingestion, analysis, and export |

### Audit Trail and Data Lineage

Every analysis result traces back to its source:

```json
{
  "analysis_id": "a-12345",
  "source_document": "s3://financials/10K-ACME-2025.pdf",
  "source_document_hash": "sha256:abc123...",
  "extraction_job": "textract-job-67890",
  "model_id": "anthropic.claude-sonnet-4-20250514-v1:0",
  "model_version": "bedrock-2025-01-01",
  "prompt_template_version": "v3.2",
  "guardrail_id": "gr-financial-v2",
  "guardrail_version": "4",
  "timestamp": "2025-06-15T14:30:00Z",
  "analyst_id": "analyst-jdoe",
  "analysis_output": { ... }
}
```

**Data lineage stored in DynamoDB** with GSI on `source_document` for tracing all analyses derived from a single document.

### Model Evaluation for Accuracy

Financial accuracy is non-negotiable. Evaluation pipeline:

1. **Ground truth dataset:** 500 manually verified financial summaries
2. **Bedrock evaluation job:**
   - Metric: Factual accuracy (does the summary match the source numbers?)
   - Metric: Completeness (are key metrics captured?)
   - Metric: Hallucination rate (numbers not present in source document)
3. **Automated regression testing:** Before any prompt template change, run the full eval suite
4. **Human review sampling:** 5% of production analyses reviewed by senior analyst weekly

### PII Handling in Financial Data

Financial documents contain:
- Executive names, compensation details
- Board member information
- Insider trading disclosures

**Guardrail configuration:**
- ANONYMIZE personal names in internal summaries
- BLOCK SSNs and personal financial information
- ALLOW company names, executive titles (these are public information in SEC filings)
- Custom regex for account numbers: `\b\d{10,12}\b` → ANONYMIZE

### Exam-Relevant Takeaways

1. **Textract for table extraction** from financial documents — FORMS and TABLES features.
2. **S3 Object Lock** for document integrity (SOX compliance).
3. **Data lineage** means tracking every analysis back to source document, model version, and prompt version.
4. **Bedrock evaluation jobs** with custom metrics for domain-specific accuracy.
5. **Separate encryption keys** for different data classifications — KMS key per classification level.

---

## Scenario 9: Internal Knowledge Management System

### Business Context

A 10,000-person enterprise wants to replace their outdated intranet search with an AI-powered knowledge management system. Employees should be able to ask natural language questions and get answers from Confluence, SharePoint, Slack archives, and internal wikis.

### Amazon Q Business for Enterprise Search

**Why Amazon Q Business (not custom RAG with Bedrock KB)?**

| Factor | Amazon Q Business | Custom Bedrock KB RAG |
|---|---|---|
| Data connectors | 40+ built-in (Confluence, SharePoint, Slack, S3, etc.) | S3 only (must ETL everything to S3) |
| Access control | Inherits source system ACLs automatically | Must implement custom RBAC |
| Deployment time | Days | Weeks to months |
| Customization | Limited (guardrails, topics) | Full control |
| Cost | Per-user pricing | Per-API-call pricing |

**Decision:** Amazon Q Business — the built-in connectors and automatic ACL inheritance save months of development.

### Multiple Data Source Connectors

```
Amazon Q Business Application
        │
        ├── Confluence Connector
        │     ├── Spaces: Engineering, Product, HR, Legal
        │     └── Sync: Every 6 hours
        │
        ├── SharePoint Connector
        │     ├── Sites: Company Policies, Benefits, Onboarding
        │     └── Sync: Every 12 hours
        │
        ├── Slack Connector
        │     ├── Channels: #announcements, #engineering, #product
        │     └── Sync: Every 4 hours (exclude DMs)
        │
        ├── S3 Connector
        │     ├── Bucket: internal-docs (training materials, PDFs)
        │     └── Sync: On S3 event (real-time)
        │
        └── ServiceNow Connector
              ├── Knowledge articles and incident resolutions
              └── Sync: Every 8 hours
```

### Access Control and Permissions

Amazon Q Business maps source system permissions:

- **Confluence:** Space-level and page-level permissions → Q Business respects them
- **SharePoint:** Site/library permissions → Mapped to Q Business users via IAM Identity Center
- **Slack:** Channel membership → Only index public channels or channels user belongs to

**Identity mapping:**

```
Corporate SSO (Okta) → IAM Identity Center → Amazon Q Business
                                                    │
                                           User sees only documents
                                           they have access to in
                                           source systems
```

**Key point:** A user searching Q Business will NEVER see results from a Confluence space they don't have access to. This is automatic — no custom code needed.

### Content Freshness Management

| Source | Sync Strategy | Freshness SLA |
|---|---|---|
| Confluence | Incremental crawl every 6 hours | < 6 hours |
| SharePoint | Incremental crawl every 12 hours | < 12 hours |
| S3 | Event-driven (S3 → EventBridge → Q sync) | < 15 minutes |
| Slack | Incremental every 4 hours | < 4 hours |

**Handling stale content:**
- Q Business shows document last-modified date in citations
- Admin can trigger manual re-sync for urgent updates
- Boosting rules prioritize recently updated documents

### User Feedback Integration

```
User asks question → Q Business responds with answer + citations
        │
        ▼
User clicks 👍 or 👎
        │
        ▼
Feedback stored → Used to improve ranking over time
        │
        ▼
Low-rated answers flagged → Content owners notified to update source docs
```

**Q Business built-in feedback:** Thumbs up/down on every response. Admins see analytics dashboard showing:
- Most asked topics
- Lowest-rated responses (content gaps)
- Most used data sources
- User adoption metrics

### Exam-Relevant Takeaways

1. **Amazon Q Business for enterprise search with multiple data sources** — don't build custom RAG when Q Business has connectors.
2. **ACL inheritance is automatic** — Q Business respects source system permissions.
3. **IAM Identity Center** is required for Q Business user management.
4. **Q Business vs Bedrock KB**: Q Business for broad enterprise search; Bedrock KB for application-specific RAG.
5. **Data source connectors** sync incrementally — know the freshness tradeoffs.

---

## Scenario 10: GenAI-Powered Code Review System

### Business Context

A software company wants to augment their code review process with AI. The system should identify bugs, security vulnerabilities, style violations, and suggest improvements — integrated directly into their CI/CD pipeline.

### Architecture

```
Developer pushes code → CodeCommit / GitHub
        │
        ▼
  CodePipeline triggers
        │
        ▼
  Lambda: Extract diff
        │
        ├──→ Amazon Q Developer (Code review)
        │         │
        │         ▼
        │    Review comments posted to PR
        │
        ├──→ Bedrock (Custom analysis prompts)
        │         │
        │         ▼
        │    Security-focused analysis
        │
        └──→ CodeGuru Security (SAST)
                  │
                  ▼
             Vulnerability findings
```

### Amazon Q Developer Integration

**Amazon Q Developer for code review:**
- Automatically reviews pull requests when enabled
- Identifies bugs, security issues, and code quality problems
- Posts comments directly on the PR with suggested fixes
- Supports Java, Python, JavaScript/TypeScript, C#, and more

**Programmatic integration via API:**

```python
# Trigger Q Developer code review
response = q_developer.create_code_review(
    repositoryArn="arn:aws:codecommit:us-east-1:123456789012:my-repo",
    type="PULL_REQUEST",
    pullRequestId="42"
)
```

### Custom Prompt Engineering for Code Analysis

For domain-specific analysis beyond Q Developer's built-in checks:

```
System: You are a senior security engineer reviewing code changes.
Analyze the following code diff for:

1. SECURITY: SQL injection, XSS, SSRF, hardcoded secrets, insecure 
   deserialization, broken authentication
2. PERFORMANCE: N+1 queries, unnecessary allocations, missing indexes
3. ARCHITECTURE: SOLID violations, excessive coupling, missing error handling

For each finding, provide:
- Severity: CRITICAL / HIGH / MEDIUM / LOW
- Line number
- Description
- Suggested fix (code snippet)

Respond in JSON format.

Code diff:
{diff_content}

File context (full file for reference):
{file_content}
```

**Why Bedrock in addition to Q Developer?**
- Custom rules specific to the company's codebase and standards
- Integration with internal security policies
- Analysis of architecture patterns Q Developer doesn't cover
- Can reference internal coding guidelines stored in a knowledge base

### CI/CD Integration with CodePipeline

```yaml
# CodePipeline stage configuration
- Name: AICodeReview
  Actions:
    - Name: QDeveloperReview
      ActionTypeId:
        Category: Invoke
        Provider: Lambda
      Configuration:
        FunctionName: trigger-q-developer-review
    - Name: SecurityAnalysis
      ActionTypeId:
        Category: Invoke
        Provider: Lambda
      Configuration:
        FunctionName: bedrock-security-analysis
    - Name: CodeGuruScan
      ActionTypeId:
        Category: Test
        Provider: CodeGuru
  
- Name: GateCheck
  Actions:
    - Name: ReviewGate
      ActionTypeId:
        Category: Approval
        Provider: Manual
      Configuration:
        NotificationArn: !Ref ReviewerSNSTopic
```

**Gate logic:** If any CRITICAL finding from any reviewer → block merge, notify team lead. HIGH findings → flag for human review. MEDIUM/LOW → informational only.

### Security Scanning Automation

**Multi-layer security scanning:**
1. **CodeGuru Security** — SAST for known vulnerability patterns
2. **Bedrock analysis** — AI-powered detection of logic flaws, business logic vulnerabilities
3. **Secrets detection** — Custom regex + Bedrock for potential secret patterns

**Results aggregation:**

```python
all_findings = (
    codeguru_findings +
    bedrock_security_findings +
    secrets_scan_findings
)

deduplicated = deduplicate_findings(all_findings)
prioritized = rank_by_severity(deduplicated)
post_to_pr(prioritized)
```

### Developer Feedback Loop

| Feedback Signal | Collection Method | Usage |
|---|---|---|
| Comment dismissed | PR interaction tracking | Reduce false positives for similar patterns |
| Suggestion accepted | PR merge with AI-suggested changes | Reinforce accurate patterns |
| Override with justification | "Won't fix" with reason | Train custom rules |
| Review latency satisfaction | Periodic developer survey | Tune pipeline performance |

### Exam-Relevant Takeaways

1. **Amazon Q Developer for automated code review** — built-in PR review capability.
2. **CodeGuru Security for SAST** — complements AI review with deterministic vulnerability detection.
3. **CodePipeline for orchestration** — Lambda actions invoke Bedrock and Q Developer.
4. **Custom Bedrock prompts** for company-specific code standards that Q Developer doesn't cover.
5. **Combine deterministic scanning (CodeGuru) with GenAI analysis (Bedrock)** for defense-in-depth.

---

## Scenario 11: Scaling a GenAI Application from POC to Production

### Business Context

A team built a successful proof-of-concept GenAI application (document Q&A) using Bedrock with on-demand pricing. It serves 50 internal users. Now they need to scale to 10,000 external customers with production-grade reliability.

### Architecture Evolution

**POC Architecture:**
```
User → Lambda → Bedrock InvokeModel (on-demand)
                    │
                    ▼
              In-memory FAISS index
              (loaded per Lambda invocation)
```

**Production Architecture:**
```
User → CloudFront → ALB → ECS Fargate (Auto Scaling)
                              │
                    ┌─────────┼──────────┐
                    ▼         ▼          ▼
              ElastiCache  Bedrock    OpenSearch
              (Prompt      (Provisioned  Serverless
               Cache)      Throughput)   (Vector Store)
                              │
                              ▼
                         Guardrails
                              │
                              ▼
                    CloudWatch + X-Ray
```

### From On-Demand to Provisioned Throughput

**When to switch:**
- Consistent baseline load > 100 requests/minute
- Need guaranteed latency SLAs
- Cost savings at committed volume

**Provisioned Throughput calculation:**

```
Current usage: 500 requests/hour avg, 2000 requests/hour peak
Average tokens per request: 800 input, 400 output

Model Units needed:
  - 1 Model Unit (Sonnet) ≈ X tokens/min throughput
  - Calculate based on current Bedrock pricing page
  - Commitment: 1-month or 6-month terms
  
Savings: ~30-40% vs on-demand for steady-state workloads
```

**Hybrid approach:** Provisioned Throughput for baseline (covers 70% of traffic) + on-demand for burst (handles peaks).

### Implementing Caching Layers

**Layer 1: Exact-match prompt cache (ElastiCache Redis)**

```python
import hashlib

def get_or_generate(prompt, model_id):
    cache_key = hashlib.sha256(f"{model_id}:{prompt}".encode()).hexdigest()
    cached = redis.get(cache_key)
    if cached:
        return json.loads(cached)

    response = bedrock.invoke_model(modelId=model_id, body=prompt)
    redis.setex(cache_key, ttl=3600, value=json.dumps(response))
    return response
```

**Layer 2: Bedrock Prompt Caching (system prompt)**

```python
response = bedrock.converse(
    modelId="anthropic.claude-sonnet-4-20250514-v1:0",
    messages=messages,
    system=[{
        "text": long_system_prompt,
        "cachePoint": {"type": "default"}  # Cache this block
    }]
)
# Subsequent calls with same system prompt use cached prefix
# ~80% cost reduction on cached tokens
```

**Layer 3: Semantic cache (for similar-but-not-identical queries)**

```python
# Embed the query, search cache index for similar queries
query_embedding = get_embedding(query)
similar = vector_cache.search(query_embedding, threshold=0.95)
if similar:
    return similar[0].response  # Return cached response for semantically similar query
```

### Adding Monitoring and Alerting

**CloudWatch metrics to instrument:**

| Metric | Namespace | Alarm |
|---|---|---|
| Request latency (E2E) | Custom/GenAI | P99 > 5s |
| Bedrock invocation latency | AWS/Bedrock | P99 > 3s |
| Cache hit rate | Custom/GenAI | < 50% (expected > 70%) |
| Error rate | Custom/GenAI | > 1% |
| Token usage | Custom/GenAI | Daily > 2× baseline |
| Guardrail blocks | AWS/Bedrock | Spike > 3× baseline |
| Concurrent requests | Custom/GenAI | > 80% of provisioned capacity |

**X-Ray tracing for latency debugging:**

```python
from aws_xray_sdk.core import xray_recorder

@xray_recorder.capture("bedrock_invocation")
def invoke_bedrock(prompt):
    subsegment = xray_recorder.current_subsegment()
    subsegment.put_metadata("model", model_id)
    subsegment.put_metadata("input_tokens", count_tokens(prompt))
    response = bedrock.invoke_model(...)
    subsegment.put_metadata("output_tokens", response["usage"]["outputTokens"])
    return response
```

### Cost Projection and Optimization

| Phase | Monthly Cost | Strategy |
|---|---|---|
| POC (50 users) | $200 | On-demand, no caching |
| Early production (1K users) | $3,000 | On-demand + prompt caching |
| Growth (5K users) | $8,000 | Provisioned base + on-demand burst + Redis cache |
| Scale (10K users) | $12,000 | Full provisioned + semantic cache + model cascading |

**Model cascading at scale:**
- Simple factual queries (60% of traffic) → Haiku ($0.25/1M input)
- Complex reasoning (30%) → Sonnet ($3/1M input)
- Edge cases with low confidence (10%) → retry with Opus

### Load Testing and Performance Tuning

**Load test approach:**

```python
# Using Locust for load testing
class BedrockUser(HttpUser):
    wait_time = between(1, 5)

    @task(7)
    def simple_query(self):
        self.client.post("/api/query", json={
            "question": random.choice(simple_questions)
        })

    @task(3)
    def complex_query(self):
        self.client.post("/api/query", json={
            "question": random.choice(complex_questions)
        })
```

**Key performance findings and tuning:**
- **Bottleneck 1:** Vector search latency — solved by increasing OpenSearch OCUs
- **Bottleneck 2:** Cold start on Lambda — moved to ECS Fargate with warm pools
- **Bottleneck 3:** Bedrock throttling — provisioned throughput + request queuing
- **Bottleneck 4:** Large context windows — implemented conversation summarization

### Exam-Relevant Takeaways

1. **Provisioned Throughput for predictable workloads** — the exam will ask when to switch from on-demand.
2. **Three caching layers**: Application cache (Redis), Bedrock prompt caching, semantic cache.
3. **ECS Fargate over Lambda** for latency-sensitive GenAI apps (no cold starts).
4. **Model cascading** is the primary cost optimization for scale.
5. **X-Ray for end-to-end tracing** of GenAI request pipelines.

---

## Scenario 12: Cross-Region Disaster Recovery for GenAI

### Business Context

A financial services company runs a critical GenAI application in `us-east-1`. Regulatory requirements mandate a cross-region disaster recovery plan with RPO < 1 hour and RTO < 15 minutes.

### Primary/Secondary Region Setup

```
Primary (us-east-1)                    Secondary (us-west-2)
┌─────────────────────┐                ┌─────────────────────┐
│  Route 53 (Active)  │                │  Route 53 (Standby) │
│         │           │                │         │           │
│  ALB → ECS Fargate  │                │  ALB → ECS Fargate  │
│         │           │                │     (scaled to 0)   │
│  ┌──────┼──────┐    │                │  ┌──────┼──────┐    │
│  ▼      ▼      ▼    │                │  ▼      ▼      ▼    │
│ Bedrock  OSS  DDB   │  ──Repl──→    │ Bedrock  OSS  DDB   │
│          (Primary)   │                │          (Replica)  │
└─────────────────────┘                └─────────────────────┘
```

### Bedrock Cross-Region Inference

**Cross-region inference profiles:**

```python
# Use a cross-region inference profile for automatic failover
response = bedrock.converse(
    modelId="us.anthropic.claude-sonnet-4-20250514-v1:0",  # "us." prefix = cross-region
    messages=messages
)
# Bedrock automatically routes to available region
# If us-east-1 is down, traffic goes to us-west-2
```

**Key considerations:**
- Cross-region inference profiles (`us.model-name`) route to any US region
- You do NOT control which region handles the request
- For data residency: use single-region profiles and handle failover yourself
- Cross-region inference adds slight latency for cross-region routing

**For this scenario (financial services with data residency):**
- Use single-region inference profiles in each region
- Application-level failover via Route 53 health checks
- Ensures data stays within the designated region

### Vector Store Replication

**OpenSearch Serverless — no built-in cross-region replication.**

**Strategy: Dual-write with async sync**

```
New document ingested
        │
        ├──→ Primary KB (us-east-1) — sync
        │
        └──→ SQS (us-west-2 queue) → Lambda → Secondary KB (us-west-2) — async
```

**Alternative: S3 cross-region replication + KB re-sync**

```
S3 (us-east-1) ──CRR──→ S3 (us-west-2)
       │                        │
       ▼                        ▼
 KB Sync (primary)        KB Sync (secondary)
```

Preferred approach: S3 CRR + separate Knowledge Bases in each region. Each KB points to its regional S3 bucket. S3 CRR handles document replication; periodic KB data source sync picks up new documents.

### Route 53 Failover

```
Route 53 Health Check
    │
    ├── Checks: ALB health (us-east-1)
    ├── Checks: Bedrock endpoint health (custom Lambda)
    └── Checks: OpenSearch cluster health
    
Failover policy:
    Primary:   us-east-1 ALB (health check required)
    Secondary: us-west-2 ALB (health check required)
    
TTL: 60 seconds
```

**Custom health check for Bedrock:**

```python
def bedrock_health_check(event, context):
    try:
        response = bedrock.converse(
            modelId="anthropic.claude-haiku-3-20240307-v1:0",
            messages=[{"role": "user", "content": [{"text": "ping"}]}],
            inferenceConfig={"maxTokens": 5}
        )
        return {"statusCode": 200}
    except Exception:
        return {"statusCode": 503}
```

### RPO/RTO Analysis

| Component | RPO | RTO | Strategy |
|---|---|---|
| Application (ECS) | 0 (stateless) | ~2 min | Pre-deployed in secondary, scale from 0 |
| Bedrock models | 0 (managed service) | 0 | Available in both regions |
| Vector store (OSS) | < 1 hour | ~5 min | S3 CRR + periodic KB sync |
| DynamoDB | ~15 min | ~1 min | Global Tables (active-active) |
| User sessions | 0 | 0 | DynamoDB Global Tables |
| Configuration | 0 | ~1 min | SSM Parameter Store cross-region sync |

**Total RPO: < 1 hour** (bounded by vector store sync frequency)
**Total RTO: < 10 minutes** (ECS scaling + DNS propagation)

### Exam-Relevant Takeaways

1. **Cross-Region Inference profiles** (`us.model-name`) provide automatic Bedrock failover.
2. **OpenSearch Serverless has no native cross-region replication** — use S3 CRR + separate KBs.
3. **DynamoDB Global Tables** for active-active session and metadata replication.
4. **Route 53 failover** with custom health checks for Bedrock availability.
5. **RPO/RTO** — understand which components have what recovery characteristics.

---

## Scenario 13: Building a Multimodal Content Generation Platform

### Business Context

A marketing agency wants a platform where teams can generate blog posts, social media images, product descriptions, and video scripts — all coordinated through a unified content workflow.

### Architecture

```
Content Brief (User Input)
        │
        ▼
  Bedrock Agent (Content Orchestrator)
        │
        ├──→ Claude Sonnet: Generate blog post draft
        │
        ├──→ Claude Sonnet: Create social media variants
        │         (Twitter/X, LinkedIn, Instagram captions)
        │
        ├──→ Titan Image Generator: Create featured image
        │         + social media graphics
        │
        ├──→ Claude Haiku: Generate SEO metadata
        │         (title, description, keywords)
        │
        └──→ Nova Reel: Short video clip (optional)
                  
        All outputs → S3 → CloudFront (CDN delivery)
```

### Titan Image Generator + Text Models

**Image generation workflow:**

```python
# Generate featured image
response = bedrock.invoke_model(
    modelId="amazon.titan-image-generator-v2:0",
    body=json.dumps({
        "textToImageParams": {
            "text": "Modern minimalist office workspace with plants, "
                    "warm lighting, aerial view, professional photography style",
            "negativeText": "blurry, low quality, text, watermark"
        },
        "imageGenerationConfig": {
            "numberOfImages": 3,
            "width": 1024,
            "height": 1024,
            "cfgScale": 8.0,
            "seed": 42
        }
    })
)

images = [base64.b64decode(img["base64"]) for img in response["images"]]
```

**Image variations for different platforms:**

| Platform | Dimensions | Model Config |
|---|---|---|
| Blog featured image | 1024 × 576 | High quality, detailed |
| Instagram post | 1024 × 1024 | Vibrant, attention-grabbing |
| Twitter/X header | 1024 × 512 | Clean, brand-aligned |
| LinkedIn | 1024 × 576 | Professional, corporate |

### Prompt Chaining for Content Workflows

```
Step 1: Content Brief Analysis
    Input: Raw brief from user
    Model: Claude Sonnet
    Output: Structured content plan (topics, tone, key messages)
        │
Step 2: Blog Post Generation
    Input: Content plan + brand guidelines (from KB)
    Model: Claude Sonnet
    Output: Full blog post (1500-2000 words)
        │
Step 3: Social Media Variants
    Input: Blog post + platform specifications
    Model: Claude Sonnet
    Output: Platform-specific posts with hashtags
        │
Step 4: Image Prompt Generation
    Input: Blog post summary + brand visual guidelines
    Model: Claude Haiku
    Output: Detailed image generation prompts
        │
Step 5: Image Generation
    Input: Image prompts from Step 4
    Model: Titan Image Generator
    Output: Images for each platform
        │
Step 6: SEO Optimization
    Input: Blog post + target keywords
    Model: Claude Haiku
    Output: Meta title, description, schema markup
```

**Implementation:** Step Functions workflow with each step as a Lambda function. Parallel branches where possible (Steps 3, 4, 6 can run simultaneously after Step 2).

### Content Moderation Pipeline

Every generated asset passes through moderation before delivery:

```python
# Text moderation
text_check = bedrock.apply_guardrail(
    guardrailIdentifier="gr-content-mod",
    guardrailVersion="DRAFT",
    source="OUTPUT",
    content=[{"text": {"text": generated_text}}]
)

# Image moderation (Titan Image Generator has built-in)
# Additionally, use Rekognition for custom moderation
image_check = rekognition.detect_moderation_labels(
    Image={"Bytes": generated_image_bytes},
    MinConfidence=80
)

if image_check["ModerationLabels"]:
    flag_for_review(image_check["ModerationLabels"])
```

**Moderation rules:**
- Block explicit/violent content
- Flag brand-safety concerns (competitor logos, controversial imagery)
- Verify text in images doesn't contain PII

### Storage and Delivery

```
Generated Content → S3 (versioned)
                      │
                      ├── /blog-posts/{campaign-id}/draft-v1.md
                      ├── /images/{campaign-id}/featured-1024x576.png
                      ├── /social/{campaign-id}/twitter.txt
                      └── /metadata/{campaign-id}/seo.json
                      
S3 → CloudFront (CDN)
      │
      ├── Blog images served via CloudFront URL
      ├── Social media images with signed URLs (time-limited)
      └── OAC (Origin Access Control) restricts direct S3 access
```

### Cost Tracking per Generation

```python
# Tag every generation with campaign and cost metadata
cost_record = {
    "campaign_id": campaign_id,
    "step": "image_generation",
    "model_id": "amazon.titan-image-generator-v2:0",
    "image_count": 3,
    "estimated_cost": 0.024,  # $0.008 per image × 3
    "timestamp": datetime.utcnow().isoformat()
}
dynamodb.put_item(TableName="generation-costs", Item=cost_record)

# Monthly cost report aggregated by campaign
# Uses DynamoDB GSI on campaign_id + timestamp
```

**Cost per content piece (estimated):**

| Component | Cost |
|---|---|
| Blog post (Sonnet, ~3K output tokens) | $0.045 |
| Social variants (Sonnet, ~500 tokens × 4) | $0.030 |
| Image prompts (Haiku) | $0.001 |
| Images (Titan, 3 variants) | $0.024 |
| SEO metadata (Haiku) | $0.001 |
| **Total per content piece** | **~$0.10** |

### Exam-Relevant Takeaways

1. **Titan Image Generator** for image generation — know the API parameters (text, negativeText, dimensions, cfgScale).
2. **Prompt chaining** implemented via Step Functions, not monolithic Lambda.
3. **CloudFront + S3 with OAC** for content delivery — standard pattern.
4. **Rekognition for image moderation** alongside Bedrock Guardrails for text moderation.
5. **Cost tracking** requires custom implementation — Bedrock doesn't provide per-request cost breakdown natively.

---

## Scenario 14: Implementing GenAI Governance at Enterprise Scale

### Business Context

A Fortune 500 company has 50 teams experimenting with GenAI. The CTO wants centralized governance: cost visibility, security guardrails, model approval workflows, and compliance reporting — without slowing down innovation.

### Centralized GenAI Gateway

```
Team A ──┐
Team B ──┼──→ API Gateway (GenAI Gateway) ──→ Lambda (Router/Policy)
Team C ──┘              │                              │
                   WAF + Auth                    ┌─────┼─────┐
                                                 ▼     ▼     ▼
                                              Bedrock  Usage   Audit
                                              (Model)  Tracker  Log
```

**Gateway responsibilities:**
- Authentication (API keys per team, rotated quarterly)
- Authorization (which team can use which models)
- Rate limiting per team
- Request/response logging for audit
- Cost tagging and allocation
- Guardrail enforcement (company-wide policies)

**Implementation:**

```python
# Lambda authorizer checks team permissions
def authorize(event):
    team_id = extract_team_from_api_key(event)
    requested_model = event["body"]["modelId"]

    allowed_models = get_team_permissions(team_id)
    if requested_model not in allowed_models:
        raise UnauthorizedException(
            f"Team {team_id} not authorized for {requested_model}"
        )

    # Check budget
    monthly_spend = get_team_spend(team_id)
    if monthly_spend > get_team_budget(team_id):
        raise BudgetExceededException(
            f"Team {team_id} has exceeded monthly budget"
        )

    return {"principalId": team_id, "policyDocument": allow_policy}
```

### Cost Allocation by Department

**Tagging strategy:**

```json
{
  "ResourceTags": {
    "Team": "marketing",
    "Project": "content-gen",
    "CostCenter": "CC-4521",
    "Environment": "production"
  }
}
```

**Cost tracking implementation:**

```
Every Bedrock API call → Lambda (post-processing)
        │
        ├── Extract token usage from response metadata
        ├── Calculate cost based on model pricing
        ├── Tag with team/project from API key mapping
        └── Write to DynamoDB (cost-tracking table)
              │
              ▼
        QuickSight Dashboard
              │
              ├── Cost by team (monthly trend)
              ├── Cost by model (which models are expensive)
              ├── Cost by project
              └── Anomaly detection (unexpected spikes)
```

**AWS Cost Explorer integration:**
- Use resource tags for Bedrock resources (provisioned throughput, custom models)
- For on-demand usage, custom cost tracking is needed (Cost Explorer doesn't break down by API call)

### Usage Policies and Guardrails

**Company-wide guardrails (applied at gateway level):**

```json
{
  "companyGuardrail": {
    "contentPolicy": {
      "filters": [
        { "type": "HATE", "inputStrength": "HIGH", "outputStrength": "HIGH" },
        { "type": "VIOLENCE", "inputStrength": "HIGH", "outputStrength": "HIGH" }
      ]
    },
    "sensitiveInformation": {
      "piiEntities": [
        { "type": "SSN", "action": "BLOCK" },
        { "type": "CREDIT_DEBIT_CARD_NUMBER", "action": "BLOCK" }
      ]
    },
    "wordPolicy": {
      "wordsConfig": [
        { "text": "COMPANY_INTERNAL_CODENAME_X" }
      ]
    },
    "topicPolicy": {
      "topics": [
        {
          "name": "legal-advice",
          "definition": "Providing specific legal advice or opinions",
          "type": "DENY"
        }
      ]
    }
  }
}
```

**Team-specific guardrails (layered on top):**
- Marketing: Additional brand safety rules
- Engineering: Allow code generation, deny production credential discussion
- HR: ANONYMIZE all employee names in output

### Model Approval Workflow

```
Team requests new model access
        │
        ▼
  ServiceNow ticket created
        │
        ▼
  Security review (automated)
    ├── Model data handling policy check
    ├── Cost projection
    └── Compliance requirements
        │
        ▼
  Manager approval (if cost > threshold)
        │
        ▼
  IAM policy updated via CDK pipeline
        │
        ▼
  Team can access model through gateway
```

**IAM structure:**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "bedrock:InvokeModel",
      "Resource": [
        "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-haiku-*",
        "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-sonnet-*"
      ],
      "Condition": {
        "StringEquals": {
          "aws:PrincipalTag/Team": "marketing"
        }
      }
    },
    {
      "Effect": "Deny",
      "Action": "bedrock:InvokeModel",
      "Resource": "arn:aws:bedrock:*::foundation-model/anthropic.claude-opus-*"
    }
  ]
}
```

### Audit and Compliance Reporting

**Automated compliance report (monthly):**

| Section | Data Source |
|---|---|
| Model usage by team | Custom cost tracking DynamoDB |
| Guardrail intervention summary | CloudWatch Logs (guardrail metrics) |
| Security incidents | GuardDuty + CloudTrail anomalies |
| Data handling compliance | Bedrock model invocation logs (no data stored) |
| Access control changes | CloudTrail IAM events |
| Budget adherence | Custom cost tracking vs budget |

**Report generation:** Monthly Lambda → queries DynamoDB + CloudWatch → generates report → sends to compliance team via SES.

### Service Catalog for Approved Architectures

**AWS Service Catalog products for GenAI:**

| Product | Description |
|---|---|
| RAG Application Stack | Bedrock KB + OpenSearch + Lambda + API Gateway (pre-configured) |
| Chatbot Starter | Bedrock Agent + Guardrails + WebSocket API Gateway |
| Document Processing | Textract + Bedrock + Step Functions pipeline |
| Custom Model Training | SageMaker training job with approved instance types |

**Each product includes:**
- Pre-configured IAM roles (least privilege)
- Guardrails attached by default
- Cost alerting built-in
- Tagging enforced via Service Catalog constraints

### Exam-Relevant Takeaways

1. **API Gateway as a GenAI gateway** — centralized auth, rate limiting, cost tracking.
2. **IAM policies with conditions** (`aws:PrincipalTag`) for team-based model access control.
3. **Bedrock Guardrails can be applied at the gateway level** — company-wide + team-specific layers.
4. **Service Catalog** for pre-approved GenAI architecture patterns.
5. **Cost allocation requires custom tracking** for on-demand Bedrock usage — Cost Explorer alone isn't granular enough.
6. **CloudTrail + CloudWatch** for compliance audit trail.

---

## Scenario 15: Debugging a Production RAG System with Poor Relevance

### Business Context

A legal tech company launched a RAG system for contract analysis 3 months ago. User satisfaction has dropped from 85% to 55%. Lawyers complain: "The AI gives generic answers" and "It misses clauses that are clearly in the contract." Time to debug.

### Systematic Troubleshooting Approach

```
Reported Problem: Poor relevance
        │
        ▼
  Step 1: Quantify the problem
        │ → Run evaluation suite, measure metrics
        ▼
  Step 2: Isolate the stage
        │ → Is it retrieval or generation?
        ▼
  Step 3: Diagnose root cause
        │ → Embedding quality? Chunking? Prompt?
        ▼
  Step 4: Implement fix
        │ → Targeted improvement
        ▼
  Step 5: Validate improvement
        │ → Re-run evaluation, A/B test
        ▼
  Step 6: Monitor ongoing
```

### Step 1: Quantify with Evaluation

**Create a ground truth test set:**
- Collect 200 real user queries with lawyer-verified correct answers
- Include the specific contract sections that contain the answer
- Categorize by difficulty (simple lookup, multi-section synthesis, inference required)

**Bedrock evaluation job:**

```python
evaluation_job = bedrock.create_evaluation_job(
    jobName="rag-debugging-eval-v1",
    evaluationConfig={
        "automated": {
            "datasetMetricConfigs": [{
                "taskType": "QuestionAndAnswer",
                "metricNames": ["Correctness", "Completeness", "Helpfulness"],
                "dataset": {
                    "name": "rag-eval-dataset",
                    "datasetLocation": {"s3Uri": "s3://eval-bucket/ground-truth.jsonl"}
                }
            }]
        }
    },
    inferenceConfig={
        "models": [{
            "bedrockModel": {
                "modelIdentifier": "anthropic.claude-sonnet-4-20250514-v1:0"
            }
        }]
    }
)
```

**Results:**
- Correctness: 62% (was 88% at launch)
- Completeness: 45% (many partial answers)
- Helpfulness: 58%
- **Key finding:** Retrieval recall only 40% — the right chunks aren't being found.

### Step 2: Isolate — Retrieval vs Generation

**Test: Give the model the correct context manually.**

```python
# Bypass retrieval — manually provide the right contract section
response = bedrock.converse(
    modelId="anthropic.claude-sonnet-4-20250514-v1:0",
    messages=[{
        "role": "user",
        "content": [{
            "text": f"Given this contract section:\n{correct_section}\n\n"
                    f"Answer: {user_query}"
        }]
    }]
)
# Result: 92% correctness when given correct context
# Conclusion: Generation is fine. RETRIEVAL is the problem.
```

### Step 3: Embedding Quality Analysis

**Problem 1: Embedding model mismatch**
- Corpus was embedded with Titan Embeddings V1 (1536 dimensions)
- New documents added last month used Titan Embeddings V2 (1024 dimensions)
- **These embeddings are incompatible** — mixing them in the same index degrades search quality

**Problem 2: Legal terminology not well-represented**
- Test: Embed "indemnification clause" and "hold harmless provision" — cosine similarity only 0.72
- These are synonymous in legal context but the general-purpose embedding model doesn't capture this

**Fix for Problem 1:** Re-embed entire corpus with V2 (consistent embeddings).

**Fix for Problem 2:** Two options:
- **Option A:** Add metadata keyword tags to chunks for hybrid search (BM25 catches legal synonyms)
- **Option B:** Fine-tune a custom embedding model on legal corpus (expensive, better long-term)

### Step 4: Chunking Strategy Evaluation

**Current chunking: Fixed 1000-token chunks with 200-token overlap.**

**Problem:** Legal contracts have hierarchical structure. A 1000-token chunk often splits a clause mid-sentence, or merges parts of two unrelated clauses.

**Analysis:**

```python
# Sample problematic chunk
chunk_47 = """
...reasonable efforts to mitigate damages. 

8.3 Limitation of Liability

NOTWITHSTANDING ANYTHING TO THE CONTRARY IN THIS AGREEMENT, IN NO EVENT 
SHALL EITHER PARTY BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, 
CONSEQUENTIAL, OR PUNITIVE DAMAGES...
"""
# This chunk contains the END of Section 8.2 and the START of Section 8.3
# A query about "limitation of liability" retrieves this chunk
# but misses the FULL section 8.3 which continues in the next chunk
```

**Improved chunking strategy:**

1. **Hierarchical chunking by document structure:**
   - Split on section headers (identified by regex: `\d+\.\d+\s+[A-Z]`)
   - Each section becomes one chunk (even if > 1000 tokens)
   - For very long sections, split on paragraph boundaries within the section

2. **Parent-child chunking:**
   - Index small chunks (300 tokens) for precise retrieval
   - Store parent chunks (full section, up to 2000 tokens) for context
   - Retrieve on small chunk, return parent chunk to the model

3. **Metadata enrichment:**
   ```json
   {
     "section_number": "8.3",
     "section_title": "Limitation of Liability",
     "document_name": "MSA-ACME-2025.pdf",
     "clause_type": "liability",
     "page_number": 12
   }
   ```

### Step 5: Retrieval Pipeline Debugging

**Current pipeline:**
```
Query → Embed → kNN search (top-5) → Concatenate → Send to model
```

**Problems identified:**

1. **Top-K too low:** Only retrieving 5 chunks. For multi-section queries ("Compare the indemnification and limitation of liability clauses"), 5 chunks aren't enough.

2. **No query rewriting:** User asks "What happens if we breach?" — the embedding of this casual question doesn't match the formal legal language in the contracts.

3. **No reranking:** kNN retrieves semantically similar chunks, but some are from wrong contracts (multi-tenant system).

### Step 6: Implementing Reranking

**Add a reranking step after initial retrieval:**

```
Query → Embed → kNN search (top-20) → Reranker (top-5) → Send to model
```

**Reranking implementation options:**

| Option | Approach | Latency | Quality |
|---|---|---|---|
| Bedrock Reranker | Use Bedrock's built-in reranking model (Cohere Rerank) | +200ms | High |
| Cross-encoder | Deploy a cross-encoder model on SageMaker | +150ms | High |
| LLM reranker | Ask Claude to rank relevance of candidates | +1000ms | Highest |

**Bedrock KB reranking configuration:**

```python
response = bedrock_agent_runtime.retrieve(
    knowledgeBaseId=KB_ID,
    retrievalQuery={"text": query},
    retrievalConfiguration={
        "vectorSearchConfiguration": {
            "numberOfResults": 20,  # Retrieve more candidates
            "overrideSearchType": "HYBRID"  # BM25 + semantic
        },
        "rerankingConfiguration": {
            "type": "BEDROCK_RERANKING_MODEL",
            "bedrockRerankingConfiguration": {
                "numberOfRerankedResults": 5,
                "modelConfiguration": {
                    "modelArn": "arn:aws:bedrock:us-east-1::foundation-model/cohere.rerank-v3-5:0"
                }
            }
        }
    }
)
```

### Step 7: Query Rewriting

Add a query expansion step:

```python
def rewrite_query(user_query: str) -> str:
    response = bedrock.converse(
        modelId="anthropic.claude-haiku-3-20240307-v1:0",
        messages=[{
            "role": "user",
            "content": [{
                "text": f"Rewrite this query for searching legal contracts. "
                        f"Use formal legal terminology. Output only the rewritten query.\n"
                        f"Query: {user_query}"
            }]
        }]
    )
    return response["output"]["message"]["content"][0]["text"]

# "What happens if we breach?" →
# "Consequences and remedies for material breach of agreement, 
#  including termination rights, cure periods, and damages"
```

### Results After Fixes

| Metric | Before | After | Improvement |
|---|---|---|---|
| Retrieval recall | 40% | 82% | +105% |
| Correctness | 62% | 89% | +44% |
| Completeness | 45% | 81% | +80% |
| User satisfaction | 55% | 88% | +60% |
| Latency (P50) | 1.2s | 1.8s | +0.6s (acceptable) |

### Monitoring Improvements

**New metrics added:**
- Retrieval recall (weekly eval job)
- Chunk relevance score distribution (logged per query)
- Query rewrite frequency and impact
- Reranker score distribution (detect ranking quality degradation)
- User feedback correlation with retrieval scores

**Alerting:**
- Weekly evaluation correctness drops below 80% → alarm
- Daily average retrieval score drops below 0.6 → alarm
- Negative feedback rate exceeds 20% → alarm

### Exam-Relevant Takeaways

1. **Debug RAG by isolating retrieval vs generation** — test with known-good context first.
2. **Mixing embedding model versions is a common pitfall** — always re-embed when changing models.
3. **Hierarchical/semantic chunking** for structured documents (legal, financial, technical).
4. **Reranking dramatically improves precision** — retrieve more candidates, rerank to top-K.
5. **Hybrid search (BM25 + semantic)** catches keyword matches that embeddings miss.
6. **Query rewriting** bridges the gap between casual user language and formal document language.
7. **Bedrock evaluation jobs** for automated quality measurement — run regularly, not just at launch.

---

## Cross-Scenario Summary: Key Patterns

| Pattern | Scenarios |
|---|---|
| RAG with Bedrock KB | 1, 7, 8, 9, 15 |
| Bedrock Agents for orchestration | 1, 3, 7, 10, 13 |
| Guardrails for safety | 1, 4, 6, 14 |
| Step Functions for workflows | 2, 3, 13 |
| Provisioned Throughput for cost | 1, 5, 11 |
| Model cascading | 1, 3, 11, 15 |
| Cross-region considerations | 6, 12 |
| VPC endpoints for security | 6, 14 |
| Evaluation and monitoring | 1, 8, 11, 15 |
| Prompt caching | 1, 5, 11 |

> **Exam strategy:** When you see a scenario question, map it to the closest pattern above. The architecture components are reusable — the exam tests whether you pick the right combination.
