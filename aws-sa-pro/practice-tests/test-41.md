# AWS Certified Solutions Architect - Professional (SAP-C02) Practice Test 41

## Focus: Data Protection — Encryption Strategies, Key Management, Backup, Immutability

---

### Question 1
A financial services company stores sensitive customer data in Amazon S3. Regulatory requirements mandate that encryption keys must be rotated annually, the company must have full control over the key material, and all key usage must be logged. The security team wants to ensure that even AWS operators cannot access the plaintext data. The company uses multiple AWS accounts managed through AWS Organizations.

Which approach meets all of these requirements?

A) Use SSE-S3 encryption with S3 Bucket Keys enabled and configure an S3 Lifecycle policy to re-encrypt objects annually.
B) Use SSE-KMS with a customer managed key (CMK), enable automatic key rotation, and configure the key policy to deny AWS internal roles. Use AWS CloudTrail to log key usage.
C) Use SSE-C (customer-provided keys) where the application manages key rotation and supplies the key with each request. Log API calls through CloudTrail.
D) Use client-side encryption with keys managed in AWS CloudHSM, rotate keys annually through a custom Lambda function, and log CloudHSM operations via CloudTrail.
E) Use SSE-KMS with an AWS managed key and enable automatic key rotation.

**Correct Answer: D**
**Explanation:** The requirement that even AWS operators cannot access plaintext data rules out SSE-S3 (A, E) and SSE-KMS (B) because AWS manages the encryption infrastructure for those. SSE-C (C) provides customer key control but AWS still processes the plaintext during server-side encryption/decryption. Client-side encryption with CloudHSM (D) ensures data is encrypted before it reaches AWS, the company controls the HSM key material in a FIPS 140-2 Level 3 validated module, and CloudHSM audit logs can be sent to CloudTrail for compliance. CloudHSM keys can be rotated programmatically via Lambda.

---

### Question 2
A healthcare organization needs to implement an encryption strategy for Amazon RDS for PostgreSQL databases containing Protected Health Information (PHI). They require envelope encryption, the ability to disable keys in an emergency, cross-Region disaster recovery, and the minimum number of KMS keys to manage.

Which configuration satisfies these requirements?

A) Create a single-Region AWS KMS customer managed key. Enable automated backups with cross-Region replication. Manually create a new KMS key in the DR Region and re-encrypt the backup.
B) Create a multi-Region KMS customer managed key with the primary in the production Region and a replica in the DR Region. Enable RDS automated backups with cross-Region replication using the replica key.
C) Use the AWS managed key for RDS in each Region. Enable cross-Region read replicas.
D) Use AWS CloudHSM to create a custom key store for KMS. Create a customer managed key in the custom key store with cross-Region replication.

**Correct Answer: B**
**Explanation:** Multi-Region KMS keys (B) allow the same key material to exist in multiple Regions, simplifying cross-Region disaster recovery. RDS cross-Region backup replication can use the replica key in the target Region. The key can be disabled in an emergency to prevent decryption. Option A requires managing separate keys and complex re-encryption. Option C uses AWS managed keys that cannot be disabled by the customer and don't support cross-Region key material sharing. Option D adds unnecessary complexity; CloudHSM custom key stores don't support multi-Region key replication.

---

### Question 3
A company uses AWS Backup to protect resources across 15 AWS accounts in an organization. The compliance team requires that backup copies in the central backup account cannot be deleted by anyone — including the backup account administrator — for 7 years. They also need to ensure backup jobs complete within defined windows.

What combination of features meets these requirements?

A) Enable AWS Backup Vault Lock in compliance mode on the central vault with a minimum retention of 7 years. Configure backup plans with completion windows. Use an SCP to deny `backup:DeleteRecoveryPoint` across all accounts.
B) Enable AWS Backup Vault Lock in governance mode on the central vault. Use an IAM policy to deny deletion. Configure Amazon EventBridge rules to alert on failed backups.
C) Use S3 Object Lock in compliance mode for backup storage. Create lifecycle rules to transition to Glacier Deep Archive. Use AWS Config to monitor compliance.
D) Configure cross-account backup with vault access policies. Enable MFA delete on the backup vault. Set retention rules in the backup plan to 7 years.

**Correct Answer: A**
**Explanation:** AWS Backup Vault Lock in compliance mode (A) creates a WORM (Write Once Read Many) configuration that cannot be changed or deleted by anyone, including the root user, once the cooling-off period ends. Setting minimum retention to 7 years ensures backups are immutable for the required period. Completion windows in backup plans ensure jobs finish on time. The SCP adds defense in depth. Governance mode (B) can be overridden by users with sufficient IAM permissions. S3 Object Lock (C) doesn't directly apply to AWS Backup vaults. MFA delete (D) is an S3 feature and doesn't apply to backup vaults, and retention rules alone don't prevent deletion.

---

### Question 4
A media company stores petabytes of video assets in Amazon S3. They need to implement a tiered encryption strategy: publicly available content uses SSE-S3 for simplicity, premium content uses SSE-KMS with a shared key, and ultra-premium content uses per-customer KMS keys. The solution must enforce the correct encryption at upload time based on the S3 prefix.

How should the architect implement this?

A) Create three S3 buckets with different default encryption settings. Use S3 Access Points with bucket policies to route requests.
B) Use a single bucket with S3 bucket policies that use `Condition` keys to enforce specific encryption headers based on the `s3:prefix` condition. Set default bucket encryption to SSE-S3.
C) Use a single bucket. Create an S3 Object Lambda Access Point that intercepts PUT requests, inspects the prefix, and applies the correct encryption before storing.
D) Use three S3 Access Points on a single bucket, each mapped to a prefix. Configure each Access Point with a policy that requires the correct `s3:x-amz-server-side-encryption` and `s3:x-amz-server-side-encryption-aws-kms-key-id` headers for its prefix.

**Correct Answer: D**
**Explanation:** S3 Access Points (D) support prefix-scoped policies and can enforce specific encryption requirements per prefix. Each Access Point can have a policy requiring the appropriate encryption method and KMS key for the prefix it manages. This provides clean separation of concerns on a single bucket. Option A uses three buckets which adds management overhead. Option B is partially correct but S3 bucket policies don't support `s3:prefix` as a condition key for PUT operations — they use `s3:prefix` only for listing. Option C won't work because Object Lambda intercepts GET requests, not PUT requests.

---

### Question 5
An organization must ensure that all Amazon EBS volumes attached to production EC2 instances are encrypted with a specific customer managed KMS key. If an unencrypted volume is detected, it must be automatically encrypted and replaced within 30 minutes.

Which solution provides automated detection and remediation?

A) Enable AWS Config rule `encrypted-volumes` with a custom remediation action using Systems Manager Automation that creates an encrypted snapshot, creates a new encrypted volume, stops the instance, detaches the old volume, attaches the new volume, and starts the instance.
B) Use Amazon Inspector to scan for unencrypted volumes. Trigger a Step Functions workflow via EventBridge to perform the encryption.
C) Enable EBS encryption by default in the account with the specified KMS key. Use a Lambda function on a 30-minute schedule to check for non-compliant volumes.
D) Create an SCP that denies `ec2:RunInstances` and `ec2:CreateVolume` unless encryption is specified. Use AWS Config for detection of existing non-compliant volumes.

**Correct Answer: A**
**Explanation:** AWS Config with the `encrypted-volumes` rule (A) provides continuous detection. The SSM Automation runbook handles the complex remediation workflow: snapshot → encrypt snapshot → create volume → stop instance → swap volumes → start instance. This is the standard pattern for auto-remediation of non-compliant EBS volumes. Inspector (B) doesn't scan for EBS encryption. EBS default encryption (C) only applies to new volumes and doesn't remediate existing ones; the Lambda approach also lacks the orchestration capability. SCPs (D) are preventive but don't remediate existing violations.

---

### Question 6
A global bank requires that all AWS KMS operations for a specific customer managed key are restricted to API calls originating from within their VPC. The key is used by multiple services including S3, RDS, and Lambda within the VPC. External API calls, even from authorized IAM principals, must be denied.

How should this be implemented?

A) Create a VPC endpoint for KMS. Modify the KMS key policy to include a condition `aws:sourceVpce` matching the VPC endpoint ID.
B) Create a VPC endpoint for KMS with a restrictive endpoint policy. Modify the KMS key policy to include a condition `aws:sourceVpc` matching the VPC ID.
C) Create a VPC endpoint for KMS. Use an SCP with a condition `aws:sourceVpce` to restrict KMS usage. Attach the SCP to the OU containing the account.
D) Modify the security group of the VPC endpoint to only allow traffic from specific CIDR ranges. Use the default KMS key policy.

**Correct Answer: B**
**Explanation:** Using `aws:sourceVpc` (B) in the KMS key policy ensures that only API calls routed through the VPC (via the VPC endpoint) are permitted. This covers all services within the VPC, even Lambda functions running in VPC mode. The VPC endpoint must exist for this condition to work. Option A using `aws:sourceVpce` is more restrictive to a specific endpoint but functionally similar — however, `aws:sourceVpc` is broader and covers any endpoint in the VPC, which is more appropriate when multiple subnets may have endpoints. Option C uses SCPs which are less granular and may affect other keys. Option D relies on security groups which don't enforce KMS API call origin at the IAM policy level.

---

### Question 7
A company has implemented S3 Object Lock in governance mode for their data lake. An auditor has flagged that a privileged administrator could potentially bypass the governance mode lock and delete protected objects. The compliance team wants to ensure true immutability without re-uploading existing data.

What should the architect recommend?

A) Switch from governance mode to compliance mode on existing objects by modifying the retention settings on each object. Once in compliance mode, no one can shorten the retention period.
B) Create a new bucket with compliance mode Object Lock enabled, use S3 Batch Replication to copy objects to the new bucket, and decommission the old bucket.
C) Add an SCP denying `s3:BypassGovernanceRetention` across the entire organization. This effectively makes governance mode as strong as compliance mode.
D) Enable MFA Delete on the bucket and restrict MFA device access to the compliance team only.

**Correct Answer: B**
**Explanation:** Object Lock mode cannot be changed from governance to compliance on existing objects (A is incorrect). The Object Lock configuration (compliance vs governance) is set per-object version at upload time. The correct approach (B) is to create a new bucket with default retention in compliance mode, replicate objects there, and decommission the old bucket. Option C using SCPs helps but doesn't provide true compliance-mode guarantees — SCPs can be modified by the management account. MFA Delete (D) adds a layer of protection but doesn't provide WORM immutability.

---

### Question 8
A SaaS provider needs to implement a multi-tenant encryption architecture where each tenant's data in DynamoDB is encrypted with a tenant-specific KMS key. The solution must support 10,000+ tenants, minimize KMS costs, and allow individual tenant key revocation.

Which approach is most cost-effective while meeting requirements?

A) Create one KMS customer managed key per tenant. Use DynamoDB client-side encryption with the AWS Database Encryption SDK. Cache data keys locally to reduce KMS API calls.
B) Create one KMS customer managed key per tenant. Configure DynamoDB table-level encryption with each tenant's key by creating a separate table per tenant.
C) Use a single KMS customer managed key. Implement attribute-level encryption using the AWS Database Encryption SDK with unique data keys per tenant derived from the single CMK using encryption context.
D) Use AWS CloudHSM to generate tenant-specific keys. Implement client-side encryption before writing to DynamoDB.

**Correct Answer: C**
**Explanation:** Option C uses a single KMS CMK (costing $1/month instead of $10,000+/month for 10,000 keys) with the AWS Database Encryption SDK. Encryption context with tenant identifiers ensures each tenant gets unique data keys derived from the same CMK, providing cryptographic isolation. Individual tenant access can be revoked by updating the KMS key policy or grant to deny the specific encryption context. Option A creates 10,000+ keys at $1/month each, which is prohibitively expensive. Option B also has the per-key cost issue plus DynamoDB table limits. Option D is expensive and complex.

---

### Question 9
A company needs to migrate their on-premises Oracle database with Transparent Data Encryption (TDE) to Amazon RDS for Oracle. The TDE wallet keys must be managed by the company, and the encryption must use the same algorithm (AES-256). Downtime must be minimized.

Which migration approach meets these requirements?

A) Use AWS DMS with an Oracle source endpoint. Configure the target RDS for Oracle instance with SSE-KMS using a customer managed key. DMS handles TDE decryption and re-encryption automatically.
B) Export the TDE wallet from on-premises. Import the wallet into RDS for Oracle using the `rdsadmin.rdsadmin_util.push_tde_wallet` procedure. Use AWS DMS for ongoing replication.
C) Disable TDE on the on-premises database, perform the migration using AWS DMS, then enable RDS Oracle TDE with an RDS-managed key. Use KMS for the tablespace encryption key.
D) Use Oracle Data Pump to export unencrypted data. Import into RDS for Oracle with TDE enabled using CloudHSM as the key store for the TDE master encryption key.

