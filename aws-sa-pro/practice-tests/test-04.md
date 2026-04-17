# AWS Certified Solutions Architect - Professional (SAP-C02) Practice Test 4

**Focus Areas:** Analytics (Kinesis, Athena, Glue, EMR), Security Services, Hybrid Architectures
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

A pharmaceutical company operates 80 AWS accounts across research, manufacturing, clinical trials, and corporate divisions. Each division has its own security requirements, but the CISO needs a single view of security findings across all accounts. The company uses Amazon GuardDuty, AWS Security Hub, Amazon Inspector, and Amazon Macie. Security findings must be aggregated, prioritized, and have automated remediation for common issues.

Which architecture provides centralized security management?

A. Configure each security service independently in each account with findings sent to individual SNS topics.

B. Designate a security tooling account as the delegated administrator for GuardDuty, Security Hub, Inspector, and Macie. Enable organization-wide auto-enrollment for all services. Security Hub aggregates findings from all services in the delegated admin account. Create EventBridge rules in the security account to route critical findings to Lambda functions for automated remediation (e.g., revoke open security groups, disable compromised access keys).

C. Deploy a third-party SIEM in the security account and configure all services to send logs to it.

D. Use CloudWatch Dashboards in each account for local security monitoring.

**Correct Answer: B**

**Explanation:** Using a delegated administrator for all security services provides a single pane of glass. Security Hub normalizes findings from GuardDuty, Inspector, and Macie into a standard format (ASFF). Organization-wide auto-enrollment ensures new accounts are automatically covered. EventBridge-triggered Lambda provides automated remediation. Option A fragments security monitoring across accounts. Option C adds cost and complexity of a third-party tool when native services suffice. Option D lacks cross-account aggregation.

---

### Question 2

A company needs to implement a hybrid DNS architecture where their on-premises DNS servers can resolve AWS private hosted zone records, and AWS resources can resolve on-premises DNS records. The company has a Direct Connect connection. They have 10 VPCs across 5 accounts that all need this bidirectional DNS resolution.

Which architecture provides the MOST scalable bidirectional DNS resolution?

A. Deploy BIND DNS servers in each VPC for forwarding.

B. Create a centralized DNS VPC with Route 53 Resolver inbound endpoints (for on-premises → AWS resolution) and outbound endpoints (for AWS → on-premises resolution). Create Route 53 Resolver forwarding rules for on-premises domains. Share the forwarding rules with all 10 VPCs via AWS RAM. Configure on-premises DNS servers to forward AWS domain queries to the inbound endpoint IP addresses over the Direct Connect connection.

C. Use Route 53 public hosted zones so both environments can resolve records over the internet.

D. Configure DHCP option sets in each VPC to point to on-premises DNS servers.

**Correct Answer: B**

**Explanation:** Route 53 Resolver endpoints in a centralized DNS VPC handle bidirectional resolution. Inbound endpoints receive queries from on-premises (via Direct Connect), and outbound endpoints forward queries to on-premises. RAM shares the forwarding rules across all VPCs without duplicating endpoints. Option A adds operational overhead with self-managed DNS servers. Option C exposes internal DNS records publicly. Option D creates a dependency on on-premises for all DNS resolution and doesn't handle AWS private hosted zones.

---

### Question 3

An insurance company has a compliance requirement that all data stored in AWS must be encrypted using FIPS 140-2 Level 3 validated hardware security modules. They use KMS extensively for encryption across 30 accounts. The current KMS keys use AWS-managed HSMs which are FIPS 140-2 Level 3 validated by default.

The compliance team has further mandated that the company must have exclusive control over the HSM hardware—AWS should not have access to the key material at any point.

Which solution meets the exclusive control requirement?

A. Standard AWS KMS with customer-managed keys—KMS HSMs are already FIPS 140-2 Level 3 validated.

B. AWS CloudHSM which provides dedicated, single-tenant HSM instances. The company retains exclusive control of the HSM and key material—AWS has no access to keys stored in CloudHSM. Integrate CloudHSM with KMS using a custom key store to use CloudHSM-backed keys across all AWS services that integrate with KMS.

C. Use AWS KMS with imported key material for full control.

D. Use AWS KMS external key store (XKS) with an on-premises HSM.

**Correct Answer: B**

**Explanation:** CloudHSM provides single-tenant HSMs where the company has exclusive control—AWS cannot access the key material (this is architecturally enforced). KMS custom key store integration allows using CloudHSM-backed keys with any KMS-integrated service. Option A uses shared multi-tenant HSMs where AWS manages the infrastructure. Option C (imported key material) still uses shared KMS HSMs for cryptographic operations. Option D (XKS) works but adds on-premises dependency and latency for every crypto operation.

---

### Question 4

A multinational enterprise needs to connect their on-premises data centers in New York, London, and Tokyo to AWS Regions in us-east-1, eu-west-1, and ap-northeast-1. Each data center needs connectivity to all three AWS Regions. Traffic must stay private and the solution must provide automatic failover if a single connection fails.

Which hybrid connectivity architecture provides global private connectivity with resilience?

A. Establish a Direct Connect connection from each data center to its nearest AWS Region. Use a Direct Connect Gateway to connect to transit gateways in all three Regions. Configure inter-Region transit gateway peering for cross-Region connectivity. Deploy redundant connections for failover.

B. Use three separate VPN connections from each data center to each Region (9 total connections).

C. Use a single Direct Connect connection from the New York data center for all global traffic.

D. Use AWS CloudWAN with Direct Connect attachments for each site.

**Correct Answer: A**

**Explanation:** Direct Connect from each data center to the nearest Region provides optimal latency. The Direct Connect Gateway enables each connection to reach transit gateways in all three Regions through a single gateway. Inter-Region transit gateway peering connects the Regions. Redundant connections at each location provide failover. Option B uses VPN which has lower bandwidth and higher latency than Direct Connect. Option C is a single point of failure with all traffic routing through New York. Option D works but is more complex than needed for three defined sites.

---

### Question 5

A company implements AWS Control Tower and discovers that some developer accounts have manually provisioned resources that conflict with the landing zone baseline. Specifically, developers have created Config recorders with settings that differ from Control Tower's mandatory Config configuration.

How should this conflict be resolved?

A. Delete the Control Tower landing zone and redeploy.

B. In the affected accounts, delete the manually created Config recorder and Config delivery channel. Then re-register the account in Control Tower to deploy the standard baseline Config configuration. Implement an SCP to prevent direct Config API calls (config:PutConfigurationRecorder, config:DeleteConfigurationRecorder) in all member accounts.

C. Ignore the conflict—both Config configurations will run in parallel.

D. Modify Control Tower's Config configuration to match the developer accounts' settings.

**Correct Answer: B**

**Explanation:** Removing the conflicting manual Config configuration and re-registering the account allows Control Tower to deploy its baseline correctly. The SCP prevents future manual modifications to Config settings, ensuring Control Tower maintains consistent governance. Option A is destructive and unnecessary. Option C causes conflicts—only one Config recorder can be active per Region per account. Option D compromises governance standards to match non-standard configurations.

---

### Question 6

A company has a hybrid architecture with AWS and Azure. They need to connect their AWS VPCs to Azure VNets for a multi-cloud application. The connection must be private, support high bandwidth (5 Gbps), and be reliable. They already have AWS Direct Connect and Azure ExpressRoute connections from their data center.

Which approach provides private multi-cloud connectivity?

A. Route traffic from AWS through the Direct Connect connection to the on-premises data center, then through the ExpressRoute connection to Azure. This uses existing infrastructure for private, high-bandwidth connectivity.

B. Create a VPN connection between AWS and Azure over the internet.

C. Use a cloud exchange provider (like Equinix or Megaport) that offers direct peering between AWS and Azure, bypassing the on-premises data center.

D. Send traffic over the public internet between AWS and Azure.

**Correct Answer: C**

**Explanation:** A cloud exchange provider offers direct Layer 2/Layer 3 connectivity between AWS and Azure at colocation facilities, providing the shortest path with highest bandwidth and lowest latency. This avoids hairpinning through the on-premises data center (Option A) which adds latency and depends on data center infrastructure. Option B uses the public internet with VPN overhead and bandwidth limitations. Option D has no encryption by default and uses the public internet.

---

### Question 7

A company uses AWS Organizations with 50 accounts. The security team needs to implement a solution that automatically detects when someone creates an IAM user with programmatic access keys in any member account (the company mandates SSO for all access). The detection should trigger an alert and disable the access keys within 5 minutes.

Which solution provides the FASTEST detection and remediation?

A. Use AWS Config rules to check for IAM users with access keys daily.

B. Deploy an organization-wide CloudTrail trail. Create an EventBridge rule in the management account (or delegated admin) that matches the CreateAccessKey API call pattern from CloudTrail events. The EventBridge rule triggers a Lambda function that: (1) sends an SNS alert to the security team, (2) calls iam:UpdateAccessKey to disable the key using a cross-account role, (3) logs the remediation action.

C. Use Amazon GuardDuty to detect unauthorized IAM access key creation.

D. Use Security Hub to aggregate findings about new access keys.

**Correct Answer: B**

**Explanation:** CloudTrail events delivered to EventBridge are near real-time (typically within minutes). EventBridge rules matching CreateAccessKey API calls trigger Lambda for immediate automated response—disabling the key and alerting the security team. This achieves the sub-5-minute requirement. Option A (Config) runs on a schedule, not real-time. Option C (GuardDuty) detects threats from key usage, not key creation. Option D (Security Hub) aggregates existing findings but doesn't create custom detection rules for API calls.

---

### Question 8

A company operates a hybrid environment with sensitive workloads. They need to ensure that all communication between their on-premises network and AWS is encrypted. They use AWS Direct Connect for connectivity. The security team notes that Direct Connect provides a dedicated connection but traffic is NOT encrypted by default on the physical link.

Which solution adds encryption to Direct Connect traffic?

A. Direct Connect traffic is already encrypted—no additional action needed.

B. Create a Site-to-Site VPN connection over the Direct Connect public virtual interface using the IPsec protocol. This encrypts all traffic traversing the Direct Connect connection. Alternatively, use MACsec (802.1AE) on supported Direct Connect connections for Layer 2 encryption.

C. Use TLS on all application connections.

D. Add a software-based encryption appliance in the on-premises data center.

**Correct Answer: B**

**Explanation:** Direct Connect provides a dedicated physical connection but does NOT encrypt traffic on the wire. Two options add encryption: (1) VPN over Direct Connect using a public VIF encrypts at the IP layer with IPsec; (2) MACsec provides native Layer 2 encryption on the Direct Connect connection itself (supported on dedicated 10 Gbps and 100 Gbps connections). Option A is factually incorrect. Option C encrypts application traffic but not all network traffic. Option D adds complexity and doesn't integrate with AWS networking.

---

### Question 9

An enterprise wants to implement a centralized outbound internet access point for all 20 VPCs across their organization. All internet-bound traffic must be inspected by AWS Network Firewall for threat detection, domain filtering, and intrusion prevention. The architecture must be cost-effective and support scaling.

Which architecture centralizes internet egress with inspection?

A. Deploy a NAT gateway and Network Firewall in each of the 20 VPCs.

B. Create a centralized inspection VPC with AWS Network Firewall and NAT gateways. Attach all spoke VPCs and the inspection VPC to a transit gateway. Configure transit gateway route tables to route 0.0.0.0/0 from spoke VPCs to the inspection VPC. In the inspection VPC, route traffic through the Network Firewall before reaching the NAT gateway.

C. Use AWS WAF on CloudFront for all outbound traffic inspection.

D. Deploy proxy servers on EC2 in each VPC for outbound traffic filtering.

**Correct Answer: B**

**Explanation:** A centralized inspection VPC with Transit Gateway provides a single egress point with Network Firewall inspection for all 20 VPCs. Transit Gateway route tables direct all internet traffic (0.0.0.0/0) to the inspection VPC where Network Firewall inspects before NAT gateway sends to the internet. This is cost-effective (one firewall deployment) and scalable. Option A deploys 20 firewalls—expensive and operationally complex. Option C is for inbound web traffic, not outbound inspection. Option D requires managing proxy infrastructure.

