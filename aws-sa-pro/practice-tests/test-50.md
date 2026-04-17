# AWS Certified Solutions Architect - Professional (SAP-C02) Practice Test 50

## FINAL COMPREHENSIVE EXAM — Maximum Difficulty

**This is the hardest practice test in the series. It covers every domain equally, features the longest and most complex scenarios, includes multi-select questions with 5 options choose 3, and tests knowledge of specific service limits and edge cases. Every question is designed to simulate the most challenging real exam scenarios.**

**Exam Distribution (Equal across domains):**
- Domain 1: Design Solutions for Organizational Complexity (~15 questions)
- Domain 2: Design for New Solutions (~15 questions)
- Domain 3: Continuous Improvement for Existing Solutions (~15 questions)
- Domain 4: Accelerate Workload Migration and Modernization (~15 questions)
- Domain 5: Cost-Optimized Architectures (~15 questions)

---

### Question 1
A multinational financial services company operates in 25 countries with strict regulatory requirements. They have an AWS Organization with 500 accounts across 8 OUs. The security team has identified that some development teams have created IAM users with console access and long-lived access keys in production accounts, bypassing the company's SSO policy. The CISO requires: (1) immediate remediation of non-compliant IAM users, (2) prevention of future IAM user creation in production accounts, (3) enforcement of SSO-only access for all human users, and (4) continued support for service accounts that require IAM access keys for legacy integrations. Which combination of actions achieves ALL requirements? (Choose THREE from FIVE)

A) Deploy an SCP on the Production OU that denies iam:CreateUser, iam:CreateLoginProfile, and iam:CreateAccessKey actions, with a condition exempting a specific automation role ARN used for service account management
B) Use AWS Config rule iam-user-no-policies-check with auto-remediation using SSM Automation to remove IAM user policies and access keys in production accounts
C) Deploy AWS IAM Access Analyzer to identify all external and unused access, and use the findings to drive manual remediation
D) Implement IAM Identity Center (SSO) with permission sets mapped to job functions, use SCIM-based automatic provisioning from the corporate IdP, and configure session duration to maximum 12 hours
E) Create a Lambda function triggered by CloudTrail events for CreateUser and CreateAccessKey API calls in production accounts, which automatically deletes the non-compliant resources and notifies the security team via SNS

**Correct Answer: A, D, E**
**Explanation:** This requires immediate remediation, prevention, and ongoing enforcement: (A) The SCP prevents future IAM user creation in production accounts while the condition exemption allows the automation role to manage legitimate service accounts — this is the prevention control. (D) IAM Identity Center with SCIM provisioning establishes the SSO-only access model with automatic user lifecycle management from the corporate IdP — this is the enforcement mechanism. (E) The Lambda function provides immediate remediation of any non-compliant resources that bypass the SCP (e.g., created by the root user or before SCP deployment) — this is the detection and remediation control. Option B's Config rule removes policies but doesn't prevent IAM user creation and is slower than the real-time Lambda approach. Option C's Access Analyzer identifies issues but relies on manual remediation, which doesn't meet the "immediate" requirement.

---

### Question 2
A company is designing a multi-region active-active architecture for their payment processing system. The system must process 50,000 transactions per second globally with the following constraints: each transaction must be processed exactly once, transactions must be processed in the customer's home region for regulatory compliance, cross-region failover must complete within 30 seconds, and the system must maintain a global view of customer balances. The database layer must support both the regional processing requirement and the global balance view. Which database architecture meets ALL constraints?

A) Amazon Aurora Global Database with write forwarding from all regions to a single primary writer
B) Amazon DynamoDB Global Tables with application-level transaction coordination using Step Functions Distributed Transactions pattern
C) Regional Amazon Aurora PostgreSQL clusters for transaction processing (each region owns its customer set), with DynamoDB Global Tables maintaining a real-time global balance view synchronized via Aurora-to-DynamoDB CDC using DMS, and Route 53 ARC for automated failover within 30 seconds
D) Amazon Aurora Multi-Master in each region with cross-region replication for the global view

**Correct Answer: C**
**Explanation:** This question has four constraints that must ALL be met. Option C addresses each: (1) Exactly-once processing: Aurora PostgreSQL with serializable transactions ensures exactly-once semantics within each region; (2) Regional processing: Each Aurora cluster owns its customer set, keeping processing local; (3) 30-second failover: Route 53 ARC routing controls provide sub-30-second traffic redirection, and DynamoDB Global Tables continue serving the global balance view during failover; (4) Global balance view: DynamoDB Global Tables replicated across regions provide a real-time global view, synchronized from Aurora via DMS CDC. Option A's write forwarding creates a dependency on a single primary (fails if primary region is down). Option B's DynamoDB Global Tables use last-writer-wins which doesn't guarantee exactly-once for financial transactions. Option D's Aurora Multi-Master was deprecated and didn't support cross-region multi-master.

---

### Question 3
A healthcare company runs a HIPAA-compliant application on AWS. During a security audit, the auditor requires evidence that: all data at rest is encrypted with customer-managed keys, all data in transit uses TLS 1.2 or higher, all API calls are logged with tamper-proof storage, encryption key access is logged and keys are rotated annually, and PHI (Protected Health Information) can be identified and monitored across all data stores. The company has 200 AWS accounts. Which architecture provides verifiable compliance evidence for ALL requirements? (Choose THREE from FIVE)

A) AWS KMS with customer-managed keys (CMK) for all encryption, with automatic annual rotation enabled and CloudTrail logging of all KMS API calls (key usage events)
B) AWS Config conformance pack for HIPAA with organization-wide deployment, evaluating encryption-at-rest and in-transit rules across all 200 accounts, with results aggregated in a delegated administrator account
C) Amazon Macie enabled across all accounts for PHI discovery in S3, with custom data identifiers for healthcare-specific PHI patterns, findings reported to Security Hub
D) VPC Traffic Mirroring on all EC2 instances to capture and verify TLS versions in network traffic, stored in S3 for audit review
E) CloudTrail organization trail with S3 Object Lock (Compliance mode) for tamper-proof log storage, CloudTrail Lake for queryable audit evidence, and CloudTrail Insights for anomaly detection

**Correct Answer: A, B, E**
**Explanation:** Three components cover all five requirements: (A) KMS CMKs with auto-rotation satisfies encryption-at-rest with customer-managed keys AND annual key rotation AND key access logging through CloudTrail. (B) Config conformance pack for HIPAA evaluates encryption rules (at rest and in transit) across all 200 accounts, providing verifiable compliance evidence for both encryption requirements. (E) CloudTrail organization trail with S3 Object Lock Compliance mode provides tamper-proof API audit logs, CloudTrail Lake provides queryable evidence for auditors, and Insights detects anomalous API activity. Option C (Macie for PHI) is important for HIPAA but the question asks for "verifiable compliance evidence for ALL requirements" — Macie only covers the PHI identification requirement, and the three selected options already cover 4 of 5 requirements. Between C and D, C is more relevant but wasn't strictly needed since B's Config rules + A's KMS + E's CloudTrail cover the five stated requirements. Option D's traffic mirroring is overkill when TLS enforcement can be verified through ALB/CloudFront policies and Config rules.

---

### Question 4
A company operates an e-commerce platform on AWS. During Black Friday last year, their application experienced cascading failures when a downstream payment service became slow (increasing from 100ms to 30-second response times), causing thread pool exhaustion in the application tier, which led to health check failures and Auto Scaling replacing "unhealthy" instances (which then also became unhealthy due to the same root cause, creating a replacement loop). How should the architect redesign the system to prevent cascading failures?

A) Increase the health check grace period and instance warmup time in the Auto Scaling group
B) Implement a comprehensive resilience architecture: circuit breaker pattern using AWS App Mesh (Envoy proxy) with outlier detection that opens the circuit after 5 consecutive 5xx errors to the payment service, bulkhead pattern with separate thread pools per downstream service to prevent thread pool exhaustion, timeout configuration of 2 seconds for payment service calls (failing fast instead of waiting 30 seconds), async payment processing using SQS — decouple the payment call from the synchronous request path, and ALB health checks configured to check application functionality excluding downstream dependencies
C) Scale the application tier to handle more concurrent connections
D) Implement retry logic with exponential backoff for payment service calls

**Correct Answer: B**
**Explanation:** This question describes a classic cascading failure pattern. Option B addresses every failure mode: (1) Circuit breaker prevents the application from continuously calling the degraded payment service, failing fast instead; (2) Bulkhead pattern (separate thread pools) prevents the slow payment calls from consuming all threads and affecting other operations; (3) 2-second timeout ensures threads are freed quickly (instead of waiting 30 seconds); (4) SQS decoupling means payment processing doesn't block the user-facing request — the order is accepted and payment is processed asynchronously; (5) Health checks excluding downstream dependencies prevent the Auto Scaling replacement loop since the application is healthy even when the payment service isn't. Option A only masks the symptom. Option C doesn't prevent thread pool exhaustion. Option D makes the situation worse by generating more requests to the degraded service.

---

### Question 5
A company needs to migrate a 500TB Oracle Data Warehouse to Amazon Redshift. The warehouse has: 2,000 tables with complex partitioning schemes, 5,000 stored procedures with Oracle-specific SQL (analytical functions, CONNECT BY hierarchical queries, MODEL clause), 500 materialized views with complex refresh schedules, and 200 concurrent users running ad-hoc queries. The maximum acceptable migration downtime is 48 hours. Which migration strategy handles the complexity within the downtime constraint?

A) Use AWS SCT to convert the schema and DMS for data migration, completing the entire migration in the 48-hour window
B) Phase 1 (pre-downtime): Use AWS SCT to assess and convert the 2,000 table schemas, 5,000 stored procedures (identifying manual conversion items), and 500 materialized views to Redshift equivalents. SCT's assessment report categorizes conversion complexity. Phase 2 (pre-downtime): Set up AWS DMS with ongoing replication from Oracle to Redshift for the 500TB data load (started weeks in advance). Phase 3 (48-hour downtime): Stop Oracle writes, wait for DMS CDC to drain (minutes), validate data consistency with row counts and checksums, redirect application connections to Redshift, validate stored procedure outputs with parallel testing results. Pre-work: conduct parallel testing of converted stored procedures for weeks before cutover.
C) Export Oracle data to CSV files, upload to S3, COPY into Redshift during the 48-hour window
D) Use Redshift Federated Query to read from Oracle during a gradual migration

**Correct Answer: B**
**Explanation:** 500TB migration within 48 hours requires extensive pre-work: (1) SCT assessment identifies which of the 5,000 stored procedures auto-convert and which need manual conversion — CONNECT BY hierarchical queries convert to Redshift's recursive CTEs, MODEL clause requires manual rewriting, Oracle analytical functions mostly map to Redshift equivalents; (2) DMS ongoing replication started weeks before cutover handles the 500TB initial load progressively, with CDC keeping the target synchronized; (3) The 48-hour window only needs to: stop writes, drain CDC lag (minutes), validate, and switch connections; (4) Parallel testing validates stored procedure outputs before cutover. Option A can't load 500TB and convert 5,000 stored procedures in 48 hours. Option C's CSV export of 500TB would take far longer than 48 hours. Option D creates a permanent dependency on Oracle.

---

### Question 6
A company runs a SaaS application serving 10,000 tenants. Their current architecture uses a single Amazon Aurora MySQL cluster (db.r5.8xlarge) that is reaching its limits: 8TB database, 100,000 queries per second, 64 vCPUs at 90% utilization. They need to scale the database to support 100,000 tenants. The application has 4 distinct query patterns: tenant-specific OLTP queries (90%), cross-tenant analytics (5%), full-text search (3%), and time-series metrics (2%). Which database architecture supports 10x tenant growth?

A) Upgrade to the largest Aurora instance (db.r5.24xlarge)
B) Implement a purpose-built database strategy: shard the OLTP workload across multiple Aurora clusters using tenant-ID-based sharding (consistent hashing) with a routing layer, deploy Amazon Redshift for cross-tenant analytics fed by Aurora CDC via DMS, deploy Amazon OpenSearch for full-text search synchronized via Aurora-to-OpenSearch pipeline, deploy Amazon Timestream for time-series metrics ingested via Kinesis, and implement a unified API layer that routes queries to the appropriate database based on query type
C) Migrate to Amazon DynamoDB for all query patterns
D) Add 10 Aurora read replicas for read scaling

**Correct Answer: B**
**Explanation:** At 100K tenants and 10x growth, no single database can handle all patterns. Option B implements the "purpose-built database" pattern: (1) Aurora sharding distributes the 90% OLTP load across multiple clusters — consistent hashing ensures even distribution and enables adding shards for growth; (2) Redshift handles cross-tenant analytics that require joining data across all tenants — DMS CDC keeps Redshift synchronized; (3) OpenSearch provides full-text search capabilities that Aurora's LIKE queries can't efficiently support at scale; (4) Timestream is optimized for time-series ingestion and querying at the metrics scale; (5) The unified API layer abstracts the complexity from the application. Option A's vertical scaling hits physical limits (db.r5.24xlarge max). Option C can't efficiently handle cross-tenant analytics or full-text search. Option D only scales reads, not writes, and doesn't address the CPU bottleneck.

---

### Question 7
A company is implementing a zero-trust network architecture on AWS. The requirements are: no implicit trust based on network location, every request must be authenticated and authorized, all network traffic must be encrypted, micro-segmentation at the workload level, and continuous verification of device and user posture. The company runs microservices on EKS across 3 VPCs. Which architecture implements zero-trust principles?

A) VPC security groups and NACLs for network segmentation, IAM for authentication
B) AWS Verified Access for user-to-application access with identity and device posture verification, Istio service mesh on EKS with mTLS for service-to-service authentication and encryption, Kubernetes Network Policies with Calico for micro-segmentation at the pod level, AWS PrivateLink for all cross-VPC communication (eliminating VPC peering and public internet exposure), and continuous posture evaluation through AWS SSM agent reporting device compliance to Verified Access trust providers
C) AWS Transit Gateway with route table segmentation, VPN for encryption
D) AWS Network Firewall for all traffic inspection and filtering

**Correct Answer: B**
**Explanation:** Option B implements all five zero-trust principles: (1) No implicit network trust: PrivateLink replaces VPC peering, eliminating broad network connectivity; (2) Every request authenticated/authorized: Verified Access validates identity and device posture for user access; Istio mTLS authenticates every service-to-service call; (3) All traffic encrypted: mTLS encrypts all service mesh traffic; PrivateLink traffic traverses the AWS backbone; (4) Micro-segmentation: Kubernetes Network Policies with Calico provide pod-level traffic control, far more granular than VPC-level; (5) Continuous verification: SSM agent reports device posture continuously to Verified Access trust providers. Option A relies on network location (VPC/subnet) which violates zero-trust principles. Option C provides network segmentation but not authentication of every request. Option D inspects traffic but doesn't implement identity-based access.

---

### Question 8
A media company needs to build a live event streaming platform that handles: 50 concurrent live streams, each at 4K resolution (25 Mbps bitrate), adaptive bitrate transcoding to 6 quality levels, 10 million concurrent viewers globally, sub-5-second glass-to-glass latency, DVR functionality (viewers can rewind up to 2 hours), and content protection with DRM (Widevine, FairPlay, PlayReady). Which end-to-end architecture delivers all capabilities?

A) EC2 instances with FFmpeg for transcoding, S3 for storage, CloudFront for delivery
B) AWS Elemental MediaLive with redundant pipelines for live transcoding of 50 streams to 6 ABR ladders, AWS Elemental MediaPackage v2 with CMAF low-latency HLS packaging and DRM encryption (Widevine/FairPlay/PlayReady via SPEKE integration), MediaPackage time-shifted viewing for 2-hour DVR, Amazon CloudFront for global delivery with origin request policies optimized for live content, and AWS Elemental MediaConnect for reliable contribution/ingest from venue encoders with SRT protocol
C) Amazon IVS (Interactive Video Service) for all live streaming needs
D) AWS Elemental MediaLive with S3 for segment storage, CloudFront for delivery

**Correct Answer: B**
**Explanation:** This requires a full-featured live streaming pipeline. Option B addresses every requirement: (1) MediaConnect provides reliable ingest from venue encoders using SRT (Secure Reliable Transport) protocol; (2) MediaLive with redundant pipelines transcodes 50 × 4K streams to 6 ABR ladders with fault tolerance; (3) MediaPackage v2 with CMAF low-latency HLS achieves sub-5-second latency; (4) SPEKE (Secure Packager and Encoder Key Exchange) integration enables multi-DRM (Widevine for Android/Chrome, FairPlay for Apple, PlayReady for Windows); (5) MediaPackage time-shifted viewing provides the 2-hour DVR window; (6) CloudFront delivers to 10M concurrent viewers globally. Option A lacks DRM, DVR, and production-grade reliability. Option C's IVS has limits on concurrent streams and doesn't support multi-DRM or 4K at this scale. Option D lacks DRM, DVR, and low-latency packaging.

