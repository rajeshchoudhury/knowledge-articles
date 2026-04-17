# Domain 6: High Availability, Fault Tolerance, and Disaster Recovery — Practice Questions

> 40+ scenario-based practice questions with detailed answer explanations. These questions mirror the complexity and style of the DOP-C02 exam.

---

## Question 1

A company runs a three-tier web application on AWS with an ALB, EC2 instances in an ASG across two AZs, and an RDS MySQL Multi-AZ database. During a recent AZ outage, the application experienced 5 minutes of downtime. The DevOps engineer needs to reduce the failover time to under 1 minute. What should the engineer do?

**A.** Migrate from RDS MySQL to Amazon Aurora MySQL with Multi-AZ read replicas and enable RDS Proxy.

**B.** Enable cross-region read replicas for the RDS instance and configure Route 53 failover.

**C.** Increase the ASG minimum capacity and deploy NAT Gateways in each AZ.

**D.** Switch to an NLB and enable cross-zone load balancing.

<details>
<summary>Answer</summary>

**A.** Aurora MySQL with Multi-AZ read replicas and RDS Proxy.

**Explanation**: Aurora provides faster failover (~30 seconds) compared to RDS Multi-AZ (~60-120 seconds). RDS Proxy further reduces failover time by multiplexing connections and managing failover transparently. The proxy maintains a connection pool, so applications don't need to re-establish connections after failover. Option B is for cross-region DR, not AZ failover. Options C and D address networking but not the database failover bottleneck.
</details>

---

## Question 2

A company requires a disaster recovery solution with an RPO of 1 hour and an RTO of 4 hours. The application uses EC2 instances, RDS PostgreSQL, and S3. The company wants to minimize costs. Which DR strategy is most appropriate?

**A.** Multi-Site Active/Active with full production in two regions.

**B.** Warm Standby with a scaled-down environment in the DR region.

**C.** Backup and Restore with cross-region backups and CloudFormation templates.

**D.** Pilot Light with an RDS cross-region read replica and pre-configured AMIs.

<details>
<summary>Answer</summary>

**C.** Backup and Restore.

**Explanation**: With an RPO of 1 hour and RTO of 4 hours, Backup and Restore is sufficient and the most cost-effective. Hourly RDS snapshots (or automated backups with 5-minute transaction log intervals) satisfy the RPO. CloudFormation templates can rebuild the infrastructure within 4 hours. S3 CRR ensures data availability. Pilot Light (D) would also work but costs more due to running a cross-region read replica continuously. Options A and B are overprovisioned for these requirements.
</details>

---

## Question 3

A DevOps engineer manages an application deployed on Amazon ECS with Fargate. During a recent deployment, a bug was introduced that caused tasks to crash repeatedly. The ECS service kept trying to launch new tasks, creating a loop of failing deployments. How should the engineer prevent this in the future?

**A.** Enable the ECS deployment circuit breaker with rollback.

**B.** Configure an ECS task placement constraint to limit tasks to one AZ.

**C.** Set up a CloudWatch alarm on CPUUtilization and configure an SNS notification.

**D.** Use ECS service auto scaling with target tracking on running task count.

<details>
<summary>Answer</summary>

**A.** Enable the ECS deployment circuit breaker with rollback.

**Explanation**: The ECS deployment circuit breaker monitors deployments and detects when new tasks can't reach a steady state. When triggered, it automatically stops the deployment and rolls back to the last stable service revision. This prevents the infinite loop of failing task launches. Option C provides notification but no automatic remediation. Options B and D don't address deployment failure detection.
</details>

---

## Question 4

A company uses DynamoDB as its primary database for a globally distributed application. Users in North America, Europe, and Asia need low-latency access. The application requires read and write access in all regions. Which solution meets these requirements?

**A.** Deploy DynamoDB in us-east-1 with DAX for caching and use CloudFront for global distribution.

**B.** Configure DynamoDB Global Tables across three regions (us-east-1, eu-west-1, ap-southeast-1).

**C.** Create DynamoDB read replicas in each region with writes routed to the primary.

**D.** Use S3 Cross-Region Replication to sync DynamoDB exports across regions.

<details>
<summary>Answer</summary>

**B.** DynamoDB Global Tables.

**Explanation**: DynamoDB Global Tables provide multi-region, multi-active (read/write) replication. Data is automatically replicated across selected regions with sub-second latency. Users in all regions get low-latency reads AND writes. Last-writer-wins conflict resolution handles concurrent writes. Option A only provides caching, not multi-region writes. Option C is incorrect because DynamoDB doesn't have "read replicas" — that's an RDS concept. Option D is not real-time.
</details>

---

## Question 5

A company's application uses an ALB with an ASG spanning three AZs. During an AZ failure, the ASG launched new instances in the remaining AZs, but the ALB continued to send traffic to targets in the failed AZ for several minutes. What should the engineer configure to minimize this impact?

**A.** Reduce the ALB health check interval to 5 seconds and the unhealthy threshold to 2.

**B.** Disable cross-zone load balancing on the ALB.

**C.** Switch to an NLB with TCP health checks.

**D.** Configure the ASG to use only two AZs.

<details>
<summary>Answer</summary>

**A.** Reduce the health check interval and unhealthy threshold.

**Explanation**: By reducing the health check interval (from default 30s to 5s) and the unhealthy threshold (from default 3 to 2), the ALB detects unhealthy targets faster. With a 5-second interval and threshold of 2, targets are marked unhealthy in 10 seconds instead of 90 seconds. The ALB stops sending traffic to unhealthy targets. Disabling cross-zone load balancing (B) would worsen the situation. Switching to NLB (C) changes the protocol handling and isn't needed. Reducing to two AZs (D) decreases availability.
</details>

---

## Question 6

A company needs to ensure that database backups cannot be deleted by anyone, including administrators and the root user, for compliance purposes. Backups must be retained for 7 years. Which solution meets this requirement?