**Correct Answer: D**
**Explanation:** RDS for Oracle supports TDE integration with AWS CloudHSM (Option D), which allows the company to maintain control over TDE master encryption keys. This meets the requirement for company-managed keys with AES-256. Data Pump handles the migration while CloudHSM provides the key management. Option A is incorrect because DMS doesn't automatically handle TDE wallet migration. Option B uses a procedure that doesn't exist in RDS. Option C requires disabling TDE (security gap) and RDS-managed keys don't give the company full control. CloudHSM provides FIPS 140-2 Level 3 key management that satisfies the company-managed key requirement.

---

### Question 10
A company has 50 AWS accounts and needs to implement a centralized secrets management strategy. Requirements include: automatic rotation of database credentials every 30 days, cross-account secret sharing, audit logging, and the ability to replicate secrets to a DR Region.

Which architecture meets all requirements?

A) Use AWS Secrets Manager in a central security account. Create resource-based policies to share secrets cross-account. Enable automatic rotation with Lambda rotator functions. Enable multi-Region secret replication. Use CloudTrail for audit logging.
B) Use AWS Systems Manager Parameter Store SecureString parameters with a centralized KMS key. Share parameters using RAM. Write a custom Lambda function for rotation.
C) Use HashiCorp Vault on Amazon ECS in the central account. Configure Vault's database secrets engine for rotation. Use Transit secrets engine for encryption.
D) Store secrets in a DynamoDB table encrypted with KMS. Use DynamoDB Global Tables for DR replication. Write Lambda functions for rotation and cross-account access via API Gateway.

**Correct Answer: A**
**Explanation:** AWS Secrets Manager (A) natively supports all requirements: automatic rotation with built-in Lambda templates for common databases, resource-based policies for cross-account sharing, multi-Region secret replication for DR, and CloudTrail integration. Parameter Store (B) doesn't support native rotation or multi-Region replication and cannot be shared via RAM. HashiCorp Vault (C) works but adds operational overhead for running and managing Vault infrastructure. DynamoDB (D) requires building everything custom and doesn't provide the security features of a purpose-built secrets manager.

---

### Question 11
A company's security policy mandates that all S3 objects must be encrypted with a customer managed KMS key specific to the data classification level (Confidential, Internal, Public). Objects uploaded without the correct key for their prefix must be automatically denied. Additionally, the KMS keys must use imported key material to support the company's key escrow requirements.

How should this be architected?

A) Create three KMS keys with imported key material using `EXTERNAL` origin. Configure S3 bucket policies with `Deny` statements using `StringNotEquals` on `s3:x-amz-server-side-encryption-aws-kms-key-id` for each prefix path. Set expiration dates on the imported key material and automate re-import before expiry.
B) Create three KMS keys using AWS-generated key material. Use S3 Inventory to scan for non-compliant objects and trigger Lambda to re-encrypt them.
C) Create a single KMS key with imported key material. Use S3 event notifications to validate encryption on upload and delete non-compliant objects.
D) Use SSE-S3 with bucket-level encryption and rely on IAM policies to restrict which keys can be used per prefix.

**Correct Answer: A**
**Explanation:** KMS keys with imported key material (`EXTERNAL` origin) (A) allow the company to maintain copies of key material outside AWS for escrow. Bucket policies can enforce specific KMS key IDs per prefix using condition keys. The expiration date on imported key material requires operational planning for re-import. Option B uses AWS-generated key material, which doesn't satisfy escrow. Option C deleting objects is destructive and doesn't prevent the upload. Option D using SSE-S3 doesn't involve KMS customer managed keys and IAM can't enforce per-prefix encryption keys effectively.

---

### Question 12
An e-commerce platform stores credit card data tokenized in Amazon Aurora MySQL. PCI DSS requires that the tokenization keys be stored in a hardware security module. The application needs to tokenize/detokenize thousands of transactions per second with sub-10ms latency. The solution must support high availability across two Availability Zones.

What is the optimal architecture?

A) Use AWS KMS for tokenization with a customer managed key. Enable KMS request caching in the application.
B) Deploy an AWS CloudHSM cluster with HSM instances in two Availability Zones. Use the PKCS#11 library to perform tokenization/detokenization operations directly on the HSM. Implement connection pooling in the application.
C) Use AWS Payment Cryptography service for card tokenization with its managed HSM backend.
D) Deploy a software-based tokenization service on EC2 instances across two AZs with keys stored in Secrets Manager.

**Correct Answer: B**
**Explanation:** CloudHSM (B) provides FIPS 140-2 Level 3 validated hardware, supports high-throughput cryptographic operations (thousands of TPS), and can achieve sub-10ms latency with connection pooling. Deploying across two AZs provides high availability. Option A (KMS) has per-request latency overhead and throttling limits that may not meet sub-10ms at thousands of TPS. Option C (AWS Payment Cryptography) handles payment-specific cryptographic operations but is designed for payment terminal operations, not application-level tokenization. Option D using software-based tokenization with Secrets Manager doesn't satisfy the HSM requirement for PCI DSS.

---

### Question 13
A government agency needs to implement data-at-rest encryption for an Amazon Redshift cluster containing classified data. Requirements: FIPS 140-2 Level 3 key management, the ability to immediately invalidate the cluster's encryption, and multi-node cluster support.

Which encryption configuration should be used?

A) Enable Redshift cluster encryption with an AWS KMS customer managed key. Use KMS key disabling for emergency invalidation.
B) Enable Redshift cluster encryption with AWS CloudHSM as the KMS custom key store. Create the CMK in the custom key store. Disconnect the custom key store for emergency invalidation.
C) Enable Redshift cluster encryption using CloudHSM Classic (legacy HSM). Configure the cluster to use the HSM for key management.
D) Implement client-side encryption in the ETL pipeline before loading data into Redshift. Store encryption keys in CloudHSM.

**Correct Answer: B**
**Explanation:** KMS with a CloudHSM custom key store (B) provides FIPS 140-2 Level 3 validation (standard KMS is Level 2 for most operations). Redshift natively supports KMS encryption. To immediately invalidate encryption, disconnecting the custom key store makes the key unusable, effectively making the cluster's data inaccessible. Option A uses standard KMS which is FIPS 140-2 Level 2, not Level 3. Option C references CloudHSM Classic which is a legacy service. Option D using client-side encryption would prevent Redshift from querying the data since it can't decrypt at query time.

---

### Question 14
A multinational company needs to implement a backup strategy for workloads across 6 AWS Regions. Requirements include: centralized backup management, cross-Region and cross-account copies, the ability to restore to any Region within 4 hours, and backup cost optimization for data older than 90 days.

Which solution meets all requirements with the least operational overhead?

A) Use AWS Backup with a backup policy in AWS Organizations applied at the OU level. Define backup plans with cross-Region copy rules targeting a central Region. Add lifecycle rules to transition backups older than 90 days to cold storage. Use AWS Backup Audit Manager for compliance monitoring.
B) Create CloudFormation StackSets to deploy backup plans to all accounts and Regions. Use custom Lambda functions to manage cross-Region copies and lifecycle transitions.
C) Implement a hub-and-spoke model with a central backup account. Use EventBridge cross-account event routing to trigger backup jobs. Store backups in S3 with Intelligent-Tiering.
D) Use AWS Backup in each account independently. Implement a custom orchestration layer using Step Functions for cross-Region copies and lifecycle management.

**Correct Answer: A**
**Explanation:** AWS Backup with Organizations backup policies (A) provides centralized management with the least operational overhead. Backup policies can be applied at the OU level, automatically covering all accounts. Cross-Region copy rules handle the DR requirement. Cold storage lifecycle rules optimize costs for older backups. Audit Manager provides compliance reporting. Options B, C, and D all involve custom implementations that increase operational complexity.

---

### Question 15
A company is designing an encryption architecture for a data lake on Amazon S3. Different datasets have different compliance requirements: some require HIPAA-compliant encryption, some require keys that can be deleted after the retention period, and some require dual-layer encryption. All data must support S3 Select queries.

Which encryption strategy accommodates all requirements?

A) Use SSE-KMS for HIPAA-compliant datasets, SSE-KMS with scheduled key deletion for time-bound datasets, and DSSE-KMS (dual-layer server-side encryption) for datasets requiring dual-layer encryption. All three support S3 Select.
B) Use client-side encryption with separate KMS keys per requirement. Implement custom S3 Select-compatible encryption.
C) Use SSE-S3 for all datasets and implement application-layer encryption for additional requirements.
D) Use SSE-C for all datasets with different keys per compliance requirement. Manage key lifecycle in Secrets Manager.

**Correct Answer: A**
**Explanation:** SSE-KMS (A) is HIPAA-eligible when used with a BAA. KMS CMKs can be scheduled for deletion (7-30 day waiting period) to support data disposal requirements. DSSE-KMS provides dual-layer server-side encryption. All three (SSE-KMS and DSSE-KMS) support S3 Select queries. Option B with client-side encryption doesn't support S3 Select since the data is encrypted before reaching S3. SSE-S3 (C) doesn't allow key deletion or dual-layer encryption. SSE-C (D) supports S3 Select but managing keys externally is complex and error-prone.

---

### Question 16
A company runs a critical application on Amazon EKS that processes sensitive financial data. They need to encrypt Kubernetes Secrets at rest using a customer managed KMS key, encrypt all pod-to-pod communication, and encrypt persistent volumes. The solution must not significantly impact cluster performance.

What combination of solutions should be implemented?

A) Enable EKS envelope encryption for Kubernetes Secrets using a KMS CMK. Deploy a service mesh (AWS App Mesh with Envoy) for mTLS between pods. Use EBS CSI driver with encrypted gp3 volumes using KMS.
B) Use Sealed Secrets with a KMS CMK for Kubernetes Secrets. Use Calico network policies for pod communication security. Use EFS with encryption in transit.
C) Store secrets in AWS Secrets Manager instead of Kubernetes Secrets. Use VPC security groups for pod-level network isolation. Use instance store encryption.
D) Enable etcd encryption using a self-managed key. Deploy Istio for mTLS. Use Longhorn for encrypted persistent storage.

**Correct Answer: A**
**Explanation:** EKS envelope encryption (A) uses KMS to encrypt the data encryption key that protects Kubernetes Secrets in etcd, providing customer-managed key control. AWS App Mesh with Envoy provides mTLS for pod-to-pod encryption with minimal performance impact through sidecar proxies. EBS CSI driver natively supports KMS-encrypted volumes. Option B uses Sealed Secrets which is a third-party solution. Option C doesn't encrypt K8s Secrets at rest. Option D involves self-managed etcd encryption which isn't supported on managed EKS.

---

### Question 17
A company must implement a ransomware protection strategy for their AWS environment. They need to protect S3 data, EBS volumes, RDS databases, and DynamoDB tables from unauthorized encryption or deletion. Recovery must be possible within 1 hour.

Which comprehensive strategy provides the strongest protection?

A) Enable S3 Versioning with Object Lock (compliance mode) and MFA Delete. Use AWS Backup with vault lock for EBS, RDS, and DynamoDB. Enable cross-account backup copies. Create SCPs denying deletion of backup resources. Enable GuardDuty for threat detection.
B) Enable S3 Cross-Region Replication. Take daily EBS snapshots. Enable RDS Multi-AZ. Enable DynamoDB point-in-time recovery. Use CloudWatch alarms for anomaly detection.
C) Use AWS Backup for all resources with a 1-hour backup frequency. Enable deletion protection on all resources. Use AWS Config for compliance monitoring.
D) Implement immutable backups using S3 Glacier Vault Lock. Replicate all data to a separate isolated account using custom scripts. Monitor with Security Hub.

**Correct Answer: A**
**Explanation:** Option A provides defense in depth: S3 Object Lock prevents object deletion/modification, MFA Delete adds another layer, AWS Backup vault lock makes backups immutable, cross-account copies protect against account compromise, SCPs prevent backup deletion, and GuardDuty detects threats. The combination ensures data can be recovered within 1 hour from recent immutable backups. Option B lacks immutability — an attacker could delete replicas and snapshots. Option C doesn't provide immutability. Option D uses custom scripts which are operationally risky and Glacier retrieval may not meet the 1-hour RTO.

---

### Question 18
A company has an AWS KMS customer managed key that is used by 200+ applications across 30 accounts. They need to rotate the key without any application downtime or code changes. The key is used for S3 SSE-KMS, EBS encryption, and RDS encryption.

How should the key rotation be performed?

A) Enable automatic KMS key rotation. KMS will generate new key material annually and maintain old material for decryption. No application changes are needed because KMS tracks all key versions internally.
B) Create a new KMS key, update all S3 bucket policies and EBS/RDS configurations to use the new key, then re-encrypt all existing data with the new key.
C) Use the KMS `ReEncrypt` API to re-encrypt all data keys with new key material. Update all application configurations to use the new key ARN.
D) Import new key material into the existing KMS key using the import key material workflow. This replaces the old key material automatically.

