# Domain 4: Policies and Standards Automation — Practice Questions

## 35+ Scenario-Based Questions with Detailed Explanations

---

### Question 1
A company uses AWS Organizations with multiple OUs. The security team wants to ensure that no member account can disable CloudTrail logging. The management account should remain unaffected. What should they do?

**A)** Attach an IAM policy denying `cloudtrail:StopLogging` and `cloudtrail:DeleteTrail` to all users in member accounts.
**B)** Attach an SCP to the root of the organization denying `cloudtrail:StopLogging` and `cloudtrail:DeleteTrail`.
**C)** Attach an SCP to each OU denying `cloudtrail:StopLogging` and `cloudtrail:DeleteTrail`.
**D)** Create a Config rule to detect disabled CloudTrail and auto-remediate.

**Correct Answer: B**

**Explanation:** Attaching the SCP to the root ensures it applies to ALL member accounts and OUs. SCPs do NOT affect the management account, which meets the requirement. Option A would require managing IAM policies in every account, which is not scalable. Option C works but requires attaching to every OU — attaching to root is simpler. Option D is detective/reactive, not preventive.

---

### Question 2
A developer has the `iam:CreateRole` permission and a permission boundary set to the `DeveloperBoundary` managed policy. The developer creates a new role with the `AdministratorAccess` policy attached. What happens when someone assumes the new role?

**A)** The assumed role has full administrator access.
**B)** The assumed role has no permissions because the permission boundary is violated.
**C)** The assumed role has permissions that are the intersection of `AdministratorAccess` and `DeveloperBoundary`.
**D)** The role creation fails because of the permission boundary.

**Correct Answer: C (if no boundary is on the new role) or D (if boundary is required)**

**Explanation:** This is a nuanced question. The permission boundary on the *developer* limits what the developer can do. However, to enforce that newly created roles also have boundaries, you must include a condition in the developer's IAM policy requiring `iam:PermissionsBoundary` when creating roles. Without this condition, the developer CAN create roles without boundaries, and those roles would have the full `AdministratorAccess` permissions (Answer A). With the condition enforced (which is the best-practice pattern), the role creation fails unless the developer attaches a permission boundary (Answer D). The exam expects you to know this pattern.

**Best practice answer: D** — the IAM policy should use the `iam:PermissionsBoundary` condition key to require a boundary on all created roles.

---

### Question 3
A company has 50 AWS accounts in an organization. They want to ensure all EC2 instances across all accounts have a `CostCenter` tag. Non-compliant instances should be flagged and automatically tagged with a default value. What solution should they implement?

**A)** Create a tag policy in Organizations enforcing the `CostCenter` tag, and use AWS Config auto-remediation.
**B)** Use an SCP to deny `ec2:RunInstances` without the `CostCenter` tag.
**C)** Deploy an organization Config rule with auto-remediation using an SSM Automation document that adds the default tag.
**D)** Use AWS Service Catalog with TagOptions to enforce the tag.

**Correct Answer: C**

**Explanation:** The requirement has two parts: (1) detect non-compliance, and (2) auto-remediate. An organization Config rule with the `required-tags` managed rule detects non-compliant instances. Auto-remediation with SSM Automation adds the default `CostCenter` tag. Option A detects non-compliance via tag policies but tag policies alone don't auto-remediate. Option B is preventive but doesn't remediate existing instances and requires users to always provide the tag. Option D only applies to Service Catalog provisioned resources.

---

### Question 4
An organization uses AWS Control Tower to manage their multi-account environment. A new team needs accounts provisioned with specific VPC configurations and baseline security tools. The team uses Terraform for infrastructure management. What should the DevOps engineer recommend?

**A)** Use Control Tower Account Factory in the Service Catalog console to manually create accounts.
**B)** Use Account Factory for Terraform (AFT) to automate account provisioning with Terraform-based customizations.
**C)** Write CloudFormation stack sets to deploy into new accounts.
**D)** Use Customizations for Control Tower (CfCT) with CloudFormation.

**Correct Answer: B**

**Explanation:** AFT is specifically designed for Terraform-based account provisioning and customization in Control Tower environments. It provides a GitOps pipeline (CodePipeline/CodeBuild) and supports global and per-account customizations using Terraform. Option A is manual and doesn't use Terraform. Option C doesn't integrate with Control Tower lifecycle events. Option D uses CloudFormation, not Terraform.

