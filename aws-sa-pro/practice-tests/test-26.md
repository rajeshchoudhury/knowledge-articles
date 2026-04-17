# AWS Certified Solutions Architect - Professional (SAP-C02) Practice Test 26

**Focus Areas:** Identity Federation — SAML 2.0, OIDC, Amazon Cognito, IAM Identity Center, Active Directory Integration
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

A global financial services company has 200 AWS accounts under AWS Organizations. They currently use a third-party SAML 2.0 identity provider (IdP) for workforce authentication. Each team manually configures IAM roles and SAML trust relationships in their individual accounts. The security team has discovered 47 accounts with misconfigured SAML provider metadata, creating authentication failures. Management wants a centralized solution that eliminates per-account SAML configuration while maintaining granular permission assignments.

Which approach BEST meets these requirements?

A. Deploy AWS IAM Identity Center with the third-party IdP as the external identity source. Create permission sets that map to IAM policies and assign them to groups synced from the IdP across organizational units.

B. Create a centralized Lambda function that propagates SAML provider metadata to all accounts via AssumeRole, triggered by an EventBridge schedule every 6 hours.

C. Configure AWS SSO in the management account with SAML federation and use CloudFormation StackSets to deploy identical IAM SAML providers across all member accounts.

D. Migrate all users to AWS Managed Microsoft AD and use Kerberos-based authentication with IAM roles in each account.

**Correct Answer: A**

**Explanation:** AWS IAM Identity Center (successor to AWS SSO) provides native integration with AWS Organizations, enabling centralized management of workforce access across all accounts. By connecting the third-party IdP as an external identity source, you eliminate the need for per-account SAML provider configuration. Permission sets are defined once and assigned to groups across accounts/OUs. Option B is a custom solution with propagation delays and operational overhead. Option C still requires per-account SAML providers and doesn't truly centralize the configuration. Option D requires a full identity migration and changes the authentication protocol, which is unnecessarily disruptive.

---

### Question 2

A healthcare company uses AWS Organizations with 50 accounts. They have an on-premises Microsoft Active Directory with 12,000 users. Developers need console access to development accounts, while operations staff need CLI access to production accounts. Compliance requires that all access be traced to a specific AD group membership and that no long-lived credentials be issued. AD group membership changes must be reflected within 1 hour.

Which architecture meets ALL requirements?

A. Deploy AWS Managed Microsoft AD in a shared services account with a two-way forest trust to on-premises AD. Configure IAM Identity Center with AD as the identity source and enable automatic synchronization. Create permission sets mapped to AD groups.

B. Deploy AD Connector in each AWS account pointing to the on-premises AD. Configure SAML 2.0 federation per account with IAM roles mapped to AD groups.

C. Configure IAM Identity Center with SCIM provisioning from the on-premises AD through Azure AD as an intermediary. Create permission sets assigned to synchronized groups.

D. Deploy a fleet of EC2 instances running Active Directory Federation Services (ADFS) behind an ALB. Configure each account with SAML federation pointing to the ADFS endpoint.

**Correct Answer: A**

**Explanation:** AWS Managed Microsoft AD with a two-way forest trust to on-premises AD enables IAM Identity Center to use AD as its identity source. This setup provides automatic synchronization of users and groups, centralized permission set management, temporary credentials for both console and CLI access, and CloudTrail logging that traces actions to AD identities. Option B requires per-account configuration and AD Connector instances. Option C introduces Azure AD as an unnecessary intermediary—IAM Identity Center can work directly with Managed Microsoft AD. Option D requires managing ADFS infrastructure with high availability, which adds operational burden. The Managed Microsoft AD sync interval satisfies the 1-hour requirement.

---

### Question 3

A SaaS company is building a multi-tenant application on AWS. Each tenant's employees must authenticate using their own corporate identity provider (which may be SAML 2.0 or OIDC). After authentication, users must receive temporary AWS credentials scoped to their tenant's data partition in DynamoDB and S3. The solution must support onboarding hundreds of new tenants without code changes.

Which architecture BEST meets these requirements?

A. Create an Amazon Cognito user pool with a separate app client for each tenant. Configure each tenant's IdP as a federated identity provider in the user pool. Use a Cognito identity pool with role mapping based on the tenant claim to vend scoped temporary credentials.

B. Create a separate IAM SAML provider and IAM role for each tenant. Build a custom broker application that determines the tenant from the SAML assertion and calls AssumeRoleWithSAML for the correct role.

C. Deploy a single Amazon Cognito user pool per tenant, each configured with the tenant's IdP. Use API Gateway with Cognito authorizers and implement data isolation at the application layer.

D. Use IAM Identity Center with an external IdP and create permission sets per tenant. Map each tenant's users to their respective permission set.

**Correct Answer: A**

**Explanation:** A single Cognito user pool supporting multiple IdPs (both SAML and OIDC) is the most scalable architecture. Each tenant's IdP is registered as a federated provider in the user pool. The Cognito identity pool uses role mapping with rules or token-based claims to assign tenant-specific IAM roles with policy variables (e.g., `${cognito-identity.amazonaws.com:sub}`) for fine-grained data access. Adding tenants requires only IdP configuration—no code changes. Option B doesn't scale well with hundreds of tenants and requires managing a custom broker. Option C creates operational overhead with hundreds of user pools. Option D is designed for workforce access to AWS accounts, not application-level multi-tenant federation.

---

### Question 4

An enterprise is consolidating identity management across 8 AWS accounts. They have an on-premises Okta deployment used by 5,000 employees. Requirements include: (1) SSO to all AWS accounts, (2) attribute-based access control using department and project tags, (3) automated provisioning and deprovisioning of user access when employees join or leave, (4) session duration of 8 hours for developers. The solution must minimize custom development.

Which configuration BEST meets these requirements?

A. Configure IAM Identity Center with Okta as the external identity source using SCIM for automatic provisioning. Enable ABAC with attributes passed from Okta. Create permission sets with session duration set to 8 hours and assign them to Okta groups.

B. Configure each account with a SAML 2.0 provider pointing to Okta. Create IAM roles with 8-hour max session duration and trust policies referencing the Okta IdP. Use Okta lifecycle management to call a custom Lambda that removes role assignments on deprovisioning.

C. Deploy an Amazon Cognito user pool federated with Okta. Use Cognito groups mapped to IAM roles in each account. Configure token expiration to 8 hours.

D. Use AWS Directory Service to create a new Managed Microsoft AD. Sync users from Okta to AD using a third-party tool. Configure IAM Identity Center with AD as the identity source.

**Correct Answer: A**

**Explanation:** IAM Identity Center natively supports Okta as an external identity source with SCIM v2.0 for automated provisioning and deprovisioning. ABAC is supported through identity store attributes that map to session tags, enabling department and project-based access control. Permission sets support configurable session durations up to 12 hours. This is a fully managed, no-custom-code solution. Option B requires per-account configuration and a custom Lambda for deprovisioning. Option C is designed for customer-facing applications, not workforce SSO, and Cognito tokens don't translate directly to IAM console sessions. Option D introduces unnecessary complexity by adding AD as a middleman between Okta and IAM Identity Center.

---

### Question 5

A government agency requires all API calls to AWS services to be authenticated using PIV/CAC smart card certificates. They have an existing ADFS infrastructure that validates smart card certificates. The agency uses 30 AWS accounts and needs both console and programmatic access. All sessions must terminate after 1 hour, and MFA via smart card must be enforced for every session.

Which solution meets these requirements?

A. Configure IAM Identity Center with ADFS as the external SAML 2.0 provider. ADFS enforces certificate-based authentication before issuing SAML assertions. Set permission set session duration to 1 hour. Configure ADFS claims rules to include an MFA assertion.

B. Create IAM users with virtual MFA devices in each account. Configure ADFS to issue SAML tokens that include the MFA claim, then use AssumeRoleWithSAML with the MFA condition.

C. Deploy AWS Managed Microsoft AD with smart card authentication enabled. Configure IAM roles with a condition requiring `aws:MultiFactorAuthPresent` and a 1-hour maximum session.

D. Use Cognito user pools with custom authentication flows that validate smart card certificates through a Lambda trigger. Issue credentials with 1-hour expiration.

**Correct Answer: A**

**Explanation:** ADFS already handles PIV/CAC certificate-based authentication. By configuring ADFS as the SAML 2.0 provider for IAM Identity Center, smart card authentication is enforced at the ADFS layer before any AWS access is granted. ADFS includes the SAML authentication context class `urn:oasis:names:tc:SAML:2.0:ac:classes:SmartcardPKI` in the assertion, which AWS treats as MFA. The 1-hour session is enforced via permission set session duration. This centralizes access management across all 30 accounts. Option B creates unnecessary IAM users with credentials. Option C doesn't natively support smart card authentication for AWS console access. Option D is application-level, not workforce console/CLI access.

---

### Question 6

A multinational corporation has a hybrid identity architecture: US employees use Azure AD, European employees use on-premises ADFS, and Asia-Pacific employees use Ping Identity. All 15,000 employees need SSO to 80 AWS accounts organized under AWS Organizations. The company wants a single portal for all employees regardless of their home IdP.

Which architecture provides the BEST solution?

A. Configure IAM Identity Center with one of the IdPs as the external identity source. Federate the other two IdPs into that primary IdP first, then sync to IAM Identity Center.

B. Configure IAM Identity Center with its built-in identity store. Use SCIM provisioning from all three IdPs to sync users and groups into the Identity Center directory. Configure SSO applications in each IdP pointing to Identity Center.

C. Set up separate SAML federation in each AWS account with all three IdPs. Create three IAM roles per access pattern in each account—one trusted by each IdP.

D. Deploy Amazon Cognito with all three IdPs configured as social/enterprise federation providers. Use Cognito tokens to assume IAM roles in each account.

**Correct Answer: A**

**Explanation:** IAM Identity Center supports only a single external identity source. The recommended approach for multiple IdPs is to establish a hub-and-spoke federation model where one IdP acts as the primary identity hub. Azure AD is commonly used as the hub because it natively supports federation with ADFS and other SAML/OIDC providers. All employees authenticate through the hub IdP, which then federates to IAM Identity Center, providing a single portal experience. Option B won't work because IAM Identity Center accepts only one external identity source; you can't have three IdPs provisioning into it simultaneously. Option C is operationally unmanageable at 80 accounts × 3 IdPs. Option D is for application-level authentication, not workforce AWS account access.

---

### Question 7

A company's security team discovers that developers are using long-lived IAM access keys in their applications running on EC2 instances. The company uses AWS Organizations with 40 accounts and IAM Identity Center with an external IdP. Management mandates that all human access must use temporary credentials through federation and that IAM access keys for human users must be disabled organization-wide.

Which combination of actions achieves this? (Choose THREE.)

A. Create an SCP that denies `iam:CreateAccessKey` and `iam:UpdateAccessKey` for all principals except service-linked roles and specific automation roles.

B. Use IAM Identity Center CLI credential helper (aws configure sso) to provide temporary credentials for developer CLI access.

C. Create an AWS Config rule to detect IAM users with active access keys and configure auto-remediation to deactivate them.

D. Migrate all application workloads on EC2 to use IAM instance profiles with roles instead of IAM user access keys.

E. Delete all IAM users across all accounts using a Lambda function triggered by a Step Functions workflow.

**Correct Answer: A, B, D**

**Explanation:** This requires a three-pronged approach: (1) SCP (A) prevents creation of new access keys organization-wide, with exceptions for service automation roles—this is a preventive control. (2) IAM Identity Center CLI integration (B) gives developers temporary credentials via `aws sso login`, replacing the need for long-lived access keys. (3) Migrating EC2 applications to instance profiles (D) eliminates the application-level dependency on access keys. Option C is detective but doesn't prevent new key creation and would disrupt running applications without migration. Option E is dangerously aggressive—deleting IAM users would break service accounts and applications that legitimately use them.

---

### Question 8

A retail company is building a mobile application where customers authenticate with their social accounts (Google, Facebook, Apple). After authentication, users must upload photos to a user-specific S3 prefix and read only their own order records from DynamoDB. The application must support millions of users with no per-user IAM role creation.

Which architecture provides the MOST scalable and secure solution?

A. Create a Cognito user pool with Google, Facebook, and Apple as federated identity providers. Create a Cognito identity pool linked to the user pool. Define an authenticated IAM role with policy variables using `${cognito-identity.amazonaws.com:sub}` for S3 prefix and DynamoDB leading key isolation.

B. Build a custom authentication backend on API Gateway and Lambda that validates social tokens, creates a unique IAM user per customer, and attaches inline policies for resource isolation.

C. Use a Cognito user pool only. Generate pre-signed S3 URLs from a Lambda function authorized by the Cognito user pool token. Access DynamoDB through API Gateway with Cognito authorizers.

D. Create a single IAM role that all mobile users assume via web identity federation directly with Google/Facebook/Apple. Use S3 bucket policies and DynamoDB fine-grained access control conditions.

**Correct Answer: A**

**Explanation:** The Cognito user pool + identity pool pattern is purpose-built for this use case. The user pool handles federation with social IdPs and provides a normalized identity. The identity pool exchanges user pool tokens for temporary AWS credentials with the authenticated IAM role. Policy variables like `${cognito-identity.amazonaws.com:sub}` enforce per-user data isolation in S3 (prefix-based) and DynamoDB (leading key condition) without per-user role creation. Option B doesn't scale—creating IAM users for millions of customers would hit account limits. Option C works but requires a backend for every S3 operation instead of direct client-to-S3 uploads. Option D bypasses the user pool normalization layer and requires configuring each social provider separately as a web identity provider in IAM.

---

### Question 9

An organization uses AWS IAM Identity Center with Azure AD as the external identity source. They have configured SCIM provisioning. The security team notices that when a user is disabled in Azure AD, the user's active AWS sessions continue for up to 12 hours. Compliance requires that access be revoked within 15 minutes of deprovisioning in Azure AD.

Which solution addresses this requirement?

A. Reduce the IAM Identity Center permission set session duration to 15 minutes for all permission sets.

B. Configure Azure AD to send a SCIM deprovisioning event to Identity Center. Create an EventBridge rule that detects user deprovisioning events and triggers a Lambda function that calls `DeleteAccountAssignment` and revokes all active sessions using the `identity-store:DeleteUser` API.

C. Enable AWS CloudTrail monitoring of Identity Center events. Create an EventBridge rule to detect `DeactivateUser` events and trigger a Lambda that calls the `iam:DeleteRolePolicy` API for the user's assumed roles.

D. Configure the Azure AD conditional access policy to check user status every 15 minutes and terminate AWS sessions for disabled users.

**Correct Answer: B**

**Explanation:** SCIM deprovisioning syncs the user status change to Identity Center, but active sessions persist until they expire. To enforce the 15-minute requirement, you need an automated response: an EventBridge rule detects the SCIM-triggered deprovisioning event in Identity Center, and a Lambda function actively revokes the user's account assignments and removes them from the identity store, effectively terminating their ability to use existing sessions. Option A would severely impact usability for all users, forcing re-authentication every 15 minutes. Option C won't effectively revoke already-assumed role sessions. Option D is not possible—Azure AD cannot directly manage AWS session state.

---

### Question 10

A company is migrating from a legacy LDAP directory to AWS. They have 3,000 users and 200 groups in LDAP. Applications running on EC2 instances perform LDAP binds for authentication. The company also wants to use the same directory for AWS console SSO. They need to maintain LDAP compatibility for existing applications during a 6-month transition period.

Which approach meets these requirements with minimal application changes?

A. Deploy AWS Managed Microsoft AD. Migrate users and groups from LDAP to Managed Microsoft AD using the AD Migration Toolkit. Configure IAM Identity Center with Managed Microsoft AD as the identity source. Point EC2 applications to the Managed Microsoft AD LDAP endpoint.

