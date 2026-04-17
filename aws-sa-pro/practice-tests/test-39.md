# AWS SAP-C02 Practice Test 39 — Advanced Security

> **Theme:** Zero trust, defense in depth, incident response, forensics, data classification, DDoS protection  
> **Questions:** 75 | **Time Limit:** 180 minutes  
> **Domain Distribution:** D1 ≈ 20 | D2 ≈ 22 | D3 ≈ 11 | D4 ≈ 9 | D5 ≈ 13

---

### Question 1
A financial services company is implementing a zero-trust security model on AWS. They want to ensure that every API request to their internal microservices is authenticated and authorized regardless of the network it originates from. Services run on ECS Fargate across multiple VPCs. What architecture best implements zero trust for service-to-service communication?

A) Use VPC security groups and NACLs to restrict traffic between services.  
B) Use AWS VPC Lattice with IAM-based auth policies. Each service authenticates using SigV4 signing with its IAM role. Auth policies define which IAM principals (service roles) can access which services and which specific operations. All traffic is encrypted. This provides identity-based, not network-based, access control — a core zero-trust principle.  
C) Deploy a VPN between all services for encrypted communication.  
D) Use mutual TLS certificates managed by the application team.

**Correct Answer: B**
**Explanation:** Zero trust requires identity-based access control where every request is authenticated and authorized regardless of network position. VPC Lattice with SigV4 authentication enforces this — every request must carry a valid IAM signature. Auth policies provide fine-grained authorization (which service can call which endpoints). This is network-agnostic. Option A is network-based security (not zero trust). Option C encrypts but doesn't authenticate individual requests. Option D requires manual certificate management.

---

### Question 2
A company discovers that an EC2 instance in their production VPC is communicating with a known command-and-control (C2) server. The security team needs to perform forensic analysis on the compromised instance while containing the threat. What should the incident response procedure be?

A) Immediately terminate the EC2 instance to stop the communication.  
B) Execute a structured incident response: (1) Isolate — change the instance's security group to a forensic isolation group that blocks all inbound/outbound except to the forensic team's jump box. (2) Preserve evidence — create an EBS snapshot of all volumes before any changes. Create a memory dump using SSM Run Command if the instance supports it. (3) Capture metadata — instance metadata, VPC Flow Logs, CloudTrail events, security group history. (4) Launch a forensic analysis instance in an isolated forensic VPC, attach copies of the EBS snapshots (not originals), and analyze. (5) Record all actions with timestamps for chain of custody.  
C) Detach the instance from the network and reboot it.  
D) Run antivirus on the instance and continue operating.

**Correct Answer: B**
**Explanation:** Proper incident response preserves evidence while containing the threat. The isolation security group stops C2 communication without destroying evidence (unlike termination). EBS snapshots capture disk state. Memory dumps capture running processes and network connections. Working on copies preserves the original evidence. Chain of custody documentation is critical for legal proceedings. Option A destroys evidence. Option C loses volatile memory evidence. Option D doesn't contain the threat or preserve evidence.

---

### Question 3
A company operating in the EU needs to implement data classification for their AWS environment. They store customer data (PII), financial records, intellectual property, and public marketing content across S3 buckets, RDS databases, and DynamoDB tables. They need automatic discovery and classification of sensitive data. What should the architect implement?

A) Manually tag all resources with classification labels.  
B) Deploy Amazon Macie to automatically discover and classify sensitive data in S3. Macie uses ML and pattern matching to identify PII, financial data, and credentials. For non-S3 data stores (RDS, DynamoDB), export data to S3 periodically and scan with Macie, or use AWS Glue with custom classifiers for in-place classification. Create a data classification taxonomy (Public, Internal, Confidential, Restricted) and map Macie findings to these levels. Use resource tags and AWS Config rules to enforce classification-based controls.  
C) Use AWS Inspector to scan for sensitive data.  
D) Rely on S3 bucket names to indicate data sensitivity.

**Correct Answer: B**
**Explanation:** Macie automates sensitive data discovery in S3 using ML — it identifies PII (names, SSNs, credit cards), financial data, and credentials. The classification taxonomy maps discovery results to organizational sensitivity levels. AWS Config rules enforce that classified data has appropriate protections (encryption, access controls). For non-S3 stores, periodic exports or Glue classifiers extend coverage. Option A is manual and error-prone. Option C — Inspector scans for vulnerabilities, not data classification. Option D is an unreliable naming convention.

---

### Question 4
A company needs to implement defense in depth for their web application. The application runs on ECS behind an ALB and uses RDS Aurora. They need multiple layers of security from the edge to the database. What comprehensive security architecture should the architect design?

A) Use WAF on the ALB and security groups on the instances.  
B) Implement layered security: (1) Edge — AWS Shield Advanced for DDoS protection, CloudFront with geographic restrictions. (2) Application edge — AWS WAF on the ALB with managed rule groups (OWASP Top 10, SQL injection, XSS, bot control, rate limiting). (3) Network — VPC with private subnets for ECS and RDS, NACLs for subnet-level filtering, security groups for instance-level access control, VPC endpoints for AWS service access. (4) Application — IAM roles for ECS task authentication, Secrets Manager for database credentials with automatic rotation. (5) Data — Aurora encryption at rest (KMS), TLS for connections, RDS IAM authentication. (6) Monitoring — GuardDuty for threat detection, CloudTrail for API audit, VPC Flow Logs, Config for compliance.  
C) Deploy a WAF appliance on EC2 for all security.  
D) Use security groups only since they are stateful.

**Correct Answer: B**
**Explanation:** Defense in depth requires multiple, independent security layers so that compromise of one layer doesn't expose the entire system. Each layer addresses different threat vectors: Shield/CloudFront handle DDoS, WAF handles application attacks, NACLs/SGs handle network access, IAM/Secrets Manager handle authentication, encryption handles data protection, and monitoring handles detection. Option A covers only two layers. Option C centralizes security in a single point of failure. Option D is a single layer.

---

### Question 5
A company's security team discovers that IAM credentials for a service account have been committed to a public GitHub repository. The credentials have been active for 3 hours. What should the incident response procedure be? (Select THREE.)

A) Immediately deactivate the compromised IAM access keys and generate new ones.  
B) Review CloudTrail logs for the last 3 hours to identify all API calls made with the compromised credentials — look for unauthorized resource creation, data access, or privilege escalation.  
C) Delete the IAM user entirely.  
D) Rotate all secrets and credentials that the compromised IAM user had access to (database passwords, API keys stored in Secrets Manager, etc.), as they may have been exfiltrated.  
E) Ignore the issue since the credentials were for a service account with limited permissions.

**Correct Answer: A, B, D**
**Explanation:** (A) Immediately revoking the compromised keys stops ongoing unauthorized access. New keys restore legitimate service functionality. (B) CloudTrail analysis reveals the blast radius — what the attacker accessed/modified during the 3-hour window. Look for CreateUser, AttachPolicy, RunInstances, GetObject on sensitive S3 buckets. (D) Any secret the compromised user could access must be considered compromised — the attacker may have read database passwords, API keys, etc. Option C is premature and disrupts legitimate services. Option E is dangerous — even limited permissions can be exploited.

---

### Question 6
A company needs to protect their application against DDoS attacks. They have a web application behind CloudFront and ALB, and they also have TCP-based services (gaming servers) running on NLBs. They need automatic DDoS detection, mitigation, and access to the AWS DDoS Response Team. What should the architect configure?

A) Use AWS WAF with rate limiting rules only.  
B) Subscribe to AWS Shield Advanced for all exposed resources (CloudFront distributions, ALBs, NLBs, Elastic IPs). Shield Advanced provides: automatic DDoS detection and mitigation at layers 3/4/7, advanced metrics in CloudWatch, AWS DDoS Response Team (SRT) access 24/7, cost protection (credits for DDoS-related scaling costs), and automatic WAF rule deployment by the SRT during attacks. Create a proactive engagement with the SRT so they contact you during detected events.  
C) Over-provision infrastructure to absorb DDoS traffic.  
D) Use CloudFront geographic restrictions to block all foreign traffic.

**Correct Answer: B**
**Explanation:** Shield Advanced provides comprehensive DDoS protection across all layers. It protects both HTTP (CloudFront/ALB) and TCP (NLB/EIP) resources. The SRT team provides expert assistance during attacks. Cost protection prevents surprise bills from DDoS-induced auto-scaling. Proactive engagement means AWS contacts you (not the other way around) during events. Option A only provides rate limiting, not DDoS-specific detection. Option C is expensive and insufficient for volumetric attacks. Option D blocks legitimate international users.

---

### Question 7
A company's compliance team requires that all API calls across their AWS Organization (50 accounts) are logged, immutable (tamper-proof), and stored for 7 years. The logs must be centralized for security analysis. What should the architect configure?

A) Enable CloudTrail in each account individually and configure each to send logs to its own S3 bucket.  
B) Create an Organization trail in the management account that logs all API activity across all 50 member accounts. Configure the trail to deliver logs to a centralized S3 bucket in a dedicated security/audit account. Enable S3 Object Lock (Compliance mode, 7-year retention) on the bucket for immutability. Enable CloudTrail log file integrity validation. Enable CloudTrail Insights for anomaly detection. Deny all S3 delete operations on the bucket using a bucket policy.  
C) Use AWS Config to log all API calls.  
D) Enable VPC Flow Logs across all accounts and centralize them.

**Correct Answer: B**
**Explanation:** Organization trails centralize all API logging across all accounts automatically — new accounts are included by default. S3 Object Lock in Compliance mode ensures logs cannot be deleted or modified for 7 years (even by the root user). Log file integrity validation detects tampering using hash chains. CloudTrail Insights detects unusual API activity patterns. The dedicated security account isolates audit logs from operational accounts. Option A requires per-account management. Option C tracks configuration changes, not API calls. Option D captures network traffic, not API calls.

---

### Question 8
A company wants to implement just-in-time (JIT) access for their AWS environment. Administrators should not have permanent elevated privileges. When they need to perform administrative tasks, they should request temporary access that is approved, time-limited, and fully audited. What architecture should the architect design?

A) Create shared IAM admin credentials that all administrators use.  
B) Implement a JIT access workflow: (1) Administrators have baseline read-only IAM roles. (2) To request elevated access, they submit a request via a custom portal (API Gateway → Lambda → DynamoDB for tracking). (3) Approvers receive an SNS notification and approve/deny via the portal. (4) On approval, the Lambda function calls AWS IAM Identity Center (SSO) to create a time-limited permission set assignment (e.g., 4 hours). (5) After expiration, the assignment is automatically removed. (6) All access events are logged in CloudTrail and DynamoDB for audit. Alternative: Use AWS IAM Identity Center's built-in temporary elevated access with ABAC.  
C) Give all administrators permanent PowerUser access with MFA required.  
D) Use IAM policy conditions with time-based restrictions.

**Correct Answer: B**
**Explanation:** JIT access eliminates standing privileges (a zero-trust principle). Administrators get elevated access only when needed, for a limited time, with approval and audit. IAM Identity Center permission set assignments are time-limited — they automatically expire. The approval workflow prevents unauthorized privilege escalation. Complete audit trail in CloudTrail and DynamoDB provides accountability. Option A is the worst practice. Option C provides permanent elevated access. Option D can restrict time but doesn't implement the request/approval workflow.

---

### Question 9
A company detects that an IAM role assumed by an EC2 instance is being used to make API calls from an IP address outside their VPC. The role should only be used by the instance. What is the most likely attack vector and how should the architect prevent this?

A) Someone has stolen the instance's SSH key and is using it remotely.  
B) The instance's IAM role temporary credentials have been exfiltrated (likely via SSRF or IMDSv1 exploitation). The attacker retrieved credentials from the instance metadata service and is using them externally. Prevention: (1) Require IMDSv2 (token-based) on all EC2 instances — this prevents SSRF-based credential theft. (2) Add an IAM policy condition (aws:VpcSourceIp or aws:SourceVpc) to the role to restrict API calls to the VPC. (3) Use VPC endpoints to keep API calls within the VPC. (4) Enable GuardDuty, which detects credential usage from unusual IPs.  
C) The IAM role's trust policy is too permissive.  
D) DNS spoofing is redirecting API calls.

**Correct Answer: B**
**Explanation:** Instance metadata credential theft is a well-known attack vector. IMDSv1 allows simple HTTP GET to http://169.254.169.254/latest/meta-data/iam/security-credentials/ — SSRF vulnerabilities in applications on the instance can be exploited to retrieve these credentials. IMDSv2 requires a PUT request with a token first, preventing SSRF exploitation. VPC-scoped IAM conditions prevent exfiltrated credentials from working outside the VPC. GuardDuty detects unusual usage patterns. Option A — SSH keys don't grant IAM API access. Option C doesn't explain the IP issue. Option D is unlikely for IAM calls.

---

### Question 10
A company needs to implement encryption for data at rest across their entire AWS environment — S3, EBS, RDS, DynamoDB, and EFS. They require customer-managed keys with automatic rotation, separation of duties (key administrators vs. key users), and audit trails. What should the architect design?

A) Use AWS-managed KMS keys (aws/s3, aws/ebs, etc.) for all services.  
B) Create customer-managed KMS keys with the following configuration: (1) Separate KMS keys per service type and per environment (e.g., prod-s3-key, prod-rds-key). (2) Key policies with separation of duties — key administrators (can manage but not use keys) and key users (can encrypt/decrypt but not manage). (3) Enable automatic key rotation (annual). (4) Enable KMS key usage logging in CloudTrail. (5) Use AWS Config rules to detect unencrypted resources. (6) Implement SCPs in the Organization to deny resource creation without encryption. (7) Use KMS grants for temporary, fine-grained access.  
C) Use a third-party HSM for all encryption key management.  
D) Implement application-level encryption for all data.

