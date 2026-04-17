# 14 — Quick Reference Cheat Sheet: Last-Day Review

> Designed for a 30-minute final review before the AWS Certified AI Practitioner / GenAI Developer – Professional exam.

---

## 1. Service Quick Reference Table

### Core GenAI Services

| Service | One-Line Description | When to Use |
|---|---|---|
| **Amazon Bedrock** | Managed service to access foundation models via API | Default choice for GenAI application development |
| **Amazon SageMaker** | Full ML platform for training, tuning, and hosting models | Custom model training, BYOM, full control needed |
| **Amazon Q Business** | AI assistant for enterprise data search and Q&A | Enterprise knowledge search with built-in connectors |
| **Amazon Q Developer** | AI coding assistant | Code generation, review, debugging, transformation |

### Bedrock Sub-Services

| Service | One-Line Description | When to Use |
|---|---|---|
| **Bedrock Knowledge Bases** | Managed RAG — ingest, embed, store, retrieve | Whenever you need retrieval-augmented generation |
| **Bedrock Agents** | Autonomous task execution with tool use | Multi-step tasks requiring API calls or KB queries |
| **Bedrock Guardrails** | Content filtering, PII protection, topic blocking | Any customer-facing GenAI app needing safety rails |
| **Bedrock Evaluation** | Automated model quality assessment | Comparing models, measuring RAG quality, regression testing |
| **Bedrock Fine-Tuning** | Customize models with your data | Domain-specific vocabulary, consistent style/format |
| **Bedrock Prompt Management** | Version and manage prompt templates | Production prompt lifecycle management |
| **Bedrock Model Catalog** | Browse and access FMs | Discovering available models |
| **Bedrock Marketplace** | Third-party model access | Specialized models not natively in Bedrock |

### AI/ML Services (Supporting)

| Service | One-Line Description | When to Use |
|---|---|---|
| **Amazon Textract** | Extract text, tables, forms from documents | Document processing, OCR, form extraction |
| **Amazon Comprehend** | NLP: entities, sentiment, language, PII, toxicity | Text analysis without a custom model |
| **Amazon Rekognition** | Image/video analysis: labels, faces, moderation | Image moderation, visual content analysis |
| **Amazon Translate** | Neural machine translation | Real-time or batch text translation |
| **Amazon Polly** | Text-to-speech | Voice interfaces |
| **Amazon Transcribe** | Speech-to-text | Audio/video transcription |
| **Amazon Kendra** | Intelligent search (precursor to Q Business) | Enterprise search (legacy, prefer Q Business) |

### Infrastructure & Orchestration

| Service | One-Line Description | When to Use |
|---|---|---|
| **AWS Step Functions** | Serverless workflow orchestration | Multi-step GenAI pipelines, human-in-the-loop |
| **AWS Lambda** | Serverless compute | Glue code, event processing, API handlers |
| **Amazon ECS/Fargate** | Container orchestration | Latency-sensitive GenAI apps (no cold starts) |
| **Amazon API Gateway** | REST/WebSocket API management | GenAI app frontend, centralized gateway |
| **Amazon EventBridge** | Event bus for decoupled architectures | Event-driven GenAI pipeline triggers |

### Data & Storage

| Service | One-Line Description | When to Use |
|---|---|---|
| **OpenSearch Serverless** | Managed vector search + BM25 | Large-scale vector store with hybrid search |
| **Aurora pgvector** | PostgreSQL with vector extension | Smaller vector workloads, existing Aurora users |
| **Amazon S3** | Object storage | Document storage, KB data sources, model artifacts |
| **Amazon DynamoDB** | NoSQL key-value/document DB | Metadata, sessions, conversation history |
| **ElastiCache (Redis)** | In-memory cache | Response caching, semantic caching |
| **Amazon Neptune** | Graph database | Knowledge graphs, entity relationships |
| **Amazon MemoryDB** | Durable in-memory DB with vector search | Vector search + durable caching in one service |