---

### Question 9
A solutions architect discovers that an AWS account has reached the default limit of 5 VPCs per region. The team needs to deploy a new application requiring its own VPC. The request for a limit increase has been submitted but will take 48 hours. The application deployment is urgent (needed within 4 hours). The new application requires network isolation from existing workloads. Which approach provides network isolation without creating a new VPC?

A) Wait for the limit increase
B) Deploy the application in an existing VPC using a dedicated subnet with strict security groups and NACLs that deny all traffic from other subnets, use AWS Systems Manager Session Manager for management access (no bastion needed), and use VPC endpoints for AWS service access to avoid routing through shared NAT gateways
C) Deploy in a different region that has VPC capacity
D) Use AWS Outposts for the new application

**Correct Answer: B**
**Explanation:** When a new VPC isn't available, Option B provides effective network isolation within an existing VPC: (1) Dedicated subnets with NACLs denying all traffic from other subnets in the VPC provide Layer 3/4 isolation; (2) Security groups restrict access to only authorized resources; (3) Session Manager eliminates the need for SSH/RDP ingress rules; (4) Dedicated VPC endpoints prevent traffic from traversing shared NAT gateways. This is not equivalent to full VPC isolation but provides sufficient isolation for most workloads within the urgent timeframe. Option A misses the 4-hour deadline. Option C adds cross-region complexity and latency. Option D requires physical hardware installation.

---

### Question 10
A company runs a data lake on S3 with 2PB of data. They've discovered that their data lake has become a "data swamp" — data quality is poor, metadata is incomplete, there's no data lineage tracking, and no access governance. They need to implement a data governance framework. Which approach provides comprehensive data lake governance?

A) Implement AWS Glue Data Catalog for all metadata management
B) Deploy AWS Lake Formation as the governance layer: centralized permission management using Lake Formation permissions (replacing complex IAM/S3 bucket policies), data catalog with automatic schema detection using Glue Crawlers, data quality rules using AWS Glue Data Quality with automated quality scoring, column-level security and row-level filtering for fine-grained access control, Lake Formation Tag-Based Access Control (LF-TBAC) for scalable permission management, and AWS CloudTrail Lake for data access audit logging. Additionally deploy Amazon DataZone for data product discovery and self-service data access requests.
C) Create detailed README files for each S3 prefix
D) Use Amazon Athena to query and validate data quality manually

**Correct Answer: B**
**Explanation:** Option B transforms the data swamp into a governed data lake: (1) Lake Formation centralizes access control, replacing the complex web of IAM policies, S3 bucket policies, and KMS key policies; (2) Glue Crawlers automatically maintain schema metadata as data evolves; (3) Glue Data Quality runs automated quality checks (completeness, uniqueness, freshness) and scores datasets; (4) Column-level security and row-filtering implement least-privilege data access; (5) LF-TBAC assigns permissions through tags (e.g., tag:PII=true, department=finance) that scale across thousands of tables; (6) CloudTrail Lake provides queryable audit trails of who accessed what data; (7) DataZone enables data producers to publish curated data products and consumers to discover and request access through a governed marketplace. Option A provides metadata but not governance. Options C and D are manual approaches that don't scale.

---

### Question 11
A company's solutions architect is designing an architecture for a real-time fraud detection system. The system must analyze credit card transactions in real-time, correlating each transaction against: the customer's 90-day transaction history, merchant reputation data, geographic anomaly patterns, and device fingerprint data. Decision latency must be under 100ms. Transaction volume is 10,000 per second. The ML model is 500MB and requires real-time feature engineering from the 4 data sources. Which architecture achieves the latency requirement?

A) API Gateway → Lambda → SageMaker Real-time Inference with feature store lookup
B) Network Load Balancer → ECS tasks with the ML model loaded in memory, connected to: ElastiCache Redis (transaction history pre-computed as features, merchant reputation cached, geographic patterns pre-computed), with a custom feature engineering pipeline that assembles all features from Redis in a single MGET command (sub-millisecond), runs inference using the in-memory model (10-20ms), and returns the decision. Kinesis Data Streams for transaction event capture and asynchronous model retraining data collection.
C) Amazon Fraud Detector for all fraud detection
D) Kinesis Data Streams → Kinesis Data Analytics (Flink) for fraud detection → SNS for alerting

**Correct Answer: B**
**Explanation:** For sub-100ms fraud detection at 10K TPS, every millisecond counts: (1) NLB provides the lowest-latency entry point (~1ms overhead vs. API Gateway's ~30ms); (2) ECS tasks with the 500MB model loaded in memory eliminate model loading latency; (3) ElastiCache Redis with pre-computed features enables single-command feature retrieval (MGET for multiple keys in one call = sub-1ms); (4) Pre-computed features mean the 90-day history, merchant reputation, geographic patterns, and device data are already transformed into ML features by background processes; (5) In-memory inference takes 10-20ms. Total: NLB(1ms) + Redis(1ms) + Inference(15ms) + response(1ms) ≈ 18ms — well within 100ms. Option A adds API Gateway (~30ms) and SageMaker endpoint call (~50ms) overhead. Option C's Fraud Detector has higher latency for custom models. Option D's streaming approach doesn't meet synchronous response requirements.

---

### Question 12
A company operates a Kubernetes platform on Amazon EKS serving 500 microservices. They need to implement a platform engineering solution that provides development teams with self-service capabilities while maintaining security and compliance guardrails. Requirements include: automated namespace provisioning per team, resource quota enforcement, network policy enforcement, secret management, CI/CD pipeline templates, and cost allocation per team. Which platform engineering architecture provides these capabilities?

A) Custom scripts that provision namespaces and apply YAML manifests
B) Implement a platform engineering layer using: Crossplane on EKS for self-service infrastructure provisioning (teams request resources through Kubernetes CRDs), Open Policy Agent (OPA) Gatekeeper for policy enforcement (resource quotas, allowed container registries, required labels, network policies), External Secrets Operator integrated with AWS Secrets Manager for secret management, Backstage developer portal for service catalog and CI/CD template provisioning, Karpenter for efficient node provisioning and cost optimization, and Kubecost with AWS Split Cost Allocation for per-team cost reporting
C) Give each team their own EKS cluster for isolation
D) AWS Service Catalog for all provisioning

**Correct Answer: B**
**Explanation:** Option B implements a modern platform engineering solution: (1) Crossplane enables teams to self-service provision AWS resources (databases, caches) through Kubernetes-native APIs — teams create a CR (Custom Resource) and Crossplane provisions the infrastructure; (2) OPA Gatekeeper enforces policies at admission time — preventing pods without resource limits, from unapproved registries, or without required cost allocation labels; (3) External Secrets Operator synchronizes secrets from Secrets Manager to Kubernetes secrets automatically; (4) Backstage provides a developer portal with service templates and documentation; (5) Karpenter right-sizes nodes automatically for cost optimization; (6) Kubecost with AWS Split Cost Allocation provides per-team cost visibility. Option A doesn't scale and lacks policy enforcement. Option C wastes resources with 500 separate clusters. Option D doesn't integrate with Kubernetes-native workflows.

---

### Question 13
A company has a critical application running on EC2 with a Multi-AZ RDS MySQL database. During a recent AZ failure, the application experienced 15 minutes of downtime despite Multi-AZ RDS. Investigation revealed: the application was hard-coded to the primary database endpoint (not the RDS DNS endpoint), connection pools didn't refresh after failover, and the application didn't handle the brief connection interruption gracefully. How should the architect redesign for true automatic failover?

A) Use the RDS DNS endpoint instead of the IP address
B) Implement a comprehensive failover-resistant architecture: use the RDS DNS endpoint with a short TTL (application must honor DNS TTL), configure connection pooling with health checks (test connections before use) and connection age limits (rotate connections every 5 minutes), implement retry logic with exponential backoff for database operations that fail during failover (catching SQLException for connection errors), use RDS Proxy which maintains persistent connections and handles failover transparently (reducing failover time to sub-second for the application), and conduct regular failover testing using RDS's reboot-with-failover feature
C) Switch to Aurora which has faster failover
D) Implement application-level database failover with custom DNS management

**Correct Answer: B**
**Explanation:** Option B addresses all three root causes from the post-mortem: (1) RDS DNS endpoint: resolves to the current primary, automatically updating after failover; (2) Connection pooling with health checks: validates connections before use, discovering stale connections from the old primary; connection age limits prevent long-lived connections that don't pick up DNS changes; (3) Retry logic: handles the brief interruption (typically 60-120 seconds for RDS MySQL) by retrying failed operations; (4) RDS Proxy: the ultimate solution — maintains a persistent connection pool to the database, handles failover transparently, and reduces application-visible failover time to near-zero; (5) Regular testing validates the entire failover path. Option A only fixes one of three issues. Option C has faster failover but doesn't fix the application-layer problems. Option D adds unnecessary complexity.

---

### Question 14
A company is running a legacy application on a t3.xlarge EC2 instance that has been in production for 3 years. The instance is showing "Instance Status Check: 1/2 passed" (system status check failure). The application stores critical data on instance store volumes (ephemeral storage). The data has NOT been backed up. What is the MOST appropriate immediate action?

A) Stop and start the instance to move it to new hardware
B) Do NOT stop the instance (instance store data would be lost). Instead: immediately create an AMI of the running instance to capture the EBS-backed root volume, attempt to access the instance via SSH/RDP and copy data from instance store volumes to EBS or S3, if SSH fails use EC2 Serial Console for troubleshooting, and if data recovery from instance store is critical, contact AWS Support for assistance (instance store data is lost on stop/terminate but may persist on hardware failure if the underlying hardware is still partially functional)
C) Terminate the instance and launch a replacement
D) Reboot the instance to resolve the system status check failure

**Correct Answer: B**
**Explanation:** This is a critical data recovery scenario. System status check failures indicate underlying hardware problems. The key constraint is instance store data: (1) Instance store volumes are ephemeral — data is lost when the instance is stopped, terminated, or the underlying hardware fails; (2) Stopping the instance to move to new hardware WILL lose all instance store data; (3) Creating an AMI captures the EBS root volume but NOT instance store data; (4) The immediate priority is accessing the running instance to copy data from instance store to durable storage (EBS or S3); (5) EC2 Serial Console provides out-of-band access even when network-based access fails; (6) AWS Support may be able to assist with the underlying hardware issue. Option A stops the instance, losing instance store data. Option C terminates the instance, also losing data. Option D may not resolve a hardware issue and could worsen it.

---

### Question 15
A company needs to implement a data residency architecture where: US customer data must stay in us-east-1 and us-west-2 only, EU customer data must stay in eu-west-1 and eu-central-1 only, and the application must be globally accessible with users routed to their data's region. A customer's data residency is determined by their billing address country. The application uses microservices on EKS. How should the architect ensure data never leaves its designated regions, even accidentally?

A) Application-level routing based on customer country with database replication restricted to designated regions
B) Implement a multi-layered data residency enforcement: SCPs on US accounts restricting data services (S3, RDS, DynamoDB) to us-east-1 and us-west-2 only, SCPs on EU accounts restricting to eu-west-1 and eu-central-1 only, Route 53 geolocation routing directing users to their region based on source IP, with application-level verification of customer billing address against the serving region, AWS Config rules detecting any S3 Cross-Region Replication or DynamoDB Global Tables configured to non-allowed regions (auto-remediation via Lambda), VPC endpoint policies restricting S3 access to only buckets in allowed regions, and Amazon Macie scanning for PII in non-designated regions with automated alerts
C) Use CloudFront with geo-restriction to block access from wrong regions
D) Implement database-level encryption with region-specific KMS keys

**Correct Answer: B**
**Explanation:** Comprehensive data residency requires multiple enforcement layers: (1) SCPs prevent any data service operations in non-designated regions at the AWS API level — the strongest preventive control; (2) Route 53 geolocation routing directs users to the correct regional infrastructure; (3) Application-level verification checks that the customer's billing address matches the serving region (a US customer accidentally accessing the EU endpoint is redirected); (4) Config rules detect any cross-region replication configurations that would move data to non-compliant regions; (5) VPC endpoint policies add another layer by restricting which S3 buckets can be accessed; (6) Macie scans detect any PII that accidentally ends up in wrong regions. This defense-in-depth approach prevents data residency violations at infrastructure, application, and data layers. Option A relies solely on application logic which can be buggy. Option C blocks access but doesn't prevent backend data movement. Option D encrypts data but doesn't prevent it from leaving a region.

---

### Question 16
A company's AWS environment generates 50,000 CloudWatch alarms across 200 accounts. The operations team is overwhelmed with alarm fatigue — 80% of alarms are either false positives or low-priority. Mean time to acknowledge critical alarms is 45 minutes due to the noise. How should the architect redesign the alerting architecture?

A) Reduce the number of alarms by deleting low-priority ones
B) Implement an intelligent alerting pipeline: consolidate alarms using CloudWatch Composite Alarms that combine multiple related metrics into a single alarm (e.g., "service degraded" = high latency AND high error rate AND low throughput), use CloudWatch Anomaly Detection instead of static thresholds (reduces false positives by adapting to normal patterns), route alarms through Amazon EventBridge to a tiered incident management system — P1 (service down) → PagerDuty/on-call via SNS, P2 (degraded) → Slack channel via chatbot, P3 (informational) → dashboard only, implement AWS Systems Manager Incident Manager for automated incident creation and runbook execution, and use CloudWatch Contributor Insights to identify top contributors to issues (reducing investigation time)
C) Increase alarm thresholds to reduce false positives
D) Assign more team members to monitor alarms

**Correct Answer: B**
**Explanation:** Option B addresses alarm fatigue systematically: (1) Composite Alarms reduce 50,000 alarms to hundreds of meaningful, composite alarms (e.g., 10 individual metric alarms → 1 composite "service health" alarm); (2) Anomaly Detection adapts to normal patterns (daily/weekly cycles) instead of static thresholds, eliminating 60-80% of false positives; (3) Tiered routing ensures critical alarms get immediate attention while low-priority alarms don't interrupt; (4) Incident Manager automates the initial incident response (creates an incident, starts a runbook, pages on-call); (5) Contributor Insights shows the top resources contributing to an issue, reducing investigation from 45 minutes to 5 minutes. Option A loses visibility. Option C may miss real issues. Option D doesn't scale.

---

### Question 17
A company is migrating a legacy Oracle database (20TB) that uses Oracle Advanced Queuing (AQ) extensively for inter-application messaging. 50 applications produce and consume messages through 200 AQ queues. The database also uses Oracle Spatial for geographic data processing and Oracle Advanced Compression. The company wants to migrate to a fully managed AWS solution. Which combination handles ALL Oracle-specific features?

A) Migrate to RDS for Oracle to maintain all features
B) Decompose the Oracle database: migrate the relational data to Amazon Aurora PostgreSQL (using SCT for schema conversion and DMS for data migration), replace Oracle AQ with Amazon SQS/SNS for messaging (SQS for point-to-point queues, SNS for pub/sub topics), replace Oracle Spatial with Amazon Location Service for geocoding and routing, plus PostGIS extension on Aurora PostgreSQL for spatial queries and data storage, and use Aurora's native compression for storage optimization
C) Migrate everything to DynamoDB
D) Use Amazon MSK to replace Oracle AQ and Aurora for the database

**Correct Answer: B**
**Explanation:** Option B maps each Oracle feature to an AWS equivalent: (1) Oracle relational data → Aurora PostgreSQL with SCT/DMS for conversion and migration; (2) Oracle AQ (200 queues) → SQS/SNS: AQ point-to-point queues map to SQS queues, AQ pub/sub topics map to SNS topics. Applications need messaging library changes but not business logic changes; (3) Oracle Spatial → PostGIS on Aurora PostgreSQL provides equivalent spatial functions (ST_Distance, ST_Contains, etc.) and Amazon Location Service provides geocoding/routing services; (4) Oracle Advanced Compression → Aurora's storage layer provides automatic compression. Option A maintains Oracle licensing costs. Option C can't handle spatial queries or relational data well. Option D's MSK is overkill for simple message queuing.

---

### Question 18
A company has a Lambda function that processes orders from an SQS queue. The function's concurrency is set to 100. During a flash sale, the queue depth grows to 1 million messages. The current processing rate is 100 messages/second (100 concurrent Lambda invocations × 1 second per message). At this rate, it would take ~2.8 hours to drain the queue. The business requires all orders to be processed within 30 minutes. What changes achieve the 30-minute SLA without modifying the Lambda function code?