**A.** Store backups in S3 with Object Lock in Compliance mode and a 7-year retention period.

**B.** Use AWS Backup with Vault Lock in compliance mode and a 7-year minimum retention.

**C.** Enable RDS automated backups with a 35-day retention period and copy to S3.

**D.** Use AWS Backup with cross-account backup to a separate security account.

<details>
<summary>Answer</summary>

**B.** AWS Backup with Vault Lock in compliance mode.

**Explanation**: AWS Backup Vault Lock in compliance mode enforces a WORM (Write Once, Read Many) policy. Once a vault is locked in compliance mode, it cannot be unlocked by anyone — including the root user. The minimum retention period ensures backups are kept for the specified duration. Option A works for S3 objects but doesn't cover RDS/Aurora/DynamoDB backups natively. Option C has a max retention of 35 days. Option D adds isolation but doesn't prevent deletion by the security account admin.
</details>

---

## Question 7

A DevOps engineer is designing a multi-region active-active architecture for a web application. The application uses Aurora MySQL. Which combination of services provides the lowest RTO and RPO for database failover? (Choose TWO.)

**A.** Aurora Global Database with managed planned failover.

**B.** RDS MySQL cross-region read replica with manual promotion.

**C.** Route 53 latency-based routing with health checks.

**D.** DynamoDB Global Tables.

**E.** Aurora Serverless v2 with auto-scaling.

<details>
<summary>Answer</summary>

**A and C.**

**Explanation**: Aurora Global Database provides cross-region replication with typically less than 1-second replication lag (low RPO). Managed planned failover promotes a secondary region with zero data loss. Route 53 latency-based routing with health checks provides automatic traffic failover to the healthy region (low RTO). Together they deliver near-zero RPO and very low RTO. Option B has higher RPO due to asynchronous replication lag and requires manual intervention. Option D is a different database type. Option E addresses scaling but not multi-region.
</details>

---

## Question 8

A company uses Amazon S3 for storing critical application data. They need to ensure data is available in a second region with replication completing within 15 minutes for 99.99% of objects. How should this be configured?

**A.** Enable S3 Cross-Region Replication (CRR) with Replication Time Control (RTC).

**B.** Enable S3 Cross-Region Replication with default settings.

**C.** Use AWS DataSync scheduled to run every 15 minutes.

**D.** Use S3 Same-Region Replication with lifecycle policies to transition to another region.

<details>
<summary>Answer</summary>

**A.** CRR with Replication Time Control (RTC).

**Explanation**: S3 Replication Time Control (RTC) guarantees that 99.99% of objects replicate within 15 minutes. It also provides replication metrics for monitoring. Standard CRR (B) does not have a time guarantee. DataSync (C) is batch-based and wouldn't handle continuous replication of new objects. Option D is incorrect because lifecycle policies cannot move objects across regions.
</details>

---

## Question 9

An application running on EC2 instances behind an ALB occasionally experiences failures when a downstream microservice is overloaded. The failures cascade and bring down the entire application. Which fault tolerance pattern should the engineer implement?

**A.** Queue-based leveling with SQS between the services.

**B.** Circuit breaker pattern to stop calling the failing service.

**C.** Increase the EC2 instance size to handle more load.

**D.** Add more read replicas to the database.

<details>
<summary>Answer</summary>

**B.** Circuit breaker pattern.

**Explanation**: The circuit breaker pattern prevents cascading failures by stopping calls to a service that is failing. When the failure threshold is reached, the circuit opens and requests are immediately rejected (or a fallback response is returned), preventing the calling service from being overwhelmed waiting for responses from the failing service. Option A is useful for absorbing spikes but doesn't address cascading failures from a failing downstream. Options C and D don't address the root cause.
</details>

---

## Question 10

A company operates in a regulated industry and must have its application running in a secondary region within 30 minutes of a primary region failure. The current architecture includes EC2, ALB, and Aurora PostgreSQL. Cost must be minimized while meeting the RTO requirement. Which strategy should the engineer implement?

**A.** Backup and Restore with cross-region snapshots.

**B.** Pilot Light with Aurora Global Database and pre-configured ASG (desired = 0).

**C.** Warm Standby with scaled-down infrastructure in the DR region.

**D.** Multi-Site Active/Active with full production in both regions.

<details>
<summary>Answer</summary>

**B.** Pilot Light.

**Explanation**: Pilot Light provides the most cost-effective solution for a 30-minute RTO. The Aurora Global Database keeps the database synchronized with sub-second replication lag. The ASG with desired count of 0 (or minimal) means no EC2 costs during normal operations, but infrastructure definitions are pre-configured for rapid scaling. On failover: promote Aurora, scale up ASG, update DNS — achievable within 30 minutes. Backup and Restore (A) would likely exceed 30 minutes. Warm Standby (C) is more expensive due to running instances. Multi-Site (D) is far more expensive than needed.
</details>

---

## Question 11

A company uses AWS CodeDeploy for ECS Blue/Green deployments. During a recent deployment, the new version had a memory leak that wasn't detected during the initial health checks. The issue appeared 30 minutes after deployment. How can the engineer ensure automatic rollback for such issues?

**A.** Configure CodeDeploy with a longer wait time for the original task set termination and set up CloudWatch alarms to trigger automatic rollback.

**B.** Increase the ECS health check grace period to 60 minutes.

**C.** Use a CodeDeploy linear deployment configuration instead of all-at-once.

**D.** Configure ECS service auto scaling to replace unhealthy tasks.

<details>
<summary>Answer</summary>

**A.** Configure longer termination wait time with CloudWatch alarm-based rollback.

**Explanation**: CodeDeploy Blue/Green for ECS allows you to configure a termination wait time for the original (blue) task set. During this window, both blue and green task sets are running. If a CloudWatch alarm fires (e.g., on error rate, latency, or memory utilization), CodeDeploy automatically rolls back by shifting traffic back to the blue task set. Setting this window to longer than 30 minutes would catch the memory leak. Option B only affects initial task startup. Option C is about deployment speed. Option D doesn't roll back the deployment.
</details>

