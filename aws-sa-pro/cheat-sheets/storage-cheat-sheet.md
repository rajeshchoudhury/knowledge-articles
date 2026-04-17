# AWS Storage Cheat Sheet — SAP-C02

> Comprehensive reference for all AWS storage services, classes, features, performance specs, and decision criteria.

---

## Table of Contents

1. [Amazon S3](#1-amazon-s3)
2. [Amazon EBS](#2-amazon-ebs)
3. [Amazon EFS](#3-amazon-efs)
4. [Amazon FSx](#4-amazon-fsx)
5. [AWS Storage Gateway](#5-aws-storage-gateway)
6. [AWS DataSync](#6-aws-datasync)
7. [AWS Transfer Family](#7-aws-transfer-family)
8. [AWS Snow Family](#8-aws-snow-family)
9. [AWS Backup](#9-aws-backup)
10. [Storage Decision Tree](#10-storage-decision-tree)

---

## 1. Amazon S3

### Storage Classes

| Class | Durability | Availability | Min Duration | Retrieval Fee | First Byte | Use Case |
|-------|-----------|-------------|-------------|---------------|------------|----------|
| **S3 Standard** | 11 9s | 99.99% | None | None | ms | Frequently accessed, general purpose |
| **S3 Intelligent-Tiering** | 11 9s | 99.9% | None | None | ms (auto) | Unknown or changing access patterns |
| **S3 Standard-IA** | 11 9s | 99.9% | 30 days | Per GB | ms | Infrequent access, rapid retrieval |
| **S3 One Zone-IA** | 11 9s | 99.5% | 30 days | Per GB | ms | Re-creatable, infrequent, single AZ |
| **S3 Glacier Instant Retrieval** | 11 9s | 99.9% | 90 days | Per GB | ms | Archive with instant access (quarterly) |
| **S3 Glacier Flexible Retrieval** | 11 9s | 99.99% | 90 days | Per GB | 1–12 hrs | Archive with flexible retrieval |
| **S3 Glacier Deep Archive** | 11 9s | 99.99% | 180 days | Per GB | 12–48 hrs | Lowest cost, long-term compliance |

### Intelligent-Tiering Access Tiers

| Tier | Access Pattern | Latency | Auto/Opt-in |
|------|---------------|---------|-------------|
| **Frequent Access** | Default | ms | Automatic |
| **Infrequent Access** | Not accessed for 30 days | ms | Automatic |
| **Archive Instant Access** | Not accessed for 90 days | ms | Automatic |
| **Archive Access** | Not accessed for 90–730 days | 3–5 hrs | Opt-in |
| **Deep Archive Access** | Not accessed for 180–730 days | 12–48 hrs | Opt-in |

No retrieval fees, small monthly monitoring fee per object.

### Glacier Retrieval Options

| Tier | Glacier Flexible | Glacier Deep Archive |
|------|-----------------|---------------------|
| **Expedited** | 1–5 min | N/A |
| **Standard** | 3–5 hrs | 12 hrs |
| **Bulk** | 5–12 hrs | 48 hrs |

**Provisioned capacity:** Reserve expedited retrieval capacity for Glacier Flexible ($100/unit/month, guarantees retrieval within 1–5 min).

### S3 Versioning

- Enabled at the bucket level
- Every PUT creates a new version (unique version ID)
- Delete adds a **delete marker** (object hidden but not deleted)
- Permanent delete requires specifying version ID
- MFA Delete: require MFA to permanently delete versions or change versioning state
- Versioning cannot be disabled once enabled — only suspended

### S3 Replication

| Feature | CRR (Cross-Region Replication) | SRR (Same-Region Replication) |
|---------|-------------------------------|------------------------------|
| **Scope** | Different AWS regions | Same AWS region |
| **Use case** | DR, compliance, latency optimization | Log aggregation, replication between accounts, dev/test |

#### Replication Details

| Feature | Details |
|---------|---------|
| **Requirements** | Versioning enabled on source AND destination |
| **Existing objects** | NOT replicated by default (use S3 Batch Replication) |
| **Delete markers** | NOT replicated by default (can be enabled) |
| **Permanent deletes** | NOT replicated (prevents cascading deletion) |
| **Chaining** | No chaining — A→B, B→C does NOT replicate A→C |
| **Bi-directional** | Supported (configure both directions) |
| **Encryption** | SSE-S3, SSE-KMS (need proper KMS permissions), SSE-C (not supported) |
| **Replication Time Control (RTC)** | 99.99% of objects replicated within 15 minutes (SLA) |

### S3 Lifecycle Policies

- Transition actions: Move objects between storage classes
- Expiration actions: Delete objects or delete markers
- Can filter by prefix and/or tags
- Days counted from object creation date (or last modified with filters)

#### Lifecycle Transition Waterfall

```
Standard → Standard-IA (≥30 days) → One Zone-IA → Glacier Instant (≥90 days)
→ Glacier Flexible (≥90 days) → Glacier Deep Archive (≥180 days)
```

**Minimum 30 days** before transitioning from Standard to any IA class. Minimum days are cumulative.

### S3 Object Lock

| Mode | Can Override? | Use Case |
|------|---------------|----------|
| **Governance** | Yes (with `s3:BypassGovernanceRetention` permission) | Organizational compliance, testing |
| **Compliance** | No (not even root account) | Regulatory compliance (SEC 17a-4, FINRA) |
| **Legal Hold** | Yes (with `s3:PutObjectLegalHold`) | Litigation hold, no expiry date |

- Requires versioning enabled
- Retention period set per object version (days/years)
- Bucket-level default retention settings available

### S3 Access Points

- Simplified access management for shared datasets
- Each access point has its own DNS name and policy
- **VPC access points:** Restrict access to a specific VPC
- **Internet access points:** Accessible from the internet
- Can delegate access management to different teams/apps

### S3 Multi-Region Access Points (MRAP)

- Single global endpoint that routes to the nearest S3 bucket
- Requires **S3 Replication** (CRR) between participating buckets
- **Failover controls:** Route traffic away from a region (active-passive)
- Supports **AWS Global Accelerator** for optimized routing
- Use case: Global applications with low-latency access, multi-region resilience

### S3 Select & S3 Object Lambda

| Feature | S3 Select | S3 Object Lambda |
|---------|-----------|-----------------|
| **Purpose** | Filter S3 data with SQL (retrieve subset of object) | Transform data on retrieval |
| **Input** | CSV, JSON, Parquet | Any object |
| **Processing** | Server-side (S3) | Lambda function |
| **Use case** | Reduce data transfer (only get needed fields/rows) | Redact PII, decompress, watermark images |

### S3 Batch Operations

- Perform operations on billions of objects at scale
- Operations: copy, invoke Lambda, restore from Glacier, replace tags, replace ACLs, Object Lock
- Input: S3 Inventory report or CSV manifest
- Built-in retry and progress tracking
- Use case: Bulk tagging, encrypting existing objects, restoring archives

### S3 Event Notifications

| Destination | Details |
|-------------|---------|
| **SNS** | Publish to topic |
| **SQS** | Send to queue |
| **Lambda** | Invoke function |
| **EventBridge** | All S3 events to EventBridge (most flexible) |

Event types: `s3:ObjectCreated:*`, `s3:ObjectRemoved:*`, `s3:ObjectRestore:*`, `s3:Replication:*`, `s3:LifecycleTransition`, etc.

**EventBridge vs direct notifications:** EventBridge supports filtering, multiple targets, archive/replay, cross-account — prefer for complex workflows.

### S3 Inventory

- Daily or weekly report of objects and metadata
- Output: CSV, ORC, or Parquet to S3
- Includes: key, size, last modified, storage class, encryption status, replication status
- Use case: Audit compliance, lifecycle planning, input for Batch Operations

### S3 Analytics — Storage Class Analysis

- Recommends when to transition objects to IA
- 30+ days of data needed for recommendations
- Per prefix/tag filtering
- Use case: Optimize storage class before creating lifecycle policies

### S3 Storage Lens

- Organization-wide visibility into storage usage and activity
- Metrics: total storage, object count, request counts, errors, cost optimization
- Dashboard: default (free) or advanced (paid — 15 months retention, prefix-level, CloudWatch publishing)
- Multi-account aggregation via Organizations

### S3 Performance Optimization

| Feature | Details |
|---------|---------|
| **Request rate** | 5,500 GET/s and 3,500 PUT/s per prefix (unlimited prefixes) |
| **Multipart upload** | Required for >5 GB, recommended for >100 MB |
| **S3 Transfer Acceleration** | Upload via CloudFront edge locations to S3 |
| **Byte-range fetches** | Parallelize downloads by requesting byte ranges |
| **S3 Express One Zone** | Single-digit ms latency, co-located with compute in AZ |

### S3 Limits

| Limit | Value |
|-------|-------|
| Max object size | 5 TB |
| Max single PUT | 5 GB |
| Multipart upload min part | 5 MB (except last part) |
| Max parts per multipart | 10,000 |
| Buckets per account | 100 (soft limit, up to 1,000) |
| Object key length | 1,024 bytes |
| Metadata per object | 2 KB |
| Tags per object | 10 |
| Lifecycle rules per bucket | 1,000 |

---

## 2. Amazon EBS

### Volume Types

| Type | Category | IOPS | Throughput | Size | Use Case |
|------|----------|------|-----------|------|----------|
| **gp3** | General Purpose SSD | 3,000 baseline, up to 16,000 | 125 MiB/s baseline, up to 1,000 MiB/s | 1 GiB–16 TiB | Most workloads, boot volumes |
| **gp2** | General Purpose SSD | 3 IOPS/GiB (100–16,000), burst to 3,000 | Up to 250 MiB/s | 1 GiB–16 TiB | Legacy (prefer gp3) |
| **io2** | Provisioned IOPS SSD | Up to 64,000 | Up to 1,000 MiB/s | 4 GiB–16 TiB | I/O-intensive (databases) |
| **io2 Block Express** | Provisioned IOPS SSD | Up to 256,000 | Up to 4,000 MiB/s | 4 GiB–64 TiB | Highest performance (large databases) |
| **st1** | Throughput Optimized HDD | N/A | 500 MiB/s baseline (40 MiB/s per TiB) | 125 GiB–16 TiB | Big data, data warehousing, log processing |
| **sc1** | Cold HDD | N/A | 250 MiB/s baseline (12 MiB/s per TiB) | 125 GiB–16 TiB | Infrequently accessed, lowest cost |

#### Key Exam Points

- **gp3 vs gp2:** gp3 has independent IOPS and throughput provisioning (no burst credit system), gp3 is 20% cheaper
- **io2 vs io1:** io2 has same cost as io1 but 99.999% durability (vs 99.8%), higher IOPS/GiB ratio (500 vs 50)
- **io2 Block Express:** Only supported on Nitro-based instances (r5b, etc.)
- **st1 and sc1:** Cannot be boot volumes

### EBS Snapshots

| Feature | Details |
|---------|---------|
| **Storage** | Stored in S3 (managed by AWS, not visible in your bucket) |
| **Incremental** | Only changed blocks stored after first snapshot |
| **Cross-region** | Copy snapshots to other regions |
| **Cross-account** | Share snapshots with other accounts (modify permissions) |
| **Encryption** | Snapshots of encrypted volumes are encrypted; can copy unencrypted → encrypted |
| **Archive** | Move snapshots to archive tier (75% cheaper, 24–72 hrs restore) |
| **Recycle Bin** | Protect against accidental deletion (retention rules) |

### Fast Snapshot Restore (FSR)

- Eliminates latency on first access of blocks from snapshot
- Without FSR: first read is slower (blocks fetched from S3 on-demand)
- Enable per AZ (billed per AZ per hour)
- Use case: Boot volumes that need immediate full performance, databases restored from snapshot

### EBS Encryption

- AES-256 encryption using KMS
- Encryption at creation or by copying unencrypted snapshot as encrypted
- **Cannot encrypt existing unencrypted volume directly:**
  1. Create snapshot (unencrypted)
  2. Copy snapshot with encryption enabled
  3. Create new volume from encrypted snapshot
  4. Attach new volume
- **Default encryption:** Enable per-account per-region (all new volumes encrypted)
- Encrypted volume → snapshot → AMI → new volume: all encrypted with same key (or different key on copy)

### EBS Multi-Attach

- Attach a single **io2** volume to up to **16 Nitro instances** in the same AZ
- All instances have full read/write access
- Must use cluster-aware file system (not ext4/XFS)
- Use case: Clustered applications, HA for applications managing concurrent writes

### Instance Store

| Feature | Details |
|---------|---------|
| **Type** | Physically attached block storage (NVMe SSD or HDD) |
| **Persistence** | Ephemeral — data lost on stop, terminate, or hardware failure |
| **Performance** | Highest IOPS (millions of IOPS for i3/i3en/d2) |
| **Cost** | Included in instance price |
| **Use case** | Temporary storage, buffers, caches, scratch data |

---

## 3. Amazon EFS

### Key Characteristics

| Feature | Details |
|---------|---------|
| **Type** | Managed NFS v4.1 file system |
| **Access** | Multiple EC2, Lambda, ECS, EKS across AZs and VPCs |
| **Scaling** | Automatic (petabyte scale) |
| **Durability** | 11 9s (data stored across 3+ AZs) |
| **Availability** | Regional (99.99%) or One Zone (99.9%) |

### Performance Modes

| Mode | Latency | Throughput | Use Case |
|------|---------|-----------|----------|
| **General Purpose** | Lowest latency (<1 ms) | Moderate | Web serving, CMS, home directories |
| **Max I/O** | Higher latency | Highest aggregate throughput | Big data, media processing, HPC (legacy — prefer Elastic throughput) |

### Throughput Modes

| Mode | Throughput | Scaling | Use Case |
|------|-----------|---------|----------|
| **Bursting** | Scales with storage (50 MiB/s per TiB + burst) | Automatic (burst credits) | Small to medium workloads |
| **Provisioned** | Set throughput independent of storage | Manual (you choose) | Known high-throughput needs |
| **Elastic** | Automatically scales up to 10+ GiB/s | Automatic (pay per use) | Spiky or unpredictable workloads (recommended) |

### EFS Storage Classes

| Class | Availability | Cost | Access |
|-------|-------------|------|--------|
| **EFS Standard** | Multi-AZ | $$$ | Immediate |
| **EFS Standard-IA** | Multi-AZ | $ (storage) + access fee | Immediate |
| **EFS One Zone** | Single AZ | $$ | Immediate |
| **EFS One Zone-IA** | Single AZ | $ (storage) + access fee | Immediate |

### EFS Lifecycle Management

- Automatically move files to IA (Infrequent Access) tier based on last access
- Configurable: 7, 14, 30, 60, 90, 180, 270, or 365 days
- Transition back to Standard on access (configurable)
- Saves up to 92% on storage costs

### EFS Replication

- Automatic replication to another region or same region
- RPO ~15 minutes
- Use case: DR, cross-region data availability

### EFS Access Points

- Application-specific entry points with enforced POSIX user, group, and directory
- Simplify access management for multi-tenant or multi-application setups
- Enforce root directory per access point
- IAM-based mount authorization

### EFS Security

| Feature | Details |
|---------|---------|
| **Encryption at-rest** | KMS (enabled at creation — cannot be changed later) |
| **Encryption in-transit** | TLS (mount helper with `-o tls`) |
| **IAM** | IAM policies for mount authorization |
| **Security Groups** | Applied to mount targets (ENIs) |
| **POSIX** | User and group-level permissions |

### EFS vs EBS

| Feature | EFS | EBS |
|---------|-----|-----|
| Access | Multi-AZ, multi-instance, multi-VPC | Single AZ, single instance (except io2 multi-attach) |
| Protocol | NFS v4.1 | Block device |
| Scaling | Automatic (petabytes) | Fixed size (resize manually) |
| Cost | Higher per GB | Lower per GB |
| Performance | Elastic or provisioned throughput | Consistent IOPS per volume |
| Use case | Shared file storage | Single-instance databases, boot volumes |

---

## 4. Amazon FSx

### FSx for Windows File Server

| Feature | Details |
|---------|---------|
| **Protocol** | SMB (+ NFS with multi-protocol — via ONTAP only) |
| **Integration** | Active Directory (AWS Managed AD or self-managed AD) |
| **DFS** | Distributed File System Namespaces support |
| **Performance** | Up to 2 GB/s throughput, millions of IOPS |
| **Storage** | SSD or HDD, up to 64 TiB per file system |
| **HA** | Multi-AZ (automatic failover) or Single-AZ |
| **Backup** | Daily automated backups to S3 |
| **Data deduplication** | Yes |
| **Shadow copies** | Yes (VSS — end-user file restore) |
| **Encryption** | KMS at-rest, SMB encryption in-transit |
| **Quotas** | User-level storage quotas |
| **Use case** | Windows workloads, AD-dependent apps, SQL Server, .NET, home directories |

### FSx for Lustre

| Feature | Details |
|---------|---------|
| **Protocol** | POSIX-compliant (Lustre) |
| **Performance** | 100s of GB/s throughput, millions of IOPS |
| **Storage** | SSD (higher IOPS) or HDD (higher throughput per $) |
| **Deployment types** | Scratch (temporary, highest throughput, no replication) or Persistent (replicated within AZ, long-running) |

| Deployment | Durability | Availability | Use Case |
|-----------|-----------|-------------|----------|
| **Scratch** | No replication | Single AZ | Short-term processing, temporary data, cost-sensitive HPC |
| **Persistent 1** | Replicated within AZ | Single AZ | Long-term storage, sensitive data |
| **Persistent 2** | Replicated within AZ (higher durability) | Single AZ | Long-term, most sensitive data |

#### S3 Integration

- FSx for Lustre can be **linked to an S3 bucket**
- Transparently presents S3 objects as files
- Lazy loading: files loaded from S3 on first access
- Batch data import: `hsm_restore` and metadata import
- Auto-export: Write changes back to S3 automatically
- Use case: Process S3 data with high-performance compute, then write results back

### FSx for NetApp ONTAP

| Feature | Details |
|---------|---------|
| **Protocol** | NFS, SMB, iSCSI (multi-protocol simultaneously) |
| **Features** | Snapshots, clones, FlexClones, replication (SnapMirror), deduplication, compression, data tiering |
| **Storage tiering** | Automatic tiering to capacity pool (S3-backed) |
| **Multi-AZ** | Yes (HA pairs) |
| **Max capacity** | Petabytes |
| **Use case** | Multi-protocol access, Linux + Windows mixed, data tiering, migration from NetApp on-prem |

### FSx for OpenZFS

| Feature | Details |
|---------|---------|
| **Protocol** | NFS v3/v4, v4.1, v4.2 |
| **Features** | Snapshots, clones, compression (up to 4x), point-in-time snapshots |
| **Performance** | Up to 12.5 GB/s throughput, 1M IOPS |
| **Use case** | Linux workloads needing ZFS features, migration from on-prem ZFS |

### FSx Comparison

| Feature | FSx Windows | FSx Lustre | FSx ONTAP | FSx OpenZFS |
|---------|-------------|------------|-----------|-------------|
| **Protocol** | SMB | POSIX/Lustre | NFS, SMB, iSCSI | NFS |
| **OS** | Windows | Linux | Linux + Windows | Linux |
| **AD integration** | Yes | No | Optional | No |
| **S3 integration** | No | Yes (linked) | No | No |
| **Multi-AZ** | Yes | No (single AZ) | Yes | No (single AZ) |
| **Multi-protocol** | SMB only | POSIX only | NFS + SMB + iSCSI | NFS only |
| **Data tiering** | No | No | Yes (auto to S3) | No |
| **Best for** | Windows workloads | HPC, ML, video | Mixed, NetApp migration | Linux ZFS workloads |

---

## 5. AWS Storage Gateway

### Gateway Types

#### S3 File Gateway

| Feature | Details |
|---------|---------|
| **Protocol** | NFS v3/v4.1, SMB |
| **Backend** | S3 Standard, Standard-IA, One Zone-IA, Intelligent-Tiering |
| **Cache** | Local SSD cache for frequently accessed data |
| **Architecture** | On-prem VM/hardware → cache → S3 (via HTTPS) |
| **Lifecycle** | Can use S3 lifecycle policies to transition to Glacier |
| **Use case** | Cloud-backed file shares, data lake ingestion, backup to S3 |
| **Active Directory** | SMB shares can integrate with AD |

**Key point:** Files stored as **objects** in S3 (not as files) — accessible via S3 API.

#### FSx File Gateway

| Feature | Details |
|---------|---------|
| **Protocol** | SMB |
| **Backend** | FSx for Windows File Server |
| **Cache** | Local cache for low-latency access from on-prem |
| **Use case** | Low-latency on-prem access to FSx Windows shares |

#### Volume Gateway — Cached Volumes

| Feature | Details |
|---------|---------|
| **Protocol** | iSCSI |
| **Primary data** | S3 (full dataset in cloud) |
| **Cache** | Frequently accessed data cached locally |
| **Max volume** | 32 TiB per volume, 32 volumes per gateway (1 PiB total) |
| **Snapshots** | EBS snapshots stored in S3 (can restore as EBS volume) |
| **Use case** | Primary data in cloud, local cache for performance |

#### Volume Gateway — Stored Volumes

| Feature | Details |
|---------|---------|
| **Protocol** | iSCSI |
| **Primary data** | On-premises (full dataset stored locally) |
| **Backup** | Asynchronous backup to S3 as EBS snapshots |
| **Max volume** | 16 TiB per volume, 32 volumes per gateway (512 TiB total) |
| **Use case** | Primary data on-prem with cloud backup, DR |

#### Tape Gateway (VTL — Virtual Tape Library)

| Feature | Details |
|---------|---------|
| **Protocol** | iSCSI VTL (compatible with existing backup software) |
| **Backend** | S3 (virtual tapes) → Glacier Flexible / Deep Archive (archived tapes) |
| **Tape size** | 100 GiB–5 TiB per virtual tape |
| **Max tapes** | 1,500 (in library) + unlimited in vault (archived) |
| **Compatible** | Veeam, Veritas NetBackup, Commvault, Dell EMC, etc. |
| **Use case** | Replace physical tape backup with cloud, compliance archival |

### Storage Gateway Deployment Options

| Deployment | Details |
|-----------|---------|
| **On-premises VM** | VMware ESXi, Microsoft Hyper-V, Linux KVM |
| **Hardware appliance** | Pre-configured Dell PowerEdge server from AWS |
| **EC2 instance** | Run in AWS (for AWS-to-AWS scenarios or testing) |

### Storage Gateway Summary

| Type | Protocol | Cache | Backend | Use Case |
|------|----------|-------|---------|----------|
| S3 File | NFS/SMB | Local SSD | S3 | File shares backed by S3 |
| FSx File | SMB | Local cache | FSx Windows | Low-latency FSx access from on-prem |
| Volume (Cached) | iSCSI | Frequent data | S3 | Cloud-primary with local cache |
| Volume (Stored) | iSCSI | Full dataset local | S3 (backup) | On-prem primary with cloud backup |
| Tape (VTL) | iSCSI VTL | Local | S3/Glacier | Replace physical tape infrastructure |

---

## 6. AWS DataSync

### Key Characteristics

| Feature | Details |
|---------|---------|
| **Purpose** | Automated data transfer service (online) |
| **Speed** | Up to 10 Gbps, 10x faster than open-source tools |
| **Protocol** | NFS, SMB, HDFS, self-managed object storage, S3, EFS, FSx |
| **Agent** | Required for on-prem sources (runs as VM) |
| **Agentless** | AWS-to-AWS transfers (S3 ↔ EFS, EFS ↔ EFS, etc.) |
| **Encryption** | TLS in-transit, encryption at-rest at destination |
| **Verification** | Data integrity verification (checksums) |
| **Bandwidth** | Throttling supported (limit bandwidth usage) |

### DataSync Architecture

```
On-Prem NFS/SMB ──→ DataSync Agent (VM) ──→ TLS over internet/DX ──→ S3/EFS/FSx
```

### Task Scheduling and Filtering

| Feature | Details |
|---------|---------|
| **Scheduling** | Cron-based schedules (hourly, daily, weekly, custom) |
| **Filtering** | Include/exclude filters (by path pattern) |
| **Transfer mode** | Transfer only changed data (incremental) or all data |
| **Preserves** | Metadata, permissions, timestamps, symlinks |
| **Verification** | Post-transfer checksum verification |

### DataSync Locations (Source → Destination)

| Source | Destination |
|--------|-------------|
| On-prem NFS/SMB | S3, EFS, FSx |
| On-prem HDFS | S3 |
| S3 | S3, EFS, FSx |
| EFS | S3, EFS, FSx |
| FSx | S3, EFS, FSx |
| Other cloud storage | S3 |

### DataSync vs Storage Gateway vs Transfer Family

| Feature | DataSync | Storage Gateway | Transfer Family |
|---------|----------|----------------|-----------------|
| **Purpose** | Data migration/sync | Hybrid cloud storage | File transfer protocol |
| **Pattern** | One-time or scheduled sync | Continuous hybrid access | Ongoing protocol-based transfer |
| **Caching** | No | Yes (local cache) | No |
| **Protocols** | Agent + NFS/SMB/HDFS | NFS/SMB/iSCSI/VTL | SFTP/FTPS/FTP/AS2 |
| **Use case** | Migrate data, sync datasets | Extend on-prem to cloud | Replace SFTP server, B2B transfer |

---

## 7. AWS Transfer Family

### Supported Protocols

| Protocol | Port | Use Case |
|----------|------|----------|
| **SFTP** (SSH File Transfer Protocol) | 22 | Secure file transfer (most common) |
| **FTPS** (FTP over SSL) | 21, data ports | Legacy FTP with TLS |
| **FTP** (plain) | 21 | Legacy, unencrypted (internal only) |
| **AS2** (Applicability Statement 2) | 443 | B2B EDI, supply chain (HIPAA, PCI) |

### Backend Storage

| Destination | Details |
|-------------|---------|
| **S3** | Store files as S3 objects |
| **EFS** | Store files in EFS file system |

### Key Features

| Feature | Details |
|---------|---------|
| **Authentication** | AWS Transfer service-managed (SSH keys), AWS Directory Service (AD), custom IdP (Lambda-backed) |
| **Endpoint types** | Public, VPC (internal or internet-facing with EIP) |
| **DNS** | Custom hostname with Route 53 |
| **Managed workflows** | Post-upload processing (copy, tag, decrypt, custom Lambda step) |
| **Logging** | CloudWatch Logs |
| **Compliance** | HIPAA, PCI, SOC |

---

## 8. AWS Snow Family

### Device Comparison

| Feature | Snowcone | Snowcone SSD | Snowball Edge Storage Optimized | Snowball Edge Compute Optimized | Snowmobile |
|---------|----------|-------------|--------------------------------|-------------------------------|------------|
| **Storage** | 8 TB HDD | 14 TB SSD | 80 TB usable (210 TB total) | 42 TB (28 TB usable NVMe) | 100 PB |
| **Compute** | 2 vCPU, 4 GB RAM | 2 vCPU, 4 GB RAM | 40 vCPU, 80 GB RAM | 104 vCPU, 416 GB RAM + optional GPU | N/A |
| **Weight** | 4.5 lbs (2 kg) | 4.5 lbs (2 kg) | 49.7 lbs (22.5 kg) | Shipping container (truck) |
| **Form factor** | Ruggedized, portable | Ruggedized, portable | Suitcase-sized | 45-foot shipping container |
| **Network** | 2× 1G/10G | 2× 1G/10G | 1× 25G, 1× 100G (or 4× 25G) | N/A |
| **EC2** | No | No | Yes (sbe1.*, sbe-c.*) | Yes (sbe-c.*) + optional GPU |
| **Lambda** | No | No | Yes (via IoT Greengrass) | No |
| **Clustering** | No | No | Yes (5–10 devices) | No |
| **Use case** | Edge compute, small migration, IoT | Edge compute, small migration | Large migration, edge storage | Massive migration (exabyte-scale) |

### When to Use Each

| Data Size | Recommended Device |
|-----------|--------------------|
| Up to 8 TB | Snowcone |
| Up to 14 TB (SSD needed) | Snowcone SSD |
| 10 TB – 80 TB | Snowball Edge Storage Optimized |
| 80 TB – 10 PB | Multiple Snowball Edge devices |
| 10 PB – 100 PB | Snowmobile |
| Edge compute needed | Snowball Edge Compute Optimized or Snowcone |

### Snow Family Process

1. Order device via AWS console
2. AWS ships device to you
3. Connect to local network, load data (NFS, S3 adapter)
4. Ship device back to AWS
5. AWS loads data into S3
6. Device is securely wiped (NIST 800-88)

### OpsHub

- GUI application for managing Snow Family devices
- Install on local computer
- Configure devices, transfer data, manage EC2 instances
- Alternative to CLI-based management

### Data Transfer Encryption

- All data encrypted with KMS keys before leaving your premises
- 256-bit encryption
- Tamper-evident enclosures, TPM chip
- E-ink shipping label

---

## 9. AWS Backup

### Key Features

| Feature | Details |
|---------|---------|
| **Centralized** | Single console to manage backups across AWS services |
| **Policy-based** | Backup plans with schedules, retention, lifecycle |
| **Cross-account** | Backup to vaults in different accounts (Organizations) |
| **Cross-region** | Copy backups to other regions |
| **Supported services** | EC2, EBS, RDS, Aurora, DynamoDB, EFS, FSx, S3, Neptune, DocumentDB, Storage Gateway, VMware on AWS, Redshift, SAP HANA, Timestream |

### Backup Components

| Component | Description |
|-----------|-------------|
| **Backup Plan** | Schedule + retention + lifecycle + copy rules |
| **Backup Vault** | Storage container for backups (encrypted with KMS) |
| **Recovery Point** | Individual backup (snapshot, image, etc.) |
| **Protected Resource** | AWS resource associated with a backup plan |

### Backup Vault Lock

| Mode | Description |
|------|-------------|
| **Governance** | Admin with specific IAM permissions can manage vault lock settings |
| **Compliance** | WORM — once locked, nobody can delete backups (including root), no changes to policy |

- **Compliance mode:** Cannot be deleted during retention period, even by root
- Use case: Regulatory compliance (SEC 17a-4, CFTC, FINRA)
- **Additional protection:** Max retention, min retention settings

### AWS Backup for Organizations

- **Backup policies** defined at Organization level (OUs)
- Automatically apply to all accounts in the OU
- Cross-account backup to centralized vault
- Delegated administrator for backup management

### Backup Audit Manager

- Continuously monitor backup compliance
- Built-in frameworks: backup frequency, retention, cross-region, cross-account, encryption
- Custom frameworks available
- Generate audit-ready reports

---

## 10. Storage Decision Tree

### "I need to store..."

```
OBJECTS (files, images, videos, backups, data lake)?
└── → S3
    ├── Frequently accessed → S3 Standard
    ├── Unknown pattern → S3 Intelligent-Tiering
    ├── Infrequent, rapid access → S3 Standard-IA
    ├── Re-creatable, infrequent → S3 One Zone-IA
    ├── Archive, instant access → Glacier Instant Retrieval
    ├── Archive, flexible retrieval → Glacier Flexible Retrieval
    └── Long-term compliance archive → Glacier Deep Archive

BLOCK STORAGE (databases, boot volumes)?
└── → EBS
    ├── General purpose → gp3
    ├── High IOPS → io2 / io2 Block Express
    ├── High throughput, big data → st1
    ├── Lowest cost, cold → sc1
    └── Highest IOPS, ephemeral → Instance Store

SHARED FILE STORAGE?
├── NFS (Linux) → EFS
├── SMB (Windows, AD) → FSx for Windows
├── HPC/ML (Lustre) → FSx for Lustre
├── Multi-protocol (NFS + SMB + iSCSI) → FSx for NetApp ONTAP
└── Linux with ZFS features → FSx for OpenZFS

HYBRID (on-prem + cloud)?
├── File shares backed by S3 → S3 File Gateway
├── Low-latency FSx access from on-prem → FSx File Gateway
├── iSCSI block, primary in cloud → Volume Gateway (Cached)
├── iSCSI block, primary on-prem → Volume Gateway (Stored)
└── Replace tape backup → Tape Gateway
```

### "I need to transfer data..."

```
One-time migration or scheduled sync?
├── Files (NFS/SMB/HDFS) → DataSync
├── Database → DMS
├── Large dataset (>10 TB, slow network) → Snowball Edge
├── Massive dataset (>10 PB) → Snowmobile
├── SFTP/FTPS protocol needed → Transfer Family
└── S3 to S3 replication → S3 Replication (CRR/SRR)

Ongoing hybrid access?
└── → Storage Gateway (appropriate type)
```

### Exam Scenario Quick Reference

| Scenario | Answer |
|----------|--------|
| "Store unlimited objects, 11 9s durability" | S3 |
| "Archive data, retrieve in 12 hours" | S3 Glacier Flexible Retrieval (Standard) |
| "Archive data, retrieve in milliseconds" | S3 Glacier Instant Retrieval |
| "Compliance archive, 7-year retention, WORM" | S3 Glacier + Object Lock (Compliance mode) |
| "High-performance shared Linux file system" | EFS (or FSx for Lustre if HPC) |
| "Windows file shares with AD integration" | FSx for Windows File Server |
| "HPC compute with S3 data" | FSx for Lustre (linked to S3) |
| "Replace NFS + SMB on-prem NAS" | FSx for NetApp ONTAP |
| "Migrate 50 TB file server to S3" | DataSync |
| "Migrate 500 TB offline" | Multiple Snowball Edge devices |
| "On-prem apps need iSCSI with cloud backup" | Volume Gateway (Stored) |
| "Cloud-primary iSCSI with local cache" | Volume Gateway (Cached) |
| "Replace tape backup infrastructure" | Tape Gateway |
| "SFTP server for partner file exchange" | Transfer Family |
| "Centralized backup across 50 accounts" | AWS Backup (Organization policies) |
| "Immutable backups, compliance" | AWS Backup Vault Lock (Compliance mode) |
| "Boot volume for EC2, general purpose" | EBS gp3 |
| "Database on EC2 needing 100K+ IOPS" | EBS io2 Block Express |
| "Temporary scratch data, highest IOPS" | Instance Store |
