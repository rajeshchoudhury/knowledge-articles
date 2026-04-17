# Practice Exam 39 - AWS Solutions Architect Associate (SAA-C03) - FINAL BOSS

## Exam Information
- **Questions:** 65
- **Time Limit:** 130 minutes
- **Passing Score:** 72%
- **Difficulty:** EXTREME — The hardest practice exam in this entire study guide
- **If you score 75%+ on this exam, you will DEFINITELY pass the real SAA-C03**
- Every question requires deep understanding of multiple AWS services
- Multiple response questions require selecting EXACTLY the right combination

### Domain Breakdown
| Domain | Questions | Percentage |
|--------|-----------|------------|
| Security | 1–13 | ~20% |
| Resilient Architecture | 14–30 | ~26% |
| High-Performing Architecture | 31–46 | ~25% |
| Cost-Optimized Architecture | 47–65 | ~29% |

---

## Questions

---

### Question 1

A financial services company processes credit card transactions across 12 AWS accounts organized under AWS Organizations. The security team requires that all Amazon S3 objects containing cardholder data be encrypted using customer-managed AWS KMS keys. The encryption keys must be rotated annually, and the key policy must ensure that only the specific Lambda functions in each account (identified by their execution role ARNs) can perform `kms:Decrypt` operations. The central security account must retain the ability to audit key usage and disable keys in an emergency, but must NOT be able to decrypt the data itself. A junior architect proposes sharing the KMS key via a key policy that grants `kms:*` to the Organizations management account. What is the MOST secure approach that satisfies ALL requirements?

A) Create a customer-managed KMS key in each of the 12 accounts. Configure the key policy to grant `kms:Decrypt` only to the specific Lambda execution role ARNs. Share key metadata with the central security account using AWS RAM. Enable automatic key rotation and grant `kms:DescribeKey`, `kms:DisableKey`, and `kms:GetKeyPolicy` to the security account's IAM role via the key policy.

B) Create a single customer-managed KMS key in the central security account. Use KMS grants to delegate `kms:Decrypt` to each Lambda execution role in the 12 accounts with a `GranteePrincipal` constraint. Enable automatic key rotation. The security account retains full administrative control over the key.

C) Create a customer-managed KMS key in each of the 12 accounts. Configure the key policy to grant `kms:Decrypt` to the specific Lambda execution role ARNs using conditions on `kms:ViaService` restricted to `s3.*.amazonaws.com`. Grant the central security account's role `kms:DescribeKey`, `kms:DisableKey`, `kms:EnableKey`, `kms:GetKeyRotationStatus`, and `kms:ListGrants` but explicitly deny `kms:Decrypt` and `kms:Encrypt`. Enable automatic annual key rotation.

D) Create a single customer-managed KMS key in the central security account and share it to all 12 accounts using an Organization-level KMS key policy with `aws:PrincipalOrgID` condition. Grant `kms:Decrypt` to `*` with a condition of `kms:CallerAccount` matching each of the 12 account IDs. Enable automatic key rotation.

---

### Question 2

A healthcare SaaS company must comply with both HIPAA and PCI DSS requirements. They store electronic Protected Health Information (ePHI) in Amazon RDS for PostgreSQL and process payment card data through an application running on Amazon ECS Fargate. The compliance officer requires that: (1) ePHI at rest uses AES-256 encryption with keys the company controls, (2) payment card data is tokenized before storage, (3) all administrative access to production resources is logged and requires MFA, (4) network traffic between the ECS tasks and RDS is encrypted in transit, and (5) no production data leaves the us-east-1 Region. The team currently uses IAM users with long-term credentials for administrative access. Which combination of changes addresses ALL five compliance requirements? (Select THREE.)

A) Enable RDS encryption using AWS-managed keys, configure SSL/TLS enforcement on the RDS instance by setting `rds.force_ssl=1` in the parameter group, and deploy a tokenization microservice using AWS Lambda that integrates with AWS Payment Cryptography to tokenize card data before it reaches the ECS application.

B) Enable RDS encryption using a customer-managed KMS key with annual rotation, configure SSL/TLS enforcement on the RDS instance by setting `rds.force_ssl=1` in the parameter group, and deploy a tokenization service within the ECS cluster using the AWS Encryption SDK to tokenize card data before storage.

C) Migrate all administrative users from IAM users to AWS IAM Identity Center (SSO) with MFA enforced via an SCP. Enable AWS CloudTrail with log file validation in us-east-1, and configure an SCP that denies all actions outside us-east-1 except for global services (IAM, STS, CloudFront).

D) Configure security groups on ECS tasks to only allow outbound traffic to the RDS security group on port 5432. Enable VPC Flow Logs and ship them to a dedicated CloudWatch Logs group with a 365-day retention policy. Attach an SCP to the OU denying `ec2:RunInstances` outside us-east-1.

E) Enable AWS Config rules for `rds-storage-encrypted`, `ecs-task-definition-log-configuration`, and `cloudtrail-enabled`. Set up automated remediation using Systems Manager Automation to re-encrypt any non-compliant RDS instances.

---

### Question 3

A multinational bank is designing a zero-trust network architecture on AWS for their trading platform. The platform runs on Amazon EKS across three Availability Zones and communicates with 15 internal microservices via REST APIs. Requirements include: (1) no traffic traverses the public internet, (2) each microservice can only communicate with explicitly approved services, (3) all API calls are authenticated and authorized at the network layer, (4) the architecture must support 50,000 concurrent connections with sub-2ms added latency, and (5) the security team must be able to revoke any service's access within 30 seconds. The team is considering AWS PrivateLink but is concerned about the 50-endpoint-per-VPC limit. What is the MOST operationally efficient architecture that meets ALL requirements?

A) Deploy all 15 microservices in a single VPC using VPC Lattice. Define a service network with auth policies that specify which services can communicate. Use IAM-based auth policies on each Lattice service with `aws:PrincipalTag` conditions mapping to service identities. To revoke access, update the auth policy for the target service.

B) Deploy each microservice in its own VPC and create VPC PrivateLink endpoints between each pair of approved services. Use security groups on the endpoints to control access. To stay within the 50-endpoint limit, consolidate related microservices into shared VPCs, reducing to 6 VPCs with a maximum of 30 endpoints each.

C) Deploy all microservices in a single VPC. Use an internal Application Load Balancer for each microservice with mutual TLS (mTLS) authentication. Configure ALB listener rules to allow traffic only from specific client certificates. Use AWS Certificate Manager Private CA to issue and revoke certificates within 30 seconds.

D) Deploy all microservices in a single VPC with AWS App Mesh as the service mesh. Configure Envoy sidecar proxies with mTLS between services. Define virtual services and virtual routers to control traffic routing. Integrate App Mesh with AWS PrivateLink for cross-VPC communication if needed. Revoke access by updating App Mesh virtual service policies.

---

### Question 4

A government agency uses AWS GovCloud (US) for classified workloads. They have a central logging account that collects CloudTrail, VPC Flow Logs, and GuardDuty findings from 30 member accounts via AWS Organizations. The CISO requires: (1) all logs must be immutable for 7 years, (2) no single administrator can delete or modify log data, (3) GuardDuty findings rated HIGH must trigger automated containment within 5 minutes, (4) the logging architecture must survive the complete loss of one AWS Region, and (5) cross-account log access must use temporary credentials with a maximum 1-hour session duration. A solutions architect proposes using a single S3 bucket with Object Lock. What additional changes are needed to meet ALL requirements?

A) Enable S3 Object Lock in Compliance mode with a 7-year retention period on the logging bucket. Enable S3 Cross-Region Replication to a bucket in a second GovCloud Region with identical Object Lock settings. Configure GuardDuty to send HIGH findings to EventBridge, which triggers a Step Functions workflow that isolates compromised resources by modifying security groups and detaching IAM policies. Use cross-account IAM roles with a `MaxSessionDuration` of 3600 seconds for log access.

B) Enable S3 Object Lock in Governance mode with a 7-year retention period. Use S3 Same-Region Replication for redundancy. Configure GuardDuty to publish to SNS, triggering a Lambda function that quarantines EC2 instances using Systems Manager. Use AWS SSO with 1-hour session policies for cross-account access.

C) Enable S3 Object Lock in Compliance mode with a 7-year retention period. Enable S3 Cross-Region Replication to a bucket in a second GovCloud Region with identical Object Lock settings. Configure GuardDuty findings to trigger EventBridge rules in each member account that invoke a centralized Lambda function via cross-account IAM roles to isolate resources. Use IAM Identity Center with permission sets limited to 1-hour sessions for log access.

D) Enable S3 Versioning with MFA Delete. Configure a bucket policy denying `s3:DeleteObject` and `s3:PutObject` for all principals except the logging service role. Use a single Region with S3 Standard-IA for cost optimization. Configure GuardDuty multi-account via Organizations with a delegated administrator account. Use EventBridge to trigger automated remediation.

---

### Question 5

A security-conscious e-commerce company runs a three-tier web application on AWS. The web tier uses Amazon CloudFront with an Application Load Balancer origin. The application tier runs on EC2 instances in private subnets, and the data tier uses Amazon Aurora MySQL. During a recent penetration test, the security team discovered that: (1) the ALB is accessible directly via its DNS name, bypassing CloudFront WAF rules, (2) the EC2 instances can reach the internet through a NAT Gateway, which could be used for data exfiltration, and (3) database credentials are hardcoded in the application configuration files. The CTO wants ALL three vulnerabilities fixed with MINIMUM operational overhead. Which combination of actions addresses all three vulnerabilities? (Select TWO.)

A) Configure CloudFront to add a custom HTTP header (e.g., `X-Custom-Header: <secret-value>`) to origin requests. Create an ALB listener rule that returns HTTP 403 for any request missing this header. Store the secret value in AWS Secrets Manager with automatic rotation every 30 days, and update both CloudFront and the ALB rule via a Lambda function triggered by the rotation event.

B) Associate AWS WAF with both CloudFront and the ALB, using the same web ACL. Configure the ALB security group to allow inbound traffic only from CloudFront's managed prefix list. Replace the NAT Gateway with VPC endpoints for the specific AWS services the application needs (S3, STS, Secrets Manager, CloudWatch). Migrate database credentials to Secrets Manager with automatic rotation.

C) Configure the ALB security group to allow inbound traffic only from the CloudFront managed prefix list (`com.amazonaws.global.cloudfront.origin-facing`). Replace the NAT Gateway with VPC interface endpoints for required AWS services (Secrets Manager, CloudWatch, STS) and a gateway endpoint for S3. Migrate database credentials to AWS Secrets Manager with automatic rotation using the built-in Lambda rotation function for Aurora MySQL.

D) Move the ALB into a private subnet with no internet gateway route. Create a VPC PrivateLink connection from CloudFront to the ALB. Remove the NAT Gateway and configure all outbound traffic to route through an AWS Network Firewall for inspection. Store database credentials in AWS Systems Manager Parameter Store SecureString parameters.

E) Configure CloudFront Origin Access Control (OAC) for the ALB origin to sign requests with SigV4. Configure the ALB to validate the SigV4 signature. Remove the NAT Gateway and deploy all AWS API calls through VPC endpoints. Migrate database credentials to Secrets Manager with automatic rotation.

---

### Question 6

A data analytics company operates a multi-tenant platform where each tenant's data is stored in a separate S3 prefix within a shared bucket. The platform has 500 tenants, and each tenant has between 1 and 50 users who access data via a custom web application. The security team requires: (1) each user can only access their own tenant's data, (2) access must use temporary credentials that expire within 15 minutes, (3) no IAM users or roles should be created per-tenant, (4) the solution must support SAML 2.0 federation with each tenant's own identity provider, and (5) audit logs must show which tenant user accessed which S3 objects. The current approach creates one IAM role per tenant (500 roles) which is approaching account limits. What is the MOST scalable approach that meets ALL requirements?

A) Use Amazon Cognito Identity Pools with a separate User Pool for each tenant's SAML IdP. Configure the Identity Pool to use attribute-based access control (ABAC) with a tag `tenant_id` derived from the SAML assertion. Create a single IAM role for authenticated users with an inline policy using `s3:prefix` condition keys matching `${aws:PrincipalTag/tenant_id}`. Set the Cognito session duration to 15 minutes.

B) Use IAM Identity Center with external SAML federation. Create permission sets with inline policies that use session tags. Map each tenant's SAML assertion `tenant_id` attribute to an AWS session tag. Create a single permission set with an S3 policy using `${aws:PrincipalTag/tenant_id}` as the prefix condition. Limit session duration to 15 minutes.

C) Use Amazon Cognito Identity Pools with a single User Pool configured with multiple SAML identity providers (one per tenant). Map the SAML `tenant_id` attribute to a Cognito custom attribute. Use a Lambda trigger (Pre Token Generation) to inject `tenant_id` as a session tag into the identity token. Create a single IAM role with a trust policy for the Identity Pool and an inline policy using `${aws:PrincipalTag/tenant_id}` to restrict S3 access. Configure token expiration to 15 minutes. Enable CloudTrail data events for S3 with the `userIdentity` field capturing the Cognito identity.

D) Implement a custom token vending machine using API Gateway and Lambda. When a user authenticates via their tenant's SAML IdP, the Lambda function calls `sts:AssumeRole` on a single IAM role, passing `tenant_id` as a session tag. The role's policy uses `${aws:PrincipalTag/tenant_id}` for S3 prefix restriction. Set `DurationSeconds` to 900 (15 minutes). Log all STS calls via CloudTrail.

---

### Question 7

A financial trading company runs a low-latency order matching engine on AWS. The application stores session state in Amazon ElastiCache for Redis (cluster mode enabled) with 6 shards. A recent security audit found that: (1) Redis AUTH is not enabled, (2) data in transit between the application and Redis is unencrypted, (3) the ElastiCache subnet group includes public subnets, (4) there are no automated backups, and (5) the same Redis cluster is used for both production trading and a development/testing environment. The security team requires all five issues to be resolved with ZERO downtime to the production trading system. What is the correct sequence of actions?

A) Create a new ElastiCache Redis cluster with in-transit encryption enabled, AUTH token configured, deployed in private subnets only, with automated daily backups and a 35-day retention period. Use the new cluster exclusively for production. Migrate production traffic using application-level dual-write to both clusters during transition. Decommission the old cluster after cutover. Create a separate, smaller Redis cluster for dev/test.

B) Modify the existing cluster to enable in-transit encryption and AUTH. Update the subnet group to remove public subnets. Enable automated backups. These changes can be applied with a maintenance window that causes a brief disruption. Create a separate cluster for dev/test.

C) Enable in-transit encryption on the existing cluster by modifying the replication group (supported without downtime since ElastiCache 7.0+). Set an AUTH token using the `modify-replication-group` API with `--auth-token` and `--apply-immediately`. Modify the subnet group to only include private subnets. Enable automated backups with a 35-day retention period. Tag the cluster as `production` and create a separate cluster for dev/test.

D) Create a new ElastiCache Redis cluster with in-transit encryption, AUTH, private subnets, and automated backups. Use ElastiCache Global Datastore to replicate data from the old cluster to the new one. Switch the application connection string to the new cluster. Decommission the old cluster. Create a separate cluster for dev/test.

---

### Question 8

A company is implementing AWS Security Hub across 200 accounts in their AWS Organization. They need to aggregate findings from GuardDuty, Inspector, IAM Access Analyzer, and Firewall Manager. Requirements include: (1) a delegated administrator account for Security Hub, (2) custom security standards that check for company-specific compliance rules (e.g., all EC2 instances must have a `CostCenter` tag), (3) automated suppression of findings from sandbox accounts, (4) critical findings must create Jira tickets within 5 minutes, and (5) the solution must automatically enable Security Hub on any new account added to the Organization. An architect suggests using Security Hub's auto-enable feature with custom actions. What is the complete architecture that meets ALL requirements?

A) Designate the security account as the Security Hub delegated administrator. Enable auto-enable for new accounts via Organizations integration. Create AWS Config custom rules for company-specific checks and import findings into Security Hub using the `BatchImportFindings` API. Create an EventBridge rule matching Security Hub findings with `ProductName` filter for sandbox accounts, targeting a Lambda function that calls `BatchUpdateFindings` to set `Workflow.Status` to `SUPPRESSED`. Create a second EventBridge rule for CRITICAL severity findings targeting an API Gateway endpoint that invokes a Lambda function to create Jira tickets via the Jira REST API.

B) Designate the security account as the Security Hub delegated administrator. Enable auto-enable via Organizations integration. Deploy custom Security Hub controls using AWS Config conformance packs pushed via CloudFormation StackSets. Create an EventBridge rule filtering findings where `AwsAccountId` matches sandbox account IDs, targeting a Lambda that suppresses findings. For Jira integration, configure Security Hub custom actions linked to EventBridge rules that trigger a Step Functions workflow calling the Jira API.

C) Designate the security account as the Security Hub delegated administrator. Enable auto-enable for new accounts. Deploy custom Config rules via CloudFormation StackSets and use the Security Hub integration with Config to import findings. Create EventBridge rules in the delegated admin account matching findings from sandbox accounts (using `AwsAccountId` filter) that target a Lambda function to set `Workflow.Status` to `SUPPRESSED`. Create an EventBridge rule matching `Security Hub Findings - Imported` events with severity `CRITICAL` that triggers a Lambda function to create Jira tickets. Deploy these EventBridge rules using infrastructure as code.

D) Enable Security Hub in each account individually using a CloudFormation StackSet. Create custom insights for company-specific compliance rules. Use SNS topics for cross-account finding aggregation. Filter sandbox findings using SNS message filtering policies. For Jira integration, subscribe a Lambda function to the SNS topic that creates tickets for critical findings.

---

### Question 9

A company has deployed an Amazon API Gateway REST API that serves as the front door for 30 microservices. The API receives 10,000 requests per second at peak. Security requirements include: (1) OAuth 2.0 token validation with custom claims, (2) rate limiting per customer (identified by API key) at 100 requests/second, (3) request/response payload validation against JSON schemas, (4) protection against SQL injection and XSS in all request parameters, (5) the ability to block requests from specific countries within 60 seconds of a threat intelligence update. Currently, all validation is done in the backend Lambda functions, adding 50ms latency per request. What architecture MINIMIZES latency while meeting ALL security requirements?

A) Deploy a CloudFront distribution in front of API Gateway. Attach AWS WAF with SQL injection and XSS rule groups to CloudFront. Create a Lambda@Edge function for OAuth token validation. Configure API Gateway usage plans with API keys for per-customer rate limiting at 100 req/s. Enable request validation in API Gateway using JSON schema models. For geo-blocking, update the WAF geographic match rule via a Lambda function triggered by an SNS topic that publishes threat intelligence updates.

B) Attach AWS WAF with managed rule groups for SQL injection and XSS directly to the API Gateway. Create an API Gateway Lambda authorizer with caching enabled (TTL 300 seconds) for OAuth 2.0 token validation. Configure API Gateway usage plans with API keys for rate limiting at 100 req/s per customer. Enable API Gateway request validators with JSON schema models on each method. For geo-blocking, update a WAF geo-match rule set via a Lambda function that subscribes to the threat intelligence SNS topic.

C) Deploy a CloudFront distribution in front of API Gateway with AWS WAF attached. Configure WAF with SQL injection, XSS, and geo-blocking rules. Use a CloudFront Function for OAuth token validation and country-based blocking. Configure API Gateway with usage plans and API keys for rate limiting. Enable request validation with JSON schema models on API Gateway methods.

D) Use API Gateway HTTP API (v2) instead of REST API for lower latency. Attach a JWT authorizer for OAuth 2.0 validation. Configure route-level throttling at 100 req/s per route. Attach AWS WAF for SQL injection and XSS protection. Use API Gateway parameter mapping for request validation.

---

### Question 10

An insurance company manages policyholder documents in Amazon S3. The bucket contains 50 million objects totaling 80 TB. Regulatory requirements mandate that: (1) documents must be retrievable within 4 hours for the first 2 years, (2) documents must be retained for 10 years total but can tolerate 12-hour retrieval after year 2, (3) no document can be deleted or overwritten by anyone, including the root user, before its 10-year retention expires, (4) a quarterly audit must verify that no documents have been tampered with, and (5) the solution must minimize storage costs. The current setup uses S3 Standard with no versioning or lifecycle policies. What is the MINIMUM set of changes to meet ALL requirements?

A) Enable S3 Versioning. Enable S3 Object Lock in Compliance mode with a 10-year retention period. Create a lifecycle rule to transition objects to S3 Glacier Flexible Retrieval after 2 years. Enable S3 Inventory with a weekly schedule and configure an Athena query to compare inventory reports quarterly for tamper detection. Use S3 Storage Lens for cost monitoring.

B) Enable S3 Versioning and S3 Object Lock in Compliance mode with a 10-year retention period on the bucket. Create a lifecycle rule to transition current versions to S3 Standard-IA after 30 days, to S3 Glacier Flexible Retrieval after 2 years, and to S3 Glacier Deep Archive after 5 years. For quarterly audits, enable CloudTrail data events for the bucket and use Athena to query CloudTrail logs for any `PutObject` or `DeleteObject` operations that might indicate tampering.

C) Enable S3 Versioning and S3 Object Lock in Governance mode with a 10-year retention period. Create lifecycle rules transitioning to S3 Glacier Instant Retrieval after 2 years. Enable S3 Object Lambda to verify document integrity on retrieval. Use AWS Config rule `s3-bucket-object-lock-enabled` for compliance monitoring.

D) Enable S3 Versioning and S3 Object Lock in Compliance mode with a 10-year default retention period. Create lifecycle rules: transition to S3 Intelligent-Tiering after 30 days (which auto-moves to Archive Access after 90 days and Deep Archive Access after 180 days). For quarterly audits, use S3 Batch Operations to run a checksum verification job against stored checksums. Use S3 event notifications to trigger a Lambda for real-time tamper detection.

---

### Question 11

A global media company serves video content from Amazon S3 through Amazon CloudFront. They've detected that premium content URLs are being shared on social media, allowing unauthorized access. Requirements include: (1) only authenticated subscribers can access premium content, (2) URLs must expire within 2 hours, (3) access must be restricted to specific geographic regions per content license, (4) the solution must support 100,000 concurrent viewers with no increased origin load, (5) the security mechanism must work for both HLS streaming segments and thumbnail images, and (6) switching to a new signing key must not invalidate existing active sessions. What is the MOST complete solution?

A) Create a CloudFront key group with two public keys (for key rotation). Use CloudFront signed URLs with a 2-hour expiration for all premium content. Configure CloudFront geo-restriction to allow only licensed countries. Enable Origin Shield in the Region closest to the S3 bucket to reduce origin load. Use S3 as the origin with OAC to prevent direct S3 access.

B) Create a CloudFront key group with two public keys. Use CloudFront signed cookies (instead of signed URLs) with a 2-hour expiration, setting the cookie path to the premium content prefix. Configure CloudFront geo-restriction allow lists per distribution (one per content license region). Enable Origin Shield to minimize origin requests. Use S3 with OAC as the origin. For key rotation, add the new key to the key group before removing the old one.

C) Use Lambda@Edge on the viewer-request event to validate JWT tokens against the subscriber database. Implement custom geo-restriction logic in the Lambda@Edge function based on content license rules. Enable CloudFront caching with Origin Shield to reduce origin load. Use signed URLs for the initial playlist manifest and unsigned URLs for subsequent segments.

D) Configure CloudFront field-level encryption to protect the subscriber token in the URL. Use a CloudFront Function on viewer-request to validate the token and check geographic restrictions. Enable Origin Shield. Use signed URLs with a 2-hour policy for all content types. Rotate keys using CloudFront key groups.

---

### Question 12

A SaaS company runs a multi-account AWS environment with 50 accounts organized into OUs: Production, Development, Sandbox, and Security. They've experienced an incident where a developer in a Sandbox account created an IAM role that could be assumed by an external AWS account, leading to data exfiltration. The CISO requires a preventive control framework that: (1) prevents any IAM role from being assumed by principals outside the Organization, (2) allows specific exceptions for approved third-party integrations (tracked in a DynamoDB table), (3) prevents any account from disabling CloudTrail or GuardDuty, (4) restricts Sandbox accounts to only t3.micro and t3.small EC2 instances, and (5) all controls must be applied automatically to new accounts. What is the CORRECT combination of controls?

A) Create an SCP attached to the root OU with a `Deny` statement for `sts:AssumeRole` where `aws:PrincipalOrgID` does not equal the Organization ID, with `StringNotEquals` condition. Create a second SCP denying `cloudtrail:StopLogging`, `cloudtrail:DeleteTrail`, `guardduty:DisableOrganizationAdminAccount`, and `guardduty:DeleteDetector`. Create a third SCP attached to the Sandbox OU denying `ec2:RunInstances` unless `ec2:InstanceType` is `t3.micro` or `t3.small`. For third-party exceptions, add `StringEquals` conditions for specific external account IDs in the SCP.

B) Create an SCP attached to the root OU with a `Deny` on `iam:CreateRole` and `iam:UpdateAssumeRolePolicy` where the role trust policy contains principals outside the Organization, using `StringNotLike` on `iam:PolicyDocument`. Create SCPs denying CloudTrail and GuardDuty disablement. Attach instance-type restriction SCP to Sandbox OU. Manage third-party exceptions by excluding specific account IDs from the deny statement.

C) Apply an SCP to the root OU that denies `iam:CreateRole`, `iam:UpdateAssumeRolePolicy`, and `sts:AssumeRole` actions when `aws:PrincipalOrgID` doesn't match, combined with denials on CloudTrail and GuardDuty modification actions. Attach an SCP to the Sandbox OU restricting `ec2:RunInstances` to t3.micro and t3.small using `ec2:InstanceType` condition. For approved third-party exceptions, use a Lambda-backed custom EventBridge rule that reads from DynamoDB and dynamically updates the SCP deny statement with allowed external account IDs. Deploy all SCPs via CloudFormation StackSets for automatic application to new accounts.

D) Create an IAM permission boundary attached to all roles and users across all accounts via CloudFormation StackSets. The permission boundary denies cross-account access, CloudTrail/GuardDuty changes, and large instance types in Sandbox. Use a Lambda function to read the DynamoDB exception table and update permission boundaries dynamically.

---

### Question 13

