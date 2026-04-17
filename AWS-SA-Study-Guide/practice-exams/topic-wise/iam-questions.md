# IAM & Organizations Question Bank

**AWS Solutions Architect Associate (SAA-C03) — Topic-Wise Practice**
**Total Questions: 30**

---

### Question 1
A company has multiple AWS accounts under AWS Organizations. The security team wants to ensure that no one in any member account can launch EC2 instances in the `ap-southeast-1` region. The restriction must apply even if the IAM user has an `AdministratorAccess` policy attached. What should the solutions architect recommend?

A) Create an IAM policy that denies `ec2:RunInstances` in `ap-southeast-1` and attach it to every IAM user in all accounts
B) Create a Service Control Policy (SCP) that denies `ec2:RunInstances` in `ap-southeast-1` and attach it to the root OU
C) Configure AWS Config rules to automatically terminate instances launched in `ap-southeast-1`
D) Use IAM permission boundaries on all users to deny `ec2:RunInstances` in `ap-southeast-1`

**Answer: B**
**Explanation:** SCPs set the maximum permissions available to IAM entities in member accounts. Even if a user has `AdministratorAccess`, the SCP will override and deny the action. Option A is operationally difficult to maintain across all accounts. Option C is reactive, not preventive. Option D requires attaching boundaries to every user and wouldn't prevent root account actions.

---

### Question 2
A developer needs to give an application running on an EC2 instance access to an S3 bucket. The developer has created an IAM role with the appropriate S3 permissions. What is the MOST secure way to provide these credentials to the application?

A) Store the IAM user access keys in the application's configuration file on the EC2 instance
B) Attach the IAM role to the EC2 instance as an instance profile
C) Store the IAM user access keys in an environment variable on the EC2 instance
D) Embed the IAM user access keys directly in the application code

**Answer: B**
**Explanation:** IAM roles for EC2 (instance profiles) are the recommended way to grant AWS permissions to applications running on EC2. The SDK automatically retrieves temporary credentials from the instance metadata service. Storing access keys in config files, environment variables, or code is insecure and violates best practices because keys are long-lived and can be leaked.

---

### Question 3
A company is implementing a multi-account strategy. They want to centrally manage user authentication and provide SSO access to all AWS accounts. Users are currently managed in an on-premises Microsoft Active Directory. What solution should the solutions architect recommend?

A) Create IAM users in each AWS account and sync passwords from Active Directory using a custom Lambda function
B) Set up AWS IAM Identity Center (formerly AWS SSO) with a two-way trust to the on-premises AD via AWS Directory Service AD Connector
C) Federate each account individually using SAML 2.0 with ADFS
D) Replicate the on-premises AD to AWS Managed Microsoft AD and create IAM users from AD groups

**Answer: B**
**Explanation:** IAM Identity Center provides centralized SSO management across multiple AWS accounts. AD Connector creates a proxy to the on-premises AD without replicating directory data. This gives a seamless SSO experience. Option A doesn't provide SSO. Option C works but is complex to manage per account. Option D unnecessarily replicates the directory and still doesn't address SSO centrally.

---

### Question 4
An IAM user has the following IAM policy attached:

```json
{
  "Effect": "Allow",
  "Action": "s3:*",
  "Resource": "*"
}
```

The user also has a permission boundary that contains:

```json
{
  "Effect": "Allow",
  "Action": ["s3:GetObject", "s3:ListBucket"],
  "Resource": "*"
}
```

What actions can this user perform on S3?

A) All S3 actions, because the identity-based policy allows `s3:*`
B) Only `s3:GetObject` and `s3:ListBucket`
C) No S3 actions, because permission boundaries deny all actions not explicitly listed
D) Only `s3:GetObject`

**Answer: B**
**Explanation:** The effective permissions are the intersection of the identity-based policy and the permission boundary. The identity-based policy allows all S3 actions, but the permission boundary only allows `s3:GetObject` and `s3:ListBucket`. The intersection is `s3:GetObject` and `s3:ListBucket`. Permission boundaries don't grant permissions — they define the maximum scope.

---

### Question 5
A solutions architect needs to enable a third-party auditing company to access resources in the company's AWS account. The auditor already has their own AWS account. The access should be temporary and follow security best practices. What approach should the architect take?

