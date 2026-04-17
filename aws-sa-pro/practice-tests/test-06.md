# AWS Certified Solutions Architect - Professional (SAP-C02) Practice Test 6

**Focus Areas:** CloudFront/Global Accelerator, Route 53, WAF/Shield, Auto Scaling, S3 Advanced Features

**Time Limit:** 180 minutes
**Total Questions:** 75
**Passing Score:** 750/1000

---

## Domain 1: Design Solutions for Organizational Complexity (Questions 1–20)

### Question 1
A multinational corporation operates in 15 countries and has separate AWS accounts for each country's operations. The company uses Amazon CloudFront to distribute content globally and wants to enforce a unified security policy across all distributions. The security team requires that all CloudFront distributions use a minimum TLS 1.2 policy, block requests from certain geographic regions under sanctions, and log all viewer requests to a centralized S3 bucket in the security account. The solution must automatically detect and remediate non-compliant distributions.

A) Deploy AWS Config rules in each account to check CloudFront configurations, use AWS Systems Manager Automation runbooks for remediation, and configure CloudFront access logs to ship to each account's local S3 bucket with cross-account replication to the security account.
B) Use AWS Organizations with SCPs to prevent creation of CloudFront distributions, then manage all distributions from a single central account using CloudFront origin access identities shared across accounts.
C) Implement AWS CloudFormation StackSets to deploy standardized CloudFront configurations across all accounts, use AWS Config conformance packs with auto-remediation via Lambda functions, and configure CloudFront real-time logs with Kinesis Data Streams to a centralized account.
D) Create a custom solution using EventBridge rules in each account to detect CloudFront API calls via CloudTrail, trigger a centralized Lambda function via cross-account IAM roles to enforce compliance, and use S3 cross-region replication for log centralization.

**Correct Answer: C**

**Explanation:** CloudFormation StackSets provide the ability to deploy standardized infrastructure across multiple accounts in an AWS Organization. AWS Config conformance packs allow you to deploy a collection of Config rules and remediation actions as a single entity across an organization. CloudFront real-time logs with Kinesis Data Streams provide near-real-time log delivery that can be directed to a centralized account. Option A would work but S3 cross-account replication adds complexity and latency. Option B is too restrictive — SCPs blocking distribution creation would prevent legitimate use. Option D is overly custom and harder to maintain at scale.

---

### Question 2
A company has a hub-and-spoke AWS account architecture with a central networking account and 50 spoke accounts. Each spoke account hosts customer-facing applications behind CloudFront distributions. The networking team wants to implement AWS WAF rules centrally and apply them consistently to all CloudFront distributions across all accounts. The rules must be updated centrally and propagated within 15 minutes. Some spoke accounts require additional custom rules specific to their applications.

A) Use AWS Firewall Manager in the Organizations management account to create WAF policies that automatically apply to CloudFront distributions across all member accounts, with spoke accounts adding custom rule groups to the web ACLs managed by Firewall Manager.
B) Create WAF web ACLs in each spoke account using CloudFormation StackSets, store rule definitions in AWS Systems Manager Parameter Store in the central account, and use Lambda functions triggered on parameter changes to update all accounts.
C) Deploy a single WAF web ACL in the central networking account and share it across all spoke accounts using AWS Resource Access Manager (RAM), then associate it with each CloudFront distribution.
D) Implement a CI/CD pipeline in the central account that deploys WAF rules to each spoke account using CodePipeline with cross-account CodeDeploy stages and CloudFormation change sets.

**Correct Answer: A**

**Explanation:** AWS Firewall Manager is purpose-built for centrally managing WAF rules across an AWS Organization. It integrates with AWS Organizations and can automatically apply WAF policies to new CloudFront distributions as they're created. Firewall Manager allows the central security team to define baseline rules while permitting spoke accounts to add their own custom rule groups. Option B would work but requires significant custom automation. Option C is incorrect because WAF web ACLs cannot be shared via RAM for CloudFront. Option D introduces unnecessary CI/CD complexity for what Firewall Manager handles natively.

---

### Question 3
A global media company uses Amazon S3 to store and serve petabytes of video content. They have S3 buckets in us-east-1, eu-west-1, and ap-southeast-1. The company recently acquired a competitor and needs to merge their content libraries. The acquired company has 500 TB of content in a single us-west-2 bucket with a complex folder structure. The merged content must be accessible from all regions with consistent metadata, and the migration must complete within 30 days while minimizing data transfer costs.

A) Use S3 Cross-Region Replication from the us-west-2 bucket to all three destination buckets, then delete the source after verification. Enable S3 Inventory on all buckets to verify completeness.
B) Set up S3 Batch Operations with the S3 Copy operation to copy objects from us-west-2 to us-east-1 first (free intra-region-adjacent transfer), then use S3 Replication from us-east-1 to the other two regions. Use S3 Inventory reports to generate the manifest.
C) Deploy an S3 Multi-Region Access Point spanning all four buckets, configure S3 Replication rules between all buckets, then use S3 Batch Replication to replicate existing objects. Use S3 Multi-Region Access Points for unified access going forward.
D) Use AWS DataSync tasks to transfer data from us-west-2 to each destination bucket in parallel, with bandwidth throttling to avoid network congestion. Schedule transfers during off-peak hours.

**Correct Answer: C**

**Explanation:** S3 Multi-Region Access Points provide a single global endpoint that routes requests to the nearest bucket, solving the unified access requirement. S3 Replication rules handle ongoing synchronization, and S3 Batch Replication specifically addresses replicating existing objects (which normal replication doesn't cover). This approach minimizes operational overhead and provides a long-term architecture. Option A doesn't provide unified access and CRR doesn't replicate existing objects without Batch Replication. Option B introduces unnecessary complexity with the staging approach and data transfer between us-west-2 and us-east-1 is not free. Option D works for migration but doesn't solve the ongoing synchronization or unified access requirements.

---

### Question 4
An enterprise runs a critical financial application spanning three AWS accounts: production, disaster recovery, and audit. The application uses CloudFront with a custom domain and must maintain PCI DSS compliance. The security team requires that the TLS certificate used by CloudFront is rotated every 90 days, the private key never leaves a FIPS 140-2 Level 3 validated HSM, and certificate rotation causes zero downtime. The audit account must log all certificate operations.

A) Use AWS Certificate Manager (ACM) to provision public certificates for CloudFront, as ACM handles automatic renewal. Send ACM events to the audit account via EventBridge cross-account event bus. ACM's managed renewal satisfies the 90-day rotation requirement.
B) Generate private keys in AWS CloudHSM, create CSRs, obtain certificates from a public CA, import them into ACM in us-east-1, associate with CloudFront, and use a Lambda function to automate the 90-day rotation cycle. Forward CloudTrail logs to the audit account.
C) Use ACM Private CA to issue certificates, configure automatic renewal at 60-day intervals, associate with CloudFront distributions, and use AWS CloudTrail Lake in the audit account for cross-account certificate operation logging.
D) Store TLS certificates in AWS Secrets Manager with automatic rotation enabled via a custom Lambda function, use the CloudFront API to update the distribution configuration with each new certificate, and replicate secrets to the audit account for logging.

**Correct Answer: B**

**Explanation:** The requirement that the private key never leaves a FIPS 140-2 Level 3 validated HSM mandates the use of AWS CloudHSM, which provides FIPS 140-2 Level 3 validated hardware. ACM's managed certificates (Option A) use AWS-managed keys that don't provide customer-visible FIPS 140-2 Level 3 guarantees for the private key. The process involves generating the private key in CloudHSM, creating a CSR, getting it signed by a public CA, and importing the certificate into ACM for use with CloudFront. Lambda automation handles the 90-day cycle, and CloudTrail cross-account logging covers audit requirements. Option C is incorrect because ACM Private CA certificates are not trusted by browsers for public-facing CloudFront distributions without additional configuration. Option D is incorrect because Secrets Manager cannot directly serve as a certificate source for CloudFront.

---

### Question 5
A large SaaS provider operates separate AWS accounts for each of their 200 enterprise customers using AWS Organizations. Each customer account has an Amazon CloudFront distribution serving their custom-branded portal. The provider wants to implement a centralized caching strategy where common static assets (shared JavaScript libraries, CSS frameworks, common images) are cached once and shared across all customer distributions, while customer-specific content remains isolated. The solution must minimize origin load and data transfer costs.

A) Create a shared S3 bucket in a central account as a secondary origin for all customer CloudFront distributions. Use CloudFront origin groups with failover to serve common assets from the shared origin and customer-specific assets from each customer's bucket.
B) Implement a single CloudFront distribution for shared assets with a unique domain, and configure customer CloudFront distributions to use this shared distribution as a custom origin for common asset paths via cache behaviors.
C) Use CloudFront Functions at viewer-request to rewrite URLs for common assets to a centralized CloudFront distribution, while serving customer-specific content directly. Implement shared cache keys using CloudFront cache policies.
D) Deploy a shared CloudFront distribution with Lambda@Edge to inspect the Host header and route requests to the appropriate customer S3 bucket for custom content, while serving common assets from a shared origin group.

**Correct Answer: B**

