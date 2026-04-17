# AWS Certified Solutions Architect - Professional (SAP-C02) Practice Test 27

**Focus Areas:** Storage Deep Dive — S3 Object Lock, Glacier, FSx, EFS, Storage Gateway, Snow Family
**Time Limit:** 180 minutes
**Total Questions:** 75
**Passing Score:** 750/1000

---

## Domain Distribution
- Domain 1 – Organizational Complexity: Questions 1–20
- Domain 2 – Design New Solutions: Questions 21–42
- Domain 3 – Continuous Improvement: Questions 43–53
- Domain 4 – Migration: Questions 54–62
- Domain 5 – Cost Optimization: Questions 63–75

---

### Question 1

A financial services company with 50 AWS accounts under AWS Organizations must ensure that all S3 buckets containing audit data across every account have Object Lock enabled in Compliance mode with a 7-year retention period. No one, including root users, should be able to delete or modify these objects during the retention period. The policy must automatically apply to new accounts.

Which approach provides the MOST comprehensive enforcement?

A. Create an SCP attached to the root OU that denies `s3:PutObjectRetention` with a condition that the retention mode is not `COMPLIANCE` or the retention period is less than 7 years. Deploy an AWS Config organizational rule that checks all S3 buckets for Object Lock configuration. Use a conformance pack with auto-remediation via SSM Automation to enable Object Lock on non-compliant buckets.

B. Enable S3 Object Lock on each bucket manually and set default retention to 7 years in Compliance mode across all accounts.

C. Use S3 bucket policies in each account that deny delete operations. Create a Lambda function to apply policies to new buckets.

D. Enable MFA Delete on all audit buckets and restrict the MFA device to the security team.

**Correct Answer: A**

**Explanation:** SCPs prevent anyone in member accounts (including root users at the account level, though not the management account root) from weakening Object Lock settings below the required Compliance mode and 7-year retention. The Config organizational rule provides continuous compliance monitoring across all accounts, including new ones. Auto-remediation via SSM Automation ensures non-compliant buckets are automatically configured. Option B is manual and doesn't scale or enforce on new accounts. Option C uses bucket policies, which can be modified by account administrators. Option D doesn't prevent object deletion—MFA Delete only requires MFA for delete operations but doesn't enforce retention periods.

---

### Question 2

A healthcare organization stores patient records across 200 S3 buckets in 10 accounts. Regulatory compliance requires that specific records be placed on legal hold independently from the bucket's default retention policy. When a legal investigation begins, records matching specific metadata criteria must be frozen immediately. When the investigation ends, the hold must be lifted. The solution must handle thousands of legal hold operations per day.

Which architecture meets these requirements?

A. Enable S3 Object Lock on all buckets. When a legal investigation begins, use a Step Functions workflow that queries an S3 Inventory manifest (or an indexed metadata store in DynamoDB) to identify matching objects. The workflow's Map state invokes Lambda functions that call `PutObjectLegalHold` with status `ON` for each matching object across all accounts using cross-account IAM roles. When the investigation ends, the reverse workflow sets legal hold status to `OFF`. Track all hold operations in a DynamoDB audit table.

B. Move objects under legal hold to a separate "legal hold" S3 bucket with Object Lock Compliance mode enabled. Move them back when the hold is lifted.

C. Modify the default retention period on the bucket to extend it when a legal hold is needed.

D. Use S3 Glacier Vault Lock policies to freeze objects during investigations.

**Correct Answer: A**

**Explanation:** S3 Object Lock's Legal Hold feature is purpose-built for this use case—it's independent of retention periods and can be toggled on/off per object without time limits. Step Functions with Map state provides parallel processing for thousands of objects. Cross-account IAM roles enable centralized management. DynamoDB tracks the audit trail. The S3 Inventory or indexed metadata store enables efficient identification of matching objects. Option B requires moving objects, which is expensive at scale and may violate data residency requirements. Option C affects all objects in the bucket, not specific records. Option D applies vault-level policies, not object-level holds, and Glacier is not suitable for records that need immediate access.

---

### Question 3

A media company stores 50 PB of video content across multiple S3 buckets. They need to implement a tiered storage strategy where: (1) content accessed in the last 30 days stays in S3 Standard, (2) content not accessed for 30-90 days moves to S3 Intelligent-Tiering, (3) content not accessed for 90-365 days moves to S3 Glacier Instant Retrieval, and (4) content older than 1 year moves to S3 Glacier Deep Archive. Object Lock must be maintained across all transitions.

Which configuration implements this correctly?

A. Create S3 Lifecycle policies on each bucket that transition objects from Standard to Intelligent-Tiering after 30 days, from Intelligent-Tiering to Glacier Instant Retrieval after 90 days, and to Glacier Deep Archive after 365 days. Object Lock retention and legal holds are preserved across storage class transitions. Deploy lifecycle rules using CloudFormation StackSets across all accounts for consistency.

B. Create Lambda functions triggered by S3 access patterns that manually copy objects to different storage classes based on last access time, then delete the originals.

C. Use S3 Intelligent-Tiering for all data from day one, configuring the archive access tiers to automatically move data to Glacier and Deep Archive tiers.

D. Keep all data in S3 Standard and use S3 Select to access only the parts of video files needed, reducing costs through selective retrieval rather than storage tiering.

**Correct Answer: A**

**Explanation:** S3 Lifecycle policies handle automatic transitions between storage classes based on object age. Critically, Object Lock retention settings and legal holds are preserved when objects transition between storage classes—this is a native S3 feature. CloudFormation StackSets ensure consistent lifecycle rule deployment across all accounts. Option B requires moving objects, which is complex, expensive, and may break Object Lock (copy creates a new object). Option C is a viable alternative but S3 Intelligent-Tiering's archive tiers use Glacier Flexible Retrieval and Deep Archive, which may not align with the specific transition timing requirements (Intelligent-Tiering monitors access patterns, not calendar-based). Option D doesn't address storage costs for 50 PB.

---

### Question 4

A multinational bank operates in 15 countries with data residency requirements—customer data must remain within the country of origin. They use S3 for document storage. Each country has its own AWS account and Region. The central compliance team needs to audit Object Lock configurations across all countries without having direct access to customer data.

Which architecture enables centralized compliance auditing?

A. Deploy S3 Storage Lens at the organization level with advanced metrics enabled, which includes Object Lock configuration metrics. Create a delegated administrator account for Storage Lens. The compliance team accesses the Storage Lens dashboard to view Object Lock status, retention configurations, and compliance metrics across all accounts and Regions without accessing the actual objects. Supplement with AWS Config organizational rules for `s3-bucket-default-lock-enabled`.

B. Create a Lambda function in each account that reads bucket configurations and publishes metrics to a central CloudWatch dashboard via cross-account metrics sharing.

C. Use S3 Inventory configured in each account to report Object Lock status, with inventory files replicated to a central account.

D. Give the compliance team read access to all S3 buckets across all countries using cross-account IAM roles.

**Correct Answer: A**

**Explanation:** S3 Storage Lens provides organization-wide visibility into storage metrics including Object Lock configurations without granting access to the actual data. Advanced metrics include detailed lock status information. The delegated administrator model allows the compliance team to manage Storage Lens without management account access. AWS Config organizational rules complement this by providing continuous compliance checks for Object Lock enablement. Option B is a custom solution requiring maintenance in every account. Option C provides data but requires processing inventory files—less real-time than Storage Lens. Option D violates data residency requirements by granting cross-border data access.

---

### Question 5

A company uses S3 Glacier Deep Archive for long-term backup retention. A disaster recovery event requires restoring 500 TB of data within 12 hours. They discover that Glacier Deep Archive standard retrieval takes up to 12 hours and bulk retrieval takes up to 48 hours. The company didn't plan for this retrieval timeline.

Which combination of actions provides the fastest recovery? (Choose TWO.)

A. Initiate standard retrieval requests for all objects immediately. Standard retrieval for Deep Archive completes within 12 hours, meeting the deadline. Parallelize the retrieval requests using multiple Lambda functions to ensure all 500 TB of restore requests are submitted quickly.

B. Contact AWS Support to request an expedited retrieval for Deep Archive objects (available for Glacier Flexible Retrieval but not Deep Archive).

C. While waiting for Glacier restores, evaluate if a subset of the most critical data (identified by tags or prefixes) can be restored first. Initiate standard retrieval for critical data and bulk retrieval for non-critical data to manage costs while meeting the 12-hour SLA for essential data.

D. Use S3 Batch Operations with a manifest from S3 Inventory to submit restore requests for all 500 TB simultaneously, ensuring efficient parallel submission within API rate limits.

E. Copy all data from Deep Archive to another S3 bucket to trigger faster access.

**Correct Answer: A, D**

**Explanation:** (A) Standard retrieval for Deep Archive completes within 12 hours, which meets the deadline. Starting immediately is critical since every hour of delay reduces the margin. (D) S3 Batch Operations efficiently submits restore requests for millions of objects in parallel using an S3 Inventory manifest, handling API throttling automatically—far more efficient than scripting individual RestoreObject calls. Option B is incorrect—expedited retrieval is not available for Deep Archive. Option C is a good prioritization strategy but doesn't ensure full 500 TB recovery within 12 hours. Option E doesn't work—you can't copy archived objects without first restoring them.

---

### Question 6

A research institution has 200 TB of genomics data in S3 Standard. Multiple research teams across 5 AWS accounts need read access. Data must not be copied or moved—there should be one authoritative copy. Some teams need access to entire datasets while others need column-level access to CSV/Parquet files. All access must be logged.

Which approach provides centralized data sharing with granular access control?

A. Create S3 Access Points for each research team in the data account. Each access point has a customized access policy scoped to the team's allowed prefixes and operations. For column-level access, use S3 Object Lambda access points that filter CSV/Parquet content through a Lambda function before delivering to the requesting team. Enable access point access logging via S3 server access logs. Use Resource Access Manager to share the access points cross-account.

B. Use S3 Cross-Region Replication to copy relevant subsets to each team's account.

C. Create bucket policies that grant cross-account access based on IAM roles in each team's account.

D. Use Lake Formation with S3 data locations registered. Grant column-level permissions to cross-account principals via Lake Formation.

**Correct Answer: D**

**Explanation:** AWS Lake Formation provides native column-level access control for structured data (CSV/Parquet) stored in S3. By registering the S3 locations in Lake Formation and creating a Glue Data Catalog over the data, you can grant column-level permissions to principals in other accounts through Lake Formation's cross-account sharing. All access is logged through CloudTrail and Lake Formation audit logs. This provides both dataset-level and column-level granularity from a single authoritative copy. Option A requires building a custom Lambda function for column-level filtering, which is complex and slow for large files. Option B creates copies, violating the single-copy requirement. Option C provides prefix-level access but no column-level granularity.

---

### Question 7

A company needs to implement S3 Object Lock across 500 existing buckets that were created without Object Lock enabled. Object Lock can only be enabled at bucket creation time. The company has 100 TB of data in these buckets with ongoing write operations.

Which migration approach enables Object Lock with minimal disruption?

A. Create new S3 buckets with Object Lock enabled. Use S3 Batch Replication to replicate all existing objects from old buckets to new buckets with Object Lock. Configure the new buckets with the desired default retention policy. Update application endpoints to write to the new buckets. After replication completes and all applications are migrated, verify object counts and sizes match, then decommission old buckets. Enable S3 Replication time control for SLA guarantees on replication completeness.

B. Use the S3 API to enable Object Lock on existing buckets retroactively.

C. Contact AWS Support to enable Object Lock on existing buckets through a special support request.

D. Create an SCP that simulates Object Lock by denying delete operations on the existing buckets.

**Correct Answer: A**

**Explanation:** S3 Object Lock must be enabled at bucket creation—it cannot be enabled retroactively on existing buckets. The migration requires creating new buckets with Object Lock, replicating data using S3 Batch Replication (which handles existing objects efficiently), and switching application endpoints. S3 Replication Time Control provides an SLA (15 minutes for 99.99% of objects) ensuring replication completeness. The parallel-run period allows verification before decommissioning old buckets. Option B is not supported—Object Lock cannot be enabled on existing buckets. Option C is also not possible—AWS Support cannot retroactively enable Object Lock. Option D doesn't provide true Object Lock protections (SCPs don't apply to the management account root user, and bucket policies can be changed).

---

### Question 8

A law firm needs to store case evidence in S3 with the following requirements: (1) evidence once uploaded cannot be modified or deleted for 10 years (Compliance mode), (2) individual pieces of evidence may be placed on legal hold indefinitely, (3) evidence must be retrievable within 5 minutes when needed for court proceedings, (4) access must be limited to specific case teams, and (5) all access must produce court-admissible audit logs.

Which S3 configuration meets ALL requirements?

A. Create S3 buckets with Object Lock enabled in Compliance mode with a 10-year default retention. Use S3 Glacier Instant Retrieval as the storage class for cost optimization while maintaining the 5-minute retrieval requirement (millisecond first-byte latency). Configure S3 access points per case team with restrictive policies. Enable CloudTrail data events for all S3 operations and store logs in a separate Object Lock-protected bucket. Legal holds are applied per evidence item as needed, independent of the retention period.

B. Use S3 Standard with Object Lock for recent evidence and Glacier Flexible Retrieval for older evidence with a lifecycle transition after 1 year.

C. Store evidence in S3 Standard with bucket versioning and MFA Delete enabled. Use IAM policies to restrict access per case team.

D. Use S3 Object Lock in Governance mode so the firm's administrator can override retention if needed for legal reasons.

**Correct Answer: A**

**Explanation:** S3 Object Lock Compliance mode ensures no one (including root) can delete or modify evidence during the 10-year retention—this is the correct choice for legal evidence preservation. Glacier Instant Retrieval provides millisecond first-byte latency (meeting the 5-minute requirement) at lower cost than Standard. Legal holds can be applied independently on top of retention. Per-case-team access points provide isolation. CloudTrail data events in an Object Lock-protected bucket create a tamper-proof audit trail admissible in court. Option B uses Glacier Flexible Retrieval, which has 3-5 hour retrieval—too slow for court proceedings. Option C doesn't prevent deletion by administrators. Option D allows administrators to bypass retention, which undermines evidence integrity.

---

### Question 9

A company operates a high-performance computing (HPC) cluster on EC2 with 100 compute-optimized instances. The workload requires a shared POSIX-compliant file system with sub-millisecond latency, consistent throughput of 10 GB/s, and the ability to process millions of small files (average 64 KB each).

Which storage solution BEST meets these requirements?

A. Amazon FSx for Lustre with a Persistent 2 deployment type on SSD storage. Configure the file system with the appropriate throughput per unit of storage to achieve 10 GB/s. FSx for Lustre provides POSIX-compliant access with sub-millisecond latencies and is optimized for HPC workloads with millions of small file operations.

B. Amazon EFS with Max I/O performance mode and Provisioned Throughput set to 10 GB/s.

C. Amazon FSx for Windows File Server with Multi-AZ deployment for high availability.

D. A shared EBS volume using EBS Multi-Attach with io2 Block Express volumes.

**Correct Answer: A**

**Explanation:** FSx for Lustre is the purpose-built HPC file system on AWS. The Persistent 2 deployment type provides consistent, low-latency performance suitable for long-running workloads. SSD storage delivers sub-millisecond latency. Lustre's architecture is specifically designed for high-throughput, small-file workloads with parallel I/O across hundreds of clients. It achieves 10 GB/s throughput through its parallel file system design. Option B's EFS Max I/O mode adds latency (not sub-millisecond) and may struggle with millions of small files at this throughput. Option C is Windows-based (SMB, not POSIX) and not designed for HPC. Option D is limited to 16 instances maximum with Multi-Attach and doesn't provide a shared file system.

---

### Question 10

