# EBS, EFS & FSx

## Table of Contents

1. [Amazon EBS Overview](#amazon-ebs-overview)
2. [EBS Volume Types](#ebs-volume-types)
3. [EBS Snapshots](#ebs-snapshots)
4. [EBS Encryption](#ebs-encryption)
5. [EBS Multi-Attach](#ebs-multi-attach)
6. [EBS Optimized Instances](#ebs-optimized-instances)
7. [RAID Configurations](#raid-configurations)
8. [Amazon EFS](#amazon-efs)
9. [EFS vs EBS vs S3 vs Instance Store](#efs-vs-ebs-vs-s3-vs-instance-store)
10. [Amazon FSx for Windows File Server](#amazon-fsx-for-windows-file-server)
11. [Amazon FSx for Lustre](#amazon-fsx-for-lustre)
12. [Amazon FSx for NetApp ONTAP](#amazon-fsx-for-netapp-ontap)
13. [Amazon FSx for OpenZFS](#amazon-fsx-for-openzfs)
14. [Complete Storage Comparison](#complete-storage-comparison)
15. [Exam Tips & Scenarios](#exam-tips--scenarios)

---

## Amazon EBS Overview

Amazon Elastic Block Store (EBS) provides persistent block storage volumes for EC2 instances. EBS volumes behave like raw, unformatted block devices that can be formatted with a filesystem and attached to an EC2 instance.

### Key Characteristics

- **Persistent**: Data persists independently of the instance lifecycle (survives stop/terminate if configured)
- **Network-attached**: Connected to the instance over the network (not physically attached)
- **AZ-locked**: A volume exists in a single AZ and can only be attached to instances in that AZ
- **Resizable**: Can increase size, change type, and adjust IOPS while in use (for most types)
- **Snapshots**: Point-in-time backups stored in S3 (managed by AWS)
- **One instance at a time** (except Multi-Attach for io1/io2)

### Volume Lifecycle

1. **Create**: Specify type, size, IOPS, AZ
2. **Attach**: Attach to an EC2 instance in the same AZ
3. **Use**: Format, mount, read/write
4. **Modify**: Change size, type, IOPS on-the-fly
5. **Detach**: Detach from the instance
6. **Delete**: Terminate the volume (or it's deleted with the instance if `DeleteOnTermination=true`)

---

## EBS Volume Types

This is one of the most critical tables to memorize for the exam.

### General Purpose SSD — gp2

| Feature | Detail |
|---------|--------|
| **Type** | SSD |
| **Size range** | 1 GiB – 16 TiB |
| **Max IOPS** | 16,000 (at 5,334 GiB and above) |
| **Max throughput** | 250 MiB/s |
| **IOPS scaling** | 3 IOPS per GiB (baseline) |
| **Burst** | Up to 3,000 IOPS for volumes < 1 TiB |
| **Latency** | Single-digit milliseconds |
| **Boot volume** | Yes |
| **Use cases** | Boot volumes, dev/test, low-latency interactive apps |

**How IOPS scale with gp2:**
- Minimum: 100 IOPS (for volumes ≤ 33 GiB)
- Formula: 3 IOPS × volume size in GiB
- Maximum: 16,000 IOPS (at 5,334 GiB)
- Volumes < 1 TiB can burst to 3,000 IOPS using I/O credits (similar to T-series CPU credits)

### General Purpose SSD — gp3

| Feature | Detail |
|---------|--------|
| **Type** | SSD |
| **Size range** | 1 GiB – 16 TiB |
| **Baseline IOPS** | 3,000 (regardless of volume size) |
| **Max IOPS** | 16,000 (provisioned independently) |
| **Baseline throughput** | 125 MiB/s |
| **Max throughput** | 1,000 MiB/s (provisioned independently) |
| **Latency** | Single-digit milliseconds |
| **Boot volume** | Yes |
| **Use cases** | Same as gp2 but more cost-effective |

**Key differences gp3 vs gp2:**
- gp3 has a **fixed baseline** of 3,000 IOPS and 125 MiB/s regardless of size
- gp3 allows **independent provisioning** of IOPS and throughput
- gp3 is **20% cheaper** than gp2 at baseline (same IOPS/throughput)
- gp3 does NOT have a burst mechanism (it doesn't need one — baseline is already 3,000)
- gp2 links IOPS to volume size; gp3 decouples them

**Exam Tip**: gp3 is almost always the better choice over gp2 for new workloads. It provides better baseline performance at lower cost.

### Provisioned IOPS SSD — io1

| Feature | Detail |
|---------|--------|
| **Type** | SSD |
| **Size range** | 4 GiB – 16 TiB |
| **Max IOPS** | 64,000 (Nitro instances) / 32,000 (non-Nitro) |
| **Max throughput** | 1,000 MiB/s |
| **IOPS-to-size ratio** | Max 50 IOPS per GiB |
| **Latency** | Single-digit milliseconds |
| **Multi-Attach** | Yes |
| **Boot volume** | Yes |
| **Use cases** | Critical databases (Oracle, SAP HANA), latency-sensitive workloads |

### Provisioned IOPS SSD — io2

| Feature | Detail |
|---------|--------|
| **Type** | SSD |
| **Size range** | 4 GiB – 16 TiB |
| **Max IOPS** | 64,000 (Nitro instances) |
| **Max throughput** | 1,000 MiB/s |
| **IOPS-to-size ratio** | Max 500 IOPS per GiB |
| **Durability** | 99.999% (5 nines) — better than io1's 99.8-99.9% |
| **Latency** | Single-digit milliseconds |
| **Multi-Attach** | Yes |
| **Boot volume** | Yes |
| **Use cases** | Same as io1 with higher durability and better IOPS density |

### io2 Block Express

| Feature | Detail |
|---------|--------|
| **Type** | SSD (next-gen architecture) |
| **Size range** | 4 GiB – 64 TiB |
| **Max IOPS** | **256,000** |
| **Max throughput** | **4,000 MiB/s** |
| **IOPS-to-size ratio** | Max 1,000 IOPS per GiB |
| **Latency** | **Sub-millisecond** |
| **Multi-Attach** | Yes |
| **Boot volume** | Yes |
| **Use cases** | Largest, most I/O-intensive, mission-critical databases (SAP HANA, Oracle, SQL Server) |

**io2 Block Express** is the highest-performance EBS volume type. It requires Nitro-based instances that support Block Express (R5b, X2idn, etc.).

### Throughput Optimized HDD — st1

| Feature | Detail |
|---------|--------|
| **Type** | HDD |
| **Size range** | 125 GiB – 16 TiB |
| **Max IOPS** | 500 |
| **Max throughput** | 500 MiB/s |
| **Baseline throughput** | 40 MiB/s per TiB |
| **Burst throughput** | 250 MiB/s per TiB |
| **Boot volume** | **No** |
| **Use cases** | Big data, data warehouses, log processing, streaming workloads |

### Cold HDD — sc1

| Feature | Detail |
|---------|--------|
| **Type** | HDD |
| **Size range** | 125 GiB – 16 TiB |
| **Max IOPS** | 250 |
| **Max throughput** | 250 MiB/s |
| **Baseline throughput** | 12 MiB/s per TiB |
| **Burst throughput** | 80 MiB/s per TiB |
| **Boot volume** | **No** |
| **Use cases** | Infrequently accessed data, lowest cost storage, cold data |

### Complete EBS Volume Comparison Table

| Feature | gp2 | gp3 | io1 | io2 | io2 Block Express | st1 | sc1 |
|---------|-----|-----|-----|-----|-------------------|-----|-----|
| **Type** | SSD | SSD | SSD | SSD | SSD | HDD | HDD |
| **Size** | 1-16 TiB | 1-16 TiB | 4-16 TiB | 4-16 TiB | 4-64 TiB | 125 GiB-16 TiB | 125 GiB-16 TiB |
| **Max IOPS** | 16,000 | 16,000 | 64,000 | 64,000 | **256,000** | 500 | 250 |
| **Max Throughput** | 250 MiB/s | 1,000 MiB/s | 1,000 MiB/s | 1,000 MiB/s | **4,000 MiB/s** | 500 MiB/s | 250 MiB/s |
| **Multi-Attach** | No | No | Yes | Yes | Yes | No | No |
| **Boot Volume** | Yes | Yes | Yes | Yes | Yes | No | No |
| **Durability** | 99.8-99.9% | 99.8-99.9% | 99.8-99.9% | **99.999%** | **99.999%** | 99.8-99.9% | 99.8-99.9% |
| **Price** | $$ | $ | $$$$ | $$$$ | $$$$$ | $ | ¢ |

---

## EBS Snapshots

EBS snapshots are **point-in-time copies** of EBS volumes, stored in Amazon S3 (managed by AWS).

### Key Characteristics

- **Incremental**: Only changed blocks since the last snapshot are saved (reduces storage costs and time)
- **Asynchronous**: The snapshot captures the state at the point of initiation, even if writes continue
- **Consistent**: For consistency, it's recommended (but not required) to detach the volume or stop the instance before snapshotting
- **S3-based**: Stored redundantly across multiple AZs (11 nines durability)
- **Lazily loaded**: When a volume is created from a snapshot, data is loaded on demand (first access may be slower)

### Cross-Region Copy

- Copy snapshots to another AWS Region
- Useful for: disaster recovery, migration, geo-distributed deployments
- Encrypted snapshots can be copied (re-encrypted with a key in the target region)
- Unencrypted snapshots can be encrypted during copy

### Fast Snapshot Restore (FSR)

- Eliminates the latency of lazily loading data when creating a volume from a snapshot
- Volumes created from FSR-enabled snapshots have **full performance immediately**
- Enabled per snapshot per AZ
- **Expensive** — charged per snapshot-AZ-hour
- Use cases: Databases or applications that need immediate full performance after restore

### EBS Snapshot Archive

- Move snapshots to an **archive tier** that is 75% cheaper than standard snapshot storage
- Retrieval time: **24-72 hours** to restore from archive
- Use cases: Snapshots retained for compliance but rarely accessed
- Archive snapshots manually or with lifecycle policies

### Recycle Bin for EBS Snapshots

- Protect snapshots from accidental deletion
- Deleted snapshots go to the Recycle Bin instead of being permanently deleted
- **Retention rules**: Define how long deleted snapshots are retained (1 day to 1 year)
- Can recover snapshots from the Recycle Bin within the retention period
- Applies to both EBS snapshots and AMIs

### EBS Snapshot Lifecycle (Data Lifecycle Manager — DLM)

Automate snapshot creation and deletion:
- **Lifecycle policies**: Define schedules for creating and retaining snapshots
- **Target**: Based on tags (e.g., snapshot all volumes tagged `backup: true`)
- **Schedule**: How often to create snapshots (every N hours)
- **Retention**: Number of snapshots to retain or age-based retention
- **Cross-region copy**: Automatically copy snapshots to another region
- **Cross-account sharing**: Automatically share snapshots with other accounts
- **Fast Snapshot Restore**: Automatically enable FSR on new snapshots

---

## EBS Encryption

### How It Works

- EBS encryption uses **AWS KMS** keys (AES-256)
- When you create an encrypted volume, the following are encrypted:
  - Data at rest inside the volume
  - All data moving between the volume and the instance
  - All snapshots created from the volume
  - All volumes created from those snapshots
- Encryption and decryption are handled **transparently** (no impact on application)
- **Minimal latency impact** (encryption is handled by the EC2 Nitro system hardware)

### Encryption Keys

- **AWS-managed key** (`aws/ebs`): Default KMS key, free to use, AWS manages rotation
- **Customer-managed key (CMK)**: You create and manage in KMS. Allows key rotation control, key policies, and cross-account sharing.

### Encrypting an Unencrypted Volume

You cannot directly encrypt an existing unencrypted volume. Instead:

1. Create a snapshot of the unencrypted volume
2. Copy the snapshot with encryption enabled (choose KMS key)
3. Create a new volume from the encrypted snapshot
4. Attach the new encrypted volume to the instance

**Shortcut**: Copy the snapshot and enable encryption → create volume from encrypted snapshot.

### Encrypting an Unencrypted Root Volume

1. Launch an instance with an unencrypted root volume
2. Create an AMI from the instance
3. Copy the AMI with encryption enabled
4. Launch a new instance from the encrypted AMI

### Default Encryption

- Enable **default EBS encryption** at the **account level per Region**
- All new EBS volumes created in that Region will be encrypted automatically
- Uses the default KMS key (or a custom CMK you specify)
- Existing unencrypted volumes are NOT affected

### Cross-Account Encrypted Snapshot Sharing

1. Share the **customer-managed KMS key** with the target account (via KMS key policy)
2. Share the **encrypted snapshot** with the target account
3. Target account copies the snapshot and re-encrypts with their own KMS key
4. Target account creates a volume from their copy

**Note**: Snapshots encrypted with the AWS-managed key (`aws/ebs`) **cannot** be shared with other accounts. You must use a customer-managed key.

---

## EBS Multi-Attach

Multi-Attach allows a **single io1/io2 EBS volume** to be attached to **multiple EC2 instances** simultaneously.

### Key Details

- **Volume types**: io1, io2, io2 Block Express only
- **Same AZ**: All instances must be in the same AZ as the volume
- **Max instances**: Up to **16** EC2 instances simultaneously
- **Instances**: Must be Linux (Windows not supported for Multi-Attach)
- **Cluster-aware filesystem**: You must use a cluster-aware filesystem (e.g., GFS2, OCFS2) — NOT ext4 or XFS
- Standard filesystems do NOT handle concurrent writes safely

### Use Cases

- Clustered databases (Oracle RAC)
- Applications that manage concurrent write operations
- High availability within a single AZ

### Limitations

- Single AZ only (cannot span AZs)
- Must use cluster-aware filesystem
- io1/io2 only (not gp2/gp3/st1/sc1)
- Applications must handle concurrent access

---

## EBS Optimized Instances

EBS Optimized instances provide **dedicated bandwidth** between the instance and EBS volumes.

- Dedicated EBS throughput separate from network bandwidth
- Available on most current-generation instance types
- Some instance types are EBS-optimized by default (no additional cost)
- Older instance types can enable EBS optimization for an additional fee
- Bandwidth ranges from 500 Mbps to 60,000 Mbps+ depending on instance type

**Why it matters:**
- Without EBS optimization, EBS traffic shares bandwidth with network traffic
- This can cause I/O contention and degraded EBS performance
- EBS-optimized instances guarantee the EBS bandwidth is separate

**Exam Tip**: If you see EBS performance issues on an older instance type, enabling EBS optimization (or upgrading to a current-gen instance that is optimized by default) is a common fix.

---

## RAID Configurations

RAID (Redundant Array of Independent Disks) can be configured on EC2 using EBS volumes.

### RAID 0 — Striping (Performance)

- Data is **striped** across multiple volumes
- **Doubles throughput and IOPS** (with 2 volumes)
- **No fault tolerance**: If one volume fails, all data is lost
- Use cases: Applications needing maximum I/O performance where data loss is acceptable (or data is replicated at the application level)
- Example: 2 × gp3 volumes → combined 6,000 baseline IOPS, 250 MiB/s throughput

### RAID 1 — Mirroring (Fault Tolerance)

- Data is **mirrored** across multiple volumes
- Provides **fault tolerance**: If one volume fails, data is preserved on the other
- **No performance improvement** (writes go to both volumes)
- Use cases: Critical data that needs extra protection within a single instance
- Effectively doubles storage cost

### RAID 5 and RAID 6 — NOT Recommended

- AWS **does not recommend** RAID 5 or RAID 6 for EBS
- The parity writes consume significant IOPS (20-30% of IOPS lost to parity)
- EBS already provides redundancy within the AZ
- Use RAID 0 for performance or RAID 1 for fault tolerance

---

## Amazon EFS

Amazon Elastic File System (EFS) is a fully managed, elastic, shared **NFS file system** for Linux workloads.

### Key Characteristics

- **Protocol**: NFSv4.1
- **OS**: Linux only (not Windows)
- **Elastic**: Grows and shrinks automatically (no need to pre-provision capacity)
- **Shared**: Can be mounted by **thousands of EC2 instances** concurrently across AZs
- **Regional**: Data stored across multiple AZs (unless using One Zone)
- **POSIX-compliant**: Standard file system semantics (file locking, permissions, etc.)
- **Compatible with**: EC2, ECS (Fargate and EC2), EKS, Lambda (via VPC)

### Performance Modes

| Mode | Max IOPS | Latency | Use Cases |
|------|----------|---------|-----------|
| **General Purpose** (default) | ~35,000 read / ~7,000 write | Lowest | Web serving, CMS, home directories, general development |
| **Max I/O** | 500,000+ | Higher | Big data, media processing, highly parallelized workloads |

**Note**: General Purpose mode now supports up to 55,000 IOPS with Elastic throughput, making Max I/O less necessary. AWS recommends General Purpose for most workloads.

### Throughput Modes

| Mode | How Throughput Works | Best For |
|------|---------------------|----------|
| **Bursting** (default) | Scales with file system size. Baseline: 50 MiB/s per TiB. Burst to 100 MiB/s per TiB (or 100 MiB/s min). | Workloads with variable throughput needs |
| **Provisioned** (now called "Fixed") | You specify throughput independent of storage size. | Workloads needing more throughput than Bursting provides |
| **Elastic** | Automatically scales throughput up and down. Up to 10 GiB/s for reads, 3 GiB/s for writes. | Spiky, unpredictable workloads. Recommended by AWS for most workloads. |

**Bursting details:**
- Earns burst credits when below baseline
- Minimum burst: 100 MiB/s (even for small file systems)
- Example: 1 TiB file system → 50 MiB/s baseline, burst to 100 MiB/s

### Storage Classes

| Class | AZ Redundancy | Latency | Cost | Availability SLA |
|-------|--------------|---------|------|-----------------|
| **EFS Standard** | Multi-AZ | Low | $0.30/GB/month | 99.99% |
| **EFS Standard-IA** | Multi-AZ | Higher | $0.025/GB/month + per access | 99.99% |
| **EFS One Zone** | Single AZ | Low | $0.16/GB/month | 99.9% |
| **EFS One Zone-IA** | Single AZ | Higher | $0.0133/GB/month + per access | 99.9% |

### Lifecycle Management

- Automatically moves files between Standard and IA storage classes based on access patterns
- Configure lifecycle policies: 7, 14, 30, 60, 90 days without access → move to IA
- **Transition out of IA**: Configure automatic transition back to Standard on access (or keep in IA)
- Saves costs for infrequently accessed files

### EFS Access Points

- Application-specific entry points into an EFS file system
- Each access point can:
  - Enforce a specific **POSIX user** and **group** (override client identity)
  - Enforce a **root directory** (chroot) — the application sees only a subset of the file system
- Use with IAM policies for fine-grained access control
- Multiple access points per file system
- Use cases: Multi-tenant applications, containerized workloads

### Mount Targets

- To access EFS, you create **mount targets** in your VPC subnets
- One mount target per AZ (recommended: one per AZ where you have instances)
- Each mount target has:
  - An IP address from the subnet CIDR
  - A security group (controls NFS access)
  - A DNS name

### EFS Encryption

**At rest:**
- Enable encryption when creating the file system
- Uses AWS KMS (AWS-managed or customer-managed key)
- Cannot enable encryption on an existing unencrypted file system
- All data, metadata, and backups are encrypted

**In transit:**
- TLS 1.2 encryption using the EFS mount helper (`amazon-efs-utils`)
- Mount command: `sudo mount -t efs -o tls fs-12345678:/ /mnt/efs`
- Uses the EFS mount helper and stunnel for TLS tunneling

---

## EFS vs EBS vs S3 vs Instance Store

### Comprehensive Comparison Table

| Feature | EBS | EFS | S3 | Instance Store |
|---------|-----|-----|-----|---------------|
| **Type** | Block storage | File storage (NFS) | Object storage | Block storage |
| **Protocol** | Block device | NFSv4.1 | HTTP/HTTPS (API) | Block device |
| **Persistence** | Persistent | Persistent | Persistent | **Ephemeral** |
| **Attachment** | 1 instance (except Multi-Attach) | 1000s of instances | Not attached (API access) | 1 instance |
| **AZ scope** | Single AZ | Regional (multi-AZ) or One Zone | Regional | Single AZ (host) |
| **Max size** | 64 TiB (io2 BE) | Petabytes | 5 TB per object | Instance-dependent |
| **Max IOPS** | 256,000 (io2 BE) | 55,000+ | N/A | Millions (NVMe) |
| **Latency** | Sub-ms to ms | Low ms | Tens of ms | Sub-ms |
| **Scaling** | Manual resize | Automatic | Automatic | Fixed at launch |
| **Backup** | Snapshots | AWS Backup | Versioning, replication | Manual (copy out) |
| **Encryption** | KMS | KMS (rest + transit) | SSE-S3/KMS/C | Some types |
| **OS support** | Linux, Windows | **Linux only** | Any (API) | Linux, Windows |
| **Cost model** | Per GB + IOPS provisioned | Per GB used | Per GB + requests | Included with instance |
| **Best for** | Databases, boot volumes | Shared file access, CMS, home dirs | Static assets, backups, data lakes | Cache, temp data, highest I/O |

---

## Amazon FSx for Windows File Server

Fully managed **Windows-native** shared file storage built on Windows Server.

### Key Features

| Feature | Detail |
|---------|--------|
| **Protocol** | SMB (Server Message Block) |
| **OS compatibility** | Windows and Linux (SMB client) |
| **Active Directory** | Integrates with Microsoft AD (AWS Managed AD or self-managed) |
| **Storage type** | SSD or HDD |
| **Max throughput** | Up to 2 GB/s |
| **Max storage** | Up to 64 TB per file system (multi-AZ can be higher with scale-out) |
| **Deduplication** | Yes (data deduplication saves 50-80% storage) |
| **Encryption** | At rest (KMS) and in transit |
| **Backup** | Automatic daily backups to S3 |
| **Access** | From on-premises via VPN or Direct Connect |

### Multi-AZ Deployment

- **Single-AZ**: One file system in one AZ (lower cost)
- **Multi-AZ**: Active-standby in two AZs (automatic failover)
- Multi-AZ provides high availability for production workloads
- DNS name automatically resolves to the active file server

### DFS Namespaces

- **Distributed File System (DFS) Namespaces**: Group multiple FSx file systems under a single namespace
- Users see a single logical file structure
- Useful for: organizing file shares, scaling beyond single file system limits
- DFS Replication is NOT supported (use AWS DataSync for replication)

### Use Cases

- Windows-based application file storage
- Home directories for Windows users
- .NET application shared configuration
- SQL Server (SMB continuously available shares for SQL Server)
- Media and entertainment workflows (Windows-based)
- Any workload requiring SMB protocol and Windows ACLs

**Exam Tip**: "Windows," "SMB," "Active Directory," "NTFS" → FSx for Windows File Server.

---

## Amazon FSx for Lustre

Fully managed Lustre file system for **high-performance computing** workloads.

### What is Lustre?

Lustre is an open-source parallel distributed file system designed for high-performance computing. It provides sub-millisecond latency and massive throughput.

### Key Features

| Feature | Detail |
|---------|--------|
| **Protocol** | POSIX-compliant (mounted via Lustre client) |
| **OS** | Linux only |
| **Max throughput** | Hundreds of GB/s |
| **Max IOPS** | Millions |
| **Latency** | Sub-millisecond |
| **Storage** | SSD or HDD |
| **S3 integration** | Seamless — can read/write directly to/from S3 |

### Deployment Types

**Scratch:**
- Temporary storage (data is NOT replicated)
- **Highest performance** (burst up to 6x baseline throughput)
- **No data persistence**: If the underlying server fails, data is lost
- Use cases: Short-term processing, temporary computations where data can be re-created from S3

**Persistent:**
- Data is replicated within the same AZ
- Failed files are automatically replaced
- Use cases: Long-term storage, data that must survive hardware failure
- Two sub-types:
  - **Persistent 1**: For long-term storage, general use
  - **Persistent 2**: Higher throughput (up to 1000 MB/s/TiB), better for latency-sensitive workloads

### S3 Integration

- **S3 as a data repository**: Link an FSx for Lustre file system to an S3 bucket
- **Lazy loading**: Data is loaded from S3 on first access (not pre-loaded)
- **S3 data release**: Write results back to S3 using `hsm_archive` commands
- **Auto import**: Automatically import new/changed objects from S3
- **Auto export**: Automatically export new/changed files to S3

**Workflow example:**
1. Raw data stored in S3
2. FSx for Lustre file system linked to S3 bucket
3. HPC cluster reads data from FSx (lazy-loaded from S3 on first access)
4. Processing occurs at Lustre-speed (hundreds of GB/s)
5. Results written back to S3

### Performance

| Deployment | Throughput per TiB | Storage Type |
|------------|-------------------|-------------|
| Scratch | 200 MB/s (burst to 1200 MB/s) | SSD |
| Persistent 1 | 50, 100, 200 MB/s (configurable) | SSD or HDD |
| Persistent 2 | 125, 250, 500, 1000 MB/s (configurable) | SSD |

### Use Cases

- Machine learning training (read training data at high speed)
- High-performance computing (computational fluid dynamics, weather modeling)
- Video processing and rendering
- Financial modeling and risk analysis
- Genomics and life sciences
- Electronic design automation (EDA)

**Exam Tip**: "HPC," "machine learning training data," "high throughput," "Lustre," "computational" → FSx for Lustre. If S3 is the data source for HPC processing → FSx for Lustre with S3 integration.

---

## Amazon FSx for NetApp ONTAP

Fully managed **NetApp ONTAP** file system on AWS — provides enterprise-grade shared storage.

### Key Features

| Feature | Detail |
|---------|--------|
| **Protocols** | NFS, SMB, **iSCSI** (multi-protocol) |
| **OS** | Linux, Windows, macOS |
| **Data management** | Snapshots, clones, replication, compression, deduplication, tiering |
| **Storage tiering** | Automatic tiering between SSD (primary) and capacity pool (S3-backed, cheaper) |
| **Latency** | Sub-millisecond |
| **Max throughput** | Up to 4 GB/s |
| **Multi-AZ** | Yes (HA pairs across AZs) |
| **Encryption** | At rest (KMS) and in transit |

### Storage Tiering

- **SSD tier**: Primary storage for active data (high performance)
- **Capacity pool tier**: Lower-cost storage backed by S3 (for infrequently accessed data)
- Data automatically moves between tiers based on access patterns
- Configurable tiering policy: Auto, Snapshot-only, All, None

### Data Management Features

- **FlexClone**: Create instant, space-efficient clones of volumes (for dev/test)
- **SnapMirror**: Replicate data across FSx file systems (or to on-premises NetApp)
- **Deduplication & Compression**: Reduce storage usage by 50-80%
- **Thin provisioning**: Allocate more capacity than physically available (pay only for what you use)
- **Quotas**: User and group quotas

### Use Cases

- Migrating on-premises NetApp workloads to AWS
- Applications needing multi-protocol access (NFS + SMB + iSCSI)
- Development/test environments (FlexClone for instant copies)
- Workloads benefiting from storage efficiency features (dedup, compression)
- VMware Cloud on AWS (as external datastore)

**Exam Tip**: "NetApp," "multi-protocol," "NFS and SMB," "iSCSI," "data tiering," "SnapMirror" → FSx for NetApp ONTAP.

---

## Amazon FSx for OpenZFS

Fully managed **OpenZFS** file system on AWS.

### Key Features

| Feature | Detail |
|---------|--------|
| **Protocol** | NFS (v3, v4, v4.1, v4.2) |
| **OS** | Linux, Windows (NFS client), macOS |
| **Max throughput** | Up to 12.5 GB/s |
| **Max IOPS** | Up to 1,000,000 |
| **Latency** | Sub-millisecond (up to 0.2 ms) |
| **Compression** | Z-Standard and LZ4 |
| **Snapshots** | Point-in-time, instant, space-efficient |
| **Clones** | Instant clones (like ZFS) |
| **Storage** | SSD |

### Key Capabilities

- **ZFS snapshots**: Point-in-time, instant, minimal overhead
- **ZFS clones**: Writable clones from snapshots (instant, space-efficient)
- **Data compression**: Reduces storage costs
- **No data tiering** (unlike NetApp ONTAP) — SSD only
- **Single-AZ** deployment only (no Multi-AZ option)

### Use Cases

- Migrating on-premises ZFS workloads to AWS
- Applications requiring NFS with high performance
- Workloads needing ZFS features (snapshots, clones)
- Development and testing (instant clones)
- EDA, financial analytics, media processing

**Exam Tip**: "OpenZFS," "ZFS," "NFS with sub-millisecond latency," "instant clones" → FSx for OpenZFS. Does NOT support SMB or iSCSI.

---

## Complete Storage Comparison

### FSx Family Comparison

| Feature | FSx Windows | FSx Lustre | FSx NetApp ONTAP | FSx OpenZFS |
|---------|-------------|-----------|-----------------|-------------|
| **Protocol** | SMB | POSIX/Lustre | NFS, SMB, iSCSI | NFS |
| **OS** | Windows, Linux | Linux | Linux, Windows, macOS | Linux, Windows, macOS |
| **Max throughput** | 2 GB/s | Hundreds of GB/s | 4 GB/s | 12.5 GB/s |
| **Multi-AZ** | Yes | No | Yes | No |
| **S3 integration** | No | Yes (seamless) | No (uses tiering) | No |
| **Active Directory** | Yes (required) | No | Optional | No |
| **Data tiering** | No | No | Yes (SSD ↔ capacity pool) | No |
| **Deduplication** | Yes | No | Yes | No |
| **Compression** | Yes | No | Yes | Yes |
| **Multi-protocol** | SMB only | Lustre only | NFS + SMB + iSCSI | NFS only |
| **Cloning** | No | No | Yes (FlexClone) | Yes (ZFS clone) |
| **Best for** | Windows file shares | HPC, ML training | Enterprise multi-protocol | ZFS migration, NFS |
| **Primary use case** | Enterprise Windows | High-performance compute | Flexible enterprise storage | High-perf NFS |

### All Storage Services Comparison

| Service | Type | Persistence | Shared | Max IOPS | Protocol | Best For |
|---------|------|-------------|--------|----------|----------|----------|
| EBS gp3 | Block | Yes | No* | 16K | Block | General databases, boot |
| EBS io2 BE | Block | Yes | Yes* | 256K | Block | High-perf databases |
| EBS st1 | Block | Yes | No | 500 | Block | Big data throughput |
| Instance Store | Block | No | No | Millions | Block | Cache, temp, highest I/O |
| EFS | File | Yes | Yes | 55K+ | NFS | Shared Linux, CMS, containers |
| FSx Windows | File | Yes | Yes | — | SMB | Windows file shares |
| FSx Lustre | File | Varies | Yes | Millions | Lustre | HPC, ML |
| FSx ONTAP | File/Block | Yes | Yes | — | NFS/SMB/iSCSI | Multi-protocol enterprise |
| FSx OpenZFS | File | Yes | Yes | 1M | NFS | High-perf NFS |
| S3 | Object | Yes | Yes | N/A | HTTP | Static data, backups, lakes |

*EBS Multi-Attach only for io1/io2

---

## Exam Tips & Scenarios

### Scenario 1: High-Performance Database
**Q:** Oracle database requires 100,000 IOPS with sub-millisecond latency.
**A:** EBS io2 Block Express. Supports up to 256,000 IOPS with sub-millisecond latency.

### Scenario 2: Shared Linux File System
**Q:** Multiple EC2 instances across AZs need shared access to the same files (Linux).
**A:** Amazon EFS. Multi-AZ, shared NFS, auto-scaling.

### Scenario 3: Windows File Shares
**Q:** Windows-based applications need shared file storage with Active Directory integration.
**A:** FSx for Windows File Server with AD integration.

### Scenario 4: HPC Data Processing
**Q:** HPC cluster needs to process 100 TB of data stored in S3 at high speed.
**A:** FSx for Lustre linked to the S3 bucket. Data lazy-loaded from S3, processed at Lustre speed.

### Scenario 5: Cost-Effective Boot Volume
**Q:** Need a boot volume for a general-purpose web server. Cost optimization is key.
**A:** EBS gp3. 20% cheaper than gp2 with better baseline performance.

### Scenario 6: Maximum Throughput (Streaming)
**Q:** Data warehouse needs maximum sequential read throughput at lowest cost.
**A:** EBS st1 (Throughput Optimized HDD). Up to 500 MiB/s, HDD pricing.

### Scenario 7: Multi-Protocol Enterprise Storage
**Q:** Application needs to access the same data via NFS, SMB, and iSCSI.
**A:** FSx for NetApp ONTAP. Only FSx option supporting all three protocols.

### Scenario 8: Protecting Snapshots from Deletion
**Q:** Team accidentally deleted critical EBS snapshots. Need to prevent this.
**A:** Enable **Recycle Bin** for EBS snapshots with appropriate retention rules.

### Scenario 9: Encrypting Existing Unencrypted Volume
**Q:** A production EBS volume is unencrypted. Must encrypt it with minimal downtime.
**A:** Create a snapshot → copy snapshot with encryption → create new encrypted volume → stop instance → detach old volume → attach new encrypted volume → start instance.

### Scenario 10: Highest I/O Performance
**Q:** Application needs millions of IOPS for a caching layer. Data loss on instance failure is acceptable.
**A:** Instance store (NVMe SSD). Millions of IOPS, lowest latency, ephemeral.

### Key Exam Patterns

1. **gp3 > gp2** for most new workloads (cheaper, better baseline, independent IOPS/throughput)
2. **io2 Block Express** = highest IOPS (256K) and throughput (4 GB/s) in EBS
3. **Multi-Attach** = io1/io2 only, same AZ, requires cluster-aware filesystem
4. **EBS snapshots** are incremental, stored in S3, can be copied cross-region
5. **Fast Snapshot Restore** = instant full performance (expensive)
6. **EFS** = Linux only, NFS, multi-AZ, elastic, shared
7. **EFS Elastic throughput** is recommended for most EFS workloads
8. **FSx Windows** = SMB + Active Directory. "Windows file share" = this.
9. **FSx Lustre** = HPC + S3 integration. "High performance computing" + S3 = this.
10. **FSx NetApp ONTAP** = multi-protocol (NFS + SMB + iSCSI) + data tiering
11. **FSx OpenZFS** = NFS + instant clones + high performance
12. **st1/sc1 cannot be boot volumes** — only SSD types (gp2/gp3/io1/io2) can be boot volumes
13. **Instance Store** survives reboot but NOT stop/terminate/hardware failure
14. **EBS encryption** = KMS-based, minimal performance impact on Nitro instances
15. **Recycle Bin** = protect snapshots and AMIs from accidental deletion

---

*Previous: [← S3 Deep Dive](11-s3-deep-dive.md) | Next: [Storage Gateway & Data Migration →](13-storage-gateway-migration.md)*
