# Multi-Account Topology & AWS Organizations

## 1. AWS Organizations OU Hierarchy

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                            MANAGEMENT ACCOUNT                                   │
│                     (Org root, billing, SCPs, CloudFormation StackSets)          │
│                          Account ID: 111111111111                                │
└──────────────────────────────────┬──────────────────────────────────────────────┘
                                   │
               ┌───────────────────┼───────────────────────┐
               │                   │                       │
               ▼                   ▼                       ▼
  ┌────────────────────┐ ┌──────────────────┐  ┌─────────────────────┐
  │   SECURITY OU      │ │ INFRASTRUCTURE   │  │   WORKLOADS OU      │
  │                    │ │      OU          │  │                     │
  │  SCP: Deny region  │ │                  │  │  SCP: Require       │
  │  outside allowed   │ │  SCP: Restrict   │  │  encryption, deny   │
  │                    │ │  public access   │  │  leaving org        │
  └──┬─────────────┬───┘ └──┬──────────┬───┘  └──┬──────────────┬───┘
     │             │        │          │          │              │
     ▼             ▼        ▼          ▼          ▼              ▼
┌─────────┐ ┌─────────┐ ┌────────┐ ┌────────┐ ┌────────────┐ ┌────────────┐
│Log       │ │Security │ │Network │ │Shared  │ │  Prod OU   │ │Non-Prod OU │
│Archive   │ │Tooling  │ │Hub     │ │Services│ │            │ │            │
│Account   │ │Account  │ │Account │ │Account │ │┌──────────┐│ │┌──────────┐│
│          │ │         │ │        │ │        │ ││App-A Prod││ ││App-A Dev ││
│222222222 │ │33333333 │ │444444  │ │555555  │ ││App-B Prod││ ││App-B Dev ││
│          │ │         │ │        │ │        │ ││App-C Prod││ ││Staging   ││
└─────────┘ └─────────┘ └────────┘ └────────┘ │└──────────┘│ │└──────────┘│
                                               └────────────┘ └────────────┘

                         ┌──────────────────┐
                         │   SANDBOX OU     │
                         │                  │
                         │  SCP: Budget     │
                         │  limits, no prod │
                         │  services        │
                         │                  │
                         │ ┌──────────────┐ │
                         │ │ Dev sandbox  │ │
                         │ │ accounts     │ │
                         │ │ (per-dev or  │ │
                         │ │  per-team)   │ │
                         │ └──────────────┘ │
                         └──────────────────┘
```

### SCP Inheritance Model

```
          ROOT (SCP: FullAWSAccess)
              │
              ├── SCP applied here inherits DOWN to ALL child OUs/accounts
              │
              ├── Security OU ── SCP: DenyAllExcept{us-east-1, us-west-2}
              │     │
              │     ├── Log Archive ── Effective: ROOT ∩ Security_OU SCPs
              │     └── Security Tooling ── Effective: ROOT ∩ Security_OU SCPs
              │
              └── Workloads OU ── SCP: RequireEncryption, DenyLeaveOrg
                    │
                    ├── Prod OU ── SCP: DenyDeleteCloudTrail, DenyModifyConfig
                    │     │
                    │     └── App Account ── Effective: ROOT ∩ Workloads ∩ Prod SCPs
                    │
                    └── Non-Prod OU ── SCP: RestrictInstanceTypes
                          │
                          └── Dev Account ── Effective: ROOT ∩ Workloads ∩ Non-Prod SCPs

  ┌──────────────────────────────────────────────────────────────────┐
  │  KEY: SCPs are DENY filters (intersection). An action must be   │
  │  allowed at EVERY level. SCPs never GRANT — they only restrict. │
  │  Management account is EXEMPT from SCPs.                        │
  └──────────────────────────────────────────────────────────────────┘
