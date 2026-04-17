# AWS Certified Solutions Architect - Professional (SAP-C02) Practice Test 3

**Focus Areas:** Migration (DMS, MGN, Snow Family), DR Strategies, Serverless, Cost Optimization
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

A company is establishing a multi-account architecture for a new business unit. The business unit requires 15 AWS accounts organized by function: production, development, staging, shared services, logging, and security. They want automated account provisioning with baseline configurations including VPC, IAM roles, and Config rules. The solution must integrate with the existing AWS Organizations structure.

Which approach provides the MOST automated and consistent account provisioning?

A. Manually create accounts in Organizations and configure each account individually using CloudFormation templates.

B. Use AWS Control Tower Account Factory with customized account blueprints. Define baseline configurations (VPC, IAM, Config) using Account Factory Customization (AFC) with CloudFormation templates stored in a Service Catalog portfolio.

C. Write a custom Lambda function triggered by Organizations CreateAccount API to bootstrap each account.

D. Use Terraform to provision accounts and resources across the organization.

**Correct Answer: B**

**Explanation:** Control Tower Account Factory provides standardized, automated account creation with customizable blueprints. AFC allows defining baseline resources (VPCs, IAM roles, Config rules) as CloudFormation templates that automatically deploy during account creation. This integrates natively with Organizations and Control Tower guardrails. Option A is manual and error-prone. Option C requires building and maintaining custom automation. Option D works but doesn't integrate natively with Control Tower guardrails.

---

### Question 2

A large enterprise has separate AWS accounts for each application team (30 accounts). Each team manages their own VPC and networking. The network team wants to centralize the management of all DNS records, VPC CIDR allocations, and IP address tracking to prevent CIDR overlaps and ensure consistent DNS resolution across all VPCs.

Which combination provides centralized network management? (Choose TWO.)

A. Use Amazon VPC IP Address Manager (IPAM) to allocate and track CIDR blocks across all accounts in the organization. Define IPAM pools for each environment (production, development) to enforce CIDR allocation policies.

B. Use Route 53 Resolver with centralized forwarding rules shared via RAM to all accounts. Create private hosted zones in a central DNS account and associate them with VPCs across accounts.

C. Assign each team a /8 CIDR block to avoid any overlap.

D. Deploy a custom CMDB on EC2 to track IP allocations across accounts.

E. Use separate Route 53 public hosted zones in each account for DNS management.

**Correct Answer: A, B**

**Explanation:** VPC IPAM (A) provides organization-wide CIDR allocation, tracking, and overlap prevention from a central account. It enforces allocation policies through IPAM pools. Centralized Route 53 Resolver (B) with shared forwarding rules and cross-account private hosted zone associations provides consistent DNS resolution. Option C wastes IP space and doesn't prevent intra-block overlaps. Option D is custom-built and doesn't enforce policies. Option E fragments DNS management across accounts.

---

### Question 3

A financial institution has a regulatory requirement that all AWS API activity must be logged, encrypted, and stored immutably for 10 years across all 50 accounts in the organization. The logs must be accessible for forensic analysis within 4 hours but stored cost-effectively.

Which architecture meets these requirements?

A. Enable CloudTrail organization trail in the management account. Store logs in a centralized S3 bucket in a dedicated logging account with S3 Object Lock (Compliance mode, 10-year retention). Use S3 Lifecycle to transition logs older than 90 days to S3 Glacier Instant Retrieval.

B. Enable CloudTrail in each account individually. Store logs locally in each account's S3 bucket.

C. Enable CloudTrail organization trail and store logs in CloudWatch Logs with a 10-year retention period.

D. Enable CloudTrail organization trail and store logs in S3 with a 10-year retention lifecycle policy that prevents deletion.

**Correct Answer: A**

**Explanation:** Organization trails automatically capture API activity from all 50 accounts. Object Lock in Compliance mode provides true immutability (no one can delete, including root). Glacier Instant Retrieval offers millisecond access meeting the 4-hour forensic analysis requirement while being 68% cheaper than S3 Standard for long-term storage. Option B doesn't centralize and requires per-account management. Option C (CloudWatch Logs) is prohibitively expensive at scale for 10 years. Option D uses lifecycle rules which don't provide immutability—someone could modify the policy.

---

### Question 4

A company uses AWS Organizations with 40 accounts. The security team needs to implement a solution where any EC2 instance launched in any account automatically gets an IAM instance profile attached with a baseline set of permissions (CloudWatch agent, SSM agent connectivity). The solution must work for instances launched by any method (console, CLI, CloudFormation, Terraform).

Which approach ensures all EC2 instances get the baseline instance profile?

A. Create a mandatory default IAM instance profile in each account using CloudFormation StackSets. Use an SCP that denies ec2:RunInstances unless an instance profile is specified in the request.

B. Use AWS Config rules to detect instances without instance profiles and auto-remediate by attaching one.

C. Create a Lambda function triggered by CloudTrail RunInstances events that attaches the instance profile to newly launched instances.

D. Document the requirement and train all teams to attach the instance profile manually.

**Correct Answer: A**

**Explanation:** StackSets deploy the baseline IAM instance profile consistently across all accounts. The SCP prevents launching instances without specifying an instance profile, forcing users to include one (either the baseline or a custom one that includes the baseline). This is a preventive control that works regardless of the launch method. Option B is reactive—instances run without a profile briefly. Option C is also reactive with a delay. Option D relies on human compliance.

---

### Question 5

A company has a hybrid architecture with an on-premises Active Directory and 20 AWS accounts. They need to implement a solution where on-premises users can access AWS resources using their AD credentials. Different AD groups should map to different AWS roles with varying permissions across accounts. The solution must support MFA and provide centralized access management.

Which architecture provides the MOST streamlined identity federation?

A. Deploy ADFS on-premises and configure SAML federation with each of the 20 AWS accounts individually.

B. Configure AWS IAM Identity Center with AD Connector pointing to the on-premises AD. Create permission sets that map to AD groups. Assign permission sets to accounts. Enable MFA in IAM Identity Center.

C. Deploy AWS Managed Microsoft AD and establish a forest trust with on-premises AD. Create IAM roles in each account with trust policies for the managed AD.

D. Synchronize AD users to IAM users in each account using a custom directory synchronization tool.

**Correct Answer: B**

**Explanation:** IAM Identity Center with AD Connector provides centralized federation management for all 20 accounts from a single pane. Permission sets map to AD groups, and assignments automatically provision roles across accounts. Built-in MFA support adds security without additional infrastructure. Option A requires configuring SAML in each of 20 accounts—high overhead. Option C adds Managed AD cost and complexity. Option D creates IAM users which is an anti-pattern for federated access.

---

### Question 6

A government agency requires that all cross-account access follows a pattern where no account can directly trust another account's IAM principals. Instead, all cross-account access must flow through a centralized identity broker account. The broker account validates the request, checks authorization, and assumes a role in the target account on behalf of the requester.

Which pattern implements this centralized identity brokering?

A. Configure direct cross-account IAM role trust policies between all accounts.

B. Deploy a custom identity broker application in a dedicated account. When a user needs cross-account access, the broker authenticates the user, checks authorization policies, calls sts:AssumeRole in the target account using a trust relationship between the broker account and target accounts, and returns temporary credentials. Target accounts only trust the broker account.

C. Use AWS IAM Identity Center as the identity broker with SSO to all accounts.

D. Use AWS Resource Access Manager to share all resources across accounts.

**Correct Answer: B**

**Explanation:** A custom identity broker centralizes all cross-account access through a single control point. Target accounts only trust the broker account, preventing any direct cross-account trust. The broker validates authorization before assuming roles, providing centralized audit and control. Option A allows direct cross-account trust which violates the requirement. Option C (Identity Center) provides SSO but users directly assume roles in target accounts, not through a broker intermediary. Option D shares resources, not access roles.

---

### Question 7

A multinational corporation has AWS accounts in multiple Regions serving different countries. Each country has specific data residency requirements—customer data must stay within the country's borders. The company needs to enforce that resources in specific accounts can only be created in approved Regions, and cross-Region data transfers are blocked.

Which combination of controls enforces data residency? (Choose TWO.)

A. Use SCPs with aws:RequestedRegion conditions to restrict each country's accounts to their respective approved Regions.

B. Use VPC endpoint policies to prevent data transfer to other Regions.

C. Use S3 bucket policies with aws:SourceVpce conditions to prevent cross-Region access.

D. Use CloudTrail with Lambda to monitor and alert on resources created in unapproved Regions.

E. Implement S3 Block Public Access and disable cross-Region replication to prevent data from leaving the Region.

**Correct Answer: A, E**

**Explanation:** SCPs with Region restrictions (A) prevent any resource creation outside approved Regions at the API level—the strongest preventive control. S3 Block Public Access combined with disabled cross-Region replication (E) prevents data from being copied or accessed from outside the Region. Together, these enforce data residency for compute and storage. Option B doesn't prevent cross-Region transfers initiated from within the VPC. Option C limits to VPC endpoints but doesn't enforce Region restrictions. Option D is detective, not preventive.

---

### Question 8

A company operates in a regulated industry and must demonstrate that their AWS infrastructure meets specific compliance frameworks (SOC 2, HIPAA, PCI DSS). They have 30 accounts and need to continuously monitor compliance posture across all accounts with a single dashboard that maps controls to compliance frameworks.

Which solution provides the MOST comprehensive compliance monitoring?

A. Use AWS Audit Manager to set up automated assessments against SOC 2, HIPAA, and PCI DSS frameworks across all accounts. Audit Manager automatically collects evidence from Config, CloudTrail, and Security Hub.

B. Use AWS Security Hub with compliance standards enabled (CIS, PCI DSS, AWS Foundational Best Practices) across all accounts using a delegated administrator.

C. Create custom AWS Config rules for each compliance requirement and aggregate results in a central account.

D. Hire external auditors to manually review the environment quarterly.

**Correct Answer: A**

**Explanation:** AWS Audit Manager maps AWS controls to specific compliance frameworks (SOC 2, HIPAA, PCI DSS), automatically collects evidence from multiple AWS services, and provides assessment dashboards—purpose-built for compliance monitoring and audit preparation. Option B (Security Hub) provides security posture but doesn't map controls to compliance frameworks like SOC 2 or generate audit evidence packages. Option C requires building custom rules for each framework. Option D is periodic, not continuous.

---

### Question 9

A company has an Organization with 100 accounts. They want to enable Amazon GuardDuty across all accounts for threat detection. The security team in a dedicated security account should be able to view and manage all findings. New accounts should automatically have GuardDuty enabled.

What is the MOST operationally efficient way to deploy GuardDuty organization-wide?

A. Manually enable GuardDuty in each account and send findings to a central S3 bucket.

B. Designate the security account as the GuardDuty delegated administrator. Enable GuardDuty for the organization with auto-enable for new member accounts. All findings aggregate to the delegated administrator.

C. Use CloudFormation StackSets to enable GuardDuty in all accounts.

D. Create a Lambda function that runs daily to check if GuardDuty is enabled in all accounts and enables it if not.

**Correct Answer: B**

**Explanation:** GuardDuty's organization integration with a delegated administrator automatically enables GuardDuty in all current and future member accounts. The delegated admin sees all findings in a single console. Auto-enable ensures new accounts are immediately protected. Option A requires manual per-account configuration. Option C uses StackSets which works but doesn't auto-enable for new accounts without additional triggers. Option D is a custom polling solution with gaps between checks.

---

### Question 10

A company has a shared services account that hosts common tools (CI/CD pipelines, artifact repositories, monitoring). 25 application accounts need network connectivity to the shared services. The company also needs to ensure that shared services resources can be accessed by all accounts but application accounts remain isolated from each other.