**Correct Answer: A**
**Explanation:** KMS automatic key rotation (A) generates new cryptographic material annually while retaining all previous versions. The key ID and ARN remain the same. AWS services that use the key (S3, EBS, RDS) automatically use the new material for new encryption operations and can decrypt using any previous version. No application changes needed. Option B requires massive coordination across 200+ applications. Option C requires re-encrypting all data keys and changing ARNs. Option D — you cannot import new material into a key that was created with AWS-generated material; import is only for keys with EXTERNAL origin, and even then, re-importing replaces (doesn't add) material.

---

### Question 19
A media company stores large video files (up to 100 GB) in S3 and needs to encrypt them with SSE-KMS. They're experiencing throttling due to KMS API rate limits when multiple large uploads happen simultaneously, especially during multipart uploads.

What is the most effective way to reduce KMS throttling?

A) Enable S3 Bucket Keys. This reduces KMS API calls by generating a bucket-level key from the CMK that is used for a time-limited period, reducing per-object KMS calls.
B) Request a KMS API rate limit increase through AWS Support.
C) Switch to SSE-S3 encryption which doesn't use KMS.
D) Implement exponential backoff in the upload client and reduce upload parallelism.
E) Use larger multipart upload part sizes to reduce the number of parts and associated KMS calls.

**Correct Answer: A**
**Explanation:** S3 Bucket Keys (A) significantly reduce KMS API calls by generating an S3-level bucket key derived from the CMK. This key is reused for a time-limited period, reducing the number of KMS `GenerateDataKey` calls from one per object to a much lower rate. For multipart uploads, this is especially impactful. Option B is a valid short-term fix but doesn't address the root cause. Option C removes KMS entirely which may violate policy. Options D and E reduce symptoms but don't solve the underlying efficiency issue. S3 Bucket Keys can reduce KMS costs by up to 99%.

---

### Question 20
A company needs to share encrypted AMIs from a central account with 50 member accounts in their AWS Organization. The AMIs contain sensitive pre-configured application software. Recipients must be able to launch instances from these AMIs but should not be able to copy the AMI to accounts outside the organization.

How should this be implemented?

A) Create a KMS key with a key policy that allows `kms:CreateGrant` for the organization using `aws:PrincipalOrgID`. Share the AMI with specific account IDs. Use an SCP to deny `ec2:CopyImage` to accounts outside the organization.
B) Share the AMI publicly and rely on the KMS key policy to prevent unauthorized decryption.
C) Copy the AMI to each of the 50 accounts and re-encrypt with each account's local KMS key.
D) Use AWS RAM to share the AMI with the organization. The AMI's KMS key must have a key policy allowing usage by the organization.

**Correct Answer: A**
**Explanation:** Option A correctly implements encrypted AMI sharing. The KMS key policy must allow `kms:CreateGrant` (which is needed for EBS volume decryption during instance launch) scoped to the organization. The AMI is shared with specific accounts. The SCP prevents copying outside the organization. Option B making AMIs public is a security risk. Option C is operationally complex at scale. Option D — RAM supports AMI sharing, but the key policy still needs correct configuration, and RAM alone doesn't prevent cross-organization copying; the SCP is still needed for that constraint.

---

### Question 21
A financial institution needs to implement a certificate management strategy for 500+ internal microservices running on ECS Fargate. Requirements include automated certificate issuance, rotation every 30 days, private CA, and no secrets stored in container images.

Which architecture minimizes operational overhead?

A) Deploy AWS Private CA. Use AWS Certificate Manager (ACM) to issue private certificates. Integrate ACM with Application Load Balancers for TLS termination at the ALB level. Use ACM auto-renewal.
B) Deploy AWS Private CA with a two-tier hierarchy. Use the ACM Private CA API with ECS task IAM roles to request short-lived certificates at container startup. Store certificates in memory only.
C) Deploy HashiCorp Vault with the PKI secrets engine on ECS. Configure Vault agent sidecar containers to inject certificates.
D) Use AWS Private CA with ACM. Store certificates in Secrets Manager with 30-day rotation Lambda functions. Mount secrets as container environment variables.

**Correct Answer: B**
**Explanation:** Using ACM Private CA API (B) with ECS task roles allows each container to programmatically request short-lived certificates at startup. The two-tier CA hierarchy (root + subordinate) is a PKI best practice. Certificates exist only in memory, eliminating storage risks. ECS task IAM roles provide identity without secrets. Option A terminates TLS at the ALB, not providing end-to-end encryption between services. Option C adds operational overhead for Vault management. Option D stores certificates in Secrets Manager which is less secure than in-memory certificates and adds rotation complexity.

---

### Question 22
A company uses Amazon S3 for storing regulatory documents with a 10-year retention requirement. After 3 years, documents must be verifiably unchanged from their original upload. The solution must provide cryptographic proof of data integrity and be legally admissible.

Which approach provides the strongest guarantee?

A) Enable S3 Object Lock in compliance mode with a 10-year retention period. Use S3 Versioning. Generate SHA-256 checksums at upload and store them in a DynamoDB table.
B) Enable S3 Object Lock in compliance mode. Use Amazon S3 additional checksums (SHA-256) at upload time. Store the checksum as object metadata. Use AWS CloudTrail data events to log all access.
C) Use Amazon QLDB (Quantum Ledger Database) to record cryptographic hashes of each document at upload. Store documents in S3 with Object Lock. QLDB provides an immutable, verifiable journal.
D) Store documents in S3 Glacier with vault lock. Use AWS Backup with vault lock for secondary copies. Generate and store HMAC signatures in a separate encrypted S3 bucket.

**Correct Answer: C**
**Explanation:** Amazon QLDB (C) provides a cryptographically verifiable, immutable ledger that records document hashes at upload time. Combined with S3 Object Lock, this provides both immutable storage and cryptographic proof of integrity over time. QLDB's hash chain allows verification that records haven't been tampered with, which is stronger for legal admissibility than simple checksum storage. Option A stores checksums in DynamoDB which is mutable. Option B's metadata checksums prove integrity only if the metadata itself hasn't been altered. Option D uses HMAC but lacks the immutable audit chain.

---

### Question 23
An enterprise needs to encrypt Amazon EFS file systems used by a fleet of EC2 instances and Lambda functions. They require encryption at rest using a customer managed KMS key and encryption in transit. Some workloads need to access the file system from a different AWS account.

Which configuration meets all requirements?

A) Create an EFS file system with encryption at rest using a KMS CMK. Enable encryption in transit by mounting with the TLS mount option (`-o tls`). Create a KMS key policy allowing the secondary account. Use VPC Peering and EFS mount targets in the secondary account's VPC.
B) Create an EFS file system with encryption at rest. Use AWS PrivateLink for cross-account access. Mount using standard NFS.
C) Create an encrypted EFS file system. Share it using AWS RAM with the secondary account. Mount with the EFS mount helper using TLS. Configure the KMS key policy for cross-account access.
D) Create an EFS file system without encryption. Use a VPN connection between accounts for in-transit encryption. Access EFS over the VPN.

**Correct Answer: C**
**Explanation:** AWS RAM (C) supports sharing EFS file systems across accounts with minimal configuration. The EFS mount helper with TLS provides encryption in transit. The KMS key policy must allow the secondary account to use the key for decryption. Option A is incorrect because EFS mount targets can only be created by the file system owner, not in a secondary account's VPC. Option B — PrivateLink isn't used for EFS cross-account access. Option D provides no encryption at rest and VPN is an unnecessarily complex approach.

---

### Question 24
A company runs a data pipeline that processes files in S3, transforms them in AWS Glue, and loads results into Amazon Redshift. All stages must use a consistent customer managed KMS key. The security team has discovered that Glue temporary storage is using a different key.

How should this be corrected to ensure end-to-end encryption consistency?

A) Configure the Glue job's security configuration to specify the customer managed KMS key for S3 encryption, CloudWatch Logs encryption, and job bookmark encryption. Set the `--encryption-type` job parameter.
B) Create a Glue Security Configuration that specifies the CMK for S3 encryption mode (SSE-KMS), CloudWatch encryption, and job bookmark encryption. Attach this security configuration to the Glue job. Ensure the Glue service role has permissions on the CMK.
C) Modify the Glue job script to explicitly encrypt temporary files using the AWS Encryption SDK before writing.
D) Configure the S3 bucket used for Glue temporary storage with default encryption using the CMK. Enable Redshift audit logging encryption with the same key.

**Correct Answer: B**
**Explanation:** Glue Security Configurations (B) are the correct way to manage encryption settings for Glue jobs comprehensively. They control encryption for S3 targets (including temporary storage), CloudWatch Logs, and job bookmarks. The security configuration is attached to the Glue job, and the Glue service role must have `kms:Encrypt`, `kms:Decrypt`, and `kms:GenerateDataKey` permissions on the CMK. Option A mixes security configuration and job parameter syntax incorrectly. Option C modifies only the script, not the framework's temporary storage. Option D configures bucket defaults but doesn't cover CloudWatch and bookmarks.

---

### Question 25
A healthcare company has a hybrid architecture with on-premises systems connected to AWS via Direct Connect. They need to encrypt data in transit between on-premises and AWS for HIPAA compliance. The encryption must not reduce throughput below 5 Gbps and must use standards-compliant encryption.

Which approach provides the required throughput with encryption?

A) Set up a Site-to-Site VPN over the Direct Connect public VIF using IPsec. This provides encryption at up to 1.25 Gbps per VPN tunnel.
B) Create a MACsec-enabled Direct Connect connection (10 Gbps or 100 Gbps). MACsec provides Layer 2 encryption with minimal performance impact, meeting both the encryption and throughput requirements.
C) Set up multiple Site-to-Site VPN connections over Direct Connect and use ECMP routing to aggregate bandwidth above 5 Gbps.
D) Use a Transit Gateway with a Direct Connect Gateway. Configure the Direct Connect connection with a transit VIF and use the built-in encryption.

**Correct Answer: B**
**Explanation:** MACsec on Direct Connect (B) provides Layer 2 (IEEE 802.1AE) encryption with near-zero performance impact, supporting 10 Gbps or 100 Gbps connections. This easily exceeds the 5 Gbps throughput requirement. IPsec VPN (A) is limited to 1.25 Gbps per tunnel. Option C using multiple VPN tunnels with ECMP could work but is complex and may not reliably achieve 5 Gbps due to per-flow hashing. Option D — Direct Connect connections don't have built-in encryption; Transit VIFs don't encrypt traffic natively.

---

### Question 26
A company is implementing a data classification and automatic encryption system. When files are uploaded to an S3 bucket, they should be automatically scanned by Amazon Macie, classified, and re-encrypted with the appropriate KMS key based on classification (PII data gets Key A, financial data gets Key B, general data gets Key C).

How should this workflow be implemented?

A) Enable Macie on the S3 bucket for automatic discovery. Use Macie findings published to EventBridge to trigger a Lambda function that reads the classification, copies the object with the appropriate KMS key using `S3:CopyObject` with `ServerSideEncryption` parameters, and deletes the original.
B) Configure S3 event notifications to trigger Macie on each upload. Macie automatically re-encrypts based on classification.
C) Use S3 Object Lambda to intercept reads and encrypt with the appropriate key based on Macie findings.
D) Configure Macie to run continuous classification. Use AWS Config custom rules to detect mismatched encryption and trigger SSM Automation for re-encryption.

**Correct Answer: A**
**Explanation:** Macie publishes findings to EventBridge (A), enabling event-driven automation. The Lambda function processes the classification finding, determines the appropriate KMS key, uses S3 CopyObject with server-side encryption parameters to create a correctly encrypted copy, then deletes the original. Option B is incorrect because Macie doesn't automatically re-encrypt and isn't triggered per-object by S3 events. Option C handles reads, not writes, and doesn't address classification. Option D works but introduces delay through Config rule evaluation cycles and is more complex than the event-driven approach.

---

### Question 27
A company stores encrypted database backups in S3 using SSE-KMS. They have a disaster recovery requirement to restore backups in a different AWS account within 2 hours. The backup account and DR account are in different AWS Organizations.

What is the most reliable approach?

A) Configure S3 Cross-Region Replication from the backup account to a bucket in the DR account. Use a KMS key policy in the source account that grants the DR account decrypt and encrypt permissions. Create a separate KMS key in the DR account for the destination bucket.
B) Configure S3 Same-Region Replication to a bucket in the DR account. Share the KMS key with the DR account using a key grant.
C) Write a Lambda function in the DR account that periodically copies objects from the source bucket using cross-account S3 access and re-encrypts with a local KMS key.
D) Use AWS Backup with cross-account backup to copy backups to the DR account. AWS Backup handles the KMS re-encryption automatically.

**Correct Answer: A**
**Explanation:** S3 Cross-Region Replication (A) to a different account can re-encrypt objects with a destination KMS key owned by the DR account. The replication configuration specifies the destination encryption. The source account's KMS key policy must allow the replication role to decrypt. Since the accounts are in different Organizations, direct key sharing via org conditions isn't possible, so explicit account-based key policies are needed. Option B uses same-Region which doesn't address geographic DR. Option C introduces latency and Lambda timeout risks for large backups. Option D — AWS Backup cross-account requires accounts to be in the same Organization.

