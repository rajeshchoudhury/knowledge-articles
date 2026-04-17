# Domain 3 — Cloud Technology and Services (34%)

> **Domain weight:** 34% — the largest domain by weight (~**17 of 50 scored
> questions**). This is a breadth domain: the exam expects you to recognize
> what each service does and, crucially, **when to use it vs an alternative**.
> The goal here is not to master every knob — it's to build an accurate
> mental map of the service catalog.
>
> **Task statements in CLF-C02:**
> 3.1 Define methods of deploying and operating in the AWS Cloud.
> 3.2 Define the AWS global infrastructure.
> 3.3 Identify AWS compute services.
> 3.4 Identify AWS database services.
> 3.5 Identify AWS network services.
> 3.6 Identify AWS storage services.
> 3.7 Identify AWS services for artificial intelligence (AI), machine
>     learning (ML), data analytics, IoT, and other categories.

The article is organized category-by-category. For each, we explain the
fundamentals, enumerate the services, and end with a **selection rule**
that tells you when to pick which.

---

## 1. Ways to interact with AWS

Before services, you must know the **operational surfaces**:

| Surface | Use |
|---|---|
| **AWS Management Console** | Browser GUI. Good for learning, rare changes. |
| **AWS CLI** (v2) | Scriptable command line. Canonical for ops tasks. |
| **AWS SDKs** | Boto3 (Python), aws-sdk-js (Node), Java, .NET, Go, PHP, Ruby, Swift, Kotlin, C++, Rust. Used from app code. |
| **AWS CloudShell** | Pre-authenticated, browser-based shell (free). |
| **AWS Tools for PowerShell** | Windows ops. |
| **Infrastructure as Code** | CloudFormation (native), AWS CDK (TS/Python/etc. compiles to CFN), SAM (serverless subset of CFN), Terraform (HCL), Pulumi, Ansible. |
| **AWS App Composer / Application Composer** | Visual builder for serverless CFN/SAM. |
| **AWS Cloud Control API** | Unified CRUDL for resources across AWS services. |

### 1.1 Deployment/operation models

- **Managed services** (S3, DynamoDB, RDS, Lambda, SQS, SNS, etc.) — AWS
  handles patching, scaling, availability. You pay; you use; you don't
  rack/cool.
- **Self-managed on EC2** — install your own software on EC2 and operate it.
- **Serverless** — you upload code or define events; AWS runs it on
  invisible fleets. Scale to zero. Examples: **Lambda, Fargate, S3,
  DynamoDB, API Gateway, Step Functions, SQS, SNS, EventBridge, Aurora
  Serverless v2, Redshift Serverless, OpenSearch Serverless**.
- **Container-based** — ECS, EKS, ECR, App Runner, Fargate.
- **Hybrid** — Outposts, Snowball Edge, Local Zones, Wavelength, Storage
  Gateway, DMS, VPN, Direct Connect.

---

## 2. Global infrastructure refresher (tested)

- **Region** ≥ 3 AZs, fault-isolated, data stays here by default.
- **Availability Zone** ≥ 1 data center; independent power/network within
  an AZ.
- **Edge Locations** / **Regional Edge Caches** serve CloudFront, Route 53,
  Global Accelerator.
- **Local Zones** — metro edges for <10 ms latency.
- **Wavelength Zones** — inside 5G telco networks.
- **Outposts** — AWS racks in your DC.
- **Dedicated Local Zones** / **Dedicated AWS Regions** — for government /
  sovereign customers.

### 2.1 Service "scope" types (often tested)

| Scope | Examples |
|---|---|
| **Global** | IAM, Route 53, CloudFront, WAF (rules at CF), Shield, Organizations, Artifact, Service Catalog (optional) |
| **Regional** | EC2, RDS, Lambda, DynamoDB, VPC, S3 (bucket is regional, namespace global), KMS keys, Redshift |
| **AZ-scoped** | EC2 instances, EBS volumes, RDS DB instances (single-AZ), ASG (spans AZs within a Region) |

▶ **Gotcha — S3:** Bucket names are **globally unique**, but the bucket
itself lives in exactly **one Region**. S3 is still classified as a Regional
service.

---

## 3. Compute services

### 3.1 Amazon EC2

Virtual servers. The most-used AWS compute service and the most-tested.

**Key concepts**
- **AMI (Amazon Machine Image)** — template for boot volume.
- **Instance types** — Families, sizes, generations. Families:
  - `t` — burstable, general workloads (t2, t3, t4g).
  - `m` — general purpose (balanced CPU/memory).
  - `c` — compute optimized (c5, c6i, c7g, c7gn).
  - `r` — memory optimized (r5, r6i, r7i, r7g).
  - `x` / `u` — extreme memory (SAP HANA).
  - `i` / `d` / `h` — storage optimized (NVMe SSD, HDD, dense storage).
  - `p` / `g` / `dl` / `trn` / `inf` — GPU / ML / Trainium / Inferentia.
  - `a` — AMD EPYC.
  - `g*`/`*g` suffix — **Graviton** (AWS Arm).
- **Purchasing options** — On-Demand, Reserved Instances (Standard /
  Convertible), Savings Plans, Spot, Dedicated Hosts, Dedicated Instances,
  Capacity Reservations.