Which networking design achieves this with the LEAST operational complexity?

A. Create VPC peering connections between each application account VPC and the shared services VPC (25 peering connections). VPC peering is non-transitive, naturally isolating application accounts.

B. Deploy AWS Transit Gateway. Attach all VPCs. Use two route tables: one for shared services (routes to all application VPCs) and one for application VPCs (route only to shared services VPC). Use RAM to share the transit gateway.

C. Deploy a VPN mesh between all VPCs for full connectivity.

D. Use AWS PrivateLink to expose each shared service as an endpoint service to all application accounts.

**Correct Answer: B**

**Explanation:** Transit Gateway with separate route tables provides scalable hub-and-spoke topology. The application route table only routes to shared services (not to other applications), maintaining isolation. RAM shares the transit gateway across accounts. Option A works for isolation but 25 peering connections are operationally complex and each new account requires a new connection. Option C provides full mesh which violates isolation. Option D works for specific services but is complex if there are many shared services.

---

### Question 11

A company has developed an SCP that denies the ability to leave the Organization. After applying the SCP to all OUs, the security team realizes the management account can still potentially leave the organization. They need to ensure no account—including the management account—can be removed from the organization.

What should they understand about SCP limitations?

A. The SCP needs to be applied directly to the management account.

B. SCPs do not apply to the management account. To protect against the management account leaving or being dissolved, implement compensating controls such as requiring MFA on the root user, enabling CloudTrail alerts for organization management API calls, and restricting access to the management account to a small group of administrators.

C. SCPs apply to all accounts including the management account.

D. Enable Organization-level MFA Delete to prevent any account from leaving.

**Correct Answer: B**

**Explanation:** SCPs explicitly do not apply to the management account—this is a fundamental limitation of Organizations. The management account always has full permissions. Compensating controls (MFA on root, CloudTrail alerts, restricted access) mitigate the risk. Option A is incorrect because SCPs cannot be applied to the management account. Option C is factually wrong. Option D doesn't exist as a feature.

---

### Question 12

A company is implementing AWS Config across their organization. They want Config to evaluate compliance in all 60 accounts using consistent rules but allow individual accounts to add their own custom rules. The central compliance team needs an aggregated view of compliance across all accounts.

Which setup provides centralized management with account-level flexibility?

A. Deploy Config rules using CloudFormation StackSets. Each team adds custom rules locally. Use a Config aggregator in the management account for cross-account visibility.

B. Enable organization-wide Config rules from a delegated administrator account for mandatory rules. Allow individual accounts to create additional local rules. Set up a multi-account, multi-Region Config aggregator in the delegated administrator account.

C. Deploy Config only in the management account and use cross-account IAM roles to evaluate resources in member accounts.

D. Have each account manage their own Config rules independently with no central oversight.

**Correct Answer: B**

**Explanation:** Organization-wide Config from a delegated administrator ensures mandatory rules are consistently deployed across all 60 accounts. Accounts retain the ability to add local custom rules for team-specific compliance needs. The multi-account aggregator provides a single-pane view of compliance. Option A (StackSets) works but is less integrated with Config's organization features. Option C doesn't scale—Config evaluates locally per account. Option D lacks central governance.

---

### Question 13

A company needs to ensure that all S3 buckets across 40 accounts block public access. The policy must be preventive (not just detective) and should apply to both existing and new buckets. Even administrators within member accounts should not be able to enable public access.

Which control provides the STRONGEST preventive enforcement?

A. Enable S3 Block Public Access at the account level in each account and use an SCP to deny the s3:PutBucketPublicAccessBlock action (preventing anyone from disabling the block) and deny s3:PutBucketPolicy with conditions that would make buckets public.

B. Use AWS Config rules to detect public buckets and auto-remediate.

C. Create a bucket policy in each bucket that denies public access.

D. Enable S3 Block Public Access at the account level in each account.

**Correct Answer: A**

**Explanation:** Enabling account-level Block Public Access and then using an SCP to deny modifying that setting (s3:PutBucketPublicAccessBlock) creates an unbreakable preventive control. No IAM principal in any member account can disable the block or create public bucket policies. Option B is detective/reactive. Option C can be overridden by anyone with PutBucketPolicy permission. Option D can be disabled by account administrators without the SCP protection.

---

### Question 14

A company has a centralized networking account that owns all transit gateways and Direct Connect connections. Application accounts need to attach their VPCs to the transit gateway. The networking team wants to approve each VPC attachment before it becomes active, preventing unauthorized VPCs from gaining network connectivity.

Which feature enables attachment approval workflows?

A. Share the transit gateway via RAM with auto-accept disabled. When an application account creates a VPC attachment, it enters a "pendingAcceptance" state. The networking team manually reviews and accepts or rejects the attachment in the networking account.

B. Use IAM policies to prevent application accounts from creating transit gateway attachments.

C. Create an SNS notification when attachments are created and manually delete unauthorized ones.

D. Use security groups on the transit gateway to control which VPCs can attach.

**Correct Answer: A**

**Explanation:** RAM sharing with auto-accept disabled requires explicit approval from the networking account for each VPC attachment. The attachment stays in "pendingAcceptance" until approved. This provides an approval workflow without preventing accounts from initiating the request. Option B prevents accounts from even requesting—too restrictive. Option C is reactive with a window of unauthorized connectivity. Option D is incorrect—transit gateways don't have security groups.

---

### Question 15

A media company has an AWS Organization with separate accounts for content production and content delivery. The production account generates video files in S3 that the delivery account's CloudFront distribution needs to serve. The production team updates content frequently, and the delivery team needs immediate access to new content.

Which S3 cross-account access pattern is MOST efficient?

A. Copy files from the production account S3 bucket to the delivery account S3 bucket using S3 Cross-Region Replication.

B. Grant the delivery account's CloudFront Origin Access Control (OAC) access to the production account's S3 bucket through a bucket policy. CloudFront in the delivery account directly serves content from the production bucket.

C. Generate pre-signed URLs in the production account for each object and share them with the delivery account.

D. Make the production S3 bucket public so CloudFront can access it.

**Correct Answer: B**

**Explanation:** CloudFront OAC supports cross-account S3 bucket access. The production bucket policy grants access to the delivery account's CloudFront distribution via OAC. This eliminates data duplication and provides immediate access to new content. Option A creates data copies, doubling storage costs and introducing replication lag. Option C requires pre-signing each URL—impractical for frequent content updates. Option D makes the bucket public, creating a security vulnerability.

---

### Question 16

A company needs to enforce that all EC2 instances across 20 accounts must use specific approved AMIs maintained by a central platform team. The platform team publishes golden AMIs monthly with security patches and compliance configurations. No team should be able to launch instances from non-approved AMIs.

Which approach provides the MOST reliable enforcement?

A. Share approved AMIs using RAM from the platform account. Create an SCP that denies ec2:RunInstances unless the image ID matches the list of approved AMIs using the ec2:ImageId condition key.

B. Document approved AMIs in a wiki and ask teams to use only those AMIs.

C. Use AWS Config rules to detect instances running non-approved AMIs and terminate them.

D. Use AWS Service Catalog to offer pre-configured products that use approved AMIs only.

**Correct Answer: A**

**Explanation:** RAM shares AMIs across accounts, and the SCP with ec2:ImageId condition keys prevents launching from non-approved AMIs at the API level. This is a preventive control that can't be bypassed. Option B has no enforcement mechanism. Option C is reactive—non-compliant instances run before detection. Option D works for Service Catalog users but doesn't prevent direct CLI/API launches.

---

### Question 17

An organization has acquired another company with its own AWS accounts. They need to migrate the acquired company's 10 AWS accounts into the existing Organization. The acquired accounts have existing resources that must be preserved, and the migration must not cause downtime.

What is the correct procedure to bring acquired accounts into the organization?

A. Create new accounts in the organization and migrate resources from the acquired accounts using AWS Migration Hub.

B. Have the acquired accounts leave their current organization (if any). Send an invitation from the management account to each acquired account. The acquired account accepts the invitation, joining the organization. Apply SCPs and guardrails progressively.

C. Use AWS Organizations MergeAccounts API to combine organizations.

D. Delete the acquired accounts and recreate them in the existing organization.

**Correct Answer: B**

**Explanation:** Accounts can be invited to join an organization. The process is: acquired accounts leave their current organization, the management account sends invitations, accounts accept and join. Existing resources are preserved—no downtime. SCPs and guardrails are applied progressively to avoid disrupting existing workloads. Option A is unnecessarily complex. Option C—there is no MergeAccounts API. Option D destroys resources.

---

### Question 18

A company is implementing a disaster recovery solution for their AWS environment. The management account of their Organization is critical for governance. They need a plan to handle a scenario where the management account is compromised or becomes inaccessible.

Which measures provide the BEST protection for the management account?

A. Only use the management account for Organizations management—no production workloads. Restrict access to a small group of administrators. Enable MFA on the root user and all IAM users. Set up CloudTrail alerts for sensitive API calls. Maintain an offline backup of account configurations and SCP policies.

B. Create a backup management account that mirrors all configurations.

C. Use a member account as a backup management account.

D. Store management account credentials in a shared password manager accessible to all IT staff.

**Correct Answer: A**

**Explanation:** Best practices for management account protection include: keeping it clean (no workloads), restricting access, enforcing MFA, monitoring API calls, and maintaining offline documentation/backup of configurations. If compromised, the documented configurations help recreate governance quickly. Option B—you can't have a "backup" management account for an organization. Option C—member accounts can't assume management account responsibilities. Option D creates security risks with broadly shared credentials.

---

### Question 19

A company uses AWS Organizations with consolidated billing. Different business units have different compliance requirements: the healthcare unit needs HIPAA controls, the payment unit needs PCI DSS controls, and the general business unit needs basic security controls. All units share a common set of baseline security controls.

How should the Organization structure and SCPs be designed?

A. Create a flat structure with all accounts in a single OU. Apply all compliance controls via a single SCP.

B. Create a hierarchical OU structure: Root → Baseline SCP (common controls) → Healthcare OU (HIPAA SCP) → PCI OU (PCI SCP) → General OU (basic SCP). Accounts are placed in the appropriate compliance OU. SCPs inherit down the hierarchy.

C. Create separate AWS Organizations for each compliance requirement.

D. Apply all SCPs at the account level rather than using OUs.

**Correct Answer: B**

**Explanation:** Hierarchical OUs with inherited SCPs allow layered compliance: baseline controls apply to all accounts via the root-level SCP, while specific compliance OUs add healthcare (HIPAA), payment (PCI), or general controls. SCP inheritance means accounts in the Healthcare OU get both baseline and HIPAA controls. Option A over-restricts all accounts with all controls. Option C fragments management across multiple organizations. Option D requires per-account SCP management which doesn't scale.

---

### Question 20

A company wants to implement a break-glass access mechanism for their multi-account environment. In emergency situations, specific senior engineers should be able to gain temporary administrator access to production accounts. The access should be logged, time-limited, and require approval from a security team member.

Which implementation provides a SECURE break-glass mechanism?

A. Create permanent admin IAM users in each production account with passwords stored in an envelope.

B. Implement a break-glass workflow using AWS IAM Identity Center with a dedicated break-glass permission set (AdministratorAccess). The permission set is normally unassigned. When a break-glass is needed, an automated approval workflow (via Step Functions with SNS notifications) assigns the permission set to the requesting engineer temporarily. Session duration is limited to 2 hours. CloudTrail logs all actions taken during the session.

C. Store root account credentials in a hardware safe deposit box.

