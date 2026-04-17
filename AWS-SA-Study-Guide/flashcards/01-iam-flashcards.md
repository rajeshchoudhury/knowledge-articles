# IAM & Security Flashcards

## AWS Solutions Architect Associate (SAA-C03) — Deck 1 of 9

---

### Card 1
**Q:** What are the four main IAM identities (principals)?
**A:** **Users** – individual people or applications; **Groups** – collections of users (cannot be nested); **Roles** – temporary credentials assumed by trusted entities; **Policies** – JSON documents that define permissions attached to identities or resources. Groups cannot contain other groups, and a user can belong to up to 10 groups.

---

### Card 2
**Q:** What is the root account and what are the best practices for securing it?
**A:** The root account is the email address used to create the AWS account. Best practices: enable MFA (hardware key preferred), do **not** use root for daily tasks, do **not** create access keys for root, use root only for tasks that require it (e.g., changing account settings, restoring IAM permissions, closing the account). Store root credentials securely.

---

### Card 3
**Q:** What is an IAM policy and what are the two main categories?
**A:** An IAM policy is a JSON document defining permissions. **Identity-based policies** attach to users, groups, or roles (managed or inline). **Resource-based policies** attach directly to AWS resources (e.g., S3 bucket policy, SQS queue policy). Resource-based policies always include a `Principal` element; identity-based policies do not.

---

### Card 4
**Q:** Explain the structure of an IAM policy document.
**A:** A policy contains: **Version** (`"2012-10-17"`), **Statement** (array of permission blocks). Each statement has: **Sid** (optional identifier), **Effect** (`Allow` or `Deny`), **Action** (API calls like `s3:GetObject`), **Resource** (ARN of the target), and optionally **Condition** (contextual constraints like IP, MFA, tags). A **Principal** element is used only in resource-based policies.

---

### Card 5
**Q:** How does IAM policy evaluation logic work when multiple policies apply?
**A:** 1) All requests start as **implicit deny**. 2) All applicable policies are evaluated together. 3) An explicit **Deny** in any policy always wins. 4) An explicit **Allow** is needed to permit access. 5) If no explicit Allow is found, the request is denied. Order: Deny → Allow → Implicit Deny. SCPs, permission boundaries, and session policies further restrict what is allowed.

---

### Card 6
**Q:** What is the difference between AWS managed policies, customer managed policies, and inline policies?
**A:** **AWS managed policies** – created and maintained by AWS, reusable, updated by AWS when new services launch. **Customer managed policies** – created by you, reusable across identities, versioning supported (up to 5 versions). **Inline policies** – embedded directly in a single user, group, or role; deleted when the principal is deleted. Best practice is to use customer managed policies for reusability and version control.

---

### Card 7
**Q:** What is the IAM policy size limit?
**A:** Managed policies: up to **6,144 characters** (after whitespace removal). Inline policies: up to **2,048 characters** for users, **5,120** for roles, **10,240** for groups. These limits are per-policy, not cumulative.

---

### Card 8
**Q:** What is an IAM role and when should you use one?
**A:** A role is an identity with temporary security credentials (no long-term passwords or access keys). Use roles for: EC2 instances accessing AWS services, cross-account access, federated users, Lambda functions, ECS tasks, and any scenario where temporary credentials are preferred over permanent ones. Roles use AWS STS to issue short-lived credentials.

---

### Card 9
**Q:** What is AWS STS (Security Token Service)?
**A:** STS is a web service that produces temporary, limited-privilege credentials. Key API calls: **AssumeRole** (for cross-account or same-account role assumption), **AssumeRoleWithSAML** (for SAML-federated users), **AssumeRoleWithWebIdentity** (for web identity federation, though Cognito is preferred), **GetSessionToken** (for MFA-enhanced requests), **GetFederationToken** (custom federated access). Credentials include an access key, secret key, and session token with a configurable expiry.

---

### Card 10
**Q:** How does cross-account access work with IAM roles?
**A:** 1) Account B creates a role with a **trust policy** that lists Account A as a trusted principal. 2) Account B attaches a **permissions policy** to the role defining what actions are allowed. 3) A user/role in Account A calls `sts:AssumeRole` specifying the role ARN in Account B. 4) STS returns temporary credentials scoped to Account B's role. Both the trust policy (Account B) and the identity policy (Account A) must allow the action.

