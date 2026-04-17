# AWS Certified Solutions Architect - Professional (SAP-C02) Practice Test 21

## Topic Focus: Organizations, Account Factory, SCP Inheritance, Delegated Admin, RAM, VPC Sharing

**Time Limit: 180 minutes**
**Passing Score: 75%**
**Total Questions: 75**

---

### Question 1
A global enterprise operates 350+ AWS accounts under AWS Organizations with a multi-OU hierarchy. The security team needs to prevent any account from launching EC2 instances in regions outside of us-east-1, eu-west-1, and ap-southeast-1, while still allowing the management account to operate in all regions for billing and support purposes. The organization uses nested OUs where a "Production" OU contains sub-OUs for each business unit. A new business unit OU was recently created under Production, but its accounts can still launch instances in restricted regions.

What is the MOST likely cause and the recommended fix?

A) SCPs are not inherited by newly created OUs. Attach the region-restriction SCP directly to the new business unit OU.
B) The SCP uses a Deny policy with a condition on aws:RequestedRegion, but the management account is exempt from SCPs, and the new OU inherited a conflicting Allow policy from a parent OU that overrides the Deny.
C) SCPs use an implicit deny model. The new OU needs an explicit Allow SCP for the three permitted regions, but the FullAWSAccess SCP attached at the root is overriding the restriction.
D) The region-restriction SCP is attached to the Production OU but uses NotAction with specific services. The new OU's accounts are using a service not listed in the NotAction element, bypassing the restriction.
E) SCPs attached to the root OU do not automatically propagate to newly created OUs. Reattach the SCP to the root to trigger propagation.

**Correct Answer: D**

**Explanation:** SCPs DO inherit down through the OU hierarchy, so options A and E are incorrect. The management account is indeed exempt from SCPs, but this doesn't explain why accounts in the new OU can bypass restrictions (B is partially correct but doesn't address the root cause for member accounts). SCPs work on an intersection model — an action must be allowed at every level. However, the most likely cause is that the Deny SCP uses NotAction to exclude certain global services (like IAM, STS, Support), and accounts in the new OU are using a service not captured in the NotAction list. This is a common pitfall with region-restriction SCPs where the NotAction list must be comprehensive. The fix is to update the SCP's NotAction element to include all global and region-agnostic services.

---

### Question 2
A company is migrating from a single AWS account to a multi-account strategy using AWS Control Tower. They need to provision new accounts for 50 development teams, each requiring a standardized VPC, IAM roles, and security configurations. The company wants to allow teams to customize certain parameters (CIDR ranges, environment tags) while enforcing mandatory security controls. Account provisioning must integrate with the company's ServiceNow ITSM for approval workflows.

Which approach provides the MOST scalable and compliant solution?

A) Use AWS Control Tower Account Factory with custom blueprints backed by AWS Service Catalog products. Integrate ServiceNow with the Service Catalog using the AWS Service Management Connector for approval workflows before account provisioning.
B) Create a custom Lambda function triggered by ServiceNow webhooks that calls the AWS Organizations CreateAccount API, then uses CloudFormation StackSets to deploy baseline resources across new accounts.
C) Use AWS Control Tower Account Factory for Terraform (AFT) with a GitOps pipeline. Integrate ServiceNow approvals into the Git pull request process before Terraform applies account customizations.
D) Deploy accounts manually through the AWS Control Tower console, then use AWS Config conformance packs to remediate non-compliant configurations. Use ServiceNow email notifications for manual approval tracking.

**Correct Answer: A**

**Explanation:** AWS Control Tower Account Factory with custom blueprints (backed by Service Catalog) is the most scalable approach for standardized account provisioning. Custom blueprints allow teams to select parameters (CIDR, tags) while enforcing mandatory configurations. The AWS Service Management Connector for ServiceNow provides native integration between ServiceNow ITSM workflows and AWS Service Catalog, enabling approval processes before account provisioning. Option B works but bypasses Control Tower governance guardrails. Option C (AFT) is valid for Terraform-centric organizations but adds complexity with Git-based ServiceNow integration. Option D is not scalable for 50 teams and relies on reactive remediation.

---

### Question 3
An organization uses AWS RAM to share subnets from a central networking account with multiple workload accounts across three OUs. A new compliance requirement mandates that only accounts within the "Production" OU can access the shared production subnets, while "Development" OU accounts should only see development subnets. Currently, RAM shares are configured at the organization level. A solutions architect needs to implement this segregation without restructuring the OU hierarchy.

What is the MOST operationally efficient approach?

A) Create two separate RAM resource shares — one for production subnets shared with the Production OU, and another for development subnets shared with the Development OU. Remove the organization-level share.
B) Use SCP policies on each OU to deny ec2:CreateNetworkInterface actions on subnets tagged as belonging to the wrong environment.
C) Implement AWS RAM permission sets with custom conditions that evaluate the requesting account's OU membership using aws:PrincipalOrgPaths.
D) Deploy VPC peering connections instead of RAM sharing, using route table configurations to control which accounts can route to which subnets.

**Correct Answer: A**

**Explanation:** AWS RAM supports sharing resources with specific OUs within an organization. Creating two separate RAM resource shares — one targeting the Production OU with production subnets and another targeting the Development OU with development subnets — provides clean segregation. This is the most operationally efficient approach as it leverages built-in RAM capabilities. Option B adds complexity with SCPs and doesn't prevent subnet visibility. Option C describes a feature that doesn't exist in RAM's current permission model. Option D replaces the shared VPC model entirely, adding significant networking complexity and cost.

---

### Question 4
A financial services company has implemented SCPs across their AWS Organizations hierarchy. The security team discovers that an SCP attached to the "Sandbox" OU denies all S3 actions, but a developer in a sandbox account can still list S3 buckets. The OU hierarchy is: Root → Workloads → Sandbox. The Root has FullAWSAccess attached. The Workloads OU has a custom SCP that allows S3 read actions. The Sandbox OU has an SCP that denies all S3 actions.

What explains this behavior?

A) The FullAWSAccess SCP at the Root overrides the Deny SCP at the Sandbox OU level because Root-level policies take precedence.
B) The developer's IAM policy includes an explicit Allow for s3:ListBuckets with a condition that bypasses the SCP.
C) The Deny SCP on the Sandbox OU has a condition key that is not being met, so the Deny statement is not being evaluated.
D) SCPs cannot deny actions that are explicitly allowed by an SCP at a higher level in the hierarchy.
E) The Workloads OU Allow SCP overrides the Sandbox OU Deny SCP because Allow policies at parent OUs take precedence over Deny policies at child OUs.

**Correct Answer: C**

**Explanation:** In the SCP evaluation logic, an explicit Deny always overrides any Allow. SCPs at the Root do NOT override child OU Deny policies (A is wrong). IAM policies cannot bypass SCPs (B is wrong). SCPs follow an intersection model where Allow must exist at every level AND no Deny exists at any level — a Deny at any level blocks the action (D and E are wrong). The only logical explanation is that the Deny SCP has a condition that isn't being triggered. Common examples include conditions like aws:RequestedRegion, StringNotEquals on specific resources, or time-based conditions. The security team should review the SCP's condition block to identify why the Deny isn't applying.

---

### Question 5
A healthcare company needs to share Amazon Aurora MySQL databases across accounts in their AWS Organization for a reporting solution. The databases contain PHI (Protected Health Information) and must remain encrypted with customer-managed KMS keys. The reporting accounts need read-only access to specific database clusters. Cross-account access must be auditable, and the sharing mechanism must not require database credentials to be stored in the reporting accounts.

Which solution BEST meets these requirements?

A) Use AWS RAM to share Aurora DB clusters with the reporting accounts. Configure IAM database authentication for the Aurora clusters. Use AWS CloudTrail to audit cross-account access.
B) Create Aurora cross-region read replicas in the reporting accounts. Share the KMS key using a key policy that grants the reporting accounts decrypt permissions. Use database-native audit logging.
C) Set up Aurora clones in the reporting accounts using cross-account snapshot sharing. Re-encrypt snapshots with a KMS key accessible to reporting accounts. Configure RDS event notifications for audit purposes.
D) Use AWS RAM to share Aurora DB clusters. Configure the reporting accounts with IAM roles that assume a role in the database account to connect via RDS Proxy with IAM authentication. Enable RDS audit logging and CloudTrail data events.

**Correct Answer: D**

**Explanation:** This solution provides the most comprehensive approach. AWS RAM supports sharing Aurora DB clusters across accounts. RDS Proxy with IAM authentication eliminates the need for database credentials in reporting accounts. Cross-account role assumption provides controlled access while maintaining auditability through CloudTrail. RDS audit logging captures database-level access. Option A is close but lacks the RDS Proxy layer for connection management. Option B creates full replicas which increases costs and data surface area for PHI. Option C uses snapshots which create point-in-time copies rather than live read access, and introduces data duplication concerns for PHI.

---

### Question 6
An enterprise is implementing a multi-account landing zone using AWS Control Tower. They need to enforce that all new accounts have AWS CloudTrail enabled with logs sent to a centralized logging account, AWS Config enabled with a centralized aggregator, and VPC flow logs enabled for all VPCs. The company has 12 custom guardrails beyond the Control Tower defaults. They also need to support account customization post-provisioning for specific business units that require additional services like Amazon SageMaker or Amazon Redshift.

What combination of services provides the MOST comprehensive solution?

A) AWS Control Tower with mandatory guardrails for CloudTrail and Config, custom SCPs for additional guardrails, Account Factory customization blueprints for post-provisioning, and CloudFormation StackSets for VPC flow log enforcement.
B) AWS Control Tower with all default guardrails, AWS Config organizational rules for the 12 custom controls, Account Factory for Terraform (AFT) for account customizations, and a Lambda-backed custom resource for VPC flow log automation.
C) AWS Landing Zone Solution (legacy) with custom CloudFormation templates for all configurations, Step Functions for orchestration, and SNS notifications for compliance monitoring.
D) AWS Control Tower with proactive controls implemented as CloudFormation Guard rules, detective controls as AWS Config rules, Account Factory custom blueprints backed by Service Catalog products for business unit customization, and lifecycle events triggering Lambda functions for VPC flow log setup.

**Correct Answer: D**

**Explanation:** This solution leverages the full spectrum of Control Tower capabilities. Proactive controls (CloudFormation Guard rules) prevent non-compliant resources before deployment. Detective controls (Config rules) identify existing non-compliance. Account Factory custom blueprints backed by Service Catalog enable standardized yet customizable account provisioning for different business units. Lifecycle events triggering Lambda for VPC flow logs provide automated post-provisioning configuration. Option A mixes StackSets manually which is less integrated. Option B uses AFT which adds Terraform complexity. Option C uses the legacy Landing Zone Solution which is superseded by Control Tower.

---

### Question 7
A company's networking team manages a shared VPC in a central networking account. The VPC has subnets shared via AWS RAM to 30 workload accounts across two OUs. A security audit reveals that workload accounts can create security groups in the shared VPC that allow inbound traffic from 0.0.0.0/0. The networking team needs to prevent this while still allowing workload accounts to create security groups with restricted CIDR ranges.

Which approach provides the MOST effective control?

A) Implement an SCP that denies ec2:AuthorizeSecurityGroupIngress when the condition aws:SourceIp includes 0.0.0.0/0.
B) Use AWS Network Firewall in the shared VPC to inspect and block traffic regardless of security group rules.
C) Implement an SCP that denies ec2:AuthorizeSecurityGroupIngress and ec2:CreateSecurityGroup with a condition on ec2:Vpc matching the shared VPC ID when the CIDR block is 0.0.0.0/0, using the StringEquals condition with the ipPermission/cidr condition key.
D) Create AWS Config rules with auto-remediation that detect and remove security group rules allowing 0.0.0.0/0 within 60 seconds of creation.
E) Remove security group creation permissions from workload accounts and have the networking team create all security groups centrally, sharing them via RAM.

**Correct Answer: C**

**Explanation:** An SCP with conditions on the VPC ID and CIDR range provides preventive control. The ec2:AuthorizeSecurityGroupIngress action supports condition keys for evaluating the CIDR in the ingress rule. By combining the VPC condition (to scope it to the shared VPC only) with the CIDR condition (to block 0.0.0.0/0), workload accounts can still create security groups with restricted CIDRs. Option A incorrectly uses aws:SourceIp which refers to the caller's IP, not the security group rule CIDR. Option B doesn't prevent the misconfiguration, only mitigates traffic impact. Option D is detective/reactive, not preventive. Option E eliminates team autonomy and creates an operational bottleneck.

---

### Question 8
An organization with 500+ AWS accounts needs to delegate AWS security hub administration to a dedicated security account while keeping the management account lightweight. They also need to delegate Amazon GuardDuty, AWS Config aggregation, and AWS Firewall Manager to the same security account. The solution must automatically enroll new accounts as they are created through Control Tower.

Which architecture BEST achieves this?

A) Designate the security account as delegated administrator for Security Hub, GuardDuty, Config, and Firewall Manager through the Organizations console. Use Control Tower lifecycle events to trigger a Lambda function that enrolls new accounts into each service.
B) Use the management account for all security services since delegated administration is limited to one service per account. Create cross-account IAM roles for the security team to access findings.
C) Deploy separate delegated administrator accounts for each security service to maintain separation of duties. Use EventBridge rules to coordinate findings across accounts.
D) Configure the security account as delegated administrator only for Security Hub, as Security Hub can aggregate findings from GuardDuty, Config, and Firewall Manager automatically without separate delegated admin setup.

**Correct Answer: A**

**Explanation:** A single account can serve as delegated administrator for multiple AWS services including Security Hub, GuardDuty, AWS Config, and Firewall Manager. Designating the security account as delegated admin for all these services centralizes security operations. Control Tower lifecycle events (specifically CreateManagedAccount) can trigger Lambda functions to automatically enroll new accounts into each service. Option B is incorrect — delegated admin is not limited to one service per account. Option C unnecessarily fragments security operations across multiple accounts. Option D is incorrect — while Security Hub aggregates findings, each service still needs its own delegated admin setup for full management capabilities (like enabling/disabling detectors, managing rules).

---

### Question 9
A multinational corporation uses AWS Organizations with an OU structure aligned to geographic regions (Americas, EMEA, APAC). Each region has sub-OUs for Production, Staging, and Development. The company needs to implement data sovereignty controls ensuring that accounts in the EMEA OU can only create resources in eu-west-1 and eu-central-1, while APAC accounts are restricted to ap-southeast-1 and ap-northeast-1. Global services (IAM, CloudFront, Route 53) must remain accessible. The solution must accommodate future region additions without modifying every SCP.

What is the MOST maintainable approach?

A) Create a separate region-restriction SCP for each geographic OU using aws:RequestedRegion with StringNotEquals and a Deny effect. Use NotAction to exclude global services. Attach each SCP to the corresponding geographic OU.
B) Create a single SCP with multiple statements, each using conditions on aws:PrincipalOrgPaths to match the OU path and aws:RequestedRegion for the allowed regions. Attach this SCP to the Root OU.
C) Use AWS Control Tower Region deny control at the OU level, configuring the governed regions for each geographic OU. Enable global service exceptions in the Control Tower settings.
D) Implement IAM permission boundaries in each account that restrict resource creation to specific regions based on account tags, deployed via CloudFormation StackSets targeted to each OU.

**Correct Answer: A**

**Explanation:** Creating separate region-restriction SCPs per geographic OU is the most maintainable approach. Each SCP uses a Deny effect with StringNotEquals on aws:RequestedRegion and NotAction to exclude global services (IAM, STS, CloudFront, Route 53, Support, etc.). When a new region needs to be added, only the relevant geographic OU's SCP needs modification. Option B puts all logic in one SCP which becomes complex and harder to maintain. Option C (Control Tower Region deny) works but is less flexible for per-OU customization and may conflict with custom SCPs. Option D uses IAM permission boundaries which are per-account and harder to enforce centrally — they also require updating in every account when changes are needed.

---

### Question 10
A company recently adopted AWS Organizations and needs to consolidate billing while maintaining operational independence for each business unit. Each business unit has existing AWS accounts with running workloads. The company wants to migrate these accounts into the organization without disrupting workloads. Some accounts have AWS Marketplace subscriptions and Reserved Instances. The company needs to ensure RI sharing benefits are maximized across the organization while allowing business units to track their own costs.

What is the recommended migration approach?

