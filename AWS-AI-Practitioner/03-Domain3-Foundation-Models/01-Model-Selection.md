# 3.1 — Model Selection Criteria

Choosing the right foundation model is a recurring exam topic. The short answer is: **it depends on the task, quality, latency, cost, context size, modality, and compliance.**

---

## 1. Selection Criteria — The Checklist

Ask all of these for every new use case:

| Criterion | Questions |
|-----------|-----------|
| **Task type** | Generation, classification, embedding, multimodal, code? |
| **Quality bar** | What's the acceptable error rate? Evaluate with Bedrock Model Evaluation. |
| **Modality** | Text-only or image/audio/video too? |
| **Context window** | How long are your inputs? 8K, 32K, 128K, 200K, 300K? |
| **Latency** | <1s (interactive) or async? |
| **Throughput** | Concurrent users / requests per second? |
| **Cost** | $/1K input tokens, $/1K output tokens. For high volume consider Provisioned Throughput or batch. |
| **Languages** | English only, or multilingual? |
| **Tool use / structured output** | Does it reliably follow JSON schemas and call tools? |
| **Customization** | Will you fine-tune or use continued pretraining? Is that supported? |
| **Safety** | Is the model aligned well? Does the vendor support guardrails? |
| **Region availability** | Is it in the regions your data must stay in? |
| **Compliance** | HIPAA, FedRAMP, data residency? |
| **Licensing** | Any commercial restrictions? |
| **Vendor lock-in risk** | Can you port to another model if needed? |

---

## 2. Quick Rules of Thumb

- **Small / fast / cheap tasks** (classification, extraction, drafting): **Nova Micro/Lite**, **Claude Haiku**, **Llama 3.1 8B**, **Mistral Small**.
- **Balanced chat and reasoning**: **Nova Pro**, **Claude Sonnet**, **Llama 3 70B**, **Mistral Large**.
- **Top-tier reasoning / coding**: **Claude Opus / Claude 3.7+ Sonnet / Claude 4**, **Nova Premier**.
- **Multimodal (image + text)**: **Claude 3+ family**, **Nova Lite/Pro**, **Llama 3.2 Vision**.
- **Embeddings**: **Titan Embeddings V2**, **Cohere Embed**.
- **Image generation**: **Nova Canvas**, **Titan Image Generator**, **Stable Diffusion XL / SD3**.
- **Video generation**: **Nova Reel**.
- **RAG-tuned**: **Cohere Command R+**.
- **Tool use / agents**: **Claude Sonnet / Opus**, **Nova Pro**, **Mistral Large**.

---

## 3. The Model-Choice Tradeoff Triangle

```
            Quality
              /\
             /  \
            /    \
           /      \
          /        \
   Cost  /__________\  Latency
```
You can usually pick two. Small models are cheap and fast but lower quality; large models are smart but slow and pricey.

---

## 4. Customization Strategies — Cost & Complexity Ladder

Arranged from **least** effort to **most**:

| Approach | Data needed | Cost | Outcome |
|----------|-------------|------|---------|
| **Prompt engineering** | None | $ | Fastest path; often good enough |
| **Few-shot prompting** | 3–20 examples in the prompt | $ | Better style/format control |
| **RAG** | Your documents indexed | $$ | Inject fresh, domain-specific knowledge without retraining |
| **Fine-tuning (SFT)** | Hundreds–thousands of (prompt, completion) pairs | $$$ | Adapt tone, style, task behavior |
| **Continued pretraining** | Large unlabeled domain corpus | $$$$ | Teach the model new vocabulary / domain |
| **Model distillation** | A teacher model + sample prompts | $$$ | Smaller, cheaper model that mimics a bigger one |
| **Train from scratch** | Massive corpus + huge compute | $$$$$ | Rarely appropriate; reserved for sovereign models |

### Decision flow
```
Need fresher or private knowledge?        → RAG
Need different tone / format / vocabulary?→ Fine-tune
Need domain expertise the model lacks?    → Continued pretraining
Need cheaper inference?                   → Distillation (or smaller model)
Need a brand-new model?                   → Train from scratch (rare)
```

RAG is the most common answer. Do it first; fine-tune only if RAG isn't enough.

---

## 5. Prompt Engineering vs RAG vs Fine-Tuning — Side by Side

| Dimension | Prompt Engineering | RAG | Fine-Tuning |
|-----------|-------------------|-----|-------------|
| Training needed | No | No | Yes |
| Data needed | Few examples | Documents + vector DB | Labeled (prompt, completion) pairs |
| Updates knowledge? | No | Yes, instantly when docs update | No (frozen) |
| Changes behavior / tone? | Somewhat | Limited | Strongly |
| Cost to build | Low | Medium (embed + store) | High |
| Cost to infer | Low-medium | Medium (retrieval + longer prompt) | Medium-high (custom model + provisioned throughput) |
| Best for | Style, format, basic tasks | Grounding in up-to-date or private info | Persistent new behavior, classification heads, style mimicry |
| Risk | Brittle to prompt changes | Stale vectors, bad retrieval | Overfitting, catastrophic forgetting |

**Exam tip**: If the question emphasizes **"up-to-date"**, **"private company data"**, or **"reduce hallucination with facts"** → **RAG**. If it emphasizes **"adopt our writing style"** or **"respond in a particular format every time"** → **fine-tune**.

---

## 6. Context Window & Cost Planning

Every token costs money and latency. A long system prompt multiplied by millions of requests = real money.

- Use **prompt caching** where supported to cache the system prompt + static context.
- Use **prompt compression** techniques (summarize, trim, deduplicate).
- For RAG, tune **top-k** and **chunk size** to balance recall vs prompt length.
- Monitor `input_tokens` and `output_tokens` via CloudWatch.

---

## 7. Evaluation-Driven Selection

Don't just guess — evaluate.

1. Build a **representative dataset** of prompts with ideal outputs.
2. Use **Bedrock Model Evaluation** to run automatic metrics.
3. Optionally run **human evaluation** for quality-sensitive tasks.
4. Measure **quality, latency, cost**.
5. Pick the smallest / cheapest model that meets the quality bar.

---

## 8. Recognize These Clues on the Exam

| Clue in the question | Likely answer |
|----------------------|---------------|
| "Answer using the latest company policies" | **RAG** with Knowledge Bases |
| "Write in the brand voice every time" | **Fine-tune** |
| "Reduce hallucinations" | **RAG + Guardrails** (grounded + verified) |
| "Lowest latency for short classifications" | **Small model** (Nova Micro, Claude Haiku) |
| "Multi-step actions that call APIs" | **Bedrock Agent** |
| "Doesn't want to manage infrastructure" | **Bedrock** (serverless), not SageMaker |
| "Needs deep domain vocabulary" | **Continued pretraining** (or domain-specific model) |
| "Already have a big model, want cheaper in prod" | **Distillation** |
| "Sensitive data must not leave VPC" | **PrivateLink / VPC endpoints** + Bedrock |
| "Images + text together" | **Multimodal model** (Claude 3, Nova Pro) |
| "Steady 24/7 high volume traffic" | **Provisioned throughput** |
| "Bulk processing overnight" | **Batch inference** |
| "One-click pretrained models with full control" | **SageMaker JumpStart** |
| "No-code ML for analysts" | **SageMaker Canvas** |
| "Real-time agent assist in call center" | **Amazon Q in Connect** |
| "Coding productivity" | **Amazon Q Developer** |
| "Company-wide enterprise chat on internal data" | **Amazon Q Business** |

> Next — [3.2 Retrieval Augmented Generation](./02-RAG.md)