**Correct Answer: B**
**Explanation:** Customer-managed KMS keys provide full control over key lifecycle, access policies, and rotation. Separation of duties in key policies prevents any single person from both managing keys and using them — a critical security control. Automatic rotation maintains crypto hygiene. CloudTrail logging provides complete audit of every encryption/decryption operation. SCPs enforce encryption organization-wide. Config rules detect compliance gaps. Option A — AWS-managed keys don't allow custom key policies or separation of duties. Option C adds complexity without additional benefit for most use cases. Option D requires code changes in every application.

---

### Question 11
A company is implementing AWS Security Hub across their multi-account Organization. They want to aggregate security findings from GuardDuty, Inspector, Macie, IAM Access Analyzer, and Firewall Manager in a central dashboard. They need to prioritize findings and automate remediation for common issues. What should the architect configure?

A) Deploy individual security services in each account and review findings separately.  
B) Enable Security Hub in the delegated administrator account with organization-wide coverage. Enable all AWS security service integrations (GuardDuty, Inspector, Macie, IAM Access Analyzer, Firewall Manager). Enable security standards (CIS AWS Foundations, AWS Foundational Security Best Practices, PCI DSS). Create custom insights for business-specific risk views. Use EventBridge rules to route critical findings to SNS for alerting and Lambda for automated remediation (e.g., auto-revoke public S3 bucket access, disable compromised IAM keys). Use Security Hub's automation rules for finding suppression and severity adjustment.  
C) Use CloudWatch Alarms for all security monitoring.  
D) Deploy a third-party SIEM and bypass Security Hub.

**Correct Answer: B**
**Explanation:** Security Hub serves as the central security finding aggregator across the Organization. Delegated administrator enables centralized management without using the management account. Security standards provide automated compliance checks. Custom insights prioritize findings based on business context. EventBridge integration enables real-time alerting and automated remediation. Automation rules reduce noise from known-acceptable findings. Option A creates silos. Option C doesn't aggregate security findings. Option D ignores AWS-native integration benefits.

---

### Question 12
A company's security team needs to detect threats across their AWS environment including cryptocurrency mining on EC2, unauthorized API calls, data exfiltration from S3, and DNS-based attacks. The detection should work across all accounts with no agents to install. What should the architect enable?

A) Deploy IDS/IPS agents on all EC2 instances.  
B) Enable Amazon GuardDuty across the Organization with delegated administrator. GuardDuty analyzes: VPC Flow Logs (network anomalies, crypto mining, C2 communication), CloudTrail logs (suspicious API calls, credential compromise), DNS logs (DNS exfiltration, malicious domains), S3 data events (unauthorized access patterns), and EKS audit logs. Enable GuardDuty S3 protection, EKS protection, Lambda protection, and RDS protection. Configure EventBridge rules for high-severity findings to trigger automated response via Lambda.  
C) Use AWS Config to detect all threats.  
D) Analyze VPC Flow Logs manually for suspicious activity.

**Correct Answer: B**
**Explanation:** GuardDuty is an agentless threat detection service that analyzes multiple AWS data sources using ML and threat intelligence. It detects cryptocurrency mining (network patterns), unauthorized API calls (impossible travel, unusual services), S3 data exfiltration (unusual access patterns), and DNS-based attacks (query to malicious domains). Organization-wide deployment ensures complete coverage. Automated response via EventBridge prevents threat escalation. Option A requires agent management. Option C detects configuration compliance, not threats. Option D is manual and doesn't cover all data sources.

---

### Question 13
A company needs to ensure that only approved AMIs are used to launch EC2 instances in their Organization. Unapproved AMIs may contain vulnerabilities or malware. What preventive and detective controls should the architect implement?

A) Communicate the approved AMI list to all teams via email.  
B) Implement layered controls: (1) Preventive — Create an SCP that uses a condition key (ec2:ImageId) to restrict EC2 launches to a list of approved AMI IDs (maintained in a managed prefix list or explicit list). (2) Detective — AWS Config rule (approved-amis-by-id) that checks running instances against the approved AMI list and marks non-compliant instances. (3) Responsive — EventBridge rule triggered by Config compliance change that invokes Lambda to notify the security team and optionally stop non-compliant instances. (4) Proactive — Golden AMI pipeline (CodePipeline + Image Builder) that produces hardened, scanned AMIs and publishes them to a shared AMI catalog.  
C) Use AWS Inspector to scan instances after launch.  
D) Block all AMI sharing using resource-based policies.

**Correct Answer: B**
**Explanation:** The layered approach covers prevention (SCPs block unapproved AMIs), detection (Config rules find violations), response (automated notification/remediation), and proactive security (golden AMI pipeline ensures approved AMIs are secure). SCPs are the strongest preventive control — they cannot be bypassed by any IAM principal. Config provides continuous compliance monitoring. The golden AMI pipeline ensures approved AMIs are patched and hardened. Option A is not a technical control. Option C is reactive only. Option D prevents legitimate sharing.

---

### Question 14
A company handles credit card transactions and must comply with PCI DSS. They need to isolate their cardholder data environment (CDE) on AWS while maintaining connectivity to other business systems for non-sensitive operations. What network security architecture should the architect implement?

A) Place CDE workloads in the same VPC as other business systems but in dedicated subnets.  
B) Create a dedicated CDE VPC with strict isolation: (1) No Internet Gateway or NAT Gateway. (2) All AWS service access through VPC endpoints (Interface endpoints for KMS, S3, CloudWatch, etc.). (3) Connect to a shared services VPC only via Transit Gateway with a dedicated route table containing only necessary routes. (4) AWS Network Firewall inspects all traffic entering/leaving the CDE VPC with stateful rules. (5) All data encrypted with dedicated KMS keys (separate from non-CDE). (6) VPC Flow Logs with all-traffic capture sent to a separate security account. (7) Separate AWS account for CDE workloads. (8) SCPs restrict CDE account to only PCI-compliant services.  
C) Use security groups to isolate CDE workloads within a shared VPC.  
D) Deploy CDE workloads in an on-premises environment to avoid cloud compliance issues.

**Correct Answer: B**
**Explanation:** PCI DSS requires network segmentation between CDE and non-CDE environments. A separate VPC in a separate account provides the strongest isolation. No IGW/NAT ensures no internet path. VPC endpoints provide private AWS access. Network Firewall provides deep packet inspection. Dedicated KMS keys prevent cross-environment key sharing. Separate account limits the PCI scope. SCPs enforce only compliant services. Option A doesn't provide sufficient segmentation. Option C — security groups are insufficient for PCI network isolation. Option D — cloud can be PCI compliant.

---

### Question 15
A company's SOC (Security Operations Center) team needs to investigate a security incident. They need to query CloudTrail logs, VPC Flow Logs, and GuardDuty findings across all accounts for the past 90 days. Queries must return results in seconds, not minutes. What log analysis architecture should the architect implement?

A) Search through individual log files in S3 manually.  
B) Centralize all security logs in Amazon Security Lake (which normalizes logs to OCSF format). Configure Security Lake to collect CloudTrail, VPC Flow Logs, Route 53 DNS logs, and GuardDuty findings across all accounts. Query using Amazon Athena with pre-built security investigation queries. For interactive, sub-second queries, integrate with Amazon OpenSearch Service for real-time search and dashboards. Use Amazon Detective for automated investigation of GuardDuty findings with visual exploration.  
C) Use CloudWatch Logs Insights across all accounts.  
D) Export all logs to a third-party SIEM without centralization.

**Correct Answer: B**
**Explanation:** Amazon Security Lake centralizes and normalizes all security-relevant logs into the OCSF (Open Cybersecurity Schema Framework) standard format. This enables consistent querying across different log types. OpenSearch provides sub-second interactive search and visualization. Amazon Detective provides automated investigation with visual graphs showing relationships between entities (IPs, users, resources). Athena handles ad-hoc SQL queries. Option A is manual and slow. Option C has cross-account limitations. Option D adds external dependency without normalization.

---

### Question 16
A company needs to implement credential rotation for all database credentials, API keys, and certificates across their 200 microservices. Credentials must rotate automatically without application downtime. What should the architect implement?

A) Store credentials in environment variables and rotate manually during maintenance windows.  
B) Use AWS Secrets Manager for all secrets: (1) Database credentials — enable automatic rotation with Lambda rotation functions (Secrets Manager provides templates for RDS, Redshift, DocumentDB). Multi-user rotation strategy creates a new user before retiring the old one, preventing connectivity gaps. (2) API keys — custom Lambda rotation functions that call the third-party API to generate new keys. (3) Certificates — ACM for public certificates (auto-renewal) and ACM Private CA with Lambda rotation for private certificates. Applications retrieve secrets at runtime using the Secrets Manager SDK with local caching to reduce API calls.  
C) Store all credentials in AWS Systems Manager Parameter Store without rotation.  
D) Use a single master password for all services.

**Correct Answer: B**
**Explanation:** Secrets Manager provides native automatic rotation with zero-downtime strategies. Multi-user rotation (alternating-user strategy) creates a second set of credentials before deactivating the first, ensuring continuous availability. Custom Lambda functions extend rotation to any secret type. ACM handles certificate lifecycle. SDK caching reduces latency and API costs. Option A requires downtime and is manual. Option C — Parameter Store doesn't support automatic rotation. Option D is a critical security anti-pattern.

---

### Question 17
A company wants to detect and prevent data exfiltration through their AWS environment. Sensitive data is stored in S3, and they need to detect unusual access patterns, large data downloads, and access from unexpected locations. What should the architect implement?

A) Enable S3 access logging and review logs weekly.  
B) Deploy a multi-layered data loss prevention (DLP) architecture: (1) Amazon Macie for continuous S3 sensitive data discovery and access anomaly detection. (2) GuardDuty S3 protection to detect unauthorized access patterns (unusual user behavior, access from Tor exit nodes). (3) CloudTrail data events for S3 (GetObject, PutObject) sent to Security Hub. (4) VPC endpoint policies on S3 endpoints to restrict which buckets can be accessed from which VPCs. (5) S3 bucket policies with condition keys (aws:SourceVpc, aws:SourceIp) to restrict access origins. (6) EventBridge rules that alert on large data transfers (Macie/GuardDuty findings). (7) AWS Backup with cross-account backup for ransomware protection.  
C) Encrypt all S3 data and assume it's protected.  
D) Block all internet access from the VPC.

**Correct Answer: B**
**Explanation:** Data exfiltration prevention requires multiple layers: Macie detects sensitive data exposure. GuardDuty detects unusual access patterns (impossible travel, unusual volumes). CloudTrail data events provide complete access audit. VPC endpoint policies and bucket policies restrict where data can be accessed from. EventBridge enables real-time alerting. Backup protects against ransomware. Option A is reactive and infrequent. Option C — encryption doesn't prevent authorized users from exfiltrating data. Option D blocks legitimate access.

---

### Question 18
A company is implementing a secure CI/CD pipeline for deploying applications to production. They need to ensure that only approved code reaches production, all deployments are audited, and secrets are never exposed in the pipeline. What security controls should the architect implement?

A) Give developers direct access to production accounts.  
B) Implement a secure CI/CD pipeline: (1) Source — CodeCommit with branch protection (require PR reviews, signed commits). (2) Build — CodeBuild in an isolated VPC, build specs don't contain secrets (use Secrets Manager/Parameter Store references). (3) Security scanning — SAST (CodeGuru), dependency scanning (Snyk/Trivy), container image scanning (ECR), IaC scanning (cfn-nag/checkov). (4) Approval gate — manual approval in CodePipeline before production deployment, requiring a security team member. (5) Deploy — cross-account deployment role with minimum permissions. (6) Audit — CodePipeline execution history in CloudTrail, deployment notifications in SNS. (7) Secrets — never in source control; detected by Amazon CodeGuru Secrets Detector.  
C) Deploy directly from developer laptops to production.  
D) Use a single AWS account for both CI/CD and production.

**Correct Answer: B**
**Explanation:** A secure pipeline enforces multiple security controls: branch protection prevents unauthorized code changes. Security scanning catches vulnerabilities before deployment. Manual approval gates ensure human verification. Cross-account deployment with minimum permissions follows least privilege. Secrets management prevents credential exposure. Complete audit trail enables forensic investigation. Option A bypasses all controls. Option C lacks reproducibility and audit. Option D lacks environment isolation.

---

### Question 19
A company discovers that a developer accidentally created an S3 bucket policy that grants public read access to a bucket containing customer PII. This has been in place for 2 weeks. What should the incident response and remediation plan include? (Select THREE.)

A) Immediately remove the public access by updating the bucket policy and enabling S3 Block Public Access at the account level.  
B) Use CloudTrail S3 data event logs to identify all GetObject requests to the bucket during the 2-week window — determine which objects were accessed and from which IP addresses.  
C) Delete all data from the bucket to prevent further exposure.  
D) Engage the legal/compliance team to assess data breach notification requirements under applicable regulations (GDPR, CCPA, etc.) based on the data accessed.  
E) Blame the developer who created the bucket policy.

**Correct Answer: A, B, D**
**Explanation:** (A) Immediate remediation stops ongoing exposure. Account-level Block Public Access prevents recurrence. (B) Forensic analysis of CloudTrail data events reveals the actual blast radius — which specific objects were accessed and by whom (potential attackers vs. search engine crawlers). (D) Legal assessment determines if regulatory notification is required — GDPR requires 72-hour breach notification, CCPA has similar requirements. The actual data accessed determines the notification scope. Option C destroys evidence and data. Option E is not an incident response action.

---

### Question 20
A company wants to implement a centralized secrets management solution across their multi-account Organization. They need to share secrets securely between accounts, enforce encryption, and audit all secret access. What should the architect design?

A) Store secrets in a shared S3 bucket with cross-account access.  
B) Deploy AWS Secrets Manager with cross-account sharing: (1) Create secrets in a centralized secrets account. (2) Use resource-based policies on secrets to grant cross-account access to specific IAM roles. (3) Encrypt all secrets with customer-managed KMS keys — grant cross-account Decrypt permissions via KMS key policy. (4) Enable CloudTrail logging for all Secrets Manager API calls. (5) Use AWS Config rules to detect secrets not encrypted with the approved KMS key. (6) Implement automatic rotation for all secrets. (7) Use Secrets Manager's replication feature for multi-Region secrets.  
C) Share secrets via AWS Systems Manager Parameter Store SecureString with cross-account access.  
D) Use AWS Organizations to automatically share secrets.

