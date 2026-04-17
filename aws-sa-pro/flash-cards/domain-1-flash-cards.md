# Domain 1 - Organizational Complexity Flash Cards

## AWS Certified Solutions Architect - Professional (SAP-C02)

**Topics:** Multi-account strategies, Organizations, SCPs, Control Tower, cross-account access, RAM, VPC sharing, Transit Gateway, Direct Connect, VPN, hybrid DNS, directory services, identity federation, IAM Identity Center, Cognito, SAML, OIDC, governance, compliance, Config, CloudTrail, Audit Manager, Service Catalog

---

### Card 1
**Q:** What is the recommended multi-account strategy pattern in AWS, and what are its key benefits?
**A:** AWS recommends using AWS Organizations with a multi-account strategy organized by workload, environment, or business unit. Benefits include: blast-radius reduction (security isolation), granular cost tracking per account, service quota isolation, separate IAM boundaries, simplified compliance auditing, and independent deployment pipelines. The AWS Well-Architected Framework suggests separate accounts for production, staging, dev, security/logging, shared services, and sandbox.

---

### Card 2
**Q:** What is AWS Organizations and what are its two feature sets?
**A:** AWS Organizations is a service for centrally managing multiple AWS accounts. Two feature sets: (1) **Consolidated Billing Only** – aggregates billing across accounts, provides volume discounts, and shares Reserved Instance/Savings Plan benefits. (2) **All Features** – includes consolidated billing plus SCPs, tag policies, backup policies, AI services opt-out policies, and integration with AWS services like Control Tower, RAM, and IAM Identity Center.

---

### Card 3
**Q:** What is the structure of an AWS Organization?
**A:** An Organization consists of a **management account** (formerly master account) at the root, and member accounts organized into **Organizational Units (OUs)**. OUs can be nested up to 5 levels deep. The root is the top-level container. Each account belongs to exactly one OU. The management account cannot be restricted by SCPs.

---

### Card 4
**Q:** What are Service Control Policies (SCPs) and how do they work?
**A:** SCPs are organization-level permission guardrails that define the maximum available permissions for member accounts. SCPs do NOT grant permissions—they only restrict what's allowed. They apply to all IAM users, roles, and the root user in member accounts, but NOT to the management account. SCPs use IAM policy syntax with Allow/Deny statements. A Deny in an SCP overrides any Allow in IAM policies.

---

### Card 5
**Q:** How does SCP inheritance work through the OU hierarchy?
**A:** SCPs are inherited through the OU hierarchy using an intersection model. An account's effective permissions are the intersection of all SCPs attached from the root down to the account's OU, intersected with the account's own attached SCPs. If an OU has no explicit SCP, the default `FullAWSAccess` policy applies. To restrict a service, you can attach a Deny SCP at any parent OU, and it affects all child OUs and accounts below.

---

### Card 6
**Q:** What is the difference between a Deny-list and Allow-list SCP strategy?
**A:** **Deny-list strategy** (default): Keep `FullAWSAccess` attached, then add explicit Deny statements for services/actions you want to block. Easier to manage. **Allow-list strategy**: Remove `FullAWSAccess`, then explicitly allow only specific services. More restrictive but harder to manage as you must enumerate every allowed action. Deny-list is recommended for most organizations.

---

### Card 7
**Q:** What is AWS Control Tower and what problems does it solve?
**A:** AWS Control Tower automates the setup and governance of a secure, multi-account AWS environment (a landing zone). It provides: pre-configured OUs (Security, Sandbox), guardrails (preventive via SCPs and detective via Config rules), Account Factory for provisioned new accounts, a dashboard for compliance visibility, and automated log archive/audit accounts. It builds on Organizations, Config, CloudTrail, IAM Identity Center, and Service Catalog.

---

### Card 8
**Q:** What are the types of guardrails in AWS Control Tower?
**A:** Three types: (1) **Preventive** – implemented as SCPs, block disallowed operations (e.g., deny root account access keys). (2) **Detective** – implemented as AWS Config rules, detect noncompliance and flag it (e.g., EBS volumes not encrypted). (3) **Proactive** – implemented as CloudFormation hooks, check resources before provisioning. Each guardrail has a behavior: mandatory, strongly recommended, or elective.

---

### Card 9
**Q:** What is Account Factory in AWS Control Tower?
**A:** Account Factory is a configurable account provisioning template that automates new account setup. It provisions accounts via Service Catalog, applies guardrails, configures VPC settings, sets up IAM Identity Center access, and ensures the account conforms to organizational standards. Account Factory for Terraform (AFT) extends this with Terraform-based customization pipelines.

---

### Card 10
**Q:** What is AWS Resource Access Manager (RAM)?
**A:** AWS RAM enables resource sharing across AWS accounts or within an Organization without creating duplicate resources. Shareable resources include: VPC subnets, Transit Gateway, Route 53 Resolver rules, License Manager configurations, Aurora DB clusters, CodeBuild projects, EC2 (Dedicated Hosts, Capacity Reservations), Glue catalogs, and more. Within an Organization, sharing can be enabled without individual account acceptance.

---

### Card 11
**Q:** How does VPC sharing work with AWS RAM?
**A:** VPC sharing allows a VPC owner to share subnets with other accounts in the same Organization. Participant accounts can launch resources (EC2, RDS, Lambda, etc.) in shared subnets but cannot modify the VPC or subnet. The owner account manages VPC networking (route tables, NACLs, gateways). Benefits: reduced VPC sprawl, centralized network management, and resources in shared subnets can communicate via private IPs.

---

### Card 12
**Q:** What are the methods for cross-account access in AWS?
**A:** Key methods: (1) **IAM Roles with cross-account trust** – create a role in target account with trust policy allowing source account. (2) **Resource-based policies** – attach policies on resources (S3 buckets, KMS keys, SQS, SNS, Lambda) allowing cross-account principals. (3) **AWS RAM** – share resources natively. (4) **IAM Identity Center** – centralized SSO with permission sets. (5) **Organizations delegation** – delegate admin for services to member accounts.

---

### Card 13
**Q:** What is the difference between IAM role assumption and resource-based policies for cross-account access?
**A:** With **role assumption**, the principal gives up original permissions and assumes the role's permissions. There's no simultaneous access to both accounts' resources. With **resource-based policies**, the principal retains its own permissions AND gains access to the shared resource—no permission switch occurs. Resource-based policies support direct cross-account access without assuming a role. Not all services support resource-based policies.

---

### Card 14
**Q:** What is AWS Transit Gateway and what problems does it solve?
**A:** Transit Gateway (TGW) is a regional network hub that connects VPCs, VPN connections, Direct Connect gateways, and peered Transit Gateways. It solves the N-to-N peering complexity problem—instead of creating O(N²) peering connections, all VPCs connect to one TGW. Supports transitive routing, route tables for segmentation, multicast, and cross-region peering. Bandwidth per VPC attachment: up to 50 Gbps (burst).

---

### Card 15
**Q:** How do Transit Gateway route tables enable network segmentation?
**A:** TGW supports multiple route tables. Each attachment (VPC, VPN, DX) can be associated with one route table and propagate routes to multiple route tables. You create isolated route domains by associating groups of attachments with separate route tables. For example: production VPCs share one route table, dev VPCs share another, and only a shared-services VPC propagates to both—achieving segmentation without complex ACLs.