- **User data** — script run on first boot (cloud-init on Linux).
- **Metadata service (IMDSv2)** — retrieves instance info from within.

### 3.2 Amazon EC2 Auto Scaling

Maintains a **desired capacity** across AZs. Scales on metrics or schedules.
- **Scaling policies** — simple, step, target tracking, predictive.
- **Launch templates** vs launch configurations (legacy).
- **Lifecycle hooks** — customize launch/terminate.
- **Warm pools** — pre-initialized instances ready to serve.

### 3.3 Elastic Load Balancing (ELB)

| Type | OSI | Protocols | Typical use |
|---|---|---|---|
| **Application LB (ALB)** | L7 | HTTP/HTTPS/gRPC/WS | Microservices, path/host routing |
| **Network LB (NLB)** | L4 | TCP/UDP/TLS | Ultra-low-latency, static IPs, extreme throughput |
| **Gateway LB (GWLB)** | L3 (GENEVE) | Transparent NVA insertion | Firewall/IDS/IPS insertion |
| **Classic LB (CLB)** | L4/L7 | HTTP/TCP | Legacy; avoid for new designs |

All ELBs integrate with ACM for TLS, with WAF (ALB only), and with Auto
Scaling.

### 3.4 Serverless compute

- **AWS Lambda** — event-driven functions, up to 15 min timeout, 10 GB
  memory, ephemeral `/tmp` up to 10 GB, EFS / container image support,
  concurrency controls, Provisioned Concurrency for warm starts.
  Supported runtimes: Node, Python, Java, Go, Ruby, .NET, custom via
  runtime API.
- **AWS Fargate** — serverless containers. Works under **ECS** and **EKS**.
  No servers to manage.
- **AWS Batch** — orchestrates batch jobs across EC2 / Fargate / Spot.
- **AWS App Runner** — fully managed web apps/APIs from source or container;
  auto-scales to zero; easiest path to host a Dockerfile without config.

### 3.5 Containers

- **Amazon ECR** — private/public container registry.
- **Amazon ECS** — AWS-native orchestrator; simpler than K8s. Runs on EC2
  launch type (you manage nodes) or Fargate launch type (serverless).
- **Amazon EKS** — managed Kubernetes control plane. Works with EC2,
  Fargate, or Outposts.
- **ECS Anywhere / EKS Anywhere** — on-prem variants.

### 3.6 Platform services

- **Elastic Beanstalk** — upload code (Java/Node/Python/Ruby/Go/.NET/PHP/
  Docker) and AWS handles capacity, ELB, ASG, deployments, monitoring.
  Think: "PaaS on top of EC2/ASG/ELB." You can SSH into the boxes.
- **AWS Lightsail** — simple VPS + managed DB + CDN + containers at flat
  monthly pricing. Friendly to devs learning AWS or hosting small sites.
- **AWS Wavelength**, **AWS Local Zones**, **AWS Outposts** — compute at
  edge / on-prem.
- **VMware Cloud on AWS** — run your existing vSphere cluster on AWS bare
  metal.

### 3.7 Compute selection rule

```
Do you need an OS to tune, custom kernel, 3rd-party networking?   → EC2
Do you want containers without managing nodes?                     → Fargate (via ECS/EKS)
Do you already run K8s or want OSS portability?                    → EKS
AWS-native orchestration with minimal K8s overhead?                → ECS
Event-driven code, < 15 min runs, simplest ops?                    → Lambda
Long-running web app from source/Dockerfile, zero config?          → App Runner
Full web/app stack with little config, want SSH access?            → Elastic Beanstalk
Simple VPS / flat monthly cost, hobby or SMB site?                 → Lightsail
Batch jobs / HPC with job queues?                                  → AWS Batch
On-prem with AWS APIs?                                             → Outposts
Ultra-low latency to mobile 5G?                                    → Wavelength
Metro-level latency?                                               → Local Zones
```

---

## 4. Storage services

### 4.1 Amazon S3 (Simple Storage Service)

Object storage. Virtually unlimited. 11 nines durability, 4 nines availability.

**Storage classes:**
| Class | Use case | Retrieval | Min duration |
|---|---|---|---|
| **S3 Standard** | Frequent access | Immediate | None |
| **S3 Intelligent-Tiering** | Unknown/changing access | Immediate (hot/infreq tiers) | 30 days (hot tiers); archive tiers optional |
| **S3 Standard-IA** | Infrequent, > 30 days | Immediate | 30 days |
| **S3 One Zone-IA** | Infrequent, non-critical, re-creatable | Immediate | 30 days |
| **S3 Glacier Instant Retrieval** | Rarely accessed, immediate retrieval | Immediate | 90 days |
| **S3 Glacier Flexible Retrieval** (formerly Glacier) | Archive | Minutes–hours | 90 days |
| **S3 Glacier Deep Archive** | Long-term (7–10 yr) archive | 12 hours (std), 48 h (bulk) | 180 days |

**Key features:**
- **Versioning** — keep every version; protects against accidental delete.
- **Lifecycle policies** — tier/expire objects over time.
- **Replication** — **CRR** (cross-region), **SRR** (same-region),
  **Multi-Region Access Points**.