**Correct Answer: B**
**Explanation:** Secrets Manager with resource-based policies enables secure cross-account sharing with fine-grained access control. KMS customer-managed keys provide encryption with cross-account key sharing. CloudTrail provides complete audit of who accessed which secret and when. Config rules enforce encryption compliance. Automatic rotation maintains security hygiene. Multi-Region replication supports DR scenarios. Option A is not designed for secrets management. Option C — Parameter Store has limitations in cross-account sharing and rotation. Option D — Organizations doesn't share secrets automatically.

---

### Question 21
A company runs a public-facing API that is under a persistent credential stuffing attack. Attackers use stolen username/password combinations from other breached sites to try logging into the company's system. The attacks come from thousands of different IP addresses. What layered defenses should the architect implement?

A) Block all suspicious IP addresses using NACLs.  
B) Implement multi-layered credential stuffing defense: (1) AWS WAF with Bot Control managed rule group to detect and block automated credential stuffing bots. (2) WAF rate-based rules per IP to throttle login attempts. (3) Amazon Cognito with compromised credentials detection — Cognito checks submitted passwords against known breach databases and blocks or warns. (4) Enforce MFA for all users via Cognito. (5) Implement CAPTCHA challenge on the login page after N failed attempts (WAF CAPTCHA action). (6) CloudFront with geographic restrictions for regions with no legitimate users. (7) GuardDuty for detecting successful unauthorized logins.  
C) Require stronger passwords only.  
D) Rate limit all API endpoints uniformly.

**Correct Answer: B**
**Explanation:** Credential stuffing requires multiple defenses because attackers adapt. Bot Control detects automated tools. Rate limiting slows down attacks. Cognito compromised credentials detection catches known-breached passwords. MFA prevents login even with correct credentials. CAPTCHA adds human verification. Geographic restrictions reduce the attack surface. GuardDuty catches successful breaches. No single defense is sufficient. Option A — thousands of IPs make blocking impractical. Option C doesn't help if credentials are correct. Option D affects legitimate users.

---

### Question 22
A company needs to implement a secure landing zone for their AWS Organization. The landing zone must enforce security baselines, provide compliant account provisioning, and implement guardrails across all accounts. What should the architect deploy?

A) Manually configure each AWS account with security settings.  
B) Deploy AWS Control Tower to create a governed multi-account environment: (1) Landing zone with mandatory guardrails (CloudTrail enabled, S3 public access blocked, root user MFA required). (2) Strongly recommended guardrails (EBS encryption, RDS encryption, GuardDuty enabled). (3) Account Factory for automated, compliant account provisioning with pre-configured baselines. (4) Customizations for Control Tower (CfCT) to deploy additional security tooling (Security Hub, Inspector, Macie) in every new account. (5) AWS Service Catalog for approved infrastructure patterns. (6) Centralized logging in a Log Archive account and security monitoring in an Audit account.  
C) Use a third-party governance tool.  
D) Create a CloudFormation template and manually apply it to each account.

**Correct Answer: B**
**Explanation:** Control Tower provides a governed landing zone with built-in guardrails (preventive and detective). Account Factory automates account provisioning with security baselines. CfCT extends the baseline with custom security tooling. The Log Archive and Audit accounts provide centralized security infrastructure. This is the AWS-recommended approach for multi-account governance. Option A is manual and error-prone. Option C adds complexity. Option D requires manual execution in each account and doesn't enforce compliance.

---

### Question 23
A company suspects that an insider threat actor (a privileged administrator) is accessing customer data without business justification. They need to detect unusual database access patterns without alerting the suspected insider. What should the architect implement?

A) Review database access logs during quarterly audits.  
B) Implement covert monitoring: (1) Enable Amazon RDS Performance Insights and activity streams (Database Activity Streams for Aurora) to capture all database operations with detailed query logging. (2) Stream activity to a Kinesis Data Stream in a security account that the insider doesn't have access to. (3) Use Lambda to analyze access patterns (unusual hours, unusual tables, unusual data volumes, unusual queries). (4) Enable GuardDuty RDS protection for anomalous login detection. (5) Use Amazon Macie to detect if sensitive data appears in unauthorized locations (indicating exfiltration). (6) Create a honey token (fake high-value record in the database) — access to this record triggers an immediate alert.  
C) Remove the administrator's access immediately.  
D) Deploy a DLP agent on the administrator's workstation.

**Correct Answer: B**
**Explanation:** Insider threat investigation requires covert monitoring — alerting the subject would cause them to cover their tracks. Database Activity Streams provide complete, tamper-proof database operation logs streamed to a secured account. Lambda analysis detects unusual patterns. Honey tokens provide high-confidence indicators of unauthorized access (no legitimate reason to access fake records). GuardDuty adds ML-based anomaly detection. All monitoring is invisible to the insider. Option A is too infrequent. Option C alerts the insider. Option D may not be possible or may alert the insider.

---

### Question 24
A company needs to implement network segmentation for their microservices running on EKS. Different services have different security classifications (public-facing, internal, restricted). They need to enforce that restricted services can only communicate with specific internal services, and public-facing services cannot directly access restricted services. What should the architect implement?

A) Use Kubernetes namespaces as the sole isolation mechanism.  
B) Implement multi-layer network segmentation: (1) Kubernetes Network Policies to enforce pod-to-pod communication rules (restricted pods can only receive traffic from specific internal service pods). (2) Separate EKS node groups in different subnets for each security classification. (3) Security groups on node groups to enforce subnet-level access control. (4) Use Calico or Cilium network policy engines for advanced policy features (DNS-based, L7 filtering). (5) AWS VPC Lattice for service-to-service authorization with IAM-based access control. (6) Network ACLs as a secondary defense layer on subnets.  
C) Use separate EKS clusters for each security classification.  
D) Rely on application-level authentication only.

**Correct Answer: B**
**Explanation:** Network segmentation in EKS requires multiple layers: Kubernetes Network Policies provide pod-level control (fine-grained). Node group separation provides infrastructure-level isolation. Security groups provide AWS-native access control. Advanced network policy engines add L7 and DNS-based filtering. VPC Lattice adds identity-based service authorization. NACLs provide subnet-level defense. This defense-in-depth approach ensures that no single layer failure exposes restricted services. Option A — namespaces don't provide network isolation by default. Option C is expensive and operationally heavy. Option D doesn't address network-level threats.

---

### Question 25
A company needs to implement a centralized certificate management solution for their hybrid environment. They issue certificates for internal services (mutual TLS between microservices), IoT devices, and VPN endpoints. Certificates must be automatically renewed and revoked when needed. What should the architect design?

A) Use self-signed certificates managed by each application team.  
B) Deploy AWS Certificate Manager Private CA (ACM PCA) as the root or subordinate CA: (1) Create a CA hierarchy (root CA + subordinate CAs per environment). (2) Issue short-lived certificates for microservices (24-hour validity with automatic renewal). (3) Use ACM for managed certificate issuance and renewal. (4) For IoT devices, use ACM PCA API to issue device certificates at scale. (5) Configure Certificate Revocation Lists (CRL) published to S3 and OCSP endpoints for real-time revocation checking. (6) Use CloudTrail to audit all certificate operations. (7) Share the CA across accounts using AWS RAM for cross-account certificate issuance.  
C) Use Let's Encrypt for all internal certificates.  
D) Store certificates in Secrets Manager and rotate them manually.

**Correct Answer: B**
**Explanation:** ACM PCA provides a managed CA for internal certificate issuance. Short-lived certificates reduce the blast radius of certificate compromise. CA hierarchy enables organizational structure. CRL and OCSP provide revocation capabilities. Cross-account sharing via RAM centralizes certificate management. CloudTrail audits all operations. This handles all use cases (microservices, IoT, VPN). Option A is unmanaged and lacks revocation. Option C — Let's Encrypt is for public certificates, not internal mTLS. Option D — manual rotation is error-prone.

---

### Question 26
A company operates a multi-account AWS environment. They want to prevent any account from disabling CloudTrail, GuardDuty, or Security Hub — even if an attacker gains administrator access to an account. What should the architect implement?

A) Enable MFA on all IAM users and roles.  
B) Implement preventive SCPs at the Organization level that deny the following actions for all accounts except the management and security accounts: cloudtrail:StopLogging, cloudtrail:DeleteTrail, guardduty:DisableOrganizationAdminAccount, guardduty:DeleteDetector, securityhub:DisableSecurityHub, securityhub:DeleteMembers. Use a deny list SCP approach — explicitly deny these actions. Additionally, use AWS Config rules as detective controls to alert if these services are disabled despite the SCPs.  
C) Use IAM policies to restrict these actions for non-admin users.  
D) Monitor for service disablement using CloudWatch and react after the fact.

**Correct Answer: B**
**Explanation:** SCPs are the strongest preventive control in AWS — they override IAM permissions, including administrator access. Even an account root user (with certain exceptions) cannot override SCPs. Denying security service disablement ensures that even a compromised administrator can't blind security monitoring. Config rules provide a detective backup. Option A — MFA doesn't prevent an authenticated admin from disabling services. Option C — IAM policies can be modified by an admin. Option D is reactive, not preventive.

---

### Question 27
A company's web application is hit by a sophisticated Layer 7 DDoS attack. The attacker sends valid-looking HTTP requests at a high rate from a botnet. The requests pass through WAF rules because they appear legitimate individually. How should the architect configure AWS WAF to detect and mitigate this attack?

A) Increase the rate-based rule threshold to allow more traffic.  
B) Implement advanced WAF detection: (1) WAF rate-based rules with multiple dimensions — rate limit per IP, per session cookie, per API key, and per URI path. (2) WAF Bot Control managed rule group with targeted protection (analyzes browser fingerprints, interaction patterns, and token validation). (3) WAF CAPTCHA and Challenge actions for suspicious traffic. (4) Custom WAF rules matching known bot patterns (abnormal header combinations, missing standard headers). (5) CloudFront with Shield Advanced for automatic L7 DDoS response. (6) WAF logging to Kinesis Firehose → OpenSearch for real-time traffic analysis and pattern identification.  
C) Block all traffic temporarily until the attack stops.  
D) Scale up the backend infrastructure to absorb the attack.

**Correct Answer: B**
**Explanation:** Sophisticated L7 DDoS requires multi-dimensional analysis. Single-IP rate limiting fails against botnets with thousands of IPs. Multi-dimensional rate limiting (per session, per endpoint) catches distributed attacks. Bot Control analyzes browser behavior and fingerprints. CAPTCHA challenges differentiate humans from bots. Custom rules catch specific bot signatures. Shield Advanced provides automatic L7 attack response. Real-time log analysis identifies emerging patterns. Option A makes the problem worse. Option C blocks legitimate users. Option D doesn't stop the attack.

---

### Question 28
A company needs to implement a data encryption strategy where they control the encryption keys and AWS services never have access to the plaintext data. They need this for a specific dataset containing trade secrets. What encryption approach should the architect use?

A) Use server-side encryption with KMS (SSE-KMS).  
B) Implement client-side encryption: (1) Encrypt data before sending it to any AWS service using the AWS Encryption SDK with customer-managed KMS keys or keys stored in AWS CloudHSM. (2) For S3, use the S3 Encryption Client to encrypt objects before upload (SSE-C or client-side encryption). (3) For DynamoDB, use the DynamoDB Encryption Client to encrypt attributes before writing. (4) Store encryption keys in CloudHSM (FIPS 140-2 Level 3 validated) for maximum key control — keys never leave the HSM. (5) Manage key access through CloudHSM user management, completely separate from AWS IAM.  
C) Use S3 default encryption and trust AWS.  
D) Use application-level encryption with hardcoded keys.

**Correct Answer: B**
**Explanation:** Client-side encryption ensures AWS services only receive ciphertext — they never have access to plaintext data. CloudHSM provides the highest level of key control (dedicated hardware, keys never leave the HSM, customer-exclusive access). The AWS Encryption SDK handles the encryption complexity. DynamoDB and S3 encryption clients are purpose-built for their respective services. This meets the requirement that AWS never sees plaintext. Option A — with SSE-KMS, AWS services decrypt data for processing. Option C — AWS manages the encryption process. Option D — hardcoded keys are a critical vulnerability.

---

### Question 29
A company needs to secure their Amazon S3 data against ransomware attacks. Attackers who gain access could encrypt or delete all objects. What should the architect implement for ransomware protection?

A) Enable S3 versioning only.  
B) Implement comprehensive S3 ransomware protection: (1) S3 Versioning — enables recovery of overwritten/encrypted objects (restore previous versions). (2) S3 Object Lock with Governance or Compliance mode — prevents deletion/modification for a retention period (even root user can't override Compliance mode). (3) MFA Delete — requires MFA to delete object versions. (4) S3 replication to a cross-account backup bucket with separate IAM permissions. (5) AWS Backup with cross-account backup vault — immutable backup copies in an isolated account. (6) S3 bucket policies denying s3:DeleteObject from non-backup roles. (7) GuardDuty S3 protection for anomalous access detection. (8) IAM least privilege — no service has permissions to both read and delete in production.  
C) Encrypt all S3 data so attackers can't read it.  
D) Perform daily S3 backups to the same account.

**Correct Answer: B**
**Explanation:** Ransomware protection requires multiple layers: Versioning preserves original objects. Object Lock makes them immutable. MFA Delete adds an authentication barrier. Cross-account replication ensures backups survive account compromise. AWS Backup provides managed, isolated backup copies. Access controls limit who can delete. GuardDuty detects the attack in progress. Option A — versioning alone doesn't prevent deletion of versions. Option C — encryption doesn't protect against ransomware (attacker re-encrypts). Option D — same-account backups are vulnerable to the same attack.

---

