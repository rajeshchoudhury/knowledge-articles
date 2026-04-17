# 2.1 — Generative AI Fundamentals

## 1. What is Generative AI?

**Generative AI** is a category of machine learning where models generate **new content** — text, images, audio, video, code, 3D, proteins — rather than classifying or predicting a single value.

### Capabilities typically asked on the exam

| Capability | Example |
|------------|---------|
| **Text generation** | Summaries, emails, stories, code |
| **Question answering** | Support chatbots, research assistants |
| **Translation** | English ↔ Japanese |
| **Code generation** | Complete a function, generate SQL |
| **Image generation** | Text-to-image (Stable Diffusion, Amazon Nova Canvas, Titan Image Generator) |
| **Audio generation** | Text-to-speech (Polly Generative, ElevenLabs), music |
| **Video generation** | Amazon Nova Reel, Sora-style |
| **Multimodal understanding** | Image + text → text (Claude, Nova, GPT-4V) |
| **Embedding** | Turn content into a vector for search / RAG |
| **Agents / tool use** | LLM calls external APIs to complete multistep tasks |

---

## 2. How Did We Get Here?

1. **2012 — Deep learning breakthrough** (AlexNet on ImageNet).
2. **2017 — "Attention Is All You Need"** — Transformer paper from Google.
3. **2018 — BERT** (Google) and **GPT-1** (OpenAI).
4. **2019-2020 — GPT-2, GPT-3** — the "it works at scale" moment.
5. **2022 — ChatGPT** — mainstream awareness; RLHF.
6. **2023 — GPT-4, Claude, Llama 2, Amazon Bedrock GA**.
7. **2024-2026 — Multimodal, long context, agents, open-source parity; Amazon Nova family**.

---

## 3. Core Concepts

### 3.1 Tokens
- Models process **tokens**, not characters or words.
- Typical ratio: ~4 chars ≈ 1 token in English; 100 tokens ≈ 75 words.
- **Billed** per input + output tokens (on-demand). Long context = more tokens = more cost and latency.
- **Tokenizer** is part of the model; different models split differently.

### 3.2 Context Window
- Maximum tokens (input + output) the model can consider per request.
- 2025 typical sizes:
  - Anthropic Claude 3.5/3.7 Sonnet: 200K
  - Anthropic Claude 4: 200K+
  - Amazon Nova Pro: 300K
  - Meta Llama 3.3 70B: 128K
  - Mistral Large 2: 128K
  - Cohere Command R+: 128K
- **Longer context** supports more RAG chunks, longer conversations, entire documents.

### 3.3 Embeddings
- Numerical vectors (e.g., 1024-dim floats) that encode semantic meaning.
- Similar meanings → closer vectors (cosine similarity).
- Used for:
  - **Semantic search** (find docs related to a query, not just matching keywords).
  - **Retrieval Augmented Generation (RAG)**.
  - **Clustering / classification** of text or images.
  - **Anomaly detection**.
- AWS embedding models:
  - **Amazon Titan Text Embeddings V2** — text embeddings up to 8K tokens, 1024 dims (configurable 256/512/1024).
  - **Amazon Titan Multimodal Embeddings** — shared space for text and images.
  - **Cohere Embed** — multilingual embeddings on Bedrock.

### 3.4 Parameters
- Learnable weights of the model.
- Modern sizes: 7B, 13B, 70B, 405B, 1T+.
- **Bigger ≠ always better.** Bigger models are usually more capable but slower and more expensive. Often a smaller, fine-tuned, or distilled model is the right choice.

### 3.5 Inference Parameters — Must Know

| Parameter | What it does | Range | Typical setting |
|-----------|--------------|-------|-----------------|
| **Temperature** | Higher = more random / creative; 0 = deterministic | 0.0–1.0 (often up to 2.0) | 0 for factual Q&A; 0.7 for creative writing |
| **Top-p (nucleus sampling)** | Sample from smallest set of tokens whose cumulative probability ≥ p | 0.0–1.0 | 0.9 |
| **Top-k** | Sample from the top k most likely tokens | 1+ | 40 |
| **Max tokens (max_tokens / max_output_tokens)** | Cap on output length | model-specific | Set explicitly |
| **Stop sequences** | Strings that terminate generation | string list | `"\n\n"`, `"Human:"` |
| **Frequency penalty** | Penalize tokens that have already appeared | -2 to 2 | 0 |
| **Presence penalty** | Penalize topics already mentioned | -2 to 2 | 0 |

