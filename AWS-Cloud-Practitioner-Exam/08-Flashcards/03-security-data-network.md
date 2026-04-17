# Flashcards — Domain 2 (Data, Network, Detective, Compliance)

Q: What is AWS KMS?
A: Managed, regional service for cryptographic keys; multi-tenant HSM-backed. #must-know

Q: Default symmetric algorithm in KMS?
A: AES-256. #must-know

Q: KMS FIPS 140-2 level in commercial Regions?
A: Level 3. #must-know

Q: Difference between AWS-managed and customer-managed KMS key?
A: AWS-managed: AWS creates per-service per-account; customer-managed: you create/manage/control key policy. #must-know

Q: Is KMS key rotation automatic for symmetric CMKs?
A: Yes (annual) if enabled; manual for asymmetric and imported keys. #must-know

Q: What is envelope encryption?
A: A data key encrypts data; KMS encrypts the data key. Data key is short-lived in memory; reduces KMS calls. #must-know

Q: KMS vs CloudHSM?
A: KMS is multi-tenant managed HSM; CloudHSM is single-tenant HSM you control. #must-know

Q: When to use CloudHSM?
A: Need exclusive key control, PKCS#11/JCE/CNG, compliance preventing multi-tenant KMS. #must-know

Q: Secrets Manager vs SSM Parameter Store?
A: Secrets Manager — built-in rotation, cross-account, higher cost; Parameter Store — cheaper/free, hierarchical, no built-in rotation. #must-know

Q: Which service supplies free TLS certs for AWS services?
A: ACM (AWS Certificate Manager). #must-know

Q: Can ACM certs be used directly on an EC2?
A: No — TLS must terminate on a supported service (ALB, CloudFront, APIGW, App Runner, etc.). #must-know

Q: ACM Private CA price?
A: ~$400/month per CA, plus per-cert issuance fees. #must-know

Q: Can ACM auto-renew certs?
A: Yes for public, DNS-validated certs. #must-know

Q: Default encryption on new S3 buckets (since Jan 2023)?
A: SSE-S3 (AES-256) is enabled by default. #must-know

Q: S3 SSE-KMS vs SSE-S3?
A: SSE-KMS uses KMS CMKs (audit + control); SSE-S3 uses AWS-owned keys. #must-know

Q: What is SSE-C?
A: Customer-Provided encryption keys; AWS encrypts/decrypts using your key, doesn't store it. #must-know

Q: What enforces HTTPS on S3?
A: Bucket policy condition aws:SecureTransport = true. #must-know

Q: What does S3 Object Lock do?
A: WORM retention for regulatory compliance; Governance vs Compliance mode. #must-know

Q: Are EBS volumes encrypted by default?
A: Only if you've enabled EBS encryption at the account level (recommended). #must-know

Q: Is DynamoDB encrypted at rest by default?
A: Yes (AWS-owned key by default; switch to AWS-managed or CMK). #must-know

Q: Security Group — stateful or stateless?
A: Stateful. #must-know

Q: NACL — stateful or stateless?
A: Stateless. #must-know

Q: SG rule types?
A: Allow only (no Deny). #must-know

Q: NACL rule types?
A: Allow and Deny, evaluated in numeric order. #must-know

Q: At what level does SG apply?
A: ENI level (attached to EC2, RDS, Lambda ENIs, etc.). #must-know

Q: At what level does NACL apply?
A: Subnet level. #must-know

Q: Can SG rules reference other SGs?
A: Yes (e.g., "allow from the web-tier SG"). #must-know

Q: What layer does WAF protect?
A: L7 (HTTP/HTTPS). #must-know

Q: Services that can have WAF attached?
A: CloudFront, ALB, API Gateway, AppSync, App Runner, Verified Access, Cognito User Pools. #must-know

Q: Shield Standard — cost?
A: Free, always on. #must-know

Q: Shield Advanced — monthly fee?
A: $3,000/month per organization + data fees. #must-know

Q: Shield Advanced key benefits?
A: 24/7 SRT, cost protection during attacks, advanced attack diagnostics, WAF included at no extra cost. #must-know

