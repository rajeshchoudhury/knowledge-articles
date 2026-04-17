# AWS Certified Solutions Architect - Professional (SAP-C02) Practice Test 34

## Governance and Compliance — Config Rules, SCPs, Data Residency, HIPAA/PCI Patterns

**Time Limit: 180 minutes | 75 Questions | Passing Score: 75%**

> **Domain Distribution:** D1 ≈ 20 | D2 ≈ 22 | D3 ≈ 11 | D4 ≈ 9 | D5 ≈ 13

---

### Question 1
A healthcare organization with 80 AWS accounts managed through AWS Organizations needs to ensure all accounts comply with HIPAA requirements. They must guarantee that CloudTrail is enabled in every account and region, encryption at rest is enforced on all EBS volumes, and only HIPAA-eligible services can be used. The security team of three people cannot manually audit every account. Which combination of controls provides the MOST comprehensive and automated compliance enforcement?

A) Deploy AWS Config organizational rules for CloudTrail and EBS encryption checks, with automatic remediation via SSM Automation runbooks, and create an SCP that denies non-HIPAA-eligible service API calls

B) Use AWS Security Hub with the CIS Benchmark standard across all accounts to detect compliance issues

C) Create IAM policies in every account that restrict service usage and enable CloudTrail manually in each account

D) Use AWS Trusted Advisor organizational view to monitor compliance across all accounts

**Correct Answer: A**
**Explanation:** This combines preventive controls (SCPs blocking non-HIPAA-eligible services) with detective and corrective controls (Config rules detecting non-compliant resources with automatic remediation). SCPs enforce at the API level — even account admins cannot use blocked services. Config organizational rules deploy from a delegated administrator account and automatically apply to new accounts. SSM Automation runbooks handle remediation (e.g., enabling encryption on unencrypted EBS volumes). Option B detects issues but doesn't remediate or prevent non-eligible service usage. Option C doesn't scale to 80 accounts and IAM policies can be modified by account admins. Option D provides recommendations but lacks enforcement or remediation.

---

### Question 2
A multinational bank operates under PCI DSS Level 1 requirements. They must implement network segmentation to isolate their Cardholder Data Environment (CDE) from all other workloads. The CDE spans three AWS accounts. Non-CDE accounts must have zero network paths to CDE subnets. How should the architect design the network segmentation?

A) Place all CDE workloads in a single VPC with security groups restricting access

B) Create dedicated CDE accounts in a separate OU with their own Transit Gateway. Use a firewall account with AWS Network Firewall between the CDE Transit Gateway and any permitted connections. Attach an SCP to the CDE OU denying creation of VPC peering, Transit Gateway attachments to the non-CDE TGW, or any cross-account networking outside the approved firewall path. Use AWS Config rules to detect unauthorized network paths.

C) Use VPC endpoint policies to restrict traffic between CDE and non-CDE accounts

D) Deploy CDE workloads on AWS Outposts to physically isolate them from cloud workloads

**Correct Answer: B**
**Explanation:** PCI DSS requires strict network segmentation of the CDE. A dedicated Transit Gateway for CDE accounts ensures no shared routing with non-CDE traffic. The firewall account with AWS Network Firewall provides stateful inspection, IDS/IPS, and logging for any traffic entering/leaving the CDE — a PCI requirement. SCPs on the CDE OU prevent any networking workarounds (peering, unauthorized TGW attachments) even by account admins. Config rules provide detective validation. Option A lacks account-level isolation — a single VPC means blast radius includes all CDE if the VPC is compromised. Option C only controls traffic to specific services, not general network segmentation. Option D is excessive and doesn't address the cloud workload connectivity requirements.

---

### Question 3
A European financial services company must comply with GDPR Article 17 (Right to Erasure). When a customer requests data deletion, all their personal data across DynamoDB, S3, Aurora, and Elasticsearch must be deleted within 30 days. Data exists across eu-west-1 and eu-central-1. The company processes 500 deletion requests per month. How should the architect design the data deletion pipeline?

A) Manually search each service and delete customer records when requests arrive

B) Implement a customer data catalog in DynamoDB that maps each customer ID to all storage locations (table/bucket/index/database references). When a deletion request arrives via API Gateway, trigger a Step Functions workflow that: (1) looks up all data locations from the catalog, (2) executes parallel Lambda functions to delete from each service, (3) records deletion proof with timestamps in an audit DynamoDB table, (4) sends a completion notification via SNS. Use DynamoDB TTL on the audit records to retain proof for the required period.

C) Use S3 Lifecycle policies to automatically delete all customer data after 30 days

D) Tag all customer data with the customer ID and use AWS Resource Groups to find and delete tagged resources

**Correct Answer: B**
**Explanation:** GDPR Right to Erasure requires provable, complete deletion across all data stores within the regulatory timeframe. A customer data catalog provides a single source of truth for where each customer's data resides. Step Functions orchestrates parallel deletion across heterogeneous services (DynamoDB delete item, S3 delete objects, Aurora DELETE queries, Elasticsearch document deletion). The audit trail provides compliance evidence. This pattern handles the 500 monthly requests efficiently without manual intervention. Option A doesn't scale and lacks audit trails. Option C deletes ALL data, not specific customer data. Option D — not all data can be tagged at the record level (DynamoDB items, Elasticsearch documents don't support resource tags).

---

### Question 4
An organization with 200 AWS accounts needs to implement preventive guardrails that deny the ability to create public-facing resources across all accounts except the DMZ accounts. This includes public S3 buckets, EC2 instances with public IPs, RDS instances with public accessibility, and public-facing load balancers. Which approach provides the MOST comprehensive coverage?

A) Enable S3 Block Public Access at the organization level and manually configure each service

B) Attach SCPs to all non-DMZ OUs that deny: `s3:PutBucketPolicy` and `s3:PutBucketAcl` with conditions preventing public access, `ec2:RunInstances` with condition `{"Bool": {"ec2:AssociatePublicIpAddress": "true"}}`, `rds:CreateDBInstance` with condition `{"Bool": {"rds:PubliclyAccessible": "true"}}`, and `elasticloadbalancing:CreateLoadBalancer` with condition `{"StringEquals": {"elasticloadbalancing:Scheme": "internet-facing"}}`. Additionally, enable S3 Block Public Access at the organization level as defense in depth.

C) Use AWS Config rules to detect public resources and auto-remediate them

D) Create a Lambda function that scans for public resources hourly and terminates them

**Correct Answer: B**
**Explanation:** SCPs with service-specific condition keys provide preventive controls that block public resource creation at the API level before resources exist. The SCP conditions map to each service's specific mechanism for public access: EC2 uses `ec2:AssociatePublicIpAddress`, RDS uses `rds:PubliclyAccessible`, ELB uses `elasticloadbalancing:Scheme`. S3 Block Public Access at the organization level adds another preventive layer specifically for S3. Attaching to non-DMZ OUs allows DMZ accounts to create public resources as needed. Option A only covers S3. Option C is detective/corrective — resources exist briefly before remediation (risk window). Option D has an hourly gap where public resources can exist.

---

### Question 5
A government agency requires all data stored on AWS to be encrypted with agency-managed keys. They use a centralized security account to manage all KMS keys. Application accounts must be able to use the keys but never create, delete, or modify them. The agency has 50 accounts across 3 OUs. How should the architect implement this key management model?

A) Create KMS keys in each application account and restrict key management via IAM policies

B) Create all KMS keys in the centralized security account. Grant cross-account access via KMS key policies that allow application account roles to use keys (kms:Encrypt, kms:Decrypt, kms:GenerateDataKey, kms:ReEncrypt*, kms:DescribeKey) but not administer them. Attach an SCP to non-security OUs that denies kms:CreateKey, kms:ScheduleKeyDeletion, kms:DisableKey, kms:PutKeyPolicy, and kms:CreateAlias. Use AWS Config rules to detect any KMS keys created outside the security account.

C) Use AWS CloudHSM in the security account and share access via VPC peering

D) Use AWS-managed keys (aws/s3, aws/ebs) instead of customer-managed keys

**Correct Answer: B**
**Explanation:** Centralized key management in a security account provides single-pane control over all encryption keys. Cross-account KMS key policies grant usage permissions without administrative access — application teams can encrypt/decrypt but cannot modify key policies or delete keys. SCPs as a preventive guardrail ensure no account outside the security account can create KMS keys, even if an administrator attempts it. Config rules provide detective validation. Option A defeats centralization — keys in each account means 50 accounts managing their own keys. Option C adds complexity; KMS cross-account access is simpler than CloudHSM sharing. Option D — AWS-managed keys are not agency-managed and cannot be centrally controlled.

---

### Question 6
A company subject to SOX (Sarbanes-Oxley) compliance must implement segregation of duties for their AWS environments. Specifically: developers must not be able to deploy to production, infrastructure changes must require approval from a separate team, and no single person should be able to both create and approve IAM policy changes. How should the architect enforce this across their AWS Organization?

A) Document the segregation requirements and trust teams to follow them

B) Implement a multi-layered approach: (1) Separate OUs for development and production with different SCPs — dev accounts allow broad permissions, production accounts restrict direct deployments. (2) Use AWS CodePipeline with a manual approval stage where a member of the Change Advisory Board must approve before production deployment. (3) Implement IAM permission boundaries in production accounts that prevent direct resource modification — all changes must flow through the CI/CD pipeline. (4) For IAM policy changes, use Service Catalog with a portfolio shared from a governance account — IAM changes are requested via Service Catalog and provisioned by an automation role after approval via SNS.

C) Use MFA for all production account access

D) Implement AWS SSO with different permission sets for each environment

**Correct Answer: B**
**Explanation:** SOX compliance requires technical enforcement of segregation of duties, not just procedural controls. The layered approach addresses each requirement: (1) OU-based separation with SCPs prevents developers from having production permissions even if they try to assume roles. (2) CodePipeline approval stages enforce change management with a different team approving than the team developing. (3) Permission boundaries in production ensure all changes go through approved pipelines — direct API calls are blocked. (4) Service Catalog for IAM changes ensures the person requesting is different from the automated role provisioning, with an approval step in between. Option A has no technical enforcement. Option C adds authentication strength but doesn't enforce segregation. Option D helps with access management but doesn't enforce approval workflows or prevent direct deployments.

---

### Question 7
A healthcare SaaS provider stores PHI across multiple AWS services. During a compliance audit, they need to demonstrate that all data access is logged, all PHI is encrypted, and access patterns are monitored for anomalies. The audit team requires evidence within 24 hours. How should the architect design the compliance evidence system?

A) Enable CloudTrail and manually generate reports when auditors request them

B) Deploy a centralized compliance dashboard: (1) CloudTrail organization trail with log file validation stored in a dedicated logging account S3 bucket with Object Lock (WORM). (2) AWS Config conformance packs evaluating encryption rules across all accounts. (3) Amazon Macie scanning S3 buckets for unencrypted PHI with scheduled discovery jobs. (4) GuardDuty with anomaly detection for unusual API call patterns. (5) Security Hub aggregating findings from Config, Macie, and GuardDuty with custom insights. (6) QuickSight dashboard connected to Security Hub findings and CloudTrail logs via Athena for on-demand audit evidence generation.

C) Use AWS Artifact to download compliance reports for auditors

D) Deploy a third-party SIEM solution on EC2 to aggregate logs

**Correct Answer: B**
**Explanation:** This architecture provides continuous compliance monitoring with on-demand evidence generation. CloudTrail with log file validation in WORM storage proves logs haven't been tampered with — critical for audits. Config conformance packs provide automated compliance checks with results available instantly. Macie identifies unprotected PHI proactively. GuardDuty detects anomalous access patterns (potential breaches). Security Hub aggregates everything into a single pane. QuickSight dashboards allow the 24-hour evidence generation requirement to be met instantly. Option A requires manual work and can't meet the 24-hour requirement reliably. Option C provides AWS's compliance certifications, not evidence of YOUR compliance posture. Option D adds operational overhead and still requires building the compliance logic.

---

### Question 8
A retail company operates in AWS regions across the US, EU, and APAC. Data residency laws require that customer PII collected in each region stays within that region. However, the analytics team needs to run aggregate (non-PII) reports across all regions. How should the architect design this system?

A) Replicate all data to a central region and restrict access with IAM policies

B) Keep PII in regional accounts/VPCs restricted by SCPs to their respective regions. Deploy a data pipeline in each region that uses AWS Glue ETL to strip PII fields (anonymize/pseudonymize) and write aggregate metrics to a central analytics account in us-east-1. Use Glue Data Catalog with Lake Formation to enforce column-level access — PII columns are accessible only within the regional account. The analytics account only receives anonymized aggregate data via cross-account S3 replication of the de-identified datasets.

C) Use Amazon Redshift with cross-region data sharing for all data

D) Grant the analytics team read access to all regional databases

**Correct Answer: B**
**Explanation:** This preserves data residency by keeping PII local while enabling cross-region analytics on non-PII data. Glue ETL strips PII before data leaves the region — the analytics account never receives identifiable data. Lake Formation column-level security prevents unauthorized PII access even within regional accounts. SCPs restrict the regional accounts to their geographic AWS regions. The analytics team works only with anonymized aggregates, satisfying both data residency laws and business analytics needs. Option A directly violates data residency — PII leaves the region. Option C — cross-region data sharing still moves PII. Option D gives the analytics team PII access, which violates the principle of least privilege and potentially data residency laws.

---

### Question 9
An AWS Organization has a requirement that ALL resources across 150 accounts must be tagged with CostCenter, Environment, DataClassification, and Owner tags. Resources without mandatory tags should be prevented from being created. What is the MOST effective implementation?

A) Use AWS Config rules to detect untagged resources and auto-remediate by adding default tags

B) Implement tag policies in AWS Organizations to define required tags and allowed values. Additionally, create SCPs that deny resource creation API calls unless the required tags are present using `aws:RequestTag` condition keys: `{"Condition": {"Null": {"aws:RequestTag/CostCenter": "true"}}, "Effect": "Deny"}` for each required tag. Deploy AWS Config rules as a detective layer to catch resources that bypass tagging (e.g., resources created before the policy).

C) Create a Lambda function triggered by CloudTrail events that tags resources post-creation

D) Use AWS Service Catalog to provide pre-tagged resource templates

**Correct Answer: B**
**Explanation:** This layered approach provides both preventive and detective tagging enforcement. Tag policies define the canonical tag keys and allowed values at the organization level. SCPs with `aws:RequestTag` conditions prevent resource creation without required tags — this is a hard block at the API level. Config rules detect any resources that exist without proper tags (legacy resources or edge cases). The combination ensures comprehensive coverage. Option A is only detective/corrective — resources exist briefly without tags. Option C has a delay between creation and tagging. Option D only works if teams use Service Catalog exclusively, which can't be guaranteed.

---

### Question 10
A financial institution must implement PCI DSS Requirement 10 (Track and monitor all access to network resources and cardholder data). They need immutable logs that cannot be deleted or modified by anyone, including account administrators, for a minimum of one year with immediate access and seven years of archival. How should the architect design the logging architecture?

A) Enable CloudTrail in each account and store logs in the account's default S3 bucket

B) Configure an organization CloudTrail trail that delivers logs to a dedicated log archive account. The log archive S3 bucket uses: (1) S3 Object Lock in Compliance mode with a 1-year retention period (immutable — no one, including root, can delete). (2) S3 Lifecycle policy transitioning objects to S3 Glacier Deep Archive after 1 year with a total retention of 7 years. (3) Bucket policy denying s3:DeleteObject and s3:PutBucketPolicy (preventing policy changes). (4) SCP on the log archive account denying s3:DeleteObject, s3:PutObjectRetention, and s3:PutBucketPolicy from all principals. (5) Enable CloudTrail log file validation for tamper detection.

C) Use Amazon CloudWatch Logs with a 7-year retention period

D) Send logs to an external SIEM system and delete AWS copies after 90 days

**Correct Answer: B**
**Explanation:** PCI DSS Requirement 10 demands immutable, tamper-proof logging. S3 Object Lock in Compliance mode provides true WORM (Write Once Read Many) storage — even AWS root account users cannot delete objects during the retention period. This is critical for PCI compliance. The organization trail captures all API activity across all accounts. Log file validation enables detection of any log tampering. The SCP prevents even the log archive account admin from modifying the bucket configuration. Lifecycle policies optimize cost by moving to Glacier Deep Archive after the 1-year active access period while maintaining the 7-year total retention. Option A — logs in individual accounts can be deleted by account admins. Option C — CloudWatch Logs retention doesn't provide WORM guarantee. Option D — deleting AWS copies after 90 days violates the 1-year immediate access requirement.

---

### Question 11
A company needs to enforce that all RDS instances across their organization use encryption at rest, have automated backups enabled with a minimum 14-day retention, have deletion protection enabled, and are not publicly accessible. Non-compliant instances must be detected within 1 hour and the security team must be notified immediately. What should the architect implement?