**Explanation:** Using a dedicated CloudFront distribution for shared assets as a custom origin behind customer distributions creates an efficient caching architecture. The shared distribution caches common assets at edge locations, and customer distributions pull from this cached layer via cache behaviors that match common asset path patterns (e.g., /shared/*). This minimizes origin load because the shared distribution serves as a mid-tier cache. Option A doesn't reduce edge cache duplication — each customer distribution would still cache the same common assets independently. Option C using CloudFront Functions to redirect would cause additional round trips. Option D consolidating everything into one distribution would create a single point of failure and complicate customer isolation.

---

### Question 6
A healthcare organization uses multiple AWS accounts organized under AWS Organizations. They need to deploy Route 53 health checks that monitor endpoints across all accounts. If any critical endpoint fails, the health check must trigger automated failover AND notify the on-call team via PagerDuty within 60 seconds. The solution must work across 12 AWS Regions and comply with HIPAA requirements for health data in transit.

A) Create Route 53 health checks in each account for local endpoints, aggregate health check results using calculated health checks in the central account, use CloudWatch alarms with SNS to trigger a Lambda function that calls the PagerDuty API, and configure Route 53 failover routing policies.
B) Deploy Route 53 health checks in the central networking account monitoring endpoints across all accounts using their public IPs, configure CloudWatch alarms on HealthCheckStatus metric with a 1-minute period, use SNS with HTTPS endpoint to PagerDuty, and configure Route 53 failover routing.
C) Use AWS Health Dashboard APIs with EventBridge to detect endpoint failures across accounts, trigger Step Functions workflows for failover orchestration, and use Amazon SNS with PagerDuty integration for alerting.
D) Implement custom health check agents on EC2 instances in each region using the CloudWatch agent, publish custom metrics to a centralized CloudWatch namespace using cross-account roles, create composite alarms for failover decisions, and use SNS to PagerDuty.

**Correct Answer: B**

**Explanation:** Route 53 health checks in the central account provide the simplest architecture for monitoring endpoints across all accounts. Route 53 health checks can monitor any public endpoint regardless of which account owns it. CloudWatch alarms on the HealthCheckStatus metric with a 1-minute evaluation period meet the 60-second notification requirement. The SNS-to-PagerDuty HTTPS integration provides reliable alerting. Route 53 failover routing policies automatically redirect traffic when health checks fail. All Route 53 health check traffic is encrypted in transit. Option A adds unnecessary complexity with cross-account health check aggregation. Option C relies on AWS Health which monitors AWS service health, not custom endpoints. Option D requires managing EC2 instances and custom agents, adding operational overhead.

---

### Question 7
A company operates a global e-commerce platform with separate AWS accounts per region. The DNS is managed in a central Route 53 account. During a recent outage, it took 45 minutes to update DNS records because the network team had to manually coordinate changes across multiple hosted zones. The CTO wants to implement a DNS change management system that allows regional teams to propose DNS changes, requires approval from the central networking team, maintains an audit trail, and can execute approved changes within 5 minutes.

A) Create a Service Catalog portfolio in the central account with DNS change products, share it with regional accounts, require central team approval via Service Catalog constraints, and use CloudFormation to execute approved changes to Route 53.
B) Implement a Step Functions workflow triggered by API Gateway. Regional teams submit DNS change requests via API, the workflow stores the request in DynamoDB, sends an approval notification via SNS, and on approval, executes the Route 53 change via Lambda with cross-account roles. All steps are logged in CloudTrail.
C) Use AWS Systems Manager Change Manager to define DNS change templates, require approval workflows from the central team, execute approved changes using Automation runbooks that call Route 53 APIs, and maintain change records in Change Manager's built-in tracking.
D) Set up a CodeCommit repository for DNS configurations stored as Terraform files, implement a CodePipeline with a manual approval stage, and deploy changes to Route 53 using CodeBuild with Terraform apply.

**Correct Answer: C**

**Explanation:** AWS Systems Manager Change Manager is purpose-built for operational change management. It provides pre-defined change templates, multi-level approval workflows, automatic execution of approved changes via Automation runbooks, and built-in change tracking and audit trails. The 5-minute execution requirement is easily met with pre-configured runbooks. Option A using Service Catalog is designed for provisioning resources, not managing changes to existing resources. Option B is a custom-built solution that requires significant development and maintenance. Option D using IaC pipelines is good for infrastructure management but the pipeline execution time may exceed the 5-minute requirement and adds Git workflow overhead for simple DNS changes.

---

### Question 8
An organization with 30 AWS accounts uses Amazon S3 for data lakes across multiple accounts. The data governance team requires that all S3 buckets across the organization enforce the following: server-side encryption with customer-managed KMS keys (no AWS-managed or S3-managed keys), versioning enabled, access logging to a centralized bucket, and MFA delete enabled for all production account buckets. Non-compliant buckets must be flagged within 1 hour and auto-remediated within 4 hours.

A) Deploy AWS Config rules using organizational conformance packs to check encryption, versioning, and logging settings. Use AWS Config auto-remediation with SSM Automation documents. For MFA delete, use a custom Config rule with Lambda since MFA delete requires root credentials and cannot be auto-remediated.
B) Use AWS Security Hub with the AWS Foundational Security Best Practices standard across all accounts, create custom actions for non-compliant findings, and trigger Lambda functions via EventBridge for remediation.
C) Implement SCPs to prevent creation of non-compliant buckets, use CloudTrail with EventBridge to detect configuration changes, and trigger Step Functions for remediation workflows across accounts.
D) Deploy a centralized Lambda function on a 1-hour schedule that scans all S3 buckets across accounts using AssumeRole, checks compliance, and remediates non-compliant configurations using the S3 API.

**Correct Answer: A**

**Explanation:** AWS Config organizational conformance packs provide the most comprehensive approach. Config rules can detect non-compliant encryption settings (s3-bucket-server-side-encryption-enabled with KMS check), versioning (s3-bucket-versioning-enabled), and logging configurations. Auto-remediation via SSM Automation documents can fix encryption, versioning, and logging within the 4-hour window. The critical insight is that MFA delete requires root account credentials to enable, making it impossible to auto-remediate via automation — hence a custom Config rule that flags it for manual action is the correct approach. Option B's Security Hub checks don't cover all these specific requirements and has limited auto-remediation. Option C's SCPs prevent creation but don't remediate existing non-compliant buckets. Option D is a custom solution with higher operational overhead.

---

### Question 9
A financial services company is implementing a multi-account strategy. They need to ensure that CloudFront distributions in development accounts can only serve content over HTTPS from S3 origins, while production accounts can use custom origins with specific TLS policies. Both account types must prevent CloudFront distributions from being created without WAF web ACLs attached. The solution should allow the security team to grant exceptions when needed.

A) Create two SCPs — one for development OUs restricting CloudFront CreateDistribution and UpdateDistribution to S3 origins with ViewerProtocolPolicy HTTPS-only, another for production OUs requiring minimum TLS 1.2. Use a separate SCP requiring WAF association. Use tag-based SCP conditions for exceptions.
B) Use AWS Firewall Manager to enforce WAF associations on all CloudFront distributions. Deploy AWS Config rules via conformance packs to check origin types and TLS policies based on account OU membership. Use Config auto-remediation for non-compliant distributions.
C) Implement IAM permission boundaries in each account type that restrict CloudFront API actions based on the distribution configuration parameters. Use SCP exception policies attached to specific accounts when exceptions are needed.
D) Deploy CloudFormation Guard rules in a CI/CD pipeline that validates CloudFront templates before deployment. Use Service Control Policies to prevent direct console or API creation of CloudFront distributions, forcing all changes through the pipeline.

**Correct Answer: B**

**Explanation:** This solution combines two AWS-native services optimally. Firewall Manager is the best tool for enforcing WAF associations on CloudFront distributions — it can automatically associate WAF web ACLs with new distributions and detect/remediate distributions without WAF. AWS Config conformance packs deployed per OU can check origin types and TLS policies with different rules for dev vs. production accounts. Config auto-remediation handles non-compliant distributions. Option A is partially correct but SCPs cannot inspect CloudFront distribution configuration parameters like origin type or TLS policy at the API level with that granularity. Option C is incorrect because IAM permission boundaries cannot conditionally restrict based on CloudFront configuration parameters. Option D forces pipeline-only deployment which is too restrictive and doesn't handle existing distributions.

---

### Question 10
A company has a centralized logging account that collects CloudFront access logs from 100 accounts. Each account generates approximately 50 GB of logs per day. The security team needs to query these logs for threat analysis within 30 seconds for the last 24 hours of data, and within 5 minutes for the last 90 days. After 90 days, logs must be retained for 7 years for compliance but query performance is not critical. Cost optimization is a key concern.

A) Configure CloudFront to send real-time logs to Kinesis Data Firehose, which delivers to S3 in the logging account partitioned by date. Use Amazon Athena with partition projection for queries. Apply S3 Lifecycle policies to transition to S3 Glacier Deep Archive after 90 days.
B) Send CloudFront real-time logs to Amazon OpenSearch Service with a hot-warm-cold architecture. Hot nodes retain 24 hours for fast queries, warm nodes for 90 days, and UltraWarm/cold storage for 7 years.
C) Deliver CloudFront real-time logs to Kinesis Data Streams, process with Lambda to enrich and store in Amazon Timestream for the 24-hour fast query window. Simultaneously store raw logs in S3 with Athena for 90-day queries. Apply S3 Lifecycle to Glacier Deep Archive after 90 days.
D) Use CloudFront standard logging to S3, create a daily AWS Glue ETL job to transform and load the last 24 hours into Amazon Redshift Serverless for fast queries. Keep 90 days in Redshift, then unload to S3 and transition to Glacier Deep Archive.

**Correct Answer: A**

**Explanation:** At 5 TB/day (50 GB × 100 accounts), cost efficiency is critical. CloudFront real-time logs to Kinesis Data Firehose provides near-real-time log delivery to S3 with automatic partitioning (by date/hour). Athena with partition projection enables fast queries on recent data by efficiently scanning only relevant partitions — 24 hours of data (~5 TB) can be queried within 30 seconds with appropriate partitioning. For 90-day queries, Athena scans more partitions but meets the 5-minute SLA. S3 Lifecycle to Glacier Deep Archive after 90 days provides cost-effective 7-year retention. Option B's OpenSearch is expensive at this data volume — hot nodes for 5 TB/day and 7-year retention would be extremely costly. Option C adds unnecessary complexity with Timestream. Option D's daily Glue ETL introduces latency that may not meet the 30-second requirement for recent data.

---

### Question 11
A global retail company is using AWS Organizations with consolidated billing. They have 200 accounts with CloudFront distributions across different business units. The finance team discovers that CloudFront costs have increased by 300% in the last quarter, but they cannot determine which business units or applications are responsible because CloudFront costs appear as a single line item in the consolidated bill. The company needs granular cost visibility and the ability to implement charge-back to individual business units.

A) Enable Cost Allocation Tags across the organization, require all CloudFront distributions to be tagged with BusinessUnit and Application tags using tag policies in AWS Organizations, and use AWS Cost Explorer with tag-based filtering to generate charge-back reports.
B) Move each business unit's CloudFront distributions to separate linked accounts, enable detailed billing reports per account, and use AWS Cost and Usage Reports (CUR) with Athena for detailed analysis.
C) Enable AWS Cost and Usage Reports (CUR) with resource-level detail, use the resource IDs in CUR to map CloudFront distributions to business units via a tagging-based lookup in a central DynamoDB table, and build charge-back dashboards in QuickSight.
D) Use CloudFront usage reports and access logs to calculate per-distribution costs manually, build a custom Lambda-based billing system that parses these reports monthly, and store results in an RDS database for reporting.

**Correct Answer: A**

**Explanation:** Cost Allocation Tags are the standard AWS mechanism for cost attribution. AWS Organizations Tag Policies can enforce required tags (BusinessUnit, Application) across all accounts, ensuring compliance. Once tags are activated as cost allocation tags, they appear in Cost Explorer and CUR, enabling direct filtering and charge-back reporting without custom infrastructure. Option B restructuring accounts by business unit is disruptive and impractical for 200 existing accounts. Option C works but adds unnecessary complexity with the DynamoDB lookup when tags provide direct attribution. Option D is entirely custom and error-prone, with no integration into AWS billing tools.

---

### Question 12
An enterprise operates a multi-account environment with a shared services account that hosts common infrastructure. The shared services account contains Route 53 private hosted zones that must be accessible from VPCs in 40 spoke accounts across 4 regions. When new accounts are added to the organization, they must automatically gain access to these private hosted zones. The solution must handle VPC CIDR overlaps between spoke accounts.

A) Use Route 53 Resolver rules shared via AWS RAM across the organization, with Route 53 Resolver endpoints in the shared services VPC, and configure spoke account VPCs to use the shared Resolver rules for forwarding DNS queries.
B) Associate the Route 53 private hosted zones with each spoke account VPC using cross-account VPC association authorizations. Automate the association for new accounts using a Lambda function triggered by the Organizations CreateAccount API via EventBridge.
C) Deploy Route 53 Resolver endpoints in each spoke account VPC and create conditional forwarding rules pointing to the shared services account's Resolver inbound endpoints. Use Transit Gateway for network connectivity.
D) Implement a custom DNS proxy fleet on EC2 instances in the shared services account, configure spoke account VPCs to use these as custom DNS servers via DHCP option sets, and use Auto Scaling for high availability.

**Correct Answer: B**

**Explanation:** Route 53 private hosted zone cross-account VPC association is the native solution. You authorize the association from the hosted zone account and accept it from the VPC account. Automating this with Lambda triggered by EventBridge (when new accounts are created via Organizations) ensures new accounts automatically get access. This approach works regardless of CIDR overlaps because DNS resolution doesn't depend on network routing between VPCs. Option A using Route 53 Resolver rules requires network connectivity (e.g., Transit Gateway) and doesn't directly solve private hosted zone access. Option C requires Transit Gateway connectivity and is more complex. Option D is custom infrastructure with high operational overhead.

---

### Question 13
A company operates a multi-tier web application using CloudFront, ALB, and EC2 Auto Scaling groups across three accounts (web, app, data). The architecture team needs to implement a blue-green deployment strategy that spans all three accounts. During deployment, CloudFront must seamlessly shift traffic from the blue (current) to green (new) environment, with the ability to instantly rollback if error rates exceed 1%. The deployment must not require DNS changes.

A) Use CloudFront continuous deployment with staging distributions. Deploy the green environment, associate it with the staging distribution for testing, then promote the staging configuration to the primary distribution. Monitor error rates with CloudWatch and use the CloudFront API to rollback if needed.
B) Configure CloudFront with two origin groups — blue and green ALB origins. Use Lambda@Edge to implement weighted routing between origins based on a DynamoDB configuration flag. Adjust weights gradually and rollback by flipping the flag.
C) Create two separate CloudFront distributions (blue and green) behind Route 53 weighted routing. Shift traffic by adjusting Route 53 weights. Use Route 53 health checks linked to CloudWatch alarms on error rate metrics for automatic rollback.
D) Use CloudFront with a single ALB origin. Implement blue-green at the ALB level using weighted target groups. Use CodeDeploy with ALB traffic shifting for gradual deployment and automatic rollback based on CloudWatch alarms.

**Correct Answer: A**

**Explanation:** CloudFront continuous deployment is the native feature designed for this exact use case. It creates a staging distribution that shares the same CloudFront domain but receives a configurable percentage of traffic. This allows testing the green environment without DNS changes. The staging distribution can be promoted to production with a single API call, and rollback is equally fast. Option B using Lambda@Edge for routing adds latency and complexity. Option C requires DNS changes which violates the requirements. Option D only handles blue-green at the ALB tier, not across all three account tiers.

---

### Question 14
A multinational company has AWS accounts in an Organization with OUs structured by region (US, EU, APAC). Each regional OU has sub-OUs for production, staging, and development. The company must comply with data residency laws: EU data must stay in eu-west-1 and eu-central-1, APAC data must stay in ap-southeast-1 and ap-northeast-1. US accounts have no restrictions. The solution must prevent accidental resource creation in non-compliant regions while allowing global services like CloudFront, Route 53, and IAM.

A) Attach SCPs to the EU and APAC OUs that deny all actions unless the aws:RequestedRegion condition matches the allowed regions. Add explicit allows for global services by listing their service prefixes in a separate SCP statement.
B) Attach SCPs to the EU and APAC OUs that deny actions for regional services when aws:RequestedRegion does not match allowed regions, with NotAction listing global services (cloudfront:*, route53:*, iam:*, sts:*, support:*, etc.) to exclude them from the deny.
C) Use AWS Config rules to detect resources created in non-compliant regions and auto-remediate by deleting them. Combine with CloudFormation Guard to prevent non-compliant deployments in CI/CD pipelines.
D) Implement IAM permission boundaries in all EU and APAC accounts that restrict resource creation to approved regions, with exceptions for global services defined in the boundary policy.

**Correct Answer: B**

**Explanation:** The correct approach uses SCPs with a deny statement and NotAction for global services. The SCP denies all regional service actions when aws:RequestedRegion doesn't match the allowed list, while using NotAction to exclude global services (CloudFront, Route 53, IAM, STS, Organizations, Support, etc.) from the deny. This is the AWS-recommended pattern for region restriction. Option A's approach of denying all actions and explicitly allowing global services is harder to maintain and may miss services. Option C detects after the fact rather than preventing, which doesn't satisfy compliance requirements. Option D requires managing permission boundaries in every account and for every role, which doesn't scale.

---

### Question 15
A company's security team discovers that an S3 bucket in a development account is publicly accessible and contains sensitive data that was improperly classified. The CISO mandates an organization-wide solution to prevent any S3 bucket from being publicly accessible in any account, including new accounts added in the future. The solution must also detect and remediate existing public buckets within 1 hour while allowing specific exception buckets used for static website hosting in approved accounts.

A) Enable S3 Block Public Access at the organization level using the Organizations management account. For exceptions, disable block public access at the account level for specific approved accounts and manage bucket-level permissions for static website hosting buckets.
B) Use an SCP to deny s3:PutBucketPolicy, s3:PutBucketAcl, and s3:PutAccessPointPolicy actions that would make buckets public. Create exception entries using SCP condition keys with tag-based exceptions for approved buckets.
C) Enable S3 Block Public Access at the organization level. For approved static website hosting, use CloudFront with origin access control (OAC) to serve content from private S3 buckets instead of making buckets public, eliminating the need for exceptions.
D) Deploy AWS Config rule s3-bucket-public-read-prohibited and s3-bucket-public-write-prohibited across all accounts with auto-remediation via Lambda that enables S3 Block Public Access at the bucket level. Maintain an exception list in DynamoDB.

**Correct Answer: C**

**Explanation:** Enabling S3 Block Public Access at the organization level is the most effective preventive control — it applies to all accounts and cannot be overridden by account-level settings. The key insight is addressing the static website hosting exception: rather than creating exceptions to the public access block (which weakens security), using CloudFront with OAC serves the same purpose while keeping buckets private. This eliminates the need for any exceptions. Option A weakens security by disabling block public access for entire accounts. Option B with SCPs cannot inspect the effect of bucket policies to determine if they make buckets public. Option D is detective rather than preventive, and managing exceptions adds complexity.

---

### Question 16
A digital media company has an AWS Organization with 50 accounts. They use S3 Intelligent-Tiering for their media assets. The CTO wants a centralized dashboard showing storage utilization, cost trends, and access pattern analytics across all accounts. The dashboard must update daily, show per-account and per-bucket breakdowns, and allow drill-down to object-level access patterns for specific buckets. The finance team also needs monthly reports exported to CSV.

A) Enable S3 Storage Lens at the organization level with advanced metrics. Create a Storage Lens dashboard with account-level and bucket-level metrics. For object-level access patterns, enable S3 Storage Lens advanced data protection and activity metrics. Export daily metrics to S3 and use QuickSight for CSV-exportable reports.
B) Configure S3 Inventory in each account, aggregate inventory reports in a central S3 bucket, use AWS Glue to process inventory data, and build dashboards in QuickSight. Use S3 Server Access Logs for access pattern analysis.
C) Use AWS Cost Explorer API to extract S3 cost data, combine with CloudWatch S3 metrics for utilization data, aggregate in a central Redshift Serverless cluster, and build dashboards in QuickSight.
D) Deploy a Lambda function in each account that collects S3 metrics using the S3 API, publishes to a centralized CloudWatch namespace using cross-account roles, and build CloudWatch dashboards with CSV export capability.

**Correct Answer: A**

**Explanation:** S3 Storage Lens is purpose-built for organization-wide S3 analytics. At the organization level with advanced metrics enabled, it provides daily updated dashboards with account-level and bucket-level breakdowns, including metrics on access patterns, data protection, and cost efficiency. Advanced metrics include activity metrics for access pattern analysis. Storage Lens can export daily metrics to S3 in CSV/Parquet format, which can be visualized in QuickSight for custom reports. Option B requires significant custom infrastructure. Option C doesn't provide access pattern analytics. Option D is entirely custom and operationally expensive.

---

### Question 17
An organization uses AWS WAF with CloudFront to protect its web applications across 10 accounts. They want to share threat intelligence across accounts — when a WAF rule blocks an IP in one account, all other accounts should automatically block that IP within 5 minutes. The solution must handle up to 10,000 IPs and distinguish between automated blocks (which expire after 24 hours) and manually added permanent blocks.

A) Use AWS Firewall Manager to manage WAF rules centrally with an IP set that is synchronized across all accounts. Implement a Lambda function that collects WAF logs from all accounts, identifies blocked IPs, and updates the central IP set.
B) Configure WAF to send logs to a centralized Kinesis Data Firehose. Use a Lambda function triggered by Kinesis to extract blocked IPs, store them in DynamoDB with TTL for automated blocks (24-hour TTL) and no TTL for manual blocks. A separate Lambda function runs every 5 minutes, reads DynamoDB, and updates WAF IP sets across all accounts using cross-account roles.
C) Use EventBridge to forward WAF block events from all accounts to a central event bus. A Lambda function processes events, updates a centralized WAF IP set, and Firewall Manager propagates the IP set to all accounts. Store IP metadata in DynamoDB with TTL for auto-expiry.
D) Create a shared WAF IP set using AWS RAM, give all accounts read/write access. Each account's WAF logs trigger Lambda functions that directly update the shared IP set. Use DynamoDB with TTL for tracking expiry of automated blocks.

**Correct Answer: C**

**Explanation:** This solution optimally combines EventBridge, Lambda, Firewall Manager, and DynamoDB. EventBridge cross-account event routing provides near-real-time propagation of WAF block events. Lambda processing at the central bus extracts blocked IPs and writes to DynamoDB (with TTL for automated 24-hour blocks). Firewall Manager manages the WAF IP sets across all accounts, ensuring consistent enforcement. The 5-minute propagation requirement is met through EventBridge's near-real-time delivery plus Firewall Manager's update cycle. Option A is vague about the log collection mechanism. Option B's 5-minute Lambda polling interval is less efficient than event-driven architecture. Option D's direct shared IP set writes could cause race conditions with concurrent updates from multiple accounts.

---

### Question 18
A company operates a multi-tenant SaaS platform across 5 AWS accounts. Each account hosts multiple tenant workloads behind CloudFront distributions. The platform team needs to implement per-tenant rate limiting at the CloudFront layer. Each tenant has a different rate limit based on their subscription tier (Basic: 100 req/s, Professional: 1000 req/s, Enterprise: 10000 req/s). Tenant identification is based on an API key in the x-api-key header. The solution must work without modifying the backend application.

A) Use AWS WAF rate-based rules with custom request handling. Create separate WAF rules for each tenant with their API key as the scope-down criteria and appropriate rate limits. Associate the web ACL with CloudFront distributions.
B) Deploy CloudFront Functions at viewer-request to extract the API key, look up the tenant's rate limit from a CloudFront KeyValueStore, and implement token-bucket rate limiting using CloudFront KeyValueStore for state tracking.
C) Use AWS WAF with a rate-based rule that aggregates by the x-api-key header value. Set the rate limit to the highest tier (10,000 req/s). Deploy a Lambda function that periodically reads tenant tier data and creates additional WAF rules for lower-tier tenants with their specific limits.
D) Implement Lambda@Edge at viewer-request to extract the API key, query DynamoDB for tenant tier, and enforce rate limiting using DynamoDB atomic counters with TTL for sliding window rate limiting.

**Correct Answer: A**

**Explanation:** AWS WAF rate-based rules support scope-down statements that can match specific header values (x-api-key). By creating separate rate-based rules for each tenant (or groups of tenants by tier), you can enforce different rate limits based on the API key. WAF rules can be associated with CloudFront distributions, requiring no backend changes. This is the most operationally simple approach. Option B is incorrect because CloudFront Functions have limited capabilities and KeyValueStore is read-only from functions (cannot track state for rate limiting). Option C's approach of using the highest limit universally doesn't enforce lower-tier limits accurately. Option D adds latency to every request with DynamoDB calls and is expensive at scale.

---

### Question 19
A company runs a data analytics platform with a centralized S3 data lake in the analytics account. Data producers in 20 different accounts need to write data to specific prefixes in the data lake. Data consumers in 10 accounts need read access to specific prefixes. Access must be managed centrally, new producer/consumer accounts must be onboarded within 1 hour, and all access must be logged with the originating account identity preserved.

A) Use S3 bucket policies with cross-account access conditions, specifying each account's IAM roles and allowed prefixes. Use STS external IDs for security. Enable S3 server access logging.
B) Implement S3 Access Points — one per producer account with write permissions to their specific prefix, and one per consumer account group with read permissions to their allowed prefixes. Use S3 Access Points policies for fine-grained access control. Enable CloudTrail data events for audit logging.
C) Use AWS Lake Formation to manage the data lake. Register the S3 location in Lake Formation, define databases and tables, and grant fine-grained permissions to cross-account IAM roles using Lake Formation permissions. Use Lake Formation audit logs via CloudTrail.
D) Share the S3 bucket via AWS RAM to all producer and consumer accounts. Use IAM policies in each account to restrict access to specific prefixes. Use bucket policies as a secondary control layer.

**Correct Answer: B**

**Explanation:** S3 Access Points are designed for managing access to shared buckets at scale. Each access point has its own policy, DNS name, and can restrict access to specific prefixes. Creating new access points for onboarding (within 1 hour) is straightforward. Access points maintain the originating account identity in CloudTrail data events. This scales better than bucket policies (which have a 20 KB size limit that becomes a constraint with 30+ accounts). Option A's bucket policy approach hits size limits with 30 accounts and complex prefix rules. Option C with Lake Formation is best for table-level analytics access but adds overhead for raw S3 prefix-level access patterns. Option D is incorrect because S3 buckets cannot be shared via RAM.

---

### Question 20
A financial services firm has a multi-account architecture with separate production, staging, and development accounts. The firm is implementing disaster recovery for their primary CloudFront distribution that serves their trading platform. The RTO is 15 minutes and RPO is near-zero. The primary CloudFront distribution uses custom error pages, Lambda@Edge functions, custom headers, and complex cache behaviors. The firm needs a DR strategy that can failover the CloudFront distribution to a secondary configuration if the primary becomes unavailable or misconfigured.

A) Maintain the CloudFront distribution configuration as CloudFormation templates in CodeCommit. If the primary distribution fails, deploy a new distribution from the template using a CI/CD pipeline. Use Route 53 with a CNAME record to switch to the new distribution.
B) Use CloudFront continuous deployment to maintain a staging distribution with an identical configuration. In a DR event, promote the staging distribution to primary. Keep the staging distribution synchronized using a Lambda function that copies configuration changes.
C) Export the CloudFront distribution configuration periodically using the GetDistribution API, store it in S3 with versioning. In a DR event, create a new distribution from the stored configuration using a Lambda function, update Route 53 to point to the new distribution.
D) Create a secondary CloudFront distribution in the same account with identical configuration managed via CloudFormation. Use Route 53 failover routing with health checks on the primary distribution's origin. Both distributions use the same ACM certificate and alternate domain name (one active, one warm standby with the alternate domain name removed until failover).

**Correct Answer: D**

**Explanation:** Maintaining a secondary CloudFront distribution as warm standby provides the fastest failover within the 15-minute RTO. Both distributions are managed by CloudFormation ensuring identical configurations (cache behaviors, Lambda@Edge, custom headers, error pages). Route 53 failover routing with health checks provides automatic failover. The warm standby distribution is pre-deployed (eliminating deployment time), and the only change needed during failover is adding the alternate domain name to the secondary distribution via API call. Near-zero RPO is achieved because both distributions serve from the same origins. Option A's pipeline deployment would likely exceed 15 minutes. Option B's continuous deployment isn't designed for DR scenarios. Option C's create-on-demand approach adds risk and deployment time.

---

## Domain 2: Design for New Solutions (Questions 21–42)

### Question 21
A streaming media company is launching a live sports broadcasting service expected to handle 10 million concurrent viewers during peak events. The video content is delivered via Amazon CloudFront. Each viewer receives a unique token in the URL for access control. The company wants to prevent unauthorized sharing of these tokenized URLs while maintaining sub-second start times for the live stream. The token must expire within 5 minutes of generation.

A) Use CloudFront signed URLs with a 5-minute expiry. Generate signed URLs using Lambda@Edge at the authentication layer. Use custom policy for signed URLs to restrict by IP address and time.
B) Use CloudFront signed cookies with a custom policy that restricts access by time (5-minute window) and optionally by IP range. Cookies are set during the authentication flow and CloudFront validates them on each request.
C) Implement CloudFront field-level encryption to encrypt the token in the URL, validate the token using Lambda@Edge at the origin-request event, and reject requests with expired or invalid tokens.
D) Use AWS WAF with CloudFront to implement token validation. Create a custom WAF rule that inspects the URL query string for valid tokens, and use a Lambda function integrated with WAF to validate token expiry.

**Correct Answer: B**

**Explanation:** Signed cookies are the optimal choice for live streaming because they authorize access to the entire stream (multiple segments/chunks) without requiring individually signed URLs for each segment. HLS/DASH live streams consist of hundreds of small segment files — signing each URL would be impractical and add latency. Signed cookies with a 5-minute custom policy (using DateLessThan) authorize access to a path pattern for the duration. This maintains sub-second start times since cookie validation is handled natively by CloudFront edge locations. Option A with signed URLs would require signing each media segment URL individually, which is impractical for live streams. Option C's field-level encryption is for protecting sensitive form data. Option D's WAF-based validation adds latency and doesn't scale efficiently for 10 million concurrent viewers.

---

### Question 22
A company is designing a global API platform that must serve users from 30 countries with single-digit millisecond response times. The API responses are personalized (non-cacheable). The platform must handle sudden traffic spikes of up to 50x normal load during product launches. The backend is a microservices architecture running on ECS Fargate. The company needs to minimize the impact of regional failures and ensure requests are routed to the nearest healthy region.

A) Deploy the API in three regions behind Amazon CloudFront with an Application Load Balancer origin in each region. Use CloudFront origin failover with origin groups to handle regional failures. Use ECS Service Auto Scaling with target tracking.
B) Use AWS Global Accelerator with endpoints in three regions, each with an ALB fronting ECS Fargate services. Configure Global Accelerator health checks for automatic failover. Use ECS Service Auto Scaling with step scaling policies tuned for 50x spikes.
C) Deploy API Gateway Regional endpoints in three regions behind Route 53 latency-based routing with health checks. Backend on ECS Fargate with auto-scaling. Use Route 53 failover as secondary routing policy.
D) Use CloudFront with Lambda@Edge to handle API requests at edge locations, with DynamoDB Global Tables as the backend data store for personalized responses. Cache user profiles at the edge using CloudFront Functions.

**Correct Answer: B**

**Explanation:** AWS Global Accelerator is the optimal choice for non-cacheable, latency-sensitive API traffic. It uses the AWS global network to route requests to the nearest healthy region, providing consistent single-digit millisecond improvements in latency. Unlike CloudFront, Global Accelerator is designed for non-cacheable traffic. Built-in health checks enable automatic failover within seconds. For 50x traffic spikes, step scaling policies with aggressive scale-out thresholds are more responsive than target tracking. Option A using CloudFront adds minimal value for non-cacheable responses since they bypass the cache. Option C with Route 53 has slower failover (depends on DNS TTL) compared to Global Accelerator's instant failover. Option D is architecturally unsound — Lambda@Edge has concurrency limits and cold starts that conflict with single-digit millisecond requirements at 50x spike scale.

---

### Question 23
A company operates a global e-commerce platform and wants to implement dynamic content acceleration for their product pages. Each product page is semi-personalized — 80% of the page content is the same for all users (product details, images) while 20% is personalized (pricing, recommendations, cart status). The current architecture serves the entire page from the origin, resulting in high latency for distant users. The solution must reduce page load times by at least 50% for users in all regions.

A) Use CloudFront with cache behaviors to serve static portions (images, CSS, JS) from cache. For the dynamic page, use Lambda@Edge at origin-request to assemble the page by fetching the static template from S3 cache and personalized data from the API origin.
B) Implement CloudFront with Edge Side Includes (ESI) processing using Lambda@Edge. Cache the static 80% of the page at the edge and use Lambda@Edge to fetch and inject the personalized 20% from the origin for each request.
C) Use CloudFront to cache the full static page template at the edge. Implement a client-side JavaScript approach where the browser loads the cached static page immediately, then makes asynchronous API calls through CloudFront to fetch personalized content. Use separate cache behaviors for static and API routes.
D) Deploy CloudFront with origin shield enabled and aggressive caching for the full page. Use CloudFront Functions to add user-specific cache keys based on cookies, effectively creating per-user cached pages.

**Correct Answer: C**

**Explanation:** The client-side composition approach delivers the best user experience and performance. The static page template (80% of content) is cached at CloudFront edge locations and served instantly, dramatically reducing perceived load times. The browser then asynchronously fetches the personalized 20% via API calls routed through CloudFront. This approach achieves >50% latency reduction because the majority of page content loads from cache. Separate cache behaviors optimize caching for each content type. Option A's Lambda@Edge assembly adds origin-facing latency for every request. Option B's ESI-like approach still requires an origin round-trip for every page request. Option D creating per-user cache keys would result in extremely low cache hit ratios, essentially negating the CDN benefit.

---

### Question 24
A logistics company needs to design a fleet tracking system that ingests GPS coordinates from 100,000 vehicles every 5 seconds. The system must provide real-time vehicle locations on a map, support geofence alerts (notify when a vehicle enters/exits a defined area), and store historical location data for 2 years for route optimization analytics. The solution must handle the ingestion rate of 20,000 events per second with end-to-end latency under 10 seconds for geofence alerts.

A) Use Amazon Kinesis Data Streams for ingestion, process with AWS Lambda for geofence calculations using Amazon Location Service, store real-time positions in Amazon ElastiCache (Redis) for the map, and archive to S3 via Kinesis Data Firehose for long-term analytics with Athena.
B) Use Amazon IoT Core for device ingestion with IoT Rules for routing. Send data to Amazon Timestream for time-series storage and real-time queries. Use Amazon Location Service geofences for alert processing. Use Grafana for map visualization.
C) Use Amazon MSK (Kafka) for ingestion, Apache Flink on Kinesis Data Analytics for real-time geofence processing, Amazon DynamoDB with TTL for recent positions (map display), and S3 with Glacier transition for historical data.
D) Use API Gateway WebSocket API for vehicle connections, Lambda for processing, Amazon Location Service for geofencing, DynamoDB for current positions, and Redshift for historical analytics.

**Correct Answer: A**

**Explanation:** This architecture optimally handles each requirement. Kinesis Data Streams can handle 20,000 events/second with appropriate shard count. Lambda consumers process events through Amazon Location Service's geofence evaluation API for sub-10-second alert latency. ElastiCache Redis provides sub-millisecond reads for the real-time map display (using geospatial data types). Kinesis Data Firehose buffers and delivers data to S3 for cost-effective 2-year storage, queryable with Athena for route optimization. Option B's IoT Core adds unnecessary protocol translation overhead since GPS data is typically HTTP/HTTPS. Timestream is more expensive than S3+Athena for 2-year storage. Option C's MSK has higher operational overhead than Kinesis. Option D's API Gateway WebSocket has connection limits that make 100,000 persistent connections challenging.

---

### Question 25
A healthcare company is designing a patient portal that must serve users in the United States and European Union. Due to GDPR and HIPAA regulations, EU patient data must be stored and processed exclusively in the eu-west-1 region, while US patient data must stay in us-east-1. Users should experience consistent low latency regardless of their location. The application requires real-time data and cannot tolerate stale reads. The portal uses both relational data (patient records) and unstructured data (medical images).

A) Use Route 53 geolocation routing to direct EU users to eu-west-1 and US users to us-east-1 deployments. Each region has independent Aurora PostgreSQL clusters, S3 buckets, and application stacks. No cross-region data replication. Use CloudFront with regional origin restrictions.
B) Deploy a single global application with Aurora Global Database spanning both regions and S3 Cross-Region Replication with object-level tagging for data residency. Use Lambda@Edge to route requests based on user location.
C) Use Route 53 geolocation routing to direct users to the correct region. Deploy independent application stacks in each region with Aurora PostgreSQL and S3. Share authentication using Cognito with a single user pool. Implement application-level data residency enforcement.
D) Use Global Accelerator to route traffic to the nearest region. Deploy Aurora Global Database with write forwarding for low-latency writes in both regions. Use S3 Multi-Region Access Points for image storage with replication.

**Correct Answer: A**

**Explanation:** Data residency requirements mandate complete data isolation — EU data must never leave eu-west-1 and US data must never leave us-east-1. This eliminates any solution involving cross-region data replication (Options B, D) because replication would move protected data across regions, violating GDPR and HIPAA data residency rules. Route 53 geolocation routing ensures users are directed to the correct regional deployment. Independent infrastructure stacks in each region maintain complete data isolation. CloudFront with regional edge caches provides low latency for static assets. Option C's shared Cognito user pool could result in authentication data crossing regions. Option A's fully isolated approach is the only one that strictly satisfies data residency requirements.

---

### Question 26
An online gaming company is designing a global leaderboard system for their multiplayer game with 5 million daily active users. The leaderboard must support real-time score updates, display the top 100 players globally, show each player's rank, and support regional leaderboards. Updates must be reflected within 1 second. The system must handle 50,000 score updates per second during peak hours.

A) Use Amazon ElastiCache for Redis Global Datastore with sorted sets for the leaderboard. Primary cluster in us-east-1 handles writes, read replicas in other regions for regional and global reads. Use ZADD for score updates and ZRANK/ZREVRANGE for rankings.
B) Use Amazon DynamoDB Global Tables with a score attribute and GSI for ranking. Implement leaderboard queries using DynamoDB Scan with FilterExpression. Use DynamoDB Streams with Lambda for real-time rank calculation.
C) Use Amazon Aurora Global Database with a scores table and window functions for rank calculation. Use read replicas in each region for low-latency reads. Materialized views refresh every second for the top 100.
D) Use Amazon Timestream for score storage with time-series queries for leaderboard calculation. Deploy read endpoints in multiple regions and use scheduled queries for leaderboard aggregation.

**Correct Answer: A**

**Explanation:** Redis sorted sets are the gold standard for leaderboard implementations. ZADD provides O(log(N)) score updates, ZREVRANGE retrieves the top N players in O(log(N)+M), and ZRANK returns a player's rank in O(log(N)). ElastiCache for Redis Global Datastore provides cross-region replication for regional reads. At 50,000 updates/second, Redis handles this comfortably. Regional leaderboards can be maintained as separate sorted sets. The 1-second update reflection is achieved because Redis operations are sub-millisecond and replication lag in Global Datastore is typically under 1 second. Option B's DynamoDB doesn't natively support ranking without full table scans or complex GSI designs. Option C's Aurora adds SQL overhead for what's fundamentally a sorted set operation. Option D's Timestream is designed for time-series data, not ranking use cases.

---

### Question 27
A media company needs to implement an image processing pipeline for their content management system. Editors upload high-resolution images (up to 200 MB each) that need to be processed into 15 different sizes and formats (thumbnails, social media sizes, print resolution). The pipeline must handle burst uploads of 1,000 images during major events. Each image's 15 variants must be generated within 5 minutes of upload. The processed images must be served globally with sub-100ms latency.

A) Use S3 event notifications to trigger a Step Functions workflow for each upload. The workflow fans out 15 parallel Lambda functions, each generating one variant using Sharp library, storing results back in S3. Serve processed images via CloudFront with S3 origin.
B) Use S3 event notifications to trigger an SQS queue, which feeds an ECS Fargate task using Spot capacity. Each task processes all 15 variants for one image. Store results in S3 and serve via CloudFront.
C) Use S3 event notifications to trigger Lambda, which publishes to SNS with 15 SQS subscriptions (one per variant). Each queue feeds a separate Lambda function optimized for that variant's processing. Store results in S3 and serve via CloudFront.
D) Use CloudFront with on-the-fly image transformation using Lambda@Edge. When a variant is requested, Lambda@Edge checks if it exists in S3; if not, it generates the variant from the original, stores it in S3, and returns it. Use CloudFront caching for subsequent requests.

**Correct Answer: A**

**Explanation:** Step Functions with parallel Lambda execution is the optimal architecture. Step Functions orchestrates the workflow with a Parallel state that fans out 15 Lambda functions simultaneously. Each Lambda processes one variant, enabling all 15 variants to complete within the 5-minute window even for 200 MB images. Lambda functions with 10 GB memory and 15-minute timeout can handle large image processing. During burst uploads of 1,000 images, Lambda's concurrency scales to handle 15,000 parallel executions. S3+CloudFront provides global sub-100ms delivery. Option B's Fargate has slower scaling (minutes to provision tasks) which may miss the 5-minute SLA during bursts. Option C's SNS/SQS fan-out is more complex without the orchestration benefits of Step Functions. Option D delays variant generation until first request, doesn't meet the 5-minute proactive processing requirement, and Lambda@Edge has a 30-second timeout and 50 MB response limit.

---

### Question 28
A financial technology company needs to design a real-time fraud detection system for payment transactions. The system must analyze each transaction against historical patterns, user behavior, and known fraud signatures within 100 milliseconds. The system processes 10,000 transactions per second during peak hours. When fraud is detected, the transaction must be blocked before completion, and the fraud team must be notified with full context. The system must continuously learn from new fraud patterns.

A) Use Amazon Kinesis Data Streams for transaction ingestion, invoke Lambda for each transaction to call an Amazon SageMaker real-time inference endpoint for fraud scoring, store results in DynamoDB, and use SNS for fraud team notifications. Retrain the model weekly using SageMaker Pipelines.
B) Use Amazon API Gateway synchronous integration with a Lambda function that calls SageMaker real-time inference. Store transaction features in ElastiCache for historical pattern lookups. Use EventBridge for fraud notifications. Implement SageMaker Model Monitor for drift detection and automated retraining.
C) Use Amazon MSK for transaction streaming, Amazon Managed Service for Apache Flink for real-time pattern analysis against a feature store in ElastiCache, combined with SageMaker real-time inference for ML-based scoring. Use DynamoDB for fraud rules. SNS for notifications.
D) Process transactions through API Gateway to Lambda, which performs rule-based checks against DynamoDB fraud rules and calls Amazon Bedrock for AI-based fraud analysis. Store patterns in Neptune for graph-based fraud detection. EventBridge for notifications.

**Correct Answer: B**

**Explanation:** The 100-millisecond requirement means the fraud check must be synchronous and in the transaction path. API Gateway with Lambda provides a synchronous request-response flow. SageMaker real-time inference endpoints deliver single-digit millisecond predictions. ElastiCache provides sub-millisecond lookups for historical features (user spending patterns, location history). The combined latency stays well within 100ms. SageMaker Model Monitor detects model drift, and automated retraining with Pipelines ensures the system learns from new fraud patterns. Option A's Kinesis is asynchronous — by the time fraud is detected, the transaction may already be complete. Option C's MSK+Flink is designed for stream processing, not synchronous transaction blocking. Option D's Bedrock has higher latency than a purpose-trained SageMaker model for this specific use case.

---

### Question 29
A company is migrating their monolithic .NET application to AWS and wants to adopt a microservices architecture. The application handles order processing with the following requirements: orders must be processed exactly once, processing involves 7 sequential steps (validation, inventory check, payment, fulfillment, shipping, notification, analytics), each step may take 1-30 seconds, and failures at any step must trigger compensating transactions for all previously completed steps. The system handles 500 orders per minute during peak.

A) Use Amazon SQS FIFO queues between each microservice for exactly-once processing. Each service consumes from its input queue, processes, and publishes to the next queue. Implement dead-letter queues for failures and a separate compensation service that reverses completed steps.
B) Implement AWS Step Functions Standard Workflows with a state machine that orchestrates all 7 steps. Use the Saga pattern with Step Functions — each step has a corresponding compensation step. On failure, Step Functions executes compensation steps in reverse order. Use Lambda for each step.
C) Use Amazon EventBridge pipes to chain the 7 services together in sequence. Each service publishes a completion event that triggers the next. For failures, publish a failure event that triggers a reverse chain of compensation events.
D) Deploy the microservices on ECS Fargate with AWS App Mesh for service-to-service communication. Implement the Saga pattern within the application code using a choreography approach. Use DynamoDB for tracking transaction state.

**Correct Answer: B**

**Explanation:** Step Functions Standard Workflows are ideal for the Saga pattern implementation. They provide built-in state management, error handling, and compensation logic through Catch and Fallback states. The state machine explicitly defines each processing step and its corresponding compensation step. If step N fails, Step Functions automatically executes compensation steps N-1 through 1 in reverse order. Standard Workflows support executions up to 1 year with exactly-once execution semantics. At 500 orders/minute (8.3/second), Step Functions handles this comfortably. Option A's SQS chain makes compensation logic extremely complex — tracking which steps completed for an order across 7 queues is error-prone. Option C's EventBridge choreography makes it difficult to guarantee all compensations execute in order. Option D's application-level Saga requires significant custom code and is harder to debug and maintain.

---

### Question 30
A company needs to serve dynamic web content with extreme low latency (under 5ms TTFB) for users accessing data that changes every 30 seconds. The content is based on stock market data and must be identical for all users requesting the same stock symbol. The system serves 100,000 requests per second during market hours across North America and Europe. The data is generated by a backend in us-east-1.

A) Use CloudFront with a 30-second cache TTL and cache key based on the stock symbol path parameter. Enable Origin Shield in us-east-1 to reduce origin load. Use Lambda@Edge origin-request to fetch fresh data when cache misses occur.
B) Use CloudFront with real-time log monitoring and cache invalidation. Backend publishes updates every 30 seconds and triggers CloudFront cache invalidation for changed stock symbols. Set a long TTL (1 hour) to maximize cache hits.
C) Use Global Accelerator to route traffic to the nearest ALB endpoint in multiple regions. Deploy the application in three regions with ElastiCache Redis for caching stock data with 30-second TTL. Backend publishes updates to all regions via SNS.
D) Use CloudFront with a TTL of 25 seconds (slightly less than update interval) and stale-while-revalidate behavior. Cache key based on stock symbol. Enable Origin Shield. Use S3 as origin with the backend writing updated JSON files to S3 every 30 seconds.

**Correct Answer: D**

**Explanation:** This approach achieves sub-5ms TTFB through CloudFront edge caching. Setting the TTL to 25 seconds ensures content is usually served from cache during the 30-second update cycle. Using S3 as the origin simplifies the architecture — the backend writes pre-generated JSON to S3 every 30 seconds, and CloudFront serves it from edge cache. Since all users requesting the same stock symbol get identical content, the cache hit ratio is extremely high. Origin Shield reduces S3 load by providing a centralized cache layer. The 5ms TTFB target is achievable because CloudFront edge POPs serve cached content in 1-3ms. Option A's Lambda@Edge adds latency for cache misses. Option B's invalidation approach has propagation delays and is expensive at scale. Option C doesn't achieve sub-5ms because even ElastiCache requires network round trips from the edge.

---

### Question 31
A company is designing a multi-tenant application where each tenant's data must be encrypted with a unique KMS key. The application has 5,000 tenants and expects to grow to 50,000. Each tenant generates approximately 1,000 API requests per second that require data encryption/decryption. The KMS cost and request throttling limits must be managed. The solution must allow tenants to optionally bring their own KMS keys (BYOK).

A) Create one KMS key per tenant in the application's AWS account. Use KMS key grants to control access per tenant. Implement data key caching in the application using the AWS Encryption SDK with a 5-minute cache TTL to reduce KMS API calls.
B) Create one KMS key per tenant. Use KMS key policies for access control. Implement envelope encryption where KMS generates data encryption keys (DEKs), the application caches DEKs locally, and re-generates them hourly. For BYOK tenants, create KMS keys with imported key material.
C) Use a single KMS key with encryption context containing the tenant ID. KMS logs the encryption context for audit purposes. Implement data key caching with the AWS Encryption SDK. For BYOK tenants, create separate KMS keys with imported key material.
D) Create KMS keys in each tenant's own AWS account for maximum isolation. Use cross-account key access via key policies. Implement the AWS Encryption SDK with data key caching. For tenants without AWS accounts, create keys in a shared account.

**Correct Answer: B**

**Explanation:** One KMS key per tenant provides the required encryption isolation. Envelope encryption with locally cached DEKs is critical for managing KMS costs and staying within request limits — at 5,000 tenants × 1,000 req/s, direct KMS calls would be 5 million req/s, far exceeding KMS limits. With envelope encryption, the application calls KMS only to generate/decrypt DEKs, then uses the cached DEK for data operations locally. Hourly DEK rotation balances security with cost. For BYOK, KMS supports importing customer key material into CMKs. Option A's key grants add complexity; the main issue is that 50,000 keys may hit KMS per-account key limits (needs key limit increases). Option C using a single key with encryption context doesn't provide per-tenant key isolation as required. Option D requiring cross-account access for every tenant is operationally complex at 50,000 tenants.

---

### Question 32
A ride-sharing company needs to design their matching system that pairs riders with nearby drivers. The system must process 100,000 ride requests per minute during peak hours in a metropolitan area. For each request, the system must find the 5 nearest available drivers within a 5 km radius, calculate ETAs using real-time traffic data, and send match offers to drivers within 3 seconds of the ride request. Drivers have 15 seconds to accept. If no driver accepts, the system re-matches.

A) Use API Gateway to receive ride requests, Lambda to query DynamoDB with geo-hashing for nearby drivers, a second Lambda to calculate ETAs via a third-party traffic API, and SQS to manage driver notification queues. Step Functions orchestrates the matching cycle.
B) Use API Gateway WebSocket API for real-time rider and driver connections. ElastiCache Redis with geospatial commands (GEOADD, GEORADIUS) for driver location indexing. Lambda processes match logic, calls an ETA service on ECS Fargate, and pushes offers via WebSocket. Use Step Functions Express Workflows for the match-accept-retry cycle.
C) Use Amazon Location Service for geospatial queries and route calculations. Kinesis Data Streams for ride request ingestion. ECS Fargate services for matching logic. DynamoDB for driver state management. SNS for push notifications to drivers.
D) Use AppSync with real-time subscriptions for rider-driver communication. Neptune graph database for spatial queries on driver locations. Lambda resolvers for match logic. Step Functions for the matching workflow.

**Correct Answer: B**

**Explanation:** This architecture optimizes for the 3-second matching requirement. WebSocket connections enable instant bidirectional communication with riders and drivers. ElastiCache Redis geospatial commands (GEORADIUS) find nearby drivers in sub-millisecond time, crucial for the 3-second SLA. The ETA service on Fargate provides consistent performance for route calculations. Step Functions Express Workflows (synchronous, up to 5 minutes) efficiently orchestrate the match-offer-accept-retry cycle with built-in timeout handling for the 15-second driver response window. Option A's SQS introduces unnecessary latency for time-critical driver notifications. Option C's Kinesis adds batching latency inappropriate for a 3-second SLA. Option D's Neptune is not optimized for simple geospatial proximity queries compared to Redis.

---

### Question 33
A news organization needs to design a system that automatically generates article summaries, translations into 10 languages, and audio narrations for every published article. Articles are published at a rate of 200 per day with occasional bursts of 50 articles in 10 minutes during breaking news. Each article must have all 12 assets (1 summary + 10 translations + 1 audio) generated within 15 minutes of publication. The system must be cost-effective during quiet periods and scale during breaking news.

A) Use S3 event notifications on article uploads to trigger a Step Functions workflow. The workflow first generates a summary using Amazon Bedrock, then fans out 10 parallel Lambda functions for translations using Amazon Translate, and finally generates audio using Amazon Polly. Store all assets in S3.
B) Use EventBridge to trigger processing on article publication. Lambda functions call Amazon Bedrock for summaries and translations, and Amazon Polly for audio. Use SQS to buffer requests during bursts. Store assets in S3.
C) Deploy a continuously running ECS Fargate service that polls for new articles, processes them sequentially through Bedrock for summaries, Translate for translations, and Polly for audio. Use auto-scaling based on queue depth.
D) Use S3 event notifications to trigger Lambda, which publishes to SNS. Three SQS queues subscribe (summary, translation, audio). Separate Lambda functions process each queue: Bedrock for summaries, Translate for translations, Polly for audio. Translations wait for summary completion via a DynamoDB flag.

**Correct Answer: A**

**Explanation:** Step Functions provides clean orchestration of the sequential-then-parallel workflow. The summary must be generated first (it's used for translations), then translations and audio generation run in parallel. Step Functions' Map state handles the 10 parallel translations efficiently. The 15-minute SLA is achievable: Bedrock summary (~10s) + parallel translations (~30s each, but concurrent) + Polly audio (~60s) = well within 15 minutes. Step Functions is serverless and scales to zero during quiet periods. Option B's Lambda-only approach requires custom orchestration for the sequential-then-parallel pattern. Option C's always-running Fargate is not cost-effective during quiet periods. Option D's SQS-based choreography makes the dependency between summary and translation harder to manage reliably.

---

### Question 34
A financial services company needs to implement a document processing system that handles loan applications. Each application package contains 10-50 pages including identification documents, financial statements, tax returns, and bank statements. The system must extract structured data from these documents, classify each page by document type, verify the applicant's identity against the ID document, and flag any inconsistencies. The system processes 10,000 applications per day with a 2-hour SLA.

A) Use Amazon Textract for document extraction with AnalyzeDocument API for forms and tables. Amazon Comprehend for document classification. Amazon Rekognition for identity verification by comparing the ID photo to a selfie. Step Functions orchestrates the pipeline. Store extracted data in DynamoDB.
B) Use Amazon Textract with AnalyzeLending API (purpose-built for lending documents) for extraction and classification. Amazon Rekognition for identity verification. Amazon Bedrock for inconsistency detection by analyzing extracted data against business rules. Step Functions Distributed Map for parallel processing of pages.
C) Use Amazon Textract for OCR, custom ML models on SageMaker for document classification, and Amazon Rekognition for ID verification. Build inconsistency detection rules in Lambda. Use SQS for pipeline orchestration.
D) Use Amazon Bedrock multimodal capabilities to process all document pages, extract data, classify documents, and detect inconsistencies in a single prompt. Use Amazon Rekognition for identity verification. Trigger processing via S3 events.

**Correct Answer: B**

**Explanation:** Amazon Textract's AnalyzeLending API is purpose-built for processing lending document packages — it automatically classifies common lending documents (pay stubs, bank statements, tax forms, etc.) and extracts relevant fields without custom training. Step Functions Distributed Map processes the 10-50 pages per application in parallel, maximizing throughput. Amazon Bedrock excels at analyzing extracted structured data for inconsistencies (e.g., income on tax return vs. financial statement). Rekognition handles identity verification. At 10,000 applications/day (~7/minute), this architecture handles the load within the 2-hour SLA easily. Option A uses the generic Textract API instead of the specialized lending API. Option C requires training custom classification models unnecessarily. Option D relies too heavily on Bedrock for structured data extraction where Textract is more accurate and cost-effective.

---

### Question 35
A company wants to implement a real-time recommendation engine for their e-commerce platform that serves 10 million monthly active users. The system must provide personalized product recommendations within 50 milliseconds, handle a catalog of 5 million products, update recommendations based on user behavior within 5 minutes, and support A/B testing of recommendation algorithms. The solution must be fully managed with minimal operational overhead.

A) Use Amazon Personalize for the recommendation engine with real-time events API for behavior tracking. Deploy Personalize campaigns with auto-scaling for real-time inference. Use Amazon Personalize's built-in A/B testing support. Cache frequent recommendations in ElastiCache.
B) Train a custom recommendation model on SageMaker, deploy it to SageMaker real-time endpoints with auto-scaling. Use Kinesis Data Streams to ingest user events and Lambda to update user profiles in DynamoDB. Implement A/B testing using API Gateway canary deployments.
C) Use Amazon OpenSearch Service with Learning to Rank (LTR) plugin for recommendations. Index products and user behavior. Use OpenSearch k-NN for similarity-based recommendations. Implement A/B testing with feature flags.
D) Use Amazon Neptune for a product knowledge graph with collaborative filtering queries. Cache results in ElastiCache with 5-minute TTL. Use Lambda for serving recommendations. A/B testing via CloudFront header-based routing to different Lambda versions.

**Correct Answer: A**

**Explanation:** Amazon Personalize is the fully managed recommendation service that directly addresses all requirements. It handles model training, real-time inference, and behavioral data ingestion natively. The PutEvents API updates user behavior in near-real-time, enabling the 5-minute recommendation freshness requirement. Personalize campaigns auto-scale to handle traffic and deliver sub-50ms latency. Built-in A/B testing support through campaign configuration simplifies experimentation. ElastiCache for frequently requested recommendations reduces latency further. Option B requires significant operational overhead for custom ML pipeline management. Option C's OpenSearch LTR requires manual model training and feature engineering. Option D's Neptune graph queries are slower than purpose-built recommendation inference.

---

### Question 36
An autonomous vehicle company needs to design a system to collect, process, and analyze telemetry data from 10,000 test vehicles. Each vehicle generates 500 MB of sensor data per hour including LiDAR point clouds, camera feeds, GPS, and vehicle diagnostics. The company needs to: store raw data for 5 years, process data within 2 hours of collection for safety analysis, run weekly batch ML training jobs on the full dataset, and provide interactive analytics for engineers querying specific vehicle data.

A) Use AWS IoT Greengrass on vehicles for edge preprocessing and compression. Upload to S3 via AWS Transfer Family when vehicles return to base. Use AWS Glue for ETL processing, SageMaker for ML training, and Athena for interactive queries. Lifecycle policies move data to Glacier after 6 months.
B) Stream data via Kinesis Data Streams from vehicles over cellular to S3. Use EMR for real-time processing and safety analysis. SageMaker for weekly training. Amazon Redshift Serverless for interactive analytics. S3 Intelligent-Tiering for lifecycle management.
C) Use IoT Greengrass on vehicles for local buffering and prioritization. Upload to S3 via S3 Transfer Acceleration when cellular is available. Use Step Functions with Lambda for safety-critical processing within 2 hours. SageMaker for ML training. Athena with Apache Iceberg tables for interactive analytics. S3 lifecycle to Glacier Deep Archive after 1 year.
D) Use AWS Snowball Edge devices in vehicles for local storage and compute. Periodically ship Snowball devices to AWS for data import. Use EMR for processing, SageMaker for ML, and Redshift for analytics.

**Correct Answer: C**

**Explanation:** At 500 MB/hour per vehicle, the total data rate is 5 TB/hour. IoT Greengrass handles edge preprocessing (filtering, compression, prioritization) to reduce upload volume. S3 Transfer Acceleration optimizes uploads over variable cellular connections. Step Functions with Lambda for safety processing ensures the 2-hour SLA with serverless scalability. SageMaker handles weekly batch training on S3 data directly. Athena with Apache Iceberg provides interactive analytics with time-travel capabilities useful for debugging vehicle behavior. S3 lifecycle to Glacier Deep Archive after 1 year optimizes the 5-year retention cost. Option A's Transfer Family assumes vehicles return to base, which may not be frequent enough for 2-hour processing. Option B's Kinesis streaming over cellular for 5 TB/hour is impractical and expensive. Option D's Snowball shipping introduces days of latency, violating the 2-hour processing requirement.

---

### Question 37
A global social media company is designing a content moderation system for user-generated images and videos. The system must process 50,000 uploads per hour, detect inappropriate content (nudity, violence, hate symbols), identify copyrighted material, and provide moderation decisions within 30 seconds of upload. Human reviewers must be able to override automated decisions. The system must maintain an audit trail of all moderation decisions for legal compliance.

A) Use S3 event triggers to invoke Lambda for image moderation using Amazon Rekognition Content Moderation. For videos, use Rekognition Video with start/get async APIs. Use Amazon Augmented AI (A2I) for human review workflows. Store decisions in DynamoDB with DynamoDB Streams to EventBridge for audit logging in S3.
B) Use SQS to queue uploads, process with ECS Fargate tasks calling Rekognition for content moderation and a custom TensorFlow model on SageMaker for copyright detection. Implement a human review portal on EC2. Store audit trail in Aurora.
C) Use S3 event triggers to invoke Step Functions. Parallel states call Rekognition Content Moderation for inappropriate content, a SageMaker endpoint for copyright detection using perceptual hashing, and Amazon Comprehend for text-in-image analysis. Use Amazon A2I for human review with custom task templates. CloudTrail and DynamoDB for audit trail.
D) Use Amazon Bedrock multimodal models to analyze uploads for all content policy violations in a single inference call. Queue results for human review via SQS. Store decisions in S3 with Lambda-generated audit logs.

**Correct Answer: C**

**Explanation:** Step Functions orchestrates parallel moderation checks efficiently — Rekognition Content Moderation for inappropriate content, a SageMaker endpoint with perceptual hashing for copyright detection (a proven technique for matching against known copyrighted content), and Comprehend for text extraction from images. Parallel execution ensures the 30-second SLA is met. Amazon A2I (Augmented AI) is purpose-built for human review workflows with customizable task templates, workforce management, and decision tracking. DynamoDB provides the structured audit trail, while CloudTrail captures API-level audit data. Option A doesn't address copyright detection. Option B's custom human review portal is unnecessary operational overhead when A2I exists. Option D's Bedrock approach lacks the reliability of purpose-built content moderation APIs and doesn't address copyright detection.

---

### Question 38
A company is building a serverless event-driven architecture for their order management system. Events include OrderCreated, OrderPaid, OrderShipped, and OrderDelivered. Multiple downstream consumers need to react to these events: inventory system, analytics, customer notifications, and fraud detection. Each consumer needs different subsets of events, and the system must guarantee at-least-once delivery with ordering per order ID. The system must handle 5,000 events per second during peak.

A) Use Amazon EventBridge with event rules to route events to different consumers based on event type. Each consumer has its own SQS queue as a target. Use EventBridge archive and replay for failure recovery.
B) Use Amazon SNS with message filtering policies for each subscriber. Subscribers include SQS queues for each consumer. Enable SNS message deduplication and ordering using SNS FIFO topics with SQS FIFO queues as subscribers.
C) Use Amazon Kinesis Data Streams with enhanced fan-out for each consumer. Use partition key based on order ID for ordering. Each consumer has a dedicated enhanced fan-out consumer with its own read throughput.
D) Use Amazon MSK (Kafka) with topics per event type. Consumer groups for each downstream system subscribe to relevant topics. Kafka's partition-based ordering with order ID as the partition key ensures ordering.

**Correct Answer: B**

**Explanation:** SNS FIFO topics with SQS FIFO queues provide the optimal combination of message filtering, ordering, and at-least-once delivery. SNS message filtering policies allow each consumer to subscribe only to relevant event types without custom routing logic. SNS FIFO topics maintain ordering per message group ID (order ID), and SQS FIFO queues preserve this ordering for consumers. At 5,000 events/second, SNS FIFO supports up to 6,000 publishes/second per topic (with batching, up to 60,000). Option A's EventBridge doesn't provide ordering guarantees per order ID. Option C's Kinesis provides ordering but doesn't natively filter events for different consumers — each consumer must filter unwanted events. Option D's MSK is operationally heavy for what SNS FIFO handles natively.

---

### Question 39
A healthcare company is designing a telemedicine platform that supports real-time video consultations between doctors and patients. The platform must support 10,000 concurrent video sessions, comply with HIPAA requirements, record all sessions for medical records with consent, integrate with the existing patient record system (running on-premises), and provide screen sharing for reviewing medical images. The latency for video must be under 200 milliseconds.

A) Use Amazon Chime SDK for video sessions with HIPAA-eligible configuration. Record sessions to S3 using Chime SDK media capture. Connect to on-premises systems via AWS Direct Connect and VPN. Store recordings encrypted with KMS in S3 with Object Lock for retention compliance.
B) Use Amazon IVS (Interactive Video Service) for real-time video. Record to S3 via IVS recording configuration. Use API Gateway to integrate with on-premises systems via VPN. Encrypt recordings with KMS.
C) Build a custom WebRTC solution on EC2 with TURN/STUN servers. Use S3 for recording storage. Connect to on-premises via Direct Connect. Implement custom encryption for HIPAA compliance.
D) Use Amazon Kinesis Video Streams for bidirectional video. Use WebRTC with Kinesis Video Streams signaling channels. Record to S3 using Kinesis Video Streams. Connect to on-premises via Site-to-Site VPN.

**Correct Answer: A**

**Explanation:** Amazon Chime SDK is the purpose-built service for embedding real-time video communications in applications. It's HIPAA-eligible, supports 10,000+ concurrent sessions, provides sub-200ms latency, and includes screen sharing capabilities natively. Media capture pipelines record sessions to S3. The Chime SDK handles the complexity of WebRTC (TURN/STUN, session management, codec negotiation) as a managed service. Direct Connect provides reliable, low-latency connectivity to on-premises patient record systems. KMS encryption and S3 Object Lock ensure HIPAA-compliant recording storage. Option B's IVS is designed for one-to-many broadcasting, not bidirectional consultations. Option C's custom WebRTC is extremely complex to build and maintain at scale. Option D's Kinesis Video Streams is designed for device-to-cloud video ingestion, not bidirectional real-time video.

---

### Question 40
A company wants to design a multi-region active-active architecture for their customer-facing API. The API has both read and write operations. Writes must be conflict-free and eventually consistent across regions within 2 seconds. Reads must be strongly consistent within a region. The API handles 50,000 requests per second across two regions (us-east-1 and eu-west-1). Data size is 500 GB. The solution must handle a full regional failure with automatic failover and zero data loss.

A) Use DynamoDB Global Tables in both regions for data storage. API Gateway with Regional endpoints in each region behind Route 53 latency-based routing. DynamoDB Global Tables handles cross-region replication with conflict resolution using last-writer-wins. Strongly consistent reads within each region.
B) Use Aurora Global Database with write forwarding enabled. API Gateway in both regions behind Global Accelerator. Writes in the secondary region are forwarded to the primary. Use read replicas for strongly consistent reads. On primary failure, promote the secondary.
C) Use Amazon ElastiCache Global Datastore with Redis in both regions for low-latency reads and writes. S3 Cross-Region Replication for durable storage. API Gateway behind Route 53.
D) Use CockroachDB on EC2 across both regions for globally consistent reads and writes. API Gateway behind Global Accelerator. CockroachDB handles multi-region consensus automatically.

**Correct Answer: A**

**Explanation:** DynamoDB Global Tables provide active-active multi-region replication with sub-second replication latency (meeting the 2-second requirement). Global Tables handle write conflicts using last-writer-wins reconciliation, making writes conflict-free. Strongly consistent reads are available within each region (reading from the local replica). At 50,000 req/s across two regions, DynamoDB's on-demand capacity scales seamlessly. Regional failures are handled automatically — traffic is routed to the healthy region via Route 53. Zero data loss is achieved because writes replicated before failure are preserved, and the last-writer-wins resolution ensures consistency post-failover. Option B's Aurora Global Database doesn't support active-active writes (write forwarding still goes to one primary). Option C's ElastiCache isn't designed as a primary database and doesn't guarantee durability. Option D requires managing database infrastructure on EC2.

---

### Question 41
A company is designing a data pipeline that must process 10 TB of raw clickstream data daily. The pipeline must enrich the data with user profile information from a PostgreSQL database, deduplicate events, aggregate by session, and produce analytics-ready datasets. Processing must complete within a 4-hour batch window. The pipeline runs daily and must handle late-arriving data (up to 2 hours late). The team has limited Spark expertise.

A) Use AWS Glue with Spark ETL jobs for data transformation. Use Glue DynamicFrames for schema flexibility. Glue bookmarks for incremental processing. Glue Crawlers to maintain the Data Catalog. Store results in S3 in Parquet format partitioned by date.
B) Use AWS Glue with PySpark jobs for the main transformations. Use Glue's JDBC connection for PostgreSQL enrichment. Implement deduplication using Glue's ResolveChoice and DropDuplicates transforms. Schedule daily with Glue Workflows including a 2-hour delay job for late data reprocessing. Output to S3 as Iceberg tables.
C) Use Amazon EMR Serverless with Spark for processing. Read from S3, enrich from RDS PostgreSQL via JDBC, deduplicate and aggregate using Spark SQL. Handle late-arriving data with Apache Hudi's incremental processing. Store results in S3 with Hudi table format.
D) Use Amazon Redshift Serverless with COPY commands to load raw data, use Redshift Federated Queries for PostgreSQL enrichment, and SQL-based transformations for deduplication and aggregation. Use Redshift Spectrum for querying results in S3.

**Correct Answer: B**

**Explanation:** AWS Glue provides the managed Spark environment with the least operational overhead, ideal for a team with limited Spark expertise. Glue's visual ETL editor and PySpark integration simplify development. The JDBC connection to PostgreSQL enables profile enrichment. Glue Workflows orchestrate the daily pipeline with built-in retry and scheduling. The 2-hour delay job for late data reprocessing handles late-arriving events. Iceberg table format on S3 supports upserts for late data integration and provides ACID transactions. At 10 TB daily within 4 hours, Glue's auto-scaling worker allocation handles the volume. Option A's approach is similar but doesn't address late-arriving data handling. Option C's EMR Serverless works but has higher operational complexity for a team with limited Spark skills. Option D's Redshift approach requires loading all data into Redshift, adding cost and complexity.

---

### Question 42
A company needs to implement a search system for their e-commerce platform with 50 million products. The search must support full-text search with typo tolerance, faceted navigation (filter by category, brand, price range), autocomplete suggestions with sub-50ms latency, and personalized search ranking based on user behavior. The system must handle 10,000 search queries per second during peak and index updates must be reflected within 30 seconds.

A) Use Amazon OpenSearch Service with a multi-node cluster. Use OpenSearch's fuzzy matching for typo tolerance, aggregations for faceted navigation, and a completion suggester for autocomplete. Implement Learning to Rank plugin for personalized ranking. Use OpenSearch's near-real-time indexing for 30-second update visibility.
B) Use Amazon Kendra for enterprise search with semantic understanding. Use Kendra's built-in faceting and relevance tuning. Implement custom tokenizers for autocomplete. Use Kendra's relevance feedback for personalization.
C) Use Amazon CloudSearch for full-text search with autocomplete. Use CloudSearch's facet feature for navigation. Implement personalization by boosting query terms based on user profile data from DynamoDB.
D) Use Amazon DynamoDB with a full-text search GSI for search queries. Implement autocomplete using DynamoDB Accelerator (DAX) for prefix matching. Use DynamoDB Streams to update search indexes.

**Correct Answer: A**

**Explanation:** Amazon OpenSearch Service is the optimal choice for e-commerce search at this scale. Its fuzzy matching handles typos, aggregations power faceted navigation, and the completion suggester provides sub-50ms autocomplete. The Learning to Rank (LTR) plugin enables ML-based personalized ranking by incorporating user behavior features. Near-real-time indexing (configurable refresh interval) achieves the 30-second update requirement. A properly sized OpenSearch cluster handles 10,000 queries/second. Option B's Kendra is designed for enterprise document search, not e-commerce product search at this scale and query rate. Option C's CloudSearch has limited customization and no ML-based ranking. Option D's DynamoDB is not designed for full-text search, typo tolerance, or faceted navigation.

---

## Domain 3: Continuous Improvement for Existing Solutions (Questions 43–53)

### Question 43
A company has an existing CloudFront distribution serving a web application with an ALB origin. During a major sale event, the origin returned 503 errors for 15 minutes due to backend overload, and CloudFront served these error responses to all users. Even after the backend recovered, cached 503 responses continued to be served for the remaining TTL (5 minutes). The company wants to prevent this scenario in future events.

A) Implement CloudFront origin failover with an origin group. Configure the primary origin (ALB) and a secondary origin (S3 static maintenance page). CloudFront automatically fails over to S3 when the ALB returns 5xx errors. Also configure custom error responses with a short TTL (10 seconds) for 503 errors.
B) Add a CloudFront Function at viewer-response to detect 503 status codes and modify the Cache-Control header to no-cache, preventing CloudFront from caching error responses.
C) Enable Origin Shield and increase the origin connection timeout and read timeout values. Add retry logic using Lambda@Edge at origin-request to retry failed requests up to 3 times before returning an error.
D) Configure CloudFront to use multiple ALB origins with weighted distribution. If one ALB becomes unhealthy, CloudFront distributes traffic to the remaining healthy ALBs.

**Correct Answer: A**

**Explanation:** This is a two-part solution addressing both the origin failure and the cached error problem. Origin failover with an origin group ensures users see a meaningful maintenance page instead of raw 503 errors when the ALB is overwhelmed. The custom error response configuration with a short TTL (10 seconds) for 503 errors prevents long-lived cached errors — even if a 503 is cached, it expires quickly and CloudFront retries the origin. This combination prevents both serving error pages and caching them for too long. Option B's CloudFront Function at viewer-response cannot reliably prevent upstream caching decisions. Option C's retry logic at Lambda@Edge would increase load on an already overwhelmed origin. Option D's weighted distribution isn't how CloudFront origins work and doesn't address the cached error problem.

---

### Question 44
A company's Auto Scaling group for their web application frequently launches instances that fail health checks and are terminated within 2 minutes, creating a cycle of launch-fail-terminate. The launch template uses a custom AMI with a user data script that installs application dependencies and starts the service. CloudWatch shows CPU spikes to 100% during instance initialization. The team needs to stabilize the scaling behavior and reduce the initialization time.

A) Increase the health check grace period to 10 minutes. Switch to ELB health checks. Implement a warm pool with pre-initialized instances in the Stopped state. Update the launch template to use an AMI with dependencies pre-baked using EC2 Image Builder.
B) Add a lifecycle hook at instance launch that pauses the instance in Pending:Wait state. Use Systems Manager Run Command to complete initialization during the hook. Send a CompleteLifecycleAction signal when the application is healthy. Use predictive scaling to pre-launch instances before demand spikes.
C) Switch to Elastic Beanstalk with rolling updates. Beanstalk manages health checks and instance initialization automatically. Enable enhanced health reporting for detailed instance status.
D) Increase the instance type to one with more CPU. Extend the cooldown period to 10 minutes to prevent rapid scaling. Add an SNS notification on launch failures for manual investigation.

**Correct Answer: A**

**Explanation:** The root cause is that instances fail health checks before initialization completes (the health check grace period is too short). The fix combines several improvements: increasing the health check grace period prevents premature termination of initializing instances. Pre-baking dependencies into the AMI via EC2 Image Builder eliminates the CPU-intensive installation during user data execution, dramatically reducing initialization time. A warm pool with pre-initialized Stopped instances means scaling events simply start already-configured instances, achieving near-instant readiness. ELB health checks are more application-aware than EC2 status checks. Option B's lifecycle hooks add complexity and SSM Run Command for initialization is slower than pre-baked AMIs. Option C's Elastic Beanstalk migration is a major change for an operational issue. Option D's larger instances and longer cooldowns don't address the root cause.

---

### Question 45
A company's S3-based data lake has grown to 50 PB over 3 years. The data engineering team reports that Athena queries on recent data (last 30 days) are fast, but queries spanning historical data take over 30 minutes and frequently time out. The data is stored as Parquet files partitioned by date but with inconsistent file sizes (ranging from 1 KB to 5 GB). The team needs to improve query performance across all time ranges without re-ingesting all historical data.

A) Migrate the data lake to Apache Iceberg table format using Athena CREATE TABLE AS SELECT. Implement Iceberg's compaction to normalize file sizes. Use Iceberg's hidden partitioning for automatic partition evolution. Schedule regular Iceberg OPTIMIZE operations.
B) Run AWS Glue ETL jobs to compact small files and split large files across the entire dataset, targeting 128 MB-1 GB file sizes. Add additional partition columns (year/month/day/hour) for finer granularity. Update the Glue Data Catalog.
C) Use Athena's CTAS (Create Table As Select) to create optimized copies of historical data with consistent file sizes and additional partitioning. Use partition projection to eliminate Glue Catalog overhead. For the 50 PB dataset, run CTAS incrementally by time range.
D) Move historical data to Amazon Redshift Spectrum external tables. Use Redshift's automatic materialized views for frequently accessed time ranges. Keep recent data in S3 with Athena.

**Correct Answer: C**

**Explanation:** For a 50 PB dataset, a practical approach is needed. Athena CTAS incrementally rewriting historical partitions to produce consistently sized Parquet files (targeting 128 MB-1 GB) dramatically improves scan performance. Partition projection eliminates the latency of querying the Glue Data Catalog for partition information (which becomes significant at this scale). Running CTAS by time range allows incremental optimization without processing all 50 PB at once. Option A's Iceberg migration for 50 PB is extremely time-consuming and expensive as a migration. Option B's Glue ETL across 50 PB is also impractical in a single operation and expensive. Option D splits the architecture unnecessarily and adds Redshift costs.

---

### Question 46
A company operates an API Gateway REST API that has grown to 200 resources with complex request/response transformations using Velocity templates. The API experiences cold start latency of 3-5 seconds for Lambda backends during traffic spikes after quiet periods. The development team also reports that deployments take 20 minutes and occasionally fail, requiring rollbacks. The company wants to reduce cold starts, speed up deployments, and improve reliability.

A) Migrate to API Gateway HTTP API for lower latency. Use Lambda provisioned concurrency for critical functions. Implement canary deployments for API Gateway stages. Use Lambda SnapStart for Java functions.
B) Keep API Gateway REST API but split into multiple smaller APIs by domain. Use Lambda provisioned concurrency with Application Auto Scaling for critical paths. Implement API Gateway canary release deployments. Use CloudFormation nested stacks for parallel deployment.
C) Replace API Gateway with Application Load Balancer and Lambda targets for lower latency. Use Lambda provisioned concurrency. Deploy using CodeDeploy with traffic shifting.
D) Migrate to Amazon ECS Fargate to eliminate cold starts entirely. Use API Gateway with VPC Link to the Fargate services. Implement blue-green deployments with CodeDeploy.

**Correct Answer: B**

**Explanation:** Splitting the monolithic 200-resource API into smaller domain-specific APIs reduces deployment size and time, and limits the blast radius of failed deployments. Lambda provisioned concurrency with Application Auto Scaling maintains warm instances during quiet periods, eliminating cold starts for critical paths. API Gateway canary deployments send a percentage of traffic to the new version, enabling safe rollouts with automatic rollback on errors. CloudFormation nested stacks parallelize the deployment of multiple smaller APIs. Option A's HTTP API doesn't support Velocity templates, requiring migration of all request/response transformations. Option C's ALB doesn't support the complex transformations currently using Velocity templates. Option D's full migration to Fargate is a major architectural change that goes beyond addressing the stated problems.

---

### Question 47
A company's existing Route 53 configuration has 50 alias records pointing to various AWS resources (ALBs, CloudFront distributions, S3 website endpoints). During a recent incident, a developer accidentally deleted a critical alias record, causing a 2-hour outage. The company wants to prevent accidental DNS changes, implement change auditing, and enable quick recovery from accidental modifications.

A) Enable Route 53 Resolver DNS Firewall to protect DNS records. Implement IAM policies restricting Route 53 ChangeResourceRecordSets to a specific CI/CD pipeline role. Use CloudTrail for audit logging.
B) Use Route 53 hosted zone versioning to maintain a history of all record changes. Enable IAM policies to restrict direct changes. Implement CloudTrail with CloudWatch alarms for unauthorized DNS changes.
C) Implement IAM policies restricting Route 53 change operations to a specific IAM role used by the CI/CD pipeline. Enable CloudTrail logging for Route 53 API calls. Use Route 53 change batches exported to S3 as backups. Create a Lambda function triggered by CloudTrail events to detect deletions and automatically restore records from the backup.
D) Manage all Route 53 records via CloudFormation with stack termination protection and stack policies that deny Delete and Replace operations on DNS records. Restrict direct Route 53 API access via IAM. Use CloudFormation drift detection for change auditing.

**Correct Answer: D**

**Explanation:** Managing Route 53 records through CloudFormation with stack termination protection prevents accidental stack deletion. Stack policies can explicitly deny Delete and Replace operations on specific resources, preventing accidental record deletions even through CloudFormation updates. Restricting direct Route 53 API access via IAM forces all changes through CloudFormation, creating an audit trail. CloudFormation drift detection alerts on out-of-band changes. For recovery, CloudFormation can easily restore records by re-deploying the stack. Option A's DNS Firewall is for filtering DNS queries, not protecting DNS records. Option B's hosted zone versioning doesn't exist as a Route 53 feature. Option C works but is more complex and relies on custom backup/restore logic.

---

### Question 48
A company has 100 Auto Scaling groups across their production environment. During a cost review, they discover that many ASGs maintain more capacity than needed because minimum and maximum values were set conservatively when first configured and never adjusted. The team needs a data-driven approach to right-size ASG configurations while maintaining the ability to handle traffic spikes.

A) Use AWS Compute Optimizer to analyze ASG utilization patterns and implement recommended instance type and count changes. Enable predictive scaling on each ASG to automatically adjust capacity ahead of demand. Set target tracking scaling policies at 70% CPU.
B) Implement a custom Lambda function that analyzes CloudWatch metrics for each ASG (CPU, network, request count) over the past 30 days, calculates optimal min/max/desired values, and updates ASG configurations. Run weekly.
C) Use AWS Trusted Advisor to identify underutilized ASGs. Manually review and adjust min/max values based on Trusted Advisor recommendations. Set up CloudWatch alarms for high utilization to alert when adjustments are needed.
D) Migrate all ASGs to use AWS Fargate with auto-scaling, eliminating the need to manage minimum and maximum capacity settings. Fargate scales tasks based on demand without pre-provisioned capacity.

**Correct Answer: A**

**Explanation:** AWS Compute Optimizer analyzes historical utilization data (CPU, memory, network) and provides data-driven recommendations for right-sizing ASGs, including optimal instance types and counts. Predictive scaling uses ML to analyze historical patterns and proactively scale capacity before anticipated demand increases, reducing the need for conservative minimums. Target tracking at 70% CPU provides a balance between cost and headroom for spikes. This combination addresses both the over-provisioning (via Compute Optimizer) and the spike handling (via predictive scaling). Option B requires building and maintaining custom analytics. Option C's Trusted Advisor provides less detailed ASG-specific recommendations. Option D is an impractical migration of 100 ASGs and doesn't necessarily reduce costs.

---

### Question 49
A company's existing WAF configuration has 50 custom rules that have accumulated over 2 years. The security team suspects many rules are redundant or conflicting, causing legitimate requests to be blocked. They also notice that WAF evaluation adds 20ms of latency to every request. The team needs to optimize the WAF configuration without removing necessary security protections.

A) Enable WAF logging with Kinesis Data Firehose to S3. Use Athena to analyze which rules are triggering, identify redundant rules (rules that never match or always match the same requests as other rules), and identify false positives. Remove redundant rules and consolidate similar rules into single rules with OR conditions. Re-order remaining rules to put high-match-rate rules first with BLOCK action and Count rules last.
B) Replace all 50 custom rules with AWS Managed Rule Groups (Core Rule Set, Known Bad Inputs, etc.) that cover common attack vectors. Add specific custom rules only for application-specific logic that managed rules don't cover.
C) Use AWS WAF Bot Control and AWS WAF Fraud Control to replace custom bot detection and fraud rules. Consolidate remaining rules using rule group nesting. Enable rule labels for complex matching logic instead of multiple separate rules.
D) Create a new web ACL with only AWS Managed Rules. Deploy it alongside the existing web ACL using CloudFront's A/B testing. Compare block rates and false positive rates. Gradually migrate to the optimized configuration.

**Correct Answer: A**

**Explanation:** Data-driven optimization is the correct approach for cleaning up accumulated WAF rules. Analyzing WAF logs reveals: rules that never trigger (candidates for removal), rules that trigger on the same requests (redundant — keep one), rules blocking legitimate traffic (false positives — adjust or remove), and rule ordering opportunities (high-match BLOCK rules early short-circuit evaluation, reducing latency). The 20ms latency is likely due to sequential evaluation of 50 rules; reducing rule count and optimizing order directly reduces latency. Option B blindly replacing custom rules with managed rules risks removing application-specific protections. Option C assumes specific rule types without data analysis. Option D's A/B testing is useful but should come after data analysis, not instead of it.

---

### Question 50
A company has an existing S3 bucket receiving 10,000 PUT requests per second for log ingestion. They recently enabled S3 Event Notifications to trigger a Lambda function for real-time log processing. However, they're experiencing Lambda throttling and occasional event notification failures with no built-in retry mechanism for failed notifications. Some events are being lost. The system must process every log file without loss.

A) Replace S3 Event Notifications with S3 Event Notifications to SQS. Configure the SQS queue with a visibility timeout matching Lambda's maximum execution time, a dead-letter queue for persistent failures, and Lambda event source mapping with batch processing. Enable SQS long polling.
B) Replace S3 Event Notifications with EventBridge integration. Use EventBridge rules to route S3 events to an SQS queue, which triggers Lambda. EventBridge's built-in retry and dead-letter queue ensure no events are lost. Enable EventBridge archive for replay.
C) Increase Lambda reserved concurrency to handle 10,000 concurrent executions. Enable S3 Event Notification retry by configuring the S3 bucket notification with a failure destination (SQS dead-letter queue).
D) Replace the Lambda function with a Kinesis Data Firehose destination for S3 Event Notifications. Firehose buffers events and delivers to the processing Lambda in batches, smoothing the ingestion rate.

**Correct Answer: B**

**Explanation:** Amazon EventBridge integration with S3 provides reliable event delivery with built-in retry logic (up to 185 retries over 24 hours). EventBridge routes events to an SQS queue, which acts as a buffer and provides its own retry mechanism. Lambda event source mapping from SQS handles batch processing and automatic scaling. The dead-letter queue captures events that fail after all retries. EventBridge's archive feature allows replaying historical events for recovery. Option A's SQS destination works but S3 Event Notifications to SQS still has the same initial notification reliability concern. Option C doesn't solve the event notification reliability issue — S3 Event Notifications don't support failure destinations natively. Option D is incorrect because Kinesis Data Firehose is not a valid S3 Event Notification destination.

---

### Question 51
A company runs a web application behind CloudFront with an Auto Scaling group of EC2 instances. The application experiences a daily traffic pattern with a predictable 3x spike between 9 AM and 10 AM. Currently, the ASG uses target tracking scaling on CPU utilization (target 60%), but instances don't launch fast enough, causing degraded performance for 10-15 minutes every morning. The team also notices they're paying for instances that take 5 minutes to initialize before serving traffic.

A) Add a scheduled scaling action to increase the ASG desired capacity 15 minutes before the 9 AM spike. Combine with target tracking scaling for additional capacity if needed. Use warm pools with pre-initialized instances in the Running state.
B) Switch to predictive scaling, which uses ML to predict the daily pattern and scale proactively. Combine with target tracking as a fallback. Implement instance warm-up time in the scaling policy to prevent premature scale-in.
C) Replace EC2 with Lambda@Edge functions at CloudFront for handling the traffic spike. Lambda scales instantly and eliminates the instance initialization delay. Fall back to EC2 for baseline traffic.
D) Use step scaling with aggressive thresholds (scale out at 40% CPU with large step adjustments). Pre-bake the AMI to reduce initialization time. Add an ALB slow start configuration to gradually route traffic to new instances.

**Correct Answer: B**

**Explanation:** Predictive scaling is designed exactly for this scenario — it analyzes historical traffic patterns and proactively adjusts capacity before predicted demand increases. For a predictable daily 3x spike, predictive scaling learns the pattern and pre-launches instances before 9 AM. Combined with target tracking for unexpected variations, this provides both proactive and reactive scaling. Instance warm-up time configuration ensures new instances don't count toward the scaling metric until they're fully initialized, preventing premature scale-in of supporting instances. Option A's scheduled scaling works for a known pattern but is rigid and doesn't adapt to changing patterns. Option C's Lambda@Edge migration is overblown for a scaling issue. Option D's aggressive step scaling still reacts after the spike begins, not before.

---

### Question 52
A company operates a content delivery platform where each user's request is authenticated by a Lambda@Edge function at the viewer-request event. The Lambda function validates a JWT token against a user database in DynamoDB in us-east-1. During peak traffic, the Lambda@Edge function adds 50-200ms of latency due to DynamoDB lookups, and the team observes cold start latency of 500ms. The platform serves 100,000 requests per second. The team wants to reduce authentication latency to under 10ms.

A) Replace Lambda@Edge with CloudFront Functions for JWT validation. CloudFront Functions run in milliseconds with no cold starts. Store the JWT signing public key in CloudFront KeyValueStore for validation without DynamoDB lookups.
B) Implement JWT validation using CloudFront's built-in signed URL/signed cookie mechanism. Replace custom JWT tokens with CloudFront signed tokens. Eliminate Lambda@Edge entirely.
C) Add a DynamoDB Global Table replica in every CloudFront edge region to reduce DynamoDB read latency. Optimize the Lambda@Edge function with provisioned concurrency equivalent features using the Lambda function's configuration.
D) Cache validated JWT tokens in an ElastiCache Global Datastore cluster. Lambda@Edge checks ElastiCache first (sub-millisecond) and only queries DynamoDB on cache miss. Set cache TTL to match JWT expiry.

**Correct Answer: A**

**Explanation:** CloudFront Functions run at CloudFront edge locations with sub-millisecond execution time and no cold starts, making them ideal for lightweight authentication. JWT validation is a stateless operation — it requires only the signing public key to verify the token's signature and check its claims (expiry, audience, etc.). Storing the public key in CloudFront KeyValueStore eliminates DynamoDB lookups entirely. JWT tokens are self-contained, so validation doesn't require database access. At 100,000 req/s, CloudFront Functions handle the scale easily (they support millions of req/s). Option B requires changing the token mechanism which is a larger application change. Option C is incorrect — DynamoDB Global Tables don't deploy to CloudFront edge locations. Option D reduces but doesn't eliminate the DynamoDB dependency and Lambda@Edge latency.

---

### Question 53
A company has an existing multi-region Route 53 failover configuration with a primary site in us-east-1 and secondary in eu-west-1. During a recent failover test, they discovered that the failover took 5 minutes because the Route 53 health check had a 30-second interval, required 3 consecutive failures (90 seconds), and the DNS TTL was 300 seconds. Clients continued using cached DNS records pointing to the failed region. The company needs to reduce failover time to under 60 seconds.

A) Reduce the Route 53 health check interval to 10 seconds (fast health checks), reduce the failure threshold to 1, reduce the DNS record TTL to 10 seconds, and implement health check inversion for the secondary to ensure it only receives traffic during failover.
B) Replace Route 53 failover routing with AWS Global Accelerator. Global Accelerator performs health checks every 10 seconds and routes traffic based on health status without DNS caching issues. Maintain Route 53 for DNS resolution pointing to Global Accelerator's static IPs.
C) Keep Route 53 failover routing but add CloudFront in front with origin failover. CloudFront detects origin failures in real-time and fails over to the secondary origin without waiting for DNS changes.
D) Reduce health check interval to 10 seconds and failure threshold to 2. Set DNS TTL to 30 seconds. Add a CloudWatch alarm-based health check that evaluates the application's custom health metric every 10 seconds for faster failure detection.

**Correct Answer: B**

**Explanation:** The fundamental problem is DNS-based failover depends on client DNS caching, which cannot be fully controlled even with low TTLs (many clients ignore TTL). AWS Global Accelerator eliminates this issue because it uses anycast IP addresses — the same static IPs route to the nearest healthy endpoint via the AWS global network. Health checks run every 10 seconds, and failover happens at the network routing layer within seconds, not dependent on DNS cache expiry. This achieves under 60 seconds failover consistently. Option A reduces failover time but can't guarantee under 60 seconds because DNS caching is not fully controlled. Option C works for origin failover but requires the CloudFront distribution itself to remain accessible. Option D improves detection time but still suffers from DNS caching delays.

---

## Domain 4: Accelerate Workload Migration and Modernization (Questions 54–62)

### Question 54
A company is migrating a legacy application that uses multicast networking for cluster discovery and state synchronization. The application consists of 20 servers that communicate via multicast for heartbeat detection and data replication. The application cannot be modified, and the migration must maintain the multicast functionality. The company also needs the migrated application to communicate with on-premises resources over the existing AWS Direct Connect connection.

A) Deploy EC2 instances in a VPC with Transit Gateway multicast support. Create a multicast domain on Transit Gateway, register the ENIs of the EC2 instances as multicast group members. Connect the Transit Gateway to the Direct Connect gateway for on-premises connectivity.
B) Use an overlay network solution (e.g., Weave Net or Flannel) on EC2 instances to simulate multicast in unicast-only VPC networking. Connect to on-premises via VPN over Direct Connect.
C) Deploy the application on ECS Fargate with AWS Cloud Map for service discovery as a replacement for multicast-based discovery. Implement application-level replication instead of multicast state sync.
D) Use AWS Outposts in the on-premises data center to run the application without network changes, maintaining native multicast support through the on-premises network infrastructure.

**Correct Answer: A**

**Explanation:** AWS Transit Gateway supports multicast, making it the native AWS solution for applications requiring multicast networking. Transit Gateway multicast domains allow EC2 instances to send and receive multicast traffic. By registering instance ENIs as group members, the application's multicast-based cluster discovery and state synchronization work without modification. Transit Gateway also connects to Direct Connect gateways for on-premises connectivity. Option B's overlay network adds complexity and may not fully replicate native multicast behavior. Option C modifies the application, which violates the requirement. Option D avoids migration entirely and doesn't leverage cloud benefits.

---

### Question 55
A company is migrating their on-premises Hadoop cluster (500 TB data, 200 nodes) to AWS. The cluster runs a mix of Spark ETL jobs, Hive queries, and HBase workloads. The ETL jobs run for 4 hours daily, Hive queries are ad-hoc during business hours, and HBase serves real-time lookups 24/7. The company wants to reduce costs by 50% while maintaining performance. They have 6 months for the migration and want to adopt AWS-native services where beneficial.

A) Migrate the entire cluster to Amazon EMR with the same topology. Use EMR persistent clusters for HBase, transient clusters for Spark ETL. Use EMR Hive for ad-hoc queries. Store data in HDFS on EMR.
B) Separate workloads: migrate Spark ETL to EMR Serverless with S3 storage, migrate Hive queries to Amazon Athena, and migrate HBase to Amazon DynamoDB. Use AWS DMS with CDC for HBase data migration. Use S3 as the central data lake.
C) Migrate all data to S3 using AWS DataSync. Run Spark ETL on EMR Serverless (pay per use), migrate Hive queries to Athena with the Hive-compatible interface, and migrate HBase to Amazon EMR with HBase on S3 (EMRFS) for persistent storage. Use EMR managed scaling for the HBase cluster.
D) Use AWS Glue for Spark ETL, Amazon Redshift Serverless for Hive queries via Redshift Spectrum, and Amazon Keyspaces (Cassandra) for real-time lookups. Migrate data using AWS Snow Family due to the 500 TB volume.

**Correct Answer: C**

**Explanation:** This approach optimally maps each workload to the most cost-effective AWS service. S3 as the data lake storage replaces expensive HDFS. EMR Serverless for Spark ETL eliminates the 20 hours/day when ETL isn't running. Athena provides serverless Hive-compatible queries for ad-hoc use. HBase on EMR with S3 storage maintains the real-time lookup capability while allowing EMR managed scaling to right-size the cluster. This combination achieves 50%+ cost reduction by eliminating always-on compute for intermittent workloads. Option A replicates the same architecture on AWS with minimal cost savings. Option B's DynamoDB migration for HBase requires schema and access pattern redesign. Option D's Keyspaces is Cassandra-compatible, not HBase-compatible, requiring application changes.

---

### Question 56
A company needs to migrate 200 VMware virtual machines from their on-premises data center to AWS within a 3-month window. The VMs have complex dependencies — 50 are web servers, 80 are application servers, 40 are database servers, and 30 are utility servers. The company has already established a 10 Gbps Direct Connect connection. The migration must minimize downtime to under 2 hours per application group and maintain network connectivity between migrated and non-migrated workloads during the transition period.

A) Use AWS Application Migration Service (MGN) for rehost migration. Install the MGN agent on all 200 VMs for continuous replication. Use MGN's application grouping to migrate dependent VMs together. Test with non-disruptive test instances before cutover. Maintain hybrid connectivity via Direct Connect during the transition.
B) Use VM Import/Export to convert VMDKs to AMIs. Launch EC2 instances from the AMIs. Use Route 53 weighted routing for gradual traffic shifting. Connect on-premises and AWS via VPN during transition.
C) Use AWS Server Migration Service (SMS) to replicate VMs incrementally. Group related VMs into SMS server groups for coordinated migration. Use CloudFormation templates generated by SMS for consistent deployment.
D) Use VMware Cloud on AWS to lift and shift all VMs without conversion. Run the VMs on VMware infrastructure in AWS. Use HCX for live migration with minimal downtime. Maintain vSphere management tools.

**Correct Answer: A**

**Explanation:** AWS Application Migration Service (MGN) is the recommended service for large-scale rehost migrations. MGN performs continuous block-level replication, minimizing cutover downtime to minutes (well within the 2-hour requirement). Application grouping ensures dependent VMs (web+app+database) migrate together as a unit. Non-disruptive test instances allow validation before actual cutover. The existing Direct Connect connection provides reliable bandwidth for replication and maintains hybrid connectivity during the transition. Option B's VM Import/Export is a one-time operation without continuous replication, increasing downtime risk. Option C's SMS has been superseded by MGN. Option D's VMware Cloud on AWS maintains VMware licensing costs and doesn't achieve a native AWS migration.

---

### Question 57
A company operates a large Oracle database (30 TB) supporting a custom ERP system. They want to migrate to AWS and modernize the database to reduce licensing costs. The Oracle database uses PL/SQL stored procedures, materialized views, database links, and Oracle-specific features like Advanced Queuing. The ERP application is written in Java and cannot be modified in the near term. The company needs a phased approach.

A) Phase 1: Migrate Oracle to Amazon RDS for Oracle using DMS with ongoing replication. Phase 2: Use AWS Schema Conversion Tool to convert PL/SQL to PostgreSQL-compatible code. Phase 3: Migrate from RDS Oracle to Aurora PostgreSQL using DMS. Update application JDBC connections.
B) Phase 1: Migrate Oracle to Amazon RDS for Oracle (Bring Your Own License) using DMS for the initial lift-and-shift. Phase 2: Use Babelfish for Aurora PostgreSQL to provide Oracle compatibility without application changes. Phase 3: Gradually refactor to native PostgreSQL.
C) Migrate directly from on-premises Oracle to Aurora PostgreSQL using DMS with AWS SCT for schema conversion. Convert all PL/SQL stored procedures to PostgreSQL functions. Use SCT assessment report to identify conversion issues upfront.
D) Phase 1: Migrate to Amazon RDS for Oracle using DMS with ongoing replication. Reduce licensing costs with License Included model. Phase 2: Use AWS SCT to assess and convert the schema to Aurora PostgreSQL, addressing PL/SQL conversions, replacing materialized views and database links with Aurora-compatible alternatives, and replacing Advanced Queuing with Amazon SQS. Phase 3: Migrate data to Aurora PostgreSQL using DMS with validation.

**Correct Answer: D**

**Explanation:** This phased approach manages risk while achieving the modernization goal. Phase 1 immediately gets the database to AWS with minimal risk (Oracle-to-Oracle on RDS). Phase 2 uses SCT to systematically convert Oracle-specific features — PL/SQL stored procedures to PostgreSQL, materialized views to PostgreSQL materialized views, database links to postgres_fdw or dblink, and Advanced Queuing to Amazon SQS. Phase 3 uses DMS for the actual data migration with validation to ensure data integrity. Option A is similar but doesn't address Oracle-specific features like Advanced Queuing. Option B's Babelfish provides SQL Server compatibility, not Oracle compatibility. Option C's direct migration is too risky for a 30 TB production database with extensive Oracle-specific features.

---

### Question 58
A company runs a real-time analytics platform on a self-managed Apache Kafka cluster (12 brokers) on-premises. The platform processes 2 GB/second of streaming data from IoT devices. They want to migrate to AWS while reducing operational overhead. The existing Kafka consumers include multiple Spark Streaming jobs and custom Java applications. The migration must maintain exactly-once processing semantics and the ability to replay data from any point in the last 7 days.

A) Migrate to Amazon MSK with the same cluster configuration (12 brokers). Use MSK Connect for managed connectors. Keep existing consumer applications with updated bootstrap server endpoints. Use MSK's tiered storage for 7-day retention with cost optimization.
B) Replace Kafka with Amazon Kinesis Data Streams. Rewrite consumers to use the Kinesis Client Library (KCL). Use enhanced fan-out for consumer isolation. Enable 7-day extended retention. Use Kinesis Data Analytics (Flink) to replace Spark Streaming.
C) Migrate to Amazon MSK Serverless for zero broker management. Use MirrorMaker 2 for data migration from on-premises Kafka. Migrate Spark Streaming jobs to EMR Serverless with Spark Structured Streaming. Keep custom Java consumers with the Kafka client library.
D) Use Amazon MSK with a provisioned cluster. Use MirrorMaker 2 running on ECS Fargate for continuous replication during migration. Keep existing consumers with endpoint updates. Replace Spark Streaming with Amazon Managed Service for Apache Flink for reduced operational overhead. Enable MSK's 7-day retention.

**Correct Answer: D**

**Explanation:** Amazon MSK (provisioned) provides a managed Kafka service that maintains API compatibility with existing consumers. MirrorMaker 2 on ECS Fargate provides a managed migration path for continuous data replication from on-premises Kafka to MSK, enabling a low-risk cutover. Existing Java consumers only need endpoint updates. Replacing Spark Streaming with Managed Flink reduces operational overhead while maintaining exactly-once semantics (Flink's built-in feature). MSK supports 7-day retention for data replay. Option A doesn't modernize Spark Streaming. Option B requires rewriting all consumers and Kinesis doesn't support exactly-once processing natively. Option C's MSK Serverless has throughput limits that may not support 2 GB/second, and it doesn't support all Kafka features.

---

### Question 59
A company is migrating a Windows-based .NET Framework application from on-premises to AWS. The application uses Windows Authentication (Active Directory), MSMQ for message queuing, Windows Task Scheduler for batch jobs, and shared network drives (SMB) for file storage. The company wants to minimize refactoring while modernizing incrementally.

A) Rehost on EC2 Windows instances joined to AWS Managed Microsoft AD. Replace MSMQ with Amazon SQS. Replace Task Scheduler with EventBridge Scheduler triggering Lambda functions. Replace SMB shares with Amazon FSx for Windows File Server.
B) Rehost on EC2 Windows instances joined to AWS Managed Microsoft AD. Keep MSMQ, Task Scheduler, and local storage initially. Replace SMB shares with FSx for Windows File Server. Phase 2: Incrementally replace MSMQ with SQS and Task Scheduler with EventBridge.
C) Containerize the application using Windows containers on ECS. Use AWS Managed Microsoft AD for authentication. Replace MSMQ with Amazon MQ for ActiveMQ. Use EFS for shared storage.
D) Refactor the application to .NET Core, deploy on Lambda with API Gateway. Use Cognito with SAML federation to AD for authentication. Replace MSMQ with SQS. Use S3 for file storage.

**Correct Answer: B**

**Explanation:** A phased approach minimizes risk for a complex Windows application with multiple dependencies. Phase 1 rehost maintains application functionality: EC2 Windows instances work with all existing Windows components (MSMQ, Task Scheduler), AWS Managed Microsoft AD provides Windows Authentication, and FSx for Windows File Server provides native SMB shares with AD integration. Phase 2 incrementally modernizes components. Option A attempts too many changes simultaneously, increasing migration risk. Option C's Windows containers on ECS don't support MSMQ or traditional Task Scheduler, requiring immediate refactoring. Option D's full refactoring to .NET Core is a major effort that conflicts with the "minimize refactoring" requirement.

---

### Question 60
A media company needs to migrate their video transcoding pipeline from an on-premises GPU cluster to AWS. The pipeline processes 1,000 videos per day, each requiring 15-30 minutes of GPU-accelerated transcoding. Peak load occurs Monday-Friday during business hours, with minimal weekend processing. The on-premises cluster has 50 GPU servers that are 70% idle on average. The company wants to reduce costs significantly.

A) Use Amazon Elastic Transcoder for video transcoding. It's a managed service that eliminates the need for GPU management. Use S3 for input/output storage.
B) Deploy EC2 GPU instances (g5 family) in an Auto Scaling group with a step scaling policy based on an SQS queue depth metric. Use Spot Instances for up to 90% cost savings. Implement S3 event notifications to SQS for job queuing.
C) Use AWS Elemental MediaConvert for video transcoding. It's a serverless service with pay-per-use pricing that handles GPU acceleration internally. Use S3 for input/output. No infrastructure management needed.
D) Deploy AWS Batch with GPU-enabled compute environments using Spot Instances. Define job definitions for transcoding tasks. Use S3 event notifications to trigger Step Functions that submit Batch jobs. Scale to zero during idle periods.

**Correct Answer: C**

**Explanation:** AWS Elemental MediaConvert is a serverless, file-based video transcoding service that requires zero infrastructure management. It handles GPU acceleration internally, scales automatically, and charges per minute of content processed. For 1,000 videos/day with variable load, the pay-per-use model eliminates the 70% idle capacity waste. MediaConvert supports professional-grade encoding features. Option A's Elastic Transcoder is a legacy service with limited codec support. Option B requires managing EC2 GPU instances and Auto Scaling, adding operational overhead. Option D works but adds unnecessary complexity with Batch job management when MediaConvert handles the use case natively as a fully managed service.

---

### Question 61
A company is migrating a legacy mainframe application that processes batch transactions overnight (6 PM to 6 AM). The batch processes involve COBOL programs reading from VSAM files, performing business logic, and writing to DB2 databases. The company wants to re-platform to AWS while preserving the existing COBOL business logic to avoid rewriting 2 million lines of code. The DB2 database will be migrated to Aurora PostgreSQL.

A) Use AWS Mainframe Modernization service with the Micro Focus runtime engine to execute existing COBOL programs on EC2 or managed runtime. Migrate VSAM files to Amazon FSx or RDS PostgreSQL using the Mainframe Modernization data replication tools. Connect to Aurora PostgreSQL for database operations.
B) Rewrite all COBOL programs in Java using automated code conversion tools. Deploy on ECS Fargate. Migrate DB2 to Aurora PostgreSQL using DMS. Replace VSAM with S3.
C) Use AWS Lambda with a COBOL runtime layer to execute batch programs serverlessly. Migrate VSAM to DynamoDB. Use Step Functions to orchestrate the batch sequence.
D) Deploy a z/OS emulator on EC2 bare metal instances. Run the mainframe application unchanged. Connect to Aurora PostgreSQL via JDBC.

**Correct Answer: A**

**Explanation:** AWS Mainframe Modernization service with the Micro Focus runtime provides a supported environment for executing existing COBOL programs without rewriting them. The service handles the complexities of mainframe runtime (JCL processing, CICS transaction management, VSAM file handling) on AWS infrastructure. VSAM files can be migrated to relational databases or file systems that the Micro Focus runtime can access. This approach preserves 2 million lines of COBOL while running on modern AWS infrastructure. Option B's automated COBOL-to-Java conversion of 2 million lines is extremely risky and time-consuming. Option C's Lambda with COBOL runtime doesn't support the complex batch orchestration mainframes provide. Option D using a z/OS emulator is not a supported or practical approach.

---

### Question 62
A company has an on-premises data warehouse running Teradata with 100 TB of data. Thousands of SQL queries and stored procedures are dependent on Teradata-specific SQL syntax and features. The company wants to migrate to AWS while maintaining query compatibility. The migration must complete within 6 months, and the data warehouse must remain operational during migration with minimal query rewriting.

A) Migrate to Amazon Redshift using AWS SCT for schema conversion and DMS for data migration. Use Redshift's Teradata-compatible mode for SQL compatibility. Run SCT assessment to identify conversion issues and use SCT to convert stored procedures.
B) Migrate to Amazon Redshift using SCT and DMS. Manually rewrite all Teradata-specific SQL to Redshift SQL. Use the AWS Partner Network for specialized Teradata migration consultants.
C) Migrate to Amazon EMR with Presto for SQL query compatibility. Use Spark ETL to migrate data to S3 in Parquet format. Rewrite stored procedures as Spark jobs.
D) Keep Teradata running on EC2 instances (Teradata Vantage on AWS). This maintains 100% SQL compatibility. Migrate data using Teradata's native tools over Direct Connect.

**Correct Answer: A**

**Explanation:** Amazon Redshift with AWS SCT provides the most practical migration path from Teradata. SCT automatically converts most Teradata-specific SQL, BTEQ scripts, and stored procedures to Redshift-compatible code. SCT's assessment report identifies incompatible constructs that need manual attention, enabling focused effort. DMS handles the data migration with CDC for minimal downtime. Redshift provides a familiar SQL data warehouse experience. The 6-month timeline is achievable with SCT's automation reducing manual conversion work. Option B's manual rewriting of thousands of queries would likely exceed 6 months. Option C requires significant query rewriting and loses stored procedure functionality. Option D avoids modernization and maintains expensive Teradata licensing.

---

## Domain 5: Design for Cost Optimization (Questions 63–75)

### Question 63
A company runs 500 EC2 instances across production (200 instances, 24/7), staging (150 instances, 12 hours/day on weekdays), and development (150 instances, 8 hours/day on weekdays). All instances are currently On-Demand. The production workload is stable, staging has occasional weekend use, and development instances vary in type. The company wants to reduce EC2 costs by at least 40%.

A) Purchase 3-year Compute Savings Plans covering 100% of production compute usage. Purchase 1-year EC2 Instance Savings Plans for 50% of staging usage. Use Spot Instances for development workloads with On-Demand fallback.
B) Purchase 1-year Compute Savings Plans covering production usage. Use Instance Scheduler for staging (stop after hours and weekends) and development (stop after hours). Use Spot Instances for non-critical development workloads.
C) Purchase 3-year All Upfront Reserved Instances for all production instances. Purchase 1-year No Upfront Reserved Instances for staging. Use Instance Scheduler for development with On-Demand pricing.
D) Purchase 1-year Compute Savings Plans to cover 80% of production compute, with the flexibility to also cover staging during business hours when production is below peak. Use Instance Scheduler for staging and development off-hours. Use Spot Instances for non-critical development. On-Demand for remaining capacity.

**Correct Answer: D**

**Explanation:** This strategy maximizes cost savings through layered optimization. Compute Savings Plans at 80% of production compute provide significant discounts (up to 66% for 1-year). The flexibility of Compute Savings Plans means unused production commitment applies to staging during business hours, maximizing plan utilization. Instance Scheduler stops staging and development instances during off-hours (staging saves ~64% of runtime, development saves ~76%). Spot Instances for development add further savings up to 90% discount. This layered approach achieves >40% savings while maintaining flexibility for development. Option A over-commits with 3-year plans and 100% coverage, limiting flexibility. Option B doesn't optimize staging costs beyond scheduling. Option C's Reserved Instances lack the flexibility of Compute Savings Plans across instance families.

---

### Question 64
A company hosts a popular web application using CloudFront with an ALB origin. Their monthly CloudFront bill is $50,000, with 80% attributed to data transfer out (500 TB/month) and 20% to HTTP requests (10 billion/month). The content mix is 60% static assets (images, CSS, JS) and 40% dynamic API responses. The company wants to reduce CloudFront costs by at least 30% without degrading user experience.

A) Enable CloudFront Origin Shield to reduce origin fetches. Increase cache TTLs for static assets to 30 days. Implement Brotli compression for text-based responses. Use CloudFront price classes to restrict distribution to regions with lower pricing.
B) Sign a CloudFront Security Savings Bundle (commit to a monthly spend for a 30% discount). Enable compression (Gzip and Brotli) for all compressible content types to reduce data transfer. Optimize cache hit ratio by normalizing query strings and headers in cache keys.
C) Move static assets to S3 with CloudFront and dynamic API responses to Global Accelerator (no CDN markup on data transfer). Implement aggressive caching for static assets. Enable compression for text content.
D) Replace CloudFront with an ALB with AWS WAF for security. Use S3 Transfer Acceleration for static asset delivery. This eliminates CloudFront costs entirely.

**Correct Answer: B**

**Explanation:** The CloudFront Security Savings Bundle provides up to 30% discount on CloudFront charges in exchange for a monthly spend commitment — directly meeting the cost reduction target. Additionally, enabling Gzip/Brotli compression for text-based content (HTML, CSS, JS, JSON API responses) typically reduces transfer size by 60-80%, significantly reducing the data transfer component. Normalizing cache keys (removing unnecessary query strings, standardizing headers) improves cache hit ratio, reducing origin fetches and improving response times. Option A's Origin Shield and TTL increases help but don't achieve 30% reduction alone. Option C splits architecture unnecessarily and Global Accelerator has its own data transfer costs. Option D removes CDN benefits (edge caching, DDoS protection, global distribution), degrading user experience.

---

### Question 65
A company stores 1 PB of data in S3 Standard. Analysis shows that 5% of the data is accessed daily, 15% is accessed monthly, 30% hasn't been accessed in 6 months, and 50% hasn't been accessed in over a year. The company pays $23,000/month for S3 Standard storage. They need to reduce storage costs by 60% while maintaining the ability to access any object within 12 hours.

A) Enable S3 Intelligent-Tiering for all objects. Intelligent-Tiering automatically moves objects between frequent, infrequent, archive, and deep archive tiers based on access patterns. Enable the Archive Access and Deep Archive Access tiers.
B) Implement S3 Lifecycle policies: transition objects to S3 Standard-IA after 30 days, to S3 Glacier Flexible Retrieval after 180 days, and to S3 Glacier Deep Archive after 365 days. Use S3 Inventory to verify transitions.
C) Move all data to S3 Glacier Flexible Retrieval (standard retrieval within 3-5 hours meets the 12-hour requirement). Use S3 Batch Operations for the initial transition. Use Lifecycle policies for future data.
D) Use S3 Intelligent-Tiering for the 20% frequently/monthly accessed data, and S3 Lifecycle policies for the remaining 80%: transition to Glacier Flexible Retrieval after 180 days and Glacier Deep Archive after 365 days.

**Correct Answer: A**

**Explanation:** S3 Intelligent-Tiering is the optimal choice here because it automatically optimizes storage costs based on actual access patterns without requiring manual analysis or lifecycle policies. With the Archive Access tier (objects not accessed for 90 days) and Deep Archive Access tier (objects not accessed for 180 days) enabled, Intelligent-Tiering automatically moves the 80% of rarely accessed data to archive tiers at Glacier-equivalent pricing. The 20% actively accessed data stays in frequent/infrequent access tiers. Intelligent-Tiering's automatic retrieval from archive tiers (within 12 hours for Deep Archive) meets the access requirement. Monthly monitoring fee ($0.0025/1000 objects) is minimal at this scale. This achieves ~65% cost reduction. Option B requires manual threshold tuning and doesn't adapt to changing patterns. Option C makes frequently accessed data expensive to retrieve. Option D's hybrid approach adds management complexity.

---

### Question 66
A company runs a SaaS platform where each customer has a dedicated Amazon Aurora PostgreSQL database instance. They currently have 200 customers on db.r6g.large instances. Usage analysis shows that 70% of databases use less than 10% of their provisioned capacity during off-peak hours (nights and weekends), while peak usage is concentrated in 4-hour windows during business hours. The monthly RDS cost is $150,000.

A) Migrate all databases to Aurora Serverless v2 with minimum ACU of 0.5 and maximum ACU of 16. Aurora Serverless automatically scales to match demand, reducing costs during off-peak periods to near-zero while handling peak loads.
B) Use Instance Scheduler to stop development and staging Aurora instances during off-hours. For production, create read replicas for peak hours and remove them during off-peak.
C) Consolidate multiple small-usage customers onto shared Aurora clusters using schema-based multi-tenancy. Reduce the number of database instances from 200 to 20.
D) Purchase Reserved Instances (1-year, All Upfront) for all 200 db.r6g.large instances to get a 40% discount on the compute cost.

**Correct Answer: A**

**Explanation:** Aurora Serverless v2 automatically scales compute capacity in fine-grained increments (0.5 ACU) based on actual database load. For this use case where 70% of databases are underutilized during off-peak, Serverless v2 scales down to the minimum 0.5 ACU (equivalent to roughly 1 GB RAM), dramatically reducing costs during nights and weekends. During the 4-hour peak windows, it scales up to handle demand. With 200 databases mostly idle off-peak, the savings are substantial — potentially 60-70% compared to provisioned instances. Option B requires custom scheduling and doesn't handle the variable peak load. Option C's multi-tenancy requires significant application changes for schema isolation. Option D locks in costs without addressing the utilization problem.

---

### Question 67
A company has a data analytics pipeline that runs on an EMR cluster 24/7. The cluster has 1 master node (m5.4xlarge), 10 core nodes (r5.4xlarge), and up to 50 task nodes (r5.4xlarge) that scale based on job queue depth. Analysis shows the cluster is fully utilized only 8 hours per day (during batch processing windows), with 20% utilization the rest of the time. Task nodes are needed only during the 8-hour batch window. The monthly cost is $80,000.

A) Use EMR Managed Scaling to dynamically adjust core and task node counts. Purchase On-Demand Capacity Reservations for master and minimum core nodes, and use Spot Instances for all task nodes. Schedule EMR cluster start/stop around the 8-hour batch window using Step Functions.
B) Keep the master and core nodes running 24/7 for data durability (HDFS). Use Spot Instances for task nodes with EMR Managed Scaling. Purchase Compute Savings Plans to cover the master and core node compute. Migrate data from HDFS to S3 for the subset of data that doesn't require low-latency access.
C) Migrate data storage from HDFS to S3 (EMRFS). This decouples storage from compute, allowing the entire cluster to be terminated when not in use. Use transient EMR clusters with Spot Instances for task nodes launched by Step Functions for the 8-hour batch window. A small always-on cluster handles the low-utilization workload.
D) Replace EMR with AWS Glue for all ETL jobs. Glue is serverless and charges only for job execution time. Use Glue workflows to orchestrate the batch processing.

**Correct Answer: C**

**Explanation:** Migrating from HDFS to S3 is the key insight — it decouples storage from compute, enabling transient clusters. A transient batch cluster runs only during the 8-hour window using Spot Instances for task nodes (up to 90% discount). A small always-on cluster handles the remaining 16 hours of low-utilization work. This architecture dramatically reduces costs: Spot task nodes save 60-90% during batch hours, and eliminating 16 hours of unused large cluster capacity saves proportionally. The savings easily exceed 60% of the current $80,000/month. Option A still requires the cluster to run 24/7 for HDFS. Option B improves but keeps more capacity running than needed. Option D's Glue migration requires significant job rewriting and may not handle all EMR workload types.

---

### Question 68
A company transfers 100 TB of data per month from AWS to their on-premises data center over the internet. The data transfer costs are $8,700/month (at $0.087/GB for the first 150 TB). The company also has intermittent data transfers between regions (50 TB/month from us-east-1 to eu-west-1). The total monthly data transfer bill is $10,700. The company wants to reduce data transfer costs by 50%.

A) Establish an AWS Direct Connect connection (10 Gbps) for on-premises transfers. Direct Connect data transfer is $0.02/GB vs $0.087/GB for internet, saving $6,700/month on the 100 TB. For inter-region transfers, use VPC Gateway Endpoints for S3 where possible and S3 Transfer Acceleration for remaining transfers.
B) Use CloudFront for data distribution to on-premises. CloudFront data transfer to internet is cheaper than direct EC2/S3 data transfer out. For inter-region, use S3 Replication with S3 Batch Operations instead of real-time transfer.
C) Compress data before transfer to reduce volume by 60%. Use AWS DataSync for optimized transfers to on-premises. For inter-region, evaluate if the data can be processed in the source region to eliminate cross-region transfers.
D) Use AWS Snow Family devices for the monthly 100 TB transfer to on-premises. For inter-region, use S3 Cross-Region Replication only for data that's actually needed in the other region, and process other data in the source region.

**Correct Answer: A**

**Explanation:** Direct Connect reduces data transfer costs from $0.087/GB (internet) to $0.02/GB for data out, saving $6,700/month on the 100 TB on-premises transfer (from $8,700 to $2,000). This alone achieves a 63% reduction on the largest cost component. VPC Gateway Endpoints for S3 eliminate some inter-region transfer costs for S3-to-S3 transfers within the same region. The total savings easily exceed 50%. The Direct Connect monthly cost (~$1,500 for 10 Gbps port + cross-connect fees) is offset by the $6,700 monthly savings. Option B's CloudFront pricing is about $0.085/GB which barely saves anything. Option C's compression helps but doesn't address the fundamental pricing. Option D's Snow Family involves physical shipping which is impractical for a monthly recurring transfer.

---

### Question 69
A company runs a serverless application using API Gateway, Lambda, and DynamoDB. Their monthly bill breakdown shows: API Gateway $5,000 (REST API, 500 million requests), Lambda $3,000 (500 million invocations, average 200ms duration, 256 MB memory), and DynamoDB $8,000 (provisioned mode, 10,000 WCU, 50,000 RCU). The DynamoDB table has highly variable traffic with 5x spikes lasting 2 hours during peak.

A) Migrate API Gateway from REST API to HTTP API (up to 71% cheaper). Optimize Lambda memory using AWS Lambda Power Tuning to find the optimal memory/cost configuration. Switch DynamoDB to On-Demand capacity mode given the variable traffic pattern.
B) Keep the REST API but enable API Gateway caching to reduce Lambda invocations. Reduce Lambda memory to 128 MB. Use DynamoDB Auto Scaling with aggressive scale-up policies.
C) Replace API Gateway and Lambda with an ALB and ECS Fargate for reduced per-request costs at this volume. Keep DynamoDB provisioned mode with reserved capacity.
D) Implement CloudFront in front of API Gateway to cache GET responses and reduce API Gateway requests. Use Lambda Provisioned Concurrency to reduce cold starts. Switch DynamoDB to On-Demand mode.

**Correct Answer: A**

**Explanation:** Three targeted optimizations deliver significant savings. HTTP API costs $1.00/million requests vs $3.50/million for REST API — saving ~$3,500/month on API Gateway. Lambda Power Tuning typically identifies that a different memory configuration achieves the same performance at lower cost (or faster execution at similar cost, reducing billed duration). DynamoDB On-Demand mode eliminates over-provisioning for variable workloads — the current provisioned capacity (10K WCU, 50K RCU) is sized for 5x peaks but wasteful during normal traffic. On-Demand charges per request, aligning cost with actual usage. Combined savings exceed 40%. Option B's 128 MB Lambda may increase duration and total cost. Option C introduces infrastructure management overhead. Option D's CloudFront caching and Provisioned Concurrency add costs.

---

### Question 70
A company has 50 TB of data in an S3 bucket in us-east-1 that is accessed by applications in us-east-1, us-west-2, and eu-west-1. Cross-region data transfer costs $4,000/month. The access pattern shows that 90% of cross-region requests are for the same 5 TB subset of frequently accessed data. The remaining 45 TB is accessed only from us-east-1.

A) Enable S3 Cross-Region Replication to replicate the entire 50 TB bucket to us-west-2 and eu-west-1. Applications in each region access their local bucket. This eliminates cross-region data transfer for reads but doubles storage costs.
B) Create S3 Replication rules with S3 Replication Time Control to replicate only the 5 TB frequently accessed prefix to us-west-2 and eu-west-1. Applications access local replicas for the hot data and cross-region for cold data. Use S3 Lifecycle policies on replicas to use S3 One Zone-IA.
C) Deploy CloudFront with the S3 bucket as origin. Cross-region applications access data through CloudFront, which caches frequently accessed objects at edge locations closer to the application regions.
D) Use S3 Multi-Region Access Points to automatically route requests to the nearest replica. Replicate only the frequently accessed 5 TB to the other regions using replication rules with prefix filters.

**Correct Answer: D**

**Explanation:** S3 Multi-Region Access Points provide a single global endpoint that automatically routes requests to the nearest S3 bucket, optimizing latency and reducing cross-region transfer. By replicating only the 5 TB hot data subset (using prefix-based replication filters) to us-west-2 and eu-west-1, cross-region reads for this data become local reads. The remaining 45 TB stays only in us-east-1 (accessed only from that region anyway). Storage cost increase is minimal (5 TB × 2 replicas = 10 TB additional), while cross-region transfer savings are ~90% of the current $4,000/month ($3,600 saved). Option A replicates 50 TB unnecessarily, tripling storage costs. Option B is similar but One Zone-IA reduces durability unnecessarily. Option C adds CloudFront costs and doesn't handle write scenarios.

---

### Question 71
A company runs a machine learning training pipeline that uses 10 p4d.24xlarge instances (GPU) for 8 hours daily, 5 days a week. The on-demand cost is $32.77/hour per instance, resulting in a monthly cost of approximately $52,000. The training jobs can tolerate interruptions with checkpoint/restart capability. The company wants to reduce costs by at least 60%.

A) Use Spot Instances for all training jobs. Implement checkpointing every 30 minutes to S3. Use a diversified Spot fleet across p4d.24xlarge, p3dn.24xlarge, and g5.48xlarge instance types. Implement automatic restart from the latest checkpoint on Spot interruption.
B) Purchase 1-year Reserved Instances (All Upfront) for p4d.24xlarge instances. This provides a 40% discount. Use the instances 24/7 to maximize utilization by running additional training experiments during off-hours.
C) Use SageMaker Training with managed Spot training. SageMaker handles checkpointing, Spot interruption, and automatic restart natively. Use SageMaker's maximum wait time and maximum runtime parameters for cost control.
D) Purchase a 1-year Compute Savings Plan covering the p4d.24xlarge compute at the 8-hour daily usage rate. Use Spot Instances for any additional capacity beyond the committed usage.

**Correct Answer: C**

**Explanation:** SageMaker Managed Spot Training provides the optimal combination of cost savings and operational simplicity. It automatically handles Spot Instance procurement, checkpointing to S3, interruption handling, and job restart — eliminating custom checkpoint/restart logic. Spot savings of 60-90% on GPU instances directly meet the 60%+ cost reduction target. SageMaker's max_wait_time parameter prevents jobs from waiting too long for Spot capacity, and max_run_time controls total costs. The managed nature reduces operational overhead. Option A provides similar savings but requires building custom checkpoint/restart infrastructure. Option B's Reserved Instances only save 40% and commit to 24/7 payment for 8-hour usage. Option D's Savings Plan doesn't achieve 60% savings.

---

### Question 72
A company's AWS bill shows $15,000/month in NAT Gateway data processing charges. Investigation reveals that EC2 instances in private subnets are making API calls to AWS services (S3, DynamoDB, SQS, SNS, CloudWatch) through the NAT Gateway, and also downloading large datasets from S3 (20 TB/month) for processing. The company wants to minimize NAT Gateway costs.

A) Create VPC Gateway Endpoints for S3 and DynamoDB (free). Create VPC Interface Endpoints for SQS, SNS, and CloudWatch. Update route tables for gateway endpoints and DNS for interface endpoints. This eliminates NAT Gateway traffic for all AWS service calls.
B) Move EC2 instances to public subnets with Elastic IPs, eliminating NAT Gateway entirely. Use security groups and NACLs for security. Enable S3 Gateway Endpoint for S3 traffic.
C) Implement S3 VPC Gateway Endpoint for the bulk of traffic (20 TB/month S3 downloads). Evaluate if VPC Interface Endpoints are cost-effective for other services by comparing endpoint costs vs NAT Gateway data processing charges for that service's traffic volume.
D) Replace NAT Gateway with a NAT Instance (t3.micro) for reduced costs. The t3.micro handles the API calls while S3 traffic goes through an S3 Gateway Endpoint.

**Correct Answer: C**

**Explanation:** A cost-optimized approach starts with the biggest win: S3 Gateway Endpoint (free, no data processing charges) eliminates the 20 TB/month S3 traffic from NAT Gateway, saving approximately $900/month in NAT Gateway data processing ($0.045/GB × 20,000 GB). For other services, the decision between Interface Endpoints and NAT Gateway depends on traffic volume — Interface Endpoints cost $0.01/GB + $0.01/hour per AZ, which may or may not be cheaper than NAT Gateway's $0.045/GB depending on the traffic volume. The correct approach evaluates each service's traffic to determine cost-effectiveness. Option A installs interface endpoints for all services without evaluating if each one saves money. Option B moving to public subnets compromises security. Option D's NAT Instance has throughput limitations and operational overhead.

---

### Question 73
A company runs a batch processing workload on 100 c5.2xlarge Spot Instances that process jobs from an SQS queue. The average Spot price is $0.12/hour (70% discount from on-demand). However, the company experiences frequent Spot interruptions during a specific 4-hour window (2 PM - 6 PM EST) when demand spikes, causing 30% of instances to be reclaimed. This results in job failures, extended processing times, and reprocessing costs. The company wants to maintain cost savings while improving reliability.

A) Diversify across multiple instance types (c5.2xlarge, c5a.2xlarge, m5.2xlarge, c6i.2xlarge, c6a.2xlarge) and multiple Availability Zones using a capacity-optimized allocation strategy in EC2 Fleet. Implement SQS visibility timeout extensions for long-running jobs.
B) Use a mixed instances policy in the Auto Scaling group: 70% Spot with diversified types and 30% On-Demand as a stable baseline. During the 2-6 PM window, shift to 50% On-Demand via scheduled scaling. Implement job checkpointing.
C) Switch to On-Demand instances during the 2-6 PM window using EventBridge Scheduler to modify the ASG launch template. Use Spot for the remaining 20 hours. Implement SQS dead-letter queues for failed jobs.
D) Use Spot Fleet with the lowest-price allocation strategy across multiple instance types. Request Spot instances in regions with historically lower Spot prices. Implement job timeout and requeue logic.

**Correct Answer: A**

**Explanation:** Instance type diversification with capacity-optimized allocation is the primary solution for Spot interruptions. The capacity-optimized strategy selects instance pools with the highest available capacity, minimizing interruption probability. By diversifying across 5+ instance types and multiple AZs, the fleet draws from many independent Spot pools, dramatically reducing the chance of widespread interruptions. SQS visibility timeout extensions prevent interrupted jobs from being processed by another instance while the original may still complete. This approach maintains the 70% cost savings while significantly improving reliability. Option B's On-Demand baseline adds cost without addressing the root cause during normal hours. Option C's time-based switching is reactive and increases costs significantly. Option D's lowest-price strategy actually increases interruption risk by concentrating on the cheapest (most popular) pools.

---

### Question 74
A company has a multi-tier web application with the following monthly costs: ALB ($500), EC2 Auto Scaling group ($8,000 for 10-20 c5.xlarge instances), RDS PostgreSQL Multi-AZ ($4,000 for db.r5.2xlarge), ElastiCache Redis ($1,500 for cache.r5.xlarge), and NAT Gateway ($2,000). Traffic analysis shows: average 1,000 requests per second, 3x spikes lasting 30 minutes twice daily, and 200ms average response time. The CTO wants to reduce the total monthly cost by 50% without sacrificing performance.

A) Migrate to serverless: API Gateway + Lambda + Aurora Serverless v2 + ElastiCache Serverless. Eliminate ALB, EC2, and NAT Gateway costs.
B) Right-size EC2 instances using Compute Optimizer (likely 30% over-provisioned). Purchase Savings Plans for baseline EC2 capacity. Switch RDS to Aurora PostgreSQL I/O-Optimized for better price-performance. Use Reserved Nodes for ElastiCache. Reduce NAT Gateway costs with VPC endpoints.
C) Migrate the application tier to ECS Fargate with Spot capacity for non-critical tasks. Use Aurora Serverless v2 to replace RDS (scales for spikes, saves during low traffic). Replace ElastiCache with DynamoDB DAX. Use VPC endpoints to reduce NAT Gateway costs.
D) Purchase 1-year Reserved Instances for EC2, RDS, and ElastiCache. Implement Instance Scheduler to stop non-production resources. Add CloudFront for caching to reduce origin load and allow smaller ASG.

**Correct Answer: B**

**Explanation:** A systematic optimization approach yields the best results for an existing application. Compute Optimizer typically identifies 20-30% over-provisioning, reducing EC2 costs to ~$5,600. Savings Plans on the baseline compute provide an additional 30% discount ($3,920). Aurora PostgreSQL I/O-Optimized eliminates per-I/O charges, typically reducing database costs by 25-40% for write-heavy workloads ($2,400-$3,000). Reserved ElastiCache nodes save ~40% ($900). VPC endpoints reduce NAT Gateway to ~$500. Total: ~$7,820-$8,320, roughly a 50% reduction from $16,000. This approach doesn't require application changes. Option A's serverless migration is a major architectural change that may not reduce costs at 1,000 req/s sustained load (Lambda can be more expensive than EC2 at this volume). Option C mixes too many changes. Option D's RIs alone don't achieve 50%.

---

### Question 75
A company provides a video surveillance SaaS platform. Each customer has 10-50 cameras streaming 24/7 to AWS. The platform stores 30 days of video and serves on-demand playback. Current architecture: Kinesis Video Streams for ingestion ($15,000/month), S3 Standard for storage ($10,000/month for 500 TB), CloudFront for playback ($5,000/month), and EC2 for video processing ($8,000/month). Total monthly cost: $38,000. The company wants to reduce costs by 40%.

A) Replace Kinesis Video Streams with direct-to-S3 uploads using multipart upload from cameras. Use S3 Lifecycle policies: Standard for 7 days, then S3 Glacier Instant Retrieval for 8-30 days. Use MediaConvert for on-demand transcoding instead of always-on EC2 processing.
B) Keep Kinesis Video Streams but reduce retention to 24 hours (just enough for processing). Move processed video to S3 Intelligent-Tiering. Replace EC2 video processing with Lambda for event-driven processing. Use CloudFront Security Savings Bundle.
C) Optimize Kinesis Video Streams retention to 24 hours. Store processed video in S3: Standard for 3 days, S3 Standard-IA for 4-30 days. Replace EC2 with AWS Elemental MediaLive for live processing and MediaConvert for recorded processing. Use CloudFront price class restrictions.
D) Replace Kinesis Video Streams with Amazon IVS for ingestion. Use S3 One Zone-IA for all video storage (single-AZ is acceptable for surveillance footage). Use Spot Instances for EC2 video processing. Negotiate CloudFront private pricing.

**Correct Answer: A**

**Explanation:** The largest cost component is Kinesis Video Streams ($15,000). Replacing it with direct-to-S3 multipart uploads eliminates this cost entirely — cameras can upload HLS segments or raw footage directly to S3 via HTTPS. S3 Lifecycle tiering saves significantly on the $10,000 storage cost: 7 days in Standard (~$2,750) + 23 days in Glacier Instant Retrieval (3.6x cheaper, ~$2,500) = ~$5,250 total. Glacier Instant Retrieval provides millisecond access for on-demand playback. MediaConvert replaces always-on EC2 processing ($8,000) with pay-per-minute serverless transcoding, saving during low-processing periods. Total estimated savings: >$15,000/month (>40%). Option B reduces KVS costs but doesn't eliminate them. Option C still uses KVS. Option D's One Zone-IA risks data loss from AZ failure, unacceptable for a surveillance platform.

---

## Answer Key

| # | Answer | # | Answer | # | Answer | # | Answer | # | Answer |
|---|--------|---|--------|---|--------|---|--------|---|--------|
| 1 | C | 16 | A | 31 | B | 46 | B | 61 | A |
| 2 | A | 17 | C | 32 | B | 47 | D | 62 | A |
| 3 | C | 18 | A | 33 | A | 48 | A | 63 | D |
| 4 | B | 19 | B | 34 | B | 49 | A | 64 | B |
| 5 | B | 20 | D | 35 | A | 50 | B | 65 | A |
| 6 | B | 21 | B | 36 | C | 51 | B | 66 | A |
| 7 | C | 22 | B | 37 | C | 52 | A | 67 | C |
| 8 | A | 23 | C | 38 | B | 53 | B | 68 | A |
| 9 | B | 24 | A | 39 | A | 54 | A | 69 | A |
| 10 | A | 25 | A | 40 | A | 55 | C | 70 | D |
| 11 | A | 26 | A | 41 | B | 56 | A | 71 | C |
| 12 | B | 27 | A | 42 | A | 57 | D | 72 | C |
| 13 | A | 28 | B | 43 | A | 58 | D | 73 | A |
| 14 | B | 29 | B | 44 | A | 59 | B | 74 | B |
| 15 | C | 30 | D | 45 | C | 60 | C | 75 | A |