A pharmaceutical company is building a drug discovery pipeline on AWS that processes sensitive genomic data. The data classification policy requires: (1) Amazon Macie to continuously scan all S3 buckets for PII/PHI, (2) any file containing genomic identifiers must be automatically moved to a quarantine bucket with restricted access within 10 minutes, (3) all quarantined files must be reviewed by the compliance team before being released or permanently deleted, (4) the pipeline must process 5 TB of new data daily across 20 S3 buckets, and (5) the solution must integrate with the company's existing ServiceNow ITSM for ticket creation. A developer proposes running Macie classification jobs on a daily schedule. Why is this insufficient, and what architecture meets the time requirement?

A) Daily Macie jobs don't meet the 10-minute requirement. Instead, configure Macie to run automated sensitive data discovery continuously on all 20 buckets. Create an EventBridge rule matching Macie findings of type `SensitiveData:S3Object/Personal` with custom data identifiers for genomic patterns. The rule triggers a Step Functions workflow that: (1) copies the object to the quarantine bucket using S3 `CopyObject` with a KMS key restricted to the compliance team, (2) deletes the original, (3) creates a ServiceNow ticket via an API Gateway integration, (4) waits for a callback token from the compliance review, and (5) either permanently deletes or restores the file based on the review outcome.

B) Daily Macie jobs don't meet the 10-minute requirement. Enable Macie automated sensitive data discovery for all 20 buckets. Configure custom data identifiers for genomic patterns. Create an EventBridge rule for Macie findings targeting a Lambda function that moves objects to the quarantine bucket using S3 Batch Operations. The Lambda also sends an SNS notification to the compliance team and creates a ServiceNow incident via a second Lambda function. The compliance team manually releases or deletes files.

C) Daily Macie jobs are sufficient if scheduled every 10 minutes. Configure Macie to run a classification job every 10 minutes across all 20 buckets with custom data identifiers. Use S3 event notifications to trigger a Lambda function that quarantines flagged objects. Create ServiceNow tickets via EventBridge API Destinations.

D) Daily Macie jobs don't meet the 10-minute requirement. Instead, deploy a real-time scanning solution using S3 event notifications that trigger a Lambda function on every `PutObject` event. The Lambda uses Amazon Comprehend Medical to detect PHI and a custom ML model for genomic identifiers. Files containing sensitive data are moved to the quarantine bucket. EventBridge Pipes routes the detection events to an API Destination configured for the ServiceNow API.

---

### Question 14

A ride-sharing company operates in 15 countries and needs a disaster recovery strategy for their core ride-matching platform. The platform uses Amazon Aurora MySQL with 500 GB of data, an Amazon MSK cluster processing 100,000 events/second, an Amazon ElastiCache Redis cluster with 50 GB of session data, and an EKS cluster running 200 microservices. Requirements: (1) RPO of 5 minutes for the database, (2) RPO of 0 for in-flight ride events, (3) RTO of 15 minutes for the complete platform, (4) the DR Region must be in the EU for GDPR compliance, (5) monthly DR costs must not exceed $15,000, and (6) a DR test must be executable without impacting production. What architecture meets ALL requirements?

A) Deploy Aurora Global Database with a secondary cluster in eu-west-1 (RPO ~1 second). Deploy a standby MSK cluster in eu-west-1 with MirrorMaker 2.0 replicating all topics in real-time for zero RPO on events. Use ElastiCache Global Datastore for Redis replication to eu-west-1. Maintain a scaled-down EKS cluster in eu-west-1 with all microservice images pre-deployed but running at minimum replicas (1 pod each). During failover, promote Aurora secondary, scale up EKS, and update Route 53 health checks. For DR testing, use Route 53 failover routing with a test domain that points to the DR Region.

B) Use Aurora cross-Region read replicas in eu-west-1 with binary log replication. Deploy MSK Connect with S3 sink connector to replicate events to eu-west-1, then replay from S3 during failover. Use ElastiCache snapshots exported to S3 and replicated cross-Region. Store EKS manifests in a CodeCommit repository. During failover, promote Aurora replica, recreate MSK, restore ElastiCache from snapshot, and deploy EKS via CodePipeline.

C) Deploy Aurora Global Database in eu-west-1. Use Amazon Kinesis Data Streams cross-Region replication instead of MSK standby (convert MSK topics to Kinesis streams for DR). Use ElastiCache Global Datastore. Deploy an EKS cluster in eu-west-1 using Karpenter for rapid node scaling from zero. Use AWS Backup with cross-Region copy rules for all data stores.

D) Configure Aurora automated backups with cross-Region backup to eu-west-1 (RPO ~5 minutes). Use MSK multi-cluster replication in eu-west-1. Use ElastiCache backup and restore from S3 snapshots replicated to eu-west-1. Maintain EKS cluster configurations in CloudFormation templates stored in S3. Deploy the entire DR environment from templates during failover.

---

### Question 15

A social media platform stores user-generated content including images and videos in Amazon S3. The platform receives 50,000 uploads per minute. Each upload triggers a processing pipeline: thumbnail generation, content moderation (using Amazon Rekognition), metadata extraction, and database update. The current architecture uses S3 event notifications to a single SQS queue consumed by a fleet of EC2 instances. During a recent viral event, the pipeline fell 2 hours behind. The platform needs to process each upload within 30 seconds end-to-end while handling 5x burst capacity (250,000 uploads/minute). What architecture provides the MOST reliable processing within the latency requirement?

A) Replace the single SQS queue with an SNS topic that fans out to four separate SQS queues (one per processing step). Use Lambda functions consuming from each queue with reserved concurrency set to handle peak load: thumbnail Lambda (1,000 concurrent), Rekognition Lambda (500 concurrent with retries for throttling), metadata Lambda (200 concurrent), database Lambda (200 concurrent). Configure each SQS queue with a visibility timeout of 60 seconds and a DLQ after 3 retries.

B) Replace the EC2 fleet with a Step Functions Express Workflow triggered by S3 event notifications via EventBridge. The workflow runs thumbnail generation, Rekognition moderation, metadata extraction, and database update as parallel Lambda tasks where possible and sequential where dependent. Configure Step Functions with a maximum concurrency of 10,000 executions. Use a Map state for batch processing.

C) Keep the SQS queue but replace EC2 instances with Lambda consumers. Enable SQS event source mapping with `MaximumBatchingWindowInSeconds` of 0 and `BatchSize` of 1 for lowest latency. Configure Lambda reserved concurrency to 5,000. The Lambda function performs all four processing steps sequentially. Configure the SQS queue `maxReceiveCount` to 3 with a DLQ. Set the visibility timeout to 120 seconds.

D) Use S3 Event Notifications to EventBridge. Create an EventBridge rule that triggers a Step Functions Standard Workflow. The workflow executes thumbnail generation, Rekognition, metadata extraction, and database update in parallel where possible. Configure the workflow with an Express child workflow for the parallel tasks and a Standard parent for orchestration and error handling. Use a DLQ on the EventBridge rule for failed invocations.

---

### Question 16

A logistics company operates a fleet management system that tracks 100,000 vehicles in real-time. Each vehicle sends GPS coordinates, speed, fuel level, and engine diagnostics every 5 seconds. The system must: (1) detect geofence violations within 10 seconds, (2) store all telemetry data for 3 years, (3) support real-time dashboards showing fleet status with sub-5-second refresh, (4) run machine learning models for predictive maintenance that need the last 30 days of data with sub-second query latency, and (5) keep monthly infrastructure costs under $50,000. The current architecture writes directly to Amazon RDS, which is overwhelmed at 20,000 writes/second. What architecture meets ALL requirements?

A) Ingest telemetry via Amazon Kinesis Data Streams with 100 shards (handling 100,000 records/second). Use a Kinesis Data Analytics for Apache Flink application for real-time geofence detection within 10 seconds. Write raw telemetry to Amazon Timestream for the 30-day hot query window and simultaneously to S3 in Parquet format for long-term storage. Use Timestream for the real-time dashboard and ML model queries. Create a lifecycle policy in Timestream to retain data for 30 days in the memory store and move to magnetic store for 3 years. Use Amazon Managed Grafana for dashboards connected to Timestream.

B) Ingest via Amazon Kinesis Data Streams with 200 shards. Use Lambda consumers for geofence detection. Write to Amazon DynamoDB with TTL for 30-day hot data and stream changes to Kinesis Data Firehose for S3 archival. Use DynamoDB Streams and Lambda for real-time dashboard updates via WebSocket API Gateway. Use Amazon SageMaker with DynamoDB as the data source for ML.

C) Ingest via Amazon MSK (Kafka) with 50 partitions. Use Kafka Streams for geofence detection. Write to Amazon OpenSearch for real-time queries and dashboards. Archive to S3 via MSK Connect S3 Sink. Use OpenSearch as the ML data source. Configure OpenSearch Index State Management to delete data older than 30 days.

D) Ingest via API Gateway WebSocket API to Kinesis Data Firehose. Buffer telemetry for 60 seconds before writing to S3 in Parquet format. Use Athena for real-time queries. Deploy a geofence detection Lambda triggered by Firehose transformation. Use Amazon Redshift Spectrum for ML queries over S3 data.

---

### Question 17

A healthcare analytics company runs a HIPAA-compliant data lake on AWS. Their ETL pipeline processes 500 GB of raw medical claims data daily from 50 hospital partners. Each partner sends data in different CSV formats with varying column names for the same fields (e.g., "patient_id", "patientID", "Patient_Identifier"). Requirements: (1) data must be deduplicated and standardized before loading into the data lake, (2) PII fields must be tokenized before storage, (3) data lineage must be tracked for audit purposes, (4) the pipeline must complete within a 4-hour nightly window, (5) failed records must be quarantined without blocking the pipeline, and (6) the solution must handle schema evolution as partners add new fields. What architecture BEST meets ALL requirements?

A) Use AWS Glue ETL jobs with Glue Crawlers to detect schema changes. Create Glue custom classifiers for each partner's format. Use Glue's `ResolveChoice` and `Map` transforms for standardization. Implement PII tokenization using a Glue Python Shell job that calls the AWS Encryption SDK. Track lineage using Glue Data Catalog table properties. Write clean data to S3 in Parquet format and quarantine failed records to a separate S3 prefix.

B) Deploy AWS Glue ETL with Glue DynamicFrames for schema flexibility. Create a mapping table in DynamoDB that translates each partner's column names to the standard schema. Use Glue `ApplyMapping` transforms with the DynamoDB lookup for standardization. Implement PII tokenization using a Glue custom transform that calls a Lambda-backed tokenization service. Enable Glue Data Catalog with AWS Lake Formation for data lineage. Configure Glue error handling to write failed records to a dead-letter S3 prefix. Enable Glue bookmarks for incremental processing and schema evolution handling.

C) Use Amazon EMR with Apache Spark for ETL processing. Deploy a Spark application that reads mapping rules from a configuration file for schema standardization. Use a custom Spark UDF for PII tokenization. Track lineage using Apache Atlas deployed on the EMR cluster. Write results to S3 with quarantined records in a separate partition. Handle schema evolution by updating the configuration file.

D) Use Step Functions to orchestrate Lambda functions for the ETL pipeline. Each Lambda processes one partner's data, using a mapping configuration stored in Parameter Store for schema translation. Use the AWS Encryption SDK in Lambda for PII tokenization. Track lineage in a DynamoDB table recording input/output relationships. Write clean data to S3 and quarantine failures. Handle schema evolution by updating Parameter Store configurations.

---

### Question 18

A global gaming company runs multiplayer game servers on Amazon EC2 across us-east-1, eu-west-1, and ap-northeast-1. During a game launch, player count surged from 50,000 to 2 million in 4 hours. The infrastructure failed because: (1) the Auto Scaling group hit the Region's EC2 on-demand limit, (2) the Network Load Balancer failed health checks on new instances still loading 20 GB of game asset data, (3) Route 53 latency-based routing sent players to overwhelmed Regions before scaling completed, and (4) the game state database (DynamoDB) was throttled due to provisioned capacity. Design the architecture that prevents ALL four failures. (Select TWO.)

A) Request AWS service limit increases for EC2 in all three Regions to 10,000 instances. Configure the Auto Scaling group to use a mix of instance types across multiple instance families (c5, c6g, m5, m6g) with an Attribute-Based Instance Type Selection (ABIS) policy. Pre-bake AMIs with game assets and use instance store volumes or pre-warmed EBS snapshots with fast snapshot restore enabled for the 20 GB asset data. Configure NLB health checks with an extended initial health check grace period of 600 seconds matching the application's startup time.

B) Switch DynamoDB to on-demand capacity mode for automatic scaling without throttling. Deploy a global Amazon Aurora Serverless v2 database as a complementary datastore for game state that requires strong consistency. Implement Route 53 Application Recovery Controller with readiness checks that verify sufficient capacity in each Region before routing traffic. Use weighted routing policies that gradually shift traffic to a Region only after scaling is confirmed via CloudWatch alarm integration.

C) Pre-provision warm pools in Auto Scaling groups in all Regions with instances in the `Stopped` state. Use capacity reservations for baseline capacity and Spot Instances with diversified allocation for burst capacity. Store game assets on Amazon EFS with pre-mounted volumes in the launch template. Configure NLB target group deregistration delay to 300 seconds. Switch DynamoDB to on-demand capacity mode.

D) Use Amazon GameLift FleetIQ for multi-Region game server management. Configure FleetIQ to use Spot Instances with automatic rebalancing. Implement Route 53 geoproximity routing with traffic biasing. Store game assets in S3 and use a custom pre-loading script in the instance user data.

E) Use AWS Global Accelerator instead of Route 53 for routing. Configure automatic failover based on endpoint health. Deploy Auto Scaling groups with predictive scaling policies based on historical launch patterns. Store game assets on FSx for Lustre linked to an S3 bucket for fast parallel loading.

---

### Question 19

A video streaming platform uses Amazon CloudFront to deliver content globally. During a live streaming event, 5 million concurrent viewers generated 2 Tbps of traffic. The origin is an Application Load Balancer fronting an ECS cluster that serves the HLS manifest files, while video segments are served from S3. Post-event analysis revealed: (1) 15% of manifest requests resulted in 5xx errors from the origin, (2) S3 returned 503 SlowDown errors on the segment bucket, (3) CloudFront cache hit ratio for manifests was only 30% because they change every 2 seconds, and (4) total data transfer costs were $180,000 for the 6-hour event. Design improvements to address ALL four issues.

A) Enable CloudFront Origin Shield in the Region closest to the ALB to consolidate origin requests and increase cache hit ratio for manifests. Configure the manifest cache behavior with a TTL of 1 second (half the update interval) to improve hit ratio while maintaining freshness. Distribute S3 segments across multiple prefixes using a hash-based naming convention to avoid the 5,500 GET/s per-prefix limit. Negotiate a CloudFront private pricing commitment for reduced data transfer costs. Scale the ECS cluster with target tracking on request count per target.

B) Replace the ALB origin with an API Gateway HTTP API for manifest generation to handle burst traffic. Configure CloudFront with a 0-second TTL for manifests but enable `stale-while-revalidate` using Cache-Control headers. Use S3 Transfer Acceleration for segment uploads. Implement CloudFront Functions to redirect segment requests across multiple S3 buckets for load distribution. Use Reserved Capacity for CloudFront to reduce data transfer costs.

C) Deploy Lambda@Edge to generate manifest files at the edge, eliminating origin requests entirely. Cache manifests for 2 seconds at the edge. For S3, use multiple buckets behind a CloudFront origin group with failover. Enable S3 Intelligent-Tiering for segments. Use CloudFront Security Savings Bundle for cost reduction.

D) Increase the ECS cluster size by 3x and configure ALB with connection draining. Set CloudFront manifest TTL to 5 seconds and use versioned manifest URLs. Use a single S3 bucket with request rate optimization and enable S3 Transfer Acceleration. Negotiate an Enterprise Discount Program for data transfer costs.

---

### Question 20

A financial services company must implement an application that processes stock trade confirmations. Each confirmation must be processed EXACTLY ONCE — duplicate processing would result in double-charging customers. The system receives 5,000 trades per second with a burst of up to 50,000 per second during market open. Each trade confirmation requires: (1) validation against a rules engine, (2) enrichment with customer data from DynamoDB, (3) PDF generation, (4) storage in S3, and (5) notification to the customer via email and SMS. End-to-end processing must complete within 60 seconds. What architecture guarantees exactly-once processing while meeting the throughput and latency requirements?

A) Use Amazon SQS FIFO queue with message deduplication enabled (ContentBasedDeduplication). Lambda consumers process messages with a batch size of 10. The Lambda function performs all five steps within a single invocation. Configure the FIFO queue with a throughput limit of 70,000 messages per second using high-throughput mode. Use the message group ID as the customer account number for ordered processing per customer.

B) Use Amazon Kinesis Data Streams with enhanced fan-out consumers. Assign each trade a unique `PartitionKey` (trade ID). Use a Lambda consumer with event source mapping configured with `BisectBatchOnFunctionError` and `MaximumRetryAttempts` of 3. Before processing, check a DynamoDB table for the trade ID; if it exists, skip (idempotency). If not, process the trade: validate, enrich, generate PDF, store in S3, and send notifications. Write the trade ID to DynamoDB in the same transaction as the trade processing using DynamoDB transactions. Configure Kinesis with 50 shards for the 50,000/s burst.

C) Use Amazon MSK with exactly-once semantics enabled (EOS). Configure producers with `enable.idempotence=true` and `transactional.id` set per producer. Use MSK consumers with `isolation.level=read_committed`. Process each trade in a Kafka transaction: validate, enrich, generate PDF (calling a separate service), store in S3, and update an "offsets" topic. Use Amazon SES for email and SNS for SMS. Deploy consumers on ECS Fargate with auto-scaling based on consumer lag.

D) Use an SQS Standard queue for ingestion with a DynamoDB-based idempotency table. A Lambda function reads from SQS, checks DynamoDB for duplicate trade IDs, and processes if not a duplicate. Use Step Functions Express Workflow for the five processing steps, with each step having built-in retry logic. Configure the DynamoDB table with a TTL to expire deduplication records after 24 hours. Use SQS with a batch size of 10 and visibility timeout of 120 seconds.

---

### Question 21

A multinational retail company operates 5,000 stores globally. Each store runs a local application on AWS Outposts that processes point-of-sale (POS) transactions and syncs to the central AWS Region (us-east-1) every 5 minutes. Requirements include: (1) store operations must continue for up to 72 hours if connectivity to the AWS Region is lost, (2) when connectivity is restored, data must sync without loss or duplication, (3) local data must be encrypted at rest with keys that are usable during disconnection, (4) the central system must aggregate all store data for analytics with less than 10-minute staleness, and (5) deploying updates to all 5,000 stores must complete within 4 hours. What architecture meets ALL requirements?

A) Deploy AWS Outposts racks at each store with a local EKS cluster running the POS application. Use Amazon RDS on Outposts for local data storage with encryption using a locally cached KMS key. Sync data to the central Region using AWS DataSync over Direct Connect with Store and Forward mode. For updates, use AWS Systems Manager to deploy to all stores in parallel with a rate control of 500 concurrent deployments. Use Amazon Kinesis Data Firehose in the central Region to aggregate store data.

B) Deploy AWS Outposts servers (1U/2U) at each store with EC2 instances running the POS application. Use local instance store for POS data with application-level encryption using keys cached locally from KMS (pre-cached with a grant for offline use). Sync data using an SQS-based queue: the local application writes to a local queue that forwards messages to a central SQS queue when connectivity is available, with deduplication using `MessageDeduplicationId`. For analytics, consume the central SQS queue with Lambda and load into Amazon Redshift. Deploy updates using ECS Anywhere with rolling deployments across 500 stores per batch.

C) Use AWS Snow Family (Snowcone) at each store for local processing and storage. Sync data to S3 using AWS DataSync when connected. Use AWS IoT Greengrass for local application management and OTA updates. Encrypt local data using Snowcone's built-in encryption. For analytics, use Athena to query the centralized S3 data lake.

D) Use AWS Local Zones in each store's metropolitan area. Deploy EC2 instances and RDS in the Local Zone. Use DynamoDB Global Tables for data synchronization. For updates, use CodeDeploy with a deployment group spanning all Local Zones.

---

### Question 22

A SaaS company provides a document management platform that stores 500 TB of data in Amazon S3 across three buckets: `hot-docs` (50 TB, accessed daily), `warm-docs` (150 TB, accessed weekly), and `cold-docs` (300 TB, accessed yearly for compliance). The platform ingests 2 TB of new documents daily. Current monthly S3 costs are $12,500. The CTO wants to reduce storage costs by at least 40% while maintaining: (1) sub-100ms retrieval for hot documents, (2) sub-5-minute retrieval for warm documents, (3) maximum 12-hour retrieval for cold documents, (4) cross-Region replication for all buckets to eu-west-1 for DR, and (5) the solution must handle unexpected access pattern changes (e.g., a warm document suddenly getting 1,000 reads/day). What storage strategy achieves the target cost reduction?

A) Move `hot-docs` to S3 Intelligent-Tiering (with no Archive tiers enabled). Move `warm-docs` to S3 Standard-IA. Move `cold-docs` to S3 Glacier Flexible Retrieval. Enable CRR on all buckets. Use S3 Lifecycle rules to move objects from Intelligent-Tiering to Standard-IA after 90 days and from Standard-IA to Glacier after 1 year.

B) Keep `hot-docs` on S3 Standard. Move `warm-docs` to S3 Intelligent-Tiering with the Archive Access tier enabled (90-day threshold) and Deep Archive Access tier enabled (180-day threshold). Move `cold-docs` to S3 Glacier Deep Archive. Enable CRR on all buckets. For unexpected access pattern changes, S3 Intelligent-Tiering automatically moves objects back to Frequent Access.

C) Move `hot-docs` to S3 Intelligent-Tiering (Frequent and Infrequent tiers only). Move `warm-docs` to S3 Intelligent-Tiering with all tiers enabled (Frequent, Infrequent, Archive Instant, Archive, Deep Archive). Move `cold-docs` to S3 Glacier Flexible Retrieval. Enable CRR on all buckets with replication to matching storage classes. For unexpected access changes on warm documents, Intelligent-Tiering automatically promotes to Frequent Access. For cold documents needing faster access, use S3 Batch Operations to restore and reclassify.

D) Move `hot-docs` to S3 Express One Zone for sub-10ms access. Move `warm-docs` to S3 Standard-IA with S3 Object Lambda to redirect infrequent requests. Move `cold-docs` to S3 Glacier Deep Archive. Use EventBridge to detect access pattern changes and trigger lifecycle transitions.

---

### Question 23

A biotechnology company runs computationally intensive protein folding simulations on AWS. Each simulation processes a 500 MB input file, requires 256 GB of RAM and 64 vCPUs, runs for 6-18 hours, and produces 50 GB of output. They need to run 1,000 simulations per week with a deadline of 72 hours for each batch. Simulations are idempotent and can be restarted from the beginning if interrupted. The current setup uses On-Demand c5.18xlarge instances managed by a custom scheduler, costing $85,000/month. What architecture reduces costs by at least 60% while meeting the 72-hour deadline?

A) Use AWS Batch with a managed compute environment configured for Spot Instances. Specify a diverse set of memory-optimized instance types (r5.16xlarge, r6g.16xlarge, r6i.16xlarge, r5a.16xlarge, x2gd.8xlarge) with an allocation strategy of `SPOT_PRICE_CAPACITY_OPTIMIZED`. Configure AWS Batch retry strategy with 3 attempts and a 1-hour timeout per attempt to handle Spot interruptions. Store input files in S3 and use S3 for output. Use EBS gp3 volumes for local scratch space during processing.

B) Use Amazon EKS with Karpenter configured to use Spot Instances from memory-optimized instance families. Deploy simulations as Kubernetes Jobs with pod disruption budgets. Use Amazon FSx for Lustre linked to S3 for input/output to optimize I/O. Configure cluster autoscaler to scale nodes based on pending pod count. Use Graviton-based instances (r6g, r7g) for additional cost savings.

C) Migrate to AWS ParallelCluster with Spot Instances and a Slurm scheduler. Configure the cluster with a mix of r5 and r6g instance types. Use Amazon EFS for shared storage of input and output files. Enable checkpointing every hour to EFS so interrupted simulations can resume rather than restart. Configure a maximum price of 50% of On-Demand for Spot.

D) Use AWS Lambda with 10 GB memory and container image support. Break each simulation into 64 parallel chunks processed by separate Lambda functions, then merge results. Use S3 for all I/O. Use Step Functions to orchestrate the chunked workflow with parallel Map states.

---

### Question 24

A company hosts a critical customer-facing application behind an Application Load Balancer. The application runs on EC2 instances in an Auto Scaling group across three Availability Zones. The application connects to an Amazon Aurora MySQL Multi-AZ cluster. During a recent AZ failure: (1) the ALB continued routing traffic to the failed AZ for 90 seconds before deregistering targets, (2) the Auto Scaling group took 8 minutes to launch replacement instances in healthy AZs, (3) the Aurora writer instance was in the failed AZ and failover took 45 seconds during which the application returned errors, and (4) some sessions were lost because session state was stored in-memory on the failed instances. Design the improvements to achieve less than 30-second recovery from any single-AZ failure.

A) Configure ALB health checks with a 5-second interval, 2-second timeout, and 2 consecutive failures threshold (10-second detection). Enable Cross-Zone Load Balancing. Configure the Auto Scaling group with a warm pool of pre-initialized instances in a Stopped state with 1-minute warm-up time. Switch to Aurora Multi-AZ with 2 readable standbys and set the failover priority to tier-0 for instances in healthy AZs. Move session state to ElastiCache for Redis with Multi-AZ replication.

B) Configure ALB target group health checks with a 10-second interval and 3 healthy/unhealthy thresholds. Use an Auto Scaling group with Predictive Scaling and a minimum capacity that exceeds demand by 50%. Configure Aurora with a read replica in each AZ and use RDS Proxy for connection management during failover. Store session state in DynamoDB with DAX.

C) Replace the ALB with a Network Load Balancer for faster failover. Configure NLB health checks at 10-second intervals with 3 failures threshold. Over-provision the Auto Scaling group with a minimum of N+1 capacity across AZs. Use Aurora with read replicas and promote a replica manually during failover. Use sticky sessions on the NLB.

D) Deploy the application on ECS Fargate behind the ALB for faster task replacement. Configure ALB health checks with 5-second intervals. Use Aurora Serverless v2 for automatic failover. Store sessions in DynamoDB Global Tables for multi-Region resilience. Configure ECS service to maintain minimum healthy percent of 100%.

---

### Question 25

