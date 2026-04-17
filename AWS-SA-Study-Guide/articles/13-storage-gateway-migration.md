# Storage Gateway & Data Migration

## Table of Contents

1. [AWS Storage Gateway Overview](#aws-storage-gateway-overview)
2. [S3 File Gateway](#s3-file-gateway)
3. [FSx File Gateway](#fsx-file-gateway)
4. [Volume Gateway](#volume-gateway)
5. [Tape Gateway](#tape-gateway)
6. [Storage Gateway Decision Tree](#storage-gateway-decision-tree)
7. [Storage Gateway Deployment Options](#storage-gateway-deployment-options)
8. [AWS DataSync](#aws-datasync)
9. [DataSync vs Storage Gateway](#datasync-vs-storage-gateway)
10. [AWS Transfer Family](#aws-transfer-family)
11. [Snow Family](#snow-family)
12. [AWS Backup](#aws-backup)
13. [Migration Strategies: The 7 Rs](#migration-strategies-the-7-rs)
14. [Application Discovery Service](#application-discovery-service)
15. [Application Migration Service (MGN)](#application-migration-service-mgn)
16. [Database Migration Service (DMS)](#database-migration-service-dms)
17. [Exam Tips & Scenarios](#exam-tips--scenarios)

---

## AWS Storage Gateway Overview

AWS Storage Gateway is a **hybrid cloud storage service** that connects on-premises environments to AWS cloud storage. It provides seamless integration between your on-premises IT environment and AWS storage infrastructure.

### Why Storage Gateway?

- Bridge between on-premises data and cloud storage
- Low-latency local access with cloud-backed storage
- Disaster recovery and backup to AWS
- Tiering infrequently accessed data to the cloud
- Gradual migration from on-premises to cloud

### Gateway Types

| Type | Protocol | Backend Storage | Primary Use Case |
|------|----------|----------------|-----------------|
| **S3 File Gateway** | NFS, SMB | S3 (all classes except Glacier) | Cloud-backed file shares |
| **FSx File Gateway** | SMB | FSx for Windows File Server | Windows file share caching |
| **Volume Gateway — Cached** | iSCSI | S3 + EBS snapshots | Extend on-premises storage |
| **Volume Gateway — Stored** | iSCSI | Local + S3 (async backup) | Low-latency block storage |
| **Tape Gateway** | iSCSI VTL | S3 Glacier / Deep Archive | Backup/archive (tape replacement) |

---

## S3 File Gateway

S3 File Gateway presents a **file interface** (NFS/SMB) to on-premises applications while storing files as **objects in S3**.

### How It Works

```
On-Premises Servers → (NFS/SMB) → S3 File Gateway → (HTTPS) → Amazon S3
                                    [Local Cache]
```

1. On-premises applications read/write files using NFS or SMB
2. The gateway translates file operations to S3 API calls
3. Files are stored as objects in an S3 bucket
4. A local cache on the gateway stores recently accessed data for low-latency access
5. Most recently used data is cached locally; full dataset is in S3

### Key Features

| Feature | Detail |
|---------|--------|
| **Protocols** | NFS v3/v4.1, SMB v2/v3 |
| **Backend** | Amazon S3 (Standard, Standard-IA, One Zone-IA, Intelligent-Tiering) |
| **Local cache** | Yes — frequently accessed data for low-latency reads |
| **Lifecycle** | Use S3 lifecycle rules to tier objects to Glacier (gateway sees archived objects but cannot read them directly) |
| **Notification** | Use S3 event notifications, Lambda triggers, etc. on uploaded objects |
| **Authentication** | NFS: no auth / SMB: Active Directory integration |
| **Encryption** | In transit (HTTPS), at rest (SSE-S3, SSE-KMS) |
| **Refresh cache** | `RefreshCache` API to pick up changes made directly in S3 |

### How Files Map to Objects

- File path becomes the S3 object key: `/share/folder/file.txt` → `folder/file.txt` in the bucket
- File metadata (permissions, timestamps) stored as S3 object metadata
- Each file is one S3 object (no splitting/combining)

### Use Cases

- Replace on-premises NAS with cloud-backed storage
- Migrate file data to S3 incrementally
- Use S3-native features (analytics, ML) on files created by on-premises apps
- Cloud-backed file shares for distributed offices
- Data lake ingestion from on-premises file systems

**Exam Tip**: "NFS/SMB access to S3," "on-premises file share backed by cloud" → S3 File Gateway.

---

## FSx File Gateway

FSx File Gateway provides a **local cache** for an Amazon FSx for Windows File Server file system.

### How It Works

```
On-Premises Windows Servers → (SMB) → FSx File Gateway → (SMB) → FSx for Windows File Server
                                        [Local Cache]
```

1. Windows clients connect to the FSx File Gateway via SMB
2. Frequently accessed data is cached locally on the gateway
3. The gateway keeps data synchronized with the FSx file system in AWS
4. FSx for Windows provides the authoritative file system

### Key Features

| Feature | Detail |
|---------|--------|
| **Protocol** | SMB only |
| **Backend** | FSx for Windows File Server |
| **Local cache** | Yes — low-latency access to frequently used files |
| **Active Directory** | Yes — joins the same AD domain as FSx |
| **DFS Namespaces** | Supports DFS for unified namespace |
| **Encryption** | In transit and at rest |

### When to Use FSx File Gateway vs S3 File Gateway

| Factor | S3 File Gateway | FSx File Gateway |
|--------|----------------|-----------------|
| Backend | S3 (object storage) | FSx Windows (file storage) |
| Protocol | NFS + SMB | SMB only |
| Windows features | Basic SMB | Full Windows (ACLs, AD, DFS, dedup) |
| Data format | Objects in S3 | Files in FSx (NTFS) |
| Use case | General cloud storage | Windows native file access |

**Exam Tip**: "On-premises Windows file server," "local cache for FSx," "Active Directory," "SMB with low-latency" → FSx File Gateway.

---

## Volume Gateway

Volume Gateway provides **block storage** volumes (iSCSI) to on-premises applications, backed by S3 and EBS snapshots.

### Stored Volumes

```
On-Premises App → (iSCSI) → Volume Gateway (Stored Mode)
                                ├── Local Storage: Full data set (1-16 TiB per volume)
                                └── Async Backup: Point-in-time snapshots → S3 → EBS Snapshots
```

**How it works:**
- **Complete data set** is stored locally on-premises
- Data is asynchronously backed up to S3 as EBS snapshots
- Low-latency access to the entire dataset (data is local)
- Snapshots can be used to create EBS volumes in AWS

**Key details:**
- Volume size: 1 GiB to 16 TiB
- Up to 32 volumes per gateway
- Total storage: Up to 512 TiB per gateway
- Snapshots stored in S3 (managed by AWS, not visible in your S3 console)

**Use cases:**
- Primary storage is on-premises with cloud backup
- Disaster recovery (restore from snapshots to EC2)
- Low-latency access to full dataset

### Cached Volumes

```
On-Premises App → (iSCSI) → Volume Gateway (Cached Mode)
                                ├── Local Cache: Frequently accessed data
                                └── Primary Storage: Amazon S3 (full data set)
```

**How it works:**
- **Full data set** is stored in S3
- **Only frequently accessed data** is cached locally
- Extends on-premises storage using S3 as primary storage
- Local cache provides low-latency access to hot data

**Key details:**
- Volume size: 1 GiB to 32 TiB
- Up to 32 volumes per gateway
- Total storage: Up to 1 PiB per gateway (32 × 32 TiB)
- Cache size should be ~20% of the data set + 20% upload buffer

**Use cases:**
- Extend storage capacity without adding on-premises hardware
- Primary storage in cloud with local caching
- Frequently accessed data needs low-latency access

### Stored vs Cached Comparison

| Feature | Stored Volumes | Cached Volumes |
|---------|---------------|----------------|
| Primary data location | On-premises | S3 (cloud) |
| Local data | Complete dataset | Frequently accessed only |
| Max volume size | 16 TiB | 32 TiB |
| Max total storage | 512 TiB | 1 PiB |
| Latency | Lowest (all data local) | Low for cached data, higher for cold |
| On-premises storage needed | Full dataset size | ~20% of dataset |
| Data durability | Depends on local storage + S3 backup | S3 durability (11 nines) |
| Best for | Full local access, DR | Extending capacity, most data in cloud |

### EBS Snapshots from Volume Gateway

- Both modes create EBS snapshots stored in S3
- Snapshots can be used to:
  - Restore data on-premises (attach to gateway)
  - Create EBS volumes in AWS (for EC2)
  - Create a new Volume Gateway from snapshots (for DR)
- Snapshots are incremental
- Schedule snapshots at regular intervals

---

## Tape Gateway

Tape Gateway replaces physical tape infrastructure with a **virtual tape library (VTL)** backed by S3 and Glacier.

### How It Works

```
Backup Software → (iSCSI VTL) → Tape Gateway → Amazon S3 (Virtual Tape Library)
                                                      ↓ (Archive)
                                               S3 Glacier / Glacier Deep Archive
                                               (Virtual Tape Shelf)
```

1. Backup software (Veeam, Veritas NetBackup, Commvault, etc.) connects to the Tape Gateway via iSCSI
2. The gateway presents a virtual tape library (VTL) — tape drives, media changer
3. Backup software writes to virtual tapes
4. Virtual tapes are stored in S3 (up to 5 TiB per tape)
5. Eject/archive tapes to S3 Glacier or Glacier Deep Archive (Virtual Tape Shelf)

### Key Details

| Feature | Detail |
|---------|--------|
| **Protocol** | iSCSI (compatible with most backup software) |
| **Virtual tape size** | 100 GiB to 5 TiB |
| **Library size** | Up to 1,500 virtual tapes (1 PB total) |
| **Archive tier** | S3 Glacier Flexible Retrieval or S3 Glacier Deep Archive |
| **Retrieval time** | Glacier: 3-5 hours, Deep Archive: 12 hours |
| **Encryption** | In transit and at rest |
| **Compression** | Data is compressed before upload |

### Use Cases

- Replace physical tape backup with cloud-based virtual tapes
- Long-term data retention and archival
- Regulatory compliance requiring tape-based backup procedures
- Cost reduction (eliminate tape library hardware, maintenance, off-site storage)

**Exam Tip**: "Tape backup," "virtual tape library," "VTL," "backup software," "archive to Glacier" → Tape Gateway.

---

## Storage Gateway Decision Tree

Use this decision tree to determine the correct Storage Gateway type:

```
Need on-premises access to AWS storage?
│
├── File access (NFS/SMB)?
│   ├── Need S3 as backend?
│   │   └── S3 File Gateway
│   └── Need FSx Windows as backend (Windows/AD)?
│       └── FSx File Gateway
│
├── Block access (iSCSI)?
│   ├── Need complete data locally?
│   │   └── Volume Gateway — Stored
│   └── Need to extend storage capacity (cache frequently accessed)?
│       └── Volume Gateway — Cached
│
└── Tape replacement?
    └── Tape Gateway
```

### Quick Reference

| Requirement | Gateway Type |
|------------|-------------|
| File shares backed by S3 (NFS or SMB) | S3 File Gateway |
| Windows file shares with local cache (SMB/AD) | FSx File Gateway |
| Block storage — all data on-premises with cloud backup | Volume Gateway (Stored) |
| Block storage — extend capacity with cloud primary storage | Volume Gateway (Cached) |
| Replace physical tape backup infrastructure | Tape Gateway |

---

## Storage Gateway Deployment Options

### On-Premises VM

- Deploy as a **virtual machine** on existing hypervisor infrastructure
- Supported hypervisors:
  - VMware ESXi
  - Microsoft Hyper-V
  - Linux KVM
- Download the VM image from AWS
- Allocate minimum resources: 4 vCPUs, 16 GB RAM, storage for cache/upload buffer

### Hardware Appliance

- AWS provides a **physical hardware appliance** for sites without virtualization infrastructure
- Pre-configured Dell PowerEdge server
- Supports all gateway types (File, Volume, Tape)
- 5 TB usable cache storage (expandable)
- Useful for: small data centers, branch offices, remote locations without existing hypervisors
- Order from AWS; arrives pre-configured

### Amazon EC2

- Deploy the gateway as an **EC2 instance** in AWS
- Useful for: testing, development, or cloud-to-cloud data migration
- Same gateway types available
- AMI provided by AWS in the marketplace

---

## AWS DataSync

AWS DataSync is a **data transfer service** that automates moving data between on-premises storage and AWS storage services, or between AWS storage services.

### How DataSync Works

```
On-Premises:                              AWS:
NFS/SMB Server → DataSync Agent → (TLS) → DataSync Service → S3/EFS/FSx
```

1. Install the **DataSync agent** on-premises (VM on VMware/Hyper-V/KVM)
2. Configure a **source location** (NFS, SMB, HDFS, or self-managed object storage)
3. Configure a **destination location** (S3, EFS, FSx)
4. Create a **task** that defines the transfer parameters
5. Run the task — DataSync handles the transfer with built-in verification

### Key Features

| Feature | Detail |
|---------|--------|
| **Speed** | Up to 10 Gbps (per agent), can use multiple agents in parallel |
| **Scheduling** | Schedule tasks hourly, daily, weekly |
| **Data integrity** | Automatic verification (checksums) after transfer |
| **Bandwidth throttling** | Limit bandwidth to avoid saturating the network |
| **Incremental transfer** | Only transfers changed data after the first full copy |
| **Filtering** | Include/exclude patterns for selective transfer |
| **Metadata preservation** | Preserves file permissions, timestamps, ownership (POSIX metadata) |
| **Encryption** | TLS in transit |
| **Compression** | Data is compressed during transfer |

### Supported Locations

**Sources:**
- NFS file systems (on-premises)
- SMB file systems (on-premises)
- HDFS (Hadoop Distributed File System)
- Self-managed object storage (any S3-compatible)
- AWS services: S3, EFS, FSx (for AWS-to-AWS transfers)

**Destinations:**
- Amazon S3 (all storage classes including Glacier)
- Amazon EFS
- Amazon FSx (Windows File Server, Lustre, OpenZFS, NetApp ONTAP)

### AWS-to-AWS Transfers

DataSync can transfer data **between AWS services** without an on-premises agent:
- S3 → EFS
- EFS → S3
- S3 → FSx
- Between different FSx file systems
- Between S3 buckets (cross-region, cross-account)

### Tasks and Task Execution

- **Task**: Defines source, destination, settings (schedule, filter, bandwidth, verification)
- **Task execution**: A single run of a task
- Tasks can be run on-demand or on a schedule
- Each execution transfers only changed data (incremental)

---

## DataSync vs Storage Gateway

This is a common exam comparison. Understanding when to use each is critical.

| Feature | DataSync | Storage Gateway |
|---------|----------|----------------|
| **Primary purpose** | Data transfer/migration | Hybrid storage (ongoing access) |
| **Direction** | One-time or scheduled transfers | Continuous on-premises access to cloud storage |
| **Protocol** | Agent-based (NFS/SMB source) | NFS, SMB, iSCSI (to on-premises clients) |
| **Local caching** | No (transfer only) | Yes (local cache for low-latency access) |
| **Data remains on-premises** | No (data is migrated) | Depends on type (cached vs stored) |
| **Scheduling** | Scheduled or on-demand tasks | Always available (live gateway) |
| **Speed** | Up to 10 Gbps per agent | Network-limited |
| **Verification** | Built-in checksums | N/A |
| **Use case** | Migration, replication, scheduled sync | Hybrid storage, extending on-premises |

### When to Use Which

**Use DataSync when:**
- Migrating large datasets to AWS (one-time or scheduled)
- Setting up regular data transfer between on-premises and AWS
- Moving data between AWS storage services
- Replacing scripts/cron jobs that use rsync or similar tools

**Use Storage Gateway when:**
- Applications need continuous, low-latency access to cloud-backed storage
- Extending on-premises storage capacity with cloud storage
- Providing hybrid file shares for users
- Replacing tape backup infrastructure

**Combined pattern**: Use DataSync for initial bulk migration, then Storage Gateway for ongoing hybrid access.

---

## AWS Transfer Family

AWS Transfer Family provides fully managed **file transfer** support for transferring files into and out of S3 and EFS.

### Supported Protocols

| Protocol | Port | Description |
|----------|------|-------------|
| **SFTP** (SSH File Transfer Protocol) | 22 | Secure file transfer over SSH |
| **FTPS** (File Transfer Protocol over SSL) | 990 | FTP with TLS encryption |
| **FTP** (File Transfer Protocol) | 21 | Unencrypted FTP (only within VPC) |
| **AS2** (Applicability Statement 2) | 443 | B2B data exchange (EDI, supply chain) |

### Key Features

- **Managed infrastructure**: No servers to manage
- **Endpoint types**:
  - **Public**: Internet-accessible endpoint with DNS
  - **VPC endpoint (internal)**: Private, accessible only within VPC
  - **VPC endpoint (internet-facing)**: Public IP but deployed in VPC (for security groups, NACLs)
- **Storage backends**: S3 or EFS
- **Scaling**: Automatically scales to handle your file transfer workload
- **Custom DNS**: Use Route 53 or any DNS provider for custom hostnames

### Identity Providers

- **Service-managed**: Create and manage users within AWS Transfer Family
- **AWS Directory Service** (AD): Use Microsoft Active Directory
- **Custom Lambda authorizer**: Integrate with any identity provider (LDAP, OAuth, database)
- **API Gateway authorizer**: Custom authentication via API Gateway + Lambda

### Use Cases

- Replace self-managed SFTP servers with a fully managed service
- B2B file exchanges with partners (AS2)
- Regulatory requirements mandating specific file transfer protocols
- Migrate SFTP-based workflows to AWS without changing client workflows

### Workflow Automation

- **Managed workflows**: Define post-upload processing steps
- Steps include: copy, tag, custom Lambda processing, delete
- Triggered automatically when files are uploaded
- Example: Upload file → validate → process with Lambda → move to archive folder

**Exam Tip**: "SFTP server," "managed file transfer," "FTP/FTPS to S3" → AWS Transfer Family.

---

## Snow Family

The AWS Snow Family provides physical devices for offline data transfer and edge computing when network transfer is impractical.

### When to Use Snow Family

- Transferring **very large amounts of data** (terabytes to petabytes)
- Network bandwidth is limited or expensive
- Transfer would take **weeks or months** over the network
- Edge computing in remote or disconnected environments

### Rule of Thumb

If transferring over the network would take **more than 1 week**, consider using Snow Family.

Example: 100 TB over a 1 Gbps connection ≈ 12 days (including overhead).

### AWS Snowcone

| Feature | Snowcone | Snowcone SSD |
|---------|----------|-------------|
| **Weight** | 4.5 lbs (2.1 kg) | 4.5 lbs (2.1 kg) |
| **Storage** | 8 TB HDD | 14 TB SSD |
| **Compute** | 2 vCPUs, 4 GB memory | 2 vCPUs, 4 GB memory |
| **Power** | USB-C, battery optional | USB-C, battery optional |
| **Networking** | 2 x 1/10 GbE | 2 x 1/10 GbE |
| **Data transfer** | Physical shipping or DataSync (built-in agent) | Physical shipping or DataSync |
| **Use cases** | IoT, edge computing, data collection in remote locations |

**Key features:**
- Smallest and most portable Snow device
- **DataSync agent pre-installed** — can send data over the network to AWS
- Withstands harsh environments (dust, vibration, temperature)
- Can be battery-powered (with optional external battery)
- Supports EC2 instances and Lambda (via IoT Greengrass)

### AWS Snowball Edge

| Feature | Storage Optimized | Compute Optimized |
|---------|-------------------|-------------------|
| **Storage** | 80 TB usable (210 TB NVMe total) | 42 TB usable (28 TB NVMe + 7.68 TB SSD) |
| **Compute** | 40 vCPUs, 80 GB memory | 104 vCPUs, 416 GB memory |
| **GPU** | No | Optional NVIDIA V100 GPU |
| **Networking** | 1/10/25/40/100 GbE | 1/10/25/40/100 GbE |
| **Clustering** | Yes (up to 15 devices) | Yes (up to 15 devices) |
| **Use cases** | Large data transfer, local storage | Edge ML, video analysis, data processing |

**Key features:**
- Supports **EC2 instances** and **Lambda functions** running on the device
- **Cluster mode**: Combine up to 15 Snowball Edge devices for increased storage and compute
- **S3-compatible endpoint**: Applications can use S3 APIs directly against the device
- Block storage via iSCSI
- Tamper-evident, tamper-resistant, encrypted (256-bit)

### AWS Snowmobile

| Feature | Detail |
|---------|--------|
| **Capacity** | Up to **100 PB** per Snowmobile |
| **Physical form** | A 45-foot shipping container on a semi-trailer truck |
| **Networking** | 40 Gbps (multiple connections) |
| **Security** | GPS tracking, alarm monitoring, 24/7 video surveillance, escort security |
| **Power** | Self-powered or facility power |
| **Use cases** | Exabyte-scale data migration (10+ PB at a time) |

**Key points:**
- For extremely large migrations (10 PB to exabytes)
- Driven to your data center by AWS personnel
- Transfer data at up to 1 TB/s network speed
- AWS manages the logistics, security, and transit
- Use Snowball Edge for ≤10 PB; Snowmobile for ≥10 PB

### Snow Family Comparison

| Feature | Snowcone | Snowball Edge (Storage Opt) | Snowball Edge (Compute Opt) | Snowmobile |
|---------|----------|---------------------------|---------------------------|------------|
| **Capacity** | 8-14 TB | 80 TB | 42 TB | 100 PB |
| **Compute** | 2 vCPUs, 4 GB | 40 vCPUs, 80 GB | 104 vCPUs, 416 GB | N/A |
| **GPU** | No | No | Optional | N/A |
| **EC2/Lambda** | Yes | Yes | Yes | No |
| **Transfer method** | Ship or DataSync | Ship only | Ship only | Truck |
| **Portability** | Highly portable | Rack-mountable | Rack-mountable | Semi-trailer |
| **Best for** | Small edge, IoT | Large transfers | Edge compute + transfer | Massive (>10 PB) |

### AWS OpsHub

- **Desktop application** for managing Snow Family devices
- GUI for configuring, monitoring, and managing devices
- Launch EC2 instances, manage storage, monitor device status
- Replaces the command-line tools previously required

### Data Transfer Process

1. **Request** a Snow device from the AWS Console
2. AWS **ships** the device to your location
3. **Connect** the device to your network
4. **Transfer data** using the Snow client, S3 API, or OpsHub
5. **Ship** the device back to AWS
6. AWS **uploads** the data to your S3 bucket
7. AWS **wipes** the device (NIST 800-88 standard)

---

## AWS Backup

AWS Backup is a **centralized backup service** that automates and manages backups across AWS services.

### Supported Services

- EC2 instances (EBS volumes and AMIs)
- EBS volumes
- RDS databases
- DynamoDB tables
- EFS file systems
- FSx file systems (all types)
- S3 buckets
- Aurora clusters
- Neptune databases
- DocumentDB
- Storage Gateway volumes
- VMware workloads (on-premises)
- SAP HANA on EC2
- Amazon Redshift

### Backup Plans

A backup plan defines **when** and **how** to create backups.

**Components:**
- **Backup rule**: Schedule (cron or rate), retention period, lifecycle (transition to cold storage), copy to another region
- **Resource assignment**: Which resources to back up (by tags, resource IDs, or resource type)
- **Backup vault**: Where backups are stored

**Schedule options:**
- Cron expressions (e.g., `cron(0 1 * * ? *)` for daily at 1 AM)
- Rate expressions (e.g., `rate(12 hours)`)
- On-demand (manual)

### Backup Vaults

- Logical containers for backup recovery points
- **Default vault**: Created automatically
- **Custom vaults**: Create your own for organizational separation
- **Access policies**: Control who can access the vault and its backups
- **Encryption**: All backups are encrypted (AWS-managed or customer-managed KMS key)

### Cross-Region Backup

- Copy backups to another AWS Region automatically
- Part of the backup plan configuration
- Use cases: Disaster recovery, compliance requirements for geographic separation
- Copy retains encryption (re-encrypts with a key in the target region)

### Cross-Account Backup

- Copy backups to a different AWS account
- Requires AWS Organizations
- Use cases: Protect against account compromise, organizational backup strategy
- Source account shares backups with destination account's vault

### Vault Lock

AWS Backup Vault Lock provides **WORM (write-once-read-many)** protection for backups.

- Once enabled, vault lock **cannot be removed** (even by the root user)
- Backups in a locked vault cannot be deleted before the retention period expires
- Supports **compliance mode** (even root can't delete) and **governance mode** (authorized users can change)
- Use cases: Regulatory compliance (SEC 17a-4, CFTC, FINRA)

### Backup for Hybrid Workloads

- Back up on-premises VMware VMs using the AWS Backup gateway
- Centralized management of both cloud and on-premises backups
- Consistent backup policies across hybrid environments

---

## Migration Strategies: The 7 Rs

The **7 Rs** are migration strategies for moving applications to the cloud. Understanding when to apply each is critical for the exam.

### 1. Rehost (Lift and Shift)

- Move applications to AWS **without changes**
- Move VMs to EC2, databases to EC2 instances
- Fastest migration approach
- Use AWS Application Migration Service (MGN) for automated rehosting
- Example: Move on-premises VMs directly to EC2

**When to use:** Tight timelines, large-scale migrations, legacy applications that work as-is

### 2. Replatform (Lift, Tinker, and Shift)

- Move to AWS with **minor optimizations** (no core architecture changes)
- Leverage some cloud capabilities without rewriting
- Examples:
  - Migrate database to RDS (instead of managing DB on EC2)
  - Move to Elastic Beanstalk for managed platform
  - Switch to managed caching (ElastiCache)
  - Use ALB instead of self-managed load balancer

**When to use:** Want some cloud benefits without a full rewrite. Moderate timeline.

### 3. Repurchase (Drop and Shop)

- Replace the existing application with a **cloud-native SaaS** product
- Examples:
  - CRM: On-premises → Salesforce
  - HR: On-premises → Workday
  - CMS: On-premises → Drupal on AWS Marketplace
  - Email: Exchange → Amazon WorkMail or Microsoft 365
  - ERP: On-premises → SAP on AWS

**When to use:** Commercial off-the-shelf (COTS) software with better SaaS alternatives

### 4. Refactor / Re-architect

- **Redesign the application** from scratch using cloud-native features
- Biggest effort but biggest potential benefit
- Examples:
  - Monolith → Microservices on ECS/EKS
  - Traditional app → Serverless (Lambda + API Gateway + DynamoDB)
  - On-premises message queue → SQS/SNS
  - File processing → Event-driven architecture

**When to use:** Need to add cloud-native features (auto-scaling, event-driven), improve agility, or the application doesn't work well as-is

### 5. Retire

- **Decommission** the application — turn it off
- Identify applications that are no longer useful
- Save costs and reduce management overhead
- Example: Redundant applications, applications with <5 users

**When to use:** Application is no longer needed, redundant, or being replaced

### 6. Retain (Revisit)

- **Keep the application** where it is (do not migrate now)
- Postpone migration to a later date
- Examples:
  - Recently upgraded on-premises application
  - Applications with unresolved compliance concerns
  - Applications not yet ready for migration

**When to use:** Not worth migrating now, complex dependencies, regulatory barriers

### 7. Relocate

- Move to AWS **without changes**, specifically for VMware-based workloads
- Use **VMware Cloud on AWS** to move VMs without conversion
- Maintains the VMware environment in the cloud
- No replatforming or application changes required

**When to use:** VMware-based infrastructure that needs to move quickly without any changes

---

## Application Discovery Service

AWS Application Discovery Service helps plan migration by **collecting information** about on-premises data centers.

### Agentless Discovery (Discovery Connector)

- Deploy an **OVA** (Open Virtual Appliance) on VMware vCenter
- Collects VM configuration data: host name, IP addresses, MAC addresses, resource allocation, disk I/O, CPU/memory utilization
- **Does NOT** collect data from inside the VMs (no application dependencies)
- Lighter weight, quicker to set up

### Agent-Based Discovery (Discovery Agent)

- Install an **agent** on each on-premises server (Linux or Windows)
- Collects detailed information:
  - System configuration and performance data
  - **Running processes** and network connections
  - **Application dependencies** (which servers communicate with which)
- Provides deeper insights for migration planning
- More setup effort (agent on each server)

### Integration with AWS Services

- Data is stored in **AWS Application Discovery Service** data store
- View in **AWS Migration Hub** for centralized migration tracking
- Export data to S3 for analysis with **Amazon Athena**
- Use data to plan migration waves and dependencies

---

## Application Migration Service (MGN)

AWS Application Migration Service (formerly CloudEndure Migration) is the **recommended service** for lift-and-shift (rehost) migrations.

### How It Works

```
On-Premises Server → MGN Agent → Continuous Replication → AWS Staging Area
                                                              ↓ (Cutover)
                                                         Production EC2 Instance
```

1. Install the **MGN Replication Agent** on source servers
2. Agent continuously replicates data to a **staging area** in AWS (lightweight instances)
3. Test instances can be launched from replicated data (non-disruptive testing)
4. When ready, perform a **cutover**: launch production instances from the replicated data
5. After cutover, decommission on-premises servers

### Key Features

| Feature | Detail |
|---------|--------|
| **Replication** | Continuous block-level replication (not snapshot-based) |
| **Testing** | Non-disruptive test launches (don't affect source or replication) |
| **Cutover** | Automated cutover process with minimal downtime |
| **OS support** | Windows and Linux (physical, virtual, or cloud) |
| **Source platforms** | VMware, Hyper-V, Azure, GCP, physical servers |
| **Network** | Replicates over the public internet or VPN/Direct Connect |
| **Conversion** | Automatically converts boot volumes to AWS-compatible format |
| **Post-launch** | Configure post-launch actions (install agents, run scripts) |

### Migration Phases

1. **Replication**: Continuous replication from source to AWS (hours to days for initial sync)
2. **Testing**: Launch test instances to validate (non-disruptive)
3. **Cutover**: Final sync + launch production instances (minutes of downtime)
4. **Post-migration**: Decommission source, optimize AWS instances

### MGN vs SMS (Server Migration Service)

- SMS is the **predecessor** to MGN (deprecated)
- SMS used incremental snapshot-based replication (slower)
- MGN uses continuous block-level replication (faster, less downtime)
- **Always choose MGN** for new migrations on the exam

---

## Database Migration Service (DMS)

AWS Database Migration Service (DMS) helps migrate databases to AWS quickly and securely.

### Architecture

```
Source Database → DMS Replication Instance → Target Database
                  (EC2 instance running DMS)
```

### Endpoints

- **Source endpoint**: Connection to the source database
- **Target endpoint**: Connection to the target database
- DMS supports the source database staying operational during migration (minimal downtime)

### Supported Sources and Targets

**Sources:**
- On-premises databases: Oracle, SQL Server, MySQL, MariaDB, PostgreSQL, MongoDB, SAP ASE, DB2
- Azure SQL Database
- Amazon RDS (all engines), Aurora
- S3 (as a source of data)

**Targets:**
- Amazon RDS (all engines), Aurora
- Amazon Redshift
- Amazon DynamoDB
- Amazon S3
- Amazon OpenSearch
- Amazon Kinesis Data Streams
- Amazon Neptune
- Amazon DocumentDB
- Apache Kafka

### Migration Types

**Full Load:**
- Migrates all existing data from source to target
- One-time migration
- Source tables are loaded in their entirety

**Change Data Capture (CDC):**
- Captures and applies ongoing changes from the source
- Continuous replication after the initial load
- Keeps source and target in sync
- Minimal downtime during cutover

**Full Load + CDC (most common):**
1. Full load: Migrate all existing data
2. CDC: Capture changes that occurred during the full load
3. Apply changes: Bring the target up to date
4. Cutover: Switch the application to the target database

### Replication Instance

- An **EC2 instance** that runs the DMS software
- Handles data migration between source and target
- Size affects migration speed (larger instance = faster)
- Can be in a VPC for secure connectivity
- **Multi-AZ**: For production migrations, use Multi-AZ for high availability
- Replication instance class: dms.t3.*, dms.r5.*, dms.c5.*

### Schema Conversion Tool (SCT)

AWS SCT converts database schema from one engine to another (for **heterogeneous** migrations).

**What SCT does:**
- Convert schema objects (tables, views, stored procedures, functions, triggers, indexes)
- Convert application SQL code
- Identifies schema elements that can't be automatically converted (action items)
- Generates a migration assessment report

**When SCT is needed:**
- **Heterogeneous migration**: Different source and target engines
  - Oracle → Aurora PostgreSQL
  - SQL Server → Aurora MySQL
  - Oracle → Amazon Redshift
- SCT is **NOT needed** for homogeneous migrations (same engine):
  - MySQL → Aurora MySQL
  - PostgreSQL → RDS PostgreSQL
  - Oracle → RDS Oracle

### DMS Key Features

- **Continuous replication**: Keep source and target synchronized indefinitely
- **Table mapping**: Select which schemas, tables, and columns to migrate
- **Data validation**: Verify data integrity after migration
- **Pre-migration assessment**: Identify potential issues before migration
- **CloudWatch integration**: Monitor migration task metrics
- **Multi-AZ**: High availability for the replication instance

### Homogeneous vs Heterogeneous Migration

| Feature | Homogeneous | Heterogeneous |
|---------|------------|---------------|
| Engine change | No (same engine) | Yes (different engines) |
| SCT needed | No | Yes |
| Example | Oracle → RDS Oracle | Oracle → Aurora PostgreSQL |
| Complexity | Lower | Higher |
| Schema conversion | Automatic (or not needed) | Manual review required |

---

## Exam Tips & Scenarios

### Scenario 1: On-Premises File Shares to AWS
**Q:** On-premises NFS file server needs cloud-backed storage. Users need low-latency access to frequently used files.
**A:** S3 File Gateway. NFS interface, S3 backend, local cache for frequently accessed files.

### Scenario 2: Tape Backup Replacement
**Q:** Company wants to eliminate tape backup infrastructure and move to cloud-based archival.
**A:** Tape Gateway. Virtual tape library interface for existing backup software, data archived to S3 Glacier.

### Scenario 3: Migrate 50 TB to S3
**Q:** Need to migrate 50 TB of data from on-premises NFS to S3. Network bandwidth is 1 Gbps (shared).
**A:** AWS DataSync. Agent-based, can throttle bandwidth, incremental transfer, scheduled tasks.

### Scenario 4: Migrate 500 TB with Limited Bandwidth
**Q:** Need to migrate 500 TB to AWS. Internet bandwidth is only 100 Mbps.
**A:** Snowball Edge (Storage Optimized). Multiple devices. Network transfer would take months.

### Scenario 5: Lift and Shift VM Migration
**Q:** Company wants to migrate 200 VMs from on-premises VMware to EC2 with minimal downtime.
**A:** Application Migration Service (MGN). Continuous replication, non-disruptive testing, automated cutover.

### Scenario 6: Oracle to Aurora PostgreSQL
**Q:** Migrate Oracle database to Aurora PostgreSQL with minimal downtime.
**A:** AWS SCT for schema conversion + DMS with Full Load + CDC for data migration. SCT converts Oracle schema to PostgreSQL. DMS handles data migration and ongoing replication until cutover.

### Scenario 7: MySQL to Aurora MySQL
**Q:** Migrate on-premises MySQL to Aurora MySQL.
**A:** DMS with Full Load + CDC. Homogeneous migration — SCT is NOT needed.

### Scenario 8: Extend On-Premises Storage
**Q:** On-premises application needs more iSCSI storage, but the company doesn't want to buy more hardware. Most data is rarely accessed.
**A:** Volume Gateway (Cached mode). Primary data in S3, frequently accessed data cached locally. Extends storage without new hardware.

### Scenario 9: Centralized Backup Strategy
**Q:** Need to centralize backup management for EC2, RDS, EFS, and DynamoDB with cross-region copies.
**A:** AWS Backup. Centralized backup plans, cross-region copy rules, single management interface.

### Scenario 10: Immutable Backups for Compliance
**Q:** Backups must be immutable for 7 years per regulatory requirements.
**A:** AWS Backup with Vault Lock (compliance mode). Backups cannot be deleted by anyone during the retention period.

### Scenario 11: Edge Computing in Remote Location
**Q:** Need to collect and process IoT data at a remote oil rig with no internet connectivity.
**A:** Snowball Edge (Compute Optimized) or Snowcone. Run EC2 instances and Lambda at the edge. Ship device back for data upload.

### Scenario 12: Windows File Shares for Branch Offices
**Q:** Multiple branch offices need low-latency access to shared Windows file system.
**A:** FSx for Windows File Server (central) + FSx File Gateway at each branch office (local cache).

### Scenario 13: SFTP Server Migration
**Q:** Company runs self-managed SFTP servers for partner file exchange. Want to reduce management overhead.
**A:** AWS Transfer Family (SFTP). Fully managed, stores files in S3, same SFTP endpoint for partners.

### Scenario 14: Petabyte-Scale Data Center Migration
**Q:** Need to migrate 60 PB of data from a data center to S3.
**A:** AWS Snowmobile. For >10 PB, Snowmobile is the most practical option.

### Key Exam Patterns

1. **S3 File Gateway** = NFS/SMB file access backed by S3 with local cache
2. **FSx File Gateway** = Local cache for FSx Windows File Server (SMB/AD)
3. **Volume Gateway Stored** = Full data locally + cloud backup (iSCSI)
4. **Volume Gateway Cached** = Full data in cloud + local cache for hot data (iSCSI)
5. **Tape Gateway** = Virtual tape library backed by S3/Glacier
6. **DataSync** = Migrate data (agent-based, one-time or scheduled, high-speed)
7. **Storage Gateway** = Hybrid storage (continuous on-premises access)
8. **DataSync for migration**, Storage Gateway for ongoing hybrid access
9. **Snowball Edge** = Large offline transfers (TB to PB) and edge computing
10. **Snowcone** = Small, portable, has DataSync agent (can send data over network)
11. **Snowmobile** = Massive transfers (>10 PB)
12. **MGN** = Lift-and-shift migration (continuous replication, replaces SMS)
13. **DMS** = Database migration (Full Load + CDC for minimal downtime)
14. **SCT** = Schema conversion for heterogeneous DB migrations (NOT needed for same-engine)
15. **AWS Backup** = Centralized backup across AWS services. Vault Lock for WORM compliance.
16. **7 Rs**: Rehost (lift & shift), Replatform (lift & tinker), Repurchase (SaaS), Refactor (re-architect), Retire (decommission), Retain (keep as-is), Relocate (VMware Cloud)
17. **Transfer Family** = Managed SFTP/FTPS/FTP/AS2 to S3 or EFS
18. **Application Discovery Service**: Agentless (VMware info only) vs Agent-based (processes, dependencies, deeper insight)

---

*Previous: [← EBS, EFS & FSx](12-ebs-efs-fsx.md)*
