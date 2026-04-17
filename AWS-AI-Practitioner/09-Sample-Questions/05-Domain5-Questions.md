# Domain 5 — Sample Questions (Security, Compliance, Governance)

---

**Q1.** Which AWS service is best for retrieving HIPAA BAA and SOC reports?
- A. AWS Artifact
- B. AWS Config
- C. AWS Security Hub
- D. AWS Audit Manager

<details><summary>Answer</summary>**A.** AWS Artifact is the source for compliance reports and agreements.</details>

---

**Q2.** Which service automates compliance evidence collection against frameworks like HIPAA, PCI DSS, and NIST?
- A. AWS Audit Manager
- B. AWS Artifact
- C. AWS CloudTrail
- D. AWS Glue

<details><summary>Answer</summary>**A.** Audit Manager maps AWS evidence to frameworks.</details>

---

**Q3.** Which is TRUE about data used with Amazon Bedrock foundation models?
- A. It's used to train base FMs.
- B. It stays in the customer's account and is NOT used to train base FMs.
- C. It's sold to third parties.
- D. It's stored globally with no region guarantee.

<details><summary>Answer</summary>**B.** Data stays in your account and is not used to train FMs.</details>

---

**Q4.** Which AWS feature provides **private** connectivity to Bedrock / SageMaker endpoints from a VPC?
- A. NAT Gateway
- B. VPC Interface Endpoint (PrivateLink)
- C. Internet Gateway
- D. Elastic IP

<details><summary>Answer</summary>**B.** PrivateLink via Interface Endpoints.</details>

---

**Q5.** Which is the BEST way to restrict an IAM role to only a specific Bedrock model?
- A. Service Control Policy
- B. Identity policy with `Resource` scoped to the model ARN
- C. Network ACL
- D. IAM password policy

<details><summary>Answer</summary>**B.** Scope Resource in the identity policy; SCPs also help at the org level.</details>

---

**Q6.** Which service records all API calls to AWS (including Bedrock)?
- A. CloudTrail
- B. CloudWatch Metrics
- C. GuardDuty
- D. AWS Config

<details><summary>Answer</summary>**A.** CloudTrail = API audit log.</details>

---

**Q7.** Which AWS service aggregates security findings across services like GuardDuty, Inspector, and Macie?
- A. AWS Security Hub
- B. AWS Audit Manager
- C. AWS Artifact
- D. Amazon EventBridge

<details><summary>Answer</summary>**A.** Security Hub aggregates findings.</details>

---

**Q8.** Which is the correct statement about KMS keys for Bedrock encryption?
- A. Bedrock can't use customer-managed KMS keys.
- B. Customer-managed KMS keys can be configured for sensitive Bedrock features like model customization.
- C. KMS is optional only for SageMaker.
- D. Bedrock encryption is in-cleartext.

<details><summary>Answer</summary>**B.** CMKs are supported; recommended for strict compliance.</details>

---

**Q9.** Which SCP pattern restricts all accounts in an org to only Anthropic and Nova models?
- A. Allow `bedrock:InvokeModel` on all resources
- B. Deny `bedrock:InvokeModel` with `NotResource` listing the allowed model ARNs
- C. Deny everything
- D. Use resource-based policies on S3

<details><summary>Answer</summary>**B.** Deny-NotResource pattern is standard.</details>

---

**Q10.** Which is TRUE about the shared responsibility model for Bedrock?
- A. Customer maintains the foundation model weights.
- B. AWS secures infrastructure and FM weights; customer secures data, IAM, prompts, monitoring.
- C. Customer manages all GPU provisioning.
- D. AWS writes customer IAM policies.

<details><summary>Answer</summary>**B.** Shared model.</details>

---

**Q11.** Which service can detect anomalous AWS API calls / compromised credentials?
- A. Amazon GuardDuty
- B. AWS Config
- C. AWS WAF
- D. Amazon CloudFront

<details><summary>Answer</summary>**A.** GuardDuty = intelligent threat detection.</details>

---

**Q12.** Which of the following is TRUE about model invocation logging in Bedrock?
- A. Enabled by default
- B. Opt-in; can deliver prompts + responses to CloudWatch Logs or S3 for audit
- C. Only logs training data
- D. Requires SageMaker

<details><summary>Answer</summary>**B.** Off by default; customer opts in.</details>

