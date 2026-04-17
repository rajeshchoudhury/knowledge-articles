# AWS Certified Solutions Architect - Professional (SAP-C02) Practice Test 16

**Focus Areas:** Encryption (KMS/CloudHSM), Secrets Manager, ACM, Compliance & Governance
**Time Limit:** 180 minutes
**Total Questions:** 75
**Passing Score:** 750/1000

---

## Domain Distribution
- Domain 1 – Organizational Complexity: Questions 1–20
- Domain 2 – Design New Solutions: Questions 21–42
- Domain 3 – Continuous Improvement: Questions 43–53
- Domain 4 – Migration: Questions 54–62
- Domain 5 – Cost Optimization: Questions 63–75

---

### Question 1

A multinational financial institution operates 200 AWS accounts under AWS Organizations. The CISO mandates that all EBS volumes, S3 buckets, and RDS instances across every account must be encrypted using customer managed KMS keys (CMKs) — never AWS managed keys or unencrypted. The security team needs to enforce this preventively and detect any drift. The solution must work automatically for new accounts added to the organization.

Which combination of actions provides the MOST comprehensive enforcement? (Choose TWO.)

A. Attach SCPs to the root OU that deny ec2:CreateVolume, s3:CreateBucket, and rds:CreateDBInstance unless the aws:RequestedEncryptionKey condition matches the organization's CMK ARN pattern.

B. Deploy AWS Config organizational rules using a delegated administrator to detect non-compliant resources and configure automatic remediation via SSM Automation documents.

C. Create a Lambda function in the management account that periodically scans all accounts using AssumeRole to verify encryption settings and sends alerts to an SNS topic.

D. Enable AWS Security Hub across the organization and use custom insights to filter for unencrypted resources.

E. Use CloudFormation StackSets with service-managed permissions to deploy IAM policies in all accounts that deny creation of unencrypted resources.

**Correct Answer: A, B**

**Explanation:** SCPs (A) provide preventive controls at the organization level, denying resource creation that doesn't use CMKs. They apply automatically to all accounts, including new ones. AWS Config organizational rules (B) provide detective controls with auto-remediation for any resources that slip through or pre-existing non-compliant resources. Option C is operationally heavy and introduces polling lag. Option D detects but doesn't prevent or remediate. Option E deploys IAM policies but these can be modified by account administrators unless protected by SCPs, making it less reliable than using SCPs directly.

---

### Question 2

A healthcare company must comply with HIPAA and requires that all AWS KMS keys used for encrypting PHI (Protected Health Information) have automatic key rotation enabled. They have 50 AWS accounts and use both symmetric and asymmetric KMS keys. The compliance team needs a centralized dashboard showing rotation status across all accounts with automated remediation for non-compliant keys.

Which solution BEST meets these requirements?

A. Deploy AWS Config rule kms-cmk-not-scheduled-for-deletion across all accounts using AWS Organizations integration, and create a custom Config rule to check rotation status with Lambda-based remediation.

B. Use AWS Security Hub with the AWS Foundational Security Best Practices standard, which includes checks for KMS key rotation, aggregated to a central administrator account.

C. Deploy a custom AWS Config rule via organizational conformance packs that evaluates kms:GetKeyRotationStatus for each CMK. Configure automatic remediation using an SSM Automation document that calls kms:EnableKeyRotation. Use a delegated Config administrator for the centralized dashboard.

D. Create a CloudWatch Events rule in each account that triggers on KMS API calls and a Lambda function that checks and enables rotation for newly created keys.

**Correct Answer: C**

**Explanation:** Organizational conformance packs (C) allow deploying custom Config rules to all accounts from a delegated administrator, providing centralized visibility and compliance dashboards. The SSM Automation remediation automatically enables rotation on non-compliant keys. Note that automatic key rotation only applies to symmetric CMKs — asymmetric keys do not support automatic rotation, so the rule should account for this. Option A uses a deletion-focused rule, not rotation. Option B provides detection but not automated remediation. Option D only catches newly created keys and requires per-account deployment.

---

### Question 3

A company is designing a multi-account encryption strategy. They want a central security account to manage KMS keys that other accounts use for encryption. Application accounts should be able to use these keys for encryption and decryption but should NOT be able to manage, disable, or schedule deletion of the keys. The solution must support cross-account access for EBS, S3, and RDS services.

Which approach BEST implements this with least privilege?

A. Create KMS keys in the security account. Add a key policy granting the application account root principals kms:Encrypt, kms:Decrypt, kms:ReEncrypt*, kms:GenerateDataKey*, and kms:DescribeKey. Add grants for AWS services using kms:CreateGrant with a condition limiting the grantee to AWS service principals.

B. Create KMS keys in the security account. Share them using AWS Resource Access Manager (RAM) with the application accounts OU, granting full key usage permissions.

C. Create KMS keys in each application account but manage them through a centralized CloudFormation StackSet deployed from the security account.

D. Create KMS keys in the security account and replicate them to application accounts using a custom Lambda function that recreates identical key material.

**Correct Answer: A**

**Explanation:** Creating keys in a central security account with specific key policy grants (A) provides least-privilege cross-account access. The key policy grants only usage permissions (Encrypt, Decrypt, GenerateDataKey) without management permissions (DisableKey, ScheduleKeyDeletion). The kms:CreateGrant with service principal conditions allows AWS services like EBS and RDS to use the key via grants. Option B is incorrect because KMS keys cannot be shared via RAM. Option C creates keys in each account, defeating centralized management. Option D is impossible — KMS key material cannot be exported and replicated.

---

### Question 4

An organization uses AWS CloudHSM for generating and storing cryptographic keys for their payment processing application. They currently have a CloudHSM cluster with two HSM instances in a single AZ. The compliance team requires high availability and the ability to survive an AZ failure without losing key material.

Which architecture change should the solutions architect recommend?

A. Add a third HSM instance in a different AZ within the same Region. Configure the application to connect to the CloudHSM cluster endpoint, which automatically handles failover.

B. Create a second CloudHSM cluster in a different Region and configure cross-Region replication of key material using AWS Backup.

C. Replace CloudHSM with AWS KMS custom key store backed by a multi-AZ CloudHSM cluster, which handles HA automatically.

D. Add an HSM instance in a different AZ and configure manual key synchronization between the instances using CloudHSM client SDK.

**Correct Answer: A**

**Explanation:** CloudHSM clusters automatically synchronize key material across all HSMs within the cluster. Adding an HSM in a different AZ (A) provides AZ-level redundancy. The cluster endpoint handles routing, and if one AZ fails, the cluster continues operating with the remaining HSMs. Option B is incorrect because CloudHSM doesn't support cross-Region replication via AWS Backup. Option C adds unnecessary KMS abstraction — a custom key store still requires a properly configured CloudHSM cluster underneath. Option D is wrong because synchronization within a cluster is automatic; manual sync is not needed or supported in this way.

---

### Question 5

A government agency requires FIPS 140-2 Level 3 validated hardware security modules for all cryptographic operations related to classified data. They also need to maintain exclusive control of their encryption keys — AWS must not have the ability to access the key material. The agency uses multiple AWS services including S3, EBS, and RDS.

Which solution meets these requirements?

A. Use AWS KMS with customer managed keys configured for FIPS 140-2 compliance mode.

B. Use AWS CloudHSM to generate and store keys, and integrate with AWS services using a KMS custom key store backed by the CloudHSM cluster.

C. Use AWS KMS with imported key material generated from the agency's on-premises FIPS-validated HSM.

D. Use AWS KMS external key store (XKS) connected to the agency's on-premises FIPS 140-2 Level 3 HSM.

**Correct Answer: B**

**Explanation:** AWS CloudHSM provides FIPS 140-2 Level 3 validated HSMs where the customer has exclusive control of the key material — AWS cannot access it. By creating a KMS custom key store backed by CloudHSM (B), the agency can use KMS-integrated services (S3, EBS, RDS) while keys are generated and stored in the FIPS Level 3 validated CloudHSM. Option A is incorrect because KMS HSMs are FIPS 140-2 Level 2 (not Level 3), and AWS manages the underlying HSM infrastructure. Option C imports key material into KMS but KMS HSMs are still Level 2. Option D (XKS) keeps keys on-premises but introduces latency and availability challenges; however, the key requirement is Level 3 within AWS services integration, which CloudHSM + custom key store best satisfies.

---

### Question 6

A retail company stores customer PII in an RDS PostgreSQL database encrypted with a KMS CMK. The compliance team discovers that the same CMK has been shared with a development account for testing purposes, violating their data classification policy. The security team needs to immediately ensure the production database is encrypted with a key accessible only to the production account, with minimal downtime.

Which approach should the solutions architect recommend?

A. Create a new CMK in the production account with a restrictive key policy. Create a snapshot of the RDS instance, copy the snapshot while re-encrypting with the new CMK, and restore a new RDS instance from the re-encrypted snapshot. Update the application connection string and delete the old instance.

B. Modify the existing CMK's key policy to remove the development account's access, then re-encrypt the RDS instance in place using the ModifyDBInstance API.

C. Create a new CMK and use AWS DMS to migrate data from the existing instance to a new RDS instance encrypted with the new key.

D. Disable the existing CMK, create a new one, and RDS will automatically re-encrypt using the new key.

**Correct Answer: A**

**Explanation:** RDS encryption keys cannot be changed in place. The correct approach (A) is to create a snapshot, copy it with re-encryption using the new CMK, and restore a new instance. This provides a clean break from the compromised key. Option B is wrong because you cannot change the encryption key of an existing RDS instance — removing dev access from the old key doesn't re-encrypt the data. Option C works but introduces unnecessary complexity with DMS. Option D is destructive — disabling the CMK makes the existing database inaccessible, and RDS does not auto-re-encrypt.

---

### Question 7

A SaaS company provides data analytics services to multiple tenants. Each tenant's data must be encrypted with a unique KMS key, and tenants must be able to audit the usage of their specific encryption key. The company currently has 500 tenants and expects to grow to 5,000 within two years. They need to manage this at scale while keeping costs manageable.

Which encryption architecture BEST addresses these requirements?

A. Create a single KMS key per tenant in the SaaS provider's account. Use key policies to grant each tenant's AWS account read access to CloudTrail logs filtered by their key ID. Implement a key management microservice for provisioning.

B. Create KMS keys in each tenant's AWS account and use cross-account grants to allow the SaaS application to use them. Tenants monitor their own CloudTrail for KMS events.

C. Use a single KMS key with encryption context containing the tenant ID. Grant tenants access to CloudTrail log queries filtered by encryption context values. Use KMS grants for fine-grained access control per tenant.

D. Use AWS CloudHSM with separate key partitions for each tenant to provide complete isolation and auditing.

**Correct Answer: C**

**Explanation:** Using encryption context (C) with a single KMS key is the most scalable approach. Encryption context is logged in CloudTrail, allowing per-tenant audit trails by filtering on the tenant ID context value. KMS grants can restrict access based on encryption context, providing logical tenant isolation. At 5,000 tenants, creating individual KMS keys (A) becomes costly (each key costs $1/month = $5,000/month) and hits key management complexity. Option B requires every tenant to have an AWS account and manage their own keys. Option D is extremely expensive and operationally complex for this scale.

---

### Question 8

A company is implementing envelope encryption for a high-throughput application that processes 100,000 records per second. Each record must be individually encrypted. The application runs on an Auto Scaling group of EC2 instances. The team is concerned about KMS API throttling and latency.

Which implementation strategy BEST addresses performance requirements?

A. Call KMS GenerateDataKey for each record, use the plaintext data key to encrypt the record, and store the encrypted data key alongside the encrypted record.

B. Call KMS GenerateDataKey once per batch of records. Cache the plaintext data key in memory and use it to encrypt multiple records within a time window. Store the encrypted data key with the batch. Implement the AWS Encryption SDK with data key caching.

C. Use KMS Encrypt API directly for each record, bypassing envelope encryption to reduce complexity.

D. Use CloudHSM for all encryption operations to avoid KMS throttling limits entirely.

**Correct Answer: B**

**Explanation:** Data key caching (B) via the AWS Encryption SDK dramatically reduces KMS API calls. Instead of calling GenerateDataKey 100,000 times per second (which would far exceed KMS limits of 5,500-30,000 requests/second per account depending on Region), you generate a data key periodically and cache it for encrypting multiple records. The cached key can be bounded by time (max age), number of messages, or bytes encrypted. Option A would immediately hit throttling at 100K records/sec. Option C using direct KMS encryption has a 4KB payload limit and would also throttle. Option D is expensive and still requires managing high throughput; CloudHSM has its own performance considerations.

---

### Question 9

A company has deployed an application that uses AWS Secrets Manager to store database credentials. The application retrieves the secret on every database connection request, resulting in approximately 50,000 API calls per hour. The team notices increased latency and occasional throttling errors.

Which solution MOST effectively reduces API calls while maintaining security?

A. Implement client-side caching of the secret value in the application with a TTL matching the secret rotation interval. Use the AWS Secrets Manager caching library.

B. Store the database credentials in AWS Systems Manager Parameter Store SecureString parameters instead, as they have higher API limits.

C. Read the secret value at application startup and store it in an environment variable for the lifetime of the application process.

D. Deploy an ElastiCache Redis cluster to cache the secret value and have all application instances read from the cache.

**Correct Answer: A**

**Explanation:** The Secrets Manager caching library (A) provides client-side caching that significantly reduces API calls while automatically refreshing the cached value. Setting the TTL to match the rotation interval ensures credentials are refreshed when rotated. This is the AWS-recommended approach. Option B might reduce throttling but loses Secrets Manager's rotation capabilities. Option C stores credentials in environment variables, which is less secure and doesn't handle rotation. Option D introduces a shared cache that could become a security risk and single point of failure — secrets cached in Redis would need additional encryption and access control.

---

### Question 10

