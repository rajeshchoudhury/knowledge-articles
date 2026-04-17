# AWS Certified Solutions Architect - Professional (SAP-C02) Practice Test 1

**Focus Areas:** VPC/Networking, S3, IAM, Lambda, AWS Organizations
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

A global enterprise has 120 AWS accounts organized under AWS Organizations with a multi-OU structure. The security team wants to ensure that no IAM user in any account can create VPC peering connections to accounts outside the organization. They also need to allow specific exceptions for three partner accounts. The solution must be centrally managed and enforce the policy across all accounts including new ones.

Which approach BEST meets these requirements?

A. Create an IAM policy in each account that denies ec2:CreateVpcPeeringConnection and attach it to all IAM users, with a condition allowing the three partner account IDs.

B. Create a Service Control Policy (SCP) attached to the root OU that denies ec2:CreateVpcPeeringConnection and ec2:AcceptVpcPeeringConnection unless the peer owner account ID matches an account within the organization or the three partner accounts.

C. Use AWS Config rules to detect VPC peering connections to unauthorized accounts and use a Lambda remediation function to delete them automatically.

D. Deploy a CloudFormation StackSet across all accounts that creates a VPC endpoint policy blocking unauthorized peering connections.

**Correct Answer: B**

**Explanation:** SCPs provide centralized, preventive guardrails that apply to all principals in member accounts. By attaching an SCP to the root OU that denies VPC peering unless the peer account is in the organization or one of the three partner accounts, you enforce the policy across all current and future accounts automatically. Option A requires per-account management and can be bypassed by users not assigned the policy. Option C is detective, not preventive—unauthorized peering could exist before remediation. Option D is incorrect because VPC endpoint policies do not control VPC peering operations.

---

### Question 2

A company operates a three-tier web application in a single VPC with public, application, and database subnets. They are expanding to a second AWS Region for disaster recovery. The application tier must communicate with the database tier in the primary Region during failover testing, and the communication must use private IP addresses only. The networking team wants minimal operational overhead.

Which solution should a solutions architect recommend?

A. Set up an inter-Region VPC peering connection between the VPCs in the two Regions. Update route tables in both VPCs to route traffic through the peering connection.

B. Deploy a transit gateway in each Region and configure inter-Region transit gateway peering. Attach the VPCs to their respective transit gateways and configure appropriate route tables.

C. Create a Site-to-Site VPN connection between the two VPCs across Regions using virtual private gateways.

D. Use AWS PrivateLink to expose the database tier as a service and create an interface VPC endpoint in the DR Region's VPC.

**Correct Answer: A**

**Explanation:** Inter-Region VPC peering provides private connectivity between two VPCs across Regions with low operational overhead. It supports private IP communication, is encrypted in transit, and requires only route table updates. Option B (Transit Gateway peering) works but adds unnecessary complexity and cost for a simple two-VPC setup. Option C (VPN) introduces management overhead for VPN tunnels and has lower bandwidth compared to peering. Option D (PrivateLink) would require significant architectural changes to expose the database tier as a service and is designed for service-consumer patterns, not general network connectivity.

---

### Question 3

A financial services company uses AWS Organizations with consolidated billing. They have 50 accounts across development, staging, and production OUs. The CTO requires that all S3 buckets across every account must have default encryption enabled with AWS KMS keys, and versioning must be turned on. They need to detect and auto-remediate any non-compliant buckets.

Which combination of services provides the MOST operationally efficient solution? (Choose TWO.)

A. Deploy AWS Config conformance packs across all accounts using a delegated administrator account with rules for s3-bucket-server-side-encryption-enabled and s3-bucket-versioning-enabled.

B. Create a Lambda function in each account triggered by CloudTrail events for CreateBucket that checks and remediates encryption and versioning settings.

C. Use AWS Config automatic remediation with SSM Automation documents to enable encryption and versioning on non-compliant buckets.

D. Enable AWS Security Hub across the organization and use the AWS Foundational Security Best Practices standard to monitor S3 settings.

E. Write a script that runs daily on an EC2 instance in the management account to scan all buckets in all accounts using AssumeRole.

**Correct Answer: A, C**

**Explanation:** AWS Config conformance packs (A) can be deployed organization-wide from a delegated administrator, providing consistent compliance detection across all 50 accounts. Combined with Config automatic remediation using SSM Automation documents (C), non-compliant buckets are automatically corrected. Option B is operationally heavy as it requires Lambda deployment in every account. Option D monitors but doesn't auto-remediate. Option E is a custom solution with significant operational overhead and potential failure points.

---

### Question 4

A multinational corporation wants to implement a centralized networking model where all internet-bound traffic from 15 VPCs across 3 Regions must flow through a set of inspection VPCs containing third-party firewall appliances. The VPCs are in different AWS accounts under the same organization. The solution must scale as new VPCs are added and minimize operational overhead.

Which architecture BEST meets these requirements?

A. Deploy a transit gateway in each Region with the firewall appliance VPCs attached. Use transit gateway route tables to route all internet traffic through the inspection VPCs. Peer the transit gateways across Regions for inter-Region traffic.

B. Create VPC peering connections from each VPC to the inspection VPC in that Region. Use route tables to direct 0.0.0.0/0 traffic through the peering connection.

C. Set up AWS Network Firewall in each VPC with identical rule groups managed through AWS Firewall Manager.

D. Use AWS CloudWAN with a global network to connect all VPCs and define network segments that route internet traffic through the inspection VPCs.

**Correct Answer: D**

**Explanation:** AWS CloudWAN provides a centralized, global network management plane purpose-built for multi-Region, multi-account networking. It supports network segments, automated attachments for new VPCs, and policy-driven routing, which makes scaling as new VPCs are added simpler. Option A works but requires manual configuration of transit gateways and peering across Regions with operational overhead. Option B doesn't scale—VPC peering is non-transitive and requires N connections. Option C replaces the third-party firewalls with AWS Network Firewall, which doesn't meet the requirement to use existing third-party appliances.

---

### Question 5

A company is building a data lake on Amazon S3. Multiple teams across 10 AWS accounts need access to a shared S3 bucket in a central data account. The security team requires that access be granted at the column level for sensitive data stored in Parquet files. They need a centralized permission model that works with both Athena and Redshift Spectrum queries.

Which solution BEST addresses these requirements?

A. Create S3 bucket policies with conditions for each account and use S3 Select to restrict column access.

B. Use AWS Lake Formation to register the S3 data location, define column-level permissions, and grant cross-account access using Lake Formation's permission model.

C. Set up IAM roles in the data account for each team with S3 bucket policies restricting access to specific S3 object prefixes representing columns.

D. Deploy Amazon Macie to classify sensitive columns and create S3 Access Points with policies for each account.

**Correct Answer: B**

**Explanation:** AWS Lake Formation provides centralized, fine-grained access control including column-level permissions that work seamlessly with both Athena and Redshift Spectrum. It supports cross-account data sharing and provides a unified permission model across analytics services. Option A is incorrect because S3 bucket policies and S3 Select don't provide column-level security for analytics queries. Option C uses prefix-based access which doesn't map to Parquet columns. Option D uses Macie for classification only, and S3 Access Points don't provide column-level control.

---

### Question 6

A healthcare company has a HIPAA-compliant application running in AWS. They need to implement a solution where AWS Lambda functions in a private subnet can access both an Amazon RDS database in the same VPC and an external third-party API over the internet. The Lambda functions process PHI (Protected Health Information), so all traffic must be logged and inspectable. No Lambda function should be able to access arbitrary internet destinations.

Which architecture meets all these requirements?

A. Place Lambda functions in private subnets with a NAT gateway in a public subnet. Use security groups to restrict outbound traffic to the RDS instance and the third-party API's IP range.

B. Place Lambda functions in private subnets with a NAT gateway in a public subnet. Route internet traffic through an AWS Network Firewall with domain filtering rules allowing only the third-party API domain. Enable VPC Flow Logs.

C. Configure Lambda functions with a VPC endpoint for RDS and use the default Lambda internet access (outside VPC) for the third-party API calls.

D. Place Lambda functions in public subnets with an Elastic IP. Use network ACLs to restrict traffic to the RDS instance and the third-party API.

**Correct Answer: B**

**Explanation:** Placing Lambda in private subnets with a NAT gateway enables internet access, while AWS Network Firewall with domain filtering ensures only the approved third-party API domain is reachable—meeting the requirement that arbitrary internet access is blocked. VPC Flow Logs provide the traffic logging needed for HIPAA compliance. Option A uses security groups which work on IP addresses, not domains—the third-party API's IPs could change. Option C would split Lambda traffic paths, making PHI data handling inconsistent and unloggable for internet-bound traffic. Option D is incorrect because Lambda functions cannot be placed in public subnets with Elastic IPs.

---

### Question 7

An organization with 200+ AWS accounts uses AWS Organizations. The central cloud team wants to share common VPC subnets with member accounts to reduce IP address waste and simplify network management. Development teams in member accounts should be able to launch EC2 instances and other resources in the shared subnets but should NOT be able to modify the VPC configuration, route tables, or security groups owned by the networking account.

Which approach achieves this?

A. Use AWS Resource Access Manager (RAM) to share the VPC subnets with the organization. Resource owners in the networking account retain control of VPC-level resources, and participants can only launch resources in the shared subnets.

B. Create VPC peering connections from each member account's VPC to the central networking VPC. Configure route tables for bidirectional communication.

C. Deploy a transit gateway and attach all member account VPCs. Use shared services VPC for common resources.

D. Create cross-account IAM roles that allow member accounts to assume a role in the networking account with limited EC2 permissions.

**Correct Answer: A**

**Explanation:** AWS RAM allows sharing VPC subnets across accounts within an organization. The networking account (owner) retains full control of VPC resources like route tables, security groups, and NACLs, while participant accounts can launch resources in the shared subnets but cannot modify the underlying network configuration. Option B creates separate VPCs requiring peering—doesn't reduce IP waste. Option C provides connectivity but doesn't share subnets. Option D requires cross-account role assumption which adds complexity and doesn't provide native subnet sharing.

---

### Question 8

A company has an application that uses Amazon S3 to store customer documents. The compliance team requires that once a document is uploaded, it cannot be deleted or overwritten for 7 years. However, users should be able to add metadata tags to documents at any time. The solution must satisfy SEC Rule 17a-4(f) compliance requirements.

Which S3 configuration meets these requirements?

A. Enable S3 Versioning and create a lifecycle rule to transition objects to S3 Glacier after 1 day. Use a Glacier Vault Lock policy with a compliance retention period of 7 years.

B. Enable S3 Object Lock in Compliance mode with a default retention period of 7 years on the bucket.

C. Enable S3 Object Lock in Governance mode with a default retention period of 7 years and enable MFA Delete.

D. Enable S3 Versioning with MFA Delete and create a bucket policy that denies s3:DeleteObject actions for all principals.

**Correct Answer: B**

**Explanation:** S3 Object Lock in Compliance mode meets SEC 17a-4(f) requirements. In Compliance mode, no user—including the root account—can delete or overwrite a protected object version until the retention period expires. Users can still modify object tags since tagging is separate from the object data. Option A adds unnecessary complexity with Glacier and vault locks are a different mechanism. Option C uses Governance mode which allows users with special permissions to override the retention—not sufficient for SEC 17a-4(f). Option D can be circumvented by modifying the bucket policy.

---

### Question 9

A large enterprise wants to implement a hub-and-spoke network architecture with a shared services VPC as the hub. The hub VPC must provide DNS resolution, centralized NAT, and VPN connectivity to the on-premises data center. There are 50 spoke VPCs across multiple accounts. The enterprise needs a solution that supports overlapping CIDR ranges in some spoke VPCs.

Which solution addresses all these requirements including overlapping CIDRs?

A. Use AWS Transit Gateway with a single route table. Attach all spoke VPCs and the hub VPC. Propagate routes from all attachments.

B. Use AWS Transit Gateway with multiple route tables for network segmentation. Use AWS PrivateLink for services that need cross-VPC communication where CIDRs overlap.

C. Create VPC peering connections between each spoke and the hub VPC. Use Route 53 private hosted zones for DNS resolution.

D. Deploy AWS CloudWAN with network segments for groups of VPCs and use NAT gateways in the hub segment for centralized internet access.

**Correct Answer: B**

**Explanation:** Transit Gateway with multiple route tables provides the hub-and-spoke model, and AWS PrivateLink resolves the overlapping CIDR problem by enabling service-based connectivity that doesn't rely on IP routing. VPCs with overlapping CIDRs cannot route to each other via Transit Gateway, but PrivateLink uses ENIs with VPC-local addresses. Option A fails because a single route table cannot handle overlapping CIDRs. Option C doesn't support overlapping CIDRs either and doesn't scale well. Option D is viable for segmentation but doesn't inherently solve the overlapping CIDR problem for direct cross-VPC communication.