```

### Key Concepts

| Component | Purpose | Exam Notes |
|-----------|---------|------------|
| **Management Account** | Org root, billing consolidation, StackSets delegated admin | Keep minimal workloads here; exempt from SCPs |
| **Security OU** | Log archive + security tooling | Immutable logs; cross-account read-only access |
| **Infrastructure OU** | Networking, shared services | Transit Gateway owner, DNS, directory |
| **Workloads OU** | Application accounts by environment | Separate Prod/Non-Prod sub-OUs |
| **Sandbox OU** | Developer experimentation | Aggressive budget SCPs, auto-nuke policies |

---

## 2. Control Tower Landing Zone Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         AWS CONTROL TOWER                                   │
│                                                                             │
│  ┌─────────────────┐  ┌──────────────────┐  ┌───────────────────────────┐  │
│  │  Account Factory │  │  Guardrails      │  │  Dashboard                │  │
│  │  (Service Catalog │  │  (Preventive=SCP │  │  (Compliance status,     │  │
│  │   + Lambda)      │  │   Detective=     │  │   drift detection)       │  │
│  │                  │  │   Config Rules)  │  │                          │  │
│  └────────┬─────────┘  └────────┬─────────┘  └───────────────────────────┘  │
│           │                     │                                            │
└───────────┼─────────────────────┼────────────────────────────────────────────┘
            │                     │
            ▼                     ▼
┌───────────────────────────────────────────────────────────────────────────────┐
│                        LANDING ZONE STRUCTURE                                 │
│                                                                               │
│  ┌──────────────────────────────────────────────────────────────────────────┐ │
│  │                     Management Account                                   │ │
│  │  • AWS Organizations    • AWS SSO (IAM Identity Center)                 │ │
│  │  • Control Tower        • CloudFormation StackSets                      │ │
│  │  • Service Catalog      • AWS Config (delegated to Security Tooling)    │ │
│  └──────────────────────────────────────────────────────────────────────────┘ │
│                                                                               │
│  ┌─────────────────────────┐   ┌──────────────────────────────────────────┐  │
│  │  LOG ARCHIVE ACCOUNT    │   │  AUDIT (SECURITY TOOLING) ACCOUNT       │  │
│  │                         │   │                                          │  │
│  │  ┌───────────────────┐  │   │  ┌────────────────────────────────────┐  │  │
│  │  │ S3: CloudTrail    │  │   │  │  Cross-Account Access Roles:      │  │  │
│  │  │     Logs          │◄─┼───┼──│  • AWSControlTowerExecution       │  │  │
│  │  │ (org trail)       │  │   │  │  • ReadOnly for forensics         │  │  │
│  │  ├───────────────────┤  │   │  │  • Config Aggregator              │  │  │
│  │  │ S3: Config        │  │   │  │  • GuardDuty Admin                │  │  │
│  │  │     Snapshots     │◄─┼───┼──│  • Security Hub Admin             │  │  │
│  │  ├───────────────────┤  │   │  └────────────────────────────────────┘  │  │
│  │  │ S3: Access Logs   │  │   │                                          │  │
│  │  │ (S3 server logs)  │  │   │  ┌────────────────────────────────────┐  │  │
│  │  └───────────────────┘  │   │  │  SNS Topics for Alerts:           │  │  │
│  │                         │   │  │  • GuardDuty findings              │  │  │
│  │  Bucket policy: DENY    │   │  │  • Config non-compliance           │  │  │
│  │  delete, require SSE    │   │  │  • CloudTrail anomalies            │  │  │
│  │  Object Lock (optional) │   │  └────────────────────────────────────┘  │  │
│  └─────────────────────────┘   └──────────────────────────────────────────┘  │
│                                                                               │
│  ┌──────────────────────────────────────────────────────────────────────────┐ │
│  │               ENROLLED MEMBER ACCOUNTS (via Account Factory)             │ │
│  │                                                                          │ │
│  │   ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐               │ │
│  │   │ Account  │  │ Account  │  │ Account  │  │ Account  │  ...           │ │
│  │   │ (Prod)   │  │ (Dev)    │  │ (Network)│  │ (Shared) │               │ │
│  │   │          │  │          │  │          │  │          │               │ │
│  │   │• CloudTr.│  │• CloudTr.│  │• CloudTr.│  │• CloudTr.│               │ │
│  │   │• Config  │  │• Config  │  │• Config  │  │• Config  │               │ │
│  │   │• SSO     │  │• SSO     │  │• SSO     │  │• SSO     │               │ │
│  │   │• Guard-  │  │• Guard-  │  │• Guard-  │  │• Guard-  │               │ │
│  │   │  rails   │  │  rails   │  │  rails   │  │  rails   │               │ │
│  │   └──────────┘  └──────────┘  └──────────┘  └──────────┘               │ │
│  └──────────────────────────────────────────────────────────────────────────┘ │
└───────────────────────────────────────────────────────────────────────────────┘
```