A) Create new accounts within the organization using Account Factory, then migrate workloads from existing accounts to new accounts using AWS Application Migration Service. Cancel existing RIs and repurchase them in the management account.
B) Send invitations from the management account to existing accounts. After accounts join, enable RI sharing at the organization level. Use cost allocation tags and linked account billing to track per-business-unit costs. Verify Marketplace subscriptions transfer correctly.
C) Use the Organizations MoveAccount API to move accounts between organizations. Enable consolidated billing and RI sharing. Create separate billing groups using AWS Billing Conductor for each business unit.
D) Create the organization structure first, then use AWS Control Tower to enroll existing accounts. This automatically handles RI consolidation, Marketplace subscriptions, and creates cost allocation views.

**Correct Answer: B**

**Explanation:** The correct approach is to invite existing accounts to join the organization. This preserves running workloads, existing configurations, and account history. RI sharing should be enabled at the organization level to maximize cross-account benefits. Cost allocation tags and linked account billing allow per-business-unit cost tracking. Marketplace subscriptions generally transfer with the account, but should be verified. Option A is disruptive and unnecessarily migrates workloads. Option C's MoveAccount API requires the account to leave its current organization first (if any). Option D — Control Tower enrollment of existing accounts is possible but doesn't automatically handle all the listed items, and the question specifically asks about the migration approach, not governance.

---

### Question 11
A solutions architect needs to design a VPC sharing strategy for an organization with 100 accounts. The central networking account owns VPCs in three regions. Requirements include: application teams must deploy resources in shared subnets but cannot modify route tables or NACLs, DNS resolution must work across all shared VPCs, and there must be network isolation between production and non-production workloads within the same region.

Which design BEST meets these requirements?

A) Share all subnets via RAM at the organization level. Use security groups for isolation between production and non-production. Configure Route 53 Private Hosted Zones associated with each shared VPC.
B) Create separate VPCs for production and non-production in each region. Share production subnets only with the Production OU and non-production subnets only with the Non-Production OU via RAM. Use Route 53 Resolver rules for cross-VPC DNS resolution.
C) Use a single VPC per region with separate subnet tiers (production, non-production). Share specific subnets via RAM to appropriate OUs. Use NACLs managed by the networking account for isolation. Associate a Route 53 Private Hosted Zone with the VPC and share the zone using RAM.
D) Deploy Transit Gateway in each region and use TGW route tables for isolation between production and non-production. Share TGW via RAM to all accounts. Each account creates its own VPC and attaches to the TGW.

**Correct Answer: B**

**Explanation:** Separate VPCs for production and non-production provide the strongest network isolation. Sharing production subnets with the Production OU and non-production subnets with the Non-Production OU via RAM enforces isolation at the sharing level. Route 53 Resolver rules enable cross-VPC DNS resolution (for cases where services need to resolve names across environments). In shared VPCs, participant accounts cannot modify route tables or NACLs by default — only the VPC owner can. Option A lacks production/non-production isolation. Option C uses a single VPC which provides weaker isolation (NACLs alone are insufficient for compliance). Option D gives each account its own VPC, which contradicts the shared VPC model and increases management overhead.

---

### Question 12
An enterprise uses AWS Organizations with multiple SCPs to enforce security. They discover that after attaching a new SCP that denies iam:CreateUser to the Production OU, their CI/CD pipeline running in a production account can no longer create IAM roles (iam:CreateRole) either, even though only CreateUser was denied. The pipeline previously worked correctly.

What is the MOST likely root cause?

A) The new SCP has a wildcard in the Action field (iam:Create*) instead of specifically iam:CreateUser, causing it to also deny iam:CreateRole.
B) The SCP evaluation reduced the effective permissions. Another SCP at a higher level only allows specific IAM actions, and the combination of Allow SCPs and the new Deny SCP resulted in CreateRole being implicitly denied.
C) Attaching any new SCP to an OU causes all other SCPs to be re-evaluated, and a previously unnoticed conflict now surfaces.
D) The CI/CD pipeline's IAM role has a trust policy that references the management account, and SCPs prevent cross-account role assumptions in Production OU accounts.

**Correct Answer: A**

**Explanation:** The most likely cause is a wildcard in the SCP's Action field. If the SCP uses iam:Create* instead of iam:CreateUser, it will deny all IAM Create actions including CreateRole, CreatePolicy, CreateInstanceProfile, etc. This is a common mistake in SCP authoring. Option B describes a valid SCP evaluation scenario but is less likely than a simple typo/wildcard issue. Option C is incorrect — SCP evaluation doesn't change when new SCPs are attached; each API call evaluates all applicable SCPs. Option D is unrelated to the described symptoms. The fix is to update the SCP to specifically deny only iam:CreateUser.

---

### Question 13
A company uses AWS RAM to share a transit gateway from a networking account with 50 workload accounts. They need to implement a policy where only specific accounts can create VPC attachments to the transit gateway, and all attachment requests must be approved by the networking team. Currently, any account with the RAM share can create attachments immediately.

How should the solutions architect implement this approval workflow?

A) Remove the RAM share and instead create a custom API Gateway backed by Lambda that accepts attachment requests, stores them in DynamoDB for approval, and uses the networking account's credentials to create approved attachments.
B) Use RAM to share the transit gateway with auto-accept disabled. When participant accounts request attachments, the networking account receives a pending acceptance request. Implement a Step Functions workflow triggered by EventBridge that routes approvals to the networking team via SNS notifications.
C) Modify the RAM resource share to include a managed permission that requires multi-party approval. Configure RAM to send approval requests to the networking team's email distribution list.
D) Use SCPs to deny ec2:CreateTransitGatewayVpcAttachment for all workload accounts. When an attachment is needed, temporarily remove the SCP, create the attachment, and reattach the SCP.

**Correct Answer: B**

**Explanation:** Transit Gateway attachments shared via RAM support an approval workflow through the auto-accept feature. When auto-accept is disabled, attachment requests from participant accounts remain in a "pending acceptance" state until the transit gateway owner (networking account) accepts them. Using EventBridge to detect pending attachment events, a Step Functions workflow can orchestrate the approval process — notifying the networking team, tracking approval status, and automatically accepting or rejecting based on the team's decision. Option A is overly complex and reinvents built-in functionality. Option C describes a feature that doesn't exist in RAM. Option D is operationally risky and not scalable.

---

### Question 14
A large enterprise is implementing AWS Control Tower in an existing organization with 200 accounts. Many accounts have existing configurations that conflict with Control Tower guardrails (non-compliant S3 buckets, unencrypted EBS volumes, public security groups). The enterprise wants to enroll these accounts into Control Tower without disrupting existing workloads but needs a remediation strategy for non-compliant resources.

What is the recommended enrollment and remediation approach?

A) Enroll all accounts at once using the RegisterOrganizationalUnit API. Control Tower will automatically remediate all non-compliant resources during enrollment.
B) Enroll accounts in batches starting with the least critical ones. Use Control Tower's drift detection to identify non-compliant resources. Deploy AWS Config auto-remediation rules targeting specific non-compliance types. Use Systems Manager Automation documents for complex remediation tasks.
C) Create new compliant accounts in Control Tower and migrate all workloads from existing accounts using AWS Migration Hub. Decommission old accounts after migration.
D) Enroll all accounts but set all guardrails to "detective" mode initially. After identifying all non-compliant resources across the organization, switch guardrails to "preventive" mode and manually fix each non-compliant resource.

**Correct Answer: B**

**Explanation:** Enrolling accounts in batches (starting with least critical) minimizes risk to production workloads. Control Tower enrollment doesn't automatically remediate existing non-compliant resources (A is wrong) — it identifies them as drift. AWS Config auto-remediation rules provide automated, scalable remediation for common non-compliance patterns (unencrypted volumes, public security groups). Systems Manager Automation documents handle complex remediation requiring multi-step actions. Option C is extremely disruptive. Option D's approach of flipping all guardrails at once after enrollment could cause widespread disruption, and not all guardrails have both detective and preventive modes.

---

### Question 15
A company operates a shared services account that provides centralized logging, monitoring, and security scanning services. These services need to access resources in 100+ workload accounts. The solutions architect needs to design a cross-account access pattern that is scalable, auditable, and follows the principle of least privilege. New workload accounts must be automatically configured to trust the shared services account.

Which approach provides the BEST combination of scalability and security?

A) Create IAM users in the shared services account with access keys. Store the access keys in AWS Secrets Manager. Workload accounts create IAM roles that trust the shared services account. The shared services account uses AssumeRole to access workload accounts.
B) Use AWS Organizations to create a service-linked role in every member account that trusts the shared services account. Configure the roles using CloudFormation StackSets deployed from the management account, triggered by Control Tower lifecycle events for new accounts.
C) Deploy an IAM role in each workload account using CloudFormation StackSets targeted at the organizational root. The role trusts the shared services account with conditions on aws:PrincipalOrgID. Use Control Tower lifecycle events to trigger StackSet deployment for new accounts. The shared services account assumes these roles using specific service roles with session policies for least privilege.
D) Use AWS IAM Identity Center (SSO) to create permission sets that grant the shared services account access to workload accounts. Configure ABAC policies using session tags.

**Correct Answer: C**

**Explanation:** CloudFormation StackSets deployed from the management account ensure consistent IAM role deployment across all workload accounts. The aws:PrincipalOrgID condition on the trust policy ensures only principals within the organization can assume the role. Control Tower lifecycle events automate role deployment to new accounts. Session policies applied during AssumeRole calls provide dynamic least-privilege scoping per service. Option A uses long-lived credentials (access keys) which is a security anti-pattern. Option B describes "service-linked roles" incorrectly — those are created by AWS services, not custom roles. Option D — IAM Identity Center is designed for human user access, not service-to-service access patterns.

---

### Question 16
An organization needs to implement a tag enforcement strategy across 200 AWS accounts. All resources must have "CostCenter", "Environment", and "Owner" tags. The strategy must prevent untagged resource creation (not just detect after the fact). Different OUs have different valid values for the Environment tag (Production OU only allows "prod", Development OU only allows "dev" and "staging").

What combination provides the MOST comprehensive preventive tag enforcement?

A) Use AWS Organizations Tag Policies with enforcement enabled. Create different tag policies for each OU with the appropriate tag values. Tag policies prevent resource creation without required tags.
B) Implement SCPs that deny resource-creating API calls unless the request includes the required tags with valid values. Create separate SCPs for each OU to enforce OU-specific valid values. Complement with AWS Config rules for detection of any gaps.
C) Use AWS Service Catalog as the only method to create resources. Product templates enforce required tags. Restrict direct console and API access using SCPs.
D) Deploy CloudFormation Guard rules as Control Tower proactive controls that validate tag presence and values. Require all resource creation to go through CloudFormation.

**Correct Answer: B**

**Explanation:** SCPs with Deny statements and conditions on aws:RequestTags provide truly preventive enforcement at the API level. Conditions like StringNotEquals on tag values enforce OU-specific valid values. SCPs apply regardless of how resources are created (console, CLI, SDK, CloudFormation). AWS Config rules provide a detective backup layer for services where SCP tag conditions aren't supported. Option A is incorrect — tag policies enforce tag case and value standardization but do NOT prevent resource creation without tags. Option C is too restrictive and impractical for all resource creation. Option D only works for CloudFormation deployments, not direct API calls.

---

### Question 17
A solutions architect is designing a multi-account architecture where a centralized data lake account needs to receive data from 80 producer accounts. Each producer sends data to a specific S3 prefix. The data lake account needs to own all objects regardless of which account uploaded them. Producers should only be able to write to their designated prefix and not read other producers' data. The solution must scale automatically as new producer accounts are added.

Which approach BEST meets these requirements?

A) Configure cross-account S3 bucket policies with conditions on aws:PrincipalOrgPaths for each producer OU. Use s3:PutObject with the bucket-owner-full-control ACL condition. Structure prefixes by account ID and use ${aws:PrincipalAccount} variable in the bucket policy for automatic prefix scoping.
B) Create individual S3 buckets for each producer in the data lake account. Share each bucket via RAM with the corresponding producer account. Enable S3 Object Ownership set to BucketOwnerEnforced.
C) Use S3 Access Points — one per producer account — each with an access point policy scoping access to a specific prefix. Enable S3 Object Ownership set to BucketOwnerEnforced on the bucket to ensure the data lake account owns all objects. Use aws:PrincipalOrgID condition for organization-level trust.
D) Set up AWS Transfer Family SFTP endpoints in the data lake account. Each producer uploads via SFTP with account-specific credentials mapped to specific S3 prefixes.

**Correct Answer: C**

**Explanation:** S3 Access Points provide the most scalable approach for multi-producer access. Each access point has its own policy that restricts a producer to their specific prefix. S3 Object Ownership set to BucketOwnerEnforced eliminates ACL complexities and ensures the data lake account automatically owns all uploaded objects (no need for bucket-owner-full-control ACL). The aws:PrincipalOrgID condition adds organizational trust. New access points can be created for new producers without modifying the main bucket policy. Option A requires the bucket-owner-full-control ACL which is unnecessary with BucketOwnerEnforced and has the 20KB bucket policy size limit concern at scale. Option B creates operational overhead with 80+ buckets. Option D adds unnecessary protocol translation complexity.

---

### Question 18
A financial institution needs to prevent any IAM principal in their organization from disabling CloudTrail, deleting CloudTrail logs, or modifying the CloudTrail configuration in any account. This must apply to all accounts including those with AdministratorAccess IAM policies. However, the security account (delegated admin for CloudTrail) must retain the ability to modify CloudTrail settings for the organization trail.

How should this be implemented?

A) Create an SCP that denies CloudTrail modification actions (cloudtrail:StopLogging, cloudtrail:DeleteTrail, cloudtrail:UpdateTrail) for all accounts. Add a condition that excludes actions when the principal ARN matches a specific role in the security account.
B) Create an SCP that denies CloudTrail modification actions with a StringNotEquals condition on aws:PrincipalAccount matching the security account's ID. Attach this SCP to all OUs except the OU containing the security account.
C) Create an SCP that denies CloudTrail modification actions. Attach it to all OUs. The security account, as delegated administrator, is automatically exempt from SCPs related to its delegated services.
D) Create an SCP that denies CloudTrail modification actions with a condition using ArnNotLike on aws:PrincipalARN to exclude specific IAM roles in the security account. Attach this SCP to the Root OU, which applies to all member accounts including the security account.

**Correct Answer: D**

**Explanation:** An SCP attached to the Root OU with a Deny statement for CloudTrail modification actions applies to all member accounts. The ArnNotLike condition on aws:PrincipalARN excludes specific IAM roles in the security account, allowing those roles to manage CloudTrail. This is the standard pattern for protecting organization-wide security services while maintaining delegated admin capabilities. Option A is similar but less precise — the condition should use ArnNotLike for role-based exceptions. Option B doesn't protect the security account's CloudTrail from other principals within that account. Option C is incorrect — delegated administrators are NOT automatically exempt from SCPs. Remember: SCPs never apply to the management account, but they DO apply to all member accounts including delegated admin accounts.

---

### Question 19
A company uses AWS Control Tower with Account Factory to provision accounts. They need to implement a workflow where account requests go through a multi-level approval process: team lead approval, then security team review, then automated compliance check, before the account is provisioned. The company uses Microsoft Teams for communication and Jira for tracking.

Which architecture provides the MOST integrated approval workflow?

A) Use AWS Service Catalog with launch constraints and a SNS-based approval workflow. Integrate SNS with Microsoft Teams using a webhook Lambda function. Create a Jira integration using Lambda and the Jira REST API. Gate the Service Catalog provisioning on approval status stored in DynamoDB.
B) Build a custom web application using API Gateway, Lambda, and Step Functions. The Step Functions workflow orchestrates multi-level approvals with wait states, calls Microsoft Teams and Jira APIs for notifications, and invokes the Control Tower Account Factory API upon final approval.
C) Use ServiceNow as the orchestrator with the AWS Service Management Connector. Configure ServiceNow workflows for multi-level approvals. Use ServiceNow plugins for Microsoft Teams and Jira integration.
D) Implement a GitOps workflow with Account Factory for Terraform (AFT). Pull requests serve as approval gates, with team lead and security reviews as required PR approvers. Use GitHub Actions for compliance checks and Microsoft Teams/Jira notifications.

**Correct Answer: B**

