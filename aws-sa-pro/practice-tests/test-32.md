# AWS Certified Solutions Architect - Professional (SAP-C02) Practice Test 32

## Disaster Recovery Deep Dive (All 4 Strategies, RPO/RTO Calculations, Failover Automation, DRS, Route 53 ARC)

**Time Limit: 180 minutes | 75 Questions | Passing Score: 75%**

---

### Question 1
A financial trading company runs its primary workload in us-east-1 with an RDS Multi-AZ MySQL database (200 GB), an Auto Scaling group of EC2 instances behind an ALB, and an ElastiCache Redis cluster. The company requires an RPO of 1 hour and an RTO of 4 hours. The monthly DR budget is $500. Which DR strategy best meets these requirements?

A) Multi-site active-active with full infrastructure in us-west-2
B) Warm standby with a scaled-down version of the production environment in us-west-2
C) Pilot light with RDS cross-region read replica, pre-configured AMIs, and launch templates in us-west-2
D) Backup and restore with automated daily backups to S3 with cross-region replication

**Correct Answer: C**
**Explanation:** Pilot light meets the RPO of 1 hour (RDS cross-region read replica provides continuous replication with near-zero RPO) and RTO of 4 hours (infrastructure can be launched from pre-configured AMIs and launch templates in minutes to hours). The cost is minimal—primarily the RDS read replica (~$100-200/month for a small instance) and minimal storage costs, fitting within the $500 budget. Option A (multi-site) costs thousands per month as it runs full production in both regions. Option B (warm standby) runs continuously, exceeding the $500 budget. Option D (backup and restore) meets the budget but with daily backups, RPO could be up to 24 hours, exceeding the 1-hour requirement.

---

### Question 2
A healthcare company has the following production environment: 10 EC2 instances (m5.2xlarge) running a Java application, an Aurora PostgreSQL cluster (r5.2xlarge writer + 2 readers), 5 TB of S3 data, and an ElastiCache Redis cluster (3 nodes). They need an RPO of 15 minutes and RTO of 30 minutes. Calculate the approximate monthly cost difference between warm standby and multi-site active-active strategies.

A) Warm standby: ~$3,000/month; Multi-site: ~$12,000/month; Difference: ~$9,000/month
B) Warm standby: ~$5,000/month; Multi-site: ~$15,000/month; Difference: ~$10,000/month
C) Warm standby: ~$1,500/month; Multi-site: ~$12,000/month; Difference: ~$10,500/month
D) Both strategies cost approximately the same because data replication dominates costs

**Correct Answer: A**
**Explanation:** Warm standby runs a scaled-down version: maybe 2 EC2 instances (m5.large ~$70/month each = $140), 1 Aurora instance (r5.large ~$200/month), smaller ElastiCache (1 node ~$100/month), plus data transfer (~$100/month). Total ~$3,000/month including data replication, NAT, etc. Multi-site active-active mirrors production: 10 EC2 (10 × $280 = $2,800), Aurora cluster ($800), ElastiCache ($300), plus Global Accelerator, data sync. Total ~$12,000/month. The difference is approximately $9,000/month. Option D is wrong—compute costs dominate, not data replication. Both meet RPO/RTO requirements, but multi-site provides near-zero RTO vs. warm standby's minutes of scaling time.

---

### Question 3
A company uses AWS Elastic Disaster Recovery (DRS) to replicate 50 on-premises VMware servers to AWS. During a DR test, they discover that 5 servers failed to launch because the AMIs were based on an older kernel version incompatible with the target EC2 instance types. The architect needs to prevent this issue in future DR tests.

A) Use DRS launch settings to specify compatible instance types for each source server and conduct regular DR drills
B) Manually update kernel versions on all on-premises servers before running DR tests
C) Use DRS post-launch actions to run scripts that update kernels after instance launch
D) Switch from DRS to CloudEndure Migration for better compatibility

**Correct Answer: A**
**Explanation:** DRS launch settings allow you to specify the target EC2 instance type, subnet, security groups, and other launch parameters for each source server. By selecting compatible instance types and conducting regular DR drills (using the non-disruptive test feature), you can identify and resolve compatibility issues before an actual disaster. DRS supports testing without impacting ongoing replication. Option B is a manual process that may not be feasible for all servers and doesn't address the root cause in the DR configuration. Option C is risky—if the kernel is incompatible, the instance may not boot at all, preventing post-launch scripts from running. Option D—CloudEndure Migration is for one-time migrations, not ongoing DR.

---

### Question 4
A company has a three-tier web application in us-east-1 using Route 53, CloudFront, ALB, EC2 Auto Scaling, and Aurora MySQL. They need to implement a disaster recovery solution in eu-west-1 with automatic failover. The RTO requirement is 5 minutes for the web tier and 15 minutes for the database tier. Which architecture achieves this?

A) Aurora Global Database with us-east-1 as primary, Route 53 health checks with failover routing policy, pre-provisioned ALB and Auto Scaling group in eu-west-1 at minimum capacity
B) Aurora cross-region read replica, manual DNS update to the eu-west-1 endpoint when disaster is detected
C) RDS automated backups with cross-region copy, CloudFormation StackSets to deploy infrastructure in eu-west-1 on demand
D) Aurora Global Database with us-east-1 as primary, Global Accelerator with automatic failover, fully scaled infrastructure in eu-west-1

**Correct Answer: A**
**Explanation:** Aurora Global Database replicates data to eu-west-1 with typically sub-second replication lag. During failover, the secondary cluster can be promoted to primary in under a minute (meeting the 15-minute database RTO). Route 53 health checks monitor the us-east-1 ALB and automatically failover DNS to eu-west-1 ALB when unhealthy (meets 5-minute web tier RTO with TTL consideration). Pre-provisioned ALB and Auto Scaling group at minimum capacity (warm standby) scale up during failover. Option B requires manual intervention, violating the automatic failover requirement. Option C has an RTO of hours due to infrastructure deployment and backup restoration. Option D would work but running fully scaled infrastructure in both regions is unnecessarily expensive when warm standby meets the RTO.

---

### Question 5
A company's DR plan requires failover from us-east-1 to us-west-2. They use Route 53 with health checks and failover routing. During a test, they discover that Route 53 health checks pass even though the application is returning HTTP 500 errors because the health check is configured to check port 443 TCP connectivity, not HTTP response codes. How should the architect fix this?

A) Change the Route 53 health check to HTTP/HTTPS type with string matching that validates the response body contains a specific health indicator
B) Use CloudWatch alarms based on ALB 5xx metrics as a calculated health check in Route 53
C) Implement a dedicated /health endpoint that checks all dependencies and configure Route 53 to check this endpoint
D) Both A and C together provide the most reliable health checking

**Correct Answer: D**
**Explanation:** The most reliable approach combines both: (C) implement a /health endpoint that checks all critical dependencies (database connectivity, cache availability, external API health) and returns HTTP 200 only when all dependencies are healthy; (A) configure Route 53 health check as HTTP/HTTPS type targeting this /health endpoint with string matching to verify the response body (e.g., checking for "status":"healthy"). String matching ensures that even if the endpoint returns HTTP 200, it validates the actual content, protecting against proxy or load balancer responses that might mask failures. Option B is complementary but has delay (CloudWatch alarm evaluation periods add latency to failover).

---

### Question 6
A company must achieve an RPO of zero (no data loss) for their mission-critical database running on Amazon Aurora PostgreSQL. They currently use Aurora Global Database with a secondary region. During a regional outage simulation, they measured 800ms of replication lag, meaning up to 800ms of committed transactions could be lost. How can the architect achieve true zero RPO?

A) Use Aurora Global Database with write forwarding enabled in the secondary region
B) Use synchronous replication by deploying Aurora Multi-AZ across regions
C) Implement application-level synchronous writes to both regions using a distributed transaction coordinator
D) Accept that true zero RPO across regions is impractical due to physics (speed of light); instead, use Aurora Global Database with managed planned failover (zero data loss for planned failovers) and implement application-level transaction logging to S3 with cross-region replication for gap recovery during unplanned failovers

**Correct Answer: D**
**Explanation:** True zero RPO across geographically distant regions is physically impossible for synchronous replication without unacceptable latency (speed of light imposes ~30-60ms round-trip between US regions). Aurora Global Database provides sub-second RPO for unplanned failovers and zero data loss for planned failovers (managed planned failover waits for replication to catch up). For the ~800ms gap during unplanned failovers, implement application-level transaction logging to S3 (with cross-region replication) to recover the gap. Option A—write forwarding still uses async replication. Option B—Aurora doesn't support cross-region synchronous Multi-AZ. Option C—application-level distributed transactions add extreme latency and complexity.

---

### Question 7
A company has a multi-region active-active architecture with DynamoDB Global Tables. Users in us-east-1 and eu-west-1 both read and write to their local tables. During peak hours, they observe conflict resolution issues where two users in different regions update the same item simultaneously, and the "last writer wins" resolution causes data inconsistency. How should the architect handle this?

A) Switch to a single-region DynamoDB table with a global DAX cluster to maintain consistency
B) Implement application-level conflict resolution by adding a version attribute and using conditional writes with optimistic locking
C) Use DynamoDB transactions across regions to ensure consistency
D) Partition data by region so that each item is "owned" by one region, with cross-region reads using the Global Table replica

**Correct Answer: D**
**Explanation:** Data partitioning by ownership region eliminates cross-region write conflicts entirely. Each data item has a "home region" based on the user's geography, and only that region writes to it. Other regions read from their local Global Table replica (eventually consistent). This is the most scalable pattern for active-active architectures. Option B (optimistic locking) helps but still has conflicts that must be retried, and cross-region propagation delay makes it unreliable. Option A defeats the purpose of multi-region active-active. Option C—DynamoDB transactions don't work across regions in Global Tables.

---

### Question 8
A company's production environment in us-east-1 includes 200 EC2 instances across 15 Auto Scaling groups, 5 RDS instances, 3 Aurora clusters, 10 ElastiCache clusters, and various other resources. They need to replicate this entire environment to us-west-2 for DR. The architect must choose the most maintainable approach for keeping the DR environment in sync with production changes.

A) Use CloudFormation StackSets with parameters for region-specific configurations to deploy and maintain identical infrastructure in both regions
B) Manually create the DR environment and document all configuration differences
C) Use AWS Backup with cross-region copy for all supported services and CloudFormation for infrastructure
D) Use Terraform with workspaces and modules parameterized by region to maintain both environments from a single codebase

**Correct Answer: A**
**Explanation:** CloudFormation StackSets deploy and maintain stacks across multiple regions from a single template. Region-specific configurations (VPC IDs, subnet IDs, AMI IDs) are parameterized. When production infrastructure changes (new Auto Scaling groups, modified instance types), updating the StackSet propagates changes to both regions automatically. This ensures the DR environment stays in sync with production. Option B is error-prone and doesn't scale. Option C handles data backup but not infrastructure configuration synchronization. Option D is viable but the question asks about AWS-native solutions, and StackSets provide native multi-region management. Both A and D are valid in practice.

---

### Question 9
A company needs to implement a disaster recovery strategy for their Amazon EKS cluster running 50 microservices. The cluster uses EBS-backed persistent volumes, application configurations stored in ConfigMaps and Secrets, and Helm charts for deployments. The architect must design the DR strategy.

A) Use Velero (formerly Heptio Ark) to back up Kubernetes resources and persistent volumes, store backups in S3 with cross-region replication, and restore to an EKS cluster in the DR region
B) Replicate the EKS control plane using AWS's built-in multi-region EKS support
C) Back up only the Helm charts and values files to S3, and redeploy from scratch in the DR region
D) Use EKS Anywhere in the DR region with manually synchronized configurations

**Correct Answer: A**
**Explanation:** Velero is the industry-standard tool for Kubernetes cluster backup and disaster recovery. It backs up all Kubernetes resources (deployments, services, ConfigMaps, Secrets, PVCs) and can snapshot EBS volumes used by persistent volume claims. Storing backups in S3 with cross-region replication ensures availability in the DR region. The DR EKS cluster can be pre-provisioned (pilot light) and Velero restores the complete application state. Option B—EKS doesn't have built-in multi-region replication for the data plane (workloads and storage). Option C loses runtime state, ConfigMaps, Secrets, and persistent data. Option D—EKS Anywhere is for on-premises/edge, not cloud DR.

---

