# Flashcards — Domain 3 (Storage)

Q: S3 durability?
A: 99.999999999% (11 nines). #must-know

Q: S3 Standard availability SLA?
A: 99.99%. #must-know

Q: Max S3 object size?
A: 5 TB. #must-know

Q: Single PUT max size in S3?
A: 5 GB (use multipart for larger). #must-know

Q: Recommended multipart-upload threshold?
A: > 100 MB (mandatory > 5 GB). #must-know

Q: Cheapest S3 class for long archive retrieval within 12h OK?
A: S3 Glacier Deep Archive. #must-know

Q: Cheapest S3 class with ms retrieval?
A: S3 Glacier Instant Retrieval. #must-know

Q: S3 class for unknown/changing access patterns?
A: Intelligent-Tiering. #must-know

Q: Minimum storage duration for S3 Standard-IA?
A: 30 days. #must-know

Q: Minimum storage duration for S3 Glacier Flexible Retrieval?
A: 90 days. #must-know

Q: Minimum storage duration for Glacier Deep Archive?
A: 180 days. #must-know

Q: S3 One Zone-IA caveat?
A: Stored in a single AZ; loss if AZ is destroyed. #must-know

Q: What's S3 Transfer Acceleration?
A: Uploads via CloudFront edge to speed global transfers. #must-know

Q: What's S3 Select?
A: Server-side SQL-like filter on objects at GET. #must-know

Q: What's S3 Object Lambda?
A: Transform GET responses via a Lambda function. #must-know

Q: What's Block Public Access?
A: Account/bucket-level controls to prevent accidental public exposure. #must-know

Q: Presigned URL?
A: Time-limited signed URL granting temp access to an S3 object using the signer's creds. #must-know

Q: S3 versioning?
A: Keeps all versions of an object (including delete markers). #must-know

Q: S3 replication — CRR vs SRR?
A: CRR = cross-Region; SRR = same-Region. #must-know

Q: What's Object Lock?
A: WORM retention (Governance or Compliance mode) for regulatory requirements. #must-know

Q: S3 Lifecycle — what can it do?
A: Transition objects between classes or expire/delete them by age/tag/prefix. #must-know

Q: Can S3 host a website?
A: Yes (static website hosting, HTTP only; front with CloudFront for HTTPS + caching). #must-know

Q: Default EBS volume type?
A: gp3 (modern default). #must-know

Q: When to choose io2 Block Express?
A: Extreme IOPS/latency for SAP HANA, Oracle, other critical DBs. #must-know

Q: When to choose st1?
A: Big, throughput-focused HDD workloads (logs, data warehouses). #must-know

Q: When to choose sc1?
A: Cheapest cold HDD for rarely accessed data. #must-know

Q: EBS volume AZ behavior?
A: AZ-bound; attach only to EC2 in same AZ (exception: io1/io2 Multi-Attach within same AZ). #must-know

Q: EBS snapshot storage location?
A: S3 (internally; region-scoped; copyable cross-Region). #must-know

Q: Can EBS encryption be changed after creation?
A: No — restore from snapshot to new encrypted volume. #must-know

Q: What is EFS?
A: Managed NFSv4 file system for Linux. #must-know

Q: EFS Standard vs One Zone?
A: Standard is multi-AZ; One Zone is single AZ (cheaper). #must-know

Q: EFS storage tiers?
A: Standard, Standard-IA, Archive. #must-know

Q: Which managed SMB file system for Windows + AD?
A: FSx for Windows File Server. #must-know

Q: HPC/ML parallel file system?
A: FSx for Lustre. #must-know

Q: Which FSx is NetApp?
A: FSx for NetApp ONTAP. #must-know

Q: Which FSx is ZFS?
A: FSx for OpenZFS. #must-know

Q: Storage Gateway — which replaces a tape library?
A: Tape Gateway. #must-know

Q: Storage Gateway — which exposes an SMB share backed by S3?
A: S3 File Gateway. #must-know

Q: Snowball Edge Storage Optimized capacity?
A: 80 TB (usable). #must-know

Q: Snowcone SSD capacity?
A: 14 TB. #must-know

Q: Snowmobile?
A: Semi-truck with 100 PB (being retired — know concept). #must-know

Q: DataSync?
A: Agent-based online data transfer between on-prem/clouds and AWS (NFS/SMB/HDFS/object). #must-know

Q: Transfer Family?
A: Managed SFTP/FTPS/FTP/AS2 endpoints fronting S3/EFS. #must-know

Q: Elastic Disaster Recovery?
A: Continuous block replication to AWS staging area for DR; sub-second RPO. #must-know

Q: AWS Backup manages?
A: Centralized backup policies across 20+ AWS services + VMware + SAP HANA on EC2. #must-know

Q: Typical use for S3 Standard-IA?
A: Infrequently accessed data (≤ 1/month), still needing ms access. #must-know

Q: SSE-S3 key management?
A: Fully managed by S3; cannot audit per-key usage. #must-know

Q: SSE-KMS adds what over SSE-S3?
A: KMS-based key with audit trail + key policy control. #must-know

Q: DSSE-KMS is?
A: Dual-layer server-side encryption with KMS (for top-secret / highly regulated data). #must-know

Q: EBS gp3 independent knobs?
A: Size, IOPS, and throughput can be provisioned independently. #must-know

Q: Max IOPS on a single io2 BX volume?
A: 256,000 IOPS. #must-know

Q: Max S3 bucket object count?
A: Unlimited. #must-know