### Guardrail Types

| Type | Mechanism | Example |
|------|-----------|---------|
| **Preventive (mandatory)** | SCP | Disallow changes to CloudTrail config |
| **Preventive (elective)** | SCP | Disallow internet access for VPCs |
| **Detective (mandatory)** | AWS Config | Detect root account usage |
| **Detective (elective)** | AWS Config | Detect MFA not enabled for IAM users |
| **Proactive** | CloudFormation Hooks | Check resources before provisioning |

### Exam Tips
- Control Tower manages **landing zone** with **Account Factory** (Service Catalog product)
- **Customizations for Control Tower (CfCT)** extends landing zone with custom CloudFormation
- Control Tower **cannot be retroactively applied** — you enroll existing accounts
- **Drift detection** identifies when guardrails are violated or modified

---

## 3. Centralized Logging Architecture

```
┌────────────────────────────────────────────────────────────────────────────────┐
│                      MEMBER ACCOUNTS (Each Account)                            │
│                                                                                │
│  ┌──────────────┐   ┌──────────────────┐   ┌─────────────────┐                │
│  │  CloudTrail   │   │  CloudWatch Logs  │   │  VPC Flow Logs  │               │
│  │  (per-account │   │  (application     │   │  (ENI-level or  │               │
│  │   trail)      │   │   logs, Lambda    │   │   VPC-level)    │               │
│  │              │   │   logs)           │   │                 │               │
│  └──────┬───────┘   └────────┬──────────┘   └────────┬────────┘               │
│         │                    │                        │                         │
│         │                    │                        │                         │
└─────────┼────────────────────┼────────────────────────┼─────────────────────────┘
          │                    │                        │
          ▼                    ▼                        ▼
  ┌───────────────┐   ┌───────────────────┐   ┌──────────────────┐
  │ Org CloudTrail│   │ CW Subscription   │   │ Flow Log → CW    │
  │ Trail (from   │   │ Filter            │   │ Log Group or S3  │
  │ mgmt account) │   │                   │   │                  │
  └───────┬───────┘   └────────┬──────────┘   └────────┬─────────┘
          │                    │                        │
          │            ┌───────▼──────────┐             │
          │            │ Kinesis Data     │             │
          │            │ Firehose         │             │
          │            │ (cross-account   │             │
          │            │  delivery)       │             │
          │            │                  │             │
          │            │ Buffer: 60s/5MB  │             │
          │            │ Transform: Lambda│             │
          │            └───────┬──────────┘             │
          │                    │                        │
          ▼                    ▼                        ▼
┌────────────────────────────────────────────────────────────────────────────────┐
│                     LOG ARCHIVE ACCOUNT (222222222222)                          │
│                                                                                │
│  ┌─────────────────────────────────────────────────────────────────────┐       │
│  │                     S3 LOG BUCKETS                                   │       │
│  │                                                                     │       │
│  │  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────────┐   │       │
│  │  │ cloudtrail-org/ │ │ cloudwatch-     │ │ vpc-flow-logs/      │   │       │
│  │  │                 │ │ centralized/    │ │                     │   │       │
│  │  │ AWSLogs/        │ │                 │ │ AWSLogs/            │   │       │
│  │  │  {acct-id}/     │ │ {acct-id}/      │ │  {acct-id}/         │   │       │
│  │  │   CloudTrail/   │ │  {log-group}/   │ │   vpcflowlogs/     │   │       │
│  │  │    {region}/    │ │   {date}/       │ │    {date}/          │   │       │
│  │  │     {date}/     │ │                 │ │                     │   │       │
│  │  └─────────────────┘ └─────────────────┘ └─────────────────────┘   │       │
│  │                                                                     │       │
│  │  BUCKET POLICIES:                                                   │       │
│  │  • Allow org trail delivery (aws:PrincipalOrgID condition)          │       │
│  │  • Deny s3:DeleteObject, s3:PutBucketPolicy from non-admin         │       │
│  │  • Require aws:SecureTransport (TLS)                                │       │
│  │  • Server-side encryption: SSE-S3 or SSE-KMS                       │       │
│  │  • S3 Object Lock (WORM) for compliance                            │       │
│  │                                                                     │       │
│  │  LIFECYCLE:                                                         │       │
│  │  • Standard → IA (90 days) → Glacier (365 days) → Delete (7 yrs)  │       │
│  └─────────────────────────────────────────────────────────────────────┘       │
│                                                                                │
│         │                                                                      │
│         ▼                                                                      │
│  ┌─────────────────────────────────────────────────────────────────────┐       │
│  │  QUERYING & ANALYSIS                                                │       │
│  │                                                                     │       │
│  │  CloudTrail ──► Athena (partition by acct/region/date)             │       │
│  │  VPC Flow   ──► Athena (PARTITION PROJECTION for fast queries)     │       │
│  │  CW Logs    ──► OpenSearch (real-time search & dashboards)         │       │
│  └─────────────────────────────────────────────────────────────────────┘       │
└────────────────────────────────────────────────────────────────────────────────┘
```

