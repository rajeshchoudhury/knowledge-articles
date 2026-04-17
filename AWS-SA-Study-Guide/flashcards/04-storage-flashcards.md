# Storage Flashcards

## AWS Solutions Architect Associate (SAA-C03) — Deck 4 of 9

---

### Card 1
**Q:** What are the S3 storage classes and their use cases?
**A:** **S3 Standard** – frequently accessed data, 99.99% availability, 11 nines durability, multi-AZ. **S3 Intelligent-Tiering** – automatic cost optimization for unknown access patterns, no retrieval fees. **S3 Standard-IA** – infrequent access, lower cost, retrieval fee, min 30-day storage, min 128 KB charge. **S3 One Zone-IA** – same as Standard-IA but single AZ, 99.5% availability. **S3 Glacier Instant Retrieval** – millisecond retrieval, min 90 days. **S3 Glacier Flexible Retrieval** – minutes to hours retrieval, min 90 days. **S3 Glacier Deep Archive** – cheapest, 12-48 hour retrieval, min 180 days.

---

### Card 2
**Q:** What are the retrieval options for S3 Glacier Flexible Retrieval?
**A:** **Expedited** – 1-5 minutes, most expensive. **Standard** – 3-5 hours. **Bulk** – 5-12 hours, cheapest. For Glacier Deep Archive: **Standard** – 12 hours, **Bulk** – 48 hours (no expedited option). Glacier Instant Retrieval provides millisecond access (like Standard-IA but cheaper for data accessed once per quarter). Retrieval costs are in addition to storage costs.

---

### Card 3
**Q:** How does S3 Intelligent-Tiering work?
**A:** S3 Intelligent-Tiering automatically moves objects between tiers based on access patterns. Tiers: **Frequent Access** (default, same as S3 Standard), **Infrequent Access** (objects not accessed for 30 days), **Archive Instant Access** (not accessed for 90 days), **Archive Access** (optional, 90-730 days), **Deep Archive Access** (optional, 180-730 days). No retrieval fees for Frequent and Infrequent tiers. Small monthly monitoring fee per object. Best for data with unpredictable or changing access patterns.

---

### Card 4
**Q:** What are S3 lifecycle rules?
**A:** Lifecycle rules automate transitioning objects between storage classes or expiring them. **Transition actions** – move objects to another class after N days (e.g., Standard → Standard-IA after 30 days → Glacier after 90 days). **Expiration actions** – delete objects or versions after N days. Rules can apply to the entire bucket, a prefix, or tags. Constraints: must wait 30 days before transitioning to IA classes; cannot transition from Glacier back to Standard; can filter by prefix and/or tags.

---

### Card 5
**Q:** What is S3 versioning?
**A:** S3 versioning keeps multiple versions of an object in the same bucket. When enabled, every overwrite or delete creates a new version. **Deleting** a versioned object adds a **delete marker** (the object appears deleted but previous versions remain). Versioning states: **Unversioned** (default), **Enabled**, **Suspended** (stops creating new versions; existing versions are retained). Versioning cannot be disabled once enabled, only suspended. Required for cross-region replication, S3 Object Lock, and MFA Delete.

---

### Card 6
**Q:** What is MFA Delete on S3?
**A:** MFA Delete adds an extra layer of protection by requiring MFA authentication to: permanently delete an object version or change the versioning state of a bucket. MFA Delete can only be enabled/disabled by the **bucket owner (root account)** using the **AWS CLI** (not the console). It requires versioning to be enabled. Prevents accidental or malicious permanent deletions. MFA Delete applies only to version deletions, not regular operations.

---

### Card 7
**Q:** What is S3 Cross-Region Replication (CRR) vs. Same-Region Replication (SRR)?
**A:** **CRR** – replicates objects to a bucket in a **different** AWS region. Use cases: compliance, lower-latency access, cross-account replication. **SRR** – replicates objects within the **same** region. Use cases: log aggregation, live replication between production and test accounts, data sovereignty (keep data in same region). Both require versioning on source and destination. Replication is asynchronous. New objects are replicated; existing objects require **S3 Batch Replication**. Delete markers are NOT replicated by default (can be enabled).