---

### Question 28
A company is designing a system to manage encryption keys for a multi-cloud environment (AWS, Azure, GCP). They want a single key management system that works across all three clouds while maintaining FIPS 140-2 Level 3 compliance.

Which approach best meets this requirement?

A) Use AWS KMS as the primary key management system. Export KMS key material to Azure Key Vault and Google Cloud KMS.
B) Deploy AWS CloudHSM clusters. Use the CloudHSM PKCS#11 and JCE interfaces to create a unified key management API. Applications in all clouds connect to CloudHSM via VPN/Direct Connect.
C) Use an external key management solution (e.g., Thales CipherTrust or Fortanix) that integrates with AWS KMS External Key Store (XKS), Azure Key Vault Managed HSM, and Google Cloud External Key Manager (EKM).
D) Use each cloud's native KMS independently and maintain key material synchronization through a custom application.

**Correct Answer: C**
**Explanation:** An external key manager (C) with XKS integration provides a single control plane for keys across all clouds. AWS KMS External Key Store (XKS) allows KMS to use keys stored outside AWS while maintaining the KMS API. Azure and GCP have similar external key integration capabilities. This provides centralized key management with FIPS 140-2 Level 3 from the external HSM. Option A — KMS key material cannot be exported. Option B requires all traffic to route through AWS which adds latency and creates AWS dependency. Option D requires custom synchronization which is error-prone and complex.

---

### Question 29
A company needs to implement field-level encryption for a web application behind Amazon CloudFront. Sensitive form fields (credit card number, SSN) must be encrypted at the edge before reaching the origin. Only specific backend microservices should be able to decrypt these fields.

How should this be architected?

A) Use CloudFront field-level encryption. Configure a field-level encryption profile with an RSA public key. Specify which POST body fields to encrypt. Store the private key in AWS Secrets Manager accessible only by authorized backend services.
B) Implement client-side JavaScript encryption using the Web Crypto API. Send encrypted fields to CloudFront which passes them to the origin.
C) Use AWS WAF with CloudFront to encrypt sensitive fields in transit. Configure WAF rules to identify and encrypt specific form fields.
D) Terminate TLS at CloudFront and re-encrypt using a custom Lambda@Edge function that encrypts specific fields with a KMS key.

**Correct Answer: A**
**Explanation:** CloudFront field-level encryption (A) encrypts specific POST body fields at the edge location using a public key configured in the encryption profile. The encrypted fields remain encrypted through the origin and intermediate services. Only services with access to the corresponding private key can decrypt the fields, providing true field-level confidentiality. Option B requires client-side implementation which isn't enforceable. Option C — WAF doesn't encrypt fields. Option D using Lambda@Edge adds latency and KMS calls at the edge increase costs and latency.

---

### Question 30
A company has a compliance requirement to prove that their KMS customer managed key has never been used to encrypt data for unauthorized services or accounts. They need a complete audit trail of all key usage going back 5 years.

How should this be implemented?

A) Enable CloudTrail with KMS data event logging. Configure a CloudTrail organization trail with log file integrity validation. Store logs in S3 with Object Lock (compliance mode, 5-year retention). Use Athena for forensic queries on key usage.
B) Use KMS key policies with `kms:ViaService` conditions to restrict usage. Enable CloudTrail management events for KMS. Store logs in CloudWatch Logs with a 5-year retention period.
C) Enable AWS Config recording for KMS resources. Use Config rules to detect unauthorized key usage. Store Config snapshots for 5 years.
D) Use CloudTrail Insights to detect unusual KMS API patterns. Configure SNS alerts for unauthorized usage. Store CloudTrail logs in S3 for 5 years.

**Correct Answer: A**
**Explanation:** CloudTrail data events for KMS (A) capture every cryptographic operation (Encrypt, Decrypt, GenerateDataKey, etc.) with full context including the calling principal and service. Organization trail ensures coverage across all accounts. Log file integrity validation provides cryptographic proof that logs haven't been tampered with. S3 Object Lock ensures the 5-year retention. Athena enables forensic analysis. Option B only captures management events (key creation, policy changes) not actual usage. Option C tracks configuration changes, not usage. Option D provides anomaly detection but not complete usage records.

---

### Question 31
A company is migrating a legacy application that uses PGP encryption for file transfers. The new architecture should use AWS-native services while maintaining compatibility with existing PGP-encrypted files from partners. Partners cannot change their encryption method.

Which solution handles both legacy and new encryption requirements?

A) Use AWS Transfer Family with a custom identity provider. Configure a Lambda function as a post-upload workflow step that decrypts PGP files using GPG binaries in a Lambda layer, then re-encrypts with KMS for internal storage.
B) Deploy AWS Transfer Family for SFTP. Store PGP-encrypted files directly in S3 with SSE-KMS. Rely on double encryption (PGP + SSE-KMS).
C) Replace PGP with S3 client-side encryption. Provide partners with AWS SDK integration instructions.
D) Use Amazon MQ to receive encrypted files via AMQP. Decrypt using a custom consumer application.

**Correct Answer: A**
**Explanation:** AWS Transfer Family (A) supports SFTP/FTPS/FTP protocols compatible with partner systems. The managed workflow feature allows post-upload processing via Lambda to handle PGP decryption and KMS re-encryption. This maintains partner compatibility while enabling AWS-native encryption for internal use. Option B stores PGP-encrypted data but doesn't allow internal services to easily access the plaintext. Option C requires partners to change their encryption method, which violates the requirement. Option D uses the wrong protocol for file transfer.

---

### Question 32
A company needs to ensure that database connection strings, API keys, and certificates are never stored in plaintext in their infrastructure-as-code templates (CloudFormation, Terraform). They want automated detection and remediation.

Which approach provides the best prevention and detection?

A) Use dynamic references in CloudFormation (`{{resolve:secretsmanager:...}}` and `{{resolve:ssm-secure:...}}`). For Terraform, use data sources to retrieve from Secrets Manager at apply time. Implement git-secrets or TruffleHog in the CI/CD pipeline for pre-commit scanning. Use Amazon CodeGuru Reviewer for automated code reviews.
B) Encrypt IaC templates using KMS before storing in CodeCommit. Only decrypt during deployment.
C) Store all secrets as CloudFormation parameters with `NoEcho: true`. Use Parameter Store for Terraform variables.
D) Use CloudFormation stack policies to prevent secret exposure. Implement manual code reviews before deployment.

**Correct Answer: A**
**Explanation:** Dynamic references (A) ensure secrets are never written in plaintext in templates — they're resolved at deployment time from Secrets Manager or Parameter Store. git-secrets/TruffleHog in CI/CD catches accidental secret commits. CodeGuru Reviewer can identify hardcoded credentials. Option B encrypts entire templates which makes them unreadable and unmanageable. Option C — `NoEcho` only masks display in the console; secrets are still in the template parameter values. Option D relies on manual review which is error-prone and doesn't scale.

---

### Question 33
A company uses Amazon Aurora with IAM database authentication. They want to implement a zero-trust approach where database access tokens are short-lived, each microservice gets a unique identity, and all database access is logged at the SQL query level.

Which architecture achieves this?

A) Use ECS tasks with unique IAM task roles. Each role has IAM policy to generate Aurora auth tokens. Configure Aurora to use IAM authentication. Enable Aurora Advanced Auditing for SQL-level logging. Set token lifetime to 15 minutes (the maximum for IAM DB auth tokens).
B) Use RDS Proxy with IAM authentication. Configure each microservice with unique Secrets Manager credentials. Enable RDS Proxy logging.
C) Use IAM database authentication with shared service account credentials. Rotate credentials every 15 minutes using Lambda.
D) Use Aurora Data API with IAM authentication. Configure resource-based policies per microservice. Enable API Gateway access logging.

**Correct Answer: A**
**Explanation:** ECS task roles (A) provide unique IAM identities per microservice. IAM database authentication generates short-lived tokens (15 minutes) that serve as temporary credentials, aligning with zero-trust principles. Aurora Advanced Auditing logs SQL queries with the authenticated user. This provides unique identity, short-lived access, and comprehensive logging. Option B uses Secrets Manager credentials which are longer-lived and not zero-trust. Option C shares credentials violating unique identity. Option D — Data API has limitations on connection pooling and isn't suitable for all workloads.

---

### Question 34
A regulated company needs to implement a "break glass" procedure for emergency access to encrypted data. During normal operations, the KMS key used for encrypting critical data should require multi-party approval for decryption. During an emergency, a single authorized responder should be able to bypass the multi-party requirement.

How should this be designed?

A) Create two KMS keys: a primary key requiring multi-party approval via KMS grants with retiring principal, and an emergency key with a policy allowing the incident response role. Encrypt data with both keys (envelope encryption with two layers). Monitor emergency key usage with CloudTrail and SNS alerts.
B) Use a KMS key policy with a condition requiring multiple IAM principals to call `kms:Decrypt`. Create a separate "break glass" IAM role with admin permissions.
C) Configure the KMS key to require MFA for decrypt operations. Provide the incident response team with a dedicated MFA device for emergencies.
D) Use an SCP to deny KMS decrypt operations. During emergency, temporarily remove the SCP.

**Correct Answer: A**
**Explanation:** Dual-key envelope encryption (A) provides the strongest design. Normal decryption requires the primary key (multi-party approval via grants) and the emergency key (restricted to incident response). During emergencies, the responder uses only the emergency key which decrypts the outer envelope. CloudTrail alerts ensure emergency key usage is monitored and audited. Option B — KMS policies can't require multiple principals for a single API call. Option C — MFA only adds one factor, not multi-party. Option D — removing SCPs during emergencies is slow and risky.

---

### Question 35
A company is building a document management system where users upload documents that are encrypted with user-specific KMS keys. When a user's account is deleted, all their documents must become permanently inaccessible. The system has 1 million users.

What is the most efficient approach?

A) Create one KMS CMK per user. When a user is deleted, schedule the CMK for deletion (7-day minimum). After deletion, all encrypted documents become permanently inaccessible.
B) Use a single KMS CMK with unique encryption contexts per user. When a user is deleted, revoke all grants associated with their encryption context.
C) Use client-side encryption with data keys generated per user from a single CMK using unique encryption contexts. Store encrypted data keys alongside documents. When a user is deleted, delete all their stored encrypted data keys, making documents undecryptable.
D) Use SSE-S3 and delete the user's S3 prefix when their account is deleted.

**Correct Answer: C**
**Explanation:** Using a single CMK with per-user data keys (C) avoids creating 1 million KMS keys (which would exceed account limits and cost $1M/month). Each user's data keys are encrypted with a unique encryption context. Deleting the encrypted data keys makes documents permanently undecryptable — without the encrypted data key, there's no way to derive the plaintext data key even with the CMK. Option A creating 1M keys is not feasible. Option B revoking grants doesn't prevent future decryption if the encryption context is known. Option D doesn't truly make data inaccessible as S3 objects could be recovered.

---

### Question 36
An organization needs to implement cross-Region disaster recovery for their AWS KMS-encrypted resources. They have identified that during a regional outage, they cannot access KMS keys to decrypt data needed for recovery in the DR Region.

Which strategy ensures key availability during a regional failure?

A) Create multi-Region KMS keys with replicas in the DR Region. Multi-Region keys share the same key material across Regions, allowing the DR Region to decrypt data encrypted in the primary Region without cross-Region calls.
B) Export KMS key material and store it in an S3 bucket in the DR Region, encrypted with a DR Region KMS key.
C) Use AWS CloudHSM in both Regions with identical key material cloned between clusters.
D) Replicate all encrypted data to the DR Region and re-encrypt it with a DR Region-specific KMS key during replication.

**Correct Answer: A**
**Explanation:** Multi-Region KMS keys (A) are designed specifically for this use case. They share cryptographic material across Regions while maintaining independent key resources in each Region. During a regional failure, the DR Region can use its local replica key to decrypt data without any cross-Region dependencies. Option B — KMS key material cannot be exported for keys with AWS-generated material. Option C works but adds operational complexity of managing CloudHSM. Option D works for pre-replicated data but adds complexity and cost for re-encryption, and data in transit during failure would be inaccessible.

---

### Question 37
A company operates an Amazon Redshift data warehouse with sensitive columns containing PII. They need column-level encryption where different teams can only decrypt columns relevant to their role. Analysts should be able to query non-sensitive columns without decryption overhead.

Which approach provides granular column-level access control with encryption?

A) Use Redshift column-level access control combined with column-level encryption using SQL UDFs that call KMS through Lambda. Each UDF uses a role-specific KMS key. Grant UDF execution to appropriate roles.
B) Encrypt all columns with a single KMS key. Use Redshift row-level security to control access.
C) Use Amazon Redshift dynamic data masking to mask PII columns for unauthorized users. Use column-level grants for access control.
D) Implement application-layer encryption before loading data. Store encrypted and unencrypted columns side by side.