---

### Card 16
**Q:** What is Transit Gateway peering and what are its characteristics?
**A:** TGW supports inter-region and intra-region peering using static routes. Peered TGWs exchange traffic over the AWS global network (encrypted). Key traits: peering uses static routes only (no dynamic propagation), data is encrypted in transit, supports cross-account peering, bandwidth up to 50 Gbps. Use case: connecting VPCs across regions through a hub-and-spoke model spanning multiple regions.

---

### Card 17
**Q:** What is AWS Direct Connect and its key specifications?
**A:** Direct Connect (DX) provides a dedicated private network connection from on-premises to AWS. Speeds: 1 Gbps, 10 Gbps, 100 Gbps (dedicated), or 50 Mbps–10 Gbps (hosted). Uses **Virtual Interfaces (VIFs)**: Private VIF (VPC access), Public VIF (AWS public services), Transit VIF (Transit Gateway). Data is NOT encrypted by default. Typical provisioning: weeks to months. Uses BGP for routing. SLA requires redundant connections.

---

### Card 18
**Q:** What are the three types of Direct Connect Virtual Interfaces?
**A:** (1) **Private VIF** – connects to a single VPC via Virtual Private Gateway (VGW). Access private IP addresses. (2) **Public VIF** – access all AWS public services (S3, DynamoDB, etc.) via public IP addresses across all regions. (3) **Transit VIF** – connects to a Transit Gateway, allowing access to multiple VPCs via a single DX connection. Transit VIF supports up to 3 TGWs per DX connection.

---

### Card 19
**Q:** How do you achieve high availability with Direct Connect?
**A:** **Maximum resiliency**: Two DX connections at two separate DX locations, each with redundant device connections (4 total). **High resiliency**: Two DX connections at two separate locations (2 total). **Development/Test**: Single DX with redundant device connections. For additional HA, add a VPN connection as backup (cheaper). Use BFD (Bidirectional Forwarding Detection) for fast failover. LAG (Link Aggregation Group) bundles multiple connections at same location.

---

### Card 20
**Q:** How do you encrypt traffic over Direct Connect?
**A:** DX traffic is NOT encrypted by default. Options: (1) **VPN over DX** – create a Site-to-Site VPN connection over the Public VIF, then route to VPC. Provides IPsec encryption with ~1.25 Gbps throughput per VPN tunnel. (2) **MACsec** – Layer 2 encryption available on 10 Gbps and 100 Gbps dedicated connections. Provides line-rate encryption without throughput reduction. MACsec requires supported DX partner equipment.

---

### Card 21
**Q:** What is a Direct Connect Gateway and when would you use it?
**A:** A DX Gateway is a globally available resource that connects a DX connection to VPCs in multiple regions (via VGWs) or to Transit Gateways. Without it, a Private VIF only reaches one VGW in one region. With DX Gateway, one DX connection can connect to up to 10 VGWs across any region. DX Gateway + Transit VIF connects to TGW for access to thousands of VPCs. No additional data processing charges.

---

### Card 22
**Q:** What is AWS Site-to-Site VPN and its key characteristics?
**A:** Site-to-Site VPN creates an IPsec encrypted tunnel between on-premises and AWS. Components: Customer Gateway (on-prem side config), Virtual Private Gateway or Transit Gateway (AWS side). Each VPN connection has 2 tunnels for HA. Throughput: up to 1.25 Gbps per tunnel. Supports static routing or BGP. Can run over public internet or over DX (for encryption). Provisioning: minutes (vs. weeks for DX). Supports Accelerated VPN via Global Accelerator.

---

### Card 23
**Q:** What is AWS Client VPN and how does it differ from Site-to-Site VPN?
**A:** AWS Client VPN is a managed OpenVPN-based service for individual user connectivity to AWS and on-premises networks. It uses TLS for encryption. Supports SAML 2.0 federated authentication, Active Directory, and mutual certificate auth. Key difference: Client VPN is for individual users/devices (remote workforce), while Site-to-Site VPN connects entire networks. Client VPN is elastic and scales automatically. Billed per connection-hour plus per subnet association-hour.

---

### Card 24
**Q:** What is AWS CloudWAN and when would you use it over Transit Gateway?
**A:** AWS Cloud WAN is a managed WAN service that provides a global network connecting on-premises and AWS resources. Use over TGW when you need: a global network policy (declarative JSON/YAML), cross-region routing without manually peering TGWs, centralized network management across regions, and segment-level isolation. Cloud WAN automates TGW creation, peering, and routing. Best for large enterprises with multi-region presence needing centralized global network management.

---

### Card 25
**Q:** How does hybrid DNS resolution work between on-premises and AWS?
**A:** Use **Route 53 Resolver**: (1) **Inbound Endpoints** – allow on-premises DNS servers to resolve AWS-hosted domains by forwarding queries to the endpoint ENIs. (2) **Outbound Endpoints** – allow VPC resources to resolve on-premises domains by forwarding queries via conditional forwarding rules. (3) **Resolver Rules** – define which domains forward where. Rules can be shared across accounts via RAM. The VPC CIDR+2 address serves as the default DNS resolver within a VPC.

---

### Card 26
**Q:** What is the VPC DNS resolution flow (AmazonProvidedDNS)?
**A:** When `enableDnsSupport=true` and `enableDnsHostnames=true`, EC2 instances get public DNS hostnames and use the VPC's Route 53 Resolver (CIDR+2 address). Resolution order: (1) Route 53 Resolver rules (if matched), (2) Route 53 Private Hosted Zones (if associated), (3) VPC DNS resolution for instances, (4) Public DNS for everything else. Private Hosted Zones require VPC association and can be shared cross-account.

---

### Card 27
**Q:** How do you associate a Route 53 Private Hosted Zone with VPCs in other accounts?
**A:** You cannot associate cross-account via the console. Use the CLI/SDK: (1) In the hosted zone account, call `create-vpc-association-authorization` to authorize the VPC. (2) In the VPC account, call `associate-vpc-with-hosted-zone` to complete the association. (3) Optionally, delete the authorization after association. Alternatively, use Route 53 Profiles to manage and share collections of hosted zone associations across accounts.

---

### Card 28
**Q:** What is AWS Directory Service and what options does it provide?
**A:** AWS Directory Service offers three options: (1) **AWS Managed Microsoft AD** – full Microsoft AD managed by AWS in your VPC. Supports trusts with on-premises AD, MFA, Group Policies, schema extensions. (2) **AD Connector** – proxy that redirects directory requests to on-premises AD. No caching, requires persistent network connectivity. (3) **Simple AD** – Samba 4-based standalone directory for basic AD features. Cannot establish trusts with Microsoft AD. Choose Managed AD for hybrid, AD Connector for proxy, Simple AD for basic standalone.

---

### Card 29
**Q:** When would you use AWS Managed Microsoft AD vs. AD Connector?
**A:** Use **Managed Microsoft AD** when: you need a true AD in AWS, require trust relationships with on-premises AD, need schema extensions, want MFA support, need AD even if VPN/DX fails. Use **AD Connector** when: you want to use existing on-premises AD, don't need AD objects in AWS, want to minimize AD footprint, need simple proxy for AWS console SSO or WorkSpaces. AD Connector requires reliable on-prem connectivity; if connection drops, authentication fails.

---