D. Grant all senior engineers permanent administrator access for emergencies.

**Correct Answer: B**

**Explanation:** An automated break-glass workflow through IAM Identity Center provides temporary, auditable, approval-gated access. The permission set is only assigned after approval, sessions are time-limited, and CloudTrail logs every action. This balances security with emergency access needs. Option A uses permanent credentials that could be misused. Option C (root credentials) should be reserved for account-level emergencies, not application troubleshooting. Option D violates least privilege and removes all emergency guardrails.

---

### Question 21

A company is building a serverless event-driven architecture for their e-commerce platform. The checkout process must: validate inventory, process payment, initiate shipping, and send confirmation email. Each step takes 2-15 seconds. If any step fails, previous steps must be compensated (e.g., if shipping fails, payment must be refunded and inventory restored).

Which architecture provides reliable orchestration with compensation logic?

A. Use Amazon SNS to fan out the checkout event to all four services simultaneously. Each service handles its own rollback.

B. Use AWS Step Functions with a Saga pattern. The state machine executes steps sequentially, and each step has a corresponding compensation step. If a step fails, the state machine executes compensation steps for all previously completed steps in reverse order.

C. Use SQS queues between each step. If a step fails, send a message to a compensation queue.

D. Implement all four steps in a single Lambda function with try/catch blocks for compensation.

**Correct Answer: B**

**Explanation:** Step Functions implements the Saga pattern natively using sequential states with error handling. Each step defines a Catch block that triggers compensation steps (refund payment, restore inventory). The state machine manages the orchestration, retry logic, and compensation flow. Option A processes all steps simultaneously without ordering—can't compensate completed steps reliably. Option C requires building complex compensation queue logic. Option D risks Lambda timeout (60 seconds for 4 steps at 15 seconds each) and is a monolith.

---

### Question 22

A company needs a serverless file processing pipeline that handles uploads of various file types (PDF, CSV, JSON, XML). Each file type requires different processing logic. The pipeline must handle 100,000 files per day with sizes ranging from 1 KB to 5 GB. Files larger than 500 MB need special handling due to Lambda memory constraints.

Which architecture handles all file types and sizes?

A. S3 upload → EventBridge rule matching on file extension → different Lambda functions per file type for files under 500 MB. For files over 500 MB, EventBridge triggers ECS Fargate tasks with more memory and disk.

B. S3 upload → Single Lambda function that processes all file types and sizes.

C. S3 upload → SQS → EC2 Auto Scaling group for all processing.

D. S3 upload → Step Functions for every file regardless of type or size.

**Correct Answer: A**

**Explanation:** EventBridge rules route files by type (extension pattern matching) to specialized Lambda functions for most files. Files over 500 MB are routed to ECS Fargate which has configurable memory (up to 120 GB) and ephemeral storage (up to 200 GB). This architecture handles both the variety of file types and the range of file sizes. Option B can't handle 5 GB files—Lambda has limited ephemeral storage (10 GB) and memory (10 GB). Option C uses EC2 which isn't serverless. Option D adds unnecessary Step Functions overhead for simple file processing.

---

### Question 23

A company is designing a serverless real-time chat application. Messages must be delivered to all participants in a chat room within 200ms. The system must support 100,000 concurrent connections. Message history must be persisted for 30 days.

Which architecture provides real-time messaging with the required performance?

A. Clients poll an API Gateway REST API every second for new messages. Messages stored in DynamoDB.

B. Use Amazon API Gateway WebSocket API for persistent connections. Messages are sent through Lambda functions that broadcast to all room participants via the API Gateway Management API. Store messages in DynamoDB with TTL set to 30 days.

C. Use Amazon SQS for message delivery between participants.

D. Deploy an EC2 fleet running Socket.io behind a Network Load Balancer.

**Correct Answer: B**

**Explanation:** API Gateway WebSocket API supports persistent bidirectional connections at scale (100K+ concurrent connections). Lambda functions process incoming messages and broadcast to room participants via the @connections management API with sub-200ms latency. DynamoDB stores history with TTL for automatic 30-day cleanup. Option A (polling) wastes resources and can't achieve 200ms delivery. Option C (SQS) is for asynchronous processing, not real-time delivery. Option D requires managing EC2 infrastructure.

---

### Question 24

A company has a multi-Region active-passive DR setup for their application. The primary Region is us-east-1 and the DR Region is us-west-2. The current RTO is 4 hours and RPO is 1 hour. The business now requires RTO of 15 minutes and RPO of 5 minutes. The application uses Aurora MySQL, S3, and EC2 instances behind an ALB.

Which changes achieve the new RTO/RPO targets?

A. Switch to Aurora Global Database (RPO < 1 second). Deploy a warm standby in us-west-2 with a reduced-capacity Auto Scaling group and pre-configured ALB. Use Route 53 health checks with failover routing for automated DNS failover.

B. Keep the current pilot light but increase backup frequency.

C. Implement multi-site active-active in both Regions.

D. Use AWS Elastic Disaster Recovery to replicate EC2 instances with continuous replication.

**Correct Answer: A**

**Explanation:** Aurora Global Database provides sub-second replication (far exceeding the 5-minute RPO). A warm standby with running (but smaller) infrastructure in us-west-2 achieves 15-minute RTO—scale up the ASG and promote the Aurora secondary. Route 53 failover routing automates the DNS switchover. Option B doesn't achieve the new targets with a pilot light. Option C is more expensive than needed for the requirements. Option D handles EC2 but doesn't address Aurora, and RTO depends on instance launch time.

---

### Question 25

A company needs to implement a serverless API that processes images uploaded by users. The processing includes: resizing to multiple dimensions, applying watermarks, converting formats, and generating thumbnails. Each image generates 10 variants. The API must return all variant URLs within 30 seconds of upload.

Which architecture processes all variants within the time constraint?

A. Upload to S3 → Lambda function processes all 10 variants sequentially → returns URLs.

B. Upload to S3 → Step Functions Express Workflow using a Map state to process all 10 variants in parallel via Lambda functions → Collect results → Return URLs through API Gateway.

C. Upload to S3 → SNS notification → 10 separate Lambda functions triggered simultaneously → Write URLs to DynamoDB → Client polls for completion.

D. Upload to S3 → SQS → Lambda processes one variant at a time.

**Correct Answer: B**

**Explanation:** Step Functions Express Workflow with a Map state runs all 10 Lambda functions in parallel, each generating one variant. The workflow collects all results and returns them synchronously through API Gateway (Express Workflows support synchronous execution). Total time is the longest single variant processing time, not the sum. Option A processes sequentially—10 variants at 3 seconds each = 30 seconds, barely meeting the target with no margin. Option C is asynchronous—can't return URLs synchronously. Option D processes sequentially with queue overhead.

---

### Question 26

A healthcare company needs a serverless application that processes patient intake forms. The forms contain PHI (Protected Health Information) that must be encrypted end-to-end. The processing pipeline includes: OCR extraction, data validation, PII detection, and database storage. All intermediate data must be encrypted with customer-managed keys.

Which serverless architecture ensures end-to-end encryption of PHI?

A. API Gateway (HTTPS) → Lambda with environment variable encryption using KMS → S3 with SSE-KMS → Textract → Comprehend Medical → DynamoDB with customer-managed KMS key. All Lambda functions run in a VPC with VPC endpoints for service access.

B. API Gateway → Lambda → Store unencrypted in S3 → Process → Store in DynamoDB.

C. Use CloudFront with field-level encryption → Lambda → S3 → DynamoDB.

D. Use a custom encryption library in Lambda for all data handling without using KMS.

**Correct Answer: A**

**Explanation:** This architecture encrypts data at every stage: HTTPS in transit to API Gateway, Lambda environment variables encrypted with KMS, S3 server-side encryption with customer-managed KMS key, and DynamoDB encryption with customer-managed KMS. VPC with endpoints ensures processing traffic stays private. Textract and Comprehend Medical are HIPAA-eligible services. Option B lacks encryption at intermediate stages. Option C uses CloudFront field-level encryption which is for specific fields in forms, not end-to-end PHI protection. Option D avoids managed encryption services and is harder to audit.

---

### Question 27

A company is designing a disaster recovery solution for their containerized microservices application running on EKS. The application uses 30 microservices, Amazon Aurora, ElastiCache, and S3. The business requires an RTO of 30 minutes and RPO of 5 minutes.

Which DR strategy achieves these targets for a containerized workload?

A. Back up EKS cluster configurations and container images. In the event of disaster, recreate the EKS cluster from scratch.

B. Maintain an EKS cluster in the DR Region with the same namespace and service configurations deployed via GitOps (ArgoCD/Flux). Use Aurora Global Database for sub-second database replication. Replicate ElastiCache using Global Datastore. Use S3 Cross-Region Replication. During failover: promote Aurora secondary, scale up EKS nodes, and update DNS.

C. Use AWS Backup to snapshot all resources and restore them in the DR Region.

D. Use EKS on Fargate in the DR Region for simplified infrastructure management.

**Correct Answer: B**

**Explanation:** GitOps ensures the DR EKS cluster always has the same application configurations as primary. Aurora Global Database provides < 1-second RPO. ElastiCache Global Datastore replicates the cache layer. S3 CRR replicates object data. During failover, promoting Aurora and scaling EKS nodes takes < 30 minutes (RTO met). Option A requires rebuilding the cluster—exceeds 30-minute RTO. Option C uses AWS Backup which doesn't support all EKS resources and is slower. Option D doesn't address the application deployment or data replication.

---

### Question 28

A company operates a global SaaS platform. They need to implement a multi-Region architecture where users are automatically routed to the closest Region, and if one Region fails, traffic is automatically redirected to the next closest healthy Region. The failover must happen within 60 seconds.

Which DNS and routing configuration achieves sub-60-second failover?

A. Use Route 53 latency-based routing with health checks configured for 10-second intervals and a failover threshold of 3. Set the TTL on Route 53 records to 60 seconds. Use alias records pointing to Regional ALBs.

B. Use CloudFront with origin failover groups for automatic Regional failover.

C. Use Route 53 simple routing to a single Region with manual DNS updates for failover.

D. Use AWS Global Accelerator with endpoint groups in each Region and health checks.

**Correct Answer: D**

**Explanation:** AWS Global Accelerator uses static anycast IPs and health checks that detect failure within 30 seconds (10-second interval × 3 threshold). Traffic is immediately redirected to healthy endpoint groups without DNS TTL delays. This consistently achieves sub-60-second failover. Option A with Route 53 depends on DNS TTL (60 seconds) plus propagation time—clients may cache DNS beyond TTL, exceeding 60 seconds. Option B works for HTTP/HTTPS but not all traffic types. Option C is manual.

---

### Question 29

A company needs a serverless backend for their mobile application. The backend must support: offline-first data synchronization, real-time data subscriptions, and GraphQL API. User authentication integrates with social identity providers (Google, Facebook, Apple).

Which AWS services combination provides these capabilities with the LEAST custom code?

A. API Gateway REST API with Lambda resolvers. Build custom sync and subscription logic. Use Cognito for authentication.

B. AWS AppSync with DynamoDB data sources. Enable AppSync's built-in real-time subscriptions and offline data sync. Use Amazon Cognito User Pools with social identity provider federation.

C. Build a custom GraphQL server on ECS Fargate with WebSocket support for subscriptions. Use an Application Load Balancer.

D. Use Amazon API Gateway HTTP API with Lambda functions implementing GraphQL.

**Correct Answer: B**