A media company ingests live video feeds from 500 cameras, each streaming at 8 Mbps (total 4 Gbps ingress). The video is processed for object detection using Amazon Rekognition Video, stored for 90 days, and must be searchable by detected objects within 5 seconds of detection. The current architecture uses Amazon Kinesis Video Streams for ingestion, but the processing pipeline cannot keep up with the volume — Rekognition Video custom labels analysis is taking 10x real-time on each stream. What architecture enables real-time processing of all 500 streams?

A) Continue using Kinesis Video Streams for ingestion. Instead of Rekognition Video stream processing, extract frames at 1 FPS from each stream using a Kinesis Video Streams parser library on ECS Fargate tasks. Send extracted frames to Rekognition `DetectLabels` (image API) using a fleet of Lambda functions for parallel processing. Index detection results in Amazon OpenSearch with the camera ID, timestamp, and detected labels. Use OpenSearch's near-real-time indexing for sub-5-second searchability.

B) Use Amazon Kinesis Video Streams with a GetMediaForFragmentList API to extract HLS segments. Process segments with Amazon SageMaker real-time endpoints running a custom YOLOv5 model on ml.g5.xlarge instances with auto-scaling. Store detection results in DynamoDB with a GSI on detected object type and timestamp. Use DynamoDB Streams to trigger a Lambda that indexes results in CloudSearch.

C) Replace Kinesis Video Streams with direct S3 uploads using multipart upload. Use S3 event notifications to trigger Lambda functions that call Rekognition `StartLabelDetection` (async video API) for each segment. Store results in Amazon Timestream for time-series queries. Use Timestream's SQL interface for searching by detected objects.

D) Use Amazon Managed Streaming for Apache Kafka (MSK) for video ingestion instead of Kinesis Video Streams. Process frames using Apache Flink on Amazon Managed Service for Apache Flink with a custom Rekognition connector. Store results in Amazon Neptune for graph-based object relationship queries.

---

### Question 26

A company runs a legacy monolithic Java application on a single m5.4xlarge EC2 instance. The application handles 2,000 requests per second, uses a local PostgreSQL database, and stores 500 GB of file uploads on the local EBS volume. The CTO has mandated a migration to a resilient, highly available architecture with: (1) zero data loss during failover, (2) maximum 5-second failover time for the database, (3) the ability to deploy updates with zero downtime, (4) the application must run on at least 3 instances across 3 AZs, and (5) the migration must be completed in phases without any downtime to end users. What is the correct migration sequence?

A) Phase 1: Launch an Amazon Aurora PostgreSQL cluster with Multi-AZ and migrate the database using AWS DMS with CDC (Change Data Capture) while the monolith continues running. Phase 2: Move file storage from local EBS to Amazon EFS mounted across three AZs. Phase 3: Create an AMI of the application server and launch 3 instances behind an ALB in a target group with health checks. Configure blue/green deployment using ALB weighted target groups. Phase 4: Cut over from the single instance to the ALB by updating DNS with a Route 53 weighted record set, gradually shifting traffic from 10% to 100% over 2 hours.

B) Phase 1: Create an Aurora PostgreSQL cluster and use pg_dump/pg_restore for initial migration, then switch the application connection string during a 5-minute maintenance window. Phase 2: Copy EBS data to S3 and modify the application to use the S3 API. Phase 3: Deploy 3 instances behind an ALB. Phase 4: Terminate the original instance.

C) Phase 1: Set up an Aurora PostgreSQL cluster with a read replica. Use AWS DMS with full load and CDC to replicate from PostgreSQL to Aurora. Phase 2: Migrate file storage to Amazon S3 using AWS DataSync, then update the application to use the AWS SDK for S3 access. Phase 3: Containerize the application and deploy on ECS Fargate across 3 AZs behind an ALB with rolling deployment configuration. Phase 4: Switch the DMS task to stop replication and cut over the application to Aurora. Use Route 53 alias records for the ALB.

D) Phase 1: Set up Aurora PostgreSQL Multi-AZ and use DMS with CDC for continuous replication. Phase 2: Migrate files to EFS mounted in the application. Phase 3: Deploy the application to 3 EC2 instances behind an ALB in an Auto Scaling group with health checks. Start sending read traffic to the new fleet using Route 53 weighted routing while writes still go to the original. Phase 4: Stop DMS, point the new fleet to Aurora, and shift 100% of traffic to the ALB using Route 53.

---

### Question 27

An autonomous vehicle company collects 2 TB of sensor data per vehicle per day from a fleet of 500 vehicles. Data includes LiDAR point clouds (1.5 TB), camera images (400 GB), and telemetry logs (100 GB). Data is uploaded nightly via cellular connections from fleet depots with 1 Gbps internet links. Requirements: (1) all data must be available in S3 within 6 hours of vehicle return, (2) the upload must be resilient to network interruptions, (3) data must be encrypted in transit and at rest, (4) the solution must handle depot locations with as low as 100 Mbps connectivity, and (5) monthly data transfer costs must not exceed $50,000. Current approach uses aws s3 sync which fails frequently on large files and doesn't prioritize telemetry logs. What is the MOST reliable and cost-effective architecture?

A) Use AWS DataSync agents installed at each depot. Configure DataSync tasks to transfer data to S3 with bandwidth throttling based on depot connectivity (100 Mbps to 1 Gbps). Enable DataSync's built-in data verification and automatic retry on network failures. Prioritize telemetry logs by creating separate DataSync tasks with higher priority scheduling. Use S3 Transfer Acceleration for depots with poor connectivity to the nearest AWS Region. Encrypt with TLS in transit and SSE-S3 at rest.

B) Deploy a custom upload application on a small EC2 instance at each depot. The application uses S3 multipart upload with configurable part sizes based on bandwidth (8 MB parts for 100 Mbps, 64 MB parts for 1 Gbps). Implement automatic retry with exponential backoff for failed parts. Prioritize telemetry uploads by processing the telemetry directory first. Use S3 Intelligent-Tiering for storage. Encrypt with TLS in transit and SSE-KMS at rest. For cost optimization, use S3 VPC endpoints from depots connected via AWS Direct Connect.

C) Use AWS Snow Family — deploy a Snowball Edge Storage Optimized device at each depot that receives returned vehicles. Vehicles offload data to the Snowball Edge via local network. When full (or on a weekly schedule), ship the Snowball Edge to AWS for S3 import. Use multiple devices per high-volume depot. For telemetry logs that need faster access, upload them directly via S3 multipart upload over the internet in parallel with Snowball operations.

D) Install AWS Storage Gateway File Gateway at each depot. Map a local NFS share that vehicles write to upon return. Storage Gateway automatically uploads data to S3 asynchronously. Configure cache size to handle the depot's daily data volume. For depots with low bandwidth, configure bandwidth throttling. Storage Gateway handles retries, encryption, and bandwidth management automatically.

---

### Question 28

A company is deploying a serverless application using AWS Lambda, API Gateway, DynamoDB, and SQS. The application processes customer orders and must be resilient to any component failure. During load testing at 10,000 orders per minute, the team observed: (1) Lambda throttling due to concurrent execution limits, (2) DynamoDB write throttling on the orders table, (3) lost messages when Lambda functions processing SQS messages timed out, and (4) API Gateway returning 429 errors to customers. Design a resilient architecture that handles 10,000 orders/minute with zero message loss and graceful degradation under 5x load spikes.

A) Increase Lambda reserved concurrency to 3,000 for the order processing function. Switch DynamoDB to on-demand capacity mode. Configure SQS visibility timeout to 6x the Lambda timeout. Add a DLQ to the SQS queue with `maxReceiveCount` of 5. Configure API Gateway with a usage plan that returns a Retry-After header with 429 responses. Implement an SQS-based buffering pattern: API Gateway writes directly to SQS via a service integration, and Lambda processes asynchronously from the queue.

B) Increase Lambda account concurrency limit via a service quota request. Switch DynamoDB to provisioned capacity with auto-scaling (target utilization 70%). Increase Lambda timeout and configure SQS visibility timeout accordingly. Implement circuit breaker pattern in the Lambda function. Configure API Gateway throttling with burst limits.

C) Deploy the Lambda function in a VPC with a NAT Gateway for DynamoDB access. Use provisioned concurrency on Lambda for consistent performance. Configure DynamoDB with reserved capacity for the orders table. Use SQS FIFO queues for ordered processing. Implement API Gateway caching.

D) Replace Lambda with ECS Fargate for predictable concurrency. Use DynamoDB with DAX for write buffering. Replace SQS with Kinesis Data Streams for ordered processing. Deploy API Gateway behind CloudFront for caching 429 responses.

---

### Question 29

A global e-commerce platform serves customers in North America, Europe, and Asia-Pacific. The platform runs on Amazon EKS in us-east-1 with an Aurora MySQL Global Database. During the European shopping holiday season, European customers experienced 800ms average latency (vs. 200ms target). Analysis showed: (1) 400ms from transatlantic network round trip, (2) 200ms from database read queries crossing the Atlantic, (3) 100ms from CloudFront cache misses on personalized content, and (4) 100ms from third-party payment API calls to a European processor. The company wants to reduce European customer latency to under 250ms without deploying a full active-active architecture. What changes achieve this target? (Select THREE.)

A) Deploy an Aurora read replica cluster in eu-west-1 as part of the Global Database. Modify the application to route all read queries from European users to the eu-west-1 read replica. This eliminates the 200ms database read latency.

B) Deploy a regional EKS cluster in eu-west-1 that handles read-only operations and serves European customers. Route European traffic to this cluster using CloudFront with geographic routing. Write operations are still proxied to us-east-1 via a low-latency private connection. This eliminates the 400ms network round trip for reads.

C) Implement CloudFront Functions to generate personalized content at the edge by looking up user preferences from a CloudFront KeyValueStore populated from the application database. This eliminates the 100ms cache miss latency for personalized content.

D) Set up an API Gateway Regional endpoint in eu-west-1 that proxies payment API calls to the European payment processor. Modify the application to call the eu-west-1 API Gateway from the European EKS cluster instead of calling the payment API from us-east-1. This eliminates the 100ms payment API latency.

E) Deploy a full ElastiCache for Redis cluster in eu-west-1 with cache replication from us-east-1. Cache all database query results with a 30-second TTL. This reduces both database and network latency for repeated queries.

---

### Question 30

A company runs a mission-critical SAP HANA workload on an x2idn.32xlarge EC2 instance with 2 TB of memory. The application requires: (1) automatic recovery from hardware failure within 5 minutes, (2) protection against AZ failure with RPO of 15 minutes, (3) protection against Region failure with RPO of 1 hour, (4) the ability to restore to any point within the last 7 days, and (5) the SAP HANA instance must maintain dedicated tenancy on a specific host for licensing compliance. What combination of services provides ALL five protections? (Select TWO.)

A) Use a Dedicated Host with host recovery enabled. Configure EC2 auto-recovery via a CloudWatch alarm on `StatusCheckFailed_System` that triggers the `recover` action. This ensures the instance is automatically restarted on a new Dedicated Host within the same AZ if the underlying hardware fails.

B) Configure AWS Backint Agent for SAP HANA to take continuous backups to S3 with a 15-minute log backup schedule. Enable S3 Cross-Region Replication to the DR Region for the backup bucket. Use AWS Backup to orchestrate the backup schedule with a 7-day retention period and cross-Region copy rules. Create a CloudFormation template that deploys a new x2idn.32xlarge on a Dedicated Host in the DR Region, ready to restore from backups.

C) Use a Dedicated Host with host maintenance enabled. Deploy a second x2idn.32xlarge in another AZ using SAP HANA System Replication (HSR) in synchronous mode for zero RPO within the Region. Deploy a third instance in the DR Region with HSR in asynchronous mode for 1-hour RPO. Use AWS Launch Wizard for SAP to manage the deployment.

D) Use an EC2 Auto Scaling group with min/max of 1 across two AZs. Configure the ASG to use a launch template specifying the x2idn.32xlarge with a Dedicated Host affinity. Use EBS snapshots replicated to the DR Region for point-in-time recovery. Configure AWS Backup for 7-day retention.

E) Use AWS Elastic Disaster Recovery (DRS) to continuously replicate the SAP HANA instance to the DR Region. Configure the replication to a staging area with a smaller instance type and scale up during failover. Enable point-in-time recovery with DRS's built-in 7-day retention. Use a Dedicated Host in the source Region with host recovery for hardware failure protection.

---

### Question 31

A real-time bidding platform for online advertising must process 1 million bid requests per second. Each request must be evaluated against 10,000 advertiser campaigns and return the winning bid within 50ms (p99). The campaign data (2 GB total) changes every 5 minutes. The current architecture uses a fleet of c5.4xlarge instances with campaign data stored in ElastiCache Redis, but p99 latency is 80ms, primarily due to ElastiCache network round trips averaging 0.5ms per call with 30-40 calls per bid evaluation. What architectural change achieves the 50ms p99 target?

A) Replace ElastiCache with local in-memory caching using a cache library within the application. Load the entire 2 GB campaign dataset into each instance's memory on startup and refresh every 5 minutes by subscribing to an SNS topic that triggers a reload from S3. Use c5.4xlarge instances (32 GB memory) which have sufficient RAM for the 2 GB dataset plus application overhead. Evaluate all campaigns using local memory access (nanosecond latency instead of 0.5ms network calls).

B) Upgrade to c5.9xlarge instances and increase ElastiCache to r6g.4xlarge nodes with 6 replicas for read scaling. Enable ElastiCache reader endpoint load balancing. Reduce network latency by deploying ElastiCache and EC2 in the same placement group.

C) Replace ElastiCache with Amazon DAX (DynamoDB Accelerator) for microsecond-level reads. Store campaign data in DynamoDB and access it through DAX. Use DynamoDB Streams to refresh DAX cache when campaigns update every 5 minutes.

D) Migrate to Lambda with provisioned concurrency. Store campaign data in an EFS file system mounted to Lambda. Use Lambda's 10 GB memory configuration to load campaign data into memory during function initialization.

---

### Question 32

A machine learning company trains large language models on AWS. Each training job processes 50 TB of tokenized text data and runs on a cluster of 64 p5.48xlarge instances for 14 days. The training framework uses distributed data parallelism with gradient synchronization every 100ms. Requirements: (1) training job must complete within 14 days, (2) a single node failure must not restart the entire job (checkpoint recovery within 10 minutes), (3) network bandwidth between nodes must support 3,200 Gbps collective bandwidth, (4) storage must sustain 100 GB/s aggregate read throughput for data loading, and (5) total cost must be minimized. What architecture meets ALL requirements?

A) Deploy 64 p5.48xlarge instances in a single cluster placement group within one AZ using EFA (Elastic Fabric Adapter) for inter-node communication. Use Amazon FSx for Lustre (PERSISTENT_2 with 1000 MB/s/TiB throughput) linked to an S3 bucket for the training data, providing the required 100 GB/s read throughput. Configure the training framework to save checkpoints to FSx for Lustre every 30 minutes. On node failure, replace the instance and resume from the latest checkpoint. Use EC2 Capacity Reservations for the 14-day window to guarantee capacity at On-Demand pricing. Use SageMaker Managed Warm Pools to pre-initialize replacement nodes.

B) Deploy on Amazon SageMaker Training with 64 ml.p5.48xlarge instances. SageMaker automatically handles placement group, EFA, and checkpoint management. Store training data on S3 and use SageMaker's built-in S3 data channel with `ShardedByS3Key` mode for parallel loading. Configure SageMaker Managed Spot Training with checkpoints saved to S3 every 15 minutes. Enable SageMaker automatic model tuning.

C) Deploy 64 p5.48xlarge Spot Instances in a cluster placement group with EFA. Use Amazon FSx for Lustre (SCRATCH_2) for training data at lower cost. Save checkpoints to S3 every 10 minutes. When a Spot interruption occurs, launch a replacement instance and resume from checkpoint. Use a diversified Spot allocation strategy across p5 and p4d instance types.

D) Deploy using Amazon EKS with 64 p5.48xlarge instances. Use the EFA device plugin for Kubernetes. Deploy a distributed training operator (e.g., PyTorch Operator) that handles node failure and checkpoint recovery. Use Amazon EFS for shared checkpoint storage. Store training data on S3 and load via S3 FUSE mount.

---

### Question 33

A company runs a high-traffic web application that requires a caching strategy to handle 500,000 requests per second. The application serves three types of content: (1) user profiles — 10 million records, 2 KB each, updated every 30 minutes on average, tolerance for 5-minute staleness, (2) product catalog — 1 million records, 50 KB each, updated daily, zero staleness tolerance for price changes, and (3) session data — 5 million active sessions, 10 KB each, read/written on every request, must be consistent. Current architecture has a single ElastiCache Redis cluster handling all three workloads, running at 90% memory utilization. What caching architecture BEST optimizes for each workload's characteristics?

A) Create three separate ElastiCache Redis clusters: (1) User profiles: Redis cluster mode enabled with 3 shards and 2 replicas each, TTL of 300 seconds, lazy-loading pattern. (2) Product catalog: Redis cluster mode enabled with 6 shards (to hold the 50 GB dataset), TTL of 86400 seconds with an SNS-triggered Lambda that invalidates specific keys on price changes using `PUBLISH` to a Redis pub/sub channel that application nodes subscribe to. (3) Sessions: Redis cluster mode enabled with 3 shards and Multi-AZ, no TTL (application-managed expiry), write-through pattern.

B) Use a tiered caching approach: CloudFront cache for product catalog (1-day TTL) with Lambda@Edge invalidation on price changes. ElastiCache Redis for user profiles (5-minute TTL, lazy loading). DynamoDB with DAX for session data (strong consistency, sub-millisecond reads). This distributes the workload across services optimized for each pattern.

C) Use Amazon ElastiCache Serverless for Redis for all three workloads in a single instance but with key prefixes. Configure application-level TTLs: 300 seconds for profiles, no TTL for products (invalidation via `DEL`), and 3600 seconds for sessions. ElastiCache Serverless automatically scales memory and throughput. Implement write-behind caching for the product catalog to ensure real-time invalidation.

D) Use ElastiCache for Memcached for user profiles and product catalog (simple key-value, larger memory per node). Use ElastiCache for Redis for session data (requires persistence). Configure application-level cache-aside pattern for all workloads. Use CloudFront in front of the API for an additional caching layer.

---

### Question 34

A financial analytics platform runs complex SQL queries against 20 TB of transaction data. Query patterns include: (1) real-time dashboard queries that scan the last 24 hours of data (2 TB) and must return in under 3 seconds, (2) ad-hoc analyst queries that scan weeks to months of data and must return in under 30 seconds, (3) quarterly compliance reports that scan the entire dataset and must complete within 2 hours, and (4) a requirement to join transaction data with a 500 GB reference dataset updated daily via a third-party SFTP feed. Current setup uses a single Amazon Redshift dc2.8xlarge cluster (4 nodes). Dashboard queries take 8 seconds and analyst queries time out at 60 seconds. What architecture changes meet ALL performance requirements?

A) Migrate to Amazon Redshift RA3 nodes (ra3.4xlarge, 8 nodes) with managed storage. Create materialized views for dashboard queries, refreshed every 5 minutes using Redshift auto-refresh. Enable Redshift Concurrency Scaling for ad-hoc analyst queries with a concurrency scaling mode of `auto`. For quarterly reports, use Redshift Spectrum to scan historical data in S3 (Parquet format) partitioned by date. Load the reference dataset into Redshift nightly using a COPY command from S3 (uploaded via AWS Transfer Family SFTP endpoint).

B) Deploy Amazon Redshift Serverless for all workloads. Configure a base RPU of 128 for dashboard queries and burst to 512 for analyst queries. Use Redshift data sharing to create a separate Serverless endpoint for compliance reports. Load reference data using Redshift Federated Query against the SFTP server.

C) Use Amazon Athena for ad-hoc and compliance queries against data in S3 (Parquet, partitioned). Use Amazon Redshift (4 ra3.xlplus nodes) exclusively for real-time dashboard queries with materialized views. Use AWS Glue to process the SFTP reference data and make it available in both Athena (via Glue Data Catalog) and Redshift (via Spectrum). Use Athena Workgroups with query limits for cost control.

D) Migrate to Amazon Aurora PostgreSQL with parallel query enabled. Create partitioned tables for time-based queries. Use Aurora read replicas for analyst queries. Load reference data via Aurora's `aws_s3` extension. Use Amazon QuickSight with SPICE datasets for dashboard acceleration.

---

### Question 35

A company needs to migrate a 50 TB Oracle database to Amazon Aurora PostgreSQL. The database serves a real-time application that cannot tolerate more than 15 minutes of downtime. The Oracle database uses: (1) PL/SQL stored procedures totaling 200,000 lines of code, (2) Oracle-specific data types (XMLTYPE, SDO_GEOMETRY), (3) materialized views refreshed every 10 minutes, (4) database links to two other Oracle databases, and (5) Oracle Advanced Queuing for asynchronous processing. What is the MOST efficient migration strategy?

A) Use AWS Schema Conversion Tool (SCT) to convert the Oracle schema and PL/SQL to Aurora PostgreSQL. Use SCT's assessment report to identify conversion issues. For unconvertible PL/SQL, manually refactor the code. Replace XMLTYPE with PostgreSQL's native XML type and SDO_GEOMETRY with PostGIS. Convert materialized views to PostgreSQL materialized views with pg_cron for scheduled refresh. Replace database links with postgres_fdw foreign data wrappers. Replace Oracle AQ with Amazon SQS integrated via aws_lambda extension. Use AWS DMS with full load and CDC for data migration with minimal downtime cutover.

B) Use a lift-and-shift approach: migrate to Amazon RDS for Oracle first, then use DMS to migrate to Aurora PostgreSQL. This two-phase approach reduces risk by separating infrastructure migration from database engine migration. Convert PL/SQL and Oracle-specific features in the second phase.

C) Use AWS SCT to convert the schema and identify issues. Use DMS with full load to migrate the bulk data while the Oracle database is still active. Manually convert all PL/SQL to PostgreSQL functions. Replace Oracle-specific features with AWS-native services: XMLTYPE to DynamoDB for XML storage, SDO_GEOMETRY to Amazon Location Service, materialized views to Redshift materialized views, database links to Glue ETL, and Oracle AQ to Amazon MQ for ActiveMQ. Cut over with DMS CDC after all conversions are validated.

D) Use Amazon RDS for Oracle with License Included to run the database unchanged. Deploy Aurora PostgreSQL as a read replica using DMS CDC. Gradually migrate stored procedures and application code to use Aurora. Once all features are migrated, promote Aurora to primary and decommission Oracle.

---

### Question 36

A company operates an IoT platform that receives telemetry from 10 million devices. Each device sends a 1 KB message every 10 seconds. The platform must: (1) ingest all messages with no data loss, (2) process messages for anomaly detection within 30 seconds, (3) store raw messages for 1 year, (4) support SQL queries over the last 7 days of data with sub-10-second response, and (5) scale automatically during a flash event that could 10x the device count. What architecture meets ALL requirements with the LEAST operational overhead?

A) Use AWS IoT Core for ingestion (1 million messages/second capacity, scalable). Route messages via IoT Rules to Amazon Kinesis Data Streams (100 shards, with auto-scaling via Application Auto Scaling). Use a Kinesis Data Analytics for Apache Flink application for real-time anomaly detection. Route processed messages via Kinesis Data Firehose to S3 in Parquet format, partitioned by date and device type. Use Amazon Athena for SQL queries over the 7-day window with partition pruning. For the 1-year retention, lifecycle raw data from S3 Standard to Glacier after 30 days.

B) Use AWS IoT Core for ingestion. Route messages via IoT Rules to Amazon SQS for buffering. Use Lambda consumers for anomaly detection. Write to Amazon Timestream for the 7-day SQL query window. Simultaneously write to S3 via Kinesis Data Firehose for 1-year archival. During flash events, SQS automatically scales, and Lambda scales with reserved concurrency.

C) Use AWS IoT Core for ingestion with IoT Rules routing to Amazon Kinesis Data Streams. Use AWS Lambda with event source mapping for anomaly detection. Write to Amazon Timestream for the 7-day hot query window (memory store retention: 7 days, magnetic store retention: 365 days). Use Kinesis Data Firehose to write raw data to S3 for long-term archival. For flash events, increase Kinesis shard count using UpdateShardCount API triggered by a CloudWatch alarm on IncomingRecords metric.

D) Use Amazon MSK for ingestion (it handles higher throughput than IoT Core). Deploy anomaly detection using Kafka Streams on ECS Fargate. Write to Amazon Redshift Streaming Ingestion for the 7-day SQL query window. Archive to S3 via MSK Connect S3 sink connector. For flash events, add MSK brokers and increase partitions.

---

### Question 37

A company is designing a search feature for their e-commerce platform with 50 million products. Requirements include: (1) full-text search with typo tolerance and relevance ranking, (2) faceted filtering (category, price range, brand, rating), (3) search-as-you-type autocomplete with sub-100ms latency, (4) personalized search results based on user purchase history, (5) search index must be updated within 30 seconds of a product change, and (6) the solution must handle 10,000 search queries per second at peak. What architecture delivers ALL requirements?

A) Use Amazon OpenSearch Service with a dedicated cluster (3 master nodes, 6 data nodes of r6g.2xlarge). Configure the product index with custom analyzers for typo tolerance (using fuzzy queries and n-gram tokenizers). Use OpenSearch aggregations for faceted filtering. Implement search-as-you-type using a completion suggester with a dedicated `suggest` field. For personalization, deploy a Lambda function that calls Amazon Personalize to re-rank OpenSearch results based on user history. Stream product changes from DynamoDB Streams (source of truth) through Lambda to the OpenSearch bulk API for near-real-time indexing. Use OpenSearch UltraWarm nodes for older product data.

B) Use Amazon CloudSearch for managed search infrastructure. Configure CloudSearch with text fields for full-text search and facet fields for filtering. Use CloudSearch's built-in suggesters for autocomplete. For personalization, store user preferences in DynamoDB and use a Lambda function to boost relevant products in CloudSearch queries. Update the index via CloudSearch's document batch API triggered by product changes.

C) Use Amazon Kendra with a custom data source connector to index products from DynamoDB. Configure Kendra for natural language search with semantic understanding. Use Kendra's built-in relevance tuning for personalization. Update the index using the BatchPutDocument API triggered by DynamoDB Streams.

