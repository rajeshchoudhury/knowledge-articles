# High Availability & Disaster Recovery

## Introduction

High Availability (HA) and Disaster Recovery (DR) are among the most heavily tested topics on the AWS Solutions Architect Associate exam. You must understand the difference between HA and DR, know the four DR strategies and when to use each, understand RPO and RTO, and know the HA capabilities of every major AWS service. This article provides an exhaustive reference covering every scenario the exam may throw at you.

---

## Fundamental Concepts

### High Availability (HA) vs Disaster Recovery (DR)

| Concept | Definition | Goal |
|---------|-----------|------|
| **High Availability** | System is operational and accessible as much as possible | Minimize downtime during normal operations |
| **Disaster Recovery** | Ability to recover from a catastrophic event | Restore operations after a major failure |

- **HA** is about keeping the system running (preventing downtime)
- **DR** is about getting the system back after it has gone down
- HA reduces the need for DR, but HA alone is not a DR strategy
- You can have HA within a Region (multi-AZ) and DR across Regions (multi-Region)

### Fault Tolerance vs High Availability

- **Fault Tolerance:** System continues operating without interruption when a component fails (zero downtime). Example: Active-active database cluster.
- **High Availability:** System recovers quickly from failure with minimal downtime. Example: RDS Multi-AZ with automatic failover (~60 seconds).

---

## RPO and RTO

### Recovery Point Objective (RPO)

**Definition:** The maximum acceptable amount of data loss measured in time. How far back in time can you afford to lose data?

**Examples:**
| RPO | Meaning | Example |
|-----|---------|---------|
| RPO = 0 | No data loss tolerated | Synchronous replication (Aurora Global DB write forwarding, DynamoDB Global Tables) |
| RPO = 1 hour | Can lose up to 1 hour of data | Automated backups every hour |
| RPO = 24 hours | Can lose up to 1 day of data | Daily database snapshots |

**How to reduce RPO:**
- More frequent backups/snapshots
- Continuous replication (synchronous or asynchronous)
- Transaction log shipping
- DynamoDB Point-in-Time Recovery (RPO of seconds)

### Recovery Time Objective (RTO)

**Definition:** The maximum acceptable amount of time to restore the system after a disaster. How long can the system be down?

**Examples:**
| RTO | Meaning | Example |
|-----|---------|---------|
| RTO = 0 | No downtime tolerated | Active-active multi-Region (instant failover) |
| RTO = 1 minute | 1 minute of downtime | Route 53 failover + pre-provisioned standby |
| RTO = 4 hours | Up to 4 hours downtime | Restore from snapshots, launch new infrastructure |
| RTO = 24 hours | Up to 1 day downtime | Backup and restore from S3 |

**How to reduce RTO:**
- Pre-provision infrastructure (higher cost)
- Use automation for recovery (CloudFormation, Lambda)
- Use Route 53 health checks for automatic DNS failover
- Use multi-Region active-active architecture

### The Fundamental Trade-Off

**Lower RPO/RTO = Higher Cost**

```
Cost ←────────────────────────────────────────────→ Low
RTO  ←────────────────────────────────────────────→ High

Multi-Site    Warm Standby    Pilot Light    Backup & Restore
Active-Active                                
($$$$)        ($$$)           ($$)           ($)
```

---

## Disaster Recovery Strategies

### Strategy 1: Backup and Restore

**Concept:** Regularly back up data and configurations. In the event of a disaster, restore everything from backups.

**How it works:**
1. **Normal operations:** Automated backups of databases (RDS snapshots, DynamoDB backups), AMI creation for EC2 instances, S3 cross-region replication of critical data, EBS snapshot copies to DR Region
2. **During disaster:** Launch new infrastructure from CloudFormation templates, restore databases from snapshots, launch EC2 instances from AMIs, update DNS to point to new infrastructure

**Characteristics:**
| Attribute | Value |
|-----------|-------|
| **RTO** | Hours (typically 4-24 hours) |
| **RPO** | Hours (depends on backup frequency) |
| **Cost** | Lowest (only pay for backup storage during normal operations) |
| **Complexity** | Lowest |