### Cross-Account Log Delivery Flow

```
  Member Account A                    Log Archive Account
  ┌──────────────┐                   ┌──────────────────────┐
  │ CloudTrail   │───── Org Trail ──►│ s3://org-trail-logs  │
  │              │   (auto-delivery  │ Bucket Policy allows │
  │ Config       │    via Org trail) │ cloudtrail.amazonaws │
  │              │───────────────────►│ .com PutObject       │
  └──────────────┘                   └──────────────────────┘

  Member Account B                    Log Archive Account
  ┌──────────────┐                   ┌──────────────────────┐
  │ CW Log Group │                   │                      │
  │ /app/logs    │──── Subscription ─►│ Kinesis Firehose    │
  │              │     Filter        │ (destination acct)   │
  │              │  (requires IAM    │       │              │
  │              │   role in dest)   │       ▼              │
  └──────────────┘                   │ s3://cw-centralized  │
                                     └──────────────────────┘

  CROSS-ACCOUNT IAM REQUIREMENTS:
  ┌────────────────────────────────────────────────────────────────┐
  │  Source account: IAM role trusting logs.amazonaws.com          │
  │  Dest account:  Resource policy on Kinesis Firehose allowing  │
  │                 cross-account PutRecord                        │
  │  OR: CW Logs destination with resource policy (for CW → CW)  │
  └────────────────────────────────────────────────────────────────┘
```

---