D) Use Amazon Neptune with full-text search enabled for product search. Model products, categories, and user purchase history as a graph. Use Gremlin queries for search with faceted filtering via graph traversals. Store user history as graph edges for personalized search. Update the graph in real-time from DynamoDB Streams via Lambda.

---

### Question 38

A gaming company needs to serve 500,000 concurrent WebSocket connections for their real-time multiplayer game. Each connection receives game state updates every 100ms (10 updates/second). Each update is 500 bytes. The architecture must: (1) support server-initiated push to specific subsets of connections (e.g., all players in the same game room), (2) maintain connection state across server restarts, (3) handle a connection storm of 100,000 new connections in 10 seconds during game launch, and (4) minimize message delivery latency (p99 under 50ms). What architecture handles this scale?

A) Use Amazon API Gateway WebSocket API with a DynamoDB table storing connection IDs grouped by game room. When a game state update occurs, query DynamoDB for all connection IDs in the room and call the API Gateway `@connections` POST API for each connection. Use Lambda functions for the `$connect`, `$disconnect`, and `$default` routes. Configure API Gateway with a Regional endpoint and DynamoDB on-demand for the connection store.

B) Deploy an Amazon EKS cluster with pods running a WebSocket server (e.g., Socket.IO). Use a Network Load Balancer with sticky sessions enabled (by source IP) to route connections to the same pod. Store connection-to-room mappings in ElastiCache Redis with pub/sub for cross-pod message distribution. When a game state update occurs for a room, publish to the Redis channel; all pods subscribed to that channel push updates to their local connections. Use Karpenter for rapid node scaling during connection storms. Use Redis Cluster mode with 6 shards for the connection store.

C) Use AWS AppSync with real-time subscriptions. Create a GraphQL subscription for each game room. When game state updates, publish mutations that trigger subscription updates to all connected clients in the room. AppSync automatically manages WebSocket connections and scales horizontally. Store connection state in DynamoDB via AppSync resolvers.

D) Use Amazon Kinesis Data Streams as a message bus. Clients connect via API Gateway WebSocket, and each game room maps to a Kinesis shard. Game state updates are written to the appropriate shard. Lambda consumers read from each shard and push updates to connected clients via the API Gateway Management API. Use enhanced fan-out for dedicated consumer throughput.

---

### Question 39

A company runs a data pipeline that transforms CSV files into Parquet for analytics. Files range from 100 MB to 50 GB and arrive continuously (200 files/day). The pipeline must: (1) handle schema validation and reject malformed files, (2) deduplicate records based on a composite key, (3) partition output by date and region, (4) complete processing within 30 minutes of file arrival regardless of file size, (5) cost less than $500/month, and (6) handle up to 10x burst in file arrivals during month-end reporting. What architecture meets ALL requirements?

A) Use S3 event notifications to trigger an AWS Glue ETL job for each file. Configure the Glue job with DynamicFrames for schema validation. Use Glue's `DropDuplicates` transform for deduplication. Write output in Parquet format partitioned by date and region. Configure Glue with auto-scaling up to 20 DPUs. For large files (>10 GB), configure Glue with additional DPUs via a Lambda function that checks file size before starting the job.

B) Use S3 event notifications to trigger a Step Functions workflow. The first state is a Lambda function that validates the file schema (reading only the header and first 100 rows). If valid, the workflow triggers an AWS Glue ETL job with worker type G.2X and auto-scaling enabled. The Glue job performs deduplication using a SQL-based approach with Spark's `dropDuplicates()` on the composite key, and writes partitioned Parquet to the output bucket. For files over 10 GB, the Step Functions workflow allocates more Glue DPUs. Configure the Glue job with bookmarks disabled (each file is processed independently). Monitor costs using Glue job metrics.

C) Use S3 event notifications to trigger a Lambda function (15-minute timeout, 10 GB memory). The Lambda reads the CSV using PyArrow, validates schema, deduplicates using pandas, and writes Parquet partitioned by date and region. For files larger than what Lambda memory can handle (>5 GB), the Lambda triggers an ECS Fargate task instead.

D) Deploy Apache Airflow on Amazon MWAA. Create a DAG that monitors S3 for new files, triggers a PySpark job on Amazon EMR Serverless for each file. The Spark job handles schema validation, deduplication, and partitioned Parquet output. Use EMR Serverless auto-scaling. Schedule the DAG to check for new files every 5 minutes.

---

### Question 40

A company is building a global API that must serve requests from 30 countries with strict latency requirements: p99 under 100ms for read operations and p99 under 500ms for write operations. The API manages user preferences (read-heavy, 95% reads) and processes transactions (write-heavy, 80% writes). The database must handle 100,000 reads/second and 20,000 writes/second globally. Data must be consistent within a Region and eventually consistent across Regions (within 1 second). What is the BEST multi-Region data architecture?

A) Use Amazon DynamoDB Global Tables for user preferences (read-heavy). Deploy DynamoDB tables in 3 Regions (us-east-1, eu-west-1, ap-northeast-1) with Global Tables replication. Use DynamoDB DAX in each Region for sub-millisecond reads. For transactions, use a single-Region Amazon Aurora MySQL cluster in us-east-1 with Aurora Global Database read replicas in the other two Regions. Write all transactions to us-east-1 and read from local replicas. Use Route 53 latency-based routing to direct API traffic to the nearest Region.

B) Use Amazon Aurora Global Database with PostgreSQL for both workloads. Deploy the primary cluster in us-east-1 with secondary clusters in eu-west-1 and ap-northeast-1. Use Aurora's write forwarding feature so writes from any Region are forwarded to the primary. Configure read-local, write-global routing in the application. Use ElastiCache Global Datastore for caching in each Region.

C) Use DynamoDB Global Tables for both workloads across 3 Regions. For user preferences, use eventually consistent reads from the local Region (sub-10ms). For transactions, use DynamoDB Transactions with write-to-local semantics (Global Tables replicates within 1 second). Deploy API Gateway Regional endpoints in each Region with Lambda functions accessing local DynamoDB tables. Use CloudFront with Regional API Gateway as origin for additional edge caching of read responses.

D) Use Amazon ElastiCache Global Datastore as the primary data store for user preferences (in-memory for lowest latency). Use DynamoDB Global Tables for transactions with write-sharding across Regions. Implement conflict resolution in the application layer using last-writer-wins with vector clocks.

---

### Question 41

A media streaming company needs to transcode video uploads into 6 different formats (SD, HD, FHD, 4K, HDR, Mobile) simultaneously. Average upload is 10 GB, and they receive 500 uploads per day. Each transcode job takes: SD (5 min), HD (10 min), FHD (20 min), 4K (45 min), HDR (60 min), Mobile (3 min) on a c5.4xlarge instance. Requirements: (1) all 6 formats must be available within 90 minutes of upload, (2) transcoding quality must match the existing FFmpeg-based pipeline, (3) failed transcodes must retry automatically up to 3 times, (4) the solution must minimize cost, and (5) the company wants to avoid managing infrastructure. What is the MOST cost-effective architecture?

A) Use AWS Elemental MediaConvert for all transcoding. Create a job template with 6 output groups (one per format). MediaConvert processes all outputs in a single job with built-in parallel processing. Configure S3 event notifications on the upload bucket to trigger a Lambda function that submits MediaConvert jobs. Use MediaConvert's reserved pricing for the baseline 500 jobs/day. Configure EventBridge rules for job state changes to handle retries (Lambda resubmits failed outputs). Use on-demand queues for burst capacity.

B) Use a Step Functions workflow triggered by S3 upload events. The workflow launches 6 parallel Lambda functions, each running FFmpeg (via a Lambda Layer) for a different format. For formats exceeding Lambda's 15-minute timeout (FHD, 4K, HDR), use ECS Fargate tasks instead. Configure Step Functions retry policies (3 attempts with exponential backoff) for each parallel branch. Store transcoded output in S3.

C) Use AWS Batch with Spot Instances. Create a job queue with a compute environment using c5.4xlarge Spot Instances. Submit 6 AWS Batch jobs per upload (one per format) as an array job. Configure retry strategy of 3 attempts. Use FFmpeg container images for transcoding. Use Spot for the longer jobs (4K, HDR) and On-Demand for shorter jobs to ensure SLA.

D) Deploy an EKS cluster with Karpenter for auto-scaling. Run FFmpeg pods with resource requests sized for each format. Use a Kubernetes Job with parallelism=6 for each upload. Configure pod restart policy to retry up to 3 times. Use Spot instances via Karpenter for cost savings.

---

### Question 42

A company needs to optimize their Amazon Aurora MySQL database that handles both OLTP (10,000 transactions/second) and OLAP (50 complex analytical queries/hour) workloads. The OLAP queries currently cause lock contention and degrade OLTP performance. The database is 2 TB with 500 tables. OLAP queries typically scan 100 million+ rows and involve 5-10 table joins. Requirements: (1) OLTP p99 latency must stay under 10ms, (2) OLAP queries must complete within 60 seconds, (3) OLAP results must use data no more than 5 minutes stale, and (4) the solution must minimize additional infrastructure costs. What is the OPTIMAL architecture?

A) Add two Aurora read replicas (r6g.2xlarge) to the cluster and direct all OLAP queries to the replicas using a reader endpoint. Aurora replicas have minimal replication lag (typically under 20ms). Create appropriate indexes for OLAP queries on the replicas (using `ALTER TABLE` on the replicas via custom endpoint). Use `EXPLAIN ANALYZE` to optimize the OLAP query plans.

B) Enable Aurora Parallel Query on the cluster. Parallel Query offloads OLAP-style scans to the Aurora storage layer, reducing contention with the OLTP workload on the database instance. Create two custom endpoints: one for OLTP (writer instance) and one for OLAP (with parallel query hints). This avoids the need for additional read replicas while meeting the 5-minute staleness requirement (parallel query reads from the shared storage layer which is always current).

C) Create an Aurora zero-ETL integration with Amazon Redshift. Aurora continuously replicates data to a Redshift Serverless endpoint with near-real-time latency (typically under 10 seconds). Direct all OLAP queries to Redshift, which is optimized for complex analytical queries with columnar storage and MPP architecture. OLTP continues on Aurora unaffected. No additional ETL pipeline or data freshness management needed.

D) Add an Aurora read replica and enable ProxySQL-based query routing. Create a read replica specifically for OLAP. Deploy a Lambda function that runs every 5 minutes to refresh materialized views on the read replica for commonly accessed OLAP query patterns. Use RDS Proxy to separate OLTP and OLAP connection pools.

---

### Question 43

A company is building a data pipeline that needs to join streaming data from Amazon Kinesis Data Streams (1 million events/second, 500 bytes each) with a reference dataset in Amazon S3 (100 GB, updated hourly). The joined output must be written to: (1) Amazon Redshift for BI dashboards (within 5 minutes), (2) Amazon S3 in Parquet format for data lake queries (within 15 minutes), and (3) an Amazon OpenSearch cluster for operational dashboards (within 30 seconds). What architecture achieves ALL three latency requirements with LEAST operational overhead?

A) Use Amazon Managed Service for Apache Flink (Kinesis Data Analytics) to consume the Kinesis stream, load the S3 reference dataset as a lookup table (refreshed hourly), and perform the join in real-time. Configure three sinks from the Flink application: (1) direct write to OpenSearch using the OpenSearch Flink connector (meeting 30-second requirement), (2) write to a Kinesis Data Firehose delivery stream configured with Redshift as destination with 5-minute buffering, and (3) write to a second Kinesis Data Firehose delivery stream with S3 destination in Parquet format with 15-minute buffering.

B) Use AWS Glue Streaming ETL with a Kinesis source. Configure the Glue job to join streaming data with the S3 reference dataset. Write joined output to S3 in Parquet (15-minute micro-batches). Use S3 event notifications to trigger a Lambda that loads data into Redshift via COPY. Use a separate Kinesis consumer (Lambda) for OpenSearch with direct writes.

C) Deploy Apache Kafka on Amazon MSK to mirror the Kinesis stream. Use MSK Connect with connectors for Redshift, S3, and OpenSearch. Implement the join logic in a custom Kafka Streams application running on ECS. Update the reference dataset in a Kafka compacted topic, refreshed hourly.

D) Use Lambda consumers with Kinesis event source mapping. Cache the S3 reference dataset in a Lambda global variable (refreshed hourly). Write joined results to OpenSearch via the Lambda function. Batch results and write to Kinesis Data Firehose for both S3 and Redshift delivery.

---

### Question 44

A company operates a latency-sensitive microservices architecture with 50 services on Amazon EKS. Inter-service communication currently uses REST over HTTP/1.1 through an internal ALB. Average inter-service call latency is 25ms, but cascading timeouts cause p99 to spike to 500ms. A service graph analysis shows that a single user request triggers an average of 12 downstream service calls (some parallel, some sequential). The target is to reduce overall request latency to under 200ms at p99. What combination of changes has the GREATEST impact on latency? (Select TWO.)

A) Replace REST/HTTP 1.1 with gRPC over HTTP/2 for inter-service communication. Deploy Envoy sidecar proxies via AWS App Mesh for service discovery and connection pooling. HTTP/2 multiplexing eliminates head-of-line blocking, and gRPC's binary protocol reduces serialization overhead. Configure connection pooling to maintain persistent connections between services.

B) Implement a circuit breaker pattern using App Mesh with outlier detection. Configure each virtual service with connection limits (max connections: 1024, max pending requests: 1024), timeout policies (15-second connection timeout, 10-second per-request timeout), and retry policies (2 retries on 5xx errors with exponential backoff). Enable outlier detection to eject unhealthy endpoints after 3 consecutive 5xx errors.

C) Deploy all 50 services in a single cluster placement group across one Availability Zone. Use enhanced networking (ENA) with jumbo frames (9001 MTU) for reduced packet overhead. This minimizes network latency between pods.

D) Replace synchronous REST calls with asynchronous messaging using Amazon SQS between all services. Implement eventual consistency patterns and saga orchestration for transaction management.

E) Deploy Amazon ElastiCache for Redis as a central response cache. Cache frequently requested inter-service call responses with a 30-second TTL. Implement a cache-aside pattern in each service. This reduces the number of actual inter-service calls.

---

### Question 45

A genomics research company processes DNA sequencing data. Each sequencing run produces 300 GB of raw data that must be processed through a pipeline: (1) base calling (GPU-intensive, 2 hours per run), (2) alignment (CPU-intensive, 4 hours, requires 256 GB RAM), (3) variant calling (CPU + I/O intensive, 6 hours, requires 500 GB local scratch), (4) annotation (lightweight, 30 minutes). The company runs 20 sequencing runs per week. Requirements: minimum cost, each run completed within 24 hours, no data loss if a step fails. What is the MOST cost-effective architecture?

A) Use AWS Step Functions to orchestrate the pipeline. Step 1 (base calling): Submit an AWS Batch job using p3.2xlarge Spot Instances with a retry strategy. Step 2 (alignment): AWS Batch job using r5.8xlarge Spot Instances. Step 3 (variant calling): AWS Batch job using c5d.9xlarge Spot Instances (with 900 GB NVMe local storage for scratch). Step 4 (annotation): Lambda function (10 GB memory, 15-min timeout). Store intermediate results in S3 between steps. Configure Step Functions to retry failed steps from the beginning (since intermediate results are in S3).

B) Deploy an Amazon ParallelCluster with a Slurm scheduler. Use a mix of Spot Instance types for each step. Configure shared storage on Amazon FSx for Lustre for intermediate data. Submit all 4 steps as dependent Slurm jobs. Use checkpointing to S3 for fault tolerance.

C) Use Amazon SageMaker Processing Jobs for each step. Step 1 uses ml.p3.2xlarge, Step 2 uses ml.r5.8xlarge, Step 3 uses ml.c5.9xlarge, Step 4 uses ml.t3.medium. Chain jobs using SageMaker Pipelines. Store intermediate data in SageMaker's default S3 bucket.

D) Use Amazon EMR on EC2 with a transient cluster for each pipeline run. Configure task nodes as Spot (GPU instances for step 1, memory-optimized for step 2, compute-optimized for step 3). Use HDFS for intermediate storage and S3 for final output.

---

### Question 46

A company manages a network of 200 VPCs across 5 AWS Regions for a large enterprise. The network must support: (1) any-to-any VPC connectivity within a Region, (2) inter-Region connectivity for 20 VPC pairs with specific bandwidth requirements (1-10 Gbps), (3) on-premises data center connectivity via 4 Direct Connect locations (2 in US, 1 in EU, 1 in APAC), (4) centralized internet egress through a shared VPC with firewall inspection, (5) traffic between specific VPCs must be isolated (e.g., production cannot talk to development), and (6) the network team needs a single pane of glass for monitoring all network paths. What is the MOST scalable network architecture?

A) Deploy AWS Transit Gateway in each of the 5 Regions. Peer all 5 Transit Gateways using inter-Region peering. Attach all VPCs to their Regional Transit Gateway. Use Transit Gateway route tables with separate domains for production and development (attach production VPCs to a "production" route table and development VPCs to a "development" route table with no route propagation between them). Attach Direct Connect Gateways to all Transit Gateways for on-premises connectivity. Create a shared services VPC with AWS Network Firewall and route all internet-bound traffic through it via Transit Gateway blackhole routes for the default route on non-shared route tables and specific routes to the firewall VPC. Use AWS Network Manager with CloudWatch for centralized monitoring.

B) Use AWS Cloud WAN to create a global network. Define segments for production, development, and shared services. Create a core network policy that specifies which segments can communicate. Attach VPCs to the appropriate Cloud WAN segments. Configure Direct Connect attachments to Cloud WAN. Route internet egress through the shared services segment with AWS Network Firewall. Use Cloud WAN's built-in network monitoring dashboard and Route Analyzer for visibility.

C) Use VPC Peering for intra-Region connectivity and AWS Transit Gateway for inter-Region connectivity. Deploy firewall appliances from AWS Marketplace in each Region for centralized egress. Use separate AWS accounts for production and development to enforce isolation. Use VPC Flow Logs aggregated in a central S3 bucket for monitoring.

D) Deploy a third-party SD-WAN solution on EC2 instances in each Region. Manage all routing through the SD-WAN controller. Use IPSec VPN over the internet for inter-Region connectivity. Connect to on-premises via the SD-WAN appliance. Use the SD-WAN vendor's dashboard for monitoring.

---

### Question 47

A SaaS company runs a multi-tenant application on AWS. Their current monthly bill is $250,000 broken down as: EC2 On-Demand ($80,000 — 100 m5.2xlarge running 24/7), RDS Multi-AZ ($35,000 — 2 db.r5.4xlarge instances), NAT Gateway data processing ($30,000 — 15 TB/month), Data Transfer out ($25,000 — 50 TB/month), S3 storage ($20,000 — 500 TB), ElastiCache ($15,000 — 3 r5.2xlarge nodes), CloudWatch ($10,000 — detailed monitoring + custom metrics), EBS ($8,000 — 100 TB gp2), Lambda ($7,000 — 500 million invocations), and other ($20,000). The CTO wants to reduce the bill by at least 40% ($100,000/month savings) without reducing availability or performance. What combination of optimizations achieves this? (Select THREE.)

A) Purchase 3-year Compute Savings Plans covering 70% of the EC2 and Lambda spend ($80,000 + $7,000 = $87,000 × 70% = $60,900, saving approximately 66% on covered usage = ~$40,000/month savings). Migrate remaining 30% of EC2 workloads that are fault-tolerant to Spot Instances for an additional ~$5,000 savings.

B) Migrate EC2 instances from m5.2xlarge to m6g.2xlarge (Graviton, ~20% cheaper) and EBS from gp2 to gp3 (20% cheaper baseline). Right-size RDS instances using Performance Insights data (potentially downsize to db.r6g.2xlarge). Combined savings: ~$20,000/month on EC2 + $1,600/month on EBS + ~$8,000/month on RDS if right-sized.

C) Reduce NAT Gateway costs by deploying VPC endpoints for S3 (gateway endpoint, free) and other AWS services (interface endpoints, ~$500/month). Move internal traffic off the NAT Gateway by routing through PrivateLink. Reduce data transfer out by implementing CloudFront with origin shield for content delivery (CloudFront data transfer is cheaper than EC2 data transfer). Combined savings: ~$20,000/month on NAT Gateway + ~$10,000/month on data transfer.

D) Migrate from ElastiCache to DynamoDB DAX for caching ($5,000/month savings). Replace CloudWatch with a self-managed Prometheus/Grafana stack on EC2 ($8,000/month savings). Replace RDS with Aurora Serverless v2 ($15,000/month savings).

E) Move S3 data to S3 Intelligent-Tiering for the 500 TB ($20,000 → ~$10,000/month if 60% of data is infrequently accessed). Reduce CloudWatch costs by switching from detailed (1-minute) to basic (5-minute) monitoring for non-critical instances and using CloudWatch Embedded Metric Format instead of custom metric API calls. Combined savings: ~$10,000 on S3 + ~$5,000 on CloudWatch.

---

### Question 48

A startup runs a machine learning inference API on AWS. The API receives 1,000 requests per second during business hours (8am-8pm) and 50 requests per second during off-hours. Each inference request requires a model loaded into GPU memory (8 GB model, takes 2 minutes to load). Current setup: 10 g4dn.xlarge On-Demand instances running 24/7 behind an ALB, costing $18,000/month. The inference takes 100ms per request on a g4dn.xlarge GPU. The startup wants to cut costs by 60%+ while maintaining p99 latency under 500ms during business hours and under 2 seconds during off-hours. What architecture achieves this?

A) Use Amazon SageMaker real-time inference endpoints with auto-scaling. Configure a scaling policy to scale from 2 instances (off-hours) to 10 instances (business hours) based on a scheduled scaling policy combined with target tracking on `InvocationsPerInstance`. Use SageMaker Savings Plans for the baseline 2 instances. Use ml.g4dn.xlarge instances. Pre-load the model during instance initialization. Configure a scale-in cooldown of 300 seconds to prevent thrashing.

B) Deploy an EKS cluster with Karpenter configured for g4dn.xlarge Spot Instances. Use a Horizontal Pod Autoscaler (HPA) scaling on GPU utilization. Configure a KEDA scaler for time-based scaling (2 pods off-hours, 10 pods business hours). Use Karpenter node consolidation to terminate underutilized nodes. Implement a model-caching init container that loads the model from S3 to a shared EBS volume.

C) Use AWS Lambda with provisioned concurrency and a custom container image containing the ML model. Configure 50 provisioned concurrency units during off-hours and 500 during business hours via scheduled scaling. Use Lambda SnapStart to reduce cold start time. Store the model in an EFS file system mounted to Lambda.

D) Use SageMaker Serverless inference endpoints. Configure a maximum concurrency of 200 and a memory size of 6 GB. The endpoint automatically scales to zero during periods of no traffic and scales up as needed. Accept the cold start penalty (model loading time) during off-hours. For business hours, create a CloudWatch Events rule that sends warm-up requests every minute.

---

### Question 49

A company processes 10 million images per day for a product recognition service. Each image is 5 MB and requires: (1) upload to S3, (2) resize to 3 resolutions (thumbnail, medium, large), (3) object detection using a custom ML model (takes 2 seconds on CPU, 200ms on GPU), and (4) metadata storage in DynamoDB. The pipeline currently runs on 50 c5.2xlarge instances costing $55,000/month. 80% of the cost is in the object detection step. What architecture MINIMIZES total cost while maintaining the same throughput?

A) Use Lambda for upload handling, resizing (using Sharp library), and DynamoDB writes. Use SageMaker batch transform with ml.g4dn.xlarge Spot Instances for batch object detection. Accumulate images in S3 and run batch detection every 15 minutes. This eliminates the need for 24/7 GPU instances. Estimated cost: Lambda (~$2,000/month) + SageMaker batch (~$8,000/month with Spot) + DynamoDB (~$1,000/month) = ~$11,000/month.

B) Replace c5.2xlarge instances with g4dn.xlarge instances for the detection step (200ms vs 2s = 10x throughput per instance, need only 5 instances). Use Lambda for resize and upload handling. Use Reserved Instances for the 5 g4dn.xlarge instances. Estimated cost: ~$15,000/month.

C) Use Lambda for all steps including detection. Deploy the ML model as a Lambda container with 10 GB memory. Each Lambda invocation takes 2 seconds for detection (CPU). With 10M images/day = ~115 images/second, need concurrent Lambda executions. Estimated cost: 10M × 2s × $0.0000133 per GB-second × 10 GB = ~$2,660/month for detection + ~$1,000 for other steps.

D) Use AWS Inferentia (inf1.xlarge) instances for the detection step. Compile the model for Inferentia using AWS Neuron SDK. Inferentia provides 4x price-performance over GPU for inference. Deploy 3 inf1.xlarge instances with reserved pricing. Use Lambda for other steps. Estimated cost: ~$8,000/month total.

---

### Question 50

A company has a data warehouse on Amazon Redshift (3 dc2.8xlarge nodes, $58,000/year reserved). Usage analysis reveals: (1) BI dashboards query the last 30 days of data (200 GB) heavily between 8am-6pm, (2) analysts run ad-hoc queries across 1-3 years of data (5 TB) between 10am-4pm, (3) monthly reports scan the entire 10 TB dataset, run overnight, (4) 60% of the 10 TB data hasn't been queried in 6 months, and (5) the RI expires in 2 months. What is the MOST cost-effective strategy for the next 3 years?

A) Migrate to Amazon Redshift Serverless. The RPU-based pricing means you pay only for queries when they run. Configure base RPU of 32 for dashboard queries, burst to 256 for analyst queries. Unload historical data (>1 year) to S3 in Parquet format and query via Redshift Spectrum. For monthly reports, schedule them during off-peak hours when Serverless scales down the RPU cost.

B) Migrate to Amazon Redshift RA3 nodes (ra3.xlplus, 6 nodes) with 1-year reserved pricing. RA3 separates compute and storage, storing data in managed storage (S3-backed). Keep only 30 days of data in local cache (200 GB fits easily). Archive data older than 1 year to S3 and use Redshift Spectrum for monthly reports. Enable Concurrency Scaling (free for 1 hour/day per cluster) for peak dashboard traffic. Use Redshift data sharing to create a second Serverless endpoint for analyst ad-hoc queries that only runs during 10am-4pm.

C) Replace Redshift entirely with Amazon Athena for all workloads. Store all data in S3 in Parquet format partitioned by date. Use Athena Workgroups with query limits per group. Use Amazon QuickSight with SPICE for dashboard acceleration. Run monthly reports as Athena queries scheduled via EventBridge.

