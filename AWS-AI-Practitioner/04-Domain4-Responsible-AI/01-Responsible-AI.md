# 4.1 — Responsible AI Principles

## 1. The AWS Responsible AI Framework

AWS defines responsible AI across **eight core dimensions**. Memorize these — they appear directly and indirectly throughout the exam.

| # | Dimension | Meaning |
|---|-----------|---------|
| 1 | **Fairness** | Treat individuals and groups equitably; avoid discriminatory outcomes. |
| 2 | **Explainability** | Understand and communicate how the system arrives at a result. |
| 3 | **Privacy & Security** | Protect personal data; limit access; encrypt. |
| 4 | **Safety** | Minimize risk of harm; safe failure modes. |
| 5 | **Controllability** | Ability to supervise, steer, and shut down the system. |
| 6 | **Veracity & Robustness** | Accurate, reliable outputs; graceful under distribution shift or adversarial input. |
| 7 | **Transparency** | Clear documentation of capabilities and limitations (model & service cards). |
| 8 | **Governance** | Organizational processes and oversight over the AI lifecycle. |

Older AWS materials sometimes list a slightly different set (fairness, explainability, privacy, transparency, accountability, reliability). The exam treats these synonymously — know the concepts.

---

## 2. Why It Matters

- **Regulatory** — EU AI Act, NIST AI RMF, ISO/IEC 42001, sector-specific rules (HIPAA, GLBA).
- **Reputational** — bad outputs become PR disasters.
- **Business** — unfair models cost revenue and lawsuits.
- **User trust** — explainable systems get adopted.

---

## 3. Responsible AI Across the ML Lifecycle

| Phase | Responsible AI Action |
|-------|----------------------|
| Framing | Identify affected populations; check legal/ethical red flags |
| Data | Audit for bias, PII, consent, representativeness |
| Training | Mitigate bias (rebalancing, reweighting); track lineage |
| Evaluation | Measure fairness, toxicity, robustness, not just accuracy |
| Deployment | Apply guardrails; access controls; versioning |
| Monitoring | Watch for drift, bias, new failure modes; feedback channels |
| Sunset | Retire models safely; archive for auditability |

---

## 4. Bias — Types

| Type | Description | Example |
|------|-------------|---------|
| **Sampling bias** | Training data does not reflect real population | Voice model trained mostly on adult male voices |
| **Measurement bias** | Features are measured differently for groups | Credit decisions using zip codes (proxies race) |
| **Label bias** | Historical labels reflect past discrimination | Past hiring decisions used as labels |
| **Confirmation bias** | Humans only accept results matching expectations | Engineer tuning until "looks right" |
| **Societal bias** | Model inherits cultural stereotypes from web text | Occupation-gender stereotypes in LLM outputs |
| **Deployment bias** | Model used in a context it wasn't designed for | Fraud model built for US deployed in another region |
| **Feedback loop bias** | Model shapes future data (recommendations) | Always recommending same items makes them more popular |

### Mitigations
- Pre-training: balance datasets, augment minority groups, remove proxy features.
- During training: fairness-aware algorithms (reweighting, adversarial debiasing).
- Post-training: threshold adjustment per group, calibration.
- At runtime: guardrails, human review, diverse evaluation.

---

## 5. Fairness Metrics (quick recap)

See `../04-Responsible-AI/02-Bias-Fairness.md` for full detail. Common metrics:
- **Demographic parity** — equal positive rates across groups.
- **Equalized odds** — equal true-positive and false-positive rates.
- **Predictive parity** — equal precision across groups.
- **Disparate impact ratio** — selection rate for protected group ÷ selection rate for reference ≥ 0.8 ("four-fifths rule").

No single fairness metric fits all situations; choose based on context. Amazon SageMaker Clarify computes 20+.

---

## 6. Explainability & Interpretability

**Interpretability** — model is inherently understandable (linear regression, shallow tree).
**Explainability** — you can generate human-understandable explanations for a black-box model's predictions.