**Key AWS Services:**
- **S3** — Store backups, AMIs, snapshots
- **S3 Cross-Region Replication** — Replicate backups to DR Region
- **AWS Backup** — Centralized, automated backup across services
- **EBS Snapshots** — Point-in-time copies of volumes
- **RDS Automated Backups** — Automated daily snapshots + transaction logs
- **CloudFormation** — Recreate infrastructure from templates
- **AMIs** — Pre-configured machine images for quick EC2 launch

**When to use:**
- Non-critical workloads that can tolerate hours of downtime
- Budget constraints prevent always-on DR infrastructure
- Development and testing environments

**Exam tip:** If the question asks for the **cheapest DR option** or mentions workloads that can tolerate **hours of downtime**, Backup and Restore is the answer.

---

### Strategy 2: Pilot Light

**Concept:** Keep the absolute minimum version of the environment always running in the DR Region. Only the most critical core components (like the database) are kept running. Other components are "off" but pre-configured and ready to be scaled up.

**How it works:**
1. **Normal operations:** Database is replicated to DR Region (RDS cross-region read replica or Aurora Global Database). AMIs are prepared and up-to-date. CloudFormation templates are ready. No application servers are running in DR Region.
2. **During disaster:** Promote the read replica to primary. Launch application servers from AMIs using CloudFormation/Auto Scaling. Scale up to production capacity. Update DNS (Route 53) to point to DR Region.

**Characteristics:**
| Attribute | Value |
|-----------|-------|
| **RTO** | Tens of minutes (10-30 minutes) |
| **RPO** | Minutes (continuous replication) |
| **Cost** | Low (only database replication + minimal infrastructure) |
| **Complexity** | Moderate |

**What's always running in DR:**
- Database (read replica)
- Core infrastructure (VPC, subnets, security groups)

**What's NOT running (but pre-configured):**
- Application servers (EC2, ECS tasks)
- Load balancers
- Auto Scaling Groups (set to 0 instances)

**Key AWS Services:**
- **RDS Cross-Region Read Replica** — Continuous database replication
- **Aurora Global Database** — Low-latency cross-Region replication
- **Route 53** — DNS failover
- **CloudFormation** — Rapid infrastructure deployment
- **Auto Scaling** — Scale from 0 to production capacity

**When to use:**
- Core business systems that need faster recovery than Backup & Restore
- Moderate budget for DR
- Acceptable downtime of 10-30 minutes

**Exam tip:** If the question mentions **"minimal always-on resources"** or **"keep critical core services running,"** Pilot Light is the answer.

---

### Strategy 3: Warm Standby

**Concept:** A scaled-down but fully functional copy of the production environment runs in the DR Region at all times. It can handle a fraction of production traffic and can be quickly scaled up to full production capacity.

**How it works:**
1. **Normal operations:** A smaller version of the production environment runs in the DR Region. All components are running (web servers, app servers, database) but at reduced capacity. Database is synchronized via replication. The DR environment may handle a small portion of read traffic.
2. **During disaster:** Scale up the DR environment to full production capacity (increase ASG desired count, scale up database). Route 53 failover switches traffic to DR Region. Full production capacity achieved in minutes.

**Characteristics:**
| Attribute | Value |
|-----------|-------|
| **RTO** | Minutes (typically 5-15 minutes) |
| **RPO** | Seconds to minutes (continuous replication) |
| **Cost** | Medium-High (scaled-down but running environment) |
| **Complexity** | Moderate-High |

**What's always running in DR:**
- Database (full replica)
- Application servers (scaled down, e.g., 2 instead of 20)
- Load balancers
- All networking infrastructure

**Key AWS Services:**
- **Route 53** — Health checks + failover routing
- **Auto Scaling** — Quickly scale up instances
- **Aurora Global Database** — Fast cross-Region failover
- **Elastic Load Balancing** — Already running, handles traffic immediately
- **CloudWatch Alarms** — Trigger scale-up automation

**When to use:**
- Business-critical applications that need recovery in minutes
- Budget allows for a running (but smaller) standby environment
- Applications where data loss must be minimal

**Exam tip:** If the question describes a **"scaled-down but functional copy"** or mentions achieving **RTO in minutes**, Warm Standby is the answer.

---

### Strategy 4: Multi-Site Active-Active

**Concept:** Full production environments run simultaneously in two or more Regions, each serving live traffic. If one Region fails, the other Regions absorb 100% of the traffic with no interruption.

