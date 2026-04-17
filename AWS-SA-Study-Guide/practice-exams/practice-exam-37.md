# Practice Exam 37 - AWS Solutions Architect Associate (VERY HARD)

## Multi-Account Strategy & Enterprise Governance

### Exam Details
- **Questions:** 65
- **Time Limit:** 130 minutes
- **Difficulty:** VERY HARD (harder than real exam)
- **Passing Score:** 720/1000
- **Domain Distribution:** Security ~20 | Resilient Architectures ~17 | High-Performing Technology ~16 | Cost-Optimized Architectures ~12

### Instructions
- Each question has either ONE correct answer (multiple choice) or TWO or MORE correct answers (multiple response — clearly marked)
- Read each scenario carefully — small details change the correct answer
- Manage your time: ~2 minutes per question

---

### Question 1
A financial services company with 120 AWS accounts organized under AWS Organizations is deploying a centralized logging strategy. They need all CloudTrail logs from every account to be written to a single S3 bucket in the Log Archive account. Logs must be encrypted with a customer-managed KMS key, and log file integrity validation must be enabled. A security team in a separate Security Tooling account needs read access to query these logs using Athena. The solution must prevent any individual account administrator from disabling or modifying their trail.

What combination of steps should the solutions architect implement? **(Choose THREE.)**

A) Create an organization trail from the management account with KMS encryption and log file validation enabled, targeting an S3 bucket in the Log Archive account
B) Create individual CloudTrail trails in each account using CloudFormation StackSets with a KMS key in each account
C) Apply an SCP to all OUs denying `cloudtrail:StopLogging`, `cloudtrail:DeleteTrail`, and `cloudtrail:UpdateTrail` for the organization trail ARN
D) Configure the S3 bucket policy in the Log Archive account to allow `s3:PutObject` from the CloudTrail service principal for the organization ID using `aws:PrincipalOrgID`
E) Grant the Security Tooling account cross-account access via an S3 bucket policy with `s3:GetObject` permission and share the KMS key policy for decrypt operations
F) Create an S3 replication rule to copy logs from each account's bucket to the centralized Log Archive bucket

**Answer: A, C, E**

**Explanation:** An organization trail created from the management account automatically captures events from all accounts in the organization and writes them to a centralized S3 bucket — this is the most operationally efficient approach (A). An SCP denying trail modification actions prevents any account administrator from tampering with the organization trail, enforcing governance (C). The Security Tooling account needs both S3 bucket policy access for reading objects and KMS key policy permissions for decrypting the logs to run Athena queries (E). Individual trails per account (B) create operational overhead without the tamper-proof centralization. The bucket policy for CloudTrail's service principal is automatically configured when creating the organization trail (D is unnecessary as a separate step). S3 replication (F) is an indirect and complex approach compared to the native organization trail feature.

---

### Question 2
Meridian Healthcare operates in 5 AWS regions and must comply with data residency regulations. They need to ensure that no resources — including EC2, RDS, S3, Lambda, and ECS — can be created outside of us-east-1, us-west-2, eu-west-1, eu-central-1, and ap-southeast-1. However, global services like IAM, AWS Organizations, CloudFront, and Route 53 must continue to function normally. The policy must apply to all accounts except the management account.

Which solution meets these requirements?

A) Create an SCP with an explicit deny on all actions where `aws:RequestedRegion` is not in the allowed list, with a `StringNotEquals` condition, and add `NotAction` exceptions for global services like `iam:*`, `organizations:*`, `cloudfront:*`, `route53:*`, `sts:*`, `support:*`, and `budgets:*`
B) Create an SCP with an allow list that permits actions only in the 5 regions and attach it to the root OU
C) Configure AWS Config rules in each account to detect and auto-remediate resources created in unauthorized regions
D) Use AWS Control Tower region deny guardrail and customize it to allow only the 5 approved regions

**Answer: A**

**Explanation:** The correct approach uses an SCP with a deny statement that blocks all actions except when `aws:RequestedRegion` matches the allowed regions. Critically, the SCP must use `NotAction` to exempt global services (IAM, Organizations, CloudFront, Route 53, STS, Support, Budgets) because these services have endpoints only in us-east-1 but are used globally — blocking them by region would break fundamental account functionality. An allow-list SCP (B) would interfere with the implicit deny behavior and could inadvertently block inherited permissions. AWS Config (C) is detective, not preventive, and auto-remediation introduces delays during which non-compliant resources exist. Control Tower's region deny guardrail (D) does use SCPs under the hood but may not provide the granular `NotAction` exceptions needed for all global services and is not customizable to the degree required.

---

### Question 3
NovaTech Solutions is implementing AWS Control Tower for a new multi-account landing zone. They need every new account provisioned through Account Factory to automatically have a standardized VPC with specific CIDR ranges, security groups, VPC endpoints for S3 and DynamoDB, and a transit gateway attachment. The VPC configuration must be consistent but the CIDR ranges should be unique per account drawn from a central IPAM pool. The team also wants pre-approved application portfolios deployed into each new account.

What is the MOST operationally efficient solution?

A) Use Account Factory Customization (AFC) with a custom blueprint backed by a Service Catalog product that deploys CloudFormation templates for the VPC, references AWS IPAM for CIDR allocation, and includes a portfolio of pre-approved products
B) Create a Lambda-backed custom resource triggered by the Control Tower lifecycle event `CreateManagedAccount` that provisions the VPC and application portfolios
C) Use CloudFormation StackSets with automatic deployment enabled for the organization, targeting the Workloads OU to deploy VPC templates on account creation
D) Configure Account Factory with custom VPC settings in Control Tower and use a separate AWS Service Catalog portfolio shared via RAM for application deployment

**Answer: A**

**Explanation:** Account Factory Customization (AFC) allows you to define custom blueprints backed by Service Catalog products that are automatically deployed when new accounts are provisioned through Account Factory. This is the most operationally efficient approach because it integrates natively with the account provisioning workflow, supports CloudFormation templates that can reference AWS IPAM for unique CIDR allocation, and can bundle both infrastructure (VPC, endpoints, TGW attachment) and application portfolios in a single blueprint. Lambda-backed lifecycle events (B) work but require custom code maintenance and error handling. StackSets (C) can deploy to new accounts but don't integrate with IPAM allocation during provisioning and require separate management of application portfolios. Option D splits the solution into two mechanisms, increasing operational complexity.

---

### Question 4
A global retail company uses AWS Organizations with 200+ accounts. Their compliance team needs to evaluate all accounts against a set of 45 custom AWS Config rules and 30 conformance packs. Currently, each account team manually enables Config and deploys rules, leading to inconsistent coverage. The compliance team needs a single dashboard view of compliance across all accounts and must be alerted within 15 minutes when any account becomes non-compliant with critical rules.

What solution provides the MOST comprehensive compliance visibility with the LEAST operational overhead?

A) Deploy Config rules and conformance packs using CloudFormation StackSets with organization-level trusted access, create a Config aggregator in a delegated administrator account, and configure Amazon EventBridge rules on `Config Rules Compliance Change` events forwarded to a central SNS topic
B) Enable AWS Config in each account using a Lambda function triggered by Control Tower lifecycle events, push compliance data to a central DynamoDB table, and use CloudWatch dashboards for visualization
C) Use AWS Security Hub with the AWS Config conformance packs standard, aggregate findings in a delegated administrator account, and configure Security Hub custom actions for alerting
D) Deploy AWS Config rules via Terraform in each account using a CI/CD pipeline, export compliance data to S3, and use Amazon QuickSight for the compliance dashboard

**Answer: A**

**Explanation:** CloudFormation StackSets with organization-level trusted access can automatically deploy Config rules and conformance packs to all existing and future accounts in specified OUs with minimal overhead. A Config aggregator in a delegated administrator account provides a single-pane-of-glass view of compliance status across all 200+ accounts. EventBridge rules monitoring `Config Rules Compliance Change` events can trigger alerts within minutes, meeting the 15-minute SLA. Option B requires significant custom code and DynamoDB schema design. Security Hub (C) doesn't natively ingest all custom Config rule evaluations as a conformance pack standard and adds unnecessary abstraction. Terraform with CI/CD (D) introduces pipeline management overhead and the S3/QuickSight approach adds latency incompatible with the 15-minute alerting requirement.

---

### Question 5
CyberShield Corp has enabled Amazon GuardDuty across all 85 accounts in their AWS Organization using a delegated administrator account. They now need to also enable S3 Protection, EKS Audit Log Monitoring, and Malware Protection for EC2 across all existing and future accounts. Findings classified as HIGH severity must trigger automated remediation — specifically, isolating compromised EC2 instances by replacing their security groups with one that blocks all traffic. MEDIUM findings should create tickets in their ServiceNow instance.

Which architecture satisfies all requirements? **(Choose TWO.)**

A) In the GuardDuty delegated administrator account, enable S3 Protection, EKS Audit Log Monitoring, and Malware Protection as auto-enable features for the organization, then configure these features for existing member accounts via the API
B) Use AWS Security Hub to aggregate GuardDuty findings and create custom actions that trigger Lambda functions for remediation based on severity
C) Configure EventBridge rules in the delegated administrator account that match GuardDuty findings by severity — HIGH severity triggers a Step Functions workflow that replaces the instance's security groups, MEDIUM severity invokes a Lambda function that calls the ServiceNow API
D) Enable GuardDuty features individually in each account using CloudFormation StackSets and configure local EventBridge rules per account for remediation
E) Use GuardDuty's built-in auto-remediation feature to automatically isolate compromised instances

**Answer: A, C**

**Explanation:** GuardDuty's delegated administrator can enable additional protection plans (S3, EKS, Malware) as auto-enable features for the entire organization, ensuring all new accounts automatically get these protections. Existing accounts require a separate API call to enable the features retroactively (A). EventBridge rules in the delegated administrator account can centrally process findings — a Step Functions workflow provides the orchestration needed for EC2 isolation (describing the instance, creating a restrictive security group, replacing security groups, and optionally creating a snapshot), while a Lambda function handles ServiceNow ticket creation for MEDIUM findings (C). Security Hub custom actions (B) require manual triggering and don't provide automated remediation. Per-account StackSets and local EventBridge rules (D) create massive operational overhead across 85 accounts. GuardDuty does not have a built-in auto-remediation feature (E) — remediation must be built using EventBridge and Lambda/Step Functions.

---

### Question 6
TerraCloud Inc. operates a hub-and-spoke network architecture with an AWS Transit Gateway shared across 40 accounts using AWS Resource Access Manager (RAM). They are adding 15 new accounts in a different OU for an acquired company. These new accounts need connectivity to the existing Transit Gateway but should only be able to communicate with shared services in the hub VPC — not with any spoke VPCs from the original organization. The acquired company's accounts should also be isolated from each other during a 6-month integration period.

What combination of actions achieves this? **(Choose THREE.)**

A) Share the Transit Gateway with the new OU using RAM and accept the resource share in each new account
B) Create a new Transit Gateway route table for the acquired company's accounts and associate their VPC attachments with it
C) Add routes in the new route table only pointing to the shared services VPC CIDR via the hub VPC attachment
D) Enable Transit Gateway auto-accept shared attachments for the organization
E) Add all new account VPC attachments to the existing Transit Gateway route table alongside original spoke VPCs
F) Configure Network ACLs on the shared services VPC subnets to block traffic from original spoke VPCs

**Answer: A, B, C**

**Explanation:** RAM sharing with the new OU makes the Transit Gateway available to the acquired company's accounts (A). Creating a separate Transit Gateway route table provides network isolation — by associating only the new VPC attachments with this route table, traffic routing is controlled independently from the original spoke VPCs (B). Adding routes only to the shared services VPC CIDR in this new route table ensures the acquired accounts can reach shared services but cannot route to any original spoke VPCs, and since their own route table only has the hub route, they are also isolated from each other (C). Auto-accept (D) simplifies operations but doesn't address isolation and is optional. Adding to the existing route table (E) would allow full mesh connectivity. NACLs (F) address the wrong level of the problem and don't provide the required spoke-to-spoke isolation.

---

### Question 7
A multinational bank is implementing tag enforcement across their AWS Organization of 300 accounts. Every resource must have `Environment`, `CostCenter`, `DataClassification`, and `Owner` tags. The `DataClassification` tag must only contain values from an approved set: `Public`, `Internal`, `Confidential`, `Restricted`. Resources without compliant tags should be flagged but NOT deleted. The bank also needs to identify the total cost impact of non-compliant resources and track remediation progress over time.

What solution provides proactive enforcement with comprehensive tracking? **(Choose THREE.)**

A) Create tag policies in AWS Organizations with the `enforced_for` property targeting supported resource types, specifying allowed values for `DataClassification`
B) Use SCPs to deny resource creation actions unless all four required tags are present using the `aws:RequestTag` condition key
C) Deploy AWS Config rules (`required-tags`) across all accounts using StackSets to evaluate tag compliance and report non-compliant resources
D) Enable cost allocation tags for all four tag keys and use AWS Cost Explorer to filter costs by tag compliance status
E) Use AWS Config advanced queries to aggregate non-compliant resource data across the organization and export to S3 for trend analysis
F) Configure AWS Systems Manager Inventory to collect tag information from all resources across accounts

**Answer: A, B, C**

**Explanation:** Tag policies with the `enforced_for` property provide preventive enforcement by blocking tag operations that don't comply with the allowed values for `DataClassification` on supported resource types (A). SCPs with `aws:RequestTag` condition keys can proactively deny resource creation when required tags are missing, providing a different layer of preventive control at the API level (B). AWS Config rules deployed via StackSets provide detective controls that continuously evaluate all resources for tag compliance and report non-compliant resources without deleting them — meeting the flagging requirement (C). Cost allocation tags (D) help with cost attribution but don't filter by "compliance status" directly. Config advanced queries (E) are useful but the question asks for proactive enforcement first. Systems Manager Inventory (F) is focused on EC2 managed instances, not all AWS resource types.

---

### Question 8
Quantum Analytics runs a data lake on AWS with 50TB of new data ingested daily across 12 accounts. They use a central Data Lake account with S3 buckets registered in AWS Lake Formation. Analysts in 8 different accounts need fine-grained column-level and row-level access to specific tables in the Glue Data Catalog. The security team requires that access grants are managed centrally, audited, and can be revoked instantly. Cross-account Athena queries must work without requiring analysts to set up their own Glue crawlers.

Which architecture meets these requirements?

A) Share Glue Data Catalog tables cross-account using RAM, configure Lake Formation permissions with column-level filters and data cell-level security in the central account, and grant permissions to IAM roles in analyst accounts via Lake Formation's cross-account grant mechanism
B) Replicate the Glue Data Catalog to each analyst account using a Lambda function, create IAM policies with S3 prefix-level access for each analyst role, and use S3 bucket policies for cross-account access
C) Create S3 Access Points per analyst account with IAM policies restricting access to specific prefixes, and share the Glue Data Catalog via RAM
D) Configure S3 Object Lambda Access Points to filter columns at read time based on the requesting principal's tags, and share S3 buckets directly with analyst accounts

**Answer: A**

**Explanation:** AWS Lake Formation provides centralized, fine-grained access control including column-level and row-level security (data filters). Lake Formation's cross-account grant mechanism allows the central Data Lake account to grant permissions directly to IAM roles or accounts without requiring analysts to configure their own crawlers — they can query shared tables through Athena immediately. RAM sharing of the Glue Data Catalog resources combined with Lake Formation permissions creates a centralized, auditable, and instantly revocable access model. Option B replicating the catalog creates synchronization challenges and IAM prefix-level access lacks column/row granularity. S3 Access Points (C) provide prefix-level access control but not column or row-level filtering. S3 Object Lambda (D) is not designed for tabular column filtering and would require significant custom logic.

---

