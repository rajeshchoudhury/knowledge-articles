# 5.3 — IAM for AI Services

Access control is the most practical security topic on the exam. Know the building blocks and the patterns.

---

## 1. IAM Building Blocks (Recap)

- **Users** — people / apps with long-term credentials (avoid where possible).
- **Groups** — collections of users (for permissions).
- **Roles** — assumed temporarily; preferred for workloads.
- **Policies** — JSON documents: identity-based (attached to principal) or resource-based (attached to resource).
- **Permission boundaries** — maximum permissions a principal *can* have.
- **SCPs** — organization-wide guardrails (via AWS Organizations).
- **ABAC (Attribute-Based Access Control)** — tag-based access control.

---

## 2. Least Privilege for Bedrock

### Action scopes
- Invocation: `bedrock:InvokeModel`, `bedrock:InvokeModelWithResponseStream`, `bedrock:Converse`, `bedrock:ConverseStream`
- Knowledge Bases: `bedrock:CreateKnowledgeBase`, `bedrock:Retrieve`, `bedrock:RetrieveAndGenerate`, `bedrock:AssociateAgentKnowledgeBase`
- Agents: `bedrock:InvokeAgent`, `bedrock:CreateAgent`, `bedrock:UpdateAgent`
- Guardrails: `bedrock:ApplyGuardrail`, `bedrock:CreateGuardrail`, `bedrock:UpdateGuardrail`
- Customization: `bedrock:CreateModelCustomizationJob`, `bedrock:ListCustomModels`, `bedrock:CreateProvisionedModelThroughput`
- Model access admin: `bedrock:GetFoundationModel`, `bedrock:ListFoundationModels`, `bedrock:GetModelCustomizationJob`

### Example: tight allow for a prod chat app
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "bedrock:Converse",
        "bedrock:ConverseStream"
      ],
      "Resource": [
        "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-3-haiku-*",
        "arn:aws:bedrock:us-east-1:123456789012:guardrail/my-prod-guardrail"
      ],
      "Condition": {
        "StringEquals": { "aws:SourceVpc": "vpc-0abc123" }
      }
    }
  ]
}
```

### Example: allow RAG only
```json
{
  "Effect": "Allow",
  "Action": [
    "bedrock:Retrieve",
    "bedrock:RetrieveAndGenerate"
  ],
  "Resource": "arn:aws:bedrock:us-east-1:123456789012:knowledge-base/KB12345"
}
```

### SCPs to restrict models
```json
{
  "Effect": "Deny",
  "Action": "bedrock:InvokeModel",
  "NotResource": [
    "arn:aws:bedrock:*::foundation-model/anthropic.*",
    "arn:aws:bedrock:*::foundation-model/amazon.nova-*"
  ]
}
```

---

## 3. IAM for SageMaker

### Execution Role
- SageMaker assumes this role to train, run processing jobs, host endpoints.
- Needs access to training data (S3), KMS (decrypt), ECR (pull containers), CloudWatch (logs/metrics), VPC networking.
- **Do not grant `*:*`.** Keep it scoped to the bucket, keys, and ECR repos used.

### User roles
- **Data scientists** — Studio access, Experiments, Jumpstart.
- **ML engineers** — create/update endpoints, pipelines.
- **Auditors / risk** — read-only to Model Cards, Model Registry.

### SageMaker resource policies
- Studio user profiles.
- Model registry group access control.

---

## 4. IAM for Amazon Q Business

- Q Business uses **IAM Identity Center** (formerly SSO) for end-user identity.
- Inherits **document-level permissions** from data sources (SharePoint, S3, Confluence) so users see only what they're entitled to.
- Admin roles vs user roles for app settings.
- ACLs are re-checked at query time.

---

## 5. IAM for Amazon Q Developer

- **Identity Center** for enterprise tier (group-based licensing, customization access, shared context).
- **AWS Builder ID** for free/individual tier.
- Admins can configure telemetry opt-out, subscription management, and source code allow-lists.

---

## 6. Cross-Account and Cross-Region Access

- **Resource policies** (S3, KMS) allow other accounts.
- **AssumeRole** pattern for cross-account workloads.
- **VPC endpoints + endpoint policies** to restrict cross-account traversal.
- **RAM (Resource Access Manager)** to share resources (e.g., a Transit Gateway).

---

## 7. Secrets & Keys

- **AWS Secrets Manager** — database passwords, API keys; rotate automatically.
- **AWS Systems Manager Parameter Store** — configuration values (free tier).
- Never put secrets in prompts, environment variables, or code. Fetch at runtime with an IAM role.

---

## 8. Principals to Watch

- **EC2/ECS/EKS instance role** for workloads calling Bedrock.
- **Lambda execution role** for Action Groups and app glue.
- **SageMaker execution role** for training/inference.
- **Bedrock service role** for Knowledge Bases and Agents.
- **Replication / inference profile role** for cross-region Bedrock inference profiles.

---

## 9. Logging & Accountability

- CloudTrail logs every IAM action and API call.
- Model invocation logs (Bedrock) can carry the IAM principal that made the call — attributable to the user or role.
- Protect log integrity with CloudTrail Lake / S3 Object Lock.

---

## 10. Typical Secure RAG Architecture IAM

```
End user ───[JWT/SigV4]──▶ API Gateway
                           │
                           ▼
                        Lambda (role: chat-app)
                           │ bedrock:Converse on claude-haiku
                           │ bedrock:Retrieve on KB-prod
                           │ kms:Decrypt on app-cmk
                           ▼
                        Bedrock
                           │
                           ▼
                 Knowledge Base (role: kb-service)
                           │ s3:GetObject on doc-bucket
                           │ aoss:APIAccessAll on collection
                           ▼
                   OpenSearch Serverless
```

Each principal has only what it needs.

---

## 11. Exam Cues

| Scenario | Answer |
|----------|--------|
| "Restrict Bedrock model access to only Anthropic models org-wide" | **Service Control Policy (SCP) with Deny NotResource**|
| "App must call Bedrock only from inside our VPC" | **VPC endpoint + endpoint policy + IAM `aws:SourceVpce` condition** |
| "Rotate API credentials on a schedule" | **IAM roles (short-lived) + Secrets Manager** |
| "Users should only see their team's documents in Q Business" | **Source ACLs + IAM Identity Center groups** |
| "Prevent data scientists from deploying models to prod" | **Separate IAM role for deployment; Model Registry approval** |
| "Grant temporary access to a contractor" | **IAM role + AssumeRole + external ID** |
| "Prevent fine-tuned model from running on non-approved key" | **KMS key policy + IAM condition on `kms:ViaService` and `kms:EncryptionContext`** |

> Next — [5.4 Data & Model Governance](./04-Governance.md)
