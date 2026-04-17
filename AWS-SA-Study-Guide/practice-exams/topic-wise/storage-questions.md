# Storage Question Bank

**AWS Solutions Architect Associate (SAA-C03) — Topic-Wise Practice**
**Total Questions: 30**

---

### Question 1
A company stores log files in an S3 bucket. The logs are frequently accessed for the first 30 days, then rarely accessed for 90 days, and never accessed after 120 days. The company wants to minimize storage costs. What should the architect configure?

A) Store all logs in S3 Standard and manually delete old logs
B) Create an S3 lifecycle policy: transition to S3 Standard-IA after 30 days, to S3 Glacier Flexible Retrieval after 120 days, and delete after 365 days
C) Store all logs in S3 Glacier from day one
D) Use S3 Intelligent-Tiering for all logs

**Answer: B**
**Explanation:** A lifecycle policy automates cost optimization by transitioning objects through storage classes based on age. Standard for frequent access (first 30 days), Standard-IA for infrequent access (30-120 days), and Glacier for archival. Option A is manual. Option C makes logs inaccessible for the first 30 days of frequent use. Option D works but incurs monitoring fees per object that may exceed savings for predictable access patterns.

---

### Question 2
A company needs to store 500 TB of data in S3 that must be available within 12 hours when needed for compliance audits. Audits happen once per year. What is the MOST cost-effective storage class?

A) S3 Standard
B) S3 Standard-IA
C) S3 Glacier Deep Archive
D) S3 Glacier Flexible Retrieval

**Answer: C**
**Explanation:** S3 Glacier Deep Archive is the cheapest storage class and provides retrieval within 12 hours (standard retrieval). For data accessed once per year with a 12-hour retrieval tolerance, this is optimal. Standard (A) and Standard-IA (B) are unnecessarily expensive. Glacier Flexible Retrieval (D) is cheaper than Standard-IA but more expensive than Deep Archive.

---

### Question 3
A company wants to ensure that S3 objects cannot be deleted or overwritten for 7 years to meet regulatory requirements. Even the root user should not be able to remove the objects. What should the architect configure?

A) S3 bucket policy denying `s3:DeleteObject`
B) S3 Object Lock in Compliance mode with a 7-year retention period
C) S3 Object Lock in Governance mode with a 7-year retention period
D) S3 versioning with MFA Delete enabled

**Answer: B**
**Explanation:** S3 Object Lock in Compliance mode prevents ANY user, including the root account, from deleting or overwriting objects until the retention period expires. Governance mode (C) allows users with special permissions to override the lock. Bucket policies (A) can be modified by authorized users. MFA Delete (D) adds a layer but doesn't prevent deletion entirely.

---

### Question 4
A company has an on-premises NFS file server used by multiple Linux-based application servers. They want to migrate to AWS and need a shared file system accessible from multiple EC2 instances across Availability Zones. What should the architect recommend?

A) Amazon EBS with Multi-Attach
B) Amazon EFS (Elastic File System)
C) Amazon S3 mounted with S3 FUSE
D) Amazon FSx for Windows File Server

**Answer: B**
**Explanation:** Amazon EFS is a fully managed NFS file system that can be mounted by thousands of EC2 instances across AZs simultaneously. It's the natural replacement for on-premises NFS. EBS Multi-Attach (A) only works with io1/io2 volumes and is limited to instances in the same AZ. S3 FUSE (C) has performance limitations. FSx for Windows (D) uses the SMB protocol, not NFS.

---

### Question 5
A company is migrating a Windows file server with SMB shares to AWS. The file server uses Windows ACLs for access control and Active Directory for authentication. What storage service should the architect recommend?

A) Amazon EFS
B) Amazon FSx for Windows File Server
C) Amazon S3 with IAM policies
D) Amazon EBS attached to a Windows EC2 instance

**Answer: B**
**Explanation:** Amazon FSx for Windows File Server provides fully managed Windows file shares with native SMB protocol support, Windows NTFS, and Active Directory integration. It supports Windows ACLs natively. EFS (A) uses NFS and doesn't support SMB or Windows ACLs. S3 (C) is object storage. EBS (D) is block storage that can't be shared and doesn't provide managed file server features.

---

### Question 6
A company has 80 TB of data on-premises that needs to be transferred to S3. Their internet connection is 100 Mbps. They need the data in AWS within 1 week. What is the MOST efficient transfer method?

A) Upload directly over the internet using S3 multipart upload
B) Use AWS Snowball Edge Storage Optimized
C) Set up AWS Direct Connect for the transfer
D) Use AWS DataSync over the internet connection

