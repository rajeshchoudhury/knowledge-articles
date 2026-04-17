# IAM Deep Dive

## Table of Contents

- [Overview](#overview)
- [IAM Fundamentals](#iam-fundamentals)
  - [Root Account](#root-account)
  - [IAM Users](#iam-users)
  - [IAM Groups](#iam-groups)
  - [IAM Roles](#iam-roles)
  - [IAM Policies](#iam-policies)
- [Policy Types](#policy-types)
  - [Identity-Based Policies](#identity-based-policies)
  - [Resource-Based Policies](#resource-based-policies)
  - [Permission Boundaries](#permission-boundaries)
  - [Organizations SCPs](#organizations-scps)
  - [Session Policies](#session-policies)
  - [Access Control Lists (ACLs)](#access-control-lists-acls)
- [Policy Evaluation Logic](#policy-evaluation-logic)
- [JSON Policy Structure](#json-policy-structure)
- [Condition Operators and Keys](#condition-operators-and-keys)
- [IAM Best Practices](#iam-best-practices)
- [Cross-Account Access Patterns](#cross-account-access-patterns)
- [Federation](#federation)
- [IAM Access Analyzer](#iam-access-analyzer)
- [AWS STS](#aws-sts)
- [Service-Linked Roles vs Service Roles](#service-linked-roles-vs-service-roles)
- [Instance Profiles](#instance-profiles)
- [Policy Variables and Tags](#policy-variables-and-tags)
- [IAM Quotas and Limits](#iam-quotas-and-limits)
- [Permission Boundaries Deep Dive](#permission-boundaries-deep-dive)
- [Resource-Based vs Identity-Based Policies Comparison](#resource-based-vs-identity-based-policies-comparison)
- [Trust Policies for Roles](#trust-policies-for-roles)
- [Common Exam Scenarios](#common-exam-scenarios)

---

## Overview

AWS Identity and Access Management (IAM) is one of the most heavily tested topics on the SAA-C03 exam. IAM enables you to control who is authenticated (signed in) and authorized (has permissions) to use AWS resources. IAM is a **global service** — users, groups, roles, and policies are not Region-specific.

IAM is free to use. You pay only for the AWS resources your users access.

---

## IAM Fundamentals

### Root Account

The root account is created when you first set up your AWS account. It has **complete, unrestricted access** to all AWS services and resources.

**Root account best practices:**
- **Never use the root account for daily tasks.** Create an IAM user with admin permissions instead.
- **Enable MFA** on the root account immediately.
- **Delete root account access keys** if they exist. Never create access keys for root.
- **Use a strong, unique password.**
- **Lock away root account credentials** and share with as few people as possible.
- Use a **group email alias** (e.g., `aws-root@company.com`) rather than a personal email for the root account.

**Tasks that ONLY the root account can perform:**
- Change the account name, email, or root password
- Change the AWS Support plan
- Close the AWS account
- Enable MFA delete on S3 bucket versioning
- Create a CloudFront key pair (legacy)
- Configure an S3 bucket to enable MFA delete
- Restore IAM user permissions (if you accidentally lock yourself out)
- Register as a seller in the Reserved Instance Marketplace
- Configure S3 Object Lock retention on a bucket
- View certain tax invoices
- Sign up for GovCloud
- Enable or disable STS in Regions

### IAM Users

An IAM user is an identity with long-term credentials that represents a person or application that interacts with AWS.

**Key characteristics:**
- Has a unique name within the AWS account
- Can have up to **two access keys** (for CLI/API access)
- Can have a **console password** (for AWS Management Console access)
- Can belong to up to **10 groups**
- Policies can be attached directly to users (not recommended) or inherited through groups
- Has a unique **ARN** (Amazon Resource Name): `arn:aws:iam::123456789012:user/username`
- New users have **no permissions** by default (implicit deny)
- Limit: **5,000 IAM users** per account

**Access types:**
1. **Programmatic access:** Access key ID + Secret access key (for AWS CLI, SDK, API)
2. **Console access:** Username + Password (for AWS Management Console)

> **Exam Tip:** For applications running on EC2 instances, NEVER use IAM user credentials. Use IAM roles (instance profiles) instead. This is a best practice tested repeatedly.

### IAM Groups

An IAM group is a collection of IAM users. Groups simplify permission management.

**Key characteristics:**
- Groups contain **only users** — you cannot nest groups (no groups within groups)
- A user can belong to **multiple groups** (up to 10)
- Groups are **not an identity** — you cannot use a group as a Principal in a resource-based policy
- Groups cannot be used to assume roles
- There is a **default limit of 300 groups** per account (can be increased)
- The root account does not belong to any group
- Policies attached to a group are inherited by all users in that group

**Common group patterns:**
- `Admins` — Full AWS access
- `Developers` — Access to dev resources
- `DBAdmins` — Access to database services
- `ReadOnly` — Read-only access to resources
- `Billing` — Access to billing and cost management

### IAM Roles

An IAM role is an identity with specific permissions that can be **assumed** by trusted entities. Unlike users, roles do not have permanent credentials. When a role is assumed, temporary security credentials are provided.

**Key characteristics:**
- Roles have a **trust policy** (who can assume the role) and **permission policies** (what the role can do)
- Roles provide **temporary credentials** (via STS), not long-term credentials
- Roles can be assumed by:
  - IAM users (same or different account)
  - AWS services (EC2, Lambda, etc.)
  - Federated users (SAML, Web Identity)
  - Applications
- No limit on the number of roles an entity can assume (one at a time, but can switch)
- Roles are the **preferred mechanism** for granting permissions to AWS services

**Common role use cases:**
- EC2 instance roles (via instance profiles)
- Lambda execution roles
- Cross-account access
- Federation (SAML, OIDC)
- AWS service roles (for services to interact with other services)

### IAM Policies

Policies are JSON documents that define permissions. They specify what actions are allowed or denied on which resources under what conditions.

**Key characteristics:**
- Written in JSON format
- Can be **managed** (standalone, reusable) or **inline** (embedded in a user, group, or role)
- **AWS Managed Policies:** Created and maintained by AWS (e.g., `AdministratorAccess`, `ReadOnlyAccess`)
- **Customer Managed Policies:** Created by you, can be versioned (up to 5 versions)
- **Inline Policies:** Embedded directly in a single user, group, or role; deleted when the entity is deleted
- Permissions are evaluated as a union of all applicable policies

---

## Policy Types

AWS has six types of policies. Understanding how they interact is critical for the exam.

### Identity-Based Policies

Policies attached to IAM identities (users, groups, roles).

- **Managed Policies** (AWS or customer): Standalone, reusable, versionable
- **Inline Policies:** Embedded in a single identity, one-to-one relationship

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::my-bucket/*"
    }
  ]
}
```

### Resource-Based Policies

Policies attached directly to AWS resources (S3 buckets, SQS queues, KMS keys, Lambda functions, etc.).

- **Always inline** — directly attached to the resource
- Include a **Principal** element (who gets the permission)
- Support cross-account access without needing to assume a role

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::111122223333:root"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::my-bucket/*"
    }
  ]
}
```

**Services that support resource-based policies:**
- S3 (bucket policies)
- SQS (queue policies)
- SNS (topic policies)
- KMS (key policies)
- Lambda (function policies)
- ECR (repository policies)
- API Gateway (resource policies)
- Secrets Manager
- CloudWatch Logs
- EventBridge (event bus policies)
- Glacier (vault access policies/lock policies)
- Backup (vault policies)

### Permission Boundaries

A permission boundary is an advanced feature that sets the **maximum permissions** an IAM entity (user or role) can have. It does not grant permissions — it limits them.

- Applied to users or roles (not groups)
- Acts as a ceiling — the effective permissions are the **intersection** of the identity-based policy and the permission boundary
- Commonly used to delegate user creation to developers while limiting what permissions those new users can have

```
Effective permissions = Identity-based policies ∩ Permission boundary
```

### Organizations SCPs

Service Control Policies are applied at the AWS Organizations level. They set the **maximum permissions** for accounts in the organization.

- Applied to OUs or accounts (not individual users/roles)
- Do **not grant permissions** — they only restrict what's allowed
- The management account is **never affected** by SCPs
- SCPs affect all users and roles in member accounts, including the account root user

```
Effective permissions = SCPs ∩ Identity-based policies
```

### Session Policies

Policies passed as parameters when creating a temporary session (e.g., when assuming a role or federating).

- Limit the permissions of the session beyond what the role policy allows
- Used with `AssumeRole`, `AssumeRoleWithSAML`, `AssumeRoleWithWebIdentity`, or `GetFederationToken` API calls
- Like permission boundaries, they do not grant permissions — they restrict the session

### Access Control Lists (ACLs)

ACLs are cross-account permission policies used by specific AWS services, primarily **S3** and **VPC** (network ACLs).

- S3 ACLs are a legacy mechanism (bucket policies are preferred)
- VPC Network ACLs control traffic at the subnet level
- ACLs are the only policy type that does not use JSON policy format
- Cannot grant permissions to entities within the same account

---

## Policy Evaluation Logic

Understanding how AWS evaluates policies is one of the most important concepts for the SAA-C03 exam.

### Complete Evaluation Flow

```
Request comes in
        │
        ▼
[1] Is there an explicit DENY in any applicable policy?
    ├── YES → DENY (final)
    └── NO → continue
        │
        ▼
[2] Is there an SCP that allows the action?
    (Only if account is in AWS Organizations)
    ├── NO → DENY (implicit)
    └── YES → continue
        │
        ▼
[3] Is there a resource-based policy that allows the action?
    ├── YES → ALLOW (for same-account AND cross-account*)
    └── NO → continue
        │
        ▼
[4] Is there an identity-based policy that allows the action?
    ├── NO → DENY (implicit)
    └── YES → continue
        │
        ▼
[5] Is there a permission boundary?
    ├── YES → Does the boundary allow the action?
    │   ├── NO → DENY (implicit)
    │   └── YES → continue
    └── NO → continue
        │
        ▼
[6] Is there a session policy?
    ├── YES → Does the session policy allow the action?
    │   ├── NO → DENY (implicit)
    │   └── YES → ALLOW
    └── NO → ALLOW
```

### Key Rules

1. **Explicit Deny always wins.** An explicit Deny in any policy overrides any Allow.
2. **Default is implicit Deny.** If no policy explicitly allows an action, it is denied.
3. **An explicit Allow overrides the implicit Deny** (unless there's also an explicit Deny).
4. **SCPs, Permission Boundaries, and Session Policies are restrictive.** They set the maximum permissions but don't grant anything.
5. **For cross-account access via roles:** The identity policy in the calling account must allow assuming the role, AND the trust policy on the role must trust the caller.
6. **For cross-account access via resource-based policies:** The resource policy can grant access directly (identity policy in the other account is also needed for the principal to be allowed).

### Same-Account vs Cross-Account Evaluation

**Same-account access:**
- If EITHER an identity-based policy OR a resource-based policy allows the action (and no explicit deny), the request is allowed.
- The union of both is the effective permission.

**Cross-account access:**
- BOTH an identity-based policy in the requester's account AND a resource-based policy on the target resource (OR a trust policy + role assumption) must allow the action.
- It's an intersection, not a union.

---

## JSON Policy Structure

Every IAM policy document consists of these elements:

### Version

```json
"Version": "2012-10-17"
```
- Always use `"2012-10-17"` (the current version)
- The older version `"2008-10-17"` does not support policy variables like `${aws:username}`
- **Required** for policies to work correctly with all features

### Statement

An array of individual permission statements. Each statement has these elements:

### Sid (Statement ID)
- Optional identifier for the statement
- Must be unique within a policy
- Example: `"Sid": "AllowS3Read"`

### Effect
- **`Allow`** or **`Deny`**
- Required field

### Principal
- Specifies **who** is allowed or denied access
- Used in **resource-based policies** and **trust policies** only (NOT in identity-based policies)
- Formats:
  ```json
  "Principal": {"AWS": "arn:aws:iam::123456789012:root"}
  "Principal": {"AWS": "arn:aws:iam::123456789012:user/username"}
  "Principal": {"AWS": "arn:aws:iam::123456789012:role/rolename"}
  "Principal": {"Service": "ec2.amazonaws.com"}
  "Principal": {"Federated": "cognito-identity.amazonaws.com"}
  "Principal": "*"
  ```

### Action
- Specifies the AWS API actions to allow or deny
- Format: `"service:action"` or `"service:action*"` (wildcard)
- Examples:
  ```json
  "Action": "s3:GetObject"
  "Action": ["s3:GetObject", "s3:PutObject"]
  "Action": "s3:*"
  "Action": "ec2:Describe*"
  ```
- Use `"NotAction"` to match everything except specified actions

### Resource
- Specifies the AWS resources the statement applies to
- Uses ARN format: `arn:aws:service:region:account-id:resource`
- Examples:
  ```json
  "Resource": "arn:aws:s3:::my-bucket"
  "Resource": "arn:aws:s3:::my-bucket/*"
  "Resource": "*"
  "Resource": "arn:aws:ec2:us-east-1:123456789012:instance/*"
  ```
- Use `"NotResource"` to match everything except specified resources

### Condition
- Optional: specifies conditions for when the policy is in effect
- See the next section for detailed coverage

### Complete Policy Example

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowS3ReadMyBucket",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::my-bucket",
        "arn:aws:s3:::my-bucket/*"
      ],
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": "203.0.113.0/24"
        }
      }
    },
    {
      "Sid": "DenyDeleteOperations",
      "Effect": "Deny",
      "Action": "s3:DeleteObject",
      "Resource": "arn:aws:s3:::my-bucket/*"
    }
  ]
}
```

---

## Condition Operators and Keys

### Condition Operators

| Operator | Type | Description | Example |
|---|---|---|---|
| `StringEquals` | String | Exact, case-sensitive match | `"aws:RequestedRegion": "us-east-1"` |
| `StringNotEquals` | String | Negated exact match | `"aws:RequestedRegion": "sa-east-1"` |
| `StringEqualsIgnoreCase` | String | Case-insensitive match | `"s3:prefix": "Home"` |
| `StringLike` | String | Case-sensitive, supports wildcards (* ?) | `"s3:prefix": "home/*"` |
| `StringNotLike` | String | Negated wildcard match | `"s3:prefix": "secret/*"` |
| `NumericEquals` | Numeric | Exact number match | `"s3:max-keys": "10"` |
| `NumericNotEquals` | Numeric | Negated number match | |
| `NumericLessThan` | Numeric | Less than | `"aws:MultiFactorAuthAge": "3600"` |
| `NumericLessThanEquals` | Numeric | Less than or equal | |
| `NumericGreaterThan` | Numeric | Greater than | |
| `NumericGreaterThanEquals` | Numeric | Greater than or equal | |
| `DateEquals` | Date | Exact date match | `"aws:CurrentTime": "2024-01-01T00:00:00Z"` |
| `DateNotEquals` | Date | Negated date match | |
| `DateLessThan` | Date | Before a date | `"aws:CurrentTime": "2024-12-31T23:59:59Z"` |
| `DateGreaterThan` | Date | After a date | |
| `Bool` | Boolean | Boolean match | `"aws:SecureTransport": "true"` |
| `BinaryEquals` | Binary | Binary match | Used for key conditions |
| `IpAddress` | IP | CIDR match | `"aws:SourceIp": "203.0.113.0/24"` |
| `NotIpAddress` | IP | Negated CIDR match | `"aws:SourceIp": "10.0.0.0/8"` |
| `ArnEquals` | ARN | Exact ARN match | `"aws:SourceArn": "arn:aws:..."` |
| `ArnLike` | ARN | ARN with wildcards | `"aws:SourceArn": "arn:aws:s3:::*"` |
| `Null` | Null | Check if key exists | `"aws:TokenIssueTime": "true"` (true = key is absent) |

### Adding `IfExists`

Append `IfExists` to any operator to make the condition pass if the key is not present in the request:
- `StringEqualsIfExists` — matches if the key exists and equals the value, or if the key doesn't exist at all
- Useful when a condition key might not always be present

### Global Condition Keys

| Key | Description | Example Use |
|---|---|---|
| `aws:SourceIp` | IP of the requester | Restrict to corporate IPs |
| `aws:SourceVpc` | VPC of the requester | Restrict to specific VPC |
| `aws:SourceVpce` | VPC endpoint of the requester | Restrict to VPC endpoint |
| `aws:CurrentTime` | Current date/time | Time-based access |
| `aws:EpochTime` | Current time in epoch seconds | Time-based access |
| `aws:MultiFactorAuthPresent` | MFA was used | Require MFA |
| `aws:MultiFactorAuthAge` | Seconds since MFA auth | Limit MFA session duration |
| `aws:PrincipalOrgId` | Organization ID of principal | Restrict to organization |
| `aws:PrincipalOrgPaths` | Organization path | Restrict to OU hierarchy |
| `aws:PrincipalAccount` | Account ID of principal | Restrict by account |
| `aws:PrincipalArn` | ARN of the principal | Match specific principals |
| `aws:PrincipalTag/tag-key` | Tag on the principal | ABAC (attribute-based) |
| `aws:RequestedRegion` | Target Region of the API call | Region restriction |
| `aws:RequestTag/tag-key` | Tag in the request | Control tagging |
| `aws:ResourceTag/tag-key` | Tag on the resource | ABAC |
| `aws:TagKeys` | Tag keys in the request | Enforce required tags |
| `aws:SecureTransport` | Request used SSL/TLS | Enforce HTTPS |
| `aws:UserAgent` | User-Agent header | (not reliable) |
| `aws:Referer` | HTTP Referer header | (not reliable) |
| `aws:CalledVia` | Services that called on behalf | Track service chains |
| `aws:ViaAWSService` | Request made by an AWS service | Service-to-service calls |
| `aws:PrincipalIsAWSService` | Principal is an AWS service | Service principal checks |
| `aws:PrincipalServiceName` | Name of the service principal | Specific service checks |
| `aws:SourceAccount` | Account ID of the source | S3 event notifications |
| `aws:SourceArn` | ARN of the source | Lambda invocations, SNS |

### Service-Specific Condition Keys

Many services have their own condition keys:

**S3 examples:**
- `s3:x-amz-acl` — ACL specified in request
- `s3:x-amz-server-side-encryption` — Encryption method
- `s3:x-amz-server-side-encryption-aws-kms-key-id` — KMS key ID
- `s3:prefix` — Key prefix
- `s3:max-keys` — Maximum keys returned
- `s3:ExistingObjectTag/tag-key` — Existing object tags

**EC2 examples:**
- `ec2:InstanceType` — Instance type
- `ec2:Region` — Region
- `ec2:ResourceTag/tag-key` — Resource tags
- `ec2:Tenancy` — Tenancy type

### Condition with Multiple Values and Keys

**Multiple values for one key (OR logic within a key):**
```json
"Condition": {
  "StringEquals": {
    "aws:RequestedRegion": ["us-east-1", "eu-west-1"]
  }
}
```
The request Region must be either `us-east-1` OR `eu-west-1`.

**Multiple keys (AND logic between keys):**
```json
"Condition": {
  "StringEquals": {
    "aws:RequestedRegion": "us-east-1"
  },
  "Bool": {
    "aws:MultiFactorAuthPresent": "true"
  }
}
```
The request must be to `us-east-1` AND MFA must be present.

---

## IAM Best Practices

1. **Lock away root account credentials** — Enable MFA, do not create access keys
2. **Create individual IAM users** — Do not share credentials
3. **Use groups to assign permissions** — Manage permissions at scale
4. **Grant least privilege** — Start with minimum permissions, add as needed
5. **Use IAM roles for applications** — Never embed credentials in code
6. **Use IAM roles for cross-account access** — Do not share user credentials between accounts
7. **Rotate credentials regularly** — Passwords and access keys
8. **Use strong password policies** — Minimum length, complexity, rotation
9. **Enable MFA for privileged users** — At minimum for console access
10. **Use policy conditions for extra security** — IP restrictions, MFA requirements, time-based
11. **Monitor with CloudTrail** — Log all API calls
12. **Use IAM Access Analyzer** — Find resources shared externally
13. **Remove unused credentials** — Audit with Credential Reports
14. **Use AWS managed policies when possible** — AWS keeps them updated
15. **Validate your policies** — Use IAM Policy Simulator and Access Analyzer policy validation

### Password Policy Configuration

You can configure the account password policy:
- Minimum password length (6-128 characters)
- Require at least one uppercase letter
- Require at least one lowercase letter
- Require at least one number
- Require at least one non-alphanumeric character
- Allow users to change their own passwords
- Password expiration (1-1095 days)
- Prevent password reuse (remember last 1-24 passwords)
- Require administrator reset after expiration

---

## Cross-Account Access Patterns

### Method 1: Cross-Account Role Assumption (Recommended)

This is the preferred pattern. Account B creates a role that Account A can assume.

**Steps:**
1. **Account B** (the trusting account) creates a role with:
   - A **trust policy** that allows Account A to assume it
   - A **permission policy** that grants the needed access

2. **Account A** (the trusted account) grants its users/roles permission to call `sts:AssumeRole` on the role in Account B

3. **The user/role in Account A** calls `sts:AssumeRole`, receives temporary credentials, and uses them to access Account B's resources

**Trust policy in Account B:**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::111111111111:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "UniqueExternalId123"
        }
      }
    }
  ]
}
```

> **ExternalId** is used to prevent the **confused deputy problem** — where a malicious third party tricks a service into accessing another account's resources. Always use ExternalId for third-party cross-account access.

### Method 2: Resource-Based Policies

Some services allow resource-based policies that directly grant cross-account access:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::111111111111:root"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::shared-bucket/*"
    }
  ]
}
```

**Key difference from role assumption:** With resource-based policies, the principal retains its original identity and permissions while accessing the resource. With role assumption, the principal temporarily gives up its own permissions and gets only the role's permissions.

---

## Federation

Federation allows external identities to access AWS resources without creating IAM users.

### SAML 2.0 Federation

- Integrates with corporate identity providers (Active Directory, Okta, etc.)
- The IdP authenticates the user and provides a SAML assertion
- The assertion is exchanged for temporary AWS credentials via `AssumeRoleWithSAML`
- Supports AWS Management Console access via a sign-in URL
- Requires configuring a SAML provider in IAM and a trust policy on the role

**Flow:**
```
User → Corporate IdP (authenticate) → SAML assertion → AWS STS (AssumeRoleWithSAML) → Temporary credentials → AWS resources
```

### Web Identity Federation

- Used for mobile and web applications
- Users authenticate with a web identity provider (Amazon, Facebook, Google, or any OIDC provider)
- The application exchanges the IdP token for temporary AWS credentials via `AssumeRoleWithWebIdentity`
- **AWS recommends using Cognito instead of calling STS directly** for web identity federation

### Amazon Cognito

- Preferred for web/mobile identity federation
- Provides two components:
  - **User Pools:** User directory for sign-up/sign-in, returns JWT tokens
  - **Identity Pools (Federated Identities):** Exchange tokens for temporary AWS credentials
- Supports authenticated and unauthenticated (guest) access
- Can federate with social IdPs (Google, Facebook, Apple), SAML 2.0, OIDC
- Handles token refresh automatically

**Flow:**
```
User → Authenticate with IdP (or Cognito User Pool) → Token → Cognito Identity Pool → STS → Temporary AWS credentials → AWS resources
```

### AWS IAM Identity Center (formerly AWS SSO)

- **Recommended for enterprise SSO** and multi-account access
- Centralized access management for multiple AWS accounts and business applications
- Built-in identity store, or connect to Active Directory or external SAML 2.0 IdP
- Provides a single user portal for accessing all assigned AWS accounts and applications
- Uses **Permission Sets** to define what a user can do in each account
- Integrates with AWS Organizations

**Key advantages over manual federation:**
- Single sign-on across multiple accounts
- Centralized permission management
- Built-in user portal
- Automatic role and trust policy management

---

## IAM Access Analyzer

IAM Access Analyzer helps you identify resources that are shared with external entities.

### Key Features
- Identifies resources accessible from **outside your account** or **outside your organization**
- Supports: S3 buckets, IAM roles, KMS keys, Lambda functions, SQS queues, Secrets Manager secrets
- Generates **findings** when it detects policies that grant access to external principals
- Continuous monitoring — findings update as policies change
- **Policy validation:** Validates policies against IAM best practices and generates warnings/errors/suggestions
- **Policy generation:** Generates least-privilege policies based on CloudTrail activity
- Zone of trust: Account or Organization

### How It Works
1. Enable Access Analyzer in your account/Region
2. It continuously analyzes resource-based policies
3. It generates findings for any resource accessible outside the zone of trust
4. You review findings and either archive (acceptable) or remediate (update the policy)

---

## AWS STS

AWS Security Token Service (STS) provides temporary, limited-privilege credentials for IAM users or federated users.

### STS API Actions

| API | Use Case | Who Calls It |
|---|---|---|
| `AssumeRole` | Cross-account access, EC2 role delegation | IAM users, roles, AWS services |
| `AssumeRoleWithSAML` | SAML 2.0 federation | SAML-authenticated users |
| `AssumeRoleWithWebIdentity` | Web identity (OIDC) federation | Web/mobile app users |
| `GetSessionToken` | MFA-protected API access | IAM users |
| `GetFederationToken` | Custom federation broker | Federation proxy/broker |
| `GetCallerIdentity` | Identify the caller | Anyone (debug/audit) |
| `DecodeAuthorizationMessage` | Decode encoded error messages | Anyone with permission |

### Temporary Credential Details

- Consist of: **Access Key ID**, **Secret Access Key**, and **Session Token**
- Duration ranges:
  - `AssumeRole`: 15 minutes to 12 hours (default 1 hour)
  - `AssumeRoleWithSAML`: 15 minutes to 12 hours
  - `AssumeRoleWithWebIdentity`: 15 minutes to 12 hours
  - `GetSessionToken`: 15 minutes to 36 hours (12 hours default for IAM users)
  - `GetFederationToken`: 15 minutes to 36 hours
- Temporary credentials cannot be revoked, but you can revoke active sessions for a role by adding a deny-all policy with a date condition
- STS is a global service with a single endpoint (`https://sts.amazonaws.com`) and optional regional endpoints

### STS Regional Endpoints

- By default, STS calls go to the global endpoint in `us-east-1`
- AWS recommends using **regional STS endpoints** for:
  - Reduced latency
  - Added redundancy
  - Compliance with data residency requirements
- Regional endpoints must be activated in the account settings (most are active by default now)
- Regional endpoint format: `https://sts.<region>.amazonaws.com`

---

## Service-Linked Roles vs Service Roles

### Service Roles

- IAM roles that you create to allow an AWS service to access other AWS resources
- **You manage** the trust policy and permissions
- You choose the name and can modify the role
- Example: EC2 instance role, Lambda execution role, ECS task role

### Service-Linked Roles

- Special IAM roles **predefined by the AWS service**
- The trust policy and permissions are defined by the service and **cannot be modified**
- Created automatically by the service or manually by the user
- Named with a specific format: `AWSServiceRoleFor<ServiceName>`
- **Can only be deleted** after all resources using the role are deleted
- Used by services like: ELB, Auto Scaling, RDS, Organizations, Lex, Config, GuardDuty, etc.
- Permissions include only what the service needs (principle of least privilege)

**Key exam distinction:** If a question asks about a role that "an AWS service manages the permissions for," it's a service-linked role. If you can customize the permissions, it's a service role.

---

## Instance Profiles

An instance profile is a container for an IAM role that allows EC2 instances to assume the role.

### Key Facts
- When you create a role for EC2 in the console, an instance profile with the same name is automatically created
- When using the CLI/API, you must create the instance profile separately and add the role to it
- An instance profile can contain **only one role**
- The EC2 instance metadata service (IMDS) delivers the temporary credentials from the role to applications on the instance
- Applications use the SDK or CLI, which automatically retrieve credentials from the instance metadata
- Credential URI in instance metadata: `http://169.254.169.254/latest/meta-data/iam/security-credentials/<role-name>`
- IMDSv2 (recommended) requires a PUT request to get a session token first, then uses the token to fetch metadata (mitigates SSRF attacks)

---

## Policy Variables and Tags

### Policy Variables

Policy variables allow you to create generic policies that use placeholder values replaced at evaluation time.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::my-bucket/home/${aws:username}/*"
    }
  ]
}
```

**Common policy variables:**
| Variable | Description |
|---|---|
| `${aws:username}` | IAM user name |
| `${aws:userid}` | Unique identifier |
| `${aws:PrincipalTag/tag-key}` | Tag on the principal |
| `${aws:RequestTag/tag-key}` | Tag in the request |
| `${aws:ResourceTag/tag-key}` | Tag on the resource |
| `${aws:CurrentTime}` | Current time |
| `${aws:EpochTime}` | Epoch timestamp |
| `${aws:TokenIssueTime}` | When token was issued |
| `${aws:PrincipalOrgId}` | Organization ID |
| `${ec2:ResourceTag/tag-key}` | EC2 resource tags |
| `${s3:prefix}` | S3 key prefix |

> **Important:** Policy variables require `"Version": "2012-10-17"`. The older `"2008-10-17"` version does not support them.

### Attribute-Based Access Control (ABAC)

ABAC uses tags as attributes to control access. This is increasingly important and commonly tested.

**Example: Allow access based on matching department tags:**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:StartInstances",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "ec2:ResourceTag/Department": "${aws:PrincipalTag/Department}"
        }
      }
    }
  ]
}
```

This allows a user to start only EC2 instances whose `Department` tag matches the user's `Department` tag. When a new department is added, no policy changes are needed — just tag the user and instances.

**ABAC advantages over traditional RBAC:**
- Scales better — fewer policies needed
- Permissions automatically adjust based on tags
- Useful for rapidly changing environments
- Less administrative overhead

---

## IAM Quotas and Limits

| Resource | Default Limit | Can Increase? |
|---|---|---|
| IAM users per account | 5,000 | No |
| IAM groups per account | 300 | Yes |
| IAM roles per account | 1,000 | Yes |
| Managed policies per account | 1,500 | Yes |
| Groups per user | 10 | No |
| Managed policies attached to a user/role/group | 10 | Yes (up to 20) |
| Inline policies per user | Unlimited (but 2,048 char limit on user inline policy total) | N/A |
| Versions per managed policy | 5 | No |
| Access keys per user | 2 | No |
| SSH public keys per user | 5 | No |
| MFA devices per user | 8 | No |
| SAML providers per account | 100 | No |
| Identity providers (OIDC) | 100 | No |
| Instance profiles per account | 1,000 | Yes |
| Server certificates per account | 20 | Yes |
| Policy document size (managed) | 6,144 characters | No |
| Policy document size (inline) | 2,048 characters (user), 10,240 (role), 5,120 (group) | No |
| Trust policy size | 2,048 characters | Yes (up to 4,096) |
| Role session duration max | 12 hours | No |
| Account alias length | 3-63 characters | No |
| Path length | 512 characters | No |

---

## Permission Boundaries Deep Dive

Permission boundaries are one of the most nuanced and commonly tested advanced IAM concepts.

### How Permission Boundaries Work

A permission boundary is a managed policy (AWS-managed or customer-managed) used as a **ceiling** on an IAM entity's permissions.

**Effective permissions formula:**
```
Effective permissions = Identity-based policies ∩ Permission boundary
```

An action is allowed only if it is permitted by BOTH the identity-based policy AND the permission boundary.

### Use Case: Delegated Administration

**Scenario:** You want developers to create IAM users and roles for their applications, but you don't want them to escalate their own privileges.

**Solution:**
1. Create a permission boundary policy that limits what new users/roles can do
2. Allow developers to create users/roles BUT require them to attach the permission boundary

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowCreateUsersWithBoundary",
      "Effect": "Allow",
      "Action": [
        "iam:CreateUser",
        "iam:CreateRole",
        "iam:AttachUserPolicy",
        "iam:AttachRolePolicy",
        "iam:PutUserPermissionsBoundary",
        "iam:PutRolePermissionsBoundary"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "iam:PermissionsBoundary": "arn:aws:iam::123456789012:policy/DeveloperBoundary"
        }
      }
    },
    {
      "Sid": "DenyBoundaryRemoval",
      "Effect": "Deny",
      "Action": [
        "iam:DeleteUserPermissionsBoundary",
        "iam:DeleteRolePermissionsBoundary"
      ],
      "Resource": "*"
    }
  ]
}
```

### Visual Example

```
Developer's Identity Policy:
  Allow: s3:*, ec2:*, lambda:*, iam:Create*, iam:Attach*, iam:Put*

Developer's Permission Boundary:
  Allow: s3:*, ec2:*, lambda:*

Effective Permissions (intersection):
  Allow: s3:*, ec2:*, lambda:*
  (iam actions from identity policy are blocked by the boundary)
```

Wait — that's the developer's boundary. The developer can then create new users/roles and must attach a boundary to them:

```
New Role's Identity Policy (created by developer):
  Allow: s3:*, dynamodb:*

New Role's Permission Boundary (DeveloperBoundary):
  Allow: s3:GetObject, s3:PutObject, dynamodb:GetItem

Effective Permissions for New Role:
  Allow: s3:GetObject, s3:PutObject, dynamodb:GetItem
  (Intersection of the two)
```

### Permission Boundaries + SCPs + Identity Policies

When all three are in play:
```
Effective permissions = SCPs ∩ Permission boundary ∩ Identity-based policies
```

All three must allow the action for it to be permitted (with explicit Deny always winning).

---

## Resource-Based vs Identity-Based Policies Comparison

| Feature | Identity-Based | Resource-Based |
|---|---|---|
| **Attached to** | Users, groups, roles | Resources (S3, SQS, KMS, etc.) |
| **Principal element** | Not used (implied by attachment) | Required (who gets access) |
| **Cross-account** | Requires role assumption | Grants access directly |
| **Principal retains identity** | No (assumes role's permissions) | Yes (keeps own permissions) |
| **Supported by all services** | Yes | No (limited set of services) |
| **Can be managed policy** | Yes | No (always inline) |
| **Same-account evaluation** | Union with resource-based | Union with identity-based |
| **Cross-account evaluation** | Must allow in source account | Must allow on target resource |

### When to Use Each

**Use identity-based policies when:**
- Managing permissions for your own users/roles
- Applying permissions across many resources
- Centralizing permission management

**Use resource-based policies when:**
- Granting cross-account access (simpler than role assumption)
- Controlling access at the resource level
- The principal needs to retain its own permissions (e.g., Lambda accessing S3 in another account needs both its execution role permissions AND the target bucket's permissions)

---

## Trust Policies for Roles

Every IAM role has a trust policy that specifies who can assume the role.

### Trust Policy Structure

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

### Trust Policy Examples

**Allow a specific IAM user to assume the role:**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::111111111111:user/DevUser"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

**Allow an entire account to assume the role:**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::111111111111:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "12345"
        }
      }
    }
  ]
}
```

**Allow an AWS service to assume the role:**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

**Allow SAML federation:**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::123456789012:saml-provider/MyIdP"
      },
      "Action": "sts:AssumeRoleWithSAML",
      "Condition": {
        "StringEquals": {
          "SAML:aud": "https://signin.aws.amazon.com/saml"
        }
      }
    }
  ]
}
```

**Require MFA to assume the role:**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::111111111111:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "Bool": {
          "aws:MultiFactorAuthPresent": "true"
        }
      }
    }
  ]
}
```

**Allow any principal in the organization:**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "aws:PrincipalOrgID": "o-abc123def4"
        }
      }
    }
  ]
}
```

---

## Common Exam Scenarios

### Scenario 1: Application on EC2 Needs to Access S3
**Question:** An application running on EC2 needs to read from an S3 bucket. How should you configure access?

**Answer:** Create an IAM role with S3 read permissions and attach it to the EC2 instance via an instance profile. Never use access keys embedded in the application.

---

### Scenario 2: Cross-Account S3 Access
**Question:** Account A needs to access an S3 bucket in Account B. What are the options?

**Answer:**
1. **Role assumption:** Account B creates a role trusting Account A. Account A users assume the role.
2. **Bucket policy:** Account B's bucket policy grants access to Account A's principal.
3. **ACLs:** (Legacy) Grant access via S3 ACLs.

Best practice: Use bucket policy for simple read access, role assumption for complex scenarios.

---

### Scenario 3: Enforce MFA for Sensitive Actions
**Question:** How do you require MFA for deleting objects in S3?

**Answer:** Add a Deny policy with a condition that the action is denied when MFA is not present:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Action": "s3:DeleteObject",
      "Resource": "arn:aws:s3:::important-bucket/*",
      "Condition": {
        "BoolIfExists": {
          "aws:MultiFactorAuthPresent": "false"
        }
      }
    }
  ]
}
```

---

### Scenario 4: Developer Privilege Escalation Prevention
**Question:** How do you allow developers to create IAM roles without letting them escalate privileges?

**Answer:** Use permission boundaries. Require that any role a developer creates must have a specific permission boundary attached. Also deny the ability to remove the boundary.

---

### Scenario 5: Restrict Access to Specific Regions
**Question:** How do you ensure users can only launch resources in `eu-west-1` and `eu-central-1`?

**Answer:** Use an SCP (in Organizations) or IAM policy with the `aws:RequestedRegion` condition:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "NotAction": ["iam:*", "sts:*", "organizations:*", "support:*"],
      "Resource": "*",
      "Condition": {
        "StringNotEquals": {
          "aws:RequestedRegion": ["eu-west-1", "eu-central-1"]
        }
      }
    }
  ]
}
```

---

### Scenario 6: Third-Party Cross-Account Access
**Question:** A third-party SaaS vendor needs access to your S3 bucket. How do you grant access securely?

**Answer:** Create a cross-account role with an `ExternalId` condition in the trust policy. The ExternalId prevents the confused deputy problem — ensure the vendor provides a unique ExternalId that only they know.

---

### Scenario 7: Temporary Access for Contractors
**Question:** Contractors need temporary AWS access for a 3-month project.

**Answer:** Several options:
1. Use IAM Identity Center with time-limited permission sets
2. Create IAM users with console access and set a password expiration
3. Use federated access through their existing identity provider
4. Create IAM roles and provide temporary credentials via STS

Best practice: Use federation or IAM Identity Center; avoid creating IAM users for temporary access.

---

### Scenario 8: Policy Conflict Resolution
**Question:** A user has an identity policy that allows `s3:*` on all resources. There's also a bucket policy that denies `s3:DeleteObject` from everyone. Can the user delete objects?

**Answer:** No. Explicit Deny always wins, regardless of which policy type contains it. The bucket policy's explicit Deny overrides the identity policy's Allow.

---

### Scenario 9: Service-Linked Role Cannot Be Deleted
**Question:** You're trying to delete a service-linked role for Elastic Load Balancing but getting an error.

**Answer:** Service-linked roles can only be deleted after all resources that depend on them are removed. Delete all ELB resources first, then delete the service-linked role.

---

### Scenario 10: IAM Policy Size Limit
**Question:** Your IAM policy is exceeding the 6,144-character limit.

**Answer:**
1. Use wildcards to condense actions (e.g., `s3:Get*` instead of listing every Get action)
2. Use AWS managed policies where possible
3. Split into multiple policies (up to 10 managed policies per entity, can be increased to 20)
4. Use shorter resource ARN patterns
5. Remove unnecessary whitespace and comments

---

## Summary

IAM is the backbone of AWS security. For the SAA-C03 exam, focus on:

1. **Policy evaluation logic** — especially explicit deny, implicit deny, and the evaluation order
2. **Cross-account access** — role assumption vs resource-based policies
3. **Permission boundaries** — how they limit effective permissions
4. **Federation** — SAML, Web Identity, Cognito, Identity Center
5. **Best practices** — roles for EC2, no root usage, MFA, least privilege
6. **Condition keys** — aws:SourceIp, aws:RequestedRegion, aws:MultiFactorAuthPresent, aws:PrincipalOrgID
7. **STS API actions** — which to use in which scenario
8. **Service-linked roles** — what they are, how they differ from service roles
9. **ABAC** — using tags for access control
10. **Resource-based policies** — which services support them and how they affect cross-account evaluation
