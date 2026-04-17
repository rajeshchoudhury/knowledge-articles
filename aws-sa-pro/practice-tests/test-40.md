# AWS SAP-C02 Practice Test 40 — Mixed Comprehensive Exam

> **Theme:** Exam simulation with realistic time pressure scenarios — all domains covered  
> **Questions:** 75 | **Time Limit:** 180 minutes  
> **Domain Distribution:** D1 ≈ 20 | D2 ≈ 22 | D3 ≈ 11 | D4 ≈ 9 | D5 ≈ 13

---

### Question 1
A global retail company operates in 8 AWS Regions with a multi-account architecture managed by AWS Organizations. They need to deploy a consistent security baseline (GuardDuty, Security Hub, Config rules, CloudTrail) to all existing and future accounts automatically. The solution must handle account creation events and apply baselines within minutes. What should the solutions architect recommend?

A) Manually configure each new account when it's created.  
B) Use AWS Control Tower with Customizations for Control Tower (CfCT). Control Tower provides the landing zone with built-in guardrails and Account Factory for provisioned accounts. CfCT deploys custom CloudFormation StackSets (GuardDuty, Security Hub, Config rules) automatically when new accounts are created via lifecycle events. Use Control Tower's organizational governance to enforce mandatory guardrails.  
C) Write a Lambda function triggered by Organizations CreateAccount events.  
D) Use AWS Service Catalog to provide pre-configured account templates.

**Correct Answer: B**
**Explanation:** Control Tower + CfCT provides the most comprehensive automated baseline deployment. Control Tower handles landing zone governance with mandatory and elective guardrails. CfCT extends the baseline with custom resources deployed via StackSets triggered by account lifecycle events. Account Factory ensures every new account gets the baseline automatically. Option A doesn't scale. Option C works but doesn't include the governance framework. Option D provides templates but doesn't enforce baseline deployment.

---

### Question 2
A healthcare SaaS company needs to deploy their application in a way that each hospital customer's data is completely isolated, encrypted with customer-specific keys, and stored in the customer's preferred AWS Region. They have 500 hospital customers. The application code is identical for all customers. What multi-tenant architecture should the architect design?

A) Deploy separate AWS accounts for each of the 500 customers.  
B) Use a pool model with logical isolation: deploy shared ECS/EKS infrastructure in each required Region. Implement tenant isolation using DynamoDB with tenant ID as the partition key, S3 with tenant-specific prefixes, and KMS encryption context with tenant ID for per-tenant encryption keys. Route tenant data to the appropriate Region using Amazon Route 53 with geolocation routing. Use IAM policies with conditions (dynamodb:LeadingKeys, s3:prefix, kms:EncryptionContext) to enforce data isolation at the API level.  
C) Deploy a single-Region application and replicate data globally.  
D) Use separate VPCs per tenant within a shared account.

**Correct Answer: B**
**Explanation:** The pool model with logical isolation balances cost efficiency (shared infrastructure) with security (per-tenant encryption, API-level isolation). KMS encryption context ensures data encrypted for hospital A can't be decrypted in hospital B's context. IAM conditions enforce isolation at the AWS API layer (defense beyond application code). Multi-Region routing places data in the customer's preferred Region. Option A is extremely expensive for 500 customers. Option C violates data residency requirements. Option D adds networking complexity without improving isolation.

---

### Question 3
A financial services company runs a trading platform that requires sub-millisecond latency for order execution. The application runs on EC2 instances in a single AZ. They need to improve availability without significantly increasing latency. Current architecture uses placement groups and EFA-enabled instances. What should the architect recommend?

A) Deploy across 3 AZs with an ALB for even distribution.  
B) Maintain the single-AZ primary deployment with cluster placement group and EFA for ultra-low-latency trading. Add a warm standby in a second AZ with the same instance configuration but in a stopped or minimized state. Use Route 53 health checks with failover routing — if the primary AZ health check fails, Route 53 automatically routes to the warm standby AZ. Accept the slightly higher latency during failover. Pre-provision the capacity reservation in the standby AZ to guarantee instance availability.  
C) Use AWS Local Zones for the standby.  
D) Deploy on AWS Outposts for guaranteed local compute.

**Correct Answer: B**
**Explanation:** Ultra-low-latency trading requires single-AZ for minimal network hops (placement group + EFA). Multi-AZ adds cross-AZ latency (~1-2ms) which is unacceptable during normal operation. The warm standby approach maintains near-zero latency in normal operation while providing automated failover to the second AZ during failures. Capacity reservations guarantee instances are available when needed. Option A adds latency to every trade. Option C — Local Zones may not have the required instance types. Option D requires physical infrastructure.

---

### Question 4
A media company processes video files that are uploaded by content creators. After upload, videos go through transcoding (1-4 hours), quality analysis (30 min), and thumbnail generation (5 min). The pipeline must handle 500 concurrent uploads during peak hours and scale to zero during off-hours. Processing order doesn't matter. What architecture should the architect design?

A) Deploy EC2 instances in an ASG that processes videos directly.  
B) Build an event-driven pipeline: S3 upload event → EventBridge rule → Step Functions state machine (orchestrator). Step Functions invokes: (1) AWS Elemental MediaConvert for transcoding (managed, serverless). (2) Lambda function triggers Amazon Rekognition for quality analysis (content moderation, scene detection). (3) Lambda for thumbnail generation using Rekognition's frame-level analysis or FFmpeg in a container. Each step uses managed/serverless services that scale automatically. Step Functions manages retries, error handling, and parallel processing.  
C) Use a single large EC2 instance with FFmpeg for all processing.  
D) Deploy Kubernetes with custom transcoding pods.

**Correct Answer: B**
**Explanation:** Event-driven architecture with managed services handles the variable load (500 peak, zero off-hours) efficiently. MediaConvert scales transcoding automatically (no infrastructure management). Rekognition handles quality analysis. Step Functions orchestrates the multi-step pipeline with error handling. Everything scales to zero when idle. Option A requires managing scaling and transcoding software. Option C is a single point of failure. Option D adds Kubernetes operational overhead for a batch processing pipeline.

---

### Question 5
A company is migrating a legacy Oracle database (20TB) to Amazon Aurora PostgreSQL. The migration must minimize downtime to under 1 hour. The Oracle database uses Oracle-specific features (PL/SQL packages, materialized views, database links). What migration approach should the architect recommend?

A) Do a full database dump and restore, accepting the extended downtime.  
B) Implement a phased migration: (1) Use AWS Schema Conversion Tool (SCT) to convert Oracle PL/SQL packages, materialized views, and other objects to Aurora PostgreSQL equivalents. Manually refactor code that SCT can't automatically convert. (2) Use AWS DMS (Database Migration Service) for continuous data replication — full load + CDC (Change Data Capture) from Oracle to Aurora PostgreSQL. (3) Set up DMS ongoing replication to keep Aurora PostgreSQL in sync during the testing phase. (4) Validate data integrity using DMS validation. (5) Cutover: stop the Oracle application, wait for DMS to catch up (minutes), switch the application connection to Aurora PostgreSQL. Downtime = DMS catch-up + application restart (under 1 hour).  
C) Use RDS for Oracle to avoid the PostgreSQL conversion.  
D) Rewrite the entire application from scratch for Aurora.

**Correct Answer: B**
**Explanation:** SCT + DMS provides the standard heterogeneous database migration path. SCT converts schema and code objects. DMS handles data migration with CDC for minimal downtime — the database stays in sync during the weeks of testing. The final cutover requires only the CDC catch-up time (minutes) plus application restart. This meets the <1-hour downtime requirement. Option A has unacceptable downtime for 20TB. Option C doesn't modernize (still Oracle licensing). Option D is excessive when SCT handles most conversion.

---

### Question 6
A company operates a real-time bidding platform for digital advertising. They receive 1 million bid requests per second, and each request must be processed within 100ms. The system must evaluate bidding rules, check budget limits, and return a bid or no-bid response. What architecture handles this scale and latency?

A) API Gateway with Lambda processing each bid request.  
B) Deploy the bid evaluation service on EC2 instances in a cluster placement group behind an NLB (for lowest latency). Use ElastiCache for Redis to store bidding rules and budget limits (sub-millisecond reads). Auto Scaling group scales based on NLB RequestCount metrics. Use Kinesis Data Streams to asynchronously log all bid decisions for analytics. Pre-compute bidding rules and cache them in Redis to eliminate database calls in the hot path.  
C) Use DynamoDB for each bid lookup.  
D) Deploy on ECS Fargate with auto-scaling.

**Correct Answer: B**
**Explanation:** At 1M requests/second with 100ms latency, the architecture must minimize every processing step. NLB provides the lowest latency (Layer 4). ElastiCache for Redis enables sub-millisecond reads of bidding rules and budgets. Placement groups minimize network latency. Pre-computed rules eliminate processing time. Asynchronous logging via Kinesis avoids blocking the bid path. Option A — Lambda has cold start and concurrency limits at this scale. Option C — DynamoDB adds 1-5ms per call, which is significant at this latency target. Option D — Fargate has higher network overhead than EC2.

---

### Question 7
A company uses AWS Organizations with 100 accounts. They want to share common VPC infrastructure (Transit Gateway, shared subnets) with member accounts while preventing member accounts from modifying the shared resources. What should the architect configure?

A) Create the resources in each member account independently.  
B) Use AWS Resource Access Manager (RAM) to share resources from a central networking account: (1) Share Transit Gateway with the Organization for VPC attachments. (2) Share VPC subnets from the networking account with specific OUs using RAM (VPC sharing). (3) Member accounts can launch resources in shared subnets but cannot modify subnet configuration, route tables, or NACLs. (4) Use SCPs to deny RAM-related modification actions (ram:DisassociateResourceShare) in member accounts. (5) The networking account maintains full control over all shared infrastructure.  
C) Use VPC peering between all 100 accounts.  
D) Deploy CloudFormation StackSets to create identical resources in each account.

**Correct Answer: B**
**Explanation:** RAM enables resource sharing without duplication. Transit Gateway sharing allows member accounts to attach VPCs without managing TGW. VPC subnet sharing allows member accounts to launch resources (EC2, RDS, Lambda) in centrally managed subnets. Member accounts cannot modify shared VPC resources (route tables, NACLs). SCPs prevent accounts from disassociating from shared resources. This provides centralized network governance. Option A lacks centralized control. Option C doesn't scale to 100 accounts. Option D duplicates resources.

---

### Question 8
A company's e-commerce application experiences a traffic spike every Black Friday (10x normal load). They want to ensure the application scales to handle the spike without manual intervention. The application runs on ECS Fargate with Aurora and ElastiCache. Past Black Fridays have seen Aurora reader endpoint failures due to connection exhaustion. What should the architect prepare?

A) Manually add Aurora replicas and increase ECS task count before Black Friday.  
B) Implement proactive and reactive scaling: (1) ECS Application Auto Scaling with target tracking on CPU and custom metrics (request latency). (2) Aurora Auto Scaling for read replicas (scale out on CPU > 70%). (3) RDS Proxy to manage database connection pooling — prevents connection exhaustion by multiplexing application connections to fewer database connections. (4) ElastiCache for Redis with auto-scaling (replicas for read scaling). (5) Schedule-based scaling — use predictive scaling or scheduled actions to pre-scale before the expected traffic spike. (6) Load test the Black Friday scenario using distributed load testing solution to validate scaling behavior. (7) Service quotas — pre-request limit increases for ECS tasks, Fargate vCPUs, Aurora instances.  
C) Over-provision for peak year-round.  
D) Use Lambda instead of ECS for automatic scaling.

**Correct Answer: B**
**Explanation:** The comprehensive approach addresses every bottleneck: ECS auto-scaling handles compute. Aurora Auto Scaling adds readers. RDS Proxy prevents the connection exhaustion that caused past failures. ElastiCache scaling handles cache load. Scheduled/predictive scaling ensures capacity is ready before the spike (reactive scaling has a lag). Load testing validates the scaling configuration. Service quota increases prevent hitting AWS limits during the spike. Option A is manual. Option C wastes money for 364 days. Option D may not handle the connection management complexity.

---

### Question 9
A company needs to implement a disaster recovery strategy for their critical application. The RPO is 15 minutes and RTO is 1 hour. The application uses EC2 instances, Aurora MySQL, and S3. The primary Region is us-east-1 and DR Region is us-west-2. What DR architecture meets these requirements most cost-effectively?

A) Pilot light — deploy minimal infrastructure in us-west-2.  
B) Warm standby with Aurora Global Database: (1) Aurora Global Database with a secondary cluster in us-west-2 (replication lag < 1 second, meeting 15-minute RPO). (2) S3 Cross-Region Replication for object data. (3) Pilot light infrastructure in us-west-2: AMIs replicated, launch templates ready, Auto Scaling groups configured but with 0 desired count. (4) Route 53 health checks on primary Region with failover routing to DR Region. (5) On failover: promote Aurora secondary to standalone (takes ~1 minute), start EC2 instances in us-west-2 ASG (takes ~5-10 minutes), Route 53 failover routes traffic. Total RTO: ~15-20 minutes. (6) CloudFormation templates in us-west-2 for any additional infrastructure.  
C) Active-active multi-Region deployment.  
D) Backup and restore from S3 snapshots.

**Correct Answer: B**
**Explanation:** This design provides a warm standby that meets RPO (Aurora Global Database < 1s replication + S3 CRR) and RTO (Aurora promotion ~1 min + EC2 launch ~10 min < 1 hour). It's cost-effective because the DR Region runs minimal infrastructure until failover. Aurora Global Database is the key — it provides near-synchronous replication without the cost of a full active-active setup. Option A — pilot light may exceed the RTO depending on infrastructure complexity. Option C meets requirements but is significantly more expensive. Option D — restore from snapshots likely exceeds both RPO and RTO.

---

### Question 10
A company wants to implement a data lake on AWS. They receive data from multiple sources: real-time clickstream data (100GB/day), daily database exports (500GB), weekly log files (1TB), and monthly reports from third-party APIs. They need to query this data using SQL and build ML models on it. What architecture should the architect design?

A) Store everything in a single RDS database.  
B) Build a layered data lake on S3: (1) Ingestion — Kinesis Data Firehose for real-time clickstream, AWS DMS for database exports, S3 Transfer Acceleration for log files, Lambda for API data pulls. (2) Storage — S3 with three zones: raw (landing), processed (cleansed), and curated (analytics-ready). Use Apache Parquet format for analytical data. (3) Cataloging — AWS Glue Data Catalog with crawlers to discover and catalog schemas. (4) Processing — AWS Glue ETL jobs for batch transformation, Kinesis Data Analytics for real-time processing. (5) Query — Amazon Athena for ad-hoc SQL queries on S3, Amazon Redshift Spectrum for complex analytical queries. (6) ML — Amazon SageMaker reading directly from S3 data lake. (7) Governance — Lake Formation for access control and data sharing.  
C) Use Amazon Redshift as the sole data store.  
D) Store all data in DynamoDB.