### Question 30
A company needs to implement network traffic inspection for all traffic entering and leaving their VPCs. They want to detect and block malicious traffic including known exploit attempts, malware communications, and protocol anomalies. What should the architect deploy?

A) Use security groups and NACLs for all traffic filtering.  
B) Deploy AWS Network Firewall in a centralized inspection VPC: (1) Stateless rules for basic packet filtering (block known bad IP ranges, port filtering). (2) Stateful rules for deep packet inspection — Suricata-compatible IDS/IPS rules from managed rule groups (AWS threat intelligence, emerging threats). (3) TLS inspection for decrypting and inspecting HTTPS traffic. (4) Domain-based filtering (allow only approved domains for egress). (5) Configure as a centralized inspection architecture via Transit Gateway. (6) Enable logging to CloudWatch and S3 for forensic analysis.  
C) Deploy GuardDuty as the sole network protection.  
D) Use VPC Traffic Mirroring to copy traffic for offline analysis.

**Correct Answer: B**
**Explanation:** Network Firewall provides inline (blocking) traffic inspection with deep packet inspection capability. Stateless rules handle high-volume basic filtering. Stateful rules with Suricata engine detect exploit attempts, malware communications, and protocol anomalies. TLS inspection examines encrypted traffic. Domain filtering controls egress destinations. Centralized deployment via TGW covers all VPCs. Logging enables forensic analysis. Option A can't perform deep packet inspection. Option C detects but doesn't block (detection only). Option D is passive monitoring, not active blocking.

---

### Question 31
A company is implementing IAM Access Analyzer across their Organization. They want to identify resources shared externally (cross-account access, public access) and validate IAM policies for least-privilege compliance. What should the architect configure?

A) Manually review IAM policies quarterly.  
B) Enable IAM Access Analyzer with organization-level trust zone: (1) The analyzer identifies resources (S3 buckets, IAM roles, KMS keys, Lambda functions, SQS queues) shared outside the Organization. (2) Archive expected findings (legitimate cross-organization sharing). (3) Create EventBridge rules for new findings to alert the security team. (4) Use Access Analyzer policy validation to check IAM policies for overly permissive actions, missing conditions, or security anti-patterns during CI/CD. (5) Use Access Analyzer policy generation to create least-privilege policies based on actual CloudTrail activity. (6) Run unused access analysis to identify permissions granted but never used.  
C) Use AWS Config to check for public resources only.  
D) Review S3 bucket policies manually for public access.

**Correct Answer: B**
**Explanation:** IAM Access Analyzer provides comprehensive external access analysis across the Organization. It identifies unintended sharing of resources outside the trust boundary. Policy validation catches overly permissive policies before deployment. Policy generation creates least-privilege policies from actual activity (reducing over-permissioned roles). Unused access analysis identifies permission bloat. EventBridge integration enables real-time alerting. Option A is manual and infrequent. Option C only covers a subset of resources. Option D only covers S3 and is manual.

---

### Question 32
A company needs to implement security for their container images in Amazon ECR. They want to prevent deployment of images with known vulnerabilities and ensure only images from approved registries are used. What should the architect implement?

A) Trust developers to use secure base images.  
B) Implement container image security pipeline: (1) ECR image scanning on push — enhanced scanning (powered by Amazon Inspector) detects OS and programming language vulnerabilities. (2) ECR lifecycle policies to remove untagged/old images. (3) ECR registry policy to restrict which IAM principals can push images. (4) Admission controller (OPA/Gatekeeper or Kyverno) in EKS that rejects pods using images not from the approved ECR registry or with critical vulnerabilities. (5) ECR image signing using Notation/Cosign with AWS Signer — verify image integrity and provenance at deployment. (6) ECR replication from a golden registry to production accounts.  
C) Use public images from Docker Hub for all containers.  
D) Scan images only in production after deployment.

**Correct Answer: B**
**Explanation:** Container image security requires a supply chain approach: scanning detects known vulnerabilities at push time. Lifecycle policies reduce the attack surface of old images. Registry policies control who can push. Admission controllers prevent deployment of vulnerable or unsigned images. Image signing ensures integrity and provenance (proving the image wasn't tampered with). Replication from a golden registry ensures all accounts use verified images. Option A provides no control. Option C introduces supply chain risk. Option D is too late.

---

### Question 33
A company needs to implement a break-glass procedure for emergency access to production systems. In normal operations, no one has direct access to production resources. During a critical incident, a designated incident commander needs temporary administrative access with full audit trail. What should the architect design?

A) Keep root credentials in a physical safe and use them during emergencies.  
B) Implement a break-glass access procedure: (1) IAM Identity Center (SSO) permission set with AdministratorAccess for production, but not assigned to anyone by default. (2) Break-glass Lambda function that, when invoked with proper authorization (senior management approval via API Gateway with custom authorizer), assigns the emergency permission set to the incident commander's SSO user for a limited time (2 hours). (3) SNS notification to security team, compliance team, and management when break-glass is activated. (4) CloudTrail logs all actions taken with the emergency permission. (5) Automatic expiration of the permission set assignment after the time limit. (6) Post-incident review required to analyze all actions taken during break-glass.  
C) Give all senior engineers permanent admin access "just in case."  
D) Use an AWS Organizations management account for all emergency operations.

**Correct Answer: B**
**Explanation:** Break-glass provides emergency access with maximum accountability. No standing access (zero trust) prevents abuse. The approval workflow ensures only authorized emergencies trigger access. Time-limited assignments expire automatically. Multi-party notification creates transparency. CloudTrail captures all actions for post-incident review. This balances security (no standing access) with operational need (rapid emergency response). Option A — root credentials bypass all controls and lack granular audit. Option C creates permanent over-privilege. Option D uses the most sensitive account for operations.

---

### Question 34
A company needs to protect their API keys, database passwords, and OAuth tokens used by Lambda functions. The secrets are accessed thousands of times per second across hundreds of Lambda invocations. They need minimal latency impact and security best practices. What should the architect implement?

A) Store secrets in environment variables encrypted with the Lambda service key.  
B) Use AWS Secrets Manager with the Secrets Manager Lambda extension (caching layer): (1) Store all secrets in Secrets Manager with automatic rotation enabled. (2) Deploy the Secrets Manager Lambda extension layer — it caches secrets locally within the Lambda execution environment, reducing latency to microseconds for cached lookups while refreshing from Secrets Manager periodically. (3) Encrypt secrets with customer-managed KMS keys. (4) Use resource-based policies to restrict which Lambda function roles can access which secrets. (5) Enable CloudTrail logging for all Secrets Manager access.  
C) Hardcode secrets in the Lambda function code.  
D) Store secrets in S3 and read them at Lambda invocation.

**Correct Answer: B**
**Explanation:** The Secrets Manager Lambda extension provides a local caching layer that eliminates the latency of Secrets Manager API calls for most requests. It caches secrets in memory and refreshes periodically. This provides high-performance access (thousands of TPS) while maintaining security (automatic rotation, KMS encryption, audit logging). Resource-based policies ensure least-privilege access. Option A — environment variables are visible in the Lambda console and lack rotation. Option C is a critical vulnerability. Option D adds S3 latency to every invocation.

---

### Question 35
A company is implementing a Security Information and Event Management (SIEM) solution on AWS. They need to collect, correlate, and analyze security events from across their Organization in real-time. What should the architect design?

A) Use CloudWatch Logs for all security event storage and analysis.  
B) Build a SIEM architecture: (1) Amazon Security Lake as the centralized security data lake, collecting and normalizing data from CloudTrail, VPC Flow Logs, GuardDuty, Security Hub findings, DNS logs, and third-party sources in OCSF format. (2) Amazon OpenSearch Service for real-time search, correlation rules, and dashboards (SIEM frontend). (3) Lambda functions for automated correlation and alerting (e.g., correlate GuardDuty finding with CloudTrail events). (4) EventBridge for real-time event routing to response workflows. (5) Step Functions for automated incident response playbooks (isolate instance, snapshot evidence, notify team). (6) Amazon Athena for historical investigation queries on the data lake.  
C) Deploy a third-party SIEM on EC2.  
D) Use Security Hub as the sole SIEM solution.

**Correct Answer: B**
**Explanation:** A comprehensive SIEM requires collection, normalization, correlation, alerting, and response. Security Lake normalizes diverse data sources into a queryable format. OpenSearch provides real-time search and correlation for SIEM use cases. Lambda handles automated correlation logic. EventBridge routes events to response workflows. Step Functions orchestrate complex response playbooks. Athena enables historical investigation. Option A lacks correlation and SIEM features. Option C requires managing infrastructure. Option D — Security Hub aggregates findings but doesn't provide full SIEM correlation and investigation capabilities.

---

### Question 36
A company wants to ensure that all EBS volumes, RDS instances, and S3 buckets across their Organization are encrypted. They need both detection of unencrypted resources and prevention of creating unencrypted resources. What controls should the architect implement?

A) Send reminder emails to teams about encryption requirements.  
B) Implement preventive and detective controls: (1) Preventive SCPs — deny ec2:CreateVolume without the encrypted=true condition, deny rds:CreateDBInstance without StorageEncrypted=true, deny s3:CreateBucket actions and require BucketEncryption in the CloudFormation/Terraform template. (2) S3 account-level default encryption setting. (3) EBS account-level encryption by default setting. (4) Detective — AWS Config rules (encrypted-volumes, rds-storage-encrypted, s3-bucket-server-side-encryption-enabled) flagging non-compliant resources. (5) Auto-remediation via Config remediation actions or Systems Manager Automation documents that encrypt unencrypted resources.  
C) Use AWS Trusted Advisor to check for encryption.  
D) Enable encryption on new resources only and ignore existing ones.

**Correct Answer: B**
**Explanation:** Preventive controls (SCPs) block creation of unencrypted resources at the Organization level — no account can bypass this. Account-level default encryption ensures encryption even when users forget to specify it. Detective controls (Config rules) find existing non-compliant resources. Auto-remediation fixes violations automatically. This combination ensures complete coverage. Option A is not a technical control. Option C — Trusted Advisor has limited encryption checks. Option D ignores the existing encryption gap.

---

### Question 37
A company needs to implement cross-account access for their security team. The security team in Account A needs read-only access to CloudTrail logs, VPC Flow Logs, and GuardDuty findings in 50 member accounts. They should not have any other permissions in the member accounts. What is the most secure and scalable approach?

A) Create IAM users for the security team in each member account.  
B) Use IAM Identity Center (SSO) with permission sets: (1) Create a custom permission set with read-only permissions for CloudTrail, GuardDuty, and CloudWatch Logs (VPC Flow Logs). (2) Assign the permission set to the security team group in Identity Center. (3) Assign the permission set to all 50 member accounts. Security team members assume the role via SSO portal. Alternatively, create a cross-account IAM role in each member account (via CloudFormation StackSets) that trusts the security account, with the same read-only permissions.  
C) Share CloudTrail and GuardDuty credentials with the security team.  
D) Give the security team access to the Organization management account to view all accounts.

**Correct Answer: B**
**Explanation:** IAM Identity Center provides centralized, scalable cross-account access management. Permission sets define the exact permissions (read-only for security services). Assignment to 50 accounts is managed centrally. SSO provides a single login experience. The read-only permissions follow least privilege. StackSets can alternatively deploy cross-account roles at scale. Option A requires managing 50 × N user credentials. Option C — credentials shouldn't be shared. Option D gives excessive access to the most privileged account.

---

### Question 38
A company discovers that their application is vulnerable to SQL injection attacks. The application uses an Aurora MySQL database and is fronted by an ALB. They need immediate protection while the development team fixes the application code. What should the architect implement?

A) Update the application code immediately.  
B) Deploy immediate protection layers: (1) AWS WAF on the ALB with the AWS Managed Rules SQL injection rule set — blocks common SQL injection patterns in request parameters, headers, and body. (2) Enable WAF logging to identify and tune rules (reduce false positives). (3) Configure RDS IAM authentication to reduce credential-based attack surface. (4) Apply Aurora DB cluster parameter group changes to enable audit logging. (5) Use Amazon RDS Proxy as an intermediary that provides connection pooling and can help limit the impact of SQL injection by restricting connection permissions. (6) Medium-term: implement parameterized queries in the application code.  
C) Block all traffic to the application until the code is fixed.  
D) Add a firewall appliance in front of the ALB.

**Correct Answer: B**
**Explanation:** WAF SQL injection rules provide immediate protection while the code fix is developed. Managed rule groups are maintained by AWS and cover known SQL injection patterns. WAF logging enables tuning to reduce false positives. RDS Proxy limits database connection permissions. Audit logging captures any successful injection attempts for forensic analysis. The code fix (parameterized queries) is the definitive solution. Option A takes time to implement and test. Option C causes business disruption. Option D adds complexity when WAF provides managed protection.

---

### Question 39
A company needs to implement a forensic investigation capability. When a security incident is detected, they need to rapidly capture and preserve evidence from EC2 instances, including memory dumps, disk snapshots, and network captures. What automated forensic procedure should the architect build?

A) Manually SSH into the instance and run forensic tools.  
B) Build an automated forensic evidence collection pipeline: (1) EventBridge rule triggered by GuardDuty high-severity findings. (2) Step Functions orchestrates evidence collection. (3) Lambda isolates the instance (change security group to forensic isolation). (4) SSM Run Command captures memory dump (using tools like LiME for Linux or winpmem for Windows pre-installed via golden AMI). (5) Lambda creates EBS snapshots of all attached volumes. (6) VPC Traffic Mirroring captures live network traffic to a forensic analysis instance. (7) Copy all evidence to a dedicated forensic S3 bucket in a separate account with Object Lock for chain of custody. (8) Tag the instance with incident ID and timestamp. (9) All actions logged with timestamps for legal admissibility.  
C) Terminate the instance and analyze the EBS volumes later.  
D) Take screenshots of the CloudWatch console for evidence.