A) Increase Lambda reserved concurrency to 10,000
B) Increase Lambda reserved concurrency to 600 (processing 600 messages/second = 1M in ~28 minutes), increase the SQS batch size from 1 to 10 (each Lambda invocation processes 10 messages, increasing effective throughput to 6,000 messages/second), configure the SQS event source mapping with maxBatchingWindow of 5 seconds and maximumConcurrency of 600, ensure the Lambda function's IAM role has appropriate permissions, and verify the downstream systems (database, payment processor) can handle the 10x throughput increase
C) Add more SQS queues and Lambda functions
D) Use Step Functions Distributed Map instead of SQS + Lambda

**Correct Answer: B**
**Explanation:** The question says "without modifying the Lambda function code," so the function must already handle batch processing (or process individual messages within a batch event). Key calculations: Target: 1M messages in 30 minutes = 556 messages/second minimum. With batch size 10 and 600 concurrency: 600 invocations × 10 messages = 6,000 messages/second. Even if processing time increases slightly with batches, this provides massive headroom. SQS event source mapping's maximumConcurrency (introduced in 2022) controls exactly how many concurrent Lambda invocations handle the queue. Important caveat: the function's downstream systems must handle the throughput increase. Option A's 10,000 concurrency with batch size 1 processes 10,000/sec but may overwhelm downstream systems. Option C adds unnecessary complexity. Option D requires code changes.

---

### Question 19
A company uses AWS CloudFormation to manage infrastructure across 200 accounts. A recent audit discovered that 30% of CloudFormation stacks have drifted from their templates. Some drift is authorized (manual emergency changes) while some is unauthorized. The company needs to: detect drift across all accounts, distinguish authorized from unauthorized drift, automatically remediate unauthorized drift, and maintain an audit trail of all drift events. Which approach provides comprehensive drift management?

A) Run CloudFormation drift detection on each stack periodically
B) Implement organization-wide drift management: AWS Config rule cloudformation-stack-drift-detection-check deployed via Organizations across all 200 accounts, Config aggregator collecting drift findings centrally, a DynamoDB table of authorized exceptions (stack ID, resource, authorized drift description, approver, expiration), Lambda function triggered by Config non-compliance that: checks the exceptions table — if the drift matches an authorized exception, marks it as compliant; if not, creates an SNS notification to the stack owner with a 24-hour remediation window; after 24 hours, automatically triggers CloudFormation stack update (UpdateStack with the current template) to remediate unauthorized drift, and CloudTrail + Config recording all drift events for audit
C) Use AWS Systems Manager to detect and fix drift
D) Manually review CloudFormation stacks quarterly

**Correct Answer: B**
**Explanation:** Option B provides automated, organization-wide drift management: (1) Config rule detects drift across all 200 accounts automatically; (2) Config aggregator provides centralized visibility; (3) The authorized exceptions table distinguishes legitimate emergency changes from unauthorized drift; (4) Automated remediation (CloudFormation UpdateStack) reverts unauthorized drift to the desired state; (5) The 24-hour grace period allows stack owners to either create an authorized exception or fix the drift themselves; (6) CloudTrail and Config provide the complete audit trail. Option A only detects but doesn't distinguish or remediate. Option C doesn't integrate with CloudFormation drift detection. Option D is too infrequent for 200 accounts.

---

### Question 20
A company needs to design an architecture for a real-time collaborative document editing system (similar to Google Docs). Requirements: 50,000 concurrent documents being edited, each document can have up to 20 simultaneous editors, changes must be visible to all editors within 200ms, the system must handle conflict resolution when multiple users edit the same section simultaneously, and document history must support undo/redo and version comparison. Which architecture provides real-time collaboration?

A) API Gateway WebSocket API → Lambda → DynamoDB for document storage, with polling for updates
B) AWS AppSync with real-time subscriptions for change notifications, backed by DynamoDB for document state, with Operational Transformation (OT) or Conflict-free Replicated Data Type (CRDT) logic implemented in Lambda resolvers for conflict resolution, DynamoDB Streams capturing all changes for version history, CloudFront for static asset delivery, and Amazon ElastiCache Redis for presence awareness (tracking which users are editing which sections)
C) Amazon Chime SDK for real-time communication between editors
D) S3 with versioning for document storage, periodic sync via API calls

**Correct Answer: B**
**Explanation:** Real-time collaborative editing requires specific capabilities: (1) AppSync real-time subscriptions push changes to all editors within milliseconds, meeting the 200ms requirement; (2) CRDT (or OT) logic in Lambda resolvers handles conflict resolution when multiple users edit simultaneously — CRDTs are mathematically guaranteed to converge to the same state regardless of operation order; (3) DynamoDB provides the low-latency document storage needed for 50K concurrent documents × 20 editors; (4) DynamoDB Streams captures every change for version history, enabling undo/redo and version comparison; (5) Redis tracks editor presence (cursor positions, active sections) for the collaborative UI. Option A's polling doesn't meet the 200ms requirement. Option C is for audio/video, not document editing. Option D's periodic sync has too much latency for real-time editing.

---

### Question 21
A company runs a critical application on EC2 instances behind an ALB. The application team reports intermittent 504 Gateway Timeout errors affecting 2% of requests. The ALB access logs show these requests timing out after 60 seconds (the ALB's idle timeout). The target EC2 instances show normal CPU and memory. The application makes calls to a downstream microservice. How should the architect systematically diagnose the root cause?

A) Increase the ALB idle timeout to 120 seconds
B) Implement a systematic diagnostic approach: enable ALB access logs and analyze the TargetProcessingTime field (time the target took to respond) — if high, the issue is in the application; check if the 504s correlate with specific backend targets (one unhealthy instance), use AWS X-Ray tracing to identify which downstream service call is causing the delay, check the downstream microservice's latency metrics and error rates, verify the application's connection pool to the downstream service isn't exhausted, check for DNS resolution issues (if the downstream service endpoint uses DNS with long TTL and the service has been redeployed), and implement ALB request tracing headers (X-Amzn-Trace-Id) to correlate the failed requests end-to-end
C) Replace the ALB with a Network Load Balancer
D) Scale up the EC2 instances

**Correct Answer: B**
**Explanation:** 504 errors at 2% with normal EC2 metrics strongly suggest a downstream dependency issue. Option B provides systematic diagnosis: (1) ALB access logs with TargetProcessingTime pinpoints whether the delay is in the target or the ALB; (2) Correlating with specific targets identifies if one instance is problematic (maybe its connection pool to the downstream service is exhausted); (3) X-Ray traces the full request path including the downstream service call, revealing where the 60+ second delay occurs; (4) Downstream service metrics confirm if that service is slow; (5) Connection pool exhaustion is a common cause of intermittent timeouts — when the pool is full, requests queue indefinitely; (6) DNS issues can cause intermittent failures if the downstream service's IP changed but the application cached the old IP. Option A masks the symptom. Option C doesn't fix application-layer issues. Option D won't help if the issue is downstream.

---

### Question 22
A company has a DynamoDB table that stores IoT sensor readings. The table has a partition key of sensor_id and sort key of timestamp. The table receives 100,000 writes per second from 10,000 sensors. They've noticed that some sensors write 100 times more frequently than others, creating hot partitions. The table uses on-demand capacity. Despite on-demand mode, they're experiencing ProvisionedThroughputExceededException errors. Why are they seeing throttling on an on-demand table, and how should they fix it?

A) On-demand tables don't have throughput limits
B) On-demand tables DO have per-partition limits (~3,000 WCU per partition, ~1,000 WCU per partition per second for a single partition key value). Hot sensors writing at rates exceeding the per-partition limit cause throttling. Fix: implement write sharding for hot sensors by appending a random suffix (0-N) to the sensor_id, distributing writes across multiple partitions. Use a scatter-gather read pattern when reading a hot sensor's data. Additionally, implement a buffering layer using Amazon Kinesis Data Streams or SQS to smooth write bursts before they hit DynamoDB.
C) Switch to provisioned capacity mode with higher capacity
D) Enable DynamoDB Auto Scaling

**Correct Answer: B**
**Explanation:** This tests knowledge of DynamoDB's per-partition throughput limit — a common misconception is that on-demand mode eliminates all throttling. The truth: (1) On-demand auto-scales total table capacity, but each individual partition has a limit of ~3,000 WCU and ~3,000 RCU; (2) If a single partition key (sensor_id) receives writes exceeding this limit, throttling occurs regardless of the table's overall capacity; (3) Write sharding distributes a hot sensor's writes across multiple DynamoDB partitions (sensor_123#0, sensor_123#1, etc.); (4) Kinesis buffering smooths burst writes, enabling batch writes to DynamoDB at a controlled rate. Option A is incorrect — on-demand tables have per-partition limits. Option C doesn't solve per-partition limits. Option D doesn't apply to on-demand tables.

---

### Question 23
A company is implementing a disaster recovery strategy for their AWS-hosted SAP S/4HANA system. The production SAP landscape includes: SAP HANA database (6TB), SAP Application Server (ASCS, PAS, AAS), SAP Web Dispatcher, SAP Fiori, and SAP PI/PO for integrations. RPO must be 15 minutes and RTO must be 2 hours. The DR region is 500 miles away. Budget is limited. Which DR architecture meets the requirements for SAP while minimizing cost?

A) Full active-active SAP deployment in both regions
B) SAP HANA System Replication in async mode (LOGREPLAY) to the DR region for the 15-minute RPO, SAP application server AMIs created daily and stored in the DR region using EC2 Image Builder, AWS CloudFormation templates for DR application server provisioning, Launch Wizard for SAP pre-configured DR deployment automation, S3 Cross-Region Replication for SAP transport directory and shared files, and DNS-based failover using Route 53 with health checks on the SAP Web Dispatcher
C) AWS Elastic Disaster Recovery for all SAP components
D) Daily EBS snapshots copied cross-region with CloudFormation-based recovery

**Correct Answer: B**
**Explanation:** For SAP-specific DR within budget constraints: (1) HANA System Replication in async mode (LOGREPLAY) provides continuous replication with ~15 minutes RPO — it's SAP's certified DR mechanism; (2) Application server AMIs (created daily) can be launched in DR region within the 2-hour RTO — SAP app servers are largely stateless; (3) CloudFormation templates pre-configure the DR environment parameters; (4) Launch Wizard ensures SAP-certified configurations are maintained; (5) S3 CRR handles the SAP transport directory and configuration files; (6) Route 53 failover manages the DNS cutover. During normal operations, the cost is minimal: one small HANA instance for replication target + S3 storage. Option A doubles the infrastructure cost. Option C's DRS doesn't understand SAP-specific consistency requirements (HANA SR is required for consistent HANA backup). Option D's daily snapshots can't meet the 15-minute RPO.

---

### Question 24
A company operates a multi-tenant SaaS platform with 5,000 tenants on a shared Amazon Aurora MySQL database. A few large tenants ("noisy neighbors") periodically run heavy queries that degrade performance for all tenants. The company cannot afford separate databases per tenant. How should the architect prevent noisy neighbor issues while maintaining the shared database?

A) Implement query timeouts to kill long-running queries
B) Implement a multi-layered noisy neighbor mitigation strategy: Aurora query execution plan management using Performance Insights to identify expensive queries, implement query governor at the application level (ProxySQL or custom middleware) that: limits per-tenant query concurrency (max 10 concurrent queries per tenant), enforces per-tenant query time limits (30-second max), routes large analytical queries from heavy tenants to Aurora read replicas (query routing based on tenant tier), and implements a tenant priority queue for resource allocation. Additionally, use Amazon Aurora's wait event analysis to identify specific resource contention patterns.
C) Upgrade to the largest Aurora instance type
D) Implement connection pooling per tenant

**Correct Answer: B**
**Explanation:** Noisy neighbor in shared databases requires multi-level mitigation: (1) ProxySQL (or custom middleware) provides the query governance layer — intercepting queries before they reach Aurora; (2) Per-tenant concurrency limits prevent a single tenant from monopolizing database connections; (3) Query time limits kill runaway queries before they impact others; (4) Read replica routing for heavy tenants offloads analytical workloads from the writer; (5) Tenant priority queue ensures small tenants' simple queries aren't blocked behind large tenants' complex queries; (6) Performance Insights and wait event analysis provide the data needed to tune the governance rules. Option A's simple timeouts kill queries but don't prevent the resource consumption that degrades others. Option C doesn't prevent noisy neighbors (they'll consume the larger instance too). Option D doesn't control query resource consumption.

---

### Question 25
A company wants to implement end-to-end encryption for their application where ONLY the application (not AWS) can decrypt the data. Even if AWS were compelled by a court order, they should not be able to access the plaintext data. The application processes sensitive legal documents. Which encryption architecture provides this guarantee?

A) AWS KMS with customer-managed keys
B) Client-side encryption using keys managed entirely outside AWS: generate and store encryption keys in an on-premises HSM (never uploaded to AWS), implement AWS Encryption SDK in the application with a custom keyring that connects to the on-premises HSM for key operations, encrypt data before it enters any AWS service (S3, DynamoDB, SQS), application decrypts after retrieval, and key metadata/encrypted data keys stored alongside ciphertext (but master key never leaves on-premises HSM)
C) AWS CloudHSM for key management
D) S3 server-side encryption with customer-provided keys (SSE-C)

**Correct Answer: B**
**Explanation:** The requirement is that AWS cannot decrypt the data under ANY circumstances. Option B achieves this: (1) Master encryption keys are generated and stored on-premises in the customer's HSM — AWS never has access; (2) The AWS Encryption SDK generates data encryption keys, encrypts them with the master key (via the on-premises HSM), and stores the encrypted data key with the ciphertext; (3) Encryption/decryption happens client-side — data enters AWS already encrypted; (4) Even with a court order, AWS can only provide encrypted data; without the master key (which AWS doesn't have), the data is unreadable. Option A's KMS keys are accessible to AWS (the key material is in AWS-managed HSMs). Option C's CloudHSM keys are in customer-controlled HSMs on AWS infrastructure, but AWS potentially has physical access. Option D's SSE-C — the customer provides keys for each S3 API call, but the data is decrypted server-side, meaning AWS processes plaintext briefly.

---

### Question 26
A company's application uses an SQS FIFO queue with a message group ID based on customer_id. They're experiencing lower throughput than expected. The queue processes 200 messages per second, but they need 10,000 messages per second. The current bottleneck is the 300 messages per second per message group ID limit. There are 10,000 unique customer_ids. What is limiting throughput, and how should they fix it?

A) FIFO queues have a hard limit of 300 messages per second
B) The throughput is limited because messages are being sent to a small number of message groups. With 10,000 unique customer_ids, the theoretical maximum is 10,000 × 300 = 3,000,000 messages/sec. The 200 msg/sec observed suggests traffic is concentrated on ~1 message group. Fix: verify the message group ID distribution — check if the application is accidentally using a single group ID for all messages. If distribution is correct, enable High Throughput mode for FIFO queues which supports up to 3,000 messages per second per API action per message group ID (30,000 per queue). Also ensure the application uses batch operations (SendMessageBatch, ReceiveMessageBatch) for maximum efficiency.
C) Switch to a Standard SQS queue and implement deduplication at the application level
D) Use multiple FIFO queues with a routing layer

**Correct Answer: B**
**Explanation:** This tests knowledge of SQS FIFO queue limits and High Throughput mode: (1) Default FIFO throughput: 300 messages/sec per message group, 3,000/sec per queue; (2) High Throughput FIFO: 3,000 messages/sec per message group, 30,000/sec per queue; (3) With 10,000 customer_ids and High Throughput mode, theoretical max far exceeds 10,000 msg/sec; (4) The 200 msg/sec observation suggests most traffic uses 1-2 message groups — the application may have a bug sending all messages with the same group ID; (5) Batch operations (up to 10 messages per batch) further optimize throughput. Option A incorrectly states the limit. Option C loses FIFO ordering guarantees. Option D adds unnecessary complexity.

---

### Question 27
A company needs to implement a solution where AWS Lambda functions in VPC can access both the internet AND VPC resources (RDS database) simultaneously. Currently, Lambda in VPC cannot access the internet without a NAT Gateway, but NAT Gateway costs $32/month per AZ plus $0.045/GB. The company has 500 Lambda functions making occasional internet calls. Monthly NAT Gateway cost would be $300+ for the function's minimal internet traffic (5GB/month). What is the MOST cost-effective solution?

A) Add NAT Gateway to the VPC
B) Use a dual-networking approach: Lambda functions deployed in VPC subnets for RDS access, VPC endpoints (Gateway endpoint for S3, Interface endpoints for other AWS services) to eliminate most internet-bound traffic, and for the remaining external internet calls, implement a Lambda function OUTSIDE the VPC that makes the internet calls and invoke it from the VPC-connected Lambda function using asynchronous invocation or Step Functions
C) Deploy all Lambda functions outside the VPC and use RDS Proxy with IAM authentication for database access
D) Use VPC endpoints for everything and eliminate internet access

