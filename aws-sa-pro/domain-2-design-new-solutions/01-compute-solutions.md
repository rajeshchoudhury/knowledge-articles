# Domain 2 – Design for New Solutions: Compute Solutions

## AWS Certified Solutions Architect – Professional (SAP-C02)

---

## Table of Contents

1. [EC2 Instance Types and Selection](#1-ec2-instance-types-and-selection)
2. [EC2 Purchase Options](#2-ec2-purchase-options)
3. [EC2 Placement Groups](#3-ec2-placement-groups)
4. [EC2 Networking](#4-ec2-networking)
5. [AMI Management](#5-ami-management)
6. [Auto Scaling Deep Dive](#6-auto-scaling-deep-dive)
7. [Elastic Load Balancing Deep Dive](#7-elastic-load-balancing-deep-dive)
8. [EC2 Auto Scaling vs Application Auto Scaling](#8-ec2-auto-scaling-vs-application-auto-scaling)
9. [Spot Instance Strategies](#9-spot-instance-strategies)
10. [Compute Optimizer](#10-compute-optimizer)
11. [Elastic Beanstalk](#11-elastic-beanstalk)
12. [Outposts, Local Zones, and Wavelength Zones](#12-outposts-local-zones-and-wavelength-zones)
13. [Exam Scenarios and Decision Frameworks](#13-exam-scenarios-and-decision-frameworks)

---

## 1. EC2 Instance Types and Selection

### Instance Family Overview

| Family | Prefix | Optimized For | Use Cases |
|--------|--------|--------------|-----------|
| General Purpose | M, T, A | Balanced compute, memory, networking | Web servers, code repos, dev environments |
| Compute Optimized | C | High-performance processors | Batch processing, ML inference, gaming, HPC |
| Memory Optimized | R, X, z, u (High Memory) | Fast performance for large datasets in memory | In-memory databases, real-time big data analytics |
| Storage Optimized | I, D, H | High sequential read/write to large datasets on local storage | Data warehousing, distributed file systems, HDFS |
| Accelerated Computing | P, G, Inf, Trn, DL, F, VT | Hardware accelerators (GPU, FPGA, Inferentia) | ML training, graphics rendering, video transcoding |

### Instance Naming Convention

```
m5a.xlarge
│││  │
││├──── Additional capability (a = AMD, n = networking, d = local NVMe, g = Graviton)
│├───── Generation (5th gen)
├────── Family (m = general purpose)
     └── Size (xlarge = 4 vCPUs)
```

### General Purpose (M, T, A)

**M-series (M5, M5a, M5n, M5zn, M6i, M6g, M6a, M7g, M7i, M7a):**
- Balanced ratio of compute, memory, networking
- M5: Intel Xeon Platinum | M5a: AMD EPYC | M6g/M7g: AWS Graviton (ARM)
- M5zn: Highest frequency in M family (4.5 GHz sustained all-core turbo), ideal for gaming and HPC front-ends
- M6g/M7g: Up to 40% better price-performance over x86 equivalents

**T-series (T3, T3a, T4g):**
- Burstable performance with CPU credits
- **Unlimited mode** (default for T3): Can burst beyond baseline indefinitely; charges apply for surplus credits
- **Standard mode**: Burst limited to accrued CPU credits
- Baseline performance: T3.micro = 10%, T3.small = 20%, T3.medium = 20%, T3.large = 30%

> **Exam Tip:** T instances are NOT suitable for sustained high-CPU workloads. If a scenario describes consistent high CPU utilization, choose M or C family instead. T instances in unlimited mode will incur surprise costs.

### Compute Optimized (C)

**C5, C5a, C5n, C6i, C6g, C6gn, C7g, C7gn, C7a:**
- Highest performing processors
- C5n/C6gn/C7gn: Enhanced networking up to 200 Gbps
- C7g: AWS Graviton3 — best price-performance for compute workloads

**Key use cases:**
- Batch processing and data analytics
- Scientific modeling and machine learning inference
- High-performance web servers
- Video encoding and game servers
- Distributed analytics

### Memory Optimized (R, X, z, u)

**R-series (R5, R5a, R5b, R5n, R6g, R6i, R7g, R7i, R7a):**
- R5b: EBS-optimized up to 60 Gbps bandwidth, 260K IOPS
- Good for: Redis/Memcached, real-time analytics

**X-series (X1, X1e, X2idn, X2iedn, X2gd):**
- Up to 4 TB RAM
- SAP HANA certified
- Lowest price per GiB of RAM

**High Memory (u-) instances:**
- 3 TB, 6 TB, 9 TB, 12 TB, 18 TB, 24 TB RAM
- Designed exclusively for SAP HANA in production
- Bare metal only

**z1d:**
- Highest frequency (4.0 GHz sustained all-core turbo) with high memory
- Electronic Design Automation (EDA), per-core licensing workloads

> **Exam Tip:** When a scenario mentions SAP HANA, think X1/X2/u-series. When it mentions in-memory caching or databases like Redis, think R-series.

### Storage Optimized (I, D, H)

**I-series (I3, I3en, I4i, I4g, Im4gn, Is4gen):**
- High random I/O, NVMe SSD storage
- I3en: Up to 60 TB, 8 GiB/s sequential throughput
- I4i: AWS Nitro SSD, up to 30 TB NVMe

**D-series (D2, D3, D3en):**
- Dense HDD storage (up to 336 TB on D3en)
- MapReduce, HDFS, distributed file systems

**H-series (H1):**
- High throughput HDD storage
- MapReduce, distributed file systems

### Accelerated Computing

| Instance | Accelerator | Use Case |
|----------|------------|----------|
| P4d, P5 | NVIDIA A100/H100 GPU | ML training, HPC |
| G5, G6 | NVIDIA A10G/L4 GPU | Graphics, ML inference, video |
| Inf1, Inf2 | AWS Inferentia | ML inference (lowest cost) |
| Trn1, Trn1n | AWS Trainium | ML training (lowest cost on AWS) |
| DL1 | Gaudi HPU | Deep learning training |
| F1 | Xilinx FPGA | Genomics, financial analytics, video processing |
| VT1 | Xilinx Alveo U30 | Live video transcoding |

> **Exam Tip:** For ML **training** at lowest cost, think Trn1. For ML **inference** at lowest cost, think Inf2. For general GPU workloads, think P-series (training) or G-series (graphics/inference).

### Graviton Processors

- ARM-based custom silicon by AWS
- Up to 40% better price-performance over comparable x86 instances
- Available across families: M7g, C7g, R7g, T4g, I4g, X2gd
- Requires ARM-compatible software (most Linux distributions, containers, and interpreted languages work natively)

### Instance Selection Decision Framework

```
┌─ Is the workload burstable with variable CPU?
│  YES → T3/T4g
│  NO ↓
├─ Is it balanced compute + memory?
│  YES → M6i/M7g
│  NO ↓
├─ CPU-intensive?
│  YES → C6i/C7g
│  NO ↓
├─ Memory-intensive?
│  YES → R6i/R7g (up to 1 TB) or X2 (up to 4 TB) or u- (up to 24 TB)
│  NO ↓
├─ Storage-intensive with high I/O?
│  YES → I4i (SSD) or D3en (HDD)
│  NO ↓
├─ GPU / ML / HPC?
│  YES → P5 (training), G6 (graphics), Inf2 (inference), Trn1 (training)
│  NO ↓
└─ Consider Graviton (g suffix) for all families for better price-performance
```

---

## 2. EC2 Purchase Options

### On-Demand Instances

- Pay per second (Linux) or per hour (Windows)
- No long-term commitment
- Highest cost, maximum flexibility
- Best for: Short-term, unpredictable workloads; testing and development

### Reserved Instances (RIs)

**Standard Reserved Instances:**
- 1-year or 3-year term
- Up to 72% discount vs On-Demand
- Can be sold on the Reserved Instance Marketplace
- Scope: Regional (flexible across AZs) or Zonal (specific AZ, capacity reservation)

**Convertible Reserved Instances:**
- Up to 66% discount
- Can change instance family, OS, tenancy, and payment option
- Cannot be sold on the marketplace
- Can only be exchanged for equal or greater value

**Payment options:**
| Option | Discount Level | Cash Flow |
|--------|---------------|-----------|
| All Upfront | Highest | Pay everything upfront |
| Partial Upfront | Medium | Pay portion upfront + monthly |
| No Upfront | Lowest | Monthly payments only |

**RI Attributes (what you commit to):**
- Instance type (Standard) or instance family (Convertible)
- Region or AZ
- Tenancy (shared or dedicated)
- Platform (Linux/Windows)

> **Exam Tip:** Regional RIs provide AZ flexibility AND capacity reservation is NOT guaranteed. Zonal RIs provide guaranteed capacity reservation in a specific AZ. If a scenario requires guaranteed capacity, use Zonal RIs or On-Demand Capacity Reservations.

### Savings Plans

**Compute Savings Plans:**
- Up to 66% discount
- Commit to a $/hr of compute usage for 1 or 3 years
- Applies across EC2, Fargate, and Lambda regardless of family, size, AZ, region, OS, or tenancy
- Most flexible savings plan

**EC2 Instance Savings Plans:**
- Up to 72% discount
- Commit to a specific instance family in a specific region
- Flexible across size, OS, and tenancy within that family

**SageMaker Savings Plans:**
- For SageMaker ML instances

```
Flexibility comparison:
Compute Savings Plan > Convertible RI > EC2 Instance Savings Plan > Standard RI

Discount comparison:
Standard RI (All Upfront, 3yr) > EC2 Instance Savings Plan > Convertible RI ≈ Compute Savings Plan
```

### Spot Instances

- Up to 90% discount vs On-Demand
- Can be interrupted with 2-minute notice
- Price fluctuates based on supply/demand
- Best for: Fault-tolerant workloads, batch processing, CI/CD, big data, stateless web servers

**Spot Instance interruption handling:**
- **Stop**: Instance is stopped (EBS-backed only), can be restarted when capacity returns
- **Hibernate**: RAM contents saved to EBS, instance hibernates
- **Terminate**: Instance is terminated (default)

**Spot Fleet:** Collection of Spot Instances and optionally On-Demand instances
- Allocation strategies: `lowestPrice`, `diversified`, `capacityOptimized`, `priceCapacityOptimized` (recommended)

### Dedicated Hosts

- Physical server fully dedicated to you
- Visibility into sockets, cores, host ID
- Per-host billing
- Required for: Server-bound software licenses (Oracle, SQL Server per-core licensing), compliance requirements
- Can be shared with other AWS accounts in your organization via AWS RAM
- Supports host affinity (instances always launch on the same host)

### Dedicated Instances

- Run on hardware dedicated to you but you don't control placement
- Per-instance billing with a per-region dedicated fee
- May share hardware with other instances from the same account
- Less expensive than Dedicated Hosts

**Dedicated Hosts vs Dedicated Instances:**

| Feature | Dedicated Host | Dedicated Instance |
|---------|---------------|-------------------|
| Billing | Per host | Per instance + regional fee |
| Socket/core visibility | Yes | No |
| Host affinity | Yes | No |
| License portability (BYOL) | Yes | No |
| Placement control | Full | Limited |

### On-Demand Capacity Reservations (ODCR)

- Reserve capacity in a specific AZ for any duration
- No term commitment (create/cancel anytime)
- Combined with Savings Plans or Regional RIs for discounts
- Pay On-Demand rate whether you use it or not
- Best for: Guaranteed capacity for disaster recovery, critical events

> **Exam Tip:** For guaranteed capacity + cost savings, combine Zonal Reserved Instances (guaranteed capacity in a specific AZ) or On-Demand Capacity Reservations + Savings Plans. On-Demand Capacity Reservations alone do NOT provide a discount.

### Purchase Option Decision Framework

```
┌─ Short-term / unpredictable → On-Demand
├─ Steady-state / known baseline
│  ├─ Fixed instance family + region → EC2 Instance Savings Plan or Standard RI
│  ├─ Need flexibility across services → Compute Savings Plan
│  └─ Need to change instance family → Convertible RI
├─ Fault-tolerant / flexible start time → Spot Instances
├─ Compliance / BYOL licensing → Dedicated Host
├─ Hardware isolation only → Dedicated Instance
└─ Guaranteed capacity in specific AZ → ODCR or Zonal RI
```

---

## 3. EC2 Placement Groups

### Cluster Placement Groups

- Instances packed close together in a single AZ (same rack or nearby racks)
- Low-latency, high-throughput (10 Gbps bidirectional) network between instances
- **Use case:** HPC, tightly coupled node-to-node communication, big data jobs requiring fast inter-node communication

**Constraints:**
- Single AZ only
- Recommended: Same instance type for all instances
- Can span VPC peered connections (with performance penalty)
- Limited to certain instance types (enhanced networking required)

### Spread Placement Groups

- Each instance placed on distinct underlying hardware (different racks)
- Maximum 7 instances per AZ per group
- Can span multiple AZs in a region
- **Use case:** Critical applications requiring maximum availability, individual instance isolation

**Constraints:**
- 7 instances per AZ hard limit
- Not supported for Dedicated Hosts
- Cannot be merged with other placement groups

### Partition Placement Groups

- Instances grouped into logical partitions, each on separate racks
- Up to 7 partitions per AZ
- Can have hundreds of instances
- Partitions don't share underlying hardware with other partitions
- **Use case:** Hadoop, Cassandra, Kafka — large distributed workloads where you need rack-awareness

**Key differences from Spread:**
- Spread: Each INSTANCE on separate hardware (max 7/AZ)
- Partition: Each PARTITION on separate hardware (many instances per partition)

```
Cluster:     [inst][inst][inst]  ← All same rack, lowest latency
              ─────────────
                 One Rack

Spread:      Rack1    Rack2    Rack3
             [inst]   [inst]   [inst]  ← Each instance on separate rack

Partition:   Rack1         Rack2         Rack3
             [inst][inst]  [inst][inst]  [inst][inst]  ← Partition-level separation
             Partition A   Partition B   Partition C
```

> **Exam Tip:** "Low latency between instances" → Cluster. "Must survive rack failure for individual instances" → Spread. "Big data with rack-awareness" → Partition. Remember: Spread max = 7 per AZ.

---

## 4. EC2 Networking

### Elastic Network Interface (ENI)

- Virtual network card attached to an instance
- Attributes: Primary private IPv4, one or more secondary IPv4, one Elastic IP per private IPv4, one public IPv4, one or more IPv6, one or more security groups, MAC address, source/dest check flag
- Can be created independently and attached/detached (hot attach)
- **Use cases:** Management network, dual-homing, low-budget HA (move ENI between instances)

### Enhanced Networking

Two mechanisms for higher bandwidth and lower latency:

**Elastic Network Adapter (ENA):**
- Up to 200 Gbps
- Supported on most current-generation instances
- Uses SR-IOV (Single Root I/O Virtualization)
- No additional cost

**Intel 82599 VF (ixgbevf):**
- Up to 10 Gbps
- Legacy, used on older instance types
- Also uses SR-IOV

### Elastic Fabric Adapter (EFA)

- Enhanced ENA with OS-bypass capability
- For HPC and ML training requiring inter-node communication
- Uses libfabric API, bypasses the OS kernel for lower latency
- Supports MPI (Message Passing Interface) and NCCL (NVIDIA Collective Communication Library)
- Only available on Linux
- **Use case:** Tightly coupled HPC workloads requiring MPI, distributed ML training

```
Network Performance Hierarchy:
Standard ENI < ENA (Enhanced Networking) < EFA (Elastic Fabric Adapter)
  ~Basic~        ~Up to 200 Gbps~         ~HPC/ML, OS-bypass~
```

### Network Bandwidth

- Instances have baseline and burst bandwidth for both network and EBS
- Single-flow limit: 5 Gbps (or 10 Gbps within a placement group)
- Aggregate bandwidth varies by instance type (up to 200 Gbps for p4d.24xlarge/c6gn.16xlarge)
- EBS bandwidth may be shared with network bandwidth on some instances

> **Exam Tip:** If a scenario mentions HPC inter-node communication or MPI, choose EFA. If it mentions general high-throughput, ENA suffices. EFA is Linux-only.

---

## 5. AMI Management

### AMI Basics

An Amazon Machine Image contains:
- Root volume template (OS, applications)
- Launch permissions (who can use the AMI)
- Block device mapping (volume attachments)

AMI types:
- **EBS-backed**: Root device is an EBS volume (stopped + started, data persists)
- **Instance Store-backed**: Root device is instance store (cannot be stopped, data lost on termination)

### AMI Creation and Lifecycle

```
Running Instance → Create Image → AMI (registered)
                                    ├── EBS Snapshots (for EBS-backed volumes)
                                    └── S3 Bundle (for instance-store-backed)

AMI Lifecycle: Create → Register → Use → Deregister → Delete Snapshots
```

**No-reboot option:** Create AMI without stopping the instance (file system integrity not guaranteed)

### AMI Sharing

| Sharing Method | Details |
|---------------|---------|
| Private (default) | Only the AMI owner account can use it |
| Shared with specific accounts | Add account IDs to launch permissions |
| Public | Anyone can launch instances from it |
| AWS Marketplace | Sell AMI commercially |
| Cross-region | Copy AMI to target region (creates new AMI + snapshots) |

**Cross-account sharing rules:**
- Sharing an AMI does NOT share the underlying snapshots
- The recipient must have permissions on the KMS key if the AMI is encrypted
- To share an encrypted AMI: Share the AMI AND grant `kms:DescribeKey`, `kms:ReEncrypt*`, `kms:CreateGrant`, `kms:Decrypt` on the KMS key

### AMI Encryption

- AMIs backed by encrypted EBS snapshots can only be shared if using a customer-managed CMK (not the default `aws/ebs` key)
- When copying an AMI, you can encrypt a previously unencrypted AMI:
  - Unencrypted source → Encrypted copy (with any KMS key)
  - Encrypted source → Re-encrypted copy (can change KMS key)
- You CANNOT create an unencrypted copy of an encrypted AMI

### Golden AMI Pipeline

A best-practice automated pipeline for creating hardened, pre-configured AMIs:

```
┌──────────────┐    ┌──────────────┐    ┌──────────────────┐    ┌─────────────┐
│ Source AMI   │───→│ EC2 Image    │───→│ Test & Validate  │───→│ Distribute  │
│ (base OS)    │    │ Builder      │    │ (Inspector,      │    │ (share to   │
│              │    │ (install,    │    │  custom tests)   │    │  accounts/  │
│              │    │  harden,     │    │                  │    │  regions)   │
│              │    │  configure)  │    │                  │    │             │
└──────────────┘    └──────────────┘    └──────────────────┘    └─────────────┘
```

**EC2 Image Builder:**
- Automates AMI creation, testing, and distribution
- Components: Pipeline, Recipe, Infrastructure Configuration, Distribution Configuration
- Integrates with AWS Inspector for vulnerability scanning
- Can output AMIs, container images, or both
- Scheduled or triggered by events

**Golden AMI best practices:**
- Start from AWS-provided or verified base AMI
- Install and configure all required software
- Apply security hardening (CIS benchmarks)
- Remove temporary files, SSH keys, history
- Run Inspector scan before distribution
- Version and tag AMIs systematically
- Automate distribution to all accounts/regions via Organizations

> **Exam Tip:** EC2 Image Builder is the recommended service for building Golden AMI pipelines. It handles build, test, and distribution. If a scenario asks about automating AMI creation with testing, think EC2 Image Builder.

---

## 6. Auto Scaling Deep Dive

### Auto Scaling Components

**Launch Template (recommended over Launch Configuration):**
- Versioned templates defining instance configuration
- Supports: multiple instance types, purchase options mix (On-Demand + Spot), latest AMI parameterization
- Launch Configurations are legacy — no versioning, no mixed instance types

**Auto Scaling Group (ASG):**
- Manages a fleet of EC2 instances
- Configuration: Min size, Max size, Desired capacity
- Health checks: EC2 (default) or ELB health checks
- Can span multiple AZs (recommended: at least 2)

### Scaling Policies

**Target Tracking Scaling:**
- Maintain a specific metric at a target value
- Example: Keep average CPU at 50%
- ASG automatically creates and manages CloudWatch alarms
- Predefined metrics: ASGAverageCPUUtilization, ASGAverageNetworkIn/Out, ALBRequestCountPerTarget
- Custom metrics supported
- Scale-in cooldown: 300 seconds default

```
Example: Target Tracking
Target: ALBRequestCountPerTarget = 1000
  If current = 1500 per target → scale out (add instances)
  If current = 500 per target → scale in (remove instances)
```

**Step Scaling:**
- Scale based on CloudWatch alarm thresholds with step adjustments
- Example: Add 1 instance when CPU > 60%, add 3 when CPU > 80%
- More granular control than target tracking
- Requires manual CloudWatch alarm configuration

```
Step Scaling Example:
  CPU 60-70% → Add 1 instance
  CPU 70-80% → Add 2 instances
  CPU > 80%  → Add 3 instances
```

**Simple Scaling:**
- Single scaling adjustment when alarm triggers
- Waits for cooldown period before next action
- Legacy — prefer Step or Target Tracking

**Scheduled Scaling:**
- Scale based on predictable time patterns
- Cron-like schedule
- Example: Scale up every Monday 8 AM, scale down Friday 6 PM
- Supports one-time or recurring schedules

**Predictive Scaling:**
- Uses ML to forecast load and pre-provision capacity
- Analyzes 14 days of historical data
- Generates a forecast and schedules scaling actions
- Can work in forecast-only mode (observe without acting)
- Best combined with dynamic scaling (predictive handles baseline, dynamic handles spikes)

### Warm Pools

- Pre-initialized instances kept in a stopped (or running/hibernated) state
- Reduces launch time by having instances ready before they're needed
- States: Stopped (cheapest, still pay for EBS), Running, Hibernated
- Pool size: Configurable minimum
- Lifecycle hooks supported for warm pool instances

```
                    ┌─────────────┐
                    │  Warm Pool  │
                    │  (Stopped/  │
                    │  Hibernated)│
                    └──────┬──────┘
                           │ Scale-out event
                           ▼
┌────────────────────────────────────────┐
│        Active Auto Scaling Group       │
│  [inst1] [inst2] [inst3] [inst4]       │
└────────────────────────────────────────┘
                           │ Scale-in event
                           ▼
                    ┌─────────────┐
                    │  Warm Pool  │
                    │  (instance  │
                    │  returned)  │
                    └─────────────┘
```

### Instance Refresh

- Rolling replacement of instances in an ASG
- Useful when: AMI updates, launch template changes, infrastructure changes
- Configuration:
  - **Minimum healthy percentage**: Minimum % of healthy instances during refresh (default 90%)
  - **Instance warmup**: Time to wait after launch before considering healthy
  - **Skip matching**: Skip instances that already match the desired configuration
  - **Checkpoint**: Pause after replacing a percentage of instances (canary-style)

### Mixed Instances Policy

- Combine On-Demand and Spot instances in a single ASG
- Configuration options:
  - On-Demand base capacity (e.g., first 2 instances are On-Demand)
  - On-Demand percentage above base (e.g., 30% On-Demand, 70% Spot above base)
  - Spot allocation strategy: `capacity-optimized`, `lowest-price`, `price-capacity-optimized`
  - Multiple instance types for Spot diversification

```json
{
  "LaunchTemplate": { "LaunchTemplateId": "lt-xxx", "Version": "$Latest" },
  "Overrides": [
    { "InstanceType": "c5.xlarge" },
    { "InstanceType": "c5a.xlarge" },
    { "InstanceType": "c5d.xlarge" },
    { "InstanceType": "c4.xlarge" },
    { "InstanceType": "m5.xlarge" }
  ],
  "InstancesDistribution": {
    "OnDemandBaseCapacity": 2,
    "OnDemandPercentageAboveBaseCapacity": 25,
    "SpotAllocationStrategy": "price-capacity-optimized"
  }
}
```

### Lifecycle Hooks

- Pause instances during launch or termination for custom actions
- States: `Pending:Wait` → custom action → `Pending:Proceed` (or `Terminating:Wait` → `Terminating:Proceed`)
- Timeout: Default 1 hour, max 48 hours (via heartbeat)
- Use with: SNS, SQS, EventBridge, Lambda for automation
- **Use cases:** Install software, pull data, register with DNS, drain connections, create snapshots

### Scaling Cooldowns

- Default cooldown: 300 seconds
- Prevents ASG from launching or terminating additional instances before previous scaling takes effect
- Target tracking has built-in cooldowns (scale-out 3 min, scale-in 15 min)
- Not applicable to scheduled scaling

### Termination Policy

Order of precedence (default policy):
1. AZ with most instances (balance AZs)
2. Instance with oldest launch configuration/template
3. Instance closest to next billing hour
4. Random

Other policies: `OldestInstance`, `NewestInstance`, `OldestLaunchConfiguration`, `OldestLaunchTemplate`, `ClosestToNextInstanceHour`, `Default`, `AllocationStrategy`

> **Exam Tip:** Predictive Scaling + Target Tracking is the recommended combination for workloads with patterns. Warm Pools reduce launch time for instances that need lengthy initialization. Instance Refresh is for rolling updates (not blue/green — use CodeDeploy for that).

---

## 7. Elastic Load Balancing Deep Dive

### Application Load Balancer (ALB)

**Layer 7 (HTTP/HTTPS) load balancer**

**Routing capabilities:**
- **Path-based:** `/api/*` → API target group, `/images/*` → static target group
- **Host-based:** `api.example.com` → API TG, `web.example.com` → Web TG
- **HTTP header-based:** Route based on any standard or custom header
- **HTTP method-based:** GET, POST, etc.
- **Query string-based:** `?platform=mobile` → Mobile TG
- **Source IP-based:** Route internal vs external users

**Listener rules:**
- Evaluated in priority order (1–50000)
- Each rule has conditions and actions
- Actions: Forward, Redirect, Fixed-response, Authenticate-oidc, Authenticate-cognito

**Target types:**
- Instance ID
- IP address (including on-premises via Direct Connect/VPN)
- Lambda function
- ALB (chained — for cross-account/cross-VPC via PrivateLink)

**Weighted target groups:**
- Route traffic percentage-based to different target groups
- Enables blue/green deployments and A/B testing

```
Example: Blue/Green with Weighted Groups
  Listener Rule: Forward to
    Blue TG  → Weight: 90 (90% of traffic)
    Green TG → Weight: 10 (10% of traffic)
```

**Sticky Sessions:**
- Duration-based: ALB generates a cookie (AWSALB, 1 second to 7 days)
- Application-based: Application generates a custom cookie (AWSALBAPP)
- Stickiness is per target group

**Authentication:**
- Native OIDC/Cognito integration at the ALB level
- Authenticate before reaching the application
- Supports Amazon Cognito User Pools
- Supports any OIDC-compliant IdP (Okta, Auth0, Azure AD)

**WAF Integration:**
- AWS WAF can be directly associated with ALB
- Web ACL evaluates requests before routing
- Protects against SQL injection, XSS, bot traffic

**Other ALB features:**
- WebSocket support (native)
- HTTP/2 support (native)
- gRPC support
- Connection draining (deregistration delay): Default 300 seconds
- Cross-zone load balancing: Enabled by default, free
- Slow start mode: Gradually increases traffic to new targets
- Request tracing: X-Amzn-Trace-Id header

### Network Load Balancer (NLB)

**Layer 4 (TCP/UDP/TLS) load balancer**

**Key capabilities:**
- **Static IP:** One static IP per AZ (automatically assigned or use Elastic IP)
- **Ultra-high performance:** Millions of requests per second, ultra-low latency (~100 microseconds)
- **Preserve source IP:** Client IP visible to targets
- **TLS termination:** Offload TLS at the NLB
- **UDP support:** Only load balancer supporting UDP
- **TCP long-lived connections:** Ideal for WebSocket, IoT, gaming

**PrivateLink (VPC Endpoint Services):**
- NLB is required for creating VPC Endpoint Services
- Expose services to other VPCs or accounts via PrivateLink
- No VPC peering or Transit Gateway required

```
Service Provider VPC                    Service Consumer VPC
┌─────────────────┐                    ┌──────────────────┐
│  App Servers     │                    │  Applications    │
│     ↑            │                    │     │            │
│  [  NLB  ]       │←─── PrivateLink ──→│  [VPC Endpoint]  │
│  (Endpoint       │    (AWS backbone)  │  (ENI in VPC)    │
│   Service)       │                    │                  │
└─────────────────┘                    └──────────────────┘
```

**Target types:**
- Instance ID
- IP address
- ALB (NLB → ALB chain: Use NLB for static IPs + PrivateLink, ALB for L7 routing)

**Health checks:**
- TCP, HTTP, HTTPS
- Less granular than ALB (no path-based health checks on some target types)

**Cross-zone load balancing:** Disabled by default (charges apply when enabled)

### Gateway Load Balancer (GWLB)

**Layer 3 (IP) load balancer for network appliances**

**Architecture:**
- Operates at Layer 3 (network layer)
- Uses GENEVE protocol (port 6081) to encapsulate traffic
- Transparent to source and destination — preserves all packet data

**Use case:** Inline traffic inspection with third-party virtual appliances
- Firewalls (Palo Alto, Fortinet, Check Point)
- IDS/IPS systems
- Deep packet inspection
- Traffic analytics

```
Internet → IGW → Route Table → GWLB Endpoint → GWLB → Appliance Fleet
                                                         (inspect/filter)
                                                              ↓
                                                         GWLB → GWLB Endpoint → Application
```

**Components:**
- **GWLB:** Load balances across appliance fleet
- **GWLB Endpoints (GWLBe):** VPC endpoints in consumer VPCs for traffic routing
- **Target Group:** Appliance instances (IP or Instance targets)

**Key features:**
- Flow stickiness (5-tuple or 3-tuple hash)
- Cross-zone load balancing
- Health checks to appliance instances
- Auto Scaling for appliance fleet

### Load Balancer Comparison

| Feature | ALB | NLB | GWLB |
|---------|-----|-----|------|
| Layer | 7 (HTTP/HTTPS) | 4 (TCP/UDP/TLS) | 3 (IP/GENEVE) |
| Performance | Good | Ultra-high | High |
| Static IP | No (use Global Accelerator) | Yes (Elastic IP per AZ) | N/A |
| PrivateLink | No (as service) | Yes | Yes (GWLBe) |
| Preserve client IP | Via X-Forwarded-For header | Yes (native) | Yes |
| WebSocket | Yes | Yes | N/A |
| SSL/TLS termination | Yes | Yes | No |
| Path/Host routing | Yes | No | No |
| WAF integration | Yes | No | N/A |
| Lambda targets | Yes | No | No |
| UDP | No | Yes | N/A |
| Cross-zone LB default | Enabled (free) | Disabled (charges) | Disabled (charges) |

> **Exam Tip:** "Need static IP" → NLB or Global Accelerator in front of ALB. "PrivateLink/VPC Endpoint Service" → Must use NLB. "Inline appliance inspection" → GWLB. "Path-based routing" → ALB. "UDP or extreme performance" → NLB.

---

## 8. EC2 Auto Scaling vs Application Auto Scaling

### EC2 Auto Scaling

- Scales EC2 instance count in Auto Scaling Groups
- Policies: Target Tracking, Step, Simple, Scheduled, Predictive
- Specific to EC2 instances

### Application Auto Scaling

- Generic auto scaling for non-EC2 AWS resources
- Supports same policy types: Target Tracking, Step, Scheduled

**Supported resources:**

| Service | Scalable Dimension |
|---------|--------------------|
| ECS | Service desired count |
| DynamoDB | Table/GSI read/write capacity |
| Aurora | Number of read replicas |
| EMR | Instance count in instance groups |
| AppStream 2.0 | Fleet instances |
| SageMaker | Endpoint instances |
| Comprehend | Document/entity classifiers |
| Lambda | Provisioned concurrency |
| ElastiCache | Replicas in replication group |
| Neptune | Read replicas |
| Custom Resources | Any resource via custom CloudWatch metrics |

> **Exam Tip:** If a question mentions scaling DynamoDB, Aurora replicas, ECS tasks, or Lambda provisioned concurrency — it's Application Auto Scaling, not EC2 Auto Scaling. Both support target tracking, step, and scheduled policies.

---

## 9. Spot Instance Strategies

### Spot Fleet

- Request a collection of Spot Instances (and optionally On-Demand)
- Define: Target capacity, max price, launch specifications (multiple instance types, AZs)
- Allocation strategies:
  - **lowestPrice:** Launch in the lowest-price pool (risk: all eggs in one basket)
  - **diversified:** Spread across all pools (better for availability)
  - **capacityOptimized:** Launch in pools with most available capacity (lower interruption risk)
  - **priceCapacityOptimized (recommended):** Balance between price and capacity availability

### Diversification Best Practices

- Use multiple instance types across multiple families (e.g., c5.xlarge, c5a.xlarge, m5.xlarge, c4.xlarge)
- Use multiple AZs
- Use `priceCapacityOptimized` strategy
- Set `OnDemandBaseCapacity` for minimum guaranteed capacity

### Spot Block (Deprecated)

- Previously allowed 1-6 hour defined duration Spot Instances
- **No longer available for new customers** (as of Dec 2022)
- Exam may still reference; know it's deprecated

### Interruption Handling

**2-minute warning:** Available via:
- EC2 metadata endpoint (`http://169.254.169.254/latest/meta-data/spot/instance-action`)
- EventBridge (EC2 Spot Instance Interruption Warning)
- CloudWatch Events

**Strategies for handling interruptions:**
1. **Checkpoint and resume:** Save progress to S3/DynamoDB, resume on new instance
2. **Graceful shutdown:** Deregister from load balancer, drain connections, save state
3. **Rebalancing recommendation:** EventBridge event when a Spot Instance is at elevated risk — allows proactive migration before actual interruption
4. **Use ASG with mixed instances:** Maintain capacity by replacing interrupted Spot with On-Demand

```
Best Practice Architecture:
┌─────────────────────────────────────────────┐
│ Auto Scaling Group (Mixed Instances Policy)  │
│                                              │
│ On-Demand Base: 2 instances                  │
│ Above Base: 25% On-Demand / 75% Spot         │
│                                              │
│ Instance Types: c5.xl, c5a.xl, c5d.xl, m5.xl│
│ AZs: us-east-1a, 1b, 1c                     │
│ Strategy: price-capacity-optimized           │
│                                              │
│ [OD1] [OD2] [Spot1] [Spot2] [Spot3] [Spot4] │
└─────────────────────────────────────────────┘
```

> **Exam Tip:** Always diversify Spot across instance types and AZs. Use `priceCapacityOptimized` (not `lowestPrice`). Handle Spot interruptions via EventBridge + automation. For critical workloads, use On-Demand base + Spot above base.

---

## 10. Compute Optimizer

### Overview

- ML-powered service that recommends optimal AWS resources
- Analyzes historical utilization metrics (CPU, memory, network, storage)
- Requires CloudWatch agent for memory metrics (not collected by default)

### Supported Resources

| Resource | Recommendations |
|----------|----------------|
| EC2 Instances | Instance type right-sizing |
| Auto Scaling Groups | Instance type, count |
| EBS Volumes | Volume type, size, IOPS |
| Lambda Functions | Memory size |
| ECS on Fargate | CPU, memory for tasks |
| Commercial software licenses | License right-sizing |

### Recommendation Types

- **Under-provisioned:** Resource is too small (risk of performance issues)
- **Over-provisioned:** Resource is too large (cost optimization opportunity)
- **Optimized:** Current configuration is appropriate
- **None:** Not enough data (need 30+ hours of metric data)

### Enhanced Infrastructure Metrics

- Paid feature that extends the lookback period from 14 days to 3 months
- Provides more accurate recommendations for variable workloads
- Available at organization, account, or resource level

> **Exam Tip:** Compute Optimizer needs CloudWatch metrics. For accurate memory-based recommendations, install the CloudWatch agent. The free tier uses 14 days of data; enhanced metrics use up to 3 months.

---

## 11. Elastic Beanstalk

### Overview

- PaaS that handles infrastructure provisioning, deployment, load balancing, scaling, and monitoring
- Developer focuses on code; Beanstalk manages the rest
- Full control retained — can SSH into instances, modify resources

### Concepts

- **Application:** Logical collection of components (environments, versions, configurations)
- **Environment:** Collection of AWS resources running an application version
  - **Web Server Environment:** For HTTP workloads (ALB + ASG + EC2)
  - **Worker Environment:** For background processing (SQS + ASG + EC2)
- **Application Version:** Specific labeled iteration of deployable code
- **Environment Configuration:** Parameters defining how resources are provisioned

### Supported Platforms

Docker, Go, Java SE, Java Tomcat, .NET Core on Linux, .NET on Windows, Node.js, PHP, Python, Ruby

### Deployment Policies

| Policy | Downtime | Deploy Speed | Rollback | Cost |
|--------|----------|-------------|----------|------|
| All at once | Yes | Fastest | Redeploy | No extra |
| Rolling | No (reduced capacity) | Slow | Redeploy | No extra |
| Rolling with additional batch | No | Slower | Redeploy | Extra instances during deploy |
| Immutable | No | Slowest | Terminate new ASG | Double capacity during deploy |
| Traffic splitting | No | Slow | Reroute traffic | Extra instances |
| Blue/Green | No | Manual | Swap URLs | Full duplicate environment |

**Traffic splitting:** Canary-style deployment — send a percentage of traffic to new instances, then shift all traffic if healthy.

### .ebextensions

- Configuration files in `.ebextensions/` directory
- YAML or JSON files with `.config` extension
- Executed in alphabetical order

```yaml
# .ebextensions/01-packages.config
packages:
  yum:
    git: []
    
commands:
  01_setup:
    command: "echo 'setup complete'"

option_settings:
  aws:autoscaling:asg:
    MinSize: 2
    MaxSize: 10
  aws:elb:listener:443:
    ListenerProtocol: HTTPS
    SSLCertificateId: arn:aws:acm:...

Resources:
  myDynamoDBTable:
    Type: AWS::DynamoDB::Table
    Properties:
      TableName: my-table
```

**Capabilities:**
- Install packages
- Run commands
- Set environment variables
- Configure AWS resources (using CloudFormation syntax)
- Create files
- Set users/groups

### Docker on Beanstalk

- **Single Container Docker:** One Docker container per instance
- **Multi-Container Docker:** Multiple containers per instance using ECS
- **Preconfigured Docker:** AWS-provided Docker platforms
- Uses `Dockerrun.aws.json` for multi-container configuration

### Saved Configurations and Environment Manifest

- **Saved Configurations:** Save environment configuration for reuse
- **env.yaml (Environment Manifest):** Define environment properties in source code

### Worker Environments

- Process messages from SQS queue
- `cron.yaml` for scheduled tasks
- Dead-letter queue for failed messages
- Automatic SQS daemon manages message processing

> **Exam Tip:** Beanstalk for scenarios needing rapid deployment with full AWS resource control. Immutable deployments for safest rollback. .ebextensions for customizing infrastructure. Worker environments for async processing.

---

## 12. Outposts, Local Zones, and Wavelength Zones

### AWS Outposts

**On-premises AWS infrastructure:**
- AWS-managed hardware rack installed in your data center
- Same AWS APIs, tools, and services on-premises
- Connected to nearest AWS Region via dedicated network link

**Available services:** EC2, EBS, S3 on Outposts, ECS, EKS, RDS, ElastiCache, EMR, ALB

**Form factors:**
- **Outposts rack:** Full 42U rack (1–96 racks)
- **Outposts servers:** 1U/2U servers for smaller spaces

**Use cases:**
- Data residency (data must stay on-premises)
- Low-latency local processing
- Local data processing before cloud migration
- Migration stepping stone

**S3 on Outposts:**
- S3 APIs on-premises
- Data stored locally on Outpost
- Can replicate to S3 in the Region

### Local Zones

- AWS infrastructure in metro areas closer to users
- Extension of an AWS Region
- Opt-in from the AWS console
- Provides single-digit millisecond latency to end users
- Available services: EC2, EBS, VPC, ELB, some others

**Use cases:**
- Real-time gaming
- Live video streaming
- AR/VR
- Virtual desktop infrastructure (VDI)

### Wavelength Zones

- AWS infrastructure embedded in 5G carrier networks
- Ultra-low latency to mobile devices
- Available at carrier network edge (Verizon, Vodafone, etc.)
- Traffic from mobile devices never leaves the carrier network

**Use cases:**
- Mobile gaming
- Live video streaming to mobile
- AR/VR on mobile
- ML inference at the edge
- Connected vehicles

### Comparison

| Feature | Outposts | Local Zones | Wavelength Zones |
|---------|----------|-------------|------------------|
| Location | Your data center | Metro areas | 5G carrier edge |
| Managed by | AWS (hardware on-premises) | AWS (in city) | AWS (in carrier) |
| Latency | On-premises access | Single-digit ms | Ultra-low (5G) |
| Data residency | Yes (on-prem) | No (AWS facility) | No (carrier facility) |
| Services | Broad | Limited | Very limited |
| Use case | Hybrid, data sovereignty | City-level latency | Mobile edge |

> **Exam Tip:** Data must stay on-premises → Outposts. Single-digit ms latency in a specific city → Local Zone. Ultra-low latency for 5G mobile users → Wavelength Zone.

---

## 13. Exam Scenarios and Decision Frameworks

### Compute Selection Decision Tree

```
Q: What type of workload?
│
├─ Web Application
│  ├─ Variable traffic → ALB + ASG (Target Tracking) + Spot mixed instances
│  ├─ Predictable traffic → ALB + ASG + Reserved/Savings Plan
│  └─ Microservices → Consider ECS/EKS or Lambda
│
├─ Batch Processing
│  ├─ Fault tolerant → Spot Fleet (diversified) + SQS for work items
│  ├─ Time-sensitive → On-Demand + Auto Scaling
│  └─ Recurring schedule → Spot + Scheduled Scaling
│
├─ HPC / Tightly Coupled
│  ├─ Cluster Placement Group + EFA
│  ├─ C/P series for compute/GPU
│  └─ FSx for Lustre for parallel file system
│
├─ Machine Learning
│  ├─ Training → P5 / Trn1 (Spot if checkpointing)
│  ├─ Inference → Inf2 / G6
│  └─ Managed → SageMaker
│
├─ Licensing (per-core/socket)
│  └─ Dedicated Hosts (visibility into sockets/cores)
│
├─ Latency-Sensitive
│  ├─ City-level → Local Zone
│  ├─ Mobile/5G → Wavelength Zone
│  └─ On-premises → Outposts
│
└─ Data Residency / Compliance
   └─ Outposts (data stays on-premises)
```

### Common Exam Scenarios

**Scenario 1: "Company needs to reduce costs for a steady-state workload running 24/7 on m5.xlarge instances."**
→ EC2 Instance Savings Plan (commit to m5 family in region) or Standard RI (3-year, all upfront for max discount)

**Scenario 2: "Application needs to handle sudden traffic spikes from 100 to 10,000 users."**
→ ALB + ASG with Target Tracking + Predictive Scaling. Consider warm pools if instances take long to initialize.

**Scenario 3: "HPC workload needs low-latency inter-node communication with MPI."**
→ Cluster Placement Group + EFA + C5n/P4d instances

**Scenario 4: "Need to expose a service to hundreds of customer VPCs without peering."**
→ NLB + VPC Endpoint Service (PrivateLink)

**Scenario 5: "Batch job can tolerate interruptions, runs for 20 minutes per task, need lowest cost."**
→ Spot Instances with price-capacity-optimized allocation, multiple instance types, checkpointing to S3/SQS

**Scenario 6: "Application requires static IPs for whitelisting by partners."**
→ NLB (Elastic IP per AZ) or Global Accelerator (2 static anycast IPs)

**Scenario 7: "Need to inspect all traffic entering VPC through third-party firewall appliance."**
→ GWLB + Firewall appliance fleet in inspection VPC

**Scenario 8: "Oracle database requires per-core licensing."**
→ Dedicated Host (provides socket/core visibility for license compliance)

**Scenario 9: "Deploy new application version with zero-downtime and instant rollback."**
→ ALB weighted target groups (blue/green) or Elastic Beanstalk immutable/traffic-splitting deployment

**Scenario 10: "Instances take 10 minutes to bootstrap with configuration data."**
→ Golden AMI (pre-bake configuration) + Warm Pools in ASG (pre-initialized stopped instances)

### Key Numbers to Remember

| Metric | Value |
|--------|-------|
| Spread placement group max per AZ | 7 instances |
| Partition placement group max partitions per AZ | 7 |
| Default ASG cooldown | 300 seconds |
| Spot interruption notice | 2 minutes |
| ALB idle timeout | 60 seconds (configurable) |
| NLB idle timeout | 350 seconds (not configurable) |
| ALB listener rules max | 100 per ALB |
| ASG max group size | 1500 instances (soft limit) |
| T3 unlimited surplus credits | Charged at On-Demand vCPU rate |

---

## Quick Reference: Exam Tips Summary

1. **Cost optimization hierarchy:** Spot (90% off) > 3-yr RI All Upfront (72% off) > Savings Plans (66% off) > On-Demand
2. **Guaranteed capacity:** Zonal RI or On-Demand Capacity Reservation (NOT regional RI)
3. **BYOL licensing:** Dedicated Host (NOT Dedicated Instance)
4. **Static IPs for load balancer:** NLB or Global Accelerator + ALB
5. **PrivateLink:** Requires NLB as service endpoint
6. **Inline traffic inspection:** GWLB
7. **HPC inter-node:** Cluster Placement Group + EFA
8. **AMI encryption sharing:** Must use customer-managed CMK, grant KMS permissions
9. **Warm Pools:** Pre-initialized instances for faster scaling
10. **Predictive Scaling:** ML-based forecasting, needs 14 days of data
11. **Mixed instances in ASG:** Diversify Spot across types/families for resilience
12. **Instance Refresh:** Rolling update of instances (not blue/green)
13. **Graviton:** Best price-performance, ARM-based, check software compatibility
14. **Compute Optimizer:** Needs CloudWatch agent for memory metrics; 30+ hours of data required

---

*This document covers the compute solutions knowledge required for the SAP-C02 exam Domain 2. Pair this with hands-on practice in the AWS console and review AWS documentation for the latest service updates.*
