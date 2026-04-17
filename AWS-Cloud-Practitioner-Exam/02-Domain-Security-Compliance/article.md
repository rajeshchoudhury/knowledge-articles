# Domain 2 — Security and Compliance (30%)

> **Domain weight:** 30% of the exam (roughly **15 of 50 scored questions**).
> **Task statements in CLF-C02:**
> 2.1 Understand the AWS shared responsibility model.
> 2.2 Understand AWS Cloud security, governance, and compliance concepts.
> 2.3 Identify AWS access management capabilities.
> 2.4 Identify components and resources for security.

This is the **largest domain by weight**. Master it and you secure nearly a
third of the exam.

---

## 1. The AWS Shared Responsibility Model (SRM)

The SRM is the foundation of cloud security on AWS. Memorize the tagline:

> **AWS is responsible for *security OF* the cloud. The customer is
> responsible for *security IN* the cloud.**

### 1.1 AWS responsibilities — *security OF the cloud*

- Physical security of data centers (gates, guards, biometrics).
- Hardware lifecycle, including secure disposal.
- Host operating system, hypervisor, and firmware.
- Networking infrastructure (fiber, routers, switches).
- Virtualization platform (Nitro for modern EC2).
- Managed-service software plane (e.g., RDS engine code, S3 internals,
  DynamoDB infrastructure).

### 1.2 Customer responsibilities — *security IN the cloud*

- Guest OS updates and patches (on EC2 that you manage yourself).
- Application code, business logic, and third-party libraries.
- Identity and Access Management configuration (IAM users, roles, policies).
- Network configuration (VPC, subnets, Security Groups, NACLs, routing).
- Data: classification, encryption, integrity, backup, retention.
- Client-side encryption (if required beyond server-side defaults).
- Shared resources: some tasks (patching DB engine, replacing hardware)
  shift to AWS as you move up the stack.

### 1.3 The responsibility spectrum

```
                ┌─────────────────────────────────────────────────┐
                │            CUSTOMER RESPONSIBILITY              │
On-prem          │ Everything.                                     │
IaaS (EC2)       │ OS patching, app, data, IAM, network, encryption│
PaaS (RDS)       │ App, data, IAM; not DB engine or host OS        │
PaaS (Lambda)    │ Code and IAM; not runtime, OS, scaling          │
SaaS (Chime)     │ User data, access controls                      │
                └─────────────────────────────────────────────────┘
```

### 1.4 "Shared controls" — controls shared between AWS and customer

- **Patch management** — AWS patches the infra, customer patches guest OS.
- **Configuration management** — AWS configs the infra, customer configs OS
  and app.
- **Awareness & training** — AWS trains its staff, customer trains its staff.

▶ **Gotcha:** On a managed service like **RDS**, engine patching is AWS's
responsibility **within maintenance windows** set by the customer. The
*customer* is responsible for choosing the window, taking final backups,
and application-side compatibility.

### 1.5 Typical exam scenarios

| Scenario | Whose responsibility? |
|---|---|
| EC2 guest OS security patches | **Customer** |
| Nitro hypervisor vulnerability patch | **AWS** |
| Replacing a failed disk in a Region | **AWS** |
| Encrypting S3 objects with customer-managed KMS key | **Customer** (configuration); AWS does the crypto |
| IAM policy granting only needed privileges | **Customer** |
| Physical destruction of decommissioned storage media | **AWS** |
| Compliance attestations (e.g., SOC 2 Type II) for AWS services | **AWS** (AWS provides, customer consumes via AWS Artifact) |
| Securing customer application code against SQL injection | **Customer** |
| Updating the RDS MySQL engine to a patched version | **Both** (customer schedules and approves; AWS performs) |

---

## 2. Security principles

### 2.1 Defense in depth

Apply security at **every layer**: edge (WAF, Shield), network (VPC, SG,
NACL), host (SSM Patch Manager, Inspector), application (IAM, Cognito,
parameter validation), data (KMS encryption, S3 bucket policy), operations
(CloudTrail, GuardDuty). Any single-layer failure should not compromise the
system.

### 2.2 Least privilege

