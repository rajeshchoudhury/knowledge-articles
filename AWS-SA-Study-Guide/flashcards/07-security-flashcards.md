# Security Services Flashcards

## AWS Solutions Architect Associate (SAA-C03) — Deck 7 of 9

---

### Card 1
**Q:** What are the types of KMS keys?
**A:** **AWS Owned Keys** – managed entirely by AWS; used by services internally; free; you have no control or visibility (e.g., SSE-S3 key). **AWS Managed Keys** – created and managed by AWS for your account; named `aws/<service>` (e.g., `aws/s3`); auto-rotated every year; visible in KMS console but you can't manage rotation or policies. **Customer Managed Keys (CMK)** – created and managed by you; full control over key policy, rotation (annual, optional), enable/disable, deletion; costs $1/month + API call charges.

---

### Card 2
**Q:** What are the key KMS API operations?
**A:** **Encrypt** – encrypt up to 4 KB of data directly with a KMS key. **Decrypt** – decrypt ciphertext that was encrypted with a KMS key. **GenerateDataKey** – returns a plaintext data key AND its encrypted copy (for envelope encryption). **GenerateDataKeyWithoutPlaintext** – returns only the encrypted data key (for later use). **ReEncrypt** – re-encrypts ciphertext from one key to another without exposing plaintext. **CreateGrant** – delegate KMS key usage to other principals temporarily.

---

### Card 3
**Q:** What is envelope encryption?
**A:** Envelope encryption is the practice of encrypting data with a **data key**, then encrypting the data key with a **master key** (KMS key). Process: 1) Call `GenerateDataKey` → receive plaintext data key + encrypted data key. 2) Encrypt data locally with the plaintext data key. 3) Store the encrypted data + encrypted data key together. 4) Discard the plaintext data key. To decrypt: decrypt the data key using KMS → use the plaintext data key to decrypt the data locally. This avoids sending large data to KMS (4 KB limit).

---

### Card 4
**Q:** Why is envelope encryption necessary?
**A:** KMS can only encrypt/decrypt up to **4 KB** of data directly. For larger data (files, database records, etc.), you must use envelope encryption: generate a data key via KMS, encrypt the data locally with the data key, and store the encrypted data key alongside. This is how the AWS Encryption SDK, S3 SSE-KMS, and EBS encryption work under the hood. Benefits: reduces KMS API calls, avoids network transfer of large data to KMS, and enables client-side encryption.

---

### Card 5
**Q:** What is KMS key rotation?
**A:** **Automatic rotation** – for customer managed keys, you can enable annual automatic rotation. AWS generates new key material yearly but keeps the old key material for decrypting old data. The key ID and ARN stay the same. Only the backing key changes. AWS managed keys rotate every year automatically. **Manual rotation** – create a new KMS key and update applications to use it; use aliases to abstract the key ID and simplify rotation. Imported key material does not support automatic rotation — you must rotate manually.

---

### Card 6
**Q:** What is a KMS key policy?
**A:** A key policy is a resource-based policy that controls access to a KMS key. Every KMS key has one. The **default key policy** grants the root account full access (allowing IAM policies to manage permissions). Without this default, IAM policies alone cannot grant KMS access. Custom key policies can: grant cross-account access, restrict usage to specific services or conditions, delegate administration. Key policies + IAM policies + grants together determine who can use the key.

---

### Card 7
**Q:** How do you grant cross-account access to a KMS key?
**A:** Two steps: 1) The KMS **key policy** in Account A must allow the principal (user/role) or account in Account B. 2) The **IAM policy** in Account B must grant the user/role permission to use the KMS key. Both are required. Alternatively, the key policy alone can grant access to a specific IAM role/user in Account B using the full ARN. For services like S3 or EBS that use KMS, the service principal and the cross-account principal both need appropriate KMS permissions.

---