### Security & Monitoring

| Service | One-Line Description | When to Use |
|---|---|---|
| **AWS IAM** | Identity and access management | Control who can invoke which models |
| **AWS KMS** | Key management for encryption | Encrypt data at rest (S3, DynamoDB, custom models) |
| **AWS CloudTrail** | API call audit logging | Compliance audit, tracking Bedrock invocations |
| **Amazon CloudWatch** | Metrics, logs, alarms, dashboards | Monitoring Bedrock latency, errors, throttling |
| **AWS X-Ray** | Distributed tracing | End-to-end latency debugging in GenAI pipelines |
| **VPC Endpoints** | Private connectivity to AWS services | HIPAA/PCI — keep Bedrock traffic off public internet |
| **AWS WAF** | Web application firewall | Protect GenAI API endpoints from abuse |
| **AWS Service Catalog** | Pre-approved resource templates | Governed self-service for GenAI architectures |

---

## 2. Decision Trees

### Bedrock vs SageMaker

```
Need a foundation model for your app?
├── YES: Do you need to TRAIN a custom model from scratch?
│   ├── YES → SageMaker
│   └── NO: Do you need fine-tuning?
│       ├── YES: Is the model available in Bedrock?
│       │   ├── YES → Bedrock Fine-Tuning
│       │   └── NO → SageMaker
│       └── NO: Just need inference?
│           ├── Model available in Bedrock? → Bedrock (InvokeModel / Converse)
│           └── Custom/open-source model? → SageMaker Endpoint
└── NO: Need traditional ML (classification, regression)?
    └── SageMaker
```

**Rule of thumb:** Bedrock = managed FM access. SageMaker = full ML control.

### Vector Store Selection

```
How many vectors?
├── < 1M vectors
│   ├── Already using Aurora? → Aurora pgvector
│   ├── Need graph relationships too? → Neptune Analytics
│   └── Want simplest setup? → OpenSearch Serverless (Bedrock KB default)
├── 1M–100M vectors
│   ├── Need hybrid search (keyword + semantic)? → OpenSearch Serverless
│   ├── Need SQL filtering? → Aurora pgvector
│   └── Need vector + durable cache? → MemoryDB
└── > 100M vectors
    └── OpenSearch Serverless (scales to billions)

Special case: Need zero infrastructure?
└── Bedrock KB with default vector store (OSS auto-provisioned)
```

### Chunking Strategy Selection

```
What type of document?
├── Short, self-contained (FAQs, product descriptions)
│   └── Fixed-size (300-500 tokens) or no chunking if < 500 tokens
├── Structured with headings (technical docs, legal contracts)
│   └── Hierarchical chunking (split on headers, then by size)
├── Narrative/conversational (emails, chat logs, meeting notes)
│   └── Semantic chunking (split on topic shifts)
├── Mixed format (tables + text + images)
│   └── Semantic chunking + special handling for tables
└── Unknown or varied
    └── Start with fixed-size (512 tokens, 20% overlap), evaluate, iterate
```

### Model Selection

```
What's your task?
├── Simple classification, extraction, summarization
│   └── Claude Haiku / Llama 3 8B (cheapest)
├── General-purpose dialogue, writing, analysis
│   └── Claude Sonnet / Llama 3 70B (best price/performance)
├── Complex reasoning, nuanced analysis, hard tasks
│   └── Claude Opus (highest quality)
├── Embeddings
│   └── Titan Text Embeddings V2 (default) or Cohere Embed
├── Image generation
│   └── Titan Image Generator / Stability AI SDXL
├── Video generation
│   └── Nova Reel
└── Need maximum compatibility / standardization?
    └── Use Converse API → swap models without code changes
```

### Fine-Tuning vs RAG vs Prompt Engineering

