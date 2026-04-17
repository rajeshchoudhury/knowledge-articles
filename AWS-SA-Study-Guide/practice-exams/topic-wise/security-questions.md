# Security Services Question Bank

**AWS Solutions Architect Associate (SAA-C03) — Topic-Wise Practice**
**Total Questions: 30**

---

### Question 1
A company needs to encrypt data at rest in S3, DynamoDB, and EBS. They want to use a single encryption key managed by AWS, with the ability to audit key usage. They do NOT need to manage key material. What should the architect recommend?

A) SSE-S3 for all services
B) AWS KMS with an AWS managed key
C) AWS KMS with a customer managed key (CMK)
D) AWS CloudHSM

**Answer: C**
**Explanation:** A KMS customer managed key (CMK) provides centralized key management, audit capability via CloudTrail, and can be used across S3 (SSE-KMS), DynamoDB, and EBS. AWS managed keys (B) also work but don't allow custom key policies or rotation control. SSE-S3 (A) only applies to S3 and doesn't provide audit trails for key usage. CloudHSM (D) is for when you need to manage your own key material.

---

### Question 2
A company has a regulatory requirement that encryption keys must be stored in a FIPS 140-2 Level 3 certified hardware security module and the company must have exclusive, single-tenant access. What should the architect recommend?

A) AWS KMS with a customer managed key
B) AWS CloudHSM
C) SSE-S3
D) AWS Secrets Manager

**Answer: B**
**Explanation:** AWS CloudHSM provides dedicated, single-tenant HSMs that are FIPS 140-2 Level 3 certified. The customer has exclusive control over the keys. KMS (A) is multi-tenant and FIPS 140-2 Level 2 (or Level 3 in some configurations, but shared). SSE-S3 (C) is AWS-managed. Secrets Manager (D) stores secrets, not encryption keys in HSMs.

---

### Question 3
A web application hosted on AWS is experiencing a DDoS attack at the network layer (Layer 3/4). The company wants automatic DDoS protection with no additional cost for their existing AWS resources. What protection is already in place?

A) AWS Shield Advanced
B) AWS WAF
C) AWS Shield Standard
D) Amazon GuardDuty

**Answer: C**
**Explanation:** AWS Shield Standard is automatically enabled for all AWS accounts at no additional cost. It protects against common Layer 3/4 DDoS attacks like SYN floods, UDP reflection, and other network-level attacks. Shield Advanced (A) is a paid service with enhanced protection. WAF (B) protects against Layer 7 attacks. GuardDuty (D) is a threat detection service, not DDoS protection.

---

### Question 4
A company has a web application behind CloudFront and an ALB. They are experiencing HTTP flood attacks (Layer 7 DDoS). They need to create rate-based rules to block offending IPs and get access to a 24/7 DDoS Response Team. What should the architect recommend?

A) AWS Shield Standard and AWS WAF
B) AWS Shield Advanced with AWS WAF integration
C) Amazon GuardDuty with automatic remediation
D) Security groups with IP blocking

**Answer: B**
**Explanation:** AWS Shield Advanced provides enhanced DDoS protection, cost protection, and access to the AWS DDoS Response Team (DRT). When combined with WAF, rate-based rules can automatically block IPs generating excessive requests. Shield Standard (A) doesn't include DRT or cost protection. GuardDuty (C) is for threat detection. Security groups (D) are too slow for dynamic DDoS mitigation.

---

### Question 5
A company needs to detect and alert on unusual API activity in their AWS account, such as cryptocurrency mining, compromised EC2 instances, or unauthorized access attempts. What should the architect enable?

A) AWS CloudTrail
B) Amazon Inspector
C) Amazon GuardDuty
D) AWS Config

**Answer: C**
**Explanation:** Amazon GuardDuty uses machine learning to analyze CloudTrail, VPC Flow Logs, and DNS logs to detect threats like crypto mining, compromised instances, and unauthorized access. CloudTrail (A) logs API calls but doesn't analyze them for threats. Inspector (B) assesses vulnerabilities in instances. Config (C) tracks resource configuration changes.

---

### Question 6
A company stores sensitive PII (personally identifiable information) in S3 buckets across multiple accounts. They need to automatically discover, classify, and protect this sensitive data. What service should the architect recommend?

A) Amazon GuardDuty
B) Amazon Macie
C) AWS Config
D) Amazon Inspector

**Answer: B**
**Explanation:** Amazon Macie uses machine learning to automatically discover, classify, and protect sensitive data (PII, PHI, financial data) stored in S3. It can scan across multiple accounts in an Organization. GuardDuty (A) detects threats. Config (C) tracks resource configurations. Inspector (D) assesses instance vulnerabilities.