---

### Card 11
**Q:** What is an IAM trust policy?
**A:** A trust policy is a resource-based policy attached to an IAM role that defines **who** (which principals) can assume the role. It specifies the trusted AWS accounts, IAM users/roles, AWS services, or federated identity providers in the `Principal` element. Without a matching trust policy, `sts:AssumeRole` will fail even if the caller has permissions on their side.

---

### Card 12
**Q:** What are IAM permission boundaries?
**A:** A permission boundary is an advanced feature that uses a managed policy to set the **maximum permissions** an IAM entity (user or role) can have. It does not grant permissions on its own; it acts as a filter. Effective permissions = intersection of identity-based policies AND the permission boundary. Common use case: allow developers to create IAM roles/users only within a defined boundary, preventing privilege escalation.

---

### Card 13
**Q:** What are Service Control Policies (SCPs)?
**A:** SCPs are policies applied at the AWS Organizations level to OUs or accounts. They define the **maximum permissions** available to accounts in the organization. SCPs do not grant permissions; they restrict what identity-based and resource-based policies can allow. SCPs do **not** affect the management (master) account. They do not apply to service-linked roles. Common use: deny specific regions, deny leaving the organization, require encryption.

---

### Card 14
**Q:** How do SCPs, permission boundaries, and identity policies interact?
**A:** Effective permissions are the **intersection** of all applicable policy types. A request must be allowed by: the SCP (if in an Organization), the permission boundary (if set), AND the identity-based policy. An explicit Deny in any layer overrides all Allows. Think of it as concentric circles — the effective permission is the area where all circles overlap.

---

### Card 15
**Q:** What is IAM Access Analyzer?
**A:** IAM Access Analyzer identifies resources shared with external principals (accounts, organizations, or the public). It analyzes S3 buckets, IAM roles, KMS keys, Lambda functions, SQS queues, and Secrets Manager secrets. It generates **findings** for any resource that grants access outside your zone of trust (account or organization). It can also validate policies against best practices and generate policies based on CloudTrail activity.

---

### Card 16
**Q:** What is federation in IAM?
**A:** Federation allows external identities (corporate directory, social providers) to access AWS resources without creating IAM users. Types: **SAML 2.0 federation** (Active Directory via ADFS), **Web Identity Federation** (Google, Facebook, Amazon — use Cognito instead), **Custom Identity Broker** (for non-SAML-compatible IdPs). Federation maps external identities to IAM roles with temporary credentials from STS.

---

### Card 17
**Q:** What is the difference between SAML 2.0 federation and AWS SSO (IAM Identity Center)?
**A:** **SAML 2.0 federation** requires configuring an IdP, creating IAM roles, and managing trust manually. **IAM Identity Center** (formerly AWS SSO) is the recommended approach — it provides a single sign-on portal, integrates with AWS Organizations, supports built-in identity store or external IdPs (AD, Okta), and offers centralized permission sets across multiple accounts. Identity Center is simpler to manage at scale.

---

### Card 18
**Q:** What is an instance profile?
**A:** An instance profile is a container for an IAM role that allows EC2 instances to assume the role. When you assign a role to an EC2 instance via the console, an instance profile with the same name is automatically created. The EC2 metadata service (`169.254.169.254`) provides temporary credentials to applications on the instance. Never store access keys on EC2 — use instance profiles instead.

---

### Card 19
**Q:** What are service-linked roles?
**A:** Service-linked roles are predefined IAM roles that are linked directly to an AWS service. The trust policy only allows the specific service to assume the role. You cannot edit the permissions — AWS manages them. Examples: `AWSServiceRoleForElasticLoadBalancing`, `AWSServiceRoleForAutoScaling`. They are created automatically when you use certain services or can be created manually. They cannot be deleted if the service is still using them.

---

### Card 20
**Q:** What MFA options are available in AWS IAM?
**A:** **Virtual MFA device** (Google Authenticator, Authy), **U2F security key** (YubiKey — supports multiple root and IAM users on one key), **Hardware MFA device** (Gemalto token), **SMS-based MFA** (only for IAM users, not root — not recommended). For root accounts, hardware MFA or U2F keys are recommended. MFA can be enforced via IAM policies using the `aws:MultiFactorAuthPresent` condition key.

---

