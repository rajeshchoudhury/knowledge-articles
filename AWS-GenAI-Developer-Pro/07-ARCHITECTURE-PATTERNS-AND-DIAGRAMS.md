# 07 — Architecture Patterns & Diagrams for AWS GenAI (AIP-C01)

> **Purpose**: Visual reference of every major architecture pattern tested on the
> AWS Certified Generative AI Developer – Professional exam. Each pattern includes
> an ASCII diagram, service list, when-to-use guidance, and exam tips.

---

## Table of Contents

| # | Pattern | Jump |
|---|---------|------|
| 1 | Basic RAG | [→](#1-basic-rag-architecture) |
| 2 | Advanced RAG with Reranking | [→](#2-advanced-rag-with-reranking) |
| 3 | Agentic AI | [→](#3-agentic-ai-architecture) |
| 4 | Multi-Agent System | [→](#4-multi-agent-system) |
| 5 | Bedrock Knowledge Base Pipeline | [→](#5-bedrock-knowledge-base-pipeline) |
| 6 | GenAI Gateway | [→](#6-genai-gateway-architecture) |
| 7 | Defense-in-Depth Security | [→](#7-defense-in-depth-security) |
| 8 | CI/CD Pipeline for GenAI | [→](#8-cicd-pipeline-for-genai) |
| 9 | Streaming Response | [→](#9-streaming-response-architecture) |
| 10 | Enterprise Integration | [→](#10-enterprise-integration-pattern) |
| 11 | Vector Store Decision Matrix | [→](#11-vector-store-decision-matrix) |
| 12 | Model Selection & Routing | [→](#12-model-selection-and-routing) |
| 13 | Cost Optimization | [→](#13-cost-optimization-architecture) |
| 14 | Monitoring & Observability | [→](#14-monitoring-and-observability-stack) |
| 15 | Human-in-the-Loop | [→](#15-human-in-the-loop-pattern) |
| 16 | Cross-Region Resilience | [→](#16-cross-region-resilience) |
| 17 | MCP (Model Context Protocol) | [→](#17-mcp-model-context-protocol-architecture) |
| 18 | Fine-tuning vs RAG Decision Tree | [→](#18-fine-tuning-vs-rag-decision-tree) |
| 19 | Prompt Chaining | [→](#19-prompt-chaining-architecture) |
| 20 | Data Processing Pipeline | [→](#20-data-processing-pipeline-for-fm-consumption) |

---

## 1. Basic RAG Architecture

```
 ┌──────────┐
 │   User   │
 └────┬─────┘
      │ 1. Query
      ▼
 ┌──────────────┐   2. Embed query   ┌─────────────────────┐
 │  Amazon API  │ ─────────────────► │  Amazon Bedrock     │
 │  Gateway     │                    │  Embedding Model    │
 └──────┬───────┘                    │  (Titan / Cohere)   │
        │                            └──────────┬──────────┘
        │                                       │ 3. Query vector
        │                                       ▼
        │                            ┌─────────────────────┐
        │                            │  Vector Store        │
        │                            │  ┌─────────────────┐ │
        │                            │  │ OpenSearch       │ │
        │                            │  │ Serverless       │ │
        │                            │  └─────────────────┘ │
        │                            └──────────┬──────────┘
        │                                       │ 4. Top-K chunks
        │                                       ▼
        │  5. Query + Context        ┌─────────────────────┐
        │ ─────────────────────────► │  Amazon Bedrock     │
        │                            │  Foundation Model   │
        │                            │  (Claude / Llama)   │
        │                            └──────────┬──────────┘
        │                                       │ 6. Generated answer
        ▼                                       ▼
 ┌──────────────┐                    ┌─────────────────────┐
 │   Response   │ ◄──────────────── │  AWS Lambda         │
 │   to User    │                    │  (Orchestrator)     │
 └──────────────┘                    └─────────────────────┘

 Data Ingestion (offline):
 ┌────────┐  docs  ┌────────────┐  chunks  ┌───────────┐  vectors  ┌──────────┐
 │  S3    │ ─────► │  Lambda /  │ ───────► │  Bedrock  │ ────────► │ Vector   │
 │ Bucket │        │  Glue      │          │  Embed    │           │ Store    │
 └────────┘        └────────────┘          └───────────┘           └──────────┘
```

### When to Use
- Adding **domain-specific knowledge** to an FM without fine-tuning.
- Documents change frequently and retraining is impractical.
- Need factual, grounded, and citation-backed answers.

### AWS Services
| Service | Role |
|---------|------|
| Amazon Bedrock | Embedding + FM inference |
| OpenSearch Serverless | Vector store (k-NN) |
| Amazon S3 | Document storage |
| AWS Lambda | Orchestration logic |
| API Gateway | HTTP endpoint |

### Key Considerations
- **Chunk size** affects retrieval precision — 256-512 tokens is a common starting point.
- **Top-K** tuning: too few chunks = missing context; too many = noise and token waste.
- Embedding model and FM must be chosen as a pair (consistency matters).

### Exam Relevance
- RAG is the **#1 tested pattern** on AIP-C01.
- Know the difference between retrieval quality (embedding + vector search) vs generation quality (FM + prompt).
- Understand that RAG keeps the FM **stateless** — no model modification needed.

---

## 2. Advanced RAG with Reranking

```
 ┌──────────┐
 │   User   │
 └────┬─────┘
      │ Query: "How do I configure VPC peering?"
      ▼
 ┌─────────────────┐
 │  Query Expansion │  ◄── Generate sub-queries / synonyms
 │  (Bedrock FM)    │      "VPC peering setup", "VPC networking"
 └───────┬─────────┘
         │ Multiple query variants
         ▼
 ┌─────────────────────────────────────────────────┐
 │              Parallel Vector Searches             │
 │  ┌──────────┐  ┌──────────┐  ┌──────────────┐   │
 │  │ Semantic  │  │ Keyword  │  │ Hybrid       │   │
 │  │ (k-NN)   │  │ (BM25)   │  │ (Weighted)   │   │
 │  └────┬─────┘  └────┬─────┘  └──────┬───────┘   │
 │       │              │               │            │
 │       └──────────────┴───────────────┘            │
 │                      │                            │
 └──────────────────────┼────────────────────────────┘
                        │ Merged candidate set (e.g., 50 chunks)
                        ▼
              ┌───────────────────┐
              │  Bedrock Reranker │
              │  (Cohere Rerank / │
              │   Bedrock Rerank) │
              └────────┬──────────┘
                       │ Re-scored Top-5 chunks
                       ▼
              ┌───────────────────┐
              │  Bedrock FM       │
              │  Prompt:          │
              │  System + Context │
              │  + User Query     │
              └────────┬──────────┘
                       │ Grounded answer
                       ▼
              ┌───────────────────┐
              │  Response + Cites │
              └───────────────────┘
```

### When to Use
- Basic RAG returns **irrelevant or noisy** results.
- Queries are ambiguous or multi-faceted.
- High-stakes use cases where precision matters (medical, legal, finance).

### AWS Services
| Service | Role |
|---------|------|
| Amazon Bedrock (FM) | Query expansion + final generation |
| Amazon Bedrock (Reranker) | Cross-encoder reranking |
| OpenSearch Serverless | Hybrid search (semantic + keyword) |
| Amazon S3 | Source documents |

### Key Considerations
- **Reranking adds latency** — only rerank when retrieval quality is insufficient.
- Hybrid search (semantic + BM25) outperforms pure semantic on keyword-heavy domains.
- Query expansion can use a lightweight FM call or rule-based synonyms.

### Exam Relevance
- Know that **reranking is a cross-encoder** approach (query-document pairs scored together).
- Understand hybrid search = combining vector similarity with keyword relevance.
- Bedrock Knowledge Bases support reranking natively.

---

## 3. Agentic AI Architecture

```
                         ┌──────────────────────────────────────┐
                         │        Amazon Bedrock Agent           │
                         │                                      │
  ┌──────────┐   Task    │  ┌────────────────────────────────┐  │
  │   User   │ ────────► │  │   ReAct Loop (Reasoning +     │  │
  └──────────┘           │  │   Acting)                      │  │
                         │  │                                │  │
                         │  │  ┌──────────┐                  │  │
                         │  │  │ THOUGHT  │ "I need to look  │  │
                         │  │  │          │  up the order"   │  │
                         │  │  └────┬─────┘                  │  │
                         │  │       │                        │  │
                         │  │       ▼                        │  │
                         │  │  ┌──────────┐                  │  │
                         │  │  │  ACTION  │ Call OrderLookup │  │
                         │  │  │          │  API             │  │
                         │  │  └────┬─────┘                  │  │
                         │  │       │                        │  │
                         │  │       ▼                        │  │
                         │  │  ┌──────────────┐              │  │
                         │  │  │ OBSERVATION  │ Order #123:  │  │
                         │  │  │              │ Shipped       │  │
                         │  │  └──────┬───────┘              │  │
                         │  │         │                      │  │
                         │  │         ▼                      │  │
                         │  │  ┌──────────┐                  │  │
                         │  │  │ THOUGHT  │ "I have the info │  │
                         │  │  │          │  to respond"     │  │
                         │  │  └────┬─────┘                  │  │
                         │  │       │                        │  │
                         │  │       ▼                        │  │
                         │  │  ┌──────────┐                  │  │
                         │  │  │  ANSWER  │ Final response   │  │
                         │  │  └──────────┘                  │  │
                         │  └────────────────────────────────┘  │
                         │                                      │
                         │  Connected Resources:                │
                         │  ┌──────────────┐ ┌──────────────┐   │
                         │  │ Action Group │ │ Knowledge    │   │
                         │  │ (Lambda)     │ │ Base (RAG)   │   │
                         │  └──────┬───────┘ └──────┬───────┘   │
                         └─────────┼────────────────┼───────────┘
                                   │                │
                    ┌──────────────┼────────────────┼──────────────┐
                    │              ▼                ▼              │
                    │  ┌────────────────┐  ┌───────────────────┐  │
                    │  │  External APIs │  │  OpenSearch /     │  │
                    │  │  (REST/Lambda) │  │  Vector Store     │  │
                    │  └────────────────┘  └───────────────────┘  │
                    │           External Tool Ecosystem            │
                    └─────────────────────────────────────────────┘
```

### When to Use
- Tasks require **multi-step reasoning** and external tool invocation.
- User queries cannot be answered by a single FM call.
- Need to interact with APIs, databases, or other systems dynamically.

### AWS Services
| Service | Role |
|---------|------|
| Bedrock Agents | Agent runtime (ReAct loop) |
| AWS Lambda | Action group execution |
| Bedrock Knowledge Bases | Grounded retrieval |
| Amazon S3 / DynamoDB | Persistent state |
| CloudWatch | Agent trace logging |

### Key Considerations
- Agents follow **ReAct** (Reasoning + Acting) — Thought → Action → Observation loop.
- Action Groups define the **API schema** (OpenAPI spec) the agent can invoke.
- **Session state** persists within a session; use DynamoDB for cross-session memory.
- Guardrails can be attached to agents for safety.

### Exam Relevance
- Understand the **ReAct trace** — exam may show a trace and ask what happens next.
- Action Groups = Lambda functions with OpenAPI schemas.
- Knowledge Bases give agents RAG capability.
- Know that agents select tools autonomously (no hard-coded flow).

---

## 4. Multi-Agent System

```
 ┌──────────┐
 │   User   │
 └────┬─────┘
      │ Complex task: "Plan my trip and book flights"
      ▼
 ┌────────────────────────────────────────────────────────┐
 │               Orchestrator / Supervisor Agent           │
 │              (Bedrock Agent or Strands Agent)           │
 │                                                        │
 │  ┌─────────────────────────────────────────────────┐   │
 │  │            Task Decomposition                    │   │
 │  │  Sub-task 1: Research destinations               │   │
 │  │  Sub-task 2: Find flights                        │   │
 │  │  Sub-task 3: Book and confirm                    │   │
 │  └──────────┬──────────────┬──────────────┬────────┘   │
 │             │              │              │             │
 └─────────────┼──────────────┼──────────────┼─────────────┘
               │              │              │
      ┌────────▼──────┐ ┌────▼────────┐ ┌───▼──────────┐
      │  Research      │ │  Flight     │ │  Booking     │
      │  Agent         │ │  Search     │ │  Agent       │
      │                │ │  Agent      │ │              │
      │ ┌────────────┐ │ │ ┌─────────┐│ │ ┌──────────┐ │
      │ │ Knowledge  │ │ │ │ Airline ││ │ │ Payment  │ │
      │ │ Base       │ │ │ │ API     ││ │ │ API      │ │
      │ └────────────┘ │ │ └─────────┘│ │ └──────────┘ │
      │ ┌────────────┐ │ │ ┌─────────┐│ │ ┌──────────┐ │
      │ │ Web Search │ │ │ │ Price   ││ │ │ Email    │ │
      │ │ Tool       │ │ │ │ Compare ││ │ │ Service  │ │
      │ └────────────┘ │ │ └─────────┘│ │ └──────────┘ │
      └────────────────┘ └────────────┘ └──────────────┘

 Patterns:
 ┌──────────────────────────────────────────────────────┐
 │  Supervisor: Orchestrator delegates & merges results │
 │  Swarm:      Agents hand off to each other directly  │
 │  Parallel:   Independent agents run concurrently     │
 └──────────────────────────────────────────────────────┘
```

### When to Use
- Single agent lacks the **breadth of tools** or specialization needed.
- Tasks naturally decompose into independent sub-tasks.
- Different sub-tasks need different FMs or tool sets.

### AWS Services
| Service | Role |
|---------|------|
| Amazon Bedrock Agents | Individual agent runtime |
| Strands Agents SDK | Open-source multi-agent orchestration |
| AWS Agent Squad | Multi-agent collaboration framework |
| AWS Lambda | Tool execution per agent |
| Amazon SQS / Step Functions | Inter-agent messaging |

### Key Considerations
- **Supervisor pattern**: one agent controls others — simpler, more predictable.
- **Swarm pattern**: agents self-organize — more flexible, harder to debug.
- Keep agent responsibilities **narrow and well-defined**.
- Use Step Functions for complex orchestration with error handling.

### Exam Relevance
- Know Strands Agents SDK as the AWS open-source agent framework.
- Understand supervisor vs swarm topologies.
- Multi-agent is tested in "design a system that…" scenario questions.

---

## 5. Bedrock Knowledge Base Pipeline

```
 ┌─────────────────────────────────────────────────────────────────┐
 │                     DATA INGESTION PIPELINE                     │
 │                                                                 │
 │  ┌──────────┐    ┌───────────────────┐    ┌─────────────────┐  │
 │  │  Data     │    │  Bedrock KB       │    │  Chunking       │  │
 │  │  Sources  │───►│  Ingestion Job    │───►│  Strategy       │  │
 │  │          │    │                   │    │                 │  │
 │  │ • S3     │    │  • Crawl source   │    │ • Fixed-size    │  │
 │  │ • Web    │    │  • Parse docs     │    │ • Semantic      │  │
 │  │ • Confl. │    │  • Extract text   │    │ • Hierarchical  │  │
 │  │ • Share  │    │                   │    │ • Custom Lambda │  │
 │  └──────────┘    └───────────────────┘    └────────┬────────┘  │
 │                                                     │           │
 │                                                     ▼           │
 │                                           ┌─────────────────┐  │
 │                                           │  Embedding Model │  │
 │                                           │  (Titan / Cohere)│  │
 │                                           └────────┬────────┘  │
 │                                                     │           │
 │                                                     ▼           │
 │  ┌─────────────────────────────────────────────────────────┐   │
 │  │                    Vector Store Options                   │   │
 │  │                                                           │   │
 │  │  ┌──────────────┐ ┌──────────────┐ ┌──────────────────┐ │   │
 │  │  │  OpenSearch   │ │  Aurora       │ │  Bedrock Managed │ │   │
 │  │  │  Serverless   │ │  pgvector     │ │  Vector Store    │ │   │
 │  │  │  (k-NN)       │ │  (PostgreSQL) │ │  (Zero-config)   │ │   │
 │  │  └──────────────┘ └──────────────┘ └──────────────────┘ │   │
 │  │  ┌──────────────┐ ┌──────────────┐                       │   │
 │  │  │  Pinecone     │ │  Redis OSS   │                       │   │
 │  │  │  (Managed)    │ │  (Cache+Vec) │                       │   │
 │  │  └──────────────┘ └──────────────┘                       │   │
 │  └─────────────────────────────────────────────────────────┘   │
 └─────────────────────────────────────────────────────────────────┘

 ┌─────────────────────────────────────────────────────────────────┐
 │                        QUERY FLOW                               │
 │                                                                 │
 │  User ──► Bedrock KB ──► Embed Query ──► Vector Search          │
 │                │                              │                  │
 │                │                              ▼                  │
 │                │                     Top-K Chunks + Metadata     │
 │                │                              │                  │
 │                │         ┌────────────────────┘                  │
 │                ▼         ▼                                       │
 │        FM Prompt = System + Retrieved Chunks + User Query       │
 │                          │                                       │
 │                          ▼                                       │
 │                   Grounded Response with Citations               │
 └─────────────────────────────────────────────────────────────────┘
```

### When to Use
- You want a **fully managed RAG pipeline** without building orchestration code.
- Need automatic sync when source data changes.
- Multiple data sources (S3, web crawlers, Confluence, SharePoint).

### AWS Services
| Service | Role |
|---------|------|
| Bedrock Knowledge Bases | End-to-end managed RAG |
| Amazon S3 | Primary data source |
| OpenSearch Serverless | Default vector store |
| Aurora PostgreSQL | pgvector alternative |
| Bedrock (Titan Embed) | Embedding generation |

### Key Considerations
- **Chunking strategy** is critical — semantic chunking preserves meaning better than fixed-size.
- Metadata filters enable scoped retrieval (e.g., filter by department, date).
- Bedrock managed vector store is simplest but least customizable.
- Ingestion jobs can be triggered on schedule or on-demand.

### Exam Relevance
- Know all supported data sources and vector store options.
- Understand chunking strategies and their trade-offs.
- Bedrock KB is the **default answer** for "simplest way to add RAG."

---

## 6. GenAI Gateway Architecture

```
 ┌────────┐  ┌────────┐  ┌────────┐
 │ App A  │  │ App B  │  │ App C  │
 └───┬────┘  └───┬────┘  └───┬────┘
     │           │           │
     └───────────┼───────────┘
                 │
                 ▼
 ┌──────────────────────────────────────────────────────┐
 │              API Gateway (REST / HTTP)                │
 │  ┌────────────────────────────────────────────────┐  │
 │  │  • API Keys / Usage Plans                      │  │
 │  │  • Rate Limiting & Throttling                  │  │
 │  │  • Request Validation                          │  │
 │  └────────────────────────────────────────────────┘  │
 └───────────────────────┬──────────────────────────────┘
                         │
                         ▼
 ┌──────────────────────────────────────────────────────┐
 │             Lambda — GenAI Gateway Logic              │
 │                                                      │
 │  ┌─────────────┐  ┌──────────────┐  ┌────────────┐  │
 │  │  Auth &     │  │  Logging &   │  │  Model     │  │
 │  │  Tenant     │  │  Audit       │  │  Router    │  │
 │  │  Isolation  │  │  (CloudWatch)│  │            │  │
 │  └─────────────┘  └──────────────┘  └─────┬──────┘  │
 │                                           │         │
 │  ┌─────────────┐  ┌──────────────┐        │         │
 │  │  Cost       │  │  Guardrails  │        │         │
 │  │  Tracking   │  │  Enforcement │        │         │
 │  │  (per-team) │  │              │        │         │
 │  └─────────────┘  └──────────────┘        │         │
 └───────────────────────────────────────────┼─────────┘
                                             │
                    ┌────────────────────────┬┘
                    │                        │
                    ▼                        ▼
         ┌──────────────────┐     ┌──────────────────┐
         │  Amazon Bedrock  │     │  Amazon SageMaker │
         │  (Managed FMs)   │     │  (Custom Models)  │
         └──────────────────┘     └──────────────────┘
```

### When to Use
- **Multiple teams** share FM access and you need centralized governance.
- Need per-team cost tracking, rate limiting, and audit logging.
- Routing between Bedrock and SageMaker based on request type.

### AWS Services
| Service | Role |
|---------|------|
| API Gateway | Entry point, throttling, API keys |
| AWS Lambda | Routing, auth, logging logic |
| Amazon Bedrock | Managed FM inference |
| Amazon SageMaker | Custom model endpoints |
| CloudWatch | Centralized logging |
| DynamoDB | Usage tracking, tenant config |

### Key Considerations
- Gateway pattern enables **model abstraction** — swap models without client changes.
- Implement **semantic caching** at the gateway layer to reduce costs.
- Use API Gateway usage plans for per-team quotas.
- Log all prompts and responses for compliance (with PII redaction).

### Exam Relevance
- Tested in "enterprise governance" scenarios.
- Know how to isolate tenants and track costs per business unit.
- Understand the role of API Gateway usage plans and API keys.

---

## 7. Defense-in-Depth Security

```
 ┌──────────┐
 │   User   │
 └────┬─────┘
      │
      ▼
 ┌──────────────────────────────────────────────────────────────┐
 │  LAYER 1: Perimeter                                          │
 │  ┌────────────────────────────────────────────────────────┐  │
 │  │  API Gateway + WAF + Cognito Authentication            │  │
 │  │  • DDoS protection  • JWT validation  • IP allowlist   │  │
 │  └────────────────────────────────────────────────────────┘  │
 └──────────────────────────┬───────────────────────────────────┘
                            ▼
 ┌──────────────────────────────────────────────────────────────┐
 │  LAYER 2: Input Validation                                   │
 │  ┌────────────────────────────────────────────────────────┐  │
 │  │  Lambda Pre-processing                                 │  │
 │  │  • Input sanitization     • Max token enforcement      │  │
 │  │  • PII detection (Comprehend)  • Schema validation     │  │
 │  └────────────────────────────────────────────────────────┘  │
 └──────────────────────────┬───────────────────────────────────┘
                            ▼
 ┌──────────────────────────────────────────────────────────────┐
 │  LAYER 3: Bedrock Guardrails (Input)                         │
 │  ┌────────────────────────────────────────────────────────┐  │
 │  │  • Content filters (hate, violence, sexual, insults)   │  │
 │  │  • Denied topics                                       │  │
 │  │  • Word/phrase filters                                 │  │
 │  │  • PII redaction (regex + ML detection)                │  │
 │  │  • Contextual grounding check                          │  │
 │  └────────────────────────────────────────────────────────┘  │
 └──────────────────────────┬───────────────────────────────────┘
                            ▼
 ┌──────────────────────────────────────────────────────────────┐
 │  LAYER 4: Foundation Model                                   │
 │  ┌────────────────────────────────────────────────────────┐  │
 │  │  Amazon Bedrock FM (Claude, Titan, etc.)               │  │
 │  │  • System prompt with safety instructions              │  │
 │  │  • Temperature / top-p constraints                     │  │
 │  └────────────────────────────────────────────────────────┘  │
 └──────────────────────────┬───────────────────────────────────┘
                            ▼
 ┌──────────────────────────────────────────────────────────────┐
 │  LAYER 5: Bedrock Guardrails (Output)                        │
 │  ┌────────────────────────────────────────────────────────┐  │
 │  │  • Same filters applied to model output                │  │
 │  │  • Hallucination check (grounding)                     │  │
 │  │  • PII re-check on generated text                      │  │
 │  └────────────────────────────────────────────────────────┘  │
 └──────────────────────────┬───────────────────────────────────┘
                            ▼
 ┌──────────────────────────────────────────────────────────────┐
 │  LAYER 6: Output Validation                                  │
 │  ┌────────────────────────────────────────────────────────┐  │
 │  │  Lambda Post-processing                                │  │
 │  │  • Response format validation  • Citation verification │  │
 │  │  • Business rule checks        • Logging & audit       │  │
 │  └────────────────────────────────────────────────────────┘  │
 └──────────────────────────┬───────────────────────────────────┘
                            ▼
                     ┌──────────────┐
                     │  Safe Output │
                     │  to User     │
                     └──────────────┘
```

### When to Use
- **Every production GenAI application** should implement defense-in-depth.
- Regulated industries (healthcare, finance) with strict compliance requirements.
- Customer-facing applications where prompt injection is a risk.

### AWS Services
| Service | Role |
|---------|------|
| Bedrock Guardrails | Content filtering, PII, grounding |
| Amazon Comprehend | PII / entity detection |
| AWS WAF | DDoS, SQL injection protection |
| Amazon Cognito | User authentication |
| CloudWatch / CloudTrail | Audit logging |

### Key Considerations
- Guardrails apply to **both input and output** — configure both directions.
- PII detection supports both **regex patterns** and **ML-based detection**.
- Contextual grounding checks require a grounding source (retrieval context).
- Defense-in-depth means no single layer is solely responsible for safety.

### Exam Relevance
- **Heavily tested** — know all Guardrails filter categories.
- Understand that Guardrails can be applied to any Bedrock API call (not just agents).
- Know the difference between content filters (severity levels) and denied topics (custom).

---

## 8. CI/CD Pipeline for GenAI

```
 ┌──────────┐     ┌──────────────┐     ┌─────────────────┐
 │Developer │────►│ CodeCommit / │────►│  CodePipeline    │
 │ (Git     │     │ GitHub       │     │  (Orchestrator)  │
 │  push)   │     └──────────────┘     └────────┬────────┘
 └──────────┘                                   │
                                                │
         ┌──────────────────────────────────────┼──────────┐
         │                                      │          │
         ▼                                      ▼          ▼
 ┌───────────────┐  ┌─────────────────┐  ┌──────────────────┐
 │  BUILD Stage  │  │  TEST Stage     │  │  DEPLOY Stage    │
 │  (CodeBuild)  │  │  (CodeBuild)    │  │                  │
 │               │  │                 │  │                  │
 │ • Package     │  │ • Unit tests    │  │ • CloudFormation │
 │   Lambda      │  │ • Prompt tests  │  │   / CDK deploy   │
 │ • Validate    │  │ • RAG eval      │  │ • Canary deploy  │
 │   prompts     │  │   (RAGAS)       │  │ • Alias switch   │
 │ • Lint IaC    │  │ • Guardrail     │  │                  │
 │               │  │   tests         │  │                  │
 └───────────────┘  │ • Integration   │  └────────┬─────────┘
                    │   tests         │           │
                    │ • Cost estimate │           │
                    └─────────────────┘           │
                                                  ▼
                                      ┌────────────────────┐
                                      │  MONITOR Stage     │
                                      │                    │
                                      │ • CloudWatch       │
                                      │   metrics          │
                                      │ • Model invocation │
                                      │   logs             │
                                      │ • Human eval       │
                                      │   sampling         │
                                      │ • Drift detection  │
                                      └────────┬───────────┘
                                               │
                                               ▼
                                      ┌────────────────────┐
                                      │  FEEDBACK LOOP     │
                                      │                    │
                                      │ • Collect user     │
                                      │   feedback         │
                                      │ • Update eval      │
                                      │   datasets         │
                                      │ • Retrigger        │
                                      │   pipeline         │
                                      └────────────────────┘
```

### When to Use
- Any production GenAI application that evolves over time.
- Teams managing prompt versions, RAG configurations, or fine-tuned models.
- Need automated quality gates before deploying prompt or model changes.

### AWS Services
| Service | Role |
|---------|------|
| CodePipeline | Pipeline orchestration |
| CodeBuild | Build and test execution |
| CloudFormation / CDK | Infrastructure deployment |
| Amazon Bedrock | Model invocation in tests |
| CloudWatch | Production monitoring |
| S3 | Artifact and eval dataset storage |

### Key Considerations
- **Prompt testing** should include: accuracy, hallucination rate, toxicity, latency, and cost.
- Use **RAGAS** or **Bedrock evaluation jobs** for automated RAG quality scoring.
- Canary deployments let you route a small % of traffic to the new version first.
- Store prompts in version control alongside application code.

### Exam Relevance
- Know that GenAI CI/CD includes **prompt evaluation** as a first-class test stage.
- Understand Bedrock model evaluation jobs (automatic and human-based).
- Deployment strategies: canary, blue-green, alias-based.

---

## 9. Streaming Response Architecture

```
                    WEBSOCKET PATTERN
 ┌──────────┐                              ┌──────────────┐
 │  Client  │ ◄── WebSocket Connection ──► │  API Gateway │
 │  (React) │                              │  (WebSocket) │
 └──────────┘                              └──────┬───────┘
      ▲                                           │
      │ Chunked                                   │ $connect / $default
      │ tokens                                    ▼
      │                                    ┌──────────────┐
      │                                    │   Lambda      │
      │                                    │  (Connection  │
      │                                    │   Manager)    │
      │                                    └──────┬───────┘
      │                                           │
      │                                           ▼
      │                                    ┌──────────────┐
      │                                    │  Bedrock     │
      │                                    │  InvokeModel │
      │                                    │  WithResponse│
      │                                    │  Stream      │
      └────────────────────────────────────┤              │
               Server pushes chunks        │  ─► chunk 1  │
               back over WebSocket         │  ─► chunk 2  │
                                           │  ─► chunk 3  │
                                           │  ─► ...      │
                                           │  ─► [DONE]   │
                                           └──────────────┘

                   HTTP SSE PATTERN
 ┌──────────┐    POST /chat         ┌──────────────┐
 │  Client  │ ──────────────────►   │  API Gateway  │
 │          │                       │  (HTTP API)   │
 │          │ ◄── SSE stream ────   └──────┬───────┘
 │          │   Transfer-Encoding:          │
 │          │   chunked                     ▼
 └──────────┘                       ┌──────────────┐
                                    │  Lambda       │
                                    │  (Streaming   │
                                    │   Response    │
                                    │   URL)        │
                                    └──────┬───────┘
                                           │
                                           ▼
                                    ┌──────────────┐
                                    │  Bedrock     │
                                    │  Converse    │
                                    │  Stream API  │
                                    └──────────────┘
```

### When to Use
- Chat / conversational applications where **time-to-first-token** matters.
- Long-form generation where users expect progressive rendering.
- Any user-facing FM application — streaming dramatically improves perceived latency.

### AWS Services
| Service | Role |
|---------|------|
| API Gateway (WebSocket) | Persistent bi-directional connection |
| API Gateway (HTTP) | SSE / chunked transfer |
| Lambda (Streaming) | Function URL with response streaming |
| Bedrock ConverseStream | Streaming FM invocation |
| DynamoDB | Connection ID tracking (WebSocket) |

### Key Considerations
- **Lambda response streaming** uses Function URLs — different from standard Lambda invocations.
- `ConverseStream` returns chunks with `contentBlockDelta` events.
- WebSocket is better for multi-turn chat; HTTP SSE is simpler for single requests.
- Guardrails can still apply to streaming responses (buffer-based evaluation).

### Exam Relevance
- Know the difference between `InvokeModelWithResponseStream` and `ConverseStream`.
- Understand that streaming reduces **perceived** latency, not actual generation time.
- Lambda Function URLs enable response streaming beyond the 6 MB payload limit.

---

## 10. Enterprise Integration Pattern

```
 ┌─────────────────────────────────────────────────────────────────┐
 │                      EXISTING ENTERPRISE SYSTEMS                │
 │                                                                 │
 │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌───────────────┐  │
 │  │  CRM     │  │  ERP     │  │  ITSM    │  │  Custom App   │  │
 │  │ (Salesf) │  │ (SAP)    │  │ (Service │  │  (Legacy)     │  │
 │  │          │  │          │  │  Now)     │  │               │  │
 │  └────┬─────┘  └────┬─────┘  └────┬─────┘  └──────┬────────┘  │
 │       │              │             │               │           │
 └───────┼──────────────┼─────────────┼───────────────┼───────────┘
         │              │             │               │
         │ Events       │ Events      │ Events        │ Events
         ▼              ▼             ▼               ▼
 ┌──────────────────────────────────────────────────────────────┐
 │                  Amazon EventBridge                           │
 │                                                              │
 │  Rules:                                                      │
 │  • "ticket.created"  → Route to GenAI summarizer             │
 │  • "order.completed" → Route to GenAI recommendation engine  │
 │  • "doc.updated"     → Route to KB re-indexer                │
 └──────────────────────┬───────────────────────────────────────┘
                        │
           ┌────────────┼────────────┐
           │            │            │
           ▼            ▼            ▼
 ┌──────────────┐ ┌──────────┐ ┌────────────────┐
 │  Lambda:     │ │ Lambda:  │ │  Lambda:       │
 │  Summarize   │ │ Recommend│ │  Re-index KB   │
 │  Ticket      │ │ Products │ │                │
 └──────┬───────┘ └────┬─────┘ └───────┬────────┘
        │               │              │
        ▼               ▼              ▼
 ┌──────────────────────────────────────────────┐
 │            Amazon Bedrock                     │
 │  ┌──────────┐  ┌──────────┐  ┌────────────┐ │
 │  │ Claude   │  │ Titan    │  │ Embed +    │ │
 │  │ (Summ.)  │  │ (Reco.)  │  │ KB Sync    │ │
 │  └────┬─────┘  └────┬─────┘  └────────────┘ │
 └───────┼──────────────┼───────────────────────┘
         │              │
         ▼              ▼
 ┌──────────────┐ ┌──────────────┐
 │ Write back   │ │ Write back   │
 │ to ITSM      │ │ to CRM       │
 │ (API call)   │ │ (API call)   │
 └──────────────┘ └──────────────┘
```

### When to Use
- Adding GenAI to **existing enterprise workflows** without rewriting them.
- Event-driven architectures where GenAI is one consumer among many.
- Loose coupling between legacy systems and AI capabilities.

### AWS Services
| Service | Role |
|---------|------|
| Amazon EventBridge | Event bus and routing |
| AWS Lambda | Event processing and FM invocation |
| Amazon Bedrock | FM inference |
| Step Functions | Complex multi-step workflows |
| AppFlow | SaaS data connectors |
| SQS / SNS | Decoupling and fan-out |

### Key Considerations
- **Event-driven** = loosely coupled — GenAI services can scale independently.
- Use **dead-letter queues** (DLQ) for failed FM invocations.
- Implement **idempotency** — events may be delivered more than once.
- Consider async patterns for non-real-time use cases (batch processing).

### Exam Relevance
- EventBridge is the preferred **integration glue** in AWS architecture.
- Know when to use synchronous (API Gateway) vs asynchronous (EventBridge) patterns.
- Understand loose coupling and its benefits for maintainability.

---

## 11. Vector Store Decision Matrix

```
                    ┌─────────────────────────┐
                    │  Need a Vector Store?    │
                    └────────────┬─────────────┘
                                 │
                    ┌────────────▼─────────────┐
                    │ Managed by Bedrock KB?    │
                    │ (Simplest setup)          │
                    └──┬─────────────────────┬──┘
                   YES │                     │ NO (need control)
                       ▼                     ▼
          ┌─────────────────────┐   ┌──────────────────────┐
          │ Bedrock Managed     │   │ Which workload?      │
          │ Vector Store        │   └──┬──────────┬────────┘
          │                     │      │          │
          │ • Zero config       │      │          │
          │ • Auto-scaling      │      │          │
          │ • No infra to mgmt  │      ▼          ▼
          │ • Limited customiz. │   Full-text  Already have
          └─────────────────────┘   + vector?  PostgreSQL?
                                       │          │
                                       ▼          ▼
                              ┌──────────┐  ┌──────────────┐
                              │OpenSearch │  │ Aurora        │
                              │Serverless │  │ pgvector      │
                              └──────────┘  └──────────────┘

 ┌──────────────────────────────────────────────────────────────────────┐
 │                    COMPARISON MATRIX                                  │
 ├──────────────┬─────────────┬───────────┬────────────┬───────────────┤
 │  Feature     │ OpenSearch  │ Aurora    │ Bedrock    │ Pinecone      │
 │              │ Serverless  │ pgvector  │ Managed    │               │
 ├──────────────┼─────────────┼───────────┼────────────┼───────────────┤
 │ Setup        │ Medium      │ Medium    │ Zero       │ Medium        │
 │ Hybrid search│ YES (BM25   │ Limited   │ No         │ Yes           │
 │              │  + k-NN)    │           │            │               │
 │ Scale        │ Auto        │ Manual    │ Auto       │ Auto          │
 │ Metadata     │ Rich        │ SQL-based │ Basic      │ Rich          │
 │  filtering   │ filtering   │ filtering │ filtering  │ filtering     │
 │ Cost         │ $$          │ $         │ $          │ $$$           │
 │ Max dims     │ 16,000      │ 2,000     │ 1,536      │ 20,000        │
 │ Algorithms   │ HNSW, IVF   │ IVFFlat,  │ HNSW       │ Proprietary   │
 │              │ FAISS       │ HNSW      │            │               │
 │ AWS native   │ Yes         │ Yes       │ Yes        │ No (partner)  │
 └──────────────┴─────────────┴───────────┴────────────┴───────────────┘
```

### Decision Rules

| Situation | Best Choice |
|-----------|-------------|
| Simplest possible setup | Bedrock Managed Vector Store |
| Need hybrid (keyword + semantic) search | OpenSearch Serverless |
| Already running Aurora PostgreSQL | Aurora pgvector (add extension) |
| Need rich metadata filtering | OpenSearch Serverless |
| Budget-constrained, small scale | Aurora pgvector |
| Already using Pinecone | Pinecone (supported by Bedrock KB) |

### Exam Relevance
- Exam tests **when to choose** each vector store, not how to configure them.
- OpenSearch Serverless is the **default** for most exam answers.
- Know that pgvector is a PostgreSQL extension (not a standalone service).
- Bedrock managed store = least operational overhead.

---

## 12. Model Selection and Routing

```
 ┌──────────┐
 │  Request  │
 └─────┬────┘
       │
       ▼
 ┌───────────────────────┐
 │  Query Classifier      │
 │  (Lightweight FM or    │
 │   rule-based)          │
 └───────┬───────────────┘
         │
         ├── Simple (FAQ, greetings)
         │        │
         │        ▼
         │   ┌────────────────────────┐
         │   │  TIER 1: Small Model   │
         │   │  • Haiku / Titan Lite  │     Cost: $
         │   │  • Fast, cheap         │     Latency: Low
         │   │  • < 100 tokens out    │
         │   └────────────────────────┘
         │
         ├── Medium (summarization, Q&A)
         │        │
         │        ▼
         │   ┌────────────────────────┐
         │   │  TIER 2: Medium Model  │
         │   │  • Sonnet / Titan      │     Cost: $$
         │   │  • Balanced            │     Latency: Medium
         │   │  • 100-1000 tokens out │
         │   └────────────────────────┘
         │
         └── Complex (analysis, code, reasoning)
                  │
                  ▼
             ┌────────────────────────┐
             │  TIER 3: Large Model   │
             │  • Opus / Llama 70B    │     Cost: $$$
             │  • Most capable        │     Latency: High
             │  • > 1000 tokens out   │
             └────────────────────────┘

 ┌──────────────────────────────────────────────────────────┐
 │  ROUTING LOGIC (Lambda)                                  │
 │                                                          │
 │  if complexity == "simple":                              │
 │      model = "anthropic.claude-3-haiku"                  │
 │  elif complexity == "medium":                            │
 │      model = "anthropic.claude-3-5-sonnet"               │
 │  elif complexity == "complex":                           │
 │      model = "anthropic.claude-3-opus"                   │
 │                                                          │
 │  response = bedrock.invoke_model(modelId=model, ...)     │
 └──────────────────────────────────────────────────────────┘
```

### When to Use
- Workloads with **highly variable query complexity**.
- Need to optimize cost without sacrificing quality for hard queries.
- High-volume applications where most queries are simple.

### AWS Services
| Service | Role |
|---------|------|
| Amazon Bedrock | Multiple FM access |
| AWS Lambda | Classification and routing |
| CloudWatch | Per-model metrics |
| Bedrock Cross-Region Inference | Fallback routing |

### Key Considerations
- Classifier must be **cheaper** than the cheapest model tier to be cost-effective.
- Use a **fallback chain**: if Tier 1 confidence is low, escalate to Tier 2.
- Monitor per-tier quality metrics to validate routing accuracy.
- Bedrock model IDs follow the pattern `provider.model-name-version`.

### Exam Relevance
- Tested in "cost optimization" scenarios.
- Know the Claude model hierarchy: Haiku (fast/cheap) → Sonnet (balanced) → Opus (powerful).
- Understand inference profiles and cross-region inference for availability.

---

## 13. Cost Optimization Architecture

```
 ┌──────────┐
 │  Request  │
 └────┬─────┘
      │
      ▼
 ┌─────────────────────────────────────────┐
 │  LAYER 1: Semantic Cache (ElastiCache)  │
 │                                         │
 │  Embed query → Search cache → Hit?      │
 │  ┌─────────┐                            │
 │  │ HIT ✓   │──► Return cached response  │  Cost: ~$0
 │  └─────────┘                            │
 │  ┌─────────┐                            │
 │  │ MISS ✗  │──► Continue to next layer  │
 │  └─────────┘                            │
 └──────────────────┬──────────────────────┘
                    │
                    ▼
 ┌─────────────────────────────────────────┐
 │  LAYER 2: Model Router                  │
 │                                         │
 │  Classify complexity → Route to tier    │
 │  Simple  → Haiku      ($0.25/M tokens)  │
 │  Medium  → Sonnet     ($3.00/M tokens)  │
 │  Complex → Opus       ($15.0/M tokens)  │
 └──────────────────┬──────────────────────┘
                    │
                    ▼
 ┌─────────────────────────────────────────┐
 │  LAYER 3: Prompt Optimization           │
 │                                         │
 │  • Prompt compression                   │
 │  • Context window management            │
 │  • System prompt caching (Bedrock)      │
 │  • Max token limits                     │
 └──────────────────┬──────────────────────┘
                    │
                    ▼
 ┌─────────────────────────────────────────┐
 │  LAYER 4: Batch Processing              │
 │                                         │
 │  Non-real-time requests:                │
 │  ┌────────┐    ┌──────────────────┐     │
 │  │  SQS   │───►│ Bedrock Batch    │     │  Up to 50%
 │  │ Queue  │    │ Inference        │     │  cost reduction
 │  └────────┘    └──────────────────┘     │
 └──────────────────┬──────────────────────┘
                    │
                    ▼
 ┌─────────────────────────────────────────┐
 │  LAYER 5: Monitoring & Budgets          │
 │                                         │
 │  ┌──────────┐  ┌───────────┐            │
 │  │CloudWatch│  │ AWS       │            │
 │  │ Metrics  │  │ Budgets   │            │
 │  └──────────┘  └───────────┘            │
 │  • Token usage per model                │
 │  • Cost per request                     │
 │  • Budget alerts                        │
 └─────────────────────────────────────────┘
```

### When to Use
- **Every production GenAI application** — cost optimization is never optional at scale.
- High-volume applications where similar queries recur frequently.
- Budget-conscious organizations or teams with allocation limits.

### AWS Services
| Service | Role |
|---------|------|
| Amazon ElastiCache | Semantic cache store |
| Amazon Bedrock | FM inference + batch API |
| Amazon SQS | Batch job queuing |
| AWS Budgets | Cost alerts |
| CloudWatch | Usage metrics |

### Key Considerations
- **Prompt caching** in Bedrock caches system prompts — major savings for repeated system prompts.
- **Batch inference** gives up to 50% discount for non-real-time workloads.
- Semantic cache similarity threshold affects cache hit rate vs accuracy trade-off.
- Provisioned Throughput for predictable, high-volume workloads.

### Exam Relevance
- Know all cost levers: model selection, caching, batching, prompt optimization.
- Understand Bedrock pricing model: per input token + per output token.
- Provisioned Throughput vs On-Demand pricing.
- Prompt caching is a newer feature — high exam relevance.

---

## 14. Monitoring and Observability Stack

```
 ┌─────────────────────────────────────────────────────────────────┐
 │                    APPLICATION LAYER                             │
 │                                                                 │
 │  ┌─────────┐  ┌────────────┐  ┌──────────────┐                │
 │  │ API GW  │  │ Lambda     │  │ Bedrock      │                │
 │  │         │  │            │  │ InvokeModel  │                │
 │  └────┬────┘  └─────┬──────┘  └──────┬───────┘                │
 │       │             │                │                          │
 └───────┼─────────────┼────────────────┼──────────────────────────┘
         │             │                │
         ▼             ▼                ▼
 ┌─────────────────────────────────────────────────────────────────┐
 │                   DATA COLLECTION LAYER                         │
 │                                                                 │
 │  ┌──────────────────┐  ┌──────────────────────────────────┐    │
 │  │  CloudWatch Logs  │  │  Bedrock Model Invocation Logs   │    │
 │  │                   │  │                                  │    │
 │  │  • API GW access  │  │  • Input/output tokens          │    │
 │  │  • Lambda logs    │  │  • Latency per call             │    │
 │  │  • Custom metrics │  │  • Model ID used                │    │
 │  └────────┬──────────┘  │  • Full prompt + response       │    │
 │           │             │    (if enabled)                  │    │
 │           │             └──────────────┬───────────────────┘    │
 │           │                            │                        │
 │  ┌────────┴──────────┐  ┌─────────────┴────────────────┐       │
 │  │  AWS X-Ray        │  │  CloudTrail                   │       │
 │  │                   │  │                               │       │
 │  │  • End-to-end     │  │  • API call audit trail       │       │
 │  │    trace          │  │  • Who called what model      │       │
 │  │  • Latency map    │  │  • IAM identity tracking      │       │
 │  │  • Service graph  │  │                               │       │
 │  └────────┬──────────┘  └──────────────┬────────────────┘       │
 └───────────┼────────────────────────────┼────────────────────────┘
             │                            │
             ▼                            ▼
 ┌─────────────────────────────────────────────────────────────────┐
 │                   ANALYSIS & ALERTING LAYER                     │
 │                                                                 │
 │  ┌───────────────────┐  ┌────────────────┐  ┌───────────────┐  │
 │  │ CloudWatch        │  │ CloudWatch     │  │  SNS          │  │
 │  │ Dashboards        │  │ Alarms         │  │  Alerts       │  │
 │  │                   │  │                │  │               │  │
 │  │ • Token usage     │  │ • Latency >5s  │  │ • PagerDuty   │  │
 │  │ • Error rates     │  │ • Error rate   │  │ • Slack       │  │
 │  │ • Cost tracking   │  │   > threshold  │  │ • Email       │  │
 │  │ • Model compare   │  │ • Throttling   │  │               │  │
 │  └───────────────────┘  └────────────────┘  └───────────────┘  │
 │                                                                 │
 │  ┌───────────────────────────────────────────────────────────┐  │
 │  │  Custom GenAI Metrics (embedded in application)           │  │
 │  │  • Hallucination rate    • User satisfaction (thumbs)     │  │
 │  │  • Retrieval relevance   • Guardrail intervention rate    │  │
 │  │  • Citation accuracy     • Prompt token efficiency        │  │
 │  └───────────────────────────────────────────────────────────┘  │
 └─────────────────────────────────────────────────────────────────┘
```

### When to Use
- **Every production GenAI system** — monitoring is non-negotiable.
- Need to track model performance, costs, and safety metrics.
- Debugging latency issues or unexpected model behavior.

### AWS Services
| Service | Role |
|---------|------|
| CloudWatch Logs | Centralized logging |
| CloudWatch Metrics | Custom + built-in metrics |
| AWS X-Ray | Distributed tracing |
| CloudTrail | API audit trail |
| SNS | Alert delivery |
| S3 | Log archival, model invocation log destination |

### Key Considerations
- **Model invocation logging** must be explicitly enabled in Bedrock settings.
- Logs can go to S3 (full prompt/response) or CloudWatch (metadata only).
- X-Ray traces show end-to-end latency breakdown across Lambda → Bedrock.
- Custom metrics for GenAI quality (hallucination, relevance) must be built.

### Exam Relevance
- Know how to enable and configure **model invocation logging**.
- Understand what CloudTrail captures (API calls) vs CloudWatch (metrics/logs).
- X-Ray for latency debugging in multi-service chains.
- Model invocation logs can be stored in S3 or CloudWatch Logs.

---

## 15. Human-in-the-Loop Pattern

```
 ┌──────────┐
 │   User   │
 └────┬─────┘
      │ Request
      ▼
 ┌─────────────────┐
 │  Amazon Bedrock  │
 │  FM Invocation   │
 └────────┬────────┘
          │ Generated output
          ▼
 ┌────────────────────────────────────────────────────────┐
 │              CONFIDENCE ASSESSMENT                      │
 │                                                        │
 │  ┌──────────────────────────────────────────────────┐  │
 │  │  Evaluate:                                       │  │
 │  │  • Model confidence score                        │  │
 │  │  • Guardrail flags                               │  │
 │  │  • Business rule validation                      │  │
 │  │  • Retrieval relevance score                     │  │
 │  └──────────────────┬───────────────────────────────┘  │
 │                     │                                   │
 └─────────────────────┼───────────────────────────────────┘
                       │
          ┌────────────┴─────────────┐
          │                          │
    HIGH CONFIDENCE            LOW CONFIDENCE
    (Score > threshold)        (Score ≤ threshold)
          │                          │
          ▼                          ▼
 ┌─────────────────┐     ┌───────────────────────────────┐
 │  AUTO-APPROVE   │     │  Amazon A2I                    │
 │                 │     │  (Augmented AI)                │
 │  Direct output  │     │                               │
 │  to user        │     │  ┌─────────────────────────┐  │
 └─────────────────┘     │  │  Human Review Workflow   │  │
                         │  │                         │  │
                         │  │  • SageMaker workforce  │  │
                         │  │    (private / Mechanical│  │
                         │  │     Turk / vendor)      │  │
                         │  │  • Custom review UI     │  │
                         │  │  • Approve / Edit /     │  │
                         │  │    Reject               │  │
                         │  └───────────┬─────────────┘  │
                         └──────────────┼────────────────┘
                                        │
                                        ▼
                              ┌──────────────────┐
                              │  Final Output    │
                              │  (Human-reviewed) │
                              └──────────────────┘
                                        │
                                        ▼
                              ┌──────────────────┐
                              │  Feedback Loop   │
                              │  Store correction │
                              │  for model eval  │
                              └──────────────────┘
```

### When to Use
- High-stakes decisions: medical advice, legal recommendations, financial actions.
- Low-confidence outputs that need expert validation.
- Building a **feedback dataset** for model evaluation and fine-tuning.

### AWS Services
| Service | Role |
|---------|------|
| Amazon A2I | Human review workflow management |
| SageMaker Ground Truth | Labeling and review workforce |
| Amazon Bedrock | FM inference |
| Step Functions | Orchestrate auto/manual paths |
| S3 | Store review results and feedback |

### Key Considerations
- Define a **clear confidence threshold** — too low = everything auto-approved; too high = human bottleneck.
- A2I supports private teams, Amazon Mechanical Turk, and third-party vendors.
- Human review results feed back into evaluation datasets.
- Balance cost of human review vs risk of incorrect AI output.

### Exam Relevance
- A2I is the go-to service for human review workflows.
- Know the three workforce options: private, MTurk, vendor-managed.
- Understand confidence-based routing (auto-approve vs human review).
- Human feedback loops improve future model evaluations.

---

## 16. Cross-Region Resilience

```
 ┌──────────┐
 │  Client  │
 └────┬─────┘
      │
      ▼
 ┌──────────────────┐
 │  Route 53        │
 │  (DNS Routing)   │
 │  Health-checked  │
 └───┬──────────┬───┘
     │          │
     │ Primary  │ Failover
     ▼          ▼
 ┌────────────────────┐      ┌────────────────────┐
 │  US-EAST-1          │      │  US-WEST-2          │
 │  (Primary)          │      │  (Secondary)        │
 │                     │      │                     │
 │ ┌────────────────┐  │      │ ┌────────────────┐  │
 │ │ API Gateway    │  │      │ │ API Gateway    │  │
 │ └───────┬────────┘  │      │ └───────┬────────┘  │
 │         ▼           │      │         ▼           │
 │ ┌────────────────┐  │      │ ┌────────────────┐  │
 │ │ Lambda         │  │      │ │ Lambda         │  │
 │ └───────┬────────┘  │      │ └───────┬────────┘  │
 │         ▼           │      │         ▼           │
 │ ┌────────────────┐  │      │ ┌────────────────┐  │
 │ │ Bedrock        │  │      │ │ Bedrock        │  │
 │ │ (Claude, etc.) │  │      │ │ (Claude, etc.) │  │
 │ └────────────────┘  │      │ └────────────────┘  │
 └────────────────────┘      └────────────────────┘

 ┌──────────────────────────────────────────────────────────────┐
 │  BEDROCK CROSS-REGION INFERENCE (Simpler alternative)        │
 │                                                              │
 │  ┌──────────┐                                                │
 │  │  Client  │                                                │
 │  └────┬─────┘                                                │
 │       │                                                      │
 │       ▼                                                      │
 │  ┌─────────────────────────────┐                             │
 │  │  Bedrock Inference Profile  │                             │
 │  │  (Cross-Region enabled)     │                             │
 │  └─────────┬───────────────────┘                             │
 │            │                                                 │
 │            │ Bedrock automatically routes                    │
 │            │ to available region                             │
 │            ▼                                                 │
 │  ┌──────────┐  ┌──────────┐  ┌──────────┐                   │
 │  │us-east-1 │  │us-west-2 │  │eu-west-1 │                   │
 │  │ (Model)  │  │ (Model)  │  │ (Model)  │                   │
 │  └──────────┘  └──────────┘  └──────────┘                   │
 └──────────────────────────────────────────────────────────────┘
```

### When to Use
- Applications requiring **high availability** (99.99%+).
- Handling **regional capacity constraints** during peak load.
- Regulatory requirements for data residency with failover.

### AWS Services
| Service | Role |
|---------|------|
| Bedrock Inference Profiles | Cross-region routing (managed) |
| Route 53 | DNS-based failover |
| API Gateway | Regional endpoints |
| DynamoDB Global Tables | Cross-region state replication |
| S3 Cross-Region Replication | Document store replication |

### Key Considerations
- **Bedrock Cross-Region Inference** is the simplest approach — single API, Bedrock handles routing.
- Inference profiles define which regions are eligible for your requests.
- Full multi-region requires replicating vector stores, caches, and state.
- Cross-region inference uses the same model ID — no code changes needed.

### Exam Relevance
- Know inference profiles and how cross-region inference works.
- Understand that not all models are available in all regions.
- Cross-region inference is preferred over DIY multi-region for most exam scenarios.
- Know that inference profiles are specified via an ARN, not a model ID.

---

## 17. MCP (Model Context Protocol) Architecture

```
 ┌───────────────────────────────────────────────────────────────────┐
 │                        MCP ARCHITECTURE                           │
 │                                                                   │
 │  ┌──────────────────┐                                             │
 │  │  AI Agent         │                                             │
 │  │  (Bedrock Agent / │                                             │
 │  │   Strands Agent)  │                                             │
 │  └────────┬─────────┘                                             │
 │           │                                                       │
 │           ▼                                                       │
 │  ┌──────────────────┐     JSON-RPC over         ┌──────────────┐ │
 │  │  MCP Client      │ ◄═══════════════════════► │  MCP Server  │ │
 │  │  (Built into     │     stdio / SSE / HTTP     │              │ │
 │  │   agent runtime) │                            │  Exposes:    │ │
 │  └──────────────────┘                            │  • Tools     │ │
 │                                                  │  • Resources │ │
 │           MCP Protocol Messages:                 │  • Prompts   │ │
 │           ─────────────────────                  └──────┬───────┘ │
 │           • tools/list                                  │         │
 │           • tools/call                                  │         │
 │           • resources/read                              │         │
 │           • prompts/get                                 │         │
 └─────────────────────────────────────────────────────────┼─────────┘
                                                           │
                                  ┌────────────────────────┼────────┐
                                  │                        │        │
                                  ▼                        ▼        ▼
                         ┌──────────────┐       ┌────────┐  ┌──────────┐
                         │  External    │       │  DB    │  │  APIs    │
                         │  Services    │       │        │  │          │
                         └──────────────┘       └────────┘  └──────────┘

 ┌──────────────────────────────────────────────────────────────────┐
 │  AWS DEPLOYMENT PATTERNS FOR MCP SERVERS                         │
 │                                                                  │
 │  Pattern 1: Lambda-based (Serverless)                            │
 │  ┌──────────┐    ┌──────────────┐    ┌──────────────────┐       │
 │  │  Agent   │───►│  API Gateway │───►│  Lambda          │       │
 │  │          │    │  (HTTP)      │    │  (MCP Server)    │       │
 │  └──────────┘    └──────────────┘    └──────────────────┘       │
 │                                                                  │
 │  Pattern 2: ECS-based (Long-running)                             │
 │  ┌──────────┐    ┌──────────────┐    ┌──────────────────┐       │
 │  │  Agent   │───►│  ALB         │───►│  ECS Fargate     │       │
 │  │          │    │              │    │  (MCP Server)    │       │
 │  └──────────┘    └──────────────┘    └──────────────────┘       │
 │                                                                  │
 │  Pattern 3: Local (Development)                                  │
 │  ┌──────────┐    ┌──────────────────────────────────┐            │
 │  │  Agent   │───►│  Local process (stdio transport) │            │
 │  └──────────┘    └──────────────────────────────────┘            │
 └──────────────────────────────────────────────────────────────────┘
```

### When to Use
- Need a **standardized interface** for agents to access tools and resources.
- Building reusable tool servers that multiple agents can share.
- Integrating agents with existing systems via a universal protocol.

### AWS Services
| Service | Role |
|---------|------|
| AWS Lambda | Serverless MCP server |
| Amazon ECS Fargate | Long-running MCP server |
| API Gateway / ALB | MCP server endpoint |
| Bedrock Agents / Strands | MCP client runtime |
| IAM | MCP server access control |

### Key Considerations
- MCP defines three primitives: **Tools** (callable), **Resources** (readable), **Prompts** (templates).
- Transport options: **stdio** (local), **SSE** (server-sent events), **Streamable HTTP**.
- Lambda is ideal for stateless, low-latency MCP servers.
- ECS is better for stateful MCP servers or those needing persistent connections.

### Exam Relevance
- MCP is a newer protocol — expect conceptual questions.
- Understand the Client ↔ Server relationship and JSON-RPC protocol.
- Know the three MCP primitives: Tools, Resources, Prompts.
- Understand transport options and when to use each.

---

## 18. Fine-tuning vs RAG Decision Tree

```
 ┌─────────────────────────────────────────┐
 │  Do you need the model to use           │
 │  SPECIFIC KNOWLEDGE not in its training?│
 └──────────────────┬──────────────────────┘
                    │
          ┌─────────┴─────────┐
         YES                  NO
          │                    │
          ▼                    ▼
 ┌─────────────────┐  ┌─────────────────────────────┐
 │ Does the data   │  │  Do you need to change the   │
 │ change          │  │  model's STYLE, TONE, or     │
 │ frequently?     │  │  FORMAT?                     │
 └────────┬────────┘  └──────────────┬──────────────┘
          │                          │
    ┌─────┴─────┐              ┌─────┴──────┐
   YES          NO            YES           NO
    │            │              │             │
    ▼            ▼              ▼             ▼
 ┌───────┐  ┌───────────┐  ┌───────────┐  ┌──────────────────┐
 │  RAG  │  │ How much   │  │ FINE-TUNE │  │  Prompt          │
 │       │  │ data do    │  │           │  │  Engineering     │
 │       │  │ you have?  │  │           │  │  (No training    │
 └───────┘  └─────┬──────┘  └───────────┘  │   needed)        │
                  │                         └──────────────────┘
           ┌──────┴──────┐
       < 1000          > 1000
        examples       examples
           │              │
           ▼              ▼
      ┌───────────┐  ┌────────────┐
      │ RAG or    │  │ FINE-TUNE  │
      │ Few-shot  │  │ or         │
      │ Prompting │  │ Continued  │
      └───────────┘  │ Pre-train  │
                     └────────────┘

 ┌──────────────────────────────────────────────────────────────────┐
 │  COMPARISON SUMMARY                                              │
 ├──────────────────┬────────────────────┬──────────────────────────┤
 │  Dimension       │  RAG               │  Fine-tuning             │
 ├──────────────────┼────────────────────┼──────────────────────────┤
 │  Data freshness  │  Real-time         │  Static (training time)  │
 │  Setup cost      │  Low-Medium        │  High                    │
 │  Running cost    │  Higher per-query  │  Lower per-query         │
 │  Data needed     │  Any amount        │  Hundreds to thousands   │
 │  Transparency    │  High (citations)  │  Low (black box)         │
 │  Hallucination   │  Lower (grounded)  │  Can still hallucinate   │
 │  Style change    │  Limited           │  Excellent               │
 │  Domain adapt.   │  Good              │  Excellent               │
 │  Maintenance     │  Update docs       │  Retrain model           │
 └──────────────────┴────────────────────┴──────────────────────────┘

 Note: RAG + Fine-tuning can be COMBINED for best results.
```

### When to Use RAG
- Knowledge base changes frequently.
- Need traceable, citation-backed answers.
- Cannot afford fine-tuning compute costs.
- Small or medium data volume.

### When to Use Fine-tuning
- Need consistent style, format, or tone changes.
- Have 1,000+ high-quality labeled examples.
- Running cost must be minimized at scale.
- Task is narrow and well-defined.

### Exam Relevance
- **Heavily tested decision point** — expect 3-5 questions on this.
- Default to RAG unless the question specifically describes style/format needs.
- Know that continued pre-training is for **domain vocabulary** (not specific tasks).
- Fine-tuning in Bedrock uses **Custom Model Import** or **Bedrock Fine-tuning Jobs**.

---

## 19. Prompt Chaining Architecture

```
 ┌──────────────────────────────────────────────────────────────────┐
 │                  BEDROCK PROMPT FLOWS                             │
 │                                                                  │
 │  ┌────────┐                                                      │
 │  │ Input  │                                                      │
 │  │ Node   │                                                      │
 │  └───┬────┘                                                      │
 │      │                                                           │
 │      ▼                                                           │
 │  ┌──────────────────┐                                            │
 │  │ PROMPT NODE 1    │  "Classify this customer inquiry:          │
 │  │ (Classification) │   {{input}}"                               │
 │  └────────┬─────────┘                                            │
 │           │  Output: { "category": "refund", "urgency": "high" } │
 │           │                                                      │
 │           ▼                                                      │
 │  ┌──────────────────┐                                            │
 │  │ CONDITION NODE   │                                            │
 │  │                  │                                            │
 │  │ if category ==   │                                            │
 │  │   "refund"       │                                            │
 │  └──┬──────────┬────┘                                            │
 │     │          │                                                 │
 │  TRUE       FALSE                                                │
 │     │          │                                                 │
 │     ▼          ▼                                                 │
 │  ┌──────────┐ ┌──────────────┐                                   │
 │  │PROMPT 2a │ │ PROMPT 2b    │                                   │
 │  │(Refund   │ │ (General     │                                   │
 │  │ Policy)  │ │  Response)   │                                   │
 │  └────┬─────┘ └──────┬───────┘                                   │
 │       │              │                                           │
 │       └──────┬───────┘                                           │
 │              │                                                   │
 │              ▼                                                   │
 │  ┌──────────────────┐                                            │
 │  │ PROMPT NODE 3    │  "Given this draft response, make it       │
 │  │ (Quality Check)  │   empathetic and professional: {{draft}}"  │
 │  └────────┬─────────┘                                            │
 │           │                                                      │
 │           ▼                                                      │
 │  ┌──────────────────┐                                            │
 │  │  GUARDRAIL NODE  │  Check output safety                       │
 │  └────────┬─────────┘                                            │
 │           │                                                      │
 │           ▼                                                      │
 │  ┌────────────┐                                                  │
 │  │ Output     │                                                  │
 │  │ Node       │                                                  │
 │  └────────────┘                                                  │
 └──────────────────────────────────────────────────────────────────┘

 Node Types Available in Prompt Flows:
 ┌──────────────────────────────────────────────────────────┐
 │  • Input          — Entry point                          │
 │  • Prompt         — FM invocation with template          │
 │  • Condition      — Branch based on output               │
 │  • Knowledge Base — RAG retrieval                        │
 │  • Lambda         — Custom code execution                │
 │  • Lex            — Conversational intent detection      │
 │  • Iterator       — Loop over collections                │
 │  • Collector      — Aggregate iterator results           │
 │  • S3 Storage     — Read/write data                      │
 │  • Output         — Return final result                  │
 └──────────────────────────────────────────────────────────┘
```

### When to Use
- Complex tasks that benefit from **decomposition** into sequential steps.
- Need conditional logic between FM calls (classification → action).
- Quality assurance requires a **validation prompt** after generation.

### AWS Services
| Service | Role |
|---------|------|
| Bedrock Prompt Flows | Visual chain orchestration |
| Bedrock Prompt Management | Version-controlled prompt templates |
| AWS Lambda | Custom logic nodes |
| Amazon Lex | Intent classification nodes |
| Bedrock Guardrails | Safety check nodes |

### Key Considerations
- Each node can use a **different model** — optimize cost per step.
- Prompt Flows are **versioned** — safe rollback if quality degrades.
- Use the **iterator node** for batch processing within a flow.
- Variables from earlier nodes can be referenced with `{{node_name.output}}`.

### Exam Relevance
- Know the available **node types** in Prompt Flows.
- Understand that Prompt Flows ≠ Step Functions (Prompt Flows are Bedrock-native).
- Prompt Management stores prompt versions separately from flow definitions.
- Conditional nodes enable branching logic without custom code.

---

## 20. Data Processing Pipeline for FM Consumption

```
 ┌──────────────────────────────────────────────────────────────────┐
 │                   RAW DATA SOURCES                               │
 │                                                                  │
 │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌───────────────┐   │
 │  │  PDFs    │  │  HTML    │  │  DBs     │  │  APIs         │   │
 │  │  (S3)    │  │  (Web)   │  │ (RDS)    │  │  (REST/Graph) │   │
 │  └────┬─────┘  └────┬─────┘  └────┬─────┘  └──────┬────────┘   │
 └───────┼──────────────┼─────────────┼───────────────┼────────────┘
         │              │             │               │
         └──────────────┼─────────────┼───────────────┘
                        │             │
                        ▼             ▼
 ┌──────────────────────────────────────────────────────────────────┐
 │  STAGE 1: EXTRACTION                                             │
 │                                                                  │
 │  ┌──────────────────┐  ┌────────────────────┐                    │
 │  │  AWS Glue        │  │  Amazon Textract   │                    │
 │  │  (Structured     │  │  (PDF / Image      │                    │
 │  │   data ETL)      │  │   text extraction) │                    │
 │  └────────┬─────────┘  └────────┬───────────┘                    │
 └───────────┼─────────────────────┼────────────────────────────────┘
             │                     │
             └──────────┬──────────┘
                        │
                        ▼
 ┌──────────────────────────────────────────────────────────────────┐
 │  STAGE 2: VALIDATION & CLEANING                                  │
 │                                                                  │
 │  ┌──────────────────────────────────────────────────────────┐    │
 │  │  Lambda Functions:                                       │    │
 │  │  • Remove duplicates                                     │    │
 │  │  • Strip formatting artifacts                            │    │
 │  │  • Validate encoding (UTF-8)                             │    │
 │  │  • Detect and redact PII (Comprehend)                    │    │
 │  │  • Language detection and filtering                      │    │
 │  └──────────────────────────────────────────────────────────┘    │
 └──────────────────────────┬───────────────────────────────────────┘
                            │
                            ▼
 ┌──────────────────────────────────────────────────────────────────┐
 │  STAGE 3: TRANSFORMATION                                         │
 │                                                                  │
 │  ┌──────────────────────────────────────────────────────────┐    │
 │  │  AWS Glue / Lambda:                                      │    │
 │  │  • Chunk documents (fixed / semantic / hierarchical)     │    │
 │  │  • Add metadata (source, date, author, category)         │    │
 │  │  • Normalize formats → plain text / markdown             │    │
 │  │  • Generate summaries for long documents (FM call)       │    │
 │  └──────────────────────────────────────────────────────────┘    │
 └──────────────────────────┬───────────────────────────────────────┘
                            │
                            ▼
 ┌──────────────────────────────────────────────────────────────────┐
 │  STAGE 4: QUALITY CHECK                                          │
 │                                                                  │
 │  ┌──────────────────────────────────────────────────────────┐    │
 │  │  Automated Quality Gates:                                │    │
 │  │  • Minimum chunk length                                  │    │
 │  │  • Completeness check (no truncated sentences)           │    │
 │  │  • Embedding sanity check (cluster analysis)             │    │
 │  │  • Sample-based human review                             │    │
 │  └──────────────────────────────────────────────────────────┘    │
 └──────────────────────────┬───────────────────────────────────────┘
                            │
                            ▼
 ┌──────────────────────────────────────────────────────────────────┐
 │  STAGE 5: FM-READY OUTPUT                                        │
 │                                                                  │
 │  For RAG:                          For Fine-tuning:              │
 │  ┌────────────────────┐            ┌────────────────────┐        │
 │  │  S3 → Bedrock KB   │            │  S3 → JSONL format │        │
 │  │  (auto-embed +     │            │  {"prompt": "...", │        │
 │  │   index)           │            │   "completion":"…"}│        │
 │  └────────────────────┘            └────────────────────┘        │
 │                                                                  │
 │  For Prompting:                    For Evaluation:               │
 │  ┌────────────────────┐            ┌────────────────────┐        │
 │  │  Context-ready     │            │  Test dataset with │        │
 │  │  text blocks       │            │  ground truth      │        │
 │  └────────────────────┘            └────────────────────┘        │
 └──────────────────────────────────────────────────────────────────┘
```

### When to Use
- Building any RAG system — data quality determines retrieval quality.
- Preparing training data for fine-tuning or continued pre-training.
- Ingesting unstructured data from diverse enterprise sources.

### AWS Services
| Service | Role |
|---------|------|
| AWS Glue | ETL orchestration |
| Amazon Textract | PDF/image text extraction |
| Amazon Comprehend | PII detection, language detection |
| AWS Lambda | Custom transformation logic |
| Amazon S3 | Storage at every stage |
| Step Functions | Pipeline orchestration |
| Bedrock Knowledge Bases | Managed ingestion alternative |

### Key Considerations
- **Data quality > model quality** — garbage in, garbage out applies strongly to GenAI.
- Metadata enrichment enables **filtered retrieval** (e.g., "only docs from 2024").
- Textract handles scanned PDFs; regular parsing handles digital PDFs.
- Store intermediate results in S3 for debugging and reprocessing.

### Exam Relevance
- Know the role of Textract for document extraction.
- Understand that chunking is a pre-processing step, not a model concern.
- Comprehend for PII detection in data pipelines.
- JSONL format for fine-tuning datasets.

---

## Quick Reference: Pattern Selection Guide

```
 ┌─────────────────────────────────────────────────────────────────┐
 │                 WHICH PATTERN DO I NEED?                         │
 │                                                                 │
 │  "Add knowledge to FM"          → Pattern 1/2 (RAG)            │
 │  "FM needs to call APIs"        → Pattern 3 (Agentic)          │
 │  "Multiple specialized agents"  → Pattern 4 (Multi-Agent)      │
 │  "Simplest RAG possible"        → Pattern 5 (Bedrock KB)       │
 │  "Centralize FM access"         → Pattern 6 (Gateway)          │
 │  "Secure my GenAI app"          → Pattern 7 (Defense-in-Depth) │
 │  "Automate deployments"         → Pattern 8 (CI/CD)            │
 │  "Fast chat experience"         → Pattern 9 (Streaming)        │
 │  "Integrate with legacy"        → Pattern 10 (Enterprise)      │
 │  "Choose a vector store"        → Pattern 11 (Decision Matrix) │
 │  "Optimize model costs"         → Pattern 12/13 (Routing/Cost) │
 │  "Monitor GenAI in prod"        → Pattern 14 (Observability)   │
 │  "Human review for safety"      → Pattern 15 (HITL)            │
 │  "High availability"            → Pattern 16 (Cross-Region)    │
 │  "Standard tool interface"      → Pattern 17 (MCP)             │
 │  "Fine-tune or RAG?"            → Pattern 18 (Decision Tree)   │
 │  "Multi-step prompt logic"      → Pattern 19 (Prompt Chaining) │
 │  "Process docs for FM"          → Pattern 20 (Data Pipeline)   │
 └─────────────────────────────────────────────────────────────────┘
```

---

## Exam Day Cheat Sheet: Top Architecture Rules

1. **Default to RAG** over fine-tuning unless the question explicitly requires style/format change.
2. **Bedrock Knowledge Bases** = simplest managed RAG (exam's default "easy" answer).
3. **Guardrails go on both input AND output** — always configure both.
4. **OpenSearch Serverless** is the default vector store choice unless Aurora pgvector is already in use.
5. **Bedrock Agents use ReAct** — Thought → Action → Observation loop.
6. **Streaming** reduces perceived latency; use `ConverseStream` API.
7. **Cross-Region Inference** via inference profiles — no infrastructure to manage.
8. **Model invocation logging** must be explicitly enabled in Bedrock settings.
9. **EventBridge** is the preferred integration bus for enterprise patterns.
10. **Prompt Flows** for chaining; **Step Functions** for complex orchestration with error handling.
11. **A2I** for human-in-the-loop; supports private, MTurk, and vendor workforces.
12. **Semantic caching + model routing + batching** = the cost optimization trifecta.

---

*Last updated: April 2026 — Aligned with AIP-C01 exam guide v1.0*