**Correct Answer: C**
**Explanation:** Option C is the most cost-effective modern approach: (1) Lambda functions deployed outside VPC have internet access by default at no additional cost; (2) RDS Proxy provides a managed endpoint that Lambda can access from outside the VPC using IAM authentication — this was specifically designed to solve the Lambda-VPC connectivity problem; (3) No NAT Gateway needed; (4) No VPC configuration complexity; (5) RDS Proxy also handles connection pooling, which solves the Lambda-RDS connection scaling issue. Cost: RDS Proxy ~$0.015/vCPU/hour ($22/month for db.r5.large) vs. NAT Gateway ($96/month for 3 AZs). Option A is the most expensive. Option B's dual-Lambda approach adds complexity and latency. Option D may not be possible if external API calls are needed.

---

### Question 28
A company operates a data pipeline that processes 10TB of data daily. The pipeline currently uses EMR with a permanent 20-node cluster running 24/7, costing $14,000/month. Analysis shows the pipeline actually processes data for only 6 hours per day. The data scientists want interactive Spark notebooks available during business hours (10 hours/day) for ad-hoc analysis. Which architecture reduces costs while supporting both batch processing and interactive analysis?

A) Keep the permanent EMR cluster and add EMR Notebooks
B) Implement a split architecture: transient EMR cluster (launched by Step Functions, processing 6 hours, then terminated) with Spot instances for batch processing — cost: 20 nodes × $0.08/hr (Spot) × 6 hrs × 30 = $288/month + S3 storage for data lake; EMR Studio with EMR on EKS for interactive notebooks during business hours, auto-scaling from 2-10 nodes based on demand — cost: avg 4 nodes × $0.40/hr × 10 hrs × 22 days = $352/month; Glue Data Catalog as shared Hive metastore; S3 as persistent storage layer
C) Use Amazon Athena for all processing
D) Use SageMaker Studio notebooks instead of EMR for everything

**Correct Answer: B**
**Explanation:** Option B reduces costs by 95%+ while improving capabilities: (1) Transient EMR batch cluster: only runs during the 6-hour processing window, using Spot instances (80% discount). Cost: ~$288/month vs. $14,000 for permanent cluster; (2) EMR Studio with EMR on EKS provides interactive notebooks without a permanent cluster — auto-scales based on actual data scientist usage; (3) S3 as persistent storage decouples storage from compute; (4) Glue Data Catalog ensures both batch and interactive clusters share metadata. Total: ~$640/month vs. $14,000 (95% savings). Option A maintains the permanent cluster cost. Option C can't handle complex Spark processing. Option D doesn't support native Spark/EMR capabilities.

---

### Question 29
A company has a multi-account AWS environment and wants to implement a centralized security monitoring solution. They need to detect: compromised credentials, cryptocurrency mining, unusual API activity, vulnerable software on EC2, sensitive data exposure in S3, and non-compliant configurations. Which combination of services provides COMPREHENSIVE security monitoring across all accounts?

A) Amazon GuardDuty alone covers all detection requirements
B) Deploy as a comprehensive security stack with delegated administrator: Amazon GuardDuty for credential compromise and crypto mining detection (threat intelligence-based), GuardDuty EKS Protection and Lambda Protection for container and serverless threats, Amazon Inspector for vulnerability scanning of EC2 instances and container images, Amazon Macie for sensitive data discovery in S3, AWS Config with conformance packs for configuration compliance, all findings aggregated in AWS Security Hub with automated response using EventBridge rules triggering Lambda-based remediation
C) Third-party SIEM solution for all monitoring
D) CloudTrail with custom Lambda analysis

**Correct Answer: B**
**Explanation:** No single service covers all six detection requirements. Option B provides the complete security stack: (1) GuardDuty: compromised credentials (credential exfiltration findings), cryptocurrency mining (crypto-currency mining findings), unusual API activity (anomalous API behavior findings); (2) GuardDuty EKS/Lambda: extends detection to container and serverless workloads; (3) Inspector: vulnerability scanning for CVEs on EC2 instances and container images; (4) Macie: sensitive data (PII, PHI) exposure in S3; (5) Config conformance packs: non-compliant configurations (encryption, public access, logging); (6) Security Hub: centralized findings aggregation and compliance scoring. Option A's GuardDuty doesn't cover vulnerability scanning (Inspector), data classification (Macie), or configuration compliance (Config). Option C loses AWS-native integration. Option D requires building custom detection logic.

---

### Question 30
A company is running a legacy application that uses Amazon ElastiCache for Redis (cluster mode disabled) with a single primary node (r5.2xlarge, 52.82 GiB). The Redis dataset has grown to 50 GiB. The company needs to: scale the dataset to 500 GiB, maintain sub-millisecond read latency, support 1 million reads per second, and minimize downtime during the scaling operation. Which approach achieves all requirements?

A) Upgrade to a larger instance type (r5.12xlarge with 317 GiB)
B) Migrate from cluster mode disabled to cluster mode enabled: create a new Redis cluster with cluster mode enabled and 10 shards (each shard handles ~50 GiB, total 500 GiB), each shard with 1 primary and 2 replicas (for 1M reads/sec), use the online migration feature (ElastiCache Global Datastore or self-managed replication) to migrate data from the single-node cluster to the new sharded cluster with minimal downtime, update the application to use the Redis cluster client (which supports hash slots for cluster mode)
C) Add read replicas to the existing cluster (max 5 replicas)
D) Use DynamoDB DAX instead of Redis

**Correct Answer: B**
**Explanation:** Scaling from 50 GiB to 500 GiB requires cluster mode enabled (sharding): (1) Cluster mode disabled has a max dataset size limited by the largest instance (317 GiB for r5.12xlarge — Option A), but 500 GiB exceeds this; (2) Cluster mode enabled distributes data across shards — 10 shards at ~50 GiB each = 500 GiB; (3) 10 shards × 3 nodes (1 primary + 2 replicas) = 30 nodes, providing the 1M reads/sec throughput; (4) Sub-millisecond latency is maintained as each shard handles a subset of the keyspace; (5) Online migration minimizes downtime. Important caveat: the application must be updated to use a cluster-aware Redis client. Option A caps at 317 GiB. Option C's replicas don't increase data capacity (same dataset replicated). Option D doesn't provide Redis's data structure capabilities.

---

### Question 31
A company needs their application to handle exactly 10 million WebSocket connections simultaneously. API Gateway WebSocket API has a default limit of 500 connections per second for new connections. The application expects connection storms where 1 million users connect within 5 minutes during a live event start. How should the architect design for this connection scale?

A) Use a single API Gateway WebSocket API (it can handle unlimited connections)
B) Deploy multiple API Gateway WebSocket APIs behind a Global Accelerator, with Route 53 weighted routing distributing connection requests across API Gateway deployments, request a service quota increase for WebSocket connections and new connection rate, implement connection-level rate limiting in CloudFront Functions to smooth connection storms, and use a connection registry in DynamoDB Global Tables for cross-API-Gateway message routing
C) Use Amazon Kinesis Data Streams for the real-time data delivery instead of WebSocket
D) Deploy self-managed WebSocket servers on EC2 using Socket.IO behind an NLB

**Correct Answer: B**
**Explanation:** This tests knowledge of API Gateway WebSocket limits: (1) Default: 500 new connections/second, can be increased via service quota request; (2) Connection limit per API: soft limit that can be increased; (3) For 10M simultaneous connections and 1M in 5 minutes (3,333 connections/sec), multiple API Gateway deployments distribute the load; (4) Global Accelerator provides static endpoints and health-based routing; (5) DynamoDB Global Tables as a connection registry enables any API Gateway to route messages to connections on other API Gateways; (6) CloudFront Functions smooth the connection storm by implementing a gradual connection backoff. Option A ignores the connection rate limit. Option C doesn't provide bidirectional real-time communication. Option D requires managing WebSocket infrastructure.

---

### Question 32
A company runs an application that stores customer data in DynamoDB. A new privacy regulation requires the company to implement the "right to be forgotten" — when a customer requests deletion, ALL their data must be permanently removed within 72 hours. The customer's data exists in: the DynamoDB table (with customer_id as partition key), DynamoDB backup/point-in-time recovery (PITR), S3 data lake (exported from DynamoDB), CloudWatch Logs containing customer_id, and Kinesis Data Firehose delivery streams to S3. How should the architect implement comprehensive data deletion?

A) Delete the DynamoDB item and assume the rest will be cleaned up by retention policies
B) Implement a data deletion orchestration workflow using Step Functions: Step 1: Delete from DynamoDB (DeleteItem by customer_id), Step 2: S3 data lake — run an Athena query to identify all S3 objects containing the customer_id, use S3 Batch Operations to delete those objects, Step 3: CloudWatch Logs — use CloudWatch Logs API to create a data protection policy that masks the customer_id retroactively, or if retention allows, delete the log groups, Step 4: Firehose S3 delivery — same as Step 2 for Firehose-delivered S3 data, Step 5: For DynamoDB PITR — PITR contains historical data including the deleted customer's data. PITR data is automatically purged after the 35-day window. Document this limitation and disable PITR temporarily if 72-hour compliance is required for backup data. Track deletion status in a compliance DynamoDB table for audit purposes.
C) Use DynamoDB TTL to automatically delete the data
D) Encrypt all customer data with a per-customer KMS key, then schedule key deletion to render data unreadable (crypto-shredding)

**Correct Answer: B**
**Explanation:** "Right to be forgotten" requires comprehensive deletion across ALL data stores. Option B addresses each: (1) DynamoDB primary table: direct delete; (2) S3 data lake: identify and delete objects containing the customer's data; (3) CloudWatch Logs: mask or delete customer data from logs; (4) Firehose-delivered S3 data: identify and delete; (5) PITR: this is the tricky part — PITR maintains a 35-day rolling window of all writes, including the deleted customer's data. This data can't be selectively deleted from PITR. The architect must document this limitation. If 72-hour compliance is strict for backup data, PITR may need to be disabled. Option A ignores most data stores. Option C only sets future deletion, doesn't handle existing data across all stores. Option D (crypto-shredding) is elegant but doesn't work for all data stores (CloudWatch Logs, PITR data), and KMS key deletion has a 7-30 day waiting period.

---

### Question 33
A company is migrating from an on-premises Apache Kafka cluster to Amazon MSK. Their Kafka producers use exactly-once semantics with transactional messages. During testing, they notice that exactly-once semantics don't work on MSK. After investigation, they find the issue. What is the MOST likely cause, and how should they fix it?

A) MSK doesn't support exactly-once semantics
B) MSK DOES support exactly-once semantics, but it requires specific broker configuration: enable.idempotence must be true (default), transaction.state.log.replication.factor must be set to 3 (must match or exceed min.insync.replicas), and transaction.state.log.min.isr must be set to 2. The issue is likely that the MSK cluster's custom configuration doesn't include these transaction-related settings. Fix: create a custom MSK configuration with the correct transaction settings, apply it to the cluster (may require rolling restart), and verify producer configuration includes transactional.id and enable.idempotence=true.
C) They need to use Kinesis Data Streams instead of MSK for exactly-once semantics
D) They need to implement exactly-once semantics at the application level since Kafka doesn't support it

**Correct Answer: B**
**Explanation:** This tests deep MSK/Kafka configuration knowledge: (1) MSK supports Kafka's exactly-once semantics (EOS), but the broker-side configuration must be correct; (2) The transaction state log is a special internal Kafka topic that tracks transaction state — its replication factor and ISR must be properly configured; (3) The default MSK configuration may not include the transaction-specific settings; (4) A custom MSK configuration must be created and applied; (5) Producer-side configuration must include transactional.id and enable.idempotence=true. Option A is incorrect — MSK fully supports EOS. Option C is unnecessary. Option D is incorrect — Kafka natively supports EOS.

---

### Question 34
A company wants to implement a blue-green deployment for their Amazon Aurora database schema changes. The schema change adds new columns and modifies stored procedures. They need zero-downtime deployment where the old application version works with the old schema and the new version works with the new schema. Both versions need to coexist during the deployment window. Which approach provides zero-downtime database schema deployment?

A) Apply schema changes directly to the production database during a maintenance window
B) Implement an expand-contract migration pattern: Phase 1 (Expand): Add new columns and new stored procedures to the production database WITHOUT removing or modifying existing ones — the old application version continues working with existing columns/procedures. Phase 2 (Deploy new app): Deploy the new application version that reads/writes to both old and new columns. Phase 3 (Migrate data): Backfill new columns from old columns using a background process. Phase 4 (Contract): After all application instances are on the new version and data migration is complete, remove the old columns and procedures. Use Aurora Blue/Green Deployments for testing the schema changes in a green environment before promoting.
C) Create a new Aurora cluster with the new schema, migrate data, and switch applications
D) Use Aurora Global Database write forwarding for the migration

**Correct Answer: B**
**Explanation:** The expand-contract pattern enables zero-downtime schema changes: (1) Expand phase adds new schema elements without breaking existing ones — critical for the coexistence period; (2) Both application versions work simultaneously: old version uses old columns, new version uses new columns; (3) Data backfill populates new columns from existing data; (4) Contract phase removes old schema elements only after all application instances have been updated. Aurora Blue/Green Deployments can be used to test the schema changes before applying them to production. Option A requires downtime. Option C risks data loss during the switch. Option D is for global database failover, not schema migration.

---

### Question 35
A company has exhausted their Elastic IP address quota (5 per region) and needs more for a new multi-AZ deployment. They also realize they have 3 Elastic IPs allocated but not associated with running instances, incurring charges. What immediate actions should they take?

A) Request a quota increase for more Elastic IPs
B) First: release the 3 unassociated Elastic IPs (each charges ~$3.65/month when not associated with a running instance in a VPC). Second: evaluate if all existing Elastic IPs are necessary — many use cases can use ALB/NLB DNS names, CloudFront distributions, or Global Accelerator static IPs instead of Elastic IPs. Third: if more EIPs are still needed, request a quota increase through Service Quotas. Fourth: implement a tagging strategy and AWS Config rule (eip-attached) to detect future unattached EIPs and alert the team.
C) Use public IPv4 addresses from the VPC pool instead of Elastic IPs
D) Switch to IPv6 to avoid the need for Elastic IPs

**Correct Answer: B**
**Explanation:** This tests practical knowledge of EIP management: (1) Unassociated EIPs in VPC incur hourly charges ($0.005/hour = ~$3.65/month each) — releasing 3 saves ~$11/month and frees 3 addresses; (2) Many EIP use cases can be replaced: ALB/NLB provide stable DNS endpoints, CloudFront provides static IP via Global Accelerator; (3) After releasing unused EIPs and evaluating alternatives, a quota increase request handles remaining needs; (4) Config rule prevents future waste. Important note: as of 2024, AWS charges for ALL public IPv4 addresses ($0.005/hour per IP), including those on running EC2 instances and EIPs — this makes the optimization even more impactful. Option A doesn't address the waste. Option C still uses public IPv4 which has the same charges. Option D may not be feasible for all applications.

---

### Question 36
A solutions architect needs to design a system that processes exactly 1 million S3 event notifications per day. Each notification triggers a Lambda function that takes 5-30 seconds to process. The Lambda function must process events in the order they were created per S3 key (but events for different keys can be processed in parallel). Maximum event processing delay should be 5 minutes. Which architecture ensures ordered processing per key while maintaining parallelism?

A) S3 Event Notification → Lambda (direct invocation)
B) S3 Event Notification → SQS FIFO queue with the S3 object key as the message group ID → Lambda event source mapping with batch size 1, ensuring per-key ordering while allowing parallel processing across different message groups, with MaximumBatchingWindow of 0 to minimize delay, and Lambda reserved concurrency set high enough to handle the parallelism
C) S3 Event Notification → Kinesis Data Streams with the S3 key as the partition key → Lambda consumer
D) S3 Event Notification → EventBridge → Lambda

**Correct Answer: B**
**Explanation:** The key requirement is per-key ordering with cross-key parallelism: (1) SQS FIFO queue with S3 object key as message group ID guarantees ordering within each key's messages; (2) Different message group IDs (different S3 keys) are processed in parallel by different Lambda invocations; (3) Batch size 1 with BatchingWindow 0 ensures each message is processed immediately; (4) At 1M events/day (~12 events/second average), FIFO queue throughput is more than sufficient (300 msg/sec per group, 3,000 per queue with high throughput mode). Option A's direct Lambda invocation doesn't guarantee ordering. Option C's Kinesis can provide ordering via partition key but the per-shard throughput management is more complex. Option D's EventBridge doesn't guarantee ordering.

---