- **Object Lock** — **WORM** (compliance or governance mode) for
  regulatory retention.
- **Event notifications** — trigger Lambda, SQS, SNS, EventBridge.
- **Access control** — bucket policy, IAM, ACLs (legacy), **Block Public
  Access**, Access Points, Access Grants.
- **Security** — SSE-S3 (default), SSE-KMS, SSE-C, DSSE-KMS.
- **S3 Transfer Acceleration** — fast uploads via CloudFront edges.
- **S3 Select / Glacier Select** — server-side SQL on objects.
- **S3 Storage Lens** — org-wide visibility into usage and costs.

### 4.2 Amazon EBS (Elastic Block Store)

Block storage attached to a single EC2 (or multi-attach for io1/io2 across
Nitro EC2 in the same AZ).

| Volume | Class | Notes |
|---|---|---|
| **gp3** | SSD (general purpose) | Default recommendation; configurable IOPS/throughput independent of size |
| **gp2** | SSD | Legacy default; IOPS scales with size |
| **io2 / io2 Block Express** | SSD (provisioned IOPS) | Highest performance & durability; io2 BX for SAP HANA, Oracle |
| **io1** | SSD (provisioned IOPS) | Older than io2 |
| **st1** | HDD (throughput) | Big, sequential workloads (logs, data warehouses) |
| **sc1** | HDD (cold) | Cheapest, infrequently accessed |

EBS volumes are **AZ-bound**. Snapshots are **Region-scoped** in S3 and
copyable across Regions.

### 4.3 Amazon EFS (Elastic File System)

Managed **NFS v4** for Linux. Multi-AZ by default (Standard) or single-AZ
(One Zone) for ~47% cheaper. Pay per GB stored + per GB accessed (in
Standard-IA and archive classes). Scales elastically.

Perf modes: General Purpose, Max I/O. Throughput modes: Bursting,
Provisioned, Elastic.

### 4.4 Amazon FSx

Managed file systems for specialty workloads.

| FSx | Protocol | Use |
|---|---|---|
| **FSx for Windows File Server** | SMB | Windows apps, Active Directory |
| **FSx for Lustre** | Lustre / POSIX | HPC, ML training, media rendering |
| **FSx for NetApp ONTAP** | NFS / SMB / iSCSI | Drop-in replacement for on-prem NetApp (lifts workflows with snapshots, clones, SnapMirror) |
| **FSx for OpenZFS** | NFS | Drop-in ZFS (snapshots, clones, compression) |

### 4.5 AWS Storage Gateway

Hybrid storage appliance running on-prem (VMware/Hyper-V/EC2) with back-end
AWS storage.

| Type | Protocol | Backend |
|---|---|---|
| **S3 File Gateway** | NFS / SMB | S3 (with caching locally) |
| **FSx File Gateway** | SMB | FSx for Windows |
| **Volume Gateway (Cached)** | iSCSI | EBS snapshots; frequently accessed cached locally |
| **Volume Gateway (Stored)** | iSCSI | Full copy on-prem, async to S3/EBS |
| **Tape Gateway** | iSCSI VTL | Glacier / Deep Archive (replaces tape library) |

### 4.6 Snow Family (offline transfer)

| Device | Capacity | Notes |
|---|---|---|
| **Snowcone** | 8 TB HDD / 14 TB SSD | Rugged, battery, DataSync agent |
| **Snowball Edge Storage Optimized** | 80 TB | Has some compute (EC2 + Lambda) |
| **Snowball Edge Compute Optimized** | 42 TB + GPU | More compute for edge processing |
| **Snowmobile** (retiring) | 100 PB / container-on-a-truck | Exabyte-scale DC evacuation |

### 4.7 AWS Backup

Centralized backup orchestrator for EBS, EC2, RDS, Aurora, DynamoDB, EFS,
FSx, Storage Gateway, Neptune, DocumentDB, S3, Redshift, Timestream, VMware,
and SAP HANA on EC2. Provides Backup Plans, Vaults, cross-Region /
cross-account copy, and AWS Backup Audit Manager.

### 4.8 AWS Elastic Disaster Recovery (DRS)

Continuous block-level replication of on-prem or in-cloud servers to a
low-cost staging area in AWS; during a disaster, launch recovered
instances with sub-minute RPO.

### 4.9 AWS DataSync vs Transfer Family

- **DataSync** — agent-based bulk transfer (NFS, SMB, HDFS, object) between
  on-prem/clouds and AWS. Used for ongoing sync or migration.
- **Transfer Family** — managed SFTP/FTPS/FTP/AS2 endpoints **for your
  external partners** to push/pull files to/from S3/EFS.

### 4.10 Storage selection rule