**Explanation:** AppSync is a managed GraphQL service with built-in real-time subscriptions (WebSocket) and offline data sync capabilities for mobile/web apps. DynamoDB data sources integrate natively. Cognito User Pools support social federation (Google, Facebook, Apple) out of the box. This requires the least custom code. Option A requires building sync and subscription logic manually. Option C requires building everything from scratch. Option D requires implementing GraphQL parsing and execution in Lambda.

---

### Question 30

A company has a pilot light DR setup where the DR Region has AMIs, CloudFormation templates, and database backups but no running infrastructure. During a DR test, it took 2 hours to bring up the environment because of dependencies between services and the order they needed to start.

How can the DR recovery time be reduced and automated?

A. Create a detailed runbook document for the operations team to follow during DR.

B. Implement a Step Functions workflow that orchestrates the DR recovery sequence: (1) restore Aurora from backup, (2) launch infrastructure via CloudFormation, (3) verify health checks pass, (4) update Route 53 DNS. Each step has error handling and retry logic.

C. Use a single CloudFormation stack that deploys all resources. Run the stack during DR.

D. Pre-deploy all resources in the DR Region and keep them stopped.

**Correct Answer: B**

**Explanation:** Step Functions automates the DR sequence with proper dependency ordering, error handling, and retry logic. Each step (database restore, infrastructure deployment, health verification, DNS update) executes in the correct order with automated validation before proceeding. This reduces human error and parallelizes where possible. Option A is manual and error-prone under stress. Option C doesn't handle dependencies between stack resources and existing data (Aurora restore). Option D changes pilot light to warm standby—different cost profile.

---

### Question 31

A financial services company needs to process stock market trades in real-time. The system receives 1 million trades per second during market hours. Each trade must be processed exactly once, and the total processing latency must be under 10ms. The system must be highly available across multiple AZs.

Which architecture meets the ultra-low-latency requirement?

A. Amazon Kinesis Data Streams with Lambda consumers.

B. Amazon SQS FIFO with Lambda consumers.

C. Self-managed Apache Kafka on EC2 instances (i3.metal) with Kafka Streams for processing, deployed across multiple AZs. Use enhanced networking and placement groups for lowest latency.

D. Amazon MSK Serverless with Lambda consumers.

**Correct Answer: C**

**Explanation:** Sub-10ms end-to-end latency with exactly-once processing at 1M TPS requires optimized infrastructure. Self-managed Kafka on bare-metal i3 instances with local NVMe storage, enhanced networking, and placement groups provides the lowest possible latency. Kafka Streams provides exactly-once semantics. Option A (Kinesis) has 200ms PutRecord latency alone. Option B (SQS FIFO) is limited to 3,000 messages/second per message group. Option D (MSK Serverless) adds overhead from the managed abstraction that makes sub-10ms unreliable.

---

### Question 32

A company wants to implement a zero-downtime database schema migration strategy for their Aurora PostgreSQL database. The migration adds new columns, modifies indexes, and drops deprecated columns. The application must continue serving requests during the entire migration.

Which approach ensures zero downtime?

A. Take the database offline, run the migration, and bring it back online.

B. Use a blue-green database deployment: create a clone of the Aurora cluster, apply schema changes to the clone, use DMS to keep the clone synchronized, then switch the application to the clone.

C. Implement an expand-and-contract migration strategy: Phase 1 (expand) adds new columns and dual-writes to both old and new columns. Phase 2 (migrate) backfills data in new columns. Phase 3 (contract) removes old columns after all application code uses new columns. Use online DDL operations (CREATE INDEX CONCURRENTLY for PostgreSQL).

D. Run ALTER TABLE statements directly on the production database during off-peak hours.

**Correct Answer: C**

**Explanation:** Expand-and-contract is the standard zero-downtime schema migration pattern. Adding columns is non-blocking in PostgreSQL. Dual-writing ensures data consistency during transition. CREATE INDEX CONCURRENTLY builds indexes without locking the table. Dropping old columns happens only after all application versions use the new schema. Option A requires downtime. Option B is complex and DMS may not handle all schema change scenarios. Option D with ALTER TABLE for certain operations (like adding NOT NULL constraints) can lock the table.

---

### Question 33

A company is designing a disaster recovery solution for their serverless application stack consisting of API Gateway, Lambda, DynamoDB, S3, and Cognito. The RPO must be near zero and RTO under 5 minutes.

Which DR strategy is MOST appropriate for this serverless stack?

A. Deploy the identical serverless stack in the DR Region using infrastructure as code (CloudFormation/SAM). Use DynamoDB Global Tables for near-zero RPO. Use S3 Cross-Region Replication. Use Cognito user pool import/export for user data. Use Route 53 health checks with failover routing to switch traffic to the DR Region's API Gateway.

B. Back up all configurations and redeploy in the DR Region when needed.

C. Use AWS Backup to snapshot all resources.

D. Deploy Lambda functions in the DR Region and connect them to the primary Region's DynamoDB.

**Correct Answer: A**

**Explanation:** For serverless DR, you deploy identical infrastructure in the DR Region (API Gateway, Lambda, Cognito are stateless—just deploy). DynamoDB Global Tables provide sub-second replication for near-zero RPO. S3 CRR replicates objects. Route 53 failover routing switches traffic within seconds. RTO is effectively the Route 53 health check detection time. Option B exceeds the 5-minute RTO. Option C doesn't support all serverless resources. Option D creates cross-Region latency for every database call.

---

### Question 34

A company operates a data processing pipeline that runs nightly batch jobs. The pipeline consists of: data extraction from multiple sources, transformation using Spark, loading into a data warehouse, and report generation. The total processing time is 6 hours. The company wants to implement monitoring that detects pipeline failures within 5 minutes and automatically retries failed steps.

Which monitoring and retry architecture is MOST effective?

A. Use Amazon CloudWatch Logs and create metric filters for error patterns. Set alarms on error metrics.

B. Orchestrate the pipeline using AWS Step Functions. Each step (extract, transform, load, report) is a separate state with retry policies (exponential backoff, max attempts). Step Functions automatically detects task failures, retries, and sends SNS notifications. Use CloudWatch metrics on Step Functions execution metrics for dashboards.

C. Monitor with CloudWatch Dashboards and have an on-call engineer manually restart failed steps.

D. Run a monitoring Lambda every 5 minutes that checks if the pipeline output exists.

**Correct Answer: B**

**Explanation:** Step Functions provides built-in retry policies with configurable backoff, max attempts, and error matching. Failed states are detected immediately and retried automatically. SNS notifications alert the team. CloudWatch metrics on execution status, duration, and errors provide operational dashboards. Option A detects errors but doesn't provide automatic retry orchestration. Option C requires manual intervention. Option D is a crude check that doesn't identify which step failed.

---

### Question 35

A company has a serverless application using API Gateway and Lambda. They need to implement a rate limiting strategy that: limits each customer to 100 requests per minute, allows bursting to 200 requests per minute for premium customers, and returns a 429 status code when limits are exceeded.

Which approach implements per-customer rate limiting?

A. Use API Gateway usage plans with API keys. Create two usage plans: standard (100 req/min) and premium (200 req/min). Associate each customer's API key with the appropriate usage plan.

B. Implement rate limiting in the Lambda function using a DynamoDB counter per customer.

C. Use AWS WAF rate-based rules on the API Gateway to limit requests.

D. Configure API Gateway account-level throttling to 100 requests per minute.

**Correct Answer: A**

**Explanation:** API Gateway usage plans with API keys provide per-customer rate limiting with configurable request rates and burst capacities. Standard and premium plans with different limits map to customer tiers. API Gateway automatically returns 429 (Too Many Requests) when limits are exceeded. Option B adds latency and complexity to every request. Option C (WAF rate rules) limits by IP, not per-customer. Option D applies account-wide, not per-customer.

---

### Question 36

A company wants to implement a multi-Region active-active architecture for their serverless application. The application uses API Gateway, Lambda, and DynamoDB. Both Regions must handle reads and writes. Users should be routed to the nearest Region with automatic failover.

Which architecture supports active-active serverless operations?

A. Deploy identical API Gateway + Lambda stacks in both Regions. Use DynamoDB Global Tables for multi-Region read/write. Use Route 53 latency-based routing with health checks to route users to the nearest healthy Region.

B. Deploy the application in one Region and use CloudFront for caching in the other Region.

C. Deploy API Gateway in both Regions but Lambda and DynamoDB in only one Region. Use cross-Region API invocation.

D. Use a single Regional API Gateway with edge-optimized endpoints for global access.

**Correct Answer: A**

**Explanation:** DynamoDB Global Tables enable active-active multi-Region writes with sub-second replication. Identical serverless stacks in both Regions handle local requests. Route 53 latency-based routing with health checks routes users to the nearest Region and automatically fails over to the other Region if health checks fail. Option B is a CDN pattern, not active-active. Option C still has single-Region dependencies for compute and data. Option D doesn't provide true multi-Region processing or failover.

---

### Question 37

A logistics company needs to process GPS tracking data from 50,000 delivery vehicles. Each vehicle sends its location every 5 seconds. The system must: ingest all location data, calculate ETAs in real-time, detect if vehicles deviate from planned routes, and store historical data for analytics.

Which architecture handles all requirements?

A. Amazon IoT Core for device connectivity → Kinesis Data Streams for ingestion → Amazon Managed Service for Apache Flink for real-time ETA calculation and route deviation detection → S3 via Firehose for historical storage → DynamoDB for current vehicle positions.

B. API Gateway REST API for each vehicle to POST location data → Lambda for processing → DynamoDB.

C. Amazon SQS for ingestion → Lambda for processing → RDS for storage.

D. Direct database inserts from vehicles to Aurora for all processing and storage.

**Correct Answer: A**

**Explanation:** IoT Core handles 50,000 device connections with MQTT protocol optimized for constrained devices. Kinesis handles 10,000 messages/second (50K vehicles × 1 msg/5s). Flink provides stateful stream processing for ETAs (maintaining vehicle state) and route deviation detection (comparing to planned routes). Firehose archives to S3 for analytics. DynamoDB stores latest positions. Option B can't handle 10K TPS through API Gateway efficiently for this use case. Option C lacks real-time processing capabilities. Option D can't handle the ingestion rate.

---

### Question 38

A company operates a microservices application and needs to implement a circuit breaker pattern to prevent cascading failures. When Service A calls Service B and Service B becomes unhealthy, the circuit should open, returning cached responses for a configurable period before attempting to reconnect.

Which implementation approach is MOST appropriate for AWS?

A. Implement circuit breaker logic in application code using a library like Resilience4J or Hystrix.

B. Use AWS App Mesh with Envoy proxy's built-in circuit breaker, retry, and timeout configurations. Configure outlier detection on Service B's virtual node to eject unhealthy endpoints. Envoy returns fallback responses when the circuit is open.

C. Configure ALB health checks to remove unhealthy targets.

D. Use Route 53 health checks to stop routing to unhealthy services.

**Correct Answer: B**

**Explanation:** App Mesh with Envoy provides infrastructure-level circuit breaking without application code changes. Outlier detection automatically identifies failing Service B endpoints and ejects them. Envoy proxies can be configured with retry policies, timeouts, and circuit breaker thresholds. This works across all services in the mesh consistently. Option A requires implementing in every service independently. Option C removes targets but doesn't implement circuit breaker behavior (cached responses, half-open state). Option D operates at DNS level—too slow for circuit breaker patterns.

---

### Question 39

A company needs to implement a DR plan that tests failover automatically every quarter without impacting production. The DR test should validate: database failover, application deployment, DNS switching, and end-to-end functionality.

Which approach enables automated, non-disruptive DR testing?

A. Manually execute DR runbooks quarterly and document results.