### Card 8
**Q:** What is AWS CloudHSM?
**A:** CloudHSM provides **dedicated hardware security modules** (HSMs) in your VPC for cryptographic operations. You manage the keys (AWS cannot access them). FIPS 140-2 **Level 3** validated (KMS is Level 2). Supports symmetric and asymmetric encryption, digital signing, and hashing. CloudHSM Client SDK integrates with PKCS#11, JCE, and CNG/KSP. Multi-AZ deployment for HA (cluster of HSMs). Use for: regulatory requirements, SSL/TLS offloading, Oracle TDE, custom key store for KMS.

---

### Card 9
**Q:** What is the difference between KMS and CloudHSM?
**A:** **KMS** – multi-tenant (shared infrastructure), AWS manages the HSMs, FIPS 140-2 Level 2, integrated with 100+ AWS services, symmetric (AES-256) and asymmetric keys, automatic key rotation, pay per API call. **CloudHSM** – single-tenant (dedicated HSM), YOU manage keys (AWS has no access), FIPS 140-2 Level 3, runs in your VPC, supports PKCS#11/JCE/CNG, no automatic key rotation, no native AWS service integration (except via KMS custom key store). Choose CloudHSM for compliance, full key control, or TDE.

---

### Card 10
**Q:** What is the KMS custom key store with CloudHSM?
**A:** A KMS custom key store allows you to use KMS with keys stored in your **CloudHSM cluster** instead of the default KMS key store. KMS keys created in a custom key store use CloudHSM as the backing HSM. Benefits: single-tenant FIPS 140-2 Level 3, full control over key material, KMS API compatibility (works with AWS services that use KMS), audit via CloudTrail + CloudHSM logs. Combine the ease of KMS integration with the security of CloudHSM.

---

### Card 11
**Q:** What is AWS WAF (Web Application Firewall)?
**A:** WAF protects web applications from common exploits at **Layer 7** (HTTP). Deploy on: ALB, API Gateway, CloudFront, AppSync, Cognito User Pool. **Web ACLs** contain rules that inspect HTTP requests. Rule types: IP-based, rate-based (rate limiting), geographic, SQL injection, XSS, custom regex, and **AWS Managed Rules** (pre-built by AWS and Marketplace sellers). Actions: Allow, Block, Count, CAPTCHA. Rules are evaluated in order of priority. Charged per web ACL, per rule, and per million requests.

---

### Card 12
**Q:** What are WAF Managed Rules?
**A:** Managed Rules are pre-configured rule groups maintained by AWS or AWS Marketplace sellers. **AWS Managed Rules**: Core Rule Set (common threats), Known Bad Inputs, SQL Database, Linux/POSIX OS, Windows OS, PHP, WordPress, Amazon IP Reputation List, Anonymous IP List, Bot Control, and Account Takeover Prevention. **Marketplace rules**: from Fortinet, Imperva, F5, etc. You can add managed rules to your web ACL alongside custom rules. They reduce the effort of writing and maintaining rules.

---

### Card 13
**Q:** What is a WAF rate-based rule?
**A:** A rate-based rule counts requests from each IP address and blocks IPs that exceed a threshold within a 5-minute window. Minimum threshold: **100 requests per 5 minutes**. Use for: DDoS protection, brute-force prevention, bot mitigation. You can scope rate-based rules with conditions (e.g., rate-limit only POST requests to `/login`). When the request rate drops below the threshold, the IP is automatically unblocked. More granular than Shield for application-layer rate limiting.

---

### Card 14
**Q:** What is AWS Shield Standard vs. Shield Advanced?
**A:** **Shield Standard** – free, automatic protection for all AWS customers against common Layer 3/4 DDoS attacks (SYN floods, UDP reflection, etc.). Protects CloudFront, Route 53, and all internet-facing resources. **Shield Advanced** – $3,000/month per organization, 1-year commitment. Adds: real-time attack visibility, 24/7 DDoS Response Team (DRT), cost protection (refunds for scaling during DDoS), advanced attack diagnostics, WAF integration (WAF costs included), protection for EC2, ELB, CloudFront, Global Accelerator, Route 53. Choose Advanced for mission-critical applications.