---

### Question 10

A company is implementing a multi-account strategy using AWS Organizations. They need to ensure that specific AWS services are completely disabled in development accounts while being fully available in production accounts. The services to be restricted include Amazon EMR, Amazon Redshift, and Amazon SageMaker. The policy must automatically apply to any new development account.

Which implementation is MOST effective?

A. Create an SCP that denies access to EMR, Redshift, and SageMaker APIs. Attach the SCP to the Development OU.

B. Create IAM permission boundaries in each development account that deny access to EMR, Redshift, and SageMaker services.

C. Use AWS Service Catalog to create a portfolio that only includes approved services for development accounts.

D. Implement AWS Config rules that detect when EMR, Redshift, or SageMaker resources are created in development accounts and trigger Lambda to terminate them.

**Correct Answer: A**

**Explanation:** SCPs attached to the Development OU will prevent any principal in any current or future development account from using the specified services. SCPs are preventive controls that automatically apply to new accounts placed in the OU. Option B requires manual deployment in each new account and can't restrict the root user. Option C controls what can be provisioned through Service Catalog but doesn't prevent direct API calls. Option D is reactive—resources would exist briefly before being terminated, and it requires ongoing maintenance.

---

### Question 11

A media company runs a content delivery platform where users upload videos to S3. The videos must be processed by a Lambda function that generates thumbnails and transcodes them. During peak events, upload rates spike from 100/hour to 50,000/hour. The Lambda function takes 3-5 minutes per video. The company is experiencing Lambda throttling during peaks and wants a solution that handles bursts without losing any upload events.

Which architecture resolves the throttling issue while ensuring no uploads are lost?

A. Configure S3 event notifications to invoke Lambda directly. Increase the Lambda reserved concurrency to 10,000.

B. Configure S3 event notifications to send messages to an Amazon SQS queue. Configure the Lambda function with the SQS queue as an event source with a maximum concurrency setting.

C. Use S3 Event Notifications with Amazon SNS to fan out to multiple Lambda functions for parallel processing.

D. Enable S3 Transfer Acceleration and configure S3 Batch Operations to process uploaded objects periodically.

**Correct Answer: B**

**Explanation:** Using SQS as a buffer between S3 events and Lambda decouples the upload rate from the processing rate. SQS reliably stores all messages (no loss), and Lambda's event source mapping with maximum concurrency setting allows controlled processing without throttling. Messages remain in the queue until successfully processed. Option A would still cause throttling even with high reserved concurrency due to account-level limits and burst limits. Option C fans out to more Lambda invocations, worsening the throttling. Option D is for batch processing and transfer optimization, not event-driven processing.

---

### Question 12

A company has a VPC with a CIDR block of 10.0.0.0/16. They've exhausted the IP address space and need additional addresses. The VPC hosts critical production workloads and cannot tolerate downtime. The company also needs to ensure the new address space is routable to their on-premises network via an existing AWS Direct Connect connection.

What should a solutions architect recommend?

A. Create a new VPC with a larger CIDR block. Migrate all resources to the new VPC using AWS Application Migration Service.

B. Associate a secondary CIDR block with the existing VPC. Create new subnets using the secondary CIDR range. Advertise the new CIDR on the Direct Connect connection via BGP.

C. Create a new VPC with additional CIDR space and peer it with the existing VPC. Update route tables on both sides.

D. Modify the existing VPC's CIDR block from /16 to /8 to increase the available address space.

**Correct Answer: B**

**Explanation:** AWS allows associating secondary CIDR blocks with an existing VPC (up to 5 by default, extendable). This expands the address space without affecting running resources. New subnets can be created in the secondary CIDR range. The new CIDR can be advertised over Direct Connect via BGP for on-premises routing. Option A causes downtime during migration. Option C works but adds complexity with peering and doesn't extend the same VPC. Option D is not possible—VPC CIDR blocks cannot be modified after creation.

---

### Question 13

An enterprise has deployed an application using API Gateway and Lambda. The API serves internal users across 5 different AWS accounts in the organization. The security team requires that the API be accessible only from VPCs in these 5 accounts—not from the internet. The solution must not require managing IP addresses or VPN connections.

Which approach meets these requirements?

A. Deploy a Regional API Gateway with a resource policy that allows access only from the 5 account IDs. Use IAM authentication.

B. Deploy a private API Gateway with a VPC endpoint for execute-api in each of the 5 accounts. Configure the API Gateway resource policy to allow access from the VPC endpoints.

C. Deploy an edge-optimized API Gateway with AWS WAF rules that restrict access to known IP ranges of the 5 accounts' VPCs.

D. Deploy the Lambda function in a VPC and use an Application Load Balancer with cross-account target groups.

**Correct Answer: B**

**Explanation:** A private API Gateway is only accessible through VPC endpoints (Interface endpoints for execute-api). Creating VPC endpoints in each of the 5 accounts and specifying them in the API's resource policy ensures the API is accessible only from those VPCs, with no internet exposure. Option A with a Regional API is internet-accessible even with a restrictive resource policy—it still has a public endpoint. Option C uses WAF with IP-based rules which requires IP management. Option D changes the architecture fundamentally and ALBs don't natively support cross-account Lambda targets in this pattern.

---

### Question 14

A retail company uses a microservices architecture with 30 services communicating via REST APIs. Each service runs on ECS with Fargate. The company is experiencing intermittent failures due to service-to-service communication issues, and the operations team lacks visibility into which service calls are failing. They need distributed tracing, traffic management, and the ability to implement circuit breakers without modifying application code.

Which combination provides the BEST solution?

A. Implement AWS App Mesh with Envoy sidecar proxies for all services. Enable AWS X-Ray integration for distributed tracing.

B. Deploy an Application Load Balancer for each service and enable access logging. Use CloudWatch Container Insights for monitoring.

C. Implement Amazon API Gateway between all services for traffic management. Enable CloudWatch Logs for API call tracking.

D. Use AWS Cloud Map for service discovery and implement retry logic in each microservice's application code.

**Correct Answer: A**

**Explanation:** AWS App Mesh provides a service mesh with Envoy sidecar proxies that handle traffic management, circuit breakers, and retries without application code changes. Integrating with X-Ray provides end-to-end distributed tracing across all services. Option B provides basic load balancing and monitoring but no circuit breakers or traffic management. Option C would add significant latency and cost with API Gateway between every service. Option D requires code changes in all 30 services and doesn't provide traffic management or circuit breakers.

---

### Question 15

A company with an AWS Organization has a logging account that collects CloudTrail logs from all 80 member accounts into a central S3 bucket. The CISO requires that these logs be immutable—no one, including administrators in the logging account, should be able to delete or modify the logs for 1 year. The solution must also protect against the management account disabling CloudTrail.

Which combination of controls provides the STRONGEST protection? (Choose TWO.)

A. Enable S3 Object Lock in Compliance mode on the logging bucket with a 1-year retention period.

B. Create an SCP attached to the root OU that denies cloudtrail:StopLogging, cloudtrail:DeleteTrail, and cloudtrail:UpdateTrail actions for all principals.

C. Enable MFA Delete on the logging bucket and require MFA for all delete operations.

D. Create a bucket policy that denies all delete operations and enable S3 Versioning.

E. Use S3 Glacier Vault Lock with a compliance policy for archiving CloudTrail logs.

**Correct Answer: A, B**

**Explanation:** S3 Object Lock in Compliance mode (A) ensures no one—including the root user—can delete or modify log objects for the retention period, providing true immutability. The SCP (B) prevents anyone in any member account from stopping or modifying CloudTrail. Note: SCPs don't apply to the management account, but combined with Compliance mode Object Lock, even management account actions can't delete the logs already written. Option C (MFA Delete) can be bypassed by the root user. Option D (bucket policy) can be modified by anyone with sufficient IAM permissions. Option E adds unnecessary Glacier complexity when Object Lock on S3 achieves the same immutability.

---

### Question 16

A SaaS company needs to provide each of their 500 customers with an isolated AWS environment for data processing. Each customer environment needs access to a shared data lake in a central account. The company wants to minimize the number of AWS accounts while maintaining strong isolation between customers.

Which architecture BEST balances isolation and operational efficiency?

A. Create a separate AWS account for each customer under AWS Organizations. Use AWS RAM to share the data lake S3 bucket.

B. Use a single AWS account with separate VPCs per customer. Use VPC endpoints to access the shared data lake. Implement IAM policies with customer-specific prefixes.

C. Group customers into 10 AWS accounts (50 customers each). Use IAM roles with session tags for customer isolation. Access the central data lake via Lake Formation cross-account permissions.

D. Create an account per customer and deploy the data lake in each account using cross-account replication from the central account.

**Correct Answer: C**

**Explanation:** Grouping 50 customers per account (10 accounts total) balances operational overhead with isolation. IAM session tags enable per-customer access control within each account, and Lake Formation cross-account permissions provide fine-grained access to the shared data lake. Option A (500 accounts) creates extreme operational overhead. Option B (single account, 500 VPCs) risks hitting VPC limits and provides weaker isolation. Option D replicates the data lake 500 times, causing enormous storage costs and data synchronization challenges.

---

### Question 17

A company's security team has mandated that all Lambda functions must run inside a VPC and can only access the internet through a centralized egress point with inspection capabilities. The company has 20 AWS accounts each with multiple Lambda functions. The networking team maintains a shared services account with a transit gateway and egress VPC containing AWS Network Firewall.

How should the solutions architect configure Lambda networking to meet these requirements?

A. Place Lambda functions in private subnets in each account's VPC. Attach each VPC to the transit gateway. Configure transit gateway route tables to send 0.0.0.0/0 to the egress VPC. Deploy NAT gateways behind the Network Firewall in the egress VPC.

B. Place Lambda functions in private subnets with NAT gateways in each account's VPC. Use VPC Flow Logs for inspection.

C. Use Lambda@Edge for all functions to route traffic through CloudFront with AWS WAF for inspection.

D. Deploy a proxy server fleet on EC2 in the shared services account. Configure Lambda environment variables to use the proxy for all outbound requests.

**Correct Answer: A**

**Explanation:** Placing Lambda in private subnets with traffic routed through the transit gateway to a centralized egress VPC with Network Firewall provides centralized, inspectable internet egress. This is the standard hub-and-spoke pattern for centralized egress. Option B gives each account its own internet path, bypassing centralized inspection. Option C is for edge computing and doesn't apply to backend Lambda functions. Option D requires application-level proxy configuration in every Lambda function and is fragile.

---

### Question 18

A company is using AWS IAM Identity Center (successor to AWS SSO) with an external identity provider (Okta) for workforce access to 60 AWS accounts. A new compliance requirement states that users accessing production accounts must authenticate with a stronger MFA method (hardware security key) compared to non-production accounts (which can use any MFA method). Users must re-authenticate with the hardware key when switching from a non-production to a production context.

How should this be implemented?

A. Configure Okta to require hardware MFA for all authentication requests. Use IAM Identity Center permission sets to differentiate production and non-production access.

B. Create two separate IAM Identity Center instances—one for production with hardware MFA required and one for non-production. Sync users from Okta to both instances.

C. In IAM Identity Center, create permission sets for production accounts with session policies that require `aws:MultiFactorAuthPresent` and `aws:MultiFactorAuthAge` conditions. Configure Okta authentication policies to require hardware key for the production app assignment.

D. Use IAM roles in production accounts with trust policies that require specific SAML claims from Okta indicating hardware MFA was used. Configure Okta sign-on policies to require hardware MFA for the production SAML app.

**Correct Answer: D**

**Explanation:** Configuring IAM roles in production accounts with trust policies that check SAML MFA claims allows enforcing hardware MFA specifically for production access. Okta sign-on policies can be configured per application to require hardware security keys for the production SAML application. This ensures re-authentication with hardware MFA when accessing production. Option A requires hardware MFA for all contexts, not just production. Option B (two Identity Center instances) is not supported—one organization can have one Identity Center instance. Option C is closer but IAM Identity Center doesn't natively support session-level MFA re-authentication based on account context.

---

### Question 19

An e-commerce company stores product images in Amazon S3. Their application serves images to users worldwide through CloudFront. During a recent promotion, origin requests to S3 spiked and caused HTTP 503 errors. The company wants to ensure S3 can handle future traffic spikes while keeping images as fresh as possible (new images available within 5 minutes).

Which solution addresses both reliability and freshness requirements?

A. Enable S3 Transfer Acceleration and increase the CloudFront TTL to 24 hours.