B. Use AWS Fault Injection Simulator (FIS) to inject failures and test DR responses. Create FIS experiment templates that simulate AZ failure and Region failure scenarios. Combine with Step Functions to orchestrate the full DR test: trigger FIS experiment → verify application failover → run integration tests → restore original state.

C. Shut down the primary Region entirely and observe if DR kicks in.

D. Test DR in a separate isolated environment that mirrors production.

**Correct Answer: B**

**Explanation:** FIS injects controlled failures (AZ/Region simulation) without permanently impacting production. Step Functions orchestrates the test sequence: inject failure, validate failover, run health checks, restore. This automates the quarterly test and validates the entire DR chain. Option A is manual and error-prone. Option C impacts production during testing. Option D tests a separate environment which may not reflect production conditions.

---

### Question 40

A company is implementing a multi-tenant serverless application using API Gateway and Lambda. Each tenant has different compute requirements—some tenants process data-heavy requests that need more memory and longer execution times, while others have lightweight requests. The company wants to optimize Lambda costs per tenant.

Which approach provides per-tenant Lambda optimization?

A. Use a single Lambda function with maximum memory for all tenants.

B. Create separate Lambda functions with different memory configurations for each tenant tier. Use API Gateway request mapping to route to the appropriate function based on tenant metadata. Use Lambda Power Tuning to optimize memory for each tier.

C. Use Lambda provisioned concurrency for all tenants.

D. Deploy separate ECS tasks for each tenant with custom resource configurations.

**Correct Answer: B**

**Explanation:** Separate Lambda functions per tenant tier with optimized memory configurations ensure each tenant tier uses only the resources it needs. API Gateway routing directs requests to the appropriate function. Lambda Power Tuning identifies the most cost-effective memory setting per workload type. Option A over-provisions for lightweight tenants, wasting money. Option C adds cost without addressing memory optimization. Option D moves away from serverless.

---

### Question 41

A company is designing a solution for processing insurance claims documents. Each claim consists of multiple PDF pages that must be processed with OCR, classified, and data extracted. The processing of each page is independent but results must be aggregated per claim. Claims arrive in bursts (1,000 claims during natural disasters, 50 during normal periods).

Which serverless architecture handles bursty workloads and aggregation?

A. S3 upload (multi-page PDF) → Lambda (split into pages) → Step Functions Distributed Map to process all pages in parallel (OCR with Textract, classification with Comprehend) → Aggregation step to combine results per claim → DynamoDB for claim data.

B. S3 upload → Single Lambda function processes all pages sequentially.

C. S3 upload → SQS → EC2 fleet for processing.

D. S3 upload → Lambda for each page triggered by S3 events → Attempt to aggregate in the last Lambda invocation.

**Correct Answer: A**

**Explanation:** Step Functions Distributed Map can process thousands of items in parallel, handling the burst scenario. Each page is processed independently (Textract OCR, Comprehend classification) and results are automatically aggregated per claim by the workflow. This handles both the normal 50-claim rate and 1,000-claim bursts. Option B would exceed Lambda timeout for multi-page claims. Option C isn't serverless. Option D has no reliable aggregation mechanism—the "last" Lambda can't know it's last.

---

### Question 42

A media company needs to implement a content moderation system for user-uploaded images and videos. The system must detect inappropriate content, apply labels, and either approve or reject uploads within 10 seconds for images and 60 seconds for videos. Human review is required for borderline cases.

Which architecture provides automated moderation with human review?

A. S3 upload → Lambda triggered by S3 event → Amazon Rekognition (DetectModerationLabels for images, StartContentModeration for videos) → If confidence > 90% inappropriate: auto-reject. If confidence < 50%: auto-approve. If 50-90%: route to Amazon Augmented AI (A2I) for human review → DynamoDB for moderation decisions.

B. S3 upload → Lambda → Third-party moderation API → Manual review for all flagged content.

C. S3 upload → SageMaker custom model for moderation → Manual email notifications for review.

D. Have human moderators review all uploaded content manually.

**Correct Answer: A**

**Explanation:** Rekognition provides real-time moderation for images (< 10 seconds) and asynchronous moderation for videos (< 60 seconds). Confidence-based routing automates clear decisions and sends ambiguous cases to A2I for human review through a managed workflow. DynamoDB stores decisions for audit. Option B adds external API dependency and doesn't have managed human review. Option C requires training a custom model and building human review workflows. Option D doesn't scale and misses the automation requirement.

---

### Question 43

A company runs a large-scale web application on a fleet of 200 EC2 instances across 3 Availability Zones. They experience occasional instance failures that cause brief user-facing errors before the ALB removes the unhealthy instance. The team wants to reduce the time between instance failure and traffic removal.

Which changes reduce the failure detection time?

A. Reduce the ALB health check interval from 30 seconds to 5 seconds. Reduce the unhealthy threshold from 3 to 2 checks. This reduces worst-case detection time from 90 seconds (30s × 3) to 10 seconds (5s × 2). Additionally, configure the application's health check endpoint to verify dependencies (database, cache) to detect application-level failures, not just instance-level.

B. Increase the number of instances to reduce the impact of a single failure.

C. Switch to TCP health checks instead of HTTP health checks for faster checks.

D. Implement client-side retry logic to handle errors during failure detection.

**Correct Answer: A**

**Explanation:** Reducing the health check interval and unhealthy threshold directly decreases the time to detect and remove unhealthy instances. A comprehensive health check endpoint that verifies dependencies catches more failure modes than a simple TCP check. Going from 90 seconds to 10 seconds detection dramatically reduces user impact. Option B reduces percentage impact but doesn't speed detection. Option C (TCP checks) only verify connectivity, missing application failures. Option D is a compensating control, not a root cause fix.

---

### Question 44

A company's Lambda-based application has been experiencing cold start latency of 3-5 seconds for their Java-based Lambda functions. This affects user experience for synchronous API calls. The functions are invoked approximately 50 times per minute with occasional bursts to 500 per minute.

Which combination reduces cold start latency? (Choose TWO.)

A. Enable Lambda SnapStart for the Java functions, which snapshots the initialized execution environment and restores from the snapshot for faster cold starts.

B. Configure provisioned concurrency to keep 10 warm instances (covering the baseline 50/minute rate) to eliminate cold starts for consistent traffic.

C. Increase the Lambda function memory to reduce cold start initialization time.

D. Convert the functions from Java to Python for faster initialization.

E. Increase the Lambda timeout to 15 minutes.

**Correct Answer: A, B**

**Explanation:** SnapStart (A) dramatically reduces Java cold start times by creating a snapshot of the initialized environment, reducing cold starts from seconds to milliseconds. Provisioned concurrency (B) keeps environments pre-initialized for the baseline traffic, eliminating cold starts entirely for those requests. Together, SnapStart handles burst cold starts efficiently while provisioned concurrency covers baseline traffic. Option C helps marginally. Option D requires a full rewrite. Option E doesn't affect cold start time.

---

### Question 45

A company is using Amazon CloudWatch for monitoring and has 1,000 CloudWatch alarms. The operations team receives too many alerts, experiencing alert fatigue. Many alarms trigger simultaneously during cascading failures, making it hard to identify the root cause.

Which approach reduces alert fatigue and improves incident management?

A. Increase alarm thresholds to trigger fewer alarms.

B. Implement CloudWatch composite alarms that group related alarms using logical expressions. Create top-level alarms that only notify when specific combinations of conditions occur (e.g., high latency AND high error rate AND database slowness). Use Amazon EventBridge to route composite alarm state changes to PagerDuty or OpsGenie for incident management.

C. Disable most alarms and rely on CloudWatch dashboards for monitoring.

D. Send all alarms to a Slack channel for the team to triage.

**Correct Answer: B**

**Explanation:** Composite alarms suppress individual alarm notifications and only fire when specific combinations of conditions are met, reducing noise from cascading failures. EventBridge integration routes meaningful composite alarms to incident management platforms for proper triage. Option A risks missing legitimate issues. Option C eliminates proactive alerting. Option D increases noise by sending everything to a channel.

---

### Question 46

A company runs a real-time analytics dashboard that queries an Aurora PostgreSQL database. During business hours, dashboard queries compete with the OLTP application workload, causing both to slow down. The dashboard queries are read-only and can tolerate up to 5 seconds of data staleness.

How should the workloads be separated?

A. Add a read replica and point dashboard queries to the reader endpoint.

B. Create a custom Aurora endpoint for analytics that routes to dedicated reader instances with larger instance types. Configure the application to use the writer endpoint for OLTP and the custom analytics endpoint for dashboard queries. The 5-second staleness tolerance is well within Aurora's typical replication lag.

C. Cache all dashboard data in ElastiCache with 5-second TTL.

D. Schedule dashboard queries to run only outside business hours.

**Correct Answer: B**

**Explanation:** Custom endpoints with dedicated reader instances (potentially larger for complex analytics queries) isolate the workloads completely. Dashboard queries hit dedicated readers while OLTP uses the writer. Aurora replication lag is typically < 100ms, well within the 5-second tolerance. Option A (reader endpoint) distributes across all readers, which may include small instances used by the application. Option C requires building cache invalidation logic and doesn't suit complex analytical queries. Option D restricts dashboard availability.

---

### Question 47

A company deployed a new version of their application that introduced a memory leak. Over 6 hours, memory usage slowly climbed from 40% to 95% across all instances before the team noticed and rolled back. They need a monitoring solution that detects gradual metric trends (not just threshold breaches) and alerts before resources are exhausted.

Which monitoring approach detects gradual degradation?

A. Set a CloudWatch alarm at 80% memory utilization threshold.

B. Use CloudWatch Anomaly Detection on memory utilization metrics. Anomaly detection uses machine learning to establish a baseline pattern and alerts when the metric deviates from the expected band (a gradual increase would deviate from the normal pattern). Combine with CloudWatch metric math to calculate the rate of change (derivative) of memory usage and alert when the rate is abnormally positive.

C. Have the operations team manually review CloudWatch dashboards hourly.

D. Use CloudWatch Logs Insights to search for memory-related log entries.

**Correct Answer: B**

**Explanation:** Anomaly Detection learns normal metric patterns (memory typically stable at 40%) and alerts when the gradual climb deviates from the expected band. The rate-of-change metric math (derivative) detects the upward trend even before reaching any absolute threshold. Together, they catch gradual degradation early. Option A only alerts at a fixed threshold—by 80%, the problem is severe. Option C is manual and can miss trends. Option D requires specific log messages about memory.

---

### Question 48

A company runs their CI/CD pipeline using AWS CodePipeline. After a recent production deployment, a subtle performance regression was introduced. The team wants to implement automated performance testing in their pipeline that compares the new version's performance against the current production version before deployment.

Which approach enables automated performance regression detection?

A. Manually run JMeter tests after each deployment and compare results.

B. Add a CodePipeline stage between test and production that: (1) deploys the new version to a performance testing environment using CloudFormation, (2) runs load tests using a CodeBuild project with distributed testing tools, (3) compares results against baseline metrics stored in DynamoDB, (4) fails the pipeline if performance degrades beyond a defined threshold, (5) tears down the test environment.

C. Monitor production after deployment and roll back if performance degrades.

D. Set up CloudWatch alarms in production to catch performance issues.

**Correct Answer: B**

**Explanation:** Automated performance testing in the pipeline catches regressions before production deployment. A temporary performance testing environment with realistic load tests compared against stored baselines provides objective pass/fail criteria. CloudFormation creates and destroys the test environment automatically. Option A is manual and not integrated with the pipeline. Option C catches issues in production, exposing users to degradation. Option D only alerts after production impact.

---

### Question 49