---

### Question 10

A company needs to share Amazon Machine Images (AMIs) with specific AWS accounts outside their organization. The AMIs contain proprietary software and must not be shared publicly or copied to unauthorized accounts. The company wants to control which accounts can use the AMIs and track AMI usage.

Which approach provides controlled AMI sharing with usage tracking?

A. Make the AMIs public for easy access.

B. Share AMIs with specific account IDs using AMI launch permissions. Encrypt the AMIs with a customer-managed KMS key and grant kms:Decrypt permission only to the authorized accounts. Use CloudTrail to log all RunInstances API calls that reference the shared AMI for usage tracking.

C. Create a public S3 bucket with the AMI files for download.

D. Use AWS Marketplace to list the AMIs as public products.

**Correct Answer: B**

**Explanation:** AMI launch permissions restrict which accounts can use the AMI. KMS encryption adds a second layer of control—even if launch permissions were accidentally broadened, only accounts with KMS Decrypt permission can actually launch instances. CloudTrail logging tracks all usage. Option A makes AMIs public. Option C exposes proprietary software. Option D lists publicly on Marketplace which is more than controlled sharing.

---

### Question 11

A company has a regulatory requirement that all network traffic between their VPCs must be inspected by a third-party firewall appliance. They have 15 VPCs connected via a transit gateway. The firewall appliance runs on EC2 instances in a dedicated inspection VPC.

Which transit gateway routing configuration ensures all inter-VPC traffic passes through the firewall?

A. Propagate all VPC routes in a single transit gateway route table.

B. Create two transit gateway route tables: "spoke" and "firewall." Associate all spoke VPC attachments with the spoke route table. Associate the firewall VPC attachment with the firewall route table. In the spoke route table, create a default route (0.0.0.0/0) pointing to the firewall VPC attachment. In the firewall route table, propagate routes from all spoke VPCs. The firewall inspects and forwards traffic.

C. Use VPC peering instead of transit gateway for traffic inspection.

D. Deploy the firewall inline between the transit gateway and each VPC.

**Correct Answer: B**

**Explanation:** The two-route-table approach forces all inter-VPC traffic through the firewall. Spoke VPCs send all traffic to the firewall VPC (via the default route). The firewall VPC has routes back to all spoke VPCs (via propagation). Traffic flow: Source VPC → Transit Gateway → Firewall VPC → Inspection → Transit Gateway → Destination VPC. Option A allows direct spoke-to-spoke traffic without inspection. Option C doesn't scale and peering is non-transitive. Option D is not architecturally feasible.

---

### Question 12

A company is building an analytics solution where they need to provide 200 business analysts with SQL query access to data stored in S3. The data is stored as compressed Parquet files organized by date partitions. The total data size is 50 TB with 500 GB added daily. Analysts run ad-hoc queries ranging from simple counts to complex joins across multiple tables.

Which analytics solution balances cost and performance for this use case?

A. Load all data into Amazon Redshift for best query performance.

B. Use Amazon Athena with the AWS Glue Data Catalog. Create external tables pointing to the S3 data. Use partitioning on date columns to optimize query performance and reduce costs. For frequently accessed data, create materialized views in Athena or use Athena's query result reuse.

C. Deploy an EMR cluster running Presto for interactive SQL queries.

D. Use Amazon RDS for storing and querying the data.

**Correct Answer: B**

**Explanation:** Athena is serverless, scales to 200 concurrent analysts, and charges only per query (data scanned). Parquet's columnar format reduces data scanned. Date partitioning further reduces costs by limiting scans to relevant partitions. No infrastructure to manage. Option A requires ongoing Redshift cluster costs for 50 TB storage. Option C requires managing an EMR cluster. Option D is not suitable for 50 TB analytical workloads.

---

### Question 13

A company collects clickstream data from their e-commerce website at a rate of 50,000 events per second. They need to: (1) store raw events in a data lake, (2) aggregate events in real-time for a dashboard showing top products by page views, and (3) detect anomalous patterns like potential DDoS attacks.

Which architecture handles all three requirements?

A. Amazon Kinesis Data Streams for ingestion → Consumer 1: Kinesis Data Firehose to S3 for data lake storage → Consumer 2: Amazon Managed Service for Apache Flink for real-time aggregation and anomaly detection, writing results to DynamoDB for the dashboard.

B. API Gateway for event collection → Lambda for processing → S3 for storage.

C. Amazon SQS for event queuing → Lambda for processing → Redshift for analytics.

D. Direct S3 PUT for each event → Athena for real-time querying.

**Correct Answer: A**

**Explanation:** Kinesis Data Streams handles 50K events/second ingestion. Firehose automatically batches and delivers to S3 for the data lake. Apache Flink provides stateful real-time processing for aggregations (top products) and anomaly detection (pattern analysis over time windows). DynamoDB serves the dashboard with low-latency reads. Option B can't handle 50K events/second through API Gateway efficiently. Option C (SQS + Lambda) doesn't support real-time aggregation. Option D (direct S3 PUT) creates millions of small files and Athena isn't real-time.

---

### Question 14

A company is implementing AWS Security Hub across their organization. They want to create custom insights that identify accounts with the highest number of critical findings, track finding remediation SLA compliance, and generate weekly executive reports. The findings data must be retained for 2 years for audit purposes.

Which approach provides comprehensive security analytics on Security Hub data?

A. Use Security Hub's built-in insights and dashboards for all reporting needs.

B. Configure Security Hub to export findings to S3 via EventBridge and Kinesis Data Firehose (or direct S3 export). Use AWS Glue to catalog the findings data. Use Amazon Athena for ad-hoc queries and custom SQL-based insights. Use Amazon QuickSight for executive dashboards with weekly scheduled reports. S3 lifecycle policies retain data for 2 years.

C. Export findings to CloudWatch Logs and use Log Insights for analysis.

D. Use the Security Hub API to query findings in real-time for all reporting.

**Correct Answer: B**

**Explanation:** Exporting findings to S3 provides long-term retention (2 years), Glue catalogs the data for queryability, Athena enables flexible SQL analysis (custom insights, SLA compliance queries), and QuickSight creates executive dashboards with scheduled email reports. This provides unlimited retention and custom analytics. Option A is limited to Security Hub's 90-day finding retention and preset insights. Option C (CloudWatch Logs) has limited analytical capabilities. Option D has API rate limits and 90-day retention limitation.

---

### Question 15

A company is building a data mesh architecture where each business domain (sales, marketing, operations) owns and publishes their data as data products. Other domains should be able to discover and consume these data products with proper access controls. The company uses AWS Organizations with separate accounts per domain.

Which AWS services enable a data mesh pattern?

A. Each domain stores data in their own S3 buckets with no cross-account access.

B. Use AWS Lake Formation as the central data governance layer. Each domain registers their S3 data locations with Lake Formation and defines their data products with fine-grained permissions. Use Lake Formation cross-account data sharing to allow other domains to discover and access data products. Use the AWS Glue Data Catalog as the central metadata store for data product discovery.

C. Replicate all data to a central data lake account for all analytics.

D. Use Amazon DataZone as the data marketplace where domain teams publish data products and consumer teams can subscribe to them through a self-service catalog.

**Correct Answer: D**

**Explanation:** Amazon DataZone is purpose-built for the data mesh pattern, providing a data marketplace where domain teams publish data products with metadata, and consumers discover and subscribe through a self-service catalog. It handles governance, access requests, and approval workflows. Option A provides no cross-domain data sharing. Option B (Lake Formation) provides governance but lacks the marketplace/catalog experience that DataZone offers. Option C contradicts the data mesh principle where domains own their data.

---

### Question 16

A financial services company is building a real-time fraud detection system that analyzes transactions. They need to join streaming transaction data with reference data (customer profiles, merchant categories, historical patterns) to make fraud decisions. The reference data is stored in DynamoDB and updated hourly. The system must process 10,000 transactions per second with sub-second decision latency.

Which architecture enables stream-to-table joins with low latency?

A. Use Kinesis Data Streams with Lambda consumers that query DynamoDB for each transaction.

B. Use Amazon Managed Service for Apache Flink with a Kinesis Data Streams source for transactions. Use Flink's async I/O to query DynamoDB for reference data enrichment. Maintain a local cache (within Flink) of frequently accessed reference data with hourly refresh. Output fraud decisions to another Kinesis stream.

C. Use Amazon Redshift Streaming Ingestion to join transactions with reference tables.

D. Write all transactions to DynamoDB and run batch fraud detection hourly.

**Correct Answer: B**

**Explanation:** Flink's async I/O with DynamoDB lookups enables efficient stream enrichment without blocking the processing pipeline. Local caching of reference data reduces DynamoDB calls and latency. Flink handles 10K TPS with stateful processing for pattern matching. Option A (Lambda + DynamoDB) works but Lambda's cold starts and per-invocation overhead may not meet sub-second latency at 10K TPS consistently. Option C (Redshift Streaming) is for analytics, not real-time transaction processing. Option D is batch, not real-time.

---

### Question 17

A company has deployed AWS Config across their organization with 200+ Config rules. They are spending $15,000/month on Config due to the high volume of configuration item recordings and rule evaluations. The majority of cost comes from recording ALL resource types in ALL accounts.

How can Config costs be reduced while maintaining critical compliance monitoring?

A. Disable Config entirely and rely on CloudTrail.

B. Configure Config to record only the resource types needed for compliance rules (not all resource types). Use periodic evaluation mode for rules that don't need real-time detection. Exclude development accounts from non-critical rules. Use Config conformance pack filtering to apply rule sets selectively to different OUs.

C. Reduce the number of Config rules to 10.

D. Delete Config rules and use manual compliance checks.

**Correct Answer: B**

**Explanation:** Selective recording of only needed resource types dramatically reduces configuration item volume and cost. Periodic evaluation (instead of change-triggered) reduces evaluation frequency for rules that don't need real-time detection. Applying rules selectively by OU avoids unnecessary evaluations in development accounts. Option A loses all compliance monitoring. Option C may miss critical compliance areas. Option D replaces automated monitoring with manual processes.

---

### Question 18

A company is building a centralized VPC for shared services. The shared services include: internal DNS, centralized logging, SIEM, and artifact repositories. 30 spoke VPCs need access to these shared services. The company wants to ensure that if the shared services VPC has an outage, it doesn't cause cascading failures in the spoke VPCs.

How should the shared services architecture be designed for resilience?

A. Deploy all shared services in a single VPC with no redundancy.

B. Deploy shared services across multiple AZs within the VPC with Auto Scaling for each service. Use health checks and automatic failover. For DNS, use Route 53 Resolver (which is inherently HA). For the logging/SIEM, implement buffering in spoke VPCs (local log queuing) so that a shared services outage doesn't block spoke VPC applications. Use NLB endpoints for service access to handle AZ failures transparently.

C. Deploy identical shared services in every spoke VPC for maximum independence.

D. Use a single EC2 instance for each shared service.

**Correct Answer: B**

**Explanation:** Multi-AZ deployment with Auto Scaling provides HA for the shared services VPC. Local log buffering in spoke VPCs (using agents with local queuing) prevents a logging infrastructure outage from blocking applications. NLB endpoints distribute traffic across healthy AZ targets. Route 53 Resolver is natively HA. Option A has single-AZ failure risk. Option C duplicates services 30 times—operationally untenable. Option D has single-instance failure risk.

---

### Question 19

A company's security team needs to investigate a potential data breach. They need to analyze VPC Flow Logs, CloudTrail logs, DNS query logs, and application logs to trace the attacker's activity across multiple accounts and Regions. The investigation must cover the last 90 days of data.

Which tool and approach is MOST effective for the investigation?

A. Manually search through individual log files in S3.

B. Use Amazon Detective which automatically processes and correlates data from VPC Flow Logs, CloudTrail, and GuardDuty findings. Detective builds a behavior graph that visualizes relationships between entities (IP addresses, IAM principals, resources) over time, enabling rapid investigation of the attack path across accounts.

C. Use CloudWatch Logs Insights to search each log group individually.

D. Export all logs to a spreadsheet for manual analysis.

**Correct Answer: B**