---

**Q13.** Which is the BEST identity solution for Amazon Q Business end-users?
- A. IAM user per person
- B. IAM Identity Center with your IdP
- C. Root account
- D. Anonymous

<details><summary>Answer</summary>**B.** Q Business uses IAM Identity Center.</details>

---

**Q14.** Which of these is TRUE about Amazon Q Business permissions?
- A. It ignores source data ACLs.
- B. It enforces document-level permissions inherited from connected sources at query time.
- C. Everyone sees all documents.
- D. It caches without re-checking ACLs.

<details><summary>Answer</summary>**B.** Per-document permission enforcement.</details>

---

**Q15.** Which is a data residency best practice?
- A. Choose one AWS region and stay in it; control cross-region replication deliberately
- B. Use every region by default
- C. Use AWS China and GovCloud together
- D. Ignore data residency

<details><summary>Answer</summary>**A.** Region is your residency control.</details>

---

**Q16.** Which framework lists **prohibited / high / limited / minimal** risk AI tiers?
- A. NIST AI RMF
- B. EU AI Act
- C. HIPAA
- D. GLBA

<details><summary>Answer</summary>**B.** EU AI Act tiers.</details>

---

**Q17.** Which is TRUE about fine-tuning data stored in S3 for Bedrock?
- A. AWS uses it to improve public models.
- B. It stays in your account and is only used to train your own custom model.
- C. It becomes globally shared.
- D. It cannot be encrypted.

<details><summary>Answer</summary>**B.** Private to your account.</details>

---

**Q18.** Which service is purpose-built for **sensitive data discovery in S3**?
- A. Amazon Macie
- B. Amazon Comprehend
- C. AWS Glue
- D. CloudTrail

<details><summary>Answer</summary>**A.** Macie.</details>

---

**Q19.** Which is the BEST control to enforce org-wide standards across accounts?
- A. IAM user
- B. SCP (Service Control Policy)
- C. Security Group
- D. Route 53 rule

<details><summary>Answer</summary>**B.** SCPs are the organization-level guardrail.</details>

---

**Q20.** Which is TRUE about SageMaker Network Isolation?
- A. It disables all network access from the container, including the internet and AWS service endpoints.
- B. It enables NAT Gateway.
- C. It is required for real-time inference.
- D. It provisions VPC peering.

<details><summary>Answer</summary>**A.** Full network isolation for the container.</details>

---

**Q21.** Which of these is a HIPAA-eligible service?
- A. Amazon Transcribe Medical (under a BAA)
- B. Amazon Polly (under a BAA) — yes actually Polly is HIPAA eligible
- C. Amazon SageMaker (under a BAA)
- D. All of the above

<details><summary>Answer</summary>**D.** All are HIPAA-eligible under a BAA from AWS Artifact.</details>

---

**Q22.** Which of these is the cornerstone of least-privilege access to Bedrock?
- A. Very broad IAM policies
- B. Fine-grained action + resource scoping by model ARN, guardrail, KB, agent
- C. Shared root credentials
- D. No IAM at all

<details><summary>Answer</summary>**B.** Least privilege.</details>

---

**Q23.** Which AWS service logs configuration changes across resources and can enforce compliance rules?
- A. AWS Config
- B. AWS Audit Manager
- C. CloudTrail
- D. Amazon Inspector

<details><summary>Answer</summary>**A.** Config tracks resource config and compliance via Config Rules.</details>

---

**Q24.** Which is the BEST way to avoid leaking secrets into prompts?
- A. Hardcode secrets in the prompt
- B. Fetch secrets at runtime from AWS Secrets Manager using IAM roles; never include secrets in prompts
- C. Base64-encode them in the prompt
- D. Use stop sequences

<details><summary>Answer</summary>**B.** Secrets Manager + IAM.</details>

---

**Q25.** A company needs to ensure cross-region replication of training data is intentional and auditable. Which pair of services helps?
- A. S3 Replication + CloudTrail audit logs + AWS Config rules
- B. Route 53 + CloudFront
- C. DynamoDB + Kinesis
- D. EC2 + ECS

<details><summary>Answer</summary>**A.** S3 replication + CloudTrail + Config ensure controlled + auditable replication.</details>

---