A company has a microservices architecture where Service A depends on Service B, which depends on Service C. When Service C has increased latency, it causes cascading timeouts through B to A, eventually causing complete system degradation. The company needs to implement resilience patterns.

Which combination of patterns prevents cascading failures? (Choose TWO.)

A. Implement timeout settings for all inter-service calls—Service A sets a 2-second timeout for calls to B, and B sets a 1-second timeout for calls to C. This prevents any service from waiting indefinitely.

B. Implement bulkhead isolation by using separate thread pools or connection pools for calls to each downstream service. If Service C calls are consuming all connections, it doesn't affect Service A's other operations.

C. Increase the timeout to 60 seconds for all inter-service calls to accommodate slow responses.

D. Add more instances of Service C to handle the load.

E. Log all timeout errors for post-incident analysis.

**Correct Answer: A, B**

**Explanation:** Timeouts (A) prevent any service from waiting indefinitely for a slow dependency—failing fast allows the system to return errors or fallback responses. Bulkhead isolation (B) prevents a single slow dependency from consuming all resources (threads, connections), protecting other operations from being affected. Together, these prevent cascading failures. Option C makes cascading failures worse by extending waits. Option D addresses Service C scaling but doesn't protect A and B from C's issues. Option E is diagnostic, not preventive.

---

### Question 50

A company has an Auto Scaling group with a step scaling policy. The scaling policy reacts too slowly—by the time new instances are launched and become healthy, the load spike has passed. The scaling then triggers scale-in, creating a "thrashing" pattern of constant scale-out and scale-in.

Which changes stabilize the Auto Scaling behavior?

A. Switch from step scaling to target tracking scaling with a cooldown period. Target tracking adjusts capacity proportionally to maintain the target metric value, reducing oscillation. Set a scale-in cooldown of 300 seconds to prevent premature scale-in.

B. Remove all scaling policies and use a fixed number of instances.

C. Increase the step scaling adjustment to launch more instances per step.

D. Decrease the health check grace period to speed up instance availability.

**Correct Answer: A**

**Explanation:** Target tracking scaling continuously adjusts capacity to maintain a target metric (e.g., 50% CPU), which is smoother than step scaling's discrete adjustments. The scale-in cooldown prevents premature scale-in after scale-out, eliminating thrashing. Target tracking also considers the capacity needed proactively rather than reacting to threshold breaches. Option B loses elasticity entirely. Option C launches more instances, worsening the overshoot. Option D doesn't address the scaling policy behavior.

---

### Question 51

A company operates a highly available web application across three AZs. They need to implement chaos engineering practices to validate their resilience. The team wants to start with controlled experiments that gradually increase in severity.

Which progression of chaos experiments is MOST appropriate?

A. Start with Region-level failures immediately to test the worst case.

B. Phase 1: Use AWS Fault Injection Simulator to inject single-instance failures (terminate one EC2 instance) and validate Auto Scaling recovery. Phase 2: Inject AZ-level failures (detach subnet from ALB) and validate cross-AZ failover. Phase 3: Inject dependency failures (increase latency to database endpoints) and validate circuit breakers. Phase 4: Simulate partial Region degradation. Each phase validates steady state before progressing.

C. Test in production with no safeguards to get realistic results.

D. Only run chaos experiments in the development environment.

**Correct Answer: B**

**Explanation:** A graduated approach builds confidence incrementally: starting with small, recoverable failures (single instance) before progressing to larger blast radius experiments (AZ failure, dependency failures). Each phase validates the system's recovery before introducing more severe faults. FIS provides controlled experiment execution with stop conditions. Option A starts with maximum blast radius before validating basic resilience. Option C risks production without proven safeguards. Option D doesn't validate production-like conditions.

---

### Question 52

A company runs an application that writes metrics to CloudWatch from 500 EC2 instances. Each instance publishes 50 custom metrics every minute, totaling 25,000 PutMetricData API calls per minute. This is causing API throttling and high CloudWatch costs.

How should the metric publishing be optimized?

A. Use the CloudWatch Embedded Metric Format (EMF) in application logs. Write structured log entries with metric data to CloudWatch Logs. CloudWatch automatically extracts metrics from the logs. This reduces API calls by batching metrics within log entries and leverages the higher throughput of the PutLogEvents API.

B. Increase the PutMetricData API rate limit by contacting AWS Support.

C. Reduce the number of custom metrics published.

D. Publish metrics every 5 minutes instead of every minute.

**Correct Answer: A**

**Explanation:** CloudWatch EMF allows embedding metric data in CloudWatch Logs entries. A single PutLogEvents call can contain multiple metric data points, dramatically reducing API calls. CloudWatch Logs has higher throughput limits than PutMetricData. The metrics are automatically extracted and appear in CloudWatch Metrics with no additional cost per metric beyond the log ingestion. Option B is a band-aid that doesn't reduce costs. Option C loses observability. Option D reduces resolution.

---

### Question 53

A company has implemented blue-green deployment for their application. After switching traffic to the green environment, they discover a data corruption bug that affected records written to the database during the 30-minute green validation period. The blue environment's application code is correct, but both blue and green share the same database.

What lessons should be applied to prevent this scenario?

A. Never do blue-green deployments—use rolling deployments instead.

B. Implement the following safeguards for future blue-green deployments: (1) Use database feature flags that limit new functionality's write scope during validation. (2) Implement database change auditing that logs all mutations during validation, enabling targeted rollback. (3) For destructive database changes, implement a compatibility window where both old and new code versions work with the database schema. (4) Consider separate database schemas for blue and green with data synchronization for truly isolated testing.

C. Roll back the entire database from a backup.

D. Keep the green environment running and manually fix the corrupted records.

**Correct Answer: B**

**Explanation:** The root cause is shared mutable state (database) between blue and green environments. Feature flags limit new code's write impact during validation. Change auditing enables targeted record correction. Schema compatibility ensures safe rollback. For critical deployments, isolated database schemas provide full protection. These practices prevent data corruption during the validation window. Option A avoids the problem but loses blue-green benefits. Option C rolls back all changes including valid ones. Option D is manual and error-prone.

---

### Question 54

A company has 500 physical servers in their data center running a mix of Windows and Linux workloads. The data center lease expires in 18 months. They need to plan and execute a full data center migration to AWS. The company has limited AWS experience.

Which phased migration approach is MOST appropriate?

A. Migrate all 500 servers simultaneously using AWS Application Migration Service.

B. Phase 1 (Months 1-3): Use AWS Migration Hub and Application Discovery Service to assess all servers, map dependencies, and create migration waves. Phase 2 (Months 3-6): Migrate non-critical workloads (dev/test) using AWS MGN for a rehost approach. Phase 3 (Months 6-12): Migrate production workloads in waves based on dependency groups. Phase 4 (Months 12-18): Optimize migrated workloads (replatform/refactor where beneficial). Use Migration Hub to track progress throughout.

C. Start with the most critical production systems to prove the migration approach.

D. Refactor all applications for cloud-native before migrating.

**Correct Answer: B**

**Explanation:** A phased approach manages risk and builds experience. Assessment first identifies dependencies and creates logical migration waves. Starting with non-critical workloads builds team expertise before tackling production. Production moves in dependency-mapped waves to avoid breaking interconnected systems. Post-migration optimization takes advantage of cloud services. Option A is high-risk with no experience. Option C starts with the highest-risk systems. Option D delays the timeline significantly (18-month lease constraint).

---

### Question 55

A company is migrating a VMware-based virtualized environment with 200 VMs to AWS. The VMs have complex interdependencies and use VMware-specific features like vMotion, DRS, and vSAN. The company wants the fastest migration path while maintaining operational familiarity.

Which migration strategy provides the fastest path with minimal disruption?

A. Use AWS Application Migration Service (MGN) to replicate each VM individually to EC2 instances.

B. Use VMware Cloud on AWS. Migrate VMs using VMware HCX (Hybrid Cloud Extension) which provides live vMotion migration from on-premises vSphere to VMware Cloud on AWS. This preserves VMware tooling, operational procedures, and VM configurations.

C. Use VM Import/Export to convert each VM to an AMI.

D. Recreate all VMs as new EC2 instances and reinstall applications.

**Correct Answer: B**

**Explanation:** VMware Cloud on AWS provides a VMware SDDC running on AWS hardware. HCX enables live vMotion migration with zero downtime, preserving all VMware-specific configurations. The operations team continues using familiar VMware tools. This is the fastest path for a VMware-heavy environment. Option A works but loses VMware-specific features and requires per-VM configuration. Option C is slow for 200 VMs. Option D requires rebuilding everything from scratch.

---

### Question 56

A company has a PostgreSQL database that uses logical replication to maintain a reporting replica. They want to migrate the primary database to Amazon Aurora PostgreSQL while keeping the on-premises reporting replica active during a 6-month transition period.

Which approach maintains the reporting replica during migration?

A. Use AWS DMS with full load and CDC to migrate to Aurora PostgreSQL. After cutover, configure Aurora PostgreSQL's native logical replication to publish changes back to the on-premises PostgreSQL reporting replica. This maintains the existing reporting infrastructure during the 6-month transition.

B. Maintain the on-premises primary as a read source for the reporting replica and use DMS only for Aurora migration.

C. Shut down the reporting replica and use Amazon Athena for reporting during the transition.

D. Migrate both the primary and reporting replica to Aurora simultaneously.

**Correct Answer: A**

**Explanation:** DMS migrates the primary to Aurora with minimal downtime. After cutover, Aurora PostgreSQL's native logical replication publishes changes to the on-premises reporting replica, maintaining the existing reporting workflow during the 6-month transition. This is a clean separation of migration and reporting concerns. Option B keeps the old primary running, which means maintaining two writable databases. Option C disrupts existing reporting workflows. Option D doesn't address the on-premises reporting requirement.

---

### Question 57

A retail company needs to migrate their e-commerce platform from on-premises to AWS. The platform consists of: a Java-based web application on Tomcat, a RESTful API on Spring Boot, a MySQL 5.7 database, a Redis cache, and NFS-based shared storage for product images. The migration must complete within a 4-hour maintenance window.

Which migration plan fits within the 4-hour window?

A. Rewrite all applications as serverless functions and migrate data.

B. Pre-migration: Use DMS full load + CDC for MySQL → Aurora MySQL (running in parallel for weeks before cutover). Set up ElastiCache for Redis with REPLICAOF. Migrate product images to S3 using DataSync (completed before cutover). Replicate Java applications using MGN (continuous replication). During the 4-hour window: stop on-premises applications, let DMS/Redis sync final data, promote Aurora, switch ElastiCache to primary, update DNS to point to AWS. Test and validate.

C. During the 4-hour window: export MySQL database, upload to S3, import into Aurora, copy images to S3, launch EC2 instances from AMIs.

D. Migrate the database first, run dual-site for a month, then migrate applications.

**Correct Answer: B**

**Explanation:** Pre-staging all data migrations (DMS CDC, Redis replication, DataSync, MGN replication) before the maintenance window means the 4-hour cutover only needs to: stop writes, sync final deltas (minutes), promote targets, and verify. This approach does the heavy lifting asynchronously and minimizes the cutover window. Option A is a rewrite, not a migration. Option C tries to do everything in 4 hours—a 50 TB database export/import alone would exceed that. Option D doesn't fit in a 4-hour window for the initial database migration.

---

### Question 58

A company is migrating their on-premises Hadoop ecosystem (HDFS, Hive, Spark, HBase) to AWS. They want to modernize the architecture while migrating, moving away from managing infrastructure. Data in HDFS is 100 TB.

Which target architecture modernizes the Hadoop ecosystem with managed services?

A. Migrate everything to a self-managed Hadoop cluster on EC2.