A) Create a checklist for database administrators to follow when creating RDS instances

B) Deploy AWS Config organizational rules with custom Lambda evaluation functions that check all four conditions (encryption, backup retention >= 14 days, deletion protection, public accessibility). Configure Config to evaluate on configuration change and periodically (1 hour). Create an EventBridge rule that captures Config compliance change events where the new status is NON_COMPLIANT and routes them to an SNS topic subscribed by the security team. Additionally, create an SCP that denies `rds:CreateDBInstance` when `rds:PubliclyAccessible` is true for non-DMZ OUs.

C) Use RDS Event Subscriptions to monitor for configuration changes

D) Run a daily Lambda function that checks RDS instance configurations

**Correct Answer: B**
**Explanation:** Config organizational rules provide continuous compliance evaluation across all accounts. Custom Lambda evaluators allow checking multiple conditions (encryption, backup retention, deletion protection, public accessibility) in a single rule. Config triggers evaluation on every configuration change AND runs periodic checks (catching drift). EventBridge captures compliance state changes in near-real-time for immediate notification. The SCP adds a preventive layer for the most critical requirement (public accessibility). Option A relies on human compliance with no enforcement. Option C monitors events but doesn't evaluate compliance state. Option D has a 24-hour detection gap, violating the 1-hour requirement.

---

### Question 12
A company operates a data lake on AWS that processes personal data subject to both GDPR (EU) and CCPA (California). The data lake receives data from global sources. They need to implement data classification, apply appropriate processing rules based on the data's jurisdiction, and maintain consent records. How should the architect design the governance layer?

A) Tag all data as either GDPR or CCPA and apply manual processing rules

B) Implement automated data governance: (1) Use Amazon Macie to automatically discover and classify PII in S3 data lake objects, identifying data types (names, addresses, SSNs, EU national IDs). (2) AWS Glue ETL jobs enrich metadata with jurisdiction tags based on data origin (source IP region, user account region). (3) Lake Formation tag-based access control (LF-TBAC) restricts access based on jurisdiction — EU-tagged data only accessible by EU-authorized roles, CA-tagged data by CA-authorized roles. (4) A consent management service (DynamoDB table) tracks per-user consent status, integrated with Glue ETL to filter processing based on active consent. (5) Step Functions workflow handles data subject access requests (DSARs) by querying the data catalog for all records matching a subject ID.

C) Store EU and California data in separate AWS accounts with no cross-access

D) Use Amazon Comprehend to identify personal data and delete it automatically

**Correct Answer: B**
**Explanation:** Multi-jurisdictional compliance requires automated classification, access control, and consent management. Macie automatically discovers PII patterns, reducing the risk of unclassified personal data. Jurisdiction tagging via Glue ETL ensures data is correctly attributed. Lake Formation's tag-based access control enforces jurisdictional boundaries at the query level — an analyst querying the data lake can only see data they're authorized for based on jurisdiction. The consent management service ensures processing only occurs with valid consent (GDPR Article 6, CCPA opt-out requirements). DSAR automation handles subject access requests at scale. Option A is manual and error-prone. Option C prevents cross-jurisdictional analytics that may be legally permitted with proper controls. Option D incorrectly assumes all personal data should be deleted.

---

### Question 13
An organization wants to implement a compliance-as-code framework. Every infrastructure change must be validated against compliance rules BEFORE deployment. Non-compliant changes must be rejected automatically. They use Terraform for infrastructure provisioning and AWS CodePipeline for CI/CD. What architecture should the architect recommend?

A) Run AWS Config rules after deployment and manually rollback non-compliant changes

B) Integrate compliance validation into the CI/CD pipeline: (1) Developers commit Terraform code to CodeCommit. (2) CodeBuild runs `terraform plan` and outputs the plan file. (3) A CodeBuild stage runs OPA (Open Policy Agent) or HashiCorp Sentinel against the Terraform plan, evaluating compliance rules (encryption required, no public access, mandatory tags, approved instance types). (4) Failing compliance checks halt the pipeline and notify developers via SNS. (5) Passing checks proceed to a manual approval stage for production. (6) CodeBuild runs `terraform apply`. (7) Post-deployment, AWS Config rules validate the deployed resources as defense in depth.

C) Use CloudFormation Guard on all templates before deployment

D) Restrict Terraform module usage to only pre-approved modules

**Correct Answer: B**
**Explanation:** Shift-left compliance validates rules before infrastructure is provisioned, preventing non-compliant resources from ever existing. OPA/Sentinel evaluate the Terraform plan (which shows exactly what will be created/modified) against codified compliance rules. This catches violations before any AWS resources are created. The manual approval stage adds human oversight for production. Post-deployment Config rules provide defense in depth — catching any drift or rules that the pre-deployment checks missed. Option A allows non-compliant resources to exist temporarily. Option C only works for CloudFormation, not Terraform. Option D restricts flexibility without validating actual compliance.

---

### Question 14
A company has 300 AWS accounts and needs to implement a centralized exception management process for SCP restrictions. Sometimes legitimate workloads need temporary exceptions to organizational policies (e.g., a team needs to use a service that's normally blocked). Exceptions must be approved, time-limited, and audited. How should the architect design this?

A) Remove the SCP restriction whenever an exception is needed and re-apply it later

B) Design an automated exception workflow: (1) Requestors submit exception requests via a Service Catalog product in their account. (2) The request triggers an approval workflow in Step Functions — routes to the appropriate approver based on exception type via SNS. (3) Upon approval, a Lambda function moves the requesting account from its current OU to a temporary exception OU that has a modified SCP allowing the specific action. (4) An EventBridge scheduled rule triggers a Lambda function after the approved duration to move the account back to its original OU. (5) All exception grants, approvals, and expirations are logged in a DynamoDB audit table. (6) A CloudWatch dashboard tracks active exceptions.

C) Create IAM roles in each account that bypass SCPs for approved use cases

D) Use tag-based SCP conditions and add exception tags to accounts that need them

**Correct Answer: B**
**Explanation:** This provides a controlled, audited exception process. OU-based exceptions work because SCPs are applied at the OU level — moving an account to an exception OU with a permissive SCP temporarily grants the exception. The Service Catalog integration provides a standardized request interface. Step Functions handles the approval workflow with routing logic. Automatic expiration (EventBridge + Lambda moving the account back) ensures exceptions don't persist indefinitely. The audit trail satisfies compliance requirements for tracking policy exceptions. Option A is manual and error-prone with no audit trail. Option C — IAM roles cannot bypass SCPs; SCPs restrict the maximum permissions regardless of IAM. Option D — SCP conditions on tags can be changed by account admins, bypassing the approval process.

---

### Question 15
A healthcare company stores medical imaging data (DICOM files) in S3 totaling 500 TB. HIPAA requires that access to PHI is logged and files are retained for 7 years. After 1 year, files are rarely accessed but must remain available for retrieval within 12 hours. After 3 years, retrieval can take up to 48 hours. How should the architect optimize storage while maintaining compliance?

A) Keep all data in S3 Standard for the full 7 years

B) Implement S3 Lifecycle policies: (1) S3 Standard for 0-12 months (frequent access during active patient care). (2) S3 Standard-IA after 12 months (infrequent access, retrieval in milliseconds). (3) S3 Glacier Flexible Retrieval after 36 months (archival, 3-5 hour standard retrieval satisfies the 12-hour requirement with margin). (4) S3 Object Lock in Governance mode for the 7-year retention (prevents accidental deletion but allows authorized overrides for legal holds). (5) Enable S3 server access logging and CloudTrail data events for PHI access audit trail. (6) Encrypt all objects with customer-managed KMS keys.

C) Move all data to Glacier Deep Archive after 1 year for maximum cost savings

D) Delete data after 3 years to reduce storage costs

**Correct Answer: B**
**Explanation:** This tiered approach optimizes cost at each stage while maintaining HIPAA compliance. S3 Standard-IA after 1 year saves ~40% while maintaining millisecond access. Glacier Flexible Retrieval after 3 years saves ~80% versus Standard while meeting the 48-hour retrieval SLA with its 3-5 hour standard retrieval. Object Lock in Governance mode prevents accidental deletion for 7 years while allowing authorized users to override if legally required (Compliance mode would prevent even legal-hold modifications). S3 access logging and CloudTrail data events provide the HIPAA-required PHI access audit trail. Option A wastes money — 500 TB in Standard for 7 years is extremely expensive. Option C — Deep Archive has 12-hour standard retrieval, which doesn't meet the 12-hour SLA for years 1-3 data. Option D violates the 7-year retention requirement.

---

### Question 16
An organization needs to implement AWS Config custom rules that evaluate compliance of their Lambda functions. The rules must verify: (1) functions use VPC configuration, (2) functions use approved runtimes only, (3) functions have reserved concurrency set, and (4) function environment variables don't contain secrets. What is the MOST efficient implementation?

A) Create four separate Config rules, one for each requirement

B) Create a single AWS Config custom rule backed by a Lambda evaluation function that checks all four conditions. The evaluation function receives the `AWS::Lambda::Function` configuration item and checks: VPC config presence, runtime against an approved list (stored in SSM Parameter Store for easy updates), reserved concurrency > 0, and environment variable names/values against a regex pattern for potential secrets (e.g., patterns matching API keys, passwords). Return COMPLIANT only if all four checks pass, otherwise return NON_COMPLIANT with annotations describing which checks failed. Deploy as an organization rule.

C) Use Config managed rules — there are pre-built rules for all Lambda compliance checks

D) Use Lambda Powertools to enforce these requirements at deploy time

**Correct Answer: B**
**Explanation:** A single custom Config rule checking all four conditions is more efficient than four separate rules — it reduces Lambda invocations, Config rule costs, and simplifies management. The evaluation function receives the full Lambda configuration item, which includes VPC configuration, runtime, reserved concurrency, and environment variables. Storing the approved runtime list in SSM Parameter Store allows updates without redeploying the evaluation function. Annotations on non-compliant results tell operators exactly which check(s) failed. Organization-level deployment ensures all accounts are covered. Option A is functional but quadruples the cost and operational overhead. Option C — there are no managed rules for all four of these specific checks combined. Option D enforces at deploy time but doesn't catch existing functions or configuration drift.

---

### Question 17
A company needs to implement data sovereignty controls for a workload processing Australian citizen data. Australian Privacy Act requires that data remains within Australia. They need the workload to run in ap-southeast-2 (Sydney) only, but global services like IAM, CloudFront, and Route 53 must still function. How should the architect configure the SCP?

A) Deny all actions in all regions except ap-southeast-2

B) Create an SCP that denies all actions when `aws:RequestedRegion` is not `ap-southeast-2`, with explicit exclusions for global services. The SCP uses `StringNotEquals` condition on `aws:RequestedRegion` but exempts specific global service actions: `iam:*`, `sts:*`, `route53:*`, `cloudfront:*`, `waf:*`, `organizations:*`, `support:*`, `budgets:*`, and `ce:*` (Cost Explorer). Use the `NotAction` element instead of `Action` to create a deny-all-except pattern:
```json
{"Effect": "Deny", "NotAction": ["iam:*", "sts:*", "route53:*", "cloudfront:*", "waf:*", "organizations:*", "support:*", "budgets:*", "ce:*"], "Resource": "*", "Condition": {"StringNotEquals": {"aws:RequestedRegion": "ap-southeast-2"}}}
```

C) Use VPC endpoints in ap-southeast-2 to prevent traffic from leaving the region

D) Configure Route 53 to only resolve endpoints in ap-southeast-2

**Correct Answer: B**
**Explanation:** The `NotAction` element with a region condition is the standard pattern for region restriction SCPs that need to accommodate global services. Global services (IAM, STS, Route 53, CloudFront, WAF, Organizations, Support, Budgets, Cost Explorer) operate from us-east-1 regardless of where you access them — blocking us-east-1 entirely would break these services. The `NotAction` element means "deny everything EXCEPT these listed actions when the region is not ap-southeast-2." This allows global services while restricting all regional services to Sydney. Option A would break global services. Option C — VPC endpoints control network traffic to AWS services, not resource creation locations. Option D doesn't prevent resource creation in other regions.

---

### Question 18
A financial services company must implement change management controls for their production AWS accounts that comply with ITIL and SOX. Every infrastructure change must have an approved change ticket before implementation. The current process is manual and error-prone. How should the architect automate change management compliance?

A) Require team leads to verbally approve changes before engineers apply them

B) Integrate AWS Systems Manager Change Manager with the CI/CD pipeline: (1) All infrastructure changes are defined in CloudFormation/Terraform in CodeCommit. (2) When a PR is merged, CodePipeline triggers. (3) A Lambda function creates a Change Manager change request with the change details, risk analysis, and rollback plan. (4) Change Manager routes the approval to the appropriate Change Advisory Board (CAB) members based on change type (standard, normal, emergency). (5) Standard changes are auto-approved via pre-approved templates. (6) Upon approval, CodePipeline proceeds with the deployment. (7) Change Manager records the execution result and maintains the audit trail linked to the change ticket. (8) AWS Config records the before/after resource configurations.

C) Use CodePipeline manual approval stages for all changes

D) Require MFA authentication before any production deployment

**Correct Answer: B**
**Explanation:** Systems Manager Change Manager provides native AWS change management that integrates with ITIL processes. It supports change templates (for standard changes that can be auto-approved), approval workflows (for normal changes requiring CAB approval), and emergency change processes. Integration with CodePipeline ensures no change deploys without an approved ticket. The audit trail links every production change to an approved change request with approver identity, timestamps, and execution results — satisfying SOX audit requirements. Config provides the technical before/after evidence. Option A has no technical enforcement or audit trail. Option C provides approval but lacks structured change management (no ticket numbers, risk analysis, or change categorization). Option D adds authentication but doesn't enforce change management process.

---

### Question 19
An organization's compliance team needs to continuously validate that their AWS environment meets CIS AWS Foundations Benchmark v1.4 requirements. They need a compliance score, trend tracking over time, and the ability to drill into specific findings. The solution must cover all 180 accounts. What architecture should the architect recommend?

A) Manually run CIS benchmark assessments quarterly using a third-party tool

B) Enable AWS Security Hub across the organization with a delegated administrator account. Enable the CIS AWS Foundations Benchmark v1.4 standard in Security Hub. Security Hub automatically evaluates all CIS controls using Config rules (deployed automatically by Security Hub). Use Security Hub's compliance score and control status dashboard for real-time visibility. Create custom Security Hub insights for tracking specific control categories. Export findings to S3 via EventBridge for historical trend analysis using Athena and QuickSight dashboards. Use Security Hub cross-region aggregation to consolidate findings from all regions.

C) Deploy AWS Audit Manager with the CIS framework and run manual assessments

D) Use AWS Config conformance packs with the CIS Operational Best Practices pack

**Correct Answer: B**
**Explanation:** Security Hub with the CIS Benchmark standard provides automated, continuous compliance evaluation across all 180 accounts. It automatically deploys the required Config rules, evaluates compliance, calculates scores, and provides a dashboard — meeting all requirements with minimal operational overhead. The delegated administrator model avoids using the management account. Cross-region aggregation ensures no blind spots. Exporting to S3 + Athena + QuickSight enables historical trend tracking that Security Hub doesn't natively provide long-term. Option A is manual and only provides point-in-time assessment. Option C provides assessment frameworks but requires more manual evidence collection. Option D evaluates Config rules but doesn't provide the compliance scoring and trend analysis that Security Hub adds.

---

### Question 20
A company needs to implement a detective control that identifies when AWS Config, CloudTrail, or GuardDuty is disabled in any account across their 100-account organization. The detection must occur within 5 minutes and automatically re-enable the service. How should the architect design this?

A) Schedule a Lambda function to check service status every 5 minutes in every account

B) Use EventBridge organization rules to capture specific API calls across all accounts. Create rules matching: `cloudtrail:StopLogging`, `cloudtrail:DeleteTrail`, `config:StopConfigurationRecorder`, `config:DeleteConfigurationRecorder`, `guardduty:DeleteDetector`, `guardduty:DisableOrganizationAdminAccount`. Route matched events to a centralized EventBridge bus in the security account. A Lambda function processes these events and immediately re-enables the service using cross-account IAM roles. The Lambda also sends an alert to the security team via SNS and logs the incident in a DynamoDB audit table.

C) Use AWS Config rules to monitor whether CloudTrail and GuardDuty are enabled

D) Review CloudTrail logs daily for these API calls