---

## Question 12

A DevOps engineer needs to implement a self-healing architecture for stateful EC2 instances that run a legacy application. The instances must retain their private IP addresses and attached EBS volumes after recovery. What approach should be used?

**A.** Use an ASG with min=1, max=1 and an Elastic IP.

**B.** Configure EC2 auto-recovery using a CloudWatch alarm on StatusCheckFailed_System.

**C.** Use AWS Elastic Disaster Recovery to replicate the instance.

**D.** Create an AMI-based backup and restore process.

<details>
<summary>Answer</summary>

**B.** EC2 auto-recovery with StatusCheckFailed_System alarm.

**Explanation**: EC2 auto-recovery migrates the instance to new underlying hardware while preserving the instance ID, private IP address, Elastic IP, EBS volumes, and instance metadata. This is ideal for stateful instances that must retain their identity. An ASG (A) would create a new instance with a new private IP. DRS (C) is for DR, not single-instance recovery. AMI restore (D) would also create a new instance.
</details>

---

## Question 13

A company's application uses Step Functions to orchestrate a multi-step order processing workflow. Some steps involve calling external APIs that occasionally return transient errors. What is the best way to handle these failures?

**A.** Add a Retry field on the Task state with exponential backoff and a Catch field that routes to an error handling state.

**B.** Wrap each API call in a Lambda function that implements its own retry logic.

**C.** Use a Map state to process orders in parallel and ignore failures.

**D.** Set the Step Function timeout to a very long duration to allow for delays.

<details>
<summary>Answer</summary>

**A.** Retry with exponential backoff and Catch for error handling.

**Explanation**: Step Functions natively supports Retry with configurable IntervalSeconds, BackoffRate, and MaxAttempts. This handles transient errors with exponential backoff. The Catch block defines fallback logic when retries are exhausted (e.g., send to DLQ, notify, compensate). This is the built-in, best-practice approach. Option B works but duplicates functionality that Step Functions provides natively. Option C ignores failures which is unacceptable for order processing. Option D doesn't address the retry logic.
</details>

---

## Question 14

A company runs a web application behind an ALB with sticky sessions enabled. Users are reporting that they lose their session when instances are replaced by the ASG. How should the engineer resolve this?

**A.** Migrate session data to ElastiCache Redis and remove ALB sticky sessions.

**B.** Increase the sticky session duration to 24 hours.

**C.** Configure the ASG to use a longer cooldown period.

**D.** Enable connection draining with a 1-hour timeout.

<details>
<summary>Answer</summary>

**A.** Migrate session data to ElastiCache Redis.

**Explanation**: Storing session data on individual instances makes the application stateful and vulnerable to instance replacement. By externalizing session data to ElastiCache Redis (which itself is Multi-AZ), instances become stateless. Users' sessions persist regardless of which instance handles their request. Sticky sessions are no longer needed. Option B only extends the duration but doesn't survive instance termination. Options C and D don't address session persistence.
</details>

---

## Question 15

A DevOps engineer is configuring Route 53 for an active-passive failover architecture. The primary region is us-east-1 and the DR region is eu-west-1. The primary endpoint is behind an ALB. What is the correct Route 53 configuration?

**A.** Create two weighted routing records with 100% weight on us-east-1 and 0% on eu-west-1.

**B.** Create a failover routing policy with a primary record pointing to the us-east-1 ALB (with health check) and a secondary record pointing to the eu-west-1 ALB.

**C.** Create two latency-based records with health checks on both endpoints.

**D.** Create a simple routing record with both ALB endpoints.

<details>
<summary>Answer</summary>

**B.** Failover routing with primary and secondary records.

**Explanation**: For active-passive DR, use Route 53 failover routing. The primary record is associated with a health check. When the health check fails, Route 53 automatically routes traffic to the secondary record. Weighted routing (A) with 0% would never send traffic to DR during normal operations, but the failover is manual. Latency (C) is for active-active. Simple (D) doesn't support failover logic.
</details>

---

## Question 16

A company needs to replicate its on-premises VMware environment to AWS for disaster recovery with an RPO of less than 1 minute. Which service should the engineer use?

**A.** AWS Database Migration Service (DMS) with continuous replication.

**B.** AWS Elastic Disaster Recovery (DRS) with continuous block-level replication.

**C.** AWS Backup with hourly backup schedules.

**D.** VM Import/Export with scheduled AMI creation.

<details>
<summary>Answer</summary>

**B.** AWS Elastic Disaster Recovery (DRS).

**Explanation**: DRS provides continuous block-level replication with sub-second RPO. The replication agent installed on source servers continuously replicates data changes to a staging area in AWS. For VMware environments, DRS supports agentless replication via vCenter. DMS (A) is for database migration, not full VM replication. AWS Backup (C) provides hourly RPO at best. VM Import/Export (D) is for one-time migration, not continuous DR.
</details>

---

## Question 17

An application uses an SQS queue to decouple its front-end from back-end processing. Messages are occasionally processed more than once, causing duplicate orders. The current architecture uses a Standard SQS queue. What are two solutions? (Choose TWO.)

**A.** Switch to a FIFO SQS queue for exactly-once processing.

**B.** Implement idempotency in the consumer using DynamoDB conditional writes to track processed message IDs.

**C.** Increase the visibility timeout to prevent reprocessing.

**D.** Enable long polling to reduce duplicate deliveries.

**E.** Use SNS instead of SQS.

<details>
<summary>Answer</summary>

**A and B.**

**Explanation**: FIFO queues guarantee exactly-once processing and maintain message order. DynamoDB conditional writes provide an idempotency layer — before processing, check if the message ID exists in DynamoDB; if so, skip it. These are complementary approaches. Increasing visibility timeout (C) reduces but doesn't eliminate duplicates. Long polling (D) reduces empty responses, not duplicates. SNS (E) doesn't solve the problem.
</details>