A) Create an IAM user with a password in the company's account and share the credentials securely
B) Create a cross-account IAM role in the company's account and grant the auditor's account permission to assume it
C) Share the company's root account credentials with the auditor for the audit duration
D) Create an access key for an IAM user and send it to the auditor via encrypted email

**Answer: B**
**Explanation:** Cross-account IAM roles are the recommended approach for granting access to third parties with their own AWS accounts. The auditor assumes the role and receives temporary credentials via STS. This avoids creating and sharing long-lived credentials. Options A and D involve sharing long-lived credentials, which is insecure. Option C violates fundamental security practices.

---

### Question 6
A company wants to delegate the ability to create IAM users to junior administrators, but they must NOT be able to create users with more permissions than they themselves have. What mechanism should the solutions architect use?

A) Create a custom IAM policy that lists only the specific policies the junior admins can attach
B) Use IAM permission boundaries to limit the maximum permissions that newly created users can have
C) Use Service Control Policies to restrict IAM actions for junior admins
D) Enable IAM Access Analyzer to automatically detect over-privileged users

**Answer: B**
**Explanation:** Permission boundaries are designed for exactly this use case — delegation with guardrails. You require junior admins to attach a specific permission boundary when creating users. The boundary limits the effective permissions of the created users regardless of what policies are attached. Option A is brittle and hard to maintain. Option C is for Organizations-level controls. Option D is a detection, not prevention tool.

---

### Question 7
A company has enabled AWS CloudTrail and notices that IAM role `WebAppRole` is calling the `sts:AssumeRole` API to assume a role in another account. The security team did not authorize this cross-account access. What should the solutions architect check FIRST?

A) Review the trust policy of the role being assumed in the other account
B) Check the IAM Access Analyzer findings for the account
C) Review the SCP attached to the organizational unit
D) Check the VPC flow logs for unusual network traffic

**Answer: A**
**Explanation:** For cross-account role assumption to work, both sides must allow it: the role's identity-based policy must have `sts:AssumeRole` permission, AND the target role's trust policy must allow the source role to assume it. Checking the trust policy of the assumed role is the first step to understand who authorized the access. IAM Access Analyzer (B) may show findings but the trust policy is the direct answer. SCPs (C) and VPC flow logs (D) are not directly relevant.

---

### Question 8
A company requires that all API calls to AWS services from their accounts be made using HTTPS and signed with MFA. They want to deny any API call that was not authenticated with MFA. What is the correct approach?

A) Enable MFA on the root account and all IAM users
B) Create an IAM policy with a `Deny` effect and a condition `aws:MultiFactorAuthPresent` set to `false`, then attach it to all users
C) Create an SCP that requires MFA for all API calls
D) Configure AWS Config to detect API calls made without MFA

**Answer: B**
**Explanation:** Using an IAM policy with a condition key `aws:MultiFactorAuthPresent` is false (or `BoolIfExists`) to deny actions when MFA is not present is the standard approach. Simply enabling MFA (A) doesn't enforce it for API calls. SCPs (C) can use condition keys but the question implies account-level enforcement. Config (D) detects but doesn't prevent.

---

### Question 9
An application needs to access objects in an S3 bucket owned by a different AWS account. Both accounts are in the same organization. The bucket policy allows access from the application's account. However, the application is getting "Access Denied" errors. What is the MOST likely cause?

A) The S3 bucket has server-side encryption enabled
B) The application's IAM role does not have an S3 policy allowing access to the bucket
C) The VPC endpoint policy is blocking S3 access
D) There is an SCP denying S3 access on the application's account

**Answer: B**
**Explanation:** For cross-account S3 access, BOTH the bucket policy on the target account AND the IAM policy on the source account must allow the access. If the bucket policy allows it but the application role's IAM policy doesn't include S3 permissions, access will be denied. This is a common exam trap. Option A is unlikely as encryption doesn't cause access denied in this manner. Options C and D are possible but less likely root causes.

---

### Question 10
A company is migrating to AWS and wants to use their existing corporate identities. They use an OIDC-compatible identity provider. Mobile app users need to access DynamoDB and S3 directly. What should the solutions architect implement?

A) Create IAM users for each mobile user and distribute access keys with the mobile app
B) Use Amazon Cognito identity pools (federated identities) with the OIDC provider to issue temporary AWS credentials
C) Set up a proxy server that authenticates users and makes AWS API calls on their behalf
D) Use IAM Identity Center to grant mobile users access to AWS services