---

### Card 15
**Q:** What is Amazon GuardDuty?
**A:** GuardDuty is an intelligent **threat detection** service using ML, anomaly detection, and threat intelligence. Data sources: VPC Flow Logs, CloudTrail management and S3 data events, DNS logs, EKS audit logs, RDS login activity, Lambda network activity, EBS volume data (malware). Detects: cryptocurrency mining, unauthorized access, compromised instances, data exfiltration, credential compromises. Findings are classified as Low/Medium/High severity. Integrates with EventBridge for automated remediation. Multi-account support via Organizations. 30-day free trial.

---

### Card 16
**Q:** What is Amazon Inspector?
**A:** Inspector is an automated **vulnerability management** service. It scans: **EC2 instances** (via SSM Agent — OS vulnerabilities, network reachability), **container images in ECR** (on push), and **Lambda functions** (code and dependency vulnerabilities). Uses the CVE database. Produces findings with severity scores (CVSS). Continuously scans — no manual schedules needed. Findings sent to Security Hub and EventBridge. Different from GuardDuty (which detects threats/anomalies, not vulnerabilities).

---

### Card 17
**Q:** What is Amazon Macie?
**A:** Macie is a fully managed data security service that uses ML and pattern matching to discover, classify, and protect **sensitive data in S3**. It identifies PII (names, addresses, credit card numbers, SSNs), financial data, health records, and API keys/credentials. Produces findings in Security Hub. Supports custom data identifiers (regex + keywords). Can be enabled across an Organization. Use for: data privacy compliance (GDPR, HIPAA), auditing S3 for exposed sensitive data, monitoring new data uploads.

---

### Card 18
**Q:** What is AWS Security Hub?
**A:** Security Hub provides a comprehensive view of security alerts and compliance status across your AWS accounts. It **aggregates findings** from GuardDuty, Inspector, Macie, Firewall Manager, IAM Access Analyzer, Systems Manager, and third-party tools into a single dashboard. Runs **automated compliance checks** against standards: CIS AWS Foundations, AWS Foundational Security Best Practices, PCI DSS. Findings use the **AWS Security Finding Format (ASFF)**. Integrates with EventBridge for automated remediation. Multi-account via Organizations.

---

### Card 19
**Q:** What is Amazon Detective?
**A:** Detective makes it easy to **investigate** security findings and identify the root cause of suspicious activities. It automatically collects log data (VPC Flow Logs, CloudTrail, GuardDuty findings, EKS audit logs) and uses ML, statistical analysis, and graph theory to build a linked set of data visualizations. Use flow: GuardDuty detects a threat → you investigate with Detective to understand scope and root cause. Detective answers: "Which resources were involved? What was the timeline? What was the blast radius?"

---