---

## Question 18

A company is using CloudFront to distribute content from an S3 origin. During a regional S3 outage, the website was unavailable. How should the engineer improve availability?

**A.** Enable S3 Transfer Acceleration on the bucket.

**B.** Configure a CloudFront origin group with the primary S3 bucket and a secondary S3 bucket in another region (with CRR enabled).

**C.** Increase the CloudFront cache TTL to 24 hours.

**D.** Add an ALB as a second origin in the CloudFront distribution.

<details>
<summary>Answer</summary>

**B.** CloudFront origin group with primary and secondary S3 origins.

**Explanation**: CloudFront origin groups support origin failover. When the primary origin returns specific HTTP error codes (500, 502, 503, 504, or 404), CloudFront automatically routes the request to the secondary origin. Combine this with S3 CRR to keep the secondary bucket in sync. Option A improves upload speed, not availability. Option C may serve stale content but doesn't help when the cache is empty. Option D doesn't provide S3 failover.
</details>

---

## Question 19

A DevOps engineer needs to deploy an EKS cluster that can survive an AZ failure with minimal application disruption. The application has strict requirements for at least 3 replicas always available. What should the engineer configure?

**A.** Deploy a managed node group in a single AZ with 6 nodes.

**B.** Deploy managed node groups across 3 AZs, configure Pod Disruption Budgets with minAvailable=3, and use Pod Topology Spread Constraints.

**C.** Deploy Fargate profiles across 2 AZs with 6 pods.

**D.** Deploy a single node group with Cluster Autoscaler and 6 minimum nodes.

<details>
<summary>Answer</summary>

**B.** Multi-AZ node groups + PDBs + Pod Topology Spread Constraints.

**Explanation**: Deploying across 3 AZs protects against an AZ failure. Pod Topology Spread Constraints ensure pods are distributed across AZs (not concentrated in one). Pod Disruption Budgets guarantee that at least 3 replicas are always available during voluntary disruptions like upgrades or node drains. Together, this ensures that even if one AZ fails, at least 3 replicas continue running in the remaining AZs. Option A has a single AZ failure point. Option C with only 2 AZs is less resilient. Option D doesn't ensure cross-AZ distribution.
</details>

---

## Question 20

A company runs a Lambda-based application that processes events from an SQS queue. Some events cause the Lambda function to fail, and these messages are reprocessed repeatedly until the visibility timeout expires. This wastes Lambda invocations and increases costs. What should the engineer do?

**A.** Increase the SQS visibility timeout to 6 hours.

**B.** Configure a Dead Letter Queue (DLQ) on the SQS queue with a maxReceiveCount of 3, and create a separate process to handle DLQ messages.

**C.** Disable retries on the Lambda function.

**D.** Configure the Lambda function with reserved concurrency of 1.

<details>
<summary>Answer</summary>

**B.** Configure a DLQ with maxReceiveCount.

**Explanation**: Setting a maxReceiveCount (e.g., 3) on the SQS queue's redrive policy sends messages to a DLQ after failing a specified number of times. This prevents infinite retry loops. A separate process can then analyze and handle the failed messages. Option A still wastes invocations during the timeout. Option C can't be done for SQS event source mappings. Option D throttles processing unnecessarily.
</details>

---

## Question 21

A company wants to implement a canary deployment for their API Gateway and Lambda application. They want to route 10% of traffic to the new version and automatically rollback if the error rate exceeds 1%. What is the best approach?

**A.** Use Lambda aliases with weighted routing (90/10) and CodeDeploy with a CloudWatch alarm for automatic rollback.

**B.** Deploy two API Gateway stages and use Route 53 weighted routing.

**C.** Use API Gateway canary release deployment with 10% traffic.

**D.** Deploy the new Lambda version and manually shift traffic after monitoring.

<details>
<summary>Answer</summary>

**A.** Lambda aliases with CodeDeploy for automatic rollback.

**Explanation**: CodeDeploy supports Lambda deployments with traffic shifting (canary or linear). A Lambda alias can point to two versions with weighted traffic. CodeDeploy manages the traffic shifting and monitors CloudWatch alarms. If the alarm triggers (error rate > 1%), CodeDeploy automatically rolls back by shifting all traffic back to the original version. Option C provides canary capability but without automatic rollback based on alarms. Option B is overly complex. Option D is manual.
</details>

---

## Question 22

An organization uses AWS Organizations with multiple accounts. They need a centralized backup strategy that ensures all accounts have daily backups with 30-day retention, and no individual account can modify the backup policy. How should this be implemented?

**A.** Create AWS Backup plans in each account using CloudFormation StackSets.

**B.** Define backup policies in AWS Organizations and apply them to the appropriate OUs. Enable cross-account management in AWS Backup.

**C.** Use a Lambda function that runs daily to create backups in each account.

**D.** Enable AWS Backup in the management account and manually configure each account.

<details>
<summary>Answer</summary>

**B.** AWS Organizations backup policies.

**Explanation**: AWS Organizations backup policies allow you to define and enforce backup plans centrally. Policies are inherited through the OU hierarchy and cannot be overridden by individual accounts. Combined with cross-account management in AWS Backup, this provides centralized governance. StackSets (A) could deploy backup plans but individual accounts could modify them. Lambda (C) is custom and fragile. Manual configuration (D) doesn't scale.
</details>

---

## Question 23

A company's Auto Scaling Group uses ELB health checks. After a deployment, new instances keep getting terminated before the application finishes starting. The application takes 5 minutes to initialize. What should the engineer adjust?

**A.** Increase the ELB health check interval to 5 minutes.

**B.** Increase the ASG health check grace period to at least 5 minutes (300 seconds).

**C.** Change the ASG to use EC2 health checks instead of ELB health checks.

**D.** Disable the ELB health check and rely on Route 53 health checks.

<details>
<summary>Answer</summary>

**B.** Increase the ASG health check grace period.