### Question 37
A company is implementing a disaster recovery plan and needs to understand the actual RTO of their Aurora Global Database failover. They run a DR test and measure: DNS propagation to Route 53 health check: 30 seconds, Aurora Global Database managed planned failover: 1-2 minutes, Application connection pool refresh: 30-60 seconds, Cache warming (ElastiCache): 5-10 minutes, Post-failover data validation: 15 minutes. The total measured RTO is 20-28 minutes. They need to reduce RTO to under 5 minutes. Which changes have the GREATEST impact on reducing RTO?

A) Use a faster DNS provider
B) Implement these optimizations to reduce each RTO component: replace Route 53 DNS-based failover with Route 53 ARC routing controls (instant traffic shift, no DNS propagation delay), pre-warm ElastiCache in the DR region by implementing ElastiCache Global Datastore with continuous replication (eliminating cache warming time), use RDS Proxy in the DR region with pre-established connection pools (eliminating application connection pool refresh), automate post-failover validation with AWS FIS (pre-validated through regular DR drills, reducing validation to a confirmation step), and implement Aurora fast failover client driver (aurora-mysql-java-driver) for sub-second connection switching
C) Increase Aurora Global Database storage to make failover faster
D) Accept the 20-28 minute RTO

**Correct Answer: B**
**Explanation:** Each optimization targets a specific RTO component: (1) Route 53 ARC: 30 seconds → near-instant (eliminates DNS propagation); (2) Aurora fast client driver: handles connection switching in the application transparently in seconds; (3) RDS Proxy: pre-established pools eliminate 30-60 second connection refresh; (4) ElastiCache Global Datastore: continuous replication eliminates 5-10 minute cache warming; (5) Automated validation: 15 minutes → 1-2 minutes (pre-validated through regular drills). New RTO: instant traffic shift + 1-2 minute Aurora failover + 1 minute validation = ~3 minutes, under the 5-minute target. Option A's DNS is only 30 seconds of the total. Option C doesn't affect failover time.

---

### Question 38
A company has an AWS account that was compromised through a leaked access key posted on a public GitHub repository. The attacker launched 100 cryptocurrency mining instances (p3.16xlarge) across multiple regions, generating a $50,000 bill in 8 hours before being detected. How should the company respond and prevent future incidents? (Choose THREE from FIVE)

A) Immediately deactivate ALL IAM access keys in the account (including legitimate ones), then work with users to issue new keys after establishing which are compromised
B) Use AWS CloudTrail to identify ALL actions taken by the compromised credentials, checking for persistence mechanisms (new IAM users, roles, policies, Lambda functions, EC2 key pairs) and remove them
C) Enable AWS GuardDuty which would have detected the cryptocurrency mining activity within minutes through its CryptoMining finding type, and enable GuardDuty S3 and EC2 protection across all accounts
D) Implement git-secrets or AWS Secrets Manager rotation to prevent access keys from being committed to code repositories, and enforce IAM policies requiring MFA for all IAM user operations
E) Contact AWS Support to dispute the entire $50,000 bill

**Correct Answer: A, B, C**
**Explanation:** This is an incident response scenario requiring: (A) Immediate containment: deactivating all access keys stops the attacker's ability to launch more resources. Yes, this disrupts legitimate users, but containment is the priority. New keys can be issued after the investigation. (B) Forensics and cleanup: the attacker likely created backdoors — new IAM users, roles, policies, or Lambda functions that provide persistent access. CloudTrail reveals everything the compromised credentials did. Missing any persistence mechanism means the attacker can return. (C) Detection improvement: GuardDuty would have detected the crypto mining within minutes (CryptoCurrency:EC2/BitcoinTool.B finding), dramatically reducing the damage from $50,000 to perhaps $500. This prevents similar future incidents. Option D prevents future key leaks but doesn't address the current incident. Option E — AWS may provide a one-time courtesy credit but this isn't guaranteed and shouldn't be relied upon.

---

### Question 39
A company's Amazon ECS service running on Fargate occasionally experiences task failures. The tasks exit with exit code 137 (SIGKILL). The task definition specifies 2 vCPU and 4GB memory. CloudWatch Logs show the application's memory usage reaching 3.8GB before the task is killed. The operations team has been increasing the memory to 8GB, but costs have doubled. What is the root cause, and what is the MOST cost-effective fix?

A) Upgrade to larger Fargate task sizes
B) Exit code 137 indicates the container was killed due to out-of-memory (OOM). The container's memory usage (3.8GB) is approaching the task memory limit (4GB). The kernel's OOM killer terminates the process when memory pressure is critical. Cost-effective fixes: investigate the application for memory leaks (most common cause of gradually increasing memory), implement application-level memory management (connection pool limits, cache eviction, GC tuning for JVM applications), set the container's memoryReservation (soft limit) in the task definition to trigger warnings before hitting the hard limit, if the application genuinely needs more memory, increase to 5GB (not 8GB) — a 25% increase provides headroom while being much cheaper than doubling. Use Container Insights to monitor memory trends over time.
C) The application is crashing due to a software bug
D) Fargate has a bug — switch to EC2 launch type

**Correct Answer: B**
**Explanation:** Exit code 137 = SIGKILL, which in container environments almost always means OOM kill: (1) Container memory at 3.8GB out of 4GB limit triggered the kernel OOM killer; (2) Doubling to 8GB works but is wasteful — the real issue is why memory is growing to 3.8GB; (3) Common causes: memory leaks (objects not garbage collected), unbounded caches, connection pool growth; (4) JVM applications often need GC tuning (heap size relative to container memory); (5) Setting memoryReservation provides a soft limit warning; (6) If the application genuinely needs >4GB after optimization, a modest increase to 5GB is sufficient — not 8GB. This is a common real-world operational issue that tests both container knowledge and cost optimization thinking.

---

### Question 40
A company runs an application behind an Application Load Balancer. They notice that during deployments, approximately 5% of users receive 502 Bad Gateway errors for 30-60 seconds. The deployment uses a rolling update strategy in an Auto Scaling group. The ALB target group health check has: interval=30 seconds, healthy threshold=3, unhealthy threshold=2, timeout=5 seconds. What is causing the 502 errors, and how should the architect fix them?

A) The ALB is overloaded during deployments
B) The 502 errors occur because the ALB sends requests to new instances that haven't completed startup, or continues sending to instances being terminated. Fix: configure the ALB target group deregistration delay (default 300 seconds, set to match the connection drain time), implement a proper health check endpoint that returns 200 only when the application is fully ready to accept traffic (not just when the process is running), reduce the health check interval to 10 seconds and the healthy threshold to 2 (faster detection of healthy instances), enable connection draining to allow in-flight requests to complete on terminating instances, and configure the Auto Scaling group's instance warmup period to match the application startup time
C) Increase the number of instances to handle deployment load
D) Switch to blue-green deployment to avoid rolling update issues

**Correct Answer: B**
**Explanation:** 502 Bad Gateway during rolling deployments has two root causes: (1) New instances receiving traffic before they're ready — the health check interval (30 sec) × healthy threshold (3) = 90 seconds before an instance is considered healthy, but the ALB may start routing before this if the instance is registered; (2) Terminating instances dropping connections — without proper deregistration delay, in-flight requests are dropped. The fixes address both: shorter health check intervals detect readiness faster, proper health check endpoints ensure the application is truly ready, deregistration delay allows in-flight requests to complete, and instance warmup prevents the Auto Scaling group from considering the deployment complete before new instances are healthy. Option D's blue-green avoids the issue but is a different deployment strategy, not a fix.

---

### Question 41
A company stores sensitive customer data in DynamoDB with encryption using AWS-managed keys. A new regulation requires them to demonstrate they can render ALL customer data unreadable within 24 hours of a compliance request. The DynamoDB table has 5TB of data and processes 50,000 operations per second. Simply deleting all items would take days and consume massive write capacity. What is the FASTEST way to render the data unreadable?

A) Delete all items using BatchWriteItem
B) Implement crypto-shredding: change the table's encryption key to a customer-managed KMS key (CMK) — this requires creating a new table with the CMK and migrating data, which is pre-work done BEFORE the compliance scenario. Once the table uses a CMK, rendering data unreadable is achieved by scheduling the KMS key for deletion (7-day minimum waiting period) or immediately disabling the key (instant, rendering ALL data encrypted with that key immediately unreadable). To meet the 24-hour requirement, disable the key immediately when the compliance request is received.
C) Drop the DynamoDB table (DeleteTable API)
D) Overwrite all items with dummy data

**Correct Answer: B**
**Explanation:** Crypto-shredding is the fastest approach for rendering large datasets unreadable: (1) Disabling the KMS key is instantaneous — all 5TB becomes unreadable immediately; (2) The table still exists but no read operations can decrypt the data; (3) This meets the 24-hour requirement with margin; (4) IMPORTANT: the table must ALREADY use a customer-managed CMK (not AWS-managed key) — this is pre-work; (5) AWS-managed keys cannot be disabled or deleted by the customer. Option A's item-by-item deletion at 5TB with 50K ops/sec would take days. Option C's DeleteTable is fast but doesn't prove the data is unreadable (it triggers async deletion internally). Option D has the same speed issue as Option A.

---

### Question 42
A company operates an Amazon Redshift cluster and discovers that query performance degrades significantly when multiple users run complex queries simultaneously. The cluster has 10 dc2.8xlarge nodes. Analysis shows: WLM (Workload Management) is configured with a single default queue allowing 5 concurrent queries, memory is not allocated per query group, and some queries scan 500GB+ while others scan 1GB. How should the architect configure Redshift WLM for optimal multi-user performance?

A) Increase the concurrency limit in the default queue to 50
B) Implement Automatic WLM with query priorities: enable Automatic WLM which dynamically manages concurrency and memory allocation, create WLM query queues with priority levels — Critical (real-time dashboards, max priority), Normal (standard analytical queries, normal priority), Bulk (data loading and large scans, low priority), use query monitoring rules (QMR) to: abort queries running longer than 30 minutes (catch runaway queries), move queries scanning >100GB to the Bulk queue, and use Short Query Acceleration (SQA) to fast-track queries predicted to run in under 10 seconds
C) Add more nodes to the cluster
D) Implement result caching and disable concurrent queries

**Correct Answer: B**
**Explanation:** Redshift WLM optimization requires query classification and resource allocation: (1) Automatic WLM dynamically adjusts concurrency and memory per query, outperforming static allocation; (2) Priority-based queues ensure critical dashboard queries aren't blocked by large analytical scans; (3) QMR rules prevent runaway queries from consuming cluster resources; (4) Moving large scans to a lower-priority queue protects interactive query performance; (5) SQA provides dedicated fast-lane processing for small queries, dramatically improving their latency. Option A with 50 concurrent queries would OOM the cluster (each query needs memory). Option C doesn't address the resource contention. Option D is overly restrictive.

---

### Question 43
A company uses AWS CloudFormation to deploy infrastructure. A developer accidentally runs `aws cloudformation delete-stack` on a production stack containing: an Aurora database cluster, S3 buckets with customer data, DynamoDB tables, and Lambda functions. How should the architect prevent accidental stack deletion from destroying production resources?

A) Remove delete permissions from all IAM users
B) Implement multiple protection layers: enable CloudFormation Stack Termination Protection on all production stacks (prevents delete-stack API calls), add DeletionPolicy: Retain on critical resources (Aurora, S3, DynamoDB) — even if the stack is deleted, these resources are preserved, enable Aurora Deletion Protection at the database level (independent of CloudFormation), enable S3 bucket versioning and MFA Delete for S3 buckets, use SCPs to deny cloudformation:DeleteStack on stacks tagged as Environment=Production unless called by a specific deployment role, and implement CloudTrail alerts for DeleteStack API calls in production accounts
C) Use AWS Backup for all resources
D) Create a read-only copy of the CloudFormation template

**Correct Answer: B**
**Explanation:** Defense in depth against accidental deletion: (1) Stack Termination Protection: prevents the delete-stack API from executing — this would have prevented the incident; (2) DeletionPolicy: Retain: even if termination protection is somehow bypassed (root user), critical resources are preserved; (3) Aurora Deletion Protection: database-level protection independent of CloudFormation; (4) S3 versioning + MFA Delete: even if objects are "deleted," versions are preserved and can only be permanently deleted with MFA; (5) SCPs: organization-level policy preventing stack deletion in production; (6) CloudTrail alerts: detection layer for unauthorized deletion attempts. Multiple layers ensure no single failure leads to data loss. Option A blocks all users including legitimate deployment processes. Option C provides backups but not prevention. Option D doesn't prevent deletion.

---

### Question 44
A company needs to transfer 50TB of data from Azure Blob Storage to Amazon S3. They don't have on-premises infrastructure that could serve as an intermediary. The transfer must complete within 1 week. Which approach is MOST efficient for direct cloud-to-cloud data transfer?

A) Download from Azure to a local machine, then upload to S3
B) Use AWS DataSync with a DataSync agent deployed on an Azure VM: create a VM in Azure near the Blob Storage account, install the AWS DataSync agent on the Azure VM, configure a DataSync task with Azure Blob Storage as source (via HTTPS/NFS) and S3 as destination, DataSync optimizes the transfer with parallel streams, compression, and integrity verification, transfer speed: up to 10 Gbps depending on Azure VM networking
C) Use AWS Snow Family devices shipped to Azure's data center
D) Write a custom script using Azure SDK and AWS SDK to copy objects

**Correct Answer: B**
**Explanation:** For cloud-to-cloud transfer without on-premises infrastructure: (1) DataSync agent runs on an Azure VM, sitting close to the Azure Blob Storage for fast reads; (2) DataSync optimizes the transfer with parallel threads, minimizing transfer time; (3) At 10 Gbps, 50TB transfers in ~11 hours — well within 1 week; (4) DataSync handles data integrity verification automatically; (5) No on-premises infrastructure needed — everything runs in the cloud. Option A adds local machine as a bottleneck. Option C's Snow devices can't be shipped to Azure data centers. Option D's custom script would be slower and less reliable than DataSync's optimized transfer engine.

---

### Question 45
A company runs a critical application on Amazon EKS. During a routine update of a core microservice, a bug was deployed that caused a database corruption event. By the time the issue was detected (2 hours later), 10,000 records were corrupted. The company needs to: recover the corrupted data, prevent similar incidents, and implement faster detection. Which combination of actions provides comprehensive protection? (Choose THREE from FIVE)

A) Implement database point-in-time recovery: restore the Aurora database to a point 2 hours ago (before the corrupted deployment), extract the original 10,000 records, and merge them back into the production database using a Lambda-based reconciliation script
B) Implement Argo Rollouts with automated canary analysis: deploy changes to 5% of traffic first, use Amazon Managed Prometheus metrics to compare error rates and data quality metrics between canary and stable versions, automatically rollback if metrics degrade
C) Add more unit tests to the CI/CD pipeline
D) Implement database change data capture (CDC) with Amazon MSK: stream all database changes to Kafka topics, use a Flink application to validate data quality rules in real-time (detecting anomalous write patterns within minutes), and trigger automated alerts/rollbacks when data quality violations are detected
E) Enable Amazon DevOps Guru for anomaly detection on the EKS cluster, which uses ML to detect operational anomalies in metrics and automatically creates OpsItems in Systems Manager for investigation

**Correct Answer: A, B, D**
**Explanation:** Three actions covering recovery, prevention, and detection: (A) Data recovery: Aurora PITR enables restoring to any point within the backup retention period. Restoring to a point before the corruption and extracting the correct records solves the immediate data issue. (B) Prevention: Canary deployments with automated analysis would have detected the bug when it first corrupted records in the 5% canary traffic, automatically rolling back before it affected 100% of traffic. (D) Faster detection: Real-time CDC validation through Flink detects anomalous write patterns (e.g., unexpected data modifications) within minutes, not hours. Option C improves code quality but doesn't provide runtime protection. Option E detects operational anomalies but may not specifically catch data corruption patterns as effectively as purpose-built CDC validation.

---

### Question 46
A company is running a multi-account AWS environment with 300 accounts. They need to implement a solution that automatically detects and remediates the following security issues across all accounts within 15 minutes: S3 buckets made public, security groups opened to 0.0.0.0/0 on port 22 or 3389, CloudTrail logging disabled, and root user access keys created. Which architecture provides the fastest detection and remediation?

A) AWS Config rules with manual remediation
B) Deploy across all 300 accounts via CloudFormation StackSets: AWS Config rules for each violation type with automatic remediation using SSM Automation documents — s3-bucket-public-read-prohibited triggers Lambda to remove public ACL/policy, restricted-ssh triggers Lambda to remove the offending security group rule, cloud-trail-enabled triggers Lambda to enable CloudTrail, iam-root-access-key-check triggers Lambda to deactivate root access keys and alert security team, Config aggregator in the security account for centralized visibility, EventBridge rules in each account forwarding Config compliance change events to a central security account for additional processing and alerting via SNS
C) Weekly security audit using AWS Trusted Advisor
D) Amazon Inspector for all security scanning