**Explanation:** Amazon Detective automatically ingests and correlates CloudTrail, VPC Flow Logs, and GuardDuty findings into a unified graph model. Investigators can trace an entity (IP, user, role) across all data sources, accounts, and Regions to map the attack path. This is purpose-built for security investigations. Option A is extremely time-consuming for 90 days of multi-source logs. Option C requires searching each log group individually without cross-correlation. Option D is impractical for the volume of data involved.

---

### Question 20

A company operates in a highly regulated industry and needs to demonstrate that changes to their AWS infrastructure follow an approval workflow. All infrastructure changes must be: proposed via a change request, approved by a change advisory board (CAB), implemented through automation, and validated before completion.

Which approach implements a formal change management process for AWS infrastructure?

A. Use AWS Systems Manager Change Manager. Define change templates for common operations (e.g., patching, deployments, scaling). Configure approval workflows that require CAB sign-off. Change Manager executes the approved changes using SSM Automation documents and tracks the full change lifecycle with audit trails.

B. Use a ticketing system external to AWS and manually implement changes.

C. Implement a Git-based pull request workflow for infrastructure-as-code changes.

D. Allow all engineers to make changes directly with CloudTrail logging.

**Correct Answer: A**

**Explanation:** SSM Change Manager provides an AWS-native change management process with templates, multi-level approval workflows, automated execution via SSM Automation, and complete audit trails. This integrates change management directly with the implementation, ensuring approved changes are executed consistently. Option B separates the approval from execution—changes may not match what was approved. Option C handles code review but not operational changes or formal CAB approvals. Option D has no approval process.

---

### Question 21

A company needs to build an analytics pipeline that processes semi-structured JSON log data from 100 different application services. The logs have inconsistent schemas across services. The data team needs to: discover the schemas automatically, transform the data into a common format, and make it queryable via SQL.

Which pipeline handles schema discovery and transformation?

A. Write custom Python scripts to parse each log format individually.

B. Use AWS Glue Crawlers to automatically discover and catalog the schemas of JSON log files in S3. Use Glue Data Catalog as the central metadata store. Create AWS Glue ETL jobs (Spark-based) to transform the heterogeneous schemas into a common Parquet format with standardized column names. Query the transformed data using Amazon Athena.

C. Load all JSON files directly into Amazon Redshift using COPY.

D. Use Amazon Kinesis Data Firehose to convert JSON to Parquet during delivery.

**Correct Answer: B**

**Explanation:** Glue Crawlers automatically detect schemas from JSON files, even with inconsistent structures. The Data Catalog stores all discovered schemas. Glue ETL jobs handle schema harmonization—mapping different field names, types, and structures to a common format. Parquet conversion optimizes for Athena SQL queries. Option A requires manual parsing for 100 different schemas. Option C requires defining schemas upfront which isn't possible with inconsistent formats. Option D converts to Parquet but doesn't harmonize schemas.

---

### Question 22

A company has 10 TB of structured data in Amazon Redshift and 50 TB of unstructured data in S3. They want to enable data scientists to run machine learning models on the combined dataset without moving data between services. The data scientists use Jupyter notebooks and Python.

Which architecture enables ML on both data sources without data movement?

A. Export Redshift data to S3 and use SageMaker exclusively on S3 data.

B. Use Amazon SageMaker notebooks with connections to both data sources. Use Redshift ML to train ML models directly in Redshift using SQL (which calls SageMaker behind the scenes). For complex models, use SageMaker Data Wrangler to create data flows that join Redshift and S3 data, feed the combined dataset to SageMaker training jobs—data is accessed in-place via Redshift federated queries and S3 access.

C. Load all S3 data into Redshift for a single data source.

D. Use Amazon EMR to process both data sources.

**Correct Answer: B**

**Explanation:** SageMaker Data Wrangler connects to both Redshift and S3 natively, enabling data scientists to join, transform, and feed data to ML models without manual data movement. Redshift ML enables SQL-based ML for simpler models. Jupyter notebooks in SageMaker provide the familiar Python environment. Option A requires copying 10 TB from Redshift to S3. Option C requires loading 50 TB of unstructured data into a relational database. Option D requires managing EMR cluster infrastructure.

---

### Question 23

A company needs to implement real-time threat detection for their application. They want to analyze application logs, network flow data, and user behavior patterns to detect compromised accounts, unusual data access patterns, and potential data exfiltration. The system must correlate events from multiple data sources.

Which combination of AWS security services provides comprehensive threat detection? (Choose TWO.)

A. Amazon GuardDuty for detecting threats based on VPC Flow Logs, DNS logs, CloudTrail events, and S3 data access patterns. GuardDuty uses ML to identify anomalous behavior.

B. Amazon Macie for discovering and protecting sensitive data in S3, detecting unusual data access patterns that could indicate data exfiltration.

C. AWS WAF for detecting compromised accounts based on web request patterns.

D. Amazon Inspector for runtime vulnerability scanning of EC2 instances and containers.

E. AWS Trusted Advisor for security best practice recommendations.

**Correct Answer: A, B**

**Explanation:** GuardDuty (A) analyzes VPC Flow Logs, DNS queries, CloudTrail events, and S3 data events using ML to detect compromised accounts, unusual network activity, and malicious behavior. Macie (B) specifically monitors S3 data access patterns to detect unusual downloads or access that could indicate exfiltration. Together, they cover network-level and data-level threat detection. Option C (WAF) protects web applications from common exploits, not account compromise. Option D (Inspector) scans for vulnerabilities, not runtime threats. Option E provides recommendations, not real-time detection.

---

### Question 24

A company needs to build a data pipeline that processes 1 TB of CSV data daily from an SFTP server. The data must be cleaned (remove duplicates, fix data types, handle null values), enriched with reference data from DynamoDB, transformed into Parquet format, and loaded into a Redshift data warehouse. The pipeline should be fully managed and cost-effective.

Which ETL architecture is MOST appropriate?

A. Build a custom ETL application on EC2 that processes the CSV files.

B. AWS Transfer Family (SFTP endpoint) → S3 landing zone → AWS Glue ETL job (PySpark) for data cleaning, DynamoDB enrichment via Glue's DynamoDB connector, Parquet conversion → S3 processed zone → Redshift COPY from S3. Orchestrate with AWS Glue Workflow or Step Functions.

C. Direct SFTP download to Redshift using COPY command.

D. Use Amazon Kinesis Data Firehose for the entire pipeline.

**Correct Answer: B**

**Explanation:** AWS Transfer Family provides a managed SFTP endpoint that lands files in S3. Glue ETL handles data cleaning, deduplication, type conversion, null handling, DynamoDB enrichment, and Parquet conversion—all in a serverless Spark environment. Redshift COPY efficiently loads Parquet from S3. Orchestration ensures steps execute in order. Option A requires managing infrastructure. Option C—Redshift doesn't directly read from SFTP, and COPY doesn't handle complex transformations. Option D is for streaming, not daily batch SFTP processing.

---

### Question 25

A company has deployed AWS Network Firewall in their inspection VPC. They want to create rules that block traffic to known malicious domains, detect SQL injection attempts in HTTP traffic, and allow only specific TLS versions. The rules must be managed centrally across multiple VPCs.

Which Network Firewall configuration addresses all requirements?

A. Use only stateless rules for all traffic filtering.

B. Create a Network Firewall policy with: (1) Stateless rules for basic allow/deny by IP and port. (2) Stateful rules with domain list rule groups for blocking known malicious domains (HTTP and TLS). (3) Stateful rules with Suricata-compatible IPS signatures for SQL injection detection in HTTP payload. (4) TLS inspection rules to enforce minimum TLS versions. Use AWS Firewall Manager to deploy the policy across all VPCs consistently.

C. Use security groups for domain-based filtering.

D. Deploy AWS WAF instead of Network Firewall.

**Correct Answer: B**

**Explanation:** Network Firewall supports multiple rule types for layered security: domain lists block known bad domains in both HTTP (via Host header) and HTTPS (via SNI), Suricata IPS rules detect SQL injection in payloads, and TLS inspection rules enforce TLS version requirements. Firewall Manager provides centralized, cross-VPC policy management. Option A (stateless only) can't inspect domains or payloads. Option C (security groups) can't filter by domain. Option D (WAF) only works for HTTP/HTTPS at the application layer, not all network traffic.

---

### Question 26

A company needs to process and analyze geospatial data from IoT fleet vehicles. Each vehicle reports GPS coordinates every 10 seconds. The company needs to: store the location history, run geospatial queries (e.g., "find all vehicles within 5km of a warehouse"), and visualize vehicle positions on a real-time map.

Which architecture supports geospatial analytics?

A. Store GPS data in DynamoDB with geohash as partition key.

B. Ingest via IoT Core → Kinesis Data Streams → Lambda (process and store in Amazon Location Service for map visualization AND Amazon OpenSearch Service with the geo_point data type for geospatial queries). Use OpenSearch's geospatial query DSL for proximity searches and aggregations. Feed real-time positions to Amazon Location Service tracker for map visualization.

C. Store all data in RDS PostgreSQL with PostGIS extension.

D. Store GPS data in S3 and query with Athena.

**Correct Answer: B**

**Explanation:** Amazon Location Service provides native fleet tracking and map visualization. OpenSearch's geo_point type enables efficient geospatial queries (geo_distance, geo_bounding_box) at scale. Kinesis handles high-frequency ingestion from 50,000+ vehicles. This combination provides both real-time tracking and historical geospatial analytics. Option A (DynamoDB geohash) works for basic proximity but lacks rich geospatial query support. Option C (PostGIS) works but requires managing infrastructure at IoT scale. Option D (Athena) isn't optimized for real-time geospatial queries.

---

### Question 27

A company wants to build a machine learning pipeline that automatically retrains models when data drift is detected. New training data arrives daily in S3. The pipeline should: detect data drift, trigger retraining, evaluate model quality, and deploy the new model if it outperforms the current one.

Which architecture provides automated ML lifecycle management?

A. Manually retrain models monthly and compare results.

B. Use Amazon SageMaker Pipelines to define the ML workflow: data preprocessing → training → evaluation → conditional deployment. Use SageMaker Model Monitor to detect data drift on the deployed endpoint. When drift is detected, Model Monitor triggers an EventBridge event that starts the SageMaker Pipeline. The pipeline's evaluation step compares the new model against the current baseline; if improved, it deploys via SageMaker Endpoints with traffic shifting.

C. Use a cron job on EC2 to retrain models weekly.

D. Use AWS Lambda to train ML models when new data arrives.

**Correct Answer: B**

**Explanation:** SageMaker Model Monitor continuously analyzes inference data for drift. EventBridge triggers SageMaker Pipelines for automated retraining. The pipeline evaluates model quality against baselines before deployment. Traffic shifting (canary/linear) validates the new model in production. This is a fully automated MLOps lifecycle. Option A is manual and infrequent. Option C doesn't detect drift and retrains on a fixed schedule. Option D isn't suitable for model training (Lambda has time and resource limits).

---

### Question 28

A company has a hybrid architecture where an on-premises application needs to call AWS Lambda functions and access DynamoDB. The on-premises network is connected to AWS via Direct Connect. The company wants to invoke Lambda from on-premises without going over the internet.

How can on-premises applications privately invoke Lambda and access DynamoDB?

A. Call Lambda and DynamoDB APIs over the public internet.

B. Create interface VPC endpoints (PrivateLink) for Lambda (com.amazonaws.region.lambda) and gateway VPC endpoint for DynamoDB in a VPC connected to the Direct Connect. On-premises applications route to the VPC endpoint IP addresses through the Direct Connect connection's private virtual interface. Configure DNS resolution so that Lambda and DynamoDB API endpoints resolve to the VPC endpoint IPs.

C. Deploy the Lambda function in a VPC and call it directly via its VPC IP.

D. Use AWS Outposts to run Lambda on-premises.

**Correct Answer: B**

**Explanation:** Interface VPC endpoints for Lambda provide private IP addresses within the VPC that on-premises can reach via Direct Connect. Gateway VPC endpoints for DynamoDB route through the VPC's route table. DNS resolution ensures the API endpoints resolve to the private endpoint IPs. All traffic stays on the Direct Connect private path. Option A uses the internet, violating the private connectivity requirement. Option C—Lambda functions in a VPC don't have static IPs for direct invocation. Option D requires Outposts hardware.