### Question 10
A company runs a stateful application on EC2 instances with data stored on EBS volumes. They use AWS Elastic Disaster Recovery (DRS) for continuous replication to a DR region. The RPO is under 1 second (continuous replication). During a failover test, the RTO was 25 minutes because EC2 instances took time to launch and the application needed 15 minutes to warm up. The target RTO is 10 minutes. How can the architect reduce the RTO?

A) Use DRS recovery instance pre-provisioning to have instances ready in a stopped state, and optimize the application startup with pre-built AMIs and reduced warm-up procedures
B) Switch from DRS to native EBS snapshot cross-region copy for faster recovery
C) Increase the EC2 instance types in the DR region for faster boot times
D) Use DRS with a warm standby configuration that keeps instances running in the DR region

**Correct Answer: A**
**Explanation:** DRS supports launch templates and pre-configured instance settings that can speed up instance provisioning. More importantly, optimizing the application warm-up (pre-loading caches, pre-compiling code, using faster startup frameworks) reduces the 15-minute warm-up. Pre-built AMIs with all software pre-installed eliminate post-launch configuration time. Together these can bring RTO under 10 minutes. Option B would increase RTO—EBS snapshots have point-in-time recovery (worse RPO) and require manual instance provisioning. Option C—larger instances don't significantly reduce OS boot times. Option D would work but keeping instances running continuously increases costs significantly.

---

### Question 11
A company uses Route 53 Application Recovery Controller (ARC) for their multi-region application. They have routing controls for us-east-1 and eu-west-1. During a partial outage in us-east-1 (application tier is down but database tier is up), an engineer accidentally disabled both routing controls, causing a global outage. How should the architect prevent this?

A) Implement Route 53 ARC safety rules: a minimum of one routing control must always be enabled (assertion rule), preventing all-off scenarios
B) Use IAM policies to restrict who can modify routing controls
C) Implement a Lambda function that monitors routing control states and automatically re-enables if both are disabled
D) Use Route 53 health checks instead of ARC for automatic failover

**Correct Answer: A**
**Explanation:** Route 53 ARC safety rules are specifically designed to prevent dangerous configurations. An assertion rule can enforce that at least one routing control is always "On," preventing the all-off scenario that caused the global outage. If someone tries to turn off the last active routing control, the API rejects the request. This is a built-in guardrail. Option B restricts access but doesn't prevent authorized engineers from making mistakes. Option C adds delay—the global outage would occur before the Lambda detects and fixes it. Option D—health checks provide automatic failover but ARC provides the control to perform planned failovers and manage complex multi-region routing.

---

### Question 12
A company must design a DR solution for their Amazon Redshift data warehouse (50 TB). The RPO requirement is 4 hours and RTO is 8 hours. The data warehouse receives batch loads every 6 hours. Which is the most cost-effective DR approach?

A) Enable Redshift cross-region snapshots to automatically copy snapshots to the DR region every 4 hours, and restore the cluster in the DR region when needed
B) Maintain a running Redshift cluster in the DR region with data replication via Redshift data sharing
C) Use S3 cross-region replication for the source data and rebuild the Redshift cluster from raw data in the DR region
D) Use Redshift concurrency scaling in the DR region for automatic failover

**Correct Answer: A**
**Explanation:** Redshift cross-region snapshots automatically copy snapshots to the DR region at a configured interval (every 4 hours meets the RPO). The snapshot copy is incremental, reducing transfer costs. During DR, restore the cluster from the latest snapshot (Redshift provisioning + data restoration takes 2-6 hours for 50 TB, meeting 8-hour RTO). Cost is minimal—only S3 storage for snapshots in the DR region. Option B maintains a running cluster ($thousands/month for 50 TB). Option C requires rebuilding and reloading 50 TB, likely exceeding the 8-hour RTO. Option D—concurrency scaling doesn't provide cross-region DR.

---

### Question 13
A company has an active-active multi-region deployment in us-east-1 and ap-southeast-1. They use Global Accelerator for traffic routing. User data must stay within the user's geographic region for data sovereignty compliance. How should the architect handle failover when one region goes down, given that data cannot be replicated cross-region?

A) During failover, route all traffic to the surviving region but serve degraded functionality (read-only mode with cached data) for users whose data is in the failed region
B) Use Global Accelerator with geographic routing to prevent failover for users in the affected region
C) Replicate all data cross-region but encrypt with region-specific KMS keys that can only be used in the designated region
D) Use CloudFront with geographic restrictions to block access from the failed region's users

**Correct Answer: A**
**Explanation:** When data sovereignty prevents cross-region replication, full failover isn't possible for users whose data resides in the failed region. The best approach is graceful degradation: route traffic to the surviving region but provide limited functionality (read-only from caches, queuing writes for later processing when the failed region recovers). Users whose data is in the surviving region get full functionality. This maintains service availability while respecting data sovereignty. Option B—preventing failover means complete outage for affected users. Option C—even with separate keys, moving encrypted data cross-region may violate data residency laws. Option D blocks users entirely, which is worse than degraded service.

---

### Question 14
A company is implementing DR for a serverless application consisting of API Gateway, Lambda functions, DynamoDB tables, SQS queues, and Step Functions. The architect needs to design the DR strategy. Which components require active replication and which can be redeployed from code?

A) DynamoDB tables require active replication (Global Tables); all other components (API Gateway, Lambda, SQS, Step Functions) are redeployed from infrastructure-as-code in the DR region
B) All components must be actively replicated across regions for fast failover
C) Only Lambda functions need replication; everything else is stateful and needs backup/restore
D) DynamoDB and SQS queues require active replication; API Gateway and Lambda are deployed from code

**Correct Answer: A**
**Explanation:** In serverless architectures, the key distinction is stateless vs. stateful components. DynamoDB is the stateful component holding application data—it requires active replication via Global Tables for low RPO. API Gateway, Lambda, SQS, and Step Functions are defined in infrastructure-as-code (CloudFormation/SAM/CDK) and can be deployed identically in the DR region from the same templates. Lambda code is stored in S3/deployment packages. The DR region should have these resources pre-deployed (pilot light) but DynamoDB Global Tables handle the data replication. Option B wastes resources replicating stateless services. Option C is incorrect—Lambda is stateless. Option D—SQS queues don't need replication; they're recreated empty in the DR region.

---

### Question 15
A company has a disaster recovery plan that's triggered by a CloudWatch alarm when the primary region's health score drops below a threshold. The alarm triggers a Step Functions workflow that performs the following DR activities: promote Aurora read replica, update Route 53 records, scale up EC2 instances, clear ElastiCache, and send notifications. During a test, the Step Functions workflow took 18 minutes to complete, exceeding the 15-minute RTO. Which step is likely the bottleneck, and how can it be optimized?

A) Aurora read replica promotion (5-10 minutes); optimize by using Aurora Global Database switchover instead of read replica promotion
B) Route 53 DNS propagation (10+ minutes); optimize by reducing TTL to 60 seconds before potential failovers
C) EC2 scaling (10+ minutes); optimize by using pre-provisioned warm standby instances instead of scaling from zero
D) All steps are sequential; optimize by running Aurora promotion, EC2 scaling, and ElastiCache clearing in parallel using a Step Functions Parallel state

**Correct Answer: D**
**Explanation:** The biggest optimization is parallelization. Aurora promotion (3-10 minutes), EC2 scaling (5-10 minutes), and ElastiCache operations are independent and can run simultaneously using a Step Functions Parallel state. If these run sequentially, times add up to 18+ minutes. In parallel, the total DR time is limited by the slowest parallel step (likely EC2 scaling at 5-10 minutes). Additionally, Route 53 updates and notifications can run in parallel with other steps. This reduces overall RTO to within 15 minutes. Options A, B, and C each address individual bottlenecks but don't solve the fundamental issue of sequential execution.

---

### Question 16
A company uses Amazon S3 for storing 100 TB of regulatory documents with a 7-year retention requirement. They need DR protection for this data. The compliance team requires that the DR copy be in a different region and that deleted files in the primary bucket must be recoverable for at least 30 days. What is the most cost-effective approach?

A) S3 Cross-Region Replication (CRR) to a bucket in the DR region using S3 Glacier Deep Archive storage class, with S3 Versioning and lifecycle rules to retain deleted object versions for 30 days
B) AWS Backup for S3 with cross-region copy and a 30-day retention policy
C) Daily S3 Batch Operations job to copy objects to the DR region
D) S3 Same-Region Replication with S3 Object Lock for deletion protection

**Correct Answer: A**
**Explanation:** CRR to Glacier Deep Archive provides the most cost-effective cross-region DR for 100 TB. Glacier Deep Archive costs ~$0.00099/GB/month (~$100/month for 100 TB). S3 Versioning enables recovery of deleted objects, and lifecycle rules automatically delete old versions after 30 days to control costs. CRR handles continuous replication. Option B (AWS Backup for S3) works but costs more due to backup storage pricing vs. Glacier Deep Archive. Option C doesn't provide continuous replication and daily copies mean up to 24-hour RPO. Option D uses same-region replication, which doesn't satisfy the cross-region DR requirement.

---

### Question 17
A company has an RTO of 1 hour and needs to failover a complex application with 30+ AWS services including EC2, RDS, ElastiCache, Elasticsearch, SQS, SNS, and various Lambda functions. They are concerned about the order of service recovery during failover. Which approach ensures correct recovery sequencing?

A) Document a runbook with manual steps and train the operations team
B) Use AWS Resilience Hub to define the application structure, assess resilience, and generate recovery procedures with correct sequencing
C) Create a Step Functions workflow that recovers services in the correct order with health checks between steps
D) Use CloudFormation stack dependencies to control recovery order

**Correct Answer: C**
**Explanation:** A Step Functions workflow provides automated, ordered recovery with explicit dependencies. For example: (1) Promote RDS/Aurora first (data tier), (2) Wait for health check, (3) Restore ElastiCache/Elasticsearch, (4) Scale EC2 instances, (5) Update DNS, (6) Verify application health. Each step includes health checks and retry logic. The workflow is testable and repeatable. Option A relies on humans under pressure during a disaster. Option B—Resilience Hub assesses and recommends but doesn't execute recovery. Option D—CloudFormation deploys resources but doesn't handle live failover of running services.

---

### Question 18
During a disaster recovery test, a company discovers that their Aurora Global Database failover to the secondary region succeeded, but the application couldn't connect because the database endpoint changed. The application uses hardcoded connection strings. How should the architect redesign the connection management for DR resilience?

A) Use Amazon RDS Proxy in both regions with the same endpoint name via Route 53 CNAME, so the application always connects to the same DNS name
B) Store the database endpoint in AWS Systems Manager Parameter Store and have the application read it at startup; update the parameter during failover
C) Use Route 53 private hosted zone with a CNAME record pointing to the active Aurora cluster endpoint; during failover, update the CNAME to point to the new primary
D) Use Aurora Global Database's reader/writer endpoint which automatically updates during failover

**Correct Answer: C**
**Explanation:** A Route 53 private hosted zone CNAME (e.g., db.internal.company.com) provides a stable DNS name for the application. In normal operation, it points to the us-east-1 Aurora writer endpoint. During failover, the CNAME is updated to point to the eu-west-1 promoted writer endpoint. Applications use the stable CNAME and don't need code changes or restarts (with appropriate connection pooling and DNS TTL). Option A—RDS Proxy doesn't natively work cross-region with the same endpoint. Option B requires application restarts to pick up the new endpoint. Option D—Aurora cluster endpoints are region-specific and don't automatically cross-region redirect; the global database cluster endpoint changes after promotion.

---

### Question 19
A company needs to test their DR plan without impacting production. Their DR environment uses AWS Elastic Disaster Recovery (DRS) for EC2 instances and Aurora Global Database for the database. How should they conduct a non-disruptive DR drill?

A) Use DRS drill functionality to launch test instances from replicated data without stopping replication, and create an Aurora clone in the DR region from the Global Database secondary for database testing
B) Failover the entire environment to the DR region, test, and then fail back to the primary
C) Create a separate VPC in the DR region and manually replicate a subset of data for testing
D) Use DRS to launch test instances and point them to the production Aurora Global Database secondary

