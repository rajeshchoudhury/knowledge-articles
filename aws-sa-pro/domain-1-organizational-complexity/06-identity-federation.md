# Identity Federation in AWS

## AWS Solutions Architect Professional (SAP-C02) — Domain 1: Design Solutions for Organizational Complexity

---

## Table of Contents

1. [Introduction](#introduction)
2. [Federation Fundamentals](#federation-fundamentals)
3. [SAML 2.0 Federation](#saml-20-federation)
4. [AWS IAM Identity Center (SSO)](#aws-iam-identity-center-sso)
5. [OIDC Federation](#oidc-federation)
6. [Amazon Cognito — User Pools](#amazon-cognito--user-pools)
7. [Amazon Cognito — Identity Pools](#amazon-cognito--identity-pools)
8. [Cognito User Pools + Identity Pools Combined](#cognito-user-pools--identity-pools-combined)
9. [Custom Identity Broker Pattern](#custom-identity-broker-pattern)
10. [Active Directory Federation](#active-directory-federation)
11. [Web Identity Federation with STS](#web-identity-federation-with-sts)
12. [AssumeRoleWithSAML vs AssumeRoleWithWebIdentity](#assumerolewithsaml-vs-assumerolewithwebidentity)
13. [Cross-Account Access with Federation](#cross-account-access-with-federation)
14. [Token Vending Machine Pattern (Legacy)](#token-vending-machine-pattern-legacy)
15. [Attribute-Based Access Control (ABAC)](#attribute-based-access-control-abac)
16. [Federation Decision Tree for Exam](#federation-decision-tree-for-exam)
17. [Exam Scenarios](#exam-scenarios)
18. [Exam Tips Summary](#exam-tips-summary)

---

## Introduction

Identity federation allows users to authenticate with an external identity provider (IdP) and receive temporary AWS credentials. This eliminates the need to create IAM users for every person or application that needs AWS access. The SAP-C02 exam heavily tests federation patterns — from SAML 2.0 for enterprise workforce to Cognito for customer-facing applications.

This article covers every federation mechanism in AWS, with detailed flow diagrams, policy examples, and exam-specific guidance.

---

## Federation Fundamentals

### What is Federation?

Federation is the process of establishing trust between an identity provider (IdP) and a service provider (SP) so that users authenticated by the IdP can access resources managed by the SP.

```
┌──────────────┐     Trust     ┌──────────────┐
│  Identity     │←────────────→│  Service      │
│  Provider     │  (metadata   │  Provider     │
│  (IdP)        │   exchange)  │  (AWS)        │
│               │              │               │
│  Authenticates│              │  Authorizes   │
│  users        │              │  access to    │
│               │              │  resources    │
└──────────────┘              └──────────────┘
         │                           │
         │  1. User authenticates    │
         │                           │
         │  2. IdP issues token/     │
         │     assertion             │
         │                           │
         │  3. User presents token   │
         │     to AWS ──────────────→│
         │                           │
         │  4. AWS returns temporary │
         │     credentials ←─────────│
```

### Federation Types in AWS

| Type | Protocol | Use Case | AWS Service |
|---|---|---|---|
| **SAML 2.0** | SAML | Enterprise workforce (SSO) | IAM, Identity Center |
| **OIDC** | OpenID Connect | Mobile/web apps | IAM, Cognito |
| **Custom** | Proprietary | Legacy identity systems | Custom Identity Broker |
| **Social** | OAuth 2.0 | Consumer apps (Google, Facebook) | Cognito |
| **AD** | Kerberos/LDAP | Windows enterprise | Identity Center, AD Connector |

### AWS Security Token Service (STS)

STS is the foundation of all federation in AWS. It issues temporary credentials:

| STS API | Use Case |
|---|---|
| `AssumeRole` | Cross-account access, EC2 role, Lambda role |
| `AssumeRoleWithSAML` | SAML 2.0 federation |
| `AssumeRoleWithWebIdentity` | OIDC/web identity federation |
| `GetFederationToken` | Custom identity broker |
| `GetSessionToken` | MFA for IAM users |
| `DecodeAuthorizationMessage` | Decode encoded authorization failure |

**Temporary Credentials Components**:
- **AccessKeyId**: Temporary access key
- **SecretAccessKey**: Temporary secret key
- **SessionToken**: Session token (must be included in API calls)
- **Expiration**: When credentials expire (configurable)

---

## SAML 2.0 Federation

### Overview

SAML 2.0 (Security Assertion Markup Language) is the standard protocol for enterprise Single Sign-On. It's used by identity providers like:
- Microsoft ADFS (Active Directory Federation Services)
- Okta
- Ping Identity
- OneLogin
- Azure AD
- Google Workspace

### SAML Federation Flow (Console Access)

```
┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│  User    │     │  IdP     │     │  AWS STS  │     │  AWS     │
│  Browser │     │  (ADFS)  │     │          │     │  Console │
└────┬─────┘     └────┬─────┘     └────┬─────┘     └────┬─────┘
     │                │                │                │
     │ 1. Access      │                │                │
     │    IdP portal  │                │                │
     │──────────────>│                │                │
     │                │                │                │
     │ 2. Authenticate│                │                │
     │    (username/  │                │                │
     │     password)  │                │                │
     │──────────────>│                │                │
     │                │                │                │
     │ 3. SAML        │                │                │
     │    Assertion   │                │                │
     │<──────────────│                │                │
     │                │                │                │
     │ 4. POST SAML Assertion to AWS SSO endpoint      │
     │────────────────────────────────>│                │
     │                │                │                │
     │                │                │ 5. Validate    │
     │                │                │    assertion   │
     │                │                │ 6. AssumeRole  │
     │                │                │    WithSAML    │
     │                │                │                │
     │ 7. Redirect to Console with temp credentials    │
     │────────────────────────────────────────────────>│
     │                │                │                │
```

### SAML Federation Flow (API Access)

```
┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│  App     │     │  IdP     │     │  AWS STS  │     │  AWS     │
│          │     │  (ADFS)  │     │          │     │  Service │
└────┬─────┘     └────┬─────┘     └────┬─────┘     └────┬─────┘
     │                │                │                │
     │ 1. Auth request│                │                │
     │──────────────>│                │                │
     │                │                │                │
     │ 2. SAML        │                │                │
     │    Assertion   │                │                │
     │<──────────────│                │                │
     │                │                │                │
     │ 3. AssumeRoleWithSAML          │                │
     │    (assertion + role ARN)      │                │
     │────────────────────────────────>│                │
     │                │                │                │
     │ 4. Temporary credentials       │                │
     │<────────────────────────────────│                │
     │                │                │                │
     │ 5. API call with temp creds    │                │
     │────────────────────────────────────────────────>│
```

### IAM Configuration for SAML

**1. Create SAML Identity Provider**:
```bash
aws iam create-saml-provider \
  --saml-metadata-document file://idp-metadata.xml \
  --name "CorporateADFS"
```

**2. Create IAM Role with SAML Trust**:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::111111111111:saml-provider/CorporateADFS"
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

**3. SAML Assertion Attribute Mapping**:
```xml
<!-- SAML Assertion attributes that AWS expects -->

<!-- Required: Role and Provider ARNs -->
<Attribute Name="https://aws.amazon.com/SAML/Attributes/Role">
  <AttributeValue>
    arn:aws:iam::111111111111:role/SAMLRole,arn:aws:iam::111111111111:saml-provider/CorporateADFS
  </AttributeValue>
</Attribute>

<!-- Required: Unique identifier for the user -->
<Attribute Name="https://aws.amazon.com/SAML/Attributes/RoleSessionName">
  <AttributeValue>{user.email}</AttributeValue>
</Attribute>

<!-- Optional: Session duration (max 12 hours) -->
<Attribute Name="https://aws.amazon.com/SAML/Attributes/SessionDuration">
  <AttributeValue>3600</AttributeValue>
</Attribute>

<!-- Optional: Session tags for ABAC -->
<Attribute Name="https://aws.amazon.com/SAML/Attributes/PrincipalTag:Department">
  <AttributeValue>{user.department}</AttributeValue>
</Attribute>
```

### Multi-Account SAML Federation

For accessing multiple accounts via SAML:
```xml
<!-- Multiple roles in SAML assertion -->
<Attribute Name="https://aws.amazon.com/SAML/Attributes/Role">
  <AttributeValue>
    arn:aws:iam::111111111111:role/ProdAdmin,arn:aws:iam::111111111111:saml-provider/ADFS
  </AttributeValue>
  <AttributeValue>
    arn:aws:iam::222222222222:role/DevAdmin,arn:aws:iam::222222222222:saml-provider/ADFS
  </AttributeValue>
  <AttributeValue>
    arn:aws:iam::333333333333:role/ReadOnly,arn:aws:iam::333333333333:saml-provider/ADFS
  </AttributeValue>
</Attribute>
```

The user sees a role picker in the AWS console showing all available roles.

> **Exam Tip**: SAML 2.0 federation is for **workforce identity** (employees accessing AWS console/API). Each account needs its own SAML provider and roles. For simplified multi-account access, use IAM Identity Center instead.

---

## AWS IAM Identity Center (SSO)

### Overview

IAM Identity Center (formerly AWS SSO) is the recommended approach for managing workforce access to multiple AWS accounts and applications. It integrates natively with AWS Organizations.

### Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                   IAM Identity Center                         │
│                                                                │
│  ┌────────────────────────────────────────────────────────┐  │
│  │  Identity Source (choose one):                          │  │
│  │  ├── Identity Center Directory (built-in)               │  │
│  │  ├── Active Directory (Managed AD or AD Connector)      │  │
│  │  └── External IdP (Okta, Azure AD, Ping, OneLogin)     │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌────────────────────────────────────────────────────────┐  │
│  │  Permission Sets:                                       │  │
│  │  ├── AdministratorAccess (AWS managed)                  │  │
│  │  ├── PowerUserAccess (AWS managed)                      │  │
│  │  ├── ReadOnlyAccess (AWS managed)                       │  │
│  │  ├── CustomDevOpsAccess (custom: specific services)    │  │
│  │  └── CustomSecurityAudit (custom: security tools)      │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌────────────────────────────────────────────────────────┐  │
│  │  Account Assignments:                                   │  │
│  │                                                          │  │
│  │  Group: Platform-Admins                                  │  │
│  │  ├── Account: Prod → PermSet: AdministratorAccess      │  │
│  │  ├── Account: Dev → PermSet: AdministratorAccess       │  │
│  │  └── Account: Network → PermSet: NetworkAdmin          │  │
│  │                                                          │  │
│  │  Group: Developers                                       │  │
│  │  ├── Account: Dev → PermSet: PowerUserAccess           │  │
│  │  ├── Account: Staging → PermSet: ReadOnlyAccess        │  │
│  │  └── Account: Prod → PermSet: ReadOnlyAccess           │  │
│  │                                                          │  │
│  │  Group: Security-Team                                    │  │
│  │  ├── Account: ALL → PermSet: SecurityAudit             │  │
│  │  └── Account: Security → PermSet: AdministratorAccess  │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                                │
│  SSO Portal: https://company.awsapps.com/start               │
└──────────────────────────────────────────────────────────────┘
```

### How Identity Center Works

```
1. User navigates to SSO portal
2. Authenticates with identity source (AD, external IdP, built-in)
3. Sees list of assigned accounts and permission sets
4. Clicks desired account/permission set
5. Identity Center creates temporary IAM role credentials
6. User is signed into AWS Console (or receives CLI credentials)
```

### Permission Sets

Permission sets define what a user can do in an account:

```json
{
  "Name": "CustomDevOpsAccess",
  "Description": "DevOps access for CI/CD and infrastructure",
  "SessionDuration": "PT4H",
  "ManagedPolicies": [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
  ],
  "InlinePolicy": {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Deny",
        "Action": [
          "ec2:*Host*",
          "ec2:*ReservedInstances*"
        ],
        "Resource": "*"
      }
    ]
  },
  "PermissionsBoundary": {
    "ManagedPolicyArn": "arn:aws:iam::111111111111:policy/DevBoundary"
  }
}
```

### Permission Set Components

| Component | Description |
|---|---|
| **AWS Managed Policies** | Pre-built AWS policies (up to 10) |
| **Customer Managed Policy** | Reference to policy in target accounts |
| **Inline Policy** | Custom policy defined in the permission set |
| **Permissions Boundary** | Maximum permissions boundary |
| **Session Duration** | How long credentials are valid (1–12 hours) |
| **Relay State** | URL to redirect to after authentication |

### Identity Center with ABAC

Attribute-Based Access Control maps identity attributes to session tags:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::project-bucket/${aws:PrincipalTag/Project}/*",
      "Condition": {
        "StringEquals": {
          "s3:ExistingObjectTag/Department": "${aws:PrincipalTag/Department}"
        }
      }
    }
  ]
}
```

**How ABAC works with Identity Center**:
1. User attributes (Department, Project, Team) are synced from IdP
2. Identity Center maps attributes to AWS session tags
3. IAM policies use `${aws:PrincipalTag/KEY}` for dynamic authorization
4. Access decisions based on user attributes, not explicit per-user permissions

### Identity Center vs Direct SAML Federation

| Feature | Identity Center | Direct SAML (IAM) |
|---|---|---|
| Multi-account support | Built-in, centralized | Manual per-account setup |
| Application access | Yes (SaaS apps) | No |
| Permission management | Permission Sets | IAM roles per account |
| ABAC | Built-in attribute mapping | Manual SAML attribute config |
| User portal | Yes (SSO portal) | No |
| CLI/SDK support | Yes (SSO profiles) | Manual STS calls |
| Organization integration | Native | Manual |
| Setup complexity | Low | High (per account) |

### Identity Center CLI Configuration

```ini
# ~/.aws/config

[profile dev-admin]
sso_start_url = https://company.awsapps.com/start
sso_region = us-east-1
sso_account_id = 111111111111
sso_role_name = AdministratorAccess
region = us-east-1

[profile prod-readonly]
sso_start_url = https://company.awsapps.com/start
sso_region = us-east-1
sso_account_id = 222222222222
sso_role_name = ReadOnlyAccess
region = us-east-1
```

```bash
# Login to SSO
aws sso login --profile dev-admin

# Use profile
aws s3 ls --profile dev-admin
```

> **Exam Tip**: IAM Identity Center is the **recommended** approach for workforce access to multiple AWS accounts. It replaces manual SAML federation with each account. Know the difference between permission sets (what you CAN do) and account assignments (WHERE you can do it). Identity Center can ONLY be deployed in the management account or a delegated admin account.

---

## OIDC Federation

### Overview

OpenID Connect (OIDC) federation allows applications (mobile, web, IoT) to authenticate users with OIDC-compatible providers and exchange tokens for AWS credentials.

### OIDC Federation Flow

```
┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│  Mobile  │     │  OIDC    │     │  AWS STS  │     │  AWS     │
│  App     │     │  Provider│     │          │     │  Service │
└────┬─────┘     └────┬─────┘     └────┬─────┘     └────┬─────┘
     │                │                │                │
     │ 1. Auth request│                │                │
     │──────────────>│                │                │
     │                │                │                │
     │ 2. ID Token    │                │                │
     │    (JWT)       │                │                │
     │<──────────────│                │                │
     │                │                │                │
     │ 3. AssumeRoleWithWebIdentity   │                │
     │    (ID Token + Role ARN)       │                │
     │────────────────────────────────>│                │
     │                │                │                │
     │ 4. Temporary AWS credentials   │                │
     │<────────────────────────────────│                │
     │                │                │                │
     │ 5. API call                    │                │
     │────────────────────────────────────────────────>│
```

### IAM OIDC Identity Provider

```bash
# Create OIDC provider in IAM
aws iam create-open-id-connect-provider \
  --url "https://accounts.google.com" \
  --client-id-list "123456789.apps.googleusercontent.com" \
  --thumbprint-list "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
```

### IAM Role Trust Policy for OIDC

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::111111111111:oidc-provider/accounts.google.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "accounts.google.com:aud": "123456789.apps.googleusercontent.com",
          "accounts.google.com:sub": "user-id-12345"
        }
      }
    }
  ]
}
```

### EKS OIDC Provider (IRSA)

IAM Roles for Service Accounts (IRSA) uses OIDC federation:

```
EKS Pod → Service Account (annotated with IAM role)
  → OIDC token projected into pod
  → AWS SDK calls AssumeRoleWithWebIdentity
  → Receives temporary credentials for the annotated role
```

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::111111111111:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "oidc.eks.us-east-1.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE:sub": "system:serviceaccount:default:my-service-account",
          "oidc.eks.us-east-1.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE:aud": "sts.amazonaws.com"
        }
      }
    }
  ]
}
```

---

## Amazon Cognito — User Pools

### What are User Pools?

User Pools are **user directories** for authentication. They handle:
- User registration and sign-up
- User sign-in (authentication)
- Password policies and recovery
- MFA (SMS, TOTP, email)
- Email/phone verification
- Social and enterprise federation
- Hosted UI
- Token management (ID, Access, Refresh tokens)

### User Pool Architecture

```
┌──────────────────────────────────────────────────────────────┐
│  Cognito User Pool                                            │
│                                                                │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │  User Directory                                          │ │
│  │  ├── Users (stored in Cognito)                           │ │
│  │  ├── Groups                                               │ │
│  │  ├── Custom Attributes                                    │ │
│  │  └── Schema (standard + custom attributes)                │ │
│  └─────────────────────────────────────────────────────────┘ │
│                                                                │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │  Authentication                                          │ │
│  │  ├── Username/Password                                    │ │
│  │  ├── SRP (Secure Remote Password)                         │ │
│  │  └── Custom Auth (Lambda triggers)                        │ │
│  └─────────────────────────────────────────────────────────┘ │
│                                                                │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │  Federation (Identity Providers)                         │ │
│  │  ├── Social: Google, Facebook, Amazon, Apple             │ │
│  │  ├── SAML: Okta, ADFS, Azure AD                          │ │
│  │  └── OIDC: Any OIDC-compliant provider                   │ │
│  └─────────────────────────────────────────────────────────┘ │
│                                                                │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │  MFA                                                     │ │
│  │  ├── SMS                                                  │ │
│  │  ├── TOTP (authenticator app)                             │ │
│  │  └── Email (one-time code)                                │ │
│  └─────────────────────────────────────────────────────────┘ │
│                                                                │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │  Lambda Triggers                                         │ │
│  │  ├── Pre Sign-up (validate/auto-confirm)                  │ │
│  │  ├── Post Confirmation (welcome email, create profile)    │ │
│  │  ├── Pre Authentication (custom validation)               │ │
│  │  ├── Post Authentication (logging, analytics)             │ │
│  │  ├── Pre Token Generation (add/modify claims)             │ │
│  │  ├── Custom Message (customize emails/SMS)                │ │
│  │  ├── User Migration (lazy migration from legacy)         │ │
│  │  ├── Define Auth Challenge (custom auth flow)             │ │
│  │  ├── Create Auth Challenge                                │ │
│  │  └── Verify Auth Challenge                                │ │
│  └─────────────────────────────────────────────────────────┘ │
│                                                                │
│  Tokens Issued:                                                │
│  ├── ID Token (JWT): User identity claims                     │
│  ├── Access Token (JWT): Authorization claims                 │
│  └── Refresh Token: Obtain new ID/Access tokens               │
└──────────────────────────────────────────────────────────────┘
```

### User Pool Tokens

| Token | Purpose | Contains | Expiration |
|---|---|---|---|
| **ID Token** | Identify the user | User attributes (name, email, custom) | 5 min – 1 day |
| **Access Token** | Authorize API access | Scopes, groups | 5 min – 1 day |
| **Refresh Token** | Get new tokens | Opaque token | 60 min – 10 years |

### Hosted UI

Cognito provides a built-in authentication UI:
```
https://YOUR_DOMAIN.auth.REGION.amazoncognito.com/login?
  client_id=APP_CLIENT_ID
  &response_type=code
  &scope=email+openid+profile
  &redirect_uri=https://your-app.com/callback
```

Features:
- Customizable with CSS
- Supports all configured IdPs
- Handles sign-up, sign-in, password reset
- OAuth 2.0 / OIDC compliant

### User Migration Trigger

Migrate users from legacy identity systems on first sign-in:
```
User signs in with old credentials
  → Cognito triggers User Migration Lambda
    → Lambda authenticates against legacy system
    → If successful, returns user attributes to Cognito
    → Cognito creates user in User Pool
    → User is signed in
  → Subsequent sign-ins use Cognito directly
```

### Advanced Security Features

- **Adaptive Authentication**: Risk-based authentication that challenges suspicious logins
- **Compromised Credentials Detection**: Checks passwords against known leaked databases
- **Account Takeover Protection**: Detects and blocks suspicious login patterns
- **IP Address Tracking**: Logs and analyzes login IP addresses

> **Exam Tip**: User Pools are for **authentication** (who are you?). They are NOT for AWS authorization. To get AWS credentials from User Pool tokens, you need Cognito Identity Pools. The exam often asks about User Pools for customer-facing applications.

---

## Amazon Cognito — Identity Pools

### What are Identity Pools?

Identity Pools (Federated Identities) provide **temporary AWS credentials** to users. They handle:
- Mapping authenticated users to IAM roles
- Providing AWS credentials to unauthenticated (guest) users
- Supporting multiple identity providers simultaneously
- Fine-grained access control via IAM policies

### Identity Pool Architecture

```
┌──────────────────────────────────────────────────────────────┐
│  Cognito Identity Pool                                        │
│                                                                │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │  Identity Providers                                      │ │
│  │  ├── Cognito User Pool (Token)                           │ │
│  │  ├── Social: Google, Facebook, Amazon, Apple, Twitter    │ │
│  │  ├── SAML Identity Provider                               │ │
│  │  ├── OIDC Provider                                        │ │
│  │  └── Custom Developer Provider                            │ │
│  └─────────────────────────────────────────────────────────┘ │
│                                                                │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │  Role Mapping                                            │ │
│  │  ├── Default Role (for authenticated users)               │ │
│  │  ├── Default Role (for unauthenticated users)             │ │
│  │  ├── Rules-based mapping:                                 │ │
│  │  │   ├── If claim "custom:role" = "admin" → AdminRole    │ │
│  │  │   ├── If claim "custom:role" = "user" → UserRole      │ │
│  │  │   └── If claim "cognito:groups" contains "premium"     │ │
│  │  │       → PremiumRole                                    │ │
│  │  └── Token-based mapping:                                 │ │
│  │      └── Use "cognito:preferred_role" from token          │ │
│  └─────────────────────────────────────────────────────────┘ │
│                                                                │
│  Output:                                                       │
│  ├── Temporary AWS Credentials (STS)                          │
│  ├── Identity ID (unique per user per identity pool)         │
│  └── Valid for IAM role permissions                            │
└──────────────────────────────────────────────────────────────┘
```

### Identity Pool Flow

```
1. User authenticates with IdP (User Pool, Google, etc.)
2. User receives IdP token (ID Token, OAuth token)
3. App sends token to Cognito Identity Pool
4. Identity Pool validates token with IdP
5. Identity Pool returns:
   - Identity ID (unique identifier)
   - STS temporary credentials (mapped IAM role)
6. App uses credentials to access AWS services (S3, DynamoDB, etc.)
```

### Fine-Grained Access Control

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::user-data/${cognito-identity.amazonaws.com:sub}/*"
    },
    {
      "Effect": "Allow",
      "Action": "dynamodb:*",
      "Resource": "arn:aws:dynamodb:us-east-1:111111111111:table/UserData",
      "Condition": {
        "ForAllValues:StringEquals": {
          "dynamodb:LeadingKeys": ["${cognito-identity.amazonaws.com:sub}"]
        }
      }
    }
  ]
}
```

This policy uses the Cognito identity ID as a partition key, ensuring users can only access their own data.

### Unauthenticated (Guest) Access

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "arn:aws:s3:::public-content/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "mobileanalytics:PutEvents"
      ],
      "Resource": "*"
    }
  ]
}
```

> **Exam Tip**: Identity Pools are for **authorization** (AWS credentials). They map IdP tokens to IAM roles. Use `${cognito-identity.amazonaws.com:sub}` for per-user data isolation. Know the difference between authenticated and unauthenticated roles.

---

## Cognito User Pools + Identity Pools Combined

### Complete Architecture

```
┌──────────┐    ┌────────────────┐    ┌──────────────────┐    ┌──────────┐
│  Mobile  │    │  Cognito       │    │  Cognito         │    │  AWS     │
│  App     │    │  User Pool     │    │  Identity Pool   │    │ Services │
└────┬─────┘    └───────┬────────┘    └────────┬─────────┘    └────┬─────┘
     │                  │                      │                   │
     │ 1. Sign in       │                      │                   │
     │  (email+pass)    │                      │                   │
     │─────────────────>│                      │                   │
     │                  │                      │                   │
     │ 2. Tokens        │                      │                   │
     │  (ID, Access,    │                      │                   │
     │   Refresh)       │                      │                   │
     │<─────────────────│                      │                   │
     │                  │                      │                   │
     │ 3. Exchange ID Token for AWS credentials│                   │
     │─────────────────────────────────────────>│                  │
     │                  │                      │                   │
     │ 4. Temporary AWS credentials            │                   │
     │<─────────────────────────────────────────│                  │
     │                  │                      │                   │
     │ 5. Access AWS services with temp credentials               │
     │────────────────────────────────────────────────────────────>│
     │                  │                      │                   │
```

### When to Use This Pattern

- Customer-facing mobile/web apps that need AWS resource access
- Per-user data storage in S3 or DynamoDB
- IoT applications where devices need AWS credentials
- Gaming applications with leaderboards in DynamoDB

---

## Custom Identity Broker Pattern

### When to Use

When your identity store is NOT compatible with SAML 2.0 or OIDC:
- Legacy LDAP without SAML
- Custom authentication systems
- Proprietary identity databases

### Architecture

```
┌──────────┐    ┌───────────────────┐    ┌──────────┐    ┌──────────┐
│  User    │    │  Custom Identity  │    │  AWS STS  │    │  AWS     │
│          │    │  Broker (Lambda/  │    │          │    │  Console │
│          │    │  EC2)             │    │          │    │  or API  │
└────┬─────┘    └────────┬──────────┘    └────┬─────┘    └────┬─────┘
     │                   │                    │               │
     │ 1. Authenticate   │                    │               │
     │  (custom creds)   │                    │               │
     │──────────────────>│                    │               │
     │                   │                    │               │
     │                   │ 2. Validate against│               │
     │                   │    custom identity │               │
     │                   │    store           │               │
     │                   │                    │               │
     │                   │ 3. GetFederationToken              │
     │                   │    OR AssumeRole   │               │
     │                   │───────────────────>│               │
     │                   │                    │               │
     │                   │ 4. Temp credentials│               │
     │                   │<───────────────────│               │
     │                   │                    │               │
     │ 5. Credentials    │                    │               │
     │<──────────────────│                    │               │
     │                   │                    │               │
     │ 6. Access AWS     │                    │               │
     │───────────────────────────────────────────────────────>│
```

### GetFederationToken vs AssumeRole

| Feature | GetFederationToken | AssumeRole |
|---|---|---|
| Called by | IAM user (broker) | IAM user or role |
| Duration | 15 min – 36 hours | 15 min – 12 hours |
| MFA support | No | Yes |
| Session policies | Yes (scoped down) | Yes |
| Use case | Custom broker | Cross-account, federation |

### GetFederationToken Example

```bash
aws sts get-federation-token \
  --name "user123" \
  --policy '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Action":"s3:GetObject","Resource":"arn:aws:s3:::bucket/user123/*"}]}' \
  --duration-seconds 3600
```

---

## Active Directory Federation

### ADFS Federation to AWS

```
Corporate Network:
  │
  ├── Active Directory
  │   └── Users, Groups, Attributes
  │
  └── ADFS (AD Federation Services)
      ├── Authenticates users against AD
      ├── Issues SAML assertions
      ├── Claims rules:
      │   ├── Map AD groups to AWS roles
      │   ├── Map user attributes to session tags
      │   └── Set session duration
      └── Relying Party Trust: AWS (SAML metadata)

AWS:
  ├── IAM SAML Provider (ADFS metadata)
  └── IAM Roles (trust SAML provider)
```

### ADFS Claims Rules Example

```
# Map AD group "AWS-Admins" to AWS IAM role
Rule: "Map Groups to Roles"
  If member of "AWS-Admins"
  Then issue claim:
    Type: https://aws.amazon.com/SAML/Attributes/Role
    Value: arn:aws:iam::111111111111:role/Admin,arn:aws:iam::111111111111:saml-provider/ADFS

# Map AD attribute to session tag
Rule: "Department Tag"
  Issue claim:
    Type: https://aws.amazon.com/SAML/Attributes/PrincipalTag:Department
    Value: [user.department]
```

### Identity Center with Active Directory

```
Option 1: Identity Center + AWS Managed AD
  ├── Users and groups from Managed AD
  ├── Supports all Identity Center features
  └── Managed AD can have trust to on-premises AD

Option 2: Identity Center + AD Connector
  ├── Proxy to on-premises AD
  ├── Users/groups from on-premises AD
  └── Requires reliable network connectivity

Option 3: Identity Center + External IdP (Azure AD/Okta)
  ├── SCIM for user/group provisioning
  ├── SAML 2.0 for authentication
  └── External IdP manages user lifecycle
```

> **Exam Tip**: For enterprise AD integration, IAM Identity Center is preferred over direct SAML/ADFS federation. Identity Center provides centralized multi-account access, SSO portal, and CLI support. Direct SAML federation requires per-account configuration.

---

## Web Identity Federation with STS

### Direct Web Identity Federation (Legacy)

```
Mobile App → Google Sign-In → Google ID Token
  → AssumeRoleWithWebIdentity (Google token + Role ARN)
  → AWS STS → Temporary credentials
```

This direct approach is now considered legacy. AWS recommends using **Cognito Identity Pools** instead, because:
- Cognito handles token validation
- Cognito supports multiple IdPs
- Cognito provides anonymous access
- Cognito simplifies role mapping
- No need to distribute AWS credentials in the app

---

## AssumeRoleWithSAML vs AssumeRoleWithWebIdentity

| Feature | AssumeRoleWithSAML | AssumeRoleWithWebIdentity |
|---|---|---|
| **Protocol** | SAML 2.0 | OIDC / OAuth 2.0 |
| **Use Case** | Enterprise workforce | Mobile/web apps |
| **IdP Examples** | ADFS, Okta, Azure AD | Google, Facebook, Cognito |
| **Token Type** | SAML assertion (XML) | ID Token (JWT) |
| **Principal** | `Federated: saml-provider` | `Federated: oidc-provider` |
| **Max Duration** | 1–12 hours | 1–12 hours |
| **Recommended For** | Console access, API access | App-level AWS access |
| **AWS Alternative** | IAM Identity Center | Cognito Identity Pools |

### When to Use Each

```
Enterprise user needs AWS Console/CLI access:
  → IAM Identity Center (preferred)
  → AssumeRoleWithSAML (if Identity Center not available)

Mobile/web app needs AWS resource access:
  → Cognito Identity Pools (preferred)
  → AssumeRoleWithWebIdentity (direct, not recommended)

Custom identity store (non-SAML, non-OIDC):
  → Custom Identity Broker + GetFederationToken/AssumeRole
```

---

## Cross-Account Access with Federation

### Federation + Cross-Account Role Chaining

```
User authenticates with IdP (SAML/OIDC)
  → Assumes Role-A in Account A (via federation)
    → Assumes Role-B in Account B (via AssumeRole)
      → Accesses resources in Account B

Important: Role chaining = 1 hour max session
```

### Identity Center Multi-Account

```
User logs into Identity Center
  → Selects Account A + PermissionSet-Admin
    → Identity Center creates role in Account A
    → User has Admin access to Account A

User switches to Account B + PermissionSet-ReadOnly
  → Identity Center creates role in Account B
  → User has ReadOnly access to Account B

No role chaining needed!
```

---

## Token Vending Machine Pattern (Legacy)

### What is TVM?

The Token Vending Machine was a legacy pattern for distributing temporary AWS credentials to mobile devices:

```
Mobile App → TVM Server (EC2)
  → TVM authenticates user
  → TVM calls STS (GetFederationToken/AssumeRole)
  → TVM returns temporary credentials to mobile app
  → Mobile app uses credentials to access AWS
```

**This pattern is obsolete.** Use Cognito Identity Pools instead, which provides the same functionality as a managed service.

---

## Attribute-Based Access Control (ABAC)

### ABAC with Federation

ABAC uses attributes (tags) from the identity provider to make authorization decisions dynamically:

```
Identity Provider:
  User: jane@company.com
  Attributes:
    Department: Engineering
    Project: Phoenix
    CostCenter: CC-100

  ↓ (Mapped as session tags)

AWS IAM Policy:
  Allow s3:GetObject
  Resource: arn:aws:s3:::${aws:PrincipalTag/Project}/*
  Condition: s3:ExistingObjectTag/Department = ${aws:PrincipalTag/Department}

Result:
  Jane can access S3 objects in "Phoenix/" prefix
  where object's Department tag matches "Engineering"
```

### Benefits of ABAC

1. **Fewer policies**: One policy for all users (attributes determine access)
2. **Scales automatically**: New projects/teams don't require policy changes
3. **Dynamic**: Access changes when user attributes change in IdP
4. **Audit-friendly**: Tags provide clear access reasoning

---

## Federation Decision Tree for Exam

```
Who needs AWS access?
│
├── Employees (Workforce)?
│   ├── Multiple AWS accounts?
│   │   └── IAM Identity Center ★ (recommended)
│   │
│   ├── Single account, have SAML IdP?
│   │   └── SAML 2.0 Federation (AssumeRoleWithSAML)
│   │
│   ├── Single account, custom identity store?
│   │   └── Custom Identity Broker (GetFederationToken)
│   │
│   └── Using Active Directory?
│       ├── Identity Center + Managed AD (preferred)
│       ├── Identity Center + AD Connector
│       └── ADFS → SAML → IAM (legacy)
│
├── Customers (External users)?
│   ├── Need user registration/sign-in?
│   │   └── Cognito User Pools (authentication)
│   │
│   ├── Need AWS resource access?
│   │   └── Cognito Identity Pools (authorization)
│   │
│   ├── Need both?
│   │   └── Cognito User Pools + Identity Pools
│   │
│   └── Social login (Google, Facebook)?
│       └── Cognito User Pools (federation) + Identity Pools
│
├── Applications/Services?
│   ├── EKS pods?
│   │   └── IRSA (OIDC federation with EKS)
│   │
│   ├── GitHub Actions / CI/CD?
│   │   └── OIDC federation (AssumeRoleWithWebIdentity)
│   │
│   └── Cross-account service?
│       └── AssumeRole (cross-account role)
│
└── IoT Devices?
    └── Cognito Identity Pools (unauthenticated + authenticated)
       OR IoT Core certificate-based auth
```

---

## Exam Scenarios

### Scenario 1: Enterprise SSO

**Question**: A company with 5,000 employees using Microsoft Active Directory needs to provide SSO access to 30 AWS accounts. Employees should see only the accounts and roles assigned to their AD groups.

**Answer**: IAM Identity Center with AWS Managed Microsoft AD (or AD Connector)
- Configure Identity Center to use AD as identity source
- Create permission sets for different roles
- Map AD groups to account assignments
- Users access SSO portal → see assigned accounts → click to assume role

### Scenario 2: Customer-Facing Mobile App

**Question**: A mobile app needs to let users sign up with email, sign in with Google/Facebook, and store photos in S3 with per-user isolation.

**Answer**: Cognito User Pools + Identity Pools
- **User Pool**: Handle registration, social federation, authentication
- **Identity Pool**: Exchange User Pool tokens for AWS credentials
- IAM policy: `s3:PutObject` on `arn:aws:s3:::photos/${cognito-identity.amazonaws.com:sub}/*`

### Scenario 3: Third-Party Vendor Access

**Question**: A consulting firm needs temporary read-only access to specific S3 buckets in your production account.

**Answer**: Cross-account IAM role with External ID
- Create IAM role in your account
- Trust policy: Allow vendor's account with External ID condition
- Permission policy: ReadOnly access to specific S3 buckets
- External ID prevents confused deputy

### Scenario 4: Legacy Identity System

**Question**: A company has a custom LDAP directory (not SAML-capable) and needs to provide AWS console access to employees.

**Answer**: Custom Identity Broker
- Build a broker application (Lambda/EC2)
- Broker authenticates against LDAP
- Broker calls `GetFederationToken` or `AssumeRole`
- Broker generates console sign-in URL with temporary credentials
- Returns URL to user for console access

### Scenario 5: EKS Pod-Level Access

**Question**: Different pods in an EKS cluster need different AWS permissions (one needs DynamoDB, another needs S3).

**Answer**: IRSA (IAM Roles for Service Accounts)
- Create OIDC provider for EKS cluster
- Create IAM roles with OIDC trust policy for specific service accounts
- Annotate Kubernetes service accounts with IAM role ARNs
- Pods receive credentials for their specific role

### Scenario 6: CI/CD from GitHub

**Question**: GitHub Actions needs to deploy to AWS without storing long-lived credentials.

**Answer**: OIDC federation with GitHub
- Create IAM OIDC provider for `token.actions.githubusercontent.com`
- Create IAM role trusting the GitHub OIDC provider
- Condition: restrict to specific repository/branch
- GitHub Actions workflow uses `aws-actions/configure-aws-credentials` with OIDC

---

## Exam Tips Summary

### Critical Facts

1. **Identity Center is the recommended approach** for workforce multi-account access
2. **Cognito User Pools = authentication** (who are you?)
3. **Cognito Identity Pools = authorization** (AWS credentials)
4. **SAML 2.0 = enterprise workforce** federation
5. **OIDC = application-level** federation (mobile/web/EKS)
6. **External ID = confused deputy prevention** for third-party access
7. **Role chaining max duration = 1 hour** (regardless of role settings)
8. **GetFederationToken = custom identity broker** pattern
9. **AssumeRoleWithSAML = SAML** federation
10. **AssumeRoleWithWebIdentity = OIDC** federation (prefer Cognito)
11. **Identity Center permission sets** define permissions; **account assignments** define scope
12. **ABAC** uses session tags from IdP attributes for dynamic authorization

### Common Exam Traps

| Trap | Correct Answer |
|---|---|
| Create IAM users for each employee | Use federation (Identity Center or SAML) |
| Use AssumeRoleWithWebIdentity directly | Prefer Cognito Identity Pools |
| User Pools provide AWS credentials | User Pools authenticate; Identity Pools authorize |
| SAML for mobile apps | SAML is for enterprise workforce; use Cognito for mobile |
| Identity Center works without Organizations | Identity Center requires Organizations |
| Custom broker for SAML-capable IdP | Use SAML federation or Identity Center |
| Long-lived credentials for CI/CD | Use OIDC federation |
| Token Vending Machine for mobile | Legacy pattern; use Cognito Identity Pools |

---

## Advanced Federation Patterns

### Identity Center Delegated Administration

```
Management Account:
  └── Delegates Identity Center administration to:
      └── Shared Services Account (Delegated Admin)
          ├── Manages users and groups
          ├── Manages permission sets
          ├── Manages account assignments
          └── Manages identity source configuration
```

Delegation allows removing day-to-day identity management from the management account.

### Identity Center External Identity Provider Integration

**SCIM Provisioning**:
```
External IdP (Okta/Azure AD)
  │
  ├── SCIM Endpoint → Identity Center
  │   ├── Automatic user provisioning
  │   ├── Automatic group sync
  │   ├── Attribute mapping
  │   └── Deprovisioning on IdP removal
  │
  └── SAML Authentication → Identity Center
      ├── SSO authentication flow
      ├── MFA handled by external IdP
      └── Session management by IdP
```

**Why SCIM + SAML Together?**
- SCIM handles **provisioning** (creating/updating/deleting users and groups in Identity Center)
- SAML handles **authentication** (verifying user identity at login)
- Both are needed for complete integration with an external IdP

### Cognito Advanced Patterns

**Cognito with ALB Integration**:
```
User → ALB (HTTPS listener)
  │
  ├── ALB Authentication Action:
  │   ├── Type: Cognito User Pool
  │   ├── User Pool ID: us-east-1_abc123
  │   ├── App Client ID: abc123def456
  │   ├── Session Timeout: 3600
  │   └── On Unauthenticated: Authenticate
  │
  ├── User redirected to Cognito Hosted UI
  │   └── Authenticates (username/password or social)
  │
  ├── Cognito returns tokens to ALB
  │
  └── ALB forwards request to backend with:
      ├── x-amzn-oidc-identity (user sub)
      ├── x-amzn-oidc-data (JWT payload)
      └── x-amzn-oidc-accesstoken (access token)
```

**Cognito Custom Domain**:
```
auth.myapp.com → Cognito Hosted UI (custom domain)
  ├── Requires ACM certificate in us-east-1
  ├── Route 53 alias record to Cognito CloudFront distribution
  └── Branded login experience
```

**Cognito User Pool Triggers — Advanced Use Cases**:

| Trigger | Use Case | Example |
|---|---|---|
| Pre Sign-up | Block specific email domains | Only allow @company.com |
| Post Confirmation | Create user profile in DynamoDB | Initialize user data |
| Pre Authentication | Check IP allowlist | Block suspicious IPs |
| Post Authentication | Log authentication event | Send to analytics |
| Pre Token Generation | Add custom claims | Add role, permissions |
| User Migration | Migrate from legacy system | Validate against old DB |
| Custom Message | Branded email templates | Company-styled verification |
| Define/Create/Verify Auth | Passwordless login | OTP via email/SMS |

**Pre Token Generation Lambda Example**:
```python
def lambda_handler(event, context):
    event['response']['claimsOverrideDetails'] = {
        'claimsToAddOrOverride': {
            'custom:role': 'premium',
            'custom:tier': 'gold',
            'custom:org_id': 'org-123'
        },
        'claimsToSuppress': ['email_verified'],
        'groupOverrideDetails': {
            'groupsToOverride': ['Premium-Users', 'Gold-Tier']
        }
    }
    return event
```

### Multi-Tenant Federation Architecture

```
SaaS Application:
  │
  ├── Tenant A (Enterprise → SAML):
  │   └── Cognito User Pool:
  │       └── IdP: Tenant-A-ADFS (SAML)
  │
  ├── Tenant B (Enterprise → OIDC):
  │   └── Cognito User Pool:
  │       └── IdP: Tenant-B-AzureAD (OIDC)
  │
  ├── Tenant C (Small business → Email/Password):
  │   └── Cognito User Pool:
  │       └── Native Cognito users
  │
  └── Shared Cognito Identity Pool:
      ├── Maps all user pool tokens to IAM roles
      ├── Tenant isolation via:
      │   ├── IAM policy: s3://data/${custom:tenantId}/*
      │   └── DynamoDB: partition key = tenantId
      └── Fine-grained access control per tenant
```

### Zero Trust Architecture with AWS

```
Remote User:
  │
  ├── Authentication:
  │   ├── IAM Identity Center (workforce)
  │   └── Cognito (customers)
  │
  ├── Device Posture:
  │   └── AWS Verified Access (trust provider)
  │
  ├── Network:
  │   ├── No VPN (zero trust = no perimeter)
  │   ├── PrivateLink for service access
  │   └── VPC Lattice for service mesh
  │
  ├── Authorization:
  │   ├── ABAC (attribute-based)
  │   ├── Per-request evaluation
  │   └── Continuous authorization
  │
  └── Monitoring:
      ├── CloudTrail (API logging)
      ├── GuardDuty (anomaly detection)
      └── Security Hub (posture management)
```

### Temporary Elevated Access (Break-Glass)

```
Normal Operations:
  Developer → Identity Center → ReadOnly Permission Set → Prod Account

Emergency (Break-Glass):
  Developer → Requests elevated access (ServiceNow/Slack)
    → Approval workflow (manager + security)
      → Lambda creates temporary permission set assignment
        → Developer → Identity Center → Admin Permission Set → Prod Account
          → Time-limited (1-4 hours)
            → Auto-revoked by Lambda after TTL
              → CloudTrail + SNS for audit trail
```

### Token Refresh and Session Management

```
Cognito Token Lifecycle:
  │
  ├── ID Token: 5 min → 1 day (configurable)
  │   └── Contains: user attributes, claims
  │
  ├── Access Token: 5 min → 1 day (configurable)
  │   └── Contains: scopes, groups, authorization
  │
  └── Refresh Token: 60 min → 10 years (configurable)
      └── Used to obtain new ID and Access tokens
          └── Revokable via RevokeToken API

Session Management:
  ├── Token revocation:
  │   └── Cognito RevokeToken API → invalidates refresh token
  │
  ├── Global sign-out:
  │   └── Cognito GlobalSignOut → invalidates ALL tokens for user
  │
  └── Admin sign-out:
      └── AdminUserGlobalSignOut → force sign-out by admin
```

### Federation Monitoring and Auditing

```
CloudTrail Events for Federation:
  ├── AssumeRoleWithSAML
  │   └── Records: SAML provider, role, session name, source IP
  │
  ├── AssumeRoleWithWebIdentity
  │   └── Records: OIDC provider, role, subject
  │
  ├── GetFederationToken
  │   └── Records: IAM user (broker), federated user name
  │
  └── Identity Center events:
      ├── CreateAccountAssignment
      ├── CreatePermissionSet
      ├── Authenticate (via CloudTrail)
      └── FederateToConsole

CloudWatch Metrics:
  ├── Cognito:
  │   ├── SignIn attempts (success/failure)
  │   ├── Token refresh count
  │   └── Federation events by IdP
  │
  └── STS:
      ├── AssumeRole call count
      ├── Session duration distribution
      └── Error rates
```

### IAM Roles Anywhere (Certificate-Based Federation)

For on-premises workloads needing AWS credentials without long-lived keys:

```
On-Premises Server
  │
  ├── Has X.509 certificate from PKI/CA
  │
  ├── Calls IAM Roles Anywhere:
  │   ├── Trust Anchor: Your CA certificate
  │   ├── Profile: Maps to IAM role
  │   └── Session: Returns temporary credentials
  │
  └── Uses temporary credentials for AWS API calls

Setup:
  1. Create Trust Anchor (upload CA certificate)
  2. Create IAM Role (trust policy: rolesanywhere.amazonaws.com)
  3. Create Profile (maps role + session policies)
  4. Configure on-premises: credential_process in AWS config
```

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "rolesanywhere.amazonaws.com"
      },
      "Action": [
        "sts:AssumeRole",
        "sts:TagSession",
        "sts:SetSourceIdentity"
      ],
      "Condition": {
        "StringEquals": {
          "aws:PrincipalTag/x509Subject/CN": "server.corp.example.com"
        }
      }
    }
  ]
}
```

> **Exam Tip**: IAM Roles Anywhere eliminates long-lived credentials for on-premises/hybrid workloads. It uses X.509 certificates (PKI) to obtain temporary AWS credentials. Know this as the answer when on-premises servers need AWS access without static access keys.

### Federation Security Best Practices

1. **Never distribute long-lived credentials**: Always use federation for temporary credentials
2. **Use MFA for privileged access**: Require MFA via SAML or Identity Center for admin roles
3. **Minimize session duration**: Use shortest practical session (1 hour for sensitive operations)
4. **Use conditions in trust policies**: Restrict by source IP, time, MFA, organization ID
5. **Monitor federation events**: CloudTrail tracks all AssumeRole* calls
6. **Rotate External IDs**: Change External IDs periodically for third-party access
7. **Use ABAC over RBAC where possible**: Fewer policies, more dynamic access
8. **Implement least privilege**: Start with minimal permissions, expand based on need
9. **Separate workforce from customer identity**: Identity Center for employees, Cognito for customers
10. **Regular access reviews**: Audit permission sets, role assignments, and Cognito configurations

## Summary

Identity federation is foundational to secure AWS access at scale. For the SAP-C02 exam:

1. **IAM Identity Center** is the recommended solution for workforce multi-account access
2. **Cognito User Pools** handle customer authentication with social and enterprise federation
3. **Cognito Identity Pools** exchange IdP tokens for temporary AWS credentials
4. **SAML 2.0** federation is for enterprise workforce (ADFS, Okta, Azure AD)
5. **OIDC** federation is for applications (EKS IRSA, GitHub Actions, mobile apps)
6. **Custom Identity Broker** is for non-standard identity stores
7. **IAM Roles Anywhere** replaces long-lived keys for on-premises workloads
8. **ABAC** uses IdP attributes as session tags for dynamic authorization
9. **External ID** prevents the confused deputy problem with third parties
10. **Role chaining** has a 1-hour maximum session regardless of role configuration

Master the federation decision tree and you will confidently answer any identity question on the exam.

---

*Previous Article: [← Hybrid DNS & Directory](./05-hybrid-dns-and-directory.md)*
*Next Article: [Governance & Compliance →](./07-governance-and-compliance.md)*