### Card 30
**Q:** What is AWS IAM Identity Center (formerly AWS SSO)?
**A:** IAM Identity Center provides centralized SSO access to multiple AWS accounts and business applications. Features: integrates with Organizations for multi-account access, supports SAML 2.0 apps, built-in identity store or external IdP (Okta, Azure AD, Managed AD), permission sets define access levels, attribute-based access control (ABAC), and one-click access to console/CLI. It's the recommended approach for managing human access to AWS.

---

### Card 31
**Q:** What are permission sets in IAM Identity Center?
**A:** Permission sets are collections of IAM policies that define access to AWS accounts. When assigned to a user/group for specific accounts, they create IAM roles in those accounts automatically. Types: AWS managed policies (e.g., ViewOnlyAccess), customer managed policies (reference policies in target accounts), inline policies, and permissions boundaries. Maximum 20 permission sets per account assignment. Session duration is configurable (1-12 hours).

---

### Card 32
**Q:** How does SAML 2.0 federation work with AWS?
**A:** SAML 2.0 federation allows on-premises users to access AWS without IAM users. Flow: (1) User authenticates with corporate IdP (e.g., ADFS). (2) IdP returns SAML assertion with attributes/roles. (3) User's browser posts assertion to AWS STS `AssumeRoleWithSAML`. (4) STS returns temporary credentials. (5) User accesses AWS console or API. Requires: IAM SAML identity provider, IAM role with trust policy for SAML, and IdP configuration with AWS as relying party.

---

### Card 33
**Q:** What is the difference between SAML 2.0 federation and Web Identity Federation?
**A:** **SAML 2.0**: Enterprise identity federation using corporate IdPs (ADFS, Okta, Ping). Returns SAML assertions. Uses `AssumeRoleWithSAML`. For internal workforce access to AWS. **Web Identity Federation**: Uses social/web IdPs (Google, Facebook, Amazon, any OIDC provider). Returns JWT tokens. Uses `AssumeRoleWithWebIdentity`. For external user (customer) access to AWS resources. Amazon Cognito is the recommended approach for web identity federation.

---

### Card 34
**Q:** What is Amazon Cognito and its two components?
**A:** Cognito provides identity services for web/mobile apps. (1) **User Pools** – user directory for sign-up/sign-in. Supports MFA, email/phone verification, social IdP federation, SAML/OIDC federation, customizable UI, Lambda triggers. Returns JWT tokens. (2) **Identity Pools** (Federated Identities) – provides temporary AWS credentials for accessing AWS services. Maps authenticated/unauthenticated users to IAM roles. User Pools handle authentication; Identity Pools handle authorization to AWS resources.

---

### Card 35
**Q:** How do Cognito User Pools and Identity Pools work together?
**A:** Typical flow: (1) User authenticates against Cognito User Pool and receives JWT tokens (ID token, access token, refresh token). (2) Application exchanges the User Pool token with Cognito Identity Pool. (3) Identity Pool validates the token and calls STS to get temporary AWS credentials (access key, secret key, session token). (4) User accesses AWS services (S3, DynamoDB, API Gateway) using those credentials. Identity Pools support role mapping based on claims.

---

### Card 36
**Q:** What is the confused deputy problem and how does AWS mitigate it?
**A:** The confused deputy occurs when a less-privileged entity tricks a more-privileged service into performing unauthorized actions. Example: Service A accesses your resources via a role; an attacker provides A with a different customer's role ARN. Mitigation: use **`aws:SourceArn`** and **`aws:SourceAccount`** condition keys in trust policies and resource policies. The `ExternalId` condition in IAM roles also prevents this in cross-account scenarios (required by STS when third parties assume roles).

---

### Card 37
**Q:** What is the `ExternalId` in IAM cross-account role assumption?
**A:** ExternalId is a secret value agreed upon between the trusting account and the trusted entity (typically a third-party SaaS provider). It's included as a condition in the role's trust policy and must be provided in the `AssumeRole` call. It prevents the confused deputy problem: even if an attacker knows the role ARN, they can't assume it without the ExternalId. Not needed for cross-account roles between your own accounts—only for third-party access.

---

### Card 38
**Q:** What is AWS CloudTrail and its key features for governance?
**A:** CloudTrail records API calls (management events and optionally data events) for audit, compliance, and governance. Key features: enabled by default (90-day event history), organization trail for all accounts, S3 delivery with optional encryption, CloudWatch Logs integration, EventBridge integration for real-time alerting, Insights for detecting unusual activity, Lake for SQL-based querying. Management events are free for one trail; data events have per-event charges.

---

### Card 39
**Q:** What is the difference between CloudTrail management events and data events?
**A:** **Management events** (control plane): operations on AWS resources like CreateBucket, RunInstances, AttachRolePolicy. Logged by default. Subdivided into read/write. **Data events** (data plane): operations on data within resources like S3 GetObject/PutObject, Lambda Invoke, DynamoDB GetItem/PutItem. NOT logged by default due to high volume. Must be explicitly enabled per resource type. Data events incur additional charges.

---

### Card 40
**Q:** How do you create an organization-wide CloudTrail trail?
**A:** Create a trail in the management account and enable "Apply trail to my organization." This creates the trail in all member accounts. The trail delivers logs to a central S3 bucket in the management/logging account. The S3 bucket policy must allow writes from all member account IDs. Member accounts can see the trail but cannot modify or delete it. Best practice: use a dedicated logging account (not the management account) for the S3 bucket.

---

### Card 41
**Q:** What is CloudTrail Lake and how does it differ from standard CloudTrail?
**A:** CloudTrail Lake is a managed data lake for CloudTrail events that allows SQL-based querying without S3 + Athena setup. It stores events in event data stores (up to 7 years retention). Supports aggregation across accounts/organizations, custom integrations (non-AWS events), and dashboards. Unlike standard trails (which deliver JSON logs to S3), Lake provides an integrated query engine. Pricing is based on ingestion and storage, which is more expensive than S3 + Athena for large volumes.

---

### Card 42
**Q:** What is AWS Config and how does it support compliance?
**A:** AWS Config records and evaluates resource configurations over time. It maintains a configuration history, enabling point-in-time queries and change tracking. **Config Rules** evaluate resources for compliance (managed rules or custom Lambda). **Conformance Packs** bundle multiple rules as a compliance framework. **Aggregator** collects data across accounts/regions. **Remediation** via SSM Automation documents can auto-fix non-compliant resources. Config is per-region and must be enabled explicitly.

---

### Card 43
**Q:** What is the difference between AWS Config rules and SCPs for compliance?
**A:** **SCPs** are preventive—they block actions before they happen (deny API calls). They work at the Organizations level and cannot be overridden by IAM. **Config rules** are detective—they evaluate resources after creation and flag non-compliance. They can trigger auto-remediation but don't prevent the action. Use SCPs to prevent prohibited actions (e.g., deny certain regions), and Config rules to detect and remediate drift (e.g., unencrypted volumes).

---

### Card 44
**Q:** What is AWS Config Aggregator?
**A:** Config Aggregator collects Config data from multiple accounts and regions into a single account. Two modes: (1) **Organization aggregator** – automatically collects from all accounts in the Organization (no per-account authorization needed). (2) **Individual account aggregator** – requires each source account to authorize the aggregator. Useful for a centralized compliance dashboard. Aggregation is read-only—you still manage rules in individual accounts. Data is aggregated, not duplicated.

