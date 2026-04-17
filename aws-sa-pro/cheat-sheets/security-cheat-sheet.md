# AWS Security Cheat Sheet — SAP-C02

> Comprehensive security reference covering IAM, encryption, federation, compliance, and all AWS security services.

---

## Table of Contents

1. [IAM Deep Dive](#1-iam-deep-dive)
2. [STS (Security Token Service)](#2-sts-security-token-service)
3. [AWS Organizations & SCPs](#3-aws-organizations--scps)
4. [IAM Identity Center (SSO)](#4-iam-identity-center-sso)
5. [Amazon Cognito](#5-amazon-cognito)
6. [Federation Patterns](#6-federation-patterns)
7. [AWS KMS](#7-aws-kms)
8. [AWS CloudHSM](#8-aws-cloudhsm)
9. [AWS Certificate Manager (ACM)](#9-aws-certificate-manager-acm)
10. [Secrets Manager vs Parameter Store](#10-secrets-manager-vs-parameter-store)
11. [Threat Detection & Security Services](#11-threat-detection--security-services)
12. [AWS Config](#12-aws-config)
13. [CloudTrail](#13-cloudtrail)
14. [VPC Security](#14-vpc-security)
15. [S3 Security](#15-s3-security)
16. [Network Firewall, WAF & Shield](#16-network-firewall-waf--shield)
17. [Resource Access Manager (RAM)](#17-resource-access-manager-ram)
18. [Control Tower & Landing Zone](#18-control-tower--landing-zone)
19. [Audit Manager & Artifact](#19-audit-manager--artifact)

---

## 1. IAM Deep Dive

### Policy Types (in evaluation order)

| Policy Type | Scope | Purpose |
|------------|-------|---------|
| **Service Control Policies (SCPs)** | Organization / OU / Account | Maximum permissions boundary for accounts |
| **Permission Boundaries** | IAM User / Role | Maximum permissions boundary for principals |
| **Session Policies** | STS session | Maximum permissions for a specific session |
| **Identity-based Policies** | IAM User / Group / Role | Grant permissions to the principal |
| **Resource-based Policies** | AWS resource (S3, SQS, etc.) | Grant permissions on the resource |

### IAM Policy Evaluation Logic

```
1. Is there an explicit DENY? → DENY (always wins)
2. Is there an SCP that doesn't allow? → DENY (implicit)
3. Is there a Resource-based policy that allows? → ALLOW (for same-account)
4. Is there a Permission Boundary that doesn't allow? → DENY (implicit)
5. Is there a Session Policy that doesn't allow? → DENY (implicit)
6. Is there an Identity-based policy that allows? → ALLOW
7. Default → DENY (implicit)
```

**Critical cross-account exception:** For cross-account access, BOTH the identity-based policy (in source account) AND the resource-based policy (in target account) must explicitly ALLOW. Resource-based policy alone is NOT sufficient for cross-account with IAM roles (you need trust policy + identity policy OR resource-based policy granting the role ARN).

### Identity-Based vs Resource-Based Policies

| Feature | Identity-Based | Resource-Based |
|---------|---------------|----------------|
| **Attached to** | Users, Groups, Roles | Resources (S3, SQS, Lambda, KMS, etc.) |
| **Principal element** | Not specified (applies to attached entity) | Required (who can access) |
| **Cross-account** | Needs trust + identity policy | Can grant directly (single policy) |
| **Services supporting** | All | S3, SQS, SNS, Lambda, KMS, ECR, API GW, Secrets Manager, etc. |

### Permission Boundaries

- **What:** Maximum permissions that identity-based policies can grant to a user or role
- **Effect:** Effective permissions = intersection of identity policy AND boundary
- **Use case:** Delegate user creation to developers while limiting what those users can do
- **Only affects identity-based policies** — does NOT limit resource-based policies

```
Effective Permissions = Identity Policy ∩ Permission Boundary ∩ SCP
```

### IAM Conditions — Common Condition Keys

| Condition Key | Description | Example Use |
|--------------|-------------|-------------|
| `aws:SourceIp` | Requester's IP address | Restrict API calls to corporate IP range |
| `aws:SourceVpc` | VPC from which request originates | Restrict to specific VPC |
| `aws:SourceVpce` | VPC endpoint from which request originates | Restrict to specific VPC endpoint |
| `aws:PrincipalOrgID` | Organization ID of the requester | Allow access from entire org |
| `aws:PrincipalOrgPaths` | OU path of the requester | Allow access from specific OU |
| `aws:PrincipalTag/key` | Tag on the requesting principal | ABAC (Attribute-Based Access Control) |
| `aws:ResourceTag/key` | Tag on the resource | ABAC |
| `aws:RequestedRegion` | Region of the API call | Restrict to specific regions |
| `aws:CalledVia` | Service that made the call | Allow actions only via CloudFormation |
| `aws:PrincipalIsAWSService` | Is the caller an AWS service? | Allow service-linked roles |
| `aws:MultiFactorAuthPresent` | Was MFA used? | Require MFA for sensitive actions |
| `aws:MultiFactorAuthAge` | Seconds since MFA authentication | Require recent MFA |
| `aws:SecureTransport` | Was the request sent over HTTPS? | Deny non-HTTPS requests (S3) |
| `s3:x-amz-server-side-encryption` | Encryption header | Require SSE-KMS uploads |
| `kms:ViaService` | AWS service calling KMS | Restrict key usage to specific services |
| `ec2:ResourceTag/key` | Tag on EC2 resource | ABAC for EC2 |
| `iam:PermissionsBoundary` | ARN of permission boundary | Require boundary on created roles |

### IAM Roles

#### Trust Policies

- Define **who** can assume the role (Principal element)
- Attached to the **role** (not to the assumer)
- Can specify: AWS accounts, IAM users/roles, AWS services, federated identities

```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {
      "AWS": "arn:aws:iam::123456789012:root"
    },
    "Action": "sts:AssumeRole",
    "Condition": {
      "StringEquals": { "sts:ExternalId": "unique-id-from-partner" }
    }
  }]
}
```

#### Confused Deputy Prevention

- Use `sts:ExternalId` condition in trust policy
- External ID = secret shared between you and the third party
- Prevents another AWS customer from using a third party's role to access your resources

#### Service-Linked Roles

- Pre-defined by AWS services (e.g., `AWSServiceRoleForElasticLoadBalancing`)
- Cannot modify the permissions policy
- Can only delete after the service no longer needs it
- Auto-created when you use certain features

### IAM Best Practices for the Exam

- Use **roles** instead of long-term credentials (access keys)
- Apply **least privilege** — grant only needed permissions
- Use **permission boundaries** when delegating admin tasks
- Use **SCPs** to restrict accounts organization-wide
- Enable **MFA** for privileged users and sensitive operations
- Use **conditions** to add context-based restrictions
- Use **tags (ABAC)** for scalable permission management
- Rotate credentials regularly
- Use **IAM Access Analyzer** to identify unintended resource sharing

---

## 2. STS (Security Token Service)

### STS API Actions

| API Call | Who Uses It | Returns | Use Case |
|----------|-------------|---------|----------|
| **AssumeRole** | IAM user, role, or AWS service | Temp credentials (access key, secret key, session token) | Cross-account access, privilege escalation (controlled), service assumptions |
| **AssumeRoleWithSAML** | Federated user (SAML IdP) | Temp credentials | Enterprise SSO via SAML 2.0 (Active Directory, Okta, etc.) |
| **AssumeRoleWithWebIdentity** | Web identity (OIDC) | Temp credentials | Mobile/web apps (Google, Facebook, Amazon, OIDC) — **prefer Cognito over direct call** |
| **GetFederationToken** | IAM user (not role) | Temp credentials + federated user info | Custom identity broker, proxy for users |
| **GetSessionToken** | IAM user | Temp credentials | MFA-protected API calls, temporary access from CLI |
| **DecodeAuthorizationMessage** | Any | Decoded error message | Debugging authorization failures |

### Credential Duration Limits

| API Call | Default | Minimum | Maximum |
|----------|---------|---------|---------|
| AssumeRole | 1 hour | 15 min | 12 hours (configurable per role) |
| AssumeRoleWithSAML | 1 hour | 15 min | 12 hours |
| AssumeRoleWithWebIdentity | 1 hour | 15 min | 12 hours |
| GetFederationToken | 12 hours | 15 min | 36 hours |
| GetSessionToken | 12 hours | 15 min | 36 hours |

### Session Policies

- Optional policies passed during `AssumeRole`, `AssumeRoleWithSAML`, or `AssumeRoleWithWebIdentity`
- **Scope down** the effective permissions (cannot escalate beyond role's policies)
- Effective permissions = role's identity policies ∩ session policy
- Use case: Different levels of access for the same role based on context

### Cross-Account Access Pattern

```
Account A (source)              Account B (target)
┌─────────────────┐            ┌─────────────────┐
│ IAM User/Role   │            │ IAM Role         │
│ Policy: Allow   │──STS──────→│ Trust Policy:    │
│ sts:AssumeRole  │ AssumeRole │ Allow Account A  │
│ on Role B ARN   │            │ Policy: S3 read  │
└─────────────────┘            └─────────────────┘
```

---

## 3. AWS Organizations & SCPs

### Organization Structure

```
Root (Management Account)
├── OU: Security
│   ├── Security Account (Log Archive)
│   └── Audit Account
├── OU: Infrastructure
│   ├── Shared Services Account
│   └── Network Account
├── OU: Workloads
│   ├── OU: Production
│   │   ├── Prod Account 1
│   │   └── Prod Account 2
│   └── OU: Development
│       ├── Dev Account 1
│       └── Dev Account 2
└── OU: Sandbox
    └── Sandbox Account
```

### SCP (Service Control Policies)

- SCPs set **maximum permissions** for accounts — they don't grant permissions
- **Do NOT affect the management account** (management account is exempt)
- Do NOT affect service-linked roles
- Affect all users and roles in the account (including root user)
- Inherited hierarchically: Root → OU → Child OU → Account

#### Deny List Strategy (Recommended)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyRegionsOutsideAllowed",
      "Effect": "Deny",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "StringNotEquals": {
          "aws:RequestedRegion": ["us-east-1", "us-west-2", "eu-west-1"]
        }
      }
    }
  ]
}
```

- Start with AWS default `FullAWSAccess` SCP (allows everything)
- Attach deny SCPs for things you want to restrict
- **Easier to manage** — only define what's blocked

#### Allow List Strategy

- Remove default `FullAWSAccess` SCP
- Explicitly allow only permitted services/actions
- **More restrictive but harder to maintain**

### SCP Inheritance

```
Root: FullAWSAccess
└── OU: Deny S3
    └── Account: Allow S3 (has NO effect — parent OU denies it)
```

**Effective permissions:** Intersection of all SCPs from root to account.  
If **any level** denies an action, it's denied regardless of lower-level allows.

### Common SCP Patterns (Exam Favorites)

| Pattern | SCP Effect |
|---------|-----------|
| Deny region access | Restrict workloads to approved regions |
| Deny leaving organization | Prevent `organizations:LeaveOrganization` |
| Deny disabling CloudTrail | Prevent `cloudtrail:StopLogging` |
| Deny disabling GuardDuty | Prevent `guardduty:Disable*` |
| Deny root user actions | Deny all actions when `aws:PrincipalArn` = root |
| Require encryption | Deny S3 `PutObject` without encryption header |
| Require IMDSv2 | Deny `RunInstances` unless metadata-options require token |
| Deny public S3 | Deny `s3:PutBucketPublicAccessBlock` with less restrictive settings |

### Organization Policies (Beyond SCPs)

| Policy Type | Purpose |
|-------------|---------|
| **Tag Policies** | Enforce standardized tag key/value conventions |
| **Backup Policies** | Centralized backup plans across accounts |
| **AI Services Opt-out** | Opt out of AI services using your data |

### Organization Features

- **Consolidated Billing:** Single payer, volume discounts, RI/SP sharing
- **Delegated Administrator:** Delegate service management to member accounts (e.g., Security Hub, GuardDuty, Config)
- **CloudFormation StackSets:** Deploy stacks across accounts/regions
- **AWS Config Aggregator:** Aggregate Config data across accounts

---

## 4. IAM Identity Center (SSO)

### Key Concepts

- **Successor to AWS SSO** (renamed)
- Centralized access management for multiple AWS accounts and applications
- **Identity sources:** Identity Center directory (built-in), Active Directory (AD Connector or AWS Managed AD), or External IdP (SAML 2.0 / SCIM)
- **Permission Sets:** Define what access a user has in an account (maps to IAM role)
- One permission set → one IAM role per account where it's assigned

### ABAC (Attribute-Based Access Control)

- Use user attributes (department, team, project) from IdP as session tags
- Policies reference tags: `aws:PrincipalTag/department == "engineering"`
- Scale permissions without creating new policies for each team/project
- Tags flow from IdP → Identity Center → IAM session tags

### Permission Set Details

- Based on **managed policies** (AWS or customer) and/or **inline policy**
- Can set **session duration** (1–12 hours)
- **Relay state:** Custom URL after sign-in (e.g., specific console page)
- Permission sets create IAM roles in each assigned account

### Multi-Account Access Flow

```
User → Identity Center Portal → Select Account → Select Permission Set → Assume Role → AWS Console/CLI
```

---

## 5. Amazon Cognito

### User Pools vs Identity Pools

| Feature | User Pools | Identity Pools |
|---------|-----------|---------------|
| **Purpose** | Authentication (who you are) | Authorization (what you can access — temp AWS credentials) |
| **Function** | User directory, sign-up/sign-in | Exchange tokens for AWS credentials |
| **Output** | JWT tokens (ID, Access, Refresh) | Temporary AWS credentials (STS) |
| **Features** | MFA, email/phone verification, custom auth flows, triggers (Lambda) | Map users to IAM roles, guest access |
| **Federation** | SAML, OIDC, social (Google, Facebook, Apple, Amazon) | User Pools, SAML, OIDC, social, custom developer-authenticated |
| **Hosted UI** | Yes (customizable sign-in page) | No |
| **Integration** | ALB, API Gateway, AppSync | Direct AWS service access (S3, DynamoDB, etc.) |

### Common Architecture

```
Mobile App → Cognito User Pool (authenticate) → JWT Token
         → Cognito Identity Pool (exchange JWT for AWS credentials) → Access S3/DynamoDB
```

### User Pool Advanced Features

| Feature | Description |
|---------|-------------|
| **Lambda Triggers** | Pre sign-up, post confirmation, pre auth, post auth, custom message, token generation, migrate user |
| **Custom Auth Flow** | Define challenge/response (CUSTOM_AUTH) for passwordless, CAPTCHA, etc. |
| **Adaptive Auth** | Risk-based MFA — block or require MFA for suspicious sign-ins |
| **Groups** | Assign users to groups with IAM role mapping |
| **Resource Servers** | Define custom scopes for OAuth2 |
| **ALB Integration** | ALB can authenticate directly with User Pool (OIDC) before forwarding to targets |

### Identity Pool Role Resolution

1. **Default role:** All users get the same role
2. **Rules-based:** Map attributes (claims) to different IAM roles
3. **Token-based:** Use `cognito:preferred_role` claim from User Pool group

### Cognito vs Identity Center

| Scenario | Use |
|----------|-----|
| Customer-facing app (B2C) | **Cognito** |
| Employee/workforce AWS access | **Identity Center** |
| Mobile/web app user management | **Cognito** |
| Multi-account AWS console access | **Identity Center** |

---

## 6. Federation Patterns

### SAML 2.0 Federation

```
User → Corporate IdP (AD FS, Okta) → SAML Assertion → AWS STS (AssumeRoleWithSAML) → Temp Credentials → AWS
```

- IdP sends SAML assertion to AWS sign-in endpoint
- User is mapped to an IAM role based on SAML attributes
- No IAM user needed for each federated user

### OIDC Federation

```
User → OIDC Provider (Google, Auth0) → ID Token → AWS STS (AssumeRoleWithWebIdentity) → Temp Credentials → AWS
```

- **Best practice:** Use Cognito Identity Pools instead of direct `AssumeRoleWithWebIdentity`
- Cognito provides enhanced security, caching, and anonymous access

### Custom Identity Broker

```
User → Corporate Login → Custom Broker App → STS (GetFederationToken or AssumeRole) → Temp Credentials → AWS Console (via federation URL)
```

- Used when IdP is NOT SAML 2.0 compatible
- Broker authenticates user, calls STS, constructs console sign-in URL
- **Legacy pattern** — prefer SAML or Identity Center for new implementations

### Federation Decision Tree

```
Employee AWS Console/CLI access?
├── SAML IdP exists? → Identity Center with SAML / SAML Federation
├── Active Directory? → Identity Center with AD / AWS Managed AD
└── No standard IdP? → Custom Identity Broker (legacy)

Customer-facing web/mobile app?
├── Need user directory? → Cognito User Pool
├── Need AWS resource access? → Cognito Identity Pool
└── Social login? → Cognito User Pool (social federation)
```

---

## 7. AWS KMS

### Key Types

| Key Type | Description | Rotation | Management |
|----------|-------------|----------|------------|
| **AWS Owned Keys** | Used by AWS services (e.g., SSE-S3) | Varies (AWS manages) | AWS |
| **AWS Managed Keys** | `aws/service-name` (e.g., `aws/s3`, `aws/ebs`) | Auto every 1 year | AWS (you can view, not manage) |
| **Customer Managed Keys (CMK)** | You create and manage | Optional: auto every 1 year, on-demand | You |
| **Imported Key Material** | Your key material imported into KMS | No auto-rotation (manual only) | You (can set expiration) |

### KMS Key Policies

- **Every KMS key must have a key policy** (unlike IAM where policies are optional)
- **Default key policy:** Gives the root user full access, enables IAM policies
- **Custom key policy:** Define specific principals, actions, conditions
- Without the default key policy granting root access, IAM policies alone cannot grant KMS access

### Grants

- Temporary, scoped permissions for KMS keys
- Programmatic delegation without modifying key policy
- Use case: AWS service needs to use your key (e.g., EBS encrypting/decrypting)
- Grant tokens provide immediate access before grant propagates
- Can be retired or revoked

### Envelope Encryption

```
1. GenerateDataKey → Returns plaintext data key + encrypted data key
2. Use plaintext data key to encrypt your data (client-side)
3. Store encrypted data key alongside encrypted data
4. Delete plaintext data key from memory
5. To decrypt: Decrypt encrypted data key via KMS → use plaintext to decrypt data
```

- **Why:** KMS has 4 KB encryption limit for direct `Encrypt` call
- Envelope encryption lets you encrypt data of **any size**
- Only the data key is sent to KMS — your data never leaves your application

### Multi-Region Keys

- Primary key in one region, replica keys in other regions
- **Same key ID and key material** across regions
- Use cases: cross-region decryption (DynamoDB Global Tables, S3 cross-region), DR
- **NOT global** — must be explicitly replicated to chosen regions
- Managed independently (can have different key policies per region)
- Can encrypt in one region, decrypt in another without cross-region KMS calls

### Key Rotation

| Key Type | Auto-Rotation | Manual Rotation |
|----------|--------------|-----------------|
| AWS Managed | Every year (automatic, mandatory) | N/A |
| Customer Managed (KMS-generated) | Optional, every year | Create new key, update alias |
| Customer Managed (imported material) | Not supported | Create new key, re-import new material, update alias |

- Auto-rotation: KMS keeps old key material for decryption, uses new material for encryption
- **Alias pointing** is the recommended manual rotation strategy

### KMS Request Quotas

| Operation | Shared Quota per Region per Account |
|-----------|-------------------------------------|
| Cryptographic operations (Encrypt, Decrypt, GenerateDataKey, etc.) | 5,500–30,000 requests/sec (varies by region and key type) |
| Symmetric: | 5,500–30,000/sec |
| Asymmetric RSA: | 500/sec |
| Asymmetric ECC: | 300/sec |

- If throttled: implement exponential backoff, use data key caching, or request quota increase

### KMS ViaService Condition

- Restrict key usage to specific AWS services only:

```json
{
  "Condition": {
    "StringEquals": {
      "kms:ViaService": "s3.us-east-1.amazonaws.com"
    }
  }
}
```

---

## 8. AWS CloudHSM

### Key Characteristics

| Feature | Details |
|---------|---------|
| **Hardware** | Dedicated FIPS 140-2 Level 3 validated HSM |
| **Tenancy** | Single-tenant (your dedicated hardware) |
| **Key control** | You have exclusive control (AWS cannot access your keys) |
| **Availability** | Deploy in cluster (min 2 HSMs across AZs for HA) |
| **Integration** | SSL/TLS offload, Oracle TDE, Microsoft SignTool, custom crypto, KMS Custom Key Store |
| **Pricing** | ~$1.50/HSM/hour |
| **Protocols** | PKCS#11, JCE, CNG |

### CloudHSM vs KMS

| Feature | KMS | CloudHSM |
|---------|-----|----------|
| Tenancy | Multi-tenant | Single-tenant |
| FIPS 140-2 | Level 3 (some Level 2) | Level 3 |
| Key access | AWS + you | Only you |
| HA | AWS managed | You manage (2+ HSMs) |
| Integration | 100+ AWS services | Custom apps, KMS Custom Key Store |
| Cost | $1/key/month | ~$1.50/hour/HSM |
| Use case | Standard encryption | Regulatory, Oracle TDE, custom crypto, full key control |

### KMS Custom Key Store

- Use CloudHSM as the backend for KMS keys
- Get the KMS API integration with CloudHSM's dedicated hardware
- Keys are generated and stored in YOUR CloudHSM cluster
- Use case: regulatory requirement for dedicated HSM + need KMS service integration

---

## 9. AWS Certificate Manager (ACM)

### Public vs Private Certificates

| Feature | Public Certificates | Private Certificates |
|---------|-------------------|---------------------|
| **Cost** | Free | $400/month per CA + $0.75/cert |
| **Issuer** | Amazon Trust Services (public CA) | AWS Private CA (your private CA) |
| **Validation** | DNS or Email | No validation needed (you control the CA) |
| **Auto-renewal** | Yes (if DNS validation and used with ACM-integrated service) | Yes |
| **Use case** | Public-facing websites/APIs | Internal services, mutual TLS, IoT devices |
| **Export** | No (private key not exportable) | Yes (can export private key) |

### ACM Integration Points

| Service | Supported |
|---------|-----------|
| CloudFront | Yes (must be in us-east-1) |
| ALB | Yes |
| NLB | Yes (TLS listener) |
| API Gateway (Edge) | Yes (must be in us-east-1) |
| API Gateway (Regional) | Yes (same region) |
| Elastic Beanstalk | Yes (via ALB) |
| CloudFormation | Yes |
| **EC2 directly** | **No** (use private CA and export, or manage certs yourself) |

### DNS Validation vs Email Validation

| Feature | DNS Validation | Email Validation |
|---------|---------------|-----------------|
| **Method** | Add CNAME record to DNS | Reply to validation email |
| **Auto-renewal** | Yes (if CNAME stays) | No (manual re-validation) |
| **Recommended** | Yes | No (legacy) |
| **Automation** | Full (CloudFormation, CLI) | Requires human interaction |

---

## 10. Secrets Manager vs Parameter Store

| Feature | Secrets Manager | Parameter Store |
|---------|----------------|-----------------|
| **Auto-rotation** | Yes (Lambda function) | No |
| **Encryption** | Always (KMS mandatory) | Optional (SecureString) |
| **Cost** | $0.40/secret/month | Free (Standard), $0.05/Advanced/month |
| **Max size** | 64 KB | 4 KB (Standard), 8 KB (Advanced) |
| **Versioning** | Automatic | Yes |
| **Cross-account** | Yes (resource-based policy) | No |
| **Hierarchy** | Flat namespace | Hierarchical (/app/env/key) |
| **CloudFormation** | Dynamic reference `{{resolve:secretsmanager:...}}` | Dynamic reference `{{resolve:ssm:...}}` |
| **RDS/Aurora integration** | Direct integration for rotation | Manual |
| **Throughput** | Higher (default 10,000/sec) | 40/sec (Standard), 10,000/sec (Advanced with higher throughput) |

### Secrets Manager Rotation

- Managed rotation for RDS, Redshift, DocumentDB (built-in Lambda functions)
- Custom rotation for other secrets (you provide Lambda function)
- Rotation workflow: create new version → test → mark as current
- **Multi-user rotation:** Alternates between two users to avoid downtime during rotation

---

## 11. Threat Detection & Security Services

### GuardDuty

| Feature | Details |
|---------|---------|
| **What** | Intelligent threat detection using ML, anomaly detection, and threat intelligence |
| **Data sources** | VPC Flow Logs, DNS Logs, CloudTrail events, S3 data events, EKS audit logs, RDS login activity, Lambda network activity, runtime monitoring (EKS, ECS, EC2) |
| **Findings** | Categorized by resource type (EC2, S3, IAM, EKS, RDS, Lambda) |
| **Multi-account** | Delegated administrator manages across Organization |
| **Remediation** | EventBridge → Lambda/Step Functions/SSM automation |
| **Key finding types** | Cryptocurrency mining, credential exfiltration, unauthorized access, data exfiltration, DNS exfiltration, privilege escalation |

### Amazon Inspector

| Feature | Details |
|---------|---------|
| **What** | Automated vulnerability management / assessment |
| **Targets** | EC2 instances (via SSM agent), ECR container images, Lambda functions |
| **Checks** | CVE database, network reachability, CIS benchmarks (EC2) |
| **Scoring** | Inspector risk score (modified CVSS) |
| **Automation** | Continuous scanning — auto-rescans when new CVE published or instance state changes |
| **Integration** | Security Hub, EventBridge |

### Amazon Macie

| Feature | Details |
|---------|---------|
| **What** | Sensitive data discovery and protection for S3 |
| **Detection** | PII, PHI, financial data, credentials, API keys, custom data identifiers (regex) |
| **Scanning** | One-time or scheduled jobs on S3 buckets |
| **Integration** | Security Hub, EventBridge |
| **Multi-account** | Delegated administrator support |

### Amazon Detective

| Feature | Details |
|---------|---------|
| **What** | Security investigation and root cause analysis |
| **Data** | VPC Flow Logs, CloudTrail, GuardDuty findings, EKS audit logs |
| **Analysis** | Behavior graphs, entity profiles, visualizations showing relationships |
| **Use case** | "GuardDuty found something suspicious — let me investigate what happened" |

### Security Hub

| Feature | Details |
|---------|---------|
| **What** | Central security posture dashboard |
| **Inputs** | GuardDuty, Inspector, Macie, Firewall Manager, IAM Access Analyzer, Config, third-party |
| **Standards** | CIS AWS Foundations, PCI DSS, NIST 800-53, AWS Foundational Security Best Practices |
| **Compliance** | Automated compliance scoring per standard |
| **Multi-account** | Delegated administrator, automatic member enrollment via Organizations |
| **Actions** | Custom actions → EventBridge → Lambda / SSM / Step Functions |
| **Cross-region** | Aggregation region collects findings from linked regions |

### Detection & Response Flow

```
GuardDuty (detect threats)
Inspector (find vulnerabilities)
Macie (find sensitive data)
    ↓
Security Hub (aggregate, prioritize, compliance)
    ↓
EventBridge (trigger automation)
    ↓
Lambda / Step Functions / SSM (remediate)
    ↓
Detective (investigate when needed)
```

### IAM Access Analyzer

| Feature | Details |
|---------|---------|
| **External Access** | Identifies resources shared with external entities (other accounts, public) |
| **Unused Access** | Identifies unused IAM roles, users, permissions, access keys |
| **Policy Generation** | Generate least-privilege policies based on CloudTrail activity |
| **Policy Validation** | Validate policies against best practices before deployment |
| **Custom Policy Checks** | Check policies against custom rules |
| **Resources analyzed** | S3, IAM, KMS, Lambda, SQS, Secrets Manager, SNS, EFS, ECR |

---

## 12. AWS Config

### Key Concepts

- **Records** configuration changes to AWS resources over time
- **Config Rules** evaluate resource configurations for compliance
- **Conformance Packs** are collections of Config rules and remediation actions
- **Aggregator** collects Config data across accounts and regions

### Config Rules Types

| Type | Description |
|------|-------------|
| **AWS Managed Rules** | Pre-built rules (150+): `s3-bucket-ssl-requests-only`, `ec2-instance-no-public-ip`, etc. |
| **Custom Rules** | Lambda-backed (your logic) or Guard-backed (Guard DSL) |
| **Organization Rules** | Deploy rules across all accounts in Organization |

### Evaluation Triggers

| Trigger | Description |
|---------|-------------|
| **Configuration change** | Evaluate when resource config changes |
| **Periodic** | Evaluate at intervals (1h, 3h, 6h, 12h, 24h) |

### Auto-Remediation

```
Config Rule (non-compliant) → SSM Automation Document → Fix Resource
```

- **Auto-remediation:** Automatically invoke SSM Automation when resource is non-compliant
- **Manual remediation:** Create a remediation action for manual approval
- Built-in SSM Automation documents for common fixes (e.g., enable S3 encryption, enable VPC Flow Logs)
- Custom SSM Automation for complex remediation

### Config Multi-Account

- **Config Aggregator:** Central account collects Config data from all accounts
- **Organization Aggregator:** Automatically collects from all accounts in the org
- Conformance Packs can be deployed organization-wide

---

## 13. CloudTrail

### Trail Types

| Feature | Single-Region Trail | Multi-Region Trail | Organization Trail |
|---------|--------------------|--------------------|-------------------|
| **Scope** | One region | All regions | All accounts + all regions |
| **New region handling** | Manual | Auto-captures new regions | Auto-captures new accounts/regions |
| **Recommended** | Dev/test | Production | Multi-account production |

### Event Types

| Event Type | Description | Default |
|-----------|-------------|---------|
| **Management Events** | Control plane operations (create/modify/delete resources) | Logged by default |
| **Data Events** | Data plane operations (S3 object-level, Lambda invocations, DynamoDB item-level) | NOT logged by default (higher volume, extra cost) |
| **Insight Events** | Unusual API activity detection (rate-based anomaly detection) | NOT logged by default |

### CloudTrail Log Integrity

- **Log file validation:** Creates a hash digest for each log file
- Digest files delivered every hour to the same S3 bucket
- Use `aws cloudtrail validate-logs` CLI to verify no logs were modified or deleted
- Use case: Compliance, forensics, legal proceedings

### CloudTrail Integration

| Destination | Purpose |
|-------------|---------|
| **S3** | Long-term storage, compliance archive |
| **CloudWatch Logs** | Real-time monitoring, metric filters, alarms |
| **EventBridge** | Real-time event routing to targets |
| **Athena** | Ad-hoc query of CloudTrail logs in S3 |
| **CloudTrail Lake** | Managed query and storage (SQL-based, up to 7 years) |

### Organization Trail

- Created in management account, applies to ALL member accounts
- Member accounts can see the trail but cannot modify or delete it
- Logs delivered to S3 bucket in management account (or delegated admin)
- Includes all management events across the entire organization

### Key Exam Scenarios

| Scenario | Solution |
|----------|----------|
| "Ensure CloudTrail cannot be disabled" | SCP denying `cloudtrail:StopLogging` and `cloudtrail:DeleteTrail` |
| "Prove logs haven't been tampered" | Enable log file validation, use digest files |
| "Alert on root user activity" | CloudWatch Logs metric filter on `userIdentity.type = Root` → SNS alarm |
| "Query CloudTrail across accounts" | Organization trail + Athena or CloudTrail Lake |
| "Detect unusual API activity" | CloudTrail Insights |

---

## 14. VPC Security

### Security Layers

```
Internet → Route 53 DNS Firewall → CloudFront (WAF) → ALB (WAF + Security Group)
→ Network Firewall → NACL → Security Group → Instance
```

### Security Groups — Key Points

- **Stateful:** Return traffic automatically allowed
- **Allow rules only** (no deny rules)
- Can reference other security groups (within same VPC or peered VPC)
- Changes take effect immediately
- Default SG: deny all inbound, allow all outbound

### NACLs — Key Points

- **Stateless:** Must explicitly allow return traffic (ephemeral ports)
- Allow AND deny rules
- Evaluated by rule number (lowest first)
- One NACL per subnet (default NACL allows all)
- Default NACL: allows all; Custom NACL: denies all by default

### VPC Flow Logs for Security

- Capture traffic metadata (not content)
- Use for: security analysis, compliance auditing, network troubleshooting
- Rejected traffic analysis → identify attempted breaches
- Can send to S3 → Athena for analysis, or CloudWatch Logs for real-time alerting

---

## 15. S3 Security

### S3 Access Control (In Order of Recommendation)

1. **Bucket Policies** (recommended — resource-based policies)
2. **IAM Policies** (identity-based, for your users/roles)
3. **VPC Endpoint Policies** (restrict access through VPC endpoint)
4. **Access Points** (simplified access management for large data sets)
5. **S3 Object Ownership** (disable ACLs — recommended)
6. **ACLs** (legacy — not recommended)

### S3 Encryption Options

| Method | Key Management | Server/Client | Use Case |
|--------|---------------|---------------|----------|
| **SSE-S3** | AWS managed (AES-256) | Server-side | Default, simplest |
| **SSE-KMS** | KMS (AWS or Customer managed key) | Server-side | Audit trail, key rotation, fine-grained control |
| **SSE-C** | Customer-provided key (in request) | Server-side | Customer controls keys completely |
| **CSE** | Client manages encryption | Client-side | Encrypt before upload, most control |

### S3 Default Encryption

- All new objects are encrypted by default (SSE-S3 since Jan 2023)
- Bucket-level default: can set SSE-KMS as default
- Bucket policy can **deny** unencrypted uploads:

```json
{
  "Condition": {
    "StringNotEquals": {
      "s3:x-amz-server-side-encryption": "aws:kms"
    }
  }
}
```

### S3 Object Lock

| Mode | Description |
|------|-------------|
| **Governance** | Users with special permissions can override lock |
| **Compliance** | Nobody can delete/overwrite — not even root user |
| **Legal Hold** | Indefinite hold until explicitly removed, no retention period |

- Requires **versioning** enabled
- Can set **retention period** (days) for Governance/Compliance modes
- Use case: regulatory compliance (SEC, FINRA), evidence preservation

### S3 Access Points

- Simplify S3 access management for large datasets with many users/apps
- Each access point has its own DNS name and access policy
- Can restrict access to specific VPC (VPC-only access points)
- **Multi-Region Access Points:** Single endpoint that routes to nearest S3 bucket (requires CRR/SRR)
- **Object Lambda Access Point:** Transform data on retrieval (add watermark, redact PII, decompress)

### Block Public Access

- Account-level and bucket-level settings
- **Four settings:** Block new public ACLs, remove existing public ACLs, block new public bucket policies, block public and cross-account access via any public policy
- **Best practice:** Enable all four at the account level, override per bucket only when needed

---

## 16. Network Firewall, WAF & Shield

### AWS Network Firewall

- Stateful/stateless firewall at the VPC level
- Deployed in a **firewall subnet** (dedicated)
- Supports **Suricata** rule format for IPS
- Domain name filtering (HTTP/HTTPS)
- TLS inspection (decrypt, inspect, re-encrypt)
- Centralized deployment via Transit Gateway architecture

### WAF (Web Application Firewall)

- Attached to: **CloudFront, ALB, API Gateway, AppSync, Cognito, App Runner, Verified Access**
- **Web ACL** contains rules evaluated by priority (lowest number first)
- **Rate-based rules:** Block IPs exceeding request threshold (per 5-min window)
- **Managed Rule Groups:** AWS-managed and Marketplace rules
- **IP reputation lists:** Block known malicious IPs
- **Geo-match:** Block/allow by country
- **Bot Control:** Managed (common) + Targeted (ML-based) bot detection
- **Logging:** CloudWatch Logs, S3, Kinesis Data Firehose

### Shield

| Feature | Standard | Advanced |
|---------|----------|----------|
| **Automatic** | Yes (all AWS accounts) | Must subscribe |
| **Layer 3/4** | Always-on detection + inline mitigation | Enhanced detection, more sensitive |
| **Layer 7** | No | Yes (with WAF integration) |
| **Cost protection** | No | Yes (DDoS-related scaling costs refunded) |
| **Health-based** | No | Yes (Route 53 health checks → faster detection) |
| **SRT** | No | 24/7 Shield Response Team access |
| **Visibility** | No | Attack dashboards, real-time metrics, forensics |

### AWS Firewall Manager

- Centrally manage security policies across all accounts in an Organization
- **Policy types:** WAF, Shield Advanced, Security Groups, Network Firewall, Route 53 Resolver DNS Firewall, third-party firewall (Palo Alto, Fortigate via GWLB)
- Requires **Organizations** and a **Firewall Manager administrator account**
- Auto-applies policies to new resources and accounts

---

## 17. Resource Access Manager (RAM)

### What Can Be Shared

| Resource | Shareable Via RAM |
|----------|------------------|
| VPC Subnets | Yes |
| Transit Gateways | Yes |
| Route 53 Resolver Rules | Yes |
| License Manager Configurations | Yes |
| Aurora DB Clusters | Yes |
| CodeBuild Projects | Yes |
| EC2 (Dedicated Hosts, Capacity Reservations) | Yes |
| Prefix Lists | Yes |
| AWS Network Firewall Policies | Yes |
| Systems Manager Incident Manager | Yes |
| Outposts | Yes |
| Glue (catalog, databases, tables) | Yes |
| Resource Groups | Yes |

### Key Points

- Share resources with **individual accounts** or **entire Organization**
- Participant accounts can use the shared resource but cannot modify it
- **VPC Subnet sharing:** Allows different accounts to launch resources in the same subnet (reduces VPC sprawl)
- If sharing within an Organization, no invitation needed (auto-accepted)
- Resources are shared, not duplicated — no data transfer charges

### Shared VPC Architecture

- Owner account creates VPC and subnets
- Shares subnets via RAM with participant accounts
- Participants launch their own resources (EC2, RDS, Lambda) in shared subnets
- Each account manages its own resources
- Network connectivity is automatic (same VPC)
- Security Groups can reference cross-account SGs in the shared VPC

---

## 18. Control Tower & Landing Zone

### AWS Control Tower

| Feature | Description |
|---------|-------------|
| **Purpose** | Automated multi-account governance setup |
| **Landing Zone** | Pre-configured multi-account environment (best practices) |
| **Account Factory** | Automated provisioning of new accounts with baselines |
| **Guardrails** | Governance rules applied across accounts |
| **Dashboard** | Central compliance view |

### Guardrail Types

| Type | Mechanism | Description |
|------|-----------|-------------|
| **Preventive** | SCPs | Prevent non-compliant actions (e.g., deny public S3) |
| **Detective** | Config Rules | Detect non-compliant resources (e.g., MFA not enabled) |
| **Proactive** | CloudFormation Hooks | Block non-compliant resources before provisioning |

### Guardrail Levels

| Level | Description |
|-------|-------------|
| **Mandatory** | Always enabled, cannot be disabled (e.g., CloudTrail enabled) |
| **Strongly Recommended** | AWS best practices (e.g., encryption at rest) |
| **Elective** | Optional, for specific requirements |

### Landing Zone Accounts

| Account | Purpose |
|---------|---------|
| **Management Account** | Organization root, billing, Control Tower management |
| **Log Archive Account** | Centralized logging (CloudTrail, Config) — restricted access |
| **Audit Account** | Security team access, cross-account audit role |
| **Member Accounts** | Workload accounts (provisioned via Account Factory) |

### Control Tower Customizations

- **Customizations for Control Tower (CfCT):** Deploy custom CloudFormation templates and SCPs when new accounts are created
- **Account Factory for Terraform (AFT):** Terraform-based account provisioning pipeline

---

## 19. Audit Manager & Artifact

### AWS Audit Manager

| Feature | Description |
|---------|-------------|
| **Purpose** | Automated evidence collection for audits |
| **Frameworks** | Pre-built (CIS, PCI DSS, GDPR, HIPAA, SOC 2, NIST) + custom |
| **Evidence** | Config snapshots, CloudTrail events, Config compliance, Security Hub findings |
| **Assessment** | Continuous evidence collection mapped to controls |
| **Reports** | Generate audit-ready reports for auditors |
| **Delegation** | Delegate assessments to teams/owners |

### AWS Artifact

| Feature | Description |
|---------|-------------|
| **Purpose** | Access AWS compliance reports and agreements |
| **Reports** | SOC 1/2/3, PCI DSS, ISO 27001, FedRAMP, HIPAA BAA |
| **Agreements** | BAA (Business Associate Addendum), NDA |
| **Self-service** | Download directly from console |
| **Scope** | Organization-level agreements available |

### Audit Manager vs Config vs Security Hub

| Tool | Purpose |
|------|---------|
| **Config** | Track resource configurations, evaluate compliance rules |
| **Security Hub** | Aggregate security findings, automated compliance checks |
| **Audit Manager** | Map evidence to audit frameworks, generate audit reports |

---

## Security Architecture Patterns (Exam Favorites)

### Pattern 1: Cross-Account Access

```
Account A (Dev) → AssumeRole → Account B (Prod) Role
- Trust policy in Account B allows Account A
- Identity policy in Account A allows sts:AssumeRole
- Optional: Require ExternalId, MFA, SourceIP condition
```

### Pattern 2: Centralized Logging

```
All Accounts → CloudTrail (Organization Trail) → S3 (Log Archive Account)
              → Config (Organization Aggregator) → S3 (Log Archive Account)
              → GuardDuty (Delegated Admin) → Security Hub (Delegated Admin)
```

### Pattern 3: Data Encryption at Rest (Everywhere)

```
S3 → SSE-KMS (CMK with key policy)
EBS → KMS encryption (default encryption per account/region)
RDS → KMS encryption (cannot encrypt existing unencrypted DB — snapshot, copy encrypted, restore)
DynamoDB → AWS owned or CMK encryption
EFS → KMS encryption
Secrets Manager → Always KMS encrypted
```

### Pattern 4: Perimeter Security (Defense in Depth)

```
Internet → Route 53 (DNS Firewall)
        → CloudFront + WAF (L7 protection, geo-blocking, bot control)
        → Shield Advanced (DDoS protection)
        → ALB + WAF (additional rules) + Security Group
        → Network Firewall (IPS, domain filtering)
        → NACL (subnet level, deny rules)
        → Security Group (instance level, allow rules)
        → Application-level auth (Cognito, custom)
```

### Pattern 5: Least Privilege Delegation

```
Admin creates Permission Boundary defining MAX permissions
Admin creates IAM policy allowing developers to create roles/users
  - Condition: iam:PermissionsBoundary must be set to the boundary ARN
Developers can create roles, but those roles can never exceed the boundary
```