**Answer: B**
**Explanation:** Amazon Cognito identity pools integrate with OIDC providers and exchange tokens for temporary AWS credentials via STS. This is the recommended pattern for mobile apps that need direct AWS service access. Option A distributes long-lived credentials, which is insecure. Option C adds unnecessary complexity and a bottleneck. Option D is designed for employee SSO to AWS console/accounts, not mobile app users.

---

### Question 11
A solutions architect is designing an IAM policy for an S3 bucket. The policy must allow a user to list all buckets, but only access objects in a specific bucket named `finance-data`. Which policy statement achieves this?

A)
```json
{"Effect":"Allow","Action":"s3:*","Resource":"arn:aws:s3:::finance-data/*"}
```
B)
```json
[
  {"Effect":"Allow","Action":"s3:ListAllMyBuckets","Resource":"*"},
  {"Effect":"Allow","Action":["s3:GetObject","s3:PutObject"],"Resource":"arn:aws:s3:::finance-data/*"}
]
```
C)
```json
{"Effect":"Allow","Action":["s3:ListAllMyBuckets","s3:GetObject"],"Resource":"arn:aws:s3:::finance-data"}
```
D)
```json
{"Effect":"Allow","Action":"s3:*","Resource":"*","Condition":{"StringEquals":{"s3:prefix":"finance-data"}}}
```

**Answer: B**
**Explanation:** The correct approach uses two statements: one for `s3:ListAllMyBuckets` on `"*"` (required at the service level, not bucket level) and another for object-level operations scoped to the specific bucket ARN with `/*`. Option A doesn't include list buckets. Option C uses the wrong resource format (missing `/*` for objects and `s3:ListAllMyBuckets` requires `*` resource). Option D grants all S3 actions and the condition isn't correctly structured.

---

### Question 12
A company uses AWS Organizations with multiple OUs. They want to enforce a tagging policy so that all EC2 instances across all accounts must have an `Environment` tag with values limited to `Production`, `Staging`, or `Development`. What should the architect recommend?

A) Use an SCP to deny `ec2:RunInstances` when the `Environment` tag is missing
B) Use AWS Config rules with automatic remediation to tag non-compliant instances
C) Use tag policies in AWS Organizations to enforce the tag key and allowed values
D) Create a Lambda function triggered by CloudTrail to terminate instances without proper tags

**Answer: C**
**Explanation:** Tag policies in AWS Organizations are specifically designed to standardize tags across resources in all accounts. They can enforce tag keys and allowed values. SCPs (A) can enforce tagging but are complex for defining allowed values. Config rules (B) detect non-compliance but are reactive. Lambda (D) is a custom solution that is harder to manage.

---

### Question 13
An IAM user attempts to terminate an EC2 instance but receives an "Access Denied" error. The user has the following policies: an identity-based policy allowing `ec2:*`, a permission boundary allowing `ec2:TerminateInstances`, and the resource has a tag-based condition. The instance has the tag `Environment=Production`. The identity policy has a condition `StringEquals: ec2:ResourceTag/Environment: Development`. Why is access denied?

A) The permission boundary is too restrictive
B) The identity-based policy's condition requires the instance to have `Environment=Development`, and the instance has `Environment=Production`
C) SCPs are blocking the action
D) The instance is in a different region than the IAM user

**Answer: B**
**Explanation:** Even though the identity-based policy allows `ec2:*`, the condition on the policy restricts it to instances tagged `Environment=Development`. Since the target instance is tagged `Environment=Production`, the condition is not met, and access is denied. The permission boundary allows `ec2:TerminateInstances`, so it's not the restriction. There is no mention of SCPs or region issues.

---

### Question 14
A startup is setting up its first AWS Organization. They have a management account and plan to create workload accounts for production, staging, and development. Following AWS best practices, which action should be performed in the management account?

A) Deploy all production workloads in the management account for centralized control
B) Use the management account only for billing and Organizations management; deploy workloads in member accounts
C) Create IAM users for all developers in the management account
D) Enable all AWS services in the management account to serve as the central hub

