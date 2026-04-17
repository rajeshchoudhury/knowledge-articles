# Performance Optimization — AWS SAP-C02 Domain 5

## Table of Contents
1. [Well-Architected Framework — Performance Efficiency Pillar](#1-well-architected-framework--performance-efficiency-pillar)
2. [Compute Performance](#2-compute-performance)
3. [Storage Performance](#3-storage-performance)
4. [Database Performance](#4-database-performance)
5. [Networking Performance](#5-networking-performance)
6. [Caching Strategies](#6-caching-strategies)
7. [Content Delivery Optimization](#7-content-delivery-optimization)
8. [Application Performance](#8-application-performance)
9. [Performance Testing](#9-performance-testing)
10. [AWS Well-Architected Tool](#10-aws-well-architected-tool)
11. [Exam Scenarios](#11-exam-scenarios)

---

## 1. Well-Architected Framework — Performance Efficiency Pillar

### 1.1 Design Principles

| Principle | Description |
|---|---|
| **Democratize advanced technologies** | Use managed services instead of building yourself |
| **Go global in minutes** | Deploy to multiple regions for lower latency |
| **Use serverless architectures** | Remove server management overhead |
| **Experiment more often** | Test different approaches easily |
| **Consider mechanical sympathy** | Use the technology approach best aligned with your workload |

### 1.2 Best Practice Areas

```
Performance Efficiency:
├── Selection (choose the right resource)
│   ├── Compute: EC2 type, Lambda, containers, serverless
│   ├── Storage: S3, EBS, EFS, FSx — match to access pattern
│   ├── Database: Purpose-built, right engine, right size
│   └── Network: Placement groups, enhanced networking, CDN
│
├── Review (keep resources optimal)
│   ├── New instance types (Graviton, new generations)
│   ├── New services (serverless options, managed services)
│   └── Architecture patterns (event-driven, microservices)
│
├── Monitoring (detect performance issues)
│   ├── CloudWatch metrics and alarms
│   ├── Performance Insights (RDS/Aurora)
│   └── X-Ray (distributed tracing)
│
└── Trade-offs (make informed decisions)
    ├── Consistency vs. performance (caching, eventual consistency)
    ├── Cost vs. performance (larger instances, provisioned IOPS)
    └── Complexity vs. performance (multi-region, sharding)
```

---

## 2. Compute Performance

### 2.1 Instance Selection

| Instance Family | Optimized For | Use Case |
|---|---|---|
| **M (General)** | Balanced CPU/memory | Web servers, app servers, dev/test |
| **C (Compute)** | High CPU-to-memory ratio | Batch processing, scientific computing, ML inference |
| **R (Memory)** | High memory-to-CPU ratio | In-memory databases, real-time analytics |
| **I (Storage)** | High sequential I/O | NoSQL databases, data warehousing |
| **D (Dense)** | High density HDD storage | Hadoop/HDFS, data lakes |
| **P/G/Inf/Trn** | GPU/ML accelerators | ML training, inference, HPC, rendering |
| **T (Burstable)** | Burstable CPU | Low-traffic web servers, dev environments |
| **HPC (hpc)** | High-performance computing | Tightly-coupled parallel workloads |

### 2.2 Graviton Processors

```
Graviton Benefits:
├── Up to 40% better price-performance vs x86
├── Available: m7g, c7g, r7g, t4g, im4gn, etc.
├── Supports: Linux, containers, most languages
├── Not for: Windows workloads, x86-only software
│
Migration Path:
1. Test in ARM container (Docker multi-arch)
2. Validate application works on Graviton instances
3. Performance test (typically equal or better)
4. Deploy (same instance class, replace 5→6g or 6→7g)
```

### 2.3 Placement Groups

| Type | Description | Use Case | Limits |
|---|---|---|---|
| **Cluster** | All instances in single AZ, close together | HPC, low-latency networking | Single AZ, same instance type recommended |
| **Spread** | Each instance on different rack | HA for critical instances | Max 7 per AZ per group |
| **Partition** | Groups of instances on separate racks | HDFS, Cassandra, Kafka | Max 7 partitions per AZ |

```
Cluster Placement Group:
┌──────────────────────────────────────┐
│ Single Rack / Close Proximity         │
│ [inst1][inst2][inst3][inst4][inst5]   │
│ 10 Gbps+ between instances           │
│ Lowest latency (<0.25ms)             │
└──────────────────────────────────────┘

Spread Placement Group:
┌────────┐  ┌────────┐  ┌────────┐
│ Rack 1 │  │ Rack 2 │  │ Rack 3 │
│[inst1] │  │[inst2] │  │[inst3] │
└────────┘  └────────┘  └────────┘
Max failure domain isolation

Partition Placement Group:
┌───────────────────┐  ┌───────────────────┐
│ Partition 1       │  │ Partition 2       │
│ (Rack group A)    │  │ (Rack group B)    │
│ [inst1][inst2]    │  │ [inst3][inst4]    │
│ [inst5]           │  │ [inst6]           │
└───────────────────┘  └───────────────────┘
```

### 2.4 Enhanced Networking

| Feature | Description | Performance |
|---|---|---|
| **ENA (Elastic Network Adapter)** | Standard enhanced networking | Up to 100 Gbps |
| **EFA (Elastic Fabric Adapter)** | OS-bypass networking for HPC | Near-RDMA performance |
| **SR-IOV** | Hardware-level network virtualization | Lower latency, higher PPS |

**EFA vs ENA:**
```
ENA: Standard enhanced networking
├── Supported on most instance types
├── Up to 100 Gbps
└── Used for general high-performance networking

EFA: Elastic Fabric Adapter
├── Only on specific instances (p4d, hpc6a, c5n, etc.)
├── OS-bypass for MPI/NCCL communication
├── Used for tightly-coupled HPC and ML training
└── Supports libfabric API (not TCP/IP)
```

### 2.5 Auto Scaling Optimization

```
Scaling Policy Types:
├── Target Tracking: Maintain metric at target (e.g., CPU at 60%)
│   Best for: Steady, predictable scaling
│
├── Step Scaling: Scale based on alarm thresholds
│   CPU 60-70%: +1 instance
│   CPU 70-80%: +2 instances
│   CPU >80%: +4 instances
│   Best for: Multiple scaling thresholds
│
├── Simple Scaling: Single step (legacy)
│   Best for: Don't use — use Step or Target Tracking
│
├── Scheduled Scaling: Time-based scaling
│   Mon-Fri 8AM: min=10
│   Mon-Fri 6PM: min=2
│   Best for: Known traffic patterns
│
└── Predictive Scaling: ML-based (forecast demand)
    Analyzes 14 days of history
    Proactively scales before demand arrives
    Best for: Recurring patterns (daily, weekly)
```

---

## 3. Storage Performance

### 3.1 EBS Performance Optimization

| Volume Type | Max IOPS | Max Throughput | Use Case |
|---|---|---|---|
| **gp3** | 16,000 | 1,000 MB/s | General purpose (independently set IOPS/throughput) |
| **gp2** | 16,000 (burst) | 250 MB/s | General purpose (IOPS scale with size) |
| **io2 Block Express** | 256,000 | 4,000 MB/s | Mission-critical IOPS-intensive |
| **io1** | 64,000 | 1,000 MB/s | High IOPS workloads |
| **st1** | 500 | 500 MB/s | Big data, throughput-intensive |
| **sc1** | 250 | 250 MB/s | Infrequently accessed |

**EBS Optimization Tips:**
```
1. EBS-Optimized instances: Dedicated bandwidth for EBS
   (enabled by default on most current-gen instances)

2. gp3 vs gp2:
   gp3: 3,000 IOPS + 125 MB/s baseline (independently adjustable)
   gp2: 3 IOPS/GB (need 5,334 GB to get 16,000 IOPS)
   Winner: gp3 (more control, lower cost)

3. io2 Block Express for extreme performance:
   ├── Up to 256,000 IOPS per volume
   ├── Up to 4,000 MB/s throughput
   ├── Sub-millisecond latency
   └── Requires R5b, X2idn, or similar Nitro instances

4. RAID 0 for beyond single volume limits:
   4 × gp3 volumes striped = 64,000 IOPS + 4,000 MB/s
   (use for temporary data only — no redundancy)

5. Multi-attach (io1/io2): Single volume attached to up to 16 instances
   Use case: Clustered applications (shared storage)
```

### 3.2 S3 Performance

```
S3 Performance Limits:
├── 3,500 PUT/COPY/POST/DELETE per second per prefix
├── 5,500 GET/HEAD per second per prefix
├── Unlimited prefixes per bucket
│
Optimization:
├── Parallelize requests across prefixes
│   bucket/images/2024/01/01/file1.jpg
│   bucket/images/2024/01/02/file2.jpg
│   bucket/images/2024/01/03/file3.jpg
│   Each date prefix gets its own 3,500 PUT / 5,500 GET limit
│
├── S3 Transfer Acceleration
│   Upload: Client → CloudFront edge → AWS backbone → S3
│   50-500% faster for distant uploads
│
├── Multipart Upload
│   Required for >5 GB, recommended for >100 MB
│   Parallel upload of parts → faster throughput
│
├── S3 Select / Glacier Select
│   Query inside objects (CSV, JSON, Parquet)
│   Returns only matching data → reduce data transfer
│
└── Byte-Range Fetches
    Download specific byte ranges in parallel
    Useful for large files (video, datasets)
```

### 3.3 EFS Performance

| Mode | Throughput | Use Case |
|---|---|---|
| **General Purpose** | Lower latency | Web serving, CMS, dev environments |
| **Max I/O** | Higher throughput, higher latency | Big data, media processing, ML |
| **Elastic** (default) | Auto-scales throughput | Most workloads |

**Throughput Modes:**
| Mode | Description |
|---|---|
| **Bursting** | Scales with storage size (baseline + burst credits) |
| **Provisioned** | Set throughput independently of storage |
| **Elastic** | Auto-scales to workload demand (recommended) |

---

## 4. Database Performance

### 4.1 RDS Proxy

```
Without RDS Proxy:
┌────────────┐  100 connections each   ┌──────────────┐
│ Lambda     │─────────────────────────│ RDS          │
│ (1000      │  = 100,000 connections │ (max 5,000)  │
│ concurrent)│  → CONNECTION OVERFLOW! │              │
└────────────┘                         └──────────────┘

With RDS Proxy:
┌────────────┐  100,000 connections  ┌───────────┐  50 connections  ┌──────────────┐
│ Lambda     │──────────────────────│ RDS Proxy │────────────────│ RDS          │
│ (1000      │  (multiplexing)     │ (pools &  │  (reuses pool) │ (handles 50) │
│ concurrent)│                      │  manages) │                │              │
└────────────┘                      └───────────┘                └──────────────┘

Benefits:
├── Connection pooling and multiplexing
├── Reduces database connection overhead
├── Faster failover (holds connections during RDS failover)
├── IAM authentication for database access
└── Essential for Lambda → RDS architecture
```

### 4.2 Read Replicas

```
Read-heavy workload optimization:

┌──────────┐    Write    ┌──────────────────┐
│   App    │─────────────│  Primary (Writer) │
│ (writes) │             └────────┬─────────┘
└──────────┘                      │ Async
                                  │ Replication
                    ┌─────────────┼─────────────┐
                    ▼             ▼             ▼
             ┌──────────┐ ┌──────────┐ ┌──────────┐
             │ Replica 1│ │ Replica 2│ │ Replica 3│
             └──────────┘ └──────────┘ └──────────┘
                    ▲             ▲             ▲
                    └─────────────┼─────────────┘
                                  │
                           ┌──────┴──────┐
                           │   App       │
                           │  (reads)    │
                           └─────────────┘

RDS: Up to 5 read replicas (15 for Aurora)
Aurora: Reader endpoint auto-distributes reads
```

### 4.3 ElastiCache and DAX

```
Caching Layer:
┌──────────┐    Cache    ┌──────────────┐    DB Miss    ┌──────────────┐
│   App    │────Hit?────│ ElastiCache  │──────────────│   RDS/Aurora  │
│          │   Yes→Return│ (Redis)      │  Read from DB│              │
│          │   No→DB Read│              │  Write to    │              │
│          │◀────────────│              │◀─cache       │              │
└──────────┘             └──────────────┘              └──────────────┘

DAX (DynamoDB Accelerator):
┌──────────┐             ┌──────────────┐              ┌──────────────┐
│   App    │─────────────│    DAX       │──────────────│  DynamoDB    │
│          │  Same API   │  (in-memory) │  Cache miss  │              │
│          │  as DynamoDB│  <1ms reads  │  → DynamoDB  │              │
└──────────┘             └──────────────┘              └──────────────┘

DAX: Drop-in replacement (same DynamoDB API, just change endpoint)
ElastiCache: Application must handle cache logic (read-through, write-through)
```

### 4.4 Aurora Performance Features

| Feature | Description | Use Case |
|---|---|---|
| **Parallel Query** | Push query processing to storage layer | Large analytical queries on OLTP data |
| **Aurora Serverless v2** | Auto-scale ACUs in 0.5 increments | Variable workloads |
| **Global Database** | < 1 second cross-region replication | Multi-region reads |
| **Custom Endpoints** | Route queries to specific replica groups | Analytical vs OLTP replicas |
| **Performance Insights** | SQL-level performance monitoring | Identify slow queries |

### 4.5 DynamoDB Partition Key Design

```
Good Partition Key Design:
├── High cardinality (many unique values)
├── Even distribution of requests
├── Examples: user_id, order_id, session_id

Bad Partition Key Design:
├── Low cardinality → hot partitions
├── Examples: status (only "active"/"inactive"), date (today gets all traffic)

Hot Partition Problem:
Partition "2024-03-15": 90% of writes  ← Throttled!
Partition "2024-03-14": 5% of writes
Partition "2024-03-13": 5% of writes

Solution: Composite key or write sharding
├── PK: date#shard_id (e.g., "2024-03-15#3")
├── Use random shard (0-9) to spread writes across 10 partitions
└── On read: query all shards and aggregate

DynamoDB Adaptive Capacity:
├── Automatically redistributes capacity to hot partitions
├── But doesn't solve fundamental design issues
└── Design good keys first, rely on adaptive capacity as safety net
```

---

## 5. Networking Performance

### 5.1 Enhanced Networking

```
Standard Networking:     Enhanced Networking (ENA):
┌──────────────────┐    ┌──────────────────┐
│  Instance        │    │  Instance        │
│  ├── vNIC        │    │  ├── ENA         │
│  │   (software)  │    │  │  (hardware    │
│  │   ~1 Gbps     │    │  │   SR-IOV)     │
│  │   High latency│    │  │   100 Gbps    │
│  │   Low PPS     │    │  │   Low latency │
│  └───────────────┘    │  │   High PPS    │
└──────────────────┘    │  └───────────────┘
                        └──────────────────┘
```

### 5.2 Jumbo Frames

- Standard MTU: 1500 bytes
- Jumbo frames: 9001 bytes
- Supported within VPC (same region)
- Reduces packet overhead for large transfers
- NOT supported over VPN, internet gateway, or VPC peering (cross-region)
- Supported over Direct Connect (dedicated), Transit Gateway (same region)

### 5.3 Direct Connect Performance

```
Direct Connect Speeds:
├── Dedicated: 1 Gbps, 10 Gbps, 100 Gbps
├── Hosted: 50 Mbps to 10 Gbps (via partner)
│
Direct Connect vs VPN:
├── DX: Consistent latency, predictable bandwidth, no internet
├── VPN: Variable latency, limited to ~1.25 Gbps per tunnel
│
LAG (Link Aggregation Group):
├── Combine multiple DX connections
├── 2-4 connections of same speed
├── Active-active for higher throughput
└── Example: 4 × 10 Gbps = 40 Gbps aggregate
```

### 5.4 Global Accelerator

```
Without Global Accelerator:
User (Sydney) → Internet (variable) → us-east-1 ALB
Latency: High, variable (internet routing)

With Global Accelerator:
User (Sydney) → Nearest edge → AWS backbone → us-east-1 ALB
Latency: Lower, consistent (AWS network from edge)

Benefits:
├── 2 static Anycast IPs (global entry points)
├── AWS global network from nearest edge location
├── Health-based failover between endpoints
├── 60% improvement in latency for global users
└── TCP/UDP support (not just HTTP like CloudFront)
```

---

## 6. Caching Strategies

### 6.1 Cache Hierarchy

```
Cache at Every Layer:

Client → CloudFront (Edge Cache) → API Gateway (Response Cache) →
  Application (In-memory/ElastiCache) → Database (Buffer Pool/DAX)

Layer 1: CloudFront
├── Cache static assets (images, CSS, JS)
├── Cache API responses (TTL-based)
├── Edge locations worldwide

Layer 2: API Gateway
├── Cache API responses (0.5-237 GB)
├── Per-stage caching
├── TTL: 0 to 3600 seconds

Layer 3: ElastiCache / DAX
├── Cache database query results
├── Cache session data
├── Cache computed results

Layer 4: Database
├── RDS: Buffer pool (automatic)
├── DynamoDB: DAX (separate cluster)
├── Aurora: Buffer pool + shared storage cache
```

### 6.2 Caching Patterns

**Lazy Loading (Cache-Aside):**
```
Read Request:
1. App checks cache
2. If HIT → Return cached data
3. If MISS → Query database
4. Store result in cache
5. Return data

Pros: Only requested data is cached
Cons: Cache miss penalty (extra latency), stale data possible
```

**Write-Through:**
```
Write Request:
1. App writes to cache AND database
2. Cache always has latest data

Pros: Data always fresh
Cons: Write latency (2 writes), unused data cached
```

**Write-Behind (Write-Back):**
```
Write Request:
1. App writes to cache
2. Cache asynchronously writes to database

Pros: Low write latency
Cons: Risk of data loss if cache fails before DB write
```

**TTL (Time-to-Live):**
```
Balance freshness vs performance:
├── Short TTL (30s): Near real-time, more DB reads
├── Medium TTL (5 min): Good balance for most APIs
├── Long TTL (1 hr+): Static content, reference data
└── No TTL: Session data (until explicit invalidation)
```

### 6.3 ElastiCache Cluster Modes

**Redis Cluster Mode Disabled:**
```
1 Primary + up to 5 Replicas (single shard)
├── All data on single node
├── Max memory: single node size
├── Read scaling: replicas
└── Use for: Small datasets, simple caching
```

**Redis Cluster Mode Enabled:**
```
Up to 500 shards, each with replicas
├── Data partitioned across shards
├── Total memory: sum of all shards
├── Write scaling: across shards
├── Read scaling: replicas per shard
└── Use for: Large datasets, high throughput
```

---

## 7. Content Delivery Optimization

### 7.1 CloudFront Architecture

```
User → Nearest Edge Location → Regional Edge Cache → Origin
       (216+ locations)         (13 locations)       (S3/ALB/EC2)
       
Cache Behavior Priority:
├── Path /api/* → Origin: ALB (no caching, forward all)
├── Path /images/* → Origin: S3 (cache 24h, compress)
├── Path /static/* → Origin: S3 (cache 7d, compress)
└── Default (*) → Origin: ALB (cache 5 min)
```

### 7.2 Origin Shield

```
Without Origin Shield:              With Origin Shield:
Edge → Regional → Origin            Edge → Regional → Origin Shield → Origin
Edge → Regional → Origin            Edge → Regional → Origin Shield ← cache
Edge → Regional → Origin            Edge → Regional → Origin Shield ← cache

3 origin requests                   1 origin request + 2 cache hits

Benefits:
├── Reduces origin load
├── Improves cache hit ratio
├── Best for: Popular content, global distribution
└── Additional cost: Per-request fee
```

### 7.3 Edge Functions

| Feature | CloudFront Functions | Lambda@Edge |
|---|---|---|
| **Runtime** | JavaScript | Node.js, Python |
| **Execution** | Edge locations (all 216+) | Regional edge caches (13) |
| **Max time** | 1 ms | 5s (viewer), 30s (origin) |
| **Memory** | 2 MB | Up to 10 GB |
| **Network** | No | Yes |
| **File system** | No | Yes (read-only Lambda layer) |
| **Pricing** | $0.10/million | $0.60/million + duration |
| **Use cases** | URL rewrites, header manipulation, simple redirects | A/B testing, auth, image resize |

### 7.4 Cache Optimization

```
Maximize Cache Hit Ratio:
├── Normalize query strings (sort parameters)
├── Forward only necessary headers
├── Forward only necessary cookies
├── Use versioned URLs (/js/app.v2.js) instead of no-cache
├── Set appropriate TTLs (match content update frequency)
└── Use Origin Shield for additional caching layer

Cache Invalidation:
├── CreateInvalidation API (/*  or /images/*)
├── Versioned filenames (preferred — no invalidation needed)
└── Cost: First 1,000 paths/month free, then $0.005/path
```

---

## 8. Application Performance

### 8.1 Asynchronous Processing

```
Synchronous (slow):
Client → API → Process (30s) → Respond
Client waits 30 seconds

Asynchronous (fast):
Client → API → SQS → Respond "Accepted" (200ms)
             └── Worker → Process (30s) → Notify client (SNS/WebSocket)
Client gets immediate response, processing happens in background
```

### 8.2 Connection Pooling

```
Without Pooling:
Each Lambda invocation → New DB connection → Close connection
1000 concurrent Lambdas = 1000 DB connections (overwhelms DB)

With RDS Proxy:
Lambda → RDS Proxy (connection pool) → DB
1000 concurrent Lambdas → 50 DB connections (proxy multiplexes)

For containers (ECS/EKS):
Use HikariCP (Java), pgBouncer (PostgreSQL), or ProxySQL (MySQL)
within the container or as a sidecar
```

### 8.3 Compression

```
Enable compression for:
├── CloudFront: Automatic gzip/br compression
│   (objects between 1,000 - 10,000,000 bytes)
├── API Gateway: Minimum compression size (0 bytes = always)
├── ALB: No native compression (handle in application)
└── S3: Pre-compress objects + set Content-Encoding header

Compression savings:
├── HTML/CSS/JS: 60-80% reduction
├── JSON: 70-90% reduction
├── Images: Already compressed (skip)
└── Brotli (br) > Gzip for text content (~15-20% smaller)
```

---

## 9. Performance Testing

### 9.1 Load Testing Tools

| Tool | Type | AWS Integration |
|---|---|---|
| **Distributed Load Testing on AWS** | AWS Solution | CloudFormation deploy, uses Fargate |
| **Apache JMeter** | Open source | Run on EC2 or Fargate |
| **Locust** | Python-based | Run on EC2 or Fargate |
| **Artillery** | Node.js-based | Run on Lambda or EC2 |
| **k6** | Open source | Run on EC2 or Fargate |

### 9.2 Testing Strategy

```
Performance Testing Pyramid:

         ┌───────────────┐
         │   Chaos Test  │  ← FIS (resilience under failure)
         │  (Resilience)  │
         ├───────────────┤
         │  Stress Test   │  ← Beyond expected peak (find limits)
         │  (Breaking pt) │     Target: 200-300% of expected peak
         ├───────────────┤
         │   Load Test    │  ← Expected peak (verify performance)
         │  (Expected)    │     Target: Match production peak
         ├───────────────┤
         │   Soak Test    │  ← Extended duration (find memory leaks)
         │  (Endurance)   │     Duration: 4-24 hours
         ├───────────────┤
         │  Smoke Test    │  ← Basic functionality (quick check)
         │  (Baseline)    │     Low load, verify system works
         └───────────────┘
```

### 9.3 Key Performance Metrics

| Metric | Target | Measurement |
|---|---|---|
| **Response Time (P50)** | <200ms | Median response time |
| **Response Time (P99)** | <1s | 99th percentile |
| **Throughput** | >1000 TPS | Requests per second |
| **Error Rate** | <0.1% | 5xx / Total requests |
| **Concurrent Users** | >10,000 | Simultaneous connections |
| **CPU Utilization** | <70% at peak | CloudWatch EC2 metric |
| **Memory Utilization** | <80% at peak | CloudWatch Agent |
| **Database Connections** | <80% of max | RDS Performance Insights |

### 9.4 Distributed Load Testing on AWS

```
Architecture:
┌──────────────────────────────────────────────────┐
│  Distributed Load Testing Solution                │
│                                                   │
│  Step Functions (orchestrator)                    │
│  ├── Create Fargate tasks (load generators)      │
│  ├── Monitor test progress                       │
│  └── Collect results                             │
│                                                   │
│  Fargate Tasks (load generators):                │
│  ├── Task 1: 1000 concurrent users              │
│  ├── Task 2: 1000 concurrent users              │
│  ├── Task 3: 1000 concurrent users              │
│  ...                                              │
│  └── Task N: 1000 concurrent users              │
│                                                   │
│  Target: Your Application (ALB/API Gateway/EC2)  │
│                                                   │
│  Results: S3 + CloudWatch Dashboard              │
└──────────────────────────────────────────────────┘
```

---

## 10. AWS Well-Architected Tool

### 10.1 Overview

Interactive tool to review workloads against the 6 pillars of the Well-Architected Framework.

### 10.2 Process

```
1. Define Workload
   ├── Name and description
   ├── Environment (production, pre-production)
   ├── AWS regions
   └── Account IDs

2. Answer Questions (per pillar)
   ├── Operational Excellence (11 questions)
   ├── Security (11 questions)
   ├── Reliability (11 questions)
   ├── Performance Efficiency (8 questions)
   ├── Cost Optimization (9 questions)
   └── Sustainability (6 questions)

3. Review Findings
   ├── High-risk issues (HRIs) — immediate action
   ├── Medium-risk issues (MRIs) — plan to address
   └── Improvement plan with recommended actions

4. Track Improvements
   ├── Milestone snapshots
   ├── Track HRI/MRI reduction over time
   └── Share reports with stakeholders
```

### 10.3 Lens Catalog

| Lens | Purpose |
|---|---|
| **AWS Well-Architected** | General best practices (default) |
| **Serverless Application** | Serverless-specific best practices |
| **SaaS** | Multi-tenant SaaS best practices |
| **Machine Learning** | ML workload best practices |
| **Data Analytics** | Analytics workload best practices |
| **IoT** | IoT workload best practices |
| **Financial Services** | FSI compliance + best practices |
| **Healthcare** | HIPAA + healthcare best practices |
| **Custom** | Organization-specific lenses |

---

## 11. Exam Scenarios

### Scenario 1: Database Connection Issues with Lambda

**Question:** A serverless application using Lambda and RDS Aurora experiences connection timeout errors during traffic spikes. Lambda concurrency reaches 1,000 but RDS supports only 1,000 max connections. How to fix?

**Answer:** **Amazon RDS Proxy**

- Provides connection pooling between Lambda and RDS
- 1,000 Lambda connections multiplexed to ~100 DB connections
- Handles connection reuse and cleanup
- Also improves failover time (holds connections during failover)

---

### Scenario 2: Global Application Latency

**Question:** A company serves users in US, Europe, and Asia from us-east-1. API response times are 50ms for US users but 300ms for Asian users. How to improve?

**Answer:** Combination approach:
1. **CloudFront** for static content (cache at edge locations globally)
2. **Global Accelerator** for dynamic API traffic (AWS backbone instead of internet)
3. **DynamoDB Global Tables** or **Aurora Global Database** for data in Asia region
4. For full optimization: deploy application in ap-southeast-1 with Route 53 latency-based routing

---

### Scenario 3: S3 Performance

**Question:** A data pipeline writes 10,000 objects per second to S3 and reads 50,000 objects per second. They experience throttling. How to optimize?

**Answer:** **Distribute across prefixes**

```
Current: All writes to s3://bucket/data/file-N.json
(single prefix → throttled at 3,500 PUT/s)

Optimized:
s3://bucket/data/2024/03/15/00/file-1.json  (prefix: data/2024/03/15/00/)
s3://bucket/data/2024/03/15/01/file-2.json  (prefix: data/2024/03/15/01/)
...spread across many prefixes

Each prefix gets 3,500 PUT + 5,500 GET per second
With enough prefixes: unlimited aggregate throughput
```

---

### Scenario 4: EBS Performance

**Question:** An OLTP database on EC2 needs consistent 80,000 IOPS with sub-millisecond latency. What EBS configuration?

**Answer:** **io2 Block Express** volume

- Supports up to 256,000 IOPS per volume
- Sub-millisecond latency
- Provision 80,000 IOPS directly
- Requires Nitro-based instance (R5b or similar)
- Cost: $0.125/GB + $0.065/IOPS → size appropriately

---

### Scenario 5: Caching Strategy

**Question:** An e-commerce site has a product catalog with 100,000 items. Product pages are read 10,000 times per second but updated only 10 times per day. Database is Aurora PostgreSQL. How to optimize read performance?

**Answer:** **ElastiCache Redis** with lazy loading pattern

1. Application checks Redis first for product data
2. Cache HIT (99.99% of the time): Return from Redis (<1ms)
3. Cache MISS: Query Aurora, store in Redis with 1-hour TTL
4. On product update: Invalidate cache key + update Aurora
5. Expected cache hit ratio: >99.9%
6. Aurora load reduced by 99.9%
7. Consider Redis Cluster Mode Enabled for 100K items across shards

---

### Scenario 6: HPC Networking

**Question:** A company runs tightly-coupled HPC simulations across 100 EC2 instances that require the lowest possible inter-node latency. What configuration?

**Answer:** 
1. **Cluster Placement Group** (all instances on same rack)
2. **EFA (Elastic Fabric Adapter)** for OS-bypass networking
3. **C5n or Hpc6a instances** (EFA-capable, high network bandwidth)
4. **Single AZ** deployment
5. MPI or NCCL for inter-process communication

---

> **Key Exam Tips Summary:**
> 1. **Graviton** = 40% better price-performance for ARM-compatible workloads
> 2. **Cluster placement group** = lowest latency (single AZ, close proximity)
> 3. **EFA** = HPC/ML training networking (OS-bypass, MPI support)
> 4. **ENA** = standard enhanced networking (up to 100 Gbps)
> 5. **gp3 > gp2** = independently set IOPS/throughput, cheaper
> 6. **io2 Block Express** = up to 256K IOPS for extreme performance
> 7. **RDS Proxy** = essential for Lambda → RDS (connection pooling)
> 8. **Read Replicas** = scale reads (up to 5 RDS, 15 Aurora)
> 9. **DAX** = drop-in DynamoDB cache (same API, microsecond reads)
> 10. **ElastiCache** = application-managed caching (Redis for complex, Memcached for simple)
> 11. **CloudFront Origin Shield** = extra caching layer to protect origin
> 12. **S3 prefixes** = distribute requests across prefixes for higher throughput
> 13. **Global Accelerator** = AWS backbone for global traffic (TCP/UDP)
> 14. **Predictive Scaling** = ML-based proactive scaling
> 15. **DynamoDB partition key** = high cardinality, even distribution to avoid hot partitions