### Question 9
A SaaS company migrating to AWS needs to implement IAM Identity Center (AWS SSO) with their existing Okta identity provider. They have 2,000 users organized into 150 groups in Okta. Users should be automatically provisioned and deprovisioned in IAM Identity Center when changes are made in Okta. Permission sets should map to Okta groups — for example, the "Platform-Admins" group should get AdministratorAccess in the Infrastructure OU accounts, and "App-Developers" should get PowerUserAccess only in the Workloads OU. When a user is removed from an Okta group, their AWS access must be revoked within minutes.

What is the correct implementation? **(Choose TWO.)**

A) Configure SCIM (System for Cross-domain Identity Management) provisioning in IAM Identity Center and set up the SCIM endpoint in Okta to automatically sync users and groups, including deprovisioning
B) Create a Lambda function that periodically calls the Okta API to compare users and groups with IAM Identity Center, provisioning and deprovisioning as needed
C) Assign permission sets to the synced Okta groups at the OU level — map "Platform-Admins" group to the AdministratorAccess permission set assigned to the Infrastructure OU, and "App-Developers" to the PowerUserAccess permission set assigned to the Workloads OU
D) Create individual IAM users in each account matching Okta usernames and use Okta's AWS multi-account plugin for federation
E) Use SAML federation without SCIM and manually manage user provisioning in IAM Identity Center

**Answer: A, C**

**Explanation:** SCIM provisioning establishes automatic synchronization between Okta and IAM Identity Center. When users or groups are created, updated, or deleted in Okta, SCIM automatically reflects those changes in IAM Identity Center — including deprovisioning, which revokes AWS access within minutes (A). Permission set assignment at the OU level maps group-based permissions exactly as described: the synced Okta group "Platform-Admins" gets the AdministratorAccess permission set for all accounts in the Infrastructure OU, and "App-Developers" gets PowerUserAccess for the Workloads OU (C). A Lambda function (B) introduces complexity, latency, and maintenance burden compared to native SCIM. Individual IAM users (D) defeats the purpose of centralized identity management. SAML without SCIM (E) handles authentication but not automatic provisioning/deprovisioning — users would need manual management.

---

### Question 10
Orbit Pharmaceuticals uses AWS Backup to protect workloads across 60 accounts in 3 regions. They need a centralized backup strategy where backup policies are defined once and automatically applied to all accounts in the Workloads OU. Critical databases (RDS and DynamoDB) must have hourly backups retained for 35 days, with cross-region copies to a disaster recovery region. All backup vaults must be encrypted with customer-managed KMS keys, and no account administrator should be able to delete backup recovery points — even in their own account.

Which combination of steps implements this? **(Choose THREE.)**

A) Create an AWS Backup policy in AWS Organizations and attach it to the Workloads OU, defining backup rules for hourly RDS/DynamoDB backups with 35-day retention and cross-region copy rules
B) Create individual backup plans in each account using CloudFormation StackSets with matching configurations
C) Enable AWS Backup vault lock in governance mode on all backup vaults to prevent deletion of recovery points
D) Apply an SCP denying `backup:DeleteRecoveryPoint`, `backup:DeleteBackupVault`, and `backup:PutBackupVaultAccessPolicy` to the Workloads OU
E) Configure the backup policy to use a customer-managed KMS key in each account for vault encryption, created via StackSets
F) Use S3 Object Lock in governance mode on the S3 buckets underlying the backup vaults

**Answer: A, C, E**

**Explanation:** AWS Organizations backup policies allow centralized definition of backup plans that are automatically applied to all accounts in the targeted OU. The policy can specify backup frequency, retention, and cross-region copy rules — meeting the hourly/35-day/cross-region requirements (A). Backup vault lock in governance mode prevents anyone, including account administrators, from deleting recovery points before their retention period expires — this is the AWS-native mechanism for immutable backups (C). KMS keys for vault encryption must exist in each account where the vault resides, so deploying customer-managed KMS keys via StackSets and referencing them in the backup policy provides the required encryption (E). Individual backup plans (B) add operational overhead that Organizations backup policies eliminate. SCPs (D) can deny deletion but vault lock is the purpose-built feature with retention enforcement. S3 Object Lock (F) cannot be applied to backup vaults — they are managed by AWS Backup, not directly by S3.

---

### Question 11
StreamVault Media processes video files uploaded by content creators. When a creator uploads a file to an S3 bucket in Account A (Content Ingestion account), a Lambda function in Account B (Processing account) must be triggered to start a MediaConvert job. The Lambda function needs to read the object from Account A's bucket and write the processed output to Account C's bucket (Distribution account). All three accounts are in the same AWS Organization. The solution must use the principle of least privilege and avoid long-term credentials.

What is the MOST secure architecture?

A) Configure S3 Event Notification in Account A to publish to an SNS topic, subscribe the Lambda function in Account B to the topic via cross-account subscription. The Lambda execution role assumes a role in Account A (via `sts:AssumeRole`) to read the object, processes it, then assumes a role in Account C to write the output
B) Configure S3 Event Notification to directly invoke the Lambda function in Account B using a resource-based policy. The Lambda execution role has inline policies granting `s3:GetObject` on Account A's bucket and `s3:PutObject` on Account C's bucket, with corresponding bucket policies in both accounts
C) Use S3 replication to copy the uploaded file to Account B's bucket, trigger Lambda locally in Account B, and use S3 replication again to copy output to Account C
D) Create an IAM user in Account A with access keys, store them in Secrets Manager in Account B, and use them in the Lambda function to read files from Account A

**Answer: B**

**Explanation:** S3 Event Notifications can directly invoke a Lambda function in another account when a resource-based policy (Lambda function policy) permits the invocation from Account A's S3 bucket. The Lambda execution role with specific `s3:GetObject` and `s3:PutObject` permissions, combined with corresponding bucket policies in Accounts A and C using `aws:PrincipalOrgID` condition, follows least privilege without requiring role chaining (B). While option A works, SNS adds an unnecessary hop and role assumption chains add latency and complexity. S3 replication (C) is asynchronous, introduces delays, and doesn't provide event-driven processing. IAM users with access keys (D) violates the requirement to avoid long-term credentials and is a security anti-pattern.

---

### Question 12
A government agency is designing their AWS Control Tower landing zone. They need to implement the following OU structure: Security OU (Log Archive + Security Tooling accounts), Infrastructure OU (Network Hub + Shared Services accounts), Workloads OU (split into Prod and Non-Prod child OUs), Sandbox OU (with aggressive cost controls), and a Suspended OU for decommissioned accounts. Each OU needs different guardrails. The Sandbox OU must have a $500/month hard spending limit per account, and accounts exceeding it must have all services suspended immediately.

Which combination of controls should be applied to the Sandbox OU? **(Choose THREE.)**

A) Apply an SCP that denies all EC2 instance types larger than t3.medium, denies RDS instances, and denies any service not in an approved list (S3, Lambda, DynamoDB, API Gateway)
B) Configure AWS Budgets with a $500 budget and an action that attaches a deny-all SCP to the account when 100% of the budget is reached
C) Use Control Tower's strongly recommended guardrails for the Sandbox OU, including region deny and encryption requirements
D) Apply an SCP denying `iam:CreateUser` and `iam:CreateAccessKey` to prevent long-term credential creation in sandbox accounts
E) Configure AWS Cost Anomaly Detection to alert on unusual spending patterns in sandbox accounts
F) Enable AWS Service Catalog with approved templates only and deny CloudFormation direct stack creation

**Answer: A, B, D**

**Explanation:** Restricting instance types and services via SCP (A) provides preventive cost control by limiting sandbox accounts to cost-effective services and preventing expensive resource provisioning. AWS Budgets actions (B) enable the hard spending limit by automatically attaching a deny-all SCP when the $500 threshold is reached, effectively suspending all services in the account immediately. Denying IAM user and access key creation (D) is a critical sandbox security control that prevents credential leakage and ensures all access goes through federated identity (IAM Identity Center). Control Tower guardrails (C) provide baseline governance but don't address sandbox-specific cost limits. Cost Anomaly Detection (E) is a monitoring tool that alerts after the fact, not a preventive control. Service Catalog restriction (F) is overly restrictive for a sandbox environment meant for experimentation.

---

### Question 13
GlobalInsure has deployed AWS Security Hub across 150 accounts using a delegated administrator in their Security Tooling account. They need Security Hub to be automatically enabled in every new account added to the organization, with the AWS Foundational Security Best Practices (FSBP) standard and CIS AWS Foundations Benchmark v1.4.0 enabled by default. Findings from all accounts must flow to the delegated administrator within 5 minutes. The security team wants to suppress specific findings that are false positives across all accounts centrally without affecting individual account settings.

What is the correct implementation?

A) In the delegated administrator account, enable Security Hub organization configuration with auto-enable for new accounts, specify FSBP and CIS as default standards, and use Security Hub automation rules to suppress specific findings across all member accounts based on custom criteria
B) Use CloudFormation StackSets to enable Security Hub in each new account with a lifecycle event trigger, configure standards individually, and use Config rules to suppress false positives
C) Configure each account manually through the Security Hub console, enable the standards, and create suppression filters in each account's Security Hub settings
D) Use a Lambda function triggered by the Organizations `CreateAccount` event to call the Security Hub API in each new account to enable it and configure standards

**Answer: A**

**Explanation:** Security Hub's organization configuration in the delegated administrator account supports auto-enable for new member accounts, including the ability to specify which security standards are enabled by default. This ensures consistent coverage without manual intervention. Security Hub automation rules allow the delegated administrator to centrally suppress or modify findings based on criteria (resource type, account, finding title, etc.) across all member accounts — this is the purpose-built feature for centralized false positive management. Findings automatically flow from member accounts to the delegated administrator in near real-time. StackSets (B) and Lambda (D) add unnecessary complexity when Security Hub has native organization integration. Manual configuration (C) is not feasible at 150-account scale and doesn't meet the auto-enable requirement.

---

### Question 14
A logistics company has a Transit Gateway connecting 30 VPCs across 3 AWS regions using Transit Gateway inter-region peering. They are implementing a centralized inspection architecture where all inter-VPC traffic must pass through a Network Firewall in the Inspection VPC. The Inspection VPC is in us-east-1. Currently, traffic between VPCs in the same region flows directly without inspection. The solution must ensure that ALL traffic between any two VPCs — regardless of whether they are in the same or different regions — is inspected by the Network Firewall.

What architecture change is required?

A) Create a separate Transit Gateway route table for spoke VPCs that has a default route (0.0.0.0/0) pointing to the Inspection VPC attachment, and associate all spoke VPC attachments with this route table. The Inspection VPC attachment is associated with a different route table that has specific routes to each spoke VPC CIDR
B) Enable Transit Gateway appliance mode on the Inspection VPC attachment and add static routes in each spoke VPC route table pointing to the Transit Gateway for all RFC 1918 CIDR ranges
C) Deploy Network Firewall endpoints in each VPC subnet and modify route tables to direct inter-VPC traffic through the local firewall endpoint
D) Use VPC peering instead of Transit Gateway and configure peering route tables to forward traffic through the Inspection VPC

**Answer: A**

**Explanation:** The key to centralized inspection with Transit Gateway is route table segmentation. By creating a spoke route table with a default route pointing to the Inspection VPC attachment, all traffic from spoke VPCs is forced through the Inspection VPC regardless of destination. The Inspection VPC has its own route table with specific routes back to each spoke CIDR, creating a hub-and-spoke routing pattern that ensures symmetric traffic flow through the firewall. Appliance mode (B) is important for stateful inspection (maintaining flow symmetry) and should be enabled, but it alone doesn't force traffic through the inspection VPC — route table configuration is the primary mechanism. Deploying firewall endpoints in each VPC (C) defeats the purpose of centralized inspection and increases costs and management overhead. VPC peering (D) doesn't support transitive routing required for centralized inspection.

---

### Question 15
DataNexus Corp manages a central Data Lake account that hosts S3 buckets with sensitive customer data. They need to share specific S3 prefixes with 10 analytics accounts across the organization. Each analytics account should only see and access data in their assigned prefix. The data is encrypted with a customer-managed KMS key. When an analytics account is removed from the organization, their access must be automatically revoked. The solution must not require managing individual IAM roles in the Data Lake account for each analytics account.

What approach provides the MOST scalable access management?

A) Create S3 Access Points — one per analytics account — each with an access point policy restricting access to the account's assigned prefix. Use the `aws:PrincipalOrgID` condition in the KMS key policy to allow decrypt operations. Access is automatically revoked when an account leaves the organization because the `PrincipalOrgID` condition will no longer match
B) Create cross-account IAM roles in the Data Lake account — one per analytics account — with policies scoped to specific S3 prefixes, and require analysts to assume these roles
C) Use S3 bucket policies with 10 separate statements, each granting access to a specific account and prefix combination
D) Share the S3 bucket using RAM with the analytics OU and use S3 Object Ownership to transfer ownership of uploaded objects

**Answer: A**

**Explanation:** S3 Access Points provide scalable, per-account access management without modifying the main bucket policy. Each Access Point has its own policy scoped to specific prefixes, making it easy to add or remove analytics accounts independently. The `aws:PrincipalOrgID` condition on the KMS key policy ensures only organization members can decrypt data — when an account is removed from the organization, this condition automatically invalidates their access. Cross-account IAM roles (B) require management of one role per account in the Data Lake account, which doesn't scale. Bucket policies with 10 statements (C) become unwieldy and approach the 20KB bucket policy size limit as accounts and prefixes grow. RAM (D) doesn't support S3 bucket sharing — RAM is used for subnets, Transit Gateways, License Manager configurations, and similar resources.

---

### Question 16
A healthcare company runs a HIPAA-compliant workload across 25 AWS accounts. AWS Config is enabled in all accounts with a Config aggregator in the compliance account. They discover that 3 accounts are running unencrypted EBS volumes, 5 accounts have S3 buckets without default encryption, and 2 accounts have RDS instances without encryption at rest. The CTO demands that going forward, no unencrypted storage resource can be created in any account, and existing non-compliant resources must be remediated within 24 hours.

What combination of controls provides both prevention and remediation? **(Choose THREE.)**

A) Apply an SCP denying `ec2:CreateVolume` unless `ec2:Encrypted` is `true`, deny `s3:CreateBucket` unless `s3:x-amz-server-side-encryption` is present, and deny `rds:CreateDBInstance` unless `StorageEncrypted` is `true`
B) Enable EBS encryption by default in all accounts and regions using a Lambda function that calls `ec2:EnableEbsEncryptionByDefault` in each account
C) Deploy AWS Config remediation actions using SSM Automation documents — for unencrypted EBS volumes, create encrypted snapshots and replace volumes; for S3 buckets, enable default encryption; for unencrypted RDS instances, create encrypted read replicas and promote them
D) Create a CloudWatch Events rule that detects `CreateVolume` API calls without encryption and terminates the volume
E) Use AWS Trusted Advisor to generate a report of unencrypted resources and email the account owners
F) Configure S3 Block Public Access at the organization level and enable default encryption in the bucket properties

**Answer: A, B, C**

**Explanation:** SCPs provide the preventive control layer by denying the creation of any unencrypted EBS volumes, S3 buckets without encryption, and unencrypted RDS instances at the API level (A). Enabling EBS encryption by default as an account-level setting ensures all new EBS volumes are automatically encrypted even if users don't specify encryption — this is a defense-in-depth measure alongside the SCP (B). AWS Config remediation actions with SSM Automation documents provide the automated remediation for existing non-compliant resources within the 24-hour window (C). CloudWatch Events (D) is reactive and destructive — terminating volumes could cause data loss. Trusted Advisor (E) provides reports but not remediation. S3 Block Public Access (F) addresses public access, not encryption — it's a separate concern from the encryption requirement.

---

### Question 17
FintechPrime is designing a disaster recovery strategy for their multi-account environment. Their critical workloads run in us-east-1 across 15 accounts in the Workloads-Prod OU. The RPO is 1 hour and RTO is 4 hours. They need automated failover of Route 53 DNS records, Aurora databases (in 3 accounts), DynamoDB global tables (in 5 accounts), and S3 data (in 7 accounts). The DR plan must be testable without affecting production, and all cross-region resources must be pre-provisioned in us-west-2 but kept at minimum cost until a DR event is triggered.