**Explanation**: The health check grace period tells the ASG to wait before checking health on newly launched instances. If the application takes 5 minutes to initialize, set the grace period to at least 300 seconds (or more with buffer). During this period, the ASG won't terminate the instance even if it fails health checks. Increasing the ELB interval (A) might help but creates a gap in health monitoring for all instances. Switching to EC2 checks (C) loses application-level health detection. Route 53 (D) is for DNS, not ASG health.
</details>

---

## Question 24

A company uses Aurora PostgreSQL as its primary database. They need to implement a DR strategy that supports a managed failover with zero data loss during planned maintenance and less than 1-minute RTO for unplanned failures. What should the engineer implement?

**A.** RDS PostgreSQL with cross-region read replicas and manual failover scripts.

**B.** Aurora Global Database with managed planned failover and write forwarding.

**C.** DynamoDB Global Tables for zero-RPO cross-region replication.

**D.** Aurora PostgreSQL Multi-AZ with automated backups copied cross-region.

<details>
<summary>Answer</summary>

**B.** Aurora Global Database.

**Explanation**: Aurora Global Database provides managed planned failover (RPO = 0, since it waits for replication to complete) for planned events, and unplanned failover with typically less than 1-second RPO. The RTO is approximately 1 minute. Write forwarding allows secondary regions to forward writes to the primary without application changes. Option A has higher RPO and requires manual intervention. Option C changes the database technology. Option D doesn't provide cross-region failover capability.
</details>

---

## Question 25

A DevOps engineer is troubleshooting an application where an NLB is not distributing traffic evenly across targets in three AZs. AZ-A has 5 targets, AZ-B has 3 targets, and AZ-C has 2 targets. What is the most likely cause?

**A.** The NLB health checks are failing for targets in AZ-B and AZ-C.

**B.** Cross-zone load balancing is not enabled on the NLB.

**C.** The NLB is configured with sticky sessions.

**D.** The targets in AZ-B and AZ-C have insufficient capacity.

<details>
<summary>Answer</summary>

**B.** Cross-zone load balancing is not enabled.

**Explanation**: By default, cross-zone load balancing is disabled on NLB. Without it, each AZ receives an equal share of traffic (33% each), which is then distributed among the targets in that AZ. AZ-A targets each get ~6.6% of traffic, AZ-B targets each get ~11%, and AZ-C targets each get ~16.5%. Enabling cross-zone load balancing distributes traffic evenly across all 10 targets regardless of AZ. This is a critical difference: ALB has cross-zone enabled by default, NLB does not.
</details>

---

## Question 26

A company's application processes financial transactions using Step Functions. A transaction involves debiting one account and crediting another. If the credit step fails, the debit must be reversed. Which pattern should the engineer implement?

**A.** Use a Step Functions Map state to process both steps in parallel.

**B.** Implement the Saga pattern with Step Functions, using a Catch block on the credit step that triggers a compensating debit reversal.

**C.** Use SQS with a FIFO queue to ensure transactions are processed in order.

**D.** Enable Step Functions Express Workflow for faster processing.

<details>
<summary>Answer</summary>

**B.** Saga pattern with compensating transactions.

**Explanation**: The Saga pattern manages distributed transactions by defining a compensating action for each step. In Step Functions, implement this with a Catch block on the credit step that routes to a "reverse debit" state. If the credit fails, the compensating transaction reverses the debit, maintaining data consistency. Option A would process in parallel without proper sequencing or compensation. Option C ensures order but not compensation. Option D addresses performance, not transaction consistency.
</details>

---

## Question 27

A company is migrating from a single-region to a multi-region architecture. Their application uses an ALB, ECS Fargate, and Aurora MySQL. They want active-active in two regions with the lowest possible RTO. Which components are needed? (Choose THREE.)

**A.** Aurora Global Database with write forwarding enabled.

**B.** Route 53 latency-based routing with health checks.

**C.** CloudFront with origin groups for each region.

**D.** ECS services deployed in both regions with independent ALBs.

**E.** A single ALB with cross-region targets.

**F.** S3 Same-Region Replication.

<details>
<summary>Answer</summary>

**A, B, and D.**

**Explanation**: Aurora Global Database (A) provides cross-region database replication with write forwarding so the secondary region can accept writes. Route 53 latency-based routing (B) directs users to the nearest region and health checks enable automatic failover. ECS services in both regions with independent ALBs (D) provide the application tier in each region. CloudFront (C) is optional for caching but not required for active-active. Cross-region ALB targets (E) don't exist. SRR (F) is irrelevant.
</details>

---

## Question 28

A DevOps engineer needs to ensure that an EFS file system used by an application in us-east-1 is available in us-west-2 for disaster recovery. Changes must be replicated within 15 minutes. What should the engineer configure?

**A.** Use AWS DataSync to sync the EFS file system every 15 minutes.

**B.** Enable EFS Replication to us-west-2.

**C.** Copy EFS data to S3 with CRR enabled.

**D.** Mount the us-east-1 EFS file system from us-west-2 using VPC peering.

<details>
<summary>Answer</summary>

**B.** Enable EFS Replication.

**Explanation**: EFS Replication provides automatic, continuous replication to another region with an RPO of approximately 15 minutes. The destination file system is read-only and can be promoted for failover. DataSync (A) could work but requires custom scheduling and is more complex. S3 (C) changes the storage type. Cross-region mounting (D) is not supported for EFS and would have terrible latency even if it were.
</details>

---

## Question 29

A company's SQS-based processing pipeline experiences traffic spikes that overwhelm the EC2 consumer fleet. During spikes, message processing is delayed by hours. The engineer needs to automatically scale the fleet based on queue depth. What is the best approach?

**A.** Configure an ASG target tracking policy on the `ApproximateNumberOfMessagesVisible` metric divided by the number of running instances.

**B.** Create a CloudWatch alarm on queue age and trigger a Lambda function to adjust ASG capacity.