**How it works:**
1. **Normal operations:** Full production workloads run in 2+ Regions simultaneously. Route 53 distributes traffic (latency-based, weighted, or geolocation routing). Data is replicated bidirectionally in near real-time (DynamoDB Global Tables, Aurora Global Database).
2. **During disaster:** Route 53 health checks detect the failure. DNS automatically routes all traffic to the healthy Region(s). No manual intervention required. No scale-up needed (other Regions are already at capacity, or auto-scale to absorb).

**Characteristics:**
| Attribute | Value |
|-----------|-------|
| **RTO** | Near zero (seconds to minutes) |
| **RPO** | Near zero (synchronous or near-synchronous replication) |
| **Cost** | Highest (full duplicate production environment) |
| **Complexity** | Highest |

**Key AWS Services:**
- **Route 53** — Multi-value, latency-based, or failover routing
- **DynamoDB Global Tables** — Multi-Region, multi-active replication
- **Aurora Global Database** — Cross-Region replication with <1s lag
- **S3 Cross-Region Replication** — Object replication
- **Global Accelerator** — Anycast IP with automatic failover
- **CloudFront** — Origin failover for edge caching

**When to use:**
- Mission-critical, zero-downtime applications (financial, healthcare, e-commerce)
- Global user base requiring low latency in multiple Regions
- Budget allows for full duplicate infrastructure

**Exam tip:** If the question requires **near-zero RTO/RPO** or describes **active-active multi-Region**, this is the answer. It's also the **most expensive** option.

---

## Complete DR Strategy Comparison Table

| Attribute | Backup & Restore | Pilot Light | Warm Standby | Multi-Site Active-Active |
|-----------|-----------------|-------------|--------------|-------------------------|
| **RTO** | Hours | 10s of minutes | Minutes | Near zero |
| **RPO** | Hours | Minutes | Seconds-Minutes | Near zero |
| **Cost** | $ (lowest) | $$ | $$$ | $$$$ (highest) |
| **Complexity** | Low | Moderate | Moderate-High | High |
| **Always running in DR** | Nothing (backups only) | Core data (DB replica) | Full environment (scaled down) | Full production |
| **Recovery action** | Restore everything | Scale up compute | Scale up to full capacity | Automatic failover |
| **Data replication** | Periodic backups | Continuous (DB only) | Continuous (all) | Continuous bidirectional |
| **Example workload** | Dev/test, non-critical | Internal business apps | Customer-facing web apps | Financial trading, healthcare |

---

## HA Patterns for Each AWS Service

### Amazon EC2

| HA Mechanism | Description |
|-------------|-------------|
| **Auto Scaling Group (ASG)** | Automatically replaces unhealthy instances, maintains desired count |
| **Multi-AZ deployment** | Distribute instances across 2+ AZs in ASG |
| **Elastic Load Balancer** | Distributes traffic to healthy instances, performs health checks |
| **Launch Template** | Consistent instance configuration for replacements |
| **EBS snapshots** | Point-in-time backups for volume recovery |
| **AMIs** | Pre-baked machine images for fast instance launch |
| **Placement Groups (Spread)** | Instances on different hardware to reduce correlated failures |

**Best practice:** ASG spanning 3 AZs + ALB + health checks + launch template

### Amazon RDS

| HA Mechanism | Description |
|-------------|-------------|
| **Multi-AZ deployment** | Synchronous standby replica in another AZ; automatic failover (~60s) |
| **Read Replicas** | Asynchronous replicas for read scaling; can be promoted to standalone |
| **Cross-Region Read Replicas** | Read replicas in another Region for DR |
| **Automated Backups** | Daily snapshots + transaction logs; restore to any point in retention period |
| **Manual Snapshots** | User-triggered snapshots; persist until deleted |