**Answer: B**
**Explanation:** At 100 Mbps, transferring 80 TB would take approximately 74 days, far exceeding the 1-week deadline. Snowball Edge can be shipped, loaded, and returned within a week. Direct Connect (C) takes weeks to provision. DataSync (D) and multipart upload (A) are limited by the 100 Mbps connection bandwidth.

---

### Question 7
A company wants to enable cross-region replication for their S3 bucket containing critical data. The destination bucket must use a different storage class. What prerequisites must be met?

A) Both buckets must have versioning enabled and be in the same account
B) Both buckets must have versioning enabled; they can be in different accounts
C) Cross-region replication automatically enables versioning
D) Both buckets must use the same storage class

**Answer: B**
**Explanation:** S3 cross-region replication requires versioning to be enabled on both source and destination buckets. The buckets can be in different AWS accounts and can use different storage classes (e.g., source in Standard, destination in S3-IA). Replication does not auto-enable versioning (C). Same storage class is not required (D).

---

### Question 8
A company stores objects in S3 and wants to automatically classify and move objects to the most cost-effective storage class based on actual access patterns. The access patterns are unpredictable. What should the architect recommend?

A) S3 Lifecycle policies with fixed transition rules
B) S3 Intelligent-Tiering
C) S3 Standard-IA for all objects
D) CloudWatch monitoring with Lambda to move objects

**Answer: B**
**Explanation:** S3 Intelligent-Tiering automatically moves objects between tiers (Frequent, Infrequent, Archive Instant Access, Archive, Deep Archive) based on access patterns. There are no retrieval fees. It's ideal for unpredictable access patterns. Fixed lifecycle rules (A) are for predictable patterns. Standard-IA (C) incurs retrieval fees. Custom Lambda (D) is operationally complex.

---

### Question 9
A company has an EBS-backed EC2 instance that needs to be backed up daily. The backup must be retained for 30 days and copied to another region for disaster recovery. What is the MOST operationally efficient solution?

A) Write a cron job on the instance to create EBS snapshots using AWS CLI
B) Use Amazon Data Lifecycle Manager (DLM) with cross-region copy
C) Use AWS Backup with a backup plan and cross-region copy rule
D) Manually create snapshots daily and copy them using a script

**Answer: C**
**Explanation:** AWS Backup provides a centralized, fully managed service to automate backup creation, retention, and cross-region copy. It supports EBS, RDS, EFS, and more. DLM (B) also works for EBS snapshots but AWS Backup provides broader service coverage and centralized management. Cron jobs (A) and manual scripts (D) are operationally burdensome and error-prone.

---

### Question 10
A company needs a high-performance file system for a machine learning training workload. The data is stored in S3 and needs to be accessed with sub-millisecond latency during training. What should the architect recommend?

A) Amazon EFS with Provisioned Throughput mode
B) Amazon FSx for Lustre linked to the S3 bucket
C) Copy data from S3 to EBS volumes before training
D) Use S3 Select for faster data access

**Answer: B**
**Explanation:** Amazon FSx for Lustre is a high-performance file system designed for compute-intensive workloads. It can be linked to an S3 bucket, automatically staging S3 data and writing results back. It provides sub-millisecond latency. EFS (A) is not designed for HPC-level performance. Copying to EBS (C) is manual and slow. S3 Select (D) is for querying subsets of data, not high-throughput reads.

---

### Question 11
A company needs to encrypt all data stored in an S3 bucket. They want AWS to manage the encryption keys but need to control the key rotation schedule. What encryption method should they use?

A) SSE-S3 (S3-managed keys)
B) SSE-KMS (AWS KMS-managed keys)
C) SSE-C (Customer-provided keys)
D) Client-side encryption

**Answer: B**
**Explanation:** SSE-KMS uses AWS KMS keys where you can control the key rotation schedule (automatic annual rotation or manual rotation). SSE-S3 (A) manages keys entirely by AWS — you cannot control the rotation schedule. SSE-C (C) requires you to provide and manage your own keys. Client-side encryption (D) encrypts before upload and requires key management.

---

### Question 12
A company has a legacy application that uses block storage and requires a POSIX-compliant file system. The storage must support concurrent access from hundreds of EC2 instances across multiple AZs. What is the BEST solution?

A) Amazon EBS with Multi-Attach enabled
B) Amazon EFS in General Purpose performance mode
C) Amazon S3 with S3FS-FUSE
D) Amazon FSx for Windows File Server

