# Security, Identity & Compliance — Deep Dive

See Domain 2 article for foundations. This file is a quick per-service
card for exam review.

## Identity

- **IAM** — Users, Groups, Roles, Policies. Global. Free.
- **IAM Identity Center** — Workforce SSO across Org accounts and SaaS.
- **Cognito User Pools** — End-user auth (JWT).
- **Cognito Identity Pools** — Exchange any identity for AWS creds.
- **STS** — Vends temporary credentials.
- **IAM Roles Anywhere** — On-prem workloads assume IAM roles using X.509.
- **Directory Service** — Managed AD, AD Connector, Simple AD.

## Encryption / Keys / Secrets

- **KMS** — Regional managed key service (symmetric + asymmetric).
- **CloudHSM** — Single-tenant HSM cluster.
- **ACM** — Free TLS certs for AWS services; ACM PCA for private CA.
- **Secrets Manager** — Secrets with rotation; RDS-native rotation.
- **SSM Parameter Store** — Config + SecureString; free tier; no rotation.
- **AWS Payment Cryptography** — Card/HSM operations for payments industry.

## Network Security

- **Security Groups** — stateful; ENI-level; allow-only.
- **NACLs** — stateless; subnet-level; allow/deny in order.
- **WAF** — L7 on CloudFront/ALB/APIGW/AppSync/App Runner/Verified
  Access/Cognito.
- **Shield Standard** — Free, always-on basic DDoS.
- **Shield Advanced** — $3K/mo/org; SRT; cost protection; advanced attack
  visibility; free WAF.
- **Firewall Manager** — Org-wide policy mgmt for WAF, Shield Adv, SGs,
  Network Firewall, Route 53 Resolver DNS Firewall.
- **Network Firewall** — Managed stateful L3/L4/L7 firewall w/ Suricata
  rules.
- **Route 53 Resolver DNS Firewall** — Block DNS queries to bad domains.
- **AWS Verified Access** — Zero-trust VPN-less remote app access.

## Detective Controls

- **CloudTrail** — API activity logs.
- **Config** — Resource inventory + rules.
- **GuardDuty** — ML threat detection (CloudTrail, VPC Flow, DNS, S3
  data, EKS, RDS login, Lambda, EBS malware).
- **Inspector** — CVE scans for EC2, ECR images, Lambda functions.
- **Macie** — PII/PHI discovery in S3.
- **Security Hub** — Unified findings + standards (AWS FSBP, CIS, PCI).
- **Detective** — Investigation graph.
- **Trusted Advisor** — Best-practice checks (incl. Security).

## Compliance & Governance

- **AWS Artifact** — AWS compliance reports portal.
- **AWS Audit Manager** — Automated evidence collection.
- **AWS Organizations** — Multi-account + SCPs + consolidated billing.
- **AWS Control Tower** — Opinionated landing zone.
- **AWS Service Catalog** — Curated IaC catalog.
- **AWS License Manager** — License tracking.
- **AWS Resource Access Manager (RAM)** — Resource sharing.
- **AWS Resource Explorer** — Cross-Region resource search.
- **AWS Config Conformance Packs** — Compliance as code.

## Incident Response

- **AWS Health / PHD** — Account-level event notifications.
- **AWS Systems Manager Incident Manager** — Incident response automation.
- **AWS Elastic Disaster Recovery (DRS)** — DR replication.
- **AWS Backup** — Centralized backup.
- **AWS Resilience Hub** — Resilience assessments.