---

### Question 29

A company wants to implement a security data lake that centralizes all security-related logs from across their AWS environment. The logs include CloudTrail, VPC Flow Logs, Route 53 DNS logs, S3 access logs, ALB access logs, and GuardDuty findings. They need to query the data using SQL and retain it for 7 years.

Which solution provides a centralized, queryable security data lake?

A. Send all logs to CloudWatch Logs and use Log Insights for querying.

B. Use Amazon Security Lake which automatically centralizes security data from AWS services into a purpose-built security data lake in S3 using the Open Cybersecurity Schema Framework (OCSF). Configure subscriber access for query tools. Use Amazon Athena or third-party SIEM tools to query the data. S3 lifecycle policies retain data for 7 years.

C. Build a custom data lake by configuring each service to send logs to a central S3 bucket.

D. Use Amazon OpenSearch for all security log ingestion and analysis.

**Correct Answer: B**

**Explanation:** Amazon Security Lake automatically collects and normalizes security data from AWS services (CloudTrail, VPC Flow Logs, Route 53, S3, GuardDuty) into the OCSF format. It stores data in S3 using optimized Parquet format with automatic partitioning. Subscribers (Athena, third-party SIEMs) can query the normalized data. Option A (CloudWatch Logs) is expensive for 7-year retention at scale. Option C requires building custom normalization and collection. Option D (OpenSearch) is costly for 7 years of retention.

---

### Question 30

A company needs to implement a solution for detecting personally identifiable information (PII) in data stored across 500 S3 buckets in their organization. When PII is detected, the data must be automatically classified, the bucket owner notified, and an audit record created. The solution must be organization-wide.

Which service provides automated PII detection and classification at scale?

A. Write a custom Lambda function that scans S3 objects using regex patterns for PII.

B. Enable Amazon Macie organization-wide using a delegated administrator. Configure Macie to perform automated sensitive data discovery on all S3 buckets. Macie uses ML and pattern matching to detect PII (SSN, credit cards, names, addresses). Configure EventBridge rules to route Macie findings to SNS for bucket owner notifications and to a central S3 bucket for audit records.

C. Use Amazon Comprehend PII detection on all S3 objects.

D. Use AWS Config rules to check for PII in S3 bucket names and tags.

**Correct Answer: B**

**Explanation:** Macie is purpose-built for sensitive data discovery in S3 at scale. Organization-wide deployment via delegated admin covers all 500 buckets automatically, including new ones. Macie's ML detects 100+ PII types without custom regex. EventBridge integration enables automated notifications and audit logging. Option A requires building and maintaining regex patterns for all PII types. Option C would require reading every object—expensive and complex to orchestrate. Option D checks metadata, not content.

---

### Question 31

A company needs to implement a log analytics solution that enables analysts to search through 5 TB of daily log data interactively. Queries should return results within 5 seconds for common search patterns. The data must be retained for 90 days in the searchable state.

Which solution provides the required query performance at scale?

A. Store logs in S3 and query with Amazon Athena.

B. Amazon OpenSearch Service with index lifecycle management. Use hot nodes (SSD-backed) for the most recent 7 days, warm nodes (UltraWarm) for 8-30 days, and cold storage for 31-90 days. Configure index patterns optimized for common search queries.

C. Store logs in DynamoDB and use PartiQL for queries.

D. Amazon CloudWatch Logs with Logs Insights.

**Correct Answer: B**

**Explanation:** OpenSearch provides interactive, sub-5-second search over large log volumes with full-text indexing. Index lifecycle management automatically tiers data: hot storage for real-time search, UltraWarm for recent historical data (still searchable), and cold for older data (searchable on demand). This optimizes cost across the 90-day retention. Option A (Athena) typically takes 5-30 seconds for 5 TB scans. Option C (DynamoDB) isn't designed for full-text log search. Option D (CloudWatch Logs) becomes expensive at 5 TB/day.

---

### Question 32

A company needs to build an ETL pipeline that transforms data from multiple relational databases (MySQL, PostgreSQL, SQL Server) and loads it into a data lake. The transformations include joining tables across databases, applying business rules, and deduplicating records. The pipeline runs daily and processes 500 GB.

Which approach provides the MOST managed ETL solution?

A. Write custom Python scripts running on EC2.

B. Use AWS Glue ETL with JDBC connections to all source databases. Create Glue jobs using PySpark or Glue's visual ETL editor. Use Glue's built-in transforms (join, filter, deduplicate) for data processing. Glue's DynamicFrame handles schema differences across sources. Output to S3 in Parquet format partitioned by date. Schedule via Glue Triggers.

C. Use Amazon EMR with Spark for ETL processing.

D. Use AWS Data Pipeline for orchestrating the ETL workflow.

**Correct Answer: B**

**Explanation:** AWS Glue provides serverless ETL with native JDBC connections to MySQL, PostgreSQL, and SQL Server. DynamicFrames handle schema evolution and differences. Built-in transforms cover joins, deduplication, and business rules. The visual editor enables non-code transformations. Glue Triggers handle scheduling. Option A requires infrastructure and code management. Option C (EMR) requires cluster management. Option D (Data Pipeline) is a legacy service being replaced by Glue and Step Functions.

---

### Question 33

A company wants to implement data quality checks in their analytics pipeline. Before data is loaded into their Redshift data warehouse, they need to validate: column completeness (no critical columns are null), referential integrity (foreign keys match), data freshness (data is from the expected time range), and statistical profiles (values fall within expected distributions).

Which approach provides automated data quality validation?

A. Write SQL queries in Redshift to check data quality after loading.

B. Use AWS Glue Data Quality which integrates with Glue ETL jobs. Define Data Quality Definition Language (DQDL) rules for completeness, uniqueness, referential integrity, freshness, and statistical checks. Configure Glue Data Quality to evaluate data during ETL processing. Failed quality checks halt the pipeline and trigger SNS notifications. Quality metrics are tracked over time for trend analysis.

C. Build custom validation functions in Lambda.

D. Use Great Expectations framework on an EC2 instance.

**Correct Answer: B**

**Explanation:** AWS Glue Data Quality provides native data quality checks within the ETL pipeline using DQDL rules. Evaluations run during Glue job execution, catching issues before data reaches Redshift. Failed checks can halt the pipeline (preventing bad data from loading), and quality metrics are tracked historically. Option A checks quality after loading—bad data is already in the warehouse. Option C requires building and maintaining custom validation code. Option D works but requires managing EC2 infrastructure.

---

### Question 34

A company has an on-premises Splunk deployment for security information and event management (SIEM). They want to migrate to an AWS-native solution while maintaining similar capabilities: log aggregation, correlation rules, alert management, and security dashboards.

Which AWS solution provides Splunk-equivalent SIEM capabilities?

A. Use CloudWatch Logs for all log aggregation and alerting.

B. Use Amazon OpenSearch Service with the Security Analytics plugin. Ingest logs from all sources (CloudTrail, VPC Flow Logs, application logs) via Kinesis Data Firehose. Use OpenSearch Dashboards for visualization. Use detection rules for threat correlation and alerting. Alternatively, use Amazon Security Lake + a partner SIEM or use OpenSearch's SIEM capabilities.

C. Use Amazon Athena for security log analysis.

D. Use AWS Security Hub as a complete SIEM replacement.

**Correct Answer: B**

**Explanation:** OpenSearch with Security Analytics provides SIEM capabilities including: log ingestion from multiple sources, correlation rules (Sigma format), automated alerting, and rich dashboards for investigation. Firehose handles log collection at scale. This most closely replicates Splunk's feature set. Option A lacks correlation rules and SIEM-grade analysis. Option C is for ad-hoc querying, not real-time monitoring. Option D provides security posture management but isn't a full SIEM.

---

### Question 35

A company needs to analyze 100 TB of historical sales data stored in Amazon Redshift to identify trends, forecast demand, and segment customers. The analysis requires complex statistical computations, ML algorithms, and interactive visualization. The data science team uses Python (pandas, scikit-learn) and R.

Which analytics approach enables interactive analysis at this scale?

A. Export data from Redshift to CSV and analyze locally on laptops.

B. Use Amazon SageMaker notebooks connected to Redshift via the Redshift Data API. Use SageMaker's distributed training for ML models on the full dataset. For SQL-based analysis, use Redshift ML to train and deploy ML models directly in Redshift using SQL. For visualization, use Amazon QuickSight connected to Redshift with SPICE for fast dashboard rendering.

C. Load all data into a single EC2 instance with 1 TB of RAM.

D. Use Amazon EMR with Jupyter notebooks for all analysis.

**Correct Answer: B**

**Explanation:** SageMaker notebooks with Redshift Data API enable Python/R analysis on Redshift data. SageMaker handles large-scale ML training. Redshift ML enables SQL-based ML directly on the data warehouse. QuickSight with SPICE provides sub-second dashboard interactions on large datasets. This combination covers all requirements without data movement. Option A can't handle 100 TB locally. Option C is a single point of failure and can't scale. Option D requires managing EMR clusters.

---

### Question 36

A company is building a real-time recommendation engine for their e-commerce platform. The engine must process user clickstream data, combine it with product catalog and purchase history, and generate personalized recommendations within 100ms per request. The system serves 10,000 concurrent users.

Which architecture provides real-time personalized recommendations?

A. Pre-compute recommendations for all users daily using batch processing.

B. Use Amazon Personalize for ML-based real-time recommendations. Ingest user interactions via the Personalize Events API (real-time). Train recommendation models using Personalize campaigns. Call the GetRecommendations API at request time for sub-100ms personalized results. Use EventBridge to trigger model retraining when significant new data accumulates.

C. Use Amazon Redshift to compute recommendations at query time.

D. Build a custom recommendation engine on EC2 using collaborative filtering.

**Correct Answer: B**

**Explanation:** Amazon Personalize provides managed ML-based recommendations with real-time event ingestion and sub-100ms API response times. It handles the ML complexity (training, hosting, serving) and integrates real-time user behavior with historical data. Campaigns serve recommendations at scale. Option A generates stale recommendations that miss real-time user behavior. Option C can't provide 100ms response times for complex recommendation queries. Option D requires building and maintaining ML infrastructure.

---

### Question 37

A company needs to build a data warehouse that can handle: (1) structured data from transactional databases, (2) semi-structured JSON data from APIs, (3) streaming data from IoT devices, and (4) ML model training and inference. All data types must be queryable using standard SQL.

Which data warehouse architecture supports all data types?

A. Use separate systems for each data type.

B. Amazon Redshift as the central data warehouse. Use Redshift SUPER data type for semi-structured JSON (natively query JSON with SQL). Use Redshift Streaming Ingestion for real-time IoT data from Kinesis. Use Redshift ML for training and inference directly in SQL. Use Redshift Spectrum for querying large datasets that remain in S3.

C. Use Amazon Athena for all data types.

D. Use Amazon Aurora with JSON support for all data.

**Correct Answer: B**

**Explanation:** Redshift's SUPER type natively stores and queries JSON. Streaming Ingestion brings real-time IoT data directly into Redshift. Redshift ML enables SQL-based ML. Spectrum extends queries to S3 data. This provides a unified SQL interface across all data types. Option A fragments the analytics experience. Option C (Athena) is serverless but lacks streaming ingestion and native ML integration. Option D (Aurora) is OLTP, not designed for large-scale analytics.

---

### Question 38

A company implements AWS GuardDuty and receives a finding: "UnauthorizedAccess:IAMUser/MaliciousIPCaller.Custom." The finding indicates that an IAM user is making API calls from a known malicious IP address. The security team needs to respond immediately.

What is the correct incident response procedure?

A. Delete the IAM user immediately.

B. Execute the following response in order: (1) Confirm the finding in GuardDuty and check the IAM user's recent API activity in CloudTrail. (2) Attach a deny-all IAM policy to the user to immediately block all actions without deleting the user (preserves forensic evidence). (3) Rotate or delete the user's access keys and console password. (4) Check for any resources the user created or modified during the compromise period. (5) Review the user's IAM policies for privilege escalation. (6) Document the incident and conduct root cause analysis.