---

### Question 5
A security team discovers that a Config rule is showing an S3 bucket as NON_COMPLIANT because server-side encryption is not enabled. They want this to be automatically fixed. What is the MOST efficient approach?

**A)** Create an EventBridge rule to detect Config compliance change events and trigger a Lambda function.
**B)** Configure auto-remediation on the Config rule using the `AWS-EnableS3BucketEncryption` SSM Automation document.
**C)** Create a CloudWatch alarm for Config compliance metrics and trigger SNS.
**D)** Manually enable encryption on the bucket.

**Correct Answer: B**

**Explanation:** Config natively supports auto-remediation using SSM Automation documents. AWS provides the managed automation document `AWS-EnableS3BucketEncryption` specifically for this purpose. This is the most efficient approach as it requires no custom code. Option A works but requires writing and maintaining a Lambda function. Option C only notifies, doesn't remediate. Option D is manual.

---

### Question 6
A company wants to ensure that IAM Access Analyzer findings for external access to S3 buckets shared with a specific partner account are automatically archived. How should they configure this?

**A)** Create an IAM policy that denies Access Analyzer from creating findings for the partner account.
**B)** Create an archive rule in Access Analyzer with a filter matching the partner account ID.
**C)** Disable Access Analyzer for S3 buckets.
**D)** Modify the S3 bucket policy to not trigger findings.

**Correct Answer: B**

**Explanation:** Archive rules automatically archive findings that match specified criteria. You can create a rule filtering on the principal (partner account ID) and resource type (S3 bucket). Matching findings are automatically archived as expected/intended access. Option A is not a valid approach — you cannot prevent Access Analyzer from creating findings. Option C removes visibility. Option D doesn't affect findings.

---

### Question 7
A DevOps engineer wants to validate that all CloudFormation templates in the CI/CD pipeline meet the organization's security standards before deployment. Templates must have encryption enabled on all S3 buckets and EBS volumes. What approach should they use?

**A)** Use AWS Config rules to detect non-compliance after deployment.
**B)** Use `cfn-guard` in a CodeBuild stage to validate templates against custom Guard rules.
**C)** Use CloudFormation drift detection after deployment.
**D)** Use IAM policies to prevent creation of unencrypted resources.

**Correct Answer: B**

**Explanation:** CloudFormation Guard (cfn-guard) validates CloudFormation templates against policy rules BEFORE deployment (shift-left). Adding cfn-guard validation as a CodeBuild stage in the pipeline catches non-compliant templates before any resources are created. Option A is detective — after deployment. Option C detects drift, not compliance. Option D is runtime enforcement, not template validation.

---

### Question 8
An organization wants to restrict all AWS usage to us-east-1 and eu-west-1 regions across all member accounts. Which approach is MOST effective?

**A)** Use IAM policies in each account with the `aws:RequestedRegion` condition key.
**B)** Attach an SCP to the organization root with a deny statement using the `aws:RequestedRegion` condition key, excluding the two allowed regions.
**C)** Use AWS Config rules to detect resources in unauthorized regions.
**D)** Use Control Tower guardrails for region restriction.

**Correct Answer: B**

**Explanation:** An SCP attached to the root with a deny statement using `aws:RequestedRegion` NOT IN `[us-east-1, eu-west-1]` preventively blocks all API calls in unauthorized regions across all member accounts. The SCP must include exceptions for global services (IAM, Organizations, STS, CloudFront, Route 53, etc.) that operate in us-east-1 even when accessed from other regions. Option A requires per-account management. Option C is detective. Option D may not cover all regions.

---

### Question 9
A company needs to ensure that all RDS instances across 100 accounts comply with encryption-at-rest requirements. Non-compliant instances should be flagged in a centralized dashboard. What solution provides this?

**A)** Enable AWS Config in all accounts with the `rds-storage-encrypted` managed rule and create an organization aggregator.
**B)** Use CloudTrail to monitor `CreateDBInstance` API calls.
**C)** Use Trusted Advisor security checks.
**D)** Deploy Inspector across all accounts.

**Correct Answer: A**