B. Configure CloudFront Origin Shield in the Region closest to the S3 bucket. Set the default TTL to 5 minutes and configure stale-while-revalidate behavior.

C. Replicate the S3 bucket to multiple Regions. Configure CloudFront with an origin group using the replicas as failover origins.

D. Place an Application Load Balancer in front of the S3 bucket to absorb traffic spikes.

**Correct Answer: B**

**Explanation:** CloudFront Origin Shield adds a centralized caching layer that reduces the number of requests reaching S3, protecting against traffic spikes. Setting TTL to 5 minutes ensures images are refreshed within the required window. Origin Shield collapses duplicate origin requests, dramatically reducing S3 load. Option A doesn't reduce origin requests (Transfer Acceleration speeds uploads, not reads) and a 24-hour TTL violates the 5-minute freshness requirement. Option C adds replication cost and complexity but doesn't reduce the total origin request volume. Option D adds unnecessary infrastructure—ALBs are not designed to cache or buffer S3 traffic.

---

### Question 20

A company has implemented AWS Control Tower to manage their multi-account environment. After six months, they discover that several accounts were created outside of Control Tower (through the Organizations API directly). These accounts don't have the required guardrails, logging, or baseline configurations. The company needs to bring these accounts into compliance without recreating them.

What is the MOST efficient approach?

A. Delete the non-compliant accounts and recreate them through the Control Tower Account Factory.

B. Use the Control Tower "Enroll account" feature to enroll the existing accounts into the appropriate OUs, which applies the guardrails and baseline configurations.

C. Manually create the required CloudTrail trails, Config rules, and IAM roles in each account to match the Control Tower baseline.

D. Move the accounts to the Control Tower-managed OUs in Organizations and wait for guardrails to propagate automatically.

**Correct Answer: B**

**Explanation:** AWS Control Tower provides an "Enroll account" feature that brings existing AWS accounts into Control Tower governance. This process deploys the baseline resources (CloudTrail, Config, IAM roles) and applies the guardrails for the target OU. Option A is disruptive and would require migrating all resources. Option C is error-prone and doesn't fully integrate with Control Tower's management. Option D just moves accounts to an OU but doesn't deploy the baseline resources—Control Tower needs to explicitly enroll the account.

---

### Question 21

A company is designing a new real-time data processing pipeline. IoT sensors send data at a rate of 100,000 messages per second. Each message is 1 KB. The data must be processed in real-time for anomaly detection and also stored for batch analytics. The anomaly detection algorithm requires stateful processing with windowed aggregations over 5-minute intervals.

Which architecture BEST handles both requirements?

A. Amazon Kinesis Data Streams for ingestion → AWS Lambda for anomaly detection → Amazon S3 for storage. Use Kinesis Data Firehose for the S3 delivery.

B. Amazon Kinesis Data Streams for ingestion → Amazon Managed Service for Apache Flink for stateful anomaly detection → Amazon S3 via Firehose for batch analytics storage.

C. Amazon SQS for ingestion → Amazon EC2 Auto Scaling consumer fleet for anomaly detection → Amazon Redshift for batch analytics.

D. Amazon MSK (Managed Streaming for Apache Kafka) for ingestion → AWS Lambda consumers for anomaly detection → Amazon DynamoDB for storage.

**Correct Answer: B**

**Explanation:** Kinesis Data Streams handles the high-throughput ingestion (100K msg/sec). Amazon Managed Service for Apache Flink provides stateful stream processing with native support for windowed aggregations, making it ideal for the 5-minute anomaly detection windows. Firehose delivers data to S3 for batch analytics. Option A uses Lambda which doesn't support stateful windowed processing natively. Option C uses SQS which lacks ordering guarantees needed for time-series processing. Option D uses Lambda which has the same stateful processing limitation, and DynamoDB isn't optimal for batch analytics.

---

### Question 22

A company is building a document management system where users upload PDF documents that need to be: (1) scanned for malware, (2) text-extracted using OCR, (3) classified by document type, and (4) stored with extracted metadata. The system must handle 10,000 documents per day with variable upload patterns—mostly during business hours.

Which serverless architecture is MOST appropriate?

A. S3 upload → Lambda (malware scan) → Lambda (OCR using Amazon Textract) → Lambda (classification using Amazon Comprehend) → DynamoDB (metadata) + S3 (storage)—orchestrated by AWS Step Functions.

B. S3 upload → EC2 instance running ClamAV → Amazon Textract → Amazon SageMaker for classification → Amazon RDS for metadata.

C. S3 upload → Amazon EventBridge triggering an ECS Fargate task for the entire pipeline → Amazon OpenSearch for metadata.

D. S3 upload → Amazon SQS → Lambda monolith function that performs all four steps sequentially → S3 + DynamoDB.

**Correct Answer: A**

**Explanation:** Step Functions orchestrating individual Lambda functions for each step provides a serverless, scalable pipeline with clear separation of concerns. Textract handles OCR, Comprehend handles classification, and the workflow handles retries and error handling natively. Option B uses EC2 and RDS—not serverless and requires capacity management. Option C processes everything in a single Fargate task, losing the benefits of service-specific tools like Textract and Comprehend. Option D is a monolith Lambda that would likely exceed the 15-minute timeout and is harder to debug and maintain.

---

### Question 23

A company runs a high-performance computing (HPC) workload on AWS. The workload requires 500 EC2 instances of the c5n.18xlarge type running tightly coupled MPI-based simulations. The instances need the lowest possible inter-node latency. The simulations run for 8-12 hours and are launched 3 times per week.

Which configuration provides the BEST performance?

A. Launch instances in a cluster placement group within a single Availability Zone. Use Elastic Fabric Adapter (EFA) for inter-instance communication.

B. Launch instances spread across multiple Availability Zones for high availability. Use enhanced networking with ENA.

C. Use AWS ParallelCluster with a placement group spanning two Availability Zones for fault tolerance.

D. Launch instances using a spread placement group for maximum hardware diversity. Use enhanced networking.

**Correct Answer: A**

**Explanation:** A cluster placement group in a single AZ places instances on proximate hardware for the lowest network latency. EFA provides OS-bypass networking specifically designed for MPI workloads, delivering significantly lower latency than standard networking. Option B spreads across AZs which increases latency between nodes. Option C spanning two AZs adds inter-AZ latency to MPI communications. Option D uses spread placement which maximizes distance between instances—the opposite of what's needed for tightly coupled HPC.

---

### Question 24

A financial trading application requires single-digit millisecond read latency for 50 million records in a key-value store. The data access pattern is 90% reads and 10% writes. Individual records are up to 4 KB. The application needs strong consistency for reads immediately after writes to the same key, but eventual consistency is acceptable for reads to different keys.

Which database solution is MOST cost-effective while meeting the latency requirements?

A. Amazon DynamoDB with DynamoDB Accelerator (DAX) for caching. Use strongly consistent reads.

B. Amazon DynamoDB with on-demand capacity. Use strongly consistent reads for all operations.

C. Amazon ElastiCache for Redis with read replicas. Persist data to DynamoDB.

D. Amazon Aurora with read replicas and an ElastiCache caching layer.

**Correct Answer: A**

**Explanation:** DynamoDB provides single-digit millisecond latency natively, and DAX adds microsecond read latency for cached items—ideal for the 90% read workload. Using strongly consistent reads for same-key access after writes meets the consistency requirement. DAX reduces the read cost significantly with a 90% read workload. Option B without DAX works but is more expensive at scale for read-heavy workloads. Option C adds operational complexity managing two systems. Option D uses a relational database that's not optimized for key-value access patterns at this scale.

---

### Question 25

A company is designing a multi-Region active-active architecture for their web application. The application stores user session data that must be accessible from both Regions with sub-10ms read latency. Session data changes frequently and must be consistent across Regions within 1 second.

Which solution BEST meets these requirements?

A. Amazon ElastiCache for Redis with Global Datastore. Configure active-active replication between the two Regions.

B. Amazon DynamoDB Global Tables with the application reading from the local Region's table.

C. Amazon RDS Multi-AZ with cross-Region read replicas. Direct reads to the local read replica.

D. Amazon S3 with Cross-Region Replication and S3 Select for querying session data.

**Correct Answer: B**

**Explanation:** DynamoDB Global Tables provides multi-Region, active-active replication with sub-second replication latency and single-digit millisecond local read/write latency. Both Regions can read and write independently. Option A (ElastiCache Global Datastore) supports cross-Region replication but the secondary is read-only, not active-active for writes. Option C has higher latency for cross-Region replication and read replicas have replication lag. Option D is not designed for low-latency session data access.

---

### Question 26

A company needs to host a static website with a custom domain (example.com) using HTTPS. The website must be served globally with low latency. They also need to redirect all HTTP requests to HTTPS and redirect www.example.com to example.com. The solution should be cost-effective and require minimal operational overhead.

Which architecture achieves this?

A. Host the website on S3 with static website hosting enabled. Create a CloudFront distribution with an ACM certificate in us-east-1. Configure Route 53 alias records for both the apex domain and www subdomain, with the www distribution configured to redirect to the apex domain.

B. Deploy the website on an EC2 instance behind an Application Load Balancer with an ACM certificate. Use Route 53 to point the domain to the ALB.

C. Host the website on S3 with static website hosting. Use Route 53 alias records pointing directly to the S3 website endpoint.

D. Deploy an AWS Amplify Hosting application connected to a Git repository. Configure the custom domain in Amplify.

**Correct Answer: A**

**Explanation:** S3 + CloudFront is the standard pattern for globally distributed static websites. CloudFront provides HTTPS with ACM certificates (must be in us-east-1), global edge caching, and HTTP-to-HTTPS redirect. Two CloudFront distributions (or behaviors) handle the www-to-apex redirect. Option B uses EC2/ALB which is more expensive and operationally heavy for a static site. Option C doesn't support HTTPS for custom domains (S3 website endpoints don't support HTTPS directly). Option D works but adds unnecessary CI/CD overhead for a simple static site.

---

### Question 27

A company needs to process credit card transactions in compliance with PCI DSS. The processing application runs on EC2 instances in a dedicated VPC. The company needs to ensure network isolation of the cardholder data environment (CDE), encrypt all data in transit and at rest, and maintain detailed audit logs. Access to the CDE must be strictly limited to authorized personnel.

Which combination of measures addresses PCI DSS network isolation requirements? (Choose THREE.)

A. Deploy the CDE in a dedicated VPC with no internet gateway. Use VPC endpoints for AWS service access.

B. Implement network ACLs and security groups that follow the principle of least privilege, allowing only necessary traffic flows.

C. Use AWS PrivateLink for all connections between the CDE VPC and other VPCs containing non-CDE workloads.

D. Deploy a web application firewall (WAF) on the CloudFront distribution serving the application.

E. Enable VPC Flow Logs on all subnets and ENIs in the CDE VPC and send logs to a separate security account.

**Correct Answer: A, B, E**

**Explanation:** PCI DSS requires network segmentation (A—dedicated VPC with no direct internet access), firewall controls (B—security groups and NACLs for least-privilege traffic), and monitoring/logging (E—VPC Flow Logs for audit trails). Option C is useful but not a core isolation requirement—PrivateLink is one connectivity option but the question asks about CDE isolation. Option D applies WAF at CloudFront which is outside the CDE boundary and doesn't address network isolation of the CDE itself.

---

### Question 28

A machine learning team needs to train a deep learning model using a cluster of 8 GPU instances (p4d.24xlarge). Training takes approximately 48 hours. The model checkpoints are saved every 2 hours to prevent loss of progress. The team wants the MOST cost-effective compute option while accepting that training may be interrupted and resumed.

Which approach provides the BEST cost optimization?

A. Use On-Demand p4d.24xlarge instances for the entire 48-hour training run.

B. Use Spot Instances for the GPU cluster with checkpointing to Amazon S3. Implement a mechanism to resume training from the latest checkpoint when Spot interruptions occur.

C. Reserve p4d.24xlarge instances with a 1-year No Upfront Reserved Instance commitment.

D. Use a mix of On-Demand (2 instances) and Spot (6 instances) with checkpointing and the ability to continue training with a reduced cluster on interruption.

**Correct Answer: B**

**Explanation:** Spot Instances offer up to 90% savings over On-Demand. Since the training already implements checkpointing every 2 hours, the maximum lost work on interruption is 2 hours. The training can resume from the last checkpoint, making Spot interruptions manageable. Option A is the most expensive option. Option C requires a 1-year commitment for workloads that run only periodically. Option D adds complexity with mixed instance types and partial cluster training could affect model convergence.

---

### Question 29