B. HDFS → Amazon S3 (using DataSync or DistCp). Hive → Amazon Athena (serverless SQL on S3) or AWS Glue Data Catalog for metastore. Spark → Amazon EMR Serverless or AWS Glue for ETL. HBase → Amazon DynamoDB (for key-value/wide-column workloads). Use AWS Lake Formation for data governance.

C. Migrate everything to Amazon EMR with HDFS and maintain the same architecture.

D. Replace the entire ecosystem with Amazon Redshift.

**Correct Answer: B**

**Explanation:** Each Hadoop component maps to an optimized managed/serverless AWS service: S3 replaces HDFS with greater durability and decoupled storage, Athena/Glue replaces Hive metastore and queries, EMR Serverless/Glue replaces Spark with no cluster management, and DynamoDB replaces HBase with a managed wide-column store. Lake Formation adds governance. Option A maintains operational overhead. Option C keeps the same architecture without modernization. Option D is a data warehouse that doesn't replace all Hadoop ecosystem functions.

---

### Question 59

A company has a large monolithic .NET Framework application running on Windows Server 2012 R2. The application serves 10,000 concurrent users. They need to migrate to AWS but Windows Server 2012 R2 is end-of-life. The company wants to minimize application changes.

Which migration strategy addresses both migration and OS end-of-life?

A. Use AWS Application Migration Service to rehost the application on EC2 with Windows Server 2022. Test compatibility and address any issues from the OS upgrade.

B. Rewrite the application in .NET 6 for Linux containers on ECS.

C. Use AWS End-of-Support Migration Program (EMP) for Windows Server to create a compatibility package that allows the application to run on newer Windows Server versions on EC2 without code changes.

D. Keep the application on Windows Server 2012 R2 on EC2 with extended security updates.

**Correct Answer: C**

**Explanation:** AWS EMP for Windows Server packages the application with its dependencies and creates a runtime compatibility layer that allows it to run on newer Windows Server versions without code changes. This solves both the migration and the OS end-of-life problem simultaneously. Option A requires testing and potentially fixing compatibility issues with Windows Server 2022—risky for a monolith. Option B requires a complete rewrite. Option D uses an unsupported OS, creating security risks.

---

### Question 60

A company needs to migrate 50 TB of data from an on-premises Oracle data warehouse to Amazon Redshift. The data contains complex stored procedures, views, and custom functions. They need to convert Oracle-specific SQL to Redshift-compatible SQL and estimate the migration effort.

Which tool provides the BEST migration assessment and conversion?

A. Manually analyze each stored procedure and rewrite for Redshift.

B. AWS Schema Conversion Tool (SCT). Run SCT's assessment report on the Oracle data warehouse to get: (1) a migration complexity assessment, (2) percentage of code that can be auto-converted, (3) specific issues for manual resolution, (4) action items ranked by complexity. SCT then converts compatible schema objects, SQL scripts, and ETL code to Redshift equivalents.

C. Use AWS DMS to migrate both schema and data simultaneously.

D. Export Oracle DDL and modify syntax manually.

**Correct Answer: B**

**Explanation:** SCT's assessment report provides a comprehensive migration complexity analysis including auto-conversion percentages, specific issues, and effort estimation. It then performs the actual conversion for compatible objects. This is purpose-built for Oracle-to-Redshift migrations. Option A is extremely labor-intensive for complex warehouses. Option C—DMS migrates data, not stored procedures or complex SQL logic. Option D requires expertise in both Oracle and Redshift SQL.

---

### Question 61

A company has a legacy mainframe application that processes credit card transactions. The mainframe is at end-of-life, and the company needs to move the transaction processing capability to AWS. The COBOL programs contain 2 million lines of code and the team has limited COBOL expertise.

Which modernization approach is MOST feasible?

A. Manually rewrite all 2 million lines of COBOL in Java.

B. Use AWS Mainframe Modernization service with the automated refactoring pattern. The service uses code analysis to understand COBOL program logic and automatically converts COBOL to Java. Deploy the converted application on AWS managed runtime (Micro Focus or Blu Age). Gradually validate converted modules against mainframe output.

C. Use emulation to run the COBOL programs as-is on EC2 instances.

D. Hire a team of COBOL developers to maintain the mainframe on-premises.

**Correct Answer: B**

**Explanation:** AWS Mainframe Modernization's automated refactoring converts COBOL to Java using AI-assisted code transformation. The service manages the complexity of understanding legacy code patterns and generating equivalent modern code. Gradual validation ensures functional equivalence. Option A is impractical for 2 million lines without COBOL expertise. Option C (emulation) runs on AWS but doesn't modernize—same code, different hardware. Option D doesn't address the end-of-life mainframe.

---

### Question 62

A company needs to migrate their on-premises Elasticsearch cluster (5 nodes, 10 TB of data, 50,000 queries per minute) to AWS. They need near-zero downtime during migration and want a managed service.

Which migration approach ensures continuity?

A. Take a snapshot of the Elasticsearch cluster, upload to S3, and restore into a new Amazon OpenSearch domain. This requires downtime during the snapshot-restore cycle.

B. Create an Amazon OpenSearch Service domain. Configure the on-premises Elasticsearch cluster to replicate to OpenSearch using cross-cluster replication (if version compatible) or use Logstash with Elasticsearch input and OpenSearch output plugins to continuously replicate data. Once synchronized, switch the application to the OpenSearch endpoint.

C. Use AWS DMS to migrate Elasticsearch data.

D. Recreate all indexes in OpenSearch and re-ingest all source data from original sources.

**Correct Answer: B**

**Explanation:** Continuous replication using cross-cluster replication or Logstash keeps OpenSearch synchronized with the on-premises Elasticsearch in near real-time. The cutover is a simple endpoint switch with near-zero downtime. The application continues querying during the entire migration. Option A requires downtime during snapshot-restore. Option C—DMS doesn't support Elasticsearch as a source (only as a target). Option D requires access to all original data sources and lengthy re-ingestion.

---

### Question 63

A company has three AWS accounts: production, staging, and development. Each account runs EC2 instances, RDS databases, and Lambda functions. The monthly AWS bill is $300,000. The CFO wants a 25% cost reduction. A cost analysis shows: EC2 is 50% ($150K), RDS is 20% ($60K), Lambda is 10% ($30K), data transfer is 10% ($30K), and S3/other is 10% ($30K).

Which cost optimization plan achieves the 25% ($75K) reduction target?

A. Cut all environments by 25%.

B. EC2 optimization: Purchase Compute Savings Plans for steady-state production workloads (save ~$40K). Schedule dev/staging to run only during business hours (save ~$15K). Right-size instances using Compute Optimizer (save ~$10K). RDS optimization: Purchase RI for production databases (save ~$15K). Use Aurora Serverless v2 for dev/staging (save ~$5K). Total estimated savings: ~$85K (28%).

C. Migrate everything to Lambda to eliminate EC2 and RDS costs.

D. Move all workloads to a single account to reduce overhead.

**Correct Answer: B**

**Explanation:** A targeted optimization plan addressing the largest cost categories provides measurable savings: Savings Plans cover steady-state EC2 (~27% savings), scheduling eliminates dev/staging off-hours waste (~50% of their cost), right-sizing addresses over-provisioned instances, and RDS RIs reduce database costs. The combined savings of ~$85K exceed the $75K target. Option A would impact production performance. Option C is impractical—not all workloads suit Lambda. Option D doesn't reduce resource costs.

---

### Question 64

A company uses Amazon S3 for storing application logs, backups, and media files across 10 accounts. Total storage is 500 TB with monthly storage costs of $12,000. The company wants to reduce storage costs without impacting application performance.

Which analysis and optimization approach provides the MOST savings?

A. Delete all data older than 6 months.

B. Use S3 Storage Lens to analyze storage usage patterns, access frequency, and cost efficiency across all accounts. Based on the analysis: (1) enable S3 Intelligent-Tiering for media files with unpredictable access patterns, (2) create lifecycle rules to transition logs to S3 Glacier after 90 days, (3) transition backups to S3 Glacier Deep Archive after 30 days, (4) enable incomplete multipart upload cleanup, (5) remove expired object delete markers.

C. Move all data to S3 One Zone-IA.

D. Compress all files to reduce storage volume.

**Correct Answer: B**

**Explanation:** S3 Storage Lens provides organization-wide visibility into storage patterns, identifying optimization opportunities. Different data types get appropriate lifecycle policies: Intelligent-Tiering for unpredictable media access, Glacier for aging logs, Deep Archive for backups. Cleanup of incomplete uploads and expired delete markers eliminates waste. Option A risks deleting needed data. Option C reduces durability (one AZ) for all data. Option D only addresses file size, not storage class optimization.

---

### Question 65

A company is evaluating whether to use AWS Lambda or ECS Fargate for a new application. The application processes 10,000 requests per hour, each taking 30 seconds of compute time. The processing is CPU-intensive and uses 2 GB of memory.

Which compute option is MORE cost-effective for this workload, and why?

A. Lambda is always cheaper for serverless workloads.

B. Calculate the costs: Lambda: 10,000 requests × 30 seconds × 2 GB = 600,000 GB-seconds/hour. At $0.0000166667/GB-second = ~$10/hour = ~$7,200/month. Fargate: A task running continuously with 2 vCPU and 4 GB memory costs approximately $130/month per task. With 10,000 requests taking 30 seconds each = 83 concurrent requests average, needing ~10-15 tasks. Total: ~$1,300-$1,950/month. **Fargate is significantly cheaper** for this sustained, long-running workload.

C. ECS Fargate is always cheaper than Lambda.

D. The costs are approximately equal.

**Correct Answer: B**

**Explanation:** For sustained, long-duration compute workloads, Fargate's always-on pricing is cheaper than Lambda's per-invocation + per-GB-second pricing. Lambda is cost-effective for short-duration, sporadic workloads. At 10,000 requests/hour × 30 seconds each, the total compute time is substantial enough that dedicated Fargate tasks are more economical. The break-even point varies, but generally, Lambda becomes expensive for high-volume, long-duration processing.

---

### Question 66

A company has 50 TB of data in Amazon S3 Standard across multiple buckets. Access pattern analysis shows that 60% of the data hasn't been accessed in the past 6 months but the company doesn't know which specific objects will be needed. When data is needed, it must be available within milliseconds.

Which storage optimization provides cost savings while meeting the access requirement?

A. Transition all data to S3 Glacier Instant Retrieval.

B. Enable S3 Intelligent-Tiering on all buckets. The Frequent Access tier provides millisecond access for recently accessed data, while Infrequent Access and Archive Instant Access tiers provide millisecond access at lower costs for data not recently accessed. No retrieval fees are charged when accessing data in any tier.

C. Create lifecycle rules to transition data to S3 Standard-IA after 30 days.

D. Move all data to S3 One Zone-IA for reduced costs.

**Correct Answer: B**

**Explanation:** S3 Intelligent-Tiering is ideal when access patterns are unpredictable ("company doesn't know which specific objects will be needed"). All tiers provide millisecond access with no retrieval fees. Data automatically moves between Frequent, Infrequent, and Archive Instant Access tiers based on actual access. Option A moves all data to Glacier Instant Retrieval regardless of whether it's frequently accessed, incurring retrieval fees. Option C (Standard-IA) charges retrieval fees and has minimum storage duration charges. Option D reduces durability.

---

### Question 67

A company runs a production workload on 50 m5.xlarge On-Demand instances that must run 24/7. They have 30 additional m5.xlarge instances for development that run during business hours only (10 hours/day, 5 days/week). What is the optimal purchasing strategy?