Grant only the minimum permissions necessary. Start from deny-all, add only
what's needed. Use IAM Access Analyzer to continuously find over-permissive
access.

### 2.3 Zero Trust

"Never trust, always verify." Assume the network is hostile. Identity-driven
access decisions. AWS provides building blocks: IAM, IAM Roles Anywhere, VPC
Lattice, VPC endpoints (PrivateLink), SGs, WAF, Verified Access, Verified
Permissions.

### 2.4 Encryption everywhere

- **In transit:** TLS 1.2+ (Certificate Manager provides certs for ALB,
  CloudFront, API Gateway, etc.). VPN tunnels. TLS to S3 endpoints via HTTPS.
- **At rest:** AES-256 via KMS. Most services integrate natively (S3 SSE,
  EBS encryption, RDS encryption, DynamoDB encryption-at-rest-by-default,
  etc.).

### 2.5 Auditability

Every action must leave a trail. AWS makes this easy with CloudTrail (API
calls), Config (resource state), VPC Flow Logs (network), S3 access logs,
ALB access logs, WAF logs.

---

## 3. IAM deep dive

**AWS Identity and Access Management (IAM)** is a *global* service for
controlling *who* (authentication) can do *what* (authorization) on AWS
resources. IAM is **free**.

### 3.1 The four pillars of IAM

1. **Users** — long-lived identities for real humans or apps.
2. **Groups** — collections of users; policies attach to groups.
3. **Roles** — temporary identities assumable by users, services, or
   federated principals. Use roles for **applications**, **cross-account**
   access, and **federated** logins.
4. **Policies** — JSON documents expressing permissions.