---

### Question 7
A company runs EC2 instances and container images in ECR. They need to automatically scan for software vulnerabilities and unintended network exposure. What should the architect use?

A) Amazon GuardDuty
B) Amazon Macie
C) Amazon Inspector
D) AWS Trusted Advisor

**Answer: C**
**Explanation:** Amazon Inspector automatically scans EC2 instances for software vulnerabilities (CVEs) and network reachability issues. It also scans container images in ECR for vulnerabilities. GuardDuty (A) detects threats, not vulnerabilities. Macie (B) scans for sensitive data. Trusted Advisor (D) provides best-practice recommendations but doesn't scan for CVEs.

---

### Question 8
A company wants to centrally view and manage security findings from GuardDuty, Inspector, Macie, Firewall Manager, and IAM Access Analyzer in a single dashboard. What should the architect enable?

A) Amazon Detective
B) AWS Security Hub
C) AWS CloudTrail Insights
D) Amazon CloudWatch Dashboard

**Answer: B**
**Explanation:** AWS Security Hub aggregates security findings from multiple AWS security services and third-party tools into a centralized dashboard. It provides automated compliance checks against standards like CIS and PCI DSS. Detective (A) investigates findings. CloudTrail Insights (C) detects unusual API activity. CloudWatch Dashboards (D) display metrics, not security findings.

---

### Question 9
A company needs to provide user sign-up, sign-in, and access control for their mobile application. Users should be able to sign in with social identity providers (Google, Facebook, Apple). What should the architect use?

A) IAM users for each application user
B) Amazon Cognito User Pools for authentication and Cognito Identity Pools for AWS resource access
C) AWS IAM Identity Center
D) Custom authentication with Lambda and DynamoDB

**Answer: B**
**Explanation:** Cognito User Pools handle user registration, authentication, and federation with social identity providers. Identity Pools provide temporary AWS credentials for accessing AWS services. IAM users (A) are for AWS account management, not application users. Identity Center (C) is for employee SSO. Custom authentication (D) is unnecessary when Cognito provides this natively.

---

### Question 10
A company needs to provision SSL/TLS certificates for their CloudFront distributions and ALBs. They want certificates to be automatically renewed. What is the MOST cost-effective solution?

A) Purchase certificates from a third-party CA and manually install them
B) Use AWS Certificate Manager (ACM) to provision free public certificates
C) Generate self-signed certificates
D) Use AWS Private CA for public-facing websites

**Answer: B**
**Explanation:** ACM provides free public SSL/TLS certificates that are automatically renewed and integrated with CloudFront, ALB, and API Gateway. Third-party certificates (A) cost money and require manual renewal. Self-signed certificates (C) are not trusted by browsers. AWS Private CA (D) is for internal/private certificates and incurs costs.

---

### Question 11
A company encrypts data in S3 using SSE-KMS with a customer managed key. They want to allow a specific IAM role in another account to decrypt the data. What configuration is needed?

A) Share the KMS key ARN with the other account
B) Update the KMS key policy to allow the other account's role to use the key, and add the key's ARN to the role's IAM policy
C) Create a new KMS key in the other account
D) Use SSE-S3 instead, which doesn't have cross-account restrictions

**Answer: B**
**Explanation:** Cross-account KMS access requires both: the KMS key policy must allow the external role/account, AND the external role must have an IAM policy permitting `kms:Decrypt` on the key ARN. Simply sharing the ARN (A) doesn't grant access. Creating a new key (C) can't decrypt existing data. SSE-S3 (D) doesn't provide the same control.

---

### Question 12
A company's application encrypts data before sending it to S3 using an encryption key the application manages. What type of encryption is this?

A) Server-side encryption with S3-managed keys (SSE-S3)
B) Server-side encryption with KMS keys (SSE-KMS)
C) Server-side encryption with customer-provided keys (SSE-C)
D) Client-side encryption

**Answer: D**
**Explanation:** Client-side encryption means the application encrypts data before uploading it to S3. The application manages the encryption keys and process. SSE-S3 (A), SSE-KMS (B), and SSE-C (C) are all server-side encryption methods where S3 performs the encryption at rest. With SSE-C (C), you provide the key but S3 does the encryption — the question says the application does the encryption.

---

### Question 13
A company hosts a web application with an ALB. They need to block requests from specific countries and protect against SQL injection. They also need rate limiting. What should the architect configure?