**Q26.** Which of these provides end-to-end **lineage** from dataset → feature → model → deployed endpoint?
- A. SageMaker ML Lineage Tracking
- B. CloudTrail
- C. CloudWatch
- D. Amazon Q

<details><summary>Answer</summary>**A.** ML Lineage Tracking.</details>

---

**Q27.** Which is a correct statement about the GenAI Security Scoping Matrix?
- A. Has 5 scopes from Consumer App (1) through Self-trained (5), with controls scaling accordingly.
- B. Only relevant to Bedrock.
- C. Covers hardware only.
- D. Has 2 scopes.

<details><summary>Answer</summary>**A.** Five scopes: Consumer, Enterprise, Pretrained API, Fine-tuned, Self-trained.</details>

---

**Q28.** An architect wants to ensure only principals in a specific VPC can call Bedrock. Best control?
- A. Bucket policy
- B. VPC Interface Endpoint + endpoint policy + IAM `aws:SourceVpc` or `aws:SourceVpce` condition
- C. NAT Gateway
- D. Route table only

<details><summary>Answer</summary>**B.** Private connectivity + endpoint policy + IAM condition.</details>

---

**Q29.** Which service is AWS's **cryptographic key management** service?
- A. AWS KMS
- B. AWS IAM
- C. AWS Secrets Manager
- D. Amazon Cognito

<details><summary>Answer</summary>**A.** KMS.</details>

---

**Q30.** Which is TRUE about Bedrock **custom models** and KMS?
- A. They cannot be encrypted.
- B. You can use customer-managed KMS keys for customization data and artifacts.
- C. They are only encrypted in EBS.
- D. They never use KMS.

<details><summary>Answer</summary>**B.** KMS CMK support for customization.</details>

---

**Q31.** Which is the BEST way to protect a Lambda-backed Action Group in a Bedrock Agent?
- A. Give it `*:*` IAM permissions
- B. Grant least-privilege IAM; validate inputs; timeouts; log invocations
- C. Disable VPC
- D. Skip input validation

<details><summary>Answer</summary>**B.** Standard secure Lambda practices.</details>

---

**Q32.** Which framework includes **Govern / Map / Measure / Manage** functions?
- A. NIST AI Risk Management Framework (AI RMF)
- B. HIPAA
- C. ISO 27001
- D. PCI DSS

<details><summary>Answer</summary>**A.** NIST AI RMF.</details>

---

**Q33.** Which is TRUE about **data residency** with Bedrock?
- A. Data can move freely across all regions.
- B. Data stays in the selected region; you control cross-region inference profiles if needed.
- C. Data always replicates to us-east-1.
- D. Data is stored on-prem.

<details><summary>Answer</summary>**B.** Regional scoping.</details>

---

**Q34.** Which of the following is the BEST way to protect a Bedrock endpoint from a runaway cost incident?
- A. Ignore usage
- B. Set budgets + cost anomaly alerts; enforce per-role quotas; cap `max_tokens`; batch where possible; monitor token metrics
- C. Use Spot instances
- D. Increase temperature

<details><summary>Answer</summary>**B.** Layered cost governance.</details>

---

**Q35.** Which is an AWS service to identify vulnerabilities in workloads?
- A. Amazon Inspector
- B. AWS Config
- C. CloudTrail
- D. Amazon Polly

<details><summary>Answer</summary>**A.** Inspector.</details>

---

**Q36.** Which of these is TRUE about ISO/IEC 42001?
- A. AWS is certified to it (AI management system).
- B. It's a US federal regulation.
- C. It replaces HIPAA.
- D. It only applies to image models.

<details><summary>Answer</summary>**A.** AWS is ISO 42001 certified.</details>

---

**Q37.** Which is an appropriate classification for a consumer chat app embedded into your product using Bedrock?
- A. Scope 1 (consumer app via SaaS vendor)
- B. Scope 3 (pretrained model via API) — you build the app on Bedrock
- C. Scope 2 (enterprise app) — only when using Q Business/Bedrock Studio for internal data
- D. Scope 5

<details><summary>Answer</summary>**B.** If you build on Bedrock API, it's Scope 3 for the GenAI Security Scoping Matrix.</details>

---

**Q38.** Which is TRUE about PCI DSS for GenAI apps?
- A. Cardholder data should not be sent to LLMs freely; tokenize and keep out of prompts.
- B. PCI-DSS requires LLMs.
- C. Bedrock is not PCI-eligible.
- D. PCI-DSS applies only to hardware.

