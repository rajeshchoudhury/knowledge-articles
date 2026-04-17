# 3.3 — Fine-Tuning & Model Customization

## 1. What "Customization" Means on Bedrock

Bedrock supports three kinds of customization:

| Type | Data | Goal |
|------|------|------|
| **Fine-tuning (supervised)** | Labeled (prompt, completion) pairs | Teach the model a task, tone, or format |
| **Continued pretraining** | Unlabeled domain text | Teach the model new vocabulary or domain knowledge |
| **Distillation** | Prompts + a chosen teacher model (or your own outputs) | Create a smaller, cheaper student model that mimics the teacher |

In SageMaker, you can additionally perform **full-blown training or fine-tuning** of any open-source model with full control (PEFT, LoRA, QLoRA, full fine-tune).

---

## 2. When to Fine-Tune vs Alternatives

### Fine-tune when
- The task requires **consistent structure / style** that prompts alone cannot reliably produce.
- You need higher accuracy on **niche, repeatable** tasks (e.g., legal clause classification).
- You want to **reduce prompt length** (embed the instruction into the weights).
- You want **behavioral consistency** across thousands of queries.

### Don't fine-tune when
- Knowledge changes often → **RAG**.
- You have a small amount of data → prompt engineering first.
- You can't afford provisioned throughput → on-demand serves base models only.
- You would overfit to a narrow slice.

---

## 3. Fine-Tuning on Bedrock — The Flow

1. **Prepare training data** in JSONL on S3:
   ```jsonl
   {"prompt": "Summarize: ...", "completion": "..."}
   {"prompt": "Translate to French: ...", "completion": "..."}
   ```
   - For chat models, the schema may require `system`, `messages`, `response` fields (check the specific model's docs).
2. **Create a customization job** in Bedrock.
   - Pick the base model (must support fine-tuning).
   - Point at training data (and optional validation data).
   - Set hyperparameters (epochs, learning rate, batch size, LoRA rank if applicable).
3. **Wait for training** — Bedrock handles the infra.
4. **Evaluate** — use Bedrock Model Evaluation on the custom model.
5. **Purchase Provisioned Throughput** — required to serve most custom models.
6. **Invoke** as you would a base model, but with the custom model ARN.

### Key hyperparameters (conceptual)
- **Epochs** — how many passes over the data. Too many → overfit.
- **Learning rate** — step size. Too high → diverge; too low → slow.
- **Batch size** — samples per training step.

### Data volume guidance (rough)
- **100s** of examples — minimum, will barely move the needle.
- **1,000–10,000** examples — typical sweet spot for SFT.
- **100,000+** — diminishing returns unless task is very complex.

**Data quality > quantity.** Garbage in → garbage out.

---

## 4. Continued Pretraining on Bedrock

- Data: unlabeled text in your domain (e.g., medical journals, legal opinions).
- Outcome: model understands your vocabulary and patterns, while still being a general model.
- Typically combined with **downstream fine-tuning** after.
- Use case: financial firm wants the model to "speak banking" before fine-tuning on task-specific pairs.

---

## 5. Model Distillation on Bedrock

- Pick a **teacher model** (e.g., Claude Sonnet) and a **student model** (e.g., Claude Haiku or Llama 8B).
- Provide representative prompts from your workload.
- Bedrock runs the teacher, captures high-quality outputs, then fine-tunes the student to match.
- Output: a faster, cheaper model that retains most of the teacher's quality on your workload.

**Why distill?**
- Latency.
- Cost.
- Edge / on-prem deployment where a smaller model is needed.

---

## 6. SageMaker Fine-Tuning (more control)

- **SageMaker JumpStart** offers one-click fine-tuning for many open models.
- You can also write custom training scripts (PyTorch / Hugging Face) on SageMaker Training Jobs using PEFT / LoRA / QLoRA.
- Deploy to a **SageMaker Endpoint** with your own instance type.
- More control, more operational burden than Bedrock.

---

## 7. Parameter-Efficient Fine-Tuning (PEFT)

Fine-tune a small subset of new parameters while freezing the base model.

- **LoRA (Low-Rank Adaptation)** — inject small low-rank matrices; train only those.
- **QLoRA** — LoRA on 4-bit quantized base; fits bigger models on smaller GPUs.
- **Prefix tuning, prompt tuning, adapters** — other PEFT variants.

**Benefits**: cheaper training, smaller storage per custom model, easy to swap between adapters.

Most Bedrock fine-tuning is **LoRA-based under the hood** (though you don't interact with this directly).

---

## 8. Reinforcement Learning from Human Feedback (RLHF)

Used to align models (primarily done by model vendors at training time). Not a customer-facing managed feature of Bedrock, but exam-relevant terminology.

Pipeline:
1. SFT → supervised fine-tuning on high-quality demonstrations.
2. Reward model training — humans rank outputs.
3. Policy optimization — PPO or DPO updates the model toward preferred outputs.

Modern variants: **DPO (Direct Preference Optimization)**, **RLAIF (RL from AI Feedback)**, **Constitutional AI**.

---

## 9. Evaluating a Fine-Tuned Model

- Hold out 10–20% of data as evaluation set.
- Compare against the base model and previous fine-tune.
- Evaluate on:
  - Task accuracy (the thing you trained for).
  - General quality (does it still follow instructions?).
  - Safety (did it become more/less toxic? Check with Clarify or Guardrails).
  - Format compliance (JSON validity).
- Bedrock **Model Evaluation** supports custom models.

### Catastrophic forgetting
Fine-tuning narrowly can cause the model to forget general skills. Mitigations:
- Include a mix of general and task-specific data.
- Use small LoRA adapters so the base is preserved.
- Early stopping.

---

## 10. Cost & Ops of Custom Models

- **Training cost** — charged per training token + storage.
- **Storage cost** — per GB of model artifacts / month.
- **Inference cost** — usually requires **Provisioned Throughput** (per-hour Model Units, 1 or 6-month commitment).
- **Versioning** — you can iterate on many custom versions; track their IDs and evaluation results.

---

## 11. Common Use Cases for Fine-Tuning

- Brand voice consistency ("write like us every time").
- Strict structured outputs (JSON with specific schema).
- Classification heads (intent, sentiment tailored to your taxonomy).
- Domain-specific summarization (legal, medical).
- Code generation in a proprietary language / framework.
- Reducing prompt size by embedding instructions in weights.

---

## 12. Exam Cues

| Clue | Answer |
|------|--------|
| "Adopt our brand voice" / "always respond in our exact format" | **Fine-tune** |
| "Teach domain vocabulary (legal, medical, financial jargon)" | **Continued pretraining** |
| "Shrink a large model for faster, cheaper inference" | **Distillation** |
| "Answer using our knowledge base that updates daily" | **RAG** |
| "Serve a fine-tuned Bedrock model in production" | **Provisioned Throughput** |
| "Open-source model with full control over weights" | **SageMaker JumpStart / Training** |
| "Train efficiently on limited GPU memory" | **LoRA / QLoRA** |
| "Align a base model to human preferences" | **RLHF / DPO** |

> Next — [3.4 Evaluation & Metrics](./04-Evaluation.md)
