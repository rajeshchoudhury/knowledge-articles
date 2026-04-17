# Exam Day Tips & Last-Minute Review

## Introduction

This is the final article in your AWS Solutions Architect Associate (SAA-C03) study guide. It's designed to be your go-to resource on the day before and the morning of your exam. It covers exam logistics, time management strategies, question-reading techniques, keyword-based answer selection, common trick patterns, a comprehensive last-minute review checklist with all the comparison tables you need, and post-exam information.

---

## Exam Logistics

### About the SAA-C03 Exam

| Detail | Information |
|--------|-------------|
| **Exam code** | SAA-C03 |
| **Format** | 65 questions (50 scored + 15 unscored/experimental) |
| **Question types** | Multiple choice (1 correct) and multiple response (2+ correct) |
| **Duration** | 130 minutes (2 hours 10 minutes) |
| **Passing score** | 720 out of 1000 (scaled scoring) |
| **Cost** | $150 USD |
| **Languages** | English, Japanese, Korean, Simplified Chinese, and more |
| **Validity** | 3 years from exam date |
| **Delivery** | Pearson VUE testing center or online proctored |

### Scheduling Your Exam

- Schedule through **AWS Certification** website → **Pearson VUE**
- Testing center: Choose a nearby Pearson VUE center; book at least 1-2 weeks in advance
- Online proctored: Take the exam from home or office
- Reschedule or cancel up to 24 hours before the appointment (no penalty)
- You may qualify for a **30-minute extension** if English is not your native language (request an ESL accommodation)

### ID Requirements

**Testing Center:**
- Two forms of ID (one must be government-issued photo ID)
- Primary: Passport, driver's license, national ID card
- Secondary: Credit card (signed), bank card, employee ID
- Name on IDs must match the name on your AWS Certification account exactly

**Online Proctored:**
- One government-issued photo ID
- Clear webcam, microphone, and stable internet
- Clean desk and room (no papers, books, second monitors)
- No one else can be in the room

### Check-In Process

**Testing Center:**
- Arrive 15-30 minutes early
- Store personal belongings in a locker (phone, wallet, watch, notes)
- You'll receive a whiteboard/marker or scratch paper
- Read and accept the NDA/exam agreement
- Proctor escorts you to your workstation

**Online Proctored:**
- Log in 30 minutes before your appointment
- System check: webcam, microphone, internet, software
- Take photos of your ID, face, and workspace
- Proctor reviews and admits you
- No breaks allowed (if you leave the camera view, exam may be voided)

---

## Time Management

### The Numbers

- **65 questions** in **130 minutes** = exactly **2 minutes per question**
- 15 questions are unscored (experimental), but you don't know which ones
- Treat every question as if it counts

### Strategy

1. **First pass (90-100 minutes):** Go through all 65 questions
   - Answer every question you're confident about immediately
   - For uncertain questions: **eliminate obviously wrong answers**, make your best choice, and **flag it** for review
   - Never leave a question blank — there's no penalty for wrong answers

2. **Second pass (30-40 minutes):** Review flagged questions
   - Re-read the question carefully
   - Reconsider your answer with fresh eyes
   - Don't change answers unless you have a clear reason — your first instinct is often correct

3. **Time checkpoints:**
   - At 30 minutes: Should be around question 15
   - At 60 minutes: Should be around question 30
   - At 90 minutes: Should be around question 45
   - At 100 minutes: Should be finishing question 65
   - At 100-130 minutes: Review flagged questions

### Red Flags for Time

- If you're spending more than 3 minutes on a single question, flag it and move on
- If you're at question 20 and 45 minutes have passed, you need to speed up
- Better to answer all 65 questions imperfectly than to leave 10 unanswered

---

## Question Strategies

### How to Read Questions

1. **Read the last sentence first** — This tells you what they're actually asking for
   - "Which solution meets these requirements with the LEAST operational overhead?"
   - "Which approach is MOST cost-effective?"
   - This frames how you evaluate the answers

2. **Read the scenario** — Identify the key requirements, constraints, and context

3. **Read ALL answer options** — Even if the first one looks correct; a later option may be better

4. **Identify the AWS service keywords** in the question — They narrow down the answer domain

### Elimination Strategy