<details><summary>Answer</summary>**A.** Keep PAN/cardholder data out of prompts; tokenize.</details>

---

**Q39.** Which of these is a typical **post-incident** action if you suspect Bedrock key exposure?
- A. Rotate IAM credentials / KMS keys; disable model access; analyze CloudTrail; update guardrails
- B. Do nothing
- C. Delete customers
- D. Increase max_tokens

<details><summary>Answer</summary>**A.** Standard AWS IR.</details>

---

**Q40.** Which service enables NL BI with role-aware access to dashboards?
- A. Amazon Q in QuickSight (with row/column-level security)
- B. Amazon Kendra
- C. Amazon Transcribe
- D. Amazon DynamoDB

<details><summary>Answer</summary>**A.** Q in QuickSight respects QuickSight's RLS/CLS.</details>

---

**Q41.** Which is TRUE about encrypting training data at rest on S3?
- A. Not possible
- B. Use SSE-KMS with customer-managed keys and bucket policies enforcing encryption
- C. Only SSE-S3 works
- D. KMS is not supported with S3

<details><summary>Answer</summary>**B.** SSE-KMS with CMKs and enforcement policies.</details>

---

**Q42.** Which AWS feature helps ensure all models deployed by an MLOps pipeline are approved?
- A. SageMaker Model Registry approval states integrated with Pipelines
- B. KMS rotation
- C. CloudFront caching
- D. AWS Shield

<details><summary>Answer</summary>**A.** Registry approvals enforce governance.</details>

---

**Q43.** Which is a tactical cost-reduction lever for Bedrock?
- A. Use the most expensive model always
- B. Use smaller/distilled model for the bulk of traffic, batch inference for offline workloads, prompt caching, shorter prompts
- C. Increase `max_tokens`
- D. Disable caching

<details><summary>Answer</summary>**B.** Multiple levers.</details>

---

**Q44.** Which AWS service helps with **data catalog + access governance** for a data lake?
- A. AWS Lake Formation (+ Glue Data Catalog)
- B. Amazon CloudFront
- C. AWS Shield
- D. Amazon Polly

<details><summary>Answer</summary>**A.** Lake Formation + Glue catalog.</details>

---

**Q45.** Which of these is the correct order of steps to onboard a regulated AI use case?
- A. Deploy first, assess later
- B. Business framing → risk + compliance review → data governance → security review → build → responsible AI review → approval → monitor
- C. Build → approve → frame
- D. Deploy → monitor only

<details><summary>Answer</summary>**B.** Standard governance sequence.</details>

---

**Q46.** Which of these is the purpose of SageMaker Model Registry?
- A. Host models in real-time
- B. Version and approve models with states like Pending/Approved/Rejected
- C. Encrypt the EBS volume
- D. Store raw data

<details><summary>Answer</summary>**B.** Version + approve.</details>

---

**Q47.** Which is an example of an IAM `Condition` helpful for Bedrock?
- A. `aws:SourceVpce` restricts calls to a specific VPC endpoint
- B. `aws:Color`
- C. `aws:Topic`
- D. `aws:MaxTokens`

<details><summary>Answer</summary>**A.** Standard network condition keys.</details>

---

**Q48.** Which of these is TRUE about **CloudTrail Lake**?
- A. It provides long-term, queryable storage of CloudTrail events for audit evidence.
- B. It is a vector database.
- C. It replaces IAM.
- D. It is HIPAA-ineligible.

<details><summary>Answer</summary>**A.** Long-term, queryable audit storage.</details>

---

**Q49.** Which is a valid practice to limit blast radius of compromised credentials?
- A. Long-lived access keys shared across teams
- B. Short-lived IAM role sessions, external IDs for cross-account, and least-privilege scoping
- C. Disable IAM
- D. Turn off CloudTrail

<details><summary>Answer</summary>**B.** Temporary credentials + least privilege.</details>

---

**Q50.** Which of these is the BEST governance tool to keep a running inventory of foundation-model approvals for a bank?
- A. A spreadsheet only
- B. SageMaker Model Registry + Model Cards + Audit Manager evidence + CloudTrail API calls
- C. An email chain
- D. No inventory

<details><summary>Answer</summary>**B.** Multiple AWS tools combined for a full audit trail.</details>