What architecture meets these requirements?

A) Use Aurora Global Database with read replicas in us-west-2 (promoting during DR), DynamoDB global tables replicating to us-west-2, S3 Cross-Region Replication, Route 53 health checks with failover routing, and a CloudFormation stack in us-west-2 that scales up pre-provisioned minimum-capacity resources via a single parameter change triggered by a Step Functions orchestration workflow
B) Use AWS Backup with cross-region backup vaults to copy all Aurora snapshots, DynamoDB backups, and S3 data to us-west-2 hourly, and restore everything from backups during a DR event
C) Use pilot light architecture with only DNS and database replication, and manually provision all compute resources in us-west-2 during a DR event
D) Replicate all resources identically in us-west-2 using CloudFormation StackSets in an active-active configuration across both regions

**Answer: A**

**Explanation:** This warm standby approach meets both RPO and RTO requirements. Aurora Global Database provides continuous replication with RPO under 1 second and can be promoted in us-west-2 within minutes. DynamoDB global tables provide millisecond replication across regions. S3 CRR ensures data availability in us-west-2. Pre-provisioned but minimally-scaled resources in us-west-2 (small instance sizes, minimum capacity) keep costs low while enabling rapid scale-up during DR — a CloudFormation parameter change or Step Functions workflow can orchestrate the entire failover including DNS switching, Aurora promotion, and resource scaling within the 4-hour RTO. AWS Backup (B) requires restore time from snapshots, which can exceed the 1-hour RPO and 4-hour RTO for large Aurora databases. Pilot light (C) with manual compute provisioning risks exceeding the 4-hour RTO. Active-active (D) meets requirements but is significantly more expensive than the "minimum cost until DR" requirement allows.

---

### Question 18
Nexus Enterprises uses AWS Service Catalog to provide self-service infrastructure provisioning across 80 accounts. They need to ensure that every provisioned product automatically applies the company's mandatory tags (`CostCenter`, `Environment`, `Application`, `DataOwner`), enforces specific constraints (only t3 and m5 instance families for EC2, only gp3 for EBS), and records which user launched which product for audit purposes. The central IT team manages the portfolio in a hub account and shares it across the organization.

What combination of Service Catalog features should be used? **(Choose THREE.)**

A) Use TagOptions associated with the portfolio to enforce mandatory tag key-value pairs on all provisioned products
B) Apply launch constraints that specify an IAM role in each consumer account, ensuring products are launched with controlled permissions and the launching user's identity is recorded in CloudTrail
C) Add template constraints that restrict parameter values — limiting `InstanceType` to t3 and m5 families and `VolumeType` to gp3
D) Share the portfolio across accounts using AWS Organizations integration in Service Catalog
E) Create individual portfolios in each account using CloudFormation StackSets
F) Use SCP to restrict EC2 instance types and EBS volume types organization-wide

**Answer: A, B, C**

**Explanation:** TagOptions (A) is Service Catalog's native feature for enforcing tag key-value pairs — when associated with a portfolio, all provisioned products must include the specified tags. Launch constraints (B) define an IAM role assumed during provisioning, providing controlled permissions without giving users direct access to underlying services. CloudTrail records the actual user who initiated the provisioning along with the assumed role, satisfying the audit requirement. Template constraints (C) allow administrators to restrict CloudFormation parameter values, limiting EC2 instance types and EBS volume types to approved options. Sharing via Organizations (D) is how the portfolio reaches other accounts, but the question asks about features for enforcement, not distribution. Individual portfolios (E) defeat the purpose of centralized management. SCPs (F) are organization-wide and would affect all resource creation, not just Service Catalog provisioned products.

---

### Question 19
A media company captures live event footage that is processed by an application running on EC2 instances in an Auto Scaling group. The processed video segments are stored in S3. The application state is stored in an ElastiCache Redis cluster. During peak events, the processing load spikes from 20 instances to 200 within 10 minutes. The company wants to use a mix of On-Demand and Spot Instances for cost optimization. However, if Spot Instances are reclaimed, the in-progress video segment must not be lost — the processing must resume on another instance without starting over.

What architecture supports this requirement? **(Choose TWO.)**

A) Configure the Auto Scaling group with a mixed instances policy — 20% On-Demand (for baseline) and 80% Spot with capacity-optimized allocation strategy across multiple instance types and AZs
B) Implement a checkpoint mechanism where the application periodically saves processing progress to ElastiCache Redis. When a Spot interruption notice is received (via instance metadata), the application saves its current state to Redis and gracefully shuts down. A new instance picks up processing from the last checkpoint
C) Use Spot Fleet with the lowest-price allocation strategy and a single instance type to minimize costs
D) Store all in-progress data on instance store volumes for maximum I/O performance and replicate to S3 every 5 minutes
E) Configure the Auto Scaling group lifecycle hooks to prevent termination until processing is complete

**Answer: A, B**

**Explanation:** A mixed instances policy with capacity-optimized allocation strategy across multiple instance types minimizes Spot interruption risk by selecting from pools with the most available capacity, while maintaining a baseline of On-Demand instances (A). The checkpoint mechanism using ElastiCache Redis is the key architectural pattern — by saving processing state periodically and upon receiving the 2-minute Spot interruption notice, work is preserved. A replacement instance reads the checkpoint from Redis and resumes processing without restarting (B). Lowest-price with single instance type (C) has the highest interruption rate because it concentrates on one pool. Instance store (D) is ephemeral — data is lost on interruption regardless of replication frequency. Lifecycle hooks (E) can delay termination but cannot prevent Spot reclamation; they only work for scale-in events, not Spot interruptions.

---

### Question 20
PrimeLogistics operates a fleet of 10,000 IoT devices that send telemetry data to AWS IoT Core. This data flows through IoT Rules to Kinesis Data Streams, is processed by Lambda functions, and stored in DynamoDB. The company needs to monitor the health of this entire pipeline across 5 accounts (IoT account, Stream Processing account, Compute account, Database account, and Monitoring account). They want a single CloudWatch dashboard in the Monitoring account that shows metrics from all 5 accounts, with composite alarms that trigger when the end-to-end pipeline latency exceeds 30 seconds or when the DynamoDB consumed capacity exceeds 80% of provisioned capacity.

What is the correct cross-account monitoring architecture?

A) Enable CloudWatch cross-account observability by configuring the 4 source accounts to share metrics with the Monitoring account. In the Monitoring account, create a dashboard using cross-account metric widgets, and create composite alarms combining metric alarms from all accounts
B) Use CloudWatch metric streams in each account to send metrics to a Kinesis Data Firehose in the Monitoring account, store in S3, and build the dashboard using CloudWatch Logs Insights
C) Deploy a Prometheus server in the Monitoring account that scrapes CloudWatch metrics from all accounts using IAM cross-account roles
D) Create identical CloudWatch dashboards in each account and use CloudWatch Dashboard Sharing to create a public URL that combines all dashboards

**Answer: A**

**Explanation:** CloudWatch cross-account observability allows source accounts to share their metrics, logs, and traces with a designated monitoring account. Once configured, the Monitoring account can create dashboards that reference metrics from any source account and build composite alarms that combine metric conditions across accounts. This directly supports the requirement for a single dashboard showing end-to-end pipeline health and composite alarms for latency and capacity thresholds. Metric streams to Firehose/S3 (B) adds unnecessary data pipeline complexity and CloudWatch Logs Insights is for log analysis, not metric dashboarding. A Prometheus server (C) introduces infrastructure management overhead and isn't designed for CloudWatch metric aggregation. Dashboard sharing (D) creates separate views, not a unified dashboard with composite alarms.

---

### Question 21
An e-commerce company has 40 AWS accounts with VPCs that need to access a shared set of AWS services (S3, DynamoDB, SQS, SNS, KMS, and ECR) via VPC endpoints. Currently, each account has its own VPC endpoints in each VPC, resulting in over 300 VPC endpoints across the organization. The company wants to reduce the number of endpoints and associated costs while maintaining private connectivity. They are already using a Transit Gateway for inter-VPC connectivity.

What architecture reduces VPC endpoint costs while maintaining private connectivity?

A) Create centralized VPC endpoints in a shared services VPC connected to the Transit Gateway. Configure the Transit Gateway routing and DNS (using Route 53 Private Hosted Zones shared via RAM) so that all spoke VPCs resolve AWS service endpoints to the centralized VPC endpoints' private IPs
B) Use a single gateway VPC endpoint for S3 and DynamoDB in each VPC (free of charge) and only centralize interface endpoints for SQS, SNS, KMS, and ECR
C) Remove all VPC endpoints and use a NAT Gateway in each VPC to access AWS services over the internet
D) Use AWS PrivateLink to create custom endpoints for each service and share them across accounts using RAM

**Answer: B**

**Explanation:** Gateway VPC endpoints for S3 and DynamoDB are free and must be created per-VPC (they cannot be shared via Transit Gateway), so there is no cost benefit to centralizing them. Interface endpoints for SQS, SNS, KMS, and ECR can be centralized in a shared services VPC and made accessible to spoke VPCs through Transit Gateway routing and DNS resolution (Route 53 Private Hosted Zones). This hybrid approach minimizes costs — free gateway endpoints per VPC plus a small number of centralized interface endpoints. Option A attempts to centralize all endpoints including S3/DynamoDB, but gateway endpoints cannot be routed through Transit Gateway. NAT Gateways (C) route traffic over the internet, violating the private connectivity requirement. PrivateLink (D) is for custom services, not for re-exposing native AWS service endpoints.

---

### Question 22
CloudBank Financial needs to implement a secrets management strategy across 60 accounts. Application secrets (database credentials, API keys) must be stored centrally in a Secrets account, rotated automatically, and accessible from Lambda functions and ECS tasks in 20 application accounts. The secrets must be encrypted with a customer-managed KMS key. When a secret is rotated, all consuming applications must receive the new value within 10 minutes without redeployment. Access to secrets must be auditable, and no application should be able to access secrets belonging to other applications.

What architecture meets all requirements?

A) Store secrets in AWS Secrets Manager in the Secrets account with automatic rotation enabled. Create a resource-based policy on each secret granting cross-account access to specific IAM roles in the application accounts, scoped by secret name prefix. Use the Secrets Manager SDK with caching (TTL < 10 minutes) in Lambda and ECS tasks. Encrypt secrets with a KMS key whose key policy grants decrypt to the consuming roles
B) Store secrets in AWS Systems Manager Parameter Store SecureString parameters with cross-account access via IAM roles and CloudFormation exports
C) Store secrets in a central DynamoDB table encrypted with KMS, and create a custom API Gateway endpoint for applications to retrieve secrets
D) Store secrets in HashiCorp Vault running on EC2 in the Secrets account and configure cross-account VPC peering for access

**Answer: A**

**Explanation:** Secrets Manager provides native automatic rotation, cross-account resource-based policies, and KMS encryption. The resource-based policy on each secret can restrict access to specific IAM roles using conditions on the secret's name prefix, enforcing application-level isolation. The Secrets Manager SDK with client-side caching (TTL set to under 10 minutes) ensures applications receive rotated values within the required window without code redeployment — when the cache expires, the next request fetches the new value. All access is logged in CloudTrail for auditability. Parameter Store (B) supports SecureString but doesn't have native automatic rotation. DynamoDB (C) requires building rotation logic and an API layer from scratch. HashiCorp Vault (D) introduces infrastructure management, licensing, and HA complexity that Secrets Manager handles natively.

---

### Question 23
A research institution runs computationally intensive genomics workloads on AWS. They have a shared HPC cluster using AWS ParallelCluster in the Research account. Scientists from 15 different department accounts need to submit jobs to this cluster. Each department has a budget allocation, and job costs must be tracked per department. The cluster uses FSx for Lustre for high-performance shared storage. Scientists should be able to submit jobs from their own accounts without logging into the Research account.

What architecture supports multi-account job submission with cost tracking?

A) Deploy AWS Batch in the Research account with compute environments sized for the genomics workloads, share the Batch job queue ARNs via RAM. Scientists submit jobs using cross-account IAM roles that tag jobs with their department's cost center. Use cost allocation tags to track per-department spending
B) Create VPN connections from each department VPC to the Research VPC, and scientists SSH into the head node to submit jobs
C) Deploy separate ParallelCluster instances in each department account and use S3 for data sharing between clusters
D) Create a custom API Gateway in the Research account with Lambda backend that submits jobs to ParallelCluster on behalf of scientists

**Answer: A**

**Explanation:** AWS Batch provides managed job scheduling that integrates with cross-account IAM roles. Scientists in department accounts assume roles with permissions to submit jobs to the shared Batch job queue. Each submission includes tags (department, cost center) that enable cost tracking through AWS Cost Explorer with cost allocation tags. Batch automatically manages compute environments and scaling. VPN with SSH access (B) creates security concerns and doesn't provide native cost tracking. Separate clusters per department (C) eliminates the shared cluster benefit and increases costs significantly. A custom API Gateway (D) adds development and maintenance overhead while losing native AWS Batch features like job dependencies, array jobs, and automatic cost tagging.

---

### Question 24
A company is migrating 500 on-premises Windows servers to AWS. They need to maintain the existing Active Directory domain membership and group policies. About 100 servers need to join the corporate AD domain hosted on-premises, while the remaining 400 can use a cloud-managed directory. File shares currently on Windows file servers must be migrated to AWS with DFS Namespace support. The hybrid connectivity is via AWS Direct Connect.

What is the correct directory and file storage architecture? **(Choose TWO.)**

A) Deploy AWS Managed Microsoft AD in the AWS cloud, establish a two-way forest trust with the on-premises AD. The 100 servers that need on-premises domain membership use AD Connector to authenticate against on-premises AD. The 400 servers join AWS Managed Microsoft AD
B) Use Simple AD for the 400 cloud-managed servers and AD Connector for the 100 servers requiring on-premises domain membership
C) Deploy Amazon FSx for Windows File Server in Multi-AZ configuration, join it to AWS Managed Microsoft AD, and configure DFS Namespaces for transparent file share access across availability zones
D) Deploy Windows file servers on EC2 instances with EBS volumes and configure Windows Storage Spaces for high availability
E) Use Amazon EFS with NFS for file shares and use AWS DataSync to migrate data from on-premises file servers

**Answer: A, C**

**Explanation:** AWS Managed Microsoft AD provides a fully managed domain controller that can establish trust relationships with on-premises AD, allowing the 400 cloud servers to join the managed domain while maintaining connectivity to on-premises resources. AD Connector provides the 100 servers needing on-premises domain membership with a proxy to authenticate against the existing AD without data synchronization (A). FSx for Windows File Server natively supports SMB protocol, DFS Namespaces, and integrates with Microsoft AD — Multi-AZ deployment provides high availability. DFS Namespaces enable transparent access across AZs, matching the on-premises experience (C). Simple AD (B) doesn't support trust relationships needed for hybrid scenarios. EC2-based file servers (D) require managing HA, patching, and storage manually. EFS with NFS (E) doesn't support SMB protocol or DFS Namespaces required for Windows file shares.

---

### Question 25
OmniTrack Analytics processes clickstream data from 50 million daily active users. Events are collected via Amazon Kinesis Data Streams with 100 shards. The data is consumed by a Kinesis Data Analytics (Apache Flink) application that performs real-time sessionization and writes results to Amazon OpenSearch. The company notices that during peak hours (2x normal traffic), the Flink application falls behind, causing a processing lag of 15 minutes. Enhanced monitoring shows that some shards receive 5x more data than others due to "hot" partition keys (popular pages).

What combination of changes will resolve the processing lag? **(Choose TWO.)**

A) Increase the number of Kinesis shards from 100 to 200 and redistribute the hot partition keys using a random suffix strategy (e.g., appending a random number 1-10 to the partition key) to spread data evenly across shards
B) Enable Kinesis Data Streams Enhanced Fan-Out for the Flink consumer to get dedicated 2MB/sec throughput per shard
C) Switch from Kinesis Data Streams to Amazon SQS FIFO queues for better load distribution
D) Increase the Flink application parallelism to match the new shard count and configure auto-scaling for the Flink application's KPU (Kinesis Processing Units)
E) Replace the Flink application with a Lambda function consumer