**Correct Answer: B**
**Explanation:** The layered data lake provides a comprehensive solution for diverse data sources and access patterns. S3 is the cost-effective, scalable foundation. Multiple ingestion services handle different data sources and velocities. The raw→processed→curated zones enable data quality improvement. Glue catalogs everything for discovery. Athena provides serverless SQL. SageMaker connects directly to S3 for ML. Lake Formation provides governance. Option A can't handle the volume or variety. Option C is expensive for storage (vs. S3) and doesn't handle real-time. Option D is not designed for analytical queries.

---

### Question 11
A company runs a SaaS application that stores customer data. A customer requests complete data deletion under GDPR's "right to erasure." The customer's data exists in DynamoDB, S3, ElastiCache, CloudWatch Logs, and backup snapshots. What should the architect implement to handle this request?

A) Delete the customer's DynamoDB items and S3 objects and consider it done.  
B) Implement a comprehensive data deletion pipeline: (1) DynamoDB — delete all items with the customer's partition key. Use DynamoDB Streams to confirm deletion. (2) S3 — delete all objects with the customer's prefix. Delete all version markers (if versioning is enabled). (3) ElastiCache — invalidate/delete all cached data for the customer. (4) CloudWatch Logs — use CloudWatch Logs data protection policies or delete specific log streams containing customer data. (5) Backups — flag the customer for exclusion from future restores (you cannot selectively delete from point-in-time backups, but document this in your data retention policy). (6) Audit — create a data deletion certificate/record proving when and what was deleted. (7) Downstream systems — propagate deletion events via EventBridge to all systems that received the customer's data.  
C) Delete the customer's AWS account.  
D) Encrypt the customer's data with a key that is then deleted (crypto-shredding).

**Correct Answer: B**
**Explanation:** GDPR erasure requires deletion from all systems storing the customer's data. The pipeline must cover primary stores (DynamoDB, S3), caches (ElastiCache), logs (CloudWatch), and propagate to downstream systems. Backups present a challenge — document the retention policy and exclude the customer from future restores. The deletion certificate provides audit proof. Option A misses caches, logs, and backups. Option C — customers don't have their own AWS accounts in a SaaS model. Option D (crypto-shredding) is valid for some scenarios but doesn't address caches and logs.

---

### Question 12
A company operates a fleet of 1,000 IoT devices that send telemetry data to AWS. Each device sends data every 5 seconds. They need to process data in real-time for anomaly detection and store it for historical analysis. The solution must handle device connectivity issues gracefully (messages must not be lost). What architecture should the architect design?

A) Devices send data directly to a Lambda function via API Gateway.  
B) Deploy an IoT data pipeline: (1) AWS IoT Core as the MQTT broker — devices publish to MQTT topics. IoT Core handles connection management and offline message queuing. (2) IoT Core rules engine routes messages to Kinesis Data Streams for real-time processing. (3) Lambda function on Kinesis performs anomaly detection using Amazon Lookout for Metrics or SageMaker inference endpoint. (4) Kinesis Data Firehose delivers data to S3 in Parquet format for historical storage. (5) AWS Glue Data Catalog catalogs the S3 data. (6) Amazon Athena for historical analysis queries. (7) IoT Device Shadow maintains last-known state for each device during connectivity gaps.  
C) Use SQS for message ingestion from all devices.  
D) Store all data directly in DynamoDB as it arrives.

**Correct Answer: B**
**Explanation:** IoT Core provides managed MQTT with QoS guarantees — messages aren't lost during connectivity issues. Device Shadow maintains state during offline periods. Kinesis provides ordered, real-time stream processing for anomaly detection. Firehose handles cost-effective storage to S3. The architecture handles 200K messages/second (1000 devices × 1 msg/5 sec = 200/sec, well within limits). Option A — API Gateway/Lambda adds HTTPS overhead for IoT devices and doesn't handle offline scenarios. Option C — SQS doesn't support MQTT. Option D is expensive for high-frequency IoT writes.

---

### Question 13
A company wants to implement a blue/green deployment for their entire application stack (ECS services, Aurora database, ElastiCache) — not just the application code. They want to test the complete stack before switching production traffic. How should the architect design this?

A) Deploy the new stack in the same environment and cut over manually.  
B) Use Route 53 weighted routing with full stack duplication: (1) Deploy the green stack as a complete parallel environment in the same Region (new ECS services, new Aurora cluster restored from snapshot, new ElastiCache cluster). (2) Aurora clone for the green database (instant, space-efficient copy using Aurora's copy-on-write). (3) Test the green stack independently. (4) Route 53 weighted routing: start with 0% to green, gradually increase (1% → 10% → 50% → 100%). (5) Monitor green stack's error rates and latency at each weight increment. (6) If issues are detected, shift weight back to 100% blue (rollback). (7) Once green is at 100%, decommission the blue stack.  
C) Use CloudFormation stack updates to change the live environment.  
D) Deploy the green stack in a different Region.

**Correct Answer: B**
**Explanation:** Full stack blue/green provides the safest deployment — the entire stack (compute, database, cache) is tested in isolation before receiving production traffic. Aurora clone creates an instant, full database copy for the green environment. Weighted routing provides fine-grained traffic control. Each weight increment allows monitoring before proceeding. Rollback is instant (shift weight to blue). Option A risks testing in production. Option C modifies the live stack (not blue/green). Option D adds cross-Region complexity and latency.

---

### Question 14
A company is implementing a data mesh architecture on AWS. Each business domain (sales, marketing, inventory) should own their data, expose it as data products, and consume other domains' data products. Centralized governance should enforce quality standards without centralizing data ownership. What should the architect design?

A) Centralize all data in a single data warehouse owned by the data team.  
B) Implement a federated data mesh: (1) Each domain gets its own AWS account with S3 data lake, Glue for ETL, and Glue Data Catalog for their data products. (2) AWS Lake Formation provides centralized governance — a central governance account defines data quality rules, access policies, and sharing permissions. (3) Lake Formation data sharing allows domains to share specific tables/databases with other domains across accounts. (4) Each domain publishes data products (curated datasets in S3) with schema documentation in Glue Data Catalog. (5) Amazon DataZone provides a data marketplace where domains can discover and request access to other domains' data products. (6) Central governance account runs data quality checks using Glue Data Quality.  
C) Use a single Redshift cluster for all domains.  
D) Allow each domain to manage data independently without governance.

**Correct Answer: B**
**Explanation:** Data mesh decentralizes data ownership while centralizing governance. Each domain controls their data infrastructure and publishes curated data products. Lake Formation provides centralized access control and cross-account sharing. DataZone provides a self-service data marketplace for discovery and access requests. Glue Data Quality enforces standards. This balances domain autonomy with organizational governance. Option A centralizes ownership (opposite of data mesh). Option C creates bottleneck. Option D lacks governance.

---

### Question 15
A company runs a customer-facing mobile application backend on AWS. They observe that on Monday mornings, the application experiences degraded performance for the first 30 minutes as auto-scaling catches up with the sudden traffic increase. The application runs on ECS Fargate. What should the architect do to eliminate the Monday morning performance degradation?

A) Increase the minimum task count to handle Monday peak permanently.  
B) Implement predictive and scheduled scaling: (1) Create a scheduled auto-scaling action that increases the ECS desired count before Monday morning traffic (e.g., 6:30 AM). (2) Use Application Auto Scaling with target tracking for reactive scaling during the day. (3) Enable ECS Service Auto Scaling step scaling for rapid scale-out (scale faster than target tracking). (4) For the ALB, enable pre-warming by contacting AWS Support if the Monday spike is very large (ALB scales slower than ECS). (5) Configure health check grace periods to prevent premature traffic routing to starting tasks.  
C) Deploy a Lambda function to pre-warm the application.  
D) Cache all responses on CloudFront to handle the spike.

**Correct Answer: B**
**Explanation:** Scheduled scaling pre-provisions capacity before the known traffic pattern, eliminating the scaling lag. Step scaling provides faster reactive scaling for unexpected variations. ALB pre-warming (via AWS Support) ensures the load balancer can handle the sudden spike. Health check grace periods prevent routing to unready tasks. This combination addresses both the predictable Monday spike and unexpected variations. Option A wastes money on quiet days. Option C — Lambda can't pre-warm ECS tasks. Option D only helps for cacheable GET requests.

---

### Question 16
A company wants to migrate their on-premises Hadoop cluster (HDFS + Spark + Hive) to AWS. They process 50TB of data daily, run batch analytics jobs, and have 200 Hive tables. They want to reduce operational overhead while maintaining compatibility with existing Spark and Hive workloads. What should the architect recommend?

A) Deploy Amazon EMR clusters that run 24/7 to replace the Hadoop cluster.  
B) Decouple storage from compute: (1) Migrate HDFS data to Amazon S3 using S3DistCp or DataSync. (2) Use AWS Glue Data Catalog as the Hive metastore replacement (compatible with Hive, Spark, and Presto). (3) Deploy Amazon EMR on EKS for Spark jobs — submit Spark applications without managing EMR clusters. (4) Use Amazon Athena for interactive Hive-compatible SQL queries on S3 (serverless, no cluster management). (5) For complex ETL, use AWS Glue Spark jobs. (6) S3 Intelligent-Tiering for automatic storage cost optimization on the 50TB daily data.  
C) Use Amazon Redshift to replace Hadoop entirely.  
D) Lift and shift the Hadoop cluster to EC2 instances.

**Correct Answer: B**
**Explanation:** Decoupling storage (S3) from compute (EMR/Athena/Glue) is the key architectural improvement. S3 provides unlimited, durable, cost-effective storage. Glue Data Catalog replaces Hive metastore with a managed, compatible service. EMR on EKS runs Spark without permanent clusters. Athena provides serverless SQL. Compute scales independently of storage. Option A maintains the operational overhead of permanent clusters. Option C — Redshift is a data warehouse, not a Hadoop replacement for diverse workloads. Option D provides no improvement over on-premises.

---

### Question 17
A company operates a multi-account environment and wants to ensure that no AWS account can launch resources in unapproved Regions. Only us-east-1, us-west-2, and eu-west-1 are approved. What is the most reliable way to enforce this?

A) Communicate the approved Regions to all teams via documentation.  
B) Create an SCP attached to the organizational root that denies all actions in non-approved Regions with an exception for global services (IAM, Route 53, CloudFront, Organizations, STS): deny all actions where aws:RequestedRegion is not in [us-east-1, us-west-2, eu-west-1], except for global service actions. Apply this SCP to all OUs except the management account.  
C) Use AWS Config rules to detect resources in unapproved Regions.  
D) Remove Regional AWS service endpoints from VPCs.

**Correct Answer: B**
**Explanation:** SCPs are the definitive preventive control for Region restriction. The deny SCP blocks ALL API calls in non-approved Regions regardless of IAM permissions. The exception for global services (IAM, Route 53, etc.) is critical — these services operate globally and would break if Region-restricted. SCPs cannot be bypassed by any principal except the management account. Option A is not enforceable. Option C detects after the fact (not preventive). Option D only affects VPC-based traffic.

---

### Question 18
A company's data analytics team needs to query data across multiple data sources — S3 data lake (Parquet), Aurora PostgreSQL, DynamoDB, and a third-party SaaS application's API. They want a single query engine that can join data across these sources without ETL. What should the architect recommend?

A) ETL all data into Redshift before querying.  
B) Use Amazon Athena Federated Query: (1) Athena queries S3 data lake natively. (2) Deploy Athena data source connectors (Lambda-based) for Aurora PostgreSQL, DynamoDB, and the third-party API. (3) Analysts write SQL queries in Athena that join across all data sources in a single query. (4) Athena pushes predicates to data sources for efficient filtering. (5) Results are returned without moving data. For frequently used cross-source queries, materialize results in S3 using Athena CTAS (Create Table As Select) for performance.  
C) Use AWS Glue to build ETL pipelines for every combination.  
D) Query each source independently and join results in a spreadsheet.

**Correct Answer: B**
**Explanation:** Athena Federated Query enables SQL queries across heterogeneous data sources without ETL. Lambda-based connectors translate Athena queries to the native format of each data source. Predicate pushdown optimizes performance by filtering at the source. CTAS materializes frequent queries for faster repeat access. This eliminates ETL pipeline maintenance for ad-hoc cross-source analysis. Option A requires building and maintaining ETL for all sources. Option C creates operational overhead. Option D doesn't scale.

---

### Question 19
A company is implementing a CI/CD pipeline for their infrastructure-as-code (Terraform) deployments across 50 AWS accounts. They need to ensure that infrastructure changes are reviewed, tested, and deployed consistently across environments (dev → staging → production). What pipeline architecture should the architect design?

A) Give developers direct access to apply Terraform in all accounts.  
B) Build a centralized CI/CD pipeline: (1) Terraform code in CodeCommit with branch protection (PR reviews required for main). (2) CodeBuild runs terraform plan on every PR — plan output is posted as a PR comment for review. (3) After merge, CodePipeline deploys: dev environment first (terraform apply via cross-account role). (4) Automated tests validate dev deployment (AWS Config, custom Lambda tests). (5) Manual approval gate before staging deployment. (6) Staging deployment with integration tests. (7) Manual approval before production. (8) Production deployment across multiple accounts using Terraform workspaces or separate state files per account. (9) Terraform state stored in S3 with DynamoDB locking and state file encryption.  
C) Apply Terraform manually from a bastion host.  
D) Use CloudFormation instead of Terraform for all infrastructure.

**Correct Answer: B**
**Explanation:** This pipeline enforces governance for IaC deployments. PR reviews catch issues before merge. Plan output in PRs shows exactly what will change. Automated testing validates deployments. Manual approval gates prevent untested changes from reaching production. Cross-account roles provide secure access without permanent credentials. S3 + DynamoDB provides reliable state management with locking. Option A has no review or testing process. Option C is not repeatable or auditable. Option D — the question specifies Terraform; the pipeline architecture applies regardless of IaC tool.

---

### Question 20
A company receives real-time sensor data from manufacturing equipment and needs to detect equipment anomalies within 30 seconds of occurrence. When an anomaly is detected, the system must trigger an automated maintenance workflow. They process 10,000 events per second. What architecture should the architect design?