## 4. Security Tooling Account Architecture

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                  SECURITY TOOLING ACCOUNT (333333333333)                      │
│                  (Delegated admin for security services)                      │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐  │
│  │                     DETECTION & MONITORING                              │  │
│  │                                                                        │  │
│  │  ┌─────────────────┐  ┌───────────────────┐  ┌─────────────────────┐  │  │
│  │  │   GuardDuty     │  │   Security Hub    │  │   AWS Config        │  │  │
│  │  │   ADMIN         │  │   ADMIN           │  │   AGGREGATOR        │  │  │
│  │  │                 │  │                   │  │                     │  │  │
│  │  │  Delegated admin│  │  Delegated admin  │  │  Multi-account,     │  │  │
│  │  │  for entire org │  │  for entire org   │  │  multi-region       │  │  │
│  │  │                 │  │                   │  │  aggregation        │  │  │
│  │  │  Receives ALL   │  │  CIS Benchmark   │  │                     │  │  │
│  │  │  findings from  │  │  AWS Best Prac.  │  │  Config Rules +     │  │  │
│  │  │  all member     │  │  PCI DSS         │  │  Conformance Packs  │  │  │
│  │  │  accounts       │  │                   │  │  (deployed via Org) │  │  │
│  │  │                 │  │  Aggregates:      │  │                     │  │  │
│  │  │  S3 Protection  │  │  • GuardDuty      │  │  Evaluates config   │  │  │
│  │  │  EKS Protection │  │  • Config         │  │  of ALL resources   │  │  │
│  │  │  Malware Scan   │  │  • Inspector      │  │  across all accts   │  │  │
│  │  │                 │  │  • Macie          │  │                     │  │  │
│  │  └────────┬────────┘  └────────┬──────────┘  └──────────┬──────────┘  │  │
│  │           │                    │                         │              │  │
│  └───────────┼────────────────────┼─────────────────────────┼──────────────┘  │
│              │                    │                         │                  │
│              ▼                    ▼                         ▼                  │
│  ┌────────────────────────────────────────────────────────────────────────┐  │
│  │                   RESPONSE & AUTOMATION                                │  │
│  │                                                                        │  │
│  │  ┌─────────────────────────────────────────────────────────────────┐   │  │
│  │  │                     EventBridge                                  │   │  │
│  │  │                                                                  │   │  │
│  │  │   GuardDuty Finding ─┐                                          │   │  │
│  │  │   Config NonCompl.  ─┤──► EventBridge Rules ──► Targets:        │   │  │
│  │  │   SecHub Finding    ─┘                                          │   │  │
│  │  │                                                                  │   │  │
│  │  │   ┌──────────┐  ┌──────────────┐  ┌────────────────┐           │   │  │
│  │  │   │   SNS    │  │  Lambda      │  │  Step Functions │           │   │  │
│  │  │   │  Topics  │  │  Auto-       │  │  Remediation   │           │   │  │
│  │  │   │          │  │  Remediation │  │  Workflows     │           │   │  │
│  │  │   │ • Email  │  │              │  │                │           │   │  │
│  │  │   │ • Slack  │  │ • Isolate EC2│  │ • Quarantine   │           │   │  │
│  │  │   │ • Pager  │  │ • Block IP   │  │ • Investigate  │           │   │  │
│  │  │   │   Duty   │  │ • Revoke IAM │  │ • Notify       │           │   │  │
│  │  │   │          │  │ • Tag        │  │ • Restore      │           │   │  │
│  │  │   └──────────┘  └──────────────┘  └────────────────┘           │   │  │
│  │  └─────────────────────────────────────────────────────────────────┘   │  │
│  └────────────────────────────────────────────────────────────────────────┘  │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐  │
│  │                     ORG-LEVEL CLOUDTRAIL                               │  │
│  │                                                                        │  │
│  │  Organization Trail (created in mgmt account, delegated here)          │  │
│  │  • Management events: ALL accounts, ALL regions                       │  │
│  │  • Data events: S3/Lambda (selectively enabled)                       │  │
│  │  • Insights: Unusual API activity detection                           │  │
│  │  • Delivery: S3 (log archive) + CloudWatch Logs (real-time)          │  │
│  │  • Integrity validation: Digest files enabled                         │  │
│  └────────────────────────────────────────────────────────────────────────┘  │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐  │
│  │               ADDITIONAL SECURITY SERVICES                             │  │
│  │                                                                        │  │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────────────────┐  │  │
│  │  │  Macie   │  │Inspector │  │Detective │  │  IAM Access         │  │  │
│  │  │  Admin   │  │  Admin   │  │  Admin   │  │  Analyzer (Org)     │  │  │
│  │  │          │  │          │  │          │  │                      │  │  │
│  │  │  PII in  │  │  Vuln    │  │  Graph   │  │  External access    │  │  │
│  │  │  S3      │  │  scans   │  │  analysis│  │  findings across    │  │  │
│  │  │          │  │  ECR/EC2 │  │          │  │  all member accts   │  │  │
│  │  └──────────┘  └──────────┘  └──────────┘  └──────────────────────┘  │  │
│  └────────────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────────────┘

  DATA FLOW FROM MEMBER ACCOUNTS:
  ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
  │ Member      │     │ Member      │     │ Member      │
  │ Account A   │     │ Account B   │     │ Account C   │
  │             │     │             │     │             │
  │ • GuardDuty │     │ • GuardDuty │     │ • GuardDuty │
  │   (member)  │     │   (member)  │     │   (member)  │
  │ • Config    │     │ • Config    │     │ • Config    │
  │   (recorder)│     │   (recorder)│     │   (recorder)│
  │ • SecHub    │     │ • SecHub    │     │ • SecHub    │
  │   (member)  │     │   (member)  │     │   (member)  │
  └──────┬──────┘     └──────┬──────┘     └──────┬──────┘
         │                   │                    │
         └───────────────────┼────────────────────┘
                             │
                   Findings forwarded
                   automatically to
                   delegated admin
                             │
                             ▼
                  ┌─────────────────────┐
                  │ Security Tooling    │
                  │ Account (admin)     │
                  │                     │
                  │ Single pane of glass│
                  │ for ALL findings    │
                  └─────────────────────┘