**Explanation:** AWS Config with the `rds-storage-encrypted` managed rule detects unencrypted RDS instances. An organization aggregator collects compliance data from all 100 accounts into a centralized dashboard. Option B only sees API calls, not current state. Option C has limited checks for RDS encryption. Option D scans for vulnerabilities, not configuration compliance.

---

### Question 10
A developer assumes a role in Account B from Account A. The role in Account B has a permission boundary that allows only S3 and DynamoDB access. The developer's identity policy in Account A allows all AWS services. What can the developer do in Account B after assuming the role?

**A)** Access all AWS services because the identity policy in Account A grants full access.
**B)** Access only S3 and DynamoDB as limited by the permission boundary.
**C)** Access nothing because cross-account role assumption ignores permission boundaries.
**D)** Access services allowed by both the role's identity policy and the permission boundary.

**Correct Answer: D**

**Explanation:** When a role is assumed, the effective permissions are the intersection of the role's identity-based policies and its permission boundary. The caller's original permissions in Account A are irrelevant — once the role is assumed, the session operates under the role's policies. The permission boundary limits the role's effective permissions to S3 and DynamoDB, but the role's identity policy must also grant those permissions. The answer is D — the intersection of the role's policies and boundary.

---

### Question 11
An organization uses IAM Identity Center (SSO) with an external IdP (Okta). They want to implement ABAC so that users with the `Department=Engineering` attribute can only access resources tagged `Department=Engineering`. How should this be configured?

**A)** Create separate permission sets for each department.
**B)** Map the IdP's `Department` attribute to a session tag in Identity Center, and use `aws:PrincipalTag/Department` and `aws:ResourceTag/Department` condition keys in permission set policies.
**C)** Create IAM users in each account with appropriate policies.
**D)** Use Organizations tag policies.

**Correct Answer: B**

**Explanation:** ABAC in IAM Identity Center works by mapping identity attributes from the IdP to session tags. When a user authenticates, their `Department` attribute becomes a principal tag. Permission set policies reference `aws:PrincipalTag/Department` and `aws:ResourceTag/Department` to dynamically grant access only to matching resources. This scales without creating per-department permission sets. Option A doesn't scale. Option C defeats SSO purpose. Option D is for tag standardization, not access control.

---

### Question 12
A Config rule detects that an EC2 security group allows SSH from 0.0.0.0/0. The auto-remediation attempts to fix it but fails because the remediation role lacks the necessary `ec2:RevokeSecurityGroupIngress` permission. What happens?

**A)** Config automatically retries with elevated permissions.
**B)** The resource remains NON_COMPLIANT and the remediation failure is logged. The remediation can be retried after fixing the role.
**C)** Config changes the resource status to COMPLIANT to avoid repeated failures.
**D)** The Config rule is automatically disabled.

**Correct Answer: B**

**Explanation:** When auto-remediation fails, the resource remains NON_COMPLIANT. The failure is logged in the Config remediation execution history. You must fix the remediation role's permissions and retry. Config does not automatically retry with elevated permissions, change compliance status, or disable rules. Config supports configurable retry attempts, but these use the same role.

---

### Question 13
A company wants to share an S3 bucket with all current and future accounts in their organization without listing individual account IDs. What is the BEST approach?

**A)** Use an IAM role in each account with a trust policy allowing the S3 bucket.
**B)** Add a bucket policy condition using `aws:PrincipalOrgID` matching the organization ID.
**C)** Share the bucket using AWS RAM.
**D)** Create IAM users in the bucket's account for each external account.

**Correct Answer: B**

**Explanation:** The `aws:PrincipalOrgID` condition key in the S3 bucket policy automatically grants access to all principals in the organization. As new accounts join or leave the organization, access is automatically adjusted. No need to list individual account IDs. This is the scalable, AWS-recommended approach. Option A requires per-account role setup. Option C doesn't support S3 buckets. Option D is not scalable.

---

### Question 14
An organization wants to deploy a standardized set of compliance checks (Config rules) that maps to the CIS AWS Foundations Benchmark across all accounts. What is the MOST efficient approach?

**A)** Manually create Config rules in each account.
**B)** Deploy a conformance pack based on the CIS benchmark template across the organization.
**C)** Write a CloudFormation stack set with Config rules.
**D)** Use Control Tower mandatory guardrails.