A media production company needs shared storage for video editing workstations running on Amazon WorkSpaces (Windows). Requirements: (1) SMB protocol support, (2) Windows ACLs for permission management, (3) integration with their on-premises Active Directory, (4) Multi-AZ deployment for high availability, (5) minimum 2 TB storage with the ability to scale, and (6) data deduplication to reduce storage costs.

Which storage solution meets ALL requirements?

A. Amazon FSx for Windows File Server with a Multi-AZ deployment type. Configure it to join the on-premises Active Directory domain (via AWS Managed Microsoft AD with a trust or AD Connector). Enable data deduplication. Set the storage capacity to 2 TB with SSD storage for performance. FSx for Windows natively supports SMB, Windows ACLs, and AD integration.

B. Amazon EFS with an NFS-to-SMB gateway for Windows compatibility. Use IAM for access control.

C. Amazon FSx for NetApp ONTAP with SMB support and deduplication. Deploy in a single-AZ configuration with snapshots for resilience.

D. S3 with File Gateway (SMB) mounted on WorkSpaces. Use S3 bucket policies for access control.

**Correct Answer: A**

**Explanation:** FSx for Windows File Server is the native choice for Windows-based workloads requiring SMB access, Windows ACLs, and AD integration. Multi-AZ deployment provides automatic failover between AZs. Built-in data deduplication reduces storage costs (particularly effective for video editing with multiple versions). The file system joins the AD domain directly, enabling NTFS-level permission management. Option B uses EFS (NFS-based) with an additional gateway—complex and not native SMB. Option C with single-AZ doesn't meet the Multi-AZ requirement. Option D uses Storage Gateway, which introduces latency for video editing workflows and doesn't support Windows ACLs.

---

### Question 11

A company has a 500 TB data lake on-premises in an NFS file system. They want to synchronize this data to S3 daily, with incremental transfers of only changed files. The on-premises environment has a 10 Gbps Direct Connect link. The initial data load must complete within 2 weeks, and ongoing daily syncs must complete within an 8-hour overnight window. Typical daily changes are approximately 2 TB.

Which solution provides the MOST efficient data synchronization?

A. Deploy AWS DataSync agents on-premises connected to the NFS file system. Configure a DataSync task with the NFS location as source and S3 as destination. DataSync handles the initial full transfer using the 10 Gbps Direct Connect, completing 500 TB in approximately 5 days at 80% link utilization. Configure the task to run on a daily schedule for incremental transfers—DataSync compares metadata to identify changed files and transfers only those. Enable bandwidth throttling during business hours to avoid impacting other traffic.

B. Use `aws s3 sync` from an on-premises server over Direct Connect. Run it nightly as a cron job.

C. Set up Storage Gateway in file mode (File Gateway) to create an NFS mount backed by S3. Gradually copy data to the gateway.

D. Ship the initial 500 TB using AWS Snowball Edge devices. Then use DataSync for daily incremental syncs.

**Correct Answer: A**

**Explanation:** AWS DataSync is optimized for large-scale data transfers. It uses a purpose-built protocol with parallelization, compression, and integrity checking that can saturate a 10 Gbps link, achieving ~80% utilization (~1 GB/s, completing 500 TB in ~6 days). For daily incremental syncs, DataSync compares source and destination metadata to efficiently identify and transfer only changed files—2 TB daily completes in about 30 minutes on a 10 Gbps link. Option B uses `s3 sync`, which is single-threaded and much slower—it would take weeks for the initial transfer. Option C is designed for hybrid access, not bulk migration, and would be extremely slow. Option D adds unnecessary Snowball complexity when the 10 Gbps Direct Connect can handle the initial load within the 2-week window.

---

### Question 12

A pharmaceutical company needs to archive 1 PB of clinical trial data to Glacier Deep Archive. The data is currently on-premises in a tape library. They have a 1 Gbps internet connection and a tight compliance deadline requiring the data to be in AWS within 30 days. Network transfer at 1 Gbps would take approximately 93 days.

Which approach meets the deadline?

A. Order multiple AWS Snowball Edge Storage Optimized devices (80 TB usable each). Load data from the tape library onto 13-14 Snowball devices simultaneously. Ship them to AWS. Configure the Snowball import jobs to target S3 buckets with lifecycle policies that immediately transition objects to Glacier Deep Archive. The total turnaround time (shipping + data transfer) is typically 1-2 weeks for each device batch.

B. Upgrade the internet connection to 10 Gbps and transfer directly to S3 Glacier Deep Archive.

C. Use AWS Direct Connect with a 10 Gbps dedicated connection to transfer data.

D. Use a single Snowball Edge device and ship it back and forth multiple times within 30 days.

**Correct Answer: A**

**Explanation:** With 1 PB of data and only a 1 Gbps internet link (93 days for transfer), Snowball devices are the only solution that meets the 30-day deadline. Multiple Snowball Edge Storage Optimized devices (80 TB each) can be loaded in parallel from the tape library, shipped, and imported into S3. S3 lifecycle policies immediately transition imported objects to Glacier Deep Archive. Running multiple devices simultaneously ensures the 30-day deadline is met. Option B requires a major infrastructure upgrade that can't be completed in 30 days. Option C requires Direct Connect provisioning (weeks to months). Option D is far too slow—a single 80 TB device can't transport 1 PB within 30 days.

---

### Question 13

A company uses Amazon EFS for shared file storage across a fleet of 200 EC2 instances in an Auto Scaling group. The EFS file system is in General Purpose performance mode with bursting throughput. During peak hours, the application experiences I/O wait times exceeding 5 seconds. The file system has 1 TB of data and peaks at 500 MiB/s throughput.

Which combination of changes resolves the performance issue? (Choose TWO.)

A. Switch from Bursting Throughput to Elastic Throughput mode. Elastic Throughput automatically scales to handle peaks up to 10 GiB/s for reads and 3 GiB/s for writes without pre-provisioning, paying only for throughput consumed.

B. Switch from General Purpose to Max I/O performance mode if the workload can tolerate slightly higher latencies in exchange for higher aggregate throughput and IOPS across 200+ instances.

C. Migrate from EFS to FSx for Lustre for sub-millisecond latency and higher throughput.

D. Add more EC2 instances to distribute the I/O load across more clients.

E. Enable EFS Intelligent-Tiering to automatically optimize storage costs.

**Correct Answer: A, B**

**Explanation:** (A) Bursting Throughput is limited by the data stored—1 TB provides only ~50 MiB/s baseline with credits that deplete during sustained peaks. Elastic Throughput removes this constraint, scaling automatically to meet demand (up to 10 GiB/s reads). (B) With 200 concurrent clients, General Purpose mode's per-operation latency and IOPS limits may cause contention. Max I/O mode trades slightly higher latency for significantly higher aggregate throughput and IOPS, which is better for highly parallelized workloads. Option C is a valid solution but requires migration effort and changes the storage protocol. Option D doesn't resolve the EFS-side throughput bottleneck. Option E optimizes cost, not performance.

---

### Question 14

A gaming company operates a global leaderboard service. They need a caching layer with sub-millisecond read latency, support for sorted sets, and the ability to handle 1 million requests per second. Data persistence is required—the cache must survive node failures without data loss. The solution must be available across 3 AWS Regions.

Which storage solution meets these requirements?

A. Amazon ElastiCache for Redis with cluster mode enabled for horizontal scaling across shards. Enable Multi-AZ with automatic failover for high availability. Use Redis sorted sets for leaderboard functionality. Enable Redis Global Datastore for cross-Region replication across all 3 Regions. Configure backup and restore for data persistence, with AOF (Append Only File) enabled for durability.

B. Amazon DynamoDB Global Tables with DAX for caching. Implement leaderboard sorting in the application layer.

C. Amazon MemoryDB for Redis with global replication across 3 Regions. Use sorted sets for leaderboards.

D. S3 with CloudFront caching for leaderboard snapshots refreshed every second.

**Correct Answer: C**

**Explanation:** Amazon MemoryDB for Redis provides Redis-compatible, durable, in-memory storage with sub-millisecond read latency and single-digit millisecond writes. Unlike ElastiCache for Redis, MemoryDB provides durability—data survives node failures with a Multi-AZ transactional log. MemoryDB supports sorted sets for leaderboard operations and can handle millions of requests per second across shards. MemoryDB's Multi-Region support ensures global availability. Option A's ElastiCache for Redis with AOF provides some persistence but is not as durable as MemoryDB's transactional log (ElastiCache can lose recent writes during failover). Option B adds application-level complexity for sorting. Option D can't handle real-time leaderboard updates.

---

### Question 15

A company runs a hybrid environment where on-premises applications write files to NFS shares that must be accessible from both on-premises and AWS. Files written on-premises should appear in S3 within minutes. Files uploaded directly to S3 should be accessible from on-premises through the NFS mount within minutes. Latency for on-premises file access must be under 10 ms for recently accessed files.

Which solution provides bidirectional file synchronization with low latency?

A. Deploy an Amazon S3 File Gateway on-premises. The gateway provides an NFS mount backed by S3. Files written to the NFS mount are automatically uploaded to S3. For files uploaded directly to S3, use the `RefreshCache` API (triggered by S3 event notifications via Lambda) to make them visible through the NFS mount. The gateway's local cache ensures sub-10ms latency for recently accessed files.

B. Use AWS DataSync for bidirectional synchronization between on-premises NFS and S3, scheduled every 5 minutes.

C. Mount EFS on both on-premises servers (via VPN) and EC2 instances. Use EFS as the shared file system.

D. Deploy a Storage Gateway Volume Gateway and expose it as iSCSI LUN on-premises. Snapshot the volume to S3 periodically.

**Correct Answer: A**

**Explanation:** S3 File Gateway provides NFS access to S3 with a local cache for low-latency reads. Files written to the NFS mount are uploaded to S3 asynchronously (typically within minutes). For files uploaded directly to S3, the `RefreshCache` API updates the gateway's metadata so they appear on the NFS mount—triggering this via S3 event notifications and Lambda automates bidirectional visibility. The local cache on the gateway hardware ensures sub-10ms latency for frequently accessed files. Option B provides periodic sync but not continuous access and doesn't provide an NFS mount for real-time use. Option C works but requires reliable, low-latency VPN connectivity and may have higher latency than the gateway's local cache. Option D provides block storage, not file storage.

---

### Question 16

A media company stores 10 PB of video assets in S3 across 5 accounts. They need to implement a unified namespace where editors access videos from any account using a single mount point on their Linux workstations. The solution must support POSIX permissions, handle files up to 5 TB, and provide at least 1 GB/s aggregate throughput.

Which architecture provides a unified namespace over multi-account S3?

A. Deploy Amazon FSx for Lustre with S3 data repositories configured for each of the 5 S3 buckets (one per account). FSx for Lustre provides a POSIX-compliant file system that lazily loads data from S3 on first access and can export changes back to S3. Cross-account S3 access is configured via bucket policies. Editors mount the FSx file system via the Lustre client. A Persistent 2 deployment type with sufficient storage capacity provides the throughput requirement.

B. Create a single S3 bucket with Cross-Region Replication from all 5 accounts. Mount it using S3 File Gateway.

C. Deploy EFS and use DataSync to continuously replicate data from all 5 S3 buckets to EFS.

D. Use AWS Transfer Family with SFTP protocol to provide a unified access point to multiple S3 buckets.

**Correct Answer: A**

**Explanation:** FSx for Lustre's S3 data repository integration creates a POSIX file system namespace that transparently accesses data across multiple S3 buckets. Multiple data repository associations allow linking different S3 prefixes/buckets to different file system paths, creating a unified namespace. Lustre's parallel file system architecture provides the required throughput. Lazy loading means only accessed data is fetched from S3, avoiding upfront replication of the entire 10 PB. Option B creates a single copy (not a namespace over existing data) and S3 Replication doesn't consolidate across accounts into one bucket. Option C replicates 10 PB to EFS, which is extremely expensive. Option D provides transfer access, not a mounted file system namespace.

---

### Question 17

A company stores 500 TB of archive data in S3 Glacier Flexible Retrieval. They frequently need to restore individual files, but users often don't know the exact S3 key of the file they need—they only know partial file names or metadata attributes. Currently, finding the right file requires searching through S3 Inventory reports, which takes hours.

Which solution improves file discovery and retrieval?

A. Generate S3 Inventory reports regularly and ingest them into an Amazon OpenSearch Service cluster. Index object keys, metadata, and storage class information. Users search the OpenSearch dashboard or API to find the exact S3 key, then initiate a Glacier restore for the specific object. Automate the restore-and-notify workflow using Step Functions: the user's search triggers a Lambda that calls `RestoreObject`, polls for completion, generates a pre-signed URL, and notifies the user via SNS/SES.

B. Enable S3 Object Lambda to intercept GET requests and search through Glacier objects on the fly.

C. Migrate all data from Glacier to S3 Standard for instant access and use S3 Select to search within objects.

D. Create an Amazon RDS database with all object metadata. Users query the database to find files, then manually restore from Glacier.

**Correct Answer: A**

**Explanation:** OpenSearch provides full-text search and filtering on metadata indexed from S3 Inventory reports, enabling users to find files by partial names, metadata attributes, or any other indexed field within seconds. The automated Step Functions workflow handles the restore process end-to-end, eliminating manual steps. Option B can't search through Glacier objects—they must be restored first. Option C would cost millions of dollars for 500 TB in Standard storage. Option D works but OpenSearch provides a better search experience with fuzzy matching, relevance scoring, and a built-in dashboard.

---

### Question 18

A financial institution requires that all S3 data be encrypted with customer-managed KMS keys (CMKs). They have 100 accounts, each with its own CMK. When a bucket in Account A needs to share data with Account B, cross-account access fails because Account B can't decrypt objects encrypted with Account A's CMK. The company needs a scalable solution for cross-account encrypted data sharing.

Which approach resolves cross-account encryption access at scale?

A. Create a centralized KMS key in a shared services account with a key policy that grants `kms:Decrypt` and `kms:GenerateDataKey` to specific IAM roles in all 100 accounts. Use S3 bucket keys to reduce KMS API calls. For data sharing, configure S3 bucket policies to allow cross-account access and ensure the centralized KMS key is used for encryption. Accounts transition to the centralized key for shared buckets while maintaining their own CMKs for account-specific data.

B. Create KMS grants in each account's CMK for every other account that needs access. Manage grants using a Lambda function.

C. Re-encrypt objects with the recipient account's CMK before sharing, using S3 Batch Operations.

D. Use S3 server-side encryption with Amazon S3 managed keys (SSE-S3) instead of KMS for shared buckets.

**Correct Answer: A**

**Explanation:** A centralized KMS key in a shared services account with a key policy granting access to all participant accounts is the most scalable approach. S3 bucket keys reduce KMS API calls (and costs) by generating a bucket-level key for encryption operations. This eliminates the N-to-N key access problem. Accounts use the centralized key for shared buckets while keeping their own CMKs for internal data, maintaining the customer-managed key requirement. Option B creates O(N²) grants—unmanageable at 100 accounts. Option C requires re-encrypting data for every share, which is expensive and slow. Option D switches away from customer-managed keys, violating the requirement.

---

### Question 19

A company uses S3 for a data pipeline that processes 100,000 objects per hour. They've implemented S3 Event Notifications to trigger Lambda functions for processing. Recently, they noticed that approximately 0.1% of events are being lost, causing processing gaps. The pipeline requires exactly-once processing guarantees.

Which architecture eliminates event loss and ensures reliable processing?

A. Replace S3 Event Notifications with S3 Event Notifications delivered to Amazon SQS. Configure the SQS queue with a dead-letter queue (DLQ) for failed messages. The Lambda function processes messages from SQS with batch processing. Enable message visibility timeout longer than the Lambda function's timeout. The SQS queue guarantees at-least-once delivery—combine with idempotent processing (using DynamoDB conditional writes to track processed objects) for effective exactly-once semantics.

B. Enable S3 Event Notifications to trigger both a Lambda function and an SQS queue for redundancy.

