# Domain 1: Foundation Model Integration, Data Management, and Compliance

## Exam Weight: 31% (Heaviest Domain — Approximately 24-25 Questions)

---

> **Why This Domain Matters:** This is the single largest domain on the AIP-C01 exam. Mastery here is non-negotiable. AWS expects you to demonstrate practical, hands-on knowledge of integrating foundation models into production architectures, managing the data lifecycle that feeds them, and enforcing compliance guardrails. Every question in this domain tests whether you can build *real* GenAI systems on AWS — not just describe them.

---

## Table of Contents

1. [Task 1.1: Analyze Requirements and Design GenAI Solutions](#task-11-analyze-requirements-and-design-genai-solutions)
2. [Task 1.2: Select and Configure Foundation Models](#task-12-select-and-configure-foundation-models)
3. [Task 1.3: Implement Data Validation and Processing Pipelines](#task-13-implement-data-validation-and-processing-pipelines)
4. [Task 1.4: Design and Implement Vector Store Solutions](#task-14-design-and-implement-vector-store-solutions)
5. [Task 1.5: Design Retrieval Mechanisms for FM Augmentation (RAG)](#task-15-design-retrieval-mechanisms-for-fm-augmentation-rag)
6. [Task 1.6: Implement Prompt Engineering Strategies and Governance](#task-16-implement-prompt-engineering-strategies-and-governance)

---

# Task 1.1: Analyze Requirements and Design GenAI Solutions

## 1.1.1 — Creating Comprehensive Architectural Designs

The starting point for any GenAI project on AWS is translating business requirements into a technical architecture. AWS frames this through three lenses:

**Business Requirement Categories for GenAI:**

| Category | Example Requirement | AWS Service Mapping |
|----------|-------------------|---------------------|
| Content Generation | "Generate marketing copy in 5 languages" | Bedrock (Claude/Titan), Translate |
| Knowledge Retrieval | "Answer questions from 10K internal docs" | Bedrock Knowledge Bases, OpenSearch, S3 |
| Code Assistance | "Help developers write unit tests" | Bedrock (Claude), CodeWhisperer |
| Data Analysis | "Summarize quarterly sales trends" | Bedrock, Glue, Athena |
| Conversational AI | "Build a customer-facing chatbot" | Bedrock Agents, Lex, DynamoDB |
| Image/Media Generation | "Create product images from descriptions" | Bedrock (Stability AI, Titan Image) |

**Architectural Decision Framework:**

Before selecting any service, answer these five questions:

1. **Latency tolerance** — Is this real-time (< 2s), near-real-time (< 10s), or batch?
2. **Data sensitivity** — Does the data contain PII, PHI, or classified information?
3. **Scale profile** — Peak concurrent users? Requests per second?
4. **Customization depth** — Out-of-box FM sufficient, or do we need fine-tuning?
5. **Integration surface** — What existing systems must this connect to?

> **EXAM TIP:** When a question describes a business scenario and asks you to "choose the most appropriate architecture," mentally run through these five questions. AWS consistently tests whether you pick the *simplest* solution that meets all stated requirements. Over-engineering is a wrong answer.

## 1.1.2 — Technical Proof-of-Concept with Amazon Bedrock

Amazon Bedrock is the exam's center of gravity. Understand its architecture deeply:

```
┌─────────────────────────────────────────────────────────────┐
│                    Amazon Bedrock Architecture               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────┐    ┌──────────────┐    ┌─────────────────┐   │
│  │ Client   │───>│ API Gateway  │───>│ Bedrock Runtime │   │
│  │ App      │    │ (optional)   │    │ API             │   │
│  └──────────┘    └──────────────┘    └────────┬────────┘   │
│                                               │             │
│                        ┌──────────────────────┼──────┐      │
│                        │                      │      │      │
│                   ┌────▼────┐  ┌─────────┐  ┌▼────┐ │      │
│                   │ Claude  │  │ Titan   │  │Llama│ │      │
│                   │(Anthropic)│ │(Amazon) │  │(Meta)│ │      │
│                   └─────────┘  └─────────┘  └─────┘ │      │
│                        │                             │      │
│                        │    Foundation Models Pool    │      │
│                        └─────────────────────────────┘      │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌────────────────┐    │
│  │ Knowledge    │  │ Guardrails   │  │ Prompt         │    │
│  │ Bases        │  │              │  │ Management     │    │
│  └──────────────┘  └──────────────┘  └────────────────┘    │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌────────────────┐    │
│  │ Agents       │  │ Prompt Flows │  │ Model          │    │
│  │              │  │              │  │ Evaluation     │    │
│  └──────────────┘  └──────────────┘  └────────────────┘    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Core Bedrock API Patterns:**

The two primary invocation APIs you must know:

1. **`InvokeModel`** — Synchronous, single request-response. Used for simple completions.
2. **`InvokeModelWithResponseStream`** — Streaming response. Used for real-time UIs where you want token-by-token output.
3. **`Converse` / `ConverseStream`** — Unified conversation API that works across models with a consistent message format. This is the recommended approach for multi-turn conversations.

```python
# InvokeModel example — Claude on Bedrock
import boto3, json

bedrock = boto3.client('bedrock-runtime', region_name='us-east-1')

response = bedrock.invoke_model(
    modelId='anthropic.claude-3-sonnet-20240229-v1:0',
    contentType='application/json',
    accept='application/json',
    body=json.dumps({
        "anthropic_version": "bedrock-2023-05-31",
        "max_tokens": 1024,
        "messages": [
            {"role": "user", "content": "Explain VPC peering in two sentences."}
        ]
    })
)

result = json.loads(response['body'].read())
print(result['content'][0]['text'])
```

```python
# Converse API — model-agnostic conversation format
response = bedrock.converse(
    modelId='anthropic.claude-3-sonnet-20240229-v1:0',
    messages=[
        {
            "role": "user",
            "content": [{"text": "Explain VPC peering in two sentences."}]
        }
    ],
    inferenceConfig={
        "maxTokens": 1024,
        "temperature": 0.7
    }
)
```

> **EXAM TIP:** The `Converse` API is AWS's preferred abstraction. If a question asks about building a multi-model application or switching between providers, the Converse API is almost always the right answer because it provides a *unified interface* across all Bedrock models. The `InvokeModel` API requires model-specific request/response formats.

## 1.1.3 — AWS Well-Architected Framework and Generative AI Lens

The Well-Architected Framework has six pillars. The Generative AI Lens adds GenAI-specific guidance to each:

| Pillar | GenAI-Specific Considerations |
|--------|------------------------------|
| **Operational Excellence** | Model versioning, prompt version control, A/B testing of models, monitoring token usage and latency, runbooks for model degradation |
| **Security** | Data encryption in transit/at rest for training data, model access controls via IAM, PII detection in prompts/responses, VPC endpoints for Bedrock |
| **Reliability** | Cross-region inference, fallback models, circuit breakers for model failures, retry strategies with exponential backoff |
| **Performance Efficiency** | Right-sizing model selection (don't use Claude Opus when Haiku suffices), provisioned throughput for predictable workloads, caching strategies |
| **Cost Optimization** | Token-based pricing awareness, prompt optimization to reduce token count, caching repeated queries, choosing smaller models where possible |
| **Sustainability** | Selecting appropriately-sized models, batch processing over real-time where possible, efficient prompt design |

**Key Design Patterns for GenAI Solutions:**

1. **Gateway Pattern** — API Gateway fronts all FM calls, enabling rate limiting, auth, and routing.
2. **RAG Pattern** — Augment FM with external knowledge to reduce hallucinations and provide current information.
3. **Agent Pattern** — FM orchestrates tool use (APIs, databases, code execution) to complete complex tasks.
4. **Chain Pattern** — Multiple FM calls in sequence, where output of one becomes input of the next.
5. **Fan-Out/Fan-In** — Parallel FM calls (e.g., summarize 10 documents simultaneously), then aggregate.
6. **Human-in-the-Loop** — FM generates draft, human reviews/edits, feedback improves future outputs.

> **EXAM TIP:** AWS loves testing the Gateway Pattern. If a question mentions "multiple consumers," "rate limiting," "authentication," or "usage tracking" for a GenAI API — the answer involves API Gateway + Lambda + Bedrock.

---

# Task 1.2: Select and Configure Foundation Models

## 1.2.1 — FM Assessment and Selection

This is one of the most heavily tested areas. You must know when to choose which model.

### FM Selection Decision Matrix

```
                        FM SELECTION DECISION MATRIX
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│  START: What is the primary use case?                            │
│    │                                                             │
│    ├── Text Generation / Analysis ──────────────────────────┐    │
│    │    │                                                   │    │
│    │    ├── Complex reasoning needed? ──> Claude 3 Opus     │    │
│    │    ├── Balanced quality + speed? ──> Claude 3 Sonnet   │    │
│    │    ├── High throughput, low cost? ─> Claude 3 Haiku    │    │
│    │    ├── Need AWS-native model?    ─> Amazon Titan Text  │    │
│    │    ├── Open-source required?     ─> Llama 3 (Meta)    │    │
│    │    ├── Code generation focus?    ─> Claude / Mistral   │    │
│    │    └── Multilingual emphasis?    ─> Cohere Command R+  │    │
│    │                                                        │    │
│    ├── Embeddings ──────────────────────────────────────┐   │    │
│    │    │                                               │   │    │
│    │    ├── General purpose? ──> Titan Embeddings V2    │   │    │
│    │    ├── Multilingual?    ──> Cohere Embed           │   │    │
│    │    └── Search-optimized?──> Cohere Embed           │   │    │
│    │                                                    │   │    │
│    ├── Image Generation ────────────────────────────┐   │   │    │
│    │    │                                           │   │   │    │
│    │    ├── Photorealistic? ──> Stability AI SDXL   │   │   │    │
│    │    ├── AWS-native?     ──> Titan Image Gen     │   │   │    │
│    │    └── Image editing?  ──> Titan Image Gen     │   │   │    │
│    │                                                │   │   │    │
│    └── Summarization / RAG ─────────────────────┐   │   │   │    │
│         │                                       │   │   │   │    │
│         ├── Long context (200K)? ─> Claude 3    │   │   │   │    │
│         ├── Cost-sensitive?      ─> Haiku/Titan │   │   │   │    │
│         └── Need citations?      ─> Cohere Cmd  │   │   │   │    │
│                                                 │   │   │   │    │
└─────────────────────────────────────────────────┴───┴───┴───┴────┘
```

### Models Available in Amazon Bedrock — Deep Dive

**Anthropic Claude Family:**

| Model | Context Window | Strengths | Best For |
|-------|---------------|-----------|----------|
| Claude 3 Opus | 200K tokens | Highest reasoning quality, complex analysis | Research, nuanced writing, complex code |
| Claude 3.5 Sonnet | 200K tokens | Best balance of speed and intelligence | Production workloads, coding, analysis |
| Claude 3 Haiku | 200K tokens | Fastest, lowest cost | Classification, simple Q&A, high-volume |

**Amazon Titan Family:**

| Model | Strengths | Best For |
|-------|-----------|----------|
| Titan Text Express | Fast, cost-effective, AWS-native | Summarization, simple generation |
| Titan Text Lite | Ultra-low latency | Real-time applications, chat |
| Titan Embeddings V2 | Configurable dimensions (256/512/1024) | Vector search, semantic similarity |
| Titan Image Generator | Text-to-image, image editing, watermarking | Content creation with built-in safety |
| Titan Multimodal Embeddings | Text + image embeddings | Multimodal search |

**Meta Llama Family:**

| Model | Context | Strengths |
|-------|---------|-----------|
| Llama 3.1 (8B/70B/405B) | 128K tokens | Open-source, strong reasoning, multilingual |
| Llama 3.2 (Vision) | 128K tokens | Multimodal (text + image understanding) |

**Mistral Family:**

| Model | Strengths |
|-------|-----------|
| Mistral 7B | Lightweight, fast inference |
| Mixtral 8x7B | Mixture-of-experts, strong coding |
| Mistral Large | Competitive with larger models, multilingual |

**Cohere:**

| Model | Strengths |
|-------|-----------|
| Command R / R+ | RAG-optimized, built-in citation generation |
| Embed (English/Multilingual) | High-quality embeddings, search-optimized |
| Rerank | Re-ranking search results for relevance |

**AI21 Labs:**

| Model | Strengths |
|-------|-----------|
| Jurassic-2 | Specialized language tasks, multilingual |
| Jamba-Instruct | Long-context, structured output |

**Stability AI:**

| Model | Strengths |
|-------|-----------|
| Stable Diffusion XL | High-quality image generation, fine-grained control |

> **EXAM TIP:** The exam frequently presents scenarios where you must choose between Claude Haiku and Claude Sonnet, or between Titan and a third-party model. The deciding factors are almost always: (1) cost sensitivity, (2) latency requirements, (3) reasoning complexity, and (4) whether AWS-native/data-residency matters. If a question mentions "minimize cost" and the task is simple classification — Haiku or Titan Lite. If it mentions "complex reasoning" — Sonnet or Opus.

## 1.2.2 — Dynamic Model Selection and Provider Switching

Production GenAI systems need the ability to route requests to different models based on runtime conditions.

**Architecture: Dynamic Model Router**

```
┌──────────┐     ┌─────────────┐     ┌──────────────┐
│  Client   │────>│ API Gateway │────>│ Router       │
│  Request  │     │             │     │ Lambda       │
└──────────┘     └─────────────┘     └──────┬───────┘
                                            │
                          ┌─────────────────┼─────────────────┐
                          │                 │                 │
                    ┌─────▼─────┐    ┌──────▼──────┐   ┌─────▼─────┐
                    │ AppConfig │    │ DynamoDB    │   │ Feature   │
                    │ (routing  │    │ (routing    │   │ Flags     │
                    │  rules)   │    │  history)   │   │           │
                    └─────┬─────┘    └─────────────┘   └───────────┘
                          │
              ┌───────────┼───────────┐
              │           │           │
        ┌─────▼───┐ ┌────▼────┐ ┌────▼────┐
        │ Claude  │ │ Titan   │ │ Llama   │
        │ Sonnet  │ │ Express │ │ 3.1     │
        └─────────┘ └─────────┘ └─────────┘
```

**Implementation with AWS AppConfig:**

AppConfig enables feature-flag-style model routing without redeployment:

```python
import boto3, json

appconfig = boto3.client('appconfig')
bedrock = boto3.client('bedrock-runtime')

def get_model_config():
    response = appconfig.get_configuration(
        Application='genai-app',
        Environment='production',
        Configuration='model-routing',
        ClientId='router-lambda'
    )
    return json.loads(response['Content'].read())

def route_request(request_type, complexity_score):
    config = get_model_config()
    rules = config['routing_rules']

    if complexity_score > 0.8:
        return rules.get('complex', 'anthropic.claude-3-sonnet-20240229-v1:0')
    elif request_type == 'classification':
        return rules.get('simple', 'anthropic.claude-3-haiku-20240307-v1:0')
    else:
        return rules.get('default', 'anthropic.claude-3-sonnet-20240229-v1:0')
```

**Why this matters:** AppConfig lets you shift traffic between models (e.g., 80% Claude, 20% Llama) for A/B testing, or instantly switch all traffic away from a degraded model — all without deploying new code.

> **EXAM TIP:** If a question mentions "switch models without redeployment," "gradual rollout of a new model," or "feature flags for model selection" — the answer is **AWS AppConfig** or **Lambda environment variables** (for simpler cases). AppConfig is preferred for complex routing rules.

## 1.2.3 — Resilient AI Systems

### Step Functions Circuit Breaker Pattern

When an FM provider experiences degradation, you need automated failover:

```
┌─────────────────────────────────────────────────────────────────┐
│                Step Functions Circuit Breaker                    │
│                                                                 │
│  ┌──────────┐    ┌──────────────┐     ┌──────────────────┐     │
│  │ Invoke   │───>│ Check Error  │────>│ Circuit CLOSED   │     │
│  │ Primary  │    │ Rate         │     │ (normal flow)    │     │
│  │ Model    │    └──────┬───────┘     └──────────────────┘     │
│  └──────────┘           │                                       │
│                    Error rate                                    │
│                    > threshold                                   │
│                         │                                       │
│                   ┌─────▼──────┐      ┌──────────────────┐     │
│                   │ Circuit    │─────>│ Invoke Fallback  │     │
│                   │ OPEN       │      │ Model            │     │
│                   └─────┬──────┘      └──────────────────┘     │
│                         │                                       │
│                    Timer expires                                 │
│                         │                                       │
│                   ┌─────▼──────┐                                │
│                   │ Circuit    │── Test request ──> Primary     │
│                   │ HALF-OPEN  │                                │
│                   └────────────┘                                │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**DynamoDB tracks circuit state:**

```python
circuit_state = {
    'model_id': 'anthropic.claude-3-sonnet-20240229-v1:0',
    'state': 'CLOSED',          # CLOSED | OPEN | HALF_OPEN
    'failure_count': 0,
    'failure_threshold': 5,
    'last_failure_time': 0,
    'cooldown_seconds': 60,
    'fallback_model': 'amazon.titan-text-express-v1'
}
```

### Bedrock Cross-Region Inference

Cross-Region Inference automatically routes requests to other AWS regions when the primary region is at capacity or experiencing issues. You enable it by using an **inference profile** instead of a direct model ID:

```python
response = bedrock.invoke_model(
    modelId='us.anthropic.claude-3-sonnet-20240229-v1:0',
    # The "us." prefix indicates a cross-region inference profile
    # Bedrock automatically routes to available US regions
    body=json.dumps({...})
)
```

Key facts about Cross-Region Inference:
- Data does **not** leave the geographic boundary (e.g., `us.` stays in US regions)
- Pricing is the same as on-demand in the primary region
- No code changes beyond using the inference profile ID
- Available prefixes: `us.`, `eu.`, `ap.`

> **EXAM TIP:** Cross-Region Inference is the *easiest* resilience mechanism. If a question asks about handling throttling or regional outages with minimal effort, this is the answer. If the question specifies data must stay in a specific *single* region for compliance, then Cross-Region Inference is NOT appropriate — use Provisioned Throughput instead.

### Graceful Degradation Strategies

| Strategy | Implementation | When to Use |
|----------|---------------|-------------|
| Model fallback | Primary → Secondary model (Sonnet → Haiku) | Primary model unavailable |
| Response caching | ElastiCache / DynamoDB for repeated queries | High-volume, repeated queries |
| Quality reduction | Switch from streaming to batch | Under extreme load |
| Feature flagging | Disable non-essential AI features | Partial outage |
| Queue-based smoothing | SQS to buffer requests | Burst traffic |

## 1.2.4 — FM Customization

### Fine-Tuning vs. Continued Pre-Training vs. RAG

```
┌────────────────────────────────────────────────────────────────┐
│              CUSTOMIZATION DECISION TREE                        │
│                                                                │
│  Need domain-specific knowledge?                               │
│    │                                                           │
│    ├── YES ─── Is the knowledge in documents you can index?    │
│    │    │                                                      │
│    │    ├── YES ──> RAG (cheapest, fastest to implement)       │
│    │    │                                                      │
│    │    └── NO ──── Need the model to "understand" the domain? │
│    │         │                                                 │
│    │         ├── YES, deeply ──> Continued Pre-Training        │
│    │         │   (teach new concepts, terminology, patterns)   │
│    │         │                                                 │
│    │         └── YES, for specific tasks ──> Fine-Tuning       │
│    │             (teach specific input→output mappings)        │
│    │                                                           │
│    └── NO ──── Need different style/format/behavior?           │
│         │                                                      │
│         ├── YES ──> Fine-Tuning                                │
│         │   (teach tone, format, classification labels)        │
│         │                                                      │
│         └── NO ──> Prompt Engineering (no customization)       │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

**Continued Pre-Training:**
- Feeds unlabeled domain text to the model
- Model learns domain vocabulary, concepts, and relationships
- Requires large datasets (GBs of domain text)
- Available in Bedrock for Titan and select models
- Use case: Teaching a model about proprietary medical terminology

**Fine-Tuning:**
- Uses labeled examples (input-output pairs)
- Model learns to map specific inputs to desired outputs
- Requires smaller but curated datasets (hundreds to thousands of examples)
- Available in Bedrock for Titan, Llama, Cohere, and others
- Use case: Training a model to classify support tickets into categories

**LoRA (Low-Rank Adaptation):**
- A parameter-efficient fine-tuning technique
- Instead of updating all model weights, trains small adapter matrices
- Dramatically reduces compute and storage costs
- Adapters can be swapped at inference time
- SageMaker supports LoRA for custom model deployments

**Bedrock Fine-Tuning Process:**

1. Prepare training data in JSONL format (stored in S3)
2. Create a fine-tuning job via Bedrock console or API
3. Specify hyperparameters (epochs, batch size, learning rate)
4. Bedrock provisions compute, trains, and stores the custom model
5. Deploy via Provisioned Throughput (custom models require it)

```json
// Fine-tuning training data format (JSONL)
{"prompt": "Classify this ticket: My laptop won't turn on", "completion": "Hardware"}
{"prompt": "Classify this ticket: Can't access email", "completion": "Software"}
{"prompt": "Classify this ticket: Need new monitor", "completion": "Equipment Request"}
```

> **EXAM TIP:** The exam tests whether you know the *data format* for fine-tuning. Bedrock expects JSONL with `prompt` and `completion` fields for text models. For the Converse API style models, the format uses `system`, `messages` structure. Always store training data in S3 with proper IAM permissions for the Bedrock service role.

## 1.2.5 — SageMaker AI for Custom Model Deployment

When Bedrock's built-in models aren't sufficient, SageMaker provides full control:

**SageMaker Model Registry:**
- Central catalog for all model versions
- Tracks model lineage (which data, which hyperparameters)
- Approval workflows (Pending → Approved → Rejected)
- Integration with CI/CD pipelines for automated deployment
- Model cards for documentation and governance

**SageMaker Endpoints vs. Bedrock:**

| Aspect | Amazon Bedrock | SageMaker Endpoints |
|--------|---------------|-------------------|
| Model selection | Pre-built FMs from providers | Any model (custom, HuggingFace, etc.) |
| Infrastructure | Fully managed, serverless | You manage instance types |
| Customization | Fine-tuning, continued pre-training | Full control over training |
| Scaling | Automatic (on-demand) or Provisioned | Auto-scaling policies you configure |
| Cost model | Per-token pricing | Per-instance-hour pricing |
| Use when | Using supported FMs with standard needs | Custom models, full control needed |

## 1.2.6 — Throughput Models

**On-Demand Throughput:**
- Pay per token (input and output priced separately)
- No commitment, no provisioning
- Subject to account-level throttling
- Best for: Variable workloads, development, low-volume production

**Provisioned Throughput:**
- Reserve dedicated capacity (measured in Model Units)
- Guaranteed throughput with no throttling
- Requires 1-month or 6-month commitment (or no commitment at higher price)
- Required for custom/fine-tuned models on Bedrock
- Best for: Predictable high-volume production workloads

**Batch Inference:**
- Submit a batch of prompts as a single job
- Up to 50% cost savings vs. on-demand
- Results stored in S3
- No real-time latency requirement
- Best for: Large-scale processing, document summarization, data enrichment

**SageMaker Endpoints:**
- Real-time endpoints (persistent instances)
- Serverless endpoints (scale to zero, cold start latency)
- Asynchronous endpoints (for long-running inference > 60s)
- Best for: Custom models, models not available in Bedrock

> **EXAM TIP:** "Which throughput model?" questions are common. If the scenario mentions "predictable traffic" + "consistent latency" = Provisioned Throughput. If it mentions "variable traffic" + "cost optimization" = On-Demand. If it mentions "processing 100,000 documents overnight" = Batch Inference. If it mentions a "fine-tuned model on Bedrock" = Provisioned Throughput is *required*.

---

# Task 1.3: Implement Data Validation and Processing Pipelines

## 1.3.1 — Data Pipeline Architecture

```
┌────────────────────────────────────────────────────────────────────────┐
│                    GenAI Data Processing Pipeline                       │
│                                                                        │
│  ┌──────────┐   ┌───────────┐   ┌──────────┐   ┌──────────────────┐  │
│  │ Raw Data │──>│ Ingestion │──>│ Validate │──>│ Transform        │  │
│  │ Sources  │   │ Layer     │   │ & Clean  │   │ & Enrich         │  │
│  └──────────┘   └───────────┘   └──────────┘   └────────┬─────────┘  │
│       │              │               │                   │            │
│  ┌────┴────┐   ┌─────┴─────┐  ┌─────┴─────┐   ┌────────▼─────────┐  │
│  │ S3      │   │ Kinesis   │  │ Glue Data │   │ Lambda /         │  │
│  │ Uploads │   │ Data      │  │ Quality   │   │ SageMaker        │  │
│  │ API     │   │ Streams   │  │ Rules     │   │ Processing       │  │
│  │ Feeds   │   │ EventBdg  │  │           │   │                  │  │
│  └─────────┘   └───────────┘  └───────────┘   └────────┬─────────┘  │
│                                                         │            │
│                                                ┌────────▼─────────┐  │
│                                                │ Processed Data   │  │
│                                                │ (S3 Data Lake)   │  │
│                                                └────────┬─────────┘  │
│                                                         │            │
│                           ┌─────────────────────────────┼──────┐     │
│                           │                             │      │     │
│                    ┌──────▼──────┐  ┌──────────────┐  ┌▼────┐ │     │
│                    │ Embedding   │  │ Fine-Tuning  │  │RAG  │ │     │
│                    │ Generation  │  │ Dataset      │  │Index│ │     │
│                    └─────────────┘  └──────────────┘  └─────┘ │     │
│                           │                                    │     │
│                           │   Downstream Consumers             │     │
│                           └────────────────────────────────────┘     │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

## 1.3.2 — AWS Glue Data Quality

AWS Glue Data Quality enables you to define and enforce data quality rules on datasets processed through Glue ETL jobs:

**Key Capabilities:**
- Define rules using DQDL (Data Quality Definition Language)
- Automatic rule recommendation from data profiling
- Integration with Glue ETL jobs and Glue Data Catalog
- Publish metrics to CloudWatch
- Stop pipelines on quality failures

```python
# Glue Data Quality rule examples (DQDL)
rules = """
Rules = [
    ColumnExists "customer_id",
    IsComplete "customer_id",
    IsUnique "customer_id",
    ColumnLength "customer_id" between 8 and 12,
    ColumnValues "sentiment_score" between -1.0 and 1.0,
    RowCount > 1000,
    Completeness "email" > 0.95,
    CustomSql "SELECT COUNT(*) FROM primary WHERE LENGTH(text_content) > 0" > 0
]
"""
```

**When to use Glue Data Quality vs. other options:**
- **Glue Data Quality**: Batch data validation in ETL pipelines, data catalog-level rules
- **Lambda validation**: Real-time, event-driven validation on individual records
- **SageMaker Data Wrangler**: Interactive data exploration, visualization, and transformation

## 1.3.3 — SageMaker Data Wrangler

Data Wrangler provides a visual interface for data preparation:

- **Import**: Connect to S3, Athena, Redshift, Snowflake, and more
- **Explore**: Statistical analysis, data quality reports, visualization
- **Transform**: 300+ built-in transformations (no code needed)
- **Export**: Generate processing jobs, pipelines, or feature store ingestion

**GenAI-specific use cases for Data Wrangler:**
- Analyzing training dataset distribution before fine-tuning
- Identifying class imbalances in classification training data
- Detecting anomalies and outliers in training samples
- Generating data quality reports for governance

## 1.3.4 — Custom Lambda Validation Functions

For real-time, event-driven validation:

```python
import json
import boto3

comprehend = boto3.client('comprehend')
s3 = boto3.client('s3')

def validate_training_data(event, context):
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']

    obj = s3.get_object(Bucket=bucket, Key=key)
    content = obj['Body'].read().decode('utf-8')

    validation_results = {
        'file': key,
        'checks': []
    }

    for i, line in enumerate(content.strip().split('\n')):
        record = json.loads(line)

        # Check required fields
        if 'prompt' not in record or 'completion' not in record:
            validation_results['checks'].append({
                'line': i, 'error': 'Missing required fields'
            })
            continue

        # Check minimum length
        if len(record['prompt']) < 10:
            validation_results['checks'].append({
                'line': i, 'error': 'Prompt too short'
            })

        # PII detection via Comprehend
        pii_response = comprehend.detect_pii_entities(
            Text=record['prompt'][:5000],
            LanguageCode='en'
        )
        if pii_response['Entities']:
            validation_results['checks'].append({
                'line': i,
                'warning': f"PII detected: {[e['Type'] for e in pii_response['Entities']]}"
            })

    return validation_results
```

> **EXAM TIP:** Questions about data validation often test whether you know the right service. Real-time single-record validation = Lambda. Batch dataset validation = Glue Data Quality. Interactive exploration = SageMaker Data Wrangler. PII detection = Amazon Comprehend. The exam rewards knowing which tool fits which scenario.

## 1.3.5 — Multimodal Data Processing

**Text Processing Pipeline:**
1. Extract text from documents (Amazon Textract for PDFs/images, S3 for plain text)
2. Detect language (Amazon Comprehend)
3. Clean and normalize (Lambda — remove HTML, fix encoding, standardize formats)
4. Detect and handle PII (Amazon Comprehend → mask/redact)
5. Chunk for embedding or fine-tuning

**Image Processing Pipeline:**
1. Ingest images to S3
2. Extract metadata (Amazon Rekognition — labels, text, moderation)
3. Generate descriptions (Bedrock multimodal models — Claude 3 with vision)
4. Create embeddings (Titan Multimodal Embeddings)
5. Store in vector database with metadata

**Audio Processing Pipeline:**
1. Ingest audio files to S3
2. Transcribe (Amazon Transcribe)
3. Detect language and entities (Amazon Comprehend)
4. Summarize or analyze (Amazon Bedrock)
5. Index transcripts for search

**Tabular Data Processing:**
1. Ingest CSV/Parquet to S3
2. Profile data (Glue Data Quality, Data Wrangler)
3. Transform (Glue ETL — normalize, encode categorical, handle missing values)
4. Convert to natural language descriptions for FM consumption (Lambda)
5. Or structure for SageMaker endpoint inference

## 1.3.6 — JSON Formatting for Bedrock API Requests

Each model family has a specific request format. The Converse API abstracts this, but you need to know the native formats:

**Claude (Anthropic) Native Format:**
```json
{
    "anthropic_version": "bedrock-2023-05-31",
    "max_tokens": 1024,
    "temperature": 0.7,
    "top_p": 0.9,
    "system": "You are a helpful assistant.",
    "messages": [
        {
            "role": "user",
            "content": [
                {"type": "text", "text": "Analyze this data..."},
                {
                    "type": "image",
                    "source": {
                        "type": "base64",
                        "media_type": "image/png",
                        "data": "<base64-encoded-image>"
                    }
                }
            ]
        }
    ]
}
```

**Amazon Titan Text Native Format:**
```json
{
    "inputText": "Summarize the following document: ...",
    "textGenerationConfig": {
        "maxTokenCount": 512,
        "temperature": 0.7,
        "topP": 0.9,
        "stopSequences": []
    }
}
```

**Converse API (Unified Format — Works Across All Models):**
```json
{
    "modelId": "anthropic.claude-3-sonnet-20240229-v1:0",
    "messages": [
        {
            "role": "user",
            "content": [
                {"text": "Analyze this data..."}
            ]
        }
    ],
    "system": [{"text": "You are a helpful assistant."}],
    "inferenceConfig": {
        "maxTokens": 1024,
        "temperature": 0.7,
        "topP": 0.9
    }
}
```

> **EXAM TIP:** The `Converse` API is the answer whenever a question involves "model-agnostic," "switching providers," or "unified interface." But you still need to know native formats for questions about specific model features (like Claude's `system` field or Titan's `textGenerationConfig`).

## 1.3.7 — Conversation Formatting for Dialog Applications

Multi-turn conversations require careful message history management:

```python
def format_conversation_for_bedrock(conversation_history, new_message):
    messages = []

    for turn in conversation_history:
        messages.append({
            "role": turn['role'],
            "content": [{"text": turn['content']}]
        })

    messages.append({
        "role": "user",
        "content": [{"text": new_message}]
    })

    return messages

# DynamoDB conversation storage schema
conversation_item = {
    'conversation_id': 'conv-12345',
    'user_id': 'user-789',
    'turn_number': 3,
    'role': 'assistant',
    'content': 'Based on your previous question about...',
    'model_id': 'anthropic.claude-3-sonnet-20240229-v1:0',
    'timestamp': '2024-12-01T10:30:00Z',
    'token_count': 156,
    'ttl': 1704067200  # auto-expire after 30 days
}
```

## 1.3.8 — Amazon Comprehend for Entity Extraction

Comprehend provides NLP capabilities that complement GenAI pipelines:

- **Entity Recognition**: Detect people, places, organizations, dates, quantities
- **Sentiment Analysis**: Positive, negative, neutral, mixed
- **PII Detection**: SSN, credit card numbers, email addresses, phone numbers
- **Language Detection**: Identify language of input text
- **Custom Classification**: Train custom models for domain-specific classification
- **Key Phrase Extraction**: Pull key phrases from text

```python
comprehend = boto3.client('comprehend')

# Entity extraction for metadata enrichment
response = comprehend.detect_entities(
    Text="Amazon announced a new AI service in Seattle on December 1st.",
    LanguageCode='en'
)
# Returns: ORGANIZATION(Amazon), OTHER(AI), LOCATION(Seattle), DATE(December 1st)

# PII detection for compliance
pii_response = comprehend.detect_pii_entities(
    Text="Call me at 555-123-4567 or email john@example.com",
    LanguageCode='en'
)
# Returns: PHONE(555-123-4567), EMAIL(john@example.com)
```

**Integration pattern**: Use Comprehend to extract entities from documents → store as metadata in vector database → enable filtered vector search (e.g., "find documents mentioning Seattle from 2024").

## 1.3.9 — Data Normalization with Lambda

```python
import re
import unicodedata

def normalize_text(text):
    text = unicodedata.normalize('NFKD', text)
    text = re.sub(r'\s+', ' ', text).strip()
    text = re.sub(r'[^\x00-\x7F]+', '', text)  # Remove non-ASCII if needed
    text = text.lower()
    return text

def normalize_for_embedding(text, max_tokens=8000):
    text = normalize_text(text)

    # Rough token estimation (4 chars ≈ 1 token)
    if len(text) > max_tokens * 4:
        text = text[:max_tokens * 4]

    return text
```

---

# Task 1.4: Design and Implement Vector Store Solutions

## 1.4.1 — Vector Store Selection Decision Tree

```
┌────────────────────────────────────────────────────────────────────────┐
│                  VECTOR STORE SELECTION DECISION TREE                   │
│                                                                        │
│  What is your primary requirement?                                     │
│    │                                                                   │
│    ├── MANAGED RAG (minimal ops) ─────────────────────────────────┐    │
│    │   └──> Amazon Bedrock Knowledge Bases                        │    │
│    │        (auto-chunking, auto-embedding, auto-sync)            │    │
│    │        Backed by: OpenSearch Serverless (default)             │    │
│    │                    or Aurora pgvector, Pinecone, Redis, etc.  │    │
│    │                                                              │    │
│    ├── FULL-TEXT + VECTOR SEARCH (hybrid) ────────────────────┐   │    │
│    │   └──> Amazon OpenSearch Service                         │   │    │
│    │        (k-NN plugin, BM25, neural search, dashboards)    │   │    │
│    │                                                          │   │    │
│    ├── RELATIONAL + VECTOR (existing PostgreSQL) ─────────┐   │   │    │
│    │   └──> Amazon Aurora PostgreSQL with pgvector         │   │   │    │
│    │        (SQL queries + vector similarity in one DB)    │   │   │    │
│    │                                                      │   │   │    │
│    ├── GRAPH + VECTOR (relationship-heavy data) ──────┐   │   │   │    │
│    │   └──> Amazon Neptune                            │   │   │   │    │
│    │        (knowledge graphs + vector similarity)    │   │   │   │    │
│    │                                                  │   │   │   │    │
│    ├── SERVERLESS + AUTO-SCALING ─────────────────┐   │   │   │   │    │
│    │   └──> OpenSearch Serverless                 │   │   │   │   │    │
│    │        (vector search collection type)       │   │   │   │   │    │
│    │                                              │   │   │   │   │    │
│    └── METADATA-HEAVY + LOW LATENCY ─────────┐   │   │   │   │   │    │
│        └──> DynamoDB + Vector DB sidecar      │   │   │   │   │   │    │
│             (DynamoDB for metadata,           │   │   │   │   │   │    │
│              vector DB for similarity search) │   │   │   │   │   │    │
│                                              │   │   │   │   │   │    │
└──────────────────────────────────────────────┴───┴───┴───┴───┴───┴────┘
```

## 1.4.2 — Amazon Bedrock Knowledge Bases

Bedrock Knowledge Bases is the fully managed RAG solution. Understand its architecture:

**Components:**
1. **Data Source**: S3 bucket containing documents (PDF, TXT, HTML, MD, CSV, DOCX, XLS)
2. **Chunking Strategy**: How documents are split (fixed-size, default, hierarchical, semantic, or none)
3. **Embedding Model**: Converts chunks to vectors (Titan Embeddings V2 or Cohere Embed)
4. **Vector Store**: Where vectors are stored and searched
5. **Retrieval Configuration**: How many results to return, search type, filters

**Supported Vector Stores for Knowledge Bases:**
- Amazon OpenSearch Serverless (default, zero-config)
- Amazon Aurora PostgreSQL (pgvector)
- Amazon Neptune Analytics
- Pinecone
- Redis Enterprise Cloud
- MongoDB Atlas

**Hierarchical Organization:**
- Multiple Knowledge Bases per account
- Each Knowledge Base can have multiple Data Sources
- Data Sources can be different S3 buckets/prefixes
- Metadata filters enable scoped retrieval

```python
bedrock_agent = boto3.client('bedrock-agent-runtime')

response = bedrock_agent.retrieve_and_generate(
    input={'text': 'What is our return policy for electronics?'},
    retrieveAndGenerateConfiguration={
        'type': 'KNOWLEDGE_BASE',
        'knowledgeBaseConfiguration': {
            'knowledgeBaseId': 'KB12345',
            'modelArn': 'arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-3-sonnet-20240229-v1:0',
            'retrievalConfiguration': {
                'vectorSearchConfiguration': {
                    'numberOfResults': 5,
                    'overrideSearchType': 'HYBRID',  # SEMANTIC or HYBRID
                    'filter': {
                        'equals': {
                            'key': 'department',
                            'value': 'electronics'
                        }
                    }
                }
            }
        }
    }
)
```

> **EXAM TIP:** When a question says "fully managed," "minimal operational overhead," or "quickly set up RAG" — the answer is Bedrock Knowledge Bases. When it says "custom search logic," "hybrid BM25 + vector," or "existing OpenSearch cluster" — the answer is OpenSearch Service directly. Know the difference between *managed RAG* (Knowledge Bases) and *build-your-own RAG* (direct OpenSearch/Aurora integration).

## 1.4.3 — Amazon OpenSearch Service with Neural Plugin

OpenSearch is the most flexible vector store option on AWS:

**Key Capabilities:**
- **k-NN Plugin**: Native vector similarity search (HNSW, IVF, Faiss, NMSLIB engines)
- **Neural Search Plugin**: Integrates embedding model inference directly into the search pipeline
- **Hybrid Search**: Combine BM25 lexical search with k-NN vector search
- **Score Normalization**: Normalize and combine scores from different search methods
- **Index Management**: Sharding, replicas, lifecycle policies

**Index Configuration for Vectors:**

```json
{
    "settings": {
        "index": {
            "knn": true,
            "knn.algo_param.ef_search": 256,
            "number_of_shards": 3,
            "number_of_replicas": 1
        }
    },
    "mappings": {
        "properties": {
            "content_vector": {
                "type": "knn_vector",
                "dimension": 1024,
                "method": {
                    "name": "hnsw",
                    "space_type": "cosinesimil",
                    "engine": "nmslib",
                    "parameters": {
                        "ef_construction": 512,
                        "m": 16
                    }
                }
            },
            "content_text": {"type": "text"},
            "metadata": {
                "properties": {
                    "source": {"type": "keyword"},
                    "date": {"type": "date"},
                    "department": {"type": "keyword"}
                }
            }
        }
    }
}
```

**Sharding Strategies for Vector Databases:**

| Strategy | Description | Best For |
|----------|------------|----------|
| Single shard | All vectors in one shard | < 1M vectors |
| Index-per-tenant | Separate index per customer | Multi-tenant SaaS |
| Time-based sharding | New index per time period | Time-series knowledge |
| Size-based sharding | New shard when size threshold hit | Growing document corpus |
| Multi-index routing | Route queries to relevant indices | Domain-separated knowledge |

## 1.4.4 — Amazon Aurora PostgreSQL with pgvector

Aurora with pgvector is ideal when you already have relational data:

```sql
-- Enable pgvector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Create table with vector column
CREATE TABLE document_embeddings (
    id SERIAL PRIMARY KEY,
    content TEXT NOT NULL,
    embedding vector(1024),     -- 1024 dimensions for Titan Embeddings V2
    metadata JSONB,
    source_url TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Create HNSW index for fast similarity search
CREATE INDEX ON document_embeddings
USING hnsw (embedding vector_cosine_ops)
WITH (m = 16, ef_construction = 200);

-- Similarity search query
SELECT id, content, metadata,
       1 - (embedding <=> $1::vector) AS similarity
FROM document_embeddings
WHERE metadata->>'department' = 'engineering'
ORDER BY embedding <=> $1::vector
LIMIT 10;
```

**Advantages of Aurora pgvector:**
- Combine vector search with SQL joins (join documents with user tables, permission tables)
- ACID transactions for data consistency
- Familiar PostgreSQL tooling
- Aurora Serverless v2 for auto-scaling
- Read replicas for read-heavy workloads

## 1.4.5 — Amazon Neptune for Graph-Based Knowledge

Neptune stores knowledge as graphs (nodes and edges), enabling relationship-based retrieval:

**Use Cases:**
- Organizational knowledge graphs (who reports to whom, which team owns which service)
- Product knowledge graphs (product → category → attributes → related products)
- Compliance graphs (regulation → requirement → control → evidence)

```sparql
# SPARQL query example — find related concepts
SELECT ?concept ?relation ?related_concept
WHERE {
    ?concept :name "Machine Learning" .
    ?concept ?relation ?related_concept .
    ?related_concept :type "Concept" .
}
LIMIT 20
```

**Graph + Vector Integration Pattern:**
1. Store entities and relationships in Neptune
2. Store entity descriptions as vectors in OpenSearch
3. Query: First find semantically similar entities via vector search
4. Then traverse graph relationships from those entities in Neptune
5. Combine results for context-rich retrieval

## 1.4.6 — Amazon DynamoDB with Vector Databases

DynamoDB excels as a metadata store alongside a dedicated vector database:

**Pattern: DynamoDB for metadata + OpenSearch for vectors**

```python
# Store document metadata in DynamoDB
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('document_metadata')

table.put_item(Item={
    'document_id': 'doc-001',
    'title': 'Q4 Sales Report',
    'source': 's3://docs-bucket/reports/q4-2024.pdf',
    'department': 'sales',
    'classification': 'internal',
    'chunk_count': 15,
    'last_updated': '2024-12-01',
    'access_groups': ['sales-team', 'executives'],
    'vector_index': 'reports-index'  # Reference to OpenSearch index
})

# After vector search returns document_ids, enrich with DynamoDB metadata
def enrich_search_results(vector_results):
    enriched = []
    for result in vector_results:
        metadata = table.get_item(Key={'document_id': result['document_id']})['Item']
        enriched.append({**result, **metadata})
    return enriched
```

> **EXAM TIP:** DynamoDB is NOT a vector database by itself. It does not natively support vector similarity search. If a question asks about storing vectors for similarity search, DynamoDB alone is wrong. The correct pattern is DynamoDB for *metadata* paired with a *real* vector database (OpenSearch, Aurora pgvector, etc.) for similarity search.

## 1.4.7 — Metadata Frameworks

**S3 Object Metadata:**
- System metadata (Content-Type, Content-Length, Last-Modified)
- User-defined metadata (x-amz-meta-* headers, up to 2KB)
- S3 Object Tags (up to 10 key-value pairs per object)
- S3 Inventory for bulk metadata reporting

**Custom Metadata Schema for GenAI Documents:**

```json
{
    "document_id": "doc-001",
    "source_metadata": {
        "origin": "confluence",
        "url": "https://wiki.internal/page/12345",
        "author": "Jane Smith",
        "created_date": "2024-10-15",
        "last_modified": "2024-12-01"
    },
    "content_metadata": {
        "type": "technical_document",
        "department": "engineering",
        "topics": ["kubernetes", "deployment", "scaling"],
        "language": "en",
        "word_count": 2500
    },
    "processing_metadata": {
        "chunking_strategy": "semantic",
        "chunk_count": 12,
        "embedding_model": "amazon.titan-embed-text-v2:0",
        "embedding_dimensions": 1024,
        "processed_date": "2024-12-02"
    },
    "access_metadata": {
        "classification": "internal",
        "access_groups": ["engineering", "platform-team"],
        "retention_policy": "2-years"
    }
}
```

## 1.4.8 — Data Maintenance and Synchronization

**Incremental Updates:**

```
┌──────────────┐    ┌──────────────┐    ┌────────────────┐
│ S3 Event     │───>│ Lambda       │───>│ Bedrock KB     │
│ Notification │    │ Trigger      │    │ StartIngestion │
│ (PUT/DELETE) │    │              │    │ Job            │
└──────────────┘    └──────────────┘    └────────────────┘
```

**Bedrock Knowledge Bases Sync Strategies:**
- **Manual sync**: Trigger via API when you know data has changed
- **Scheduled sync**: EventBridge rule triggers sync on a cron schedule
- **Event-driven sync**: S3 events → Lambda → start ingestion job

**Change Detection for Non-S3 Sources:**

```python
# EventBridge scheduled rule triggers this Lambda
def sync_confluence_to_s3(event, context):
    confluence_client = create_confluence_client()
    s3 = boto3.client('s3')

    last_sync = get_last_sync_timestamp()  # From DynamoDB

    # Fetch pages modified since last sync
    updated_pages = confluence_client.get_pages(
        modified_after=last_sync
    )

    for page in updated_pages:
        s3.put_object(
            Bucket='knowledge-base-docs',
            Key=f'confluence/{page["id"]}.html',
            Body=page['content'],
            Metadata={
                'source': 'confluence',
                'page-id': page['id'],
                'last-modified': page['modified_date']
            }
        )

    # Trigger Knowledge Base sync
    bedrock_agent = boto3.client('bedrock-agent')
    bedrock_agent.start_ingestion_job(
        knowledgeBaseId='KB12345',
        dataSourceId='DS67890'
    )

    update_last_sync_timestamp()
```

> **EXAM TIP:** The exam tests whether you understand *when* to re-sync a knowledge base. If documents change frequently, event-driven sync (S3 events → Lambda → KB sync) is correct. If documents change on a known schedule (e.g., weekly reports), scheduled sync (EventBridge cron) is correct. Manual sync is only appropriate for development or one-time loads.

---

# Task 1.5: Design Retrieval Mechanisms for FM Augmentation (RAG)

## 1.5.1 — RAG Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        RAG ARCHITECTURE                                 │
│                                                                         │
│  ┌──────────────────────────────────────────────────────────────────┐   │
│  │                     INDEXING PIPELINE (Offline)                   │   │
│  │                                                                  │   │
│  │  ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌─────────────┐  │   │
│  │  │Documents │──>│ Chunking │──>│Embedding │──>│ Vector      │  │   │
│  │  │(S3)      │   │Strategy  │   │Model     │   │ Store       │  │   │
│  │  │          │   │          │   │(Titan)   │   │(OpenSearch) │  │   │
│  │  └──────────┘   └──────────┘   └──────────┘   └─────────────┘  │   │
│  │                                                                  │   │
│  └──────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  ┌──────────────────────────────────────────────────────────────────┐   │
│  │                     RETRIEVAL PIPELINE (Online)                   │   │
│  │                                                                  │   │
│  │  ┌──────┐  ┌──────────┐  ┌──────────┐  ┌────────┐  ┌────────┐  │   │
│  │  │User  │─>│Query     │─>│Embedding │─>│Vector  │─>│Re-rank │  │   │
│  │  │Query │  │Transform │  │Model     │  │Search  │  │Results │  │   │
│  │  └──────┘  └──────────┘  └──────────┘  └────────┘  └───┬────┘  │   │
│  │                                                         │       │   │
│  │                                                    ┌────▼────┐  │   │
│  │                                                    │ Top-K   │  │   │
│  │                                                    │ Chunks  │  │   │
│  │                                                    └────┬────┘  │   │
│  └─────────────────────────────────────────────────────────┼───────┘   │
│                                                             │           │
│  ┌──────────────────────────────────────────────────────────┼──────┐   │
│  │                     GENERATION PIPELINE                   │      │   │
│  │                                                          │      │   │
│  │  ┌───────────────┐   ┌──────────────┐   ┌───────────┐  │      │   │
│  │  │ System Prompt  │   │              │   │           │  │      │   │
│  │  │ + Retrieved   ◄───┤  Foundation  │──>│ Response  │  │      │   │
│  │  │   Context     │   │  Model       │   │ to User   │  │      │   │
│  │  │ + User Query  │   │  (Claude)    │   │           │  │      │   │
│  │  └───────────────┘   └──────────────┘   └───────────┘  │      │   │
│  │                                                          │      │   │
│  └──────────────────────────────────────────────────────────┘      │   │
│                                                                     │   │
└─────────────────────────────────────────────────────────────────────────┘
```

## 1.5.2 — Document Chunking Strategies

Chunking is the most impactful design decision in a RAG system. The wrong strategy leads to poor retrieval quality.

### Fixed-Size Chunking

Splits documents into chunks of a fixed token/character count with optional overlap.

```python
def fixed_size_chunk(text, chunk_size=500, overlap=50):
    words = text.split()
    chunks = []
    start = 0
    while start < len(words):
        end = start + chunk_size
        chunk = ' '.join(words[start:end])
        chunks.append(chunk)
        start = end - overlap
    return chunks
```

| Pros | Cons |
|------|------|
| Simple to implement | May split mid-sentence or mid-paragraph |
| Predictable chunk sizes | No awareness of document structure |
| Works for any document | Overlap can cause redundancy |

### Hierarchical Chunking

Creates parent and child chunks. Parent chunks provide broader context; child chunks provide specificity.

```
Document
├── Parent Chunk 1 (2000 tokens) — "Section: Introduction to Kubernetes"
│   ├── Child Chunk 1a (300 tokens) — "Pods are the smallest..."
│   ├── Child Chunk 1b (300 tokens) — "Services expose pods..."
│   └── Child Chunk 1c (300 tokens) — "Deployments manage..."
├── Parent Chunk 2 (2000 tokens) — "Section: Networking"
│   ├── Child Chunk 2a (300 tokens) — "CNI plugins provide..."
│   └── Child Chunk 2b (300 tokens) — "Network policies..."
```

**Retrieval strategy**: Search child chunks for precision, but return parent chunk for context. This gives the FM enough surrounding context to generate accurate answers.

Bedrock Knowledge Bases supports hierarchical chunking natively — you configure `parentChunkSize` and `childChunkSize`.

### Semantic Chunking

Splits at natural semantic boundaries using embedding similarity:

```python
def semantic_chunk(text, embedding_model, threshold=0.5):
    sentences = split_into_sentences(text)
    embeddings = [embedding_model.embed(s) for s in sentences]

    chunks = []
    current_chunk = [sentences[0]]

    for i in range(1, len(sentences)):
        similarity = cosine_similarity(embeddings[i-1], embeddings[i])
        if similarity < threshold:
            # Semantic break — start new chunk
            chunks.append(' '.join(current_chunk))
            current_chunk = [sentences[i]]
        else:
            current_chunk.append(sentences[i])

    chunks.append(' '.join(current_chunk))
    return chunks
```

| Pros | Cons |
|------|------|
| Respects topic boundaries | Requires embedding computation during chunking |
| Variable-size chunks match content | More complex implementation |
| Better retrieval quality | Unpredictable chunk sizes |

### Amazon Bedrock Chunking Options

| Strategy | Configuration | Best For |
|----------|--------------|----------|
| Default | 300 tokens, no overlap | Quick setup, general use |
| Fixed-size | Custom size + overlap | Predictable workloads |
| Hierarchical | Parent (1500) + child (300) | Complex documents needing context |
| Semantic | Boundary detection | Topic-diverse documents |
| None | No chunking (pass whole doc) | Small documents < context window |

> **EXAM TIP:** "Which chunking strategy?" is a common question pattern. If the scenario mentions "technical documentation with clear sections" → Hierarchical. If it mentions "diverse topics in single documents" → Semantic. If it mentions "simple, uniform documents" → Fixed-size. If it mentions "minimal setup" → Default Bedrock chunking.

## 1.5.3 — Embedding Models

### Amazon Titan Embeddings V2

- **Dimensions**: Configurable — 256, 512, or 1024 (default: 1024)
- **Max input tokens**: 8,192
- **Normalization**: Outputs are L2-normalized
- **Use cases**: General-purpose text and multimodal embeddings

```python
bedrock = boto3.client('bedrock-runtime')

response = bedrock.invoke_model(
    modelId='amazon.titan-embed-text-v2:0',
    body=json.dumps({
        "inputText": "Kubernetes pod scheduling algorithms",
        "dimensions": 1024,
        "normalize": True
    })
)

embedding = json.loads(response['body'].read())['embedding']
# Returns a list of 1024 floats
```

**Dimensionality Considerations:**

| Dimensions | Storage per Vector | Search Speed | Quality |
|------------|-------------------|-------------|---------|
| 256 | ~1 KB | Fastest | Good for simple similarity |
| 512 | ~2 KB | Fast | Balanced |
| 1024 | ~4 KB | Standard | Highest quality |

**Trade-off**: Lower dimensions = less storage, faster search, but potentially lower retrieval quality. For production RAG, 1024 is recommended unless storage/speed constraints force reduction.

### Cohere Embed

- Separate models for English and multilingual
- Search-optimized mode vs. clustering mode
- Supports `input_type` parameter: `search_document` (for indexing) vs. `search_query` (for querying)

> **EXAM TIP:** When using Cohere Embed, you *must* use `input_type: "search_document"` when embedding documents for indexing and `input_type: "search_query"` when embedding the user query. Using the wrong type will degrade search quality. This asymmetric embedding is a differentiator from Titan Embeddings.

## 1.5.4 — Search Architectures

### Semantic Search (Vector-Only)

```
User Query → Embed Query → k-NN Search → Top-K Results
```

- Uses cosine similarity or dot product between query and document vectors
- Excellent for meaning-based retrieval ("what is the refund process" matches "return policy")
- Poor at exact term matching ("error code E-4502" may not match)

### Keyword Search (Lexical — BM25)

```
User Query → Tokenize → BM25 Scoring → Top-K Results
```

- Traditional text search based on term frequency
- Excellent for exact matches, proper nouns, codes, and identifiers
- Poor at semantic understanding ("automobile" won't match "car")

### Hybrid Search (Best of Both)

```
User Query ──┬──> Embed Query ──> k-NN Search ──> Vector Results ──┐
             │                                                     │
             └──> Tokenize ──> BM25 Search ──> Keyword Results ───┤
                                                                   │
                                                          ┌────────▼────────┐
                                                          │ Score           │
                                                          │ Normalization   │
                                                          │ & Fusion        │
                                                          │ (RRF or linear) │
                                                          └────────┬────────┘
                                                                   │
                                                          ┌────────▼────────┐
                                                          │ Combined        │
                                                          │ Ranked Results  │
                                                          └─────────────────┘
```

**Reciprocal Rank Fusion (RRF):**

```python
def reciprocal_rank_fusion(vector_results, keyword_results, k=60):
    scores = {}

    for rank, doc in enumerate(vector_results):
        doc_id = doc['id']
        scores[doc_id] = scores.get(doc_id, 0) + 1.0 / (k + rank + 1)

    for rank, doc in enumerate(keyword_results):
        doc_id = doc['id']
        scores[doc_id] = scores.get(doc_id, 0) + 1.0 / (k + rank + 1)

    return sorted(scores.items(), key=lambda x: x[1], reverse=True)
```

**OpenSearch Hybrid Search:**
```json
{
    "query": {
        "hybrid": {
            "queries": [
                {
                    "match": {
                        "content_text": "kubernetes pod scheduling"
                    }
                },
                {
                    "knn": {
                        "content_vector": {
                            "vector": [0.12, -0.34, ...],
                            "k": 10
                        }
                    }
                }
            ]
        }
    }
}
```

> **EXAM TIP:** Hybrid search is almost always the best answer when a question asks about "maximizing retrieval quality" or mentions both "semantic understanding" and "exact term matching." Bedrock Knowledge Bases supports hybrid search with the `overrideSearchType: "HYBRID"` configuration. OpenSearch implements it natively via the hybrid query type.

## 1.5.5 — Amazon Bedrock Reranker Models

Reranking is a post-retrieval step that improves result ordering:

```
Initial Retrieval (Top 50) → Reranker Model → Reranked Results (Top 5)
```

**How it works:**
1. Retrieve a larger set of candidates (e.g., 50) using vector search
2. Pass each (query, candidate) pair to the reranker model
3. Reranker produces a relevance score for each pair
4. Return top-K by reranker score

**Amazon Bedrock Reranker (Cohere Rerank):**

```python
response = bedrock_agent.retrieve(
    knowledgeBaseId='KB12345',
    retrievalQuery={'text': 'How do I reset my password?'},
    retrievalConfiguration={
        'vectorSearchConfiguration': {
            'numberOfResults': 25,
            'overrideSearchType': 'HYBRID'
        }
    }
)

# Then rerank using Cohere Rerank via Bedrock
rerank_response = bedrock.invoke_model(
    modelId='cohere.rerank-v3-5:0',
    body=json.dumps({
        "query": "How do I reset my password?",
        "documents": [r['content']['text'] for r in response['retrievalResults']],
        "top_n": 5
    })
)
```

**Why reranking matters:** Vector search uses dot product / cosine similarity, which is an approximation. Reranking uses a cross-encoder model that jointly processes query and document — producing much more accurate relevance scores, at the cost of higher latency (can't pre-compute, must run at query time).

## 1.5.6 — Query Handling Techniques

### Query Expansion

Enrich the user query with additional terms to improve recall:

```python
def expand_query(original_query, bedrock_client):
    expansion_prompt = f"""Generate 3 alternative phrasings of this search query.
Return only the alternatives, one per line.
Query: {original_query}"""

    response = bedrock_client.converse(
        modelId='anthropic.claude-3-haiku-20240307-v1:0',
        messages=[{"role": "user", "content": [{"text": expansion_prompt}]}],
        inferenceConfig={"maxTokens": 200}
    )

    alternatives = response['output']['message']['content'][0]['text'].split('\n')
    all_queries = [original_query] + alternatives
    return all_queries
```

### Query Decomposition

Break complex queries into sub-queries:

```python
def decompose_query(complex_query, bedrock_client):
    prompt = f"""Break this complex question into simpler sub-questions
that can be answered independently. Return as a JSON array.
Question: {complex_query}"""

    response = bedrock_client.converse(
        modelId='anthropic.claude-3-haiku-20240307-v1:0',
        messages=[{"role": "user", "content": [{"text": prompt}]}],
        inferenceConfig={"maxTokens": 300}
    )

    sub_queries = json.loads(response['output']['message']['content'][0]['text'])
    return sub_queries

# Example:
# Input: "Compare our Q3 and Q4 sales performance in North America"
# Output: ["What was Q3 sales in North America?",
#          "What was Q4 sales in North America?",
#          "What are key differences between Q3 and Q4?"]
```

### Query Transformation

Rewrite queries for better retrieval:

```python
def transform_query_for_retrieval(user_query, conversation_history, bedrock_client):
    """Resolve pronouns and add context from conversation history."""
    prompt = f"""Given the conversation history and latest query, rewrite the
query to be self-contained (resolve pronouns, add context).

History: {json.dumps(conversation_history[-3:])}
Query: {user_query}

Return only the rewritten query."""

    response = bedrock_client.converse(
        modelId='anthropic.claude-3-haiku-20240307-v1:0',
        messages=[{"role": "user", "content": [{"text": prompt}]}],
        inferenceConfig={"maxTokens": 100}
    )

    return response['output']['message']['content'][0]['text']

# Example:
# History: [{"role": "user", "content": "Tell me about Aurora"}]
# Query: "How does it handle failover?"
# Transformed: "How does Amazon Aurora handle failover?"
```

> **EXAM TIP:** Query transformation is critical for multi-turn conversations. The exam tests whether you know that sending "How does it work?" to a vector store will return poor results because there's no context. The correct pattern is: resolve references using conversation history BEFORE embedding the query.

## 1.5.7 — Function Calling and Model Context Protocol (MCP)

**Function Calling (Tool Use):**

Function calling lets FMs invoke external tools/APIs to access real-time data or perform actions:

```python
response = bedrock.converse(
    modelId='anthropic.claude-3-sonnet-20240229-v1:0',
    messages=[{
        "role": "user",
        "content": [{"text": "What's the current stock price of AMZN?"}]
    }],
    toolConfig={
        "tools": [{
            "toolSpec": {
                "name": "get_stock_price",
                "description": "Get current stock price for a ticker symbol",
                "inputSchema": {
                    "json": {
                        "type": "object",
                        "properties": {
                            "ticker": {
                                "type": "string",
                                "description": "Stock ticker symbol"
                            }
                        },
                        "required": ["ticker"]
                    }
                }
            }
        }]
    }
)

# Model responds with toolUse block:
# {"toolUse": {"name": "get_stock_price", "input": {"ticker": "AMZN"}}}
# You call the actual API, then send the result back as a toolResult message
```

**Bedrock Agents:**

Bedrock Agents automate the function-calling loop:
1. Define action groups (Lambda functions or API schemas)
2. Agent automatically decides which tool to call
3. Agent orchestrates multi-step tool chains
4. Agent formats the final response

**Model Context Protocol (MCP):**
- An open standard for connecting FMs to external data sources and tools
- Standardizes the interface between AI applications and integrations
- Enables portable tool definitions across different FM providers
- Similar to how USB standardized peripheral connections

---

# Task 1.6: Implement Prompt Engineering Strategies and Governance

## 1.6.1 — Prompt Engineering Workflow

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    PROMPT ENGINEERING WORKFLOW                           │
│                                                                         │
│  ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────────────┐    │
│  │ Define   │──>│ Draft    │──>│ Test     │──>│ Evaluate         │    │
│  │ Goal &   │   │ Prompt   │   │ Against  │   │ Quality          │    │
│  │ Criteria │   │ Template │   │ Edge     │   │ Metrics          │    │
│  └──────────┘   └──────────┘   │ Cases    │   └────────┬─────────┘    │
│       │                        └──────────┘            │              │
│       │                                           Pass? │              │
│       │                                    ┌───────┴───────┐          │
│       │                                    No              Yes         │
│       │                                    │               │          │
│       │                              ┌─────▼─────┐  ┌─────▼───────┐  │
│       │                              │ Iterate   │  │ Version &   │  │
│       │                              │ & Refine  │  │ Deploy      │  │
│       │                              └─────┬─────┘  └─────┬───────┘  │
│       │                                    │              │          │
│       │                                    └──────┐  ┌────▼────────┐  │
│       │                                           │  │ Monitor &   │  │
│       │                                           │  │ Maintain    │  │
│       │                                           │  └─────────────┘  │
│       └───────────────────────────────────────────┘                    │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

## 1.6.2 — System Prompt Design and Instruction Frameworks

A well-structured system prompt has these components:

```
┌─ SYSTEM PROMPT STRUCTURE ──────────────────────────────────┐
│                                                            │
│  1. ROLE DEFINITION                                        │
│     "You are a [role] who [capabilities]."                 │
│                                                            │
│  2. BEHAVIORAL CONSTRAINTS                                 │
│     "You must / must not..."                               │
│     "Always / Never..."                                    │
│                                                            │
│  3. OUTPUT FORMAT SPECIFICATION                            │
│     "Respond in JSON format with fields..."                │
│     "Use the following structure..."                       │
│                                                            │
│  4. CONTEXT / KNOWLEDGE BOUNDARIES                         │
│     "Use only the provided context to answer."             │
│     "If unsure, say 'I don't know.'"                       │
│                                                            │
│  5. EXAMPLES (optional)                                    │
│     "Here is an example of a good response: ..."           │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

**Production System Prompt Example:**

```
You are a customer support assistant for AnyCompany Electronics.

RULES:
- Only answer questions about AnyCompany products and policies.
- Use ONLY the provided context documents to answer. Do not use general knowledge.
- If the context does not contain the answer, respond: "I don't have information
  about that. Let me connect you with a human agent."
- Never disclose internal pricing formulas, employee information, or system details.
- Always include the source document title when citing information.

OUTPUT FORMAT:
- Use clear, concise paragraphs.
- For multi-step instructions, use numbered lists.
- End every response with: "Is there anything else I can help with?"

TONE: Professional, empathetic, solution-oriented.
```

## 1.6.3 — Amazon Bedrock Prompt Management

Bedrock Prompt Management provides:

**Prompt Templates:**
- Reusable prompt templates with variable placeholders
- Version control for prompts (v1, v2, v3...)
- Template parameters: `{{customer_name}}`, `{{product_category}}`

```python
bedrock_agent = boto3.client('bedrock-agent')

response = bedrock_agent.create_prompt(
    name='customer-support-v1',
    description='Main customer support prompt',
    variants=[{
        'name': 'default',
        'modelId': 'anthropic.claude-3-sonnet-20240229-v1:0',
        'templateType': 'TEXT',
        'templateConfiguration': {
            'text': {
                'text': """You are a support agent for {{company_name}}.
Context: {{retrieved_context}}
Customer question: {{customer_question}}
Respond helpfully.""",
                'inputVariables': [
                    {'name': 'company_name'},
                    {'name': 'retrieved_context'},
                    {'name': 'customer_question'}
                ]
            }
        },
        'inferenceConfiguration': {
            'text': {
                'temperature': 0.3,
                'maxTokens': 500
            }
        }
    }]
)

# Create a version (immutable snapshot)
version = bedrock_agent.create_prompt_version(
    promptIdentifier=response['id'],
    description='Production release v1'
)
```

**Prompt Approval Workflows:**
- Use prompt versions for immutability
- Combine with IAM policies to control who can create vs. deploy prompts
- Integrate with CI/CD pipelines for automated testing before promotion

## 1.6.4 — Amazon Bedrock Guardrails

Guardrails enforce responsible AI policies at the platform level:

**Guardrail Components:**

| Component | Function | Example |
|-----------|----------|---------|
| Content Filters | Block harmful content categories | Hate, violence, sexual, misconduct |
| Denied Topics | Block specific topic areas | Competitor comparisons, medical advice |
| Word Filters | Block specific words/phrases | Profanity, competitor names |
| Sensitive Info Filters | Detect/mask PII | SSN, credit cards, email addresses |
| Contextual Grounding | Check response grounding in context | Hallucination detection, relevance check |

```python
bedrock = boto3.client('bedrock')

response = bedrock.create_guardrail(
    name='customer-support-guardrail',
    description='Guardrail for customer support chatbot',
    contentPolicyConfig={
        'filtersConfig': [
            {'type': 'HATE', 'inputStrength': 'HIGH', 'outputStrength': 'HIGH'},
            {'type': 'VIOLENCE', 'inputStrength': 'HIGH', 'outputStrength': 'HIGH'},
            {'type': 'SEXUAL', 'inputStrength': 'HIGH', 'outputStrength': 'HIGH'},
            {'type': 'MISCONDUCT', 'inputStrength': 'HIGH', 'outputStrength': 'HIGH'},
        ]
    },
    topicPolicyConfig={
        'topicsConfig': [
            {
                'name': 'competitor-discussion',
                'definition': 'Discussions comparing our products to competitor products',
                'examples': ['Is your product better than CompetitorX?'],
                'type': 'DENY'
            }
        ]
    },
    sensitiveInformationPolicyConfig={
        'piiEntitiesConfig': [
            {'type': 'EMAIL', 'action': 'ANONYMIZE'},
            {'type': 'PHONE', 'action': 'ANONYMIZE'},
            {'type': 'US_SOCIAL_SECURITY_NUMBER', 'action': 'BLOCK'},
            {'type': 'CREDIT_DEBIT_CARD_NUMBER', 'action': 'BLOCK'},
        ],
        'regexesConfig': [
            {
                'name': 'internal-project-code',
                'description': 'Block internal project codes',
                'pattern': 'PROJ-[A-Z]{3}-\\d{4}',
                'action': 'BLOCK'
            }
        ]
    },
    contextualGroundingPolicyConfig={
        'filtersConfig': [
            {'type': 'GROUNDING', 'threshold': 0.7},
            {'type': 'RELEVANCE', 'threshold': 0.7}
        ]
    },
    blockedInputMessaging='I cannot process this request.',
    blockedOutputsMessaging='I cannot provide this information.'
)
```

**Applying Guardrails to API Calls:**

```python
response = bedrock.converse(
    modelId='anthropic.claude-3-sonnet-20240229-v1:0',
    messages=[{"role": "user", "content": [{"text": user_input}]}],
    guardrailConfig={
        'guardrailIdentifier': 'guardrail-id-123',
        'guardrailVersion': '1',
        'trace': 'enabled'  # Returns details about guardrail actions
    }
)

# Check if guardrail intervened
if response.get('stopReason') == 'guardrail_intervened':
    print("Guardrail blocked this interaction")
    print(response['output']['message']['content'][0]['text'])
    # This will contain the blockedOutputsMessaging
```

> **EXAM TIP:** Guardrails can be applied to *both* input (user prompts) and output (model responses). The exam tests whether you know this distinction. Content filters have separate `inputStrength` and `outputStrength` settings. Contextual grounding only applies to outputs. PII filters can be set to BLOCK (reject entirely) or ANONYMIZE (mask the PII and continue).

## 1.6.5 — Conversational AI Architecture

### Step Functions for Clarification Workflows

```
┌────────────────────────────────────────────────────────────────┐
│              Clarification Workflow (Step Functions)             │
│                                                                │
│  ┌──────────┐    ┌──────────────┐     ┌──────────────┐        │
│  │ Receive  │───>│ Classify     │────>│ Sufficient   │        │
│  │ User     │    │ Intent       │     │ Info?        │        │
│  │ Input    │    │ (Comprehend) │     │              │        │
│  └──────────┘    └──────────────┘     └──────┬───────┘        │
│                                              │                 │
│                                    ┌─────────┴──────────┐      │
│                                    │                    │      │
│                                   YES                  NO      │
│                                    │                    │      │
│                            ┌───────▼──────┐    ┌───────▼────┐  │
│                            │ Generate     │    │ Generate   │  │
│                            │ Response     │    │ Clarifying │  │
│                            │ (Bedrock)    │    │ Question   │  │
│                            └──────────────┘    │ (Bedrock)  │  │
│                                                └──────┬─────┘  │
│                                                       │        │
│                                                ┌──────▼─────┐  │
│                                                │ Wait for   │  │
│                                                │ User Reply │  │
│                                                │ (Callback) │  │
│                                                └──────┬─────┘  │
│                                                       │        │
│                                                  Loop back     │
│                                                  to Classify   │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

### DynamoDB for Conversation History

```python
# Conversation history table design
table_schema = {
    'TableName': 'conversation_history',
    'KeySchema': [
        {'AttributeName': 'conversation_id', 'KeyType': 'HASH'},
        {'AttributeName': 'turn_number', 'KeyType': 'RANGE'}
    ],
    'AttributeDefinitions': [
        {'AttributeName': 'conversation_id', 'AttributeType': 'S'},
        {'AttributeName': 'turn_number', 'AttributeType': 'N'},
        {'AttributeName': 'user_id', 'AttributeType': 'S'}
    ],
    'GlobalSecondaryIndexes': [{
        'IndexName': 'user-conversations-index',
        'KeySchema': [
            {'AttributeName': 'user_id', 'KeyType': 'HASH'},
            {'AttributeName': 'conversation_id', 'KeyType': 'RANGE'}
        ],
        'Projection': {'ProjectionType': 'ALL'}
    }],
    'TimeToLiveSpecification': {
        'Enabled': True,
        'AttributeName': 'ttl'
    }
}
```

**Sliding Window for Context Management:**

```python
def get_conversation_context(conversation_id, max_turns=10, max_tokens=4000):
    response = table.query(
        KeyConditionExpression=Key('conversation_id').eq(conversation_id),
        ScanIndexForward=False,  # Most recent first
        Limit=max_turns
    )

    turns = list(reversed(response['Items']))
    messages = []
    token_count = 0

    for turn in turns:
        estimated_tokens = len(turn['content']) // 4
        if token_count + estimated_tokens > max_tokens:
            break
        messages.append({
            'role': turn['role'],
            'content': [{'text': turn['content']}]
        })
        token_count += estimated_tokens

    return messages
```

## 1.6.6 — Prompt Governance

### Parameterized Templates

```python
# S3-based prompt template repository
prompt_template = {
    "template_id": "support-v3",
    "version": "3.2.1",
    "author": "ai-platform-team",
    "approved_by": "ai-governance-board",
    "approved_date": "2024-11-15",
    "model_compatibility": [
        "anthropic.claude-3-sonnet-*",
        "anthropic.claude-3-haiku-*"
    ],
    "template": "You are {{role}}. {{constraints}} Context: {{context}} Question: {{question}}",
    "parameters": {
        "role": {"type": "string", "required": True, "allowed_values": ["support agent", "technical advisor"]},
        "constraints": {"type": "string", "required": True},
        "context": {"type": "string", "required": True, "max_length": 10000},
        "question": {"type": "string", "required": True, "max_length": 2000}
    },
    "guardrail_id": "guardrail-abc123",
    "max_tokens": 500,
    "temperature": 0.3
}
```

### CloudTrail Tracking for Prompt Changes

Every Bedrock API call is logged in CloudTrail:

```json
{
    "eventName": "InvokeModel",
    "eventSource": "bedrock.amazonaws.com",
    "requestParameters": {
        "modelId": "anthropic.claude-3-sonnet-20240229-v1:0",
        "guardrailIdentifier": "guardrail-abc123",
        "guardrailVersion": "1"
    },
    "userIdentity": {
        "arn": "arn:aws:iam::123456789012:role/app-genai-role"
    }
}
```

**Note**: CloudTrail logs the *metadata* of API calls (which model, which guardrail, which IAM role) but does NOT log prompt content by default. To log prompts and responses, enable **Bedrock Model Invocation Logging** which sends full request/response payloads to S3 and/or CloudWatch Logs.

```python
bedrock = boto3.client('bedrock')

bedrock.put_model_invocation_logging_configuration(
    loggingConfig={
        'cloudWatchConfig': {
            'logGroupName': '/aws/bedrock/model-invocations',
            'roleArn': 'arn:aws:iam::123456789012:role/bedrock-logging-role',
            'largeDataDeliveryS3Config': {
                'bucketName': 'bedrock-invocation-logs',
                'keyPrefix': 'large-payloads/'
            }
        },
        's3Config': {
            'bucketName': 'bedrock-invocation-logs',
            'keyPrefix': 'all-invocations/'
        },
        'textDataDeliveryEnabled': True,
        'imageDataDeliveryEnabled': True,
        'embeddingDataDeliveryEnabled': True
    }
)
```

> **EXAM TIP:** The exam distinguishes between CloudTrail (who called what API, when) and Model Invocation Logging (what was the actual prompt and response). If a question asks about "auditing which users accessed the model" → CloudTrail. If it asks about "logging prompt content for quality review" → Model Invocation Logging to S3/CloudWatch.

### CloudWatch Monitoring for Prompts

Key metrics to monitor:

| Metric | Source | Alert Threshold |
|--------|--------|----------------|
| `InvocationLatency` | Bedrock CloudWatch | > 10s p99 |
| `InvocationClientErrors` (4xx) | Bedrock CloudWatch | > 5% error rate |
| `InvocationServerErrors` (5xx) | Bedrock CloudWatch | > 1% error rate |
| `InvocationThrottles` | Bedrock CloudWatch | Any throttle events |
| `InputTokenCount` | Model Invocation Logs | Unusual spikes |
| `OutputTokenCount` | Model Invocation Logs | Unusual spikes |
| `GuardrailBlocked` | Custom metric | > 10% block rate |

## 1.6.7 — Quality Assurance

### Lambda for Output Verification

```python
def verify_output(event, context):
    model_response = event['model_response']
    expected_format = event['expected_format']

    checks = {
        'format_valid': False,
        'length_valid': False,
        'no_hallucination_markers': False,
        'tone_appropriate': False
    }

    # Format check
    if expected_format == 'json':
        try:
            parsed = json.loads(model_response)
            required_fields = event.get('required_fields', [])
            checks['format_valid'] = all(f in parsed for f in required_fields)
        except json.JSONDecodeError:
            checks['format_valid'] = False
    elif expected_format == 'text':
        checks['format_valid'] = len(model_response.strip()) > 0

    # Length check
    min_len = event.get('min_length', 10)
    max_len = event.get('max_length', 5000)
    checks['length_valid'] = min_len <= len(model_response) <= max_len

    # Hallucination markers
    hallucination_phrases = [
        "as an AI", "I don't have access", "I cannot verify",
        "based on my training data"
    ]
    checks['no_hallucination_markers'] = not any(
        phrase.lower() in model_response.lower()
        for phrase in hallucination_phrases
    )

    checks['all_passed'] = all(checks.values())
    return checks
```

### Step Functions for Edge Case Testing

```json
{
    "Comment": "Prompt regression testing pipeline",
    "StartAt": "LoadTestCases",
    "States": {
        "LoadTestCases": {
            "Type": "Task",
            "Resource": "arn:aws:lambda:us-east-1:123456789012:function:load-test-cases",
            "Next": "RunTests"
        },
        "RunTests": {
            "Type": "Map",
            "ItemsPath": "$.test_cases",
            "MaxConcurrency": 10,
            "Iterator": {
                "StartAt": "InvokeModel",
                "States": {
                    "InvokeModel": {
                        "Type": "Task",
                        "Resource": "arn:aws:states:::bedrock:invokeModel",
                        "Parameters": {
                            "ModelId.$": "$.model_id",
                            "Body.$": "$.request_body"
                        },
                        "Next": "ValidateOutput"
                    },
                    "ValidateOutput": {
                        "Type": "Task",
                        "Resource": "arn:aws:lambda:us-east-1:123456789012:function:validate-output",
                        "End": true
                    }
                }
            },
            "Next": "AggregateResults"
        },
        "AggregateResults": {
            "Type": "Task",
            "Resource": "arn:aws:lambda:us-east-1:123456789012:function:aggregate-results",
            "Next": "CheckThreshold"
        },
        "CheckThreshold": {
            "Type": "Choice",
            "Choices": [{
                "Variable": "$.pass_rate",
                "NumericGreaterThanEquals": 0.95,
                "Next": "ApprovePrompt"
            }],
            "Default": "RejectPrompt"
        },
        "ApprovePrompt": {
            "Type": "Task",
            "Resource": "arn:aws:lambda:us-east-1:123456789012:function:approve-prompt",
            "End": true
        },
        "RejectPrompt": {
            "Type": "Task",
            "Resource": "arn:aws:lambda:us-east-1:123456789012:function:notify-rejection",
            "End": true
        }
    }
}
```

## 1.6.8 — Advanced Prompting Techniques

### Zero-Shot Prompting

No examples provided. Relies entirely on the model's training:

```
Classify the following customer review as POSITIVE, NEGATIVE, or NEUTRAL.
Review: "The product arrived on time but the packaging was damaged."
Classification:
```

**When to use:** When the task is straightforward and the model has strong baseline capability. Good for: simple classification, summarization, translation.

### Few-Shot Prompting

Provide examples to guide the model:

```
Classify customer reviews. Examples:

Review: "Absolutely love this product! Best purchase ever."
Classification: POSITIVE

Review: "Terrible quality. Broke after one day."
Classification: NEGATIVE

Review: "It's okay, nothing special."
Classification: NEUTRAL

Review: "The product arrived on time but the packaging was damaged."
Classification:
```

**When to use:** When zero-shot performance is insufficient, or when you need the model to follow a specific format or reasoning pattern. Typically 3-5 examples are sufficient.

### Chain-of-Thought (CoT) Prompting

Ask the model to reason step-by-step:

```
A customer wants to return a laptop purchased 45 days ago. Our policy allows
returns within 30 days for electronics, but extends to 60 days for premium
members. The customer is a premium member.

Think through this step by step:
1. What is the standard return window?
2. Does the customer qualify for any extensions?
3. Is the return within the applicable window?
4. What is the final decision?
```

**When to use:** Complex reasoning, math, multi-step logic, policy evaluation. CoT significantly improves accuracy on reasoning-heavy tasks.

### Structured Input/Output

Force structured responses:

```
Extract information from the following product review and return as JSON.

Review: "I bought the UltraWidget Pro (model UW-3000) for $299 on Black Friday.
The battery life is amazing but the screen could be brighter."

Return JSON with these exact fields:
{
    "product_name": "",
    "model_number": "",
    "price": 0,
    "purchase_context": "",
    "positive_aspects": [],
    "negative_aspects": []
}
```

### Feedback Loops

Iterative refinement within a single interaction:

```python
def iterative_refinement(initial_prompt, bedrock_client, max_iterations=3):
    response = generate(initial_prompt, bedrock_client)

    for i in range(max_iterations):
        evaluation = evaluate_response(response)

        if evaluation['score'] >= 0.9:
            return response

        refinement_prompt = f"""Your previous response scored {evaluation['score']}/1.0.
Issues found: {evaluation['issues']}
Original prompt: {initial_prompt}
Previous response: {response}
Please improve your response addressing the issues above."""

        response = generate(refinement_prompt, bedrock_client)

    return response
```

> **EXAM TIP:** The exam tests whether you can match the prompting technique to the scenario. Straightforward task with a capable model → Zero-shot. Model not following desired format → Few-shot. Complex reasoning or math → Chain-of-thought. Need structured data extraction → Structured output prompting.

## 1.6.9 — Amazon Bedrock Prompt Flows

Prompt Flows enable visual orchestration of multi-step GenAI workflows:

**Key Concepts:**

- **Flow**: A directed graph of nodes
- **Node Types**: Input, Output, Prompt, Condition, Lambda, Knowledge Base, Iterator, Collector
- **Connections**: Data flows from node outputs to node inputs
- **Variables**: Pass data between nodes

**Flow Patterns:**

### Sequential Chain

```
┌───────┐    ┌────────────┐    ┌────────────┐    ┌────────┐
│ Input │───>│ Summarize  │───>│ Translate  │───>│ Output │
│       │    │ (Claude)   │    │ (Claude)   │    │        │
└───────┘    └────────────┘    └────────────┘    └────────┘
```

Use case: Summarize an English document, then translate the summary to French.

### Conditional Branching

```
┌───────┐    ┌────────────┐    ┌──────────────────────────────┐
│ Input │───>│ Classify   │───>│ Condition:                   │
│       │    │ Intent     │    │ if intent == "technical"     │
└───────┘    │ (Haiku)    │    │   → Technical KB + Sonnet    │
             └────────────┘    │ if intent == "billing"       │
                               │   → Billing KB + Haiku       │
                               │ else                         │
                               │   → General Response         │
                               └──────────────────────────────┘
```

### Pre/Post-Processing

```
┌───────┐    ┌────────────┐    ┌────────────┐    ┌──────────┐    ┌────────┐
│ Input │───>│ Lambda:    │───>│ Prompt:    │───>│ Lambda:  │───>│ Output │
│       │    │ Validate & │    │ Generate   │    │ Format & │    │        │
│       │    │ Enrich     │    │ Response   │    │ Filter   │    │        │
└───────┘    └────────────┘    └────────────┘    └──────────┘    └────────┘
```

```python
# Creating a Prompt Flow
bedrock_agent = boto3.client('bedrock-agent')

flow = bedrock_agent.create_flow(
    name='customer-support-flow',
    description='Multi-step customer support with intent routing',
    executionRoleArn='arn:aws:iam::123456789012:role/bedrock-flow-role',
    definition={
        "nodes": [
            {
                "name": "Input",
                "type": "Input",
                "configuration": {"input": {}},
                "outputs": [{"name": "document", "type": "String"}]
            },
            {
                "name": "ClassifyIntent",
                "type": "Prompt",
                "configuration": {
                    "prompt": {
                        "sourceConfiguration": {
                            "inline": {
                                "modelId": "anthropic.claude-3-haiku-20240307-v1:0",
                                "templateType": "TEXT",
                                "templateConfiguration": {
                                    "text": {
                                        "text": "Classify this as technical or billing: {{input}}",
                                        "inputVariables": [{"name": "input"}]
                                    }
                                },
                                "inferenceConfiguration": {
                                    "text": {"maxTokens": 50, "temperature": 0}
                                }
                            }
                        }
                    }
                },
                "inputs": [{"name": "input", "type": "String", "expression": "$.data"}],
                "outputs": [{"name": "modelCompletion", "type": "String"}]
            },
            {
                "name": "RouteByIntent",
                "type": "Condition",
                "configuration": {
                    "condition": {
                        "conditions": [{
                            "name": "is_technical",
                            "expression": "intent == 'technical'"
                        }]
                    }
                },
                "inputs": [{"name": "intent", "type": "String", "expression": "$.data"}]
            }
        ],
        "connections": [
            {"name": "input_to_classify", "source": "Input", "target": "ClassifyIntent",
             "type": "Data", "configuration": {"data": {"sourceOutput": "document", "targetInput": "input"}}},
            {"name": "classify_to_route", "source": "ClassifyIntent", "target": "RouteByIntent",
             "type": "Data", "configuration": {"data": {"sourceOutput": "modelCompletion", "targetInput": "intent"}}}
        ]
    }
)
```

> **EXAM TIP:** Prompt Flows questions test whether you understand the node types and when to use them. Condition nodes for routing, Lambda nodes for custom processing, Knowledge Base nodes for RAG, Prompt nodes for FM inference. If a question describes a multi-step workflow with branching logic → Prompt Flows. If it describes simple sequential chaining → you could use Prompt Flows, but for very simple cases, a Lambda calling Bedrock multiple times may suffice.

---

## Comprehensive Exam Preparation Summary

### Key Service Pairings to Memorize

| Scenario | Primary Service(s) |
|----------|-------------------|
| Managed RAG | Bedrock Knowledge Bases |
| Custom vector search | OpenSearch Service |
| SQL + vectors | Aurora PostgreSQL + pgvector |
| Graph knowledge | Neptune |
| Conversation state | DynamoDB |
| Data validation (batch) | Glue Data Quality |
| Data validation (real-time) | Lambda |
| PII detection | Comprehend or Bedrock Guardrails |
| Model routing | AppConfig + Lambda |
| Failover | Step Functions circuit breaker |
| Throttle protection | Cross-Region Inference |
| Prompt versioning | Bedrock Prompt Management |
| Content safety | Bedrock Guardrails |
| Audit trail (API calls) | CloudTrail |
| Audit trail (prompts/responses) | Bedrock Model Invocation Logging |
| Multi-step orchestration | Bedrock Prompt Flows or Step Functions |
| Fine-tuned model hosting | Bedrock Provisioned Throughput or SageMaker |
| Scheduled processing | EventBridge + Lambda/Step Functions |

### Common Exam Traps

1. **Trap: Using SageMaker when Bedrock suffices.** If the scenario doesn't require custom model training or hosting models not available in Bedrock, Bedrock is the simpler answer.

2. **Trap: Using DynamoDB as a vector store.** DynamoDB stores metadata. It is not a vector database. Always pair it with a real vector search engine.

3. **Trap: Confusing CloudTrail with Model Invocation Logging.** CloudTrail = API-level audit. Model Invocation Logging = prompt/response content logging.

4. **Trap: Ignoring the Converse API.** For multi-model applications, the Converse API is the recommended approach over model-specific InvokeModel calls.

5. **Trap: Fine-tuning when RAG is sufficient.** RAG is faster, cheaper, and doesn't require training data curation. Only fine-tune when you need the model to learn new *behaviors* (tone, format, domain-specific reasoning), not just new *facts*.

6. **Trap: Over-provisioning.** On-demand throughput is the default. Only use Provisioned Throughput when you have predictable, high-volume traffic or are deploying a custom/fine-tuned model.

7. **Trap: Single-region design without resilience.** Production systems should use Cross-Region Inference or explicit multi-region failover for availability.

8. **Trap: Forgetting metadata filters in vector search.** Pure vector search returns semantically similar results regardless of access control or document scope. Always combine with metadata filters for multi-tenant or access-controlled scenarios.

### Last-Minute Review Checklist

- [ ] Can you explain the difference between InvokeModel, Converse, and ConverseStream?
- [ ] Can you list the chunking strategies and when to use each?
- [ ] Can you describe the RAG pipeline from document to response?
- [ ] Do you know which models support fine-tuning on Bedrock?
- [ ] Can you explain how Guardrails work at both input and output?
- [ ] Do you understand Prompt Flows node types?
- [ ] Can you select the right vector store for a given scenario?
- [ ] Do you know the difference between semantic, keyword, and hybrid search?
- [ ] Can you describe the circuit breaker pattern with Step Functions?
- [ ] Do you understand when to use AppConfig vs. Lambda env vars for model routing?
- [ ] Can you explain Cross-Region Inference and its geographic constraints?
- [ ] Do you know the training data format for Bedrock fine-tuning (JSONL)?
- [ ] Can you describe Model Invocation Logging configuration?
- [ ] Do you understand embedding dimensionality trade-offs?
- [ ] Can you explain reranking and why it improves RAG quality?

---

*This study guide covers Domain 1 (31%) of the AWS Certified Generative AI Developer - Professional (AIP-C01) exam. For the remaining domains, see the companion guides in this series.*