---

### Card 8
**Q:** What are the S3 encryption options?
**A:** **Server-Side Encryption (SSE)**: **SSE-S3** – AWS manages keys (AES-256), default encryption. **SSE-KMS** – keys managed in AWS KMS; audit trail via CloudTrail; may hit KMS request rate limits. **SSE-C** – customer provides the encryption key with each request; AWS does not store the key. **Client-Side Encryption** – encrypt data before uploading; you manage the entire encryption process. **In transit**: enforce HTTPS using `aws:SecureTransport` condition. SSE-S3 is the default encryption for new buckets.

---

### Card 9
**Q:** What is the difference between SSE-S3 and SSE-KMS?
**A:** **SSE-S3** – AWS manages the key entirely; one key per object rotation handled by S3; no additional cost; no audit trail of key usage; header: `x-amz-server-side-encryption: AES256`. **SSE-KMS** – key stored in KMS; you can use AWS managed key (`aws/s3`) or a customer managed key (CMK); provides CloudTrail audit log of key usage; subject to KMS API rate limits (5,500-30,000 requests/sec depending on region); header: `x-amz-server-side-encryption: aws:kms`. Use SSE-KMS when audit or key control is needed.

---

### Card 10
**Q:** What is S3 Object Lock?
**A:** S3 Object Lock provides WORM (Write Once Read Many) protection. Requires versioning. Two retention modes: **Governance** – users with special permissions (`s3:BypassGovernanceRetention`) can override/delete. **Compliance** – NO ONE (including root) can delete or shorten the retention period; the object is protected until the retention period expires. **Legal Hold** – indefinite protection regardless of retention period; can be toggled on/off with `s3:PutObjectLegalHold`. Use for regulatory compliance (SEC, FINRA).

---

### Card 11
**Q:** What is S3 performance optimization?
**A:** S3 supports **3,500 PUT/COPY/POST/DELETE** and **5,500 GET/HEAD** requests per second **per prefix**. Spread reads across prefixes for higher throughput. **Multipart upload** – recommended for files > 100 MB, required for > 5 GB; parallel uploads improve throughput. **S3 Transfer Acceleration** – uses CloudFront edge locations to speed up uploads over long distances; transfers through AWS backbone. **S3 Byte-Range Fetches** – parallelize GETs by requesting specific byte ranges; improves download speed and enables partial recovery.

---

### Card 12
**Q:** What is S3 Transfer Acceleration?
**A:** S3 Transfer Acceleration speeds up long-distance transfers by routing data through the nearest CloudFront edge location, then over AWS's optimized backbone network to the S3 bucket. The bucket endpoint changes to `<bucket>.s3-accelerate.amazonaws.com`. Effective for uploads from geographically distant clients. There's an additional cost per GB. You can test if acceleration benefits your use case with the Speed Comparison tool. Compatible with multipart uploads.

---

### Card 13
**Q:** What are S3 event notifications?
**A:** S3 can send notifications when events occur (object created, deleted, restored, replication failed). Destinations: **SQS**, **SNS**, **Lambda**, or **Amazon EventBridge**. With EventBridge, you get advanced filtering, multiple destinations, archive/replay capability, and integration with 18+ AWS services. Event notifications require proper resource-based policies on the destination. Common use cases: trigger image processing on upload, audit object deletions, index new objects in a database.

---

### Card 14
**Q:** What is an S3 pre-signed URL?
**A:** A pre-signed URL grants temporary access to a specific S3 object to anyone who has the URL. It encodes the credentials, bucket, key, HTTP method, and expiration time in the URL. Generated using the SDK or CLI. Default expiry: 3600 seconds (1 hour) via CLI; configurable up to 7 days. The URL inherits the permissions of the IAM principal that generated it. Use for: temporary downloads/uploads, sharing private content, allowing file uploads without AWS credentials. The object's encryption settings still apply.