**Answer: A, D**

**Explanation:** The root cause is two-fold: hot partition keys causing uneven shard utilization and insufficient processing capacity during peaks. Adding a random suffix to partition keys (e.g., `popular-page-1` through `popular-page-10`) distributes hot key data across multiple shards, eliminating the hotspot. Doubling the shard count to 200 provides more aggregate capacity (A). The Flink application's parallelism must match the shard count to consume all shards efficiently, and KPU auto-scaling ensures the application scales with traffic spikes (D). Enhanced Fan-Out (B) provides dedicated throughput per consumer but doesn't solve the hot partition key problem — the bottleneck is uneven distribution, not per-shard read throughput. SQS FIFO (C) has a 300 messages/second limit per group and doesn't support the streaming analytics model. Lambda (E) loses the stateful sessionization capability that Flink provides.

---

### Question 26
A company running a legacy .NET application on Windows Server needs to migrate to AWS. The application uses MSMQ (Microsoft Message Queuing) for asynchronous communication between components, stores session state in SQL Server, and has a shared file system accessed via SMB. The application cannot be re-architected immediately, but the company wants to use managed services where possible and maintain high availability across 2 AZs.

What is the correct migration architecture?

A) Run the application on EC2 Windows instances in an Auto Scaling group across 2 AZs. Replace MSMQ with Amazon MQ for ActiveMQ (which supports the MSMQ API via bridge). Migrate SQL Server to Amazon RDS for SQL Server Multi-AZ. Use Amazon FSx for Windows File Server Multi-AZ for the SMB file share
B) Run the application on EC2 Windows instances. Keep MSMQ on EC2. Migrate SQL Server to Aurora PostgreSQL with Babelfish. Use EFS for the SMB file share
C) Containerize the application in Windows containers on ECS Fargate. Use Amazon SQS for messaging. Migrate SQL Server to RDS for SQL Server. Use S3 for file storage with S3 gateway endpoint
D) Run the application on EC2 Windows instances. Replace MSMQ with Amazon SQS. Migrate SQL Server to RDS for SQL Server Multi-AZ. Use FSx for Windows File Server Multi-AZ for the SMB file share

**Answer: D**

**Explanation:** Since the application cannot be re-architected immediately but should use managed services where possible, EC2 Windows instances in an ASG across 2 AZs provide the lift-and-shift compute layer. Amazon SQS can replace MSMQ for asynchronous messaging — the application code changes are minimal (just the queue endpoint/SDK calls), and SQS is fully managed and highly available. RDS for SQL Server Multi-AZ provides managed database HA without OS-level patching. FSx for Windows File Server Multi-AZ provides a managed SMB-compatible file share. Amazon MQ with ActiveMQ (A) doesn't support the MSMQ API natively, and there is no MSMQ bridge — this is misleading. Aurora PostgreSQL with Babelfish (B) may have compatibility issues with the existing .NET SQL Server queries and stored procedures, and EFS uses NFS, not SMB. Windows Fargate containers (C) have limited support and containerizing a legacy .NET app requires significant re-architecture work.

---

### Question 27
A retail company processes online orders through an API Gateway → Lambda → DynamoDB architecture. During Black Friday, they expect order volume to jump from 1,000 to 50,000 requests per second. The Lambda functions currently have a 10-second average execution time because they perform multiple DynamoDB operations and call an external payment API (average 3-second response time). The current Lambda concurrency limit is 1,000 (account default). The DynamoDB table uses on-demand capacity mode.

What changes are needed to handle the Black Friday load WITHOUT increasing Lambda execution time? **(Choose THREE.)**

A) Request a Lambda concurrency limit increase to at least 50,000 concurrent executions (50,000 RPS × 10 seconds average duration = 500,000 peak concurrent, but consider API Gateway integration timeout)
B) Implement Lambda Provisioned Concurrency of 500,000 to eliminate cold starts
C) Add an SQS queue between API Gateway and Lambda to buffer requests, converting the synchronous API to an asynchronous pattern where the API returns a 202 Accepted with an order ID, and clients poll for results
D) Use DynamoDB DAX for read operations to reduce DynamoDB latency and lower Lambda execution time
E) Implement connection pooling for the external payment API calls and use Lambda extensions to maintain persistent HTTP connections
F) Switch DynamoDB to provisioned capacity mode with auto-scaling to save costs at the baseline load

**Answer: A, C, E**

**Explanation:** At 50,000 RPS with 10-second execution times, the concurrent Lambda invocations would be approximately 500,000 — far exceeding the default 1,000 limit. Requesting a limit increase is essential (A). However, even with increased limits, synchronous processing at this scale is challenging. Converting to an asynchronous pattern with SQS decouples the API response from processing — API Gateway writes to SQS (via service integration) and returns immediately, while Lambda consumers process at a controlled rate (C). For the external payment API calls, connection pooling with Lambda extensions maintains persistent connections across invocations, reducing the 3-second latency by avoiding TCP/TLS handshake overhead (E). Provisioned Concurrency at 500,000 (B) is prohibitively expensive and unnecessary with the async pattern. DAX (D) helps read operations but the scenario describes writes (order processing). Switching to provisioned mode (F) is risky before a spike — on-demand handles unpredictable scaling better.

---

### Question 28
TechGlobal has a multi-account environment where developers in the Workloads-Dev OU need to experiment freely but must not be able to create resources that incur costs above certain thresholds. Specifically: no EC2 instances larger than m5.xlarge, no RDS instances larger than db.m5.large, no NAT Gateways (they should use VPC endpoints instead), no Elastic IPs (they should use private endpoints), and no AWS Marketplace subscriptions. However, these restrictions should NOT apply to the Workloads-Prod OU.

Which SCP implementation achieves this with the LEAST number of policies?

A) A single SCP attached to the Workloads-Dev OU with multiple deny statements: deny `ec2:RunInstances` where `ec2:InstanceType` is not in the allowed list, deny `rds:CreateDBInstance` where `rds:DatabaseClass` exceeds db.m5.large, deny `ec2:CreateNatGateway`, deny `ec2:AllocateAddress`, and deny `aws-marketplace:Subscribe`
B) Five separate SCPs — one for each restriction — attached to the Workloads-Dev OU
C) A single SCP attached to the root OU with a condition that excludes the Workloads-Prod OU using `aws:PrincipalOrgPaths`
D) An IAM permission boundary applied to all IAM roles in the Workloads-Dev OU accounts that restricts the specified actions

**Answer: A**

**Explanation:** A single SCP with multiple deny statements attached to the Workloads-Dev OU provides all required restrictions in one policy. The deny for `ec2:RunInstances` uses a `StringNotLike` condition on `ec2:InstanceType` to block instances larger than allowed. RDS class restrictions use similar conditions. NAT Gateway creation, Elastic IP allocation, and Marketplace subscriptions are denied outright. Since the SCP is only attached to the Workloads-Dev OU, the Workloads-Prod OU is unaffected. Five separate SCPs (B) achieve the same result but with more policies to manage, and organizations have a limit on SCPs per target. A root-level SCP with exclusions (C) is more fragile — any new OU would inherit the restrictions, and `aws:PrincipalOrgPaths` condition complexity increases maintenance burden. Permission boundaries (D) need to be attached to every role in every account, which doesn't scale and can be overridden by account administrators.

---

### Question 29
An insurance company needs to implement AWS Config conformance packs across 200 accounts to validate compliance with their internal security framework. The framework includes 50 Config rules covering encryption, network security, IAM, and logging. Some rules require custom Lambda functions for evaluation (e.g., checking that all ALBs have WAF associated). The conformance packs must be deployed from a central account, and the compliance results must be available in the delegated administrator account for reporting.

What is the MOST efficient deployment and monitoring strategy?

A) Register a delegated administrator for AWS Config, create organization conformance packs from the delegated administrator account that reference both managed and custom Config rules, deploy custom Lambda functions to each account using CloudFormation StackSets, and use Config aggregator in the delegated administrator account for consolidated compliance reporting
B) Create conformance packs individually in each account using a CodePipeline that runs across all accounts
C) Use Security Hub custom standards to define the 50 rules and deploy via Security Hub organization configuration
D) Deploy conformance packs using Terraform with a workspace per account and aggregate compliance data in a central S3 bucket

**Answer: A**

**Explanation:** Organization conformance packs deployed from a delegated administrator account automatically propagate to all member accounts in the organization. This supports both AWS managed rules and custom rules backed by Lambda functions. The custom Lambda functions must exist in each member account for evaluation, so CloudFormation StackSets deploy them at scale. The Config aggregator in the delegated administrator account collects compliance data from all accounts, providing consolidated reporting. CodePipeline per account (B) requires significant pipeline infrastructure and maintenance. Security Hub custom standards (C) don't replace Config conformance packs — they're separate constructs. Terraform with per-account workspaces (D) adds infrastructure-as-code management overhead and S3-based aggregation has latency compared to the native Config aggregator.

---

### Question 30
A gaming company has a global presence with players in North America, Europe, and Asia-Pacific. They use CloudFront for static assets and API Gateway for game state APIs. The game state is stored in DynamoDB Global Tables across 3 regions (us-east-1, eu-west-1, ap-northeast-1). They need to ensure that game state writes from a player are directed to the nearest DynamoDB region and reads are always from the local region. Conflict resolution must favor the most recent write. API latency must be under 50ms for reads and under 200ms for writes.

What architecture achieves these latency requirements?

A) Use Route 53 latency-based routing to direct API requests to the nearest regional API Gateway. Each regional API Gateway invokes a Lambda function that writes to the local DynamoDB Global Table replica. DynamoDB Global Tables use last-writer-wins conflict resolution natively. DAX clusters in each region serve reads with single-digit millisecond latency
B) Use CloudFront with Lambda@Edge to determine the player's region and route to the appropriate DynamoDB table
C) Use a single API Gateway in us-east-1 with a global accelerator endpoint, writing to DynamoDB in us-east-1 with global tables replicating to other regions
D) Use AppSync with a DynamoDB resolver and configure multi-region deployment with Route 53 failover routing

**Answer: A**

**Explanation:** Route 53 latency-based routing directs each player's API request to the nearest regional API Gateway endpoint, minimizing network latency. The regional Lambda function writes to the local DynamoDB Global Tables replica, which automatically replicates to other regions using last-writer-wins conflict resolution (most recent write prevails). DAX clusters in each region provide single-digit millisecond cached reads, well under the 50ms requirement. Writes to the local DynamoDB replica are typically under 10ms, with the Lambda execution overhead keeping total write latency well under 200ms. Lambda@Edge (B) has a 5-second timeout and isn't designed for API routing logic. A single API Gateway (C) means all writes go to us-east-1, adding 100-200ms of cross-region latency for European and Asian players. AppSync with failover routing (D) doesn't provide active-active multi-region writes.

---

### Question 31
A company needs to implement a comprehensive tagging strategy enforcement across their 150-account AWS Organization. They have defined tag policies with specific allowed values for the `DataClassification` tag (`Public`, `Internal`, `Confidential`, `Restricted`) and want to prevent users from creating resources with non-compliant tag values. However, they discovered that tag policies only enforce compliance for a subset of resource types and do not cover all the services they use. For services not covered by tag policies, they need an alternative enforcement mechanism.

What combination of approaches provides comprehensive tag enforcement? **(Choose TWO.)**

A) Use tag policies with `enforced_for` for supported resource types and complement with SCPs using `aws:RequestTag` condition keys for the remaining services
B) Use only SCPs with `aws:RequestTag` and `aws:TagKeys` condition keys for all services, since SCPs can enforce tags universally
C) Deploy AWS Config custom rules that evaluate tag compliance on all resource types and auto-remediate by adding missing tags using SSM Automation
D) Implement a Lambda function triggered by CloudTrail events that adds mandatory tags to newly created resources
E) Use Service Catalog exclusively for all resource provisioning, with TagOptions enforcing mandatory tags

**Answer: A, C**

**Explanation:** Tag policies with `enforced_for` provide native preventive enforcement for supported resource types (EC2, S3, RDS, etc.) by blocking tag operations with non-compliant values. For services not covered by tag policies, SCPs with `aws:RequestTag` condition keys can deny `Create*` and `RunInstances`-type API calls that don't include compliant tags — this covers the gap (A). However, neither tag policies nor SCPs can enforce tags on resources created by AWS-managed services or those created before the policies were applied. AWS Config custom rules provide detective controls across ALL resource types and auto-remediation via SSM Automation adds missing tags retroactively (C). SCPs alone (B) cannot cover all services because not all API actions support tag-on-create. Lambda on CloudTrail (D) has delay and error handling complexity. Service Catalog (E) is too restrictive and doesn't cover all provisioning methods.

---

### Question 32
VaultSec Financial needs to rotate all RDS database credentials across 30 accounts automatically every 30 days. The credentials are stored in AWS Secrets Manager. Each RDS instance uses a different master username. When credentials are rotated, applications using these databases must seamlessly transition to the new credentials without downtime. The applications are running on ECS Fargate tasks and Lambda functions.

What rotation architecture ensures zero-downtime credential rotation?

A) Use Secrets Manager alternating users rotation strategy — each secret maintains two sets of credentials (current and previous). The rotation Lambda creates a new user (`clone` of the current), updates the secret's `AWSCURRENT` staging label to the new credentials, and the previous credentials remain active as `AWSPREVIOUS` until the next rotation. ECS tasks and Lambda functions use the Secrets Manager SDK with caching to automatically pick up the new credentials
B) Use Secrets Manager single-user rotation strategy and configure all applications with retry logic to handle brief authentication failures during rotation
C) Store credentials in Systems Manager Parameter Store and use a Lambda function to update parameters and restart all ECS tasks simultaneously
D) Use IAM database authentication for all RDS instances, eliminating the need for credential rotation

**Answer: A**

**Explanation:** The alternating users rotation strategy is the zero-downtime approach. Secrets Manager maintains two database users — when rotation occurs, a new password is created for the alternate user, and the `AWSCURRENT` label is moved to the new credentials while the previous credentials remain valid under `AWSPREVIOUS`. Applications using the Secrets Manager SDK with caching will retrieve the new credentials on their next cache refresh. Since both sets of credentials remain valid during the transition period, there is no moment where authentication fails. The single-user strategy (B) has a brief window where the old password is invalid but the new one isn't yet committed, causing authentication failures. Parameter Store (C) doesn't have native rotation and restarting all ECS tasks causes downtime. IAM database authentication (D) is a valid approach but has connection limits and isn't supported for all RDS engines/configurations — it also doesn't address the requirement to rotate the existing credential-based setup.

---

### Question 33
An enterprise has implemented AWS CloudFormation StackSets with service-managed permissions to deploy a standard set of infrastructure (VPC, subnets, security groups, IAM roles) across all accounts in the Workloads OU. The StackSet updates are failing in 5 out of 80 accounts. CloudFormation events show `ROLLBACK_COMPLETE` status in the failed accounts. The infrastructure team needs to understand why these 5 accounts are failing and implement a strategy to handle StackSet deployment failures across the organization.

What troubleshooting and resilience strategy should be implemented? **(Choose TWO.)**

A) Check the CloudFormation Stack events in each of the 5 failed accounts by assuming the `AWSCloudFormationStackSetExecutionRole` to identify the specific resource creation failure, which could be caused by existing resources with conflicting names, service quotas, or missing prerequisites
B) Configure the StackSet's `failure_tolerance_percentage` to allow up to 10% of accounts to fail and `max_concurrent_percentage` to control the deployment rate. Enable automatic deployment with region concurrency set to `SEQUENTIAL` for safer rollouts
C) Delete and recreate the StackSet instances in the failed accounts
D) Increase the IAM permissions of the StackSet administration role to AdministratorAccess
E) Disable rollback on failure for the StackSet to leave resources in place for debugging

**Answer: A, B**