Temperature and top-p should not generally be tweaked together — tune one.

---

## 4. Training a Foundation Model — Conceptual

### 4.1 Self-Supervised Pretraining
- Huge unlabeled corpus (web, books, code, papers).
- Objective: **predict the next token** given previous tokens.
- This is expensive and slow (tens to hundreds of millions of dollars).
- Produces the **base model** (also called "pretrained model").

### 4.2 Supervised Fine-Tuning (SFT)
- Curated (prompt, response) pairs.
- Teaches the model to follow instructions (hence "instruct" models).

### 4.3 Reinforcement Learning from Human Feedback (RLHF)
- Humans rank model outputs.
- Train a **reward model** on those rankings.
- Use PPO (or DPO / Constitutional AI / RLAIF) to align the base model toward preferred outputs.
- This is how models become "helpful, harmless, honest."

### 4.4 Alignment via Constitutional AI
- Anthropic's technique: model critiques and revises its own outputs against a set of principles ("constitution").

### 4.5 Model Distillation
- Train a small "student" model to mimic a big "teacher" model.
- Produces a cheaper, faster model that preserves most of the teacher's capability.
- Bedrock has **Model Distillation** as a managed feature.

---

## 5. Where Does the Risk Come From?

- **Hallucination** — model produces confident but wrong output.
- **Staleness** — knowledge cutoff; the model doesn't know what happened after training.
- **Bias** — training data inherits societal bias.
- **Prompt injection** — user input overrides system instructions.
- **Data leakage** — training data may be regurgitated.
- **Privacy** — PII in prompts or outputs.
- **Toxicity / harmful content**.
- **IP / copyright** — generated content may resemble copyrighted training data.
- **Cost overrun** — unbounded generation length.
- **Latency / availability** — cold starts, throughput limits.

These each get mitigated with RAG, guardrails, prompt design, evaluation, monitoring, and governance (covered in later domains).

---

## 6. Generative AI Project Lifecycle (GenAIOps)

A typical generative AI project follows:

```
1. Define use case & success criteria
     │
2. Select foundation model
     │
3. Iterate:
   a. Prompt engineering   ──┐
   b. RAG                    │ in order of
   c. Fine-tune              │ increasing cost
   d. Continued pretraining  │ and complexity
   e. Train from scratch  ──┘
     │
4. Evaluate (automatic + human)
     │
5. Apply guardrails + responsible AI review
     │
6. Deploy (on-demand, provisioned throughput, or batch)
     │
7. Monitor (usage, latency, cost, quality drift, safety)
```

**Rule of thumb** — always try prompt engineering first, then RAG, then fine-tuning. Only train from scratch if you must (regulatory, very specialized domain, and you have the data + budget).

---

## 7. Multimodal

A model that handles multiple input or output modalities (text + image, text + audio, etc.).

- **Vision language models (VLMs)**: Claude 3/3.5/4, Amazon Nova Lite/Pro, Llama 3.2 Vision.
- **Image generation**: Amazon Nova Canvas, Titan Image Generator, Stable Diffusion XL, Stable Image.
- **Video generation**: Amazon Nova Reel.
- **Audio**: Polly Generative voices; third-party on Bedrock Marketplace.

---

## 8. Economics of GenAI

### On-Demand vs Provisioned Throughput (Bedrock)
- **On-demand** — pay per token, no commitment. Ideal for spiky or new workloads.
- **Provisioned throughput** — reserve capacity (Model Units), hourly cost, supports **custom (fine-tuned) models**. Lower per-token cost at high volume; required for some custom models.
- **Batch inference** — submit jobs to S3, get results later, 50% discount.

### Cost levers
- Smaller models (Nova Micro/Lite vs Pro, Claude Haiku vs Sonnet vs Opus).
- Shorter prompts (compress system prompts; use variables).
- Cache common prompt prefixes (prompt caching).
- Use RAG to avoid fine-tuning.
- Batch where latency isn't critical.
- Cap `max_tokens`.
- Distill to a smaller model.

---

## 9. Useful Mental Models

- **LLM ≈ statistical pattern completer** — not a knowledge base, not a database, not a truth engine.
- **Prompt is the API.**
- **Context window is memory**, not long-term memory (use RAG for that).
- **Temperature = creativity dial.**
- **If you need recency or private data, use RAG, not fine-tuning.**

> Next — [2.2 Foundation Models & Transformers](./02-Foundation-Models.md)
