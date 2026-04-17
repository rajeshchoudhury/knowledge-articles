# AWS Certified Solutions Architect - Professional (SAP-C02) Practice Test 2

**Focus Areas:** Databases (Aurora, DynamoDB, Redshift), Direct Connect, ECS/EKS, KMS
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

A multinational bank is setting up a multi-account structure using AWS Organizations. They require that all data at rest in every account must be encrypted with customer-managed KMS keys, and the KMS key policies must be centrally managed from a security account. New accounts must automatically have the encryption baseline applied. No IAM principal in any member account should be able to create resources using AWS-managed keys.

Which approach provides the MOST comprehensive enforcement?

A. Create an SCP that denies all resource creation API calls unless the `kms:ViaService` condition is present and the `kms:CallerAccount` matches the security account.

B. Create SCPs that deny creating resources like EC2 volumes, RDS instances, and S3 buckets unless a customer-managed KMS key ARN from the security account is specified. Use CloudFormation StackSets to deploy the KMS key policies from the security account.

C. Create an AWS Config conformance pack with rules that check for encryption at rest on all supported resources. Deploy via the organization-level Config delegated administrator.

D. Use AWS Service Catalog to provide approved CloudFormation templates that always specify encryption. Restrict direct API access via SCPs.

**Correct Answer: B**

**Explanation:** SCPs provide preventive enforcement by denying resource creation without specifying customer-managed KMS keys. CloudFormation StackSets deploy consistent KMS key grants and policies from the security account to all member accounts automatically, including new ones. Option A's conditions are too broad and don't properly map to the requirement. Option C is detective, not preventive—resources can be created unencrypted. Option D restricts but developers need some flexibility, and Service Catalog alone doesn't prevent CLI/API usage.

---

### Question 2

A company is establishing AWS Direct Connect between their on-premises data center and AWS. They have production workloads requiring 10 Gbps dedicated bandwidth and need high availability with automatic failover. The company has two data centers 50 miles apart, each with access to different Direct Connect locations.

Which Direct Connect architecture provides the HIGHEST availability?

A. Establish one 10 Gbps dedicated connection from Data Center 1 to Direct Connect Location A. Configure a Site-to-Site VPN as backup.

B. Establish two 10 Gbps dedicated connections—one from each data center to different Direct Connect locations. Configure each connection with a private virtual interface to the same virtual private gateway with BGP routing.

C. Establish one 10 Gbps dedicated connection with two private virtual interfaces for redundancy.

D. Establish four dedicated connections—two from each data center to each Direct Connect location—for maximum resiliency. This follows the AWS recommended maximum resiliency model.

**Correct Answer: D**

**Explanation:** AWS's maximum resiliency model recommends separate connections from each on-premises location to two different Direct Connect locations, creating four independent paths. This protects against device failure, connection failure, Direct Connect location failure, and data center failure. Option A provides minimal redundancy with VPN as a lower-bandwidth backup. Option B provides high resiliency but only two connections—a single Direct Connect location failure could reduce capacity. Option C has a single point of failure at the physical connection level.

---

### Question 3

An organization needs to implement a cross-account encryption strategy where a central security account owns all KMS keys, but applications in 50 member accounts need to use these keys for encrypting S3 objects, EBS volumes, and RDS databases. Key administrators in the security account must retain full control, while member accounts should only have encrypt/decrypt permissions.

Which KMS configuration BEST implements this?

A. Create KMS keys in the security account. Add key grants for each member account's IAM roles that need encrypt/decrypt access. Use grants for temporary, programmatic access.

B. Create KMS keys in each member account and replicate the key policy from the security account.

C. Create KMS keys in the security account. Define key policies that allow member account root principals to use the key. In member accounts, create IAM policies that grant kms:Encrypt and kms:Decrypt for the cross-account key ARNs.

D. Create KMS multi-Region keys in the security account and replicate them to each member account for local access.

**Correct Answer: C**

**Explanation:** Cross-account KMS access requires both a key policy in the key-owning account (allowing the member account root) and an IAM policy in the member account (granting specific actions). This two-policy model gives the security account full control via key policies while member accounts manage their own users' access via IAM policies. Option A uses grants which are better for temporary/programmatic delegation but harder to manage at scale with 50 accounts. Option B defeats the purpose of centralized key management. Option D creates independent key material in each Region, not the same centralized keys.

---

### Question 4

A company has five development teams, each with their own AWS account in a Development OU. The teams need to create and manage DynamoDB tables, but they should not be able to create tables with provisioned capacity mode—only on-demand mode is allowed to prevent unexpected high-capacity provisioning costs. Tables with encryption using anything other than AWS-owned keys should also be blocked to reduce KMS costs.

Which approach enforces these restrictions?

A. Create an SCP attached to the Development OU that denies `dynamodb:CreateTable` unless the condition `dynamodb:BillingMode` equals `PAY_PER_REQUEST` and denies if encryption specification includes customer-managed or AWS-managed KMS keys.

B. Create IAM policies in each development account that only allow DynamoDB actions with on-demand billing.

C. Use AWS Service Catalog to provide a DynamoDB table product that only creates on-demand tables with default encryption.

D. Deploy AWS Config rules that detect provisioned capacity DynamoDB tables and automatically delete them.

**Correct Answer: A**

**Explanation:** An SCP at the Development OU level provides centralized, preventive enforcement that automatically applies to all development accounts. Using condition keys for billing mode and encryption ensures only compliant table configurations are created. Option B requires deploying policies to each account individually and doesn't apply to new accounts automatically. Option C restricts catalog-created resources but doesn't prevent direct API/CLI table creation. Option D is reactive—tables exist before deletion, potentially incurring costs.

---

### Question 5

A financial services firm needs to establish private, dedicated network connectivity from their on-premises data center to services in multiple VPCs across three AWS Regions (us-east-1, eu-west-1, ap-southeast-1). All traffic must remain private and never traverse the public internet. Each Region has a transit gateway connecting multiple VPCs.

Which Direct Connect architecture provides private multi-Region connectivity?

A. Establish a Direct Connect connection in each Region. Create private virtual interfaces to connect to each Region's transit gateway.

B. Establish a single Direct Connect connection. Create a transit virtual interface (transit VIF) to a Direct Connect Gateway. Associate the Direct Connect Gateway with the transit gateways in all three Regions.

C. Establish a single Direct Connect connection. Create three private virtual interfaces—one for each Region's VPC.

D. Use AWS Site-to-Site VPN over the internet to each Region's transit gateway for simplified connectivity.

**Correct Answer: B**

**Explanation:** A Direct Connect Gateway with a transit VIF can connect to transit gateways in multiple Regions through a single Direct Connect connection. This provides private connectivity to all VPCs across the three Regions through their respective transit gateways. Option A requires three separate Direct Connect connections—expensive and operationally complex. Option C private VIFs connect to VPGs (not transit gateways), limiting the architecture. Option D uses the public internet, violating the private connectivity requirement.

---

### Question 6

A company runs an ECS Fargate cluster with 50 microservices. Each service uses secrets (database credentials, API keys) stored in AWS Secrets Manager. The security team wants to ensure that each service can only access its own secrets, even if a container is compromised. They also need automated secret rotation without service downtime.

Which approach provides the MOST secure and maintainable solution?

A. Store all secrets in a single Secrets Manager secret as JSON key-value pairs. Grant all ECS task roles access to the single secret.

B. Create individual Secrets Manager secrets per service. Assign each ECS service a unique task execution role with an IAM policy granting access only to that service's specific secrets. Enable automatic rotation with rotation Lambda functions.

C. Store secrets in SSM Parameter Store as SecureString parameters. Reference them in ECS task definitions as environment variables.

D. Embed secrets in the container images during the build process. Rotate by building and deploying new images.

**Correct Answer: B**

**Explanation:** Individual secrets with per-service task execution roles enforce least-privilege access—a compromised container can only access its own secrets. Secrets Manager's native rotation with Lambda functions provides zero-downtime rotation by using staging labels (AWSCURRENT/AWSPENDING). ECS integrates natively with Secrets Manager for injecting secrets into containers. Option A gives every service access to all secrets—a single compromise exposes everything. Option C lacks native rotation support and Parameter Store is less suited for secrets requiring automated rotation. Option D embeds secrets in images, which is a security anti-pattern.

---

### Question 7

A logistics company needs to implement identity federation for 5,000 employees to access 40 AWS accounts. They use Active Directory on-premises. The company requires that AD group membership automatically maps to appropriate AWS roles and permissions in each account, and changes in AD groups are reflected within 1 hour.

Which identity federation architecture meets these requirements with the LEAST operational overhead?

A. Deploy AD Connector in AWS. Configure AWS IAM Identity Center (SSO) with AD Connector as the identity source. Create permission sets mapped to AD groups. Assign permission sets to accounts based on AD group membership.

B. Deploy AWS Managed Microsoft AD. Establish a trust with the on-premises AD. Configure IAM roles in each account with trust policies for SAML-based federation.

C. Set up ADFS on-premises. Configure SAML federation with each AWS account individually. Map AD groups to IAM roles via SAML claim rules.

D. Synchronize AD users to Amazon Cognito User Pools. Use Cognito for authentication and IAM role mapping.

**Correct Answer: A**

**Explanation:** IAM Identity Center with AD Connector provides the simplest architecture for AD-to-AWS role mapping. Permission sets assigned to AD groups automatically propagate to the 40 accounts. AD Connector passes authentication to on-premises AD, so group membership changes are reflected when users next authenticate (within the session duration). Option B requires managing a separate AWS Managed AD with trust relationships. Option C requires configuring SAML in each of the 40 accounts individually—significant overhead. Option D requires user synchronization and Cognito is designed for customer identity, not workforce.

---

### Question 8

A company needs to implement a shared services architecture where a central account provides common services (logging, monitoring, DNS) to 30 spoke accounts. The networking must ensure that spoke accounts can access shared services but cannot communicate with each other. All traffic must stay within private networks.

Which architecture enforces spoke-to-spoke isolation while allowing spoke-to-hub communication?

A. Deploy a transit gateway with two route tables: one for the shared services VPC and one for all spoke VPCs. Associate spoke VPC attachments with the spoke route table that only has routes to the shared services VPC. Propagate only the shared services VPC routes to the spoke route table.

B. Use VPC peering between each spoke and the hub. Since VPC peering is non-transitive, spokes cannot communicate with each other.

C. Deploy a transit gateway with a single route table. Use security groups in the shared services VPC to block spoke-to-spoke traffic.

D. Deploy individual VPN connections from each spoke to the shared services VPC.

**Correct Answer: A**

**Explanation:** Transit Gateway with separate route tables for hub and spoke provides network-level isolation. The spoke route table only contains routes to the shared services VPC, so spoke VPCs have no route to each other at the network layer. This is the standard isolated spoke pattern. Option B works for isolation but doesn't scale well with 30 peering connections and requires updates for each new spoke. Option C with a single route table would propagate all routes to all attachments, enabling spoke-to-spoke routing. Option D creates management overhead with 30 VPN connections.

---

### Question 9

A government agency is implementing AWS GovCloud for a classified workload. They need to ensure that only US persons can administer the AWS accounts, all data must reside in the US, and administrative actions must be traceable. The agency has its own identity provider using PIV/CAC smart card authentication.

Which combination of controls satisfies these requirements? (Choose TWO.)

A. Use AWS GovCloud (US) Regions which restrict physical data residency to the US and require US person verification for account holders.

B. Implement AWS IAM Identity Center with the agency's SAML-based identity provider that enforces PIV/CAC authentication. Configure attribute-based access control using smart card certificate attributes.

C. Create IAM users in each account with password policies requiring 24-character passwords.

D. Enable AWS CloudTrail organization trail with log file validation and immutable storage in S3 with Object Lock.

E. Restrict all accounts to us-east-1 Region using SCPs.

**Correct Answer: A, B**

