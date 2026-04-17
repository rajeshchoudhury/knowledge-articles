# 2.3 — Amazon Bedrock Deep Dive

Amazon Bedrock is the central service for this exam. At least 25–30% of questions touch Bedrock directly.

---

## 1. What Is Amazon Bedrock?

**Bedrock** = fully managed, serverless service that gives you API access to **foundation models (FMs)** from multiple providers — plus a set of enterprise features (Knowledge Bases, Agents, Guardrails, Model Evaluation, Flows, Model Customization, Prompt Management).

Key features to memorize:

- **Serverless** — no infra to manage, no GPUs to provision for on-demand use.
- **Single API** (`InvokeModel`, `InvokeModelWithResponseStream`, `Converse`, `ConverseStream`) across models.
- **Private** — your prompts and completions **are not used to train Bedrock FMs**. Data stays in your AWS account.
- **Regional** — models available per region; data residency.
- **Integrates with IAM, KMS, VPC endpoints (PrivateLink), CloudTrail, CloudWatch**.

---

## 2. Models Available

### First-party (Amazon)
- **Amazon Nova** — Micro (text), Lite, Pro, Premier, Canvas (image), Reel (video), Sonic (speech).
- **Amazon Titan** — Titan Text, Titan Embeddings V2 (text), Titan Multimodal Embeddings, Titan Image Generator.

### Third-party
- **Anthropic Claude** (Haiku, Sonnet, Opus; Claude 3, 3.5, 3.7, 4).
- **Meta Llama** (3, 3.1, 3.2 — incl. vision, 3.3).
- **Mistral AI** (Mistral 7B, Small, Large, Mixtral).
- **Cohere** (Command R, Command R+, Embed, Rerank).
- **AI21 Labs** (Jamba family).
- **Stability AI** (Stable Diffusion XL, Stable Image).
- **DeepSeek**, **Writer Palmyra** — via Bedrock Marketplace.

### Bedrock Marketplace
Over 100 additional proprietary and specialized models. You provision a SageMaker-managed endpoint behind the scenes; still called via the Bedrock API.

### Model Access
- Models are **not enabled by default** — go to Bedrock console → **Model access** and request access to each model you want to use.
- Some require agreement to the provider's EULA.

---

## 3. Bedrock Pricing Modes

| Mode | What it is | Good for |
|------|------------|----------|
| **On-Demand** | Pay per input + output token | Variable / spiky / new workloads |
| **Batch** | Bulk jobs from S3, async, ~50% discount | Large-scale offline generation |
| **Provisioned Throughput** | Reserve **Model Units (MUs)** at hourly cost; higher throughput, required for most custom models | Steady high-volume production, custom models |
| **Model Customization** | Fine-tuning / continued pretraining jobs — charged per training token + storage | Custom fine-tuned models |

**Model Unit (MU)** — unit of committed throughput. You can reserve 1-month or 6-month terms; 6-month is cheaper. Serving a custom (fine-tuned) model **requires** provisioned throughput on most Bedrock models.

### Cost levers
- Choose a smaller model (Haiku vs Sonnet vs Opus; Nova Micro vs Pro).
- Use **batch** for non-interactive workloads (~50% cheaper).
- Use **prompt caching** (supported on Claude and Nova).
- Keep prompts short; cap `max_tokens`.
- Avoid unnecessary fine-tuning — prefer prompt + RAG.

---

## 4. Bedrock APIs

### 4.1 `InvokeModel`
Legacy, model-specific payload. Each model has its own JSON schema.

### 4.2 `InvokeModelWithResponseStream`
Streaming version (server-sent events style) — tokens arrive as they generate. Good for chat UX.

### 4.3 `Converse` / `ConverseStream` (preferred)
**Unified API** across all supported chat models. You pass messages, system prompt, inference config, and optional `toolConfig` for function calling. AWS strongly recommends `Converse` for new code.

### 4.4 `InvokeAgent`
Invoke an agent (see Agents section).

### 4.5 `RetrieveAndGenerate` / `Retrieve`
Query a Knowledge Base (RAG).

### 4.6 `ApplyGuardrail`
Standalone guardrail evaluation on arbitrary text (can be used independently of an FM call).

---