**Answer: B**
**Explanation:** Amazon EFS is POSIX-compliant, supports NFSv4, and allows concurrent access from thousands of instances across multiple AZs. General Purpose mode is suitable for latency-sensitive workloads. EBS Multi-Attach (A) is limited to the same AZ and only for io1/io2. S3FS (C) is not truly POSIX-compliant and has performance issues. FSx for Windows (D) is SMB-based.

---

### Question 13
A company has configured S3 versioning on a bucket. A developer accidentally uploads a new version of an important file that overwrites the correct data. How can the architect restore the previous version?

A) It's not possible once a new version is uploaded
B) Delete the current version (which is a delete marker) to restore the previous version
C) Copy the previous version ID back as the current version using the S3 API
D) Contact AWS Support to restore the previous version

**Answer: C**
**Explanation:** With versioning enabled, uploading a new object creates a new version without deleting the old one. You can retrieve any previous version using its version ID and copy it back (or just access it directly). Delete markers (B) are created when you "delete" an object, not when you upload a new version. AWS Support (D) is unnecessary.

---

### Question 14
A company needs to migrate 2 PB of data from their on-premises data center to S3. Their network bandwidth is limited. They need the migration completed within 3 months. What should the architect recommend?

A) AWS DataSync with Direct Connect
B) Multiple AWS Snowball Edge devices shipped in parallel
C) AWS Snowmobile
D) S3 Transfer Acceleration

**Answer: B**
**Explanation:** For 2 PB, multiple Snowball Edge devices (each up to 80 TB) can be shipped in parallel to meet the 3-month timeline. Snowmobile (C) is designed for 10 PB+ and involves a shipping container truck — overkill for 2 PB. DataSync with Direct Connect (A) depends on bandwidth availability and provisioning time. S3 Transfer Acceleration (D) is still limited by internet bandwidth.

---

### Question 15
A company stores sensitive documents in S3 and wants to ensure that any object uploaded without server-side encryption is automatically rejected. What should the architect configure?

A) Enable default encryption on the S3 bucket
B) Create a bucket policy that denies `s3:PutObject` where `s3:x-amz-server-side-encryption` is absent
C) Use S3 Object Lock to enforce encryption
D) Enable versioning to track unencrypted objects

**Answer: B**
**Explanation:** A bucket policy with a condition denying `PutObject` when the `s3:x-amz-server-side-encryption` header is absent actively rejects unencrypted uploads. Default encryption (A) encrypts objects that arrive without encryption but doesn't reject them — it applies encryption at rest. Object Lock (C) is for immutability, not encryption. Versioning (D) tracks versions, not encryption state.

---

### Question 16
A company runs a high-performance database on EC2 that requires low-latency storage with consistent IOPS. The database is 2 TB and requires 50,000 IOPS. The company also needs the ability to create point-in-time backups. What storage solution should the architect use?

A) Instance store volumes in RAID 0
B) Single io2 Block Express EBS volume
C) Multiple gp3 volumes in RAID 0
D) Amazon EFS with Provisioned Throughput

**Answer: B**
**Explanation:** A single io2 Block Express volume supports up to 256,000 IOPS and allows EBS snapshots for point-in-time backups. Instance store (A) cannot be backed up with snapshots and data is lost if the instance stops. Multiple gp3 in RAID 0 (C) can achieve 50,000 IOPS but adds complexity and RAID management. EFS (D) is not suited for database workloads requiring consistent IOPS.

---

### Question 17
A company wants to provide on-premises applications with low-latency access to S3 data. The on-premises servers use NFS. What should the architect recommend?

A) AWS DataSync to continuously sync S3 data to on-premises NFS
B) AWS Storage Gateway — File Gateway
C) AWS Direct Connect to access S3 directly
D) Mount S3 as an NFS share using s3fs-fuse

**Answer: B**
**Explanation:** AWS Storage Gateway File Gateway presents an NFS/SMB interface on-premises while storing data in S3. It caches frequently accessed data locally for low-latency access. DataSync (A) performs scheduled transfers, not real-time access. Direct Connect (C) improves bandwidth but doesn't provide NFS access. s3fs-fuse (D) has performance and reliability limitations.

---

### Question 18
A company has an application that writes temporary data at high throughput. The data is only needed during the instance's lifetime and can be recreated if lost. What is the MOST cost-effective and highest performance storage option?

A) EBS gp3 volume
B) EBS io2 volume
C) Instance store volume
D) Amazon EFS