C. Suppress the GuardDuty finding and continue monitoring.

D. Shut down all EC2 instances in the account.

**Correct Answer: B**

**Explanation:** This follows AWS's recommended incident response: contain (deny-all policy), eradicate (rotate keys), investigate (CloudTrail analysis), and recover (review changes). Attaching a deny-all policy is preferred over deletion because it preserves the user for forensic analysis while immediately blocking further actions. Option A destroys forensic evidence. Option C ignores an active threat. Option D is an overreaction that impacts all services.

---

### Question 39

A company has a hybrid architecture where some applications run on-premises and others on AWS. They need to implement centralized secrets management that works for both environments. On-premises applications should be able to retrieve secrets from AWS Secrets Manager without storing long-lived AWS credentials on-premises.

Which approach enables on-premises secret retrieval without stored credentials?

A. Store AWS access keys in an on-premises configuration file for the Secrets Manager API calls.

B. Use IAM Roles Anywhere. Create a trust anchor using the company's on-premises certificate authority. On-premises applications use X.509 certificates issued by the CA to obtain temporary AWS credentials from IAM Roles Anywhere, then use those credentials to call Secrets Manager APIs.

C. Replicate all secrets from Secrets Manager to an on-premises HashiCorp Vault.

D. Create a VPN connection and use VPC endpoints for Secrets Manager access.

**Correct Answer: B**

**Explanation:** IAM Roles Anywhere enables on-premises workloads to obtain temporary AWS credentials using X.509 certificates from an existing PKI/CA. No long-lived credentials are stored on-premises. The temporary credentials are used to call Secrets Manager APIs. Option A stores long-lived credentials. Option C requires maintaining a separate secrets store. Option D provides network connectivity but still needs authentication credentials.

---

### Question 40

A company processes sensitive financial data and needs to ensure that their AWS resources comply with specific security configurations. They need to check: EC2 instances have specific security group rules, S3 buckets are not publicly accessible, RDS databases have encryption enabled, and IAM users have MFA enabled. Non-compliant resources must be reported and auto-remediated.

Which combination provides detection and remediation? (Choose TWO.)

A. AWS Config managed rules for compliance detection (restricted-ssh, s3-bucket-public-read-prohibited, rds-storage-encrypted, iam-user-mfa-enabled).

B. AWS Config auto-remediation using SSM Automation documents that fix non-compliant resources (close open security groups, enable S3 Block Public Access, enable RDS encryption).

C. AWS Trusted Advisor for compliance checking.

D. Manual quarterly security audits.

E. AWS CloudTrail for real-time compliance detection.

**Correct Answer: A, B**

**Explanation:** AWS Config managed rules (A) provide continuous compliance evaluation against predefined checks for security groups, S3 public access, RDS encryption, and IAM MFA. Auto-remediation (B) uses SSM Automation to automatically fix non-compliant resources—closing security groups, enabling Block Public Access, etc. Together, they provide detect-and-fix automation. Option C (Trusted Advisor) provides recommendations but limited remediation. Option D is periodic, not continuous. Option E (CloudTrail) logs actions but doesn't evaluate compliance state.

---

### Question 41

A company needs to implement a real-time analytics dashboard that shows key business metrics. Data sources include: PostgreSQL database (transaction data), Redis cache (session data), API logs in CloudWatch, and a DynamoDB table (user profile data). The dashboard must update every 10 seconds and support drill-down analysis.

Which architecture provides near real-time dashboards from multiple data sources?

A. Export all data to S3 hourly and build QuickSight dashboards on the S3 data.

B. Use Amazon Managed Grafana with data source plugins for PostgreSQL (via Amazon RDS), CloudWatch, and DynamoDB. For Redis data, publish metrics to CloudWatch using a Lambda function. Configure Grafana dashboards with 10-second auto-refresh. Use Grafana's built-in alerting for threshold-based notifications.

C. Build a custom dashboard using React on EC2 that queries each data source directly.

D. Use Amazon QuickSight with SPICE for all data sources refreshed every hour.

**Correct Answer: B**

**Explanation:** Amazon Managed Grafana natively supports multiple data sources (CloudWatch, PostgreSQL, DynamoDB) with real-time querying. The 10-second auto-refresh provides near real-time updates. Grafana's drill-down and variable features enable interactive analysis. Lambda bridges Redis to CloudWatch for Grafana consumption. Option A has hourly delays. Option C requires building and maintaining a custom application. Option D (QuickSight SPICE) has minimum 1-hour refresh intervals.

---

### Question 42

A company is implementing a streaming data architecture for their IoT platform. Data flows from 100,000 IoT devices through IoT Core to Kinesis Data Streams. They need to: (1) process data in real-time for alerting, (2) archive all data to S3, (3) aggregate data every 5 minutes for time-series database storage, and (4) feed a machine learning model for predictive maintenance.

How should the Kinesis stream consumers be designed for these four use cases?

A. Use a single Lambda consumer that performs all four tasks for each record.

B. Use enhanced fan-out with four dedicated consumers: (1) Lambda with event source mapping for real-time alerting (processed individually). (2) Kinesis Data Firehose for S3 archival (buffered delivery). (3) Amazon Managed Service for Apache Flink for 5-minute windowed aggregations to Amazon Timestream. (4) Kinesis Data Firehose to a separate S3 prefix feeding SageMaker Inference Pipeline.

C. Read all data into SQS queues and process from there.

D. Use a single EC2 consumer application for all processing.

**Correct Answer: B**

**Explanation:** Enhanced fan-out provides dedicated 2MB/sec throughput per consumer, preventing consumers from competing for read capacity. Each consumer is optimized for its purpose: Lambda for low-latency alerting, Firehose for batched S3 delivery, Flink for stateful windowed aggregations, and a separate Firehose for ML data delivery. Option A creates a monolith with mixed concerns and failure modes. Option C loses Kinesis ordering and adds latency. Option D is a single point of failure.

---

### Question 43

A company runs a global content management system on ECS Fargate. The system is deployed in us-east-1 and eu-west-1. Users report occasional "stale content" where updates made in one Region aren't visible in the other for up to 5 minutes. The application uses Aurora Global Database for data storage and ElastiCache for Redis in each Region as a caching layer.

What is the MOST likely cause and solution for the stale content issue?

A. Aurora Global Database replication lag. Upgrade to a larger Aurora instance.

B. The ElastiCache instances in each Region have cached stale data that hasn't been invalidated after the Aurora Global Database replicates changes. Implement a cache invalidation strategy: when data is written, publish a message to an SNS topic that fans out to SQS queues in each Region. Lambda consumers in each Region invalidate the corresponding cache entries in the local ElastiCache cluster.

C. CloudFront is caching the stale content at edge locations.

D. ECS tasks are caching data in local memory.

**Correct Answer: B**

**Explanation:** Aurora Global Database typically replicates in under 1 second, but the ElastiCache layers in each Region cache data independently. When an update occurs in one Region, the remote Region's cache still serves the old data until TTL expires. Cross-Region cache invalidation via SNS → SQS → Lambda ensures caches are updated when the underlying data changes. Option A is unlikely—Aurora Global Database lag is sub-second. Option C would affect external users, not the application itself. Option D would affect individual tasks, not consistently across Regions.

---

### Question 44

A company has deployed AWS WAF on their Application Load Balancer to protect their web application. Despite WAF rules, the application is still experiencing SQL injection attacks. The WAF logs show that the malicious requests are encoded using double URL encoding, which bypasses the SQL injection rule group.

How should the WAF configuration be updated to detect encoded attacks?

A. Add more SQL injection rules to the rule group.

B. Enable the AWS WAF text transformation "URL_DECODE" applied twice (double decoding) in the SQL injection match condition. WAF will decode the request twice before evaluating it against SQL injection patterns, catching double-encoded payloads. Additionally, enable the "COMPRESS_WHITE_SPACE" and "HTML_ENTITY_DECODE" transformations for comprehensive detection.

C. Switch to AWS Shield Advanced for DDoS protection.

D. Block all requests containing the % character.

**Correct Answer: B**

**Explanation:** WAF text transformations decode request components before rule evaluation. Applying URL_DECODE twice handles double-encoded payloads (the common bypass technique). Additional transformations (COMPRESS_WHITE_SPACE, HTML_ENTITY_DECODE) catch other encoding tricks. Option A adds rules but they still evaluate encoded content. Option C (Shield) is for DDoS, not SQL injection. Option D blocks legitimate requests containing encoded characters (like search queries with spaces).

---

### Question 45

A company's operations team has been manually creating CloudWatch dashboards for each new application deployment. They have 50 applications, each with its own dashboard containing common widgets (CPU, memory, latency, error rates, request counts). Maintaining these dashboards is time-consuming.

Which approach automates dashboard management?

A. Continue manually creating dashboards but hire additional staff.

B. Create a CloudWatch dashboard template using CloudFormation. Define a parameterized template that accepts the application name, ALB name, ECS service name, etc. as parameters and generates a complete dashboard with all standard widgets. Deploy the template as part of each application's infrastructure pipeline.

C. Use a single dashboard for all 50 applications.

D. Use CloudWatch Application Insights for automatic dashboard creation.

**Correct Answer: B**

**Explanation:** A parameterized CloudFormation template generates consistent dashboards automatically during application deployment. Parameters customize the dashboard for each application while maintaining standard widgets and layout. This integrates with CI/CD and ensures every application gets a proper dashboard without manual creation. Option A doesn't scale. Option C makes a cluttered, unusable dashboard. Option D automatically detects common resources but doesn't customize for specific application metrics.

---

### Question 46

A company has implemented cross-Region read replicas for their RDS MySQL database. The replication lag has been steadily increasing over the past week, now averaging 30 minutes. The primary database handles 10,000 writes per second. The replica is the same instance type as the primary.

What are the MOST likely causes and solutions? (Choose TWO.)

A. The cross-Region network bandwidth is insufficient. Enable RDS Performance Insights on the replica to verify if the replica's apply thread is CPU-bound or I/O-bound. If I/O-bound, upgrade the replica to a storage-optimized instance type (e.g., r5) or switch to Provisioned IOPS storage.

B. The replica is performing long-running read queries that block the replication apply thread. Identify and optimize slow queries on the replica, or use a separate read endpoint for analytics queries.

C. The primary database is too large. Delete old data to reduce replication volume.

D. Cross-Region replication always has 30-minute lag—this is normal.

E. The VPC peering connection between Regions is throttled.

**Correct Answer: A, B**

**Explanation:** Growing replication lag typically indicates the replica can't apply changes as fast as they're produced. Common causes: (A) I/O bottleneck on the replica—write-heavy workloads generate a high replication stream that requires fast storage I/O on the replica. Performance Insights helps diagnose the bottleneck. (B) Long-running queries on the replica can block the single-threaded replication apply process. Option C—data size doesn't cause lag; write rate does. Option D—30 minutes is not normal for MySQL replication. Option E—RDS manages replication networking.

---

### Question 47

A company is running AWS Glue ETL jobs that process 500 GB of data daily. The jobs take 3 hours to complete using 10 standard DPUs. The data team wants to reduce the processing time to under 1 hour.

Which optimizations improve Glue ETL performance? (Choose TWO.)

A. Use Glue job bookmarks to process only new data incrementally rather than reprocessing the entire dataset.

B. Increase the number of DPUs or switch to G.2X worker type (more memory per worker) and enable auto-scaling to dynamically adjust DPUs based on the workload.

C. Switch from PySpark to Python shell job type for faster execution.

D. Reduce the output file size by compressing with gzip.

E. Convert input data from CSV to Parquet format for more efficient columnar reads.

**Correct Answer: A, B**

**Explanation:** Job bookmarks (A) track what data has been processed, enabling incremental runs that only process new data—dramatically reducing volume for daily runs. More DPUs or larger workers (B) provide more parallelism and memory for processing, directly reducing execution time. Auto-scaling optimizes DPU usage. Option C (Python shell) is for lightweight scripts, not large-scale ETL. Option D (compression) reduces output size but doesn't speed up processing. Option E helps reads but conversion itself is additional work.

---

### Question 48