---

### Card 45
**Q:** What is AWS Audit Manager?
**A:** Audit Manager helps continuously audit AWS usage to assess compliance with regulations and standards. It automates evidence collection from AWS services (Config, CloudTrail, Security Hub). Provides pre-built frameworks: SOC 2, PCI DSS, GDPR, HIPAA, CIS Benchmarks, NIST. You can create custom frameworks. Evidence is organized into assessments linked to controls. Generates audit-ready reports. Reduces manual evidence gathering effort for compliance teams.

---

### Card 46
**Q:** What is AWS Service Catalog and its key concepts?
**A:** Service Catalog lets admins create and manage approved portfolios of IT products (CloudFormation templates, Terraform configs). Key concepts: **Portfolio** – collection of products with access controls. **Product** – CloudFormation/Terraform template with versions. **Provisioned Product** – running instance of a product. **Constraints** – launch constraints (IAM role for provisioning), template constraints (limit parameters), notification constraints. Enables self-service provisioning with governance. Can share portfolios across accounts via Organizations.

---

### Card 47
**Q:** How does AWS Service Catalog enable self-service with governance?
**A:** Admins define approved products (CloudFormation templates) with constraints. End users see only approved products and can provision them without needing direct CloudFormation/IAM permissions. **Launch constraints** define which IAM role provisions resources, so users don't need broad permissions. **Template constraints** restrict parameter values (e.g., only certain instance types). **TagOptions** enforce tagging. This gives users autonomy while maintaining architectural and compliance guardrails.

---

### Card 48
**Q:** What is the AWS Well-Architected Framework and its pillars?
**A:** The Well-Architected Framework provides architectural best practices across six pillars: (1) **Operational Excellence** – operations as code, small changes, anticipate failure. (2) **Security** – identity foundation, traceability, defense in depth. (3) **Reliability** – auto recovery, scaling, change management. (4) **Performance Efficiency** – right resource selection, monitoring. (5) **Cost Optimization** – pay for what you use, measure efficiency. (6) **Sustainability** – minimize environmental impact. The Well-Architected Tool reviews workloads against these pillars.

---

### Card 49
**Q:** What is the shared responsibility model and how does it apply to different service types?
**A:** AWS and customer share security responsibilities. **AWS**: security OF the cloud (hardware, network, facilities, managed service infrastructure). **Customer**: security IN the cloud (data, IAM, OS/network config, encryption). For **IaaS** (EC2): customer manages OS, patching, firewall. For **PaaS** (RDS): AWS manages OS/patching; customer manages data, access. For **SaaS** (S3): AWS manages nearly everything; customer manages data, IAM, encryption config.

---

### Card 50
**Q:** What are tag policies in AWS Organizations?
**A:** Tag policies enforce standardized tags across an Organization. They define: allowed tag keys (case-sensitive), allowed values for tag keys, enforcement per resource type, and compliance reporting. Tag policies don't prevent untagged resource creation—they enforce tag value consistency when tags are applied. Use the Organizations tag policy console or CLI. Violations appear in tag policy compliance reports. Combine with SCPs for strict enforcement (e.g., deny actions without required tags).

---

### Card 51
**Q:** What is a delegated administrator in AWS Organizations?
**A:** A delegated administrator is a member account that's been granted administrative privileges for a specific AWS service on behalf of the Organization. This avoids using the management account for day-to-day administration. Services supporting delegation include: Config, GuardDuty, Security Hub, Firewall Manager, IAM Identity Center, Detective, Macie, CloudFormation StackSets, and more. The management account designates delegates via `register-delegated-administrator` API.

---

### Card 52
**Q:** What are backup policies in AWS Organizations?
**A:** Backup policies let you centrally manage AWS Backup plans across your Organization. Defined at the Organization, OU, or account level, they're inherited and merged through the hierarchy. They define: backup frequency, retention period, destination vault (including cross-region/cross-account vaults), lifecycle rules, and resource selection by tags. Backup policies are enforced via AWS Backup, ensuring all accounts maintain consistent backup strategies without per-account configuration.

---

### Card 53
**Q:** How does VPC Peering differ from Transit Gateway?
**A:** **VPC Peering**: point-to-point, non-transitive, no single point of failure, ~no bandwidth limit, lower cost (no per-hour or per-GB charge—only data transfer). **Transit Gateway**: hub-and-spoke, transitive, centralized management, supports VPN/DX, route tables for segmentation, but costs per attachment-hour and per-GB processed. Use peering for a few VPCs with high-bandwidth needs; use TGW for many VPCs needing transitive routing, centralized management, or hybrid connectivity.

---

### Card 54
**Q:** What is AWS PrivateLink and when should you use it?
**A:** PrivateLink provides private connectivity between VPCs, AWS services, and on-premises networks without traversing the public internet. Uses ENIs (interface VPC endpoints) within your VPC. Use cases: (1) Access AWS services privately (e.g., S3, DynamoDB via gateway endpoints are free; interface endpoints for other services). (2) Expose your service to other VPCs/accounts without VPC peering. (3) Connect to third-party SaaS on the AWS Marketplace. Traffic stays on the AWS network.

---

### Card 55
**Q:** What is the difference between Gateway VPC Endpoints and Interface VPC Endpoints?
**A:** **Gateway Endpoints**: free, only for S3 and DynamoDB. Added as a target in route tables. Cannot be accessed from on-premises or peered VPCs. **Interface Endpoints** (PrivateLink): cost per hour + per GB. Create ENIs in subnets. Support most AWS services. Can be accessed from on-premises (via DX/VPN) and peered VPCs. Support security groups. Use private DNS to transparently redirect traffic. Interface endpoints for S3 cost money but enable on-premises access via private IPs.

---

### Card 56
**Q:** How do you use VPC endpoints with S3 from on-premises?
**A:** Gateway endpoints for S3 are NOT accessible from on-premises. Use an **Interface endpoint** for S3 (PrivateLink), which creates ENIs with private IPs. On-premises traffic routes through DX/VPN to the VPC, then to the interface endpoint ENI, then privately to S3. Configure DNS resolution so that on-premises DNS resolves the S3 endpoint to the interface endpoint's private IPs. This keeps S3 traffic entirely private.

---

### Card 57
**Q:** What is AWS Firewall Manager and when would you use it?
**A:** Firewall Manager centrally configures and manages firewall rules across accounts in an Organization. Manages: WAF rules, Shield Advanced, Security Groups, Network Firewall, Route 53 Resolver DNS Firewall, and third-party firewalls from Marketplace. Requires: AWS Organizations (all features), Config enabled. Use when: you need consistent security policies across many accounts, auto-apply rules to new accounts/resources, and centralized compliance reporting. Prerequisite: set a Firewall Manager admin account.

---

### Card 58
**Q:** What is AWS Network Firewall and where does it fit in the architecture?
**A:** Network Firewall is a managed stateful/stateless firewall for VPC traffic. It inspects traffic at the VPC perimeter (ingress/egress). Deployed in a dedicated firewall subnet. Supports: stateless rules (5-tuple), stateful rules (domain filtering, IPS via Suricata), and managed rule groups. Architecture: route traffic through firewall endpoints using VPC route tables. Integrates with Firewall Manager for multi-account deployment. Use for deep packet inspection, domain allow/deny lists, and IDS/IPS.

