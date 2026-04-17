# 3.2 — Retrieval Augmented Generation (RAG)

RAG is the single most tested generative-AI architecture on the exam. Master it.

---

## 1. What and Why

**Problem**: LLMs have a training cutoff, don't know your private data, and hallucinate.

**Solution**: Retrieve relevant documents at query time and inject them into the prompt so the model answers from facts.

### Benefits
- Up-to-date knowledge without retraining.
- Grounded answers with **citations**.
- Works with private / proprietary data.
- Cheaper and faster than fine-tuning.
- Easy to update — just re-index.

### Limitations
- Only as good as the retrieval.
- Longer prompts → higher token cost & latency.
- Still hallucinates if retrieval fails or model ignores context.
- Requires governance on the document store (freshness, permissions, PII).

---

## 2. The Canonical RAG Flow

```
                 ┌───────────────┐
 [1] Ingest ───▶ │ Parse & chunk │───▶ Embed ───▶ Vector DB
                 └───────────────┘

 [2] User question ───▶ Embed ───▶ Vector similarity search ───▶ Top-K chunks
                                                                   │
                                                                   ▼
 [3] Prompt = system + context (chunks) + user_question ───▶ FM ───▶ Answer
                                                                   │
                                                                   ▼
                                                       Citations + guardrail check
```

### Phase A — Ingest / Index (offline)
1. **Load** documents (PDF, DOCX, HTML, Markdown, Confluence, SharePoint, Salesforce, web).
2. **Parse** — text extraction; keep metadata (source, page, date, permissions).
3. **Chunk** — split into smaller pieces (e.g., 300–1000 tokens with overlap).
4. **Embed** — send each chunk to an embedding model (Titan Embeddings V2, Cohere Embed).
5. **Store** vectors + metadata in a **vector database**.
6. Optionally index for **hybrid search** (BM25 + vector).

### Phase B — Query (online)
1. **Embed the question** with the same embedding model.
2. **Similarity search** (cosine / dot-product / Euclidean) against the vector DB.
3. Optional **rerank** with Cohere Rerank or a cross-encoder.
4. **Filter by metadata** (permissions, date, tenant, document type).
5. Build the prompt with system instructions + retrieved chunks + question.
6. Call the **FM**.
7. Return the answer with **citations**.
8. Optionally apply **Guardrails** (including contextual grounding check).

---

## 3. Chunking Strategies

Bedrock Knowledge Bases supports several out of the box:

| Strategy | How it works | Good for |
|----------|--------------|----------|
| **Fixed-size chunking** | Split every N tokens (with overlap) | Simple, works OK |
| **Hierarchical chunking** | Parent-child: retrieve small chunks for precision, return larger parent for context | Technical docs, code |
| **Semantic chunking** | Split at semantic boundaries (sentence embeddings cluster) | Prose, long-form |
| **No chunking** | Each file is one chunk | Short docs |
| **Custom (Lambda)** | Your own code | Specialized formats |

### Common parameters
- **Chunk size**: 256–1000 tokens typical.
- **Overlap**: 10–20% to avoid splitting mid-thought.
- **Metadata per chunk**: source URL, page, created_at, tenant_id, permission groups.

---

## 4. Vector Databases Supported by Bedrock Knowledge Bases

| Store | Use when |
|-------|----------|
| **Amazon OpenSearch Serverless** (default) | Out-of-box easy, scalable, hybrid search |
| **Amazon Aurora PostgreSQL** (pgvector) | You already run Postgres, want vectors near relational data |
| **Amazon Neptune Analytics** | Combine graph + vector |
| **Amazon OpenSearch Service (non-serverless)** | Existing cluster, full control |
| **Pinecone** | SaaS vector DB, easy |
| **Redis Enterprise Cloud** | Low-latency vector cache |
| **MongoDB Atlas** | You already use Atlas |

Choosing primarily depends on: existing investment, scale, cost, search sophistication.

---

## 5. Retrieval Techniques

- **Dense retrieval** — cosine similarity over embeddings (semantic search).
- **Sparse retrieval** — BM25 / keyword (lexical).
- **Hybrid search** — combine dense + sparse for better recall and precision.
- **Reranking** — second-stage scoring (Cohere Rerank or cross-encoder). Costs more but improves precision.
- **Query rewriting** — LLM rewrites the user question into better search queries (expanded, decomposed, hypothetical answer → HyDE).
- **Multi-query** — generate several query variations and union results.
- **Metadata filters** — must-match filters (tenant, language, date range, permissions).
- **MMR (Maximum Marginal Relevance)** — diversify results, avoid near-duplicates.