B. Deploy Amazon Cognito user pools and import all LDAP users. Configure Cognito as the SAML provider for IAM Identity Center. Modify EC2 applications to use Cognito authentication APIs.

C. Create all users in the IAM Identity Center built-in identity store. Configure EC2 applications to use IAM Identity Center's OIDC endpoint for authentication.

D. Deploy an AD Connector pointing to the existing LDAP directory. Use AD Connector as the identity source for IAM Identity Center.

**Correct Answer: A**

**Explanation:** AWS Managed Microsoft AD provides LDAP compatibility (it supports LDAP binds on port 389/636), which means existing EC2 applications can authenticate against it with minimal changes—just updating the LDAP endpoint. Simultaneously, IAM Identity Center can use Managed Microsoft AD as its identity source for console SSO. This provides both LDAP compatibility for legacy applications and modern SSO federation. Option B requires modifying all applications to use Cognito APIs—not LDAP compatible. Option C doesn't provide LDAP endpoints. Option D requires an existing AD (not LDAP) and AD Connector doesn't support all scenarios; the question states they have LDAP, not AD.

---

### Question 11

An enterprise with AWS Organizations has implemented IAM Identity Center with permission sets. The security team needs to implement emergency access ("break glass") to production accounts that: (1) bypasses normal IAM Identity Center flows, (2) is audited separately, (3) requires approval from two security team members, and (4) automatically expires after 2 hours.

Which architecture provides the MOST secure break-glass mechanism?

A. Create dedicated IAM users with MFA in each production account with administrator access. Store credentials in AWS Secrets Manager with automatic rotation. Require two security team members to retrieve the secret simultaneously.

B. Create a separate permission set in IAM Identity Center with AdministratorAccess and a 2-hour session duration. Use a Step Functions workflow that requires approval from two security team members via SNS and then temporarily assigns the permission set to the requesting user. EventBridge triggers removal after 2 hours.

C. Pre-provision cross-account IAM roles in production accounts with trust policies that require `aws:MultiFactorAuthPresent` and `aws:PrincipalTag/BreakGlass`. Use a separate IdP federation path that assigns the BreakGlass tag only after dual approval.

D. Store SSH keys for EC2 instances in AWS Systems Manager Parameter Store. Require two approvals via Change Manager to retrieve keys, with automatic parameter rotation after 2 hours.

**Correct Answer: B**

**Explanation:** This solution leverages existing IAM Identity Center infrastructure while adding a controlled break-glass workflow. The Step Functions workflow enforces dual approval through separate SNS/email confirmations from two security team members. The permission set's 2-hour session duration and the EventBridge-triggered removal ensure automatic expiry. All actions are audited through CloudTrail. Option A creates long-lived credentials that pose a security risk even with rotation. Option C is complex to implement and maintain with custom IdP configurations. Option D only provides access to EC2 instances, not to AWS service APIs in production accounts.

---

### Question 12

A company is building a customer-facing web application. Business requirements state that users must be able to sign up with email/password and also sign in with corporate SAML providers. The application needs to support multi-factor authentication for email/password users, custom email verification workflows, and the ability to migrate users from a legacy PostgreSQL user database without requiring password resets.

Which Amazon Cognito configuration meets ALL requirements?

A. Create a Cognito user pool with email/password sign-up enabled. Add SAML identity providers for corporate federation. Enable adaptive MFA. Configure a User Migration Lambda trigger to authenticate users against the legacy PostgreSQL database on first login. Use custom message Lambda triggers for email verification.

B. Create a Cognito identity pool with developer-authenticated identities. Build a custom authentication API that checks the PostgreSQL database. Manually federate with SAML providers using AssumeRoleWithSAML.

C. Create two separate Cognito user pools: one for email/password users and one for SAML-federated users. Migrate PostgreSQL users by bulk import using CSV. Implement MFA using a custom Lambda authorizer.

D. Use IAM Identity Center for corporate SAML users and Cognito user pools for email/password users. Build a custom federation broker to unify the two authentication paths.

**Correct Answer: A**

**Explanation:** A single Cognito user pool supports both native email/password sign-up and SAML federation. The User Migration Lambda trigger enables seamless migration from the legacy PostgreSQL database—when a user first logs in, the trigger authenticates against PostgreSQL and creates the user in Cognito without a password reset. Adaptive MFA provides the required multi-factor authentication. Custom message Lambda triggers enable customized email verification workflows. Option B doesn't support native user pool features like MFA and SAML federation. Option C unnecessarily splits the user base and CSV import requires password resets. Option D creates unnecessary architectural complexity by mixing two different identity systems.

---

### Question 13

A company with AWS Organizations (150 accounts) needs to implement a tagging governance strategy where: (1) all IAM Identity Center sessions must include cost-center and environment session tags, (2) permission sets must use ABAC to restrict access based on these tags, and (3) resources can only be accessed when the session tag matches the resource tag. The IdP is Okta.

Which implementation is correct?

A. Configure Okta to include `CostCenter` and `Environment` as SAML attributes in assertions. Map these attributes to IAM Identity Center session tags using attribute mappings. Create permission sets with IAM policies that use `aws:PrincipalTag/CostCenter` and `aws:PrincipalTag/Environment` conditions matched against `aws:ResourceTag` equivalents.

B. Create IAM policies in each account that use `aws:RequestTag` conditions. Configure Okta to pass tags as custom OIDC claims.

C. Use AWS Organizations tag policies to enforce tag values. Create SCPs that deny all actions unless the principal has the correct tags.

D. Configure IAM Identity Center to auto-assign tags based on the OU to which the account belongs. Create permission sets that reference OU-level tags.

**Correct Answer: A**

**Explanation:** IAM Identity Center supports ABAC through session tags. Okta sends attributes as SAML assertions, which IAM Identity Center maps to session tags using the attribute mapping configuration. Permission sets containing IAM policies with `aws:PrincipalTag` conditions compared against `aws:ResourceTag` conditions enforce that users can only access resources whose tags match their session tags. This works across all 150 accounts without per-account configuration. Option B uses OIDC claims, which aren't how IAM Identity Center receives attributes from SAML IdPs. Option C conflates tag policies (which govern tag compliance) with access control. Option D is not a feature of IAM Identity Center—tags are not automatically assigned based on OU membership.

---

### Question 14

A financial institution must implement identity federation that meets the following regulatory requirements: (1) all SAML assertions must be signed AND encrypted, (2) only specific named users can access production accounts, (3) all federation events must be logged to a tamper-proof audit trail, and (4) the maximum session duration for production access must be 1 hour.

Which configuration meets ALL requirements?

A. Configure IAM Identity Center with the corporate IdP. Upload the IdP's signing certificate and configure assertion encryption. Create production permission sets with 1-hour session duration and assign only specific named users (not groups) to production accounts. Enable CloudTrail with log file validation in an immutable S3 bucket with Object Lock.

B. Configure per-account SAML federation with IAM roles. Set maximum session duration to 1 hour on each role. Use CloudWatch Logs to capture federation events.

C. Use Cognito user pools with SAML federation. Enable advanced security features for logging. Set token expiration to 1 hour.

D. Deploy ADFS on EC2 with encrypted SAML assertions. Configure each account's IAM SAML provider. Enable VPC Flow Logs for audit.

**Correct Answer: A**

**Explanation:** IAM Identity Center supports SAML assertion signing and encryption through certificate exchange with the IdP. Individual user assignments (rather than group assignments) to production accounts ensure only named users have access. Permission sets enforce the 1-hour session duration. CloudTrail with log file validation stored in an S3 bucket with Object Lock (Compliance mode) provides a tamper-proof audit trail of all federation events. Option B requires managing per-account SAML configurations across multiple accounts. Option C is for application authentication, not workforce AWS console access. Option D requires managing ADFS infrastructure and VPC Flow Logs don't capture authentication events.

---

### Question 15

A media company has a serverless application using API Gateway and Lambda. They need to support three authentication methods simultaneously: (1) internal employees via corporate SAML IdP, (2) partner companies via their own OIDC providers, and (3) anonymous users with rate-limited access. All authenticated users should receive different API rate limits based on their identity type.

Which architecture handles all three authentication methods with appropriate rate limiting?

A. Create a Cognito user pool with the corporate SAML IdP and partner OIDC providers configured. Use Cognito groups to categorize users (employee, partner). Configure API Gateway with a Cognito authorizer. Create three API Gateway usage plans with API keys: employee (high limit), partner (medium limit), anonymous (low limit). Use a Lambda@Edge function to assign API keys based on the Cognito group or lack of authentication.

B. Create three separate API Gateway endpoints, each with different authorizers: Cognito for employees, Lambda for partners, and IAM for anonymous. Set different throttling per endpoint.

C. Deploy a single API Gateway with a Lambda authorizer that validates SAML tokens, OIDC tokens, and API keys. Return different usage identifiers based on the token type. Configure usage plans linked to these identifiers.

D. Use CloudFront with three origins, each mapped to a different API Gateway stage. Configure CloudFront behaviors to route based on authentication headers.

**Correct Answer: C**

**Explanation:** A custom Lambda authorizer provides the flexibility to handle all three authentication methods in a single API Gateway. It can validate SAML assertions from employees, OIDC tokens from partners, and handle unauthenticated/API-key-based anonymous access. The authorizer returns a usage identifier in the authorization response, which API Gateway maps to the appropriate usage plan for rate limiting. Option A has issues because Cognito authorizers don't natively handle anonymous access with rate limiting in the same flow. Option B fragments the API across three endpoints, creating maintenance overhead. Option D is a routing solution that doesn't address authentication or rate limiting requirements.

---

### Question 16

An organization is implementing AWS Control Tower for their multi-account environment. They want to integrate their existing Ping Federate IdP with IAM Identity Center. However, they discover that Control Tower provisions accounts with default IAM Identity Center configurations. They need to ensure that: (1) all Control Tower-provisioned accounts automatically work with Ping Federate SSO, (2) a baseline set of permission sets is applied to every new account, and (3) changes to permission sets are version-controlled.

Which approach achieves this?

A. Configure IAM Identity Center with Ping Federate as the external identity source before enabling Control Tower. Use Control Tower lifecycle events and a Lambda function to automatically assign baseline permission sets to newly created accounts. Store permission set definitions in CodeCommit and use CodePipeline to deploy changes via CloudFormation.

B. Manually configure Ping Federate SAML providers in each account after Control Tower provisioning. Use Service Catalog to deploy permission sets as products.

C. Disable IAM Identity Center in Control Tower and configure direct SAML federation per account. Use Terraform to manage IAM roles across accounts.

D. Use Control Tower Account Factory for Terraform (AFT) with custom templates that include SAML provider configuration and IAM roles for Ping Federate.

**Correct Answer: A**

**Explanation:** Configuring IAM Identity Center with Ping Federate before enabling Control Tower ensures that the IdP integration is foundational. Control Tower lifecycle events (specifically `CreateManagedAccount`) trigger a Lambda function that automatically assigns baseline permission sets to new accounts, ensuring consistent access from day one. Storing permission set definitions in CodeCommit with CodePipeline deployment provides version control and CI/CD for access management. Option B is manual and doesn't scale. Option C loses the benefits of IAM Identity Center centralization. Option D configures SAML at the account level rather than leveraging IAM Identity Center's centralized model.

---

### Question 17

A healthcare company needs to implement cross-account access for a third-party auditing firm. The auditors must be able to read CloudTrail logs, Config snapshots, and Security Hub findings across all 60 accounts. The auditing firm uses their own AWS account and IdP. Access must be read-only, limited to specific services, and automatically expire after 90 days. The company wants to avoid sharing any credentials.

Which solution meets these requirements with the LEAST operational overhead?

A. Create an IAM role in each of the 60 accounts with a trust policy allowing the auditing firm's AWS account. Scope the role's permissions to read-only access for CloudTrail, Config, and Security Hub. Set up a Lambda function to delete the roles after 90 days.

B. Create an IAM Identity Center permission set with read-only access to CloudTrail, Config, and Security Hub. Create a temporary user in Identity Center for each auditor and assign the permission set across all 60 accounts. Use an EventBridge scheduled rule to remove assignments after 90 days.

C. Aggregate CloudTrail logs, Config snapshots, and Security Hub findings into a centralized S3 bucket and Security Hub delegated administrator. Create a single cross-account IAM role in the centralized account trusting the auditing firm's account with conditions for 90-day expiry using `aws:CurrentTime`.

D. Set up a VPN connection to the auditing firm and provide direct network access to the AWS Management Console through a proxy server with read-only restrictions.

**Correct Answer: C**