C. Use EventBridge with S3 event source instead of native S3 Event Notifications. EventBridge provides built-in retry and DLQ capabilities.

D. Configure S3 Inventory reports every hour and compare against processed objects to detect and reprocess missing items.

**Correct Answer: C**

**Explanation:** Amazon EventBridge with S3 as an event source provides more reliable event delivery than native S3 Event Notifications. EventBridge offers built-in retry policies (up to 185 retries over 24 hours), dead-letter queues for failed deliveries, and content-based filtering. When combined with idempotent Lambda processing, this provides effective exactly-once semantics. EventBridge also supports multiple targets from a single event, enabling parallel processing pipelines. Option A improves reliability with SQS but S3 Event Notifications can still drop events before reaching SQS. Option B doesn't solve the root cause—if S3 Event Notifications drop events, neither target receives them. Option D is a batch reconciliation approach that doesn't provide real-time processing.

---

### Question 20

An organization has 300 S3 buckets across 20 accounts. They need to implement consistent data protection that includes: (1) cross-Region replication for disaster recovery, (2) Object Lock for compliance, (3) versioning enabled on all buckets, (4) default encryption with KMS, and (5) public access blocked. Changes to these settings must be prevented by individual account administrators.

Which approach provides the MOST comprehensive protection?

A. Deploy AWS CloudFormation StackSets from the management account to configure all S3 buckets with the required settings. Create SCPs that deny: `s3:PutBucketVersioning` (to prevent disabling versioning), `s3:PutBucketPublicAccessBlock` with condition of `false` values, `s3:DeleteBucketEncryption`, and `s3:PutBucketReplication` (to prevent modifying replication rules). Use AWS Config organizational rules to continuously monitor compliance and auto-remediate drift.

B. Create S3 Bucket Policies in each bucket that deny modifications to these settings.

C. Use AWS Control Tower guardrails for S3 compliance and block modifications through detective guardrails.

D. Create a Lambda function that runs every hour to check and fix S3 bucket configurations across all accounts.

**Correct Answer: A**

**Explanation:** This solution combines deployment (StackSets for initial configuration), prevention (SCPs to block changes), and detection/remediation (Config rules for drift). SCPs prevent account-level administrators from modifying critical settings because SCPs override IAM permissions. Config organizational rules provide continuous compliance monitoring and auto-remediation for any settings that drift. Option B uses bucket policies, which account administrators can modify. Option C provides guardrails but Control Tower's S3 guardrails may not cover all five specific requirements. Option D is reactive with a 1-hour detection gap.

---

### Question 21

A biotechnology company needs a file system for processing large genomic datasets (average file size: 50 GB, total dataset: 200 TB). The workload has two phases: (1) Initial analysis requires sequential reads at 5 GB/s for 6 hours per day, (2) Results review requires random reads at high IOPS for 4 hours per day. The file system is idle for 14 hours daily. Cost optimization is critical.

Which storage architecture minimizes costs while meeting performance requirements?

A. Use Amazon FSx for Lustre with a Scratch 2 deployment type linked to an S3 data repository. The scratch file system provides high throughput at lower cost than persistent. Data is lazily loaded from S3 during analysis and results are written back to S3. Since the workload runs only 10 hours daily, deploy the file system on demand—create it before the analysis window and delete it after, paying only for active hours. Use an EventBridge schedule with Lambda to automate creation and deletion.

B. Use Amazon EFS with Provisioned Throughput set to 5 GB/s. Enable Infrequent Access tiering for idle hours.

C. Use FSx for Lustre Persistent 2 on SSD storage with the file system running 24/7.

D. Use a fleet of EC2 instances with local NVMe instance storage in a distributed file system configuration.

**Correct Answer: A**

**Explanation:** FSx for Lustre Scratch file systems are the lowest-cost option for temporary high-performance workloads. Scratch 2 provides up to 200 MB/s per TiB of throughput. With S3 data repository integration, data persists in S3 when the file system is deleted and is reloaded on the next creation. Automating creation/deletion means paying only for the 10 active hours rather than 24/7. Option B's EFS at 5 GB/s provisioned throughput is expensive and doesn't provide the IOPS for the random read phase. Option C runs 24/7, wasting 14 hours of compute costs daily. Option D requires managing infrastructure and doesn't automatically integrate with S3 for data persistence.

---

### Question 22

A company needs to implement a disaster recovery strategy for a 50 TB file system hosted on FSx for Windows File Server. The current setup is single-AZ. Recovery objectives: RPO of 15 minutes, RTO of 30 minutes. The DR target is in a different Region.

Which DR architecture meets both RPO and RTO requirements?

A. Upgrade the existing FSx for Windows File Server to a Multi-AZ deployment for local high availability. Configure automated daily backups. For cross-Region DR, use AWS Backup with cross-Region copy rules to replicate FSx backups to the DR Region automatically. In a disaster, create a new FSx file system in the DR Region from the latest backup. To meet the 15-minute RPO, supplement backups with DFS Replication between the primary FSx file system and a secondary FSx file system in the DR Region for near-real-time replication.

B. Use FSx for Windows File Server's built-in Multi-AZ replication for cross-Region DR.

C. Configure AWS DataSync to replicate the FSx file system to S3 in the DR Region every 15 minutes. In a disaster, create a new FSx file system and restore from S3.

D. Take manual EBS snapshots of the FSx file system and copy them cross-Region.

**Correct Answer: A**

**Explanation:** DFS Replication (a Windows Server feature) between FSx file systems in different Regions provides near-real-time file replication, meeting the 15-minute RPO. The secondary FSx file system in the DR Region is already running, so RTO is essentially the time to redirect clients (well under 30 minutes). Multi-AZ provides local HA. AWS Backup cross-Region copies provide an additional recovery layer. Option B is incorrect—FSx Multi-AZ replication is within a Region only, not cross-Region. Option C introduces a 15-minute sync interval with additional restore time, making RTO longer. Option D doesn't apply—FSx doesn't use directly accessible EBS volumes.

---

### Question 23

A video streaming company needs to store and serve 500 TB of video content. Access patterns: (1) new content (< 30 days) receives 80% of requests, (2) older content (30-365 days) receives 15% of requests, (3) archive content (> 365 days) receives 5% of requests but must be playable within 5 seconds. All content is immutable after upload.

Which S3 storage architecture optimizes cost while meeting access requirements?

A. Use S3 Intelligent-Tiering with all access tiers configured: Frequent Access, Infrequent Access (30 days), Archive Instant Access (90 days). Enable the Deep Archive Access tier at 180 days. Disable the Deep Archive tier since archive content must be accessible within 5 seconds (Deep Archive requires 12 hours). CloudFront serves content with the S3 origin, and Intelligent-Tiering automatically optimizes storage class based on access patterns per object.

B. Use S3 Lifecycle policies with fixed transitions: Standard for 30 days, Standard-IA for 30-365 days, Glacier Instant Retrieval after 365 days.

C. Keep all content in S3 Standard and use CloudFront caching to reduce S3 retrieval costs.

D. Use S3 One Zone-IA for all content with CloudFront as the CDN.

**Correct Answer: B**

**Explanation:** Fixed lifecycle transitions are more predictable and cost-effective for this well-understood access pattern. Standard for the first 30 days handles the 80% of requests on new content. Standard-IA for 30-365 days costs less while providing millisecond access for the 15% of requests. Glacier Instant Retrieval after 365 days provides the lowest cost for rarely accessed content while still delivering millisecond first-byte latency (well within the 5-second requirement). Option A's Intelligent-Tiering has a per-object monitoring fee that's expensive at 500 TB with millions of objects, and the access patterns are predictable enough that fixed lifecycle rules are more cost-effective. Option C keeps everything in Standard—the most expensive tier. Option D uses single-AZ storage, risking data loss.

---

### Question 24

A company needs to implement S3 versioning with Object Lock across 100 buckets while minimizing storage costs from accumulating versions. Compliance requires keeping the current version and one prior version for 90 days, with the current version retained for 7 years. Older versions beyond the second-most-recent must be deleted.

Which lifecycle configuration achieves this retention policy?

A. Enable versioning and Object Lock on all buckets. Set the default Object Lock retention to 7 years for new objects (current versions). Create a lifecycle rule that transitions noncurrent versions to S3 Glacier Instant Retrieval after 1 day and permanently deletes noncurrent versions after 90 days with `NoncurrentVersionExpiration` set to 90 days and `NewerNoncurrentVersions` set to 1 (keep only 1 noncurrent version). Note: Object Lock prevents deletion of objects under retention, so the lifecycle rule only deletes noncurrent versions that aren't lock-protected.

B. Create a Lambda function that runs daily to delete all but the most recent two versions of every object.

C. Use S3 Lifecycle to transition all noncurrent versions to Deep Archive immediately and delete after 90 days.

D. Disable versioning after uploading each file to prevent version accumulation, then re-enable it.

**Correct Answer: A**

**Explanation:** S3 Lifecycle rules support `NewerNoncurrentVersions` to limit the number of retained noncurrent versions. Setting it to 1 keeps only the most recent noncurrent version, automatically deleting older versions after the specified days. Combined with Object Lock's 7-year retention on current versions, this balances compliance with cost optimization. Transitioning noncurrent versions to Glacier Instant Retrieval reduces storage costs while maintaining the 90-day retention. Option B is a custom solution with high API call costs for 100 buckets. Option C doesn't limit the number of noncurrent versions. Option D breaks versioning's purpose and creates gaps in version history.

---

### Question 25

A company processes satellite imagery. Each image is 2 GB, and they receive 10,000 images per day. Processing requires reading each image once sequentially, running analysis, and writing results. Images are never modified after processing and must be retained for 5 years. Processing must start within 1 minute of image arrival.

Which storage architecture optimizes for both processing performance and long-term retention cost?

A. Upload images to S3 Standard using multipart upload with Transfer Acceleration. Configure S3 Event Notifications (via EventBridge) to trigger a Lambda function that initiates processing on an ECS Fargate task. The task reads the image directly from S3 using range-based GETs for parallel download. After processing, create a lifecycle rule that transitions images to S3 Glacier Instant Retrieval after 1 day and to S3 Glacier Deep Archive after 30 days for the 5-year retention period.

B. Upload images to EFS. Process from EFS mount. Keep all images on EFS for 5 years.

C. Upload images to FSx for Lustre linked to S3. Process from Lustre. Images auto-export to S3 after processing.

D. Upload images directly to Glacier Deep Archive and restore them on-demand for processing.

**Correct Answer: A**

**Explanation:** S3 Standard provides immediate availability for processing triggered by event notifications. Transfer Acceleration speeds up uploads from potentially remote satellite ground stations. The sequential read pattern works well with S3's HTTP-based access, and range GETs enable parallel download of the 2 GB file. The aggressive lifecycle policy (IA after 1 day, Deep Archive after 30 days) dramatically reduces storage costs for the 5-year retention of 20 TB/day of new data. Option B keeps images on EFS for 5 years—extremely expensive for 36+ PB. Option C adds FSx complexity for a simple sequential-read workload. Option D makes images unavailable for immediate processing (12-hour retrieval).

---

### Question 26

A company migrating to AWS needs to support both NFS (Linux) and SMB (Windows) access to the same dataset from on-premises. The dataset is 100 TB and must be accessible from both protocols simultaneously. They also need snapshots for point-in-time recovery and storage efficiency features like deduplication and compression.

Which AWS storage service supports multi-protocol access with these features?

A. Amazon FSx for NetApp ONTAP. It natively supports both NFS and SMB access to the same data simultaneously (multi-protocol access). ONTAP provides built-in snapshots, deduplication, and compression. Deploy it in a VPC connected to on-premises via Direct Connect or VPN. Mount NFS exports on Linux clients and SMB shares on Windows clients—both accessing the same underlying volumes.

B. Deploy two storage solutions: FSx for Lustre for NFS and FSx for Windows for SMB. Use DataSync to synchronize data between them.

C. Deploy S3 File Gateway with both NFS and SMB file shares pointing to the same S3 bucket.

D. Deploy Amazon EFS and use an NFS-to-SMB protocol translator on an EC2 instance.

**Correct Answer: A**

**Explanation:** FSx for NetApp ONTAP is the only AWS-managed file system that provides true multi-protocol (NFS + SMB) access to the same data. ONTAP's NTFS-to-UNIX permission mapping ensures consistent access control across protocols. Built-in deduplication and compression reduce storage costs (often 30-65% savings). Snapshots are space-efficient (copy-on-write) and provide instant point-in-time recovery. Option B requires two separate file systems with synchronization complexity and potential data inconsistency. Option C provides multi-protocol S3 access but with gateway latency and limited POSIX compliance. Option D adds an unreliable protocol translation layer.

---

### Question 27

A life sciences company runs machine learning training jobs that read 200 TB training datasets from S3. Each training run reads the entire dataset multiple times (10 epochs). The current bottleneck is S3 read throughput—the training cluster of 64 p4d.24xlarge instances can consume data faster than S3 serves it. Each epoch takes 4 hours when it should take 1 hour.

Which storage optimization provides the MOST throughput improvement?

A. Create an Amazon FSx for Lustre file system linked to the S3 training data bucket. Configure a Persistent 2 deployment with SSD storage sized for 200 TB with sufficient aggregate throughput (e.g., 1000 MB/s per TiB = 200 GB/s aggregate). The first epoch lazily loads data from S3 to Lustre. Subsequent epochs (2-10) read from Lustre's local SSD storage at full throughput, eliminating S3 bottleneck. Mount Lustre on all 64 training instances.

B. Use S3 Transfer Acceleration to speed up reads from the training cluster.

C. Pre-download the entire dataset to local NVMe instance storage on each training instance before starting training.

D. Use S3 Select to read only relevant portions of training data, reducing the volume of data transferred.

**Correct Answer: A**

**Explanation:** FSx for Lustre with S3 data repository integration caches the entire dataset locally after the first epoch. Subsequent epochs read from Lustre's high-performance SSD storage at aggregate throughputs exceeding 200 GB/s across the cluster. Lustre's parallel file system architecture distributes I/O across all storage servers, eliminating the S3 throughput bottleneck. Option B is for uploads, not downloads—Transfer Acceleration doesn't help with reads. Option C requires 200 TB of local storage per instance (not available on p4d instances) and takes significant time to download. Option D reduces data volume but doesn't apply to ML training that needs complete datasets.

---

### Question 28

A company needs to implement immutable backup storage for ransomware protection. All backup data written to S3 must be: (1) immutable for 30 days minimum, (2) impossible for any user (including root) to delete during retention, (3) automatically transitioned to cheaper storage after 30 days, and (4) completely deleted after 1 year to comply with data minimization regulations.

Which S3 configuration provides ransomware-proof backup with automatic lifecycle management?

A. Create an S3 bucket with Object Lock enabled in Compliance mode with a 30-day default retention period. Configure a lifecycle policy that transitions objects to S3 Glacier Instant Retrieval after 30 days and expires (deletes) objects after 365 days. Object Lock Compliance mode prevents any deletion during the 30-day retention—not even the AWS account root user can override it. After retention expires, lifecycle rules handle transitions and deletion automatically.

B. Use S3 Object Lock Governance mode with a 30-day retention. Configure lifecycle rules for transition and expiration.

C. Enable MFA Delete on the bucket and versioning. Configure lifecycle rules for transitions and expiration.

D. Create a bucket policy that denies all delete operations. Use lifecycle rules for automatic management.

**Correct Answer: A**

**Explanation:** Object Lock Compliance mode provides the strongest protection—no one can delete or modify objects during the retention period, not even the root user or AWS Support. This ensures ransomware attackers who gain account access cannot delete backups. The 30-day default retention applies automatically to all new objects. After retention expires, lifecycle rules manage transitions (cheaper storage) and expiration (1-year deletion) automatically. Option B uses Governance mode, which allows users with `s3:BypassGovernanceRetention` permission to override the lock—not truly ransomware-proof. Option C's MFA Delete only requires MFA; it doesn't prevent deletion by someone with MFA access. Option D's bucket policy can be removed by account administrators.