D) Keep the existing dc2.8xlarge cluster and renew the 3-year RI. Optimize by adding a second smaller cluster (dc2.large, 2 nodes) for analyst queries using Redshift data sharing. Archive old data to S3 Glacier. Run monthly reports on the main cluster during off-hours.

---

### Question 51

A company runs 200 microservices on Amazon ECS Fargate. Their monthly Fargate bill is $120,000. Analysis shows: (1) 80% of services run at less than 30% CPU utilization, (2) 15 services are latency-critical and need consistent performance, (3) 50 services are batch processors that run for 2-4 hours every 6 hours, (4) 30 services handle unpredictable traffic with 10x burst potential, and (5) all services currently use 2 vCPU / 4 GB memory task definitions. What combination of changes achieves the GREATEST cost reduction? (Select TWO.)

A) Right-size all 200 services using Container Insights CPU/memory utilization data. For the 80% of services at <30% CPU utilization, reduce task definitions to 0.5 vCPU / 1 GB memory (or the minimum that Performance data supports). This alone could reduce Fargate compute costs by 50-60% for those services. For the 15 latency-critical services, keep current sizing or increase slightly with Fargate Spot disabled.

B) Migrate the 50 batch processor services from Fargate to ECS on EC2 with Spot Instances. Use Capacity Providers with a spot:on-demand ratio of 80:20. Configure ECS cluster auto-scaling to scale based on running task count. For the batch services that run 2-4 hours every 6 hours, this eliminates paying for idle Fargate time and gets 60-70% Spot discount. Estimated savings: 50 services × ~$100/month each × 70% = ~$3,500/month plus idle time savings.

C) Migrate all 200 services from Fargate to ECS on EC2 with a Savings Plan covering 3-year Compute. Use c6g.xlarge (Graviton) instances in an Auto Scaling group. This provides approximately 50% savings over Fargate for all workloads.

D) Implement Fargate Spot for the 30 unpredictable-traffic services. Configure a base of 2 Fargate tasks (for availability) and use Fargate Spot for all additional scaling tasks. The 70% Spot discount on burst capacity significantly reduces costs for unpredictable scaling.

E) Migrate the 15 latency-critical services to Lambda for pay-per-invocation pricing. Deploy the 50 batch services as Step Functions workflows with Lambda functions. Keep only the 30 burst-traffic services on Fargate.

---

### Question 52

A media company stores 5 PB of video content in Amazon S3 Standard across a single Region. Monthly storage costs are $115,000. Access pattern analysis shows: (1) 5% of content (250 TB) is accessed daily (popular/trending), (2) 15% (750 TB) is accessed weekly (catalog content), (3) 30% (1.5 PB) is accessed monthly (older catalog), (4) 50% (2.5 PB) is accessed less than once per year (archive), and (5) any content can suddenly become trending due to viral social media, requiring immediate access. What storage strategy achieves MAXIMUM cost savings while handling viral content access?

A) Move popular content (250 TB) to S3 Standard. Move weekly content (750 TB) to S3 Standard-IA. Move monthly content (1.5 PB) to S3 Glacier Instant Retrieval. Move archive content (2.5 PB) to S3 Glacier Flexible Retrieval. Set up CloudWatch alarms on S3 GET request metrics to detect viral access patterns and trigger a Lambda that restores and transitions objects back to Standard.

B) Put ALL 5 PB in S3 Intelligent-Tiering with all access tiers enabled (Frequent, Infrequent, Archive Instant, Archive, Deep Archive). Intelligent-Tiering automatically moves objects between tiers based on access patterns. When a video goes viral, Intelligent-Tiering automatically promotes it from any tier to Frequent Access with no retrieval fees. The monitoring fee is $0.0025 per 1,000 objects/month which is negligible. This eliminates the need for custom lifecycle logic and handles viral content automatically.

C) Deploy S3 Intelligent-Tiering for the 80% of content that has unpredictable access (weekly + monthly + archive). Keep the 5% popular content on S3 Standard (predictably accessed). Implement lifecycle rules to move the remaining 15% weekly content to S3 Standard-IA. Enable S3 Intelligent-Tiering Archive Instant Access tier but NOT the Archive or Deep Archive tiers (to ensure immediate access for viral content).

D) Use S3 Lifecycle rules: move to Standard-IA after 30 days, Glacier Instant Retrieval after 90 days, Glacier Flexible Retrieval after 365 days. Configure S3 Batch Operations to run weekly, checking analytics data and restoring viral content to Standard.

---

### Question 53

A financial services company transfers 50 TB of data monthly between their on-premises data center and AWS us-east-1. They also transfer 20 TB/month between us-east-1 and eu-west-1 for their European operations. Additionally, 10 TB/month of data is transferred from eu-west-1 to the internet for European customers. Current costs: Direct Connect ($5,000/month for a 10 Gbps port), data transfer in ($0 — free), data transfer between Regions ($20,000/month at $0.02/GB × 20 TB × 50%), data transfer out to internet from eu-west-1 ($8,500/month at $0.085/GB average). Total data transfer costs: $33,500/month. What changes can reduce total data transfer costs by at least 30% ($10,000/month)? (Select TWO.)

A) Deploy CloudFront for the 10 TB/month of European internet-facing traffic. CloudFront data transfer to internet is approximately $0.085/GB in Europe (same as EC2), but CloudFront offers a Security Savings Bundle that provides up to 30% savings on CloudFront usage with a 1-year commitment. Estimated savings: $8,500 × 30% = $2,550/month.

B) Compress data before inter-Region transfer. If compression achieves a 60% reduction (typical for structured data), the 20 TB becomes 8 TB, saving $0.02 × 12,000 GB = $240/month. Additionally, use VPC Peering instead of Transit Gateway for inter-Region traffic (VPC Peering inter-Region is $0.01/GB vs Transit Gateway at $0.02/GB). Savings: $0.01 × 20,000 GB = $200/month. Total: $440/month.

C) For inter-Region transfer, deploy S3 buckets in each Region and use S3 Cross-Region Replication (CRR) with S3 Replication Time Control (RTC). While CRR itself doesn't reduce per-GB costs, restructure the data flow to minimize cross-Region traffic: process data locally in each Region and only transfer aggregated results. If this reduces cross-Region transfer from 20 TB to 5 TB: savings = $0.02 × 15,000 GB = $300/month.

D) Replace CloudFront with a custom CDN on EC2 instances in multiple Regions using S3 as origin. Negotiate an Enterprise Discount Program (EDP) or Private Pricing Agreement with AWS for data transfer, which can provide 10-20% discounts. On $33,500/month: savings could be $3,350-$6,700/month.

E) Use CloudFront with Origin Shield for the European internet traffic. CloudFront pricing is $0.02-0.085/GB depending on edge location, but with a CloudFront Committed Use Discount (Security Savings Bundle) at $5,000/month, you get ~$7,150 of usage. For the remaining data transfer, negotiate a private pricing addendum on inter-Region transfer. Combined potential savings: ~$3,500 on internet + negotiated inter-Region savings.

---

### Question 54

A company operates an Amazon DynamoDB table that stores user activity events. The table has 2 billion items, 500 GB of data, and receives 50,000 writes/second and 200,000 reads/second. Provisioned capacity costs $45,000/month (25,000 WCU + 100,000 RCU with reserved pricing). Analysis shows: (1) 70% of reads use strongly consistent reads but could tolerate eventually consistent, (2) writes have a hot partition on the `userId` key for viral users, (3) 40% of reads fetch items that haven't been written in the last 24 hours, and (4) the GSI for time-range queries consumes 30% of the total WCU. What combination of changes reduces DynamoDB costs by at least 40%? (Select TWO.)

A) Switch 70% of reads from strongly consistent to eventually consistent. Eventually consistent reads consume half the RCU. Current read cost: 100,000 RCU. After change: 30,000 strongly consistent RCU + 70,000 eventually consistent = 30,000 + 35,000 = 65,000 RCU equivalent. Savings: 35,000 RCU = 35% reduction in read costs. Approximately $5,000-7,000/month savings.

B) Implement write sharding for the hot `userId` partition. Append a random suffix (0-9) to the partition key for viral users. This distributes writes across 10 partitions. This doesn't directly reduce cost but prevents throttling (which causes retry overhead and wasted WCU). For the GSI, evaluate if the time-range query can be replaced with a DynamoDB Streams + Lambda pipeline that maintains a pre-computed result in a separate table, eliminating the GSI entirely. Removing the GSI saves 30% of WCU = ~$4,000/month.

C) Deploy DynamoDB Accelerator (DAX) for the 40% of reads on stale data. A dax.r5.large cluster (3 nodes) costs approximately $900/month. If DAX handles 40% of reads (80,000 reads/second), you can reduce provisioned RCU from 100,000 to 60,000, saving approximately $7,000/month. Net savings: $6,100/month.

D) Migrate from provisioned capacity to on-demand capacity mode. On-demand pricing: $1.25 per million WCU and $0.25 per million RCU. Monthly cost: 50,000 WPS × 86,400 seconds × 30 days = 129.6 billion writes × $1.25/million = $162,000 for writes alone. This is significantly MORE expensive than provisioned capacity.

E) Enable DynamoDB auto-scaling with a target utilization of 50% and switch to on-demand for the GSI only. Separate the time-range query workload to a new on-demand table populated via DynamoDB Streams. This allows the main table to optimize provisioned capacity while the query table scales independently.

---

### Question 55

A startup is choosing between three architectures for their new API backend that will serve 1,000 requests per second with 100ms average response time. Each request reads from a database and processes the result. The three options are: (A) Lambda + API Gateway, (B) ECS Fargate containers, (C) EC2 instances in an Auto Scaling group. The contract is for 3 years with predictable traffic. Compute is the primary cost — database costs are identical across all options. What is the MOST cost-effective option, and why do the other two cost more?

A) **Lambda + API Gateway** is cheapest. At 1,000 req/s × 100ms × 128 MB memory: Lambda cost = 1,000 × 0.1s × $0.0000000021 × 128/1024 × 86,400 × 30 = ~$680/month. API Gateway REST API: 1,000 × 86,400 × 30 = 2.592B requests × $3.50/million = ~$9,072/month. Total: ~$9,750/month. API Gateway costs dominate.

B) **ECS Fargate** is cheapest. Running 5 Fargate tasks (0.5 vCPU, 1 GB) to handle 1,000 req/s: 5 × ($0.04048 × 0.5 + $0.004445 × 1) × 24 × 30 = ~$3,630/month. With a 3-year Compute Savings Plan (52% discount): ~$1,742/month.

C) **EC2 Auto Scaling** is cheapest. Using 3 c6g.medium instances (1 vCPU, 2 GB) with a 3-year All Upfront Reserved Instance: approximately $450/month across all 3 instances. Additional ALB cost: ~$20/month + LCU charges ~$50/month. Total: ~$520/month. EC2 RI provides the deepest discount for steady-state, predictable workloads.

D) All three options cost approximately the same over 3 years when properly optimized with savings plans or reserved instances. The choice should be based on operational requirements rather than cost.

---

### Question 56

A company deploys a new application every two weeks. Each deployment involves updating 100 EC2 instances behind an ALB. Current process: manual AMI creation, launch configuration update, and rolling replacement — taking 4 hours. Deployments occasionally fail at instance 60-70, requiring a full rollback that takes another 3 hours. Requirements: (1) deployment must complete in under 30 minutes, (2) automatic rollback on failure (detected by CloudWatch alarm on HTTP 5xx rate > 5%), (3) zero downtime during deployment, (4) the ability to canary-test with 5% of traffic before full rollout, and (5) cost must not exceed $2,000/month for the deployment infrastructure. What deployment strategy meets ALL requirements?

A) Use AWS CodeDeploy with an in-place deployment type and a `OneAtATime` deployment configuration. Configure a CloudWatch alarm for 5xx errors as an automatic rollback trigger. Use CodeDeploy lifecycle hooks for canary testing — deploy to one instance first, run integration tests, then continue.

B) Use AWS CodeDeploy with a blue/green deployment via an Auto Scaling group. Create a CodeDeploy deployment group linked to the ALB. Configure a custom deployment configuration: `canary-5-percent` (5% of traffic for 10 minutes, then 100%). Set up a CloudWatch alarm on ALB `HTTPCode_Target_5XX_Count` as an automatic rollback trigger. CodeDeploy provisions a new ASG (green), shifts traffic gradually, and terminates the old ASG (blue) after successful deployment. For cost, the green ASG runs for approximately 30 minutes per deployment = ~2 hours/month of double capacity at On-Demand pricing.

C) Implement a custom blue/green deployment using Route 53 weighted routing. Deploy a second ASG with the new version, manually shift 5% of traffic via Route 53 weights. Monitor for 10 minutes. If healthy, shift to 100%. Use a Lambda function to automate the traffic shifting and rollback based on CloudWatch metrics.

D) Use Amazon ECS with rolling updates. Containerize the application and deploy on ECS Fargate behind the ALB. Configure the ECS service with a deployment circuit breaker that automatically rolls back on failed tasks. Use CodePipeline for the deployment pipeline. Configure minimum healthy percent at 100% and maximum percent at 200% for zero downtime.

---

### Question 57

A company uses Amazon RDS for MySQL (db.r5.2xlarge Multi-AZ) at a cost of $4,200/month. The database stores 500 GB of data but Performance Insights shows: (1) average CPU utilization is 15%, (2) average freeable memory is 50 GB out of 64 GB, (3) average IOPS is 500 (provisioned 3,000 gp2), (4) 90% of queries are simple key-value lookups, (5) the remaining 10% are complex reports that run nightly and spike CPU to 80% for 2 hours. The application team refuses to modify application code. What changes reduce RDS costs by at least 50%?

A) Downsize to db.r6g.xlarge (Graviton, 4 vCPU, 32 GB RAM) which handles the 15% average CPU load. Switch storage from 500 GB gp2 (3,000 IOPS) to 500 GB gp3 (3,000 IOPS baseline + 125 MB/s throughput at lower cost). Purchase a 1-year All Upfront Reserved Instance. For the nightly reports, schedule an RDS read replica (db.r6g.xlarge) to be created at 11pm and deleted at 1am using Lambda and EventBridge. Cost: ~$1,400/month (RI) + ~$100/month (nightly replica) + gp3 savings ~$50/month = ~$1,550/month. Savings: 63%.

B) Migrate to Aurora MySQL Serverless v2. Configure minimum ACU of 2 and maximum ACU of 16. During the day (15% CPU), Serverless scales to ~4 ACUs. During nightly reports, it scales to ~16 ACUs. Aurora Serverless pricing: ~$0.12/ACU-hour. Average cost: (4 ACU × 22 hours + 16 ACU × 2 hours) × 30 days × $0.12 = ~$432/month for compute + storage costs.

C) Downsize to db.r5.large (2 vCPU, 16 GB RAM) and accept degraded nightly report performance (4 hours instead of 2). Purchase a 3-year All Upfront RI. Migrate storage to gp3. Cost: ~$800/month. Savings: 81%.

D) Migrate to Amazon DynamoDB for the 90% key-value lookups (no code changes using DynamoDB's PartiQL for MySQL-compatible syntax). Keep a small RDS instance for the 10% complex reports. Total cost: DynamoDB on-demand ~$500/month + db.r6g.large RDS ~$600/month = ~$1,100/month.

---

### Question 58

A company processes financial transactions and needs to encrypt data at rest across multiple AWS services: S3 (100 TB), RDS (5 TB), EBS (50 TB across 500 volumes), DynamoDB (10 TB), and Kinesis Data Streams (500 shards). The security team requires: (1) all encryption must use customer-managed KMS keys, (2) each service must use a different KMS key for blast radius containment, (3) key rotation must occur annually with zero downtime, (4) the solution must support a maximum of 30,000 cryptographic API calls per second across all services, and (5) the total cost of KMS must not exceed $1,000/month. What is the MOST cost-effective key management approach?

A) Create 5 customer-managed symmetric KMS keys (one per service). Enable automatic annual key rotation on all keys (no downtime — AWS manages old and new key material, decryption uses old material transparently). For the 30,000 API calls/second concern: request a KMS quota increase (default is 5,500 req/s per key in us-east-1). Cost: 5 keys × $1/month = $5/month + API calls. At 30,000 req/s: 30,000 × 86,400 × 30 = 77.76 billion requests/month × $0.03/10,000 = $233,280/month. This EXCEEDS the $1,000 budget.

B) Create 5 customer-managed symmetric KMS keys. Enable automatic key rotation. To minimize API costs, implement envelope encryption everywhere: use the AWS Encryption SDK to generate data keys locally and only call KMS for `GenerateDataKey` and `Decrypt` operations (one KMS call per encryption/decryption session rather than per object). Cache data keys for up to 5 minutes using the KMS caching SDK. This reduces API calls from 30,000/s to approximately 100/s. Cost: 5 keys × $1/month = $5 + 100 req/s × 86,400 × 30 = 259.2M × $0.03/10,000 = $777/month. Total: ~$782/month.

C) Use AWS-managed keys (aws/s3, aws/rds, etc.) for all services. These are free and support automatic rotation. Use resource policies and IAM policies for access control instead of key policies.

D) Create a single customer-managed KMS key and use it across all services with key aliases to differentiate usage. Enable automatic rotation. Implement aggressive data key caching with 1-hour TTL. Cost: $1/month + minimal API calls. Use KMS key grants for per-service access control.

---

### Question 59

A company is evaluating the total cost of running a containerized application on AWS. The application requires 100 vCPUs and 200 GB RAM steady-state, with bursts to 300 vCPUs and 600 GB RAM for 4 hours daily. The options are: (1) ECS on EC2 with a mix of Reserved and On-Demand instances, (2) ECS on Fargate with a Compute Savings Plan, (3) EKS on EC2 with Spot for burst, and (4) EKS on Fargate. The evaluation must include ALL costs: compute, control plane, load balancing, logging, and monitoring. Which option has the LOWEST total 3-year cost for this workload profile?

A) ECS on EC2: Reserve c6g.4xlarge (16 vCPU, 32 GB RAM) × 7 instances = 112 vCPU, 224 GB (covers steady state). On-Demand c6g.4xlarge × 12 instances for 4-hour burst daily. 3-year RI (All Upfront): ~$7,500/instance × 7 = $52,500 upfront = ~$1,458/month. On-Demand burst: 12 × $0.544/hr × 4 hrs × 30 days = $783/month. ECS control plane: free. ALB: ~$50/month. CloudWatch: ~$200/month. Total: ~$2,491/month.

B) ECS on Fargate with Compute Savings Plan. Steady state: 100 vCPU, 200 GB = $0.04048/vCPU/hr × 100 + $0.004445/GB/hr × 200 = $4.937/hr. Burst: 200 additional vCPU, 400 GB for 4 hours/day. Monthly steady: $4.937 × 720 = $3,554. Monthly burst: (200 × $0.04048 + 400 × $0.004445) × 4 × 30 = $1,181. Total before SP: $4,735. With 3-year Compute SP (~52% off steady): steady $1,706 + burst $1,181 = $2,887/month. Add ECS (free) + ALB ($50) + CloudWatch ($200). Total: ~$3,137/month.

C) EKS on EC2 with Spot for burst. Reserve c6g.4xlarge × 7 for steady state (same as Option A): $1,458/month. Spot c6g.4xlarge (80% discount) × 12 for burst: 12 × $0.109/hr × 4 × 30 = $157/month. EKS control plane: $74/month. ALB: $50/month. CloudWatch + Container Insights: $300/month. Total: ~$2,039/month.

D) EKS on Fargate. Same compute costs as Option B Fargate ($4,735 before SP). 3-year Compute SP: $2,887/month. EKS control plane: $74/month. ALB: $50/month. CloudWatch: $200/month. Total: ~$3,211/month.

---

### Question 60

A company is migrating from an on-premises Hadoop cluster to AWS. The cluster processes 100 TB of data with: (1) batch ETL jobs running 16 hours/day, (2) interactive Hive/Presto queries running 8 hours/day during business hours, (3) a persistent HDFS storage layer, and (4) a 30-node cluster with 8 vCPU, 64 GB RAM each. The on-premises cost is $30,000/month (hardware depreciation + power + support). The CTO wants at least 30% cost savings on AWS. What is the MOST cost-effective AWS architecture?

A) Deploy a single persistent Amazon EMR cluster with 30 m5.4xlarge instances. Use Reserved Instances for the master and core nodes. Use EBS for HDFS. Run both batch and interactive workloads on the same cluster. Cost: ~$25,000/month with RIs. Savings: 17% (doesn't meet target).

B) Deploy two Amazon EMR clusters: a persistent cluster with 10 m6g.4xlarge (Graviton) core nodes for interactive queries (8 hours/day), and a transient cluster with 20 m6g.4xlarge core nodes + 10 m6g.4xlarge Spot task nodes for batch ETL (16 hours/day, terminated when done). Use Amazon S3 as the persistent storage layer (replacing HDFS). Use EMR Managed Scaling for both clusters. Interactive cluster cost: 10 × $0.616/hr × 8 hrs × 22 business days = ~$1,084/month. Batch cluster cost: 20 core × $0.616 × 16 hrs × 30 days + 10 Spot × $0.185 × 16 hrs × 30 days = ~$6,804/month. S3 storage: 100 TB × $0.023 = $2,300/month. EMR fees + other: ~$2,000/month. Total: ~$12,188/month. Savings: 59%.

C) Migrate entirely to AWS Glue for ETL processing and Amazon Athena for interactive queries. Store data in S3 in Parquet format. Use Glue crawlers for schema detection. Glue ETL cost: ~50 DPUs × 16 hours × $0.44/DPU-hour × 30 = $10,560/month. Athena queries: ~$5/TB scanned × estimated 10 TB/day × 22 days = $1,100/month. S3 storage: $2,300/month. Total: ~$13,960/month. Savings: 53%.

D) Use Amazon EMR on EKS for all workloads. Deploy an EKS cluster with Karpenter for auto-scaling. Run Spark and Presto on Kubernetes with spot nodes for batch processing. Use S3 as persistent storage. Use Graviton instances for best price-performance.

---

### Question 61

A company must build a real-time fraud detection system for their payment processing platform. The system processes 50,000 transactions per second at peak. Each transaction must be scored within 100ms. The fraud model uses 200 features derived from: (1) the current transaction data, (2) the customer's last 100 transactions (stored in DynamoDB), (3) aggregate spending patterns (pre-computed hourly, stored in ElastiCache), and (4) a blacklist of known fraudulent merchants (updated daily, 1 million entries). A fraud score above 0.85 must trigger a real-time block. What architecture meets the 100ms latency requirement at 50,000 TPS?

A) Use API Gateway as the entry point. A Lambda function retrieves customer history from DynamoDB, aggregate patterns from ElastiCache, and the merchant blacklist from a Lambda global variable (loaded at init, refreshed daily). The Lambda computes features and calls a SageMaker real-time endpoint for model inference. If fraud score > 0.85, the Lambda returns a block response. Configure Lambda with provisioned concurrency of 5,000 and 1 GB memory.

B) Deploy the fraud detection service on ECS Fargate behind an NLB. The service loads the merchant blacklist into local memory on startup. For each transaction, it performs: (1) parallel reads from DynamoDB (using DAX for sub-millisecond latency) and ElastiCache for customer history and aggregates, (2) feature computation locally, and (3) model inference using a locally-loaded TensorFlow Lite model (avoiding external ML service calls). Configure DAX with a t3.medium 3-node cluster. Deploy 50 Fargate tasks (2 vCPU, 4 GB) across 3 AZs behind the NLB.

C) Use Kinesis Data Streams for transaction ingestion. A Flink application on Amazon Managed Service for Apache Flink enriches transactions with DynamoDB and ElastiCache lookups, computes features, and calls a SageMaker multi-model endpoint for inference. Flink writes the fraud score back to a Kinesis stream consumed by the payment service.

D) Deploy the service on EC2 c6g.8xlarge instances in a cluster placement group. Load all reference data (blacklist, customer histories, aggregates) into an in-memory database (Redis) running on the same instances. Perform all lookups, feature computation, and model inference locally using a compiled ONNX model runtime.

---

### Question 62

A company wants to implement a CI/CD pipeline for their infrastructure-as-code (IaC) deployments across 50 AWS accounts and 5 Regions. Requirements: (1) all infrastructure changes must be reviewed in a PR before deployment, (2) changes to production must be approved by two senior engineers, (3) the pipeline must detect configuration drift and alert, (4) failed deployments must automatically roll back, (5) secrets used in IaC (database passwords, API keys) must not be visible in pipeline logs or state files, and (6) the pipeline must deploy to all 50 accounts within 2 hours. What is the BEST architecture?

A) Use AWS CodePipeline with a GitHub source stage. Configure CodeBuild for `terraform plan` on PR creation (results posted as PR comments). Require 2 approvals in GitHub for production PRs. Use CodePipeline manual approval actions for production deployments. Deploy using CodeBuild running `terraform apply` with cross-account IAM roles. Use Terraform Cloud for state management with state encryption. Store secrets in AWS Secrets Manager and reference them in Terraform using the `aws_secretsmanager_secret_version` data source. Detect drift using AWS Config rules. Deploy to accounts in parallel using CodePipeline parallel actions (10 accounts per action × 5 parallel).

B) Use GitHub Actions with OIDC federation for AWS authentication. Run `terraform plan` on PR and post results as PR comments. Require 2 GitHub approvals for the production environment. Use Terraform workspaces for each account/Region combination. Store state in S3 with DynamoDB locking and SSE-KMS encryption. Reference secrets from Secrets Manager in Terraform, and use `sensitive = true` on all secret outputs. Deploy using GitHub Actions matrix strategy (50 accounts × 5 Regions = 250 jobs, running 50 in parallel). Detect drift using `terraform plan -detailed-exitcode` on a scheduled workflow. For rollback, maintain the previous state and run `terraform apply` with the prior configuration on failure.

C) Use AWS CloudFormation StackSets with Organizations integration. Deploy templates from a central management account to all 50 accounts. Use CloudFormation change sets for review. Configure drift detection on a schedule. Use dynamic references to Secrets Manager for secrets. Implement a Step Functions workflow for production approval (2 approvers via email). Roll back failed deployments using CloudFormation's built-in rollback.

D) Use CDK Pipelines (based on CodePipeline) with a self-mutating pipeline. Deploy CDK stacks to all 50 accounts using the `Wave` construct for parallel deployment. Configure a manual approval step for production Waves. Use CDK's built-in `SecretValue.secretsManager()` for secrets. Deploy a drift-detection Lambda that runs CloudFormation drift detection weekly.