### 3.2 IAM policy anatomy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ReadOnlyBucket",
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:ListBucket"],
      "Resource": [
        "arn:aws:s3:::reports",
        "arn:aws:s3:::reports/*"
      ],
      "Condition": {
        "IpAddress": { "aws:SourceIp": "203.0.113.0/24" }
      }
    }
  ]
}
```

Elements:
- **Effect** — Allow or Deny.
- **Action** — `service:Operation`, e.g., `s3:GetObject`.
- **Resource** — ARN(s) the statement applies to.
- **Principal** — *who* the policy applies to (used in **resource-based**
  policies, not identity-based).
- **Condition** — optional constraint using context keys (IP, MFA, time,
  tag, etc.).

### 3.3 Types of policies

| Type | Attached to | Common use |
|---|---|---|
| **Identity-based policy** (managed or inline) | User, group, role | Define what *principal* can do |
| **Resource-based policy** | Resource (S3 bucket, SQS queue, Lambda, KMS key) | Define who can access the *resource* |
| **Permissions boundary** | User or role | Cap on max permissions (used by admins delegating IAM) |
| **Service Control Policy (SCP)** | AWS Organizations OU / account | Org-wide allow-list or deny-list; applies to IAM principals **but not** the root |
| **Session policy** | STS `AssumeRole` session | Further restricts a role's permissions for a session |
| **Access Control List (ACL)** | S3 bucket/object, some other services | Legacy cross-account grants |

### 3.4 IAM roles in detail

A role has:
- A **trust policy** — who may assume it (e.g., EC2 service, another AWS
  account, SAML IdP).
- **Permissions policies** — what the role can do once assumed.

Typical role use cases:
- **EC2 instance role** — instead of storing keys on the instance.
- **Lambda execution role** — required for the function to run.
- **Cross-account access** — Account A trusts Account B's principal.
- **Federated identity** — SAML, OIDC (e.g., GitHub Actions, Okta).
- **EKS IRSA** (IAM Roles for Service Accounts) — pods assume roles.

### 3.5 Root user

The root user is created with the account and has **unlimited** access.
Best practices:
- **Never use** root for daily work.
- **Enable MFA** on the root user immediately.
- Do **not** create access keys for root. If one exists, delete it.
- Lock away the root credentials (password manager, physical safe).
- Tasks requiring root: changing account settings/name, closing the account,
  restoring IAM permissions if locked out, signing up for Enterprise
  Support, some billing actions (historical), registering as a seller in
  Marketplace.

### 3.6 MFA

- **Virtual MFA** — apps like Google Authenticator, Authy.
- **Hardware MFA** — YubiKey, Gemalto token.
- **U2F security keys** — FIDO-standard hardware.
- **SMS MFA** — deprecated; do not use.

Enforce MFA via policies with `"Condition": {"BoolIfExists": {"aws:MultiFactorAuthPresent": "true"}}`.

### 3.7 Access keys vs temporary credentials

| Credential | Lifetime | Best for |
|---|---|---|
| **Password + MFA** | Long-lived | Console login |
| **Access Key (AK/SK)** | Long-lived | CLI/SDK on user's workstation; avoid on EC2/Lambda |
| **Temporary credentials via STS** | Minutes–hours | Workloads; federated users; cross-account; IAM roles |

Prefer **temporary credentials** wherever possible — they can't be leaked
for long.

### 3.8 IAM policy evaluation logic

When a request arrives, IAM evaluates:

1. Default = **deny**.
2. Evaluate all applicable policies (identity, resource, SCP, boundary,
   session).
3. Any explicit **Deny** → Deny. (Explicit Deny trumps everything.)
4. Otherwise if any **Allow** and SCP allows and boundary allows → Allow.
5. Otherwise → implicit Deny.

▶ **Gotcha:** SCPs do **not** grant permissions — they only constrain what
can be allowed. A user in an SCP-restricted OU still needs an identity or
resource policy granting the access.

### 3.9 IAM best practices (exam checklist)

- Use users for humans, roles for machines.
- Enforce MFA on all users, especially root.
- Rotate access keys every 90 days (or remove them entirely).
- Use groups + managed policies for scalable governance.
- Apply permissions boundaries for delegation.
- Use Access Analyzer to find external-account exposure and unused
  permissions.
- Enable **CloudTrail in all Regions** to log IAM actions.
- Use tag-based access control (ABAC) for scalable, tag-driven permissions.

### 3.10 IAM tools you must recognize

- **IAM Access Analyzer** — finds resources shared externally, generates
  least-privilege policies from CloudTrail data, validates policies.
- **IAM Access Advisor** — shows last-accessed timestamps per service,
  useful for deprovisioning.
- **Credential Report** — CSV of all users and their credential state.
- **Policy Simulator** — tests a policy against an action before deploying.

---

## 4. Identity federation and identity services

### 4.1 AWS IAM Identity Center (successor to AWS SSO)

- Centralized identity for **workforce users** across multiple AWS accounts
  and business apps.
- Built-in identity store, or federate with **external IdPs** (Okta, Azure
  AD / Entra ID, Google Workspace, Ping, etc.) via SAML 2.0 or SCIM.
- Supports **permission sets** (named bundles of policies) mapped to
  Organization accounts.
- Enables **AWS access portal** URL for users to pick an account + role.

### 4.2 AWS STS (Security Token Service)

A global service that vends **temporary credentials**. Used when you
`AssumeRole`, `AssumeRoleWithSAML`, `AssumeRoleWithWebIdentity`,
`GetFederationToken`, or `GetSessionToken`.

Token lifetime: 15 min – 12 hours, depending on operation and config.

### 4.3 Amazon Cognito

Two distinct products sharing a name:

| Component | Purpose |
|---|---|
| **User Pools** | Authentication for your **app's end-users** (sign-up, sign-in, MFA, password reset, social/OIDC federation). Produces **JWT** tokens. |
| **Identity Pools** (Federated Identities) | Exchange any identity (Cognito user pool token, Google, Apple, SAML, OIDC, Facebook, guest) for **AWS credentials** to access AWS services directly from the app. |

▶ **Gotcha:** A common confusion is IAM vs Cognito. **IAM** is for **AWS
account users** (your developers/operators). **Cognito** is for your
**application's customers**.

### 4.4 AWS Directory Service

Managed Microsoft Active Directory offerings:

- **AWS Managed Microsoft AD** — full real AD, integrates with on-prem via
  trust; supports SSO for .NET apps, EC2 instances, FSx for Windows.
- **AD Connector** — proxies auth to on-prem AD without storing creds.
- **Simple AD** — low-cost, Samba-based. Basic AD functionality only.

### 4.5 AWS IAM Roles Anywhere

Lets on-prem servers (or any workload with an X.509 cert) assume IAM roles
using their certificate, removing the need for long-lived access keys.

---

## 5. Data protection and encryption

### 5.1 AWS Key Management Service (KMS)

- Regional, managed service for cryptographic keys.
- Keys never leave KMS un-encrypted; HSM-backed (FIPS 140-2 Level 3 in
  non-Government Regions, Level 3 in GovCloud).
- Key types:
  - **AWS-owned keys** — used on your behalf by AWS services; not visible.
  - **AWS-managed keys** (`aws/service-name`) — per-service, per-account;
    AWS creates and manages.
  - **Customer-managed keys (CMK)** — you create, you control; charged per
    key per month (+ API calls).
- Supports **symmetric** (AES-256) for encryption/decryption, and
  **asymmetric** (RSA / ECC) for sign/verify or encrypt/decrypt.
- Supports **key rotation** — automatic yearly for symmetric CMKs;
  manual for imported or asymmetric keys.
- **Envelope encryption** pattern — KMS protects a **data key**, which
  protects your data. This scales and limits data-key exposure.

### 5.2 AWS CloudHSM

Single-tenant, customer-controlled HSM cluster (FIPS 140-2 Level 3). Use
when:
- You need total control of key material.
- You have regulatory requirements disallowing multi-tenant KMS.
- You run PKCS#11, JCE, or CNG/KSP workloads.

### 5.3 AWS Secrets Manager vs Systems Manager Parameter Store

| Feature | Secrets Manager | Parameter Store |
|---|---|---|
| Use case | Secrets (DB credentials, API keys) | Config values + secrets |
| Encryption | KMS (default) | KMS (SecureString) |
| Rotation | Built-in Lambda rotation for RDS, Redshift, DocumentDB, custom | None native |
| Cost | Per secret per month + per API call | Free for Standard tier (up to 10K parameters) |
| Size | 64 KB | 4 KB (Standard), 8 KB (Advanced) |
| Hierarchical | No | Yes (`/app/prod/db/password`) |
| Cross-account sharing | Yes via resource policy | No (use RAM) |

Rule of thumb: **secrets with rotation → Secrets Manager; plain config or
low-volume secrets → Parameter Store.**

### 5.4 AWS Certificate Manager (ACM)

- Free TLS certificates for use with **ELB, CloudFront, API Gateway, App
  Runner, etc.**
- Public certs: validated via DNS or email; auto-renewed.
- Private certs via **ACM Private CA** ($400/month per CA + per cert).
- ACM certs **cannot** be used on EC2 directly (must terminate TLS on an
  AWS service).

### 5.5 Encryption in transit

- ELB / CloudFront / API Gateway / App Runner terminate TLS using ACM certs.
- Service-to-service calls over AWS network use TLS by default.
- S3 supports HTTPS endpoints; enforce with `aws:SecureTransport` bucket
  policy condition.
- VPC Flow Logs and most log pipelines are encrypted in flight.

### 5.6 Encryption at rest

- **S3:** SSE-S3 (AWS-managed), SSE-KMS (your key in KMS), SSE-C (you supply
  key), DSSE-KMS (dual-layer for top-secret classification). S3 enables
  SSE-S3 **by default** on all new buckets since Jan 2023.
- **EBS:** AES-256 with KMS; enable account-wide default.
- **RDS / Aurora:** encryption at creation; tightly tied to the KMS key
  chosen. Read replicas inherit.
- **DynamoDB:** encryption at rest by default with AWS-owned key (can switch
  to AWS-managed or CMK).
- **EFS, FSx, Redshift, SageMaker** — KMS-backed encryption.

---

## 6. Network security

### 6.1 VPC fundamentals recap

- **VPC** — a logically isolated virtual network.
- **Subnets** — slice a VPC by AZ + public/private.
- **Route tables** — control traffic between subnets and gateways.
- **IGW** — internet connectivity.
- **NAT GW / NAT Instance** — outbound internet from private subnets.
- **VPC Endpoints** — private connectivity to AWS services without the
  internet.

### 6.2 Security Groups (SGs)

- **Stateful** firewall at the ENI level.
- Default: **deny** inbound, **allow** outbound.
- **Allow** rules only — no deny rules.
- Can reference other SGs (common for tiered apps).

### 6.3 Network ACLs (NACLs)

- **Stateless** firewall at the subnet level.
- **Allow** and **Deny** rules, evaluated in numeric order.
- Default NACL allows everything; custom NACLs deny all by default.

### 6.4 SG vs NACL (classic exam comparison)

| Attribute | Security Group | Network ACL |
|---|---|---|
| Level | ENI | Subnet |
| Stateful? | Stateful | Stateless |
| Rules | Allow only | Allow & Deny |
| Rule evaluation | All rules evaluated | First matching rule (by #) |
| Default | Deny in, allow out | Varies by default vs custom |
| Default SG allows | Traffic within SG | N/A |

### 6.5 AWS WAF (Web Application Firewall)

- Attach to **CloudFront, ALB, API Gateway, AppSync, App Runner, Verified
  Access, or Cognito User Pools**.
- Inspect HTTP(S) at layer 7.
- Block SQLi, XSS, bad bots, IP reputation lists, rate-based rules, geo
  blocking, body/URI pattern matches.
- **Managed rule groups** from AWS and partners (Fortinet, Imperva, F5,
  Cyber Security Cloud, etc.).

### 6.6 AWS Shield

- **Shield Standard** — always on, free for all AWS customers; protects
  CloudFront, Route 53, Global Accelerator against common L3/L4 DDoS.
- **Shield Advanced** — paid ($3,000/month per org + data fees), adds
  24/7 SRT (Shield Response Team), cost-protection for scale-up during
  attacks, advanced attack diagnostics, and WAF at no extra charge.

### 6.7 AWS Firewall Manager

Centralized policy manager across Organizations accounts for WAF, Shield
Advanced, SGs, Network Firewall, Route 53 Resolver DNS Firewall.

### 6.8 AWS Network Firewall

Managed stateful network firewall with IDS/IPS capabilities, deployed into
a VPC. Uses **Suricata** rule syntax. Use for east-west and egress
inspection.

### 6.9 Route 53 Resolver DNS Firewall

Block DNS queries to known-bad domains; allow-list only trusted domains.

### 6.10 AWS Verified Access

Zero-trust, VPN-less remote access to internal apps, using identity and
device posture.

---

## 7. Detective controls (logging, monitoring, threat detection)

### 7.1 AWS CloudTrail

Records **API activity** in the account. Every call (via console, CLI, SDK,
service) is logged.

- Management events (control-plane) — default.
- Data events (S3 objects, Lambda invoke, DynamoDB items) — opt-in; charged.
- Insights events — detects unusual activity patterns.
- Storage: first 90 days of history in the console (free, read-only trail
  called **Event History**); for long-term archive, create a **trail**
  delivering to S3.
- **CloudTrail Lake** — fully managed, SQL-queryable lake for trail data.

### 7.2 AWS Config

Records **resource configuration** over time and evaluates rules for
compliance.

- *"What does this resource look like now? What did it look like 3 days
  ago? Has it drifted from compliance?"*
- **Rules** — managed rules (e.g., `s3-bucket-public-read-prohibited`)
  or custom Lambda-backed.
- **Conformance packs** — bundle of rules + remediation for a standard
  (e.g., PCI, CIS).
- **Aggregator** — multi-account / multi-Region view.

CloudTrail = *who did what and when*. Config = *what does it look like now,
and has it changed*.

### 7.3 Amazon GuardDuty

Managed threat detection using CloudTrail, VPC Flow Logs, DNS logs, S3 data
events, EKS audit logs, RDS login events, EBS malware scan, and Lambda
network activity.

Finds: crypto-mining on EC2, IAM credential compromise, reconnaissance,
tor-exit-node traffic, unusual API calls, S3 exfiltration.

### 7.4 Amazon Inspector

Automated vulnerability scanner for:
- **EC2** — OS and application CVEs (via SSM agent).
- **ECR container images** — CVEs on push.
- **Lambda functions** — code vulnerabilities.

Continuous scanning, CVSS scored.

### 7.5 AWS Security Hub

Single pane of glass: aggregates findings from GuardDuty, Inspector, Macie,
Firewall Manager, IAM Access Analyzer, Config, partner products. Runs
security standards (CIS, PCI-DSS, AWS FSBP — Foundational Security Best
Practices).

### 7.6 Amazon Macie

Discovers, classifies, and protects **sensitive data in S3** (PII, PHI,
financial data). Uses machine learning + pattern matching.

### 7.7 Amazon Detective

Automatically builds a graph from CloudTrail, VPC Flow Logs, GuardDuty
findings, and EKS audit logs to accelerate root-cause investigation.

### 7.8 AWS Trusted Advisor

Best-practice checks across 5 categories: Cost Optimization, Performance,
**Security**, Fault Tolerance, Service Limits, and **Operational Excellence**.
Basic/Developer plans get a subset; Business/Enterprise plans get all.

### 7.9 AWS Abuse

Email (`abuse@amazonaws.com`) / form to report compromise or abusive
activity involving AWS resources.

### 7.10 Quick comparison — *who does what*

| Concern | Service |
|---|---|
| "Who called this API?" | **CloudTrail** |
| "What does this resource look like historically?" | **Config** |
| "Is anyone attacking / compromising this account?" | **GuardDuty** |
| "Are my EC2/containers vulnerable?" | **Inspector** |
| "Is sensitive PII in S3?" | **Macie** |
| "I want a single dashboard of security posture." | **Security Hub** |
| "Help me investigate a security incident." | **Detective** |
| "Best-practice checks and savings?" | **Trusted Advisor** |
| "Compliance reports on AWS itself." | **AWS Artifact** |
| "Automated compliance evidence collection." | **AWS Audit Manager** |

---

## 8. Governance, compliance, and attestations

### 8.1 AWS Artifact

Self-service portal providing on-demand access to **AWS's compliance
documents** (SOC 1/2/3, ISO 27001 / 27017 / 27018, PCI-DSS AOC, FedRAMP
packages, etc.) and agreements (BAA for HIPAA, GDPR DPA, etc.).

▶ **Gotcha:** Artifact provides AWS's reports. It does *not* certify your
application — that's your job.

### 8.2 AWS Audit Manager

Continuously collects evidence for audits (e.g., SOC 2, PCI-DSS, HIPAA,
GDPR, ISO 27001) from AWS services and custom sources. Replaces manual
evidence gathering.

### 8.3 AWS Compliance programs (acronym soup)

Know these names at a high level:

| Program | Scope |
|---|---|
| **SOC 1 / 2 / 3** | Controls over financial reporting / security, availability, processing integrity, confidentiality, privacy. |
| **ISO 27001 / 27017 / 27018 / 27701 / 22301 / 9001 / 27005** | Information security management, cloud-specific, PII in cloud, privacy, business continuity, quality, risk. |
| **PCI-DSS** | Payment card data. AWS is Level 1. |
| **HIPAA / HITECH** | US healthcare (PHI). AWS signs a **BAA** via Artifact. |
| **FedRAMP Moderate / High** | US federal gov. Most services in us-east-1/2, us-west-2. All in GovCloud. |
| **GDPR** | EU data protection. AWS offers **DPA**. |
| **FISMA / NIST 800-53 / 800-171** | US fed infosec. |
| **FIPS 140-2 Level 3** | Crypto modules (KMS, CloudHSM). |
| **CJIS** | Criminal Justice Information Services. |
| **ITAR / EAR** | Defense trade (GovCloud only). |
| **IRAP** | Australian government. |
| **IL4 / IL5 / IL6** | US DoD impact levels. |
| **StateRAMP, K-ISMS, MTCS, IRAP, C5, CCCS, ENS, PDPA** | Regional. |
| **Cloud Security Alliance (CSA) STAR** | Transparency attestation. |

### 8.4 Data sovereignty

Data **stays in the Region you pick** unless *you* replicate it (S3 CRR,
Aurora Global, DynamoDB Global Tables). GovCloud, China, and Secret
Regions are entirely isolated partitions.

### 8.5 AWS Organizations

Multi-account management:
- **Root** of the org at the top.
- **Organizational Units (OUs)** — hierarchical grouping of accounts.
- **Service Control Policies (SCPs)** — allow-list or deny-list limiting
  what member accounts can do.
- **Consolidated billing** — one invoice for all accounts + pooled RI /
  Savings Plan / volume discounts.
- **Tag policies** — standardize tags.
- **Backup policies** — centralize AWS Backup across accounts.
- **AI services opt-out policy** — prevent AWS AI from using data for
  improvement.

### 8.6 AWS Control Tower

- Opinionated landing zone built on Organizations + IAM Identity Center +
  Config + CloudTrail + Security Hub.
- **Guardrails** — preventive (SCPs) or detective (Config rules).
- Account factory for fast, compliant account vending.
- Customizations via **Control Tower Account Factory for Terraform (AFT)**
  or **Customizations for Control Tower (CfCT)**.

### 8.7 AWS Service Catalog

Let administrators publish **approved** IaC (CloudFormation or Terraform)
products that end-users can self-service. Enforces tags and constraints.

### 8.8 AWS License Manager

Track licenses (BYOL or AWS-provided) across AWS and on-prem.

---

## 9. Security-related services quick map

```
┌────────────────── Identity ───────────────────┐
│ IAM   Identity Center   STS   Cognito   AD    │
│ IAM Roles Anywhere   IAM Access Analyzer      │
└───────────────────────────────────────────────┘

