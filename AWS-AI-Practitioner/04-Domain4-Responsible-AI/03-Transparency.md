# 4.3 — Transparency: Model Cards, Service Cards, Data Cards

Transparency means anyone affected by an AI system can understand:
- What it does and does not do.
- What data it was trained on.
- How it performs.
- Known limitations, risks, and appropriate uses.

---

## 1. AWS AI Service Cards

**AWS publishes AI Service Cards for its managed AI services.** Each card:
- Describes the service's intended use cases.
- Lists design, performance, fairness, explainability, and privacy considerations.
- Describes known limitations.
- Gives **responsible-use guidance** for customers.

Examples of AWS AI Service Cards:
- Amazon Rekognition face matching
- Amazon Textract AnalyzeID
- Amazon Transcribe (batch and streaming)
- Amazon Comprehend PII detection
- Amazon Titan Text
- Amazon Titan Image Generator
- Amazon Nova (Micro, Lite, Pro)
- Amazon Bedrock Guardrails
- Amazon Q Business

> Exam expectation: **an AI Service Card documents an AWS AI service**, not your own model. If the question is about *your custom model*, the answer is a **SageMaker Model Card**.

---

## 2. SageMaker Model Cards

**You** create Model Cards to document **your own models**. Fields typically captured:

- **Model overview** — name, version, owner, approval status.
- **Intended uses & out-of-scope uses** — who should use this, and for what; and what not to use it for.
- **Training details** — dataset, preprocessing, algorithm, hyperparameters, infra.
- **Evaluation results** — metrics on held-out data, fairness metrics, performance by subgroup.
- **Ethical considerations & caveats** — known limitations, risks.
- **Operational context** — SLAs, monitoring, rollback process.
- **Custom fields** — as your organization needs.

Supports approval workflows and integrates with **SageMaker Model Registry** and **ML Governance** dashboards.

---

## 3. Data Cards

A **data card** documents a dataset. Typical contents:
- Provenance (source, license).
- Collection methodology.
- Preprocessing steps.
- Known biases, imbalances, missing groups.
- PII handling and consent.
- Versioning / freshness.
- Update cadence.

AWS doesn't have a managed "Data Card" service, but Model Cards and Feature Store metadata can carry similar info.

---

## 4. Other Transparency Mechanisms

### Citations in RAG
- Bedrock Knowledge Bases return citations (source, offset) with each answer so users can verify claims.
- Amazon Q Business shows citations in its chat UI.

### Chain-of-thought traces
- Agents for Bedrock expose **trace logs** of reasoning and tool calls — an audit trail.
- Useful for debugging and compliance but may leak internal info; don't surface raw trace to end users.

### Confidence scores
- Rekognition returns confidence per label.
- Comprehend sentiment returns per-class probabilities.
- Encourage clients to gate decisions on confidence thresholds.

### Disclosure to users
- When users interact with an AI system, many jurisdictions now require disclosure ("This is an AI assistant").
- EU AI Act mandates labeling of synthetic media.

---

## 5. SageMaker ML Governance Dashboards

Gives managers a central view of:
- Model Cards status and completeness.
- Pending approvals in Model Registry.
- Audit/permission reports.
- Role Manager for ML personas (data scientist, ML engineer, auditor).

Integrates with **AWS Audit Manager** for compliance evidence.

---

## 6. Key Comparisons

| Concept | Who owns it | What it describes |
|---------|-------------|-------------------|
| **AI Service Card** | AWS | An AWS AI managed service |
| **Model Card (SageMaker)** | You | Your custom ML model |
| **Data Card** | You | A dataset |
| **Foundation model documentation** | Model provider | FM capabilities & limits (e.g., Anthropic model card) |

---

## 7. Transparency for Generative AI

Because FMs are closed over huge training corpora, transparency shifts to:
- **System transparency** — clearly document what your GenAI app does, data it uses, and who's accountable.
- **Behavioral transparency** — evaluations, red-team results, known failure modes.
- **Output transparency** — citations for RAG, disclosures, watermarks for synthetic media (Nova Canvas/Reel outputs can include invisible watermarks).

---

## 8. Exam Cues

| Scenario | Answer |
|----------|--------|
| "Document intended use of *our custom* fraud model for auditors" | **SageMaker Model Cards** |
| "Understand limitations of Amazon Transcribe for a use case" | **AWS AI Service Card** |
| "Provide source references for every answer in a RAG system" | **Bedrock Knowledge Base citations** |
| "Show SHAP explanations for each prediction" | **SageMaker Clarify** |
| "Central dashboard of all model approvals" | **SageMaker ML Governance / Model Registry** |
| "Human-reviewed predictions" | **Amazon A2I** |

> Next — [4.4 AWS Responsible AI Tools](./04-AWS-Tools.md)