**Correct Answer: B**

**Explanation:** Conformance packs are purpose-built for deploying sets of Config rules that map to compliance frameworks. AWS provides a pre-built conformance pack template for the CIS AWS Foundations Benchmark. Deploying it as an organization conformance pack pushes it to all member accounts with aggregated compliance reporting. Option A doesn't scale. Option C works but requires manually maintaining the Config rules. Option D covers only Control Tower guardrails, which don't fully map to CIS.

---

### Question 15
A Control Tower environment detects drift because an SCP was manually modified in the AWS Organizations console. What should the DevOps engineer do?

**A)** Delete the modified SCP and recreate it.
**B)** Re-register the affected OU in Control Tower to resolve the drift.
**C)** Ignore the drift — Control Tower self-heals.
**D)** Reset the landing zone.

**Correct Answer: B**

**Explanation:** When drift is detected in Control Tower (such as modified SCPs), re-registering the affected OU restores the expected guardrail configuration and resolves the drift. Control Tower does not self-heal in all cases. Deleting the SCP could cause additional issues. Resetting the landing zone is excessive for an SCP modification.

---

### Question 16
A Lambda function needs to access DynamoDB tables in three different AWS accounts. What is the MOST secure and manageable approach?

**A)** Embed access keys for each account in the Lambda function's environment variables.
**B)** Create IAM roles in each target account and have the Lambda function assume each role.
**C)** Create resource-based policies on DynamoDB tables in each account allowing the Lambda role.
**D)** Use a single IAM role with permissions for all three accounts.

**Correct Answer: B**

**Explanation:** Cross-account role assumption is the standard pattern. The Lambda function's execution role needs `sts:AssumeRole` permission. Each target account has a role with a trust policy allowing the Lambda role, and an identity policy granting DynamoDB access. This follows least-privilege and is auditable. Option A uses long-lived credentials — never do this. Option C doesn't work for DynamoDB (it doesn't support resource-based policies for cross-account). Option D — a single role can't have permissions in other accounts.

---

### Question 17
An organization wants to enforce that all new EC2 instances created through CloudFormation must use encrypted EBS volumes. What proactive control should they implement?

**A)** An SCP denying `ec2:RunInstances` for unencrypted volumes.
**B)** A CloudFormation Hook using Guard rules that validates EBS encryption before resource creation.
**C)** A Config rule checking for unencrypted volumes after creation.
**D)** An IAM policy with conditions on encryption.

**Correct Answer: B**

**Explanation:** CloudFormation Hooks with Guard rules are **proactive controls** that evaluate resources BEFORE CloudFormation provisions them. The hook can validate that all `AWS::EC2::Volume` and `AWS::EC2::Instance` resources specify encrypted EBS. Non-compliant templates are blocked. This is a proactive guardrail in Control Tower. Option A works but SCPs don't have granular enough condition keys for EBS encryption. Option C is detective. Option D is complex and doesn't cover all scenarios.

---

### Question 18
A company uses Service Catalog to provide pre-approved infrastructure templates to developers. Developers should only be able to launch t3.micro or t3.small instance types from the EC2 product. How should this be enforced?

**A)** Use an IAM policy limiting instance types.
**B)** Apply a template constraint on the product that restricts the InstanceType parameter to t3.micro and t3.small.
**C)** Modify the CloudFormation template to hard-code the instance type.
**D)** Use a launch constraint with limited permissions.

**Correct Answer: B**

**Explanation:** Template constraints in Service Catalog restrict which parameter values users can select. By applying a template constraint that limits `InstanceType` to `t3.micro` and `t3.small`, the Service Catalog product only allows these options. Option A applies account-wide, not just to Service Catalog. Option C removes flexibility for having two allowed options. Option D is about IAM roles, not parameter restrictions.

---

### Question 19
A company needs to generate least-privilege IAM policies based on actual usage patterns for a role that has been running in production for 60 days. What service should they use?

**A)** AWS Trusted Advisor
**B)** IAM Access Analyzer — Policy Generation feature
**C)** AWS Config
**D)** AWS CloudTrail Insights

**Correct Answer: B**