---

### Question 29

A company hosts a WordPress multisite installation on EC2 with 50 WordPress sites. Media files are stored on an EBS volume attached to the EC2 instance. They're migrating to an Auto Scaling group with multiple instances and need shared media storage.

Which storage migration provides shared access with the LEAST application changes?

A. Migrate the media directory from EBS to Amazon EFS. Mount EFS on all EC2 instances in the Auto Scaling group at the same mount point as the previous EBS volume. WordPress requires no code changes since it accesses the file system through standard POSIX operations. Configure EFS with General Purpose performance mode and Elastic Throughput for variable workloads. Enable EFS Intelligent-Tiering to automatically move infrequently accessed media to IA storage.

B. Migrate media files to S3 and install a WordPress plugin that redirects media URLs to S3.

C. Use EBS Multi-Attach to share the volume across multiple instances.

D. Implement a GlusterFS distributed file system across the EC2 instances.

**Correct Answer: A**

**Explanation:** EFS provides a POSIX-compliant shared file system that can be mounted on unlimited EC2 instances simultaneously. Since WordPress uses standard file system operations for media, mounting EFS at the same path as the previous EBS mount point requires zero application changes. Intelligent-Tiering reduces costs by moving rarely accessed media files to IA storage automatically. Option B requires installing and configuring plugins for each of the 50 WordPress sites. Option C is limited to io2 volumes, supports only 16 instances, and requires a cluster-aware file system. Option D requires managing a distributed file system with significant operational overhead.

---

### Question 30

A company stores sensitive documents in S3. They need to implement a system where documents are automatically classified (PII, PHI, financial) on upload, tagged with the classification level, and placed in the appropriate S3 Object Lock retention based on classification (PII: 7 years, PHI: 10 years, financial: 5 years).

Which architecture automates classification-based retention?

A. Configure S3 Event Notifications (EventBridge) to trigger a Step Functions workflow when a new object is uploaded. The workflow: (1) invokes Amazon Macie to scan the object for sensitive data classification, (2) based on Macie's findings, a Lambda function applies the appropriate S3 object tags (classification type), (3) the Lambda function calls `PutObjectRetention` to set the Object Lock retention period based on classification (7, 10, or 5 years in Compliance mode). S3 Object Lock must be enabled on the bucket with no default retention (retention is set per-object by the workflow).

B. Use S3 Inventory to periodically scan all objects and classify them using Comprehend.

C. Train a SageMaker model to classify documents. Deploy it as an endpoint called by a Lambda trigger.

D. Use Amazon Textract to extract text from documents and Lambda to apply regex patterns for classification.

**Correct Answer: A**

**Explanation:** Amazon Macie is purpose-built for sensitive data discovery and classification in S3. It automatically identifies PII, PHI, and financial data using ML and pattern matching. The Step Functions workflow orchestrates the classification-to-retention pipeline: Macie classifies, Lambda maps classification to retention period, and `PutObjectRetention` applies the appropriate Object Lock retention. Per-object retention (no default) ensures each document gets the correct retention based on its actual content. Option B is batch-based with delays between upload and classification. Option C requires building and maintaining a custom ML model for a well-solved problem. Option D misses context-dependent sensitive data that regex can't detect.

---

### Question 31

A company needs to implement a multi-Region active-active storage solution where applications in US-East and EU-West read and write data. Writes in one Region must be visible in the other within 15 minutes. Each Region stores approximately 500 TB. Data sovereignty requirements mean EU data must stay in EU, and US data must stay in US, but metadata must be accessible globally.

Which architecture meets these requirements?

A. Use separate S3 buckets in each Region for regional data (enforcing data sovereignty). Create S3 Replication rules with prefix filters—only metadata objects (stored as small JSON files in a specific prefix) are replicated bidirectionally between Regions. For metadata that needs global access, use DynamoDB Global Tables to store metadata records that reference the regional S3 object locations. Applications query DynamoDB for metadata and access S3 objects from the local Region only.

B. Enable S3 Cross-Region Replication bidirectionally between the two Regions for all data.

C. Use a single S3 bucket in one Region with Multi-Region Access Points.

D. Deploy S3 on Outposts in each Region to maintain data locality.

**Correct Answer: A**

**Explanation:** This architecture addresses data sovereignty by keeping regional data in its respective Region's S3 bucket—no cross-border data replication. DynamoDB Global Tables provide the global metadata layer with sub-second replication, enabling applications in either Region to discover data locations. S3 replication is limited to metadata objects only (small JSON files referencing the actual data). Applications read S3 objects from their local Region, with the DynamoDB metadata telling them whether the data exists locally or remotely. Option B replicates all data cross-border, violating sovereignty requirements. Option C stores all data in one Region. Option D is unnecessary when standard S3 regional buckets provide data locality.

---

### Question 32

A company runs a batch processing pipeline that creates 1 million temporary files per hour, each 1 MB. Files are processed once and deleted within 2 hours. The pipeline runs on 50 EC2 instances sharing a file system. High I/O throughput and low latency are critical during the 2-hour processing window.

Which storage solution is MOST cost-effective for this ephemeral workload?

A. Amazon FSx for Lustre with a Scratch 2 deployment type. Scratch file systems are designed for temporary workloads—they provide the highest throughput at the lowest cost since data is not replicated. The 1 TB/hour data rate and millions of files per hour align with Lustre's metadata performance. Since files are temporary (deleted within 2 hours), the lack of data durability in scratch deployments is acceptable.

B. Amazon EFS with Bursting Throughput mode.

C. S3 with direct object access from each EC2 instance.

D. EC2 instance store volumes pooled across all 50 instances.

**Correct Answer: A**

**Explanation:** FSx for Lustre Scratch 2 is the most cost-effective high-performance file system for temporary data. It provides up to 200 MB/s per TiB of throughput without the overhead of data replication (which persistent deployments have). The Lustre metadata subsystem handles millions of file creations and deletions efficiently. Since files are ephemeral, the lack of durability in scratch mode is a feature, not a bug—you're not paying for unnecessary data protection. Option B has lower throughput and higher per-GB cost. Option C adds latency for the create/read/delete pattern and S3's eventual consistency for listing may cause issues. Option D doesn't provide a shared file system across instances.

---

### Question 33

A company uses EFS for a containerized application on ECS Fargate. The application reads configuration files and writes log files. Configuration files are read frequently but rarely change. Log files are written continuously and read only during troubleshooting. The EFS bill has increased 3x in the last quarter due to growing log volumes.

Which optimization reduces EFS costs MOST significantly without affecting application performance?

A. Enable EFS Intelligent-Tiering (Lifecycle Management) to automatically move infrequently accessed files to the EFS Infrequent Access (IA) storage class. Set the lifecycle policy to transition files to IA after 7 days. Log files older than 7 days (the vast majority) move to IA at ~$0.016/GB-month vs Standard at ~$0.30/GB-month—a 94% reduction for those files. Additionally, implement a Lambda function that periodically moves old log files to S3 (via DataSync or direct copy) and deletes them from EFS to prevent unbounded growth.

B. Switch from EFS to FSx for Windows File Server, which offers built-in data compression.

C. Replace EFS with S3 for log storage. Modify the application to write logs to S3 using the AWS SDK.

D. Switch to EFS One Zone storage class for 47% cost reduction.

**Correct Answer: A**

**Explanation:** EFS Intelligent-Tiering is the lowest-effort optimization—it requires no application changes and automatically moves cold data (old log files) to IA storage at a 94% cost reduction. The 7-day transition period means recent logs used for troubleshooting remain in Standard for fast access. The supplementary log rotation to S3 prevents unbounded EFS growth. Option B requires migration to a Windows-based file system (SMB), which doesn't work with Fargate Linux containers. Option C requires application code changes for log writing. Option D reduces cost by 47% but IA tiering on top of One Zone would give even more savings, and One Zone risks data loss.

---

### Question 34

A company needs to provide a local file cache for a remote office connected to the main AWS environment via a 100 Mbps WAN link. Remote office users access a 50 TB dataset in S3 daily. They need local file access performance (< 10 ms latency) for frequently accessed files while ensuring all data remains available from S3.

Which solution provides the BEST remote office file access experience?

A. Deploy an AWS Storage Gateway File Gateway appliance on-premises at the remote office. Configure it with an NFS/SMB file share backed by the S3 bucket. The File Gateway maintains a local cache on its attached storage (provision at least 5 TB of local cache SSD) for frequently accessed files, providing sub-10ms latency. Less-frequently accessed files are transparently fetched from S3 through the WAN link. The 100 Mbps link handles cache misses and background uploads.

B. Set up AWS DataSync to replicate the entire 50 TB dataset to a local NAS at the remote office nightly.

C. Deploy an EFS file system and mount it at the remote office via VPN. Use EFS caching to improve performance.

D. Install CloudFront and serve S3 content through a regional edge cache.

**Correct Answer: A**

**Explanation:** Storage Gateway File Gateway provides a transparent, cached window into S3. The local cache serves hot data with local disk latency (< 10ms). Cache misses are served from S3 via the WAN link. The gateway automatically manages cache eviction based on access patterns. With 5 TB of cache for a 50 TB dataset, the most frequently accessed files (which are typically a small percentage of the total) are served locally. Option B requires 50 TB of local storage and nightly transfers that would saturate the 100 Mbps link for over 46 days. Option C doesn't cache—EFS access from a remote office over VPN would have WAN latency. Option D is for web content delivery, not file system access.

---

### Question 35

A company is building a serverless data processing pipeline that receives files in various formats (CSV, JSON, Parquet, Avro) in S3. They need to transform all files to Parquet format and store them in a processed bucket. Files range from 1 MB to 50 GB. The pipeline must handle 10,000 files per day.

Which architecture handles the variety of file sizes efficiently?

A. Use S3 Event Notifications to trigger a Lambda function for files under 500 MB and an AWS Step Functions workflow for larger files. The Lambda function reads small files using the S3 SDK, transforms to Parquet using a Python library (pyarrow), and writes to the processed bucket. For files over 500 MB, Step Functions orchestrates an AWS Glue ETL job that processes the file using Apache Spark. Glue handles large file transformation with distributed compute. Use S3 Multipart Upload for writing large Parquet files.

B. Use Lambda for all files regardless of size. Increase Lambda memory to 10 GB and timeout to 15 minutes.

C. Use AWS Glue for all files. Run a Glue job per file.

D. Use Amazon EMR with a persistent Spark cluster to process all files.

**Correct Answer: A**

**Explanation:** The bifurcated approach optimizes cost and performance: Lambda handles small files cheaply (millisecond spin-up, pay-per-invocation), while Glue handles large files that exceed Lambda's 10 GB memory and 15-minute timeout limits. Step Functions orchestrates the large-file workflow, including retry logic and error handling. S3 Multipart Upload efficiently writes large Parquet files. Option B can't handle 50 GB files—Lambda's /tmp is limited to 10 GB and memory to 10 GB. Option C wastes Glue resources on small files (minimum 2 DPU = 10 minutes minimum billing). Option D requires a persistent cluster that's expensive during idle periods.

---

### Question 36

A media company needs to implement a content review workflow where uploaded videos in S3 are automatically transcoded, thumbnailed, and made available for review. Reviewers need to access the original and transcoded versions simultaneously. Approved content must be immutable, while rejected content must be deleted immediately.

Which architecture supports this workflow?

A. Upload original videos to an S3 "inbox" bucket. S3 Event Notifications trigger a Step Functions workflow that: (1) starts a MediaConvert job for transcoding, (2) uses a Lambda function with FFmpeg layer to generate thumbnails, (3) stores transcoded versions and thumbnails in a "review" bucket. A web-based review portal (hosted on CloudFront + S3 static site) displays content with pre-signed URLs. On approval, a Lambda function copies the original and transcoded files to an "archive" bucket with Object Lock Compliance mode and deletes from review. On rejection, files are deleted from both inbox and review buckets.

B. Use a single S3 bucket with different prefixes for each workflow stage. Enable versioning and use tags to track review status.

C. Store all content in EFS mounted on the review application's EC2 instances. Move approved content to Glacier manually.

D. Use S3 Glacier for original uploads and restore them for transcoding and review.

**Correct Answer: A**

**Explanation:** The three-bucket architecture provides clear separation of concerns: inbox (incoming), review (processing), and archive (approved/immutable). S3 Event Notifications and Step Functions automate the workflow end-to-end. Object Lock Compliance mode on the archive bucket ensures approved content is immutable. Immediate deletion of rejected content from inbox and review buckets meets the cleanup requirement. Pre-signed URLs provide secure, time-limited access for reviewers without direct S3 access. Option B mixes workflow stages in one bucket, making lifecycle management complex. Option C adds EFS overhead and manual processes. Option D adds retrieval delays for every upload.

---

### Question 37

A company needs to share 100 TB of data with an external research partner. The partner has their own AWS account. Requirements: (1) the partner can read the data but not copy it to their own buckets, (2) all access is logged with the partner's identity, (3) the company retains ownership of all data, (4) access is automatically revoked after 6 months.

Which approach provides secure, time-limited data sharing?