```
Unstructured, HTTP accessible, cheap, any size?     → S3
Archive, rarely accessed, retention compliance?     → S3 Glacier Deep Archive
Block storage for a single EC2?                     → EBS gp3 (default)
Ultra-high IOPS / latency-critical DB?              → io2 / io2 BX
Shared POSIX file system across many Linux EC2?     → EFS
Shared SMB file system for Windows apps + AD?       → FSx for Windows
HPC / ML massive parallel compute?                  → FSx for Lustre
Existing NetApp workloads in lift-and-shift?        → FSx for NetApp ONTAP
Hybrid NFS/SMB with cloud tiering?                  → Storage Gateway (File)
Hybrid block with cloud DR?                         → Storage Gateway (Volume)
Replace tape library?                               → Storage Gateway (Tape)
Tens-of-TB one-time transfer over bad internet?     → Snowball Edge
Petabyte-to-exabyte one-time transfer?              → Snowmobile (retiring) / Snowball cluster
Centralize backup policies across services?         → AWS Backup
Continuous DR replication?                          → Elastic Disaster Recovery
Bulk file migration on demand?                      → DataSync
External partner SFTP/FTPS/AS2?                     → Transfer Family
```

---

## 5. Database services

### 5.1 Amazon RDS (Relational Database Service)

Managed relational DBs with automatic backups, patching, Multi-AZ,
read replicas, and encryption.

Supported engines:
- MySQL
- PostgreSQL
- MariaDB
- Oracle
- Microsoft SQL Server
- Db2 (recent)
- **Amazon Aurora** (MySQL-compatible or PostgreSQL-compatible)

Patterns:
- **Multi-AZ** — synchronous standby in a second AZ for HA.
- **Multi-AZ with two readable standbys** — in three AZs.
- **Read replicas** — async; can be in same Region, cross-Region, or
  cross-account.
- **RDS Proxy** — connection pooling; important for Lambda + RDS.
- **RDS Custom** (Oracle, SQL Server) — shell access to the OS for vendor
  installations.

### 5.2 Amazon Aurora

AWS-designed cloud-native storage layer. Up to 5× MySQL and 3× PostgreSQL
performance. Storage auto-expanded in 10 GB increments up to 128 TB (or
256 TB for Aurora PostgreSQL recent versions). 6 copies across 3 AZs.
- **Aurora Serverless v2** — fine-grained autoscaling, near-instant.
- **Aurora Global Database** — primary Region + up to 5 secondaries;
  sub-second replication; 1-minute RPO; Region failover < 1 minute.

### 5.3 Amazon DynamoDB

Fully managed, serverless NoSQL **key-value + document** DB. Single-digit
millisecond latency at any scale. Capacity modes:
- **On-Demand** — pay per request, handles spikes.
- **Provisioned** — RCU/WCU; cheaper at steady state, supports auto scaling.

Features:
- **Global Tables** — multi-active, multi-Region.
- **Streams** + Lambda triggers.
- **Point-in-Time Recovery (PITR)** — 35 days.
- **TTL** — auto-delete expired items.
- **DynamoDB Accelerator (DAX)** — in-memory cache (µs reads).

### 5.4 Amazon ElastiCache

In-memory cache. Two engines:
- **Redis / Valkey** — advanced data structures, replication, persistence,
  geospatial, HA.
- **Memcached** — simple, multi-threaded, no replication or persistence.

### 5.5 Amazon MemoryDB

Redis-compatible **durable** in-memory DB (data persisted with multi-AZ
transaction log). Primary DB use case, not just a cache.

### 5.6 Amazon Neptune

Managed graph DB (property graph via Gremlin/openCypher, RDF via SPARQL).
Use for social graphs, fraud, knowledge graphs.

### 5.7 Amazon DocumentDB (with MongoDB compatibility)

Managed JSON document DB compatible with MongoDB 3.6 / 4.0 / 5.0.

### 5.8 Amazon Keyspaces

Serverless, Apache Cassandra-compatible wide-column.

### 5.9 Amazon Timestream

Serverless time-series DB (IoT telemetry, metrics).

### 5.10 Amazon QLDB (being phased out — still appears on the exam)

Ledger DB with immutable, cryptographically verifiable journal. Use cases:
supply chain, financial, audit trails. AWS announced end-of-service 7/31/2025
and recommends Aurora PostgreSQL with ledger-style patterns.

### 5.11 Amazon Redshift

Petabyte-scale **data warehouse**. Columnar, MPP. Connectors include JDBC,
ODBC, and **Redshift Spectrum** which lets you query S3 data directly.
**Redshift Serverless** for on-demand analytics without managing clusters.

### 5.12 AWS Database Migration Service (DMS)

Online migrations (homogeneous and heterogeneous) with minimal downtime.
**Schema Conversion Tool (SCT)** converts the schema + code for
heterogeneous (e.g., Oracle → Aurora PostgreSQL).

### 5.13 Database selection rule

```
Relational OLTP, standard engines?                    → RDS (pick engine)
Cloud-native relational, HA-by-design?                → Aurora
Autoscaling relational, workload varies a lot?        → Aurora Serverless v2
Multi-Region active-active relational?                → Aurora Global Database
Key-value/document at any scale, flat latency?        → DynamoDB
µs cache/stateful session with high read ratio?       → ElastiCache (Redis/Memcached) or DAX
Durable in-memory primary DB?                         → MemoryDB
Graph relationships?                                  → Neptune
MongoDB-compatible documents?                         → DocumentDB
Cassandra-compatible wide-column?                     → Keyspaces
Time-series sensor / metrics?                         → Timestream
Immutable ledger with cryptographic proofs?           → QLDB (deprecated; check alternatives)
Petabyte-scale analytical warehousing?                → Redshift / Redshift Serverless
Data lake SQL on S3?                                  → Athena
Big Data Hadoop/Spark/Hive/Presto?                    → EMR
```

