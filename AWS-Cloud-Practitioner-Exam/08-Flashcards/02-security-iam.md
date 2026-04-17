# Flashcards — Domain 2 (IAM & Identity)

Q: State the Shared Responsibility Model tagline.
A: AWS is responsible for security OF the cloud; customer for security IN the cloud. #must-know

Q: Who patches the EC2 guest OS?
A: Customer. #must-know

Q: Who patches the hypervisor?
A: AWS. #must-know

Q: Who is responsible for IAM configuration?
A: Customer. #must-know

Q: Who is responsible for the physical security of AWS data centers?
A: AWS. #must-know

Q: On RDS, who patches the DB engine?
A: AWS (during the customer-selected maintenance window). #must-know

Q: Who owns the encryption decision for customer data at rest?
A: Customer chooses; AWS provides the mechanisms (KMS, etc.). #must-know

Q: What's an example of a shared control?
A: Patch management, configuration management, awareness & training. #must-know

Q: Define least privilege.
A: Grant only the minimum permissions necessary to complete a task. #must-know

Q: What is defense in depth?
A: Applying security at every layer (edge, network, host, app, data). #must-know

Q: Is IAM global or regional?
A: Global. #must-know

Q: Is IAM free?
A: Yes. #must-know

Q: 4 pillars of IAM objects?
A: Users, Groups, Roles, Policies. #must-know

Q: What is a policy in IAM?
A: A JSON document describing allowed/denied actions on resources. #must-know

Q: Minimum 3 elements of a policy statement?
A: Effect, Action, Resource. #must-know

Q: Effect values?
A: Allow or Deny. #must-know

Q: Does an explicit Deny win?
A: Yes — explicit Deny trumps all Allows. #must-know

Q: Default state if nothing matches?
A: Implicit deny. #must-know

Q: What is a resource-based policy?
A: A policy attached to a resource (S3 bucket, SQS, Lambda, KMS key, etc.) specifying who can access it. #must-know

Q: What's a permissions boundary?
A: A policy that caps the maximum permissions of a user or role (used by admins delegating IAM). #must-know

Q: Do SCPs grant permissions?
A: No — SCPs only cap what permissions can be granted. #must-know

Q: Do SCPs affect the root account?
A: Not for the management account; they don't apply to service-linked roles either. #must-know

Q: Where do SCPs attach?
A: To Organization root, OUs, or individual accounts. #must-know

Q: What is an IAM role's "trust policy"?
A: The policy describing who (principal) is allowed to assume the role. #must-know

Q: What operation retrieves temporary credentials from a role?
A: sts:AssumeRole (and variants). #must-know

Q: What is STS?
A: AWS Security Token Service — vends temporary credentials. #must-know

Q: Preferred way for EC2 apps to get AWS credentials?
A: IAM role via instance profile — never long-lived keys. #must-know

Q: Max role session duration?
A: 1–12 hours depending on configuration. #must-know

Q: What is IAM Identity Center?
A: Successor to AWS SSO; central identity/permissions for workforce across many AWS accounts + SaaS. #must-know

Q: Cognito User Pool vs Identity Pool?
A: User Pool = auth for your app's end-users (issues JWTs). Identity Pool = exchanges identities (any source) for AWS creds. #must-know

Q: Which service gives external on-prem servers IAM roles via X.509 certs?
A: IAM Roles Anywhere. #must-know

Q: What's Access Analyzer?
A: IAM tool that finds external-account access and can generate least-privilege policies from CloudTrail. #must-know

Q: What's Access Advisor?
A: IAM feature showing last-accessed timestamps per service for a user/role. #must-know

Q: What does IAM Credential Report show?
A: CSV of all users and credential state (access keys, password, MFA). #must-know

Q: What's the IAM Policy Simulator?
A: Tool to test if an IAM policy would allow/deny an action before deploying. #must-know

Q: Should you create access keys for the root user?
A: No — and delete if any exist. #must-know

Q: What should be enabled on the root user immediately?
A: MFA. #must-know

Q: Hardware MFA options?
A: YubiKey / Gemalto token / FIDO security keys. #must-know

Q: Is SMS MFA recommended?
A: No — deprecated. #must-know

Q: Why prefer temporary credentials?
A: They expire quickly, limiting blast radius if leaked. #must-know

Q: What does ABAC stand for?
A: Attribute-Based Access Control — IAM decisions driven by tags. #must-know

Q: Typical role for EC2 applications?
A: EC2 Instance Profile / Role. #must-know

Q: Role for Lambda functions?
A: Execution Role. #must-know

Q: SAML vs OIDC?
A: SAML 2.0 and OIDC are the two standard federation protocols AWS supports. SAML is XML-based, common for enterprise IdPs. OIDC is OAuth2-based, common for modern web/SaaS apps. #must-know

Q: Which federation approach do GitHub Actions use to assume AWS roles?
A: OIDC federation. #must-know

Q: Amazon Cognito can use which IdPs for social login?
A: Google, Facebook, Apple, Amazon, SAML, OIDC. #must-know

Q: What does "permission set" refer to in IAM Identity Center?
A: A bundle of IAM policies provisioned as roles in assigned AWS accounts. #must-know

Q: What's AWS Managed Microsoft AD?
A: Managed Microsoft Active Directory service in AWS. #must-know

Q: What's AD Connector?
A: A proxy to your on-prem AD; doesn't store credentials. #must-know

Q: Simple AD is based on what?
A: Samba 4. #must-know

Q: What's the difference between identity-based and resource-based policies?
A: Identity-based attach to principals (user/group/role). Resource-based attach to resources and specify Principal. #must-know

Q: Does an S3 bucket policy include a Principal?
A: Yes — resource-based policies must specify Principal. #must-know

Q: Can an IAM identity-based policy specify Principal?
A: No — the principal is the identity the policy is attached to. #must-know

Q: How to require MFA for an action in a policy?
A: Condition: aws:MultiFactorAuthPresent = true (or BoolIfExists pattern). #must-know

Q: What is a service-linked role?
A: A role pre-defined by a service (EKS, ECS, Organizations, etc.) for service-to-service actions. #must-know

Q: What's the blast-radius benefit of using multiple AWS accounts?
A: Separation of permissions and security posture between teams/environments. #must-know

Q: In IAM Identity Center, who is the identity store?
A: Built-in Identity Center store, or federated external IdP (Azure AD/Entra ID, Okta, Google Workspace, Ping, etc.). #must-know

Q: How long can IAM temporary credentials last?
A: Minutes to up to 12 hours (36 hours for IAM Identity Center session default is configurable up to 12h for roles). #iam

Q: What log service records IAM events?
A: CloudTrail. #must-know