A. Create an S3 Access Point for the partner with a restrictive access point policy that allows `s3:GetObject` but denies `s3:PutObject` and denies `s3:GetObject` to any destination outside the access point (by restricting the requester's VPC endpoint if applicable). Set an access point policy condition with `aws:CurrentTime` to enforce the 6-month expiration. Enable S3 server access logging that identifies the partner's IAM role ARN for audit. Use bucket ownership settings to ensure the company retains ownership.

B. Create a cross-account IAM role that the partner assumes. The role has S3 read-only permissions. Set the role's maximum session duration to 6 months.

C. Use S3 Cross-Account Replication to copy data to the partner's bucket. Delete the copy after 6 months.

D. Generate pre-signed URLs for all 100 TB of objects and share them with the partner.

**Correct Answer: A**

**Explanation:** S3 Access Points provide dedicated access policies for the partner without modifying the bucket policy. The access point policy restricts operations to read-only and includes a time-based condition (`aws:CurrentTime`) that automatically denies access after 6 months. Server access logging captures the partner's identity for every request. Since objects remain in the company's bucket, ownership is retained. Option B's IAM role session can't last 6 months (max 12 hours)—the partner would need repeated assumption, and preventing data copying isn't enforced. Option C violates the "no copy" requirement. Option D is impractical for 100 TB of objects and URLs can be shared.

---

### Question 38

A company has an on-premises deployment of NetApp ONTAP. They want to extend their storage to AWS while maintaining compatibility with their existing ONTAP management tools, SnapMirror replication, and FlexClone capabilities. Applications use both NFS and iSCSI protocols.

Which AWS storage service provides the MOST compatible hybrid storage extension?

A. Amazon FSx for NetApp ONTAP. It provides a fully managed ONTAP file system with native support for SnapMirror (enabling hybrid replication between on-premises ONTAP and AWS), FlexClone (instant space-efficient clones), NFS, SMB, and iSCSI. Existing ONTAP management tools (System Manager, CLI, REST API) work with FSx for ONTAP. Configure SnapMirror relationships between on-premises ONTAP volumes and FSx for ONTAP volumes for seamless hybrid operation.

B. Amazon FSx for Windows File Server with additional iSCSI support via a Windows Server instance.

C. Amazon EFS for NFS workloads and EBS for iSCSI workloads, managed separately.

D. S3 with Storage Gateway Volume Gateway for iSCSI access and File Gateway for NFS access.

**Correct Answer: A**

**Explanation:** FSx for NetApp ONTAP is the same ONTAP software that runs on-premises, providing full compatibility with existing management tools, SnapMirror for hybrid replication, and FlexClone for instant cloning. It supports NFS, SMB, and iSCSI natively. SnapMirror between on-premises and AWS enables seamless data mobility. This is the only AWS service that provides this level of ONTAP compatibility. Option B doesn't support ONTAP features. Option C requires managing two separate storage systems without ONTAP integration. Option D introduces gateway latency and doesn't support ONTAP features.

---

### Question 39

A company needs an S3 storage solution that minimizes costs for a 100 TB dataset with completely unpredictable access patterns. Some weeks see heavy access to all data; other weeks, less than 1% of data is accessed. They cannot predict which objects will be accessed.

Which storage approach provides the LOWEST cost with unpredictable access patterns?

A. S3 Intelligent-Tiering. It automatically moves objects between Frequent Access (S3 Standard pricing), Infrequent Access (S3 Standard-IA pricing), and optionally Archive Instant Access tiers based on per-object access patterns. There's no retrieval fee when Intelligent-Tiering moves objects between tiers—you pay only the monitoring fee ($0.0025 per 1,000 objects/month). For unpredictable access patterns, this eliminates the risk of choosing the wrong storage class.

B. S3 Standard for all data. Accept the higher storage cost to avoid retrieval fees during high-access weeks.

C. S3 Standard-IA for all data. Accept the retrieval fees during high-access weeks.

D. Manually move data between Standard and IA based on weekly access predictions.

**Correct Answer: A**

**Explanation:** S3 Intelligent-Tiering is purpose-built for unpredictable access patterns. It monitors per-object access and automatically moves each object to the most cost-effective tier. During high-access weeks, frequently accessed objects are in the Frequent Access tier (Standard pricing). During low-access weeks, untouched objects automatically move to IA tiers. The monitoring fee is negligible compared to the savings from automatic tiering. Option B overpays during low-access weeks. Option C incurs high retrieval fees during high-access weeks. Option D requires prediction capability that doesn't exist.

---

### Question 40

A company needs to implement S3 Batch Operations to retag 50 million objects across 100 buckets in 10 accounts. The retagging must apply new compliance tags based on the object's prefix, and the operation must complete within 24 hours.

Which approach executes this cross-account batch operation efficiently?

A. Generate S3 Inventory reports for all 100 buckets. Consolidate inventory manifests into the operations account. Create a CSV manifest that maps each object to its new tag set (based on prefix analysis). Submit S3 Batch Operations jobs from the operations account, using IAM roles in each target account that the batch job assumes. Configure the batch job with the `PutObjectTagging` operation. Enable completion reports for audit. Parallelize by submitting one batch job per account to process all accounts simultaneously.

B. Write a Python script using boto3 that iterates through all objects in all buckets and calls `put_object_tagging` for each object.

C. Use Lambda functions triggered by S3 Inventory report generation to retag objects in each account independently.

D. Create a single S3 Batch Operations job in the management account that processes all 50 million objects across all accounts.

**Correct Answer: A**

**Explanation:** S3 Batch Operations can process millions of objects efficiently using manifests (from S3 Inventory or CSV). Running one batch job per account parallelizes the work across all 10 accounts, completing within the 24-hour window. Cross-account IAM roles allow the operations account to operate on objects in target accounts. Completion reports provide audit evidence of all tagging operations. Option B is sequential and would take days for 50 million objects due to API rate limits. Option C adds complexity with Lambda and doesn't leverage S3 Batch Operations' optimized processing. Option D isn't possible—S3 Batch Operations processes objects within a single account per job.

---

### Question 41

A company needs to transfer 1 PB of data from an on-premises Hadoop HDFS cluster to S3 for a data lake migration. The data is organized in a specific directory structure that must be preserved as S3 prefixes. They have a 10 Gbps Direct Connect. The transfer must complete within 30 days while the HDFS cluster remains operational for existing workloads.

Which approach provides the MOST efficient transfer?

A. Deploy AWS DataSync agents on the HDFS cluster nodes. Configure DataSync tasks with HDFS as the source location and S3 as the destination. DataSync natively supports HDFS as a source location, preserving the directory structure as S3 prefixes. Configure bandwidth throttling to limit DataSync to 50% of the Direct Connect bandwidth during business hours and 100% during off-hours. DataSync's incremental transfer capability handles any files modified during the transfer window.

B. Use `hadoop distcp` to copy data from HDFS to S3 using the S3A connector.

C. Export HDFS data to a local NFS mount, then use DataSync to transfer from NFS to S3.

D. Use AWS Snowball Edge devices to physically ship the data.

**Correct Answer: A**

**Explanation:** DataSync natively supports HDFS as a source location, eliminating the need for intermediate storage or custom tooling. It preserves the directory hierarchy as S3 prefixes. Bandwidth throttling ensures the transfer doesn't impact production HDFS workloads. At 10 Gbps with 50% utilization during business hours and 100% off-hours, 1 PB completes within approximately 15 days. Incremental transfer handles changes during the migration window. Option B uses distcp, which competes with production MapReduce jobs for cluster resources and is harder to throttle. Option C adds an unnecessary intermediate step. Option D is unnecessary with 10 Gbps Direct Connect (which can transfer 1 PB in ~10 days at full speed).

---

### Question 42

A financial company needs a storage solution for a real-time trading application. Requirements: (1) sub-millisecond read latency, (2) 64 KB block size I/O, (3) consistent 500,000 IOPS, (4) multi-attach capability for 4 instances in a single AZ for high availability, and (5) snapshots for daily backup.

Which EBS configuration meets ALL requirements?

A. Amazon EBS io2 Block Express volumes with Multi-Attach enabled. Provision a volume with 500,000 IOPS (io2 Block Express supports up to 256,000 IOPS per volume, so provision two volumes with 250,000 IOPS each, striped using RAID 0). Attach each volume to 4 Nitro-based instances in the same AZ. Create daily snapshots using Amazon Data Lifecycle Manager. Note: with io2 Block Express maximum of 256,000 IOPS per volume, two RAID-0 volumes achieve 500,000 IOPS aggregate.

B. Amazon EBS gp3 volumes with 500,000 IOPS provisioned.

C. Instance store NVMe volumes in a RAID 0 configuration across 4 instances.

D. Amazon FSx for Lustre with SSD storage deployed in a single AZ.

**Correct Answer: A**

**Explanation:** EBS io2 Block Express provides the highest IOPS per volume (up to 256,000) with sub-millisecond latency. Multi-Attach enables the same io2 volume to be attached to up to 16 Nitro instances in the same AZ. Two RAID-0 volumes with 250K IOPS each achieve the 500K IOPS target. Daily snapshots via DLM provide backup. Option B's gp3 maxes out at 16,000 IOPS—far short of 500,000. Option C provides high IOPS but instance store doesn't support snapshots or Multi-Attach in the traditional sense. Option D is a file system, not block storage, and adds latency for 64 KB block I/O.

---

### Question 43

A company has 200 TB in S3 Standard across 50 buckets. AWS Cost Explorer shows that 70% of the data hasn't been accessed in 90 days but is kept in Standard because users occasionally need immediate access to archived data. Monthly S3 storage costs are $4,600.

Which optimization reduces costs while maintaining access availability?

A. Enable S3 Intelligent-Tiering on all 50 buckets using S3 Lifecycle rules that transition existing objects to Intelligent-Tiering. Configure the Archive Instant Access tier to activate after 90 days of no access. Enable the Frequent Access and Infrequent Access tiers as defaults. Intelligent-Tiering automatically moves the 70% of cold data to IA ($0.0125/GB) and Archive Instant Access ($0.004/GB) tiers while keeping hot data in Frequent Access. When users access archived data, it's instantly available with millisecond latency—no restore required.

B. Move all data to S3 Standard-IA and accept the retrieval charges.

C. Create lifecycle rules to move untouched data to Glacier Instant Retrieval after 90 days.

D. Implement a Lambda function that tracks access patterns and moves objects between storage classes manually.

**Correct Answer: A**

**Explanation:** Intelligent-Tiering eliminates the guesswork of storage class selection. The 70% of cold data automatically moves to IA and Archive Instant Access tiers—achieving approximately 75-85% cost reduction for that portion. Objects remain instantly accessible with millisecond latency at any tier. Monthly cost reduction: from ~$4,600 to approximately ~$1,800 (saving ~$2,800/month). The monitoring fee ($0.0025/1000 objects) is negligible. Option B saves less because Standard-IA has minimum storage charges and the IA rate is higher than Intelligent-Tiering's Archive Instant Access tier. Option C requires lifecycle rules that don't adapt to changing access patterns—if patterns shift, you'd need to update rules. Option D is a custom solution replicating what Intelligent-Tiering does natively.

---

### Question 44

A company uses FSx for Windows File Server with a 10 TB SSD volume for application file shares. Analysis shows that only 2 TB of data is actively used—the remaining 8 TB consists of old project files rarely accessed. FSx costs are $2,300/month.

Which optimization reduces storage costs while keeping all data accessible?

A. Enable FSx for Windows File Server's storage capacity auto-scaling and configure data deduplication (which is built into FSx for Windows). Additionally, migrate the FSx file system from SSD to HDD storage for the capacity tier if sub-millisecond latency isn't required for the majority of data. For the 2 TB of active data that needs high performance, create a smaller SSD-based FSx file system and use DFS Namespaces to present a unified view. Archive old project files to the HDD file system.

B. Move old files from FSx to S3 Glacier and modify applications to use S3 for archived data.

C. Switch from FSx for Windows to EFS with lifecycle management.

D. Delete old project files to reduce the volume size.

**Correct Answer: A**

**Explanation:** FSx for Windows supports HDD storage at significantly lower cost than SSD (~$0.013/GB vs ~$0.13/GB). Using DFS Namespaces (a Windows feature supported by FSx), you present both file systems as a single namespace to users. Active data on SSD provides performance; archive data on HDD provides cost efficiency. Data deduplication (built into FSx for Windows) further reduces storage by eliminating duplicate content (common in project files). Combined, these optimizations can reduce costs by 60-70%. Option B requires application changes and loses the Windows file system experience. Option C requires switching protocols (SMB to NFS). Option D deletes potentially needed data.

---

### Question 45

A company's S3 Transfer Acceleration bill has increased 300% due to expanding global uploads. They currently use Transfer Acceleration for all uploads from 15 global offices, including offices with Direct Connect connectivity to the nearest AWS Region.

Which optimization reduces transfer costs without impacting upload performance?

A. Audit which offices actually benefit from Transfer Acceleration by comparing upload speeds with and without acceleration using the S3 Transfer Acceleration Speed Comparison tool. Offices with Direct Connect or those near an AWS Region likely see minimal benefit from Transfer Acceleration. Disable Transfer Acceleration for these offices and route their uploads through Direct Connect or standard S3 endpoints. Keep Transfer Acceleration only for offices with high-latency internet connections far from AWS Regions. Implement S3 Multi-Region Access Points for offices that upload to different regional buckets.

B. Replace Transfer Acceleration with CloudFront uploads for all offices.

C. Compress all files before upload to reduce the amount of data transferred via Transfer Acceleration.

D. Switch to S3 Glacier for uploads to eliminate Transfer Acceleration charges.

**Correct Answer: A**

**Explanation:** Transfer Acceleration charges a premium ($0.04-$0.08/GB) on top of standard transfer costs. Offices with Direct Connect already have dedicated, low-latency connectivity—Transfer Acceleration adds cost without significant performance benefit. The Speed Comparison tool provides data-driven decisions about which offices benefit. S3 Multi-Region Access Points route uploads to the closest bucket automatically, replacing the need for Transfer Acceleration in many cases. Option B doesn't necessarily reduce costs (CloudFront PUT operations aren't free). Option C reduces transfer volume but doesn't eliminate unnecessary acceleration charges. Option D changes the storage class, not the transfer method.

---

### Question 46

A company's EFS file system costs $15,000/month for 50 TB of data. CloudWatch metrics show that average throughput is only 50 MiB/s, but the file system is in Provisioned Throughput mode set at 1 GiB/s. Only 10% of data is accessed weekly.

Which combination of changes provides the MOST cost reduction? (Choose TWO.)

A. Switch from Provisioned Throughput (1 GiB/s) to Elastic Throughput mode. Elastic Throughput automatically scales throughput based on workload needs—you pay only for throughput consumed. At an average of 50 MiB/s, this eliminates paying for 950 MiB/s of unused provisioned throughput.

B. Enable EFS Lifecycle Management to transition files not accessed for 7 days to the Infrequent Access storage class. With 90% of data rarely accessed, this moves ~45 TB to IA at $0.016/GB vs Standard at $0.30/GB, reducing storage costs by approximately $13,000/month.

C. Migrate from EFS to S3 Standard for all data.

D. Switch from Multi-AZ to One Zone EFS to reduce storage costs by 47%.

E. Increase the Provisioned Throughput to 2 GiB/s to reduce I/O wait time.

**Correct Answer: A, B**

**Explanation:** (A) Switching from Provisioned to Elastic Throughput eliminates the fixed cost of provisioning 1 GiB/s when average usage is only 50 MiB/s. Elastic Throughput charges per MiB transferred, which is dramatically cheaper at 50 MiB/s. (B) Lifecycle Management to IA moves 90% of data (45 TB) from $0.30/GB to $0.016/GB—a 94.7% reduction on those files. Combined, these two changes could reduce the $15,000/month bill to approximately $1,500-2,000/month. Option C requires application changes. Option D reduces durability—risky for 50 TB. Option E increases costs.

---

### Question 47

A company uses Storage Gateway Tape Gateway to write backups to virtual tapes in S3 Glacier. They've accumulated 2,000 virtual tapes over 5 years. Compliance requires 7-year retention, but many tapes from the first 2 years contain data for decommissioned systems and are no longer needed. The company wants to reduce costs by deleting unnecessary tapes.

Which approach safely identifies and removes unneeded tapes?

A. Retrieve the tape inventory from Storage Gateway using the `ListTapes` and `DescribeTapes` APIs. Cross-reference tape barcodes with the backup application's catalog to identify tapes associated with decommissioned systems. For tapes confirmed as unneeded, use the `DeleteTape` API to remove them from Storage Gateway and the `DeleteTapeArchive` API to delete them from Glacier archive. For tapes that must be retained, verify they're in Glacier Deep Archive for lowest cost. Create a tape lifecycle report and store it in S3 with Object Lock for compliance documentation.

B. Delete all tapes older than 2 years assuming they're no longer needed.

C. Move all tapes from Glacier to Glacier Deep Archive to reduce costs without deleting anything.

D. Archive the tape metadata to DynamoDB and delete the physical tapes from Glacier.

**Correct Answer: A**

**Explanation:** Safe tape cleanup requires cross-referencing the Storage Gateway tape inventory with the backup application's catalog to identify tapes belonging to decommissioned systems. The `DeleteTape` and `DeleteTapeArchive` APIs properly remove tapes from both Storage Gateway and Glacier. Creating a compliance-documented lifecycle report (with Object Lock) provides an audit trail of deletion decisions. Tapes that must be retained should be in Glacier Deep Archive for minimum cost. Option B risks deleting needed tapes without verification. Option C doesn't reduce the number of tapes, only storage costs. Option D deletes data while keeping useless metadata.

---

### Question 48

A company runs a data analytics platform where users upload CSV files to S3, which are processed into Parquet and stored in an analytics bucket. Users report that querying Parquet files with Athena is slow for large datasets. Investigation reveals that Parquet files are not optimally partitioned—all files are in a single prefix.

Which storage optimization improves Athena query performance the MOST?