**Correct Answer: A**
**Explanation:** DRS provides a dedicated "drill" feature that launches recovery instances from the latest replication data without interrupting ongoing replication. The production environment remains unaffected. For Aurora, creating a clone from the Global Database secondary provides a separate, writable copy for testing without affecting the secondary's replication role. Together, these enable full-fidelity DR testing with zero production impact. Option B is disruptive to production during the failover/failback. Option C doesn't test the actual DR infrastructure. Option D would send test traffic to the production database, potentially causing issues.

---

### Question 20
A company's disaster recovery plan involves failing over from us-east-1 to us-west-2. Their application uses Amazon Cognito for user authentication. After failover, users report they can't log in. What is the issue and how should the architect resolve it?

A) Cognito User Pools are regional; create a second User Pool in us-west-2 and implement custom Lambda triggers to synchronize user data between regions
B) Use Cognito Identity Pools with federation to a global identity provider (e.g., corporate SAML IdP) so authentication works in any region
C) Enable Cognito User Pool cross-region replication
D) Use API Gateway with a custom authorizer backed by DynamoDB Global Tables to store session data across regions

**Correct Answer: B**
**Explanation:** Cognito User Pools are regional and don't support native cross-region replication (Option C doesn't exist). The most architecturally sound solution is federating authentication through a global identity provider (corporate SAML/OIDC IdP, or a third-party service like Auth0/Okta). Both regions' Cognito Identity Pools (or User Pools) are configured to federate with the same IdP. Users authenticate against the IdP (which is globally available) regardless of which region they're routed to. Option A creates a synchronization challenge for user credentials and MFA settings. Option D replaces Cognito entirely, which is heavy-handed.

---

### Question 21
A company runs a critical workload in a single AZ in us-east-1 due to a legacy application that requires all components on the same subnet for low-latency communication. A recent AZ outage caused 8 hours of downtime. The company wants to reduce the impact of AZ failures with minimal application changes. What should the architect recommend?

A) Implement Elastic Disaster Recovery (DRS) with a target AZ in a different AZ within us-east-1, configured for automatic failover
B) Redesign the application for multi-AZ deployment using placement groups for low latency
C) Use an EBS Multi-Attach volume shared across AZs for stateful components
D) Deploy the application in a cluster placement group within a single AZ, but implement automated recovery with CloudWatch alarms and Lambda to re-launch in a different AZ using pre-configured AMIs and EBS snapshots

**Correct Answer: D**
**Explanation:** Since the application requires same-subnet/same-AZ deployment (minimal changes constraint), the best option is automated AZ recovery. Cluster placement group provides low-latency communication within the AZ. CloudWatch alarms detect instance/AZ failures, Lambda automates launching instances in a different AZ from the latest EBS snapshots and AMIs. The application re-assembles in the new AZ. Option A—DRS is designed for cross-region DR, not cross-AZ within the same region. Option B requires application redesign, violating the "minimal changes" constraint. Option C—EBS Multi-Attach works only within the same AZ, not cross-AZ.

---

### Question 22
A company's DR strategy involves Route 53 failover routing to a secondary region. The Route 53 health check monitors the primary ALB endpoint. The health check interval is 30 seconds, with a failure threshold of 3. After the health check fails, DNS TTL is 60 seconds. Calculate the worst-case time from failure to traffic routing to the secondary region.

A) 90 seconds (3 × 30-second intervals)
B) 150 seconds (90 seconds for health check failure + 60 seconds DNS TTL)
C) 210 seconds (90 seconds for health check + 60 seconds DNS propagation + 60 seconds client-side DNS cache)
D) 30 seconds (first health check failure triggers immediate failover)

**Correct Answer: B**
**Explanation:** Worst-case calculation: Health check failure detection = 3 failures × 30-second interval = 90 seconds (worst case: failure occurs just after a successful check, then 3 consecutive failures). DNS TTL expiry = 60 seconds (clients using cached DNS continue hitting the old endpoint until TTL expires). Total worst case: 90 + 60 = 150 seconds. However, option C adds "client-side DNS cache" which is uncontrollable. The standard calculation for Route 53 failover timing is health check detection + DNS TTL, which is 150 seconds. Note: Route 53 also offers fast health check intervals of 10 seconds, which could reduce detection to 30 seconds.

---

### Question 23
A company operates a video streaming platform with content stored in S3 and served via CloudFront. Their DR requirement is that users should continue streaming during a regional S3 outage. How should the architect implement DR for the content delivery layer?

A) Configure CloudFront with an origin failover group: primary origin in us-east-1 S3, secondary origin in us-west-2 S3, with S3 Cross-Region Replication
B) Use CloudFront edge caching with increased TTL to serve content from cache during the S3 outage
C) Use MediaStore as the primary origin with built-in redundancy
D) Replicate content to multiple S3 buckets in different regions and use Route 53 latency-based routing

**Correct Answer: A**
**Explanation:** CloudFront origin failover groups provide automatic failover between origins. Configure a primary origin (us-east-1 S3) and secondary origin (us-west-2 S3 with CRR-replicated content). If the primary origin returns 5xx errors or times out, CloudFront automatically routes requests to the secondary origin—transparent to users. This handles regional S3 outages seamlessly. Option B relies on cache hits—new or uncached content would fail. Option C—MediaStore is for live/on-demand video but doesn't provide multi-region failover. Option D adds complexity with Route 53 for what CloudFront handles natively.

---

### Question 24
A company is calculating the total cost of their DR strategy. Their production environment costs $50,000/month. They're considering four DR strategies. Estimate the steady-state monthly DR cost for each:
1) Backup & Restore
2) Pilot Light
3) Warm Standby
4) Multi-Site Active-Active

A) 1: ~$500, 2: ~$5,000, 3: ~$15,000, 4: ~$50,000
B) 1: ~$2,500, 2: ~$10,000, 3: ~$25,000, 4: ~$50,000
C) 1: ~$100, 2: ~$2,000, 3: ~$10,000, 4: ~$45,000
D) 1: ~$500, 2: ~$5,000, 3: ~$25,000, 4: ~$50,000

**Correct Answer: A**
**Explanation:** Typical DR cost ratios relative to production: **Backup & Restore (~1% of production)**: ~$500/month for S3 storage of backups and cross-region snapshot copies. **Pilot Light (~10% of production)**: ~$5,000/month for core data-layer services running continuously (database replicas, essential infrastructure). **Warm Standby (~30% of production)**: ~$15,000/month for a scaled-down but functional version of the full environment. **Multi-Site Active-Active (~100% of production)**: ~$50,000/month for a fully scaled duplicate environment (though with active-active, both regions serve traffic, so it's not purely DR cost). These are industry-standard estimates; actual costs vary based on data volume, network transfer, and service mix.

---

### Question 25
A company's application uses Amazon ElastiCache Redis as a session store. During DR failover to the secondary region, all users lose their sessions and must re-authenticate. The company wants sessions to survive regional failover. What should the architect recommend?

A) Use ElastiCache Global Datastore for Redis to replicate session data across regions
B) Switch from ElastiCache to DynamoDB Global Tables for session storage
C) Store sessions in Aurora Global Database instead of Redis
D) Implement client-side session storage (JWT tokens) to eliminate server-side session dependency

**Correct Answer: A**
**Explanation:** ElastiCache Global Datastore for Redis provides cross-region replication with sub-second lag. Session data written in the primary region is automatically replicated to the secondary region. During failover, the secondary region's ElastiCache already has all session data, so users remain authenticated. Option B works but changes the session store technology, requiring application changes and potentially higher read latency compared to Redis. Option C—using a relational database for session storage adds unnecessary latency. Option D is a valid alternative architecture but changes the authentication model significantly and has JWT-specific security considerations (token revocation).

---

### Question 26
A company needs to implement DR for their Amazon MSK (Kafka) cluster. They process 10 GB/hour of event data that must be replayed in the DR region during failover. The RPO requirement is 30 minutes. What is the recommended approach?

A) Use MSK Replicator to continuously replicate topics, consumer groups, and topic configurations from the primary to the DR region's MSK cluster
B) Configure Kafka MirrorMaker 2 on EC2 instances to replicate data between MSK clusters in different regions
C) Write all Kafka data to S3 via MSK Connect and use S3 cross-region replication
D) Use MSK Serverless in both regions with a shared storage layer

**Correct Answer: A**
**Explanation:** Amazon MSK Replicator is a fully managed feature that replicates data across MSK clusters in different regions. It replicates topic data, consumer group offsets, and topic configurations with minimal lag (well under 30-minute RPO). It's operationally simpler than self-managed MirrorMaker. During failover, consumers in the DR region resume from the replicated consumer group offsets, minimizing reprocessing. Option B works but requires managing EC2 instances and MirrorMaker configuration. Option C adds latency and doesn't replicate consumer offsets. Option D—MSK Serverless doesn't have shared cross-region storage.

---

### Question 27
A company wants to implement automated DR testing that runs monthly. The test should: (1) launch the DR environment, (2) run integration tests against the DR environment, (3) measure RTO and RPO, (4) generate a report, and (5) tear down the DR test environment. How should this be automated?

A) Use AWS Systems Manager Automation runbooks triggered by EventBridge scheduled rules to orchestrate the entire DR test lifecycle
B) Use a Step Functions workflow triggered monthly by EventBridge Scheduler, with states for each DR test phase, writing metrics to CloudWatch and generating reports via Lambda
C) Create a Jenkins pipeline that runs monthly and orchestrates DR testing
D) Use AWS Resilience Hub's scheduled assessments for automated DR testing

**Correct Answer: B**
**Explanation:** Step Functions provides visual orchestration of the multi-phase DR test: (1) launch DRS drill/Aurora clone, (2) run integration tests via Lambda/CodeBuild, (3) collect timing metrics (RTO achieved, RPO measured) and publish to CloudWatch, (4) generate a report (Lambda writes to S3 or sends via SES), (5) tear down resources. EventBridge Scheduler triggers it monthly. The workflow handles errors, timeouts, and provides execution history for audit. Option A works but SSM Automation has less flexibility for complex orchestration. Option C requires managing Jenkins infrastructure. Option D—Resilience Hub provides recommendations and assessments but doesn't execute actual failover tests.

---

### Question 28
A company has an application that uses Amazon MQ (ActiveMQ) as a message broker. Messages in the broker must not be lost during a regional disaster. The current setup is a single-broker deployment in us-east-1. What DR strategy should the architect implement for the message broker?

A) Use Amazon MQ active/standby deployment with a standby broker in another AZ, and implement a network of brokers with a forwarding bridge to a broker in the DR region
B) Switch to Amazon SQS which handles multi-AZ redundancy automatically
C) Back up the Amazon MQ configuration and message store to S3 with cross-region replication
D) Use Amazon MQ with EFS storage for message persistence and EFS cross-region replication

**Correct Answer: A**
**Explanation:** Amazon MQ active/standby provides high availability within a region. For cross-region DR, ActiveMQ's "network of brokers" feature creates a forwarding bridge to a broker in the DR region. Messages are forwarded in near real-time, ensuring minimal message loss. If the primary region fails, consumers connect to the DR region's broker. Option B changes the messaging technology, which may require significant application changes (different protocol: AMQP/MQTT vs SQS API). Option C—message store backups are point-in-time and may lose recent messages (poor RPO). Option D—Amazon MQ doesn't use EFS for storage, and EFS replication isn't suitable for message broker persistence.

---

### Question 29
A company discovers during a DR drill that their failover takes 45 minutes instead of the target 15 minutes. The breakdown: Aurora Global Database promotion (2 min), DNS propagation (3 min), EC2 instance launch (8 min), application deployment on new instances (15 min), cache warming (17 min). Which TWO optimizations would have the greatest impact on reducing RTO? (Select TWO)

A) Use pre-baked AMIs with the application already installed and configured to eliminate the 15-minute deployment step
B) Reduce Route 53 TTL from 300 seconds to 60 seconds
C) Implement lazy cache loading with a cache-aside pattern instead of pre-warming, with stale read fallback to the database
D) Switch from Aurora Global Database to RDS cross-region read replica
E) Use larger EC2 instance types for faster boot times

**Correct Answer: A, C**
**Explanation:** The two largest contributors are application deployment (15 min) and cache warming (17 min). (A) Pre-baked AMIs eliminate the 15-minute deployment by including the application, dependencies, and configuration in the AMI itself. Instances launch directly into a ready state. (C) Lazy cache loading eliminates the 17-minute cache warming by loading cache entries on-demand when requested. Initial requests go to the database (slightly slower) but the cache fills naturally during operation. Combined savings: ~32 minutes, bringing RTO to ~13 minutes. Option B saves only 4 minutes (300s → 60s TTL). Option D would likely increase promotion time. Option E has minimal impact—boot times differ by seconds, not minutes.