**Correct Answer: B**
**Explanation:** EventBridge organization rules provide near-real-time detection (seconds, not minutes) of specific API calls across all 100 accounts. By targeting the exact API calls that disable security services, the detection is precise and immediate. The centralized Lambda function uses cross-account roles to re-enable services instantly. This creates a self-healing security posture — even if an attacker gains account admin access and disables CloudTrail, it's re-enabled within seconds. Option A requires cross-account polling infrastructure and has a 5-minute gap. Option C — Config rules have longer evaluation intervals and Config itself might be the service being disabled. Option D is not real-time.

---

### Question 21
A company building a multi-tenant SaaS application needs to ensure that each tenant's data access patterns in DynamoDB are isolated. Tenant data exists in shared tables with tenant ID as the partition key. A bug in the application code could potentially allow one tenant to read another tenant's data. What defense-in-depth approach should the architect implement?

A) Rely solely on application-level tenant ID filtering in queries

B) Implement IAM-level isolation using DynamoDB fine-grained access control: (1) Each tenant's API requests are authenticated and mapped to a tenant-specific IAM role via STS AssumeRole with a session policy. (2) The session policy includes a condition: `{"ForAllValues:StringEquals": {"dynamodb:LeadingKeys": "${aws:PrincipalTag/TenantId}"}}` which restricts DynamoDB operations to items where the partition key matches the tenant ID. (3) Tag the assumed role session with the tenant ID. (4) Additionally, enable DynamoDB Streams to audit all data access and use a Lambda function to detect cross-tenant access patterns.

C) Create separate DynamoDB tables for each tenant

D) Use VPC endpoints with security groups to isolate tenant network access

**Correct Answer: B**
**Explanation:** DynamoDB fine-grained access control using `dynamodb:LeadingKeys` enforces tenant isolation at the AWS IAM level, independent of application code. Even if the application has a bug that constructs a query with the wrong tenant ID, the IAM policy prevents access to items with a different partition key. Session policies with STS AssumeRole allow dynamic per-request scoping. DynamoDB Streams-based auditing provides a detective layer. This creates defense in depth: application-level filtering + IAM-level enforcement + audit monitoring. Option A is a single layer — one bug exposes cross-tenant data. Option C doesn't scale for large multi-tenant deployments (thousands of tables). Option D — VPC security groups don't provide row-level data isolation.

---

### Question 22
A company migrating to AWS needs to maintain compliance with their existing ISO 27001 Information Security Management System (ISMS). They need to map their ISO 27001 controls to AWS services and demonstrate continuous compliance. How should the architect support the ISO 27001 compliance journey?

A) Download AWS's ISO 27001 certification from AWS Artifact and present it as evidence of compliance

B) Use AWS Audit Manager with the ISO 27001:2013 framework: (1) Audit Manager maps ISO 27001 controls to AWS-specific evidence (CloudTrail logs, Config rules, Security Hub findings). (2) Configure automated evidence collection — Audit Manager continuously gathers evidence from AWS services and maps them to ISO 27001 controls. (3) Create custom controls for organization-specific requirements not covered by standard mappings. (4) Use the assessment report feature to generate auditor-ready evidence packages. (5) Integrate with Security Hub and Config for real-time compliance status. (6) Store evidence in a dedicated S3 bucket with Object Lock for integrity.

C) Hire a consultant to manually map controls and collect evidence quarterly

D) Use AWS Well-Architected Tool reviews as ISO 27001 evidence

**Correct Answer: B**
**Explanation:** Audit Manager provides a purpose-built service for compliance evidence collection and management. The ISO 27001:2013 framework maps standard controls to AWS evidence sources, automating what was traditionally a manual process. Automated evidence collection ensures continuous compliance monitoring rather than point-in-time audits. Custom controls handle organization-specific ISMS requirements. Assessment reports provide auditor-ready packages that significantly reduce audit preparation time. Option A — AWS's ISO certification covers AWS infrastructure, but customers must demonstrate their own use of AWS is compliant. Option C is expensive, slow, and provides only point-in-time evidence. Option D — Well-Architected reviews don't map to ISO 27001 controls.

---

### Question 23
A company needs to implement a data classification framework across their AWS data lake. Data must be classified into four tiers: Public, Internal, Confidential, and Restricted. Access controls, encryption, and monitoring must be automatically applied based on classification. How should the architect design this?

A) Create a spreadsheet documenting which S3 buckets contain which classification tier

B) Implement automated classification with Lake Formation: (1) Use Amazon Macie with custom data identifiers to scan S3 objects and classify them into the four tiers based on content patterns (PII patterns = Confidential/Restricted, financial data = Restricted, internal docs = Internal). (2) A Lambda function processes Macie findings and applies S3 object tags with the classification tier. (3) Lake Formation tag-based access control (LF-TBAC) maps classification tags to IAM principals — Restricted data accessible only by specific roles, Confidential by approved groups, Internal by all employees, Public by anyone. (4) KMS key policies enforce that Restricted data uses dedicated CMKs with stricter key policies. (5) CloudWatch alarms trigger on access to Restricted data outside normal patterns.

C) Encrypt all data the same way regardless of classification

D) Let each team classify their own data and manage their own access controls

**Correct Answer: B**
**Explanation:** Automated classification using Macie ensures consistent application of the classification framework without relying on humans to correctly tag data. Custom data identifiers allow organization-specific patterns (e.g., internal project codes, custom PII formats). Lake Formation LF-TBAC enforces access controls at query time based on classification tags — an analyst querying the data lake only sees data matching their clearance level. Differentiated encryption ensures the most sensitive data has the strictest key controls. Anomaly-based monitoring on Restricted data provides an additional security layer. Option A is static and quickly outdated. Option C wastes resources on encrypting public data with high-security keys. Option D leads to inconsistent classification across teams.

---

### Question 24
A company runs a PCI DSS compliant e-commerce platform. They need to implement file integrity monitoring (FIM) for critical system files on their EC2 instances running in the CDE. PCI DSS Requirement 11.5 requires alerting on unauthorized file modifications. What should the architect implement?

A) Compare EC2 AMI checksums weekly to detect modifications

B) Deploy AWS Systems Manager with a custom SSM document that runs file integrity monitoring: (1) Install Amazon Inspector agent on all CDE EC2 instances for vulnerability scanning and system configuration checks. (2) Use SSM State Manager to run a custom SSM document on a schedule (every 15 minutes) that computes SHA-256 hashes of critical files (/etc/passwd, /etc/shadow, application binaries, config files) and compares them against a baseline stored in SSM Parameter Store. (3) Hash mismatches trigger a CloudWatch custom metric. (4) CloudWatch Alarms on the metric send alerts via SNS to the security team. (5) Additionally, enable GuardDuty with EC2 Runtime Monitoring for real-time detection of suspicious file operations.

C) Use CloudTrail to monitor file changes on EC2 instances

D) Enable EBS encryption and assume files cannot be modified

**Correct Answer: B**
**Explanation:** PCI DSS 11.5 specifically requires file integrity monitoring software that alerts on unauthorized modification of critical system files. SSM provides agent-based file hash monitoring on EC2 instances. The custom document computes hashes at regular intervals and compares against a known-good baseline. GuardDuty Runtime Monitoring adds real-time detection of suspicious file operations (malware, unauthorized access). Together, they provide both scheduled and real-time FIM. Inspector adds vulnerability scanning as defense in depth. Option A — AMI comparison doesn't detect runtime file changes. Option C — CloudTrail monitors AWS API calls, not OS-level file changes. Option D — encryption prevents unauthorized data reading, not file modification by processes running on the instance.

---

### Question 25
An organization needs to implement SCP inheritance testing before deploying new policies. A misconfigured SCP could lock out all accounts from critical services. How should the architect implement safe SCP deployment?

A) Deploy SCPs directly to the root OU and fix any issues that arise

B) Implement a staged SCP deployment pipeline: (1) Author SCPs in a CodeCommit repository with peer review via pull requests. (2) CodePipeline triggers on merge — a Lambda function validates the SCP JSON syntax and simulates the policy effect using IAM Policy Simulator API with sample principals and actions. (3) Deploy the SCP first to a Sandbox OU containing test accounts with representative workloads. (4) Automated integration tests (Lambda functions making API calls in sandbox accounts) verify that intended actions are blocked AND permitted actions still work. (5) After 48-hour bake period with no alarms, promote to Development OU, then Staging, then Production with progressive bake periods. (6) Implement a kill-switch Lambda that can remove an SCP from the OU if critical services are impacted, triggered by a CloudWatch alarm monitoring for access denied errors.

C) Test SCPs using the IAM Policy Simulator in the management account

D) Apply SCPs during maintenance windows when no users are active

**Correct Answer: B**
**Explanation:** SCPs are high-impact controls — a mistake can instantly break all workloads in affected accounts. The staged deployment approach mirrors software deployment best practices. Pull request reviews catch logical errors. JSON validation and policy simulation catch syntax and logical issues. Sandbox testing with automated integration tests verifies both positive (intended blocks) and negative (no unintended blocks) outcomes. Progressive deployment with bake periods limits blast radius. The kill-switch provides rapid rollback if something slips through. Option A risks organization-wide outage. Option C — IAM Policy Simulator doesn't fully simulate SCP behavior in combination with existing policies. Option D — SCPs take effect immediately; maintenance windows don't help if the policy is wrong.

---

### Question 26
A company needs to build a real-time compliance monitoring dashboard that shows the compliance posture of their 200-account AWS Organization across multiple regulatory frameworks (HIPAA, PCI DSS, SOC 2, and GDPR). The dashboard must show per-account, per-framework compliance scores with drill-down capability. What architecture should the architect design?

A) Manually compile compliance reports from each framework's assessment monthly

B) Build a centralized compliance data pipeline: (1) AWS Security Hub as the aggregation point — enable HIPAA, PCI DSS, and AWS Foundational Security Best Practices standards. (2) AWS Audit Manager running concurrent assessments for each framework with automated evidence collection. (3) EventBridge pipes Security Hub findings to a Kinesis Data Firehose that delivers to S3 in the analytics account. (4) AWS Glue ETL maps findings to framework controls (a Security Hub finding may satisfy multiple framework controls). (5) Amazon Athena queries the processed data for per-account, per-framework compliance calculations. (6) Amazon QuickSight dashboard with embedded analytics for the compliance team — filtered views by account, framework, and control category. (7) QuickSight SPICE dataset refreshes hourly for near-real-time compliance visibility.

C) Use AWS Config aggregator dashboard for compliance visibility

D) Deploy a third-party GRC (Governance Risk and Compliance) tool and manually import AWS data

**Correct Answer: B**
**Explanation:** This architecture creates a unified compliance view across multiple frameworks. Security Hub aggregates technical findings from Config rules, Inspector, Macie, and GuardDuty. Audit Manager provides framework-specific evidence collection. The data pipeline normalizes findings across frameworks — a single security control may satisfy requirements in multiple frameworks (e.g., encryption at rest is required by HIPAA, PCI DSS, and SOC 2). QuickSight provides the interactive dashboard with drill-down capability. SPICE provides fast, cached queries for the dashboard. Option A doesn't provide real-time visibility. Option C shows Config compliance but doesn't map to regulatory frameworks. Option D adds operational overhead for data import/export.

---

### Question 27
A company needs to implement a guardrail that prevents any AWS account in their organization from deploying resources using deprecated or vulnerable AMIs. Only AMIs approved by the security team and published to a shared AMI catalog should be allowed. How should the architect enforce this?

A) Send a monthly email to all teams listing approved AMIs

B) Implement a multi-layered AMI governance approach: (1) The security team publishes approved AMIs to the management account and shares them with the organization using EC2 Image Builder with automated vulnerability scanning. (2) Create an SCP that allows `ec2:RunInstances` only when the `ec2:ImageId` condition matches AMIs owned by the management account: `{"Condition": {"StringEquals": {"ec2:Owner": "MANAGEMENT_ACCOUNT_ID"}}}`. (3) Deploy an AWS Config custom rule that evaluates running instances against the approved AMI list (stored in SSM Parameter Store), detecting instances launched from newly deprecated AMIs. (4) EventBridge notifies the security team of non-compliant instances.

C) Use AWS License Manager to track AMI usage

D) Restrict IAM permissions so only the security team can launch EC2 instances

**Correct Answer: B**
**Explanation:** Image Builder automates the creation and testing of hardened AMIs, including vulnerability scanning before approval. The SCP with `ec2:Owner` condition ensures only AMIs from the management account (security team's approved catalog) can be used to launch instances — this is a preventive control that applies across all accounts. The Config rule provides detective monitoring for instances that may have been launched before the SCP was applied or from AMIs that were subsequently deprecated. SSM Parameter Store allows the approved AMI list to be updated without changing the Config rule. Option A relies on human compliance. Option C tracks licenses, not AMI security. Option D is too restrictive — all teams need to launch instances.

---

### Question 28
A company operating under HIPAA needs to implement breach notification procedures. If a potential PHI breach is detected, they must assess, document, and notify affected individuals within 60 days. How should the architect automate breach detection and response workflows?

A) Wait for customer complaints to identify potential breaches

B) Implement automated breach detection and response: (1) GuardDuty detects suspicious activity (unusual API calls, unauthorized access, data exfiltration patterns). (2) Macie detects unprotected PHI in S3 (public access, unencrypted objects containing PHI). (3) Security Hub aggregates findings and applies custom severity scoring for PHI-related findings. (4) EventBridge routes high-severity PHI findings to a Step Functions breach response workflow. (5) The workflow: creates an incident record in DynamoDB, notifies the privacy officer via SNS/PagerDuty, generates a preliminary breach assessment report using Lambda (analyzing the scope of exposed records), creates a Jira/ServiceNow ticket via API, and starts a 60-day timer. (6) CloudWatch alarm monitors the timer — at 45 days, escalation notification fires if the incident is still open.

C) Review security logs quarterly for potential breaches

D) Use AWS Shield to prevent all breaches

**Correct Answer: B**
**Explanation:** HIPAA Breach Notification Rule requires covered entities to notify affected individuals within 60 days of breach discovery. Automated detection (GuardDuty + Macie) reduces the time between breach occurrence and discovery. The Step Functions workflow automates the response process: incident documentation, stakeholder notification, preliminary assessment, and timeline tracking. The 45-day escalation ensures the 60-day notification deadline isn't missed. Security Hub's aggregation prevents alert fatigue by correlating multiple findings into coherent incidents. Option A is reactive and violates the requirement for proactive breach detection. Option C — quarterly reviews could miss the 60-day notification window entirely. Option D — Shield protects against DDoS, not data breaches.

---

### Question 29
A multinational company needs to implement different data retention policies based on the country of data origin. US data must be retained for 7 years (SEC requirement), EU data for 5 years (GDPR limitation), and Australian data for 7 years (Privacy Act). Data is stored in S3 with country-of-origin metadata. How should the architect implement jurisdiction-specific retention?

A) Apply a single 7-year retention policy to all data

B) Implement jurisdiction-aware retention using S3 Object Lock and Lifecycle policies: (1) Tag all S3 objects with a `jurisdiction` tag (US/EU/AU) at ingestion time via a Lambda function triggered by S3 PUT events that reads the object metadata. (2) Create separate S3 buckets per jurisdiction, each with S3 Object Lock configured with the appropriate retention period (US/AU: 7 years Compliance mode, EU: 5 years Compliance mode). (3) Objects are routed to the correct bucket by the ingestion Lambda. (4) S3 Lifecycle policies transition to cheaper storage classes based on access patterns within each bucket. (5) An AWS Config rule validates that no objects exist without jurisdiction tags.

C) Delete all data after 5 years to be safe with the shortest retention requirement

D) Store retention dates in a DynamoDB table and use a Lambda function to delete expired objects

**Correct Answer: B**
**Explanation:** Jurisdiction-specific S3 buckets with Object Lock provide legally enforceable retention that cannot be overridden. Object Lock in Compliance mode prevents anyone (including root) from deleting data before the retention period expires — this satisfies SEC, GDPR, and Privacy Act requirements. Separate buckets allow different retention periods while maintaining clear jurisdiction boundaries. Lambda-based routing at ingestion ensures correct bucket placement. Lifecycle policies within each bucket optimize storage costs independently. Option A — retaining EU data for 7 years could violate GDPR's storage limitation principle (data shouldn't be kept longer than necessary). Option C — deleting US data after 5 years violates SEC 7-year requirement. Option D — DynamoDB-based tracking can have bugs; Object Lock provides infrastructure-level enforcement.

---

### Question 30
A company needs to implement a comprehensive tagging governance strategy. They want to: enforce mandatory tags at resource creation, prevent tag modification by non-authorized users, and generate cost allocation reports by tag dimensions. Their organization has 100 accounts across 4 OUs. What approach provides the MOST comprehensive tagging governance?

A) Document tagging requirements and hope teams comply