**Correct Answer: B**
**Explanation:** Automated forensic collection ensures rapid, consistent evidence preservation. Memory dumps capture running processes and network connections (volatile evidence). EBS snapshots preserve disk state. VPC Traffic Mirroring captures live communications. Cross-account S3 with Object Lock ensures evidence integrity and chain of custody. Automation reduces human error and ensures evidence is collected before it's lost. Option A is slow and may alter evidence. Option C loses volatile memory evidence. Option D is not forensically sound evidence.

---

### Question 40
A company wants to implement data loss prevention (DLP) for their email system running on Amazon WorkMail. They need to prevent employees from sending emails containing credit card numbers, SSNs, or proprietary project code names. What should the architect design?

A) Train employees not to send sensitive information via email.  
B) Implement a multi-layer DLP solution: (1) Amazon WorkMail flow rules to route outgoing emails through a Lambda function for content inspection. (2) The Lambda function uses Amazon Comprehend PII detection to identify credit card numbers and SSNs. (3) Custom regex patterns for proprietary project code names. (4) If sensitive content is detected, the Lambda function either blocks the email and notifies the sender, quarantines it for manager review, or strips the sensitive content. (5) Amazon Macie scans email attachments stored in S3 for sensitive data. (6) Amazon SES with configuration sets for additional outbound email controls.  
C) Block all external email to prevent data leakage.  
D) Encrypt all outgoing emails so content is protected.

**Correct Answer: B**
**Explanation:** DLP for email requires content inspection before delivery. WorkMail flow rules integrate with Lambda for custom processing. Comprehend PII detection identifies standard sensitive data types automatically. Custom regex catches proprietary terms. Multiple actions (block, quarantine, strip) provide flexible response. Macie scans attachments for additional coverage. This prevents unintentional and intentional data leakage via email. Option A is not a technical control. Option C blocks all business communication. Option D — encrypted emails still leave the organization.

---

### Question 41
A company operates a healthcare application that processes PHI (Protected Health Information). They need to ensure HIPAA compliance for their AWS environment. What technical controls should the architect implement?

A) Sign a BAA with AWS and assume compliance is handled.  
B) Implement comprehensive HIPAA technical controls: (1) Sign a BAA with AWS (prerequisite). (2) Use only HIPAA-eligible AWS services. (3) Encrypt all PHI at rest (KMS with customer-managed keys) and in transit (TLS 1.2+). (4) Enable CloudTrail for all API logging. (5) VPC isolation for PHI workloads — no internet access, VPC endpoints only. (6) IAM least privilege with MFA for all PHI access. (7) Enable GuardDuty, Macie, and Security Hub for continuous monitoring. (8) Implement automatic session termination for idle sessions. (9) Enable RDS audit logging. (10) S3 access logging for all PHI buckets. (11) Implement backup with AWS Backup (HIPAA requires data backup). (12) Use AWS Artifact for compliance documentation.  
C) Use a separate on-premises environment for PHI data.  
D) Rely on AWS's inherent security for HIPAA compliance.

**Correct Answer: B**
**Explanation:** HIPAA compliance on AWS requires both organizational (BAA) and technical controls. Only HIPAA-eligible services can be used with PHI. Encryption protects confidentiality. CloudTrail and access logging provide the audit trail required by HIPAA. VPC isolation and IAM least privilege implement the minimum necessary standard. GuardDuty/Macie/Security Hub provide continuous security monitoring. Backup meets data availability requirements. Option A — BAA is necessary but not sufficient. Option C is unnecessary — AWS supports HIPAA workloads. Option D — AWS provides the infrastructure, but customers configure security controls.

---

### Question 42
A company wants to implement automated security remediation. When a non-compliant resource is detected (e.g., S3 bucket becomes public, security group allows 0.0.0.0/0 on SSH), it should be automatically remediated within minutes. What architecture should the architect build?

A) Create a weekly report of non-compliant resources for manual remediation.  
B) Build an automated remediation pipeline: (1) AWS Config rules detect non-compliant resources (s3-bucket-public-read-prohibited, restricted-ssh, ec2-instance-no-public-ip). (2) Config remediation actions trigger Systems Manager Automation documents. (3) SSM Automation documents execute the fix (e.g., PutPublicAccessBlock for S3, RevokeSecurityGroupIngress for open SSH). (4) For Security Hub findings, EventBridge rules trigger Lambda functions for remediation. (5) All remediation actions are logged in CloudTrail and notified via SNS to the resource owner. (6) Implement an exception mechanism — tagged resources can be excluded from auto-remediation with approval.  
C) Use GuardDuty as the sole remediation trigger.  
D) Deploy a cron job on EC2 that scans for non-compliant resources hourly.

**Correct Answer: B**
**Explanation:** Automated remediation reduces the window of exposure from hours/days to minutes. Config rules provide continuous compliance monitoring. SSM Automation documents execute standardized fixes. EventBridge routes findings from multiple sources to remediation functions. Logging and notification ensure transparency. The exception mechanism prevents auto-remediation from breaking intentionally configured resources. Option A — weekly cadence is too slow for security. Option C — GuardDuty detects threats, not compliance violations. Option D is less reliable and lacks the Config/SSM integration.

---

### Question 43
A company needs to implement a secure multi-account architecture where development teams have broad permissions in development accounts but very restricted permissions in production accounts. Administrative actions in production should require approval. What IAM architecture should the architect design?

A) Give developers the same permissions in all accounts.  
B) Use AWS IAM Identity Center with tiered permission sets: (1) Development accounts — PowerUserAccess permission set (broad permissions excluding IAM changes). (2) Staging accounts — ReadOnlyAccess by default, with temporary elevation to PowerUserAccess via a JIT approval workflow. (3) Production accounts — ReadOnlyAccess by default, with break-glass elevation to specific administrative permission sets via a multi-person approval workflow. (4) SCPs on production OUs that deny destructive actions (DeleteStack, TerminateInstances) unless the request comes from the CI/CD pipeline role. (5) CI/CD pipeline role in production has deployment permissions but is assumed only by CodePipeline, not humans. (6) All production changes go through the CI/CD pipeline.  
C) Use separate AWS Organizations for production and development.  
D) Use IAM users with different passwords in different accounts.

**Correct Answer: B**
**Explanation:** Tiered permissions balance developer productivity (broad dev access) with production security (restricted access, approval required). SCPs prevent destructive actions in production regardless of permissions. The CI/CD pipeline is the only path to production changes, ensuring code review and testing. JIT elevation provides temporary access when needed with audit trails. This implements the principle of least privilege across environments. Option A is overly permissive for production. Option C breaks unified governance. Option D is an anti-pattern.

---

### Question 44
A company needs to securely connect to AWS APIs from their on-premises data center without traversing the public internet. They also need to ensure that AWS API credentials are not exposed if on-premises systems are compromised. What should the architect implement?

A) Use IAM users with long-term access keys from on-premises.  
B) Configure a secure on-premises to AWS API path: (1) Direct Connect with private VIF for network connectivity. (2) VPC Interface Endpoints (PrivateLink) for all required AWS APIs (S3, STS, EC2, etc.). (3) Route on-premises AWS API traffic through the Direct Connect → VPC → VPC Endpoints path. (4) Use AWS STS with AssumeRoleWithSAML — on-premises applications authenticate with the corporate IdP (AD), receive SAML assertions, exchange them for temporary AWS credentials. No long-term AWS keys on-premises. (5) IAM role trust policies with conditions restricting role assumption to the VPC (aws:SourceVpc condition).  
C) Use a VPN for encrypted API calls over the internet.  
D) Proxy all API calls through an EC2 instance.

**Correct Answer: B**
**Explanation:** This architecture keeps all API traffic private (DX → VPC → PrivateLink, never internet) and eliminates long-term credentials on-premises. SAML-based temporary credentials via STS mean that even if on-premises systems are compromised, there are no AWS access keys to steal — only short-lived tokens that expire. The VPC source condition ensures the role can only be assumed from the secure network path. Option A puts long-term keys on-premises. Option C uses the internet. Option D requires managing a proxy instance.

---

### Question 45
A company is implementing a Web Application Firewall strategy. They have 30 web applications with different security requirements — some handle payments (PCI), some are public marketing sites, and some are internal tools. How should the architect structure WAF across these applications?

A) Use a single WAF WebACL for all 30 applications.  
B) Implement a tiered WAF strategy: (1) Create a base WebACL rule group (shared) with common protections: IP reputation lists, known bad bots, rate limiting. (2) Payment applications — additional rule group with PCI-specific rules (SQL injection, XSS, credit card number detection in responses, stricter rate limiting). (3) Public marketing sites — add Bot Control managed rule group. (4) Internal tools — IP-based allow list restricting access to corporate IP ranges. (5) Use AWS Firewall Manager to deploy and manage WAF policies across all accounts from a central administrator. (6) WAF logging to S3/Kinesis for each WebACL for analysis and tuning.  
C) Deploy WAF only on payment applications since they're highest risk.  
D) Use NACLs instead of WAF for all applications.

**Correct Answer: B**
**Explanation:** Different applications have different threat profiles and need appropriate WAF configurations. Shared rule groups provide baseline protection. Additional rule groups add context-specific security. Firewall Manager centralizes policy management across 30 applications and multiple accounts, ensuring consistent deployment. Per-WebACL logging enables tuning and incident investigation. Option A — one-size-fits-all creates overly restrictive or insufficient rules for individual apps. Option C leaves most applications unprotected. Option D — NACLs can't inspect application-layer traffic.

---

### Question 46
A company's GuardDuty detects a finding of type "UnauthorizedAccess:IAMUser/InstanceCredentialExfiltration.OutsideAWS" for one of their EC2 instances. What does this mean and what should the incident response be?

A) The EC2 instance is making normal API calls that GuardDuty incorrectly flagged.  
B) The finding means that IAM role credentials assigned to the EC2 instance are being used from an IP address outside of AWS (indicating credential exfiltration). Incident response: (1) Identify the compromised EC2 instance from the finding. (2) Isolate the instance (forensic security group). (3) Rotate the IAM role's credentials by updating the instance profile (detach/reattach) or creating a new role with restricted permissions. (4) Review CloudTrail for all API calls made with the compromised credentials — identify what the attacker accessed/modified. (5) Enforce IMDSv2 on the instance and all instances to prevent future SSRF-based credential theft. (6) Add aws:SourceVpc or aws:ViaAWSService conditions to the IAM role policy to restrict credential use to the VPC. (7) Investigate how the credentials were exfiltrated (application vulnerability, SSRF).  
C) Reboot the EC2 instance to resolve the issue.  
D) Disable GuardDuty to stop receiving alerts.

**Correct Answer: B**
**Explanation:** This GuardDuty finding specifically indicates that instance role credentials are being used from outside AWS — a clear indicator of credential exfiltration (likely via SSRF exploiting IMDSv1). The response follows incident response best practices: isolate, preserve evidence, rotate credentials, investigate blast radius, remediate the vulnerability, and prevent recurrence. IMDSv2 prevents future SSRF-based credential theft. VPC conditions prevent exfiltrated credentials from being usable outside the VPC. Option A should be investigated, not dismissed. Option C doesn't address the credential compromise. Option D ignores the threat.

---

### Question 47
A company wants to implement network microsegmentation in their AWS environment. Each workload should only be able to communicate with explicitly approved endpoints. Default behavior should deny all traffic. What should the architect design?

A) Use a single permissive security group for all instances.  
B) Implement microsegmentation: (1) Security groups as the primary control — each service has its own security group with rules allowing only specific inbound sources and outbound destinations (no 0.0.0.0/0). (2) Reference other security groups by ID (not CIDR) for internal communication — this creates a service-to-service allowlist. (3) NACLs as a secondary layer with explicit deny rules for known-bad traffic. (4) AWS Network Firewall for deep packet inspection between segments. (5) VPC Lattice auth policies for service-to-service authorization at the application layer. (6) AWS Config rules to detect security groups with 0.0.0.0/0 rules and auto-remediate.  
C) Use NACLs only for all network filtering.  
D) Deploy a jump box and route all traffic through it.

**Correct Answer: B**
**Explanation:** Microsegmentation creates fine-grained security boundaries around each workload. Security group cross-referencing creates explicit allowlists (service A's SG allows inbound only from service B's SG). NACLs add defense-in-depth. Network Firewall provides deep inspection at segment boundaries. VPC Lattice adds application-layer authorization. Config rules enforce the no-0.0.0.0/0 policy. This implements default-deny at multiple layers. Option A is the opposite of microsegmentation. Option C — NACLs alone are stateless and harder to manage. Option D creates a bottleneck.

---

### Question 48
A company needs to implement a secure key management architecture for multi-tenant SaaS. Each tenant's data must be encrypted with a separate key, and tenants should never be able to access each other's encryption keys. The solution must scale to 10,000 tenants. What should the architect design?

A) Use a single KMS key for all tenants.  
B) Use a KMS key hierarchy: (1) Create a top-level KMS key per environment (prod, staging). (2) Use AWS KMS key policies with encryption context — each encryption operation includes the tenant ID in the encryption context. (3) IAM policies condition on kms:EncryptionContext to restrict which tenant IDs each service can use when encrypting/decrypting. (4) This allows a manageable number of KMS keys (one per environment or service) while achieving tenant-level isolation through encryption context. (5) For tenants requiring dedicated keys (enterprise tier), create per-tenant KMS keys with dedicated key policies. (6) Use KMS grants for temporary, fine-grained key access.  
C) Create 10,000 separate KMS keys, one per tenant.  
D) Use tenant-provided encryption keys (SSE-C) for all storage.

**Correct Answer: B**
**Explanation:** Encryption context provides tenant-level key isolation without creating thousands of KMS keys (which would hit account limits and be operationally expensive). The tenant ID in the encryption context ensures that data encrypted for tenant A can only be decrypted with the same context — IAM policies enforce which services can use which tenant's context. For enterprise tenants, dedicated keys provide additional isolation. This scales to 10,000 tenants efficiently. Option A provides no tenant isolation. Option C doesn't scale (KMS key limits). Option D puts key management burden on tenants.

---