---

### Card 59
**Q:** What are the key networking limits to know for the exam?
**A:** Key limits: VPC CIDR blocks: 5 per VPC. Subnets per VPC: 200. Route tables per VPC: 200. Routes per table: 50 (can increase to 1,000). Security groups per ENI: 5. Rules per SG: 60 inbound + 60 outbound. NACLs per VPC: 200. Rules per NACL: 20. VPC peering connections per VPC: 125. TGW attachments: 5,000. Internet Gateways per VPC: 1. NAT Gateways per AZ: 5.

---

### Card 60
**Q:** What is AWS Control Tower Account Factory for Terraform (AFT)?
**A:** AFT extends Control Tower's Account Factory with Terraform-based provisioning and customization. It uses a Terraform pipeline (backed by CodePipeline/CodeBuild) to provision new accounts and apply customizations. Supports: account request via Terraform module, global customizations (all accounts), OU-specific customizations, and account-specific customizations. Each customization step runs independently. AFT uses a dedicated AFT management account separate from the Control Tower management account.

---

### Card 61
**Q:** How do you implement a centralized logging architecture across multiple accounts?
**A:** Best practice pattern: (1) Create a dedicated logging account (not management account). (2) Create S3 buckets with bucket policies allowing member accounts. (3) Enable organization CloudTrail trail delivering to the logging account. (4) Stream VPC Flow Logs, Config, GuardDuty findings to the logging account via cross-account roles or organization-level settings. (5) Use CloudWatch cross-account observability for metrics/logs. (6) Apply S3 Object Lock or Glacier Vault Lock for immutability. (7) Use Athena or OpenSearch for analysis.

---

### Card 62
**Q:** What is the difference between AWS Organizations consolidated billing and individual account billing?
**A:** **Consolidated billing**: single payment method for all accounts, combined usage for volume discounts (S3, EC2), shared RI/Savings Plan benefits across accounts, one bill. **Individual billing**: each account has its own payment method and bill, no shared discounts. Consolidated billing is automatic with Organizations. Key benefit: RI and Savings Plan sharing—an RI purchased in one account can apply to matching usage in any account (unless sharing is disabled).

---

### Card 63
**Q:** How do Reserved Instance and Savings Plan benefits share across an Organization?
**A:** By default, RI and Savings Plan discounts apply to any matching usage across all linked accounts in the Organization. The management account can disable sharing for specific accounts via the Billing console. Sharing logic: first applies to the purchasing account, then surplus applies to other accounts. If you need cost isolation, disable RI/SP sharing and attribute to specific accounts. Cost Explorer and CUR show blended vs. unblended costs.

---

### Card 64
**Q:** What is the recommended OU structure for AWS Organizations?
**A:** AWS-recommended OUs: **Security** – log archive, audit/security tooling. **Infrastructure** – shared networking, DNS, directory services. **Sandbox** – experimentation with low spending limits. **Workloads** – sub-OUs for Prod and Non-Prod. **Policy Staging** – test SCPs before applying to production. **Suspended** – accounts pending closure. **Deployments** – CI/CD tools. **Transitional** – accounts being migrated. Additional OUs per business unit or compliance boundary as needed.

---

### Card 65
**Q:** What is AWS CloudFormation StackSets and how does it support multi-account governance?
**A:** StackSets deploy CloudFormation stacks across multiple accounts and regions from a single template. **Service-managed StackSets** integrate with Organizations to automatically deploy to new accounts when they join an OU. Use cases: deploy Config rules, CloudTrail, GuardDuty, security baselines, or IAM roles across all accounts. Supports auto-deployment on OU membership changes, concurrent deployments, failure tolerance configuration, and drift detection.

---

### Card 66
**Q:** What is the IAM policy evaluation logic?
**A:** Evaluation order: (1) If any applicable **Deny** exists → DENY. (2) If an **SCP** applies and doesn't allow → DENY. (3) If a **resource-based policy** allows and entity is in same account → ALLOW. (4) If no applicable **Allow** in identity-based policies → DENY. (5) If a **permissions boundary** doesn't allow → DENY. (6) If a **session policy** (for assumed roles) doesn't allow → DENY. (7) Otherwise → ALLOW. Cross-account: both the identity policy AND resource policy must allow (unless using resource-based policy with specific principal).

---

### Card 67
**Q:** What are IAM permissions boundaries?
**A:** Permissions boundaries set the maximum permissions an IAM entity (user or role) can have. They're IAM policies attached as a boundary, not as permissions. The effective permissions are the intersection of identity-based policies AND the permissions boundary. Use case: allow developers to create IAM roles but restrict those roles' maximum permissions (prevent privilege escalation). Combine with SCPs for organization-level boundaries and permissions boundaries for delegation boundaries.

---

### Card 68
**Q:** How does AWS IAM Access Analyzer work?
**A:** IAM Access Analyzer identifies resources shared with external entities. It analyzes resource-based policies on: S3 buckets, IAM roles, KMS keys, Lambda functions, SQS queues, Secrets Manager secrets. **Findings** show resources accessible from outside your account/Organization. It also validates IAM policies against best practices and generates least-privilege policies based on CloudTrail activity. Can be set at account level (external access) or organization level (cross-account access analysis).

---

### Card 69
**Q:** What is the difference between AWS SSO (IAM Identity Center) and Cognito for identity management?
**A:** **IAM Identity Center**: for workforce identity—employees/contractors accessing AWS accounts and business apps. Integrates with Organizations. Provides SSO to AWS console/CLI and SAML apps. Uses corporate directory (AD, external IdP). **Cognito**: for customer identity—end users of web/mobile apps. Provides sign-up/sign-in, social federation, and temporary AWS credentials for accessing AWS resources from apps. Different audiences: internal workforce vs. external customers.

---

### Card 70
**Q:** What are the key features of Amazon Cognito User Pools?
**A:** User Pools features: hosted sign-up/sign-in UI (customizable), MFA (TOTP, SMS), email/phone verification, password policies, account recovery, Lambda triggers (pre/post authentication, migration, custom messages), social IdP federation (Google, Facebook, Apple, Amazon), SAML/OIDC federation, advanced security (adaptive authentication, compromised credential detection), groups with IAM role mapping, custom attributes, and token customization via Lambda.

---

### Card 71
**Q:** What is AWS Security Hub?
**A:** Security Hub provides a centralized security dashboard aggregating findings from GuardDuty, Inspector, Macie, Firewall Manager, IAM Access Analyzer, Systems Manager, and third-party tools. Runs automated compliance checks against standards: CIS AWS Foundations, PCI DSS, AWS Foundational Security Best Practices, NIST 800-53. Findings use AWS Security Finding Format (ASFF). Supports cross-account aggregation via Organizations. Can trigger automated remediation via EventBridge + Lambda/SSM.

---

### Card 72
**Q:** How do you implement a multi-region, multi-account security architecture?
**A:** Pattern: (1) Dedicated security account as GuardDuty, Security Hub, and Macie delegated admin. (2) Enable these services Organization-wide with auto-enable for new accounts. (3) Aggregate findings to the security account. (4) CloudTrail organization trail to logging account. (5) Config aggregator in security account. (6) Firewall Manager for WAF/Shield/SG policies. (7) EventBridge rules for real-time alerting to SNS/Lambda. (8) Security Hub custom actions for incident response. (9) Detective for investigation.