## 5. Bedrock Features — The Big Seven

### 5.1 Bedrock Knowledge Bases (KB) — Managed RAG

- You point Bedrock at an **S3 bucket** (or **Confluence**, **SharePoint**, **Salesforce**, **web crawler**, **Atlassian**, **custom**).
- Bedrock automatically chunks documents, embeds them (Titan Embeddings or Cohere Embed), and indexes them in a **vector store** of your choice:
  - **Amazon OpenSearch Serverless** (default)
  - **Amazon Aurora PostgreSQL with pgvector**
  - **Amazon Neptune Analytics (vector)**
  - **MongoDB Atlas**
  - **Pinecone**
  - **Redis Enterprise Cloud**
- Advanced chunking: fixed size, hierarchical, semantic, no chunking, custom (Lambda).
- **Query**: the user question → embedded → retrieved top-k chunks → passed with the question to an FM → answer with **citations**.
- Supports **multimodal KBs** (images + text).
- Offers **metadata filtering** and **hybrid search** (semantic + lexical).

### 5.2 Agents for Amazon Bedrock

- An **agent** is an FM that can:
  1. Plan multi-step tasks.
  2. Call APIs you expose as **Action Groups** (typically backed by **Lambda** + OpenAPI schema, or function definitions).
  3. Query **Knowledge Bases**.
  4. Maintain session memory.
  5. Use **Guardrails**.
- Great for: "book me a flight", "process this claim", "triage this support ticket with CRM + ticketing".
- **ReAct** loop: Reason → Act → Observe → repeat.
- **Multi-agent collaboration** — supervisor agent orchestrating specialist sub-agents.
- Invoke via `InvokeAgent` or via **Flows**.

### 5.3 Guardrails for Amazon Bedrock

Safety / compliance layer. Key capabilities:

- **Content filters** — block hate, insults, sexual, violence, misconduct, prompt attacks. Configurable strength (Low/Medium/High).
- **Denied topics** — natural-language definitions of topics to block (e.g., "no investment advice").
- **Word filters** — block specific words and profanity.
- **Sensitive information filters** — detect and mask/block **PII** (SSN, credit card, name, email, address, phone, driver's license, bank account, etc.) and **custom regex**.
- **Contextual grounding checks** — check that a response is grounded in a provided reference (RAG) and relevant to the user query (reduces hallucination).
- **Automated Reasoning checks** — new feature that uses formal logic to verify factual claims against a policy (e.g., HR policies).

Guardrails can be applied:
- During `InvokeModel` / `Converse` by passing a `guardrailIdentifier`.
- Within Agents and Knowledge Bases.
- Standalone via `ApplyGuardrail`.

### 5.4 Bedrock Model Evaluation

Evaluate models or your whole GenAI pipeline.

- **Automatic evaluation** — choose a task (summarization, Q&A, text classification, text generation) and a dataset (built-in or custom). Metrics: accuracy, robustness, toxicity, BLEU, ROUGE, Exact Match, BERTScore.
- **Human evaluation** — bring your own workforce or use AWS-managed workforce; reviewers rate/rank outputs.
- **LLM-as-a-judge** evaluation — use another LLM to grade responses against criteria.
- **RAG evaluation** — evaluate Knowledge Base end-to-end (retrieval precision, response correctness, context relevance, etc.).

### 5.5 Model Customization

- **Fine-tuning** — labeled (prompt, completion) pairs; teaches the model a task or style.
- **Continued pretraining** — unlabeled domain text; adapts vocabulary and knowledge (e.g., medical, legal).
- **Model Distillation** — train a small student model (Nova, Claude Haiku, Llama) to mimic a larger teacher's responses on your prompts.
- Training data lives in S3. Custom models are your private assets — not shared with other customers.
- Most custom models require **Provisioned Throughput** to serve.
- Available on a subset of models — check the docs; commonly Titan, Nova, Llama, Claude (customization support expanding).

### 5.6 Bedrock Prompt Management

- Versioned, reusable prompt templates with variables.
- Compare versions; tie to specific models and inference parameters.
- Used inside **Flows** and by your applications.

### 5.7 Bedrock Flows (Prompt Flows)

- **Visual workflow builder** that orchestrates prompts, KBs, agents, Lambdas, conditions, and simple logic.
- Lower barrier than Step Functions for GenAI orchestration.
- Great for multi-step generative workflows — e.g., extract data → classify → summarize → route.

### Also worth knowing:
- **Bedrock Studio** — a web UI (within IAM Identity Center) where non-developers can build GenAI apps using KBs, Agents, Guardrails.
- **PartyRock** — AWS's playground for experimenting with Bedrock-powered apps (not an enterprise service but exam-relevant).

---

## 6. Data Protection & Privacy in Bedrock

Memorize these points — they show up repeatedly:

1. **Your data is not used to train the base FMs.**
2. **Your prompts and completions stay in your AWS account and selected region.**
3. **Model invocation logging** (optional) can send prompts + responses to CloudWatch Logs or S3 for audit/training-data collection; off by default.
4. **KMS** — Bedrock encrypts data at rest; you can choose customer-managed keys (CMK).
5. **PrivateLink / VPC endpoints** — you can call Bedrock APIs privately without traversing the public internet.
6. **IAM** — fine-grained permissions (e.g., allow `bedrock:InvokeModel` only on `anthropic.claude-3-haiku-*`).
7. **Service control policies (SCPs)** at the org level can restrict model access.
8. **CloudTrail** logs every Bedrock API call for audit.
9. **AWS PrivateLink** for cross-account / cross-VPC.
10. **Guardrails** provide content and PII protection.

---

## 7. Observability

- **CloudWatch Metrics** — invocation count, latency, tokens in/out, throttles.
- **CloudWatch Logs** — model invocation logs (prompts, responses, metadata).
- **CloudTrail** — API call records.
- **S3** — optional destination for model invocation logs and batch outputs.

---

## 8. Common Bedrock Architecture Patterns

### Pattern A — Plain Q&A / Writing Assistant
App → Converse API → FM → Response.

### Pattern B — RAG
```
User ─▶ App ─▶ Bedrock KB (embed query → vector search)
                   │
                   ▼
              Top-K chunks + user query
                   │
                   ▼
                  FM (Claude / Nova)
                   │
                   ▼
             Answer + citations ─▶ User
```

### Pattern C — Agent
```
User ─▶ Agent ─▶ plan → call Action Group (Lambda → internal API)
                          call Knowledge Base
                          apply Guardrail
                          iterate → final answer
```

### Pattern D — Enterprise Chat (Amazon Q Business)
```
User ─▶ Q Business ─▶ Connectors → your data
                       permissions enforced per doc
                       FM → grounded answer with citations
```

### Pattern E — Batch
Files in S3 → Bedrock batch job → results in S3 (50% discount).

---

## 9. Bedrock vs SageMaker vs Q — Reinforcement

| If you need to… | Use |
|-----------------|-----|
| Consume a pretrained FM via API | **Bedrock** |
| Build your own ML model (tabular, CV, NLP) | **SageMaker** |
| Give employees an enterprise AI chat grounded in company data | **Amazon Q Business** |
| Speed up coding in IDE / CLI | **Amazon Q Developer** |
| Natural-language BI in dashboards | **Amazon Q in QuickSight** |
| Live agent assistance in contact center | **Amazon Q in Connect** |
| Build a GenAI app with RAG quickly | **Bedrock Knowledge Bases** |
| Automate multi-step actions with tool use | **Bedrock Agents** |
| Enforce GenAI safety | **Bedrock Guardrails** |
| Compare FMs for your use case | **Bedrock Model Evaluation** |

---

## 10. Exam Gotchas

- Bedrock is **regional** — a model available in us-east-1 may not be in us-west-2.
- You must **request model access** before calling a model.
- **Custom models need provisioned throughput** (usually) — you cannot serve them on-demand on most providers.
- **Data is not used to train the foundation models** — repeat this.
- **Guardrails are not "all-or-nothing"** — you enable specific filters; each has strength levels.
- Bedrock is **not** used to build models from scratch — that's SageMaker.
- **Agents + Knowledge Bases** can be combined — an agent can query a KB as one of its tools.
- **Bedrock is HIPAA-eligible** (most models) under a BAA.

> Next — [2.4 Prompt Engineering](./04-Prompt-Engineering.md)