### Question 49
A company needs to ensure that their AWS resources comply with CIS AWS Foundations Benchmark. They want continuous compliance monitoring with the ability to export compliance reports for auditors. What should the architect configure?

A) Manually check CIS Benchmark controls quarterly.  
B) Enable AWS Security Hub with the CIS AWS Foundations Benchmark standard. Security Hub automatically evaluates all CIS controls continuously (MFA on root, CloudTrail enabled, S3 public access, password policy, etc.). Enable the AWS Foundational Security Best Practices standard as a complement. Configure Security Hub to export findings to S3 (via EventBridge → Kinesis Firehose) for auditor access. Create Security Hub insights for compliance dashboards. Use Amazon QuickSight for visual compliance reports. Address failed checks with automated remediation via EventBridge → Lambda.  
C) Use AWS Audit Manager for CIS compliance.  
D) Deploy a third-party compliance scanning tool.

**Correct Answer: B**
**Explanation:** Security Hub provides automated, continuous CIS Benchmark evaluation. Controls are checked against actual AWS configuration in real-time. Failed checks generate findings with remediation guidance. Export to S3 provides auditor-accessible reports. Automated remediation addresses non-compliance quickly. Note: AWS Audit Manager (Option C) is also valid for CIS compliance and may be preferred for generating audit-ready reports — it provides evidence collection and report generation. Both B and C are valid, but Security Hub provides the continuous monitoring aspect.

---

### Question 50
A company detects that an attacker has gained access to an IAM role and created several EC2 instances for cryptocurrency mining. The instances have been running for 6 hours. What steps should the security team take for incident response and cost containment? (Select THREE.)

A) Terminate all unauthorized EC2 instances immediately and document the instance IDs, AMI IDs, security groups, and VPC configurations before termination for forensic analysis.  
B) Revoke the compromised IAM role's active sessions by adding an inline deny-all policy with an aws:TokenIssueTime condition for sessions before the current time, then rotate the role's policies.  
C) Review CloudTrail logs to determine: how the role was compromised, what other resources were created/accessed, and whether persistence mechanisms (additional IAM users, access keys, Lambda functions) were established. Remove all unauthorized resources and backdoors.  
D) Delete the AWS account to ensure complete cleanup.  
E) Increase the account's EC2 service limits to prevent future throttling.

**Correct Answer: A, B, C**
**Explanation:** (A) Terminating mining instances stops the cost bleed. Documenting configurations before termination preserves evidence (instance types, AMIs, SGs may indicate the attacker's toolkit). (B) The IAM deny-all policy with TokenIssueTime invalidates existing sessions — even if the attacker has cached credentials, they can't use them. (C) CloudTrail analysis reveals the full attack scope — backdoors (additional IAM users/keys), data access, and the initial compromise vector. Removing persistence mechanisms prevents re-entry. Option D is extreme and unnecessary. Option E makes it easier for the attacker to launch more instances.

---

### Question 51
A company is deploying a sensitive application on AWS and wants to ensure that no AWS employee can access their data, even during support operations. They need the highest level of data isolation. What should the architect configure?

A) Use standard AWS encryption and trust AWS's security practices.  
B) Implement AWS Nitro Enclaves for the most sensitive processing: (1) Nitro Enclaves create isolated compute environments where even the EC2 instance host OS and AWS operators cannot access the data being processed. (2) Use client-side encryption with CloudHSM-managed keys for data at rest — keys never leave the HSM. (3) Use KMS with external key store (XKS) backed by customer-managed HSM for S3 and EBS encryption — AWS never has access to the key material. (4) Enable CloudTrail with KMS for encrypted audit logs. (5) Use VPC endpoints to ensure data never traverses the internet.  
C) Deploy all workloads on AWS Outposts at the company's data center.  
D) Require AWS to sign an NDA for each employee.

**Correct Answer: B**
**Explanation:** Nitro Enclaves provide provable isolation — the enclave has no persistent storage, no interactive access, and no external networking. Even the parent EC2 instance can't access the enclave's memory. CloudHSM provides customer-exclusive key control (AWS cannot access HSM contents). KMS external key store (XKS) means encryption keys are held entirely by the customer — AWS services request encryption/decryption from the customer's key store but never see the key material. Option A — standard encryption allows AWS service decryption during processing. Option C moves hardware but doesn't address software-level isolation. Option D is not a technical control.

---

### Question 52
A company's security team needs to detect when IAM policies are changed in ways that could weaken security (e.g., adding wildcard permissions, removing MFA conditions, granting public access). What should the architect implement?

A) Review IAM policies monthly using the IAM console.  
B) Implement real-time IAM policy change detection: (1) CloudTrail captures all IAM API calls (PutUserPolicy, AttachRolePolicy, CreatePolicy, etc.). (2) EventBridge rules match IAM policy modification events and trigger Lambda. (3) Lambda function uses IAM Access Analyzer's ValidatePolicy API to check the new policy for security issues (wildcard actions, no condition keys, public access). (4) If issues are found, Lambda sends an alert to the security team via SNS and optionally reverts the change using the IAM API. (5) AWS Config rule custom-iam-policy-check evaluates policies against organizational security standards.  
C) Use GuardDuty to detect IAM policy changes.  
D) Block all IAM policy changes except from the security team.

**Correct Answer: B**
**Explanation:** Real-time detection catches risky policy changes as they happen. The Lambda function leverages IAM Access Analyzer's policy validation to programmatically check for security anti-patterns (wildcards, missing conditions). Automated reversion prevents the risky policy from being active for long. Config rules provide continuous compliance monitoring. Option A is too infrequent. Option C — GuardDuty doesn't specifically detect permissive policy changes. Option D prevents legitimate operations.

---

### Question 53
A company wants to implement a zero-trust architecture for their database layer. Database access should require identity verification for every connection, and all database queries should be logged for audit. The database is Amazon Aurora MySQL. What should the architect implement?

A) Use standard MySQL username/password authentication.  
B) Implement zero-trust database access: (1) Enable RDS IAM authentication — applications and administrators authenticate using IAM credentials (temporary tokens), not static passwords. (2) Enable SSL/TLS enforcement (rds.force_ssl parameter) for all connections. (3) Enable Aurora Database Activity Streams (DAS) for comprehensive query-level audit logging, streamed to Kinesis and then to S3/OpenSearch for analysis. (4) Use AWS PrivateLink (RDS VPC endpoint) so database connections stay within the VPC. (5) Implement fine-grained MySQL grants per IAM role (each service gets minimum required table/column permissions). (6) Use RDS Proxy for connection management with IAM authentication.  
C) Use security groups as the sole access control.  
D) Deploy a database proxy on EC2 for authentication.

**Correct Answer: B**
**Explanation:** Zero-trust database access means every connection is authenticated (IAM authentication — no static passwords), encrypted (TLS enforcement), authorized (fine-grained MySQL grants), and audited (Activity Streams). IAM authentication uses temporary tokens that expire (unlike passwords). Activity Streams provide immutable, comprehensive query audit. RDS Proxy improves connection efficiency while maintaining IAM auth. Option A uses static credentials. Option C is network-level only (not identity-based). Option D adds custom infrastructure.

---

### Question 54
A company needs to protect against supply chain attacks on their Lambda functions. Third-party dependencies in Lambda layers could contain malicious code. What security controls should the architect implement?

A) Trust all dependencies from public registries.  
B) Implement Lambda supply chain security: (1) Use a private artifact repository (CodeArtifact) as a proxy for public registries — scan all packages before approval. (2) Integrate dependency scanning (Snyk, OWASP Dependency-Check) in the CI/CD pipeline to detect known vulnerabilities. (3) Pin all dependency versions (no wildcards/ranges) in package manifests. (4) Use Lambda code signing — sign Lambda deployment packages with AWS Signer. Configure Lambda to reject unsigned code, preventing deployment of tampered functions. (5) Generate and store Software Bill of Materials (SBOM) for all Lambda functions. (6) Use Amazon Inspector Lambda scanning for runtime vulnerability detection.  
C) Minimize dependencies by writing all code from scratch.  
D) Run Lambda functions in a VPC to prevent malicious outbound connections.

**Correct Answer: B**
**Explanation:** Supply chain security requires controlling the dependency pipeline. CodeArtifact as a proxy ensures all packages are scanned before use. Dependency scanning catches known vulnerabilities. Version pinning prevents unexpected changes. Code signing ensures deployment packages haven't been tampered with. SBOM provides visibility into the software supply chain. Inspector provides runtime scanning. Option A is vulnerable to malicious packages. Option C is impractical. Option D doesn't prevent the malicious code from executing.

---

### Question 55
A company operates a SaaS platform and needs to implement security controls that prevent one tenant from accessing another tenant's data. Tenants share the same application infrastructure (ECS, DynamoDB, S3). What technical controls ensure tenant isolation?

A) Use separate DynamoDB tables for each tenant.  
B) Implement multi-layer tenant isolation: (1) DynamoDB — use tenant ID as the partition key prefix and IAM policy conditions (dynamodb:LeadingKeys) to restrict each tenant's access to their own partition. (2) S3 — use separate S3 prefixes per tenant with IAM policy conditions (s3:prefix) restricting access. (3) Application-level — enforce tenant context in every API request (extracted from JWT tenant claim). (4) Encryption — use KMS encryption context with tenant ID for tenant-specific encryption (separate data keys per tenant). (5) Logging — include tenant ID in all log entries for audit. (6) Testing — regularly run penetration tests specifically targeting tenant isolation boundaries.  
C) Rely on application code to filter data by tenant.  
D) Use separate AWS accounts per tenant.

**Correct Answer: B**
**Explanation:** Multi-layer tenant isolation provides defense-in-depth. IAM conditions enforce data access boundaries at the AWS API level (even if application code has a bug). Encryption context ensures data encrypted for one tenant can't be decrypted in another's context. Application-level enforcement adds another layer. Audit logging provides visibility. Penetration testing validates the controls. Option A doesn't scale. Option C is a single layer — application bugs break isolation. Option D is expensive for shared infrastructure SaaS.

---

### Question 56
A company needs to implement real-time threat detection for their EKS clusters. They want to detect compromised containers, privilege escalation attempts, and malicious network activity within the cluster. What should the architect enable?

A) Use CloudWatch Container Insights for security monitoring.  
B) Enable Amazon GuardDuty EKS Protection: (1) EKS Audit Log Monitoring — GuardDuty analyzes Kubernetes audit logs to detect suspicious activities (anonymous authentication, exposed dashboards, privilege escalation attempts, execution in kube-system namespace). (2) EKS Runtime Monitoring — GuardDuty agents on EKS nodes detect runtime threats (reverse shells, cryptocurrency mining, malicious file downloads, DNS queries to C2 domains). (3) Configure EventBridge rules for EKS-specific GuardDuty findings to trigger automated response (e.g., isolate the pod, cordon the node). (4) Enable Kubernetes RBAC audit logging for fine-grained access audit.  
C) Deploy a third-party SIEM agent on each node.  
D) Use Kubernetes Network Policies as the sole security measure.

**Correct Answer: B**
**Explanation:** GuardDuty EKS Protection provides comprehensive threat detection at both the Kubernetes API level (audit logs) and the container runtime level (system calls, network activity). It detects Kubernetes-specific attacks (RBAC exploitation, exposed dashboards) and general threats (crypto mining, C2 communication). Automated response via EventBridge limits the blast radius. Option A provides metrics, not threat detection. Option C adds operational complexity. Option D is preventive only (no detection).

---

### Question 57
A company is implementing a Disaster Recovery plan and needs to ensure that their DR site maintains the same security controls as the primary site. Security configurations drift between the sites. What should the architect implement to prevent security drift?

A) Manually configure security settings in the DR site to match the primary.  
B) Implement automated security configuration management: (1) Define all security configurations as Infrastructure as Code (CloudFormation/Terraform) stored in CodeCommit. (2) Deploy identical security configurations to both sites using CodePipeline. (3) AWS Config conformance packs applied to both sites to continuously monitor compliance with the same rules. (4) Security Hub aggregation across both Regions to show a unified compliance view. (5) CloudFormation drift detection to identify undocumented changes. (6) Automated testing (Config rules + custom Lambda checks) that runs after every deployment to validate security parity between sites.  
C) Accept that DR sites may have different security postures.  
D) Use AWS Backup as the sole DR mechanism.

**Correct Answer: B**
**Explanation:** IaC ensures identical security configurations by deploying from the same code to both sites. Config conformance packs continuously validate that both sites meet the same compliance standards. Security Hub aggregation provides unified visibility. Drift detection catches manual changes. Automated testing validates parity after deployments. This ensures the DR site is always security-equivalent to the primary. Option A leads to drift. Option C creates compliance gaps. Option D — Backup handles data, not security configuration.

---

### Question 58
A company needs to implement a secure remote access solution for administrators to manage AWS resources and on-premises servers. The solution should not require a VPN, should support session recording, and should use their existing Active Directory for authentication. What should the architect implement?

A) Deploy an OpenVPN server on EC2 for all administrative access.  
B) Use AWS Systems Manager Session Manager for secure remote access: (1) No VPN, bastion hosts, or open SSH/RDP ports required — Session Manager uses the SSM agent on instances. (2) Integrate with IAM Identity Center (SSO) backed by Active Directory for authentication. (3) Enable session logging — all session activity is recorded to S3 and CloudWatch Logs. (4) Use IAM policies to restrict which users can start sessions on which instances. (5) Configure session document to enforce idle timeout and maximum session duration. (6) For on-premises servers, install the SSM agent and register them as hybrid managed nodes.  
C) Open SSH (port 22) and RDP (port 3389) on all instances and use security groups to restrict source IPs.  
D) Use AWS Client VPN with Active Directory integration.

**Correct Answer: B**
**Explanation:** Session Manager provides agent-based access without opening inbound ports (the agent connects outbound to the SSM service). AD integration through Identity Center provides corporate authentication. Session recording captures all keystrokes for audit. IAM policies provide fine-grained access control. Idle timeouts enforce security. Hybrid managed nodes extend the same access to on-premises servers. Option A requires managing VPN infrastructure and doesn't provide session recording. Option C exposes ports to potential attack. Option D requires VPN (the question specifies no VPN).