---

### Card 73
**Q:** What is VPC Flow Logs and how do you use them for security monitoring?
**A:** VPC Flow Logs capture IP traffic metadata for network interfaces. Levels: VPC, subnet, or ENI. Destinations: CloudWatch Logs, S3, or Kinesis Data Firehose. Logged fields include: source/dest IPs, ports, protocol, packets, bytes, action (ACCEPT/REJECT), and more (custom formats in v5). For security: analyze rejected traffic patterns, detect port scanning, monitor unusual data transfers. Query with Athena (S3), CloudWatch Insights, or feed to SIEM. Flow Logs don't capture packet payloads.

---

### Card 74
**Q:** What is AWS Trusted Advisor and what categories does it cover?
**A:** Trusted Advisor inspects your AWS environment and provides recommendations in five categories: (1) **Cost Optimization** – idle resources, underutilized instances. (2) **Performance** – overutilized resources, service limits. (3) **Security** – open security groups, MFA on root, public S3 buckets. (4) **Fault Tolerance** – no backups, single-AZ deployments. (5) **Service Limits** – approaching quotas. Basic/Developer support: 7 core checks. Business/Enterprise support: all checks + API access + CloudWatch integration.

---

### Card 75
**Q:** What is the difference between preventive and detective controls in AWS?
**A:** **Preventive controls** stop non-compliant actions before they happen: SCPs (deny actions), IAM policies (deny permissions), VPC NACLs (deny traffic), permissions boundaries. **Detective controls** identify non-compliance after it occurs: Config rules, CloudTrail analysis, GuardDuty threat detection, Security Hub compliance checks, VPC Flow Logs analysis. Best practice: layer both—prevent what you can, detect everything else. AWS Control Tower uses both.

---

### Card 76
**Q:** What is AWS License Manager?
**A:** License Manager helps manage software licenses (Microsoft, Oracle, SAP) across AWS and on-premises. Features: define licensing rules (vCPU, socket, instance counts), enforce limits via launch constraints, track usage, automated discovery of software on EC2 instances. Supports: BYOL (Bring Your Own License), license-included AMIs, cross-account license sharing via Organizations/RAM. Integrates with Service Catalog and Systems Manager. Helps prevent license violations.

---

### Card 77
**Q:** What is Amazon Detective?
**A:** Amazon Detective analyzes and visualizes security data to investigate potential security issues. It automatically collects data from CloudTrail, VPC Flow Logs, GuardDuty findings, and EKS audit logs. Uses graph models to show relationships between resources, IP addresses, and API calls. Helps answer: "What happened? When? Who was involved? What resources were affected?" Use Detective for root cause analysis after GuardDuty/Security Hub identifies a finding. Organization-wide deployment via delegated admin.

---

### Card 78
**Q:** What is AWS Systems Manager Session Manager and how does it support zero-trust access?
**A:** Session Manager provides shell access to EC2 instances (and on-premises) without SSH keys, open inbound ports (22/3389), or bastion hosts. Uses the SSM Agent (pre-installed on Amazon Linux/Windows AMIs). Traffic goes through the SSM service endpoint (over HTTPS). Features: full audit logging to CloudTrail/S3/CloudWatch, session encryption via KMS, IAM-based access control, port forwarding. Supports zero-trust by eliminating need for VPN and inbound firewall rules.

---

### Card 79
**Q:** What is the purpose of an AWS Security Account (audit account) in a multi-account strategy?
**A:** The security/audit account serves as the central hub for security operations. It: (1) Hosts GuardDuty admin (delegated). (2) Hosts Security Hub aggregation. (3) Hosts Macie admin. (4) Contains Config aggregator. (5) Runs Detective. (6) Contains cross-account IAM roles for incident response. (7) Hosts security automation (Lambda, Step Functions). (8) Receives security notifications (SNS). This account should have restricted access—only the security team—and is separate from the logging account (which stores immutable logs).

---

### Card 80
**Q:** What are AWS Organizations AI services opt-out policies?
**A:** AI services opt-out policies let you control whether AWS AI services can store and use your content for service improvement. When enabled, services like Lex, Polly, Rekognition, Comprehend, etc., will NOT use your content to improve their models. Applied at Organization, OU, or account level. Inherited through the hierarchy. Important for compliance (GDPR, HIPAA) where data usage must be controlled. Does NOT affect the functionality of the services themselves.

---

### Card 81
**Q:** How do you implement cross-account access to KMS keys?
**A:** Two steps required: (1) **Key policy** in the key's account must allow the external account/principal. Include statements allowing: `kms:CreateGrant`, `kms:DescribeKey`, `kms:Encrypt`, `kms:Decrypt`, `kms:ReEncrypt*`, `kms:GenerateDataKey*` for the external principal. (2) **IAM policy** in the external account must allow the same KMS actions on the key ARN. Both the key policy AND the IAM policy must permit access. Alternatively, use KMS grants for temporary delegated access.

---

### Card 82
**Q:** What is the AWS Shared Responsibility Model for managed services like RDS?
**A:** For RDS, **AWS manages**: underlying EC2 instance OS, database engine patching, automated backups, high availability (Multi-AZ), hardware/networking, storage management. **Customer manages**: database configurations (parameter groups), IAM database authentication, security group rules, encryption configuration, managing users/permissions within the database, query optimization, and choosing appropriate instance types. Similar split applies to other managed services with varying division lines.

---

### Card 83
**Q:** What is VPC IPAM (IP Address Manager)?
**A:** VPC IPAM helps plan, track, and monitor IP addresses at scale across accounts and regions. Features: centralized IP address pool management, automated CIDR allocation to VPCs, prevent overlapping CIDRs, compliance checks for IP usage, integration with Organizations for multi-account management, support for BYOIP. Administrators define pools with CIDR ranges; developers request allocations from pools. Ensures consistent IP addressing and prevents conflicts, especially critical in hybrid networks with on-premises integration.

---

### Card 84
**Q:** What is the difference between horizontal and vertical scaling, and when is each appropriate?
**A:** **Vertical scaling** (scale up): increase instance size (e.g., m5.large → m5.xlarge). Pros: simple, no code changes. Cons: limits exist, requires downtime (usually), single point of failure. **Horizontal scaling** (scale out): add more instances. Pros: theoretically unlimited, resilient, no downtime. Cons: requires stateless design, load balancer, more complex architecture. Horizontal scaling is preferred for exam answers. Vertical for: databases (write-primary), legacy apps that can't distribute.

---

### Card 85
**Q:** How do you design cross-region replication for disaster recovery?
**A:** Key components: (1) **S3** Cross-Region Replication (CRR) for objects. (2) **RDS** cross-region read replicas or Aurora Global Database. (3) **DynamoDB** Global Tables for multi-region active-active. (4) **EBS snapshots** copied cross-region. (5) **AMIs** copied cross-region. (6) **Route 53** health checks with failover routing. (7) **CloudFormation StackSets** for infrastructure replication. (8) **S3** for CloudFormation template storage. Design trade-offs: RPO/RTO requirements, cost, complexity, data consistency model.

---