```

---

## 5. Shared Services Account Architecture

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                  SHARED SERVICES ACCOUNT (555555555555)                       │
│                                                                              │
│  ┌───────────────────────────────────────────────────────────────────────┐   │
│  │                     DIRECTORY SERVICES                                │   │
│  │                                                                       │   │
│  │  ┌──────────────────────────────────┐                                │   │
│  │  │  AWS Managed Microsoft AD        │                                │   │
│  │  │  (Enterprise Edition)            │                                │   │
│  │  │                                  │                                │   │
│  │  │  corp.example.com                │                                │   │
│  │  │  DC: 10.0.1.10, 10.0.1.11       │                                │   │
│  │  │  (Multi-AZ)                      │                                │   │
│  │  │                                  │                                │   │
│  │  │  ┌────────────────────────────┐  │                                │   │
│  │  │  │ Shared to member accounts  │  │                                │   │
│  │  │  │ via RAM or Directory       │  │                                │   │
│  │  │  │ Sharing                    │  │                                │   │
│  │  │  └────────────────────────────┘  │                                │   │
│  │  └─────────┬────────────────────────┘                                │   │
│  │            │                                                          │   │
│  │            │  AD Trust (two-way or one-way)                          │   │
│  │            ▼                                                          │   │
│  │  ┌──────────────────────────────────┐                                │   │
│  │  │  On-Premises AD (via VPN/DX)     │                                │   │
│  │  │  onprem.example.com              │                                │   │
│  │  └──────────────────────────────────┘                                │   │
│  └───────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  ┌───────────────────────────────────────────────────────────────────────┐   │
│  │                     DNS (ROUTE 53)                                    │   │
│  │                                                                       │   │
│  │  ┌──────────────────────────────────────────────────────────────┐     │   │
│  │  │  Route 53 Resolver                                           │     │   │
│  │  │                                                              │     │   │
│  │  │  Inbound Endpoint ◄── On-prem DNS forwards to AWS           │     │   │
│  │  │  (10.0.2.10, 10.0.2.11)                                     │     │   │
│  │  │                                                              │     │   │
│  │  │  Outbound Endpoint ──► Forwards to on-prem DNS              │     │   │
│  │  │  (10.0.3.10, 10.0.3.11)                                     │     │   │
│  │  │                                                              │     │   │
│  │  │  Resolver Rules (shared via RAM to all VPCs):                │     │   │
│  │  │  • *.onprem.example.com → forward to on-prem DNS            │     │   │
│  │  │  • *.corp.example.com  → forward to Managed AD DCs          │     │   │
│  │  └──────────────────────────────────────────────────────────────┘     │   │
│  │                                                                       │   │
│  │  ┌──────────────────────────────────────────────────────────────┐     │   │
│  │  │  Private Hosted Zones (shared via RAM)                       │     │   │
│  │  │  • shared.internal  (shared services endpoints)              │     │   │
│  │  │  • db.internal      (database endpoints)                     │     │   │
│  │  └──────────────────────────────────────────────────────────────┘     │   │
│  └───────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  ┌───────────────────────────────────────────────────────────────────────┐   │
│  │                     ARTIFACT REPOSITORIES                             │   │
│  │                                                                       │   │
│  │  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐   │   │
│  │  │  ECR             │  │  CodeArtifact    │  │  S3 Artifact     │   │   │
│  │  │  (Shared Docker  │  │  (Maven, npm,    │  │  Buckets         │   │   │
│  │  │   images)        │  │   pip packages)  │  │  (CloudFormation │   │   │
│  │  │                  │  │                  │  │   templates,     │   │   │
│  │  │  Cross-account   │  │  Cross-account   │  │   Lambda zips)   │   │   │
│  │  │  pull via ECR    │  │  via domain/repo │  │                  │   │   │
│  │  │  resource policy │  │  permissions     │  │  Bucket policy   │   │   │
│  │  │                  │  │                  │  │  with OrgID cond.│   │   │
│  │  └──────────────────┘  └──────────────────┘  └──────────────────┘   │   │
│  └───────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  ┌───────────────────────────────────────────────────────────────────────┐   │
│  │                     CI/CD TOOLING                                      │   │
│  │                                                                       │   │
│  │  ┌──────────────────────────────────────────────────────────────┐     │   │
│  │  │  CodePipeline → CodeBuild → Deploy (cross-account roles)    │     │   │
│  │  │                                                              │     │   │
│  │  │  Pipeline Role ──assumes──► Target Account Deploy Role       │     │   │
│  │  │  (in shared svcs)           (in workload account)            │     │   │
│  │  │                                                              │     │   │
│  │  │  KMS key shared cross-account for artifact encryption        │     │   │
│  │  └──────────────────────────────────────────────────────────────┘     │   │
│  └───────────────────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────────────────┘

  CROSS-ACCOUNT ACCESS PATTERN:
  ┌──────────────────────────────────────────────────────────┐
  │                                                          │
  │   Shared Services Account          Workload Account      │
  │   ┌───────────────────┐           ┌───────────────────┐  │
  │   │ ECR Repository    │  pull     │ ECS Task Role     │  │
  │   │ (resource policy  │◄──────────│ (arn:aws:iam::    │  │
  │   │  allows org)      │           │  555:role/ecr-pull)│  │
  │   └───────────────────┘           └───────────────────┘  │
  │                                                          │
  │   ┌───────────────────┐           ┌───────────────────┐  │
  │   │ R53 Resolver Rule │  shared   │ VPC auto-         │  │
  │   │ (via RAM)         │──────────►│ associates rule   │  │
  │   └───────────────────┘   RAM     └───────────────────┘  │
  │                                                          │
  └──────────────────────────────────────────────────────────┘
```

### Exam Relevance

| Topic | Key Points |
|-------|-----------|
| **Cross-account sharing** | RAM for R53 rules, subnets, TGW; Resource policies for S3, ECR, KMS |
| **Delegated admin** | GuardDuty, Security Hub, Config, Macie, CloudFormation StackSets |
| **DNS resolution** | R53 Resolver inbound/outbound endpoints; forwarding rules shared via RAM |
| **AD integration** | AWS Managed AD shared to member accounts; trust with on-prem AD |
| **SCPs vs IAM** | SCPs = guardrails (deny only); IAM = permissions in individual accounts |