A company uses Amazon Kinesis Data Streams with 10 shards for data ingestion. During peak hours, they see ProvisionedThroughputExceededException errors. The current stream processes 5,000 records per second with an average record size of 10 KB.

What changes resolve the throughput exception?

A. Increase the record size to batch multiple records.

B. The current 10-shard stream supports 10,000 records/sec writes and 10 MB/sec ingest. At 5,000 records × 10 KB = 50 MB/sec, the stream exceeds the 10 MB/sec ingest limit. Increase the number of shards to at least 50 (50 MB/sec ÷ 1 MB/sec per shard). Additionally, implement partition key distribution optimization to avoid hot shards and enable enhanced fan-out for consumers.

C. Switch to Kinesis Data Firehose which has no throughput limits.

D. Reduce the number of consumers reading from the stream.

**Correct Answer: B**

**Explanation:** The throughput math shows: 5,000 records × 10 KB = 50 MB/sec, but 10 shards only support 10 MB/sec (1 MB/sec per shard). Increasing to 50+ shards resolves the ingest limit. Partition key optimization prevents hot shards (a common cause of throughput exceptions even when total capacity is sufficient). Option A doesn't reduce total throughput. Option C (Firehose) is a delivery service, not a direct replacement for Data Streams. Option D addresses consumer throughput, but the error is on the producer side.

---

### Question 49

A company is implementing a security monitoring solution that must detect the following threats in real-time: (1) cryptocurrency mining on EC2 instances, (2) unauthorized S3 bucket access from external accounts, (3) compromised EC2 instances communicating with known command-and-control servers, and (4) DNS exfiltration through unusual DNS query patterns.

Which SINGLE AWS service detects all four threat types?

A. Amazon Inspector.

B. Amazon GuardDuty which detects: CryptoCurrency:EC2/BitcoinTool.B (crypto mining), UnauthorizedAccess:S3/MaliciousIPCaller (unauthorized S3 access), Backdoor:EC2/C&CActivity.B (C&C communication), and Trojan:EC2/DNSDataExfiltration (DNS exfiltration). GuardDuty analyzes VPC Flow Logs, DNS logs, CloudTrail, and S3 data events using threat intelligence and ML.

C. AWS Security Hub.

D. Amazon Macie.

**Correct Answer: B**

**Explanation:** GuardDuty is the only single service that detects all four threat types using multiple data sources: CloudTrail for API-level threats, VPC Flow Logs for network-level threats (C&C, crypto mining), DNS logs for DNS-based threats (exfiltration), and S3 data events for unauthorized access. It uses threat intelligence feeds and ML-based anomaly detection. Option A (Inspector) scans for vulnerabilities. Option C (Security Hub) aggregates findings but doesn't detect threats directly. Option D (Macie) focuses on S3 data classification.

---

### Question 50

A company has implemented AWS CloudFormation for infrastructure deployment. After a recent update, a CloudFormation stack update failed, and the stack is now stuck in UPDATE_ROLLBACK_IN_PROGRESS for 2 hours. The event log shows a custom resource backed by a Lambda function that is timing out.

How should this situation be resolved?

A. Delete the CloudFormation stack and recreate it.

