# 4.4 — AWS Responsible AI Tools Deep Dive

A consolidated deep-dive on the tools covered so far. Memorize what each does.

---

## 1. Bedrock Guardrails — The GenAI Safety Layer

Apply **one** configurable guardrail across any Bedrock model or **standalone** via `ApplyGuardrail`.

### 1.1 Content filters
Six policy categories:
1. Hate
2. Insults
3. Sexual
4. Violence
5. Misconduct (e.g., criminal activity)
6. Prompt attacks

Each has **four configurable strengths**: NONE / LOW / MEDIUM / HIGH. Applied to input (user message) and output (model response) independently.

### 1.2 Denied topics
- Up to 30 custom topics.
- Each defined by a short natural-language description and optional examples.
- The model classifier decides if a prompt or response is about a denied topic.
- Example: "Investment advice — any recommendation about buying or selling specific securities."

### 1.3 Word filters
- Custom word / phrase list.
- Built-in **profanity** list.
- Blocks if either input or output contains a filtered term.

### 1.4 Sensitive information filters (PII)
- Built-in entities: SSN, credit card, phone, email, name, address, driver's license, passport, bank account, IP address, AWS access keys, PIN, URL, date of birth, etc.
- Action: **BLOCK** or **MASK** (replace with `{SSN}` placeholder).
- Custom **regex** patterns for organization-specific IDs (employee ID, case number).
- Detects and acts on both input and output.

### 1.5 Contextual grounding checks
Reduces hallucination in RAG:
- **Grounding score** — how much the response is supported by the provided source material.
- **Relevance score** — how relevant the response is to the user's query.
- Threshold → if below, block or flag.

### 1.6 Automated Reasoning Checks (newer)
- Encode a policy as formal logic rules.
- Guardrail verifies model claims against the rules and returns a verified/unverified label with justification.
- Useful for HR policies, compliance, financial rules.

### 1.7 Guardrail Versions
- Draft version for iteration; publish versions for production.
- Version pinning for reproducibility.

### 1.8 Where guardrails can be used
- In `InvokeModel` / `Converse` by passing `guardrailIdentifier` + `guardrailVersion`.
- In Bedrock Agents (attached to agent).
- In Knowledge Bases queries.
- Standalone via `ApplyGuardrail` — even against non-Bedrock text sources.

---

## 2. SageMaker Clarify — Bias and Explainability

### 2.1 Pre-training bias
Measure imbalance in your dataset **before** you train.

### 2.2 Post-training bias
Measure bias in predictions from the trained model.

### 2.3 Explainability
- **SHAP** for tabular and NLP.
- Global (feature importance) + local (per-prediction).
- Produces a Clarify report (HTML) in the Studio UI.

### 2.4 Foundation model evaluation (Clarify FM)
- Evaluate FMs on toxicity, bias, factual knowledge, robustness, stereotyping.
- Runs on SageMaker (using JumpStart evaluation).

### 2.5 Integration
- Runs as a **SageMaker Processing Job**.
- Consumes a **SageMaker Endpoint** or batch data.
- Can run in **SageMaker Pipelines** as a step.
- Feeds **SageMaker Model Monitor** for bias drift.

---

## 3. SageMaker Model Monitor — Drift Detection

Four monitor types:
1. **Data quality** — input schema and distribution vs a baseline.
2. **Model quality** — predictions vs delayed ground truth.
3. **Bias drift** — fairness metrics over time (uses Clarify under the hood).
4. **Feature attribution drift** — changes in which features drive predictions.

Output: CloudWatch metrics and JSON violation reports in S3. Triggers: auto-retrain via EventBridge → Pipelines.

---

## 4. SageMaker Model Cards & Model Registry

- **Model Cards** — document the model (intended use, data, metrics, caveats).
- **Model Registry** — version and approve models. States: PendingManualApproval → Approved / Rejected.
- **ML Governance Dashboard** — see cards, registry, audits in one place.