---

### Question 30
A gaming company operates a real-time multiplayer game with servers in us-east-1. The game state is stored in-memory on EC2 instances and synchronized across instances using Redis Pub/Sub. During a regional outage, the company loses all active game sessions. The company wants to minimize game session loss during regional disasters. What should the architect recommend?

A) Periodically checkpoint game state to DynamoDB Global Tables every 30 seconds, and restore from the latest checkpoint in the DR region
B) Use ElastiCache Global Datastore for Redis to replicate game state cross-region in real-time
C) Stream game state changes to Kinesis Data Streams with cross-region replication, replaying the stream in the DR region to reconstruct game state
D) Accept game session loss as unavoidable for real-time gaming and implement a "reconnect with compensation" feature that gives affected players in-game rewards

**Correct Answer: A**
**Explanation:** Periodic checkpointing to DynamoDB Global Tables provides a balance between data protection and performance. A 30-second checkpoint interval means maximum 30 seconds of game state loss, which is acceptable for most games (players lose at most 30 seconds of progress). DynamoDB Global Tables replicate to the DR region with sub-second latency. On failover, the DR region's game servers load the latest checkpoint and resume. Option B replicates all Redis Pub/Sub traffic cross-region, which is expensive and high-bandwidth for real-time game state. Option C adds complexity and latency. Option D may be acceptable for some games but the question asks to minimize loss.

---

### Question 31
A company's multi-region application uses Amazon S3 for storing user-uploaded files. They have S3 Cross-Region Replication (CRR) from us-east-1 to eu-west-1. During a DR test, they notice that objects uploaded to us-east-1 take up to 15 minutes to appear in eu-west-1. The application in eu-west-1 returns 404 errors for recently uploaded files. How should the architect address this replication lag?

A) Enable S3 Replication Time Control (S3 RTC) to replicate 99.99% of objects within 15 minutes, and implement application-level fallback to read from the primary region if the object isn't found in the secondary
B) Use S3 Multi-Region Access Points to automatically route requests to the region with the data
C) Switch from eventual consistency to strong consistency for S3 reads
D) Increase the S3 bucket's provisioned throughput for faster replication

**Correct Answer: B**
**Explanation:** S3 Multi-Region Access Points (MRAP) combined with CRR provide the best solution. MRAP automatically routes GET requests to the closest region that has the data. If an object exists only in us-east-1 (not yet replicated), MRAP routes the read to us-east-1 transparently. Once replicated, reads from eu-west-1 are served locally. This eliminates 404 errors during replication lag. Option A provides SLA guarantees on replication time but doesn't eliminate the lag window. Option C—S3 strong read-after-write consistency is for the same region, not cross-region replication. Option D—S3 doesn't have provisioned throughput for replication.

---

### Question 32
A company needs to implement DR for a complex application that spans AWS and on-premises data centers. The on-premises components include Windows and Linux servers, Oracle databases, and NFS file servers. The cloud components include EC2, RDS, and S3. What combination of tools provides comprehensive DR coverage?

A) AWS Elastic Disaster Recovery (DRS) for on-premises servers, RDS cross-region read replicas for databases, and S3 cross-region replication for object storage
B) AWS Backup for all components using its unified backup framework
C) VMware Site Recovery for on-premises VMs and AWS-native tools for cloud components
D) AWS Elastic Disaster Recovery (DRS) for on-premises servers, Oracle Data Guard for Oracle databases, and AWS DataSync for NFS file replication, plus AWS-native tools for cloud components

**Correct Answer: D**
**Explanation:** A comprehensive hybrid DR strategy uses specialized tools for each component: DRS continuously replicates on-premises Windows/Linux servers to AWS. Oracle Data Guard provides real-time database replication for Oracle databases (DRS can't replicate databases at the application level). AWS DataSync replicates NFS file data to AWS (S3 or EFS). For cloud components: RDS cross-region replicas, S3 CRR, etc. Option A doesn't address Oracle database replication properly (RDS cross-region replicas don't work for on-premises Oracle). Option B—AWS Backup doesn't cover on-premises servers. Option C only addresses VMware VMs, not the full stack.

---

### Question 33
A company runs an application on EC2 instances behind an ALB in us-east-1. They want to implement a "warm standby" DR strategy in us-west-2. During failover, they need to scale the warm standby from 2 instances to 20 instances (production size). They're concerned about the scaling time. How can the architect ensure fast scaling?

A) Pre-register 20 instances in the Auto Scaling group with desired capacity of 2, so 18 instances are in standby and can be quickly activated
B) Use EC2 Auto Scaling predictive scaling to anticipate the load increase during failover
C) Use EC2 Auto Scaling warm pools with pre-initialized instances in a stopped state, allowing them to start (not launch + initialize) during failover
D) Use Spot instances for the additional 18 instances to save cost during scaling

**Correct Answer: C**
**Explanation:** Auto Scaling warm pools maintain a pool of pre-initialized instances in a stopped state. During a scale-out event (failover), these instances only need to start (seconds) rather than launch and initialize (minutes). The application is already installed and configured on these stopped instances. This dramatically reduces scaling time from 10-15 minutes to 1-2 minutes. Option A wastes resources by running 20 instances (even in standby, they consume capacity). Option B—predictive scaling doesn't help with sudden DR failover events. Option D—Spot instances can be interrupted, which is unacceptable during a disaster recovery event.

---

### Question 34
A company has a disaster recovery incident. During failover, they successfully promoted the Aurora Global Database secondary to primary in eu-west-1. After the disaster in us-east-1 is resolved, they need to fail back. The Aurora cluster in us-east-1 is no longer available. What is the correct failback procedure?

A) Delete the old Aurora cluster in us-east-1, create a new Aurora Global Database with eu-west-1 as primary and add us-east-1 as a secondary region, then perform a planned failover back to us-east-1
B) Restore the us-east-1 Aurora cluster from the most recent automated backup and reconfigure replication
C) Use Aurora's switchback feature to automatically reverse the replication direction
D) Create a cross-region read replica from eu-west-1 to us-east-1 and promote it when ready

**Correct Answer: A**
**Explanation:** After an unplanned failover, the original primary (us-east-1) is detached from the Global Database. The correct failback procedure is: (1) Delete or clean up the old us-east-1 cluster. (2) Add us-east-1 as a new secondary region to the Aurora Global Database (now primary in eu-west-1). This creates a new replica in us-east-1 from the current primary. (3) Once replication is caught up, perform a managed planned failover to switch the primary back to us-east-1. Option B risks data loss—automated backups in us-east-1 are from before the disaster, missing all writes during the DR period. Option C—there's no automatic "switchback" feature. Option D creates a standalone replica, not a Global Database secondary.

---

### Question 35
A company wants to use AWS Resilience Hub to assess their application's resilience posture. Their application consists of 3 microservices, each with its own CloudFormation stack, deployed across 2 AZs. The company's RTO target is 1 hour and RPO target is 15 minutes. After running the assessment, Resilience Hub reports that the application meets the AZ-level resilience policy but fails the region-level policy. What does this mean and what should the architect do?

A) The application can survive an AZ failure within the RTO/RPO targets but cannot survive a regional failure; add cross-region replication for data stores and deploy infrastructure templates in a second region
B) The application's AZ configuration is correct but the region configuration is wrong; fix the region settings
C) The assessment is incorrect because multi-AZ implies regional resilience
D) The application needs more AZs (at least 3) to meet regional resilience

**Correct Answer: A**
**Explanation:** Resilience Hub evaluates resilience against different failure scenarios: infrastructure, AZ, and region. Passing AZ-level means the application survives a single AZ failure (Multi-AZ deployments). Failing region-level means no cross-region recovery capability. The architect should: add cross-region data replication (Aurora Global Database, S3 CRR, DynamoDB Global Tables), deploy infrastructure-as-code in a DR region (pilot light or warm standby), and configure DNS failover. After implementing, re-run the Resilience Hub assessment to verify regional resilience. Option C is wrong—multi-AZ does not protect against regional outages. Option D—more AZs don't provide regional protection.

---

### Question 36
A company has a stateful legacy application that stores session data on the local file system of EC2 instances. The application cannot be modified to use external session stores. During an AZ failure, sessions are lost. For DR, they also need cross-region session survival. How should the architect handle this constraint?

A) Use Amazon EFS (mounted on EC2 instances) for session storage, with EFS cross-region replication to the DR region
B) Use EBS Multi-Attach volumes shared across instances in the same AZ, with EBS snapshot cross-region copy
C) Use EC2 Instance Store with periodic rsync to the DR region
D) Use a network file system like FSx for Windows File Server with multi-AZ deployment and cross-region backup

**Correct Answer: A**
**Explanation:** Amazon EFS can be mounted on EC2 instances as a regular file system, so the legacy application writes session data to what it perceives as a local path (actually an EFS mount point). EFS is multi-AZ within a region, surviving AZ failures. EFS replication provides cross-region replication to the DR region's EFS file system, enabling session recovery after regional failover. The application requires no code changes—just a mount point change. Option B—EBS Multi-Attach only works within a single AZ and doesn't help with AZ or region failures. Option C—Instance Store is ephemeral and lost on any instance stop/failure. Option D works for Windows workloads but adds unnecessary complexity for Linux-based applications.

---

### Question 37
A company implements a multi-region active-active architecture using Global Accelerator for traffic routing. During normal operations, traffic is distributed 60% to us-east-1 and 40% to eu-west-1 based on endpoint weights. They want to simulate a regional failover by shifting all traffic to eu-west-1 without actually causing an outage in us-east-1. How can they test this?

A) Set the us-east-1 endpoint weight to 0 in Global Accelerator, shifting all traffic to eu-west-1
B) Remove the us-east-1 endpoints from Global Accelerator temporarily
C) Use Global Accelerator traffic dials to set us-east-1 to 0% and eu-west-1 to 100%
D) Make the us-east-1 health checks fail artificially to trigger automatic failover

**Correct Answer: C**
**Explanation:** Global Accelerator traffic dials allow you to control the percentage of traffic routed to each endpoint group (region) without modifying health checks or weights. Setting us-east-1 to 0% gradually shifts all traffic to eu-west-1, simulating a failover. This is non-disruptive, reversible, and specifically designed for testing and failover scenarios. You can gradually increase us-east-1 back to 60% after testing. Option A—changing endpoint weights within an endpoint group doesn't stop traffic to the entire group. Option B is disruptive and requires reconfiguration to revert. Option D causes alarms and triggers incident response processes for a fake outage.

---

### Question 38
A company needs to calculate the cost of downtime to justify their DR investment. Their application generates $1 million in revenue per hour. The current mean time to recovery (MTTR) is 4 hours, and they experience an average of 2 outages per year. What is the annual cost of downtime, and how does investing $500,000/year in DR to reduce MTTR to 30 minutes compare?

A) Current cost: $8M/year; With DR: $1M/year; Net savings: $7M/year; DR investment is justified with 14x ROI
B) Current cost: $8M/year; With DR: $1M/year; Net savings: $6.5M/year after DR cost; DR investment is justified
C) Current cost: $4M/year; With DR: $500K/year; Net savings: $3M/year after DR cost; DR investment is justified
D) Current cost: $8M/year; With DR: $1M/year; The ROI analysis should also include indirect costs like reputation damage and customer churn

**Correct Answer: D**
**Explanation:** Current downtime cost: $1M/hour × 4 hours × 2 outages = $8M/year. With DR: $1M/hour × 0.5 hours × 2 outages = $1M/year. Direct savings: $7M - $500K DR investment = $6.5M net savings. However, the complete analysis should include indirect costs: reputation damage, customer churn, regulatory fines, SLA penalties, employee productivity loss, and recovery effort costs. These indirect costs can be 5-10x the direct revenue loss. The total business impact makes the DR investment even more clearly justified. Options A, B, and C only consider direct revenue loss.

---