A) Store all sensor data in DynamoDB and query for anomalies periodically.  
B) Build a real-time anomaly detection pipeline: (1) IoT sensors → AWS IoT Core → IoT Rules Engine → Amazon Kinesis Data Streams. (2) Amazon Managed Service for Apache Flink (formerly Kinesis Data Analytics) processes the stream in real-time using sliding window aggregations and anomaly detection algorithms (Random Cut Forest). (3) Detected anomalies trigger Lambda via Kinesis output stream. (4) Lambda starts a Step Functions state machine for the maintenance workflow (create maintenance ticket, notify technician, schedule downtime). (5) Raw data flows via Kinesis Data Firehose to S3 for historical analysis. (6) Amazon Lookout for Equipment provides ML-based predictive maintenance using historical patterns.  
C) Use CloudWatch Alarms with static thresholds on sensor metrics.  
D) Process events in batch every 5 minutes using EMR Spark.

**Correct Answer: B**
**Explanation:** Apache Flink provides true real-time stream processing with sub-second latency for the 30-second detection requirement. Random Cut Forest (RCF) in Flink detects anomalies using ML on streaming data. The pipeline from IoT Core to Flink to Lambda to Step Functions provides end-to-end automation under 30 seconds. Firehose handles durable storage. Lookout for Equipment adds predictive capabilities. Option A — periodic queries don't meet 30-second requirement. Option C — static thresholds miss complex multi-sensor anomalies. Option D — 5-minute batches exceed the 30-second requirement.

---

### Question 21
A company wants to implement a global content management system where authors in different Regions can simultaneously edit documents. Edits must be visible to all users within 2 seconds regardless of Region. Conflict resolution for simultaneous edits should follow "last writer wins." What database architecture should the architect use?

A) Single-Region Aurora with read replicas in other Regions.  
B) Use Amazon DynamoDB Global Tables with multi-Region active writes: (1) Create a DynamoDB table with global table replication across the required Regions. (2) Authors write to their local Region's table (low latency). (3) Global tables replicate changes across Regions with sub-second replication latency (well within the 2-second requirement). (4) DynamoDB's built-in conflict resolution uses "last writer wins" based on timestamps. (5) Use DynamoDB Streams in each Region to trigger Lambda functions for real-time notifications to active users. (6) For the document content (if large), store in S3 with Cross-Region Replication and store the S3 key in DynamoDB.  
C) Use Amazon ElastiCache Global Datastore for real-time replication.  
D) Deploy a custom replication mechanism using SQS between Regions.

**Correct Answer: B**
**Explanation:** DynamoDB Global Tables provide multi-Region, active-active writes with sub-second replication and built-in "last writer wins" conflict resolution — exactly matching the requirements. Writes go to the local Region for low latency. Replication is managed and automatic. DynamoDB Streams enable real-time notifications. Large document content in S3 with CRR handles the content size. Option A — Aurora allows writes in only one Region (primary). Option C — ElastiCache isn't designed for persistent document storage. Option D requires building custom replication.

---

### Question 22
A company is evaluating whether to use Amazon ECS or Amazon EKS for their containerized microservices platform. They have 50 microservices, need service mesh capabilities, want to use both Fargate and EC2 launch types, and their team has experience with Docker but not Kubernetes. What should the architect recommend?

A) Use Amazon EKS because it's the industry standard.  
B) Use Amazon ECS with AWS App Mesh: (1) ECS provides simpler container orchestration (no Kubernetes complexity) — their Docker expertise transfers directly. (2) App Mesh provides service mesh capabilities (traffic management, mTLS, observability) with Envoy sidecars on ECS. (3) ECS supports both Fargate and EC2 launch types natively. (4) ECS Service Connect provides built-in service discovery and load balancing. (5) CodeDeploy integrates for blue/green and canary deployments. (6) If the team's needs grow toward Kubernetes, they can migrate to EKS later.  
C) Use EC2 with Docker Compose for simplicity.  
D) Use AWS Lambda for all 50 microservices.

**Correct Answer: B**
**Explanation:** Given the team's Docker (not Kubernetes) experience, ECS provides a lower learning curve while meeting all requirements. App Mesh provides service mesh. Both Fargate and EC2 launch types are supported. ECS Service Connect simplifies service discovery. The team can be productive immediately without Kubernetes training. Option A introduces unnecessary complexity for a team without Kubernetes experience. Option C lacks orchestration for 50 services. Option D — Lambda may not suit all 50 microservices' patterns.

---

### Question 23
A company has an application that stores user-generated content in S3. They're seeing increasing S3 costs as the data grows to 500TB. Analysis shows that 80% of objects haven't been accessed in the past 90 days, and 95% of API calls are GET requests on the most recent 5% of data. What cost optimization strategy should the architect implement?

A) Delete all objects older than 90 days.  
B) Implement tiered storage with S3 Lifecycle policies: (1) S3 Intelligent-Tiering as the default storage class — it automatically moves objects between frequent and infrequent access tiers based on access patterns (no retrieval fees). (2) Lifecycle rules: move objects to S3 Glacier Instant Retrieval after 90 days (millisecond access, 68% cheaper than Standard). Move to Glacier Flexible Retrieval after 180 days. Move to Glacier Deep Archive after 365 days. (3) CloudFront for caching the frequently accessed recent content (reduces S3 GET request costs). (4) S3 Analytics to validate and refine lifecycle transition timing.  
C) Compress all S3 objects.  
D) Move all data to EBS volumes.

**Correct Answer: B**
**Explanation:** S3 Intelligent-Tiering automatically optimizes storage costs for unpredictable access patterns. Lifecycle policies move known-cold data to progressively cheaper tiers. Glacier Instant Retrieval provides millisecond access at 68% cost reduction for rarely accessed data. CloudFront caches hot content, reducing S3 request costs. S3 Analytics provides data-driven insights for lifecycle optimization. At 500TB, even small per-GB savings are significant. Option A may delete needed data. Option C reduces storage but adds compute cost. Option D is more expensive.

---

### Question 24
A company's application running on ECS experiences intermittent 504 Gateway Timeout errors. The ALB health checks pass, and CloudWatch metrics show no CPU/memory pressure. The errors correlate with burst traffic periods. Investigation shows that the application sometimes takes 90 seconds to respond to requests (the ALB timeout is 60 seconds). What should the architect do?

A) Increase the ALB idle timeout to 120 seconds.  
B) Address the root cause and the symptom: (1) Increase the ALB idle timeout to 120 seconds as an immediate fix. (2) Investigate why the application takes 90 seconds during bursts — likely database connection pool exhaustion or downstream service latency. (3) Deploy Amazon RDS Proxy to manage database connection pooling. (4) Implement circuit breakers for downstream dependencies using App Mesh. (5) Add application-level request timeouts that fail fast (30 seconds) instead of blocking for 90 seconds. (6) Scale the ECS service proactively based on request count, not just CPU.  
C) Replace ALB with NLB which doesn't have timeout issues.  
D) Increase ECS task count permanently.

**Correct Answer: B**
**Explanation:** The 504 error is a symptom (ALB timeout < application response time). The root cause is the application's slow response during bursts (likely resource contention). Increasing the ALB timeout is the immediate fix, but addressing root causes prevents escalation: RDS Proxy eliminates connection pool exhaustion, circuit breakers prevent cascade from slow dependencies, application timeouts prevent indefinite blocking, and proactive scaling handles burst traffic. Option A alone treats the symptom. Option C — NLB doesn't handle HTTP routing. Option D doesn't address the root cause.

---

### Question 25
A company has a legacy Windows application running on premises. They want to move it to AWS with minimal changes. The application requires Windows Server, uses .NET Framework 4.8, stores session state in a local file system, and connects to a SQL Server database. What migration approach should the architect recommend?

A) Rewrite the application as a serverless architecture on Lambda.  
B) Rehost (lift and shift) with minor adjustments: (1) Migrate the Windows Server application to EC2 Windows instances using AWS Application Migration Service (MGN) for automated rehosting. (2) Deploy behind an ALB with sticky sessions (to handle local session state initially). (3) Migrate SQL Server to Amazon RDS for SQL Server using DMS. (4) Plan Phase 2 modernization: move session state to ElastiCache for Redis (eliminates file-system dependency), enable horizontal scaling. (5) Use FSx for Windows File Server if shared file system access is needed. (6) Deploy in a multi-AZ ASG for high availability.  
C) Containerize the .NET Framework 4.8 application on ECS.  
D) Use AWS Elastic Beanstalk for Windows.

**Correct Answer: B**
**Explanation:** MGN provides automated lift-and-shift for Windows servers with minimal changes. ALB sticky sessions maintain the local session state behavior. RDS for SQL Server provides a managed database migration target. The phased approach moves to AWS quickly (Phase 1: rehost) and modernizes incrementally (Phase 2: externalize session state). Option A is a complete rewrite (not minimal changes). Option C — .NET Framework 4.8 (not Core) has limited container support on Windows. Option D — Elastic Beanstalk has limited Windows support compared to direct EC2.

---

### Question 26
A company needs to implement a multi-Region active-active architecture for their critical application. They need to handle Region failover automatically. Users should be routed to the nearest healthy Region. What should the architect design? (Select TWO.)

A) Use Amazon Route 53 with latency-based routing and health checks to route users to the nearest healthy Region. Configure failover to remove unhealthy Regions from DNS responses within 30 seconds.  
B) Use a single-Region deployment with a backup Region in cold standby.  
C) Deploy the application stack in each Region with DynamoDB Global Tables for shared state, Aurora Global Database for relational data, and S3 Cross-Region Replication for object storage. Each Region operates independently with its own compute layer (ECS/EKS with auto-scaling).  
D) Use CloudFront as the sole failover mechanism.  
E) Manually switch DNS during failures.

**Correct Answer: A, C**
**Explanation:** (A) Route 53 latency-based routing directs users to the nearest Region, and health checks automatically remove unhealthy Regions (key for automatic failover). (C) Each Region needs a complete, independently operational application stack. DynamoDB Global Tables, Aurora Global Database, and S3 CRR keep data synchronized across Regions for active-active operation. Together, A and C provide the routing layer (A) and the application layer (C) for multi-Region active-active. Option B is active-passive. Option D doesn't handle database failover. Option E is not automatic.

---

### Question 27
A company processes sensitive financial documents and needs to ensure that documents uploaded to S3 are automatically classified and tagged with their sensitivity level before any human accesses them. Unclassified documents should be quarantined. What should the architect design?

A) Manually classify documents before uploading to S3.  
B) Build an automated classification pipeline: (1) S3 event notification on object creation triggers a Lambda function. (2) Lambda invokes Amazon Textract to extract text from the document. (3) Lambda sends extracted text to Amazon Comprehend for PII detection and custom classification (trained on financial document categories). (4) Based on classification results, Lambda tags the S3 object with sensitivity level (Public, Internal, Confidential, Restricted). (5) Unclassified or high-sensitivity documents are moved to a quarantine bucket with restricted access. (6) S3 bucket policy denies all read access to objects without a sensitivity tag, ensuring unclassified documents can't be accessed. (7) Amazon Macie runs periodic scans to catch anything the pipeline misses.  
C) Use S3 Storage Lens for classification.  
D) Apply the highest sensitivity tag to all documents by default.

**Correct Answer: B**
**Explanation:** The automated pipeline classifies documents immediately on upload. Textract handles text extraction from various document formats. Comprehend performs NLP-based classification. S3 tagging enables downstream access control based on sensitivity. The bucket policy denying access to untagged objects ensures nothing is accessed before classification. Quarantine isolates high-risk documents. Macie provides a safety net. Option A doesn't scale. Option C — Storage Lens provides metrics, not classification. Option D is too restrictive and provides no useful classification.

---

### Question 28
A company has deployed a serverless application using API Gateway, Lambda, and DynamoDB. During a load test simulating production traffic, they discover that Lambda functions are hitting DynamoDB throttling errors at 5,000 write requests per second. The DynamoDB table is provisioned with 5,000 WCU. What should the architect do?

A) Increase DynamoDB provisioned WCU to 10,000.  
B) Implement a multi-pronged approach: (1) Switch DynamoDB to on-demand capacity mode for unpredictable workloads, or use auto-scaling with target utilization of 70% for predictable workloads. (2) Review the DynamoDB partition key design — hot partitions (uneven key distribution) cause throttling even when aggregate capacity is sufficient. Use a high-cardinality partition key. (3) Implement write buffering with SQS — Lambda writes to SQS, and a separate Lambda processes the queue at a controlled rate using reserved concurrency, smoothing burst writes. (4) Use DynamoDB Accelerator (DAX) for read caching to reduce read consumption and free capacity for writes. (5) Enable DynamoDB burst capacity to handle short spikes.  
C) Replace DynamoDB with Aurora for higher write throughput.  
D) Reduce the number of Lambda concurrent executions.

**Correct Answer: B**
**Explanation:** Throttling at the provisioned limit can be caused by insufficient capacity OR hot partitions (where some partitions exceed per-partition limits of 1,000 WCU even though the table has enough total WCU). On-demand/auto-scaling addresses capacity. Partition key review addresses hot partitions. SQS buffering smooths bursts. DAX offloads reads to free write capacity. Burst capacity handles short spikes. Option A helps if the issue is purely capacity but not if it's hot partitions. Option C changes the architecture unnecessarily. Option D reduces throughput.

---

### Question 29
A company has an application that must comply with both GDPR (EU) and CCPA (California) data privacy regulations. They need to implement data residency controls ensuring EU customer data stays in EU Regions and US customer data stays in US Regions, while maintaining a unified global application. What should the architect design?

A) Deploy separate applications in each Region with no data sharing.  
B) Implement a data residency-aware architecture: (1) Amazon API Gateway with Lambda authorizer that determines the customer's Region from their profile and routes requests to the appropriate Regional backend. (2) Separate DynamoDB tables per Region (not global tables) for customer data — EU data stays in eu-west-1, US data in us-east-1. (3) S3 buckets per Region with lifecycle policies preventing replication to non-compliant Regions. (4) IAM policies with aws:RequestedRegion conditions preventing cross-Region data access. (5) SCPs denying data service access in non-approved Regions per OU. (6) Amazon CloudFront with origin selection based on viewer country for the frontend. (7) Data residency documented and auditable via AWS Config rules.  
C) Use DynamoDB Global Tables and accept that data may replicate to non-compliant Regions.  
D) Store all data in one Region and use legal agreements for compliance.