---

### Question 59
A company has identified a vulnerability in their custom AMI that is deployed across 500 EC2 instances in multiple accounts. They need to patch all instances without significant downtime. What is the most efficient remediation approach?

A) Manually SSH into each instance and apply the patch.  
B) Use a multi-pronged remediation approach: (1) Create a patched AMI using EC2 Image Builder with the security fix. (2) Use AWS Systems Manager Patch Manager with a custom patch baseline for immediate vulnerability remediation on running instances. (3) Deploy the patch across all 500 instances using SSM Run Command with rate-limited execution (concurrency controls) to prevent mass outage. (4) For instances behind auto-scaling groups, perform a rolling update with the new AMI — update the launch template and initiate an instance refresh. (5) Use AWS Config rules to verify patch compliance across all instances. (6) Update the golden AMI pipeline to include the fix for all future instances.  
C) Terminate all 500 instances and relaunch with the patched AMI.  
D) Wait for the monthly patching cycle to address the vulnerability.

**Correct Answer: B**
**Explanation:** This approach addresses both running instances and future launches. SSM Patch Manager with Run Command applies the fix to all 500 instances remotely with rate limiting (e.g., 10% at a time) to prevent mass disruption. Auto-scaling group instance refresh gradually replaces instances with the patched AMI. Config rules verify compliance. Image Builder updates the golden AMI pipeline. Option A doesn't scale. Option C causes significant downtime across 500 instances. Option D leaves a known vulnerability unpatched for weeks.

---

### Question 60
A company is implementing a secrets detection solution to prevent developers from committing secrets (API keys, passwords, tokens) to their code repositories. What should the architect deploy?

A) Train developers not to commit secrets.  
B) Implement multi-layer secrets detection: (1) Pre-commit hooks (git-secrets, talisman) that scan code for secret patterns before commits are created. (2) Amazon CodeGuru Reviewer Secrets Detector in the CI/CD pipeline — scans code during pull request reviews for hardcoded secrets and AWS credentials. (3) If a secret is detected in CodeCommit, trigger a Lambda function via EventBridge that notifies the developer and security team, and initiates automatic rotation of the detected secret via Secrets Manager. (4) AWS Secrets Manager combined with AWS Config to detect secrets that aren't stored in Secrets Manager. (5) GitHub Advanced Security or similar tools for public repository scanning.  
C) Use .gitignore files to prevent secret files from being committed.  
D) Encrypt all code repositories.

**Correct Answer: B**
**Explanation:** Multi-layer detection catches secrets at different stages: pre-commit hooks prevent secrets from being committed locally. CodeGuru catches secrets during code review. Lambda-based response handles secrets that slip through. Automatic rotation minimizes the window of exposure for detected secrets. This addresses the human error of committing secrets comprehensively. Option A — training helps but doesn't prevent mistakes. Option C only blocks files, not secrets in code. Option D — encrypted repos don't prevent secrets in code.

---

### Question 61
A company needs to implement a secure architecture for processing payments. They need to tokenize credit card numbers so that the application stores tokens instead of actual card numbers. The tokenization solution must be PCI DSS compliant. What should the architect design?

A) Store credit card numbers encrypted in DynamoDB and call them "tokens."  
B) Implement a tokenization service: (1) Deploy the tokenization logic in a Lambda function within a dedicated CDE VPC (PCI-scoped). (2) Use Amazon DynamoDB as the token vault — maps tokens to encrypted card numbers. (3) Encrypt card numbers using KMS customer-managed keys (envelope encryption) before storing. (4) The token is a randomly generated, non-reversible identifier (format-preserving to match card number length for system compatibility). (5) Only the tokenization service has access to the KMS key and token vault. (6) Application services use tokens for downstream processing — they never see the actual card number. (7) Detokenization (reversing to the actual card number) requires separate IAM authorization with multi-factor approval.  
C) Use a hash of the credit card number as the token.  
D) Store the last four digits of the card number as the token.

**Correct Answer: B**
**Explanation:** Tokenization replaces sensitive card numbers with non-sensitive tokens, reducing PCI DSS scope for all systems that handle tokens instead of card numbers. The token vault in the CDE securely maps tokens to encrypted card data. Format-preserving tokens maintain compatibility with systems expecting card number format. IAM controls restrict detokenization to authorized services. KMS encryption protects the card data at rest. Option A — encryption isn't tokenization (the encrypted data is still card data). Option C — hash-based tokens can be reversed with rainbow tables. Option D exposes partial card data.

---

### Question 62
A company's CloudTrail logs show that someone used the root user credentials to log into the management account at 3 AM. The company policy prohibits root user usage. The root user has MFA enabled. What should the investigation include?

A) Ignore the login since MFA was required.  
B) Investigate thoroughly: (1) Review CloudTrail for all actions taken during the root user session — focus on IAM changes, billing changes, Organization configuration changes, and account-level settings. (2) Check if the root MFA device was compromised — review if the MFA device was changed or disabled during the session. (3) Identify the source IP from CloudTrail — determine if it's a known corporate IP or external. (4) Review CloudTrail for iam:CreateLoginProfile, iam:UpdateLoginProfile events that might indicate password changes. (5) Check if any new IAM users or roles were created (backdoor accounts). (6) Immediately rotate the root password, MFA device, and all root-associated credentials. (7) Enable AWS Organizations root user access management to prevent root console access.  
C) Change the root password and move on.  
D) Disable the root user account.

**Correct Answer: B**
**Explanation:** Unauthorized root user access is a critical security incident — root has unlimited permissions. Even with MFA, the session could indicate credential compromise (stolen password + MFA device/TOTP seed). CloudTrail analysis reveals what was done (IAM changes, billing modifications, Organization changes). Source IP analysis helps determine if it was an insider or external attacker. Credential rotation prevents further access. Root access management in Organizations can restrict root usage. Option A dismisses a critical incident. Option C doesn't investigate the scope. Option D — root user cannot be disabled.

---

### Question 63
A company operates a public API that serves 10,000 unique clients. They want to implement API security that includes authentication, rate limiting per client, input validation, and protection against common web attacks. What comprehensive API security architecture should the architect design?

A) Deploy the API without authentication and rely on backend security.  
B) Implement layered API security: (1) Amazon API Gateway with Cognito User Pool authorizer or Lambda authorizer for JWT-based authentication. (2) API Gateway usage plans with API keys per client for rate limiting and throttling. (3) API Gateway request validation (JSON Schema) for input validation — reject malformed requests before they reach the backend. (4) AWS WAF attached to API Gateway with managed rule groups (SQL injection, XSS, Bot Control). (5) API Gateway resource policy to restrict access by IP or VPC (for internal APIs). (6) mTLS with custom domain names for certificate-based client authentication. (7) CloudTrail logging for all API Gateway management events.  
C) Use an ALB with IP-based restrictions as the API gateway.  
D) Implement all security in the backend Lambda functions.

**Correct Answer: B**
**Explanation:** API security requires defense at the edge: Authentication (Cognito/JWT) verifies client identity. Rate limiting (usage plans) prevents abuse. Input validation (JSON Schema) catches malformed requests early. WAF protects against application attacks. Resource policies restrict access origins. mTLS provides strong client authentication. Logging enables audit and forensics. Each layer addresses different attack vectors. Option A exposes the API completely. Option C lacks authentication and input validation. Option D moves all security burden to the application.

---

### Question 64
A company needs to ensure that their AWS environment meets SOC 2 Type II compliance requirements. They need continuous evidence collection, control monitoring, and audit-ready reports. What should the architect implement?

A) Collect evidence manually before each audit.  
B) Deploy AWS Audit Manager: (1) Enable the SOC 2 framework in Audit Manager. (2) Audit Manager automatically maps controls to AWS resources and collects evidence (Config rule evaluations, CloudTrail events, Security Hub findings). (3) Evidence is collected continuously and stored in an S3 assessment report bucket. (4) Configure custom controls for organization-specific requirements. (5) Generate assessment reports for auditors at any time. (6) Complement with AWS Config conformance packs for the SOC 2 operational best practices standard. (7) Use Security Hub for continuous security monitoring aligned with SOC 2 trust service criteria.  
C) Use AWS Artifact to download SOC 2 reports and present them as the company's compliance.  
D) Implement CloudWatch dashboards as compliance evidence.

**Correct Answer: B**
**Explanation:** Audit Manager automates evidence collection mapped to SOC 2 controls — it continuously gathers evidence from Config, CloudTrail, and Security Hub. Assessment reports are generated on demand with all evidence organized by control. This dramatically reduces audit preparation effort. Config conformance packs provide additional continuous compliance checks. Option A is time-consuming and error-prone. Option C — AWS's SOC 2 report covers AWS infrastructure, not your application's compliance. Option D — dashboards aren't structured compliance evidence.

---

### Question 65
A company is implementing a secure architecture for their IoT fleet of 100,000 devices. Devices collect sensor data and send it to AWS. They need device authentication, secure communication, and protection against compromised devices. What should the architect design?

A) Use a shared API key for all devices.  
B) Implement IoT security at scale: (1) AWS IoT Core with X.509 certificate-based device authentication — each device has a unique certificate provisioned by ACM PCA via fleet provisioning. (2) IoT Core policies define per-device permissions (which MQTT topics a device can publish/subscribe to). (3) TLS 1.2 for all device-to-cloud communication. (4) AWS IoT Device Defender for continuous security auditing (detect devices with expired certificates, overly permissive policies) and anomaly detection (unusual message rates, connection patterns indicating compromise). (5) If a device is compromised, revoke its certificate using the IoT Core certificate API — the device can no longer connect. (6) Implement Just-in-Time Registration (JITR) for automatic device onboarding.  
C) Use username/password authentication for all IoT devices.  
D) Allow all devices to publish to all MQTT topics.

**Correct Answer: B**
**Explanation:** IoT security at scale requires per-device identity (unique certificates), least-privilege policies (device-specific MQTT permissions), encrypted communication (TLS), continuous monitoring (Device Defender), and revocation capability (certificate revocation for compromised devices). Fleet provisioning automates certificate distribution at scale. JITR simplifies onboarding. Option A — shared credentials mean one compromise affects all devices. Option C — passwords are weaker than certificates and harder to manage at scale. Option D allows any device to affect any topic.

---

### Question 66
A company suspects that data is being exfiltrated through DNS queries (DNS tunneling). The attacker is encoding data in DNS query strings to domains they control. How should the architect detect and prevent this?

A) Block all DNS traffic from VPCs.  
B) Implement DNS security: (1) Route 53 Resolver DNS Firewall — create rules blocking known-malicious domains and detecting suspiciously long domain names (characteristic of DNS tunneling). (2) GuardDuty DNS protection — GuardDuty analyzes VPC DNS logs and detects DNS tunneling attempts, connections to known C2 domains, and cryptocurrency mining DNS patterns. (3) Route 53 Resolver query logging — send all DNS queries to CloudWatch Logs for analysis. (4) Custom Lambda function that analyzes DNS logs for tunneling signatures (high query volume to specific domains, unusual subdomain lengths, high entropy in labels). (5) AWS Network Firewall with DNS domain-based stateful rules blocking unauthorized outbound DNS.  
C) Use a third-party DNS filtering service.  
D) Allow only specific DNS servers via NACLs.

**Correct Answer: B**
**Explanation:** DNS tunneling detection requires multiple layers: DNS Firewall blocks known bad domains and suspicious patterns. GuardDuty's ML-based DNS analysis detects tunneling behavior. Query logging provides data for custom analysis. Custom Lambda functions detect specific tunneling signatures (entropy analysis, query volume patterns). Network Firewall can block DNS to unauthorized resolvers. Option A breaks DNS resolution. Option C adds external dependency. Option D doesn't inspect DNS content.

---

### Question 67
A company needs to implement a Privileged Access Management (PAM) solution for their AWS environment. They want to eliminate standing privileged access, require approval for all administrative operations, and record all privileged sessions. What should the architect implement?

A) Use shared admin credentials with MFA.  
B) Implement a comprehensive PAM solution: (1) AWS IAM Identity Center with permission sets — no standing administrative access (baseline permission sets are read-only). (2) Temporary privilege elevation through a custom approval workflow (API Gateway → Lambda → Identity Center API to assign admin permission set). (3) Time-limited sessions (maximum 4 hours). (4) Session recording via Systems Manager Session Manager for all interactive sessions (stored in S3). (5) AWS CloudTrail for all API calls during privileged sessions. (6) Multi-person approval requirement for production access changes. (7) Weekly access review automated report showing all privilege elevations.  
C) Rotate admin passwords monthly.  
D) Restrict admin access to office hours only.

**Correct Answer: B**
**Explanation:** PAM eliminates standing privilege (no one has permanent admin access). The approval workflow ensures that every privilege elevation is intentional and approved. Time limits ensure access expires automatically. Session recording and CloudTrail provide complete audit trails. Multi-person approval prevents single-person abuse. Access review reports identify patterns and anomalies. Option A — shared credentials lack accountability. Option C still maintains standing privilege. Option D doesn't address the core PAM requirements.

---

### Question 68
A company wants to implement a secure configuration baseline for all EC2 instances. Every instance must have: the SSM agent installed, CloudWatch agent configured, specific security patches applied, and host-based firewall rules configured. Non-compliant instances should be automatically remediated. What should the architect use?

A) Manually configure each instance after launch.  
B) Use AWS Systems Manager State Manager: (1) Create SSM Associations that define the desired state (SSM agent version, CloudWatch agent configuration, required patches, firewall rules). (2) State Manager continuously enforces these configurations — if an instance drifts from the desired state, it's automatically remediated. (3) Golden AMI with EC2 Image Builder pre-bakes the baseline configuration. (4) SSM Patch Manager with patch baselines for automated security patching. (5) AWS Config rules (ec2-instance-managed-by-ssm, ec2-managedinstance-patch-compliance-status-check) for compliance monitoring. (6) SSM Inventory to track software and configuration across all instances.  
C) Use user data scripts to configure instances at launch.  
D) Deploy Ansible on a central server for configuration management.

