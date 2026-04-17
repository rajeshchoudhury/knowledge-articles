# AWS Certified Solutions Architect - Professional (SAP-C02) Practice Test 35

## Mixed Comprehensive Exam - Hardest Difficulty (Tricky Scenarios, Multiple Valid Approaches)

**Time Limit: 180 minutes | 75 Questions | Passing Score: 75%**

---

### Question 1
A global financial services company runs a trading platform that processes 500,000 transactions per second during market hours. The platform uses a microservices architecture with 80 services deployed on EKS across us-east-1 and eu-west-1 (active-active). Each transaction must be processed within 10ms end-to-end. The company recently experienced data inconsistency during a 3-second network partition between regions, where both regions accepted conflicting trades for the same account. The architect must redesign the consistency model.

A) Implement synchronous cross-region replication for all trades to ensure strong consistency
B) Designate a "home region" per account based on the customer's geography, routing all writes for an account to its home region, with cross-region reads from DynamoDB Global Tables replicas
C) Use distributed locking with DynamoDB conditional writes across regions
D) Accept eventual consistency and implement post-hoc reconciliation for conflicts

**Correct Answer: B**
**Explanation:** At 500,000 TPS with 10ms latency requirements, synchronous cross-region replication (A) is physically impossible (cross-region latency alone is 30-100ms). Distributed locking (C) across regions adds unacceptable latency. The correct approach is data partitioning by account ownership: each account has a "home region" where all writes are processed, eliminating cross-region write conflicts. DynamoDB Global Tables replicate data asynchronously for cross-region reads (analytics, reporting). During a network partition, only the home region accepts writes for that account, preventing conflicts. Option D risks financial losses from conflicting trades that reconciliation can't always resolve.

---

### Question 2
A company migrates a legacy monolith to AWS. The monolith uses a 20 TB Oracle database with 500+ stored procedures, materialized views, and Oracle-specific features (CONNECT BY, analytic functions, flashback queries). The migration timeline is 6 months. The team has 2 DBAs with Oracle expertise but no AWS experience. The application serves 50,000 concurrent users.

What migration approach minimizes risk while meeting the timeline? (Select TWO)

A) Migrate to Aurora PostgreSQL using AWS SCT and DMS for a full replatforming
B) Use a lift-and-shift approach: migrate Oracle to RDS Oracle (same engine) with Multi-AZ, then plan a future replatforming to Aurora
C) Use AWS DMS with SCT to convert stored procedures to Lambda functions
D) Deploy Oracle on EC2 for full control over Oracle-specific features, with a future migration to RDS Oracle or Aurora
E) Migrate to DynamoDB for cost savings and scalability

**Correct Answer: B, D**
**Explanation:** With 500+ stored procedures, Oracle-specific features, and only 6 months: (B) RDS Oracle is the lowest-risk option—same database engine means zero stored procedure conversion, materialized views and flashback work as-is. Multi-AZ provides HA. The team's Oracle expertise transfers directly. (D) Oracle on EC2 provides maximum compatibility (every Oracle feature works) if specific features like RAC or custom patches are needed. The trade-off: more operational overhead than RDS. Both approaches enable a future replatforming to Aurora when the team has more time and AWS experience. Option A requires converting 500+ stored procedures (6 months isn't enough). Option C is impractical for complex PL/SQL. Option E would require a complete application rewrite.

---

### Question 3
A company runs a SaaS application serving 10,000 tenants. Each tenant's data is stored in a shared Amazon Aurora MySQL cluster. A large enterprise customer demands dedicated database isolation for compliance reasons, while the other 9,999 tenants are fine with the shared model. The current schema uses tenant_id as a discriminator column. The architect must accommodate the enterprise customer without disrupting the existing tenants.

A) Migrate all tenants to separate Aurora clusters (silo model) for consistency
B) Create a dedicated Aurora cluster for the enterprise customer, implement a routing layer (using API Gateway + Lambda) that directs the enterprise customer's queries to their dedicated cluster while all others go to the shared cluster, and use DMS for initial data migration
C) Use Aurora MySQL read replicas to separate the enterprise customer's read traffic
D) Use DynamoDB with a separate table for the enterprise customer

**Correct Answer: B**
**Explanation:** A hybrid multi-tenant model (bridge pattern) accommodates both: (1) Enterprise customer gets their own Aurora cluster (meeting compliance), data migrated from the shared cluster using DMS with the tenant_id filter. (2) A routing layer (Lambda or application config) inspects the tenant context and routes database connections to the appropriate cluster. (3) The remaining 9,999 tenants continue on the shared cluster, unaffected. (4) The application code changes minimally—just the connection routing logic. Option A is a massive over-migration that's unnecessary for one customer. Option C doesn't provide write isolation. Option D changes the database technology entirely.

---

### Question 4
A company runs a machine learning inference pipeline on SageMaker real-time endpoints. The models serve 10,000 predictions per second with a P99 latency SLA of 100ms. During a new model deployment, the company experienced a 15-minute performance degradation (P99 increased to 500ms) because the new model version had a memory leak. The architect must implement a safer deployment strategy.

A) Use SageMaker blue/green deployment with automatic rollback triggered by CloudWatch alarm on P99 latency exceeding 100ms during the canary phase
B) Deploy the new model as a separate endpoint and manually switch traffic
C) Use SageMaker A/B testing (production variants) with 10% traffic on the new model, but without automatic rollback
D) Test thoroughly in staging and deploy directly to production

**Correct Answer: A**
**Explanation:** SageMaker deployment guardrails with blue/green deployment provide the safest model updates: (1) The new model deploys as the "green" fleet behind the same endpoint. (2) A canary phase routes a small percentage of traffic (e.g., 5%) to the new model. (3) CloudWatch alarm monitors P99 latency during the canary phase. (4) If P99 exceeds 100ms, the deployment automatically rolls back to the "blue" fleet within seconds—no 15-minute degradation. (5) If the canary phase passes, traffic shifts gradually to the green fleet. This provides automated, metric-driven rollback. Option B requires manual intervention. Option C lacks automatic rollback. Option D doesn't protect against production issues like memory leaks.

---

### Question 5
A media company stores 5 PB of video content in S3 Standard. Analytics show: 10% is accessed daily (hot), 25% is accessed monthly (warm), 40% is accessed yearly (cold), and 25% hasn't been accessed in 3+ years (archive). The current monthly S3 cost is $115,000. The architect must optimize storage costs. Calculate the estimated monthly savings.

A) Move to S3 Intelligent-Tiering for all data, saving approximately 30% (~$34,500/month)
B) Implement lifecycle policies: hot (S3 Standard, 500 TB), warm (S3 Standard-IA, 1.25 PB), cold (S3 Glacier Instant Retrieval, 2 PB), archive (S3 Glacier Deep Archive, 1.25 PB). Estimated monthly cost: ~$25,000. Savings: ~$90,000/month
C) Move everything to S3 Glacier for maximum savings
D) Use S3 One Zone-IA for all infrequently accessed data

**Correct Answer: B**
**Explanation:** Current cost: 5 PB × $0.023/GB = $115,000/month. Optimized tiering:
- **Hot (500 TB, S3 Standard)**: 500 TB × $0.023 = $11,500
- **Warm (1.25 PB, S3 Standard-IA)**: 1.25 PB × $0.0125 = $15,625
- **Cold (2 PB, Glacier Instant Retrieval)**: 2 PB × $0.004 = $8,000
- **Archive (1.25 PB, Glacier Deep Archive)**: 1.25 PB × $0.00099 = $1,237
- **Total**: ~$36,362/month (plus retrieval costs)
- **Savings**: ~$78,638/month (68% reduction)

The actual savings depend on retrieval patterns and costs, but lifecycle policies provide the greatest optimization. Option A provides automatic tiering but doesn't use Glacier tiers for the coldest data. Option C makes daily-accessed data retrieval too slow/expensive. Option D reduces durability for a small savings.

---

### Question 6
A company has an API that receives 100,000 requests per minute. Each request generates a 2 KB event that must be: (1) stored for 7 years for compliance, (2) available for real-time analytics, (3) searchable for ad-hoc investigations, and (4) processed by 3 downstream consumers. The architect must design the most cost-effective architecture.

A) API Gateway → Kinesis Data Streams → Lambda (fan-out to 3 consumers) + Firehose → S3 (archive) + OpenSearch (search) → S3 Glacier lifecycle
B) API Gateway → SQS → Lambda → DynamoDB (real-time) + S3 (archive) → Athena (search)
C) API Gateway → EventBridge → 3 Lambda consumers + archive rule → S3 via Firehose → Athena for search. S3 lifecycle to Glacier Deep Archive after 90 days.
D) API Gateway → Kinesis Data Streams (enhanced fan-out for 3 consumers) + Firehose → S3 (Parquet, partitioned) → Athena for search + QuickSight for analytics. S3 lifecycle to Glacier Deep Archive after 90 days.

**Correct Answer: D**
**Explanation:** Cost optimization analysis at 100K requests/minute = 144M events/day = 288 GB/day:

**Option D breakdown**: Kinesis (1 stream, ~200 shards on-demand ≈ $300/day), Firehose to S3 Parquet ($0.035/GB × 288 GB ≈ $10/day), S3 Standard first 90 days then Glacier Deep Archive. 3 enhanced fan-out consumers. Athena for ad-hoc queries ($5/TB scanned, Parquet reduces to ~60 GB/day). Total ≈ ~$350/day.

**vs Option A**: OpenSearch adds $500+/day for this volume.
**vs Option C**: EventBridge at 144M events × $1/M = $144/day just for routing + same S3/Athena costs ≈ $175/day + consumer costs. Actually competitive.

Option D is the most balanced: Kinesis handles the 100K/min throughput reliably, Firehose creates query-optimized Parquet files in S3, Athena provides cost-effective search, and Glacier Deep Archive handles 7-year retention cheaply.

---

### Question 7
A company runs a legacy application on a fleet of Windows Server 2012 R2 EC2 instances. Windows Server 2012 R2 is end of life and no longer receives security patches. The application requires this specific Windows version due to a .NET Framework 3.5 dependency that cannot be upgraded. The architect must address the security risk while keeping the application running.

A) Upgrade to Windows Server 2022 and port the .NET Framework 3.5 application
B) Keep running Windows Server 2012 R2 behind an ALB with AWS WAF, place instances in private subnets with no internet access (all patching through WSUS internally), use Amazon Inspector for vulnerability assessment, implement AWS Systems Manager for hardened configuration baselines, and plan a containerization migration to ECS with .NET Framework 3.5 on Windows containers
C) Migrate to Linux and rewrite the application
D) Use AWS End of Support Migration Program (EMP) to migrate the Windows application to a newer OS without code changes

**Correct Answer: B**
**Explanation:** For a legacy OS dependency that can't be immediately resolved, a defense-in-depth approach: (1) **WAF** protects against web attacks targeting known Windows Server 2012 vulnerabilities. (2) **Private subnets** with no internet access minimizes attack surface. (3) **Inspector** identifies known vulnerabilities for risk awareness. (4) **SSM** hardens configurations (disable unnecessary services, enforce security baselines). (5) **Windows containers on ECS** can run .NET Framework 3.5 on newer base images, providing a migration path. Option A may break the application's .NET 3.5 dependency. Option C requires a complete rewrite. Option D (EMP) is designed for exactly this scenario and is actually a strong alternative—it creates a compatibility layer allowing the application to run on newer Windows versions without code changes.

---

### Question 8
A company has a complex CI/CD pipeline that deploys to 5 AWS regions simultaneously. A recent deployment introduced a bug that caused a cascading failure across all regions within 8 minutes. The architect must redesign the deployment strategy to prevent global failures.

A) Deploy to all 5 regions simultaneously but with better testing
B) Implement a progressive deployment: deploy to one region first (canary region), monitor for 30 minutes with automated health checks, then deploy to a second region, and finally deploy to the remaining 3 regions. Each stage has automated rollback triggered by CloudWatch alarms on error rate and latency.
C) Deploy to all regions with blue/green deployments per region
D) Use feature flags to enable the new code gradually

**Correct Answer: B**
**Explanation:** Progressive multi-region deployment prevents global cascading failures: (1) **Wave 1 (canary)**: Deploy to one region (e.g., ap-southeast-2—lowest traffic). Monitor for 30 minutes. Automated alarms check error rate, latency, and business metrics. If issues detected, automatic rollback—only one region affected. (2) **Wave 2**: Deploy to a second region. Monitor again. (3) **Wave 3**: Deploy to remaining 3 regions in parallel. Each wave has a "bake time" with automated health checks. Maximum blast radius is limited to one region at a time. Option A repeats the same mistake. Option C deploys everywhere simultaneously, still risking global failure. Option D is complementary but doesn't address deployment blast radius.

---

### Question 9
A company runs an e-commerce platform with seasonal traffic (10x during Black Friday). Current architecture: ALB → ECS Fargate → Aurora MySQL. During last year's Black Friday, Aurora hit the maximum connection limit (5,000 connections), causing failed requests. The current setup uses 200 Fargate tasks, each maintaining 25 database connections.

A) Increase Aurora instance size to support more connections
B) Implement Amazon RDS Proxy between ECS and Aurora to pool and multiplex database connections, reducing the number of connections Aurora needs to handle while supporting thousands of Fargate task connections
C) Switch to Aurora Serverless v2 for automatic scaling
D) Implement read replicas to distribute read traffic

**Correct Answer: B**
**Explanation:** The root cause is connection exhaustion: 200 tasks × 25 connections = 5,000 connections hitting Aurora's limit. During Black Friday, tasks scale to 2,000+ requiring 50,000+ connections. **RDS Proxy** solves this by: (1) Connection pooling—hundreds of Fargate task connections share a smaller number of database connections. (2) Connection multiplexing—idle task connections don't consume Aurora connections. (3) RDS Proxy can handle millions of client connections while maintaining only a few hundred actual database connections. (4) Added benefit: failover handling during Aurora failover. Option A has limits and doesn't scale to 50,000 connections. Option C—Aurora Serverless v2 auto-scales compute but still has connection limits. Option D helps with read traffic but writes still hit the connection limit.

---

### Question 10
A company processes insurance claims using a Step Functions workflow with 20 states. The workflow includes: document ingestion, OCR processing, data extraction, rules evaluation, fraud detection (ML model), human review, approval, and payment processing. The average execution time is 3 days due to human review. They process 50,000 claims per day. The current Step Functions cost is $75,000/month (50K × 20 transitions × 30 days × $0.025/1000). The architect must reduce costs by 50%.

A) Migrate to SQS-based orchestration to eliminate Step Functions costs
B) Restructure the workflow into two Step Functions executions: an Express Workflow for the automated steps (ingestion through fraud detection—completes in 2 minutes), and a Standard Workflow for human review and payment processing (uses callback pattern—minimal state transitions during the 3-day wait)
C) Reduce the number of states by combining Lambda functions
D) Use Step Functions Local for testing and reduce production transitions