**Explanation:** IAM Access Analyzer's policy generation feature analyzes CloudTrail logs (up to 90 days) to generate a policy based on the actual API calls made by a role. Since the role has 60 days of CloudTrail data, Access Analyzer can generate a precise least-privilege policy. Option A provides general recommendations. Option C checks compliance, not usage. Option D detects anomalies.

---

### Question 20
An SCP attached to the root denies `ec2:TerminateInstances`. An IAM policy in a member account allows `ec2:*`. Can a user in the member account terminate an EC2 instance?

**A)** Yes, because the IAM policy explicitly allows ec2:*.
**B)** No, because the SCP deny overrides the IAM allow.
**C)** Yes, because IAM policies in the account take precedence over SCPs.
**D)** No, unless the user is the root user of the member account.

**Correct Answer: B**

**Explanation:** An explicit deny in an SCP always overrides any IAM allow in a member account. SCPs set the maximum available permissions. Even if the IAM policy grants `ec2:*`, the SCP deny on `ec2:TerminateInstances` blocks the action. This applies to ALL users and roles in member accounts, including the root user (option D is incorrect — SCPs affect root in member accounts).

---

### Question 21
A DevOps team wants to track license compliance for Oracle databases running on EC2. They need to ensure no more than 200 vCPUs are used. What should they use?

**A)** AWS Config rule for EC2 instance types.
**B)** AWS License Manager with a license configuration counting by vCPU and a hard limit of 200.
**C)** CloudWatch metrics for CPU utilization.
**D)** AWS Trusted Advisor service limit checks.

**Correct Answer: B**

**Explanation:** AWS License Manager is designed for exactly this use case. Create a license configuration with counting type set to vCPU, set a hard limit of 200, and associate it with EC2 instances running Oracle. When the limit is reached, new instances cannot be launched. Option A doesn't track licenses. Option C monitors utilization, not licensing. Option D checks AWS service limits, not software licenses.

---

### Question 22
An organization has a suspended OU in AWS Organizations for accounts awaiting closure. What SCP should be attached to this OU?

**A)** The default `FullAWSAccess` SCP.
**B)** An SCP that denies all actions (`"Effect": "Deny", "Action": "*", "Resource": "*"`).
**C)** No SCPs needed.
**D)** An SCP that allows only read operations.

**Correct Answer: B**

**Explanation:** Accounts in a suspended OU should have all actions denied to prevent any usage or changes. Attach an explicit deny-all SCP. Note: you should also keep `FullAWSAccess` attached (required for the deny to take effect in deny-list strategy), and add the deny-all as an additional SCP. The explicit deny overrides the allow, effectively blocking all actions.

---

### Question 23
An organization needs to ensure that all AWS Backup plans comply with a retention policy of at least 30 days across all accounts. What is the MOST centralized approach?

**A)** Create backup policies in AWS Organizations.
**B)** Deploy Config rules in each account.
**C)** Use Control Tower guardrails.
**D)** Create backup vaults with vault lock in each account.

**Correct Answer: A**

**Explanation:** AWS Organizations backup policies allow you to define backup plans centrally and apply them across OUs and accounts. The policy specifies retention (at least 30 days), frequency, and target resource types. Member accounts inherit and cannot override these policies. Option B requires per-account setup. Option C doesn't specifically address backup retention. Option D is about immutability, not policy enforcement.

---

### Question 24
A team uses AWS Config to monitor compliance across 10 accounts. They want to view compliance status of all accounts from a single account. What should they set up?

**A)** An organization Config aggregator in the management account.
**B)** CloudWatch cross-account dashboards.
**C)** A custom Lambda function that queries each account.
**D)** AWS Security Hub with multi-account.

**Correct Answer: A**

**Explanation:** An organization Config aggregator collects Config compliance data from all member accounts and displays it in a single account. The aggregator can be set up in a delegated administrator account or the management account. It provides a centralized view of compliance status across all accounts. Option B shows metrics, not Config compliance. Option C requires custom development. Option D aggregates security findings, not Config compliance specifically.

---

### Question 25
An application team needs to deploy a standardized three-tier web application. They should not need IAM permissions for EC2, RDS, or ELB directly. How should this be provided?

**A)** Give the team full IAM permissions.
**B)** Create a Service Catalog product with a CloudFormation template and a launch constraint that specifies an IAM role with the necessary permissions.
**C)** Create an IAM group for the team with EC2, RDS, and ELB permissions.
**D)** Use Control Tower Account Factory.