**Correct Answer: B**
**Explanation:** For 15-minute detection/remediation across 300 accounts: (1) Config rules evaluate continuously — detecting changes within minutes; (2) Automatic remediation via SSM Automation executes immediately upon non-compliance detection; (3) Each violation has a specific remediation: public S3 → remove public access, open SSH → remove SG rule, CloudTrail disabled → re-enable, root keys → deactivate; (4) StackSets deploy the configuration to all 300 accounts consistently; (5) Config aggregator provides centralized compliance visibility; (6) EventBridge cross-account events enable additional security team notification. Total detection + remediation time: ~5-10 minutes (Config evaluation + Lambda execution). Option A requires manual intervention. Option C's weekly audit is too slow. Option D's Inspector scans for vulnerabilities, not configuration compliance.

---

### Question 47
A company's Amazon S3 bucket receives 100,000 PUT requests per second for small objects (1KB each). They notice that request rates are being throttled with HTTP 503 Slow Down responses. S3 supports 3,500 PUT requests per second per prefix. The current bucket structure uses a single prefix: s3://bucket/data/YYYY/MM/DD/file.json. How should the architect redesign the key structure to eliminate throttling?

A) Enable S3 Transfer Acceleration
B) Distribute objects across multiple prefixes using a hash-based prefix strategy: instead of s3://bucket/data/YYYY/MM/DD/file.json, use s3://bucket/[hex-hash-prefix]/data/YYYY/MM/DD/file.json where [hex-hash-prefix] is a 2-character hex hash (00-ff) of the file name, providing 256 unique prefixes. At 3,500 PUTs/second per prefix × 256 prefixes = 896,000 PUTs/second capacity — well above the 100,000 requirement. Alternatively, use randomized prefixes or restructure the prefix hierarchy to distribute writes naturally.
C) Create multiple S3 buckets and distribute writes across them
D) Enable S3 Intelligent-Tiering for better performance

**Correct Answer: B**
**Explanation:** S3 throttling is per-prefix based: (1) With a single prefix (/data/), the limit is 3,500 PUTs/second — far below the 100,000 requirement; (2) Adding hash-based prefixes distributes writes: 256 hex prefixes (00-ff) provide 256 × 3,500 = 896,000 PUTs/second capacity; (3) The hash prefix is derived from the file name, ensuring even distribution; (4) Applications reading the data can still use S3 prefix listing within each hash prefix, or maintain an index in DynamoDB. Note: AWS has improved S3's prefix scaling over the years, and S3 can automatically scale to much higher request rates, but the initial scaling takes time. Pre-distributing across prefixes provides immediate high throughput. Option A doesn't affect per-prefix limits. Option C adds unnecessary complexity. Option D doesn't affect performance.

---

### Question 48
A company wants to implement a GitOps workflow for managing their Kubernetes infrastructure on EKS. They need to ensure that: all cluster changes go through git (no manual kubectl changes), changes are automatically applied when merged to the main branch, the actual cluster state is continuously reconciled with the desired state in git, and drift from the git-defined state is automatically corrected. Which architecture implements GitOps correctly?

A) CI/CD pipeline that runs kubectl apply on every git merge
B) Deploy Flux CD or ArgoCD on the EKS cluster: configure the GitOps operator to watch the git repository containing Kubernetes manifests, automatic sync on git changes (pull-based — the cluster pulls from git, not push-based), continuous reconciliation loop that detects and corrects any drift between cluster state and git state (even manual kubectl changes are reverted), implement OPA Gatekeeper admission controller that blocks direct kubectl apply commands that bypass git (preventing non-GitOps changes), and use Sealed Secrets or External Secrets Operator for secrets management (secrets encrypted in git)
C) AWS CodePipeline with CodeBuild running kubectl apply
D) Helm chart deployments from a CI server

**Correct Answer: B**
**Explanation:** GitOps requires specific characteristics that only Option B provides: (1) Pull-based model: the GitOps operator IN the cluster pulls desired state from git (more secure than push-based — no CI server needs cluster credentials); (2) Continuous reconciliation: the operator constantly compares actual vs. desired state and corrects drift (this is what makes it "ops" not just "deploy"); (3) OPA Gatekeeper blocks direct kubectl changes, enforcing the "all changes through git" requirement; (4) Sealed Secrets or External Secrets enables storing encrypted secrets in git. Options A, C, and D are all push-based CI/CD — they push changes to the cluster but don't implement continuous reconciliation or drift correction, which are the defining characteristics of GitOps.

---

### Question 49
A company has a SageMaker ML pipeline that trains a model daily. The training job takes 4 hours on an ml.p3.16xlarge instance ($24.48/hr = ~$98 per training run = ~$2,940/month). The model accuracy has stabilized and daily retraining isn't always necessary — the model only needs retraining when the data distribution has significantly changed. How should the architect optimize the training cost while maintaining model quality?

A) Reduce training frequency to weekly regardless of data changes
B) Implement a data drift detection pipeline: use SageMaker Model Monitor with a data quality baseline to continuously analyze incoming data for distribution drift, configure drift detection thresholds (e.g., KL-divergence > 0.1 for key features), trigger retraining ONLY when significant drift is detected (via EventBridge → Step Functions → SageMaker Training Job), use SageMaker Managed Spot Training for the training job when triggered (70% savings), and implement an A/B testing framework to validate the newly trained model before promoting to production
C) Use a smaller instance type for training
D) Train only once and never retrain

**Correct Answer: B**
**Explanation:** Option B provides intelligent retraining optimization: (1) Model Monitor detects when the incoming data distribution has shifted from the training data baseline; (2) Retraining only occurs when drift is significant — reducing from 30 training runs/month to perhaps 5-8; (3) Spot instances reduce each training run cost by ~70%: $98 × 0.30 = $29.40; (4) 7 runs × $29.40 = $206/month vs. $2,940 (93% savings); (5) A/B testing validates the new model doesn't degrade performance. Option A's weekly retraining is arbitrary and may miss needed retraining or do unnecessary retraining. Option C reduces per-run cost but not frequency. Option D risks serving a stale model as data patterns change.

---

### Question 50
A company operates in an industry where they must demonstrate to auditors that their encryption keys have NEVER been accessible to AWS personnel or any other entity. The keys must be stored in hardware that is physically tamper-evident and FIPS 140-2 Level 3 validated. They need to encrypt data across S3, EBS, RDS, and Lambda environment variables. Which key management architecture meets these strict requirements?

A) AWS KMS with customer-managed CMKs (FIPS 140-2 Level 2)
B) AWS CloudHSM cluster (FIPS 140-2 Level 3) in their VPC: customer-owned, single-tenant HSM appliances where only the customer has the credentials (not AWS), KMS Custom Key Store backed by CloudHSM — allowing KMS-integrated services (S3, EBS, RDS) to use keys stored in CloudHSM, Lambda environment variables encrypted using the CloudHSM-backed KMS CMK, regular key ceremony audits with HSM audit logs exported to CloudWatch for compliance evidence
C) On-premises HSM with client-side encryption only
D) AWS KMS with external key store (XKS) backed by an on-premises HSM

**Correct Answer: B**
**Explanation:** The requirements are FIPS 140-2 Level 3 AND demonstrable exclusivity from AWS: (1) CloudHSM provides dedicated, single-tenant HSMs that are FIPS 140-2 Level 3 validated; (2) Only the customer manages the HSM credentials — AWS cannot access the key material; (3) KMS Custom Key Store integrates CloudHSM with KMS, enabling all KMS-integrated services (S3 SSE-KMS, EBS encryption, RDS encryption) to use CloudHSM-backed keys; (4) Lambda environment variables can be encrypted with the custom key store CMK; (5) HSM audit logs provide cryptographic evidence of all key operations. Option A's KMS uses AWS-managed HSMs that are Level 2, not Level 3, and AWS has some access to the infrastructure. Option C doesn't integrate with AWS services. Option D (XKS) would work but adds complexity and latency of calling the on-premises HSM for every operation, potentially impacting application performance.

---

### Question 51
A company is running an application that writes 10,000 log messages per second to Amazon CloudWatch Logs. Each log message is 1KB. They're paying $4,500/month for log ingestion ($0.50 per GB × 300GB/month). They also pay $1,350/month for log storage ($0.03 per GB for 45TB accumulated). Total: $5,850/month. The company only needs to search logs from the last 7 days for troubleshooting. Older logs need to be kept for compliance but are rarely queried. How should they optimize CloudWatch Logs costs?

A) Reduce log verbosity
B) Set CloudWatch Logs retention to 7 days, export logs to S3 before the retention period expires using a subscription filter → Kinesis Data Firehose → S3, use S3 lifecycle policies to transition logs older than 30 days to Glacier for long-term compliance storage, use S3 Select or Athena for querying archived logs on the rare occasions they're needed
C) Switch to a self-managed ELK stack on EC2
D) Send logs directly to S3 and use Athena for all log queries

**Correct Answer: B**
**Explanation:** Option B dramatically reduces costs while maintaining all capabilities: (1) 7-day CloudWatch retention: accumulated storage drops from 45TB to ~2.1TB (7 days × 300GB/month ÷ 30 ≈ 70GB). Storage cost: $2.10/month (from $1,350); (2) Log ingestion cost remains $4,500/month (same volume); (3) S3 storage for the remaining data: 300GB/month for the first 30 days in Standard ($6.90) + older months in Glacier (~$0.004/GB). At 45TB in Glacier: $184/month; (4) Firehose delivery: ~$30/month; (5) New total: $4,500 + $2 + $7 + $184 + $30 = ~$4,723/month (19% savings on total, 86% savings on storage). For even more savings, Option D's direct-to-S3 approach eliminates CloudWatch ingestion cost ($4,500), but loses real-time log querying capability (CloudWatch Logs Insights). Option B maintains the real-time troubleshooting capability for recent logs.

---

### Question 52
A company's application uses an Amazon SQS Standard queue. During a load test, they discover messages are being processed multiple times, causing duplicate order charges. The application processes 5,000 messages per second. The team considers switching to a FIFO queue but is concerned about the 3,000 messages/second limit (with high throughput). What is the BEST approach to achieve exactly-once processing at 5,000 messages/second?

A) Switch to SQS FIFO with high throughput mode
B) Keep the Standard queue (unlimited throughput) but implement idempotent message processing: use a DynamoDB table as a deduplication store with the SQS message's MessageId (or a business-level idempotency key from the message body) as the partition key, before processing each message check DynamoDB (conditional PutItem with attribute_not_exists), if the key exists skip processing (duplicate), if not exists process and record completion, use DynamoDB TTL to automatically clean up old deduplication records after a reasonable window (24 hours)
C) Use Amazon MQ (RabbitMQ) for exactly-once delivery
D) Process messages faster to avoid visibility timeout expiration and redelivery

**Correct Answer: B**
**Explanation:** At 5,000 messages/second, FIFO's 3,000/sec limit is insufficient. Option B provides exactly-once processing semantics on top of the unlimited Standard queue: (1) DynamoDB conditional write (PutItem with attribute_not_exists) is atomic and prevents two simultaneous processors from both processing the same message; (2) MessageId or business-level key provides unique identification; (3) DynamoDB handles 5,000+ conditional writes per second easily; (4) TTL automatically cleans up the deduplication table; (5) This pattern is widely used in production systems at scale. Option A's FIFO can't handle the throughput. Option C's RabbitMQ doesn't provide true exactly-once either. Option D doesn't prevent duplicates from network issues or consumer errors.

---

### Question 53
A company is running Amazon ElastiCache for Redis with a single node (r6g.2xlarge, 52.82 GiB). The Redis instance stores user session data for their web application. During a node failure, ALL sessions would be lost, causing all users to be logged out. The company needs: zero session loss during node failures, sub-millisecond read latency, and automatic failover. Which Redis deployment provides these guarantees?

A) Enable Multi-AZ on the existing Redis cluster (cluster mode disabled) with automatic failover — this creates a replica in another AZ that is promoted to primary during a failure, providing data persistence across node failures
B) Enable Redis cluster mode with 3 shards, each having 2 replicas, providing both high availability and higher memory capacity
C) Use DynamoDB for session storage instead of Redis
D) Implement application-level session replication to multiple Redis instances

**Correct Answer: A**
**Explanation:** For session data requiring zero loss during node failure: (1) ElastiCache Redis with Multi-AZ creates a synchronous replica in another AZ; (2) During primary failure, the replica is automatically promoted (~seconds of downtime); (3) Since replication is synchronous, no session data is lost; (4) Sub-millisecond read latency is maintained on the replica; (5) Automatic failover is built into the Multi-AZ configuration. Option B with cluster mode provides more capacity and availability but is more complex — if the only issue is single-node failure resilience, Multi-AZ is sufficient and simpler. Option C's DynamoDB provides durability but higher latency (~5ms) than Redis (<1ms). Option D adds application complexity.

---

### Question 54
A company runs a critical database on Amazon RDS for PostgreSQL (db.r5.4xlarge). The database handles 20,000 transactions per second. The DBA discovers that the pg_stat_activity view shows 300 connections, but the instance supports a maximum of 5,000 connections. Despite low connection usage, the database intermittently becomes unresponsive for 30-60 seconds. What is the MOST likely cause, and how should the architect investigate?

A) The instance is too small and needs to be upgraded
B) The intermittent unresponsiveness is likely caused by autovacuum running on large tables, which can temporarily block other operations due to lock contention. Investigate: check PostgreSQL logs for autovacuum activity correlating with unresponsive periods, enable Performance Insights to identify wait events (Lock:Relation, IO:DataFileRead during vacuum), check for bloated tables (pg_stat_user_tables with high dead tuple counts), and optimize: tune autovacuum parameters (autovacuum_vacuum_cost_delay, autovacuum_vacuum_cost_limit) to spread vacuum I/O over longer periods, increase maintenance_work_mem for faster vacuuming, and consider enabling rds.force_autovacuum_logging_level to log all vacuum activity
C) Network connectivity issues between the application and RDS
D) The 300 connections are causing connection pool exhaustion

**Correct Answer: B**
**Explanation:** Intermittent 30-60 second unresponsiveness in PostgreSQL is a classic autovacuum symptom: (1) PostgreSQL's MVCC creates dead tuples that autovacuum must clean; (2) Autovacuum can hold AccessExclusiveLock on tables during index cleanup, blocking all queries on that table; (3) Large tables with high update rates generate many dead tuples, making autovacuum more aggressive; (4) Performance Insights wait events reveal the specific contention; (5) Tuning autovacuum_vacuum_cost_delay reduces the I/O burst impact. Option A — the instance has capacity (300/5000 connections, 20K TPS). Option C would cause different symptoms (connection errors, not unresponsiveness). Option D — 300 connections is well within limits.

---

### Question 55
A company runs an Amazon EKS cluster with 100 nodes. They deploy a new version of a microservice that has a memory leak. The memory leak causes the pods to consume increasingly more memory over 6 hours until they're killed by the Kubernetes OOM killer. When killed, new pods are started, which also eventually leak memory. This creates a cycle of pod restarts that gradually degrades cluster performance as more and more pods are in CrashLoopBackOff state. By the time the operations team notices (12 hours later), 40% of the cluster's pods are unhealthy. How should the architect implement earlier detection and automatic remediation?

A) Add more memory to the pods
B) Implement a multi-layered detection and remediation system: Kubernetes resource limits (already in place, triggering OOM kill), Horizontal Pod Autoscaler (HPA) with custom memory-growth-rate metric — if memory growth rate exceeds a threshold, scale up replacement pods before existing ones crash, Amazon Managed Prometheus with custom alerting rules that detect abnormal memory growth patterns (rate of increase, not just absolute value), Container Insights with anomaly detection on pod restart counts, automated rollback using Argo Rollouts AnalysisRun that monitors pod restart count — if restarts exceed threshold within 30 minutes of deployment, automatically roll back to the previous version
C) Run memory profiling tools in production continuously
D) Increase the OOM kill threshold so pods run longer before crashing

**Correct Answer: B**
**Explanation:** This scenario requires detection of a subtle degradation pattern: (1) Memory growth rate detection catches the leak before pods crash — monitoring rate of increase rather than absolute value identifies leaks within minutes; (2) HPA with custom metrics can scale up healthy replacement pods; (3) Pod restart count anomaly detection catches the CrashLoopBackOff pattern; (4) Argo Rollouts AnalysisRun provides the key prevention — by monitoring pod restarts after deployment, it can automatically roll back the leaking version within 30 minutes, preventing the 12-hour degradation; (5) Prometheus alerting provides early warning even without automatic rollback. Option A masks the symptom. Option C adds overhead. Option D delays the crash but doesn't solve the problem.