**Correct Answer: B**
**Explanation:** Cost optimization by splitting the workflow: **Express Workflow** (automated steps, ~12 states, 2 minutes): 50K executions/day × 30 days = 1.5M executions × ~2 minutes × 64 MB ≈ $8/month. **Standard Workflow** (human review + payment, ~8 states but only 3-4 transitions due to callback pattern): the callback pattern pauses at human review with zero state transitions during the wait. Transitions: 50K × 4 transitions × 30 = 6M × $0.025/1000 = $150/month. **Total: ~$158/month** (vs. $75,000/month). That's a 99.8% reduction, far exceeding the 50% target. The key insight is that the callback pattern eliminates the 3-day wait from costing anything in Step Functions. Option A loses orchestration benefits. Option C has limited impact. Option D only affects testing.

---

### Question 11
A company has a multi-account architecture with 200 accounts. They need to deploy a security baseline (Config rules, GuardDuty, Security Hub, IAM Access Analyzer, and CloudTrail) to all accounts. New accounts must automatically receive this baseline. The architect has 2 weeks to implement this. What is the fastest reliable approach?

A) Write custom scripts to configure each account
B) Use AWS Control Tower to set up the landing zone, which automatically deploys CloudTrail and Config. Use Control Tower Customizations (CfCT) to add GuardDuty, Security Hub, and IAM Access Analyzer via CloudFormation StackSets triggered by Control Tower lifecycle events
C) Use AWS CloudFormation StackSets with service-managed permissions to deploy all security services across all accounts in the organization, triggered by CreateAccount lifecycle events via EventBridge
D) Manually configure each account using the AWS console

**Correct Answer: C**
**Explanation:** With 200 existing accounts and a 2-week timeline, CloudFormation StackSets with service-managed permissions is the fastest approach: (1) StackSets with service-managed permissions automatically deploy to all accounts in the organization (including existing 200). (2) The StackSet template configures: GuardDuty member enrollment, Security Hub member enrollment, IAM Access Analyzer, Config rules, and CloudTrail. (3) Automatic deployment to new accounts is configured via StackSet's "Automatic deployment" feature or EventBridge rule on CreateAccount events. Option B (Control Tower) is the best long-term solution but setting up Control Tower for 200 existing accounts takes longer than 2 weeks (enrollment of existing accounts is complex). Option A is error-prone. Option D is impossible in 2 weeks for 200 accounts.

---

### Question 12
A company operates a global CDN-backed website. They recently experienced a DDoS attack that reached 500 Gbps, targeting both their CloudFront distribution and the origin ALB directly (bypassing CloudFront). CloudFront absorbed the CDN-layer attack, but the direct-to-origin attack caused an outage. The architect must prevent origin bypass attacks.

A) Enable AWS Shield Advanced on both CloudFront and the ALB
B) Restrict the ALB security group to only allow inbound traffic from CloudFront IP ranges (published by AWS and updated automatically via Lambda), configure a custom header secret shared between CloudFront and ALB (CloudFront adds it, ALB checks it via a WAF rule), and enable Shield Advanced on CloudFront
C) Use AWS WAF on the ALB to block DDoS traffic
D) Move the origin to a private subnet behind a Network Load Balancer

**Correct Answer: B**
**Explanation:** Multi-layer origin protection: (1) **CloudFront IP restriction**: The ALB security group allows inbound only from CloudFront IP ranges (AWS publishes these). A Lambda function subscribes to the AWS IP range change SNS topic and updates the security group automatically. This blocks direct-to-origin attacks that don't come through CloudFront. (2) **Shared secret header**: CloudFront custom origin header (e.g., `X-Origin-Verify: <secret>`) is checked by an ALB WAF rule—requests without the correct header are blocked. This prevents attackers who discover the origin IP from spoofing CloudFront source IPs. (3) **Shield Advanced on CloudFront**: DDoS mitigation for the CDN layer. Together, these ensure only CloudFront can reach the origin. Option A doesn't prevent direct-to-origin traffic. Option C can't stop volumetric attacks at the ALB. Option D still needs IP restrictions.

---

### Question 13
A company uses a data lake on S3 with AWS Glue for ETL and Athena for queries. Their data science team complains that Athena queries on a 50 TB table take 30+ minutes because the data is stored in JSON format without partitioning. The table receives 100 GB of new data daily. The architect must reduce query time to under 1 minute for typical analytical queries.

A) Increase Athena DPU capacity
B) Convert the existing data to Apache Parquet format with Snappy compression, partition by date (year/month/day), and use Athena partition projection. Implement a daily Glue job that converts new daily JSON data to Parquet. Add bucketing on frequently queried columns.
C) Migrate from Athena to Amazon Redshift for faster queries
D) Use S3 Select for filtering data before Athena scans it

**Correct Answer: B**
**Explanation:** Query optimization breakdown for 50 TB table:
- **JSON → Parquet**: 10x compression (50 TB → 5 TB), plus columnar format means only queried columns are read (additional 5-10x reduction for typical queries selecting few columns). Net: 50 TB scan → ~500 GB-1 TB.
- **Partitioning by date**: Most queries filter by date range. Partition pruning eliminates scanning unneeded dates. For a query on one month: ~3 TB / 12 months ≈ ~250 GB per month → ~25 GB in Parquet.
- **Partition projection**: Eliminates Glue catalog lookup latency for partition discovery.
- **Bucketing on key columns**: Further reduces scan for filtered queries.

Result: 25 GB scan at Athena's throughput (~100 GB/second distributed) = sub-second. At $5/TB: $0.125 per query. Option A—Athena doesn't have user-configurable DPU. Option C is more expensive and complex. Option D doesn't help with the fundamental format and partitioning issues.

---

### Question 14
A company has a critical application with the following availability requirement: 99.999% uptime (5.26 minutes downtime per year). The application is currently deployed in two regions (active-active) achieving 99.99%. The architect must design for 99.999%.

A) Add a third active region to improve availability
B) Implement multi-region active-active across 3 regions with: Global Accelerator (anycast IP routing), DynamoDB Global Tables (multi-active data), ECS with cross-region service discovery, Route 53 ARC for routing controls, automated health-based routing, and cell-based architecture where each region operates independently. Accept that 99.999% is the theoretical maximum for a cloud-based system.
C) Deploy in all AWS regions for maximum redundancy
D) Use dedicated hosts in 2 regions for hardware-level isolation

**Correct Answer: B**
**Explanation:** Achieving 99.999% requires: (1) **Three active regions**: If each region has 99.9% independent availability, three regions: 1 - (0.001)³ = 99.9999999% theoretical. But dependencies and failover mechanisms reduce this. (2) **Cell-based architecture**: Each region is a fully independent cell with no cross-region dependencies during normal operation. (3) **Global Accelerator**: TCP-level routing with health checks provides faster failover than DNS (seconds vs minutes). (4) **DynamoDB Global Tables**: Multi-active data replication eliminates database failover time. (5) **Route 53 ARC**: Safety rules prevent misroutes. (6) **Automated, tested failover**: No human intervention. Real-world caveat: global AWS services (IAM, Route 53 itself) create shared dependencies. True 99.999% requires accepting some risk from shared global infrastructure. Option C adds complexity without proportional benefit. Option D doesn't address regional failures.

---

### Question 15
A company has a monolithic application that writes to a single RDS PostgreSQL database. The application performs 8,000 write transactions per second. They need to add real-time analytics, full-text search, and event-driven notifications without modifying the monolith's database code. The architect must design a change data capture (CDC) solution.

A) Add application-level event publishing alongside database writes
B) Use AWS DMS with CDC from RDS PostgreSQL → Kinesis Data Streams, then fan out: Kinesis → Lambda → DynamoDB (real-time analytics), Kinesis → Lambda → OpenSearch (full-text search), Kinesis → Lambda → EventBridge (notifications)
C) Use RDS event notifications for real-time updates
D) Use pg_logical replication to a second PostgreSQL database for analytics

**Correct Answer: B**
**Explanation:** CDC without modifying the monolith: (1) **DMS with CDC** reads the PostgreSQL WAL (Write-Ahead Log) and streams changes to Kinesis Data Streams. The monolith is completely unaware. (2) **Kinesis fan-out**: Multiple consumers process the stream independently: (a) Lambda → DynamoDB for real-time analytics dashboards, (b) Lambda → OpenSearch for full-text search indexing, (c) Lambda → EventBridge for event-driven notifications to downstream systems. (3) This is the "outbox via CDC" pattern—the database's WAL serves as the outbox. At 8,000 TPS, Kinesis with sufficient shards handles the throughput. Option A requires modifying the monolith (explicitly prohibited). Option C provides administrative events, not data changes. Option D only replicates to another PostgreSQL, not to the needed destinations.

---

### Question 16
A company runs 1,000 Lambda functions in production. They discover that 15% of functions use the Python 2.7 runtime (deprecated), 10% have over-provisioned memory (256 MB allocated, only using 64 MB), and 5% have security vulnerabilities in their dependencies. The architect must remediate all three issues efficiently across 1,000 functions.

A) Fix each function individually by its owning team
B) Use a combination of: (1) AWS Config custom rule to identify Python 2.7 functions and auto-remediate by updating the runtime (with testing), (2) AWS Compute Optimizer to identify over-provisioned functions and right-size memory allocations, (3) Amazon Inspector for Lambda to scan dependencies for vulnerabilities and generate findings, (4) Automate remediation via a Step Functions workflow that updates configurations and triggers redeployments through CI/CD pipelines
C) Redeploy all functions from scratch
D) Use Lambda Layers to update runtimes and dependencies

**Correct Answer: B**
**Explanation:** Systematic remediation at scale: (1) **Python 2.7 identification**: Config custom rule flags all functions using the deprecated runtime. Auto-remediation updates the runtime configuration, but crucially, changes must be tested (trigger CI/CD pipeline to test and redeploy each function). (2) **Memory optimization**: Compute Optimizer analyzes CloudWatch metrics for each function and recommends optimal memory. Batch update memory configurations via Lambda API. (3) **Vulnerability remediation**: Inspector Lambda scanning identifies vulnerable packages with specific CVEs and remediation guidance. Teams update dependencies and redeploy. (4) **Orchestration**: Step Functions manages the remediation workflow: identify → categorize → remediate → verify → report. Option A doesn't scale. Option C is wasteful. Option D helps with shared dependencies but doesn't address runtime or memory.

---

### Question 17
A company's application uses DynamoDB with on-demand capacity. Monthly bill: $50,000. After analysis: read consumption is stable at 50,000 RCUs, write consumption is stable at 25,000 WCUs during business hours (12 hours/day), dropping to 5,000 RCUs / 2,000 WCUs overnight. Weekend traffic is 20% of weekday. Calculate the savings from switching to provisioned capacity with auto-scaling and reserved capacity.

A) Provisioned with auto-scaling saves ~30% ($15,000/month)
B) Provisioned with reserved capacity (1-year, no upfront) saves ~50% ($25,000/month)
C) Provisioned capacity with reserved capacity for baseline + auto-scaling for bursts saves ~60-70% (~$30,000-35,000/month)
D) On-demand is already the cheapest option for this variable workload

**Correct Answer: C**
**Explanation:** Cost analysis:

**On-demand current**: $50,000/month (given).

**Provisioned strategy**:
- **Reserved capacity** (1-year) for the baseline: 5,000 RCUs + 2,000 WCUs (overnight minimum). Reserved pricing: ~$0.000046/RCU-hour, ~$0.000232/WCU-hour. Monthly: ~$1,656 + $3,340 = ~$4,996/month for always-on baseline.
- **Auto-scaling** handles the variable portion: peaks at 50,000 RCUs / 25,000 WCUs during business hours. Only provisioned when needed.
- Provisioned pricing for variable capacity: ~$0.00013/RCU-hour, ~$0.00065/WCU-hour.
- Business hours (12h × 22 weekdays + 12h × 8 weekend-equivalent): ~45,000 additional RCUs for ~264 hours + proportional WCUs.

The combination of reserved baseline + auto-scaling for peaks typically saves 60-70% compared to on-demand for predictable, time-based patterns. Option D is wrong—on-demand is most expensive for predictable workloads.

---

### Question 18
A company has a microservices application where Service A calls Service B synchronously via HTTP. Service B takes 2 seconds to respond. When Service B experiences latency spikes (10+ seconds), Service A's thread pool is exhausted waiting for responses, causing Service A to fail as well (cascading failure). The architect must implement resilience patterns.

A) Increase Service A's timeout to 30 seconds
B) Implement the circuit breaker pattern in Service A: set a 3-second timeout for Service B calls, track failure rate, and when failures exceed 50% over 10 seconds, "open" the circuit (return a fallback response immediately without calling Service B). After 30 seconds, allow one test request through (half-open state). If it succeeds, close the circuit.
C) Add a load balancer between Service A and Service B
D) Scale Service B to handle more traffic

**Correct Answer: B**
**Explanation:** The circuit breaker pattern prevents cascading failures: (1) **Timeout**: 3 seconds (slightly above normal 2s) prevents threads from being held indefinitely. (2) **Failure tracking**: When >50% of requests fail in a 10-second window, the circuit opens. (3) **Open state**: Service A immediately returns a fallback response (cached data, default value, degraded experience) without calling Service B, preserving Service A's thread pool. (4) **Half-open**: After 30 seconds, allow one test request. If Service B recovered, close the circuit and resume normal operation. This is typically implemented with libraries like Resilience4j, Hystrix, or AWS App Mesh with Envoy's circuit breaking. Option A makes the cascading failure worse. Option C doesn't prevent timeout-based thread exhaustion. Option D doesn't help during latency spikes.

---

### Question 19
A company operates in a highly regulated industry and discovers that their AWS account root user has no MFA configured, has active access keys, and was last used 6 months ago to make console changes. The security audit flags this as a critical finding. What immediate and long-term actions should the architect recommend? (Select THREE)

A) Enable MFA on the root account using a hardware MFA device stored in a secure location (safe deposit box)
B) Delete the root account access keys
C) Create an IAM admin user for daily operations and stop using root
D) Change the root account email to a distribution list monitored by the security team
E) Disable the root account entirely

**Correct Answer: A, B, D**
**Explanation:** Critical root account security: (A) **Hardware MFA**: Root accounts should use hardware MFA (YubiKey or similar) stored in a physically secure location. Hardware MFA is more secure than virtual MFA for root. (B) **Delete access keys**: Root should never have programmatic access keys. Delete them immediately—no AWS operation requires root access keys. (D) **Distribution list email**: The root account email should be a monitored security distribution list (e.g., aws-root@company.com), not a personal email. This ensures multiple security team members receive root account notifications and password reset capability. Option C is correct practice but not as urgent as A, B, D. Option E—AWS root accounts cannot be disabled; they're needed for specific account-level operations.

---

### Question 20
A company runs a real-time bidding platform on EC2 instances. They need to process bids within 10ms. The current bottleneck is network latency between their application instances and an ElastiCache Redis cluster (0.5ms average but 5ms P99 due to network jitter). The architect must reduce P99 network latency.

A) Use a larger ElastiCache instance type
B) Deploy the application EC2 instances and ElastiCache nodes in a cluster placement group within the same AZ, and use enhanced networking (ENA) for maximum network performance
C) Use DAX instead of ElastiCache for caching
D) Implement client-side caching to eliminate network calls