┌────────────────── Encryption ─────────────────┐
│ KMS   CloudHSM   ACM   Secrets Manager        │
│ SSM Parameter Store   Payment Cryptography    │
└───────────────────────────────────────────────┘

┌────────────────── Network Security ───────────┐
│ Security Groups   NACLs   WAF   Shield         │
│ Firewall Manager   Network Firewall            │
│ Route 53 Resolver DNS Firewall                 │
│ VPC PrivateLink   Verified Access              │
└───────────────────────────────────────────────┘

┌────────────────── Detective ──────────────────┐
│ CloudTrail   Config   GuardDuty   Inspector   │
│ Macie   Detective   Security Hub              │
│ Trusted Advisor   Audit Manager               │
└───────────────────────────────────────────────┘

┌────────────────── Governance ─────────────────┐
│ Organizations   Control Tower   Service Catalog│
│ Artifact   Audit Manager   License Manager     │
│ Resource Access Manager (RAM)                 │
└───────────────────────────────────────────────┘

┌────────────────── Incident / DR ──────────────┐
│ AWS Health   Systems Manager (Incident Mgr)    │
│ Elastic Disaster Recovery   AWS Backup         │
│ Resilience Hub                                │
└───────────────────────────────────────────────┘
```

---

## 10. 30 rapid-fire check questions

1. Who patches the guest OS of an EC2 instance?
2. Who owns the hypervisor's security?
3. What is "security OF the cloud" vs "security IN the cloud"?
4. Which three elements comprise an IAM policy statement at minimum?
5. Does an SCP grant permissions?
6. What is an IAM permissions boundary?
7. What is STS?
8. What is the difference between Cognito User Pool and Identity Pool?
9. What is IAM Identity Center?
10. Name three ways to federate workforce identities into AWS.
11. Which encryption service provides HSM-backed multi-tenant KMS?
12. Which provides single-tenant HSMs?
13. What's the difference between Secrets Manager and Parameter Store?
14. What is ACM used for?
15. Can ACM certs be installed on an EC2 instance directly?
16. Security Groups vs NACLs — stateful?
17. Which is evaluated by rule number?
18. What protects against L7 attacks at CloudFront?
19. What protects against L3/L4 DDoS and is free by default?
20. What adds cost-protection and 24/7 SRT access?
21. Which service logs API calls?
22. Which service records resource-config history?
23. Which detects compromise in EC2/IAM/S3 using ML?
24. Which scans EC2 and containers for CVEs?
25. Which detects sensitive PII in S3?
26. Which unifies security findings?
27. Which accelerates incident investigation?
28. Which provides AWS's SOC/ISO/PCI reports to customers?
29. Which automates compliance evidence collection?
30. Which is AWS's landing-zone accelerator based on Organizations?

*Answers are in the article. Review anything you got wrong.*

---

Continue to **Domain 3 — Cloud Technology and Services**.
