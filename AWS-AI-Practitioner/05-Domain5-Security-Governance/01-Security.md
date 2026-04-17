# 5.1 — Security for AI Workloads

## 1. Shared Responsibility Model for AI Services

```
┌──────────────────────────────────────────────────────────────┐
│                        AWS (Of the cloud)                    │
│  Global infrastructure, compute, storage, networking,        │
│  managed AI service availability, the FM training &          │
│  weights, service-level controls, physical security.         │
├──────────────────────────────────────────────────────────────┤
│                   You (In the cloud)                         │
│  Your data (training, prompts, outputs), your IAM            │
│  policies, KMS key management, network config (VPC           │
│  endpoints), encryption at rest choices, guardrails,         │
│  prompt hygiene, fine-tuning data, app-level logging,        │
│  monitoring, access control and audit.                       │
└──────────────────────────────────────────────────────────────┘
```

For **managed AI services** (Bedrock, Rekognition, Transcribe, etc.) AWS handles more. For **SageMaker**, you shoulder more of the model and training environment.

---

## 2. Pillars of AI Security (Well-Architected ML Lens)

1. **Identity and access management** — least privilege with IAM.
2. **Data protection** — encryption at rest and in transit, PII handling.
3. **Infrastructure protection** — VPC isolation, PrivateLink, security groups.
4. **Detection** — CloudTrail, CloudWatch, GuardDuty.
5. **Incident response** — runbooks, key rotation, revocation.
6. **Governance** — policies, Config, Organizations, SCPs.

---

## 3. Encryption

### 3.1 At rest
- **S3** — SSE-S3, SSE-KMS, SSE-C.
- **EBS** — encrypted volumes (KMS).
- **SageMaker** — KMS keys for notebooks, training jobs, endpoints, processing jobs.
- **Bedrock** — customer-managed KMS for model customization and session data.
- **Vector stores** (OpenSearch Serverless, Aurora) — KMS.
- **Knowledge Base data sources** (S3) — KMS.

### 3.2 In transit
- TLS 1.2+ everywhere.
- **VPC endpoints (PrivateLink)** keep traffic off the public internet.
- **Internal service traffic** encrypted within the AWS network.

### 3.3 KMS key types
- **AWS-owned** — AWS manages; free; shared across accounts (service level).
- **AWS-managed** (`aws/service`) — AWS manages on your behalf; visible in your account.
- **Customer-managed (CMK)** — you manage rotation, policies, grants; required for strict compliance.

For Bedrock, using **customer-managed keys** signals to auditors that you control access.

---

## 4. Networking — Private Connectivity

### 4.1 VPC Endpoints (Interface / PrivateLink)
Provide a **private entrypoint** for AWS service APIs inside your VPC. No internet gateway needed.
- Available for: Bedrock, SageMaker, Kendra, Textract, Comprehend, Translate, S3, KMS, etc.
- Use a VPC endpoint policy to restrict which principals and actions.

### 4.2 VPC Mode for SageMaker
- Training jobs and endpoints run **inside your VPC**.
- **Network Isolation** — the container cannot reach anything outside (no internet, not even AWS APIs).

### 4.3 Bedrock Private Connectivity
- Call Bedrock **only via VPC endpoints**.
- Combine with endpoint policies and SCPs to restrict models that can be called.

### 4.4 Security Groups & NACLs
- Security groups for EC2, SageMaker endpoints, RDS / Aurora vector DBs.
- Network ACLs at subnet level.

### 4.5 Traffic flow for private RAG
```
App (in VPC) ──▶ Bedrock VPC Endpoint (PrivateLink) ──▶ Bedrock
               ──▶ OpenSearch Serverless PrivateLink ──▶ Vectors
               ──▶ S3 Gateway endpoint ──▶ Documents
```

---

## 5. IAM for AI Services

### Principle of least privilege
- Separate **build** roles (data scientists) from **deploy** roles (MLOps) from **invoke** roles (apps).
- Scope actions to specific model ARNs.

### Example: restrict Bedrock to one model
```json
{
  "Effect": "Allow",
  "Action": "bedrock:InvokeModel",
  "Resource": "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-3-haiku-20240307-v1:0"
}
```

### Common permissions
- `bedrock:InvokeModel`, `bedrock:InvokeModelWithResponseStream`, `bedrock:Converse*`
- `bedrock:CreateKnowledgeBase`, `bedrock:Retrieve`, `bedrock:RetrieveAndGenerate`
- `bedrock:InvokeAgent`
- `bedrock:ApplyGuardrail`
- `sagemaker:*` (use fine-grained actions — `sagemaker:CreateTrainingJob`, etc.)
- `s3:GetObject`, `s3:PutObject` on data buckets
- `kms:Decrypt`, `kms:Encrypt` for CMK access