### Question 39
A company uses AWS CloudFormation to manage their infrastructure. During a DR failover test to eu-west-1, the CloudFormation stack deployment fails because the AMI IDs referenced in the templates are region-specific (us-east-1 AMIs don't exist in eu-west-1). How should the architect make the CloudFormation templates DR-ready?

A) Use CloudFormation mappings with region-specific AMI IDs, maintaining AMIs in both regions through an automated AMI copy pipeline
B) Use AWS Systems Manager Parameter Store to store AMI IDs per region and reference them in CloudFormation using dynamic references
C) Use the latest Amazon Linux 2 AMI from the SSM public parameter (/aws/service/ami-amazon-linux-latest) which is available in all regions
D) Both A and B are valid approaches; B is more maintainable for frequently updated AMIs

**Correct Answer: D**
**Explanation:** Both approaches work: (A) CloudFormation Mappings with a RegionMap provide a static, version-controlled approach—deploy an AMI copy pipeline (e.g., EventBridge rule triggered by AMI creation → Lambda → ec2:CopyImage to DR region → update Mapping). (B) SSM Parameter Store with dynamic references ({{resolve:ssm:/ami/production/web-server}}) is more maintainable—the AMI copy pipeline updates the parameter in each region, and CloudFormation reads the latest value during deployment. For frequently updated custom AMIs (CI/CD pipelines producing new AMIs), SSM parameters (B) are more maintainable. For stable base AMIs, Mappings (A) work well. Option C only works for base Amazon Linux, not custom application AMIs.

---

### Question 40
A company is evaluating whether to use AWS Elastic Disaster Recovery (DRS) or native AWS services for DR. Their environment has 100 EC2 instances with a mix of Windows and Linux, using various instance types and EBS volume configurations. They need continuous replication with RPO under 1 second. What are the key advantages of DRS over building custom replication?

A) DRS provides block-level continuous replication, automated server conversion, non-disruptive testing, and point-in-time recovery—all managed, vs custom solutions requiring agents, scripts, and monitoring
B) DRS is cheaper than native EBS snapshot-based replication
C) DRS supports cross-cloud DR (Azure to AWS) which native services don't
D) DRS provides sub-second RPO through synchronous replication

**Correct Answer: A**
**Explanation:** DRS advantages for this scenario: (1) Block-level continuous replication provides sub-second RPO without application-level changes. (2) Automated server conversion handles Windows/Linux differences, driver injection, and instance type mapping. (3) Non-disruptive drill testing launches test instances without affecting replication. (4) Point-in-time recovery allows recovering to a specific moment (useful for ransomware scenarios). (5) Fully managed—no custom agents, scripts, or monitoring. Building equivalent custom solutions would require significant engineering effort. Option B—DRS has its own costs. Option C—DRS doesn't support cross-cloud (it replicates to AWS from on-premises, VMware, or other cloud VMs). Option D—DRS uses asynchronous replication (sub-second RPO, not synchronous).

---

### Question 41
A company's application uses Amazon API Gateway with a custom domain name (api.example.com). During DR failover, they need the API endpoint to automatically switch to the DR region. How should the architect configure this?

A) Use Route 53 with a CNAME record for api.example.com pointing to the API Gateway custom domain, with health checks and failover routing between the two regional API Gateway deployments
B) Deploy API Gateway edge-optimized endpoints in both regions with CloudFront automatically handling failover
C) Use a single API Gateway endpoint with a Lambda function that routes to the appropriate region
D) Use Global Accelerator to route traffic to the active API Gateway endpoint

**Correct Answer: A**
**Explanation:** Configure API Gateway regional endpoints in both regions, each with the same custom domain name (api.example.com) configured through ACM certificates. In Route 53, create failover routing records for api.example.com: primary record points to us-east-1 API Gateway, secondary record points to eu-west-1 API Gateway. Health checks on the primary trigger automatic failover to the secondary. Option B—edge-optimized endpoints create region-specific CloudFront distributions that don't fail over to each other. Option C—a single API Gateway can't route cross-region. Option D could work but adds complexity and cost when Route 53 failover handles this natively for API Gateway.

---

### Question 42
A company is required by their auditors to prove that their DR plan works. They must conduct quarterly DR tests and provide evidence of: (1) successful failover, (2) RTO achieved, (3) RPO achieved, (4) data integrity verification, and (5) successful failback. How should the architect implement auditable DR testing?

A) Use AWS Step Functions to orchestrate DR tests, log all steps to CloudWatch Logs, publish RTO/RPO metrics to CloudWatch Metrics, store test results and screenshots in S3, and generate compliance reports
B) Conduct manual DR tests with an operations team and have them fill out compliance forms
C) Use AWS Resilience Hub scheduled assessments as proof of DR capability
D) Run chaos engineering experiments with AWS Fault Injection Simulator and use the results as DR evidence

**Correct Answer: A**
**Explanation:** Automated, auditable DR testing requires: Step Functions orchestrates the full test lifecycle with timestamps for each phase (enabling RTO calculation). Data integrity verification (e.g., checksum comparison between source and recovered data) proves RPO. All steps are logged to CloudWatch Logs with timestamps for audit trail. Metrics published to CloudWatch provide quantitative evidence. Reports stored in S3 (with versioning and Object Lock for tamper-proofing) serve as audit evidence. This provides repeatable, automated evidence that satisfies auditor requirements. Option B is error-prone and not repeatable. Option C provides assessment, not actual failover proof. Option D tests failure injection, not full DR failover.

---

### Question 43
A company runs a real-time data analytics pipeline: Kinesis Data Streams → Lambda → DynamoDB → API Gateway → Dashboard. They need DR for the entire pipeline. Which components need active replication vs. cold standby?

A) Active replication: DynamoDB (Global Tables); Cold standby: Kinesis, Lambda, API Gateway (deploy from CloudFormation); Data re-ingestion from source after failover
B) Active replication: All components—Kinesis, Lambda, DynamoDB, API Gateway running in both regions simultaneously
C) Active replication: DynamoDB and Kinesis; Cold standby: Lambda and API Gateway
D) No replication needed—rebuild everything from CloudFormation and replay data from S3

**Correct Answer: A**
**Explanation:** The key insight is separating stateful (data) from stateless (compute/routing) components: **DynamoDB** holds the persistent analytics data—Global Tables provide active replication. **Kinesis, Lambda, API Gateway** are stateless/compute resources—deploy from CloudFormation in the DR region (pilot light or warm standby). After failover, Kinesis starts receiving data from producers (redirected via DNS/endpoint configuration), Lambda processes it, and DynamoDB already has historical data from Global Tables replication. Option B wastes money running the full pipeline in both regions. Option C—Kinesis streams don't need active replication since they process real-time data. Option D loses all historical analytics data during recovery.

---

### Question 44
A company uses AWS Organizations with 50 accounts. Each account runs workloads that need DR. The architect must implement a centralized DR management approach. Which strategy provides the best governance and visibility?

A) Deploy AWS Elastic Disaster Recovery (DRS) in each account independently and monitor via CloudWatch dashboards in the management account
B) Use AWS Backup with a backup policy at the Organization level to enforce backup and cross-region copy for all accounts, with a centralized backup vault in a dedicated backup account
C) Designate a central DR account, use AWS RAM to share DR-related resources, and deploy a Step Functions-based DR orchestrator in the central account
D) Use AWS Resilience Hub in each account with centralized reporting through AWS Security Hub integration

**Correct Answer: B**
**Explanation:** AWS Backup with Organization-level backup policies provides centralized governance: backup policies defined in the management account are automatically enforced across all 50 accounts. Cross-region copy rules ensure DR backups exist in the secondary region. A centralized backup vault in a dedicated account provides audit access and prevents individual accounts from deleting backups. AWS Backup supports RDS, DynamoDB, EFS, EBS, S3, and more. This provides consistent, auditable DR across the organization without per-account management. Option A lacks centralized governance. Option C requires complex custom development. Option D provides assessment but not backup management.

---

### Question 45
A company's primary region (us-east-1) experiences a catastrophic failure. Their DR region (us-west-2) activates successfully. After 3 days, us-east-1 recovers. The company needs to fail back to us-east-1. During the 3 days, users wrote 50 GB of new data to the DR region's DynamoDB Global Table. What is the failback procedure for DynamoDB?

A) No special procedure needed—DynamoDB Global Tables automatically replicate in all directions; once us-east-1 recovers, it automatically catches up with the writes from us-west-2
B) Export the DynamoDB table from us-west-2, import it to us-east-1, and switch traffic back
C) Use DynamoDB Streams to replay the 3 days of changes from us-west-2 to us-east-1
D) Delete the us-east-1 table and re-create the Global Table with us-east-1 as a new replica

**Correct Answer: A**
**Explanation:** DynamoDB Global Tables use multi-active (multi-master) replication. When us-east-1 recovers and the Global Table replica reconnects, it automatically synchronizes with all changes made in us-west-2 during the outage. The replication catches up without manual intervention. Once synchronization is complete (verify via CloudWatch metrics for ReplicationLatency), traffic can be shifted back to us-east-1. No export/import or manual replay is needed. This is a key advantage of Global Tables for DR. Option B is unnecessary and causes downtime. Option C is manual and error-prone. Option D deletes potentially valuable data.

---

### Question 46
A company has an RPO of 4 hours for their RDS PostgreSQL database (500 GB). They are evaluating two options: (A) Automated snapshots every 4 hours with cross-region copy, or (B) RDS cross-region read replica with continuous async replication. Compare the costs and RPO guarantees.

A) Option A: ~$50/month (snapshot storage + transfer), RPO exactly 4 hours; Option B: ~$500/month (running replica), RPO near-zero
B) Option A: ~$25/month, RPO up to 8 hours (snapshot could be 4 hours old plus 4 hours before next snapshot); Option B: ~$500/month, RPO seconds
C) Option A: ~$50/month, RPO guarantee of 4 hours; Option B: ~$300/month, RPO seconds but requires manual promotion during failover
D) Option A: ~$100/month, strict 4-hour RPO; Option B: ~$500/month, near-zero RPO with automatic failover

**Correct Answer: C**
**Explanation:** **Option A (Snapshots):** RDS automated snapshots are free for storage up to the DB size. Cross-region copy costs ~$0.02/GB for transfer ($10) + incremental storage. Custom automation (Lambda + CloudWatch Events) creates snapshots every 4 hours. RPO guarantee: exactly 4 hours (worst case: failure occurs 3:59 after the last snapshot, so almost 4 hours of data loss). Cost: ~$50/month with transfer and storage. **Option B (Read Replica):** A db.r5.xlarge cross-region read replica costs ~$300/month. Replication lag is typically seconds (near-zero RPO). However, during failover, the read replica must be manually promoted to a standalone instance (no automatic failover for cross-region replicas). Option D is wrong—cross-region read replicas don't provide automatic failover.

---

### Question 47
A company implements a DR solution where Route 53 health checks trigger automated failover. During a network partition event (not a full outage), Route 53 health checkers in some regions can reach the primary endpoint but others cannot. This causes the health check to flap between healthy and unhealthy. What should the architect do to prevent unnecessary failovers?

A) Increase the health check failure threshold from 3 to 5 and use multiple health check locations
B) Configure a Route 53 calculated health check that requires at least 70% of child health checks (across multiple regions) to be unhealthy before triggering failover
C) Use CloudWatch Alarm-based health checks instead of endpoint health checks, using metrics that are resilient to network partitions
D) Both B and C are valid complementary approaches

**Correct Answer: D**
**Explanation:** Both approaches address the flapping problem: (B) Calculated health checks aggregate results from multiple child health checks. Requiring 70% (or a custom threshold) of checkers to report unhealthy prevents failover due to localized network issues—if only some Route 53 checker regions can't reach the endpoint, the calculated health check remains healthy. (C) CloudWatch Alarm-based health checks use metrics collected within the application's VPC (e.g., ALB HealthyHostCount, application-level metrics) which are not affected by network partitions between Route 53 checkers and the endpoint. Together, they provide robust failover decisions. Option A alone still suffers from flapping with network partitions.

---

### Question 48
A company needs to implement DR for an application that uses AWS PrivateLink (VPC endpoints) to connect to third-party SaaS services. During regional failover, the VPC endpoint services are unavailable in the DR region. How should the architect handle this?

A) Pre-create VPC endpoints in the DR region pointing to the same SaaS service (SaaS providers typically offer endpoint services in multiple regions)
B) Use AWS Transit Gateway Inter-Region peering to route VPC endpoint traffic from the DR region to the primary region's VPC endpoint
C) Switch from PrivateLink to public internet endpoints during DR
D) Contact the SaaS provider and request them to deploy PrivateLink endpoint services in the DR region