A) Security groups and NACLs for all protections
B) AWS WAF with geo-match rules, SQL injection rules, and rate-based rules attached to the ALB
C) CloudFront geo restriction and a separate WAF for SQL injection
D) Shield Advanced for all protections

**Answer: B**
**Explanation:** AWS WAF provides geo-match conditions (country blocking), managed rule groups for SQL injection, and rate-based rules, all in a single service attached to the ALB. Security groups (A) can't inspect HTTP content or block by country. Using CloudFront + separate WAF (C) adds unnecessary complexity. Shield Advanced (D) is for DDoS, not SQL injection or country blocking.

---

### Question 14
A company has an application that generates KMS API calls for encrypting small amounts of data (< 4 KB). They want to reduce the number of KMS API calls to control costs and reduce latency. What pattern should the architect use?

A) Use SSE-S3 instead of KMS
B) Use envelope encryption — generate a data encryption key (DEK) using KMS and encrypt data locally with the DEK
C) Cache the KMS master key locally
D) Increase the KMS request quota

**Answer: B**
**Explanation:** Envelope encryption calls KMS once to generate a Data Encryption Key (plaintext + encrypted), encrypts data locally with the plaintext DEK, discards the plaintext DEK, and stores the encrypted DEK with the data. This reduces KMS API calls from one-per-encryption to one-per-batch. SSE-S3 (A) doesn't apply to application-level encryption. Caching master keys (C) is a security risk. Increasing quotas (D) doesn't reduce cost.

---

### Question 15
A company wants to ensure that their KMS customer managed key is automatically rotated. What is the rotation frequency for automatic KMS key rotation?

A) Every 30 days
B) Every 90 days
C) Every 365 days (1 year) by default, configurable
D) Automatic rotation is not supported for customer managed keys

**Answer: C**
**Explanation:** AWS KMS supports automatic key rotation for customer managed keys. When enabled, KMS rotates the key material every year (365 days) by default. The key ID remains the same; only the backing key material changes. Previous versions are retained for decryption. Automatic rotation is configurable and can be set to periods between 90 and 2560 days.

---

### Question 16
A company needs to secure their API Gateway endpoint so that only requests with a valid JWT token from their Cognito User Pool are accepted. What should the architect configure?

A) API Gateway Lambda authorizer
B) API Gateway Cognito User Pool authorizer
C) IAM authorization on the API Gateway
D) API keys on the API Gateway

**Answer: B**
**Explanation:** API Gateway natively supports Cognito User Pool authorizers, which validate JWT tokens issued by Cognito. This is the simplest integration. Lambda authorizers (A) are for custom authentication logic. IAM authorization (C) requires AWS credentials, not JWT tokens. API keys (D) are for usage plans and throttling, not authentication.

---

### Question 17
A company hosts a website on EC2 instances behind an ALB. They want to enforce HTTPS and redirect all HTTP requests to HTTPS. Where should this be configured?

A) On each EC2 instance's web server configuration
B) On the ALB listener rules — create an HTTP listener (port 80) that redirects to HTTPS (port 443)
C) In the security group by blocking port 80
D) In Route 53 by creating a redirect record

**Answer: B**
**Explanation:** ALB supports native redirect actions on listener rules. An HTTP listener (port 80) can be configured with a redirect action to HTTPS (port 443). This is the simplest and most efficient approach. Configuring on each instance (A) is redundant if using ALB. Blocking port 80 (C) would reject HTTP requests instead of redirecting them. Route 53 (D) doesn't support HTTP-to-HTTPS redirects.

---

### Question 18
A company needs to encrypt an RDS database. The database is already running in production with data. They realize encryption was not enabled at creation time. What should the architect do?

A) Enable encryption on the existing RDS instance through the console
B) Create an encrypted snapshot of the existing database, then restore a new encrypted instance from the snapshot
C) You cannot encrypt an unencrypted RDS database
D) Use client-side encryption for all future data

**Answer: B**
**Explanation:** RDS encryption can only be enabled at creation time, not on an existing instance. The workaround is: create a snapshot, copy the snapshot with encryption enabled, then restore a new instance from the encrypted snapshot. You cannot directly enable encryption on a running instance (A). While the original instance can't be retroactively encrypted, you can create an encrypted copy (C is too absolute). Client-side encryption (D) doesn't encrypt existing data.

---

### Question 19
A company uses AWS Secrets Manager to store database credentials. They want to ensure that the credentials are rotated every 30 days automatically. The database is an RDS MySQL instance. What should the architect configure?