**Answer: C**
**Explanation:** Instance store volumes provide the highest I/O performance (physically attached SSDs or NVMe drives) at no additional cost (included in the instance price). Since the data is temporary and can be recreated, the ephemeral nature of instance store is acceptable. EBS volumes (A, B) incur additional costs and have lower performance. EFS (D) is designed for shared access, not local high-throughput temp storage.

---

### Question 19
A company stores petabytes of data in S3. They want to analyze query access patterns to understand which prefixes are most accessed and optimize their bucket structure. What should the architect enable?

A) S3 server access logging
B) CloudTrail data events for S3
C) S3 Storage Lens
D) S3 Inventory

**Answer: C**
**Explanation:** S3 Storage Lens provides organization-wide visibility into storage usage, activity trends, and access patterns with recommendations. It can identify hot prefixes and access patterns. Server access logs (A) provide per-request logs but require custom analysis. CloudTrail data events (B) log API calls but are expensive at scale. S3 Inventory (C) lists objects but doesn't analyze access patterns.

---

### Question 20
A company needs to replicate S3 objects from one bucket to another in the same region for compliance. The replicated objects must be owned by the destination account (different from the source). What should the architect configure?

A) Cross-region replication (CRR) with ownership override
B) Same-region replication (SRR) with the Object Ownership setting set to override the source object owner
C) Copy objects using a Lambda function triggered by S3 events
D) S3 batch operations to copy objects periodically

**Answer: B**
**Explanation:** Same-region replication (SRR) supports replication within the same region. The ownership override setting changes the object owner to the destination bucket owner, which is required when buckets are in different accounts and the destination account needs to control the objects. CRR (A) is for different regions. Lambda (C) and batch operations (D) are custom solutions.

---

### Question 21
A company's EBS volume is experiencing high I/O latency. The volume is a gp2 type with 100 GB capacity (baseline of 300 IOPS). CloudWatch shows IOPS usage frequently hitting 300. What should the architect recommend?

A) Increase the gp2 volume size to increase baseline IOPS
B) Switch to a gp3 volume and provision higher IOPS independently
C) Switch to an io2 volume for consistent high IOPS
D) All of the above are valid options

**Answer: D**
**Explanation:** All three options are valid: gp2 IOPS scales with volume size (3 IOPS/GB), so increasing size increases baseline (A). gp3 decouples IOPS from volume size, allowing independent provisioning up to 16,000 IOPS (B). io2 provides the highest consistent IOPS for demanding workloads (C). The best choice depends on cost vs. performance requirements.

---

### Question 22
A company is running a data analytics workload that reads large sequential files from S3. The total dataset is 50 TB. They want to maximize read throughput when querying data using Athena. How should data be organized in S3?

A) Store all files in a single S3 prefix
B) Partition data by commonly queried fields (e.g., year/month/day) and use columnar format (Parquet)
C) Use the smallest possible file sizes (1 KB each)
D) Enable S3 Transfer Acceleration

**Answer: B**
**Explanation:** Partitioning by commonly queried fields reduces the amount of data Athena scans, improving performance and reducing cost. Columnar formats like Parquet allow Athena to read only the columns needed. Single prefix (A) forces full scans. Very small files (C) cause overhead from many S3 GET requests. Transfer Acceleration (D) is for upload speed, not query performance.

---

### Question 23
A company needs to share a large dataset in S3 with an external partner's AWS account. The partner must only read the data and not modify or delete it. What is the MOST secure approach?

A) Make the bucket public and share the URL
B) Create a cross-account IAM role with read-only S3 permissions
C) Generate pre-signed URLs for each object
D) Add a bucket policy granting `s3:GetObject` to the partner's AWS account ID

**Answer: D**
**Explanation:** A bucket policy granting `s3:GetObject` to the partner's specific AWS account ID provides read-only access without exposing data publicly. Cross-account roles (B) work but give broader access unless carefully scoped and are better for interactive access. Pre-signed URLs (C) expire and are impractical for large datasets. Public access (A) violates security requirements.

---

### Question 24
A company needs to restore an EBS snapshot to a volume and requires full performance immediately. What should the architect do?

A) Create the volume from the snapshot and start using it immediately — EBS handles lazy loading
B) Create the volume from the snapshot and enable EBS Fast Snapshot Restore (FSR) to eliminate latency on first access
C) Create the volume from the snapshot and run `fio` to read all blocks before use
D) Create the volume from the snapshot and wait 24 hours before use

**Answer: B**
**Explanation:** Fast Snapshot Restore (FSR) pre-initializes the volume so reads from restored snapshots don't experience the first-access latency penalty. Without FSR (A), blocks are lazily loaded on first access, causing increased latency. Running fio (C) works but is time-consuming. Waiting 24 hours (D) is unnecessary and doesn't guarantee initialization.