**Correct Answer: B**

**Explanation:** Service Catalog with a launch constraint enables users to provision pre-approved products without needing direct IAM permissions for the underlying services. The launch constraint specifies an IAM role that has EC2, RDS, and ELB permissions. Users only need `servicecatalog:ProvisionProduct` permission. This is a core governance pattern.

---

### Question 26
A security engineer needs to identify all S3 buckets, IAM roles, and Lambda functions accessible by external AWS accounts across the entire organization. What is the MOST efficient approach?

**A)** Run a custom script in each account to check resource policies.
**B)** Enable IAM Access Analyzer with the organization as the zone of trust.
**C)** Use AWS Config with custom rules.
**D)** Review CloudTrail logs for cross-account access.

**Correct Answer: B**

**Explanation:** IAM Access Analyzer with the organization as the zone of trust identifies resources accessible from OUTSIDE the organization. It automatically detects external access across supported resource types (S3, IAM roles, Lambda, KMS, SQS, etc.) in all member accounts. No custom scripts or rules needed. Option A doesn't scale. Option C requires custom rule development. Option D is reactive, not comprehensive.

---

### Question 27
A Control Tower environment has proactive guardrails enabled. A developer tries to create an unencrypted RDS instance using CloudFormation. What happens?

**A)** The instance is created and a detective guardrail flags it as non-compliant.
**B)** The CloudFormation stack creation fails because the proactive guardrail blocks the resource.
**C)** The instance is created but is automatically encrypted.
**D)** The developer receives an email notification.

**Correct Answer: B**

**Explanation:** Proactive guardrails use CloudFormation Hooks to evaluate resources BEFORE they are created. If the RDS instance doesn't specify encryption, the hook blocks the CloudFormation operation, and the stack creation fails. This is preventive at the infrastructure-as-code level — the resource is never created.

---

### Question 28
A company uses consolidated billing in AWS Organizations. Account A purchased 10 Reserved Instances for m5.large in us-east-1. Account B runs 5 m5.large On-Demand instances in us-east-1. What happens to Account B's pricing?

**A)** Account B pays full On-Demand pricing because the RIs belong to Account A.
**B)** Account B's 5 instances benefit from Account A's Reserved Instance pricing (RI sharing).
**C)** Account B must purchase its own RIs.
**D)** Only the management account benefits from RI pricing.

**Correct Answer: B**

**Explanation:** By default, Reserved Instance sharing is enabled in AWS Organizations. When Account A has unused RI capacity and Account B has matching usage (same instance type, region, platform), Account B automatically benefits from the RI pricing. This is part of consolidated billing. RI sharing can be disabled per account if desired.

---

### Question 29
A DevOps engineer needs to ensure that any IAM role created in the organization can only be assumed by principals within the organization. What is the BEST approach?

**A)** Use an SCP that requires `aws:PrincipalOrgID` condition in all IAM role trust policies.
**B)** Use Config rules to check trust policies.
**C)** Attach an SCP that denies `sts:AssumeRole` when `aws:PrincipalOrgID` does not match the organization ID.
**D)** Use IAM Access Analyzer.

**Correct Answer: C**

**Explanation:** An SCP that denies `sts:AssumeRole` when `aws:PrincipalOrgID` does NOT match the organization's ID prevents any external principal from assuming roles in member accounts. This is a preventive control that works regardless of how trust policies are configured. Option A is complex to enforce. Option B is detective. Option D identifies issues but doesn't prevent them.

---

### Question 30
Inspector detects a critical vulnerability in an ECR container image used by an ECS service. The DevOps team wants automated notification when critical findings are generated. What architecture should they implement?

**A)** Poll the Inspector API periodically from a Lambda function.
**B)** Configure Inspector to send findings to Security Hub, and create an EventBridge rule for critical findings that triggers an SNS notification.
**C)** Create a CloudWatch alarm based on Inspector metrics.
**D)** Use Trusted Advisor integration.

**Correct Answer: B**