B) Implement a multi-layered tagging governance architecture: (1) AWS Organizations Tag Policies define required tags and allowed values at the OU level. (2) SCPs with `aws:RequestTag` conditions deny resource creation without mandatory tags (CostCenter, Environment, Owner, DataClassification). (3) SCPs with `aws:TagKeys` condition deny tag modification for `CostCenter` and `DataClassification` tags except by a specific governance role: `{"Effect": "Deny", "Action": ["*:TagResource", "*:UntagResource"], "Condition": {"ForAnyValue:StringEquals": {"aws:TagKeys": ["CostCenter", "DataClassification"]}, "StringNotLike": {"aws:PrincipalArn": "arn:aws:iam::*:role/TagGovernanceRole"}}}`. (4) AWS Config rules detect untagged resources (legacy). (5) Cost Explorer tag-based allocation groups and AWS Cost and Usage Report with tag columns enable financial reporting.

C) Use AWS Service Catalog to provide pre-tagged resources

D) Deploy a Lambda function that tags resources post-creation using a mapping table

**Correct Answer: B**
**Explanation:** This addresses all three requirements: (1) SCP `aws:RequestTag` conditions prevent untagged resource creation — a hard API-level block. (2) SCP `aws:TagKeys` conditions with principal exception protect tags from unauthorized modification — only the governance role can change CostCenter and DataClassification. This prevents cost center gaming. (3) Cost Explorer and CUR with tag-based allocation enable the financial reporting. Tag Policies provide organizational-level tag standardization (consistent keys and allowed values). Config rules catch legacy resources created before the SCP enforcement. Option A provides no enforcement. Option C only works if all resources are created through Service Catalog. Option D allows a window where resources exist without proper tags.

---

### Question 31
A company using AWS for their HIPAA-regulated workloads needs to implement a minimum necessary access policy — the HIPAA Minimum Necessary Rule requires that access to PHI is limited to only the minimum necessary to accomplish the intended purpose. How should the architect enforce this across their application stack?

A) Give all employees full read access to PHI databases and trust them to access only what they need

B) Implement attribute-based access control (ABAC) across the stack: (1) Use Amazon Cognito with custom claims that include the user's role, department, and authorized patient population. (2) API Gateway authorizer validates Cognito tokens and extracts claims. (3) Lambda functions use the claims to construct DynamoDB queries with condition expressions that filter to only the patient records the user is authorized to access. (4) IAM policies on the Lambda execution role use `dynamodb:LeadingKeys` with session tags derived from Cognito claims to enforce row-level access at the IAM level. (5) Enable DynamoDB Streams to log all data access to an audit table for compliance verification. (6) Amazon Macie monitors S3 storage for PHI exposure.

C) Implement network-level isolation — each department gets its own VPC with no cross-VPC access

D) Use column-level encryption so users can only decrypt columns they need

**Correct Answer: B**
**Explanation:** The Minimum Necessary Rule requires role-based access at the data record level. ABAC using Cognito claims flows the user's authorization context from authentication through to data access. DynamoDB fine-grained access control with `dynamodb:LeadingKeys` enforces at the AWS API level — even if the application code has a bug, IAM prevents accessing unauthorized records. Audit logging via DynamoDB Streams provides evidence of compliance. This creates defense in depth: application-level filtering + IAM-level enforcement + audit monitoring. Option A directly violates Minimum Necessary. Option C — network isolation doesn't provide record-level data access control. Option D helps but doesn't address row-level access to records.

---

### Question 32
A company needs to ensure compliance with the NIST 800-53 security framework for their FedRAMP authorization. They need to implement continuous monitoring and produce monthly POA&M (Plan of Action and Milestones) reports. How should the architect design the monitoring and reporting system?

A) Hire additional staff to manually assess NIST controls monthly

B) Deploy AWS Audit Manager with the NIST 800-53 Rev 5 framework: (1) Audit Manager maps NIST controls to automated evidence (CloudTrail, Config, Security Hub findings). (2) Schedule assessments to run continuously, collecting evidence automatically. (3) Use AWS Security Hub with the NIST 800-53 standard enabled for real-time control evaluation. (4) Build a POA&M automation pipeline: Lambda function queries Security Hub for failed controls and Audit Manager for incomplete evidence, generates a structured POA&M document, and stores it in S3. (5) Amazon QuickSight dashboard visualizes the current security posture against NIST controls. (6) EventBridge scheduled rule triggers monthly POA&M generation with SNS notification to the compliance team.

C) Use AWS Artifact to download AWS's FedRAMP authorization package and submit it as the company's own

D) Implement all 1,000+ NIST controls manually in IAM policies

**Correct Answer: B**
**Explanation:** NIST 800-53 continuous monitoring requires ongoing evidence collection and regular reporting. Audit Manager with the NIST 800-53 framework provides the control-to-evidence mapping that FedRAMP assessors expect. Security Hub's NIST 800-53 standard automates the evaluation of technical controls. The automated POA&M generation ensures monthly reports are produced consistently and on time — a FedRAMP requirement. QuickSight provides the continuous monitoring visibility that FedRAMP requires. Option A doesn't scale for the 1,000+ controls. Option C — AWS's authorization covers the infrastructure; customers need their own authorization for their workloads. Option D conflates IAM policies with the full scope of NIST controls (which include physical, procedural, and technical controls).

---

### Question 33
A company stores sensitive data in Amazon Redshift and needs to implement column-level security. Some columns contain PII (SSN, email, phone) that should only be accessible by HR and compliance teams. Other columns (name, department) can be accessed by all authorized users. How should the architect implement this?

A) Create separate Redshift clusters for PII and non-PII data

B) Implement Redshift column-level access control: (1) Create Redshift database groups for different access levels (hr_group, compliance_group, general_group). (2) Use GRANT and REVOKE statements at the column level: `GRANT SELECT (name, department, employee_id) ON employees TO GROUP general_group; GRANT SELECT ON employees TO GROUP hr_group;`. (3) For additional protection, use dynamic data masking on PII columns for the general group: `CREATE MASKING POLICY mask_ssn WITH (ssn VARCHAR(11)) USING ('XXX-XX-' || RIGHT(ssn, 4)); ATTACH MASKING POLICY mask_ssn ON employees(ssn) TO PUBLIC;` while exempting hr_group and compliance_group. (4) Enable Redshift audit logging to capture all column-level access. (5) Use Lake Formation if accessing Redshift through the Redshift Spectrum or data sharing.

C) Encrypt only the PII columns and give decryption keys to HR

D) Use views that exclude PII columns for general users

**Correct Answer: B**
**Explanation:** Redshift native column-level GRANT/REVOKE provides granular access control without data duplication. Dynamic data masking adds a layer of protection — general users see masked PII (useful for partial access patterns like displaying last 4 digits of SSN). Audit logging captures who accessed which columns, satisfying compliance requirements. This is more maintainable than views because column permissions are managed through standard SQL GRANT statements rather than maintaining multiple view definitions. Option A doubles infrastructure cost and complicates queries that need both PII and non-PII data. Option C — application-level encryption is harder to manage and doesn't prevent authorized Redshift users from seeing raw encrypted values. Option D — views work but are less flexible than native column-level permissions and don't support data masking.

---

### Question 34
A company needs to implement an SCP that allows only specific EC2 instance types in production accounts to control costs and maintain compliance with their approved instance family list. However, the SCP must not break existing Auto Scaling groups that may reference older instance types. How should the architect handle this?

A) Create the SCP immediately and accept that some Auto Scaling groups may break

B) Implement a phased SCP rollout with inventory analysis: (1) First, deploy an AWS Config rule that inventories all EC2 instance types currently in use across production accounts. (2) Cross-reference the inventory against the approved instance list to identify gaps. (3) Work with teams to update Auto Scaling group launch templates/configurations to use approved instance types. (4) Once all production workloads use approved types, deploy the SCP: `{"Effect": "Deny", "Action": "ec2:RunInstances", "Resource": "arn:aws:ec2:*:*:instance/*", "Condition": {"ForAnyValue:StringNotLike": {"ec2:InstanceType": ["m5.*", "m6i.*", "r5.*", "r6i.*", "c5.*", "c6i.*", "t3.*"]}}}`. (5) Monitor for AccessDenied errors in CloudTrail for 30 days post-deployment.

C) Use AWS Compute Optimizer to automatically change all instances to approved types

D) Implement the restriction at the IAM level in each account instead of using SCPs

**Correct Answer: B**
**Explanation:** The phased approach prevents disruption to existing workloads. Config inventory identifies all current instance types, enabling gap analysis. Teams can proactively update their launch configurations before the SCP takes effect. The SCP uses wildcards (e.g., `m5.*`) to allow all sizes within approved families. CloudTrail monitoring post-deployment catches any unexpected denials. This balances compliance enforcement with operational stability. Option A risks production outages if Auto Scaling tries to launch a non-approved type. Option C — Compute Optimizer recommends but doesn't enforce types, and automatic changes could cause application issues. Option D — IAM restrictions can be overridden by account admins, defeating the purpose.

---

### Question 35
A company needs to implement AWS PrivateLink governance to ensure that VPC endpoints created across their organization only connect to approved AWS services and approved third-party PrivateLink services. Unauthorized endpoints could create data exfiltration paths. How should the architect enforce this?

A) Review VPC endpoint configurations during quarterly audits

B) Implement endpoint governance with SCPs and Config: (1) Create an SCP that denies `ec2:CreateVpcEndpoint` unless the `ec2:VpceServiceName` condition matches an allow-list of approved service names: `{"Effect": "Deny", "Action": "ec2:CreateVpcEndpoint", "Condition": {"ForAnyValue:StringNotEquals": {"ec2:VpceServiceName": ["com.amazonaws.*.s3", "com.amazonaws.*.dynamodb", "com.amazonaws.*.sqs", "com.amazonaws.*.kms", "com.amazonaws.vpce-svc-APPROVED1"]}}}`. (2) Deploy AWS Config custom rule that evaluates all existing VPC endpoints against the approved list. (3) EventBridge rule captures CreateVpcEndpoint CloudTrail events and notifies the security team for review.

C) Use Security Groups on VPC endpoints to control access

D) Block all VPC endpoints and require all traffic to go through a NAT Gateway with inspection

**Correct Answer: B**
**Explanation:** VPC endpoints can create private network paths to AWS services or third-party services, potentially bypassing network inspection. The SCP prevents creation of unauthorized endpoints at the API level. The approved list controls both AWS service endpoints (S3, DynamoDB, SQS, KMS) and specific third-party PrivateLink services. Config rules detect any existing unauthorized endpoints. EventBridge provides real-time notification for audit purposes. Option A has a 3-month detection gap. Option C — security groups control access to the endpoint, not which services are connected to. Option D reduces performance and increases cost while still not preventing endpoint creation.

---

### Question 36
A company processing credit card data needs to implement PCI DSS Requirement 3 (Protect Stored Cardholder Data). They store card data in Aurora PostgreSQL and need to ensure that PAN (Primary Account Number) is rendered unreadable anywhere it is stored, and that decryption keys are managed securely. What architecture should the architect implement?

A) Use Aurora's default encryption at rest, which encrypts the entire database

B) Implement application-level field encryption for PAN data: (1) Use AWS KMS with a dedicated CMK for cardholder data encryption, with a key policy restricting usage to the payment processing Lambda function role only. (2) Encrypt PAN in the application layer before writing to Aurora — store the encrypted PAN in the database (AES-256-GCM via AWS Encryption SDK). (3) Store the last 4 digits in a separate plaintext column for display purposes (PCI DSS allows this). (4) Enable Aurora encryption at rest (KMS) as an additional layer. (5) Enable SSL/TLS for Aurora connections (encryption in transit). (6) Implement KMS key rotation annually. (7) Use CloudTrail to log all KMS Decrypt calls for the cardholder data key.

C) Use PostgreSQL's pgcrypto extension for encryption within the database

D) Tokenize PAN using a third-party tokenization service and don't store actual card numbers

**Correct Answer: B**
**Explanation:** PCI DSS Requirement 3 requires PAN to be rendered unreadable wherever it is stored. Application-level encryption ensures PAN is encrypted before reaching the database — even database administrators cannot read the PAN without the KMS key. The KMS key policy restricts decryption to only the payment processing role, enforcing separation of duties. Aurora encryption at rest + SSL/TLS in transit provide defense in depth. The last-4-digits column satisfies the common business need to display partial PAN (explicitly permitted by PCI DSS). Annual key rotation satisfies PCI DSS 3.6.4. CloudTrail logging of KMS Decrypt calls satisfies audit requirements. Option A — database-level encryption doesn't protect against database admin access or SQL injection. Option C — pgcrypto stores keys in the database, violating key management requirements. Option D is also valid but the question asks about storing card data, not tokenization as an alternative.

---

### Question 37
An organization needs to implement a detective control to identify overly permissive IAM policies across their 200-account AWS Organization. They need to find policies that grant `*` actions or `*` resources, cross-account access to untrusted accounts, and policies with no conditions. How should the architect implement this analysis?

A) Manually review IAM policies in each account during audits

B) Deploy IAM Access Analyzer at the organization level: (1) Enable IAM Access Analyzer in the management account with the organization as the zone of trust. (2) Access Analyzer identifies resources shared outside the organization (S3 buckets, KMS keys, IAM roles with cross-account trust). (3) For overly permissive policy detection, deploy a Lambda function (triggered weekly by EventBridge) that uses `iam:GetAccountAuthorizationDetails` API in each account (via cross-account role) to retrieve all policies, then analyzes policy documents for: `Action: "*"`, `Resource: "*"`, missing condition blocks, and trust policies allowing external accounts. (4) Results are written to a DynamoDB table and surfaced via a QuickSight dashboard. (5) IAM Access Analyzer policy validation feature validates policies against AWS best practices.

C) Use AWS Trusted Advisor to check IAM best practices

D) Enable AWS Config rule `iam-policy-no-statements-with-admin-access` in all accounts

**Correct Answer: B**
**Explanation:** IAM Access Analyzer at the organization level identifies external access findings — resources shared outside the organization zone of trust. The custom Lambda analysis extends this to internal policy hygiene: detecting wildcard permissions, missing conditions, and overly broad resource scopes within the organization. Access Analyzer's policy validation feature can check policies against AWS IAM best practices (security warnings, suggestions). The DynamoDB + QuickSight combination provides a searchable, visual dashboard for the security team. Option A doesn't scale to 200 accounts. Option C only checks a few IAM best practices and doesn't analyze policy content. Option D only catches the `iam:*` + `resource:*` combination, missing other overly permissive patterns.

---

### Question 38
A company needs to implement AWS Config conformance packs across their 150-account organization. The conformance packs must include both managed and custom rules for their specific compliance requirements. Some accounts have unique rules that don't apply to all accounts. How should the architect manage the deployment?

A) Manually deploy Config rules in each account individually

B) Implement a hierarchical conformance pack deployment: (1) Create a base conformance pack template with rules applicable to ALL accounts (encryption checks, logging checks, public access checks) and deploy it as an organization conformance pack from the delegated administrator account. (2) Create OU-specific conformance pack templates (e.g., PCI rules for the CDE OU, HIPAA rules for the healthcare OU) and deploy them using CloudFormation StackSets targeted to specific OUs. (3) For account-specific rules, deploy individual conformance packs via StackSets with account-level targeting. (4) Store conformance pack templates in CodeCommit with CI/CD pipeline validation (cfn-lint, cfn-guard for template correctness). (5) Use Config aggregator in the delegated admin account for organization-wide compliance visibility.

C) Deploy all rules everywhere and use suppression for accounts where they don't apply

D) Let each account team manage their own Config rules

**Correct Answer: B**
**Explanation:** The hierarchical approach balances centralized governance with account/OU-specific requirements. Organization conformance packs automatically deploy to all current and future accounts for baseline rules. OU-targeted StackSets deploy regulatory-specific rules only where needed (avoids unnecessary rule costs and false positives). Account-level targeting handles unique requirements. CodeCommit + CI/CD ensures template quality before deployment. Config aggregator provides the single-pane compliance view. Option A doesn't scale. Option C wastes money on unnecessary rule evaluations and creates noise from irrelevant non-compliance findings. Option D leads to inconsistent compliance evaluation.

---

### Question 39
A company operating under GDPR needs to implement Privacy by Design for a new customer-facing application. The architecture must minimize data collection, support data portability (Article 20), and implement purpose limitation. How should the architect design the application?

A) Collect all possible data and filter what's needed later

B) Implement Privacy by Design architecture: (1) Data minimization — the API Gateway request validation schema rejects requests with fields not required for the specific operation. Lambda functions further validate that only necessary data fields are processed. (2) Purpose limitation — DynamoDB table design uses separate items for each processing purpose (marketing consent, service delivery, analytics) with TTL set per purpose. A purpose-tracking attribute on each record links data to its consent basis. (3) Data portability — an export API endpoint triggers a Step Functions workflow that: queries all customer data across services, formats it as JSON (machine-readable, standard format per Article 20), generates a signed download URL from S3, and notifies the customer. (4) Consent management service tracks granular consent per purpose, integrated with the processing logic. (5) Lake Formation column-level access enforces purpose limitation at the analytics layer.