---

## 5. Amazon A2I — Augmented AI (Human-in-the-Loop)

- Flow Definition: workforce + template + trigger conditions.
- Integrated with: Rekognition, Textract, SageMaker endpoints, custom.
- Output: human-verified JSON in S3.
- Feeds future retraining.

---

## 6. Amazon Macie — Sensitive Data Discovery

- Scans **S3** to find **PII / PHI / financial data**.
- Automatically classifies objects; generates findings.
- Supports **managed data identifiers** (SSN, credit card, AWS keys) and **custom identifiers** (regex + keywords).
- Critical for pre-training data audits.

---

## 7. Amazon Comprehend — PII & Content

- **DetectPiiEntities / RedactPii** — find and redact PII in text.
- **Custom entity recognition** for domain-specific PII.
- **Comprehend Medical** adds PHI detection for HIPAA-covered workloads.

---

## 8. Amazon Textract + Detection Features

Textract can detect signatures, identity documents, and PII in scanned documents. Combine with Comprehend / Macie for full data governance.

---

## 9. AWS Audit Manager & Config

- **AWS Audit Manager** — automates collection of audit evidence for compliance frameworks (HIPAA, PCI-DSS, SOC 2, GDPR, NIST AI RMF, ISO 42001).
- **AWS Config** — records AWS resource configurations and changes; Config Rules enforce compliance.

---

## 10. AWS Artifact

- On-demand **compliance reports** (SOC, ISO, PCI).
- Where you retrieve the **BAA** for HIPAA and the **DPA** for GDPR.

---

## 11. CloudTrail, CloudWatch, S3 Logs

- **CloudTrail** records every API call — who called `bedrock:InvokeModel` when.
- **CloudWatch Metrics** — per-model token counts, throttles, latency, error rates.
- **CloudWatch Logs / S3** — model invocation logs (optional) for auditing prompts and completions.

---

## 12. IAM Identity Center & KMS

- **IAM Identity Center** — SSO and user-level identity for **Amazon Q Business**, **Bedrock Studio**.
- **AWS KMS** — at-rest encryption with customer-managed keys across Bedrock, SageMaker, S3, Kendra, OpenSearch, etc.

---

## 13. Bedrock Model Evaluation

(Also in Domain 3.) Here it's a **responsible AI** control because it includes toxicity and safety evaluations:
- Automatic: toxicity, bias via rubric, BLEU / ROUGE / Exact Match.
- Human: subject-matter expert review.
- LLM-as-a-judge with custom rubric.

---

## 14. Summary Tool Map — Memorize

| Concern | Service |
|---------|---------|
| Harmful generative output / PII in prompts | **Bedrock Guardrails** |
| Factual grounding of RAG responses | **Bedrock Guardrails – Contextual grounding** |
| Compliance claims against a rule set | **Bedrock Guardrails – Automated Reasoning** |
| Bias in training data | **SageMaker Clarify (pre-training)** |
| Bias in model predictions | **SageMaker Clarify (post-training)** |
| Explain individual predictions | **SageMaker Clarify (SHAP)** |
| Monitor for drift / bias drift | **SageMaker Model Monitor** |
| Document your model | **SageMaker Model Cards** |
| Document AWS service | **AWS AI Service Cards** |
| Human review of ML predictions | **Amazon A2I** |
| Discover PII in S3 | **Amazon Macie** |
| Redact PII in text | **Amazon Comprehend PII** |
| Evaluate an FM or a RAG pipeline | **Bedrock Model Evaluation** |
| Compliance evidence collection | **AWS Audit Manager** |
| Retrieve compliance reports & BAA | **AWS Artifact** |
| SSO for AI apps | **IAM Identity Center** |
| Encryption keys | **AWS KMS** |

> You are done with Domain 4. Continue to [Domain 5 — Security, Compliance, Governance](../05-Domain5-Security-Governance/01-Security.md)