```
What's the problem?
├── Model doesn't know about YOUR data (company docs, products, policies)
│   └── RAG (Bedrock Knowledge Bases)
├── Model knows the information but doesn't FORMAT output right
│   └── Prompt Engineering (few-shot examples, system prompt)
├── Model needs to use SPECIFIC TERMINOLOGY consistently
│   └── Fine-Tuning (teach domain vocabulary and style)
├── Model's REASONING is wrong for your domain
│   └── Fine-Tuning (or stronger model)
└── All of the above?
    └── RAG + Fine-Tuning + Prompt Engineering (they stack)
```

**Critical exam trap:** RAG for knowledge. Fine-tuning for behavior/style. They solve different problems.

### Caching Strategy Selection

```
What are you caching?
├── Exact same prompts repeated frequently
│   └── Application-level cache (ElastiCache Redis) — hash prompt → response
├── Long system prompts reused across conversations
│   └── Bedrock Prompt Caching (cachePoint in system message)
├── Similar (not identical) queries returning same info
│   └── Semantic cache (embed query → vector search cache index)
├── RAG retrieval results for popular queries
│   └── Cache retrieval results (ElastiCache, TTL = content freshness window)
└── Static reference data in prompts
    └── Bedrock Prompt Caching (cache the reference data block)
```

---

## 3. Key Numbers to Remember

### Token Limits (Approximate — Check Docs for Latest)

| Model | Context Window | Max Output |
|---|---|---|
| Claude 3.5 Sonnet | 200K tokens | 8,192 tokens |
| Claude 3 Opus | 200K tokens | 4,096 tokens |
| Claude 3 Haiku | 200K tokens | 4,096 tokens |
| Llama 3 (8B/70B) | 8K tokens | 2,048 tokens |
| Titan Text Premier | 32K tokens | 3,072 tokens |
| Titan Embeddings V2 | 8,192 tokens | 1,024 dimensions (output) |
| Cohere Embed | 512 tokens | 1,024 dimensions |

### Bedrock API Limits (Default)

| Limit | Default Value |
|---|---|
| InvokeModel requests/min | Model-dependent (typically 50-1000) |
| Knowledge Base data sources | 5 per KB |
| KB file size max | 50 MB |
| KB supported formats | PDF, TXT, MD, HTML, DOC/DOCX, CSV, XLS/XLSX |
| Guardrails per account | 100 |
| Agents per account | 100 |
| Agent action groups | 20 per agent |
| Agent session timeout | 1 hour (configurable) |
| Custom model training | 1 concurrent job (default) |
| Provisioned Throughput commitment | 1 month or 6 months |

### CloudWatch Metric Names for Bedrock

| Metric | Namespace | What It Measures |
|---|---|---|
| `Invocations` | AWS/Bedrock | Number of InvokeModel calls |
| `InvocationLatency` | AWS/Bedrock | Time to process request (ms) |
| `InvocationClientErrors` | AWS/Bedrock | 4xx errors (bad requests) |
| `InvocationServerErrors` | AWS/Bedrock | 5xx errors (service issues) |
| `InvocationThrottles` | AWS/Bedrock | Throttled requests (429) |
| `InputTokenCount` | AWS/Bedrock | Tokens sent to model |
| `OutputTokenCount` | AWS/Bedrock | Tokens generated by model |
| `InvocationCount` (Guardrails) | AWS/Bedrock | Guardrail evaluations |

### IAM Policy Patterns for Bedrock

**Invoke specific models:**
```json
{
  "Effect": "Allow",
  "Action": "bedrock:InvokeModel",
  "Resource": "arn:aws:bedrock:REGION::foundation-model/MODEL_ID"
}
```

**Deny specific models (e.g., block expensive models):**
```json
{
  "Effect": "Deny",
  "Action": "bedrock:InvokeModel",
  "Resource": "arn:aws:bedrock:*::foundation-model/anthropic.claude-opus-*"
}
```