### Card 20
**Q:** What is the relationship between GuardDuty, Inspector, Macie, Security Hub, and Detective?
**A:** **GuardDuty** – threat detection (who's attacking?). **Inspector** – vulnerability assessment (what's vulnerable?). **Macie** – sensitive data discovery (where's the PII?). **Security Hub** – central aggregator and compliance dashboard (unified view of all findings). **Detective** – investigation and root cause analysis (what happened?). Together: Inspector finds vulnerabilities, GuardDuty detects threats, Macie finds exposed data → all feed into Security Hub → Detective helps investigate. Each has a distinct role.

---

### Card 21
**Q:** What is Amazon Cognito User Pools?
**A:** Cognito User Pools provide **sign-up and sign-in** functionality for your application users. Features: username/password auth, social sign-in (Google, Facebook, Apple), SAML/OIDC enterprise federation, MFA, email/phone verification, custom auth flows (Lambda triggers), hosted UI, password policies. Returns **JWT tokens** (ID token, access token, refresh token). Integrates with API Gateway and ALB for authentication. Think "user directory and authentication" — the identity provider for your application.

---

### Card 22
**Q:** What is the difference between Cognito User Pools and Identity Pools?
**A:** **User Pools** – user directory for authentication; returns JWT tokens; handles sign-up, sign-in, MFA, federation; your app validates the token. **Identity Pools** (Federated Identities) – provides **temporary AWS credentials** (STS) to access AWS services directly (S3, DynamoDB); supports authenticated users (from User Pools, Google, SAML) and **guest/unauthenticated** access; maps users to IAM roles. Common pattern: User Pool authenticates the user → Identity Pool exchanges the token for AWS credentials.

---

### Card 23
**Q:** What is the Cognito Identity Pool role mapping?
**A:** Identity Pools assign IAM roles to authenticated and unauthenticated users. **Default role mapping** – all authenticated users get the same IAM role. **Rules-based mapping** – assign different roles based on claims in the user's token (e.g., admins get an admin role). **Token-based mapping** – use the `cognito:preferred_role` claim from User Pool groups. Roles define what AWS resources users can access. Use `${cognito-identity.amazonaws.com:sub}` as a policy variable to scope per-user access (e.g., S3 prefix per user).

---

### Card 24
**Q:** What is AWS Secrets Manager?
**A:** Secrets Manager stores, manages, and **automatically rotates** secrets (database credentials, API keys, tokens). Features: automatic rotation using Lambda (built-in for RDS, Redshift, DocumentDB; custom Lambda for others), KMS encryption, fine-grained IAM policies, resource-based policies for cross-account access, versioning (current + previous), integration with RDS/Redshift for seamless credential rotation. Charged per secret per month + per 10,000 API calls. Primary differentiator from Parameter Store: **native automatic rotation**.

---

### Card 25
**Q:** What is the difference between Secrets Manager and SSM Parameter Store?
**A:** **Secrets Manager** – purpose-built for secrets; native **automatic rotation** with Lambda; costs $0.40/secret/month; mandatory KMS encryption; max 64 KB. **Parameter Store** – general-purpose configuration store; **no native rotation** (can build with EventBridge + Lambda); free tier (Standard: 10,000 params, 4 KB); Advanced tier: $0.05/param/month, 8 KB, policies (expiration/notification). Choose Secrets Manager for database credentials needing rotation. Choose Parameter Store for general configuration, feature flags, and cost sensitivity.

---

### Card 26
**Q:** What is AWS Certificate Manager (ACM)?
**A:** ACM provisions, manages, and deploys **SSL/TLS certificates** for AWS services. **Public certificates** are free and auto-renewed. **Private certificates** (via ACM Private CA) cost money. Certificates can be deployed on: ALB, NLB, CloudFront, API Gateway, Elastic Beanstalk. Cannot be used directly on EC2 (must install manually). Certificates are regional (except CloudFront, which requires `us-east-1`). Validation methods: DNS validation (recommended, automated with Route 53) or email validation.

---

### Card 27
**Q:** How does ACM certificate auto-renewal work?
**A:** ACM automatically renews public certificates **before they expire** (at least 60 days prior). **DNS-validated** certificates auto-renew as long as the CNAME record is in place. **Email-validated** certificates require the domain owner to respond to a renewal email. If renewal fails, ACM sends CloudWatch metrics and EventBridge events. Private CA certificates also auto-renew if issued by ACM. Certificates not issued by ACM (imported certificates) must be manually renewed and re-imported.

---

### Card 28
**Q:** What is AWS Firewall Manager?
**A:** Firewall Manager centrally manages firewall rules across multiple accounts and resources in an AWS Organization. Manages: **WAF rules**, **Shield Advanced** protections, **Security Groups**, **Network Firewall**, **Route 53 Resolver DNS Firewall**, and **third-party firewalls**. You create **security policies** that automatically apply rules to new and existing resources. Requires AWS Organizations and Config. Use for: enforcing consistent security policies across all accounts, ensuring all ALBs have WAF, ensuring all EC2 instances have approved security groups.

---

### Card 29
**Q:** What is AWS IAM Identity Center (formerly AWS SSO)?
**A:** IAM Identity Center provides **single sign-on** access to multiple AWS accounts and business applications. Features: centralized permission management using **Permission Sets** (IAM policies assigned to users/groups for specific accounts), built-in identity store or external IdPs (Active Directory, Okta, Azure AD via SAML 2.0), ABAC support, integrated with AWS Organizations. Users access a portal to see all assigned accounts and roles. Recommended over manual IAM federation setup for multi-account environments.

---

### Card 30
**Q:** What is AWS Directory Service?
**A:** AWS Directory Service offers three types: **AWS Managed Microsoft AD** – full Microsoft AD in the cloud; supports trust relationships with on-premises AD; MFA; LDAP; Group Policies. **AD Connector** – proxy that redirects requests to on-premises AD; no caching; does not store users in AWS. **Simple AD** – standalone, low-cost, small-scale AD compatible directory; basic features; does not support trust relationships. Choose Managed AD for full AD features, AD Connector for proxy to on-premises, Simple AD for basic needs without on-premises.

---

### Card 31
**Q:** What is the difference between AWS Managed Microsoft AD and AD Connector?
**A:** **Managed Microsoft AD** – creates a real Active Directory in AWS; stores users/groups in AWS; supports two-way trust with on-premises AD; works even if VPN/DX fails; supports MFA, LDAP, Kerberos, Group Policies. **AD Connector** – proxy/gateway to your on-premises AD; no users stored in AWS; all auth requests forwarded to on-premises; if VPN/DX fails, authentication fails; lower cost. Choose Managed AD for independence from on-premises; choose AD Connector for minimal cloud footprint.

---

### Card 32
**Q:** What are KMS grants?
**A:** KMS grants provide temporary, fine-grained access to KMS keys programmatically. Created via `CreateGrant` API, specifying the grantee principal and allowed operations. Grants are used by AWS services internally (e.g., EBS creates a grant to use the KMS key for encryption). Benefits: no need to modify key policy or IAM policy; grants are ephemeral; can be retired or revoked. Common pattern: service creates a grant for the duration of an operation, then retires it.

---

### Card 33
**Q:** What is SSE-C (Server-Side Encryption with Customer-Provided Keys)?
**A:** With SSE-C, you provide the encryption key with each S3 request. AWS uses your key to encrypt/decrypt but **does not store** the key. You must send the key in the HTTPS request header (HTTPS is mandatory). You manage key storage and rotation. If you lose the key, the data is unrecoverable. AWS uses the key only during the request and discards it. Use when you must control encryption keys but want S3 to perform the encryption. Not compatible with S3 bucket default encryption settings.

---

### Card 34
**Q:** What is AWS WAF IP reputation list?
**A:** The Amazon IP Reputation List is an AWS Managed Rule Group for WAF that blocks requests from IP addresses known for malicious activity. Includes: **AWSManagedRulesAmazonIpReputationList** (IPs with poor reputation from Amazon threat intelligence) and **AWSManagedRulesAnonymousIpList** (requests from VPNs, proxies, Tor exit nodes, hosting providers). These rules help block known bad actors without maintaining your own IP blocklist. Free to use (included with WAF pricing).

---

### Card 35
**Q:** What is the Shield Advanced DDoS cost protection?
**A:** Shield Advanced provides **cost protection** — if a DDoS attack causes scaling of protected resources (EC2 Auto Scaling, ELB, CloudFront, Route 53), AWS credits back the charges incurred due to the attack. You must have Shield Advanced enabled on the resource before the attack. Also includes: 24/7 access to the DDoS Response Team (DRT) who can create WAF rules on your behalf during an attack. DRT requires you to grant them access to your WAF and Shield configuration.

---

### Card 36
**Q:** What is Amazon Cognito Sync vs. AWS AppSync?
**A:** **Cognito Sync** (deprecated) – synchronized user data across devices (preferences, game state). Limited to 20 datasets per identity, 1 MB per dataset. **AppSync** (recommended replacement) – managed GraphQL service with real-time sync via WebSockets, offline support, and conflict resolution. AppSync can do everything Cognito Sync does plus much more (real-time subscriptions, multiple data sources). For any exam question about cross-device data sync, think AppSync (or Cognito Sync for legacy references).

---

### Card 37
**Q:** What is GuardDuty S3 Protection?
**A:** GuardDuty S3 Protection monitors S3 data access events (via CloudTrail S3 Data Events) to detect suspicious activity such as: unusual data access patterns, data exfiltration to unknown IPs, disabling of S3 logging, access from Tor exit nodes, and API calls from known malicious IPs. Enabled by default when you turn on GuardDuty. Generates S3-specific findings. Complements Macie (which focuses on sensitive data discovery) by detecting active threats to S3 data.

---

### Card 38
**Q:** What is GuardDuty EKS Protection?
**A:** GuardDuty EKS Protection monitors EKS cluster audit logs to detect suspicious Kubernetes activity. Detects: anonymous API requests, known malicious IPs, privilege escalation attempts, suspicious container images, crypto-mining pods, unauthorized namespace access. The EKS audit logs are analyzed directly by GuardDuty without you needing to enable or manage logging. Findings integrate with Security Hub and EventBridge for automated response.

---

### Card 39
**Q:** How does KMS work with S3 cross-region replication?
**A:** When replicating objects encrypted with SSE-KMS across regions, you must specify a KMS key in the **destination region** (objects are re-encrypted with the destination key). The replication role needs: `kms:Decrypt` permission on the source key and `kms:Encrypt` on the destination key. You can use a multi-region KMS key to simplify this (same key ID in both regions). Without proper KMS configuration, replication of KMS-encrypted objects will fail.

---

### Card 40
**Q:** What are KMS multi-region keys?
**A:** Multi-region keys are KMS keys replicated across multiple AWS regions. They share the same key ID, key material, and automatic rotation settings. One primary key and multiple replica keys. Enable: cross-region encryption/decryption without re-encryption, client-side encryption where data moves between regions, DynamoDB Global Tables encryption with the same key, Aurora Global Database encryption. They are NOT global — each replica is independently managed. They simplify cross-region encryption but should be used judiciously.

---

### Card 41
**Q:** What is the AWS Nitro Enclaves?
**A:** Nitro Enclaves provide isolated compute environments on EC2 instances for processing highly sensitive data. An enclave is a separate, hardened virtual machine with no persistent storage, no interactive access, and no external networking. Only the parent EC2 instance communicates with the enclave via a secure local channel (vsock). Use for: processing PII, healthcare data, financial data, DRM. Integrates with KMS — the enclave can attest to KMS for key access. Reduces the attack surface to just the enclave code.

---

### Card 42
**Q:** What is AWS Audit Manager?
**A:** Audit Manager helps you continuously audit your AWS usage for compliance. It automates evidence collection against frameworks: CIS, PCI DSS, HIPAA, SOC 2, GDPR, and custom frameworks. Evidence sources: CloudTrail logs, Config rules, Security Hub checks. Generates assessment reports ready for auditors. Maps AWS activity to specific compliance controls. Reduces manual audit effort. Different from Config (rule-based compliance) — Audit Manager is focused on generating audit-ready evidence and reports.

---

### Card 43
**Q:** What is the AWS Encryption SDK?
**A:** The AWS Encryption SDK is a client-side encryption library that simplifies envelope encryption. Available in Java, Python, C, JavaScript, and .NET. It handles: data key generation, envelope encryption, data key caching (reduces KMS calls), multiple master keys (for redundancy), and message format. The encrypted message contains the encrypted data key — so the recipient can decrypt without separately managing keys. Different from KMS (which does the encryption) — the SDK automates the envelope encryption workflow.

---

### Card 44
**Q:** What is S3 bucket policy vs. ACL for access control?
**A:** **Bucket policies** – JSON resource-based policies; support conditions, principals, and complex logic; recommended for most access control. **ACLs** – legacy mechanism with limited permissions (READ, WRITE, FULL_CONTROL); per-object or per-bucket; limited grant types; cannot deny. AWS now recommends disabling ACLs (enable "Bucket Owner Enforced" Object Ownership) and using bucket policies exclusively. ACLs are still needed in rare cross-account upload scenarios where the uploading account must retain ownership.

---

### Card 45
**Q:** What is Amazon Verified Permissions?
**A:** Amazon Verified Permissions is a managed authorization service for custom applications. Uses the **Cedar** policy language to define fine-grained permissions. Centralize authorization logic outside your application code. Policies define: who (principal), can do what (action), on which resource, under what conditions. Integrates with Cognito User Pools for identity. Use for: multi-tenant SaaS apps, complex RBAC/ABAC, consistent authorization across microservices. The exam may mention it as a solution for application-level authorization.

---

### Card 46
**Q:** What is the Cognito hosted UI?
**A:** Cognito User Pools provides a hosted web UI for sign-up, sign-in, and account management. Supports: email/password, social login (Google, Facebook, Apple, Amazon), SAML, and OIDC federation. Customizable with your logo, CSS, and domain. Returns OAuth 2.0 tokens (authorization code, implicit, or client credentials grant). Can use a custom domain with ACM certificate. Saves development time for auth UI. Integration: configure as the auth provider in ALB or API Gateway.

---

### Card 47
**Q:** What is CloudHSM high availability architecture?
**A:** Deploy CloudHSM in a **cluster** with HSMs in **multiple AZs**. Keys are automatically synchronized across all HSMs in the cluster. If one HSM fails, the others continue serving requests. Minimum 2 HSMs in different AZs for production. The cluster has a single ENI in each subnet. CloudHSM client can fail over between HSMs. AWS manages HSM hardware; you manage users, keys, and applications. For the exam: always deploy CloudHSM in at least 2 AZs for HA.

---

### Card 48
**Q:** What is the difference between WAF, Shield, and Firewall Manager?
**A:** **WAF** – Layer 7 protection; inspects HTTP requests; rules for SQL injection, XSS, IP blocking, rate limiting; deployed on ALB/CloudFront/API Gateway. **Shield** – DDoS protection; Standard (free, L3/L4) and Advanced (paid, L3/L4/L7 with DRT support). **Firewall Manager** – centralized management tool; deploys WAF rules, Shield protections, and security groups across all accounts in an Organization. Use together: Firewall Manager to deploy WAF rules and Shield protections consistently across accounts.

---

### Card 49
**Q:** What is KMS key deletion?
**A:** When you schedule a customer managed KMS key for deletion, there's a mandatory **waiting period** of 7 to 30 days (default 30). During the waiting period: the key is disabled (cannot encrypt/decrypt), CloudWatch alarms can detect usage attempts, and you can cancel deletion. After the waiting period, the key and all encrypted data are **permanently unrecoverable**. AWS managed and owned keys cannot be deleted. Best practice: disable the key first and monitor for failures before scheduling deletion.

---

### Card 50
**Q:** What is VPC endpoint policy and how is it used for security?
**A:** A VPC endpoint policy is a resource-based policy attached to a VPC endpoint (Interface or Gateway) that controls which AWS resources can be accessed through the endpoint. Example: restrict an S3 Gateway Endpoint to only allow access to a specific S3 bucket. Combined with S3 bucket policies using `aws:sourceVpce` condition, you can ensure data can only be accessed from within the VPC. Endpoint policies do not replace IAM policies — they provide an additional layer of control.

---

*End of Deck 7 — 50 cards*