**Correct Answer: A**
**Explanation:** Most major SaaS providers that offer AWS PrivateLink endpoint services deploy them in multiple regions. The architect should verify availability in the DR region and pre-create VPC endpoints as part of the DR infrastructure setup. The application uses the local VPC endpoint DNS name, which resolves to the local regional endpoint. This should be validated during DR drills. Option B routes traffic cross-region, adding latency and defeating the purpose of regional DR (if the primary region is down, the endpoint service there is also down). Option C changes the security model and may violate compliance requirements. Option D is an action item, not a solution—and is not needed if the provider already supports the DR region.

---

### Question 49
A company is building a disaster recovery solution for a machine learning inference endpoint running on Amazon SageMaker. The model serves real-time predictions for a customer-facing application. Model artifacts are stored in S3 and the model takes 10 minutes to load into memory. The RTO requirement is 5 minutes. What should the architect recommend?

A) Use SageMaker multi-region endpoint with automatic failover
B) Deploy SageMaker endpoints in both regions (active-active), use Route 53 latency-based routing, and keep model artifacts in both regions via S3 CRR
C) Store model artifacts in both regions and use SageMaker Serverless Inference in the DR region for instant scale-from-zero
D) Pre-deploy SageMaker endpoints in both regions but set the DR region's endpoint to minimum instance count, with auto-scaling to handle failover traffic

**Correct Answer: B**
**Explanation:** With a 10-minute model load time and 5-minute RTO, the model must already be loaded in the DR region. Active-active SageMaker endpoints in both regions (each serving a portion of traffic via Route 53 latency-based routing) ensure the model is always warm and ready. During failover, Route 53 shifts all traffic to the surviving region. S3 CRR ensures model artifacts are available for endpoint scaling. Option A doesn't exist—SageMaker doesn't have multi-region endpoints. Option C—Serverless Inference has cold start times and may not meet the 5-minute RTO for large models. Option D keeps minimum capacity but during failover, scaling takes time which may exceed RTO.

---

### Question 50
A company runs a financial application that uses an Amazon RDS Oracle database with Oracle Data Guard for real-time replication to an on-premises Oracle database. For their AWS-only DR strategy, they want to maintain a similar setup within AWS. They need cross-region replication with RPO of zero for planned failovers and RPO under 5 seconds for unplanned failovers.

A) Use RDS Oracle with a cross-region read replica (native RDS feature)
B) Run Oracle on EC2 instances in both regions with Oracle Data Guard configured between them, using Oracle Maximum Availability Architecture (MAA)
C) Migrate to Aurora PostgreSQL and use Aurora Global Database for cross-region replication
D) Use AWS DMS for continuous replication from RDS Oracle in the primary region to RDS Oracle in the DR region

**Correct Answer: B**
**Explanation:** For Oracle-specific features like Data Guard with synchronous (zero RPO for planned) and near-synchronous (sub-5-second RPO for unplanned) replication modes, running Oracle on EC2 provides full control over Data Guard configuration, including Oracle MAA (Maximum Availability Architecture) for the highest level of data protection. This mirrors their existing on-premises setup. Option A—RDS Oracle doesn't support cross-region read replicas. Option C requires a database migration away from Oracle, which is a separate major initiative. Option D—DMS provides continuous replication but doesn't offer the zero-RPO guarantee for planned failovers that Oracle Data Guard provides.

---

### Question 51
A company's disaster recovery plan was tested successfully 6 months ago. Since then, the development team has deployed 15 new microservices, added 3 new databases, and modified the network architecture. During a real disaster, the DR failover partially fails because the DR environment doesn't reflect these changes. How should the architect prevent DR drift?

A) Implement DR-as-code: maintain DR infrastructure in the same CI/CD pipeline as production, with automated tests that validate DR configuration matches production after every deployment
B) Schedule quarterly DR reviews to update the DR environment manually
C) Use AWS Config rules to detect configuration drift between regions
D) Require a change management approval process that includes DR updates for every production change

**Correct Answer: A**
**Explanation:** DR-as-code integrates DR infrastructure into the same CI/CD pipeline as production. Every production deployment automatically updates the DR environment through infrastructure-as-code (CloudFormation, Terraform). Automated tests (e.g., comparing resource counts, configurations, and replication status between regions) run after each deployment to catch drift immediately. This ensures DR always matches production. Option B allows 3 months of drift. Option C detects drift but doesn't prevent it. Option D is process-based and relies on humans remembering to update DR—error-prone and slow.

---

### Question 52
A company has a production RDS MySQL database that receives 10,000 write transactions per second. They need to set up a DR read replica in another region. They're concerned about replication lag under this write load. What factors affect cross-region replication lag, and how can the architect minimize it? (Select TWO)

A) Use a larger instance type for the read replica to ensure it can apply the write load without falling behind
B) Enable RDS Performance Insights to monitor replica lag and set CloudWatch alarms on ReplicaLag metric
C) Use RDS Multi-AZ in the DR region for the read replica to improve its write application speed
D) Reduce the number of indexes on the read replica to speed up write application
E) Ensure the source database uses row-based binary logging (binlog_format=ROW) for efficient replication

**Correct Answer: A, B**
**Explanation:** (A) The read replica must have sufficient compute to apply 10,000 write transactions per second. If the replica instance is too small, it can't keep up with the write rate, causing lag to grow. Use an instance type at least as large as the primary. (B) Monitoring is critical—Performance Insights shows replica lag trends, and CloudWatch alarms on ReplicaLag metric alert when lag exceeds acceptable thresholds (RPO boundary). Option C—Multi-AZ on the replica provides HA for the replica itself but doesn't improve replication speed from the primary. Option D—removing indexes on the replica improves write speed but degrades read performance, defeating the purpose. Option E—row-based binlog is actually less efficient for bulk operations than statement-based, but MySQL defaults vary and this isn't the primary optimization.

---

### Question 53
A company's DR automation uses Lambda functions to orchestrate failover. During a real regional outage in us-east-1, the Lambda functions that manage failover are also in us-east-1 and are unavailable. How should the architect redesign the failover automation to be resilient to regional failures?

A) Deploy the failover automation Lambda functions in the DR region (us-west-2), triggered by Route 53 health check status changes via CloudWatch Events in us-west-2
B) Deploy the failover automation in both regions with leader election to prevent dual execution
C) Use a third region (eu-west-1) exclusively for failover automation that monitors both primary and DR regions
D) Use AWS Systems Manager Automation in the management account, which operates independently of any single region

**Correct Answer: A**
**Explanation:** The failover automation must be in the DR region (the one that needs to activate), not the primary region (the one that might fail). Deploy Lambda functions in us-west-2 that monitor us-east-1 health. Route 53 health checks operate from multiple AWS regions globally and continue to function even during a single-region outage. CloudWatch Events in us-west-2 captures the Route 53 health check status change and triggers the failover Lambda. Option B adds complexity with leader election. Option C adds a third region dependency unnecessarily. Option D—SSM Automation runs in a specific region and could be affected by regional outages.

---

### Question 54
A company needs to implement DR for their Amazon Redshift cluster. They run complex ETL jobs that take 6 hours to complete. If they restore from a snapshot in the DR region, they would lose the in-progress ETL results and need to re-run the 6-hour ETL. The RPO requirement is 1 hour. How should the architect minimize recovery time for the ETL workload?

A) Implement checkpoint-based ETL: after each ETL stage completes, write intermediate results to S3, and on recovery, resume from the last completed stage instead of restarting
B) Run the ETL job in both regions simultaneously (active-active) so results are always available
C) Use Redshift Serverless in the DR region for instant availability
D) Increase Redshift snapshot frequency to every 15 minutes

**Correct Answer: A**
**Explanation:** Checkpoint-based ETL breaks the 6-hour job into stages (e.g., 6 one-hour stages). After each stage, intermediate results are persisted to S3 (with cross-region replication). If the primary region fails mid-ETL, the DR region's Redshift cluster (restored from snapshot) resumes from the last checkpoint rather than restarting the entire 6-hour job. Maximum lost work is one stage (1 hour), meeting the RPO requirement. Option B doubles the compute cost and may cause data consistency issues. Option C—Redshift Serverless doesn't automatically receive replicated data. Option D—more frequent snapshots help database RPO but don't save in-progress ETL computation.

---

### Question 55
A company uses Amazon WorkSpaces for 500 desktop users in us-east-1. During a regional disaster, users must be able to continue working from the DR region within 2 hours. User profiles include 50 GB of personalized data per user. What is the most cost-effective DR strategy?

A) Maintain Amazon WorkSpaces in both regions (active-active) for all 500 users and sync profiles using AWS DataSync
B) Use Amazon WorkSpaces cross-region redirection with the WorkSpaces migration feature and store user profiles on Amazon FSx with cross-region backup
C) Pre-configure WorkSpaces bundles and images in the DR region, back up user profiles to S3 with cross-region replication, and use automation to provision WorkSpaces on demand during failover
D) Use Amazon AppStream 2.0 in the DR region as a temporary alternative to WorkSpaces

**Correct Answer: C**
**Explanation:** Pre-configuring WorkSpaces bundles (AMIs with applications installed) and storing user profiles in S3 with CRR provides cost-effective DR. During failover, automation (Step Functions + WorkSpaces API) provisions 500 WorkSpaces from the pre-configured bundles and restores user profiles from S3. With WorkSpaces API automation, 500 desktops can be provisioned within 1-2 hours. Ongoing DR cost is only S3 storage (~$0.023/GB × 25 TB = ~$575/month). Option A costs ~$175,000/month running 500 WorkSpaces in both regions. Option B—WorkSpaces doesn't have native cross-region redirection. Option D provides a different experience than WorkSpaces and may not support all applications.

---

### Question 56
A company's application serves traffic in us-east-1 and uses Route 53 with a 300-second (5-minute) TTL. During a failover event, they observe that some users continue hitting the us-east-1 endpoint for up to 30 minutes after the DNS failover. What causes this, and how should the architect mitigate it?

A) Intermediate DNS resolvers cache beyond the TTL; reduce TTL to 60 seconds and implement application-level health checks that redirect users to the DR region if the primary is down
B) The users' browsers cache DNS; this cannot be controlled server-side
C) Route 53 takes up to 30 minutes to propagate changes; use Global Accelerator instead for instant failover
D) The 300-second TTL means 5 minutes maximum; 30 minutes indicates a different issue

**Correct Answer: A**
**Explanation:** While Route 53 respects TTL, intermediate DNS resolvers (ISP resolvers, corporate DNS servers, OS-level caches) may cache records beyond the specified TTL. Java applications are particularly notorious for caching DNS indefinitely (networkaddress.cache.ttl). Mitigation: (1) Reduce TTL to 60 seconds well before any planned failover. (2) Implement application-level health checks and redirects—if a user reaches the primary region and it detects it's unhealthy, it HTTP-redirects the user to the DR region. (3) Consider Global Accelerator which uses static anycast IP addresses and doesn't depend on DNS caching. Option B partially correct but controllable at the application level. Option C—Route 53 propagation is fast; caching is the issue.

---

### Question 57
A company has a hybrid architecture with an on-premises data center connected to AWS via Direct Connect. Their DR strategy uses AWS as the DR site. During a Direct Connect failure, they lose connectivity to AWS. They need a backup connectivity path for DR purposes. What should the architect recommend?

A) Set up a site-to-site VPN over the internet as a backup to Direct Connect, with automatic failover using BGP routing
B) Provision a second Direct Connect connection from a different Direct Connect location
C) Use AWS Direct Connect SiteLink for backup connectivity
D) Both A and B; use VPN for immediate failover and a second Direct Connect for long-term resilience

**Correct Answer: D**
**Explanation:** A comprehensive connectivity DR strategy uses both: (A) Site-to-site VPN provides immediate backup over the public internet—BGP routing automatically shifts traffic when Direct Connect goes down. VPN setup takes minutes and costs ~$36/month per VPN connection. (B) A second Direct Connect from a different location provides the same bandwidth and latency guarantees as the primary. It protects against single-location failures but takes weeks to provision. Together, VPN provides instant failover while the second DX provides production-grade redundancy. Option C—SiteLink is for connecting on-premises locations through the AWS backbone, not for backup connectivity to AWS.

---

### Question 58
A company needs to implement DR for their containerized application running on Amazon ECS with Fargate. The application uses 20 ECS services across 3 ECS clusters. The application stores data in Aurora and S3. What is the most efficient DR approach for the ECS components?