---

### Question 63

A company's AWS bill shows $15,000/month in data transfer costs. The breakdown is: (1) $5,000 for inter-AZ traffic within us-east-1 (500 TB at $0.01/GB per direction), (2) $4,000 for NAT Gateway processing (400 TB), (3) $3,000 for internet-facing data transfer out (35 TB), (4) $2,000 for S3 transfer to EC2 in the same Region (200 TB — this should be free, so why the cost?), and (5) $1,000 for VPC peering traffic between us-east-1 and eu-west-1. What combination of changes achieves the GREATEST cost reduction? (Select THREE.)

A) Investigate the $2,000 S3-to-EC2 cost. S3 to EC2 in the same Region IS free when using the S3 gateway VPC endpoint or public IP within the same Region. The cost likely indicates that traffic is routing through a NAT Gateway (which charges for data processing) or the EC2 instances are in a different Region than the S3 bucket. Fix: deploy an S3 gateway VPC endpoint (free) and ensure the S3 bucket and EC2 are in the same Region. This also reduces NAT Gateway costs. Savings: $2,000 (S3 cost) + portion of NAT Gateway savings.

B) Reduce inter-AZ traffic by deploying services that communicate frequently in the same AZ using AZ-affinity routing. Implement gRPC with compression for inter-service communication (50-70% payload reduction). Where possible, use AZ-local ElastiCache read replicas to serve requests within the same AZ. Potential savings: 30-50% of inter-AZ costs = $1,500-2,500/month.

C) Replace the NAT Gateway with NAT instances (t3.nano fleet) for significant cost reduction. NAT instances don't charge per-GB data processing fees.

D) Deploy S3 gateway VPC endpoints and interface VPC endpoints for other AWS services (STS, CloudWatch, ECR, etc.) to route traffic away from the NAT Gateway. Analyze the 400 TB of NAT Gateway traffic to identify what services it's destined for. If 70% is to AWS services: endpoints save $2,800/month on NAT processing.

E) Use CloudFront for the $3,000 internet-facing traffic. CloudFront's pricing is similar per-GB but offers a Security Savings Bundle (up to 30% savings with commitment). More importantly, CloudFront serves content from edge caches, reducing total origin-to-internet data transfer. If cache hit ratio is 70%, actual origin transfer drops from 35 TB to 10.5 TB. Savings: reduced internet transfer + CloudFront bundle = ~$1,500-2,000/month.

---

### Question 64

A company runs a SaaS platform and wants to implement a chargeback model that accurately allocates AWS costs to each of their 100 tenants. Each tenant's resources are deployed in a shared AWS account using shared infrastructure (ECS cluster, Aurora database, S3 bucket, ElastiCache). The tenants have different tiers: Basic (50 tenants), Professional (30 tenants), Enterprise (20 tenants). Requirements: (1) compute costs must be allocated based on actual vCPU-seconds consumed per tenant, (2) database costs must be split based on storage + query volume per tenant, (3) S3 costs must be allocated by prefix size per tenant, (4) the allocation system must produce monthly reports per tenant, and (5) the system must detect cost anomalies per tenant (e.g., a Basic tenant consuming Enterprise-level resources). What is the MOST accurate cost allocation architecture?

A) Tag all resources with `tenant_id` using AWS resource tags. Enable Cost Allocation Tags and use AWS Cost Explorer to generate per-tenant reports. Use AWS Budgets for anomaly detection. For shared resources like Aurora and ElastiCache, allocate costs proportionally based on the number of tenants in each tier.

B) Implement a custom metering system: (1) For ECS, use Container Insights with custom metrics to track CPU-seconds per container, tagged by tenant. A Lambda function aggregates these metrics daily and stores in a cost allocation DynamoDB table. (2) For Aurora, enable Performance Insights and query `pg_stat_statements` to calculate per-tenant query cost based on CPU time and rows scanned. Track per-tenant storage using a nightly S3 Inventory report filtered by tenant prefix. (3) For ElastiCache, use Redis SLOWLOG and MEMORY USAGE commands via a monitoring Lambda to estimate per-tenant cache utilization. (4) Combine all metrics with AWS Cost and Usage Reports (CUR) in a cost allocation Athena table. Generate monthly reports using Amazon QuickSight. (5) Use CloudWatch Anomaly Detection on per-tenant cost metrics for anomaly alerts.

C) Deploy each tenant in a separate ECS service, Aurora database (using a dedicated instance per tenant in a shared cluster via Aurora cloning), and S3 prefix. Tag every resource with `tenant_id`. Enable AWS Cost Allocation Tags and CUR. Use AWS Cost Categories to create rules mapping tags to tenants. Generate reports from CUR using Athena.

D) Use AWS Marketplace Metering Service to track per-tenant usage. Publish custom metering records for compute, database, and storage usage. Use the Marketplace API to generate tenant billing reports. Implement threshold-based anomaly detection in the metering Lambda.

---

### Question 65

A company is performing a comprehensive cost optimization review of their AWS environment. They have the following unused or underutilized resources identified by AWS Trusted Advisor and Cost Explorer: (1) 25 unattached EBS volumes (10 TB total, gp2), (2) 10 Elastic IP addresses not associated with running instances, (3) 5 idle RDS instances with 0 connections for 30+ days, (4) 3 NAT Gateways in VPCs with no private subnet routes, (5) an unused Direct Connect connection (1 Gbps dedicated), (6) 100 old EBS snapshots (50 TB) from instances terminated 2+ years ago, (7) 15 unused Elastic Load Balancers with no registered targets, (8) a Redshift cluster (3 dc2.large nodes) with no queries for 60 days, and (9) 20 CloudWatch dashboards with custom widgets that no one views. Assuming standard us-east-1 pricing, estimate the monthly waste and prioritize the top 5 cleanup actions by dollar impact. Which resources represent the HIGHEST monthly waste? (Select THREE.)

A) The unused Direct Connect connection: 1 Gbps dedicated port = $0.30/hour × 720 hours = $216/month port fee. Plus the cross-connect fee from the colocation provider (~$200-500/month). Total: ~$416-716/month.

B) The 5 idle RDS instances: Assuming db.r5.large Multi-AZ = $0.48/hour × 720 × 5 = $1,728/month. Plus storage costs for associated EBS. Total: ~$1,900/month.

C) The Redshift cluster: 3 dc2.large nodes × $0.25/hour × 720 = $540/month.

D) The 25 unattached EBS volumes: 10 TB gp2 × $0.10/GB = $1,000/month.

E) The 100 old EBS snapshots: 50 TB × $0.05/GB = $2,500/month.

F) The 15 idle ELBs: 15 × ~$18/month (ALB fixed cost) = $270/month. Plus the 10 unused EIPs: 10 × $3.60/month (since April 2024 pricing change) = $36/month. And 3 unused NAT Gateways: 3 × $32.40/month = $97.20/month. Combined: ~$403/month.

---

## Answer Key

### Question 1
**Correct Answer:** C

**Explanation:** Option C is the most secure approach. By creating per-account KMS keys with `kms:ViaService` conditions restricted to S3, it ensures the keys can only be used through S3 — preventing direct API decryption calls even by the Lambda roles. The central security account is explicitly denied `kms:Decrypt` and `kms:Encrypt` while retaining audit and emergency disable capabilities, perfectly matching the "audit and disable but cannot decrypt" requirement. Option A shares key metadata via RAM but doesn't include the `kms:ViaService` condition, leaving a vector for direct API decryption. Option B's single key in the security account violates the principle that the security account must NOT be able to decrypt — as key administrators in that account could potentially modify the key policy to grant themselves decrypt access. Option D uses `*` principal with conditions, which is overly broad and doesn't provide the per-Lambda-role restriction required.

---

### Question 2
**Correct Answer:** B, C, D

**Explanation:** Option B addresses requirements 1 (customer-managed KMS encryption for RDS), 4 (SSL/TLS enforcement with `rds.force_ssl=1`), and 2 (tokenization using the Encryption SDK within ECS). Option C addresses requirement 3 (migrating to SSO with MFA and CloudTrail logging) and requirement 5 (SCP denying actions outside us-east-1). Option D addresses network security between ECS and RDS (security groups), and provides additional logging via VPC Flow Logs and Region restriction for EC2. Option A is incorrect because it uses AWS-managed keys instead of customer-managed keys, violating requirement 1. Option E is a monitoring/detection control, not a preventive control — it detects non-compliance but doesn't address the actual requirements.

---

### Question 3
**Correct Answer:** A

**Explanation:** Amazon VPC Lattice is the ideal service for this zero-trust architecture. It provides service-to-service connectivity with built-in IAM-based auth policies, supports tens of thousands of concurrent connections with minimal added latency, and allows instant access revocation by updating auth policies. It eliminates the PrivateLink 50-endpoint concern entirely because Lattice uses a service network model, not individual endpoints. Option B's PrivateLink approach creates N×N complexity with 15 services and would require careful management to avoid the 50-endpoint limit. Option C's ALB-per-service approach adds significant operational overhead and ALB costs. Revoking ACM certificates within 30 seconds is also not reliable — CRL propagation can take longer. Option D's App Mesh provides traffic management but doesn't natively provide the IAM-based network-layer authentication and the 30-second revocation guarantee that Lattice's auth policies deliver.

---

### Question 4
**Correct Answer:** A

**Explanation:** Option A correctly addresses all five requirements. S3 Object Lock in Compliance mode ensures true immutability — no one, including the root user, can delete or modify objects during the 7-year retention period (Governance mode in Option B allows users with `s3:BypassGovernanceRetention` permission to override). CRR to a second GovCloud Region satisfies the Regional survivability requirement. The EventBridge-to-Step Functions workflow provides structured, reliable automated containment within 5 minutes for GuardDuty HIGH findings, with better error handling than a direct Lambda invocation (Option B's SNS-to-Lambda pattern). Cross-account IAM roles with `MaxSessionDuration` of 3600 seconds satisfy the 1-hour credential requirement. Option B fails on immutability (Governance mode), Regional resilience (same-Region replication), and containment architecture (SSM for quarantining EC2 is less comprehensive). Option C is close but using cross-account IAM roles from member accounts for centralized Lambda invocation adds complexity. Option D fails on immutability (MFA Delete is not Object Lock) and Regional resilience (single Region).

---

### Question 5
**Correct Answer:** A, C

**Explanation:** Option A fixes vulnerability 1 (ALB bypass) using the proven custom-header pattern with rotation via Secrets Manager. The Lambda-based rotation keeps the secret value synchronized between CloudFront and the ALB rule. Option C fixes vulnerability 1 (CloudFront managed prefix list restricts ALB access), vulnerability 2 (VPC endpoints replace NAT Gateway, eliminating the data exfiltration path while maintaining AWS service access), and vulnerability 3 (Secrets Manager with automatic rotation for Aurora MySQL credentials). Together, A and C provide defense-in-depth for the ALB (both header validation AND prefix list restriction), eliminate internet egress, and secure database credentials. Option B is partially correct but duplicating WAF on both CloudFront and ALB is unnecessary and adds cost — the prefix list already restricts ALB access. Option D is incorrect because CloudFront cannot use PrivateLink to connect to an ALB in a private subnet; CloudFront needs an internet-facing origin. Option E is incorrect because CloudFront OAC with SigV4 is supported for S3 origins, not ALB origins.

---

### Question 6
**Correct Answer:** C

**Explanation:** Option C provides the most complete and scalable solution. A single Cognito User Pool with multiple SAML IdPs (one per tenant) avoids creating per-tenant IAM roles. The Pre Token Generation Lambda trigger injects the `tenant_id` as a session tag, enabling ABAC with a single IAM role that uses `${aws:PrincipalTag/tenant_id}` for S3 prefix restriction. The 15-minute token expiration and CloudTrail integration with Cognito identity complete the requirements. Option A creates separate User Pools per tenant, which is operationally complex at 500 tenants and doesn't scale well. Option B uses IAM Identity Center, which is designed for workforce identity, not customer-facing multi-tenant applications — it doesn't natively support 500 external SAML IdPs. Option D's custom token vending machine works but requires building and maintaining custom infrastructure (API Gateway, Lambda), whereas Cognito provides this out of the box with additional features like token refresh and built-in SAML federation handling.

---

### Question 7
**Correct Answer:** A

**Explanation:** This is a gotcha question. In-transit encryption and AUTH cannot be enabled on an existing ElastiCache Redis cluster — they must be configured at cluster creation time (despite what Option C suggests). Even with ElastiCache 7.0+, enabling TLS on an existing cluster-mode-enabled setup requires creating a new cluster. Option A correctly creates a new cluster with all security features enabled from the start and uses application-level dual-write for zero-downtime migration. Option B is incorrect because modifying the existing cluster to enable in-transit encryption causes downtime and is not supported for cluster-mode-enabled clusters without recreation. Option C's claim that in-transit encryption can be enabled without downtime is misleading — while ElastiCache 7.0 added TLS migration support for standalone replication groups, the question specifies cluster mode enabled with 6 shards, which has different behavior. Option D incorrectly uses Global Datastore, which is designed for cross-Region replication, not within-Region migration, and adds unnecessary complexity.

---

### Question 8
**Correct Answer:** C

**Explanation:** Option C provides the most complete and architecturally sound solution. The delegated administrator with auto-enable handles requirement 5. Custom Config rules deployed via StackSets integrate with Security Hub for company-specific compliance (requirement 2). EventBridge rules in the delegated admin account filter by `AwsAccountId` for sandbox suppression (requirement 3). A separate EventBridge rule on `Security Hub Findings - Imported` events with CRITICAL severity triggers Lambda for Jira integration (requirement 4). This approach uses native Security Hub event patterns and scales well. Option A is mostly correct but uses `BatchImportFindings` incorrectly — Config rule findings flow into Security Hub automatically through the Config integration, not via manual API calls. Option B uses custom actions, which require manual triggering, not automatic — they're designed for analyst-initiated workflows, not automated responses. Option D doesn't use the delegated admin model and uses SNS instead of EventBridge, losing the rich event filtering capability needed for efficient sandbox suppression.

---

### Question 9
**Correct Answer:** B

**Explanation:** Option B minimizes latency by avoiding the additional CloudFront hop while meeting all requirements. WAF attached directly to API Gateway handles SQL injection and XSS protection and geo-blocking. The Lambda authorizer with caching validates OAuth tokens once and caches the result, amortizing the auth latency across requests. API Gateway's native usage plans with API keys handle per-customer rate limiting at the gateway level. Request validators with JSON schemas eliminate the need for backend validation. Option A adds CloudFront as an additional hop, and Lambda@Edge for OAuth validation runs at edge locations where access to the token validation endpoint might have higher latency. Option C uses CloudFront Functions for OAuth validation, but CloudFront Functions have a 2ms execution time limit and 10KB package size, making JWT validation with custom claims nearly impossible. Option D switches to HTTP API which doesn't support WAF attachment (WAF can only be attached to REST APIs), failing requirement 4.

---

### Question 10
**Correct Answer:** B

**Explanation:** Option B meets all five requirements with the minimum set of changes. S3 Versioning + Object Lock in Compliance mode ensures no one (including root) can delete/overwrite objects for 10 years (requirement 3). Lifecycle rules transition to Standard-IA (cost savings for the first 2 years with retrievable data) and Glacier Flexible Retrieval after 2 years (4-hour retrieval, meeting requirement 1), with potential Deep Archive after 5 years for additional savings. CloudTrail data events for the bucket provide a tamper-detection audit trail — any attempt to modify objects is logged, and Athena queries can verify compliance quarterly (requirement 4). Option A uses Glacier Flexible Retrieval after 2 years (correct) but S3 Inventory for tamper detection is less reliable than CloudTrail data events — inventory only shows what exists, not what was attempted. Option C uses Governance mode, which doesn't meet requirement 3 (users with bypass permissions can delete). Option D's Intelligent-Tiering with Archive tiers doesn't guarantee the 4-hour retrieval SLA for the first 2 years — the Archive Access tier has 3-5 hour retrieval, which could exceed the 4-hour requirement.

---

### Question 11
**Correct Answer:** B

**Explanation:** Signed cookies are the correct mechanism for HLS streaming because they work across all segments and thumbnails within a path without requiring individual signed URLs per segment (requirement 5). A key group with two public keys enables zero-downtime key rotation — add the new key, update the signing application, then remove the old key. Existing sessions using the old key remain valid as long as it's in the key group (requirement 6). Geo-restriction per distribution handles regional content licensing (requirement 3). Origin Shield consolidates origin requests from all edge locations through a single Regional cache, dramatically reducing origin load even with 100,000 concurrent viewers (requirement 4). OAC prevents direct S3 access. Option A uses signed URLs, which would require signing every HLS segment URL individually — adding latency and complexity for live streaming. Option C's Lambda@Edge adds per-request processing overhead and cost at 100,000 concurrent viewers, and a custom JWT-based auth doesn't leverage CloudFront's native signing capabilities. Option D's field-level encryption is designed for protecting sensitive form data, not content access control.

---

### Question 12
**Correct Answer:** C

**Explanation:** Option C provides the most comprehensive control framework. The SCP at the root OU prevents external role assumption by checking `aws:PrincipalOrgID`, prevents CloudTrail and GuardDuty modifications, and restricts Sandbox instance types. Crucially, the Lambda-backed EventBridge rule that dynamically updates the SCP from the DynamoDB exception table allows approved third-party integrations (requirement 2) while maintaining the deny-by-default posture. SCPs automatically apply to new accounts via OU inheritance (requirement 5). Option A's approach of adding specific external account IDs to SCP conditions works but is static — it requires manual SCP updates for each new third-party, doesn't read from DynamoDB, and doesn't meet the "tracked in a DynamoDB table" requirement. Option B's attempt to inspect `iam:PolicyDocument` in SCP conditions is not supported — SCPs cannot evaluate the contents of IAM policy documents being created. Option D's permission boundary approach doesn't work at scale because permission boundaries must be attached to every role/user and can be bypassed by creating new principals without the boundary.

---

### Question 13
**Correct Answer:** A

**Explanation:** Option A correctly identifies why daily Macie jobs are insufficient (10-minute detection requirement vs 24-hour batch cycle) and provides the most operationally complete solution. Automated sensitive data discovery runs continuously, meeting the time requirement. Custom data identifiers for genomic patterns extend Macie's built-in PII/PHI detection. The Step Functions workflow provides a complete quarantine-review-disposition lifecycle with a callback pattern that pauses execution until the compliance team completes their review in ServiceNow. Option B uses S3 Batch Operations for quarantine, which is a batch-oriented service not designed for real-time individual file moves — it introduces unnecessary latency and complexity for moving individual files. Option C is incorrect — running Macie classification jobs every 10 minutes would be extremely expensive and is not how Macie is designed to operate; it would also hit API rate limits. Option D's approach of using Comprehend Medical per-object is valid but significantly more expensive at 5 TB/day scale compared to Macie's automated discovery, and requires building a custom ML model for genomic identifiers.

---

### Question 14
**Correct Answer:** A

**Explanation:** Option A is the only architecture that satisfies all six requirements simultaneously. Aurora Global Database provides ~1-second RPO, exceeding the 5-minute database requirement. MSK with MirrorMaker 2.0 provides real-time topic replication for zero RPO on in-flight events. ElastiCache Global Datastore replicates session data. A pre-deployed but scaled-down EKS cluster achieves 15-minute RTO because infrastructure is already provisioned — only scaling is needed. EU Region satisfies GDPR. Cost is controlled: a minimum-replica EKS cluster, small Aurora secondary (no compute charges for storage-only), and standby MSK cluster cost well under $15,000/month. DR testing uses a separate domain pointed at the DR Region. Option B fails RPO for events — replaying from S3 introduces minutes of lag. Recreating MSK and restoring ElastiCache from snapshots easily exceeds the 15-minute RTO. Option C introduces unnecessary architecture changes (Kinesis instead of MSK) and Karpenter from-zero scaling may not meet 15-minute RTO for 200 microservices. Option D's Aurora automated backups provide 5-minute RPO (at the limit) but restoring from backup takes much longer than promoting a Global Database secondary, failing RTO.

---

### Question 15
**Correct Answer:** A

**Explanation:** The SNS fan-out pattern to four parallel SQS queues with dedicated Lambda consumers is the most reliable architecture for the latency requirement. By separating each processing step into its own queue and consumer, the pipeline achieves true parallelism where independent steps (thumbnail + metadata can run in parallel with Rekognition). Lambda's concurrent execution model scales instantly to handle 250,000/min bursts with reserved concurrency. Individual DLQs per queue isolate failures without blocking the pipeline. The 60-second visibility timeout prevents duplicate processing while allowing retry. Option B's Step Functions Express Workflows have a 5-minute execution limit and 100,000 concurrent execution limit per account (would need an increase). The 30-second SLA under 250K/min burst is tight for Step Functions' overhead. Option C's sequential processing within a single Lambda means each upload takes the sum of all step durations — Rekognition alone takes several seconds, making 30-second end-to-end difficult. Option D's Standard Workflow is too slow for 30-second processing (Standard workflows charge per state transition and have higher latency than Express).

---

### Question 16
**Correct Answer:** A

**Explanation:** Option A provides the optimal balance of real-time processing, cost, and query performance. Kinesis Data Streams with 100 shards handles 100,000 records/second (20,000 records/second per shard × 5 records/shard). Apache Flink provides stateful, low-latency geofence detection within the 10-second requirement. Amazon Timestream's memory store provides sub-second query latency for the 30-day ML window, and its magnetic store handles the 3-year retention at much lower cost. Timestream natively handles time-series data with SQL support and Grafana integration for real-time dashboards. Monthly cost stays within $50,000 given the efficient data pipeline. Option B's DynamoDB approach would be extremely expensive at 20,000 writes/second and doesn't provide native time-series query optimization. Option C uses OpenSearch, which is operationally heavier and more expensive for pure time-series workloads compared to Timestream. Option D's Firehose buffering for 60 seconds violates the 10-second geofence detection requirement, and Athena is not suitable for real-time queries.

---

### Question 17
**Correct Answer:** B

**Explanation:** Option B best addresses all six requirements. Glue DynamicFrames handle schema flexibility without requiring a fixed schema upfront, critical for handling varying partner formats and schema evolution (requirement 6). The DynamoDB mapping table for column name translation is a clean, maintainable approach to standardization (requirement 1). A custom Glue transform calling a Lambda tokenization service separates the tokenization concern and allows independent scaling (requirement 2). Lake Formation with Glue Data Catalog provides built-in data lineage tracking (requirement 3). Glue error handling with dead-letter S3 prefix quarantines failed records (requirement 5). Glue bookmarks enable incremental processing within the 4-hour window (requirement 4). Option A's approach of using Crawlers for schema detection is unreliable for varying column names (it would create different table definitions per partner). Option C's Apache Atlas adds significant operational overhead compared to Lake Formation's built-in lineage. Option D's Lambda-based approach would struggle with the 500 GB daily volume due to Lambda's 15-minute timeout and memory limits — even with per-partner splitting, large partners could exceed Lambda's capabilities.

---

### Question 18
**Correct Answer:** A, B

**Explanation:** Option A directly addresses failures 1, 2, and 3. Service limit increases prevent hitting the EC2 ceiling. ABIS with multiple instance families provides a larger pool of available capacity. Pre-baked AMIs with fast snapshot restore eliminate the 20 GB asset loading time, and extended health check grace periods prevent NLB from failing instances still starting up. Option B addresses failure 4 with DynamoDB on-demand capacity, and failure 3 with Route 53 Application Recovery Controller (ARC), which only routes traffic to Regions confirmed ready via readiness checks — preventing the surge-before-scaling problem. Option C's warm pools and capacity reservations partially address the scaling issue but EFS for game assets adds latency compared to local NVMe/EBS, and it doesn't address the Route 53 routing issue (failure 3). Option D's GameLift FleetIQ is designed for specific gaming server patterns and may not support the full microservice architecture. Option E's Global Accelerator provides better failover than Route 53 but predictive scaling based on historical patterns wouldn't help for an unprecedented launch surge.

---

### Question 19
**Correct Answer:** A

**Explanation:** Option A addresses all four issues comprehensively. Origin Shield consolidates requests from multiple edge locations through a single Regional cache, dramatically improving the manifest cache hit ratio (from 30% to potentially 90%+) since all edge locations share the same cache instead of each independently requesting from the origin (fixes issue 1 and partially 2). A 1-second TTL (half the 2-second update interval) ensures reasonable freshness while improving hit ratio — even a 1-second TTL significantly reduces origin load compared to 0-second TTL. Hash-based prefix distribution across S3 prefixes eliminates the 5,500 GET/s per-prefix limit causing 503 errors (fixes issue 2). CloudFront private pricing reduces data transfer costs significantly at this scale (fixes issue 4). ECS target tracking ensures enough origin capacity (fixes issue 1). Option B's API Gateway replacement adds complexity without solving the caching problem. Option C's Lambda@Edge for manifest generation adds compute cost at 5M concurrent viewers and doesn't address the S3 issue. Option D's 5-second TTL would make manifests too stale for live streaming (segments are 2 seconds).

---

### Question 20
**Correct Answer:** B

**Explanation:** Option B provides the closest to exactly-once processing at the required scale. Kinesis Data Streams handles the 50,000/s burst with 50 shards. The idempotency pattern using DynamoDB (check-then-process) combined with DynamoDB transactions ensures that even if a Lambda function retries a batch, previously processed trades are skipped. `BisectBatchOnFunctionError` ensures that a single failed record doesn't block the entire batch. The partition key (trade ID) ensures ordering per trade. Option A's SQS FIFO with content-based deduplication only prevents duplicate sends within a 5-minute window, and FIFO queues in high-throughput mode still have per-message-group ordering constraints that could create bottlenecks. More critically, FIFO's 70,000 messages/second is a receive limit, and with batch processing, throughput per message group is still 300 msg/s. Option C's Kafka exactly-once semantics work well but require managing the MSK cluster and consumer group, adding operational overhead. Also, S3 puts within a Kafka transaction are not natively transactional. Option D's SQS Standard queue doesn't guarantee exactly-once delivery — even with idempotency, the DynamoDB check-then-process pattern has a race condition window without transactions.

---

### Question 21
**Correct Answer:** A

**Explanation:** Option A correctly uses AWS Outposts racks, which provide a full AWS experience at each store location. Local EKS on Outposts supports the POS application running during disconnection. RDS on Outposts supports local persistent storage with encryption using locally cached KMS keys (Outposts cache data keys for offline use). DataSync with Store and Forward mode queues data locally during disconnection and syncs when connectivity is restored, preventing data loss. Systems Manager with rate control of 500 concurrent deployments updates all 5,000 stores within 4 hours (10 batches × ~20 minutes each). Kinesis Data Firehose in the central Region aggregates data for analytics within the 10-minute staleness requirement. Option B's Outposts servers (1U/2U) have limited compute capacity compared to racks and may not support RDS for local database storage. Using SQS for sync is viable but less robust than DataSync's built-in retry and conflict handling. Option C's Snowcone is designed for edge computing and data collection at remote sites but lacks the computational power and AWS service breadth needed for a full POS system. Option D's Local Zones are metro-area extensions of Regions, not store-level deployments, and require internet connectivity — they don't support the 72-hour offline requirement.

---

### Question 22
**Correct Answer:** C

**Explanation:** Option C provides the optimal cost reduction strategy. S3 Intelligent-Tiering for hot-docs (with only Frequent/Infrequent tiers) provides sub-100ms access while automatically optimizing between frequent and infrequent access. For warm-docs, enabling all Intelligent-Tiering tiers (including Archive Instant) ensures automatic tier optimization with the crucial benefit that objects automatically return to Frequent Access when accessed unexpectedly (handling requirement 5 for access pattern changes). Cold-docs on Glacier Flexible Retrieval provides 12-hour retrieval at very low cost. CRR with matching storage classes ensures DR at equivalent costs. Cost estimate: hot-docs IT ~$1,150/month, warm-docs IT ~$2,250/month, cold-docs Glacier ~$1,080/month. Total storage: ~$4,480/month vs current $12,500/month = 64% savings (exceeds 40% target). Option B's Deep Archive for cold-docs only supports 12-hour retrieval with standard retrieval, but bulk retrieval can take up to 48 hours. Option A doesn't leverage Intelligent-Tiering's ability to handle access pattern changes for warm docs. Option D's Express One Zone is single-AZ and doesn't support CRR, violating requirement 4.

---

### Question 23
**Correct Answer:** A

**Explanation:** AWS Batch with Spot Instances is the most cost-effective solution. The key factors: simulations are idempotent (can restart on Spot interruption), run 6-18 hours (tolerant of interruption), and have a 72-hour deadline (buffer for retries). `SPOT_PRICE_CAPACITY_OPTIMIZED` allocation across diverse instance types (r5, r6g, r6i, r5a, x2gd) maximizes availability and minimizes interruption risk. With Spot discounts of 60-70% for memory-optimized instances, the cost drops from $85,000 to approximately $25,000-30,000/month (65-70% savings). AWS Batch manages the job queue, retries, and instance lifecycle with minimal operational overhead. S3 for I/O is the most cost-effective storage. Option B (EKS + Karpenter) is viable but adds Kubernetes operational complexity and EKS control plane costs. Option C's ParallelCluster with checkpointing adds complexity; if Spot is interrupted near the end of a long simulation, resuming from a 1-hour-old checkpoint is only slightly better than restarting since the simulations are idempotent. The max price of 50% limits capacity diversity. Option D is infeasible — Lambda's 15-minute timeout and 10 GB memory cannot handle the 256 GB RAM, 64 vCPU requirement.

---

### Question 24
**Correct Answer:** A

**Explanation:** Option A addresses all four failure modes with configurations that achieve <30-second recovery. ALB health checks with 5-second interval and 2-failure threshold detect unhealthy targets in 10 seconds (5s × 2 failures). Cross-Zone Load Balancing ensures immediate redistribution to healthy AZs. The warm pool with pre-initialized instances provides replacement capacity within 60 seconds (already initialized, just needs to start and register). Aurora Multi-AZ with 2 readable standbys and tier-0 failover priority provides database failover in ~10 seconds (faster than standard Multi-AZ). ElastiCache for Redis Multi-AZ prevents session loss during AZ failure. Option B's 10-second interval with 3 thresholds means 30 seconds just for detection, plus launch and registration time. RDS Proxy helps with connection management but doesn't speed up Aurora failover. Option C's NLB doesn't provide application-layer health checks, and manual replica promotion is far too slow. Sticky sessions would make the AZ failure worse. Option D's ECS Fargate replacement is faster than EC2 but Aurora Serverless v2 doesn't provide faster failover than Multi-AZ with readable standbys.

---

### Question 25
**Correct Answer:** A

**Explanation:** Option A solves the core problem — Rekognition Video's stream processing cannot keep up at 10x real-time for 500 streams (it would need 5,000x the processing power of real-time). The key insight is to extract frames at a reduced rate (1 FPS instead of 30 FPS) and use Rekognition's image API (`DetectLabels`), which returns results in 1-2 seconds per image. At 500 cameras × 1 FPS = 500 images/second, this is well within Rekognition's image API throughput. Lambda provides elastic scaling for the parallel processing, and ECS Fargate handles the frame extraction from Kinesis Video Streams. OpenSearch provides near-real-time indexing (<1 second) for the sub-5-second searchability requirement. Option B's custom model approach works but SageMaker real-time endpoints for 500 concurrent streams require significant provisioning and are more expensive than Rekognition's pay-per-image pricing. Option C's async video API (`StartLabelDetection`) is a batch operation that takes minutes to hours, not meeting the 5-second searchability requirement. Option D's MSK for video ingestion adds unnecessary complexity over Kinesis Video Streams, which is purpose-built for video.

---

### Question 26
**Correct Answer:** A

**Explanation:** Option A provides the correct phased migration sequence with zero downtime. Phase 1 uses DMS with CDC for live database migration — the monolith continues writing to local PostgreSQL while DMS replicates to Aurora in real-time, ensuring zero data loss. Phase 2 moves to EFS (not S3) because EFS provides a POSIX file system interface that requires minimal application changes compared to S3 (which requires API changes). Phase 3 creates multiple instances behind an ALB. Phase 4 uses Route 53 weighted routing for gradual traffic migration, allowing rollback if issues arise. Option B's pg_dump approach requires a maintenance window (downtime), violating the zero-downtime requirement. Using S3 requires application code changes. Option C's containerization adds unnecessary migration complexity — the requirement is to make the monolith highly available, not to modernize it. Also, stopping DMS and cutting over in the same phase creates a risk of data loss. Option D's approach of splitting reads and writes between old and new systems creates data consistency issues that are difficult to manage without application changes.

---

### Question 27
**Correct Answer:** A

**Explanation:** AWS DataSync is purpose-built for this use case. DataSync agents at each depot provide: built-in network resilience with automatic retry and bandwidth management, data verification via checksums, encryption in transit (TLS) and support for SSE-S3 at rest, bandwidth throttling configurable per depot (100 Mbps to 1 Gbps), and task scheduling with priority control. Separate DataSync tasks for telemetry logs (higher priority) ensure they're uploaded first. S3 Transfer Acceleration optimizes the upload path for distant depots. Monthly costs stay within $50,000 as DataSync charges per GB transferred ($0.0125/GB). At 500 vehicles × 2 TB = 1 PB/month × $0.0125 = $12,500/month for DataSync. Option B's custom upload application requires development and maintenance of retry logic, bandwidth management, and scheduling — operational overhead that DataSync eliminates. Option C's Snowball Edge solution introduces multi-day latency from shipping, violating the 6-hour availability requirement for most vehicles. Option D's Storage Gateway is designed for hybrid cloud access patterns, not bulk data transfer — its cache would need to be enormous (2 TB × vehicles per depot) and NFS performance would be a bottleneck.

---

### Question 28
**Correct Answer:** A

**Explanation:** Option A addresses all four observed issues with the optimal serverless patterns. The SQS buffering pattern (API Gateway → SQS → Lambda) decouples API requests from processing, eliminating 429 errors — API Gateway writes directly to SQS using a service integration (no Lambda needed for ingestion), and SQS absorbs any burst. Lambda processes asynchronously from the queue with 3,000 reserved concurrency. DynamoDB on-demand mode eliminates write throttling by automatically scaling capacity. SQS visibility timeout at 6x Lambda timeout prevents message loss during processing. The DLQ with `maxReceiveCount` of 5 ensures no message loss. The Retry-After header with 429 responses enables client-side backoff for any remaining throttling. Option B's approaches are all valid individually but don't address the fundamental problem — synchronous API-to-Lambda processing will still hit concurrency limits under 5x bursts. Option C's VPC deployment with NAT Gateway adds latency and cost, and FIFO queues have lower throughput limits. Option D replaces the serverless architecture entirely, adding infrastructure management overhead.

---

### Question 29
**Correct Answer:** A, B, C

**Explanation:** The total latency budget is: 400ms (network) + 200ms (database reads) + 100ms (cache misses) + 100ms (payment API) = 800ms. Target is 250ms, so we need to eliminate ~550ms. Option A eliminates 200ms by routing reads to the local Aurora replica. Option B eliminates 400ms network RTT by serving read requests from a local EKS cluster. Option C eliminates 100ms by using CloudFront KeyValueStore (a low-latency key-value store at CloudFront edge locations) for personalized content generation, avoiding cache misses. Combined: 800ms - 200ms - 400ms - 100ms = 100ms (under 250ms target). Option D's approach of an eu-west-1 API Gateway for payment APIs would save 100ms, but we already achieve the target with A+B+C, and D requires maintaining a separate API Gateway. Option E's ElastiCache replication would help but is partially redundant with the Aurora read replica — cached data returns faster than Aurora queries, but the Aurora replica already handles the 200ms issue. The 30-second TTL could serve stale data during the window, which may not be acceptable for financial data.

---

### Question 30
**Correct Answer:** A, B

**Explanation:** Option A addresses requirements 1 and 5. Dedicated Host with host recovery ensures the instance restarts on new hardware within the same AZ if the host fails (typically within 5 minutes). The CloudWatch auto-recovery alarm on `StatusCheckFailed_System` provides additional protection. Dedicated Host satisfies the licensing compliance requirement for dedicated tenancy on a specific host. Option B addresses requirements 2, 3, and 4. AWS Backint Agent for SAP HANA provides native SAP-aware backups to S3 with continuous log backups (15-minute RPO for AZ protection). S3 CRR copies backups to the DR Region (1-hour RPO achieved through the replication lag plus backup frequency). AWS Backup's 7-day retention with cross-Region copy enables point-in-time restoration. Option C's SAP HANA System Replication (HSR) would work but deploying active instances in two AZs and a DR Region is significantly more expensive than the backup-based approach, and the question asks for the combination that provides ALL protections — not the highest availability. Option D's ASG with Dedicated Host affinity is complex and doesn't reliably provide the 5-minute recovery SLA. Option E's DRS is not optimized for SAP HANA workloads and doesn't provide SAP-aware backup/restore.

---

### Question 31
**Correct Answer:** A

**Explanation:** The bottleneck is clear: 30-40 Redis calls per bid evaluation × 0.5ms per call = 15-20ms of network latency alone. With additional processing time, hitting 80ms p99 is expected. The solution is to eliminate the network round trips entirely by loading the 2 GB campaign dataset into local application memory. c5.4xlarge instances have 32 GB RAM, easily accommodating the 2 GB dataset with room for the application. Local memory access is nanosecond-level (1000x faster than the 0.5ms Redis calls). Refreshing every 5 minutes via SNS subscription ensures campaign data is current. This is a well-known pattern called "local cache" or "embedded cache." Option B's approach of scaling Redis horizontally doesn't address the fundamental problem — the latency is from the number of network round trips, not Redis throughput. Even with more replicas, each round trip still takes 0.5ms. Option C's DAX provides microsecond latency but still involves network calls — at 30-40 calls per evaluation, even 0.1ms per call = 3-4ms, which doesn't provide the margin needed. Option D's Lambda with EFS doesn't support the persistent connections and local memory state needed for this use case, and EFS access has higher latency than ElastiCache.

---

### Question 32
**Correct Answer:** A

**Explanation:** Option A correctly addresses all five requirements. A cluster placement group with EFA provides the inter-node bandwidth needed for gradient synchronization across 64 p5.48xlarge instances (each with 3,200 Gbps EFA networking). FSx for Lustre PERSISTENT_2 at 1000 MB/s/TiB throughput on a 50 TB dataset delivers 50,000 MB/s = ~50 GB/s (adding multiple filesystems or increasing the storage pool beyond 100 TiB achieves the required 100 GB/s). Checkpoints saved every 30 minutes to FSx enable <10-minute recovery on node failure. EC2 Capacity Reservations guarantee availability for the 14-day window at On-Demand pricing — while not the cheapest, Spot would be risky for a 14-day continuous job on 64 p5 instances. Option B's SageMaker Managed Spot Training is designed for cost savings but Spot interruptions on 64 GPU instances during a 14-day job would cause frequent restarts, potentially preventing completion within the deadline. Option C's Spot Instances carry the same risk as B, and SCRATCH_2 FSx filesystems are temporary and not designed for persistent checkpoint storage. Option D's EKS adds Kubernetes overhead, and EFS doesn't provide the sustained throughput needed for high-performance ML training I/O.

---

### Question 33
**Correct Answer:** A

**Explanation:** Three separate Redis clusters optimize for each workload's distinct requirements. User profiles use lazy-loading (cache-aside) with a 5-minute TTL matching the staleness tolerance — this minimizes cache writes while maintaining freshness. Product catalog requires a larger cluster (50 GB at 50 KB × 1M records) with an active invalidation pattern using Redis pub/sub to push price change notifications to all application nodes, achieving zero staleness. Sessions use write-through to ensure every read reflects the latest write (consistency requirement). Cluster mode enabled with sharding provides the memory and throughput needed for 500K req/s across the three workloads. Option B's tiered approach is architecturally reasonable but DynamoDB DAX for session data introduces vendor lock-in and doesn't provide the same write-through consistency guarantees as Redis. CloudFront for product catalog adds complexity for API-level caching. Option C's single ElastiCache Serverless instance doesn't provide the workload isolation needed — a session write storm could impact product catalog reads. Option D's Memcached doesn't support the pub/sub needed for product catalog invalidation and doesn't provide persistence for session data.

---

### Question 34
**Correct Answer:** A

**Explanation:** Option A optimally addresses each query pattern. RA3 nodes with managed storage provide the compute/storage separation needed for the growing dataset. Materialized views with auto-refresh every 5 minutes satisfy the dashboard requirement (2 TB scan returns in under 3 seconds from pre-computed results). Concurrency Scaling handles analyst ad-hoc queries by automatically adding transient capacity during peak hours, preventing query queuing. Redshift Spectrum scans historical data in S3 for quarterly reports without loading it into Redshift, keeping the cluster right-sized. AWS Transfer Family provides a managed SFTP endpoint for the reference data feed. Option B's Serverless approach works but doesn't optimize as well — base RPU costs for consistently running dashboards are higher than reserved RA3 nodes, and Serverless doesn't have the same materialized view optimization for predictable dashboard workloads. Option C's split approach (Athena + Redshift) adds operational complexity and Athena's per-scan pricing becomes expensive for frequent dashboard queries (2 TB × many times/day × $5/TB). Option D's Aurora PostgreSQL is an OLTP database not designed for analytical workloads — parallel query helps but cannot match Redshift's columnar, MPP architecture for 10 TB analytics.

---

### Question 35
**Correct Answer:** A

**Explanation:** Option A provides the most efficient and complete migration strategy. AWS SCT converts the schema and identifies PL/SQL conversion issues with an assessment report showing the percentage of automatically convertible code. For the 200,000 lines of PL/SQL, SCT converts a significant portion automatically, and the assessment identifies what requires manual refactoring. PostgreSQL's native XML type handles XMLTYPE, and PostGIS (a PostgreSQL extension) is the industry-standard replacement for SDO_GEOMETRY. PostgreSQL natively supports materialized views with pg_cron for scheduling (matching Oracle's refresh pattern). postgres_fdw replaces database links for federated queries. Amazon SQS via the aws_lambda extension replaces Oracle AQ for async processing. DMS with full load + CDC provides continuous replication for the minimal downtime cutover. Option B's two-phase approach doubles the migration effort and cost without significant risk reduction. Option C incorrectly suggests using DynamoDB for XML (losing SQL query capability), Amazon Location Service for spatial data (not a database type), and Redshift for materialized views (different engine entirely). Option D's approach of running both databases simultaneously is expensive and doesn't address the actual PL/SQL conversion challenge.