### Service roles (pass role)
- SageMaker training/endpoint **execution role**.
- Bedrock **service role** for KB / Agent to read S3, call Lambda Action Groups, talk to vector store.
- Use **IAM Roles Anywhere** for hybrid workloads.

### Conditional access
- `aws:SourceVpce`, `aws:SourceIp`, `aws:PrincipalOrgID`.
- `bedrock:InferenceProfile` condition for model access control.

### IAM Identity Center
- Federate SSO for **Amazon Q Business** and **Bedrock Studio** end users.
- Assign user/group permissions to apps.

---

## 6. Data Privacy with Bedrock

Major exam fact — say it to yourself:
> **Your data is not used to train or improve Bedrock's foundation models. Prompts and completions stay in your account.**

Also:
- Data stays in the **selected region**.
- **Model invocation logging** is opt-in; off by default.
- You can choose to deliver logs to CloudWatch or S3 encrypted with your KMS key.
- Fine-tuning / continued pretraining data is stored in your account; the resulting custom model is private to you.
- Guardrails protect against PII leakage.

---

## 7. Data Privacy with SageMaker

- Notebook volumes, training artifacts, endpoints encrypted with **KMS**.
- VPC-only mode; Network Isolation.
- **SageMaker Pipelines lineage tracking** records data lineage.
- **Endpoint capture** saves inputs/outputs to S3 for monitoring — treat as sensitive.

---

## 8. Detecting Threats

- **AWS CloudTrail** — audit trail of API calls.
- **AWS CloudWatch** — metrics, logs, alarms.
- **Amazon GuardDuty** — intelligent threat detection on AWS accounts (anomalous API calls, compromised credentials).
- **AWS Security Hub** — aggregates findings across services.
- **AWS Inspector** — vulnerability scans on workloads.
- **Amazon Macie** — PII discovery in S3.

For Bedrock specifically:
- Watch CloudWatch metric `Invocations`, `Throttles`, `UserErrors`, `ServerErrors`, token counts by user.
- Alert on abnormal spikes (could indicate abuse).
- Use CloudTrail to audit who invoked which model.

---

## 9. Prompt & Output Security

- **Prompt injection** — treat user content and retrieved context as untrusted.
- **Output filtering** — guardrails + regex + downstream validators.
- **Do not log secrets** — sanitize prompts before CloudWatch delivery.
- **Rate limiting** at API Gateway or application layer.
- **DDoS protection** — CloudFront + Shield.

---

## 10. Secure Agent Patterns

- Limit each Action Group's Lambda role to the minimum permissions.
- Require **user confirmation** for destructive actions.
- Separate **read** and **write** tools.
- Validate inputs and outputs of tools.
- Timeouts and max-iteration caps to avoid runaway loops.
- Do not return raw tool errors to end users (leak info).

---

## 11. Key vs Data Residency

- **Region selection** is your primary data residency control — choose the region where regulatory data must live.
- **KMS keys** are regional — the key and the data must be in the same region for direct operations.
- Cross-region replication of S3 and model artifacts should be deliberate.

---

## 12. Secure Development Lifecycle (SDL) for GenAI

1. Threat model (STRIDE) the system — include prompt injection, data leakage, jailbreaks.
2. Apply IAM least-privilege.
3. Test guardrails with red-team prompts.
4. Scan dependencies (Amazon Inspector, Dependabot).
5. Code review including security rules.
6. Continuous security monitoring (Security Hub).
7. Incident response runbooks (key rotation, guardrail updates, model rollback).

---

## 13. Incident Response for AI

- Revoke IAM credentials.
- Rotate KMS keys.
- Disable model access in Bedrock console.
- Turn off public endpoints / API keys.
- Analyze CloudTrail for blast radius.
- Notify legal/compliance for PII incidents.
- Update guardrails to block the exploited behavior.
- Post-mortem and lessons learned.

---

## 14. Quick Security Checklist for Any AI Workload

- [ ] KMS customer-managed keys for all data at rest.
- [ ] TLS everywhere; VPC endpoints for internal traffic.
- [ ] Least-privilege IAM, scoped to model ARNs.
- [ ] CloudTrail enabled, logs encrypted in S3.
- [ ] Model invocation logging enabled where needed.
- [ ] Guardrails configured for GenAI endpoints.
- [ ] Macie/Comprehend scanning training data.
- [ ] Secrets in AWS Secrets Manager, not prompts.
- [ ] SCPs restricting non-approved models.
- [ ] Backups of fine-tuning data and model versions.
- [ ] Human review for high-risk decisions.

> Next — [5.2 Compliance Frameworks](./02-Compliance.md)