A company is building a RESTful API that must authenticate requests from both internal microservices and external third-party applications. Internal services use IAM roles, while external applications use OAuth 2.0 tokens issued by an external identity provider. The API must support both authentication methods simultaneously and apply different rate limits based on the caller type.

Which API Gateway configuration achieves this?

A. Deploy two separate API Gateway REST APIs—one with IAM authorization for internal callers and one with a Lambda authorizer for external callers. Use Route 53 weighted routing to direct traffic.

B. Deploy a single API Gateway REST API with a Lambda authorizer that validates both IAM signatures and OAuth 2.0 tokens, returning different context variables for rate limiting via usage plans.

C. Deploy a single API Gateway HTTP API with a JWT authorizer for external tokens and IAM authorization for internal callers. Use API keys for rate limiting.

D. Deploy a single API Gateway REST API. Use IAM authorization as the default. Create a separate resource path (/external/*) with a Cognito User Pool authorizer for external applications. Apply different usage plans to each path.

**Correct Answer: B**

**Explanation:** A Lambda authorizer can implement custom logic to handle both authentication methods—checking for IAM signatures and validating OAuth 2.0 tokens. It can return context variables that API Gateway uses to associate callers with different usage plans for rate limiting. Option A requires maintaining two APIs and doesn't properly separate routing. Option C is close but HTTP API JWT authorizers don't validate IAM signatures. Option D separates by path which creates different URL structures for internal vs external callers and Cognito isn't needed for an external OAuth provider.

---

### Question 30

A gaming company stores player profiles in Amazon DynamoDB. During game launches, read traffic spikes from 10,000 to 500,000 reads per second for popular player profiles (hot keys). The company needs to handle these spikes without increasing DynamoDB provisioned capacity to handle the peak, as the spikes last only 30-60 minutes.

Which solution MOST effectively handles the hot key issue?

A. Switch to DynamoDB on-demand capacity mode to automatically scale with the traffic spike.

B. Implement DynamoDB Accelerator (DAX) in front of the DynamoDB table to cache frequently accessed player profiles.

C. Increase the number of partitions by adding a random suffix to the partition key.

D. Use ElastiCache for Redis as a write-through cache in front of DynamoDB.

**Correct Answer: B**

**Explanation:** DAX is specifically designed to handle hot key problems in DynamoDB by caching frequently read items in memory with microsecond response times. It absorbs the read traffic spike without increasing DynamoDB capacity. Option A (on-demand mode) scales but still has per-partition throughput limits that hot keys can exceed—on-demand doesn't solve the hot partition problem. Option C changes the data model and makes querying more complex. Option D requires application-level cache management and doesn't integrate as seamlessly as DAX.

---

### Question 31

A company needs to implement a notification system that sends messages to different downstream services based on message attributes. Some messages go to email (SES), some to SMS (SNS), some trigger Lambda functions, and some go to SQS queues. The routing logic is complex with multiple conditions per message. Messages must not be lost, and the system must handle 1 million messages per day.

Which architecture provides the MOST flexible and maintainable message routing?

A. Amazon SNS with message filtering policies on each subscription to route messages based on attributes.

B. Amazon EventBridge with rules that match on event patterns and route to different targets (SES, SNS, Lambda, SQS).

C. Amazon SQS with a Lambda function that reads messages and routes them to the appropriate service based on message content.

D. Amazon Kinesis Data Streams with a Lambda consumer that implements the routing logic.

**Correct Answer: B**

**Explanation:** Amazon EventBridge supports complex event pattern matching with multiple conditions, content-based filtering, and native integration with many AWS services including SES, SNS, Lambda, and SQS. Rules are declarative and easy to maintain. Option A (SNS filtering) supports simpler attribute matching but has limitations on complex conditional logic. Option C requires custom routing code in Lambda that must be maintained. Option D is designed for stream processing, not message routing, and requires custom code.

---

### Question 32

A company runs a legacy application that requires a POSIX-compliant shared file system accessible from multiple EC2 instances across two Availability Zones. The file system stores 50 TB of data with a 70/30 read/write ratio. Peak throughput requirements are 3 GB/s for reads. The data includes both frequently accessed recent files and infrequently accessed archive files older than 90 days.

Which storage solution is MOST cost-effective while meeting performance requirements?

A. Amazon EFS with Bursting Throughput mode and Standard storage class for all files.

B. Amazon EFS with Provisioned Throughput mode (3 GB/s) and lifecycle management to transition files older than 90 days to EFS Infrequent Access.

C. Amazon FSx for Lustre linked to an S3 bucket for archive data.

D. A clustered NFS server on EC2 instances using EBS io2 volumes with replication across AZs.

**Correct Answer: B**

**Explanation:** EFS with Provisioned Throughput ensures the 3 GB/s read requirement is met consistently. Lifecycle management automatically moves files older than 90 days to EFS IA storage class, reducing storage costs for archive data. EFS natively supports multi-AZ access and POSIX compliance. Option A's Bursting Throughput may not sustain 3 GB/s consistently at 50 TB. Option C (FSx for Lustre) is POSIX-compliant but is designed for HPC/ML workloads and doesn't have native lifecycle tiering like EFS. Option D adds significant operational overhead with self-managed NFS.

---

### Question 33

A company wants to implement a blue-green deployment strategy for their application running on Amazon ECS with Fargate behind an Application Load Balancer. The deployment should automatically roll back if the new version's error rate exceeds 5% during the first 10 minutes. The solution must minimize deployment time and manual intervention.

Which implementation is MOST appropriate?

A. Use AWS CodeDeploy with an ECS blue-green deployment configuration. Define a CloudWatch alarm on the ALB's HTTPCode_Target_5XX_Count metric. Configure the deployment group with automatic rollback on alarm.

B. Create two separate ECS services (blue and green). Manually update the ALB listener rules to point to the new target group. Monitor CloudWatch metrics and manually switch back if errors exceed 5%.

C. Use ECS rolling updates with a minimum healthy percent of 50%. Monitor the deployment with CloudWatch dashboards.

D. Deploy the new version as a canary using Route 53 weighted routing (10% to new, 90% to old). Gradually increase traffic if no errors.

**Correct Answer: A**

**Explanation:** AWS CodeDeploy natively supports ECS blue-green deployments with ALB. It can automatically shift traffic between target groups and integrates with CloudWatch alarms for automatic rollback—meeting the requirement for automatic rollback when the error rate exceeds 5% within 10 minutes. Option B is manual and prone to human error. Option C (rolling update) doesn't provide instant rollback—partially updated tasks can't be easily reverted. Option D uses Route 53 which has DNS caching issues and doesn't integrate with ECS deployment lifecycle.

---

### Question 34

A company processes sensitive financial data using a Lambda function that calls an external API using an API key. The API key must be rotated every 90 days. The Lambda function is deployed across 3 environments (dev, staging, prod) with different API keys. The operations team wants automated key rotation with zero downtime during rotation.

Which solution provides the MOST secure and automated key management?

A. Store the API keys in AWS Systems Manager Parameter Store as SecureString parameters. Use a Lambda function triggered by EventBridge every 90 days to rotate the keys.

B. Store the API keys in AWS Secrets Manager with automatic rotation enabled using a custom rotation Lambda function that calls the external API's key rotation endpoint.

C. Store the API keys as Lambda environment variables encrypted with KMS. Use a CI/CD pipeline to update the environment variables every 90 days.

D. Store the API keys in an S3 bucket encrypted with SSE-KMS. Use a scheduled Lambda function to read and rotate the keys.

**Correct Answer: B**

**Explanation:** AWS Secrets Manager provides native automatic rotation with configurable rotation intervals. A custom rotation Lambda can call the external API to generate a new key, update the secret, and ensure zero downtime using the staging label mechanism (AWSCURRENT/AWSPENDING). Option A requires building custom rotation orchestration since Parameter Store doesn't have built-in rotation. Option C requires pipeline execution for rotation and causes brief downtime during deployment. Option D is insecure for key storage and adds operational complexity.

---

### Question 35

A company operates a SaaS platform where each tenant's data must be encrypted with a unique encryption key. Tenants must be able to control their own key lifecycle (enable, disable, schedule deletion). The company manages 2,000 tenants and expects growth to 10,000. The encryption keys must be managed within AWS, and the solution must scale with minimal operational overhead.

Which approach is MOST scalable and meets tenant key management requirements?

A. Create a customer-managed KMS key for each tenant in the company's AWS account. Grant each tenant's IAM role key management permissions via key policies.

B. Have each tenant create their own AWS account and KMS key. Use cross-account grants to allow the SaaS platform to use the tenant's key for encryption.

C. Use a single KMS key with different encryption contexts per tenant. Manage access through IAM policy conditions on the encryption context.

D. Use AWS CloudHSM to create and manage individual keys for each tenant in a dedicated HSM cluster.

**Correct Answer: A**

**Explanation:** Creating per-tenant KMS keys in the company's account scales well (KMS supports thousands of keys per account with limit increases) and KMS key policies can grant tenants fine-grained key management permissions (enable/disable/schedule deletion) via their IAM roles. Option B requires every tenant to have their own AWS account, which is impractical for 10,000 tenants. Option C uses a single key which doesn't allow tenants to independently manage (enable/disable) their "key." Option D (CloudHSM) requires managing HSM clusters with significant operational overhead and cost.

---

### Question 36

A company has a legacy monolithic application running on a single EC2 instance that processes batch jobs. The application reads input files from a local directory, processes them, and writes output files. The processing is CPU-intensive and takes 2-4 hours per file. Currently, a backlog of 1,000 files builds up during peak periods. The company wants to parallelize processing while making minimal changes to the application.

Which approach enables parallel processing with the LEAST application code changes?

A. Containerize the application and run it on ECS Fargate. Use SQS to distribute files. Scale the number of tasks based on queue depth.

B. Refactor the application into Lambda functions that process files in parallel. Use S3 event notifications for triggering.

C. Store input files in S3. Use S3 Batch Operations with a Lambda function that launches EC2 instances to process each file.

D. Create an AMI from the current EC2 instance. Use an Auto Scaling group with SQS-based scaling. Store files in S3 and use a startup script to pull and process files from S3 based on SQS messages.

**Correct Answer: D**

**Explanation:** Creating an AMI preserves the existing application without code changes. SQS distributes work across auto-scaled instances, and a simple startup/wrapper script pulls files from S3 based on SQS messages. This requires only a script addition, not application modification. Option A requires containerization which involves application changes. Option B requires refactoring a 2-4 hour process into Lambda (15-min limit). Option C uses EC2 instances but S3 Batch Operations with Lambda adds unnecessary complexity for launching instances.

---

### Question 37

A company operates a global application with users in North America, Europe, and Asia-Pacific. The application uses a REST API backed by Amazon Aurora MySQL. Users in remote Regions experience high latency (>500ms) for read operations. The application has a 90% read, 10% write workload, and writes must go to a single primary Region (us-east-1).

Which architecture REDUCES read latency for all Regions with the LEAST operational complexity?

A. Deploy Aurora Global Database with read replicas in eu-west-1 and ap-southeast-1. Use Route 53 latency-based routing to direct reads to the nearest Aurora endpoint.

B. Deploy Amazon ElastiCache for Redis clusters in each Region as a read-through cache. Cache database query results with a 5-minute TTL.

C. Deploy separate Aurora instances in each Region with bi-directional replication using AWS DMS.

D. Use Amazon API Gateway edge-optimized endpoints to cache API responses at CloudFront edge locations.

**Correct Answer: A**

**Explanation:** Aurora Global Database provides up to 5 read-only secondary Regions with typically less than 1 second of replication lag. Route 53 latency-based routing directs users to the nearest Aurora read endpoint, dramatically reducing read latency. This is a managed solution with minimal operational overhead. Option B requires managing cache invalidation and increases application complexity. Option C creates data consistency challenges with bidirectional replication. Option D caches at the edge but doesn't work well for dynamic/personalized data queries.

---

### Question 38

A company is designing an event-driven architecture for an order processing system. When a new order is placed, the system must: (1) process payment, (2) update inventory, (3) send confirmation email, and (4) update analytics. Steps 1 and 2 must complete before step 3. Step 4 can happen independently. If payment fails, inventory must not be updated and the order should be marked as failed.

Which architecture BEST implements this workflow?

A. Use Amazon SNS to publish the order event. Subscribe Lambda functions for each step. Handle ordering through application logic in each function.

B. Use AWS Step Functions to orchestrate steps 1-3 in sequence (with a Parallel state for 1 and 2, then 3 after both succeed). Use an EventBridge event from the order to trigger step 4 independently.

C. Use Amazon SQS FIFO queues to chain the steps sequentially—each step's Lambda puts a message in the next queue.

D. Use Amazon EventBridge Pipes with an SQS source and Step Functions enrichment.

**Correct Answer: B**

**Explanation:** Step Functions provides orchestration with Parallel states (payment and inventory simultaneously), conditional logic (fail path if payment fails), and sequential flow (email after both succeed). EventBridge handles step 4 independently through event-driven invocation. This cleanly separates the transactional workflow from the independent analytics update. Option A with SNS has no built-in ordering or error handling between steps. Option C chains sequentially which doesn't parallelize payment and inventory, and error handling across queues is complex. Option D is more suited for simple event processing pipelines, not complex workflows with branching logic.

---

### Question 39

A company is deploying a new VPC and needs to provide instances in private subnets with access to Amazon S3 and DynamoDB without using a NAT gateway. The company also needs to ensure that S3 access is restricted to a specific bucket and DynamoDB access is limited to specific tables. All API calls must stay within the AWS network.

Which solution meets these requirements?

A. Create a gateway VPC endpoint for S3 and a gateway VPC endpoint for DynamoDB. Apply endpoint policies that restrict access to the specific bucket and tables. Update route tables to include the endpoint routes.

B. Create interface VPC endpoints for S3 and DynamoDB with security groups. Configure endpoint policies for resource restriction.

C. Create a NAT gateway in a public subnet and use S3 bucket policies and DynamoDB resource policies to restrict access.

D. Configure VPC endpoint services using AWS PrivateLink for S3 and DynamoDB.

**Correct Answer: A**

**Explanation:** Gateway VPC endpoints for S3 and DynamoDB are free, don't require NAT, and keep traffic within the AWS network. Endpoint policies restrict which S3 buckets and DynamoDB tables can be accessed through the endpoint. Route table entries direct traffic to the endpoint. Option B uses interface endpoints which incur per-hour charges—gateway endpoints are available and free for S3 and DynamoDB. Option C uses a NAT gateway, which the question specifically wants to avoid. Option D is incorrect because PrivateLink is for creating your own endpoint services, not consuming AWS services.

---

### Question 40

A company needs to securely connect 50 remote branch offices to their AWS VPCs. Each branch has an internet connection but no dedicated WAN links. The company wants centralized management of the VPN connections and the ability to route traffic between branches through AWS.

Which solution provides the MOST scalable and manageable architecture?

A. Create 50 individual Site-to-Site VPN connections to a virtual private gateway attached to the VPC.

B. Deploy AWS Transit Gateway with a Site-to-Site VPN attachment for each branch office. Enable route propagation for branch-to-branch communication.

C. Implement AWS Client VPN for each branch office to connect to the VPC.

D. Set up AWS CloudWAN with IPsec VPN connections from each branch office.

**Correct Answer: B**

**Explanation:** AWS Transit Gateway supports up to 5,000 VPN connections and provides centralized routing, making it ideal for 50+ branch offices. VPN attachments to Transit Gateway enable hub-and-spoke topology where branches can communicate through the transit gateway. Option A is limited (10 VPN connections per VGW) and doesn't support branch-to-branch routing through AWS. Option C is designed for individual user VPN access, not site-to-site connectivity. Option D is more complex than needed for this use case—CloudWAN is for multi-Region, multi-provider networks.

---

### Question 41

A company is designing a serverless API that must handle both synchronous requests (GET operations completing in <1 second) and long-running asynchronous operations (POST operations that take 5-10 minutes to complete). The POST operations perform complex data transformations. Clients need to check the status of async operations.

Which architecture pattern is MOST appropriate?

A. API Gateway → Lambda for both GET (synchronous) and POST (asynchronous via Lambda async invocation). Store the job status in DynamoDB. Provide a GET /status/{jobId} endpoint.

B. API Gateway → Lambda for GET operations. API Gateway → Step Functions Express Workflow for POST operations. Return the execution ARN as a job ID.

C. API Gateway → Lambda for GET operations. API Gateway → Step Functions Standard Workflow (StartExecution via service integration) for POST operations. Store job status in DynamoDB. Provide a GET /status/{jobId} endpoint.

D. API Gateway → Lambda for all operations. For POST, use Lambda reserved concurrency to handle long-running operations.

**Correct Answer: C**

**Explanation:** API Gateway can directly integrate with Step Functions (StartExecution) to kick off a Standard Workflow (up to 1 year duration) for long-running operations. The workflow manages the data transformation steps and updates DynamoDB with status. A separate GET endpoint queries DynamoDB for status. Option A uses Lambda async which has a 15-minute limit and doesn't provide built-in orchestration. Option B uses Express Workflows which have a 5-minute limit. Option D can't support 5-10 minute operations within Lambda's 15-minute limit and doesn't provide status tracking.

---

### Question 42

A company needs to implement mutual TLS (mTLS) authentication for their API Gateway REST API. Only clients presenting valid certificates signed by the company's private Certificate Authority should be able to access the API. The CA is managed using AWS Private Certificate Authority.

Which configuration implements mTLS on API Gateway?

A. Create a custom domain name on API Gateway with mutual TLS enabled. Upload the CA certificate bundle as the truststore in an S3 bucket. Configure the custom domain to reference the truststore.

B. Configure an API Gateway Lambda authorizer that validates the client certificate against the private CA.

C. Enable client certificate authentication on the API Gateway stage and distribute client certificates generated by API Gateway.

D. Deploy a Network Load Balancer in front of API Gateway with TLS passthrough and validate certificates on the NLB.

**Correct Answer: A**

**Explanation:** API Gateway REST APIs support mutual TLS on custom domain names. You upload the CA's root certificate bundle as a truststore to S3, and API Gateway validates client certificates against this truststore during the TLS handshake. This is the native, supported mTLS configuration. Option B adds latency and complexity by validating in a Lambda. Option C uses API Gateway-generated certificates for backend validation, not client-to-API mTLS. Option D is unnecessary because API Gateway natively supports mTLS.

---

### Question 43

A company runs a critical application on EC2 instances behind an Application Load Balancer. The application has experienced two outages in the past month due to failed deployments. The team currently deploys by replacing instances manually. They need an automated deployment strategy that allows instant rollback and validates application health before sending production traffic.

Which deployment strategy BEST meets these requirements?

A. Implement a rolling deployment using an Auto Scaling group with a minimum healthy percentage of 50%. Use ALB health checks to validate instance health.

B. Implement blue-green deployment using two Auto Scaling groups. Deploy the new version to the green group, validate with a test listener on the ALB, then switch the production listener to the green target group.

C. Implement canary deployment using Route 53 weighted routing to send 10% of traffic to the new version for 30 minutes before full cutover.

D. Implement in-place deployment using AWS CodeDeploy with AllAtOnce configuration for fastest deployment.

**Correct Answer: B**

**Explanation:** Blue-green deployment with a test listener allows validating the new version completely before it receives production traffic. Switching the ALB listener provides instant rollback (switch back to blue). This approach ensures zero-downtime deployment with production-quality validation. Option A (rolling) doesn't provide instant rollback—partially updated instances can't easily revert. Option C (canary via Route 53) has DNS caching issues and slower rollback. Option D (AllAtOnce) replaces all instances simultaneously, maximizing risk.

---

### Question 44

A company's application generates 500 GB of log data per day across 100 EC2 instances. The operations team needs to search logs in near real-time for troubleshooting, retain logs for 90 days with search capability, and archive logs for 7 years for compliance. The current solution using Amazon OpenSearch Service is costing $15,000/month.

Which approach REDUCES costs while meeting all requirements?

A. Use CloudWatch Logs with a 90-day retention period. Set up a subscription filter to stream logs to S3 via Kinesis Data Firehose for 7-year archival in S3 Glacier.

B. Replace OpenSearch with a smaller OpenSearch Serverless collection for 90-day search. Archive to S3 Glacier after 90 days with lifecycle policies.

C. Send logs directly to S3. Use Amazon Athena for near real-time search. Use S3 lifecycle to transition to Glacier after 90 days.

D. Continue using OpenSearch but switch to UltraWarm storage for data older than 7 days and cold storage for data older than 30 days. Archive to S3 after 90 days.

**Correct Answer: D**

**Explanation:** OpenSearch UltraWarm and cold storage tiers are significantly cheaper than hot storage (up to 90% savings). Most of the 90-day searchable data can reside in UltraWarm (7-30 days) and cold storage (30-90 days), reducing the expensive hot tier to only 7 days of data. S3 handles the 7-year archive. Option A (CloudWatch Logs) at 500 GB/day would be extremely expensive ($0.50/GB ingestion = ~$7,500/month plus storage). Option B (OpenSearch Serverless) can be costly for high-volume log data. Option C with Athena doesn't provide near real-time search capability—it has query latency of seconds to minutes.

---

### Question 45

A company runs an Auto Scaling group of EC2 instances processing messages from an SQS queue. During a recent peak, the Auto Scaling group scaled out but new instances took 8 minutes to be ready (AMI boot time plus application initialization). By the time instances were ready, the peak had passed and messages had aged out. The company needs to reduce the time from scaling decision to processing capacity.

Which combination of changes MOST reduces scaling reaction time? (Choose TWO.)

A. Implement predictive scaling based on historical patterns to pre-scale before anticipated peaks.

B. Use warm pools in the Auto Scaling group with pre-initialized instances in a Stopped state.

C. Switch from SQS standard queue to SQS FIFO queue for better ordering.

D. Increase the SQS message retention period from 4 days to 14 days.

E. Replace SQS with Amazon Kinesis Data Streams for faster message processing.

**Correct Answer: A, B**

**Explanation:** Predictive scaling (A) uses ML to analyze historical patterns and pre-provisions capacity before anticipated peaks, eliminating the reactive scaling delay. Warm pools (B) maintain pre-initialized instances in a Stopped state that can start in seconds rather than the 8-minute full initialization, dramatically reducing time-to-capacity. Option C (FIFO) doesn't address scaling speed. Option D prevents message loss from aging but doesn't reduce scaling time. Option E (Kinesis) doesn't inherently make consumers scale faster.

---

### Question 46

A company runs a disaster recovery environment in a secondary Region using a pilot light strategy for their primary Aurora MySQL database. The current RTO is 4 hours and RPO is 1 hour. The business now requires reducing the RTO to 15 minutes and RPO to 1 minute. The DR solution must automatically detect failure and initiate failover.

Which changes achieve the new RTO and RPO targets?

A. Upgrade from pilot light to warm standby by maintaining a full application stack in the secondary Region. Use Aurora Global Database for cross-Region replication and Route 53 health checks with failover routing to automatically switch traffic.

B. Switch to multi-site active-active with Aurora Global Database in both Regions. Use Route 53 latency-based routing.

C. Implement cross-Region read replicas with Amazon RDS for MySQL. Use a Lambda function triggered by CloudWatch alarms to promote the replica.

D. Use AWS Elastic Disaster Recovery (DRS) for continuous replication to the secondary Region with automated failover.

**Correct Answer: A**

**Explanation:** Aurora Global Database provides sub-second replication (meeting the 1-minute RPO). A warm standby with a full but scaled-down application stack in the secondary Region can be scaled up and serve traffic within minutes (meeting 15-minute RTO). Route 53 health checks with failover routing automate the DNS switchover. Option B (multi-site) provides better RTO/RPO but is significantly more expensive than required. Option C (RDS cross-Region replicas) has higher replication lag and manual promotion adds time. Option D (DRS) is designed for EC2/server replication, not managed database DR.

---

### Question 47

A company's application uses an ALB with sticky sessions. Users report intermittent session loss when instances are terminated during scale-in events. The Auto Scaling group is configured with the default termination policy. Session data is stored in local memory on each EC2 instance.

Which combination of changes provides the MOST reliable session management? (Choose TWO.)

A. Externalize session storage to Amazon ElastiCache for Redis instead of local instance memory.

B. Configure the Auto Scaling group to use scale-in protection for instances with active sessions.

C. Enable connection draining on the ALB with a timeout matching the session duration.

D. Configure the Auto Scaling group termination policy to terminate the oldest instance first.

E. Disable ALB sticky sessions after externalizing session storage.

**Correct Answer: A, E**

**Explanation:** Externalizing sessions to ElastiCache (A) decouples session data from specific instances, so session data survives instance termination. Once sessions are externalized, sticky sessions are no longer needed (E), and any instance can serve any user, improving load distribution and eliminating session loss entirely. Option B (scale-in protection) prevents scaling in, which defeats the purpose of auto scaling. Option C (connection draining) helps in-flight requests but doesn't preserve sessions on terminated instances. Option D (termination policy) doesn't prevent session loss regardless of which instance is terminated.

---

### Question 48

A company has a CI/CD pipeline that builds and deploys a containerized application to ECS Fargate. Builds take 15 minutes due to pulling base images from Docker Hub and downloading dependencies from the internet. The company wants to reduce build times and eliminate external dependencies during builds for reliability.

Which measures MOST effectively reduce build times and remove external dependencies? (Choose TWO.)

A. Use Amazon ECR as a pull-through cache for Docker Hub base images. Reference the ECR cache in Dockerfiles.

B. Implement Docker multi-stage builds to reduce the final image size.

C. Set up a CodeArtifact repository to cache and proxy external package dependencies (npm, pip, Maven). Configure build environments to use CodeArtifact as the package source.

D. Increase the CodeBuild compute type to use a larger instance.

E. Switch from Fargate to EC2 launch type for faster container startup.

**Correct Answer: A, C**

**Explanation:** ECR pull-through cache (A) caches Docker Hub images locally in ECR, eliminating external pulls and reducing build time. CodeArtifact (C) caches package dependencies locally, removing internet dependency for npm/pip/Maven downloads. Both address the two main sources of external dependency and download time. Option B reduces image size but doesn't significantly reduce build time or remove external dependencies. Option D may speed up builds slightly but doesn't address the external dependency problem. Option E affects deployment, not build time.

---

### Question 49

A company monitors their application using CloudWatch. They have 50 custom metrics and 20 alarms. The monitoring team wants to implement composite alarms that combine multiple alarm states to reduce alert noise. They need a single alarm that triggers only when BOTH high CPU usage AND high memory usage occur simultaneously across their fleet.

Which approach correctly implements this?

A. Create individual CloudWatch alarms for CPU and memory. Create a composite alarm using an AND rule that requires both alarms to be in ALARM state before triggering notifications.

B. Create a CloudWatch metric math expression that multiplies CPU and memory metrics. Set a single alarm on the resulting metric.

C. Use CloudWatch anomaly detection on both metrics. Configure SNS notifications only when both anomalies are detected.

D. Create a Lambda function subscribed to both alarm state changes via SNS. The function checks if both alarms are active before sending a notification.

**Correct Answer: A**

**Explanation:** CloudWatch composite alarms support alarm rule expressions using AND, OR, and NOT operators. An AND rule triggers only when all specified child alarms are in ALARM state, exactly matching the requirement for both high CPU and high memory simultaneously. Option B (metric math) is a workaround that doesn't properly capture the independent alarm states. Option C (anomaly detection) detects deviations from normal patterns, not threshold-based conditions, and has no built-in AND logic. Option D requires custom code for what CloudWatch provides natively.

---

### Question 50

A company runs a three-tier application and wants to implement automated infrastructure testing as part of their CI/CD pipeline. They need to verify that new CloudFormation template changes: (1) pass syntax validation, (2) don't introduce security misconfigurations, and (3) successfully deploy to a test environment before production.

Which pipeline design provides comprehensive infrastructure testing?

A. CodeCommit → CodeBuild (cfn-lint + cfn_nag for static analysis) → CodeBuild (deploy to test environment using CloudFormation) → Manual approval → CodeBuild (deploy to production).

B. CodeCommit → CloudFormation validate-template → Manual approval → Deploy to production.

C. CodeCommit → CodeBuild (deploy to test with CloudFormation Change Sets preview) → Manual approval → Execute Change Set in production.

D. CodeCommit → AWS Config rules to evaluate template compliance → Deploy to production.

**Correct Answer: A**

**Explanation:** This pipeline provides three layers of testing: cfn-lint validates syntax and best practices, cfn_nag performs security analysis (detecting overly permissive IAM policies, unencrypted resources, etc.), and a full test deployment verifies actual deployment success. Manual approval gates production deployment. Option B only validates syntax, missing security checks and test deployment. Option C skips static analysis (security checks) and uses Change Sets which don't actually test deployment. Option D evaluates running resources, not templates, and doesn't test before production.

---

### Question 51

A company has a global application running in us-east-1 with a read replica infrastructure in eu-west-1 for European users. The operations team notices that during US business hours, database CPU utilization reaches 90% in us-east-1, while the EU read replica sits at 20%. They need to reduce the primary database load without changing the application's write behavior.

Which approach is MOST effective at reducing primary database CPU utilization?

A. Vertically scale the primary RDS instance to a larger instance type.

B. Implement read/write splitting in the application. Route all read queries from US-based application servers to a new read replica in us-east-1, while the primary handles only writes.

C. Implement an ElastiCache layer for frequently executed read queries. Use cache-aside pattern with appropriate TTLs.

D. Convert the single primary instance to an Aurora cluster with multiple reader instances. Use the Aurora reader endpoint for read queries.

**Correct Answer: B**

**Explanation:** Since 90% CPU on the primary suggests read queries are dominating, adding a read replica in us-east-1 and routing reads to it directly offloads the primary. This is the simplest change that addresses the root cause—read queries consuming primary CPU. Option A (vertical scaling) is expensive and doesn't address the root cause. Option C (caching) helps for repeated queries but adds complexity and doesn't help with unique queries. Option D (Aurora migration) is a significant migration effort when a read replica in the same Region solves the problem.

---

### Question 52

A DevOps team manages 200 EC2 instances across 10 AWS accounts. They need to ensure all instances have the latest security patches installed within 48 hours of patch release. The team wants centralized visibility into patch compliance across all accounts and automated patching during approved maintenance windows.

Which solution provides centralized patch management with the LEAST operational overhead?

A. Use AWS Systems Manager Patch Manager with a delegated administrator account. Define patch baselines, create maintenance windows, and use Patch Manager's compliance dashboard for cross-account visibility.

B. Deploy a WSUS server for Windows and a Satellite server for Linux in a shared services VPC. Manually configure each instance to use these patch servers.

C. Create a Lambda function that runs in each account on a schedule, executing patch commands via SSM Run Command on all instances.

D. Use AWS Config rules to detect non-compliant instances and send notifications to the operations team for manual patching.

**Correct Answer: A**

**Explanation:** Systems Manager Patch Manager with a delegated administrator provides centralized multi-account patch management. Patch baselines define which patches to apply, maintenance windows automate the timing, and the compliance dashboard shows patch status across all accounts. Option B requires managing separate patch infrastructure with significant overhead. Option C requires custom Lambda functions in each account and doesn't provide built-in compliance tracking. Option D only detects non-compliance without automating remediation.

---

### Question 53

A company runs a large-scale data pipeline that processes daily batch jobs. The pipeline consists of 50 AWS Glue ETL jobs with complex dependencies (some jobs must complete before others start). Currently, the pipeline is orchestrated using cron-scheduled Lambda functions, which has become difficult to maintain, debug, and monitor. The team needs better visibility into job failures and easier dependency management.

Which orchestration solution is MOST appropriate?

A. AWS Step Functions with a state machine that defines all job dependencies using Parallel and Choice states. Use the Step Functions console for visual monitoring.

B. Amazon Managed Workflows for Apache Airflow (MWAA) with a DAG defining all 50 jobs and their dependencies. Use the Airflow UI for monitoring and debugging.

C. Amazon EventBridge Scheduler to trigger each Glue job at specific times. Use EventBridge rules to chain dependent jobs based on Glue job state change events.

D. AWS Glue Workflows to define the job dependency graph with triggers between jobs.

**Correct Answer: B**

**Explanation:** MWAA (Apache Airflow) is purpose-built for complex DAG-based workflow orchestration with many jobs and dependencies. The Airflow UI provides rich monitoring, logging, and debugging capabilities including dependency visualization, retry management, and historical run analysis. Option A (Step Functions) works but becomes unwieldy with 50+ jobs and complex dependency graphs, and has a 25,000 event limit per execution. Option C (EventBridge) doesn't provide a unified dependency view or easy debugging. Option D (Glue Workflows) supports simpler dependency chains but lacks the advanced orchestration, monitoring, and retry capabilities of Airflow.

---

### Question 54

A company is migrating a 50 TB Oracle database to AWS. The database supports a critical OLTP application that cannot tolerate more than 1 hour of downtime during the migration. The database uses Oracle-specific features including materialized views, PL/SQL packages, and Oracle Spatial. The company wants to minimize licensing costs on AWS.

What is the BEST migration approach?

A. Use AWS DMS with full load and CDC (Change Data Capture) to migrate to Amazon Aurora PostgreSQL. Use AWS SCT to convert the schema and PL/SQL code. Cut over during a maintenance window once replication is caught up.

B. Use Oracle Data Pump to export the database and import it into Amazon RDS for Oracle on a License Included basis during a scheduled downtime window.

C. Use AWS DMS with full load and CDC to migrate to Amazon RDS for Oracle using the Bring Your Own License (BYOL) model. Use native Oracle tools for schema migration.

D. Migrate to Amazon Aurora MySQL using AWS DMS with the Oracle-to-MySQL conversion. Use AWS SCT for schema conversion.

**Correct Answer: A**

**Explanation:** DMS with CDC enables near-zero-downtime migration by replicating changes continuously until cutover. Aurora PostgreSQL eliminates Oracle licensing costs (minimizing licensing costs). SCT converts Oracle schemas, PL/SQL, and spatial features to PostgreSQL equivalents. The cutover window is minimal since CDC keeps the target synchronized. Option B requires extended downtime for a 50 TB data pump export/import. Option C keeps Oracle licensing costs. Option D uses MySQL which has less Oracle feature parity than PostgreSQL (especially for spatial and complex PL/SQL).

---

### Question 55

A company has 200 Windows servers running on-premises that need to be migrated to AWS. The servers have various configurations and the company doesn't have complete documentation of all application dependencies. They need to plan the migration by understanding which servers communicate with each other and grouping them into move groups.

Which approach provides the MOST comprehensive discovery and dependency mapping?

A. Install AWS Application Discovery Agent on all servers. Use the data collected to visualize dependencies in AWS Migration Hub. Group servers into applications based on network communication patterns.

B. Analyze existing network firewall logs to determine communication patterns between servers.

C. Conduct manual interviews with application owners to document server dependencies and create migration move groups.

D. Deploy AWS Application Discovery Service Agentless Collector to scan the VMware environment and collect configuration data.

**Correct Answer: A**

**Explanation:** The Application Discovery Agent installed on each server collects detailed information including network connections, running processes, and system performance data. This enables accurate dependency mapping in Migration Hub, showing which servers communicate and should be migrated together. Option B (firewall logs) captures network flows but misses application-level dependencies and localhost communications. Option C (manual interviews) is time-consuming and incomplete—the company explicitly lacks documentation. Option D (Agentless Collector) provides VM configuration data but less detailed network dependency information compared to the agent.

---

### Question 56

A company is migrating a legacy three-tier application from on-premises to AWS. The application consists of: (1) an IIS web tier, (2) a .NET application tier using Windows Communication Foundation (WCF) services, and (3) a Microsoft SQL Server database. The company wants a lift-and-shift migration with minimal changes for the initial phase, followed by modernization later.

Which migration approach is MOST appropriate for the initial phase?

A. Use AWS Application Migration Service (MGN) to replicate the web and application servers. Use AWS DMS to migrate the SQL Server database to Amazon RDS for SQL Server.

B. Refactor the application to run on Linux containers in ECS Fargate. Migrate the database to Aurora PostgreSQL using DMS.

C. Use VM Import/Export to convert the VMware VMs to AMIs. Launch the AMIs as EC2 instances. Use native SQL Server backup/restore to migrate the database to RDS for SQL Server.

D. Rewrite the web tier using Amazon API Gateway and Lambda. Keep the WCF services on EC2. Migrate to Aurora MySQL.

**Correct Answer: A**

**Explanation:** AWS Application Migration Service (MGN) provides automated lift-and-shift by continuously replicating servers to AWS with minimal changes—ideal for the initial phase. DMS migrates the SQL Server database to RDS for SQL Server, maintaining compatibility. This approach requires the least changes. Option B involves significant refactoring (containerization + database engine change) which contradicts the lift-and-shift requirement. Option C works but VM Import/Export is slower and less automated than MGN. Option D involves rewriting components, not lift-and-shift.

---

### Question 57

A company needs to migrate 2 PB of archival data stored on tape libraries to Amazon S3 Glacier Deep Archive. The data center has a 1 Gbps internet connection. The migration must complete within 3 months. The company cannot install additional network infrastructure.

Which migration method can meet the timeline?

A. Transfer data over the internet to S3 Glacier Deep Archive using multipart upload with AWS CLI.

B. Order multiple AWS Snowball Edge Storage Optimized devices. Copy data to the devices and ship them back to AWS.

C. Set up an AWS DataSync agent on-premises and transfer data over the internet to S3 Glacier Deep Archive.

D. Order an AWS Snowmobile for the 2 PB transfer.

**Correct Answer: B**

**Explanation:** At 1 Gbps, transferring 2 PB over the internet would take approximately 185 days (over 6 months)—exceeding the 3-month deadline. Each Snowball Edge Storage Optimized holds 80 TB. With 25 devices processed in parallel batches, the data can be physically shipped and ingested within the timeframe. Option A would take over 6 months over the 1 Gbps connection. Option C also uses the internet connection and would face the same bandwidth limitation. Option D (Snowmobile) is designed for 10 PB+ transfers and is overkill for 2 PB; procurement and logistics would likely exceed the timeline.

---

### Question 58

A company is migrating a microservices application from an on-premises Kubernetes cluster to Amazon EKS. The application uses Kubernetes ConfigMaps and Secrets, persistent volumes (NFS-backed), and Ingress controllers. The team wants to maintain Kubernetes-native tooling and minimize changes to their deployment manifests.

Which approach ensures the SMOOTHEST migration with the LEAST manifest changes?

A. Deploy EKS with managed node groups. Use Amazon EFS CSI driver for persistent volumes, AWS Secrets Manager CSI driver for secrets, and AWS Load Balancer Controller for ingress.

B. Deploy ECS Fargate and convert all Kubernetes manifests to ECS task definitions. Use EFS for persistent storage.

C. Deploy EKS on Fargate. Use Amazon EBS CSI driver for persistent volumes and ALB for ingress.

D. Deploy EKS with self-managed node groups running the same OS and configuration as on-premises nodes. Use Amazon FSx for Lustre for persistent volumes.

**Correct Answer: A**

**Explanation:** EKS with managed node groups maintains Kubernetes-native operations. The EFS CSI driver maps to the existing NFS-backed PVs with minimal manifest changes (just change the StorageClass). The Secrets Manager CSI driver keeps the Kubernetes Secrets interface while using AWS-managed secrets. The AWS Load Balancer Controller supports Kubernetes Ingress resources natively. Option B (ECS) requires complete manifest rewriting from Kubernetes to ECS format. Option C uses Fargate which doesn't support all PV types and has limitations. Option D uses FSx for Lustre which is unnecessary for general NFS workloads and adds complexity.

---

### Question 59

A company is migrating their data warehouse from on-premises Teradata to AWS. The Teradata instance contains 100 TB of data and supports 500 concurrent BI users running complex analytical queries. The company uses ANSI SQL extensively and needs to maintain query compatibility. They also need to support semi-structured JSON data ingestion from new streaming sources.

Which target architecture is MOST suitable?

A. Amazon Redshift with RA3 nodes. Use AWS SCT to convert Teradata SQL. Use Redshift Spectrum for querying data in S3. Configure concurrency scaling for burst capacity.

B. Amazon Aurora PostgreSQL with read replicas for BI query distribution.

C. Amazon Athena over data stored in S3 in Parquet format. Use AWS Glue for ETL.

D. Amazon EMR with Presto for interactive SQL queries over data stored in S3.

**Correct Answer: A**

**Explanation:** Amazon Redshift is purpose-built for data warehousing with support for complex SQL analytics. RA3 nodes scale compute and storage independently, SCT converts Teradata-specific SQL, Redshift Spectrum handles semi-structured data in S3, and concurrency scaling handles burst from 500 BI users. Option B (Aurora) is OLTP-optimized, not suited for 100 TB analytical workloads. Option C (Athena) isn't designed for 500 concurrent users running complex queries—performance and cost would be issues. Option D (EMR + Presto) requires significant operational management and lacks Teradata SQL conversion tools.

---

### Question 60

A company has a legacy application running on mainframes that process nightly batch jobs for financial reconciliation. The batch jobs take 6 hours to complete. The company wants to modernize incrementally by moving specific batch jobs to AWS while keeping the mainframe operational during the transition. The new and old systems must exchange data reliably.

Which modernization approach BEST supports incremental migration?

A. Use the Strangler Fig pattern. Expose mainframe batch functions as APIs using AWS Mainframe Modernization. Gradually move batch jobs to AWS Lambda or AWS Batch while routing through an API layer.

B. Perform a complete rewrite of all batch jobs as AWS Step Functions workflows. Deploy everything at once.

C. Set up AWS DataSync to synchronize mainframe files to S3. Run migrated batch jobs on AWS Batch reading from S3. Use DataSync to sync results back.

D. Use AWS Mainframe Modernization Replatforming to convert all COBOL code to Java and run on EC2.

**Correct Answer: A**

**Explanation:** The Strangler Fig pattern enables incremental migration by wrapping mainframe functions behind an API layer, allowing individual batch jobs to be moved to AWS one at a time while maintaining interoperability. AWS Mainframe Modernization provides tools for this integration. Option B (complete rewrite) contradicts the incremental requirement and is high-risk. Option C handles data sync but doesn't address the batch job execution integration. Option D converts everything at once, which isn't incremental.

---

### Question 61

A company needs to migrate 500 databases (mix of MySQL, PostgreSQL, Oracle, and SQL Server) to AWS within 12 months. Each database ranges from 10 GB to 5 TB. The company wants to standardize on Amazon Aurora (PostgreSQL-compatible) where possible and use RDS for databases that require engine compatibility.

Which approach enables efficient large-scale database migration?

A. Use AWS Database Migration Service (DMS) with AWS Schema Conversion Tool (SCT) for heterogeneous migrations. Create a DMS Fleet Advisor assessment to prioritize databases. Use DMS serverless for automatic capacity management across migrations.

B. Use native database export/import tools for each database manually. Schedule migrations over the 12-month period.

C. Use AWS DataSync to transfer database files from on-premises to EBS volumes. Restore databases from files on EC2-hosted database instances.

D. Migrate all databases to Amazon DynamoDB using DMS for a fully managed NoSQL solution.

**Correct Answer: A**

**Explanation:** DMS Fleet Advisor assesses the 500 databases and recommends migration targets, prioritizing the migration plan. SCT handles heterogeneous schema conversion (Oracle/SQL Server to Aurora PostgreSQL). DMS serverless automatically manages replication instance capacity across concurrent migrations, essential for 500 databases. Option B (manual export/import) doesn't scale to 500 databases in 12 months. Option C requires manual database restoration and management. Option D migrates to a NoSQL database, fundamentally changing the data model for relational databases.

---

### Question 62

A healthcare company is migrating their Electronic Health Records (EHR) system to AWS. The EHR uses a complex Oracle database with 20 TB of data, stored procedures, and triggers. Due to regulatory requirements, the application must maintain an on-premises read-only copy of the database for 2 years after migration. The migration must not exceed 4 hours of downtime.

Which migration strategy addresses all requirements?

A. Use AWS DMS with full load and CDC to migrate to Amazon RDS for Oracle. After migration, reverse the DMS replication direction to replicate from RDS back to the on-premises Oracle database.

B. Use Oracle GoldenGate for bidirectional replication between on-premises Oracle and Amazon RDS for Oracle. After cutover, configure one-way replication from RDS to on-premises.

C. Use AWS DMS with full load and CDC to migrate to Amazon RDS for Oracle. Set up a separate DMS task to continuously replicate from RDS for Oracle back to the on-premises Oracle instance for the 2-year requirement.

D. Use AWS Snowball Edge to transfer the initial data load. Then use DMS CDC to catch up. Maintain a VPN connection for ongoing replication back to on-premises.

**Correct Answer: C**

**Explanation:** DMS with full load and CDC minimizes downtime by keeping the target synchronized until cutover. After cutover, a separate DMS task replicates from RDS back to the on-premises Oracle instance, maintaining the required read-only copy for 2 years. Option A's "reverse direction" isn't a standard DMS feature—you need a separate task. Option B (GoldenGate) adds licensing costs and complexity when DMS can handle the requirement. Option D (Snowball) adds unnecessary logistics for a 20 TB database that can transfer over the network in the migration window.

---

### Question 63

A company spends $2 million annually on AWS. Analysis shows: 60% is EC2 compute (mix of production steady-state and variable development workloads), 20% is RDS databases (consistent usage), 10% is data transfer, and 10% is S3 storage. The CFO wants to reduce the total bill by at least 30% without impacting production performance.

Which combination of strategies achieves the target savings? (Choose THREE.)

A. Purchase Compute Savings Plans to cover the steady-state production EC2 usage (approximately 40% of compute). Use Spot Instances for development and testing workloads.

B. Purchase Reserved Instances for RDS databases with a 1-year All Upfront payment term.

C. Migrate all EC2 workloads to Graviton-based instance types for up to 20% price-performance improvement.

D. Implement S3 Intelligent-Tiering for all S3 buckets to automatically optimize storage costs.

E. Use VPC endpoints to reduce NAT gateway data transfer charges.

**Correct Answer: A, B, C**

**Explanation:** Compute Savings Plans (A) save up to 66% on steady-state EC2 usage, and Spot for dev/test saves up to 90%—combined savings of approximately 40-50% on the 60% compute spend (~$480K-$600K). RDS Reserved Instances (B) save up to 40% on the 20% RDS spend (~$160K). Graviton migration (C) saves 20% on remaining compute costs (~$80K+). Total potential savings: $720K-$840K (36-42%). Option D saves on S3 but the 10% S3 spend limits savings to ~$20K. Option E reduces data transfer costs but typical VPC endpoint savings on a 10% data transfer spend are modest.

---

### Question 64

A company runs hundreds of EC2 instances with varying utilization patterns. A cost analysis reveals that 40% of instances have average CPU utilization below 10% over the past 30 days. The company wants to identify and right-size these underutilized instances without causing performance issues for occasional CPU spikes.

Which approach provides the MOST accurate right-sizing recommendations?

A. Use AWS Compute Optimizer which analyzes 14 days of CloudWatch metrics (CPU, memory, network, disk) and provides right-sizing recommendations with projected performance risk.

B. Write a script that checks average CPU utilization over 30 days and downsizes any instance below 10% average to the next smaller instance type.

C. Use AWS Cost Explorer's right-sizing recommendations based on maximum CPU utilization over the past 14 days.

D. Implement a policy to terminate any instance with less than 10% average CPU utilization.

**Correct Answer: A**

**Explanation:** AWS Compute Optimizer uses machine learning to analyze multiple metrics (CPU, memory, network, disk I/O) and provides recommendations with a performance risk rating—accounting for spikes. It recommends specific instance types considering actual workload patterns, not just averages. Option B uses only average CPU which misses spikes and doesn't consider memory/network. Option C (Cost Explorer) provides simpler recommendations based on fewer metrics than Compute Optimizer. Option D would terminate potentially critical instances without considering their purpose.

---

### Question 65

A company has a large development team that frequently creates EC2 instances, RDS databases, and other resources for testing. These resources are often forgotten and left running for weeks. The average monthly waste from abandoned development resources is estimated at $50,000.

Which automated approach is MOST effective at reducing this waste?

A. Require all development resources to be tagged with an expiration date. Deploy a Lambda function triggered by EventBridge Scheduler that terminates resources past their expiration date.

B. Set up AWS Budgets with alerts when the development account exceeds the monthly budget. Send notifications to the development team lead.

C. Implement AWS Service Catalog with pre-approved templates that automatically tag resources and include CloudFormation stack deletion after a configurable TTL.

D. Use AWS Config rules to detect untagged resources and automatically stop them.

**Correct Answer: A**

**Explanation:** A tag-based expiration system with automated enforcement is the most direct solution. Resources are tagged with an expiration date at creation, and a scheduled Lambda function automatically terminates expired resources. This is customizable, enforced, and handles all resource types. Option B only alerts but doesn't take action. Option C works for Service Catalog-provisioned resources but developers often create resources outside of Service Catalog. Option D stops untagged resources but doesn't address tagged resources that are abandoned.

---

### Question 66

A company is evaluating whether to use Amazon RDS Multi-AZ or Amazon Aurora for their production MySQL database. The database requires 99.99% availability, automated failover under 30 seconds, and the ability to handle read-heavy workloads. The current database is 2 TB with 80% read operations.

Which option is MOST cost-effective while meeting all requirements?

A. Amazon RDS MySQL Multi-AZ with a read replica for read scaling.

B. Amazon Aurora MySQL with up to 15 read replicas and automatic failover with Aurora Replicas as failover targets.

C. Amazon RDS MySQL Multi-AZ with Amazon ElastiCache to offload read traffic.

D. Amazon Aurora MySQL Serverless v2 for automatic capacity scaling.

**Correct Answer: B**

**Explanation:** Aurora provides 99.99% availability SLA, automated failover typically under 30 seconds using Aurora Replicas, and up to 15 read replicas for the read-heavy workload. Aurora's storage is also more efficient with 6-way replication. For a 2 TB, read-heavy production database, Aurora is cost-effective compared to the alternatives. Option A has slower failover (60-120 seconds for Multi-AZ) and doesn't meet the 30-second requirement. Option C adds ElastiCache complexity and cost on top of RDS. Option D (Serverless v2) works but costs more than provisioned for consistent production workloads.

---

### Question 67

A media streaming company uses CloudFront to deliver video content stored in S3. Their monthly CloudFront data transfer bill is $100,000 for 500 TB of data transfer. They've noticed that 70% of requests come from the US and Europe, while 30% come from other Regions. The company wants to reduce CloudFront costs without significantly impacting user experience in major markets.

Which combination of strategies reduces costs? (Choose TWO.)

A. Enable CloudFront Price Class 100 (US, Canada, Europe) to reduce per-GB pricing, and serve other Regions directly from S3 via regional endpoints.

B. Implement CloudFront Origin Shield to reduce origin fetches and improve cache hit ratio.

C. Negotiate a CloudFront private pricing agreement (custom pricing) given the high volume usage.

D. Switch from CloudFront to serving content directly from S3 with Transfer Acceleration.

E. Compress all video content using CloudFront automatic compression.

**Correct Answer: B, C**

**Explanation:** CloudFront custom pricing (C) is available for commitments above 10 TB/month and can reduce costs by 20-40% for high-volume users—significant savings on a $100K bill. Origin Shield (B) reduces duplicate origin requests across edge locations, improving cache hit ratio and reducing both origin transfer costs and S3 request costs. Option A restricts edge locations, degrading experience for 30% of users. Option D (S3 Transfer Acceleration) is more expensive than CloudFront for content delivery. Option E doesn't apply to video—video is already compressed and CloudFront compression works on text-based content.

---

### Question 68

A company has an Auto Scaling group running m5.2xlarge instances (8 vCPU, 32 GB RAM) for a web application. CloudWatch metrics show that instances average 30% CPU utilization and 60% memory utilization, indicating the workload is memory-bound. The company wants to optimize instance costs.

Which instance family change provides the BEST cost optimization?

A. Switch to r5.xlarge (4 vCPU, 32 GB RAM) which provides the same memory with fewer CPUs at a lower cost.

B. Switch to c5.2xlarge (8 vCPU, 16 GB RAM) which provides more CPU-optimized performance.

C. Switch to t3.2xlarge (8 vCPU, 32 GB RAM) and use burstable CPU credits for the low CPU workload.

D. Switch to m5.xlarge (4 vCPU, 16 GB RAM) and scale horizontally with more instances.

**Correct Answer: A**

**Explanation:** The workload is memory-bound (60% memory, 30% CPU), so an R5 (memory-optimized) instance provides better price-performance. r5.xlarge offers 32 GB RAM (maintaining the memory) with 4 vCPUs (sufficient for 30% utilization of 8 vCPUs) at a lower cost than m5.2xlarge. Option B (c5) is CPU-optimized and reduces memory to 16 GB, which would cause memory pressure. Option C (t3) has the same cost as m5 for the same specs but introduces burstable CPU variability. Option D cuts memory in half, which would impact the memory-bound workload.

---

### Question 69

A company has separate AWS accounts for each business unit, all under AWS Organizations with consolidated billing. The company wants to implement a chargeback model where each business unit is billed for their actual AWS usage, including their share of Reserved Instance benefits. Shared infrastructure costs (transit gateway, shared VPCs) should be split proportionally.

Which approach provides the MOST accurate chargeback?

A. Use AWS Cost Explorer with filtering by linked account to show each account's costs. Manually distribute shared infrastructure costs in a spreadsheet.

B. Enable AWS Cost and Usage Reports (CUR) with resource-level data. Use Amazon Athena to query CUR data for per-account costs including RI/SP benefit allocation. Build a custom chargeback dashboard that allocates shared costs based on usage metrics.

C. Use AWS Budgets to set per-account budgets matching their expected costs.

D. Tag all resources with a business-unit cost allocation tag. Use Cost Explorer's tag-based filtering for chargeback.

**Correct Answer: B**

**Explanation:** CUR with resource-level data provides the most granular cost data including RI/SP amortization and benefit allocation across accounts. Athena queries enable flexible cost analysis, and custom dashboards can implement proportional allocation of shared infrastructure based on actual usage metrics (data transfer, requests). Option A (Cost Explorer) provides good per-account views but doesn't easily handle proportional shared cost allocation. Option C (Budgets) tracks against targets but doesn't perform chargeback allocation. Option D (tags) helps but doesn't handle shared resources or RI benefit distribution.

---

### Question 70

A startup is launching a new SaaS application and wants to optimize costs from day one. The application workload is unpredictable for the first 6 months. After that, they expect steady growth. They plan to use EC2, RDS, and S3.

Which cost optimization strategy is MOST appropriate for the first 6 months?

A. Purchase 1-year Reserved Instances for EC2 and RDS based on projected usage.

B. Use On-Demand instances for EC2, RDS with on-demand pricing, and S3 Standard. Monitor usage patterns using Cost Explorer and AWS Compute Optimizer before committing to savings plans.

C. Use Spot Instances for all EC2 workloads and Aurora Serverless for the database.

D. Purchase 3-year Savings Plans for maximum discount.

**Correct Answer: B**

**Explanation:** With unpredictable workload in the first 6 months, On-Demand pricing provides flexibility without commitment risk. Monitoring with Cost Explorer and Compute Optimizer establishes usage baselines for making informed commitment decisions after the uncertainty period. Option A (RIs based on projections) risks over-commitment on unproven projections. Option C (Spot for all workloads) isn't suitable for production SaaS where reliability is critical. Option D (3-year Savings Plans) locks in maximum commitment with maximum uncertainty—the worst risk profile.

---

### Question 71

A company processes large volumes of images stored in S3. Currently, images are stored in S3 Standard. Analysis shows that images are accessed frequently for the first 30 days, occasionally from 30-90 days, and rarely after 90 days. However, when accessed after 90 days, retrieval must complete within 12 hours. The total storage is 500 TB and growing.

Which S3 lifecycle configuration minimizes storage costs?

A. S3 Standard → S3 Standard-IA after 30 days → S3 Glacier Flexible Retrieval after 90 days.

B. S3 Intelligent-Tiering for all data.

C. S3 Standard → S3 One Zone-IA after 30 days → S3 Glacier Deep Archive after 90 days.

D. S3 Standard → S3 Standard-IA after 30 days → S3 Glacier Deep Archive after 90 days.

**Correct Answer: A**

**Explanation:** S3 Standard for the first 30 days (frequent access), S3 Standard-IA for 30-90 days (occasional access with retrieval charges), and Glacier Flexible Retrieval after 90 days (rare access with 3-5 hour standard retrieval or 5-12 hour bulk retrieval—meeting the 12-hour requirement). Option B (Intelligent-Tiering) has monthly monitoring fees per object that add up at 500 TB scale and doesn't transition to Glacier automatically. Option C uses One Zone-IA which has lower durability—risky for the only copy. Option D uses Deep Archive which has a 12-hour minimum retrieval time that may not consistently meet the 12-hour requirement (can be up to 48 hours for standard retrieval).

---

### Question 72

A company wants to implement a tagging strategy for cost management across their AWS Organization with 30 accounts. They need to ensure all resources are tagged with mandatory tags (Environment, CostCenter, Owner) at creation time. Non-compliant resources should be prevented from being created.

Which approach provides the MOST reliable enforcement?

A. Use AWS Config rules with auto-remediation to add missing tags to resources after creation.

B. Deploy SCPs that deny resource creation unless required tags are present using the `aws:RequestTag` condition key.

C. Use AWS Tag Policies in Organizations to define mandatory tags and use AWS Config for monitoring compliance.

D. Implement a Lambda function triggered by CloudTrail events that terminates resources missing required tags.

**Correct Answer: B**

**Explanation:** SCPs with `aws:RequestTag` condition keys prevent resource creation at the API level unless the required tags are included in the request. This is a preventive control that works across all accounts in the organization. Option A (Config auto-remediation) is reactive—resources are created first, then tagged, leaving a gap. Option C (Tag Policies) define tag standards but don't prevent non-compliant resource creation—they're for reporting compliance. Option D is reactive and destructive—terminating resources after creation could cause disruptions.

---

### Question 73

A company runs a data analytics platform that uses Amazon Redshift. The cluster is a dc2.8xlarge with 10 nodes. The cluster is heavily used during business hours (8 AM - 6 PM) but nearly idle at night and on weekends. The cluster costs $150,000/year. The CFO wants to reduce costs by at least 40%.

Which approach achieves the cost reduction target?

A. Switch to Redshift Serverless which automatically scales down during idle periods and scales up during business hours. Only pay for compute consumed.

B. Pause the cluster outside business hours using a Lambda function triggered by EventBridge Scheduler. Resume the cluster before business hours.

C. Purchase 1-year All Upfront Reserved Instances for the 10 nodes.

D. Migrate from dc2.8xlarge nodes to ra3.xlplus nodes with managed storage for a smaller compute footprint.

**Correct Answer: A**

**Explanation:** Redshift Serverless eliminates costs during idle periods (nights and weekends—approximately 66% of the time) and automatically scales during business hours. For a workload that's idle 66% of the time, this achieves greater than 40% savings compared to always-on provisioned clusters. Option B (pause/resume) takes several minutes and may not align with occasional off-hours queries. Option C (RIs) saves up to 40% but you still pay for idle time. Option D (ra3 nodes) may reduce costs but not by 40% if the cluster size stays the same.

---

### Question 74

A company's development teams are deploying resources freely across all AWS Regions in their development accounts. This has led to resources being scattered across 15 Regions, making cost tracking and security monitoring difficult. The company wants to restrict development accounts to only us-east-1 and eu-west-1 while not affecting production accounts.

Which solution MOST effectively restricts Region usage?

A. Create an SCP that denies all actions in non-approved Regions using the `aws:RequestedRegion` condition key. Attach the SCP to the Development OU. Include exceptions for global services like IAM, Route 53, and CloudFront.

B. Remove the development team's IAM permissions for services in non-approved Regions.

C. Use AWS Config rules to detect resources in non-approved Regions and automatically delete them.

D. Create a custom IAM policy in each development account that restricts the Region condition.

**Correct Answer: A**

**Explanation:** An SCP on the Development OU with `aws:RequestedRegion` condition denies resource creation in unapproved Regions. Exceptions for global services (IAM, CloudFront, Route 53, STS) ensure these services remain functional. The SCP automatically applies to all current and future development accounts. Option B requires managing permissions across all accounts and users individually. Option C is reactive, allowing resources to briefly exist. Option D requires per-account deployment and maintenance.

---

### Question 75

A company is reviewing their AWS bill and notices that data transfer charges account for 25% of their total spend. The main sources are: NAT gateway processing fees, inter-AZ data transfer, and data transfer between VPCs. They want to optimize data transfer costs while maintaining the current architecture.

Which combination of strategies MOST reduces data transfer costs? (Choose THREE.)

A. Replace NAT gateways with VPC gateway endpoints for S3 and DynamoDB traffic, which are free.

B. Deploy application instances in a single Availability Zone to eliminate inter-AZ data transfer.

C. Use VPC peering instead of transit gateway for VPC-to-VPC communication to eliminate the per-GB transit gateway data processing charge.

D. Implement a shared VPC model using AWS RAM to reduce cross-VPC traffic by co-locating related workloads in shared subnets.

E. Enable VPC Flow Logs to identify and eliminate unnecessary data transfers.

F. Use S3 Transfer Acceleration for all S3 operations.

**Correct Answer: A, C, D**

**Explanation:** Gateway endpoints for S3/DynamoDB (A) are free, eliminating NAT gateway processing fees for AWS service traffic. VPC peering (C) has no per-GB data processing charge unlike transit gateway, reducing VPC-to-VPC transfer costs. Shared VPCs via RAM (D) place related workloads in the same VPC, converting cross-VPC (charged) traffic to intra-VPC (free) traffic. Option B (single AZ) sacrifices high availability. Option E (Flow Logs) provides visibility but doesn't directly reduce costs. Option F (Transfer Acceleration) increases cost—it's designed for faster uploads, not cost optimization.

---

## End of Practice Test 1

**Scoring Guide:**
- Each question is worth 1 point
- Total possible score: 75
- Approximate passing score: 54/75 (72%)
- Domain 1 (Q1-20): ___/20
- Domain 2 (Q21-42): ___/22
- Domain 3 (Q43-53): ___/11
- Domain 4 (Q54-62): ___/9
- Domain 5 (Q63-75): ___/13