C) Use standard application architecture and add GDPR features later

D) Store all data encrypted and consider that sufficient for GDPR compliance

**Correct Answer: B**
**Explanation:** GDPR Privacy by Design (Article 25) requires data protection measures built into the architecture from the start. Data minimization through API validation and processing validation ensures only necessary data is collected and processed — a core GDPR principle. Purpose limitation through separate storage items and purpose tracking ensures data collected for one purpose isn't used for another. The data portability API directly implements Article 20 — customers can export their data in a machine-readable format. Consent management ensures all processing has a valid legal basis. Lake Formation enforces purpose limitation at the analytics level. Option A violates data minimization. Option C — retrofit is expensive and often incomplete. Option D — encryption is one technical measure but doesn't address GDPR's broader requirements.

---

### Question 40
A company needs to implement an automated response to security findings from GuardDuty across their organization. Different finding types require different responses: cryptocurrency mining should trigger immediate instance isolation, unauthorized access should trigger MFA enforcement, and data exfiltration should trigger VPC flow log capture and network isolation. How should the architect design the automated response system?

A) Have the security team manually triage each GuardDuty finding

B) Build an automated security response orchestration: (1) GuardDuty findings from all accounts aggregate in the delegated admin account via GuardDuty organization configuration. (2) EventBridge rules filter findings by type: `CryptoCurrency:EC2/BitcoinTool.B!DNS` → "crypto-mining" response, `UnauthorizedAccess:IAMUser/ConsoleLoginSuccess.B` → "unauthorized-access" response, `Exfiltration:S3/MaliciousIPCaller` → "data-exfiltration" response. (3) Each EventBridge rule targets a specific Step Functions workflow. (4) Crypto-mining workflow: modifies the instance's security group to a quarantine SG (deny all egress), creates an EBS snapshot for forensics, sends PagerDuty alert. (5) Unauthorized access workflow: applies an IAM deny-all policy to the compromised user, forces MFA via SCP, notifies the security team. (6) Data exfiltration workflow: enables VPC flow logs on the affected ENI, captures packet data to S3, isolates the resource. (7) All actions logged to a DynamoDB incident table.

C) Use AWS Shield Advanced to automatically block all threats

D) Configure GuardDuty to automatically suppress all findings below HIGH severity

**Correct Answer: B**
**Explanation:** Automated security response (SOAR — Security Orchestration, Automation, and Response) reduces mean time to respond (MTTR) from hours to seconds. Different finding types require different responses — crypto mining needs immediate isolation to stop costs, unauthorized access needs credential revocation, data exfiltration needs evidence preservation before isolation. Step Functions workflows provide reliable, auditable automation with error handling. GuardDuty organization configuration ensures coverage across all accounts. The forensic preservation steps (EBS snapshots, flow logs) are critical for post-incident investigation. Option A introduces dangerous delays. Option C — Shield protects against DDoS, not the finding types mentioned. Option D suppressing findings below HIGH misses important security events.

---

### Question 41
A company needs to design a highly available, multi-Region architecture for a customer-facing application that also meets data residency requirements. European customers' data must stay in eu-west-1 and eu-central-1, while US customers' data must stay in us-east-1 and us-west-2. The application must provide sub-200ms latency globally. What architecture should the architect design?

A) Deploy the application in all four regions with global database replication

B) Deploy the application stack in all four regions. Use Route 53 geolocation routing to direct European customers to eu-west-1 (primary) with eu-central-1 as failover, and US customers to us-east-1 (primary) with us-west-2 as failover. Use Aurora PostgreSQL with regional clusters — EU cluster with read replicas across eu-west-1 and eu-central-1 (no replication to US regions), and US cluster across us-east-1 and us-west-2 (no replication to EU regions). CloudFront with origin groups for latency optimization — geo-restrict EU content to EU edge locations and US content to US edge locations. Application layer deployed on ECS Fargate with regional Auto Scaling.

C) Use a single Region with CloudFront for global distribution

D) Deploy separate AWS accounts per region with no cross-region connectivity

**Correct Answer: B**
**Explanation:** Geolocation routing ensures customers are directed to the correct jurisdiction. Aurora regional clusters maintain data residency by keeping EU data within EU regions and US data within US regions — no cross-jurisdiction replication. Each jurisdiction has two regions for high availability (primary + failover). CloudFront provides edge caching for sub-200ms latency while geo-restriction prevents content caching in the wrong jurisdiction. ECS Fargate eliminates server management. This architecture satisfies all three requirements: data residency, high availability, and low latency. Option A — global replication violates data residency. Option C — single region doesn't meet high availability or latency requirements. Option D — separate accounts add operational complexity without benefit.

---

### Question 42
A company needs to design a serverless event-driven architecture for processing insurance claims. Each claim goes through: document upload, OCR extraction, fraud detection, adjudication rules engine, payment processing, and notification. Claims can be paused for manual review at any stage. The system must handle 10,000 claims per day. What architecture should the architect design?

A) Build a monolithic application on EC2 that processes claims sequentially

B) Use Step Functions with a combination of standard and callback patterns: (1) S3 upload triggers EventBridge → Step Functions Standard workflow execution. (2) Amazon Textract async job for OCR extraction of claim documents. (3) Lambda function runs fraud detection rules against the extracted data, calling Amazon Fraud Detector for ML-based scoring. (4) For claims flagged for manual review, use Step Functions Task Token with an activity — the workflow pauses until a human approver calls SendTaskSuccess via an internal web portal (API Gateway + Lambda). (5) Lambda function executes adjudication rules from a DynamoDB rules table. (6) Payment processing via Step Functions integration with SQS (decoupling the payment service). (7) Amazon SES for customer notification. DynamoDB table tracks claim state with GSI for status queries.

C) Use SQS queues between each processing stage with Lambda consumers

D) Deploy the claim processing as microservices on EKS

**Correct Answer: B**
**Explanation:** Step Functions Standard workflows provide the orchestration, state management, and human-in-the-loop capability required. The callback pattern (Task Token) is essential — it allows the workflow to pause indefinitely for manual review without consuming resources, resuming only when the reviewer completes their action. Textract handles OCR at scale. Fraud Detector provides ML-based fraud scoring. SQS decoupling for payment processing prevents payment service issues from blocking the workflow. DynamoDB provides fast claim status lookups. At 10,000 claims/day (~7/minute), serverless handles the load easily. Option A doesn't scale and is a single point of failure. Option C loses orchestration visibility and makes human-in-the-loop difficult to implement. Option D adds unnecessary infrastructure management.

---

### Question 43
A company has an existing monolithic .NET application running on EC2 that processes batch jobs. The application frequently runs out of memory during peak processing, causing job failures. The team wants to improve reliability without a full rewrite. What should the architect recommend as an immediate improvement?

A) Increase the EC2 instance size to handle peak memory requirements

B) Implement a decoupled batch processing architecture: (1) Move the batch job queue from the in-memory queue to SQS with a dead letter queue for failed jobs. (2) Deploy the existing .NET application in a Docker container on ECS Fargate with increased memory limits per task. (3) Configure ECS Service Auto Scaling based on the SQS queue depth — scale up tasks when queue depth increases, scale down when empty. (4) Implement SQS visibility timeout aligned with the maximum expected processing time. (5) Add CloudWatch alarms on DLQ depth for monitoring failed jobs. This preserves the existing code while adding reliability through decoupling and horizontal scaling.

C) Rewrite the entire application in Lambda functions

D) Add swap space to the EC2 instance to handle memory overflow

**Correct Answer: B**
**Explanation:** This approach improves reliability without a rewrite. SQS provides durable message storage — jobs aren't lost if the processing application crashes. Dead letter queues capture failed jobs for investigation. Containerizing on Fargate allows higher memory limits per task and horizontal scaling (multiple tasks processing in parallel). Auto Scaling based on queue depth matches capacity to demand. The existing .NET code runs unchanged in the container. Option A is vertical scaling with a ceiling and still has the single-point-of-failure problem. Option C requires a complete rewrite which was explicitly not desired. Option D — swap space degrades performance significantly and doesn't solve the fundamental architecture issue.

---

### Question 44
A company's existing multi-tier application on AWS has increasing latency on database reads. The Aurora PostgreSQL database handles both OLTP transactions and reporting queries. Read replicas are at maximum capacity. What should the architect recommend to improve performance?

A) Upgrade the Aurora instance to a larger size

B) Separate OLTP and analytical workloads: (1) Keep Aurora PostgreSQL for OLTP transactions (writes and transactional reads). (2) Create an Aurora read replica specifically sized for reporting workloads, or better, use Amazon Redshift for analytical queries. (3) Use AWS DMS with CDC (Change Data Capture) to continuously replicate data from Aurora to Redshift for reporting. (4) Implement Amazon ElastiCache (Redis) for frequently accessed read patterns — cache lookup results, session data, and materialized query results. (5) Update the application to use a reader endpoint for read-only queries and the writer endpoint only for transactions.

C) Add more read replicas beyond the current limit by using cross-region replicas

D) Convert all reads to eventually consistent reads

**Correct Answer: B**
**Explanation:** Separating OLTP from analytical workloads is the CQRS (Command Query Responsibility Segregation) pattern. Aurora is optimized for OLTP (fast point queries, transactions), while Redshift is optimized for analytical queries (aggregations, complex joins across large datasets). DMS with CDC keeps Redshift in near-real-time sync. ElastiCache provides sub-millisecond reads for hot data, reducing load on Aurora. Using reader endpoints distributes remaining reads across replicas efficiently. This addresses the root cause (mixed workload) rather than just adding capacity. Option A has diminishing returns and doesn't solve the workload mixing issue. Option C — Aurora supports up to 15 read replicas, and cross-region adds latency. Option D — Aurora PostgreSQL doesn't have eventually consistent reads like DynamoDB.

---

### Question 45
A company has a legacy application that writes logs to local disk on EC2 instances. During scaling events, logs from terminated instances are lost. The operations team needs centralized, searchable logging without modifying the application code. What should the architect implement?

A) Increase the EBS volume size on each instance to store more logs

B) Deploy the CloudWatch agent on all EC2 instances via SSM State Manager: (1) Configure the CloudWatch agent to collect the application log files from the local disk paths and send them to CloudWatch Logs. (2) Use SSM State Manager to ensure the agent configuration is applied to all existing and new instances (association targets the Auto Scaling group tag). (3) Set appropriate CloudWatch Logs retention periods per log group. (4) Create CloudWatch Logs Insights queries for operational troubleshooting. (5) For long-term storage and advanced analytics, configure a CloudWatch Logs subscription filter to stream logs to S3 via Kinesis Data Firehose.

C) Mount an EFS filesystem on all instances and configure the application to write logs to EFS

D) Use rsync to copy logs to S3 every hour

**Correct Answer: B**
**Explanation:** The CloudWatch agent reads log files from disk and streams them to CloudWatch Logs — no application code changes required. SSM State Manager ensures the agent is deployed and configured on all instances, including newly launched ones from Auto Scaling. CloudWatch Logs Insights provides SQL-like querying across all log groups. The Kinesis Firehose to S3 pipeline provides cost-effective long-term storage and enables Athena queries for deeper analysis. Option A doesn't solve the centralization problem or log loss during termination. Option C requires application code changes (different log path) and adds EFS cost/complexity. Option D has an hour-long data loss window and requires custom scripting.

---

### Question 46
A company runs a data analytics platform on EMR clusters that process daily batch jobs. The clusters are running 24/7 but jobs only execute for 8 hours per day. The remaining 16 hours the clusters are idle. How should the architect optimize this?

A) Keep the clusters running 24/7 for fastest job start times

B) Transition to transient EMR clusters with Step Functions orchestration: (1) EventBridge scheduled rule triggers a Step Functions workflow at the batch processing start time. (2) Step Functions creates an EMR cluster with the required configuration (instance types, software, bootstrap actions). (3) EMR steps are submitted as part of the cluster creation. (4) Step Functions monitors EMR step completion using the built-in EMR integration (.sync pattern). (5) After all steps complete, Step Functions terminates the cluster. (6) Use EMR Managed Scaling with Spot instances for task nodes to minimize compute cost. (7) Store intermediate data in S3 (not HDFS) so data persists between cluster lifetimes. (8) Estimated savings: ~67% (16/24 hours of idle time eliminated).

C) Downsize the cluster during idle hours

D) Move all processing to Lambda functions

**Correct Answer: B**
**Explanation:** Transient clusters run only when needed, eliminating the 16 hours of daily idle cost (~67% savings). Step Functions provides reliable orchestration — creating the cluster, submitting jobs, monitoring completion, and terminating the cluster. The .sync integration pattern waits for EMR steps to complete before proceeding. Spot instances for task nodes reduce compute costs by an additional 60-90%. S3-based storage ensures data persists between transient cluster lifetimes (HDFS data would be lost). EMR Managed Scaling adjusts cluster size during processing based on workload demand. Option A wastes 67% of the cluster cost. Option C saves some cost but still has idle capacity overhead. Option D — Lambda has execution time limits and isn't suited for large-scale data processing.

---

### Question 47
A company has an existing application using self-managed RabbitMQ on EC2 for message queuing. The RabbitMQ cluster requires significant operational overhead for patching, monitoring, and scaling. The company wants to reduce operational burden while minimizing application changes. What migration path should the architect recommend?

A) Rewrite the application to use Amazon SQS

B) Migrate to Amazon MQ for RabbitMQ: (1) Deploy Amazon MQ with an active/standby broker configuration for high availability. (2) Amazon MQ supports the RabbitMQ engine natively — the application connects using the same AMQP protocol and client libraries, requiring only connection string changes. (3) Configure the broker with appropriate instance size based on current RabbitMQ metrics (message throughput, queue depth). (4) Enable Amazon MQ CloudWatch metrics for monitoring. (5) Enable automatic minor version upgrades. (6) Set up a maintenance window for patching. (7) Migrate by updating the application connection strings from the self-managed cluster to the Amazon MQ endpoints during a maintenance window.

C) Move to Amazon Kinesis Data Streams for messaging

D) Deploy RabbitMQ on EKS for container-based management

**Correct Answer: B**
**Explanation:** Amazon MQ for RabbitMQ is a managed service that runs the actual RabbitMQ engine. Applications using AMQP protocol connect to Amazon MQ with only connection string changes — no code modifications to producers or consumers. Amazon MQ handles patching, monitoring integration, backups, and high availability (active/standby). This provides the minimum-change migration path. Option A — SQS uses a different API and messaging model; rewriting adds risk and development time. Option C — Kinesis is a streaming platform, not a message broker; different paradigm. Option D — EKS reduces some operational overhead but still requires managing the RabbitMQ cluster, patching containers, and configuring scaling.

---

### Question 48
A company with strict compliance requirements needs to restrict all AWS API calls to originate from their corporate network only. Employees should not be able to access AWS accounts from home or public networks without VPN. How should the architect enforce this across all accounts?

A) Configure MFA on all IAM users and trust that employees use VPN

B) Implement network-based access controls using SCPs with VPC endpoint conditions and IP restrictions: (1) Deploy a VPC with AWS PrivateLink endpoints for all required AWS services in the corporate-connected VPC (connected via Direct Connect or VPN). (2) Create an SCP that denies all actions unless the request comes from the corporate VPC endpoint or corporate public IP ranges: `{"Effect": "Deny", "Action": "*", "Resource": "*", "Condition": {"StringNotEqualsIfExists": {"aws:SourceVpc": "vpc-corporate"}, "NotIpAddressIfExists": {"aws:SourceIp": ["203.0.113.0/24"]}, "BoolIfExists": {"aws:ViaAWSService": "false"}}}`. (3) The `aws:ViaAWSService` exception allows AWS services to make calls on behalf of users (e.g., CloudFormation creating resources). (4) Exempt the management account's break-glass role from this restriction.

C) Use IAM policies in each account to restrict source IP

D) Disable programmatic access for all users

**Correct Answer: B**
**Explanation:** SCP-based network restriction ensures no AWS API call succeeds from outside the corporate network. The `aws:SourceVpc` condition restricts console/CLI/SDK access through the VPC endpoint. The `aws:SourceIp` condition covers API calls from the corporate public IP (for console access through the internet). The `aws:ViaAWSService` exception is critical — without it, AWS services making API calls on behalf of users (like CloudFormation creating resources, or S3 replication) would be blocked. The break-glass exception ensures account recovery is possible if the VPN/Direct Connect fails. Option A — MFA doesn't restrict network location. Option C — IAM policies can be modified by account admins. Option D prevents legitimate programmatic use cases.

---