---

### Question 56
A solutions architect is designing a data architecture where the company needs to run the same SQL query against data stored in: Amazon S3 (Parquet files), Amazon DynamoDB, Amazon RDS PostgreSQL, and Amazon Redshift. The query must join data across these four sources. Which service provides federated querying across all four data stores?

A) Amazon Athena with federated query connectors for all four sources
B) Amazon Redshift with federated query (RDS and S3 via Spectrum) plus Redshift's DynamoDB connector, enabling a single Redshift SQL query to join data across all four stores through external schemas
C) AWS Glue ETL to consolidate all data into one location first
D) Write a custom application that queries each store and joins results in memory

**Correct Answer: A**
**Explanation:** Amazon Athena with federated query supports all four data stores: (1) S3 (Parquet): native Athena capability via external tables; (2) DynamoDB: Athena DynamoDB connector; (3) RDS PostgreSQL: Athena JDBC connector; (4) Redshift: Athena Redshift connector. A single Athena SQL query can JOIN data across all four sources using the respective connectors. Option B's Redshift can federate to RDS and S3 (Spectrum) but DynamoDB integration via Redshift is limited and requires additional configuration. Athena's connector framework provides the most uniform federated query experience across all four stores. Option C adds latency and complexity. Option D requires custom development.

---

### Question 57
A company has a Lambda function that uses the AWS SDK to call other AWS services. The function works perfectly in testing but intermittently fails in production with "Credential should be scoped to correct service" errors. The Lambda function's execution role has the correct permissions. What is the MOST likely cause?

A) The Lambda execution role doesn't have the required permissions
B) The Lambda function is using a cached/stale set of temporary credentials from the execution environment that have become invalid, OR the function is incorrectly constructing AWS SDK clients with hardcoded region configurations that don't match the service endpoint. Fix: ensure AWS SDK clients are created inside the handler function (not in the initialization code where credentials might be cached across warm starts with a different region scope), use the AWS SDK's default credential provider chain without manually specifying credentials, and verify the region configuration matches the target service's region
C) The Lambda function has a timeout issue
D) VPC configuration is blocking the AWS API calls

**Correct Answer: B**
**Explanation:** "Credential should be scoped to correct service" is a specific AWS error indicating the STS temporary credentials are being used with a service they weren't scoped for. Common causes in Lambda: (1) Credentials cached from a previous invocation in the global scope may have region/service scoping issues; (2) Manual client construction with incorrect region configuration; (3) Using credentials from one service's assume-role response with a different service. Fix: use the default credential provider chain (which Lambda's runtime auto-configures), don't cache or manually manage credentials, ensure SDK clients use the correct region. Option A would produce "Access Denied" not "scoped to correct service." Option C produces timeout errors. Option D produces connection timeout errors.

---

### Question 58
A company is designing a system that must maintain exactly one active instance of a critical batch processor across their EKS cluster. If the processor crashes, a new instance must start within 30 seconds. Only one instance may run at any time (running two simultaneously would cause data corruption). Which Kubernetes pattern ensures single-instance execution with fast failover?

A) Deployment with replicas=1
B) Use a Kubernetes StatefulSet with replicas=1 combined with a PodDisruptionBudget (minAvailable=1), and implement a leader election pattern using Kubernetes Lease API — the batch processor acquires a lease (distributed lock) before processing, and other standby pods (if using a Deployment with multiple replicas but leader election) wait to acquire the lease. Alternatively, use a simpler approach: StatefulSet with replicas=1, PodDisruptionBudget, and priority class set to system-critical to ensure the pod is rescheduled immediately (within seconds) on node failure
C) CronJob with a schedule of every minute
D) DaemonSet limited to one specific node

**Correct Answer: B**
**Explanation:** Ensuring exactly one active instance with fast failover requires: (1) StatefulSet with replicas=1 guarantees at most one pod (Deployment with replicas=1 can briefly have 2 during updates); (2) PodDisruptionBudget prevents voluntary disruptions from killing the pod; (3) Priority class system-critical ensures the pod is rescheduled first during node failures; (4) For even faster failover, leader election with standby pods: Deployment with 3 replicas but only the lease-holder processes data, others are warm standbys that acquire the lease in seconds if the leader fails. Option A's Deployment can have 2 pods during rolling updates (violating the "only one" requirement). Option C doesn't maintain a continuously running instance. Option D fails if that node goes down.

---

### Question 59
A company is evaluating the cost of running their application in a single large instance vs. multiple smaller instances. The application can be horizontally scaled. Workload: requires 96 vCPU and 384 GiB memory. Option A: 1 × m5.24xlarge (96 vCPU, 384 GiB, $4.608/hr). Option B: 6 × m5.4xlarge (16 vCPU, 64 GiB each, $0.768/hr × 6 = $4.608/hr). The per-hour cost is identical. Which option should the architect choose and why?

A) Option A — single instance is simpler to manage
B) Option B — multiple smaller instances provide: higher availability (loss of one instance loses only 16.7% of capacity, not 100%), better fault isolation (application bugs or OS issues affect one instance, not the entire workload), more effective use of Auto Scaling (can scale in smaller increments), better Spot instance availability (smaller instance types have more capacity in Spot pools), and eligibility for Savings Plans/RIs at a more common instance size (m5.4xlarge is more likely to be reusable across teams)
C) It doesn't matter since the cost is the same
D) Option A — single instance has better network performance

**Correct Answer: B**
**Explanation:** When per-hour cost is identical, operational advantages determine the winner: (1) Availability: losing 1 of 6 instances (16.7% capacity loss) is far better than losing the single large instance (100% capacity loss); (2) Fault isolation: OS crashes, memory corruption, or application bugs are contained to one instance; (3) Auto Scaling: adding/removing 16-vCPU increments is more granular than 96-vCPU increments; (4) Spot availability: m5.4xlarge has significantly more capacity in Spot pools than m5.24xlarge, enabling Spot savings; (5) RI/SP flexibility: m5.4xlarge commitments can be reused if workload changes. Option A's single instance has higher blast radius and fewer scaling options. Option D — m5.24xlarge has 25 Gbps network, but 6 × m5.4xlarge each has up to 10 Gbps, providing potentially higher aggregate bandwidth.

---

### Question 60
A company needs to implement real-time language translation for their global customer support chat application. They support 15 languages. The system must: detect the input language automatically, translate between any language pair, maintain conversation context for better translations, and handle 10,000 concurrent chat sessions. Which architecture provides contextual real-time translation?

A) Amazon Translate for each message independently
B) Amazon Translate with custom terminology and parallel data for domain-specific accuracy, combined with: Amazon Comprehend for language detection (DetectDominantLanguage), conversation context maintained in ElastiCache Redis (last 10 messages per conversation stored as context), Lambda function that constructs translation requests including conversation context for contextual translation, WebSocket API Gateway for real-time message delivery, and Amazon Translate's adaptive translation feature that improves quality using custom parallel data from previous support interactions
C) Deploy a custom NMT (Neural Machine Translation) model on SageMaker
D) Use a third-party translation API through API Gateway

**Correct Answer: B**
**Explanation:** Option B provides contextual, high-quality real-time translation: (1) Comprehend detects the source language automatically; (2) Translate handles all 15 × 14 = 210 language pairs; (3) Redis-cached conversation context enables Lambda to include recent messages for contextual translation — critical for maintaining coherence in conversation; (4) Custom terminology ensures domain-specific terms (product names, technical terms) are translated correctly; (5) Parallel data from historical support interactions trains Translate to produce industry-specific translations; (6) WebSocket API Gateway delivers translations in real-time. Option A loses conversation context, leading to inconsistent translations. Option C requires ML expertise and ongoing model maintenance. Option D adds external dependency and latency.

---

### Question 61 - 75
[Questions 61-75 continue with similarly challenging scenarios across all domains, testing edge cases, service limits, and requiring deep architectural reasoning. Due to the comprehensive nature of this final exam, these questions maintain the same difficulty level and format as questions 1-60.]

### Question 61
A company is using Amazon Aurora PostgreSQL with a db.r5.4xlarge writer instance. They've enabled Performance Insights and notice that the top wait event is "IO:DataFileRead" consuming 60% of database time. The database has 2TB of data, but the instance has only 128 GiB of memory. The working set analysis shows that 500GB of data is accessed frequently. What is the root cause, and what is the MOST cost-effective fix?

A) Enable Aurora I/O Optimized to reduce I/O costs
B) The root cause is that the buffer cache (shared_buffers) is too small to hold the 500GB working set, causing frequent disk reads. Aurora uses the instance memory for its buffer pool. Fix: scale up to db.r5.12xlarge (384 GiB memory) to fit the 500GB working set in memory, which eliminates most disk I/O. The increased instance cost is offset by reduced I/O operations (Aurora charges per I/O). Alternatively, implement application-level caching with ElastiCache to cache the most frequently accessed 500GB of data.
C) Add Aurora read replicas to distribute the I/O
D) Increase the storage IOPS allocation

**Correct Answer: B**
**Explanation:** IO:DataFileRead indicates the database is reading from storage because data isn't in the buffer cache: (1) 128 GiB memory cannot cache the 500GB working set, causing ~75% cache miss rate; (2) Scaling to db.r5.12xlarge (384 GiB) with effective buffer pool ~300GB significantly reduces cache misses; (3) Further adding ElastiCache for Redis to cache the hottest data at the application layer can handle the remaining misses; (4) The reduced I/O operations (Aurora Standard charges per I/O) may partially offset the larger instance cost. Option A (I/O Optimized) changes the pricing model but doesn't reduce actual I/O. Option C's read replicas help distribute queries but each replica has the same cache miss issue. Option D doesn't help — Aurora's storage is already high-performance; the issue is memory, not disk speed.

---

### Question 62
A company deploys a new service on ECS Fargate. The service starts successfully but health checks fail intermittently, causing the service to cycle between "RUNNING" and "DRAINING" states. The target group health check is configured with path=/health, interval=30s, timeout=5s, healthy threshold=5, unhealthy threshold=2. The /health endpoint queries the database and returns 200 if successful. What is the MOST likely cause of the health check flapping?

A) The Fargate task doesn't have enough CPU
B) The health check configuration is too aggressive: with a 5-second timeout and database dependency, intermittent database latency (>5 seconds) causes health check failures. With unhealthy threshold=2, just 2 consecutive failures (which can happen during brief database slow periods) mark the target as unhealthy. Fix: change the health check to a lightweight endpoint (/ping) that returns 200 without database dependency (checking only that the application process is running), increase the timeout to 10 seconds, increase the unhealthy threshold to 5, and implement a separate deep health check (/health/deep) for monitoring that DOES check dependencies but isn't used for ALB routing decisions
C) The security group is blocking health check traffic
D) The ECS service deployment configuration is incorrect

**Correct Answer: B**
**Explanation:** Health check flapping is a common production issue caused by dependency-coupled health checks: (1) The /health endpoint queries the database — any database latency spike >5 seconds causes a health check failure; (2) With unhealthy threshold=2, just two consecutive failures (1 minute) triggers target deregistration; (3) Once deregistered, the target goes through the healthy threshold (5 × 30s = 2.5 minutes) to recover; (4) This creates a cycle: healthy → brief DB latency → unhealthy → recovery → healthy → next DB spike. The fix separates "is the application running" (shallow health check for routing) from "are all dependencies healthy" (deep health check for monitoring). Option A would cause consistent failures, not intermittent. Option C would cause all health checks to fail.

---

### Question 63
A company is running a distributed tracing system using AWS X-Ray. They trace 10 million requests per day. X-Ray sampling is set to 100% (trace every request). Monthly X-Ray cost: $50,000 (traces recorded: $5 per million × 300M segments, plus $0.50 per million segments retrieved). How should the architect reduce X-Ray costs while maintaining observability?

A) Disable X-Ray tracing
B) Implement intelligent sampling: reduce the default sampling rate from 100% to 1% for normal traffic (X-Ray reservoir rule: 1 trace per second per service + 1% of additional requests), create custom sampling rules for high-priority paths (e.g., payment processing at 10%, error responses at 100%), use X-Ray groups to organize traces by criteria (error, latency percentile), and implement tail-based sampling using OpenTelemetry Collector — sample 100% but only export traces that contain errors or exceed latency thresholds
C) Use CloudWatch Logs instead of X-Ray for tracing
D) Sample at 50% to reduce costs by half

**Correct Answer: B**
**Explanation:** Intelligent sampling reduces costs by 95%+ while improving signal quality: (1) Default 1% sampling with reservoir rule captures enough traces for statistical analysis of normal traffic; (2) 100% sampling for errors ensures every error is traced (critical for debugging); (3) Higher sampling for high-value paths (payments) provides more visibility where it matters; (4) Tail-based sampling (OpenTelemetry Collector) is the most sophisticated approach — it captures 100% of data temporarily, then decides what to export based on the complete trace (keeping only interesting traces like errors or high latency). Cost: from 300M segments to ~3-5M segments = ~$500-1,000/month (98% reduction). Option A loses all observability. Option C doesn't provide distributed tracing. Option D provides modest savings without focusing on important traces.

---

### Question 64
A company is running a serverless application using API Gateway, Lambda, and DynamoDB. They need to implement a canary deployment for a Lambda function that changes both the function code AND the DynamoDB table schema (adding a new GSI). The deployment must be atomic — users should either see the old code with old schema or new code with new schema, never mismatched. How should they implement this atomic deployment?

A) Deploy the Lambda code update and DynamoDB GSI simultaneously
B) The DynamoDB GSI addition and Lambda code change CANNOT be deployed atomically because GSI creation takes time (potentially hours for large tables). Instead, implement backward-compatible changes: Phase 1: Add the new GSI to DynamoDB (this can happen while the old Lambda code is running — GSI addition doesn't affect existing queries). Phase 2: Deploy the new Lambda function version that uses BOTH the old query pattern AND the new GSI. Phase 3: After validation, deploy a cleanup Lambda version that only uses the new GSI. This expand-contract pattern ensures compatibility at every stage. For the Lambda canary: use Lambda aliases with weighted routing (90% stable, 10% canary) during Phase 2.
C) Use API Gateway canary deployment to route 10% of traffic to the new version
D) Use DynamoDB Global Tables for the new schema alongside the old table

**Correct Answer: B**
**Explanation:** This is a trick question — true atomic deployment of schema + code changes isn't possible with DynamoDB GSIs. The expand-contract pattern provides the correct approach: (1) GSI creation is a long-running operation that can't be instant; (2) The new Lambda code must handle both the old and new query patterns during transition; (3) The expand phase (adding GSI + deploying dual-mode code) ensures compatibility; (4) The contract phase (removing old query pattern) cleans up after validation. Option A would fail because the GSI isn't ready when the new code deploys. Option C doesn't solve the schema timing issue. Option D creates unnecessary table duplication.

---

### Question 65
A company runs 1,000 EC2 instances across 10 regions. They need to ensure ALL instances have the latest security patches applied within 48 hours of patch release. Current patching is manual and takes 2 weeks. Which approach automates patching within the 48-hour SLA?

A) Create AMIs with patches and replace instances
B) AWS Systems Manager Patch Manager with: patch baselines defining approved patches and auto-approval rules (security patches auto-approved within 24 hours of release), maintenance windows scheduled per region (staggered to avoid simultaneous impact), patch groups targeting instances by tag (production, staging, dev), Rate Control ensuring no more than 10% of instances per patch group are patching simultaneously, integration with AWS Organizations for multi-account deployment, and pre/post patch Lambda hooks for application-level validation (stop services before patch, verify health after patch)
C) Use AWS Config to detect unpatched instances
D) Third-party patch management tool deployed on EC2

**Correct Answer: B**
**Explanation:** Systems Manager Patch Manager provides enterprise-grade automated patching: (1) Patch baselines with auto-approval rules ensure security patches are approved within 24 hours; (2) Maintenance windows schedule patching within the remaining 24 hours (total: 48 hours from release); (3) Patch groups enable targeting (patch dev first, then staging, then production); (4) Rate Control (10% at a time) prevents widespread impact if a patch causes issues; (5) Multi-account deployment via Organizations scales to 1,000 instances across 10 regions; (6) Pre/post hooks handle application-level concerns. Option A's AMI replacement is slower and more disruptive. Option C detects but doesn't remediate. Option D adds another tool to manage.

---

### Question 66
A company has an Aurora MySQL database where a developer accidentally ran DELETE FROM orders WHERE status = 'pending' without a WHERE clause limiting to test orders, deleting 500,000 production order records. The deletion happened 10 minutes ago. Aurora has point-in-time recovery enabled with a 7-day retention. What is the FASTEST way to recover the deleted records?

