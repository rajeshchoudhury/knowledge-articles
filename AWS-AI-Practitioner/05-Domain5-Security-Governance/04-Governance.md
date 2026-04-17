# 5.4 — Data & Model Governance

## 1. What Governance Means Here

Governance = the **processes, policies, and tooling** that make sure AI systems are:
- **Authorized** — someone approved every model and data use.
- **Auditable** — every change and invocation is traceable.
- **Compliant** — meet legal and regulatory obligations.
- **Risk-managed** — each system is assessed for harm, with mitigations tracked.
- **Reproducible** — you can reconstruct how a decision was made.

---

## 2. Data Governance

### 2.1 Data Catalog & Lineage
- **AWS Glue Data Catalog** — central metadata store for structured data.
- **Lake Formation** — access control on top of S3 data lakes.
- **DataZone** (Amazon) — data mesh, publish / subscribe datasets with governance.
- **SageMaker Lineage Tracking** — provenance from dataset → feature → model → endpoint.

### 2.2 Data Quality
- **AWS Glue Data Quality** — automated data quality rules.
- **Data Wrangler Insights** — quality checks at prep time.
- **SageMaker Model Monitor (data quality)** — drift detection in production.

### 2.3 Data Classification & Discovery
- **Amazon Macie** — classify PII / sensitive data in S3.
- **Comprehend PII** — detect in text.
- **Glue sensitive data detection** — scan during crawling.

### 2.4 Consent and Purpose Binding
- Track consent per record.
- Enforce purpose-limits via attribute tags and ABAC.

### 2.5 Data Retention
- S3 lifecycle policies, object tagging for retention class.
- Legal hold via Object Lock.
- Deletion pipelines for GDPR erasure.

---

## 3. Model Governance

### 3.1 Versioning & Registry
- **SageMaker Model Registry** — versioned, approvable models grouped into **Model Package Groups**.
- Attach **metrics**, **Model Card**, **explainability report**, **bias report**, **drift baseline**.
- Approval states: PendingManualApproval / Approved / Rejected.
- **Bedrock custom models** have ARNs per version; track manually or in your own registry.

### 3.2 Documentation
- **SageMaker Model Cards** — standard template covering use, data, evaluation, caveats.
- **Data cards** — describe datasets.
- **AI Service Cards** — provided by AWS for their services.

### 3.3 Change Management
- Pipelines (SageMaker Pipelines, Step Functions, CodePipeline) enforce: test → review → approve → deploy.
- Infrastructure-as-code: CloudFormation, CDK, Terraform.
- Configuration baselines via AWS Config.

### 3.4 Audit & Monitoring
- CloudTrail for every API call.
- Model invocation logging for Bedrock prompts / completions (when enabled).
- SageMaker endpoint data capture for monitoring.

### 3.5 Risk Assessment
- Classify each system by risk (low / medium / high) following NIST AI RMF or EU AI Act.
- Require additional review / mitigations for high-risk (human oversight, explainability, red-team).

### 3.6 Incident Response
- Playbooks for bad outputs, prompt injection detection, data leak.
- Model rollback (prior approved version in Registry).
- Guardrail update; custom regex / denied topics.
- Root-cause analysis and retrospective.

---

## 4. ML Governance in AWS — One-Page Architecture

```
┌────────────────────── Identity & Access ──────────────────────┐
│  IAM / Identity Center / SCPs / KMS / VPC endpoints           │
├─────────────────────── Data Layer ────────────────────────────┤
│  S3 + Lake Formation / Glue Catalog / DataZone / Macie        │
│  Feature Store / Ground Truth labels                          │
├─────────────────────── Build & Train ─────────────────────────┤
│  SageMaker Training / JumpStart / Bedrock Customization       │
│  Experiments, Clarify, Data Wrangler, Pipelines               │
├─────────────────────── Deploy & Serve ────────────────────────┤
│  SageMaker Endpoints / Bedrock (On-demand / Provisioned)      │
│  Model Registry + approvals + Model Cards                     │
├─────────────────────── Monitor & Govern ──────────────────────┤
│  Model Monitor / Clarify drift / CloudWatch                   │
│  Audit Manager / Config / CloudTrail / Security Hub / A2I     │
└────────────────────────── Controls Plane ─────────────────────┘
```