**Explanation:** The first step is diagnosing the failure by examining CloudFormation Stack events in the failed accounts. Common causes include naming conflicts (resources with hard-coded names that already exist), service quota limits (VPC per region, EIP limits), or missing prerequisites. The `AWSCloudFormationStackSetExecutionRole` in each member account provides the access needed to investigate (A). For resilience, configuring failure tolerance allows the StackSet operation to succeed even if a percentage of accounts fail, preventing a few problematic accounts from blocking the entire organization deployment. Sequential region concurrency reduces blast radius during rollouts, and max concurrent percentage controls the deployment rate (B). Deleting and recreating (C) doesn't address the root cause. AdministratorAccess (D) is unlikely to be the issue since service-managed permissions already grant necessary access. Disabling rollback (E) is a useful debugging technique but isn't available for StackSet instances.

---

### Question 34
A pharmaceutical company needs to ensure that all API calls across their 100-account AWS Organization are logged, tamper-proof, and retained for 7 years for regulatory compliance. They also need the ability to query these logs for security investigations within minutes. The total log volume is approximately 2TB per day.

What logging architecture meets the retention, integrity, and query requirements?

A) Create an organization trail in CloudTrail that logs to a centralized S3 bucket in the Log Archive account with log file validation enabled. Configure S3 Object Lock in compliance mode with a 7-year retention period. For querying, enable CloudTrail Lake with an event data store that retains events for 7 years, allowing SQL-based queries within seconds
B) Create an organization trail logging to S3 with server-side encryption. Use Athena with partition projection for querying. Set S3 lifecycle rules to transition logs to Glacier after 90 days with a 7-year expiration
C) Create individual trails in each account logging to local S3 buckets with 7-year retention. Aggregate logs using S3 replication to a central bucket for querying
D) Enable CloudTrail Insights for anomaly detection and store events in CloudWatch Logs with a 7-year retention period

**Answer: A**

**Explanation:** The organization trail captures all API calls from all 100 accounts centrally. S3 Object Lock in compliance mode ensures tamper-proof retention for exactly 7 years — no one, including the root account, can delete or modify locked objects before the retention period expires. CloudTrail Lake provides SQL-based querying of CloudTrail events within seconds, meeting the "within minutes" investigation requirement. The 7-year event data store in CloudTrail Lake eliminates the need for separate query infrastructure. Option B's Glacier transition makes logs inaccessible for quick queries after 90 days, and Athena requires table setup and partitioning. Individual trails (C) create management overhead and lack the integrity guarantees of Object Lock. CloudWatch Logs (D) retention for 7 years would be extremely expensive for 2TB/day and doesn't provide tamper-proof guarantees.

---

### Question 35
A media streaming company needs to deploy an application stack to 10 AWS regions simultaneously. The stack includes Lambda functions, API Gateway, DynamoDB tables, and CloudFront distributions. They use CloudFormation for infrastructure as code. The deployment must be consistent across all regions, with the ability to roll back all regions if any single region fails. Custom resources in the template require Lambda functions that aren't available in all regions.

What deployment strategy provides consistent multi-region deployment with rollback capability?

A) Use CloudFormation StackSets with `SEQUENTIAL` region ordering and a failure tolerance of 0. Package Lambda deployment packages in an S3 bucket in each region using a CI/CD pipeline pre-deployment step. The StackSet references region-specific S3 URLs using `!Sub` with `AWS::Region`. If any region fails, the entire operation fails and rolls back
B) Deploy separate CloudFormation stacks to each region using a CodePipeline with 10 parallel deployment stages
C) Use Terraform with a multi-region provider configuration and `terraform apply` across all regions
D) Use AWS CDK with a `PipelineStack` that deploys to all regions sequentially, rolling back on failure

**Answer: A**

**Explanation:** StackSets provide native multi-region deployment with built-in failure tolerance controls. Setting failure tolerance to 0 with sequential ordering means if any region fails, the operation stops and rolls back, ensuring consistency. Lambda deployment packages must exist in each region's S3 bucket because Lambda can only deploy code from a bucket in the same region — the CI/CD pre-deployment step handles this. The `!Sub` function with `AWS::Region` dynamically resolves the correct S3 bucket URL per region. CodePipeline with parallel stages (B) doesn't provide atomic rollback across regions if one fails. Terraform (C) can deploy multi-region but lacks the native rollback-all-on-failure behavior. CDK Pipeline (D) can orchestrate multi-region deployments but sequential deployment to 10 regions is slow and doesn't provide the same StackSet-level failure tolerance semantics.

---

### Question 36
DataStream Corp needs to implement a cross-account event bus architecture using Amazon EventBridge. The central event bus in the Platform account must receive events from 50 application accounts. Events matching specific patterns must be forwarded to different target accounts — security events to the Security account, cost events to the FinOps account, and operational events to the Operations account. The architecture must prevent any application account from sending events that impersonate another account.

What is the correct EventBridge cross-account architecture? **(Choose TWO.)**

A) Create a custom event bus in the Platform account with a resource-based policy that allows `events:PutEvents` from the organization (using `aws:PrincipalOrgID`). Configure EventBridge rules on the custom event bus with event patterns matching the `source` and `detail-type` fields, targeting cross-account event buses in the Security, FinOps, and Operations accounts
B) In each application account, create EventBridge rules on the default event bus that send matched events to the Platform account's custom event bus using a cross-account target
C) Include the `account` field in the event pattern matcher to validate that the `source` account in the event matches the actual sending account, preventing impersonation
D) Use SQS queues as intermediaries between accounts instead of direct EventBridge cross-account communication
E) Create IAM roles in the Platform account for each application account to assume before sending events

**Answer: A, B**

**Explanation:** The custom event bus in the Platform account with an organization-scoped resource policy provides centralized event aggregation while restricting access to organization members only (A). EventBridge rules in each application account's default event bus route matched events to the Platform account's custom event bus — this is the standard cross-account pattern where the source account pushes events to the central bus (B). EventBridge automatically includes the `account` field in the event envelope, and since this field is set by the service (not the sender), it inherently prevents impersonation — the event's `account` field always reflects the actual source account. Explicit pattern matching on the `account` field (C) is useful for routing but isn't needed for anti-impersonation since EventBridge already handles this. SQS intermediaries (D) add unnecessary complexity. Per-account IAM roles (E) don't scale and the resource-based policy approach is more appropriate for EventBridge.

---

### Question 37
A company's security team detected that an IAM access key in one of their developer accounts was compromised and used to launch unauthorized EC2 instances in 5 regions. They need to implement an automated incident response that: (1) immediately disables the compromised IAM access key, (2) terminates all EC2 instances launched by the compromised key, (3) revokes all active sessions for the IAM user, and (4) notifies the security team via PagerDuty. The response must trigger automatically when GuardDuty detects a `UnauthorizedAccess:IAMUser/InstanceCredentialExfiltration` finding.

What automation architecture handles this? **(Choose TWO.)**

A) Configure an EventBridge rule matching the GuardDuty finding type. The rule triggers a Step Functions state machine that orchestrates the response: first invokes a Lambda function to disable the access key via `iam:UpdateAccessKey`, then a parallel branch that terminates EC2 instances across all regions using the `ec2:TerminateInstances` API with the access key ID as a filter
B) Attach an inline deny-all IAM policy to the compromised user to revoke all active sessions (since STS tokens check IAM policies in real-time), as part of the Step Functions workflow
C) Use AWS Systems Manager Incident Manager with a response plan that automates the remediation steps
D) Manually investigate each GuardDuty finding and perform remediation steps using the AWS console
E) Configure GuardDuty to automatically remediate findings using its built-in response feature

**Answer: A, B**

**Explanation:** EventBridge captures GuardDuty findings in real-time and triggers a Step Functions state machine for orchestrated response (A). Step Functions provides the workflow coordination needed — disabling the access key prevents new API calls, but existing STS session tokens remain valid until they expire. To revoke active sessions immediately, attaching an inline deny-all policy (with a condition like `aws:TokenIssueTime` before the current time) to the IAM user causes all subsequent API calls using existing tokens to be denied, because IAM evaluates the user's policies on every API call, including those made with temporary credentials (B). The Step Functions workflow can also include parallel Lambda invocations to terminate unauthorized EC2 instances across all regions and call PagerDuty's API for notification. Systems Manager Incident Manager (C) is for incident tracking and runbooks but doesn't provide the same automated remediation orchestration. Manual investigation (D) doesn't meet the automation requirement. GuardDuty (E) does not have a built-in auto-remediation feature.

---

### Question 38
A financial services firm has strict requirements for network segmentation. Their AWS Organization has the following network design: a Network Hub account with a Transit Gateway, an Inspection VPC with AWS Network Firewall, a shared DNS VPC with Route 53 Resolver endpoints, and 30 spoke VPCs across 15 accounts. All DNS queries from spoke VPCs must go through the central DNS resolver, and all internet-bound traffic must pass through the Network Firewall. However, traffic between VPCs in the same security zone (e.g., two production VPCs) should NOT traverse the firewall.

What Transit Gateway routing configuration achieves this? **(Choose TWO.)**

A) Create three Transit Gateway route tables: one for production spoke VPCs, one for non-production spoke VPCs, and one for the Inspection/DNS VPC. Associate each VPC attachment with its corresponding route table
B) In the production route table, add specific routes for other production VPC CIDRs pointing to their attachments (allowing direct communication), and a default route (0.0.0.0/0) pointing to the Inspection VPC attachment for internet-bound traffic
C) Create a single Transit Gateway route table with all VPC routes and use Network Firewall rules to allow/deny traffic based on security zones
D) Use Transit Gateway Connect attachments for GRE tunneling between same-zone VPCs
E) Enable Transit Gateway route table propagation from all attachments to all route tables

**Answer: A, B**

**Explanation:** Separate Transit Gateway route tables per security zone provide the segmentation mechanism. Production VPCs share a route table that includes specific routes to other production VPC CIDRs, enabling direct communication without firewall inspection (A). The default route in the production route table points to the Inspection VPC attachment, ensuring internet-bound and cross-zone traffic traverses the Network Firewall (B). The Inspection VPC's route table has specific routes back to all VPC CIDRs for return traffic. This design achieves the requirement: same-zone traffic bypasses the firewall via specific routes, while internet and cross-zone traffic follows the default route through the firewall. A single route table (C) can't differentiate between same-zone and cross-zone traffic. Connect attachments (D) are for SD-WAN integration, not intra-zone routing. Full propagation (E) would route all traffic directly, bypassing the firewall entirely.

---

### Question 39
An enterprise is migrating from on-premises Splunk to AWS-native security monitoring. They need centralized log aggregation from CloudTrail, VPC Flow Logs, DNS logs, GuardDuty findings, Security Hub findings, and AWS WAF logs across 100 accounts. The solution must support real-time alerting (< 5 minutes), historical analysis over 12 months, and must integrate with their existing SIEM in a hybrid period. Log volume is approximately 5TB per day.

What log aggregation architecture meets all requirements?

A) Configure CloudTrail organization trail to S3, VPC Flow Logs to a central S3 bucket via cross-account delivery, DNS logs via Route 53 Resolver query logging to S3, GuardDuty and Security Hub findings to a central EventBridge bus, and WAF logs to S3 via Kinesis Data Firehose. Use Amazon Security Lake to normalize and centralize all logs in OCSF format, with subscribers for the existing SIEM. Use OpenSearch for real-time dashboards and alerting with a 30-day hot tier and S3-based cold tier for 12-month retention
B) Send all logs to CloudWatch Logs in a central account, create metric filters for alerting, and export to S3 for long-term retention
C) Use Splunk on EC2 with a heavy forwarder architecture, replicating the on-premises setup in AWS
D) Send all logs to Amazon Kinesis Data Streams, process with Lambda, and store in DynamoDB for querying

**Answer: A**

**Explanation:** Amazon Security Lake normalizes security logs from multiple AWS sources into the Open Cybersecurity Schema Framework (OCSF) format, providing a centralized, standardized data lake. It natively ingests CloudTrail, VPC Flow Logs, Route 53 DNS logs, Security Hub findings, and more. The subscriber model allows the existing SIEM to consume normalized data during the hybrid period. OpenSearch provides the real-time alerting and dashboard capability with hot/warm/cold storage tiers — a 30-day hot tier handles real-time analysis while S3-backed cold storage retains 12 months of data cost-effectively. At 5TB/day, CloudWatch Logs (B) would be prohibitively expensive (~$2.50/GB ingestion = $12,500/day). Splunk on EC2 (C) defeats the purpose of migrating to AWS-native services. DynamoDB (D) is not designed for log analytics at this scale and lacks the query capabilities needed for security investigation.

---

### Question 40
A company wants to implement a Service Control Policy strategy that follows the "deny list" pattern. They want to start with a permissive environment and gradually add restrictions. Their OU structure is: Root → Security OU, Infrastructure OU, Workloads OU (Prod, Non-Prod), Sandbox OU, Suspended OU. The Suspended OU should deny ALL actions except what's needed to investigate and close the account.

Which SCP must be attached to the Suspended OU?

A) A single SCP with `"Effect": "Deny", "Action": "*", "Resource": "*"` with a `Condition` block using `StringNotLike` on `aws:PrincipalARN` that exempts only the OrganizationAccountAccessRole and a specific `BreakGlass-Investigation` role. Keep the default `FullAWSAccess` SCP attached
B) Remove the `FullAWSAccess` SCP from the Suspended OU and attach no other SCPs
C) Attach an SCP that denies all actions with no exceptions
D) Attach an SCP that only allows `iam:*` and `organizations:*` actions

**Answer: A**

**Explanation:** The deny-list pattern keeps the `FullAWSAccess` SCP attached (providing the implicit allow for all actions) and adds explicit deny SCPs for restrictions. For the Suspended OU, a deny-all SCP effectively blocks all actions, but the condition exempting the OrganizationAccountAccessRole (used by the management account for administration) and a BreakGlass-Investigation role (used for forensic investigation of the suspended account) ensures the account can still be accessed for required activities like reviewing resources before closure. Removing `FullAWSAccess` (B) would result in an implicit deny of all actions, but this also prevents the management account from managing the suspended account and doesn't allow investigation access. Denying all with no exceptions (C) prevents any access, including administrative actions needed for account closure. Allowing only IAM and Organizations (D) uses an allow-list pattern inconsistent with the deny-list strategy and provides too much access for a suspended account.

---

### Question 41
A company has been running AWS Config for 6 months across 80 accounts. They discover that their Config costs have reached $45,000/month, primarily due to configuration item (CI) recording. Investigation reveals that Config is recording ALL resource types, including high-change-frequency resources like Lambda function versions, CloudFormation stacks during deployments, and Auto Scaling group configurations during scaling events.

What changes reduce Config costs while maintaining compliance visibility? **(Choose TWO.)**

A) Switch from continuous recording to periodic recording (every 24 hours) for non-critical resource types, while maintaining continuous recording only for security-critical resources (IAM, Security Groups, S3 bucket policies, KMS keys)
B) Configure Config to record only specific resource types relevant to compliance requirements instead of all resource types
C) Disable AWS Config in non-production accounts and rely on SCPs for preventive controls
D) Use AWS Config delivery channel to reduce the S3 delivery frequency
E) Enable Config recording exclusion for high-frequency resources like AWS::Lambda::FunctionVersion and AWS::CloudFormation::Stack

**Answer: A, B**

**Explanation:** AWS Config charges per configuration item (CI) recorded. Switching to periodic recording for non-critical resource types dramatically reduces CI volume — a resource that changes 100 times per day generates 100 CIs in continuous mode but only 1 CI in periodic mode (A). Additionally, limiting recording to specific resource types relevant to compliance (e.g., security groups, S3 buckets, IAM roles, RDS instances, EC2 instances) eliminates CIs for irrelevant resource types entirely (B). Together, these changes can reduce Config costs by 70-90%. Disabling Config in non-production (C) creates compliance blind spots. The delivery channel frequency (D) affects S3 delivery timing, not CI recording costs. Recording exclusion (E) for specific resource types is effectively part of option B — selecting only the resources you need to record.