---

### Question 25
A company has enabled S3 versioning and is concerned about storage costs growing as old versions accumulate. They want to keep the current version in Standard and delete non-current versions after 30 days. What should they configure?

A) A lifecycle policy with a `NoncurrentVersionExpiration` action set to 30 days
B) A Lambda function to delete old versions nightly
C) S3 Intelligent-Tiering for non-current versions
D) Disable versioning after 30 days

**Answer: A**
**Explanation:** S3 lifecycle policies support `NoncurrentVersionExpiration` which automatically deletes non-current versions after a specified number of days. This is the native, operationally efficient approach. Lambda (B) is custom and error-prone. Intelligent-Tiering (C) reduces cost but doesn't delete versions. Disabling versioning (D) stops creating new versions but doesn't delete existing ones.

---

### Question 26
A company has a hybrid environment where on-premises applications need block storage backed by S3 for backup purposes. What should the architect use?

A) AWS Storage Gateway — File Gateway
B) AWS Storage Gateway — Volume Gateway (Stored Volumes mode)
C) AWS Storage Gateway — Volume Gateway (Cached Volumes mode)
D) AWS Storage Gateway — Tape Gateway

**Answer: B**
**Explanation:** Volume Gateway in Stored Volumes mode stores the entire dataset locally (providing low-latency block storage) and asynchronously backs up point-in-time snapshots to S3 (as EBS snapshots). Cached Volumes mode (C) stores only frequently accessed data locally. File Gateway (A) provides NFS/SMB, not block storage. Tape Gateway (D) is for tape backup replacement.

---

### Question 27
A company wants to transfer data between their on-premises NFS server and Amazon EFS on a recurring schedule. They want automated, encrypted transfers with bandwidth throttling. What should the architect recommend?

A) rsync over SSH
B) AWS DataSync
C) AWS Transfer Family
D) S3 CLI sync command

**Answer: B**
**Explanation:** AWS DataSync automates data transfers between on-premises storage (NFS, SMB) and AWS storage services (S3, EFS, FSx). It provides encryption in-transit, scheduling, bandwidth throttling, and data integrity verification. rsync (A) requires manual setup. Transfer Family (C) is for SFTP/FTP access to S3. S3 CLI sync (D) is for S3, not EFS.

---

### Question 28
A company runs a media processing pipeline. Large video files (50 GB each) are uploaded to S3. Uploads over the internet are slow. What can improve upload performance?

A) S3 Transfer Acceleration
B) Use smaller file sizes
C) S3 multipart upload with Transfer Acceleration
D) Use CloudFront to upload files

**Answer: C**
**Explanation:** Combining multipart upload (parallel upload of parts) with S3 Transfer Acceleration (which routes uploads through CloudFront edge locations to S3 over optimized network paths) maximizes upload speed. Transfer Acceleration alone (A) helps but multipart upload adds parallelism. Smaller files (B) are impractical for video. CloudFront (D) is for content delivery, not direct S3 uploads.

---

### Question 29
A company runs a high-performance computing workload on EC2 that requires a shared POSIX file system with sub-millisecond latency and hundreds of GB/s throughput. What storage solution should the architect recommend?

A) Amazon EFS with Max I/O performance mode
B) Amazon FSx for Lustre
C) Amazon S3 with S3 Select
D) Amazon EBS volumes shared via NFS on EC2

**Answer: B**
**Explanation:** Amazon FSx for Lustre provides sub-millisecond latency and hundreds of GB/s throughput, specifically designed for HPC and machine learning workloads. EFS Max I/O (A) supports high throughput but with higher latency. S3 (C) is object storage, not a POSIX file system. Manual NFS on EBS (D) is complex, limited, and not high-performance.

---

### Question 30
A company wants to prevent accidental deletion of their S3 bucket that contains critical data. They also want to protect against accidental object deletion. What combination of features should be enabled?

A) Bucket policy denying `s3:DeleteBucket` and MFA Delete on versioning
B) S3 versioning only
C) S3 Object Lock only
D) Cross-region replication only

**Answer: A**
**Explanation:** A bucket policy denying `s3:DeleteBucket` protects the bucket itself. MFA Delete requires MFA to permanently delete object versions, protecting against accidental deletion. Versioning alone (B) protects objects but not the bucket. Object Lock (C) prevents modification/deletion of objects but doesn't protect the bucket. CRR (D) replicates data but doesn't prevent deletion at the source.

---

*End of Storage Question Bank*