**Correct Answer: A**
**Explanation:** SQL UDFs (A) calling KMS through Lambda provide true column-level encryption with role-based key access. Each sensitive column is encrypted with a different key. UDF execution permissions control who can decrypt each column. Non-sensitive columns have zero encryption overhead. Option B with a single key doesn't provide per-column access differentiation. Option C — dynamic data masking obscures data display but doesn't encrypt at rest. Option D creates data management issues and doesn't leverage Redshift's query engine efficiently.

---

### Question 38
A company is running Amazon EMR clusters that process encrypted data from S3. The EMR cluster needs to encrypt HDFS data at rest, data in transit between nodes, and EMRFS data. They also need to encrypt EBS volumes attached to the cluster nodes. All encryption must use a single customer managed KMS key.

What is the correct EMR security configuration?

A) Create an EMR Security Configuration that specifies: SSE-KMS with the CMK for EMRFS encryption, LUKS encryption with the CMK for local disk encryption, in-transit encryption with PEM certificates, and EBS encryption with the CMK. Attach the security configuration to the cluster at launch.
B) Configure each component separately: S3 bucket default encryption for EMRFS, EC2 EBS default encryption for volumes, and a custom Hadoop configuration for HDFS encryption.
C) Use EMR Encryption at Rest setting with the CMK. This automatically encrypts HDFS, EMRFS, and EBS volumes.
D) Configure HDFS encryption zones with KMS. Use S3 SSE-KMS for EMRFS. Configure EBS encryption through the EC2 launch template.

**Correct Answer: A**
**Explanation:** EMR Security Configurations (A) centralize all encryption settings. EMRFS encryption uses SSE-KMS for S3 data. Local disk (HDFS) encryption uses LUKS with the KMS CMK as the encryption provider. In-transit encryption uses TLS certificates (PEM). EBS encryption uses the CMK. All settings are applied at cluster launch through a single configuration. Option B configures components separately which is error-prone and doesn't cover HDFS. Option C oversimplifies — there's no single "encryption at rest" toggle. Option D mixes EMR and standalone Hadoop/EC2 configurations.

---

### Question 39
A company has an S3 bucket with billions of objects encrypted using an SSE-KMS key that needs to be retired. They must re-encrypt all objects with a new KMS key. The operation must complete within 72 hours without impacting the production application's performance.

What is the most efficient approach?

A) Use S3 Batch Operations with a `COPY` operation specifying the new KMS key in the `SSE-KMS` encryption configuration. Create a manifest from S3 Inventory. Use S3 Batch Operations priority and throttling to manage performance impact.
B) Write a Lambda function triggered by S3 Inventory that copies each object with the new encryption key. Use reserved concurrency to limit impact.
C) Create an S3 Replication rule to the same bucket with the new KMS key. Wait for replication to complete.
D) Use the AWS CLI `s3 cp` command with `--recursive` and `--sse-aws-kms-key-id` to copy objects in place.

**Correct Answer: A**
**Explanation:** S3 Batch Operations (A) is the most efficient way to perform operations on billions of objects. It handles parallelization, retry logic, and progress tracking. The COPY operation with new encryption settings re-encrypts objects in place. S3 Inventory provides the complete manifest. Priority settings control the operation's share of S3 bandwidth. Option B using Lambda has timeout limits and concurrency challenges at billions of objects. Option C — you cannot replicate to the same bucket. Option D would take far too long with CLI and doesn't provide the same parallelism.

---

### Question 40
A company stores application logs in CloudWatch Logs groups across 20 accounts. Compliance requires that all log data is encrypted with a customer managed KMS key and that log data cannot be exported to unencrypted destinations.

How should this be implemented at scale?

A) Use a CloudFormation StackSet to associate a KMS CMK with each CloudWatch Logs log group across all accounts. Create an SCP denying `logs:CreateExportTask` unless the destination S3 bucket requires SSE-KMS encryption. Use AWS Config custom rules for compliance monitoring.
B) Enable CloudWatch Logs default encryption at the account level using KMS. This automatically encrypts all new and existing log groups.
C) Create a centralized logging account. Use CloudWatch Logs subscription filters to forward all logs to a central encrypted destination. Delete local log groups.
D) Use AWS Organizations tag policy to tag log groups requiring encryption. Use AWS Config to detect non-encrypted groups.

**Correct Answer: A**
**Explanation:** CloudFormation StackSets (A) enable consistent deployment of KMS encryption associations for log groups across all accounts. The SCP prevents exporting to unencrypted destinations. AWS Config monitors ongoing compliance. Option B — CloudWatch Logs doesn't have an account-level default encryption setting; encryption must be associated per log group. Option C creates a complex architecture and doesn't address the export restriction. Option D tags don't enforce encryption.

---

### Question 41
A company is implementing Amazon S3 Glacier Vault Lock for archival data. They need to understand the implications of different vault lock policies. The legal team requires that once the vault lock is applied, no one — including the root user — can modify or delete archives for 7 years, but new archives can still be added.

Which vault lock policy meets this requirement?

A) Create a vault lock policy that denies `glacier:DeleteArchive` for all principals when the archive age is less than 7 years (using `DateLessThan` with a calculated date from archive creation). Allow `glacier:UploadArchive`. Initiate the lock and complete it within the 24-hour window.
B) Create a vault lock policy that denies all operations on the vault. Use a separate vault for new uploads.
C) Create a vault lock policy that denies `glacier:DeleteArchive` and `glacier:InitiateJob` for all principals unconditionally.
D) Create a vault access policy (not vault lock) with the same deny rules. This is equivalent but reversible.

**Correct Answer: A**
**Explanation:** Glacier Vault Lock (A) with a time-based deny policy prevents deletion of archives younger than 7 years while allowing new uploads. The vault lock policy becomes immutable once completed (after the 24-hour confirmation window). The key is using `glacier:DeleteArchive` with a condition on archive creation date. Option B denying all operations prevents uploads. Option C denying `InitiateJob` would prevent retrieval. Option D using vault access policy (not vault lock) is mutable and doesn't meet the immutability requirement.

---

### Question 42
A company has implemented AWS KMS key policies with strict access controls. However, their automated deployment pipeline occasionally fails because the pipeline role needs temporary access to keys it doesn't normally use during blue/green deployments. The access should be automatically revoked after 6 hours.

What is the best approach to provide temporary KMS access?

A) Use KMS grants to provide the pipeline role temporary access. Specify a `RetiringPrincipal` that is the pipeline itself, and set `GranteePrincipal` as the pipeline role. Configure the pipeline to retire the grant after the deployment completes. Use CloudWatch Events with a Lambda function to retire any grants older than 6 hours as a safety net.
B) Modify the KMS key policy before deployment to add the pipeline role, then remove it after deployment.
C) Create a separate KMS key for deployments with broader access. Re-encrypt resources with this key during deployment.
D) Use IAM session policies to provide temporary KMS permissions during assumed role sessions.

**Correct Answer: A**
**Explanation:** KMS grants (A) are designed for temporary, programmatic access. The retiring principal can clean up the grant when done, and the Lambda safety net handles cases where the pipeline fails before retiring the grant. Option B modifying key policies is slow (eventual consistency) and creates security windows. Option C creates unnecessary key management complexity. Option D — IAM session policies can only restrict permissions of the assumed role, not add new ones.

---

### Question 43
A company is designing an application that must comply with the EU's right to be forgotten (GDPR Article 17). User data is distributed across S3, DynamoDB, Aurora, and Elasticsearch. When a deletion request is received, all user data must become irrecoverable across all services within 30 days.

Which encryption-based approach simplifies GDPR compliance?

A) Implement crypto-shredding: assign each user a unique KMS data key, encrypt all their data with this key across all services, and when a deletion request is received, delete the encrypted data key material. Without the key, the encrypted data is irrecoverable.
B) Tag all user data with the user ID and run a batch deletion job across all services within 30 days.
C) Implement user-specific KMS CMKs and schedule them for deletion upon receiving a GDPR request.
D) Use DynamoDB TTL, S3 Lifecycle rules, Aurora scheduled queries, and Elasticsearch index lifecycle management to delete data after 30 days.

**Correct Answer: A**
**Explanation:** Crypto-shredding (A) is the most efficient approach for right to be forgotten across distributed systems. By encrypting each user's data with a unique data key and destroying that key upon request, all encrypted data becomes cryptographically irrecoverable without needing to locate and delete every piece of data across multiple services. This is significantly simpler than service-by-service deletion. Option B requires perfect data tracking across services. Option C is expensive at scale (per-user KMS CMKs). Option D automates deletion but is time-based rather than request-based and requires coordination across services.

---

### Question 44
A company uses AWS Organizations with multiple accounts for production workloads. They want to ensure that no one can create unencrypted Amazon RDS instances, Amazon EBS volumes, or Amazon S3 buckets without default encryption in any account within the organization.

Which combination of controls provides preventive enforcement?

A) Create SCPs that: (1) deny `rds:CreateDBInstance` unless `StorageEncrypted` is true, (2) deny `ec2:CreateVolume` unless encrypted is true, (3) deny `s3:CreateBucket` unless followed by `s3:PutEncryptionConfiguration`. Enable EBS encryption by default in all accounts via a CloudFormation StackSet.
B) Use AWS Config organizational rules: `rds-storage-encrypted`, `encrypted-volumes`, and `s3-bucket-server-side-encryption-enabled`. Configure auto-remediation for each.
C) Create SCPs that deny `rds:CreateDBInstance` unless `rds:StorageEncrypted` condition is true. Deny `ec2:RunInstances` unless `ec2:Encrypted` condition is true. Deny `s3:PutObject` unless encryption header is present. Enable EBS encryption by default via SCP.
D) Use AWS Control Tower mandatory guardrails for encryption. These automatically enforce encryption across all services.

**Correct Answer: C**
**Explanation:** SCPs (C) provide preventive controls at the organization level. The `rds:StorageEncrypted` condition key prevents unencrypted RDS instances. The `ec2:Encrypted` condition key on `RunInstances` prevents launches with unencrypted volumes. Denying `s3:PutObject` without encryption headers forces encryption. EBS default encryption ensures standalone volume creation is encrypted. Option A's S3 approach (monitoring `CreateBucket` then `PutEncryptionConfiguration`) isn't enforceable as an SCP. Option B uses detective controls (Config) which detect after creation, not prevent. Option D — Control Tower guardrails don't cover all these specific encryption requirements.

---

### Question 45
A company needs to rotate their AWS CloudHSM keys used for payment processing. The rotation must be seamless with zero downtime, and both old and new keys must work during a transition period. The company uses PKCS#11 to interface with CloudHSM.

How should the key rotation be implemented?

A) Generate a new key pair in CloudHSM with a versioned label (e.g., `payment-key-v2`). Update the application to use the new key for new encryptions while maintaining the ability to decrypt with the old key using the key label. After the transition period, delete the old key.
B) Delete the old key and create a new one with the same label. CloudHSM maintains the old key material internally.
C) Export the old key material, generate a new key, and import the old material as a backup.
D) Use CloudHSM key wrapping to wrap the old key with the new key, establishing a key hierarchy.

**Correct Answer: A**
**Explanation:** Versioned key labels (A) in CloudHSM allow the application to reference both old and new keys simultaneously. New operations use the new key (v2) while decryption can still use the old key (v1) based on key metadata stored with the ciphertext. This provides zero-downtime rotation. Option B deleting the old key would cause immediate failure for existing data — CloudHSM doesn't maintain deleted key material. Option C — PKCS#11 generally doesn't support key export for sensitive keys without wrapping. Option D creates a hierarchy but doesn't address the transition period for existing encrypted data.

---

### Question 46
A financial company runs workloads on EC2 instances with encrypted EBS volumes. They have discovered that some EC2 instances have unencrypted EBS snapshots shared by other teams. The security team wants to prevent the use of unencrypted snapshots and ensure all new snapshots are encrypted with a specific KMS key.

Which combination of controls achieves this?

A) Enable EBS encryption by default with the specified KMS key. Create an IAM policy that denies `ec2:CreateSnapshot` unless the `ec2:Encrypted` condition is true. Create an SCP denying `ec2:RunInstances` that reference unencrypted snapshot IDs.
B) Use AWS Config to detect unencrypted snapshots. Create a Lambda function to encrypt them automatically.
C) Modify the KMS key policy to deny `ec2:CreateSnapshot` without encryption.
D) Use Amazon Data Lifecycle Manager (DLM) exclusively for snapshot management. Configure DLM to always encrypt snapshots.

**Correct Answer: A**
**Explanation:** Enabling EBS encryption by default (A) ensures all new snapshots are encrypted with the specified key. The IAM/SCP combination provides preventive controls against unencrypted snapshot creation and usage. This is defense in depth: default encryption handles the common case, and the policies catch edge cases. Option B is detective, not preventive. Option C — KMS key policies don't control EC2 operations. Option D — DLM only manages automated snapshots, not manual ones.

