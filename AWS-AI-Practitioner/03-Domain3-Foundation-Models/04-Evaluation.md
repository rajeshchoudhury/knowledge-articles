# 3.4 — Evaluation & Metrics for AI/ML and GenAI

## 1. Why Evaluation Matters

You cannot ship what you cannot measure. The exam tests whether you know:
- **Classic ML metrics** (for supervised learning).
- **GenAI / LLM metrics** (ROUGE, BLEU, BERTScore, perplexity, human evals).
- **RAG metrics**.
- **Bias and fairness metrics**.

---

## 2. Classic ML Metrics

### 2.1 Classification

| Metric | Formula | When to use |
|--------|---------|-------------|
| **Accuracy** | (TP+TN)/N | Balanced classes |
| **Precision** | TP/(TP+FP) | Cost of false positives is high (spam filter) |
| **Recall (Sensitivity, TPR)** | TP/(TP+FN) | Cost of false negatives is high (cancer screening) |
| **F1** | 2·P·R/(P+R) | Balance P & R |
| **Specificity (TNR)** | TN/(TN+FP) | |
| **AUC-ROC** | Area under ROC | Ranking-quality on imbalanced |
| **AUC-PR** | Area under precision-recall | Highly imbalanced data |
| **Log loss / Cross-entropy** | | Calibrated probability models |

Always check **confusion matrix** and **class balance** before choosing.

### 2.2 Regression

| Metric | Intuition |
|--------|-----------|
| **MAE** (Mean Absolute Error) | Average absolute error in same units |
| **MSE** (Mean Squared Error) | Penalizes larger errors more |
| **RMSE** | Square root of MSE; same units as y |
| **R²** | Fraction of variance explained (0–1) |
| **MAPE** | Mean absolute percentage error |

### 2.3 Clustering / Unsupervised

- **Silhouette score** — how well points fit their cluster.
- **Davies–Bouldin**, **Calinski–Harabasz**.
- Ultimately judged by downstream utility.

### 2.4 Object Detection / Segmentation
- **IoU** (Intersection over Union).
- **mAP** (mean Average Precision).
- **Dice coefficient** (segmentation).

---

## 3. GenAI / LLM Metrics

### 3.1 N-gram overlap (surface-level)
- **BLEU** — for **translation**. 0–1 (or 0–100); higher is better.
- **ROUGE-N / ROUGE-L** — for **summarization**. Measures overlap with reference summary.
- **METEOR** — improved BLEU with stemming + synonyms.
- **Exact Match (EM)** — exact string match (QA).

### 3.2 Semantic similarity
- **BERTScore** — uses BERT embeddings; better captures paraphrases than BLEU/ROUGE.
- **BLEURT**, **COMET** — learned metrics for translation quality.
- **Embedding cosine similarity** — compare generated vs reference embeddings.

### 3.3 Probabilistic
- **Perplexity** — how "surprised" the LM is by a test set. Lower is better. Used during pretraining evaluation.

### 3.4 Task-specific reference-free metrics
- **Toxicity score** (Perspective API, Detoxify).
- **Readability** (Flesch).
- **Faithfulness / groundedness** — does answer follow from the given context? Measured with NLI models or LLM-as-a-judge.
- **Factuality** — match claims against a ground truth source.

### 3.5 Human evaluation
Gold standard for open-ended tasks. Dimensions:
- Correctness
- Helpfulness
- Harmlessness
- Style / tone
- Fluency
- Instruction-following