For each question:
1. Immediately eliminate options that are **technically wrong** (service doesn't support that feature)
2. Eliminate options that **don't meet the stated requirements**
3. Among remaining options, choose the one that best matches the **optimization keyword** (cost, availability, security, etc.)

### Common Question Structures

**"Which solution meets these requirements?"**
- All options may be technically possible
- The "best" answer satisfies ALL stated requirements
- Look for the option that addresses every requirement mentioned

**"Which solution is MOST cost-effective?"**
- Multiple options work, but one is cheapest while still meeting requirements
- "Cost-effective" doesn't mean "cheapest" — it means best value while meeting all requirements

**"Which solution provides the LEAST operational overhead?"**
- Favor managed services over self-managed
- Favor serverless over servers
- Favor AWS-native over third-party

**"Which combination of steps..."** (multiple response)
- Usually 2 or 3 correct answers out of 5-6 options
- Each correct answer is independently necessary
- Look for complementary options (e.g., one creates a resource, another configures it)

---

## Keywords That Change the Answer

This is perhaps the most important section. The SAA-C03 exam heavily relies on specific keywords to determine the "best" answer. The same scenario with a different keyword often has a completely different answer.

### "Most Cost-Effective" / "Minimize Cost"

| Context | Answer Pattern |
|---------|---------------|
| Steady-state compute | Reserved Instances or Savings Plans |
| Fault-tolerant batch jobs | Spot Instances |
| Unpredictable traffic | On-Demand + Auto Scaling (or Lambda/Fargate for serverless) |
| Infrequently accessed data | S3 Standard-IA, Glacier, or Intelligent-Tiering |
| Database for unpredictable workloads | Aurora Serverless, DynamoDB On-Demand |
| DR strategy (cost focus) | Backup and Restore |
| API Gateway | HTTP API (70% cheaper than REST API) |
| Transfer data from S3 globally | S3 + CloudFront (reduces transfer costs) |

### "Least Operational Overhead" / "Minimize Management"

| Context | Answer Pattern |
|---------|---------------|
| Compute | Lambda > Fargate > ECS/EC2 > EC2 |
| Database | Aurora Serverless > RDS > self-managed on EC2 |
| File system | EFS > self-managed NFS on EC2 |
| Message queue | SQS > self-managed RabbitMQ on EC2 |
| Search | OpenSearch Serverless > OpenSearch managed > self-managed Elasticsearch |
| Container orchestration | App Runner > Fargate > ECS on EC2 > self-managed |
| ML predictions | SageMaker > self-built on EC2 |
| Key management | KMS > CloudHSM (CloudHSM requires you to manage the HSMs) |
| AD service | Managed Microsoft AD > running AD on EC2 |

### "Highest Availability" / "Fault Tolerant"

| Context | Answer Pattern |
|---------|---------------|
| EC2 | Multi-AZ ASG + ALB |
| Database | Aurora (multi-AZ, up to 15 replicas) > RDS Multi-AZ |
| Cross-Region database | Aurora Global Database |
| Storage | S3 (11 9s durability, multi-AZ by default) |
| Caching | ElastiCache Redis Multi-AZ with auto-failover |
| DNS | Route 53 (100% SLA) with health checks + failover routing |
| DR | Multi-Site Active-Active |
| Global app | Multi-Region + Route 53 + Global Accelerator |

### "Most Secure" / "Protect Data"

| Context | Answer Pattern |
|---------|---------------|
| Access control | IAM roles (not access keys), least privilege |
| Network | Private subnets, VPC endpoints, security groups |
| Connectivity | Direct Connect + VPN (encrypted + private) |
| Data at rest | KMS encryption (SSE-KMS for S3, encrypted EBS, encrypted RDS) |
| Data in transit | TLS/SSL, ACM certificates, HTTPS |
| Secrets | Secrets Manager (not environment variables or Parameter Store plaintext) |
| DDoS protection | Shield Advanced + WAF + CloudFront |
| Threat detection | GuardDuty |
| Compliance logging | CloudTrail (all Regions, all accounts) |
| S3 access | Presigned URLs for temporary access, bucket policies with conditions |

### "Fastest" / "Lowest Latency"

| Context | Answer Pattern |
|---------|---------------|
| Global content delivery | CloudFront |
| Database reads | ElastiCache (microseconds) > DAX (microseconds) > Read Replicas (ms) |
| Global routing | Global Accelerator (AWS backbone) |
| DNS resolution | Route 53 latency-based routing |
| Storage | Instance store (highest IOPS) > io2 Block Express > io2 > gp3 |
| Data transfer to AWS | Snowball (petabytes), Direct Connect (steady), S3 Transfer Acceleration (global uploads) |
| Local compute | Outposts (on-premises), Local Zones (metro), Wavelength (5G) |

### "Decouple" / "Loosely Coupled"

| Context | Answer Pattern |
|---------|---------------|
| Request/response buffering | SQS |
| Fan-out to multiple consumers | SNS → SQS |
| Complex event routing | EventBridge |
| Real-time stream processing | Kinesis Data Streams |
| Workflow orchestration | Step Functions |
| API decoupling | API Gateway |

### "Migrate with Minimal Changes" / "Lift and Shift"

| Context | Answer Pattern |
|---------|---------------|
| VMware workloads | VMware Cloud on AWS |
| Database migration (same engine) | DMS (homogeneous) |
| Database migration (different engine) | DMS + SCT (heterogeneous) |
| Server migration | AWS Application Migration Service |
| Large data transfer | Snowball / Snowball Edge |
| File shares to AWS | Storage Gateway (File Gateway) |
| On-premises to EC2 | VM Import/Export, Application Migration Service |

### "Real-Time"

| Context | Answer Pattern |
|---------|---------------|
| Data streaming | Kinesis Data Streams |
| Database change capture | DynamoDB Streams |
| Real-time analytics | Kinesis Data Analytics |
| Near real-time delivery | Kinesis Data Firehose (60-second minimum buffer) |
| Real-time notifications | SNS |
| Real-time bidirectional | API Gateway WebSocket |
| Real-time dashboards | AppSync (GraphQL subscriptions) |

### "Near Real-Time"

- **Kinesis Data Firehose:** Minimum 60-second buffer (near real-time, not real-time)
- The exam specifically distinguishes between "real-time" (Kinesis Data Streams) and "near real-time" (Kinesis Data Firehose)

---

## Common Trick Patterns in Questions

### Trick 1: "Immediately" + Direct Connect

If a question asks for a connection that needs to be set up **immediately** or **within hours**, Direct Connect is wrong (takes weeks to months). Use VPN instead.

### Trick 2: Read Replica for Write Scaling

RDS read replicas scale **reads**, not writes. If the question asks about write performance, read replicas are the wrong answer. Consider: Aurora (more write capacity), DynamoDB (distributed writes), or write sharding.

### Trick 3: S3 "Strong Consistency"

S3 now provides **strong read-after-write consistency** for all operations (PUT, DELETE, LIST). Questions implying S3 has eventual consistency are outdated. All read operations return the most recent version.

### Trick 4: RDS Multi-AZ Standby is NOT a Read Replica

The Multi-AZ standby in RDS is for **failover only** — you cannot read from it. If you need read scaling, you need read replicas (separate from Multi-AZ standby).

### Trick 5: Security Group vs NACL

- Security groups are **stateful** (return traffic automatically allowed)
- NACLs are **stateless** (must explicitly allow both inbound and outbound)
- Security groups only have **allow** rules
- NACLs have both **allow** and **deny** rules
- Questions about blocking a specific IP → NACL (you can't deny with security groups)

### Trick 6: NAT Gateway vs NAT Instance

- NAT Gateway is managed, scales automatically, highly available within an AZ
- NAT Instance is a regular EC2 instance you manage
- Exam almost always wants NAT Gateway (least operational overhead)
- NAT Gateway does NOT support security groups (NAT Instance does)
- NAT Gateway does NOT support port forwarding or bastion hosting

### Trick 7: EBS Volume and AZ Lock-In

- EBS volumes are **AZ-specific** — they can only attach to instances in the same AZ
- To move to another AZ: create a snapshot → create a volume from the snapshot in the new AZ
- This is a common trick in questions about migration or failover

### Trick 8: S3 Encryption Options

- **SSE-S3:** AWS manages everything (simplest, default)
- **SSE-KMS:** You manage keys in KMS, audit trail in CloudTrail
- **SSE-C:** You provide the encryption key with every request (AWS doesn't store it)
- **Client-side:** You encrypt before uploading
- If the question asks for **audit trail of key usage**, SSE-KMS is the answer

### Trick 9: Lambda in VPC

- Lambda in a VPC **loses internet access** by default
- To restore internet: place Lambda in a private subnet + NAT Gateway in a public subnet
- To access AWS services without internet: use VPC Endpoints
- Common trick: "Lambda can't reach DynamoDB after being placed in VPC" → Add VPC Endpoint for DynamoDB

### Trick 10: CloudFront Signed URLs vs S3 Presigned URLs

- **CloudFront Signed URLs/Cookies:** For content distributed via CloudFront; support expiration and IP restrictions; use CloudFront key pairs
- **S3 Presigned URLs:** Direct access to S3 objects; simpler; anyone with the URL can access
- If content is served via CloudFront → use CloudFront signed URLs
- If direct S3 access → use S3 presigned URLs

---

## Last-Minute Review Checklist

### Key Port Numbers

| Port | Protocol/Service |
|------|-----------------|
| 22 | SSH |
| 25 | SMTP |
| 53 | DNS |
| 80 | HTTP |
| 443 | HTTPS |
| 3306 | MySQL / Aurora MySQL |
| 5432 | PostgreSQL / Aurora PostgreSQL |
| 1433 | Microsoft SQL Server |
| 1521 | Oracle |
| 6379 | Redis (ElastiCache) |
| 11211 | Memcached (ElastiCache) |
| 3389 | RDP (Remote Desktop, Windows) |
| 27017 | MongoDB (DocumentDB) |
| 9092 | Apache Kafka (MSK) |
| 443 | NFS (EFS uses NFS over TLS) |
| 2049 | NFS (standard) |

### Key Limits and Defaults

| Service | Limit/Default |
|---------|--------------|
| **VPC** | 5 VPCs per Region (soft limit) |
| **Subnets** | 200 per VPC |
| **Internet Gateways** | 1 per VPC |
| **Security Groups** | 2,500 per VPC; 60 inbound + 60 outbound rules per SG |
| **NACLs** | 200 per VPC; 20 rules per NACL |
| **Elastic IPs** | 5 per Region (soft limit) |
| **EC2 On-Demand** | 20 per instance type per Region (varies, soft limit) |
| **EBS gp3** | 3,000 IOPS baseline, up to 16,000 IOPS |
| **EBS gp2** | 3 IOPS/GiB, burst to 3,000, max 16,000 |
| **EBS io2** | Up to 64,000 IOPS per volume |
| **EBS io2 Block Express** | Up to 256,000 IOPS per volume |
| **S3 object size** | Max 5 TB; multipart upload required for >5 GB |
| **S3 PUT** | 3,500 PUTs per second per prefix |
| **S3 GET** | 5,500 GETs per second per prefix |
| **Lambda memory** | 128 MB to 10,240 MB |
| **Lambda timeout** | Max 15 minutes (900 seconds) |
| **Lambda concurrency** | 1,000 per Region (default, soft limit) |
| **Lambda deployment** | 50 MB zipped, 250 MB unzipped, 10 GB container image |
| **SQS message size** | Max 256 KB |
| **SQS retention** | 1 minute to 14 days (default 4 days) |
| **SQS visibility timeout** | Default 30 seconds, max 12 hours |
| **SNS message size** | Max 256 KB |
| **DynamoDB item size** | Max 400 KB |
| **DynamoDB partition key** | Max 2,048 bytes |
| **DynamoDB sort key** | Max 1,024 bytes |
| **RDS max storage** | 64 TiB (varies by engine) |
| **Aurora storage** | Auto-scales up to 128 TiB |
| **CloudFormation** | 500 resources per stack |
| **API Gateway timeout** | 29 seconds (max integration timeout) |
| **API Gateway throttle** | 10,000 RPS per Region (account-level) |
| **Step Functions** | Standard: up to 1 year; Express: up to 5 minutes |

### S3 Storage Class Comparison

| Storage Class | Availability | Durability | Min Storage | Retrieval Fee | Use Case |
|--------------|-------------|-----------|-------------|--------------|----------|
| **S3 Standard** | 99.99% | 11 9s | None | None | Frequently accessed data |
| **S3 Intelligent-Tiering** | 99.9% | 11 9s | None | None | Unknown/changing access patterns |
| **S3 Standard-IA** | 99.9% | 11 9s | 128 KB, 30 days | Per GB retrieved | Infrequent access, rapid retrieval |
| **S3 One Zone-IA** | 99.5% | 11 9s | 128 KB, 30 days | Per GB retrieved | Infrequent, non-critical, reproducible |
| **S3 Glacier Instant Retrieval** | 99.9% | 11 9s | 128 KB, 90 days | Per GB retrieved | Archive, instant ms retrieval |
| **S3 Glacier Flexible Retrieval** | 99.99% | 11 9s | 40 KB, 90 days | Per GB + per request | Archive, minutes-hours retrieval |
| **S3 Glacier Deep Archive** | 99.99% | 11 9s | 40 KB, 180 days | Per GB + per request | Long-term archive, 12-48 hour retrieval |

**Glacier Flexible Retrieval Times:**
- Expedited: 1-5 minutes
- Standard: 3-5 hours
- Bulk: 5-12 hours

**Glacier Deep Archive Retrieval Times:**
- Standard: 12 hours
- Bulk: 48 hours

### EBS Volume Type Comparison

| Volume Type | Category | IOPS (max) | Throughput (max) | Size | Use Case |
|------------|----------|-----------|-----------------|------|----------|
| **gp3** | SSD | 16,000 | 1,000 MiB/s | 1 GiB - 16 TiB | General purpose (recommended) |
| **gp2** | SSD | 16,000 | 250 MiB/s | 1 GiB - 16 TiB | General purpose (legacy) |
| **io2** | SSD | 64,000 | 1,000 MiB/s | 4 GiB - 16 TiB | High-performance databases |
| **io2 Block Express** | SSD | 256,000 | 4,000 MiB/s | 4 GiB - 64 TiB | Largest, most demanding databases |
| **st1** | HDD | 500 | 500 MiB/s | 125 GiB - 16 TiB | Big data, data warehouses, log processing |
| **sc1** | HDD | 250 | 250 MiB/s | 125 GiB - 16 TiB | Cold data, infrequent access, lowest cost |

**Key facts:**
- Only SSD volumes (gp2, gp3, io1, io2) can be boot volumes
- HDD volumes (st1, sc1) cannot be boot volumes
- gp3 lets you independently set IOPS and throughput (gp2 scales IOPS with size)
- io2 provides 99.999% durability (other types: 99.8-99.9%)

### EC2 Instance Type Families

| Family | Category | Optimized For | Example Use Case |
|--------|----------|--------------|-----------------|
| **M** | General Purpose | Balanced compute/memory/network | Web servers, app servers, small databases |
| **C** | Compute Optimized | High CPU | Batch processing, ML inference, gaming, HPC |
| **R** | Memory Optimized | High memory | In-memory databases, real-time analytics |
| **X** | Memory Optimized | Very high memory | SAP HANA, large in-memory databases |
| **P** | Accelerated (GPU) | GPU parallel processing | ML training, deep learning |
| **G** | Accelerated (GPU) | Graphics | Video rendering, game streaming, 3D |
| **Inf** | Accelerated (Inferentia) | ML inference | Cost-effective ML inference |
| **I** | Storage Optimized | High sequential I/O | NoSQL databases (Cassandra, MongoDB) |
| **D** | Storage Optimized | Dense storage | Distributed file systems, data warehouses |
| **H** | Storage Optimized | High disk throughput | MapReduce, HDFS |
| **T** | Burstable | Variable CPU | Dev/test, small workloads, micro-services |
| **Mac** | Mac | macOS | iOS/macOS development |

**Memory trick:** Mnemonic for common types:
- **M** = Main (general purpose)
- **C** = Compute
- **R** = RAM
- **T** = Turbo/Tiny (burstable)
- **I** = I/O
- **G** = Graphics
- **P** = Parallel (GPU)

### Database Service Comparison

| Service | Type | Use Case | Key Feature |
|---------|------|----------|-------------|
| **RDS** | Relational (SQL) | Traditional OLTP applications | Multi-AZ, Read Replicas, 6 engines |
| **Aurora** | Relational (SQL) | High-performance OLTP | 5x MySQL, 3x PostgreSQL, auto-scaling storage |
| **DynamoDB** | Key-Value / Document | Serverless, high-scale NoSQL | Single-digit ms latency, Global Tables |
| **ElastiCache** | In-memory | Caching, session stores | Redis (persistence, replication) or Memcached |
| **Redshift** | Data Warehouse | OLAP, analytics | Columnar storage, Spectrum for S3 queries |
| **Neptune** | Graph | Fraud detection, social networks | Supports Gremlin and SPARQL |
| **DocumentDB** | Document (MongoDB-compatible) | MongoDB workloads on AWS | MongoDB 3.6/4.0/5.0 API compatible |
| **Keyspaces** | Wide Column (Cassandra-compatible) | Cassandra workloads on AWS | Serverless, CQL compatible |
| **QLDB** | Ledger | Immutable records | Cryptographically verifiable, no decentralization |
| **Timestream** | Time Series | IoT, DevOps metrics | Built-in time series analytics, retention policies |
| **MemoryDB** | In-memory (Redis-compatible) | Durable in-memory database | Redis API + Multi-AZ durability |

### Encryption Options Per Service

| Service | At Rest | In Transit | Key Management |
|---------|---------|-----------|----------------|
| **S3** | SSE-S3, SSE-KMS, SSE-C, client-side | HTTPS (TLS) | KMS or customer-managed |
| **EBS** | AES-256 (KMS) | Encrypted between EC2 and EBS | KMS |
| **RDS** | AES-256 (KMS); must be enabled at creation | SSL/TLS | KMS |
| **Aurora** | AES-256 (KMS) | SSL/TLS | KMS |
| **DynamoDB** | AES-256 (default: AWS owned, option: KMS CMK) | HTTPS (TLS) | KMS or AWS owned |
| **EFS** | AES-256 (KMS) | TLS (mount with TLS helper) | KMS |
| **Redshift** | AES-256 (KMS or CloudHSM) | SSL/TLS | KMS or CloudHSM |
| **Lambda** | Environment variables: KMS | HTTPS | KMS |
| **SQS** | SSE-SQS or SSE-KMS | HTTPS (TLS) | KMS or SQS managed |
| **SNS** | SSE-KMS | HTTPS (TLS) | KMS |
| **Kinesis** | SSE (KMS) | HTTPS (TLS) | KMS |
| **ElastiCache** | At-rest encryption (Redis) | In-transit encryption (Redis) | AWS managed or KMS |

### DR Strategy Comparison (RPO/RTO)

| Strategy | RPO | RTO | Cost | Always-On in DR |
|----------|-----|-----|------|-----------------|
| **Backup & Restore** | Hours | Hours | $ | Nothing |
| **Pilot Light** | Minutes | 10s of minutes | $$ | Database replica only |
| **Warm Standby** | Seconds-Minutes | Minutes | $$$ | Scaled-down full stack |
| **Multi-Site Active-Active** | Near zero | Near zero | $$$$ | Full production |

### VPN vs Direct Connect

| Feature | VPN | Direct Connect |
|---------|-----|---------------|
| **Setup time** | Minutes | Weeks to months |
| **Bandwidth** | Limited by internet | 1, 10, or 100 Gbps |
| **Latency** | Variable (internet-based) | Consistent, low |
| **Encryption** | Yes (IPsec) | No (add VPN for encryption) |
| **Cost** | Lower | Higher |
| **Reliability** | Depends on internet | Dedicated, more reliable |
| **Use case** | Quick setup, backup, low bandwidth | High bandwidth, consistent performance |
| **HA** | 2 tunnels per connection | Need 2 DX at different locations |

### Service Comparison Tables

#### SQS vs SNS vs EventBridge

| Feature | SQS | SNS | EventBridge |
|---------|-----|-----|-------------|
| **Model** | Queue (pull) | Pub/Sub (push) | Event Bus (push) |
| **Consumers** | 1 per message | All subscribers | Matched targets |
| **Ordering** | FIFO available | FIFO available | No |
| **Filtering** | No | Message attributes | Event patterns (rich) |
| **Max message size** | 256 KB | 256 KB | 256 KB |
| **Retention** | Up to 14 days | No retention | Archive + replay |
| **SaaS integration** | No | No | Yes |
| **Exam trigger** | "decouple", "buffer" | "fan-out", "notify" | "event-driven", "routing" |

#### ALB vs NLB vs GLB

| Feature | ALB | NLB | GLB |
|---------|-----|-----|-----|
| **Layer** | 7 (HTTP/HTTPS) | 4 (TCP/UDP/TLS) | 3 (IP) |
| **Protocols** | HTTP, HTTPS, gRPC | TCP, UDP, TLS | IP (GENEVE) |
| **Routing** | Path, host, header, query string | Port-based | N/A (transparent) |
| **Targets** | EC2, ECS, Lambda, IP | EC2, IP, ALB | Appliances (firewalls, IDS) |
| **Static IP** | No (use Global Accelerator) | Yes (1 per AZ) | N/A |
| **SSL termination** | Yes | Yes | N/A |
| **WebSocket** | Yes | Yes | N/A |
| **Performance** | Good | Ultra-high (millions of RPS) | N/A |
| **Use case** | Web applications, microservices | Gaming, IoT, static IP | Third-party appliances |

#### CloudFront vs Global Accelerator

| Feature | CloudFront | Global Accelerator |
|---------|-----------|-------------------|
| **Type** | CDN (content caching) | Network routing (anycast) |
| **Caching** | Yes | No |
| **Static IP** | No | Yes (2 anycast IPs) |
| **Protocol** | HTTP/HTTPS | TCP, UDP |
| **Use case** | Static/dynamic web content | Non-HTTP, gaming, static IP, instant failover |
| **Origin failover** | Yes (origin groups) | Yes (endpoint groups) |
| **Edge** | Edge locations (200+) | Edge locations + AWS backbone |

#### Kinesis Data Streams vs Kinesis Data Firehose

| Feature | Data Streams | Data Firehose |
|---------|-------------|---------------|
| **Latency** | Real-time (~200 ms) | Near real-time (60s+ buffer) |
| **Management** | Manage shards | Fully managed, auto-scaling |
| **Consumers** | Custom (Lambda, KCL, Kinesis Analytics) | Built-in: S3, Redshift, OpenSearch, Splunk, HTTP |
| **Data retention** | 1-365 days | No retention (delivery only) |
| **Ordering** | Per shard | N/A |
| **Replay** | Yes | No |
| **Use case** | Custom real-time processing | ETL delivery to destinations |

#### RDS vs Aurora vs DynamoDB

| Feature | RDS | Aurora | DynamoDB |
|---------|-----|--------|----------|
| **Type** | Relational | Relational | NoSQL (Key-Value/Document) |
| **Engines** | MySQL, PostgreSQL, MariaDB, Oracle, SQL Server | MySQL, PostgreSQL | Proprietary |
| **Storage** | EBS (up to 64 TiB) | Auto-scaling (up to 128 TiB) | Auto-managed |
| **Read replicas** | Up to 5 | Up to 15 | N/A (auto-distributed) |
| **Multi-AZ** | Standby (failover only) | Built-in (6 copies, 3 AZs) | Built-in (3 AZs) |
| **Failover** | 60-120 seconds | <30 seconds | N/A (auto) |
| **Serverless** | No | Aurora Serverless v2 | On-Demand mode |
| **Global** | Cross-region read replicas | Global Database | Global Tables |
| **Scaling** | Vertical (instance size) | Vertical + auto-storage | Horizontal (auto) |
| **Best for** | Traditional SQL apps | High-performance SQL | High-scale, low-latency NoSQL |

---

## What to Do After the Exam

### Immediately After

1. **Preliminary result:** You'll see a **pass** or **fail** on screen immediately after completing the exam
   - Note: This is preliminary; the official result follows
   - The preliminary result is almost always accurate

2. **Survey:** You may be asked to complete a short survey about the exam experience

### Within 5 Business Days

1. **Official score:** Available in your AWS Certification account
   - Score range: 100-1000 (passing: 720)
   - You'll see your score and a breakdown by exam domain
   - Domain-level results help identify areas for improvement if you didn't pass

2. **Digital badge:** If you passed, you'll receive a **Credly digital badge**
   - Share on LinkedIn, social media, email signatures
   - Verifiable by employers and clients

### After Certification

- **Certificate:** Download your certificate PDF from the AWS Certification portal
- **Benefits:**
  - 50% discount voucher for your next AWS exam
  - Access to AWS Certified merchandise store
  - AWS Certified LinkedIn community
  - Digital badge for professional profiles
- **Recertification:** The certification is valid for **3 years**
  - To recertify, pass the current version of the same exam or a higher-level exam
  - AWS sometimes offers a shorter recertification exam

### If You Don't Pass

- You can retake the exam after a **14-day waiting period**
- Review your domain-level results to focus your study
- There's no limit to the number of retakes
- Each retake costs the full exam fee ($150)

---

## Common Exam Scenarios with Strategy

### Scenario 1: Migration with Tight Timeline

**Question:** "A company needs to migrate 50 TB of data to AWS within 2 weeks. Their internet connection is 100 Mbps."

**Strategy:**
- Calculate: 50 TB over 100 Mbps = ~46 days (too slow)
- Answer: **AWS Snowball** (ships in ~1 week, load data, ship back)
- If the question said 1 TB, the internet connection would be sufficient

### Scenario 2: Decoupled Architecture

**Question:** "The application processes images uploaded by users. During peak hours, the processing service is overwhelmed."

**Strategy:**
- Keywords: "overwhelmed" + "decouple"
- Answer: **S3 → SQS → Lambda** (or EC2 processing from SQS queue)
- SQS buffers the requests, processing happens at a sustainable rate

### Scenario 3: Global Low-Latency

**Question:** "Users in Asia, Europe, and North America need low-latency access to a web application."

**Strategy:**
- Keywords: "global" + "low-latency"
- Answer: **CloudFront** for static content + **Multi-Region deployment** with **Route 53 latency-based routing** for dynamic content
- If database is mentioned: **DynamoDB Global Tables** or **Aurora Global Database**

### Scenario 4: Cost-Effective Data Storage

**Question:** "A company stores log files that are frequently accessed for the first 30 days, then rarely accessed but must be kept for 7 years."

**Strategy:**
- Keywords: "30 days" + "7 years" + retention
- Answer: **S3 Lifecycle Policy:**
  - Days 0-30: S3 Standard
  - Days 30-90: S3 Standard-IA
  - Days 90+: S3 Glacier Flexible Retrieval (or Deep Archive for 7-year retention)

### Scenario 5: Secure VPC Architecture

**Question:** "Web servers must be accessible from the internet. Application and database servers must NOT be accessible from the internet."

**Strategy:**
- Answer: **3-tier architecture:**
  - Public subnet: ALB
  - Private subnet 1: Application servers (EC2/ECS)
  - Private subnet 2: Database (RDS)
  - NAT Gateway in public subnet for outbound internet from private subnets

### Scenario 6: Event-Driven with Multiple Consumers

**Question:** "When an order is placed, the order must be processed, a notification must be sent, and analytics must be updated — all independently."

**Strategy:**
- Keywords: "multiple consumers" + "independently"
- Answer: **SNS → SQS fan-out pattern**
  - SNS topic receives the order event
  - 3 SQS queues subscribed (processing, notification, analytics)
  - Each queue has its own Lambda/consumer

### Scenario 7: Regulatory Data Residency

**Question:** "Due to regulations, data must remain physically within the company's own data center, but the team wants to use AWS APIs."

**Strategy:**
- Keywords: "own data center" + "AWS APIs"
- Answer: **AWS Outposts** — Run AWS infrastructure in your data center

### Scenario 8: Block a Specific IP Address

**Question:** "The security team needs to block traffic from a specific IP address."

**Strategy:**
- Security groups only support ALLOW rules → Cannot block specific IPs
- Answer: **NACL** (Network ACL) — Supports explicit DENY rules
- Or **AWS WAF** if it's a web application (IP set rules)

### Scenario 9: Shared File System

**Question:** "Multiple EC2 instances in different AZs need to share a file system concurrently."

**Strategy:**
- EBS: Cannot share across instances (except io1/io2 multi-attach, same AZ only)
- Answer: **Amazon EFS** — NFS file system accessible from multiple AZs
- If Windows: **Amazon FSx for Windows File Server**

### Scenario 10: Stateless Session Management

**Question:** "A web application uses sticky sessions on the ALB. The team wants to remove sticky sessions while maintaining user session data."

**Strategy:**
- Keywords: "stateless" + "session management"
- Answer: Store sessions in **ElastiCache Redis** or **DynamoDB**
- Application retrieves session from the shared store on each request
- Instances become stateless and can be replaced freely

---

## Final Exam Day Reminders

1. **Get a good night's sleep** — Cognitive function matters more than last-minute cramming
2. **Eat a balanced meal** before the exam — Your brain needs fuel for 2+ hours
3. **Arrive early** (testing center) or **test your setup** (online proctored)
4. **Read every question completely** — Don't rush; misreading is the most common error
5. **Don't panic on hard questions** — Flag them and come back; you only need ~72% to pass
6. **Trust your preparation** — If you've studied the material in this guide, you're ready
7. **Remember the keywords** — They are the single most reliable way to find the best answer
8. **There's no penalty for guessing** — Always answer every question, even if uncertain
9. **Watch for "NOT" and "EXCEPT"** — These flip the question; read carefully
10. **You've got this!**

---

## Quick Reference: "If You See X, Think Y"

| If You See... | Think... |
|---------------|----------|
| "serverless" | Lambda, DynamoDB, Fargate, API Gateway |
| "containers" | ECS, Fargate, EKS, ECR |
| "Kubernetes" | EKS |
| "5G", "carrier" | Wavelength |
| "on-premises AWS" | Outposts |
| "metro low-latency" | Local Zones |
| "VMware" | VMware Cloud on AWS |
| "tape backup" | Storage Gateway (Tape) |
| "NFS to S3" | Storage Gateway (File) |
| "dedicated encrypted link" | DX + VPN |
| "quick encrypted link" | VPN |
| "DNS failover" | Route 53 + Health Checks |
| "static IP" | NLB or Global Accelerator |
| "DDoS" | Shield + WAF + CloudFront |
| "SQL injection/XSS" | WAF |
| "threat detection" | GuardDuty |
| "sensitive data in S3" | Macie |
| "compliance check" | Config |
| "audit API calls" | CloudTrail |
| "secrets rotation" | Secrets Manager |
| "federated SSO" | IAM Identity Center |
| "trust relationship AD" | Managed Microsoft AD |
| "event-driven" | EventBridge, Lambda, SNS, SQS |
| "workflow" | Step Functions |
| "GraphQL" | AppSync |
| "real-time streaming" | Kinesis Data Streams |
| "near real-time delivery" | Kinesis Firehose |
| "ETL" | Glue |
| "data lake query" | Athena |
| "search" | OpenSearch |
| "batch processing" | AWS Batch |
| "HPC" | ParallelCluster, FSx for Lustre |
| "machine learning" | SageMaker |
| "document/text extraction" | Textract |
| "image/video analysis" | Rekognition |
| "chatbot" | Lex |
| "translate" | Translate |
| "transcribe audio" | Transcribe |
| "multi-account management" | Organizations + SCPs |
| "centralized logging" | CloudWatch Logs, S3, OpenSearch |
| "cost optimization" | Cost Explorer, Budgets, Trusted Advisor, Compute Optimizer |

---

**Good luck on your exam! You're well prepared.**

---

*This concludes the AWS Solutions Architect Associate Study Guide series.*