### Question 49
A company is designing a disaster recovery strategy for their critical application currently running in us-east-1. The application uses Aurora PostgreSQL, ElastiCache Redis, and ECS Fargate. RTO is 1 hour and RPO is 5 minutes. The DR region is us-west-2. What architecture meets these requirements?

A) Take daily backups of all services and restore manually when needed

B) Implement a warm standby DR architecture: (1) Aurora PostgreSQL Global Database with the primary in us-east-1 and a secondary cluster in us-west-2 — provides RPO of typically <1 second (async replication) and promotes to read-write in <1 minute. (2) ElastiCache Global Datastore for Redis with the primary in us-east-1 and a secondary in us-west-2 — sub-second replication lag. (3) ECS Fargate service in us-west-2 running at minimum capacity (e.g., 2 tasks) — scaled up during failover via Application Auto Scaling. (4) Route 53 health checks on the us-east-1 endpoint with failover routing to us-west-2. (5) CodeDeploy/CodePipeline configured for multi-region deployments. (6) Regularly test failover with GameDays.

C) Use AWS Backup with cross-region copy for all services

D) Deploy an identical active-active setup in both regions

**Correct Answer: B**
**Explanation:** Warm standby meets the 1-hour RTO and 5-minute RPO requirements cost-effectively. Aurora Global Database provides <1-second RPO (well under 5 minutes) and <1-minute failover (well under 1-hour RTO). ElastiCache Global Datastore replicates cache state, avoiding cold-cache performance issues after failover. Running ECS at minimum capacity in the DR region means containers are pre-deployed and can scale up in minutes, not hours. Route 53 health check failover automates the traffic switch. Option A — daily backups have 24-hour RPO, violating the 5-minute requirement. Option C — backup restoration takes time, potentially exceeding the 1-hour RTO. Option D — active-active costs twice as much and is unnecessary for the stated RTO/RPO.

---

### Question 50
A company needs to design a secure, compliant architecture for processing government data classified as ITAR (International Traffic in Arms Regulations). Only US persons can access the data, and all processing must occur in the United States. What architecture controls should the architect implement?

A) Deploy in US regions and restrict access via IP-based controls

B) Implement a comprehensive ITAR-compliant architecture: (1) Use AWS GovCloud (US) regions (us-gov-west-1, us-gov-east-1) — these regions are operated by US persons and physically located in the US. (2) All IAM users and roles must have US person attestation — implement a custom authentication flow that validates citizenship status. (3) SCPs restrict all actions to GovCloud regions only. (4) Use AWS KMS with keys generated in GovCloud — key material never leaves GovCloud regions. (5) Enable CloudTrail with log file validation in GovCloud S3 buckets with Object Lock. (6) No VPC peering or connectivity to non-GovCloud accounts. (7) Use AWS PrivateLink for all service access — no internet-facing endpoints. (8) Implement mandatory access control (MAC) labels using resource tags.

C) Use standard AWS regions in the US (us-east-1, us-west-2) with encryption

D) Deploy on AWS Outposts in a US government facility

**Correct Answer: B**
**Explanation:** ITAR requires that technical data related to defense articles is only accessible by US persons and processed within the United States. AWS GovCloud is specifically designed for ITAR and other regulatory workloads — it's operated by screened US persons, physically located in the US, and has separate IAM identity stores. Standard US regions (Option C) don't provide the US person operational requirement. The SCP restriction to GovCloud prevents accidental resource creation in standard regions. PrivateLink eliminates internet exposure. CloudTrail with WORM storage provides audit compliance. Option A — IP-based controls don't verify US person status. Option C — standard regions may be operated by non-US persons. Option D — Outposts may work for some cases but doesn't provide the full ITAR control framework.

---

### Question 51
A company's AWS Config rules are generating thousands of non-compliant findings per day, causing alert fatigue for the security team. Many findings are for temporary non-compliance during deployments (e.g., an EC2 instance exists briefly without tags before the CI/CD pipeline applies them). How should the architect reduce noise while maintaining compliance visibility?

A) Disable Config rules that generate too many findings

B) Implement intelligent compliance filtering: (1) Create a Config rule evaluation Lambda that includes a grace period — instead of immediately marking resources as NON_COMPLIANT, the Lambda checks the resource creation time and only evaluates resources older than 15 minutes (allowing CI/CD pipelines time to complete tagging). (2) Implement Config rule suppression for known transient conditions using a DynamoDB table of suppression rules (resource type + tag pattern + duration). (3) Aggregate findings using Security Hub — create custom insights that filter out suppressed findings. (4) Create a tiered alerting system: immediate alerts for critical compliance failures (encryption, public access), daily digest for non-critical findings (missing optional tags). (5) Use EventBridge rules with input transformers to enrich findings with context before routing to SNS.

C) Switch from Config rules to manual audits to reduce noise

D) Increase the Config rule evaluation frequency to catch resources after tagging completes

**Correct Answer: B**
**Explanation:** The grace period addresses the root cause — resources are temporarily non-compliant during deployment but become compliant once the pipeline finishes. By evaluating only resources older than the CI/CD pipeline completion time, false positives from deployments are eliminated. The suppression table handles known transient conditions without disabling rules entirely. Tiered alerting ensures critical findings get immediate attention while non-critical ones are batched. Security Hub custom insights provide the filtered compliance view. Option A loses compliance visibility. Option C is the opposite of automation. Option D doesn't solve the underlying timing issue and may increase noise.

---

### Question 52
A company's Aurora PostgreSQL database performance has degraded over time. The database has grown to 5 TB with many tables having large amounts of dead tuples from frequent updates. The autovacuum process isn't keeping up. What should the architect recommend?

A) Restart the Aurora cluster to clear dead tuples

B) Implement a multi-pronged performance restoration: (1) Adjust Aurora PostgreSQL parameters: increase `autovacuum_max_workers` from default 3 to 5, decrease `autovacuum_vacuum_cost_delay` from default 20ms to 2ms, decrease `autovacuum_vacuum_threshold` and `autovacuum_vacuum_scale_factor` for large tables to trigger vacuum more frequently. (2) For the immediate bloat issue, run `pg_repack` extension on the most bloated tables during a maintenance window — it rebuilds tables without locking (unlike VACUUM FULL). (3) Set up a CloudWatch alarm on the `DeadTupleCount` custom metric (collected via a Lambda function querying `pg_stat_user_tables`). (4) For extremely large tables, consider partitioning by date — smaller partitions vacuum faster. (5) Review application update patterns — batched updates may be more efficient.

C) Migrate to DynamoDB to avoid vacuum issues

D) Increase the Aurora instance size for better vacuum performance

**Correct Answer: B**
**Explanation:** Aurora PostgreSQL inherits PostgreSQL's MVCC (Multi-Version Concurrency Control) behavior, which creates dead tuples during updates. Tuning autovacuum parameters ensures it keeps pace with the update workload — the defaults are conservative for high-update workloads. `pg_repack` reclaims space without exclusive table locks (unlike VACUUM FULL), making it suitable for production databases. Monitoring dead tuple counts provides proactive alerting before performance degrades. Partitioning reduces the per-table vacuum scope. Option A — restarting doesn't remove dead tuples; vacuum does. Option C — migrating a 5 TB relational database to DynamoDB is a massive effort and may not be appropriate for the data model. Option D — larger instance types have more CPU for vacuum but don't address the configuration issue.

---

### Question 53
A company runs a containerized microservices application on EKS. Some services are experiencing intermittent latency spikes during peak hours. The EKS cluster uses the default VPC CNI plugin, and pods are running at 80% memory utilization. What should the architect investigate and optimize?

A) Increase the EKS node instance sizes across the board

B) Implement systematic performance optimization: (1) Check if the VPC CNI is running out of secondary IPs — pod scheduling failures cause retries and latency. Enable VPC CNI prefix delegation to assign /28 prefixes instead of individual IPs, increasing pod density per node. (2) Configure Kubernetes Vertical Pod Autoscaler (VPA) to right-size pod resource requests/limits — 80% memory utilization suggests pods may be under-provisioned. (3) Implement Horizontal Pod Autoscaler (HPA) with custom CloudWatch metrics for services experiencing latency. (4) Deploy Container Insights for detailed pod-level CPU, memory, and network metrics. (5) Check for noisy neighbor effects — use Kubernetes resource quotas and limit ranges per namespace. (6) Evaluate if latency-sensitive pods should run in a dedicated node group with guaranteed capacity.

C) Move all services to Lambda to eliminate container overhead

D) Switch from EKS to ECS Fargate for simpler container management

**Correct Answer: B**
**Explanation:** Intermittent latency spikes during peak hours suggest resource contention. VPC CNI IP exhaustion causes pod scheduling delays — prefix delegation solves this by significantly increasing available IPs per node. At 80% memory utilization, pods are near their limits and may be OOMKilled during peaks, causing restarts and latency. VPA right-sizes pods; HPA scales horizontally based on actual demand. Container Insights provides the visibility needed for data-driven optimization. Noisy neighbor effects in shared nodes can be mitigated with resource quotas and dedicated node groups for critical services. Option A may help but is an expensive shotgun approach without understanding root cause. Option C requires a complete rewrite. Option D doesn't address the underlying resource issues.

---

### Question 54
A company is migrating 200 VMware VMs from their on-premises data center to AWS. The VMs include a mix of Windows and Linux with varying OS versions. They have a 6-month migration window and need minimal downtime per server. What migration strategy and tooling should the architect recommend?

A) Manually install OS and applications on new EC2 instances

B) Use AWS Application Migration Service (MGN): (1) Install the MGN replication agent on each source VM. The agent continuously replicates data to AWS using block-level replication (no downtime during replication). (2) MGN automatically creates staging instances in a dedicated staging VPC for data replication. (3) For each migration wave (batch of related VMs), launch test instances from the replicated data to validate in a test VPC. (4) After validation, perform the cutover: stop the source VM, wait for final replication sync (minutes), launch the production instance. Downtime = final sync + boot + validation (typically 30-60 minutes). (5) Organize the 200 VMs into migration waves based on application dependencies using AWS Migration Hub. (6) Use MGN's post-launch actions to automate post-migration tasks (agent installations, DNS updates).

C) Use VM Import/Export to convert all VMware VMs to AMIs

D) Use AWS Server Migration Service (SMS) to migrate all VMs

**Correct Answer: B**
**Explanation:** Application Migration Service (MGN) is the current recommended tool for lift-and-shift migrations, replacing the older SMS. Continuous block-level replication means the source VMs keep running during the replication phase — zero downtime until the actual cutover. The cutover window is minimal (minutes for final sync). Test instances allow validation before the production cutover, reducing risk. Migration Hub organizes the 200 VMs into waves based on application dependency mapping. Post-launch actions automate repetitive tasks. Option A is extremely slow for 200 servers. Option C — VM Import/Export requires VM downtime during export and doesn't support continuous replication. Option D — SMS has been superseded by MGN and has limitations on concurrent replications.

---

### Question 55
A company is migrating a legacy mainframe application to AWS. The application processes batch COBOL programs and uses VSAM files for data storage. They want to modernize to cloud-native services. What migration approach should the architect recommend?

A) Rewrite the entire mainframe application in Java from scratch

B) Implement a phased mainframe modernization: (1) Use AWS Mainframe Modernization service with the automated refactoring option (powered by Blu Age) to convert COBOL programs to Java microservices. The service parses COBOL, maps data structures, and generates equivalent Java code. (2) Convert VSAM files to Aurora PostgreSQL using the Mainframe Modernization data migration tools. (3) Deploy the converted Java services on ECS Fargate. (4) Replace batch scheduling (JCL/JES) with Step Functions + EventBridge for orchestration. (5) Implement a parallel-run phase where both mainframe and AWS process the same inputs, and Lambda functions compare outputs to validate correctness. (6) Gradually shift traffic using a strangler fig pattern — new transactions go to AWS, legacy transactions continue on mainframe until validated.

C) Use mainframe emulation software on large EC2 instances

D) Migrate the mainframe to a colocation facility and connect to AWS via Direct Connect

**Correct Answer: B**
**Explanation:** AWS Mainframe Modernization with automated refactoring converts COBOL to Java using the Blu Age transformation engine. This is more efficient than manual rewriting (Option A) while achieving true modernization. VSAM-to-Aurora conversion modernizes the data layer. ECS Fargate provides scalable, managed compute for the converted services. Step Functions replaces JCL batch orchestration with cloud-native workflow management. The parallel-run phase is critical for mainframe migrations — it validates that the converted code produces identical results before decommissioning the mainframe. The strangler fig pattern reduces risk by incrementally shifting workload. Option A is high-risk and extremely time-consuming. Option C doesn't modernize — it just changes the hosting location. Option D isn't a migration to AWS.

---

### Question 56
A company needs to migrate their on-premises Hadoop cluster (500 TB of data in HDFS, HBase, and Hive) to AWS. The cluster processes both batch and real-time workloads. How should the architect plan this migration?

A) Create an EMR cluster and manually copy all data using distcp

B) Implement a phased Hadoop migration: (1) Use AWS DataSync to transfer HDFS data to S3 (500 TB over Direct Connect at ~80% utilization takes approximately 6 days). (2) Convert Hive tables to use S3-backed storage with the AWS Glue Data Catalog as the Hive metastore replacement. (3) Migrate HBase to Amazon EMR HBase with S3 storage (HBase on S3) or to DynamoDB if the access pattern fits (key-value lookups). (4) Deploy EMR clusters for batch processing using the migrated S3 data. (5) For real-time workloads, evaluate migrating to Amazon MSK (Managed Streaming for Apache Kafka) + Kinesis Data Analytics or Apache Flink on EMR. (6) Use CloudWatch and Ganglia (EMR built-in) for monitoring parity.

C) Use AWS Snowball Edge devices to transfer all 500 TB

D) Keep the on-premises Hadoop cluster and connect it to AWS via Direct Connect

**Correct Answer: B**
**Explanation:** DataSync provides optimized data transfer for the 500 TB HDFS migration, handling the network transfer efficiently over Direct Connect. S3 as the storage layer decouples storage from compute — a major architectural advantage over HDFS. Glue Data Catalog replaces the Hive metastore with a managed, AWS-native service that integrates with Athena, Redshift Spectrum, and EMR. HBase migration depends on the access pattern — EMR HBase on S3 for wide-column needs, DynamoDB for simpler key-value. The phased approach (batch first, then real-time) reduces risk. Option A — distcp is inefficient for 500 TB and requires managing the transfer process. Option C — Snowball has higher latency (shipping time) than Direct Connect for this data volume. Option D doesn't migrate to AWS.

---

### Question 57
A company is modernizing a legacy monolithic e-commerce application into microservices on AWS. The monolith currently handles user management, product catalog, shopping cart, order processing, and payment. What migration strategy should the architect recommend?

A) Rewrite all components simultaneously as microservices

B) Apply the strangler fig pattern with phased decomposition: (1) Deploy the monolith on EC2 behind an ALB as the starting point. (2) Identify the first extraction candidate — Product Catalog is low-risk and read-heavy, making it ideal. Deploy as a Lambda + API Gateway + DynamoDB microservice. (3) Use the ALB with path-based routing to direct `/api/products/*` to the new microservice while all other paths continue to the monolith. (4) Next, extract Shopping Cart as an ElastiCache Redis-backed microservice. (5) Then User Management to Cognito + Lambda. (6) Order Processing to Step Functions + SQS + Lambda. (7) Payment to a separate ECS service with PCI-scoped isolation. (8) After each extraction, remove the corresponding code from the monolith. (9) Use AWS X-Ray for distributed tracing across the hybrid architecture.

C) Containerize the monolith on ECS and call the migration complete

D) Build all microservices first, then switch from monolith to microservices in one cutover

**Correct Answer: B**
**Explanation:** The strangler fig pattern incrementally replaces monolith functionality with microservices, reducing risk. Each extraction is independently deployable and testable. Starting with the lowest-risk, read-heavy service (Product Catalog) builds team confidence. The ALB acts as the routing layer, directing specific paths to microservices while the monolith handles remaining functionality. Each extraction reduces the monolith's scope until it can be decommissioned. AWS services match each domain: DynamoDB for catalog (fast key-value reads), Redis for cart (session-like data), Cognito for auth, Step Functions for order orchestration, isolated ECS for PCI-scoped payment. X-Ray provides observability across the hybrid system. Option A is high-risk big-bang. Option C doesn't modernize. Option D is also big-bang risk.

---

### Question 58
A company needs to migrate a petabyte-scale data warehouse from on-premises Teradata to AWS. The warehouse has complex stored procedures, user-defined functions, and thousands of ETL jobs. Queries must continue running during migration with minimal performance impact. What should the architect recommend?

A) Rewrite all queries and ETL jobs for Amazon Redshift from scratch