**Correct Answer: B**
**Explanation:** Network latency optimization: (1) **Cluster placement group**: Places EC2 and ElastiCache instances physically close together in the same rack or adjacent racks, minimizing network hops. (2) **Same AZ**: Eliminates cross-AZ network traversal. (3) **Enhanced Networking (ENA)**: Provides higher bandwidth, higher PPS (packets per second), and lower jitter. This reduces P99 from 5ms to sub-1ms. The combination of placement group + same AZ + ENA is the standard approach for latency-sensitive workloads. Option A doesn't reduce network latency. Option C (DAX) is for DynamoDB, not general caching. Option D eliminates network calls but stale cache is a problem for real-time bidding.

---

### Question 21
A company runs a data warehouse on Amazon Redshift (50 nodes, ra3.4xlarge). Monthly cost: $120,000. Usage analysis shows: queries run between 6 AM - 10 PM (16 hours/day), the cluster is idle overnight, and weekend usage is 30% of weekday. The architect must reduce costs without impacting query performance.

A) Use Redshift Serverless which charges only for active queries
B) Implement Redshift pause/resume: pause the cluster overnight (10 PM - 6 AM) and schedule resume before business hours, saving 33% on compute. Additionally, evaluate Redshift reserved nodes (1-year, no upfront) for the active hours.
C) Reduce the cluster to 25 nodes
D) Migrate to Athena for all queries

**Correct Answer: B**
**Explanation:** Cost optimization: (1) **Pause/resume**: Pausing from 10 PM - 6 AM (8 hours) saves 33% compute cost. On weekends, pause for longer periods (run 8 hours instead of 16). Savings: ~$120K × 35% ≈ $42,000/month. (2) **Reserved nodes** (1-year, no upfront): ~35% discount on the remaining active hours. On the reduced cost base ($78K): 35% × $78K ≈ $27,300 additional savings. **Total savings: ~$69,000/month (58%)**. Option A (Serverless) charges per RPU-hour used, which could be cheaper or more expensive depending on query patterns—need to analyze. For consistent 16-hour daily usage with 50 nodes of queries, provisioned is likely cheaper. Option C reduces query performance. Option D requires re-engineering all queries.

---

### Question 22
A company has an S3 bucket receiving 50,000 PutObject requests per second during peak. Each object is 100 KB. They need to process each object immediately after upload (within 1 second). The current architecture uses S3 Event Notifications → SQS → Lambda, but at 50,000 events/second, they're hitting SQS throughput limits and Lambda concurrency limits. What should the architect redesign?

A) Use S3 Event Notifications → SNS → Multiple SQS queues for parallel processing
B) Use S3 Event Notifications → EventBridge → Lambda
C) Replace S3 Event Notifications → SQS with S3 Event Notifications → Kinesis Data Streams (as the destination), then use Lambda with Kinesis event source mapping with parallelization factor for high-throughput consumption
D) Use S3 Batch Operations for processing

**Correct Answer: C**
**Explanation:** At 50,000 objects/second: SQS Standard can handle this throughput but Lambda's concurrent execution is the bottleneck (default 1,000, even 10,000 may not be enough). **Kinesis Data Streams** provides: (1) S3 can send event notifications to Amazon EventBridge, which routes to Kinesis. (2) Kinesis handles 50,000 records/second across multiple shards (50 shards at 1,000 records/second each). (3) Lambda's Kinesis event source mapping with **parallelization factor** (up to 10 per shard) creates up to 500 concurrent Lambda invocations, each processing batches of ~100 events. (4) This handles the volume within Lambda concurrency limits while maintaining sub-second processing. Option A still hits Lambda concurrency limits. Option B—EventBridge has a throughput limit per account. Option D is for batch processing, not real-time.

---

### Question 23
A company has a critical dependency on a third-party API that has a rate limit of 100 requests/second and 99.9% availability. The company's application needs to make 500 requests/second to this API. The architect must design a solution that handles the rate limit and provides resilience against API unavailability.

A) Queue requests in SQS and process at 100/second using Lambda with reserved concurrency
B) Implement an API caching layer with ElastiCache: cache API responses with a TTL matching data freshness requirements. For cache misses, use a token bucket rate limiter (implemented with Redis INCRBY + EXPIRE) that limits outbound API calls to 100/second. Queue excess requests in SQS for processing during lower-traffic periods. Implement a circuit breaker for API unavailability.
C) Use API Gateway with caching and throttling as a proxy
D) Negotiate a higher rate limit with the third-party

**Correct Answer: B**
**Explanation:** Multi-layer resilience for API dependency: (1) **Caching**: If 60% of 500 requests/second hit the same data (common in practice), caching reduces actual API calls to 200/second. With a short TTL (e.g., 30 seconds), data stays fresh. (2) **Rate limiter**: Redis-based token bucket limits outbound calls to exactly 100/second. Requests exceeding the rate go to SQS for deferred processing. (3) **SQS queue**: Absorbs traffic bursts. During low-traffic periods (nights/weekends), queued requests are processed against the rate limit. (4) **Circuit breaker**: When the API is down, stop making calls (save the rate limit), serve from cache if possible, queue for later, return degraded results if not. This handles both the rate limit (5x over) and availability (0.1% downtime). Option A only handles rate limiting, not caching. Option C proxies but doesn't add caching logic. Option D may not be possible.

---

### Question 24
A company runs 500 EC2 instances across 10 accounts. They need to implement automated patching that: patches all instances within 72 hours of patch release, doesn't cause downtime for production, and provides compliance reporting. What should the architect design?

A) Use SSM Patch Manager with maintenance windows, patch groups, and scan/install operations
B) Implement AWS Systems Manager Patch Manager with: (1) patch baselines per OS (auto-approve critical/security patches after 3 days), (2) patch groups tagged by environment (production, staging, dev), (3) maintenance windows: dev patches first (day 1), staging (day 2), production with rolling updates (day 3)—production instances patched in batches with ALB health checks ensuring availability, (4) State Manager associations for compliance scanning, (5) compliance reporting via Config and Systems Manager Explorer
C) Use AMI-based patching: create new patched AMIs and replace instances
D) Use a third-party patching tool

**Correct Answer: B**
**Explanation:** Comprehensive patching strategy: (1) **Patch baselines**: Auto-approve critical/important patches after 72-hour review period. Custom baselines per OS (Windows, Amazon Linux, Ubuntu). (2) **Rolling deployment**: Production instances patched in batches (e.g., 10% at a time). ALB deregisters the target, patches are applied, instance rejoins the target group. Zero downtime. (3) **Progressive deployment**: Dev → Staging → Production catches patch-related issues before production. (4) **Compliance scanning**: Daily scan-only operations report patch status without installing. (5) **Organization-wide**: Deploy across all 10 accounts via Systems Manager Organization. (6) **Reporting**: SSM Compliance dashboard + Config rules verify patch compliance. Option A is a subset of B. Option C works but is slow for 500 instances and requires instance replacement. Option D adds external dependency.

---

### Question 25
A company has a hybrid architecture with on-premises data centers connected to AWS via Direct Connect. They're experiencing 40% packet loss on the Direct Connect connection during peak hours. The connection is a 1 Gbps dedicated connection that's 85% utilized on average. The architect must resolve the bandwidth issue.

A) Upgrade to a 10 Gbps Direct Connect connection
B) Implement a multi-path strategy: add a second 1 Gbps Direct Connect connection via a different Direct Connect location for redundancy and load distribution, configure BGP with AS path prepending for traffic engineering, and add a site-to-site VPN as overflow/backup
C) Use AWS Direct Connect Gateway for better routing
D) Compress data to reduce bandwidth usage

**Correct Answer: B**
**Explanation:** Multi-path connectivity: (1) **Second Direct Connect (different location)**: Adds 1 Gbps capacity (total 2 Gbps), and using a different location provides physical path diversity. BGP ECMP or traffic engineering distributes load across both connections. (2) **BGP traffic engineering**: Configure AS path prepending and community tags to control which traffic uses which connection based on latency/cost requirements. (3) **VPN backup**: An IPsec VPN over the internet (~1.25 Gbps per tunnel, up to 2 tunnels) provides additional bandwidth for overflow and serves as a backup if a Direct Connect connection fails. Total capacity: ~3-4 Gbps. Option A is a bigger jump but single point of failure (one location). Option C optimizes routing between regions, not bandwidth. Option D has limited effectiveness.

---

### Question 26
A company is designing a multi-tenant SaaS application. They need to provide each tenant with an isolated virtual network for compliance reasons, but want to share the application layer (ECS services) across tenants for cost efficiency. How should the architect design the network isolation?

A) Separate VPCs per tenant connected via Transit Gateway, with shared ECS services using AWS PrivateLink
B) Single VPC with separate subnets per tenant
C) Use VPC sharing (AWS RAM) to share subnets from a central VPC with tenant-specific accounts, deploy shared ECS services in shared subnets, and use security groups + NACLs for tenant isolation
D) Separate AWS accounts per tenant with separate VPCs

**Correct Answer: A**
**Explanation:** VPC per tenant + shared services via PrivateLink: (1) **Tenant VPCs**: Each tenant gets their own VPC (compliance-grade network isolation). No cross-tenant traffic is possible by default. (2) **Shared services VPC**: ECS services run in a central VPC. (3) **AWS PrivateLink**: Each tenant VPC has a VPC endpoint connecting to a Network Load Balancer in the shared services VPC. Tenants access shared services privately without traffic traversing the internet or other tenants' networks. (4) **Transit Gateway**: Optional for management traffic and monitoring. This provides true network isolation while sharing the application layer. Option B doesn't provide VPC-level isolation. Option C shares the network, which may not meet compliance. Option D provides full isolation but doesn't share the application layer.

---

### Question 27
A company processes genomic data files that are 100-300 GB each. Processing involves: alignment (CPU-intensive, 4 hours), variant calling (CPU + memory intensive, 2 hours), and annotation (I/O intensive, 1 hour). They process 50 samples per day. The architect must design the most cost-effective compute architecture.

A) Use a single large EC2 instance type for all stages
B) Use AWS Batch with different compute environments optimized for each stage: (1) Alignment: c6i.8xlarge Spot instances (CPU-optimized), (2) Variant calling: r6i.4xlarge Spot instances (memory-optimized), (3) Annotation: i3.2xlarge Spot instances (storage-optimized with NVMe). Use S3 for input/output with high-throughput VPC endpoints.
C) Use SageMaker Processing for all stages
D) Use Fargate for serverless container processing

**Correct Answer: B**
**Explanation:** AWS Batch with stage-optimized Spot instances: (1) **Alignment** (CPU-bound): c6i.8xlarge (32 vCPU, cost-effective for compute). Spot pricing: ~70% savings. (2) **Variant calling** (CPU + memory): r6i.4xlarge (128 GB memory) handles large genome reference databases. (3) **Annotation** (I/O-bound): i3.2xlarge with local NVMe SSD for fast random reads across large annotation databases. (4) **AWS Batch**: Manages job queues, dependencies between stages, Spot interruption handling (retries), and cluster scaling. (5) **Cost estimate**: 50 samples × 7 hours × ~$1-2/hour (Spot) ≈ $350-700/day ≈ $10,500-21,000/month. Option A wastes resources on stages that don't need those resources. Option C isn't optimized for genomics. Option D—Fargate doesn't support 100-300 GB files well (limited storage).

---

### Question 28
A company's application uses API Gateway → Lambda → DynamoDB. They need to handle a flash sale event where traffic will spike from 1,000 TPS to 50,000 TPS within seconds. The application must not return errors during the spike. The DynamoDB table uses provisioned capacity at 5,000 WCU.

A) Switch DynamoDB to on-demand capacity mode before the flash sale
B) Pre-warm all layers: (1) API Gateway: request an API Gateway account-level throttle increase, (2) Lambda: use provisioned concurrency for ~500 functions to handle the initial burst, (3) DynamoDB: switch to on-demand capacity well in advance (it scales instantly but must be switched 24+ hours ahead) OR increase provisioned capacity to 50,000 WCU + auto-scaling, (4) After the flash sale, revert settings
C) Use SQS to buffer requests during the spike
D) Scale DynamoDB to 50,000 WCU right before the sale

**Correct Answer: B**
**Explanation:** Flash sale preparation requires pre-warming ALL layers: (1) **API Gateway**: Default account limit is 10,000 RPS. Request increase to 100,000+ for the sale. (2) **Lambda**: Without provisioned concurrency, 50,000 TPS would require instant creation of thousands of concurrent executions, causing cold start errors. Provisioned concurrency pre-creates execution environments. (3) **DynamoDB**: On-demand mode is ideal but must be switched at least 24 hours before (there's a cooldown period between mode changes). If staying provisioned, increase WCU to 50,000+ with auto-scaling (auto-scaling takes minutes, too slow for instant spikes). Pre-warm by setting high provisioned capacity. (4) Each service has its own scaling timeline—all must be prepared. Option A only addresses DynamoDB. Option C adds latency (not ideal for flash sales). Option D—DynamoDB WCU increases happen gradually, not instantly.

---

### Question 29
A company has a mature microservices architecture with 60 services. Each service has its own CI/CD pipeline, database, and monitoring. They want to implement distributed tracing but 40 of the 60 services are maintained by teams that don't want to add tracing code. The architect must implement tracing with minimal code changes.

A) Require all teams to instrument their services with X-Ray SDK
B) Deploy AWS Distro for OpenTelemetry (ADOT) as a sidecar/daemonset that automatically captures traces for supported frameworks (gRPC, HTTP, AWS SDK calls) without application code changes. For the remaining services that need custom spans, provide a simple API wrapper.
C) Use CloudWatch ServiceLens which automatically correlates services
D) Implement a service mesh (App Mesh with Envoy) that automatically captures inter-service communication traces at the proxy level, without any application code changes

**Correct Answer: D**
**Explanation:** A service mesh provides the most transparent tracing: (1) **App Mesh with Envoy proxy**: Every service gets an Envoy sidecar proxy (deployed automatically via ECS or EKS configuration). (2) **Automatic tracing**: Envoy proxies capture all inter-service HTTP/gRPC communication: source, destination, latency, error codes, trace context propagation—all without any application code changes. (3) **X-Ray integration**: Envoy proxies export traces to X-Ray, creating a complete service map. (4) **Additional benefits**: Traffic management, retry policies, circuit breaking. This satisfies the "40 teams don't want to add tracing code" constraint perfectly. Option A requires code changes (rejected by 40 teams). Option B still requires some instrumentation for custom traces. Option C correlates existing data but doesn't generate traces.

---

### Question 30
A company stores sensitive documents in S3 and needs to implement a secure document sharing system. External users (customers, partners) need temporary access to specific documents. The system must: authenticate external users, provide time-limited access, track all downloads, and revoke access immediately when needed.

A) Use S3 presigned URLs for each document
B) Implement a document portal using: API Gateway with Cognito User Pool (for external user authentication) → Lambda function that generates short-lived S3 presigned URLs (15-minute expiry) with additional CloudFront signed cookies for streaming. Track downloads via S3 data events in CloudTrail. For immediate revocation: use a DynamoDB blacklist checked by a Lambda@Edge function before allowing download.
C) Make documents public and use obscure URLs
D) Create IAM users for each external user