---

### Card 15
**Q:** What are S3 Access Points?
**A:** S3 Access Points simplify managing access to shared datasets. Each access point has its own DNS name, access point policy, and network origin control (internet or VPC). Instead of a single complex bucket policy, you create multiple access points with different policies (e.g., one for finance team, one for analytics). Can restrict access to a specific VPC using `networkOrigin: VPC`. The bucket policy must allow the access point to access it. Simplifies governance for large, shared buckets.

---

### Card 16
**Q:** What is S3 Object Lambda?
**A:** S3 Object Lambda allows you to transform data retrieved from S3 using a Lambda function before returning it to the caller. Use cases: redact PII, convert data formats, resize images on-the-fly, enrich data with external sources. You create an **Object Lambda Access Point** backed by a supporting **S3 Access Point** and a Lambda function. The caller uses the Object Lambda Access Point endpoint instead of the bucket endpoint. Each caller can receive a different view of the same data.

---

### Card 17
**Q:** What are the EBS volume types and their characteristics?
**A:** **gp3** – baseline 3,000 IOPS / 125 MB/s, up to 16,000 IOPS / 1,000 MB/s; IOPS/throughput independent of size. **gp2** – baseline 3 IOPS/GB (burst to 3,000), max 16,000 IOPS; IOPS linked to size. **io2 Block Express** – up to 256,000 IOPS, 4,000 MB/s, sub-ms latency, 99.999% durability. **io1** – up to 64,000 IOPS, Nitro instances. **st1** (throughput HDD) – up to 500 MB/s, for sequential workloads. **sc1** (cold HDD) – up to 250 MB/s, lowest cost. Only gp and io can be boot volumes.

---

### Card 18
**Q:** When should you use gp3 vs. gp2 vs. io2?
**A:** **gp3** – best default choice; independent IOPS/throughput configuration; cost-effective; good for most workloads up to 16,000 IOPS. **gp2** – legacy; IOPS scales with volume size; use only if already in use (gp3 is generally cheaper). **io2/io2 Block Express** – mission-critical applications needing sustained high IOPS (>16,000), sub-millisecond latency, or multi-attach capability; databases like Cassandra, MongoDB; io2 Block Express supports up to 256,000 IOPS. Cost: io2 > gp3 > gp2 > st1 > sc1 (for IOPS workloads).

---

### Card 19
**Q:** What is EBS Multi-Attach?
**A:** EBS Multi-Attach allows a single **io1/io2** volume to be attached to up to **16** Nitro-based EC2 instances in the **same AZ** simultaneously. All instances can read and write to the volume. Use cases: clustered applications that need shared block storage (e.g., clustered databases). The application must manage concurrent write operations (use a cluster-aware file system like GFS2, not ext4/xfs). Not supported for gp, st, or sc volume types.

---

### Card 20
**Q:** How does EBS encryption work?
**A:** EBS encryption uses AWS KMS keys (AES-256). When enabled: data at rest is encrypted, data in transit between instance and volume is encrypted, snapshots are encrypted, and volumes created from encrypted snapshots are encrypted. Encryption is handled transparently with minimal latency impact. You can use the **default AWS managed key** or a **customer managed key**. To encrypt an unencrypted volume: create a snapshot → copy snapshot with encryption → create new encrypted volume from the encrypted snapshot.

---

### Card 21
**Q:** What are EBS snapshots and their features?
**A:** EBS snapshots are incremental backups stored in S3 (managed by AWS). Only changed blocks are saved after the first snapshot. Features: **EBS Snapshot Archive** – move rarely accessed snapshots to an archive tier (75% cheaper, 24-72hr restore). **Recycle Bin** – protect against accidental deletion with retention rules (1 day to 1 year). **Fast Snapshot Restore (FSR)** – eliminates latency on first use of a restored volume ($$$). Snapshots can be copied cross-region and shared cross-account. They can be taken while the volume is in use.