**Correct Answer: B**
**Explanation:** Data residency requires strict control over where data is stored and processed. Per-Region DynamoDB tables (not global tables) ensure data stays in the correct Region. API Gateway routing directs requests to the correct Regional backend. IAM and SCP conditions prevent cross-Region access. S3 buckets are Region-specific by design. Config rules provide audit evidence. This maintains a unified application while respecting data residency. Option A creates two separate products. Option C violates data residency. Option D doesn't provide technical enforcement.

---

### Question 30
A company runs a containerized application on EKS that needs to access secrets stored in AWS Secrets Manager. The pods should retrieve secrets automatically at startup without hardcoding credentials. They also need to mount secrets as files within the pod's file system. What should the architect configure?

A) Store secrets in Kubernetes Secrets and sync manually from Secrets Manager.  
B) Deploy the AWS Secrets and Configuration Provider (ASCP) for the Kubernetes Secrets Store CSI Driver: (1) Install the Secrets Store CSI Driver on the EKS cluster. (2) Install the ASCP provider. (3) Create SecretProviderClass resources that map Secrets Manager secrets to pod volumes. (4) EKS pods use IAM Roles for Service Accounts (IRSA) to authenticate to Secrets Manager — each service account has an IAM role with least-privilege access to only its required secrets. (5) Secrets are mounted as files in the pod's file system at startup. (6) Optional: sync secrets to Kubernetes Secrets for environment variable consumption. (7) Secret rotation in Secrets Manager is automatically reflected in pods (configurable rotation interval).  
C) Pass secrets as environment variables in the pod spec.  
D) Use an init container that fetches secrets from a custom API.

**Correct Answer: B**
**Explanation:** The Secrets Store CSI Driver with ASCP provides native integration between EKS and Secrets Manager. IRSA provides secure, pod-level IAM authentication without managing access keys. Secrets mounted as files meet the requirement. Sync to Kubernetes Secrets enables environment variable access. Automatic rotation reflection ensures pods always have current secrets. Option A requires manual synchronization. Option C exposes secrets in pod specs. Option D adds custom infrastructure.

---

### Question 31
A company is building a real-time fraud detection system that must process credit card transactions and return a fraud/not-fraud decision within 50ms. The system must evaluate 100+ rules and an ML model for each transaction. How should the architect design the low-latency decision engine?

A) Use API Gateway with Lambda for each transaction evaluation.  
B) Deploy a low-latency decision engine: (1) NLB for lowest network latency (Layer 4). (2) EC2 instances in a cluster placement group with the rules engine and ML model loaded in memory. (3) Pre-load all 100+ rules into a local rules engine (Drools or custom) at startup. (4) SageMaker model compiled with SageMaker Neo for optimized inference, deployed as a sidecar or loaded locally. (5) ElastiCache for Redis for transaction history lookups (sub-millisecond). (6) All decision data (rules, model, transaction patterns) cached locally — no network calls in the hot path. (7) Asynchronous logging to Kinesis for audit and model retraining.  
C) Use Amazon Fraud Detector for real-time evaluation.  
D) Store rules in DynamoDB and query for each transaction.

**Correct Answer: B**
**Explanation:** At 50ms total latency, every network call matters. Loading everything into local memory eliminates network round-trips for rules and model evaluation. NLB provides the lowest network latency. Placement groups minimize instance-to-Redis latency. Asynchronous logging avoids blocking the decision path. Neo-compiled models optimize inference speed. Option A — Lambda cold starts and invocation overhead may exceed 50ms. Option C — Fraud Detector latency may exceed 50ms for complex evaluations. Option D — DynamoDB adds 1-5ms per call.

---

### Question 32
A company runs a web application that serves both static content (images, CSS, JS) and dynamic API responses. Currently, everything goes through the ALB to ECS. They want to reduce latency for global users and reduce load on the ECS services. What should the architect implement?