**Multi-AZ details:**
- Standby is NOT used for reads (it's a failover target only)
- Failover triggers: AZ outage, instance failure, storage failure, network failure
- Automatic failover updates the DNS CNAME to point to the standby
- Failover time: typically 60-120 seconds

**RDS vs Aurora HA:**
| Feature | RDS Multi-AZ | Aurora |
|---------|-------------|--------|
| **Replicas** | 1 standby (not readable) | Up to 15 read replicas |
| **Storage** | EBS-based, sync replication | Shared cluster storage, 6 copies across 3 AZs |
| **Failover time** | 60-120 seconds | Typically <30 seconds |
| **Cross-Region** | Read replicas | Aurora Global Database (<1s replication lag) |

### Aurora Global Database

- **Primary Region:** Handles all writes
- **Up to 5 secondary Regions:** Read-only, with up to 16 read replicas each
- **Replication lag:** Typically <1 second
- **Failover:** Promote a secondary Region to become the new primary (RTO typically <1 minute)
- **Use case:** Global applications requiring low-latency reads and fast cross-Region DR

### Amazon S3

| HA/Durability Feature | Description |
|----------------------|-------------|
| **Durability** | 99.999999999% (11 9s) — data is replicated across 3+ AZs |
| **Availability** | 99.99% for S3 Standard |
| **Versioning** | Protect against accidental deletes and overwrites |
| **Cross-Region Replication (CRR)** | Asynchronous object replication to another Region |
| **Same-Region Replication (SRR)** | Replication within the same Region (different account or compliance) |
| **Object Lock** | WORM protection for compliance |
| **MFA Delete** | Require MFA to delete objects or disable versioning |

**S3 CRR requirements:**
- Source and destination buckets must have versioning enabled
- Buckets must be in different Regions (for CRR)
- IAM role for S3 to assume during replication
- Replication is asynchronous

### Amazon DynamoDB

| HA Feature | Description |
|-----------|-------------|
| **Multi-AZ by default** | Data automatically replicated across 3 AZs |
| **Global Tables** | Multi-Region, multi-active replication |
| **On-Demand Backup** | Full backup without performance impact |
| **Point-in-Time Recovery (PITR)** | Continuous backups; restore to any second in last 35 days |
| **DynamoDB Streams** | Capture data changes for event-driven processing |

**Global Tables:**
- Active-active: reads and writes in any Region
- Replication typically <1 second
- Conflict resolution: last writer wins
- Requires DynamoDB Streams enabled
- Supports up to any number of replica Regions

### AWS Lambda

| HA Feature | Description |
|-----------|-------------|
| **Multi-AZ by default** | Lambda runs across multiple AZs automatically |
| **Built-in fault tolerance** | Retries on failure (async: 2 retries, sync: caller handles) |
| **Dead Letter Queue** | Failed events sent to SQS or SNS for later processing |
| **Reserved concurrency** | Guarantee capacity for critical functions |
| **Provisioned concurrency** | Pre-warmed execution environments, eliminates cold starts |

### Amazon ElastiCache

| HA Feature | Description |
|-----------|-------------|
| **Redis Multi-AZ** | Automatic failover to read replica in another AZ |
| **Redis Cluster Mode** | Data sharded across multiple nodes for read/write scaling |
| **Redis Global Datastore** | Cross-Region replication for DR and low-latency global reads |
| **Automatic backups** | Daily snapshots, manual snapshots for Redis |
| **Memcached** | No replication; use multiple nodes for data distribution |

**Redis vs Memcached HA:**
| Feature | Redis | Memcached |
|---------|-------|-----------|
| Multi-AZ | Yes (automatic failover) | No |
| Replication | Yes (read replicas) | No |
| Backup/Restore | Yes | No |
| Persistence | Yes | No |
| Global Datastore | Yes | No |

---

## Multi-Region Architectures

### Active-Active vs Active-Passive

| Feature | Active-Active | Active-Passive |
|---------|--------------|----------------|
| **Traffic handling** | Both Regions serve traffic | Only primary serves traffic |
| **Failover** | Automatic (Route 53 removes unhealthy) | Manual or automated DNS switch |
| **Data replication** | Bidirectional (DynamoDB Global Tables) | Unidirectional (read replicas) |
| **Cost** | Highest (full production in both) | Moderate (standby costs less) |
| **Complexity** | Highest (data conflicts, consistency) | Moderate |
| **RTO** | Near zero | Minutes to tens of minutes |
| **Use case** | Global apps, zero-downtime requirement | Regional apps, acceptable brief downtime |

### Active-Active Architecture Components

```
                  Route 53 (Latency-Based Routing)
                 /                                \
        Region A (US-East-1)               Region B (EU-West-1)
        ┌──────────────┐                   ┌──────────────┐
        │ CloudFront   │                   │ CloudFront   │
        │ ALB          │                   │ ALB          │
        │ Auto Scaling │                   │ Auto Scaling │
        │ DynamoDB     │ ←── Global ──→    │ DynamoDB     │
        │ Global Table │     Tables        │ Global Table │
        │ S3 Bucket    │ ←── CRR ──→      │ S3 Bucket    │
        └──────────────┘                   └──────────────┘
```

---

## Route 53 Failover Routing with Health Checks

### How It Works

1. Create **health checks** for your primary endpoint (can check HTTP, HTTPS, TCP, or even CloudWatch alarm status)
2. Create a **failover routing policy** with:
   - **Primary record:** Points to primary Region resources
   - **Secondary record:** Points to DR Region resources (or an S3 static website for a sorry page)
3. Route 53 monitors health checks every 10 or 30 seconds
4. If the primary fails health checks, Route 53 automatically routes traffic to the secondary

### Health Check Types

| Type | Description |
|------|-------------|
| **Endpoint health check** | Monitors a specific endpoint (IP or domain, port, path) |
| **Calculated health check** | Combines results of multiple health checks (AND/OR logic) |
| **CloudWatch alarm health check** | Monitors a CloudWatch alarm state |

### Health Check Configuration

- **Request interval:** 10 seconds (fast, higher cost) or 30 seconds (standard)
- **Failure threshold:** Number of consecutive failures before marking unhealthy (default 3)
- **String matching:** Optionally check if the response body contains a specific string (first 5,120 bytes)
- **Regions:** Health checks are performed from multiple AWS Regions worldwide

### Key Exam Points

- Health checks can monitor **endpoints**, **other health checks**, or **CloudWatch alarms**
- Route 53 health checks themselves are **global** (not tied to a specific Region)
- Failover routing requires an **alias record** pointing to the secondary resource
- You can combine failover with other routing policies (e.g., latency-based routing in each Region with failover between Regions)

---

## Global Accelerator for Multi-Region Failover

### How It Works

- Provides **2 static anycast IP addresses** that serve as a fixed entry point
- Routes traffic over the AWS global network to the optimal Region
- Performs **health checks** on endpoints in each Region
- Automatically **fails over** to healthy endpoints in seconds

### Global Accelerator vs Route 53 vs CloudFront

| Feature | Route 53 | Global Accelerator | CloudFront |
|---------|----------|-------------------|------------|
| **Type** | DNS | Network layer (anycast IP) | CDN (content caching) |
| **Failover speed** | DNS TTL dependent (60s typical) | Seconds (instant rerouting) | Origin failover (seconds) |
| **Static IP** | No | Yes (2 anycast IPs) | No |
| **Caching** | No | No | Yes |
| **Protocol** | DNS | TCP/UDP | HTTP/HTTPS |
| **Use case** | DNS-level routing | Non-HTTP, gaming, IoT, static IP | Web content delivery |

### Key Exam Points

- Global Accelerator provides **static IP addresses** (important for allowlisting)
- Failover is **faster than DNS** (no TTL caching issues)
- Works for **non-HTTP protocols** (TCP, UDP) — unlike CloudFront
- Routes over the **AWS backbone** (not the public internet)

---

## CloudFront Origin Failover

### How It Works

- Create an **Origin Group** with a primary and secondary origin
- CloudFront automatically switches to the secondary origin if the primary returns specific HTTP error codes (e.g., 500, 502, 503, 504)
- No DNS change required — failover happens at the CloudFront distribution level

### Configuration

- Define which HTTP status codes trigger failover (customizable)
- Both origins can be any supported CloudFront origin (S3, ALB, custom origin)
- Failover is per-request (each failed request retries on secondary)

### Use Case

- Primary origin in us-east-1, secondary in eu-west-1
- If us-east-1 origin returns 5xx errors, CloudFront serves from eu-west-1
- Users experience no DNS change delay

---

## Cross-Region Data Replication Services

### S3 Cross-Region Replication (CRR)

- **Asynchronous** replication to a bucket in another Region
- Requires **versioning** on both source and destination buckets
- Can replicate to a bucket in a different AWS account
- Supports **replication time control (RTC)** — 99.99% of objects replicated within 15 minutes
- Can replicate only a subset of objects using **prefix or tag filters**
- **Existing objects are NOT replicated automatically** — use S3 Batch Replication for existing objects
- Delete markers are optionally replicated (configurable)

### DynamoDB Global Tables

- **Active-active** multi-Region replication
- All Regions can accept writes
- **Conflict resolution:** Last writer wins (based on timestamp)
- Sub-second replication latency typically
- Requires DynamoDB Streams enabled
- Charges for replicated write capacity units (rWCU) in each Region
- Eventual consistency for cross-Region reads

### Aurora Global Database

- **1 primary Region** (read-write) + **up to 5 secondary Regions** (read-only)
- Replication lag typically **<1 second**
- Secondary Regions have up to **16 read replicas** each
- **Managed planned failover:** Gracefully switch the primary to a secondary Region (for planned maintenance, Region relocation)
- **Unplanned failover:** Promote a secondary Region manually (detach and promote) — RTO typically <1 minute
- **Write forwarding:** Secondary Region can forward write requests to primary (simplifies application logic)

### ElastiCache Global Datastore

- Cross-Region replication for Redis
- **Primary cluster** in one Region, **secondary clusters** in up to 2 other Regions
- Asynchronous replication
- Promotes secondary to primary for DR
- Sub-second replication lag typically
- Useful for global session stores, caching layers

### RDS Cross-Region Read Replicas

- Available for MySQL, MariaDB, PostgreSQL, Oracle (limited)
- **Asynchronous** replication
- Read replicas in another Region can be **promoted to standalone** for DR
- Promotion breaks replication (one-time operation)
- Each cross-region replica incurs data transfer charges

---

## EBS Snapshot Cross-Region Copy

### Manual Copy
- Copy a snapshot to another Region using the console, CLI, or API
- Snapshots are encrypted at rest (can use different KMS key in destination Region)

### Automated Copy with Amazon Data Lifecycle Manager (DLM)
- Create lifecycle policies to automatically:
  - Create EBS snapshots on a schedule
  - Copy snapshots to another Region
  - Delete old snapshots based on retention rules
- Supports both EBS volumes and EBS-backed AMIs

### Automated Copy with AWS Backup
- Centralized backup management
- Cross-Region copy rules in backup plans
- Cross-account copy for added protection
- Supports: EBS, RDS, DynamoDB, EFS, FSx, Aurora, S3, EC2 (AMIs), and more

---

## AWS Backup

### Overview

AWS Backup is a centralized, fully managed backup service that automates and consolidates backup activities across AWS services.

### Key Features

- **Backup plans:** Define backup frequency, retention, and lifecycle (transition to cold storage)
- **Cross-Region copy:** Automatically copy backups to another Region
- **Cross-account copy:** Copy backups to another AWS account (using AWS Organizations)
- **Backup vault:** Storage container for backups; can apply vault lock policy (WORM)
- **Backup vault lock:** Immutable backup policy for compliance (cannot be deleted, even by root)
- **Point-in-time recovery:** For supported services (DynamoDB, S3)

### Supported Services

EC2 (AMIs), EBS, RDS, Aurora, DynamoDB, DocumentDB, Neptune, EFS, FSx, S3, Storage Gateway volumes, VMware VMs, SAP HANA, Timestream, Redshift

### Exam Tips

- AWS Backup is the answer for **"centralized backup management across multiple AWS services"**
- Cross-Region + cross-account backup is the answer for **"protect against accidental deletion by compromised admin"**
- Vault Lock is the answer for **"compliance requirement for immutable backups"**

---

## Chaos Engineering: AWS Fault Injection Simulator (FIS)

### What is It?

AWS FIS is a managed service for running fault injection experiments on your AWS workloads. It follows the principles of chaos engineering — intentionally inject failures to discover weaknesses.

### Supported Actions

- **EC2:** Stop instances, terminate instances, stress CPU/memory/IO
- **ECS:** Drain containers, stop tasks
- **EKS:** Terminate pods, stress nodes
- **RDS:** Reboot instances, failover Multi-AZ
- **Network:** Disrupt connectivity, add latency, drop packets
- **Systems Manager:** Run SSM documents on targets

### How It Works

1. Create an **experiment template** defining:
   - **Actions:** What failures to inject (e.g., stop 30% of EC2 instances)
   - **Targets:** Which resources to affect (by tag, resource ID, or percentage)
   - **Stop conditions:** CloudWatch alarm that stops the experiment if impact exceeds tolerance
   - **IAM role:** Permissions for FIS to perform actions
2. Run the experiment
3. Monitor the impact using CloudWatch, X-Ray, etc.
4. Analyze results and improve resilience

### Key Exam Points

- FIS is used for **chaos engineering** and **resilience testing**
- It helps validate that Auto Scaling, Multi-AZ, and failover mechanisms actually work
- Stop conditions prevent experiments from causing unacceptable damage
- Supports experiments across multiple services simultaneously

---

## AWS Elastic Disaster Recovery (DRS)

### What is It?

AWS Elastic Disaster Recovery (formerly CloudEndure Disaster Recovery) provides continuous block-level replication of your servers to AWS, enabling fast, reliable recovery with minimal RPO and RTO.

### How It Works

1. Install the **AWS Replication Agent** on source servers (on-premises, other cloud, or EC2)
2. Agent performs **continuous block-level replication** to a staging area in AWS (low-cost EC2 instances + EBS)
3. Replication keeps the staging area up-to-date with changes
4. **During a drill or actual failover:**
   - Launch recovery instances from the replicated data
   - Recovery instances are full production-ready EC2 instances
   - Cutover takes minutes

### Key Characteristics

| Attribute | Value |
|-----------|-------|
| **RPO** | Seconds (continuous replication) |
| **RTO** | Minutes (launch recovery instances) |
| **Replication** | Continuous, block-level |
| **Source** | On-premises, other cloud, or AWS EC2 |
| **Target** | Any AWS Region |
| **Testing** | Non-disruptive DR drills without impacting source |

### When to Use

- DR for on-premises servers to AWS
- DR for EC2 instances to another Region
- Need RPO in seconds and RTO in minutes
- Want to replace traditional DR solutions (Zerto, VMware SRM)

### Exam Tips

- DRS is the answer for **"continuous replication of on-premises servers to AWS with minimal RPO/RTO"**
- DRS is **not** the same as backup and restore — it provides continuous replication
- DRS supports **non-disruptive drills** — test DR without affecting production

---

## Runbooks and Playbooks

### Runbooks

- **Documented procedures** for well-understood, routine operations
- Step-by-step instructions that anyone on the team can follow
- Examples: scaling procedures, deployment steps, incident resolution for known issues
- Can be automated using **Systems Manager Automation** runbooks

### Playbooks

- **Investigation guides** for unexpected situations
- Less prescriptive than runbooks — guide the operator through diagnostic steps
- Help operators identify root cause and determine the appropriate response
- Examples: investigating high latency, diagnosing database connectivity issues

### AWS Systems Manager Automation

- Create automated runbooks using SSM Automation documents
- Pre-built runbooks for common tasks (restart EC2, create snapshot, patch instances)
- Custom runbooks using YAML or JSON
- Can be triggered by CloudWatch Alarms or EventBridge rules

---

## DR Testing Strategies

### Why Test?

- DR that hasn't been tested is not DR
- Backups that haven't been restored are not verified backups
- Failover mechanisms can drift over time

### Testing Approaches

| Approach | Description | Risk |
|----------|-------------|------|
| **Tabletop exercise** | Walk through the DR plan on paper | None |
| **Parallel testing** | Run DR in parallel with production, verify data consistency | Low |
| **DR drill (failover test)** | Actually fail over to DR environment, run operations | Medium |
| **Full simulation** | Simulate a Region failure, all traffic served from DR | High |
| **Chaos engineering (FIS)** | Inject real failures and observe system response | Medium |

### Best Practices

- Test DR regularly (quarterly at minimum)
- Automate DR testing where possible
- Measure actual RTO and RPO during tests
- Document lessons learned and update plans
- Test backup restoration, not just backup creation
- Include all stakeholders (ops, dev, business)

---

## Common Exam Scenarios

### Scenario 1: Cheapest DR Strategy

**Question:** "A company has a non-critical internal application. They need a DR plan with minimal cost. The application can tolerate up to 24 hours of downtime and data loss."

**Answer:** Backup and Restore — Store snapshots and AMIs in S3 in the DR Region. Restore from backups when needed. RPO/RTO in hours but lowest cost.

### Scenario 2: Minutes of RTO, Low Cost

**Question:** "A company needs DR for a web application with RTO of 30 minutes. They want to minimize ongoing costs."

**Answer:** Pilot Light — Keep database replication running in the DR Region. Pre-configure Auto Scaling, ALB, and CloudFormation templates. Scale up on failover.

### Scenario 3: Near-Zero Downtime

**Question:** "A financial services company requires near-zero downtime for their trading platform. Budget is not a constraint."

**Answer:** Multi-Site Active-Active — Full production in 2 Regions, DynamoDB Global Tables, Route 53 latency-based routing, Global Accelerator for instant failover.

### Scenario 4: Database HA

**Question:** "An application needs a relational database that automatically fails over with minimal downtime."

**Answer:** Amazon Aurora with Multi-AZ (failover typically <30 seconds) or RDS Multi-AZ (failover 60-120 seconds). For cross-Region, use Aurora Global Database.

### Scenario 5: Static Website DR

**Question:** "During a Region failure, the company wants to display a maintenance page to users."

**Answer:** Route 53 failover routing with the secondary pointing to an S3 static website hosting in another Region displaying the maintenance page.

### Scenario 6: Cross-Region Database DR

**Question:** "A company needs to protect their MySQL database against a Region failure with RPO under 1 minute."

**Answer:** Aurora Global Database (MySQL-compatible) — Sub-second replication lag, fast failover to secondary Region.

### Scenario 7: Global Session Store

**Question:** "A global application needs a shared session store accessible with low latency from any Region."

**Answer:** ElastiCache Global Datastore (Redis) — Cross-Region replication for low-latency reads. Or DynamoDB Global Tables for a fully managed active-active solution.

### Scenario 8: Immutable Backups

**Question:** "A healthcare company must ensure backups cannot be deleted, even by an administrator, for regulatory compliance."

**Answer:** AWS Backup with Vault Lock — Enforces a WORM (Write Once Read Many) policy that cannot be overridden, even by root.

### Scenario 9: On-Premises DR to AWS

**Question:** "A company wants continuous replication of their on-premises VMware environment to AWS for disaster recovery, with RTO under 15 minutes."

**Answer:** AWS Elastic Disaster Recovery (DRS) — Continuous block-level replication, RTO in minutes, supports on-premises VMware servers.

### Scenario 10: Protecting Against Accidental Deletion

**Question:** "How should a company protect their DynamoDB tables against accidental deletion?"

**Answer:** Enable Point-in-Time Recovery (PITR) for continuous backups + Enable deletion protection on the table + Create on-demand backups before major changes + Use DynamoDB Global Tables for cross-Region redundancy.

### Scenario 11: RTO vs Cost Trade-Off

**Question:** "A company has $500/month budget for DR. Their application has 10 EC2 instances and an RDS database. What DR strategy is feasible?"

**Answer:** With a limited budget:
- Backup and Restore: Store AMIs and RDS snapshots in DR Region (cheapest, ~hours RTO)
- Pilot Light: Keep one RDS read replica in DR Region (moderate cost, ~minutes RTO)
- Cannot afford Warm Standby or Active-Active at this budget level

---

## Summary Decision Matrix

| If the question says... | Choose... |
|------------------------|-----------|
| "Cheapest DR" / "lowest cost" | Backup and Restore |
| "Minimal resources always running" | Pilot Light |
| "Scaled-down copy always running" | Warm Standby |
| "Zero downtime" / "active-active" | Multi-Site Active-Active |
| "Automatic database failover within Region" | RDS Multi-AZ or Aurora Multi-AZ |
| "Cross-Region database DR" | Aurora Global Database |
| "Global low-latency database" | DynamoDB Global Tables |
| "Continuous replication from on-premises" | AWS Elastic Disaster Recovery |
| "Centralized backup management" | AWS Backup |
| "Immutable backups for compliance" | AWS Backup Vault Lock |
| "Chaos engineering / resilience testing" | AWS Fault Injection Simulator |
| "Static IP with instant failover" | Global Accelerator |
| "DNS-level failover" | Route 53 Failover Routing |
| "CDN origin failover" | CloudFront Origin Group |

---

*Next Article: [Serverless Architecture Patterns](31-serverless-patterns.md)*