### Card 21
**Q:** How can you enforce MFA for API calls?
**A:** Use IAM policy conditions: `"Condition": {"Bool": {"aws:MultiFactorAuthPresent": "true"}}`. For S3 delete operations, enable MFA Delete on the bucket (requires versioning). For STS, use `GetSessionToken` with MFA to get MFA-authenticated temporary credentials. Without MFA-authenticated credentials, actions protected by MFA conditions will be denied.

---

### Card 22
**Q:** What is the `aws:SourceIp` condition key used for?
**A:** `aws:SourceIp` restricts API calls based on the client's public IP address. Example: deny all actions unless the request originates from the corporate IP range. It works in both IAM policies and S3 bucket policies. Note: it applies to the IP of the caller, not the resource. For VPC-based restrictions, use `aws:SourceVpc` or `aws:SourceVpce` instead.

---

### Card 23
**Q:** What is the `aws:PrincipalOrgID` condition key?
**A:** `aws:PrincipalOrgID` restricts access to principals belonging to a specific AWS Organization. Useful in resource-based policies (e.g., S3 bucket policies) to allow access only from accounts within your organization without listing every account ID. It dynamically includes all current and future accounts in the organization.

---

### Card 24
**Q:** What is the `aws:RequestedRegion` condition key?
**A:** `aws:RequestedRegion` restricts API calls to specific AWS regions. Example: deny all EC2 actions outside `us-east-1` and `eu-west-1`. It applies to the region where the API call is directed, not the user's location. Commonly used in SCPs or IAM policies for region restriction. Global services (IAM, STS, CloudFront) always target `us-east-1`.

---

### Card 25
**Q:** Explain the difference between `NotAction` and `Deny` with `Action`.
**A:** `"Effect": "Deny"` with `"Action": ["s3:*"]` explicitly denies all S3 actions. `"Effect": "Allow"` with `"NotAction": ["iam:*"]` allows everything **except** IAM actions (but does not deny IAM — another policy could still allow it). `NotAction` with `Deny` is used for deny-everything-except patterns. `NotAction` is an exclusion, not a denial — the distinction matters for policy evaluation.

---

### Card 26
**Q:** What is a resource-based policy and how does it differ from an identity-based policy for cross-account access?
**A:** A resource-based policy (e.g., S3 bucket policy) is attached to a resource and grants access to a specified principal. For cross-account access, using a resource-based policy does **not** require the principal to give up their original permissions — they retain both their identity permissions and the cross-account grant. With role assumption (identity-based), the principal **gives up** their original permissions and gets only the role's permissions.

---