A) Deploy the application in multiple Regions.  
B) Deploy Amazon CloudFront in front of the ALB: (1) CloudFront caches static content at edge locations globally (set TTL based on content type — long TTL for CSS/JS, shorter for images). (2) Configure cache behaviors: /api/* origin requests pass through to the ALB (no caching or short TTL). /static/* requests are served from CloudFront cache. (3) Enable CloudFront Origin Shield for a centralized caching layer that reduces origin load. (4) Use CloudFront Functions or Lambda@Edge for edge-side operations (header manipulation, A/B testing, authentication). (5) Enable compression (Brotli/Gzip) at the CloudFront level.  
C) Move static files to S3 and create a separate CloudFront distribution.  
D) Increase the number of ECS tasks to handle global load.

**Correct Answer: B**
**Explanation:** CloudFront as a single distribution handles both static and dynamic content with different cache behaviors. Static content is cached at edge locations (reducing latency to milliseconds globally). Dynamic API requests pass through to the origin (ALB/ECS) but benefit from CloudFront's optimized backbone. Origin Shield reduces cache-miss load on the origin. Compression reduces transfer sizes. Option A adds multi-Region complexity for what is primarily a caching problem. Option C creates two distributions to manage. Option D doesn't reduce latency for global users.

---

### Question 33
A company has a data pipeline that processes customer clickstream data. The pipeline currently uses a Kinesis Data Stream with 50 shards. They notice that some shards are "hot" (processing 5x more records than others) while some shards are nearly idle. What should the architect do?

A) Double the number of shards to 100.  
B) Address the hot shard problem: (1) Review the partition key — if using a low-cardinality key (like page URL), switch to a high-cardinality key (like user session ID or a random suffix added to the key). (2) If the data naturally has hotspots (some pages get more clicks), use a composite partition key with a random suffix (e.g., pageUrl_random(1-10)) to distribute hot keys across multiple shards. (3) Use Kinesis Enhanced Fan-Out if consumers are falling behind on hot shards (dedicated 2MB/s per consumer per shard). (4) Monitor shard-level metrics (IncomingBytes, IncomingRecords per shard) using CloudWatch to validate the fix.  
C) Switch from Kinesis to SQS for better distribution.  
D) Enable Kinesis auto-scaling.

**Correct Answer: B**
**Explanation:** Hot shards are caused by poor partition key distribution — records with the same key always go to the same shard. Using high-cardinality keys or adding random suffixes distributes records more evenly. Composite keys (original_key + random_suffix) maintain per-key ordering within a shard while distributing across shards. Enhanced Fan-Out provides dedicated throughput per consumer. Shard metrics validate the improvement. Option A adds capacity but doesn't fix the distribution problem. Option C loses stream ordering. Option D — Kinesis doesn't have native auto-scaling for shard count.

---

### Question 34
A company wants to implement a cost allocation strategy across their 200-account AWS Organization. Different business units, projects, and environments need to be tracked for chargeback. What comprehensive cost management approach should the architect implement?

A) Review the monthly AWS bill and split it evenly across business units.  
B) Implement a comprehensive cost allocation strategy: (1) Define a mandatory tagging policy with tags: BusinessUnit, Project, Environment, CostCenter. (2) Use AWS Organizations Tag Policies to enforce tag compliance across all accounts. (3) Enable Cost Allocation Tags in the billing console for these tags. (4) Use AWS Cost Explorer for visualization by tag, account, service, and Region. (5) Enable the Cost and Usage Report (CUR) delivered to S3 for detailed analysis — query with Athena. (6) Create AWS Budgets per business unit and project with alerts. (7) Use AWS Cost Anomaly Detection to flag unexpected cost increases. (8) Implement SCPs that deny resource creation without required tags. (9) Monthly chargeback reports generated from CUR using QuickSight dashboards.  
C) Use separate billing accounts for each business unit.  
D) Track costs using CloudWatch custom metrics.

**Correct Answer: B**
**Explanation:** Comprehensive cost allocation requires enforced tagging (the foundation), multiple reporting tools, and proactive monitoring. Tag Policies enforce compliance. Cost Allocation Tags enable tag-based cost tracking. CUR provides granular data for analysis. Budgets provide spend limits with alerts. Cost Anomaly Detection catches unexpected increases. SCPs ensure every resource is tagged. QuickSight dashboards provide executive visibility. Option A has no granularity. Option C adds account management overhead. Option D doesn't provide billing integration.

---

### Question 35
A company is building a multi-player online game. The game requires real-time communication between players (< 100ms latency), persistent game state, and the ability to handle 100,000 concurrent players. What architecture should the architect design?

A) Use API Gateway with WebSockets and Lambda for game logic.  
B) Deploy a real-time gaming architecture: (1) Amazon GameLift or EC2 fleet for game servers in cluster placement groups (low-latency game logic execution). (2) AWS Global Accelerator for anycast-based player routing to the nearest game server. (3) Amazon ElastiCache for Redis for in-memory game state (sub-millisecond access). (4) Amazon DynamoDB for persistent player profiles and game history. (5) Amazon Kinesis for real-time game event streaming (analytics, anti-cheat). (6) WebSocket connections from game clients to game servers (not through API Gateway — direct for lowest latency). (7) Amazon GameLift FlexMatch for matchmaking. (8) Auto Scaling group for game servers based on active player count.  
C) Use a single large EC2 instance for all game logic.  
D) Deploy on Lambda for automatic scaling.

**Correct Answer: B**
**Explanation:** Real-time multiplayer gaming requires ultra-low-latency architecture. GameLift/EC2 provides dedicated game server compute. Global Accelerator routes players to the nearest server via anycast (< 100ms). Redis stores in-memory game state for instant access. Direct WebSocket connections (not through API Gateway) minimize latency. Kinesis handles event streaming. FlexMatch provides skill-based matchmaking. Auto-scaling handles player count fluctuations. Option A — API Gateway adds latency. Option C — single server can't handle 100K players. Option D — Lambda has cold starts and no persistent connections.

---

### Question 36
A company is migrating 500 virtual machines from VMware vSphere to AWS. They have 6 months to complete the migration. VMs range from simple web servers to complex multi-tier applications with interdependencies. What migration approach should the architect recommend?

A) Manually recreate all 500 VMs on EC2.  
B) Use a structured migration approach: (1) AWS Application Discovery Service with agentless (vCenter connector) and agent-based discovery to map all VMs, dependencies, and performance profiles. (2) AWS Migration Hub for centralized tracking of migration progress. (3) Group VMs into migration waves based on dependencies (migrate dependent VMs together). (4) AWS Application Migration Service (MGN) for automated rehosting — MGN continuously replicates VMs to AWS, enabling test migrations and final cutover with minimal downtime. (5) For each wave: install MGN agent → replicate → test launch → cutover. (6) CloudEndure (MGN) handles the OS, disk, and network configuration translation automatically. (7) Post-migration optimization: right-size instances based on CloudWatch metrics.  
C) Use AWS VM Import/Export for all VMs.  
D) Rebuild all applications as cloud-native on ECS/Lambda.

**Correct Answer: B**
**Explanation:** This structured approach handles 500 VMs systematically. Discovery maps dependencies to prevent breaking connected systems. Wave-based migration groups dependent VMs together. MGN provides automated, continuous replication with minimal downtime cutover. Migration Hub tracks progress across 500 VMs. Post-migration right-sizing optimizes costs. Option A is manual and error-prone at scale. Option C — VM Import/Export is older and requires more manual steps than MGN. Option D is a modernization project, not a migration (too slow for 6 months at 500 VMs).

---

### Question 37
A company's CloudWatch bill has increased 400% over the past year due to growing log volume (10TB/day of CloudWatch Logs). Most logs are kept for compliance (7-year retention) but are rarely queried. What should the architect do to reduce CloudWatch Logs costs while maintaining compliance?

A) Reduce log verbosity across all applications.  
B) Implement a tiered logging architecture: (1) Use CloudWatch Logs subscription filters to stream logs to Amazon S3 via Kinesis Data Firehose (much cheaper long-term storage). (2) Set CloudWatch Logs retention to 30 days (enough for active troubleshooting). (3) S3 lifecycle policies: Standard for 30 days → S3 Glacier Instant Retrieval for 1 year → Glacier Deep Archive for remaining 6 years (7-year total retention at ~$1/TB/month). (4) Use Amazon Athena with the CloudWatch Logs S3 export format for ad-hoc queries on historical logs. (5) S3 Object Lock for compliance (immutable storage). (6) For real-time monitoring, keep CloudWatch Logs Insights on the 30-day window.  
C) Delete all logs older than 30 days.  
D) Compress CloudWatch Logs using a Lambda function.

**Correct Answer: B**
**Explanation:** CloudWatch Logs is expensive for long-term storage (~$0.03/GB/month). S3 Glacier Deep Archive is ~$0.00099/GB/month — 30x cheaper. The tiered approach keeps recent logs in CloudWatch for fast access (Logs Insights) while archiving to S3/Glacier for compliance at dramatically lower cost. Firehose handles the streaming export. Athena enables ad-hoc queries on archived logs. Object Lock ensures compliance immutability. At 10TB/day, this saves ~$8,000/month. Option A loses valuable debugging information. Option C violates compliance. Option D doesn't address storage costs.

---

### Question 38
A company has an EKS cluster running stateful workloads (databases, message queues). They need persistent storage that provides high IOPS, low latency, and survives pod restarts and node failures. What storage architecture should the architect configure?

A) Use EBS volumes directly attached to specific EC2 nodes.  
B) Use the Amazon EBS CSI Driver for Kubernetes: (1) Install the EBS CSI Driver on the EKS cluster. (2) Create StorageClasses for different performance tiers: gp3 for general purpose, io2 Block Express for high-IOPS databases. (3) Use PersistentVolumeClaims (PVCs) in pod specs to dynamically provision EBS volumes. (4) EBS volumes persist across pod restarts and reschedules within the same AZ. (5) For cross-AZ persistence, use Amazon EFS CSI Driver (EFS provides multi-AZ, multi-pod shared storage). (6) For the highest IOPS (256K+), use io2 Block Express with EBS Multi-Attach for shared access. (7) Use VolumeSnapshots for backup via the CSI Snapshot Controller.  
C) Use hostPath volumes for persistent storage.  
D) Store all data in S3 and mount via s3fs.

**Correct Answer: B**
**Explanation:** The EBS CSI Driver provides native Kubernetes storage integration. Dynamic provisioning via StorageClasses eliminates manual volume management. Different storage classes match workload needs (gp3 for general, io2 for databases). PVCs provide portable storage claims. EFS handles cross-AZ requirements. VolumeSnapshots enable backup. Option A — direct EBS attachment bypasses Kubernetes storage management and doesn't handle pod rescheduling. Option C — hostPath is node-local and doesn't survive node failure. Option D — S3 via fuse mount has poor IOPS performance.

---

### Question 39
A company runs an application that generates 1 million SNS notifications per day. Each notification triggers a Lambda function that takes 30 seconds to process (calling external APIs). They're hitting Lambda concurrency limits. What should the architect do?

A) Request a Lambda concurrency limit increase.  
B) Decouple and control the processing rate: (1) Add an SQS queue between SNS and Lambda (SNS → SQS → Lambda). (2) Configure Lambda with SQS as an event source with reserved concurrency set to a manageable level (e.g., 100 concurrent executions). (3) SQS batching — process multiple messages per Lambda invocation (batch size up to 10). (4) This smooths the burst — SQS buffers messages and Lambda processes at a controlled rate. (5) Set SQS visibility timeout to 6x the Lambda timeout (180 seconds). (6) Configure a dead-letter queue for messages that fail processing after max retries. (7) For the external API calls, implement connection pooling and batch API calls where possible to reduce per-message processing time.  
C) Replace Lambda with ECS tasks for processing.  
D) Increase the Lambda timeout to reduce concurrent executions.

**Correct Answer: B**
**Explanation:** SQS as a buffer between SNS and Lambda converts a burst problem into a queuing problem. Lambda processes the queue at a controlled rate (reserved concurrency limits parallel executions). Batching processes multiple messages per invocation, reducing total Lambda invocations. SQS handles the backlog gracefully — messages wait in the queue instead of hitting concurrency limits. DLQ captures persistent failures. Option A has account-wide limits and may not solve burst issues. Option C is more complex to manage. Option D — longer timeout means fewer concurrent invocations but doesn't fix bursts.

---

### Question 40
A company wants to build a machine learning pipeline that automatically retrains models when new data arrives. The pipeline should include data validation, feature engineering, training, evaluation, and conditional deployment (only deploy if the new model outperforms the current one). What should the architect design?

A) Run training manually in SageMaker notebooks.  
B) Build an automated ML pipeline using SageMaker Pipelines: (1) S3 event (new data) → EventBridge → triggers SageMaker Pipeline. (2) Processing step: data validation (check for schema drift, missing values, data quality) using SageMaker Processing. (3) Feature engineering step: transform raw data into training features. (4) Training step: train the new model with the updated dataset. (5) Evaluation step: compare new model metrics (accuracy, F1, AUC) against the current production model stored in Model Registry. (6) Condition step: if new model performance > production model by threshold, proceed to register; otherwise, stop. (7) Register step: add the new model to Model Registry with "PendingManualApproval" status. (8) After approval, update the SageMaker endpoint to the new model using a blue/green deployment.  
C) Use a cron job to retrain on a fixed schedule regardless of data changes.  
D) Retrain in a Jupyter notebook and manually deploy.

**Correct Answer: B**
**Explanation:** SageMaker Pipelines automates the full ML lifecycle. Event-driven triggering ensures retraining happens when new data arrives (not on a fixed schedule). Data validation prevents garbage-in-garbage-out. The condition step implements the champion/challenger pattern — only better models progress. Model Registry provides version control and approval workflow. Blue/green deployment ensures zero-downtime model updates. Option A is manual. Option C wastes compute when no new data exists and misses data between schedules. Option D doesn't scale or automate.

---

### Question 41
A company is deploying a serverless application using AWS SAM (Serverless Application Model). They need to implement canary deployments for their Lambda functions — routing a small percentage of traffic to the new version before full rollout. What should the architect configure?

A) Deploy new Lambda versions and update the alias manually.  
B) Use AWS SAM with CodeDeploy integration for Lambda traffic shifting: (1) In the SAM template, set the DeploymentPreference property to Canary10Percent5Minutes (10% traffic to new version for 5 minutes). (2) SAM automatically creates a CodeDeploy deployment that manages Lambda alias traffic shifting between old and new versions. (3) Configure pre-traffic and post-traffic hooks (Lambda functions) that validate the new version before and after traffic shifts. (4) Define CloudWatch Alarms that trigger automatic rollback if error rates exceed thresholds. (5) If alarms trigger during the canary period, CodeDeploy rolls back to the previous version.  
C) Use API Gateway stage variables to route traffic.  
D) Deploy two separate Lambda functions and use Route 53 for routing.

**Correct Answer: B**
**Explanation:** SAM's DeploymentPreference integrates directly with CodeDeploy for managed Lambda traffic shifting. Canary deployments send a percentage to the new version while monitoring health. Pre/post-traffic hooks validate functionality. CloudWatch alarms trigger automatic rollback on errors. This is fully automated and AWS-native. Option A is manual. Option C requires API Gateway configuration changes for each deployment. Option D — Route 53 can't route between Lambda function versions.

---

### Question 42
A company wants to reduce their AWS spend by identifying idle and underutilized resources across 50 accounts. They want recommendations for right-sizing and cost savings. What tools and approach should the architect use?

A) Manually review each account's billing console.  
B) Implement multi-layered cost optimization: (1) AWS Cost Explorer right-sizing recommendations for EC2 instances (based on CPU/memory utilization). (2) AWS Compute Optimizer for detailed right-sizing recommendations for EC2, EBS, Lambda, and ECS (uses ML on CloudWatch metrics). (3) AWS Trusted Advisor for idle resources (unused EBS volumes, idle load balancers, unused Elastic IPs). (4) Savings Plans recommendations from Cost Explorer for committed-use savings. (5) Implement a Lambda function that scans all accounts for: stopped EC2 instances, unattached EBS volumes, unused ENIs, old snapshots, idle RDS instances. (6) Generate weekly cost optimization reports using CUR data in QuickSight. (7) Set up Cost Anomaly Detection for unexpected spend increases.  
C) Use only AWS Trusted Advisor for all cost recommendations.  
D) Set up AWS Budgets and respond only when budgets are exceeded.

**Correct Answer: B**
**Explanation:** Multi-tool approach captures different types of waste. Cost Explorer provides quick right-sizing recommendations. Compute Optimizer uses ML for more accurate sizing. Trusted Advisor finds idle resources. Custom Lambda scanning catches resources that managed tools miss. Savings Plans optimize committed spend. QuickSight dashboards provide ongoing visibility. Cost Anomaly Detection catches emerging issues. Option A doesn't scale to 50 accounts. Option C — Trusted Advisor has limited scope. Option D is reactive, not proactive.

---

### Question 43
A company has deployed Amazon OpenSearch Service for log analytics. The cluster handles 500GB of new data daily and stores 30 days of logs. Query performance has degraded, and the cluster is showing high JVM memory pressure (>80%). What should the architect do?

A) Increase the instance count to add more capacity.  
B) Optimize the OpenSearch cluster: (1) Implement index lifecycle management — use UltraWarm (warm storage) for logs older than 3 days and Cold Storage for logs older than 14 days. This reduces hot node storage and JVM pressure. (2) Review index mapping — disable _all field, reduce the number of indexed fields, use keyword type instead of text for non-searchable fields. (3) Increase the number of data nodes with storage-optimized instances (r6g.large or larger). (4) Implement index rollover policies — create new indices daily with appropriate shard sizes (10-50GB per shard). (5) Force merge old indices to reduce segment count. (6) Enable OpenSearch Serverless for variable workloads.  
C) Delete all logs older than 7 days.  
D) Replace OpenSearch with Athena for all log queries.

**Correct Answer: B**
**Explanation:** JVM memory pressure indicates the hot tier is overloaded. UltraWarm moves older data to cost-effective storage that doesn't consume JVM heap. Proper shard sizing and index management reduce overhead. Mapping optimization reduces memory per document. Force merge consolidates segments. These are standard OpenSearch optimization techniques. Option A adds compute without addressing the root cause (data management). Option C may violate retention requirements. Option D — Athena has higher query latency than OpenSearch for interactive log analysis.

---

### Question 44
A company needs to implement a globally distributed API that serves users from the nearest Region. API responses include personalized data, so they cannot be cached. Each Region has its own set of backend services. What architecture minimizes latency for global users?

A) Deploy the API in one Region and use CloudFront for global distribution.  
B) Use Amazon API Gateway in each Region with AWS Global Accelerator: (1) Deploy identical API Gateway + backend services in each Region. (2) AWS Global Accelerator provides two static anycast IPs that route users to the nearest healthy Region's API Gateway. (3) Global Accelerator health checks monitor each Region's API endpoint and automatically fail over unhealthy Regions. (4) Since responses are personalized (uncacheable), Global Accelerator's optimized AWS network path provides the latency benefit (not caching). (5) DynamoDB Global Tables provide multi-Region data access for personalized data.  
C) Use Route 53 latency-based routing to Regional APIs.  
D) Use CloudFront with Lambda@Edge for API processing.

**Correct Answer: B**
**Explanation:** Global Accelerator is ideal for uncacheable, personalized API traffic. Its anycast IPs route users to the nearest Region via AWS's private backbone (lower latency than public internet). Health checks provide automatic failover. Static IPs simplify DNS management. Combined with DynamoDB Global Tables, each Region serves personalized data locally. Option A — single-Region adds latency for distant users. Option C works but has DNS caching delays during failover. Option D — Lambda@Edge can't process personalized data requiring backend access.

---

### Question 45
A company has a monolithic application running on a large EC2 instance (r5.4xlarge) in a single AZ. The application has periodic memory leaks that cause crashes every 3-4 days. The team can't fix the leak quickly. What should the architect implement as a temporary measure while the fix is developed?

A) Deploy a larger instance to delay the memory leak effect.  
B) Implement automatic recovery and monitoring: (1) Deploy behind an Auto Scaling group with desired count of 1, spanning multiple AZs — ASG automatically replaces failed instances. (2) Create a CloudWatch alarm on StatusCheckFailed that triggers EC2 auto-recovery (maintains the same EBS volumes, EIP, and instance ID). (3) Create a CloudWatch alarm on MemoryUtilization (from CloudWatch Agent) — when memory exceeds 90%, trigger a scheduled SSM Automation document that gracefully drains connections and restarts the application process. (4) Use an ALB with connection draining to handle the restart gracefully. (5) Store session state in ElastiCache (not on the instance) to survive restarts.  
C) Schedule a cron job to reboot the instance every 2 days.  
D) Add a swap file to extend available memory.

**Correct Answer: B**
**Explanation:** The multi-layered approach handles the memory leak automatically. The ASG replaces crashed instances. CloudWatch memory alarm triggers graceful restart before crash. Connection draining prevents dropped requests. External session state survives restarts. This keeps the application available while the team works on the fix. Option A just delays the problem. Option C — blind reboots may disrupt during peak hours. Option D — swap adds latency without fixing the leak.

---

### Question 46
A company operates a media streaming service that uses CloudFront for content delivery. They notice that certain users are sharing their streaming URLs with unauthorized users. They want to restrict access so that only authenticated, paying subscribers can access the content. What should the architect implement?

A) Use CloudFront's geographic restrictions to block unauthorized Regions.  
B) Implement signed URLs or signed cookies with CloudFront: (1) For individual video streams, use CloudFront signed URLs with expiration times (e.g., 4 hours). (2) For multiple resources (playlist + segments), use signed cookies that grant access to a URL pattern. (3) The application's authentication service generates signed URLs/cookies after verifying the user's subscription status. (4) CloudFront validates the signature before serving content — unsigned or expired requests are denied. (5) Use AWS WAF to add additional protection (rate limiting, bot detection). (6) Enable CloudFront access logging for monitoring unauthorized access attempts.  
C) Make all content public and trust the honor system.  
D) Use S3 bucket policies to restrict access.

**Correct Answer: B**
**Explanation:** CloudFront signed URLs/cookies provide cryptographic access control for content. The application generates signed URLs only for authenticated subscribers. The URL includes an expiration timestamp, so shared URLs expire quickly. Signed cookies handle multi-resource access (HLS/DASH streaming with many segment files). WAF adds defense against automated sharing. Access logging enables monitoring. Option A doesn't authenticate individual users. Option C provides no access control. Option D — S3 bucket policies can't validate per-user authentication for CloudFront-served content.

---

### Question 47
A company is designing a backup and recovery strategy for their multi-account environment. They need centralized backup management, cross-account backup copies, and protection against ransomware (backup deletion). What should the architect configure?

A) Use AWS Backup in each account independently.  
B) Implement centralized backup with AWS Backup: (1) Enable AWS Backup with Organizations integration from a central backup account. (2) Create backup policies in AWS Organizations that automatically apply to all member accounts. (3) Configure backup plans for all supported services (EC2, EBS, RDS, DynamoDB, EFS, S3). (4) Use cross-account backup — copy backups to a vault in the central backup account. (5) Enable AWS Backup Vault Lock (compliance mode) on the central vault — prevents anyone (including root) from deleting backups for the retention period. (6) Vault Lock protects against ransomware because even if an attacker compromises a member account, they cannot delete the cross-account backup copies.  
C) Use EBS snapshots and S3 versioning as the backup strategy.  
D) Create AMIs of all EC2 instances as backups.

**Correct Answer: B**
**Explanation:** AWS Backup with Organizations provides centralized, policy-based backup management. Cross-account copies ensure backups exist outside the blast radius of a compromised account. Vault Lock in compliance mode makes backups immutable — ransomware attackers cannot delete them even with root access. Organization-level backup policies ensure all accounts have consistent backup coverage. Option A lacks centralization and cross-account protection. Option C covers only EBS and S3. Option D only backs up EC2 (misses databases, storage).

---

### Question 48
A company needs to migrate a 100TB data warehouse from Oracle Exadata to Amazon Redshift. The migration must complete within a 48-hour maintenance window. How should the architect plan the migration?

A) Export data from Oracle and import into Redshift during the 48-hour window.  
B) Pre-migrate most data before the window: (1) Use AWS Schema Conversion Tool (SCT) to convert Oracle schema, views, and stored procedures to Redshift-compatible DDL. (2) Pre-load the majority of data (90TB of historical data that doesn't change) to Redshift using SCT data extraction agents → S3 → Redshift COPY command over the weeks before the window. (3) During the 48-hour window: use SCT/DMS for the remaining 10TB of recent data (changed since pre-load) and final delta sync. (4) Validate row counts and data checksums between Oracle and Redshift. (5) Switch application connections to Redshift. (6) Use Redshift's COPY command with parallel loading from multiple S3 files for maximum throughput.  
C) Use AWS DMS to replicate the entire 100TB during the 48-hour window.  
D) Use Snowball devices to physically ship the data.

**Correct Answer: B**
**Explanation:** At 100TB, migration within 48 hours requires pre-staging most data. Historical data (static) is loaded beforehand over weeks. Only the delta (changed data since pre-load) needs to transfer during the window. SCT converts schema and code. Parallel COPY from S3 maximizes Redshift ingestion speed. Checksum validation ensures data integrity. Option A — exporting and importing 100TB in 48 hours is risky. Option C — DMS migrating 100TB in 48 hours requires extremely high bandwidth. Option D — Snowball takes days for delivery/return.

---

### Question 49
A company is running a CI/CD pipeline that deploys to production. A recent deployment caused a production outage because a configuration change was incorrect. They want to implement automated rollback capabilities. The application runs on ECS behind an ALB. What rollback strategy should the architect implement?

A) Keep manual deployment procedures and roll back by redeploying the previous version.  
B) Implement automated rollback with CodeDeploy blue/green: (1) ECS with CodeDeploy deployment controller. (2) CodeDeploy creates a new (green) target group with the new version. (3) Traffic shifts gradually (canary or linear). (4) CloudWatch alarms monitor key metrics: ALB 5xx error rate, application error rate (custom metric), response latency P99. (5) If any alarm triggers during the deployment window, CodeDeploy automatically rolls back — shifts 100% traffic back to the original (blue) target group and terminates the green tasks. (6) Configure rollback trigger alarms with appropriate thresholds (e.g., 5xx rate > 1%, P99 latency > 500ms). (7) Enable CloudWatch Composite Alarms that combine multiple conditions.  
C) Run production tests after full deployment and rollback manually if they fail.  
D) Use a feature flag to disable the problematic code.

**Correct Answer: B**
**Explanation:** CodeDeploy blue/green with CloudWatch alarms provides fully automated rollback. The green target group operates alongside the blue — rollback is instant (shift traffic back, terminate green). No data loss or extended outage. Alarms trigger automatically based on real production metrics. Composite alarms combine multiple signals for higher accuracy. Option A is slow (requires redeployment). Option C is reactive (outage already occurred). Option D requires code instrumentation and doesn't address configuration issues.

---

### Question 50
A company needs to build a data pipeline that processes incoming CSV files, validates them, transforms them into Parquet format, and loads them into a data warehouse. Files arrive unpredictably, ranging from 10MB to 50GB. The pipeline must be serverless and cost-effective. What architecture should the architect design?

A) Deploy EMR cluster to process all files.  
B) Build an event-driven serverless pipeline: (1) S3 event notification on file upload → EventBridge → Step Functions. (2) Step Functions choice state: if file < 500MB, process with Lambda; if file > 500MB, process with AWS Glue Spark job. (3) Validation step: Lambda function checks CSV schema, data types, and value ranges. Invalid files move to an error bucket with notification. (4) Transformation step: Lambda or Glue converts CSV to Parquet (columnar format). (5) Loading step: Redshift COPY command or Glue Crawler catalogs the Parquet files in the data lake. (6) For Lambda: use /tmp storage for files < 500MB, streaming processing for larger files. (7) For Glue: job bookmarks prevent reprocessing. Pay only when processing runs.  
C) Use Lambda for all file sizes.  
D) Use a cron-based batch job running every hour.

**Correct Answer: B**
**Explanation:** The adaptive pipeline uses Lambda for small files (cost-effective, fast) and Glue Spark for large files (handles 50GB). Step Functions orchestrates with a file-size-based routing decision. S3 events provide immediate processing (no waiting for a batch window). Validation prevents bad data from propagating. Serverless = zero cost when idle. Option A — EMR cluster has fixed costs. Option C — Lambda has memory (10GB) and storage (/tmp 10GB) limits that can't handle 50GB files. Option D adds unnecessary latency.

---

### Question 51
A company's application stores customer profile images in S3. They want to serve these images globally with low latency, automatically resize them for different devices (mobile, tablet, desktop), and protect against hotlinking from unauthorized sites. What architecture should the architect design?

A) Store all image sizes in S3 and serve through CloudFront.  
B) Implement dynamic image processing with CloudFront: (1) CloudFront distribution with S3 as the origin for original images. (2) Lambda@Edge (Origin Response) or CloudFront Functions for on-the-fly image resizing based on query parameters (width, height, quality) or device type (from User-Agent header). (3) Cache resized images in CloudFront (different cache keys per dimension). (4) Referer header check in CloudFront or WAF to prevent hotlinking — only allow requests from authorized domains. (5) Signed URLs for authenticated access to premium content. (6) CloudFront Origin Access Identity (OAI) or Origin Access Control (OAC) to prevent direct S3 access.  
C) Use API Gateway + Lambda for image resizing on every request.  
D) Pre-generate all possible image sizes.

**Correct Answer: B**
**Explanation:** Lambda@Edge provides on-the-fly image processing at CloudFront edge locations. Resized images are cached, so subsequent requests are served instantly. Device-based sizing provides optimal images per device. Referer checking prevents hotlinking. OAC ensures images are only accessible through CloudFront. This is more efficient than pre-generating all sizes. Option A requires pre-generating every size. Option C doesn't cache at the edge. Option D is storage-expensive and can't cover all possible dimensions.

---

### Question 52
A company's development team deploys infrastructure using CloudFormation. They occasionally encounter stack update failures that leave resources in UPDATE_ROLLBACK_FAILED state, requiring manual intervention. How should the architect prevent and handle this?

A) Avoid using CloudFormation for complex deployments.  
B) Implement resilient CloudFormation practices: (1) Enable CloudFormation stack protection: termination protection to prevent accidental deletion. (2) Use change sets instead of direct updates — review changes before execution. (3) Implement stack policies that protect critical resources from accidental replacement/deletion. (4) For UPDATE_ROLLBACK_FAILED state: use ContinueUpdateRollback API with resources to skip (skip the resources causing the rollback failure). (5) Use CloudFormation drift detection to identify out-of-band changes before updates. (6) Implement custom resources with proper error handling (Lambda-backed resources must signal success/failure). (7) Use nested stacks for modularity and independent lifecycle management.  
C) Use Terraform instead of CloudFormation.  
D) Deploy resources manually and import them into CloudFormation.

**Correct Answer: B**
**Explanation:** Resilient CloudFormation practices prevent and handle failures. Change sets show exactly what will change before execution. Stack policies protect critical resources. ContinueUpdateRollback skips problematic resources to recover from failed rollbacks. Drift detection catches manual changes that cause update conflicts. Proper custom resource error handling prevents hanging stacks. Nested stacks provide modularity. Option A abandons a valid tool. Option C — similar issues exist with any IaC tool. Option D creates state management problems.

---

### Question 53
A company runs a critical database on Amazon Aurora MySQL. They need to implement a disaster recovery strategy with an RPO of 1 second and an RTO of 1 minute for Regional failures. What architecture should the architect design?

A) Use Aurora automated backups with point-in-time recovery.  
B) Deploy Aurora Global Database with write forwarding: (1) Primary cluster in us-east-1, secondary cluster in us-west-2. (2) Aurora Global Database provides <1 second replication lag (meeting 1-second RPO). (3) In a disaster, promote the secondary cluster to standalone primary — promotion takes ~1 minute (meeting 1-minute RTO). (4) Configure Route 53 health checks on the primary Region. (5) Route 53 failover routing with alias records pointing to Regional Aurora endpoints. (6) Enable write forwarding on the secondary cluster — during normal operation, applications in us-west-2 can write to the secondary which forwards to the primary, reducing latency for multi-Region applications.  
C) Use Aurora Multi-AZ for Regional disaster recovery.  
D) Take hourly Aurora snapshots and copy them cross-Region.

**Correct Answer: B**
**Explanation:** Aurora Global Database provides <1 second cross-Region replication (RPO < 1 second) and ~1-minute promotion time (RTO ~1 minute). This exactly meets the requirements. Write forwarding enables active-active read/write patterns. Route 53 failover automates traffic routing after promotion. Option A — point-in-time recovery is Region-scoped (doesn't protect against Regional failure). Option C — Multi-AZ protects against AZ failure, not Regional failure. Option D — hourly snapshots give RPO of 1 hour (doesn't meet 1-second requirement).

---

### Question 54
A company wants to implement a service that receives webhook notifications from 50 different SaaS providers (Stripe, Salesforce, GitHub, etc.). Each provider sends webhooks in a different format. The service must validate, normalize, and route these events to the appropriate internal system. What architecture should the architect design?

A) Deploy an EC2 instance with a custom webhook receiver for each provider.  
B) Build a serverless webhook gateway: (1) Amazon API Gateway endpoint for each provider (or a single endpoint with path-based routing /webhooks/{provider}). (2) Lambda authorizer that validates provider-specific webhook signatures (HMAC, OAuth, etc.). (3) Lambda function per provider that normalizes the webhook payload to a common internal event format. (4) Normalized events published to Amazon EventBridge custom event bus. (5) EventBridge rules route events to appropriate internal systems (SQS, Lambda, Step Functions) based on event type. (6) SQS queue as dead-letter for failed processing. (7) Store raw webhook payloads in S3 for audit and replay.  
C) Use a single Lambda function that handles all 50 webhook formats.  
D) Use Amazon SNS as the webhook receiver.

**Correct Answer: B**
**Explanation:** The webhook gateway pattern normalizes diverse webhook formats into a consistent internal event format. Per-provider Lambda functions handle format-specific validation and transformation. EventBridge provides flexible routing based on event content. API Gateway handles HTTPS endpoint management and throttling. Dead-letter queues prevent data loss. Raw storage enables replay. Option A doesn't scale and requires managing infrastructure. Option C — a single function handling 50 formats becomes complex and hard to maintain. Option D — SNS can't validate webhook signatures.

---

### Question 55
A company is running Amazon Redshift as their data warehouse. Query performance has degraded as the cluster grows to 50TB. Analysts report that complex queries take 20+ minutes. What should the architect do to optimize Redshift performance?

A) Add more nodes to the cluster.  
B) Optimize Redshift comprehensively: (1) Review table design: check distribution keys (DISTKEY) to minimize data redistribution, sort keys (SORTKEY) to optimize frequently filtered columns, and compression encoding (ENCODE). (2) Run VACUUM and ANALYZE to reclaim space and update statistics. (3) Enable Redshift Concurrency Scaling to handle query bursts (automatically adds clusters for queued queries). (4) Use Redshift Spectrum to offload queries on cold data to S3 (reducing hot data cluster size). (5) Implement workload management (WLM) queues to prioritize critical queries. (6) Use materialized views for frequently run complex queries. (7) Review query plans using EXPLAIN and optimize problematic queries. (8) Consider RA3 nodes with managed storage for cost-effective scaling.  
C) Replace Redshift with Athena for all queries.  
D) Increase the Redshift cluster timeout for long queries.

**Correct Answer: B**
**Explanation:** Redshift performance optimization requires multiple strategies. Distribution keys minimize data movement during joins. Sort keys speed up range-filtered queries. Compression reduces I/O. VACUUM/ANALYZE maintain performance. Concurrency Scaling handles parallel query load. Spectrum offloads cold data queries to S3. WLM prioritizes critical work. Materialized views cache complex results. RA3 nodes provide elastic storage. Option A may help but doesn't address the root causes. Option C — Athena has higher latency for complex analytical queries. Option D doesn't fix performance.

---

### Question 56
A company has a microservices application where each service writes logs to CloudWatch Logs. They want to implement a centralized alerting system that detects specific error patterns across all services and creates tickets in their Jira system. What should the architect design?

A) Review CloudWatch Logs manually for errors.  
B) Build an automated alerting pipeline: (1) CloudWatch Logs Metric Filters across all log groups — detect specific error patterns (e.g., "FATAL", "OutOfMemoryError", "ConnectionRefused") and emit custom CloudWatch metrics. (2) CloudWatch Alarms on the custom metrics with appropriate thresholds (e.g., > 5 FATAL errors in 5 minutes). (3) Alarms trigger SNS topic → Lambda function. (4) Lambda creates Jira tickets using the Jira REST API with relevant error details (service name, error message, timestamp, log group link). (5) Lambda checks for existing open tickets for the same error pattern to avoid duplicates. (6) CloudWatch Logs Insights queries embedded in the ticket for investigation context.  
C) Use CloudWatch Anomaly Detection for all error alerting.  
D) Create separate alarms in each service's account.

**Correct Answer: B**
**Explanation:** Metric Filters efficiently detect error patterns in log streams and convert them to metrics. CloudWatch Alarms provide threshold-based alerting. Lambda-to-Jira integration automates ticket creation. Duplicate detection prevents alert fatigue. Embedded Logs Insights queries give the incident responder immediate investigation context. Option A doesn't scale. Option C — Anomaly Detection is for metrics, not log pattern matching. Option D doesn't centralize the alerting.

---

### Question 57
A company wants to implement a multi-tenant SaaS application where tenant onboarding (new customer signup) automatically provisions all required AWS resources (DynamoDB tables, S3 buckets, Lambda functions). The onboarding must complete within 5 minutes. What automation should the architect build?

A) Manually provision resources for each new tenant.  
B) Build an automated tenant onboarding pipeline: (1) API Gateway receives tenant signup request. (2) Lambda function validates the request and creates a record in the tenant registry (DynamoDB). (3) Step Functions orchestrates resource provisioning: Create DynamoDB table partitions (or configure tenant-specific GSIs), create S3 prefix structure, deploy tenant-specific Lambda configurations via CloudFormation stack. (4) CloudFormation StackSets or custom Lambda for cross-account provisioning if using account-per-tenant model. (5) Store tenant configuration (resource ARNs, endpoints) in the tenant registry. (6) Send onboarding completion notification via SES. (7) Full provisioning completes in < 5 minutes.  
C) Use AWS Service Catalog to let tenants provision their own resources.  
D) Pre-provision all resources and assign them to tenants.

**Correct Answer: B**
**Explanation:** Automated onboarding provides a consistent, fast, error-free provisioning experience. Step Functions orchestrates the multi-step workflow with error handling. CloudFormation provides repeatable resource provisioning. The tenant registry tracks all per-tenant resources. SES notification completes the onboarding experience. < 5-minute target is achievable with managed services. Option A doesn't scale. Option C requires tenant AWS expertise. Option D wastes resources for unneeded tenants.

---

### Question 58
A company runs a batch processing system that processes 10,000 jobs per day. Each job takes 5-30 minutes and requires 2-8 vCPUs. Jobs are independent of each other. They want to minimize compute cost while maintaining processing throughput. What compute architecture should the architect use?

A) Deploy a fixed fleet of EC2 instances to process all jobs.  
B) Use AWS Batch with Spot Instances: (1) AWS Batch manages the compute environment, job queues, and scheduling. (2) Configure a Spot compute environment with a mix of instance types (c5, m5, r5) for maximum Spot availability. (3) Batch automatically provisions Spot Instances when jobs are queued and terminates them when processing completes. (4) Set a Spot bid price at the on-demand price (maximizes availability). (5) Configure a fallback on-demand compute environment for jobs that must complete by a deadline. (6) Multi-AZ Spot to reduce interruption risk. (7) Batch handles job retries if a Spot Instance is reclaimed.  
C) Use Lambda for all batch jobs.  
D) Use ECS Fargate for all batch processing.

**Correct Answer: B**
**Explanation:** AWS Batch is purpose-built for batch processing — it manages compute provisioning, job scheduling, and retries. Spot Instances provide up to 90% savings over on-demand. Mixed instance types maximize Spot availability. Automatic retry handles Spot interruptions. The fallback on-demand environment ensures deadline-critical jobs complete. Batch scales to zero when idle. Option A wastes money during idle periods. Option C — Lambda has a 15-minute timeout (jobs run up to 30 minutes). Option D — Fargate is more expensive than Spot EC2 for batch processing.

---

### Question 59
A company has deployed an API that accepts file uploads up to 5GB. Currently, the API uses API Gateway + Lambda, but they're hitting the API Gateway payload size limit (10MB). How should the architect redesign the upload mechanism for large files?

A) Increase the API Gateway payload limit.  
B) Implement presigned URL-based uploads: (1) Client requests an upload URL from the API (API Gateway → Lambda). (2) Lambda generates an S3 presigned URL with a 5GB limit, expiration time, and optional content type restrictions. (3) Client uploads the file directly to S3 using the presigned URL (bypasses API Gateway entirely). (4) S3 event notification triggers Lambda for post-upload processing (virus scanning, metadata extraction). (5) For files > 5GB, use S3 multipart upload with presigned URLs for each part. (6) Lambda returns the upload status and metadata to the client via the API. (7) Use S3 Transfer Acceleration for faster uploads from distant users.  
C) Deploy a separate NLB with EC2 instances for file uploads.  
D) Use CloudFront for file uploads.

**Correct Answer: B**
**Explanation:** Presigned URLs allow direct client-to-S3 uploads, bypassing API Gateway's payload limit entirely. The API only handles the URL generation (small payload). S3 handles the actual file transfer (supports objects up to 5TB). Event-driven post-processing (virus scan, metadata extraction) runs after upload. Multipart upload handles very large files. Transfer Acceleration optimizes upload speed globally. Option A — API Gateway max is 10MB, not extendable. Option C adds infrastructure to manage. Option D — CloudFront is optimized for delivery, not uploads.

---

### Question 60
A company operates an e-commerce platform where products frequently go in and out of stock. They want to implement a real-time inventory system that reflects stock changes within 1 second across all frontend servers (50 instances). What architecture ensures real-time inventory visibility?

A) Query the database for every product page view.  
B) Implement a real-time cache invalidation architecture: (1) Inventory updates write to DynamoDB. (2) DynamoDB Streams captures changes. (3) Lambda processes the stream and updates ElastiCache for Redis (stock levels). (4) Lambda also publishes to SNS → each frontend server has a local subscription that invalidates its local cache. (5) Frontend servers check ElastiCache for stock levels (sub-millisecond reads). (6) For critical actions (add to cart), use a DynamoDB conditional write to verify stock availability at transaction time, preventing overselling. (7) TTL on cache entries as a safety net for missed invalidation events.  
C) Use S3 to store stock levels and CloudFront for caching.  
D) Refresh all caches on a 5-minute schedule.

**Correct Answer: B**
**Explanation:** DynamoDB Streams + Lambda + ElastiCache provides sub-second stock update propagation. Redis provides sub-millisecond reads for high-traffic product pages. SNS fan-out invalidates local caches on all 50 frontend servers. DynamoDB conditional writes prevent overselling (race condition protection). TTL provides eventual consistency safety net. Option A doesn't scale for high-traffic product pages. Option C — S3 + CloudFront has higher latency and no sub-second cache invalidation. Option D — 5-minute staleness causes overselling.

---

### Question 61
A company's security team wants to ensure that all IAM roles across their Organization follow the principle of least privilege. Many roles have accumulated excessive permissions over time. How should the architect identify and remediate over-permissioned roles?

A) Manually review all IAM policies.  
B) Use IAM Access Analyzer for continuous least-privilege analysis: (1) IAM Access Analyzer unused access analysis — identifies permissions granted but never used over a specified period (90 days). (2) Generate refined IAM policies using Access Analyzer's policy generation feature, which creates policies based on actual CloudTrail activity. (3) Use Access Analyzer's policy validation to check existing policies for overly broad actions (wildcard resources, missing conditions). (4) Implement a workflow: Access Analyzer identifies over-permissioned roles → SNS notification to role owner → owner reviews and applies the generated least-privilege policy → Access Analyzer re-validates.  
C) Remove all custom IAM policies and use only AWS-managed policies.  
D) Set all roles to read-only and add permissions as requested.

**Correct Answer: B**
**Explanation:** Access Analyzer provides data-driven least-privilege enforcement. Unused access analysis identifies permissions granted but never exercised. Policy generation creates policies from actual usage (CloudTrail data), ensuring only needed permissions are retained. Policy validation catches anti-patterns. The workflow automates the review and remediation process. Option A doesn't scale. Option C — AWS-managed policies are often too broad. Option D disrupts operations and doesn't use data-driven analysis.

---

### Question 62
A company has deployed Amazon ElastiCache for Redis as a caching layer. During peak traffic, they observe cache misses increasing due to memory eviction (maxmemory reached). The eviction policy is allkeys-lru. What should the architect do?

A) Switch to a larger node type immediately.  
B) Optimize the caching strategy: (1) Analyze key size and TTL distribution — use Redis INFO and MEMORY USAGE commands. (2) Reduce value sizes with compression (Redis doesn't compress natively — compress in the application). (3) Set appropriate TTLs on all keys — ensure no keys are stored indefinitely if they have limited usefulness. (4) Implement cache tiering — use local in-process cache (Caffeine/Guava) for the hottest data (eliminates network round-trip) with Redis as L2 cache. (5) Vertical scaling: upgrade to a node with more memory. (6) Horizontal scaling: enable cluster mode with multiple shards to distribute keys across more nodes. (7) Review eviction policy — volatile-lru only evicts keys with TTL, preserving permanent keys.  
C) Disable maxmemory limit to prevent eviction.  
D) Replace Redis with DynamoDB.

**Correct Answer: B**
**Explanation:** Memory optimization should precede scaling. Analyzing key distribution reveals optimization opportunities (large unused keys, missing TTLs). Compression reduces memory per key. TTLs ensure expired data is reclaimed. Local caching reduces Redis load. If optimization isn't sufficient, scale vertically (more memory) or horizontally (more shards). The eviction policy should match the access pattern. Option A may be needed but should follow optimization. Option C — disabling maxmemory risks OOM crashes. Option D changes the architecture.

---

### Question 63
A company has a mobile application that needs to authenticate users, store user profiles, sync data offline, and send push notifications. They want minimal backend code. What AWS services should the architect combine?

A) Build a custom backend on EC2 for all mobile services.  
B) Use AWS Amplify with managed services: (1) Amazon Cognito for user authentication (sign-up, sign-in, social login, MFA). (2) AWS AppSync (GraphQL) for real-time data sync and offline support — AppSync resolvers connect to DynamoDB for user profiles and app data. (3) Amazon SNS for push notifications to iOS (APNs) and Android (FCM). (4) Amazon S3 with Cognito Identity Pool for user-specific file storage (profile photos). (5) Amazon Pinpoint for targeted push notifications based on user segments. (6) AWS Amplify SDK in the mobile app for easy integration with all services.  
C) Use API Gateway + Lambda for all mobile backend needs.  
D) Use Firebase instead of AWS services.

**Correct Answer: B**
**Explanation:** Amplify + managed services provides a full mobile backend with minimal custom code. Cognito handles auth. AppSync provides GraphQL with offline sync (built-in conflict resolution). SNS/Pinpoint handle push notifications. S3 + Cognito Identity handles user-specific storage. Amplify SDK simplifies client-side integration. Option A requires building and managing everything custom. Option C provides an API but doesn't handle offline sync, push notifications, or auth natively. Option D uses a competitor's services.

---

### Question 64
A company is evaluating Reserved Instances vs. Savings Plans for their EC2 fleet. They run a mix of instance types across 5 Regions, and their workloads shift between instance types quarterly. What purchasing strategy should the architect recommend?

A) Purchase Standard Reserved Instances for all instances.  
B) Use Compute Savings Plans as the primary commitment: (1) Compute Savings Plans apply to any EC2 instance regardless of Region, instance family, size, OS, or tenancy — providing maximum flexibility for workloads that shift between instance types. (2) Analyze Cost Explorer's Savings Plans recommendations to determine the optimal hourly commitment. (3) Start with a conservative commitment (covering 60-70% of baseline usage) and increase over time. (4) Complement with on-demand for remaining variable workload. (5) For truly stable workloads, use EC2 Instance Savings Plans (more restrictive but higher discount) for the predictable portion. (6) Review and adjust commitments quarterly based on usage trends.  
C) Use Spot Instances for all workloads.  
D) Use only on-demand to maintain maximum flexibility.

**Correct Answer: B**
**Explanation:** Compute Savings Plans provide the best balance of cost savings (up to 66% discount) and flexibility (any instance type, Region, OS). Since the company shifts instance types quarterly, the Region/type flexibility of Compute Savings Plans is critical. Starting conservatively prevents over-commitment. Blending with Instance Savings Plans for stable workloads maximizes total savings. Option A — Standard RIs are locked to instance type and Region (no quarterly flexibility). Option C — Spot has interruption risk. Option D misses 66% savings opportunity.

---

### Question 65
A company runs a media processing pipeline that uses Step Functions to orchestrate Lambda functions. One Lambda function calls a third-party API that has a rate limit of 10 requests per second. During peak processing, 100 Step Functions executions run concurrently, all trying to call the API simultaneously. What should the architect do?

A) Increase the third-party API rate limit.  
B) Implement rate-controlled API calls: (1) Instead of calling the API directly from Lambda, send the request to an SQS queue. (2) A separate Lambda function processes the SQS queue with reserved concurrency set to 10 (matching the API rate limit). (3) The Step Functions task uses a callback pattern (waitForTaskToken): it sends a task token with the SQS message and pauses. (4) When the rate-limited Lambda processes the message and gets the API response, it calls SendTaskSuccess with the task token, resuming the Step Functions execution. (5) This decouples the Step Functions execution rate from the API rate limit. (6) SQS handles the backpressure naturally — messages queue up and are processed at the API's rate.  
C) Add a sleep state in Step Functions between API calls.  
D) Implement retry logic in Lambda when the API returns rate limit errors.

**Correct Answer: B**
**Explanation:** The callback pattern with SQS decouples the Step Functions concurrency from the API rate limit. SQS queues requests naturally. Reserved concurrency (10) ensures exactly 10 concurrent Lambda invocations processing the queue — matching the API's rate limit. The callback token pauses the Step Functions execution without consuming resources, resuming only when the API response is available. Option A depends on a third party. Option C — sleep adds latency to all executions without precise rate control. Option D wastes Lambda invocations on retries and doesn't solve the rate limiting.

---

### Question 66
A company has a legacy application that uses NFS for shared storage between multiple application servers. They're migrating to AWS and need a shared file system that supports NFS, provides high availability across AZs, and scales automatically. What should the architect recommend?

A) Deploy a self-managed NFS server on EC2.  
B) Use Amazon EFS (Elastic File System): (1) Create an EFS file system with Standard storage class. (2) Mount targets in each AZ where application instances run. (3) EFS provides NFS v4.1 protocol compatibility — existing applications mount it without code changes. (4) EFS automatically scales (petabyte capacity) with no provisioning needed. (5) Multi-AZ replication for high availability. (6) Use EFS lifecycle management to automatically move infrequently accessed files to EFS IA (Infrequent Access) storage class for cost savings. (7) For performance, choose between General Purpose (latency-sensitive) and Max I/O (throughput-intensive) performance modes. (8) Enable EFS encryption at rest (KMS) and in transit.  
C) Use S3 with s3fs-fuse mount for NFS compatibility.  
D) Use FSx for Lustre for NFS storage.

**Correct Answer: B**
**Explanation:** EFS is the managed NFS service for AWS. It supports NFSv4.1, scales automatically, replicates across AZs, and requires no infrastructure management. Mount targets in each AZ provide local access. Lifecycle management optimizes costs. Encryption provides security. Existing NFS-based applications work without changes. Option A requires managing NFS server HA, patching, and scaling. Option C — s3fs-fuse has poor performance and isn't truly NFS. Option D — FSx for Lustre uses a different protocol (not NFS).

---

### Question 67
A company wants to implement a disaster recovery test that validates their failover procedure without affecting production. They want to test Route 53 failover, Aurora Global Database promotion, and ECS service activation in the DR Region. How should the architect conduct the test?

A) Simulate a disaster by shutting down the primary Region's resources.  
B) Conduct a controlled DR test: (1) Create a Route 53 health check that can be manually set to unhealthy (health check that checks a specific CloudWatch alarm that you control). (2) Trigger the alarm to make the health check fail, causing Route 53 to failover DNS to the DR Region. (3) In the DR Region: promote Aurora secondary cluster using the "detach and promote" method (creates an independent cluster without affecting the primary's global database). (4) Start the ECS services in the DR Region. (5) Route test traffic to the DR Region and validate application functionality. (6) After testing: re-add the promoted Aurora cluster as a secondary, deactivate ECS services in DR, reset the health check. (7) Document results and time metrics (RPO/RTO achieved vs. target).  
C) Test only individual components, not the full failover procedure.  
D) Use a GameDay with production traffic to test DR.

**Correct Answer: B**
**Explanation:** Controlled DR testing validates the full failover procedure without impacting production. The manual health check trigger simulates a Route 53 failover. Aurora "detach and promote" tests the promotion process without breaking the global database. Test traffic validates the DR environment. Documentation proves the DR plan works. Cleanup restores normal operation. Option A is risky (actually impacts production). Option C doesn't test the integration between components. Option D risks production impact.

---

### Question 68
A company has a Step Functions workflow that processes customer orders. Occasionally, the workflow gets stuck in a "running" state because a Lambda function times out waiting for an external system response. The stuck workflows consume Step Functions state transitions and prevent new orders from processing. What should the architect implement?

A) Increase the Lambda timeout to avoid timeouts.  
B) Implement timeout and heartbeat handling: (1) Set TimeoutSeconds on each Step Functions task state to an appropriate duration (e.g., 5 minutes). If the task doesn't complete within the timeout, Step Functions transitions to a catch/fallback state. (2) For long-running tasks, use HeartbeatSeconds — the Lambda sends periodic heartbeat signals to Step Functions, proving it's still active. If heartbeats stop, Step Functions knows the task is stuck. (3) The catch state routes to error handling: send to a dead-letter queue, alert the team, or retry with a different strategy. (4) Use Step Functions Express Workflows for high-volume, short-duration orders (cheaper and faster). (5) Enable Step Functions logging for debugging stuck workflows.  
C) Set the Step Functions execution timeout to unlimited.  
D) Use SQS instead of Step Functions for order processing.

**Correct Answer: B**
**Explanation:** TimeoutSeconds ensures tasks don't run indefinitely. HeartbeatSeconds detects stuck tasks even before the timeout (the task is alive but not making progress). Catch states route timeout errors to appropriate handling. Express Workflows optimize for high-volume orders. Logging aids debugging. This prevents stuck workflows from accumulating. Option A — longer Lambda timeout just delays the problem. Option C allows infinite stuck workflows. Option D loses orchestration capabilities.

---

### Question 69
A company runs a large EKS cluster with 500 pods across 50 nodes. They want to optimize pod placement to minimize cross-AZ data transfer costs while maintaining high availability. What should the architect configure?

A) Deploy all pods in a single AZ to eliminate cross-AZ costs.  
B) Optimize pod placement for cost and availability: (1) Use Kubernetes topology spread constraints to distribute pods evenly across AZs (maintain HA) while minimizing cross-AZ communication. (2) Co-locate pods that communicate frequently using pod affinity rules (pods that call each other are placed in the same AZ). (3) Use pod anti-affinity to spread replicas of the same service across AZs for HA. (4) Enable ALB AZ affinity (zonal affinity) to prefer routing to targets in the same AZ. (5) Deploy stateful services with node selectors targeting specific AZs to minimize data replication. (6) Monitor cross-AZ data transfer using VPC Flow Logs and Cost Explorer to identify the largest cross-AZ communication paths.  
C) Use separate EKS clusters per AZ.  
D) Use Fargate to let AWS optimize pod placement.

**Correct Answer: B**
**Explanation:** Topology spread constraints maintain HA (pods across AZs) while affinity rules minimize cross-AZ traffic (communicating pods in the same AZ). Anti-affinity ensures service replicas are distributed. ALB AZ affinity keeps request-response within the same AZ when possible. Monitoring identifies the biggest cross-AZ cost drivers for targeted optimization. Option A sacrifices HA. Option C adds cluster management overhead. Option D — Fargate doesn't support pod affinity/anti-affinity rules.

---

### Question 70
A company needs to process 100 million records nightly from multiple source systems, apply complex transformation logic (joins, aggregations, deduplication), and load results into Redshift. The processing must complete within a 4-hour window. What should the architect design?

A) Use Lambda functions chained together for ETL processing.  
B) Build a scalable ETL pipeline: (1) Source data lands in S3 from various ingestion mechanisms. (2) AWS Glue Spark ETL jobs for transformation: joins, aggregations, and deduplication using Spark's distributed processing. (3) Configure Glue with sufficient DPUs (Data Processing Units) to meet the 4-hour window — start with 100 DPUs and tune. (4) Use Glue bookmarks to process only new/changed data incrementally. (5) Enable Glue Auto Scaling for dynamic DPU adjustment. (6) Use Glue Crawler to catalog source data schemas. (7) COPY command to load Parquet output from S3 to Redshift. (8) Orchestrate with Step Functions for workflow management, retry logic, and monitoring.  
C) Use Amazon Athena CTAS for all transformations.  
D) Use Redshift's own ETL capabilities (stored procedures) for everything.

**Correct Answer: B**
**Explanation:** Glue Spark provides distributed processing power for 100 million records. DPU scaling controls processing speed. Bookmarks enable incremental processing (only process changes). Auto Scaling adjusts resources dynamically. S3 → Glue → S3 (Parquet) → Redshift COPY is the standard high-performance ETL path. Step Functions provide orchestration with monitoring. Option A — Lambda has a 15-minute timeout and 10GB memory limit, insufficient for 100M record joins. Option C — Athena isn't optimized for complex multi-step ETL. Option D — Redshift compute is expensive for ETL.

---

### Question 71
A company is deploying an application that needs to comply with data sovereignty requirements in 5 countries. Each country's data must be processed and stored within that country's borders. AWS doesn't have a Region in one of the countries. What should the architect recommend?

A) Store all data in the nearest AWS Region and rely on legal agreements.  
B) For countries with AWS Regions: deploy the application stack in the local Region with strict data controls (SCPs restricting data service access to the local Region, VPC endpoints for private access, encryption with local KMS keys). For the country without an AWS Region: (1) Deploy AWS Outposts at a colocation facility within the country — Outposts provides AWS infrastructure and services in the local territory. (2) If Outposts isn't feasible, use AWS Local Zones if available. (3) As a last resort, deploy on-premises infrastructure connected to the nearest AWS Region via Direct Connect for AWS service integration, with all data remaining on-premises. (4) Implement data residency controls: DLP policies preventing cross-border data transfer, Network Firewall rules blocking cross-Region traffic, automated compliance auditing with Config rules.  
C) Deploy everything in a single Region and encrypt the data for compliance.  
D) Wait until AWS opens a Region in that country.

**Correct Answer: B**
**Explanation:** Data sovereignty requires data to be physically located within the country. For countries with AWS Regions, standard regional deployment with SCPs works. For countries without a Region, Outposts brings AWS infrastructure to local territory (data never leaves). Local Zones provide another option. On-premises hybrid is the fallback. DLP and network controls prevent cross-border data movement. Option A doesn't technically comply with data sovereignty. Option C violates the requirement. Option D delays the project indefinitely.

---

### Question 72
A company's application uses Amazon SQS for message processing. They notice that some messages are being processed multiple times, and some messages are lost when the consumer crashes mid-processing. How should the architect ensure exactly-once processing and no message loss?

A) Increase the SQS visibility timeout.  
B) Implement reliable message processing: (1) Set visibility timeout to 6x the average processing time to prevent duplicate delivery to another consumer. (2) Implement idempotent processing — use a DynamoDB table with message ID as the primary key (conditional write with attribute_not_exists). Before processing, check if the message was already handled. (3) Use the SQS DeleteMessage API only after successful processing and idempotency check. (4) Configure a dead-letter queue (DLQ) with maxReceiveCount of 3 — messages that fail processing 3 times move to the DLQ instead of being reprocessed forever. (5) Set up a CloudWatch alarm on the DLQ for investigation. (6) For strict ordering requirements, use SQS FIFO queues.  
C) Use SNS instead of SQS for guaranteed delivery.  
D) Process messages in batch to reduce duplicate probability.

**Correct Answer: B**
**Explanation:** The visibility timeout prevents duplicate delivery during processing. Idempotency with DynamoDB conditional writes ensures that even if a message is delivered twice, it's processed only once. Deleting after processing prevents message loss (if the consumer crashes, the message becomes visible again after the timeout). DLQ captures poison messages that repeatedly fail. FIFO queues add ordering if needed. Option A alone doesn't ensure idempotency. Option C — SNS is pub/sub, not a queue. Option D doesn't solve the fundamental issues.

---

### Question 73
A company wants to implement a global CDN strategy that serves dynamic content (API responses) with the lowest possible latency. The content cannot be cached because it's personalized per user. What should the architect use?

A) Use CloudFront with no caching (pass-through).  
B) Use a combination of CloudFront and Lambda@Edge: (1) CloudFront as the CDN with origin set to the nearest Regional ALB. (2) Cache-Control: no-cache headers to prevent response caching. (3) Even without caching, CloudFront provides latency benefits: persistent connections to origin (connection pooling), TCP/TLS optimization, HTTP/2 multiplexing, and AWS backbone routing from edge to origin. (4) Lambda@Edge at the origin request event for lightweight personalization or user context injection. (5) CloudFront Origin Shield as a centralized origin-facing cache layer to reduce origin load for semi-personalized content. (6) Enable CloudFront response compression for reduced transfer sizes.  
C) Use Global Accelerator instead of CloudFront.  
D) Deploy the API in every Region for local access.

**Correct Answer: B**
**Explanation:** CloudFront provides latency benefits even without caching: persistent connections to origin eliminate TCP/TLS handshake per request, AWS backbone routing bypasses public internet congestion, HTTP/2 multiplexing reduces overhead, and compression reduces transfer sizes. Lambda@Edge can handle personalization logic at the edge. Origin Shield reduces origin load. Option A is essentially what's described. Option C — Global Accelerator is better for non-HTTP traffic; CloudFront is optimized for HTTP. Option D is expensive and complex.

---

### Question 74
A company runs a multi-account AWS environment and wants to implement automated security compliance. When a new AWS Config rule is deployed to detect a specific non-compliance (e.g., unencrypted EBS volumes), they find that 5,000 existing resources are already non-compliant. How should the architect handle the existing non-compliance while ensuring new resources are compliant?

A) Fix all 5,000 resources manually.  
B) Implement a phased compliance remediation: (1) Immediately deploy the Config rule with auto-remediation for new non-compliant resources (using Config remediation actions + SSM Automation). (2) For the 5,000 existing resources, create a remediation backlog: prioritize by criticality (production before development), sensitivity (data-bearing resources first), and exposure (public-facing first). (3) Use AWS Systems Manager Automation with rate controls (concurrency limit, error threshold) to remediate in batches. (4) Create a compliance exception process — resources that can't be remediated immediately get a documented exception with an expiration date. (5) Dashboard in QuickSight tracking compliance percentage improvement over time. (6) Weekly compliance reports to stakeholders.  
C) Delete the Config rule to avoid showing non-compliance.  
D) Fix all 5,000 at once during a maintenance window.

**Correct Answer: B**
**Explanation:** Phased remediation handles the existing backlog safely while preventing new non-compliance. Auto-remediation stops the bleeding. Prioritization ensures the most critical/exposed resources are fixed first. Rate-controlled SSM Automation prevents mass changes from causing outages. The exception process handles resources that can't be immediately fixed. Dashboards provide visibility. Option A is slow. Option C hides the problem. Option D risks mass outage from simultaneous changes to 5,000 resources.

---

### Question 75
A startup is building their first production application on AWS. They have a small team (3 developers) and need to ship features quickly while maintaining security and reliability. They want a single tool to manage their infrastructure, CI/CD pipeline, and monitoring. What should the architect recommend for maximum developer velocity?

A) Set up individual AWS services (CodePipeline, CloudFormation, CloudWatch) manually.  
B) Use AWS Amplify (for frontend) and AWS CDK with AWS App Runner or Copilot (for backend): (1) AWS CDK (Cloud Development Kit) for infrastructure-as-code using TypeScript — developers write infrastructure in a familiar programming language. (2) AWS App Runner for containerized backend services — deploys from source code or container image with automatic scaling, TLS, and deployment pipeline built in. (3) AWS Amplify Hosting for frontend — Git-connected CI/CD for web apps. (4) Amazon Cognito for authentication. (5) CDK Pipelines for self-mutating CI/CD pipeline that deploys CDK stacks. (6) CloudWatch with CDK-defined alarms and dashboards. This gives a small team production-grade infrastructure with minimal operational overhead.  
C) Use Kubernetes (EKS) for maximum flexibility.  
D) Deploy everything manually and automate later.

**Correct Answer: B**
**Explanation:** For a 3-developer startup, developer velocity is paramount. CDK uses familiar programming languages (TypeScript). App Runner eliminates container orchestration complexity (no EKS/ECS configuration). Amplify Hosting provides zero-config frontend CI/CD. CDK Pipelines automate infrastructure deployment. This stack provides production-grade infrastructure without dedicated DevOps staff. Option A requires learning and configuring many services. Option C adds massive operational overhead for a small team. Option D accumulates technical debt.

---

## Answer Key

| # | Answer | # | Answer | # | Answer | # | Answer | # | Answer |
|---|--------|---|--------|---|--------|---|--------|---|--------|
| 1 | B | 16 | B | 31 | B | 46 | B | 61 | B |
| 2 | B | 17 | B | 32 | B | 47 | B | 62 | B |
| 3 | B | 18 | B | 33 | B | 48 | B | 63 | B |
| 4 | B | 19 | B | 34 | B | 49 | B | 64 | B |
| 5 | B | 20 | B | 35 | B | 50 | B | 65 | B |
| 6 | B | 21 | B | 36 | B | 51 | B | 66 | B |
| 7 | B | 22 | B | 37 | B | 52 | B | 67 | B |
| 8 | B | 23 | B | 38 | B | 53 | B | 68 | B |
| 9 | B | 24 | B | 39 | B | 54 | B | 69 | B |
| 10 | B | 25 | B | 40 | B | 55 | B | 70 | B |
| 11 | B | 26 | A,C | 41 | B | 56 | B | 71 | B |
| 12 | B | 27 | B | 42 | B | 57 | B | 72 | B |
| 13 | B | 28 | B | 43 | B | 58 | B | 73 | B |
| 14 | B | 29 | B | 44 | B | 59 | B | 74 | B |
| 15 | B | 30 | B | 45 | B | 60 | B | 75 | B |

---

### Domain Distribution
- **Domain 1 — Organizational Complexity:** Q1, Q2, Q7, Q10, Q14, Q17, Q19, Q22, Q26, Q29, Q34, Q47, Q54, Q57, Q61, Q64, Q67, Q71, Q74, Q75 (20)
- **Domain 2 — New Solutions:** Q4, Q6, Q9, Q12, Q13, Q18, Q20, Q21, Q27, Q30, Q31, Q35, Q38, Q40, Q44, Q46, Q50, Q53, Q60, Q63, Q66, Q73 (22)
- **Domain 3 — Continuous Improvement:** Q8, Q15, Q24, Q28, Q33, Q36, Q43, Q45, Q52, Q55, Q62 (11)
- **Domain 4 — Migration & Modernization:** Q5, Q16, Q25, Q32, Q41, Q48, Q49, Q59, Q68 (9)
- **Domain 5 — Cost Optimization:** Q3, Q11, Q23, Q37, Q39, Q42, Q51, Q56, Q58, Q65, Q69, Q70, Q72 (13)