---

## 5. Cross-Functional Governance Processes

### Approval workflow (typical)
1. Business owner requests AI solution.
2. Risk & compliance review — classify risk.
3. Data governance review — consent, PII, retention.
4. Security review — threat model, IAM, KMS.
5. ML team builds and evaluates.
6. Responsible AI review — bias, explainability, model card.
7. Approval gate → Model Registry → Deploy.
8. Monitor + periodic re-assessment.

### Governance artifacts per model
- Problem statement
- Data sources & provenance
- Bias & fairness report
- Explainability report
- Evaluation report
- Model Card
- Risk assessment
- Approval record
- Deployment record
- Monitoring configuration

---

## 6. Responsible AI Policies & Playbooks

Create organization-level policies for:
- **Acceptable use** — no surveillance without consent, no autonomous weapons, etc.
- **Data use** — which data may be used for training, fine-tuning, prompts.
- **Third-party models** — vetting, IP, licensing, data privacy.
- **Disclosure** — when to inform end users that they're interacting with AI.
- **Human oversight** — where humans are required in the loop.
- **Rollback & kill-switch** — criteria and process.

---

## 7. Frameworks & Maturity Models

- **AWS Well-Architected Machine Learning Lens** — pillars: operational excellence, security, reliability, performance efficiency, cost optimization — adapted for ML.
- **AWS Generative AI Security Scoping Matrix** — categorizes GenAI workloads by control needs (Consumer, Enterprise, Pretrained Model, Fine-Tuned, Self-trained).
- **AWS Cloud Adoption Framework – AI/ML Perspective**.
- **NIST AI RMF**, **ISO 42001**, **MLOps Maturity Models**.

### AWS Generative AI Security Scoping Matrix (simplified)

| Scope | Description | Example |
|-------|-------------|---------|
| **1** | Consumer app | Use ChatGPT, Copilot via SaaS |
| **2** | Enterprise app | Amazon Q Business, Bedrock Studio with enterprise data |
| **3** | Pretrained model via API | Bedrock Converse with base model |
| **4** | Fine-tuned model | Bedrock custom model |
| **5** | Self-trained | SageMaker training your own model |

Controls scale with scope: Scope 1 = mostly data usage policy; Scope 5 = full lifecycle (data, model, infra, ops).

---

## 8. Cost Governance

- Cost allocation tags for AI workloads.
- **AWS Budgets** alerts on Bedrock token spend.
- **Cost Explorer** to attribute spend by service/tag.
- **AWS Cost Anomaly Detection** for unusual spikes.
- Use **batch inference** (50% discount) where possible.
- Use smaller or distilled models where feasible.
- Cache prompts; compress; cap max tokens.

---

## 9. Exam Cues

| Scenario | Answer |
|----------|--------|
| "Version and approve models before production" | **SageMaker Model Registry** |
| "Document intended use and limitations of a custom model" | **SageMaker Model Cards** |
| "Classify and label sensitive data in S3" | **Amazon Macie** |
| "Manage data access across a lake" | **AWS Lake Formation** |
| "Unified catalog and data mesh" | **Amazon DataZone** |
| "Collect compliance evidence automatically" | **AWS Audit Manager** |
| "Configuration drift detection" | **AWS Config** |
| "Aggregate security findings" | **AWS Security Hub** |
| "AI best practices blueprint" | **AWS Well-Architected ML Lens / GenAI Security Scoping Matrix** |
| "Risk-based AI regulation" | **EU AI Act** |
| "AI management system standard" | **ISO/IEC 42001** |
| "US voluntary AI risk framework" | **NIST AI RMF** |
| "End-to-end lineage of data to prediction" | **SageMaker ML Lineage Tracking** |

> You are done with Domain 5. Now review the [Flash Cards](../06-Flash-Cards/), [Diagrams](../07-Diagrams/Diagrams.md), and attempt the [Practice Exams](../09-Sample-Questions/).