### Techniques
- **Feature importance** — which features matter overall (tree gains, permutation importance).
- **SHAP (Shapley Additive exPlanations)** — per-prediction attribution.
- **LIME** — local surrogate models.
- **Partial dependence plots (PDP)**.
- **Counterfactuals** — "what change flips the prediction?"
- For LLMs: **attention visualization**, **logit lens**, **chain-of-thought** (partial — CoT is not a guaranteed explanation).

### AWS tooling
- **SageMaker Clarify** — SHAP for tabular and feature attribution; global + local explanations.
- **Bedrock** — responses include **citations** in RAG, chain-of-thought in agents (trace logs).

---

## 7. Transparency

- **Model cards** (SageMaker Model Cards) — document intended use, training data, performance, caveats.
- **AI Service Cards** — AWS-published documents describing each AWS AI service's intended use, capabilities, limitations, and responsible-use guidance (e.g., Rekognition, Transcribe, Bedrock Titan, Bedrock Guardrails).
- **Data cards** — document data provenance, licensing, known issues.

---

## 8. Privacy

- **Data minimization** — only collect what you need.
- **Consent** — users agree to processing.
- **PII handling** — detect (Amazon Macie, Comprehend PII, Bedrock Guardrails) and redact.
- **Encryption** — KMS at rest, TLS in transit.
- **Data residency** — keep data in specific regions.
- **Right to be forgotten** — architecture must support deletion.
- **Differential privacy** — add noise to aggregates to prevent re-identification.

---

## 9. Safety

- Guardrails on generative output.
- Human-in-the-loop for critical decisions.
- Fallback behaviors on errors.
- Rate limiting and abuse monitoring.
- Red-teaming: deliberately attack your system to find weaknesses.

---

## 10. Controllability

- **Kill switch** for agents (disable tool calls, rollback).
- **Model versioning** — roll back to a prior version.
- **Access controls** — only authorized users can deploy / change prompts.
- **Audit trails** — CloudTrail + model invocation logs.

---

## 11. Veracity & Robustness

- **Reduce hallucination** — RAG, grounding checks, citations, retrieval verification.
- **Adversarial robustness** — test with jailbreak prompts, typos, noise.
- **Distribution-shift monitoring** — Model Monitor, Clarify.
- **Consistency** — evaluate repeated queries for stability.

---

## 12. Governance

- **Policies and procedures** — approvals, change management.
- **Roles and responsibilities** — RACI for each ML system.
- **Risk assessments** — classify systems by risk level.
- **Third-party review** — legal, compliance sign-off.
- **Model registry** — track versions, approvals.
- **Incident response** — process to handle bad outputs.
- Frameworks: **NIST AI RMF**, **ISO/IEC 42001** (AI management system), **EU AI Act**.

---

## 13. Responsible AI Tooling on AWS — Quick Map

| Concern | AWS tool |
|---------|----------|
| Detect bias in data / model | **SageMaker Clarify** |
| Explain predictions | **SageMaker Clarify (SHAP)** |
| Document models | **SageMaker Model Cards** |
| Document services | **AWS AI Service Cards** |
| Monitor bias / drift in production | **SageMaker Model Monitor** |
| Filter harmful outputs / PII | **Bedrock Guardrails** |
| Verify factual claims | **Guardrails: Contextual grounding + Automated Reasoning checks** |
| Evaluate FMs for toxicity / accuracy | **Bedrock Model Evaluation + Clarify** |
| Audit actions | **CloudTrail + model invocation logs** |
| Manage approvals | **SageMaker Model Registry + ML Governance** |
| Detect PII in data | **Amazon Macie, Comprehend PII** |
| Human review | **Amazon A2I (Augmented AI)** |

---

## 14. Responsible AI Reminders for Exam Questions

- **Explainability** → Clarify / SHAP.
- **Bias detection** → Clarify.
- **Unsafe LLM output** → Guardrails.
- **PII in prompts/responses** → Guardrails (sensitive info filter) / Comprehend / Macie.
- **Transparency for a service** → AI Service Card.
- **Document a custom model** → SageMaker Model Card.
- **Human review of model predictions** → Amazon A2I.
- **"Reduce hallucination"** → RAG + Grounding check + Guardrails.

> Next — [4.2 Bias, Fairness, and Explainability](./02-Bias-Fairness.md)
