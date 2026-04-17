# Security Cheat Sheet

## IAM Policy Evaluation Flowchart

```
Request arrives
       │
       ▼
┌──────────────────┐    Yes    ┌─────────┐
│ Explicit DENY in │──────────▶│ DENIED  │
│ any policy?      │           └─────────┘
└──────────────────┘
       │ No
       ▼
┌──────────────────┐    Yes    ┌──────────────────┐
│ SCP (Org) allows │──────────▶│ Check next level  │
│ the action?      │           └──────────────────┘
└──────────────────┘                    │
       │ No                             ▼
       ▼                       ┌──────────────────┐    Yes    ┌───────────┐
┌─────────┐                    │ Resource-based    │──────────▶│ ALLOWED   │
│ DENIED  │                    │ policy allows?    │           └───────────┘
└─────────┘                    └──────────────────┘
                                        │ No
                                        ▼
                               ┌──────────────────┐    Yes    ┌───────────┐
                               │ Identity-based    │──────────▶│ ALLOWED   │
                               │ policy allows?    │           └───────────┘
                               └──────────────────┘
                                        │ No
                                        ▼
                               ┌──────────────────┐    Yes    ┌───────────┐
                               │ Permissions       │──────────▶│ ALLOWED   │
                               │ boundary allows?  │           └───────────┘
                               └──────────────────┘
                                        │ No
                                        ▼
                                   ┌─────────┐
                                   │ DENIED  │
                                   └─────────┘
```

**Key rules:**
1. **Explicit deny always wins** — overrides any allow
2. **SCPs** are evaluated first (Organization level boundary)
3. **Resource-based policies** can grant cross-account access independently
4. **Identity-based policies** (user/group/role)
5. **Permissions boundaries** limit maximum permissions
6. **Session policies** (for assumed roles/federated users)
7. **Default: implicit deny** — no permission = denied

---

## Encryption Options Per Service

| Service          | At Rest                          | In Transit                | Key Management           |
|------------------|----------------------------------|---------------------------|--------------------------|
| **S3**           | SSE-S3, SSE-KMS, SSE-C, CSE     | TLS / HTTPS               | S3, KMS, Customer        |
| **EBS**          | AES-256 (KMS-backed)             | Encrypted between EC2↔EBS | KMS                      |
| **EFS**          | KMS encryption                   | TLS mount helper          | KMS                      |
| **RDS**          | KMS (at creation)                | SSL/TLS certificates      | KMS                      |
| **Aurora**       | KMS (at creation)                | SSL/TLS certificates      | KMS                      |
| **DynamoDB**     | AWS owned key, KMS (CMK)         | TLS (default)             | AWS owned, KMS           |
| **Redshift**     | KMS, CloudHSM                    | SSL                       | KMS, CloudHSM            |
| **ElastiCache**  | Redis: KMS. Memcached: No        | Redis: TLS. Memcached: No | KMS (Redis only)         |
| **Lambda**       | KMS (env vars)                   | TLS                       | KMS                      |
| **SQS**          | SSE-SQS, SSE-KMS                 | TLS                       | SQS, KMS                 |
| **SNS**          | SSE-KMS                          | TLS                       | KMS                      |
| **Kinesis**      | SSE-KMS                          | TLS                       | KMS                      |
| **CloudWatch**   | KMS (log groups)                 | TLS                       | KMS                      |

**Exam tip:** "Encrypt an unencrypted RDS/EBS" → Create encrypted snapshot → Restore from it. Cannot enable encryption on existing resource.

---

## KMS Key Types

| Key Type                    | Created By | Managed By | Rotation         | Cost           | Cross-Account |
|-----------------------------|------------|------------|------------------|----------------|---------------|
| **AWS Owned Keys**          | AWS        | AWS        | Varies           | Free           | N/A           |
| **AWS Managed Keys**        | AWS        | AWS        | Auto (1 year)    | Free           | No            |
| **Customer Managed Keys**   | Customer   | Customer   | Optional (configurable) | $1/month + API | Yes      |

**Key aliases:** `aws/s3`, `aws/ebs`, `aws/rds` = AWS managed keys. Custom aliases for CMKs.

**Envelope encryption:** KMS encrypts a data key → data key encrypts data. Used for >4 KB data.

**Key policies:** Every KMS key must have a key policy. Default policy gives root account full access.

---

## KMS vs CloudHSM