**Explanation:** A Step Functions workflow provides the most flexible and integrated approval process. Step Functions' wait states naturally support multi-level approvals with callback patterns. The workflow can: (1) notify the team lead via Microsoft Teams and wait for approval, (2) notify the security team and wait for review, (3) run automated compliance checks via Lambda, and (4) invoke Account Factory provisioning via Service Catalog API. Lambda integrations handle Microsoft Teams webhooks and Jira ticket creation/updates. Option A lacks orchestration capabilities for multi-level sequential approvals. Option C requires ServiceNow which the company doesn't use. Option D is suitable for Terraform-centric organizations but ties approvals to Git workflows which may not suit all organizational cultures.

---

### Question 20
An organization discovered that several accounts across different OUs have the same S3 bucket names with different data classification levels. When they attempted to implement an organization-wide S3 data perimeter using VPC endpoints and bucket policies, they found that traffic was being routed to wrong buckets in some cases. They need to implement a data perimeter that prevents S3 access from leaving the organization boundary while ensuring correct bucket resolution.

What is the MOST effective data perimeter implementation?

A) Implement S3 gateway VPC endpoints in all VPCs with endpoint policies that restrict access to buckets owned by accounts within the organization using aws:ResourceOrgID condition.
B) Use S3 interface VPC endpoints with private DNS enabled. Configure endpoint policies with aws:PrincipalOrgID and aws:ResourceOrgID conditions. Implement bucket policies on all buckets with a Deny statement for requests not originating from the organization's VPC endpoints.
C) Deploy AWS PrivateLink endpoints for S3 in all VPCs. Use SCP to deny s3:* unless the request passes through a VPC endpoint (aws:sourceVpce condition). Add aws:ResourceOrgID conditions in the SCP to prevent accessing buckets outside the organization.
D) Implement identity-based and resource-based policies. Add aws:PrincipalOrgID condition to all bucket policies to restrict access to organization principals. Add SCP deny with aws:ResourceOrgID condition to prevent principals from accessing buckets outside the organization.

**Correct Answer: D**

**Explanation:** A comprehensive data perimeter for S3 requires both identity perimeter (who can access our resources) and resource perimeter (what resources our principals can access). Adding aws:PrincipalOrgID to bucket policies ensures only organization principals access organization buckets. SCPs with aws:ResourceOrgID conditions prevent organization principals from accessing buckets outside the organization. This is the AWS-recommended data perimeter pattern. The bucket name confusion issue is a separate DNS/namespace issue. Option A only addresses network egress through VPC endpoints but doesn't prevent access to buckets outside the org via the internet. Option B is overly complex and VPC endpoint policies alone don't provide a complete perimeter. Option C has the right SCP approach but VPC endpoints alone don't cover all access patterns (Lambda, CloudFormation, etc.).

---

### Question 21
A company with 300 accounts under AWS Organizations wants to implement a centralized backup strategy. They need AWS Backup to manage backups across all accounts with backup plans defined centrally. The security team requires that backup vaults in member accounts are encrypted with a centralized KMS key and that no one in the member accounts can delete backup recovery points. New accounts must be automatically enrolled in the backup framework.

Which solution BEST meets all requirements?

A) Deploy AWS Backup using delegated administrator in a dedicated backup account. Create organization-wide backup policies using AWS Organizations backup policies. Use AWS Backup Vault Lock in governance mode on member account vaults. Deploy a KMS key in the backup account and share it via key policy with all member accounts.
B) Use CloudFormation StackSets to deploy backup plans and vaults in every member account. Use SCPs to deny backup:DeleteRecoveryPoint across all OUs. Create an AWS KMS multi-Region key in the management account and replicate it to all regions.
C) Enable AWS Backup at the organization level with a delegated administrator. Create backup policies at the OU level within AWS Organizations. Use AWS Backup Vault Lock in compliance mode to prevent deletion. Use KMS customer-managed keys per region deployed via StackSets with SCPs preventing key deletion.
D) Configure AWS Backup with cross-account backup copying to a central vault in the backup account. Enable MFA delete on the central vault. Use the management account's KMS key for all encryption.

**Correct Answer: C**

**Explanation:** This solution provides the most comprehensive approach. AWS Backup delegated administrator enables centralized management without using the management account. Organization-level backup policies in AWS Organizations enable centralized policy definition that automatically applies to new accounts. Vault Lock in compliance mode (not governance mode) provides WORM protection that prevents anyone, including root users, from deleting recovery points — this meets the strictest security requirement. KMS keys deployed via StackSets ensure encryption consistency, and SCPs prevent key deletion. Option A uses governance mode which allows vault lock removal after a cooling period. Option B doesn't use organization-level backup policies. Option D focuses on cross-account copying rather than distributed backup management.

---

### Question 22
A solutions architect is implementing a network architecture for an organization using shared VPCs. The architecture includes a central inspection VPC with AWS Network Firewall, shared application VPCs, and a shared services VPC. Traffic between all VPCs must be inspected. The Transit Gateway is shared via RAM. Application teams in workload accounts need to deploy resources in shared subnets but require internet access through a centralized NAT gateway in the inspection VPC.

How should routing be configured to ensure all traffic is inspected?

A) Configure Transit Gateway route tables with a default route pointing to the inspection VPC attachment. In the inspection VPC, route traffic from Network Firewall to NAT Gateway for internet-bound traffic and back to TGW for inter-VPC traffic. Use separate TGW route table associations for application VPCs and the inspection VPC.
B) Deploy NAT Gateways in each shared application VPC. Configure VPC route tables to send inter-VPC traffic to the Transit Gateway. Use TGW route tables for direct VPC-to-VPC routing with Network Firewall inline using Gateway Load Balancer endpoints.
C) Use a hub-and-spoke model with the inspection VPC as the hub. Create TGW route tables: one for spoke VPCs with a default route to the inspection VPC, and one for the inspection VPC with specific routes to each spoke VPC. In the inspection VPC, create subnets for TGW attachments, Network Firewall endpoints, and NAT Gateways with appropriate route tables for each subnet tier.
D) Use VPC peering between all VPCs for direct communication. Deploy Network Firewall in each VPC for local inspection. Centralize only internet egress through the inspection VPC using Transit Gateway.

**Correct Answer: C**

**Explanation:** The hub-and-spoke model with segregated TGW route tables is the correct architecture for centralized inspection. The spoke route table (associated with application VPC attachments) sends all traffic (0.0.0.0/0) to the inspection VPC. The inspection VPC route table has specific routes back to each spoke. Within the inspection VPC, proper subnet routing is critical: TGW attachment subnets route to Network Firewall endpoints, Network Firewall subnets route internet traffic to NAT Gateways and VPC traffic back to TGW. NAT Gateway subnets route to the Internet Gateway. This ensures ALL traffic — inter-VPC and internet-bound — passes through Network Firewall. Option A is on the right track but lacks the detail about inspection VPC internal routing. Option B's per-VPC NAT gateways defeat centralized inspection. Option D's VPC peering doesn't support transitive routing through an inspection point.

---

### Question 23
A company is implementing AWS Control Tower across an existing organization. Several accounts have resources that will violate Control Tower guardrails when enabled. The company wants to understand the impact before enrollment and create a remediation plan. They have a 90-day timeline for full enrollment.

What phased approach should the solutions architect recommend?

A) Phase 1: Enable Control Tower in the management account with only mandatory guardrails. Phase 2: Run AWS Config conformance packs against all accounts to identify non-compliant resources. Phase 3: Remediate all findings. Phase 4: Enroll all OUs and enable additional guardrails.
B) Phase 1: Deploy a Control Tower landing zone in a separate, new organization for testing. Phase 2: Migrate test workloads to validate guardrail impact. Phase 3: Migrate the production organization to Control Tower. Phase 4: Enable all guardrails.
C) Phase 1: Enable Control Tower with mandatory guardrails only. Phase 2: Enroll non-production OUs first to validate impact. Phase 3: Enable detective guardrails across all OUs to identify compliance gaps. Phase 4: Remediate findings and enroll production OUs. Phase 5: Enable preventive guardrails progressively.
D) Phase 1: Enable all guardrails in simulation mode. Phase 2: Review simulation results. Phase 3: Enroll all accounts simultaneously. Phase 4: Remediate any failures.

**Correct Answer: C**

**Explanation:** This phased approach minimizes risk while meeting the 90-day timeline. Starting with mandatory guardrails only avoids immediate impact on existing resources. Enrolling non-production OUs first validates the enrollment process and identifies issues in a lower-risk environment. Detective guardrails identify compliance gaps without blocking operations, giving teams visibility into what needs remediation. After remediation, production enrollment proceeds with confidence. Progressive preventive guardrail enablement prevents operational disruption. Option A delays enrollment until all remediation is complete, which may exceed the timeline. Option B wastes time with a separate organization. Option D — Control Tower guardrails don't have a simulation mode.

---

### Question 24
An enterprise needs to implement a strategy for managing VPC CIDR allocations across 200+ accounts to prevent IP address conflicts. The central networking team must allocate CIDRs from a master IP address plan, and workload accounts should not be able to create VPCs with arbitrary CIDR ranges. The solution must track usage and reclaim unused allocations.

Which approach provides the MOST automated and controlled CIDR management?

A) Use Amazon VPC IP Address Manager (IPAM) with a delegated administrator in the networking account. Create IPAM pools for each environment and region with allocation rules. Share IPAM pools via RAM with relevant OUs. Use SCPs to deny ec2:CreateVpc unless the CIDR is allocated from an IPAM pool.
B) Maintain a DynamoDB table as a CIDR registry. Create a Service Catalog product that provisions VPCs using CloudFormation with a Lambda-backed custom resource that allocates CIDRs from the registry. Restrict direct VPC creation using SCPs.
C) Use AWS Config rules to detect VPCs with non-compliant CIDRs. Implement auto-remediation that deletes non-compliant VPCs. Maintain CIDR allocations in an Excel spreadsheet managed by the networking team.
D) Pre-create VPCs with allocated CIDRs in each workload account using StackSets. Share the VPCs via RAM. Prevent workload accounts from creating additional VPCs using SCPs.

**Correct Answer: A**

**Explanation:** Amazon VPC IPAM is the purpose-built AWS service for centralized IP address management. With a delegated administrator in the networking account, IPAM pools can be created with allocation rules (minimum/maximum CIDR size, allowed CIDR ranges). Sharing IPAM pools via RAM with specific OUs allows workload accounts to allocate CIDRs from approved pools when creating VPCs. SCPs ensure VPCs can only be created with IPAM-allocated CIDRs. IPAM automatically tracks usage and can identify unused allocations. Option B works but reinvents IPAM functionality. Option C is reactive and destructive (deleting VPCs). Option D limits flexibility as VPCs must be pre-created, and sharing VPCs via RAM isn't the same as sharing subnets.

---

### Question 25
A company has implemented AWS Organizations with SCPs. They need to allow specific IAM roles in specific accounts to perform actions that are otherwise denied by SCPs. For example, a break-glass role in each account should be able to perform any action, and a security scanner role should be able to read all resources even in restricted regions.

What is the MOST secure way to implement these exceptions?

A) Create exception SCPs at the account level that override the deny SCPs at the OU level.
B) Use SCP Deny statements with conditions that exclude specific role ARNs using aws:PrincipalARN with ArnNotLike. List the break-glass and security scanner role ARNs in the condition.
C) Attach the FullAWSAccess SCP directly to accounts that need exceptions, which overrides Deny statements at higher OU levels.
D) Do not use SCPs for these restrictions. Instead, use IAM permission boundaries that can be selectively applied to roles that should be restricted, while leaving break-glass and scanner roles without boundaries.

**Correct Answer: B**

**Explanation:** Using Deny SCPs with ArnNotLike conditions on aws:PrincipalARN is the standard pattern for SCP exceptions. The SCP denies actions for all principals except those matching the specified role ARNs. This maintains the SCP's protection while allowing designated roles to bypass specific restrictions. For break-glass roles, the exception pattern might use: "Condition": {"ArnNotLike": {"aws:PrincipalARN": ["arn:aws:iam::*:role/BreakGlass", "arn:aws:iam::*:role/SecurityScanner"]}}. Option A is incorrect — exception SCPs cannot override Deny statements from higher levels (Deny always wins). Option C is incorrect — FullAWSAccess cannot override explicit Deny. Option D shifts enforcement to per-role configuration which is error-prone and hard to manage at scale.

---

### Question 26
A solutions architect needs to design the OU structure for a company that has development, staging, and production environments across three business units (Retail, Finance, and Healthcare). The company needs: different SCPs per environment, different compliance requirements per business unit (Healthcare requires HIPAA controls), centralized security and networking accounts, and a sandbox environment for experimentation.

What OU structure BEST supports these requirements?

A) Root → Business Unit OUs (Retail, Finance, Healthcare) → Environment OUs (Dev, Staging, Prod) under each. Separate Infrastructure OU for security and networking. Separate Sandbox OU.
B) Root → Environment OUs (Dev, Staging, Prod) → Business Unit OUs (Retail, Finance, Healthcare) under each. Separate Infrastructure OU and Sandbox OU at the Root level.
C) Root → Workloads OU → Environment OUs (Dev, Staging, Prod) → Business Unit OUs under Prod only. Infrastructure OU at Root for security and networking. Sandbox OU at Root. Policy Staging OU at Root for testing SCPs.
D) Root → Security OU, Infrastructure OU, Sandbox OU, Workloads OU. Under Workloads → Environment OUs (Dev, Staging, Prod). Under each Environment → Business Unit OUs. HIPAA-specific controls attached to Healthcare OUs wherever they appear.

**Correct Answer: D**

**Explanation:** This structure (recommended by AWS) provides the best balance of security segregation and operational flexibility. Root-level OUs for Security, Infrastructure, Sandbox, and Workloads separate concerns cleanly. Under Workloads, Environment OUs allow environment-specific SCPs (tighter restrictions for Prod). Business Unit OUs under each Environment enable business-unit-specific policies (HIPAA controls for Healthcare). The Security OU isolates the log archive and security tooling accounts from workload-related policies. Infrastructure OU contains shared networking, DNS, and transit gateway accounts. Option A puts business units at the top which makes environment-level SCP management harder. Option B has environment OUs first but lacks the Infrastructure/Security separation. Option C is incomplete — it only has business unit OUs under Prod.

---

### Question 27
A company operates a centralized DNS architecture using Route 53 Private Hosted Zones in a shared services account. They share these zones with 100+ VPCs across workload accounts using RAM. A new requirement states that DNS queries from production accounts must be logged and analyzed for security, while development account DNS queries should not be logged to reduce costs. All DNS resolution must work identically for both environments.

How should the solutions architect implement selective DNS query logging?

A) Enable Route 53 Resolver DNS query logging in the shared services account. Create logging configurations that log queries from all VPCs. Use CloudWatch Logs filter patterns to separate production and development queries based on VPC ID.
B) Create separate Route 53 Private Hosted Zones for production and development. Enable DNS query logging only on the production hosted zones. Share each set of zones with the appropriate OU via RAM.
C) Enable Route 53 Resolver query logging in the networking account. Associate the logging configuration only with VPCs belonging to production accounts. Since RAM-shared hosted zones resolve through the local VPC's resolver, only production VPC queries will be logged.
D) Deploy Route 53 Resolver endpoints in production VPCs that forward queries to a centralized DNS resolver with logging enabled. Development VPCs use standard Route 53 resolution without forwarding.

**Correct Answer: C**

**Explanation:** Route 53 Resolver query logging can be selectively associated with specific VPCs. By associating the logging configuration only with production account VPCs, only production DNS queries are logged. This works because DNS resolution in shared VPCs happens through the local VPC's Route 53 Resolver, even for RAM-shared Private Hosted Zones. The hosted zones themselves don't need to be duplicated. Using RAM sharing with AWS Organizations, the Resolver query logging configuration can be shared with the Production OU, and only production VPCs opt-in to logging. Option A logs everything and filters afterward, incurring unnecessary costs. Option B creates operational overhead by duplicating hosted zones. Option D adds complexity with resolver endpoints for a logging requirement.

---

### Question 28
An organization is using AWS RAM to share resources across accounts. They discover that after enabling AWS Organizations integration with RAM, individual account-level RAM shares they had previously created still exist but some resources are showing as "associated" with both the organization share and the account-level share. This is causing confusion about which share is authoritative and creating duplicate notifications.

What is the recommended approach to resolve this?