B) Implement a phased data warehouse migration: (1) Use AWS Schema Conversion Tool (SCT) to analyze the Teradata schema, stored procedures, and UDFs — SCT provides a migration assessment with estimated conversion percentages. (2) SCT converts Teradata SQL to Redshift-compatible SQL, flagging items requiring manual conversion. (3) Use SCT data extraction agents to extract data from Teradata and load into Redshift (handles the petabyte-scale transfer efficiently using multiple agents in parallel). (4) Set up continuous replication from Teradata to Redshift using SCT CDC agents during the migration period. (5) Convert ETL jobs using AWS Glue (replacing Teradata-specific ETL tools). (6) Run parallel query validation — execute the same queries on both Teradata and Redshift, compare results using a Lambda function. (7) Use Redshift's Teradata-to-Redshift specific optimizations (distribution keys, sort keys based on the SCT recommendations).

C) Migrate to Aurora PostgreSQL since it's PostgreSQL-compatible like Redshift

D) Use Amazon Athena to query the Teradata data directly via federated query

**Correct Answer: B**
**Explanation:** SCT is purpose-built for data warehouse migrations, with specific Teradata-to-Redshift conversion capabilities. The SCT data extraction agents handle petabyte-scale transfers by parallelizing the extraction process. CDC agents maintain synchronization during the migration period, allowing queries to continue on Teradata while the migration progresses. Parallel query validation ensures Redshift produces identical results before cutover. Redshift-specific optimizations (distribution keys, sort keys) ensure the migrated warehouse performs well — SCT recommends these based on the Teradata workload analysis. Option A is extremely expensive and time-consuming for thousands of ETL jobs. Option C — Aurora is OLTP-optimized, not designed for petabyte-scale analytical workloads. Option D — federated query has performance limitations for heavy analytical workloads.

---

### Question 59
A company has a legacy Windows .NET Framework 4.5 application running on Windows Server 2012 R2. The application uses MSMQ for message queuing and SQL Server for the database. Windows Server 2012 R2 is end-of-life. What modernization path should the architect recommend?

A) Lift and shift to EC2 instances running Windows Server 2012 R2 AMIs

B) Implement a modernization migration: (1) Assess the application with AWS Migration Hub Strategy Recommendations and AWS Microservice Extractor for .NET to determine the optimal strategy. (2) Use AWS App2Container to containerize the .NET Framework application — it creates Docker images from running Windows applications without code changes. (3) Deploy on Amazon ECS with Windows container support. (4) Replace MSMQ with Amazon MQ for ActiveMQ (supports MSMQ migration patterns) or SQS with application-level changes. (5) Migrate SQL Server to RDS for SQL Server or, if refactoring, to Aurora PostgreSQL using DMS with SCT. (6) Upgrade the .NET Framework version within the container to a supported version. (7) Plan a future migration from .NET Framework to .NET 6+ using AWS Porting Assistant for .NET.

C) Rewrite the entire application in .NET 6 on Linux

D) Keep using Windows Server 2012 R2 with Extended Security Updates

**Correct Answer: B**
**Explanation:** App2Container containerizes Windows applications without code changes — it discovers the running application, creates a Dockerfile, builds the container image, and generates ECS/EKS deployment artifacts. This addresses the immediate end-of-life concern by moving to a modern container platform. MSMQ replacement with Amazon MQ (ActiveMQ) minimizes code changes since both support similar messaging patterns. SQL Server to RDS provides managed database without refactoring. The Porting Assistant for .NET provides a future path to .NET 6+ (cross-platform). Option A doesn't address the EOL OS — 2012 R2 AMIs will lose support too. Option C is a full rewrite — high risk and time. Option D incurs extended support costs with no modernization.

---

### Question 60
A media company needs to migrate their on-premises video transcoding farm to AWS. They currently have 50 physical servers running FFmpeg for transcoding, processing 2,000 videos per day. Videos range from 1 GB to 50 GB. What should the architect recommend?

A) Deploy 50 EC2 instances to replicate the on-premises architecture

B) Migrate to a cloud-native transcoding architecture: (1) Upload source videos to S3 using S3 Transfer Acceleration for geographically distributed uploaders. (2) S3 PUT events trigger an EventBridge rule that starts a Step Functions workflow. (3) The workflow submits an AWS Elemental MediaConvert job for each video — MediaConvert is a fully managed transcoding service that handles FFmpeg-equivalent transcoding without infrastructure management. (4) MediaConvert automatically scales to handle the 2,000 daily videos with no capacity planning. (5) Output renditions (multiple bitrates/resolutions for adaptive streaming) are stored in S3. (6) For videos requiring custom FFmpeg filters not supported by MediaConvert, use AWS Batch with Spot instances running FFmpeg in Docker containers. (7) CloudFront distributes the transcoded content.

C) Deploy FFmpeg on Lambda functions for each video

D) Use Amazon Elastic Transcoder for all transcoding

**Correct Answer: B**
**Explanation:** MediaConvert replaces the 50-server transcoding farm with a fully managed service — no servers to patch, scale, or monitor. It handles the 2,000 daily video throughput automatically with per-job pricing (no idle capacity cost). Step Functions orchestrates the pipeline with error handling and retry logic. The hybrid approach (MediaConvert for standard transcoding, AWS Batch + Spot for custom FFmpeg) covers all use cases. S3 Transfer Acceleration handles uploads from content creators globally. Option A replicates the on-premises operational overhead. Option C — Lambda's 15-minute timeout and memory limits can't handle large video files (50 GB). Option D — Elastic Transcoder is an older service with fewer features than MediaConvert.

---

### Question 61
A company needs to migrate a legacy Oracle Forms application to AWS. The application has complex business logic embedded in Oracle Forms triggers and PL/SQL packages. Users access it through a Java applet. What modernization strategy should the architect recommend?

A) Run Oracle Forms on EC2 instances with no changes

B) Implement a replatforming approach: (1) Use Oracle Application Express (APEX) running on RDS Oracle or Amazon Aurora as an intermediate modernization step — APEX can import many Oracle Forms and convert them to web-based applications. (2) For forms that can't be converted, use Amazon AppStream 2.0 to stream the Oracle Forms client to users' browsers (replacing the Java applet). (3) Migrate the Oracle database to RDS Oracle initially (lift and shift the database), then plan a future migration to Aurora PostgreSQL using SCT/DMS. (4) For net-new functionality, build with API Gateway + Lambda + DynamoDB. (5) Implement a Cognito-based authentication layer to replace Oracle database authentication.

C) Rewrite all Oracle Forms in React.js

D) Use AWS Amplify to generate a new frontend automatically

**Correct Answer: B**
**Explanation:** APEX provides a lower-effort migration path for Oracle Forms than a complete rewrite — it runs on the Oracle database and can leverage existing PL/SQL business logic. AppStream 2.0 handles the most complex forms that can't be easily converted, providing browser-based access without the Java applet dependency. This phased approach reduces risk: APEX for most forms, AppStream for the hardest ones, and new development in cloud-native services. Future database migration to Aurora reduces Oracle licensing costs. Option A doesn't address the Java applet issue (browsers have dropped applet support). Option C is a complete rewrite — extremely expensive with the embedded business logic. Option D can't generate Oracle Forms equivalents automatically.

---

### Question 62
A company is performing a large-scale migration of 500 servers from three data centers to AWS. They need to minimize the migration timeline while managing interdependencies between applications. What should the architect use to orchestrate this migration?

A) Create a spreadsheet to track all 500 server migrations manually

B) Use AWS Migration Hub with a comprehensive orchestration approach: (1) Deploy AWS Application Discovery Service agents on all 500 servers to discover server specifications, running applications, network connections, and interdependencies. (2) Import discovery data into Migration Hub, which generates an application dependency map. (3) Group servers into migration waves based on dependency analysis — servers that communicate frequently should migrate together. (4) For each wave, use Application Migration Service (MGN) for the actual server replication. (5) Define migration wave templates in Migration Hub Orchestrator with pre/post migration steps (DNS updates, testing, monitoring). (6) Track migration status across all 500 servers in the Migration Hub dashboard. (7) Use Migration Hub Refactor Spaces to set up routing between migrated and unmigrated services during the transition.

C) Migrate all 500 servers simultaneously on a single weekend

D) Use CloudEndure Migration for all servers without dependency analysis

**Correct Answer: B**
**Explanation:** Application Discovery Service provides the data-driven dependency mapping essential for a 500-server migration. Without understanding application dependencies, migrating server A without server B could break the application. Migration Hub provides the centralized tracking dashboard. Migration Hub Orchestrator automates the migration workflow (pre-migration validation, migration execution, post-migration testing). Refactor Spaces manages the hybrid routing during the transition when some servers have migrated and others haven't. Wave-based execution manages risk — each wave is tested before proceeding to the next. Option A doesn't scale for 500 servers. Option C is extreme risk — any failure affects everything. Option D lacks the dependency analysis critical for avoiding outages.

---

### Question 63
A company runs 200 EC2 instances across their development, staging, and production environments. Development instances run only during business hours (10 hours/day, 5 days/week), staging instances run 12 hours/day on weekdays, and production runs 24/7. All instances are using On-Demand pricing. How should the architect optimize costs?

A) Purchase Reserved Instances for all 200 instances

B) Implement a tiered pricing strategy: (1) Production instances (24/7, steady-state): Purchase Compute Savings Plans for the predictable baseline — Savings Plans provide up to 72% discount and apply automatically to matching usage. (2) Staging instances (60 hours/week, predictable schedule): Use Instance Scheduler solution (Lambda + DynamoDB with CloudWatch Events) to automatically start/stop instances based on schedule. The reduced runtime drops effective cost. (3) Development instances (50 hours/week): Same scheduler-based approach with more aggressive scheduling. (4) For development, evaluate converting appropriate workloads to Spot instances (80-90% discount) for fault-tolerant work. (5) Use AWS Compute Optimizer to right-size all instances before purchasing Savings Plans.

C) Move all workloads to Lambda to avoid EC2 costs entirely

D) Use Spot Instances for all environments including production

**Correct Answer: B**
**Explanation:** The tiered approach matches pricing to each environment's usage pattern. Production's 24/7 usage justifies Savings Plans (up to 72% discount) — Compute Savings Plans are flexible across instance types and regions. Staging and development benefit from scheduling (stopping when not in use) — development runs 50/168 hours per week (70% waste eliminated). Right-sizing before purchasing Savings Plans ensures you're not over-committing to larger instances than needed. Spot instances for fault-tolerant development work add further savings. Option A — Reserved Instances for dev/staging waste money during off-hours. Option C — not all workloads are suitable for Lambda. Option D — Spot instances can be interrupted, which is unacceptable for production.

---

### Question 64
A company's S3 storage costs have grown to $500,000/month across 5 PB of data. Analysis shows: 30% of objects haven't been accessed in over a year, 20% haven't been accessed in 6 months, 10% are incomplete multipart uploads, and 5% are non-current versions of versioned objects. How should the architect optimize storage costs?

A) Delete all data older than 6 months

B) Implement comprehensive S3 cost optimization: (1) Enable S3 Storage Lens at the organization level for detailed storage analytics and cost optimization recommendations. (2) Create S3 Lifecycle policies: transition objects to S3 Intelligent-Tiering after 30 days (automatically moves objects between frequent and infrequent tiers based on access patterns). (3) Use S3 Lifecycle rules to abort incomplete multipart uploads after 7 days (10% of data = 500 TB of waste). (4) Add a lifecycle rule to expire non-current versions after 30 days (5% of data). (5) For objects confirmed as archival (no access needed for months), transition to S3 Glacier Instant Retrieval or Glacier Flexible Retrieval. (6) Enable S3 Requester Pays for buckets shared with external partners. (7) Estimated savings: 50-60% reduction in monthly costs.

C) Move all data to EBS volumes for lower storage costs

D) Compress all objects to reduce storage size

**Correct Answer: B**
**Explanation:** S3 Storage Lens provides data-driven optimization insights. Intelligent-Tiering eliminates the need to predict access patterns — objects automatically move between frequent and infrequent access tiers without retrieval charges. Aborting incomplete multipart uploads is pure waste elimination — 500 TB of incomplete uploads is immediately recoverable. Expiring old non-current versions reduces versioning overhead. Glacier tiers provide 68-95% cost savings for truly archival data. Combined, these optimizations can reduce the $500K/month bill by 50-60%. Option A would destroy potentially needed data. Option C — EBS is significantly more expensive per GB than S3. Option D helps but doesn't address tier optimization or waste.

---

### Question 65
A company runs a data processing pipeline that uses 50 r5.2xlarge EC2 instances 24/7 for an in-memory caching layer. The instances are 60% utilized on average, with peaks reaching 85%. How should the architect optimize costs while maintaining performance?

A) Maintain the current setup to ensure performance headroom

B) Right-size and optimize the caching layer: (1) Use Compute Optimizer to analyze the actual utilization patterns — 60% average utilization suggests over-provisioning. (2) Migrate from self-managed caching on EC2 to Amazon ElastiCache for Redis with cluster mode enabled. (3) Size ElastiCache nodes based on actual memory usage (not 60% utilized r5.2xlarge = ~38 GB used of 64 GB per node). (4) Use ElastiCache reserved nodes for the baseline capacity (1-year partial upfront for ~40% discount). (5) Enable ElastiCache auto-scaling for read replicas to handle peaks. (6) Implement ElastiCache data tiering (r6gd nodes) to automatically move less frequently accessed data to SSD, reducing the amount of expensive memory needed. Estimated savings: 40-50% from right-sizing + managed service efficiency + reserved pricing.

C) Switch to Spot Instances for the caching layer

D) Reduce the number of instances to 30 and accept the performance impact

**Correct Answer: B**
**Explanation:** Migrating to ElastiCache eliminates the operational overhead of self-managed caching (patching, monitoring, failover management). Right-sizing from 64 GB nodes (r5.2xlarge) to appropriately sized ElastiCache nodes based on actual 38 GB usage eliminates over-provisioning. ElastiCache data tiering on r6gd nodes automatically moves infrequently accessed keys from memory to SSD — reducing memory cost while maintaining acceptable latency for cold data. Reserved nodes for baseline capacity add another 40% discount. Auto-scaling read replicas handle peaks without over-provisioning. Option A wastes 40% of capacity. Option C — cache nodes on Spot instances risk data loss when reclaimed, which defeats the purpose of caching. Option D — arbitrary reduction without analysis risks degrading performance.

---

### Question 66
A company runs their application on m5.4xlarge instances in an Auto Scaling group. The application experiences predictable traffic patterns: high during business hours, low at night, and extremely high during monthly month-end processing. How should the architect optimize costs while handling all traffic patterns?

A) Size the Auto Scaling group for maximum month-end capacity at all times

B) Implement a multi-layered scaling and pricing strategy: (1) Compute Savings Plans for the baseline capacity that's always running (24/7 minimum instances) — estimated 10 instances. (2) Predictive scaling in the Auto Scaling group using AWS Auto Scaling predictive scaling — it uses ML to predict daily traffic patterns and pre-scales before demand increases. (3) Scheduled scaling actions for the known month-end peak — scale up the desired capacity on the 28th of each month, scale down on the 3rd. (4) Dynamic scaling policies for unexpected traffic bursts (target tracking on CPU utilization). (5) Use mixed instance types in the ASG (m5.4xlarge, m5a.4xlarge, m6i.4xlarge) for capacity availability. (6) Use Spot instances for the month-end burst capacity (up to 60-90% discount).

C) Use only On-Demand instances with dynamic scaling

D) Purchase Reserved Instances for the maximum month-end capacity

**Correct Answer: B**
**Explanation:** The multi-layered approach matches pricing to each capacity tier: Savings Plans for always-on baseline (highest discount), predictive scaling for daily patterns (pre-warms capacity efficiently), scheduled scaling for predictable monthly peaks (avoids scaling delay), dynamic scaling for unexpected bursts (safety net), and Spot for burst capacity (lowest cost for the temporary peak). Mixed instance types improve Spot availability and reduce single-instance-type dependency. Option A wastes enormous capacity 27 days per month. Option C — On-Demand pricing for all capacity is the most expensive option. Option D — Reserving for peak capacity wastes money during the 27 non-peak days per month.

---

### Question 67
A company operates a multi-account AWS Organization and wants to implement a chargeback model where each business unit pays for their own AWS usage. They need accurate cost allocation even for shared services (logging, security, networking). How should the architect implement this?

A) Split the total AWS bill equally among all business units