**C.** Use SQS long polling to reduce the number of empty receives.

**D.** Increase the SQS visibility timeout to allow more processing time.

<details>
<summary>Answer</summary>

**A.** ASG target tracking on backlog per instance.

**Explanation**: The recommended approach is to use a custom metric: `ApproximateNumberOfMessagesVisible / NumberOfRunningInstances` (backlog per instance). Set a target value (e.g., 10 messages per instance). ASG scales out when the backlog per instance exceeds the target and scales in when it drops below. This is AWS's recommended pattern for SQS-based scaling. Option B works but is more complex. Options C and D don't address scaling.
</details>

---

## Question 30

A company uses CloudFormation StackSets to deploy infrastructure across 50 accounts in their Organization. A recent update failed in 5 accounts, blocking the entire deployment. How should the engineer configure StackSets to handle partial failures?

**A.** Set `MaxConcurrentPercentage` to 100% to deploy all accounts simultaneously.

**B.** Configure `FailureToleranceCount` to 5 or `FailureTolerancePercentage` to 10%.

**C.** Use CloudFormation change sets to preview changes before deploying.

**D.** Enable automatic rollback on the stack set.

<details>
<summary>Answer</summary>

**B.** Configure FailureToleranceCount or FailureTolerancePercentage.

**Explanation**: StackSets' `FailureToleranceCount` or `FailureTolerancePercentage` defines how many accounts can fail before the entire operation stops. Setting this to 5 (or 10%) allows the deployment to continue in the remaining 45 accounts even if 5 fail. The failed accounts can be investigated and redeployed separately. Option A increases parallelism but doesn't handle failures. Option C is a preview, not a failure tolerance mechanism. Option D applies to individual stacks, not the StackSet operation.
</details>

---

## Question 31

A DevOps engineer needs to implement a Blue/Green deployment for an application running on EC2 instances behind an ALB. The deployment should be fully automated and support instant rollback. Which approach is most appropriate?

**A.** Use CodeDeploy with an in-place deployment and auto-rollback.

**B.** Use CodeDeploy with a Blue/Green deployment type targeting the ALB and ASG.

**C.** Manually create a new ASG, register with the ALB, and deregister the old one.

**D.** Use ALB weighted target groups to gradually shift traffic using a Lambda function.

<details>
<summary>Answer</summary>

**B.** CodeDeploy Blue/Green with ALB and ASG.

**Explanation**: CodeDeploy Blue/Green deployment for EC2 creates a replacement (green) ASG, deploys the new version, and shifts traffic at the ALB level. It supports instant rollback by rerouting traffic back to the original (blue) ASG. The deployment is fully automated and supports hooks for validation. In-place (A) doesn't provide true Blue/Green. Manual (C) isn't automated. Lambda-based shifting (D) is custom and doesn't support CodeDeploy's built-in rollback.
</details>

---

## Question 32

A company has an application that writes to an SQS queue. A Lambda function processes messages from the queue. Occasionally, a single "poison pill" message causes the Lambda function to fail repeatedly, blocking the processing of subsequent messages in the batch. What TWO configurations should the engineer implement? (Choose TWO.)

**A.** Configure a DLQ on the SQS queue with a maxReceiveCount of 3.

**B.** Enable `ReportBatchItemFailures` in the Lambda event source mapping.

**C.** Increase the Lambda memory to handle the problematic message.

**D.** Configure the Lambda function with a longer timeout.

**E.** Switch to an SNS topic instead of SQS.

<details>
<summary>Answer</summary>

**A and B.**

**Explanation**: `ReportBatchItemFailures` allows the Lambda function to report which specific messages in a batch failed, so only those messages are retried (not the entire batch). This prevents one bad message from blocking the entire batch. The DLQ with maxReceiveCount ensures that after a configured number of failures, the poison pill message is moved to the DLQ instead of being retried indefinitely. Together, these prevent a single bad message from blocking the queue.
</details>

---

## Question 33

A company needs to ensure that their Route 53 health checks can monitor an application running on EC2 instances in a private subnet. The instances are not accessible from the internet. What approach should the engineer use?

**A.** Configure Route 53 endpoint health checks with the private IP addresses.

**B.** Create a CloudWatch alarm on a custom metric from the application, then create a Route 53 health check based on the CloudWatch alarm.

**C.** Open the security group to allow Route 53 health checker IP ranges.

**D.** Move the instances to a public subnet temporarily for health checking.

<details>
<summary>Answer</summary>

**B.** CloudWatch alarm-based health check.

**Explanation**: Route 53 endpoint health checks originate from the public internet and cannot reach private subnets. For private resources, use a CloudWatch alarm-based health check: the application publishes a custom metric, a CloudWatch alarm monitors it, and the Route 53 health check monitors the alarm state. When the alarm goes to ALARM state, the health check fails. Option A won't work because Route 53 health checkers can't reach private IPs. Option C is a security risk and still won't work for truly private subnets without a NAT path.
</details>

---

## Question 34

A company runs a multi-tier application with a web tier, application tier, and database tier. They want to implement the bulkhead pattern to prevent a failure in one tier from cascading to others. Which implementation is most appropriate?

**A.** Deploy all tiers in a single ASG for simplified management.

**B.** Deploy each tier in separate ASGs with separate ALBs/NLBs, separate SQS queues between tiers, and separate Lambda functions with reserved concurrency.

**C.** Use a single large EC2 instance for all tiers to reduce network latency.

**D.** Deploy all tiers in a single ECS service for easier deployment.

<details>
<summary>Answer</summary>

**B.** Separate ASGs, load balancers, queues, and reserved concurrency per tier.

**Explanation**: The bulkhead pattern isolates components so failures don't cascade. Separate ASGs mean a scaling issue in one tier doesn't affect others. Separate queues buffer communication between tiers. Reserved concurrency on Lambda functions prevents one function from consuming all available concurrency. Each tier can scale, fail, and recover independently. Options A, C, and D combine tiers, defeating the purpose of bulkhead isolation.
</details>