A) Delete all account-level RAM shares and rely exclusively on organization-level shares. The organization shares provide broader and more manageable access control.
B) Keep both sharing mechanisms as they serve different purposes. Account-level shares provide fine-grained control while organization shares provide broad access. The duplicate associations are expected behavior.
C) Migrate resources from account-level shares to organization-level shares in a phased approach. For each resource type, create the organization share, verify access works, then remove the resource from the account-level share. Delete empty account-level shares afterward.
D) Disable AWS Organizations integration with RAM and use only account-level shares, as they provide more granular control over who can access shared resources.

**Correct Answer: C**

**Explanation:** A phased migration from account-level to organization-level RAM shares is the recommended approach. Dual sharing of the same resource can cause confusion and complicates access management. The phased approach ensures no disruption: create organization shares first, verify that participant accounts can access resources through the new shares, then remove resources from account-level shares. Organization-level shares are preferred because they automatically include new accounts added to shared OUs. Option A risks disruption if done abruptly. Option B accepts an unmanageable state. Option D loses the advantages of organization-level sharing (automatic new account inclusion, OU-level granularity).

---

### Question 29
A multinational company needs to implement a service control policy strategy that restricts access to specific AWS services based on the environment. Production accounts should have access to a curated list of 30 approved services. Development accounts should have broader access (100+ services) but with spending limits. Sandbox accounts should have the broadest access but with absolute guardrails preventing data exfiltration.

What SCP strategy BEST implements these tiered restrictions?

A) Use Allow-list SCPs for all tiers. Create an SCP for Production with 30 allowed services, Development with 100+ services, and Sandbox with all services minus data exfiltration actions. Attach to respective OUs.
B) Use a Deny-list approach for all tiers. Deny everything not in the approved list for each tier. This provides the most restrictive baseline.
C) Use an Allow-list approach for Production OU (only explicitly allowed services). Use a Deny-list approach for Development OU (deny expensive services and region restrictions). Use a Deny-list approach for Sandbox OU (deny data exfiltration actions like s3:PutBucketPolicy with public access, organizations:LeaveOrganization, etc.).
D) Use a single SCP with multiple statements using conditions on aws:PrincipalOrgPaths to differentiate behavior based on OU membership. Attach to the Root.

**Correct Answer: C**

**Explanation:** A mixed approach optimizes control and flexibility per environment. Production benefits from an Allow-list (most restrictive — only 30 approved services), ensuring no unapproved service is accidentally used in production. Development benefits from a Deny-list approach where specific expensive or risky services are blocked, allowing flexibility for experimentation with the 100+ approved services. Sandbox uses Deny-list for data exfiltration guardrails while maximizing freedom. Option A — Allow-list for all tiers works but is very restrictive for Sandbox. Option B uses Deny-list for all which is less secure for Production where an Allow-list is preferred. Option D crams everything into one SCP making it hard to maintain and hitting size limits.

---

### Question 30
A company is setting up delegated administration for multiple AWS services across their organization. They want to delegate: AWS Security Hub to the security account, Amazon Detective to the security account, AWS Service Catalog to the platform account, Amazon Macie to the data security account, and AWS Audit Manager to the compliance account. The management account should only handle billing and organizational management.

What should the solutions architect verify before implementing this delegation?

A) Each service can only be delegated to one account per organization. Verify that no two services are being delegated to the same account.
B) Verify that each delegated admin account has the appropriate IAM roles and permissions, and that trusted access is enabled in Organizations for each service. Also confirm that the services support delegated administration and check for any service-specific limitations on the maximum number of delegated admin accounts.
C) Verify that the management account has a service-linked role for each service being delegated. The delegated admin feature only works if the management account has previously used the service.
D) Ensure that all delegated admin accounts are in the same OU, as delegated administration only works within a single OU scope.

**Correct Answer: B**

**Explanation:** Before implementing delegated administration, you must verify: (1) Each service actually supports delegated administration — not all AWS services do. (2) Trusted access must be enabled in AWS Organizations for each service. (3) The delegated admin account needs appropriate IAM roles. (4) Some services have limits on the number of delegated admin accounts. (5) Some services require specific prerequisites in the delegated admin account. Option A is incorrect — multiple services CAN be delegated to the same account (Security Hub and Detective to the security account is fine). Option C is incorrect — the management account doesn't need to have used the service first. Option D is incorrect — delegated admin accounts can be in any OU; they operate at the organization level.

---

### Question 31
A healthcare company runs HIPAA-compliant workloads on AWS. They are implementing a new multi-account strategy and need to ensure that all accounts used for HIPAA workloads have specific configurations: CloudTrail with log file validation, encrypted EBS volumes by default, S3 bucket versioning for PHI data, and restricted public access settings. The company has 50 existing accounts and expects to add 10 per quarter.

How should the architect ensure continuous compliance for both existing and new accounts?

A) Create a custom AWS Config conformance pack that checks for all HIPAA-required configurations. Deploy the conformance pack across all accounts using AWS Config organization-level deployment from a delegated admin account. Include auto-remediation for each rule. Use Control Tower lifecycle events to trigger conformance pack deployment for new accounts.
B) Use AWS Control Tower HIPAA guardrails which automatically enforce all HIPAA requirements when enabled.
C) Create a custom AMI with all security agents pre-installed. Use SCP to only allow launching instances from this AMI. Configure S3 bucket policies in each account via StackSets.
D) Purchase a third-party compliance solution from AWS Marketplace that handles HIPAA configuration management across all accounts.

**Correct Answer: A**

**Explanation:** AWS Config conformance packs with auto-remediation provide comprehensive, continuous compliance checking and remediation. Organization-level deployment ensures all member accounts are covered. The conformance pack includes Config rules for each HIPAA requirement: CloudTrail log validation, EBS encryption, S3 versioning, and public access settings. Auto-remediation SSM documents fix non-compliant resources automatically. Control Tower lifecycle events ensure new accounts get the conformance pack immediately. Option B is incorrect — Control Tower has some HIPAA-relevant guardrails but they don't cover all the specific requirements listed. Option C only addresses EC2, not S3 or CloudTrail. Option D doesn't leverage AWS-native capabilities.

---

### Question 32
A solutions architect needs to implement network segmentation in a shared VPC. The VPC is shared via RAM with 20 workload accounts. Requirements: workloads in different accounts must not be able to communicate with each other by default, specific cross-account communication must be explicitly allowed, and all traffic must be logged.

What approach provides the MOST granular network segmentation within a shared VPC?

A) Use separate subnets per account. Configure NACLs on each subnet to deny traffic from other accounts' subnets. Create explicit NACL allow rules for approved cross-account communication.
B) Use security groups. Since participant accounts in a shared VPC can reference security groups from other participant accounts, create a security group per account that only allows intra-account traffic. For approved cross-account communication, add rules referencing the other account's security group.
C) Deploy AWS Network Firewall within the shared VPC. Create stateful rules that allow/deny traffic based on source and destination IP ranges allocated to each account's subnets. Enable flow log logging on the Network Firewall.
D) Implement micro-segmentation using AWS PrivateLink. Each account creates VPC endpoints for services it needs to consume from other accounts. No direct network-level communication is allowed.

**Correct Answer: B**

**Explanation:** In a shared VPC, participant accounts can create and manage their own security groups. Security groups in a shared VPC can reference security groups from other participant accounts within the same VPC. This enables granular segmentation: each account's resources use account-specific security groups that default to deny all inbound traffic (security group default behavior). For approved cross-account communication, security group rules reference the other account's security group ID. VPC Flow Logs capture all traffic for logging. Option A — NACLs are stateless and managed by the VPC owner, not participants, limiting flexibility. Option C adds significant cost and complexity. Option D works for service-to-service but is overly complex for general communication needs.

---

