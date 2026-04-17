# EC2 Deep Dive

## Table of Contents

1. [Introduction to EC2](#introduction-to-ec2)
2. [Instance Types & Families](#instance-types--families)
3. [Instance Naming Convention](#instance-naming-convention)
4. [Purchasing Options](#purchasing-options)
5. [Amazon Machine Images (AMIs)](#amazon-machine-images-amis)
6. [Placement Groups](#placement-groups)
7. [Network Interfaces: ENI vs ENA vs EFA](#network-interfaces-eni-vs-ena-vs-efa)
8. [Instance Lifecycle: Hibernate, Stop, Terminate](#instance-lifecycle-hibernate-stop-terminate)
9. [User Data and Instance Metadata](#user-data-and-instance-metadata)
10. [Instance Store vs EBS](#instance-store-vs-ebs)
11. [EC2 Networking](#ec2-networking)
12. [Auto Scaling Groups](#auto-scaling-groups)
13. [EC2 Image Builder](#ec2-image-builder)
14. [Nitro System](#nitro-system)
15. [Burstable Instances & CPU Credits](#burstable-instances--cpu-credits)
16. [Complete Pricing Comparison](#complete-pricing-comparison)
17. [Exam Tips & Scenarios](#exam-tips--scenarios)

---

## Introduction to EC2

Amazon Elastic Compute Cloud (EC2) is the backbone of AWS compute services. It provides resizable virtual servers (instances) in the cloud, giving you complete control over the operating system, networking, storage, and security. EC2 is arguably the single most important service to understand for the SAA-C03 exam.

Key concepts:
- **Instances** are virtual servers running on AWS physical hosts
- You choose the **instance type** (CPU, memory, storage, networking)
- You choose the **AMI** (operating system and pre-installed software)
- You choose the **network settings** (VPC, subnet, security groups)
- You choose the **storage** (EBS volumes, instance store)
- You pay based on the **purchasing option** selected

---

## Instance Types & Families

EC2 instance types are grouped into families optimized for different workloads. Understanding when to use each family is critical for the exam.

### General Purpose (M, T, A, Mac)

General Purpose instances provide a balance of compute, memory, and networking resources.

| Family | Highlights | Use Cases |
|--------|-----------|-----------|
| **M7i, M7g, M7a, M6i, M6g, M6a, M5** | Balanced CPU-to-memory ratio (1 vCPU : 4 GiB). M7g/M6g are Graviton (ARM)-based. | Web servers, application servers, small/medium databases, development environments, backend servers, enterprise applications |
| **T3, T3a, T2** | Burstable performance with CPU credit system. T3a uses AMD processors. | Micro-services, low-latency interactive applications, small/medium databases, development, test, staging environments |
| **A1** | ARM-based (Graviton first-gen). Cost-effective. | Scale-out workloads: web servers, containerized microservices, development environments |
| **Mac1, Mac2** | Runs macOS on Mac mini hardware. Dedicated Host required. | Build/test/sign Apple applications (iOS, macOS, tvOS, watchOS) |

**Exam Tip**: When you see "balanced" or "general-purpose" in a question, think M-family. When you see "cost-sensitive variable workload" or "burstable," think T-family.

### Compute Optimized (C)

Compute Optimized instances are ideal for compute-bound applications that benefit from high-performance processors.

| Family | Highlights | Use Cases |
|--------|-----------|-----------|
| **C7g, C7gn, C7i, C7a, C6g, C6i, C6a, C5, C5n** | Highest CPU-to-memory ratio. C7g/C6g are Graviton-based. C5n/C7gn offer 100+ Gbps networking. | Batch processing, media transcoding, high-performance web servers, high-performance computing (HPC), scientific modeling, dedicated gaming servers, ad serving, machine learning inference |

**Exam Tip**: Keywords like "compute-intensive," "batch processing," "HPC," or "media encoding" point to C-family.

### Memory Optimized (R, X, Z, High Memory)

Memory Optimized instances are designed to deliver fast performance for workloads that process large data sets in memory.

| Family | Highlights | Use Cases |
|--------|-----------|-----------|
| **R7g, R7i, R7a, R6g, R6i, R6a, R5, R5b** | High memory-to-CPU ratio (1 vCPU : 8 GiB). R5b offers up to 60 Gbps EBS bandwidth. | High-performance databases (MySQL, PostgreSQL, Oracle), distributed in-memory caches (Redis, Memcached, ElastiCache), real-time big data analytics |
| **X2idn, X2iedn, X2gd, X1e, X1** | Very large memory (up to 4 TiB per instance). X2iedn includes local NVMe storage. | SAP HANA, in-memory databases, large-scale enterprise databases |
| **z1d** | High single-thread performance + large memory. Sustained all-core frequency of up to 4.0 GHz. | Electronic Design Automation (EDA), certain relational database workloads with high per-core licensing costs |
| **u-* (High Memory)** | Up to 24 TiB of RAM. Bare metal only. | SAP HANA production environments |

**Exam Tip**: "In-memory database," "SAP HANA," "high memory," "ElastiCache" → R/X-family. "High per-core performance" → z1d.

### Storage Optimized (I, D, H)

Storage Optimized instances provide high sequential read/write access to very large data sets on local storage.

| Family | Highlights | Use Cases |
|--------|-----------|-----------|
| **I4i, I3, I3en** | NVMe SSD-backed instance storage. Very high random I/O performance (millions of IOPS). I3en offers up to 60 TB dense storage. | NoSQL databases (Cassandra, MongoDB, DynamoDB local), data warehousing, distributed file systems, high-frequency online transaction processing (OLTP) |
| **D3, D3en, D2** | HDD-backed instance storage. Very high sequential read/write throughput. D3en offers up to 336 TB. | Massively parallel processing (MPP) data warehouses, MapReduce/Hadoop distributed computing, distributed file systems, log/data processing |
| **H1** | HDD-based with high sequential throughput and balance of compute and memory. Up to 16 TB. | MapReduce, distributed file systems, network file systems, log processing |

**Exam Tip**: "High IOPS," "NoSQL," "transactional databases" → I-family. "Big data," "MapReduce," "data lakes," "sequential throughput" → D/H-family.

### Accelerated Computing (P, G, F, Inf, Trn, DL, VT)

Accelerated Computing instances use hardware accelerators (GPUs, FPGAs, or custom chips) to perform some functions more efficiently.

| Family | Highlights | Use Cases |
|--------|-----------|-----------|
| **P5, P4d, P3** | NVIDIA GPU instances. P5 has H100 GPUs with 640 GB HBM3 memory. | Machine learning training, deep learning, HPC, genomics |
| **G5, G5g, G4dn, G4ad** | GPU instances optimized for graphics. G5 uses NVIDIA A10G GPUs. G4ad uses AMD Radeon Pro. | Machine learning inference, video transcoding, graphics-intensive applications, game streaming, 3D rendering |
| **F1** | FPGA instances. Customizable hardware acceleration. | Genomics research, financial analytics, real-time video processing, big data search/analytics |
| **Inf2, Inf1** | AWS Inferentia chips. Purpose-built for ML inference. Lowest cost-per-inference. | High-performance, cost-effective ML inference at scale |
| **Trn1, Trn1n** | AWS Trainium chips. Purpose-built for ML training. | High-performance, cost-effective deep learning training |
| **DL1, DL2q** | Gaudi HPU instances for deep learning. | Deep learning training |
| **VT1** | Xilinx video transcoding instances. | Live video transcoding |

**Exam Tip**: "GPU," "machine learning training" → P-family. "Graphics," "rendering," "inference" → G-family. "Lowest cost inference" → Inf-family. "FPGA" → F-family.

---

## Instance Naming Convention

EC2 instance names follow a consistent pattern:

```
m5a.2xlarge
│││  │
││├──┤ a = AMD processor
│├───┤ 5 = generation
├────┤ m = family (General Purpose)
     └─ 2xlarge = size
```

**Common additional letters:**
- **g** → Graviton (ARM-based, e.g., m7g)
- **a** → AMD processor (e.g., m5a)
- **i** → Intel processor (e.g., m7i)
- **n** → Network optimized (e.g., c5n)
- **d** → Local NVMe instance store (e.g., m5d)
- **b** → EBS optimized (e.g., r5b)
- **e** → Extra storage or memory (e.g., x2iedn)
- **flex** → Flex instance (e.g., m7i-flex)
- **metal** → Bare metal (no hypervisor)

**Size progression:**
`nano → micro → small → medium → large → xlarge → 2xlarge → 4xlarge → 8xlarge → 12xlarge → 16xlarge → 24xlarge → 48xlarge → metal`

Each step roughly doubles the resources (vCPUs, memory, network bandwidth, EBS bandwidth).

---

## Purchasing Options

This is one of the most heavily tested topics on the SAA-C03 exam. You must understand when to recommend each option.

### On-Demand Instances

- **Billing**: Per-second (minimum 60 seconds) for Linux/Windows. Per-hour for other OSes.
- **Commitment**: None. Start/stop anytime.
- **Discount**: None (baseline price).
- **Use Cases**: Short-term, unpredictable workloads. Applications being developed/tested. Workloads that cannot be interrupted.

### Reserved Instances (RI)

Reserved Instances provide up to **72% discount** compared to On-Demand pricing in exchange for a 1-year or 3-year commitment.

**Standard Reserved Instances:**
- Can change: AZ, instance size (within same family), networking type
- Cannot change: instance family, OS, tenancy, payment option, term
- Can be sold on the Reserved Instance Marketplace

**Convertible Reserved Instances:**
- Can change: instance family, OS, tenancy, payment option
- Lower discount (up to ~66%) than Standard RIs
- **Cannot** be sold on the RI Marketplace

**Payment options and their discounts (approximate):**

| Payment Option | 1-Year Discount | 3-Year Discount |
|---------------|----------------|----------------|
| No Upfront | ~36% | ~56% |
| Partial Upfront | ~40% | ~60% |
| All Upfront | ~42% | ~72% |

**Regional vs Zonal RIs:**
- **Regional RI**: Discount applies to any AZ in the region. Provides capacity reservation at the *regional* level. Size flexibility within instance family (Linux only).
- **Zonal RI**: Discount applies only to the specified AZ. Provides a capacity reservation in that specific AZ. No size flexibility.

**Exam Tip**: For steady-state, predictable workloads running 24/7, Reserved Instances offer the best cost savings (if a 1-3 year commitment is acceptable).

### Savings Plans

Savings Plans offer up to **72% discount** (same as RIs) with more flexibility.

**Compute Savings Plans:**
- Apply to any EC2 instance regardless of family, size, AZ, Region, OS, or tenancy
- Also apply to **Fargate** and **Lambda** usage
- Most flexible plan
- Discount: up to 66%

**EC2 Instance Savings Plans:**
- Apply to a specific instance family in a specific Region
- Any size, OS, or tenancy within that family/Region
- Discount: up to 72%

**Both types:**
- Require a commitment of $/hour for 1 or 3 years
- Payment: All Upfront, Partial Upfront, No Upfront
- Usage beyond the commitment is billed at On-Demand rates

**Exam Tip**: AWS now recommends Savings Plans over Reserved Instances for most use cases. If the question mentions flexibility across instance families or regions, choose Compute Savings Plans.

### Spot Instances

Spot Instances let you use spare EC2 capacity at up to **90% discount** vs On-Demand.

**Key characteristics:**
- You define a **max spot price** you're willing to pay
- If the current spot price exceeds your max price, your instance is interrupted with a **2-minute warning**
- Spot Instances can also be interrupted when AWS needs the capacity back
- **NOT suitable** for critical workloads or databases

**Spot Instance interruption handling (you choose one):**
- **Terminate**: Instance is terminated (default)
- **Stop**: Instance is stopped (only for EBS-backed instances)
- **Hibernate**: Instance state is saved to EBS root volume

**Spot Fleets:**
A Spot Fleet is a collection of Spot Instances and (optionally) On-Demand Instances that attempts to meet your target capacity.

Allocation strategies:
- **lowestPrice** (default): Launches instances from the pool with the lowest price. (Being deprecated in favor of `priceCapacityOptimized`)
- **diversified**: Distributes across all pools (good for availability)
- **capacityOptimized**: Launches from the pool with the most available capacity (reduces interruptions)
- **priceCapacityOptimized** (recommended): Considers both price and capacity availability

**Spot Placement Score:**
- A pre-launch assessment that recommends AWS Regions or AZs where your Spot request is likely to succeed
- Helps you determine the best location for your Spot workloads
- Returns a score from 1-10 for each Region/AZ

**Best use cases for Spot:**
- Batch processing jobs
- Data analysis
- Image/video rendering
- CI/CD workloads
- Big data processing (EMR)
- Stateless web servers (behind a load balancer)
- High-performance computing

### Dedicated Hosts

A **Dedicated Host** is an entire physical server fully dedicated to your use.

| Feature | Detail |
|---------|--------|
| **Visibility** | You get visibility into sockets, cores, host ID |
| **Compliance** | Addresses per-socket/per-core software licensing (e.g., Windows Server, SQL Server, Oracle) |
| **Affinity** | You can control instance placement on the host |
| **Pricing** | On-Demand or Reserved (1yr/3yr). Most expensive option. |
| **Sharing** | Can share with other AWS accounts via RAM (Resource Access Manager) |
| **Duration** | Host is allocated for at least your reservation period |

### Dedicated Instances

A **Dedicated Instance** runs on hardware dedicated to your account but you don't get control over the physical host.

| Feature | Dedicated Host | Dedicated Instance |
|---------|---------------|-------------------|
| Dedicated physical server | Yes | Yes |
| Per-host billing | Yes | No (per-instance + per-region fee) |
| Visibility into sockets/cores | Yes | No |
| Host affinity | Yes | No |
| BYOL (Bring Your Own License) | Yes | Depends on license |
| Instance placement control | Yes | No |

**Exam Tip**: If the question mentions "software licensing," "per-core licensing," "per-socket licensing," or "compliance requiring physical server isolation" → Dedicated Host. If it just says "hardware isolation" → Dedicated Instance is cheaper.

### Capacity Reservations

On-Demand Capacity Reservations let you reserve capacity in a specific AZ without a term commitment.

- **No discount**: You pay On-Demand price whether or not you run instances
- **Guaranteed capacity**: Ensures you can launch instances when you need them
- **No term commitment**: Create or cancel anytime
- **Combine with Savings Plans or Regional RIs** for discounts + capacity guarantee
- Must specify: instance type, platform (OS), AZ, tenancy, quantity

**Exam Tip**: Use Capacity Reservations when you need to guarantee capacity for disaster recovery or critical applications, combined with Savings Plans for cost optimization.

---

## Amazon Machine Images (AMIs)

An AMI is a template that contains the software configuration (OS, application server, applications) to launch an EC2 instance.

### AMI Types

**By backing store:**
- **EBS-backed AMI**: Root device is an EBS volume. Instance can be stopped and restarted. Most common.
- **Instance store-backed AMI**: Root device is instance store. Instance cannot be stopped, only terminated.

**By source:**
- **AWS-provided AMIs**: Amazon Linux, Ubuntu, Windows, RHEL, etc.
- **AWS Marketplace AMIs**: Third-party software (may include licensing costs)
- **Community AMIs**: Shared by other AWS users (use at your own risk)
- **Custom AMIs**: Your own AMIs built from configured instances

### Creating an AMI

1. Launch and configure an EC2 instance
2. Stop the instance (ensures data integrity — recommended but not required)
3. Create an AMI → This creates EBS snapshots of the attached volumes
4. The AMI is registered and can be used to launch new instances

Creating an AMI from a running instance is possible but may result in data inconsistency.

### Copying AMIs Across Regions

- AMIs are **regional** resources
- To use an AMI in another Region, you must **copy** it to that Region
- The copy process creates new EBS snapshots in the target Region
- The copied AMI gets a new AMI ID
- Source AMI is unaffected

### Sharing AMIs

- You can share an AMI with specific AWS accounts, or make it public
- You can share encrypted AMIs, but you must also share the KMS key used for encryption
- Sharing an AMI does NOT change ownership — the source account retains ownership
- The receiving account can copy the shared AMI to become the owner of the copy

### AMI Encryption

- You can encrypt an AMI's EBS snapshots
- If you launch an instance with an encrypted AMI, the root volume is encrypted
- You **cannot** directly create an unencrypted AMI from an encrypted snapshot
- **To encrypt an unencrypted AMI**: Copy the AMI and enable encryption during the copy
- You can use a custom KMS key (CMK) or the AWS-managed key

**Cross-account encrypted AMI sharing:**
1. Share the KMS CMK with the target account (key policy)
2. Share the AMI with the target account
3. Target account copies the AMI and re-encrypts with their own KMS key

---

## Placement Groups

Placement groups control how instances are placed on underlying hardware.

### Cluster Placement Group

- Instances are packed close together **in a single AZ** on the same rack (or nearby racks)
- Provides **lowest latency** and **highest throughput** (up to 10-25 Gbps within the group)
- All instances should be launched at the same time for best allocation
- If an instance fails, all instances in the group could be affected (single point of failure at rack level)

**Use cases:** Big data jobs needing fast inter-node communication, HPC, applications requiring extremely low latency

**Limitations:**
- Only certain instance types are supported
- Recommended to use a single instance type (homogeneous)
- Cannot span AZs
- You can add instances later but risk "insufficient capacity" errors

### Spread Placement Group

- Each instance is placed on **distinct underlying hardware** (different racks)
- Minimizes correlated failures
- **Limit: 7 instances per AZ per placement group**
- Can span multiple AZs within a Region

**Use cases:** Critical applications where each instance must be isolated from failure of other instances (e.g., primary/secondary database nodes, critical application instances)

**Limitations:**
- Maximum of 7 running instances per AZ
- Not supported for Dedicated Instances or Dedicated Hosts

### Partition Placement Group

- Instances are divided into **partitions** (logical groups), each on different racks
- Up to **7 partitions per AZ**
- Can have hundreds of instances
- Instances in one partition do not share racks with instances in other partitions
- You get partition information via metadata (which instances are in which partition)

**Use cases:** Large distributed/replicated workloads (HDFS, HBase, Cassandra, Kafka) where topology awareness matters

| Feature | Cluster | Spread | Partition |
|---------|---------|--------|-----------|
| Latency | Lowest | Normal | Normal |
| Availability | Lowest (single rack risk) | Highest | High |
| Max instances per AZ | No limit (but same rack) | 7 | Hundreds (7 partitions) |
| Span AZs | No | Yes | Yes |
| Best for | HPC, low-latency | Critical individual instances | Distributed big data |

---

## Network Interfaces: ENI vs ENA vs EFA

### ENI (Elastic Network Interface)

An ENI is a **virtual network card** attached to an EC2 instance.

Each ENI has:
- A primary private IPv4 address
- One or more secondary private IPv4 addresses
- One Elastic IP per private IPv4 address
- One public IPv4 address
- One or more IPv6 addresses
- One or more security groups
- A MAC address
- A source/destination check flag

**Key points:**
- Every instance has a default (primary) ENI that cannot be detached
- You can create and attach additional ENIs
- ENIs are bound to an AZ
- You can move secondary ENIs between instances (for failover)
- The number of ENIs and IPs per ENI depends on the instance type

### ENA (Elastic Network Adapter)

ENA provides **Enhanced Networking** capabilities:
- Up to **100 Gbps** network bandwidth
- Higher packets per second (PPS) performance
- Lower latency and jitter
- Uses **SR-IOV** (Single Root I/O Virtualization) — provides direct hardware access, bypassing the hypervisor
- No additional cost
- Supported on most current-generation instance types
- Requires ENA driver in the AMI

**Alternative for Enhanced Networking:**
- **Intel 82599 VF** (legacy): Up to 10 Gbps. Used on older instance types (C3, C4, R3, etc.)

### EFA (Elastic Fabric Adapter)

EFA is a **network device for HPC and ML** workloads:
- Provides **OS-bypass** capability (Linux only) using the **Libfabric** interface
- Enables direct hardware communication between instances, bypassing the OS kernel
- Much lower latency than traditional TCP networking
- Supports **Message Passing Interface (MPI)** for tightly-coupled HPC applications
- Available on specific instance types (p4d, c5n, m5n, r5n, etc.)

**Exam Tip**: "Low-latency HPC," "MPI," "tightly-coupled" → EFA. "Enhanced networking" or "high bandwidth" → ENA.

---

## Instance Lifecycle: Hibernate, Stop, Terminate

### Stop

- The instance shuts down; EBS root volume is preserved
- Instance store data is **lost**
- You stop paying for compute (still pay for EBS volumes and Elastic IPs)
- When restarted: new public IPv4 (unless Elastic IP), same private IPv4
- Can change instance type while stopped
- Instance can be in "stopped" state indefinitely

### Terminate

- Instance is permanently deleted
- EBS root volume is deleted by default (configurable via `DeleteOnTermination` attribute)
- Additional EBS volumes are preserved by default (also configurable)
- Instance store data is **lost**
- **Termination protection**: `DisableApiTermination` attribute prevents accidental termination via API/Console

### Hibernate

Hibernate saves the **in-memory (RAM) state** to the encrypted EBS root volume, enabling much faster startup.

**How it works:**
1. RAM contents are written to the EBS root volume (must be encrypted and large enough)
2. Instance enters "stopped" state
3. On startup: RAM contents are loaded from EBS, processes resume
4. Boot is much faster than a cold start

**Requirements & Limitations:**
- Root volume must be **EBS** (not instance store) and **encrypted**
- Root volume must be large enough to store the RAM
- RAM must be **less than 150 GB**
- Supported on: On-Demand, Reserved, and Spot Instances
- Supported instance families: C, M, R (3-5 generations), plus others
- Cannot hibernate for more than **60 days**
- Available for Amazon Linux 2, Ubuntu, Windows

**Exam Tip**: "Fast boot time," "preserve in-memory state," "long-running processes that need quick resume" → Hibernate.

---

## User Data and Instance Metadata

### User Data

User data is a script (or cloud-init directives) that runs **once** at instance first boot (by default).

```bash
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "Hello from $(hostname)" > /var/www/html/index.html
```

**Key points:**
- Runs as **root** user
- Maximum size: **16 KB** (before base64 encoding)
- Accessible at: `http://169.254.169.254/latest/user-data`
- Can be shell scripts (Linux) or PowerShell scripts (Windows)
- Can be modified when instance is stopped, but only runs on first boot by default
- Use **cloud-init** `per-boot` module to run scripts on every boot

### Instance Metadata Service (IMDS)

Instance metadata provides information about the running instance, accessible from within the instance.

**Endpoint:** `http://169.254.169.254/latest/meta-data/`

Common metadata categories:
- `ami-id` — The AMI used to launch the instance
- `instance-id` — The instance ID
- `instance-type` — The instance type
- `local-ipv4` — Private IP address
- `public-ipv4` — Public IP address
- `security-groups` — Security groups
- `iam/info` — IAM role information
- `iam/security-credentials/<role-name>` — Temporary credentials from the instance's IAM role
- `placement/availability-zone` — AZ the instance is in
- `hostname` — Private DNS hostname
- `mac` — MAC address of the primary ENI

### IMDSv1 vs IMDSv2

| Feature | IMDSv1 | IMDSv2 |
|---------|--------|--------|
| Request method | Simple HTTP GET | Session-oriented (PUT to get token, then GET with token) |
| Security | Vulnerable to SSRF attacks | Protected against SSRF (requires token header) |
| Default | Available by default | Must be explicitly required (or available alongside v1) |
| Hop limit | 1 (default) | Configurable (default 1 for instances, 2 for containers) |

**IMDSv2 workflow:**
```bash
# Step 1: Get a session token (PUT request with TTL)
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Step 2: Use the token in subsequent requests
curl -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/instance-id
```

**Why IMDSv2 is more secure:**
- The PUT request for the token has a TTL (max 6 hours / 21,600 seconds)
- Token cannot be forwarded through network layer firewalls (X-Forwarded-For headers are rejected)
- Token is tied to the specific instance
- Mitigates SSRF (Server-Side Request Forgery) attacks because an attacker cannot make PUT requests through most SSRF vectors

**Best practice:** Enforce IMDSv2 by setting `HttpTokens=required` in the instance metadata options. You can set this as an account-level default.

---

## Instance Store vs EBS

### Instance Store (Ephemeral Storage)

Instance store provides **temporary block-level storage** physically attached to the host machine.

| Feature | Detail |
|---------|--------|
| **Performance** | Very high IOPS (millions for NVMe). Lowest latency. |
| **Persistence** | **Ephemeral** — data lost on stop, terminate, or host failure |
| **Survives reboot** | Yes (data persists through reboot) |
| **Cost** | Included in instance price |
| **Size** | Depends on instance type (up to 60 TB on d3en.12xlarge) |
| **Attach/Detach** | Only at launch time. Cannot detach and reattach. |
| **Snapshots** | Not supported |
| **Encryption** | Some instance types support encryption at rest |

### When to Use Instance Store

- Buffer, cache, scratch data, temporary content
- Data replicated across a fleet (distributed databases)
- Highest possible I/O performance
- Any scenario where data can be regenerated

### When to Use EBS

- Data that must persist beyond instance lifecycle
- Databases
- Boot volumes
- Applications requiring snapshots or backups

---

## EC2 Networking

### Enhanced Networking

Enhanced Networking provides higher bandwidth, higher PPS, and lower latency using SR-IOV.

Two mechanisms:
1. **ENA (Elastic Network Adapter)**: Up to 100 Gbps. Used on modern instances.
2. **Intel 82599 VF**: Up to 10 Gbps. Legacy instances.

Requirements:
- Supported instance type
- Proper driver installed in the AMI
- HVM virtualization (not PV)

### Jumbo Frames

- Standard Ethernet frame: **1500 MTU** (Maximum Transmission Unit)
- Jumbo frames: **9001 MTU**
- Supported within a VPC (not over the internet or VPN)
- Reduces overhead for large data transfers
- Path MTU Discovery (PMTUD) must be enabled
- Cluster placement groups support jumbo frames
- Traffic outside the VPC (internet, VPN, VPC peering across regions) is limited to 1500 MTU

**Exam Tip**: Jumbo frames are beneficial for HPC, storage transfers, and database replication within a VPC.

---

## Auto Scaling Groups

Auto Scaling Groups (ASGs) automatically adjust the number of EC2 instances based on demand.

### Launch Templates vs Launch Configurations

| Feature | Launch Template | Launch Configuration |
|---------|----------------|---------------------|
| Versioning | Yes | No |
| Multiple instance types | Yes (mixed instances) | No (single type) |
| Spot + On-Demand mix | Yes | No |
| T2/T3 Unlimited | Yes | Yes |
| Placement groups | Yes | Yes |
| Dedicated Hosts | Yes | No |
| Elastic GPU | Yes | No |
| Status | **Recommended** | Legacy (being deprecated) |

**Always use Launch Templates** — they are the current best practice and offer all the features of Launch Configurations plus more.

### Scaling Policies

#### Target Tracking Scaling

- Set a target value for a specific metric
- ASG adjusts capacity to keep the metric close to the target
- Example: "Keep average CPU utilization at 50%"
- Simplest to configure
- Common metrics: `ASGAverageCPUUtilization`, `ASGAverageNetworkIn`, `ASGAverageNetworkOut`, `ALBRequestCountPerTarget`

#### Step Scaling

- Define scaling adjustments based on CloudWatch alarm thresholds
- Multiple steps for different alarm breach sizes
- Example: Add 1 instance when CPU > 60%, add 3 instances when CPU > 80%
- Better for workloads with sudden, large spikes
- Supports warm-up time per step

#### Simple Scaling

- Single scaling adjustment when a CloudWatch alarm is triggered
- Waits for cooldown period before allowing another scaling action
- Less flexible than step scaling
- **Not recommended** (use target tracking or step scaling instead)

#### Scheduled Scaling

- Scale based on a schedule (cron expression or one-time)
- Set min, max, or desired capacity at specific times
- Example: Scale up every Monday at 8 AM, scale down every Friday at 6 PM
- Ideal for predictable traffic patterns

#### Predictive Scaling

- Uses **machine learning** to forecast traffic and pre-scale
- Analyzes historical load patterns
- Creates scheduled scaling actions in advance (proactive)
- Works best with recurring patterns (daily, weekly)
- Can be used alongside other scaling policies
- Forecast mode (observation only) or Forecast and Scale mode

### Cooldown Period

- After a scaling activity completes, ASG waits for the cooldown period before allowing another scaling activity
- Default cooldown: **300 seconds** (5 minutes)
- Prevents rapid, unnecessary scaling actions
- Target tracking and step scaling have their own warm-up time that can replace cooldown

### Warm Pools

A warm pool is a set of **pre-initialized instances** that sit alongside the ASG and are ready to serve traffic quickly.

**States for warm pool instances:**
- **Stopped**: Instance is stopped (pay only for EBS volumes). Fastest to bring into service.
- **Running**: Instance is running (pay for compute). Faster warm-up but more expensive.
- **Hibernated**: Instance is hibernated (RAM saved to EBS). Good balance.

**Benefits:**
- Dramatically reduce scale-out latency
- Pre-initialized instances (already bootstrapped)
- Reduce costs by keeping warm pool instances in stopped/hibernated state

### Lifecycle Hooks

Lifecycle hooks let you perform custom actions as instances launch or terminate.

- **Launching (EC2_INSTANCE_LAUNCHING)**: Perform setup (install software, pull config) before the instance starts receiving traffic
- **Terminating (EC2_INSTANCE_TERMINATING)**: Perform cleanup (upload logs, deregister) before the instance is terminated
- Default timeout: **1 hour** (configurable up to 48 hours, or extended by heartbeat)
- Instance enters **Pending:Wait** or **Terminating:Wait** state
- Complete the hook by sending `complete-lifecycle-action` or let it time out

### Instance Refresh

Instance Refresh allows you to update all instances in an ASG to use a new launch template version or new configuration.

- **Minimum healthy percentage**: Percentage of instances that must remain healthy during refresh (default 90%)
- **Checkpoint**: Pause the refresh after a certain percentage is replaced (for validation)
- **Skip matching**: Skip instances that already match the desired configuration
- **Rollback**: Automatically roll back if CloudWatch alarms trigger

### Health Checks

ASG supports multiple health check types:
- **EC2 health checks**: Default. Only checks that the instance is running (not stopped/terminated).
- **ELB health checks**: Instance must pass the load balancer's health check
- **Custom health checks**: Use the `SetInstanceHealth` API

**Health check grace period**: Time after launch before health checks begin (default 300 seconds). Allows time for instance bootstrapping.

### Scaling Metrics and Best Practices

| Metric | When to Use |
|--------|-------------|
| CPU Utilization | General-purpose web servers |
| Request Count Per Target | Web applications behind ALB |
| Network In/Out | Network-bound applications |
| Custom metric (SQS queue depth) | Queue-processing applications |

**Best practices:**
- Use target tracking scaling for simplicity
- Use multiple metrics for accuracy
- Set appropriate cooldown/warm-up times
- Use lifecycle hooks for complex bootstrapping
- Enable health checks from ELB
- Use warm pools for applications with long startup times

---

## EC2 Image Builder

EC2 Image Builder automates the creation, maintenance, and deployment of customized and hardened machine images.

**Pipeline components:**
1. **Source Image**: Base AMI (Amazon Linux, Windows, etc.)
2. **Build Components**: Scripts/steps to install and configure software
3. **Test Components**: Validation tests to ensure the image works
4. **Distribution**: Where to distribute the resulting AMI (regions, accounts)

**Key features:**
- **Automated pipeline**: Runs on a schedule (e.g., weekly) or when components update
- **Version management**: Track image versions
- **Multi-region distribution**: Automatically copy AMIs to multiple regions
- **Cross-account distribution**: Share AMIs with other accounts via organizations or specific account IDs
- **OS support**: Linux and Windows
- **Output formats**: AMI, Docker container images
- **Free service**: Only pay for underlying resources (EC2 instances, EBS storage)
- **Security**: Integrates with Inspector for vulnerability scanning

**Exam Tip**: EC2 Image Builder is used to automate the creation and maintenance of golden AMIs. If the question asks about keeping AMIs up-to-date with security patches, Image Builder is the answer.

---

## Nitro System

The AWS Nitro System is the underlying platform for modern EC2 instances.

**Components:**
1. **Nitro Cards**: Dedicated cards for VPC networking, EBS, instance storage, and monitoring
2. **Nitro Security Chip**: Built into the motherboard. Provides hardware root of trust. Continuously monitors and protects firmware.
3. **Nitro Hypervisor**: Lightweight hypervisor (based on KVM). Offloads virtualization to Nitro cards. Allows near bare-metal performance.
4. **Nitro Enclaves**: Isolated compute environments for processing sensitive data. No persistent storage, no admin/operator access, no external networking.

**Benefits:**
- Higher performance (nearly all CPU/memory available to the instance)
- Better security (hardware-based)
- Faster innovation (new instance types)
- EBS encryption is always available (handled by Nitro cards)
- Enhanced networking handled by Nitro cards (not consuming host CPU)

**Nitro Enclaves:**
- Create isolated processing for highly sensitive data (PII, healthcare, financial)
- Runs in a separate, hardened virtual machine
- No SSH access, no persistent storage
- Uses cryptographic attestation to prove code identity
- Use cases: processing credit card numbers, private keys, healthcare data

---

## Burstable Instances & CPU Credits

### How Burstable (T-series) Instances Work

T-series instances (T2, T3, T3a, T4g) provide a **baseline** level of CPU performance with the ability to **burst** above the baseline.

**CPU Credit System:**
- Each T instance earns CPU credits at a steady rate (depends on instance size)
- **1 CPU credit = 1 vCPU running at 100% for 1 minute** (or 2 vCPUs at 50%, etc.)
- When CPU usage is below baseline, credits accumulate
- When CPU usage exceeds baseline, credits are consumed
- When credits are depleted, performance is throttled to baseline

**Baseline performance by instance type:**

| Instance | vCPUs | Baseline | Credits/hour | Max Credits |
|----------|-------|----------|-------------|-------------|
| t3.nano | 2 | 5% | 6 | 144 |
| t3.micro | 2 | 10% | 12 | 288 |
| t3.small | 2 | 20% | 24 | 576 |
| t3.medium | 2 | 20% | 24 | 576 |
| t3.large | 2 | 30% | 36 | 864 |
| t3.xlarge | 4 | 40% | 96 | 2304 |
| t3.2xlarge | 8 | 40% | 192 | 4608 |

### T2/T3 Unlimited Mode

- When credits are depleted, the instance can **continue bursting** beyond baseline
- You are charged for **surplus credits** at a small per-vCPU-hour fee
- T3/T3a/T4g: Unlimited mode is enabled by **default**
- T2: Unlimited mode must be explicitly enabled
- If average CPU over 24 hours stays below baseline, surplus credits are covered by earned credits (no extra charge)

**Exam Tip**: "Variable workload," "small database," "dev/test environment" with occasional CPU spikes → T-series. If consistently using more than baseline → switch to M-family (more cost-effective).

---

## Complete Pricing Comparison

### Purchasing Option Summary

| Option | Discount vs On-Demand | Commitment | Interruption Risk | Best For |
|--------|----------------------|------------|-------------------|----------|
| On-Demand | 0% | None | None | Short-term, unpredictable, testing |
| Reserved (Standard) | Up to 72% | 1 or 3 years | None | Steady-state, known instance type |
| Reserved (Convertible) | Up to 66% | 1 or 3 years | None | Steady-state, may change instance type |
| Compute Savings Plan | Up to 66% | 1 or 3 years | None | Flexible across families/regions/services |
| EC2 Instance Savings Plan | Up to 72% | 1 or 3 years | None | Committed to a family in a region |
| Spot | Up to 90% | None | **Yes** (2-min warning) | Fault-tolerant, flexible, batch |
| Dedicated Instance | ~Same as On-Demand | None | None | Hardware isolation, compliance |
| Dedicated Host | ~Same as On-Demand or Reserved | None or 1/3yr | None | BYOL, per-core licensing, compliance |
| Capacity Reservation | 0% (On-Demand price) | None | None | Guaranteed capacity in specific AZ |

### Cost Optimization Strategy (Exam Pattern)

1. **Baseline load** (always running): Reserved Instances or Savings Plans
2. **Predictable spikes**: Scheduled Scaling + On-Demand or pre-warmed instances
3. **Variable extra load**: On-Demand (if cannot be interrupted) or Spot (if fault-tolerant)
4. **Fault-tolerant batch processing**: Spot Instances
5. **Licensing compliance**: Dedicated Hosts

---

## Exam Tips & Scenarios

### Scenario 1: Persistent Database
**Q:** A company needs a database server running 24/7 for the next 3 years on an r5.2xlarge.
**A:** Standard Reserved Instance (3-year, All Upfront) for maximum savings.

### Scenario 2: Variable Web Application
**Q:** A web application has unpredictable traffic spikes. Instances must not be interrupted.
**A:** Auto Scaling Group with On-Demand instances + target tracking scaling policy.

### Scenario 3: Big Data Batch Processing
**Q:** A company runs nightly batch jobs that take 2-4 hours and can be restarted if interrupted.
**A:** Spot Instances (up to 90% savings, workload is fault-tolerant).

### Scenario 4: Licensing Compliance
**Q:** A company needs to run Oracle Database with per-core licensing requirements.
**A:** Dedicated Hosts (provides visibility into physical cores for licensing).

### Scenario 5: HPC Application
**Q:** A tightly-coupled HPC application requires lowest possible inter-node latency.
**A:** Cluster Placement Group + EFA + C5n/P4d instances.

### Scenario 6: Quick Recovery
**Q:** A long-running data processing instance needs to recover quickly after being stopped (preserving in-memory state).
**A:** EC2 Hibernate with encrypted EBS root volume.

### Scenario 7: Auto Scaling with Slow Bootstrap
**Q:** Instances take 10+ minutes to bootstrap. The ASG needs to scale quickly.
**A:** Warm Pools with pre-initialized instances (stopped or hibernated state).

### Scenario 8: Mixed Workloads Cost Optimization
**Q:** An ASG runs 10 instances minimum, bursts to 40. Need cost optimization.
**A:** 10 instances on Reserved/Savings Plans (baseline). Use mixed instances policy with Spot for scale-out capacity, On-Demand as fallback.

### Scenario 9: AMI Across Regions
**Q:** A company needs to launch instances from the same AMI in multiple regions.
**A:** Copy the AMI to each target region. Each copy creates new EBS snapshots in that region.

### Scenario 10: Preventing SSRF
**Q:** How to prevent SSRF attacks from stealing instance credentials?
**A:** Enforce IMDSv2 (`HttpTokens=required`). The token-based approach prevents forwarding of metadata requests.

### Key Exam Patterns

1. **Cost optimization** is the #1 tested concept for EC2 purchasing options
2. **Know the differences** between Reserved, Savings Plans, Spot, and Dedicated options
3. **Placement groups**: Cluster = low latency, Spread = high availability (max 7/AZ), Partition = big data topology
4. **ENI** = basic networking, **ENA** = enhanced networking (100G), **EFA** = HPC/MPI
5. **Instance store** = ephemeral, highest performance; **EBS** = persistent
6. **ASG scaling policies**: Target tracking is simplest and most common; Predictive for recurring patterns
7. **Warm Pools** reduce scale-out time for slow-booting instances
8. **IMDSv2** is the security best practice for instance metadata
9. **Hibernate** preserves RAM contents for fast resume
10. **Nitro Enclaves** for processing sensitive data in isolation

---

## Quick Reference: Instance Family Cheat Sheet

| Need | Family | Remember |
|------|--------|----------|
| Balanced | M | **M**edium / **M**ain |
| Burstable | T | **T**iny / **T**urbo (burst) |
| Compute | C | **C**ompute |
| Memory | R | **R**AM |
| Extreme Memory | X | e**X**tra memory |
| High Frequency | z1d | **z** = high fre**q**uency |
| Storage IOPS | I | **I**/O |
| Storage Throughput | D | **D**ense storage |
| GPU | P / G | **P**arallel / **G**raphics |
| FPGA | F | **F**PGA |
| ML Inference | Inf | **Inf**erence |
| ML Training | Trn | **Tr**ai**n**ing |

---

*Next Article: [Lambda & Serverless →](08-lambda-serverless.md)*