---

### Card 22
**Q:** What is Amazon EFS (Elastic File System)?
**A:** EFS is a managed, serverless NFS file system for Linux workloads. Supports NFSv4.1 protocol. Multi-AZ (regional) by default. Auto-scales (no capacity provisioning). Compatible with EC2, ECS, EKS, Fargate, and Lambda. **Performance modes**: General Purpose (default, low latency) and Max I/O (higher throughput, higher latency, for large parallel workloads). **Throughput modes**: Bursting (scales with size), Provisioned (fixed throughput regardless of size), Elastic (auto-scales throughput). Up to thousands of concurrent connections.

---

### Card 23
**Q:** What are the EFS storage classes?
**A:** **Standard** – for frequently accessed files, multi-AZ. **Standard-IA (Infrequent Access)** – lower cost, retrieval fee, multi-AZ. **One Zone** – single AZ, lower cost. **One Zone-IA** – single AZ, infrequent access, lowest cost. **EFS Lifecycle Management** automatically moves files between Standard and IA classes based on last access time (7, 14, 30, 60, or 90 days). One Zone classes are good for development, backups, or data that can be recreated. Standard classes for production workloads needing HA.

---

### Card 24
**Q:** What is the difference between EBS, EFS, and Instance Store?
**A:** **EBS** – block storage, single AZ, one instance at a time (except Multi-Attach io1/io2), persistent, specific size provisioned, can be detached/attached. **EFS** – NFS file system, multi-AZ (or One Zone), shared across many instances, auto-scales, Linux only, higher cost. **Instance Store** – ephemeral, physically attached, highest performance, lost on stop/terminate. Use EBS for databases and boot volumes, EFS for shared file storage, Instance Store for caches and temporary high-IOPS data.

---

### Card 25
**Q:** What are the FSx file system types?
**A:** **FSx for Windows File Server** – fully managed Windows-native file system; SMB protocol, NTFS, AD integration, DFS. **FSx for Lustre** – high-performance parallel file system for HPC, ML, video processing; integrates with S3 (lazy-load and write-back). **FSx for NetApp ONTAP** – multi-protocol (NFS, SMB, iSCSI), snapshots, compression, deduplication, replication; supports Linux, Windows, macOS. **FSx for OpenZFS** – NFS protocol, snapshots, compression; for Linux workloads migrating from on-premises ZFS.

---

### Card 26
**Q:** What are the FSx for Lustre deployment types?
**A:** **Scratch** – temporary storage, high burst throughput (up to 200 MB/s per TiB), no data replication, data lost if the file server fails. Use for short-term processing and cost optimization. **Persistent** – long-term storage, data replicated within the same AZ, failed files auto-replaced within minutes. Use for long-term processing and sensitive data. Both integrate with S3 for data import/export. Lustre provides sub-millisecond latencies and hundreds of GB/s throughput.

---

### Card 27
**Q:** What is AWS Storage Gateway?
**A:** Storage Gateway is a hybrid cloud storage service that provides on-premises access to virtually unlimited cloud storage. Three types: **S3 File Gateway** – NFS/SMB interface to S3; caches recent data locally. **FSx File Gateway** – SMB interface to FSx for Windows File Server with local cache. **Volume Gateway** – iSCSI block storage backed by S3 with EBS snapshots; **Stored Volumes** (full data local, async backup to S3) or **Cached Volumes** (primary data in S3, cached locally). **Tape Gateway** – virtual tape library backed by S3/Glacier for backup software.

---