| Feature                     | KMS                            | CloudHSM                       |
|-----------------------------|--------------------------------|--------------------------------|
| **Management**              | Shared (multi-tenant)          | Dedicated hardware (single-tenant) |
| **Key storage**             | AWS managed HSMs               | Customer-managed HSMs          |
| **FIPS compliance**         | FIPS 140-2 Level 3*            | FIPS 140-2 Level 3             |
| **Availability**            | Highly available (managed)     | Must deploy in cluster (HA)    |
| **Integration**             | Native AWS service integration | Custom app integration         |
| **Key types**               | Symmetric (AES), Asymmetric (RSA, ECC) | Symmetric, Asymmetric, Session keys |
| **Access control**          | IAM + Key Policies             | HSM users and policies         |
| **Key export**              | Cannot export                  | Can export keys                |
| **SSL/TLS offloading**      | No                             | Yes                            |
| **Oracle TDE**              | No                             | Yes                            |
| **Cost**                    | Per key + API calls            | ~$1.50/hr per HSM              |

*KMS uses FIPS 140-2 Level 3 validated HSMs internally

**Exam tip:** "Dedicated hardware," "full control of keys," "FIPS 140-2 Level 3," "SSL offloading," or "Oracle TDE" → CloudHSM.

---

## Shield Standard vs Shield Advanced

| Feature                     | Shield Standard                | Shield Advanced                |
|-----------------------------|--------------------------------|--------------------------------|
| **Cost**                    | Free (automatic)               | $3,000/month + data transfer   |
| **Protection**              | Layer 3/4 DDoS                 | Layer 3/4/7 DDoS               |
| **Services protected**      | All AWS resources              | EC2, ELB, CloudFront, Global Accelerator, Route 53 |
| **DDoS Response Team**      | No                             | Yes (DRT, 24/7)                |
| **Cost protection**         | No                             | Yes (refund for scaling costs) |
| **Real-time metrics**       | No                             | Yes (CloudWatch)               |
| **Health-based detection**  | No                             | Yes                            |
| **WAF included**            | No                             | Yes (WAF at no extra cost)     |
| **Automatic mitigation**    | Basic                          | Advanced + application layer   |

**Exam tip:** "DDoS cost protection" or "DDoS response team" → Shield Advanced.

---

## Security Services Comparison

| Service           | Purpose                                    | What It Analyzes                          | Output                    |
|-------------------|--------------------------------------------|-------------------------------------------|---------------------------|
| **GuardDuty**     | Threat detection                           | VPC Flow Logs, DNS logs, CloudTrail, S3 data events, EKS audit logs | Findings (threats) |
| **Inspector**     | Vulnerability assessment                    | EC2 instances, ECR images, Lambda functions | Findings (CVEs, network) |
| **Macie**         | Sensitive data discovery                   | S3 buckets                                | PII/sensitive data findings|
| **Detective**     | Root cause investigation                   | GuardDuty findings, VPC Flow Logs, CloudTrail | Visualizations, analysis |
| **Security Hub**  | Central security dashboard                 | Aggregates from all security services     | Compliance scores, findings|
| **Config**        | Resource compliance tracking               | AWS resource configurations               | Compliance rules results  |
| **CloudTrail**    | API activity logging                       | All AWS API calls                         | Event logs                |
| **Access Analyzer**| Identify unintended resource sharing       | IAM policies, S3, KMS, SQS, Lambda, etc. | Findings (external access)|

**Flow:** GuardDuty detects → Detective investigates → Security Hub aggregates → EventBridge triggers remediation

---

## Cognito User Pools vs Identity Pools

| Feature                     | User Pools                     | Identity Pools                 |
|-----------------------------|--------------------------------|--------------------------------|
| **Purpose**                 | Authentication (who are you?)  | Authorization (what can you do?) |
| **Function**                | Sign-up, sign-in, user directory | Provide temporary AWS credentials |
| **Returns**                 | JWT tokens (ID, Access, Refresh) | Temporary AWS credentials (STS) |
| **Federation**              | Social (Google, Facebook, Apple), SAML, OIDC | Cognito User Pools, Social, SAML, OIDC |
| **AWS service access**      | No (just authentication)       | Yes (S3, DynamoDB, etc.)       |
| **MFA**                     | Built-in                       | N/A                            |
| **Customization**           | Hosted UI, Lambda triggers     | IAM role mapping               |
| **Guest access**            | No                             | Yes (unauthenticated roles)    |

**Common pattern:** User Pool (auth) → Identity Pool (get AWS creds) → Access AWS services

**Exam tip:** "Sign in / sign up" → User Pools. "Access S3/DynamoDB from mobile app" → Identity Pools. Usually both together.

---

## Secrets Manager vs Parameter Store