**Restrict by tag (team-based access):**
```json
{
  "Condition": {
    "StringEquals": {
      "aws:PrincipalTag/Team": "${aws:PrincipalTag/Team}"
    }
  }
}
```

**Require guardrail on every invocation (SCP):**
```json
{
  "Effect": "Deny",
  "Action": "bedrock:InvokeModel",
  "Resource": "*",
  "Condition": {
    "Null": {
      "bedrock:GuardrailId": "true"
    }
  }
}
```

---

## 4. Common Exam Traps

### Bedrock vs SageMaker Misconceptions

| Trap | Reality |
|---|---|
| "SageMaker is always better for fine-tuning" | Bedrock supports fine-tuning for supported models — use it for simpler cases |
| "Bedrock can train models from scratch" | NO — Bedrock only does fine-tuning and continued pre-training. Training from scratch = SageMaker |
| "SageMaker is needed for RAG" | NO — Bedrock Knowledge Bases handle RAG end-to-end |
| "Bedrock supports all open-source models" | Only models available in Bedrock Model Catalog. For arbitrary HuggingFace models → SageMaker |
| "SageMaker endpoints are cheaper" | Not necessarily — you pay for uptime. Bedrock on-demand = pay per token (often cheaper for variable loads) |

### Security Pitfalls

| Trap | Reality |
|---|---|
| "Bedrock stores your prompts" | By default, NO. Bedrock does not store or log prompts/completions |
| "VPC endpoints are optional for HIPAA" | Practically required — keeps traffic off public internet |
| "IAM alone is enough for model access control" | Also need VPC endpoint policies, SCPs, and Guardrails |
| "Encryption at rest is automatic" | S3 and DynamoDB yes (SSE), but custom KMS keys needed for compliance |
| "CloudTrail captures prompt content" | CloudTrail captures API metadata, not prompt/response content by default |

### Cost Optimization Myths

| Trap | Reality |
|---|---|
| "Provisioned Throughput always saves money" | Only for consistent, predictable loads. Bursty workloads are cheaper on-demand |
| "Smaller models are always cheaper" | Not if they require more retries or longer prompts to get good output |
| "Caching is free" | ElastiCache/Redis costs money. Calculate cache hit rate × savings vs cache infrastructure cost |
| "Cross-region inference is more expensive" | Same per-token price, but adds routing latency |
| "Fine-tuning reduces inference cost" | Fine-tuned model inference is MORE expensive per token. Fine-tuning saves by reducing prompt size or retries |

### When NOT to Use Fine-Tuning

- You just need the model to know about your documents → **Use RAG**
- You need a different output format → **Use prompt engineering (few-shot)**
- You have < 100 training examples → **Not enough data; use prompt engineering**
- The base model is already accurate, just slow → **Use a smaller model or caching**
- Your data changes frequently → **RAG** (fine-tuning creates a static snapshot)

---

## 5. Acronym Reference