**Correct Answer: B**
**Explanation:** Secure document sharing with full control: (1) **Cognito User Pool**: External users register and authenticate. Supports MFA, password policies, and account management. (2) **Presigned URLs** (15-minute expiry): Short-lived access tokens. Even if shared, they expire quickly. (3) **CloudFront signed cookies**: For document streaming/preview without re-authentication. (4) **Download tracking**: CloudTrail S3 data events log every GetObject with the user identity. (5) **Immediate revocation**: Lambda@Edge checks a DynamoDB blacklist before allowing downloads. To revoke access: add the user to the blacklist—all future download attempts are blocked regardless of active presigned URLs. Option A doesn't authenticate users or track downloads. Option C is insecure. Option D doesn't scale for external users.

---

### Question 31
A company has an application that needs to process events exactly once. Events come from 100 IoT devices sending data every second. Each event must update a running total in DynamoDB. If an event is processed twice, the total becomes incorrect. The architect must guarantee exactly-once processing.

A) Use SQS FIFO with exactly-once processing
B) Use Kinesis Data Streams with Lambda. Implement idempotency in the Lambda function using DynamoDB conditional writes: use `UpdateItem` with `ConditionExpression = "attribute_not_exists(eventId) OR eventId < :newEventId"` to ensure each event is processed exactly once, even if Lambda retries.
C) Use EventBridge with guaranteed delivery
D) Process events synchronously from the IoT devices

**Correct Answer: B**
**Explanation:** True exactly-once processing requires application-level idempotency because no messaging system guarantees it end-to-end: (1) **Kinesis** receives events reliably with at-least-once delivery. (2) **Lambda** processes events but may retry on failure (at-least-once invocation). (3) **Idempotent DynamoDB write**: The conditional update checks if the event was already processed. Using `attribute_not_exists(eventId)` or comparing sequence numbers ensures the same event applied twice produces the same result. (4) For running totals: store the last processed event ID alongside the total. The conditional write atomically updates the total only if the event hasn't been processed yet. This provides effectively-exactly-once semantics. Option A—FIFO provides message-level dedup but doesn't guarantee the consumer won't process twice. Option C doesn't guarantee exactly-once. Option D doesn't scale.

---

### Question 32
A company has a critical workload running on EC2 in a single AZ. The workload uses instance store volumes for high-IOPS temporary data processing. They need to protect against AZ failures while maintaining the performance of instance store volumes. The catch: the processed data must survive an AZ failure.

A) Use EBS io2 Block Express instead of instance store
B) Use instance store volumes for processing (performance), but implement a "checkpoint and replicate" pattern: periodically (every 30 seconds) write checkpoints of processed data to S3 (cross-AZ durable), and maintain a hot standby instance in a different AZ that can resume from the last S3 checkpoint
C) Use EBS with Multi-Attach across AZs
D) Use a RAID configuration with instance store volumes for redundancy

**Correct Answer: B**
**Explanation:** Instance store volumes provide the highest IOPS but are ephemeral and single-AZ. The architecture: (1) **Primary instance** (AZ-a) uses instance store for high-IOPS processing. Every 30 seconds, a checkpoint (processing state, intermediate results) is written to S3 (durable, cross-AZ). (2) **Standby instance** (AZ-b) with instance store is ready (warm standby). On AZ-a failure, it loads the latest checkpoint from S3 and resumes processing. Maximum data loss: 30 seconds of processing. (3) Final processed results are always written to a durable store (S3, EBS, DynamoDB). This preserves instance store performance while surviving AZ failures. Option A loses the instance store performance advantage. Option C—EBS Multi-Attach only works within the same AZ. Option D doesn't protect against AZ failure.

---

### Question 33
A company is building a serverless application and needs to choose between API Gateway REST API and API Gateway HTTP API. The application needs: WebSocket support for real-time features, request/response transformation, API key management, usage plans, and caching. Monthly request volume: 1 billion. Compare the features and costs.

A) HTTP API for everything (cheapest)
B) Use REST API for the main API (supports all required features: request/response transformation, API keys, usage plans, caching) and a separate WebSocket API for real-time features. Cost: REST API at $3.50/million = $3,500/month for 1B requests + WebSocket API costs.
C) Use HTTP API for most endpoints and REST API only for endpoints needing transformation/caching. Cost: HTTP API at $1.00/million for 800M requests ($800) + REST API at $3.50/million for 200M requests ($700) = $1,500/month total.
D) Both REST and HTTP APIs support all listed features

**Correct Answer: C**
**Explanation:** Strategic API Gateway selection: HTTP API supports: Lambda/HTTP integration, JWT authorization, CORS—at $1.00/million requests (71% cheaper than REST API). REST API adds: request/response transformation, API keys, usage plans, caching, WAF integration—at $3.50/million. **Optimal approach**: (1) Use HTTP API for endpoints that only need basic routing (80% of traffic): $1.00/M × 800M = $800. (2) Use REST API for endpoints needing transformations, caching, or API key management (20% of traffic): $3.50/M × 200M = $700. (3) Use WebSocket API for real-time: separate pricing ($1/M messages + connection hours). **Total: $1,500/month** vs $3,500/month for all-REST. Option A—HTTP API doesn't support transformation, API keys, or caching. Option D is incorrect—HTTP API lacks several features.

---

### Question 34
A company runs a 100-node Amazon EMR cluster processing 10 TB of data daily. The cluster runs 24/7 with the following pattern: heavy processing from 2 AM - 8 AM (ETL), moderate usage 8 AM - 6 PM (analytics), and near-idle 6 PM - 2 AM. The monthly cost is $80,000. The architect must reduce costs by 50%.

A) Switch to EMR Serverless for all workloads
B) Redesign as a transient cluster architecture: (1) ETL cluster (2 AM - 8 AM): 100 nodes on Spot instances for heavy processing, terminated after ETL completes. (2) Analytics cluster (8 AM - 6 PM): 30 nodes (On-Demand core + Spot task nodes) for interactive queries, terminated after business hours. (3) Use S3 as the persistent data layer (not HDFS). (4) Use EMR Managed Scaling for dynamic sizing within each cluster.
C) Use smaller instance types
D) Reduce data processing to 5 TB/day

**Correct Answer: B**
**Explanation:** Transient cluster cost optimization:

**Current**: 100 nodes × 24/7 × $0.05/hour (approximate) = $80,000/month.

**Optimized**:
- **ETL cluster** (6 hours, 100 Spot nodes): 100 × 6h × 30 days × $0.015 (Spot) = $2,700/month
- **Analytics cluster** (10 hours, 30 nodes, mix): 30 × 10h × 22 days × $0.035 (On-Demand/Spot mix) = $2,310/month
- **S3 storage**: Negligible change
- **Total**: ~$5,000/month + S3 + EMR management fees ≈ ~$10,000-15,000/month

**Savings**: ~$65,000-70,000/month (80-85% reduction, exceeding the 50% target). Key enabler: S3 as persistent storage (decoupled from compute) allows cluster termination without data loss. Option A may work but pricing depends on actual usage. Option C has limited impact. Option D loses business value.

---

### Question 35
A company is building a real-time fraud detection system that must evaluate 10,000 transactions per second against 500 fraud rules. Each transaction must be evaluated against ALL 500 rules within 50ms. The rules change weekly. The current approach uses Lambda functions, but evaluating 500 rules sequentially takes 200ms.

A) Use Step Functions Express Workflow to parallelize rule evaluation
B) Pre-compile all 500 rules into a single optimized decision engine deployed on EC2 instances with local caching of rule sets. Use an ALB for load distribution. New rules are compiled and deployed weekly via CodePipeline. The decision engine evaluates all rules in-memory in a single pass (<5ms).
C) Use API Gateway caching to avoid re-evaluating identical transactions
D) Distribute rules across multiple Lambda functions running in parallel

**Correct Answer: B**
**Explanation:** Performance-critical fraud detection requires a purpose-built engine: (1) **Pre-compiled rules**: 500 rules are compiled into an optimized decision tree or Rete network (common in rules engines like Drools, Nools, or custom engines). This eliminates per-rule evaluation overhead. (2) **In-memory execution**: All rules and reference data are loaded in EC2 instance memory. A single transaction evaluation traverses the decision tree once (<5ms). (3) **EC2 with ALB**: Provides the lowest and most predictable latency. At 10,000 TPS × 5ms per evaluation, a few large instances handle the load. (4) **Weekly deployment**: CodePipeline compiles new rules and deploys to EC2 fleet with rolling updates. Option A adds Step Functions overhead. Option C—fraud transactions have unique attributes (caching doesn't help). Option D still has Lambda invocation overhead and 500 parallel invocations per transaction is excessive.

---

### Question 36
A company migrates their on-premises Hadoop cluster to AWS. The cluster uses HDFS for storage, HBase for NoSQL, Hive for SQL, Spark for processing, and Kafka for streaming. The architect must map each component to the optimal AWS service while minimizing operational overhead.

A) Use EMR for all components (managed Hadoop)
B) Map to purpose-built AWS services: HDFS → S3 (decoupled storage), HBase → DynamoDB (managed NoSQL with similar API patterns), Hive → Athena (serverless SQL on S3), Spark → EMR Serverless or Glue (managed Spark), Kafka → Amazon MSK (managed Kafka). This eliminates cluster management while preserving functionality.
C) Lift-and-shift the entire Hadoop cluster to EC2
D) Use EMR for Spark and HBase, S3 for HDFS, Amazon MSK for Kafka, and Athena for Hive

**Correct Answer: B**
**Explanation:** Purpose-built services reduce operational overhead: (1) **HDFS → S3**: Decouples storage from compute. S3 scales infinitely, no cluster sizing. (2) **HBase → DynamoDB**: Both are wide-column stores. DynamoDB is fully managed, auto-scaling, and supports similar access patterns. DynamoDB is operationally simpler than managed HBase on EMR. (3) **Hive → Athena**: Serverless SQL on S3. No cluster management. Pay per query. (4) **Spark → EMR Serverless/Glue**: Serverless Spark execution without managing clusters. Glue for ETL, EMR Serverless for general Spark jobs. (5) **Kafka → MSK**: Fully managed Kafka, compatible with existing Kafka producers/consumers. This eliminates all cluster management. Option A keeps the monolithic cluster. Option C is lift-and-shift with maximum operational burden. Option D is a good alternative (uses managed EMR for Spark/HBase).

---

### Question 37
A company has a complex VPC architecture: 10 VPCs in 5 accounts, connected via VPC Peering in a full mesh (45 peering connections). Adding new VPCs requires creating peering connections to all existing VPCs, and route tables are becoming unmanageable. The architect must simplify the network.

A) Replace all VPC peering with a single AWS Transit Gateway, centralize routing, and implement Transit Gateway route tables for network segmentation
B) Use AWS PrivateLink instead of VPC peering
C) Merge all VPCs into a single VPC
D) Use AWS Cloud WAN for global network management

**Correct Answer: A**
**Explanation:** Transit Gateway hub-and-spoke: (1) **Replace 45 peering connections** with 10 Transit Gateway attachments (one per VPC). (2) **Centralized routing**: Transit Gateway route tables control which VPCs can communicate. Adding a new VPC requires only one attachment. (3) **Network segmentation**: Create separate TGW route tables for different traffic patterns (e.g., production VPCs in one route table, dev in another) with route propagation and static routes. (4) **Cross-account**: Transit Gateway supports cross-account sharing via AWS RAM. (5) **Cost**: TGW has per-attachment and per-GB charges, but operational simplicity justifies the cost vs managing 45+ peering connections. Option B is for service exposure, not VPC connectivity. Option C loses account-level isolation. Option D is for multi-region global networks, potentially overkill for 10 VPCs in one region.

---

### Question 38
A company needs to implement a blue/green deployment for an application running on EC2 instances behind an ALB. The application uses a sticky session (session affinity) based on a cookie. During deployment, existing sessions must continue on the blue (old) version until they naturally expire (30-minute session timeout), while new sessions go to the green (new) version.

A) Use ALB weighted target groups: 100% to green for new sessions
B) Configure ALB with two target groups (blue and green). Use an ALB listener rule with a condition on the session cookie: requests WITH the existing session cookie route to the blue target group; requests WITHOUT the cookie (new sessions) route to the green target group. After 30 minutes, all sessions have migrated to green; decommission blue.
C) Use Route 53 weighted routing for gradual traffic shift
D) Use CodeDeploy blue/green deployment which handles session draining automatically

**Correct Answer: B**
**Explanation:** Cookie-based session routing: (1) **ALB listener rule 1** (high priority): If request contains the legacy session cookie (e.g., `JSESSIONID` matching a pattern from the blue version) → route to blue target group. (2) **ALB listener rule 2** (lower priority): All other requests (no cookie = new session) → route to green target group. (3) Green target group sets a new session cookie. (4) After 30 minutes, all blue sessions expire naturally; blue target group receives zero traffic. (5) Remove the blue target group. This provides zero-downtime, zero-disruption deployment for stateful applications. Option A doesn't handle sticky sessions. Option C adds DNS-level routing complexity. Option D doesn't provide cookie-based routing control at this granularity.

---

### Question 39
A company processes sensitive healthcare data and must implement end-to-end encryption. Data flows: mobile app → API Gateway → Lambda → DynamoDB. They need encryption at every stage: in transit, at rest, and during processing. A breach at any single point must not expose plaintext PHI.

A) Use HTTPS and KMS encryption at rest
B) Implement defense in depth: (1) Mobile app encrypts PHI fields client-side using AWS Encryption SDK with a KMS data key before sending. (2) HTTPS (TLS 1.3) for transit encryption to API Gateway. (3) API Gateway forwards the still-client-encrypted payload to Lambda. (4) Lambda decrypts only the fields it needs for processing using KMS. (5) Re-encrypts processed data before writing to DynamoDB. (6) DynamoDB has server-side encryption (KMS) as an additional layer. Net result: PHI is encrypted at every point with multiple layers.
C) Use VPC endpoints to ensure data stays within the AWS network
D) Use AWS CloudHSM for all encryption

**Correct Answer: B**
**Explanation:** Defense-in-depth encryption: **Client-side encryption** (AWS Encryption SDK) ensures that even if HTTPS is compromised, the payload is encrypted. If Lambda's environment is compromised, only the fields it decrypts are exposed (not the entire record). **Transit encryption** (TLS 1.3) provides network-level protection. **Server-side encryption** (DynamoDB KMS) provides at-rest protection even if S3/DynamoDB storage is accessed directly. This means: (1) A TLS compromise only reveals already-client-encrypted data. (2) A Lambda compromise reveals only the fields Lambda processes. (3) A DynamoDB access reveals only encrypted data (server-side encryption key is separate from client-side key). Option A provides basic encryption but a Lambda compromise reveals plaintext. Option C doesn't encrypt data during processing. Option D is a key management choice, not an encryption architecture.

---

### Question 40
A company operates a global SaaS platform and needs to comply with data residency requirements in 15 countries. Some countries don't have AWS regions. They also need a unified control plane that works globally while keeping customer data local. How should the architect design the architecture?

A) Single region with encryption per country
B) Implement a "control plane/data plane separation" architecture: (1) Global control plane (us-east-1) manages: user authentication, billing, metadata, routing configuration—no customer data. (2) Regional data planes deployed in AWS regions (for countries with regions) and on AWS Outposts/Local Zones (for countries without regions) process and store customer data locally. (3) Data plane APIs enforce data residency at the API level—each request is routed to the correct regional data plane based on the customer's jurisdiction.
C) Use CDN edge locations as data residency points
D) Deploy the entire application in every country