---

## 6. Networking services

### 6.1 Amazon VPC (Virtual Private Cloud)

A virtual network in AWS. Default VPC auto-created; recommend creating
purpose-built VPCs.

Building blocks:
- **CIDR block** — IP range (e.g., 10.0.0.0/16).
- **Subnets** — AZ-scoped, /28 minimum.
- **Route tables** — per subnet or default.
- **Internet Gateway (IGW)** — horizontally scaled, free.
- **Egress-only IGW** — IPv6 outbound only.
- **NAT Gateway** — managed NAT; AZ-scoped; highly available within AZ.
- **NAT Instance** — legacy; EC2 running NAT software.
- **VPC Endpoints** — private access to AWS services.
  - **Gateway endpoints** — S3 and DynamoDB (route table entry, free).
  - **Interface endpoints** — ENI with private IP (most other services);
    powered by **PrivateLink**; hourly + per GB.
- **VPC Peering** — 1:1 between two VPCs, non-transitive.
- **Transit Gateway (TGW)** — hub-and-spoke for 10s–1000s of VPCs and
  VPNs; transitive.
- **Direct Connect (DX)** — dedicated private line (1/10/100 Gbps) from DC
  to AWS; consistent latency.
- **Site-to-Site VPN** — IPsec over internet to VPC (via VGW or TGW).
- **Client VPN** — end-user OpenVPN-based.
- **AWS Cloud WAN** — managed global WAN fabric on top of TGW.
- **VPC Lattice** — application networking for service-to-service calls
  across accounts/VPCs with identity-based policies.

### 6.2 Amazon Route 53

Authoritative **DNS**, domain registration, and health checks.

Routing policies:
- **Simple** — one record set.
- **Weighted** — split traffic by percentage (A/B testing).
- **Latency-based** — send to lowest-latency Region.
- **Failover** — active/passive based on health checks.
- **Geolocation** — answer based on user's country.
- **Geoproximity** — shift traffic by bias toward a Region.
- **Multivalue answer** — up to 8 healthy records.
- **IP-based** — CIDR-based routing (newer).

### 6.3 Amazon CloudFront

Global CDN with 600+ edge locations. Use cases:
- Static/dynamic website/asset acceleration.
- Video streaming.
- Security layer (with AWS WAF, Shield, field-level encryption, Lambda@Edge,
  CloudFront Functions).
- Origin shield for cache efficiency.

### 6.4 AWS Global Accelerator

Uses AWS's global network with **anycast** static IPs to route clients to
the nearest healthy endpoint in AWS Regions. Not a cache — a network
accelerator. Good for TCP/UDP workloads, gaming, IoT, VoIP.

### 6.5 Networking selection rule

```
Content caching (HTML, images, video, API GET)?     → CloudFront
TCP/UDP with static anycast IPs?                    → Global Accelerator
DNS?                                                → Route 53
Few VPCs (2–3) connected?                           → VPC Peering
Many VPCs, on-prem, global?                         → Transit Gateway (+ Direct Connect / VPN)
Expose a service privately to consumers?            → PrivateLink endpoint service
Quick private link from VPC to AWS service?         → Gateway (S3/DDB) or Interface endpoint
Dedicated, consistent private connectivity?         → Direct Connect
IPsec tunnels over internet?                        → Site-to-Site VPN
End-user remote access to VPC?                      → Client VPN
Global service mesh (L7 with identity)?             → VPC Lattice
```

---

## 7. Application integration, messaging, APIs

### 7.1 Decoupling services

- **Amazon SQS (Simple Queue Service)** — pull-based queue.
  - Standard queue — at-least-once, best-effort ordering, unlimited TPS.
  - FIFO queue — exactly-once, strict order, 3K msgs/s (30K with batching).
  - **DLQ** for poison messages; **Visibility Timeout**; message retention
    up to 14 days.
- **Amazon SNS (Simple Notification Service)** — push-based **pub/sub**.
  - Fans out to SQS, Lambda, HTTP(S), email, SMS, mobile push, Firehose.
  - **FIFO topics** deliver only to FIFO SQS queues.
- **Amazon EventBridge** — event bus with rules and schemas. Supports
  **event buses** per account plus **Partner Event Sources** (Salesforce,
  Datadog, PagerDuty, Auth0, etc.). Powerful **Schema Registry**, archive
  + replay, pipe sources to targets.
  - **EventBridge Pipes** — source → filter → (optional) enrichment → target.
- **AWS Step Functions** — serverless workflow orchestration with JSON
  state language (ASL). **Standard** (long-running, exactly-once) vs
  **Express** (short, at-least-once, cheaper).
- **Amazon MQ** — managed ActiveMQ / RabbitMQ for existing JMS/AMQP apps.
- **Amazon AppFlow** — managed SaaS-to-AWS data transfer (Salesforce,
  ServiceNow, Slack, Google Analytics, etc.).
- **Amazon MSK** (Managed Streaming for Kafka) — Apache Kafka, and
  **MSK Serverless**.