| Acronym | Full Form | Context |
|---|---|---|
| **RAG** | Retrieval-Augmented Generation | Combine retrieval with generation to ground responses |
| **FM** | Foundation Model | Large pre-trained model (Claude, Titan, Llama, etc.) |
| **LLM** | Large Language Model | Text-focused foundation model |
| **MCP** | Model Context Protocol | Standard protocol for tool use across AI agents |
| **LoRA** | Low-Rank Adaptation | Parameter-efficient fine-tuning technique |
| **PII** | Personally Identifiable Information | Names, SSNs, emails — what Guardrails can filter |
| **RBAC** | Role-Based Access Control | IAM roles/policies for access management |
| **ABAC** | Attribute-Based Access Control | Tag-based IAM conditions |
| **PHI** | Protected Health Information | HIPAA-regulated medical data |
| **HIPAA** | Health Insurance Portability and Accountability Act | US healthcare data regulation |
| **SOC 2** | System and Organization Controls 2 | Security/availability compliance framework |
| **SOX** | Sarbanes-Oxley Act | Financial reporting compliance |
| **TTFB** | Time to First Byte | Latency measure for streaming responses |
| **kNN** | k-Nearest Neighbors | Vector similarity search algorithm |
| **BM25** | Best Matching 25 | Keyword-based text ranking algorithm |
| **OCU** | OpenSearch Compute Unit | Billing unit for OpenSearch Serverless |
| **OAC** | Origin Access Control | CloudFront → S3 access method (replaces OAI) |
| **SCP** | Service Control Policy | Organization-wide IAM guardrails |
| **SAST** | Static Application Security Testing | CodeGuru Security type |
| **RPO** | Recovery Point Objective | Max acceptable data loss (time) |
| **RTO** | Recovery Time Objective | Max acceptable downtime |
| **EOS** | End of Sequence | Token that signals model to stop generating |
| **RLHF** | Reinforcement Learning from Human Feedback | Technique to align models with human preferences |
| **CoT** | Chain of Thought | Prompting technique for step-by-step reasoning |
| **ReAct** | Reasoning + Acting | Agent pattern: reason about task, take actions, observe results |
| **RAGAS** | RAG Assessment | Framework for evaluating RAG quality |

---

## 6. AWS Service Pairs

Services that commonly work together in GenAI architectures:

| Pair | Use Case |
|---|---|
| **Bedrock KB + OpenSearch Serverless** | RAG with managed vector store |
| **Bedrock Agents + Lambda** | Agent action groups call Lambda functions |
| **Bedrock + Guardrails** | Safe model invocation with content filtering |
| **Textract + Bedrock** | Extract text from documents → summarize/analyze |
| **Textract + Comprehend** | Extract text → entity recognition, sentiment |
| **Step Functions + Lambda** | Orchestrate multi-step GenAI pipelines |
| **API Gateway + Lambda + Bedrock** | Serverless GenAI API endpoint |
| **S3 + Bedrock KB** | S3 as data source for Knowledge Base |
| **CloudWatch + X-Ray** | Monitor metrics + trace latency |
| **CloudTrail + S3** | Audit logging with long-term storage |
| **IAM + VPC Endpoints** | Secure model access (who + where) |
| **KMS + S3** | Encrypted storage for training data / documents |
| **ElastiCache + Bedrock** | Cache responses for cost/latency optimization |
| **CloudFront + S3** | Serve generated content (images, documents) |
| **Route 53 + ALB** | DNS failover for cross-region DR |
| **DynamoDB + Bedrock Agents** | Session/memory storage for agents |
| **SQS + Lambda** | Async GenAI processing queue |
| **EventBridge + Step Functions** | Event-driven pipeline triggers |
| **Comprehend + Guardrails** | Layered content moderation (fast NLP + policy enforcement) |
| **CodePipeline + Q Developer** | CI/CD with AI code review |

---

## 7. "When to Use X" Quick Reference

### Choosing Between Similar Services