A) A Lambda function that updates the credentials manually every 30 days
B) Enable automatic rotation in Secrets Manager with a 30-day rotation interval, using the built-in Lambda rotation function for RDS MySQL
C) Use IAM database authentication instead
D) Store credentials in Systems Manager Parameter Store with automatic rotation

**Answer: B**
**Explanation:** Secrets Manager provides built-in Lambda rotation functions for RDS MySQL, PostgreSQL, and other databases. Configuring automatic rotation with a 30-day interval handles everything automatically. Custom Lambda (A) is unnecessary since Secrets Manager has built-in rotation. IAM database authentication (C) is an alternative but doesn't address the question of credential rotation. Parameter Store (D) doesn't have built-in rotation.

---

### Question 20
A company wants to create a private connection between their VPC and KMS that does not traverse the internet. What should the architect configure?

A) A VPN connection to the KMS service
B) A VPC interface endpoint (PrivateLink) for KMS
C) A VPC gateway endpoint for KMS
D) Direct Connect to KMS

**Answer: B**
**Explanation:** VPC interface endpoints (powered by PrivateLink) create a private connection between a VPC and supported AWS services, including KMS. Traffic stays within the AWS network. Gateway endpoints (C) are only available for S3 and DynamoDB. VPN (A) and Direct Connect (D) connect to on-premises, not directly to individual AWS services.

---

### Question 21
A security incident response team needs to investigate a potential breach. They need to analyze relationships between GuardDuty findings, CloudTrail logs, and VPC Flow Logs to determine the root cause. What service should the architect recommend?

A) Amazon GuardDuty
B) AWS Security Hub
C) Amazon Detective
D) AWS CloudTrail Insights

**Answer: C**
**Explanation:** Amazon Detective automatically collects log data from GuardDuty, CloudTrail, and VPC Flow Logs, and uses graph models to help analyze and visualize security issues for root cause investigation. GuardDuty (A) detects threats but doesn't investigate them. Security Hub (B) aggregates findings. CloudTrail Insights (D) detects unusual API patterns.

---

### Question 22
A company needs to deploy a WAF configuration consistently across all ALBs and CloudFront distributions in multiple accounts within their Organization. What should the architect use?

A) Deploy WAF rules manually in each account
B) Use AWS Firewall Manager to centrally configure and manage WAF rules across accounts
C) Use CloudFormation StackSets to deploy WAF rules
D) Use SCPs to enforce WAF attachment

**Answer: B**
**Explanation:** AWS Firewall Manager centrally configures and manages WAF rules, Shield Advanced protections, and security group policies across all accounts in an AWS Organization. It automatically applies policies to new resources. Manual deployment (A) is error-prone. StackSets (C) can deploy rules but don't auto-apply to new resources. SCPs (D) can restrict actions but can't configure WAF rules.

---

### Question 23
A company has an S3 bucket that stores sensitive data. They want to ensure that any access to the bucket from outside the VPC is denied, regardless of who is making the request. What should the architect configure?

A) A bucket policy with a condition `aws:SourceVpc` matching their VPC ID
B) A VPC endpoint policy for S3
C) An IAM policy denying S3 access without VPC conditions
D) S3 Block Public Access

**Answer: A**
**Explanation:** A bucket policy with the condition `aws:SourceVpc` restricts access to only requests originating from the specified VPC (via a VPC endpoint). Any request from outside the VPC is denied. VPC endpoint policies (B) restrict what can be accessed through the endpoint but don't restrict the bucket itself. IAM policies (C) are per-user, not per-bucket. Block Public Access (D) blocks anonymous access but not authenticated access from outside the VPC.

---

### Question 24
A company is using AWS KMS and wants to import their own key material instead of having KMS generate it. What is a limitation of imported key material in KMS?

A) Imported key material cannot be used for S3 encryption
B) Imported key material does not support automatic key rotation; you must manually rotate by creating a new key and re-pointing the alias
C) Imported key material provides the same features as AWS-generated key material
D) Imported key material is automatically backed up by AWS

**Answer: B**
**Explanation:** KMS keys with imported key material do NOT support automatic key rotation. To rotate, you must create a new CMK, import new key material, and update the key alias. Additionally, imported key material can be set to expire and AWS does not guarantee durability (you must maintain a copy). AWS-generated key material (C) has additional features. AWS backs up AWS-generated keys but not imported material (D).

---

### Question 25
A company uses Cognito User Pools for authentication. They want to allow users who sign in to also access S3 and DynamoDB directly from their mobile app using temporary AWS credentials. What additional Cognito component is needed?

