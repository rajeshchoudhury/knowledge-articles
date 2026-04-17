# WAF, Shield & Security Services

## Table of Contents

1. [AWS WAF (Web Application Firewall)](#aws-waf-web-application-firewall)
2. [AWS Shield](#aws-shield)
3. [AWS Firewall Manager](#aws-firewall-manager)
4. [Amazon GuardDuty](#amazon-guardduty)
5. [Amazon Inspector](#amazon-inspector)
6. [Amazon Macie](#amazon-macie)
7. [AWS Security Hub](#aws-security-hub)
8. [Amazon Detective](#amazon-detective)
9. [AWS Audit Manager](#aws-audit-manager)
10. [Amazon Cognito](#amazon-cognito)
11. [AWS IAM Identity Center (SSO)](#aws-iam-identity-center-sso)
12. [AWS Directory Service](#aws-directory-service)
13. [Common Exam Scenarios](#common-exam-scenarios)

---

## AWS WAF (Web Application Firewall)

### Overview

AWS WAF is a web application firewall that helps protect web applications and APIs from common web exploits and bots that may affect availability, compromise security, or consume excessive resources. WAF operates at **Layer 7 (HTTP/HTTPS)** and gives you control over which traffic reaches your applications.

### Core Components

#### Web ACLs (Access Control Lists)

A Web ACL is the top-level resource in AWS WAF. It contains rules that define the inspection criteria and the action to take on web requests that match those criteria.

- **Default Action**: Every Web ACL has a default action (ALLOW or BLOCK) that applies to requests that don't match any rules
- **Capacity Units (WCUs)**: Each Web ACL has a maximum capacity of **1,500 WCUs** (can be increased by contacting AWS). Each rule consumes a certain number of WCUs depending on its complexity
- **Scope**: Web ACLs are **regional** (for ALB, API Gateway, AppSync, Cognito) or **global** (for CloudFront — must be created in us-east-1)
- **Rule Priority**: Rules are evaluated in order of priority (lowest number first). Once a request matches a rule, the action is taken and no further rules are evaluated (unless the action is COUNT)

#### Rules

Rules define the inspection criteria and the action to take:

| Action | Description |
|--------|-------------|
| **ALLOW** | Permits the request to reach the protected resource |
| **BLOCK** | Blocks the request and returns a 403 Forbidden by default (customizable) |
| **COUNT** | Counts the request but doesn't affect whether it's allowed or blocked; useful for testing rules |
| **CAPTCHA** | Presents a CAPTCHA challenge to the client |
| **Challenge** | Presents a silent challenge (JavaScript challenge) |

#### Rule Groups

Rule groups are reusable collections of rules that you can add to a Web ACL:

**AWS Managed Rule Groups (free):**
- `AWSManagedRulesCommonRuleSet` — core rule set, protects against OWASP Top 10
- `AWSManagedRulesAdminProtectionRuleSet` — blocks external access to admin pages
- `AWSManagedRulesKnownBadInputsRuleSet` — blocks known bad input patterns (e.g., Log4j)
- `AWSManagedRulesSQLiRuleSet` — blocks SQL injection
- `AWSManagedRulesLinuxRuleSet` — blocks Linux-specific exploits
- `AWSManagedRulesUnixRuleSet` — blocks POSIX-specific exploits
- `AWSManagedRulesWindowsRuleSet` — blocks Windows/PowerShell exploits
- `AWSManagedRulesPHPRuleSet` — blocks PHP-specific exploits
- `AWSManagedRulesWordPressRuleSet` — blocks WordPress-specific exploits
- `AWSManagedRulesAmazonIpReputationList` — blocks IPs from Amazon threat intelligence
- `AWSManagedRulesAnonymousIpList` — blocks VPN, proxy, Tor exit nodes
- `AWSManagedRulesBotControlRuleSet` — bot management (targeted or common)
- `AWSManagedRulesATPRuleSet` — Account Takeover Prevention
- `AWSManagedRulesACFPRuleSet` — Account Creation Fraud Prevention

**AWS Marketplace Rule Groups:**
- Third-party managed rule groups available from security vendors (F5, Fortinet, Imperva, etc.)
- Purchased through AWS Marketplace and added to Web ACLs
- Additional subscription costs apply

**Custom Rule Groups:**
- User-defined rule groups with custom logic
- Shareable across multiple Web ACLs
- Have their own WCU capacity

#### Rate-Based Rules

Rate-based rules track the rate of requests from individual IP addresses and trigger an action when the rate exceeds a specified threshold:

- **Threshold**: Minimum of **100 requests** per 5-minute evaluation period
- **Action**: Typically BLOCK — automatically blocks IPs exceeding the threshold
- **Scope Down Statement**: Optional — narrow which requests count toward the rate (e.g., only count requests to `/login`)
- **Aggregation Keys**: By IP address, forwarded IP (X-Forwarded-For header), or custom keys
- **Use Cases**: Brute force login prevention, DDoS mitigation, API rate limiting

### WAF Match Conditions

WAF inspects requests based on various conditions:

#### IP Set Match
- Match requests from specific IP addresses or CIDR ranges
- Supports IPv4 and IPv6
- Maximum of **10,000 IP addresses/CIDR ranges** per IP set
- Use case: Allow/block specific IP ranges, geo-restriction enhancement

#### String Match
- Inspect request components for specific strings
- **Comparison operators**: Exactly matches, Starts with, Ends with, Contains, Contains word
- **Text transformations**: Lowercase, HTML entity decode, URL decode, Compress whitespace, CMD line, Base64 decode, Hex decode, etc.
- Can inspect: URI, Query string, Body, Single header, All headers, Cookies, JSON body

#### Regex Match
- Use regular expressions to match patterns in request components
- **Regex pattern set**: Up to 10 regex patterns per set, each up to 200 characters
- Consumes more WCUs than string match conditions

#### Size Constraint
- Match requests based on the size (in bytes) of specific request components
- **Comparison operators**: EQ, NE, LE, LT, GE, GT
- Can check: URI, Query string, Body, Single header, All headers, Cookies

#### Geo Match
- Match requests based on the country of origin
- Uses the source IP or forwarded IP (X-Forwarded-For)
- ISO 3166 country codes
- Use case: Block traffic from specific countries, compliance requirements

#### SQL Injection (SQLi)
- Detects potential SQL injection attacks in request components
- AWS uses internal machine learning models and pattern matching
- Apply text transformations before inspection
- Can inspect all standard request components

#### Cross-Site Scripting (XSS)
- Detects potential XSS attacks in request components
- Inspects for common XSS patterns and payloads
- Apply text transformations before inspection

### WAF Integration Points

| Service | Scope | Notes |
|---------|-------|-------|
| **Amazon CloudFront** | Global (us-east-1) | Most common integration; inspects before edge caching |
| **Application Load Balancer (ALB)** | Regional | Protects web apps behind ALB |
| **Amazon API Gateway** | Regional | REST API stage level protection |
| **AWS AppSync** | Regional | GraphQL API protection |
| **Amazon Cognito User Pools** | Regional | Protects hosted UI and API operations |
| **AWS App Runner** | Regional | Protects App Runner services |
| **AWS Verified Access** | Regional | Additional layer on Verified Access instances |

**Key Integration Notes:**
- One Web ACL can be associated with multiple resources of the same type
- One resource can have only **one Web ACL** associated
- CloudFront distributions require **global** (us-east-1) Web ACLs
- All other services use **regional** Web ACLs

### WAF Logging

WAF provides comprehensive logging of all evaluated requests:

**Logging Destinations:**

| Destination | Details |
|-------------|---------|
| **Amazon Kinesis Data Firehose** | Stream name must start with `aws-waf-logs-`. Near real-time delivery to S3, Redshift, OpenSearch, Splunk |
| **Amazon S3** | Bucket name must start with `aws-waf-logs-`. Logs delivered every 5 minutes |
| **Amazon CloudWatch Logs** | Log group name must start with `aws-waf-logs-`. Real-time monitoring and alerting |

**Logged Information:**
- Timestamp, source IP, action taken (ALLOW/BLOCK/COUNT)
- Rule matched, country, URI, query string, headers
- Request body (if configured)
- Labels applied by rules

**Log Filtering:**
- Redacted fields: Mask specific fields in logs (e.g., sensitive headers)
- Filtering conditions: Log only specific request types (blocked only, specific rules, etc.)

---

## AWS Shield

### AWS Shield Standard

AWS Shield Standard is a **free**, automatic DDoS protection service that is enabled for **all AWS customers** by default. No configuration required.

**Protection:**
- Layer 3 (Network) and Layer 4 (Transport) protection
- Protects against SYN/UDP floods, reflection attacks, and other common infrastructure-level attacks
- Always-on detection and automatic inline mitigations
- Integrated with CloudFront and Route 53 edge locations

**Limitations:**
- No DDoS Response Team access
- No DDoS cost protection
- No advanced metrics or reporting
- No application layer (L7) protection
- No proactive engagement

### AWS Shield Advanced

AWS Shield Advanced provides enhanced DDoS protection with additional features, detection, and mitigation capabilities.

**Pricing:**
- **$3,000 per month** per organization (not per account)
- **1-year subscription** commitment
- Data transfer out (DTO) usage fees for protected resources may apply
- DDoS cost protection provides credits for scaling charges during attacks

**Protection Layers:**
- **Layer 3/4**: Enhanced detection and mitigation beyond Shield Standard
- **Layer 7**: Application layer DDoS protection (requires WAF integration)
- **Near real-time visibility** into DDoS events
- **Automatic application layer mitigation** — can automatically create, evaluate, and deploy WAF rules

**Key Features:**

| Feature | Description |
|---------|-------------|
| **DDoS Response Team (DRT)** | 24/7 access to AWS DDoS experts who can help during attacks. Can create WAF rules on your behalf |
| **Cost Protection** | Credits for EC2, ELB, CloudFront, Global Accelerator, Route 53 scaling charges during DDoS attacks |
| **Advanced Metrics** | Near real-time metrics and detailed attack diagnostics in CloudWatch |
| **Health-Based Detection** | Uses Route 53 health checks to improve detection accuracy and response time |
| **Proactive Engagement** | DRT proactively contacts you when health checks are unhealthy during detected events |
| **WAF Integration** | AWS WAF is included at no additional cost for resources protected by Shield Advanced |
| **SRT Support** | Shield Response Team creates custom mitigations |
| **Global Threat Dashboard** | View DDoS attack trends across the internet |

**Protected Resources:**
- Amazon EC2 instances (via Elastic IP)
- Elastic Load Balancers (ALB, NLB, CLB)
- Amazon CloudFront distributions
- AWS Global Accelerator accelerators
- Amazon Route 53 hosted zones

**Important Notes for Exam:**
- Shield Advanced protects EC2 only through **Elastic IP** association
- For L7 protection, WAF must be configured on the protected resource
- Shield Advanced is an **organization-level** subscription — all accounts benefit
- Route 53 health checks enhance detection accuracy when combined with Shield Advanced

---

## AWS Firewall Manager

### Overview

AWS Firewall Manager is a security management service that allows you to centrally configure and manage firewall rules across your accounts and applications in **AWS Organizations**.

### Key Concepts

**Security Policies:**
Firewall Manager creates security policies that define the firewall rules and can be automatically applied to new resources as they're created.

**Supported Policy Types:**

| Policy Type | Description |
|-------------|-------------|
| **AWS WAF** | Manage WAF rules across accounts and resources |
| **AWS Shield Advanced** | Apply Shield Advanced protection across accounts |
| **VPC Security Groups** | Audit and manage security group rules across VPCs |
| **AWS Network Firewall** | Deploy and manage Network Firewall across VPCs |
| **Route 53 Resolver DNS Firewall** | Manage DNS Firewall rules across VPCs |
| **Third-party Firewalls** | Palo Alto, Fortigate via Firewall Manager |

**Prerequisites:**
1. AWS Organizations with **all features** enabled
2. Designate a **Firewall Manager administrator account** (can be different from management account)
3. Enable **AWS Config** in all accounts where policies will be applied

**Key Features:**
- **Auto-remediation**: Automatically apply rules to non-compliant resources
- **Policy scope**: Apply to all accounts, specific OUs, or tagged resources
- **Compliance monitoring**: Dashboard showing compliance status across accounts
- **Automatic protection**: New resources in scope automatically get protected
- **Cross-account management**: Single pane of glass for security rules

**Use Case Example:**
- Ensure all ALBs across 50 accounts have the same WAF rules
- Automatically apply Shield Advanced to all new CloudFront distributions
- Audit and enforce security group rules across all VPCs in the organization

---

## Amazon GuardDuty

### Overview

Amazon GuardDuty is an intelligent **threat detection** service that continuously monitors for malicious activity and unauthorized behavior across your AWS accounts, workloads, and data.

GuardDuty uses **machine learning**, **anomaly detection**, and integrated **threat intelligence** feeds to identify unexpected and potentially unauthorized activity.

### Data Sources

GuardDuty analyzes multiple data sources (you don't need to enable these separately — GuardDuty accesses them independently):

| Data Source | What It Detects |
|-------------|-----------------|
| **AWS CloudTrail Management Events** | Unusual API calls, unauthorized deployments, suspicious IAM activity |
| **AWS CloudTrail S3 Data Events** | Suspicious S3 object-level operations (GetObject, PutObject, DeleteObject) |
| **VPC Flow Logs** | Unusual network traffic patterns, communication with known bad IPs, port scanning |
| **DNS Logs** | DNS queries to known malicious domains, DNS exfiltration, crypto-mining domains |
| **EKS Audit Logs** | Suspicious Kubernetes API activity, privileged containers, anonymous access |
| **RDS Login Activity** | Anomalous login attempts to RDS databases, brute force attacks |
| **Lambda Network Activity** | Suspicious network connections from Lambda functions, communication with crypto-mining pools |
| **S3 Logs** | Suspicious access patterns to S3 data |
| **EBS Malware Protection** | Scans EBS volumes for malware when suspicious activity is detected |
| **Runtime Monitoring** | OS-level visibility into container and EC2 workloads |

### Finding Types

GuardDuty generates findings categorized by the affected resource:

**EC2 Finding Types:**
- `Backdoor:EC2/DenialOfService` — EC2 instance participating in DDoS
- `CryptoCurrency:EC2/BitcoinTool` — EC2 mining cryptocurrency
- `Trojan:EC2/BlackholeTraffic` — Traffic to known black hole IP
- `UnauthorizedAccess:EC2/SSHBruteForce` — SSH brute force detected
- `Recon:EC2/PortProbeUnprotectedPort` — Port probe on unprotected port

**IAM Finding Types:**
- `UnauthorizedAccess:IAMUser/ConsoleLoginSuccess.B` — Successful console login from unusual location
- `CredentialAccess:IAMUser/AnomalousBehavior` — Anomalous API calls with IAM credentials
- `Persistence:IAMUser/UserPermissions` — User modifying permissions to maintain access

**S3 Finding Types:**
- `Exfiltration:S3/MaliciousIPCaller` — S3 API called from known malicious IP
- `Policy:S3/BucketBlockPublicAccessDisabled` — Block public access disabled on bucket
- `UnauthorizedAccess:S3/TorIPCaller` — S3 API called from Tor exit node

### Key Features

**Severity Levels:** Low (0.1–3.9), Medium (4.0–6.9), High (7.0–8.9)

**Suppression Rules:**
- Automatically archive findings matching specified criteria
- Filter out known false positives (e.g., expected vulnerability scanners)
- Findings still generated but automatically archived

**Trusted and Threat IP Lists:**
- **Trusted IP List**: IPs that should NOT generate findings (one list per account per region)
- **Threat IP List**: Known malicious IPs to enhance detection (up to 6 lists)

**Multi-Account Management:**
- Designate a **delegated administrator** in AWS Organizations
- Administrator account can view and manage findings across all member accounts
- Automatic enrollment of new organization accounts

**Integration:**
- EventBridge: Route findings to Lambda, SNS, SQS for automated remediation
- Security Hub: Aggregated view of findings
- Detective: Investigate findings further

**Pricing:** Based on volume of data analyzed (CloudTrail events, VPC Flow Logs, DNS queries). 30-day free trial available.

---

## Amazon Inspector

### Overview

Amazon Inspector is an automated **vulnerability management** service that continuously scans AWS workloads for software vulnerabilities and unintended network exposure.

### Supported Targets

| Target | Requirement | What's Scanned |
|--------|-------------|-----------------|
| **EC2 Instances** | SSM Agent must be installed and running | OS packages, software vulnerabilities (CVEs), network reachability |
| **ECR Container Images** | Automatic on push | Container image vulnerabilities in OS packages and programming language packages |
| **Lambda Functions** | Automatic | Code vulnerabilities, dependency vulnerabilities in deployment packages and layers |

### How It Works

1. **Automatic Discovery**: Inspector automatically discovers eligible resources (EC2 with SSM agent, ECR repos, Lambda functions)
2. **Continuous Scanning**: Rescans when new CVEs are published, packages are updated, or new resources are deployed
3. **Risk Scoring**: Each finding gets an **Inspector risk score** (0–100) that factors in CVSS score, exploit availability, network reachability, and more
4. **Findings**: Results include vulnerability details, affected resources, remediation guidance, and CVSS scores

### Finding Types

- **Package Vulnerability**: CVE found in installed software packages
- **Network Reachability**: Network configuration allows access to a port from the internet or another VPC (EC2 only)
- **Code Vulnerability**: Security issue found in Lambda function code

### Key Features

- **Delegated Administrator**: Centrally manage Inspector across AWS Organizations
- **Software Bill of Materials (SBOM)**: Export SBOM for scanned resources in CycloneDX or SPDX format
- **Integration with Security Hub**: Findings automatically sent to Security Hub
- **Integration with EventBridge**: Automate remediation workflows
- **Suppression Rules**: Suppress findings based on criteria
- **CIS Benchmarks**: Assess EC2 instances against CIS hardening benchmarks

### Key Exam Points

- Inspector v2 is the current version — **agentless** discovery (but SSM agent needed for deep EC2 scanning)
- **Continuous scanning** is the default (not one-time assessments like Inspector Classic)
- Network reachability findings do NOT require SSM agent
- Inspector only scans for **known CVEs** — it does not perform penetration testing

---

## Amazon Macie

### Overview

Amazon Macie is a fully managed data security and data privacy service that uses **machine learning** and **pattern matching** to discover and protect sensitive data stored in **Amazon S3**.

### What Macie Discovers

**Personally Identifiable Information (PII):**
- Names, addresses, phone numbers, email addresses
- Social Security numbers, passport numbers, driver's license numbers
- Date of birth, national identification numbers

**Financial Data:**
- Credit card numbers (PCI compliance)
- Bank account numbers
- Financial statements and records

**Technical Data:**
- AWS secret keys, API keys
- Private keys, certificates
- Database connection strings, passwords in files

**Healthcare Data:**
- Health Insurance Claim Numbers
- Medical Record Numbers
- HIPAA-related identifiers

### How It Works

1. **S3 Bucket Inventory**: Macie creates and maintains an inventory of all S3 buckets in the account
2. **Bucket-Level Analysis**: Evaluates bucket security (encryption, public access, shared access)
3. **Sensitive Data Discovery Jobs**: Scheduled or one-time jobs that analyze S3 objects for sensitive data
4. **Automated Sensitive Data Discovery**: Uses sampling to continuously discover sensitive data across all buckets
5. **Findings**: Generates findings for sensitive data and policy violations

### Finding Types

**Sensitive Data Findings:**
- `SensitiveData:S3Object/Personal` — PII detected
- `SensitiveData:S3Object/Financial` — Financial data detected
- `SensitiveData:S3Object/Credentials` — Credentials detected
- `SensitiveData:S3Object/CustomIdentifier` — Custom identifier detected
- `SensitiveData:S3Object/Multiple` — Multiple types of sensitive data

**Policy Findings:**
- `Policy:IAMUser/S3BucketPublic` — Bucket is public
- `Policy:IAMUser/S3BucketReplicatedExternally` — Bucket replication to external account
- `Policy:IAMUser/S3BucketEncryptionDisabled` — Server-side encryption not enabled
- `Policy:IAMUser/S3BucketSharedExternally` — Bucket policy allows external access
- `Policy:IAMUser/S3BlockPublicAccessDisabled` — Block public access settings disabled

### Key Features

- **Custom Data Identifiers**: Regex-based patterns + keywords for domain-specific sensitive data
- **Allow Lists**: Exclude specific text patterns from findings (e.g., test credit card numbers)
- **Multi-Account**: Delegated administrator in AWS Organizations
- **Integration**: EventBridge, Security Hub, Step Functions for automated remediation
- **Reveal Samples**: View up to 10 samples of detected sensitive data (requires KMS key)

### Key Exam Points

- Macie is **S3 only** — does not scan EBS, EFS, DynamoDB, or RDS
- Can be used for **PCI DSS compliance** by finding credit card data in S3
- Useful for **GDPR compliance** by discovering PII
- Findings are sent to EventBridge for automated remediation (e.g., auto-encrypt bucket, remove public access)

---

## AWS Security Hub

### Overview

AWS Security Hub provides a **comprehensive view** of your security state within AWS. It aggregates, organizes, and prioritizes security findings from multiple AWS services and third-party products.

### Data Sources

Security Hub collects findings from:
- Amazon GuardDuty
- Amazon Inspector
- Amazon Macie
- AWS Firewall Manager
- AWS IAM Access Analyzer
- AWS Systems Manager Patch Manager
- Third-party products (CrowdStrike, Palo Alto, Splunk, etc.)

### Security Standards

Security Hub evaluates your environment against industry standards and best practices:

| Standard | Description |
|----------|-------------|
| **AWS Foundational Security Best Practices (FSBP)** | AWS-defined security controls across services |
| **CIS AWS Foundations Benchmark** | Center for Internet Security benchmark (Level 1 & 2) |
| **PCI DSS v3.2.1** | Payment Card Industry Data Security Standard |
| **NIST SP 800-53 Rev. 5** | National Institute of Standards and Technology framework |
| **AWS Resource Tagging Standard** | Checks for proper resource tagging |

### AWS Security Finding Format (ASFF)

All findings in Security Hub use a standardized JSON format (ASFF) that includes:
- Severity (INFORMATIONAL, LOW, MEDIUM, HIGH, CRITICAL)
- Resource details, finding type, remediation information
- Compliance status, workflow status
- Product-specific fields

### Key Features

**Findings Aggregation:**
- Cross-region aggregation: Designate an **aggregation region** to view findings from all regions
- Cross-account: Delegated administrator views findings from all organization accounts
- Automatic import from integrated services

**Automated Remediation:**
- EventBridge integration for automated response
- Custom actions: Define actions that send specific findings to EventBridge
- Security Hub + EventBridge + Lambda/SSM Automation for auto-fix

**Example Auto-Remediation Workflow:**
```
Security Hub Finding → EventBridge Rule → Lambda Function → Fix Resource
```
- Finding: S3 bucket has public access → Lambda disables public access
- Finding: Security group has 0.0.0.0/0 on port 22 → Lambda removes the rule
- Finding: CloudTrail not enabled → SSM Automation enables CloudTrail

**Insights:**
- Built-in managed insights (e.g., "EC2 instances with public IP addresses")
- Custom insights: Create custom groupings and filters for findings
- Visual dashboards for security posture

### Prerequisites

- **AWS Config** must be enabled in all regions where Security Hub is used (required for security standard checks)
- Enable each security standard individually
- Enable each product integration individually

### Key Exam Points

- Security Hub is a **central dashboard** — it doesn't detect threats itself, it aggregates findings
- Requires **AWS Config** to evaluate compliance
- Use **EventBridge** for automated remediation
- **Cross-region aggregation** requires designating an aggregation region
- Supports both AWS Organizations (delegated administrator) and manual account invitations

---

## Amazon Detective

### Overview

Amazon Detective makes it easy to **investigate**, **analyze**, and quickly identify the **root cause** of potential security issues or suspicious activities. It automatically collects log data from your AWS resources and uses machine learning, statistical analysis, and graph theory to build interactive visualizations.

### Data Sources

Detective automatically ingests and analyzes:
- AWS CloudTrail logs (management events)
- Amazon VPC Flow Logs
- Amazon GuardDuty findings
- Amazon EKS audit logs
- AWS Security Lake (optional)

### How It Works

1. **Graph Model**: Detective builds a **behavior graph** that links security data across your AWS accounts
2. **Entity Profiles**: Creates detailed profiles for entities (IP addresses, AWS accounts, IAM users/roles, EC2 instances)
3. **Interactive Visualizations**: Provides time-based visualizations showing activity patterns
4. **Investigation**: Start investigations from GuardDuty findings, Security Hub findings, or Detective directly

### Key Features

- **Automatic Data Collection**: No agents, no additional data sources to enable (uses existing CloudTrail and VPC Flow Logs)
- **Up to 12 Months of Data**: Maintains a rolling 12-month history
- **Multi-Account**: Delegated administrator in AWS Organizations
- **Finding Groups**: Automatically groups related findings and associated resources
- **Investigation Summaries**: AI-powered summaries of investigations

### Key Exam Points

- Detective is for **investigation** (after detection) — not for detection itself
- Works hand-in-hand with **GuardDuty** (GuardDuty detects, Detective investigates)
- No additional infrastructure or data source configuration needed
- Free 30-day trial

---

## AWS Audit Manager

### Overview

AWS Audit Manager helps you continuously audit your AWS usage to simplify how you manage risk and compliance with regulations and industry standards.

### Key Concepts

**Frameworks:**
- **Pre-built frameworks**: GDPR, HIPAA, PCI DSS, SOC 2, ISO 27001, FedRAMP, GxP, NIST CSF, NIST 800-53
- **Custom frameworks**: Build your own controls mapped to your requirements
- **Control sets**: Groups of controls within a framework

**Evidence Collection:**
- **Automated evidence**: Compliance checks from AWS Config, Security Hub, CloudTrail, API calls
- **Manual evidence**: Upload documentation, screenshots, certificates
- **Evidence folders**: Organized by control, with daily evidence snapshots

**Assessments:**
- Create assessments for specific frameworks
- Define scope (accounts, services, regions)
- Assign controls to team members for review
- Track assessment progress

**Assessment Reports:**
- Generate stakeholder-ready reports
- Include evidence summaries and compliance status
- Export to S3 for retention

### Key Exam Points

- Audit Manager is about **compliance evidence collection**, not threat detection
- Integrates with **AWS Config**, **Security Hub**, **CloudTrail**
- Supports **delegated administrator** in AWS Organizations
- Useful when asked about "preparing for audits" or "compliance evidence"

---

## Amazon Cognito

### Cognito User Pools

Amazon Cognito User Pools provide a **user directory** for sign-up and sign-in functionality for web and mobile applications.

#### Core Features

**User Management:**
- Self-service sign-up and sign-in
- Customizable sign-up attributes (email, phone, custom attributes)
- Username options: email, phone number, preferred username, or UUID
- Account verification via email or SMS
- Password policies: minimum length, uppercase, lowercase, numbers, special characters

**Authentication:**
- Token-based authentication (JWT tokens)
  - **ID Token**: User identity claims (name, email, phone, custom attributes)
  - **Access Token**: Authorization claims (scopes, groups)
  - **Refresh Token**: Obtain new ID and Access tokens (configurable expiration: 1 hour to 3650 days)
- Secure Remote Password (SRP) protocol
- Server-side authentication flow (ADMIN_NO_SRP_AUTH, ADMIN_USER_PASSWORD_AUTH)
- Client-side authentication flow (USER_SRP_AUTH, USER_PASSWORD_AUTH)
- Custom authentication flow (CUSTOM_AUTH) with Lambda triggers

**Multi-Factor Authentication (MFA):**
- **TOTP** (Time-based One-Time Password): Authenticator apps (Google Authenticator, Authy)
- **SMS**: One-time code sent via SMS
- MFA settings: Required, Optional, Off
- Adaptive authentication: Risk-based MFA (sign-in from new device, new location)

**Hosted UI:**
- Pre-built, customizable sign-in/sign-up pages
- Custom domain support (e.g., auth.yourdomain.com with ACM certificate)
- Cognito domain (e.g., your-domain.auth.us-east-1.amazoncognito.com)
- Supports OAuth 2.0 flows: Authorization Code Grant, Implicit Grant

**Federation (Social and Enterprise Identity Providers):**
- **Social IdPs**: Facebook, Google, Amazon, Apple
- **SAML 2.0**: Enterprise identity providers (Okta, Azure AD, ADFS)
- **OpenID Connect (OIDC)**: Any OIDC-compliant provider
- Attribute mapping from IdP to Cognito user attributes

**Lambda Triggers:**

| Trigger | Use Case |
|---------|----------|
| **Pre Sign-up** | Validate, auto-confirm, or reject sign-up |
| **Post Confirmation** | Send welcome email, add user to group |
| **Pre Authentication** | Custom validation before authentication |
| **Post Authentication** | Log events, analytics |
| **Pre Token Generation** | Add/remove claims from tokens, customize scopes |
| **Custom Message** | Customize verification/MFA messages |
| **User Migration** | Migrate users from legacy system on first sign-in |
| **Define Auth Challenge** | Custom authentication flow |
| **Create Auth Challenge** | Generate challenge for custom auth |
| **Verify Auth Challenge** | Verify custom auth challenge response |

**Advanced Security Features:**
- Compromised credentials detection
- Adaptive authentication (risk-based)
- User activity logging

#### User Pools Integration with API Gateway

Cognito User Pool can serve as an **authorizer** for API Gateway:
1. Client authenticates with Cognito → receives JWT tokens
2. Client sends API request with token in Authorization header
3. API Gateway validates the token with Cognito
4. If valid, request is forwarded to backend

### Cognito Identity Pools (Federated Identities)

Cognito Identity Pools provide **temporary AWS credentials** to users so they can access AWS services directly (S3, DynamoDB, etc.).

#### How It Works

1. User authenticates with an identity provider (Cognito User Pool, Facebook, Google, SAML, OIDC, or custom developer provider)
2. User exchanges token for Cognito Identity Pool token
3. Identity Pool calls **STS (Security Token Service)** to obtain temporary AWS credentials
4. Credentials are returned to the user with permissions based on the IAM role

#### Identity Types

| Type | Description |
|------|-------------|
| **Authenticated Identities** | Users who have signed in through an IdP. Mapped to an **authenticated IAM role** with broader permissions |
| **Unauthenticated Identities** | Guest users who haven't signed in. Mapped to an **unauthenticated IAM role** with limited permissions (e.g., read-only S3 access) |

#### Role Mapping

**Default Role Mapping:**
- All authenticated users get the same IAM role
- All unauthenticated users get the same IAM role

**Rules-Based Role Mapping:**
- Assign different roles based on token claims
- Example: Users in "admin" group get AdminRole, users in "user" group get UserRole

**Token-Based Role Mapping:**
- Uses the `cognito:preferred_role` claim from the ID token
- Set by Cognito User Pool group membership

#### IAM Policy Variables for Fine-Grained Access

Use `${cognito-identity.amazonaws.com:sub}` in IAM policies for per-user access:

```json
{
  "Effect": "Allow",
  "Action": ["s3:GetObject", "s3:PutObject"],
  "Resource": "arn:aws:s3:::my-bucket/users/${cognito-identity.amazonaws.com:sub}/*"
}
```

This ensures each user can only access their own folder in S3.

### User Pools vs Identity Pools Comparison

| Feature | User Pools | Identity Pools |
|---------|-----------|----------------|
| **Primary Purpose** | Authentication (sign-in/sign-up) | Authorization (AWS credentials) |
| **Output** | JWT Tokens (ID, Access, Refresh) | Temporary AWS Credentials (Access Key, Secret Key, Session Token) |
| **User Directory** | Yes — manages user accounts | No — relies on external IdPs |
| **MFA** | Yes | No |
| **Hosted UI** | Yes | No |
| **Direct AWS Access** | No — tokens are for your app/API Gateway | Yes — credentials allow direct AWS service calls |
| **Guest Access** | No | Yes (unauthenticated identities) |
| **Federation** | Social/SAML/OIDC → Cognito users | User Pools/Social/SAML/OIDC/Custom → AWS credentials |
| **Use Together** | Auth users with User Pool, then exchange tokens for AWS credentials via Identity Pool |

**Common Pattern:**
```
User → Cognito User Pool (authenticate) → JWT Token
JWT Token → Cognito Identity Pool → Temporary AWS Credentials
Credentials → Access S3, DynamoDB, Lambda directly
```

---

## AWS IAM Identity Center (SSO)

### Overview

AWS IAM Identity Center (formerly AWS Single Sign-On / AWS SSO) is the recommended service for managing **human user access** to multiple AWS accounts and business applications from a single place.

### Key Features

**Single Sign-On:**
- One login for all assigned AWS accounts and applications
- User portal with all assigned accounts and apps
- CLI access via `aws sso login`

**Identity Sources:**
- **Identity Center directory** (built-in): Create and manage users/groups directly
- **Active Directory**: Connect to existing AWS Managed Microsoft AD or AD Connector
- **External SAML 2.0 IdP**: Okta, Azure AD, Ping Identity, OneLogin

**Permission Sets:**
- Define permissions (IAM policies) in a reusable permission set
- Assign permission sets to users/groups for specific accounts
- AWS managed policies or custom policies
- Session duration configuration
- Inline policies for fine-grained control

**Multi-Account Permissions:**
- Assign access to AWS accounts from AWS Organizations
- Assign permission sets to users/groups per account
- Centrally manage who has access to what across all accounts

**Application Assignments:**
- SAML 2.0 integration with business applications (Salesforce, Box, Microsoft 365, Slack)
- Custom SAML 2.0 application support
- Built-in application catalog

**Attribute-Based Access Control (ABAC):**
- Use user attributes (department, cost center) for fine-grained access control
- Pass attributes from identity source to IAM policies

### Key Exam Points

- IAM Identity Center is the **recommended** approach for workforce access to AWS accounts
- Successor to AWS SSO
- Works with **AWS Organizations** — manages access across all accounts
- Single place to manage access to AWS accounts AND business applications
- Permission Sets define the IAM policies; assigned per account per user/group

---

## AWS Directory Service

### Overview

AWS Directory Service provides multiple ways to use **Microsoft Active Directory (AD)** with other AWS services.

### Service Options

#### AWS Managed Microsoft AD

A fully managed **Microsoft Active Directory** running on AWS:

- **Full AD features**: Group Policy, LDAP, Kerberos, NTLM, AD administrative tools
- **Two editions**: Standard (≤30,000 objects) and Enterprise (≤500,000 objects)
- **Multi-AZ deployment**: At least 2 domain controllers in different AZs
- **Trust relationships**: Establish trust with on-premises AD (one-way or two-way trust)
- **Supports**: EC2 instances joining the domain, RDS for SQL Server, WorkSpaces, QuickSight, SSO
- **MFA**: Supports RADIUS-based MFA
- **Automatic backups**: Daily snapshots with 5-year retention
- **Seamless Domain Join**: EC2 instances automatically join the domain at launch

**Use Cases:**
- Hybrid environment with on-premises AD
- Run AD-aware workloads on AWS
- Need full AD features (Group Policy, trusts, LDAP)

#### AD Connector

A **proxy** that redirects directory requests to your on-premises Microsoft AD:

- **No caching**: All requests forwarded to on-premises AD
- **No trust relationship needed**: Acts as a proxy
- **Two sizes**: Small (≤500 users) and Large (≤5,000 users)
- **Requires VPN or Direct Connect** to on-premises network
- **Supports**: SSO, EC2 domain join, WorkSpaces
- **MFA**: Supports RADIUS MFA (on-premises MFA server)

**Use Cases:**
- Don't want to manage AD on AWS
- Want to leverage existing on-premises AD investment
- Need connectivity between AWS and on-premises AD

#### Simple AD

A standalone, **low-cost** managed directory powered by **Samba 4**:

- **Compatible with basic AD features**: User accounts, groups, group policies
- **Two sizes**: Small (≤500 users) and Large (≤5,000 users)
- **No trust relationships**: Cannot connect to on-premises AD
- **Does NOT support**: MFA, RDS SQL Server, SSO, PowerShell AD cmdlets, schema extensions
- **Supports**: EC2 domain join, WorkSpaces, basic LDAP

**Use Cases:**
- Need basic AD features without on-premises connectivity
- Budget-conscious and don't need advanced AD features
- Simple user management for AWS resources

### Directory Service Comparison

| Feature | Managed Microsoft AD | AD Connector | Simple AD |
|---------|---------------------|--------------|-----------|
| **Type** | Full Microsoft AD on AWS | Proxy to on-premises AD | Samba 4-based AD |
| **Trust Relationships** | Yes | No | No |
| **On-Premises Connectivity** | Optional (trust) | Required (VPN/DX) | No |
| **MFA** | RADIUS | RADIUS (on-premises) | No |
| **Schema Extensions** | Yes | No | No |
| **RDS SQL Server** | Yes | No | No |
| **SSO/Identity Center** | Yes | Yes | No |
| **Cost** | $$$ | $$ | $ |
| **Best For** | Full AD on AWS + hybrid | Proxy to existing AD | Basic standalone AD |

---

## Common Exam Scenarios

### Scenario 1: Protect Web Application from SQL Injection and XSS

**Question**: A company hosts a web application on ALB and wants to protect against SQL injection and XSS attacks.

**Answer**: Deploy **AWS WAF** on the ALB with **AWS Managed Rules** — specifically `AWSManagedRulesSQLiRuleSet` and `AWSManagedRulesCommonRuleSet` (which includes XSS protection). For centralized management across accounts, use **AWS Firewall Manager**.

### Scenario 2: DDoS Protection with Cost Protection

**Question**: A company wants DDoS protection and doesn't want to pay for infrastructure scaling during attacks.

**Answer**: Enable **AWS Shield Advanced** ($3,000/month). It provides enhanced L3/L4/L7 DDoS protection, access to the DDoS Response Team (DRT), and **cost protection** that credits scaling charges during DDoS events. AWS WAF is included at no additional cost.

### Scenario 3: Detect Compromised EC2 Instance

**Question**: An EC2 instance is suspected of communicating with a known command-and-control server.

**Answer**: **Amazon GuardDuty** would detect this through VPC Flow Logs analysis and DNS log monitoring. Findings would be generated such as `Backdoor:EC2/C&CActivity`. Use **Amazon Detective** to investigate the finding further.

### Scenario 4: Find PII Data in S3 Buckets

**Question**: A company needs to discover and classify all PII data stored across hundreds of S3 buckets for GDPR compliance.

**Answer**: Enable **Amazon Macie** to automatically discover and classify sensitive data in S3. Create sensitive data discovery jobs or use automated discovery. Integrate with EventBridge for automated remediation (e.g., encrypt unencrypted buckets containing PII).

### Scenario 5: Central Security Dashboard

**Question**: A company with 50 AWS accounts needs a central view of security posture and compliance.

**Answer**: Enable **AWS Security Hub** with a delegated administrator account. Enable security standards (CIS, FSBP, PCI DSS). Security Hub aggregates findings from GuardDuty, Inspector, Macie, and other sources. Use **cross-region aggregation** for a single view.

### Scenario 6: Vulnerability Scanning for Containers

**Question**: A company runs containers on ECS with images stored in ECR and needs continuous vulnerability scanning.

**Answer**: **Amazon Inspector** automatically scans ECR container images for vulnerabilities when pushed and when new CVEs are published. No additional agent required for ECR scanning.

### Scenario 7: User Authentication with Social Sign-In

**Question**: A mobile app needs user sign-up/sign-in with Google and Facebook, with direct access to user-specific S3 folders.

**Answer**: Use **Cognito User Pools** for authentication with social federation (Google, Facebook). Use **Cognito Identity Pools** to exchange JWT tokens for temporary AWS credentials. Use IAM policy variables (`${cognito-identity.amazonaws.com:sub}`) to restrict S3 access to per-user folders.

### Scenario 8: Single Sign-On Across AWS Accounts

**Question**: A company with 100 AWS accounts and Azure AD as the identity provider needs SSO.

**Answer**: Use **AWS IAM Identity Center** with **external SAML 2.0 IdP** (Azure AD) as the identity source. Create **permission sets** and assign them to groups from Azure AD for each AWS account. Users access the IAM Identity Center portal for single sign-on.

### Scenario 9: Compliance Audit Preparation

**Question**: A company is preparing for a SOC 2 audit and needs to collect evidence of AWS security controls.

**Answer**: Use **AWS Audit Manager** with the SOC 2 pre-built framework. Audit Manager automatically collects evidence from AWS Config, CloudTrail, and Security Hub. Assign controls to team members for review, then generate an assessment report.

### Scenario 10: Rate Limiting API Requests

**Question**: An API Gateway REST API is being abused with excessive requests from specific IPs.

**Answer**: Deploy **AWS WAF** on the API Gateway with a **rate-based rule** (minimum 100 requests per 5 minutes). Optionally scope down the rule to specific paths (e.g., `/api/login`). This automatically blocks IPs exceeding the threshold.

### Scenario 11: Centralized Firewall Management

**Question**: A company needs to ensure all ALBs across 50 accounts in AWS Organizations have the same WAF rules applied, including new ALBs.

**Answer**: Use **AWS Firewall Manager** with a WAF security policy. Firewall Manager automatically applies WAF rules to all existing and new ALBs across all accounts in the organization. Prerequisites: AWS Organizations with all features, Firewall Manager administrator, and AWS Config enabled.

### Scenario 12: Hybrid AD with Trust Relationship

**Question**: A company has an on-premises Active Directory and needs to extend it to AWS for EC2 instances to join the domain and support Group Policy.

**Answer**: Deploy **AWS Managed Microsoft AD** and establish a **trust relationship** with the on-premises AD. This provides full AD features on AWS including Group Policy, Kerberos, LDAP, and allows EC2 instances to join either the AWS or on-premises domain.

---

## Key Takeaways for the Exam

1. **WAF** = Layer 7 protection (HTTP/HTTPS), rules-based filtering, integrates with CloudFront, ALB, API Gateway, AppSync, Cognito
2. **Shield Standard** = Free, automatic, L3/L4 protection for all AWS customers
3. **Shield Advanced** = $3,000/month, L3/L4/L7, DDoS Response Team, cost protection
4. **Firewall Manager** = Centralized management across AWS Organizations (requires Organizations + Config)
5. **GuardDuty** = Intelligent threat detection (CloudTrail, VPC Flow Logs, DNS, etc.)
6. **Inspector** = Vulnerability scanning (EC2 with SSM, ECR images, Lambda functions)
7. **Macie** = S3 sensitive data discovery (PII, financial data)
8. **Security Hub** = Central security dashboard, aggregates findings, compliance standards (requires Config)
9. **Detective** = Investigation and root cause analysis (after GuardDuty detection)
10. **Audit Manager** = Compliance evidence collection for audits
11. **Cognito User Pools** = Authentication (sign-in/sign-up, JWT tokens)
12. **Cognito Identity Pools** = Authorization (temporary AWS credentials for direct AWS access)
13. **IAM Identity Center** = SSO for workforce access to AWS accounts + business apps
14. **Managed Microsoft AD** = Full AD on AWS, supports trusts with on-premises
15. **AD Connector** = Proxy to on-premises AD, requires VPN/DX
16. **Simple AD** = Basic standalone AD, cheapest, no trusts or MFA