**Explanation:** GovCloud (A) ensures US data residency and US person requirements—mandatory for government classified workloads. SAML federation with the agency's IdP (B) enables PIV/CAC smart card authentication and maintains the existing identity management system, with ABAC for fine-grained access control. Option C creates local IAM users instead of leveraging existing agency identity infrastructure. Option D provides traceability but is not a primary access/residency control. Option E is insufficient—GovCloud is the proper solution for data residency, not Region restriction.

---

### Question 10

A company uses AWS Organizations with 60 accounts. The finance team needs visibility into Reserved Instance (RI) utilization and coverage across all accounts. They want to identify unused RIs and see recommendations for optimal RI purchases. Access to this data should be limited to the finance team without giving them access to other AWS services.

Which solution provides the REQUIRED access with LEAST privilege?

A. Grant the finance team access to the AWS Cost Explorer RI reports in the management account using a custom IAM policy that allows only ce:* (Cost Explorer) and organizations:ListAccounts actions.

B. Share Cost and Usage Report data to an S3 bucket. Grant the finance team access to query the data using Athena.

C. Create a delegated administrator account for AWS Cost Explorer. Grant the finance team access to the delegated administrator account with policies limited to Cost Explorer and RI recommendations.

D. Give the finance team read-only access to the management account with the ViewOnlyAccess managed policy.

**Correct Answer: A**

**Explanation:** A custom IAM policy in the management account granting only Cost Explorer API access (ce:GetReservationUtilization, ce:GetReservationCoverage, ce:GetReservationPurchaseRecommendation) provides RI visibility across all organization accounts without exposing other services. Option B works but requires maintaining the CUR-to-Athena pipeline and query skills. Option C—Cost Explorer does not support delegated administrator for RI reports from a member account. Option D (ViewOnlyAccess) is too broad, granting read access to many services beyond cost data.

---

### Question 11

A media company has a Direct Connect connection with a public virtual interface for accessing AWS public services. They also need to access S3 buckets and DynamoDB tables from their on-premises data center without traffic going over the public internet. Currently, they route S3/DynamoDB traffic over the public VIF. The security team now requires this traffic to be fully private.

Which change makes S3 and DynamoDB access fully private over Direct Connect?

A. Create a private virtual interface to a VPC. In the VPC, create interface VPC endpoints for S3 and DynamoDB. Route on-premises traffic to the VPC endpoints via the private VIF.

B. Continue using the public virtual interface but restrict the advertised prefixes to only S3 and DynamoDB IP ranges.

C. Remove the public VIF. Create a transit VIF connected to a Direct Connect Gateway associated with a transit gateway. Create VPC endpoints for S3 and DynamoDB in a VPC attached to the transit gateway. Route on-premises traffic through this path.

D. Use S3 Transfer Acceleration endpoints which provide private connectivity.

**Correct Answer: C**

**Explanation:** A transit VIF to a Direct Connect Gateway connected to a transit gateway routes private traffic from on-premises into a VPC where interface VPC endpoints for S3 and DynamoDB provide private service access. This keeps all traffic within private networks. Option A with a private VIF to a single VPC works but a transit VIF provides more flexibility for multi-VPC routing. Option B still uses the public VIF which means traffic goes to AWS public IP ranges—the security team wants fully private. Option D's Transfer Acceleration uses public endpoints, not private connectivity.

---

### Question 12

A company runs 200 Amazon ECS services across development, staging, and production clusters. Each service has its own task definition, and new versions are deployed multiple times per day in development. The operations team struggles to track which container image versions are running in each environment and to ensure that only approved images run in production.

Which approach provides image governance and visibility across all environments?

A. Use Amazon ECR with image scanning enabled. Create lifecycle policies to manage image versions. Implement ECR repository policies that restrict production ECS task roles to only pull images with specific tags (e.g., "prod-approved").

B. Store container images in S3 and use Lambda to validate images before deployment.

C. Use Docker Hub for all container images with manual approval for production releases.

D. Implement a custom image registry on EC2 with webhook-based approval workflows.

**Correct Answer: A**

**Explanation:** Amazon ECR provides native image scanning for vulnerabilities, lifecycle policies to manage image proliferation, and repository policies that restrict which IAM principals (ECS task roles) can pull specific image tags. Restricting production task execution roles to only pull "prod-approved" tagged images ensures governance. Option B is not designed for container image storage and lacks registry features. Option C uses an external registry without AWS-native governance controls. Option D adds significant operational overhead for a custom registry.

---

### Question 13

A healthcare company needs to store patient records in DynamoDB with the following requirements: records must be encrypted at rest with a key that the company controls, the encryption key must be automatically rotated annually, and access to decrypt records must be audited. The company processes 50,000 reads and 10,000 writes per second.

Which DynamoDB encryption configuration meets all requirements?

A. Use DynamoDB's default encryption with an AWS-owned key.

B. Configure DynamoDB encryption with an AWS managed key (aws/dynamodb).

C. Configure DynamoDB encryption with a customer-managed KMS key. Enable automatic key rotation on the KMS key. Use CloudTrail to log KMS Decrypt API calls.

D. Implement client-side encryption using the DynamoDB Encryption Client before writing data. Manage keys in AWS CloudHSM.

**Correct Answer: C**

**Explanation:** A customer-managed KMS key gives the company full control over the encryption key, including key policy management. KMS automatic rotation rotates key material annually while maintaining access to previously encrypted data. CloudTrail logs all KMS API calls including Decrypt, providing the required audit trail. Option A (AWS-owned key) doesn't provide customer control or audit visibility. Option B (AWS-managed key) doesn't allow customer-managed key policies. Option D (client-side encryption) adds application complexity and CloudHSM operational overhead unnecessary when server-side encryption meets the requirements.

---

### Question 14

A company operates an Amazon EKS cluster running 100 pods across 20 nodes. They need to implement a solution where each pod's network traffic is isolated from other pods, and network policies are enforced to allow only specific communication paths between services. The company also needs to assign unique security groups to individual pods.

Which combination of EKS networking features addresses these requirements? (Choose TWO.)

A. Enable the Amazon VPC CNI plugin's security groups for pods feature to assign individual security groups to pods via SecurityGroupPolicy custom resources.

B. Install Calico network policy engine as an EKS add-on to enforce Kubernetes NetworkPolicy resources for pod-to-pod traffic control.

C. Create separate VPCs for each pod group and use VPC peering for allowed communications.

D. Use AWS Network Firewall to inspect traffic between pods.

E. Deploy each service in a separate EKS cluster for network isolation.

**Correct Answer: A, B**

**Explanation:** Security groups for pods (A) via the VPC CNI plugin allows assigning AWS security groups directly to pods, controlling traffic at the VPC level. Calico (B) enforces Kubernetes-native NetworkPolicy resources for fine-grained pod-to-pod communication control within the cluster. Together, they provide both VPC-level and cluster-level network isolation. Option C is impractical—pods run within a single cluster VPC. Option D operates at the VPC level, not pod level. Option E creates excessive operational overhead with separate clusters.

---

### Question 15

A company is migrating their on-premises Cassandra cluster to AWS. The Cassandra cluster handles 500,000 reads and 100,000 writes per second with data stored in a single-table design. The data model relies heavily on partition keys and clustering keys. The company wants a managed service that minimizes migration effort and maintains operational compatibility with Cassandra.

Which AWS service is MOST appropriate?

A. Amazon DynamoDB with careful schema redesign to match DynamoDB's partition key and sort key model.

B. Amazon Keyspaces (for Apache Cassandra) which provides Cassandra-compatible APIs with a serverless, managed service.

C. Amazon DocumentDB for the flexible schema requirements.

D. Deploy self-managed Cassandra on EC2 instances using a Cassandra AMI.

**Correct Answer: B**

**Explanation:** Amazon Keyspaces is a Cassandra-compatible, serverless service that supports Cassandra Query Language (CQL), partition keys, and clustering keys. It minimizes migration effort because existing Cassandra application code works with minimal changes. Option A (DynamoDB) requires schema redesign and application rewriting since the query patterns and data models differ. Option C (DocumentDB) is MongoDB-compatible, not Cassandra-compatible. Option D (self-managed on EC2) requires managing the Cassandra cluster, defeating the purpose of using a managed service.

---

### Question 16

A company uses AWS Organizations with SCPs. The security team created an SCP that denies all actions in all Regions except us-east-1. After applying the SCP, users in member accounts report they cannot create CloudFront distributions, IAM roles, or Route 53 hosted zones, even though these are global services.

What is the MOST likely cause and solution?

A. The SCP is too restrictive. Add explicit allow statements for global service API calls by adding conditions to exclude global service endpoints.

B. The SCP is correctly denying actions. Global services must be accessed from the us-east-1 console only.

C. The SCP needs to exclude global services by adding a `NotAction` block or condition for services that use global endpoints (IAM, CloudFront, Route 53, STS, WAF, etc.) alongside the Region deny.

D. SCPs don't affect global services. The issue is with IAM policies in the member accounts.

**Correct Answer: C**

**Explanation:** Global services like IAM, CloudFront, and Route 53 use the us-east-1 endpoint but their API calls may be attributed to different Regions depending on the context. The SCP should use a `NotAction` block for global service actions or add a condition to exclude them from the Region restriction. This is a common pitfall with Region-restricting SCPs. Option A (explicit allow) doesn't work in SCPs—SCPs can only deny. Option B is incorrect—global services API calls should work from any console. Option D is wrong—SCPs do affect global service API calls when Region restrictions are in place.

---

### Question 17

A company is implementing AWS Control Tower in an existing organization with 40 accounts. The organization already has SCPs, Config rules, and CloudTrail configured. The company wants to use Control Tower for governance but is concerned about conflicts with existing configurations.

What is the recommended approach for implementing Control Tower in this environment?

A. Delete all existing SCPs, Config rules, and CloudTrail configurations before enabling Control Tower to avoid conflicts.

B. Enable Control Tower on the organization. Register existing accounts into appropriate OUs. Control Tower will layer its guardrails on top of existing SCPs. Review and resolve any conflicts between existing and Control Tower configurations.

C. Create a new AWS Organization for Control Tower and migrate all accounts from the old organization.

D. Use Control Tower landing zone only for new accounts and keep existing accounts in their current OUs without Control Tower governance.

**Correct Answer: B**

**Explanation:** Control Tower can be enabled on existing organizations and will add its guardrails alongside existing configurations. Existing SCPs remain in place, and Control Tower's SCPs are additive (SCPs are implicitly intersecting). After enablement, review for conflicts such as overlapping Config rules or conflicting SCP deny statements. Option A destroys existing governance unnecessarily. Option C requires account migration which is disruptive and complex. Option D splits governance, defeating the purpose of centralized management.

---

### Question 18

A company needs to implement a centralized DNS architecture for their multi-account environment. They have 20 VPCs across 5 accounts that need to resolve each other's private hosted zone names. On-premises data centers also need to resolve AWS private DNS names, and AWS resources need to resolve on-premises DNS names.

Which DNS architecture provides bidirectional resolution with centralized management?

A. Create private hosted zones in each VPC's account. Associate each hosted zone with all 20 VPCs using cross-account VPC associations.

B. Deploy a centralized DNS VPC with Route 53 Resolver inbound and outbound endpoints. Create Route 53 Resolver rules that forward on-premises domains to on-premises DNS. Share inbound endpoint IPs with on-premises DNS for AWS domain forwarding. Use Route 53 Resolver rules shared via RAM to all accounts.

C. Deploy custom BIND DNS servers in a shared VPC. Configure all VPCs to use the custom DNS servers.

D. Use Route 53 public hosted zones for all DNS records and allow public resolution.

**Correct Answer: B**

**Explanation:** A centralized DNS VPC with Route 53 Resolver endpoints provides bidirectional DNS resolution. Inbound endpoints allow on-premises DNS servers to resolve AWS private DNS names. Outbound endpoints with forwarding rules allow AWS resources to resolve on-premises names. RAM shares the rules to all accounts. Option A handles VPC-to-VPC resolution but doesn't address on-premises bidirectional DNS. Option C requires managing DNS servers with significant operational overhead. Option D exposes private DNS records publicly—a security risk.

---

