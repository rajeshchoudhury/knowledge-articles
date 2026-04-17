# AWS Services Comparison Cheat Sheet — SAP-C02

> Quick-reference comparison tables for choosing the right AWS service. Organized by category with "When to Use" guidance for every service.

---

## Table of Contents

1. [Compute Comparisons](#1-compute-comparisons)
2. [Storage Comparisons](#2-storage-comparisons)
3. [Database Comparisons](#3-database-comparisons)
4. [Messaging & Integration Comparisons](#4-messaging--integration-comparisons)
5. [Networking Comparisons](#5-networking-comparisons)
6. [Security Service Comparisons](#6-security-service-comparisons)
7. [Migration Tool Comparisons](#7-migration-tool-comparisons)
8. [Analytics Comparisons](#8-analytics-comparisons)
9. [Container Orchestration Comparisons](#9-container-orchestration-comparisons)
10. [IaC & Deployment Comparisons](#10-iac--deployment-comparisons)

---

## 1. Compute Comparisons

### EC2 vs ECS vs EKS vs Lambda vs Fargate vs Batch

| Feature | EC2 | ECS (EC2) | ECS (Fargate) | EKS | Lambda | AWS Batch |
|---------|-----|-----------|----------------|-----|--------|-----------|
| **Abstraction** | IaaS — full VM | Container orchestration on EC2 | Serverless containers | Managed Kubernetes | FaaS — functions | Managed batch jobs |
| **Unit of work** | Instance | Task/Container | Task/Container | Pod | Function invocation | Job |
| **Max run time** | Unlimited | Unlimited | Unlimited | Unlimited | 15 min | Unlimited |
| **Scaling** | ASG, manual | Service auto-scaling | Service auto-scaling | HPA, Karpenter | Automatic (concurrency) | Managed compute env |
| **Pricing** | Per instance-hour | EC2 pricing + no ECS charge | Per vCPU/GB per second | EC2/Fargate + $0.10/hr/cluster | Per invocation + GB-s | EC2/Fargate pricing |
| **State** | Stateful | Stateful possible | Ephemeral preferred | Stateful possible (EBS CSI) | Stateless (15 min max) | Stateless jobs |
| **Cold start** | Minutes (launch) | Seconds (if capacity) | ~30s–60s | Seconds (if nodes ready) | ms–seconds | Minutes (EC2 launch) |
| **Ops overhead** | High (patching, OS) | Medium (EC2 fleet) | Low | Medium-High (K8s expertise) | Very Low | Low-Medium |
| **GPU support** | Yes | Yes | No | Yes | No | Yes |
| **Max memory** | Up to 24 TB (u-24tb1) | Instance dependent | 120 GB | Instance dependent | 10 GB | Instance dependent |

#### When to Use Each

| Service | Best For |
|---------|----------|
| **EC2** | Full OS control, GPU workloads, stateful apps, license-bound software (BYOL), Windows workloads |
| **ECS (EC2)** | Containerized apps needing GPU, large/specific instance types, or high density per host |
| **ECS (Fargate)** | Containerized apps without managing infrastructure, variable workloads, minimal ops |
| **EKS** | Kubernetes-native workloads, multi-cloud portability, existing K8s expertise, complex microservices |
| **Lambda** | Event-driven, short-duration (<15 min), unpredictable traffic, API backends, data processing |
| **AWS Batch** | Large-scale batch processing, HPC, genomics, rendering, ML training, array/dependent jobs |

---

### EC2 Purchase Options Comparison

| Option | Commitment | Discount | Use Case |
|--------|-----------|----------|----------|
| **On-Demand** | None | 0% | Short-term, unpredictable workloads |
| **Reserved (Standard)** | 1 or 3 year | Up to 72% | Steady-state workloads |
| **Reserved (Convertible)** | 1 or 3 year | Up to 66% | Steady-state, may change instance family |
| **Savings Plans (Compute)** | 1 or 3 year $/hr | Up to 66% | Flexible across EC2, Fargate, Lambda |
| **Savings Plans (EC2 Instance)** | 1 or 3 year $/hr | Up to 72% | Committed to instance family in region |
| **Spot** | None (can be interrupted) | Up to 90% | Fault-tolerant, flexible workloads |
| **Dedicated Host** | On-Demand or Reserved | Varies | BYOL, compliance, socket/core licensing |
| **Dedicated Instance** | Per-instance premium | Varies | Compliance — hardware not shared with others |
| **Capacity Reservation** | None (pay regardless) | 0% (On-Demand price) | Guaranteed capacity in an AZ |

---

### Lambda vs Step Functions (Standard vs Express)

| Feature | Lambda | Step Functions Standard | Step Functions Express |
|---------|--------|----------------------|---------------------|
| **Max duration** | 15 min | 1 year | 5 min |
| **Execution model** | Single function | State machine (orchestration) | State machine (orchestration) |
| **Pricing** | Per invocation + duration | Per state transition ($0.025/1000) | Per execution + duration |
| **Idempotency** | You manage | Exactly-once execution | At-least-once |
| **Use case** | Individual tasks | Long-running workflows, human approval | High-volume, short workflows |
| **Max payload** | 6 MB (sync), 256 KB (async) | 256 KB per state | 256 KB per state |

---

## 2. Storage Comparisons

### S3 vs EBS vs EFS vs FSx vs Instance Store

| Feature | S3 | EBS | EFS | FSx for Windows | FSx for Lustre | Instance Store |
|---------|-----|-----|-----|-----------------|----------------|----------------|
| **Type** | Object | Block | File (NFS) | File (SMB) | File (POSIX) | Block (ephemeral) |
| **Protocol** | HTTP/S API | Attached to EC2 | NFS v4.1 | SMB, NFS (ONTAP) | POSIX | Direct attached |
| **Durability** | 99.999999999% (11 9s) | 99.8–99.999% | 99.999999999% | — | — | Ephemeral |
| **Availability** | 99.99% (Standard) | 99.999% (io2) | 99.99% (Regional) | Multi-AZ | — | Instance lifetime |
| **Max size** | Unlimited (5 TB/object) | 64 TiB/vol | Petabytes | 64 TiB | Petabytes | Instance-dependent |
| **Access** | Any (via API) | Single AZ (multi-attach io2) | Multi-AZ, cross-region | Multi-AZ | Single AZ (usually) | Single instance |
| **Performance** | 5,500 GET/s per prefix | Up to 256K IOPS (io2 BE) | Elastic throughput | Up to 2 GB/s | 100s of GB/s | Very high IOPS |
| **Encryption** | SSE-S3, SSE-KMS, SSE-C | AES-256 (KMS) | At-rest + transit | At-rest + transit | At-rest + transit | Not at rest |
| **Cost** | $ (cheapest for archive) | $$ | $$$ | $$$ | $$ (scratch) $$$ (persistent) | Free (included) |
| **Shared access** | Yes (via API) | No (except multi-attach) | Yes (NFS) | Yes (SMB) | Yes (POSIX) | No |

#### When to Use Each

| Service | Best For |
|---------|----------|
| **S3** | Object storage, static websites, data lakes, backups, archive, unlimited scale |
| **EBS** | Boot volumes, databases, transactional workloads needing consistent low-latency |
| **EFS** | Shared file storage across multiple EC2/containers, CMS, web serving, ML |
| **FSx for Windows** | Windows workloads, AD integration, SMB protocol, SQL Server, .NET apps |
| **FSx for Lustre** | HPC, ML training, genomics, video rendering, S3-linked compute |
| **FSx for NetApp ONTAP** | Multi-protocol (NFS+SMB+iSCSI), data tiering, SnapMirror replication |
| **FSx for OpenZFS** | Linux workloads needing snapshots, clones, compression, NFS |
| **Instance Store** | Temporary data, buffers, caches, scratch data, highest IOPS |

---

### S3 Storage Classes Comparison

| Storage Class | Availability | Min Duration | Retrieval Fee | First Byte Latency | Use Case |
|--------------|-------------|-------------|---------------|--------------------| ---------|
| **Standard** | 99.99% | None | None | ms | Frequently accessed |
| **Intelligent-Tiering** | 99.9% | None | None | ms (auto-tiered) | Unknown/changing access |
| **Standard-IA** | 99.9% | 30 days | Per GB | ms | Infrequently accessed, rapid access |
| **One Zone-IA** | 99.5% | 30 days | Per GB | ms | Re-creatable infrequent data |
| **Glacier Instant Retrieval** | 99.9% | 90 days | Per GB | ms | Archive with instant access |
| **Glacier Flexible Retrieval** | 99.99% | 90 days | Per GB | min–hrs | Archive, flexible retrieval |
| **Glacier Deep Archive** | 99.99% | 180 days | Per GB | 12–48 hrs | Long-term archive, compliance |

---

### Storage Gateway Modes

| Mode | Protocol | Backend | Cache | Use Case |
|------|----------|---------|-------|----------|
| **S3 File Gateway** | NFS/SMB | S3 | Local cache | Cloud-backed file shares, data lake ingestion |
| **FSx File Gateway** | SMB | FSx for Windows | Local cache | Low-latency access to FSx from on-prem |
| **Volume Gateway (Cached)** | iSCSI | S3 | Local cache | Primary data in cloud, frequently accessed cached locally |
| **Volume Gateway (Stored)** | iSCSI | S3 (async backup) | Full dataset local | Primary data on-prem, async backup to S3 |
| **Tape Gateway** | iSCSI VTL | S3 Glacier/Deep Archive | Local cache | Tape backup replacement |

---

## 3. Database Comparisons

### Relational Databases: RDS vs Aurora

| Feature | RDS | Aurora |
|---------|-----|--------|
| **Engines** | MySQL, PostgreSQL, MariaDB, Oracle, SQL Server | MySQL-compatible, PostgreSQL-compatible |
| **Storage** | EBS (gp3, io1) | Shared cluster storage (auto-grows to 128 TiB) |
| **Replication** | Synchronous standby (Multi-AZ), async read replicas | 6 copies across 3 AZs, up to 15 read replicas |
| **Failover time** | 60–120s | ~30s (fast failover) |
| **Read replicas** | Up to 15 (5 for Oracle/SQL Server) | Up to 15 (same storage, zero replication lag) |
| **Serverless** | No | Aurora Serverless v2 (instant scaling) |
| **Global** | Cross-region read replicas | Aurora Global Database (<1s replication) |
| **Backtrack** | No | Yes (rewind to point in time without restore) |
| **Performance** | Standard | Up to 5x MySQL, 3x PostgreSQL |
| **Cost** | Lower entry point | 20–30% more than RDS, but better value at scale |
| **Blue/Green** | Yes | Yes |
| **Parallel Query** | No | Yes (for OLTP+OLAP hybrid) |

#### When to Use RDS vs Aurora

| Scenario | Choose |
|----------|--------|
| Oracle or SQL Server needed | **RDS** |
| Minimal cost, small workload | **RDS** |
| High availability, fast failover | **Aurora** |
| Variable/unpredictable workload | **Aurora Serverless v2** |
| Global presence, <1s cross-region replication | **Aurora Global Database** |
| >5 read replicas needed | **Aurora** |
| Need backtrack (undo) | **Aurora** |

---

### Full Database Comparison

| Database | Type | Max Size | Scaling | Latency | Transactions | Best For |
|----------|------|----------|---------|---------|-------------|---------|
| **RDS** | Relational | 64 TiB | Vertical + read replicas | ms | ACID | Traditional RDBMS, Oracle/SQL Server |
| **Aurora** | Relational | 128 TiB | Vertical + 15 replicas + Serverless v2 | ms | ACID | High-perf relational, global apps |
| **DynamoDB** | Key-value/Document | Unlimited | Horizontal (automatic) | Single-digit ms | ACID (25 items) | Serverless apps, gaming, IoT, scale-out |
| **Redshift** | Columnar/OLAP | Petabytes | RA3 nodes, Serverless | Seconds | Serializable | Data warehousing, analytics, BI |
| **ElastiCache Redis** | In-memory K/V | 500 nodes × 6.1 TB | Cluster mode, sharding | Sub-ms | Lua scripts | Caching, session store, leaderboards, pub/sub |
| **ElastiCache Memcached** | In-memory K/V | 20 nodes × 300+ GB | Horizontal | Sub-ms | None | Simple caching, no persistence needed |
| **Neptune** | Graph | 64 TiB | Read replicas | ms | ACID | Social networks, knowledge graphs, fraud detection |
| **DocumentDB** | Document (MongoDB) | 128 TiB | Up to 15 replicas | ms | ACID | MongoDB-compatible workloads |
| **Keyspaces** | Wide-column (Cassandra) | Unlimited | Serverless (automatic) | Single-digit ms | Lightweight | Cassandra-compatible, IoT, time-series |
| **QLDB** | Ledger | — | Serverless | ms | ACID | Immutable audit, supply chain, financial ledger |
| **Timestream** | Time-series | — | Serverless | ms | — | IoT metrics, DevOps monitoring, time-series analytics |
| **MemoryDB** | Durable in-memory | — | Cluster (sharding) | Sub-ms reads, single-digit ms writes | — | Redis-compatible durable primary database |

---

### ElastiCache: Redis vs Memcached

| Feature | Redis | Memcached |
|---------|-------|-----------|
| **Data structures** | Strings, lists, sets, sorted sets, hashes, streams, geospatial | Simple key-value strings |
| **Persistence** | RDB snapshots + AOF | None |
| **Replication** | Multi-AZ with auto-failover | None |
| **Cluster mode** | Yes (data sharding) | Yes (auto-discovery) |
| **Pub/Sub** | Yes | No |
| **Lua scripting** | Yes | No |
| **Transactions** | MULTI/EXEC | No |
| **Backup/Restore** | Yes | No |
| **Encryption** | At-rest + in-transit | At-rest + in-transit |
| **Global Datastore** | Yes (cross-region) | No |
| **Max nodes** | 500 per cluster | 40 per cluster |
| **Use case** | Complex caching, sessions, leaderboards, rate limiting, queues | Simple caching, session store (disposable) |

**Rule of thumb:** If you need persistence, replication, complex data types, or pub/sub → **Redis**. If you need the simplest possible multi-threaded cache → **Memcached**.

---

## 4. Messaging & Integration Comparisons

### SQS vs SNS vs EventBridge vs Kinesis vs MQ vs MSK

| Feature | SQS | SNS | EventBridge | Kinesis Data Streams | Amazon MQ | Amazon MSK |
|---------|-----|-----|-------------|---------------------|-----------|------------|
| **Pattern** | Queue (point-to-point) | Pub/Sub (fan-out) | Event bus (event-driven) | Stream (ordered) | Message broker | Managed Kafka |
| **Ordering** | FIFO: yes, Standard: best-effort | FIFO topics: yes | Per event bus | Per shard (partition key) | Yes (per queue) | Per partition |
| **Delivery** | At-least-once (Standard), exactly-once (FIFO) | At-least-once | At-least-once | At-least-once (exactly-once with KCL) | Depends on protocol | At-least-once (exactly-once producer) |
| **Retention** | 1 min–14 days (default 4 days) | No retention (immediate delivery) | 24h replay (archive for longer) | 1–365 days | Depends on config | 1–365 days (unlimited tiered) |
| **Throughput** | Nearly unlimited (Standard), 3000 msg/s (FIFO w/ batching) | ~30M messages/s | 400 puts/s default (raise to millions) | Unlimited shards (1 MB/s per shard in, 2 MB/s out) | Dependent on broker | Unlimited partitions |
| **Max message** | 256 KB (2 GB with S3 extended client) | 256 KB | 256 KB | 1 MB per record | Varies by protocol | 1 MB default (configurable) |
| **Consumer model** | Pull (long/short polling) | Push (HTTP, Lambda, SQS, etc.) | Push (targets: Lambda, SQS, Step Functions, etc.) | Pull (KCL, Lambda) | Pull (AMQP, MQTT, STOMP, etc.) | Pull (consumer groups) |
| **Serverless** | Yes | Yes | Yes | Yes (on-demand mode) | No (broker instances) | Serverless option available |
| **Replay** | No (once processed) | No | Archive + replay | Yes (per shard iterator) | No | Yes (consumer offset) |
| **Schema** | None | None | Schema Registry built-in | None | None | Schema Registry available |
| **Pricing** | Per request | Per publish + delivery | Per event | Per shard-hour + per PUT | Per broker instance-hour | Per broker + storage |

#### When to Use Each

| Service | Best For |
|---------|----------|
| **SQS** | Decoupling microservices, work queues, buffering requests, dead-letter handling |
| **SNS** | Fan-out to multiple subscribers, mobile push, email/SMS notifications |
| **EventBridge** | Event-driven architectures, SaaS integration, cross-account events, schema discovery, rule-based routing |
| **Kinesis Data Streams** | Real-time streaming, log/event aggregation, analytics, ordered processing, replay |
| **Amazon MQ** | Migrating from on-prem message brokers (ActiveMQ/RabbitMQ), protocols like AMQP, MQTT, STOMP |
| **Amazon MSK** | Migrating from Apache Kafka, streaming with Kafka ecosystem, existing Kafka expertise |

---

### SQS Standard vs FIFO

| Feature | Standard | FIFO |
|---------|----------|------|
| **Throughput** | Nearly unlimited | 3,000 msg/s (w/ batching), 300 without |
| **Ordering** | Best-effort | Strict FIFO per message group |
| **Delivery** | At-least-once | Exactly-once processing |
| **Deduplication** | None | 5-minute deduplication (content-based or ID) |
| **Queue name** | Any | Must end in `.fifo` |
| **Cost** | Lower | Higher |
| **Use case** | High throughput, order not critical | Financial transactions, command ordering |

---

### Kinesis Data Streams vs Kinesis Data Firehose

| Feature | Kinesis Data Streams | Kinesis Data Firehose |
|---------|---------------------|----------------------|
| **Real-time** | Yes (200ms with enhanced fan-out) | Near real-time (60s buffer min) |
| **Custom consumers** | Yes (KCL, Lambda, SDK) | No (delivers to destinations) |
| **Destinations** | Custom | S3, Redshift, OpenSearch, Splunk, HTTP |
| **Data transformation** | You build | Built-in Lambda transforms |
| **Scaling** | Manual (add shards) or on-demand | Automatic |
| **Retention** | 1–365 days | No retention (delivery only) |
| **Replay** | Yes | No |
| **Use case** | Custom real-time processing, multiple consumers | ETL to S3/Redshift/OpenSearch, log delivery |

---

## 5. Networking Comparisons

### ALB vs NLB vs GWLB

| Feature | ALB | NLB | GWLB |
|---------|-----|-----|------|
| **Layer** | 7 (HTTP/HTTPS) | 4 (TCP/UDP/TLS) | 3 (IP packets) |
| **Protocols** | HTTP, HTTPS, gRPC, WebSocket | TCP, UDP, TLS | IP (GENEVE encapsulation) |
| **Performance** | Good | Ultra-high (millions rps, ultra-low latency) | High |
| **Static IP** | No (use Global Accelerator) | Yes (1 per AZ, or Elastic IP) | No |
| **SSL termination** | Yes | Yes (TLS) | No |
| **Path/host routing** | Yes | No | No |
| **Sticky sessions** | Yes (cookie-based) | Yes (source IP) | Yes (flow-based) |
| **Health checks** | HTTP, HTTPS, gRPC | TCP, HTTP, HTTPS | HTTP, HTTPS, TCP |
| **Targets** | EC2, IP, Lambda, ALB | EC2, IP, ALB | EC2, IP (appliances) |
| **Cross-zone LB** | Default on | Default off | Default off |
| **Pricing** | Per LCU-hour | Per NLCU-hour | Per GWLCU-hour |
| **Use case** | Web apps, microservices, content routing | TCP/UDP, extreme performance, static IPs, PrivateLink | 3rd party security appliances (firewalls, IDS/IPS) |

---

### Direct Connect vs VPN

| Feature | Direct Connect | Site-to-Site VPN |
|---------|---------------|-----------------|
| **Connection** | Dedicated fiber (physical) | IPsec over public internet |
| **Bandwidth** | 1 Gbps, 10 Gbps, 100 Gbps (dedicated); 50 Mbps–10 Gbps (hosted) | Up to 1.25 Gbps per tunnel |
| **Latency** | Consistent, low | Variable (internet-dependent) |
| **Encryption** | Not by default (add MACsec or VPN overlay) | IPsec encrypted |
| **Setup time** | Weeks–months | Minutes–hours |
| **Redundancy** | Requires 2 connections (ideally at different DX locations) | 2 tunnels per VPN connection (active-passive or active-active) |
| **Cost** | Port-hour + data transfer (no internet DTO for private VIF) | Per VPN connection-hour + data transfer |
| **Use case** | High throughput, consistent latency, large data transfer, hybrid production workloads | Quick setup, backup for DX, lower bandwidth needs, encrypted connectivity |

**Common pattern:** Direct Connect (primary) + VPN (backup) for resilient hybrid connectivity.

---

### Transit Gateway vs VPC Peering vs PrivateLink

| Feature | Transit Gateway | VPC Peering | PrivateLink |
|---------|----------------|------------|-------------|
| **Topology** | Hub-and-spoke (any-to-any) | Point-to-point (mesh) | Service endpoint (consumer→provider) |
| **Transitive routing** | Yes | No | N/A (unidirectional) |
| **Cross-region** | Yes (inter-region peering) | Yes | Yes |
| **Cross-account** | Yes | Yes | Yes |
| **Bandwidth** | 50 Gbps per AZ attachment | No limit (instance bandwidth) | Interface endpoint bandwidth |
| **IP overlap** | Can handle (with route tables) | Cannot overlap CIDRs | No CIDR requirement (uses ENI) |
| **Complexity** | Medium (route tables, associations) | Low | Low |
| **Cost** | Per attachment-hour + per GB | Per GB | Per endpoint-hour + per GB |
| **Scalability** | Up to 5,000 attachments | 125 per VPC (soft limit) | Highly scalable |
| **Use case** | 10+ VPCs, on-prem connectivity hub, shared services | Few VPCs, simple connections | Exposing a service to consumers securely |

---

### VPC Endpoints: Gateway vs Interface

| Feature | Gateway Endpoint | Interface Endpoint |
|---------|-----------------|-------------------|
| **Services** | S3 and DynamoDB only | 100+ AWS services |
| **Mechanism** | Route table entry | ENI with private IP in your subnet |
| **Cost** | Free | Per hour + per GB |
| **Security** | Endpoint policy | Endpoint policy + Security Groups |
| **DNS** | Prefix list in route table | Private DNS (optional) |
| **Cross-region** | No | No (same region) |
| **PrivateLink** | No | Yes (powered by PrivateLink) |

---

## 6. Security Service Comparisons

### GuardDuty vs Inspector vs Macie vs Detective vs Security Hub

| Service | What It Does | Data Sources | Output |
|---------|-------------|-------------|--------|
| **GuardDuty** | Threat detection (ML-based) | VPC Flow Logs, DNS Logs, CloudTrail, S3 data events, EKS audit logs, RDS login, Lambda network, runtime monitoring | Findings (low/medium/high severity) |
| **Inspector** | Vulnerability assessment | EC2 (SSM agent), ECR images, Lambda functions | Findings (CVE-based, network reachability) |
| **Macie** | Sensitive data discovery | S3 buckets | Findings (PII, PHI, credentials in S3) |
| **Detective** | Investigation & root cause analysis | GuardDuty findings, VPC Flow Logs, CloudTrail | Visualizations, entity profiles, behavior graphs |
| **Security Hub** | Centralized security posture | GuardDuty, Inspector, Macie, Firewall Manager, IAM Access Analyzer, Config, 3rd party | Aggregated findings, compliance scores (CIS, PCI DSS, NIST) |

#### Flow: GuardDuty (detect) → Security Hub (aggregate) → Detective (investigate)

---

### Secrets Manager vs Systems Manager Parameter Store

| Feature | Secrets Manager | Parameter Store |
|---------|----------------|-----------------|
| **Purpose** | Secrets management (credentials, API keys) | Configuration + secrets |
| **Rotation** | Built-in auto-rotation (Lambda) | Manual (no built-in rotation) |
| **Encryption** | Always encrypted (KMS) | Optional (SecureString uses KMS) |
| **Versioning** | Yes (automatic) | Yes |
| **Cost** | $0.40/secret/month + $0.05/10K API calls | Free (Standard), $0.05/advanced param/month |
| **Max size** | 64 KB | 4 KB (Standard), 8 KB (Advanced) |
| **Cross-account** | Yes (resource-based policy) | No (must use IAM role assumption) |
| **CloudFormation** | Dynamic reference | Dynamic reference |
| **Hierarchy** | Flat | Hierarchical paths (/app/db/password) |
| **Use case** | Database credentials, API keys, auto-rotation needed | Application config, feature flags, non-rotating secrets |

**Rule of thumb:** Need rotation? → **Secrets Manager**. Config values or budget-conscious? → **Parameter Store**.

---

### KMS vs CloudHSM vs ACM

| Feature | KMS | CloudHSM | ACM |
|---------|-----|----------|-----|
| **Purpose** | Key management & encryption | Dedicated HSM hardware | SSL/TLS certificate management |
| **Key control** | AWS or customer managed | Customer exclusive control | AWS managed |
| **FIPS 140-2** | Level 3 (some operations) | Level 3 (dedicated) | N/A |
| **Multi-tenant** | Yes (shared infrastructure) | No (dedicated HSM) | N/A |
| **Pricing** | $1/key/month + per request | ~$1.50/HSM/hour | Free (public certs) |
| **Integration** | 100+ AWS services | KMS custom key store, SSL offload, Oracle TDE | CloudFront, ALB, API Gateway, NLB |
| **Use case** | Standard encryption across AWS | Regulatory requirements for dedicated HSM, custom crypto operations | Free SSL/TLS for AWS services |

---

### WAF vs Shield vs Network Firewall vs Firewall Manager

| Feature | WAF | Shield Standard | Shield Advanced | Network Firewall | Firewall Manager |
|---------|-----|----------------|-----------------|-----------------|-----------------|
| **Protection** | Layer 7 (HTTP/S rules) | Layer 3/4 DDoS (basic) | Layer 3/4/7 DDoS (advanced) | Layer 3–7 (VPC level) | Policy management across accounts |
| **Scope** | CloudFront, ALB, API GW, AppSync, Cognito | All AWS resources (auto) | EC2, ELB, CloudFront, Global Accelerator, Route 53 | VPC subnets | Organization-wide |
| **Cost** | Per rule + per request | Free | $3,000/month + DTO protection | Per endpoint-hour + per GB | Per policy per region |
| **Features** | Rate limiting, geo blocking, IP sets, managed rules, Bot Control | Always-on detection | DRT access, cost protection, health-based detection, WAF included | Stateful/stateless rules, IPS, domain filtering, TLS inspection | Centralized WAF, Shield, SG, NF, Route 53 Firewall |
| **Use case** | SQL injection, XSS, bot protection | Basic DDoS (automatic) | High-value targets, DDoS cost protection | VPC-level traffic filtering, deep packet inspection | Multi-account security policy management |

---

## 7. Migration Tool Comparisons

### Migration Tool Matrix

| Tool | What It Migrates | Method | Downtime |
|------|-----------------|--------|----------|
| **Application Migration Service (MGN)** | Servers (VMs, physical) | Continuous block-level replication | Minutes (cutover) |
| **Database Migration Service (DMS)** | Databases | Continuous data replication | Minutes (cutover) |
| **Schema Conversion Tool (SCT)** | Database schemas | Schema analysis & conversion | Offline (schema prep) |
| **DataSync** | Files/objects (NFS, SMB, S3, HDFS) | Agent-based scheduled transfer | N/A (file sync) |
| **Transfer Family** | Files via SFTP/FTPS/FTP/AS2 | Protocol-level transfer to S3/EFS | N/A |
| **Snow Family** | Large datasets (offline) | Physical device shipment | Days (shipment) |
| **Migration Hub** | Tracking/orchestration | Central dashboard | N/A |
| **Application Discovery Service** | Discovery/assessment | Agent or agentless scan | N/A |
| **Migration Evaluator** | TCO analysis | Data collection | N/A |

### When to Use Each Migration Tool

| Scenario | Tool |
|----------|------|
| Migrate VMware VMs to EC2 | **MGN** |
| Migrate Oracle DB to Aurora | **DMS + SCT** |
| Migrate file shares to S3/EFS | **DataSync** |
| Transfer 100 TB offline | **Snowball Edge** |
| Transfer 100 PB offline | **Snowmobile** |
| Ongoing SFTP to S3 | **Transfer Family** |
| Track migration progress | **Migration Hub** |
| Discover on-prem dependencies | **Application Discovery Service** |
| Estimate cloud costs | **Migration Evaluator** |

---

### Data Transfer Time Estimates

| Data Size | 100 Mbps | 1 Gbps | 10 Gbps | Snowball Edge (80 TB) |
|-----------|----------|--------|---------|----------------------|
| 1 TB | ~1 day | ~2.5 hrs | ~15 min | Overkill |
| 10 TB | ~10 days | ~1 day | ~2.5 hrs | Consider Snowball |
| 100 TB | ~100 days | ~10 days | ~1 day | 2 Snowball devices |
| 1 PB | ~3 years | ~100 days | ~10 days | 13 Snowball devices |

**Rule of thumb:** If network transfer takes > 1 week, consider Snow Family.

---

## 8. Analytics Comparisons

### Athena vs Redshift vs EMR vs Glue

| Feature | Athena | Redshift | EMR | Glue |
|---------|--------|----------|-----|------|
| **Type** | Serverless SQL query | Data warehouse | Managed Hadoop/Spark | Serverless ETL |
| **Engine** | Presto/Trino | PostgreSQL-based (Redshift) | Hadoop, Spark, Hive, Presto | Spark (PySpark, Scala) |
| **Data location** | S3 (query in place) | Redshift storage + Spectrum (S3) | S3, HDFS | S3 (source/target) |
| **Pricing** | $5/TB scanned | Per node-hour or Serverless RPU | Per instance-hour | Per DPU-hour |
| **Best for** | Ad-hoc queries, quick analysis | Complex analytics, BI dashboards | Big data processing, ML | ETL pipelines, data catalog |
| **Performance** | Good for ad-hoc | Best for repeated complex queries | Best for large-scale processing | Good for ETL workloads |
| **Optimization** | Columnar formats (Parquet), partitioning | Distribution keys, sort keys, Spectrum | Cluster tuning | Job bookmarks, partitioning |

---

### OpenSearch vs CloudWatch Logs Insights vs Athena (for log analysis)

| Feature | OpenSearch | CloudWatch Logs Insights | Athena |
|---------|-----------|------------------------|--------|
| **Real-time** | Near real-time | Near real-time | Batch (S3) |
| **Visualization** | Dashboards (built-in) | Basic | Use QuickSight |
| **Full-text search** | Yes (Elasticsearch) | Yes (query language) | Limited |
| **Cost** | Instance-based | Per query scanned | Per TB scanned |
| **Best for** | Log analytics, SIEM, full-text search | Quick log queries, alerting | Ad-hoc S3 log analysis |
| **Retention** | Custom | 1 day–forever | S3 lifecycle |

---

## 9. Container Orchestration Comparisons

### ECS vs EKS — Deep Comparison

| Feature | ECS | EKS |
|---------|-----|-----|
| **Orchestrator** | AWS proprietary | Kubernetes (CNCF) |
| **Portability** | AWS-only | Multi-cloud, on-prem (EKS Anywhere) |
| **Learning curve** | Lower | Higher (Kubernetes expertise) |
| **Control plane cost** | Free | $0.10/hr (~$72/month) |
| **Service mesh** | AWS App Mesh or Cloud Map | Istio, Linkerd, App Mesh |
| **Auto-scaling** | ECS Service Auto Scaling | HPA, VPA, Karpenter, Cluster Autoscaler |
| **Networking** | awsvpc, bridge, host | VPC CNI plugin (pod = ENI IP) |
| **Logging** | CloudWatch, FireLens | CloudWatch, Fluent Bit, Prometheus |
| **CI/CD** | CodeDeploy, CodePipeline | ArgoCD, Flux, CodePipeline |
| **Windows** | Yes | Yes |
| **Use case** | Simple container workloads, AWS-native | K8s ecosystem, multi-cloud, complex microservices |

---

## 10. IaC & Deployment Comparisons

### CloudFormation vs CDK vs SAM vs Terraform

| Feature | CloudFormation | CDK | SAM | Terraform |
|---------|---------------|-----|-----|-----------|
| **Language** | YAML/JSON | TypeScript, Python, Java, C#, Go | YAML (extension of CFN) | HCL |
| **Scope** | AWS only | AWS only (generates CFN) | Serverless on AWS | Multi-cloud |
| **State** | Managed by AWS (stack) | Managed by AWS (via CFN) | Managed by AWS (via CFN) | State file (S3/Terraform Cloud) |
| **Abstraction** | Low (resource-level) | High (constructs, patterns) | Medium (serverless-focused) | Medium |
| **Drift detection** | Yes | Yes (via CFN) | No | `terraform plan` |
| **Use case** | AWS-native IaC, enterprise standard | Developers who prefer code, complex patterns | Serverless applications (Lambda, API GW, DynamoDB) | Multi-cloud, existing Terraform skills |

---

### Deployment Strategies Comparison

| Strategy | Downtime | Rollback Speed | Risk | Cost | Use Case |
|----------|----------|---------------|------|------|----------|
| **All-at-once** | Yes | Redeploy | High | Low | Dev/test |
| **Rolling** | Minimal | Slow (re-roll) | Medium | Low | Simple apps |
| **Rolling with extra batch** | No | Slow | Medium | Medium | Maintaining capacity |
| **Immutable** | No | Fast (terminate new) | Low | High (double capacity) | Production |
| **Blue/Green** | No | Very fast (switch) | Low | High (double capacity) | Critical production |
| **Canary** | No | Fast (route back) | Very low | Medium | Gradual validation |
| **Linear** | No | Medium | Low | Medium | Gradual rollout |

---

## Quick Decision Frameworks

### "I need a database for..."

```
Relational data + SQL?
├── Need Oracle/SQL Server? → RDS
├── Need MySQL/PostgreSQL with high availability? → Aurora
├── Variable/unpredictable load? → Aurora Serverless v2
└── Cross-region <1s replication? → Aurora Global Database

Key-value or document data?
├── Need serverless + scale? → DynamoDB
├── Need MongoDB compatibility? → DocumentDB
└── Need Cassandra compatibility? → Keyspaces

Graph data? → Neptune
Time-series data? → Timestream
Immutable ledger? → QLDB
Data warehouse (OLAP)? → Redshift
Caching layer? → ElastiCache Redis
Durable in-memory database? → MemoryDB
```

### "I need to transfer data..."

```
How much data?
├── < 10 TB + fast network → DataSync or DMS
├── 10–80 TB → Snowball Edge
├── 80 TB–10 PB → Multiple Snowball Edge
├── > 10 PB → Snowmobile
└── Ongoing sync? → DataSync (scheduled) or DMS (continuous)

What protocol?
├── NFS/SMB shares → DataSync or Storage Gateway
├── SFTP/FTPS → Transfer Family
├── Database → DMS
└── S3 to S3 → S3 Replication
```

### "I need compute for..."

```
Long-running, stateful, GPU? → EC2
Containers, AWS-native? → ECS
Containers, K8s/portable? → EKS
Containers, no infra management? → Fargate
Short-duration, event-driven? → Lambda
Batch processing, HPC? → AWS Batch
```