**Correct Answer: B**
**Explanation:** Control plane/data plane separation is the standard architecture for global SaaS with data residency: (1) **Global control plane**: Authentication (Cognito/Identity Provider), billing, tenant management, global routing table. Contains NO customer data—only metadata and configuration. Deployed in a single region or multi-region for availability. (2) **Regional data planes**: Each jurisdiction has its own data plane (compute, database, storage) that processes and stores customer data. In AWS regions: standard AWS services. In countries without regions: AWS Outposts or partner data centers. (3) **Routing layer**: When a request arrives, the routing layer (API Gateway or Global Accelerator) determines the customer's jurisdiction from the authentication token and routes to the correct data plane. Option A violates data residency. Option C—CDN edge locations aren't data centers. Option D is expensive and operationally complex.

---

### Question 41
A company has an Aurora MySQL database experiencing performance degradation. CloudWatch shows: CPU at 90%, read IOPS at 50,000, write IOPS at 10,000. The application performs 70% reads and 30% writes. Analyzing the workload reveals: 60% of reads hit the same 100 rows (hot data), and writes involve complex transactions across 5 tables. What should the architect recommend?

A) Scale up to a larger Aurora instance
B) Add Aurora read replicas and configure read/write splitting in the application
C) Implement a multi-layer caching strategy: (1) ElastiCache Redis for the hot 100 rows (eliminates 60% of reads from hitting Aurora), (2) Aurora read replicas for remaining read traffic, (3) Optimize write transactions by reviewing indexes, batch writes, and potentially denormalizing heavily joined tables
D) Migrate to DynamoDB for better scalability

**Correct Answer: C**
**Explanation:** Targeted optimization based on the specific workload pattern: (1) **ElastiCache for hot rows**: 60% of reads hit 100 rows. Caching these in Redis (sub-millisecond latency) eliminates 42% of total database load (60% of 70% reads). Cache invalidation on writes ensures consistency. (2) **Aurora read replicas**: Handle the remaining 28% of reads (non-hot data), offloading the primary instance. (3) **Write optimization**: Complex multi-table transactions need index tuning, batch processing, and possibly schema denormalization to reduce write amplification. Combined effect: Primary instance load drops from 90% to ~25-30%. Option A is a short-term fix that doesn't address the root cause. Option B helps reads but doesn't address the hot data pattern or write optimization. Option D requires a complete application rewrite.

---

### Question 42
A company wants to implement a "cell-based architecture" for their global application to limit blast radius. Each cell is a complete, independent deployment that serves a subset of customers. If one cell fails, only its customers are affected. How should the cells be implemented on AWS?

A) Each cell is a separate VPC in the same account
B) Each cell is a separate AWS account with its own VPC, database, compute, and complete application stack. Cell assignment is based on consistent hashing of customer ID. A global routing layer (Global Accelerator + Lambda@Edge or CloudFront Functions) inspects the customer's authentication token and routes to the correct cell. Cross-cell communication is prohibited by design.
C) Each cell is a different region
D) Use ECS services as cells within a shared cluster

**Correct Answer: B**
**Explanation:** Cell-based architecture principles: (1) **Complete isolation**: Each cell (AWS account) is independent—its own database, compute, networking. A bug or overload in one cell cannot propagate to another. (2) **Fixed customer assignment**: Consistent hashing of customer ID determines which cell serves each customer. No customer moves between cells during normal operation. (3) **Global routing**: A thin routing layer (Global Accelerator → CloudFront Functions/Lambda@Edge) reads the customer ID from the request (JWT, cookie, or API key) and routes to the correct cell. (4) **No cross-cell communication**: Cells never call each other. This is the architecture used by Amazon, Azure, and other hyperscalers. Maximum blast radius = one cell's customers. Option A shares the account (blast radius too wide). Option C limits to 20-30 cells (number of regions). Option D doesn't provide sufficient isolation.

---

### Question 43
A company's data science team wants to run Jupyter notebooks with GPU access for model training. They need: instant notebook startup, GPU instances (p3.2xlarge), persistent storage for notebooks and datasets (500 GB per user), cost control (auto-shutdown after 30 minutes idle), and integration with their S3 data lake. There are 50 data scientists. How should the architect design this?

A) Deploy JupyterHub on an EC2 GPU instance
B) Use Amazon SageMaker Studio with: (1) ml.p3.2xlarge instances for GPU notebooks, (2) EFS storage for persistent notebooks and datasets, (3) Auto-shutdown lifecycle configuration (Lambda-based) that stops idle instances after 30 minutes, (4) VPC configuration for secure access to S3 data lake, (5) IAM roles for controlled S3 data lake access per user
C) Use AWS Cloud9 for notebooks
D) Use EC2 Spot instances with Jupyter pre-installed

**Correct Answer: B**
**Explanation:** SageMaker Studio provides a managed notebook environment: (1) **GPU instances**: Studio supports ml.p3.2xlarge for GPU-accelerated notebooks. Instances start in seconds (pre-provisioned images). (2) **EFS persistent storage**: Each user's notebooks, datasets, and conda environments persist across sessions. 500 GB allocation per user. (3) **Auto-shutdown**: Lifecycle configuration scripts detect idle notebooks (no kernel activity for 30 minutes) and shut down the underlying instance—user only pays while actively using GPU. (4) **Data lake integration**: VPC mode provides private S3 access. IAM roles control which S3 paths each user can access. (5) **Cost control**: 50 users × $3.06/hour (p3.2xlarge) × ~4 hours active/day = ~$612/day (vs $3,672/day if running 24/7). Option A requires managing infrastructure. Option C doesn't support GPU. Option D—Spot interruptions during model training cause lost work.

---

### Question 44
A company needs to replicate their on-premises Oracle Data Guard setup in AWS. The on-premises setup uses Maximum Availability mode (synchronous replication between primary and standby). The database is 5 TB with 20,000 transactions per second. They want the same protection level in AWS.

A) Use RDS Oracle with Multi-AZ (synchronous replication)
B) Deploy Oracle on EC2 in two AZs with Data Guard in Maximum Availability mode using an EC2 placement group to minimize network latency between primary and standby. Use EBS io2 Block Express for storage with Multi-Attach disabled. Configure Data Guard broker for automated failover.
C) Use Aurora with synchronous replication
D) Use RDS Oracle with cross-region read replica

**Correct Answer: B**
**Explanation:** Oracle Data Guard Maximum Availability mode on EC2: (1) **EC2 in two AZs**: Primary in AZ-a, standby in AZ-b. Data Guard handles synchronous redo log shipping. (2) **Network optimization**: While placement groups work within a single AZ, cross-AZ network latency in AWS is typically <1ms, acceptable for synchronous replication. Enhanced networking (ENA) with jumbo frames reduces overhead. (3) **EBS io2 Block Express**: Up to 256,000 IOPS and 4,000 MB/s—handles 20,000 TPS easily. (4) **Data Guard Broker**: Automates failover, monitoring, and switchover operations. (5) **Oracle RAC** (if needed): Requires shared storage, more complex on AWS. Option A—RDS Oracle Multi-AZ uses Amazon's replication technology, not Oracle Data Guard (different behavior). Option C—Aurora is not Oracle. Option D—cross-region replicas are asynchronous.

---

### Question 45
A company has a CI/CD pipeline that takes 45 minutes to run. The breakdown: CodeCommit webhook trigger (instant), CodeBuild compile + unit tests (15 min), CodeBuild integration tests (20 min), manual approval (varies), CodeDeploy (10 min). The team wants to reduce the pipeline time to under 20 minutes.

A) Use larger CodeBuild instances
B) Parallelize: (1) Split unit tests into 5 parallel CodeBuild projects (15 min → 3 min with CodeBuild batch build), (2) Overlap compilation with integration test environment setup, (3) Split integration tests into 4 parallel suites (20 min → 5 min), (4) Use CodeDeploy with AllAtOnce instead of rolling for non-production (10 min → 2 min). Maintain rolling deploy for production. Total: ~10 minutes + approval.
C) Skip integration tests to save time
D) Use pre-built Docker images to reduce build time

**Correct Answer: B**
**Explanation:** Pipeline optimization through parallelism: (1) **CodeBuild batch builds**: Split unit tests into 5 parallel builds. Each runs a subset (3 minutes each). All run simultaneously = 3 minutes total. (2) **Overlap stages**: While compiling, start provisioning the integration test environment (can save 2-3 minutes). (3) **Integration test parallelism**: 4 parallel test suites, each running a quarter of integration tests (5 minutes each). (4) **CodeDeploy optimization**: AllAtOnce for dev/staging is acceptable (2 minutes). Rolling deploy for production preserves safety. **New timeline**: Compile + parallel unit tests (3 min) → parallel integration tests (5 min) → deploy (2 min) = 10 minutes. 78% reduction. Option A helps marginally. Option C reduces quality. Option D helps build time but not test time.

---

### Question 46
A company has a legacy SOAP API that their enterprise customers depend on. They're building a new REST API for modern clients. During the transition (12+ months), both APIs must be maintained. The SOAP API runs on EC2, and the REST API runs on API Gateway + Lambda. The architect must minimize the cost and effort of maintaining both APIs.

A) Run both APIs independently
B) Implement a single backend service (Lambda) and use API Gateway for the REST API and an API Gateway HTTP integration with a SOAP-to-REST transformation Lambda for the SOAP API. The transformation Lambda converts SOAP XML requests to the internal REST format, calls the same backend Lambda, and converts the REST response back to SOAP XML.
C) Rewrite the SOAP API as a REST API and force customers to migrate
D) Use AWS AppSync as a unified API layer

**Correct Answer: B**
**Explanation:** Single backend with protocol translation: (1) **Backend Lambda**: Contains all business logic, accepts JSON input/output. Shared by both APIs. (2) **REST API**: API Gateway → Backend Lambda (native JSON, no translation needed). (3) **SOAP API**: ALB/NLB → Translation Lambda (SOAP XML → JSON → calls Backend Lambda → JSON response → SOAP XML response). (4) **Single codebase**: Business logic changes are made once and serve both APIs. (5) **Migration path**: As enterprise customers migrate to REST, the translation layer handles fewer requests. Eventually, decommission the SOAP facade. Option A doubles the maintenance effort. Option C forces customer migration (business relationship risk). Option D is GraphQL, not SOAP/REST.

---

### Question 47
A company runs a Kubernetes cluster on EKS with 200 pods across 20 nodes. They need to implement pod-level network security: certain pods must only communicate with specific other pods (zero-trust networking within the cluster). The architect must enforce network policies.

A) Use Kubernetes NetworkPolicy with a CNI that supports it (Calico on EKS) to define ingress and egress rules at the pod level. Example: the payment pod only accepts traffic from the API pod and can only send traffic to the database pod. All other pod-to-pod communication is denied by default.
B) Use security groups on EC2 nodes
C) Use NACLs on the EKS subnets
D) Implement application-level authentication between pods

**Correct Answer: A**
**Explanation:** Kubernetes NetworkPolicy with Calico: (1) **Default deny all**: Apply a default deny-all NetworkPolicy to every namespace, establishing zero-trust. (2) **Allow specific**: Create NetworkPolicy resources allowing only required communication. Example: `spec: ingress: - from: - podSelector: {matchLabels: {app: api-gateway}} ports: - port: 8080` on the payment service allows only the API gateway to connect. (3) **Calico CNI**: Amazon VPC CNI doesn't enforce NetworkPolicies by default. Install Calico (or the Calico Network Policy Engine for VPC CNI) to enforce them. (4) **Namespace isolation**: Cross-namespace traffic is denied by default with NetworkPolicies. Option B operates at the node level, not pod level. Option C operates at the subnet level. Option D adds authentication but doesn't prevent network access.

---

### Question 48
A company has 500 microservices and needs to implement a service mesh for: traffic management, mTLS between services, retries, circuit breaking, and observability. They run on ECS Fargate. Compare AWS App Mesh vs. a third-party mesh (Istio).

A) Use Istio for all features
B) Use AWS App Mesh which integrates natively with ECS Fargate, providing Envoy-based sidecar proxies for: traffic management (weighted routing, retries, timeouts), mTLS (auto-generated certificates via ACM Private CA), circuit breaking, and X-Ray integration for observability. App Mesh is managed—no control plane to operate.
C) Implement service-to-service communication libraries in application code
D) Use ALB for inter-service communication management

**Correct Answer: B**
**Explanation:** For ECS Fargate, App Mesh is the optimal choice: (1) **Native Fargate integration**: App Mesh Envoy sidecars are deployed alongside Fargate tasks via task definition configuration. No EC2 management needed (unlike Istio which requires control plane nodes). (2) **Managed control plane**: App Mesh manages the mesh configuration—no need to operate Istio's istiod, Pilot, Citadel components. (3) **mTLS**: Automatic mutual TLS between services using ACM Private CA certificates (managed certificate lifecycle). (4) **Traffic management**: Weighted routing for canary deployments, retries with exponential backoff, timeouts. (5) **X-Ray integration**: Envoy proxies automatically export traces to X-Ray. (6) **Circuit breaking**: Connection pool management and outlier detection. Option A requires managing Istio's control plane (complex on Fargate). Option C is unmaintainable at 500 services. Option D doesn't provide mTLS or circuit breaking.

---

### Question 49
A company stores time-series IoT data (temperature readings from 100,000 sensors, 1 reading per second per sensor = 100,000 writes/second). They need: fast writes, efficient time-range queries, downsampling for historical data, and 5-year retention. The architect must choose the optimal database.

A) DynamoDB with composite sort keys (timestamp)
B) Amazon Timestream for time-series data: purpose-built for IoT time-series with: (1) automatic tiering (in-memory → magnetic storage), (2) built-in time-series functions (interpolation, smoothing, binning), (3) automatic data lifecycle management (downsample and aggregate old data), (4) native support for 100,000+ writes/second, (5) SQL-compatible query interface
C) RDS PostgreSQL with TimescaleDB extension
D) Amazon OpenSearch with time-based indices

**Correct Answer: B**
**Explanation:** Amazon Timestream is purpose-built for this use case: (1) **Write throughput**: Handles millions of writes/second, easily accommodating 100,000/second. (2) **Automatic tiering**: Recent data in memory store (fast queries), older data in magnetic store (cost-effective). (3) **Time-series functions**: Built-in interpolation, smoothing, aggregation, gap filling—essential for IoT analytics. (4) **Data lifecycle**: Configure retention policies per storage tier. Automatic downsampling of old data (e.g., keep 1-minute aggregates after 30 days, 1-hour aggregates after 1 year). (5) **SQL interface**: Compatible with BI tools and standard query patterns. (6) **Cost-effective at scale**: Magnetic storage for 5-year historical data is significantly cheaper than DynamoDB or RDS. Option A can handle the writes but lacks time-series functions. Option C requires managing EC2/RDS infrastructure. Option D is optimized for search, not time-series.

---

### Question 50
A company needs to implement a data mesh architecture on AWS. Each business domain (Sales, Marketing, Finance, Operations) owns its data products. The central platform team provides shared infrastructure. The architect must design the data mesh with proper governance.