---

## 6. Prompt Template for RAG

```
System:
You are an expert assistant. Answer strictly from the CONTEXT.
If the CONTEXT does not contain the answer, say "I don't know."
Cite each factual claim with a [1], [2] reference to CONTEXT entries.

Context:
[1] {chunk_1}
[2] {chunk_2}
[3] {chunk_3}

Question:
{user_question}

Answer:
```

---

## 7. Bedrock Knowledge Bases — Concrete Capabilities

- **Data sources**: S3, Confluence, SharePoint, Salesforce, Web Crawler, Atlassian, custom connector.
- **Embedding models**: Titan Embeddings V2, Titan Multimodal Embeddings, Cohere Embed.
- **Vector stores**: the list above.
- **Chunking**: fixed, hierarchical, semantic, none, custom.
- **Parsing**: Amazon Bedrock's built-in parser; or **Foundation Model parsing** (use a multimodal LLM to parse complex PDFs with tables/images).
- **Metadata filtering** and **metadata.json** files to attach per-document metadata.
- **Sessions / multi-turn** via conversation state.
- **Citations** in the API response.
- **Multimodal KBs** (images + text).
- **Retrieve API** — returns chunks only (you compose the prompt).
- **RetrieveAndGenerate API** — full managed RAG: retrieval + FM call + answer + citations.
- **Can be attached to an Agent** as one of its tools.

---

## 8. Common RAG Pitfalls (and Fixes)

| Pitfall | Fix |
|---------|-----|
| Answers are generic / wrong | Retrieval is bad → inspect top-k; consider hybrid + rerank; tune chunk size |
| Out-of-date answers | Re-ingest more frequently; add freshness filter |
| Permission leaks (user sees docs they shouldn't) | Enforce **metadata filters** by user identity; use **Q Business** which does this natively |
| Too expensive | Smaller chunk count; smaller model; caching; shorter system prompt |
| Hallucination persists | Add **Guardrails > Contextual grounding check**; stronger system prompt; cite-or-abstain |
| Multilingual questions miss docs | Use a multilingual embedding (Cohere Embed multilingual) |
| Tables and figures lost | Use **FM parsing** or Textract |
| Duplicate / near-duplicate docs | Deduplicate; use MMR; metadata filters |

---

## 9. RAG Evaluation Metrics

**Retrieval metrics**
- Recall@K — did we retrieve the gold chunk in top-K?
- Precision@K — of retrieved, how many relevant?
- MRR (Mean Reciprocal Rank), NDCG.

**Generation metrics**
- **Faithfulness / groundedness** — does the answer follow from retrieved context?
- **Answer relevance** — does it answer the question?
- **Context relevance** — are retrieved chunks on-topic?
- **ROUGE / BLEU / BERTScore** for text overlap.
- **Human ratings** for tone, clarity.
- Bedrock **RAG Evaluation** covers these end-to-end.

---

## 10. When NOT to Use RAG

- Task is purely creative (no knowledge grounding needed).
- Data is extremely small (just put it in the prompt).
- You need persistent behavior change (style, format) → fine-tune.
- The model already knows it well enough.

---

## 11. RAG vs Fine-Tuning — Exam Framing

- "Answer questions using the latest internal policies that change weekly" → **RAG**.
- "We want the model to always respond like our HR team, even without context" → **Fine-tune**.
- "We need both fresh docs *and* a specific tone" → **RAG + Fine-tune**.

---

## 12. Example Reference Architecture (Bedrock KB + Agent)

```
┌─────────┐      ┌─────────────────────┐
│  User   │ ───▶ │  API Gateway        │
└─────────┘      │  + Lambda (frontend)│
                 └───────┬─────────────┘
                         │
                  InvokeAgent
                         ▼
                 ┌─────────────────────┐
                 │  Bedrock Agent      │
                 │  (ReAct planner)    │
                 └──┬────┬─────────────┘
                    │    │
          ┌─────────▼    ▼──────────┐
          │ Knowledge Base          │
          │ (OpenSearch Serverless) │
          └──┬──────────────────────┘
             ▼
     ┌───────────────┐      ┌─────────────┐
     │ S3 Documents  │      │ Action Group│
     └───────────────┘      │ (Lambda API)│
                            └─────────────┘
                            
  ┌─────────────────────┐
  │ Guardrail (PII,     │
  │ topics, grounding)  │
  └─────────────────────┘
```

> Next — [3.3 Fine-Tuning & Customization](./03-Fine-Tuning.md)