---

### Question 47
A company needs to implement envelope encryption for application data where the data encryption keys (DEKs) must never be stored in plaintext. The application processes 50,000 encrypt/decrypt operations per second. KMS API rate limits are 10,000 requests per second.

How should the encryption architecture be designed?

A) Use KMS `GenerateDataKey` to generate DEKs. Cache the plaintext DEK in memory for a configurable time period (e.g., 5 minutes). Use the cached DEK for multiple encrypt operations. Only call KMS when the cache expires or for decryption of data encrypted with a different DEK.
B) Use the AWS Encryption SDK which automatically handles DEK caching, envelope encryption, and KMS API optimization with a configurable cache TTL and maximum bytes/messages per cached key.
C) Call KMS `Encrypt` for every operation. Request a rate limit increase to 50,000 per second.
D) Generate DEKs locally using a cryptographic library. Encrypt the DEKs with KMS only when persisting to storage.

**Correct Answer: B**
**Explanation:** The AWS Encryption SDK (B) provides built-in data key caching that reduces KMS API calls while maintaining security. It handles the complete envelope encryption workflow: generating data keys from KMS, caching them with configurable limits (TTL, max bytes, max messages), encrypting data with cached keys, and managing key rotation. Option A implements manual caching which is error-prone. Option C is expensive and may not be approved. Option D generating keys locally without KMS involvement doesn't provide the same security guarantees.

---

### Question 48
A healthcare organization needs to ensure that when they delete patient data from Amazon S3, the data is truly irrecoverable — not just deleted but overwritten. This is required for compliance with specific data destruction regulations.

What should the architect recommend?

A) AWS provides a compliance certification that S3 storage is sanitized according to NIST 800-88 guidelines when objects are deleted. Request the SOC 2 Type II report and the S3 data disposal attestation from AWS Artifact for the compliance team.
B) Implement a custom process that overwrites each S3 object with random data three times before deleting.
C) Use S3 Object Expiration with a lifecycle rule. S3 automatically overwrites data after deletion.
D) Store data on Dedicated Hosts with encrypted local storage. Physically destroy the hosts when data must be deleted.

**Correct Answer: A**
**Explanation:** AWS handles storage media sanitization according to NIST 800-88 guidelines (A). When S3 objects are deleted, the underlying storage is sanitized before reuse. This is documented in AWS SOC reports and specific compliance attestations available through AWS Artifact. Customers don't need to (and can't) perform their own data sanitization on S3. Option B — overwriting S3 objects doesn't guarantee overwriting the same physical storage due to S3's distributed architecture. Option C — lifecycle rules don't trigger overwrites. Option D is extremely expensive and impractical.

---

### Question 49
A company runs a serverless application using API Gateway, Lambda, and DynamoDB. They want to encrypt all data in transit and at rest using customer managed KMS keys. They also want to ensure that Lambda environment variables containing connection strings are encrypted.

Which comprehensive encryption configuration is correct?

A) Configure API Gateway with a custom domain and TLS 1.2 certificate from ACM. Encrypt Lambda environment variables with a KMS CMK (enable helpers for encryption in transit). Configure DynamoDB table encryption with the KMS CMK. Enable DynamoDB TLS endpoints (default).
B) Configure API Gateway with mutual TLS. Use Lambda layers for encryption. Configure DynamoDB with SSE-S3.
C) Use API Gateway resource policies for encryption. Store Lambda environment variables in Parameter Store. Use DynamoDB DAX for encrypted caching.
D) Configure a VPC endpoint for all services. VPC endpoints provide automatic encryption for all traffic.

**Correct Answer: A**
**Explanation:** Option A correctly addresses all encryption requirements. API Gateway custom domains with ACM certificates enforce TLS 1.2 for transit encryption. Lambda environment variables can be encrypted with a KMS CMK using the "enable helpers for encryption in transit" feature. DynamoDB supports table-level encryption with a customer managed KMS key. DynamoDB endpoints already use TLS. Option B — SSE-S3 is an S3 encryption mode, not DynamoDB. Option C — API Gateway resource policies control access, not encryption. Option D — VPC endpoints don't automatically encrypt all traffic.

---

### Question 50
A company has enabled AWS Backup for their production environment. They need to create an isolated "clean room" account where backup copies can be restored for forensic analysis after a security incident, without any network connectivity to production. The backups must be encrypted with a key that production account administrators cannot access.

How should this be architected?

A) Configure AWS Backup cross-account backup to copy backups to the clean room account. In the clean room account, create a KMS key that only the forensics team can access. Configure the cross-account copy to re-encrypt with the clean room KMS key. Ensure the clean room account has no VPC peering, Transit Gateway attachments, or Direct Connect to production.
B) Use S3 Cross-Region Replication to copy backup data to the clean room account. Use VPC isolation.
C) Create manual snapshots and share them with the clean room account. Use the clean room account's default KMS key.
D) Use AWS RAM to share backup vaults with the clean room account. Restrict network access using NACLs.

**Correct Answer: A**
**Explanation:** AWS Backup cross-account copy (A) with re-encryption provides proper isolation. The clean room KMS key ensures production admins cannot decrypt the forensic copies. Network isolation (no peering, Transit Gateway, or Direct Connect) prevents data exfiltration. Option B doesn't work directly with AWS Backup vaults. Option C using manual snapshots doesn't provide automated, consistent copies. Option D — RAM sharing of backup vaults would still use the original encryption key, and NACLs alone don't provide full network isolation.

---

### Question 51
A media company stores customer-uploaded content in S3. They need to implement a system where content is initially stored with a temporary encryption key. After content moderation is complete (within 24 hours), approved content is re-encrypted with a permanent key, and rejected content has its temporary key deleted, making the content irrecoverable.

Which approach implements this content moderation workflow?

A) Use S3 server-side encryption with a per-upload KMS CMK created with `PendingDeletion` scheduled for 24 hours. If content is approved, cancel the key deletion and re-encrypt with a permanent key. If rejected, let the key be deleted.
B) Upload content encrypted with a temporary data key derived from a "moderation" CMK using a unique encryption context. Store the encrypted data key in DynamoDB with a 24-hour TTL. If approved, copy the object with the permanent key. If rejected or TTL expires, the encrypted data key is deleted, making the content irrecoverable.
C) Upload content to a bucket with 24-hour lifecycle expiration. If approved, copy to a permanent bucket before expiration.
D) Use S3 Object Lock with a 24-hour retention period. After moderation, either extend retention (approved) or let it expire and delete (rejected).

**Correct Answer: B**
**Explanation:** Option B implements crypto-shredding for rejected content. The encrypted data key stored in DynamoDB with TTL acts as a time bomb — if not explicitly preserved, it's automatically deleted, making the content unrecoverable. For approved content, copying with a permanent key ensures long-term access. Option A — KMS minimum deletion waiting period is 7 days, not 24 hours. Option C deletes the actual content but doesn't address crypto-shredding. Option D — letting Object Lock expire still leaves the object accessible.

---

### Question 52
A company is implementing data loss prevention (DLP) for their S3 data lake. They need to automatically detect when unencrypted sensitive data is uploaded, quarantine it, encrypt it with the appropriate key, and place it in the correct bucket.

Which architecture provides automated DLP?

A) Configure S3 Event Notifications on the landing bucket to trigger a Step Functions workflow that: (1) invokes Amazon Macie for classification, (2) moves unencrypted objects to a quarantine bucket, (3) based on Macie classification, encrypts with the appropriate KMS key, (4) places the object in the correct destination bucket based on data classification.
B) Use S3 Intelligent-Tiering with classification tags. Configure bucket policies to enforce encryption based on tags.
C) Deploy Amazon GuardDuty S3 protection to detect unencrypted uploads. Use EventBridge to trigger remediation.
D) Use AWS Config rule `s3-bucket-server-side-encryption-enabled` with auto-remediation.

**Correct Answer: A**
**Explanation:** The Step Functions workflow (A) orchestrates the complete DLP pipeline: detection, quarantine, classification, encryption, and routing. Macie provides accurate data classification. The workflow can handle the multi-step process reliably with error handling and retries. Option B — Intelligent-Tiering manages storage classes, not encryption or classification. Option C — GuardDuty S3 protection monitors for threats, not encryption status of individual objects. Option D monitors bucket-level encryption settings, not object-level encryption.

---

### Question 53
A company wants to use AWS Nitro Enclaves for processing sensitive data. The application inside the enclave needs to decrypt data using a KMS key, but the key should only be accessible from within the enclave, not from the parent EC2 instance.

How should the KMS key policy be configured?

A) Add a condition to the KMS key policy that allows `kms:Decrypt` only when the request includes a valid attestation document from the Nitro Enclave. Use the `kms:RecipientAttestation:PCR0` condition key to verify the enclave image.
B) Create an IAM role for the EC2 instance that has KMS decrypt permissions. The Nitro Enclave inherits the role.
C) Use a VPC endpoint for KMS accessible only from the enclave's network namespace.
D) Store the KMS key material in the enclave's encrypted memory.

**Correct Answer: A**
**Explanation:** Nitro Enclaves (A) generate cryptographic attestation documents that contain Platform Configuration Registers (PCRs) — unique measurements of the enclave image. KMS key policies can use `kms:RecipientAttestation:PCR0` (and other PCR condition keys) to allow decrypt only when a valid attestation document is presented, effectively restricting key access to verified enclave code. Option B gives the parent instance access too. Option C — enclaves don't have network interfaces; they communicate only via vsock with the parent. Option D — KMS key material isn't directly accessible.

---

### Question 54
A company has a requirement that all data written to their Amazon Aurora PostgreSQL database must be encrypted at the application layer using a specific algorithm (AES-256-GCM). They also need to search encrypted fields without decrypting them.

Which approach enables encrypted field searching?

A) Use deterministic encryption (AES-256-SIV) for searchable fields and randomized encryption (AES-256-GCM) for non-searchable fields. Create database indexes on the deterministically encrypted columns.
B) Implement a blind index: compute an HMAC of the plaintext value using a separate key, store the HMAC alongside the encrypted field, and search by computing the HMAC of the search term.
C) Use AWS Database Encryption SDK with searchable encryption using beacons. Configure standard beacons for equality searches and compound beacons for complex queries.
D) Decrypt all data in a Lambda function and perform the search in memory.

**Correct Answer: C**
**Explanation:** The AWS Database Encryption SDK (C) supports searchable encryption using beacons — truncated HMACs that allow equality and range searches on encrypted data without decryption. Standard beacons support equality searches, compound beacons support complex queries, and the beacon values don't reveal the plaintext. Option A using deterministic encryption leaks equality information (same plaintext produces same ciphertext). Option B with blind indexes is similar but is a manual implementation of what the SDK provides natively. Option D decrypting all data is expensive and doesn't scale.

---

### Question 55
A company needs to implement a secure key distribution system for 10,000 IoT devices that encrypt telemetry data before sending it to AWS IoT Core. Each device needs a unique encryption key, and keys must be rotatable without physical access to devices.

Which architecture supports secure key management for IoT at scale?

A) Use AWS IoT Core with X.509 device certificates for authentication. Provision per-device KMS data keys using IoT Device Provisioning. Use IoT Jobs to rotate data keys by sending new encrypted data keys to devices over the MQTT channel. Devices decrypt the new data key using their device certificate's private key.
B) Embed symmetric encryption keys in the device firmware during manufacturing. Use IoT FOTA (firmware over the air) to update keys.
C) Use a single shared encryption key for all devices. Rotate it annually via IoT Jobs.
D) Store device keys in AWS Secrets Manager. Have each device call Secrets Manager API directly.

**Correct Answer: A**
**Explanation:** The X.509 certificate-based approach (A) provides unique device identity and a secure channel for key rotation. IoT Jobs provide a managed mechanism to distribute new encrypted data keys to devices. The asymmetric device certificate enables secure key envelope — new symmetric data keys are encrypted with the device's public key and can only be decrypted by the device. Option B embedding keys in firmware is insecure and inflexible. Option C using a shared key means compromising one device compromises all. Option D requires each device to have IAM credentials for Secrets Manager, which is not scalable.

---

### Question 56
A company uses Amazon WorkSpaces for remote employees. They need to ensure that the WorkSpaces root and user volumes are encrypted, local data doesn't persist on thin client devices, and any data at rest on the WorkSpace uses a customer managed KMS key specific to the department.

What is the correct implementation?

A) Enable WorkSpaces encryption with a department-specific KMS CMK during WorkSpace creation. Enable MFA for WorkSpace authentication. Use WorkSpaces Streaming Protocol (WSP) which doesn't cache data on the client. Configure root and user volume encryption with the CMK.
B) Use WorkSpaces with encrypted AMIs. Configure Group Policy to disable local storage on the WorkSpace. Use the default AWS managed key.
C) Deploy Amazon AppStream 2.0 instead of WorkSpaces for fully non-persistent sessions. Use KMS encryption for streaming.
D) Use WorkSpaces Web for browser-based access. Store all data in S3 with SSE-KMS.