A. Reorganize the Parquet files using a partitioning strategy based on query patterns. Implement Hive-style partitioning (e.g., `s3://bucket/table/year=2024/month=01/day=15/`) based on date columns commonly used in WHERE clauses. Use AWS Glue ETL jobs to repartition existing data and compact small files into larger Parquet files (~128-256 MB each, aligned with Athena's optimal file size). Update the Glue Data Catalog with partition definitions. Configure the processing pipeline to output correctly partitioned and sized Parquet files going forward.

B. Switch from Parquet to CSV format for Athena queries.

C. Enable S3 Select to allow Athena to push queries down to S3.

D. Move data from S3 Standard to S3 Intelligent-Tiering to improve access speed.

**Correct Answer: A**

**Explanation:** Athena performance is primarily determined by data layout in S3. Hive-style partitioning enables partition pruning—Athena reads only partitions matching the query's WHERE clause, skipping irrelevant data. File size optimization (128-256 MB) balances parallelism with overhead—too many small files cause excessive S3 LIST/GET operations, while too few large files limit parallelism. Proper partitioning and file sizing typically improves Athena query performance by 10-100x. Option B moves to a less efficient format (CSV doesn't support predicate pushdown or columnar access). Option C doesn't apply—Athena already uses S3-level optimizations. Option D changes storage class, not data layout.

---

### Question 49

A company has 100 TB of data in S3 with S3 Versioning enabled. They discover that noncurrent versions consume an additional 200 TB, tripling their storage costs. Most noncurrent versions are from automated ETL processes that overwrite files frequently.

Which approach reduces versioning costs MOST while maintaining version protection?

A. Implement S3 Lifecycle rules with `NoncurrentVersionExpiration` to delete noncurrent versions after 7 days (keeping them long enough for rollback). Set `NewerNoncurrentVersions` to 2 to keep only the 2 most recent noncurrent versions per object. For the ETL pipeline, evaluate whether versioning is needed on ETL output buckets—if not (since ETL can reprocess), disable versioning on those specific buckets. For buckets that need versioning, apply lifecycle rules immediately to clean up the existing 200 TB of noncurrent versions.

B. Disable versioning on all buckets to stop accumulating noncurrent versions.

C. Move all noncurrent versions to Glacier Deep Archive using lifecycle transitions.

D. Use S3 Batch Operations to manually delete all noncurrent versions older than 30 days.

**Correct Answer: A**

**Explanation:** The combination of `NoncurrentVersionExpiration` (7 days) and `NewerNoncurrentVersions` (2) ensures that no more than 2 historical versions are kept, and they're automatically deleted after 7 days. For ETL buckets where outputs can be regenerated, disabling versioning eliminates the problem entirely. Lifecycle rules apply to existing noncurrent versions, cleaning up the 200 TB backlog. The net effect reduces the 200 TB of noncurrent versions to a small fraction. Option B removes version protection entirely—risky for non-ETL buckets. Option C still stores all 200 TB (cheaper but still expensive). Option D is a one-time cleanup without ongoing management.

---

### Question 50

A company's S3 storage costs have grown to $50,000/month. The storage team lacks visibility into which applications, teams, and data classifications are driving costs. They need to implement comprehensive S3 cost attribution.

Which approach provides the MOST detailed cost visibility?

A. Implement a multi-layered attribution strategy: (1) Enable S3 Storage Lens with organization-level aggregation for dashboard views of storage by account, bucket, Region, and storage class. (2) Apply cost allocation tags to all S3 buckets (team, application, environment, data-classification). (3) Enable the tags in the Billing Console for Cost Allocation. (4) Create CUR (Cost and Usage Report) queries in Athena that group S3 costs by tag combinations. (5) Build QuickSight dashboards showing cost trends by team, application, and classification. (6) Set up AWS Budgets with tag-based filters to alert teams when their S3 costs exceed thresholds.

B. Use CloudWatch S3 metrics to monitor bucket sizes and correlate with billing manually.

C. Enable S3 server access logging and parse logs to estimate per-application access costs.

D. Create separate AWS accounts per team and use consolidated billing to separate costs.

**Correct Answer: A**

**Explanation:** This comprehensive approach provides visibility at every level: Storage Lens for operational dashboards, cost allocation tags for financial attribution, CUR + Athena for detailed analysis, QuickSight for executive reporting, and Budgets for proactive cost management. Tags enable grouping costs by any dimension (team, app, classification), and CUR provides line-item-level detail including storage class, API call type, and data transfer. Option B is manual and limited to storage volume (not costs by dimension). Option C estimates access costs but misses storage costs. Option D is operationally heavy and doesn't help with shared-account scenarios.

---

### Question 51

A company uses S3 for a data lake with 500 TB of data. They currently use SSE-S3 (AES-256) encryption. A new compliance requirement mandates that all data must be encrypted with customer-managed KMS keys, and the encryption key must be rotated annually. The transition must not require re-encrypting existing data immediately.

Which approach transitions encryption MOST efficiently?

A. Create a customer-managed KMS key with automatic annual rotation enabled. Update the S3 bucket default encryption setting to use the new KMS key (SSE-KMS). All new objects uploaded after this change are encrypted with the KMS key. Existing objects remain encrypted with SSE-S3. For existing objects, use S3 Batch Operations with the COPY operation (copy-in-place) to re-encrypt them with the KMS key in batches over time. Enable S3 Bucket Keys to reduce KMS API calls and costs. AWS Config rules monitor encryption compliance.

B. Create a new bucket with KMS encryption. Copy all 500 TB from the old bucket to the new one.

C. Use Lambda triggers to re-encrypt objects on next access.

D. Wait for natural object overwrites to gradually transition all objects to KMS encryption.

**Correct Answer: A**

**Explanation:** Changing the bucket default encryption to SSE-KMS immediately affects new uploads. For existing objects, S3 Batch Operations efficiently re-encrypts objects in-place (COPY to the same location with new encryption settings) without creating a new bucket or changing object paths. KMS automatic rotation rotates the key material annually while maintaining the same key ARN. S3 Bucket Keys reduce KMS API calls from per-object to per-bucket-key, significantly reducing costs. Option B requires 500 TB of data movement and updates to all references. Option C only re-encrypts accessed objects—many objects may never be accessed. Option D relies on overwrites that may never happen for archival data.

---

### Question 52

A company has been using S3 Glacier Flexible Retrieval for backups. They realize that most restorations require Standard retrieval (3-5 hours), but they're occasionally hit with Expedited retrieval charges ($10/GB) when urgent restorations are needed. Monthly urgent restoration costs average $5,000 for approximately 500 GB.

Which optimization reduces urgent restoration costs while maintaining retrieval speed?

A. Purchase Provisioned Capacity for Glacier Flexible Retrieval. Each unit of provisioned capacity guarantees retrieval throughput of 150 MB/s and 3 expedited retrievals per 5 minutes, at $100/month per unit. For 500 GB/month of urgent retrievals, one provisioned capacity unit ($100/month) is sufficient and eliminates the $10/GB charge for expedited retrievals—reducing costs from $5,000 to $100. When provisioned capacity is available, expedited retrievals are guaranteed within 1-5 minutes.

B. Migrate from Glacier Flexible Retrieval to Glacier Instant Retrieval for all backup data.

C. Keep a copy of frequently needed backup data in S3 Standard alongside the Glacier copy.

D. Use S3 Object Lambda to serve cached copies of recently restored Glacier objects.

**Correct Answer: A**

**Explanation:** Provisioned Capacity units provide guaranteed expedited retrieval at a fixed monthly cost ($100/unit) instead of per-GB charges. For 500 GB of monthly urgent restorations, one unit saves $4,900/month ($5,000 - $100). Provisioned capacity guarantees that expedited retrieval requests are processed, whereas without it, expedited retrievals can fail during periods of high demand. Option B moves all data to a more expensive storage class when only 500 GB/month needs fast retrieval. Option C doubles storage costs. Option D only helps with recently restored objects, not new restoration requests.

---

### Question 53

A company has 20 on-premises file servers with a combined 300 TB of data. Each server serves a different department. They want to consolidate all file servers into AWS, providing a single namespace where each department has its own share with separate storage quotas.

Which architecture provides consolidated file serving with per-department quotas?

A. Deploy Amazon FSx for NetApp ONTAP with multiple Storage Virtual Machines (SVMs)—one per department. Each SVM has its own NFS/SMB share and FlexVol with a configurable quota (max size). Users access their department's SVM. ONTAP's built-in quota management provides per-user and per-directory quotas within each SVM. The underlying file system pool is shared, enabling efficient storage utilization. Data deduplication and compression across the file system reduce total storage requirements.

B. Create separate EFS file systems per department. There's no native quota mechanism, so use a Lambda function to monitor and enforce sizes.

C. Deploy separate FSx for Windows File Server instances per department.

D. Use S3 with per-department prefixes and Lambda-based quota enforcement.

**Correct Answer: A**

**Explanation:** FSx for NetApp ONTAP's multi-tenancy model with Storage Virtual Machines is ideal for department consolidation. Each SVM provides an isolated file serving environment with its own protocol access and authentication. ONTAP's native quota management supports per-user, per-group, and per-directory quotas—a feature not available in EFS or FSx for Windows. FlexVol volumes provide flexible capacity allocation from a shared pool. Deduplication and compression reduce total storage requirements significantly (typically 30-65%). Option B lacks native quotas and requires 20 separate file systems. Option C creates 20 separate FSx instances with independent management. Option D isn't a file system solution.

---

### Question 54

A company needs to migrate 2 PB of cold data from an on-premises tape library to S3 Glacier Deep Archive. The tape library uses LTO-8 tapes. They have no Direct Connect and only a 1 Gbps internet connection. The migration must complete within 90 days.

Which migration approach is MOST cost-effective and meets the deadline?

A. Order AWS Snowball Edge Storage Optimized devices. Request 25 devices (80 TB each = 2 PB). Set up a parallel tape-to-Snowball workflow: mount LTO-8 tapes, read data, and write to Snowball devices. Ship devices to AWS in batches as they're filled. Configure Snowball import jobs to target S3 with lifecycle policies that immediately transition to Glacier Deep Archive. At the tape library's typical read speed of ~300 MB/s per drive, with multiple drives operating in parallel, data can be read from tape faster than Snowball devices can be filled.

B. Transfer 2 PB over the 1 Gbps internet connection directly to S3 Glacier Deep Archive.

C. Install a 10 Gbps Direct Connect circuit and transfer data directly.

D. Use AWS DataSync over the internet with compression enabled.

**Correct Answer: A**

**Explanation:** At 1 Gbps, transferring 2 PB would take approximately 185 days—exceeding the 90-day deadline. Snowball Edge devices at 80 TB each require ~25 devices. With parallel tape-to-Snowball operations and batch shipping, the 90-day deadline is achievable. The workflow: fill devices over ~30-40 days (limited by tape read speed and parallel operations), ship in batches (5-7 days per batch), and AWS ingests data from devices. Lifecycle policies transition data to Deep Archive immediately after S3 import. Option B takes 185 days at full link utilization. Option C requires months for Direct Connect provisioning. Option D is still limited by the 1 Gbps link.

---

### Question 55

A broadcast company needs to migrate 500 TB of video assets from on-premises SAN storage to Amazon S3 while maintaining file-level access from their video editing applications during migration. Editors must continue working uninterrupted throughout the 6-month migration period.

Which migration strategy enables continuous file access during migration?

A. Deploy an AWS Storage Gateway File Gateway on-premises. Configure an NFS/SMB file share on the gateway backed by the target S3 bucket. The gateway presents a familiar file system interface to editors. Phase 1: Copy existing data from SAN to the File Gateway share (which uploads to S3 in the background) using robocopy/rsync during off-hours. Phase 2: Redirect editing applications from the SAN mount to the File Gateway mount. Editors experience transparent access—frequently used files are served from the gateway's local cache. Phase 3: Decommission the SAN after verifying all data is in S3.

B. Use AWS DataSync to bulk-transfer the 500 TB to S3 first, then switch editors to access S3 directly.

C. Ship data using Snowball Edge devices and cut over editing workflows after data arrives in S3.

D. Set up S3 Mountpoint on on-premises editors' workstations to access S3 directly.

**Correct Answer: A**

**Explanation:** File Gateway provides a bridge between on-premises file access and S3. During migration, editors access the gateway's file share as they would any NFS/SMB share, with the local cache providing low-latency access to active files. Data is uploaded to S3 in the background. This enables a non-disruptive migration where editors never experience downtime—they simply mount a different share at the switchover point. The gateway's local cache ensures editing performance isn't degraded by S3 latency. Option B requires a long bulk transfer period before editors can work with the new system. Option C has a cutover gap while data ships. Option D doesn't work on-premises—S3 Mountpoint is for EC2 instances.

---

### Question 56

A company operates an on-premises Windows file server with 50 TB of data accessed by 500 users. They need to migrate to AWS FSx for Windows File Server with zero downtime. Users authenticate via on-premises Active Directory. The migration must preserve all NTFS permissions, file attributes, and share configurations.

Which migration approach ensures zero downtime with permission preservation?

A. Deploy AWS Managed Microsoft AD with a trust to on-premises AD (or use AD Connector). Create an FSx for Windows File Server Multi-AZ file system joined to the domain. Use AWS DataSync with a Windows agent on-premises to transfer data from the on-premises file server to FSx. DataSync preserves NTFS permissions, file metadata, and ownership. Run the initial full sync during a weekend. Configure daily incremental syncs thereafter. When ready for cutover: run a final incremental sync, update DFS Namespace to point to the FSx file share, and editors seamlessly access FSx without reconnecting.

B. Use robocopy to copy files from on-premises to an EC2 instance, then from EC2 to FSx.

C. Export the file server data to a VHD file, upload it to S3, and restore it to FSx.

D. Use Windows Server Migration Tools to perform a live migration of the file server VM to EC2, then attach the data to FSx.

**Correct Answer: A**

**Explanation:** DataSync preserves NTFS permissions, ACLs, timestamps, and ownership during transfer—critical for Windows file server migration. The incremental sync approach minimizes the final cutover window. DFS Namespace provides seamless redirection—users' mapped drives automatically point to the FSx share without manual reconfiguration. The AD trust/Connector ensures the same user identities work with FSx. Multi-AZ provides high availability. Option B loses NTFS metadata in a two-hop transfer and requires an intermediate EC2 instance. Option C is not a supported FSx workflow. Option D doesn't translate a VM migration into FSx (FSx is not a VM-based service).

---

### Question 57

A research facility needs to migrate 100 TB of NFS data from on-premises to EFS. The data includes millions of small files (average 50 KB) in a deep directory hierarchy. Previous migration attempts with rsync failed due to the small file problem—metadata operations dominated the transfer time.

Which approach handles the small-file migration challenge MOST effectively?

A. Deploy multiple AWS DataSync agents (3-4 agents) on-premises. Configure them as a single DataSync location with the NFS share. DataSync is optimized for high-metadata workloads—it uses parallel file listing, batched file operations, and intelligent scheduling to handle millions of small files efficiently. Configure task settings with `OverwriteMode` set to `ALWAYS` and `PreserveDeletedFiles` enabled. DataSync's performance for small files is significantly better than rsync because it parallelizes metadata operations across its multi-threaded architecture.

B. Use a single rsync command with increased parallelism (`--parallel` flag) over Direct Connect.

C. Archive all small files into tar archives, transfer the archives with DataSync, then extract on the EFS side.

D. Use S3 Transfer Acceleration to upload files to S3, then use DataSync to move from S3 to EFS.

**Correct Answer: A**

**Explanation:** DataSync is specifically optimized for the small-file challenge. Multiple agents provide parallel file listing and transfer across the NFS namespace. DataSync's protocol handles metadata operations (stat, open, close) more efficiently than NFS-over-rsync by batching operations and maintaining persistent connections. With 3-4 agents, the metadata bottleneck is distributed across multiple parallel workers. DataSync also provides integrity verification, transfer scheduling, and progress monitoring. Option B's rsync is single-threaded for metadata operations even with parallel data transfer. Option C adds tar/untar overhead and loses incremental transfer capability. Option D adds an unnecessary S3 intermediate step.

---

### Question 58

A company has 5 PB of data in an on-premises Isilon (Dell EMC PowerScale) NAS accessed via NFS and SMB. They want to migrate to AWS but need to maintain the same multi-protocol access. The on-premises environment uses NDMP for backups. They need a phased migration over 12 months.