A) Use AWS Copilot or CDK to define ECS services as code and deploy to both regions; use Aurora Global Database and S3 CRR for data
B) Create ECS task definition backups and service configurations in S3, and rebuild manually during failover
C) Use ECR cross-region replication for container images and deploy ECS services from CloudFormation in the DR region, with Aurora Global Database and S3 CRR
D) Run duplicate ECS clusters in the DR region at full scale

**Correct Answer: C**
**Explanation:** For ECS/Fargate DR: (1) ECR cross-region replication automatically copies container images to the DR region. (2) ECS services, task definitions, and cluster configurations are defined in CloudFormation and can be deployed (or pre-deployed at minimum count) in the DR region. (3) Aurora Global Database handles database DR. (4) S3 CRR handles object storage DR. This approach ensures container images are available in the DR region for immediate deployment. Option A is similar but CDK/Copilot is a specific toolchain preference. Option B requires manual intervention. Option D is expensive for DR. The key differentiator is ECR cross-region replication, which C explicitly includes.

---

### Question 59
A company's application uses AWS Secrets Manager to store database credentials, API keys, and certificates. During DR failover, the application in the DR region needs access to the same secrets. How should the architect handle secrets management across regions?

A) Use Secrets Manager replica secrets with multi-region secret replication to automatically replicate secrets to the DR region
B) Store secrets in S3 with cross-region replication and encrypt with a multi-region KMS key
C) Manually create copies of all secrets in the DR region and maintain synchronization via Lambda
D) Use AWS Systems Manager Parameter Store with cross-region replication

**Correct Answer: A**
**Explanation:** Secrets Manager supports multi-region secret replication natively. When you create a secret, you can specify replica regions. Secrets Manager automatically keeps the secret values synchronized across regions, including during secret rotation. The replicated secrets are accessible via the same secret name in the DR region. KMS encryption in the replica region uses a KMS key in that region. This is the simplest, most reliable approach. Option B is less secure and harder to manage. Option C is error-prone and doesn't handle rotation properly. Option D—SSM Parameter Store doesn't have native cross-region replication.

---

### Question 60
A company has a data lake on S3 with 500 TB of data. They need DR protection but the cost of replicating 500 TB cross-region is prohibitive (estimated $11,500/month for S3 storage alone in Standard tier). How should the architect design a cost-effective DR strategy for the data lake?

A) Use S3 Cross-Region Replication with S3 Glacier Deep Archive storage class in the DR region and S3 Intelligent-Tiering for frequently accessed data
B) Only replicate the last 30 days of data (50 TB) cross-region and store older data in a single region with S3 Versioning
C) Use S3 Cross-Region Replication with Glacier Deep Archive for all data and store the metadata catalog (AWS Glue Data Catalog) in both regions
D) Replace S3 with Amazon Redshift Spectrum which provides built-in multi-region access

**Correct Answer: C**
**Explanation:** Replicating 500 TB to Glacier Deep Archive costs ~$495/month ($0.00099/GB × 500 TB), dramatically cheaper than Standard tier. The Glue Data Catalog (table definitions, partitions, schemas) must also be available in the DR region for querying the data after failover. During DR, data can be accessed from Glacier Deep Archive with bulk retrieval (5-12 hours, cheapest) or standard retrieval (12 hours). For the most critical recent data, use replication rules with storage class overrides (recent data to Standard, older to Deep Archive). Option A doesn't address the metadata catalog. Option B creates an incomplete backup. Option D doesn't address S3 data protection.

---

### Question 61
A company uses Amazon Connect for their contact center in us-east-1. During a regional outage, all customer calls are dropped. The company needs DR for their contact center. Amazon Connect instances are regional. What should the architect recommend?

A) Deploy a second Amazon Connect instance in us-west-2 with identical configuration (call flows, queues, routing profiles), use an external SBC (Session Border Controller) or carrier-level routing to redirect calls to the DR region during failover
B) Use Amazon Connect global resiliency feature which automatically fails over to another region
C) Route calls through Amazon Chime SDK which provides multi-region calling
D) Deploy agents in multiple regions using Amazon WorkSpaces and connect to a single Connect instance

**Correct Answer: A**
**Explanation:** Amazon Connect instances are regional with no built-in cross-region failover. The DR strategy requires: (1) A parallel Connect instance in the DR region with identical configuration (exported/imported via the Connect API or CloudFormation). (2) External call routing at the telephony layer—use the telephony carrier's failover capabilities or a SBC to redirect inbound calls from the primary DID numbers to the DR region's Connect instance. (3) Agent configuration replicated via infrastructure-as-code. Option B—Amazon Connect has introduced global resiliency features, but initially for distributing traffic, not full DR. Option C is not a contact center solution. Option D doesn't solve the Connect instance being unavailable.

---

### Question 62
A company tests their DR plan and measures the following RTO components: detection time (5 min), decision time (10 min), Aurora failover (2 min), EC2 scaling (8 min), DNS propagation (2 min), validation testing (5 min). The measured RTO is 32 minutes but the target is 15 minutes. Which components should the architect optimize FIRST for maximum RTO reduction?

A) Reduce decision time by automating the failover decision based on predefined health criteria (saves 10 minutes)
B) Reduce EC2 scaling time by using warm pools (saves 6 minutes)
C) Reduce detection time by increasing health check frequency (saves 3 minutes)
D) A and B together reduce RTO to approximately 16 minutes, close to the target; add automation of validation to meet the target

**Correct Answer: D**
**Explanation:** Current RTO breakdown: Detection (5) + Decision (10) + Aurora (2) + EC2 (8) + DNS (2) + Validation (5) = 32 min. **Automated decision (A):** Eliminate the 10-minute human decision time by automating failover triggering based on health check criteria → saves 10 min. **EC2 warm pools (B):** Reduce EC2 scaling from 8 min to ~2 min → saves 6 min. **Automated validation:** Reduce from 5 min to ~2 min with automated health checks → saves 3 min. New RTO: 5 + 0 + 2 + 2 + 2 + 2 = 13 min ≤ 15 min target. Option C saves only 3 minutes and requires very frequent health checks. The biggest wins come from automating the human decision and pre-provisioning compute.

---

### Question 63
A company uses Amazon OpenSearch Service (Elasticsearch) for log analytics with 10 TB of active indices. They need DR with an RPO of 1 hour and RTO of 4 hours. What is the most cost-effective DR approach?

A) Use OpenSearch cross-cluster replication to maintain a replica cluster in the DR region
B) Use automated snapshots to S3 with cross-region replication, and restore the OpenSearch domain in the DR region from the snapshot when needed
C) Use OpenSearch Serverless in the DR region with collections backed by replicated S3 data
D) Maintain a full-scale OpenSearch domain in the DR region with real-time index replication

**Correct Answer: B**
**Explanation:** OpenSearch automated snapshots to S3 are created hourly by default (meeting 1-hour RPO). S3 cross-region replication copies snapshots to the DR region. During DR, provision a new OpenSearch domain and restore from the snapshot. Restoration of 10 TB takes 2-3 hours, within the 4-hour RTO. Cost is minimal: only S3 storage for snapshots (~$230/month for 10 TB). Option A (cross-cluster replication) runs a full cluster in both regions—very expensive for 10 TB. Option C—OpenSearch Serverless collections don't restore from traditional snapshots. Option D is the most expensive option with full-scale running infrastructure.

---

### Question 64
A company's DR strategy uses Route 53 ARC (Application Recovery Controller). They have a multi-cell architecture with cells in us-east-1 and us-west-2. Each cell is an independent, full-stack deployment. The architect needs to understand the difference between Route 53 ARC readiness checks and routing controls.

A) Readiness checks verify that the DR environment is properly configured and ready for failover; routing controls manage which cell receives traffic—they serve different phases of DR
B) Readiness checks and routing controls are the same feature with different names
C) Readiness checks monitor application health; routing controls perform automatic failover
D) Readiness checks are for planned failovers; routing controls are for unplanned failovers

**Correct Answer: A**
**Explanation:** Route 53 ARC has two distinct capabilities: **Readiness checks** continuously verify that DR resources are properly configured and ready for failover (e.g., are read replicas in sync, are security groups configured correctly, are enough EC2 instances available). They answer: "If I needed to failover right now, would it work?" **Routing controls** are switches that control Route 53 health check states, determining which cells receive traffic. Together with safety rules (preventing dangerous configurations like all-off), they provide the mechanism to shift traffic during failover. Readiness checks = pre-failover validation; routing controls = failover execution.

---

### Question 65
A company has 100 TB of data in Amazon FSx for Windows File Server that serves a Windows-based application. They need cross-region DR for this file data. The RPO requirement is 15 minutes. What should the architect recommend?

A) Use FSx for Windows File Server backup with cross-region copy to the DR region, scheduled every 15 minutes
B) Use AWS DataSync to replicate FSx data to an FSx file system in the DR region continuously
C) Use DFS Replication (DFSR) between FSx instances in both regions (Windows native replication)
D) Set up scheduled FSx backups every 15 minutes and copy to S3 in the DR region

**Correct Answer: B**
**Explanation:** AWS DataSync can continuously synchronize data between FSx for Windows File Server instances in different regions. DataSync handles incremental transfers efficiently, minimizing bandwidth usage while maintaining near-real-time synchronization (well within 15-minute RPO). Option A—FSx backups taken every 15 minutes at 100 TB scale would be resource-intensive and may not complete within the 15-minute window. Option C—DFSR could work but requires Active Directory configuration and management across regions, adding complexity. Option D—FSx backups don't go to S3 directly; they're stored as FSx backups that can be cross-region copied.

---

### Question 66
A company's database team argues that their Aurora MySQL database doesn't need DR because it already has Multi-AZ with 6 copies of data across 3 AZs. The solutions architect disagrees. Why does Aurora Multi-AZ NOT eliminate the need for cross-region DR?

A) Multi-AZ protects against AZ failures and storage failures but not against regional disasters (natural disasters, regional service outages, regional network partitions)
B) Multi-AZ is only for read scaling, not for durability
C) Multi-AZ doesn't provide automatic failover
D) Multi-AZ copies are eventually consistent and may lose data

**Correct Answer: A**
**Explanation:** Aurora's 6 copies across 3 AZs protect against: individual drive failures, AZ failures, and temporary storage subsystem issues within a region. However, all 6 copies are in the SAME REGION. A regional disaster (earthquake, major network outage, regional service degradation) affects all AZs in that region simultaneously. Cross-region DR (Aurora Global Database or cross-region backups) is needed to protect against regional-scope events. Option B is incorrect—Aurora Multi-AZ is for durability and availability, not just read scaling. Option C is incorrect—Aurora provides automatic failover within the region. Option D is incorrect—Aurora writes are synchronously replicated to 4 of 6 copies before acknowledging.

---

### Question 67
A company operates a multi-region application and needs to implement a "split-brain" prevention mechanism for their database during network partitions. If both regions think they're the primary and accept writes, data corruption occurs. How should the architect prevent split-brain scenarios?

A) Use a "fencing" mechanism: before a DR region promotes itself to primary, it must verify with a quorum service (e.g., DynamoDB Global Table with conditional writes) that the old primary is truly down
B) Use Route 53 health checks to determine the primary—whichever region Route 53 routes traffic to is the primary
C) Implement a manual approval step before any database promotion
D) Use an odd number of regions (3) so that the majority partition can always form a quorum

**Correct Answer: A**
**Explanation:** Split-brain prevention requires a coordination mechanism. A fencing (or "stonith") approach uses an external quorum service: before promoting the DR database to primary, the automation must acquire a "primary lock" in a DynamoDB Global Table using a conditional write (PutItem with ConditionExpression). If the old primary is truly down, it can't renew the lock, and the DR region acquires it. If both regions are up (network partition), only one can hold the lock. This prevents both databases from accepting writes simultaneously. Option B—Route 53 health checks can flap during partitions. Option C adds human delay to automated failover. Option D is architecturally sound but requires three regions.

---

### Question 68
A company uses AWS Backup to manage backups across their organization. They need to ensure that backups cannot be deleted by anyone, including administrators, for a 7-year retention period (compliance requirement). How should the architect configure this?

A) Use AWS Backup Vault Lock in compliance mode with a 7-year minimum retention period, making backups immutable and undeletable even by the root account
B) Use S3 Object Lock in governance mode for backup storage
C) Implement IAM policies that deny backup deletion actions for all users
D) Use AWS Backup with a retention policy of 7 years and trust that administrators won't delete backups