---

### Question 42
NeuralNet AI runs machine learning training jobs on GPU instances across 3 accounts (ML-Development, ML-Staging, ML-Production). They use SageMaker for training and need to ensure that model artifacts produced in ML-Development are promoted to ML-Staging for validation, then to ML-Production for deployment. The model artifacts are stored in S3, and the model registry must track all model versions, their approval status, and which account produced each version. Only the ML-Production account should be able to deploy models that have been approved in ML-Staging.

What cross-account ML pipeline architecture enforces this promotion workflow?

A) Use SageMaker Model Registry in a shared ML-Governance account. The ML-Development account registers model versions as `PendingManualApproval`. The ML-Staging account's validation pipeline evaluates the model and updates the status to `Approved` or `Rejected`. The ML-Production account's deployment pipeline has an IAM policy that only allows `sagemaker:CreateModel` for model versions with `Approved` status from the registry. S3 cross-account access with bucket policies enables artifact sharing
B) Copy model artifacts between S3 buckets in each account using S3 replication and manage approval status in a DynamoDB table
C) Use CodePipeline with cross-account actions to promote models between accounts, storing approval status as CodePipeline manual approval gates
D) Share the SageMaker Studio domain across accounts using RAM and manage approvals via IAM permissions

**Answer: A**

**Explanation:** SageMaker Model Registry provides native model versioning, approval workflow, and lineage tracking. Centralizing the registry in a shared governance account ensures all three accounts reference a single source of truth for model versions and their approval status. The cross-account workflow enforces the promotion chain: Development → PendingManualApproval → Staging validates and sets Approved/Rejected → Production can only deploy Approved models. IAM conditions on the `sagemaker:CreateModel` action in the Production account can reference the model version's approval status, providing enforcement. S3 cross-account bucket policies with `aws:PrincipalOrgID` enable artifact access. DynamoDB for approval tracking (B) lacks native ML metadata and lineage. CodePipeline (C) provides CI/CD but not the model-specific metadata, versioning, and registry capabilities. SageMaker Studio domains (D) cannot be shared via RAM across accounts.

---

### Question 43
A company has implemented AWS Organizations with 60 accounts. Their CTO wants to track cost optimization opportunities across all accounts from a single dashboard. They need to see: Reserved Instance (RI) coverage and utilization across the organization, Savings Plans recommendations, rightsizing recommendations for EC2 instances, and unattached EBS volumes and idle load balancers. The data must be refreshable daily and accessible to the FinOps team in a dedicated Cost Management account.

What is the MOST operationally efficient approach?

A) Enable AWS Cost Explorer at the organization level in the management account, enable RI and Savings Plans recommendations, enable EC2 rightsizing recommendations with CloudWatch agent metrics integration, and create a delegated administrator for AWS Cost Explorer in the Cost Management account. Use AWS Cost Anomaly Detection monitors for organization-level anomaly detection
B) Deploy Trusted Advisor across all accounts and aggregate findings in a central S3 bucket using Lambda
C) Use CloudWatch metrics with custom dashboards to track resource utilization across all accounts
D) Deploy a third-party cost management tool (CloudHealth/Apptio) with cross-account IAM roles

**Answer: A**

**Explanation:** AWS Cost Explorer at the organization level provides consolidated RI/Savings Plans coverage, utilization, and recommendations across all member accounts from a single view. EC2 rightsizing recommendations use CloudWatch metrics (including memory utilization when the agent is installed) to identify oversized instances. The delegated administrator feature for AWS Cost Explorer allows the FinOps team in the Cost Management account to access these insights without requiring management account credentials. Cost Anomaly Detection provides ML-powered anomaly detection across the organization. Trusted Advisor aggregation (B) requires per-account API calls and custom aggregation infrastructure. CloudWatch metrics (C) provide raw utilization data but not cost-specific recommendations. Third-party tools (D) work but add licensing costs and are not the most operationally efficient when AWS-native tools meet the requirements.

---

### Question 44
A healthcare organization needs to implement a data perimeter strategy for their AWS Organization. They want to ensure that: (1) data can only be accessed by identities within the organization, (2) data can only be accessed from network locations within the organization's VPCs or trusted on-premises networks, and (3) data can only be stored in approved AWS services (S3, RDS, DynamoDB — not EC2 instance store or EBS snapshots shared publicly).

What combination of controls implements this data perimeter? **(Choose THREE.)**

A) Use `aws:PrincipalOrgID` condition in S3 bucket policies and KMS key policies to restrict access to organization identities only
B) Use VPC endpoint policies with `aws:PrincipalOrgID` condition and S3 bucket policies with `aws:SourceVpce` condition to restrict access to organization network locations
C) Apply SCPs denying `ec2:ModifySnapshotAttribute` with `"Add": {"Group": "all"}` to prevent public EBS snapshot sharing, and deny `s3:PutBucketPolicy` actions that would grant access to principals outside the organization
D) Use AWS PrivateLink for all service access and disable public internet access in all VPCs
E) Configure AWS Network Firewall to inspect all outbound traffic and block data exfiltration
F) Enable Amazon Macie across all accounts to detect sensitive data exposure

**Answer: A, B, C**

**Explanation:** A comprehensive data perimeter has three dimensions: identity, network, and resource. The `aws:PrincipalOrgID` condition in resource policies ensures only organization identities can access data — the identity perimeter (A). VPC endpoint policies combined with `aws:SourceVpce` conditions in bucket policies ensure data can only be accessed from approved network locations — the network perimeter (B). SCPs preventing public EBS snapshot sharing and restricting S3 bucket policies from granting external access form the resource perimeter — controlling how data can be stored and shared (C). PrivateLink (D) addresses network but not identity or resource perimeters and disabling public internet may break legitimate use cases. Network Firewall (E) can inspect traffic but can't enforce identity-level controls on AWS service API calls. Macie (F) is a detective control for sensitive data discovery, not a preventive data perimeter control.

---

### Question 45
QuantumPay processes 100,000 payment transactions per hour through their payment processing pipeline. They use a Step Functions Express workflow for transaction processing. Each execution calls 4 Lambda functions sequentially: validation, fraud check, payment processing, and notification. The fraud check Lambda calls an external ML endpoint with a 2-second average response time. During peak hours, the fraud check Lambda occasionally times out at 15 seconds, causing the entire transaction to fail. They need 99.99% success rate.

What architecture improvements increase reliability? **(Choose TWO.)**

A) Implement a circuit breaker pattern using Step Functions' built-in error handling — add retry with exponential backoff on the fraud check step (3 retries, 2-second initial interval, 2x backoff), and configure a fallback to a simplified rule-based fraud check Lambda if all retries fail
B) Increase the Lambda timeout to 5 minutes to prevent timeouts
C) Add an SQS queue before the fraud check step and process fraud checks asynchronously with a separate consumer
D) Cache fraud check results in ElastiCache Redis with a TTL of 5 minutes — for repeat transactions from the same customer within the TTL, skip the external ML call and use the cached result
E) Replace Step Functions Express with Standard workflows for better reliability

**Answer: A, D**

**Explanation:** The retry with exponential backoff handles transient timeout failures, and the fallback to a rule-based fraud check ensures transactions complete even when the external ML endpoint is degraded — this circuit breaker pattern dramatically improves reliability (A). Caching fraud check results in ElastiCache reduces calls to the external ML endpoint for repeat transactions, lowering latency and reducing the chance of timeouts during peak hours. Since fraud patterns for the same customer don't change within minutes, a 5-minute TTL is appropriate (D). Simply increasing the timeout (B) doesn't address the reliability issue — it just extends the wait before failure. Adding SQS (C) breaks the synchronous transaction flow required for payment processing. Standard workflows (E) have higher latency and cost compared to Express workflows and don't address the external endpoint reliability issue.

---

### Question 46
An aerospace company needs to implement AWS GovCloud connectivity for their classified workloads. They have existing commercial AWS accounts in the standard partition. Some workloads run in commercial regions and need to communicate with GovCloud workloads over private connections. Data classification requires that no GovCloud data traverses the public internet. They also need unified identity management across both partitions.

What architecture addresses the cross-partition connectivity and identity requirements? **(Choose TWO.)**

A) Establish AWS Direct Connect connections to both the commercial and GovCloud regions from their on-premises data center, and route traffic between the two environments through the on-premises network
B) Create a VPC peering connection between the commercial and GovCloud VPCs
C) Implement separate IAM Identity Center instances in each partition — one in commercial and one in GovCloud — both federating with the same on-premises Active Directory via SAML, providing unified identity through the common IdP
D) Use Transit Gateway inter-region peering between commercial and GovCloud regions
E) Use AWS PrivateLink to create cross-partition service endpoints

**Answer: A, C**

**Explanation:** GovCloud is a separate AWS partition — there is no direct VPC peering or Transit Gateway peering between commercial and GovCloud partitions. The only way to establish private connectivity between the two environments is through Direct Connect connections to each partition, with traffic routed through the on-premises network or a colocation facility (A). For identity management, IAM Identity Center in each partition can federate with the same on-premises Active Directory, providing a unified identity experience where users authenticate against the same IdP regardless of which partition they're accessing (C). VPC peering (B) does not work across AWS partitions. Transit Gateway peering (D) also does not work across partitions. PrivateLink (E) cannot create cross-partition endpoints. The key architectural principle is that cross-partition communication must go through an intermediate network outside of AWS.

---

### Question 47
A retail company implemented cost allocation tags 3 months ago, but their finance team reports that 30% of AWS costs cannot be attributed to any business unit because resources are missing the `BusinessUnit` tag. The majority of untagged resources are EC2 instances, EBS volumes created by Auto Scaling groups, and Lambda functions deployed via CI/CD pipelines. They need a solution that both remediates existing untagged resources and prevents future untagged resource creation.

What comprehensive approach addresses both remediation and prevention? **(Choose THREE.)**

A) Implement an SCP that denies `ec2:RunInstances`, `lambda:CreateFunction`, and `lambda:TagResource` unless the `BusinessUnit` tag is present, using the `aws:RequestTag/BusinessUnit` condition key. For Auto Scaling groups, configure launch templates with the required tags and enable tag propagation
B) Deploy an AWS Config rule that detects resources missing the `BusinessUnit` tag and triggers an SSM Automation document that tags resources based on the creating IAM principal's department (looked up from IAM tags)
C) Use Tag Editor in the Resource Groups console to bulk-add missing `BusinessUnit` tags to existing untagged resources across all accounts
D) Modify CI/CD pipelines to include the `BusinessUnit` tag in all CloudFormation templates and SAM templates as a required parameter with no default value
E) Send weekly emails to account owners listing their untagged resources
F) Use AWS Config advanced queries to generate reports of untagged resources for finance

**Answer: A, B, D**

**Explanation:** SCPs provide preventive control by blocking resource creation without required tags. For EC2 instances, the SCP uses `aws:RequestTag/BusinessUnit` condition on `ec2:RunInstances`. Auto Scaling groups must use launch templates with tags and tag propagation enabled so volumes inherit tags (A). For existing untagged resources, an AWS Config rule with SSM Automation remediation can automatically tag resources by looking up the creating principal's department from IAM user/role tags — this scales across accounts without manual intervention (B). Modifying CI/CD pipelines ensures all future deployments include required tags as a mandatory parameter in CloudFormation/SAM templates — failing the deployment if the tag is missing (D). Tag Editor (C) is a manual tool that doesn't scale across 200+ accounts. Weekly emails (E) are not automated remediation. Config advanced queries (F) are reporting, not remediation.

---

### Question 48
A company is designing a multi-account strategy for a new digital banking platform. They need to separate concerns across accounts while minimizing operational overhead. The platform includes: customer-facing APIs, internal microservices, a data analytics platform, a machine learning pipeline, shared databases, and common infrastructure (networking, DNS, monitoring). They need strict PCI-DSS compliance for the payment processing components.

How should the accounts be organized? **(Choose TWO.)**

A) Create dedicated accounts within the Workloads OU: API-Production, Microservices-Production, Analytics-Production, ML-Production, SharedData-Production, and mirror these in Non-Production child OUs. Place payment processing in a separate PCI-Scoped account with the strictest guardrails
B) Create a single Production account with VPC-level isolation between workload types and security groups for access control
C) Place the PCI-scoped account in a dedicated PCI OU under Workloads with additional SCPs enforcing PCI-DSS requirements: deny non-encrypted storage creation, deny public subnet creation, deny VPC peering with non-PCI accounts, enforce MFA for all console access
D) Create a separate AWS Organization for PCI workloads to achieve complete isolation
E) Use resource-level tagging to distinguish PCI from non-PCI resources within the same account

**Answer: A, C**

**Explanation:** Dedicated accounts per workload type within the Workloads OU provides clear blast radius boundaries, independent IAM policies, separate billing, and service quota isolation. Separating PCI payment processing into its own account reduces the PCI-DSS compliance scope — only that account's infrastructure needs to meet PCI requirements (A). A dedicated PCI OU with restrictive SCPs enforces PCI controls organizationally: denying unencrypted storage prevents data-at-rest violations, denying public subnets prevents unauthorized network exposure, denying VPC peering with non-PCI accounts prevents scope expansion, and requiring MFA aligns with PCI strong authentication requirements (C). A single account (B) creates a massive blast radius and makes PCI scoping impossible. A separate Organization (D) creates operational overhead with duplicate infrastructure and no cross-organization resource sharing. Tag-based separation (E) doesn't provide the account-level isolation that PCI auditors expect and makes compliance validation difficult.

---

### Question 49
A multinational company has accounts across 4 AWS regions. They need to implement DNS resolution that works across all accounts and regions. On-premises DNS servers must be able to resolve AWS private hosted zone records, and VPCs must resolve on-premises domain names. The company has 50 VPCs across 20 accounts, and all VPCs are connected via Transit Gateway. They want to minimize the number of Route 53 Resolver endpoints deployed.

What DNS architecture minimizes endpoint deployment while providing full resolution capability?

A) Deploy Route 53 Resolver inbound and outbound endpoints in a central DNS VPC in each region. Share the Resolver rules with all accounts in the organization using RAM. Associate the private hosted zones with the central DNS VPC. Configure on-premises DNS to forward AWS domain queries to the inbound endpoint IPs. Spoke VPCs use the central DNS VPC's resolver through Transit Gateway routing for DNS traffic
B) Deploy Route 53 Resolver endpoints in every VPC across all 50 VPCs
C) Use Route 53 public hosted zones for all DNS records and configure on-premises DNS to use public resolution
D) Configure DHCP option sets in each VPC to point to the on-premises DNS servers as the primary DNS resolver

**Answer: A**

**Explanation:** A centralized DNS architecture deploys Resolver endpoints only in a hub DNS VPC per region — minimizing endpoint count to 4 regions × 2 endpoint types = 8 total endpoints (versus 100 endpoints for all VPCs). RAM sharing of Resolver rules allows all organization accounts to forward queries for on-premises domains through the central outbound endpoint. Private hosted zones associated with the central DNS VPC resolve for all spoke VPCs through VPC DNS resolution forwarded via Transit Gateway. On-premises DNS servers forward AWS domain queries to the inbound endpoint IPs in the central DNS VPC. Deploying endpoints in every VPC (B) is cost-prohibitive and operationally complex. Public hosted zones (C) expose internal DNS records and don't resolve private resources. DHCP option sets pointing to on-premises (D) route ALL DNS through on-premises, creating latency and a single point of failure for AWS service endpoint resolution.

---

### Question 50
A company runs a critical application that uses an Application Load Balancer in front of an ECS Fargate cluster with 50 tasks. The application team wants to implement a blue/green deployment strategy where they can gradually shift traffic from the current (blue) version to the new (green) version. They need the ability to automatically roll back if the error rate on the green version exceeds 5% during the canary period. The deployment must be fully automated and triggered by a new container image push to ECR.

What deployment architecture provides automated blue/green with canary analysis and auto-rollback?