Which migration architecture maintains feature parity?

A. Target Amazon FSx for NetApp ONTAP for multi-protocol compatibility (NFS + SMB). Phase 1: Deploy FSx for ONTAP and configure SnapMirror-like replication (using DataSync for initial bulk transfer). Phase 2: Use AWS DataSync agents on the Isilon cluster to transfer data to FSx for ONTAP incrementally. Phase 3: Redirect NFS and SMB clients to FSx for ONTAP endpoints. Phase 4: Use AWS Backup for FSx for ONTAP backups (replacing NDMP). Phase 5: Decommission Isilon after verifying all data and workflows.

B. Migrate to EFS for NFS workloads and FSx for Windows for SMB workloads separately.

C. Migrate all data to S3 and use File Gateway for NFS/SMB access.

D. Replicate Isilon on EC2 using Dell EMC CloudIQ.

**Correct Answer: A**

**Explanation:** FSx for NetApp ONTAP provides true multi-protocol access (NFS + SMB to the same data), matching Isilon's capability. DataSync handles the bulk data migration from Isilon (NFS source) to FSx for ONTAP, preserving file metadata and permissions. The phased approach with incremental syncs allows the 12-month migration timeline. AWS Backup replaces NDMP for backup operations. ONTAP's storage efficiency features (deduplication, compression) may reduce the storage footprint from 5 PB. Option B splits the workload across two different file systems, requiring data synchronization. Option C adds gateway latency and doesn't provide native multi-protocol access. Option D puts Isilon software on EC2, which isn't a supported or efficient approach.

---

### Question 59

A company uses AWS Storage Gateway Volume Gateway in cached mode to provide iSCSI storage for on-premises applications. They're now fully migrating to AWS and need to convert the Volume Gateway volumes to native EBS volumes attached to EC2 instances.

Which migration path converts Volume Gateway volumes to EBS?

A. Create EBS snapshots from the Volume Gateway volumes using the Storage Gateway console (Volume Gateway volumes are backed by S3 and can be snapshotted to EBS snapshots). Once the EBS snapshot is created, create an EBS volume from the snapshot in the desired AZ. Attach the EBS volume to an EC2 instance. Verify data integrity by mounting the volume and checking file system consistency. Decommission the Volume Gateway after confirming all volumes are migrated.

B. Use DataSync to transfer data from Volume Gateway to EBS.

C. Mount the Volume Gateway volume on an EC2 instance via iSCSI and use dd to copy data to an EBS volume.

D. Export Volume Gateway data to S3 and then restore to EBS.

**Correct Answer: A**

**Explanation:** Volume Gateway natively supports creating EBS snapshots from gateway volumes—this is a built-in feature. The snapshot captures the entire volume state, and creating an EBS volume from the snapshot is a standard AWS operation. This is the most direct and reliable migration path. The process is: Volume Gateway → EBS Snapshot → EBS Volume → Attach to EC2. Option B adds unnecessary complexity with DataSync. Option C works but is much slower and more complex than using native snapshots. Option D isn't a direct feature—while Volume Gateway data is stored in S3, it's in a gateway-specific format, not directly usable.

---

### Question 60

A company is migrating a Hadoop cluster with 200 TB in HDFS to an S3-based data lake. Their Hadoop applications use HDFS-specific features: atomic renames for output commit, directory listings, and consistent read-after-write. They need these semantics preserved when moving to S3.

Which approach ensures Hadoop application compatibility with S3?

A. Use the S3A connector (hadoop-aws) with S3Guard disabled (no longer needed with S3's strong consistency). Configure the S3A committer (`org.apache.hadoop.fs.s3a.commit.staging.StagingCommitter` or the magic committer) for atomic output commits, replacing HDFS rename-based commits. S3's strong read-after-write consistency (available since December 2020) handles consistent reads. For directory listings, S3A provides directory markers and listing capabilities. Migrate data using DataSync from HDFS to S3, then update Hadoop configurations to use `s3a://` paths.

B. Deploy FSx for Lustre as an HDFS replacement. Lustre provides POSIX semantics including atomic renames.

C. Use EMRFS (S3 as HDFS replacement on EMR) with consistent view enabled using DynamoDB.

D. Keep a small HDFS cluster running alongside S3 for metadata operations.

**Correct Answer: A**

**Explanation:** S3's strong consistency (launched December 2020) eliminated the need for consistency layers like S3Guard or EMRFS consistent view. The S3A committer handles atomic output commits without relying on rename operations (which S3 doesn't support efficiently). The magic committer writes data to the final location directly, using multipart upload completion for atomicity. S3A provides directory listing support. DataSync handles the HDFS-to-S3 migration. Option B works but adds FSx for Lustre infrastructure costs. Option C's consistent view with DynamoDB is deprecated since S3 now has strong consistency. Option D maintains unnecessary HDFS infrastructure.

---

### Question 61

A company needs to migrate 50 TB of data from Azure Blob Storage to AWS S3. They don't have direct network connectivity between Azure and AWS. The transfer must complete within 2 weeks.

Which approach transfers data between cloud providers efficiently?

A. Deploy an EC2 instance in the same Azure region (or the nearest AWS Region to the Azure region) with sufficient network bandwidth. Use the `azcopy` tool to download data from Azure Blob Storage and simultaneously upload to S3 using the AWS CLI or SDK with multipart upload. Alternatively, use AWS DataSync with a DataSync agent running on an EC2 instance that has access to Azure Blob Storage over the internet. Calculate bandwidth requirements: 50 TB in 2 weeks requires approximately 350 Mbps sustained throughput.

B. Use Azure Data Box to ship data from Azure to an AWS Direct Connect location.

C. Use a third-party cloud-to-cloud migration service.

D. Download all data from Azure to on-premises, then upload to AWS using Snowball.

**Correct Answer: A**

**Explanation:** Running an EC2 instance (or using DataSync agent) to orchestrate the transfer between Azure Blob Storage and S3 is the most direct approach. Internet transfer between Azure and AWS typically achieves good throughput since both providers have well-connected networks. At 350 Mbps sustained (easily achievable), 50 TB transfers in 2 weeks. The EC2 instance can run multiple parallel transfer streams to maximize throughput. DataSync provides monitoring, scheduling, and integrity verification. Option B is complex (Azure Data Box to AWS is not a standard workflow). Option C adds cost and dependency. Option D doubles the transfer time through an on-premises intermediate.

---

### Question 62

A company is migrating from an on-premises Ceph distributed storage cluster (500 TB, both block and object storage) to AWS. Applications use the Ceph RADOS Block Device (RBD) for block storage and Ceph Object Gateway (RGW, S3-compatible) for object storage.

Which AWS migration target and approach best replaces both Ceph storage types?

A. Map Ceph storage types to AWS equivalents: Ceph RBD (block) → Amazon EBS for EC2 workloads, Ceph RGW (S3-compatible objects) → Amazon S3. For RBD migration: snapshot Ceph RBD images, export them as raw images, upload to S3, use `aws ec2 import-snapshot` to create EBS snapshots, then create EBS volumes. For RGW migration: use `rclone` (which supports both Ceph RGW S3 and AWS S3) or DataSync to transfer objects from Ceph RGW to AWS S3, preserving object metadata. Applications that used the Ceph S3 API require minimal changes since AWS S3 uses the same API.

B. Replicate the entire Ceph cluster on EC2 instances using Ceph's migration tools.

C. Migrate everything to S3, including block storage workloads.

D. Use FSx for Lustre as a replacement for both Ceph block and object storage.

**Correct Answer: A**

