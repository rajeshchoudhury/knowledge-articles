# Right-Sizing and Reserved Capacity — AWS SAP-C02 Domain 4

## Table of Contents
1. [Right-Sizing Methodology](#1-right-sizing-methodology)
2. [AWS Compute Optimizer Deep Dive](#2-aws-compute-optimizer-deep-dive)
3. [Reserved Instance Planning](#3-reserved-instance-planning)
4. [Savings Plans Planning](#4-savings-plans-planning)
5. [Spot Usage Patterns](#5-spot-usage-patterns)
6. [RDS Right-Sizing and Reserved Capacity](#6-rds-right-sizing-and-reserved-capacity)
7. [ElastiCache Reserved Nodes](#7-elasticache-reserved-nodes)
8. [Redshift Reserved Nodes](#8-redshift-reserved-nodes)
9. [DynamoDB Reserved Capacity vs On-Demand](#9-dynamodb-reserved-capacity-vs-on-demand)
10. [OpenSearch Reserved Instances](#10-opensearch-reserved-instances)
11. [Exam Scenarios Comparing Purchase Options](#11-exam-scenarios-comparing-purchase-options)

---

## 1. Right-Sizing Methodology

### 1.1 Four-Step Process

```
Step 1: COLLECT                Step 2: ANALYZE
┌────────────────────┐        ┌────────────────────┐
│ CloudWatch Metrics │        │ Identify Patterns  │
│ (14-30 days min)   │        │ • Peak times       │
│ • CPU utilization  │───────▶│ • Average usage    │
│ • Memory (agent)   │        │ • P95/P99 usage    │
│ • Network          │        │ • Growth trends    │
│ • Disk I/O         │        │                    │
└────────────────────┘        └────────┬───────────┘
                                       │
Step 4: MONITOR                Step 3: IMPLEMENT
┌────────────────────┐        ┌────────────────────┐
│ Post-change verify │        │ Apply changes      │
│ • Performance OK?  │◀───────│ • Resize instance  │
│ • Alarms quiet?    │        │ • Change type      │
│ • Users happy?     │        │ • Test first       │
│ • Re-evaluate in   │        │ • Maintenance       │
│   30 days          │        │   window            │
└────────────────────┘        └────────────────────┘
```

### 1.2 Key Metrics for Right-Sizing

| Metric | Under-Provisioned Indicator | Over-Provisioned Indicator |
|---|---|---|
| **CPU** | >80% sustained | <30% average, <60% peak |
| **Memory** | >80% sustained, swap usage | <40% average |
| **Network** | Approaching instance limit | <20% of instance capacity |
| **Disk IOPS** | Hitting volume IOPS limit | <30% of provisioned IOPS |
| **Disk Throughput** | Hitting MB/s limit | <30% of provisioned throughput |

### 1.3 Right-Sizing Categories

```
Category 1: IDLE (Terminate or Stop)
┌──────────────────────────────────────────┐
│ CPU avg < 5%, Network < 1 MB/s          │
│ No connections for 7+ days               │
│ Action: Terminate (or snapshot + stop)   │
│ Savings: 100%                            │
└──────────────────────────────────────────┘

Category 2: VASTLY OVER-PROVISIONED (Downsize 2+ sizes)
┌──────────────────────────────────────────┐
│ CPU avg < 10%, peak < 30%               │
│ Memory avg < 20%                         │
│ Current: m5.4xlarge (16 vCPU, 64 GB)   │
│ Recommended: m5.large (2 vCPU, 8 GB)   │
│ Savings: 75%                             │
└──────────────────────────────────────────┘

Category 3: SLIGHTLY OVER-PROVISIONED (Downsize 1 size)
┌──────────────────────────────────────────┐
│ CPU avg 20-40%, peak 50-70%             │
│ Memory avg 30-50%                        │
│ Current: m5.2xlarge (8 vCPU, 32 GB)    │
│ Recommended: m5.xlarge (4 vCPU, 16 GB) │
│ Savings: 50%                             │
└──────────────────────────────────────────┘

Category 4: WELL-SIZED (No change)
┌──────────────────────────────────────────┐
│ CPU avg 40-60%, peak 70-85%             │
│ Memory avg 50-70%                        │
│ Headroom sufficient for peaks            │
│ Action: No change, continue monitoring   │
└──────────────────────────────────────────┘

Category 5: UNDER-PROVISIONED (Upsize)
┌──────────────────────────────────────────┐
│ CPU avg > 80%, peak > 95%               │
│ Memory > 80%, swap in use               │
│ Current: m5.large (2 vCPU, 8 GB)       │
│ Recommended: m5.xlarge (4 vCPU, 16 GB) │
│ Note: Performance issue risk             │
└──────────────────────────────────────────┘
```

### 1.4 Instance Family Optimization

Beyond sizing, consider changing instance families:

| Current Instance | Workload Profile | Recommended | Savings |
|---|---|---|---|
| m5.xlarge (general) | CPU-bound, not memory-intensive | c5.xlarge (compute) | ~15% |
| m5.2xlarge (general) | Memory-bound, not CPU-intensive | r5.xlarge (memory, smaller) | ~40% |
| m5.xlarge (x86) | Standard workload | m6g.xlarge (Graviton) | ~20% |
| c5.2xlarge (compute) | Burstable, low avg CPU | t3.2xlarge (burstable) | ~30% |

> **Exam Tip:** Right-sizing should ALWAYS happen before purchasing RIs or Savings Plans. Right-size first → then commit to the optimized size.

---

## 2. AWS Compute Optimizer Deep Dive

### 2.1 Supported Resources

| Resource | Metrics Used | Recommendation Type |
|---|---|---|
| **EC2 Instances** | CPU, memory, network, EBS | Instance type and size |
| **EC2 Auto Scaling Groups** | Same + ASG config | Instance type and ASG settings |
| **EBS Volumes** | IOPS, throughput | Volume type, size, IOPS |
| **Lambda Functions** | Memory, duration, invocations | Memory size |
| **ECS on Fargate** | CPU, memory | Task size (CPU and memory) |

### 2.2 Enhanced Infrastructure Metrics

```
Standard (Free):
└── 14 days of CloudWatch data
    └── Recommendations based on 14-day window

Enhanced ($0.0003360215 per resource per hour):
└── Up to 93 days of CloudWatch data
    └── Better recommendations for cyclical workloads
    └── Monthly or quarterly patterns captured
```

### 2.3 Recommendation Findings

| Finding | Description |
|---|---|
| **Under-provisioned** | Resource is too small; performance risk |
| **Over-provisioned** | Resource is too large; cost waste |
| **Optimized** | Resource is well-matched |
| **None** | Insufficient data (need 14+ days) |

### 2.4 EC2 Recommendation Detail

```
Current Instance: m5.4xlarge
Region: us-east-1
Cost: $0.768/hr ($560/month)

Recommendation 1 (Top):
├── Instance: m5.xlarge
├── Cost: $0.192/hr ($140/month)
├── Savings: $420/month (75%)
├── Performance Risk: Low
│   CPU: Peak 35% on xlarge (vs 9% on 4xlarge)
│   Memory: Peak 45% (vs 11%)
│   Network: Well within limits
└── Migration Effort: Low (stop/start with type change)

Recommendation 2:
├── Instance: m6g.xlarge (Graviton)
├── Cost: $0.154/hr ($112/month)
├── Savings: $448/month (80%)
├── Performance Risk: Low (Graviton is ~20% better perf/$)
└── Migration Effort: Medium (test ARM compatibility)

Recommendation 3:
├── Instance: c5.xlarge
├── Cost: $0.170/hr ($124/month)
├── Savings: $436/month (78%)
├── Performance Risk: Low (workload is CPU-bound)
└── Migration Effort: Low
```

### 2.5 Lambda Recommendations

```
Current:
├── Function: processOrders
├── Memory: 512 MB
├── Avg Duration: 800 ms
├── Invocations: 100K/month
├── Monthly Cost: $5.42

Recommendation:
├── Memory: 1024 MB
├── Projected Duration: 420 ms (faster due to more CPU)
├── Projected Cost: $5.70 (+$0.28, but 2× faster)
├── Finding: Under-provisioned (duration could be reduced)

OR

├── Memory: 256 MB
├── Projected Duration: 1600 ms (slower, less CPU)
├── Projected Cost: $5.42 (same cost, slower execution)
├── Finding: Could reduce memory if latency is acceptable
```

### 2.6 EBS Volume Recommendations

```
Current Volume:
├── Type: io1
├── Size: 500 GB
├── Provisioned IOPS: 10,000
├── Cost: $62.50 + $650 = $712.50/month

Actual Usage:
├── Max IOPS: 3,200 (32% of provisioned)
├── Avg IOPS: 800 (8% of provisioned)
├── Throughput: 50 MB/s (within gp3 capabilities)

Recommendation:
├── Type: gp3
├── Size: 500 GB
├── IOPS: 3,500 (includes 3,000 free)
├── Cost: $40 + $2.50 (500 extra IOPS) = $42.50/month
├── Savings: $670/month (94%)
└── Risk: Low (actual usage well within gp3 limits)
```

---

## 3. Reserved Instance Planning

### 3.1 RI Purchase Decision Framework

```
Is the workload running 24/7?
├── No → Don't buy RI (use On-Demand, Spot, or Savings Plan)
│
└── Yes → Will it run for at least 1 year?
    ├── No → On-Demand or 1-year Savings Plan
    │
    └── Yes → Will it run for 3 years?
        ├── Yes → 3-year All Upfront (maximum savings)
        │         ├── Instance family certain? → Standard RI or EC2 SP
        │         └── Might change? → Convertible RI or Compute SP
        │
        └── Uncertain → 1-year term
            ├── Cash available? → All Upfront
            ├── Some cash? → Partial Upfront
            └── No cash? → No Upfront
```

### 3.2 Coverage Target Strategy

```
Optimal RI/SP Coverage Strategy:
┌──────────────────────────────────────────────────────────┐
│                                                          │
│  RI/SP Coverage: 70-80% of steady-state                 │
│  ┌─────────────────────────────────────────┐            │
│  │████████████████████████████████░░░░░░░░░│            │
│  │        Reserved (70-80%)        On-Demand│            │
│  └─────────────────────────────────────────┘            │
│                                                          │
│  WHY NOT 100%?                                          │
│  • Workloads change (20% flexibility buffer)            │
│  • Over-purchasing wastes money (unused RIs)            │
│  • Some usage is variable (Spot/On-Demand is cheaper)   │
│                                                          │
│  The "sweet spot" breakdown:                            │
│  ├── 60-70%: RIs / EC2 Instance Savings Plans          │
│  │   (steady, known instance families)                  │
│  ├── 10-15%: Compute Savings Plans                     │
│  │   (covers variable instance families + Fargate)      │
│  ├── 10-15%: On-Demand                                 │
│  │   (fluctuating workloads, new services)              │
│  └── 5-10%: Spot                                       │
│      (fault-tolerant workloads)                         │
└──────────────────────────────────────────────────────────┘
```

### 3.3 RI Modification

**Standard RI Modifications (No exchange needed):**
- Change AZ within same region (if region-scoped, this is automatic)
- Split: 1 × r5.2xlarge → 2 × r5.xlarge (using size flexibility factors)
- Merge: 2 × r5.xlarge → 1 × r5.2xlarge

**Convertible RI Exchange:**
- Change instance family (m5 → c5)
- Change OS (Linux → Windows)
- Change tenancy (default → dedicated)
- **Must be equal or greater value**

### 3.4 RI Marketplace

- Sell unused Standard RIs (not Convertible)
- Third-party marketplace within AWS
- Receive remaining value minus fees
- Buyer gets remaining term at discount
- Seller can recoup some investment if workload changes

### 3.5 Size Flexibility (Linux Standard RIs)

```
Normalization Factor Table:
Instance Size    Factor
──────────────────────
nano              0.25
micro             0.5
small             1
medium            2
large             4
xlarge            8
2xlarge          16
4xlarge          32
8xlarge          64
9xlarge          72
10xlarge         80
12xlarge         96
16xlarge        128
18xlarge        144
24xlarge        192
metal           192

Example: 1 × m5.xlarge RI (factor 8) covers any combination:
• 1 × m5.xlarge (8)
• 2 × m5.large (4+4 = 8)
• 8 × m5.small (1×8 = 8)
• 1 × m5.large (4) + 4 × m5.small (4×1 = 4) = 8
• CANNOT cover m5.2xlarge (16) — insufficient factors
```

---

## 4. Savings Plans Planning

### 4.1 Compute vs EC2 Instance Savings Plans

```
Scenario: Company spending $50/hr on EC2 across multiple families

Option A: EC2 Instance Savings Plan ($40/hr commitment)
├── 72% discount on committed amount
├── Only applies to specific family+region (e.g., m5 in us-east-1)
├── Monthly cost: $40/hr × 730 = $29,200 (at discount)
│   + $10/hr On-Demand × 730 = $7,300
├── Total: $36,500
├── Savings: $36,500 vs $36,500 → depends on discount depth

Option B: Compute Savings Plan ($40/hr commitment)
├── 66% discount on committed amount
├── Applies to ANY EC2, Fargate, Lambda, ANY region
├── Monthly cost: $40/hr × 730 = $29,200 (at discount)
│   + $10/hr On-Demand × 730 = $7,300
├── Total: $36,500

Key difference: 
EC2 Instance SP: ~6% deeper discount BUT locked to family+region
Compute SP: Slightly less discount BUT covers everything
```

### 4.2 Commitment Sizing

```
How to size your commitment:

Step 1: Look at Cost Explorer Savings Plans recommendations
└── Shows recommended hourly commitment based on past usage

Step 2: Analyze steady-state spend
└── Minimum consistent hourly spend across services
    (use 7-day or 30-day rolling minimum)

Step 3: Be conservative
└── Commit to 70-80% of steady-state minimum
    (leave 20-30% for flexibility)

Example:
Daily spend pattern (hourly):
  12 AM - 6 AM:  $20/hr (lowest)
  6 AM - 12 PM:  $45/hr
  12 PM - 6 PM:  $50/hr (highest)
  6 PM - 12 AM:  $35/hr

Minimum: $20/hr
Conservative commitment: $20 × 0.80 = $16/hr

Result: $16/hr committed (gets discount on $16 of every hour)
        Remaining $4-34/hr at On-Demand
```

### 4.3 Savings Plans Utilization Monitoring

```
Target: >95% utilization

If utilization < 90%:
├── Over-committed → commitment is being wasted
├── Action: Wait for current plan to expire, reduce next commitment
│
If utilization 90-100%:
├── Good balance
│
If coverage < 70%:
├── Under-committed → opportunity for more savings
├── Action: Purchase additional Savings Plan
```

---

## 5. Spot Usage Patterns

### 5.1 Interruption Rate Analysis

```
Average Spot Interruption Rates (historical):

Instance Type     Interruption Rate    Risk Level
──────────────────────────────────────────────────
m5.large             5-8%              Low
m5.xlarge            4-7%              Low
c5.xlarge            3-6%              Low
r5.large             5-10%             Medium
g4dn.xlarge          10-15%            Medium-High
p3.2xlarge           15-25%            High

Strategy: Use instances with <10% interruption rate
Diversify across 3+ instance types and 3+ AZs
```

### 5.2 Spot Best Practices

| Practice | Implementation |
|---|---|
| **Diversify** | Use 6+ instance types across 3+ AZs |
| **Capacity optimized** | Use `priceCapacityOptimized` allocation |
| **Checkpointing** | Save state to S3/DynamoDB every N minutes |
| **Graceful handling** | Monitor metadata + EventBridge for interruption |
| **Mixed fleet** | On-Demand base (20%) + Spot (80%) |
| **Rebalance recommendation** | Handle EC2 rebalance recommendations proactively |

### 5.3 Fallback Strategies

```
Strategy 1: Mixed Instance ASG
Primary: Spot (75%)
Fallback: On-Demand (25% guaranteed)

Strategy 2: Spot Fleet with OD fallback
Spot Fleet: 10 instances target
If capacity unavailable: Launch On-Demand up to 10

Strategy 3: Multi-Region Spot
Region 1: Try Spot (us-east-1)
Region 2: Try Spot (us-west-2) if insufficient in Region 1
Fallback: On-Demand in any available region
```

---

## 6. RDS Right-Sizing and Reserved Capacity

### 6.1 RDS Right-Sizing

```
Analysis:
┌──────────────────────────────────────────────────────┐
│ RDS Instance: production-db (db.r5.4xlarge)          │
│ Cost: $1.92/hr ($1,401/month)                        │
│                                                       │
│ Performance Insights (30 days):                       │
│ ├── CPU Average: 15%                                 │
│ ├── CPU Peak: 45%                                    │
│ ├── Memory Average: 35% (44.8 GB of 128 GB)        │
│ ├── Connections Average: 50 (of 8,000 max)          │
│ ├── Read IOPS: 500 avg, 2,000 peak                  │
│ ├── Write IOPS: 200 avg, 800 peak                   │
│ └── Storage: 200 GB used of 500 GB allocated        │
│                                                       │
│ Recommendation: db.r5.xlarge (4 vCPU, 32 GB)        │
│ ├── CPU headroom: 45% of 4 vCPU = ~2 vCPU needed   │
│ │   r5.xlarge provides 4 vCPU ✓                     │
│ ├── Memory: 35% of 128 GB = ~45 GB needed           │
│ │   r5.xlarge provides 32 GB ⚠ (tight)             │
│ │   Better: r5.2xlarge (64 GB) for safety           │
│ ├── Connections: 50 of 4,000 max ✓                  │
│ └── IOPS: gp3 with 3,000 IOPS base ✓              │
│                                                       │
│ Recommended: db.r5.2xlarge                           │
│ Cost: $0.96/hr ($700/month)                          │
│ Savings: $701/month (50%)                            │
└──────────────────────────────────────────────────────┘
```

### 6.2 RDS Reserved Instances

| Feature | Details |
|---|---|
| **Terms** | 1-year or 3-year |
| **Payment** | All Upfront, Partial Upfront, No Upfront |
| **Discount** | Up to 69% (3-year All Upfront) |
| **Multi-AZ** | Must match deployment configuration |
| **Engine** | Must match (MySQL RI doesn't apply to PostgreSQL) |
| **Size Flexibility** | Available for MySQL, MariaDB, PostgreSQL, Oracle BYOL |
| **Marketplace** | Cannot be sold |

```
RDS RI Example: db.r5.2xlarge Multi-AZ (PostgreSQL)

On-Demand: $1.92/hr × 730 = $1,401.60/month

1-year RI (All Upfront): ~$8,400/year = $700/month (50% savings)
3-year RI (All Upfront): ~$17,000/3yr = $472/month (66% savings)
```

---

## 7. ElastiCache Reserved Nodes

### 7.1 Key Details

| Feature | Details |
|---|---|
| **Engines** | Redis, Memcached |
| **Terms** | 1-year or 3-year |
| **Payment** | All Upfront, Partial, No Upfront |
| **Discount** | Up to 55% |
| **Flexibility** | Must match exact node type |
| **Modification** | Cannot modify; purchase new if needs change |

### 7.2 Example

```
ElastiCache Redis Cluster:
3 × cache.r6g.xlarge (1 primary + 2 replicas)

On-Demand: 3 × $0.326/hr × 730 = $714/month

1-year All Upfront: ~$4,700/year = $392/month (45% savings)
3-year All Upfront: ~$9,600/3yr = $267/month (63% savings)
```

---

## 8. Redshift Reserved Nodes

### 8.1 Key Details

| Feature | Details |
|---|---|
| **Node Types** | DC2, RA3 |
| **Terms** | 1-year or 3-year |
| **Payment** | All Upfront, Partial, No Upfront |
| **Discount** | Up to 75% (3-year) |
| **Flexibility** | Must match node type exactly |

### 8.2 Example

```
Redshift Cluster: 4 × ra3.4xlarge

On-Demand: 4 × $3.26/hr × 730 = $9,519/month

1-year All Upfront: ~$70,000/year = $5,833/month (39% savings)
3-year All Upfront: ~$113,000/3yr = $3,139/month (67% savings)

Alternative: Redshift Serverless ($0.375/RPU-hour)
If usage is <40% of month: Serverless might be cheaper
```

---

## 9. DynamoDB Reserved Capacity vs On-Demand

### 9.1 Comparison

```
Scenario: 1,000 WCU + 5,000 RCU (constant)

On-Demand Mode:
├── Writes: 1,000/sec × 2.592M sec/mo × $1.25/1M = $3,240
├── Reads: 5,000/sec × 2.592M sec/mo × $0.25/1M = $3,240
└── Total: $6,480/month

Provisioned Mode:
├── WCU: 1,000 × $0.00065/hr × 730 = $475
├── RCU: 5,000 × $0.00013/hr × 730 = $475
└── Total: $950/month (85% cheaper!)

Provisioned + Reserved (1-year):
├── WCU: 1,000 × ~$0.00028/hr × 730 + upfront = ~$285/month amortized
├── RCU: 5,000 × ~$0.00006/hr × 730 + upfront = ~$285/month amortized
└── Total: ~$570/month (91% cheaper than On-Demand!)

Provisioned + Reserved (3-year):
└── Total: ~$350/month (95% cheaper than On-Demand!)
```

### 9.2 When to Use Each

| Mode | Use When |
|---|---|
| **On-Demand** | New tables, unpredictable traffic, spiky workloads, <100 WCU/RCU needed |
| **Provisioned** | Known traffic patterns, steady state, cost-sensitive |
| **Provisioned + Auto Scaling** | Mostly steady with some variation (±50%) |
| **Provisioned + Reserved** | Guaranteed steady traffic for 1-3 years |

---

## 10. OpenSearch Reserved Instances

### 10.1 Key Details

| Feature | Details |
|---|---|
| **Terms** | 1-year or 3-year |
| **Payment** | All Upfront, Partial, No Upfront |
| **Discount** | Up to 50% |
| **Coverage** | Instance hours only (not storage or data transfer) |
| **Flexibility** | Must match instance type |

### 10.2 Example

```
OpenSearch Domain: 3 × r6g.xlarge.search

On-Demand: 3 × $0.335/hr × 730 = $734/month
1-year All Upfront: ~$5,100/year = $425/month (42% savings)
3-year All Upfront: ~$10,200/3yr = $283/month (61% savings)
```

---

## 11. Exam Scenarios Comparing Purchase Options

### Scenario 1: EC2 Pricing Decision

**Question:** A company runs 20 m5.2xlarge instances 24/7 for a production workload. The workload is stable and will continue for at least 3 years. They also run 10 c5.xlarge instances for batch processing that runs 12 hours/day using Spot. What purchase options should they use?

**Answer:**
- **20 m5.2xlarge:** EC2 Instance Savings Plan (3-year, All Upfront) — deepest discount for known family+region
- **10 c5.xlarge batch:** Continue using Spot (70-90% savings, batch workload is fault-tolerant)
- Don't buy RIs for Spot workloads — they're already cheaper than RI pricing

---

### Scenario 2: Mixed Workload Optimization

**Question:** A company has the following monthly spend:
- EC2 (m5 family): $20,000 (steady)
- EC2 (c5 family): $10,000 (steady)
- EC2 (various): $5,000 (variable)
- Fargate: $8,000 (growing)
- Lambda: $2,000 (variable)
Total: $45,000/month

What commitment strategy?

**Answer:**
1. **EC2 Instance SP (m5, us-east-1):** $18/hr commitment (~$13,140/mo at discount)
   - Covers most of the $20K m5 spend
2. **Compute SP:** $12/hr commitment (~$8,760/mo at discount)
   - Covers c5, Fargate, Lambda across any region
3. **Remaining ~$10K:** On-Demand (variable and growth workloads)

**Estimated total after optimization:** ~$32,000/month (29% savings)

---

### Scenario 3: Right-Size Before Commit

**Question:** Compute Optimizer shows 30 out of 50 EC2 instances are over-provisioned by 1-2 sizes. The company wants to buy Reserved Instances. What should they do first?

**Answer:** **Right-size FIRST, then purchase RIs.**

**Process:**
1. Right-size 30 instances (estimated 40% reduction in compute spend)
2. Wait 2-4 weeks to validate performance with new sizes
3. Analyze new steady-state spend
4. Purchase Savings Plans or RIs for the right-sized instances
5. If they buy RIs first and then right-size, the RIs won't match the new instances (waste)

---

### Scenario 4: Standard vs Convertible RI

**Question:** A company is migrating from Intel-based m5 instances to Graviton-based m6g instances over the next 2 years. They need Reserved capacity for 3 years. What type?

**Answer:** **Convertible Reserved Instances** (3-year term)

**Reasoning:**
- Currently m5, migrating to m6g → need to change instance family
- Standard RI cannot change family → would be stranded on m5
- Convertible RI can exchange m5 → m6g when ready
- Trade-off: 66% vs 72% discount, but flexibility is critical here
- Alternative: Compute Savings Plan (automatically applies to m6g when they switch)

---

### Scenario 5: DynamoDB Pricing

**Question:** A DynamoDB table handles 10,000 reads/sec and 2,000 writes/sec consistently. The application is in production for the foreseeable future. Currently using On-Demand mode and spending $15,000/month. What's the most cost-effective option?

**Answer:** Switch to **Provisioned mode with Auto Scaling + Reserved Capacity (3-year).**

```
Current (On-Demand): $15,000/month

Provisioned:
WCU: 2,000 × $0.47/mo = $940
RCU: 10,000 × $0.09/mo = $900
Total: $1,840/month (88% savings)

Provisioned + 3-year Reserved:
Estimated: ~$900/month (94% savings!)
```

---

### Scenario 6: Spot vs Reserved for Variable Workload

**Question:** A company runs a data processing pipeline 8 hours/day, 5 days/week on 20 c5.2xlarge instances. The processing can tolerate interruptions and restart from checkpoints. Should they use Spot or Reserved Instances?

**Answer:** **Spot Instances** (NOT Reserved Instances)

**Reasoning:**
```
Usage: 8 hrs/day × 5 days/week × 4.33 weeks = 173 hrs/month (24% utilization)

RI cost (1-year, All Upfront):
20 × $0.204/hr × 730 = $2,978/month (paying for 730 hrs but using 173)
Effective hourly rate: $2,978 / (20 × 173) = $0.86/hr → MORE expensive!

Spot cost:
20 × $0.068/hr (Spot ~80% off) × 173 = $235/month
Plus occasional On-Demand fallback

On-Demand cost:
20 × $0.340/hr × 173 = $1,176/month

Winner: Spot ($235/month) — workload is fault-tolerant and runs <25% of time
```

**Rule of thumb:** RIs make sense only for workloads running >60-70% of the time. Below that, On-Demand or Spot is cheaper.

---

> **Key Exam Tips Summary:**
> 1. **Right-size BEFORE buying RIs/SPs** — avoid committing to oversized instances
> 2. **Compute Optimizer** needs 14+ days of data; enhanced mode for up to 93 days
> 3. **Standard RI** = deepest discount (72%), locked to family/region
> 4. **Convertible RI** = less discount (66%), can change family/OS/tenancy
> 5. **Compute SP** = most flexible (any instance, Fargate, Lambda, any region)
> 6. **EC2 Instance SP** = deeper discount than Compute SP, locked to family+region
> 7. **RI size flexibility** = 1 xlarge = 2 large = 4 medium (Linux, Standard only)
> 8. **Don't buy RIs for <60% utilization** — Spot or On-Demand is cheaper
> 9. **Spot** = fault-tolerant, checkpoint-capable workloads (up to 90% savings)
> 10. **DynamoDB Provisioned** = 85%+ cheaper than On-Demand for steady traffic
> 11. **Target RI/SP coverage:** 70-80% (leave room for flexibility)
> 12. **Target RI/SP utilization:** >90% (don't over-purchase)