**Explanation:** Inspector findings are automatically sent to Security Hub and EventBridge. Create an EventBridge rule matching Inspector findings with severity CRITICAL, targeting an SNS topic for notifications. This is event-driven and requires no polling. Option A introduces latency and complexity. Option C doesn't have the right metric granularity. Option D doesn't integrate with Inspector.

---

### Question 31
A company wants to opt out of AWS AI services using their data for service improvement across all accounts. What is the MOST efficient approach?

**A)** Contact AWS Support for each account.
**B)** Attach an AI services opt-out policy to the organization root.
**C)** Configure each service individually in each account.
**D)** Use an SCP to deny AI service APIs.

**Correct Answer: B**

**Explanation:** AI services opt-out policies in AWS Organizations allow you to opt out organization-wide by attaching a policy to the root. This ensures all accounts (current and future) are opted out. No per-account configuration needed. Option A doesn't scale. Option C is manual. Option D prevents using the services entirely, which is different from opting out of data collection.

---

### Question 32
A security team uses AWS Config to monitor encrypted volumes. They notice a rule evaluation shows an EBS volume as COMPLIANT, but the volume was created 3 months ago before Config was enabled. Is the compliance status reliable?

**A)** No, Config can only evaluate resources created after Config was enabled.
**B)** Yes, Config records the CURRENT configuration, regardless of when the resource was created.
**C)** No, a periodic rule must be used for old resources.
**D)** Yes, but only if a manual re-evaluation is triggered.

**Correct Answer: B**

**Explanation:** When AWS Config is enabled, it takes a snapshot of ALL existing resources, not just new ones. The configuration recorder captures the current state of all supported resources. Config rules then evaluate these current configurations. The age of the resource doesn't matter — Config evaluates what exists now. The compliance status is reliable.

---

### Question 33
A company wants to prevent any AWS actions outside us-east-1 and eu-west-1 using SCPs. After implementing the SCP, users report they can't manage IAM users or create CloudFront distributions. Why?

**A)** The SCP is not attached correctly.
**B)** IAM and CloudFront are global services with their API endpoints in us-east-1. The SCP must exclude these global services from the region restriction.
**C)** SCPs don't support region restrictions.
**D)** The users need IAM permissions for these services.

**Correct Answer: B**

**Explanation:** IAM, STS (global endpoint), CloudFront, Route 53, and other global services operate from us-east-1. A region-restricting SCP that only allows us-east-1 and eu-west-1 should work for these services if us-east-1 is in the allow list. However, some global service actions may need explicit exclusion from the deny statement. The SCP must include `NotAction` for global services like `iam:*`, `sts:*`, `organizations:*`, `cloudfront:*`, `route53:*`, `support:*`, `budgets:*`, etc. to avoid blocking them.

---

### Question 34
A Control Tower administrator wants to extend the landing zone with custom SCPs and CloudFormation templates that automatically deploy when new accounts are created. What solution should they use?

**A)** Account Factory for Terraform (AFT).
**B)** Customizations for Control Tower (CfCT).
**C)** AWS CloudFormation StackSets.
**D)** Manual deployment after account creation.

**Correct Answer: B**

**Explanation:** Customizations for Control Tower (CfCT) is an AWS solution that hooks into Control Tower lifecycle events. When a new account is created, CfCT automatically deploys custom SCPs and CloudFormation templates defined in a manifest file. It uses CodePipeline for deployment. Option A is for Terraform-based customizations. Option C works but doesn't automatically trigger on account creation. Option D doesn't automate.

---

### Question 35
An organization uses tag policies with enforcement enabled. A developer tries to create an EC2 instance with the tag `Environment=PROD` but the tag policy only allows `Environment` values of `prod`, `staging`, `dev` (lowercase). What happens?

**A)** The instance is created with the tag `Environment=PROD`.
**B)** The instance creation fails because `PROD` is not in the allowed values.
**C)** The tag is automatically converted to lowercase.
**D)** A Config rule flags the instance as non-compliant.

**Correct Answer: B**

**Explanation:** When tag policy enforcement is enabled for a resource type, resource creation fails if the tag value doesn't match the allowed values. Since `PROD` (uppercase) is not in the allowed values (`prod`, `staging`, `dev` — lowercase), the `CreateTags` or `RunInstances` call fails. Tag policies are case-sensitive. There is no automatic case conversion.

---

