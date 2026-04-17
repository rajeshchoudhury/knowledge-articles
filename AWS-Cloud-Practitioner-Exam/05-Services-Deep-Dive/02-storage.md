# Storage Services — Deep Dive

## Amazon S3

- **What it is:** Object storage with virtually unlimited scale.
- **Best for:** Data lake, backups, static websites, ML datasets, logs,
  any blob data accessed over HTTPS.
- **Durability:** 99.999999999% (11 nines). Availability: 99.99% (Standard).
- **Objects:** Up to **5 TB each**; single PUT up to **5 GB**; multipart
  upload for > 100 MB recommended; mandatory for > 5 GB.
- **Key features:**
  - **Storage classes** (price ↓, latency ↑):
    - Standard, Intelligent-Tiering (auto), Standard-IA, One Zone-IA,
      Glacier Instant Retrieval, Glacier Flexible Retrieval, Glacier
      Deep Archive.
  - **Lifecycle policies** — transition or expire objects.
  - **Versioning** — previous versions kept.
  - **Object Lock** — WORM retention (governance or compliance mode).
  - **Replication** — CRR (cross-region), SRR (same-region),
    Multi-Region Access Points (MRAP) with failover.
  - **Encryption** — SSE-S3 (default), SSE-KMS, SSE-C, DSSE-KMS;
    encryption in transit via HTTPS.
  - **Access**: bucket policy, IAM, ACLs (legacy), Block Public Access,
    Access Points, Access Grants (2023+), presigned URLs.
  - **S3 Transfer Acceleration** — fast uploads via CloudFront edges.
  - **S3 Select / Glacier Select** — SQL filter on retrieval.
  - **S3 Object Lambda** — transform on GET.
  - **Storage Lens** — org-wide analytics.
  - **Batch Operations** — run actions on billions of objects.
  - **S3 Inventory** — daily/weekly manifest of objects.
  - **Event notifications** — Lambda/SQS/SNS/EventBridge triggers.
  - **Static website hosting** — without a web server (supports only HTTP;
    front with CloudFront for HTTPS).
- **Pricing:** Per-GB/month (class-dependent) + requests + retrievals +
  data transfer out + replication.
- **Gotchas:**
  - Bucket names are **globally unique**.
  - S3 Standard-IA/One Zone-IA have **minimum 128 KB per object** and
    **30-day minimum** retention (charged).
  - Glacier tiers have 90–180-day minimums.
  - Public access **blocked by default** on new buckets; enabling public
    access requires explicitly disabling Block Public Access.
  - Pre-signed URLs use the creator's credentials and expire.

---

## Amazon EBS (Elastic Block Store)

- **What it is:** Block-level persistent storage for EC2.
- **Best for:** OS disks, databases on EC2, latency-sensitive block
  workloads.
- **Volume types:**

| Type | Media | Use | Max IOPS | Max throughput |
|---|---|---|---|---|
| gp3 | SSD | General purpose (default) | 16,000 | 1,000 MB/s |
| gp2 | SSD | Legacy general purpose | 16,000 | 250 MB/s |
| io2 Block Express | SSD (provisioned) | Critical DB, SAP HANA | 256,000 | 4,000 MB/s |
| io2 / io1 | SSD (provisioned) | DB, latency-sensitive | 64,000 | 1,000 MB/s |
| st1 | HDD (throughput) | Big data, logs | 500 | 500 MB/s |
| sc1 | HDD (cold) | Rarely accessed | 250 | 250 MB/s |

- **Key features:**
  - AZ-bound (replicate within an AZ).
  - Snapshots are stored in S3; Region-scoped.
  - **Fast Snapshot Restore (FSR)** — initialize volumes instantly.
  - **EBS Multi-Attach** — io1/io2 to multiple Nitro EC2 in same AZ.
  - Encryption by default (account setting); uses KMS.
  - Elastic volumes — change size/type/IOPS without downtime.
- **Pricing:** Per GB-month, per IOPS-month, per throughput-month.

---

## Amazon EFS (Elastic File System)

- **What it is:** Managed NFSv4 file system.
- **Best for:** Linux shared file storage, lift-and-shift NFS workloads,
  home directories, container persistence, ML training data shared
  across nodes.