- **Amazon Kinesis** — real-time streaming:
  - **Data Streams** — shard-based, custom consumers.
  - **Data Firehose** — load to S3/Redshift/OpenSearch/Splunk/HTTP.
  - **Video Streams** — video from devices.
  - **Kinesis Data Analytics for Apache Flink** — now called **Managed
    Service for Apache Flink**.

### 7.2 API management

- **Amazon API Gateway** — REST, HTTP, WebSocket APIs. Auth via IAM /
  Cognito / Lambda authorizer. Caching, throttling, stages, usage plans,
  API keys.
- **AWS AppSync** — managed **GraphQL** and **Pub/Sub**; real-time
  subscriptions; DynamoDB/RDS/OpenSearch/Lambda resolvers.

### 7.3 Selection rule

```
Decouple producers from consumers, buffer bursts?     → SQS
Fan out one event to many subscribers?                → SNS
Route / filter events from 130+ AWS and SaaS sources? → EventBridge
Multi-step workflow, retries, branching, sagas?       → Step Functions
Existing JMS/AMQP app, lift-and-shift?                → Amazon MQ
Kafka-compatible stream?                              → MSK
AWS-native stream with shards + Firehose ingestion?   → Kinesis
REST/HTTP/WebSocket APIs?                             → API Gateway
GraphQL with real-time?                               → AppSync
Move data from SaaS to AWS?                           → AppFlow
```

---

## 8. Management and governance

### 8.1 Amazon CloudWatch

- **Metrics** — numeric time series (AWS-provided + custom). 1-sec
  high-resolution optional.
- **Alarms** — thresholds on metrics; actions can include SNS, Auto
  Scaling, EC2 recovery, Systems Manager Ops Item.
- **Logs** — ingest + store + query (Logs Insights). Subscription filters
  to Kinesis/Firehose/Lambda.
- **Events/EventBridge** — now unified under EventBridge.
- **Dashboards** — cross-Region, cross-account views.
- **Synthetics** — canary scripts that probe endpoints.
- **RUM (Real User Monitoring)** — browser-side metrics.
- **Container Insights** / **Lambda Insights** / **Network Monitor** /
  **Internet Monitor** — specialized dashboards.
- **Application Signals** — SLIs/SLOs for apps.

### 8.2 AWS CloudTrail (Domain 2 recap)

API activity audit trail.

### 8.3 AWS Config

Resource inventory + compliance.

### 8.4 AWS Systems Manager (SSM)

Umbrella for many ops tools:

| Capability | Purpose |
|---|---|
| **Fleet Manager** | Visual instance management |
| **Inventory** | SW / config inventory of EC2 and on-prem |
| **Patch Manager** | OS patching, with baselines |
| **Run Command** | Ad-hoc commands on instances |
| **Session Manager** | Browser-based SSH with IAM auditing; no need for bastion |
| **State Manager** | Enforce desired config |
| **Automation** | Runbooks, remediation, cross-service workflows |
| **Parameter Store** | Config + SecureString secrets |
| **OpsCenter / Incident Manager** | Incident response |
| **Change Manager / Calendar** | Change control |
| **Distributor** | Package distribution |
| **Application Manager** | Application-centric ops view |
| **Quick Setup** | One-click onboarding across accounts |

### 8.5 AWS Organizations / Control Tower

Recap from Domain 2.

### 8.6 AWS Trusted Advisor

Five categories: Cost, Performance, Security, Fault Tolerance, Service
Limits, + Operational Excellence. All checks available in Business and
Enterprise Support plans.

### 8.7 AWS Health / Personal Health Dashboard

Alerts on events that affect your account (planned maintenance, degraded
service, security events). Integrates with EventBridge.

### 8.8 AWS Resilience Hub

Assesses and improves workload resilience against RTO/RPO targets.

### 8.9 AWS Resource Access Manager (RAM)

Share AWS resources (TGW, subnets, Route 53 Resolver rules, License
Manager configs, License Manager, Licenses) across accounts.

### 8.10 AWS Service Catalog / License Manager / Proton

- **Service Catalog** — curated, approved IaC products.
- **License Manager** — track license compliance.
- **AWS Proton** — managed infrastructure for platform teams to publish
  self-service templates for developers.

---

## 9. Developer tools

| Service | Purpose |
|---|---|
| **AWS CodeCommit** | Git-based source control (note: AWS stopped onboarding new customers in 2024; still tested) |
| **AWS CodeBuild** | Managed CI build service |
| **AWS CodeDeploy** | Automated deployments to EC2/Lambda/ECS/on-prem |
| **AWS CodePipeline** | CI/CD orchestration |
| **AWS CodeArtifact** | Managed package repo (npm, Maven, PyPI, NuGet, generic) |
| **AWS CodeGuru Reviewer / Profiler** | ML-based code reviews / perf insights (being folded into Amazon Q) |
| **AWS X-Ray** | Distributed tracing |
| **AWS Cloud9** | Browser IDE (end-of-life announced 2024; migrate to VS Code / CloudShell) |
| **AWS Amplify** | Front-end + back-end for web/mobile apps |
| **AWS App Runner** | Fully managed deploy-from-source web apps (appears in compute too) |
| **AWS CDK** | Define IaC in TS/Python/Java/C#/Go |
| **AWS SAM** | Serverless Application Model |
| **AWS CloudFormation** | Declarative IaC (YAML/JSON) |
| **AWS CloudShell** | Pre-auth shell in browser |
| **Amazon Q Developer** | AI coding assistant (replaces CodeWhisperer) |

