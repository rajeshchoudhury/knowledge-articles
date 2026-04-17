# 10 — Security Architecture on AWS

## Complete Guide for AWS Solutions Architect Professional (SAP-C02)

---

## Table of Contents

1. [Defense in Depth on AWS](#1-defense-in-depth-on-aws)
2. [Encryption at Rest Patterns](#2-encryption-at-rest-patterns)
3. [Encryption in Transit](#3-encryption-in-transit)
4. [KMS Deep Dive](#4-kms-deep-dive)
5. [CloudHSM](#5-cloudhsm)
6. [Secrets Manager](#6-secrets-manager)
7. [AWS Certificate Manager](#7-aws-certificate-manager)
8. [DDoS Protection](#8-ddos-protection)
9. [Web Application Security](#9-web-application-security)
10. [Network Security Layers](#10-network-security-layers)
11. [GuardDuty](#11-guardduty)
12. [Security Hub](#12-security-hub)
13. [Inspector](#13-inspector)
14. [Macie](#14-macie)
15. [Detective](#15-detective)
16. [IAM Access Analyzer](#16-iam-access-analyzer)
17. [Incident Response Patterns](#17-incident-response-patterns)
18. [Zero Trust Architecture](#18-zero-trust-architecture)
19. [Exam Scenarios](#19-exam-scenarios)

---

## 1. Defense in Depth on AWS

### Security Layers

```
┌─────────────────────────────────────────────────────────────────┐
│  Layer 1: EDGE                                                   │
│  Route 53, CloudFront, Shield, WAF, Global Accelerator           │
├─────────────────────────────────────────────────────────────────┤
│  Layer 2: VPC PERIMETER                                          │
│  NACLs, Security Groups, Network Firewall, VPC Endpoints         │
├─────────────────────────────────────────────────────────────────┤
│  Layer 3: SUBNET                                                 │
│  Public/Private subnets, NAT Gateway, Route tables               │
├─────────────────────────────────────────────────────────────────┤
│  Layer 4: INSTANCE / CONTAINER                                   │
│  Security Groups, OS hardening, SSM Patch Manager, Inspector     │
├─────────────────────────────────────────────────────────────────┤
│  Layer 5: APPLICATION                                            │
│  WAF, authentication (Cognito), authorization (IAM), input       │
│  validation, API throttling, secrets management                  │
├─────────────────────────────────────────────────────────────────┤
│  Layer 6: DATA                                                   │
│  Encryption at rest (KMS/CloudHSM), encryption in transit (TLS), │
│  access control (IAM/Lake Formation), backup, Macie (PII)        │
└─────────────────────────────────────────────────────────────────┘
```

### Cross-Cutting Security Services

```
┌─────────────────────────────────────────────────────────────────┐
│  DETECT                │  RESPOND               │  GOVERN        │
│                        │                        │                │
│  GuardDuty (threats)   │  Security Hub          │  IAM           │
│  Inspector (vulns)     │  (aggregate findings)  │  Organizations │
│  Macie (data class)    │  EventBridge + Lambda  │  SCPs          │
│  CloudTrail (audit)    │  (automated response)  │  Config Rules  │
│  VPC Flow Logs         │  Systems Manager       │  Access        │
│  Detective (investigate)│ (remediation)          │  Analyzer      │
└─────────────────────────────────────────────────────────────────┘
```

> **Exam Tip:** Security questions are pervasive across the entire exam. Every domain includes security considerations. The defense-in-depth model helps you systematically address each layer.

---

## 2. Encryption at Rest Patterns

### S3 Encryption Options

| Option | Key Management | Who Encrypts | Use Case |
|--------|---------------|-------------|----------|
| **SSE-S3** | AWS-managed S3 key | S3 (server-side) | Default, simplest. No additional cost. |
| **SSE-KMS** | Customer-managed KMS key | S3 (server-side) | Audit trail (CloudTrail), key rotation control, cross-account access control |
| **SSE-C** | Customer-provided key (you send key with each request) | S3 (server-side) | You manage keys outside AWS, S3 doesn't store the key |
| **CSE** | Client-side key (KMS or custom) | Client (before upload) | Data encrypted before reaching AWS, zero trust on S3 |

**S3 Bucket Key (SSE-KMS optimization):**

```
WITHOUT Bucket Key:
  Every object → individual KMS API call → $0.03/10,000 calls

WITH Bucket Key:
  Bucket-level key derived from KMS → encrypts objects locally
  → ~99% reduction in KMS API calls
```

**Default encryption policy:**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyUnencryptedUploads",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::my-bucket/*",
      "Condition": {
        "StringNotEquals": {
          "s3:x-amz-server-side-encryption": "aws:kms"
        }
      }
    }
  ]
}
```

### EBS Encryption

- Encrypts volumes, snapshots, and data in transit between EC2 and EBS
- Uses KMS (aws/ebs default key or CMK)
- Can enable **default encryption** per region (all new volumes encrypted)
- Cannot encrypt an existing unencrypted volume directly — create encrypted snapshot → create volume from snapshot
- Encrypted snapshots can be shared cross-account (if using CMK with appropriate key policy)

### RDS Encryption

- Encrypts storage, automated backups, read replicas, snapshots
- Must be enabled at creation (cannot encrypt existing unencrypted DB)
- **Workaround:** Snapshot → Copy snapshot (enable encryption) → Restore from encrypted snapshot
- Read replicas must use the same encryption key type (KMS)
- Cross-region read replicas use different KMS key (region-specific)

### DynamoDB Encryption

| Option | Description |
|--------|------------|
| **AWS owned key** | Default, free, no CloudTrail audit |
| **AWS managed key** (`aws/dynamodb`) | Free, CloudTrail audit |
| **Customer managed key** | Full control, rotation, cross-account, CloudTrail |

### Redshift Encryption

- AES-256 encryption
- KMS or CloudHSM for key management
- Enable at cluster creation or modify to enable (triggers migration)
- Encrypted clusters: all data, backups, and snapshots encrypted

> **Exam Tip:** Know which services require encryption at creation vs. can be enabled later. RDS and Redshift = at creation. EBS = can enable default encryption. S3 = can enable anytime. If the question involves "encrypt existing RDS database," the answer is snapshot → copy (encrypt) → restore.

---

## 3. Encryption in Transit

### TLS Everywhere

| Service | TLS Support |
|---------|------------|
| **ELB (ALB/NLB)** | TLS termination at load balancer; backend can be HTTP or HTTPS |
| **API Gateway** | TLS by default on all API endpoints |
| **CloudFront** | TLS between viewer↔CloudFront and CloudFront↔origin |
| **RDS** | TLS supported, can enforce with `rds.force_ssl` parameter |
| **DynamoDB** | TLS in transit (always, HTTPS endpoints) |
| **S3** | TLS in transit (enforce with bucket policy `aws:SecureTransport`) |
| **ElastiCache** | In-transit encryption optional (must enable at creation for Redis) |
| **MSK** | TLS between clients and brokers, TLS between brokers |
| **OpenSearch** | Node-to-node encryption, HTTPS required |

**Enforce TLS on S3:**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyHTTP",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::my-bucket",
        "arn:aws:s3:::my-bucket/*"
      ],
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
```

### ACM (AWS Certificate Manager) Integration

```
ACM ──── Free public cert ────▶ ALB (TLS termination)
     ──── Free public cert ────▶ CloudFront
     ──── Free public cert ────▶ API Gateway
     ──── Free public cert ────▶ NLB (TLS listener)
     ──── Private cert ────────▶ Internal services (mTLS)
```

### Mutual TLS (mTLS)

Both client and server authenticate each other:

```
Client ◀──── TLS Handshake ────▶ Server
  │          (server cert +         │
  │           client cert)          │
  │                                 │
  └── Presents client certificate   │
      Server verifies client cert ──┘
```

**AWS implementation:**
- **API Gateway:** mTLS with custom truststore (S3)
- **App Mesh:** mTLS between services (Envoy proxy)
- **NLB:** mTLS with backend targets
- **ACM Private CA:** Issue client certificates

### VPN Encryption

| VPN Type | Encryption |
|----------|-----------|
| **Site-to-Site VPN** | IPsec (AES-256-GCM, AES-256-CBC) |
| **Client VPN** | OpenVPN (TLS) |
| **Direct Connect** | NOT encrypted by default |

### Direct Connect MACsec

Layer 2 encryption for Direct Connect:

```
On-Premises ──── Direct Connect ──── AWS
              [MACsec encryption]
              (802.1AE, AES-256-GCM)
              Available on 10 Gbps and 100 Gbps connections
```

**Alternative:** Run VPN over Direct Connect for Layer 3 encryption (IPsec).

> **Exam Tip:** Direct Connect is NOT encrypted by default. For encryption: MACsec (Layer 2, dedicated connections 10/100 Gbps) or Site-to-Site VPN over Direct Connect (Layer 3, any connection speed).

---

## 4. KMS Deep Dive

### Key Hierarchy

```
┌──────────────────────────────────────────────────────────┐
│  AWS KMS                                                  │
│                                                           │
│  ┌──────────────────────┐                                 │
│  │ Customer Master Key  │  (CMK / KMS Key)                │
│  │ (never leaves KMS)   │  Used to generate/encrypt       │
│  │                      │  data keys                      │
│  └──────────┬───────────┘                                 │
│             │                                             │
│             │ GenerateDataKey                              │
│             ▼                                             │
│  ┌──────────────────────┐                                 │
│  │ Data Encryption Key  │  Plaintext DEK + Encrypted DEK  │
│  │ (DEK)                │  Plaintext used to encrypt data │
│  │                      │  then DISCARDED from memory     │
│  │                      │  Encrypted DEK stored with data │
│  └──────────────────────┘                                 │
│                                                           │
│  Envelope Encryption:                                     │
│  Data ←encrypted by→ DEK ←encrypted by→ CMK              │
└──────────────────────────────────────────────────────────┘
```

### Key Types

| Type | Description | Management | Cost |
|------|------------|-----------|------|
| **AWS owned** | AWS manages entirely; shared across accounts | AWS | Free |
| **AWS managed** | `aws/service` keys (e.g., `aws/s3`, `aws/ebs`) | AWS (auto-rotation every year) | Free (API calls charged) |
| **Customer managed** | You create and manage | You (policies, rotation, enable/disable) | $1/month + API calls |

### Symmetric vs Asymmetric Keys

| Feature | Symmetric (AES-256) | Asymmetric (RSA, ECC) |
|---------|--------------------|--------------------|
| **Operations** | Encrypt + Decrypt | Sign + Verify, Encrypt + Decrypt |
| **Key material** | Never leaves KMS | Public key downloadable |
| **Use case** | Envelope encryption (most services) | External systems that can't call KMS, digital signatures |
| **Cross-service** | All AWS services | Limited AWS service support |

### Key Policies

Every KMS key has a key policy (resource-based policy). Unlike most AWS resources, **IAM policies alone are not sufficient** — the key policy must also grant access.

**Default key policy (allows account-level access):**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Enable IAM policies",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::123456789012:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    }
  ]
}
```

**Cross-account key access:**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowCrossAccountUse",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::222233334444:root"
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowCrossAccountGrant",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::222233334444:root"
      },
      "Action": [
        "kms:CreateGrant",
        "kms:ListGrants",
        "kms:RevokeGrant"
      ],
      "Resource": "*",
      "Condition": {
        "Bool": {
          "kms:GrantIsForAWSResource": "true"
        }
      }
    }
  ]
}
```

### Grants

Programmatic, temporary permissions on KMS keys:

```
KMS Key ←── Grant ──→ Grantee Principal
                       (specific operations like Decrypt)
                       
Use case: AWS service needs temporary access to a key
  e.g., EBS creates a grant to decrypt a volume key
```

### ViaService Condition

Restrict key usage to specific AWS services:

```json
{
  "Condition": {
    "StringEquals": {
      "kms:ViaService": [
        "s3.us-east-1.amazonaws.com",
        "ebs.us-east-1.amazonaws.com"
      ]
    }
  }
}
```

This ensures the key can only be used through S3 or EBS, not directly via KMS API.

### Multi-Region Keys

```
┌──────────────────┐          ┌──────────────────┐
│ us-east-1        │          │ eu-west-1         │
│                  │          │                   │
│ Primary Key      │──────────│ Replica Key       │
│ mrk-abc123...    │  same    │ mrk-abc123...     │
│                  │  key ID  │                   │
│ Encrypt here ────┼──────────│── Decrypt here    │
│                  │          │                   │
└──────────────────┘          └──────────────────┘
```

- Same key material in multiple regions
- Same key ID across regions
- Encrypt in one region, decrypt in another without cross-region API calls
- Use cases: global DynamoDB tables, cross-region disaster recovery, global S3 replication with client-side encryption

### Key Rotation

| Rotation Type | Symmetric CMK | Asymmetric CMK | AWS Managed |
|--------------|---------------|----------------|-------------|
| **Automatic** | Optional (every 90–2560 days, configurable) | Not supported | Every year (mandatory) |
| **Manual** | Create new key, update alias | Create new key, update alias | N/A |
| **On-demand** | Trigger immediate rotation | Not supported | N/A |

Automatic rotation keeps the same key ID; old key material retained for decryption of previously encrypted data. New data encrypted with new material.

### Imported Key Material

Bring your own key material into KMS:

```
1. Create CMK with no key material (Origin: EXTERNAL)
2. Download wrapping key (public key) from KMS
3. Encrypt your key material with wrapping key
4. Import encrypted key material into KMS
```

**Limitations:**
- No automatic rotation (must manually re-import)
- Can set expiration date
- Can delete key material without deleting the CMK
- Not available for asymmetric keys
- Cannot be used with custom key stores

### Custom Key Store (CloudHSM)

KMS keys backed by your CloudHSM cluster:

```
┌──────────────────┐          ┌──────────────────┐
│ AWS KMS          │          │ CloudHSM Cluster │
│                  │          │                   │
│ Custom Key Store │──────────│ HSM instances     │
│ (KMS key backed  │ via VPC  │ (key material    │
│  by CloudHSM)    │ endpoint │  stored here)     │
│                  │          │                   │
└──────────────────┘          └──────────────────┘
```

Use case: Regulatory requirement that key material must be in a FIPS 140-2 Level 3 validated HSM.

> **Exam Tip:** KMS key policy is ALWAYS required (IAM alone is insufficient). ViaService = restrict to specific services. Multi-region keys = encrypt in one region, decrypt in another. Custom key store = regulatory requirement for HSM-backed keys.

---

## 5. CloudHSM

### Architecture

```
┌──────────────────────────────────────────────────────────────┐
│  Your VPC                                                     │
│                                                               │
│  ┌──────────────────────────────────────────────────────┐     │
│  │  CloudHSM Cluster                                     │     │
│  │                                                       │     │
│  │  AZ-a              AZ-b              AZ-c             │     │
│  │  ┌──────────┐      ┌──────────┐      ┌──────────┐    │     │
│  │  │ HSM      │◀────▶│ HSM      │◀────▶│ HSM      │    │     │
│  │  │ (FIPS    │ sync │ (FIPS    │ sync │ (FIPS    │    │     │
│  │  │  140-2   │      │  140-2   │      │  140-2   │    │     │
│  │  │  Level 3)│      │  Level 3)│      │  Level 3)│    │     │
│  │  └──────────┘      └──────────┘      └──────────┘    │     │
│  │                                                       │     │
│  │  ENIs in your VPC subnets                             │     │
│  └──────────────────────────────────────────────────────┘     │
│                                                               │
│  ┌──────────────┐                                             │
│  │ EC2 Instance │── CloudHSM Client ── ENI ── HSM             │
│  │ (application)│                                             │
│  └──────────────┘                                             │
└──────────────────────────────────────────────────────────────┘
```

### KMS vs CloudHSM

| Feature | KMS | CloudHSM |
|---------|-----|----------|
| **Management** | Fully managed | You manage HSMs (AWS manages hardware) |
| **Key control** | Shared tenancy (logical isolation) | Single-tenant, dedicated hardware |
| **FIPS validation** | FIPS 140-2 Level 2 (some Level 3) | FIPS 140-2 Level 3 |
| **Key types** | Symmetric (AES-256), Asymmetric (RSA, ECC) | Symmetric, Asymmetric, Session keys |
| **Integration** | Native with 100+ AWS services | Custom integration via PKCS#11, JCE, OpenSSL |
| **Availability** | Fully managed HA | You deploy across AZs (min 2 HSMs recommended) |
| **Cost** | $1/key/month + API calls | ~$1.60/HSM/hour (~$1,168/month) |
| **Use case** | Most AWS encryption needs | Regulatory requirements, Oracle TDE, SSL/TLS offloading |

### CloudHSM Use Cases

| Use Case | Description |
|----------|------------|
| **Regulatory compliance** | FIPS 140-2 Level 3 required (PCI DSS, HIPAA) |
| **Oracle TDE** | Oracle Transparent Data Encryption needs direct HSM access |
| **SSL/TLS offloading** | Store private keys in HSM, offload TLS from web servers |
| **Code signing** | Sign code artifacts with HSM-protected keys |
| **Key storage for KMS** | Custom Key Store — KMS keys backed by CloudHSM |
| **Certificate Authority** | Issue certificates with HSM-protected CA keys |
| **Tokenization** | Generate and store tokens for PCI compliance |

> **Exam Tip:** CloudHSM = FIPS 140-2 Level 3, single tenant, you own the keys. KMS = FIPS 140-2 Level 2 (mostly), multi-tenant, AWS manages. If the question mentions "regulatory requirement for Level 3" or "you must have exclusive control of keys," CloudHSM is the answer.

---

## 6. Secrets Manager

### Architecture

```
┌──────────┐    GetSecretValue    ┌──────────────────┐
│ Lambda / │──────────────────────│ Secrets Manager  │
│ ECS Task │                      │                  │
│ EC2      │                      │ Secret:          │
└──────────┘                      │ {                │
                                  │   "username": "x"│
                                  │   "password": "y"│
                                  │ }                │
                                  │                  │
                                  │ Encrypted with   │
                                  │ KMS key          │
                                  └──────────────────┘
```

### Automatic Rotation

```
┌──────────────────────────────────────────────────────────┐
│  Rotation Process                                         │
│                                                           │
│  Secrets Manager ──── triggers ────▶ Lambda Function      │
│  (on schedule)                      (rotation function)   │
│                                           │               │
│                                    ┌──────┼──────┐        │
│                                    ▼      ▼      ▼        │
│                               createSecret  setSecret     │
│                               testSecret    finishSecret  │
│                                    │                      │
│                                    ▼                      │
│                              Database (RDS, Redshift,     │
│                              DocumentDB, etc.)            │
│                              Password updated              │
└──────────────────────────────────────────────────────────┘
```

**Rotation schedule:** Rate (e.g., every 30 days) or cron expression.

**Built-in rotation support:** RDS (MySQL, PostgreSQL, Oracle, SQL Server, MariaDB), Aurora, Redshift, DocumentDB.

**Custom rotation:** Any secret via custom Lambda function (4-step process: createSecret, setSecret, testSecret, finishSecret).

### Cross-Account Access

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::222233334444:role/AppRole"
      },
      "Action": "secretsmanager:GetSecretValue",
      "Resource": "*"
    }
  ]
}
```

Requires BOTH:
1. Resource policy on the secret (above)
2. IAM policy on the consuming role
3. KMS key policy (if using CMK) must allow cross-account decrypt

### Multi-Region Secrets

Replicate secrets across regions for DR and low-latency access:

```
Primary Secret (us-east-1) ──── replication ────▶ Replica (eu-west-1)
                                                  Replica (ap-southeast-1)
```

- Automatic sync: changes to primary replicated to all replicas
- Replica can be promoted to primary during DR
- Same secret value, different ARNs per region

> **Exam Tip:** Secrets Manager = automatic rotation (native for RDS) + multi-region. SSM Parameter Store = simpler, cheaper, no rotation. If the question mentions "automatic credential rotation," Secrets Manager is the answer.

---

## 7. AWS Certificate Manager

### Public Certificates

```
Request cert ──▶ Validate domain ──▶ Issue cert ──▶ Deploy to AWS service
                     │
               ┌─────┼─────┐
               ▼           ▼
          DNS validation   Email validation
          (CNAME record)   (email to domain admin)
```

| Feature | Description |
|---------|------------|
| **Cost** | Free for public certificates |
| **Validation** | DNS (recommended, auto-renewal) or Email |
| **Auto-renewal** | Yes (if DNS validated and cert is in use) |
| **Supported services** | ALB, NLB, CloudFront, API Gateway, Elastic Beanstalk, App Runner |
| **Export** | Cannot export private key (cert stays in AWS) |
| **Regions** | CloudFront requires cert in us-east-1; ALB requires cert in same region |

### Private CA (ACM Private Certificate Authority)

Issue private certificates for internal services:

```
┌──────────────────────────────────────────────────────────┐
│  ACM Private CA                                           │
│                                                           │
│  Root CA ──── Subordinate CA ──── End Entity Certificates │
│                                                           │
│  Use cases:                                               │
│  - mTLS between microservices                             │
│  - IoT device certificates                                │
│  - Internal web applications                              │
│  - Code signing                                           │
│  - VPN authentication                                     │
│                                                           │
│  Cost: $400/month per CA + per-cert fee                   │
└──────────────────────────────────────────────────────────┘
```

### Certificate for CloudFront

```
IMPORTANT: CloudFront certificates MUST be in us-east-1

Client ──── TLS ────▶ CloudFront ──── TLS ────▶ ALB (origin)
            │                                     │
       ACM cert                              ACM cert
       (us-east-1)                           (origin region)
```

> **Exam Tip:** ACM public certs are free and auto-renew with DNS validation. Private CA = $400/month, for internal mTLS. CloudFront certs must be in us-east-1. ACM certs cannot be exported (if you need to export, use ACM Private CA or third-party).

---

## 8. DDoS Protection

### Shield Standard vs Shield Advanced

| Feature | Shield Standard | Shield Advanced |
|---------|----------------|-----------------|
| **Cost** | Free (all AWS accounts) | $3,000/month (1-year commitment) |
| **Protection** | Layer 3/4 (network/transport) | Layer 3/4/7 (including application layer) |
| **Resources** | All AWS resources | CloudFront, Route 53, ALB, NLB, Elastic IP, Global Accelerator |
| **DRT Access** | No | Yes (DDoS Response Team) |
| **Cost Protection** | No | Yes (reimbursement for scaling costs during DDoS) |
| **WAF Integration** | No | Yes (free WAF for Shield Advanced resources) |
| **Health Checks** | No | Yes (Route 53 health checks for proactive engagement) |
| **Visibility** | Basic CloudWatch | Real-time metrics, attack forensics |
| **SLA** | No | 99.999% for CloudFront/Route 53 |

### DDoS Protection Architecture

```
┌────────────────────────────────────────────────────────────────┐
│                                                                 │
│  Internet                                                       │
│     │                                                           │
│     ▼                                                           │
│  ┌──────────────┐  Shield Standard (automatic, free)            │
│  │ Route 53     │  DDoS protection on DNS                       │
│  └──────┬───────┘                                               │
│         │                                                       │
│         ▼                                                       │
│  ┌──────────────┐  Shield Advanced + WAF                        │
│  │ CloudFront   │  Layer 7 protection, rate limiting            │
│  └──────┬───────┘  Bot control, IP reputation                   │
│         │                                                       │
│         ▼                                                       │
│  ┌──────────────┐  Shield Advanced                              │
│  │ ALB          │  Auto-scaling behind CloudFront               │
│  └──────┬───────┘                                               │
│         │                                                       │
│         ▼                                                       │
│  ┌──────────────┐  Security Groups                              │
│  │ EC2/ECS/EKS  │  Only allow ALB traffic                       │
│  └──────────────┘                                               │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

### Best Practices

1. **Use CloudFront** as the entry point — absorbs DDoS at the edge
2. **Enable Shield Advanced** on all internet-facing resources
3. **WAF rate-based rules** to block HTTP floods
4. **Route 53** — Shield Standard automatically protects DNS
5. **Auto Scaling** — absorb traffic spikes
6. **Health-based DDoS detection** — Route 53 health checks for proactive DRT engagement
7. **Elastic IP** with Shield Advanced — protected IP for NLB/EC2

> **Exam Tip:** If the question mentions "DDoS protection with cost protection" or "DDoS Response Team," the answer is Shield Advanced. For architecture: CloudFront (edge) → WAF (Layer 7) → ALB (scaling) → Shield Advanced on all.

---

## 9. Web Application Security

### AWS WAF Architecture

```
┌──────────────────────────────────────────────────────────────┐
│  AWS WAF                                                      │
│                                                               │
│  Web ACL:                                                     │
│  ┌────────────────────────────────────────────────────────┐   │
│  │ Rule 1 (Priority 1): AWS Managed - Core Rule Set       │   │
│  │ → Block known bad inputs (XSS, SQLi, etc.)             │   │
│  │                                                        │   │
│  │ Rule 2 (Priority 2): AWS Managed - Known Bad Inputs    │   │
│  │ → Block additional patterns                            │   │
│  │                                                        │   │
│  │ Rule 3 (Priority 3): Rate-based rule                   │   │
│  │ → If > 2000 requests/5 min from same IP → BLOCK        │   │
│  │                                                        │   │
│  │ Rule 4 (Priority 4): IP Set - Block list               │   │
│  │ → Block known bad IPs                                  │   │
│  │                                                        │   │
│  │ Rule 5 (Priority 5): Geo restriction                   │   │
│  │ → Block traffic from specific countries                │   │
│  │                                                        │   │
│  │ Rule 6 (Priority 6): Custom rule                       │   │
│  │ → Block if URI path contains '/admin' AND              │   │
│  │   source IP NOT in office IP set                       │   │
│  │                                                        │   │
│  │ Default Action: ALLOW                                   │   │
│  └────────────────────────────────────────────────────────┘   │
│                                                               │
│  Attached to: CloudFront, ALB, API Gateway, AppSync,          │
│               Cognito User Pool, App Runner, Verified Access   │
└──────────────────────────────────────────────────────────────┘
```

### WAF Rule Types

| Type | Description | Example |
|------|------------|---------|
| **Regular rules** | Match conditions (IP, string, regex, size, geo, SQL injection, XSS) | Block if body contains SQLi pattern |
| **Rate-based rules** | Count requests from a source and block if exceeds threshold | Block IP if > 2000 req/5min |
| **Rule groups** | Reusable collection of rules | AWS Managed Rules, Marketplace rules |

### AWS Managed Rule Groups

| Rule Group | Protection |
|-----------|-----------|
| **Core Rule Set (CRS)** | OWASP Top 10 (XSS, SQLi, path traversal) |
| **Known Bad Inputs** | Exploits, vulnerable software patterns |
| **SQL Injection** | Specialized SQL injection detection |
| **Linux/Windows OS** | OS-specific exploit patterns |
| **PHP/WordPress** | CMS-specific vulnerabilities |
| **IP Reputation** | AWS threat intelligence IP block list |
| **Anonymous IP** | VPN, proxy, Tor exit nodes |
| **Bot Control** | Bot detection and management |
| **Account Takeover Prevention (ATP)** | Credential stuffing, brute force |
| **Account Creation Fraud Prevention (ACFP)** | Fake account detection |

### Bot Control

```
WAF Bot Control:
┌──────────────────────────────────────────────┐
│                                               │
│  Common Bots (free tier):                     │
│  - Identify verified bots (Googlebot, etc.)   │
│  - Block non-verified common bots             │
│                                               │
│  Targeted Bots (paid tier):                   │
│  - Advanced ML-based bot detection            │
│  - Browser fingerprinting                     │
│  - CAPTCHA/Challenge integration              │
│  - Silent Challenge (invisible to users)      │
│                                               │
└──────────────────────────────────────────────┘
```

### WAF Logging

```
WAF Logs → Kinesis Data Firehose → S3 (full logs)
                                 → OpenSearch (analysis)
        → CloudWatch Logs
        → S3 (direct)
```

### Cross-Account WAF

Use AWS Firewall Manager to manage WAF rules across multiple accounts:

```
┌──────────────────────────────────────────────────────────────┐
│  AWS Firewall Manager (Organizations management account)      │
│                                                               │
│  Security Policy:                                             │
│  "Apply Core Rule Set to all ALBs in all accounts"            │
│                                                               │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐     │
│  │ Account A│  │ Account B│  │ Account C│  │ Account D│     │
│  │ WAF ACL  │  │ WAF ACL  │  │ WAF ACL  │  │ WAF ACL  │     │
│  │ (auto-   │  │ (auto-   │  │ (auto-   │  │ (auto-   │     │
│  │ applied) │  │ applied) │  │ applied) │  │ applied) │     │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘     │
└──────────────────────────────────────────────────────────────┘
```

Firewall Manager also manages: Shield Advanced, Security Groups, Network Firewall, Route 53 Resolver DNS Firewall.

> **Exam Tip:** WAF = Layer 7 protection (HTTP/HTTPS). Attach to CloudFront/ALB/API Gateway. Rate-based rules for DDoS at Layer 7. Managed rules for OWASP. Firewall Manager for multi-account WAF management.

---

## 10. Network Security Layers

### Security Groups vs NACLs

| Feature | Security Groups | NACLs |
|---------|----------------|-------|
| **Level** | Instance/ENI | Subnet |
| **State** | Stateful (return traffic auto-allowed) | Stateless (must explicitly allow return) |
| **Rules** | Allow only | Allow and Deny |
| **Evaluation** | All rules evaluated | Rules evaluated in order (lowest number first) |
| **Default** | Deny all inbound, allow all outbound | Allow all inbound and outbound |
| **Association** | Multiple SGs per ENI | One NACL per subnet |

### Network Firewall

Managed firewall for VPC-level traffic inspection:

```
┌──────────────────────────────────────────────────────────────┐
│  VPC                                                          │
│                                                               │
│  Internet GW                                                  │
│      │                                                        │
│      ▼                                                        │
│  ┌──────────────────┐                                         │
│  │ Firewall Subnet  │  Network Firewall Endpoint              │
│  │ (AZ-a)           │                                         │
│  └────────┬─────────┘                                         │
│           │                                                   │
│           ▼                                                   │
│  ┌──────────────────┐                                         │
│  │ Public Subnet    │  NAT GW / ALB                           │
│  │ (AZ-a)           │                                         │
│  └────────┬─────────┘                                         │
│           │                                                   │
│           ▼                                                   │
│  ┌──────────────────┐                                         │
│  │ Private Subnet   │  Application servers                    │
│  │ (AZ-a)           │                                         │
│  └──────────────────┘                                         │
└──────────────────────────────────────────────────────────────┘
```

**Capabilities:**
- Stateful inspection (5-tuple matching)
- Intrusion detection/prevention (IDS/IPS) using Suricata rules
- Domain-based filtering (allow/deny specific domains)
- TLS inspection (decrypt, inspect, re-encrypt)
- Custom Suricata rules for deep packet inspection

| Feature | Security Groups | NACLs | Network Firewall |
|---------|----------------|-------|-----------------|
| **Granularity** | Instance | Subnet | VPC |
| **Inspection** | L3/L4 | L3/L4 | L3/L4/L7 (deep packet) |
| **Domain filtering** | No | No | Yes |
| **IDS/IPS** | No | No | Yes |
| **TLS inspection** | No | No | Yes |
| **Cost** | Free | Free | ~$0.395/hr/endpoint + data |

### VPC Flow Logs

```
Source: VPC / Subnet / ENI
   │
   ▼
Flow Log Record:
2 123456789012 eni-abc123 10.0.1.5 52.94.76.7 49321 443 6 15 6780 1672531200 1672531260 ACCEPT OK

Fields: version account eni src-ip dst-ip src-port dst-port protocol packets bytes start end action status
```

**Destinations:**
- CloudWatch Logs
- S3
- Kinesis Data Firehose

**Custom fields (v5):** vpc-id, subnet-id, instance-id, pkt-srcaddr, pkt-dstaddr, flow-direction, traffic-path.

### Traffic Mirroring

Copy network traffic for deep inspection:

```
┌──────────────┐    Mirror    ┌──────────────────────┐
│ Source ENI   │──────────────│ Target               │
│ (production) │   (copies    │ (IDS/IPS appliance   │
│              │    packets)  │  or NLB → instances) │
└──────────────┘              └──────────────────────┘
```

Use cases: intrusion detection, content inspection, forensics, troubleshooting.

> **Exam Tip:** Network Firewall = VPC-level deep packet inspection with IDS/IPS. For domain filtering of outbound traffic → Network Firewall or DNS Firewall. For port/protocol filtering → Security Groups + NACLs. For traffic inspection/forensics → Traffic Mirroring.

---

## 11. GuardDuty

### Architecture

```
┌──────────────────────────────────────────────────────────────┐
│  Amazon GuardDuty                                             │
│                                                               │
│  Data Sources:                                                │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐        │
│  │ CloudTrail   │  │ VPC Flow     │  │ DNS Logs     │        │
│  │ Events       │  │ Logs         │  │              │        │
│  └──────────────┘  └──────────────┘  └──────────────┘        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐        │
│  │ S3 Data      │  │ EKS Audit   │  │ Lambda       │        │
│  │ Events       │  │ Logs         │  │ Network      │        │
│  └──────────────┘  └──────────────┘  └──────────────┘        │
│  ┌──────────────┐  ┌──────────────┐                          │
│  │ RDS Login    │  │ EBS Malware  │                          │
│  │ Activity     │  │ Scan         │                          │
│  └──────────────┘  └──────────────┘                          │
│                                                               │
│  ML + Threat Intelligence → Findings                          │
│                                │                              │
│                          ┌─────▼─────┐                        │
│                          │ EventBridge│                        │
│                          └─────┬─────┘                        │
│                                │                              │
│                    ┌───────────┼───────────┐                  │
│                    ▼           ▼           ▼                  │
│              Lambda       SNS         Security Hub            │
│              (auto-       (alert)     (aggregate)             │
│              remediate)                                        │
└──────────────────────────────────────────────────────────────┘
```

### Finding Types

| Category | Examples |
|----------|---------|
| **EC2** | Cryptocurrency mining, C&C communication, port scanning, unusual traffic |
| **IAM** | Unusual API calls from unusual location, impossible travel, anomalous behavior |
| **S3** | Unusual data access patterns, S3 publicly accessible, anonymous access |
| **EKS** | Privileged container, anonymous authentication, exposed Kubernetes dashboard |
| **Lambda** | Network activity from Lambda to known malicious IP |
| **RDS** | Anomalous login activity, brute force attempts |
| **Malware** | EBS volume scan detects malware |

### Protection Plans

| Plan | What It Detects |
|------|----------------|
| **S3 Protection** | S3 data plane events (object-level), anomalous access |
| **EKS Audit Log Monitoring** | Kubernetes API activity, suspicious pods |
| **EKS Runtime Monitoring** | OS-level activity in EKS containers |
| **Lambda Protection** | Suspicious network activity from Lambda functions |
| **RDS Protection** | Anomalous database login attempts |
| **Malware Protection** | Malware on EBS volumes (triggered by other findings or on-demand) |

### Multi-Account with Organizations

```
GuardDuty Administrator Account
├── Member Account 1 (auto-enabled)
├── Member Account 2 (auto-enabled)
├── Member Account 3 (auto-enabled)
└── ... (all org accounts)

Centralized view of findings across all accounts.
```

> **Exam Tip:** GuardDuty = threat detection (ML + threat intelligence). No agents required — reads logs directly. Always enable in all accounts/regions. Automated remediation via EventBridge → Lambda.

---

## 12. Security Hub

### Architecture

```
┌──────────────────────────────────────────────────────────────┐
│  AWS Security Hub                                             │
│                                                               │
│  Finding Sources:                                             │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐              │
│  │ GuardDuty  │  │ Inspector  │  │ Macie      │              │
│  └─────┬──────┘  └─────┬──────┘  └─────┬──────┘              │
│        │               │               │                      │
│        └───────────────┼───────────────┘                      │
│                        ▼                                      │
│  ┌────────────────────────────────────────────────┐           │
│  │  Security Hub (AWS Security Finding Format)     │           │
│  │                                                 │           │
│  │  Standards:                                     │           │
│  │  ├── AWS Foundational Security Best Practices   │           │
│  │  ├── CIS AWS Foundations Benchmark              │           │
│  │  ├── PCI DSS v3.2.1                             │           │
│  │  ├── NIST 800-53                                │           │
│  │  └── SOC 2                                      │           │
│  │                                                 │           │
│  │  Compliance Score: 87%                          │           │
│  └────────────────────────────────────────────────┘           │
│                        │                                      │
│                        ▼                                      │
│  ┌────────────────────────────────────────────────┐           │
│  │  Automated Response                             │           │
│  │  EventBridge → Lambda → Remediate               │           │
│  │                                                 │           │
│  │  Custom Actions → EventBridge → SIEM/Ticket     │           │
│  └────────────────────────────────────────────────┘           │
└──────────────────────────────────────────────────────────────┘
```

### Cross-Account Aggregation

```
Organization:
┌──────────────────────────────────────────────┐
│  Delegated Admin Account (Security Hub admin) │
│                                               │
│  Aggregates findings from:                    │
│  ├── Account A (us-east-1, eu-west-1)         │
│  ├── Account B (us-east-1, eu-west-1)         │
│  ├── Account C (us-east-1, eu-west-1)         │
│  └── ... all org accounts, all regions         │
│                                               │
│  Cross-Region Aggregation:                    │
│  All regions → Single aggregation region       │
└──────────────────────────────────────────────┘
```

### Automated Response Examples

```python
# EventBridge rule: Security Hub finding → Lambda
# Example: Auto-remediate public S3 bucket

def handler(event, context):
    finding = event['detail']['findings'][0]
    if finding['Type'] == 'Software and Configuration Checks/AWS Security Best Practices':
        bucket_name = finding['Resources'][0]['Id'].split(':')[-1]
        s3.put_public_access_block(
            Bucket=bucket_name,
            PublicAccessBlockConfiguration={
                'BlockPublicAcls': True,
                'IgnorePublicAcls': True,
                'BlockPublicPolicy': True,
                'RestrictPublicBuckets': True
            }
        )
```

> **Exam Tip:** Security Hub = central aggregation of findings + compliance checks. Integrates with GuardDuty, Inspector, Macie, Config, Firewall Manager, and third-party tools. Use for compliance dashboards and automated remediation.

---

## 13. Inspector

### Architecture

```
┌──────────────────────────────────────────────────────────────┐
│  Amazon Inspector                                             │
│                                                               │
│  Scan Targets:                                                │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐              │
│  │ EC2        │  │ ECR        │  │ Lambda     │              │
│  │ Instances  │  │ Images     │  │ Functions  │              │
│  │ (SSM Agent)│  │ (on push)  │  │ (code +    │              │
│  │            │  │            │  │  deps)     │              │
│  └────────────┘  └────────────┘  └────────────┘              │
│                                                               │
│  Scans for:                                                   │
│  - Software vulnerabilities (CVE database)                    │
│  - Network reachability (EC2)                                 │
│  - Code vulnerabilities (Lambda)                              │
│                                                               │
│  Output: Findings with severity + remediation                 │
│  → Security Hub, EventBridge                                  │
│                                                               │
│  SBOM (Software Bill of Materials):                           │
│  Export complete software inventory                            │
└──────────────────────────────────────────────────────────────┘
```

### Scanning Coverage

| Target | What's Scanned | Trigger |
|--------|---------------|---------|
| **EC2** | OS packages, application packages | Continuous (new CVEs, instance changes) |
| **ECR** | Container image OS and app dependencies | On push, re-scan on new CVE, or on demand |
| **Lambda** | Function code + dependencies | On deploy, re-scan on new CVE |

### SBOM (Software Bill of Materials)

Export a complete inventory of all software:
- Format: CycloneDX or SPDX
- Export to S3
- Use for compliance audits and supply chain security

> **Exam Tip:** Inspector = vulnerability scanning (CVEs). EC2 (needs SSM agent), ECR (on push), Lambda (on deploy). Continuous scanning = automatically re-scans when new CVEs are published.

---

## 14. Macie

### Architecture

```
┌──────────────────────────────────────────────────────────────┐
│  Amazon Macie                                                 │
│                                                               │
│  ┌──────────────────┐                                         │
│  │  S3 Buckets      │                                         │
│  │  ┌─────┐ ┌─────┐ │                                        │
│  │  │ Obj │ │ Obj │ │                                        │
│  │  │ Obj │ │ Obj │ │                                        │
│  │  └─────┘ └─────┘ │                                        │
│  └────────┬─────────┘                                         │
│           │                                                   │
│           ▼                                                   │
│  ┌──────────────────┐                                         │
│  │ Macie Discovery  │  ML + pattern matching                  │
│  │ Job              │                                         │
│  │                  │  Detects:                                │
│  │                  │  - PII (names, SSN, credit cards)        │
│  │                  │  - Financial data                        │
│  │                  │  - Credentials / API keys                │
│  │                  │  - Custom data identifiers               │
│  └────────┬─────────┘                                         │
│           │                                                   │
│           ▼                                                   │
│  ┌──────────────────┐                                         │
│  │ Findings         │ → Security Hub                          │
│  │ - Sensitive data  │ → EventBridge → Lambda (remediate)      │
│  │   findings        │                                         │
│  │ - Policy findings │                                         │
│  │   (public bucket, │                                         │
│  │    unencrypted)   │                                         │
│  └──────────────────┘                                         │
└──────────────────────────────────────────────────────────────┘
```

### Finding Types

| Type | Examples |
|------|---------|
| **Sensitive Data** | PII (SSN, credit cards, names, addresses), financial data, credentials |
| **Policy** | Public bucket, unencrypted bucket, shared with external account |

### Custom Data Identifiers

Define custom patterns using regex:

```
Name: "Employee ID"
Regex: "EMP-\d{6}"
Keywords: ["employee", "emp id", "staff id"]
Maximum Match Distance: 50 characters
```

> **Exam Tip:** Macie = S3 data classification and PII detection. If the question mentions "discover sensitive data in S3" or "PII detection," Macie is the answer.

---

## 15. Detective

### What Detective Does

Investigates and visualizes security findings from GuardDuty, Security Hub, and other sources:

```
GuardDuty Finding: "Unusual API call from IAM user X"
        │
        ▼
Detective Investigation:
├── What other API calls did user X make?
├── What IP addresses were used?
├── What resources were accessed?
├── Timeline of all activities
├── Geo-location of API calls
├── VPC flow log analysis
├── Related CloudTrail events
└── Visualization: Entity graph + timeline
```

### Data Sources

- CloudTrail management events
- VPC Flow Logs
- EKS audit logs
- GuardDuty findings
- Security Hub findings

### Investigation Groups

Detective automatically groups related findings:

```
Finding 1: Unusual API call (user X)
Finding 2: S3 data exfiltration (same IP)
Finding 3: Credential compromise (same user X)

→ Detective groups these into one investigation
→ Shows entity relationship graph
→ Timeline of all related events
```

> **Exam Tip:** Detective = investigate and analyze (post-finding). GuardDuty = detect. Security Hub = aggregate. Detective = deep-dive investigation. If the question says "investigate the root cause of a security finding," Detective is the answer.

---

## 16. IAM Access Analyzer

### Capabilities

| Feature | Description |
|---------|------------|
| **External Access** | Find resources shared with external entities (other accounts, public) |
| **Unused Access** | Find IAM roles/users with unused permissions |
| **Policy Generation** | Generate least-privilege policies from CloudTrail activity |
| **Policy Validation** | Check IAM policies against best practices and grammar |
| **Custom Policy Checks** | Validate policies against your security standards |

### External Access Analysis

```
IAM Access Analyzer scans:
├── S3 bucket policies
├── IAM roles (trust policies)
├── KMS key policies
├── Lambda function policies
├── SQS queue policies
├── Secrets Manager secret policies
├── SNS topic policies
├── EBS volume snapshots
├── RDS DB snapshots
├── ECR repository policies
├── EFS file system policies
└── DynamoDB streams/tables

For each: "Is this resource accessible from OUTSIDE the zone of trust?"
Zone of trust = your AWS account or organization
```

### Unused Access Analysis

```
Analyzer reviews (over 90-day window):
├── IAM roles not assumed
├── IAM users with unused access keys
├── IAM users with unused passwords
├── Unused permissions (actions never called)
├── Unused services (services never accessed)
└── Generates findings: "Role X has 50 unused permissions"
```

### Policy Generation

```
1. IAM Access Analyzer reviews CloudTrail logs (up to 90 days)
2. Identifies actual API calls made by a role/user
3. Generates a least-privilege IAM policy
4. You review and apply

Original policy: "Effect: Allow, Action: s3:*, Resource: *"
Generated policy: "Effect: Allow, Action: [s3:GetObject, s3:ListBucket], Resource: [specific-bucket-arn]"
```

> **Exam Tip:** Access Analyzer = find overly permissive resources and permissions. External access = who outside my account can access my resources? Unused access = what permissions are granted but never used? Policy generation = create least-privilege from actual usage.

---

## 17. Incident Response Patterns

### Automated Incident Response Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│  Incident Detection & Response Pipeline                           │
│                                                                   │
│  DETECT:                                                          │
│  GuardDuty ──┐                                                    │
│  Inspector ──┼──▶ Security Hub ──▶ EventBridge                    │
│  Macie ──────┤                         │                          │
│  Config ─────┘                         │                          │
│                                        ▼                          │
│  TRIAGE:                         ┌──────────┐                     │
│                                  │ Lambda   │                     │
│                                  │ (triage) │                     │
│                                  └────┬─────┘                     │
│                                       │                           │
│                              ┌────────┼────────┐                  │
│                              ▼        ▼        ▼                  │
│  RESPOND:               Low Sev   Med Sev   High Sev              │
│                         Log only  SNS alert Auto-remediate        │
│                                   + Jira    + SNS page            │
│                                             + forensics           │
│                                                                   │
│  REMEDIATE:                                                       │
│  ┌──────────────────────────────────────────────────────┐         │
│  │ Lambda / SSM Automation:                              │         │
│  │ - Isolate EC2 instance (change SG to deny all)        │         │
│  │ - Revoke IAM credentials                              │         │
│  │ - Block IP in WAF                                     │         │
│  │ - Enable S3 public access block                       │         │
│  │ - Snapshot EBS volume (forensics)                     │         │
│  │ - Stop/terminate compromised instance                 │         │
│  └──────────────────────────────────────────────────────┘         │
└──────────────────────────────────────────────────────────────────┘
```

### EC2 Incident Response Steps

```
1. CONTAIN:
   ┌──────────────┐    Change SG to    ┌──────────────┐
   │ Compromised  │──────────────────▶ │ Isolated     │
   │ EC2 Instance │    "deny all"      │ EC2 Instance │
   │              │    (no inbound/    │ (forensic SG)│
   │              │     outbound)      │              │
   └──────────────┘                    └──────────────┘

2. PRESERVE EVIDENCE:
   - Create EBS snapshot (before any changes)
   - Capture memory dump (if possible)
   - Preserve CloudTrail logs, VPC Flow Logs
   - Tag instance as "under investigation"

3. INVESTIGATE:
   - Analyze with Detective
   - Review CloudTrail for unusual API calls
   - Analyze VPC Flow Logs for data exfiltration
   - Scan EBS snapshot with GuardDuty Malware Protection

4. ERADICATE:
   - Terminate compromised instance
   - Rotate all credentials
   - Patch vulnerability

5. RECOVER:
   - Deploy clean instance from approved AMI
   - Verify security controls
   - Monitor for recurrence
```

### IAM Credential Compromise Response

```python
# Automated response to compromised IAM credentials
def respond_to_compromised_credentials(user_name):
    iam = boto3.client('iam')
    
    # 1. Deactivate access keys
    keys = iam.list_access_keys(UserName=user_name)
    for key in keys['AccessKeyMetadata']:
        iam.update_access_key(
            UserName=user_name,
            AccessKeyId=key['AccessKeyId'],
            Status='Inactive'
        )
    
    # 2. Attach deny-all policy
    iam.attach_user_policy(
        UserName=user_name,
        PolicyArn='arn:aws:iam::123456789012:policy/DenyAll'
    )
    
    # 3. Invalidate temporary credentials (for roles)
    # Add inline policy with condition:
    # aws:TokenIssueTime < current_time
    
    # 4. Delete console password
    iam.delete_login_profile(UserName=user_name)
    
    # 5. Deactivate MFA devices
    mfa_devices = iam.list_mfa_devices(UserName=user_name)
    for device in mfa_devices['MFADevices']:
        iam.deactivate_mfa_device(
            UserName=user_name,
            SerialNumber=device['SerialNumber']
        )
```

**Revoke active sessions for an IAM role:**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "DateLessThan": {
          "aws:TokenIssueTime": "2026-04-16T12:00:00Z"
        }
      }
    }
  ]
}
```

This denies all actions for sessions issued before the specified time, effectively revoking all active sessions.

> **Exam Tip:** Incident response pattern: Contain → Preserve evidence → Investigate → Eradicate → Recover. For EC2: isolate with SG, snapshot EBS, investigate. For IAM: deactivate keys, revoke sessions, attach deny policy.

---

## 18. Zero Trust Architecture

### Zero Trust Principles on AWS

```
┌──────────────────────────────────────────────────────────────┐
│  Zero Trust: "Never trust, always verify"                     │
│                                                               │
│  1. IDENTITY-CENTRIC:                                         │
│     - IAM least privilege                                     │
│     - MFA everywhere                                          │
│     - Short-lived credentials (STS)                           │
│     - Attribute-based access control (ABAC)                   │
│                                                               │
│  2. NETWORK MICRO-SEGMENTATION:                               │
│     - Security groups per workload                            │
│     - Network Firewall for inspection                         │
│     - VPC endpoints (no internet transit)                     │
│     - Private subnets by default                              │
│                                                               │
│  3. ENCRYPTION EVERYWHERE:                                    │
│     - TLS for all communications                              │
│     - mTLS between services                                   │
│     - Encryption at rest for all data                         │
│                                                               │
│  4. CONTINUOUS VERIFICATION:                                  │
│     - GuardDuty (threat detection)                            │
│     - Inspector (vulnerability scanning)                      │
│     - CloudTrail (audit logging)                              │
│     - Config (compliance monitoring)                          │
│                                                               │
│  5. DEVICE/WORKLOAD VERIFICATION:                             │
│     - AWS Verified Access (user + device trust)               │
│     - ECS/EKS task/pod IAM roles                              │
│     - VPC Lattice (service-to-service auth)                   │
└──────────────────────────────────────────────────────────────┘
```

### AWS Verified Access

VPN-less access to corporate applications based on user identity and device posture:

```
┌──────────────┐    ┌──────────────────────┐    ┌──────────────┐
│ Corporate    │───▶│ AWS Verified Access  │───▶│ Internal     │
│ User         │    │                      │    │ Application  │
│ (browser)    │    │ Verify:              │    │ (ALB/NLB)    │
│              │    │ - Identity (IdP)     │    │              │
│              │    │ - Device posture     │    │              │
│              │    │ - Access policy      │    │              │
└──────────────┘    └──────────────────────┘    └──────────────┘

No VPN required. Fine-grained access policies.
Integrates with: Okta, Azure AD, CrowdStrike, Jamf, etc.
```

### VPC Lattice

Service-to-service networking and security:

```
┌──────────────────────────────────────────────────────────┐
│  VPC Lattice Service Network                              │
│                                                           │
│  ┌────────────┐         ┌────────────┐                    │
│  │ Service A  │────────▶│ Service B  │                    │
│  │ (VPC 1)    │ Auth:   │ (VPC 2)    │                    │
│  │            │ IAM +   │            │                    │
│  │            │ Auth     │            │                    │
│  │            │ Policy   │            │                    │
│  └────────────┘         └────────────┘                    │
│                                                           │
│  Features:                                                │
│  - Service-to-service authentication (IAM)                │
│  - Auth policies (who can access what)                    │
│  - Traffic management (weighted routing)                  │
│  - Cross-VPC, cross-account connectivity                  │
│  - No VPC peering or Transit Gateway needed               │
└──────────────────────────────────────────────────────────┘
```

> **Exam Tip:** Zero trust on AWS = IAM least privilege + encryption everywhere + VPC endpoints + mTLS + continuous monitoring. Verified Access = VPN replacement for corporate apps. VPC Lattice = service-to-service zero trust.

---

## 19. Exam Scenarios

### Scenario 1: Multi-Layer Encryption

**Question:** A healthcare company stores PHI (Protected Health Information) in S3 and DynamoDB. They need encryption at rest with customer-managed keys, key rotation every 90 days, and the ability to audit all key usage. They must maintain separate keys per department.

**Answer:**
- **S3:** SSE-KMS with customer-managed CMKs (one per department)
- **DynamoDB:** Customer-managed CMK encryption
- **Key rotation:** Automatic rotation every 90 days (configurable for customer-managed keys)
- **Audit:** CloudTrail logs all KMS API calls (Encrypt, Decrypt, GenerateDataKey)
- **Access control:** KMS key policies restrict which IAM roles can use each key
- **ViaService condition:** Ensure keys only used through S3/DynamoDB (not directly)

---

### Scenario 2: DDoS Protection Architecture

**Question:** A global e-commerce company experiences frequent DDoS attacks on their web application. They need protection against both Layer 3/4 and Layer 7 attacks, with automatic mitigation and cost protection during attacks.

**Answer:**
- **Edge:** CloudFront (absorb DDoS at 400+ edge locations)
- **DNS:** Route 53 (Shield Standard protects DNS automatically)
- **Layer 7:** WAF on CloudFront
  - AWS Managed Rules (Core Rule Set, Known Bad Inputs, IP Reputation)
  - Rate-based rule (block IPs exceeding 2000 req/5min)
  - Bot Control managed rule group
- **Shield Advanced:** On CloudFront, ALB, Route 53
  - DDoS Response Team (DRT) engagement
  - Cost protection (reimbursement for scaling costs)
  - Health-based detection (Route 53 health checks)
- **Auto Scaling:** Behind ALB to absorb traffic spikes

---

### Scenario 3: Cross-Account Security Monitoring

**Question:** A company with 200 AWS accounts needs centralized security monitoring, compliance checking against CIS benchmarks, and automated remediation of common misconfigurations (public S3 buckets, unencrypted EBS volumes, unrestricted security groups).

**Answer:**
- **Delegated admin account** for security services
- **GuardDuty:** Enable in all accounts/regions via Organizations integration
- **Security Hub:** Enable with CIS AWS Foundations Benchmark + AWS Foundational Best Practices
  - Cross-region aggregation to single region
  - Cross-account via Organizations
- **Inspector:** Enable across all accounts for vulnerability scanning
- **Macie:** Enable for sensitive data discovery in S3
- **AWS Config:** Organization-wide conformance packs
- **Automated remediation:**
  - Security Hub finding → EventBridge → Lambda
  - S3 public access → auto-enable block public access
  - Unencrypted EBS → notify (can't encrypt existing)
  - Unrestricted SG → auto-remove 0.0.0.0/0 rules
- **Firewall Manager:** Centrally manage WAF rules, SGs across all accounts

---

### Scenario 4: Secrets Management at Scale

**Question:** A company runs 500 microservices across multiple accounts. Each service needs database credentials that rotate every 30 days. Services shouldn't store credentials in code or environment variables. Cross-account database access is required.

**Answer:**
- **Secrets Manager:** Store all database credentials
  - Automatic rotation every 30 days (Lambda rotation function)
  - Multi-region secrets for DR
- **Cross-account access:** Resource policy on secrets + IAM policy on consuming roles + KMS key policy for cross-account decrypt
- **Application integration:**
  - ECS: Task definition secrets reference (`valueFrom: arn:aws:secretsmanager:...`)
  - EKS: Secrets Store CSI Driver with AWS provider
  - Lambda: Environment variables from Secrets Manager (resolved at invocation)
- **Caching:** SDK caches secrets locally (reduce API calls and latency)

---

### Scenario 5: Compliance for Financial Services

**Question:** A bank needs FIPS 140-2 Level 3 compliance for cryptographic key storage, must encrypt all data at rest and in transit, and needs audit trails for all data access. They also need to discover and classify sensitive data across their S3 data lake.

**Answer:**
- **Key Management:** CloudHSM (FIPS 140-2 Level 3)
  - Cluster across 2+ AZs for HA
  - KMS Custom Key Store (use CloudHSM-backed keys with KMS API)
- **Encryption at rest:**
  - S3: SSE-KMS with CloudHSM-backed keys
  - RDS: KMS encryption (CloudHSM-backed)
  - EBS: KMS encryption
  - DynamoDB: Customer-managed KMS key
- **Encryption in transit:**
  - TLS everywhere (enforce with policies)
  - mTLS between microservices (ACM Private CA)
  - Direct Connect with MACsec
- **Audit:**
  - CloudTrail (all KMS API calls logged)
  - S3 access logs + CloudTrail data events
  - VPC Flow Logs
- **Data classification:**
  - Amazon Macie for sensitive data discovery
  - Custom data identifiers for financial data patterns

---

### Scenario 6: Incident Response Automation

**Question:** A company detected that an EC2 instance is communicating with a known cryptocurrency mining pool. They need an automated response that: 1) Isolates the instance, 2) Preserves evidence for forensics, 3) Alerts the security team, 4) Creates a ticket.

**Answer:**
- **Detection:** GuardDuty finding: `CryptoCurrency:EC2/BitcoinTool.B`
- **Automated response via EventBridge → Step Functions:**
  1. **Isolate:** Lambda → change SG to "forensics-isolation" (deny all in/out)
  2. **Preserve:** Lambda → create EBS snapshot of all volumes
  3. **Tag:** Lambda → tag instance with "security-incident", timestamp, finding ID
  4. **Investigate:** Lambda → trigger GuardDuty Malware Protection scan on EBS
  5. **Alert:** SNS → security team (email/PagerDuty)
  6. **Ticket:** Lambda → create Jira/ServiceNow ticket
  7. **Log:** Write incident details to DynamoDB for tracking

---

### Key Exam Tips Summary

| Topic | Key Point |
|-------|-----------|
| Defense in depth | Edge → VPC → Subnet → Instance → App → Data |
| S3 encryption | SSE-S3 (default), SSE-KMS (audit, key control), SSE-C (you manage keys), CSE (client-side) |
| KMS | Key policy ALWAYS required. ViaService restricts to specific services. Multi-region keys for cross-region decrypt. |
| CloudHSM | FIPS 140-2 Level 3. Single-tenant. Custom Key Store for KMS integration. |
| Secrets Manager | Auto-rotation (native for RDS). Multi-region for DR. Cross-account via resource policy. |
| ACM | Free public certs (DNS validation for auto-renew). CloudFront certs must be in us-east-1. |
| Shield | Standard = free L3/L4. Advanced = $3K/mo, DRT, cost protection, L7. |
| WAF | Layer 7 on CloudFront/ALB/API GW. Rate-based rules for HTTP floods. Managed rules for OWASP. |
| Network Firewall | VPC-level deep packet inspection, IDS/IPS, domain filtering. |
| GuardDuty | Threat detection via ML + threat intel. No agents. Enable everywhere. |
| Security Hub | Aggregate findings + compliance checks (CIS, PCI, NIST). Automated remediation. |
| Inspector | Vulnerability scanning (CVE). EC2, ECR, Lambda. Continuous. |
| Macie | S3 sensitive data discovery (PII, financial). Custom data identifiers. |
| Detective | Investigate findings. Root cause analysis. Entity graphs + timelines. |
| Access Analyzer | External access findings, unused permissions, policy generation from CloudTrail. |
| Incident response | Contain → Preserve → Investigate → Eradicate → Recover. Automate with EventBridge + Lambda. |
| Zero trust | Verified Access (VPN-less), VPC Lattice (service-to-service), mTLS, least privilege. |

---

*End of Article 10 — Security Architecture*