| If you need... | Use this | Not this |
|---|---|---|
| RAG out of the box | **Bedrock Knowledge Bases** | Custom LangChain on EC2 |
| Enterprise search with connectors | **Amazon Q Business** | Bedrock KB (S3 only) |
| Managed FM inference | **Bedrock** | SageMaker endpoint |
| Custom model training | **SageMaker** | Bedrock (can't train from scratch) |
| Document OCR / table extraction | **Textract** | Bedrock (it's a text model, not an OCR engine) |
| Named entity recognition | **Comprehend** | Bedrock (overkill for simple NER) |
| Toxicity detection (fast, cheap) | **Comprehend** | Guardrails (heavier, policy-focused) |
| Content policy enforcement | **Guardrails** | Comprehend (no custom policies) |
| PII redaction in prompts | **Guardrails** | Comprehend (separate service, manual integration) |
| Image moderation | **Rekognition** | Guardrails (text only) |
| Code review automation | **Q Developer** | Custom Bedrock prompts (unless you need custom rules) |
| Workflow orchestration | **Step Functions** | Lambda calling Lambda |
| Vector search at scale | **OpenSearch Serverless** | Aurora pgvector (smaller scale) |
| Simple vector store + SQL | **Aurora pgvector** | OpenSearch (overkill for small) |
| Streaming GenAI chat | **API Gateway WebSocket + Bedrock ConverseStream** | REST polling |
| Model comparison / eval | **Bedrock Evaluation** | Custom eval scripts |
| Prompt versioning | **Bedrock Prompt Management** | Git (less integrated) |
| Cost tracking per team | **Custom (API Gateway + DynamoDB)** | AWS Cost Explorer alone (not granular enough) |
| Cross-region failover | **Cross-Region Inference Profile** | Manual multi-region deployment (for simple cases) |
| Data residency compliance | **Single-Region Inference Profile** | Cross-Region Inference (sends to any region) |

### One-Liner Decision Rules

- **"I need to query my company's documents"** → Bedrock Knowledge Base
- **"I need to connect Confluence, SharePoint, Slack"** → Amazon Q Business
- **"I need the AI to call APIs and take actions"** → Bedrock Agents
- **"I need to block harmful content"** → Bedrock Guardrails
- **"I need to extract data from scanned forms"** → Amazon Textract
- **"I need sentiment analysis at scale"** → Amazon Comprehend
- **"I need to keep traffic private"** → VPC Endpoints
- **"I need to audit all AI API calls"** → AWS CloudTrail (data events)
- **"I need consistent response latency"** → Provisioned Throughput
- **"I need to reduce costs on repeated prompts"** → Prompt Caching
- **"I need to compare model quality"** → Bedrock Evaluation Jobs
- **"My RAG results are bad"** → Check: chunking → embeddings → retrieval → reranking → prompt
- **"I need the cheapest model that works"** → Start with Haiku, evaluate, upgrade only if needed
- **"I need multi-step AI workflows"** → Step Functions (not Lambda chains)
- **"I need to fine-tune"** → First ask: is prompt engineering or RAG enough? If not, Bedrock fine-tuning for supported models, SageMaker for everything else
- **"I need this to work in multiple regions"** → Cross-Region Inference Profile for Bedrock + DynamoDB Global Tables for state

---

## Final 5-Minute Flashcard Review

1. **Converse API** = model-agnostic Bedrock API. Use it for everything.
2. **Guardrails** = apply to input AND output. Work with streaming. Can use standalone (`ApplyGuardrail`).
3. **Knowledge Bases** = managed RAG. Data source = S3. Vector store = OpenSearch Serverless (default).
4. **Agents** = orchestrate multi-step tasks. Use action groups (Lambda) for external API calls.
5. **Prompt caching** = cache long system prompts. Use `cachePoint` in system message.
6. **Provisioned Throughput** = reserved capacity. Saves 30-40% for steady workloads.
7. **Cross-Region Inference** = `us.model-name` prefix. Auto-routes across regions.
8. **Fine-tuning** = changes model behavior/style. RAG = adds knowledge. Different problems.
9. **Textract** = OCR/extraction. **Comprehend** = NLP analysis. **Bedrock** = generation.
10. **VPC Endpoints** = private Bedrock access. Required for HIPAA/compliance.
11. **CloudTrail** = audit. **CloudWatch** = metrics/alarms. **X-Ray** = tracing.
12. **Step Functions** = workflow orchestration. `.waitForTaskToken` for human-in-the-loop.
13. **IAM + VPC Endpoint Policies + SCPs + Guardrails** = defense in depth for model access.
14. **Evaluation jobs** = automated quality testing. Run regularly, not just at launch.
15. **Model cascading** = route simple tasks to cheap models, hard tasks to expensive ones.

---

> **You've got this. Trust your preparation, read questions carefully, and eliminate wrong answers first.**