### Card 27
**Q:** What is the difference between an IAM policy `Allow` and an S3 bucket policy `Allow` for cross-account access?
**A:** For cross-account S3 access, you need **both**: the identity-based policy in the source account must allow the S3 action, **and** the S3 bucket policy in the target account must allow the source principal. Either one alone is insufficient. Within the **same** account, either an identity-based allow or a resource-based allow is sufficient (unless there's an explicit deny).

---

### Card 28
**Q:** What is the PassRole permission?
**A:** `iam:PassRole` controls which IAM roles a user can assign to AWS services (e.g., assigning a role to an EC2 instance or Lambda function). Without `iam:PassRole` for a specific role ARN, a user cannot attach that role to a service, even if they can launch the service. This prevents privilege escalation — a user with limited permissions cannot pass a role with broader permissions to a service. It is checked only at the time of passing the role.

---

### Card 29
**Q:** What is the IAM credential report?
**A:** The IAM credential report is an account-level report that lists all IAM users and the status of their credentials: password enabled, password last used, MFA active, access key status, access key last used, access key last rotated, and certificate status. It is generated via the console or `GenerateCredentialReport` API. Use it for auditing and compliance. It can be generated once every 4 hours.

---

### Card 30
**Q:** What is the IAM Access Advisor?
**A:** IAM Access Advisor shows the **service permissions** granted to a user/role/group and **when those services were last accessed**. It helps you implement least privilege by identifying unused permissions that can be removed. For example, if a role has S3 and DynamoDB permissions but DynamoDB was never accessed, you can safely remove DynamoDB permissions. Available per-principal in the IAM console.

---

### Card 31
**Q:** What are IAM tags and how are they used for access control?
**A:** IAM tags are key-value pairs attached to IAM resources (users, roles, policies). They enable **Attribute-Based Access Control (ABAC)** via condition keys like `aws:PrincipalTag`, `aws:ResourceTag`, and `aws:RequestTag`. Example: allow users to manage only EC2 instances where `aws:ResourceTag/Project` matches `aws:PrincipalTag/Project`. ABAC scales better than RBAC because permissions adapt without new policies for each new project.

---

### Card 32
**Q:** What is the AWS Security Token Service (STS) endpoint consideration?
**A:** STS has a **global endpoint** (`sts.amazonaws.com`) and **regional endpoints** (`sts.us-east-1.amazonaws.com`). Regional endpoints are recommended for reduced latency and to build redundancy. By default, STS tokens from the global endpoint are valid in all regions. Regional endpoint tokens may only be valid in specific regions. Activate STS in required regions via IAM settings.

---

### Card 33
**Q:** What is an IAM session policy?
**A:** A session policy is passed as a parameter when programmatically creating a temporary session (via `AssumeRole`, `GetFederationToken`, etc.). It further restricts the effective permissions of the session beyond what the role's policy allows. Effective permissions = intersection of the role's identity policy and the session policy. Session policies cannot grant more permissions than the role itself — they can only filter down.

---

### Card 34
**Q:** How do you enforce S3 encryption using IAM policies?
**A:** Use a bucket policy with a `Deny` effect and a condition that checks `s3:x-amz-server-side-encryption`. Example: deny `s3:PutObject` unless `"s3:x-amz-server-side-encryption": "aws:kms"`. You can also deny unencrypted transport using `"aws:SecureTransport": "false"` to enforce HTTPS. Additionally, you can set a default encryption configuration on the bucket.

---

### Card 35
**Q:** What is an IAM policy variable and give an example?
**A:** Policy variables are placeholders resolved at runtime. Examples: `${aws:username}` (IAM username), `${aws:userid}` (unique ID), `${aws:PrincipalTag/department}` (tag value). Use case: allow users to access only their own S3 prefix — `"Resource": "arn:aws:s3:::bucket/${aws:username}/*"`. Variables make policies dynamic and reusable without hardcoding values. Requires `"Version": "2012-10-17"`.

---

### Card 36
**Q:** What is the `aws:SecureTransport` condition key?
**A:** `aws:SecureTransport` is a global condition key that checks whether the API request was sent over HTTPS (`true`) or HTTP (`false`). Common use: attach a bucket policy that denies all `s3:*` actions where `"aws:SecureTransport": "false"` to enforce encryption in transit. Works with any service that supports conditions.

---

### Card 37
**Q:** What are the limits on IAM groups?
**A:** An AWS account can have up to **300 groups** (adjustable). A user can belong to a maximum of **10 groups**. Groups cannot be nested (no groups within groups). Groups cannot be used as a principal in a resource-based policy — only users, roles, and accounts can be principals. Groups are purely an organizational construct for attaching identity-based policies.

---

### Card 38
**Q:** What happens when you delete an IAM user?
**A:** When you delete an IAM user: all inline policies are deleted, all managed policy attachments are removed, the user is removed from all groups, all access keys are deleted, the signing certificate is deleted, the MFA device is deactivated, and the login profile is deleted. However, policies themselves (managed policies) are **not** deleted. Deletion is permanent and cannot be undone.

---

### Card 39
**Q:** What is the `iam:CreateServiceLinkedRole` permission?
**A:** This permission allows a principal to create a service-linked role. Some AWS services require you to explicitly allow `iam:CreateServiceLinkedRole` for the service to function (e.g., Elasticsearch, ECS). The condition `iam:AWSServiceName` can restrict which service the role can be created for. This is separate from `iam:PassRole`.

---

### Card 40
**Q:** What is the difference between `aws:PrincipalArn` and `aws:SourceArn`?
**A:** `aws:PrincipalArn` identifies the ARN of the IAM principal making the request — useful for restricting who can perform actions. `aws:SourceArn` identifies the ARN of the AWS resource that is making a service-to-service request (e.g., an S3 bucket triggering a Lambda). Use `aws:SourceArn` to prevent confused deputy attacks in resource-based policies where a service acts on behalf of a resource.

---

### Card 41
**Q:** What is the confused deputy problem and how do you prevent it?
**A:** The confused deputy problem occurs when a less-privileged entity tricks a more-privileged service into performing actions on its behalf (e.g., a malicious account provides their role ARN to a trusted service). Prevent it using **external ID** in trust policies (for third-party cross-account access) and `aws:SourceArn`/`aws:SourceAccount` conditions in resource-based policies to verify the originating resource.

---

### Card 42
**Q:** What is an external ID in IAM role trust policies?
**A:** An external ID is a secret value shared between you and a third party, specified in the trust policy condition `sts:ExternalId`. When the third party calls `AssumeRole`, they must provide this external ID. This prevents the confused deputy problem — even if an attacker knows the role ARN, they cannot assume it without the correct external ID. It is **not** a replacement for proper authentication.

---

### Card 43
**Q:** What is an IAM policy evaluation for same-account requests?
**A:** For same-account requests: 1) Check for explicit Deny across all policies — if found, deny. 2) Check SCPs (if Organizations) — if no Allow, deny. 3) Check resource-based policies — if Allow found and principal matches, allow (for most services). 4) Check identity-based policies — if Allow found, continue. 5) Check permission boundary — if no Allow, deny. 6) Check session policy — if no Allow, deny. 7) If all applicable layers allow, the request succeeds.