Use **pairwise preference** (A vs B) or **Likert scale** ratings; inter-rater agreement (Cohen's kappa) matters.

### 3.6 LLM-as-a-judge
Use a strong LLM (Claude Opus, Nova Premier, GPT-4-class) to grade outputs against a rubric. Fast and scalable; biased toward verbose or similar-style answers — validate against human judges periodically.

---

## 4. RAG-Specific Metrics

Retrieval:
- **Recall@K**, **Precision@K**, **NDCG**, **MRR** — did the gold chunk appear in top-K?

Generation in RAG:
- **Faithfulness** — are claims supported by retrieved context?
- **Answer relevance** — does it answer the question?
- **Context relevance** — are retrieved chunks useful?

Bedrock's **RAG Evaluation** automates these dimensions.

---

## 5. Bias & Fairness Metrics

### Pre-training bias (data)
- **Class Imbalance (CI)** — are protected classes under-represented?
- **Difference in Positive Proportions in Labels (DPL)**.
- **Kullback–Leibler (KL) divergence** across groups.
- **Jensen–Shannon (JS)** divergence.

### Post-training bias (predictions)
- **Difference in Positive Predictions (DPP)**.
- **Disparate Impact (DI)** — 80% rule.
- **Accuracy Difference (AD)** across groups.
- **Recall Difference (RD)** / **Precision Difference (PD)**.
- **Treatment Equality**.
- **Conditional Demographic Disparity (CDD)**.

**Amazon SageMaker Clarify** computes 20+ such metrics automatically.

---

## 6. Bedrock Model Evaluation — What You Get

- **Automatic evaluation**
  - Choose a task: summarization, Q&A, text generation, text classification, custom.
  - Built-in or custom dataset.
  - Metrics: accuracy, robustness, toxicity, BLEU, ROUGE, BERTScore, Exact Match, etc.
- **Human evaluation**
  - Bring your own workforce or use an AWS-managed team.
  - Custom rating rubric, Likert, thumbs-up/down, or comparison tasks.
- **LLM-as-a-judge evaluation**
  - Pick a judge model and criteria; Bedrock computes scores.
- **RAG evaluation**
  - Evaluate an end-to-end RAG pipeline (retrieval + generation).

Outputs stored in S3; summary in the console.

---

## 7. SageMaker Clarify for FMs

Clarify has extended its capabilities to foundation models:
- **Bias evaluation** across demographic slices.
- **Toxicity scoring** using built-in classifiers.
- **Accuracy, robustness, factual knowledge** benchmarks.
- **Stereotyping** detection.

Can be run inside SageMaker Studio via Jumpstart Eval or Clarify jobs.

---

## 8. Choosing the Right Metric

| Scenario | Metric |
|----------|--------|
| Email spam classifier | Precision, Recall, F1, AUC-ROC |
| Fraud detection (rare positive class) | AUC-PR, Recall, custom cost-weighted |
| Sales forecast | RMSE, MAE, MAPE |
| Translation EN→FR | BLEU, BERTScore, human |
| Summarization | ROUGE, BERTScore, human |
| Chatbot | Helpfulness (human), toxicity, faithfulness |
| Code assistant | Unit-test pass rate (HumanEval), compilation rate, human review |
| Visual Q&A | Exact match, BERTScore, human |
| RAG Q&A | Faithfulness, Answer relevance, Context relevance |
| Image classifier | Accuracy, macro-F1 |

---

## 9. Evaluation Pitfalls

1. **Test-set contamination** — model was trained on your test data.
2. **Metric gaming** — optimizing a metric that doesn't reflect quality.
3. **Hallucinated "correctness"** — LLM-as-judge rating its own style too highly.
4. **Small eval sets** — statistical noise.
5. **Missing safety eval** — only measuring quality, not toxicity/bias.
6. **Ignoring cost/latency** — best quality isn't best overall.
7. **No ground truth** — can't compute supervised metrics for open-ended tasks; use human + reference-free metrics.

---

## 10. A Minimal Evaluation Plan for a GenAI Project

1. Write **20–100 golden examples** covering typical + edge cases.
2. Define metrics — at least one quality metric + safety metric + cost + latency.
3. Run candidate models with **Bedrock Model Evaluation**.
4. Run a **human review** on a sample (≥30 examples).
5. Add **safety evaluation** (toxicity, bias, PII leakage).
6. Pick winner based on quality vs cost/latency tradeoff.
7. Re-evaluate **every time prompts, models, or retrieval change**.
8. Monitor production with **random sampling** + feedback loops.

> Next — [3.5 Agents & Orchestration](./05-Agents.md)