A) Create a single data lake account managed by the central team
B) Implement: (1) Domain accounts: each domain has its own AWS account with S3 data lake, Glue catalog, and ETL tools to produce data products. (2) Central governance account: Lake Formation manages cross-domain data access with tag-based access control. (3) Data product catalog: Glue Data Catalog with cross-account sharing via Lake Formation. (4) Shared infrastructure: Athena/Redshift Spectrum workgroups in consumer accounts query data products across domains. (5) Data quality: Glue Data Quality rules enforced at the domain level.
C) Use a single Redshift cluster with schema-per-domain
D) Use AWS Data Exchange for inter-domain data sharing

**Correct Answer: B**
**Explanation:** Data mesh on AWS: (1) **Domain ownership**: Each domain account owns, produces, and maintains its data products in S3 with Glue ETL. Domain teams have full autonomy over their pipelines. (2) **Federated governance**: Lake Formation in a central account provides tag-based access control (LF-TBAC) across all domain accounts. Tags like "PII", "Confidential" control access without per-resource policies. (3) **Data discovery**: Glue Data Catalog (shared via Lake Formation) enables consumers to discover data products across domains. (4) **Self-serve consumption**: Consumer teams query data products from their accounts using Athena/Redshift Spectrum without needing direct access to producer accounts. (5) **Quality contracts**: Glue Data Quality rules (expectations) serve as the data product SLA. Option A is centralized (anti-data mesh). Option C is a data warehouse, not a data mesh. Option D is for external data exchange.

---

### Question 51
A company deploys a microservices application using ECS Fargate. During peak load, new tasks take 45 seconds to start due to container image pull time (2 GB image). The ALB health check passes after 30 seconds. Total time from scale-out trigger to serving traffic: 75 seconds. The architect must reduce this to under 15 seconds.

A) Use smaller container images
B) Implement: (1) Seekable OCI (SOCI) image lazy loading to reduce image pull to ~5 seconds (only pulls necessary layers on demand), (2) Reduce image size by using multi-stage builds with Alpine base images (2 GB → 200 MB), (3) Configure ALB health check with shorter interval and faster healthy threshold, (4) Use ECS capacity providers with pre-provisioned Fargate tasks (maintained at a minimum warm pool)
C) Switch from Fargate to EC2 launch type with pre-pulled images
D) Use ECR image caching

**Correct Answer: B**
**Explanation:** Multi-pronged startup optimization: (1) **SOCI (Seekable OCI)**: AWS Fargate supports SOCI indexes that enable lazy loading—containers start executing before the full image is downloaded. Reduces pull time from 45 seconds to ~5 seconds. (2) **Image optimization**: Multi-stage Docker builds eliminate build tools from the final image. Alpine base images reduce size dramatically (2 GB → 200 MB). Smaller images pull faster even without SOCI. (3) **ALB health check optimization**: Reduce interval to 5 seconds, healthy threshold to 2 checks = 10 seconds. The application should respond to health checks immediately on startup. (4) **Warm pool**: Maintain some pre-started tasks. **New total: 5s (pull) + 10s (health check) = 15 seconds**. Option C adds EC2 management overhead. Option D helps with repeat pulls but not cold starts.

---

### Question 52
A company has a production database that requires zero-downtime migration from RDS MySQL 5.7 to Aurora MySQL 8.0. The database is 2 TB with 5,000 writes per second. Replication between MySQL 5.7 and MySQL 8.0 has compatibility issues with some stored procedures. What is the safest migration approach?

A) Use RDS Blue/Green Deployments to create a staging environment with Aurora MySQL 8.0, replicate using MySQL binary log replication, test stored procedure compatibility, and then switchover with minimal downtime
B) Create an Aurora read replica from the RDS instance, then promote it
C) Use DMS for full load and CDC replication to Aurora MySQL 8.0
D) Dump and restore the database during a maintenance window

**Correct Answer: A**
**Explanation:** RDS Blue/Green Deployments provide the safest path: (1) **Create a Blue/Green deployment**: RDS creates a "green" staging environment (Aurora MySQL 8.0) and sets up replication from the "blue" (RDS MySQL 5.7) using binlog replication. (2) **Testing**: Run stored procedures on the green environment while replication is active. Fix compatibility issues (MySQL 5.7 → 8.0 syntax changes). (3) **Switchover**: When ready, RDS performs a switchover that: stops writes to blue, catches up replication lag, promotes green to primary, updates the endpoint—downtime is typically under 1 minute. (4) **Rollback**: If issues are found, switch back to blue within minutes. Option B—read replicas from RDS MySQL can't target Aurora MySQL 8.0 directly with version jumps. Option C works but lacks the integrated switchover mechanism. Option D requires extended downtime.

---

### Question 53
A company runs a global e-commerce platform and needs to implement a product recommendation engine. The system must: generate personalized recommendations in real-time (<100ms), handle 50,000 requests/second during peak, and update models daily with new purchase data. They have a data science team but limited infrastructure expertise.

A) Build a custom recommendation engine on EC2 with GPU instances
B) Use Amazon Personalize for the recommendation engine: (1) Ingest purchase data via S3 and Personalize Event Tracker (real-time events). (2) Train recommendation models daily (automated retraining). (3) Serve recommendations via Personalize API (<100ms latency). (4) Cache popular recommendations in ElastiCache for cost optimization at 50K RPS. (5) Use A/B testing to optimize recommendation strategies.
C) Use SageMaker to build and deploy a custom model
D) Use a simple collaborative filtering algorithm in Lambda

**Correct Answer: B**
**Explanation:** Amazon Personalize provides a fully managed recommendation engine: (1) **Data ingestion**: S3 for historical data (bulk import), Event Tracker API for real-time events (clicks, purchases, page views). (2) **Model training**: Automated ML pipeline selects the best algorithm (User Personalization, Similar Items, Personalized Ranking) and hyperparameters. Daily retraining with new data. (3) **Real-time inference**: `GetRecommendations` API returns personalized items in <100ms. (4) **50K RPS**: Personalize auto-scales for throughput. Complemented by ElastiCache for the most popular/trending items. (5) **A/B testing**: Personalize campaigns support metrics for comparing recommendation strategies. This requires minimal ML infrastructure expertise. Option A requires significant ML engineering. Option C is feasible but higher effort. Option D is too simplistic for personalization.

---

### Question 54
A company's AWS monthly bill is $500,000. The CFO wants a 25% cost reduction ($125,000/month savings). The current breakdown: EC2 ($200K), RDS ($80K), S3 ($50K), Data Transfer ($70K), Lambda ($30K), Others ($70K). The architect must identify the highest-impact optimizations.

A) Negotiate an Enterprise Discount Program (EDP) for a blanket discount
B) Prioritized optimization plan: (1) EC2 ($200K): Right-size (Compute Optimizer, ~20% savings = $40K), Savings Plans (30% on remaining = $48K). (2) RDS ($80K): Right-size + Reserved Instances (40% savings = $32K). (3) Data Transfer ($70K): Use CloudFront for S3 delivery, VPC endpoints to eliminate NAT Gateway data processing, S3 Transfer Acceleration review (30% savings = $21K). (4) S3 ($50K): Lifecycle policies to Glacier tiers (40% savings = $20K). Total potential: ~$161K/month savings.
C) Move everything to Spot instances
D) Reduce application functionality to cut costs

**Correct Answer: B**
**Explanation:** Targeted optimization by cost category:

| Category | Current | Optimization | Savings |
|----------|---------|-------------|---------|
| EC2 ($200K) | Over-provisioned, on-demand | Right-size + 1yr Savings Plan | $88K |
| RDS ($80K) | Over-provisioned, on-demand | Right-size + Reserved | $32K |
| Data Transfer ($70K) | NAT Gateway processing, direct S3 | CloudFront + VPC endpoints | $21K |
| S3 ($50K) | All Standard tier | Lifecycle to IA/Glacier | $20K |
| **Total** | | | **$161K** |

This exceeds the $125K target with minimal risk. Implementation order: (1) Savings Plans/RIs (biggest savings, no code changes), (2) Right-sizing (minimal risk), (3) S3 lifecycle (data access pattern analysis needed), (4) Data transfer optimization (architectural changes). Option A provides ~5-10% EDP discount (~$50K), not enough alone. Option C—Spot isn't suitable for all workloads. Option D is a business decision, not architecture.

---

### Question 55
A company operates a SaaS application where each API request requires querying 3 databases (user data from DynamoDB, product data from Aurora, pricing data from ElastiCache) and aggregating the results. Currently, queries are sequential (DynamoDB: 5ms, Aurora: 15ms, ElastiCache: 1ms = 21ms total). The architect must reduce the API response time.

A) Cache the aggregated results in ElastiCache
B) Execute all three queries in parallel using async programming (Promise.all in Node.js / asyncio.gather in Python), reducing total time from sequential (21ms) to the maximum single query time (~15ms)
C) Move all data to a single database
D) Pre-compute aggregated results in a materialized view

**Correct Answer: B**
**Explanation:** Parallel query execution is the simplest, most impactful optimization: (1) **Sequential**: DynamoDB (5ms) → Aurora (15ms) → ElastiCache (1ms) = 21ms. (2) **Parallel**: All three queries execute simultaneously. Total time = max(5ms, 15ms, 1ms) = 15ms. (3) **Implementation**: In Lambda (Node.js): `const [userData, productData, pricingData] = await Promise.all([queryDynamoDB(), queryAurora(), queryElastiCache()])`. In Python: `results = await asyncio.gather(query_dynamo(), query_aurora(), query_cache())`. **Savings: 29% latency reduction** (21ms → 15ms) with minimal code change. Option A adds a caching layer but the current 21ms may already be acceptable. Option C loses the benefits of purpose-built databases. Option D adds staleness and maintenance complexity.

---

### Question 56
A company runs a batch processing system that generates monthly reports. The job reads 5 TB from S3, processes it with Spark on EMR, and writes 500 GB of results back to S3. The job runs once per month and takes 4 hours. Current cost: $2,000/run (20 r5.4xlarge instances × 4 hours). The architect must reduce costs.

A) Use Spot instances for the EMR cluster
B) Use EMR Serverless with Spot capacity: (1) No cluster management overhead. (2) Pay only for the resources used during the 4-hour run. (3) Auto-scales workers based on workload demands. (4) Spot workers significantly reduce cost. Estimated cost: ~$400-600/run (70-80% savings).
C) Use AWS Glue instead of EMR
D) Pre-filter the 5 TB to reduce data volume

**Correct Answer: B**
**Explanation:** EMR Serverless optimization: (1) **No idle cluster**: Traditional EMR requires provisioning a cluster that may be over- or under-provisioned. Serverless provisions exactly the resources needed. (2) **Spot pricing**: EMR Serverless supports Spot capacity for workers (up to 80% cheaper than on-demand). (3) **Auto-scaling**: Workers scale up during CPU-intensive phases and scale down during I/O phases—no wasted capacity. (4) **No management**: No cluster creation, termination, or Hadoop/Spark tuning. Cost breakdown: $2,000 current → ~$400 with Spot + right-sized compute. Option A (Spot on traditional EMR) saves ~60% but still has cluster management overhead. Option C—Glue may not be cost-effective for 5 TB processing. Option D reduces volume but may not be possible.

---

### Question 57
A company has a Lambda function that connects to an RDS database in a VPC. Cold starts take 8 seconds due to VPC ENI creation. The function processes time-sensitive financial transactions. The architect must eliminate cold start latency.

A) Move the database outside the VPC
B) Use Lambda Provisioned Concurrency AND VPC improvements: (1) Provisioned concurrency pre-creates execution environments with pre-attached ENIs (eliminating cold start entirely). (2) Lambda's VPC networking improvements (Hyperplane-based ENI) have reduced VPC cold starts to ~1 second for non-provisioned invocations. (3) Use RDS Proxy (in the same VPC) for connection pooling. (4) Size provisioned concurrency based on expected concurrent transactions.
C) Use Lambda outside VPC with a VPN tunnel to RDS
D) Switch to DynamoDB which doesn't require VPC access

**Correct Answer: B**
**Explanation:** Eliminating Lambda cold starts for VPC functions: (1) **Provisioned concurrency**: Pre-creates N concurrent execution environments. Each has a pre-attached ENI and an initialized runtime—zero cold start. For financial transactions, this guarantees consistent sub-100ms starts. (2) **Modern VPC optimization**: Even without provisioned concurrency, AWS's Hyperplane-based ENI sharing (launched 2019) reduced VPC cold starts from 8-10 seconds to ~1 second. (3) **RDS Proxy**: Handles connection pooling, so Lambda doesn't need to create database connections during cold starts (connection reuse). (4) **Cost**: Provisioned concurrency costs ~$0.0000041667/GB-second. For 100 provisioned concurrent × 128 MB = $1.50/hour. Justified for financial transaction SLAs. Option A weakens security. Option C is complex. Option D changes the database technology.

---

### Question 58
A company needs to implement a disaster recovery solution for their entire AWS Organization (50 accounts). The solution must protect against: account compromise, accidental deletion of organization resources, and ransomware. What should the architect design?

A) Standard DR with cross-region backups
B) Implement: (1) AWS Backup with Organization policies + Vault Lock (compliance mode) for immutable backups. (2) Cross-account backup vaults in a dedicated backup account with no delete permissions. (3) Cross-region backup copies. (4) SCP preventing anyone from deleting backup vaults or disabling backups. (5) Separate "break-glass" Organization in a different root email for catastrophic recovery. (6) Regularly test restores from backups.
C) Use S3 versioning on all buckets
D) Use AWS CloudFormation for infrastructure recovery only

**Correct Answer: B**
**Explanation:** Organization-level DR against advanced threats: (1) **Vault Lock**: Immutable backups that cannot be deleted by anyone (including root, including ransomware). (2) **Cross-account vaults**: If an account is compromised, the attacker can't reach the backup account. (3) **Cross-region copies**: Protects against regional disasters. (4) **SCPs**: Prevent deletion of backup infrastructure organization-wide. (5) **Separate break-glass Organization**: If the primary Organization is completely compromised (management account breach), a separate Organization (different email, different root credentials stored offline) provides a recovery path for the most catastrophic scenario. (6) **Test restores**: Backups are only useful if they can be restored. Option A doesn't address account compromise or ransomware. Option C doesn't protect against account compromise. Option D only recovers infrastructure, not data.

---

### Question 59
A company has an application that needs to call AWS APIs from IoT devices deployed in the field. The devices have limited storage and computing power. Device credentials must be managed securely, and devices that are decommissioned must have their access revoked immediately. There are 1 million devices.

A) Create IAM users for each device with access keys
B) Use AWS IoT Core with X.509 device certificates: (1) Each device gets a unique X.509 certificate provisioned during manufacturing. (2) IoT Core policies control which AWS resources each device can access. (3) Device certificates can be revoked individually (immediate effect). (4) Fleet provisioning handles adding new devices at scale. (5) For AWS API access beyond IoT Core, use the IoT Credential Provider to exchange the X.509 certificate for temporary IAM credentials.
C) Use Cognito Identity Pools for device authentication
D) Embed shared AWS credentials in the device firmware