### Question 19

A gaming company needs to collect telemetry from millions of mobile game clients. Each client sends small events (500 bytes) at a rate of 100,000 events per second during peak. Events must be stored in a data lake for batch analytics and a subset of events must trigger real-time leaderboard updates. The architecture must handle client disconnections gracefully.

Which ingestion architecture handles both requirements efficiently?

A. Clients send events to Amazon API Gateway which invokes Lambda to write to both S3 and DynamoDB.

B. Clients send events to Amazon Kinesis Data Streams with two consumers: one Kinesis Data Firehose delivery stream for S3 storage, and one Lambda consumer (via event source mapping) for real-time leaderboard processing.

C. Clients send events directly to S3 using pre-signed URLs. Use S3 event notifications to trigger Lambda for leaderboard updates.

D. Clients send events to Amazon SQS. A Lambda function reads from SQS and writes to both S3 and DynamoDB.

**Correct Answer: B**

**Explanation:** Kinesis Data Streams handles 100K events/second ingestion with built-in retry handling for client disconnections. Firehose provides automatic batching and delivery to S3 for the data lake. A Lambda consumer processes the real-time subset for leaderboard updates. The dual-consumer pattern cleanly separates batch and real-time processing. Option A with API Gateway and Lambda at 100K TPS would be expensive and has throttling risks. Option C with per-event S3 PUTs creates millions of small objects. Option D with SQS doesn't provide ordered processing needed for leaderboard consistency.

---

### Question 20

An enterprise has 100 AWS accounts organized by business units in AWS Organizations. The CTO wants to implement a tagging governance framework that ensures all accounts use consistent tag key naming conventions (e.g., "CostCenter" not "cost-center" or "Cost_Center"). Non-compliant tags should be flagged but not blocked.

Which approach enforces tag naming consistency across the organization?

A. Create Tag Policies in AWS Organizations that define allowed tag keys and capitalization conventions. Enable Tag Policy enforcement reporting to identify non-compliant resources.

B. Deploy SCPs that deny resource creation with non-standard tag key names.

C. Create AWS Config rules in each account that check for tag naming conventions.

D. Send a tagging standards document to all teams and rely on manual compliance.

**Correct Answer: A**

**Explanation:** AWS Tag Policies define standardized tag keys, allowed values, and capitalization conventions across the organization. They generate compliance reports identifying non-compliant resources without blocking creation—meeting the "flagged but not blocked" requirement. Option B (SCPs) would block resource creation, not just flag non-compliance. Option C requires deploying Config rules to each account individually. Option D relies on manual compliance with no enforcement or reporting.

---

### Question 21

A company is building a multi-tenant SaaS application. Each tenant's data is stored in a separate Amazon Aurora PostgreSQL database. The application tier runs on ECS Fargate and needs to connect to the correct tenant database based on the incoming request. The number of tenants is growing from 100 to 1,000, and managing individual database connections is becoming a bottleneck.

Which approach BEST manages database connections at scale?

A. Use Amazon RDS Proxy with multiple target groups, one per tenant database. Configure the application to select the appropriate RDS Proxy endpoint based on the tenant identifier.

B. Implement connection pooling in the application code using PgBouncer running as a sidecar container in each ECS task.

C. Create a single Aurora cluster with separate schemas per tenant instead of separate databases. Use a single RDS Proxy endpoint with the application switching schemas per request.

D. Use Amazon RDS Proxy with a single proxy that supports multiple databases on the same Aurora cluster. Configure IAM authentication with the proxy selecting the target database via the `initquery` connection parameter.

**Correct Answer: C**

**Explanation:** Consolidating tenants into schemas within a single Aurora cluster with a single RDS Proxy drastically reduces connection management complexity. The proxy pools connections to one cluster, and the application sets the schema per request using `SET search_path`. This scales to 1,000 tenants without 1,000 separate database connection pools. Option A creates 1,000 proxy target groups which exceeds RDS Proxy limits and is operationally complex. Option B requires managing PgBouncer in every container. Option D's approach of using initquery per connection is not the standard RDS Proxy pattern and doesn't address the core scaling issue.

---

### Question 22

A company needs a database solution for their IoT time-series data. The data includes temperature readings, pressure sensors, and vibration measurements from 10,000 devices sending readings every second. They need to query data by device and time range, and also run aggregate queries (average, max, min) over time windows. Data older than 1 year should be automatically deleted.

Which database solution is MOST optimized for this use case?

A. Amazon DynamoDB with a partition key of device_id and sort key of timestamp. Use TTL for automatic data expiration.

B. Amazon Timestream for the time-series data with automatic data lifecycle management (memory store to magnetic store to deletion).

C. Amazon Redshift with a sort key on timestamp for optimized range queries.

D. Amazon Aurora PostgreSQL with the TimescaleDB extension for time-series optimization.

**Correct Answer: B**

**Explanation:** Amazon Timestream is purpose-built for time-series workloads with built-in support for time-series query functions (interpolation, smoothing, aggregates), automatic data tiering (memory store for recent data, magnetic store for older data), and automatic data retention policies. It handles 10K devices at 1-second intervals efficiently. Option A works but lacks built-in time-series aggregate functions and requires application-level implementation. Option C (Redshift) is a data warehouse, not optimized for high-frequency time-series ingestion. Option D requires managing the extension and Aurora instance.

---

### Question 23

A company runs an e-commerce platform on Amazon EKS. During Black Friday sales, the platform needs to scale from 50 to 500 pods in under 3 minutes. The current EKS cluster has 20 m5.2xlarge nodes managed by Cluster Autoscaler, but node provisioning takes 5-7 minutes, causing pod scheduling delays.

Which approach MOST effectively reduces scaling time?

A. Switch from Cluster Autoscaler to Karpenter for faster node provisioning. Configure Karpenter NodePools with the required instance types pre-configured.

B. Pre-provision 500 pods using Deployment replicas set to 500 and scale down during off-peak.

C. Use EKS with Fargate profiles for the workload to eliminate node provisioning entirely.

D. Increase the minimum node count in the Cluster Autoscaler to 50 nodes to have capacity pre-provisioned.

**Correct Answer: A**

**Explanation:** Karpenter provisions nodes significantly faster than Cluster Autoscaler by launching right-sized instances directly based on pending pod requirements, typically in under 2 minutes. It also supports a wider variety of instance types and uses a more efficient scheduling algorithm. Option B wastes resources during off-peak. Option C (Fargate) has cold start times and doesn't support all Kubernetes features. Option D over-provisions 50 nodes (30 extra) continuously, wasting significant compute costs.

---

### Question 24

A company is implementing a data warehouse using Amazon Redshift for their BI team. The BI team runs complex queries that can take 10-30 minutes. During month-end reporting, 50 additional analysts need access, causing query queue times of over an hour. The company wants to maintain query performance during these peak periods.

What is the MOST cost-effective solution for handling the month-end surge?

A. Resize the Redshift cluster permanently to handle peak capacity.

B. Enable Redshift Concurrency Scaling. Configure a WLM queue for the BI workload with concurrency scaling enabled. The additional capacity automatically scales during peaks and charges per-second of usage.

C. Create a second Redshift cluster for month-end reporting and restore a snapshot to it.

D. Migrate to Redshift Serverless for automatic scaling based on demand.

**Correct Answer: B**

**Explanation:** Concurrency Scaling automatically adds transient cluster capacity when queries are queued, handling burst demand. It charges per-second only when scaling clusters are active and includes a free daily credit. This is ideal for predictable periodic surges. Option A wastes money on permanently enlarged capacity for a monthly event. Option C requires manual snapshot management and a second cluster's ongoing costs. Option D (Serverless) may work but is more expensive for a consistent base workload with only periodic spikes.

---

### Question 25

A company migrated from Oracle to Amazon Aurora PostgreSQL. They have complex reporting queries that join 15+ tables and take 30 minutes on Aurora. These reports run twice daily and significantly impact the production database performance. The company wants to offload reporting without maintaining a separate data warehouse.

Which solution MOST effectively offloads the reporting workload?

A. Create an Aurora read replica dedicated to reporting queries. Configure the application to send reporting queries to the reader endpoint.

B. Use Aurora parallel query to accelerate the complex reporting queries on the same cluster.

C. Export Aurora data to S3 using aurora_s3_export and query with Amazon Athena.

D. Create an Aurora custom endpoint for reporting workloads that routes to a specific subset of reader instances sized for analytical queries.

**Correct Answer: D**

**Explanation:** A custom Aurora endpoint pointing to dedicated reader instances optimized for reporting (potentially larger instance types) isolates the analytical workload from production. The custom endpoint ensures reporting queries consistently route to these dedicated readers. Option A (reader endpoint) distributes across all readers including those serving production reads. Option B (parallel query) improves query speed but still impacts the primary cluster's resources. Option C adds latency from export and S3 query doesn't match Aurora's join performance.

---

### Question 26

A company needs to implement a database solution for their content management system. The content includes articles, user profiles, comments, and content metadata. The data model is hierarchical—articles contain sections, sections contain paragraphs, and paragraphs can have embedded media references. Queries need to retrieve full article hierarchies in single calls. The schema evolves frequently as new content types are added.

Which database BEST fits this data model and query pattern?

A. Amazon Aurora PostgreSQL using JSONB columns for flexible schema.

B. Amazon DocumentDB (MongoDB compatible) which natively stores and queries hierarchical document structures.

C. Amazon DynamoDB with a single-table design using composite keys to model the hierarchy.

D. Amazon Neptune graph database for hierarchical relationship queries.

**Correct Answer: B**

**Explanation:** DocumentDB's document model natively represents the hierarchical article structure as nested documents (article → sections → paragraphs → media). Full hierarchies are retrieved in single reads, and the flexible schema accommodates frequent content type changes without migrations. Option A (Aurora with JSONB) works but lacks the rich document query operators. Option C (DynamoDB single-table) can model hierarchies but querying full nested hierarchies requires multiple queries or complex projections. Option D (Neptune) is for highly connected graph data, not hierarchical document retrieval.

---

### Question 27

A company runs a critical PostgreSQL database on Amazon RDS. The database supports a financial trading application where even 1 second of data loss is unacceptable (RPO near zero). They need automatic failover within 30 seconds and the ability to handle a full AZ failure. The database receives 20,000 transactions per second.

Which RDS deployment provides the required durability and availability?

A. Amazon RDS Multi-AZ deployment with a synchronous standby in a different AZ.

B. Amazon Aurora PostgreSQL with multiple reader instances across AZs and automatic failover.

C. Amazon RDS with cross-Region read replicas for disaster recovery.

D. Amazon RDS with automated backups every 5 minutes.

**Correct Answer: B**

**Explanation:** Aurora PostgreSQL provides 6-way replication across 3 AZs with near-zero RPO. Automatic failover to a reader instance typically completes within 30 seconds. Aurora can handle 20,000 TPS with its distributed storage architecture. Option A (RDS Multi-AZ) has synchronous replication but failover takes 60-120 seconds, exceeding the 30-second requirement. Option C (cross-Region replicas) introduces replication lag and is for DR, not HA. Option D (5-minute backups) implies up to 5 minutes of data loss—violating the near-zero RPO requirement.

---

### Question 28

A company is implementing field-level encryption for sensitive data in their DynamoDB table. They need to ensure that certain attributes (SSN, credit card numbers) are encrypted before being stored, can only be decrypted by authorized services, and the encryption is transparent to DynamoDB (DynamoDB never sees plaintext values).

Which approach implements field-level encryption correctly?

A. Use DynamoDB's built-in encryption at rest with a customer-managed KMS key.

B. Use the AWS Database Encryption SDK (formerly DynamoDB Encryption Client) with a KMS keyring to encrypt specific attributes client-side before writing to DynamoDB. Configure attribute actions to encrypt sensitive fields and sign all fields.

C. Create a Lambda function triggered on DynamoDB Streams that encrypts sensitive attributes after they are written.

D. Use VPC endpoints to ensure DynamoDB traffic is encrypted in transit and rely on server-side encryption for at rest.