**Answer: B**
**Explanation:** AWS best practice is to use the management account only for Organizations management and consolidated billing. No workloads should run in the management account. Workloads should be deployed in dedicated member accounts. Options A and C violate this principle. Option D is vague and doesn't align with the least-privilege approach.

---

### Question 15
A company needs to analyze its IAM configuration to find resources shared with external entities. They want to identify S3 buckets, IAM roles, KMS keys, Lambda functions, and SQS queues that are accessible from outside their AWS account. Which service should the architect recommend?

A) Amazon GuardDuty
B) AWS Trusted Advisor
C) IAM Access Analyzer
D) Amazon Inspector

**Answer: C**
**Explanation:** IAM Access Analyzer analyzes resource-based policies to identify resources that are shared with external principals. It generates findings for S3 buckets, IAM roles, KMS keys, Lambda functions, SQS queues, and Secrets Manager secrets. GuardDuty (A) detects threats. Trusted Advisor (B) provides best-practice recommendations. Inspector (D) assesses vulnerabilities in EC2 instances and container images.

---

### Question 16
A developer is trying to assume an IAM role from an EC2 instance in Account A to access DynamoDB in Account B. The role in Account B has the correct trust policy allowing the instance's role ARN. However, the call fails. What is the MOST likely issue?

A) The EC2 instance's security group does not allow outbound traffic to DynamoDB
B) The IAM role attached to the EC2 instance does not have `sts:AssumeRole` permission for the target role ARN
C) DynamoDB does not support cross-account access
D) The VPC does not have a NAT gateway

**Answer: B**
**Explanation:** For cross-account role assumption, the calling principal (the instance's role) must have `sts:AssumeRole` permission, AND the target role's trust policy must allow it. If the trust policy is correct but the call fails, the instance's role likely lacks the `sts:AssumeRole` permission. DynamoDB (C) does support cross-account access. Security groups (A) and NAT gateway (D) affect network connectivity, not IAM permissions.

---

### Question 17
A company has a policy that no IAM user should have inline policies. They want to be automatically notified when an inline policy is attached to any IAM user. What is the MOST operationally efficient solution?

A) Write a Lambda function that runs daily to check all IAM users for inline policies
B) Use AWS Config managed rule `iam-user-no-policies-check` with an SNS notification on non-compliance
C) Enable CloudTrail and create a CloudWatch metric filter for `PutUserPolicy` API calls with an alarm
D) Use IAM Access Analyzer to detect inline policies

**Answer: C**
**Explanation:** Creating a CloudWatch metric filter on the `PutUserPolicy` CloudTrail event directly detects when inline policies are attached and triggers an immediate notification. AWS Config rule (B) is also valid but `iam-user-no-policies-check` checks for any directly attached policies (both managed and inline). Option C is more precise for inline policies specifically. Option A is not real-time. Option D does not detect inline policy attachments.

---

### Question 18
A solutions architect needs to provide temporary access to an S3 bucket for an external partner. The partner does not have an AWS account. The access should expire after 1 hour. What is the simplest solution?

A) Create an IAM user with temporary credentials
B) Generate a pre-signed URL for the S3 objects with a 1-hour expiration
C) Create a public bucket policy with a time-based condition
D) Set up an Amazon Cognito user pool for the partner

**Answer: B**
**Explanation:** Pre-signed URLs provide temporary, time-limited access to S3 objects without requiring the recipient to have an AWS account. They are the simplest solution for this use case. IAM users (A) don't have built-in temporary credentials. Public bucket policies (C) expose data broadly. Cognito (D) is overkill for a single partner.

---

### Question 19
A company's security policy requires that IAM access keys must be rotated every 90 days. They need to identify users with access keys older than 90 days and enforce rotation. What combination of services achieves this?

A) AWS Config rule `access-keys-rotated` with 90-day parameter and AWS Systems Manager Automation for remediation
B) IAM credential report downloaded manually every quarter
C) CloudTrail logs analyzed by Athena to find old access keys
D) GuardDuty monitoring for stale credential usage

**Answer: A**
**Explanation:** AWS Config managed rule `access-keys-rotated` can be configured with a `maxAccessKeyAge` parameter of 90 days. Combined with SSM Automation, non-compliant keys can be automatically deactivated. Option B is manual and not automated. Option C doesn't directly identify key age. Option D detects anomalous usage, not key age.

---

