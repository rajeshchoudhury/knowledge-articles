# 2.5 — Generative AI Use Cases, Benefits & Limitations

## 1. Who Uses Generative AI and Why?

| Industry | Typical use cases |
|----------|-------------------|
| **Financial services** | Draft investment research, summarize earnings calls, fraud narrative generation, customer service, KYC document extraction |
| **Healthcare & life sciences** | Clinical note summarization, medical coding, patient intake, literature review, drug discovery |
| **Legal** | Contract analysis, clause extraction, legal research, drafting, discovery |
| **Retail & e-commerce** | Product descriptions, recommendations, review summarization, image generation, chatbots |
| **Manufacturing** | SOP assistance, maintenance logs, quality reports, supplier email triage |
| **Media & entertainment** | Content creation, localization, script development, image/video generation |
| **Education** | Personalized tutoring, content creation, automatic grading |
| **Software & IT** | Code completion (Q Developer), test generation, migration (Java 8 → 17), documentation |
| **Public sector** | Policy drafting, citizen services, translation, case summaries |
| **Customer support** | Agent assist, self-service chatbots, call summarization |

---

## 2. Core Generative AI Capabilities (From an Exam Viewpoint)

| Capability | Example AWS solution |
|------------|----------------------|
| **Text generation** | Bedrock + Claude / Nova / Llama |
| **Text summarization** | Bedrock + any chat FM |
| **Text classification** | Bedrock or Comprehend Custom |
| **Entity extraction** | Bedrock (structured output) or Comprehend |
| **Chatbots / conversational AI** | Bedrock / Q Business / Lex (intent-based) |
| **Enterprise search with NL** | Q Business, Bedrock KB, Kendra |
| **Code generation** | Q Developer / Bedrock Code models |
| **Image generation** | Bedrock + Nova Canvas / Titan Image / Stable Diffusion |
| **Image understanding** | Bedrock + Claude 3 / Nova Lite/Pro |
| **Audio transcription** | Transcribe (+ summarize via Bedrock) |
| **Speech synthesis** | Polly (incl. generative voices) |
| **Video generation** | Bedrock + Nova Reel |
| **Document Q&A** | Textract + Bedrock (RAG) |
| **Translation** | Translate or Bedrock (higher quality with context) |
| **Personalization** | Personalize (classic) or Bedrock + user profile in prompt |
| **Forecasting** | Forecast / SageMaker / Bedrock (with caution on numerical accuracy) |
| **Content moderation** | Rekognition, Comprehend, Bedrock Guardrails |
| **Agents (multi-step actions)** | Bedrock Agents |

---

## 3. Use-Case Deep Dives

### 3.1 Customer Support Chatbot

**Goal**: answer user questions from docs, defer to human when unsure.

- Pick an FM with good latency and cost (Claude Haiku, Nova Lite).
- Ground on company docs using **Bedrock Knowledge Bases** (S3 + OpenSearch Serverless).
- Apply **Guardrails**: PII redaction, denied topics (competitors, medical advice).
- Hand off to human if confidence low or user asks.
- Log everything (CloudWatch) and run periodic **Model Evaluation** to catch regressions.
- Consider **Amazon Q Business** if you want a lower-code option.

### 3.2 Marketing Copy Generator

- Use prompt templates with brand voice; version with **Prompt Management**.
- Let users pick tone (playful, formal), length, channel.
- Use image models (Nova Canvas, Titan Image) for visual companions.
- Apply **Guardrails** for word filters and brand safety.
- Keep **temperature** around 0.7–0.9 for variety.

### 3.3 Contract / Document Analysis

- **Textract** for OCR of scanned PDFs.
- **Bedrock** for extraction (structured JSON), classification, summarization.
- Include page citations by chunking per-page.
- Use **Automated Reasoning** guardrail to verify clauses against a policy.
- Keep humans-in-the-loop for sensitive decisions.

### 3.4 Code Assistant

- **Amazon Q Developer** for IDE integration (VS Code, JetBrains).
- **Bedrock** with code-capable models for custom tooling.
- Plug into CI to auto-generate unit tests or explain failing builds.