---

### Question 36
**Correct Answer:** C

**Explanation:** Option C provides the best combination of functionality and low operational overhead. AWS IoT Core natively handles millions of device connections with automatic scaling (no capacity planning needed). Kinesis Data Streams provides durable event ingestion with the ability to auto-scale shards. Lambda with event source mapping for anomaly detection scales automatically and requires no server management. Amazon Timestream's memory store (7 days) provides sub-10-second SQL query response for recent data, while the magnetic store (365 days) handles the 1-year retention — both accessed via the same SQL interface. Kinesis Data Firehose writes raw data to S3 for additional long-term archival. For 10x flash events, Kinesis shard auto-scaling (via CloudWatch alarm) handles the burst. Option A's Apache Flink adds operational overhead for anomaly detection that Lambda can handle at this scale. Option B's SQS-to-Lambda approach works but SQS doesn't provide the ordered processing and replay capabilities of Kinesis. Athena for "real-time" queries is not ideal — Timestream's purpose-built time-series engine provides better performance. Option D requires managing MSK infrastructure and ECS Fargate tasks, significantly more operational overhead than the serverless approach.

---

### Question 37
**Correct Answer:** A

**Explanation:** Amazon OpenSearch Service is the best fit for this search use case. It provides full-text search with fuzzy matching for typo tolerance, custom analyzers for relevance tuning, aggregations for faceted filtering, and completion suggesters for sub-100ms autocomplete. The 6 data nodes of r6g.2xlarge handle 10,000 queries/second for 50M products. The Amazon Personalize integration for re-ranking adds ML-based personalization without building a custom model. DynamoDB Streams to Lambda to OpenSearch bulk API ensures near-real-time indexing within 30 seconds. UltraWarm nodes for older product data optimize costs. Option B's CloudSearch is a legacy service with limited customization — it lacks fuzzy matching, custom analyzers, and the advanced aggregation capabilities of OpenSearch. Option C's Amazon Kendra is designed for enterprise document search with natural language understanding, not e-commerce product search at scale — it doesn't support the faceted filtering and autocomplete patterns needed here. Option D's Neptune is a graph database, not a search engine — while it can model relationships, its query performance for full-text search with faceted filtering at 10,000 QPS would be orders of magnitude worse than OpenSearch.

---

### Question 38
**Correct Answer:** B

**Explanation:** Option B is the only architecture that can handle 500,000 concurrent WebSocket connections with 50ms p99 message delivery. EKS with Socket.IO provides persistent WebSocket handling with NLB sticky sessions routing clients to the correct pod. Redis pub/sub distributes game state updates across all pods — when a game state update occurs, it's published to the Redis channel for that room, and all pods with players in that room receive and forward the update. This architecture handles the connection storm via Karpenter's rapid node provisioning. Redis Cluster mode with 6 shards provides the memory and throughput for the connection store. Option A's API Gateway WebSocket API has a fundamental scaling issue: pushing to specific connections via the `@connections` API requires individual POST calls per connection. For a room with 100 players receiving 10 updates/second, that's 1,000 API calls/second per room. At scale with thousands of rooms, this creates prohibitive API Gateway costs and latency. Option C's AppSync subscriptions are designed for GraphQL use cases with lower connection counts — 500,000 concurrent connections would be challenging. Option D's Kinesis-backed approach adds unnecessary latency from the stream processing and doesn't support the room-based pub/sub pattern efficiently.

---

### Question 39
**Correct Answer:** B

**Explanation:** Option B provides the optimal architecture for all six requirements. Step Functions orchestrates the pipeline with proper error handling. The initial Lambda for schema validation (reading only headers) is fast and cheap, preventing invalid files from consuming Glue DPU resources. Glue ETL with auto-scaling handles files from 100 MB to 50 GB by automatically adjusting DPU count. The `dropDuplicates()` Spark transform efficiently deduplicates on composite keys. Partitioned Parquet output meets the analytics requirement. Step Functions' dynamic DPU allocation based on file size optimizes cost for small files while ensuring large files complete within 30 minutes. At 200 files/day, estimated cost: Lambda (~$5/month) + Glue (~$300-400/month with auto-scaling averaging 5-10 DPUs per job × 10-30 minutes × 200 jobs × $0.44/DPU-hour) + Step Functions (~$5/month) = well under $500/month. Option A doesn't include the schema validation step and directly triggers Glue for every file, wasting resources on malformed files. Option C's Lambda approach can't handle 50 GB files even with 10 GB memory, and the ECS fallback adds complexity. Option D's MWAA (Airflow) costs ~$400-500/month alone for the environment, exceeding the budget before any processing costs.

---

### Question 40
**Correct Answer:** C

**Explanation:** DynamoDB Global Tables is the best choice for both workloads given the requirements. For the read-heavy user preferences (95% reads), eventually consistent reads from the local Region provide single-digit millisecond latency, easily meeting the 100ms p99 target. For the write-heavy transactions (80% writes), DynamoDB Global Tables allows writes to the local Region — Global Tables replicates within typically 1 second across Regions (meeting the eventual consistency requirement). DynamoDB handles 100,000 reads/second and 20,000 writes/second with on-demand or appropriately provisioned capacity. Regional API Gateway endpoints with Lambda and CloudFront edge caching for reads optimize the full request path. Option A's split architecture (DynamoDB for reads, Aurora for writes) introduces unnecessary complexity. Aurora Global Database write forwarding adds latency (writes must travel cross-Region to us-east-1), potentially exceeding the 500ms write p99 for distant Regions. Option B's Aurora write forwarding has measured latency overhead of the cross-Region round trip, which could push European writes over 500ms. Option D's ElastiCache as primary data store lacks the durability guarantees of DynamoDB, and "write-sharding across Regions" for transactions creates complex conflict resolution challenges.

---

### Question 41
**Correct Answer:** A

**Explanation:** AWS Elemental MediaConvert is the most cost-effective and operationally simple solution. A single MediaConvert job processes all 6 output formats in parallel internally, leveraging MediaConvert's distributed processing architecture. MediaConvert is fully managed (requirement 5), supports FFmpeg-equivalent quality with industry-standard codecs (requirement 2), and includes built-in job retry logic via EventBridge (requirement 3). All 6 formats are available quickly because MediaConvert parallelizes output generation (requirement 1). Reserved pricing for the predictable 500 jobs/day baseline provides significant cost savings. Estimated cost: 500 jobs × 6 outputs × average 15 minutes of output × ~$0.024/minute (reserved) = ~$1,080/month. Option B's hybrid Lambda/Fargate approach requires managing FFmpeg deployment, handling the 15-minute Lambda timeout for shorter formats while separately managing Fargate for longer ones. This is operationally complex and more expensive. Option C's Batch approach requires managing container images, Spot interruption handling, and instance lifecycle. The Spot discount is offset by the operational overhead. Option D's EKS approach is the most operationally complex option, requiring Kubernetes expertise for a media transcoding use case.

---

### Question 42
**Correct Answer:** C

**Explanation:** Aurora zero-ETL integration with Redshift is the optimal solution for separating OLTP and OLAP workloads. Aurora continuously replicates data to Redshift with near-real-time latency (typically under 10 seconds), well within the 5-minute staleness requirement. Redshift's columnar storage and MPP architecture are purpose-built for complex analytical queries with large table scans and multi-table joins — completing 100M+ row scans in under 60 seconds. The OLTP workload on Aurora remains completely unaffected, maintaining sub-10ms p99 latency. No ETL pipeline to build or maintain. This is the lowest-cost option since Redshift Serverless scales to zero when not running OLAP queries. Option A's read replicas help but don't solve the fundamental problem — Aurora's row-based storage engine is not optimized for analytical queries scanning 100M+ rows with complex joins, even on replicas. Option B's Parallel Query helps but still processes on the Aurora instance type, which isn't designed for OLAP-scale operations. Parallel Query works best for queries scanning less than a significant portion of the table. Option D's materialized views on a read replica help for known queries but don't address ad-hoc analytical queries, and ProxySQL adds operational complexity.

---

### Question 43
**Correct Answer:** A

**Explanation:** Amazon Managed Service for Apache Flink (formerly Kinesis Data Analytics) provides a single processing application that handles the stream join with the S3 reference dataset and writes to all three destinations with different latency requirements. Flink's ability to load and periodically refresh an S3 lookup table makes the hourly reference data join seamless. The three-sink architecture addresses each latency requirement: OpenSearch Flink connector provides near-real-time writes (sub-30 seconds), Firehose to Redshift with 5-minute buffering meets the BI requirement, and Firehose to S3 with 15-minute buffering meets the data lake requirement. All in a single, managed application with least operational overhead. Option B's Glue Streaming ETL cannot write to OpenSearch directly and the micro-batch approach doesn't meet the 30-second OpenSearch requirement. Option C requires managing MSK infrastructure and custom Kafka Streams applications. Option D's Lambda approach would struggle with the S3 reference dataset — a 100 GB lookup table doesn't fit in Lambda's 10 GB memory, and refreshing hourly adds complexity. The sequential processing of Kinesis records through Lambda also adds latency compared to Flink's parallel processing.

---

### Question 44
**Correct Answer:** A, B

**Explanation:** The two changes with the greatest impact on p99 latency are A (replacing REST with gRPC/HTTP2) and B (implementing circuit breakers with outlier detection). Option A addresses the fundamental protocol overhead: HTTP/2 multiplexing eliminates head-of-line blocking that causes latency spikes when multiple sequential calls share the same connection. gRPC's binary serialization is significantly faster than JSON serialization/deserialization. Connection pooling via Envoy sidecars eliminates TCP handshake overhead for each call. Combined, this can reduce average inter-service latency from 25ms to 5-10ms. Option B directly addresses the p99 spike to 500ms caused by cascading timeouts. Circuit breakers prevent a slow downstream service from causing upstream timeouts across the entire call chain. Outlier detection ejects unhealthy instances quickly, preventing requests from being routed to degraded pods. The retry policy with exponential backoff handles transient failures gracefully. Option C's single-AZ placement group increases availability risk for minimal latency gain (cross-AZ latency within a Region is typically <1ms). Option D replaces synchronous communication with asynchronous messaging, which fundamentally changes the application architecture — not practical for request-response patterns. Option E's response caching helps but many inter-service calls have unique parameters, limiting cache hit rates.