### Question 20
A company is implementing a data lake on S3. They want to grant fine-grained, column-level access control to data in S3 for different analytics teams. What should the solutions architect recommend?

A) Create separate S3 buckets for each team with different bucket policies
B) Use AWS Lake Formation to define granular permissions including column-level access
C) Encrypt different columns with different KMS keys
D) Use S3 Access Points with different policies for each team

**Answer: B**
**Explanation:** AWS Lake Formation provides fine-grained access control including database, table, column, and row-level permissions for data in S3-based data lakes. It integrates with Athena, Redshift Spectrum, and EMR. Option A doesn't provide column-level control. Option C is impractical and doesn't work with analytical queries. Option D provides bucket-level access control, not column-level.

---

### Question 21
A company wants to ensure that all S3 buckets created in their Organization have public access blocked. They also want to prevent member accounts from changing this setting. What is the BEST approach?

A) Enable S3 Block Public Access at the account level in each member account
B) Use an SCP to deny `s3:PutBucketPublicAccessBlock` API calls and enable Block Public Access at the Organization level
C) Create an AWS Config rule to detect public buckets and auto-remediate
D) Use a Lambda function to monitor and revert changes to bucket public access settings

**Answer: B**
**Explanation:** S3 Block Public Access can be enabled at the Organization level. Combined with an SCP that denies the ability to modify this setting, member accounts cannot create public buckets or change the setting. Option A must be done per account and can be overridden. Options C and D are reactive, not preventive.

---

### Question 22
An application team wants to store database credentials that are automatically rotated. The credentials must be accessed programmatically by applications running on EC2 instances. The solution must support automatic rotation without application changes. What should the architect recommend?

A) Store credentials in AWS Systems Manager Parameter Store SecureString and use a Lambda function for rotation
B) Use AWS Secrets Manager with automatic rotation enabled
C) Store credentials in an encrypted S3 bucket and update them periodically
D) Use IAM database authentication for RDS

**Answer: B**
**Explanation:** AWS Secrets Manager natively supports automatic rotation of credentials for RDS, Redshift, and DocumentDB. It provides an API for programmatic access, and applications can be configured to always retrieve the current credential. While Parameter Store (A) can store secrets, it doesn't have built-in rotation. Option C is cumbersome. Option D works only for MySQL and PostgreSQL on RDS and has connection limits.

---

### Question 23
A large enterprise wants to set up a landing zone with pre-configured multi-account environment following AWS best practices. They need guardrails, automated account provisioning, and centralized logging. What service should they use?

A) AWS Organizations with custom CloudFormation StackSets
B) AWS Control Tower
C) AWS Service Catalog with custom account templates
D) AWS CloudFormation with nested stacks

**Answer: B**
**Explanation:** AWS Control Tower automates the setup of a multi-account landing zone with pre-configured guardrails (preventive and detective), automated account provisioning (Account Factory), centralized logging, and cross-account audit capabilities. While Organizations (A) is the foundation, Control Tower provides the full landing zone setup. Service Catalog (C) and CloudFormation (D) are building blocks, not complete solutions.

---

### Question 24
A company has federated access to AWS using SAML 2.0 with their corporate Identity Provider. Users are mapped to IAM roles based on their AD groups. A new team reports they can authenticate but cannot see any AWS resources after federation. What should the architect check?

A) Whether the SAML assertion includes the correct `Role` attribute mapping to an IAM role with appropriate permissions
B) Whether the corporate firewall is blocking AWS API calls
C) Whether the team's IP address is whitelisted in the IAM policy
D) Whether MFA is required for the federated role

**Answer: A**
**Explanation:** When using SAML federation, the SAML assertion maps AD groups to IAM roles via the `Role` attribute. If the role mapping is incorrect or the mapped IAM role doesn't have appropriate permissions, users can authenticate (sign in) but won't be able to access resources. This is the most common issue with new team setups.

---

### Question 25
An organization requires all API calls across all member accounts to be logged in a central S3 bucket in the security account. Which approach is MOST efficient?

A) Create a CloudTrail trail in each member account pointing to the central S3 bucket
B) Create an organization trail in the management account that logs to the central S3 bucket
C) Use EventBridge rules in each account to forward API events to the central account
D) Enable VPC Flow Logs in all accounts and send them to the central S3 bucket