---

## Question 35

A DevOps engineer manages an Aurora MySQL Global Database with a primary cluster in us-east-1 and a secondary cluster in eu-west-1. The company needs to perform maintenance on the us-east-1 region and wants to failover to eu-west-1 with zero data loss. Which approach should be used?

**A.** Detach the secondary cluster and promote it to a standalone cluster.

**B.** Use managed planned failover to promote the eu-west-1 cluster.

**C.** Use unplanned failover (detach and promote) for fastest recovery.

**D.** Create a snapshot of the primary and restore in eu-west-1.

<details>
<summary>Answer</summary>

**B.** Managed planned failover.

**Explanation**: Managed planned failover is designed for controlled operations like maintenance. It ensures zero data loss (RPO = 0) by waiting for the secondary to catch up before completing the switchover. The secondary becomes the new primary, and the former primary becomes a secondary. The Global Database topology is maintained. Unplanned failover (C) or detach and promote (A) may result in data loss and break the Global Database configuration. Snapshot restore (D) is slow and has significant data loss.
</details>

---

## Question 36

A company's API Gateway receives occasional traffic spikes that exceed the backend service capacity, causing 5xx errors. The backend is an ECS service. What architecture change would best handle these spikes without over-provisioning the backend?

**A.** Enable API Gateway caching for all responses.

**B.** Place an SQS queue between API Gateway and the backend, with the ECS service consuming from the queue.

**C.** Configure API Gateway throttling to reject excess requests.

**D.** Increase the ECS service maximum task count to 1000.

<details>
<summary>Answer</summary>

**B.** SQS queue-based leveling between API Gateway and backend.

**Explanation**: Queue-based leveling absorbs traffic spikes by buffering requests in an SQS queue. The ECS service processes messages at its own pace, scaling as needed. This decouples the ingestion rate from the processing rate. API Gateway caching (A) only works for repeated identical requests. Throttling (C) rejects requests, which isn't ideal. Over-provisioning (D) is wasteful and may still not handle extreme spikes.
</details>

---

## Question 37

A company uses ElastiCache Redis as a session store for their web application. They need to ensure session data survives an AZ failure and provide cross-region DR capability. What configuration should the engineer implement?

**A.** Redis Cluster Mode Disabled with a single node.

**B.** Redis Cluster Mode Enabled with Multi-AZ automatic failover and Global Datastore.

**C.** Memcached cluster with nodes in multiple AZs.

**D.** Redis Cluster Mode Disabled with Read Replicas in two AZs.

<details>
<summary>Answer</summary>

**B.** Redis Cluster Mode Enabled with Multi-AZ and Global Datastore.

**Explanation**: Redis Cluster Mode Enabled distributes data across multiple shards for scaling and each shard has replicas across AZs for HA. Multi-AZ automatic failover promotes a replica if the primary node fails. Global Datastore provides cross-region replication for DR. Memcached (C) doesn't support replication or persistence. Cluster Mode Disabled (D) works for Multi-AZ but doesn't support Global Datastore as effectively. Single node (A) has no HA.
</details>

---

## Question 38

A DevOps engineer must configure AWS Backup to protect resources across 20 accounts in an AWS Organization. Backups must be stored in a central security account and copied to a second region. Individual accounts must not be able to delete their backups. What should the engineer configure?

**A.** Create AWS Backup plans in each account using CloudFormation StackSets with cross-region copy rules. Enable cross-account backup to the security account.

**B.** Define backup policies in AWS Organizations applied to the root OU, with cross-region copy rules and cross-account backup to a vault in the security account. Enable Vault Lock on the security account vault.

**C.** Use a Lambda function triggered on a schedule to copy backups from each account to the security account.

**D.** Enable AWS Backup in the security account only and assume roles into member accounts.

<details>
<summary>Answer</summary>

**B.** Organizations backup policies + cross-account + cross-region + Vault Lock.

**Explanation**: AWS Organizations backup policies provide centralized, enforceable backup plans that member accounts can't modify. Cross-region copy rules ensure backups are in two regions. Cross-account backup to the security account provides isolation. Vault Lock on the security account vault prevents anyone — including the security account admin — from deleting backups. StackSets (A) could be modified by account admins. Lambda (C) is custom and fragile. Option D doesn't scale well.
</details>

---

## Question 39

A company is deploying a Lambda function that is triggered by an SQS queue. The function makes HTTP calls to an external API that has rate limits. When too many Lambda invocations hit the API simultaneously, the API returns 429 (Too Many Requests) errors. What should the engineer do?

**A.** Configure reserved concurrency on the Lambda function to limit parallel executions.

**B.** Enable SQS FIFO queue to serialize message processing.

**C.** Add an SQS delay queue with a 60-second delay.

**D.** Increase the Lambda function timeout.

<details>
<summary>Answer</summary>

**A.** Reserved concurrency on the Lambda function.

**Explanation**: Reserved concurrency limits the number of concurrent Lambda executions. If the external API can handle 10 concurrent requests, set reserved concurrency to 10. SQS will automatically manage the messages — unprocessed messages remain in the queue until a Lambda execution slot is available. FIFO (B) serializes but doesn't limit concurrency. Delay queue (C) delays all messages but doesn't control concurrency. Timeout (D) doesn't address rate limiting.
</details>

---

## Question 40

A company has a strict regulatory requirement that their application must be recoverable in a different region within 15 minutes. They currently use EC2 instances (with data on EBS), RDS Oracle, and S3. Which combination provides the lowest cost while meeting the requirement? (Choose TWO.)

**A.** Aurora Global Database.

**B.** Pilot Light with RDS cross-region read replica, AMIs copied to DR region, and S3 CRR.

**C.** Multi-Site Active/Active.

**D.** Pre-created CloudFormation templates stored in S3 for the DR region.

**E.** AWS Elastic Disaster Recovery for the EC2 instances.