---

### Card 44
**Q:** Can an IAM group be a principal in a trust policy?
**A:** No. IAM groups **cannot** be used as principals in any policy — not in trust policies, not in resource-based policies. Only IAM users, IAM roles, AWS accounts, AWS services, and federated users can be principals. If you need to allow all members of a group to assume a role, you must either list them individually or add `sts:AssumeRole` permission to the group's identity-based policy and trust the entire account.

---

### Card 45
**Q:** What is the maximum session duration for an IAM role?
**A:** The default maximum session duration is **1 hour**. It can be configured up to **12 hours** (43,200 seconds) per role. When calling `AssumeRole`, you specify `DurationSeconds`. For roles used by AWS services (e.g., EC2 instance profiles), credentials are automatically rotated. For console access via federation, sessions default to 12 hours maximum. `GetSessionToken` can go up to 36 hours.

---

### Card 46
**Q:** What are permission boundaries useful for in a delegation scenario?
**A:** Permission boundaries allow administrators to delegate IAM management safely. Example: allow a developer to create IAM roles and users, but only if they attach a specific permission boundary. This prevents the developer from creating an admin role, because the boundary caps the effective permissions. The developer must attach the boundary via `iam:PermissionsBoundary` condition, ensuring no privilege escalation.

---

### Card 47
**Q:** What is the `aws:CalledVia` condition key?
**A:** `aws:CalledVia` identifies which AWS services made requests on behalf of the principal. For example, if CloudFormation calls S3 on your behalf, `aws:CalledVia` includes `cloudformation.amazonaws.com`. Use `aws:CalledViaFirst` and `aws:CalledViaLast` for more granular control. Useful when you want to allow access to a resource only when it's called through a specific service.

---

### Card 48
**Q:** How does `NotPrincipal` work in a policy?
**A:** `NotPrincipal` specifies every principal **except** the listed ones. Typically used with `"Effect": "Deny"` to create a deny-everyone-except pattern. Example: deny all principals except a specific admin role from accessing an S3 bucket. Caution: using `NotPrincipal` with `Allow` can inadvertently grant access broadly. AWS recommends using conditions over `NotPrincipal` when possible.

---

### Card 49
**Q:** What is the relationship between AWS Organizations and IAM?
**A:** AWS Organizations provides centralized governance across accounts. SCPs restrict maximum permissions per account/OU. Tag policies enforce tag standardization. Consolidated billing aggregates costs. AI services opt-out policies control data usage. Backup policies centralize backup plans. Organizations enables features like IAM Identity Center for SSO, CloudTrail organization trails, and Config aggregators — all of which interact with IAM for authentication and authorization.

---

### Card 50
**Q:** What is the `iam:ResourceTag` condition key?
**A:** `iam:ResourceTag` checks tags on the IAM resource being acted upon. Example: allow `iam:DeleteUser` only if the target user has tag `Department=Test`. This enables tag-based access control for IAM administration itself. Combined with `aws:PrincipalTag`, you can build ABAC policies where admins can only manage IAM resources in their own department. Different from `aws:ResourceTag` which applies to non-IAM resources.

---

*End of Deck 1 — 50 cards*