**Correct Answer: A**
**Explanation:** WorkSpaces (A) supports both root and user volume encryption with customer managed KMS keys specified at launch time. WSP (WorkSpaces Streaming Protocol) doesn't cache application data on the client device. Department-specific CMKs provide encryption key isolation. Option B uses the default key instead of department-specific. Option C replaces WorkSpaces entirely with AppStream, which may not meet all desktop requirements. Option D — WorkSpaces Web is browser-only and limited.

---

### Question 57
A company has a data pipeline that receives encrypted files from external partners. Each partner uses a different encryption method: Partner A uses PGP, Partner B uses AES-256-CBC with a pre-shared key, and Partner C uses S/MIME. After decryption, data must be re-encrypted with KMS for internal storage.

How should the decryption gateway be architected?

A) Deploy a decryption gateway using AWS Step Functions orchestrating Lambda functions. Each partner has a dedicated Lambda function with the appropriate decryption library (OpenPGP.js, crypto module, PKCS#7 library). Store partner-specific decryption keys in Secrets Manager. After decryption, use the AWS Encryption SDK to re-encrypt with KMS.
B) Use Amazon Managed Workflows for Apache Airflow (MWAA) with custom operators for each encryption type.
C) Deploy a single EC2 instance with GPG, OpenSSL, and S/MIME tools installed. Process files sequentially.
D) Require all partners to switch to S3 SSE-KMS by providing them with cross-account KMS access.

**Correct Answer: A**
**Explanation:** Step Functions with specialized Lambda functions (A) provides a scalable, serverless decryption gateway. Each partner's encryption method is handled by a dedicated function with the appropriate library. Secrets Manager stores partner keys securely with rotation capability. The AWS Encryption SDK standardizes internal encryption. Option B is more complex to operate and overkill for this use case. Option C is a single point of failure and doesn't scale. Option D requires partner changes which may not be feasible.

---

### Question 58
A company is implementing a tape backup replacement using AWS Storage Gateway Tape Gateway. They need to ensure that virtual tapes are encrypted, the encryption keys are managed by the company, and archived tapes in S3 Glacier are immutable for compliance.

Which configuration meets these requirements?

A) Deploy Tape Gateway with encryption enabled using a customer managed KMS key. Create virtual tapes that are automatically encrypted. When tapes are archived to S3 Glacier, they retain KMS encryption. Configure a Glacier Vault Lock policy to prevent deletion of archived tapes.
B) Deploy Tape Gateway without encryption. Configure S3 bucket default encryption for the gateway's S3 bucket. Use S3 Object Lock for immutability.
C) Deploy Tape Gateway. Encrypt backup data at the application level before writing to tape. Archive to Glacier and use vault access policies.
D) Deploy Tape Gateway with the default AWS managed key. Use S3 Lifecycle policies to transition to Glacier. Configure S3 Object Lock.

**Correct Answer: A**
**Explanation:** Tape Gateway (A) supports KMS encryption with customer managed keys for virtual tapes. Encryption is maintained when tapes are archived to S3 Glacier. Glacier Vault Lock provides immutability that even root users cannot override. Option B — you can't configure S3 bucket default encryption for Tape Gateway's managed buckets directly. Option C adds complexity and the application must handle encryption. Option D uses AWS managed key instead of customer managed, and S3 Lifecycle/Object Lock don't apply to Tape Gateway's Glacier archives the same way.

---

### Question 59
A company's data engineering team needs to implement column-level encryption in AWS Glue ETL jobs. Different columns need different KMS keys based on sensitivity, and the encrypted data must be queryable in Amazon Athena.

How should this be implemented?

A) Use the AWS Glue built-in encryption with security configurations for the entire dataset. Use Athena with KMS to decrypt.
B) Implement column-level encryption in the Glue job script using the AWS Encryption SDK. Encrypt sensitive columns with specific KMS keys. Store encryption metadata in the Glue Data Catalog. Use Athena UDFs backed by Lambda to decrypt columns at query time.
C) Use Apache Spark's built-in AES encryption in the Glue job. Store keys in Glue job parameters.
D) Write encrypted columns as separate Parquet files with different S3 SSE-KMS keys.

**Correct Answer: B**
**Explanation:** Column-level encryption in the Glue ETL script (B) with the AWS Encryption SDK provides granular control over which columns use which keys. Storing metadata in the Data Catalog helps track encryption. Athena UDFs (User Defined Functions) backed by Lambda can decrypt specific columns during queries, allowing authorized users to see plaintext while maintaining encryption at rest. Option A only provides dataset-level encryption. Option C stores keys insecurely in job parameters. Option D separating columns into different files breaks the data model and complicates queries.

---

### Question 60
A company operates in a highly regulated industry and needs to implement a key management governance framework. They need to track all KMS key lifecycle events, ensure keys are properly classified, detect orphaned keys, and generate compliance reports.

Which comprehensive key governance solution should be implemented?

A) Use AWS Config rules to monitor KMS key configurations (`kms-key-rotation-enabled`, custom rules for key policy compliance). Deploy AWS Security Hub with the CIS benchmark for KMS findings. Use a custom Lambda function to identify orphaned keys (keys with no recent CloudTrail usage). Generate compliance dashboards in Amazon QuickSight from Config and CloudTrail data.
B) Use AWS KMS console to manually review key policies monthly. Export key lists to CSV for tracking.
C) Use AWS Audit Manager with the KMS framework to automate compliance assessments and evidence collection.
D) Implement a third-party key management platform (e.g., Venafi) for comprehensive key lifecycle management.

**Correct Answer: A**
**Explanation:** The combination in option A provides comprehensive key governance. AWS Config monitors key configurations and policy compliance. Security Hub aggregates findings. Custom Lambda functions identify unused keys by analyzing CloudTrail. QuickSight provides visualization and reporting. Option B is manual and doesn't scale. Option C — Audit Manager helps with compliance assessments but doesn't provide the operational monitoring for orphaned keys and real-time governance. Option D adds external dependency and may not have full KMS integration.

---

### Question 61
A company is using Amazon Macie to discover and protect sensitive data in S3. They have 500 buckets across 10 accounts. They need to automatically apply bucket-level encryption to any bucket where Macie finds unencrypted PII, without disrupting existing read operations.

What is the most effective automated response?

A) Configure Macie findings to publish to EventBridge. Create an EventBridge rule for PII findings that triggers a Lambda function to: (1) check if the bucket has default encryption, (2) if not, apply SSE-KMS with the appropriate CMK as default encryption, (3) initiate S3 Batch Operations to re-encrypt existing unencrypted objects. Existing read operations are unaffected because default encryption only applies to new objects.
B) Configure Macie auto-remediation to apply bucket encryption directly.
C) Use AWS Config auto-remediation with `s3-bucket-server-side-encryption-enabled` rule.
D) Deploy a GuardDuty custom threat intelligence list that flags unencrypted PII buckets.

**Correct Answer: A**
**Explanation:** The EventBridge-driven approach (A) provides automated response to Macie findings. Setting default bucket encryption doesn't affect existing objects (maintaining read operations) while ensuring new uploads are encrypted. S3 Batch Operations handles re-encryption of existing unencrypted objects. Option B — Macie doesn't have native auto-remediation for encryption. Option C detects missing bucket encryption but isn't triggered by Macie PII findings specifically. Option D — GuardDuty doesn't handle encryption enforcement.

---

### Question 62
A company is running Amazon Neptune for a graph database containing sensitive relationship data. They need encryption at rest with a customer managed key, encryption in transit, and the ability to query encrypted data without performance degradation.

Which configuration is correct?

A) Enable Neptune cluster encryption at creation time with a customer managed KMS key. Neptune handles transparent encryption/decryption without query performance impact. Enable SSL/TLS for in-transit encryption by setting the `neptune_enforce_ssl` cluster parameter to `1`.
B) Implement application-layer encryption for sensitive properties before storing in Neptune. Use Lambda for encryption/decryption during queries.
C) Use Neptune Serverless which automatically encrypts all data. Configure VPC endpoints for in-transit security.
D) Deploy Neptune in a VPC with encrypted EBS volumes. Use a Network Load Balancer with TLS termination.

**Correct Answer: A**
**Explanation:** Neptune (A) supports native encryption at rest with customer managed KMS keys, applied at the cluster level during creation. The encryption is transparent to the application with minimal performance impact (hardware-accelerated AES-256). The `neptune_enforce_ssl` parameter mandates TLS for all connections. Option B adds significant query latency and complexity. Option C — Serverless doesn't automatically use customer managed keys and VPC endpoints don't encrypt traffic. Option D — Neptune doesn't use EBS directly and NLB TLS termination doesn't apply to Neptune's native protocol.

---

### Question 63
A company has a regulatory requirement that all database encryption keys must be rotated every 90 days. They use Amazon Aurora MySQL with KMS encryption. However, Aurora's KMS key rotation happens annually. How can they meet the 90-day requirement?

A) You cannot change Aurora's KMS key rotation frequency, but you can manually create a new KMS key every 90 days and create a new Aurora cluster from a snapshot, specifying the new key. Use blue/green deployment for zero-downtime cutover.
B) Enable KMS automatic rotation and change the rotation period to 90 days through the KMS API.
C) Use the `ModifyDBCluster` API to change the KMS key every 90 days.
D) Implement application-layer encryption with 90-day key rotation independent of Aurora's storage encryption.

**Correct Answer: A**
**Explanation:** KMS automatic key rotation only supports annual rotation (B is incorrect — the period cannot be changed for symmetric keys). The `ModifyDBCluster` API doesn't allow changing the KMS key (C is incorrect). The correct approach (A) is to create a new cluster from a snapshot with a new KMS key and use blue/green deployment for cutover. Option D adds application-layer encryption which addresses the requirement but adds significant complexity and performance overhead. Option A directly addresses the storage encryption key rotation requirement.

---

### Question 64
A company needs to implement data encryption for Amazon Kinesis Data Streams. They process 1 million records per second across 100 shards. Each record contains PII that must be encrypted before entering the stream.

Which encryption approach minimizes latency impact?

A) Enable Kinesis server-side encryption with a KMS CMK. Kinesis uses envelope encryption internally, generating data keys and caching them, so the latency impact is minimal.
B) Implement client-side encryption using the KMS `Encrypt` API for each record before putting it into the stream.
C) Use the AWS Encryption SDK with data key caching on the producer side. Configure cache limits based on throughput. Records are encrypted client-side with cached data keys, reducing KMS API calls.
D) Use a VPC endpoint for Kinesis with TLS. This provides sufficient encryption without additional overhead.

**Correct Answer: A**
**Explanation:** Kinesis server-side encryption (A) with KMS uses envelope encryption with internal data key caching, making it transparent and low-latency. At 1M records/second, the KMS API calls are amortized across many records since Kinesis caches the data key. Option B calling KMS per record would require 1M KMS calls/second, far exceeding rate limits. Option C works but adds complexity on the producer side. Option D — TLS only covers in-transit encryption, not at-rest.

---

### Question 65
A company uses AWS Transfer Family for SFTP file transfers from external partners. Files contain sensitive financial data and must be encrypted at rest. Different partners require different KMS keys for their data. The company also needs to scan files for malware before they are accessible to internal systems.

How should the post-upload workflow be designed?

A) Configure AWS Transfer Family with managed workflows. The workflow executes: (1) a custom Lambda step for malware scanning (using ClamAV in Lambda), (2) a copy-to-destination step with partner-specific KMS encryption based on the SFTP username mapped to the partner. Failed malware scans route files to a quarantine bucket.
B) Configure S3 event notifications on the Transfer Family bucket to trigger a Step Functions workflow for scanning and encryption.
C) Use Transfer Family's built-in antivirus scanning. Configure per-user encryption keys in the Transfer Family server settings.
D) Deploy a custom SFTP server on EC2 with antivirus software and encryption middleware.

**Correct Answer: A**
**Explanation:** Transfer Family managed workflows (A) provide native post-upload processing. Custom Lambda steps handle malware scanning, and the copy step handles partner-specific encryption. The SFTP username identifies the partner, mapping to the appropriate KMS key. Exception handling routes malicious files to quarantine. Option B adds architectural complexity with Step Functions when managed workflows handle this natively. Option C — Transfer Family doesn't have built-in antivirus. Option D loses the benefits of the managed service.

---

### Question 66
A company is implementing a Zero Trust architecture for their AWS environment. They want to ensure that all data access requests are authenticated, authorized, and encrypted, even within the VPC. Internal service-to-service communication must use mutual TLS with short-lived certificates.

Which architecture provides comprehensive Zero Trust data protection?