**Correct Answer: B**
**Explanation:** IoT device identity at scale: (1) **X.509 certificates**: Industry standard for device identity. Each device has a unique certificate stored in its secure element/TPM. No passwords to rotate. (2) **IoT Core integration**: Certificates authenticate MQTT connections. IoT policies provide fine-grained access (per-device, per-topic). (3) **Instant revocation**: Certificate revocation list (CRL) or IoT Core's `UpdateCertificate` API immediately blocks a decommissioned device. (4) **Credential Provider**: For devices needing to call AWS APIs (S3 PutObject, DynamoDB writes), the IoT Credential Provider exchanges the X.509 certificate for temporary STS credentials with role-assumed permissions. (5) **Fleet provisioning**: Automate certificate creation and device registration at manufacturing scale. Option A doesn't scale to 1 million and has no cert-based revocation. Option C is for human users. Option D is a critical security vulnerability.

---

### Question 60
A company runs a content management system that stores 50 million documents in S3. Users search documents by content using Amazon OpenSearch. The OpenSearch cluster costs $15,000/month and takes 30 seconds to reindex when a document changes. The architect must reduce cost and improve indexing speed.

A) Use Amazon Kendra for document search
B) Implement a tiered search architecture: (1) Use S3 Event Notifications → Lambda → OpenSearch for near-real-time indexing (document changes are indexed within seconds). (2) Right-size the OpenSearch cluster using UltraWarm for older document indices. (3) Use OpenSearch Serverless for search workloads (pay per OCU, auto-scales). (4) Implement a search cache (ElastiCache) for popular queries.
C) Use S3 Select for document content search
D) Replace OpenSearch with Athena full-text search

**Correct Answer: B**
**Explanation:** Optimization: (1) **Event-driven indexing**: S3 Event → Lambda → OpenSearch replaces the batch reindexing. Each document change triggers an immediate index update (seconds, not 30 seconds). Lambda extracts text from the document and calls the OpenSearch bulk API. (2) **OpenSearch Serverless**: For search-heavy workloads with variable traffic, Serverless eliminates node management and scales OCUs based on demand. Can significantly reduce costs compared to a fixed cluster. (3) **UltraWarm**: For the 90%+ of documents that are rarely searched, UltraWarm storage costs 90% less than hot storage. (4) **Search cache**: Popular queries (same search terms repeated by different users) served from ElastiCache without hitting OpenSearch. Estimated cost: $5,000-8,000/month (47-67% savings). Option A is designed for enterprise search but more expensive at this scale. Option C doesn't support full-text search. Option D—Athena isn't designed for full-text search.

---

### Question 61
A company is designing a multi-player online game backend. Requirements: 100,000 concurrent players, 50ms response time, real-time leaderboards, matchmaking, and persistent game state. The architect must choose the right combination of services.

A) EC2 instances with Redis for everything
B) Use: GameLift for matchmaking and dedicated game servers, DynamoDB for persistent game state (player profiles, inventory), ElastiCache Redis for real-time leaderboards (sorted sets) and session data, API Gateway WebSocket for real-time client communication, Kinesis for game telemetry/analytics. EventBridge for game event processing.
C) Use AppSync with DynamoDB subscriptions for real-time
D) Use a single Aurora database for all game data

**Correct Answer: B**
**Explanation:** Purpose-built services for game backend: (1) **GameLift**: Managed dedicated game servers with matchmaking (FlexMatch). Auto-scales based on player demand. Supports 100K+ concurrent players. (2) **DynamoDB**: Low-latency (<5ms) reads/writes for player profiles, inventory, and game state. Auto-scales with on-demand capacity. (3) **ElastiCache Redis**: ZADD/ZRANGEBYSCORE for leaderboards (sub-millisecond). Session store for game sessions. Sorted sets handle millions of entries. (4) **WebSocket API**: Real-time bidirectional communication for game events (player moves, state updates). (5) **Kinesis**: Game telemetry (analytics, anti-cheat). (6) **EventBridge**: Achievement triggers, daily rewards, scheduled events. This architecture handles 100K concurrent with <50ms response. Option A requires managing game servers. Option C has latency limitations. Option D is too slow for real-time gaming.

---

### Question 62
A company's data pipeline processes 1 TB of data hourly through 5 transformation stages. Each stage is an EMR Spark job. The pipeline currently runs sequentially (5 hours total). However, stages 2 and 3 have no dependency on each other (both depend only on stage 1). Similarly, stage 5 depends on both stages 3 and 4, but stage 4 only depends on stage 2. The architect must optimize the pipeline execution time.

A) Run all stages in parallel
B) Implement a DAG-based execution using Step Functions or MWAA (Amazon Managed Workflows for Apache Airflow): Stage 1 → (Stage 2 || Stage 3) → Stage 4 (depends on Stage 2) → Stage 5 (depends on Stages 3 and 4). This parallelizes independent stages, reducing total time from 5 hours to 3 hours.
C) Use a single EMR cluster for all stages
D) Use Glue workflows for orchestration

**Correct Answer: B**
**Explanation:** DAG optimization:

**Sequential (current)**: S1 → S2 → S3 → S4 → S5 = 5 hours

**Parallel DAG**:
- Hour 1: S1
- Hour 2: S2 (parallel) AND S3 (parallel)
- Hour 3: S4 (after S2) AND wait for S3
- Hour 3 end: S5 (after S3 and S4)
- Total: 3 hours (40% reduction)

**MWAA/Step Functions** handles the DAG: defines dependencies, triggers each stage when prerequisites complete, handles retries/failures. Step Functions Parallel state runs S2 and S3 simultaneously after S1 completes. A nested parallel can run S4 (after S2) in parallel with S3 completion check. Option A would produce incorrect results (dependencies exist). Option C doesn't parallelize stages. Option D can work but MWAA provides richer DAG management.

---

### Question 63
A company has a serverless API that returns personalized product recommendations. The API is backed by Lambda functions that query DynamoDB. Average response time: 50ms. During marketing campaigns, the same products are recommended to millions of users (low cardinality of unique responses). The API handles 100,000 requests/second during campaigns. Current Lambda cost during campaigns: $15,000/day.

A) Use API Gateway caching to serve cached responses for identical recommendations
B) Implement a multi-layer caching strategy: (1) API Gateway response cache (5-minute TTL) for identical request patterns—eliminates Lambda invocations entirely. (2) Lambda function-level cache (global variable) for hot recommendation data. (3) DynamoDB DAX for low-latency reads on cache misses. For campaigns, API Gateway caching alone could serve 90%+ of requests without Lambda invocations, reducing costs by 90%.
C) Use CloudFront for API caching
D) Pre-compute recommendations and store in S3

**Correct Answer: B**
**Explanation:** Cost-optimized caching: During campaigns, millions of users receive the same recommendations (low cardinality). **API Gateway cache**: Caches responses based on request parameters. With a 5-minute TTL, a recommendation that applies to millions of users is computed once and served from cache for 5 minutes. At 100K RPS with 90% cache hit: only 10K RPS hit Lambda. **Lambda in-memory cache**: For the 10K RPS that reach Lambda, frequently accessed DynamoDB data is cached in the Lambda execution environment's memory (global variable). **DAX**: For remaining cache misses, DAX provides microsecond DynamoDB reads. **Cost reduction**: Lambda invocations drop from 100K/s to 10K/s = 90% cost reduction ($15K/day → $1.5K/day). API Gateway cache costs ~$3.50/hour per 0.5 GB = minimal. Option A is a subset of B. Option C adds CloudFront complexity. Option D loses personalization.

---

### Question 64
A company has a hybrid environment with on-premises Active Directory. They want to use AWS services with their existing AD identities for: AWS console access, programmatic access, and access to RDS SQL Server with Windows authentication. How should the architect configure identity federation?

A) Create IAM users mirroring AD users
B) Implement: (1) AWS Managed Microsoft AD or AD Connector for Directory Service. (2) IAM Identity Center (SSO) federated with the on-premises AD for console and programmatic access—users log in with AD credentials. (3) RDS SQL Server with Windows Authentication enabled, joined to the AWS Managed AD domain. (4) Users can connect to RDS with their AD credentials (Kerberos). Single sign-on across all services.
C) Use Cognito User Pools with LDAP federation
D) Sync AD passwords to IAM using a custom Lambda

**Correct Answer: B**
**Explanation:** Unified AD-based access: (1) **AWS Managed Microsoft AD**: Extends on-premises AD to AWS via trust relationship or replication. Provides AD authentication for AWS services. (2) **IAM Identity Center**: Federated with the AD (via AD Connector or direct trust). Users authenticate with AD credentials for: AWS console, CLI (aws sso login), and programmatic access. No separate AWS credentials needed. (3) **RDS SQL Server Windows Auth**: RDS joins the AWS Managed AD domain. Users connect with their AD credentials using Kerberos—same credentials as on-premises SQL Server access. (4) **Single identity**: One AD user, one password, access to AWS console + API + RDS. Option A creates duplicate identities. Option C is for customer/external identities. Option D is a security anti-pattern.

---

### Question 65
A company runs an application that processes large CSV files (1-10 GB each). Files arrive in S3 every hour. The processing involves: parsing, validation, transformation, enrichment (calling external APIs), and writing to RDS. Some files have malformed rows that cause the entire processing job to fail, requiring restart. The architect must make the processing resilient.

A) Use Lambda for processing with retry logic
B) Implement record-level processing with dead-letter handling: (1) S3 Event → Step Functions Distributed Map state that processes each row independently. (2) Each row goes through: parse → validate → transform → enrich → write. (3) Malformed rows are caught by error handling, logged to a dead-letter S3 bucket with the error details, and processing continues for remaining rows. (4) After processing, generate a completion report showing: total rows, successful, failed, with links to failed records for manual review.
C) Use AWS Glue for ETL processing
D) Pre-validate files before processing

**Correct Answer: B**
**Explanation:** Resilient record-level processing: (1) **Step Functions Distributed Map**: Reads the CSV directly from S3 and processes each row as a separate child execution. Malformed rows fail individually without affecting other rows. (2) **Error handling per row**: Each row's processing catches errors (validation failures, API timeouts) and routes them to a dead-letter S3 prefix with the original data + error message. (3) **Continues processing**: Unlike the current all-or-nothing approach, the pipeline processes all valid rows and collects all failures separately. (4) **Completion report**: A final state generates a summary: 1,000,000 rows processed, 999,950 successful, 50 failed (stored in s3://bucket/dead-letter/2024-01-15/). (5) **Retry failed rows**: A separate workflow can retry the dead-letter rows after manual review or API recovery. Option A—Lambda has a 15-minute timeout, insufficient for 10 GB files. Option C provides ETL but less control over per-record error handling. Option D helps but doesn't handle all failure modes.

---

### Question 66
A company needs to serve a machine learning model that has 50 GB of model weights. Loading the model takes 10 minutes. Once loaded, inference takes 50ms. The model serves 100 requests/second during business hours and near-zero overnight. The architect must optimize for both cost and latency.

A) Use SageMaker real-time endpoint with auto-scaling
B) Use SageMaker real-time endpoint with: (1) ml.g5.2xlarge instance with 50 GB model loaded in GPU memory. (2) Auto-scaling with minimum 1 instance (always on during business hours) and scale-to-zero overnight using scheduled scaling. (3) Warm pool of 1-2 instances for rapid scale-out. (4) Use SageMaker Inference Component to share the endpoint instance with multiple models if applicable.
C) Use SageMaker Serverless Inference
D) Use Lambda with the model loaded from S3

**Correct Answer: B**
**Explanation:** For a 50 GB model with 10-minute load time: (1) **Always-on minimum**: At least 1 instance must be running during business hours to avoid 10-minute cold starts. (2) **Scheduled scaling**: Scale to 0 overnight (no traffic, no cost). Scale to 1+ before business hours. (3) **Warm pool**: Pre-initialized instances (model already loaded) that can be activated in seconds for rapid scale-out, avoiding the 10-minute load during traffic spikes. (4) **Inference Component**: If the company has multiple models, share the GPU instance to improve utilization. Option C—Serverless Inference has cold start issues and a 6 GB memory limit (50 GB model won't fit). Option D—Lambda has a 10 GB deployment package limit and 15-minute timeout (insufficient for 50 GB model). Option A doesn't address the cold start from scale-to-zero.

---

### Question 67
A company has a REST API with the following access pattern: 80% of requests hit 20% of the endpoints, and 95% of responses are identical for the same endpoint + query parameters within a 5-minute window. The API processes 50,000 requests/second. Current architecture: CloudFront → API Gateway → Lambda → DynamoDB. Monthly cost: $100,000. The architect must reduce costs by 60%.

A) Optimize Lambda memory allocation
B) Implement aggressive caching at every layer: (1) CloudFront edge caching with 5-minute TTL for the hot 20% of endpoints (eliminates 76% of requests from reaching API Gateway). (2) API Gateway response cache for remaining cache-eligible requests. (3) Lambda in-memory caching for DynamoDB hot items. Net effect: only ~5% of original requests reach Lambda/DynamoDB. Cost reduction: ~80-85%.
C) Use DynamoDB DAX for all reads
D) Use API Gateway HTTP API (cheaper) instead of REST API

**Correct Answer: B**
**Explanation:** Caching economics at 50K RPS:

**Current**: 50K RPS → all hit Lambda + DynamoDB = $100K/month

**With caching**:
- **CloudFront**: 80% of requests hit hot endpoints. 95% have identical responses. CloudFront serves these from edge. Only 20% of requests (non-hot endpoints) + 5% of hot requests (cache misses) = ~24% pass through. CloudFront costs ~$4K/month for this volume.
- **API Gateway cache**: Catches remaining repeatable requests. Maybe 50% of the 24% = 12% pass through.
- **Lambda/DynamoDB**: Only 12% of original volume = 6K RPS. Cost proportional: ~$12K/month.
- **Total**: ~$16K-20K/month (80% savings, exceeding 60% target)

Option A saves ~10%. Option C saves on DynamoDB reads but not Lambda/API Gateway. Option D saves ~50% on API Gateway costs only (~$15K total).

---

### Question 68
A company has a serverless application using DynamoDB with on-demand pricing. The monthly DynamoDB bill is $40,000. Analysis shows: 90% of reads are for items less than 1 hour old, the table has 500 GB of data, and 400 GB is "cold" data accessed less than once per month. Write patterns are consistent at 10,000 WCU. How should the architect optimize costs?

A) Switch to provisioned capacity with reserved capacity for the consistent write load
B) Implement a tiered architecture: (1) DynamoDB with TTL set to 1 hour for the "hot" table (only stores recent items, ~100 GB). (2) DynamoDB Streams → Lambda → S3 (Parquet) for cold data archival before TTL deletion. (3) Use Athena for ad-hoc queries on cold data in S3. (4) Switch the hot table to provisioned capacity with auto-scaling + reserved capacity for the consistent 10K WCU.
C) Enable DynamoDB auto-scaling
D) Use S3 for all data and ElastiCache for hot data

**Correct Answer: B**
**Explanation:** Cost optimization for the bimodal access pattern:

**Current**: 500 GB on-demand = $40K/month (reads + writes + storage)

**Optimized**:
- **Hot table** (100 GB, DynamoDB provisioned): 10K WCU reserved ($1,680/month) + read capacity for hot data (~$500/month) + 100 GB storage ($25/month) = ~$2,200/month
- **Cold data** (400 GB in S3 Parquet): Storage $9.20/month. Athena queries: occasional, ~$50/month
- **DynamoDB Streams + Lambda** for archival: ~$100/month
- **Total**: ~$2,360/month (94% savings!)