### Card 28
**Q:** What is the difference between Storage Gateway Stored Volumes and Cached Volumes?
**A:** **Stored Volumes** – entire dataset stored on-premises; asynchronous backup to AWS as EBS snapshots in S3; up to 16 TB per volume; low latency access to all data. **Cached Volumes** – primary data stored in S3; only frequently accessed data cached on-premises; up to 32 TB per volume; reduces on-premises storage needs. Choose Stored for low-latency access to full dataset; choose Cached to minimize on-premises storage while retaining frequent access performance.

---

### Card 29
**Q:** What is the AWS Snow Family?
**A:** Physical devices for offline data transfer and edge computing. **Snowcone** – 8 TB HDD or 14 TB SSD, lightweight (4.5 lbs), rugged, can run EC2 and IoT Greengrass; ships via mail. **Snowball Edge Storage Optimized** – 80 TB usable, optional compute; for large data transfer. **Snowball Edge Compute Optimized** – 42 TB, powerful compute (52 vCPUs, optional GPU); for edge processing. **Snowmobile** – exabyte-scale transfer in a 45-foot shipping container (up to 100 PB each). Use when network transfer would take > 1 week.

---

### Card 30
**Q:** When should you use Snow Family vs. DataSync vs. Transfer Acceleration?
**A:** **Snow Family** – offline/physical transfer for 10s of TB to PB scale; use when network bandwidth is limited or transfer would take > 1 week. **DataSync** – online agent-based transfer for scheduled/one-time migrations from on-prem NFS/SMB/HDFS to S3/EFS/FSx; up to 10 Gbps over Direct Connect. **Transfer Acceleration** – speed up S3 uploads from distant clients via CloudFront edge; for ongoing transfers over the internet. Rule of thumb: calculate transfer time at your available bandwidth to choose.

---

### Card 31
**Q:** What is AWS DataSync?
**A:** DataSync automates and accelerates data transfer between on-premises storage and AWS (S3, EFS, FSx), or between AWS storage services. Features: agent-based (install on-premises), supports NFS, SMB, HDFS, and self-managed object storage. Handles encryption, integrity validation, bandwidth throttling, and scheduling. Transfers up to 10 Gbps. Use for: one-time data migrations, recurring data processing workflows, data replication for HA/DR. Can run on a schedule (hourly, daily, weekly). Also supports AWS-to-AWS transfers without an agent.

---

### Card 32
**Q:** What is S3 Select and Glacier Select?
**A:** S3 Select allows you to retrieve a subset of data from an object using SQL expressions. Instead of downloading the entire object and filtering client-side, S3 processes the query and returns only the matching rows/columns. Supports CSV, JSON, and Parquet formats. Reduces data transfer and processing time by up to 400%. **Glacier Select** does the same for data in Glacier. Use when you need specific data from large objects without retrieving the full object.

---

### Card 33
**Q:** What is S3 batch operations?
**A:** S3 Batch Operations perform large-scale operations on billions of objects. Operations include: copy objects, invoke Lambda, replace tags, modify ACLs, restore from Glacier, apply Object Lock settings. You provide a manifest (S3 Inventory report or CSV) and define the operation. Batch Operations manages retries, tracks progress, and sends completion notifications. Use for: bulk tagging, bulk encryption changes, cross-account copies, large-scale restores.

---

### Card 34
**Q:** What is S3 Inventory?
**A:** S3 Inventory generates flat-file reports listing objects and their metadata for a bucket or prefix. Reports can include: size, last modified date, storage class, encryption status, replication status, Object Lock status. Output format: CSV, ORC, or Parquet. Delivered daily or weekly to a destination S3 bucket. Use for: auditing encryption compliance, identifying objects for lifecycle rules, generating manifests for Batch Operations. More efficient than the LIST API for large buckets.

---