B) Implement a comprehensive chargeback system: (1) Enable AWS Cost Allocation Tags — define mandatory tags (BU, CostCenter, Project) enforced by SCPs. (2) Configure AWS Cost and Usage Report (CUR) v2 with all tag and resource-level columns, delivered to S3. (3) For shared services costs, implement a cost allocation model: Transit Gateway costs allocated proportionally based on data transfer per account; Security Hub/GuardDuty costs allocated per account count; shared VPC costs allocated based on resource count or data transfer. (4) Build a cost allocation pipeline: Glue ETL processes CUR data, applies shared service allocation logic, and writes to a cost allocation DynamoDB table. (5) QuickSight dashboards show per-BU cost breakdown with shared service allocation. (6) Automate monthly chargeback reports via Lambda + SES.

C) Use AWS Budgets to set spending limits per business unit

D) Create separate AWS Organizations for each business unit

**Correct Answer: B**
**Explanation:** CUR with resource-level granularity and cost allocation tags provides the raw data for accurate chargeback. Mandatory tag enforcement via SCPs ensures all resources are attributable. The critical challenge is shared service allocation — Transit Gateway, security tools, and shared networking benefit all BUs but are billed to specific accounts. The Glue ETL pipeline applies fair allocation models (proportional to usage). QuickSight provides business-friendly visualization. Monthly automated reports reduce finance team overhead. Option A is unfair — BUs with lower usage subsidize heavy users. Option C sets budgets but doesn't allocate actual costs. Option D loses shared service benefits and consolidated billing discounts.

---

### Question 68
A company's NAT Gateway costs have grown to $50,000/month across their multi-VPC architecture. They have 20 VPCs, each with its own NAT Gateway, primarily for instances to access AWS services like S3, DynamoDB, SQS, and CloudWatch. How should the architect reduce NAT Gateway costs?

A) Remove NAT Gateways and give instances public IPs

B) Implement VPC endpoint optimization: (1) Deploy Gateway VPC endpoints for S3 and DynamoDB in all VPCs (free, no per-GB data processing charge). (2) Deploy Interface VPC endpoints (PrivateLink) for frequently used services: SQS, CloudWatch, KMS, ECR, Secrets Manager. While interface endpoints have hourly costs, they're significantly cheaper than NAT Gateway data processing charges for high-volume services. (3) Analyze NAT Gateway flow logs to identify the remaining traffic patterns. (4) Consolidate VPCs where possible using a shared services VPC with Transit Gateway — share NAT Gateways across VPCs through Transit Gateway routing. (5) For remaining NAT Gateway traffic, ensure AZ-specific NAT Gateways to avoid cross-AZ data transfer charges.

C) Replace NAT Gateways with NAT instances on t3.micro

D) Move all workloads to public subnets to eliminate NAT need

**Correct Answer: B**
**Explanation:** The majority of NAT Gateway cost is typically data processing charges ($0.045/GB). Gateway VPC endpoints for S3 and DynamoDB are free and handle the highest-volume traffic patterns. Interface endpoints for other services have hourly costs but eliminate the $0.045/GB NAT data processing charge. If a VPC sends 10 TB/month to S3 through a NAT Gateway, that's $450/month in data processing — a Gateway endpoint eliminates this completely. Centralizing NAT Gateways via Transit Gateway reduces the number of NAT Gateways from 20 to a few shared ones. Analyzing flow logs ensures optimization is data-driven. Option A creates security risks. Option C — NAT instances lack the scalability, availability, and bandwidth of NAT Gateways. Option D — public subnets expose instances to the internet.

---

### Question 69
A company runs a machine learning training pipeline on p3.2xlarge GPU instances. Training jobs run for 4-8 hours daily and are fault-tolerant (checkpointing is implemented). The current monthly GPU compute cost is $80,000. How should the architect optimize costs?

A) Purchase Reserved Instances for the GPU instances

B) Optimize ML training costs: (1) Use Spot Instances for training jobs — p3.2xlarge Spot pricing is 60-70% lower than On-Demand. Implement checkpointing every 30 minutes to S3, and configure the Spot interruption handler to save a checkpoint upon receiving the 2-minute termination notice. (2) Use SageMaker Managed Spot Training which handles Spot interruptions, checkpointing, and job restart automatically. (3) Evaluate if the training workload can use p3.16xlarge instances for faster completion (potentially cheaper despite higher hourly rate due to reduced runtime). (4) Use SageMaker Training Compiler to optimize the training code for up to 50% faster training time. (5) Implement mixed precision training (FP16) to nearly double throughput on GPU instances. Estimated savings: 70-80% from Spot + training optimizations.

C) Move training to CPU instances which are cheaper per hour

D) Reduce the training dataset size to reduce compute time

**Correct Answer: B**
**Explanation:** Spot Instances provide 60-70% cost savings, and ML training is an ideal Spot workload because checkpointing makes it fault-tolerant. SageMaker Managed Spot Training abstracts the complexity of handling Spot interruptions — it automatically saves checkpoints, requests new capacity, and resumes training. Larger instance types (p3.16xlarge) may complete training faster, reducing total cost despite higher hourly rates. Training Compiler optimizes deep learning frameworks (TensorFlow, PyTorch) for AWS hardware. Mixed precision training (using FP16 instead of FP32) nearly doubles GPU throughput with minimal accuracy impact. Combined, these optimizations could reduce the $80K monthly cost to $15-20K. Option A — Reserved Instances for 4-8 hours/day usage is wasteful. Option C — CPU training is orders of magnitude slower for deep learning. Option D — reducing data affects model quality.

---

### Question 70
A company pays $200,000/month for data transfer costs across their multi-Region architecture. Traffic flows between us-east-1 and eu-west-1, with significant cross-AZ traffic within each region. How should the architect reduce data transfer costs?

A) Consolidate everything into a single region to eliminate inter-Region transfer

B) Implement a data transfer cost optimization strategy: (1) Audit data transfer using VPC Flow Logs and CUR to identify the top data transfer cost sources. (2) Enable S3 Transfer Acceleration only when it provides faster transfers (it adds cost, so disable for same-region transfers). (3) For frequently accessed cross-Region data, implement regional caches — ElastiCache or S3 replicas in each region to avoid repeated cross-Region fetches. (4) Minimize cross-AZ traffic: ensure ECS/EKS services communicate with AZ-local endpoints using AZ-affinity routing. (5) Compress data before cross-Region transfer (gzip/zstd can reduce payload 70-80%). (6) Use VPC endpoints to keep AWS service traffic within the AWS network (free for Gateway endpoints, reduced for Interface endpoints vs NAT Gateway). (7) Evaluate CloudFront for content served to end users — CloudFront data transfer out is cheaper than direct EC2/ALB data transfer out.

C) Switch to smaller instance types to reduce network throughput

D) Use Direct Connect for inter-Region traffic

**Correct Answer: B**
**Explanation:** Data transfer optimization requires understanding the traffic patterns first (flow logs + CUR analysis). Regional caching eliminates redundant cross-Region transfers — if eu-west-1 repeatedly fetches the same data from us-east-1, a regional cache or S3 replica eliminates the transfer. AZ-affinity routing reduces cross-AZ charges ($0.01/GB in each direction). Compression reduces the bytes transferred by 70-80%, directly reducing costs. CloudFront's pricing for data out to internet is lower than EC2/ALB/S3 direct, plus it caches at edge locations. VPC Gateway endpoints eliminate NAT Gateway data processing charges for S3/DynamoDB. Option A sacrifices availability and latency. Option C doesn't reduce data volume. Option D — Direct Connect doesn't reduce inter-Region data transfer pricing.

---

### Question 71
A company runs a SaaS application serving 1,000 customers. Each customer has a dedicated RDS PostgreSQL instance (db.r5.large). Many instances are underutilized — average CPU is 15% and average connections are 20. Monthly RDS cost is $1.2M. How should the architect optimize?

A) Continue with dedicated instances to maintain isolation

B) Implement multi-tenant database consolidation: (1) Evaluate consolidation to Aurora PostgreSQL clusters with tenant isolation via schema-per-tenant model. Each Aurora cluster hosts 50-100 tenants in separate schemas. (2) Use RDS Proxy to pool database connections — reducing the connection overhead from 1,000 separate connection pools to a few Aurora clusters. (3) For the largest/most demanding tenants, keep dedicated Aurora instances but right-size them. (4) Use Aurora Serverless v2 for tenants with variable workloads — it auto-scales between 0.5-128 ACUs, eliminating idle capacity. (5) Purchase Aurora Reserved Instances for the baseline clusters. (6) Implement Row-Level Security (RLS) in PostgreSQL for an additional isolation layer. Estimated savings: 70-80% (from ~$1.2M to ~$250K-350K).

C) Move all databases to DynamoDB

D) Downgrade all instances to db.t3.micro

**Correct Answer: B**
**Explanation:** At 15% average CPU, 1,000 db.r5.large instances represent massive over-provisioning. Schema-per-tenant consolidation on Aurora clusters maintains logical isolation while dramatically reducing instance count. RDS Proxy pools connections efficiently across tenants. Aurora Serverless v2 is ideal for variable-workload tenants — it scales to near-zero during inactive periods and up during bursts. PostgreSQL RLS adds query-level isolation as defense in depth. The tiered approach (dedicated for large tenants, shared for small tenants, serverless for variable) optimizes cost across the customer base. Option A wastes 85% of compute capacity. Option C requires a complete application rewrite. Option D — db.t3.micro has burstable performance that may cause issues for active tenants.

---

### Question 72
A company uses CloudFront to distribute their web application globally. Their current configuration uses a single origin in us-east-1 with default TTL of 24 hours. Some pages are dynamic (user-specific), and the company pays $100,000/month in CloudFront data transfer. How should the architect optimize CloudFront costs and performance?

A) Increase TTL to 7 days to reduce origin fetches

B) Implement a CloudFront optimization strategy: (1) Configure Cache Policies with different TTLs: static assets (CSS, JS, images) with 30-day TTL using content-hash cache keys, API responses with 0 TTL (pass-through), semi-dynamic content (product listings) with 5-minute TTL. (2) Enable CloudFront Origin Shield as a centralized caching layer between edge locations and the origin — reduces origin load and data transfer. (3) Use CloudFront Functions (or Lambda@Edge) for dynamic content personalization at the edge, avoiding origin round-trips. (4) Evaluate the CloudFront pricing class — if 80% of users are in North America and Europe, use PriceClass_100 instead of PriceClass_All (costs less by excluding expensive edge locations). (5) Enable Brotli/gzip compression for text-based content. (6) Use CloudFront real-time logs to analyze cache hit ratios and optimize cache keys.

C) Replace CloudFront with direct ALB access

D) Serve all content as static files from S3

**Correct Answer: B**
**Explanation:** Differentiated cache policies maximize cache hit ratio for each content type — static assets benefit from long TTLs while dynamic content bypasses caching. Origin Shield reduces origin fetches by adding a centralized cache between edge locations and the origin — all edge locations go through Origin Shield instead of independently fetching from the origin. Price class optimization removes expensive edge locations in regions with few users. Edge functions handle simple personalization without origin round-trips. Compression reduces data transfer (and costs) by 70-80% for text content. Real-time logs enable data-driven cache optimization. Option A would serve stale dynamic content. Option C eliminates edge caching benefits entirely. Option D isn't possible for a dynamic application.

---

### Question 73
A company runs Lambda functions that process events from SQS. Each function invocation makes API calls to a third-party REST service. The Lambda functions run for an average of 30 seconds per invocation with 1024 MB memory allocation. Monthly Lambda cost is $50,000 across 10 million invocations. How should the architect optimize costs?

A) Reduce the Lambda memory to 128 MB to lower per-invocation cost

B) Implement Lambda cost optimization: (1) Use Lambda Power Tuning to find the optimal memory/CPU allocation — Lambda CPU scales with memory, so higher memory may complete faster and cost less despite the higher per-ms rate. (2) Batch SQS messages — configure the SQS trigger with a batch size of 10 and batch window of 30 seconds, processing multiple messages per invocation to amortize invocation costs and API connection overhead. (3) Implement connection pooling to the third-party API — reuse HTTP connections across invocations (Lambda execution environments persist between invocations). (4) Use Lambda Provisioned Concurrency for predictable workloads to eliminate cold start overhead. (5) If processing is truly long-running (30 seconds), evaluate migrating to ECS Fargate Spot for lower per-second cost at higher durations. (6) Use Graviton2 (ARM) Lambda functions for 20% lower cost with potentially better performance.

C) Move all processing to EC2 Reserved Instances

D) Switch from SQS to SNS to reduce message delivery overhead

**Correct Answer: B**
**Explanation:** Lambda Power Tuning often reveals that higher memory (more CPU) completes faster at lower total cost — a 2x memory increase might halve execution time, resulting in the same cost but better throughput. Batching SQS messages dramatically reduces invocation count — processing 10 messages per invocation reduces 10M invocations to 1M, saving on invocation charges. Connection pooling reduces the 30-second average by reusing HTTP connections. Graviton2 provides 20% better price-performance. For 30-second average execution times, Fargate Spot might be more cost-effective per compute-second. Option A — reducing memory reduces CPU, likely increasing execution time and potentially increasing cost. Option C loses the serverless scaling benefits. Option D — SNS doesn't provide the same guaranteed delivery and retry semantics.

---

### Question 74
A company uses Amazon Redshift for their data warehouse. The cluster has 20 ra3.xlplus nodes running 24/7, costing $120,000/month. Query analysis shows: peak usage is 8 AM-6 PM weekdays, moderate usage 6 PM-midnight, and minimal usage midnight-8 AM and weekends. How should the architect optimize costs?

A) Scale down to 10 nodes and accept slower query performance

B) Implement Redshift cost optimization: (1) Enable Redshift Serverless for variable workloads — Redshift Serverless automatically scales capacity based on query demand, eliminating idle capacity costs during off-hours. Migrate from provisioned to serverless. (2) If remaining on provisioned: implement Redshift pause/resume — pause the cluster during minimal usage periods (midnight-8 AM weekdays, weekends) saving ~50% of compute costs. (3) Use Reserved Nodes for the baseline that runs 24/7 (if staying provisioned). (4) Enable Redshift Concurrency Scaling for burst capacity during peak hours (free for up to 1 hour/day). (5) Review table design: implement proper distribution keys, sort keys, and compression encodings to reduce the compute needed. (6) Use Redshift Spectrum for infrequently queried historical data (stored in S3 instead of Redshift storage).

C) Migrate to Athena for all queries

D) Move to a smaller node type

**Correct Answer: B**
**Explanation:** Redshift Serverless is ideal for variable workloads — it scales to zero during quiet periods and up during peaks, paying only for actual query processing. For provisioned clusters, pause/resume eliminates compute costs during predictable quiet periods (midnight-8 AM, weekends = ~50% of hours). Concurrency Scaling provides free burst capacity for the first hour daily, handling peak concurrent queries. Redshift Spectrum moves cold data to cheaper S3 storage while keeping it queryable. Table design optimization reduces per-query compute requirements. Option A reduces capacity during peak hours, impacting users. Option C — Athena is slower for complex data warehouse queries and BI workloads. Option D — smaller nodes reduce performance without addressing the utilization pattern.

---

### Question 75
A company's AWS bill shows $300,000/month in unused Elastic IP addresses, idle Load Balancers, unattached EBS volumes, and obsolete snapshots across their 100-account organization. How should the architect implement systematic waste elimination?

A) Manually check each account monthly for unused resources

B) Implement automated waste detection and remediation: (1) Enable AWS Cost Anomaly Detection with alerts for unusual spending patterns. (2) Deploy AWS Config rules across the organization to detect: unattached EBS volumes (ec2-volume-in-use-check), unused Elastic IPs, idle Load Balancers (no healthy targets), and EBS snapshots older than 90 days without tags indicating retention. (3) Configure automatic remediation: Lambda function triggered by Config non-compliance that: tags unattached EBS volumes with a deletion-date 14 days in the future, sends a notification to the resource owner. (4) A weekly Lambda function deletes resources past their deletion-date if no exemption tag was added. (5) For snapshots, implement a lifecycle policy — DLM (Data Lifecycle Manager) for automated snapshot management with age-based deletion. (6) Create a QuickSight waste dashboard pulling from Config compliance data and CUR. Estimated savings: $300K/month recovered.

C) Use Trusted Advisor to generate a report and email it to all teams

D) Implement AWS Budgets actions to terminate all unused resources automatically

**Correct Answer: B**
**Explanation:** Systematic waste elimination requires detection, notification, grace period, and automated cleanup. Config organizational rules provide continuous detection across all 100 accounts. The 14-day grace period with owner notification prevents accidental deletion of resources that appear unused but are needed (e.g., EBS volumes detached during maintenance). The exemption tag mechanism allows teams to justify keeping resources. DLM automates snapshot lifecycle management. Cost Anomaly Detection catches new waste patterns early. The QuickSight dashboard provides visibility for leadership. Option A doesn't scale to 100 accounts. Option C provides information but no automation — teams often ignore reports. Option D — Budgets actions are too coarse for specific resource-type cleanup.

---