### Question 33
A company's SCP configuration includes the following policy attached to the Production OU:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyAllOutsideApprovedRegions",
      "Effect": "Deny",
      "NotAction": [
        "iam:*",
        "sts:*",
        "organizations:*"
      ],
      "Resource": "*",
      "Condition": {
        "StringNotEquals": {
          "aws:RequestedRegion": ["us-east-1", "eu-west-1"]
        }
      }
    }
  ]
}
```

A developer reports that they cannot create a CloudFront distribution from a production account, even though CloudFront is a global service. What is the issue and fix?

A) CloudFront API calls are made to us-east-1. The SCP allows us-east-1, so CloudFront should work. The issue must be an IAM permission problem, not the SCP.
B) CloudFront needs to be added to the NotAction list because CloudFront resources appear as global but some API operations check against a specific region that may not match the approved regions.
C) The SCP is working correctly. CloudFront is indeed a global service, but the cloudfront:CreateDistribution API is processed in us-east-1, which is allowed. The developer needs to check their IAM policy.
D) CloudFront API calls are processed in the us-east-1 region, so they should be allowed by this SCP. However, if the CloudFront distribution needs to access an S3 origin in a non-approved region, the SCP blocks the origin configuration. The fix is to add s3:GetObject to the NotAction list.

**Correct Answer: A**

**Explanation:** CloudFront is indeed a global service and its API calls are processed in us-east-1. Since us-east-1 is in the approved regions list, the SCP should not block CloudFront operations. The developer's issue is likely an IAM permission problem, not an SCP issue. The NotAction list already excludes IAM, STS, and Organizations from the region restriction. CloudFront API calls would hit us-east-1 and be evaluated against the condition — since us-east-1 is allowed, CloudFront calls should succeed. The solutions architect should investigate the developer's IAM policies, resource-based policies, and any other SCPs that might be restricting CloudFront access. However, it's worth noting that if there are OTHER SCPs in the hierarchy that might affect CloudFront, those should also be checked.

---

### Question 34
A company wants to implement an automated account vending machine that provisions new AWS accounts with: a standardized VPC connected to Transit Gateway, baseline security configurations (GuardDuty, Security Hub, Config), IAM roles for break-glass and standard access, and budget alerts. The solution should work with their existing Terraform codebase and integrate with their CI/CD pipeline.

What is the MOST appropriate solution?

A) AWS Control Tower Account Factory for Terraform (AFT). Use AFT to manage account provisioning through Terraform. Define account customizations in a Git repository with separate Terraform modules for VPC, security baseline, IAM roles, and budgets. AFT's pipeline automatically applies customizations after account provisioning.
B) Custom Terraform solution using the AWS provider for Organizations. Create modules for account creation, then use the Terraform AWS provider with assume_role blocks to configure each new account. Trigger via CI/CD pipeline.
C) AWS Control Tower with Service Catalog custom blueprints. Convert Terraform modules to CloudFormation templates using the former terraform-to-cloudformation conversion tools. Deploy via Account Factory.
D) Use Pulumi CrossGuard to create and configure accounts. Pulumi's native AWS provider supports Organizations and cross-account resource creation.

**Correct Answer: A**

**Explanation:** AWS Control Tower Account Factory for Terraform (AFT) is purpose-built for Terraform-based account vending. AFT manages the account lifecycle through Terraform, maintaining a Git repository for account definitions and customizations. Customizations are organized into global customizations (applied to all accounts), OU-level customizations, and account-specific customizations — aligning with the requirements for baseline configurations plus account-specific needs. AFT integrates with existing CI/CD pipelines through its Git-based workflow. Option B works but loses Control Tower governance capabilities. Option C requires converting Terraform to CloudFormation which is cumbersome and loses Terraform ecosystem benefits. Option D uses a different IaC tool than the company's existing Terraform codebase.

---

### Question 35
An organization needs to share an Amazon Managed Grafana workspace across multiple accounts for centralized monitoring. The Grafana workspace is in the monitoring account and needs to query CloudWatch metrics, X-Ray traces, and Prometheus metrics from 50+ workload accounts. Each workload account team should only see their own data in Grafana.

How should cross-account data access be configured while maintaining data isolation?

A) Create IAM roles in each workload account that trust the Grafana workspace's service role. Configure Grafana data sources for each account using the AssumeRole ARN. Use Grafana organizations or teams with RBAC to restrict dashboard access by team.
B) Enable CloudWatch cross-account observability using monitoring account links and source account sinks. Configure Grafana to use the monitoring account's CloudWatch as the data source. Implement Grafana folder-level permissions for data isolation.
C) Set up CloudWatch cross-account observability with the monitoring account as the monitoring account and workload accounts as source accounts. Use account-level sink policies to control which metrics are shared. In Grafana, configure a single CloudWatch data source that can query across linked accounts. Use Grafana teams with folder-level permissions and CloudWatch account-scoped queries for data isolation.
D) Forward all metrics from workload accounts to a centralized Amazon Managed Service for Prometheus workspace using remote write. Configure Grafana to query the central Prometheus workspace. Use PromQL label-based filtering for per-account isolation.

**Correct Answer: C**

**Explanation:** CloudWatch cross-account observability is the native AWS solution for centralized monitoring across accounts. The monitoring account configuration creates "links" with source accounts, enabling seamless metric, log, and trace access. Account-level sink policies control what data is shared from each source account. In Grafana, a single CloudWatch data source with cross-account querying capability provides unified access. Grafana teams with folder-level permissions, combined with CloudWatch account-scoped queries (using accountId filter), ensure each team only sees their own account's data. Option A works but requires managing 50+ data sources and IAM roles. Option B is similar but less specific about the isolation mechanism. Option D requires additional Prometheus infrastructure and doesn't cover CloudWatch-specific metrics and X-Ray traces.

---

### Question 36
A company has an SCP that restricts the maximum EC2 instance size to m5.xlarge in development accounts. A developer needs to run a one-time data processing job that requires an m5.4xlarge instance. The company's change management policy requires approval for SCP exceptions. The solutions architect needs to enable this without permanently modifying the SCP or creating security risks.

What is the MOST controlled approach?

A) Temporarily detach the SCP from the Development OU, let the developer launch the instance, then reattach the SCP. This window should be as brief as possible.
B) Move the developer's account temporarily to a different OU that allows larger instances, let them launch the instance, then move the account back.
C) Create a temporary SCP exception using a condition on aws:PrincipalARN for the developer's specific IAM role, with an additional condition on aws:CurrentTime to automatically expire the exception after a defined window. Attach this modified SCP while keeping the restriction active for all other roles.
D) Use AWS Step Functions to orchestrate: (1) modify the SCP to add a time-bound exception, (2) notify the developer, (3) wait for a defined period, (4) revert the SCP. All changes are logged in CloudTrail.

**Correct Answer: C**

**Explanation:** Adding a time-bound, role-specific exception to the SCP is the most controlled approach. The aws:CurrentTime condition allows specifying a DateLessThan value, making the exception automatically expire. The aws:PrincipalARN condition limits the exception to only the developer's role. This maintains SCP protection for all other users and roles while providing temporary, scoped access. After the time window expires, the SCP automatically enforces the restriction again. Option A removes protection for all accounts in the OU during the window. Option B is operationally risky and temporarily removes all Development OU SCPs from the account. Option D automates SCP modification but is unnecessarily complex when time-based conditions can handle expiration natively.

---

### Question 37
A global company has AWS accounts across four AWS Organizations (acquired through M&A). They need to consolidate into a single organization while maintaining: existing account-level configurations, active workloads without downtime, RI and Savings Plan benefits, and compliance with regional data sovereignty requirements.

What migration strategy should the solutions architect recommend?

A) Create a new target organization. Migrate accounts from each source organization using the Organizations migration feature. Schedule migrations during maintenance windows. Transfer RIs and Savings Plans using the Billing Console transfer capability.
B) For each source organization, remove accounts (they become standalone), then invite them to the target organization. Before migration, document existing SCPs and tag policies to recreate them. After migration, reapply equivalent policies in the target organization. Use consolidated billing to maintain RI sharing benefits. Migrate in phases: non-production first, then production.
C) Use AWS Control Tower's Account Factory to create new accounts in the target organization. Migrate workloads from old accounts to new accounts using AWS Application Migration Service. Transfer RIs through AWS Support cases.
D) Keep all four organizations and implement cross-organization resource sharing using RAM. Use a single billing account connected to all organizations via billing consolidation.

**Correct Answer: B**

**Explanation:** The correct process to consolidate organizations is: (1) Remove accounts from source organizations (they become standalone accounts), (2) Invite standalone accounts to the target organization. This process preserves all account-level configurations and running workloads with no disruption. Before removing accounts, document SCPs, tag policies, and other organizational policies to recreate them. Phased migration (non-production first) reduces risk. RI and Savings Plans sharing consolidation happens automatically under consolidated billing once accounts join the target organization. Option A — there is no native "Organizations migration feature" that directly moves accounts between organizations. Option C is unnecessarily disruptive by creating new accounts. Option D doesn't achieve consolidation.

---

### Question 38
A solutions architect is designing a multi-account strategy for a SaaS company. Each enterprise customer gets a dedicated AWS account for data isolation. The company needs: automated account provisioning when customers sign up, customer-specific resource limits, the ability to shut down and clean up accounts when customers churn, and cost tracking per customer.

What is the MOST scalable architecture?

A) Use AWS Organizations with a "Customers" OU. Automate account creation using the Organizations API triggered by the SaaS platform's customer onboarding workflow. Apply baseline SCPs to the Customers OU. Use AWS Budgets per account for cost tracking. For churn, use the CloseAccount API to close the account, which triggers automatic resource cleanup after 90 days.
B) Use separate AWS accounts created manually for each customer. Track costs using tags. For churn, manually delete all resources and close the account via AWS Support.
C) Use a single account with resource-level isolation using IAM policies and tags. Each customer's resources are tagged with their customer ID. For churn, use Resource Groups to identify and delete tagged resources.
D) Use AWS Control Tower with Account Factory for each customer account. Create a custom Service Catalog product for customer onboarding. For churn, use a Lambda function that lists and deletes all resources in the account before closing it.

**Correct Answer: A**

**Explanation:** This architecture leverages AWS Organizations' native capabilities for the customer account lifecycle. The Organizations CreateAccount API enables automated provisioning. SCPs on the Customers OU enforce resource limits and security baselines. Per-account cost tracking through AWS Budgets and Cost Explorer provides customer-level cost visibility. The CloseAccount API (available since 2022) enables automated account closure during customer churn — AWS automatically handles resource cleanup during the 90-day suspension period before permanent closure. Option B is not scalable. Option C lacks true isolation between customers. Option D adds unnecessary complexity with Control Tower for customer accounts and manual resource deletion before closure (the CloseAccount API handles this).

---

### Question 39
An organization's security team discovered that a compromised IAM role in a member account was used to call organizations:LeaveOrganization, which would have removed the account from AWS Organizations and all SCP protections. Although the attempt was blocked by an existing SCP, the team wants to implement defense-in-depth to prevent this and other dangerous organization-level actions.

What combination of controls provides the MOST comprehensive protection?

A) Create an SCP denying organizations:LeaveOrganization. Enable CloudTrail for Organizations API calls. Create EventBridge rules to alert on organizations:* API calls.
B) Create an SCP denying critical Organizations actions (LeaveOrganization, DisableAWSServiceAccess, DeregisterDelegatedAdministrator) with no exception conditions. Implement GuardDuty to detect credential compromise. Create CloudTrail metric filters and CloudWatch alarms for Organizations API calls. Enable AWS Config rules to detect SCP modifications. Use SNS to alert the security team.
C) Disable the Organizations API in all member accounts using an SCP that denies all organizations:* actions.
D) Use IAM permission boundaries on all roles in member accounts to deny organizations:* actions. Deploy this using CloudFormation StackSets.

**Correct Answer: B**

**Explanation:** Defense-in-depth requires multiple layers: (1) Preventive: SCP denying critical Organizations actions without exceptions ensures no member account principal can execute these dangerous actions. (2) Detective: GuardDuty detects credential compromise that could be used for privilege escalation. CloudTrail metric filters catch attempted Organizations API calls. AWS Config rules detect if SCPs are modified or removed. (3) Responsive: SNS alerts enable rapid security team response. Option A is incomplete — it only covers one action and lacks detection of credential compromise. Option C is overly broad — member accounts legitimately need some Organizations read actions (like ListAccounts for cross-account operations). Option D — IAM permission boundaries are per-role and can be removed by admins in the account, unlike SCPs which are enforced from outside the account.

---

### Question 40
A company operates a centralized container registry in an ECR repository within a shared services account. Application accounts across the organization need to pull images from this registry. The company wants: read-only access for all organization accounts, write access limited to the CI/CD account, image scanning enabled for all pushed images, and images to be replicated to a DR region.

How should the solutions architect configure ECR access and resilience?

A) Create an ECR repository policy that grants ecr:GetDownloadUrlForLayer, ecr:BatchGetImage, and ecr:BatchCheckLayerAvailability to the organization using aws:PrincipalOrgID condition. Grant push permissions to the CI/CD account's IAM role. Enable ECR enhanced scanning. Configure ECR replication rules for cross-region replication.
B) Share the ECR repository via AWS RAM with the entire organization for pull access. Grant push permissions to the CI/CD account. Enable basic scanning. Use a Lambda function to copy images to the DR region.
C) Create ECR pull-through cache rules in each application account pointing to the central registry. This provides read access without cross-account permissions. Enable scanning on the central repository. Use ECR replication for DR.
D) Use Amazon ECR Public for the container registry to avoid cross-account access configuration. Enable scanning and configure a private mirror in the DR region.

**Correct Answer: A**

**Explanation:** ECR repository policies support organization-level access using the aws:PrincipalOrgID condition key. This grants read-only access to all current and future organization accounts without individual account configuration. Write permissions are limited to the CI/CD account's specific IAM role ARN. ECR enhanced scanning (powered by Amazon Inspector) provides comprehensive vulnerability scanning. ECR native replication rules handle cross-region replication without custom Lambda functions. Option B — ECR is not a RAM-supported resource type. Option C — pull-through cache rules are designed for external public registries, not internal cross-account ECR repositories. Option D — public repositories expose images outside the organization, violating security best practices.

---

### Question 41
A multinational bank uses AWS Organizations with OUs for each country (US, UK, Germany, Japan). Regulatory requirements mandate that each country's accounts can only store data in their respective local regions. However, the bank's shared services (identity management, central logging) must be accessible from all accounts. The bank also needs a global view of security findings.

What architecture BEST satisfies both data sovereignty and operational requirements?

A) Use region-restriction SCPs per country OU. Deploy shared services in all required regions. Use Security Hub with a delegated administrator that aggregates findings across all regions. Create a central logging architecture where logs from each country stay in their local region but are queryable centrally through Athena federated queries.
B) Deploy completely isolated AWS Organizations per country to ensure strict data sovereignty. Each organization has its own shared services. Aggregate security findings using a custom SIEM solution.
C) Use a single OU for all countries. Implement data sovereignty through IAM policies and S3 bucket policies that restrict PutObject operations based on the bucket's region.
D) Use Transit Gateway inter-region peering to connect all country VPCs. Deploy shared services in a single region with VPC endpoints accessible from all countries. Data sovereignty is handled through encryption with country-specific KMS keys.

**Correct Answer: A**

**Explanation:** Region-restriction SCPs per country OU prevent accounts from creating resources outside their approved region (e.g., Germany OU restricted to eu-central-1). Shared services like identity management (IAM Identity Center) and central logging are deployed in each required region for availability, with the centralized management operating from the organization's management region. Security Hub's delegated administrator with cross-region aggregation provides the global security view. For central logging, each country's logs stay in the local region (compliance), but Athena with data source connectors enables federated querying across regions without data movement. Option B creates management overhead with separate organizations. Option C doesn't provide preventive data sovereignty controls. Option D moves data across regions through TGW, potentially violating sovereignty.

---

### Question 42
A company uses AWS Organizations and needs to prevent member accounts from creating VPC peering connections with VPCs outside the organization. They also need to prevent accounts from creating VPN connections to on-premises networks without using the centralized Transit Gateway. However, they want to allow VPC peering within the organization for specific use cases.

Which SCP implementation achieves this?

A) Deny ec2:CreateVpcPeeringConnection and ec2:CreateVpnConnection for all member accounts without conditions.
B) Deny ec2:CreateVpcPeeringConnection with a condition that checks if the peer VPC owner account is outside the organization using aws:ResourceOrgID. Deny ec2:CreateVpnConnection and ec2:CreateVpnGateway for all accounts except the networking account using aws:PrincipalARN condition.
C) Deny ec2:AcceptVpcPeeringConnection from accounts outside the organization. Allow all VPC peering creation. Deny ec2:CreateVpnConnection for all non-networking accounts.
D) Deny ec2:CreateVpcPeeringConnection with a StringNotEquals condition on the requester's aws:PrincipalOrgID. Deny all VPN-related actions except for accounts with a specific tag.

**Correct Answer: B**

**Explanation:** This approach provides granular control. For VPC peering, the SCP denies ec2:CreateVpcPeeringConnection when the peer VPC owner is outside the organization (using a condition on the resource's organization). This allows intra-organization peering while blocking external peering. For VPN connections, denying ec2:CreateVpnConnection and ec2:CreateVpnGateway for all accounts except the networking account prevents unauthorized VPN creation while maintaining centralized network management. Option A blocks ALL peering including internal, which is too restrictive. Option C only blocks acceptance of external peering but doesn't prevent creation of peering requests to external accounts. Option D's condition logic is inverted — aws:PrincipalOrgID checks the requester's org, not the peer's org.

---

### Question 43
A company is using AWS RAM to share subnets from a central networking account. A development team in a workload account reports they cannot launch an RDS instance in a shared subnet. The team can successfully launch EC2 instances in the same subnet. The RDS instance creation fails with an "unauthorized" error.

What is the MOST likely cause?

A) RDS is not supported for launch in RAM-shared subnets. Only EC2 instances, Lambda functions, and ECS tasks can be launched in shared subnets.
B) The workload account needs to create a DB subnet group using the shared subnets. The IAM role used by the development team has ec2:* permissions but lacks rds:CreateDBSubnetGroup permissions.
C) The RAM resource share only includes the subnet but not the associated security groups. RDS requires security groups to be explicitly shared via RAM.
D) RDS requires a VPC endpoint in the workload account to access RDS resources in shared subnets.

**Correct Answer: B**

**Explanation:** To launch an RDS instance in RAM-shared subnets, the workload account must first create a DB subnet group referencing the shared subnets. The development team can launch EC2 instances because EC2 doesn't require this intermediate resource creation step. The "unauthorized" error likely indicates the team's IAM role lacks rds:CreateDBSubnetGroup permission. RDS IS supported in RAM-shared subnets (A is wrong). Security groups don't need to be shared via RAM — participant accounts can create their own security groups in the shared VPC (C is wrong). VPC endpoints are not required for RDS in shared subnets (D is wrong).

---

### Question 44
An organization has 400 accounts and uses AWS Control Tower. The management team wants to prevent shadow IT by ensuring that all AWS accounts used by employees are part of the organization. They've discovered that some employees have created personal AWS accounts using corporate email addresses and are deploying workloads that handle company data.

What is the MOST comprehensive approach to address this?

A) Use AWS IAM Identity Center to manage all corporate user access to AWS. Implement DNS-level blocking of the AWS console for non-corporate networks. Use email filters to block AWS account creation emails from corporate domains.
B) Work with the email/IT team to block AWS account verification emails for corporate email domains unless they originate from the Organizations management account. Implement a cloud access security broker (CASB) that detects and alerts on unauthorized AWS account usage. Create a corporate policy requiring all AWS usage to go through the organization.
C) Use AWS Organizations to create all accounts. Deploy an SCP that blocks account creation. Monitor CloudTrail for unauthorized account activity.
D) Implement AWS Control Tower with guardrails that detect unauthorized accounts. Use AWS Config cross-account rules to scan all accounts.

**Correct Answer: B**

**Explanation:** This is a comprehensive approach combining technical and policy controls. Blocking AWS account verification emails for corporate email domains prevents unauthorized account creation (AWS requires email verification). A CASB solution detects unauthorized AWS usage by monitoring network traffic for AWS API calls from corporate networks. Corporate policy provides the organizational governance framework. Option A's DNS blocking is easily circumvented and doesn't address VPN or home network usage. Option C — SCPs only apply within the organization and can't prevent account creation outside it. Option D — Control Tower and AWS Config only operate within the organization and cannot detect or manage external accounts.

---

### Question 45
A company needs to implement a strategy where specific S3 buckets in workload accounts are accessible to an analytics account for data processing. The analytics account should be able to read from designated buckets across 30 accounts without requiring bucket policies to be modified in each workload account. The solution should automatically include buckets in new accounts.

What is the MOST scalable approach?

A) Use S3 Access Grants with an S3 Access Grants instance in each workload account. Register the analytics account's IAM Identity Center identity. Define access grants for designated buckets.
B) Use AWS Lake Formation cross-account data sharing. Register S3 locations in Lake Formation for each workload account. Grant the analytics account read access through Lake Formation permissions.
C) Create an IAM role in each workload account that trusts the analytics account. Deploy the role using CloudFormation StackSets. The analytics account assumes the role in each workload account to access S3 buckets. Use Control Tower lifecycle events to deploy the role in new accounts.
D) Use S3 Access Points with a cross-account access point in the analytics account for each workload account's bucket. This centralizes access configuration in the analytics account.

**Correct Answer: C**

**Explanation:** CloudFormation StackSets deployed at the OU level create consistent IAM roles across all workload accounts. The role's trust policy trusts the analytics account, and the role's permissions policy grants S3 read access to designated buckets (using resource tags or naming conventions). Control Tower lifecycle events trigger StackSet deployment for new accounts, providing automatic inclusion. The analytics account assumes the cross-account role to access S3. Option A — S3 Access Grants is a newer feature but requires configuration per workload account. Option B — Lake Formation cross-account sharing requires registration per S3 location per account. Option D is incorrect — S3 Access Points must be in the same account as the bucket, not in a cross-account configuration.

---

### Question 46
A company uses AWS Organizations and wants to implement a preventive control that ensures no member account can create an S3 bucket without server-side encryption enabled (either SSE-S3 or SSE-KMS). The control must work regardless of how the bucket is created (console, CLI, SDK, CloudFormation).

Which approach provides the strongest preventive control?

A) Create an SCP that denies s3:CreateBucket unless the request includes the x-amz-server-side-encryption header.
B) Create an SCP that denies s3:PutObject unless encryption is specified. This ensures all data is encrypted even if the bucket allows unencrypted uploads.
C) Use S3 bucket default encryption which is now enabled by default for all new buckets. Since SSE-S3 is the default, no additional controls are needed.
D) Use a Control Tower proactive control (CloudFormation Guard rule) that validates CloudFormation templates include bucket encryption configuration. Complement with an SCP that denies s3:PutBucketEncryption with the condition that the encryption algorithm is not aws:kms or AES256.

**Correct Answer: D**

**Explanation:** A multi-layer approach provides the strongest control. The proactive control (CloudFormation Guard) prevents CloudFormation from creating buckets without encryption configuration. The SCP prevents modification or removal of bucket encryption settings by denying s3:PutBucketEncryption unless the encryption algorithm is aws:kms or AES256. Note that as of January 2023, S3 automatically encrypts all new objects with SSE-S3 by default (Option C's point), but the controls in Option D go further by preventing someone from explicitly disabling encryption or changing settings. Option A — there's no x-amz-server-side-encryption header requirement at bucket creation time. Option B addresses object-level encryption but doesn't prevent bucket encryption modification.

---

### Question 47
A solutions architect is deploying a multi-account architecture where all internet-bound traffic must egress through a centralized inspection VPC using AWS Network Firewall. The architecture uses Transit Gateway shared via RAM. Some workload accounts need to host public-facing Application Load Balancers that receive inbound traffic from the internet.

How should inbound internet traffic to workload ALBs be handled while maintaining centralized egress inspection?

A) Route all inbound internet traffic through the centralized inspection VPC using Transit Gateway. Use Network Firewall to inspect inbound traffic before routing it to workload ALBs via Transit Gateway.
B) Allow inbound internet traffic directly to workload VPCs via Internet Gateways. The ALBs receive traffic directly. Only egress traffic routes through Transit Gateway to the centralized inspection VPC. Use AWS WAF on the ALBs for inbound inspection.
C) Deploy ALBs in the centralized inspection VPC. Share the ALB subnets via RAM with workload accounts. Workload accounts register their targets (in their own VPCs) with the shared ALBs.
D) Use AWS Global Accelerator to route inbound traffic to workload ALBs. Global Accelerator's built-in DDoS protection replaces the need for centralized inbound inspection.

**Correct Answer: B**

**Explanation:** The recommended architecture separates inbound and egress traffic paths. Inbound traffic to public ALBs enters directly through the workload VPC's Internet Gateway — this is required because ALBs need to be in public subnets with direct internet access. AWS WAF on the ALBs provides layer 7 inspection for inbound traffic (SQL injection, XSS, rate limiting). AWS Shield provides DDoS protection. Egress traffic (initiated by workload resources) routes through Transit Gateway to the centralized inspection VPC with Network Firewall. Option A routing inbound through TGW adds latency and complexity and creates asymmetric routing issues with ALBs. Option C has cross-VPC target registration limitations. Option D — Global Accelerator doesn't replace comprehensive inbound inspection.

---

### Question 48
A company has an SCP that restricts all actions in the ap-south-1 region. However, they need to deploy a disaster recovery solution for their primary region (ap-southeast-1) workloads in ap-south-1. Only the DR automation role in each account should be able to create resources in ap-south-1, and only specific resource types (EC2 instances, EBS volumes, RDS instances) should be allowed.

How can this be implemented with SCPs?

A) Create a new SCP that allows the DR automation role to perform all actions in ap-south-1. Attach it alongside the existing Deny SCP.
B) Modify the existing region-restriction SCP to add a condition that excludes the DR automation role ARN using aws:PrincipalARN with ArnNotLike. This allows the DR role to work in ap-south-1 without restriction.
C) Modify the existing region-restriction SCP to add conditions using aws:PrincipalARN (ArnNotLike for the DR role). Create a separate SCP that restricts the DR role to only ec2:RunInstances, ec2:CreateVolume, rds:CreateDBInstance, and related actions in ap-south-1, denying all other actions for the DR role in that region.
D) Remove the region restriction for ap-south-1 entirely. Instead, use IAM policies to restrict non-DR roles from operating in ap-south-1.

**Correct Answer: C**

**Explanation:** This requires two SCPs working together. The first SCP (modified region restriction) uses ArnNotLike on aws:PrincipalARN to exclude the DR automation role from the region restriction. The second SCP specifically restricts what the DR role can do in ap-south-1 — only allowing specific DR-related actions (RunInstances, CreateVolume, CreateDBInstance). This follows the principle of least privilege. Option A's new Allow SCP cannot override an existing Deny (an Allow SCP doesn't override a Deny SCP). Option B gives the DR role unrestricted access to all services in ap-south-1, violating least privilege. Option D removes the preventive control for all accounts and relies on per-account IAM policies which is less secure.

---

### Question 49
A company migrating to AWS needs to implement a multi-account strategy from scratch. They have 8 business units, each needing development, staging, and production environments. They also need centralized security, logging, networking, and shared services accounts. The total expected account count is 30+. They want to use AWS Control Tower and need the implementation completed within 4 weeks.

What is the recommended implementation order?

A) Week 1: Set up Control Tower and create all accounts. Week 2: Configure networking. Week 3: Implement security services. Week 4: Enable guardrails and begin workload migration.
B) Week 1: Enable Control Tower with mandatory guardrails, create the Security OU with log archive and audit accounts, and the Infrastructure OU with networking account. Week 2: Set up Transit Gateway architecture, create the Shared Services OU and account, configure centralized logging and security services (GuardDuty, Security Hub, Config). Week 3: Create the Workloads OU structure with environment sub-OUs, implement SCPs per OU, deploy Account Factory blueprints. Week 4: Provision initial workload accounts, validate guardrails and security posture, create operational runbooks.
C) Week 1-2: Design the OU structure on paper and get stakeholder approval. Week 3: Implement everything at once using CloudFormation. Week 4: Testing and remediation.
D) Week 1: Set up Control Tower. Week 2-3: Manually create each account and configure it individually. Week 4: Test and document.

**Correct Answer: B**

**Explanation:** This phased approach follows AWS best practices for landing zone implementation. Week 1 establishes the governance foundation (Control Tower, mandatory guardrails) and essential accounts (log archive, audit, networking). Week 2 builds infrastructure (networking, shared services, security services). Week 3 creates the workload structure with proper SCPs and Account Factory blueprints for repeatable provisioning. Week 4 provisions initial workload accounts and validates the entire setup. This order ensures each layer depends on the previous one: governance → infrastructure → workload structure → workload accounts. Option A creates accounts before infrastructure is ready. Option C wastes two weeks on design without implementation. Option D's manual approach won't scale and wastes time.

---

### Question 50
An organization needs to implement a mechanism where any API call made from the management account that modifies organizational structure (creating/deleting OUs, moving accounts, attaching/detaching SCPs) triggers a multi-person approval process. This is required by their compliance framework to prevent a single administrator from making unauthorized changes.

What architecture implements this multi-person approval requirement?

A) Require all organizational changes to be made through CloudFormation. Use CloudFormation change sets that require review before execution. Deploy a Lambda function that validates the CloudFormation template and checks for approval in a DynamoDB table.
B) Remove all IAM permissions for organizational management from individual users. Create a Step Functions workflow that: (1) receives change requests, (2) sends approval notifications to multiple approvers via SNS, (3) waits for N of M approvals using callback patterns, (4) executes the approved change using a privileged IAM role. All requests and approvals are logged in DynamoDB and CloudTrail.
C) Use AWS Organizations policy-level controls to require multi-factor authentication for organizational changes. Each approver provides their MFA token.
D) Implement a custom API Gateway endpoint that proxies Organizations API calls. The proxy checks for required approval headers containing digital signatures from multiple approvers.

**Correct Answer: B**

**Explanation:** Step Functions provides a robust workflow engine for multi-person approval. The workflow receives change requests (submitted through a web interface or Slack), sends notifications to designated approvers, and uses callback patterns to wait for the required number of approvals (e.g., 2 of 3 approvers). Only after sufficient approvals does the workflow assume a privileged IAM role to execute the organizational change. Individual users never have direct permissions to modify the organization structure. DynamoDB stores the approval audit trail, and CloudTrail captures the actual API calls. Option A requires CloudFormation for all changes which isn't practical for all organizational operations. Option C — Organizations doesn't natively support multi-person approval through MFA alone. Option D is fragile and can be bypassed by calling the API directly.

---

### Question 51
A company shares a VPC with 20 workload accounts via AWS RAM. The VPC has private subnets connected to an on-premises data center through AWS Direct Connect via Transit Gateway. Workload accounts can currently resolve on-premises DNS names through Route 53 Resolver rules. A new requirement mandates that only production workload accounts should be able to resolve specific on-premises DNS zones (internal.corp.com), while development accounts should be blocked from resolving these zones.

How should this be implemented?

A) Create two Route 53 Resolver rule sets — one for production including internal.corp.com resolution, one for development without it. Associate each rule set with the shared VPC's Route 53 Resolver configuration based on the account type.
B) Share Route 53 Resolver rules for internal.corp.com via RAM only with the Production OU. Development OU accounts will not have the rule and therefore cannot resolve internal.corp.com names. The shared VPC's base DNS resolution continues to work for both environments.
C) Implement DNS firewall rules that deny DNS queries for internal.corp.com from development accounts. Associate the DNS firewall rule group with the shared VPC.
D) Configure the on-premises DNS server to reject queries originating from IP ranges allocated to development account subnets.

**Correct Answer: B**

**Explanation:** Route 53 Resolver rules can be shared via AWS RAM with specific OUs. By sharing the internal.corp.com resolver rule only with the Production OU, only production accounts will have DNS forwarding for that zone. Development accounts without the shared rule will get NXDOMAIN responses for internal.corp.com queries. Base DNS resolution for AWS resources continues normally for all accounts. Option A — you cannot have account-specific DNS configurations within a single VPC's resolver. Option C — Route 53 DNS Firewall could work, but implementing per-account rules within a shared VPC is complex. Option D requires on-premises infrastructure changes and IP-range-based filtering which is brittle.

---

### Question 52
A company uses AWS Organizations and has enabled all features. They want to implement a tag-based access control strategy where IAM roles can only manage resources that share the same "Department" tag value as the role. This must work across 100 accounts. The company also needs to prevent tag values from being modified by unauthorized principals.

What combination of services and policies implements this?

A) Use ABAC with IAM policies that include conditions on aws:ResourceTag/Department matching aws:PrincipalTag/Department. Deploy IAM roles with Department tags via CloudFormation StackSets. Use SCP to deny iam:TagRole and iam:UntagRole for non-admin principals. Use AWS Organizations Tag Policies to enforce Department tag values.
B) Use resource-based policies on all resources that check the caller's Department tag. Deploy using StackSets.
C) Use IAM permission boundaries that restrict access to resources matching the principal's Department tag. Deploy boundaries via StackSets.
D) Use AWS Lake Formation-style tag-based access control for all resource types.

**Correct Answer: A**

**Explanation:** This is the comprehensive ABAC (Attribute-Based Access Control) implementation. IAM policies with conditions comparing aws:ResourceTag/Department to aws:PrincipalTag/Department ensure principals can only manage matching resources. CloudFormation StackSets deploy consistent IAM roles across accounts. SCPs prevent tag manipulation (changing the Department tag on a role would allow privilege escalation). Tag Policies enforce valid Department tag values across the organization. Option B — not all resources support resource-based policies. Option C — permission boundaries work but are more complex to manage than ABAC conditions in identity policies. Option D — Lake Formation tags only apply to data catalog resources, not general AWS resources.

---

### Question 53
A solutions architect is tasked with implementing a guardrail that prevents any member account from purchasing Reserved Instances or Savings Plans. All purchases must be made centrally by the finance team through the management account to ensure optimal utilization across the organization. Existing RIs in member accounts should continue to work.

Which SCP achieves this?

A) Deny ec2:PurchaseReservedInstancesOffering, rds:PurchaseReservedDBInstancesOffering, elasticache:PurchaseReservedCacheNodesOffering, es:PurchaseReservedInstanceOffering, redshift:PurchaseReservedNodeOffering, and savingsplans:CreateSavingsPlan for all member accounts.
B) Deny ec2:PurchaseReservedInstancesOffering only. Other services' RI purchases will be automatically blocked.
C) Deny all purchase-related API calls using a wildcard: *:Purchase* and savingsplans:Create*.
D) Remove pricing-related IAM permissions from all member account roles using permission boundaries deployed via StackSets.

**Correct Answer: A**

**Explanation:** Each AWS service has its own API for purchasing Reserved Instances or commitments. The SCP must explicitly deny each service's purchase API: EC2 (PurchaseReservedInstancesOffering), RDS (PurchaseReservedDBInstancesOffering), ElastiCache (PurchaseReservedCacheNodesOffering), OpenSearch (PurchaseReservedInstanceOffering), Redshift (PurchaseReservedNodeOffering), and Savings Plans (CreateSavingsPlan). Existing RIs continue functioning because the SCP only blocks new purchases, not the application of existing reservations. Option B only covers EC2 RIs. Option C — wildcard across service namespaces (*:Purchase*) is not valid SCP syntax. Option D relies on per-role permission boundaries which can be circumvented if someone creates a new role.

---

### Question 54
A company's security team needs to implement a detective control that identifies when new IAM roles are created in any member account with overly permissive policies (e.g., AdministratorAccess, PowerUserAccess, or policies with "Effect": "Allow", "Action": "*", "Resource": "*"). The detection must be near-real-time and trigger automated remediation.

What is the MOST effective architecture?

A) Use AWS Config rule iam-policy-no-statements-with-admin-access deployed across all accounts via organization-level Config. Create auto-remediation using SSM Automation that removes the overly permissive policy from the role.
B) Use CloudTrail organizational trail. Create EventBridge rules that match iam:CreateRole and iam:AttachRolePolicy events. Trigger a Lambda function that evaluates the attached policy for overly permissive statements. If detected, the Lambda removes the policy and sends an alert via SNS.
C) Use IAM Access Analyzer to continuously monitor for overly permissive policies. Configure findings to trigger EventBridge rules for automated remediation.
D) Deploy a custom AWS Config rule (Lambda-backed) that evaluates IAM role policies for overly permissive patterns. Use organization-level deployment. Configure auto-remediation that detaches non-compliant policies and notifies the security team. Complement with an EventBridge rule on CloudTrail for near-real-time detection of role creation events.

**Correct Answer: D**

**Explanation:** A combination approach provides the most effective solution. The custom Config rule enables comprehensive policy evaluation (checking for admin access patterns, wildcard permissions, etc.) beyond what the built-in rule covers. Organization-level Config deployment ensures all accounts are monitored. Auto-remediation detaches non-compliant policies. EventBridge rules on CloudTrail events provide near-real-time detection (Config rules have a delay). The Lambda triggered by EventBridge can immediately evaluate new role policies. Option A's built-in Config rule only checks for one specific pattern. Option B covers creation events but misses existing roles and policy modifications. Option C — IAM Access Analyzer focuses on external access findings, not overly permissive internal policies.

---

### Question 55
A global media company needs to implement a multi-account strategy for their video processing pipeline. The pipeline involves: content ingestion accounts (receiving uploads from content creators), processing accounts (transcoding, watermarking), distribution accounts (CDN, streaming), and analytics accounts. Data must flow between these account types. The company processes 10,000+ videos daily and needs cost visibility per content creator.

What multi-account architecture BEST supports this pipeline?

A) Create separate OUs for each pipeline stage (Ingestion, Processing, Distribution, Analytics). Use cross-account IAM roles for data access between stages. Share S3 buckets via bucket policies with aws:PrincipalOrgID conditions. Tag all resources with content creator IDs for cost allocation. Use Step Functions cross-account workflows to orchestrate the pipeline.
B) Use a single account for the entire pipeline to avoid cross-account complexity. Separate stages using VPCs and security groups.
C) Deploy all pipeline stages in each content creator's account. Use EventBridge cross-account event routing for coordination.
D) Use AWS Organizations with account-per-creator model. Each content creator gets their own account with all pipeline stages.

**Correct Answer: A**

**Explanation:** Separating accounts by pipeline stage provides security isolation between stages, independent scaling, and clear cost boundaries. Cross-account IAM roles enable secure data flow. S3 bucket policies with aws:PrincipalOrgID allow organization-wide access. Content creator tags enable per-creator cost allocation using Cost Explorer and Cost and Usage Reports. Step Functions cross-account workflows (using IAM roles) orchestrate the multi-account pipeline. Option B uses a single account, losing isolation and blast radius benefits. Option C is overly complex — you'd need N content creator accounts each with full pipeline capabilities. Option D creates 10,000+ accounts which is unmanageable.

---

### Question 56
An organization uses AWS RAM to share Transit Gateway and several VPC subnets across accounts. They discover that when they update a RAM resource share to add a new subnet, existing workload accounts sometimes experience a brief period where they cannot see the new subnet. The delay varies between 5-30 minutes. This causes issues with their automated deployment pipelines that expect shared subnets to be available immediately after the RAM share is updated.

How should the architect address this?

A) Use RAM's eventually consistent sharing model by implementing a retry mechanism with exponential backoff in the deployment pipeline. Before creating resources in shared subnets, validate subnet availability using ec2:DescribeSubnets with a waiter.
B) Pre-share all subnets before they're needed. Maintain a pool of pre-shared subnets that deployment pipelines can use immediately.
C) Replace RAM sharing with cross-account VPC peering for each workload account, as peering provides immediate connectivity.
D) Use EventBridge to detect RAM share acceptance events. Trigger the deployment pipeline only after the event confirms the subnet is shared with the target account.

**Correct Answer: A**

**Explanation:** RAM resource sharing is eventually consistent. When new subnets are added to a resource share, there can be a propagation delay before participant accounts see the new resources. The correct approach is to implement resilience in the deployment pipeline: use ec2:DescribeSubnets with retries and exponential backoff to verify subnet visibility before attempting to create resources. This is a common pattern for handling eventual consistency in distributed AWS services. Option B works but reduces flexibility and wastes IP address space. Option C replaces the architecture entirely for a timing issue. Option D — EventBridge events for RAM share updates exist but the underlying propagation delay to the participant account remains, so the pipeline might still fail.

---

### Question 57
A company needs to provide temporary AWS account access to external auditors. The auditors need read-only access to specific accounts for 30 days. The company uses AWS IAM Identity Center with an external IdP (Azure AD). The auditors have Azure AD accounts but should not have the same access as internal employees. After the audit period, all access must be automatically revoked.

What is the MOST secure approach?

A) Create temporary IAM users in each audited account with read-only policies. Set password expiration to 30 days. Delete the users manually after the audit.
B) Create a dedicated permission set in IAM Identity Center with ReadOnlyAccess policy. Create a time-boxed group in Azure AD for auditors with a 30-day lifecycle. Assign the auditor group to the permission set for specific accounts. Configure Azure AD to automatically remove users from the group after 30 days, which revokes SSO access.
C) Share IAM role credentials with auditors via Secrets Manager with automatic rotation. Set the secret to expire after 30 days.
D) Create a dedicated AWS account for auditors. Replicate necessary logs and configurations to this account using CloudFormation. The account is closed after 30 days.

**Correct Answer: B**

**Explanation:** Leveraging the existing IAM Identity Center + Azure AD integration is the most secure and manageable approach. A dedicated permission set with ReadOnlyAccess scoped to specific accounts provides least-privilege access. Azure AD's group lifecycle management (or access review features) can automatically remove auditors from the group after 30 days, which automatically revokes their SSO access. This eliminates the need for manual cleanup and leverages existing identity infrastructure. Option A creates long-lived credentials and relies on manual deletion. Option C shares credentials which is a security anti-pattern. Option D is overly complex and may not provide real-time access to live resources.

---

### Question 58
An organization is implementing a data perimeter strategy using AWS Organizations. They need to ensure that: no data can leave the organization boundary via S3, no external principals can access organization S3 buckets, and VPC endpoints are the only network path for S3 access. The solution must work across 200 accounts with minimal per-account configuration.

What combination of controls implements a complete S3 data perimeter?

A) Use SCPs with aws:ResourceOrgID conditions to prevent principals from accessing S3 buckets outside the organization. Use S3 bucket policies with aws:PrincipalOrgID to prevent external access. Use SCPs to deny S3 access unless through a VPC endpoint using aws:SourceVpce conditions.
B) Use S3 Block Public Access at the organization level. Use SCPs to deny s3:PutBucketPolicy with a condition preventing policies that reference external principals.
C) Use SCPs with three controls: (1) Deny S3 actions where aws:ResourceOrgID doesn't match the organization (prevents data exfiltration to external buckets), (2) Deploy S3 bucket policies via StackSets with aws:PrincipalOrgID conditions (prevents external access to organization buckets), (3) Deny S3 actions where aws:SourceVpce is not in an approved list of VPC endpoints (forces VPC endpoint usage). Combine with S3 Block Public Access at the organization level.
D) Use AWS Firewall Manager with Network Firewall to inspect and block S3 traffic leaving the VPC. Use DNS Firewall to restrict S3 DNS resolution to VPC endpoint DNS names.

**Correct Answer: C**

**Explanation:** A complete S3 data perimeter has three components: (1) Identity perimeter — S3 bucket policies restrict access to organization principals (aws:PrincipalOrgID). (2) Resource perimeter — SCPs prevent organization principals from accessing buckets outside the organization (aws:ResourceOrgID). (3) Network perimeter — SCPs require S3 access through approved VPC endpoints (aws:SourceVpce). S3 Block Public Access at the organization level adds an additional layer. This approach works across all 200 accounts with SCPs (organization-level) and StackSets (bucket policies). Option A is close but doesn't mention organization-level S3 Block Public Access. Option B only addresses public access, not cross-account or network perimeter. Option D operates at the network level but doesn't provide identity or resource perimeter controls.

---

### Question 59
A company has a complex AWS Organizations structure with 5 levels of nested OUs. They need to troubleshoot an access denied error for a Lambda function in a deeply nested account. The function is trying to call dynamodb:PutItem but receives AccessDenied. The Lambda function's execution role has the correct DynamoDB permissions. Multiple SCPs exist at various levels of the hierarchy.

What is the MOST efficient approach to diagnose the SCP issue?

A) Use IAM Policy Simulator in the affected account to test the Lambda role's permissions. The simulator evaluates SCPs along with IAM policies.
B) Review SCPs at each of the 5 OU levels plus the root manually. For each SCP, check if dynamodb:PutItem is allowed/denied for the Lambda role's conditions.
C) Use AWS CloudTrail to find the exact AccessDenied event. The error response includes details about which policy (IAM or SCP) caused the denial. Use AWS Organizations API to list all SCPs in the account's OU path and evaluate the effective permissions using the GetEffectivePermissions API.
D) Use the AWS Organizations console to view the effective SCP for the account, which shows the intersection of all SCPs from the Root to the account's OU. Check if dynamodb:PutItem is in the effective allowed actions.

**Correct Answer: A**

**Explanation:** IAM Policy Simulator evaluates the complete permissions chain including SCPs, IAM policies, resource-based policies, and permission boundaries. By testing the Lambda execution role against the dynamodb:PutItem action, the simulator shows whether the action is allowed or denied and identifies which policy caused the denial. This is the most efficient single tool for diagnosing permission issues in complex OU hierarchies. Option B is time-consuming with 5 levels. Option C — CloudTrail shows the denial but doesn't always detail which specific SCP caused it, and there is no GetEffectivePermissions API. Option D — the Organizations console doesn't show a pre-computed "effective SCP" view, though you can view SCPs per OU.

---

### Question 60
A company uses Control Tower and wants to implement customizations that run after every account is provisioned. The customizations include: deploying a VPC with specific CIDR ranges, enabling AWS Config rules, creating SNS topics for alerting, and configuring AWS Backup policies. Different OUs require different customization parameters. The company has 200 accounts and provisions approximately 5 new accounts per week.

What is the MOST maintainable approach to implement these customizations?

A) Use Control Tower Customizations for AWS Control Tower (CfCT) solution. Define customizations as CloudFormation templates organized by OU. CfCT automatically applies customizations to new accounts via lifecycle events and can update existing accounts when templates change.
B) Create Lambda functions triggered by Control Tower lifecycle events. Each Lambda deploys the required resources using the AWS SDK directly in the new account.
C) Use Control Tower Account Factory custom blueprints with Service Catalog products. Create different blueprint products for each OU with the appropriate parameters. Account requesters select the blueprint during account provisioning.
D) Deploy all customizations using CloudFormation StackSets with OU-based targeting. Manually run StackSet operations after each account is provisioned.

**Correct Answer: A**

**Explanation:** Customizations for AWS Control Tower (CfCT) is an AWS solution specifically designed for this purpose. It uses a manifest file to define which CloudFormation templates apply to which OUs/accounts. CfCT hooks into Control Tower lifecycle events to automatically apply customizations to new accounts. When templates are updated, CfCT can push updates to all affected accounts. The OU-based organization of customizations supports different parameters per OU. Option B requires maintaining custom Lambda code for each customization. Option C requires account requesters to manually select blueprints and doesn't handle updates to existing accounts. Option D requires manual StackSet operations and doesn't automate new account customization.

---

### Question 61
A company has 150 accounts in AWS Organizations and wants to centralize IAM role management. They want to ensure that: a specific set of mandatory roles exists in every account (security scanner, break-glass, operations), the roles have consistent policies across accounts, roles are automatically deployed to new accounts, and role policies can be updated centrally without modifying each account individually.

What architecture provides the MOST centralized and automated role management?

A) Use CloudFormation StackSets deployed from the management account targeting the organization root. Define the mandatory roles in a CloudFormation template. Use auto-deployment for new accounts. Update the template to push policy changes across all accounts.
B) Use IAM Identity Center permission sets to create the mandatory roles. Permission sets automatically deploy roles to assigned accounts.
C) Create the roles using a Terraform module deployed via Account Factory for Terraform (AFT).
D) Use AWS Service Catalog with portfolio sharing to create an IAM role product. Each account provisions the product to create the roles.

**Correct Answer: A**

**Explanation:** CloudFormation StackSets with organization-level auto-deployment provide the most centralized role management. The StackSet template defines all mandatory roles with their policies. Auto-deployment ensures new accounts get the roles automatically when they join the organization. Template updates propagate to all accounts via StackSet update operations. The management account maintains control. Option B — IAM Identity Center permission sets are designed for human user access through SSO, not for service roles or break-glass roles that need to exist permanently in accounts. Option C works for Terraform-based organizations but adds AFT dependency. Option D requires each account to provision the product, which is not automatic.

---

### Question 62
A company needs to ensure that all VPCs created in their organization use specific DNS configurations: DNS resolution must be enabled, DNS hostnames must be enabled, and a specific DHCP option set (pointing to corporate DNS servers) must be associated. The architecture uses shared VPCs from a networking account as well as account-level VPCs for isolated workloads.

What combination of controls enforces these DNS requirements?

A) Use SCPs to deny ec2:CreateVpc unless specific DNS parameters are set. Use AWS Config rules to detect VPCs with incorrect DHCP option sets. Deploy the standard DHCP option set to each account via StackSets.
B) Use Control Tower proactive controls (CloudFormation Guard) to validate that CloudFormation templates creating VPCs include correct DNS settings. Complement with detective AWS Config rules (vpc-dns-resolution-check and a custom rule for DHCP options) with auto-remediation. Deploy the corporate DHCP option set to each account and region via StackSets.
C) Use a Service Catalog product as the only approved method for VPC creation. The product template includes correct DNS settings. Use SCPs to deny ec2:CreateVpc for all principals except the Service Catalog service role.
D) Use AWS Network Manager to centrally manage all VPC DNS configurations across the organization.

**Correct Answer: B**

**Explanation:** A multi-layer approach provides the most comprehensive enforcement. Proactive controls via CloudFormation Guard rules prevent non-compliant VPCs from being created through CloudFormation. Detective Config rules identify non-compliant VPCs created through other means (console, CLI), and auto-remediation corrects the configuration. StackSets pre-deploy the DHCP option set to each account/region so it's available for association. Option A — SCPs don't support conditions on VPC DNS parameters directly. Option C is too restrictive and blocks legitimate VPC creation methods. Option D — Network Manager doesn't manage VPC DNS configurations.

---

### Question 63
A solutions architect is designing an architecture where a central data platform account needs to provide cross-account access to Amazon Redshift clusters. Teams in 20 workload accounts need to query specific schemas and tables based on their team's authorization. The solution must prevent teams from accessing data belonging to other teams and must work without sharing database credentials.

What is the MOST secure and manageable approach?

A) Use Redshift datashares to share specific schemas and tables with each workload account's Redshift cluster. Each team gets access only to their authorized datashare. Datashares use IAM-based authorization without requiring database credentials.
B) Create database users for each team in the central Redshift cluster. Distribute credentials via Secrets Manager with cross-account sharing.
C) Use Redshift Spectrum with cross-account access to an S3 data lake. Each team's IAM role has access to specific S3 prefixes corresponding to their authorized data.
D) Use AWS Lake Formation cross-account data sharing with column-level security. Register Redshift tables in the Lake Formation catalog. Grant cross-account permissions at the table and column level.

**Correct Answer: A**

**Explanation:** Redshift datashares provide native cross-account data sharing with granular control at the schema and table level. Each workload account can access shared data through their own Redshift cluster (or Redshift Serverless) without needing database credentials in the central cluster. The data platform account creates datashares for each team with only the authorized schemas/tables. Consumer accounts create databases from the datashares. This approach provides the best combination of security (no credential sharing, IAM-based authorization), granularity (schema/table level), and manageability. Option B distributes credentials which is less secure. Option C requires data to be in S3, not Redshift. Option D works but adds Lake Formation complexity and is better suited for S3-based data.

---

### Question 64
An organization has a compliance requirement that all CloudFormation stacks in production accounts must be created with termination protection enabled and must use an IAM role for deployment (not the caller's permissions). This ensures auditability and prevents accidental stack deletion.

What is the MOST effective way to enforce these requirements across the organization?

A) Create an SCP that denies cloudformation:CreateStack unless the request includes EnableTerminationProtection=true and a RoleARN parameter. Use conditions on cloudformation:RoleArn to ensure it's not null.
B) Create a Config rule that checks existing stacks for termination protection and service role. Use auto-remediation to enable termination protection. Alert on stacks without service roles.
C) Use a Control Tower proactive control with CloudFormation Guard rules that validate templates include termination protection and a service role. Complement with an SCP that denies cloudformation:CreateStack unless specific conditions are met.
D) Only allow stack creation through a CI/CD pipeline that automatically adds termination protection and uses a service role. Block direct CloudFormation access using SCPs.

**Correct Answer: C**

**Explanation:** The combination of proactive controls (CloudFormation Guard) and SCPs provides comprehensive enforcement. CloudFormation Guard rules validate template configurations before deployment. SCPs provide an additional enforcement layer at the API level — the SCP can deny cloudformation:CreateStack unless the request includes the required parameters. Together, they prevent non-compliant stacks from being created regardless of the deployment method. Option A only covers SCPs without proactive validation. Option B is detective, not preventive. Option D is overly restrictive and doesn't account for legitimate use cases outside CI/CD.

---

### Question 65
A company with 80 accounts discovers that several development accounts have accumulated orphaned resources (unused EBS volumes, unattached Elastic IPs, stopped EC2 instances older than 30 days) that are incurring unnecessary costs. They want to implement an automated cleanup solution that respects exceptions (resources tagged as "retain") and operates across all development accounts.

What is the MOST operationally safe automated cleanup solution?

A) Deploy a Lambda function in each development account that runs daily, identifies orphaned resources, and deletes them after checking for the "retain" tag. Deploy via StackSets.
B) Use AWS Config rules with auto-remediation to delete orphaned resources. Create separate rules for each resource type (unused EBS volumes, unattached EIPs, stopped instances). Exemption is based on the "retain" tag configured in the Config rule.
C) Create a centralized cleanup solution using Systems Manager Automation. Create an SSM document that identifies and deletes orphaned resources (checking for "retain" tag exemptions). Use a maintenance window to run the document across development accounts via Organization-level SSM. Generate a pre-deletion report stored in S3. Implement a 48-hour delay between identification and deletion, during which teams can tag resources for retention.
D) Enable AWS Trusted Advisor organization view. Use Trusted Advisor's cost optimization checks to identify orphaned resources. Export findings to S3 and process with Lambda for deletion.

**Correct Answer: C**

**Explanation:** This approach prioritizes operational safety with a comprehensive solution. The centralized SSM Automation document handles multiple resource types in a single workflow. The 48-hour delay between identification and deletion provides a safety window for teams to review and tag resources they want to retain. Pre-deletion reports stored in S3 provide audit trails. Organization-level SSM runs the automation across all development accounts without per-account Lambda deployment. Option A depletes without a safety delay. Option B's auto-remediation could delete resources immediately without review. Option D only identifies resources; Trusted Advisor doesn't provide deletion capability.

---

### Question 66
A financial services company needs to implement a solution where any changes to SCPs, OU structure, or account assignments must go through a GitOps workflow. All organizational changes must be version-controlled, peer-reviewed, and automatically applied. Manual changes made through the console must be detected and reverted.

What architecture implements this GitOps model for AWS Organizations management?

A) Store all SCP definitions, OU structure, and account assignments in a Git repository. Use AWS CodePipeline triggered by Git commits to deploy changes via CloudFormation (for SCPs and OUs). Implement a drift detection Lambda that periodically compares the actual organization state with the Git repository and reverts unauthorized changes.
B) Use Terraform with the AWS Organizations provider to manage all organizational resources. Store Terraform state in S3 with DynamoDB locking. Use a CI/CD pipeline for plan/apply workflow. Implement a Terraform Cloud sentinel policy for additional validation. Deploy a periodic reconciliation Lambda that runs terraform plan to detect drift and terraform apply to revert it.
C) Use AWS Control Tower's built-in drift detection to identify manual changes. All changes must go through Control Tower's console.
D) Export the organization configuration to a YAML file in Git. Use a custom Python script to apply changes from Git. Run the script manually after peer review.

**Correct Answer: B**

**Explanation:** Terraform provides the most comprehensive GitOps model for AWS Organizations. The Organizations provider manages SCPs, OUs, accounts, and policies as code. CI/CD pipeline with plan/apply workflow enables peer review via pull requests. Terraform state tracking enables precise drift detection — periodic terraform plan runs detect any manual changes. Terraform apply with auto-approve reverts unauthorized modifications. Sentinel policies add pre-apply validation. Option A's CloudFormation approach works but drift detection is less precise than Terraform's state management. Option C doesn't support GitOps workflow. Option D lacks automation and CI/CD integration.

---

### Question 67
A company runs a centralized Amazon EKS cluster in a shared services account. Teams from 15 workload accounts need to deploy applications to the EKS cluster. Each team should only manage their own namespace. The company uses AWS IAM Identity Center for identity management. EKS cluster access must be auditable and follow the principle of least privilege.

How should cross-account EKS access be implemented?

A) Create IAM roles in each workload account that trust the EKS cluster account. Map these roles to Kubernetes RBAC roles/bindings scoped to team-specific namespaces using EKS access entries. Teams assume their workload account role, then authenticate to EKS using the role mapping.
B) Create Kubernetes service accounts with tokens for each team. Store tokens in Secrets Manager and share cross-account. Teams use tokens directly to authenticate to the cluster.
C) Use a shared kubectl configuration file stored in S3. Each team downloads the kubeconfig and uses their AWS credentials to authenticate.
D) Create IAM users in the EKS cluster account for each team member. Map users to Kubernetes RBAC in the aws-auth ConfigMap.

**Correct Answer: A**

**Explanation:** EKS access entries (the newer EKS-native access management) provide the cleanest cross-account access. IAM roles in workload accounts trust the EKS cluster account. EKS access entries map these cross-account IAM role ARNs to specific Kubernetes RBAC groups and namespaces. Teams use their workload account credentials to assume their role, which is then authenticated by EKS. This provides: cross-account access without credential sharing, namespace-level isolation via RBAC, auditability through CloudTrail (role assumption) and EKS audit logs. Option B shares long-lived credentials. Option C doesn't provide per-team isolation. Option D creates IAM users which is an anti-pattern.

---

### Question 68
An organization is evaluating whether to use AWS RAM sharing or cross-account IAM roles for providing access to a centralized Amazon RDS database from 25 application accounts. The database is in a shared data account. Applications need different levels of access (read-only, read-write) based on the account type.

Which approach is MOST appropriate and why?

A) Use RAM to share the RDS database with all 25 accounts. RAM handles the cross-account access and permissions automatically.
B) Use cross-account IAM roles in the data account with different policies for read-only and read-write access. Application accounts assume the appropriate role via STS AssumeRole. Combined with RDS Proxy for connection management and IAM database authentication.
C) Use VPC peering from each application account to the data account. Applications connect directly to the RDS endpoint using database credentials stored in their local Secrets Manager.
D) Create read replicas of the RDS database in each application account that needs read-only access. Only the read-write accounts connect to the primary.

**Correct Answer: B**

**Explanation:** Cross-account IAM roles provide the most flexible and secure access pattern for RDS. Different roles can be created for different access levels (read-only IAM role for read accounts, read-write role for write accounts). RDS Proxy with IAM authentication eliminates the need for database credentials and provides connection pooling. Applications assume the appropriate cross-account role, and IAM authentication tokens provide short-lived access. Option A — RAM supports sharing RDS DB clusters (Aurora) but doesn't support sharing standard RDS instances, and RAM sharing alone doesn't handle fine-grained read/write access control. Option C uses static credentials and lacks IAM-based access control. Option D creates unnecessary infrastructure overhead and cost.

---

### Question 69
A company uses AWS Organizations and needs to implement a mechanism to prevent accidental deletion of the organization or its OUs. Several incidents have occurred where junior administrators nearly deleted production OUs through the console.

What combination of controls provides the MOST robust protection?

A) Restrict Organizations console access to senior administrators using IAM policies. Enable MFA for all administrators with Organizations access.
B) Create an SCP that denies organizations:DeleteOrganizationalUnit and organizations:DeleteOrganization for all accounts including a condition that requires a specific tag "DeletionApproved: true" to be present. Implement IAM policies for the management account that deny destructive Organizations actions for non-senior roles. Enable CloudTrail alerting on Organizations modification events. Use AWS Organizations' built-in protection that requires removing all accounts from an OU before deletion.
C) Use AWS Config rule to detect OU deletions and automatically recreate them.
D) Create a Lambda function that continuously monitors the OU structure and alerts on any changes.

**Correct Answer: B**

**Explanation:** Multiple layers of protection are needed. SCPs deny destructive actions (DeleteOrganizationalUnit, DeleteOrganization) with a condition requiring an explicit approval tag — this prevents both accidental and unauthorized deletion. However, SCPs don't apply to the management account, so IAM policies in the management account must restrict destructive actions for non-senior roles. CloudTrail alerting provides near-real-time notification of any organizational structure changes. AWS Organizations' built-in requirement to remove all accounts before OU deletion adds another natural safeguard. Option A only addresses human access, not programmatic. Option C is reactive, not preventive. Option D is detective only and adds operational overhead.

---

### Question 70
A solutions architect is designing a multi-Region, multi-account disaster recovery strategy. The organization has 40 production accounts running workloads in us-east-1 (primary) with DR in us-west-2. Each account's DR resources must be automatically deployed and configured in us-west-2 when a disaster is declared. The DR environment should have minimal running costs during normal operations.

What architecture provides the MOST cost-effective and automated DR solution?

A) Deploy full DR infrastructure in us-west-2 for all accounts but with instances stopped. Use AWS Backup cross-region backup for data. During DR activation, use Systems Manager Automation to start instances across all accounts via organization-level automation.
B) Use CloudFormation StackSets to maintain DR infrastructure templates for all accounts. During normal operations, only deploy networking, DNS, and data replication (RDS cross-region replicas, S3 CRR). On DR activation, deploy the full StackSet which provisions compute, application layers, and updates Route 53 failover records. Use Step Functions to orchestrate the multi-account DR activation sequence.
C) Use AWS Elastic Disaster Recovery (DRS) for all EC2 instances across all accounts. DRS maintains lightweight replication instances in us-west-2 and fully provisions instances during failover.
D) Pre-deploy everything in us-west-2 at full scale with active-active configuration using Route 53 weighted routing. This eliminates DR activation time.

**Correct Answer: B**

**Explanation:** This approach optimizes cost during normal operations while enabling automated DR activation. Normal-state costs are limited to networking infrastructure, data replication (RDS read replicas, S3 cross-region replication), and Route 53 configurations. CloudFormation StackSets ensure consistent DR templates across all 40 accounts. During DR activation, Step Functions orchestrates the sequence: deploy StackSets (compute, apps), verify deployments, promote RDS replicas, update Route 53 failover records. Option A's stopped instances still incur EBS storage costs for all accounts. Option C works for EC2 but doesn't cover managed services. Option D eliminates DR activation delay but doubles infrastructure costs.

---

### Question 71
A company needs to share an AWS CodeArtifact domain across their organization for centralized package management. Development teams in 60 accounts should be able to publish and consume packages, while production accounts should only consume packages. The solution must prevent developers from consuming packages from public upstream repositories that haven't been approved.

How should the architect configure CodeArtifact?

A) Create a CodeArtifact domain in the shared services account. Create repositories for each team. Use RAM to share the domain with the organization. Configure domain policies that grant publish permissions to development OUs and consume-only permissions to the production OU. Create an upstream repository that connects to public repositories, with an approval workflow using Lambda that promotes vetted packages.
B) Create separate CodeArtifact domains in each account. Synchronize packages using Lambda functions.
C) Use S3 as a package repository. Share the S3 bucket via RAM with the organization.
D) Create a single CodeArtifact repository in the shared services account. Grant all accounts the same permissions. Allow direct upstream connections to public repositories.

**Correct Answer: A**

**Explanation:** A centralized CodeArtifact domain with granular policies provides the best solution. The domain-level resource policy can differentiate access by OU — development OUs get publish+consume permissions, production OU gets consume-only. RAM sharing enables organization-wide access. For public package security, creating an upstream repository with a controlled connection to public registries (npm, PyPI, Maven) and an approval workflow ensures only vetted packages are available. Lambda can automate the approval process, checking packages against security scanning results before promoting them. Option B creates management overhead. Option C doesn't provide package management features. Option D lacks access control and security vetting.

---

### Question 72
An enterprise operating under strict compliance has a requirement that all data stored in AWS must be encrypted with KMS keys that are NOT shared outside the organization. They need a control that prevents any principal from creating KMS key policies or grants that reference external accounts or principals outside the organization.

How should this be enforced?

A) Use an SCP that denies kms:CreateKey, kms:PutKeyPolicy, and kms:CreateGrant unless the policy/grant references only principals within the organization. Use conditions on kms:GrantIsForAWSResource and aws:PrincipalOrgID.
B) Use an SCP that denies kms:PutKeyPolicy and kms:CreateGrant with a condition that checks if the grantee principal is outside the organization using kms:GranteePrincipal with a condition operator checking for the organization ID pattern.
C) Use AWS Config rules to detect KMS keys with external access and automatically modify the key policy to remove external references.
D) Use KMS key policies that only allow access from within the organization (aws:PrincipalOrgID). Deploy these policies via StackSets as the default for all new keys.

**Correct Answer: B**

**Explanation:** SCPs with conditions on kms:GranteePrincipal can evaluate whether a KMS grant or key policy references external principals. By denying kms:PutKeyPolicy and kms:CreateGrant when the grantee principal doesn't match the organization's account patterns, external sharing is prevented at the API level. This is the strongest preventive control. Option A's approach is conceptually correct but the conditions described are not precise — kms:GrantIsForAWSResource checks if the grant is for an AWS service, not organization membership. Option C is reactive, not preventive. Option D deploys good key policies but doesn't prevent someone from modifying them later.

---

### Question 73
A company uses AWS Organizations with 100 accounts. They need to implement a solution where any account that becomes non-compliant with critical security requirements (no active CloudTrail, disabled GuardDuty, or removed mandatory IAM roles) is automatically quarantined — moved to a restricted OU that limits the account to only security remediation actions until the issue is fixed.

What architecture implements this automated quarantine?

A) Use AWS Config organizational rules to detect non-compliance. Create EventBridge rules that trigger on Config compliance change events. A Step Functions workflow evaluates the severity, and if critical, calls organizations:MoveAccount to move the non-compliant account to the quarantine OU. The quarantine OU has an SCP that denies all actions except those needed for remediation. A separate workflow monitors the quarantine OU and moves accounts back when compliant.
B) Use GuardDuty findings to trigger quarantine actions. When high-severity findings are detected, move the account to quarantine.
C) Use Security Hub's automated response and remediation to quarantine accounts.
D) Deploy a Lambda function that polls each account every hour for compliance and triggers quarantine if needed.

**Correct Answer: A**

**Explanation:** This architecture provides automated, event-driven quarantine. AWS Config organizational rules continuously monitor compliance across all accounts. EventBridge captures compliance change events. Step Functions orchestrates the evaluation and quarantine logic — checking severity, verifying the compliance state, and moving the account. The quarantine OU's SCP limits actions to only security remediation (restoring CloudTrail, enabling GuardDuty, deploying IAM roles). A reverse workflow monitors quarantined accounts and automatically restores them when compliant. Option B — GuardDuty findings are threat-based, not configuration-compliance-based. Option C — Security Hub doesn't natively support account quarantine. Option D — polling is inefficient compared to event-driven architecture.

---

### Question 74
A company needs to implement a solution for managing cross-account access to AWS Secrets Manager secrets. A central secrets management account stores shared infrastructure secrets (database passwords, API keys, certificates). Application accounts need access to specific secrets based on their environment (dev/staging/prod) and team membership.

What is the MOST secure and scalable approach?

A) Store all secrets in the central account. Attach resource policies to each secret granting access to specific accounts. Use IAM roles in application accounts that assume a cross-account role in the secrets account to retrieve secrets.
B) Replicate secrets to each application account using Secrets Manager's multi-Region replication feature with cross-account permissions.
C) Store secrets in the central account with resource-based policies using aws:PrincipalOrgPaths conditions to grant access based on OU membership (e.g., production secrets accessible only to accounts in the Production OU path). Application accounts access secrets directly using the resource policy — no cross-account role assumption needed. Encrypt secrets with KMS keys whose key policies also use aws:PrincipalOrgPaths conditions.
D) Use AWS Systems Manager Parameter Store SecureStrings instead of Secrets Manager. Share parameters using RAM.

**Correct Answer: C**

**Explanation:** Using resource-based policies on secrets with aws:PrincipalOrgPaths conditions provides the most scalable approach. aws:PrincipalOrgPaths evaluates the full OU path of the requesting principal, enabling environment-based access (production OU accounts access production secrets, dev OU accounts access dev secrets). Resource policies allow direct cross-account access without intermediate role assumption. KMS key policies with matching conditions ensure decryption is also scoped correctly. New accounts automatically get access based on their OU placement. Option A requires per-account policy entries which don't scale. Option B — Secrets Manager replication is multi-Region, not cross-account. Option D — Parameter Store doesn't support RAM sharing.

---

### Question 75
A large enterprise is migrating from a legacy on-premises LDAP-based access control system to AWS. They need to map their existing organizational structure (departments, teams, roles) to an AWS multi-account model. The LDAP directory has 5,000 users across 50 teams in 8 departments. Each team currently has access to specific applications and environments. The company wants to maintain similar access granularity in AWS while leveraging AWS-native identity management.

What is the recommended identity and access architecture?

A) Migrate all LDAP users to IAM users distributed across AWS accounts based on their team membership. Use IAM groups within each account for permission management.
B) Integrate the LDAP directory with AWS IAM Identity Center using AD Connector or AWS Managed Microsoft AD. Map LDAP groups to IAM Identity Center groups. Create permission sets that mirror existing role-based access. Assign groups to specific accounts/OUs with appropriate permission sets. Use ABAC with session tags derived from LDAP attributes for fine-grained access control.
C) Use Amazon Cognito User Pools for workforce identity management. Federate with the LDAP directory. Create Cognito groups for each team.
D) Maintain the LDAP directory on-premises. Use SAML federation directly with each AWS account's IAM SAML provider. Configure trust policies per account.

**Correct Answer: B**

**Explanation:** AWS IAM Identity Center is the recommended service for workforce identity management in multi-account environments. AD Connector or AWS Managed Microsoft AD enables LDAP integration, preserving the existing directory. LDAP groups map to IAM Identity Center groups, maintaining the organizational structure. Permission sets define access levels (equivalent to LDAP roles). Group-to-account assignments with permission sets replicate the existing access model. ABAC with session tags derived from LDAP attributes (department, team, role) provides fine-grained, attribute-based access without creating hundreds of individual policies. Option A creates thousands of IAM users which is unmanageable. Option C — Cognito is for customer identity, not workforce. Option D requires per-account SAML configuration for 50+ accounts, creating management overhead.

---

## Answer Key

| Q# | Answer | Q# | Answer | Q# | Answer | Q# | Answer | Q# | Answer |
|----|--------|----|--------|----|--------|----|--------|----|--------|
| 1  | D      | 16 | B      | 31 | A      | 46 | D      | 61 | A      |
| 2  | A      | 17 | C      | 32 | B      | 47 | B      | 62 | B      |
| 3  | A      | 18 | D      | 33 | A      | 48 | C      | 63 | A      |
| 4  | C      | 19 | B      | 34 | A      | 49 | B      | 64 | C      |
| 5  | D      | 20 | D      | 35 | C      | 50 | B      | 65 | C      |
| 6  | D      | 21 | C      | 36 | C      | 51 | B      | 66 | B      |
| 7  | C      | 22 | C      | 37 | B      | 52 | A      | 67 | A      |
| 8  | A      | 23 | C      | 38 | A      | 53 | A      | 68 | B      |
| 9  | A      | 24 | A      | 39 | B      | 54 | D      | 69 | B      |
| 10 | B      | 25 | B      | 40 | A      | 55 | A      | 70 | B      |
| 11 | B      | 26 | D      | 41 | A      | 56 | A      | 71 | A      |
| 12 | A      | 27 | C      | 42 | B      | 57 | B      | 72 | B      |
| 13 | B      | 28 | C      | 43 | B      | 58 | C      | 73 | A      |
| 14 | B      | 29 | C      | 44 | B      | 59 | A      | 74 | C      |
| 15 | C      | 30 | B      | 45 | C      | 60 | A      | 75 | B      |

---

## Domain Distribution

| Domain | Questions | Count |
|--------|-----------|-------|
| D1: Design Solutions for Organizational Complexity | 1-15, 26, 37, 44, 49, 75 | 20 |
| D2: Design for New Solutions | 16-25, 27, 32, 34, 40, 47, 51, 55, 62, 63, 67, 68, 71 | 22 |
| D3: Continuous Improvement for Existing Solutions | 28, 33, 43, 54, 56, 59, 60, 65, 66, 69, 73 | 11 |
| D4: Accelerate Workload Migration and Modernization | 10, 14, 23, 36, 41, 48, 57, 70, 74 | 9 |
| D5: Design Solutions for Cost Optimization | 29, 30, 31, 35, 38, 39, 42, 45, 46, 50, 52, 53, 64 | 13 |