**Correct Answer: B**
**Explanation:** State Manager continuously enforces desired state — it's not just at launch time. If configuration drifts (agent removed, firewall rule changed), State Manager re-applies the configuration. Golden AMI pre-bakes the baseline for fast, consistent launches. Patch Manager handles security patching. Config rules monitor compliance. Inventory provides visibility. This is fully managed and AWS-native. Option A is manual and error-prone. Option C — user data runs only at launch, not continuously. Option D requires managing Ansible infrastructure.

---

### Question 69
A company is migrating to AWS and needs to bring their existing hardware security modules (HSMs) to AWS for regulatory reasons. They require FIPS 140-2 Level 3 validated hardware for key management. What should the architect recommend?

A) Use AWS KMS, which is FIPS 140-2 Level 2 validated.  
B) Deploy AWS CloudHSM, which provides dedicated, single-tenant FIPS 140-2 Level 3 validated HSMs in the AWS cloud. Configure a CloudHSM cluster (minimum 2 HSMs across AZs for high availability). Manage keys through the CloudHSM client and PKCS#11/JCE/CNG interfaces. Integrate with applications using industry-standard cryptographic APIs. For KMS integration, use KMS custom key stores backed by CloudHSM — this allows KMS API compatibility while using CloudHSM for key material storage.  
C) Import their physical HSMs into an AWS data center.  
D) Use AWS KMS with imported key material as an alternative to HSM.

**Correct Answer: B**
**Explanation:** CloudHSM provides FIPS 140-2 Level 3 validation (the highest commonly required level) on dedicated hardware. The customer exclusively controls the HSM — AWS cannot access key material. Multi-AZ clusters provide HA. Industry-standard interfaces (PKCS#11, JCE) ensure application compatibility. KMS custom key store integration provides the convenience of KMS APIs while maintaining CloudHSM's key security. Option A — KMS is Level 2, not Level 3 (though KMS uses Level 3 HSMs internally, the validation is at Level 2). Option C is not possible. Option D — imported key material still stores in KMS, not Level 3 HSM.

---

### Question 70
A company needs to detect and respond to anomalous behavior in their AWS accounts. They want to detect: unusual API call volumes, geographic anomalies (API calls from unusual locations), and resource usage anomalies. What combination of services provides comprehensive anomaly detection?

A) Use CloudWatch Alarms with static thresholds for all metrics.  
B) Deploy multiple anomaly detection services: (1) Amazon GuardDuty for IAM, network, and storage threat detection (unauthorized API calls, unusual credential usage, geographic anomalies). (2) AWS CloudTrail Insights for unusual API call volume and error rate anomalies. (3) CloudWatch Anomaly Detection for resource usage anomalies (CPU, memory, network patterns). (4) Amazon Detective for automated investigation of GuardDuty findings — visual exploration of entity relationships and activity timelines. (5) Security Hub for centralized finding aggregation and prioritization. (6) EventBridge rules for automated response to high-severity findings across all detection services.  
C) Use AWS Config as the sole anomaly detection service.  
D) Deploy Splunk on EC2 for all anomaly detection.

**Correct Answer: B**
**Explanation:** Comprehensive anomaly detection requires multiple services covering different domains: GuardDuty uses threat intelligence and ML for security-specific anomalies. CloudTrail Insights detects unusual API patterns. CloudWatch Anomaly Detection handles operational metrics. Detective provides investigation capability. Security Hub centralizes and prioritizes. EventBridge enables automated response. Each service is specialized for its domain. Option A — static thresholds don't adapt to changing patterns. Option C monitors configuration, not behavior. Option D requires managing infrastructure.

---

### Question 71
A company's security policy requires that all data leaving their AWS VPC to the internet must pass through a web proxy for URL filtering and content inspection. Users access SaaS applications (Salesforce, Office 365) from workstations in the VPC. How should the architect implement this?

A) Deploy Squid proxy on EC2 instances and route all traffic through them.  
B) Deploy a centralized web proxy architecture: (1) AWS Network Firewall in the egress VPC with TLS inspection for HTTPS traffic and HTTP protocol rules for URL filtering. (2) For advanced web proxy features (content inspection, DLP, user-based policies), deploy a third-party web proxy appliance behind a Gateway Load Balancer in the egress VPC. (3) TGW routes all internet-bound traffic from spoke VPCs to the egress VPC. (4) Use GWLB endpoints in spoke VPCs for transparent proxy. (5) SaaS traffic destined for known-good URLs can bypass deep inspection using Network Firewall domain allowlists.  
C) Use CloudFront as a forward proxy for all outbound traffic.  
D) Block all internet access and use AWS PrivateLink for everything.

**Correct Answer: B**
**Explanation:** The centralized proxy architecture inspects all outbound traffic. Network Firewall provides URL filtering and TLS inspection natively. For advanced features (DLP, user-based policies, content categorization), third-party proxies behind GWLB provide enterprise proxy capabilities transparently. TGW ensures all VPC traffic routes through the inspection point. Domain allowlists optimize performance for trusted SaaS traffic. Option A — Squid requires manual HA, scaling, and management. Option C — CloudFront is not a forward proxy. Option D is too restrictive for SaaS access.

---

### Question 72
A company wants to implement automated incident response playbooks for common security incidents. When a specific GuardDuty finding type is detected, the response should be automated with minimal human intervention for the initial containment. What should the architect build?

A) Write a wiki page with response procedures for the security team to follow manually.  
B) Build automated playbooks using Step Functions: (1) EventBridge rules match specific GuardDuty finding types and trigger the corresponding Step Functions state machine. (2) Playbook for compromised EC2: isolate instance → snapshot volumes → capture metadata → notify security team. (3) Playbook for compromised IAM credentials: revoke active sessions → disable access keys → scan CloudTrail for unauthorized activity → notify. (4) Playbook for S3 public access: apply Block Public Access → scan bucket contents with Macie → notify. (5) Each playbook sends notifications at every step via SNS. (6) Store all evidence in a forensic S3 bucket with Object Lock. (7) Create a human decision step for escalation decisions.  
C) Use Lambda alone for all playbooks.  
D) Manually respond to every GuardDuty finding.

**Correct Answer: B**
**Explanation:** Step Functions provides visual, auditable, orchestrated incident response. Different playbooks handle different finding types with appropriate containment actions. Automation reduces response time from hours to seconds. SNS notifications keep the team informed. The human decision step allows escalation for complex scenarios. Object Lock preserves evidence. The visual workflow provides clear audit trail of all actions taken. Option A — manual procedures are slow and inconsistent. Option C — Lambda alone can't orchestrate complex multi-step workflows with branching. Option D is too slow for security incidents.

---

### Question 73
A company is implementing AWS PrivateLink to expose internal services to partner organizations. They need to ensure that only authorized partners can access the service, and the traffic must be encrypted and monitored. What security controls should the architect implement?

A) Create the endpoint service and share the service name publicly.  
B) Implement secured PrivateLink: (1) Create a VPC Endpoint Service backed by NLB. (2) Configure the endpoint service to require acceptance — each partner's endpoint connection request must be manually or programmatically approved. (3) Add specific partner AWS account IDs to the endpoint service's allowed principals list. (4) Enable client IP preservation on the NLB to see the originating partner IP. (5) NLB listener with TLS termination using ACM certificates for encryption. (6) VPC Flow Logs on the endpoint service's VPC for traffic monitoring. (7) Backend security groups restricting access to only the NLB's IP range. (8) WAF on an ALB behind the NLB for application-layer inspection.  
C) Use VPC peering instead of PrivateLink for partner connectivity.  
D) Expose the service via a public ALB with IP restrictions.

**Correct Answer: B**
**Explanation:** Secured PrivateLink provides multi-layer protection: acceptance requirement prevents unauthorized connections. Allowed principals restrict which accounts can create endpoints. Client IP preservation enables partner-specific logging and access control. TLS encrypts traffic. Flow Logs monitor all connections. Security groups restrict backend access. WAF provides application-layer protection. Option A allows anyone to attempt connection. Option C exposes the entire VPC network. Option D uses public internet.

---

### Question 74
A company needs to implement a security monitoring solution that detects when their AWS resources are being used for malicious purposes (e.g., an EC2 instance is being used to send spam, perform DDoS attacks, or serve malware). What should the architect configure?

A) Monitor CloudWatch CPU metrics for unusual activity.  
B) Implement comprehensive abuse detection: (1) Amazon GuardDuty — detects EC2 instances communicating with known malicious IPs, performing DDoS, DNS exfiltration, or cryptocurrency mining. (2) AWS Network Firewall with IDS rules that detect outbound malicious traffic patterns (spam, scanning, exploit traffic). (3) VPC Flow Logs analyzed by Amazon Detective for unusual outbound traffic volume and patterns. (4) Amazon SES reputation monitoring if the instance sends email. (5) AWS Abuse notification handling — configure an SNS topic that receives abuse notifications from AWS and triggers automated investigation. (6) GuardDuty finding types: UnauthorizedAccess:EC2/MaliciousIPCaller, Recon:EC2/PortProbeUnprotectedPort, CryptoCurrency:EC2/BitcoinTool.  
C) Rely on AWS to detect and notify about abuse.  
D) Deploy antivirus on all EC2 instances.

**Correct Answer: B**
**Explanation:** Outbound abuse detection requires monitoring for multiple attack types. GuardDuty uses threat intelligence and ML to detect known malicious communication patterns. Network Firewall with IDS rules detects outbound exploit traffic. Flow Logs + Detective identify unusual traffic volumes and patterns. SES reputation monitoring catches spam. AWS Abuse handling automates response to AWS notifications. Option A — CPU metrics alone don't indicate abuse. Option C — AWS notifications come after abuse is detected by external parties (too late). Option D — antivirus helps but doesn't detect network-level abuse patterns.

---

### Question 75
A company is implementing a comprehensive security architecture for a new application. They want to ensure that security is embedded throughout the application lifecycle — from design to deployment to operations. What should the architect recommend as an overall security strategy?

A) Implement security at the end of the development cycle.  
B) Implement a DevSecOps approach with security at every stage: (1) Design — threat modeling (STRIDE), security architecture review, data classification. (2) Development — IDE security plugins (SonarQube), pre-commit hooks for secrets detection, secure coding training. (3) Build — SAST with CodeGuru, dependency scanning, container image scanning (ECR/Inspector), IaC scanning (cfn-nag). (4) Test — DAST testing, penetration testing, contract testing for API security. (5) Deploy — CodePipeline with security approval gates, deployment to isolated environments, blue/green with security verification. (6) Operate — GuardDuty, Security Hub, Config for continuous monitoring. Automated incident response via Step Functions. (7) Feedback — security findings fed back into development backlog. Retrospectives after incidents. (8) Compliance — Audit Manager for continuous compliance evidence collection.  
C) Hire a penetration testing firm to test once a year.  
D) Buy a comprehensive security product that handles everything.

**Correct Answer: B**
**Explanation:** DevSecOps embeds security into every phase of the application lifecycle rather than treating it as a gate at the end. Each phase has specific security activities and tools: threat modeling prevents design flaws, SAST catches code vulnerabilities, image scanning prevents vulnerable deployments, continuous monitoring detects runtime threats, and incident response handles breaches. The feedback loop ensures lessons learned improve future development. This is the industry best practice for modern application security. Option A — late-cycle security is expensive to fix. Option C — annual testing misses 364 days of changes. Option D — no single product covers the entire lifecycle.

---

## Answer Key

| # | Answer | # | Answer | # | Answer | # | Answer | # | Answer |
|---|--------|---|--------|---|--------|---|--------|---|--------|
| 1 | B | 16 | B | 31 | B | 46 | B | 61 | B |
| 2 | B | 17 | B | 32 | B | 47 | B | 62 | B |
| 3 | B | 18 | B | 33 | B | 48 | B | 63 | B |
| 4 | B | 19 | A,B,D | 34 | B | 49 | B | 64 | B |
| 5 | A,B,D | 20 | B | 35 | B | 50 | A,B,C | 65 | B |
| 6 | B | 21 | B | 36 | B | 51 | B | 66 | B |
| 7 | B | 22 | B | 37 | B | 52 | B | 67 | B |
| 8 | B | 23 | B | 38 | B | 53 | B | 68 | B |
| 9 | B | 24 | B | 39 | B | 54 | B | 69 | B |
| 10 | B | 25 | B | 40 | B | 55 | B | 70 | B |
| 11 | B | 26 | B | 41 | B | 56 | B | 71 | B |
| 12 | B | 27 | B | 42 | B | 57 | B | 72 | B |
| 13 | B | 28 | B | 43 | B | 58 | B | 73 | B |
| 14 | B | 29 | B | 44 | B | 59 | B | 74 | B |
| 15 | B | 30 | B | 45 | B | 60 | B | 75 | B |

---

### Domain Distribution
- **Domain 1 — Organizational Complexity:** Q1, Q7, Q8, Q10, Q11, Q13, Q14, Q20, Q22, Q26, Q37, Q43, Q45, Q48, Q55, Q57, Q64, Q67, Q73, Q75 (20)
- **Domain 2 — New Solutions:** Q4, Q6, Q9, Q12, Q15, Q17, Q21, Q24, Q25, Q27, Q28, Q29, Q30, Q35, Q39, Q47, Q51, Q53, Q56, Q61, Q65, Q66 (22)
- **Domain 3 — Continuous Improvement:** Q2, Q5, Q19, Q23, Q36, Q38, Q42, Q46, Q50, Q52, Q62 (11)
- **Domain 4 — Migration & Modernization:** Q3, Q18, Q31, Q32, Q40, Q54, Q58, Q59, Q69 (9)
- **Domain 5 — Cost Optimization:** Q16, Q33, Q34, Q41, Q44, Q49, Q60, Q63, Q68, Q70, Q71, Q72, Q74 (13)