### 3.5 Enterprise Search

- **Amazon Q Business** for the end-to-end UX (connectors + chat + ACLs).
- Or **Kendra** + **Bedrock** if you need full control.
- Or build RAG with **Bedrock Knowledge Bases**.

### 3.6 Call Center Analytics

- **Transcribe Call Analytics** for transcripts + sentiment + categories.
- **Bedrock** to summarize and generate next-best-actions.
- **Amazon Q in Connect** for real-time agent assist.
- Store summaries in a CRM; dashboards via QuickSight (+ Q).

### 3.7 Personalized Recommendations with GenAI

- Retrieve candidate items (Personalize or vector search).
- Use **Bedrock** to generate personalized product descriptions or pitches.
- Apply **Guardrails** for claim accuracy.

### 3.8 Drug / Protein Research

- Use domain-specific models via SageMaker JumpStart or Bedrock Marketplace.
- Keep **strict access controls** and **PrivateLink**.

### 3.9 Knowledge Worker Productivity

- Summarize meetings, draft emails, answer HR questions.
- **Amazon Q Business** or **Bedrock Studio** builds.

### 3.10 Education / Training

- Tutoring: CoT prompts for step-by-step solutions.
- Content creation: lesson plans, quizzes.
- **Guardrails** to keep content age-appropriate.

---

## 4. Benefits of Generative AI

1. **Productivity gains** — drafts in seconds.
2. **Scalability** — handle millions of queries.
3. **Personalization** — tailor at scale.
4. **Unstructured data unlock** — previously siloed docs become queryable.
5. **Accessibility** — translation, speech, summarization.
6. **Innovation velocity** — prototype new products quickly.
7. **Cost reduction** — automate repetitive knowledge work.
8. **Multimodal fusion** — chat with images, charts, videos.

---

## 5. Limitations, Costs, and Risks

### Limitations
- **Hallucination** — confident but wrong.
- **Staleness** — training cutoff.
- **Numerical reasoning** — unreliable without tools.
- **Context window** — finite memory.
- **Interpretability** — hard to explain why the model said what it said.
- **Consistency** — outputs vary run-to-run even at temperature 0 (nondeterminism from hardware).
- **Bias** — inherited from training data.

### Costs
- Per-token billing adds up quickly.
- Long prompts (RAG contexts) multiply cost.
- Provisioned throughput is expensive but predictable.
- Human review / labeling is a real budget line.

### Risks
- Reputational damage from bad outputs.
- Legal — IP/copyright, data privacy, regulated industries.
- Prompt injection / data exfiltration.
- Over-reliance without human review.
- Vendor lock-in if you hardcode to one model's quirks.

### Exam framing

When a question asks "what is a limitation?" the answer is almost always one of:
- Hallucination
- Data privacy / compliance
- Cost at scale
- Lack of explainability / transparency
- Knowledge cutoff / staleness
- Security risks (prompt injection)
- Bias / fairness issues

---

## 6. When NOT to Use GenAI

- When deterministic answers are required and rules work.
- When outcomes must be fully explainable (regulated decisions) — consider simpler, interpretable ML.
- Ultra-low-latency contexts (< 10 ms).
- When privacy / sovereignty rules forbid sending data to an FM.
- When the cost per query does not fit the business model.

---

## 7. Framework for Deciding: GenAI vs Traditional ML vs Rules

```
Is the task deterministic with known rules?
  Yes → Rules / code
  No → Is labeled data plentiful and the task well-defined?
           Yes → Traditional ML (XGBoost / SageMaker)
           No → Is the task about language / content / reasoning?
                 Yes → GenAI (Bedrock)
                 No → Reconsider or use a hybrid
```

Real solutions are **often hybrid** — rules for safety, classic ML for scoring, GenAI for language.

---

> You have finished Domain 2. Continue to Domain 3 — [Applications of Foundation Models](../03-Domain3-Foundation-Models/01-Model-Selection.md).