<details>
<summary>Answer</summary>

**B and D.**

**Explanation**: Pilot Light provides the lowest-cost DR that can meet a 15-minute RTO. The RDS cross-region read replica keeps the database synchronized (can be promoted in minutes). AMIs in the DR region allow fast EC2 launch. S3 CRR ensures data availability. CloudFormation templates (D) enable rapid, automated infrastructure provisioning in the DR region. Multi-Site (C) is far more expensive. Aurora (A) requires migrating from Oracle. DRS (E) works but adds cost beyond what's needed when AMIs and CloudFormation can achieve the same goal.
</details>

---

## Question 41

A DevOps engineer is implementing a multi-region architecture. The application uses WebSocket connections, and the company needs the lowest latency for users globally while maintaining connection persistence. Which load balancer and routing combination is appropriate?

**A.** ALB in each region with Route 53 latency-based routing.

**B.** NLB in each region with Route 53 latency-based routing and Global Accelerator.

**C.** CloudFront with WebSocket support pointing to a single-region ALB.

**D.** GLB in each region with Route 53 geolocation routing.

<details>
<summary>Answer</summary>

**B.** NLB with Route 53 and Global Accelerator.

**Explanation**: NLB provides static IPs and handles TCP connections efficiently, which is ideal for WebSockets. Global Accelerator provides consistent, low-latency routing using the AWS global network (not DNS-based, so it's faster than Route 53 alone). Route 53 latency-based routing directs initial connections to the nearest region. Together, they provide the lowest latency for WebSocket connections globally. ALB (A) works for WebSockets but Global Accelerator with NLB provides better routing. CloudFront (C) supports WebSockets but a single region doesn't provide global low latency. GLB (D) is for network appliances.
</details>

---

## Question 42

A company runs an application on ECS Fargate and needs to ensure that during a rolling deployment, there are always at least 4 healthy tasks running out of a desired count of 4. What deployment configuration should the engineer set?

**A.** minimumHealthyPercent = 100, maximumPercent = 200.

**B.** minimumHealthyPercent = 50, maximumPercent = 100.

**C.** minimumHealthyPercent = 100, maximumPercent = 100.

**D.** minimumHealthyPercent = 0, maximumPercent = 200.

<details>
<summary>Answer</summary>

**A.** minimumHealthyPercent = 100, maximumPercent = 200.

**Explanation**: With minimumHealthyPercent = 100, ECS ensures all 4 existing tasks remain running during deployment. With maximumPercent = 200, ECS can launch up to 4 additional tasks (8 total), deploying the new version alongside the old before draining the old tasks. This ensures zero capacity loss during deployment. Option B allows dropping to 2 tasks. Option C prevents launching new tasks before stopping old ones (deadlock). Option D allows dropping to 0 tasks.
</details>

---

## Question 43

A company wants to use AWS Fault Injection Simulator (FIS) to test their application's resilience. They want to simulate an AZ failure and observe how their Multi-AZ architecture responds. Which FIS action is most appropriate?

**A.** `aws:ec2:terminate-instances` targeting all instances in one AZ.

**B.** `aws:ec2:send-spot-instance-interruptions` for Spot instances.

**C.** `aws:fis:inject-api-internal-error` for AWS APIs.

**D.** `aws:ec2:stop-instances` targeting instances in a specific AZ combined with `aws:network:disrupt-connectivity` for the AZ subnet.

<details>
<summary>Answer</summary>

**D.** Stop instances + disrupt network connectivity in a specific AZ.

**Explanation**: A realistic AZ failure simulation involves both compute and network disruption. Stopping instances simulates server failures, while disrupting network connectivity simulates the network isolation that occurs during an AZ outage. This combination tests whether the ALB, ASG, and database properly failover. Simply terminating instances (A) doesn't simulate network failure. Spot interruptions (B) are specific to Spot instances. API errors (C) test a different failure mode.
</details>

---

## Question 44

A company has an application that uses DynamoDB with provisioned capacity. During Black Friday sales, the table is throttled despite auto-scaling being enabled. The traffic spike happens within seconds. What change would prevent throttling during sudden spikes?

**A.** Switch to DynamoDB on-demand capacity mode.

**B.** Pre-provision extra read and write capacity units before the event.

**C.** Enable DAX for caching.

**D.** Increase the auto-scaling target utilization to 90%.

<details>
<summary>Answer</summary>

**A.** Switch to on-demand capacity mode.

**Explanation**: DynamoDB on-demand capacity instantly accommodates traffic spikes — it automatically allocates capacity as needed without throttling. Provisioned capacity with auto-scaling has a delay (CloudWatch alarm evaluation + scaling action), causing throttling during sudden spikes. Pre-provisioning (B) works if you know the exact capacity needed but doesn't handle unexpected variations. DAX (C) helps for read-heavy workloads but doesn't address write throttling. Higher utilization target (D) means scaling starts later, making the problem worse.
</details>

---

## Question 45

A company uses a microservices architecture with 10 services on ECS. They want to implement a retry policy with exponential backoff for inter-service communication. The solution must work without modifying application code. What should the engineer implement?

**A.** AWS App Mesh (service mesh) with retry policies configured on virtual routes.

**B.** An ALB with retry configuration on target groups.

**C.** A Lambda function as a proxy between services to handle retries.

**D.** SQS queues between every pair of services.

<details>
<summary>Answer</summary>

**A.** AWS App Mesh with retry policies.

**Explanation**: AWS App Mesh is a service mesh that provides application-level networking using Envoy proxies as sidecars. Retry policies with exponential backoff can be configured on virtual routes without modifying application code — the Envoy proxy handles retries transparently. ALBs (B) don't have retry configuration. Lambda proxies (C) add complexity and latency. SQS between every service pair (D) changes the communication pattern from synchronous to asynchronous, which may not be compatible.
</details>

---

*End of practice questions. Review any incorrect answers against the article.md content for deeper understanding.*