A) Deploy AWS App Mesh with Envoy proxy sidecars on all ECS services. Configure mTLS using AWS Private CA with short-lived certificates (24 hours). Use IAM Roles Anywhere for on-premises services. Implement VPC Lattice for service-to-service authentication and authorization. Enable EBS, S3, and RDS encryption with CMKs.
B) Use security groups and NACLs for network segmentation. Enable TLS on all internal load balancers. Use IAM for authentication.
C) Deploy a third-party Zero Trust platform (e.g., Zscaler) integrated with AWS. Route all traffic through the platform.
D) Use AWS PrivateLink for all service-to-service communication. Enable VPC Flow Logs for monitoring.

**Correct Answer: A**
**Explanation:** Option A implements comprehensive Zero Trust: App Mesh with mTLS ensures encrypted, authenticated communication between all services. Short-lived certificates from Private CA minimize the impact of certificate compromise. VPC Lattice provides service-level authentication and authorization. IAM Roles Anywhere extends identity to on-premises. Encryption at rest covers all storage. Option B relies on network-level controls which aren't Zero Trust. Option C adds external dependency. Option D — PrivateLink provides private connectivity but not mTLS or service-level auth.

---

### Question 67
A company uses AWS Lake Formation to manage access to their data lake. They need to implement cell-level security where specific cells in a table are encrypted and accessible only to users with the appropriate clearance level.

Which approach provides cell-level security in Lake Formation?

A) Use Lake Formation cell-level security with data filters that restrict access to specific rows and columns based on IAM principal tags. Combine with column-level encryption using the AWS Database Encryption SDK in the ETL pipeline.
B) Lake Formation natively supports cell-level encryption. Configure encryption policies in the Data Catalog.
C) Implement column-level access control in Lake Formation. For cell-level protection, use views in Amazon Redshift Spectrum that filter based on user context.
D) Store different classification levels in separate tables. Use Lake Formation permissions to control access to each table.

**Correct Answer: A**
**Explanation:** Lake Formation (A) provides row-level and column-level security through data filters but not native cell-level encryption. Combining Lake Formation's access control with application-level cell encryption via the Database Encryption SDK provides true cell-level protection. The data filters restrict which rows/columns a principal can see, while encryption ensures unauthorized access yields only ciphertext. Option B — Lake Formation doesn't natively encrypt at the cell level. Option C using Redshift Spectrum views is limited to Redshift query engine. Option D separating into tables loses the relational data model.

---

### Question 68
A company runs AWS ParallelCluster for HPC workloads processing classified data. They need to ensure that the shared file system (FSx for Lustre), compute node local storage, and inter-node MPI communication are all encrypted.

What is the correct encryption configuration?

A) Configure FSx for Lustre with encryption at rest using a KMS CMK and encryption in transit. Use encrypted EBS volumes for compute node local storage. Deploy the cluster in a VPC with a security group allowing only encrypted MPI traffic using Libfabric EFA with encryption enabled.
B) Use FSx for Lustre encryption at rest. Use instance store encryption for compute nodes. Rely on VPC encryption for inter-node traffic.
C) Implement application-level encryption for all data. Use unencrypted FSx for Lustre for performance.
D) Use FSx for Windows File Server instead of Lustre for encryption support. Configure SMB encryption for inter-node communication.

**Correct Answer: A**
**Explanation:** FSx for Lustre (A) supports both encryption at rest (KMS) and encryption in transit. EBS encryption protects compute node storage. EFA (Elastic Fabric Adapter) with Libfabric supports encryption for MPI traffic, ensuring inter-node communication is encrypted without significant performance impact. Option B — VPC doesn't provide automatic traffic encryption and instance stores aren't inherently encrypted. Option C sacrifices the file system encryption. Option D — FSx for Windows isn't suitable for HPC workloads.

---

### Question 69
A company has implemented AWS Control Tower and wants to enforce encryption standards across all new and existing accounts. They need preventive controls that block resource creation without encryption and detective controls that identify existing non-compliant resources.

Which implementation provides both preventive and detective encryption governance?

A) Enable Control Tower mandatory guardrails for encryption. Create custom SCPs that deny creation of unencrypted resources (EBS, RDS, S3, EFS, DynamoDB). Deploy AWS Config organizational rules for encryption compliance detection. Use Control Tower's Account Factory to apply encryption baselines to new accounts.
B) Use AWS Config conformance packs for encryption. Set up auto-remediation for all non-compliant resources.
C) Create a custom Control Tower blueprint that enables default encryption for all services. Apply to all managed accounts.
D) Use AWS Security Hub with the AWS Foundational Security Best Practices standard for encryption findings.

**Correct Answer: A**
**Explanation:** Combining Control Tower guardrails, custom SCPs, and Config organizational rules (A) provides comprehensive governance. SCPs are preventive (block non-compliant creation), Config rules are detective (find existing non-compliance), and Account Factory ensures new accounts are born compliant. Option B is detective only (Config) with remediation after the fact. Option C — there's no single blueprint that enables encryption for all services. Option D is detective only.

---

### Question 70
A company needs to encrypt Amazon DocumentDB data at rest with automatic key rotation. They also need to encrypt specific document fields within the database for defense-in-depth. The application runs on ECS Fargate.

Which architecture provides layered encryption?

A) Enable DocumentDB cluster encryption with a KMS CMK that has automatic rotation enabled. In the ECS application, use the AWS Encryption SDK to encrypt sensitive document fields before writing to DocumentDB. Store the field-level encryption metadata as additional document attributes. Decrypt in the application layer on read.
B) Use DocumentDB's built-in field-level encryption feature with KMS integration.
C) Enable DocumentDB encryption at rest with the AWS managed key. Implement client-side encryption using MongoDB's Client-Side Field Level Encryption (CSFLE) with a KMS provider.
D) Use DocumentDB encryption at rest only. Implement field-level access control using DocumentDB role-based access for defense-in-depth.

**Correct Answer: C**
**Explanation:** DocumentDB (C) is compatible with MongoDB drivers that support Client-Side Field Level Encryption (CSFLE). CSFLE with a KMS provider encrypts specific fields before they reach the database, providing defense-in-depth on top of the cluster-level encryption at rest. Option A using the Encryption SDK works but CSFLE (C) is more appropriate for document databases as it integrates with the MongoDB driver. Option B — DocumentDB doesn't have built-in field-level encryption. Option D provides access control but not encryption at the field level.

---

### Question 71
A global financial institution has a regulatory requirement that encryption keys used for EU customer data must never leave the EU. However, their application runs in both `eu-west-1` and `us-east-1`, and EU customer data may be processed in `us-east-1` during failover.

How should the encryption architecture handle this constraint?

A) Use KMS multi-Region keys with the primary in `eu-west-1` and a replica in `us-east-1`. This violates the requirement because key material would exist outside the EU.
B) Use KMS External Key Store (XKS) with the external key manager physically located in the EU. Configure XKS proxy endpoints in both Regions pointing to the same EU-based external key manager. All cryptographic operations use the EU-based key material regardless of which Region the application runs in.
C) Create separate KMS keys in each Region. Ensure EU data is only encrypted with the EU key.
D) Use CloudHSM in `eu-west-1` and connect from `us-east-1` over a cross-Region VPC peering connection.

**Correct Answer: B**
**Explanation:** KMS External Key Store (B) keeps key material in the EU-based external key manager. Even when the application in `us-east-1` performs cryptographic operations, the actual key operations occur at the external key manager in the EU. XKS proxy endpoints in both Regions connect to the same EU-based HSM. Option A violates data residency by placing key material in the US. Option C requires the application to track which key to use and doesn't work for failover scenarios. Option D adds significant latency for cross-Region HSM calls and creates network dependency.

---

### Question 72
A company is implementing Amazon GuardDuty with S3 protection. They want to automatically respond to findings where data exfiltration is detected by immediately revoking the compromised IAM credentials, enabling S3 Block Public Access, and creating a forensic copy of the affected bucket's access logs.

Which automated response architecture should be used?

A) Configure GuardDuty to publish findings to EventBridge. Create an EventBridge rule matching S3 exfiltration findings that triggers a Step Functions workflow. The workflow: (1) calls IAM to deactivate the access key from the finding, (2) enables S3 Block Public Access on the affected bucket, (3) copies S3 access logs and CloudTrail data events to a forensic bucket in an isolated account, (4) sends SNS notification to the security team.
B) Use GuardDuty auto-remediation feature to revoke credentials and block public access.
C) Configure Lambda to process all GuardDuty findings and take remediation actions based on finding type.
D) Use AWS Security Hub automated response and remediation playbooks for S3 findings.

**Correct Answer: A**
**Explanation:** The EventBridge + Step Functions approach (A) provides reliable, multi-step automated response. Step Functions handles the orchestration with error handling, retries, and parallel execution. The workflow addresses immediate containment (credential revocation, public access blocking) and forensics (log preservation). Option B — GuardDuty doesn't have native auto-remediation. Option C using a single Lambda function for complex multi-step remediation risks timeouts and error handling issues. Option D — Security Hub has some playbook functionality but not the specific multi-step workflow described.

---

### Question 73
A company is designing a backup strategy for Amazon EKS workloads including persistent volumes, cluster configurations, and application state. They need cross-Region backup capability with encryption and the ability to restore to a new EKS cluster in the DR Region within 4 hours.

Which backup strategy meets these requirements?

A) Use Velero (open source) with the AWS plugin for EKS backup. Configure Velero to snapshot EBS persistent volumes using CSI snapshots, back up Kubernetes resources to S3, and replicate to the DR Region S3 bucket with SSE-KMS encryption. Use Velero restore in the DR Region to recreate the cluster state. Store EKS cluster configuration in a Git repository (GitOps).
B) Use AWS Backup for EKS (native support). Configure cross-Region backup copy rules with KMS encryption. Use AWS Backup restore to recreate the cluster.
C) Take EBS snapshots of all nodes. Copy snapshots to DR Region. Launch new nodes from snapshots.
D) Use `kubectl` to export all resources as YAML. Store in S3 with cross-Region replication. Re-apply YAML in DR.

**Correct Answer: B**
**Explanation:** AWS Backup now natively supports EKS (B), providing integrated backup and restore for cluster resources and persistent volumes. Cross-Region copy rules with KMS encryption handle the DR requirement. AWS Backup's EKS restore can recreate cluster resources in a target cluster within the RTO. Option A (Velero) works but requires managing additional infrastructure. Option C only captures node state, not Kubernetes resources. Option D using `kubectl` export misses secrets, CRDs, and running state.

---

### Question 74
A company needs to implement encryption for Amazon Timestream for time-series IoT data. They require customer managed KMS key encryption, the ability to query encrypted data efficiently, and data retention policies that automatically delete data after compliance periods.

How should this be configured?

A) Timestream automatically encrypts all data at rest with a service-managed key. To use a customer managed KMS key, specify the CMK ARN when creating the Timestream database. Configure memory store and magnetic store retention policies for automatic data lifecycle management. Queries operate transparently on encrypted data.
B) Implement client-side encryption before writing to Timestream. Create custom query functions to decrypt results.
C) Use Timestream with default encryption. Implement a Lambda function to delete expired data based on timestamps.
D) Store time-series data in DynamoDB with KMS encryption instead. Use DynamoDB TTL for data lifecycle.

**Correct Answer: A**
**Explanation:** Timestream (A) supports customer managed KMS keys specified at the database level. Encryption is transparent — queries work without performance impact. Timestream's built-in retention policies (configurable for memory and magnetic stores) automatically manage data lifecycle, deleting data when the retention period expires. Option B client-side encryption prevents Timestream from querying the data. Option C using Lambda for deletion is unnecessary when Timestream has built-in retention. Option D replaces the service entirely and DynamoDB isn't optimized for time-series queries.

---

### Question 75
A multinational corporation needs to implement a comprehensive data protection strategy that covers data classification, encryption, key management, backup, and monitoring across 200 AWS accounts in 12 Regions. They need a centralized governance model with federated execution.

Which architecture provides enterprise-scale data protection?

A) Deploy a centralized security account with: (1) Amazon Macie delegated administrator for data discovery across all accounts, (2) KMS multi-Region keys managed centrally with key policies allowing federated account usage, (3) AWS Backup with organizational backup policies for cross-account/Region backup, (4) AWS Config organizational rules for encryption compliance, (5) Security Hub aggregation for findings, (6) CloudTrail organization trail with data events for KMS and S3.
B) Each account manages its own encryption, backup, and monitoring independently using standardized CloudFormation templates.
C) Use a single centralized account for all data storage with KMS encryption. Other accounts access data through cross-account roles.
D) Deploy a third-party data protection platform across all accounts using a shared services architecture.

**Correct Answer: A**
**Explanation:** Option A provides the comprehensive centralized governance with federated execution model. Macie provides organization-wide data discovery. Multi-Region KMS keys with centralized management ensure consistent key governance. AWS Backup organizational policies automate cross-account/Region backup. Config organizational rules enforce compliance. Security Hub aggregates findings. CloudTrail organization trail provides audit. Option B lacks centralized governance. Option C creates a single point of failure and doesn't scale. Option D adds third-party dependency and integration complexity.

---