---

## 10. Analytics

| Service | Purpose |
|---|---|
| **Amazon Athena** | Serverless SQL over S3 (Presto/Trino-based) |
| **AWS Glue** | Serverless ETL + Data Catalog; Glue Studio for visual pipelines; **DataBrew** for low-code data prep; **Crawler** discovers schemas |
| **Amazon EMR** | Managed Spark/Hadoop/Hive/Presto/Trino/Hudi/Iceberg |
| **Amazon Kinesis** | Streaming (see §7.1) |
| **Amazon MSK** | Managed Kafka |
| **Amazon OpenSearch Service** | Managed OpenSearch/Elasticsearch + Kibana/OpenSearch Dashboards; + Serverless |
| **Amazon QuickSight** | BI dashboards with **Q** (NLQ) and **Generative BI** |
| **AWS Data Exchange** | Marketplace for third-party datasets |
| **AWS Lake Formation** | Data-lake governance on top of Glue/S3/Athena/Redshift |
| **Amazon Redshift** | Data warehouse (compute) |
| **Amazon FinSpace** | Analytics for finance industry |
| **AWS Clean Rooms** | Multi-party data collaboration with privacy |

---

## 11. Machine Learning and Generative AI

- **Amazon SageMaker** — end-to-end ML (Studio, Notebooks, Training,
  Processing, Pipelines, Feature Store, Model Registry, Endpoints, Ground
  Truth labeling, Clarify, Autopilot, Canvas, JumpStart, HyperPod for
  large-model training).
- **Pre-trained AI services** (no ML skills needed):
  - **Amazon Rekognition** — images / videos.
  - **Amazon Textract** — extract text, forms, tables from docs.
  - **Amazon Comprehend** — NLP (sentiment, entities, topics, PII);
    **Comprehend Medical** for healthcare.
  - **Amazon Translate** — neural MT.
  - **Amazon Polly** — text-to-speech.
  - **Amazon Transcribe** — speech-to-text (+ Medical).
  - **Amazon Lex** — chatbots (same tech as Alexa).
  - **Amazon Kendra** — enterprise semantic search.
  - **Amazon Forecast** — time-series forecasting (being sunset — check status).
  - **Amazon Personalize** — recommendation systems.
  - **Amazon Fraud Detector** — fraud scoring.
- **Generative AI**:
  - **Amazon Bedrock** — serverless access to foundation models from
    Anthropic, Meta, Cohere, AI21, Stability, Mistral, Amazon (Titan,
    Nova). Guardrails, Knowledge Bases (RAG), Agents, Flows, Prompt
    Management.
  - **Amazon Q Business** — enterprise assistant on your data.
  - **Amazon Q Developer** — coding assistant.
  - **Amazon Q in QuickSight** — NL BI.

### 11.1 Selection rule

```
I have ML expertise and want to build models end to end?     → SageMaker
I just need image/video analysis?                            → Rekognition
Extract text from docs (incl. forms/tables)?                 → Textract
Sentiment / entities / topics / PII in text?                 → Comprehend
Translate text?                                              → Translate
Speech ↔ text?                                               → Polly (TTS) / Transcribe (STT)
Chatbot?                                                     → Lex  (or Bedrock Agents)
Enterprise semantic search?                                  → Kendra (or Bedrock Knowledge Bases)
Generic chatbot on my data with FM?                          → Amazon Q Business / Bedrock + KB
Coding assistant?                                            → Amazon Q Developer
Call an FM without managing infra?                           → Amazon Bedrock
```

---

## 12. IoT, media, other categories

### 12.1 IoT

- **AWS IoT Core** — MQTT / HTTPS / WSS broker + Device Gateway + Rules
  Engine + Device Shadow + Device Registry.
- **AWS IoT Greengrass** — extends AWS to edge devices.
- **AWS IoT Device Defender / Device Management / Events / SiteWise /
  TwinMaker / FleetWise / ExpressLink** — specialty IoT services.

### 12.2 Media

- **AWS Elemental MediaConvert / MediaLive / MediaPackage / MediaStore /
  MediaTailor / MediaConnect** — broadcast-grade video pipelines.
- **Amazon Interactive Video Service (IVS)** — low-latency live streaming.
- **Amazon Nimble Studio** (being wound down).

### 12.3 End-user computing

- **Amazon WorkSpaces** — desktop-as-a-service (Windows/Linux).
- **Amazon WorkSpaces Web** — secure browser-in-a-browser for SaaS access.
- **Amazon AppStream 2.0** — stream desktop apps.
- **Amazon WorkDocs** — file sharing (EOL announced).
- **Amazon Chime** / **Amazon Connect** — UCaaS / contact center.

### 12.4 Business applications

- **Amazon SES** — email sending.
- **Amazon Pinpoint** — multi-channel marketing / transactional messages
  (merging with SES / End User Messaging brand).
- **Amazon Honeycode** (EOL).