**Correct Answer: A**
**Explanation:** AWS Backup Vault Lock in compliance mode creates a WORM (Write Once Read Many) configuration for the backup vault. Once locked in compliance mode, the configuration cannot be changed or deleted—not by administrators, not by AWS support, not even by the root account. The minimum retention period ensures backups are retained for the specified duration. This meets regulatory requirements for immutable backup retention. Option B—S3 governance mode can be bypassed by users with special permissions. Option C—IAM policies can be changed by administrators. Option D provides no enforcement.

---

### Question 69
A company needs to calculate the Recovery Point Objective (RPO) for their system that uses multiple data stores: Aurora (cross-region replica with 1-second lag), DynamoDB Global Tables (sub-second replication), ElastiCache (no cross-region replication), and S3 (CRR with 15-minute SLA). What is the overall system RPO?

A) Sub-second (the fastest component determines RPO)
B) 1 second (Aurora's replication lag)
C) 15 minutes (determined by the slowest component—S3 CRR)
D) It depends on whether ElastiCache data is recoverable from other sources; if not, the RPO is "undefined" for cached data, and 15 minutes for persistent data

**Correct Answer: D**
**Explanation:** The overall system RPO is determined by the component with the worst RPO, but only for data that cannot be regenerated. If ElastiCache data is a cache of data from Aurora/DynamoDB (regenerable), then losing it doesn't affect RPO—the cache warms up from the source. If ElastiCache stores unique data (sessions, counters), it has no cross-region replication, making that data's RPO effectively infinite (total loss). For persistent data stores, the RPO is 15 minutes (S3 CRR with RTC). The system RPO is a composite: 15 minutes for persistent data, and cache reconstruction time for cached data. Option C is closest for persistent data but doesn't account for ElastiCache.

---

### Question 70
A company performs a cost-benefit analysis for DR. Their current architecture costs $100,000/month. The probability of a regional disaster in any given year is estimated at 2%. The estimated cost of an 8-hour outage (including revenue loss, SLA penalties, and reputation damage) is $5 million. Should they invest in a warm standby DR strategy costing $30,000/month that reduces MTTR from 8 hours to 30 minutes?

A) No—the expected annual loss without DR is $100,000 (2% × $5M), but DR costs $360,000/year; the DR investment exceeds the expected savings
B) Yes—the DR investment reduces expected annual loss from $100K to ~$6,250 (2% × $312K for 30-min outage), and the improved resilience justifies the cost
C) The decision should factor in both the expected loss reduction AND the intangible benefits (customer confidence, compliance requirements, competitive advantage), making it likely justifiable
D) Cannot determine without knowing the company's revenue

**Correct Answer: C**
**Explanation:** Pure expected value calculation: Without DR: 2% × $5M = $100K expected annual loss. With DR: 2% × ($5M × 30/480) ≈ 2% × $312K = $6,250 expected annual loss. DR cost: $360K/year. Strictly by expected value, DR costs more ($360K) than it saves ($93,750). However, this analysis is incomplete: (1) the $5M estimate may be conservative, (2) a single catastrophic event could be existential for the business, (3) regulatory compliance may mandate DR, (4) customer contracts may require specific RTO/RPO guarantees, (5) the reputational damage of an 8-hour outage may be far greater than estimated. Most enterprises invest in DR despite the expected-value math because the risk is "low probability, high impact."

---

### Question 71
A company implements a "chaos engineering" program to validate their DR readiness. They want to simulate various failure scenarios in production safely. Which AWS service and approach should they use?

A) AWS Fault Injection Simulator (FIS) with experiments targeting specific resource types (EC2 instance termination, AZ blackout, network latency injection) with safety guardrails (stop conditions based on CloudWatch alarms)
B) Manually terminate random EC2 instances using a custom Lambda function (Netflix Chaos Monkey approach)
C) Use AWS Systems Manager to inject failures via SSM Run Command
D) Conduct tabletop exercises without actually injecting failures

**Correct Answer: A**
**Explanation:** AWS Fault Injection Simulator (FIS) is purpose-built for chaos engineering. It provides: (1) Pre-built experiment templates for common failure scenarios (EC2, ECS, EKS, RDS, network). (2) AZ-level fault injection (simulate an AZ outage). (3) Safety guardrails—stop conditions based on CloudWatch alarms automatically halt the experiment if impact exceeds acceptable thresholds. (4) IAM integration to limit blast radius. (5) Experiment history for auditing. Option B lacks safety controls and is hard to manage. Option C can inject failures but lacks the orchestration, safety, and reporting of FIS. Option D validates processes but not actual system behavior.

---

### Question 72
A company has a critical application with the following SLA requirements: 99.99% availability (52.6 minutes annual downtime allowed). They deploy across two regions. If each region independently has 99.9% availability (8.76 hours annual downtime), what is the theoretical availability of the two-region active-active deployment?

A) 99.99% (1 - (1-0.999)²) = 99.9999%—the dual-region architecture exceeds the SLA requirement
B) 99.99%—exactly meeting the SLA
C) 99.9% × 2 = 199.8%—this calculation doesn't apply
D) The theoretical availability is 99.9999% but actual availability depends on the failover mechanism's reliability and speed

**Correct Answer: D**
**Explanation:** Theoretical calculation: If regions are independent, the probability both fail simultaneously is (1-0.999) × (1-0.999) = 0.000001, so availability = 1 - 0.000001 = 99.9999%. However, this assumes: (1) Failures are independent (they often aren't—shared global services like IAM, Route 53 can cause correlated failures). (2) Failover is instant and 100% reliable (it isn't—DNS propagation, health check delays, data consistency checks add minutes). (3) The failover mechanism itself doesn't fail. In practice, two-region active-active typically achieves 99.95-99.99%, well below the theoretical 99.9999%. Option A gives the correct math but ignores real-world factors.

---

### Question 73
A company's DR plan requires that during a failover event, all in-flight API requests must complete successfully without the client experiencing errors. The application uses API Gateway, Lambda, and DynamoDB. The current failover causes HTTP 503 errors for 2-3 minutes during DNS propagation. How should the architect achieve zero-error failover?

A) Use Global Accelerator (static IP addresses) instead of Route 53, which provides faster failover without DNS caching issues
B) Implement client-side retry logic with exponential backoff, so clients automatically retry failed requests against the new endpoint
C) Deploy API Gateway in both regions behind Global Accelerator, implement idempotent APIs, and configure clients with retry logic—accepting that zero-error failover is practically impossible but minimizing errors
D) Use CloudFront as a reverse proxy with origin failover group (primary: us-east-1 API Gateway, secondary: us-west-2 API Gateway)

**Correct Answer: C**
**Explanation:** True zero-error failover is practically impossible for synchronous API traffic due to: in-flight requests at the moment of failure, TCP connections that must be re-established, and propagation delays. The best practical approach combines: (1) Global Accelerator for fast failover (seconds, not minutes), (2) idempotent APIs so retried requests don't cause side effects, (3) client retry logic to handle the brief failover window. This minimizes errors to a few seconds of impact rather than 2-3 minutes. Option A reduces failover time but doesn't eliminate errors for in-flight requests. Option D adds CloudFront latency to every API call and may not support all API patterns.

---

### Question 74
A company needs to implement DR for their AWS Transfer Family SFTP server. External partners upload files via SFTP, and the files must be available in the DR region for processing. The company receives 10,000 files per day totaling 50 GB. How should the architect design this?

A) Deploy AWS Transfer Family SFTP servers in both regions with S3 as the backend, enable S3 Cross-Region Replication, and use Route 53 failover routing for the SFTP endpoint
B) Use a single SFTP server and replicate files to the DR region using DataSync
C) Store files on EFS and use EFS cross-region replication
D) Implement a custom SFTP server on EC2 with EBS replication

**Correct Answer: A**
**Explanation:** AWS Transfer Family supports custom hostnames via Route 53 (e.g., sftp.company.com). Deploy Transfer Family SFTP servers in both regions with S3 buckets as the backend. S3 Cross-Region Replication ensures files uploaded in the primary region are replicated to the DR region's S3 bucket. Route 53 failover routing directs partners' SFTP connections to the active region. During failover, Route 53 redirects SFTP traffic to the DR region's Transfer Family server, and the replicated S3 bucket has all files. Option B requires the single server to be available for uploads. Option C—Transfer Family supports S3 and EFS; EFS works but S3 CRR is simpler and cheaper at this scale. Option D adds operational overhead.

---

### Question 75
A company conducts a comprehensive DR audit and discovers the following gaps. Rank them by severity and recommend the order of remediation:
1. No automated failover—all failovers require manual intervention
2. DR environment is 3 months out of date with production
3. Database backups have never been tested for restorability
4. No monitoring of cross-region replication lag

Which order should the architect prioritize remediation?

A) 3 → 4 → 2 → 1 (data integrity first, then monitoring, then currency, then automation)
B) 1 → 2 → 3 → 4 (automation first for fastest recovery)
C) 3 → 2 → 4 → 1 (untested backups are the highest risk, then environment currency, then monitoring, then automation)
D) All gaps should be addressed simultaneously as they are interdependent

**Correct Answer: C**
**Explanation:** Priority ranking: **(3) Untested backups (CRITICAL):** If backups can't be restored, you have no DR at all. This is the most dangerous gap—the company may believe they have DR capability when they don't. Immediate action: test a restore. **(2) Outdated DR environment (HIGH):** A 3-month-old DR environment may be missing critical services, security patches, and configurations. Failover to this environment could partially fail. **(4) No replication lag monitoring (MEDIUM):** Without monitoring, you don't know your actual RPO. Replication could be hours behind without anyone knowing. **(1) Manual failover (LOWER):** Manual failover is slower but still works. Many companies successfully use manual failover—it just takes longer. Automation improves RTO but isn't as fundamental as having working backups and a current DR environment.

---

## Answer Key

| Q | Answer | Q | Answer | Q | Answer | Q | Answer | Q | Answer |
|---|--------|---|--------|---|--------|---|--------|---|--------|
| 1 | C | 16 | A | 31 | B | 46 | C | 61 | A |
| 2 | A | 17 | C | 32 | D | 47 | D | 62 | D |
| 3 | A | 18 | C | 33 | C | 48 | A | 63 | B |
| 4 | A | 19 | A | 34 | A | 49 | B | 64 | A |
| 5 | D | 20 | B | 35 | A | 50 | B | 65 | B |
| 6 | D | 21 | D | 36 | A | 51 | A | 66 | A |
| 7 | D | 22 | B | 37 | C | 52 | A,B | 67 | A |
| 8 | A | 23 | A | 38 | D | 53 | A | 68 | A |
| 9 | A | 24 | A | 39 | D | 54 | A | 69 | D |
| 10 | A | 25 | A | 40 | A | 55 | C | 70 | C |
| 11 | A | 26 | A | 41 | A | 56 | A | 71 | A |
| 12 | A | 27 | B | 42 | A | 57 | D | 72 | D |
| 13 | A | 28 | A | 43 | A | 58 | C | 73 | C |
| 14 | A | 29 | A,C | 44 | B | 59 | A | 74 | A |
| 15 | D | 30 | A | 45 | A | 60 | C | 75 | C |

### Domain Distribution
- **Domain 1** (Organizational Complexity): Q8, Q11, Q13, Q17, Q32, Q35, Q42, Q44, Q48, Q51, Q53, Q57, Q61, Q64, Q67, Q68, Q70, Q71, Q75 → 19 questions
- **Domain 2** (New Solutions): Q1, Q4, Q5, Q6, Q7, Q9, Q14, Q18, Q20, Q21, Q23, Q25, Q26, Q28, Q30, Q33, Q36, Q41, Q43, Q49, Q58, Q74 → 22 questions
- **Domain 3** (Continuous Improvement): Q3, Q10, Q15, Q22, Q29, Q37, Q39, Q47, Q52, Q56, Q62 → 11 questions
- **Domain 4** (Migration & Modernization): Q19, Q27, Q34, Q40, Q50, Q55, Q59, Q63, Q65 → 9 questions
- **Domain 5** (Cost Optimization): Q2, Q12, Q16, Q24, Q31, Q38, Q45, Q46, Q54, Q60, Q66, Q69, Q72 → 13 questions