### Card 35
**Q:** What is S3 Requester Pays?
**A:** In a Requester Pays bucket, the requester (not the bucket owner) pays for data transfer and request costs. The bucket owner still pays for storage. The requester must include `x-amz-request-payer: requester` in the request header. Anonymous access is not allowed. Use case: sharing large datasets (genomics, weather data) where you don't want to bear the transfer costs. Commonly used for public datasets.

---

### Card 36
**Q:** What is the S3 consistency model?
**A:** Since December 2020, S3 provides **strong read-after-write consistency** for all operations. After a successful PUT of a new object or overwrite, any subsequent GET or LIST immediately returns the latest version. After a DELETE, a subsequent GET correctly returns a 404. This applies to all S3 operations including LIST. There is no eventual consistency for any S3 operation — all reads are always consistent.

---

### Card 37
**Q:** What is S3 Object Ownership?
**A:** S3 Object Ownership controls who owns objects uploaded to your bucket. Three settings: **Bucket owner enforced** (recommended) – disables ACLs; bucket owner automatically owns all objects; simplest model. **Bucket owner preferred** – bucket owner owns objects uploaded with `bucket-owner-full-control` ACL. **Object writer** (default for legacy) – the uploading account owns the object. AWS recommends disabling ACLs (Bucket owner enforced) and using bucket policies for access control instead.

---

### Card 38
**Q:** How does S3 replication handle delete operations?
**A:** By default, S3 replication does **not** replicate delete markers or version deletions. Rationale: prevent accidental or malicious mass deletions from propagating. You can **optionally enable delete marker replication** in the replication rule, which replicates delete markers (but not permanent version deletions). Permanent deletions (specifying a version ID) are **never** replicated. This protects against cascading deletes across regions.

---

### Card 39
**Q:** What is the minimum storage duration charge for each S3 class?
**A:** **S3 Standard** – none. **S3 Standard-IA** – 30 days. **S3 One Zone-IA** – 30 days. **S3 Intelligent-Tiering** – none (but monthly monitoring fee). **S3 Glacier Instant Retrieval** – 90 days. **S3 Glacier Flexible Retrieval** – 90 days. **S3 Glacier Deep Archive** – 180 days. If you delete or transition an object before the minimum duration, you're still charged for the full minimum period. Also, IA classes have a minimum object size charge of 128 KB.

---

### Card 40
**Q:** What is the maximum size of a single S3 object?
**A:** The maximum size of a single S3 object is **5 TB** (5 terabytes). A single PUT request can upload up to **5 GB**. For objects larger than 5 GB, you must use **multipart upload**. AWS recommends multipart upload for objects > 100 MB. Multipart upload allows parallel uploads of parts (each 5 MB to 5 GB), improves throughput, and supports resuming failed uploads. The maximum number of parts is 10,000.

---

### Card 41
**Q:** What is S3 Storage Lens?
**A:** S3 Storage Lens provides organization-wide visibility into object storage usage and activity across all accounts and regions. It generates **dashboards** with 60+ metrics on storage usage, cost efficiency, data protection, and access patterns. **Free metrics** (28 metrics, 14-day data) and **Advanced metrics** (additional metrics, 15-month data, prefix-level aggregation, CloudWatch integration). Delivers daily metrics and recommendations for optimizing storage costs.

---

### Card 42
**Q:** What is the EBS IOPS-to-throughput relationship for gp3?
**A:** For **gp3**: baseline 3,000 IOPS and 125 MB/s throughput are included for free. You can independently provision up to 16,000 IOPS and 1,000 MB/s. IOPS and throughput are decoupled from volume size. For **gp2**: IOPS = 3 × volume size in GB (min 100, max 16,000); throughput is limited to 250 MB/s. A 5,334+ GB gp2 volume reaches max 16,000 IOPS. gp3 is generally cheaper than gp2 for the same performance.

---