Q: What is AWS Firewall Manager?
A: Central policy manager for WAF/Shield Advanced/SGs/Network Firewall/Route 53 Resolver DNS Firewall across Organizations. #must-know

Q: What is AWS Network Firewall?
A: Managed stateful firewall in VPCs with Suricata rule support. #must-know

Q: What is Route 53 Resolver DNS Firewall?
A: Block DNS queries to malicious domains from your VPC. #must-know

Q: What is Verified Access?
A: Zero-trust VPN-less app access with identity + device posture. #must-know

Q: Records API calls?
A: AWS CloudTrail. #must-know

Q: Records resource configuration over time?
A: AWS Config. #must-know

Q: Do management events get logged by CloudTrail by default?
A: Yes — 90 days free in Event History. #must-know

Q: Are S3 data events logged by default in CloudTrail?
A: No — opt-in, chargeable. #must-know

Q: Where does a CloudTrail trail deliver logs?
A: S3 (optionally CloudWatch Logs, EventBridge). #must-know

Q: CloudTrail Lake?
A: SQL-queryable managed data lake for trail events. #must-know

Q: What detects unusual API activity patterns automatically?
A: CloudTrail Insights (and GuardDuty for security-specific). #must-know

Q: GuardDuty data sources?
A: CloudTrail, VPC Flow Logs, DNS logs, S3 data events, EKS audit, RDS login, Lambda network activity, EBS malware scan. #must-know

Q: Inspector scans what?
A: EC2, ECR container images, Lambda functions for CVEs. #must-know

Q: Macie does what?
A: Discovers sensitive data (PII, PHI) in S3. #must-know

Q: Security Hub does what?
A: Unifies findings from multiple sources + runs standards (AWS FSBP, CIS, PCI). #must-know

Q: Detective does what?
A: Builds investigation graphs for security incidents. #must-know

Q: Artifact provides?
A: AWS's compliance reports (SOC, ISO, PCI, HIPAA BAA, FedRAMP package). #must-know

Q: Audit Manager does what?
A: Continuously collects evidence for audits. #must-know

Q: Trusted Advisor categories (full in Business+)?
A: Cost, Performance, Security, Fault Tolerance, Service Limits (+ Operational Excellence). #must-know

Q: Where do you report compromise or abusive traffic?
A: AWS Abuse — abuse@amazonaws.com / form. #must-know

Q: Organizations SCPs act on whom?
A: IAM principals in member accounts — not on the management account (except payer-account use-cases). #must-know

Q: What does Control Tower provide?
A: Opinionated multi-account landing zone built on Organizations, Identity Center, Config, CloudTrail, Security Hub; guardrails; Account Factory. #must-know

Q: What's a guardrail in Control Tower?
A: Preventive (SCP) or detective (Config rule) controls. #must-know

Q: Service Catalog purpose?
A: Publish approved IaC products (CFN/TF) for users to self-serve. #must-know

Q: RAM purpose?
A: Share AWS resources (TGW, subnets, R53 Resolver rules, Licenses, etc.) across accounts. #must-know

Q: HIPAA-covered workloads — key services?
A: AWS signs a BAA; use only BAA-covered services (S3, EC2, RDS, Lambda, DynamoDB, etc., most core services). #must-know

Q: FedRAMP High relevant Regions?
A: us-gov-east-1, us-gov-west-1 + some commercial us-east-1/2, us-west-2. #must-know

Q: GDPR applicability on AWS?
A: AWS offers DPA (Data Processing Addendum); customer is data controller. #must-know

Q: What is the typical CloudTrail retention in Event History (free)?
A: 90 days. #must-know

Q: What's included in AWS Backup Vault Lock?
A: WORM protection for backups. #must-know

Q: How to enforce multi-AZ on RDS at the org level?
A: AWS Config managed rule / SCP / Control Tower guardrail. #must-know

Q: CloudWatch Logs retention default?
A: Never expires by default — set a retention to avoid unbounded cost. #must-know

Q: What's the difference between SSE-KMS (AWS-managed) and SSE-KMS (CMK)?
A: AWS-managed key (aws/s3) auto-managed by AWS; CMK is customer-created in KMS with your key policy. #must-know