An enterprise is implementing AWS Certificate Manager (ACM) for TLS certificates across their multi-account organization. They want to use a centralized private Certificate Authority (CA) for internal services while using ACM public certificates for external-facing services. The private CA must be shared across 100 accounts.

Which architecture provides centralized management with cross-account access?

A. Create an ACM Private CA in a central security account. Share the CA using AWS Resource Access Manager (RAM) with the organization. Application accounts can issue private certificates from the shared CA.

B. Create an ACM Private CA in each account and chain them to a root CA in the security account using cross-account IAM roles.

C. Create an ACM Private CA in the security account. Set up a Lambda function that issues certificates on behalf of other accounts and distributes them via S3.

D. Use AWS Certificate Manager public certificates for all services, including internal ones, to simplify management.

**Correct Answer: A**

**Explanation:** ACM Private CA can be shared via RAM (A), allowing other accounts in the organization to issue certificates from the centralized CA without managing their own CA infrastructure. This provides centralized governance while enabling self-service certificate issuance. Option B creates unnecessary operational complexity with per-account CAs. Option C is a custom solution with significant management overhead. Option D uses public certificates for internal services, which is wasteful (public certs cost nothing in ACM but private internal services don't need public trust) and exposes internal service names in Certificate Transparency logs.

---

### Question 11

A company's security team has detected that KMS key policies in several accounts are overly permissive, granting key usage to "Principal": "*". They need to immediately identify all such keys across 150 accounts and remediate them without disrupting applications that legitimately use the keys.

Which approach provides the safest remediation path?

A. Use AWS Config aggregator with a custom rule that evaluates KMS key policies for wildcard principals. For each non-compliant key, trigger a Step Functions workflow that analyzes CloudTrail logs for the key's usage patterns, generates a least-privilege policy, sends it for approval via SNS, and applies it upon approval.

B. Run a script from the management account that immediately replaces all wildcard key policies with policies granting access only to the account root principal.

C. Enable AWS Access Analyzer for all accounts and use its policy validation feature to flag overly permissive KMS key policies, then manually update each one.

D. Schedule the KMS keys with wildcard policies for deletion with a 30-day waiting period, create new keys with restrictive policies, and re-encrypt all data.

**Correct Answer: A**

**Explanation:** The Config-based approach with Step Functions workflow (A) provides automated detection, evidence-based remediation (using CloudTrail for actual usage patterns), and human approval before changes. This prevents disrupting legitimate access. Option B could break applications by immediately restricting access without understanding usage patterns. Option C provides detection but requires manual remediation across 150 accounts. Option D is extremely disruptive — scheduling key deletion and re-encrypting all data is a massive undertaking with significant risk.

---

### Question 12

A company needs to implement automatic rotation for RDS MySQL database credentials stored in Secrets Manager. The database is in a private subnet with no internet access. The rotation Lambda function must be able to access both Secrets Manager and the RDS instance.

Which networking configuration allows the rotation Lambda to function correctly?

A. Deploy the Lambda function in the same VPC and subnet as the RDS instance. Create VPC endpoints for Secrets Manager and the RDS API in the VPC.

B. Deploy the Lambda function outside the VPC and configure the RDS instance's security group to allow inbound connections from the Lambda function.

C. Deploy the Lambda function in the same VPC as the RDS instance. Attach a NAT Gateway to the private subnet for Secrets Manager API access.

D. Deploy the Lambda function in the same VPC as the RDS instance. Create a VPC endpoint for Secrets Manager. Ensure the Lambda function's security group allows outbound access to the RDS port and the RDS security group allows inbound from the Lambda security group.

**Correct Answer: D**

**Explanation:** The Lambda rotation function needs network access to both the RDS instance and Secrets Manager. Deploying Lambda in the VPC (D) enables RDS connectivity, and a VPC endpoint for Secrets Manager provides API access without internet. Security groups must allow Lambda-to-RDS communication. Option A mentions an "RDS API" VPC endpoint which isn't needed for database connectivity — the function connects directly to the RDS endpoint. Option B won't work because a non-VPC Lambda can't reach a private RDS instance. Option C adds a NAT Gateway which works but violates the "no internet access" requirement and adds unnecessary cost when a VPC endpoint suffices.

---

### Question 13

A financial services company runs workloads across three AWS Regions. They use KMS for encryption and must ensure that encrypted data can be accessed across Regions for disaster recovery purposes. S3 objects encrypted with KMS in the primary Region must be accessible from all three Regions.

Which approach enables cross-Region access to encrypted S3 data with the LEAST operational overhead?

A. Create KMS multi-Region keys. Use the primary key in the primary Region for encryption. Create replica keys in the DR Regions. Configure S3 cross-Region replication with the replica keys for re-encryption in destination buckets.

B. Create separate KMS keys in each Region. When replicating S3 objects, use S3 cross-Region replication with a Lambda function that decrypts with the source key and re-encrypts with the destination key.

C. Use a single Region's KMS key for all S3 operations. Configure applications in other Regions to make cross-Region KMS API calls to the primary Region for decryption.

D. Copy the KMS key material from the primary Region and import it into KMS keys in each DR Region to create functionally identical keys.

**Correct Answer: A**

**Explanation:** KMS multi-Region keys (A) are designed for this use case. They share the same key ID and key material across Regions, making cross-Region operations seamless. S3 cross-Region replication natively supports re-encrypting replicated objects with a KMS key in the destination Region. Using replica keys means the same ciphertext can be decrypted in any Region. Option B requires custom Lambda logic, adding complexity. Option C introduces cross-Region latency and creates a single point of failure. Option D is not supported — KMS doesn't allow exporting key material from keys created in KMS.

---

### Question 14

A company uses AWS Secrets Manager to store API keys for 30 different third-party SaaS integrations. Each secret has a custom rotation Lambda function. The operations team reports that several rotations have failed silently, causing application outages when expired credentials are used.

Which monitoring and alerting strategy provides the MOST comprehensive coverage for rotation failures?

A. Create CloudWatch alarms on the RotationSucceeded and RotationFailed CloudWatch metrics for each secret. Configure an SNS topic with PagerDuty integration for RotationFailed alarms. Add a metric for days since last successful rotation.

B. Configure CloudTrail to log Secrets Manager API calls and create a CloudWatch Logs metric filter for failed rotation events.

C. Enable AWS Config rule secretsmanager-scheduled-rotation-success-check across all secrets and integrate with Security Hub for alerting.

D. Create a scheduled Lambda function that runs daily, checks the last rotation date for each secret, and alerts if any secret hasn't been rotated within the expected interval.

**Correct Answer: A**

**Explanation:** CloudWatch metrics for Secrets Manager rotation (A) provide real-time monitoring of rotation success and failure. Creating alarms on RotationFailed immediately alerts the team. Adding a metric tracking days since last successful rotation catches cases where rotation simply stops running. SNS with PagerDuty ensures prompt incident response. Option B relies on log analysis and may miss some failure modes. Option C's Config rule checks help but has evaluation delays and doesn't provide real-time alerting. Option D is a good backup but introduces polling delay and is a custom solution requiring maintenance.

---

### Question 15

An organization has a compliance requirement that all encryption keys used for production data must be rotated annually. They use a mix of KMS symmetric keys, KMS asymmetric keys, and CloudHSM keys. The compliance team needs an automated solution that handles rotation differently based on key type.

Which solution correctly addresses the rotation requirements for all key types?

A. Enable automatic annual rotation for all KMS keys and use a Lambda function to rotate CloudHSM keys by generating new key material and updating references.

B. Enable automatic annual rotation for KMS symmetric keys. Implement a custom rotation process for KMS asymmetric keys that creates new keys and updates references in applications. Implement HSM key rotation through the CloudHSM client SDK in a scheduled automation.

C. Use AWS Config to enforce rotation policies uniformly across all key types and remediate with a single SSM document.

D. Replace all asymmetric and CloudHSM keys with symmetric KMS keys to enable uniform automatic rotation.

**Correct Answer: B**

**Explanation:** Different key types require different rotation strategies (B). KMS symmetric keys support automatic annual rotation natively. KMS asymmetric keys do NOT support automatic rotation — you must create new keys and update application references (manual process). CloudHSM keys are managed independently and require rotation through the CloudHSM client SDK or PKCS#11 interface. Option A is incorrect because asymmetric KMS keys don't support automatic rotation. Option C cannot apply a uniform rotation approach to fundamentally different key types. Option D is impractical — many use cases (digital signatures, TLS) specifically require asymmetric keys.

---

### Question 16

A media company hosts sensitive video content on S3, encrypted with KMS. They need to provide time-limited access to specific videos for authorized partners. The solution must ensure partners can only access their designated videos, and the presigned URLs must work with KMS-encrypted objects.

Which solution provides secure, time-limited access to KMS-encrypted S3 objects for external partners?

A. Generate S3 presigned URLs using an IAM role that has both s3:GetObject permission on the specific object and kms:Decrypt permission on the KMS key. Set URL expiration to the required time window.

B. Create a CloudFront distribution with an Origin Access Identity. Use CloudFront signed URLs with a custom policy that specifies the exact object path and expiration time. Configure the CloudFront distribution to use the KMS key for server-side decryption.

C. Create temporary IAM users for each partner with policies scoped to their specific S3 objects and KMS key usage. Provide them with time-limited access keys.

D. Copy the requested videos to an unencrypted public S3 bucket with a lifecycle rule to delete them after the access window expires.

**Correct Answer: B**

**Explanation:** CloudFront signed URLs (B) with OAI provide the best combination of security and performance for distributing encrypted content. CloudFront handles KMS decryption transparently when configured correctly, provides edge caching for better performance, and signed URLs with custom policies enable per-partner path restrictions and precise expiration control. Option A works technically but presigned URLs bypass CloudFront, meaning no edge caching and direct S3 access. Option C creates IAM user management overhead and is less secure than URL-based access. Option D is a significant security risk — placing sensitive content in a public bucket, even temporarily.

---

### Question 17

A company operates in a regulated industry and must demonstrate to auditors that encryption keys have never been used by unauthorized principals. They need a comprehensive audit trail showing every KMS API call, who made it, and whether it succeeded or failed, going back three years.

Which solution provides the required audit capability?

A. Enable CloudTrail in all accounts with KMS data event logging. Configure CloudTrail to deliver logs to a centralized S3 bucket with object lock (compliance mode) in a dedicated log archive account. Set a lifecycle policy for 3-year retention. Use Athena for querying.

B. Use CloudTrail default management event logging, which captures all KMS API calls. Store logs in S3 with a 3-year retention policy.

C. Enable KMS key-level logging by configuring each key to send usage logs to CloudWatch Logs with a 3-year retention period.

D. Use AWS Config to record all KMS resource configuration changes and maintain a 3-year history.

**Correct Answer: A**

**Explanation:** CloudTrail with KMS data event logging (A) captures all cryptographic operations (Encrypt, Decrypt, GenerateDataKey) in addition to management events. Storing in an S3 bucket with object lock in compliance mode ensures logs cannot be deleted or tampered with, satisfying audit immutability requirements. Athena enables efficient querying across years of data. Option B only captures management events by default — data events like Encrypt/Decrypt require explicit enablement. Option C is incorrect — KMS doesn't have a built-in per-key CloudWatch Logs integration for all API calls. Option D records configuration changes but not API usage events like who decrypted using a key.

---

### Question 18

A company needs to encrypt data in Amazon DynamoDB using client-side encryption. They want to encrypt specific attributes (PII fields) while leaving other attributes searchable in plaintext. The encryption keys must be managed through KMS. The solution must support key rotation without re-encrypting existing items.

Which approach BEST meets these requirements?

A. Use the Amazon DynamoDB Encryption Client (now part of AWS Database Encryption SDK) with attribute-level encryption. Configure the client to encrypt only designated attributes using a KMS keyring. Enable key rotation on the KMS key — the library stores the encrypted data key with each item, so decryption uses the original key version.

B. Implement custom encryption logic using the AWS SDK KMS client to encrypt specific fields before writing to DynamoDB and decrypt after reading.

C. Enable DynamoDB server-side encryption with a KMS CMK and use DynamoDB fine-grained access control to restrict access to PII attributes.

D. Use S3 client-side encryption to encrypt PII fields and store references in DynamoDB, with the actual encrypted data in S3.

**Correct Answer: A**

**Explanation:** The AWS Database Encryption SDK (A) (formerly DynamoDB Encryption Client) provides attribute-level encryption designed specifically for DynamoDB. It encrypts only specified attributes while leaving others in plaintext for querying. The SDK uses envelope encryption — each item's encrypted data key is stored alongside the item, so when the KMS CMK is rotated, existing items can still be decrypted (old key versions are retained). Option B requires building custom encryption logic that the SDK already provides. Option C uses server-side encryption which encrypts the entire table, not specific attributes. Option D adds unnecessary architectural complexity.

---

### Question 19

An organization is setting up AWS Control Tower for 300 accounts. They need to ensure that ACM certificates across all accounts are monitored for expiration and that certificates expiring within 30 days trigger automated renewal or alerts. The solution must work without modifying applications in individual accounts.

Which approach provides organization-wide certificate expiration monitoring?

A. Deploy an organizational AWS Config rule using acm-certificate-expiration-check with a configurable parameter of 30 days. Aggregate findings in the audit account using a Config aggregator. Configure SNS notifications for non-compliant resources.

B. Create a Lambda function in each account using CloudFormation StackSets that checks ACM certificate expiration daily and sends notifications to a central SNS topic.

C. Use AWS Security Hub with the AWS Foundational Security Best Practices standard, which includes ACM certificate expiration checks, aggregated to a central account.

D. Configure ACM to send expiration notifications via email to the central security team for all accounts.

**Correct Answer: A**

**Explanation:** The AWS Config organizational rule acm-certificate-expiration-check (A) evaluates ACM certificates across all accounts and flags those expiring within the configured window. Config aggregator provides centralized visibility in the audit account. SNS notifications enable automated alerting. This deploys automatically to new accounts via Organizations integration. Option B requires StackSet management and custom Lambda maintenance. Option C provides monitoring but Security Hub findings may have different evaluation schedules and less configurability. Option D only works for ACM-issued certificates (not imported ones) and relies on email, which is unreliable for operational alerting.

---

### Question 20

A company uses AWS Organizations with SCPs to enforce encryption policies. A developer reports that they cannot launch an EC2 instance with an encrypted EBS volume in their development account, despite having the correct IAM permissions. The SCP allows ec2:RunInstances and kms:CreateGrant. The KMS key is in a shared services account.

What is the MOST likely cause of this issue?

A. The SCP is missing kms:Decrypt permission, which is required when EC2 launches an instance with an encrypted EBS volume.

B. The SCP is missing kms:GenerateDataKeyWithoutPlaintext permission, which EBS requires to encrypt the volume during instance launch.

C. The KMS key policy in the shared services account doesn't grant the developer's account permissions to use the key.

D. The developer's IAM policy is missing the kms:CreateGrant condition key that limits grants to AWS service principals.

**Correct Answer: C**

**Explanation:** For cross-account KMS usage, both the key policy (in the key's account) AND the IAM/SCP permissions (in the user's account) must allow the operation. Even if the SCP allows KMS operations, the key policy in the shared services account must explicitly grant the development account access. This is a common mistake — KMS key policies are resource-based policies that require explicit cross-account grants. Options A and B describe permissions that might be needed but the most likely cause for a cross-account scenario is the missing key policy grant (C). Option D describes a condition that would further restrict grants, which is not a standard requirement.

---

### Question 21

A startup is building a SaaS application that must encrypt customer data at rest using per-tenant encryption keys. They expect 10,000 tenants within the first year. The application uses Aurora PostgreSQL for structured data and S3 for file storage. Each tenant must be able to bring their own encryption key (BYOK) or use a platform-provided key.

Which encryption architecture BEST balances security isolation, cost, and scalability?

A. Create a KMS key per tenant ($1/key/month). Store the key ARN in a tenant metadata table. Use the tenant's key for Aurora column-level encryption and S3 SSE-KMS. For BYOK tenants, use KMS external key store (XKS).

B. Use a single platform KMS key with tenant-specific encryption contexts. For BYOK tenants, import their key material into KMS keys. Use the AWS Database Encryption SDK for Aurora column-level encryption and S3 SSE-KMS with encryption context.

C. Use CloudHSM to create isolated key namespaces per tenant. Implement custom encryption middleware that routes to the correct HSM key based on tenant ID.

D. Use application-level encryption with OpenSSL and store data encryption keys encrypted by each tenant's master key in a separate DynamoDB table.

**Correct Answer: B**

**Explanation:** Using a single platform key with encryption contexts (B) is most cost-effective at 10,000 tenants (avoiding $10,000/month for per-tenant keys). Encryption context provides logical isolation and audit trails per tenant. For BYOK tenants, importing their key material into dedicated KMS keys gives them control while staying within the KMS ecosystem. The Database Encryption SDK provides column-level encryption for Aurora. Option A costs $120,000/year in KMS key charges alone. Option C is prohibitively expensive and complex at this scale. Option D requires building and maintaining a complete encryption framework.

---

### Question 22

A company is building a microservices architecture on EKS. Each microservice needs to access different secrets (database credentials, API keys, TLS certificates). The security team requires that secrets are not stored in Kubernetes Secrets (which are base64-encoded, not encrypted at rest by default) and wants seamless integration with AWS Secrets Manager.

Which solution provides secure, scalable secret delivery to EKS pods?

A. Use the AWS Secrets and Configuration Provider (ASCP) for the Kubernetes Secrets Store CSI Driver. Define SecretProviderClass resources that map Secrets Manager secrets to mounted volumes in pods. Use IAM Roles for Service Accounts (IRSA) to control which pods can access which secrets.

B. Create an init container in each pod that uses the AWS SDK to fetch secrets from Secrets Manager and write them to a shared emptyDir volume.

C. Use an External Secrets Operator to synchronize Secrets Manager secrets into Kubernetes Secrets, encrypted with KMS using the EKS envelope encryption feature.

D. Deploy HashiCorp Vault on EKS and synchronize AWS Secrets Manager secrets to Vault, then use Vault's sidecar injector for pod access.

**Correct Answer: A**

**Explanation:** ASCP with CSI Driver (A) provides native integration between EKS and Secrets Manager without storing secrets as Kubernetes Secrets. Secrets are mounted as files in the pod's filesystem directly from Secrets Manager. IRSA ensures fine-grained access control, mapping specific service accounts to specific secrets. Option B is a custom solution requiring maintenance and doesn't handle secret rotation. Option C still creates Kubernetes Secrets, even with EKS envelope encryption. Option D introduces unnecessary complexity by adding Vault as an intermediary.

---

### Question 23

A healthcare application processes medical records and must comply with HIPAA. The application uses an ALB for HTTPS termination with an ACM public certificate. The compliance team requires end-to-end encryption — TLS must be maintained between the ALB and the backend EC2 instances, not just from clients to the ALB.

Which configuration ensures end-to-end TLS encryption?

A. Configure the ALB target group to use HTTPS protocol (port 443). Install TLS certificates on the backend EC2 instances (can use ACM Private CA certificates). Configure the ALB listener to use the ACM public certificate for the frontend connection.

B. Use a Network Load Balancer instead of an ALB, as NLBs provide end-to-end encryption by passing through TLS connections.

C. Enable the ALB's built-in end-to-end encryption feature by checking "Enable backend encryption" in the target group settings.

D. Use CloudFront in front of the ALB and configure origin SSL protocols to enforce TLS to the origin.

**Correct Answer: A**

**Explanation:** ALB supports end-to-end encryption by configuring HTTPS target groups (A). The ALB terminates the client-side TLS using the ACM public certificate, then establishes a new TLS connection to the backend instances. Backend instances need their own TLS certificates — ACM Private CA is ideal for this. This provides encryption in transit for both legs. Option B with NLB TCP passthrough maintains the original TLS connection but loses ALB features (path routing, host routing, WAF integration). Option C doesn't exist as a feature. Option D adds CloudFront but doesn't address ALB-to-backend encryption.

---

### Question 24

A company uses AWS Secrets Manager to store database credentials with automatic rotation configured every 30 days. After a recent rotation, several application instances continued using the old credentials and experienced authentication failures. The database was configured with a single-user rotation strategy.

What caused this issue, and how should it be resolved?

A. The single-user rotation strategy changes the password for the active user, which can cause connection failures for applications using cached credentials. Switch to a multi-user rotation strategy that alternates between two sets of credentials, allowing a transition period.

B. The rotation Lambda failed silently and the old credentials expired. Enable CloudWatch alarms on the rotation Lambda errors metric.

C. The Secrets Manager cache TTL was set too high, causing applications to use stale credentials. Reduce the cache TTL to match the rotation interval.

D. The database security group was blocking the rotation Lambda function from connecting to update the password.

**Correct Answer: A**

**Explanation:** Single-user rotation (A) changes the password of the current user immediately, which causes applications with cached credentials to fail until they fetch the new secret. The multi-user (alternating users) rotation strategy maintains two sets of credentials — when rotating, it updates the inactive set and swaps the active set label. This provides a smoother transition because the previous credentials remain valid until the next rotation. Options B and D describe potential rotation failures, but the scenario states rotation completed successfully. Option C is about cache TTL, but the root cause is the single-user strategy itself.

---

### Question 25

A financial company needs to implement a solution where specific S3 objects containing trade secrets are encrypted with a key that requires two separate administrators to authorize before it can be used for decryption. No single person should be able to decrypt the data alone.

Which approach implements this dual-control requirement?

A. Create a KMS key with a key policy requiring two IAM principals to call kms:Decrypt. Use IAM policy conditions with aws:MultiFactorAuthPresent for both users.

B. Use CloudHSM with quorum authentication (M-of-N access control) configured on the key. Require at least 2 out of N HSM users to authenticate before cryptographic operations can proceed.

C. Create two separate KMS keys. Encrypt the data twice — first with Key A, then with Key B. Grant Key A decrypt to Administrator 1 and Key B decrypt to Administrator 2. Both must decrypt in sequence.

D. Use AWS KMS with a custom key store and configure the CloudHSM cluster backing it with quorum authentication for key usage.

**Correct Answer: D**

**Explanation:** A KMS custom key store backed by CloudHSM with quorum authentication (D) provides true dual-control within the KMS ecosystem. CloudHSM supports M-of-N quorum authentication where multiple HSM users must approve operations. When combined with KMS custom key store, this provides the dual-control requirement while maintaining KMS integration for S3 encryption. Option A is not possible — KMS doesn't support multi-principal authorization for a single API call. Option B uses CloudHSM directly but loses KMS integration with S3. Option C is creative but operationally complex and doesn't provide true dual control at the key level.

---

### Question 26

A company wants to implement TLS mutual authentication (mTLS) for their API Gateway APIs to ensure that only authorized client applications can connect. They need to manage client certificates and validate them against a trusted CA.

Which solution implements mTLS with API Gateway?

A. Configure an API Gateway REST API with a custom authorizer Lambda function that extracts and validates the client certificate from the request headers.

B. Configure an API Gateway HTTP API with mutual TLS authentication. Upload a truststore (PEM file containing trusted CA certificates) to S3. Configure the API to reference this truststore for client certificate validation.

C. Use an NLB with TCP listeners in front of API Gateway and implement TLS termination at the NLB layer with client certificate validation.

D. Configure API Gateway with an ACM-issued client certificate and distribute it to all authorized client applications.

**Correct Answer: B**

**Explanation:** API Gateway HTTP APIs natively support mTLS (B). You upload a truststore containing trusted CA certificates to S3, and API Gateway validates client certificates against this truststore during the TLS handshake. This provides strong authentication ensuring only clients with certificates signed by the trusted CA can connect. Option A requires custom implementation and doesn't leverage native mTLS. Option C adds unnecessary complexity. Option D confuses API Gateway's backend client certificate (used for API GW to origin authentication) with client-to-API-GW mTLS.

---

### Question 27

A company needs to encrypt Amazon EFS file system data. The file system stores application logs that are written by multiple EC2 instances in an Auto Scaling group. They require encryption of data at rest AND in transit. The encryption keys must be customer managed.

Which configuration achieves both requirements?

A. Create an EFS file system with encryption at rest enabled using a customer managed KMS key. Mount the file system on EC2 instances using the EFS mount helper with TLS option (mount -t efs -o tls fs-id:/ /mnt/efs). Ensure security groups allow NFS traffic on port 2049.

B. Create an EFS file system with encryption at rest enabled using a customer managed KMS key. Mount using standard NFS mount commands. Enable the "encryption in transit" option in the EFS console.

C. Create an EFS file system without encryption. Use an encrypted SSH tunnel between EC2 instances and the EFS mount target for in-transit encryption.

D. Use AWS CloudHSM to encrypt files before writing them to EFS, providing both at-rest and in-transit encryption.

**Correct Answer: A**

**Explanation:** EFS encryption at rest (A) is configured at file system creation with a KMS key. Encryption in transit is enabled by mounting with the EFS mount helper using the -o tls option, which establishes a TLS tunnel for all NFS traffic. Both encryption layers work independently and together provide comprehensive protection. Option B is wrong because there is no console toggle for in-transit encryption — it must be specified at mount time. Option C adds operational complexity with custom SSH tunnels. Option D encrypts file content but doesn't provide native at-rest encryption for metadata or native in-transit encryption.

---

### Question 28

A company receives encrypted data files from partners via S3. Each partner encrypts their files using their own KMS key in their AWS account. The company needs to re-encrypt these files using their own KMS key for internal processing. The solution must handle files up to 50 GB efficiently.

Which approach provides the MOST efficient re-encryption?

A. For each file, download it from S3, decrypt it using the partner's KMS key (via cross-account access), and re-upload it encrypted with the company's KMS key using multipart upload with SSE-KMS.

B. Use S3 Batch Operations with the COPY operation specifying the company's KMS key as the new encryption key. Grant the S3 Batch Operations IAM role decrypt permissions on partner keys and encrypt permissions on the company's key.

C. Use the KMS ReEncrypt API to change the encryption key from the partner's key to the company's key without exposing the plaintext data.

D. Create an S3 replication rule on the partner's bucket to replicate to the company's bucket with encryption key override.

**Correct Answer: B**

**Explanation:** S3 Batch Operations COPY (B) efficiently re-encrypts objects at scale by copying them in place (or to a different bucket) with a new encryption key. It handles large files automatically and can process millions of objects. The IAM role needs decrypt on source keys and encrypt on the destination key. Option A works but is operationally heavy for large-scale processing. Option C (ReEncrypt) only works for data up to 4 KB — it operates on KMS-encrypted ciphertext directly, not on S3 objects with envelope encryption. Option D requires configuration in the partner's account and is designed for ongoing replication, not one-time re-encryption.

---

### Question 29

A company is implementing Secrets Manager for a blue/green deployment strategy. During deployment, both blue and green environments must access the same database credentials. When the green environment is promoted, the blue environment's access to secrets must be revoked immediately. The solution must be automated and integrated with CodeDeploy.

Which approach BEST integrates secret lifecycle management with blue/green deployments?

A. Use Secrets Manager resource policies that grant access based on EC2 instance tags (environment:blue or environment:green). Update the resource policy during the CodeDeploy lifecycle hook to revoke the blue environment's access after traffic shifts.

B. Create separate secret versions for blue and green environments. Use CodeDeploy hooks to update the AWSCURRENT staging label to point to the green version after promotion.

C. Use IAM roles with different permissions for blue and green instances. During CodeDeploy's AfterAllowTraffic hook, trigger a Lambda that updates the blue environment's IAM role to remove Secrets Manager access.

D. Store credentials in Parameter Store during deployment with a lifecycle policy that automatically removes the blue environment's parameters.

**Correct Answer: C**

**Explanation:** Using IAM roles with CodeDeploy lifecycle hooks (C) provides clean integration. Blue and green environments use different IAM roles. After the AfterAllowTraffic hook confirms the green environment is healthy, a Lambda function modifies the blue environment's IAM role to remove Secrets Manager permissions, immediately revoking access. This is automated via CodeDeploy hooks. Option A relies on instance tags for secret access, which is less reliable than IAM roles. Option B misuses staging labels — AWSCURRENT should always point to the latest valid credential, not be environment-specific. Option D moves to Parameter Store, losing Secrets Manager's rotation features.

---

### Question 30

A company needs to implement field-level encryption using CloudFront to protect sensitive form fields (credit card numbers, SSN) before they reach the origin server. Only a specific backend microservice should be able to decrypt these fields.

Which implementation correctly uses CloudFront field-level encryption?

A. Configure a CloudFront field-level encryption profile with an RSA public key. Specify which POST body fields to encrypt. Associate the profile with a cache behavior. The origin receives the request with specified fields encrypted using the public key. Only the backend microservice with the corresponding private key can decrypt.

B. Configure CloudFront with an ACM certificate that has field-level encryption enabled. All form fields are automatically encrypted.

C. Use Lambda@Edge to encrypt specific fields in the POST body before forwarding to the origin. Store the encryption key in Secrets Manager.

D. Enable CloudFront HTTPS-only with origin protocol policy set to HTTPS. This provides field-level protection through TLS.

**Correct Answer: A**

**Explanation:** CloudFront field-level encryption (A) uses an RSA public key to encrypt specific POST body fields at the CloudFront edge before forwarding to the origin. You configure an encryption profile specifying which fields to encrypt and which public key to use. The origin receives the request with those fields as RSA-encrypted ciphertext. Only the service with the corresponding RSA private key can decrypt the sensitive fields. This provides defense-in-depth beyond TLS. Option B doesn't exist as an ACM feature. Option C adds custom Lambda overhead for something CloudFront does natively. Option D provides transport encryption but doesn't protect fields within the application layer.

---

### Question 31

A company runs a legacy application that uses hardcoded database credentials in configuration files on EC2 instances. They want to migrate to Secrets Manager but cannot modify the application code. The application reads credentials from /etc/app/db.conf in the format: host=x, port=y, user=z, password=w.

Which approach migrates to Secrets Manager WITHOUT application code changes?

A. Use a startup script (via user data or systemd) that retrieves the secret from Secrets Manager using the AWS CLI, formats it into the expected configuration file format, and writes it to /etc/app/db.conf before the application starts. Configure IAM instance profile with Secrets Manager read permissions.

B. Create a symbolic link from /etc/app/db.conf to a Secrets Manager endpoint.

C. Use the Secrets Manager agent, a client-side daemon that caches secrets and exposes them as local files.

D. Modify the application's systemd unit to pass secrets as environment variables sourced from Secrets Manager.

**Correct Answer: A**

**Explanation:** A startup script (A) that fetches the secret and writes it in the application's expected configuration format provides seamless migration without code changes. The script runs before the application starts, so the application finds its expected configuration file with current credentials. The IAM instance profile provides secure authentication to Secrets Manager. Option B is not possible — you cannot mount Secrets Manager as a file system. Option C (Secrets Manager agent) is a real feature but exposes secrets via a local HTTP endpoint, not as configuration files in a specific format. Option D requires changing how the application reads credentials, which contradicts the "no code changes" requirement.

---

### Question 32

A company is implementing AWS Certificate Manager to manage TLS certificates for their microservices architecture. They have 200 internal services communicating over gRPC. Each service needs a unique certificate for mTLS. The certificates must be automatically renewed and distributed to services running on ECS Fargate.

Which solution provides automated certificate lifecycle management for this architecture?

A. Create an ACM Private CA. Use AWS Private CA short-lived certificate mode for cost optimization. Implement a sidecar container in each ECS task that uses the ACM Private CA API to issue and auto-renew certificates, storing them in the task's ephemeral storage.

B. Create an ACM Private CA. Issue certificates manually for each service and import them into ACM. Configure ECS to use the ACM certificates.

C. Use ACM public certificates for each service and configure auto-renewal.

D. Deploy a self-signed certificate generator as a Lambda function that creates and distributes certificates to all services via S3.

**Correct Answer: A**

**Explanation:** ACM Private CA with short-lived certificate mode (A) is designed for high-volume, automated certificate issuance. Short-lived certificates (7 days or less) are significantly cheaper ($400/month unlimited vs. $0.75 per certificate). A sidecar container handles the certificate lifecycle — requesting, installing, and renewing certificates automatically. This pattern works well with ECS Fargate's ephemeral storage. Option B is not scalable for 200 services with manual operations. Option C uses public certificates for internal services, exposing internal service names and adding unnecessary cost. Option D creates a custom PKI without proper certificate management.

---

### Question 33

A company's applications use a KMS CMK for S3 server-side encryption. The key was created 5 years ago and has never been rotated. The security team wants to enable rotation immediately. They're concerned about what happens to data encrypted with the original key material after rotation is enabled.

Which statement accurately describes KMS automatic key rotation behavior?

A. When automatic rotation is enabled, KMS rotates the key material annually. All existing data must be re-encrypted with the new key material, or it becomes inaccessible.

B. When automatic rotation is enabled, KMS generates new key material annually. The CMK ID and ARN remain the same. KMS retains all previous key material versions indefinitely, so existing encrypted data remains accessible. New encryption operations use the latest key material. No re-encryption of existing data is needed.

C. Automatic rotation changes the CMK's key ID and ARN annually. Applications must be updated to reference the new key.

D. Automatic rotation re-encrypts all S3 objects automatically using the new key material during the rotation window.

**Correct Answer: B**

**Explanation:** KMS automatic rotation (B) generates new cryptographic material annually while keeping the same CMK ID, ARN, and alias. All previous key material versions are retained indefinitely by KMS, so existing ciphertext encrypted with older versions can always be decrypted. New Encrypt/GenerateDataKey operations automatically use the latest key material. This is transparent to applications — no changes needed, no re-encryption required. Option A is incorrect — existing data remains accessible. Option C is wrong — key IDs don't change. Option D is wrong — S3 objects are not automatically re-encrypted.

---

### Question 34

A company is building a data lake on S3. Different departments need to encrypt their data with different KMS keys. The data engineering team needs to query across all departments' data using Athena. The solution must allow cross-department queries without giving the data engineering team access to all department KMS keys.

Which architecture enables cross-department Athena queries with department-level encryption isolation?

A. Use S3 bucket keys for each department. Create KMS grants that allow the Athena service role to use all department keys for decrypt operations. The grants are revocable and auditable.

B. Use a single S3 bucket with department-specific prefixes. Encrypt each prefix with a different KMS key using S3 bucket key configuration. Grant the Athena execution role kms:Decrypt on all department KMS keys via IAM policy.

C. Create a materialized view layer that decrypts and re-encrypts all department data with a shared analytics key in a separate S3 location that Athena queries.

D. Configure Athena with per-workgroup encryption settings that automatically handle cross-key decryption.

**Correct Answer: B**

**Explanation:** Using department-specific prefixes with different KMS keys (B) and granting the Athena execution role decrypt permissions on all keys is the most straightforward approach. S3 bucket keys reduce KMS API costs. The Athena role needs decrypt on all keys because Athena must read data from all departments. IAM policies provide auditable access control. Option A's KMS grants work similarly to IAM policies but KMS grants are more complex to manage at scale. Option C creates data duplication and a complex ETL pipeline. Option D doesn't exist — Athena workgroup encryption settings control output encryption, not input decryption.

---

### Question 35

A regulated company must ensure that all AWS API calls within their organization are encrypted using TLS 1.2 or higher. They need to prevent any service from accepting requests over older TLS versions and enforce this across all accounts.

Which combination of controls enforces TLS 1.2 minimum across the organization? (Choose TWO.)

A. Apply an SCP that denies all actions unless the condition aws:SecureTransport is true and s3:TlsVersion is 1.2 or higher.

B. Configure VPC endpoint policies to require TLS 1.2 for all traffic through VPC endpoints.

C. Apply S3 bucket policies with a condition of aws:SecureTransport: true and s3:TlsVersion >= 1.2 on all buckets using organizational S3 policies.

D. Apply an SCP that denies s3:* actions with a condition where s3:TlsVersion is less than 1.2, and configure the SDK in all applications to use TLS 1.2 minimum.

E. Use AWS Config to detect API calls made over TLS versions less than 1.2 via CloudTrail log analysis, and create alerts for non-compliance.

**Correct Answer: D, E**

**Explanation:** SCPs with the s3:TlsVersion condition (D) can enforce minimum TLS version for S3 operations across the organization. However, s3:TlsVersion is S3-specific — for other services, ensuring applications use TLS 1.2+ requires client-side configuration. AWS SDKs since 2020 default to TLS 1.2+. Option E provides detective monitoring to identify any legacy clients using older TLS versions via CloudTrail's tlsDetails field. Option A incorrectly combines aws:SecureTransport with s3:TlsVersion in a way that wouldn't work for non-S3 services. Option B — VPC endpoint policies don't have TLS version conditions. Option C works for S3 but requires per-bucket policies, not organization-wide enforcement.

---

### Question 36

A company operates an e-commerce platform and needs to store PCI DSS compliant payment card data. They must encrypt cardholder data with keys stored in FIPS 140-2 Level 3 HSMs, implement key ceremony procedures, and maintain separation of duties between key custodians and system administrators.

Which AWS architecture satisfies these PCI DSS encryption requirements?

A. Use AWS KMS with customer managed keys and tag-based access control to separate key custodians from system administrators.

B. Deploy a CloudHSM cluster across multiple AZs. Implement role separation using CloudHSM crypto users (CU) for key operations and crypto officers (CO) for key management. Use quorum authentication for sensitive operations. Integrate with the application via PKCS#11 or JCE providers.

C. Use AWS KMS custom key store backed by CloudHSM. Use KMS key policies for role separation and CloudHSM quorum authentication for key ceremonies.

D. Use server-side encryption with S3 managed keys (SSE-S3) and implement PCI compliance at the application layer.

**Correct Answer: C**

**Explanation:** KMS custom key store backed by CloudHSM (C) provides FIPS 140-2 Level 3 (via CloudHSM) while maintaining KMS integration for ease of use. CloudHSM's role separation (CO for management, CU for operations) and quorum authentication satisfy PCI DSS key ceremony and separation of duties requirements. KMS key policies add another layer of access control. Option A uses KMS alone, which is FIPS Level 2. Option B works but loses KMS integration benefits. Option D (SSE-S3) provides no customer control over keys and doesn't meet PCI HSM requirements.

---

### Question 37

A company has an application that uses AWS Secrets Manager to store third-party API tokens. The tokens are valid for 90 days and must be refreshed by calling the third-party provider's API to obtain new tokens. The third-party API requires an API key and secret that are also stored in Secrets Manager.

Which rotation strategy correctly implements this cascading secret dependency?

A. Create a custom rotation Lambda function that: (1) Retrieves the third-party API credentials from Secrets Manager, (2) Calls the third-party API to generate a new token, (3) Stores the new token in Secrets Manager. Configure rotation at 80-day intervals. Set the third-party API credentials secret as an environment variable on the Lambda function.

B. Create a custom rotation Lambda that retrieves the third-party API credentials from Secrets Manager using a secondary secret ARN passed as an environment variable. The Lambda calls the third-party API to generate a new token and updates the rotated secret. Implement proper error handling that distinguishes between third-party API failures and Secrets Manager failures. Set rotation to 80 days.

C. Create a Step Functions workflow triggered on a schedule that orchestrates the token refresh by calling separate Lambda functions for retrieving credentials, calling the third-party API, and storing the new token.

D. Use Secrets Manager's built-in rotation template for third-party tokens, which handles cascading dependencies automatically.

**Correct Answer: B**

**Explanation:** Custom rotation Lambda (B) correctly handles the dependency by retrieving the third-party API credentials from Secrets Manager (not environment variables) during rotation. This ensures it always uses the current API credentials, even if they've been rotated. Proper error handling distinguishes failure modes — the third-party API might be down vs. Secrets Manager access issues. 80-day rotation for 90-day tokens provides a safety buffer. Option A incorrectly stores API credentials as Lambda environment variables, which bypasses Secrets Manager's secret management and rotation. Option C adds orchestration complexity. Option D doesn't exist — there's no built-in template for arbitrary third-party token rotation.

---

### Question 38

A company needs to implement data classification tags on KMS keys that propagate to all resources encrypted with those keys. They want to enforce that "Confidential" classified data can only be encrypted with keys tagged as "Classification:Confidential" and track compliance across their environment.

Which solution enforces data classification alignment between KMS keys and encrypted resources?

A. Create SCPs with condition keys that match KMS key tags to resource tags. Deny encryption operations where the key's Classification tag doesn't match the resource's Classification tag.

B. Use IAM policies with the kms:ResourceTag condition key to restrict which KMS keys can be used based on the key's tags. Combine with AWS Config custom rules that verify resources are encrypted with appropriately classified keys.

C. Implement attribute-based access control (ABAC) using IAM policies with conditions that check both the KMS key tag (aws:ResourceTag/Classification) and the resource tag. Configure policies that only allow kms:GenerateDataKey and kms:Encrypt when the principal's session tags match the key's classification tag.

D. Use AWS Tag Policies via Organizations to enforce consistent Classification tags on KMS keys and Config rules to verify encrypted resources use correctly classified keys.

**Correct Answer: C**

**Explanation:** ABAC with session tags and KMS resource tags (C) provides dynamic, scalable enforcement. IAM policies can condition KMS operations on both the key's tags and the principal's attributes (session tags from SAML/OIDC or STS). This ensures a principal working on "Confidential" data (via session tag) can only use "Confidential" KMS keys. Option A is incorrect — SCPs don't have the ability to compare tags across different resource types in a single condition. Option B partially works but kms:ResourceTag alone doesn't enforce the matching. Option D enforces tag consistency but not the relationship between key classification and data classification.

---

### Question 39

A company is migrating from on-premises PKI to ACM Private CA. They have an existing three-tier CA hierarchy: Root CA → Intermediate CA → Issuing CA. They need to maintain the same hierarchy in AWS and ensure existing certificates issued by the on-premises PKI remain valid during the migration period.

Which migration approach maintains certificate continuity?

A. Create a new root CA in ACM Private CA. Create subordinate CAs matching the existing hierarchy. Revoke all existing certificates and reissue them from the new PKI.

B. Export the existing root CA's private key and import it into ACM Private CA to create an identical root CA. Recreate the intermediate and issuing CAs as subordinate CAs in ACM Private CA.

C. Create the root CA and intermediate CA as external to ACM (maintain them on-premises). Create the issuing CA in ACM Private CA as a subordinate of the on-premises intermediate CA by generating a CSR in ACM Private CA and signing it with the on-premises intermediate CA.

D. Use ACM Private CA to create a new standalone issuing CA and configure applications to trust both the old and new CA certificates during migration.

**Correct Answer: C**

**Explanation:** Creating the issuing CA in ACM Private CA as a subordinate of the on-premises intermediate CA (C) maintains certificate chain continuity. The CSR generated by ACM Private CA is signed by the existing on-premises intermediate CA, so the new issuing CA is part of the existing trust hierarchy. Existing certificates remain valid because the root trust anchor hasn't changed. New certificates issued by the ACM Private CA issuing CA are also trusted because they chain up to the same root. Option A breaks all existing certificates. Option B is possible in concept but ACM Private CA doesn't support importing root CA private keys. Option D creates two separate trust hierarchies.

---

### Question 40

A company is building a data pipeline where S3 objects are processed by Lambda functions. Each object is encrypted with SSE-KMS. The pipeline processes 10 million small objects per day. They are experiencing KMS throttling errors (ThrottlingException) that cause Lambda invocations to fail.

Which combination of approaches MOST effectively addresses the throttling? (Choose TWO.)

A. Enable S3 Bucket Keys on the bucket. This reduces KMS API calls by using a bucket-level key to create data keys, reducing the per-object KMS calls for S3 operations.

B. Request a KMS API rate limit increase through AWS Support for the account and Region.

C. Switch from SSE-KMS to SSE-S3 encryption, which doesn't use KMS.

D. Implement exponential backoff with jitter in the Lambda function for KMS API calls and increase the Lambda concurrency limit.

E. Use the AWS Encryption SDK with data key caching in the Lambda function, setting a maximum age and message threshold for cached keys.

**Correct Answer: A, E**

**Explanation:** S3 Bucket Keys (A) significantly reduce KMS API calls by creating a time-limited bucket-level key that S3 uses to generate per-object data keys locally, rather than calling KMS for every object. This can reduce KMS requests by up to 99%. Data key caching with the Encryption SDK (E) in Lambda further reduces KMS calls by reusing data keys across multiple encryption operations within the Lambda execution environment. Option B is reactive and may not be sufficient. Option C removes KMS-based encryption, which may violate compliance requirements. Option D handles throttling gracefully but doesn't reduce the API call volume.

---

### Question 41

A company operates in the EU and must comply with GDPR's right to erasure (right to be forgotten). Customer data is encrypted with KMS and stored across S3, DynamoDB, and RDS. When a customer requests deletion, the company needs to ensure all their data is irrecoverably destroyed.

Which approach provides the STRONGEST guarantee of data erasure while being operationally feasible?

A. Delete the customer's records from all data stores and rely on S3 object deletion, DynamoDB item deletion, and RDS row deletion to remove the data.

B. Use per-customer KMS CMKs. When a customer requests deletion, schedule the customer's KMS key for deletion (7-day minimum waiting period), making all their encrypted data irrecoverably unreadable. Also delete the actual records as a defense-in-depth measure.

C. Delete all data records and then rotate the KMS key used for encryption, which invalidates access to the old key material.

D. Overwrite customer records with random data before deletion to ensure the original data cannot be recovered from storage media.

**Correct Answer: B**

**Explanation:** Crypto-shredding with per-customer KMS keys (B) provides the strongest guarantee. Scheduling the key for deletion makes all data encrypted with that key irrecoverably unreadable, regardless of where copies might exist (backups, replicas, snapshots). The 7-day waiting period satisfies the "without undue delay" GDPR requirement. Deleting actual records as well provides defense-in-depth. Option A doesn't address backup copies, snapshots, or replicated data. Option C is wrong — KMS rotation retains old key material for decrypting existing data. Option D is impractical across multiple services and doesn't address backups.

---

### Question 42

A company needs to implement a centralized secrets management strategy for a hybrid environment. Applications run both on-premises and on AWS. On-premises applications use Java and .NET, while AWS applications use various services. All secrets must be centrally managed, rotated, and audited.

Which architecture provides unified secrets management across hybrid environments?

A. Use AWS Secrets Manager for all secrets. On-premises applications access secrets through the Secrets Manager API via AWS Direct Connect or VPN. Use the AWS SDK for Java and .NET to retrieve secrets. IAM roles for hybrid environments (using IAM Roles Anywhere with X.509 certificates) provide authentication for on-premises applications.

B. Deploy HashiCorp Vault on-premises and synchronize secrets to AWS Secrets Manager for cloud applications.

C. Use AWS Systems Manager Parameter Store with SecureString parameters and provide on-premises applications access via API calls over VPN.

D. Store all secrets in an encrypted DynamoDB table and provide API access for both on-premises and cloud applications.

**Correct Answer: A**

**Explanation:** Secrets Manager with IAM Roles Anywhere (A) provides a unified solution. IAM Roles Anywhere allows on-premises applications to obtain temporary AWS credentials using X.509 certificates, eliminating the need for long-term access keys. Applications use the standard AWS SDK to retrieve secrets, and all access is audited through CloudTrail. Direct Connect or VPN provides private network connectivity. Option B introduces a separate system requiring synchronization. Option C uses Parameter Store which has less sophisticated rotation capabilities. Option D requires building a custom secrets management system.

---

### Question 43

A company has been using AWS KMS with a single CMK for all S3 encryption across 50 accounts for three years. A security audit reveals that this key has been used for over 100 billion encrypt operations and the key policy grants overly broad access. The security team wants to improve the security posture without disrupting existing applications.

Which phased improvement plan BEST enhances security while minimizing disruption?

A. Immediately create new CMKs per service and re-encrypt all S3 objects. Update all applications to use new keys. Delete the old key.

B. Phase 1: Enable automatic key rotation on the existing CMK. Phase 2: Tighten the key policy using CloudTrail analysis to identify actual key users and restrict to least privilege. Phase 3: Create service-specific CMKs for new workloads. Phase 4: Gradually migrate existing workloads to service-specific keys using S3 Batch Operations for re-encryption. Phase 5: After full migration, schedule the old CMK for deletion.

C. Create a new CMK with restrictive policies and use S3 default encryption to apply it to all new objects. Leave existing objects encrypted with the old key indefinitely.

D. Replace the single CMK with a CloudHSM-backed custom key store for improved security, migrating all applications at once.

**Correct Answer: B**

**Explanation:** A phased approach (B) systematically improves security while minimizing risk. Enabling rotation first addresses key material freshness. Tightening the policy based on CloudTrail data ensures only legitimate users are granted access. Creating service-specific keys for new workloads stops the sprawl. Gradual migration via S3 Batch Operations re-encrypts existing data methodically. Option A is high-risk — immediate changes across 50 accounts could cause widespread outages. Option C improves new objects but leaves the overly permissive key in place for all existing data. Option D is a disruptive big-bang migration.

---

### Question 44

A company's security team discovers that developers have been creating KMS keys without proper tagging, making it impossible to attribute key costs or determine key ownership. There are currently 500 untagged keys across the organization. They need to prevent this going forward and remediate existing keys.

Which solution addresses both prevention and remediation?

A. Create an SCP that denies kms:CreateKey unless the request includes required tags (aws:RequestTag conditions for Department, Environment, and Owner). Deploy a Config rule that identifies existing untagged keys. Use a Lambda function triggered by Config non-compliance to cross-reference key ARNs with CloudTrail creator information and apply appropriate tags.

B. Use AWS Tag Policies to enforce mandatory tags on KMS keys and manually tag existing keys.

C. Create an IAM policy in each account that requires tagging for key creation and use AWS Tag Editor to find and tag existing keys.

D. Disable KMS key creation for all users and require them to submit a request form that auto-creates properly tagged keys.

**Correct Answer: A**

**Explanation:** SCPs with aws:RequestTag conditions (A) preventively enforce tagging at key creation across the organization. The Config rule detects existing non-compliant keys, and the Lambda function intelligently applies tags using CloudTrail data to identify key creators. This addresses both prevention and remediation comprehensively. Option B's Tag Policies enforce tag format consistency but don't prevent untagged resource creation as strongly as SCPs. Option C requires per-account IAM policy management. Option D disrupts development workflows and adds bureaucratic overhead.

---

### Question 45

A company has ACM certificates deployed on ALBs across 20 accounts. Several certificates have expired in the past, causing outages. ACM auto-renewal failed because DNS validation records were not accessible from the accounts where certificates were created.

Which solution prevents future certificate expiration issues?

A. Switch from DNS validation to email validation for all certificates and set up monitoring for renewal emails.

B. Consolidate all DNS records into a single Route 53 hosted zone in a central networking account. Delegate certificate DNS validation subdomains to this zone. ACM in each account creates validation records via cross-account Route 53 access, enabling automatic renewal.

C. Create a Lambda function that runs monthly to check certificate expiration dates and manually renews certificates that are close to expiring.

D. Replace ACM certificates with self-signed certificates that have longer validity periods.

**Correct Answer: B**

**Explanation:** Centralizing DNS in Route 53 (B) ensures ACM can always access the DNS zone to create or update validation records during renewal. Cross-account Route 53 access (using resource-based policies on the hosted zone) allows ACM in any account to manage validation records. This enables fully automatic renewal without manual intervention. Option A uses email validation, which requires human action and is unreliable. Option C adds manual overhead and doesn't address the root cause — DNS inaccessibility. Option D introduces security and management risks with self-signed certificates.

---

### Question 46

A company has been using the same CloudHSM cluster for 4 years. They want to upgrade to a newer generation of CloudHSM instances for improved performance. They need to migrate all keys without any downtime for applications that depend on the HSM.

Which migration approach provides zero-downtime key migration?

A. Create a new CloudHSM cluster. Export all keys from the old cluster using the key_mgmt_util extractMaskedObject command. Import the wrapped keys into the new cluster. Update application configurations to point to the new cluster. Decommission the old cluster.

B. Add new-generation HSM instances to the existing cluster. Remove old-generation instances one at a time as keys synchronize to new instances. The cluster automatically handles key distribution.

C. Use AWS Backup to create a backup of the old cluster and restore it to a new cluster with updated instance types.

D. Contact AWS Support to perform an in-place upgrade of the HSM instances within the existing cluster.

**Correct Answer: B**

**Explanation:** Adding new-generation HSMs to the existing cluster (B) leverages CloudHSM's automatic intra-cluster synchronization. All keys are automatically distributed to new instances. Once synchronized, old instances can be removed one by one without disruption, as the cluster endpoint routes operations to available instances. This provides zero downtime. Option A requires application changes and has a migration window. Option C — CloudHSM backup/restore creates a new cluster but doesn't upgrade instance types within the restore process. Option D — in-place instance upgrades are not a supported AWS operation for CloudHSM.

---

### Question 47

A company uses Secrets Manager to manage credentials for 200 microservices on ECS. They notice that secret retrieval latency spikes during deployments when all services start simultaneously and each fetches its secrets. This creates a "thundering herd" problem overwhelming the Secrets Manager API.

Which solution MOST effectively mitigates the thundering herd during deployments?

A. Increase the Secrets Manager API throttling limits by contacting AWS Support.

B. Implement a deployment strategy that staggers service startups with jittered delays. Use the Secrets Manager client-side caching library in each service with a warm-up phase. For ECS, configure the deployment circuit breaker with rolling updates limited to 10% of services at a time.

C. Cache all secrets in an ElastiCache Redis cluster and have services read from Redis during startup.

D. Pre-fetch all secrets during the CI/CD pipeline and inject them as ECS task definition environment variables.

**Correct Answer: B**

**Explanation:** Staggering deployments with jitter (B) and rolling updates limited to 10% at a time naturally spreads the API load over time. The caching library ensures subsequent secret access doesn't hit the API. The deployment circuit breaker prevents cascading failures. This combination addresses both the spike and ongoing performance. Option A is reactive and doesn't solve the architectural issue. Option C introduces a security concern — secrets in Redis need their own encryption and access control. Option D exposes secrets in task definitions, which are visible in the ECS console and API, violating security best practices.

---

### Question 48

A company has migrated to AWS and uses KMS for encryption. Post-migration, they realize they are spending significantly on KMS API calls due to an application that makes individual Encrypt API calls for each small message (averaging 200 bytes) in a high-throughput messaging system processing 50,000 messages per second.

Which optimization reduces KMS costs while maintaining encryption for all messages?

A. Switch to the KMS Decrypt API with pre-generated ciphertexts to reduce cost.

B. Implement envelope encryption using the AWS Encryption SDK with data key caching. Generate one data key and use it to encrypt multiple messages locally, only calling KMS when the cached key expires or reaches its usage threshold. Set max age to 5 minutes and max messages to 1,000,000.

C. Use server-side encryption at the messaging layer (e.g., SQS SSE-KMS with S3 bucket keys) instead of client-side encryption.

D. Reduce message volume by batching messages before encryption.

**Correct Answer: B**

**Explanation:** Data key caching with envelope encryption (B) dramatically reduces KMS API calls. Instead of 50,000 KMS API calls per second (4.3 billion per month, costing ~$12,900/month at $0.03 per 10,000 requests), caching a data key for 5 minutes or 1 million messages would reduce KMS calls to approximately 50 per minute (instead of 3 million per minute), cutting costs by over 99.99%. Option A doesn't reduce API calls. Option C might help but changes the encryption model. Option D delays message processing.

---

### Question 49

A company has ACM certificates on CloudFront distributions serving content globally. They want to monitor certificate transparency logs to detect if any unauthorized certificates are issued for their domains. This is a security requirement to detect potential MitM attacks.

Which solution provides certificate transparency monitoring?

A. Enable AWS Certificate Manager certificate transparency logging for all issued certificates. Use Amazon EventBridge to detect certificate transparency log submissions and alert on any certificates not issued by ACM.

B. Subscribe to Google Certificate Transparency log feeds and parse them with a Lambda function to detect certificates for the company's domains.

C. Use AWS GuardDuty to monitor for unauthorized TLS certificates being used against the company's domains.

D. Configure CAA (Certificate Authority Authorization) DNS records that restrict which CAs can issue certificates for the company's domains, and use Route 53 health checks to verify certificate validity.

**Correct Answer: A**

**Explanation:** ACM integrates with certificate transparency logging (A). When certificates are issued, they are submitted to public CT logs. EventBridge can detect new CT log entries for your domains. By alerting on certificates you didn't request, you can identify potentially fraudulent certificates. Option B works but requires building and maintaining a custom CT log monitoring system. Option C doesn't monitor certificate transparency. Option D (CAA records) is a preventive control that restricts issuance but doesn't detect unauthorized certificates that bypass CAA checks (some CAs may not check CAA).

---

### Question 50

A SaaS company wants to allow enterprise customers to use their own KMS keys for encrypting their data (Customer Managed Keys / BYOK). The SaaS application runs in the provider's AWS account, and customer data is stored in S3 and DynamoDB.

Which architecture allows customers to maintain control of their encryption keys while the SaaS application operates normally?

A. Use KMS cross-account key sharing. Customers create CMKs in their accounts and grant the SaaS application's IAM role kms:Encrypt, kms:Decrypt, and kms:GenerateDataKey permissions via key policies. The SaaS application references each customer's key ARN when performing encryption operations.

B. Have customers import their key material into keys created in the SaaS provider's account using KMS imported key material feature.

C. Use AWS KMS External Key Store (XKS) where each enterprise customer operates their own external key manager, and the SaaS provider creates XKS keys linked to each customer's key manager.

D. Create KMS keys in the SaaS provider's account and share them with customers via RAM for auditing purposes only.

**Correct Answer: A**

**Explanation:** Cross-account key sharing (A) gives customers full control — they own the key, manage the policy, can revoke access at any time, and see all usage in their own CloudTrail. The SaaS provider's IAM role is granted only usage permissions (not management), maintaining least privilege. Customers can audit who uses their key via CloudTrail. Option B gives control of key material to the customer but the key exists in the SaaS provider's account, giving the provider more control than desired. Option C is complex and requires each customer to run an external key manager. Option D doesn't allow customers to control their own keys.

---

### Question 51

A company's AWS Config dashboard shows that 30% of their EBS volumes are unencrypted, violating their security policy. They need to encrypt these volumes with minimal service disruption. The volumes are attached to running EC2 instances.

Which approach encrypts the existing EBS volumes with the LEAST disruption?

A. Stop each EC2 instance, detach the unencrypted volume, create an encrypted snapshot from the unencrypted volume, create a new encrypted volume from the snapshot, attach it to the instance, and start the instance.

B. Create a snapshot of each unencrypted volume. Copy the snapshot with encryption enabled (specifying a KMS key). Create new encrypted volumes from the encrypted snapshots. Stop the instance briefly, swap the volumes (detach old, attach new), and start the instance. Automate with Systems Manager Automation.

C. Enable EBS encryption by default in the account and reboot all instances. EBS automatically encrypts existing volumes during reboot.

D. Use AWS Elastic Disaster Recovery to replicate instances with encrypted volumes and fail over.

**Correct Answer: B**

**Explanation:** Snapshot-copy-replace (B) minimizes disruption. You create snapshots while instances are running (no downtime for snapshot creation). Copy the snapshot with encryption. Create new volumes. The only downtime is the brief swap operation (stop, detach, attach, start). SSM Automation can orchestrate this across hundreds of volumes. Option A has more downtime because it includes the snapshot creation time while the instance is stopped. Option C is wrong — enabling default encryption only applies to NEW volumes, it doesn't encrypt existing ones. Option D is massive overkill for volume encryption.

---

### Question 52

A company uses AWS Secrets Manager with automatic rotation for RDS Aurora PostgreSQL credentials. After enabling rotation, they notice that their application occasionally throws "FATAL: password authentication failed" errors. The errors are intermittent and self-resolving within a few seconds.

What is the root cause, and how should it be addressed?

A. The application's connection pool is stale. Configure the connection pool to validate connections before use and implement retry logic with exponential backoff. Also ensure the rotation Lambda's testSecret step properly validates the new credentials before finalizing.

B. The rotation Lambda has insufficient timeout configured. Increase the Lambda timeout to allow more time for credential propagation.

C. Aurora read replicas have replication lag causing the new password to not be immediately available on all endpoints. Use the cluster writer endpoint exclusively.

D. The Secrets Manager cache is returning the old credential version. Reduce the cache TTL to 0 seconds.

**Correct Answer: A**

**Explanation:** Intermittent authentication failures during rotation (A) typically occur because the application's database connection pool holds connections authenticated with the old credentials. When the pool is exhausted and new connections are attempted with stale cached credentials, they fail. Connection pool validation (test-on-borrow) detects invalid connections and refreshes them. Retry logic handles the brief window during rotation. The testSecret step verification ensures credentials work before the rotation finalizes. Option B — rotation Lambda timeout wouldn't cause intermittent client errors. Option C — password changes propagate via the cluster, not replication. Option D would cause excessive API calls and throttling.

---

### Question 53

A company wants to implement a "break glass" procedure for emergency access to KMS-encrypted production data. During normal operations, only automated systems should access the data. In emergencies, a senior engineer should be able to decrypt data, but only with proper approval, logging, and time constraints.

Which architecture implements a secure break-glass procedure?

A. Create a separate "break glass" KMS key for emergency use. Store the key's ARN in a sealed Secrets Manager secret. Grant decrypt permissions only to a specific IAM role. Require the engineer to assume the role via STS with MFA and session tags indicating the emergency ticket. Configure CloudTrail to alert on any usage of this key. Set the IAM role's maximum session duration to 1 hour.

B. Give senior engineers permanent decrypt access to the production KMS key but monitor usage via CloudTrail.

C. Store the KMS key material in a physical safe. In emergencies, import it into a temporary KMS key.

D. Use an approval-based workflow in ServiceNow to grant temporary IAM permissions to the production KMS key.

**Correct Answer: A**

**Explanation:** A dedicated break-glass key with stringent controls (A) provides defense-in-depth. The separate key ensures normal automated processes aren't affected. MFA requirement adds authentication strength. Session tags linking to an emergency ticket provide audit context. Short maximum session duration limits the window of access. CloudTrail alerts ensure visibility. Option B grants permanent access, which violates least privilege. Option C is impractical — KMS key import is slow and complex. Option D relies on an external system with potential delays during emergencies, and granting access to the production key is riskier than having a separate emergency key.

---

### Question 54

A company is migrating their on-premises Oracle database to AWS Aurora PostgreSQL. The database contains sensitive financial data encrypted with Oracle Transparent Data Encryption (TDE). The migration must maintain encryption throughout the process — data should never exist unencrypted, even during transfer.

Which migration approach maintains continuous encryption?

A. Use AWS Database Migration Service (DMS) with SSL/TLS encryption for the replication connection. DMS decrypts from Oracle TDE source and re-encrypts using Aurora's KMS encryption during the write. Enable the DMS endpoint SSL mode to verify-full for the source Oracle connection.

B. Export the data from Oracle using Data Pump with encryption, transfer the encrypted dump files to S3 via AWS Transfer Family with SFTP, then import into Aurora.

C. Use AWS Schema Conversion Tool (SCT) with data extractors to move data to S3 encrypted with KMS, then load into Aurora using the aws_s3 extension.

D. Set up a direct connection between Oracle TDE and Aurora encryption, allowing transparent re-encryption during migration.

**Correct Answer: A**

**Explanation:** DMS with SSL/TLS (A) maintains encryption throughout migration. The connection from DMS to Oracle uses SSL (encrypted in transit). DMS reads the data (Oracle TDE decrypts at the database layer during read), and DMS immediately writes to Aurora, which encrypts at rest via KMS. The DMS replication instance itself can be encrypted. verify-full SSL mode ensures the Oracle endpoint's identity is verified. Data is never stored unencrypted — it moves from Oracle TDE → TLS tunnel → DMS (temporary, in encrypted instance) → TLS → Aurora KMS encryption. Option B creates unencrypted data during Oracle export before encryption. Option C adds complexity with S3 staging. Option D doesn't exist as a feature.

---

### Question 55

A company is migrating from an on-premises HSM appliance to AWS CloudHSM. They have 10,000 RSA key pairs used for document signing in a legal application. The migration must preserve all existing key pairs because historically signed documents must be verifiable against the original signing keys.

Which migration approach preserves existing RSA key pairs?

A. Use the CloudHSM key_mgmt_util or cloudhsm_mgmt_util tools to wrap (export) keys from the source HSM using a common wrapping key, transfer the wrapped keys, and unwrap (import) them into CloudHSM. Establish a wrapping key agreement between the source and target HSMs first.

B. Generate new RSA key pairs in CloudHSM and re-sign all historical documents with the new keys.

C. Use AWS Key Management Service to import the key material from the on-premises HSM, then transfer to CloudHSM via a custom key store.

D. Extract the raw private keys from the on-premises HSM and import them directly into CloudHSM using the PKCS#11 interface.

**Correct Answer: A**

**Explanation:** Key wrapping (A) is the standard method for securely migrating keys between HSMs. The source HSM exports keys wrapped (encrypted) with a wrapping key, ensuring private keys are never exposed in plaintext. The wrapping key is established between source and target HSMs through a secure key exchange. CloudHSM's key management utilities support importing wrapped keys. This preserves the original key pairs. Option B loses the ability to verify historical signatures — unacceptable for legal documents. Option C is incorrect — KMS imported key material doesn't transfer to CloudHSM. Option D is incorrect — proper HSMs don't allow raw private key extraction; keys must be wrapped/unwrapped.

---

### Question 56

A company is migrating a data warehouse from on-premises to Amazon Redshift. The on-premises data warehouse uses column-level encryption for PII fields. During migration, they need to maintain column-level encryption in Redshift while minimizing application changes.

Which approach maintains column-level encryption after migration to Redshift?

A. Use Redshift's native column-level encryption feature, which allows specifying encryption for individual columns during table creation.

B. Implement client-side encryption in the application layer. Before inserting data into Redshift, encrypt PII columns using the AWS Encryption SDK with KMS. Store encrypted ciphertext in VARCHAR columns. Decrypt in the application when reading. Migrate existing encrypted data using DMS, which transfers the ciphertext as-is.

C. Use Redshift's server-side encryption with KMS, which encrypts the entire cluster including all columns.

D. Create a separate encrypted Redshift table for PII columns and join with the main table at query time.

**Correct Answer: B**

**Explanation:** Client-side encryption (B) is the correct approach for column-level encryption in Redshift, as Redshift doesn't have native column-level encryption. By encrypting PII fields before insertion, the ciphertext is stored in regular columns. DMS can migrate the already-encrypted ciphertext as-is, maintaining encryption continuity. Applications decrypt when reading. This pattern is consistent with the on-premises approach. Option A is incorrect — Redshift doesn't offer native column-level encryption. Option C encrypts the entire cluster at rest but all users who can query can see all columns in plaintext. Option D adds query complexity without providing true column encryption.

---

### Question 57

A regulated financial institution is migrating 500 applications from on-premises to AWS over 18 months. Each application's encryption approach must be assessed and potentially redesigned during migration. They need a framework for determining which AWS encryption service to use for each application based on compliance requirements, performance needs, and key management complexity.

Which decision framework correctly maps requirements to AWS encryption services?

A. Use AWS KMS for all applications to simplify management. KMS meets all compliance requirements.

B. Decision framework: (1) If FIPS 140-2 Level 3 and exclusive key control required → CloudHSM or KMS Custom Key Store. (2) If keys must remain outside AWS → KMS External Key Store (XKS). (3) If standard compliance with managed keys → KMS with CMKs. (4) If high-throughput symmetric encryption → KMS with data key caching. (5) If PKI/certificate operations → ACM Private CA. (6) If per-application isolation needed → separate KMS keys with key policies. Evaluate each application against these criteria during migration planning.

C. Use CloudHSM for all applications to maximize security, regardless of compliance requirements.

D. Let each application team choose their own encryption approach independently during migration.

**Correct Answer: B**

**Explanation:** A structured decision framework (B) ensures each application gets the right encryption service based on its specific requirements. FIPS Level 3 drives CloudHSM decisions. Key residency requirements drive XKS adoption. Standard workloads use KMS for operational simplicity. Performance-sensitive applications need data key caching. PKI needs map to ACM Private CA. Option A oversimplifies — KMS alone doesn't satisfy all requirements (e.g., FIPS Level 3, key residency outside AWS). Option C is unnecessarily expensive and complex for most applications. Option D leads to inconsistency, security gaps, and operational complexity.

---

### Question 58

A company is migrating a HIPAA-compliant healthcare application from on-premises to AWS. The application uses TLS client certificates for mutual authentication between services. During migration, both on-premises and AWS services must communicate securely. The on-premises services use certificates issued by the company's existing private CA.

Which approach maintains mTLS continuity during the migration?

A. Issue new certificates from ACM for AWS services and configure on-premises services to trust ACM's CA.

B. Set up ACM Private CA as a subordinate CA under the existing on-premises root CA. Issue certificates for AWS services from ACM Private CA. Both on-premises and AWS services trust the same root CA, maintaining mTLS across the hybrid environment.

C. Use self-signed certificates for AWS services during migration and switch to a proper CA after migration is complete.

D. Replace mTLS with IAM authentication for all service-to-service communication during migration.

**Correct Answer: B**

**Explanation:** Making ACM Private CA a subordinate of the existing on-premises root CA (B) creates a unified trust hierarchy. All certificates (on-premises and AWS) chain to the same root CA, so mTLS works seamlessly across the hybrid environment. AWS services get certificates from ACM Private CA, on-premises services keep their existing certificates. No trust configuration changes are needed on existing services. Option A requires on-premises services to trust a new CA. Option C weakens security during the most vulnerable phase (migration). Option D fundamentally changes the authentication model, requiring extensive application changes.

---

### Question 59

A company is using AWS Application Migration Service (MGN) to migrate 200 servers from on-premises to AWS. The on-premises servers have encrypted disks using BitLocker (Windows) and LUKS (Linux). The company needs to ensure migrated EC2 instances have EBS volumes encrypted with their KMS CMK.

How does MGN handle encryption during migration?

A. MGN automatically re-encrypts the replicated data using the specified KMS key during replication. Configure the launch template to specify the KMS CMK for EBS volume encryption. MGN decrypts the source disk encryption (BitLocker/LUKS) during the replication agent's read operations and encrypts with KMS during writes to the staging area EBS volumes.

B. MGN cannot migrate encrypted source servers. You must decrypt the source disks before starting migration.

C. MGN preserves the original encryption (BitLocker/LUKS) on the migrated EBS volumes and adds KMS encryption as an additional layer.

D. You must manually encrypt the EBS volumes after migration using snapshot-copy encryption.

**Correct Answer: A**

**Explanation:** MGN's replication agent (A) reads data from the source server at the block level. When source disks use OS-level encryption (BitLocker/LUKS), the agent reads the decrypted data from within the running OS (the OS has already decrypted it). The data is transmitted encrypted (TLS) to AWS, where it's written to staging EBS volumes. The launch template configuration specifies the KMS key for EBS encryption on the target volumes. The result is EBS-encrypted volumes with your CMK, replacing the original BitLocker/LUKS encryption with AWS-native encryption. Option B is incorrect — MGN handles encrypted sources. Option C is wrong — the original encryption is replaced. Option D is unnecessary.

---

### Question 60

A company is migrating from a third-party secrets management solution (CyberArk) to AWS Secrets Manager. They have 5,000 secrets across development, staging, and production environments. The migration must be executed without any application downtime and with the ability to roll back.

Which migration strategy provides zero-downtime secret migration with rollback capability?

A. Export all secrets from CyberArk and import them into Secrets Manager in a single batch operation. Update all application configurations to point to Secrets Manager simultaneously.

B. Implement a phased migration: (1) Create a secret proxy layer (API Gateway + Lambda) that reads from both CyberArk and Secrets Manager. (2) Copy secrets from CyberArk to Secrets Manager, verifying each. (3) Configure the proxy to read from Secrets Manager with CyberArk fallback. (4) Migrate applications to use Secrets Manager SDK gradually. (5) Decommission the proxy and CyberArk after full migration. Maintain dual-write to both systems during transition.

C. Use AWS Database Migration Service to migrate secrets from CyberArk to Secrets Manager.

D. Recreate all secrets manually in Secrets Manager and switch applications during a maintenance window.

**Correct Answer: B**

**Explanation:** The phased approach with a proxy layer (B) provides zero-downtime migration and rollback capability. The proxy abstracts the backend secret store, allowing gradual migration. Dual-write ensures both systems stay synchronized during transition. Applications can be migrated individually, and if any issues arise, the proxy falls back to CyberArk. This approach is operationally safe for 5,000 secrets across multiple environments. Option A is high-risk with a big-bang cutover. Option C — DMS is for databases, not secrets managers. Option D requires downtime and has no rollback mechanism.

---

### Question 61

A company is migrating SAP HANA from on-premises to AWS. The SAP HANA database uses data-at-rest encryption with the SAP HANA built-in encryption and also has custom encryption keys managed by SAP's key management. After migration, they want to leverage AWS-native encryption services while maintaining SAP HANA's internal encryption.

Which encryption architecture is appropriate post-migration?

A. Use only SAP HANA's built-in encryption and disable AWS-level encryption to avoid double encryption overhead.

B. Implement layered encryption: EBS volume encryption with KMS for infrastructure-level protection, and SAP HANA's built-in data and log encryption for application-level protection. Configure SAP HANA to use PKCS#11 integration with CloudHSM for its internal key management, replacing the on-premises key store.

C. Disable SAP HANA's built-in encryption and rely solely on EBS encryption with KMS.

D. Use S3 server-side encryption for SAP HANA data files stored on S3.

**Correct Answer: B**

**Explanation:** Layered encryption (B) provides defense-in-depth. EBS encryption protects at the infrastructure level (protects against physical disk theft, snapshot exposure). SAP HANA's built-in encryption provides application-level protection (protects against unauthorized database access). CloudHSM with PKCS#11 integration replaces the on-premises key management for SAP HANA, maintaining the same key management paradigm. Option A loses infrastructure-level protection. Option C loses application-level protection and SAP HANA's granular encryption controls. Option D is incorrect — SAP HANA on EC2 uses EBS, not S3.

---

### Question 62

A company needs to migrate encrypted Amazon RDS instances from one AWS account to another as part of an organizational restructuring. The source RDS instances are encrypted with KMS CMKs in the source account. They have 50 RDS instances to migrate.

Which approach correctly migrates encrypted RDS instances across accounts?

A. Share the source KMS key with the target account. Create RDS snapshots in the source account, share them with the target account. In the target account, copy each shared snapshot, specifying a local KMS key for re-encryption. Restore RDS instances from the re-encrypted snapshots. Automate with a Step Functions workflow.

B. Use DMS to replicate data from source to target account RDS instances, handling encryption automatically.

C. Export RDS instances to S3 using RDS Export, transfer S3 objects to the target account, and import into new RDS instances.

D. Directly share encrypted RDS snapshots with the target account and restore them — the encryption transfers automatically.

**Correct Answer: A**

**Explanation:** Cross-account encrypted RDS migration (A) requires sharing both the KMS key and the snapshot. The target account copies the shared snapshot with re-encryption using their own KMS key, creating an independent copy. This is the correct process because the target account shouldn't depend on the source account's KMS key long-term. Step Functions automation handles the scale of 50 instances. Option B works but is slower and more complex for a straight migration. Option C is limited — RDS Export to S3 has format limitations and not all engines support it fully. Option D fails because encrypted snapshots require access to the KMS key; without re-encryption, the target account depends permanently on the source account's key.

---

### Question 63

A company's monthly KMS bill has grown to $45,000, primarily from API calls. Analysis shows that their application makes GenerateDataKey calls for every S3 PutObject operation across 500 S3 buckets, averaging 1.5 billion API calls per month.

Which combination of optimizations provides the GREATEST cost reduction? (Choose TWO.)

A. Enable S3 Bucket Keys on all 500 buckets. This reduces KMS GenerateDataKey calls by using a time-limited bucket-level key, potentially reducing calls by 99%.

B. Switch from SSE-KMS to SSE-S3 (AES-256) encryption for buckets that don't require KMS-specific features (audit trails, key policies, key rotation control).

C. Consolidate the 500 buckets into 50 larger buckets to reduce the number of KMS keys needed.

D. Implement client-side encryption with the AWS Encryption SDK and data key caching for application-managed S3 uploads.

E. Request a KMS pricing discount through AWS Enterprise Support.

**Correct Answer: A, B**

**Explanation:** S3 Bucket Keys (A) reduce KMS API calls by up to 99% by creating a short-lived bucket-level key that S3 uses to derive per-object data keys locally, drastically cutting the number of KMS GenerateDataKey calls. For buckets not requiring KMS-specific features (B), switching to SSE-S3 eliminates KMS costs entirely — SSE-S3 is free and handled by S3 internally. Together, these could reduce the $45,000 bill to under $1,000. Option C doesn't reduce per-object KMS calls. Option D adds application complexity. Option E — KMS doesn't have negotiable volume pricing.

---

### Question 64

A company uses ACM to provision TLS certificates for hundreds of ALBs across multiple accounts. They also use ACM Private CA for internal services at $400/month per CA. The total ACM Private CA cost across their organization is $4,800/month (12 CAs).

Which optimization reduces ACM Private CA costs while maintaining the same certificate management capabilities?

A. Consolidate from 12 separate ACM Private CAs to a single shared Private CA in a central security account, shared via RAM with all accounts. Use a single general-purpose CA for all certificate types. This reduces cost from $4,800/month to $400/month.

B. Replace ACM Private CA with Let's Encrypt certificates for internal services.

C. Create a root CA and use short-lived certificate mode for all subordinate CAs. Short-lived mode CAs cost $400/month but issue certificates at $0 per certificate (instead of $0.75/certificate in general-purpose mode).

D. Issue all internal certificates manually using OpenSSL and eliminate ACM Private CA entirely.

**Correct Answer: A**

**Explanation:** Consolidating to a single shared CA via RAM (A) reduces the fixed cost from $4,800/month to $400/month — an 92% reduction. RAM allows all accounts in the organization to issue certificates from the shared CA. A single CA can serve different purposes through certificate templates and policies. Option B uses public Let's Encrypt for internal services, which exposes internal service names in CT logs. Option C addresses per-certificate costs ($0.75 each) which may also help depending on volume, but the question focuses on the CA cost itself. Option D eliminates managed certificate lifecycle and introduces significant operational risk.

---

### Question 65

A company encrypts 100 TB of data daily across S3, EBS, and RDS using KMS. Their KMS costs are $30,000/month. The CFO wants to reduce this by 50% without compromising security. Analysis shows 60% of KMS costs come from S3 API calls, 25% from EBS, and 15% from RDS.

Which prioritized optimization plan achieves the target cost reduction?

A. Phase 1 (60% of savings): Enable S3 Bucket Keys on all S3 buckets — reduces S3-related KMS costs by ~99%. Phase 2 (10% of savings): For non-sensitive S3 data (logs, temp files), switch to SSE-S3 encryption. Phase 3: Monitor remaining costs and evaluate if further optimization is needed. Expected new cost: ~$11,000/month (63% reduction).

B. Switch all encryption to SSE-S3 to eliminate KMS costs entirely.

C. Reduce the amount of data being encrypted by classifying data and only encrypting sensitive data.

D. Move to CloudHSM, which has a flat monthly cost regardless of API call volume.

**Correct Answer: A**

**Explanation:** Targeting the highest cost area first (A) — S3 at 60% of costs — with Bucket Keys provides the biggest impact. Bucket Keys reduce S3 KMS calls by up to 99%, turning the $18,000 S3 KMS cost to ~$180. Switching non-sensitive data to SSE-S3 eliminates those KMS costs entirely. Combined, this exceeds the 50% reduction target. Option B removes KMS security features (audit trails, key policies). Option C may violate compliance requirements. Option D — CloudHSM costs ~$1.50/hour per HSM instance, totaling ~$2,200+/month for a minimal HA cluster, but doesn't integrate as transparently with S3/EBS/RDS.

---

### Question 66

A company has 1,000 Secrets Manager secrets across 50 accounts. Each secret costs $0.40/month, totaling $400/month. Additionally, API call charges are $200/month. The CFO questions whether all 1,000 secrets are necessary.

Which audit and optimization strategy reduces Secrets Manager costs?

A. Delete all secrets and store credentials in Parameter Store SecureString parameters, which have no per-secret charge.

B. Audit secrets using CloudTrail logs to identify unused secrets (no GetSecretValue calls in 90 days). Consolidate related secrets (e.g., database host, port, username, password as a single JSON secret instead of four separate secrets). Migrate non-rotating, non-sensitive configuration to Parameter Store. Expected outcome: reduce to ~300 essential secrets ($120/month) with targeted API optimization.

C. Use a longer rotation interval for all secrets to reduce API calls.

D. Store all secrets in a single JSON document in one Secrets Manager secret.

**Correct Answer: B**

**Explanation:** A data-driven audit (B) identifies waste — unused secrets, over-decomposed secrets (four secrets for one database connection), and configuration values that don't need Secrets Manager's rotation features. CloudTrail analysis shows which secrets are actually accessed. Consolidating related credentials into single JSON secrets is a common optimization. Migrating non-sensitive config to Parameter Store eliminates per-secret charges for those items. Option A loses rotation capabilities for secrets that need them. Option C doesn't address storage costs. Option D creates a single point of failure and makes fine-grained access control impossible.

---

### Question 67

A company runs a serverless application using Lambda and API Gateway. They use KMS to encrypt environment variables for 200 Lambda functions. Each function invocation decrypts the environment variables, resulting in 50 million KMS Decrypt API calls per month.

Which optimization eliminates most KMS costs for Lambda environment variable encryption?

A. Lambda automatically encrypts environment variables with a service key at no cost. The 50 million Decrypt calls are occurring because the application is explicitly calling KMS Decrypt in the function code on the encrypted environment variable values. Remove the explicit KMS Decrypt calls — Lambda decrypts environment variables automatically before the function handler is invoked. Use the KMS CMK only for encryption at rest if required by compliance.

B. Cache the decrypted values in a Lambda layer shared across all functions.

C. Use Parameter Store instead of environment variables and implement caching.

D. Switch to using Secrets Manager with caching for all configuration values.

**Correct Answer: A**

**Explanation:** Lambda automatically decrypts environment variables before the handler runs (A), so explicit KMS Decrypt calls in the function code are redundant and wasteful. By default, Lambda uses a service key (free) for environment variable encryption. If a CMK is configured, Lambda calls KMS once during initialization (not per invocation) and caches the result. Removing the explicit Decrypt calls eliminates virtually all 50 million monthly KMS API calls. Option B doesn't address the root cause. Options C and D move the problem elsewhere without solving the fundamental issue of unnecessary API calls.

---

### Question 68

A company uses CloudHSM with a cluster of 6 HSM instances for high availability and performance. Each instance costs $1.60/hour, totaling $6,912/month. Analysis shows the cluster handles an average of 500 operations per second with peaks of 2,000 ops/sec.

Which optimization reduces CloudHSM costs while maintaining performance requirements?

A. A single CloudHSM instance can handle approximately 1,100 RSA 2048-bit signatures per second. Reduce the cluster to 3 instances (2 for capacity + 1 for HA), handling up to 3,300 ops/sec peak — well above the 2,000 ops/sec requirement. This reduces costs by 50% to $3,456/month.

B. Replace CloudHSM with KMS for all operations to eliminate HSM costs.

C. Use CloudHSM On-Demand instances that scale automatically based on load.

D. Schedule CloudHSM instances to stop during off-peak hours using Lambda automation.

**Correct Answer: A**

**Explanation:** Right-sizing the CloudHSM cluster (A) based on actual performance requirements is the correct optimization. With 2,000 ops/sec peak, 3 HSM instances provide sufficient capacity (each handles ~1,100 RSA 2048-bit ops/sec) plus HA across AZs. This halves the cost while meeting performance and availability needs. Option B may not be possible if CloudHSM is required for compliance (FIPS Level 3). Option C doesn't exist — CloudHSM instances don't auto-scale. Option D — you cannot stop/start individual HSM instances within a cluster in the same way as EC2.

---

### Question 69

A company creates 50,000 ACM Private CA certificates per month at $0.75 each (general-purpose mode), costing $37,500/month. Most certificates are for short-lived microservices with 7-day validity. Longer-lived certificates (1-year validity) account for only 2,000 per month.

Which optimization significantly reduces certificate issuance costs?

A. Create a separate ACM Private CA in short-lived certificate mode for the 48,000 short-lived certificates. Short-lived mode charges $400/month flat with no per-certificate fee (certificates valid ≤7 days). Keep the existing general-purpose CA for the 2,000 longer-lived certificates at $0.75 each. New cost: $400 (short-lived CA) + $400 (general CA) + $1,500 (2,000 × $0.75) = $2,300/month.

B. Reduce the number of certificates by using wildcard certificates for all microservices.

C. Migrate to self-signed certificates for microservices and keep ACM Private CA only for external-facing services.

D. Use ACM public certificates instead of private certificates for all services.

**Correct Answer: A**

**Explanation:** ACM Private CA short-lived certificate mode (A) provides unlimited certificate issuance for a flat $400/month, but certificates must have a validity of 7 days or less. Since 48,000 of the 50,000 monthly certificates are for short-lived microservices, this saves $36,000/month (from $37,500 to $2,300). The 2,000 longer-lived certificates remain on the general-purpose CA. Total savings: ~94%. Option B uses wildcards which reduce certificate count but weaken security posture. Option C reduces security. Option D exposes internal service names in Certificate Transparency logs.

---

### Question 70

A company's application generates KMS Decrypt calls at a rate that approaches the account-level KMS request quota (5,500 requests per second for symmetric operations in us-east-1). They face throttling during peak hours. Requesting a quota increase would cost more. The application processes encrypted messages from SQS.

Which architectural change reduces KMS API usage while processing the same message volume?

A. Implement SQS SSE-KMS with a longer data key reuse period (configured via KmsDataKeyReusePeriodSeconds, maximum 86,400 seconds / 24 hours). This reduces KMS calls because SQS caches and reuses the data key for the specified period instead of calling KMS for every message.

B. Move from SQS SSE-KMS to SQS SSE-SQS encryption, which uses SQS-managed keys at no cost and zero KMS API calls.

C. Implement message batching to reduce the number of SQS messages and therefore KMS calls.

D. Use multiple AWS accounts to distribute KMS API usage across separate quotas.

**Correct Answer: A**

**Explanation:** Increasing the KmsDataKeyReusePeriodSeconds (A) on SQS queues directly reduces KMS API calls. The default is 300 seconds (5 minutes). Setting it to the maximum of 86,400 seconds (24 hours) means SQS reuses a cached data key for much longer, dramatically reducing KMS GenerateDataKey and Decrypt calls. This maintains SSE-KMS features (audit trails, key policies). Option B eliminates KMS integration entirely, losing audit capabilities. Option C changes application architecture. Option D adds account management complexity.

---

### Question 71

A company runs an analytics platform that processes encrypted data across 10 AWS Regions. Each Region has its own KMS CMK for encrypting regional data. When data needs to be analyzed across Regions, it must be decrypted in the source Region, transferred, and re-encrypted in the destination Region. This cross-Region transfer adds $8,000/month in KMS API costs and significant latency.

Which architecture reduces cross-Region encryption costs and latency?

A. Use KMS multi-Region keys. Create a primary key in one Region and replicas in all other Regions. Data encrypted in any Region can be decrypted in any other Region using the local replica, eliminating cross-Region KMS API calls for decryption. Cross-Region data transfer uses standard S3 Cross-Region Replication or transfer mechanisms.

B. Use a single KMS key in one Region and have all other Regions make cross-Region API calls to that Region for all KMS operations.

C. Encrypt all data with SSE-S3 to eliminate cross-Region KMS dependency.

D. Deploy CloudHSM clusters in each Region and synchronize key material manually.

**Correct Answer: A**

**Explanation:** Multi-Region KMS keys (A) share the same key material and key ID across Regions. Data encrypted in Region A can be decrypted in Region B using the local replica key, eliminating cross-Region KMS API calls. This reduces both cost (local API calls are cheaper and don't incur cross-Region data transfer) and latency (local KMS endpoint vs. cross-Region call). S3 CRR natively supports re-encryption with a specified KMS key in the destination. Option B centralizes all KMS calls, creating a single point of failure and high latency. Option C loses KMS features. Option D is expensive and operationally complex.

---

### Question 72

A company uses Secrets Manager extensively and wants to reduce costs. They have 500 secrets: 200 are database credentials requiring rotation, 150 are static API keys from third-party services, and 150 are application configuration values (feature flags, URLs, timeouts).

Which tiered approach optimizes costs while maintaining appropriate security for each secret type?

A. Keep all 500 secrets in Secrets Manager but negotiate a volume discount with AWS.

B. Tier 1 — Keep 200 database credentials in Secrets Manager ($80/month) — they need automatic rotation. Tier 2 — Migrate 150 static API keys to Systems Manager Parameter Store SecureString ($0/month for standard parameters) — they don't need rotation but benefit from KMS encryption. Tier 3 — Migrate 150 configuration values to Parameter Store standard parameters or AppConfig ($0/month) — they're not secrets. Total new cost: $80/month vs. previous $200/month.

C. Move everything to Parameter Store SecureString to eliminate Secrets Manager costs.

D. Build a custom secrets management solution using DynamoDB and KMS.

**Correct Answer: B**

**Explanation:** Tiering secrets by capability requirements (B) optimizes costs. Database credentials genuinely need Secrets Manager's rotation capabilities. Static API keys benefit from encrypted storage but don't need rotation — Parameter Store SecureString provides this free. Configuration values aren't secrets at all — storing them in Parameter Store or AppConfig is more appropriate and cheaper. This reduces monthly costs by 60% while improving the architecture. Option A doesn't change the cost structure. Option C loses rotation for database credentials. Option D creates operational overhead.

---

### Question 73

A company discovers that their KMS costs are inflated because developers create new CMKs for every project, resulting in 2,000 CMKs across the organization at $1/month each ($24,000/year). Many of these CMKs encrypt identical types of data with identical compliance requirements.

Which governance approach reduces key proliferation while maintaining security?

A. Implement a shared key architecture: create a managed set of CMKs organized by data classification (Public, Internal, Confidential, Restricted) and environment (dev, staging, prod). Use key policies and IAM for access control. Establish a key creation governance process via Service Catalog that routes key requests through the security team. Identify and consolidate existing keys using CloudTrail analysis. Target: reduce to ~50 shared CMKs.

B. Schedule all unused keys for deletion immediately to reduce costs.

C. Disable automatic key creation permissions for all users and require manual key creation by the security team via tickets.

D. Switch to AWS managed keys to eliminate CMK costs entirely.

**Correct Answer: A**

**Explanation:** A shared key architecture with governance (A) addresses the root cause — uncontrolled key creation. Organizing keys by classification and environment provides appropriate isolation without per-project keys. Service Catalog with approval workflows prevents proliferation while not blocking developers entirely. CloudTrail analysis identifies which existing keys can be consolidated. Reducing from 2,000 to ~50 keys saves ~$23,400/year. Option B is dangerous — some "unused" keys may encrypt existing data. Option C creates bottlenecks. Option D loses audit trails, key policies, and rotation control provided by CMKs.

---

### Question 74

A company uses CloudFront with ACM public certificates for 500 domains. They also run ALBs in 5 Regions with ACM certificates. ACM public certificates are free, but the company pays for Route 53 DNS zones for certificate validation ($0.50/month per hosted zone). They maintain 500 hosted zones totaling $250/month.

Which optimization reduces DNS costs while maintaining ACM certificate management?

A. Consolidate DNS by using wildcard certificates where possible (e.g., *.example.com instead of separate certificates for app1.example.com, app2.example.com, etc.). A single wildcard certificate covers multiple subdomains with one validation record. Also consolidate Route 53 hosted zones where domains share the same parent domain. Potential reduction from 500 zones to ~50 zones ($25/month).

B. Switch from DNS validation to email validation for ACM certificates to eliminate the need for Route 53 hosted zones.

C. Move DNS to a free DNS provider and use CNAME records for ACM validation.

D. Use imported certificates instead of ACM-issued certificates to eliminate validation DNS requirements.

**Correct Answer: A**

**Explanation:** Consolidating with wildcard certificates (A) reduces the number of certificates and validation records needed. Multiple subdomains under one parent domain can share a single wildcard certificate. Consolidating Route 53 hosted zones for related domains reduces the $0.50/zone/month cost. Going from 500 to ~50 zones saves $225/month ($2,700/year). Option B eliminates auto-renewal, as only DNS-validated certificates auto-renew. Option C moves DNS away from AWS, potentially complicating certificate renewal. Option D requires managing certificate lifecycle manually, including renewals.

---

### Question 75

A company is evaluating the total cost of ownership (TCO) of their AWS encryption infrastructure. They currently use: 100 KMS CMKs ($100/month), 2 CloudHSM instances ($2,304/month), 1 ACM Private CA ($400/month), 500 Secrets Manager secrets ($200/month), and KMS API calls ($15,000/month). Total: $18,004/month.

Which comprehensive cost optimization strategy achieves the greatest reduction while maintaining security posture?

A. Eliminate CloudHSM and use KMS for everything, saving $2,304/month.

B. Comprehensive optimization: (1) Enable S3 Bucket Keys across all buckets to reduce KMS API costs by ~90% ($15,000 → $1,500). (2) Consolidate KMS CMKs from 100 to 30 based on data classification ($70/month savings). (3) Right-size CloudHSM to 2 instances if HA is met, or evaluate if KMS custom key store meets compliance needs. (4) Tier Secrets Manager — move non-rotating secrets to Parameter Store ($200 → $80). (5) Audit ACM Private CA usage for short-lived certificate mode opportunity. Projected savings: $13,690/month (76% reduction) to approximately $4,314/month.

C. Move all encryption to application-layer encryption using open-source libraries and eliminate all AWS encryption services.

D. Negotiate an Enterprise Discount Program (EDP) with AWS for reduced KMS pricing.

**Correct Answer: B**

**Explanation:** The comprehensive strategy (B) addresses each cost component with targeted optimization. The biggest win is reducing KMS API calls (83% of total cost) via S3 Bucket Keys. Key consolidation, secret tiering, and CloudHSM right-sizing provide additional savings. Each optimization maintains the security posture — encryption is preserved, just managed more efficiently. Option A removes CloudHSM without evaluating compliance requirements. Option C introduces enormous operational risk and loses AWS service integration. Option D might provide some savings but doesn't address architectural inefficiencies.

---

## Answer Key

| Q | Ans | Q | Ans | Q | Ans | Q | Ans | Q | Ans |
|---|-----|---|-----|---|-----|---|-----|---|-----|
| 1 | A,B | 16 | B | 31 | A | 46 | B | 61 | B |
| 2 | C | 17 | A | 32 | A | 47 | B | 62 | A |
| 3 | A | 18 | A | 33 | B | 48 | B | 63 | A,B |
| 4 | A | 19 | A | 34 | B | 49 | A | 64 | A |
| 5 | B | 20 | C | 35 | D,E | 50 | A | 65 | A |
| 6 | A | 21 | B | 36 | C | 51 | B | 66 | B |
| 7 | C | 22 | A | 37 | B | 52 | A | 67 | A |
| 8 | B | 23 | A | 38 | C | 53 | A | 68 | A |
| 9 | A | 24 | A | 39 | C | 54 | A | 69 | A |
| 10 | A | 25 | D | 40 | A,E | 55 | A | 70 | A |
| 11 | A | 26 | B | 41 | B | 56 | B | 71 | A |
| 12 | D | 27 | A | 42 | A | 57 | B | 72 | B |
| 13 | A | 28 | B | 43 | B | 58 | B | 73 | A |
| 14 | A | 29 | C | 44 | A | 59 | A | 74 | A |
| 15 | B | 30 | A | 45 | B | 60 | B | 75 | B |