A) Use AWS CodeDeploy with ECS blue/green deployment. Configure the deployment with a linear traffic shifting configuration (10% every 5 minutes). Define a CloudWatch alarm monitoring the ALB target group's 5xx error rate for the green target group. Configure CodeDeploy to automatically roll back when the alarm triggers. Trigger the deployment via a CodePipeline that starts when a new image is pushed to ECR
B) Create two separate ECS services (blue and green) and manually update the ALB listener rules to shift traffic
C) Use Route 53 weighted routing to split traffic between two ALB endpoints — one for blue, one for green
D) Deploy the new version using ECS rolling updates and monitor manually for errors

**Answer: A**

**Explanation:** CodeDeploy's ECS blue/green deployment natively supports traffic shifting configurations (canary, linear, or all-at-once). The linear 10% every 5 minutes configuration provides gradual rollout. CloudWatch alarms on the green target group's 5xx error rate trigger automatic rollback — CodeDeploy reroutes all traffic back to the blue target group and terminates the green tasks. The CodePipeline integration enables full automation from ECR image push through deployment. Two separate services (B) require manual traffic management and lack automated rollback. Route 53 weighted routing (C) operates at the DNS level with TTL-dependent propagation, making it too slow for rapid rollback. ECS rolling updates (D) don't provide blue/green deployment — they replace tasks in place without the ability to roll back to the previous version quickly.

---

### Question 51
A SaaS company provides dedicated infrastructure for each enterprise customer (tenant) in separate AWS accounts within their organization. They currently have 200 tenant accounts. When onboarding a new customer, they need to: create a new AWS account, deploy baseline infrastructure (VPC, security groups, IAM roles, monitoring), provision the application stack, configure DNS with the customer's custom domain, and set up billing with the customer's cost center tag. The current onboarding process takes 3 days of manual work.

What automation reduces onboarding to under 1 hour?

A) Use Control Tower Account Factory for Terraform (AFT) to automate account creation with a customization pipeline. AFT provisions the account via Control Tower, then executes Terraform modules for baseline infrastructure, application stack, DNS configuration, and billing tag setup. Store tenant-specific configuration in a Git repository that AFT reads during provisioning
B) Create a Lambda function that calls the Organizations `CreateAccount` API and runs a Step Functions workflow for post-creation configuration
C) Use CloudFormation StackSets to deploy everything after manually creating the account
D) Create a custom portal using API Gateway and Lambda that orchestrates account creation through a series of API calls

**Answer: A**

**Explanation:** Account Factory for Terraform (AFT) provides an end-to-end automated pipeline for account provisioning and customization. It integrates with Control Tower for account creation (ensuring guardrails are applied), then executes customization Terraform modules that deploy baseline infrastructure, application stacks, and configuration. Tenant-specific parameters (custom domain, CIDR ranges, cost center tags) are stored in a Git repository as input variables. The entire process is triggered by a Git commit and completes autonomously. A Lambda + Step Functions approach (B) works but requires building and maintaining the entire orchestration logic, error handling, and state management from scratch. StackSets (C) require manual account creation first and don't handle application-level customization. A custom portal (D) replicates what AFT provides natively with significant development effort.

---

### Question 52
A company has 80 AWS accounts and wants to implement a centralized VPC IP address management strategy. Currently, each account team independently selects VPC CIDR ranges, leading to conflicts when VPCs need to be connected via Transit Gateway. They have already experienced 5 CIDR overlap incidents. The solution must automatically allocate non-overlapping CIDRs from a master pool, support multiple environments (prod, non-prod) with different CIDR ranges, and integrate with their Infrastructure-as-Code deployments.

What is the MOST scalable IPAM strategy?

A) Use Amazon VPC IPAM (IP Address Manager) with a delegated administrator in the Network account. Create IPAM pools organized hierarchically — a top-level pool with the organization's supernet, child pools for each environment (prod: 10.0.0.0/8, non-prod: 172.16.0.0/12), and regional sub-pools. Share IPAM pools with the organization via RAM. CloudFormation templates reference the IPAM pool ID for VPC CIDR allocation, which automatically assigns the next available non-overlapping CIDR
B) Maintain a spreadsheet of allocated CIDR ranges and require each team to check for conflicts before creating a VPC
C) Use a Lambda function with a DynamoDB table that acts as a CIDR allocation database, integrated into a Service Catalog product for VPC creation
D) Allocate fixed CIDR ranges per account (e.g., Account 1 = 10.1.0.0/16, Account 2 = 10.2.0.0/16) and document the mapping

**Answer: A**

**Explanation:** Amazon VPC IPAM is the purpose-built service for centralized IP address management in multi-account environments. The hierarchical pool structure (organization → environment → region) provides organized CIDR allocation that prevents overlaps. When a CloudFormation template specifies an IPAM pool ID instead of a static CIDR, IPAM automatically allocates the next available block from the pool. RAM sharing makes the pools available to all organization accounts. The delegated administrator model allows the Network team to manage IPAM without management account access. A spreadsheet (B) doesn't scale and is error-prone. A custom Lambda/DynamoDB solution (C) replicates IPAM functionality with development and maintenance overhead. Fixed per-account allocation (D) wastes address space and doesn't accommodate accounts needing multiple VPCs or varying CIDR sizes.

---

### Question 53
A company is implementing AWS Audit Manager to automate compliance evidence collection for SOC 2 Type II audits across 30 accounts. They need evidence from CloudTrail logs, Config rule evaluations, Security Hub findings, and manual evidence uploads. The assessment must cover controls across all accounts, and evidence must be automatically collected daily. The audit team in a central compliance account needs to review all evidence and generate assessment reports.

What implementation provides automated, cross-account audit evidence collection?

A) Enable AWS Audit Manager in each of the 30 accounts with a delegated administrator in the compliance account. Create an assessment using the SOC 2 framework with automated evidence collection from CloudTrail, Config, and Security Hub data sources. The delegated administrator can view evidence from all member accounts, add manual evidence, and generate assessment reports for the external auditor
B) Configure CloudTrail to log to a central S3 bucket and manually compile evidence into spreadsheets for the audit team
C) Use AWS Artifact to download SOC 2 reports for each account and present them to the auditor
D) Deploy a custom evidence collection application using Lambda functions that query CloudTrail, Config, and Security Hub APIs across all accounts

**Answer: A**

**Explanation:** AWS Audit Manager with a delegated administrator provides centralized, automated compliance evidence collection across all member accounts. The SOC 2 framework template maps controls to automated data sources — CloudTrail for activity logging evidence, Config for configuration compliance evidence, and Security Hub for security posture evidence. Daily automated collection ensures continuous evidence availability. The delegated administrator can review evidence from all 30 accounts in a single interface, add manual evidence for controls that can't be automated, and generate comprehensive assessment reports. Manual compilation (B) is time-intensive and error-prone. AWS Artifact (C) provides AWS's own compliance reports, not the company's compliance evidence. Custom Lambda functions (D) replicate Audit Manager's functionality with significant development effort and ongoing maintenance.

---

### Question 54
An enterprise has a complex VPC architecture with 100 VPCs across 25 accounts. They need to implement a centralized egress architecture where all internet-bound traffic from all VPCs exits through a single Egress VPC. The Egress VPC contains NAT Gateways for IPv4 traffic and a proxy fleet for URL filtering. The existing Transit Gateway connects all VPCs. Some VPCs require direct internet access without URL filtering for specific services (e.g., SageMaker notebook instances downloading packages).

What egress architecture supports both filtered and unfiltered internet access? **(Choose TWO.)**

A) In the Egress VPC, deploy NAT Gateways in public subnets and the proxy fleet in private subnets. Create two Transit Gateway route tables: one for VPCs requiring URL filtering (default route via proxy fleet ENIs) and one for VPCs requiring direct NAT access (default route via NAT Gateway)
B) Configure spoke VPC route tables with a default route (0.0.0.0/0) pointing to the Transit Gateway, which routes to the Egress VPC based on the associated route table
C) Deploy NAT Gateways in every spoke VPC that needs unfiltered access
D) Use AWS Network Firewall in the Egress VPC instead of a proxy fleet and create firewall rule groups with domain-based filtering
E) Configure VPC endpoint policies to control which internet resources each VPC can access

**Answer: A, B**

**Explanation:** Two Transit Gateway route tables enable differentiated egress paths. VPCs requiring URL filtering are associated with a route table whose default route points to the proxy fleet ENIs in the Egress VPC. VPCs requiring direct NAT access use a route table with the default route pointing to the Egress VPC's NAT Gateway attachment. This provides centralized egress with path differentiation (A). All spoke VPCs must have their local route tables configured with 0.0.0.0/0 pointing to the Transit Gateway as the next hop — the Transit Gateway then routes to the Egress VPC based on the spoke's associated route table (B). Deploying NAT Gateways in every spoke VPC (C) defeats the centralized egress purpose. Network Firewall (D) is an alternative to the proxy fleet but the question states the proxy fleet exists. VPC endpoint policies (E) control access to AWS services, not internet egress.

---

### Question 55
A company's AWS Health dashboard shows an upcoming hardware retirement event for 20 EC2 instances across 8 accounts. The instances run in Auto Scaling groups with minimum capacity requirements. The events are scheduled 2 weeks from now. The infrastructure team needs to proactively replace all affected instances before the retirement date without impacting application availability.

What is the MOST operationally efficient replacement strategy?

A) Use AWS Health organizational view in the management account to identify all affected instances across accounts. For instances in Auto Scaling groups, initiate instance refresh with a minimum healthy percentage of 90% in each affected ASG — this launches new instances on healthy hardware before terminating the old ones. Monitor the refresh status via the ASG console or EventBridge events
B) Manually stop and start each instance to migrate it to new hardware
C) Create AMIs of all affected instances, terminate them, and launch replacements from the AMIs
D) Wait for AWS to automatically migrate the instances on the retirement date

**Answer: A**

**Explanation:** AWS Health organizational view provides centralized visibility of health events across all organization accounts. Instance refresh in Auto Scaling groups is the purpose-built mechanism for replacing instances while maintaining availability — it launches new instances (which will be placed on healthy hardware) and terminates old ones gradually, respecting the minimum healthy percentage to avoid capacity drops. A 90% minimum healthy percentage ensures the application maintains near-full capacity during the refresh. Stop/start (B) causes brief downtime per instance and must be done manually for 20 instances. AMI-based replacement (C) is unnecessarily complex for instances in ASGs, which already have launch configurations/templates. Waiting for automatic migration (D) risks application disruption as AWS may terminate instances with minimal notice if the hardware fails before the scheduled date.

---

### Question 56
A research university needs to share specific AWS resources across 15 department accounts. They want to share: (1) a Transit Gateway from the Network account, (2) Resolver rules from the DNS account, (3) License Manager configurations for Microsoft SQL Server licenses, and (4) specific subnets from a shared VPC for departments that don't need their own VPC. They want to avoid managing individual resource shares per department.

What is the simplest RAM sharing architecture?

A) Create one RAM resource share per resource type, enable sharing with the organization in AWS RAM (which requires enabling RAM sharing for the organization in the management account), and add the resources. All accounts in the organization automatically have access. Use RAM permissions to control what recipients can do with shared resources
B) Create individual RAM resource shares — one per department per resource type (60 total shares)
C) Share resources by modifying each resource's policy to allow cross-account access
D) Use CloudFormation StackSets to deploy identical resources in each department account

**Answer: A**

**Explanation:** RAM organization-level sharing dramatically simplifies resource sharing. By enabling RAM sharing for the organization and creating resource shares that share with the organization (or specific OUs), all current and future member accounts automatically receive access. One resource share per resource type keeps the architecture clean and manageable (4 shares total instead of 60). RAM permissions define what recipients can do — e.g., Transit Gateway recipients can create attachments but not modify the TGW, subnet recipients can launch instances but not modify the subnet. Individual shares per department (B) creates management overhead that grows with each new department. Resource policy modification (C) doesn't work for all resource types (Transit Gateway, subnets don't have resource policies). StackSets (D) deploy copies rather than sharing, which defeats the purpose of centralized resources and increases costs.

---

### Question 57
A financial institution runs a real-time fraud detection system. Events from point-of-sale terminals arrive via Kinesis Data Streams at 500,000 events per second during peak hours. Each event must be enriched with customer profile data from DynamoDB, scored by a SageMaker endpoint, and if the fraud score exceeds a threshold, a notification must be sent within 5 seconds. The current architecture uses Lambda consumers for Kinesis, but at peak load, Lambda function concurrency limits are being reached.

What architecture handles 500K events/second with the 5-second latency requirement?

A) Replace the Lambda consumer with a Kinesis Data Analytics (Apache Flink) application that performs in-stream enrichment using async I/O to DynamoDB, calls the SageMaker endpoint for scoring, and writes high-risk events to an SNS topic for notification. Use Flink's native exactly-once processing semantics and auto-scaling KPUs
B) Increase the Lambda concurrency limit and add more Kinesis shards
C) Use SQS FIFO as a buffer between Kinesis and Lambda to manage backpressure
D) Use Kinesis Data Firehose to batch events and process them with Lambda in micro-batches every 5 seconds

**Answer: A**

**Explanation:** Apache Flink (via Kinesis Data Analytics) is designed for high-throughput, low-latency stream processing. It maintains in-memory state for customer enrichment caching (reducing DynamoDB calls), supports async I/O for parallel DynamoDB and SageMaker calls without blocking, and provides auto-scaling KPUs to handle 500K events/second. Flink's exactly-once semantics ensure no events are processed twice. The 5-second latency requirement is achievable because Flink processes events as they arrive without batching delays. Lambda with Kinesis (B) struggles at 500K events/second — even with increased concurrency, the per-shard Lambda invocation model creates processing bottlenecks and the concurrency needed would be enormous. SQS FIFO (C) has a 300 transactions/second/group limit, far below the requirement. Kinesis Data Firehose (D) introduces buffering delays (minimum 60 seconds or 1MB buffer) incompatible with the 5-second requirement.

---

### Question 58
A company uses AWS CloudFormation StackSets to deploy a standard monitoring stack across 100 accounts. The monitoring stack includes CloudWatch alarms, a CloudWatch dashboard, and a subscription filter that sends logs to a central Kinesis Data Stream. After a StackSet update that modified the alarm thresholds, they discovered that 15 accounts show a `OUTDATED` status for their stack instances. The remaining 85 accounts were updated successfully.

What should the operations team do to resolve the OUTDATED instances? **(Choose TWO.)**

A) Investigate the cause by checking CloudFormation stack events in the affected accounts — common causes include: modified resources that have drifted from the template, insufficient permissions in the execution role, or resource dependencies that no longer exist
B) Run a StackSet update operation targeting only the 15 affected accounts using the `OVERWRITE` parameter to force the update
C) Retry the StackSet update with the `--operation-preferences` parameter set to include only the 15 OUTDATED accounts by specifying them in the `Accounts` filter
D) Delete the stack instances in the 15 accounts and let the StackSet recreate them
E) Ignore the OUTDATED status as it will self-resolve on the next StackSet operation

**Answer: A, C**

**Explanation:** OUTDATED status indicates the stack instance doesn't match the latest StackSet template version. The first step is diagnosing why the update failed in those 15 accounts by checking CloudFormation stack events — this reveals specific resource-level failures like permission issues, resource conflicts, or quota limits (A). After addressing the root cause, retrying the StackSet update with the Accounts filter targeting only the 15 affected accounts avoids unnecessarily re-updating the 85 successful accounts (C). There is no `OVERWRITE` parameter in StackSets (B is fabricated). Deleting and recreating stack instances (D) is unnecessarily destructive — it removes all deployed resources and redeploys them, causing downtime. OUTDATED status does not self-resolve (E) — it persists until a successful update operation.

---

### Question 59
A company has a hybrid DNS architecture with an on-premises data center and AWS. Their on-premises applications resolve AWS private hosted zone records via Route 53 Resolver inbound endpoints. AWS applications resolve on-premises domain names via Route 53 Resolver outbound endpoints with forwarding rules. They're now adding a new AWS region (eu-west-1) in addition to their existing us-east-1 region. VPCs in both regions are connected via Transit Gateway inter-region peering.