- **Key features:**
  - Regional (Standard) or single-AZ (One Zone).
  - Storage classes: Standard, Standard-IA, Archive.
  - Automatic **lifecycle management** to IA/Archive.
  - Provisioned, Bursting, or **Elastic** throughput modes.
  - Mount targets per AZ.
  - Cross-region replication (2022+).
- **Pricing:** Per GB-month (class-dependent) + throughput-mode charge.
- **Compare with:** FSx (Windows/Lustre/NetApp/OpenZFS).

---

## Amazon FSx

- **What it is:** Managed file systems for specialty needs.
- **Variants:**
  - **FSx for Windows File Server** — SMB, AD-integrated, Windows apps.
  - **FSx for Lustre** — HPC, sub-ms access, Lustre parallel file system.
  - **FSx for NetApp ONTAP** — NetApp features (snapshots, clones,
    deduplication, SnapMirror); NFS, SMB, iSCSI.
  - **FSx for OpenZFS** — ZFS features (snapshots, clones, compression).
- **Pricing:** Per GB-month + throughput + (Lustre) backup.

---

## AWS Storage Gateway

- **What it is:** Hybrid storage appliance bridging on-prem to AWS.
- **Types:**
  - **S3 File Gateway** — NFS/SMB ↔ S3 (objects in S3).
  - **FSx File Gateway** — SMB ↔ FSx for Windows (cache on-prem).
  - **Volume Gateway (Cached)** — iSCSI, recent data on-prem, all in S3.
  - **Volume Gateway (Stored)** — iSCSI, full copy on-prem, async to S3.
  - **Tape Gateway (VTL)** — iSCSI VTL ↔ S3 Glacier / Deep Archive.

---

## AWS Snow Family

| Device | Capacity | Compute | Use |
|---|---|---|---|
| Snowcone | 8 TB HDD / 14 TB SSD | 2 vCPU, 4 GB | Small, rugged, edge |
| Snowball Edge Storage-Optimized | 80 TB | 40 vCPU | Bulk data transfer |
| Snowball Edge Compute-Optimized | 42 TB + GPU | 104 vCPU + GPU | Edge compute |
| Snowmobile | 100 PB | — | Exabyte DC evac (retiring) |

Offline alternative when network bandwidth makes transfer impractical.

---

## AWS Backup

- **What it is:** Centralized backup for 20+ AWS services.
- **Supported:** EBS, EC2, RDS, Aurora, DynamoDB, EFS, FSx, Storage
  Gateway, Neptune, DocumentDB, S3, Redshift, Timestream, VMware,
  SAP HANA on EC2.
- **Key features:** Backup plans, vaults (with Vault Lock for
  immutability), cross-region / cross-account copies, Backup Audit
  Manager, Restore testing, Continuous backup (PITR for DDB, RDS, S3).

---

## AWS DataSync

- **What it is:** Agent-based data transfer between on-prem/clouds and
  AWS storage (S3, EFS, FSx, Outposts).
- **Supports:** NFS, SMB, HDFS, object (S3-compatible, Azure Blob,
  Google Cloud Storage).
- **Transfers:** Online, scheduled, one-shot, bidirectional (2023+).
- **Pricing:** $0.0125 per GB transferred.

---

## AWS Transfer Family

- **What it is:** Fully managed SFTP, FTPS, FTP, AS2 endpoints
  backed by S3 or EFS.
- **Best for:** Exposing file transfer endpoints to external business
  partners without running SFTP servers.

---

## AWS Elastic Disaster Recovery (DRS)

- **What it is:** Continuous block-level replication for disaster
  recovery; replaces CloudEndure DR.
- **RPO:** sub-second; **RTO:** minutes.
- **Use cases:** Cross-Region DR, on-prem → AWS DR.

---

## Storage Class Decision Matrix

```
                           Access pattern
              Frequent    Infrequent    Archive (minutes)   Archive (hours)
              ┌──────────┬─────────────┬───────────────────┬────────────────┐
Multi-AZ      │ Standard │ Standard-IA │ Glacier Instant   │ Glacier Flex/DA│
One AZ        │ —        │ One Zone-IA │ (N/A)             │ (N/A)          │
Auto-tier     │   ─── Intelligent-Tiering ─────────────── │ optional       │
```
