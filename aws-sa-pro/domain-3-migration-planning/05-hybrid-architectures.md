# Hybrid Architectures — AWS SAP-C02 Domain 3 Deep Dive

## Table of Contents
1. [Hybrid Architecture Patterns](#1-hybrid-architecture-patterns)
2. [VMware Cloud on AWS](#2-vmware-cloud-on-aws)
3. [AWS Outposts](#3-aws-outposts)
4. [Local Zones and Wavelength Zones](#4-local-zones-and-wavelength-zones)
5. [ECS/EKS Anywhere](#5-ecseks-anywhere)
6. [Storage Hybrid Patterns](#6-storage-hybrid-patterns)
7. [Database Hybrid Patterns](#7-database-hybrid-patterns)
8. [Networking for Hybrid](#8-networking-for-hybrid)
9. [Identity for Hybrid](#9-identity-for-hybrid)
10. [Monitoring for Hybrid](#10-monitoring-for-hybrid)
11. [Hybrid DNS Patterns](#11-hybrid-dns-patterns)
12. [Exam Scenarios](#12-exam-scenarios)

---

## 1. Hybrid Architecture Patterns

### 1.1 Pattern: Extend to Cloud

**Use Case:** Keep core applications on-premises while extending to AWS for new workloads, dev/test, or elastic capacity.

```
On-Premises Data Center                    AWS Cloud
┌─────────────────────────┐    Direct    ┌─────────────────────┐
│  Core ERP (SAP)         │    Connect   │  New microservices  │
│  Database (Oracle)      │◄───────────▶ │  Data analytics     │
│  Active Directory       │    / VPN     │  Machine learning   │
│  Legacy applications    │              │  Dev/test environments│
│                         │              │  Web frontend        │
└─────────────────────────┘              └─────────────────────┘
```

### 1.2 Pattern: AWS as DR

**Use Case:** Maintain production on-premises with AWS as a disaster recovery site.

```
Primary (On-Premises)                   DR (AWS)
┌─────────────────────────┐           ┌─────────────────────────┐
│  Production workloads   │           │  Pilot Light:           │
│  ┌───────┐ ┌──────────┐ │           │  ┌───────────────────┐  │
│  │ App   │ │ Database │ │  Replctn  │  │ RDS Read Replica  │  │
│  │ Servers│ │ (Oracle) │ │──────────▶│  │ (standby)         │  │
│  └───────┘ └──────────┘ │           │  └───────────────────┘  │
│                         │  AMI sync │  ┌───────────────────┐  │
│                         │──────────▶│  │ AMIs (app servers) │  │
│                         │           │  │ (launch on demand) │  │
└─────────────────────────┘           │  └───────────────────┘  │
                                      └─────────────────────────┘
Route 53 failover routing ──▶ Switch to AWS on failure
```

### 1.3 Pattern: Cloud Bursting

**Use Case:** Run baseline workload on-premises, burst to AWS during peak demand.

```
Normal Load:                    Peak Load:
┌──────────────┐               ┌──────────────┐   ┌──────────────┐
│ On-Premises  │               │ On-Premises  │   │  AWS (burst) │
│ 10 servers   │               │ 10 servers   │ + │  20 servers  │
│ (baseline)   │               │ (baseline)   │   │  (temporary) │
└──────────────┘               └──────────────┘   └──────────────┘
     100% load                      33% load           67% load

Implementation:
- Auto Scaling group in AWS
- Custom metrics from on-prem push to CloudWatch
- Scale out trigger when on-prem reaches 80% capacity
- ELB distributes traffic to both on-prem and AWS
```

### 1.4 Pattern: Backup to Cloud

```
On-Premises                              AWS
┌──────────────────────┐              ┌──────────────┐
│  Production servers  │   AWS Backup │  S3 (backups)│
│  ┌──────┐ ┌───────┐ │──────────────▶│  S3 Glacier  │
│  │ Data │ │ VMs   │ │   DataSync   │  (archive)   │
│  └──────┘ └───────┘ │──────────────▶│              │
│  ┌──────────────┐   │   Storage GW │              │
│  │ File shares  │───┼──────────────▶│              │
│  └──────────────┘   │              └──────────────┘
└──────────────────────┘
```

### 1.5 Pattern Summary

| Pattern | On-Premises | AWS | Key Service |
|---|---|---|---|
| **Extend** | Core systems | New workloads | Direct Connect, VPN |
| **DR** | Production | Standby | DRS, Route 53 |
| **Burst** | Baseline | Peak overflow | Auto Scaling, ALB |
| **Backup** | Production | Backup storage | S3, Glacier, DataSync |
| **Hybrid Processing** | Data sources | Analytics/ML | Kinesis, S3, SageMaker |

---

## 2. VMware Cloud on AWS

### 2.1 Overview

VMware Cloud on AWS runs the VMware SDDC (Software-Defined Data Center) stack on dedicated AWS bare-metal infrastructure. Jointly engineered by VMware and AWS.

### 2.2 Architecture

```
┌───────────────────────────────────────────────────────────────┐
│                    VMware Cloud on AWS                          │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │  vCenter Server                                          │  │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐              │  │
│  │  │   VM 1   │  │   VM 2   │  │   VM 3   │   ...        │  │
│  │  └──────────┘  └──────────┘  └──────────┘              │  │
│  │                                                          │  │
│  │  NSX (Networking & Security)                             │  │
│  │  vSAN (Storage)                                          │  │
│  │  ESXi Hosts (i3.metal bare metal)                        │  │
│  └─────────────────────────────────────────────────────────┘  │
│                        │                                       │
│                   ENI (25 Gbps)                                │
│                        │                                       │
│  ┌─────────────────────▼───────────────────────────────────┐  │
│  │  Connected AWS VPC                                       │  │
│  │  ├── S3 (storage)                                        │  │
│  │  ├── RDS (databases)                                     │  │
│  │  ├── EFS (file storage)                                  │  │
│  │  ├── Lambda, ECS, etc.                                   │  │
│  │  └── Any AWS service                                     │  │
│  └─────────────────────────────────────────────────────────┘  │
└───────────────────────────────────────────────────────────────┘
```

### 2.3 SDDC Components

| Component | Description |
|---|---|
| **ESXi Hosts** | AWS bare-metal instances (i3.metal, i3en.metal, i4i.metal) |
| **vCenter** | Centralized management (same as on-prem) |
| **NSX-T** | Network virtualization, micro-segmentation, firewall |
| **vSAN** | Software-defined storage across hosts |
| **HCX** | Hybrid connectivity and migration tool |

### 2.4 Migration Methods

| Method | Downtime | Use Case |
|---|---|---|
| **vMotion (HCX)** | Zero | Single VM live migration |
| **Bulk Migration (HCX)** | Brief (reboot) | Multiple VMs, scheduled |
| **Cold Migration** | Extended | Powered-off VMs |
| **vSphere Replication** | Brief | Continuous replication + cutover |
| **MGN** | Brief | Migrate away from VMware to native EC2 |

### 2.5 Use Cases

1. **Data center evacuation:** Quick migration of VMware VMs to AWS
2. **Disaster recovery:** VMware Site Recovery on AWS
3. **Application modernization:** Gradually move VMs to native AWS services
4. **Development/test:** Spin up VMware environments on demand
5. **Capacity extension:** Burst VMware workloads to AWS

### 2.6 Pricing

- Minimum 2 hosts per SDDC (cluster)
- Per-host pricing (i3.metal: ~$8-10/hour on-demand)
- 1-year and 3-year reserved pricing available
- No charge for vCenter, NSX, vSAN software

> **Exam Tip:** VMware Cloud on AWS = "We have VMware and want to move to AWS quickly without changing anything." Key use cases: data center exit, disaster recovery, and hybrid operations.

---

## 3. AWS Outposts

### 3.1 Overview

AWS Outposts extends AWS infrastructure, services, APIs, and tools to virtually any on-premises facility. AWS-managed hardware installed in your data center.

### 3.2 Outposts Rack vs Outposts Server

| Feature | Outposts Rack | Outposts Server |
|---|---|---|
| **Form Factor** | Standard 42U rack | 1U or 2U server |
| **Capacity** | Up to 96 instances per rack | 1 server |
| **Storage** | EBS, S3 on Outposts | EBS only |
| **Services** | EC2, EBS, S3, ECS, EKS, RDS, EMR, etc. | EC2, EBS |
| **Networking** | Direct Connect or VPN to Region | Internet/VPN |
| **Management** | AWS manages (hardware, software, updates) | AWS manages |
| **Power** | 5-15 kW per rack | Standard server power |
| **Use Case** | Large on-premises AWS footprint | Small, remote, edge |
| **Space** | Data center with rack space | Any server room |
| **Minimum** | 1 rack (42U) | 1 server |

### 3.3 Architecture

```
AWS Region (us-east-1)
┌───────────────────────────────────────────────────────┐
│  Parent Region                                         │
│  ┌─────────────────┐  ┌────────────────────────────┐  │
│  │ Control Plane   │  │ VPC (connected to Outpost) │  │
│  │ (manages        │  │                            │  │
│  │  Outpost)       │  │  Subnet: 10.0.1.0/24      │  │
│  │                 │  │  (Region subnet)           │  │
│  └────────┬────────┘  │                            │  │
│           │           │  Subnet: 10.0.2.0/24      │  │
│           │           │  (Outpost subnet)          │  │
│           │           └────────────────────────────┘  │
└───────────┼───────────────────────────────────────────┘
            │  Service Link (encrypted)
            │  VPN or Direct Connect
            │
┌───────────▼───────────────────────────────────────────┐
│  Customer Data Center                                   │
│  ┌─────────────────────────────────────────────────┐   │
│  │  AWS Outposts Rack                               │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐      │   │
│  │  │  EC2     │  │   EBS    │  │  S3 on   │      │   │
│  │  │instances │  │ volumes  │  │ Outposts │      │   │
│  │  └──────────┘  └──────────┘  └──────────┘      │   │
│  │  ┌──────────┐  ┌──────────┐                     │   │
│  │  │  ECS     │  │  RDS     │                     │   │
│  │  │  tasks   │  │ instances│                     │   │
│  │  └──────────┘  └──────────┘                     │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
│  ┌──────────────────────────┐                          │
│  │  Local Gateway (LGW)     │──▶ On-premises network   │
│  │  (Local traffic routing) │    (low latency access)  │
│  └──────────────────────────┘                          │
└─────────────────────────────────────────────────────────┘
```

### 3.4 Networking

**Service Link:** Encrypted connection from Outposts to parent AWS Region
- Required for control plane operations
- Uses Direct Connect or internet VPN
- If Service Link is down: existing instances continue running, no new launches

**Local Gateway (LGW):** Routes traffic between Outpost and on-premises network
- Enables on-premises resources to access Outpost resources with low latency
- Supports static routes and BGP
- Critical for data residency use cases

### 3.5 Available Services on Outposts

| Service Category | Services |
|---|---|
| **Compute** | EC2 (various instance types), ECS, EKS |
| **Storage** | EBS (gp2, io1), S3 on Outposts |
| **Database** | RDS (MySQL, PostgreSQL, SQL Server), ElastiCache |
| **Analytics** | EMR |
| **Networking** | ALB, VPC, subnets |
| **Management** | Systems Manager, CloudWatch (agent) |

### 3.6 Use Cases

1. **Data residency:** Data must stay in specific location (compliance)
2. **Low latency:** Applications need <10ms latency to on-premises systems
3. **Local data processing:** Process data locally before sending to cloud
4. **Hybrid consistency:** Same APIs, tools, and infrastructure in both locations
5. **Manufacturing/retail:** Edge processing in factories or stores

> **Exam Tip:** Outposts = "Must use AWS services but data must stay on-premises" or "Need AWS API consistency with on-premises hardware." S3 on Outposts for data residency. Local Gateway for on-premises network integration.

---

## 4. Local Zones and Wavelength Zones

### 4.1 Local Zones

**What:** AWS infrastructure deployed in large metro areas, closer to end-users than the parent Region.

```
AWS Region (us-east-1, Virginia)
┌────────────────────────────┐
│  AZ-1a  AZ-1b  AZ-1c      │
│  (Full AWS services)       │
└────────────┬───────────────┘
             │ Low latency (1-2ms)
             │
┌────────────▼───────────────┐     ┌────────────────────────┐
│  Local Zone: us-east-1-bos │     │ Local Zone: us-east-1- │
│  (Boston)                   │     │ mia (Miami)            │
│  • EC2 instances            │     │ • EC2 instances         │
│  • EBS volumes              │     │ • EBS volumes           │
│  • ALB                      │     │ • ALB                   │
│  • VPC subnets              │     │ • VPC subnets           │
│                             │     │                         │
│  ~1-2ms to Boston users     │     │ ~1-2ms to Miami users  │
└─────────────────────────────┘     └────────────────────────┘
```

**Available Services:** EC2, EBS, ECS, EKS, VPC, ALB, NLB, Direct Connect, IAM, CloudWatch

**Use Cases:**
- Real-time gaming
- Live video streaming
- AR/VR applications
- Machine learning inference at the edge
- Media content creation (Hollywood studios)

### 4.2 Wavelength Zones

**What:** AWS infrastructure embedded within telecom providers' 5G networks for ultra-low latency mobile applications.

```
Mobile Device (5G)
      │
      │ 5G Radio
      ▼
┌──────────────────────┐
│ Telecom 5G Network   │
│  ┌────────────────┐  │
│  │ Wavelength Zone│  │
│  │ ┌────────────┐ │  │
│  │ │ EC2        │ │  │
│  │ │ instances  │ │  │      Single-digit ms
│  │ └────────────┘ │  │      to mobile users
│  └────────────────┘  │
└──────────┬───────────┘
           │ Carrier Gateway
           ▼
┌─────────────────────┐
│ AWS Region          │
│ (full services)     │
└─────────────────────┘
```

**Available Services:** EC2, EBS, VPC, ECS, EKS
**Carriers:** Verizon, Vodafone, KDDI, SK Telecom, Bell Canada

**Use Cases:**
- Connected vehicles
- Interactive live video streaming
- AR/VR on mobile
- Real-time gaming on mobile
- ML inference for mobile apps

### 4.3 Comparison Table

| Feature | Availability Zone | Local Zone | Wavelength Zone | Outposts |
|---|---|---|---|---|
| **Location** | AWS Region | Metro area | Telecom 5G | Your data center |
| **Managed by** | AWS | AWS | AWS + Telecom | AWS (in your DC) |
| **Latency target** | N/A | <10ms to metro | <10ms to 5G | <1ms on-premises |
| **Services** | All | Limited subset | Very limited | Limited subset |
| **Use case** | Standard cloud | City-level edge | Mobile edge | On-premises AWS |
| **Data residency** | AWS controls | AWS controls | AWS + Telecom | You control |

---

## 5. ECS/EKS Anywhere

### 5.1 ECS Anywhere

**What:** Run ECS tasks on your own on-premises infrastructure, managed by the ECS control plane in AWS.

```
AWS Region                              On-Premises
┌────────────────────────┐             ┌────────────────────────┐
│  ECS Control Plane     │             │  ECS Anywhere          │
│  (manages tasks,       │◄───────────▶│  ┌──────────────────┐  │
│   service discovery,   │  SSM Agent  │  │ Your servers     │  │
│   scheduling)          │             │  │ ┌──────┐ ┌──────┐│  │
│                        │             │  │ │Task 1│ │Task 2││  │
│  Same ECS APIs,        │             │  │ └──────┘ └──────┘│  │
│  same task definitions │             │  │ ECS Agent + SSM  │  │
│                        │             │  └──────────────────┘  │
└────────────────────────┘             └────────────────────────┘
```

**Setup:** Install SSM Agent + ECS Agent on on-premises servers, register as EXTERNAL launch type.

### 5.2 EKS Anywhere

**What:** Run Kubernetes clusters on your own infrastructure with EKS tooling and optional AWS management.

```
Deployment Options:
┌─────────────────────────────────────────────────────┐
│  EKS Anywhere (On-Premises)                          │
│                                                       │
│  Option 1: Standalone                                │
│  ┌─────────────────────────────────────┐            │
│  │  K8s Control Plane (on-prem)        │            │
│  │  Worker Nodes (on-prem)             │            │
│  │  No AWS dependency at runtime       │            │
│  └─────────────────────────────────────┘            │
│                                                       │
│  Option 2: Connected (EKS Connector)                 │
│  ┌─────────────────────────────────────┐            │
│  │  K8s Control Plane (on-prem)        │            │
│  │  Worker Nodes (on-prem)             │◄──────────▶│ AWS EKS Console
│  │  Visible in AWS EKS console         │  EKS       │ (monitoring)
│  └─────────────────────────────────────┘  Connector │
│                                                       │
│  Supported on: VMware vSphere, bare metal,           │
│  Cloudstack, Nutanix, Snow devices                   │
└─────────────────────────────────────────────────────┘
```

---

## 6. Storage Hybrid Patterns

### 6.1 AWS Storage Gateway

**What:** Hybrid cloud storage service providing on-premises access to virtually unlimited cloud storage.

**Three Gateway Types:**

```
Type 1: S3 File Gateway
On-Premises NFS/SMB clients ──▶ File Gateway ──▶ S3 (objects)
- Files stored as objects in S3
- Local cache for recent files (low latency)
- Supports S3 Standard, S3 IA, S3 One Zone-IA

Type 2: FSx File Gateway
On-Premises SMB clients ──▶ FSx File Gateway ──▶ FSx for Windows
- Windows file shares backed by FSx
- Local cache for frequently accessed files
- Active Directory integration

Type 3: Volume Gateway
├── Stored Volumes: Full data on-prem, async backup to S3 (EBS snapshots)
│   On-Premises ──▶ Volume GW ──▶ Local disks (primary) + S3 (backup)
│   
└── Cached Volumes: Full data in S3, cache of frequently accessed on-prem
    On-Premises ──▶ Volume GW ──▶ S3 (primary) + Local cache

Type 4: Tape Gateway
Backup Software ──▶ Tape Gateway (iSCSI) ──▶ S3 (Virtual Tape Library)
                                             ──▶ S3 Glacier (Tape Archive)
```

### 6.2 Storage Gateway Decision Matrix

| Requirement | Gateway Type | Why |
|---|---|---|
| NFS/SMB file share → S3 | S3 File Gateway | File interface, S3 backend |
| Windows file share → FSx | FSx File Gateway | SMB + AD + FSx |
| Block storage with cloud backup | Volume Gateway (Stored) | iSCSI, EBS snapshots |
| Cloud primary with local cache | Volume Gateway (Cached) | iSCSI, S3 backend |
| Tape backup replacement | Tape Gateway | iSCSI/VTL, S3/Glacier |

### 6.3 DataSync for Hybrid Storage

```
Ongoing Sync:
┌──────────────┐    DataSync Agent    ┌──────────────┐
│ On-Premises  │    (Scheduled sync)  │  AWS          │
│ NFS Server   │──────────────────────▶│  S3 / EFS    │
│              │    Incremental only  │  FSx          │
│ 100 TB data  │    (changed files)   │              │
└──────────────┘                      └──────────────┘

Schedule: Every 6 hours, sync only changed files
Bandwidth: Throttled to 500 Mbps (leave bandwidth for production)
```

### 6.4 Hybrid Storage Architecture Example

```
On-Premises                                    AWS
┌──────────────────────────────┐    ┌──────────────────────────┐
│                              │    │                          │
│  App Servers ──▶ S3 File GW ─┼───▶│ S3 (unlimited storage)  │
│               (hot cache)    │    │    │                      │
│                              │    │    ├── S3 Standard       │
│  Backup SW ──▶ Tape Gateway ─┼───▶│    ├── S3 Glacier       │
│               (VTL)          │    │    └── S3 Deep Archive   │
│                              │    │                          │
│  Block Apps ──▶ Volume GW ───┼───▶│ EBS Snapshots           │
│               (iSCSI)        │    │ (disaster recovery)     │
│                              │    │                          │
│  File Sync ──▶ DataSync ─────┼───▶│ EFS / FSx               │
│               (bulk + sync)  │    │ (for cloud workloads)   │
│                              │    │                          │
└──────────────────────────────┘    └──────────────────────────┘
             Direct Connect / VPN
```

> **Exam Tip:** Storage Gateway = on-premises apps need access to cloud storage with local caching. DataSync = bulk or recurring data transfer. Key difference: Storage Gateway provides ongoing transparent access; DataSync is for transfers/sync operations.

---

## 7. Database Hybrid Patterns

### 7.1 RDS on Outposts

```
Customer Data Center                        AWS Region
┌─────────────────────────────────┐       ┌──────────────────┐
│  AWS Outposts                    │       │  RDS Control     │
│  ┌───────────────────────────┐  │       │  Plane           │
│  │  RDS on Outposts          │  │       │  (manages        │
│  │  ┌─────────────────────┐  │  │◀─────▶│   instance)      │
│  │  │ MySQL / PostgreSQL  │  │  │       │                  │
│  │  │ / SQL Server        │  │  │       │  Automated       │
│  │  │                     │  │  │       │  backups → S3    │
│  │  │ Multi-AZ: Local     │  │  │       │  in Region       │
│  │  │ (within Outpost)    │  │  │       │                  │
│  │  └─────────────────────┘  │  │       └──────────────────┘
│  └───────────────────────────┘  │
│                                  │
│  On-Premises App ──▶ RDS (LGW)  │ ← Low latency via Local Gateway
└─────────────────────────────────┘
```

### 7.2 Read Replicas in Cloud

```
On-Premises (Primary)                     AWS (Read Replicas)
┌──────────────────────┐                ┌──────────────────────┐
│  MySQL Primary       │  Async         │  Aurora MySQL         │
│  (write traffic)     │──Replication──▶│  Read Replica        │
│                      │                │  (analytics,          │
└──────────────────────┘                │   reporting,          │
                                        │   read-heavy apps)   │
                                        └──────────────────────┘

Use Cases:
- Analytics queries on cloud replica (no impact on production)
- Geographic read distribution
- Gradual migration path (promote replica when ready)
```

### 7.3 DynamoDB Global Tables for Hybrid

```
Region 1 (Primary)              Region 2 (DR/Read)
┌──────────────────┐           ┌──────────────────┐
│  DynamoDB        │           │  DynamoDB        │
│  Global Table    │◄─────────▶│  Global Table    │
│  (active writes) │  Multi-   │  (active reads   │
│                  │  master   │   or writes)     │
└──────────────────┘  replictn └──────────────────┘

On-Premises App ──▶ API Gateway ──▶ Lambda ──▶ DynamoDB
(via Direct Connect)
```

---

## 8. Networking for Hybrid

### 8.1 AWS Direct Connect

```
On-Premises                  Direct Connect Location       AWS
┌───────────┐              ┌───────────────────┐        ┌──────────┐
│ Customer  │   Last Mile  │  Colocation       │        │  AWS     │
│ Router    │──────────────│  Facility         │        │  Region  │
│           │              │  ┌─────────────┐  │        │          │
│           │              │  │ AWS Direct  │  │ AWS    │  VPC     │
│           │              │  │ Connect     │──┤ Backbne│  │       │
│           │              │  │ Router      │  │        │  VGW /   │
│           │              │  └─────────────┘  │        │  DXGW /  │
│           │              │                   │        │  TGW     │
└───────────┘              └───────────────────┘        └──────────┘

Connection Speeds: 1 Gbps, 10 Gbps (dedicated)
                   50 Mbps - 10 Gbps (hosted via partner)
```

**Virtual Interfaces (VIFs):**

| VIF Type | Purpose | Connects To |
|---|---|---|
| **Private VIF** | Access VPC resources (private IPs) | VGW or Direct Connect Gateway |
| **Public VIF** | Access AWS public services (S3, DynamoDB, etc.) | AWS public endpoints |
| **Transit VIF** | Access multiple VPCs via Transit Gateway | Transit Gateway |

### 8.2 Direct Connect Gateway

```
                    ┌──────────────────────┐
                    │ Direct Connect       │
On-Premises ──DX──▶│ Gateway              │
                    │                      │
                    │  ├──▶ VPC 1 (us-east-1)  via VGW
                    │  ├──▶ VPC 2 (us-west-2)  via VGW
                    │  └──▶ VPC 3 (eu-west-1)  via VGW
                    └──────────────────────┘

One Direct Connect → Access VPCs in multiple regions
```

### 8.3 Hybrid with Transit Gateway

```
┌──────────────────────────────────────────────────────────────┐
│                    Transit Gateway                             │
│                                                                │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌──────────────┐   │
│  │  VPC A  │  │  VPC B  │  │  VPC C  │  │ Direct       │   │
│  │         │  │         │  │         │  │ Connect GW   │   │
│  └─────────┘  └─────────┘  └─────────┘  └──────┬───────┘   │
│                                                  │           │
└──────────────────────────────────────────────────┼───────────┘
                                                   │
                                          ┌────────▼─────────┐
                                          │  On-Premises     │
                                          │  (via DX)        │
                                          └──────────────────┘

Transit Gateway = hub for all VPC-to-VPC and VPC-to-on-premises routing
Supports: VPC attachments, VPN attachments, Direct Connect Gateway, peering
```

### 8.4 VPN Options

| Option | Bandwidth | Latency | Cost | Encryption | Setup Time |
|---|---|---|---|---|---|
| **Site-to-Site VPN** | ~1.25 Gbps per tunnel | Variable (internet) | Low | IPSec | Hours |
| **Accelerated VPN** | ~1.25 Gbps per tunnel | Lower (Global Accelerator) | Medium | IPSec | Hours |
| **Direct Connect** | 1/10/100 Gbps | Consistent, low | High | Optional (MACsec) | Weeks-months |
| **DX + VPN** | DX bandwidth | Consistent + encrypted | Highest | IPSec over DX | Weeks |

### 8.5 High Availability Networking

```
Recommended: Redundant Direct Connect + VPN Backup

On-Premises
┌─────────────┐
│ Router A    │──── DX Connection 1 ────▶ DX Location A ──▶ AWS (Primary)
│             │
│ Router B    │──── DX Connection 2 ────▶ DX Location B ──▶ AWS (Backup DX)
│             │
│ Router C    │──── Site-to-Site VPN ───▶ Internet ────────▶ AWS (VPN Backup)
└─────────────┘

Failover order:
1. DX Connection 1 (primary, lowest latency)
2. DX Connection 2 (backup DX, same performance)
3. VPN (last resort, encrypted over internet)
```

---

## 9. Identity for Hybrid

### 9.1 Active Directory Integration

```
Pattern 1: AWS Managed Microsoft AD
┌──────────────────┐     Trust     ┌──────────────────┐
│ On-Premises AD   │◄─────────────▶│ AWS Managed AD   │
│ (forest: corp.   │  Two-way      │ (forest: aws.    │
│  example.com)    │  forest trust │  corp.example.com)│
└──────────────────┘               └──────────────────┘

Pattern 2: AD Connector (Proxy)
┌──────────────────┐               ┌──────────────────┐
│ On-Premises AD   │◄──────────────│ AD Connector     │
│ (all users)      │  Forwards     │ (proxy, no cache)│
│                  │  auth requests│ Redirects to     │
│                  │  via VPN/DX   │ on-prem AD       │
└──────────────────┘               └──────────────────┘

Pattern 3: Self-Managed AD on EC2
┌──────────────────┐  Replication  ┌──────────────────┐
│ On-Premises AD   │◄─────────────▶│ AD Domain        │
│ (DC1, DC2)       │               │ Controller on EC2│
│                  │               │ (DC3, DC4)       │
└──────────────────┘               └──────────────────┘
```

### 9.2 Federation Patterns

**SAML 2.0 Federation:**
```
User ──▶ Corporate IdP (ADFS) ──▶ AWS STS (AssumeRoleWithSAML) ──▶ AWS Resources
```

**IAM Identity Center (SSO):**
```
User ──▶ IAM Identity Center ──▶ Connected to:
         │                        ├── AWS Managed AD
         │                        ├── External IdP (Okta, Azure AD)
         │                        └── Identity Center directory
         │
         └──▶ Permission Sets → Multiple AWS accounts
```

### 9.3 Identity Decision Matrix

| Requirement | Solution |
|---|---|
| AWS workloads need AD | AWS Managed Microsoft AD |
| Redirect auth to on-prem AD | AD Connector |
| Full AD replica in AWS | Self-managed AD on EC2 |
| SSO to multiple AWS accounts | IAM Identity Center |
| Federated access (SAML) | IAM Identity Provider + STS |
| Temporary credentials | STS AssumeRole |

---

## 10. Monitoring for Hybrid

### 10.1 CloudWatch Agent on On-Premises

```
On-Premises Servers                       AWS
┌─────────────────────────┐            ┌──────────────────┐
│  Server 1               │            │  CloudWatch      │
│  ┌─────────────────┐   │  HTTPS     │  ┌────────────┐  │
│  │ CloudWatch Agent│───┼────────────▶│  │ Metrics    │  │
│  │ - CPU, Memory   │   │            │  │ Logs       │  │
│  │ - Disk, Network │   │            │  │ Dashboards │  │
│  │ - Custom metrics│   │            │  │ Alarms     │  │
│  │ - Log files     │   │            │  └────────────┘  │
│  └─────────────────┘   │            └──────────────────┘
│                         │
│  Server 2               │            ┌──────────────────┐
│  ┌─────────────────┐   │            │  Systems Manager │
│  │ SSM Agent       │───┼────────────▶│  ┌────────────┐  │
│  │ - Inventory     │   │            │  │ Inventory  │  │
│  │ - Patching      │   │            │  │ Compliance │  │
│  │ - Run Command   │   │            │  │ Automation │  │
│  └─────────────────┘   │            │  └────────────┘  │
└─────────────────────────┘            └──────────────────┘
```

### 10.2 Systems Manager for Hybrid

**Hybrid Activations:**
1. Create hybrid activation in Systems Manager
2. Install SSM Agent on on-premises servers
3. Register with activation code + ID
4. Servers appear as managed instances (prefix `mi-`)

**Available capabilities on hybrid instances:**
- Run Command
- Patch Manager
- State Manager
- Inventory
- Session Manager (remote shell)
- Compliance
- Distributor (package installation)

### 10.3 Unified Monitoring Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                 Unified Monitoring Dashboard                   │
│                 (CloudWatch + Grafana)                        │
├────────────────────┬────────────────────┬────────────────────┤
│  On-Premises       │  AWS Cloud          │  Edge (Outposts)  │
│  ┌──────────────┐  │  ┌──────────────┐  │  ┌──────────────┐│
│  │CW Agent      │  │  │CW native     │  │  │CW Agent      ││
│  │SSM Agent     │  │  │metrics       │  │  │SSM Agent     ││
│  │Prometheus    │  │  │X-Ray traces  │  │  │              ││
│  │exporters     │  │  │VPC Flow Logs │  │  │              ││
│  └──────┬───────┘  │  └──────┬───────┘  │  └──────┬───────┘│
│         │          │         │          │         │         │
└─────────┼──────────┴─────────┼──────────┴─────────┼─────────┘
          │                    │                    │
          ▼                    ▼                    ▼
   ┌──────────────────────────────────────────────────────┐
   │  Amazon Managed Grafana                               │
   │  (Cross-source dashboards)                            │
   │  Data Sources: CloudWatch, Prometheus, X-Ray          │
   └──────────────────────────────────────────────────────┘
```

---

## 11. Hybrid DNS Patterns

### 11.1 DNS Resolution: On-Premises ↔ AWS

```
Pattern: Route 53 Resolver Endpoints

AWS VPC                                    On-Premises
┌──────────────────────────────────┐     ┌────────────────────┐
│                                  │     │                    │
│  Route 53 Resolver               │     │  Corporate DNS     │
│  ┌────────────────────────────┐  │     │  (e.g., BIND)     │
│  │ Inbound Endpoint           │  │     │                    │
│  │ (on-prem → AWS resolution) │◀─┼─────│  Forward .aws.corp │
│  │ 10.0.1.10, 10.0.1.11      │  │     │  queries to Route  │
│  └────────────────────────────┘  │     │  53 Inbound EP     │
│                                  │     │                    │
│  ┌────────────────────────────┐  │     │                    │
│  │ Outbound Endpoint          │  │     │                    │
│  │ (AWS → on-prem resolution) │──┼────▶│  Resolve .corp.    │
│  │ 10.0.2.10, 10.0.2.11      │  │     │  example.com       │
│  └────────────────────────────┘  │     │  from on-prem DNS  │
│                                  │     │                    │
│  Resolver Rules:                 │     │                    │
│  *.corp.example.com → Outbound   │     │                    │
│  (forward to on-prem DNS)        │     │                    │
└──────────────────────────────────┘     └────────────────────┘
```

### 11.2 Resolver Rule Types

| Rule Type | Purpose |
|---|---|
| **Forward** | Forward queries to specific DNS servers (on-prem) |
| **System** | Use Route 53 Resolver default behavior |
| **Recursive** | Route 53 acts as recursive resolver |

### 11.3 Shared Resolver Rules via RAM

```
┌────────────────────────────────────────────────┐
│  Organization (AWS RAM sharing)                 │
│                                                 │
│  Account A (Network/Shared Services)            │
│  ├── Route 53 Resolver Endpoints (shared)       │
│  ├── Resolver Rules (shared via RAM)            │
│  │   ├── *.corp.example.com → on-prem DNS      │
│  │   └── *.internal.local → on-prem DNS        │
│  │                                              │
│  Account B (Workload) ← uses shared rules       │
│  Account C (Workload) ← uses shared rules       │
│  Account D (Workload) ← uses shared rules       │
└────────────────────────────────────────────────┘
```

> **Exam Tip:** Route 53 Resolver Inbound Endpoint = on-premises resolving AWS private hosted zone records. Outbound Endpoint = AWS resolving on-premises DNS records. Both are needed for bidirectional hybrid DNS.

---

## 12. Exam Scenarios

### Scenario 1: Data Residency Requirement

**Question:** A company must process financial data that cannot leave their data center due to regulatory requirements. They want to use AWS services (EC2, S3, ECS) with the same APIs and tools. What solution?

**Answer:** **AWS Outposts Rack** with S3 on Outposts

**Reasoning:**
- Data must stay on-premises → Outposts installed in their data center
- S3 on Outposts → data stored locally
- Same AWS APIs (EC2, S3, ECS) → consistent developer experience
- Local Gateway → low-latency access from on-premises apps

---

### Scenario 2: VMware Migration

**Question:** A company has 2,000 VMware VMs and wants to move to AWS quickly. They have significant investment in VMware tooling (vCenter, NSX, vSAN) and want to maintain their operational model during transition. What approach?

**Answer:** **VMware Cloud on AWS** with HCX for migration

**Steps:**
1. Deploy VMware Cloud on AWS SDDC (minimum 2 hosts)
2. Configure HCX for hybrid connectivity
3. Use vMotion for zero-downtime VM migration
4. Maintain vCenter management for ops team
5. Over time, selectively modernize to native AWS services

---

### Scenario 3: Hybrid DNS

**Question:** A company has on-premises applications that need to resolve AWS private hosted zone names, and AWS applications that need to resolve on-premises Active Directory DNS records. How to configure DNS?

**Answer:** **Route 53 Resolver with Inbound and Outbound Endpoints**

**Configuration:**
1. Create Route 53 **Inbound Endpoint** in VPC (receives queries from on-premises)
2. Configure on-premises DNS to forward `*.aws.company.com` to inbound endpoint IPs
3. Create Route 53 **Outbound Endpoint** in VPC (sends queries to on-premises)
4. Create Resolver **Forward Rule**: `*.corp.company.com` → on-premises DNS server IPs
5. Result: Bidirectional DNS resolution

---

### Scenario 4: Low-Latency Edge Application

**Question:** A company is building a real-time multiplayer game that needs single-digit millisecond latency for users in New York City. They want to use EC2 instances close to end-users. What option?

**Answer:** **AWS Local Zone** (us-east-1-nyc)

**Reasoning:**
- New York City has an AWS Local Zone
- <10ms latency to NYC users
- EC2 instances in Local Zone for game servers
- VPC subnet extends from parent region to Local Zone
- Back-end services (database, matchmaking) in parent region

---

### Scenario 5: Hybrid Storage

**Question:** A company has 500 TB of file data on NFS shares. Applications need local access with low latency. They want to extend storage to AWS for capacity and backup. They also need to run analytics on the data in AWS. What solution?

**Answer:** **AWS Storage Gateway (S3 File Gateway)** + **DataSync** for initial migration

**Architecture:**
1. **DataSync** — Bulk initial copy of 500 TB to S3
2. **S3 File Gateway** — Deployed on-premises, presents NFS interface
3. Gateway caches frequently accessed files locally (low latency)
4. All data stored in S3 (unlimited capacity)
5. Analytics: Athena, Glue, Redshift Spectrum query data directly in S3
6. Lifecycle policy: Archive old data to S3 Glacier

---

### Scenario 6: High Availability Hybrid Connectivity

**Question:** A company requires 99.99% availability for connectivity between on-premises and AWS. What network architecture?

**Answer:** **Dual Direct Connect connections at two different DX locations** + **VPN backup**

**Architecture:**
1. DX Connection 1: 10 Gbps at DX Location A
2. DX Connection 2: 10 Gbps at DX Location B (different facility)
3. Both connect via Direct Connect Gateway to Transit Gateway
4. Site-to-Site VPN as tertiary backup (over internet)
5. BGP routing with preference: DX1 > DX2 > VPN
6. This achieves maximum resiliency per AWS DX SLA

---

> **Key Exam Tips Summary:**
> 1. **Outposts** = AWS infrastructure in your data center (data residency, low latency)
> 2. **VMware Cloud on AWS** = Quick migration for VMware estates, maintain VMware ops model
> 3. **Local Zones** = Low latency in specific cities (not on-premises)
> 4. **Wavelength** = Ultra-low latency for 5G mobile applications
> 5. **Storage Gateway** = On-premises access to cloud storage (caching + tiering)
> 6. **Direct Connect** = Consistent, low-latency connectivity (not encrypted by default)
> 7. **DX + VPN** = DX with encryption
> 8. **Route 53 Resolver** = Inbound EP (on-prem → AWS DNS), Outbound EP (AWS → on-prem DNS)
> 9. **AD Connector** = Proxy to on-prem AD (no caching)
> 10. **AWS Managed AD** = Full AD in AWS (trust with on-prem)
> 11. **ECS/EKS Anywhere** = Run containers on-premises with AWS control plane
> 12. **Systems Manager** = Manage on-premises servers (hybrid activation, SSM agent)