---

### Question 45
**Correct Answer:** A

**Explanation:** Step Functions orchestrating AWS Batch with Spot Instances is the most cost-effective architecture. Each pipeline step uses the optimal instance type: p3.2xlarge (GPU) for base calling, r5.8xlarge (memory) for alignment, c5d.9xlarge (compute + NVMe scratch) for variant calling, and Lambda for the lightweight annotation step. Spot pricing provides 60-70% savings on the compute-intensive steps. AWS Batch manages instance lifecycle, job queuing, and retry logic. Step Functions handles the sequential orchestration with built-in error handling — if a step fails, intermediate results in S3 allow restart from the failed step (not the beginning). At 20 runs/week: base calling (20 × 2h × ~$3.10/h Spot p3.2xlarge = ~$124/week), alignment (20 × 4h × ~$0.60/h Spot r5.8xlarge = ~$48/week), variant calling (20 × 6h × ~$0.50/h Spot c5d.9xlarge = ~$60/week), annotation (Lambda ~$5/week). Total: ~$240/week or ~$1,040/month — dramatically cheaper than the current $55,000/month. Option B's ParallelCluster adds operational overhead for a workflow that doesn't require inter-node communication. Option C's SageMaker Processing adds ~30% cost overhead over raw EC2 for the managed service premium. Option D's EMR is designed for distributed data processing, not sequential pipeline steps.

---

### Question 46
**Correct Answer:** B

**Explanation:** AWS Cloud WAN is the correct answer for a network of this scale and complexity. Cloud WAN provides a centralized, policy-driven approach to managing 200 VPCs across 5 Regions. Its segment-based architecture cleanly implements production/development isolation (requirement 5) through core network policies rather than complex route table management. Cloud WAN natively supports Transit Gateway attachments, Direct Connect, and VPN connections through a single management plane. The built-in network monitoring dashboard and Route Analyzer provide the single-pane-of-glass visibility (requirement 6). Centralized internet egress through a shared services segment with Network Firewall is a native pattern. Option A's manual Transit Gateway management works but becomes operationally complex at this scale — managing 5 Transit Gateways, inter-Region peering, separate route tables for isolation, and Direct Connect Gateway attachments requires significant manual configuration and monitoring tooling. It lacks the policy-driven automation and built-in monitoring of Cloud WAN. Option C's VPC Peering doesn't scale for any-to-any connectivity across 200 VPCs (n×n peering complexity). Option D's third-party SD-WAN solution adds cost, licensing complexity, and IPSec overhead that AWS native solutions avoid.

---

### Question 47
**Correct Answer:** A, C, E

**Explanation:** These three optimizations together achieve approximately $100,000/month in savings. Option A: Compute Savings Plans covering 70% of EC2+Lambda ($87,000 × 70% × 66% savings = ~$40,000/month) plus Spot for fault-tolerant workloads (~$5,000/month). Total: ~$45,000/month savings. Option C: VPC endpoints eliminate most NAT Gateway processing fees (~$20,000 savings). CloudFront for content delivery reduces EC2 data transfer out costs (~$10,000 savings). Total: ~$30,000/month savings. Option E: S3 Intelligent-Tiering saves ~$10,000/month on the 500 TB bucket (60% infrequently accessed data moved to IA tier). CloudWatch optimization saves ~$5,000/month by switching non-critical monitoring to basic and using EMF. Total: ~$15,000/month savings. Grand total: ~$90,000-95,000/month savings, approaching the $100,000 target. Option B provides real savings (~$30,000) but overlaps significantly with Option A's Savings Plans — right-sizing first and then applying Savings Plans is the correct order, but the question asks for the combination that achieves $100,000, and A+C+E gets closer. Option D's suggestions are risky (DynamoDB DAX is not a drop-in replacement for ElastiCache, self-managed monitoring adds operational overhead, and Aurora Serverless v2 may not save money for steady-state workloads).

---

### Question 48
**Correct Answer:** A

**Explanation:** SageMaker real-time inference with auto-scaling provides the best cost optimization. Scheduled scaling between 2 instances (off-hours) and 10 instances (business hours) matches the traffic pattern. During off-hours at 50 req/s, 2 instances handle the load (25 req/s each at 100ms = easily within capacity). SageMaker Savings Plans for the 2-instance baseline provides ~64% discount. The model pre-loading during initialization avoids cold start latency. Cost: 2 instances × 24 hours × $0.526/hr (Savings Plan) = $25.25/day + 8 additional instances × 12 hours × $0.736/hr (On-Demand) = $70.66/day. Monthly: ~$2,877/month. Savings: 84% vs current $18,000. Option B's EKS with Spot is viable but GPU Spot interruptions cause 2-minute cold starts for model loading, potentially exceeding the 500ms p99 SLA during business hours. Option C's Lambda cannot use GPUs, and the 100ms inference time on CPU would be much longer (2+ seconds), far exceeding the latency requirements. Lambda SnapStart also doesn't support container images currently. Option D's SageMaker Serverless inference has cold starts when scaling from zero, making it unsuitable for consistent latency during off-hours when the endpoint might scale to zero between requests.

---

### Question 49
**Correct Answer:** A

**Explanation:** Option A uses the optimal service for each processing step. Lambda handles upload, resize, and DynamoDB writes efficiently and cheaply. The key insight is that batch inference with SageMaker on Spot Instances is dramatically cheaper than real-time inference for the 80% of cost (object detection). Accumulating images and running batch detection every 15 minutes eliminates the need for always-on GPU instances. SageMaker batch transform with Spot provides 60-70% discount over On-Demand, and batch processing is more efficient than individual inference calls (better GPU utilization). Estimated monthly: Lambda at 10M invocations for resize/upload ~$2,000, SageMaker batch with Spot ml.g4dn.xlarge ~$8,000 (processing 10M images at 200ms each = 2M GPU-seconds/month, requiring ~5 instances running 4.6 hours/day × 30 days on Spot), DynamoDB ~$1,000. Total: ~$11,000 vs current $55,000 (80% savings). Option B reduces instances but 5 GPU instances running 24/7 is still expensive. Option C's Lambda with CPU inference at 2 seconds per image is surprisingly cost-competitive at $2,660/month, but the total Lambda cost calculation would be higher when including the 10 GB memory configuration ($0.0000133/GB-sec × 10 GB × 2s × 10M = $2,660), and this doesn't account for the concurrent execution capacity needed (115 concurrent at 2s each = 230 concurrent Lambdas). Option D's Inferentia approach is excellent for performance but reserved pricing still costs more than batch Spot.

---

### Question 50
**Correct Answer:** B

**Explanation:** Option B provides the most cost-effective architecture for this mixed workload pattern. RA3 nodes with managed storage separate compute from storage — the 200 GB hot dataset fits in the local SSD cache while the full 10 TB is in managed storage (S3-backed). 1-year reserved RA3 pricing provides significant savings over On-Demand. Concurrency Scaling adds temporary compute clusters during peak dashboard hours at no charge for the first hour per day (included free), handling the 8am-6pm spike. Data sharing to a Redshift Serverless endpoint for analyst queries (10am-4pm only) means you pay for analyst compute only 6 hours/day — Serverless scales to zero outside these hours. Historical data in S3 via Spectrum handles monthly reports without loading into the cluster. AWS Transfer Family for the SFTP reference data feed is seamlessly integrated. Option A's Serverless-only approach works but the consistent dashboard workload is more cost-effective on reserved RA3 nodes than RPU-based Serverless pricing. Option C's Athena-only approach becomes expensive for frequent dashboard queries ($5/TB × 2TB × multiple queries/day × 22 days = potentially thousands per month). Option D's dc2 renewal locks in old technology, and dc2 doesn't offer compute-storage separation.

---

### Question 51
**Correct Answer:** A, B

**Explanation:** Option A provides the largest single cost reduction. Right-sizing 80% of services from 2 vCPU/4 GB to 0.5 vCPU/1 GB represents a 75% reduction in Fargate compute costs for 160 services. At $120,000/month total, those 160 services represent approximately $96,000 (80% of the fleet). A 75% reduction = ~$72,000 savings, though actual savings depend on the right-size target (conservatively 50-60% = $48,000-57,600). Option B migrates the 50 batch services to ECS on EC2 with Spot. Batch services running 2-4 hours every 6 hours means they're active only 33-67% of the time, but Fargate charges for every second. EC2 Spot with cluster auto-scaling only charges when tasks are running, and at 60-70% Spot discount. Estimated savings: 50 services × ~$600/month each × 50% utilization savings × 70% Spot discount = significant cost reduction. Option C's wholesale migration to EC2 loses Fargate's operational simplicity for ALL services, which is overkill. Option D's Fargate Spot for unpredictable services is a good idea but represents smaller savings (30 services with intermittent burst). Option E's Lambda migration for latency-critical services adds cold-start risk, contradicting the latency requirement.

---

### Question 52
**Correct Answer:** B

**Explanation:** Option B is the optimal strategy because S3 Intelligent-Tiering with all tiers enabled handles the key challenge — viral content access. When ALL 5 PB is in Intelligent-Tiering, objects automatically move between tiers based on access patterns. Popular content stays in Frequent Access. Weekly content moves to Infrequent Access (30 days of no access). Monthly content moves to Archive Instant Access (90 days). Yearly content moves to Archive Access (90 days after Infrequent) or Deep Archive (180 days). The critical advantage: when content goes viral, Intelligent-Tiering promotes it back to Frequent Access with NO retrieval fees and NO operational intervention. No custom logic, no alarms, no Lambda functions. Cost estimate: Frequent tier (250 TB × $0.023 = $5,750), Infrequent (750 TB × $0.0125 = $9,375), Archive Instant (1.5 PB × $0.004 = $6,000), Archive/Deep Archive (2.5 PB × $0.00099-0.002 = ~$2,500-5,000). Total: ~$23,625-28,125/month + monitoring fee (~$12,500 for 5B objects). Grand total: ~$36,000-40,000/month. Savings: 65-69%. Option A requires custom automation for viral detection and S3 Glacier Flexible Retrieval takes 3-5 hours, not instant. Option C's approach of mixing IT and lifecycle adds complexity. Option D's weekly S3 Batch Operations is too slow for viral content response.

---

### Question 53
**Correct Answer:** D, E

**Explanation:** Option D provides the largest cost reduction opportunity. An Enterprise Discount Program (EDP) or Private Pricing Agreement provides 10-20% across ALL AWS spending, not just data transfer. At $33,500/month data transfer alone, plus likely significant overall spend, a 15% EDP discount could save $5,000+/month on data transfer alone. More importantly, restructuring data flows to minimize cross-Region transfer (processing locally and transferring only aggregated results) can dramatically reduce the 20 TB inter-Region transfer. Option E's CloudFront with a Security Savings Bundle provides meaningful savings on the internet-facing traffic through edge caching (70% cache hit ratio reduces origin data from 35 TB to 10.5 TB) and committed-use pricing. The combined savings of $3,500-5,000/month is significant. Together, D+E can achieve $8,500-11,700/month savings (25-35%+). Option A's CloudFront Savings Bundle savings of $2,550/month alone doesn't reach the 30% target. Option B's compression savings ($440/month) is too small. Option C's approach reduces volume but the per-GB rate remains the same, and $300/month is minimal.

---

### Question 54
**Correct Answer:** A, B

**Explanation:** Option A provides the most direct and significant cost reduction. Switching 70% of reads to eventually consistent halves the RCU consumption for those reads, saving approximately 35% of read costs. This is a configuration change with immediate impact and no infrastructure changes needed. Estimated savings: $5,000-7,000/month. Option B addresses two costs: write sharding prevents hot partition throttling (which wastes WCU on retries) and evaluating whether the GSI can be replaced with a DynamoDB Streams-based pre-computed table eliminates 30% of WCU. The GSI consumes WCU for every write to the main table (for index updates), so removing it saves both the GSI write overhead and the GSI storage. Combined savings: ~$4,000-6,000/month. Together A+B save approximately $9,000-13,000/month on a $45,000/month bill = 20-29%. To reach the 40% target, implementing C (DAX) for additional read savings would help, but the question asks for combinations achieving "at least 40%." With A saving 35% of reads and B saving 30% of writes, the combined impact approaches 40%. Option C adds DAX for further read savings. Option D correctly identifies that on-demand would be catastrophically more expensive. Option E's mixed approach adds complexity without clear cost benefit.

---

### Question 55
**Correct Answer:** C

**Explanation:** For a 3-year steady-state workload at 1,000 req/s, EC2 with Reserved Instances is the cheapest option. At 100ms average response time, each request uses minimal compute. Three c6g.medium instances (Graviton) can handle 1,000 req/s with headroom. With 3-year All Upfront RI pricing, the total compute cost is approximately $450/month across all 3 instances. Add ALB (~$70/month) = ~$520/month total. Option A (Lambda) appears cheap on compute ($680/month) but API Gateway REST API pricing at $3.50 per million requests is the killer — at 2.592 billion requests/month, that's $9,072/month just for API Gateway. Total: $9,750/month. Even with HTTP API ($1.00/million), it's $2,592/month + Lambda = $3,272/month, still far more than EC2 RI. Option B (Fargate) at $1,742/month with Compute Savings Plan is competitive but still 3x more expensive than EC2 RI because Fargate has a premium over raw EC2. Option D is incorrect — the costs are dramatically different, with EC2 RI being 5-19x cheaper than Lambda+API Gateway and 3x cheaper than Fargate for this specific steady-state workload.

---

### Question 56
**Correct Answer:** B

**Explanation:** CodeDeploy blue/green deployment via ASG is the optimal solution for all five requirements. CodeDeploy provisions an entirely new ASG (green), deploys the new version, and shifts traffic through the ALB. The `canary-5-percent` custom deployment configuration routes 5% of traffic to the green group for 10 minutes (requirement 4), then shifts 100% if healthy. The CloudWatch alarm on `HTTPCode_Target_5XX_Count` triggers automatic rollback (requirement 2) — CodeDeploy automatically reroutes all traffic back to the blue ASG. The entire process completes in under 30 minutes (requirement 1) with zero downtime (requirement 3) since both ASGs are active during transition. Cost: double capacity for ~30 minutes bi-weekly = ~2 hours/month of extra instances, well under $2,000 (requirement 5). Option A's in-place `OneAtATime` deployment is far too slow for 100 instances (each requiring health check stabilization). Option C's custom Route 53-based approach requires building and maintaining the entire orchestration logic that CodeDeploy provides natively. Option D's ECS migration changes the compute platform, which is beyond the deployment strategy question — and ECS circuit breakers are deployment-level, not traffic-level canary testing.

---

### Question 57
**Correct Answer:** B

**Explanation:** Aurora Serverless v2 provides the most significant cost reduction for this workload profile. The daytime workload at 15% CPU of a db.r5.2xlarge (8 vCPU, 64 GB) needs approximately 1.2 vCPU worth of compute, which translates to about 4 ACUs (Aurora Capacity Units, where 1 ACU ≈ 2 GB RAM). During the 2-hour nightly report spike (80% CPU), it scales to ~16 ACUs. Monthly cost: (4 ACU × 22 hours + 16 ACU × 2 hours) × 30 days × $0.12/ACU-hour = (88 + 32) × 30 × $0.12 = $432/month for compute. With Aurora storage (~$0.10/GB × 500 GB = $50/month) and I/O charges, total is approximately $600-700/month. Savings: 83-85%. The application team doesn't need to modify code because Aurora Serverless v2 is wire-compatible with MySQL. Option A achieves 63% savings but requires managing a nightly replica creation/deletion workflow. Option C downsizes too aggressively — db.r5.large with 2 vCPU and 16 GB RAM at 80% CPU utilization during reports would likely OOM during the nightly reporting (the 64 GB memory of the current instance may be necessary for complex report queries). Option D incorrectly claims DynamoDB PartiQL is a MySQL-compatible drop-in — it's a SQL-like interface for DynamoDB, not a MySQL wire protocol replacement. The application would need code changes.

---

### Question 58
**Correct Answer:** B

**Explanation:** Option B correctly identifies the solution that meets all requirements including the crucial $1,000/month cost constraint. Five customer-managed keys ($5/month) with automatic rotation provide zero-downtime annual rotation. The key insight is envelope encryption with data key caching: instead of calling KMS for every encrypt/decrypt operation (which at 30,000/s would cost $233,280/month), the application uses locally cached data keys. The AWS Encryption SDK generates a data key via `GenerateDataKey`, caches it for up to 5 minutes, and uses it locally for all encryption/decryption during that window. This reduces KMS API calls from 30,000/s to approximately 100/s (one call per cache refresh per data key). At 100 req/s: 259M calls/month × $0.03/10,000 = $777/month + $5 keys = $782/month. Well within the $1,000 budget. Option A correctly calculates that without caching, the API cost would be $233,280/month — far exceeding the budget. Option C uses AWS-managed keys, violating requirement 1 (customer-managed keys). Option D uses a single key, violating requirement 2 (different key per service for blast radius containment).

---

### Question 59
**Correct Answer:** C

**Explanation:** EKS on EC2 with Reserved Instances for steady state and Spot for burst provides the lowest total 3-year cost. Steady state: 7 c6g.4xlarge RIs at ~$1,458/month. Burst: 12 c6g.4xlarge Spot instances at 80% discount for 4 hours/day = $157/month. EKS control plane: $74/month. ALB + CloudWatch: $350/month. Total: ~$2,039/month or ~$73,404 over 3 years. Option A (ECS on EC2): Same compute costs as C but without EKS control plane fee. However, the question assumes identical compute pricing, and ECS on EC2 total is ~$2,491/month — higher because it uses On-Demand for burst instead of Spot. If ECS also used Spot, it would be ~$1,965/month (slightly less due to no EKS fee). But the answer choices as structured show C as the optimized Spot option. Option B (Fargate with CSP): $3,137/month — Fargate's per-vCPU/GB premium makes it more expensive even with Savings Plans. Option D (EKS on Fargate): $3,211/month — same Fargate premium plus EKS control plane cost. The key differentiator is EC2 Spot for burst providing 80% discount vs Fargate's inability to use Spot-level pricing.

---

### Question 60
**Correct Answer:** B

**Explanation:** Option B achieves the target 30% savings by optimizing along three dimensions: (1) separating interactive and batch workloads into right-sized clusters, (2) using Graviton instances for 20% better price-performance, (3) using Spot for batch task nodes (60-70% cheaper), and (4) using S3 instead of HDFS (eliminating persistent storage costs and EBS overhead). The persistent interactive cluster runs only during business hours (8 hours × 22 business days), dramatically reducing costs compared to a 24/7 cluster. The transient batch cluster spins up for 16 hours/day and terminates, avoiding idle compute costs. S3 as persistent storage (replacing HDFS) provides unlimited, durable storage at $0.023/GB. EMR Managed Scaling automatically adjusts cluster size based on workload demands. Total: ~$12,188/month = 59% savings from $30,000. Option A's single persistent cluster at $25,000/month only saves 17%, below the 30% target. Option C's Glue + Athena approach at ~$13,960/month saves 53% but Glue's per-DPU pricing for 16 hours/day of heavy ETL is expensive, and migrating complex Spark/Hive workloads to Glue requires significant effort. Option D's EMR on EKS is viable but adds Kubernetes operational overhead for a Hadoop migration.

---

### Question 61
**Correct Answer:** B

**Explanation:** Option B achieves the 100ms latency budget through two key optimizations: (1) local model inference eliminates the external SageMaker call (saving 10-20ms of network latency + inference overhead), and (2) DAX provides sub-millisecond reads for customer history (the most latency-critical lookup). The fraud detection service loads the 8 MB merchant blacklist into local memory (nanosecond lookup), retrieves customer history from DAX (sub-1ms), and aggregates from ElastiCache (sub-1ms). Feature computation (local CPU, <5ms) and TensorFlow Lite inference (local CPU, <10ms) complete the pipeline well within 100ms. NLB provides TCP-level routing with minimal added latency. 50 Fargate tasks handle 50,000 TPS (1,000 TPS per task). Option A's Lambda approach adds multiple external service calls: DynamoDB (5-10ms), ElastiCache (1-2ms), and SageMaker endpoint (20-50ms). Even with provisioned concurrency eliminating cold starts, the SageMaker call alone could push latency over 100ms at p99. Option C's Kinesis + Flink approach adds streaming latency (ingestion + processing + output) that makes the 100ms target very difficult. Option D's approach of running Redis on the same EC2 instance is an anti-pattern — it reduces available compute for inference and creates a single point of failure.

---

### Question 62
**Correct Answer:** B

**Explanation:** GitHub Actions with OIDC federation provides the most complete CI/CD pipeline for multi-account IaC deployments. OIDC federation eliminates long-term credentials (security best practice). Running `terraform plan` on PRs with results as comments satisfies requirement 1. GitHub's environment protection rules with 2 required reviewers satisfies requirement 2 — this is a native GitHub feature, not a workaround. Terraform workspaces per account/Region with S3+DynamoDB state backend provides encrypted, locked state management. `sensitive = true` on secret outputs prevents them from appearing in logs (requirement 5). The matrix strategy runs 50 accounts in parallel, easily completing within 2 hours (requirement 6). Scheduled drift detection via `terraform plan -detailed-exitcode` satisfies requirement 3. Maintaining previous state for rollback with the prior configuration satisfies requirement 4. Option A's CodePipeline approach works but manual approval actions for 50 accounts are cumbersome, and CodePipeline parallel actions are limited in their fan-out capability. Option C's CloudFormation StackSets is a valid approach but lacks the flexibility of Terraform for multi-cloud or complex state management, and change sets don't provide the same review experience as PR-based plans. Option D's CDK Pipelines with self-mutating pipeline is elegant but CDK's drift detection is limited compared to Terraform's.

---

### Question 63
**Correct Answer:** A, B, D

**Explanation:** Option A investigates and fixes the suspicious $2,000 S3-to-EC2 cost. S3 to EC2 in the same Region should be free when using a gateway VPC endpoint. The cost indicates traffic is routing through the NAT Gateway (which charges $0.045/GB for processing). Deploying the free S3 gateway endpoint and fixing routing saves both the $2,000 S3 transfer cost and reduces NAT Gateway processing. This is the highest-impact quick win. Option B addresses the $5,000 inter-AZ traffic through AZ-affinity routing (keeping service-to-service calls within the same AZ when possible), gRPC compression (reducing payload sizes by 50-70%), and AZ-local cache reads. A 30-50% reduction = $1,500-2,500/month savings on the largest cost category. Option D addresses the $4,000 NAT Gateway processing cost. Deploying VPC endpoints for AWS services (which typically account for the majority of NAT Gateway traffic) eliminates the per-GB processing charge for that traffic. If 70% of NAT traffic is to AWS services: $2,800/month savings. Combined: A ($2,000+) + B ($1,500-2,500) + D ($2,800) = $6,300-7,300/month savings (42-49% of $15,000). Option C's NAT instances eliminate per-GB processing charges but introduce operational overhead (patching, monitoring, HA), limited bandwidth, and are not recommended by AWS. Option E's CloudFront savings are meaningful but smaller in absolute terms compared to the other three.

---

### Question 64
**Correct Answer:** B

**Explanation:** Option B provides the most accurate cost allocation by implementing service-specific metering. For ECS, Container Insights with custom metrics tracks actual vCPU-seconds per container tagged by tenant — this is the most granular compute metering possible (requirement 1). For Aurora, Performance Insights with `pg_stat_statements` provides actual per-query CPU time and row counts, enabling precise per-tenant database cost allocation based on real consumption (requirement 2). S3 Inventory reports with prefix filtering provide exact storage per tenant (requirement 3). For ElastiCache, Redis memory and command metrics approximate per-tenant cache utilization. Combining all metrics with CUR in an Athena-based cost allocation table enables accurate monthly reports (requirement 4). CloudWatch Anomaly Detection on per-tenant cost metrics identifies Basic tenants consuming Enterprise-level resources (requirement 5). Option A's tag-based approach is too coarse for shared resources — you can't tag individual rows in a shared Aurora database or individual keys in a shared ElastiCache cluster. Proportional allocation by tenant count is inaccurate when tenants have vastly different usage patterns. Option C's approach of per-tenant Aurora instances defeats the purpose of shared infrastructure and dramatically increases database costs. Option D's Marketplace Metering Service is designed for AWS Marketplace ISV billing, not internal cost allocation.

---

### Question 65
**Correct Answer:** B, E, D

**Explanation:** The three highest monthly waste items by dollar impact are: **Option B (5 idle RDS instances): ~$1,900/month.** Assuming db.r5.large Multi-AZ instances (a common configuration), each costs ~$0.48/hour = $345.60/month. Five instances with no connections for 30+ days = $1,728/month compute + ~$170 storage = ~$1,900/month. This is the single largest waste item. **Option E (100 old EBS snapshots, 50 TB): ~$2,500/month.** EBS snapshots cost $0.05/GB/month. 50 TB × 1024 GB/TB × $0.05 = $2,560/month. For snapshots from instances terminated 2+ years ago, this is clearly waste. This is actually the highest-cost item overall. **Option D (25 unattached EBS volumes, 10 TB): ~$1,000/month.** Unattached gp2 volumes at $0.10/GB: 10,000 GB × $0.10 = $1,000/month. These volumes are paying full price without being used. The remaining items: unused Direct Connect (~$416-716/month), Redshift cluster ($540/month), idle ELBs + EIPs + NAT Gateways (~$403/month), and CloudWatch dashboards ($3/dashboard × 20 = $60/month minus free tier) are all significant but smaller in absolute dollar terms. Priority cleanup: (1) Delete old EBS snapshots ($2,500), (2) Terminate idle RDS instances ($1,900), (3) Delete unattached EBS volumes ($1,000), (4) Pause/terminate Redshift cluster ($540), (5) Cancel unused Direct Connect ($416-716).

---

## Scoring Guide

| Score | Assessment |
|-------|-----------|
| 58-65 (89-100%) | **AWS Master** — You know AWS better than most SAs at Amazon |
| 49-57 (75-88%) | **PASS** — You will definitely pass the real SAA-C03 exam |
| 40-48 (62-74%) | **Almost There** — Review weak domains and retake |
| 30-39 (46-61%) | **More Study Needed** — Focus on understanding service interactions |
| Below 30 (<46%) | **Significant Gaps** — Review all domains systematically |

---

*This is the FINAL BOSS exam. If you scored 75%+ here, walk into the SAA-C03 with confidence. You've earned it.*