A) Restore the entire Aurora cluster to a point 11 minutes ago and switch the application to the restored cluster
B) Use Aurora's Backtrack feature (if enabled): backtrack the database to a point 11 minutes ago. Backtrack is faster than PITR because it doesn't create a new cluster — it rewinds the existing database in place. If Backtrack was not enabled, use PITR to restore to a new cluster, use mysqldump or SELECT INTO OUTFILE to extract the orders table from the restored cluster, then INSERT the recovered records back into the production database. Delete the temporary restored cluster.
C) Check the MySQL binary log and replay the INSERT statements
D) Retrieve the data from DynamoDB Streams (if the orders were mirrored)

**Correct Answer: B**
**Explanation:** Aurora Backtrack is the fastest recovery option: (1) If enabled, Backtrack rewinds the database to before the deletion in seconds-to-minutes, without creating a new cluster; (2) This is the fastest possible recovery — faster than PITR which creates a new cluster (10-30 minutes). If Backtrack isn't enabled (it must be configured during cluster creation): (1) PITR creates a new cluster at the point before deletion; (2) Extract the orders table from the restored cluster; (3) Insert records back into production; (4) This takes 30-60 minutes. Option A restores the entire cluster, losing the last 10 minutes of ALL changes (not just the accidental delete). Option C requires binary log access which may not be available. Option D assumes a mirroring setup that wasn't mentioned.

---

### Question 67 through Question 75
[Questions continue at maximum difficulty, covering: cross-service integration edge cases, specific numerical limits of AWS services, complex multi-account permission scenarios, advanced networking (IPv6 dual-stack, PrivateLink cross-account, Transit Gateway with multiple route tables), complex cost optimization calculations, hybrid cloud integration patterns, advanced security (SCP interaction with identity policies, permission boundaries with SCPs), and final comprehensive architecture design questions.]

### Question 67
A company uses AWS Organizations with 100 accounts. They have an SCP on the Production OU that denies all actions except from a specific list of approved services. A developer in a production account tries to create a Lambda function using an IAM role that has AdministratorAccess. The Lambda creation fails. Why?

A) AdministratorAccess isn't sufficient for Lambda
B) SCPs act as a permission boundary for the ENTIRE account. Even though the IAM role has AdministratorAccess (an identity policy that allows *), the SCP limits the effective permissions. If the SCP's deny-list approach doesn't include lambda:CreateFunction in the allowed services, the action is denied. SCPs apply to ALL principals in the account (except the management account's root user). The effective permission = intersection of SCP AND identity policy. To fix: add Lambda-related actions to the SCP's allowed services list for the Production OU.

**Correct Answer: B**
**Explanation:** This tests understanding of SCP-IAM interaction: (1) SCPs don't grant permissions — they restrict the maximum available permissions; (2) The effective permissions for any principal in an account are the intersection of the SCP permissions AND the identity-based permissions; (3) Even with AdministratorAccess (*), if the SCP doesn't allow lambda:CreateFunction, the action is denied; (4) This is by design — SCPs enforce organizational controls that individual accounts cannot override.

---

### Question 68
A company has a VPC with CIDR 10.0.0.0/16 and needs to add more IP addresses because they've exhausted the existing range. The VPC cannot be recreated. What should they do?

A) Create a new VPC with a larger CIDR and migrate resources
B) Add a secondary CIDR block to the existing VPC. AWS allows adding up to 5 IPv4 CIDR blocks (can be extended to 50 with a quota increase) to an existing VPC. Add a non-overlapping CIDR (e.g., 10.1.0.0/16), create new subnets in the secondary CIDR, and deploy new resources in the new subnets. Existing resources remain in the original CIDR. Route tables automatically include the secondary CIDR.
C) Use IPv6 to supplement IPv4 addresses
D) The VPC CIDR cannot be changed after creation

**Correct Answer: B**
**Explanation:** AWS allows adding secondary CIDR blocks to existing VPCs: (1) Up to 5 secondary IPv4 CIDR blocks by default (quota increase to 50); (2) Secondary CIDRs must not overlap with existing VPC CIDRs, peered VPC CIDRs, or on-premises networks; (3) New subnets can be created in the secondary CIDR; (4) Route tables automatically include routes for the secondary CIDR; (5) This is a non-disruptive operation — existing resources are unaffected. Option A is unnecessary with secondary CIDRs available. Option C adds IPv6 but doesn't help if applications need IPv4. Option D is incorrect — secondary CIDRs can be added.

---

### Question 69
A company needs to implement S3 Object Lambda to dynamically transform S3 objects during retrieval. The transformation adds a watermark to images. They expect 1,000 GET requests per second for transformed images. Each transformation takes 2 seconds on a Lambda function with 3GB memory. What is the MAXIMUM concurrency this workload will require, and how should the architect ensure the system can handle it?

A) 1,000 concurrent Lambda executions
B) The maximum concurrency = requests per second × processing time = 1,000 × 2 = 2,000 concurrent Lambda executions. This exceeds the default regional Lambda concurrent execution limit of 1,000. The architect must: request a concurrency limit increase to at least 2,500 (providing 25% headroom), configure a reserved concurrency for the S3 Object Lambda function to guarantee capacity, implement CloudFront in front of S3 Object Lambda Access Point to cache transformed images (reducing the actual request rate to Lambda), and set up CloudWatch alarms on Lambda throttling metrics.
C) 500 concurrent Lambda executions (Lambda scales gradually)
D) 2 concurrent Lambda executions (Lambda processes requests sequentially)

**Correct Answer: B**
**Explanation:** Concurrency calculation: 1,000 requests/sec × 2 seconds per request = 2,000 concurrent executions needed. Key considerations: (1) Default Lambda regional concurrency is 1,000 (or 3,000 in some regions) — this workload would be throttled; (2) Concurrency limit increase is required; (3) CloudFront caching dramatically reduces the actual concurrency needed — if images are cacheable, even a 50% cache hit rate halves the concurrency to 1,000; (4) Reserved concurrency guarantees this function's capacity. This tests understanding of the Little's Law relationship between throughput, latency, and concurrency in serverless systems.

---

### Question 70
A company is using AWS Config to monitor compliance across 200 accounts. Their Config bill is $80,000/month due to recording all resource types with all configuration changes. Only 20 resource types (out of 200+) are relevant for their compliance requirements. How should they optimize Config costs?

A) Disable Config in non-production accounts
B) Optimize Config recording: change from recording ALL resource types to recording ONLY the 20 relevant types (EC2, S3, RDS, IAM, Lambda, VPC, Security Groups, etc.), enable periodic recording instead of continuous recording for slowly-changing resources (IAM policies change rarely), use Config aggregator in a delegated admin account to view compliance across all 200 accounts from a single pane, remove custom Config rules that duplicate AWS managed rules, and use conformance packs to standardize rule deployment. This reduces Config items recorded by ~90%, proportionally reducing costs to ~$8,000/month.
C) Switch to AWS Trusted Advisor for compliance monitoring
D) Run Config evaluations less frequently

**Correct Answer: B**
**Explanation:** Config pricing is primarily based on configuration items recorded: (1) Recording only 20 relevant resource types (instead of 200+) reduces recorded items by ~90%; (2) Periodic recording for stable resources further reduces items; (3) Removing duplicate rules reduces evaluation costs; (4) Conformance packs standardize deployment, reducing management overhead. Cost: $80,000 × 0.10 = $8,000/month (90% savings). Option A loses compliance visibility in non-production accounts. Option C doesn't provide the same compliance monitoring depth. Option D's Config evaluation frequency is separate from recording.

---

### Question 71
A company operates a real-time bidding (RTB) platform that must respond to bid requests within 100ms. They currently use Application Load Balancer for routing. During latency analysis, they discover the ALB adds 5-15ms of latency for request processing. For their 100ms budget, this represents 5-15% overhead. How can they reduce load balancer latency?

A) Use CloudFront in front of the ALB
B) Replace the ALB with a Network Load Balancer (NLB): NLB operates at Layer 4 (TCP) with ~1-2ms of added latency (vs. ALB's 5-15ms at Layer 7), NLB provides static IP addresses and supports ultra-low latency routing, implement TLS termination at the NLB (TLS at Layer 4), and use target group health checks for backend monitoring. If Layer 7 features are needed (path-based routing, host-based routing), implement them in the application layer instead.
C) Increase the ALB's capacity by pre-warming it
D) Use Global Accelerator to route to the ALB more efficiently

**Correct Answer: B**
**Explanation:** For latency-sensitive applications, the load balancer choice matters: (1) ALB operates at Layer 7 (HTTP), parsing headers, cookies, and request bodies — 5-15ms overhead; (2) NLB operates at Layer 4 (TCP), simply routing packets — 1-2ms overhead; (3) Reducing from 5-15ms to 1-2ms recovers 3-13ms of the 100ms budget; (4) NLB provides static IP addresses useful for allow-listing; (5) The trade-off: losing ALB features (path routing, host routing, WAF integration) which must be implemented at the application level if needed. Option A adds another hop, increasing latency. Option C helps with throughput, not latency. Option D helps with client-to-AWS latency, not LB processing.

---

### Question 72
A company has a hybrid architecture with applications running on-premises and on AWS. They use AWS Transit Gateway to connect their on-premises data center via VPN. The on-premises network team reports that the VPN throughput is limited to 1.25 Gbps per tunnel, but they need 10 Gbps. How should they increase the VPN throughput?

A) Create more VPN connections to the same Transit Gateway (each VPN connection has 2 tunnels, each at 1.25 Gbps = 2.5 Gbps per VPN, 4 VPN connections = 10 Gbps) with ECMP (Equal Cost Multi-Path) routing enabled on the Transit Gateway to distribute traffic across all tunnels
B) Replace VPN with AWS Direct Connect for 10 Gbps dedicated bandwidth
C) Increase the VPN tunnel size
D) Use AWS Global Accelerator to improve VPN performance

**Correct Answer: A**
**Explanation:** Transit Gateway supports ECMP for VPN connections: (1) Each Site-to-Site VPN connection has 2 tunnels, each capable of 1.25 Gbps; (2) With ECMP enabled on Transit Gateway, traffic is distributed across all available VPN tunnels; (3) 4 VPN connections = 8 tunnels × 1.25 Gbps = 10 Gbps aggregate throughput; (4) ECMP distributes traffic based on the 5-tuple hash (source/dest IP, source/dest port, protocol); (5) This is a supported AWS configuration. Option B works but is more expensive and has longer provisioning time. Option C — VPN tunnel bandwidth is fixed at 1.25 Gbps. Option D doesn't increase VPN tunnel throughput.

---

### Question 73
A company wants to ensure that their AWS infrastructure changes are reviewed and approved before being applied. They use Terraform for infrastructure as code. A developer must not be able to apply Terraform changes directly — changes must go through a pull request and be approved by a senior engineer. Which approach enforces this workflow?

A) Remove Terraform apply permissions from developers
B) Implement a Terraform workflow with separation of duties: developers write Terraform code and create PRs, CI/CD pipeline runs terraform plan on PR creation (showing proposed changes), senior engineer reviews the plan output and approves the PR, on merge to main branch the CI/CD pipeline runs terraform apply using a service role (not developer credentials), SCPs restrict developers' IAM from directly calling infrastructure-modifying APIs (matching what Terraform would call), only the CI/CD pipeline's service role has apply permissions, and all Terraform state is stored in S3 with DynamoDB locking (preventing local state manipulation)
C) Use Terraform Cloud with Sentinel policies
D) Review Terraform state files for unauthorized changes

**Correct Answer: B**
**Explanation:** This implements GitOps-style infrastructure governance: (1) Developers can only modify infrastructure through code changes in git; (2) Terraform plan on PRs shows exactly what will change before approval; (3) Senior engineer review ensures changes are appropriate; (4) Only the CI/CD service role can apply changes, not individual developers; (5) SCPs prevent developers from making direct API calls that bypass Terraform; (6) S3 + DynamoDB state management prevents local state manipulation. Option C with Terraform Cloud/Sentinel is also valid but adds a third-party service. Option A alone doesn't provide the review workflow. Option D is reactive, not preventive.

---

### Question 74
A company needs to migrate a time-series database from InfluxDB (self-managed on EC2) to a managed AWS service. The database stores IoT sensor data: 100,000 data points per second ingestion, 1-second resolution, 2 years of historical data (500TB), and queries include: latest value per sensor, time-range aggregations (avg, min, max, sum), and downsampling. Which AWS service provides the best fit?

A) Amazon Timestream: purpose-built for time-series data with automatic tiering (in-memory for recent data, magnetic for historical), built-in time-series functions (interpolation, smoothing, approximation), automatic data lifecycle management, and support for 100K+ data points per second. Recent data retention in memory store for fast queries, historical data in magnetic store for cost-effective storage.
B) Amazon DynamoDB with time-based partition keys
C) Amazon Redshift for the analytics workload
D) Amazon OpenSearch with time-based indices

**Correct Answer: A**
**Explanation:** Amazon Timestream is specifically designed for this use case: (1) 100K data points/second ingestion is within Timestream's capabilities; (2) Automatic tiering — recent data in memory (fast queries), historical in magnetic (cost-effective); (3) Built-in time-series functions handle the aggregation and downsampling requirements; (4) Automatic data lifecycle management handles the 2-year retention; (5) SQL-compatible query interface makes migration easier. Option B's DynamoDB requires custom time-series logic. Option C's Redshift isn't optimized for time-series ingestion. Option D's OpenSearch works but requires more operational management for time-based index rotation.

---

### Question 75
A company has completed a comprehensive AWS Well-Architected Review and identified 50 high-risk findings across all 6 pillars. The CTO wants all findings remediated within 6 months. Given limited engineering resources, how should the architect prioritize the remediation effort?

A) Remediate findings in alphabetical order by pillar
B) Prioritize using a risk-based approach: categorize each finding by impact (data loss potential, security exposure, availability impact, financial impact) AND effort (hours to remediate, team dependencies, testing requirements), create a prioritization matrix: Quadrant 1 — high impact, low effort (quick wins, do first), Quadrant 2 — high impact, high effort (plan and execute next), Quadrant 3 — low impact, low effort (fill in between major efforts), Quadrant 4 — low impact, high effort (defer or accept risk), address Security pillar findings FIRST regardless of effort (reduce exposure window), use AWS Well-Architected Tool to track remediation progress, and schedule quarterly Well-Architected Reviews to prevent regression
C) Fix the easiest findings first to show quick progress
D) Address all findings simultaneously by assigning one to each team member

**Correct Answer: B**
**Explanation:** Risk-based prioritization maximizes the value of limited engineering time: (1) Impact × Effort matrix ensures the most critical issues are addressed first; (2) Security findings get priority regardless of effort — unaddressed security issues pose immediate organizational risk; (3) Quick wins (high impact, low effort) provide immediate risk reduction and demonstrate progress to the CTO; (4) Complex high-impact items are planned with proper resource allocation; (5) Low-impact, high-effort items are deferred — the effort may be better spent elsewhere; (6) Well-Architected Tool tracks progress systematically; (7) Quarterly reviews prevent regression. Option A ignores risk differences. Option C may miss critical high-effort findings. Option D spreads resources too thin.

---

## Answer Key

| Q# | Answer | Q# | Answer | Q# | Answer | Q# | Answer | Q# | Answer |
|----|--------|----|--------|----|--------|----|--------|----|--------|
| 1  | A,D,E  | 16 | B      | 31 | B      | 46 | B      | 61 | B      |
| 2  | C      | 17 | B      | 32 | B      | 47 | B      | 62 | B      |
| 3  | A,B,E  | 18 | B      | 33 | B      | 48 | B      | 63 | B      |
| 4  | B      | 19 | B      | 34 | B      | 49 | B      | 64 | B      |
| 5  | B      | 20 | B      | 35 | B      | 50 | B      | 65 | B      |
| 6  | B      | 21 | B      | 36 | B      | 51 | B      | 66 | B      |
| 7  | B      | 22 | B      | 37 | B      | 52 | B      | 67 | B      |
| 8  | B      | 23 | B      | 38 | A,B,C  | 53 | A      | 68 | B      |
| 9  | B      | 24 | B      | 39 | B      | 54 | B      | 69 | B      |
| 10 | B      | 25 | B      | 40 | B      | 55 | B      | 70 | B      |
| 11 | B      | 26 | B      | 41 | B      | 56 | A      | 71 | B      |
| 12 | B      | 27 | C      | 42 | B      | 57 | B      | 72 | A      |
| 13 | B      | 28 | B      | 43 | B      | 58 | B      | 73 | B      |
| 14 | B      | 29 | B      | 44 | B      | 59 | B      | 74 | A      |
| 15 | B      | 30 | B      | 45 | A,B,D  | 60 | B      | 75 | B      |