The key insight: 400 GB of rarely-accessed data in DynamoDB costs ~$100/month in storage alone but the provisioned reads for cold data scans are expensive. Moving cold data to S3+Athena eliminates this cost. Option A saves on writes but not on the cold data storage/read costs. Option C is already on-demand (auto-scales). Option D changes the architecture too drastically.

---

### Question 69
A company's microservices architecture has 30 services, each with its own database. A new business requirement needs a report that joins data across 5 services' databases (2 DynamoDB tables, 1 Aurora MySQL, 1 Aurora PostgreSQL, 1 Redshift table). The architect must implement cross-database querying without ETL or data duplication.

A) Build an ETL pipeline to load all data into Redshift
B) Use Amazon Athena Federated Query with data source connectors: (1) Athena DynamoDB connector for the 2 DynamoDB tables. (2) Athena MySQL connector for Aurora MySQL. (3) Athena PostgreSQL connector for Aurora PostgreSQL. (4) Athena Redshift connector for the Redshift table. (5) Write a single SQL query that JOINs across all 5 data sources directly.
C) Use AWS Glue to merge data into a single S3 data lake
D) Use Amazon QuickSight for cross-source reporting

**Correct Answer: B**
**Explanation:** Athena Federated Query enables cross-database JOINs without data movement: (1) **Data source connectors**: Each Lambda-based connector translates Athena SQL into the native database's query language. (2) **Single SQL query**: `SELECT u.name, o.total, p.price FROM dynamodb.users u JOIN aurora_mysql.orders o ON u.id = o.user_id JOIN aurora_pg.products p ON o.product_id = p.id JOIN redshift.analytics a ON ...` (3) **No data duplication**: Data stays in its original database. Queries are pushed down to each source for efficiency. (4) **On-demand**: No infrastructure to manage. Pay per query ($5/TB scanned). (5) **Caveat**: Performance depends on the data volume from each source. For frequent reporting, consider materializing results. Option A requires maintaining an ETL pipeline. Option C also requires ETL. Option D can connect to multiple sources but doesn't provide SQL JOIN capability.

---

### Question 70
A company runs a highly available web application across 3 AZs. During a real AZ outage, they experienced 5 minutes of errors because the ALB continued routing traffic to the failed AZ while health checks detected the failure. The health check configuration: interval 30 seconds, unhealthy threshold 3, healthy threshold 2. Calculate the detection time and optimize for faster failover.

A) Reduce health check interval to 5 seconds
B) Optimize the entire detection + failover chain: (1) Reduce health check interval to 5 seconds. (2) Reduce unhealthy threshold to 2. (3) Detection time: 2 × 5 = 10 seconds worst case. (4) ALB deregistration delay: default is 300 seconds—reduce to 30 seconds for faster target removal. (5) Enable ALB cross-zone load balancing (already default). (6) Pre-scale remaining AZs to handle full load with capacity headroom. (7) Total worst-case failover: ~40 seconds.
C) Use Route 53 health checks instead of ALB health checks
D) Implement application-level AZ awareness

**Correct Answer: B**
**Explanation:** Failover timing analysis:

**Current**: 3 × 30s interval = 90s detection + 300s deregistration delay = ~5-6.5 minutes of errors.

**Optimized**:
- Health check: 5s interval × 2 unhealthy threshold = 10s detection
- Deregistration delay: 30s (allows in-flight requests to complete)
- ALB marks target unhealthy and stops routing new requests
- **Worst case**: 10s detection + 30s deregistration = 40 seconds

**Additional protections**: (6) Pre-scaling: If each AZ handles 33% of traffic, losing one AZ means 50% more load on each remaining AZ. Pre-scale to handle 50% of total capacity per AZ (3 AZs each at 50% = 150% headroom). This prevents cascading failure from overload. Option A alone helps detection but doesn't address deregistration delay. Option C adds DNS caching latency. Option D is complementary.

---

### Question 71
A company wants to build a real-time data pipeline that processes clickstream data, enriches it with user profile data, performs sessionization, and writes results to both a real-time dashboard and a data lake. The pipeline must handle 500,000 events per second with end-to-end latency under 5 seconds. Compare two architectures and choose the best.

Architecture A: Kinesis Data Streams → Lambda → DynamoDB (enrichment) → Kinesis Data Streams → Lambda (sessionization) → DynamoDB (dashboard) + Firehose (S3 data lake)

Architecture B: Amazon MSK → Apache Flink (enrichment + sessionization in a single job) → DynamoDB (dashboard) + S3 (data lake via Flink's S3 sink)

A) Architecture A is better due to serverless operations
B) Architecture B is better: Flink handles enrichment (async I/O for DynamoDB lookups) and sessionization (session windows) in a single job without inter-service communication overhead. At 500K events/second, the Lambda-based architecture would require thousands of concurrent Lambda invocations and has higher per-event overhead. Flink's stateful stream processing is purpose-built for this workload.
C) Both are equally good
D) Neither—use Kinesis Data Analytics SQL

**Correct Answer: B**
**Explanation:** At 500K events/second, Architecture B (Flink) is superior: (1) **Single processing job**: Flink handles enrichment + sessionization in one streaming application. No serialization/deserialization between stages. (2) **Stateful processing**: Session windows are natively supported in Flink—no external state management. (3) **Async I/O**: Flink's async I/O operator for DynamoDB enrichment lookups is more efficient than Lambda's synchronous calls. (4) **Cost**: Flink on managed service processes 500K events/second with a moderate cluster (~$3K/month). Architecture A at 500K Lambda invocations/second would cost ~$15K+/month in Lambda alone. (5) **Latency**: Single Flink job has lower end-to-end latency than multi-stage Kinesis → Lambda → Kinesis chains. Architecture A works for lower volumes (<50K events/second) where serverless simplicity outweighs performance.

---

### Question 72
A company migrates their monitoring stack to AWS. They currently use Prometheus for metrics, Grafana for dashboards, and Jaeger for tracing. They want to keep the same tools but reduce operational overhead. What AWS-managed alternatives should they use?

A) CloudWatch for everything
B) Amazon Managed Service for Prometheus (AMP) for metrics collection, Amazon Managed Grafana (AMG) for dashboards, and AWS X-Ray for distributed tracing. ADOT (AWS Distro for OpenTelemetry) as the unified collection agent replacing Prometheus exporters and Jaeger agents.
C) Keep self-managed Prometheus/Grafana/Jaeger on EC2
D) Use Datadog or New Relic as a SaaS replacement

**Correct Answer: B**
**Explanation:** Managed replacements preserving tooling familiarity: (1) **AMP**: Fully managed Prometheus. Same PromQL queries, same Prometheus data model. No cluster management. Integrates with existing Prometheus remote_write configurations—minimal migration effort. (2) **AMG**: Fully managed Grafana. Import existing Grafana dashboards directly. SSO integration. Supports AMP, CloudWatch, X-Ray as data sources. (3) **X-Ray**: Managed distributed tracing. While not Jaeger-compatible at the API level, ADOT provides a Jaeger-compatible receiver that forwards to X-Ray, enabling gradual migration. (4) **ADOT**: Single agent replaces Prometheus node_exporter + Jaeger agent. Supports OpenTelemetry protocol (OTLP) for future-proofing. Option A loses Prometheus/Grafana compatibility. Option C doesn't reduce operational overhead. Option D is valid but the question implies staying within AWS.

---

### Question 73
A company's infrastructure team manages 500 CloudFormation stacks across 20 accounts. Stack updates frequently fail due to: resource conflicts, parameter mismatches, and dependency ordering issues. Rollbacks take 30+ minutes, during which the environment is in an inconsistent state. The architect must improve deployment reliability.

A) Switch from CloudFormation to Terraform
B) Implement: (1) CloudFormation Change Sets for every update—preview changes before applying. (2) Stack policies to prevent accidental replacement/deletion of critical resources. (3) Nested stacks with clear dependency ordering. (4) CloudFormation drift detection before updates to identify manual changes. (5) Import manually created resources into stacks. (6) Use CDK for more expressive and testable infrastructure code with built-in best practices.
C) Use smaller, more focused CloudFormation stacks
D) Implement manual approval for all stack changes

**Correct Answer: B**
**Explanation:** CloudFormation reliability improvements: (1) **Change Sets**: Preview exactly what will be added, modified, or deleted before applying. Catches resource conflicts and unexpected replacements. (2) **Stack policies**: `{"Statement": [{"Effect": "Deny", "Action": "Update:Replace", "Principal": "*", "Resource": "LogicalResourceId/ProductionDatabase"}]}` prevents accidental database replacement. (3) **Nested stacks**: Clear dependency ordering via DependsOn and cross-stack references. (4) **Drift detection**: Before updating, detect if resources were modified manually (which causes conflicts). (5) **CDK**: TypeScript/Python code with IDE support catches parameter mismatches at compile time, not deploy time. Unit tests validate infrastructure before deployment. Option A may help with state management but doesn't inherently solve the listed issues. Option C helps reduce blast radius. Option D adds delay without preventing failures.

---

### Question 74
A company has a mission-critical application that must process financial transactions with exactly-once semantics, sub-second latency, and 99.999% availability. They currently use a commercial message queue (IBM MQ) on-premises. The architect must migrate to AWS while maintaining these guarantees. (Select TWO)

A) Use Amazon SQS FIFO with exactly-once processing
B) Use Amazon MQ (ActiveMQ or RabbitMQ) as a managed replacement for IBM MQ, maintaining AMQP protocol compatibility and transactional message handling
C) Use Amazon MSK for Kafka-based messaging with exactly-once semantics (Kafka transactions)
D) Use DynamoDB Streams for event processing
E) Implement idempotent message processing in the consumer application using DynamoDB conditional writes for exactly-once semantics, regardless of the messaging service chosen

**Correct Answer: B, E**
**Explanation:** (B) **Amazon MQ** provides a managed message broker compatible with JMS/AMQP protocols used by IBM MQ. ActiveMQ supports transactional messaging (XA transactions), persistent messages, and message acknowledgment—maintaining the guarantees from IBM MQ. This minimizes migration effort (same protocol, similar configuration). (E) **Application-level idempotency** is essential because no messaging system provides true exactly-once delivery in all failure scenarios. Using DynamoDB conditional writes (check if message ID was already processed) ensures that even if a message is delivered twice, it's only processed once. This is the industry standard for financial transaction processing. Together: MQ provides reliable delivery with transactional guarantees, and application-level idempotency provides the final exactly-once guarantee. Option A—SQS FIFO provides deduplication but not transactional guarantees. Option C could work but requires significant re-architecture.

---

### Question 75
A company is designing their AWS architecture and has a total budget of $50,000/month. They need: a web application serving 10 million page views/month, a REST API handling 5 million requests/month, a database storing 500 GB with 10,000 TPS, real-time analytics, CI/CD pipeline, monitoring, and DR in a second region. The architect must design the most cost-effective architecture that fits within budget while meeting all requirements.

A) Use the most powerful instances for each service
B) Design a cost-optimized architecture:
**Compute**: ECS Fargate Spot for web + API ($3,000/month)
**Database**: Aurora MySQL with reserved instances ($2,000/month)
**CDN**: CloudFront for static assets ($500/month)
**Analytics**: Kinesis Data Firehose → S3 → Athena ($1,000/month)
**CI/CD**: CodePipeline + CodeBuild ($200/month)
**Monitoring**: CloudWatch + X-Ray ($500/month)
**DR**: Aurora Global Database + S3 CRR + pilot light compute ($3,000/month)
**Network**: ALB + NAT Gateway ($1,000/month)
**Other**: KMS, Secrets Manager, WAF ($800/month)
**Total**: ~$12,000/month (76% under budget)
C) Use all serverless services for minimum cost
D) The requirements cannot be met within the $50,000 budget

**Correct Answer: B**
**Explanation:** Well-architected cost-optimized design:

| Component | Service | Monthly Cost |
|-----------|---------|-------------|
| Web/API compute | ECS Fargate (Spot for non-prod, On-Demand for prod) | $3,000 |
| Database | Aurora MySQL (r6g.large reserved, 1yr) | $2,000 |
| CDN | CloudFront (10M page views) | $500 |
| Real-time analytics | Kinesis Firehose → S3, Athena for queries | $1,000 |
| CI/CD | CodePipeline + CodeBuild + CodeDeploy | $200 |
| Monitoring | CloudWatch + X-Ray + Container Insights | $500 |
| DR (second region) | Aurora Global DB + pilot light (min Fargate tasks) | $3,000 |
| Networking | ALB + NAT Gateway + VPC | $1,000 |
| Security | WAF + KMS + Secrets Manager + Shield Standard | $800 |
| **Total** | | **~$12,000** |

This leaves $38,000/month buffer for traffic growth, additional features, and unexpected costs. The architecture is production-grade with DR, monitoring, and security. Option A wastes budget on oversized resources. Option C—full serverless may not be cheapest at this scale (Lambda at 5M requests can be more expensive than Fargate). Option D underestimates—$50K/month is generous for this workload.

---

## Answer Key

| Q | Answer | Q | Answer | Q | Answer | Q | Answer | Q | Answer |
|---|--------|---|--------|---|--------|---|--------|---|--------|
| 1 | B | 16 | B | 31 | B | 46 | B | 61 | B |
| 2 | B,D | 17 | C | 32 | B | 47 | A | 62 | B |
| 3 | B | 18 | B | 33 | C | 48 | B | 63 | B |
| 4 | A | 19 | A,B,D | 34 | B | 49 | B | 64 | B |
| 5 | B | 20 | B | 35 | B | 50 | B | 65 | B |
| 6 | D | 21 | B | 36 | B | 51 | B | 66 | B |
| 7 | B | 22 | C | 37 | A | 52 | A | 67 | B |
| 8 | B | 23 | B | 38 | B | 53 | B | 68 | B |
| 9 | B | 24 | B | 39 | B | 54 | B | 69 | B |
| 10 | B | 25 | B | 40 | B | 55 | B | 70 | B |
| 11 | C | 26 | A | 41 | C | 56 | B | 71 | B |
| 12 | B | 27 | B | 42 | B | 57 | B | 72 | B |
| 13 | B | 28 | B | 43 | B | 58 | B | 73 | B |
| 14 | B | 29 | D | 44 | B | 59 | B | 74 | B,E |
| 15 | B | 30 | B | 45 | B | 60 | B | 75 | B |

### Domain Distribution
- **Domain 1** (Organizational Complexity): Q1, Q3, Q8, Q11, Q14, Q19, Q26, Q37, Q40, Q42, Q47, Q48, Q50, Q58, Q59, Q64, Q72, Q73, Q74 → 19 questions
- **Domain 2** (New Solutions): Q4, Q6, Q9, Q12, Q15, Q18, Q22, Q23, Q27, Q28, Q30, Q31, Q35, Q38, Q39, Q43, Q49, Q53, Q60, Q61, Q65, Q71 → 22 questions
- **Domain 3** (Continuous Improvement): Q7, Q13, Q16, Q20, Q25, Q29, Q41, Q45, Q51, Q52, Q70 → 11 questions
- **Domain 4** (Migration & Modernization): Q2, Q15, Q36, Q44, Q46, Q52, Q57, Q62, Q66 → 9 questions
- **Domain 5** (Cost Optimization): Q5, Q10, Q17, Q21, Q24, Q33, Q34, Q43, Q54, Q56, Q63, Q67, Q68, Q75 → 13 questions