| Feature                     | Secrets Manager                | Systems Manager Parameter Store |
|-----------------------------|--------------------------------|--------------------------------|
| **Purpose**                 | Secrets management             | Config + secrets storage       |
| **Auto rotation**           | Built-in (Lambda-based)        | No built-in rotation           |
| **Cost**                    | $0.40/secret/month + API calls | Free (Standard), $0.05/advanced/month |
| **Max size**                | 64 KB                          | 4 KB (Std) / 8 KB (Adv)       |
| **Cross-account access**    | Via resource policy            | Via IAM (no resource policy)   |
| **Encryption**              | Always encrypted (KMS)         | Optional (KMS for SecureString)|
| **Versioning**              | Built-in                       | Built-in                       |
| **Parameter hierarchy**     | No                             | Yes (/app/db/password)         |
| **CloudFormation**          | Dynamic reference              | Dynamic reference              |
| **Notifications**           | CloudTrail + EventBridge       | CloudTrail + EventBridge       |
| **RDS integration**         | Native (auto-rotation)         | Manual                         |

**Exam tip:** "Automatic rotation" or "RDS password rotation" → Secrets Manager. "Configuration values and parameters" → Parameter Store. "Cost-effective" → Parameter Store.

---

## WAF Rule Types

| Rule Type                   | Purpose                                    | Examples                        |
|-----------------------------|--------------------------------------------|---------------------------------|
| **IP Set**                  | Allow/block specific IPs                   | Block known bad IPs, allow office IPs |
| **Rate-based**              | Block IPs exceeding request rate           | DDoS protection (min 100 req/5 min) |
| **Size constraint**         | Block requests by size                     | Body, URI, query string size    |
| **Geo match**               | Block/allow by country                     | Block traffic from specific countries |
| **Regex match**             | Match patterns in request components       | Block SQL injection patterns    |
| **String match**            | Match specific strings                     | Block specific User-Agents      |
| **Managed Rule Groups**     | Pre-built rules by AWS/partners            | OWASP top 10, Bot control       |
| **SQL injection**           | Detect SQL injection                       | Built-in detection rules        |
| **XSS**                     | Detect cross-site scripting                | Built-in detection rules        |

**WAF can be attached to:** CloudFront, ALB, API Gateway, AppSync, Cognito User Pool

**WAF CANNOT be attached to:** NLB, EC2 directly, Route 53

---

## ACM Integration Points

| Service                     | ACM Integration | Notes                            |
|-----------------------------|-----------------|----------------------------------|
| **CloudFront**              | Yes             | Must be in us-east-1             |
| **ALB**                     | Yes             | Same region as ALB               |
| **NLB**                     | Yes             | TLS listeners                    |
| **API Gateway**             | Yes             | Custom domain names              |
| **Elastic Beanstalk**       | Yes             | Via load balancer                |
| **CloudFormation**          | Yes             | Resource provisioning            |
| **EC2 directly**            | No              | Must use self-managed certs      |

**ACM certificates are FREE** for public certificates. Private CA costs $400/month.

**Validation methods:** DNS validation (recommended, auto-renew) or Email validation.

---

## Cross-Account Access Patterns

| Pattern                     | Use Case                                   | How It Works                    |
|-----------------------------|--------------------------------------------|---------------------------------|
| **IAM Role (AssumeRole)**   | EC2/Lambda in Account A access Account B   | sts:AssumeRole with trust policy|
| **Resource-based Policy**   | S3, SQS, SNS, Lambda, KMS                 | Allow Principal from other account|
| **AWS Organizations SCP**   | Restrict permissions org-wide              | Deny/allow at OU/account level  |
| **RAM (Resource Access Mgr)**| Share subnets, Transit GW, etc.           | Share resources across accounts |
| **S3 Bucket Policy**        | Cross-account S3 access                    | Allow other account's principal |
| **KMS Key Policy**          | Cross-account encryption/decryption        | Allow other account in key policy|

**Exam tip:** Cross-account access generally requires BOTH an IAM policy in the source account AND a resource/trust policy in the destination account.

---

## Compliance Services Mapping

| Compliance Need              | AWS Service                                |
|------------------------------|--------------------------------------------|
| **API audit trail**          | CloudTrail                                 |
| **Resource compliance**      | AWS Config                                 |
| **Data classification**      | Macie                                      |
| **Threat detection**         | GuardDuty                                  |
| **Vulnerability scanning**   | Inspector                                  |
| **Central security view**    | Security Hub                               |
| **Automated remediation**    | Config Rules + SSM Automation / EventBridge + Lambda |
| **Compliance reports**       | Artifact                                   |
| **Encryption key audit**     | KMS (CloudTrail logs key usage)            |
| **Network traffic audit**    | VPC Flow Logs                              |
| **Access analysis**          | IAM Access Analyzer                        |
| **Evidence collection**      | Audit Manager                              |
| **Penetration testing**      | Allowed without approval for 8 services    |

**Penetration testing allowed (no approval):** EC2, RDS, Aurora, CloudFront, API Gateway, Lambda, Lightsail, Elastic Beanstalk.