**Correct Answer: B**

**Explanation:** The AWS Database Encryption SDK encrypts specified attributes client-side before data reaches DynamoDB, ensuring DynamoDB never sees plaintext values. KMS keyrings control which services can decrypt. Attribute actions specify which fields to encrypt and which to sign (for integrity). Option A (server-side encryption) encrypts the entire table at the storage layer—DynamoDB service still processes plaintext data. Option C encrypts after writing, meaning plaintext briefly exists in DynamoDB. Option D handles transport encryption, not field-level encryption.

---

### Question 29

A company needs to replicate their DynamoDB table across three AWS Regions (us-east-1, eu-west-1, ap-southeast-1) for a globally distributed application. The application requires that updates in any Region are visible in all other Regions within 2 seconds. Occasionally, two Regions may update the same item simultaneously.

Which configuration handles global replication and conflict resolution?

A. Set up DynamoDB Global Tables (Version 2019.11.21) which provides active-active multi-Region replication with last-writer-wins conflict resolution based on timestamps.

B. Implement custom cross-Region replication using DynamoDB Streams and Lambda functions that write to tables in other Regions.

C. Use DynamoDB with cross-Region read replicas that sync every 5 minutes.

D. Create separate DynamoDB tables in each Region and use AWS AppSync as a unified global API with conflict detection.

**Correct Answer: A**

**Explanation:** DynamoDB Global Tables provide active-active replication across Regions with sub-second replication (meeting the 2-second requirement). The service handles conflict resolution using last-writer-wins based on the item timestamp, which is appropriate for most use cases with simultaneous updates. Option B requires building and maintaining custom replication—error-prone and operationally heavy. Option C doesn't exist as a DynamoDB feature. Option D adds unnecessary complexity when Global Tables natively handle the requirement.

---

### Question 30

A company operates a Direct Connect connection with a 10 Gbps dedicated connection for production traffic. They need to add a non-production workload that requires 2 Gbps of bandwidth. The company wants to keep production and non-production traffic isolated at the network level while using the same physical connection.

How should this be implemented?

A. Order a second 10 Gbps Direct Connect connection dedicated to non-production traffic.

B. Create a hosted connection on the existing physical connection to partition bandwidth.

C. Create a new private virtual interface (VIF) on the existing Direct Connect connection for non-production traffic. Use separate BGP sessions and VPCs for isolation.

D. Use VLANs on the on-premises router to logically separate production and non-production traffic over the same VIF.

**Correct Answer: C**

**Explanation:** A single Direct Connect connection supports multiple private virtual interfaces, each with its own VLAN tag, BGP session, and VPC association. This provides network-level isolation between production and non-production on the same physical connection. Option A wastes money on a separate 10 Gbps connection for only 2 Gbps of traffic. Option B is for Direct Connect partners to allocate hosted connections—not applicable to a dedicated connection already owned by the customer. Option D handles VLAN separation on-premises but doesn't create isolated AWS-side connectivity.

---

### Question 31

A company uses Amazon Redshift as their data warehouse. They need to enable their BI team to query both the Redshift data warehouse and a data lake stored in S3 (containing 200 TB of Parquet files) using standard SQL queries. The solution should not require data movement or ETL.

Which approach enables querying both data sources?

A. Load all S3 data into Redshift using COPY commands to query everything from Redshift.

B. Use Amazon Redshift Spectrum to create external tables referencing the S3 data lake. Query Redshift internal tables and S3 external tables using standard SQL joins.

C. Use Amazon Athena to query both Redshift and S3 through federated queries.

D. Export Redshift data to S3 and use only Athena for all queries.

**Correct Answer: B**

**Explanation:** Redshift Spectrum extends Redshift's SQL capability to query data directly in S3 without loading it. External tables reference S3 data organized by the Glue Data Catalog, and standard SQL joins work between internal Redshift tables and external S3 tables. This requires no data movement. Option A requires loading 200 TB into Redshift—expensive storage and lengthy ETL. Option C (Athena federated queries) can query Redshift but with performance limitations for complex joins. Option D loses the benefits of Redshift's optimized columnar storage.

---

### Question 32

A company runs a Docker-based microservices application and needs to decide between ECS and EKS. The application consists of 20 services, uses standard Docker Compose for local development, doesn't need Kubernetes-specific features like custom controllers or operators, and the team has limited Kubernetes experience. They need the simplest path to production with AWS-native integration.

Which container orchestration platform is MOST appropriate?

A. Amazon ECS with Fargate launch type for serverless container management. Use ECS service discovery for inter-service communication.

B. Amazon EKS with managed node groups. Deploy a service mesh for inter-service communication.

C. Amazon EKS on Fargate for the simplest Kubernetes experience.

D. Self-managed Kubernetes on EC2 instances for maximum control.

**Correct Answer: A**

**Explanation:** ECS with Fargate is the simplest path for a team without Kubernetes experience. ECS provides native AWS integration (IAM, CloudWatch, ALB, service discovery) without Kubernetes complexity. Fargate eliminates node management. Docker Compose compatibility exists via `ecs-cli compose`. Option B adds Kubernetes and service mesh complexity for no benefit. Option C (EKS Fargate) still requires understanding Kubernetes concepts (pods, deployments, services). Option D is the most operationally complex option.

---

### Question 33

A company needs to encrypt data in an Amazon Aurora MySQL database using a KMS key. The key must be shared with an auditing application in a different AWS account that needs to decrypt the database snapshots for compliance analysis. The auditing account should not be able to modify the key or encrypt new data.

Which KMS configuration provides the correct access?

A. Create the KMS key in the database account. Add a key policy statement granting the auditing account's root principal `kms:Decrypt` and `kms:DescribeKey` permissions. Share encrypted Aurora snapshots with the auditing account.

B. Create the KMS key in the auditing account and use it to encrypt the Aurora database in the database account.

C. Create a multi-Region KMS key and replicate it to the auditing account's Region.

D. Export the KMS key material and import it into a new key in the auditing account.

**Correct Answer: A**

**Explanation:** Granting the auditing account only `kms:Decrypt` and `kms:DescribeKey` in the key policy allows them to decrypt shared snapshots but not encrypt new data or modify the key. Aurora snapshots can be shared cross-account, and the auditing account can copy and restore them using the shared key permissions. Option B puts key ownership in the wrong account. Option C (multi-Region key) creates a full replica with all capabilities—not restricted to decrypt-only. Option D is not possible for AWS KMS-generated key material.

---

### Question 34

A company is designing a solution where their ECS Fargate containers need to access an Amazon RDS database in a private subnet. The containers must authenticate to the database without storing long-lived credentials. The security team requires that database credentials are rotated every 30 days without application changes.

Which approach provides credential-free database authentication?

A. Use IAM database authentication for RDS. Assign the ECS task role the `rds-db:connect` permission. The application generates a short-lived authentication token using the task role credentials.

B. Store database credentials in AWS Secrets Manager with 30-day rotation. Reference the secret in the ECS task definition to inject credentials as environment variables.

C. Store database credentials in SSM Parameter Store. Update the parameter every 30 days and restart the ECS tasks.

D. Hard-code database credentials in the application configuration file. Redeploy the application every 30 days with new credentials.

**Correct Answer: A**

**Explanation:** IAM database authentication eliminates stored credentials entirely. The ECS task role provides IAM credentials, and the application generates a short-lived (15-minute) authentication token via the RDS API. No rotation is needed because tokens are ephemeral. Option B stores and rotates credentials—functional but not credential-free. Option C requires manual rotation and task restarts. Option D is the least secure approach with hard-coded credentials.

---

### Question 35

A company runs a legacy Oracle database that uses Oracle Advanced Queuing (AQ) for asynchronous messaging between application components. They are migrating to AWS and want to replace Oracle AQ with an AWS-native messaging service. The messaging patterns include: point-to-point delivery, FIFO ordering, message grouping by customer ID, and exactly-once processing.

Which AWS messaging service provides all required capabilities?

A. Amazon SQS FIFO queues with message group IDs for customer-based ordering and deduplication IDs for exactly-once processing.

B. Amazon SNS for pub/sub messaging with SQS subscriptions for durability.

C. Amazon MQ with an ActiveMQ broker for JMS-compatible messaging.

D. Amazon EventBridge for event-driven asynchronous communication.

**Correct Answer: A**

**Explanation:** SQS FIFO queues provide exactly-once processing, strict ordering, and message group IDs (which map to customer-based grouping). This directly replaces Oracle AQ's capabilities: point-to-point delivery is SQS's core pattern, FIFO ensures ordering, message groups maintain per-customer ordering, and deduplication provides exactly-once semantics. Option B (SNS) is pub/sub, not point-to-point with ordering. Option C (Amazon MQ) works but adds unnecessary infrastructure management for features SQS provides natively. Option D (EventBridge) is event routing, not message queuing with FIFO/exactly-once.

---

### Question 36

A company wants to implement end-to-end encryption for data flowing through their AWS architecture: data is collected from IoT devices, processed by Lambda functions, stored in DynamoDB, and queried via API Gateway. They need to ensure data is encrypted at every stage—in transit and at rest—with the company maintaining control of all encryption keys.

Which combination of encryption measures provides end-to-end protection? (Choose THREE.)

A. IoT devices use TLS 1.2 with AWS IoT Core's managed certificates for data in transit. Configure the IoT rules engine to invoke Lambda.

B. Lambda functions use the AWS Encryption SDK with a customer-managed KMS key to encrypt data before writing to DynamoDB. This provides application-layer encryption independent of DynamoDB's server-side encryption.

C. Configure DynamoDB with a customer-managed KMS key for encryption at rest. This complements the application-layer encryption.

D. API Gateway uses default HTTPS provided by AWS-managed certificates.

E. Use self-signed certificates on all services for encryption.

**Correct Answer: A, B, C**

**Explanation:** TLS 1.2 with IoT Core (A) encrypts data from devices to AWS. Application-layer encryption in Lambda using the Encryption SDK with customer-managed KMS keys (B) ensures data is encrypted before storage, maintaining company key control. DynamoDB encryption with a customer-managed KMS key (C) adds defense-in-depth at the storage layer. Together, these cover in-transit (TLS), application-layer (Encryption SDK), and at-rest (DynamoDB encryption) protection with customer-controlled keys. Option D uses AWS-managed certificates, not customer-controlled. Option E with self-signed certificates doesn't integrate with AWS services properly.

---

### Question 37

A company deploys an EKS cluster that needs to pull container images from Amazon ECR repositories in three different AWS accounts (development, staging, production). The EKS cluster is in the production account. The development and staging ECR repositories are in their respective accounts. Nodes should be able to pull images without storing long-lived credentials.

Which approach allows cross-account ECR image pulls with LEAST privilege?

A. Create ECR repository policies in the development and staging accounts that grant the production account's EKS node IAM role permission to pull images. Configure the EKS node role with ecr:GetAuthorizationToken permission.

B. Create IAM users in the development and staging accounts with ECR pull permissions. Store their access keys in Kubernetes secrets.

C. Enable ECR public repositories for development and staging images.

D. Use ECR replication to copy all images to the production account's ECR repository.

**Correct Answer: A**

**Explanation:** ECR repository policies can grant cross-account pull access to specific IAM roles. The EKS node IAM role in the production account is granted ecr:BatchGetImage and ecr:GetDownloadUrlForLayer in the source accounts' repository policies. This uses IAM roles (no stored credentials) with least-privilege permissions. Option B stores long-lived credentials which is a security risk. Option C makes images public which is a security concern. Option D works but requires maintaining image copies and replication infrastructure across accounts.

---

### Question 38

A company needs to implement a Global Accelerator for their application hosted behind ALBs in us-east-1 and eu-west-1. The application handles both HTTP and TCP traffic. During a Region failover, traffic should automatically shift to the healthy Region within 30 seconds. The company also needs to control the proportion of traffic sent to each Region during normal operations.

Which Global Accelerator configuration meets these requirements?

A. Create a Global Accelerator with two endpoint groups (one per Region) with health checks. Set traffic dials to control the percentage distribution. Configure the health check interval to 10 seconds with a 3-threshold count for faster failover.