### Card 86
**Q:** What is the AWS Acceptable Use Policy's relevance to Solutions Architects?
**A:** Solutions Architects must design within AWS's Acceptable Use Policy constraints. Key restrictions: no network abuse (DDoS, port scanning without authorization), no unsolicited bulk messaging, must comply with penetration testing rules (automatic approval for some services, request needed for others). Architects must ensure designs comply with these policies and relevant regulations (GDPR, HIPAA, PCI DSS). AWS provides compliance documentation via Artifact.

---

### Card 87
**Q:** What is AWS Artifact?
**A:** Artifact provides on-demand access to AWS security and compliance reports and select online agreements. Reports include: SOC 1/2/3, PCI DSS attestation, ISO 27001/27017/27018, FedRAMP, HIPAA BAA, GDPR DPA. Two sections: **Artifact Reports** – download compliance documents. **Artifact Agreements** – review and accept agreements (BAA for HIPAA, DPA for GDPR) for individual accounts or Organization-wide. Essential for compliance teams and auditors needing evidence of AWS's own compliance.

---

### Card 88
**Q:** What are the key differences between Network ACLs and Security Groups?
**A:** **Security Groups**: stateful (return traffic automatically allowed), operates at ENI level, allow rules only (no deny), evaluates all rules, default: deny all inbound/allow all outbound. **NACLs**: stateless (must explicitly allow return traffic), operates at subnet level, allow AND deny rules, rules evaluated in order (lowest number first), default: allow all. Key exam tips: use NACLs to block specific IPs; use Security Groups for application-level access control.

---

### Card 89
**Q:** How do you implement a multi-account networking pattern using Transit Gateway and shared VPCs?
**A:** Pattern: (1) Central networking account owns TGW and shared VPCs. (2) Share TGW via RAM to member accounts. (3) Share VPC subnets via RAM for workloads needing shared networking. (4) Each workload account can also have its own VPC attached to TGW. (5) Use TGW route tables for segmentation (production isolated from dev). (6) Centralized egress through a shared egress VPC with NAT gateways. (7) Centralized ingress through a shared ingress VPC with ALBs. This reduces cost and operational complexity.

---

### Card 90
**Q:** What is AWS Network Manager?
**A:** Network Manager provides a centralized dashboard for managing and monitoring global networks. It visualizes your Transit Gateways, VPNs, Direct Connect, and SD-WAN connectivity. Features: topology view, route analysis, network change events, CloudWatch metrics integration, and integration with third-party SD-WAN devices. Use it to monitor health and performance of hybrid networks spanning multiple regions and on-premises sites. Helps with troubleshooting connectivity issues.

---

### Card 91
**Q:** What are the key decisions when choosing between VPN and Direct Connect?
**A:** **Choose VPN** when: need quick setup (minutes), budget-constrained, acceptable latency variability, backup for DX, traffic < 1.25 Gbps per tunnel. **Choose DX** when: need consistent latency, high throughput (up to 100 Gbps), large data transfers (cheaper than internet), regulatory requirements for dedicated connectivity, need SLA guarantees. **Common pattern**: DX primary + VPN backup for cost-effective resilience. VPN over DX gives both dedicated connection and encryption.

---

### Card 92
**Q:** What is the difference between AWS Managed AD trust types?
**A:** AWS Managed Microsoft AD supports: (1) **Forest Trust** – trust between the AWS AD forest and on-premises AD forest. Enables users from either directory to access resources in the other. One-way or two-way. (2) **External Trust** – trust to a specific domain (not entire forest). Use when: only one domain relationship needed or forest trust isn't feasible. Forest trusts support Kerberos authentication across the trust; external trusts use NTLM. Trust types must match on-premises AD configuration.

---

### Card 93
**Q:** How does AWS CloudTrail Insights work?
**A:** CloudTrail Insights detects unusual API activity by analyzing write management events. It establishes a baseline of normal API call patterns (volumes) over 7 days, then flags deviations. Examples: sudden spike in `RunInstances` calls, unusual `DeleteBucket` activity. Insights generates events in CloudTrail when anomalies start and stop. These can trigger EventBridge rules for alerting. Insights does NOT analyze data events. Additional per-event charges apply. Useful for detecting compromised credentials or operational issues.

---

### Card 94
**Q:** What is AWS Resource Groups and Tag Editor?
**A:** Resource Groups organize AWS resources using tags or CloudFormation stack membership. Create groups to manage, monitor, and automate actions on collections of resources. **Tag-based groups**: dynamic membership based on tag queries. **CloudFormation-based groups**: resources from a specific stack. **Tag Editor**: bulk edit tags across resources/regions. Use with Systems Manager to apply automation (patching, inventory) to resource groups. Combine with tag policies for organizational governance.

---

### Card 95
**Q:** What is the Landing Zone concept and how does Control Tower implement it?
**A:** A Landing Zone is a pre-configured, secure, multi-account AWS environment. Control Tower's Landing Zone includes: management account, log archive account, audit account, Security OU, Sandbox OU, identity configuration (IAM Identity Center), organization CloudTrail, guardrails, Account Factory, and centralized logging. It implements AWS best practices automatically. Alternatives to Control Tower: custom landing zone using CloudFormation/Terraform (for organizations needing more customization).

---

### Card 96
**Q:** What is Amazon Macie and its role in organizational governance?
**A:** Macie uses machine learning to discover, classify, and protect sensitive data (PII, financial data, credentials) stored in S3 buckets. Features: automated S3 bucket inventory across accounts, sensitive data discovery jobs, custom data identifiers (regex-based), policy findings (public buckets, unencrypted, shared access), and integration with Security Hub/EventBridge. Organization-wide deployment via delegated admin. Essential for GDPR/HIPAA compliance—helps identify where sensitive data lives.

---

### Card 97
**Q:** How does the IAM Identity Center authentication flow work with an external IdP?
**A:** Flow: (1) User navigates to the IAM Identity Center portal URL. (2) IAM Identity Center redirects to the external IdP (Okta, Azure AD) for authentication. (3) User authenticates with IdP (password + MFA). (4) IdP returns SAML assertion to IAM Identity Center. (5) IAM Identity Center lists available accounts/permission sets. (6) User selects an account/role. (7) IAM Identity Center calls STS to assume the corresponding IAM role. (8) User gets console access or CLI credentials (temporary). All in one SSO portal.

---

### Card 98
**Q:** What is the recommended approach for managing root user access in a multi-account Organization?
**A:** Best practices: (1) Enable MFA on all root users (hardware MFA for management account). (2) Don't use root user for daily tasks. (3) Use SCP to deny all root user actions in member accounts (except specific actions that only root can do). (4) Centralize root user email addresses using a distribution list or +alias pattern. (5) Rotate root credentials regularly. (6) Use IAM Identity Center for all human access. (7) Monitor root sign-in via CloudTrail + EventBridge alerting.

---

### Card 99
**Q:** What is AWS Control Tower lifecycle events?
**A:** Control Tower emits lifecycle events to EventBridge when changes occur: `CreateManagedAccount` (new account created), `UpdateManagedAccount`, `EnableGuardrail`, `DisableGuardrail`, `RegisterOrganizationalUnit`, `DeregisterOrganizationalUnit`, `SetupLandingZone`, `UpdateLandingZone`. Use these events to trigger custom automation: additional account configuration, notifications, CMDB updates, or third-party integration. They enable extensibility beyond Control Tower's built-in customizations.

---