**Explanation:** This approach maps Ceph storage types to their AWS-native equivalents. EBS replaces Ceph RBD for block storage with direct snapshot import support. S3 replaces Ceph RGW with near-complete API compatibility (Ceph's S3 API is designed to be AWS S3-compatible). `rclone` is an excellent tool for S3-to-S3 compatible transfers with metadata preservation. Applications using Ceph's S3 API need only endpoint/credential changes to work with AWS S3. Option B creates unnecessary infrastructure complexity. Option C doesn't work for block storage workloads. Option D is a file system, not a replacement for block/object storage.

---

### Question 63

A company stores 1 PB of data across S3 storage classes. Current monthly costs: S3 Standard: $15,000 (650 TB), S3 Standard-IA: $4,875 (600 TB with retrieval fees), S3 Glacier IR: $2,000 (500 TB), S3 Glacier DA: $500 (500 TB). Analysis shows that 400 TB of the Standard data hasn't been accessed in 60 days, and 300 TB of Standard-IA data hasn't been accessed in 180 days.

Which optimization provides the GREATEST cost reduction?

A. Move the 400 TB of unaccessed Standard data to Glacier Instant Retrieval using lifecycle rules (from $0.023/GB to $0.004/GB = saving ~$7,600/month). Move the 300 TB of unaccessed Standard-IA data to Glacier Instant Retrieval (from $0.0125/GB to $0.004/GB = saving ~$2,550/month). Total monthly savings: approximately $10,150. Implement S3 Intelligent-Tiering for remaining Standard data to prevent future accumulation of cold data in expensive tiers.

B. Move all Standard data to Standard-IA.

C. Negotiate an Enterprise Discount Program (EDP) with AWS for bulk storage pricing.

D. Compress all data before storing in S3.

**Correct Answer: A**

**Explanation:** Moving 400 TB from Standard ($0.023/GB) to Glacier Instant Retrieval ($0.004/GB) saves $7,600/month. Moving 300 TB from Standard-IA ($0.0125/GB) to Glacier Instant Retrieval ($0.004/GB) saves $2,550/month. Total savings: ~$10,150/month or ~$121,800/year. Glacier Instant Retrieval provides millisecond access, maintaining the user experience. Intelligent-Tiering on remaining Standard data prevents future cold data accumulation. Option B saves less (Standard-IA is more expensive than Glacier IR). Option C requires significant commitment and may not match the savings from proper tiering. Option D requires processing all 1 PB of data and may not be feasible for all data types.

---

### Question 64

A company runs FSx for Lustre Persistent 2 at 100 TB for machine learning workloads. The file system costs $14,000/month. ML training runs only during business hours (10 hours/day, 5 days/week, ~217 hours/month out of 730 hours). The rest of the time, data sits idle in S3 (which Lustre is linked to).

Which optimization provides the GREATEST cost savings?

A. Switch from Persistent 2 to Scratch 2 deployment. Automate file system creation and deletion using EventBridge Scheduled Rules with Lambda: create the FSx for Lustre scratch file system linked to the S3 data repository before business hours, and delete it after business hours. Data persists in S3 (the file system is linked to S3, so all data is available on next creation). The Lustre scratch file system costs approximately $140/TB/month pro-rated—at 217 hours/month, this is approximately 30% of full-month cost, reducing costs from $14,000 to approximately $4,200/month.

B. Reduce the FSx file system size during off-hours and scale it back up during business hours.

C. Use EFS instead of FSx for Lustre for ML workloads.

D. Keep the Persistent 2 file system but scale down throughput during off-hours.

**Correct Answer: A**

**Explanation:** FSx for Lustre with S3 data repository integration enables the create/delete pattern—data persists in S3 between file system instances. Scratch 2 file systems are cheaper than Persistent 2 and appropriate for temporary compute-intensive workloads (data is already durable in S3). Running only during business hours (217 of 730 hours = ~30% of the month) reduces costs by ~70%. Automation ensures reliability. Option B isn't possible—FSx for Lustre doesn't support dynamic size reduction. Option C offers lower performance for ML workloads. Option D provides some savings but Persistent 2 still has a higher base cost than Scratch 2.

---

### Question 65

A company uses EBS gp3 volumes across 500 EC2 instances. Monthly EBS costs are $25,000. Analysis reveals: (1) 30% of volumes are unattached, (2) 40% of attached volumes have average IOPS utilization below 5%, and (3) 15% of volumes have less than 10% storage utilization.

Which combination of optimizations provides the MOST cost reduction? (Choose THREE.)

A. Delete unattached EBS volumes after creating snapshots for backup. This eliminates 30% of the volume costs (~$7,500/month saved) while preserving data in snapshots.

B. For volumes with low IOPS utilization (< 5%), check if they're provisioned with IOPS above the gp3 baseline (3,000 IOPS). If so, reduce provisioned IOPS to the free baseline. If the workload could tolerate gp2 burst behavior, consider gp2 as an alternative for cost parity with free baseline IOPS.

C. For volumes with < 10% storage utilization, resize them down to the minimum needed (accounting for growth). Use EBS Elastic Volumes to modify the size online without downtime.

D. Migrate all volumes from gp3 to sc1 (cold HDD) for lowest cost.

E. Enable EBS snapshots for all volumes as a replacement for live volumes.

**Correct Answer: A, B, C**

**Explanation:** (A) Unattached volumes are pure waste—deleting them saves 30% of costs. Snapshots preserve data at ~$0.05/GB/month vs $0.08/GB/month for gp3 volumes. (B) gp3 volumes include 3,000 IOPS free. If additional IOPS were provisioned but utilization is < 5%, the provisioned IOPS ($0.005/IOPS/month) are wasted. (C) Oversized volumes waste the per-GB storage cost. EBS Elastic Volumes enables online size reduction without downtime. Combined, these three optimizations could save 40-50% of the $25,000 monthly cost. Option D sacrifices performance for workloads that need SSD I/O patterns. Option E converts live storage to cold storage, requiring restoration for any access.

---

### Question 66

A company uses S3 for a web application that serves static assets. CloudFront sits in front of S3. Monthly S3 costs breakdown: storage ($5,000), GET requests ($8,000), data transfer ($3,000). The high GET request cost indicates many cache misses at CloudFront.

Which optimization reduces S3 GET request costs MOST?

A. Optimize CloudFront caching to reduce origin GET requests: (1) increase CloudFront default TTL and maximum TTL values, (2) configure the application to send proper Cache-Control headers on S3 objects (e.g., `max-age=31536000` for versioned assets), (3) enable Origin Shield on CloudFront to add a caching layer between edge locations and the S3 origin (reducing duplicate origin requests from different edge caches), (4) analyze the URL patterns—if query strings are used unnecessarily, configure CloudFront to ignore query strings or forward only relevant ones.

B. Enable S3 Requester Pays to shift GET costs to end users.

C. Move assets from S3 to EC2 instance storage behind CloudFront.

D. Switch from S3 Standard to S3 One Zone-IA to reduce per-GET charges.

**Correct Answer: A**

**Explanation:** S3 GET request costs are driven by CloudFront origin requests (cache misses). Each optimization reduces origin requests: longer TTLs keep content cached at edge locations, proper Cache-Control headers tell CloudFront to cache effectively, Origin Shield adds a regional cache layer that consolidates origin requests from edge locations in the same region, and query string optimization prevents cache fragmentation. These changes can reduce origin GETs by 60-90%, directly lowering the $8,000/month in S3 GET costs. Option B shifts costs to users, not reducing them. Option C adds EC2 management overhead. Option D changes storage class but Standard-IA actually has higher per-GET costs than Standard.

---

### Question 67

A company has 100 TB in S3 Glacier Flexible Retrieval. They pay $1,000/month for storage. However, they perform about 50 Standard retrievals per month (average 1 GB each), costing an additional $500/month in retrieval and early deletion fees. The retrieved data is typically needed for only a few hours.

Which optimization reduces retrieval costs?

A. Analyze retrieval patterns to identify frequently retrieved objects. Move these objects (~2 TB based on 50 × 1 GB per month with overlap analysis) to S3 Glacier Instant Retrieval, which has no retrieval fee (just a per-GB storage premium). Keep the remaining 98 TB in Glacier Flexible Retrieval. Implement a metadata layer (DynamoDB) that tracks retrieval history and automatically moves objects to Glacier IR when they're retrieved more than twice. This optimizes the storage/retrieval cost balance.

B. Move all 100 TB to S3 Standard to eliminate retrieval fees.

C. Use Glacier Expedited Retrieval instead of Standard to reduce retrieval time (but this costs more).

D. Implement a caching layer in ElastiCache for recently retrieved Glacier objects.

**Correct Answer: A**

**Explanation:** The key insight is that some objects are retrieved repeatedly. Moving frequently retrieved objects to Glacier Instant Retrieval eliminates per-retrieval fees while adding only a modest storage cost increase ($0.004/GB vs $0.0036/GB for Flexible Retrieval). For 2 TB of frequently retrieved data, the storage increase is ~$0.80/month, while saving potentially hundreds in retrieval fees. The DynamoDB tracking layer automates the optimization over time. Option B moves 100 TB to Standard at $2,300/month—far more expensive. Option C increases retrieval costs. Option D adds ElastiCache infrastructure for objects that may not be retrieved again.

---

### Question 68

A company uses AWS Backup to protect 200 EBS volumes, 50 EFS file systems, and 100 RDS instances across 20 accounts. Monthly backup storage costs are $30,000 and growing 20% quarterly. Many backups are retained beyond their useful recovery window.

Which approach provides the MOST sustainable backup cost reduction?

A. Implement a tiered backup retention strategy aligned with actual recovery needs: (1) Use AWS Backup lifecycle rules to transition backups to cold storage after 7 days (cold storage costs ~$0.01/GB vs $0.05/GB for warm). (2) Review and reduce retention periods—reduce daily backup retention from 90 days to 30 days for development/staging environments (only production needs extended retention). (3) Create backup plans per resource tier: critical (hourly backup, 90-day retention), standard (daily, 30-day), development (daily, 7-day). (4) Use AWS Backup Audit Manager to identify and delete orphaned backups for terminated resources. (5) Tag resources with backup tier for automated plan assignment.

B. Reduce backup frequency from daily to weekly for all resources.

C. Delete all backups older than 7 days across all environments.

D. Switch from AWS Backup to custom EBS snapshot scripts to avoid backup service charges.

**Correct Answer: A**

**Explanation:** The tiered approach right-sizes backup spend based on actual recovery needs. Cold storage transition saves 80% on backup storage after 7 days. Environment-based retention prevents development backups from consuming 90 days of storage. Orphaned backup cleanup eliminates waste from terminated resources. Tag-based automation ensures new resources get appropriate backup plans. The 20% quarterly growth is likely driven by unbounded retention and orphaned backups. Option B reduces RPO to weekly—unacceptable for production. Option C deletes backups needed for compliance. Option D loses cross-service backup management capabilities.

---

### Question 69

A company processes 10 TB of logs daily, storing them in S3. Log files are written in JSON format (average 1 MB each, ~10 million files/day). Analytics runs Athena queries over the last 30 days of logs. Monthly S3 costs for log storage are $20,000. Athena queries scan far more data than necessary, adding to costs.

Which optimization reduces both storage and query costs?

A. Transform JSON logs to Apache Parquet format using a Glue ETL job (or Kinesis Data Firehose with format conversion) before storage. Parquet's columnar format reduces storage by 60-80% compared to JSON (compression + columnar efficiency). Partition Parquet files by date (`year/month/day/hour`) in S3 for Athena partition pruning. Compact small Parquet files into 128-256 MB files using Glue compaction jobs. Apply S3 Lifecycle rules to transition logs older than 7 days to Standard-IA and older than 30 days to Glacier IR. Expected savings: storage reduced 70% (JSON→Parquet) + 50% (lifecycle tiering) = ~$15,000/month. Athena scans reduced 90%+ through columnar reads and partition pruning.

B. Compress JSON logs with gzip before storing in S3.

C. Keep JSON format but partition by date for Athena optimization.

D. Move all logs to CloudWatch Logs Insights instead of S3 + Athena.

**Correct Answer: A**

**Explanation:** The Parquet conversion provides compounding benefits: (1) 60-80% smaller files reduce storage costs, (2) columnar format means Athena reads only queried columns (90%+ scan reduction for typical log queries that select a few fields), (3) date partitioning enables partition pruning (only scanning relevant time periods), (4) file compaction reduces per-request overhead. Lifecycle tiering further reduces costs for aging data. Option B saves storage but Athena still scans entire rows. Option C helps Athena but JSON files are still large and Athena still scans all columns. Option D costs more at 10 TB/day ingest volume.

---

### Question 70

A company has a Storage Gateway Volume Gateway in stored mode with 20 TB of data. The on-premises hardware is aging and needs replacement. They want to evaluate whether to replace the hardware or migrate to a fully cloud-native architecture.

Which cost comparison and migration approach should they use?

A. Compare costs: (1) Storage Gateway replacement hardware + maintenance + S3 snapshot storage + bandwidth vs (2) EBS volumes on EC2 + automated snapshots. If applications can run on EC2, migrate to cloud-native: create EBS snapshots from the Volume Gateway volumes, create EBS volumes from snapshots, attach to EC2 instances running the applications. If applications must remain on-premises, deploy Storage Gateway on VMware/Hyper-V virtual appliance on newer on-premises infrastructure (avoiding hardware-specific gateway), or consider AWS Outposts for on-premises AWS-native storage. Calculate the 3-year TCO including hardware lifecycle, maintenance, bandwidth, and EC2/EBS costs.

B. Simply replace the hardware with the same model and continue using Volume Gateway.

C. Migrate to EFS as it's more flexible than EBS for shared access.

D. Move to S3 and rewrite applications to use the S3 API.

**Correct Answer: A**

**Explanation:** This systematic approach evaluates both paths with TCO analysis. If applications can migrate to EC2, Volume Gateway's native EBS snapshot capability provides a direct migration path—no data reformatting needed. If applications must stay on-premises, deploying the gateway as a virtual appliance on commodity hardware or Outposts avoids vendor-specific hardware dependencies. The 3-year TCO should factor in hardware refresh cycles, power/cooling, maintenance contracts, and operational overhead vs. cloud operational costs. Option B perpetuates the hardware dependency cycle. Option C changes the storage architecture unnecessarily. Option D requires application rewrites.

---

### Question 71

A company uses S3 with cross-Region replication from us-east-1 to eu-west-1 for disaster recovery. Monthly replication costs include: data transfer ($2,000), PUT request charges at destination ($500), and storage at destination ($3,000). They want to reduce DR storage costs while maintaining the ability to recover within 4 hours.

Which optimization reduces DR costs MOST while meeting the RTO?

A. Configure S3 Replication rules to replicate objects to a destination bucket with Glacier Instant Retrieval as the storage class (using the `StorageClass` field in the replication configuration). This reduces destination storage costs by ~83% (from ~$0.023/GB to ~$0.004/GB). Glacier Instant Retrieval provides millisecond access, meeting the 4-hour RTO easily. Data transfer and PUT request costs remain the same, but storage drops from $3,000 to ~$510/month. Additionally, configure replication to use S3 Replication Time Control (RTC) to guarantee that 99.99% of objects replicate within 15 minutes.

B. Replace cross-Region replication with periodic AWS Backup cross-Region copies.

C. Reduce replication to only critical data, accepting data loss for non-critical assets.

D. Use S3 Same-Region Replication instead to reduce data transfer costs.

**Correct Answer: A**

**Explanation:** Replicating directly to Glacier Instant Retrieval as the storage class provides the largest single cost reduction—83% on storage, which is the biggest cost component. Glacier Instant Retrieval provides millisecond first-byte latency, far exceeding the 4-hour RTO requirement. RTC ensures replication completeness. This change requires only a modification to the replication rule configuration. Option B provides periodic copies (higher RPO) rather than continuous replication. Option C reduces data protection. Option D moves DR to the same Region, defeating the purpose of geographic redundancy.

---

### Question 72

A company uses Amazon EFS across 10 applications with separate file systems. Monthly EFS costs are $45,000. Analysis reveals: 3 file systems are in Provisioned Throughput mode (over-provisioned), 4 are in Bursting mode (frequently depleting burst credits), and 3 have minimal throughput needs. Total data: 150 TB with 80% infrequently accessed.

Which optimization plan provides the MOST cost savings?

A. (1) Switch all 10 file systems to Elastic Throughput—for over-provisioned systems, this eliminates paying for unused throughput; for bursting systems, this prevents credit depletion without over-provisioning. (2) Enable Lifecycle Management on all file systems with a 7-day transition to IA for all 10 file systems. With 80% of data (120 TB) transitioning from Standard ($0.30/GB) to IA ($0.016/GB), storage savings are approximately $35,280/month. (3) Evaluate if any file systems can be consolidated—applications sharing data patterns can share a single EFS file system using access points for isolation. (4) Switch non-critical file systems to One Zone storage class for 47% additional savings.

B. Migrate all EFS data to S3 and use Mountpoint for Amazon S3.

C. Consolidate all 10 file systems into a single file system to simplify management.

D. Switch all file systems to Max I/O performance mode.

**Correct Answer: A**

**Explanation:** The multi-pronged optimization targets the three main EFS cost drivers: throughput mode (Elastic vs Provisioned/Bursting), storage tiering (Standard vs IA), and redundancy (Multi-AZ vs One Zone). IA tiering alone saves ~$35,280/month on 120 TB of cold data. Elastic Throughput right-sizes throughput costs for all usage patterns. One Zone for non-critical data adds another 47% storage reduction. Consolidation where possible reduces the number of file systems to manage. Option B changes the access pattern and may not support all POSIX operations. Option C may create performance bottlenecks and permission management issues. Option D doesn't address costs—it changes performance characteristics.

---

### Question 73

A company stores 500 TB of data in S3 with S3 Versioning and S3 Object Lock (Compliance mode, 3-year retention). Their monthly S3 bill is $25,000. They want to reduce costs but can't delete data or disable Object Lock/versioning due to compliance.

Which optimization reduces costs within compliance constraints?

A. Implement S3 Lifecycle rules to transition current versions to Glacier Instant Retrieval after 30 days and to Glacier Deep Archive after 365 days. Transition noncurrent versions to Glacier Deep Archive after 1 day (noncurrent versions are for compliance retention, not active access). Object Lock retention and legal holds are preserved across all storage class transitions. Expected savings: current version storage moves from $0.023/GB to $0.004/GB (30-365 days) and $0.00099/GB (>365 days). Noncurrent versions move from $0.023/GB to $0.00099/GB. With noncurrent versions potentially doubling storage, savings could exceed 70%.

B. Disable versioning to stop accumulating noncurrent versions.

C. Remove Object Lock to allow deletion of old data.

D. Switch to S3 One Zone-IA for all data to reduce costs by 20%.

**Correct Answer: A**

**Explanation:** Storage class transitions are the only cost optimization available when you can't delete data, disable versioning, or remove Object Lock. The key insight is that noncurrent versions (which are compliance artifacts, rarely accessed) should be transitioned to Deep Archive as quickly as possible—they're kept for legal/compliance reasons, not operational access. Current versions follow a standard tiering path. Object Lock Compliance mode retention is maintained across all transitions—this is an explicit AWS guarantee. Option B is prohibited by compliance. Option C is prohibited by compliance. Option D provides only 20% savings vs 70%+ from proper tiering.

---

### Question 74

A company pays $8,000/month for S3 data transfer out to the internet for a file distribution service. Files average 500 MB and are downloaded by customers worldwide. They already use CloudFront, but many downloads bypass CloudFront through direct S3 URLs shared in emails.

Which approach reduces data transfer costs MOST?

A. Eliminate direct S3 access by: (1) configuring the S3 bucket with an Origin Access Control (OAC) policy that only allows CloudFront to access the bucket (remove all public access), (2) generating all download links as CloudFront signed URLs or signed cookies instead of S3 pre-signed URLs, (3) moving existing shared S3 URLs to CloudFront equivalents. CloudFront data transfer out is cheaper than S3 direct transfer ($0.085/GB vs $0.09/GB for first 10 TB, with volume discounts at higher tiers). CloudFront's Reserved Capacity pricing (commit to 10 TB/month) can reduce costs by an additional 30-40%.

B. Enable S3 Requester Pays to shift download costs to customers.

C. Compress all files to reduce the total data transferred.

D. Limit download speeds for customers to reduce bandwidth consumption.

**Correct Answer: A**

**Explanation:** Direct S3 data transfer out costs $0.09/GB. CloudFront's data transfer is cheaper, especially at volume ($0.085/GB first 10 TB, decreasing to $0.02/GB at higher tiers). OAC forces all access through CloudFront, ensuring the cost advantage applies to all downloads. CloudFront also caches files at edge locations, reducing origin fetches and improving customer download speeds. Reserved Capacity pricing (available through AWS Sales) can provide 30-40% additional discount. Combined, this could reduce the $8,000/month by 40-60%. Option B alienates customers. Option C may not be applicable to all file types. Option D degrades customer experience.

---

### Question 75

A company has implemented all recommended S3 cost optimizations (lifecycle policies, Intelligent-Tiering, bucket consolidation). Their remaining $100,000/month S3 bill consists primarily of storage for data that genuinely needs to be retained. They want further cost reduction.

Which advanced strategies can reduce already-optimized S3 costs? (Choose TWO.)

A. Negotiate an AWS Enterprise Discount Program (EDP) commitment. With $100,000/month in S3 alone, the company likely has significant total AWS spend. EDP commitments of $1M+/year typically provide 5-15% discounts on S3 storage, applied retroactively. For $100K/month, a 10% discount saves $120,000/year.

B. Implement application-level data compression before storing in S3. Use columnar formats (Parquet, ORC) for structured data and format-appropriate compression (gzip, zstd, lz4) for other data types. Depending on data types, compression can reduce storage 50-80%, saving $50,000-80,000/month.

C. Create S3 endpoints in all VPCs to eliminate NAT Gateway charges for S3 access.

D. Move all data to a single S3 bucket to reduce per-bucket overhead costs.

E. Switch all data to S3 Express One Zone for faster access at lower cost.

**Correct Answer: A, B**

**Explanation:** (A) EDP provides volume-based discounts that apply across all S3 usage. At $100K/month, the company has negotiating leverage for meaningful discounts. (B) If data hasn't already been compressed or converted to efficient formats, this is the largest remaining optimization opportunity. Parquet vs JSON can be 5-10x smaller. Zstandard compression provides excellent compression ratios with fast decompression. Combined, these strategies can reduce the $100K/month bill by 40-60%. Option C saves on data transfer, not storage costs (and is already likely optimized). Option D doesn't provide savings—S3 doesn't charge per-bucket fees. Option E is more expensive per GB, not cheaper.

---

## Answer Key

| Q | Ans | Q | Ans | Q | Ans | Q | Ans | Q | Ans |
|---|-----|---|-----|---|-----|---|-----|---|-----|
| 1 | A | 16 | A | 31 | A | 46 | A,B | 61 | A |
| 2 | A | 17 | A | 32 | A | 47 | A | 62 | A |
| 3 | A | 18 | A | 33 | A | 48 | A | 63 | A |
| 4 | A | 19 | C | 34 | A | 49 | A | 64 | A |
| 5 | A,D | 20 | A | 35 | A | 50 | A | 65 | A,B,C |
| 6 | D | 21 | A | 36 | A | 51 | A | 66 | A |
| 7 | A | 22 | A | 37 | A | 52 | A | 67 | A |
| 8 | A | 23 | B | 38 | A | 53 | A | 68 | A |
| 9 | A | 24 | A | 39 | A | 54 | A | 69 | A |
| 10 | A | 25 | A | 40 | A | 55 | A | 70 | A |
| 11 | A | 26 | A | 41 | A | 56 | A | 71 | A |
| 12 | A | 27 | A | 42 | A | 57 | A | 72 | A |
| 13 | A,B | 28 | A | 43 | A | 58 | A | 73 | A |
| 14 | C | 29 | A | 44 | A | 59 | A | 74 | A |
| 15 | A | 30 | A | 45 | A | 60 | A | 75 | A,B |