B. Use Route 53 latency-based routing with health checks to direct traffic to the nearest healthy ALB.

C. Use CloudFront with multiple origins in an origin group for failover.

D. Deploy a Network Load Balancer with cross-Region load balancing.

**Correct Answer: A**

**Explanation:** Global Accelerator provides static anycast IP addresses, traffic dials for percentage-based distribution, and health checks with configurable intervals that detect failures within 30 seconds (10-second intervals × 3 threshold = 30 seconds). It supports both HTTP and TCP traffic. Option B (Route 53) depends on DNS TTL which can exceed 30 seconds for failover. Option C (CloudFront) is for HTTP/HTTPS only, not TCP. Option D cross-Region NLB load balancing is not a native NLB feature.

---

### Question 39

A company runs a Redshift cluster that queries both local Redshift tables and external S3 data via Spectrum. The data science team wants to query data from a DynamoDB table and an RDS PostgreSQL database alongside Redshift data, all within a single SQL query.

Which Redshift feature enables this?

A. Amazon Redshift Federated Query which allows querying RDS PostgreSQL and DynamoDB data sources alongside Redshift data in a single SQL statement.

B. Amazon Redshift COPY command to load DynamoDB and RDS data into Redshift tables.

C. AWS Glue ETL jobs to extract data from all sources and load into Redshift.

D. Amazon Athena federated query with a Redshift data source connector.

**Correct Answer: A**

**Explanation:** Redshift Federated Query enables direct SQL access to data in Amazon RDS (PostgreSQL/MySQL) and live DynamoDB tables from Redshift. Combined with Spectrum for S3 data, users can join data across Redshift, S3, RDS, and DynamoDB in a single SQL query without data movement. Option B requires ETL to load data into Redshift. Option C also requires ETL with additional Glue infrastructure. Option D queries from Athena, not from within Redshift.

---

### Question 40

A company manages encryption for their multi-account environment using KMS. They need to implement a key hierarchy where a master key in a security account is used to encrypt data keys in member accounts. Data keys should be generated per-application and stored encrypted. The solution must support key rotation without re-encrypting all data.

Which KMS approach implements this key hierarchy?

A. Use KMS data key hierarchy: create a customer-managed key (CMK) in the security account as the master key. Applications in member accounts call GenerateDataKey to get a plaintext and encrypted data key. Use the plaintext key to encrypt data locally, and store only the encrypted data key alongside the data. Key rotation of the CMK automatically wraps new data keys without re-encrypting existing data.

B. Create separate KMS keys in each member account and manually rotate them by creating new keys.

C. Use AWS CloudHSM to manage the key hierarchy with custom key wrapping.

D. Store encryption keys in AWS Secrets Manager and use application-level encryption.

**Correct Answer: A**

**Explanation:** KMS's envelope encryption model implements the described hierarchy natively. GenerateDataKey creates unique data keys per application, encrypted under the CMK. When the CMK is rotated, KMS retains old key material to decrypt existing data keys while using new material for new GenerateDataKey calls—no re-encryption of existing data needed. Option B doesn't implement a hierarchy and requires manual rotation. Option C adds CloudHSM complexity for functionality KMS provides natively. Option D doesn't implement a cryptographic key hierarchy.

---

### Question 41

A company runs an ECS cluster with 100 services. During deployments, they occasionally experience issues where a new task version starts but fails health checks after 2 minutes. The current deployment configuration replaces all tasks at once, causing service disruptions. They need a deployment strategy that validates new task health before replacing old tasks.

Which ECS deployment configuration prevents unhealthy deployments from impacting users?

A. Configure ECS deployment circuit breaker with rollback enabled. Set the minimum healthy percent to 100% and maximum percent to 200%. This allows ECS to launch new tasks alongside old ones, validate health, and automatically roll back if the new tasks fail health checks.

B. Set minimum healthy percent to 0% and maximum percent to 100% for fastest deployments.

C. Use ECS external deployments with manual approval between old and new task sets.

D. Deploy new task definitions to a separate ECS cluster and manually switch traffic.

**Correct Answer: A**

**Explanation:** With minimum healthy 100% and maximum 200%, ECS launches new tasks alongside existing ones. The deployment circuit breaker monitors health checks and automatically rolls back if new tasks fail—old tasks continue serving traffic throughout. This prevents unhealthy deployments from impacting users. Option B (0%/100%) takes down all old tasks before starting new ones, causing downtime. Option C requires manual intervention. Option D requires maintaining two clusters and manual traffic switching.

---

### Question 42

A company is building a real-time fraud detection system. Transaction data flows through Kinesis Data Streams. The fraud detection model runs on SageMaker. The system must evaluate each transaction within 100ms and enrich the transaction with the fraud score before writing to DynamoDB. The system processes 10,000 transactions per second.

Which architecture meets the latency requirement?

A. Kinesis Data Streams → Lambda (calls SageMaker real-time endpoint) → DynamoDB.

B. Kinesis Data Streams → Kinesis Data Analytics (Apache Flink) → SageMaker batch transform → DynamoDB.

C. Kinesis Data Streams → Lambda (calls SageMaker real-time endpoint) → SQS → Lambda → DynamoDB.

D. Kinesis Data Streams → Kinesis Data Firehose → SageMaker processing job → DynamoDB.

**Correct Answer: A**

**Explanation:** Lambda consuming from Kinesis with calls to a SageMaker real-time inference endpoint provides sub-100ms inference latency. Lambda writes the enriched transaction directly to DynamoDB. SageMaker real-time endpoints are designed for low-latency inference (typically 10-50ms). Option B uses batch transform which is for batch processing, not real-time. Option C adds unnecessary SQS latency. Option D uses Firehose which batches and buffers data—not suitable for per-transaction real-time processing.

---

### Question 43

A company operates an Aurora PostgreSQL cluster that experiences daily traffic patterns: high load from 8 AM to 6 PM, moderate from 6 PM to midnight, and minimal from midnight to 8 AM. The current setup uses a fixed db.r5.2xlarge writer and two db.r5.2xlarge readers. The DBA wants to reduce costs while maintaining performance during peak hours and ensuring high availability at all times.

Which optimization provides the BEST cost reduction while maintaining performance?

A. Replace the fixed Aurora readers with Aurora Auto Scaling that adjusts the number and size of reader instances based on CPU utilization.

B. Replace fixed Aurora readers with Aurora Serverless v2 reader instances that automatically scale capacity between 0.5 and 16 ACUs based on load. Keep the writer as a provisioned instance for consistent write performance.

C. Switch the entire cluster to Aurora Serverless v2 for both writer and readers.

D. Use a scheduled Lambda function to stop reader instances at midnight and start them at 6 AM.

**Correct Answer: B**

**Explanation:** Aurora Serverless v2 readers scale continuously based on demand, reducing capacity (and cost) during low-traffic periods while scaling up during peaks. Keeping the writer as provisioned ensures consistent write performance. This provides cost savings during off-peak without compromising peak performance. Option A (Auto Scaling) adjusts replica count but each replica is a fixed size—less granular than Serverless v2. Option C risks write performance variability with a Serverless v2 writer. Option D has no readers from midnight to 6 AM, losing high availability.

---

### Question 44

A company's application experiences intermittent 502 Bad Gateway errors from their Application Load Balancer. The errors occur randomly throughout the day and affect approximately 2% of requests. CloudWatch metrics show healthy targets and normal target response times. The application logs don't show corresponding errors.

What is the MOST likely cause and how should it be investigated?

A. The ALB is experiencing capacity issues. Request a service limit increase for the ALB.

B. The backend targets are closing connections before the ALB expects them to. Check the ALB access logs for 502 errors with `target_processing_time` of -1, indicating the target closed the connection. Adjust the target's keep-alive timeout to be greater than the ALB's idle timeout (default 60 seconds).

C. The security group on the ALB is blocking some requests. Review and update the security group rules.

D. The SSL certificate on the ALB has expired, causing intermittent TLS failures.

**Correct Answer: B**

**Explanation:** Intermittent 502s with healthy targets typically indicate connection timing issues. When a target closes a keep-alive connection at the same moment the ALB sends a request, the ALB returns a 502. The solution is to ensure the target's keep-alive timeout exceeds the ALB's idle timeout (60 seconds), so targets never close connections that the ALB might reuse. Option A is rarely the cause for intermittent 502s. Option C would cause consistent blocking, not intermittent errors. Option D would affect all HTTPS requests, not random 2%.

---

### Question 45

A company uses Amazon CloudWatch for monitoring their production workloads. They have identified that their monitoring costs are high due to custom metrics published every 1 second at $0.30 per metric per month. The company publishes 5,000 custom metrics. They want to reduce monitoring costs while maintaining sufficient observability.

Which approach provides the MOST significant cost reduction?

A. Switch from 1-second resolution to 60-second standard resolution for non-critical metrics. Use high resolution only for latency-sensitive metrics.

B. Consolidate related metrics into fewer metrics using CloudWatch metric dimensions.

C. Replace CloudWatch with a self-managed Prometheus instance on EC2.

D. Delete all custom metrics and rely solely on AWS-provided default metrics.

**Correct Answer: A**

**Explanation:** High-resolution (1-second) custom metrics cost $0.30/metric/month, while standard resolution (60-second) metrics cost $0.30 per metric for the first 10,000 but most applications don't need 1-second resolution for all metrics. Reducing from 5,000 high-resolution metrics to perhaps 100 high-resolution + 4,900 standard resolution significantly reduces the total PutMetricData API call costs and storage costs. Option B helps but metric cost is per unique metric name, not per dimension. Option C trades CloudWatch cost for EC2 infrastructure costs and operational overhead. Option D eliminates critical observability.

---

### Question 46

A company has an application deployed across three Availability Zones. They need to implement automated remediation that replaces unhealthy EC2 instances. The application requires that instances maintain their Elastic IP addresses and EBS volumes when replaced. The recovery must complete within 5 minutes.

Which solution meets these requirements?

A. Use Auto Scaling group health checks to replace unhealthy instances. Use lifecycle hooks to reattach EIPs and EBS volumes.

B. Configure EC2 Auto Recovery by setting a CloudWatch alarm on the StatusCheckFailed_System metric to trigger the recover action. This automatically restarts the instance on new hardware while maintaining the same EIP, instance ID, and EBS volumes.

C. Use AWS Lambda triggered by CloudWatch events to terminate unhealthy instances and launch new ones with the same configuration.

D. Use AWS Fault Injection Simulator to automatically detect and recover from failures.

**Correct Answer: B**

**Explanation:** EC2 Auto Recovery restarts the instance on new hardware while preserving the instance ID, private IP, EIP, and all EBS volume attachments. The CloudWatch alarm on StatusCheckFailed_System triggers automatic recovery within minutes. Option A (Auto Scaling) launches new instances with new IDs, requiring complex lifecycle hooks to reassociate EIPs and volumes. Option C requires custom automation and volume/EIP management. Option D (FIS) is for chaos engineering testing, not automated remediation.

---

### Question 47

A company runs a SaaS platform and needs to implement an SLA dashboard that tracks availability across multiple services. Each service publishes health check metrics to CloudWatch. The dashboard needs to calculate a composite availability score and alert when any service drops below 99.95% availability over a rolling 30-day window.

Which approach creates an accurate availability SLA dashboard?

A. Create a CloudWatch dashboard with individual metric widgets for each service. Set alarms on each service individually.

B. Use CloudWatch Metric Math to calculate a composite availability score from individual health check metrics. Create a CloudWatch alarm on the composite metric with a 30-day evaluation period. Publish the dashboard using CloudWatch Dashboards with automatic sharing.

C. Export CloudWatch metrics to S3 and use QuickSight for SLA visualization.

D. Use AWS Health Dashboard for SLA tracking.

**Correct Answer: B**