B. Identify the stuck custom resource from the CloudFormation events. Fix the Lambda function that backs the custom resource (it may be timing out because it's not sending a response to the CloudFormation callback URL). If the Lambda can't be fixed immediately, manually send a SUCCESS response to the CloudFormation callback URL using the pre-signed S3 URL from the custom resource event. This unblocks the rollback.

C. Wait for CloudFormation to eventually timeout and recover.

D. Contact AWS Support to manually fix the stack state.

**Correct Answer: B**

**Explanation:** CloudFormation custom resources require the Lambda function to send a SUCCESS or FAILED response to a pre-signed S3 URL. If the Lambda times out without responding, CloudFormation waits up to 1 hour (then retries). Manually sending a SUCCESS response to the callback URL immediately unblocks the rollback. Fixing the Lambda prevents future occurrences. Option A is destructive. Option C may eventually work but takes hours. Option D is slower than manual resolution.

---

### Question 51

A company runs an application with predictable traffic patterns: high traffic from 9 AM to 5 PM and minimal traffic overnight. The application uses an Auto Scaling group with target tracking scaling based on CPU utilization. Despite the predictable pattern, the application experiences performance issues every morning at 9 AM because the Auto Scaling group takes 10 minutes to scale up.

Which approach eliminates the morning performance degradation?

A. Lower the CPU target tracking value to trigger scaling earlier.

B. Implement predictive scaling on the Auto Scaling group. Predictive scaling uses ML to analyze historical traffic patterns and proactively scales the group before the anticipated demand increase. The instances are pre-provisioned before 9 AM traffic arrives. Keep target tracking as the reactive complement for unexpected spikes.

C. Increase the minimum capacity of the Auto Scaling group to handle peak load permanently.

D. Use scheduled scaling to increase capacity at 8:50 AM.

**Correct Answer: B**

**Explanation:** Predictive scaling analyzes historical patterns and pre-provisions capacity before demand increases. AWS ML models identify the daily traffic pattern and schedule capacity changes ahead of time. Combined with target tracking for unexpected variations, this provides both proactive and reactive scaling. Option A doesn't help—the issue is reaction time, not threshold. Option C wastes money overnight. Option D works but is rigid—predictive scaling adapts automatically to changing patterns.

---

### Question 52

A company's application makes millions of API calls per day to an external third-party API. The API has a rate limit of 100 requests per second. During peak hours, the application needs to make 500 requests per second. The company needs a solution to handle the rate limiting without losing requests.

Which architecture handles rate limiting gracefully?

A. Implement retry logic with exponential backoff in the application.

B. Place API requests in an Amazon SQS queue. A consumer Lambda function processes messages from the queue at a controlled rate (100 requests/second) using reserved concurrency to limit the number of concurrent invocations. For requests that need real-time responses, implement a caching layer (ElastiCache) that stores API responses with appropriate TTLs to serve repeated requests without hitting the API.

C. Purchase a higher rate limit from the third-party API provider.

D. Use API Gateway as a proxy with throttling set to 100 TPS.

**Correct Answer: B**

**Explanation:** SQS buffers excess requests (500/sec peak) and Lambda consumes at the controlled rate (100/sec). ElastiCache reduces the actual API calls by serving cached responses for repeated queries. Together, they handle 5x the rate limit through buffering and caching. Option A helps with transient failures but doesn't solve sustained over-limit scenarios. Option C may not be possible or affordable. Option D throttles your API but the third-party rate limit applies to outbound calls, not inbound.

---

### Question 53

A company runs a distributed application with components in both AWS and on-premises. They need end-to-end observability including: distributed tracing across AWS and on-premises components, unified metrics from both environments, and correlated log analysis. The solution must work with their existing Prometheus and Grafana setup on-premises.

Which AWS services provide hybrid observability?

A. Use CloudWatch exclusively for all monitoring.

B. Use AWS Distro for OpenTelemetry (ADOT) to collect traces and metrics from both AWS and on-premises components. Send traces to AWS X-Ray for distributed tracing visualization. Use Amazon Managed Prometheus to store metrics from both environments (on-premises Prometheus can remote-write to AMP). Use Amazon Managed Grafana with data sources for X-Ray, AMP, and CloudWatch for unified dashboards.

C. Deploy Datadog across both environments.

D. Use separate monitoring tools for each environment.

**Correct Answer: B**

**Explanation:** ADOT provides a vendor-neutral instrumentation agent for both AWS and on-premises. X-Ray handles distributed tracing across hybrid components. Amazon Managed Prometheus is compatible with existing Prometheus (on-premises can remote-write). Managed Grafana provides unified dashboards across all data sources, compatible with the team's existing Grafana skills. Option A doesn't work well for on-premises components. Option C adds third-party cost and dependency. Option D fragments observability.

---

### Question 54

A financial services company needs to migrate their on-premises IBM DB2 database to AWS. The database contains 5 TB of data with complex stored procedures and OLAP queries. The company wants to minimize licensing costs. The application primarily performs complex analytical queries with some transactional workloads.

Which target database and migration approach is MOST appropriate?

A. Migrate to Amazon RDS for DB2 to maintain compatibility.

B. Use AWS SCT to assess the DB2 database for conversion to Amazon Redshift (for analytics) and Amazon Aurora PostgreSQL (for transactional workloads). SCT converts DB2 stored procedures and SQL to target-compatible formats. Use DMS for data migration. This eliminates DB2 licensing.

C. Migrate to Amazon DynamoDB for all workloads.

D. Run DB2 on EC2 with BYOL.

**Correct Answer: B**

**Explanation:** Splitting the workload between Redshift (analytics) and Aurora PostgreSQL (transactions) optimizes each for its purpose while eliminating DB2 licensing. SCT handles schema and SQL conversion from DB2. DMS migrates data. This is a replatform that reduces costs significantly. Option A (RDS for DB2) doesn't exist—there's no RDS engine for DB2. Option C is unsuitable for complex analytical queries and stored procedures. Option D keeps licensing costs.

---

### Question 55

A company is migrating their on-premises VMware environment to AWS. They have 300 VMs running a mix of production and non-production workloads. The company wants to track migration progress, maintain dependency mapping, and ensure no applications are missed during the migration.

Which tool provides the BEST migration tracking and coordination?

A. Use a spreadsheet to track migration progress.

B. AWS Migration Hub as the central tracking service. Import server data from Application Discovery Service (agent-based discovery for detailed dependencies). Create migration waves in Migration Hub based on application groups and dependencies. Track each server's migration status (not started, in progress, completed) as they're migrated using AWS MGN. Use the Migration Hub dashboard for executive reporting on overall progress.

C. Use Jira tickets for each server migration.

D. Track migration in CloudFormation using stack status.

**Correct Answer: B**

**Explanation:** Migration Hub is purpose-built for tracking large-scale migrations. Application Discovery Service maps dependencies, Migration Hub organizes servers into application-grouped waves, and MGN integration automatically updates migration status. The dashboard provides real-time progress visibility. Option A doesn't integrate with migration tools. Option C tracks tasks but not technical migration state. Option D tracks infrastructure deployment, not the migration process.

---

### Question 56

A company wants to migrate their Oracle RAC (Real Application Clusters) database to AWS. Oracle RAC provides active-active database clustering for high availability and horizontal scaling. The database is 20 TB with high write throughput requirements.

Which AWS database configuration provides similar capabilities to Oracle RAC?

A. Amazon RDS for Oracle Single-AZ (RAC is not supported on RDS).

B. Amazon Aurora PostgreSQL or MySQL with multiple writer instances is not available in the standard Aurora offering. For Oracle RAC-equivalent functionality, the best option is to use Amazon Aurora PostgreSQL with a single writer and multiple readers, combined with Aurora Auto Scaling. For true multi-writer needs, consider redesigning the application tier with sharding on Aurora or using Amazon Aurora MySQL with the multi-master feature (deprecated). Most practically, migrate to Aurora PostgreSQL with application-level write distribution using a connection proxy.

C. Deploy Oracle RAC on EC2 instances with shared storage using Amazon FSx.

D. Use Amazon DynamoDB for active-active multi-node writes.

**Correct Answer: C**

**Explanation:** For a direct Oracle RAC migration with minimal application changes, deploying Oracle RAC on EC2 with FSx for shared storage is the most compatible option. EC2 supports the required network configuration (multicast alternatives) and FSx provides the shared storage RAC needs. This maintains Oracle RAC compatibility while moving to AWS infrastructure. Option A—RDS doesn't support RAC. Option B suggests alternatives but requires significant application changes. Option D is a NoSQL database that doesn't replace a relational RAC database.

---

### Question 57

A company is migrating 100 on-premises servers to AWS using AWS Application Migration Service (MGN). During testing, they find that 20 servers have boot issues after migration due to driver incompatibilities. The servers run various Linux distributions and Windows versions.

How should the boot issues be resolved?

A. Recreate the servers from scratch on EC2.

B. MGN includes a post-launch script capability. Use post-launch actions to run scripts that: install AWS drivers (ENA for enhanced networking, NVMe for EBS), update the bootloader configuration (GRUB for Linux), and install the EC2 launch agent. For persistent boot issues, launch the instance from the replicated disk, attach it as a secondary volume to a working instance, fix the boot configuration, detach, and create a new AMI.

C. Change the instance type to one that supports legacy drivers.

D. Wait for AWS to fix the driver compatibility automatically.

**Correct Answer: B**

**Explanation:** Post-launch scripts handle most driver compatibility issues automatically. For persistent boot failures, the secondary-volume technique allows fixing boot configuration (installing ENA/NVMe drivers, updating GRUB/BCD) from a working instance. This is the standard approach for resolving post-migration boot issues. Option A loses all server configuration and data. Option C may not resolve the underlying driver issue. Option D—AWS doesn't automatically fix guest OS driver issues.

---

### Question 58

A company needs to migrate their on-premises MongoDB cluster to AWS. The cluster stores 2 TB of document data, supports 50,000 operations per second, and uses MongoDB's aggregation framework extensively. The company wants a managed, MongoDB-compatible service.

Which AWS service and migration approach is MOST appropriate?

A. Migrate to Amazon DynamoDB using DMS.

B. Use Amazon DocumentDB (with MongoDB compatibility). Set up a DocumentDB cluster with appropriate instance sizes. Use AWS Database Migration Service with MongoDB as the source and DocumentDB as the target for full load plus CDC migration. Test aggregation framework queries for compatibility (DocumentDB supports most MongoDB 3.6/4.0 APIs).

C. Deploy self-managed MongoDB on EC2 instances.

D. Migrate to Amazon Aurora PostgreSQL with JSONB columns.

**Correct Answer: B**

**Explanation:** DocumentDB provides MongoDB-compatible APIs as a managed service. DMS migrates data from on-premises MongoDB with full load + CDC for minimal downtime. DocumentDB supports MongoDB's aggregation framework for common use cases. Option A (DynamoDB) is a different data model requiring application rewrites. Option C (self-managed MongoDB) maintains operational overhead. Option D requires significant schema and query conversion from MongoDB to relational SQL.

---

### Question 59

A company has a legacy application that communicates with an on-premises mainframe using MQ Series (IBM MQ) message queues. The application is being migrated to AWS, but the mainframe will remain on-premises for 3 more years. The application on AWS must continue to exchange messages with the mainframe's MQ Series.

Which solution maintains MQ compatibility during the hybrid period?

A. Replace IBM MQ with Amazon SQS and rewrite the mainframe messaging.

B. Deploy Amazon MQ with an IBM MQ-compatible broker (ActiveMQ with JMS or RabbitMQ with AMQP). Configure a network bridge between the on-premises IBM MQ broker and Amazon MQ over a Direct Connect or VPN connection. Alternatively, use an IBM MQ client library in the AWS application to connect directly to the on-premises MQ broker through the private connection.

C. Use Amazon EventBridge for mainframe messaging.

D. Implement a custom REST API wrapper around the mainframe's MQ interface.

**Correct Answer: B**

**Explanation:** Amazon MQ supports JMS (Java Message Service) which is compatible with IBM MQ's messaging model. A network bridge or direct client connection over Direct Connect/VPN maintains messaging between AWS and the on-premises mainframe. This preserves the messaging patterns without mainframe changes. Option A requires mainframe changes which are complex and risky. Option C doesn't support MQ protocols. Option D adds latency and changes the messaging pattern.

---

### Question 60

A company is migrating a data analytics workload from on-premises Cloudera to AWS. The workload includes: HDFS (200 TB), Hive tables with metadata, Spark ETL jobs, Impala interactive queries, and Kafka streaming ingestion. They want fully managed replacements for each component.

Which mapping of Cloudera components to AWS services is correct?

A. Run Cloudera on EC2 for a like-for-like migration.

B. HDFS → Amazon S3 (with AWS Glue Data Catalog replacing Hive Metastore). Hive → Amazon Athena (serverless SQL queries) or Amazon EMR with Hive. Spark ETL → AWS Glue or Amazon EMR Serverless. Impala → Amazon Athena (serverless interactive queries) or Amazon Redshift Spectrum. Kafka → Amazon MSK (Managed Streaming for Apache Kafka). Use DataSync to migrate HDFS data to S3.

C. Replace everything with Amazon Redshift.

D. Use Amazon Kinesis to replace all Cloudera components.

**Correct Answer: B**

**Explanation:** Each Cloudera component maps to an optimized AWS managed service: S3 replaces HDFS with better durability and no cluster dependency, Glue Data Catalog replaces Hive Metastore, Athena replaces Impala for interactive queries, Glue/EMR Serverless replaces Spark, and MSK replaces Kafka with full compatibility. DataSync efficiently transfers the 200 TB. Option A maintains operational overhead. Option C can't replace all components. Option D isn't a complete analytics platform.

---

### Question 61

A company's on-premises Active Directory contains 50,000 user accounts. They are migrating applications to AWS that require AD authentication. The company needs to maintain a single identity source and support both LDAP and Kerberos authentication for applications running on EC2 instances.

Which approach provides AD authentication for AWS applications?

A. Create IAM users for all 50,000 employees.

B. Deploy AWS Managed Microsoft AD in AWS and establish a two-way forest trust with the on-premises AD. Applications on EC2 authenticate against the Managed AD which resolves trust to on-premises AD for user verification. This supports both LDAP binds and Kerberos authentication natively.

C. Deploy AD Connector for all authentication needs.

D. Synchronize on-premises AD to Amazon Cognito User Pools.

**Correct Answer: B**

**Explanation:** AWS Managed Microsoft AD provides a full AD-compatible directory that supports LDAP and Kerberos natively. The forest trust with on-premises AD allows seamless authentication using existing credentials without synchronizing users. EC2 instances can join the Managed AD domain. Option A doesn't provide AD compatibility (LDAP/Kerberos). Option C (AD Connector) proxies to on-premises AD but doesn't support all AD features and adds latency for every auth request. Option D requires user synchronization and doesn't support LDAP/Kerberos.

---

### Question 62

A company needs to migrate their on-premises container workloads to AWS. The containers currently run on Docker Swarm with 50 services. The company wants to modernize to Kubernetes but has limited Kubernetes experience. They need a gradual migration path.

Which migration strategy provides the smoothest transition?

A. Rewrite all services for AWS Lambda.

B. Phase 1: Deploy Amazon EKS with managed node groups. Use AWS App2Container to analyze and containerize any non-containerized components. Phase 2: Convert Docker Compose files to Kubernetes manifests using kompose tool. Deploy services to EKS in batches, starting with stateless services. Phase 3: Migrate stateful services with persistent volumes using EBS CSI driver. Use AWS Load Balancer Controller for ingress. Throughout: use EKS Blueprints for cluster configuration best practices.

C. Migrate all 50 services to EKS simultaneously.

D. Deploy Docker Swarm on EC2 instances as a lift-and-shift.

**Correct Answer: B**

**Explanation:** Phased migration reduces risk: App2Container helps with non-containerized components, kompose converts Docker Compose to Kubernetes manifests, and deploying in batches (stateless first) builds team confidence. EKS Blueprints provide production-ready cluster configuration. Option A completely changes the compute model. Option C is high-risk for a team with limited Kubernetes experience. Option D doesn't modernize and Docker Swarm has limited AWS integration.

---

### Question 63

A company has been using On-Demand pricing for all their AWS resources. Their monthly bill is $200,000 consisting of: EC2 ($100,000 - 60% steady state, 40% variable), RDS ($40,000 - 90% steady state), ElastiCache ($15,000 - 100% steady state), Lambda ($10,000), S3 ($20,000), and other services ($15,000). They want to implement a comprehensive savings strategy.

Which purchasing strategy maximizes savings?

A. Purchase Reserved Instances for everything.

B. Compute Savings Plan: Commit to $60,000/month worth of EC2 compute (covering the 60% steady-state portion) at ~40% savings = save ~$24,000/month. RDS Reserved Instances: Purchase 1-year All Upfront RIs for the steady-state 90% = save ~$14,400/month. ElastiCache Reserved Nodes: Purchase 1-year for the 100% steady-state = save ~$6,000/month. S3 Intelligent-Tiering: Reduce storage costs by ~20% = save ~$4,000/month. Lambda: Optimize with Graviton and right-sizing = save ~$2,000/month. Total estimated savings: ~$50,400/month (25%).

C. Move all workloads to Spot Instances.

D. Negotiate an Enterprise Discount Program (EDP) with AWS.

**Correct Answer: B**

**Explanation:** A layered savings strategy addresses each service appropriately: Compute Savings Plans for EC2 flexibility, RIs for steady-state databases (RDS, ElastiCache), S3 tiering for storage, and Lambda optimization. Each commitment matches the predictable portion of that service's usage. Option A over-commits on variable workloads. Option C is unsuitable for production workloads. Option D may provide additional savings but typically requires $1M+ annual spend commitment.

---

### Question 64

A company processes real-time financial market data. They run 200 EC2 instances that consume data from Kinesis and write results to DynamoDB. The processing is stateless and can handle interruptions (data is reprocessed from the Kinesis checkpoint). The instances run 24/7 and are currently all On-Demand.

Which cost optimization strategy is MOST appropriate for this workload?

A. Use Reserved Instances for all 200 instances.

B. Use a mixed fleet: 40 On-Demand instances (20%) as a baseline guarantee, 160 Spot Instances (80%) with capacity-optimized allocation strategy. Configure Spot Fleet to maintain the target capacity by automatically replacing interrupted instances. The application's checkpoint-based design ensures no data loss on Spot interruptions.

C. Migrate to Lambda for processing.

D. Reduce to 100 instances and accept higher latency.

**Correct Answer: B**

**Explanation:** The workload is ideal for Spot: stateless, interruption-tolerant (Kinesis checkpoint recovery), and 24/7 usage. An 80/20 Spot/On-Demand mix provides cost savings of approximately 60-70% on the Spot portion while maintaining a baseline capacity guarantee. Capacity-optimized allocation strategy reduces interruption frequency. Option A (RIs) saves ~40% but Spot saves ~80-90% on the Spot portion. Option C—Lambda may not meet latency requirements for financial data. Option D impacts processing capacity.

---

### Question 65

A company discovers that their AWS Lambda functions are over-provisioned with memory. They have 200 Lambda functions, most configured with 1024 MB or 3008 MB of memory. Many functions only use 128-256 MB of actual memory during execution. The total Lambda cost is $8,000/month.

Which approach provides the MOST efficient Lambda cost optimization?

A. Set all functions to 128 MB memory.

B. Use AWS Lambda Power Tuning (an open-source tool) to analyze each function's optimal memory setting by running it at various memory configurations and measuring execution time and cost. Functions often have a "sweet spot" where cost is minimized (lower memory = slower but cheaper, higher memory = faster but more expensive). Apply the optimized memory setting to each function.

C. Reduce all functions to 512 MB as a compromise.

D. Monitor CloudWatch metrics for Lambda memory usage and manually adjust.

**Correct Answer: B**

**Explanation:** Lambda Power Tuning empirically determines the optimal memory configuration for each function by testing at multiple levels. It finds the balance where the function runs efficiently without over-provisioning. This data-driven approach can typically reduce Lambda costs by 30-50% for over-provisioned functions. Option A under-provisions—less memory means proportionally less CPU, potentially making functions run much longer and costing more. Option C is a blanket approach without data. Option D is manual and time-consuming for 200 functions.

---

### Question 66

A company uses Amazon Redshift with a 10-node dc2.8xlarge cluster ($130,000/year). They want to migrate to the newer RA3 node type. Their data warehouse contains 30 TB of data, but query analysis shows that only 5 TB is frequently accessed (hot data) while 25 TB is rarely queried (warm/cold data).

What is the cost benefit of migrating to RA3 nodes?

A. RA3 nodes cost the same as dc2 nodes.

B. Migrate to RA3 nodes which separate compute and storage. RA3 nodes use managed storage (RMS) that automatically caches hot data on local SSDs while storing cold data in S3. The 5 TB of hot data is cached locally for fast access, and the 25 TB of cold data is in S3 at much lower cost. With RA3, you may need fewer nodes since storage is decoupled—right-size based on compute needs, not storage needs.

C. Stay on dc2 nodes because they have local SSD storage.

D. Move cold data to a separate Redshift cluster.

**Correct Answer: B**

**Explanation:** RA3 nodes decouple compute from storage. Hot data (5 TB) is automatically cached on local SSD for fast access. Cold data (25 TB) is stored in S3 at S3 pricing. You size the cluster for compute needs (query concurrency/complexity), not storage—potentially fewer nodes needed. dc2 nodes store everything on local SSD, paying premium storage prices for rarely accessed data. Option C overpays for cold storage. Option D adds management complexity with two clusters.

---

### Question 67

A company runs a web application on EC2 instances behind an ALB. They use Amazon RDS with Multi-AZ for the database. The application is stateless with session data in ElastiCache. The company wants to implement cost-effective high availability that survives a single AZ failure.

Which configuration provides the MOST cost-effective HA setup?

A. Deploy across 2 AZs with equal capacity in each. Auto Scaling minimum of 4 instances (2 per AZ).

B. Deploy across 3 AZs with Auto Scaling. Set minimum to 3 instances (1 per AZ) with maximum of 9. Configure the Auto Scaling group to balance across AZs. If one AZ fails, the remaining 2 AZs handle the load with Auto Scaling adding instances. RDS Multi-AZ is already cross-AZ. ElastiCache with cluster mode enabled across AZs.

C. Deploy in a single AZ with Auto Recovery enabled for all instances.

D. Deploy across 2 AZs with 100% excess capacity in each AZ to handle AZ failure.

**Correct Answer: B**

**Explanation:** Three AZs with balanced distribution means losing one AZ only impacts 33% of capacity (vs 50% with 2 AZs). Auto Scaling adds instances in the remaining AZs to restore capacity. Starting with 3 instances (minimum needed for HA) keeps baseline costs low. Option A with 2 AZs requires 2x capacity in each (4 total) to survive an AZ loss—more expensive. Option C has no AZ redundancy. Option D over-provisions by 100% in each AZ.

---

### Question 68

A company uses Amazon CloudWatch and has created 500 custom CloudWatch dashboards. They are paying $3/month per dashboard ($1,500/month total). Many dashboards have overlapping widgets and are rarely viewed.

How should dashboard costs be optimized?

A. Delete all dashboards and use CLI queries.

B. Audit dashboard usage using CloudWatch API (GetDashboard call logs in CloudTrail) to identify unused dashboards. Consolidate overlapping dashboards by creating comprehensive dashboards with variables/parameters that allow switching between applications. Implement CloudWatch cross-account dashboards to consolidate multi-account views. Target reducing to 50-100 dashboards.

C. Switch to a third-party monitoring tool.

D. Keep all dashboards—$1,500/month is negligible.

**Correct Answer: B**

**Explanation:** CloudTrail shows which dashboards are actually being viewed. Consolidating overlapping dashboards with variables (e.g., an application selector dropdown) reduces the count significantly. Cross-account dashboards eliminate per-account duplicates. Reducing from 500 to 50-100 dashboards saves $1,200-$1,350/month. Option A removes all visibility. Option C may not reduce costs. Option D ignores savings that are easily achievable.

---

### Question 69

A company is running Amazon ElastiCache for Redis with 10 r5.2xlarge nodes in a cluster. Analysis shows that memory usage averages 30% across nodes, and CPU averages 15%. The cluster costs $25,000/month.

Which optimization reduces ElastiCache costs?

A. Switch to t3.medium nodes for burstable performance.

B. Right-size the cluster by reducing to r5.large nodes (same family, smaller size) which provides 25% of the current memory per node. With 30% average memory usage across 10 r5.2xlarge nodes (each with 52.82 GB = 528 GB total, 158 GB used), right-sizing to r5.large (13.21 GB each) would need ~12 r5.large nodes. Additionally, purchase Reserved Nodes (1-year) for the right-sized cluster for additional ~40% savings.

C. Delete the ElastiCache cluster and use DynamoDB instead.

D. Disable replication to reduce the number of nodes.

**Correct Answer: B**

**Explanation:** Right-sizing from r5.2xlarge to r5.large reduces per-node cost by ~75% while accommodating the 30% memory utilization with some headroom. Reserved Nodes add ~40% savings on the right-sized nodes. Combined savings can be 60-70%. Option A (t3) may have inconsistent performance for Redis workloads. Option C changes the data store architecture. Option D reduces availability.

---

### Question 70

A company runs a data pipeline that uses AWS Glue for ETL processing. Their monthly Glue costs are $10,000. The jobs run on 20 standard DPUs but analysis shows that jobs are only running 30% of each hour they're allocated, with 70% idle time within the DPU-hour billing period.

Which approach reduces Glue costs?

A. Switch to Glue 4.0 with auto-scaling enabled. Auto-scaling dynamically adjusts the number of workers based on the workload's actual needs, reducing idle DPU time. Also enable Glue Flex execution which uses spare capacity at lower cost for non-time-sensitive jobs.

B. Increase the number of DPUs to process data faster.

C. Switch from Glue to EMR for all ETL.

D. Run Glue jobs less frequently.

**Correct Answer: A**

**Explanation:** Glue auto-scaling in version 4.0 dynamically adjusts workers during job execution, eliminating idle DPU time. Glue Flex execution uses spare capacity at reduced cost for jobs that can tolerate variable start times. Together, these optimize both DPU utilization and pricing. Option B increases cost without addressing utilization. Option C requires managing infrastructure. Option D may not meet processing requirements.

---

### Question 71

A company pays $50,000/month for Amazon Kinesis Data Streams across 20 streams. Most streams have 50 shards but traffic analysis shows that many shards are underutilized during off-peak hours while being at capacity during peak hours.

Which Kinesis cost optimization provides the MOST savings?

A. Reduce the number of shards permanently.

B. Enable Kinesis on-demand capacity mode for streams with variable traffic patterns. On-demand mode automatically scales shard count based on throughput, eliminating the need to over-provision for peak capacity. For streams with consistent, predictable traffic, keep provisioned mode and right-size the shard count. Monitor with CloudWatch's IncomingBytes and IncomingRecords metrics.

C. Switch all streams to Amazon MSK.

D. Consolidate all 20 streams into a single stream.

**Correct Answer: B**

**Explanation:** Kinesis on-demand mode scales shards automatically—no over-provisioning for peaks. During off-peak, fewer shards are active, reducing cost. For predictable streams, provisioned mode with right-sized shards is more cost-effective. The hybrid approach optimizes each stream based on its traffic pattern. Option A causes throttling during peaks. Option C requires application changes for a different API. Option D complicates consumer routing and increases processing complexity.

---

### Question 72

A company uses AWS Transit Gateway to connect 30 VPCs. They pay $0.05 per GB of data processed through the transit gateway. Monthly data processing charges are $15,000 (300 TB). Analysis shows that 60% of transit gateway traffic is between VPCs in the same AZ that could communicate directly.

Which optimization reduces transit gateway data processing costs?

A. Remove the transit gateway and use VPC peering for all connections.

B. For VPCs that communicate frequently and are in the same account/Region, implement VPC peering as a supplementary path alongside transit gateway. Configure route tables to prefer the VPC peering route for specific high-traffic VPC pairs. VPC peering has no data processing charge (only standard inter-AZ or cross-AZ transfer rates apply). Keep transit gateway for VPCs needing hub-and-spoke routing or inspection.

C. Move all workloads to a single VPC.

D. Implement data compression on all transit gateway traffic.

**Correct Answer: B**

**Explanation:** VPC peering for high-traffic pairs eliminates the $0.05/GB transit gateway data processing charge for that traffic. The 60% of same-AZ traffic moved to peering saves approximately $9,000/month (180 TB × $0.05). Transit gateway remains for routing that requires central management or inspection. Option A removes hub-and-spoke capabilities and doesn't scale to 30 VPCs. Option C is impractical for 30 VPCs worth of resources. Option D doesn't reduce the per-GB charge.

---

### Question 73

A company has been running the same CloudFormation stacks for 2 years without reviewing the resource configurations. Instance types, storage sizes, and other parameters haven't been updated to take advantage of newer, more cost-effective options.

Which comprehensive review process identifies cost savings in existing infrastructure?

A. Manually review each CloudFormation template.

B. Use AWS Trusted Advisor for cost optimization recommendations. Use AWS Compute Optimizer for EC2 and Lambda right-sizing. Use S3 Storage Lens for storage optimization. Use RDS Performance Insights to identify over-provisioned databases. Generate a comprehensive optimization report and update CloudFormation templates with the recommended changes. Deploy updates through the existing CI/CD pipeline.

C. Delete all stacks and recreate with default settings.

D. Use AWS Cost Explorer recommendations only.

**Correct Answer: B**

**Explanation:** A multi-tool approach provides comprehensive optimization: Trusted Advisor identifies idle resources and general optimization opportunities, Compute Optimizer provides ML-based right-sizing for EC2/Lambda, Storage Lens analyzes S3 patterns, and Performance Insights identifies database optimization opportunities. Updating CloudFormation ensures changes are tracked and repeatable. Option A is time-consuming and may miss opportunities. Option C is destructive. Option D provides limited recommendations compared to the multi-tool approach.

---

### Question 74

A company discovers that their data transfer costs between AWS and their on-premises data center are $30,000/month over their Direct Connect connection. The traffic consists of: database replication (40%), file transfers (30%), API calls (20%), and backup data (10%).

Which strategies reduce hybrid data transfer costs? (Choose TWO.)

A. Implement data compression for database replication streams to reduce the bytes transferred. Configure DMS with LOB handling optimization and parallel load settings.

B. Use AWS DataSync with compression and data deduplication for file transfers, which can reduce transferred data by 40-60%.

C. Increase Direct Connect bandwidth for lower per-GB pricing.

D. Move all workloads to AWS to eliminate hybrid data transfer.

E. Use CloudFront for API response caching to reduce repeated data transfer.

**Correct Answer: A, B**

**Explanation:** Database replication compression (A) reduces the 40% of traffic that's replication data. DataSync with compression and deduplication (B) reduces the 30% that's file transfers—DataSync only transfers changed data and compresses in transit. Together, they target 70% of the traffic. Option C—Direct Connect pricing is based on port speed commitment, not per-GB (data transfer out still applies). Option D is a major initiative, not a cost optimization tactic. Option E applies to outbound API responses which may be a small portion of total transfer.

---

### Question 75

A company's AWS bill includes $8,000/month for Amazon CloudWatch. The breakdown is: $3,000 for custom metrics, $2,500 for log storage, $1,500 for dashboards, and $1,000 for alarms. The company wants to reduce CloudWatch costs by 40%.

Which combination of optimizations achieves the target? (Choose THREE.)

A. Reduce custom metric resolution from high-resolution (1-second) to standard (60-second) for non-critical metrics, reducing metric costs by ~50%.

B. Set CloudWatch Logs retention periods to 30 days instead of indefinite. Archive logs older than 30 days to S3 for long-term retention at much lower cost.

C. Consolidate dashboards from 500 to 100 as discussed earlier—save 80% on dashboard costs.

D. Replace all CloudWatch alarms with manual monitoring.

E. Increase alarm evaluation periods to reduce alarm costs.

F. Use CloudWatch Embedded Metric Format to reduce PutMetricData API calls.

**Correct Answer: A, B, C**

**Explanation:** Reducing metric resolution (A) saves ~$1,500 (50% of $3,000). Setting log retention to 30 days with S3 archival (B) saves ~$1,500-2,000 (60-80% of $2,500 as most cost is long-term storage). Dashboard consolidation (C) saves ~$1,200 (80% of $1,500). Total savings: ~$4,200-$4,700 (~53-59%), exceeding the 40% target of $3,200. Option D removes monitoring capability. Option E has minimal cost impact. Option F reduces API costs but not metric storage costs.

---

## End of Practice Test 4

**Scoring Guide:**
- Each question is worth 1 point
- Total possible score: 75
- Approximate passing score: 54/75 (72%)
- Domain 1 (Q1-20): ___/20
- Domain 2 (Q21-42): ___/22
- Domain 3 (Q43-53): ___/11
- Domain 4 (Q54-62): ___/9
- Domain 5 (Q63-75): ___/13