**Explanation:** Centralizing audit data (CloudTrail to an organization trail's S3 bucket, Config via an aggregator, Security Hub via a delegated administrator) reduces the access surface to a single account. A cross-account IAM role in this centralized account with a trust policy trusting the auditing firm's AWS account, combined with a `Condition` block using `aws:CurrentTime` for the 90-day expiry, provides secure, time-limited, credential-free access. Option A requires managing roles in 60 accounts. Option B creates auditor users in Identity Center, which mixes workforce and external access. Option D is insecure and impractical.

---

### Question 18

A company has implemented IAM Identity Center with an external SAML IdP. They have 10 permission sets used across 100 accounts. The security team wants to enforce that all permission sets in production accounts include a boundary that prevents: (1) creating IAM users, (2) modifying identity provider configurations, and (3) escalating privileges by attaching AdministratorAccess policies. This restriction must apply even to permission sets created in the future.

Which approach provides the MOST reliable enforcement?

A. Create an SCP attached to the production OU that denies `iam:CreateUser`, `iam:CreateSAMLProvider`, `iam:UpdateSAMLProvider`, `iam:DeleteSAMLProvider`, and `iam:AttachRolePolicy` when the policy ARN is `arn:aws:iam::policy/AdministratorAccess`. Exempt the management account's Identity Center role.

B. Add a permissions boundary to every IAM Identity Center-created role in production accounts that restricts these actions.

C. Include explicit deny statements in every permission set assigned to production accounts. Create an AWS Config rule to verify that all permission sets include these denies.

D. Use IAM Access Analyzer to detect permission sets that allow these actions and manually remediate findings.

**Correct Answer: A**

**Explanation:** SCPs are the most reliable enforcement mechanism because they apply to all principals in member accounts regardless of their permissions, including future permission sets. The SCP attached to the production OU denies the specified identity-related actions, preventing IAM user creation, IdP modifications, and privilege escalation. This applies automatically to any new permission set—no additional configuration needed. Option B requires modifying IAM Identity Center's role creation process, which isn't directly supported. Option C requires updating every permission set and only detects non-compliance, doesn't prevent it for new sets. Option D is detective, not preventive.

---

### Question 19

An organization is deploying a data lake accessible by multiple teams across 20 AWS accounts. They use IAM Identity Center with ABAC. The data lake's S3 buckets and Glue Data Catalog tables are tagged with `DataClassification` (public, internal, confidential, restricted) and `Department` tags. Users should only access data matching their department and clearance level, which are provided as attributes from the IdP.

Which implementation enforces these requirements at the IAM level?

A. Create permission sets with IAM policies that use `aws:PrincipalTag/Department` matched against `aws:ResourceTag/Department` AND `aws:PrincipalTag/Clearance` evaluated against `aws:ResourceTag/DataClassification` using a custom condition that maps clearance levels to classification levels. Configure the IdP to send Department and Clearance as SAML attributes mapped to session tags.

B. Create separate permission sets for each department-clearance combination. Assign users to the appropriate permission set based on their department and clearance level.

C. Use Lake Formation with tag-based access control. Map IAM Identity Center users to Lake Formation data permissions based on their department tag. Control data classification access through Lake Formation data filters.

D. Create S3 bucket policies in the data lake account that reference IAM Identity Center user ARNs with explicit allow/deny per classification level.

**Correct Answer: C**

**Explanation:** AWS Lake Formation with tag-based access control (LF-TBAC) is purpose-built for this scenario. LF-TBAC allows you to assign LF-Tags to Data Catalog databases, tables, and columns, then grant permissions to IAM Identity Center users/groups based on tag expression matching. This integrates with IAM Identity Center session tags from the IdP for department and clearance, providing fine-grained data lake access control without complex IAM policies. Option A's IAM policy approach becomes complex when mapping clearance levels to classification hierarchies. Option B creates a combinatorial explosion of permission sets. Option D requires managing individual user ARNs, which doesn't scale.

---

### Question 20

A company has acquired another company. The acquiring company uses IAM Identity Center with Okta, and the acquired company uses direct SAML federation with ADFS to their 25 AWS accounts. During a 12-month integration period, employees from both companies need access to all accounts. After integration, all employees should use the Okta-based IAM Identity Center setup. The solution must minimize disruption during the transition.

Which migration strategy is BEST?

A. Immediately switch all acquired company accounts to IAM Identity Center and force all acquired employees to enroll in Okta. This provides a clean cutover.

B. Add the acquired company's 25 accounts to the acquiring company's AWS Organization. Keep existing ADFS SAML federation in the acquired accounts operational. Gradually sync acquired company users from ADFS to Okta. Configure IAM Identity Center permission sets for acquired accounts. Run both access methods in parallel. After verifying all acquired users can access via Identity Center, remove the per-account SAML configuration.

C. Create a separate IAM Identity Center instance for the acquired company connected to ADFS. Merge the two Identity Center instances after 12 months.

D. Use AWS Resource Access Manager to share resources between the two organizations. Maintain separate identity systems permanently.

**Correct Answer: B**

**Explanation:** A parallel-run migration strategy minimizes disruption. By adding the acquired accounts to the Organization, you can gradually extend IAM Identity Center access while keeping existing ADFS federation working. This gives acquired employees uninterrupted access during the transition. Users are synced from ADFS to Okta progressively, and once validated, per-account SAML configurations are removed. Option A causes immediate disruption as employees must immediately adopt a new IdP. Option C is not possible—an Organization can have only one IAM Identity Center instance. Option D doesn't address the integration requirement and maintaining separate systems is costly long-term.

---

### Question 21

A startup is building a B2C mobile application that requires: (1) passwordless authentication using email magic links, (2) the ability to link social identities (Google, Apple) to the same user profile, (3) user attributes stored and searchable (e.g., preferred_language, subscription_tier), and (4) pre-token-generation customization to inject subscription information into JWT claims.

Which Amazon Cognito configuration meets ALL requirements?

A. Create a Cognito user pool with custom authentication challenge Lambda triggers implementing magic link flows. Enable social identity providers (Google, Apple) with attribute mapping and account linking. Store custom attributes (preferred_language, subscription_tier) in the user pool schema. Use a Pre Token Generation Lambda trigger to add subscription claims to the JWT.

B. Create a Cognito identity pool with developer-authenticated identities for magic links. Federate with Google and Apple at the identity pool level. Store user attributes in a DynamoDB table.

C. Build a custom authentication service on ECS. Use Cognito user pools only for social sign-in. Store all attributes in RDS. Generate custom JWTs.

D. Use Amazon Verified Permissions for authentication and authorization. Configure magic link authentication through SES integration. Store user profiles in the Verified Permissions policy store.

**Correct Answer: A**

**Explanation:** Cognito user pools support custom authentication flows through DefineAuthChallenge, CreateAuthChallenge, and VerifyAuthChallengeResponse Lambda triggers, enabling passwordless magic link authentication. Social identity providers are natively supported with automatic account linking when users sign in with the same email. Custom attributes in the user pool schema support searchable user attributes. The Pre Token Generation trigger allows injecting custom claims into JWTs before they're issued. Option B doesn't support user pool features like custom authentication flows and searchable attributes. Option C requires building and maintaining custom auth infrastructure. Option D is an authorization service, not an authentication service.

---

### Question 22

A government contractor needs to implement a solution where: (1) application users authenticate via a government-approved OIDC provider, (2) after authentication, the application checks the user's access against a fine-grained policy store that evaluates attributes like clearance_level, office_code, and project_assignment, (3) policies must be versioned and auditable, and (4) the solution must use AWS-managed services.

Which architecture BEST meets these requirements?

A. Use Amazon Cognito user pool federated with the government OIDC provider for authentication. Use Amazon Verified Permissions with a Cedar policy store for authorization decisions. Pass user attributes from the Cognito token to Verified Permissions for policy evaluation. Store policy versions in the Verified Permissions policy store with change tracking via CloudTrail.

B. Use Cognito user pools for authentication. Build a custom authorization engine on Lambda that evaluates JSON policies stored in S3. Version policies using S3 versioning.

C. Use IAM Identity Center federated with the OIDC provider. Use IAM policies with conditions for fine-grained authorization. Track changes via Config.

D. Use Cognito with custom attributes for clearance_level, office_code, and project_assignment. Implement authorization logic entirely in the application code using Cognito group memberships.

**Correct Answer: A**

**Explanation:** Amazon Verified Permissions provides a managed, fine-grained authorization service using the Cedar policy language. It's designed for application-level authorization with attribute-based access control. Cognito handles authentication with the government OIDC provider, and the resulting tokens contain user attributes. The application passes these attributes to Verified Permissions for policy evaluation. Cedar policies are expressive enough to handle complex rules involving clearance levels, office codes, and project assignments. All policy changes are auditable via CloudTrail. Option B requires building and maintaining a custom authorization engine. Option C uses IAM for application-level auth, which is the wrong tool. Option D embeds authorization logic in application code, making it hard to audit and version.

---

### Question 23

A company is building a multi-Region active-active web application. Users authenticate via Amazon Cognito. The application must ensure that: (1) users can authenticate in any Region, (2) a user's tokens are valid in all Regions, (3) user profile updates in one Region propagate to others within seconds, and (4) if one Region fails, authentication continues seamlessly in remaining Regions.

Which architecture achieves this?

A. Create separate Cognito user pools in each Region. Use DynamoDB Global Tables to replicate user data. Build a custom pre-authentication Lambda trigger that synchronizes user records between user pools.

B. Create a Cognito user pool in the primary Region and use Route 53 failover routing to redirect authentication requests to a backup Region with a cold standby user pool restored from periodic exports.

C. Use a Cognito user pool in a single Region behind a CloudFront distribution with origin failover. Cache tokens at CloudFront edge locations.

D. Create separate Cognito user pools in each Region. Implement a custom user migration Lambda trigger in each pool. Use a global DynamoDB table as the authoritative user store. On first authentication in any Region, the migration trigger creates the user in that Region's pool from the global store. Use a post-confirmation trigger to update the global store with profile changes.

**Correct Answer: D**

**Explanation:** Cognito user pools don't natively support cross-Region replication. The best approach uses separate user pools per Region with a DynamoDB Global Table as the authoritative user store. The user migration Lambda trigger enables lazy migration—when a user first authenticates in a new Region, the trigger creates the user locally from the global store. Post-confirmation and post-authentication triggers propagate profile updates to the global store, which DynamoDB Global Tables replicates across Regions within seconds. Route 53 latency-based routing directs users to the nearest Region. Option A's pre-authentication trigger would be too slow for synchronization. Option B has a cold standby with data loss risk. Option C doesn't solve the single-Region failure problem since the origin is still in one Region.

---

### Question 24

A company uses Amazon Cognito for a customer-facing application. They need to implement step-up authentication where: (1) viewing account information requires standard authentication, (2) transferring funds requires re-authentication with MFA within the last 5 minutes, and (3) changing security settings requires re-authentication with a hardware security key.

Which implementation correctly handles step-up authentication?

A. Use Cognito's custom authentication flow with DefineAuthChallenge to implement step-up logic. Track authentication timestamps and methods in the access token using Pre Token Generation triggers. The application validates the `auth_time` and `amr` (authentication methods references) claims in the token before allowing sensitive operations. Force re-authentication with specific challenge types for elevated operations.

B. Create three separate Cognito app clients with different authentication requirements. Redirect users to the appropriate app client based on the operation they're attempting.

C. Use API Gateway with three different Cognito authorizers, each configured with different token validation scopes. Require different token types for each operation level.

D. Implement all step-up logic in the frontend application. Use JavaScript to check if MFA was completed recently before calling protected API endpoints.

**Correct Answer: A**

**Explanation:** Custom authentication flows with DefineAuthChallenge provide full control over the authentication step-up process. The Pre Token Generation trigger adds `auth_time` and authentication method (`amr`) claims to tokens. For standard operations, the application checks the valid token. For fund transfers, it verifies that MFA was completed within the last 5 minutes by checking `auth_time` and `amr` claims—if not, it initiates a re-authentication flow requiring MFA. For security changes, it requires re-authentication with a FIDO2/WebAuthn challenge (hardware key). Option B disrupts the user experience by switching app clients. Option C doesn't support step-up within a single session. Option D puts security logic in the client, which can be bypassed.

---

### Question 25

A media streaming company needs to provide time-limited access to premium video content stored in S3. Authenticated users (via Cognito) should access content through CloudFront. Free-tier users get access to trailers only. Premium users get full content access. The solution must prevent URL sharing and direct S3 access.

Which architecture provides secure, tiered content delivery?

A. Use Cognito user pool groups (free, premium) to categorize users. After authentication, a Lambda function generates CloudFront signed cookies scoped to the user's tier—free users get cookies allowing access to the `/trailers/*` path, premium users get cookies for `/*`. Set cookie expiration to match the session duration. Configure the S3 bucket as a CloudFront origin with an Origin Access Control (OAC) policy preventing direct access.

B. Generate pre-signed S3 URLs for each video request. Use short URL expiration times. Differentiate access by generating URLs for different S3 prefixes based on user tier.

C. Use S3 bucket policies with Cognito identity pool role conditions. Allow direct S3 access with IAM role-based path restrictions per tier.

D. Configure CloudFront with Cognito as a custom origin. Use Lambda@Edge for authentication checks on every request.

**Correct Answer: A**

**Explanation:** CloudFront signed cookies provide tier-based access without generating individual signed URLs for each video. The Cognito user pool groups identify the user's tier, and a Lambda function (called after authentication) generates cookies with the appropriate path policy. Free users' cookies only grant access to the `/trailers/*` path pattern, while premium users access everything. OAC prevents direct S3 access, ensuring all content goes through CloudFront. Cookie-based access prevents simple URL sharing since the cookies are tied to the browser session. Option B generates individual URLs per video, which is expensive at scale and URLs can be shared. Option C allows direct S3 access, bypassing CloudFront caching and CDN benefits. Option D processes authentication on every request, adding latency and cost.

---

### Question 26

A logistics company has a fleet of IoT devices in delivery trucks. Each device needs to authenticate to AWS IoT Core and also call Lambda functions directly (bypassing IoT Core for batch operations). The company wants a unified identity model where each truck has a unique identity. Device certificates are already provisioned via AWS IoT Core.

Which approach provides the MOST efficient unified identity?

A. Use AWS IoT Core certificate-based authentication for MQTT connections. For Lambda access, configure a Cognito identity pool with an IoT Core certificate-authenticated identity provider. Map IoT certificates to Cognito identities and assume an IAM role with permissions to invoke specific Lambda functions.

B. Create IAM users for each truck with access keys stored on the device. Use IAM for both IoT Core and Lambda access.

C. Use IoT Core for MQTT. Create separate X.509 certificates for each truck to assume IAM roles via a custom STS federation endpoint.

D. Deploy a fleet of API Gateway endpoints with mutual TLS using the same device certificates. Route all Lambda invocations through API Gateway.

**Correct Answer: A**

**Explanation:** Cognito identity pools support IoT Core as an authentication provider through the `cognito-identity.amazonaws.com` enhanced authentication flow. IoT devices authenticated via X.509 certificates to IoT Core can obtain Cognito identity pool credentials. This provides temporary IAM credentials scoped to invoke specific Lambda functions, using the same identity (IoT certificate) for both MQTT and AWS API calls. Option B creates long-lived credentials on devices—a security risk if trucks are stolen. Option C requires building a custom STS federation endpoint. Option D adds unnecessary API Gateway infrastructure and doesn't leverage existing IoT certificates efficiently.

---

### Question 27

An organization uses AWS Organizations with 200 accounts. They recently migrated to IAM Identity Center from per-account SAML federation. Post-migration, several accounts still have orphaned IAM SAML providers and unused IAM roles that were created for the old federation. The security team wants to identify and clean up these resources across all accounts.

Which approach is MOST efficient for identifying and cleaning up orphaned federation resources?

A. Deploy an AWS Config organizational rule that detects IAM SAML providers and IAM roles with SAML-based trust policies. Create an SSM Automation document that cross-references these resources against IAM Identity Center assignments. Run the automation across all accounts to identify orphaned resources and generate a cleanup report. After security team review, execute the cleanup phase.

B. Write a Python script that uses boto3 to assume a role in each account, list SAML providers and roles, and compare against Identity Center assignments. Run the script on an EC2 instance.

C. Manually review each account's IAM console and delete unused SAML providers and roles.

D. Use IAM Access Analyzer to identify unused roles across all accounts and delete them automatically.

**Correct Answer: A**

**Explanation:** An organizational AWS Config rule provides automated, continuous detection of IAM SAML providers and SAML-trusting IAM roles across all 200 accounts. The SSM Automation document can cross-reference these findings against active IAM Identity Center assignments, identifying truly orphaned resources. The two-phase approach (report then cleanup) ensures safety. Option B works but is a one-time script without ongoing detection, and requires managing the execution environment. Option C is impractical at 200 accounts. Option D only identifies unused roles—IAM Access Analyzer doesn't detect orphaned SAML providers, and automatic deletion without review is risky.

---

### Question 28

A SaaS platform needs to allow customers to configure their own identity providers for SSO into the platform. The platform must support: (1) self-service IdP configuration by customer administrators, (2) both SAML 2.0 and OIDC protocols, (3) just-in-time user provisioning, (4) organization-level isolation, and (5) the ability for a single user to belong to multiple organizations.

Which architecture handles this?

A. Create a Cognito user pool for the platform. Build a self-service admin portal that uses the Cognito `CreateIdentityProvider` API to let customer admins configure their SAML/OIDC providers. Use a Pre Sign-Up Lambda trigger for JIT provisioning that creates the user and assigns them to the correct Cognito group (organization). Support multi-organization membership through multiple group assignments.

B. Create a separate Cognito user pool per customer organization. Provide APIs for customer admins to configure their IdP in their dedicated pool. Handle cross-organization membership through a central lookup DynamoDB table.

C. Use IAM Identity Center with self-service IdP registration through a custom portal. Create separate Identity Center instances per organization.

D. Build a fully custom SAML/OIDC service on ECS using open-source libraries. Store IdP configurations in DynamoDB.

**Correct Answer: A**

**Explanation:** A single Cognito user pool supports multiple SAML and OIDC identity providers, and the Cognito APIs allow programmatic IdP management, enabling self-service configuration by customer admins. JIT provisioning via Pre Sign-Up Lambda creates users on first login. Cognito groups model organizations, and a user can belong to multiple groups. A Pre Token Generation trigger can include the active organization context in tokens. Option B creates operational overhead with hundreds of user pools and makes multi-organization membership complex. Option C is for workforce, not customer-facing, and you can't have multiple Identity Center instances per Organization. Option D requires building and maintaining a complete identity platform.

---

### Question 29

A financial company has an existing REST API running on ECS behind an ALB. They need to add authentication that supports: (1) machine-to-machine authentication for partner systems using client credentials, (2) user authentication for the web app using authorization code flow with PKCE, and (3) both flows must produce JWT tokens that API Gateway validates. The company wants to migrate the API from ALB to API Gateway.

Which Cognito configuration supports both authentication flows?

A. Create a Cognito user pool with a resource server defining API scopes (e.g., `api/read`, `api/write`). Create two app clients: one configured for the client credentials grant (for M2M) and another configured for the authorization code grant with PKCE (for web users). Configure API Gateway with a Cognito authorizer that validates the JWT from either app client.

B. Create two separate Cognito user pools: one for M2M authentication and one for web user authentication. Configure API Gateway with two different Cognito authorizers.

C. Use Cognito identity pools for both flows. Configure the identity pool with developer-authenticated identities for M2M and user pool federation for web users.

D. Use a Lambda authorizer that manually validates JWTs from Cognito. Handle client credentials validation separately against a DynamoDB table of API keys.

**Correct Answer: A**

**Explanation:** A single Cognito user pool supports both the client credentials grant (for M2M) and the authorization code grant with PKCE (for web users) through separate app clients. The resource server defines scopes that the client credentials grant uses. Both app clients produce JWTs from the same user pool, so a single Cognito authorizer in API Gateway validates both. The M2M app client has a client secret and uses the `client_credentials` grant type; the web app client uses the `code` grant with PKCE. Option B unnecessarily duplicates the user pool. Option C doesn't support client credentials flow. Option D builds custom validation when Cognito handles it natively.

---

### Question 30

A company is implementing a microservices architecture where 15 services need to authenticate each other. Each service runs on ECS Fargate. The security team requires: (1) mutual authentication between services, (2) no long-lived credentials, (3) identity verification per request, and (4) centralized certificate management.

Which architecture BEST provides service-to-service identity?

A. Deploy AWS App Mesh with mutual TLS (mTLS) enabled. Use AWS Private CA to issue short-lived certificates to each service's Envoy proxy. App Mesh manages certificate rotation automatically. Services are identified by their certificate's Subject Alternative Name (SAN).

B. Use Cognito user pools with the client credentials grant for M2M authentication. Each service has its own app client with a secret.

C. Create IAM roles for each ECS task and use SigV4 signing for all inter-service requests.

D. Deploy a service mesh with Consul on ECS. Manage certificates manually with Let's Encrypt.

**Correct Answer: A**

**Explanation:** AWS App Mesh with mutual TLS provides mutual authentication between services where both client and server present certificates. AWS Private CA (ACM PCA) issues short-lived certificates that App Mesh's Envoy proxies manage, including automatic rotation—no long-lived credentials. Each service's identity is established by its certificate's SAN, enabling per-request verification. This is transparent to application code. Option B uses Cognito for service identity, which is designed for user/client applications, not service meshes. Option C provides request signing but not mutual authentication. Option D requires managing Consul infrastructure and manual certificate lifecycle management.

---

### Question 31

A company needs to secure API Gateway endpoints with fine-grained access control. The API serves both internal employees (authenticated via IAM Identity Center) and external developers (authenticated via API keys). Internal employees should access all endpoints, while external developers should only access `/public/*` endpoints. Rate limiting must differ: 10,000 requests/day for external developers, unlimited for internal.

Which configuration achieves this?

A. Create a Cognito authorizer for internal employees using the Cognito user pool federated with IAM Identity Center's OIDC endpoint. Create a usage plan with API keys for external developers. Use resource policies on API Gateway to restrict API key access to `/public/*` paths. Configure the usage plan with a 10,000/day quota.

B. Create two separate API Gateway stages: one for internal with IAM authorization and one for external with API keys. Deploy the same API to both stages with different resource configurations.

C. Use a Lambda authorizer that checks the caller's identity type. For internal users, validate the IAM Identity Center token and allow all paths. For external developers, validate the API key and restrict to `/public/*`. Return the appropriate usage plan identifier.

D. Use WAF rules on API Gateway to restrict path access based on the source IP address. Internal employees use corporate IP ranges, external developers use other IPs.

**Correct Answer: C**

**Explanation:** A Lambda authorizer provides the flexibility to handle both authentication methods (IAM Identity Center tokens and API keys) in a single API. The authorizer determines the caller type, validates accordingly, returns an IAM policy allowing appropriate paths (all paths for internal, only `/public/*` for external), and includes a `usageIdentifierKey` to link external developers to the rate-limited usage plan. Option A mixes authorizer types in a way that requires complex API configuration. Option B duplicates API infrastructure. Option D relies on IP addresses, which is unreliable for identity-based access control.

---

### Question 32

A financial institution needs to implement delegated administration for IAM Identity Center. Requirements: (1) the security team manages permission sets and account assignments, (2) the platform team manages user/group provisioning from the IdP, (3) application teams can view their own account assignments but not modify them, and (4) no team should have access to the management account.

Which implementation achieves this separation of duties?

A. Designate a security account as the IAM Identity Center delegated administrator. Create IAM roles in the security account: one for the security team with `sso:*PermissionSet*` and `sso:*AccountAssignment*` permissions, one for the platform team with `identitystore:*` and `sso:*InstanceAccessControlAttributeConfiguration*` permissions, and one for application teams with read-only `sso:Describe*` and `sso:List*` permissions. Use SCP to deny all IAM Identity Center actions in the management account except for the organization administrator.

B. Give the security team full access to IAM Identity Center in the management account. Use SCP to restrict other teams.

C. Create separate IAM Identity Center instances for each team's responsibility area.

D. Use AWS Control Tower with Account Factory to delegate account creation. Manage permission sets through Service Catalog portfolios.

**Correct Answer: A**

**Explanation:** IAM Identity Center supports delegated administration, allowing a member account (not the management account) to manage Identity Center. By creating role-based access in the delegated administrator account, you separate duties: the security team manages permission sets and assignments, the platform team manages identity provisioning (users, groups, SCIM configuration), and application teams have read-only visibility. The SCP preventing Identity Center actions in the management account ensures no team operates there. Option B violates the management account access restriction. Option C isn't possible—only one Identity Center instance per Organization. Option D addresses account creation, not Identity Center administration.

---

### Question 33

A company is implementing Cognito user pools for a web application. They need to support a complex password policy with: (1) minimum 12 characters, (2) no reuse of the last 10 passwords, (3) passwords expire every 90 days, (4) account lockout after 5 failed attempts for 30 minutes, and (5) passwords cannot contain the user's name or email.

Which approach implements ALL requirements?

A. Configure the Cognito user pool's native password policy for minimum length and complexity. Implement password history checking and expiration via a Pre Authentication Lambda trigger that queries a DynamoDB table tracking password hashes and change dates. Use a Pre Sign-Up Lambda trigger to verify passwords don't contain the username/email. Configure Cognito's advanced security features for adaptive account lockout.

B. Use Cognito's built-in password policy settings which support all these requirements natively without additional configuration.

C. Replace Cognito with a custom authentication backend on ECS that enforces all password policies. Use Cognito only for token issuance.

D. Use Cognito with a custom authentication challenge flow that implements all password checks. Store password state in Cognito custom attributes.

**Correct Answer: A**

**Explanation:** Cognito user pools natively support password minimum length and complexity requirements, but not password history, password expiration, or custom content restrictions. These additional requirements need Lambda triggers: Pre Authentication checks the DynamoDB password history table and enforces expiration, Pre Sign-Up validates the password doesn't contain user attributes. Cognito's advanced security features provide risk-based adaptive authentication including account lockout behavior. Option B is incorrect—Cognito doesn't natively support password history or expiration. Option C abandons Cognito's managed benefits. Option D stores sensitive password state in user attributes, which is insecure and visible to users.

---

### Question 34

An e-commerce company needs to implement social sign-in with Google for their mobile app, but they also need to: (1) progressively collect additional user information (shipping address, phone number) after initial sign-in, (2) allow users to add email/password as an additional sign-in method, (3) detect account takeover by comparing the current login's device and location with historical patterns, and (4) block sign-ins from embargoed countries.

Which Cognito configuration addresses ALL requirements?

A. Create a Cognito user pool with Google as a federated identity provider. Mark shipping address and phone as non-required attributes to enable progressive collection. Enable native username/password sign-up with account linking by email. Enable advanced security features for adaptive authentication (device tracking and anomaly detection). Use a Pre Authentication Lambda trigger that checks the source IP against a GeoIP database to block embargoed countries.

B. Create a Cognito identity pool for Google sign-in. Use DynamoDB to store progressive profile data. Build custom device fingerprinting with Lambda.

C. Use API Gateway with a Google OAuth backend. Manage all user state in RDS. Implement IP blocking at the WAF level.

D. Create a custom authentication service using Passport.js on ECS. Store user data in DocumentDB. Use CloudFront geo-restriction for country blocking.

**Correct Answer: A**

**Explanation:** Cognito user pools support federated (Google) and native (email/password) sign-in methods with automatic account linking. Non-required attributes enable progressive profile collection through the UpdateUserAttributes API. Advanced security features provide adaptive authentication with device tracking and user context analysis for account takeover detection. The Pre Authentication Lambda trigger enables custom country-based blocking using the request context (source IP). Option B uses identity pools, which don't support progressive profiles or advanced security. Option C requires building auth infrastructure. Option D requires managing a complete custom identity platform. WAF/CloudFront geo-restriction blocks all users from those countries, not just sign-in attempts.

---

### Question 35

A healthcare application needs to implement user consent management for HIPAA compliance. When users authenticate via Cognito, they must: (1) accept the latest terms of service before receiving tokens, (2) grant granular data access consent (e.g., sharing medical records with specific providers), (3) be able to revoke consent at any time, and (4) have all consent changes audit-logged.

Which architecture handles consent management with Cognito?

A. Use a Cognito Pre Token Generation Lambda trigger that checks a DynamoDB consent table before issuing tokens. If the user hasn't accepted the latest ToS version, the trigger throws an error that the application catches to display the consent flow. Store granular consent records in DynamoDB with timestamps. Use DynamoDB Streams to capture consent changes and forward them to Kinesis Data Firehose for audit storage in S3. The application checks consent at the API layer before returning data.

B. Store consent status in Cognito custom attributes. Check the attributes at each API call. Use CloudTrail to audit attribute changes.

C. Create a separate Cognito user pool group for consented users. Move users between groups as consent changes. Use Cognito triggers to log changes.

D. Implement consent management entirely in the frontend application. Store consent in browser local storage and send it as a custom header with each API request.

**Correct Answer: A**

**Explanation:** The Pre Token Generation trigger is the ideal hook for enforcing consent—it executes before tokens are issued, blocking access until ToS is accepted. DynamoDB provides a flexible schema for granular consent records with per-provider, per-data-type consent tracking. DynamoDB Streams → Kinesis Data Firehose → S3 creates a tamper-resistant audit trail of all consent changes. Consent revocation is immediate—updating the DynamoDB record causes the next token generation to reflect the revoked consent. Option B limits consent to flat custom attributes (10 max mutable), which can't model granular provider-level consent. Option C uses group membership as a binary consent flag, which lacks granularity. Option D puts consent enforcement on the client side, which is unacceptable for HIPAA compliance.

---

### Question 36

A company needs to implement a secure API token exchange service. External partners authenticate with their own OIDC providers and receive tokens. These tokens must be exchanged for tokens that the company's internal microservices accept. The exchange must: (1) validate the external token, (2) map external claims to internal claims, (3) add company-specific authorization scopes, and (4) issue a new short-lived JWT.

Which architecture provides a secure token exchange?

A. Use an Amazon Cognito user pool configured with each partner's OIDC provider. When partners authenticate, Cognito validates the external token and issues a Cognito JWT. Use a Pre Token Generation Lambda trigger to map external claims to internal claims and add company-specific scopes. Set token expiration to 15 minutes. Internal microservices validate the Cognito JWT.

B. Build a custom token exchange endpoint on API Gateway + Lambda that validates external JWTs against each partner's JWKS endpoint, transforms claims, and signs a new JWT using a private key stored in KMS.

C. Use IAM Identity Center to federate with partner OIDC providers. Exchange the Identity Center token for temporary STS credentials that internal services validate.

D. Deploy Keycloak on ECS as a centralized identity broker. Configure each partner's OIDC provider in Keycloak and use token exchange (RFC 8693).

**Correct Answer: A**

**Explanation:** Cognito user pools natively handle OIDC token validation when configured with external providers. The Pre Token Generation trigger enables claim transformation—mapping external partner claims to internal claim names and adding company-specific scopes (custom claims). The resulting Cognito JWT is short-lived and valid for internal microservices. This is a managed solution with no custom infrastructure. Option B works but requires building custom JWT handling, key management, and token signing—significant security-sensitive custom code. Option C is for workforce access, not API token exchange. Option D requires managing Keycloak infrastructure with high availability.

---

### Question 37

An organization is implementing a zero-trust security model. Every request to internal applications must be authenticated and authorized regardless of network location. They need: (1) device posture verification (managed device, up-to-date patches), (2) user identity verification via corporate IdP, (3) continuous authorization based on real-time risk signals, and (4) private access to internal applications without a VPN.

Which AWS architecture supports this zero-trust model?

A. Deploy AWS Verified Access with the corporate IdP for user identity verification and a device management solution (e.g., CrowdStrike, Jamf) as a trust provider for device posture. Configure Verified Access policies using Cedar that evaluate both user identity claims and device posture signals. Verified Access provides private application access without VPN through an endpoint that evaluates policy on every request.

B. Use Client VPN with certificate-based authentication. Deploy a Lambda function that checks device posture before allowing VPN connection. Use IAM roles for application access.

C. Use CloudFront with a Lambda@Edge authorizer that validates user tokens and checks device posture headers. Configure origin as internal ALBs.

D. Deploy AWS AppStream 2.0 for all application access. Authenticate users via Cognito. Only allow connections from managed devices based on IP allowlists.

**Correct Answer: A**

**Explanation:** AWS Verified Access is purpose-built for zero-trust application access. It integrates with corporate IdPs for user identity and device management solutions for device posture verification. Cedar policies evaluate both user and device trust signals for every request, providing continuous authorization. Applications are accessed through Verified Access endpoints without requiring a VPN. Option B uses VPN, which contradicts the zero-trust VPN-less access requirement. Option C relies on headers for device posture, which can be spoofed. Option D forces users through a virtual desktop, which degrades user experience and doesn't evaluate device posture per-request.

---

### Question 38

A company acquired a SaaS application that uses Auth0 for customer identity. They want to integrate it with their AWS environment where Cognito is the standard. During a 6-month transition: (1) existing customers must continue using Auth0, (2) new customers should be created in Cognito, (3) both identity systems must grant access to the same AWS resources, and (4) eventually all customers must be migrated to Cognito.

Which migration strategy minimizes customer disruption?

A. Configure Auth0 as a SAML/OIDC identity provider in the Cognito user pool. Existing customers authenticate via Auth0, which federates to Cognito. New customers sign up directly in Cognito. Use a custom attribute to track migration status. Implement a User Migration Lambda trigger that captures Auth0 user credentials on next login and creates native Cognito users. Over time, users transparently migrate from Auth0 to native Cognito authentication.

B. Run both Auth0 and Cognito in parallel with separate token validation. Build a token normalization layer that converts Auth0 tokens to a format compatible with Cognito-validated APIs.

C. Immediately migrate all Auth0 users to Cognito by exporting user data and forcing password resets. Redirect all authentication to Cognito.

D. Keep Auth0 permanently for existing customers. Use a custom API Gateway authorizer that validates tokens from both systems.

**Correct Answer: A**

**Explanation:** Federated Auth0 into Cognito as an external IdP provides seamless access for existing customers through their familiar Auth0 login. New customers go directly to Cognito. The User Migration Lambda trigger enables transparent migration: when an existing Auth0 user logs in through the federated flow, the trigger can capture their identity and create a native Cognito user, eventually allowing removal of the Auth0 dependency. All users access the same AWS resources through Cognito identity pool credentials. Option B requires maintaining two separate token validation systems. Option C forces password resets, causing major customer disruption. Option D doesn't meet the goal of full migration to Cognito.

---

### Question 39

A multinational company has separate AWS Organizations for each business unit (BU): BU-A has 50 accounts, BU-B has 30 accounts. Each BU has its own IAM Identity Center instance. The CEO mandates a unified access experience where employees can access accounts in both Organizations from a single portal. Each BU should retain administrative control over their own permission sets.

Which approach achieves unified access while maintaining BU autonomy?

A. Consolidate both Organizations under a single parent Organization. Migrate all accounts. Set up a single IAM Identity Center instance.

B. Keep both Organizations separate. Choose one Organization's IAM Identity Center as the primary portal. In the other Organization's accounts, create IAM roles that trust the primary Organization's Identity Center roles. Users access the primary portal and use role chaining to reach the other Organization's accounts.

C. Deploy a custom web portal that integrates with both IAM Identity Center instances via their OIDC endpoints. The portal authenticates the user once with the corporate IdP and presents a unified list of accounts and roles from both Identity Center instances. Users click to initiate SSO to either Organization.

D. Merge the two Organizations into one and create OUs for each BU. Delegate IAM Identity Center permission set management to each BU's security team using delegated administrator accounts.

**Correct Answer: C**

**Explanation:** Since each Organization can only have one IAM Identity Center instance, and combining Organizations is disruptive, a custom portal that integrates with both Identity Center instances provides the unified experience without organizational restructuring. The portal authenticates users via the shared corporate IdP and presents a consolidated view of accounts across both Organizations. Each BU retains full administrative control over their own Identity Center instance, permission sets, and account assignments. Option A/D requires Organization consolidation, which is highly disruptive and may not be desired. Option B requires role chaining, which adds complexity and session duration limitations (chained roles limited to 1 hour).

---

### Question 40

A company needs to implement identity-based networking policies. When developers access development resources, their network access should be restricted to development VPCs. When they access production resources (during an approved change window), their network should be restricted to production VPCs. This should be enforced automatically based on the IAM Identity Center session, not manual network configuration.

Which architecture implements identity-based network segmentation?

A. Use AWS Verified Access with trust providers (IAM Identity Center for identity, device management for posture). Define Verified Access policies that evaluate the user's role/group and the current time (for change windows). Create separate Verified Access endpoints for development and production applications in their respective VPCs. The policies enforce that developers can only access production endpoints during approved change windows.

B. Use VPC security groups with IAM conditions that restrict access based on the source IAM principal. Dynamically update security group rules when developers change their session.

C. Deploy Network Firewall with rules that inspect HTTP headers for IAM session information and filter based on identity.

D. Use AWS Client VPN with separate VPN endpoints for development and production. Control access through IAM Identity Center-based Active Directory group membership.

**Correct Answer: A**

**Explanation:** AWS Verified Access integrates directly with IAM Identity Center and evaluates Cedar policies on every request. Policies can include conditions on user groups, attributes, and time-based rules (for change windows). Separate Verified Access endpoints for dev and prod VPCs enforce network segmentation based on identity. Developers accessing production endpoints outside approved change windows are denied by policy. Option B is not possible—security groups don't support IAM principal conditions. Option C can't reliably identify IAM sessions from network traffic. Option D requires managing separate VPN connections and doesn't enforce time-based access dynamically.

---

### Question 41

A company needs to implement a customer identity verification flow for a financial application. New users sign up with email/password, then must complete: (1) email verification, (2) phone number verification via SMS OTP, (3) government ID document verification, and (4) liveness detection (selfie matching against ID photo). Only after all steps are complete should the user gain full access.

Which architecture provides this verification workflow?

A. Use a Cognito user pool for email/password sign-up with email auto-verification. Configure SMS-based MFA for phone verification. Use a Post Confirmation Lambda trigger to initiate a Step Functions workflow that orchestrates document verification (via Amazon Textract for ID parsing and Amazon Rekognition for facial comparison). Store verification status in DynamoDB. Use Cognito custom attributes to track verification completion. The Pre Token Generation trigger checks verification status and includes a `verification_complete` claim—the application restricts features based on this claim.

B. Build the entire identity verification flow using a custom solution on ECS. Don't use Cognito since it can't handle all steps.

C. Use Cognito with a custom authentication flow that implements all verification steps as challenges in sequence. Block token issuance until all challenges pass.

D. Use a third-party identity verification service (Jumio, Onfido) and integrate it with API Gateway. Use Cognito only for basic authentication after verification is complete elsewhere.

**Correct Answer: A**

**Explanation:** This architecture leverages Cognito for core identity management (sign-up, email verification, SMS MFA) and extends it with AWS AI services for advanced verification. The Step Functions workflow orchestrates the multi-step verification process: Textract extracts data from government IDs, Rekognition compares the selfie with the ID photo. Verification status in DynamoDB is reflected in tokens via the Pre Token Generation trigger, enabling feature gating in the application. Option B abandons managed identity services unnecessarily. Option C would create an extremely long authentication flow and poor user experience. Option D separates identity and verification unnecessarily and requires users to navigate two different systems.

---

### Question 42

A company provides a data analytics platform where customers query data using SQL through a web interface. Each customer has a Cognito user pool identity. Queries execute in Amazon Athena, and results are stored in customer-specific S3 prefixes. The platform must ensure: (1) customers can only query their own datasets in the Glue Data Catalog, (2) query results are stored in the correct customer prefix, and (3) temporary credentials expire after 1 hour.

Which architecture provides secure, per-customer Athena access?

A. Create a Cognito identity pool linked to the user pool. Define an authenticated IAM role with policy variables using `${cognito-identity.amazonaws.com:sub}` for Lake Formation data permissions and S3 result location. Configure Athena workgroups per customer with output location set to the customer-specific S3 prefix. Use Lake Formation to grant table permissions based on the IAM role's session tags derived from the Cognito identity.

B. Create a backend Lambda function that assumes a per-customer IAM role (one role per customer) and executes Athena queries. Return results to the user.

C. Give all customers the same IAM role with broad Athena and S3 access. Implement data isolation at the application layer by filtering SQL queries.

D. Create IAM users for each customer with inline policies restricting their Athena and S3 access.

**Correct Answer: A**

**Explanation:** The Cognito identity pool provides temporary credentials (1-hour default) with IAM role policy variables for per-customer isolation. Lake Formation integrates with the session tags derived from the Cognito identity to enforce data catalog permissions at the table/column level. Athena workgroups enforce the query result output location per customer. This is a fully managed, scalable approach without per-customer IAM resources. Option B creates a role per customer, which doesn't scale and hits IAM role limits. Option C provides no real data isolation—application-layer filtering can be bypassed. Option D creates long-lived credentials that violate the temporary credential requirement.

---

### Question 43

A company has been using IAM Identity Center with permission sets for 2 years. They now have 85 permission sets across 100 accounts, and management of assignments has become unwieldy. The security team frequently receives requests to modify permission sets, but changes affect multiple accounts unpredictably. They need to improve permission set lifecycle management.

Which approach provides the MOST operationally efficient improvement?

A. Implement permission set-as-code using CloudFormation (or Terraform) stored in a Git repository. Define permission sets, their IAM policies, and account/group assignments declaratively. Use a CI/CD pipeline that requires security team approval before applying changes. Implement a pre-deployment validation step that shows which accounts and users will be affected by the change. Use separate stacks for permission set definitions and assignments.

B. Reduce the number of permission sets by creating a few broad sets (ReadOnly, PowerUser, Admin) and assigning them widely.

C. Use AWS Service Catalog to create permission set products that teams can self-service deploy.

D. Switch from permission sets to per-account IAM roles managed by CloudFormation StackSets.

**Correct Answer: A**

**Explanation:** Infrastructure-as-code for permission sets provides version control, peer review, change tracking, and reproducibility. The CI/CD pipeline with approval gates ensures the security team reviews all changes. The pre-deployment impact analysis shows which accounts and users are affected before applying changes, eliminating surprises. Separating permission set definitions from assignments allows independent modification. Option B reduces granularity, violating least privilege. Option C doesn't address the core lifecycle management problem. Option D abandons the centralized management benefits of IAM Identity Center.

---

### Question 44

An organization's Cognito user pool has grown to 5 million users. They're experiencing: (1) slow ListUsers queries for admin search, (2) high costs from advanced security features at scale, (3) token generation latency spikes during peak hours. They need to optimize performance and cost without changing the authentication flow.

Which combination of optimizations should they implement? (Choose TWO.)

A. Enable Cognito user pool search optimization by creating custom attribute indexes. Migrate admin search workloads to use an Amazon OpenSearch Service cluster that syncs with Cognito via a Post Confirmation/Post Authentication Lambda trigger and DynamoDB Streams.

B. Review advanced security feature usage and disable features that aren't providing value (e.g., if compromised credential checking is sufficient, disable full adaptive authentication for non-sensitive operations). Use advanced security only for user pools handling sensitive operations.

C. Replace Cognito with a self-managed Keycloak cluster on ECS with Aurora PostgreSQL for better query performance.

D. Create multiple Cognito user pools and shard users across them alphabetically to reduce per-pool size.

E. Enable Cognito's built-in caching layer to reduce token generation latency during peak hours.

**Correct Answer: A, B**

**Explanation:** (A) Cognito's ListUsers API has limited query capabilities at scale. Offloading admin search to OpenSearch (synced via Lambda triggers) provides fast, flexible search across millions of users without hitting Cognito API limits. (B) Advanced security features charge per monthly active user and add processing overhead to each authentication. Reviewing and disabling unnecessary features for non-sensitive workloads reduces both cost and latency. Option C requires managing identity infrastructure, defeating the purpose of a managed service. Option D fragments the user base, breaking features like global sign-out and complicating the architecture. Option E doesn't exist as a Cognito feature.

---

### Question 45

A company implemented SAML federation with IAM Identity Center 6 months ago. The security team's audit reveals that: (1) 40% of permission sets are overly permissive, (2) several users have permission set assignments they haven't used in 90 days, and (3) some permission sets include wildcard actions on sensitive services. They need a systematic approach to right-size permissions.

Which approach provides the MOST effective permission right-sizing?

A. Use IAM Access Analyzer policy generation to analyze CloudTrail logs for each permission set's assumed role across all accounts. Generate least-privilege policies based on actual usage over 90 days. Compare generated policies with current permission sets. Use the IAM Identity Center APIs to update permission sets with the right-sized policies. Implement unused access findings from IAM Access Analyzer to identify and remove stale user-to-permission-set assignments.

B. Replace all permission sets with AWS-managed policies that follow AWS's predefined permission boundaries.

C. Ask each team to submit their required permissions. Manually update permission sets based on their responses.

D. Enable AWS CloudTrail Insights to detect unusual permission usage patterns and manually adjust permission sets based on insights.

**Correct Answer: A**

**Explanation:** IAM Access Analyzer's policy generation feature analyzes CloudTrail logs to determine what API calls were actually made by each role. For IAM Identity Center, this means analyzing the roles assumed via permission sets to generate least-privilege policies reflecting actual usage. The unused access findings feature identifies permission set assignments where users haven't accessed the account, enabling cleanup of stale assignments. This is a data-driven, systematic approach. Option B replaces custom permissions with generic ones, likely too broad or too narrow. Option C relies on self-reporting, which is inaccurate. Option D provides anomaly detection but not systematic right-sizing.

---

### Question 46

A company's mobile application uses Cognito user pools and identity pools. During a recent incident, they discovered that compromised refresh tokens allowed an attacker to maintain access for 30 days (the default refresh token lifetime). They need to improve their token security posture.

Which combination of changes MOST effectively mitigates token compromise risks? (Choose TWO.)

A. Reduce the refresh token expiration to the minimum acceptable for user experience (e.g., 1 day). Enable token revocation on the Cognito user pool, which allows the `GlobalSignOut` and `AdminUserGlobalSignOut` APIs to invalidate refresh tokens immediately.

B. Enable Cognito advanced security features with adaptive authentication. Configure automatic risk response to block high-risk authentication events and challenge medium-risk events, which detects and prevents use of compromised tokens from unfamiliar devices or locations.

C. Implement client-side token encryption using a key stored in the mobile app's keychain/keystore.

D. Switch from Cognito tokens to IAM access keys for the mobile application.

E. Disable refresh tokens entirely and require users to re-authenticate with username/password for every session.

**Correct Answer: A, B**

**Explanation:** (A) Reducing refresh token lifetime limits the window of exploitation. Enabling token revocation allows immediate invalidation of all refresh tokens for a compromised user via GlobalSignOut—without this feature, revoked tokens can still be exchanged until they expire. (B) Advanced security's adaptive authentication detects anomalous token usage (new device, unusual location, impossible travel) and can block or challenge these attempts, preventing attackers from using stolen tokens from different contexts. Option C encrypts tokens on the device but doesn't prevent use of stolen tokens from another device. Option D introduces long-lived credentials, which is worse. Option E destroys usability.

---

### Question 47

A company uses IAM Identity Center with 60 permission sets. They need to implement a self-service access request system where: (1) users can browse available permission sets, (2) users request temporary access to specific accounts, (3) requests require manager approval, (4) approved access is automatically provisioned and automatically revoked after the requested duration, and (5) all requests are audited.

Which architecture implements this self-service system?

A. Build a web application using API Gateway and Lambda that reads available permission sets from IAM Identity Center APIs. Users submit access requests stored in DynamoDB. A Step Functions workflow sends approval notifications to managers via SES/SNS. On approval, a Lambda function calls the Identity Center `CreateAccountAssignment` API. An EventBridge scheduled rule triggers a Lambda function that checks DynamoDB for expired assignments and calls `DeleteAccountAssignment`. CloudTrail logs all API calls.

B. Use AWS Service Catalog to create products for each permission set. Users request products with approval workflows. Service Catalog handles provisioning and deprovisioning.

C. Use AWS RAM to share permission sets as resources. Users request access through RAM invitation workflows.

D. Build a Slack bot that accepts access requests and uses a Lambda backend to provision access after emoji-based manager approval.

**Correct Answer: A**

**Explanation:** This architecture leverages IAM Identity Center APIs for programmatic assignment management, Step Functions for the approval workflow, DynamoDB for request state management, and EventBridge for time-based automatic deprovisioning. The solution provides complete self-service capabilities with proper approval chains and automatic cleanup. CloudTrail provides the audit trail. Option B doesn't natively map to IAM Identity Center permission sets. Option C isn't how permission sets work—RAM shares other AWS resources. Option D lacks proper audit trails and formal approval processes.

---

### Question 48

A company is implementing passwordless authentication for their customer portal. They want to support: (1) FIDO2/WebAuthn for desktop browsers, (2) biometric authentication (Touch ID/Face ID) for mobile apps, (3) email magic links as a fallback, and (4) a smooth enrollment flow that doesn't require a password at any point.

Which Amazon Cognito configuration supports fully passwordless authentication?

A. Create a Cognito user pool with custom authentication challenge flows. Implement DefineAuthChallenge, CreateAuthChallenge, and VerifyAuthChallengeResponse Lambda triggers that support multiple passwordless methods. For FIDO2/WebAuthn, use the CreateAuthChallenge trigger to generate a challenge and VerifyAuthChallengeResponse to validate the authenticator signature against registered credentials stored in DynamoDB. For biometric, leverage the device's platform authenticator through the same WebAuthn flow. For magic links, generate a signed token sent via SES and validate it in VerifyAuthChallengeResponse. Set user pool to allow sign-up without password using a custom required attribute.

B. Use Cognito's built-in FIDO2 support for desktop and mobile biometric. Configure Cognito to allow email OTP as a second factor.

C. Disable password-based authentication in Cognito and only allow federation with an external IdP that supports passwordless. Configure the external IdP with FIDO2 and magic link support.

D. Use API Gateway with a custom Lambda authorizer that handles all authentication. Don't use Cognito for authentication, only for token management.

**Correct Answer: A**

**Explanation:** Cognito custom authentication flows provide the flexibility to implement any authentication method through Lambda triggers. FIDO2/WebAuthn challenges are generated and verified through the challenge triggers, with credential public keys stored externally (DynamoDB). Mobile biometric authentication uses the same WebAuthn protocol with platform authenticators (Touch ID/Face ID). Magic links are implemented as custom challenges with SES for delivery. The user pool is configured to not require a password during sign-up. Option B overstates Cognito's native FIDO2 support—it requires custom auth flows. Option C requires managing an external IdP. Option D fragments the identity system between custom auth and Cognito.

---

### Question 49

An enterprise's IAM Identity Center deployment has grown organically, resulting in: (1) overlapping permission sets with similar but slightly different policies, (2) users assigned to multiple permission sets per account causing confusion, (3) no naming convention for permission sets, and (4) no documentation of which permission set is intended for which use case.

Which approach provides the MOST sustainable governance improvement?

A. Conduct a permission set rationalization exercise: (1) Export all permission set policies and compare them using IAM Access Analyzer policy similarity scores. (2) Merge overlapping permission sets into canonical sets following a naming convention (e.g., `{BU}-{Function}-{AccessLevel}`). (3) Create a permission set catalog document stored alongside the IaC definitions. (4) Implement a CI/CD gate that validates naming conventions and checks for policy overlap before deploying new permission sets. (5) Remove duplicate assignments using the Identity Center APIs.

B. Delete all permission sets and start over with a clean taxonomy.

C. Add tags to all permission sets describing their purpose. Use tags to prevent overlapping assignments.

D. Restrict permission set creation to a single person who manually reviews all requests.

**Correct Answer: A**

**Explanation:** Systematic rationalization addresses the root causes: comparison identifies overlapping sets for consolidation, a naming convention provides clarity, a catalog provides documentation, and CI/CD gates prevent future sprawl. IAM Access Analyzer can compare policies for similarities. This approach is data-driven and sustainable. Option B causes massive disruption and loses institutional knowledge about why permission sets were created. Option C doesn't address the overlap problem—tags are informational only. Option D creates a bottleneck and doesn't fix existing issues.

---

### Question 50

A company is using Cognito for a healthcare application that processes PHI (Protected Health Information). An auditor requires proof that: (1) all authentication events are logged with user identity, (2) failed authentication attempts are tracked, (3) MFA bypass attempts are detected, and (4) user data modifications are logged with before/after values.

Which logging configuration provides comprehensive audit evidence?

A. Enable CloudTrail logging for all Cognito API calls (authentication, user management). Configure Cognito's advanced security features to log user-level authentication events to CloudWatch Logs, including risk assessments and failed attempts. Implement a Post Authentication Lambda trigger that logs authentication details to a dedicated audit DynamoDB table. Use a Pre Token Generation trigger to detect and log any MFA bypass attempts by checking the authentication event for MFA verification. Implement an AdminSetUserSettings CloudTrail event monitor for user data changes.

B. Enable CloudTrail for Cognito. Use the CloudTrail logs as the sole audit source for all events.

C. Configure Cognito to send all events to CloudWatch Logs. Use CloudWatch Insights for audit queries.

D. Build a custom logging middleware in the application that captures all authentication-related requests and responses.

**Correct Answer: A**

**Explanation:** A comprehensive audit requires multiple complementary logging mechanisms. CloudTrail captures all Cognito API calls (admin operations, user management). Advanced security features provide detailed per-user authentication event logs including risk scores and failure reasons. Lambda triggers provide application-level audit logging for business-specific requirements like MFA bypass detection. DynamoDB provides a queryable, immutable audit store. Option B misses user-level authentication details—CloudTrail logs API calls but not the full authentication context. Option C doesn't capture all required details. Option D only logs application-layer events, missing direct API access and admin operations.

---

### Question 51

A company has implemented Cognito user pools for three separate applications. They want to enable single sign-on between these applications so users authenticate once and can access all three without re-authenticating. All applications use the same corporate user base.

Which approach provides SSO across the three applications with MINIMAL changes?

A. Configure all three applications as app clients within the same Cognito user pool. Use the Cognito hosted UI with a shared domain. When a user authenticates for one application, the Cognito hosted UI maintains a session cookie. Subsequent applications redirect to the hosted UI, which recognizes the existing session and issues tokens for the new app client without requiring re-authentication.

B. Create a federation relationship between the three Cognito user pools using OIDC. Each user pool trusts the other two as identity providers.

C. Build a custom SSO service that issues a shared session token stored in a common cookie domain. Each application validates the shared token.

D. Merge all three applications into a single application with a single Cognito app client.

**Correct Answer: A**

**Explanation:** When multiple applications (app clients) share the same Cognito user pool and hosted UI domain, Cognito maintains a session cookie that enables SSO. After a user authenticates for the first application, navigating to another application (app client) triggers a redirect to the Cognito hosted UI, which detects the existing session and issues tokens for the new app client without showing a login screen. This requires minimal changes—just configuring app clients in the same user pool and using the hosted UI. Option B creates circular federation complexity. Option C requires building custom SSO infrastructure. Option D requires merging applications, which isn't realistic.

---

### Question 52

A company deployed IAM Identity Center 18 months ago but never properly configured attribute-based access control. They now want to migrate from role-based (permission set-based) access to ABAC to reduce the number of permission sets from 60 to 15. The IdP is Azure AD.

Which migration approach minimizes disruption?

A. Phase 1: Configure Azure AD to send department, team, and project SAML attributes. Map these to IAM Identity Center session tags. Phase 2: Create new ABAC-enabled permission sets that use `aws:PrincipalTag` conditions alongside existing permission sets. Phase 3: Assign users to new ABAC permission sets in parallel with existing ones, validating access is equivalent. Phase 4: Remove old role-based permission set assignments after validation. Phase 5: Delete orphaned permission sets.

B. Delete all current permission sets. Create 15 new ABAC-enabled permission sets. Assign all users to the new sets.

C. Modify existing permission sets in-place to add ABAC conditions. Update all 60 permission sets with tag-based conditions.

D. Keep existing permission sets. Layer ABAC on top using SCPs that restrict access based on session tags.

**Correct Answer: A**

**Explanation:** A phased parallel-run migration ensures continuity. First, configure attribute passing from Azure AD to ensure session tags are available. Then, create new ABAC permission sets alongside existing ones, allowing dual access paths during validation. Users can be gradually moved to ABAC permission sets after confirming equivalent access. Old permission sets are removed only after successful validation. Option B causes immediate disruption if any ABAC policy is misconfigured. Option C modifies live permission sets, risking breaking existing access patterns during the transition. Option D uses SCPs for authorization logic, which is not their intended purpose and creates confusing deny-based access control.

---

### Question 53

A company's Cognito user pool has 2 million users. They need to add a new required custom attribute `compliance_level` to all existing users. The attribute must be set based on the user's country (derived from their existing `locale` attribute). This must be completed within a maintenance window of 4 hours without disrupting active sessions.

Which approach completes this migration within the constraints?

A. Add `compliance_level` as a new custom attribute to the user pool schema (this is non-disruptive). Create a Step Functions workflow with a Map state that processes users in parallel batches. Use the Cognito `ListUsers` API with pagination to get all users, then `AdminUpdateUserAttributes` to set `compliance_level` based on the locale-to-compliance mapping. Configure the Map state with a concurrency limit to stay within Cognito API rate limits (use exponential backoff). Active sessions are unaffected as attribute changes don't invalidate existing tokens.

B. Export all users from Cognito using the CSV export feature. Add the compliance_level column. Re-import users using the CSV import job.

C. Create a new user pool with the compliance_level attribute. Migrate all users using the User Migration Lambda trigger. Switch the application to the new user pool.

D. Use a Lambda function triggered on every user's next login (Pre Authentication trigger) to set the compliance_level attribute. Wait until all users have logged in.

**Correct Answer: A**

**Explanation:** Adding a custom attribute to an existing Cognito user pool schema is a non-disruptive operation. Step Functions with a Map state provides scalable parallel processing with controlled concurrency. The `AdminUpdateUserAttributes` API updates user attributes without affecting active sessions or requiring re-authentication. With 2 million users and Cognito's API rate limits (~25 RPS for admin operations, with burst capacity), the migration completes within the 4-hour window. Option B's CSV import creates users but doesn't update existing ones—it would fail on duplicates. Option C requires a full migration to a new user pool, which is highly disruptive. Option D only updates users who log in—those who don't log in during the window are missed.

---

### Question 54

A company is migrating 500 applications from on-premises to AWS over 18 months. Currently, all applications authenticate against an on-premises Microsoft Active Directory with 20,000 users. Some applications use LDAP binds, some use Kerberos, and some use NTLM. The company wants to progressively migrate authentication to AWS while maintaining functionality for applications that remain on-premises during the transition.

Which identity architecture supports this phased migration?

A. Deploy AWS Managed Microsoft AD in a shared services VPC. Establish a two-way forest trust with the on-premises AD. As applications migrate, point them to the Managed Microsoft AD endpoint for LDAP, Kerberos, and NTLM authentication. Configure IAM Identity Center with Managed Microsoft AD as the identity source for AWS console/CLI access. Applications still on-premises continue using the on-premises AD—the forest trust ensures both directories share authentication.

B. Deploy AD Connector in AWS pointing to the on-premises AD over a VPN. Use AD Connector for all AWS authentication. Migrate applications one by one to Cognito.

C. Synchronize on-premises AD users to Cognito user pools using a custom sync tool. Modify applications to use Cognito APIs during migration.

D. Keep all authentication on-premises. Use AWS Direct Connect and route all auth traffic from AWS back to on-premises AD.

**Correct Answer: A**

**Explanation:** AWS Managed Microsoft AD supports LDAP, Kerberos, and NTLM—the same protocols as on-premises AD. The two-way forest trust allows users from either directory to authenticate to applications in either environment, enabling a gradual migration. Applications migrated to AWS point to Managed Microsoft AD; those still on-premises continue with the existing directory. IAM Identity Center integration enables modern SSO for AWS console access. Option B uses AD Connector, which proxies to on-premises AD but doesn't support NTLM for all scenarios and creates on-premises dependency. Option C requires rewriting authentication for all 500 applications. Option D creates latency and a single point of failure at the Direct Connect link.

---

### Question 55

A company is migrating a customer-facing application from an on-premises OpenLDAP directory to AWS. The application has 100,000 active users who authenticate with username/password. Requirements: (1) users must not be forced to reset passwords, (2) migration must be seamless (no downtime or UX changes), (3) new registrations should go directly to the cloud directory, and (4) the old directory should be fully decommissioned within 6 months.

Which migration strategy achieves this?

A. Create an Amazon Cognito user pool. Configure a User Migration Lambda trigger that authenticates users against the on-premises OpenLDAP on first login. If LDAP authentication succeeds, the trigger creates the user in Cognito with their existing password—subsequent logins go directly to Cognito. New registrations go to Cognito natively. Monitor the percentage of migrated users and decommission OpenLDAP when migration reaches 100% or the 6-month deadline (force-migrate remaining users at that point).

B. Export all 100,000 users from OpenLDAP to a CSV file and import them into Cognito using the bulk import feature. This forces password resets since passwords can't be exported from LDAP.

C. Run OpenLDAP on EC2 for 6 months while gradually moving users. Use a custom proxy that routes authentication to either OpenLDAP or Cognito based on migration status.

D. Federate Cognito with OpenLDAP as a SAML provider. Users continue authenticating against LDAP through federation.

**Correct Answer: A**

**Explanation:** The Cognito User Migration Lambda trigger enables seamless, transparent migration. On first login, the trigger receives the username and password, validates them against OpenLDAP, and if successful, returns the user attributes to Cognito, which creates the user account. The user's password is preserved because Cognito receives it directly during this flow. Subsequent logins authenticate directly against Cognito. New registrations bypass LDAP entirely. A monitoring dashboard tracks migration progress, and remaining users can be force-migrated (requiring password reset for only those users) at the 6-month deadline. Option B forces all users to reset passwords. Option C requires maintaining LDAP infrastructure on EC2 and building a custom proxy. Option D keeps LDAP as a permanent dependency—OpenLDAP doesn't natively support SAML.

---

### Question 56

A company is migrating from Google Workspace (Google Identity) as their corporate IdP to Microsoft Entra ID (Azure AD). They currently use IAM Identity Center with Google Workspace as the external identity source via SAML. 300 users have active permission set assignments across 80 accounts. The migration must ensure zero authentication downtime.

Which migration plan avoids downtime?

A. Phase 1: Set up Microsoft Entra ID with all users provisioned and tested independently. Phase 2: Configure Entra ID as an application in Google Workspace so users can access it during transition. Phase 3: Change IAM Identity Center's external identity source from Google Workspace to Entra ID. Re-establish SCIM provisioning from Entra ID. Phase 4: Re-map all permission set assignments to Entra ID-synced users/groups. Phase 5: Remove Google Workspace federation.

B. Change the IAM Identity Center identity source from Google Workspace to Entra ID directly. Reassign all permission sets afterward.

C. Switch IAM Identity Center to the built-in identity store first. Manually recreate all 300 users. Switch to Entra ID as the identity source and re-provision users.

D. Run both Google Workspace and Entra ID as identity sources in IAM Identity Center simultaneously during migration.

**Correct Answer: A**

**Explanation:** This phased approach ensures continuity. Entra ID is fully set up and tested before any changes to IAM Identity Center. The critical step—changing the Identity Center identity source—is carefully planned with user/group mapping prepared in advance. During the brief changeover (Phase 3), existing sessions remain active. Permission set reassignment (Phase 4) is executed immediately after, with pre-prepared mappings ensuring minimal access disruption. Option B risks disruption because permission sets reference identity source-specific user/group IDs that change with the identity source. Option C requires recreating all users and loses SSO during migration. Option D is not supported—IAM Identity Center only supports one external identity source at a time.

---

### Question 57

A company is migrating a legacy Java application that uses Spring Security with JDBC-based authentication (user table in Oracle). The application must be modernized to use Cognito without changing the login page UX. The Oracle user table contains username, bcrypt-hashed password, roles, and account status.

Which migration approach preserves the existing UX while migrating to Cognito?

A. Create a Cognito user pool. Implement a User Migration Lambda trigger that connects to the Oracle database on first login, retrieves the user record, verifies the bcrypt password hash against the provided password using a bcrypt library, and returns user attributes and roles as Cognito attributes. Update the Spring Security configuration to use the Cognito OAuth 2.0 integration (spring-security-oauth2-resource-server) with the existing login page as a custom UI through the Cognito hosted UI customization or by using the Cognito APIs directly from the Spring application.

B. Export all users from Oracle to a CSV file. Bulk import into Cognito. Update the Spring application to use Cognito's hosted UI.

C. Keep the Oracle-based authentication. Deploy Oracle on RDS. Use Cognito only as a token issuer after Oracle authentication succeeds.

D. Create IAM users for all application users and use IAM authentication for the Spring application.

**Correct Answer: A**

**Explanation:** The User Migration Lambda trigger transparently migrates users on first login. Since the trigger receives the plaintext password during authentication, it can verify it against the bcrypt hash from Oracle. After successful verification, the user is created in Cognito. The Spring application is updated to use Cognito's SDK/APIs directly (using the Authorization Code flow) with the existing login page template, preserving the UX. Option B forces password resets since bcrypt hashes can't be imported into Cognito. Option C doesn't actually migrate authentication away from Oracle. Option D uses IAM for application authentication, which is not appropriate for end-user authentication.

---

### Question 58

A company is migrating from AWS Single Sign-On (the predecessor) to the rebranded AWS IAM Identity Center, and they're using this opportunity to also move from per-account SAML federation (present in 40 accounts) to centralized IAM Identity Center management. They need to ensure that existing automation (scripts and CI/CD pipelines) that use AssumeRoleWithSAML continues working during the transition.

Which migration strategy prevents automation disruption?

A. Keep existing IAM SAML providers and federation roles in all accounts during the migration. Configure IAM Identity Center with the same IdP. Deploy new permission sets that mirror the existing role permissions. Validate that human users can access accounts via Identity Center. For automation, update scripts to use Identity Center's OIDC device authorization flow or maintain separate IAM roles for service accounts with trust policies that don't depend on SAML. Remove per-account SAML providers only after all automation is migrated.

B. Remove all per-account SAML providers immediately after enabling IAM Identity Center. Force all automation to use Identity Center credentials.

C. Create new IAM users with access keys for all automation workloads before removing SAML federation.

D. Convert all SAML roles to use web identity federation with the IAM Identity Center OIDC endpoint.

**Correct Answer: A**

**Explanation:** The parallel-run strategy keeps existing SAML federation intact for automation while Identity Center handles human access. This prevents any automation disruption. For the automation migration path, IAM Identity Center's OIDC device authorization flow provides temporary credentials for interactive scripts, while non-interactive automation should use dedicated IAM roles (not SAML-dependent) or service account patterns appropriate for their workload (e.g., instance profiles for EC2, task roles for ECS). Per-account SAML providers are removed only after confirming all dependencies are migrated. Option B causes immediate automation failures. Option C creates long-lived credentials—a step backward. Option D requires rewriting all automation simultaneously.

---

### Question 59

A company is migrating a monolithic application to microservices on EKS. The monolith uses a custom LDAP-based authentication module. Each microservice needs its own identity for service-to-service communication, and end-users must still authenticate via the corporate IdP. The migration is happening incrementally—the monolith and microservices must coexist for 12 months.

Which identity architecture supports the coexistence period?

A. Deploy AWS Managed Microsoft AD with a trust to on-premises LDAP (via a Samba DC or AD migration). The monolith continues LDAP authentication against Managed Microsoft AD. For microservices on EKS, use EKS Pod Identity or IRSA (IAM Roles for Service Accounts) for service-to-service AWS API calls. Deploy an Istio service mesh with mTLS for inter-service authentication. Implement an OAuth 2.0 authorization server (Cognito or the corporate IdP) that both the monolith and microservices accept for end-user tokens. Use an API gateway as the front door that validates end-user tokens before routing to either the monolith or microservices.

B. Give each microservice its own IAM access keys stored in Secrets Manager. Use the same LDAP authentication for end users across all services.

C. Migrate all authentication to Cognito on day one. Rewrite the monolith's LDAP module to use Cognito APIs.

D. Deploy Keycloak on EKS as the central identity broker. Migrate the LDAP directory into Keycloak. Configure all services to use Keycloak.

**Correct Answer: A**

**Explanation:** This architecture supports coexistence by providing: LDAP compatibility for the monolith (Managed Microsoft AD), cloud-native identity for microservices (IRSA/Pod Identity for AWS access, mTLS for service mesh), and a common end-user authentication standard (OAuth 2.0) that both the monolith and microservices can validate. The API gateway ensures consistent token validation at the entry point. Option B uses static credentials for services—insecure and doesn't scale. Option C requires monolith changes on day one, which conflicts with incremental migration. Option D requires managing additional infrastructure and migrating the directory, which is risky during an active migration.

---

### Question 60

A company is migrating 200 applications from on-premises to AWS. These applications currently share a common SAML SSO portal built on PingFederate. Post-migration, 150 apps will run on AWS and 50 will remain on-premises for another 2 years. All applications must continue to use SSO from the same portal regardless of where they're hosted.

Which approach maintains unified SSO during and after migration?

A. Keep PingFederate as the primary IdP for all 200 applications. Configure IAM Identity Center with PingFederate as the external SAML 2.0 identity source for AWS account access. For the 150 applications migrating to AWS, configure them as SAML/OIDC service providers registered in PingFederate—they continue using PingFederate regardless of hosting location. Use Application Load Balancers with OIDC authentication action to offload authentication for web applications, pointing to PingFederate.

B. Migrate all applications to use Cognito as the identity provider. Configure Cognito as a SAML provider in PingFederate for on-premises apps.

C. Replace PingFederate with IAM Identity Center. Configure the 50 on-premises applications as custom SAML applications in Identity Center.

D. Deploy a separate PingFederate instance on EC2 in AWS. Cluster it with the on-premises instance. Point migrated applications to the AWS PingFederate instance.

**Correct Answer: A**

**Explanation:** PingFederate remains the SSO portal for all applications, maintaining the unified experience. Migrated applications simply update their endpoints but keep PingFederate as their IdP—whether the app is on-premises or in AWS is transparent to the SSO flow. IAM Identity Center with PingFederate provides AWS account access (console/CLI). ALB's built-in OIDC authentication action simplifies authentication for web applications by handling the OIDC flow at the load balancer level. Option B inverts the IdP relationship inappropriately. Option C replaces an established IdP with one that has limited support for custom applications. Option D adds infrastructure management overhead for a PingFederate cluster.

---

### Question 61

A company is migrating from a legacy custom identity system that stores user passwords as MD5 hashes (insecure) to Amazon Cognito. They have 50,000 users. The security team mandates that: (1) MD5 passwords must not be stored anywhere in AWS, (2) users must set new passwords meeting Cognito's complexity requirements, (3) the migration must be transparent—users receive an email prompting them to set a new password through a secure link, and (4) user profiles must be preserved.

Which migration approach meets ALL security requirements?

A. Use the Cognito CSV user import job to create users with `RESET_REQUIRED` status (importing user attributes but not passwords). This creates accounts in Cognito that require a password reset on first access. Send a custom email to each user via SES with a link to the Cognito hosted UI password reset flow. The link initiates a `FORCE_CHANGE_PASSWORD` flow. MD5 hashes are never transferred to AWS.

B. Import MD5 hashes into DynamoDB. Use a User Migration Lambda trigger that verifies MD5 hashes during first login, then creates users in Cognito with the new password.

C. Use the Cognito User Migration trigger to connect to the legacy system on first login. Verify the MD5 hash and create the Cognito user.

D. Create users programmatically with `AdminCreateUser` and set temporary passwords. Email each user their temporary password.

**Correct Answer: A**

**Explanation:** CSV import with `RESET_REQUIRED` status creates user accounts preserving all attributes (email, phone, custom attributes) without importing passwords. Since MD5 hashes are never transferred to AWS, the security requirement is met. The custom email via SES (not Cognito's default email) allows a branded password reset experience. When users click the link, they're directed to the Cognito hosted UI's force-change-password flow, where they set a new password meeting Cognito's complexity requirements. Option B stores MD5 hashes in AWS (DynamoDB), violating requirement 1. Option C also involves MD5 hashes in the migration trigger's processing. Option D generates temporary passwords and sends them via email, which is a security risk.

---

### Question 62

A company is migrating from Okta to IAM Identity Center as part of a cost-reduction initiative. They have 200 custom Okta applications configured as SAML service providers, 50 AWS accounts with Okta SSO, and automated provisioning via Okta's SCIM integration with various SaaS tools. They need to maintain SSO to all 200 applications during the transition.

Which migration plan addresses all components?

A. Phase 1: Configure IAM Identity Center with a built-in identity store (or Entra ID if available) and migrate the 50 AWS accounts from per-account Okta SAML to Identity Center permission sets. Phase 2: For the 200 custom applications, evaluate which can be reconfigured as IAM Identity Center custom SAML 2.0 applications. Phase 3: For SCIM-provisioned SaaS tools, reconfigure SCIM endpoints from Okta to the new IdP. Phase 4: For applications that Identity Center can't support as SAML apps, maintain them on Okta during a longer transition or find an alternative IdP (like Entra ID) that supports them. Phase 5: Decommission Okta only when all applications are migrated.

B. Cancel Okta immediately and switch all 200 applications and 50 accounts to IAM Identity Center on the same day.

C. Keep Okta for the 200 custom applications permanently. Only migrate the 50 AWS accounts to IAM Identity Center.

D. Replace Okta with Amazon Cognito for all 200 applications and AWS account access.

**Correct Answer: A**

**Explanation:** IAM Identity Center can replace Okta for AWS account access (permission sets) and some SAML applications (it supports custom SAML 2.0 applications). However, Identity Center has limitations—it may not support all 200 applications' SAML configurations, especially complex ones. A phased approach prioritizes AWS account migration (highest cost savings), then evaluates each application. SCIM provisioning requires reconfiguring each SaaS tool's provisioning endpoint. The plan acknowledges that some applications may need an alternative IdP if Identity Center can't support them. Option B risks massive disruption. Option C doesn't achieve the cost reduction goal. Option D is inappropriate—Cognito is for customer identity, not workforce SSO.

---

### Question 63

A company uses IAM Identity Center with 100 accounts. They currently pay for Okta as their IdP and also use several AWS identity services. The CFO asks for identity cost optimization. Current setup: Okta Universal Directory ($8/user/month, 2000 users), AWS Managed Microsoft AD ($$$), Cognito user pools (3 pools, 100K MAU), and per-account SAML configurations requiring manual maintenance.

Which combination of changes provides the MOST cost savings? (Choose TWO.)

A. Replace Okta with IAM Identity Center's built-in identity store for workforce SSO if the company doesn't need Okta's advanced features (lifecycle automation, app catalog). This eliminates the $192,000/year Okta cost.

B. Consolidate the three Cognito user pools into one. Cognito pricing is per MAU across all pools, so consolidation saves on redundant Lambda triggers, infrastructure, and operational costs, but not on per-MAU pricing.

C. Replace AWS Managed Microsoft AD with AD Connector if the only use case is IAM Identity Center integration and there are no LDAP/Kerberos requirements from AWS-hosted applications.

D. Add more accounts to the Organization to increase the per-account SAML maintenance cost, justifying a centralized solution.

E. Migrate all applications from Cognito to IAM Identity Center to eliminate Cognito costs entirely.

**Correct Answer: A, C**

**Explanation:** (A) Okta at $8/user/month for 2000 users is $192,000/year. If the company's requirements can be met by IAM Identity Center's built-in identity store (which is free), this is the largest cost saving. (C) AWS Managed Microsoft AD starts at $$$$/month for the Standard edition. If the only use case is identity source for IAM Identity Center (no LDAP/Kerberos needs for AWS apps), AD Connector (~$$$$/month) is significantly cheaper as it simply proxies to on-premises AD. Option B consolidation saves operational costs but not per-MAU Cognito charges. Option D creates costs instead of savings. Option E is inappropriate—Cognito serves customer-facing apps, Identity Center serves workforce access.

---

### Question 64

A company has Cognito user pools for three applications with overlapping user bases. Currently, users who use multiple applications have separate accounts in each pool (total: 500,000 accounts across pools, but only 200,000 unique users). This creates: (1) redundant SMS MFA costs ($0.01/SMS per auth), (2) multiple password resets per user, and (3) inconsistent user experiences.

Which consolidation approach reduces costs and improves UX?

A. Consolidate to a single Cognito user pool with three app clients (one per application). Implement a user migration strategy: configure User Migration Lambda triggers in the consolidated pool that authenticate against the old pools on first login, creating users in the new pool. After migration, decommission the old pools. Each app client has its own OAuth scopes and callback URLs. Users authenticate once and can access all three applications via Cognito's SSO session.

B. Keep all three pools but implement a shared MFA service using SNS topics. Synchronize passwords across pools using Lambda triggers.

C. Replace Cognito with a self-managed identity solution on ECS to eliminate per-MAU charges.

D. Merge the pools by exporting users from all three and importing into one, forcing all 500,000 accounts to reset passwords.

**Correct Answer: A**

**Explanation:** Consolidating to a single user pool with three app clients reduces unique users from 500K to 200K, cutting MAU-based pricing by 60%. SMS MFA costs are reduced because each user authenticates once (SSO session) rather than separately per application. Single password management improves UX. The User Migration Lambda trigger enables transparent migration without password resets. Option B adds complexity without reducing costs significantly. Option C trades managed service benefits for infrastructure management overhead. Option D forces password resets for all users, causing massive disruption, and the 500K import includes duplicates.

---

### Question 65

A company uses IAM Identity Center with 80 permission sets. Analysis shows that many permission sets include overly broad policies (e.g., `s3:*`, `ec2:*`) because teams requested broad access during initial setup. CloudTrail analysis reveals that only 30% of granted permissions are actually used. Reducing permissions could save costs by preventing accidental resource creation and improving security.

Which approach right-sizes permissions with the LEAST effort while reducing potential cost waste?

A. Use IAM Access Analyzer to generate least-privilege policies based on CloudTrail activity for each permission set's assumed roles over the last 90 days. Replace overly broad policies in permission sets with the generated policies. Add permissions boundaries to permission sets as a safety net that prevents access to costly services (e.g., denying creation of large EC2 instance types, SageMaker endpoints) that teams don't need.

B. Remove all permissions and wait for teams to request what they need through a ticketing system.

C. Add AWS Budgets alerts to every account. When spending exceeds the budget, investigate which permissions caused the overspend.

D. Create new restrictive permission sets but keep the old broad ones. Ask teams to voluntarily switch.

**Correct Answer: A**

**Explanation:** IAM Access Analyzer policy generation creates least-privilege policies based on actual usage (CloudTrail data), removing permissions that were never used. This is data-driven and requires minimal guesswork. Permissions boundaries add a safety net preventing accidental creation of expensive resources even if some broad permissions remain. The combination reduces both security risk and cost waste from accidental resource provisioning. Option B disrupts operations immediately. Option C is reactive—cost waste occurs before detection. Option D relies on voluntary adoption, which rarely achieves full coverage.

---

### Question 66

A company hosts a SaaS application with Cognito authentication. They offer free and paid tiers. Free-tier users generate Cognito costs (MAU charges, SMS for MFA) without revenue. The company wants to reduce identity-related costs for free-tier users while maintaining a full-featured experience for paid users.

Which cost optimization strategy is MOST effective?

A. Configure free-tier users to use email-based OTP or TOTP authenticator apps for MFA instead of SMS, eliminating per-message SMS charges. For free-tier users, use Cognito's basic features only and disable advanced security features (which charge per MAU). Use Cognito user pool groups to separate tiers and apply different authentication flows—free-tier uses custom auth challenges without SMS, paid-tier gets full SMS MFA and advanced security.

B. Create two separate Cognito user pools: one free pool with minimal features and one paid pool with full features. Migrate users between pools when they upgrade.

C. Remove MFA for free-tier users entirely to save costs.

D. Replace Cognito with a self-hosted identity solution for free-tier users.

**Correct Answer: A**

**Explanation:** SMS is the primary variable cost driver in Cognito—each SMS costs $0.01+. Switching free-tier users to TOTP or email OTP eliminates this cost while maintaining MFA security. Advanced security features ($0.050/MAU) are also expensive at scale. Using Cognito groups to differentiate authentication flows within a single user pool avoids the operational overhead of multiple pools. Option B creates migration complexity between pools. Option C removes a security feature, increasing risk. Option D requires building and maintaining identity infrastructure, likely costing more than Cognito.

---

### Question 67

A company uses AWS Organizations with 150 accounts. Each account has at least 3 IAM roles created for legacy per-account SAML federation (now replaced by IAM Identity Center). These 450+ orphaned roles have policies that could be assumed if the SAML provider metadata is compromised. Cleaning up these roles reduces both security risk and the blast radius of a compromise.

Which approach safely removes orphaned federation roles at scale?

A. Use AWS Config organizational rules to identify IAM roles with SAML trust policies across all accounts. Cross-reference with IAM Access Analyzer unused access findings to confirm the roles haven't been assumed in 90 days. Deploy an SSM Automation document that: (1) adds a deny-all inline policy to the role, (2) waits 7 days for any breakage reports, (3) if no issues, deletes the role. Execute across all accounts using the management account's automation role.

B. Delete all IAM roles with SAML trust policies immediately using a Lambda function running across all accounts.

C. Modify the trust policies of all SAML roles to trust `arn:aws:iam::root` (nobody), effectively disabling them. Leave the roles in place.

D. Use CloudFormation StackSets to delete the roles, but only during a maintenance window.

**Correct Answer: A**

**Explanation:** This is a safe, three-phase cleanup: (1) Identify orphaned roles using Config and validate they're unused via Access Analyzer. (2) Apply a deny-all policy rather than immediate deletion, creating a soft-disable period that catches any undocumented dependencies. (3) Delete only after the safety period passes without issues. This prevents accidental disruption from roles that might still be used by unknown processes. Option B risks breaking applications that may still depend on these roles. Option C leaves unnecessary roles that clutter the environment and could be re-enabled. Option D doesn't include a safety period and depends on scheduling.

---

### Question 68

A company is evaluating the cost of running their identity infrastructure across AWS. Current components: IAM Identity Center (free), Managed Microsoft AD Standard ($87.60/month), Cognito user pool (500K MAU at Cognito pricing), 3 AD Connectors ($36/month each), and custom Lambda functions for identity automation (10M invocations/month). The company wants to reduce costs by 40%.

Which optimization achieves the target cost reduction?

A. Analyze the AD Connectors usage. If they're only used for WorkSpaces/WorkDocs directory integration, evaluate whether these services can use IAM Identity Center directly (WorkSpaces now supports Identity Center). Eliminate AD Connectors that become redundant. Evaluate whether Managed Microsoft AD is necessary—if no AWS applications require LDAP/Kerberos and it's only used as the IAM Identity Center identity source, replace it with Identity Center's built-in identity store or connect Identity Center directly to the corporate IdP (SAML/SCIM). Optimize Lambda invocations by consolidating identity automation functions and using Step Functions for orchestration to reduce redundant invocations.

B. Migrate from Cognito to a self-hosted solution to eliminate MAU charges.

C. Switch from Managed Microsoft AD Standard to Simple AD, which costs less.

D. Reduce the number of AWS accounts in the Organization to lower identity management costs.

**Correct Answer: A**

**Explanation:** The optimization targets three cost centers: (1) AD Connectors ($108/month) may be eliminable if the services they support can use Identity Center. (2) Managed Microsoft AD ($87.60/month) is the most expensive identity component—if it's only serving as the Identity Center identity source without LDAP/Kerberos workloads, replacing it with direct IdP integration eliminates this cost. (3) Lambda optimizations reduce invocation costs. Together, eliminating AD Connectors + Managed Microsoft AD saves ~$195/month of the identity infrastructure cost. Option B replaces managed service with self-managed infrastructure, typically increasing total cost. Option C may not support required AD features. Option D doesn't directly reduce identity costs.

---

### Question 69

A company uses Cognito for a global application with 2 million MAU. Cognito pricing tiers mean they're paying the higher per-MAU rate for users above the 100K tier. They want to reduce Cognito costs without changing the user experience.

Which optimization provides the MOST cost reduction?

A. Implement a Cognito token caching layer using ElastiCache. When users make repeated API calls, validate cached tokens locally instead of calling Cognito's token endpoint, reducing Cognito API call charges. Additionally, analyze the MAU breakdown—if many "users" are bots or automated systems, implement CAPTCHA (Cognito's built-in or WAF) to block them, reducing artificial MAU inflation. Review token lifetimes: extending access token duration (e.g., from 5 minutes to 1 hour) reduces token refresh calls.

B. Migrate to a cheaper Region. Cognito pricing varies by Region.

C. Reduce the number of features (remove MFA, remove advanced security) to lower the per-MAU rate.

D. Create multiple Cognito user pools and distribute users across them to take advantage of lower pricing tiers per pool.

**Correct Answer: A**

**Explanation:** The primary costs in Cognito are MAU charges and API calls. Token caching reduces API call volume significantly for high-traffic applications. Bot detection and blocking reduces inflated MAU counts—each bot that authenticates counts as an MAU. Extending access token lifetimes reduces the frequency of token refresh calls. Combined, these optimizations can significantly reduce costs without affecting legitimate user experience. Option B has minimal pricing variation across Regions. Option C reduces security for minimal savings. Option D doesn't work—Cognito MAU pricing is per pool, but splitting users across pools creates operational complexity and doesn't reduce total MAU.

---

### Question 70

A company operates a multi-tenant SaaS platform using Cognito. Each tenant's configuration is stored in DynamoDB. They currently run a separate Lambda function per tenant for custom authentication flows, resulting in 500 Lambda functions with identical code but different environment variables. This creates deployment and maintenance overhead.

Which architecture consolidation reduces operational costs?

A. Consolidate to a single set of Lambda triggers (DefineAuthChallenge, CreateAuthChallenge, VerifyAuthChallengeResponse) shared across all tenants. Pass the tenant ID as a claim in the authentication request. The Lambda function reads the tenant's configuration from DynamoDB at runtime (with DAX caching for performance) to customize the authentication flow per tenant. This reduces Lambda functions from 500 to 3-4, simplifying deployments and reducing cold starts.

B. Replace Lambda triggers with API Gateway and Step Functions for authentication flows.

C. Move all custom authentication logic to the client side to eliminate Lambda costs entirely.

D. Deploy a single ECS service for authentication processing instead of Lambda functions.

**Correct Answer: A**

**Explanation:** Consolidating 500 identical Lambda functions into a few shared functions with runtime tenant resolution dramatically reduces operational overhead. DAX caching ensures that DynamoDB lookups for tenant configuration don't add significant latency. Benefits include: single deployment for all tenants, reduced cold start surface (fewer distinct functions), simplified monitoring, and lower maintenance costs. The tenant ID in the authentication request (via `clientMetadata`) identifies which configuration to load. Option B adds unnecessary orchestration complexity. Option C moves security-sensitive logic to untrusted clients. Option D introduces ECS management overhead for a function that Lambda handles efficiently.

---

### Question 71

A company uses IAM Identity Center with permission sets that include inline policies. They've hit the 10,240-character limit on several permission sets, forcing them to create additional overlapping sets. This proliferation increases management complexity and the risk of permission gaps.

Which approach resolves the policy size limitation MOST effectively?

A. Replace inline policies in permission sets with customer-managed IAM policies referenced by ARN in the permission set configuration. Customer-managed policies have a 6,144-character limit per policy but permission sets can reference up to 10 customer-managed policies. Additionally, refactor policies to use ABAC (attribute-based conditions) instead of explicit resource ARNs, which reduces policy size significantly. Use permission set boundary policies to enforce limits without consuming the inline policy character budget.

B. Create multiple permission sets with the policies split across them. Assign all sets to the same users.

C. Use SCPs to replace some of the permission set policies, reducing the inline policy size.

D. Compress the policy JSON by removing whitespace and comments, then minify the policy.

**Correct Answer: A**

**Explanation:** Permission sets support both inline policies and references to customer-managed IAM policies (up to 10). By moving policies to customer-managed policies, you get more total policy space. ABAC refactoring replaces long lists of resource ARNs with concise tag-based conditions (e.g., `"Condition": {"StringEquals": {"aws:ResourceTag/Project": "${aws:PrincipalTag/Project}"}}` replaces dozens of explicit ARNs). Permissions boundaries in permission sets provide guardrails without consuming the main policy budget. Option B creates management complexity with overlapping permission sets. Option C uses SCPs for authorization logic, which is not their intended purpose. Option D provides minimal savings and is already done by AWS automatically.

---

### Question 72

A company runs a regulated application where every authentication event must be correlated with a unique session ID that persists across all API calls made during that session. This session ID must appear in CloudTrail, application logs, and Cognito logs for end-to-end audit tracing.

Which implementation provides end-to-end session correlation?

A. Use the Cognito Pre Token Generation Lambda trigger to generate a unique session UUID and inject it as a custom claim in both the access token and ID token. The application extracts this session ID from the token and includes it in every API request header. API Gateway access logging captures the session ID. Lambda functions in the backend log it. CloudTrail events for the Cognito identity pool-assumed role include the session tags, which can contain the session ID via IAM session tags derived from the Cognito token claims.

B. Use CloudTrail event IDs as session identifiers. Correlate events by matching user ARN across CloudTrail entries.

C. Generate session IDs in the frontend application and pass them as custom headers. Log them at each service.

D. Use AWS X-Ray trace IDs as session identifiers across all services including Cognito.

**Correct Answer: A**

**Explanation:** The Pre Token Generation trigger is the ideal injection point—it executes after successful authentication and before token delivery. The session UUID in token claims persists for the entire session (until token refresh). By flowing this ID from Cognito through API Gateway to backend services and into CloudTrail (via session tags), you create a complete audit trail. Option B relies on CloudTrail event IDs, which are per-event, not per-session. Option C generates IDs client-side, which can be spoofed or missing. Option D's X-Ray traces are per-request, not per-session, and X-Ray doesn't integrate with Cognito authentication events.

---

### Question 73

A company has 5 business units, each with their own AWS accounts and Cognito user pools. They're consolidating to a shared services model where common platform services (notification service, file service, user preferences service) are deployed once in a shared account. All business units' users must access these shared services using their existing Cognito identities without creating new accounts.

Which architecture enables cross-account, cross-user-pool access to shared services?

A. Create a Cognito identity pool in the shared services account configured with all 5 business unit user pools as authentication providers. Define a single authenticated IAM role in the shared services account with permissions to access the shared platform services. Users authenticate with their BU's user pool and exchange the token for shared account credentials via the identity pool. The IAM role's policy uses `cognito-identity.amazonaws.com:sub` for per-user data isolation within shared services.

B. Create cross-account IAM roles in the shared services account that trust each BU's Cognito user pool. Users assume these roles directly.

C. Federate all 5 user pools into a single central user pool using OIDC. Users authenticate against the central pool.

D. Deploy copies of shared services in each BU's account to avoid cross-account access.

**Correct Answer: A**

**Explanation:** Cognito identity pools support multiple user pools as authentication providers, even from different accounts. The shared services account's identity pool accepts tokens from any of the 5 BU user pools and issues temporary credentials for the shared account's authenticated role. Policy variables ensure per-user data isolation across the shared services. This requires no changes to existing user pools or user accounts. Option B doesn't work—IAM role trust policies can't directly trust Cognito user pools across accounts without an identity pool. Option C requires users to authenticate against a different pool than their BU pool. Option D wastes resources by duplicating services.

---

### Question 74

A company wants to implement identity federation cost monitoring. They spend on: IAM Identity Center (free), Cognito (per MAU), Managed Microsoft AD (per hour), Lambda triggers (per invocation), CloudWatch logs for authentication events, and SES for Cognito emails. They want a unified dashboard showing identity-related costs across all these services.

Which approach provides the MOST comprehensive cost visibility?

A. Create cost allocation tags (e.g., `CostCenter: Identity`) and apply them to all identity-related resources: Cognito user pools, Lambda functions, Managed Microsoft AD, CloudWatch log groups, and SES configuration sets. Enable the tag in the billing console for cost allocation. Use AWS Cost Explorer with the tag filter to create a custom report. Build a Cost and Usage Report (CUR) analysis in Athena with a query that aggregates costs across all tagged resources. Display results in a QuickSight dashboard with trend analysis and anomaly detection.

B. Check the monthly bill manually and add up identity-related line items.

C. Use AWS Budgets with a filter for each identity service. Create separate budgets and sum them mentally.

D. Use Trusted Advisor's cost optimization checks to identify identity-related cost savings.

**Correct Answer: A**

**Explanation:** Cost allocation tags provide a unified mechanism to attribute costs across diverse services to the "Identity" cost center. CUR data in Athena allows granular analysis (daily/hourly trends, per-service breakdown within the identity category). QuickSight dashboards provide visualization with anomaly detection to catch unexpected cost increases (e.g., Cognito MAU spike, Lambda invocation surge). This gives the CFO a single view of total identity cost across all services. Option B is manual and error-prone. Option C requires managing separate budgets without a unified view. Option D focuses on general cost optimization, not identity-specific cost tracking.

---

### Question 75

A company is evaluating whether to use Amazon Cognito or IAM Identity Center for a new internal tool used by 500 employees. The tool is a React web application hosted on S3/CloudFront that calls API Gateway + Lambda backends. Employees already have IAM Identity Center access to AWS accounts.

Which is the MORE cost-effective and operationally efficient choice?

A. Use IAM Identity Center's OIDC integration. Configure the React app to authenticate against IAM Identity Center's OIDC endpoint. API Gateway validates the OIDC token issued by Identity Center. This leverages the existing identity infrastructure, adds no additional cost (Identity Center is free), and provides SSO with other AWS account access. No additional identity service needed.

B. Create a new Cognito user pool for the application. Configure it with the same IdP as Identity Center. Set up a separate user pool, app client, and hosted UI domain.

C. Use IAM authentication directly. Create IAM users for all 500 employees with API keys.

D. Use both Cognito and Identity Center—Cognito for the application and Identity Center for AWS account access.

**Correct Answer: A**

**Explanation:** IAM Identity Center supports OIDC for custom applications, and since employees are already provisioned in Identity Center, no additional identity infrastructure is needed. The React app redirects to Identity Center for authentication and receives OIDC tokens. API Gateway validates these tokens. This is zero additional cost since Identity Center is free, and employees get SSO between the internal tool and their AWS account access. Option B adds Cognito cost ($0.0055/MAU × 500 = $2.75/month minimum, plus operational overhead of managing a separate identity source). Option C creates long-lived credentials—a security anti-pattern. Option D is redundant since Identity Center alone handles both use cases.

---

## Answer Key

| Q | Ans | Q | Ans | Q | Ans | Q | Ans | Q | Ans |
|---|-----|---|-----|---|-----|---|-----|---|-----|
| 1 | A | 16 | A | 31 | C | 46 | A,B | 61 | A |
| 2 | A | 17 | C | 32 | A | 47 | A | 62 | A |
| 3 | A | 18 | A | 33 | A | 48 | A | 63 | A,C |
| 4 | A | 19 | C | 34 | A | 49 | A | 64 | A |
| 5 | A | 20 | B | 35 | A | 50 | A | 65 | A |
| 6 | A | 21 | A | 36 | A | 51 | A | 66 | A |
| 7 | A,B,D | 22 | A | 37 | A | 52 | A | 67 | A |
| 8 | A | 23 | D | 38 | A | 53 | A | 68 | A |
| 9 | B | 24 | A | 39 | C | 54 | A | 69 | A |
| 10 | A | 25 | A | 40 | A | 55 | A | 70 | A |
| 11 | B | 26 | A | 41 | A | 56 | A | 71 | A |
| 12 | A | 27 | A | 42 | A | 57 | A | 72 | A |
| 13 | A | 28 | A | 43 | A | 58 | A | 73 | A |
| 14 | A | 29 | A | 44 | A,B | 59 | A | 74 | A |
| 15 | C | 30 | A | 45 | A | 60 | A | 75 | A |