**Explanation:** CloudWatch Metric Math calculates composite availability from individual metrics in real-time. A 30-day rolling evaluation provides the accurate SLA window. CloudWatch Dashboards can display both individual service metrics and the composite score. Option A lacks composite scoring. Option C adds latency from export and doesn't provide real-time dashboards. Option D tracks AWS service health, not customer application SLAs.

---

### Question 48

A company's EKS cluster uses Horizontal Pod Autoscaler (HPA) based on CPU utilization. However, the application is I/O-bound, not CPU-bound—pods are waiting on database responses but CPU is low. As a result, HPA doesn't scale even when response times are degraded. The company needs autoscaling based on request latency.

Which approach enables latency-based autoscaling for EKS pods?

A. Replace HPA with a cron-based scaling schedule that adds pods during peak hours.

B. Configure HPA with custom metrics using the Prometheus Adapter. Export application response latency metrics to Prometheus, and configure HPA to scale based on the custom latency metric.

C. Increase the CPU requests for pods to artificially raise CPU utilization relative to the limit.

D. Use Cluster Autoscaler to add more nodes when latency increases.

**Correct Answer: B**

**Explanation:** The Prometheus Adapter exposes Prometheus metrics as Kubernetes custom metrics that HPA can use for scaling decisions. The application exports latency metrics to Prometheus, and HPA scales pods based on p95 or average latency thresholds. Option A (cron-based) doesn't respond to actual demand. Option C manipulates CPU metrics which masks the real issue and wastes resources. Option D (Cluster Autoscaler) adds nodes, not pods—it responds to unschedulable pods, not application-level latency.

---

### Question 49

A company is implementing a canary deployment for their ECS service. They want to deploy the new version to 10% of traffic, monitor error rates for 15 minutes, and then either proceed with full deployment or rollback. The deployment should be fully automated with no manual intervention.

Which implementation provides the MOST automated canary deployment?

A. Use AWS CodeDeploy with an ECS deployment type configured as a canary deployment (10% shift, 15-minute interval). Configure a CloudWatch alarm for error rate as the deployment validation. CodeDeploy automatically rolls back if the alarm triggers.

B. Create two ECS services with different target groups. Use Route 53 weighted routing with 10/90 split. Manually monitor and adjust weights.

C. Use Application Load Balancer weighted target groups to send 10% to the new version and 90% to the old version. Use a Lambda function to monitor and adjust.

D. Deploy the new version as a separate ECS service on a different port. Use manual testing for validation.

**Correct Answer: A**

**Explanation:** CodeDeploy's ECS canary deployment type natively supports percentage-based traffic shifting with configurable intervals. CloudWatch alarm integration provides automated validation—if error rates exceed the threshold during the 15-minute bake period, CodeDeploy automatically rolls back. This is fully automated end-to-end. Option B requires manual monitoring and weight adjustment. Option C requires custom Lambda automation for validation and rollback. Option D is fully manual.

---

### Question 50

A company needs to implement centralized logging for their EKS cluster. They want to collect logs from all pods, enrich them with Kubernetes metadata (pod name, namespace, labels), and store them in Amazon OpenSearch for analysis. The solution should have minimal impact on pod performance.

Which logging architecture is MOST appropriate?

A. Deploy Fluent Bit as a DaemonSet on all nodes. Configure Fluent Bit with the Kubernetes filter for metadata enrichment and the OpenSearch output plugin for direct delivery.

B. Add a logging sidecar container to every pod that reads log files and sends them to CloudWatch Logs.

C. Configure each application to send logs directly to OpenSearch using the OpenSearch client library.

D. Enable EKS control plane logging and rely on it for all cluster logs.

**Correct Answer: A**

**Explanation:** Fluent Bit as a DaemonSet runs one instance per node (not per pod), minimizing resource overhead. The Kubernetes filter automatically enriches logs with pod metadata. Direct output to OpenSearch provides efficient log delivery. Option B adds a sidecar to every pod, consuming resources per-pod and requiring deployment changes. Option C requires application code changes and tightly couples apps to the logging backend. Option D only captures control plane logs, not pod application logs.

---

### Question 51

A company runs an RDS MySQL database with Multi-AZ. During a recent failover test, the application experienced 5 minutes of errors because the application's connection pool continued trying to connect to the old primary IP. The DNS TTL for the RDS endpoint was properly set, but the application's connection pool cached the resolved IP.

How should the application be configured to handle failover more gracefully?

A. Configure the application's connection pool to validate connections before use (testOnBorrow) and implement DNS cache TTL settings in the JVM (for Java applications) to respect the RDS endpoint's short DNS TTL. Implement connection retry logic with exponential backoff.

B. Use the RDS instance IP address directly instead of the DNS endpoint.

C. Implement a custom health check that monitors the primary RDS instance and updates a configuration file with the new IP.

D. Switch to Amazon Aurora which doesn't experience failover.

**Correct Answer: A**

**Explanation:** Connection validation (testOnBorrow) detects stale connections immediately. Setting the JVM's DNS cache TTL (networkaddress.cache.ttl) to a low value ensures the application resolves the RDS endpoint to the new IP after failover. Retry logic with exponential backoff handles the brief period during failover. Option B (direct IP) means no automatic failover at all—you'd need manual IP updates. Option C is a custom solution that's more fragile than DNS-based failover. Option D is incorrect—Aurora also has failover, though typically faster (30 seconds vs 60-120 seconds).

---

### Question 52

A company's application experiences periodic spikes in DynamoDB consumed write capacity that exceed their provisioned capacity, causing throttled requests. The writes are not time-sensitive and can be delayed by up to 30 seconds. The company doesn't want to switch to on-demand capacity because their baseline usage is well-served by provisioned capacity.

Which approach handles write spikes without over-provisioning?

A. Implement a write buffer using Amazon SQS. The application writes to SQS instead of directly to DynamoDB. A Lambda function consumes from SQS at a controlled rate matching the provisioned write capacity, using SQS message batching and Lambda reserved concurrency for rate limiting.

B. Enable DynamoDB Auto Scaling with aggressive scaling targets.

C. Implement exponential backoff retry logic in the application for throttled writes.

D. Increase provisioned write capacity to handle peak spikes permanently.

**Correct Answer: A**

**Explanation:** SQS acts as a write buffer, absorbing spikes and smoothing them out. Lambda consumes at a controlled rate using reserved concurrency to match DynamoDB's provisioned capacity. The 30-second latency tolerance makes this viable. Option B (Auto Scaling) takes minutes to respond and may not keep up with sudden spikes. Option C (retry) reduces throttling errors but still bursts against DynamoDB during spikes. Option D over-provisions for peak, wasting money during normal operations.

---

### Question 53

A company uses AWS CloudFormation for infrastructure deployment. A recent production deployment failed mid-way through, leaving the stack in UPDATE_ROLLBACK_FAILED state. Some resources were successfully updated while others failed, and manual intervention is needed to fix the stack.

What is the correct procedure to recover from UPDATE_ROLLBACK_FAILED state?

A. Delete the entire stack and recreate it from scratch.

B. Use the `continue-update-rollback` API call with the `--resources-to-skip` parameter to skip the resources that cannot be rolled back. Fix the underlying issues first (such as manually deleting resources that conflict), then run the continue rollback. Once the stack is back in UPDATE_ROLLBACK_COMPLETE state, perform a new update.

C. Create a new stack with a different name and migrate resources manually.

D. Contact AWS Support to manually fix the stack state.

**Correct Answer: B**