How should DNS be extended to the new region while minimizing endpoint costs? **(Choose TWO.)**

A) Deploy Route 53 Resolver inbound and outbound endpoints in a central DNS VPC in eu-west-1, connected to the Transit Gateway
B) Share the existing us-east-1 Resolver forwarding rules with the eu-west-1 VPCs using RAM — this makes the rules available without needing outbound endpoints in eu-west-1
C) Associate all eu-west-1 VPCs with the Route 53 private hosted zones for DNS resolution of AWS resources
D) Route all DNS queries from eu-west-1 VPCs through Transit Gateway to the us-east-1 Resolver endpoints to avoid deploying any endpoints in eu-west-1
E) Deploy outbound endpoints only in eu-west-1 (not inbound) since on-premises DNS can forward to the existing us-east-1 inbound endpoints

**Answer: A, C**

**Explanation:** A new region requires its own Route 53 Resolver endpoints because DNS queries from eu-west-1 VPCs need local resolution infrastructure. The inbound endpoint allows on-premises DNS to resolve eu-west-1 private hosted zone records via Direct Connect or VPN to the eu-west-1 region. The outbound endpoint forwards eu-west-1 VPC queries for on-premises domains to the on-premises DNS servers (A). Private hosted zone association with eu-west-1 VPCs enables those VPCs to resolve AWS private DNS records directly (C). Sharing forwarding rules via RAM (B) only works within the same region — cross-region RAM sharing of Resolver rules is not supported. Routing all DNS through Transit Gateway to us-east-1 (D) adds cross-region latency to every DNS query and creates a single point of failure. Outbound-only (E) means on-premises can't resolve eu-west-1 private records, breaking hybrid DNS.

---

### Question 60
A company wants to implement drift detection and automatic remediation for their CloudFormation-managed infrastructure across 50 accounts. They need to detect when resources are manually modified outside of CloudFormation and either revert the change automatically or alert the responsible team. Critical resources (security groups, IAM policies, S3 bucket policies) must be auto-remediated. Non-critical resources should generate alerts only.

What architecture implements drift detection with selective auto-remediation?

A) Enable AWS Config rules that detect changes to critical resource configurations. For security groups, use `ec2-security-group-attached-to-eni-periodic` with custom SSM Automation documents that revert security group rules to the CloudFormation-defined state. For IAM policies and S3 bucket policies, use Config managed rules with similar remediation. For non-critical resources, configure CloudFormation drift detection on a schedule (via EventBridge + Lambda) and send drift notifications to SNS
B) Use CloudFormation drift detection API called every hour for all stacks and manually remediate detected drift
C) Enable CloudTrail event monitoring for all `Modify*` and `Update*` API calls and reverse them using a Lambda function
D) Use AWS Config managed rules for all resource types and auto-remediate everything uniformly

**Answer: A**

**Explanation:** This approach combines real-time detection with selective remediation. AWS Config rules continuously monitor critical resources and trigger SSM Automation remediation immediately when non-compliant changes are detected — restoring security groups, IAM policies, and S3 bucket policies to their intended state. For non-critical resources, periodic CloudFormation drift detection (e.g., hourly via EventBridge-triggered Lambda) identifies deviations without immediate remediation, sending alerts for team review. This graduated response prevents disruptions from auto-remediating non-critical changes while ensuring security-critical resources stay in their intended state. Hourly drift detection for all stacks (B) doesn't provide real-time detection for critical resources and manual remediation is slow. Reversing all API calls (C) would break legitimate changes and operational activities. Uniform auto-remediation (D) is too aggressive for non-critical resources and could cause operational disruptions.

---

### Question 61
A company is using AWS Cost Anomaly Detection across their organization. They configured monitors for AWS services, member accounts, and cost allocation tags. They're receiving too many false positive anomaly alerts — approximately 20 per day — mostly related to expected cost fluctuations from monthly Reserved Instance charges, end-of-month data transfer spikes, and CI/CD pipeline scaling events. The actual concerning anomalies are getting lost in the noise.

What strategy reduces false positives while maintaining detection of genuine anomalies? **(Choose TWO.)**

A) Configure anomaly detection monitors with dollar-threshold alert preferences — set a minimum impact threshold (e.g., > $500 per anomaly) to filter out minor fluctuations. Create separate monitors with different thresholds for different account groups (production accounts with lower thresholds, development accounts with higher thresholds)
B) Use anomaly detection subscription filters that exclude specific categories like "RI recurring charges" and create time-based suppression rules for known monthly patterns
C) Disable Cost Anomaly Detection and rely on AWS Budgets for cost monitoring
D) Create a Lambda function that processes anomaly notifications from SNS and applies custom filtering logic before forwarding to the team — filtering out anomalies matching known patterns (CI/CD scaling in specific accounts, data transfer on month boundaries) and enriching remaining alerts with context from Cost Explorer API
E) Increase the training period for the anomaly detection model to reduce sensitivity

**Answer: A, D**

**Explanation:** Dollar-threshold alert preferences eliminate low-impact anomalies that aren't worth investigating, and different thresholds per account group ensure production cost anomalies are caught at lower thresholds while development account noise is filtered (A). A Lambda function processing SNS notifications provides custom filtering logic that Cost Anomaly Detection's built-in filters can't handle — filtering known patterns like RI recurring charges and monthly data transfer spikes, and enriching genuine alerts with Cost Explorer context for faster investigation (D). Disabling Cost Anomaly Detection (C) loses ML-powered anomaly detection entirely. Option B describes filtering capabilities that don't fully exist in Cost Anomaly Detection's native configuration. The training period (E) is automatically managed by the service and can't be user-configured.

---

### Question 62
A healthcare company is implementing AWS PrivateLink to expose their internal APIs to partner organizations that have their own AWS accounts (outside the company's organization). The APIs run on Network Load Balancers in the company's VPC. Partners should only access specific APIs based on their partnership agreement. The company needs to control which partner accounts can create VPC endpoints to their services and ensure that partners cannot access APIs they're not authorized for.

What architecture implements partner-specific API access control via PrivateLink?

A) Create separate VPC endpoint services for each API (or API group), each backed by its own NLB target group. Use the endpoint service's `AllowedPrincipals` to whitelist specific partner account IDs for each service. Require endpoint connection acceptance for manual approval of new partner connections. Partners create interface VPC endpoints in their own VPCs to access only the services they're authorized for
B) Create a single VPC endpoint service backed by one NLB and use security group rules to control which partner VPC endpoint IPs can access which APIs
C) Use API Gateway with IAM authorization and resource policies to control partner access, without PrivateLink
D) Share the NLB using RAM with partner accounts and let partners create target groups for their authorized APIs

**Answer: A**

**Explanation:** Separate VPC endpoint services per API provide granular access control. Each service's `AllowedPrincipals` list determines which partner accounts can create endpoints to that specific service — partners can only create endpoints to services they're explicitly authorized for. Connection acceptance adds a manual approval step where the company reviews and approves each endpoint connection request. This architecture ensures partner A can only create endpoints to their authorized API services, while partner B accesses different ones. A single endpoint service (B) exposes all APIs to all authorized partners, and security group IP-based filtering is fragile when partner endpoint IPs change. API Gateway without PrivateLink (C) doesn't meet the PrivateLink requirement and exposes APIs via public endpoints. RAM sharing of NLBs (D) gives partners direct access to the NLB, which is not appropriate for external partner access control.

---

### Question 63
A company has been running AWS Config across 100 accounts for 2 years. Their Config S3 bucket has grown to 50TB with configuration history and snapshots. The cost of storing this data is $1,150/month in S3 Standard. Compliance requirements mandate retention of Config data for 7 years, but the team only queries data from the last 90 days for active investigations. Historical data is accessed once or twice per year during annual audits.

What storage optimization reduces costs while meeting compliance requirements?

A) Implement S3 Intelligent-Tiering on the Config S3 bucket for data less than 90 days old. Create an S3 Lifecycle policy that transitions objects to S3 Glacier Instant Retrieval after 90 days and to S3 Glacier Deep Archive after 365 days, with a 7-year expiration. For the rare annual audit queries, use S3 Glacier Instant Retrieval which provides millisecond access for data in the 90-365 day range, and initiate bulk retrieval for Deep Archive data needed during audits
B) Delete all Config data older than 90 days and rely on Config's built-in retention for compliance
C) Move all data to S3 One Zone-IA to reduce costs
D) Compress Config data using a Lambda function and store compressed archives in S3 Standard

**Answer: A**

**Explanation:** This tiered storage approach optimizes costs based on access patterns. S3 Intelligent-Tiering automatically moves infrequently accessed recent data between tiers. The lifecycle policy transitions 90+ day data to Glacier Instant Retrieval (millisecond access at ~68% lower cost than Standard), suitable for the occasional audit access pattern. Data older than a year moves to Glacier Deep Archive (~95% lower cost than Standard) since annual audits can plan ahead for the 12-48 hour bulk retrieval time. The 7-year expiration ensures compliance retention. This could reduce the monthly cost from $1,150 to approximately $150-200. Deleting data (B) violates the 7-year retention requirement. One Zone-IA (C) provides only ~20% savings and risks data loss from AZ failure — inadequate for compliance data. Lambda compression (D) adds complexity and the savings from compression are modest compared to storage class optimization.

---

### Question 64
A company is implementing a multi-account CI/CD pipeline strategy. The central DevOps account hosts CodePipeline and CodeBuild projects that deploy applications to Dev, Staging, and Production accounts. The pipeline must: deploy to Dev automatically on commit, require manual approval before Staging, run integration tests in Staging, require manual approval from two different team leads before Production, and support rollback of any stage. Cross-account deployments use CloudFormation.

What pipeline architecture meets all requirements?

A) Create a CodePipeline in the DevOps account with stages: Source (CodeCommit), Build (CodeBuild), Deploy-Dev (CloudFormation cross-account deploy action with the Dev account's deployment role), Manual-Approval-Staging, Deploy-Staging (CloudFormation cross-account), Test-Staging (CodeBuild running integration tests), Manual-Approval-Prod-1, Manual-Approval-Prod-2 (two sequential approval actions requiring different SNS topic subscribers), Deploy-Prod (CloudFormation cross-account). Each cross-account action assumes a deployment IAM role in the target account. Artifacts are stored in a KMS-encrypted S3 bucket shared across accounts
B) Create separate CodePipeline instances in each account (Dev, Staging, Prod) triggered by S3 artifact uploads from the DevOps account
C) Use a single CodeBuild project with a buildspec that handles all deployment logic and environment selection based on branch name
D) Deploy using Terraform from a single CI/CD account with workspace-per-environment isolation

**Answer: A**

**Explanation:** A single CodePipeline with cross-account CloudFormation actions provides unified pipeline visibility with built-in stage gates. Cross-account deployment actions assume IAM roles in target accounts — each role has least-privilege permissions for CloudFormation stack operations in that account. Two sequential manual approval actions (each subscribed to different SNS topics targeting different team leads) enforce the dual-approval requirement for production. The KMS-encrypted S3 artifact bucket must have a bucket policy and KMS key policy allowing cross-account access from the target account deployment roles. CloudFormation's built-in rollback capability supports the rollback requirement for any stage. Separate pipelines per account (B) lose unified pipeline visibility and make cross-stage dependencies hard to manage. A single CodeBuild project (C) doesn't support manual approvals or stage gates. Terraform with workspaces (D) doesn't have native approval workflows comparable to CodePipeline.

---

### Question 65
An enterprise with 200 AWS accounts is evaluating their overall governance posture. They currently have: AWS Organizations with SCPs on 5 OUs, Config rules deployed inconsistently across 60% of accounts, CloudTrail enabled in 80% of accounts, GuardDuty in 50% of accounts, and no centralized Security Hub or IAM Identity Center. The CISO wants 100% governance coverage within 30 days.

What is the correct prioritized implementation plan? **(Choose THREE.)**

A) Enable an organization CloudTrail trail from the management account — this immediately captures API activity from ALL 200 accounts without per-account configuration, closing the logging gap
B) Enable GuardDuty with a delegated administrator and auto-enable for the organization — this immediately enables threat detection in all 200 accounts including new accounts
C) Deploy AWS Config organization-wide using a Config aggregator with a delegated administrator, then deploy conformance packs via organization conformance packs to ensure consistent rule deployment across all 200 accounts
D) Manually enable Config and GuardDuty in each of the remaining accounts one by one
E) Focus only on implementing IAM Identity Center first, as centralized identity is the most critical gap
F) Implement Security Hub with organization configuration before Config or GuardDuty, as it provides the broadest security view

**Answer: A, B, C**

**Explanation:** The organization CloudTrail trail is the highest priority because it immediately provides 100% API logging coverage with a single action — no per-account work needed. This addresses the most critical audit gap (A). GuardDuty with delegated administrator and auto-enable immediately extends threat detection to all 200 accounts, and the organization-level configuration ensures any new accounts are automatically enrolled (B). Config with a delegated administrator and organization conformance packs ensures all accounts have consistent compliance rule evaluation, closing the 40% coverage gap and providing the compliance posture visibility the CISO needs (C). Manual per-account enablement (D) won't complete within 30 days for 200 accounts. IAM Identity Center (E) is important but doesn't address the immediate security monitoring gaps. Security Hub (F) depends on Config and GuardDuty being enabled first — it aggregates their findings, so deploying it before fixing the underlying coverage gaps would provide an incomplete security view.

---

## Answer Key Summary

| Q | Answer | Q | Answer | Q | Answer | Q | Answer | Q | Answer |
|---|--------|---|--------|---|--------|---|--------|---|--------|
| 1 | A,C,E | 14 | A | 27 | A,C,E | 40 | A | 53 | A |
| 2 | A | 15 | A | 28 | A | 41 | A,B | 54 | A,B |
| 3 | A | 16 | A,B,C | 29 | A | 42 | A | 55 | A |
| 4 | A | 17 | A | 30 | A | 43 | A | 56 | A |
| 5 | A,C | 18 | A,B,C | 31 | A,C | 44 | A,B,C | 57 | A |
| 6 | A,B,C | 19 | A,B | 32 | A | 45 | A,D | 58 | A,C |
| 7 | A,B,C | 20 | A | 33 | A,B | 46 | A,C | 59 | A,C |
| 8 | A | 21 | B | 34 | A | 47 | A,B,D | 60 | A |
| 9 | A,C | 22 | A | 35 | A | 48 | A,C | 61 | A,D |
| 10 | A,C,E | 23 | A | 36 | A,B | 49 | A | 62 | A |
| 11 | B | 24 | A,C | 37 | A,B | 50 | A | 63 | A |
| 12 | A,B,D | 25 | A,D | 38 | A,B | 51 | A | 64 | A |
| 13 | A | 26 | D | 39 | A | 52 | A | 65 | A,B,C |

---

**Domain Distribution:**
- Security (Q1-Q5, Q7, Q9, Q13, Q15-Q16, Q22, Q31, Q34, Q37, Q39-Q40, Q44, Q46, Q62, Q65): ~20 questions
- Resilient Architectures (Q6, Q10, Q14, Q17, Q24, Q26, Q33, Q35, Q38, Q46, Q49-Q50, Q54-Q55, Q58-Q59, Q60): ~17 questions
- High-Performing Technology (Q8, Q11, Q19-Q20, Q23, Q25, Q27, Q30, Q36, Q42, Q45, Q50, Q52, Q57, Q64): ~16 questions
- Cost-Optimized Architectures (Q12, Q18-Q19, Q21, Q28, Q41, Q43, Q47-Q48, Q51, Q61, Q63): ~12 questions

**Multiple Response Questions:** Q1, Q5, Q6, Q7, Q9, Q10, Q12, Q16, Q18, Q19, Q24, Q25, Q27, Q31, Q36, Q37, Q38, Q41, Q44, Q45, Q47, Q48, Q54, Q58, Q59, Q61, Q65