**Answer: B**
**Explanation:** An organization trail in the management account automatically logs API activity for all member accounts to a single S3 bucket. This is the most efficient approach. Creating individual trails (A) is operationally expensive. EventBridge (C) is not designed for comprehensive API logging. VPC Flow Logs (D) capture network traffic, not API calls.

---

### Question 26
A developer has an IAM policy that allows `s3:PutObject` on bucket `data-bucket`. They also belong to an IAM group with a policy that has `"Effect": "Deny", "Action": "s3:PutObject", "Resource": "arn:aws:s3:::data-bucket/restricted/*"`. Can the developer upload an object to `s3://data-bucket/restricted/file.txt`?

A) Yes, because the individual Allow policy takes precedence over the group Deny
B) No, because an explicit Deny always overrides any Allow
C) Yes, because individual policies take priority over group policies
D) It depends on the order in which the policies were created

**Answer: B**
**Explanation:** In IAM policy evaluation, an explicit Deny ALWAYS takes precedence over any Allow, regardless of where the policies are attached (user, group, or role). The group's Deny policy on `restricted/*` will override the user's Allow on the bucket. IAM policy evaluation order doesn't depend on attachment point or creation time.

---

### Question 27
A company wants to allow developers to create and manage their own IAM roles for Lambda functions, but wants to prevent them from escalating their own privileges. What is the BEST approach?

A) Use SCPs to restrict IAM actions for developers
B) Require developers to attach a specific permission boundary to any role they create, enforced by a condition in their IAM policy
C) Allow developers to create roles but require approval from an admin to attach policies
D) Use AWS Service Catalog to provide pre-approved role templates

**Answer: B**
**Explanation:** By adding a condition to the developer's IAM policy that requires `iam:PermissionsBoundary` to be a specific boundary ARN when calling `iam:CreateRole` and `iam:AttachRolePolicy`, you ensure all roles created by developers are limited by the boundary. This prevents privilege escalation while allowing self-service. SCPs (A) are too broad. Approval workflows (C) slow development. Service Catalog (D) is rigid.

---

### Question 28
An application uses an IAM role with a session duration of 1 hour. The application runs a batch process that takes 4 hours to complete. After 1 hour, the application starts receiving "ExpiredTokenException" errors. What should the architect recommend?

A) Increase the maximum session duration of the IAM role to 4 hours or more
B) Have the application re-assume the role before the session expires
C) Use an IAM user with long-lived access keys instead
D) Both A and B would work

**Answer: D**
**Explanation:** Both solutions are valid. Option A increases the maximum session duration (up to 12 hours for IAM roles) so a single session covers the batch process. Option B implements credential refresh logic in the application. Using long-lived access keys (C) is not a best practice. The exam may present either approach as correct depending on the scenario constraints.

---

### Question 29
A company is using AWS RAM (Resource Access Manager) to share subnets from a central networking account with workload accounts. A workload account complains they cannot launch EC2 instances in the shared subnet. What should the architect verify?

A) The shared subnet has available IP addresses
B) The workload account has accepted the RAM resource share invitation (if not in the same Organization with sharing enabled)
C) The security group allows EC2 launch
D) The subnet's route table has a route to the internet gateway

**Answer: B**
**Explanation:** When sharing resources via AWS RAM outside of an Organization (or when organizational sharing is not enabled), the recipient account must accept the invitation. If the invitation wasn't accepted, the shared subnet won't be available. Within an Organization with sharing enabled, acceptance is automatic. Options A, C, and D are valid troubleshooting steps but the most likely issue is the unaccepted share.

---

### Question 30
A company has a strict compliance requirement that all IAM user passwords must be at least 14 characters, include uppercase, lowercase, numbers, and symbols, and be rotated every 60 days. How should this be enforced?

A) Create an SCP that enforces password complexity
B) Configure the IAM account password policy with the required settings
C) Use a Lambda function to check password compliance when users change passwords
D) Use AWS Config to monitor password policy compliance

**Answer: B**
**Explanation:** The IAM account password policy allows you to set minimum length, character requirements (uppercase, lowercase, numbers, symbols), and maximum password age. This is the native and correct mechanism. SCPs (A) don't control password policies. Lambda (C) is unnecessary custom code. AWS Config (D) can check if the password policy meets requirements but doesn't enforce the policy itself.

---

*End of IAM & Organizations Question Bank*