### 12.5 Migration & Transfer (recap)

- Application Migration Service (MGN).
- Database Migration Service (DMS).
- DataSync.
- Transfer Family.
- Snow Family.
- Migration Hub.
- Elastic Disaster Recovery.
- VM Import/Export.
- Application Discovery Service.
- Migration Evaluator.

### 12.6 Blockchain (niche, occasionally tested)

- **Amazon Managed Blockchain** — Hyperledger Fabric / Ethereum
  (being phased; check status).

### 12.7 Quantum

- **Amazon Braket** — quantum computing platform.

### 12.8 Robotics

- **AWS RoboMaker** (EOL announced Sept 2025).

### 12.9 Satellite

- **AWS Ground Station** — fully managed ground-station-as-a-service for
  satellite downlink.

---

## 13. Big cross-cutting comparisons

### 13.1 Serverless map

| Capability | Service |
|---|---|
| Compute | Lambda, Fargate, App Runner |
| Storage | S3 |
| Database | DynamoDB, Aurora Serverless v2, Redshift Serverless, OpenSearch Serverless, Keyspaces |
| Messaging | SQS, SNS, EventBridge, Step Functions |
| Networking | API Gateway, CloudFront, Route 53 |
| Auth | IAM, Cognito |
| Observability | CloudWatch, X-Ray |

### 13.2 Big data map

```
Ingest       ─▶  Kinesis (Data Streams / Firehose / Video) / MSK / IoT Core / DMS / DataSync / Snowball / Transfer Family
Store        ─▶  S3 (data lake), Redshift, DynamoDB, RDS, OpenSearch
Catalog/Gov  ─▶  Glue Data Catalog, Lake Formation
Process      ─▶  EMR, Glue, Athena, Redshift, Lambda, Managed Service for Apache Flink
Consume      ─▶  QuickSight, Redshift, Athena via BI, SageMaker, Bedrock, ML services
```

### 13.3 Identity & access map

```
Who are you?
 - AWS principal              → IAM (user / role / group)
 - Workforce user w/ SSO      → IAM Identity Center
 - App customer (B2C/B2B)     → Cognito User Pool
 - External IdP (Google, Okta, Azure AD) → SAML / OIDC federation to IAM Identity Center or Cognito

What can you do?
 - IAM identity policies
 - Resource-based policies (S3 bucket policy, SQS, Lambda, KMS...)
 - SCPs at org level
 - Permissions boundaries
 - ABAC via tags
 - Session policies
```

### 13.4 Observability map

```
Metrics      → CloudWatch Metrics
Logs         → CloudWatch Logs (+ subscription filters, Insights)
Events       → EventBridge / CloudWatch Events
Traces       → X-Ray / ADOT (OpenTelemetry-compatible)
API audit    → CloudTrail
Config drift → AWS Config
Threat       → GuardDuty, Macie, Inspector, Security Hub
Unified apps → CloudWatch Application Signals
RUM / canary → CloudWatch RUM / Synthetics
```

---

## 14. 40 rapid-fire check questions

1. What is AWS Fargate?
2. Which compute service scales to zero in seconds and runs ≤ 15 min
   functions?
3. Which gives you managed Kubernetes?
4. Which is the lowest-operations-overhead way to host a Dockerfile on AWS?
5. What does an Application Load Balancer route by?
6. Which load balancer gives you static IPs and millions of concurrent TCP
   connections?
7. Which EBS volume type is the new default general-purpose SSD?
8. Which storage class is cheapest and for ≥ 180-day archives?
9. Which S3 feature prevents deletion for compliance retention?
10. Which service auto-classifies sensitive data in S3?
11. Which database is 5× MySQL and 3× PostgreSQL?
12. Which AWS database is fully managed, NoSQL, multi-Region active-active?
13. Which in-memory store also provides durability for a primary DB?
14. Which managed DB is graph?
15. Which is MongoDB-compatible?
16. Which is Cassandra-compatible?
17. Which is columnar data warehouse?
18. Which lets you run SQL on S3 files serverlessly?
19. Which orchestrates multi-step workflows with JSON state machines?
20. Which routes events from many sources to many targets based on content
    filters?
21. Which messaging service is pub/sub?
22. Which is pull-based queue?
23. Which provides a managed SFTP endpoint?
24. Which is the hybrid storage gateway for SMB/NFS?
25. Which offline device carries 80 TB?
26. Which offline device is a 100 PB semi-trailer?
27. Which service caches content at 600+ edge locations?
28. Which accelerates TCP/UDP with static anycast IPs?
29. Which provides DNS with geoproximity routing?
30. Which connects many VPCs and on-prem in a hub-and-spoke topology?
31. Which provides private, dedicated connectivity from your DC?
32. Which provides IPsec VPN?
33. Which gives browser-based SSH via IAM?
34. What replaces bastion hosts with IAM-based sessions?
35. Which service automates OS patching via baselines?
36. Which orchestrates CI/CD?
37. Which service is AWS's native Git? (acknowledge deprecation)
38. Which is AWS's GraphQL API service?
39. Which provides text-to-speech?
40. Which provides serverless access to foundation models from multiple
    vendors?

---

Continue to **Domain 4 — Billing, Pricing, and Support**.