### Question 36
A DevOps engineer needs to implement a solution where developers can create IAM roles but cannot grant themselves more permissions than they already have. What pattern should be used?

**A)** Use SCPs to deny `iam:CreateRole`.
**B)** Implement permission boundaries. Require that all created roles have a specific permission boundary attached, and the boundary limits permissions to a maximum set.
**C)** Use AWS Config to detect overprivileged roles.
**D)** Use IAM Access Analyzer to validate policies.

**Correct Answer: B**

**Explanation:** This is the classic **delegated administration** pattern. The developer's IAM policy allows `iam:CreateRole` but with conditions:
1. `iam:PermissionsBoundary` must be set to a specific managed policy.
2. The permission boundary limits the maximum permissions of any role the developer creates.
This ensures developers cannot create roles with more permissions than defined by the boundary. Option A prevents role creation entirely. Options C and D are detective.

---

### Question 37
A company has 200 accounts. They want to monitor Trusted Advisor findings across all accounts and automatically remediate exposed security groups. What architecture should they implement?

**A)** Manually check Trusted Advisor in each account.
**B)** Use AWS Health organizational events with EventBridge, triggering a centralized Lambda function that assumes roles in member accounts to remediate.
**C)** Use AWS Config organization rules instead of Trusted Advisor.
**D)** Use Security Hub with automated response.

**Correct Answer: B**

**Explanation:** For organization-wide Trusted Advisor monitoring, AWS Health organizational view aggregates health events (including Trusted Advisor check results) to the management account. EventBridge rules can match these events and trigger Lambda for automated remediation. The Lambda function assumes roles in the affected member account to remediate the exposed security group. Option A doesn't scale. Option C works but the question specifically asks about Trusted Advisor. Option D can also work but the most direct answer for Trusted Advisor is B.

---

### Question 38
An engineer is configuring IAM Identity Center with permission sets. They want the same permission set to grant different levels of access based on which account it's used in. Is this possible?

**A)** No, a permission set grants the same permissions in all assigned accounts.
**B)** Yes, by using `aws:PrincipalTag` conditions that vary by account.
**C)** Yes, by using ABAC with account-specific resource tags.
**D)** No, you must create separate permission sets for different access levels.

**Correct Answer: A (standard), C (with ABAC)**

**Explanation:** By default, a permission set grants the same permissions in all accounts it's assigned to (Answer A). If you need different access levels in different accounts, you typically create separate permission sets (Answer D). However, with ABAC (Answer C), you can write policies that reference resource tags. If resources in different accounts have different tags, the same permission set can effectively provide different access levels. The simplest and most common approach tested on the exam is creating separate permission sets.

**Best answer: D** for simplicity or **C** for ABAC sophistication.

---

### Question 39
A Config rule auto-remediation is configured with 3 retry attempts. The first remediation attempt fails. What happens next?

**A)** Config waits for the next rule evaluation cycle before retrying.
**B)** Config retries the remediation automatically up to 3 times with exponential backoff.
**C)** Config retries the remediation automatically up to the configured retry count.
**D)** The resource is marked as COMPLIANT after remediation failure.

**Correct Answer: C**

**Explanation:** When auto-remediation is configured with retry attempts, Config automatically retries the SSM Automation remediation up to the specified number of times. Each retry uses the same SSM Automation document. If all retries fail, the resource remains NON_COMPLIANT and the failures are logged in the remediation execution history. The resource is never automatically marked COMPLIANT on failure.

---

### Question 40
An organization wants to use a single resource-based policy on an SQS queue that grants access to all accounts in their organization, both current and future. What condition should they use?

**A)** List all account IDs in the Principal element.
**B)** Use `"Condition": {"StringEquals": {"aws:PrincipalOrgID": "o-xxxxx"}}` with `"Principal": "*"`.
**C)** Use `"Condition": {"StringEquals": {"aws:SourceAccount": "account-id"}}`.
**D)** Use an IAM role trust policy.

**Correct Answer: B**

**Explanation:** Setting `Principal` to `*` with the `aws:PrincipalOrgID` condition restricts access to only principals from the specified organization. As accounts are added or removed from the organization, access automatically adjusts. Option A requires updating the policy when accounts change. Option C specifies a single account. Option D is for role assumption, not resource-based policies.
