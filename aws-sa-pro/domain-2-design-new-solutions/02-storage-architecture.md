# Domain 2 – Design for New Solutions: Storage Architecture

## AWS Certified Solutions Architect – Professional (SAP-C02)

---

## Table of Contents

1. [S3 Deep Dive](#1-s3-deep-dive)
2. [S3 Security](#2-s3-security)
3. [S3 Performance Optimization](#3-s3-performance-optimization)
4. [EBS Deep Dive](#4-ebs-deep-dive)
5. [EFS Deep Dive](#5-efs-deep-dive)
6. [FSx Deep Dive](#6-fsx-deep-dive)
7. [Storage Gateway](#7-storage-gateway)
8. [Data Transfer Services Comparison](#8-data-transfer-services-comparison)
9. [AWS Backup](#9-aws-backup)
10. [Storage Selection Decision Framework](#10-storage-selection-decision-framework)

---

## 1. S3 Deep Dive

### Storage Classes

| Storage Class | Durability | Availability | Min Duration | Retrieval Fee | Use Case |
|--------------|-----------|--------------|-------------|---------------|----------|
| S3 Standard | 99.999999999% (11 9s) | 99.99% | None | None | Frequently accessed data |
| S3 Intelligent-Tiering | 11 9s | 99.9% | None | None | Unknown/changing access patterns |
| S3 Standard-IA | 11 9s | 99.9% | 30 days | Per-GB | Infrequently accessed, rapid access |
| S3 One Zone-IA | 11 9s | 99.5% | 30 days | Per-GB | Reproducible, infrequently accessed |
| S3 Glacier Instant Retrieval | 11 9s | 99.9% | 90 days | Per-GB (higher) | Archive with millisecond access |
| S3 Glacier Flexible Retrieval | 11 9s | 99.99% (after restore) | 90 days | Per-GB | Archive, minutes to hours retrieval |
| S3 Glacier Deep Archive | 11 9s | 99.99% (after restore) | 180 days | Per-GB | Lowest cost, 12-48 hour retrieval |
| S3 Express One Zone | 11 9s (single AZ) | 99.95% | None | None | Lowest latency, single-digit ms |

### S3 Intelligent-Tiering

Automatically moves objects between access tiers based on access patterns — no retrieval fees.

**Tiers within Intelligent-Tiering:**
1. **Frequent Access** (default, automatic): Objects accessed regularly
2. **Infrequent Access** (automatic, after 30 days): Objects not accessed for 30 days
3. **Archive Instant Access** (automatic, after 90 days): Objects not accessed for 90 days
4. **Archive Access** (optional, configurable 90-730 days): Must opt-in
5. **Deep Archive Access** (optional, configurable 180-730 days): Must opt-in

**Cost:** Small monthly monitoring/automation fee per object (no retrieval fees)

> **Exam Tip:** Intelligent-Tiering is the recommended class when access patterns are unpredictable. The optional archive tiers must be explicitly enabled. There are NO retrieval fees — this is a key differentiator from IA classes.

### Lifecycle Policies

Transition and expiration rules for objects:

```
S3 Standard
    │ (30 days)
    ▼
S3 Standard-IA
    │ (60 days)
    ▼
S3 Glacier Instant Retrieval
    │ (90 days)
    ▼
S3 Glacier Flexible Retrieval
    │ (180 days)
    ▼
S3 Glacier Deep Archive
    │ (365 days)
    ▼
  DELETE
```

**Transition constraints (waterfall):**
- Standard → Any class
- Standard-IA → One Zone-IA, Glacier Instant, Glacier Flexible, Deep Archive
- Glacier Instant → Glacier Flexible, Deep Archive
- Glacier Flexible → Deep Archive
- Cannot transition back "up" via lifecycle (use S3 Batch Operations to copy back)

**Key rules:**
- Minimum 30 days in Standard before transition to IA
- Minimum 30 days in Standard-IA before transition to Glacier
- Objects smaller than 128 KB are not transitioned to IA classes (charged as 128 KB min)
- Lifecycle rules can apply to: prefix, tags, entire bucket, current/noncurrent versions

```json
{
  "Rules": [
    {
      "ID": "TransitionRule",
      "Status": "Enabled",
      "Filter": { "Prefix": "logs/" },
      "Transitions": [
        { "Days": 30, "StorageClass": "STANDARD_IA" },
        { "Days": 90, "StorageClass": "GLACIER" },
        { "Days": 365, "StorageClass": "DEEP_ARCHIVE" }
      ],
      "Expiration": { "Days": 730 },
      "NoncurrentVersionTransitions": [
        { "NoncurrentDays": 30, "StorageClass": "GLACIER" }
      ],
      "NoncurrentVersionExpiration": { "NoncurrentDays": 90 }
    }
  ]
}
```

### Replication

**Cross-Region Replication (CRR):**
- Replicate objects across AWS Regions
- Use cases: Compliance, lower latency access, cross-account replication

**Same-Region Replication (SRR):**
- Replicate within the same Region
- Use cases: Log aggregation, live replication between prod/test accounts

**Replication requirements:**
- Source and destination must have versioning enabled
- S3 must have IAM permissions to replicate on your behalf
- Can replicate across accounts (configure bucket policy on destination)

**Replication features:**
- **Replication Time Control (RTC):** SLA to replicate 99.99% of objects within 15 minutes
- **S3 Replication Metrics:** Track replication progress via CloudWatch
- **Delete marker replication:** Optional (disabled by default)
- **Bi-directional replication:** Configure rules in both directions
- **Existing objects:** Use S3 Batch Replication (replication rules only apply to new objects by default)

**What is NOT replicated:**
- Objects before replication was enabled (use Batch Replication)
- Objects encrypted with SSE-C (must re-encrypt)
- Objects in Glacier/Deep Archive classes
- Delete markers (unless explicitly enabled)
- Deletes of specific versions (version ID deletes)

### Versioning

- **Enabled:** All object versions preserved. Deleting adds a delete marker (recoverable). Each version has a unique version ID.
- **Suspended:** New objects get `null` version ID. Existing versions are preserved.
- **Cannot disable** versioning once enabled — only suspend

**MFA Delete:**
- Requires MFA to: Delete object versions permanently, change versioning state
- Can only be enabled/disabled by the root account via CLI (not console)
- Additional protection against accidental/malicious deletions

### Object Lock

Prevents object deletion or overwriting for a specified period (WORM model).

**Modes:**

| Mode | Description | Who Can Delete |
|------|-------------|---------------|
| Governance Mode | Protected with override capability | Users with `s3:BypassGovernanceRetention` permission |
| Compliance Mode | No one can delete or overwrite, including root | NO ONE (not even root) until retention expires |

**Retention period:** Set per-object, defines how long the lock applies

**Legal Hold:**
- Independent of retention period
- Remains until explicitly removed
- Requires `s3:PutObjectLegalHold` permission
- Use case: Hold objects indefinitely for legal proceedings

> **Exam Tip:** Compliance mode = NOBODY can delete. Governance mode = Most users can't, but privileged users can override. Legal hold = Independent flag, no expiration date. Object Lock requires versioning.

### Access Points

- Named network endpoints with dedicated access policies
- Simplify managing access to shared datasets
- Each access point has its own DNS name and policy
- Can restrict to a specific VPC (VPC-only access point)

```
                    ┌── Access Point: "analytics" ──→ /analytics/* (Data Science team)
                    │
S3 Bucket ──────────┼── Access Point: "finance" ──→ /finance/* (Finance team)
                    │
                    └── Access Point: "public-data" ──→ /public/* (Public access)
```

### Multi-Region Access Points (MRAP)

- Global endpoint that routes requests to the closest S3 bucket
- Supports active-active or active-passive replication
- Automatic failover routing
- Integrated with S3 Cross-Region Replication

```
Client (US-East) ──→ ┌──────────────────────┐ ──→ us-east-1 bucket
                     │  Multi-Region Access  │
Client (EU) ──────→  │  Point (Global EP)    │ ──→ eu-west-1 bucket
                     │  mrap.accesspoint.s3- │
Client (APAC) ────→ │  global.amazonaws.com │ ──→ ap-southeast-1 bucket
                     └──────────────────────┘
```

**Failover controls:** Route traffic to specific buckets for disaster recovery

### Event Notifications

Trigger actions on S3 events (object created, deleted, restored, etc.):

**Destinations:**
- SNS Topic
- SQS Queue
- Lambda Function
- EventBridge (recommended — supports all S3 events, filtering, multiple destinations)

**EventBridge advantages:**
- Advanced filtering (JSON content-based filtering)
- Multiple destinations from single event
- Archive and replay events
- Schema discovery
- Over 18 AWS service targets

### S3 Select and Glacier Select

- Query subset of data using SQL expressions
- Filter rows and columns at the storage layer
- Supports CSV, JSON, Parquet
- Up to 400% faster, 80% cheaper than scanning full objects

```sql
SELECT s.name, s.age FROM S3Object s WHERE s.age > 30
```

### S3 Batch Operations

- Perform bulk operations on billions of objects
- Operations: Copy, invoke Lambda, restore from Glacier, replace tags, replace ACLs, Object Lock settings
- Uses S3 Inventory report or CSV manifest as input
- Integrates with S3 Inventory for target object selection

### S3 Inventory

- Scheduled report of objects and metadata in a bucket
- Output: CSV, ORC, or Parquet
- Delivered daily or weekly to a destination bucket
- Includes: Object key, size, last modified, storage class, encryption status, replication status

### S3 Storage Lens

- Organization-wide storage analytics and insights
- Dashboard with 60+ metrics
- **Free metrics:** 28 usage metrics, 14-day data retention
- **Advanced metrics (paid):** Activity metrics, cost optimization, data protection, status code, prefix-level aggregation, 15-month retention, CloudWatch publishing

### Transfer Acceleration

- Speeds up uploads using CloudFront edge locations
- Client uploads to nearest edge location → AWS backbone → S3 bucket
- Uses a distinct endpoint: `bucketname.s3-accelerate.amazonaws.com`
- Cost: Per-GB transfer fee on top of S3 transfer pricing
- Only beneficial for long-distance uploads (same region may be slower)

### Presigned URLs

- Grant temporary access to private objects
- Configurable expiration (default: 1 hour for console, up to 7 days for CLI/SDK)
- Inherits permissions of the IAM principal who generated it
- For upload (PUT) or download (GET)

### Requester Pays

- Bucket owner pays for storage; requester pays for data transfer and requests
- Requester must be an authenticated AWS user
- Use case: Large datasets shared publicly where the data provider doesn't want to pay for transfers

---

## 2. S3 Security

### Bucket Policies

- Resource-based JSON policies attached to the bucket
- Can grant cross-account access
- Up to 20 KB in size
- Conditions: IP range, VPC endpoint, SSL/TLS, MFA, time, etc.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyUnencryptedUploads",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::my-bucket/*",
      "Condition": {
        "StringNotEquals": {
          "s3:x-amz-server-side-encryption": "aws:kms"
        }
      }
    },
    {
      "Sid": "DenyNonHTTPS",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::my-bucket",
        "arn:aws:s3:::my-bucket/*"
      ],
      "Condition": {
        "Bool": { "aws:SecureTransport": "false" }
      }
    }
  ]
}
```

### ACLs (Access Control Lists)

- Legacy access control mechanism
- Bucket ACLs and Object ACLs
- AWS recommends disabling ACLs (bucket owner enforced)
- **S3 Object Ownership:** "Bucket owner enforced" setting disables all ACLs

### Block Public Access

Four independent settings (can be set at account or bucket level):
1. **BlockPublicAcls**: Block new public ACLs
2. **IgnorePublicAcls**: Ignore existing public ACLs
3. **BlockPublicPolicy**: Block new public bucket policies
4. **RestrictPublicBuckets**: Restrict public/cross-account access via public policies

> **Exam Tip:** Enable all four Block Public Access settings at the ACCOUNT level as a best practice. Override only at the bucket level when a bucket truly needs public access.

### Encryption

**Server-Side Encryption (SSE):**

| Method | Key Management | Key Storage | Use Case |
|--------|---------------|-------------|----------|
| SSE-S3 (AES-256) | AWS manages | S3 | Default, simplest option |
| SSE-KMS | AWS KMS manages | KMS | Audit trail (CloudTrail), key rotation, separate permissions |
| SSE-C | Customer provides | Customer | Full customer key control |
| DSSE-KMS | Dual-layer KMS | KMS | Compliance requiring dual-layer encryption |

**SSE-KMS specifics:**
- Uses AWS KMS Customer Master Key (CMK)
- Each object encrypted with unique data key
- CloudTrail logs every KMS API call (audit trail)
- KMS request rate limits may apply (5,500–30,000 requests/sec depending on Region)
- Can use AWS managed key (`aws/s3`) or customer managed key

**SSE-C specifics:**
- Customer provides encryption key with every request
- S3 does NOT store the key
- HTTPS required (mandatory)
- Customer responsible for key management

**Client-Side Encryption (CSE):**
- Data encrypted before sending to S3
- Customer manages encryption/decryption entirely
- AWS never sees unencrypted data
- Can use AWS Encryption SDK or S3 Encryption Client

**Default encryption:**
- SSE-S3 is the default for all new buckets (as of Jan 2023)
- Can be changed to SSE-KMS or DSSE-KMS
- Bucket policy can enforce a specific encryption method

### VPC Endpoints for S3

**Gateway Endpoint:**
- Free of charge
- Route table entry pointing to S3
- No DNS resolution changes needed
- Policy-based access control
- S3 and DynamoDB only

**Interface Endpoint (PrivateLink):**
- ENI in your subnet with private IP
- Costs per hour + per GB
- DNS resolution changes (private DNS)
- Security group based
- Accessible from on-premises via Direct Connect/VPN

```
Gateway Endpoint:
  Private Subnet → Route Table (prefix list → vpce-xxx) → S3

Interface Endpoint:
  Private Subnet → ENI (private IP) → PrivateLink → S3
  On-premises → DX/VPN → ENI → PrivateLink → S3
```

> **Exam Tip:** Use Gateway Endpoint when traffic stays in AWS (free). Use Interface Endpoint when you need access from on-premises via Direct Connect/VPN, or need private DNS.

### S3 Access Logging

- Log all requests made to a bucket
- Delivered to a target logging bucket (must be in same Region)
- Best effort delivery (not guaranteed real-time)
- Log format includes: requester, bucket, time, action, response status, error code

---

## 3. S3 Performance Optimization

### Baseline Performance

- 3,500 PUT/COPY/POST/DELETE requests per second per prefix
- 5,500 GET/HEAD requests per second per prefix
- No limit on number of prefixes

**Prefix strategy for throughput:**
```
bucket/prefix1/file1  → 3,500 writes + 5,500 reads
bucket/prefix2/file1  → 3,500 writes + 5,500 reads
bucket/prefix3/file1  → 3,500 writes + 5,500 reads
                        (Total: 10,500 writes + 16,500 reads)
```

### Multipart Upload

- Recommended for files > 100 MB, required for files > 5 GB
- Upload parts in parallel (improved throughput)
- Retry individual parts on failure
- Parts: 1–10,000, each 5 MB to 5 GB (last part can be smaller)
- Abort incomplete uploads with lifecycle policy to avoid storage charges

### Byte-Range Fetches

- Parallelize downloads by requesting specific byte ranges
- Resume failed downloads from the last successful byte
- Download only specific portions of an object

### S3 Express One Zone

- Single-digit millisecond latency (up to 10x faster than S3 Standard)
- Uses directory buckets (not general purpose buckets)
- Bucket name includes AZ suffix (e.g., `bucket--usw2-az1--x-s3`)
- 200K+ requests per second per prefix
- Use cases: ML training data, financial modeling, real-time analytics

### S3 Select / Glacier Select Performance

- Server-side filtering reduces data scanned and transferred
- Up to 400% performance improvement
- Supports: CSV, JSON, Apache Parquet (with columnar push-down)

### KMS Throttling Considerations

- SSE-KMS generates a KMS API call for every GET/PUT
- KMS quota: 5,500–30,000 requests/sec (varies by Region)
- Request a quota increase if needed
- Use S3 Bucket Keys to reduce KMS calls by up to 99%
  - Bucket-level key reduces per-object KMS calls
  - Enabled per-bucket, compatible with replication

```
Without Bucket Key:
  Each PUT → KMS:GenerateDataKey call
  Each GET → KMS:Decrypt call
  (High KMS API volume)

With S3 Bucket Key:
  Bucket-level key generated periodically
  Object keys derived locally
  (99% fewer KMS API calls)
```

---

## 4. EBS Deep Dive

### Volume Types

| Volume | Type | IOPS (max) | Throughput (max) | Size | Use Case |
|--------|------|-----------|-----------------|------|----------|
| gp3 | General Purpose SSD | 16,000 | 1,000 MB/s | 1 GiB – 16 TiB | Boot, dev/test, virtual desktops |
| gp2 | General Purpose SSD | 16,000 | 250 MB/s | 1 GiB – 16 TiB | Legacy gp (gp3 preferred) |
| io2 | Provisioned IOPS SSD | 64,000 | 1,000 MB/s | 4 GiB – 16 TiB | Databases, latency-sensitive |
| io2 Block Express | Provisioned IOPS SSD | 256,000 | 4,000 MB/s | 4 GiB – 64 TiB | Largest, most demanding workloads |
| st1 | Throughput Optimized HDD | 500 | 500 MB/s | 125 GiB – 16 TiB | Big data, data warehouse, logs |
| sc1 | Cold HDD | 250 | 250 MB/s | 125 GiB – 16 TiB | Infrequently accessed, lowest cost |

### gp3 vs gp2

| Feature | gp3 | gp2 |
|---------|-----|-----|
| Baseline IOPS | 3,000 (included) | 3 IOPS/GiB (min 100) |
| Max IOPS | 16,000 (independent of size) | 16,000 (at 5,334+ GiB) |
| Baseline Throughput | 125 MB/s (included) | Tied to IOPS |
| Max Throughput | 1,000 MB/s | 250 MB/s |
| Pricing | ~20% cheaper than gp2 | Legacy pricing |
| IOPS provisioning | Independent of size | Tied to volume size |

> **Exam Tip:** gp3 is the default recommendation. gp3 decouples IOPS and throughput from volume size. For any new workload, prefer gp3 over gp2.

### io2 and io2 Block Express

- io2: 500 IOPS per GiB ratio, max 64,000 IOPS
- io2 Block Express: 1,000 IOPS per GiB, max 256,000 IOPS, 4,000 MB/s, 64 TiB
- Multi-attach capable (io1/io2 only)
- 99.999% durability (10x gp2/gp3)
- Use case: Critical databases (Oracle, SQL Server, SAP HANA)

### EBS Encryption

- Uses AES-256 encryption
- Encrypts data at rest, data in transit (to/from EC2), all snapshots, all volumes from snapshots
- Handled transparently (no performance impact on modern instances)
- Uses AWS KMS (CMK or AWS managed key)
- Encryption is per-volume setting

**Encrypting an unencrypted volume:**
1. Create snapshot of unencrypted volume
2. Copy snapshot with encryption enabled
3. Create new volume from encrypted snapshot
4. Attach encrypted volume to instance

### EBS Snapshots

- Point-in-time, incremental backups stored in S3 (managed by AWS)
- Only changed blocks are stored after the first snapshot
- Can copy across regions (for DR)
- Can share with other accounts (encrypted snapshots require sharing KMS key)

**Snapshot lifecycle:**
- Automated via Amazon Data Lifecycle Manager (DLM) or AWS Backup
- DLM: Policy-based, tag-driven, supports cross-region copy

### Fast Snapshot Restore (FSR)

- Eliminates latency on first read for volumes from snapshots
- Normally, blocks are lazy-loaded from S3 on first access (slow)
- FSR pre-warms the volume (full performance immediately)
- Enabled per snapshot per AZ
- Costly — charges per snapshot per AZ per hour
- Alternative: Initialize volume with `dd` or `fio` (free but time-consuming)

### Multi-Attach

- Attach a single io1/io2 volume to up to 16 Nitro instances in the same AZ
- Each instance has full read/write permissions
- Application must manage concurrent write operations (cluster-aware filesystem required)
- Use case: Clustered applications (e.g., Oracle RAC), high availability within a single AZ
- NOT for general-purpose file sharing — use EFS/FSx for that

### Elastic Volumes

- Modify volume type, size, and IOPS on a live, attached volume
- No downtime required
- Can increase size (never decrease)
- Can change type (e.g., gp2 → gp3, gp3 → io2)
- Modification in progress — takes time, volume is usable during modification
- Cooldown: 6 hours between modifications

> **Exam Tip:** EBS is single-AZ only. For multi-AZ, use EFS or FSx. Multi-Attach is within the SAME AZ only and requires cluster-aware filesystem. For cross-region backup, use snapshot copy.

---

## 5. EFS Deep Dive

### Overview

- Managed NFS file system (NFSv4.1)
- Multi-AZ by default (Regional)
- Scales automatically (petabyte-scale)
- POSIX-compliant (Linux only)
- Pay-per-use (no pre-provisioning)

### Performance Modes

| Mode | Latency | Throughput | IOPS | Use Case |
|------|---------|-----------|------|----------|
| General Purpose (default) | Low (sub-ms) | Good | 35,000+ read, 7,000+ write | Web serving, content management, home dirs |
| Max I/O | Higher | Highest | 500,000+ | Big data, media processing, HPC |

> **Note:** Max I/O is being replaced by General Purpose with Enhanced mode. General Purpose now supports higher IOPS, making Max I/O less necessary.

### Throughput Modes

| Mode | Description | Best For |
|------|-------------|----------|
| Bursting | Throughput scales with size (50 MiB/s per TiB) + burst credits | Workloads with variable throughput |
| Provisioned | Specify throughput independent of storage size | Consistent high throughput, small filesystems |
| Elastic (recommended) | Auto-scales throughput up/down based on workload | Spiky, unpredictable workloads |

**Elastic throughput:**
- Automatically scales up to 10 GiB/s read, 3 GiB/s write
- Pay only for throughput used
- Recommended for most workloads

### Storage Classes

| Class | Availability | Use Case | Cost |
|-------|-------------|----------|------|
| EFS Standard | Multi-AZ | Frequently accessed | $$$ |
| EFS Standard-IA | Multi-AZ | Infrequently accessed | $ + per-access fee |
| EFS One Zone | Single AZ | Dev/test, backups | $$ |
| EFS One Zone-IA | Single AZ | Infrequently accessed, non-critical | $ + per-access fee |

### Lifecycle Management

- Automatically transition files between Standard and IA classes
- Configurable: 7, 14, 30, 60, 90 days since last access
- Can transition back to Standard on next access (optional)
- Works independently of S3 lifecycle (EFS-specific feature)

### EFS Replication

- Automatic replication to another Region or AZ
- RPO of ~15 minutes
- Read-only replica (failover by promoting to read-write)
- Use case: Disaster recovery

### Access Points

- Application-specific entry points
- Enforce POSIX user/group identity
- Define root directory for each application
- Simplify managing access for multiple applications on a single filesystem

```
EFS Filesystem
├── /app1  ← Access Point 1 (UID: 1000, root: /app1)
├── /app2  ← Access Point 2 (UID: 2000, root: /app2)
└── /shared ← Direct NFS mount (root access)
```

### NFS Security

- Security groups on mount targets
- IAM policies for EFS actions
- EFS resource policies
- Encryption in transit (TLS via EFS mount helper)
- Encryption at rest (KMS)
- VPC-based access (mount targets in subnets)

> **Exam Tip:** EFS = NFS = Linux only. For Windows, use FSx for Windows File Server. EFS is multi-AZ by default (one-zone option exists). Elastic throughput is the recommended mode for most workloads.

---

## 6. FSx Deep Dive

### FSx for Windows File Server

**Fully managed Windows file system on SMB protocol**

**Architecture:**
- Built on Windows Server
- Single-AZ or Multi-AZ deployment
- SSD or HDD storage
- Up to 64 TB per filesystem, scales via DFS Namespaces

**Key features:**
- **Active Directory integration:** AWS Managed AD or self-managed AD
- **DFS Namespaces:** Group multiple filesystems under a single namespace for scaling beyond 64 TB
- **Shadow Copies:** Windows VSS snapshots accessible by end users (Previous Versions tab)
- **Data deduplication:** Save 50-80% storage for general-purpose file shares
- **User quotas:** Per-user storage limits
- **Access from multiple VPCs/accounts:** Via VPC peering, Transit Gateway, or shared VPC

**Multi-AZ:**
- Active/standby across two AZs
- Automatic failover (typically < 30 seconds)
- DNS name automatically points to active node

**Backup:**
- Automatic daily backups (configurable retention 0-90 days)
- User-initiated backups (no retention limit)
- Backups are incremental, stored in S3

**Performance:**
- SSD: Latency < 1 ms, up to 3 GB/s throughput, 80,000 IOPS
- HDD: Latency single-digit ms, up to 12 GB/s throughput
- Throughput scales with filesystem size or provisioned capacity

### FSx for Lustre

**High-performance parallel file system for compute-intensive workloads**

**Deployment types:**

| Type | Durability | Replication | Use Case |
|------|-----------|-------------|----------|
| Scratch | Single AZ, no replication | None | Temporary storage, short-term processing |
| Persistent 1 | Single AZ, replicated within AZ | Within AZ | Long-term storage, sensitive data |
| Persistent 2 | Single AZ, replicated within AZ | Within AZ (higher durability) | Long-term, most sensitive workloads |

**S3 integration:**
- Transparently presents S3 objects as files
- Lazy loading: Files loaded from S3 on first access
- Can write results back to S3 via `hsm_archive` command
- Auto-import: New S3 objects automatically appear in Lustre
- Auto-export: Changed files automatically written back to S3

**Performance:**
- SSD: Sub-millisecond latency, up to millions of IOPS
- HDD: With SSD read cache for frequently accessed data
- Throughput: 200 MB/s to 1,000+ MB/s per TiB of storage

**Data compression:**
- LZ4 compression: Reduces storage cost by 50-60%
- Transparent to applications

**Use cases:** Machine learning training, HPC, video processing, financial modeling, genomics

### FSx for NetApp ONTAP

**Fully managed NetApp ONTAP file system**

**Key features:**
- **Multi-protocol:** NFS, SMB, and iSCSI simultaneously
- **Multi-AZ:** Active/standby deployment
- **Snapshots:** Instant, space-efficient snapshots
- **FlexClone:** Create instant, writable clones of volumes (thin provisioned)
- **SnapMirror:** Replicate data to other FSx ONTAP or on-premises NetApp systems
- **Tiering:** Automatic tiering between SSD (performance) and capacity pool (cost-optimized)
- **Data compression and deduplication:** Reduce storage by 65%+

**Architecture:**
- Storage Virtual Machine (SVM): Isolated file server within the filesystem
- Volumes within SVMs
- FlexGroup: Single namespace spanning multiple volumes for large datasets

**Use cases:**
- Migration from on-premises NetApp systems
- Workloads needing multi-protocol access
- DevOps (FlexClone for instant dev/test environments)
- Database cloning

### FSx for OpenZFS

**Fully managed OpenZFS file system**

**Key features:**
- NFS protocol (v3, v4, v4.1, v4.2)
- Snapshots (instant, space-efficient)
- Data compression (LZ4, Z-Standard)
- Up to 1 million IOPS, sub-100 microsecond latency
- Point-in-time clones
- Up to 12.5 GB/s throughput

**Use cases:**
- Linux/macOS workloads migrating from on-premises ZFS
- Low-latency file storage
- CI/CD pipelines, developer environments

### FSx Comparison

| Feature | Windows File Server | Lustre | NetApp ONTAP | OpenZFS |
|---------|-------------------|--------|-------------|---------|
| Protocol | SMB | Lustre (POSIX) | NFS, SMB, iSCSI | NFS |
| OS support | Windows, Linux | Linux | Linux, Windows | Linux, macOS |
| Multi-AZ | Yes | No (single AZ) | Yes | No |
| S3 integration | No | Yes (native) | No | No |
| AD integration | Yes | No | Yes | No |
| Use case | Windows shares | HPC, ML | Multi-protocol, NetApp migration | ZFS migration |
| Max throughput | 12 GB/s | 1,000+ MB/s/TiB | 4 GB/s | 12.5 GB/s |

> **Exam Tip:** Windows/SMB/AD → FSx for Windows. HPC/ML/S3 integration → FSx for Lustre. Multi-protocol NFS+SMB+iSCSI → FSx for NetApp ONTAP. ZFS migration → FSx for OpenZFS.

---

## 7. Storage Gateway

### Overview

Hybrid cloud storage service — bridge between on-premises and AWS cloud storage.

Deployed as: VM (VMware, Hyper-V, KVM) or hardware appliance

### S3 File Gateway

```
On-premises ──(NFS/SMB)──→ S3 File Gateway ──→ Amazon S3
                            (local cache)      (Standard, S3-IA, etc.)
```

- Presents S3 objects as files via NFS/SMB
- Local cache for low-latency access to recently used data
- Each file becomes an S3 object (1:1 mapping)
- Supports S3 storage classes, lifecycle policies
- Active Directory integration for SMB access
- Use case: Backup/archive to cloud, cloud data lake, on-premises file shares backed by S3

### FSx File Gateway

```
On-premises ──(SMB)──→ FSx File Gateway ──→ FSx for Windows File Server
                       (local cache)
```

- Local cache for low-latency access to FSx for Windows
- Useful when latency to FSx is too high from some branch offices
- Integrates with Active Directory
- Use case: Branch offices accessing centralized Windows file shares

### Volume Gateway

**Cached Volumes:**
```
On-premises ──(iSCSI)──→ Volume Gateway ──→ S3 (primary data)
                         (cache: hot data)    
                                         ──→ EBS Snapshots
```
- Primary data in S3, cache of frequently accessed data on-premises
- Up to 1,024 TiB total (32 volumes × 32 TiB each)
- Suitable when: Most data accessed infrequently, want cloud-primary storage

**Stored Volumes:**
```
On-premises ──(iSCSI)──→ Volume Gateway ──→ S3 (async backup)
                         (full dataset        
                          stored locally)  ──→ EBS Snapshots
```
- Full dataset on-premises, asynchronous backup to S3
- Up to 512 TiB total (32 volumes × 16 TiB each)
- Suitable when: Low-latency access to entire dataset, cloud backup

### Tape Gateway (VTL)

```
On-premises ──(iSCSI VTL)──→ Tape Gateway ──→ S3 (Virtual Tape Library)
 Backup                      (cache)          ──→ Glacier (Virtual Tape Shelf)
 Software                                     ──→ Deep Archive
```

- Presents virtual tape library (VTL) via iSCSI
- Compatible with existing backup software (Veeam, NetBackup, Backup Exec, etc.)
- Virtual tapes stored in S3; archived tapes in Glacier/Deep Archive
- Each virtual tape: 100 GiB to 5 TiB
- Up to 1,500 virtual tapes per gateway

### Storage Gateway Comparison

| Gateway Type | Protocol | Primary Storage | Cache | Use Case |
|-------------|----------|----------------|-------|----------|
| S3 File Gateway | NFS/SMB | S3 | Local | File shares backed by S3 |
| FSx File Gateway | SMB | FSx Windows | Local | Branch office access to FSx |
| Volume Cached | iSCSI | S3 | Local | Cloud-primary block storage |
| Volume Stored | iSCSI | Local | S3 (backup) | On-prem block with cloud backup |
| Tape Gateway | iSCSI VTL | S3/Glacier | Local | Tape backup replacement |

> **Exam Tip:** "Replace tape backup" → Tape Gateway. "On-premises NFS/SMB access to S3" → S3 File Gateway. "iSCSI block storage with cloud backup" → Volume Gateway. "Branch offices accessing Windows file shares" → FSx File Gateway.

---

## 8. Data Transfer Services Comparison

### Decision Matrix

| Service | Best For | Direction | Speed | Online/Offline |
|---------|---------|-----------|-------|---------------|
| S3 Transfer Acceleration | Large uploads to S3 over internet | Upload | Fast (edge locations) | Online |
| DataSync | Large data migration/sync to AWS | Both | Up to 10 Gbps | Online |
| Storage Gateway | Ongoing hybrid access | Both | Varies | Online |
| Transfer Family | SFTP/FTPS/FTP to S3/EFS | Upload/Download | Varies | Online |
| Snow Family | Massive offline data transfer | Both | Physical shipping | Offline |
| Direct Connect | Dedicated network link | Both | 1/10/100 Gbps | Online |

### AWS DataSync

- Automated data transfer between on-premises and AWS, or between AWS services
- Agent-based (on-premises) or agentless (AWS-to-AWS)
- Supports: NFS, SMB, HDFS, self-managed object storage, S3, EFS, FSx
- Up to 10 Gbps throughput per task
- Automatic encryption, data validation, bandwidth throttling
- Incremental transfers (only changed data)
- Scheduled or one-time transfers

**DataSync vs Storage Gateway:**
- DataSync: Data migration, scheduled sync (move data)
- Storage Gateway: Ongoing hybrid access (access data)

### AWS Transfer Family

- Managed SFTP, FTPS, FTP, AS2 service
- Transfer directly into/out of S3 or EFS
- Uses existing authentication (AD, LDAP, custom IdP)
- Use case: B2B file transfers, regulatory compliance requiring SFTP

### AWS Snow Family

| Device | Storage | Compute | Use Case |
|--------|---------|---------|----------|
| Snowcone | 8 TB HDD / 14 TB SSD | 2 vCPU, 4 GB RAM | Edge, small migrations |
| Snowball Edge Storage Optimized | 80 TB | 40 vCPU, 80 GB RAM | Large migrations, edge |
| Snowball Edge Compute Optimized | 42 TB | 52 vCPU, 208 GB RAM | Edge compute + storage |
| Snowmobile | 100 PB (truck) | N/A | Exabyte-scale migrations |

**Rule of thumb:** If data transfer over network takes > 1 week, consider Snow Family.

---

## 9. AWS Backup

### Overview

- Centralized backup management across AWS services
- Policy-based backup automation (backup plans)
- Supports: EC2, EBS, EFS, FSx, RDS, Aurora, DynamoDB, Neptune, DocumentDB, S3, Storage Gateway, VMware on-premises

### Backup Plans

- Define: Frequency (hourly, daily, weekly, monthly), retention, lifecycle (to cold storage)
- Assign resources via tags or resource IDs
- Continuous backup for point-in-time recovery (PITR) — supported for S3, RDS, Aurora

### Backup Vault

- Container for backups
- Access controlled via IAM + vault access policy

**Vault Lock:**
- WORM (Write Once Read Many) for backups
- Even root account cannot delete backups during retention period
- Compliance mode: Cannot be changed after lock
- Use case: Regulatory compliance (SEC, FINRA)

### Cross-Account Backup

- Copy backups to another AWS account
- Requires AWS Organizations
- Protect against account compromise

### Cross-Region Backup

- Copy backups to another Region
- Disaster recovery
- Supports all backup-eligible services

### Backup Architecture

```
┌─────────────────────────────────────────────┐
│              AWS Backup                       │
│                                               │
│  Backup Plan: "Production-Daily"              │
│  ├── Rule: Daily at 2 AM UTC                  │
│  │   ├── Retention: 35 days                   │
│  │   ├── Copy to: us-west-2 (cross-region)    │
│  │   └── Copy to: DR Account (cross-account)  │
│  │                                            │
│  └── Resource Assignment: tag:backup=true     │
│                                               │
│  Backup Vault: "Production"                   │
│  ├── Vault Lock: Compliance (365 days)        │
│  └── Access Policy: Deny delete               │
└─────────────────────────────────────────────┘
```

> **Exam Tip:** AWS Backup Vault Lock with Compliance mode = immutable backups (even root can't delete). For cross-account DR, use Organizations + cross-account copy. AWS Backup is the single pane of glass for all AWS backup needs.

---

## 10. Storage Selection Decision Framework

### Decision Tree

```
Q: What is the access pattern?
│
├─ Object storage (files, images, logs, backups)
│  ├─ Frequently accessed → S3 Standard
│  ├─ Unknown/variable access → S3 Intelligent-Tiering
│  ├─ Infrequent access, multi-AZ → S3 Standard-IA
│  ├─ Infrequent access, single-AZ → S3 One Zone-IA
│  ├─ Archive, ms retrieval → Glacier Instant Retrieval
│  ├─ Archive, min-hours retrieval → Glacier Flexible Retrieval
│  └─ Archive, 12-48 hours → Glacier Deep Archive
│
├─ Block storage (databases, boot volumes, transactional)
│  ├─ General purpose → gp3
│  ├─ High IOPS databases → io2 / io2 Block Express
│  ├─ Throughput-heavy sequential → st1
│  ├─ Cold data, lowest cost → sc1
│  └─ Temporary, highest IOPS → Instance Store
│
├─ File storage (shared filesystems)
│  ├─ Linux NFS → EFS
│  ├─ Windows SMB + AD → FSx for Windows
│  ├─ HPC / ML parallel processing → FSx for Lustre
│  ├─ Multi-protocol NFS+SMB+iSCSI → FSx for NetApp ONTAP
│  └─ ZFS workloads → FSx for OpenZFS
│
├─ Hybrid (on-premises + cloud)
│  ├─ NFS/SMB to S3 → S3 File Gateway
│  ├─ Branch office access → FSx File Gateway
│  ├─ iSCSI block storage → Volume Gateway
│  ├─ Tape replacement → Tape Gateway
│  └─ Large migration → DataSync or Snow Family
│
└─ Data transfer
   ├─ Online, large scale → DataSync
   ├─ Long distance uploads → S3 Transfer Acceleration
   ├─ SFTP/FTP compliance → Transfer Family
   ├─ > 1 week over network → Snow Family
   └─ Dedicated link → Direct Connect
```

### Common Exam Scenarios

**Scenario 1: "Company needs to store 100 TB of log data with unpredictable access patterns and minimize cost."**
→ S3 Intelligent-Tiering (automatic tier optimization, no retrieval fees)

**Scenario 2: "Application requires shared filesystem accessible from 50 Linux EC2 instances across multiple AZs."**
→ EFS with General Purpose performance mode and Elastic throughput

**Scenario 3: "Windows application requires SMB file shares with Active Directory integration."**
→ FSx for Windows File Server (Multi-AZ for high availability)

**Scenario 4: "Machine learning training job needs high-throughput access to 500 TB dataset stored in S3."**
→ FSx for Lustre (automatic S3 integration, parallel filesystem for HPC/ML)

**Scenario 5: "Migrate 50 TB from on-premises NAS to S3, then continue syncing changes weekly."**
→ AWS DataSync (agent on-premises, scheduled weekly sync to S3)

**Scenario 6: "Replace tape backup infrastructure with cloud-based solution compatible with Veeam."**
→ Tape Gateway (VTL interface, compatible with existing backup software)

**Scenario 7: "Database requires 100,000 IOPS with sub-millisecond latency."**
→ EBS io2 Block Express (up to 256,000 IOPS)

**Scenario 8: "Ensure backups cannot be deleted by anyone for 7 years for regulatory compliance."**
→ AWS Backup with Vault Lock (Compliance mode, 7-year retention)

**Scenario 9: "Serve static website content globally with lowest latency."**
→ S3 + CloudFront (OAC for private S3 access)

**Scenario 10: "Application needs multi-protocol access (NFS + SMB + iSCSI) from both Linux and Windows servers."**
→ FSx for NetApp ONTAP (native multi-protocol support)

### Key Numbers to Remember

| Metric | Value |
|--------|-------|
| S3 object max size | 5 TB |
| S3 single PUT max | 5 GB |
| S3 requests per prefix | 3,500 PUT + 5,500 GET/sec |
| EBS gp3 baseline IOPS | 3,000 |
| EBS gp3 max IOPS | 16,000 |
| EBS io2 max IOPS | 64,000 |
| EBS io2 Block Express max IOPS | 256,000 |
| EFS max throughput (elastic) | 10 GiB/s read |
| S3 Glacier Flexible retrieval | Expedited: 1-5 min, Standard: 3-5 hr, Bulk: 5-12 hr |
| S3 Glacier Deep Archive retrieval | Standard: 12 hr, Bulk: 48 hr |
| S3 versioning | Cannot disable, only suspend |
| S3 Object Lock compliance mode | Nobody can delete (not even root) |
| S3 Intelligent-Tiering monitoring fee | Per-object monthly fee |
| EBS multi-attach | io1/io2, same AZ, up to 16 instances |

---

*This document covers the storage architecture knowledge required for the SAP-C02 exam Domain 2. Combine with hands-on practice in the AWS console and review AWS documentation for the latest updates.*