A. Purchase Reserved Instances for all 80 instances.

B. For the 50 production instances: purchase a 1-year Compute Savings Plan commitment for the equivalent of 50 m5.xlarge (provides ~40% savings with flexibility to change instance types). For the 30 development instances: use Instance Scheduler to run only during business hours, and use the remaining Savings Plan benefit during development hours (since the plan covers any EC2 usage up to the commitment). Any development usage beyond the plan coverage uses On-Demand pricing.

C. Use all Spot Instances for maximum savings.

D. Use On-Demand for everything—the overhead of managing RIs and plans isn't worth the savings.

**Correct Answer: B**

**Explanation:** Compute Savings Plan for the 50 production instances provides ~40% savings with flexibility. Instance Scheduler reduces development costs by ~71% (running only 50 hours/week instead of 168). The Savings Plan can apply to development hours automatically if production hasn't consumed the full commitment. This combination maximizes savings across both workload types. Option A over-commits on development instances that don't run 24/7. Option C is too risky for production. Option D leaves significant savings on the table (~$200K+ annually at this scale).

---

### Question 68

A company runs a data pipeline that processes 1 TB of data nightly using an EMR cluster. The cluster runs for 4 hours and uses 20 m5.2xlarge instances. The total cost is $15,000/month. The processing is fault-tolerant and can handle node failures.

Which changes MOST reduce EMR costs?

A. Use a combination of On-Demand instances for the master node and core nodes (minimum needed for HDFS), and Spot Instances for task nodes (processing-only). Additionally, use instance fleets with multiple instance types to increase Spot availability. Use Graviton instances (m6g) for additional price-performance improvement.

B. Increase the number of instances to process data faster and reduce the cluster running time.

C. Switch to a persistent EMR cluster that runs 24/7.

D. Use Reserved Instances for the EMR cluster.

**Correct Answer: A**

**Explanation:** Task nodes (processing-only) are ideal for Spot Instances since they don't store HDFS data—Spot interruptions don't cause data loss. Instance fleets with multiple instance types improve Spot availability. Graviton instances offer 20% better price-performance. Master and minimal core nodes on On-Demand ensure cluster stability. Potential savings: 60-80% on task node compute. Option B may increase cost if parallelism doesn't reduce overall compute hours. Option C wastes 20 hours/day of idle compute. Option D over-commits for a 4-hour nightly workload.

---

### Question 69

A company's AWS environment generates $500,000/month in costs. The finance team wants to implement cost governance with automated controls that prevent budget overruns. Different departments should have individual budgets, and exceeding 80% of budget should trigger notifications while exceeding 100% should restrict new resource creation.

Which governance framework provides automated budget enforcement?

A. Use AWS Budgets with budget actions. Create budgets for each department account. Configure budget actions to: at 80% budget, send SNS notifications to department leads and finance. At 100% budget, apply an SCP that denies resource creation actions (ec2:RunInstances, rds:CreateDBInstance, etc.) to the department's OU.

B. Monitor costs manually in Cost Explorer and send emails when budgets are exceeded.

C. Set billing alerts in CloudWatch and hope departments comply with spending limits.

D. Use AWS Organizations consolidated billing to track costs.

**Correct Answer: A**

**Explanation:** AWS Budgets with budget actions provides automated enforcement: notifications at 80% threshold and automatic SCP application at 100% to prevent new resource creation. SCPs applied to department OUs ensure no one in the department can launch new resources once the budget is exceeded. Option B is manual and reactive. Option C lacks enforcement. Option D provides visibility but no enforcement.

---

### Question 70

A company has multiple workloads with different availability requirements: Tier 1 (99.99% - critical financial trading), Tier 2 (99.9% - customer-facing web app), and Tier 3 (99% - internal batch processing). Currently, all tiers use the same Multi-AZ architecture, resulting in over-spending on lower-tier workloads.

How should infrastructure be right-sized by availability tier?

A. Use the same architecture for all tiers for simplicity.

B. Tier 1: Multi-Region active-active with Aurora Global Database, Auto Scaling across 3+ AZs, Route 53 health checks with failover. Tier 2: Single Region Multi-AZ with Aurora Multi-AZ, Auto Scaling across 2 AZs, ALB health checks. Tier 3: Single AZ deployment with automated recovery (Auto Scaling minimum 1), regular backups, higher RTO/RPO tolerance.

C. Use Spot Instances for all tiers based on cost savings.

D. Deploy all workloads in a single AZ and use backups for recovery.

**Correct Answer: B**

**Explanation:** Matching infrastructure to availability requirements prevents over-spending. Tier 1 needs multi-Region for 99.99%. Tier 2 needs Multi-AZ for 99.9%. Tier 3 can use single-AZ with backup/recovery for 99%—significantly cheaper than Multi-AZ. Each tier's architecture matches its SLA, optimizing cost-to-availability. Option A over-provisions Tier 3. Option C risks availability for all tiers. Option D under-provisions Tier 1 and 2.

---

### Question 71

A company uses AWS Lambda extensively. Their Lambda bill shows that $5,000/month is spent on Lambda@Edge functions for a CloudFront distribution. The functions perform simple URL rewriting and header manipulation. The functions execute 100 million times per month with an average duration of 5ms.

Which optimization reduces the Lambda@Edge costs?

A. Increase the function memory for faster execution.

B. Migrate from Lambda@Edge to CloudFront Functions for simple URL rewriting and header manipulation. CloudFront Functions run at a fraction of Lambda@Edge cost (~1/6th the price), support up to 10 million requests per second, and execute in sub-millisecond time. They're designed specifically for lightweight HTTP transformations.

C. Reduce the CloudFront cache TTL to reduce the number of function invocations.

D. Move the URL rewriting logic to the origin server.

**Correct Answer: B**

**Explanation:** CloudFront Functions cost ~$0.10 per million invocations vs Lambda@Edge at ~$0.60 per million. For 100 million monthly invocations doing simple HTTP manipulations, CloudFront Functions reduce costs by approximately 83% (~$4,150 savings). They're purpose-built for lightweight request/response transformations. Option A doesn't address pricing—Lambda@Edge costs are per-invocation and duration. Option C reduces functionality. Option D adds load to the origin.

---

### Question 72

A company uses Amazon DynamoDB with provisioned capacity mode for their production table. The table has a predictable daily pattern: 10,000 RCU/5,000 WCU during business hours and 1,000 RCU/500 WCU at night. They currently provision for peak capacity 24/7.

Which approach optimizes DynamoDB costs for this pattern?

A. Switch to on-demand capacity mode.

B. Use DynamoDB Auto Scaling with minimum capacity matching off-peak (1,000 RCU/500 WCU) and maximum capacity matching peak (10,000 RCU/5,000 WCU). Purchase DynamoDB Reserved Capacity for the baseline (1,000 RCU/500 WCU). Auto Scaling adjusts between min and max based on utilization.

C. Use Application Auto Scaling with scheduled scaling actions that increase capacity at 8 AM and decrease at 6 PM.

D. Provision peak capacity 24/7 with Reserved Capacity for the full peak.

**Correct Answer: B**

**Explanation:** Reserved Capacity for the 24/7 baseline (1,000 RCU/500 WCU) provides the deepest discount (~53% savings on that portion). Auto Scaling handles the dynamic range between baseline and peak, paying on-demand rates only during scale-up periods. This combines commitment savings with elasticity. Option A (on-demand) costs more for predictable patterns. Option C (scheduled scaling) works but doesn't adapt to actual usage within the day. Option D wastes money provisioning peak capacity during off-peak hours.

---

### Question 73

A company operates a multi-Region application and notices that inter-Region data transfer charges are $20,000/month. Analysis shows most of the transfer is database replication between Regions and API calls between microservices deployed across Regions.

Which strategies reduce inter-Region data transfer costs? (Choose TWO.)

A. Implement application-level data compression for inter-service API calls to reduce the payload size transferred between Regions.

B. Use Amazon CloudFront to cache frequently accessed API responses at edge locations, reducing repeated cross-Region API calls.

C. Move all services to a single Region.

D. Use AWS Direct Connect for inter-Region transfers.

E. Increase the database replication batch size to reduce the number of individual transfer operations.

**Correct Answer: A, B**

**Explanation:** Data compression (A) reduces the bytes transferred between Regions for API calls—even 50% compression halves the data transfer cost for those calls. CloudFront caching (B) serves repeated API responses from edge caches, eliminating redundant cross-Region requests. Option C sacrifices multi-Region availability. Option D doesn't reduce inter-Region transfer costs—Direct Connect pricing doesn't apply to inter-Region traffic within AWS. Option E may slightly reduce TCP overhead but doesn't significantly reduce data volume.

---

### Question 74

A company runs a SaaS application with 100 customers. Each customer's environment includes an EC2 instance, an RDS database, and an S3 bucket. Some customers rarely use their environment but the resources remain provisioned. The company wants to implement a "hibernation" strategy for inactive customer environments.

Which approach minimizes costs for inactive environments while enabling quick reactivation?

A. Terminate all resources for inactive customers and reprovision when needed.

B. For inactive environments: stop the EC2 instance (eliminates compute charges, retains EBS volume). Stop the RDS instance (eliminates compute charges, retains storage) with a maximum of 7-day auto-stop. Implement a reactivation Lambda that starts EC2 and RDS when the customer logs in. S3 storage continues with Intelligent-Tiering for automatic cost optimization.

C. Scale down EC2 to t3.nano and RDS to db.t3.micro.

D. Move all inactive customer data to Glacier and delete the compute resources.

**Correct Answer: B**

**Explanation:** Stopping EC2 eliminates compute charges while preserving the EBS volume (much cheaper). Stopping RDS eliminates database compute charges while retaining data. Automatic reactivation via Lambda ensures quick restart when customers return. S3 Intelligent-Tiering optimizes storage for idle data. Option A requires full reprovisioning which takes time. Option C still incurs compute costs. Option D requires lengthy data retrieval from Glacier for reactivation.

---

### Question 75

A company is reviewing their AWS bill and finds significant charges for Elastic IP addresses. They have 200 Elastic IPs allocated, but only 80 are attached to running instances. The remaining 120 are either attached to stopped instances or not attached at all.

What is the cost impact and recommended action?

A. Elastic IPs are free regardless of usage.

B. AWS charges for Elastic IPs that are not associated with a running instance. At approximately $3.65/month per unused EIP (since Feb 2024, AWS also charges for EIPs in use at $0.005/hour), 120 unused EIPs cost approximately $438/month. Release all unattached EIPs. For stopped instances, release the EIP and allocate a new one when the instance is restarted (automate with Lambda triggered by instance state changes).

C. Attach all EIPs to running instances to avoid charges.

D. Convert Elastic IPs to public IPv4 addresses to avoid charges.

**Correct Answer: B**

**Explanation:** Since February 2024, AWS charges $0.005/hour for ALL public IPv4 addresses including in-use EIPs, but unused EIPs cost the same rate without providing value. Releasing 120 unused EIPs saves ~$438/month. Automating EIP allocation/release on instance start/stop prevents waste while maintaining functionality. Option A is incorrect—EIPs cost money (especially since the 2024 pricing change). Option C requires running instances for each EIP which costs more. Option D—public IPv4 addresses also incur the same charge.

---

## End of Practice Test 3

**Scoring Guide:**
- Each question is worth 1 point
- Total possible score: 75
- Approximate passing score: 54/75 (72%)
- Domain 1 (Q1-20): ___/20
- Domain 2 (Q21-42): ___/22
- Domain 3 (Q43-53): ___/11
- Domain 4 (Q54-62): ___/9
- Domain 5 (Q63-75): ___/13
