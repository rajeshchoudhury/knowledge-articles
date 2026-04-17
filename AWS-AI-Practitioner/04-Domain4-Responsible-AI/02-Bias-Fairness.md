# 4.2 — Bias, Fairness, and Explainability

## 1. Bias in AI — The Short Version

**Bias** in ML = systematic errors that lead to unfair or incorrect outcomes, often along protected dimensions (race, gender, age, etc.).

**Fairness** = the absence of bias with respect to a defined notion of what's fair (multiple valid definitions!).

**No model is "fair" or "unbiased" by default.** You must decide, measure, and mitigate.

---

## 2. Sources of Bias (Mnemonic: **SLIM-DRF**)

- **S**ampling bias (unrepresentative training data)
- **L**abel bias (labels reflect human prejudice)
- **I**nstrument/Measurement bias (how features are recorded)
- **M**odel/algorithmic bias (model class encodes assumptions)
- **D**eployment bias (used outside intended context)
- **R**eporting/Confirmation bias
- **F**eedback-loop bias (model affects future data)

**Generative AI–specific sources**:
- Internet training data reflects societal stereotypes.
- RLHF annotator demographics bias preferences.
- Prompt wording itself can induce biased answers.

---

## 3. Fairness Definitions (Multiple, and They Conflict)

### Group fairness
- **Demographic parity / Statistical parity** — same positive rate across groups.
- **Equal opportunity** — same TPR (recall) across groups.
- **Equalized odds** — same TPR *and* FPR across groups.
- **Predictive parity** — same precision across groups.
- **Calibration within groups** — predicted probabilities are accurate within each group.

**Impossibility theorem** — you usually can't satisfy all of these at once if base rates differ. Pick the one most relevant to your harm model.

### Individual fairness
- "Similar individuals should be treated similarly" — hard to operationalize.

### Counterfactual fairness
- Prediction should be the same if we counterfactually changed the protected attribute.

### Disparate impact (80% rule)
- Selection rate for any protected group should be ≥ 80% of the highest group's rate.

---

## 4. Bias Metrics in SageMaker Clarify

Clarify reports both pre-training and post-training bias metrics. You do **not** need to memorize every formula for the exam, but recognize the names.

### Pre-training (data) metrics
- Class Imbalance (CI)
- Difference in Proportions of Labels (DPL)
- Kullback–Leibler (KL) divergence
- Jensen–Shannon (JS) divergence
- Lp norm
- Total Variation Distance (TVD)
- Conditional Demographic Disparity in Labels (CDDL)

### Post-training (model) metrics
- Difference in Positive Predictions (DPP)
- Disparate Impact (DI)
- Difference in Conditional Acceptance / Rejection
- Difference in Accuracy / Recall / Specificity
- Treatment Equality
- Conditional Demographic Disparity (CDD)
- Counterfactual Fliptest

Clarify produces a bias report with these metrics across your chosen "facet" (protected attribute).

---

## 5. Mitigation Strategies

### Data-level
- Add data for under-represented groups.
- Re-sample or re-weight.
- Remove leaky proxies (zip → race).
- Augment with synthetic data — carefully.

### Model-level
- Fairness-aware training (constraints, adversarial debiasing, reduction methods).
- Train separate thresholds per group (not always legal — check jurisdiction).

### Post-hoc
- Calibration per group.
- Threshold adjustment.
- Reject option classification.

### Generative AI–specific
- **System prompt guidance** — "avoid stereotypes, present balanced perspectives".
- **RLHF / RLAIF** with diverse annotators.
- **Guardrails** (denied topics, word filters).
- **Output diversification** — generate and pick the fairest candidate.
- **Post-generation rewriting** to neutralize bias.

---

## 6. Explainability Techniques

### Global explainability (model-wide)
- Tree / gradient feature importance.
- Partial Dependence Plots (PDP).
- Permutation importance.
- SHAP summary plots.

### Local explainability (per prediction)
- **SHAP values** — contribution of each feature to a specific prediction.
- **LIME** — local surrogate linear model.
- **Counterfactual explanations** — minimal change to flip the prediction.
- **Integrated gradients** (for deep nets).
- **Attention maps** (transformers — limited value as explanations).

### LLM-specific
- **Chain-of-thought rationales** — readable but unreliable (CoT can be post-hoc, not the true reasoning).
- **Citations in RAG** — explain "which document was used".
- **Agent trace logs** — each tool call is auditable.

**SageMaker Clarify** computes SHAP-based explanations for most tabular ML models, including XGBoost, Linear Learner, and bring-your-own models.

---

## 7. Human-in-the-Loop (HITL) — Amazon A2I

**Amazon Augmented AI (A2I)** lets you insert human review into ML workflows.

- Define a **Human Review Workflow (flow definition)** with a workforce (public / private / vendor) and a UI template.
- Trigger reviews based on confidence thresholds or random sampling.
- Integrates with Textract, Rekognition, SageMaker endpoints, and custom tasks.
- Reviewer decisions can be used to retrain or approve/reject.

Use when:
- Decisions are high-stakes (medical, legal, financial).
- Model confidence is low.
- Regulation requires human oversight.

---

## 8. Practical Checklist for Responsible AI Per Project

- [ ] Who is affected? Any protected groups?
- [ ] Is the training data representative?
- [ ] Are labels biased? Who labeled them?
- [ ] Did we audit for PII / privacy compliance?
- [ ] Did we compute bias metrics (Clarify)?
- [ ] Did we check explainability (Clarify SHAP)?
- [ ] Do we document the model (Model Cards)?
- [ ] Do we monitor drift & bias in production (Model Monitor)?
- [ ] Do we have a human-in-the-loop plan (A2I)?
- [ ] Are guardrails in place for GenAI outputs?
- [ ] Have we run red-teaming / adversarial testing?
- [ ] Do we have rollback and kill-switch procedures?

---

## 9. Exam Mappings

| Scenario | Answer |
|----------|--------|
| "Detect bias in training data" | **SageMaker Clarify (pre-training)** |
| "Measure bias in model predictions across gender" | **SageMaker Clarify (post-training)** |
| "Explain why the model predicted what it predicted" | **SageMaker Clarify (SHAP)** |
| "Send low-confidence predictions to human reviewers" | **Amazon A2I** |
| "Document intended use and limitations of a custom model" | **SageMaker Model Cards** |
| "Filter out hate speech from LLM responses" | **Bedrock Guardrails (content filter)** |
| "Find PII in unstructured documents in S3" | **Amazon Macie** |
| "Detect PII in text and redact it" | **Comprehend PII / Bedrock Guardrails sensitive info filter** |

> Next — [4.3 Transparency & Model Cards](./03-Transparency.md)