### Card 100
**Q:** What is the difference between AWS Config Conformance Packs and AWS Security Hub standards?
**A:** **Config Conformance Packs**: bundles of Config rules + remediation actions deployed as a unit. Custom or AWS sample packs (e.g., Operational Best Practices for HIPAA). Deployed per account/region or via Organization. Focus on resource configuration compliance. **Security Hub Standards**: pre-built compliance frameworks (CIS, PCI, NIST) that run automated checks. Aggregate findings across services (not just Config). Focus on broader security posture. Use both together: Config for resource-level compliance, Security Hub for aggregated security view.

---

### Card 101
**Q:** What is AWS Private Certificate Authority (Private CA)?
**A:** AWS Private CA is a managed private CA for issuing and managing private SSL/TLS certificates within your organization. Use cases: internal services mutual TLS, IoT device certificates, code signing. Features: X.509 certificate issuance, CRL (Certificate Revocation List) distribution, integrates with ACM for deployment, supports certificate templates, and audit via CloudTrail. Cross-account sharing via RAM. Costs: per CA per month + per certificate issued. Cheaper than managing your own PKI infrastructure.

---

### Card 102
**Q:** When should you use AWS Organizations delegated administrator vs. cross-account IAM roles?
**A:** Use **delegated administrator** when: an AWS service natively supports it (GuardDuty, Security Hub, Config, etc.), you want Organization-wide management from a non-management account, and you need automatic member account enrollment. Use **cross-account IAM roles** when: the service doesn't support delegation, you need custom automation across accounts, or you need more granular per-account access control. Delegated admin is the preferred pattern for supported services to keep the management account minimal.

---

### Card 103
**Q:** What is the AWS Compute Optimizer?
**A:** Compute Optimizer analyzes utilization metrics and recommends optimal AWS resource configurations. Covers: EC2 instances (type/size), EBS volumes (type/size), Lambda functions (memory), Auto Scaling groups, ECS services on Fargate, and commercial software licenses. Uses machine learning on CloudWatch metrics. Provides: over-provisioned, under-provisioned, or optimized findings. Enhanced infrastructure metrics available with paid tier (3 months history vs. 14 days). Requires opt-in; Organization-level enrollment available.

---

### Card 104
**Q:** How do you implement a centralized internet egress pattern for multiple VPCs?
**A:** Pattern: (1) Create a shared egress VPC with NAT Gateways and optional Network Firewall. (2) Attach all VPCs to a Transit Gateway. (3) In workload VPCs, set default route (0.0.0.0/0) pointing to TGW. (4) In the egress VPC, route TGW traffic to NAT Gateway. (5) NAT Gateway sends traffic to Internet Gateway. Benefits: single point for egress monitoring/filtering, shared NAT costs, consistent egress policies. Add Network Firewall for inspection. This is cheaper than NAT Gateways in every VPC.

---

### Card 105
**Q:** What is AWS Route 53 Resolver DNS Firewall?
**A:** Route 53 Resolver DNS Firewall filters outbound DNS queries from your VPCs. You create rules that: block DNS queries to known malicious domains, allow queries to trusted domains, or alert on suspicious queries. Uses domain lists (managed by AWS or custom). Rule groups are associated with VPCs and evaluated in priority order. Protects against DNS exfiltration (tunneling). Can be managed centrally via Firewall Manager across an Organization. Available at no additional charge beyond standard Route 53 Resolver pricing.

---

### Card 106
**Q:** What is AWS IAM Roles Anywhere?
**A:** IAM Roles Anywhere lets on-premises workloads obtain temporary AWS credentials using X.509 certificates from a corporate PKI. Instead of long-lived access keys, on-premises servers authenticate with their existing certificates. Flow: create a trust anchor (CA certificate), create a profile mapping certificates to IAM roles, on-premises workload presents certificate and receives temporary credentials via STS. Benefits: eliminates long-lived keys, leverages existing PKI, enables least-privilege for on-premises/hybrid workloads.

---

### Card 107
**Q:** How do you design a network for a highly regulated workload across multiple accounts?
**A:** Architecture: (1) Dedicated VPC in an isolated account with no internet access. (2) VPC endpoints for AWS service access (no internet gateway). (3) Network Firewall for traffic inspection. (4) Transit Gateway with isolated route table (no default route). (5) AWS PrivateLink for internal service communication. (6) VPC Flow Logs to centralized logging. (7) Config rules for network compliance. (8) SCPs blocking internet gateway creation. (9) DNS Firewall for query filtering. (10) KMS encryption for all data flows.

---

### Card 108
**Q:** What is the difference between inter-region and intra-region VPC peering?
**A:** **Intra-region peering**: VPCs in the same region. No bandwidth limits, lowest latency, all traffic stays on AWS network. Data transfer: standard inter-AZ rates if across AZs, free within same AZ. **Inter-region peering**: VPCs in different regions. Traffic encrypted automatically, uses AWS backbone. Data transfer charges per GB (varies by region pair). Both: non-transitive, require route table entries, support security group referencing (intra-region only for SG references). No single point of failure.

---

### Card 109
**Q:** What is AWS Verified Access?
**A:** AWS Verified Access provides secure access to corporate applications without a VPN. It validates each access request against identity (corporate IdP) and device posture (MDM providers like Jamf, CrowdStrike) using Cedar policy language. Deployed as endpoints in front of ALBs or ENIs. Users access via HTTPS; no VPN client needed. Implements zero-trust network access (ZTNA). Each request is evaluated against policies—even authenticated users can be blocked based on device security posture. Integrates with IAM Identity Center.

---

### Card 110
**Q:** What is AWS Secrets Manager vs. AWS Systems Manager Parameter Store for secret management?
**A:** **Secrets Manager**: purpose-built for secrets. Automatic rotation (Lambda-based, native for RDS/Redshift/DocumentDB), cross-account sharing, replication to other regions, costs $0.40/secret/month + $0.05/10K API calls. **Parameter Store**: general-purpose. Standard tier is free (up to 10K parameters). Advanced tier supports policies and higher throughput. No native rotation (must use Lambda + EventBridge). For the exam: choose Secrets Manager when rotation or cross-account sharing is required; Parameter Store for non-secret config or budget constraints.

---

### Card 111
**Q:** What is the Principle of Least Privilege and how do you implement it at scale in AWS?
**A:** Grant only the minimum permissions required. Implementation at scale: (1) Use IAM Access Analyzer to generate policies from CloudTrail activity. (2) Start with broad policies, then tighten using Access Analyzer recommendations. (3) Use permissions boundaries for delegated IAM administration. (4) Implement SCPs as organizational guardrails. (5) Use IAM Identity Center with time-limited access. (6) Regular access reviews via IAM credential reports and Access Advisor (last-used data). (7) Automate policy generation and review in CI/CD pipelines.

---

### Card 112
**Q:** How does AWS Organizations handle account closure?
**A:** Account closure flow: (1) Member account enters "Suspended" state for 90 days. (2) During suspension, account resources may still incur charges (running EC2, etc.). (3) After 90 days, AWS permanently closes the account and deletes resources. Best practices: terminate all resources before closing, move the account to a "Suspended" OU with restrictive SCPs (deny all actions except what's needed for cleanup), disable all regions, and ensure no cross-account dependencies remain. Management account cannot be closed while it has member accounts.