A) Cognito Sync
B) Cognito Identity Pools (Federated Identities)
C) Cognito Lambda Triggers
D) Cognito Hosted UI

**Answer: B**
**Explanation:** Cognito Identity Pools exchange tokens from Cognito User Pools (or other identity providers) for temporary AWS credentials via STS. These credentials allow direct access to AWS services like S3 and DynamoDB from the mobile app. Cognito Sync (A) is for data synchronization. Lambda Triggers (C) customize authentication flows. Hosted UI (D) provides a sign-in web interface.

---

### Question 26
A company has enabled AWS Config and wants to ensure that all EBS volumes are encrypted. If a non-encrypted volume is detected, it should be automatically encrypted. What should the architect configure?

A) AWS Config rule `encrypted-volumes` with manual remediation
B) AWS Config rule `encrypted-volumes` with automatic remediation using SSM Automation to create an encrypted copy and replace the original
C) A Lambda function that runs hourly to check for unencrypted volumes
D) An SCP that denies creation of unencrypted volumes

**Answer: B**
**Explanation:** AWS Config's `encrypted-volumes` managed rule detects non-compliant (unencrypted) volumes. Automatic remediation via SSM Automation can create an encrypted snapshot, create an encrypted volume from it, and replace the original. Manual remediation (A) requires human intervention. Lambda (C) is a custom solution. SCPs (D) prevent creation but don't remediate existing volumes.

---

### Question 27
A company has a KMS key that must only be used by specific IAM roles and must never be deleted without a 30-day waiting period. What controls should the architect implement?

A) KMS key policy restricting usage to specific IAM role ARNs and setting the key deletion waiting period to 30 days
B) IAM policies on the roles allowing KMS access
C) CloudTrail monitoring of KMS key usage
D) AWS Config rule for KMS key compliance

**Answer: A**
**Explanation:** The KMS key policy is the primary access control mechanism. It should explicitly list the allowed IAM role ARNs and deny access to others. KMS requires a waiting period (7-30 days) before key deletion, which should be set to 30 days. IAM policies (B) grant access but the key policy must also allow it. CloudTrail (C) and Config (D) monitor but don't enforce access control.

---

### Question 28
A company runs a web application that uses cookies. They want to prevent cross-site scripting (XSS) attacks and ensure cookies are only transmitted over HTTPS. What should the architect implement at the application level?

A) AWS WAF XSS rules only
B) Set `HttpOnly`, `Secure`, and `SameSite` cookie flags, and deploy AWS WAF with XSS managed rule group
C) Use SSL/TLS certificates on the ALB
D) Enable CloudFront with HTTPS only

**Answer: B**
**Explanation:** A defense-in-depth approach combines application-level protections (cookie flags: `HttpOnly` prevents JavaScript access, `Secure` ensures HTTPS-only transmission, `SameSite` prevents CSRF) with infrastructure protection (WAF XSS rules block malicious input). WAF alone (A) doesn't protect cookies. SSL/TLS (C) and CloudFront HTTPS (D) encrypt transport but don't prevent XSS.

---

### Question 29
A company is building a serverless application with API Gateway and Lambda. They need to authorize API requests using custom business logic that validates tokens against their own user database. What should the architect configure?

A) API Gateway IAM authorization
B) API Gateway Cognito authorizer
C) API Gateway Lambda authorizer (formerly custom authorizer)
D) API key validation

**Answer: C**
**Explanation:** A Lambda authorizer allows custom authorization logic — the Lambda function receives the token, validates it against the custom user database, and returns an IAM policy allowing or denying access. IAM authorization (A) requires AWS credentials. Cognito authorizer (B) works with Cognito User Pools. API keys (D) are for usage plans, not authentication.

---

### Question 30
A company wants to enforce that all data written to DynamoDB is encrypted with a specific customer managed KMS key. If any table is created without this encryption configuration, it should be flagged as non-compliant. What should the architect configure?

A) A DynamoDB table-level setting that enforces encryption
B) AWS Config custom rule that checks if DynamoDB tables use the specified KMS key for encryption
C) An SCP that denies `dynamodb:CreateTable` without encryption parameters
D) IAM policies that require encryption condition keys

**Answer: B**
**Explanation:** An AWS Config custom rule (or a managed rule combined with custom logic) can evaluate whether DynamoDB tables use the specific CMK for encryption and flag non-compliant tables. DynamoDB tables are encrypted by default with an AWS owned key, so you need to check that the specific CMK is used. SCPs (C) can enforce conditions but are complex for this. IAM policies (D) don't have DynamoDB encryption condition keys.

---

*End of Security Services Question Bank*
