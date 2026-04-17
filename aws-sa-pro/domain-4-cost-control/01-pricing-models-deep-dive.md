# Pricing Models Deep Dive — AWS SAP-C02 Domain 4

## Table of Contents
1. [EC2 Pricing](#1-ec2-pricing)
2. [Storage Pricing](#2-storage-pricing)
3. [Database Pricing](#3-database-pricing)
4. [Data Transfer Pricing](#4-data-transfer-pricing)
5. [Lambda Pricing](#5-lambda-pricing)
6. [API Gateway Pricing](#6-api-gateway-pricing)
7. [Network Pricing](#7-network-pricing)
8. [Container Pricing](#8-container-pricing)
9. [Free Tier Details](#9-free-tier-details)
10. [Pricing Calculator Usage](#10-pricing-calculator-usage)
11. [Exam Scenarios with Cost Calculation](#11-exam-scenarios-with-cost-calculation)

---

## 1. EC2 Pricing

### 1.1 On-Demand Instances

**What:** Pay for compute capacity by the second (Linux) or by the hour (Windows), with no long-term commitment.

**Pricing Characteristics:**
- No upfront costs, no commitments
- Per-second billing (minimum 60 seconds) for Linux/Ubuntu
- Per-hour billing for Windows, RHEL, SUSE
- Highest per-unit cost of all pricing models

**Example Pricing (us-east-1, approximate):**

| Instance Type | vCPUs | Memory | On-Demand/hr |
|---|---|---|---|
| t3.micro | 2 | 1 GB | $0.0104 |
| t3.medium | 2 | 4 GB | $0.0416 |
| m5.large | 2 | 8 GB | $0.096 |
| m5.xlarge | 4 | 16 GB | $0.192 |
| c5.2xlarge | 8 | 16 GB | $0.340 |
| r5.2xlarge | 8 | 64 GB | $0.504 |
| m5.24xlarge | 96 | 384 GB | $4.608 |

**When to Use:**
- Short-term, spiky, or unpredictable workloads
- First time applications
- Applications being developed or tested
- Applications that cannot be interrupted

### 1.2 Reserved Instances (RIs)

**Types of RIs:**

| Type | Discount | Term | Flexibility |
|---|---|---|---|
| **Standard RI** | Up to 72% | 1 or 3 years | Limited (can sell on Marketplace) |
| **Convertible RI** | Up to 66% | 1 or 3 years | Can change instance family, OS, tenancy |
| **Scheduled RI** | 5-10% | 1 year | Specific time windows (DISCONTINUED) |

**Payment Options:**

| Payment | Discount Level | Cash Flow |
|---|---|---|
| All Upfront | Highest (e.g., 72%) | Large upfront payment, no monthly |
| Partial Upfront | Medium (e.g., 60%) | Partial upfront + reduced monthly |
| No Upfront | Lowest (e.g., 45%) | No upfront, reduced monthly rate |

**Standard RI Example (m5.xlarge, 3-year, us-east-1):**
```
On-Demand:      $0.192/hr × 8,760 hrs/yr × 3 yrs = $5,046
All Upfront:    $2,556 (one-time) → $0.097/hr effective → 49% savings
Partial Upfront: $1,356 upfront + $0.052/hr → ~47% savings
No Upfront:     $0.119/hr → 38% savings
```

**Standard RI Modifications:**
- Can change AZ within same region
- Can change instance size within same family (size flexibility)
- CANNOT change instance family, OS, or tenancy

**Convertible RI:**
- CAN change instance family, OS, tenancy, scope
- Equal or greater value exchange required
- CANNOT sell on RI Marketplace

**RI Size Flexibility (Linux only):**
```
Normalization factors:
nano:    0.25
micro:   0.5
small:   1
medium:  2
large:   4
xlarge:  8
2xlarge: 16
4xlarge: 32
8xlarge: 64
...

Example: 1 × m5.xlarge RI (factor 8) can cover:
- 1 × m5.xlarge (8)
- 2 × m5.large (4+4=8)
- 4 × m5.medium (2+2+2+2=8)
- 1 × m5.large (4) + 2 × m5.medium (2+2=4) = 8
```

### 1.3 Savings Plans

**Types:**

| Plan Type | Discount | Flexibility |
|---|---|---|
| **Compute Savings Plan** | Up to 66% | Any EC2 instance family, any region, any OS, any tenancy, Fargate, Lambda |
| **EC2 Instance Savings Plan** | Up to 72% | Specific instance family + region, any size/OS/tenancy |
| **SageMaker Savings Plan** | Up to 64% | SageMaker instance usage |

**How It Works:**
1. Commit to a consistent amount of compute usage ($/hour) for 1 or 3 years
2. Usage up to commitment = discounted rate
3. Usage beyond commitment = On-Demand rate

**Example:**
```
Commitment: $10/hour for 3 years (Compute Savings Plan, All Upfront)

Hour 1: $15 actual usage
  - $10 covered by Savings Plan (discounted)
  - $5 at On-Demand pricing

Hour 2: $7 actual usage
  - $7 covered by Savings Plan (discounted)
  - $3 of commitment "wasted" (but plan still saves overall)
```

**Savings Plans vs Reserved Instances:**

| Feature | Reserved Instances | Savings Plans |
|---|---|---|
| Commitment | Specific instance type | Dollar amount per hour |
| Flexibility | Limited (Standard) or Moderate (Convertible) | High (Compute) or Moderate (EC2) |
| Coverage | EC2 only | EC2, Fargate, Lambda (Compute SP) |
| Marketplace | Standard RIs can be sold | Cannot be sold |
| Size flexibility | Within family (Linux) | Automatic (any size) |
| Region flexibility | No (except Convertible exchange) | Yes (Compute SP) |

> **Exam Tip:** Savings Plans are generally the recommended approach for new commitments. Compute Savings Plans offer the most flexibility. EC2 Instance Savings Plans offer the deepest discount for predictable instance families.

### 1.4 Spot Instances

**What:** Use unused EC2 capacity at up to 90% discount. Instances can be interrupted with 2-minute warning.

**Pricing Characteristics:**
- Up to 90% discount compared to On-Demand
- Prices fluctuate based on supply and demand
- 2-minute interruption notice via instance metadata and CloudWatch Events
- Charged per-second, minimum 60 seconds

**Spot Pricing History (Approximate):**
```
Instance: m5.xlarge (us-east-1)
On-Demand: $0.192/hr
Spot:      $0.040-0.060/hr (varies by AZ)
Savings:   ~70-80%
```

**Spot Fleet:**
- Request a fleet of Spot Instances (and optionally On-Demand)
- Specify target capacity (instances or vCPUs)
- Multiple instance types and AZs for diversification
- Allocation strategies: `lowestPrice`, `capacityOptimized`, `diversified`, `priceCapacityOptimized`

**Spot Placement Score:**
- Query API that rates likelihood of getting Spot capacity
- Score 1-10 per region/AZ for specified instance types
- Use to choose optimal region/AZ for Spot workloads

**Interruption Handling:**
| Action | Description |
|---|---|
| **Terminate** | Instance terminated (default) |
| **Stop** | Instance stopped (can restart later) |
| **Hibernate** | Instance hibernated (memory saved to EBS) |

**Best Practices:**
- Diversify across multiple instance types and AZs
- Use `capacityOptimized` or `priceCapacityOptimized` allocation strategy
- Implement graceful interruption handling (check metadata endpoint)
- Use for fault-tolerant, stateless workloads

### 1.5 Dedicated Hosts vs Dedicated Instances

| Feature | Dedicated Host | Dedicated Instance |
|---|---|---|
| **What** | Physical server dedicated to you | Instance on dedicated hardware |
| **Socket/core visibility** | Yes (for licensing) | No |
| **BYOL** | Yes (Oracle, SQL Server, Windows) | Limited |
| **Affinity** | Can specify which host | No control |
| **Per-host billing** | Yes (pay for entire host) | Per-instance (premium) |
| **Placement** | You control instance placement | AWS controls |
| **Compliance** | Full hardware isolation | Hardware isolation |
| **Cost** | Higher (entire host) | Lower (per-instance premium) |
| **Use Case** | BYOL, compliance, licensing requirements | Compliance without BYOL needs |

> **Exam Tip:** "Company uses Oracle with per-socket licensing" → Dedicated Host (need socket visibility). "Regulatory requirement for dedicated hardware" → Dedicated Host or Dedicated Instance depending on whether BYOL/socket visibility is needed.

---

## 2. Storage Pricing

### 2.1 S3 Pricing

**Storage Classes (us-east-1 approximate):**

| Class | Storage/GB/mo | PUT/POST | GET | Retrieval | Min Duration | Min Size |
|---|---|---|---|---|---|---|
| **S3 Standard** | $0.023 | $0.005/1K | $0.0004/1K | Free | None | None |
| **S3 Intelligent-Tiering** | $0.023-0.0025 | $0.005/1K | $0.0004/1K | Free | None | 128 KB |
| **S3 Standard-IA** | $0.0125 | $0.01/1K | $0.001/1K | $0.01/GB | 30 days | 128 KB |
| **S3 One Zone-IA** | $0.01 | $0.01/1K | $0.001/1K | $0.01/GB | 30 days | 128 KB |
| **S3 Glacier Instant** | $0.004 | $0.02/1K | $0.01/1K | $0.03/GB | 90 days | 128 KB |
| **S3 Glacier Flexible** | $0.0036 | $0.03/1K | $0.0004/1K | Varies | 90 days | 40 KB |
| **S3 Glacier Deep Archive** | $0.00099 | $0.05/1K | $0.0004/1K | Varies | 180 days | 40 KB |

**S3 Glacier Retrieval Pricing:**

| Tier | Glacier Flexible Time | Glacier Deep Archive Time | Cost |
|---|---|---|---|
| **Expedited** | 1-5 minutes | N/A | $0.03/GB + $10/1K requests |
| **Standard** | 3-5 hours | 12 hours | $0.01/GB + $0.05/1K requests |
| **Bulk** | 5-12 hours | 48 hours | $0.0025/GB + $0.025/1K requests |

**S3 Additional Costs:**
- Lifecycle transitions: $0.01 per 1,000 objects transitioned
- S3 Select/Glacier Select: $0.002/GB scanned + $0.0007/GB returned
- S3 Inventory: $0.0025 per million objects listed
- S3 Analytics: $0.10 per million objects monitored per month
- S3 Object Lambda: Lambda invocation costs

### 2.2 EBS Pricing

| Volume Type | Price | IOPS | Throughput |
|---|---|---|---|
| **gp3** | $0.08/GB/mo | 3,000 free, $0.005/IOPS | 125 MB/s free, $0.040/MB/s |
| **gp2** | $0.10/GB/mo | 3 IOPS/GB (burst to 3,000) | Up to 250 MB/s |
| **io2 Block Express** | $0.125/GB/mo | $0.065/IOPS | Up to 4,000 MB/s |
| **io1** | $0.125/GB/mo | $0.065/IOPS | Up to 1,000 MB/s |
| **st1 (Throughput)** | $0.045/GB/mo | N/A | 500 MB/s max |
| **sc1 (Cold)** | $0.015/GB/mo | N/A | 250 MB/s max |

**EBS Snapshots:**
- Standard: $0.05/GB/month (incremental)
- Archive: $0.0125/GB/month (75% cheaper, 24-72 hr restore)
- Fast Snapshot Restore: $0.75/DSU/hour (per AZ, per snapshot)

### 2.3 EFS Pricing

| Feature | Standard | One Zone |
|---|---|---|
| **Standard storage** | $0.30/GB/mo | $0.16/GB/mo |
| **Infrequent Access** | $0.016/GB/mo + $0.01/GB access | $0.0133/GB/mo + $0.01/GB access |
| **Archive** | $0.008/GB/mo + $0.05/GB access | N/A |
| **Provisioned Throughput** | $6.00/MB/s/month | $6.00/MB/s/month |

### 2.4 FSx Pricing

| FSx Type | Storage | Throughput | Use Case |
|---|---|---|---|
| **FSx for Windows** | $0.013/GB/mo (HDD) - $0.23/GB/mo (SSD) | Included | Windows file shares |
| **FSx for Lustre** | $0.14/GB/mo (SSD) | Included based on storage | HPC, ML training |
| **FSx for NetApp ONTAP** | $0.125/GB/mo (SSD) | $0.20/MB/s/mo | Multi-protocol |
| **FSx for OpenZFS** | $0.09/GB/mo (SSD) | Included | Linux migration |

---

## 3. Database Pricing

### 3.1 RDS Pricing

**Components:**
1. Instance hours (per-second, 10-minute minimum)
2. Storage (per GB/month)
3. I/O requests (for Aurora)
4. Backup storage (free up to DB size)
5. Data transfer
6. Multi-AZ (roughly 2× single-AZ for instance + storage)

**RDS Instance Examples (us-east-1, Multi-AZ):**

| Instance | vCPUs | Memory | On-Demand/hr (Multi-AZ) |
|---|---|---|---|
| db.t3.medium | 2 | 4 GB | $0.068 × 2 = $0.136 |
| db.r5.large | 2 | 16 GB | $0.240 × 2 = $0.480 |
| db.r5.2xlarge | 8 | 64 GB | $0.960 × 2 = $1.920 |
| db.r6g.xlarge | 4 | 32 GB | $0.380 × 2 = $0.760 |

**RDS Storage:**
| Type | Cost | Use Case |
|---|---|---|
| gp3 | $0.115/GB/mo | General purpose |
| io1 | $0.125/GB/mo + $0.10/IOPS/mo | High-performance OLTP |
| Magnetic | $0.10/GB/mo | Legacy compatibility |

### 3.2 Aurora Pricing

**Key Differences from RDS:**
- Storage auto-scales in 10 GB increments up to 128 TB
- Storage: $0.10/GB/month
- I/O: $0.20 per million I/O requests (Standard), $0 for Aurora I/O Optimized
- Backtrack: $0.012/million change records
- No storage pre-provisioning needed

**Aurora I/O Optimized (2023+):**
- 30% higher storage cost ($0.225/GB/mo)
- Zero I/O charges
- Best when I/O costs exceed 25% of total Aurora cost

**Aurora Serverless v2:**
- Scales in 0.5 ACU increments (1 ACU = ~2 GB RAM)
- Minimum 0.5 ACU, maximum 128 ACU
- $0.12/ACU/hour
- Best for variable/unpredictable workloads

### 3.3 DynamoDB Pricing

**On-Demand Mode:**
| Operation | Cost |
|---|---|
| Write Request Unit (WRU) | $1.25 per million |
| Read Request Unit (RRU) | $0.25 per million |
| Storage | $0.25/GB/month |

**Provisioned Mode:**
| Resource | Cost |
|---|---|
| Write Capacity Unit (WCU) | $0.00065/WCU/hour ($0.47/WCU/month) |
| Read Capacity Unit (RCU) | $0.00013/RCU/hour ($0.09/RCU/month) |
| Storage | $0.25/GB/month |

**Reserved Capacity (Provisioned only):**
- 1-year or 3-year term
- Up to 76% discount on WCU/RCU

**Additional DynamoDB Costs:**
- Global Tables: 1.5× standard WCU pricing per replica region
- Streams: First 2.5 million reads free, then $0.02/100K reads
- DAX: Instance hours (e.g., dax.r5.large = $0.269/hr)
- Backups: $0.10/GB/month (on-demand), $0.03/GB/month (continuous PITR)
- Data export: $0.11/GB
- DynamoDB Accelerator (DAX) cluster charges

### 3.4 ElastiCache and Redshift

**ElastiCache (Redis/Memcached):**
- Instance hours (similar to EC2 pricing)
- cache.t3.medium: ~$0.068/hr
- cache.r6g.xlarge: ~$0.326/hr
- Reserved nodes: Up to 55% discount (1 or 3 year)

**Redshift:**
- On-Demand: Starting at $0.25/hr (dc2.large)
- Reserved: Up to 75% discount (1 or 3 year)
- Redshift Serverless: $0.375/RPU-hour (billed per second)
- Redshift Spectrum: $5/TB scanned
- Storage: Included in node price (managed storage $0.024/GB/mo for RA3)

---

## 4. Data Transfer Pricing

### 4.1 Data Transfer Overview

```
Data Transfer Pricing Map:
┌──────────────────────────────────────────────────────────────┐
│                    INTERNET                                    │
│    ┌─────────────────────────────────────────────┐           │
│    │  Data IN from Internet → AWS: FREE           │           │
│    │  Data OUT from AWS → Internet:               │           │
│    │    First 100 GB/mo:  $0.09/GB               │           │
│    │    Next 9.9 TB/mo:   $0.085/GB              │           │
│    │    Next 40 TB/mo:    $0.07/GB               │           │
│    │    Over 150 TB/mo:   $0.05/GB               │           │
│    └─────────────────────────────────────────────┘           │
│                           │                                   │
│                           ▼                                   │
│    ┌──────────────── AWS Region ─────────────────┐           │
│    │                                              │           │
│    │  Same AZ:    FREE (private IP)              │           │
│    │              $0.01/GB (public/Elastic IP)    │           │
│    │                                              │           │
│    │  Cross-AZ:   $0.01/GB each direction        │           │
│    │              ($0.02/GB round-trip)           │           │
│    │                                              │           │
│    │  ┌─────────┐    $0.01/GB    ┌─────────┐    │           │
│    │  │  AZ-1a  │◄──────────────▶│  AZ-1b  │    │           │
│    │  └─────────┘                └─────────┘    │           │
│    └──────────────────────────────────────────────┘           │
│              │                            │                   │
│              │  Cross-Region:             │                   │
│              │  $0.02/GB (varies)         │                   │
│              ▼                            ▼                   │
│    ┌─────────────┐              ┌─────────────┐              │
│    │ us-east-1   │◄────────────▶│ eu-west-1   │              │
│    └─────────────┘  $0.02/GB   └─────────────┘              │
└──────────────────────────────────────────────────────────────┘
```

### 4.2 Detailed Transfer Pricing

| Transfer Type | Cost |
|---|---|
| **Internet → AWS (inbound)** | FREE |
| **AWS → Internet (outbound)** | $0.09/GB (first 100 GB, then tiered) |
| **Same AZ (private IP)** | FREE |
| **Same AZ (public/Elastic IP)** | $0.01/GB each way |
| **Cross-AZ (same region)** | $0.01/GB each way ($0.02 round-trip) |
| **Cross-Region** | $0.02/GB (varies by region pair) |
| **VPC Peering (same region)** | $0.01/GB each way (same as cross-AZ) |
| **VPC Peering (cross-region)** | $0.02/GB each way |
| **Transit Gateway (same region)** | $0.02/GB per attachment |
| **Transit Gateway (cross-region peering)** | $0.02/GB |
| **Direct Connect** | $0.02/GB OUT (varies by DX location) |
| **Direct Connect (via Transit VIF)** | $0.02/GB + TGW attachment costs |
| **CloudFront → Internet** | $0.085/GB (cheaper than direct) |
| **CloudFront → Origin (EC2/ALB)** | FREE |
| **S3 → CloudFront** | FREE |
| **S3 → Same-region EC2** | FREE |
| **S3 → Cross-region** | $0.02/GB |

### 4.3 Key Cost Savings Patterns

```
Pattern 1: Use CloudFront for outbound data
Without CloudFront: EC2 → Internet = $0.09/GB
With CloudFront:    EC2 → CloudFront (FREE) → Internet ($0.085/GB)
Saving: ~6% + better performance

Pattern 2: Use VPC Endpoints for S3/DynamoDB
Without endpoint: EC2 → NAT GW → Internet → S3 = $0.045/GB (NAT) + $0.09/GB (data)
With GW endpoint: EC2 → VPC GW Endpoint → S3 = FREE
Saving: $0.135/GB

Pattern 3: Same-AZ placement
Cross-AZ:  $0.01/GB × 2 directions = $0.02/GB round-trip
Same-AZ:   FREE (private IP)
Saving: $0.02/GB per round-trip
```

> **Exam Tip:** Data transfer pricing is HEAVILY tested. Memorize: inbound = free, same-AZ private = free, cross-AZ = $0.01 each way, cross-region = $0.02. CloudFront is cheaper than direct outbound. S3 to same-region is free. VPC Gateway Endpoints eliminate NAT Gateway costs for S3/DynamoDB.

---

## 5. Lambda Pricing

### 5.1 Pricing Components

| Component | Price |
|---|---|
| **Requests** | $0.20 per million requests |
| **Duration** | $0.0000166667/GB-second ($0.06/GB-hour) |
| **Provisioned Concurrency** | $0.0000041667/GB-second (idle) + duration when executing |
| **Ephemeral Storage** | $0.0000000309/GB-second (above 512 MB) |

### 5.2 Duration Pricing Calculation

```
Function: 256 MB memory, 200ms average execution
Invocations: 10 million per month

Requests:
  10,000,000 × $0.20/1M = $2.00

Duration:
  Memory: 256 MB = 0.25 GB
  Duration: 200ms = 0.2 seconds
  GB-seconds: 0.25 × 0.2 = 0.05 GB-seconds per invocation
  Total: 10,000,000 × 0.05 = 500,000 GB-seconds
  Cost: 500,000 × $0.0000166667 = $8.33

Total: $2.00 + $8.33 = $10.33/month

Free tier: 1M requests + 400,000 GB-seconds
After free tier: $10.33 - ($0.20 + $6.67) = $3.46/month
```

### 5.3 Lambda@Edge and CloudFront Functions

| Feature | Lambda@Edge | CloudFront Functions |
|---|---|---|
| **Price per request** | $0.60/million | $0.10/million |
| **Price per duration** | $0.00000625125/128MB/ms | Included |
| **Max execution time** | 5s (viewer), 30s (origin) | 1ms |
| **Memory** | Up to 10 GB | 2 MB |
| **Use case** | Complex logic | Simple transforms |

---

## 6. API Gateway Pricing

### 6.1 REST API vs HTTP API

| Feature | REST API | HTTP API |
|---|---|---|
| **Price per million requests** | $3.50 | $1.00 |
| **Caching** | Yes ($0.02-$3.80/hr) | No |
| **WAF integration** | Yes | No |
| **Usage plans/API keys** | Yes | No |
| **Private endpoints** | Yes | Yes |
| **Lambda integration** | Yes | Yes (simpler) |
| **Cost for 100M req/mo** | $350 | $100 |

### 6.2 WebSocket API

- $1.00 per million connection minutes
- $1.00 per million messages (32 KB each)

> **Exam Tip:** HTTP API is 70% cheaper than REST API. Choose HTTP API unless you need features exclusive to REST API (caching, WAF, usage plans, request validation).

---

## 7. Network Pricing

### 7.1 NAT Gateway

| Component | Cost |
|---|---|
| **Hourly charge** | $0.045/hour ($32.40/month) |
| **Data processing** | $0.045/GB processed |

```
Example: 1 NAT Gateway processing 1 TB/month
Hourly:     $0.045 × 730 hrs = $32.85
Processing: $0.045 × 1,024 GB = $46.08
Total:      $78.93/month

×3 AZs = $236.79/month (just for NAT!)
```

### 7.2 VPC Endpoints

| Endpoint Type | Hourly | Data Processing |
|---|---|---|
| **Gateway Endpoint** (S3, DynamoDB) | FREE | FREE |
| **Interface Endpoint** (PrivateLink) | $0.01/hour/AZ | $0.01/GB |

```
Interface Endpoint example: 3 AZs, 500 GB/month
Hourly: $0.01 × 730 × 3 = $21.90
Data:   $0.01 × 500 = $5.00
Total:  $26.90/month

vs NAT Gateway for same: $78.93/month
Saving: $52.03/month
```

### 7.3 Elastic Load Balancing

| Type | Hourly | LCU/NLCU/GLCU |
|---|---|---|
| **ALB** | $0.0225/hr | $0.008/LCU-hr |
| **NLB** | $0.0225/hr | $0.006/NLCU-hr |
| **GLB** | $0.0125/hr | $0.008/GLCU-hr |
| **CLB (Classic)** | $0.025/hr | $0.008/GB processed |

**LCU Dimensions (ALB):**
- New connections/sec: 25
- Active connections/min: 3,000
- Processed bytes/hr: 1 GB
- Rule evaluations/sec: 1,000
- You pay for the dimension with highest usage

### 7.4 PrivateLink (Endpoint Services)

- Endpoint owner (service provider): $0.01/hr + $0.01/GB
- Endpoint consumer: $0.01/hr + $0.01/GB

---

## 8. Container Pricing

### 8.1 ECS Pricing

| Launch Type | Compute Cost | ECS Fee |
|---|---|---|
| **EC2** | Standard EC2 pricing | FREE |
| **Fargate** | Per vCPU + memory + storage | N/A |

### 8.2 Fargate Pricing

| Resource | Linux Price | Windows Price |
|---|---|---|
| **vCPU per hour** | $0.04048 | $0.09148 |
| **Memory per GB per hour** | $0.004445 | $0.01005 |
| **Ephemeral storage** | $0.000111/GB/hour (>20 GB) | Same |

```
Example: 2 vCPU, 4 GB task running 24/7
vCPU:   2 × $0.04048 × 730 = $59.10
Memory: 4 × $0.004445 × 730 = $12.98
Total:  $72.08/month

Fargate Spot: Up to 70% discount ($21.62/month)
```

### 8.3 EKS Pricing

| Component | Cost |
|---|---|
| **EKS Cluster** | $0.10/hour ($73/month) per cluster |
| **EC2 nodes** | Standard EC2 pricing |
| **Fargate pods** | Standard Fargate pricing |
| **EKS Anywhere** | $0/cluster (free license, optional support) |

> **Exam Tip:** ECS on EC2 has no ECS fee (just EC2 costs). EKS always has a $0.10/hr cluster fee plus compute. Fargate = pay per task (no idle capacity waste). Fargate Spot = up to 70% off for fault-tolerant containers.

---

## 9. Free Tier Details

### 9.1 Always Free

| Service | Free Amount |
|---|---|
| Lambda | 1M requests, 400,000 GB-seconds/month |
| DynamoDB | 25 GB, 25 WCU, 25 RCU |
| S3 Glacier | 10 GB retrieval/month |
| CloudWatch | 10 custom metrics, 10 alarms |
| SNS | 1M publishes, 100K HTTP/S deliveries |
| SQS | 1M requests/month |
| SES | 62,000 outbound messages (from EC2) |
| CodeBuild | 100 build minutes/month |
| CodePipeline | 1 active pipeline |
| X-Ray | 100K traces, 1M scans |

### 9.2 12-Month Free (New Accounts)

| Service | Free Amount |
|---|---|
| EC2 | 750 hours/month (t2.micro or t3.micro) |
| RDS | 750 hours/month (db.t2.micro or db.t3.micro) |
| S3 | 5 GB Standard, 20K GET, 2K PUT |
| CloudFront | 1 TB transfer, 10M requests |
| ElastiCache | 750 hours (cache.t2.micro or cache.t3.micro) |
| ELB | 750 hours + 15 LCUs |
| EBS | 30 GB (gp2/gp3) |
| Data Transfer | 100 GB out to internet |

---

## 10. Pricing Calculator Usage

### 10.1 AWS Pricing Calculator

**URL:** https://calculator.aws

**Key Features:**
- Estimate monthly costs for architecture
- Compare On-Demand vs RI vs Savings Plans
- Share estimates via URL
- Export to CSV

### 10.2 Cost Estimation Best Practices

1. **Include ALL cost components:**
   - Compute (instances)
   - Storage (EBS, S3, snapshots)
   - Database (instance + storage + I/O + backup)
   - Data transfer (cross-AZ, cross-region, internet)
   - Network (NAT GW, LB, endpoints)
   - Support plan

2. **Account for utilization:**
   - Dev/test: 8-12 hours/day (stop overnight)
   - Production: 24/7
   - Auto Scaling: Average vs peak capacity

3. **Factor in discounts:**
   - Free tier (first 12 months)
   - Volume discounts (S3, data transfer)
   - RI/Savings Plans
   - AWS credits

---

## 11. Exam Scenarios with Cost Calculation

### Scenario 1: EC2 Cost Comparison

**Question:** An application runs on 10 × m5.xlarge instances 24/7 in us-east-1. Which purchasing option provides the most savings for a guaranteed 3-year deployment?

**Calculation:**
```
On-Demand: 10 × $0.192/hr × 8,760 hrs/yr × 3 yrs = $50,457
RI (All Upfront, 3yr): 10 × ~$2,556 = $25,560 (49% savings)
EC2 Savings Plan (3yr, All Upfront): ~$25,560 (similar to RI)
Convertible RI (3yr, All Upfront): ~$29,000 (42% savings)
```

**Answer:** Standard RI or EC2 Instance Savings Plan, All Upfront, 3-year term.

---

### Scenario 2: Data Transfer Optimization

**Question:** An application in us-east-1 transfers 10 TB/month to the internet. How can they reduce data transfer costs?

**Answer:** Use **Amazon CloudFront** as CDN.

**Calculation:**
```
Direct EC2 → Internet: 10 TB × $0.085/GB avg = $870/month
With CloudFront:
  EC2 → CloudFront: FREE (origin fetch)
  CloudFront → Internet: 10 TB × $0.085/GB = $850/month
  + Cache hit ratio 80%: Only 2 TB fetched from origin
  Effective cost: ~$200-300/month (cached responses, less origin load)
  
CloudFront also offers free tier: 1 TB/month
```

---

### Scenario 3: NAT Gateway Cost Reduction

**Question:** A company spends $5,000/month on NAT Gateway data processing for S3 API calls from private subnets. How can they eliminate this cost?

**Answer:** Use **S3 Gateway Endpoint** (free).

```
Current:    EC2 → NAT Gateway ($0.045/GB) → Internet → S3
            $5,000/month ÷ $0.045/GB ≈ 111 TB/month through NAT

With Gateway Endpoint:
            EC2 → S3 Gateway Endpoint → S3
            Cost: $0 (gateway endpoints are free)
            
Savings: $5,000/month = $60,000/year
```

---

### Scenario 4: Database Pricing

**Question:** A company runs a database with 200 GB storage, average 5,000 reads/sec and 500 writes/sec, access patterns are unpredictable. Which DynamoDB pricing mode and why?

**Answer:** **On-Demand mode** for unpredictable workloads.

```
On-Demand calculation:
Reads: 5,000/sec × 86,400 sec/day × 30 days = 12.96 billion reads/month
  Strong consistency (1 RRU per 4KB): 12.96B × $0.25/1M = $3,240
Writes: 500/sec × 86,400 × 30 = 1.296 billion writes/month
  1 WRU per 1KB: 1.296B × $1.25/1M = $1,620
Storage: 200 GB × $0.25 = $50

Total On-Demand: ~$4,910/month

Provisioned calculation:
RCU: 5,000 × $0.09/month = $450 (much cheaper!)
WCU: 500 × $0.47/month = $235
Storage: $50
Total Provisioned: ~$735/month

BUT the question says "unpredictable" — spikes could be 10× baseline
On-Demand handles spikes automatically
Provisioned would need auto-scaling (slower to react) or massive over-provision
```

**Better Answer:** Start with **On-Demand** to learn traffic patterns, then switch to **Provisioned with Auto Scaling** once patterns are understood. If predictable at a later stage, provisioned + reserved capacity gives deepest discount.

---

> **Key Exam Tips Summary:**
> 1. **Data IN to AWS** = always FREE
> 2. **Same AZ, private IP** = FREE data transfer
> 3. **Cross-AZ** = $0.01/GB each way
> 4. **S3 Gateway Endpoint** = FREE (eliminates NAT GW costs for S3)
> 5. **CloudFront → origin** = FREE transfer
> 6. **NAT Gateway** = $0.045/hr + $0.045/GB (expensive at scale!)
> 7. **Savings Plans** = most flexible commitment model
> 8. **Standard RI** = deepest discount, least flexibility
> 9. **Convertible RI** = good discount, can change instance family
> 10. **Spot** = up to 90% discount, 2-minute interruption warning
> 11. **Dedicated Host** = BYOL (Oracle, SQL Server per-socket licensing)
> 12. **HTTP API** = 70% cheaper than REST API
> 13. **Fargate Spot** = up to 70% off for fault-tolerant containers
> 14. **Aurora I/O Optimized** = when I/O > 25% of total Aurora cost
> 15. **DynamoDB On-Demand** = unpredictable workloads, **Provisioned** = steady state