### Card 43
**Q:** What EBS volume modifications are allowed without downtime?
**A:** You can modify EBS volumes **without detaching** them: change volume type (e.g., gp2 → gp3), increase size, and adjust IOPS and throughput (for gp3, io1, io2). Changes take effect gradually (the volume enters an "optimizing" state). You cannot decrease volume size. After increasing size, you must extend the OS file system to use the new space. Wait at least 6 hours between modifications. Changing from magnetic to SSD requires a snapshot/restore workflow.

---

### Card 44
**Q:** What is EBS Fast Snapshot Restore (FSR)?
**A:** FSR eliminates the latency penalty when accessing data from a newly created EBS volume restored from a snapshot. Normally, blocks are lazily loaded from S3 on first access, causing higher latency. With FSR, the volume is fully initialized at creation, providing full performance immediately. FSR is enabled per snapshot per AZ. It's expensive — charged per DSU (Data Service Unit) per hour. Use for: boot volumes in ASGs, databases that need immediate full performance.

---

### Card 45
**Q:** What is S3 Glacier Vault Lock?
**A:** Glacier Vault Lock enforces compliance controls on a Glacier vault using a **Vault Lock policy**. Once locked, the policy can never be changed or deleted (immutable). Use for WORM compliance (SEC Rule 17a-4, CFTC regulations). The process: create a vault lock policy → initiate the lock (24-hour window to abort) → complete the lock (irreversible). Different from S3 Object Lock which applies to individual objects in S3 buckets.

---

### Card 46
**Q:** What is the difference between S3 Block Public Access settings?
**A:** Four settings: **BlockPublicAcls** – blocks new public ACLs from being set. **IgnorePublicAcls** – ignores existing public ACLs. **BlockPublicPolicy** – blocks new bucket policies that grant public access. **RestrictPublicBuckets** – restricts access to bucket with public policies to AWS principals and authorized users only. Settings apply at the **account level** (all buckets) or **bucket level**. Account-level settings override bucket-level. Enabled by default for new buckets. Recommended to keep all four enabled.

---

### Card 47
**Q:** How do you share EBS snapshots cross-account or cross-region?
**A:** **Cross-account**: modify snapshot permissions to add the target account ID (or make it public). If the snapshot is encrypted with a CMK, you must also share the KMS key with the target account. AWS managed keys cannot be shared cross-account. **Cross-region**: copy the snapshot to the target region (encryption can be changed during copy). The target account can then create volumes from the shared/copied snapshot. Snapshots of encrypted volumes are always encrypted.

---

### Card 48
**Q:** What is S3 Multi-Part Upload abort policy?
**A:** Incomplete multipart uploads accumulate parts in S3, consuming storage and incurring charges. Use a **lifecycle rule** with `AbortIncompleteMultipartUpload` to automatically clean up incomplete multipart uploads after a specified number of days. Example: abort incomplete uploads after 7 days. This is a best practice to prevent unbounded storage costs from failed or abandoned uploads. Applies only to parts, not completed uploads.

---

### Card 49
**Q:** What is S3 Cross-Region Replication time control (S3 RTC)?
**A:** S3 Replication Time Control provides a guaranteed SLA that 99.99% of new objects are replicated within **15 minutes**. Without RTC, replication is "best effort" and may take longer. RTC includes **S3 Replication Metrics** (time to replicate, operations pending, bytes pending) published to CloudWatch, and **S3 Event Notifications** for replication failures. Use for compliance or business requirements that mandate a maximum replication time.

---

### Card 50
**Q:** What is an S3 website endpoint vs. a REST API endpoint?
**A:** **Website endpoint**: `http://<bucket>.s3-website-<region>.amazonaws.com` – supports only HTTP (not HTTPS), returns HTML error documents, supports redirects, serves index documents. **REST API endpoint**: `https://<bucket>.s3.<region>.amazonaws.com` – supports HTTPS, returns XML error responses, no redirect support, used for programmatic access. For static website hosting with HTTPS, use CloudFront in front of the website endpoint with an SSL certificate from ACM.

---

*End of Deck 4 — 50 cards*