**Explanation:** `continue-update-rollback` with `--resources-to-skip` allows CloudFormation to complete the rollback by skipping problematic resources. After fixing the underlying issues (e.g., manually deleting resources that CloudFormation can't clean up), the stack returns to a manageable state for future updates. Option A destroys all resources including those that are working. Option C duplicates infrastructure. Option D is a last resort, not the recommended procedure.

---

### Question 54

A company is migrating a self-managed Apache Kafka cluster from on-premises to AWS. The cluster handles 500,000 messages per second across 50 topics. The migration must maintain message ordering within topics and ensure zero message loss during the transition. Applications currently using Kafka client libraries should require minimal code changes.

Which migration approach meets all requirements?

A. Set up Amazon MSK (Managed Streaming for Apache Kafka) in the target VPC. Use MirrorMaker 2.0 to replicate all topics from the on-premises cluster to MSK with consumer group offset synchronization. Gradually switch producers and consumers to the MSK cluster.

B. Replace Kafka with Amazon Kinesis Data Streams. Rewrite producers and consumers to use the Kinesis SDK.

C. Use AWS DMS to migrate Kafka data to Amazon SQS queues.

D. Set up Amazon MSK and manually replay messages from the beginning of each topic.

**Correct Answer: A**

**Explanation:** Amazon MSK is a managed Kafka service that's fully compatible with Apache Kafka client libraries—minimal code changes needed (just update broker endpoints). MirrorMaker 2.0 provides live topic replication with ordering preserved and consumer group offset synchronization for zero-loss cutover. Option B requires rewriting all producers and consumers for a different API. Option C—DMS doesn't support Kafka-to-SQS migration, and SQS has different semantics. Option D loses messages produced during migration and requires coordinated downtime.

---

### Question 55

A company has a 500 TB data lake in an on-premises Hadoop cluster with HDFS. The data is processed daily using Spark jobs. They want to migrate the data lake to AWS and continue running Spark workloads. The company wants to decouple storage from compute and use a managed service for Spark execution.

Which target architecture provides the BEST separation of storage and compute?

A. Migrate data to Amazon S3 using AWS DataSync. Run Spark jobs on Amazon EMR transient clusters that read from and write to S3.

B. Migrate to Amazon EMR with HDFS on EBS volumes for persistent storage.

C. Migrate data to Amazon EFS and process with Spark on EC2 instances.

D. Migrate to an always-on EMR cluster with HDFS as the primary storage layer.

**Correct Answer: A**

**Explanation:** S3 provides durable, cost-effective storage decoupled from compute. EMR transient clusters launch for processing, access S3 data, and terminate when done—you only pay for compute during execution. DataSync efficiently transfers the 500 TB from on-premises HDFS to S3. Option B couples storage (HDFS on EBS) to the EMR cluster. Option C (EFS) is not optimized for big data analytics workloads. Option D (always-on HDFS) maintains the coupled storage/compute model and runs continuously.

---

### Question 56

A company operates a Microsoft SQL Server database with 50 TB of data and 200 stored procedures. They plan to migrate to Amazon Aurora PostgreSQL to reduce licensing costs. The stored procedures contain complex business logic. The migration has a 2-hour downtime window.

Which approach manages the schema and stored procedure conversion MOST efficiently?

A. Manually rewrite all 200 stored procedures in PostgreSQL PL/pgSQL.

B. Use AWS Schema Conversion Tool (SCT) to convert the SQL Server schema, stored procedures, and functions to Aurora PostgreSQL. Review SCT's conversion report for items requiring manual intervention. Use SCT's assessment to prioritize manual conversion of complex procedures. Use DMS for data migration with CDC.

C. Use AWS DMS to migrate both schema and data simultaneously.

D. Export the SQL Server database and use the PostgreSQL COPY command to import data.

**Correct Answer: B**

**Explanation:** AWS SCT automates the conversion of SQL Server schemas and stored procedures to PostgreSQL equivalents. Its assessment report identifies conversion issues and the percentage of code that can be auto-converted. For complex procedures that can't be auto-converted, SCT provides guidance. DMS with CDC handles data migration within the 2-hour window. Option A is extremely time-consuming for 200 stored procedures. Option C—DMS migrates data, not stored procedures. Option D handles data transfer but not stored procedure conversion.

---

### Question 57

A company needs to migrate 10 TB of real-time transactional data from an on-premises MySQL 5.7 database to Amazon Aurora MySQL. The database receives 5,000 transactions per second and cannot tolerate more than 10 minutes of downtime. After migration, the on-premises database must remain operational as a read-only replica for 30 days.

Which migration strategy minimizes downtime while maintaining the on-premises read-only copy?

A. Use mysqldump to export the database, transfer to S3, and import into Aurora. Set up binlog replication from Aurora back to on-premises MySQL.

B. Use AWS DMS with full load + CDC from on-premises MySQL to Aurora MySQL. During cutover, stop the application, wait for DMS to sync the last changes, switch the application to Aurora. After cutover, set up Aurora MySQL as a binlog replication source to the on-premises MySQL for the 30-day read-only requirement.

C. Use Aurora MySQL native binlog replication from on-premises as a read replica. Promote Aurora to primary during cutover.

D. Use AWS Snowball to transfer the initial data load, then use DMS CDC to catch up.

**Correct Answer: B**

**Explanation:** DMS full load + CDC keeps Aurora synchronized with minimal lag. The cutover window only needs to cover the time to stop writes, let DMS sync final changes, and redirect the application—well within 10 minutes. After cutover, Aurora's binlog can replicate back to on-premises MySQL for the 30-day read-only copy. Option A (mysqldump) creates extended downtime for a 10 TB export/import. Option C works but DMS provides better monitoring and progress tracking. Option D (Snowball) adds unnecessary logistics for 10 TB—network transfer via DMS handles this size efficiently.

---

### Question 58

A company has 1,000 virtual machines running on VMware vSphere in their data center. They need to plan a migration to AWS and want to start with a portfolio assessment to understand which applications should be rehosted, replatformed, refactored, or retired. The assessment must include TCO analysis and migration complexity ratings.

Which AWS tool provides the MOST comprehensive migration assessment?

A. AWS Migration Hub with the Migration Evaluator (formerly TSO Logic) for TCO analysis and right-sizing recommendations based on actual on-premises utilization data.

B. AWS Application Discovery Service for discovering server configurations only.

C. AWS Migration Hub Strategy Recommendations which analyzes applications and recommends migration strategies (rehost, replatform, refactor) based on source code analysis and runtime data.

D. Manual assessment using spreadsheets with vendor quotes.

**Correct Answer: C**

**Explanation:** Migration Hub Strategy Recommendations analyzes applications using source code analysis and runtime data to recommend specific migration strategies per application (rehost, replatform, refactor). It provides migration complexity ratings and anti-pattern detection. Combined with Migration Evaluator data, it gives a comprehensive assessment. Option A provides TCO analysis but not per-application strategy recommendations. Option B discovers infrastructure but doesn't assess migration strategies. Option D is time-consuming and less comprehensive.

---

### Question 59

A company is migrating a large-scale Oracle E-Business Suite (EBS) application to AWS. The application has multiple components: web servers, application servers, concurrent managers, database servers, and shared file systems. The company wants to run Oracle EBS on AWS with Oracle Database on RDS while minimizing re-architecture.

Which migration approach is MOST appropriate?

A. Use AWS Application Migration Service (MGN) to lift-and-shift all components to EC2. Deploy Oracle Database on Amazon RDS for Oracle.

B. Refactor the entire Oracle EBS application into microservices running on ECS.

C. Deploy Oracle EBS on EC2 instances following Oracle's validated architecture for AWS. Use Amazon RDS for Oracle (or EC2 with Oracle DB) for the database. Use Amazon EFS for shared file systems. Use MGN for the application tier migration.

D. Replace Oracle EBS with a SaaS alternative.

**Correct Answer: C**

**Explanation:** Oracle EBS has a validated architecture pattern for AWS that uses EC2 for application tiers, RDS or EC2 for Oracle Database, and EFS for shared file systems. Following this validated pattern ensures supportability while minimizing re-architecture. MGN handles the application tier migration. Option A oversimplifies—blind lift-and-shift doesn't account for EBS-specific requirements like shared storage. Option B is impractical—EBS is a monolithic suite that can't be easily decomposed. Option D is a replacement, not a migration.

---

### Question 60

A financial company is migrating their on-premises data warehouse from Teradata to Amazon Redshift. The Teradata system has 200 TB of data and 5,000 SQL scripts used for ETL and reporting. The company needs to convert Teradata-specific SQL to Redshift-compatible SQL.

Which approach provides the MOST efficient SQL conversion?

A. Manually rewrite all 5,000 SQL scripts for Redshift syntax.

B. Use AWS Schema Conversion Tool (SCT) to convert Teradata SQL scripts, BTEQ scripts, and stored procedures to Redshift-compatible SQL. Review the assessment report for unconvertible constructs. Use SCT data extraction agents for parallel data migration to S3, then load into Redshift.

C. Use AWS DMS to migrate data and automatically convert SQL scripts.

D. Use Amazon Athena to run Teradata SQL directly on migrated data in S3.

**Correct Answer: B**

**Explanation:** SCT specifically supports Teradata-to-Redshift conversion including SQL scripts, BTEQ scripts, and stored procedures. Its assessment report identifies conversion percentages and problematic constructs. SCT data extraction agents parallelize the data extraction from Teradata for loading into Redshift. Option A is impractical for 5,000 scripts. Option C migrates data but doesn't convert SQL scripts. Option D doesn't support Teradata SQL syntax.

---

### Question 61

A company needs to modernize their monolithic Java application running on WebSphere. The application processes insurance claims and has been running for 15 years. The company wants to break it into microservices incrementally over 2 years while keeping the monolith running. The first microservice to extract handles claims validation.

Which modernization strategy supports incremental decomposition?

A. Rewrite the entire application from scratch using modern frameworks and deploy on ECS. Launch when complete.

B. Use the Strangler Fig pattern. Deploy the existing monolith on EC2. Create the claims validation microservice on ECS/Fargate. Route claims validation requests to the new service using an ALB with path-based routing. Gradually extract more services over time.

C. Containerize the monolith as-is in a single container. Run on ECS.

D. Use AWS App2Container to automatically decompose the monolith into microservices.

**Correct Answer: B**

**Explanation:** The Strangler Fig pattern incrementally replaces functionality by routing specific requests to new microservices while the monolith handles everything else. ALB path-based routing directs claims validation requests to the new ECS service. Over 2 years, more services are extracted until the monolith is retired. Option A is big-bang approach—risky for a 15-year-old application. Option C containerizes without decomposing—still a monolith. Option D (App2Container) helps containerize but doesn't automatically decompose business logic into microservices.

---

### Question 62

A gaming company needs to migrate their Redis-based session store from on-premises to AWS. The Redis cluster has 500 GB of data, handles 100,000 operations per second with sub-millisecond latency, and uses Redis Cluster mode with 6 shards. During migration, the game must continue operating with no more than 5 seconds of session data staleness.

Which migration approach minimizes disruption?

A. Export the Redis RDB file, upload to S3, and import into Amazon ElastiCache for Redis. Schedule a maintenance window for the cutover.

B. Set up Amazon ElastiCache for Redis in cluster mode with 6 shards. Use the Redis REPLICAOF (SLAVEOF) command to set up each ElastiCache shard as a replica of the corresponding on-premises shard via VPN/Direct Connect. Once replication is caught up (within 5-second lag), promote ElastiCache and switch the application endpoint.

C. Deploy Amazon MemoryDB for Redis and use AWS DMS to migrate the data.

D. Recreate the session data in ElastiCache by having users re-authenticate after migration.

**Correct Answer: B**

**Explanation:** Redis native replication (REPLICAOF) keeps ElastiCache synchronized with the on-premises Redis cluster in near real-time. Each shard replicates independently, maintaining the cluster topology. When replication lag is within the 5-second threshold, the cutover switches the application to ElastiCache with minimal data staleness. Option A requires downtime for export/import and data becomes stale during transfer. Option C—DMS doesn't support Redis-to-Redis migration. Option D loses all active sessions, disrupting the gaming experience.

---

### Question 63

A company operates a large production environment with 500 EC2 instances. They discover that 30% of their instances are using previous-generation instance types (m4, c4, r4) that cost more per unit of compute than current-generation equivalents (m6i, c6i, r6i). The total EC2 spend is $500,000/month.

What is the estimated monthly savings from modernizing to current-generation instances, and what is the SAFEST approach?

A. Current-generation instances typically offer 10-15% better price-performance. Use AWS Compute Optimizer to identify specific instances and target types. Migrate instances in batches using maintenance windows, starting with non-production. Estimated savings: $15,000-$22,500/month on the 30% of instances affected.

B. Replace all 500 instances simultaneously with the latest generation for maximum savings.

C. Wait for the next Reserved Instance term to expire before making any changes.

D. The savings are negligible—previous-generation instances are fine.

**Correct Answer: A**

**Explanation:** Current-generation instances (m6i, c6i, r6i) offer 10-15% better price-performance over previous-generation (m4, c4, r4). For the 30% of instances ($150,000/month), this yields ~$15K-$22.5K/month savings. Compute Optimizer provides specific recommendations, and batched migration with non-production first reduces risk. Option B (simultaneous replacement) is too risky for production. Option C delays savings unnecessarily—you can modify RIs to cover new instance types. Option D is incorrect—the savings are significant at $500K/month total spend.

---

### Question 64

A company runs multiple Amazon Redshift clusters across different departments. The total Redshift spend is $80,000/month. Analysis shows: the marketing cluster runs queries only during business hours, the finance cluster is heavily used during month-end but light otherwise, and the data science cluster is used sporadically for experimental queries.

Which optimization strategy provides the MOST cost savings?

A. Convert all clusters to Redshift Serverless which charges based on actual compute usage.

B. Keep the permanently needed capacity as provisioned clusters with Reserved Nodes. Convert the marketing cluster to use Redshift pause/resume on a schedule. Convert the data science cluster to Redshift Serverless. Enable concurrency scaling for the finance cluster's month-end peaks.

C. Resize all clusters to the smallest available node type.

D. Consolidate all departments into a single Redshift cluster with WLM queues.

**Correct Answer: B**

**Explanation:** A mixed strategy optimizes each usage pattern: pause/resume saves marketing cluster costs during off-hours (~60% savings), Serverless charges data science only for actual usage (sporadic queries = significant savings), Reserved Nodes reduce base costs for consistent workloads, and concurrency scaling handles finance peaks without permanent over-provisioning. Option A (all Serverless) may cost more for the consistently used portions. Option C reduces performance. Option D creates contention between departments and loses isolation.

---

### Question 65

A company uses Amazon S3 extensively with 2 PB of total storage. Their current storage distribution is: 70% in S3 Standard, 20% in S3 Standard-IA, and 10% in S3 Glacier. An analysis of access patterns shows that 50% of the Standard-class data hasn't been accessed in over 90 days. The company wants to optimize storage costs automatically.

Which approach achieves the MOST savings with the LEAST operational overhead?

A. Manually analyze each bucket and create lifecycle rules to transition objects to appropriate storage classes.

B. Enable S3 Intelligent-Tiering on all buckets currently using S3 Standard. Intelligent-Tiering automatically moves data between Frequent Access, Infrequent Access, Archive Instant Access, Archive Access, and Deep Archive tiers based on actual access patterns.

C. Create a Lambda function that checks S3 access logs and moves objects between storage classes based on custom logic.

D. Move all data to S3 Glacier to minimize storage costs.

**Correct Answer: B**

**Explanation:** S3 Intelligent-Tiering automatically analyzes access patterns and moves objects between tiers without retrieval fees or access time impact. For 1.4 PB in Standard where 50% is infrequently accessed, the automatic tiering to IA (~40% cheaper) and archive tiers provides significant savings. The monitoring fee per object is minimal compared to storage savings at this scale. Option A requires ongoing manual analysis and rule creation. Option C adds custom code maintenance and API costs. Option D makes all data slow to retrieve, impacting frequently accessed data.

---

### Question 66

A company pays $30,000/month for NAT gateway data processing charges. Their VPC has multiple private subnets with EC2 instances, Lambda functions, and ECS tasks that access various AWS services and the internet through NAT gateways. Traffic analysis shows that 60% of NAT traffic is to S3 and DynamoDB, 25% is to other AWS services, and 15% is to external internet endpoints.

Which combination of changes provides the MOST cost reduction? (Choose TWO.)

A. Create gateway VPC endpoints for S3 and DynamoDB to eliminate NAT gateway charges for this traffic (~$18,000/month savings).

B. Create interface VPC endpoints for the other frequently used AWS services (SQS, SNS, CloudWatch, etc.) to reduce NAT gateway traffic.

C. Replace the NAT gateway with a NAT instance on a t3.micro for cost savings.

D. Move all workloads to public subnets to eliminate the need for NAT gateways entirely.

E. Enable VPC Flow Logs to track NAT gateway usage.

**Correct Answer: A, B**

**Explanation:** Gateway VPC endpoints for S3 and DynamoDB (A) are free and eliminate NAT data processing for 60% of the traffic (~$18,000/month savings). Interface VPC endpoints (B) for other AWS services reduce the 25% of remaining AWS service traffic through NAT. While interface endpoints have hourly costs, they're typically cheaper than NAT gateway data processing at high volumes. Option C (NAT instance) has lower bandwidth limits and management overhead. Option D exposes private resources to the internet. Option E provides visibility but no cost savings.

---

### Question 67

A company has a Savings Plan covering 70% of their EC2 compute usage. The remaining 30% is On-Demand. The On-Demand portion is primarily development and test workloads that run during business hours (8 AM - 6 PM, Monday to Friday). The company wants to reduce the On-Demand costs.

Which approach MOST effectively reduces the remaining On-Demand spend?

A. Purchase additional Savings Plans to cover 100% of compute.

B. Implement a scheduling solution using AWS Instance Scheduler to automatically stop development/test instances outside business hours. This eliminates ~72% of the On-Demand spend (128 of 168 weekly hours are outside business hours).

C. Convert all development workloads to Spot Instances.

D. Migrate development workloads to smaller instance types.

**Correct Answer: B**

**Explanation:** Instance Scheduler stops instances during non-business hours (nights and weekends), eliminating charges for ~72% of the weekly hours. For the 30% On-Demand spend, this saves approximately 72% of that portion. Option A commits to Savings Plans for workloads that only run part-time—wasteful. Option C (Spot) works for some workloads but not all development needs (stateful work, testing). Option D reduces costs per-hour but doesn't eliminate idle hours.

---

### Question 68

A company uses Amazon CloudFront for content delivery. They serve a mix of static assets (images, CSS, JS) and dynamic API responses. Their current CloudFront bill is $20,000/month. Analysis shows the cache hit ratio is only 45%, meaning 55% of requests go to the origin.

Which optimizations would MOST improve the cache hit ratio and reduce costs? (Choose TWO.)

A. Normalize cache keys by configuring CloudFront to forward only necessary query string parameters and headers in the cache key policy. Remove unnecessary vary dimensions.

B. Increase the default TTL from 60 seconds to 24 hours for static assets using cache behaviors matching file extensions (*.jpg, *.css, *.js).

C. Enable CloudFront Standard logging to identify cache misses.

D. Use a single CloudFront distribution for all content types.

E. Disable caching entirely to reduce complexity.

**Correct Answer: A, B**

**Explanation:** Normalizing cache keys (A) prevents cache fragmentation from unnecessary query strings and headers—identical content with different irrelevant parameters creates separate cache entries. Increasing TTL for static assets (B) keeps content in cache longer, reducing origin requests. Together, these typically improve cache hit ratio from 45% to 80%+, significantly reducing origin requests and costs. Option C provides visibility but doesn't improve the ratio. Option D doesn't address the root cause. Option E increases origin costs dramatically.

---

### Question 69

A company runs a production workload that requires exactly 20 EC2 instances of m5.2xlarge running 24/7. They currently use On-Demand pricing. The workload is expected to run for at least 3 years. The CFO wants the maximum possible cost savings with the constraint that the company prefers paying upfront for accounting simplicity.

Which purchasing option provides the MAXIMUM savings?

A. 1-year All Upfront Reserved Instances (~40% savings).

B. 3-year All Upfront Reserved Instances (~60% savings).

C. 3-year All Upfront Compute Savings Plan (~60% savings with instance flexibility).

D. 3-year All Upfront EC2 Instance Savings Plan for m5.2xlarge (~60% savings locked to instance family and Region).

**Correct Answer: C**

**Explanation:** A 3-year All Upfront Compute Savings Plan provides approximately 60% savings (similar to 3-year All Upfront RIs) with the added flexibility to change instance families, sizes, OS, tenancy, and Regions. If the workload evolves over 3 years, the company can adapt without losing the discount. Option A provides lower savings (40%). Option B provides similar savings but locks to specific instance type without flexibility. Option D provides similar savings with some flexibility (within instance family) but less than Compute Savings Plans.

---

### Question 70

A company is analyzing their AWS bill and discovers they're paying for 500 EBS snapshots totaling 50 TB, many of which are old and no longer needed. The company wants to identify and delete unnecessary snapshots while retaining snapshots needed for DR and compliance.

Which approach MOST efficiently manages EBS snapshot costs?

A. Implement Amazon Data Lifecycle Manager (DLM) policies to manage snapshot retention. Use DLM age-based retention rules to automatically delete snapshots older than the retention period. Tag snapshots required for compliance with a "retain" tag and exclude them from DLM cleanup.

B. Write a custom script that deletes all snapshots older than 30 days.

C. Delete all snapshots and create fresh ones from current volumes.

D. Convert all snapshots to Amazon S3 for cheaper storage.

**Correct Answer: A**

**Explanation:** DLM policies automate snapshot lifecycle management with configurable retention periods. Age-based rules automatically clean up old snapshots. Tagging compliance-required snapshots and excluding them from DLM ensures required snapshots are retained. This provides ongoing automated management, not just one-time cleanup. Option B risks deleting compliance-required snapshots. Option C loses DR history. Option D—snapshots can't be directly stored in S3 as usable backup formats.

---

### Question 71

A company uses AWS Lambda extensively with 200 functions. Their Lambda bill is $15,000/month. Analysis shows that 80% of the cost comes from 20 functions that run for 5-15 minutes each with memory configured at 3008 MB. The functions perform CPU-intensive image processing.

Which optimization MOST reduces Lambda costs for these functions?

A. Enable Lambda Graviton2 (ARM) architecture for the CPU-intensive functions, which offers up to 20% lower cost and 34% better price-performance. Also use AWS Lambda Power Tuning to find the optimal memory configuration for each function.

B. Migrate the functions to EC2 Spot Instances for lower cost.

C. Reduce the memory allocation to 128 MB to minimize per-ms cost.

D. Rewrite the functions in a compiled language (Go or Rust) for faster execution.

**Correct Answer: A**

**Explanation:** Lambda Graviton2 (ARM) offers 20% lower price per ms-GB. Lambda Power Tuning identifies the memory/CPU sweet spot where the function runs most cost-efficiently (right amount of memory/CPU = fastest execution × lowest cost). For CPU-intensive workloads, Graviton2's better performance per dollar is significant. Option B requires managing infrastructure and instance lifecycles. Option C reduces available CPU (Lambda allocates CPU proportional to memory), making functions run longer and potentially costing more. Option D requires significant rewriting effort.

---

### Question 72

A company runs multiple AWS accounts for different environments. They notice that each account has a default VPC with unused resources (internet gateways, subnets, security groups). The company wants to ensure new accounts don't waste resources or pose security risks from default VPCs.

Which approach prevents default VPC security risks in new accounts?

A. After creating accounts through Control Tower, use a lifecycle event to trigger a Lambda function that deletes the default VPC in all Regions using a cross-account role.

B. Create an SCP that prevents the use of default VPC resources.

C. Manually delete the default VPC in each new account.

D. Leave the default VPCs but create NACLs that deny all traffic.

**Correct Answer: A**

**Explanation:** Automating default VPC deletion through a Control Tower lifecycle event and Lambda function ensures every new account immediately has its default VPC removed across all Regions. This eliminates security risks (like accidentally launching resources in an unsecured default VPC) and reduces confusion. Option B is difficult—there's no specific SCP condition for "default VPC." Option C requires manual action for every new account in every Region. Option D leaves the VPCs active with potential for misconfiguration.

---

### Question 73

A company processes large datasets using Amazon EMR. They run 10 EMR clusters for different workloads, each running 24/7 with core nodes on On-Demand instances. Analysis shows that clusters are utilized 40% during the day and 10% at night. Task nodes are used for burst processing.

Which combination optimizes EMR costs? (Choose TWO.)

A. Use EC2 Reserved Instances or Savings Plans for the core nodes that run 24/7.

B. Use Spot Instances for all task nodes since they can be interrupted without data loss (task nodes don't store HDFS data).

C. Run all EMR nodes as Spot Instances including core and master nodes.

D. Migrate all processing to AWS Glue Serverless ETL.

E. Increase cluster sizes to reduce processing time.

**Correct Answer: A, B**

**Explanation:** Reserved Instances/Savings Plans (A) for core nodes provide up to 60% savings on the consistent 24/7 compute. Spot Instances (B) for task nodes provide up to 90% savings on burst capacity—task nodes are ideal for Spot because they only process data and don't store HDFS data, so Spot interruptions don't cause data loss. Option C puts core/master nodes on Spot risking HDFS data loss and cluster instability. Option D requires significant rewriting and not all workloads suit Glue. Option E doesn't address cost optimization.

---

### Question 74

A company has multiple AWS accounts with resources tagged inconsistently. Some resources are tagged with "environment", others with "Environment", "env", or "ENV". This inconsistency breaks their cost allocation reports. The company needs to standardize tags across all existing resources and prevent future inconsistency.

Which approach provides the MOST complete solution?

A. Use AWS Tag Editor to search and bulk-update tags across all accounts. Implement AWS Organizations Tag Policies to define the canonical tag key ("Environment") and enforce case conventions. Use SCPs with `aws:RequestTag` conditions to require the standardized tag format for new resources.

B. Write a script to update all tags in all accounts.

C. Use AWS Config to detect non-standard tags.

D. Send an email to all teams asking them to use consistent tags.

**Correct Answer: A**

**Explanation:** Tag Editor provides bulk search and update capabilities for remediating existing inconsistent tags. Tag Policies define the canonical tag key name and capitalization across the organization. SCPs with `aws:RequestTag` conditions enforce that new resources must use the standardized format. This three-part approach fixes existing tags, defines standards, and prevents future deviations. Option B handles existing tags but doesn't prevent future inconsistency. Option C detects but doesn't remediate or prevent. Option D relies on human compliance with no enforcement.

---

### Question 75

A SaaS company provides each customer a dedicated Amazon RDS PostgreSQL instance. They have 200 customers, each with a db.r5.large instance. Total RDS spend is $200,000/month. Many customer databases are underutilized (average CPU < 10%, storage < 20% used). The company wants to consolidate infrastructure while maintaining customer data isolation.

Which consolidation strategy provides the MOST cost savings while maintaining isolation?

A. Migrate all customers to a single Aurora PostgreSQL cluster with separate schemas per customer. Use IAM-based access control to enforce schema-level isolation.

B. Migrate customers to shared Aurora PostgreSQL clusters (10 clusters with 20 customers each) using separate databases per customer on the same cluster. Use PostgreSQL's role-based access control for isolation.

C. Switch all instances to db.t3.medium (burstable) instances.

D. Keep the current architecture but purchase 3-year Reserved Instances.

**Correct Answer: B**

**Explanation:** Consolidating 200 instances into 10 Aurora clusters (20 customers per cluster using separate databases) dramatically reduces the number of instances and leverages Aurora's auto-scaling. Separate databases provide strong isolation at the PostgreSQL level. This could reduce costs by 80-90% through cluster consolidation. Option A (single cluster with 200 schemas) creates a single point of failure and may hit performance limits. Option C reduces per-instance cost but maintains 200 instances. Option D saves 40-60% on RIs but doesn't address the fundamental over-provisioning.

---

## End of Practice Test 2

**Scoring Guide:**
- Each question is worth 1 point
- Total possible score: 75
- Approximate passing score: 54/75 (72%)
- Domain 1 (Q1-20): ___/20
- Domain 2 (Q21-42): ___/22
- Domain 3 (Q43-53): ___/11
- Domain 4 (Q54-62): ___/9
- Domain 5 (Q63-75): ___/13
