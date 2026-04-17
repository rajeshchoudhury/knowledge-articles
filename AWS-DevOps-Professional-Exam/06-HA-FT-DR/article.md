# Domain 6: High Availability, Fault Tolerance, and Disaster Recovery (18% of Exam)

> **Exam Weight**: This domain accounts for 18% of the DOP-C02 exam — roughly 13-14 questions. Mastering HA, FT, and DR concepts is essential because they cross-cut nearly every other domain: CI/CD pipelines must be resilient, monitoring must detect failures, security controls must survive region outages, and IaC must codify recovery procedures.

---

## Table of Contents

1. [Multi-AZ Architectures](#1-multi-az-architectures)
2. [Multi-Region Architectures](#2-multi-region-architectures)
3. [Disaster Recovery Strategies](#3-disaster-recovery-strategies)
4. [Backup Strategies](#4-backup-strategies)
5. [Data Replication Patterns](#5-data-replication-patterns)
6. [High Availability for Specific Services](#6-high-availability-for-specific-services)
7. [Fault Tolerance Patterns](#7-fault-tolerance-patterns)
8. [Self-Healing Architectures](#8-self-healing-architectures)

---

## 1. Multi-AZ Architectures

Multi-AZ is the foundational building block for high availability on AWS. An Availability Zone (AZ) is one or more discrete data centers with redundant power, networking, and connectivity within an AWS Region. Deploying across multiple AZs protects applications against a single data-center failure, and AWS designs its managed services around this principle.

### 1.1 VPC Design for High Availability

A well-architected VPC for high availability follows these principles:

**Multi-AZ Subnet Layout**: Create both public and private subnets in at least two (preferably three) AZs. A typical three-AZ design includes six subnets — three public and three private. Each public subnet hosts a NAT Gateway and load balancer nodes; each private subnet hosts application and database resources.

**NAT Gateway per AZ**: Deploy one NAT Gateway in each AZ's public subnet. If you share a single NAT Gateway across AZs, a failure of that AZ takes down internet access for all private subnets. With per-AZ NAT Gateways, routing tables in each private subnet point to the local AZ's NAT Gateway, so an AZ failure only affects resources in that AZ.

**Redundant Networking**: Use multiple route tables scoped to each AZ. For hybrid connectivity, deploy AWS Direct Connect with at least two connections to different Direct Connect locations. Add a Site-to-Site VPN as a backup path. Use Transit Gateway for hub-and-spoke networking across multiple VPCs and accounts, deploying Transit Gateway attachments in multiple AZs.

**Network Load Balancing Across AZs**: Enable cross-zone load balancing to distribute traffic evenly regardless of the number of targets per AZ. Without it, each AZ receives an equal share of traffic even if one AZ has fewer healthy instances.

> **📝 Key Points for the Exam**
> - A NAT Gateway is AZ-scoped. For HA, deploy one per AZ.
> - VPC subnets are AZ-scoped; they cannot span AZs.
> - Cross-zone load balancing is enabled by default on ALB but must be explicitly enabled on NLB.
> - Transit Gateway supports multi-AZ attachments and automatic failover between AZs.

### 1.2 Elastic Load Balancing (ELB) Deep Dive

AWS offers three load balancer types, each suited to different workloads:

#### Application Load Balancer (ALB)

ALB operates at Layer 7 (HTTP/HTTPS) and is the most feature-rich option for web applications.

| Feature | Details |
|---|---|
| **Path-based routing** | Route `/api/*` to one target group, `/static/*` to another |
| **Host-based routing** | Route `api.example.com` to one target group, `web.example.com` to another |
| **Weighted target groups** | Split traffic by percentage (e.g., 90/10) for canary deployments |
| **Slow start mode** | Gradually increase traffic to new targets over a configured duration (30-900 seconds) |
| **Lambda targets** | Invoke Lambda functions directly as targets — no need for API Gateway |
| **Sticky sessions** | Application-based cookies or duration-based cookies; tie a user session to a specific target |
| **Authentication** | Native integration with Cognito and OIDC providers |
| **Cross-zone load balancing** | Enabled by default (can be disabled at target group level) |
| **Connection draining (deregistration delay)** | Default 300 seconds; allows in-flight requests to complete before deregistering a target |

**Health Checks**: ALB health checks are HTTP/HTTPS-based. You configure a path (e.g., `/health`), interval, timeout, healthy/unhealthy thresholds, and expected response codes. Unhealthy targets stop receiving traffic but remain registered until deregistered or they pass health checks again.

#### Network Load Balancer (NLB)

NLB operates at Layer 4 (TCP/UDP/TLS) and is designed for extreme performance and low latency.

| Feature | Details |
|---|---|
| **Static IP** | Each AZ gets one static IP; you can also assign Elastic IPs |
| **TCP/UDP support** | Handles millions of requests per second with ultra-low latency |
| **Preserve source IP** | Client source IP is preserved (unlike ALB where you need X-Forwarded-For) |
| **PrivateLink** | NLB is required to expose services via AWS PrivateLink (VPC endpoint services) |
| **TLS termination** | Can terminate TLS at the load balancer |
| **Cross-zone load balancing** | Disabled by default — must be explicitly enabled |
| **Health checks** | TCP, HTTP, or HTTPS |

#### Gateway Load Balancer (GLB)

GLB operates at Layer 3 (IP packets) and is designed for deploying, scaling, and managing third-party virtual appliances such as firewalls, intrusion detection systems, and deep packet inspection systems.

- Uses the GENEVE protocol on port 6081
- Integrates with Gateway Load Balancer Endpoints (GWLBE) in consumer VPCs
- Traffic is transparently routed through appliances without modifying packets

> **📝 Key Points for the Exam**
> - ALB = Layer 7, HTTP/HTTPS, path/host routing, weighted target groups.
> - NLB = Layer 4, static IPs, PrivateLink, preserve source IP.
> - GLB = Layer 3, GENEVE, transparent network appliance insertion.
> - For Blue/Green deployments, ALB with weighted target groups is key.
> - Deregistration delay (connection draining) default is 300 seconds — reduce it for faster deployments.
> - NLB cross-zone load balancing is OFF by default; ALB is ON by default.

### 1.3 Auto Scaling for High Availability

Auto Scaling Groups (ASGs) are the primary mechanism for maintaining application availability and scaling capacity.

**Multi-AZ Deployment**: Configure the ASG to span at least two AZs (preferably three). The ASG automatically distributes instances across the specified AZs. If one AZ experiences an outage, the ASG launches replacement instances in the remaining AZs.

**Capacity Rebalancing**: When enabled, ASG proactively launches new instances in other AZs before terminating instances in an AZ that is degrading. This is particularly important for Spot Instances where capacity can be reclaimed. Capacity Rebalancing responds to EC2 Rebalance Recommendation signals.

**AZ Rebalancing**: ASG automatically rebalances instances across AZs when you add or remove AZs, or when instances are launched or terminated. If an AZ becomes unhealthy, ASG launches instances in healthy AZs and terminates the unhealthy ones once replacements are running.

**Scaling Policies**:
- **Target Tracking**: Maintain a specific metric value (e.g., CPU at 50%). Simplest to configure.
- **Step Scaling**: Scale in/out based on CloudWatch alarm thresholds with defined step adjustments.
- **Simple Scaling**: Legacy — one adjustment per alarm. Use step or target tracking instead.
- **Scheduled Scaling**: Scale based on predictable load patterns (e.g., scale up before business hours).
- **Predictive Scaling**: Uses ML to forecast load and pre-provisions capacity.

**Health Checks**: ASG can use EC2 status checks (default), ELB health checks, or custom health checks. When using ELB, configure the ASG to use ELB health checks to replace instances that fail load balancer health checks.

**Instance Refresh**: Rolling replacement of instances (e.g., after a new AMI). Configure minimum healthy percentage and warm-up time. Supports checkpoints and rollback.

### 1.4 RDS Multi-AZ

Amazon RDS Multi-AZ provides high availability for relational databases through synchronous replication.

**Multi-AZ Instance Deployment (Traditional)**:
- A primary DB instance is synchronously replicated to a standby in a different AZ
- The standby is not accessible for read traffic
- Automatic failover during: AZ outage, primary instance failure, instance type change, software patching, manual failover (reboot with failover)
- Failover typically completes in 60-120 seconds
- DNS endpoint stays the same — applications reconnect to the same CNAME

**Multi-AZ DB Cluster (New)**:
- Available for MySQL and PostgreSQL
- One writer instance and two reader instances across three AZs
- Readers are accessible for read traffic (unlike traditional Multi-AZ)
- Uses a writer endpoint, reader endpoint, and instance endpoints
- Failover is faster (~35 seconds) compared to traditional Multi-AZ
- Readers use semi-synchronous replication

> **📝 Key Points for the Exam**
> - Multi-AZ is for HA, not for read scaling (traditional). Read replicas are for read scaling.
> - Multi-AZ DB Cluster provides both HA and read scaling.
> - Failover is triggered automatically — no manual intervention needed.
> - The CNAME DNS record flips to the standby during failover.
> - Multi-AZ does NOT protect against accidental deletion or corruption — you need backups for that.

### 1.5 Amazon Aurora

Aurora is AWS's cloud-native relational database, designed from the ground up for high availability.

**Architecture**: Aurora stores data in a cluster volume spanning three AZs with six copies of data (two copies per AZ). It can tolerate the loss of two copies without affecting write availability and three copies without affecting read availability.

**Read Replicas**: Up to 15 read replicas across multiple AZs. Any read replica can be promoted to primary in case of a failure. Failover priority tiers (0 to 15) determine promotion order.

**Aurora Global Database**: Spans multiple regions with typically less than 1 second replication lag. The primary region handles reads and writes; secondary regions handle reads and can be promoted for disaster recovery. Supports managed planned failover (RPO = 0) and unplanned failover (RPO typically < 1 second).

**Aurora Serverless v2**: Instantly scales compute capacity based on demand. Scales in 0.5 ACU increments. Supports Multi-AZ for HA. Ideal for variable or unpredictable workloads.

**Custom Endpoints**: Define endpoints that map to subsets of instances (e.g., larger instances for analytics queries). Useful for directing different workloads to appropriately sized instances.

**Fast Failover**: Aurora failover typically completes in under 30 seconds. With the RDS Proxy, failover is even faster as the proxy handles connection management transparently.

### 1.6 ElastiCache

**Redis Cluster Mode Enabled**: Data is partitioned across up to 500 shards. Each shard has a primary node and up to five replicas. Multi-AZ with automatic failover promotes a replica if the primary fails.

**Redis Cluster Mode Disabled**: A single shard with one primary and up to five replicas. Multi-AZ failover still works but data is not partitioned.

**Global Datastore**: Cross-region replication for Redis. One primary region (read/write) and up to two secondary regions (read-only). Typical replication lag is under 1 second.

### 1.7 DynamoDB

**Global Tables**: Multi-region, multi-active (read/write in any region) replication. Uses last-writer-wins conflict resolution. Requires DynamoDB Streams enabled. Replication is typically completed in under one second.

**On-Demand vs. Provisioned Capacity**: On-demand automatically scales to accommodate workload. Provisioned with Auto Scaling adjusts capacity based on utilization targets.

**DAX (DynamoDB Accelerator)**: In-memory cache for DynamoDB. Multi-AZ deployment for HA. Microsecond read latency for cached items.

---

## 2. Multi-Region Architectures

Multi-region architectures provide the highest levels of availability and disaster recovery capability but introduce significant complexity and cost.

### 2.1 Route 53

Route 53 is the cornerstone of multi-region architectures, providing DNS-based traffic routing and health checking.

**Routing Policies**:

| Policy | Use Case | How It Works |
|---|---|---|
| **Simple** | Single resource | Returns one or more values randomly |
| **Weighted** | A/B testing, gradual migration | Route traffic by percentage weight |
| **Latency** | Performance optimization | Route to the region with lowest latency to the user |
| **Failover** | Active-passive DR | Route to primary; failover to secondary when health check fails |
| **Geolocation** | Compliance, localization | Route based on user's geographic location |
| **Geoproximity** | Bias-adjusted geographic routing | Route based on geographic location with optional bias to shift traffic |
| **Multivalue Answer** | Simple load balancing | Return up to 8 healthy records randomly |

**Health Checks**:
- **Endpoint health checks**: Monitor an endpoint by IP or domain name. Configurable interval (10 or 30 seconds), failure threshold, and protocol (HTTP, HTTPS, TCP).
- **Calculated health checks**: Combine results of multiple health checks with AND, OR, or threshold logic (e.g., "healthy if at least 2 of 3 child checks pass").
- **CloudWatch Alarm-based health checks**: Mark healthy/unhealthy based on a CloudWatch alarm state. Useful for monitoring internal resources that health checkers can't reach directly.

**Failover Configurations**:
- **Active-Active**: Multiple resources serve traffic simultaneously. Use weighted, latency, geolocation, or multivalue routing. All resources receive traffic; unhealthy resources are removed based on health checks.
- **Active-Passive**: Primary resource serves all traffic. Failover routing policy sends traffic to secondary only when the primary health check fails. The secondary resource is idle during normal operations.

> **📝 Key Points for the Exam**
> - Route 53 health checks are initiated from multiple global locations — security groups/NACLs must allow health checker IPs.
> - For private hosted zones / private resources, use CloudWatch alarm-based health checks.
> - Alias records vs. CNAME: Alias is free, works at zone apex, and is AWS-native. Prefer Alias for AWS resources.
> - Failover routing requires health checks associated with the primary record.
> - Geolocation routing requires a "Default" record to handle locations without a specific match.

### 2.2 CloudFront

CloudFront is AWS's content delivery network (CDN) that caches content at edge locations worldwide.

**Origins**: S3 buckets, ALB, NLB, EC2, API Gateway, MediaStore, or any custom HTTP origin. Use Origin Access Control (OAC) for S3 origins to restrict direct access.

**Behaviors**: Define how CloudFront handles different URL patterns. Each behavior specifies which origin to use, caching policies, viewer protocol, allowed HTTP methods, and edge functions.

**Cache Policies**: Control what CloudFront uses as the cache key (headers, query strings, cookies). Separate from Origin Request Policies which control what is forwarded to the origin.

**Origin Failover with Origin Groups**: Create an origin group with a primary and secondary origin. If the primary returns specific error codes (e.g., 500, 502, 503, 504), CloudFront automatically fails over to the secondary origin. This is critical for HA.

**Lambda@Edge**: Run Lambda functions at CloudFront edge locations at four points: viewer request, viewer response, origin request, origin response. Use cases include A/B testing, URL rewrites, authentication, and dynamic content manipulation.

**CloudFront Functions**: Lightweight JavaScript functions that run at the edge for viewer request and viewer response events. Higher throughput and lower latency than Lambda@Edge, but more limited (no network access, smaller payload).

### 2.3 S3 Cross-Region Replication (CRR)

**Requirements**: Versioning must be enabled on both source and destination buckets. An IAM role is required to grant S3 permission to replicate objects.

**Replication Rules**: Specify which objects to replicate (all or by prefix/tag filter). Choose the destination bucket (same or different account). Configure storage class for replicas.

**Replication Time Control (RTC)**: Guarantees that 99.99% of objects replicate within 15 minutes. Publishes replication metrics to CloudWatch. Costs more but provides predictable replication time.

**S3 Replication Metrics**: CloudWatch metrics for replication latency and pending operations. Enable these for monitoring replication health.

**Key Behaviors**:
- Existing objects are NOT replicated when you enable replication — only new objects. Use S3 Batch Replication for existing objects.
- Delete markers can optionally be replicated.
- Deletes of specific versions are NOT replicated (to prevent malicious deletes propagating).
- No chaining: if Bucket A replicates to Bucket B, and Bucket B replicates to Bucket C, objects from A do NOT replicate to C.

### 2.4 Multi-Region Event Architectures with EventBridge

EventBridge supports cross-region event routing through Global Endpoints. A Global Endpoint uses a managed Route 53 health check tied to a CloudWatch alarm. When the primary region becomes unhealthy, events are automatically routed to the secondary region.

You can also create rules that forward events to event buses in other regions for event-driven multi-region architectures.

### 2.5 API Gateway

| Type | Description | Use Case |
|---|---|---|
| **Regional** | API deployed in a specific region | Standard APIs, multi-region with Route 53 |
| **Edge-Optimized** | API deployed with CloudFront distribution | Global users, single region origin |
| **Private** | API accessible only within VPC | Internal microservices |

For multi-region APIs, deploy Regional endpoints in each region and use Route 53 latency or failover routing with custom domain names.

---

## 3. Disaster Recovery Strategies

This section is **mission-critical for the exam**. Expect multiple questions on DR strategy selection based on RTO/RPO requirements and cost constraints.

### 3.1 Core Concepts

**RTO (Recovery Time Objective)**: The maximum acceptable time between a disaster and full service restoration. "How long can the business survive without the system?"

**RPO (Recovery Point Objective)**: The maximum acceptable amount of data loss measured in time. "How much data can the business afford to lose?"

Lower RTO and RPO = higher cost and complexity. The exam tests your ability to select the appropriate DR strategy based on these requirements.

### 3.2 The Four DR Strategies

#### Strategy 1: Backup and Restore

**RTO**: Hours | **RPO**: Hours | **Cost**: Lowest

The simplest and cheapest strategy. Data is backed up regularly and stored in another region. In a disaster, infrastructure is rebuilt and data is restored from backups.

**Implementation**:
- S3 Cross-Region Replication for backups
- AMI copying to the DR region
- EBS snapshots copied cross-region
- RDS automated backups and manual snapshots copied cross-region
- DynamoDB backups exported to S3 and replicated
- CloudFormation templates stored in S3 for rapid infrastructure provisioning

**Drawbacks**: Longest recovery time. Must provision all infrastructure from scratch during a disaster. Highest data loss potential.

#### Strategy 2: Pilot Light

**RTO**: 10s of minutes | **RPO**: Minutes | **Cost**: Low

A minimal version of the core infrastructure is always running in the DR region. Typically this means the database is replicated (e.g., RDS read replica, Aurora Global Database) but compute resources are not running. On failover, you start/scale compute resources and switch DNS.

**Implementation**:
- RDS cross-region read replica or Aurora Global Database in DR region
- AMIs registered and available in DR region
- Launch templates and ASG configurations pre-configured (desired count = 0 or minimal)
- Infrastructure as Code ready to scale up
- Route 53 failover routing configured

**On Failover**:
1. Promote the read replica / failover Aurora Global Database
2. Scale up ASGs, start EC2 instances
3. Update Route 53 or let health check failover trigger

#### Strategy 3: Warm Standby

**RTO**: Minutes | **RPO**: Seconds to minutes | **Cost**: Medium

A scaled-down but fully functional version of the production environment runs in the DR region. It handles a portion of traffic or is idle but ready.

**Implementation**:
- Full infrastructure running at reduced capacity in the DR region
- Database is synchronized (read replicas, Global Tables, Aurora Global DB)
- ASGs running with minimum instances
- Load balancers and networking fully configured
- May handle read traffic to justify cost

**On Failover**:
1. Scale up ASGs to production capacity
2. Promote databases if needed
3. Switch DNS via Route 53

#### Strategy 4: Multi-Site Active/Active

**RTO**: Near zero (seconds) | **RPO**: Near zero | **Cost**: Highest

Full production environments in two or more regions actively serving traffic simultaneously. This provides the lowest possible RTO and RPO.

**Implementation**:
- Full production infrastructure in multiple regions
- DynamoDB Global Tables or Aurora Global Database for data
- Route 53 latency or weighted routing for traffic distribution
- Stateless application tier
- Conflict resolution strategies for concurrent writes

**On Failover**:
1. Route 53 health checks detect failure
2. Traffic automatically routes to healthy regions
3. Potentially no manual intervention required

### 3.3 DR Strategy Comparison Table

| Strategy | RTO | RPO | Cost | Complexity | Steady-State Resources in DR |
|---|---|---|---|---|---|
| **Backup & Restore** | Hours | Hours | $ | Low | None (just backups) |
| **Pilot Light** | 10s of min | Minutes | $$ | Medium | Core data only |
| **Warm Standby** | Minutes | Seconds-Min | $$$ | High | Scaled-down full stack |
| **Multi-Site** | Seconds | Near zero | $$$$ | Very High | Full production |

> **📝 Key Points for the Exam**
> - **Know this table cold.** Given an RTO/RPO requirement and cost constraint, you must select the right strategy.
> - Pilot Light vs. Warm Standby: Pilot Light has only the database (core) running. Warm Standby has a scaled-down but complete stack running.
> - "Cost-effective with 1-hour RTO" → Pilot Light or Warm Standby depending on specifics.
> - "Near-zero downtime, money is no object" → Multi-Site Active/Active.
> - "Lowest cost, can tolerate hours of downtime" → Backup and Restore.
> - RDS read replica promotion breaks replication — it becomes a standalone DB.
> - Aurora Global Database supports managed planned failover with zero data loss.

### 3.4 AWS Elastic Disaster Recovery (DRS)

AWS Elastic Disaster Recovery (formerly CloudEndure) provides automated, continuous replication for disaster recovery.

**How It Works**:
1. Install the AWS Replication Agent on source servers (on-premises or cloud)
2. Agent continuously replicates data to a staging area in the target AWS region (lightweight EC2 instances with EBS volumes)
3. Data is compressed and encrypted in transit
4. On failover, launch drill/recovery instances from the replicated data

**Key Concepts**:
- **Continuous Replication**: Block-level replication with sub-second RPO
- **Launch Settings**: Define instance type, subnet, security group, and other settings for recovery instances
- **Drill**: Test your DR plan without impacting production or replication
- **Failover**: Launch recovery instances and redirect traffic
- **Failback**: After the primary site is restored, replicate back and switch over

**Exam Relevance**: DRS is the answer when questions mention migrating on-premises servers to AWS for DR, or when you need sub-second RPO with continuous replication.

### 3.5 Database DR Strategies by Service

| Service | DR Mechanism | RPO | RTO |
|---|---|---|---|
| **RDS** | Cross-region read replica, snapshot copy | Minutes (replica), Hours (snapshot) | Minutes (promotion), Hours (restore) |
| **Aurora** | Global Database | ~1 second | ~1 minute (managed failover) |
| **DynamoDB** | Global Tables | Sub-second | Sub-second (active-active) |
| **ElastiCache Redis** | Global Datastore | Sub-second | Minutes |
| **Redshift** | Cross-region snapshot copy | Hours | Hours |
| **DocumentDB** | Global Clusters | ~1 second | ~1 minute |

### 3.6 Testing DR Plans

DR plans must be tested regularly. AWS services that support DR testing:

- **DRS**: Supports non-disruptive drills that don't affect replication
- **Aurora Global Database**: Managed planned failover for testing
- **GameDay exercises**: Simulate failure scenarios
- **Chaos engineering**: AWS Fault Injection Simulator (FIS) to inject failures
- **Runbooks**: Document step-by-step failover procedures in Systems Manager documents

---

## 4. Backup Strategies

### 4.1 AWS Backup

AWS Backup is a centralized backup service that automates and manages backups across AWS services.

**Supported Services**: EC2, EBS, RDS, Aurora, DynamoDB, EFS, FSx, Neptune, DocumentDB, S3, VMware workloads, and more.

**Key Components**:

**Backup Plans**: Define backup frequency (cron or rate expression), retention period, lifecycle rules (transition to cold storage), and backup vault. A plan contains one or more backup rules.

**Backup Vaults**: Logical containers for backups. Each vault has an encryption key (AWS KMS). You can set access policies on vaults to control who can manage or restore backups.

**Vault Lock**: Enforce a WORM (Write Once, Read Many) model on a vault. Once locked, backups cannot be deleted by anyone, including the root user. Supports governance mode (can be removed) and compliance mode (cannot be removed — irreversible). Critical for regulatory compliance.

**Cross-Account Backup**: Copy backups to a vault in another AWS account for additional protection. Requires an Organization with cross-account backup enabled. Configure backup policies in the destination account to accept incoming copies.

**Cross-Region Backup**: Copy backups to a vault in another AWS region. Configure as part of the backup rule — specify destination region and vault.

**Backup Policies in Organizations**: Use AWS Organizations backup policies to centrally define and enforce backup plans across all accounts. Policies are applied through organizational units (OUs) and inheritance.

> **📝 Key Points for the Exam**
> - AWS Backup is the unified answer for centralized backup management questions.
> - Vault Lock in compliance mode is the answer for "prevent anyone including root from deleting backups."
> - Cross-account + cross-region backup is the most resilient configuration.
> - AWS Backup integrates with Organizations for enterprise-wide backup governance.

### 4.2 EBS Snapshots

**Amazon Data Lifecycle Manager (DLM)**: Automate the creation, retention, and deletion of EBS snapshots and AMIs. Define lifecycle policies with schedules, retention counts or age-based retention, and tags for target volumes.

**Cross-Region Copy**: DLM policies can automatically copy snapshots to another region. You can also manually copy snapshots cross-region.

**Fast Snapshot Restore (FSR)**: Eliminates the performance penalty when restoring data from a snapshot. Volumes created from FSR-enabled snapshots deliver full provisioned performance immediately. Costs extra per AZ-hour.

**EBS Snapshots are incremental**: Only changed blocks are stored after the initial full snapshot. Deleting a snapshot only removes blocks not referenced by other snapshots.

### 4.3 RDS Backups

**Automated Backups**: Enabled by default with a configurable retention period (1-35 days). Creates daily snapshots and captures transaction logs every 5 minutes. Supports point-in-time recovery (PITR) to any second within the retention period.

**Manual Snapshots**: User-initiated, retained until explicitly deleted. Not affected by the automated backup retention period.

**Cross-Region Snapshot Copy**: Manually or automatically copy snapshots to another region. Automated cross-region backups can be enabled to automatically replicate snapshots and transaction logs.

**Export to S3**: Export RDS snapshots to S3 in Apache Parquet format for analytics. Uses KMS encryption.

### 4.4 S3 Versioning and Lifecycle Policies

**Versioning**: Maintains multiple versions of objects. Protects against accidental deletes (creates a delete marker; previous versions remain). Required for cross-region replication. MFA Delete adds an extra layer of protection.

**Lifecycle Policies**: Automate transitions between storage classes and object expiration.
- Transition current versions to S3-IA after 30 days, Glacier after 90 days
- Expire noncurrent versions after 90 days
- Delete incomplete multipart uploads after 7 days
- Delete expired object delete markers

### 4.5 DynamoDB Backups

**On-Demand Backup**: Full backup at any time, retained until deleted. No impact on table performance. Restores to a new table.

**Point-in-Time Recovery (PITR)**: Continuous backups with 35-day retention. Restore to any second within the retention window. Must be explicitly enabled. Restores to a new table.

---

## 5. Data Replication Patterns

### 5.1 Synchronous vs. Asynchronous Replication

| Aspect | Synchronous | Asynchronous |
|---|---|---|
| **How it works** | Write is acknowledged only after replicated | Write is acknowledged immediately; replication follows |
| **Data consistency** | Strong consistency | Eventual consistency |
| **Latency impact** | Higher write latency | Minimal write latency impact |
| **RPO** | Zero (no data loss) | Non-zero (some data loss possible) |
| **Distance** | Typically within a region (same AZ pair) | Can span regions |
| **AWS Examples** | RDS Multi-AZ, Aurora cluster volume, EBS io2 Multi-Attach | RDS read replicas, S3 CRR, DynamoDB Global Tables, Aurora Global DB |

### 5.2 RDS Read Replicas

- Up to 15 read replicas for Aurora, 5 for other engines
- Cross-region read replicas for both geographic read performance and DR
- Asynchronous replication — eventual consistency
- Can be promoted to a standalone DB instance (breaks replication)
- Cross-region read replicas support encryption (using a KMS key in the destination region)

### 5.3 S3 Replication

**Same-Region Replication (SRR)**: Replicate objects within the same region.
- Use cases: Log aggregation, compliance copies, test/dev data
- Same versioning and rule requirements as CRR

**Cross-Region Replication (CRR)**: Replicate objects to a different region.
- Use cases: DR, compliance with geographic data requirements, latency optimization
- Replication Time Control (RTC): 99.99% of objects in 15 minutes

**Bi-Directional Replication**: Configure replication rules in both directions between two buckets. Enable replica modification sync to replicate metadata changes to replicas.

### 5.4 EFS Replication

Amazon EFS supports automatic replication to another region or within the same region. Replication is asynchronous. The RPO is typically 15 minutes or less. The destination file system is read-only and can be promoted for failover.

### 5.5 Database Migration Service (DMS) for Continuous Replication

DMS supports ongoing replication (Change Data Capture / CDC) for continuous data synchronization between source and target databases. Use cases include:
- Heterogeneous database migration with ongoing replication
- Cross-region data synchronization
- Database consolidation
- Real-time data warehousing

---

## 6. High Availability for Specific Services

### 6.1 Amazon ECS

**Service Auto Scaling**: Target tracking, step scaling, or scheduled scaling on CloudWatch metrics like CPU, memory, or custom metrics. Use Application Auto Scaling.

**Multi-AZ Task Placement**: ECS distributes tasks across AZs by default using the "spread" placement strategy on the `attribute:ecs.availability-zone` attribute. This ensures tasks are evenly distributed for HA.

**Circuit Breaker**: ECS deployment circuit breaker detects failed deployments and automatically rolls back to the last stable state. Enable it with the rollback option. If a deployment can't reach steady state, the circuit breaker stops the deployment and rolls back.

**Capacity Providers**: Use Fargate and Fargate Spot capacity providers for serverless HA. For EC2 launch type, use capacity providers with managed scaling and managed termination protection.

### 6.2 Amazon EKS

**Multi-AZ Node Groups**: Deploy managed node groups across multiple AZs. EKS distributes nodes across AZs automatically.

**Pod Disruption Budgets (PDBs)**: Define the minimum number or percentage of pods that must remain available during voluntary disruptions (e.g., node drains, cluster upgrades). Prevents taking down too many pods at once.

**Cluster Autoscaler vs. Karpenter**:
- **Cluster Autoscaler**: Adjusts the number of nodes based on pending pods. Works with ASGs. Slower to respond; relies on ASG scaling.
- **Karpenter**: AWS-developed node provisioner. Directly provisions EC2 instances (no ASG dependency). Faster, more flexible, supports diverse instance types and consolidation. The modern recommended approach.

**Pod Topology Spread Constraints**: Distribute pods across failure domains (AZs, nodes) for HA. More flexible than pod anti-affinity rules.

### 6.3 AWS Lambda

**Multi-Region**: Deploy Lambda functions in multiple regions. Use Route 53 with API Gateway or Function URLs for failover.

**Reserved Concurrency**: Guarantee a minimum number of concurrent executions for critical functions. Prevents throttling during spikes.

**Provisioned Concurrency**: Keep functions pre-initialized to eliminate cold starts. Configure auto scaling for provisioned concurrency.

**Retry Behavior**: Synchronous invocations — caller retries. Asynchronous invocations — Lambda retries twice with delays. Event source mappings — retries depend on the source (SQS retries until message visibility timeout; Kinesis retries until record expires).

### 6.4 SQS/SNS

Both SQS and SNS are inherently highly available:
- **SQS**: Messages are stored redundantly across multiple AZs. Standard queues provide at-least-once delivery. FIFO queues provide exactly-once processing.
- **SNS**: Messages are stored across multiple AZs. Supports message durability with delivery retries and DLQ.

---

## 7. Fault Tolerance Patterns

### 7.1 Retry with Exponential Backoff and Jitter

When a transient failure occurs, retry the operation with increasing wait times. Add jitter (randomization) to prevent thundering herd problems where many clients retry simultaneously.

```
wait_time = min(base * 2^attempt + random_jitter, max_wait)
```

AWS SDKs implement this by default. Step Functions support configurable retry with exponential backoff.

### 7.2 Circuit Breaker Pattern

Prevent cascading failures by stopping calls to a failing service. Three states:
1. **Closed**: Requests flow normally. Failures are counted.
2. **Open**: Requests are immediately rejected. No calls to the failing service.
3. **Half-Open**: After a timeout, allow a limited number of test requests. If successful, close the circuit. If they fail, reopen.

AWS implementations: ECS deployment circuit breaker, App Mesh circuit breaking, custom implementation with Step Functions or Lambda.

### 7.3 Bulkhead Pattern

Isolate components to prevent a failure in one from affecting others. Like bulkheads in a ship, failures are contained.

AWS implementations: Separate ASGs for different services, separate SQS queues for different workloads, separate Lambda functions with reserved concurrency, VPC subnet isolation.

### 7.4 Timeout Patterns

Set timeouts on all external calls to prevent indefinite blocking. Combine with retries and circuit breakers.

AWS implementations: API Gateway timeout (max 29 seconds), Lambda timeout (max 15 minutes), Step Functions timeouts (HeartbeatSeconds, TimeoutSeconds), ALB idle timeout.

### 7.5 Queue-Based Leveling

Use a queue between producers and consumers to absorb load spikes. The queue buffers requests, and consumers process them at their own pace.

AWS implementations: SQS between API Gateway and Lambda/ECS, SQS with ASG scaling based on ApproximateNumberOfMessagesVisible, SNS fan-out to multiple SQS queues.

### 7.6 Saga Pattern for Distributed Transactions

Manage data consistency across microservices through a sequence of local transactions. Each step has a compensating transaction for rollback.

Two approaches:
- **Choreography**: Each service publishes events that trigger the next step. Decentralized but can be complex.
- **Orchestration**: A central coordinator (Step Functions) manages the saga. Easier to understand and debug.

AWS Step Functions is the ideal service for implementing orchestration-based sagas.

### 7.7 Idempotency

Design operations so that performing them multiple times produces the same result as performing them once. Critical for retries and at-least-once delivery systems.

Techniques:
- Use idempotency tokens/keys in requests
- Check-before-write patterns with DynamoDB conditional writes
- Powertools for AWS Lambda provides idempotency utilities
- DynamoDB conditional expressions for atomic updates

> **📝 Key Points for the Exam**
> - Step Functions is the go-to for implementing saga pattern with error handling and compensation.
> - Circuit breaker = ECS deployment circuit breaker for container scenarios.
> - Queue-based leveling with SQS + ASG is a classic scaling pattern.
> - AWS SDKs implement exponential backoff by default.
> - Idempotency is required when using SQS standard queues (at-least-once delivery).

---

## 8. Self-Healing Architectures

Self-healing systems automatically detect and recover from failures without human intervention.

### 8.1 Auto Scaling Health Checks

**EC2 Health Checks**: Default for ASG. Monitors the EC2 instance status (running, stopped, terminated, impaired). Replaces instances that are not in the "running" state.

**ELB Health Checks**: When configured, ASG considers an instance unhealthy if it fails ELB health checks — even if the EC2 status check passes. This catches application-level failures that EC2 checks miss.

**Grace Period**: Configure a health check grace period so new instances have time to start and pass health checks before being terminated. Default is 300 seconds.

**Custom Health Checks**: Set instance health via the `SetInstanceHealth` API. Useful for application-aware health checking.

### 8.2 Route 53 Health Check Failover

Route 53 health checks continuously monitor endpoints. When a health check fails, Route 53 removes the unhealthy resource from DNS responses.

**Automatic Recovery Flow**:
1. Health check detects failure (based on threshold, e.g., 3 consecutive failures)
2. Route 53 updates DNS to exclude unhealthy endpoint
3. Traffic shifts to healthy endpoints (failover, weighted, latency)
4. When the endpoint recovers and health check passes, it's added back

### 8.3 ECS Service Auto-Recovery

ECS services maintain a desired count of tasks. If a task fails or is stopped, the ECS service scheduler automatically launches a replacement. Combined with multi-AZ placement, tasks are replaced in healthy AZs.

The deployment circuit breaker adds intelligence: if new deployments keep failing, it rolls back automatically instead of continuously cycling failed tasks.

### 8.4 EC2 Auto-Recovery

**StatusCheckFailed_System**: CloudWatch alarm triggers EC2 auto-recovery when the system status check fails. The instance is migrated to new underlying hardware, retaining the instance ID, private IP, Elastic IP, instance metadata, and placement group membership.

**Requirements**: Instance must use EBS-backed storage (not instance store). Supports most instance types. Configure via CloudWatch alarms or EC2 instance recovery attribute.

**Auto-Recovery vs. ASG**: Auto-recovery preserves the specific instance (same IP, same EBS volumes). ASG replacement creates a new instance. Use auto-recovery when you need to preserve instance identity; use ASG when instances are stateless and interchangeable.

### 8.5 Lambda Retry Behavior

| Invocation Type | Retry Behavior |
|---|---|
| **Synchronous** | No automatic retries — caller must retry |
| **Asynchronous** | Retries twice (3 total attempts) with delays. Configure maximum retry attempts (0, 1, 2) and maximum event age. Failed events go to DLQ or on-failure destination |
| **Event Source Mapping (SQS)** | Message retried until visibility timeout expires. After maxReceiveCount, sent to DLQ |
| **Event Source Mapping (Kinesis/DynamoDB)** | Retries until record expires. Configure retry attempts, max record age, bisect batch on error, on-failure destination |

### 8.6 Step Functions Error Handling

Step Functions provides robust error handling for self-healing workflows:

**Retry**: Automatically retry failed states with configurable:
- `IntervalSeconds`: Wait between retries
- `BackoffRate`: Multiplier for exponential backoff
- `MaxAttempts`: Maximum retry count
- `ErrorEquals`: Which errors to catch

**Catch**: Define fallback states when retries are exhausted. Route to cleanup, notification, or compensation logic.

**Heartbeat**: For long-running tasks, require periodic heartbeats. If no heartbeat within `HeartbeatSeconds`, the task is considered failed.

**Timeouts**: `TimeoutSeconds` limits total task duration. Prevents hung tasks from blocking workflows.

> **📝 Key Points for the Exam**
> - EC2 auto-recovery preserves instance ID and IP. ASG replacement does not.
> - ELB health checks on ASG catch application failures that EC2 checks miss — always enable this.
> - Lambda async retries: 2 retries by default. Use destinations or DLQ for failed events.
> - Step Functions Retry + Catch is the standard pattern for error handling in workflows.
> - ECS circuit breaker + rollback prevents stuck deployments.
> - Health check grace period prevents premature instance termination during startup.

---

## Summary: High-Impact Exam Concepts

### Top Scenarios You'll See on the Exam

1. **"Company needs DR with RTO of 15 minutes and RPO of 1 minute"** → Warm Standby or Pilot Light with Aurora Global Database
2. **"Minimize cost while still providing DR across regions"** → Backup and Restore or Pilot Light
3. **"Zero-downtime deployment across regions"** → Multi-Site Active/Active with Route 53
4. **"Database must survive a regional outage"** → Aurora Global Database or DynamoDB Global Tables
5. **"Prevent anyone from deleting backups"** → AWS Backup Vault Lock (compliance mode)
6. **"Auto-recover from failed deployments"** → ECS circuit breaker with rollback, CodeDeploy auto-rollback
7. **"Application must handle AZ failure automatically"** → Multi-AZ with ALB + ASG
8. **"Migrate on-premises servers for DR"** → AWS Elastic Disaster Recovery (DRS)
9. **"Process messages even during failures"** → SQS with DLQ and retry logic
10. **"Manage distributed transactions across microservices"** → Step Functions (saga pattern)

### Decision Framework

```
Need HA within a region? → Multi-AZ (ALB + ASG + RDS Multi-AZ)
Need HA across regions? → Multi-Region (Route 53 + CloudFront + Global Database)
Need DR with lowest cost? → Backup and Restore
Need DR with fast recovery? → Pilot Light or Warm Standby
Need near-zero downtime? → Multi-Site Active/Active
Need to prevent data loss? → Synchronous replication or continuous backup
Need self-healing? → ASG + ELB health checks + Route 53 failover
Need fault tolerance? → Retry + Circuit breaker + Queue-based leveling
```

---

*This domain is heavily tested and cross-cuts all other domains. Practice identifying the correct DR strategy given RTO/RPO constraints and cost requirements. Understand the difference between HA (surviving component failure) and DR (surviving regional disaster).*
