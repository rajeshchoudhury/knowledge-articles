# Cost Optimization Strategies — AWS SAP-C02 Domain 4

## Table of Contents
1. [Right-Sizing](#1-right-sizing)
2. [Reserved Capacity Planning](#2-reserved-capacity-planning)
3. [Savings Plans Optimization](#3-savings-plans-optimization)
4. [Spot Instance Strategies](#4-spot-instance-strategies)
5. [Storage Optimization](#5-storage-optimization)
6. [Database Optimization](#6-database-optimization)
7. [Network Cost Optimization](#7-network-cost-optimization)
8. [Serverless Cost Optimization](#8-serverless-cost-optimization)
9. [Container Cost Optimization](#9-container-cost-optimization)
10. [Architecture Cost Patterns](#10-architecture-cost-patterns)
11. [Exam Scenarios](#11-exam-scenarios)

---

## 1. Right-Sizing

### 1.1 Overview

Right-sizing is the process of matching instance types and sizes to workload performance and capacity requirements at the lowest possible cost.

### 1.2 AWS Compute Optimizer

**What:** ML-powered service that analyzes CloudWatch metrics and provides right-sizing recommendations.

```
Data Collection (14+ days)          Analysis                  Recommendation
┌──────────────────────┐    ┌──────────────────────┐    ┌──────────────────┐
│ CloudWatch Metrics   │───▶│ ML Model             │───▶│ Over-provisioned │
│ • CPU utilization    │    │ • Workload patterns  │    │ m5.2xlarge → m5. │
│ • Memory utilization │    │ • Usage correlations │    │ xlarge            │
│ • Network I/O        │    │ • Peak analysis      │    │ Save: $745/yr    │
│ • Disk I/O           │    │                      │    │                  │
│ • EBS metrics        │    │                      │    │ Under-provisioned│
│                      │    │                      │    │ t3.micro → t3.   │
│ Minimum 14 days data │    │                      │    │ medium            │
└──────────────────────┘    └──────────────────────┘    └──────────────────┘
```

**Supported Resources:**
| Resource | Metrics Analyzed | Recommendations |
|---|---|---|
| EC2 Instances | CPU, memory, network, disk | Instance type, size |
| EBS Volumes | IOPS, throughput, size | Volume type, size, IOPS |
| Lambda Functions | Memory, duration, invocations | Memory size |
| ECS on Fargate | CPU, memory | Task size |
| Auto Scaling Groups | Instance types, utilization | Instance types |

### 1.3 Right-Sizing Methodology

```
Step 1: Collect Metrics (14-30 days minimum)
┌──────────────────────────────────────────────────┐
│ CloudWatch Agent + Compute Optimizer              │
│ CPU: avg 15%, peak 45%                           │
│ Memory: avg 30%, peak 60%                        │
│ Network: avg 200 Mbps, peak 1 Gbps              │
│ Disk IOPS: avg 500, peak 2000                    │
└──────────────────────────────────────────────────┘

Step 2: Analyze Usage Patterns
┌──────────────────────────────────────────────────┐
│ Current: m5.4xlarge (16 vCPU, 64 GB RAM)         │
│ CPU: Never exceeds 45% → needs ~8 vCPUs max     │
│ Memory: Never exceeds 60% → needs ~40 GB max    │
│ Network: Needs up to 10 Gbps                     │
│                                                   │
│ Recommendation: m5.2xlarge (8 vCPU, 32 GB RAM)  │
│ OR: r5.xlarge (4 vCPU, 32 GB) if memory-bound   │
└──────────────────────────────────────────────────┘

Step 3: Test and Validate
┌──────────────────────────────────────────────────┐
│ Deploy smaller instance in test environment       │
│ Run load tests simulating peak traffic           │
│ Validate response times and throughput           │
│ Monitor for 1-2 weeks before production change   │
└──────────────────────────────────────────────────┘

Step 4: Implement and Monitor
┌──────────────────────────────────────────────────┐
│ Apply change during maintenance window            │
│ Set CloudWatch alarms for high utilization        │
│ Re-evaluate monthly                               │
└──────────────────────────────────────────────────┘
```

### 1.4 Trusted Advisor Checks

| Check | What It Finds |
|---|---|
| Low Utilization EC2 | Instances with avg CPU <10% over 14 days |
| Idle Load Balancers | ELBs with no active connections |
| Unassociated Elastic IPs | EIPs not attached to instances ($3.60/mo) |
| Idle RDS Instances | RDS with no connections for 7 days |
| Underutilized EBS | Volumes with <1 IOPS/day over 14 days |
| Unused EBS Snapshots | Snapshots with no associated volume |

> **Exam Tip:** Right-sizing should be done BEFORE purchasing RIs or Savings Plans. Right-size first, then commit to discounted pricing.

---

## 2. Reserved Capacity Planning

### 2.1 EC2 Reserved Instances Strategy

**Step 1: Analyze Steady-State Usage**
```
Usage over 30 days:

CPU-hours/month by instance type:
m5.xlarge:   10 instances × 730 hrs = 7,300 hrs (100% utilization — steady)
m5.2xlarge:  5 instances × 730 hrs = 3,650 hrs (100% — steady)
c5.xlarge:   3 instances × 500 hrs = 1,500 hrs (varies — 68%)
t3.medium:   20 instances × 200 hrs = 4,000 hrs (varies — 27%)

Reserve: m5.xlarge (10), m5.2xlarge (5) — steady state
On-Demand: c5.xlarge, t3.medium — variable usage
```

**Step 2: Choose Payment Option**
```
Decision Matrix:
Cash available?     Yes → All Upfront (maximum discount)
Budget constrained? → Partial Upfront (balanced)
No capex budget?    → No Upfront (still significant savings)
```

**Step 3: Choose Term**
```
Workload stable for 3+ years? → 3-year (maximum discount)
Uncertain beyond 1 year?      → 1-year (lower commitment)
Technology may change?         → Convertible RI (flexibility)
```

### 2.2 RI Coverage vs Utilization

```
RI Utilization: How much of your purchased RIs are being used

100% Utilization = All reserved hours consumed (ideal)
80% Utilization = 20% of reserved hours wasted (over-purchased)
50% Utilization = 50% wasted (significantly over-purchased)

RI Coverage: What percentage of your On-Demand usage is covered by RIs

100% Coverage = All usage covered (no On-Demand spend)
70% Coverage = 30% at On-Demand rates (typical target)
50% Coverage = Room for more RIs

Target: 80-90% utilization, 70-80% coverage
Never 100% coverage — need flexibility for variable workloads
```

### 2.3 RDS Reserved Instances

| Feature | Details |
|---|---|
| **Scope** | Single-AZ or Multi-AZ |
| **Terms** | 1-year or 3-year |
| **Payment** | All Upfront, Partial, No Upfront |
| **Discount** | Up to 69% |
| **Flexibility** | Same DB engine family; size flexibility for specific engines |
| **Multi-AZ** | Must match deployment type (buy Multi-AZ RI for Multi-AZ deployment) |

### 2.4 ElastiCache Reserved Nodes

- 1-year or 3-year terms
- Up to 55% discount
- Must match node type exactly
- Cannot resize or exchange

### 2.5 Redshift Reserved Nodes

- 1-year or 3-year terms
- Up to 75% discount
- Node type must match
- Can mix On-Demand and Reserved in same cluster

---

## 3. Savings Plans Optimization

### 3.1 Choosing the Right Savings Plan

```
Decision Flow:

Do you need flexibility across services (EC2, Fargate, Lambda)?
├── Yes → Compute Savings Plan
│         (66% discount, any instance family, any region, Fargate, Lambda)
│
└── No → Do you know the instance family and region?
         ├── Yes → EC2 Instance Savings Plan
         │         (72% discount, specific family + region)
         │
         └── Unsure → Compute Savings Plan (safer choice)
```

### 3.2 Commitment Analysis

```
Monthly spend analysis (last 3 months):

EC2 Spend:
  m5 family (us-east-1):  $15,000/mo ← Very stable
  c5 family (us-east-1):  $5,000/mo  ← Stable
  t3 family (us-east-1):  $3,000/mo  ← Variable ($1K-5K)
  m5 family (eu-west-1):  $2,000/mo  ← Stable

Fargate Spend:           $4,000/mo  ← Growing
Lambda Spend:            $500/mo    ← Variable

Recommendation:
1. EC2 Instance SP (us-east-1, m5): $12/hr commitment
   (covers ~$8,760/mo of the $15K m5 spend at ~40% discount)
2. Compute SP: $5/hr commitment
   (covers mix of c5, Fargate, Lambda at ~35% discount)
3. Remaining: On-Demand (variable workloads)

Total commitment: $17/hr = $12,410/mo
Estimated savings: $4,000-5,000/mo
```

### 3.3 Savings Plans Utilization Tracking

Monitor in Cost Explorer:
- **Utilization:** Are you using all of your committed $/hr? (Target: >90%)
- **Coverage:** What % of your eligible usage is covered? (Target: 70-80%)
- **Net savings:** How much are you actually saving?

---

## 4. Spot Instance Strategies

### 4.1 Diversification Strategy

```
Instead of:  10 × m5.xlarge (all in 1 AZ)    ← HIGH interruption risk

Use:         Spot Fleet with diversification:
             3 × m5.xlarge (AZ-1a)
             2 × m5.xlarge (AZ-1b)
             2 × m4.xlarge (AZ-1a)
             1 × m4.xlarge (AZ-1c)
             1 × m5a.xlarge (AZ-1b)
             1 × m5a.xlarge (AZ-1c)
             
Diversified across: 3 instance types × 3 AZs = 9 capacity pools
```

### 4.2 Allocation Strategies

| Strategy | Description | Best For |
|---|---|---|
| `priceCapacityOptimized` | Balance price + capacity availability | **Default recommended** |
| `capacityOptimized` | Pick pools with most available capacity | Lowest interruption risk |
| `lowestPrice` | Pick cheapest pools | Maximum savings |
| `diversified` | Spread evenly across pools | Maintaining diversity |

### 4.3 Interruption Handling

```python
# Check for Spot interruption notice (2-minute warning)
import requests

def check_spot_interruption():
    try:
        response = requests.get(
            'http://169.254.169.254/latest/meta-data/spot/instance-action',
            timeout=2
        )
        if response.status_code == 200:
            action = response.json()
            # {"action": "terminate", "time": "2024-01-15T12:30:00Z"}
            graceful_shutdown()
    except:
        pass  # No interruption notice

def graceful_shutdown():
    # 1. Stop accepting new work
    # 2. Complete in-progress tasks
    # 3. Checkpoint state to S3/DynamoDB
    # 4. Deregister from load balancer
    pass
```

### 4.4 Spot Use Cases

| Workload | Strategy | Savings |
|---|---|---|
| **Batch processing** | Spot Fleet + checkpointing | 60-90% |
| **CI/CD builds** | Spot for CodeBuild/Jenkins agents | 60-80% |
| **Data analytics** | EMR Spot (task nodes) | 60-80% |
| **Web servers** | Mixed ASG (On-Demand base + Spot) | 30-50% |
| **Training ML models** | Spot with checkpointing (SageMaker) | 70-90% |
| **Rendering** | Spot Fleet for parallel rendering | 70-90% |
| **Testing** | Spot for test environments | 60-90% |

### 4.5 Mixed Instances Policy (Auto Scaling)

```json
{
  "MixedInstancesPolicy": {
    "LaunchTemplate": {
      "LaunchTemplateSpecification": {
        "LaunchTemplateName": "my-lt",
        "Version": "$Latest"
      },
      "Overrides": [
        {"InstanceType": "m5.xlarge"},
        {"InstanceType": "m5a.xlarge"},
        {"InstanceType": "m5d.xlarge"},
        {"InstanceType": "m4.xlarge"}
      ]
    },
    "InstancesDistribution": {
      "OnDemandBaseCapacity": 2,
      "OnDemandPercentageAboveBaseCapacity": 25,
      "SpotAllocationStrategy": "price-capacity-optimized",
      "SpotMaxPrice": ""
    }
  }
}
```
**Result:** 2 On-Demand (base) + 25% On-Demand + 75% Spot for scaling.

---

## 5. Storage Optimization

### 5.1 S3 Lifecycle Policies

```json
{
  "Rules": [
    {
      "ID": "OptimizeStorage",
      "Status": "Enabled",
      "Filter": {"Prefix": "logs/"},
      "Transitions": [
        {
          "Days": 30,
          "StorageClass": "STANDARD_IA"
        },
        {
          "Days": 90,
          "StorageClass": "GLACIER_IR"
        },
        {
          "Days": 365,
          "StorageClass": "DEEP_ARCHIVE"
        }
      ],
      "Expiration": {
        "Days": 2555
      }
    }
  ]
}
```

**Cost Impact (per 1 TB):**
```
Storage Class       Cost/TB/Month    After Lifecycle
─────────────────────────────────────────────────────
S3 Standard         $23.55           Days 0-30
S3 Standard-IA      $12.80           Days 30-90
S3 Glacier IR       $4.10            Days 90-365
S3 Glacier DA       $1.01            Days 365-2555
Expired             $0               After 7 years

Blended annual cost: ~$4-8/TB/month vs $23.55/TB/month static
```

### 5.2 S3 Intelligent-Tiering

- Automatic tier movement based on access patterns
- No retrieval fees
- Small monthly monitoring fee ($0.0025/1K objects)
- Tiers: Frequent → Infrequent (30 days) → Archive Instant (90 days) → Archive (90-730 days) → Deep Archive (180-730 days)

**When to Use:**
- Unknown or changing access patterns
- Don't want to manage lifecycle policies
- Objects accessed unpredictably

### 5.3 EBS Optimization

```
Common Optimizations:
                                                    
1. gp2 → gp3 Migration                              
   gp2 (100 GB): $10/mo, 300 IOPS (burst 3,000)   
   gp3 (100 GB): $8/mo, 3,000 IOPS, 125 MB/s      
   Saving: $2/mo + better baseline performance       
                                                    
2. Delete Unused Volumes                             
   Find unattached EBS volumes                       
   Delete or snapshot and delete                     
                                                    
3. Snapshot Management                               
   Delete old snapshots (>90 days if not needed)     
   Use EBS Snapshot Archive for rarely accessed      
   ($0.0125/GB/mo vs $0.05/GB/mo = 75% savings)    
                                                    
4. Right-size Volumes                                
   Reduce volume size (create new smaller volume)    
   io2 → gp3 if IOPS requirements decreased         
```

### 5.4 EBS Snapshot Management

```
Cost Analysis:
500 EBS volumes × average 100 GB × 30 daily snapshots
= 500 × 100 GB × $0.05/GB × some incremental factor
≈ $2,500/month (if incremental is ~1%)

Optimization:
- Delete snapshots older than 30 days: save ~60%
- Archive snapshots older than 7 days: save ~75% on archived
- Use Amazon Data Lifecycle Manager (DLM) for automated policy
```

---

## 6. Database Optimization

### 6.1 Aurora Serverless v2

```
Traditional Aurora Provisioned:
┌─────────────────────────────────────────────────────┐
│ db.r5.2xlarge running 24/7                           │
│ Cost: $0.96/hr × 730 = $700.80/month                │
│ Utilization: 10% average, 80% peak (2 hrs/day)      │
│ You pay for 100% capacity even at 10% usage          │
└─────────────────────────────────────────────────────┘

Aurora Serverless v2:
┌─────────────────────────────────────────────────────┐
│ Min: 0.5 ACU, Max: 16 ACU                           │
│ Off-peak (22 hrs): 0.5 ACU × $0.12 = $0.06/hr      │
│ Peak (2 hrs):      16 ACU × $0.12 = $1.92/hr        │
│                                                       │
│ Daily: (22 × $0.06) + (2 × $1.92) = $5.16          │
│ Monthly: $5.16 × 30 = $154.80                        │
│                                                       │
│ Savings: $700.80 - $154.80 = $546/month (78%)        │
└─────────────────────────────────────────────────────┘
```

### 6.2 DynamoDB Optimization

**Switch Modes Based on Patterns:**
```
Provisioned Mode (steady traffic):
  1,000 WCU × $0.47/mo = $470
  5,000 RCU × $0.09/mo = $450
  Total: $920/month

On-Demand Mode (same average traffic):
  1,000 writes/sec × 86,400 × 30 = 2.59B writes
  2.59B × $1.25/M = $3,237
  5,000 reads/sec × 86,400 × 30 = 12.96B reads  
  12.96B × $0.25/M = $3,240
  Total: $6,477/month

Provisioned is 86% cheaper for steady traffic!

Use provisioned + auto-scaling for steady patterns
Use on-demand for unpredictable or new workloads
```

### 6.3 RDS Optimization

| Technique | Description | Savings |
|---|---|---|
| **Stop/Start** | Stop dev/test RDS during off-hours | Up to 70% |
| **Right-size** | Use Performance Insights to identify overprovisioned | 20-50% |
| **Aurora Serverless v2** | For variable workloads | 40-80% |
| **Read Replicas** | Offload reads from expensive primary | 20-40% |
| **Graviton** | Switch to r6g/r7g instances | 20-30% |
| **Reserved Instances** | Commit for 1 or 3 years | 30-69% |
| **Multi-AZ optimization** | Only for production; use Single-AZ for dev/test | 50% on dev |

### 6.4 Redshift Optimization

- **Pause/Resume:** Pause unused Redshift clusters (save 100% during pause)
- **Concurrency Scaling:** Auto-add capacity for burst queries (free credits: 1hr/24hr)
- **Redshift Serverless:** For intermittent or unpredictable analytics
- **RA3 nodes:** Separate compute from storage (scale independently)
- **Reserved Nodes:** 75% discount for consistent workloads

---

## 7. Network Cost Optimization

### 7.1 VPC Endpoints

```
BEFORE: EC2 → NAT Gateway → Internet → S3
Cost: $0.045/GB (NAT processing) + $0.09/GB (data out)
For 10 TB/month: $1,350/month

AFTER: EC2 → S3 Gateway Endpoint → S3
Cost: $0 (gateway endpoint is free)

SAVINGS: $1,350/month = $16,200/year
```

**Interface Endpoint Savings:**
```
BEFORE: EC2 → NAT Gateway → Internet → AWS service (KMS, STS, etc.)
Cost: $0.045/GB (NAT) + NAT hourly

AFTER: EC2 → Interface Endpoint → AWS service
Cost: $0.01/hr/AZ + $0.01/GB
For moderate usage: significantly cheaper than NAT
```

### 7.2 CloudFront Cost Optimization

```
WITHOUT CloudFront:
EC2 → Internet: $0.09/GB
1 TB/month: $92.16

WITH CloudFront:
EC2 → CloudFront: FREE (origin fetch)
CloudFront → Internet: $0.085/GB
Plus 80% cache hit ratio means only 200 GB origin fetch

Effective cost for 1 TB delivered:
CloudFront: (1 TB × $0.085) + 0 (origin fetch) = $87.04
But only 200 GB actually leaves origin
Real origin transfer: FREE (to CloudFront)

Total: $87.04 + distribution availability
vs $92.16 without CloudFront + better latency
```

### 7.3 Same-AZ Placement

```
For high-bandwidth applications:

BEFORE: App Server (AZ-1a) → Database (AZ-1b)
Transfer: $0.01/GB each way = $0.02/GB round-trip
1 TB/month: $20.48

AFTER: App Server (AZ-1a) → Database (AZ-1a)
Transfer: FREE (same AZ, private IP)
Savings: $20.48/month

TRADE-OFF: Reduced high availability
SOLUTION: Multi-AZ for DR, same-AZ for performance + cost in one AZ pair
```

### 7.4 NAT Gateway Optimization

```
Optimization strategies:

1. Centralized NAT Gateway (if using Transit Gateway)
   Instead of: NAT GW in each VPC (3 VPCs × 3 AZs = 9 NAT GWs)
   Use: Shared NAT GW in dedicated VPC via Transit Gateway
   Save: 6 NAT GW hourly charges

2. Replace with VPC Endpoints where possible
   S3/DynamoDB: Gateway Endpoints (free)
   Other services: Interface Endpoints ($0.01/GB vs $0.045/GB)

3. Reduce NAT data by using VPC endpoints for high-volume services
   Identify top data consumers through VPC Flow Logs
   Common culprits: S3, DynamoDB, CloudWatch, KMS, STS
```

---

## 8. Serverless Cost Optimization

### 8.1 Lambda Power Tuning

```
AWS Lambda Power Tuning Tool:
Tests function at different memory settings to find optimal cost/performance.

Example results for a CPU-bound function:
Memory    Duration    Cost/Invocation    Relative Cost
128 MB    3000 ms     $0.00006250        1.00×
256 MB    1500 ms     $0.00006250        1.00×
512 MB    800 ms      $0.00006667        1.07×
1024 MB   400 ms      $0.00006667        1.07×
1769 MB   250 ms      $0.00007375        1.18×
3008 MB   200 ms      $0.00010000        1.60×

Optimal: 256 MB (same cost as 128 MB, 2× faster!)
```

### 8.2 API Gateway Caching

```
WITHOUT caching:
100,000 requests/hour → 100,000 Lambda invocations
Lambda cost: 100K × $0.20/1M + 100K × 200ms × 256MB duration
= $0.02 + $0.83 = $0.85/hour = $620/month

WITH caching (80% cache hit):
100,000 requests/hour → 20,000 Lambda invocations
Lambda cost: 20K × $0.20/1M + 20K × 200ms × 256MB duration
= $0.004 + $0.17 = $0.174/hour = $127/month
Cache cost: ~$0.02/hr (0.5 GB cache) = $14.60/month

Total with caching: $141.60/month
Savings: $478.40/month (77%)
```

### 8.3 Step Functions Optimization

| Workflow Type | Pricing | Best For |
|---|---|---|
| **Standard** | $0.025/1K state transitions | Long-running, auditable, <1 year |
| **Express** | $0.00001667/GB-sec + $0.000001/request | High-volume, short (<5 min) |

```
Example: 1M executions/month, 5 states each

Standard: 1M × 5 = 5M transitions × $0.025/1K = $125/month
Express:  1M × $0.000001 + duration cost ≈ $1 + ~$10 = $11/month

If workload fits Express constraints: 91% savings
```

---

## 9. Container Cost Optimization

### 9.1 Fargate Spot

```
Standard Fargate (2 vCPU, 4 GB, 24/7):
vCPU: 2 × $0.04048 × 730 = $59.10
Memory: 4 × $0.004445 × 730 = $12.98
Total: $72.08/month

Fargate Spot (same, fault-tolerant):
Up to 70% discount
Total: ~$21.62/month

Savings: $50.46/month per task (70%)
```

### 9.2 ECS Capacity Providers

```
ECS Capacity Provider Strategy:
┌────────────────────────────────────────┐
│  Service: my-web-service               │
│  Desired: 10 tasks                     │
│                                        │
│  Capacity Provider Strategy:           │
│  ├── on-demand-provider: base=2,       │
│  │   weight=1 (20% On-Demand)         │
│  └── spot-provider: base=0,           │
│      weight=4 (80% Spot)              │
│                                        │
│  Result:                               │
│  2 tasks on On-Demand (guaranteed)     │
│  8 tasks on Spot (cost-optimized)      │
└────────────────────────────────────────┘
```

### 9.3 Karpenter for EKS

- Just-in-time node provisioning for Kubernetes
- Selects optimal instance types automatically
- Supports Spot and On-Demand mix
- Consolidation: Removes underutilized nodes
- Typically saves 20-50% vs static node groups

---

## 10. Architecture Cost Patterns

### 10.1 Serverless vs Containers vs EC2 Break-Even

```
Monthly cost comparison for a REST API:

Requests/Month    Lambda+APIGW    Fargate (2 tasks)    EC2 (m5.large)
─────────────────────────────────────────────────────────────────────
100K              $1              $72                   $70
1M                $10             $72                   $70
10M               $100            $72                   $70
50M               $500            $144 (4 tasks)        $70
100M              $1,000          $360 (10 tasks)       $140 (2 inst)
500M              $5,000          $1,440 (40 tasks)     $700 (10 inst)
1B                $10,000         $2,880 (80 tasks)     $1,400 (20 inst)

Break-even points (approximate):
Lambda cheaper than EC2: <10M requests/month
Fargate cheaper than EC2: rarely (but easier ops)
EC2 cheapest: >10M requests/month (requires ops investment)
```

### 10.2 When to Choose Each

| Criteria | Choose Serverless | Choose Containers | Choose EC2 |
|---|---|---|---|
| **Traffic** | Variable, spiky, low | Medium, predictable | High, steady |
| **Ops team** | Small/none | Medium | Large |
| **Cost priority** | Low traffic | Medium traffic | High traffic (with RI) |
| **Cold starts** | Acceptable | N/A | N/A |
| **Execution time** | <15 minutes | Any | Any |
| **State** | Stateless | Stateful OK | Any |

---

## 11. Exam Scenarios

### Scenario 1: Reducing EC2 Costs

**Question:** A company runs 100 m5.2xlarge instances 24/7 in us-east-1 for production. Monthly bill is $140,000. They've confirmed the workload is stable for 3 years. How to reduce costs?

**Answer:** Purchase **EC2 Instance Savings Plan** (3-year, All Upfront) for the m5 family in us-east-1. Expected savings: ~72% → ~$39,200/month.

Additionally:
- Right-size any underutilized instances (Compute Optimizer)
- Consider Graviton-based m6g/m7g instances for additional 20% savings

---

### Scenario 2: Spot for Batch Processing

**Question:** A company runs nightly batch processing that takes 4 hours on 50 × c5.4xlarge instances. The job can restart from checkpoints if interrupted. How to optimize cost?

**Answer:** Use **Spot Instances** with diversification.

```
Current: 50 × c5.4xlarge On-Demand × 4 hrs = $108/night
With Spot (80% savings): $21.60/night

Configuration:
- Spot Fleet with priceCapacityOptimized strategy
- Instance types: c5.4xlarge, c5a.4xlarge, c5d.4xlarge, c5n.4xlarge
- AZs: us-east-1a, 1b, 1c
- Checkpoint state to S3 every 15 minutes
- Fallback: If insufficient Spot, launch On-Demand for remaining
```

---

### Scenario 3: Storage Cost Optimization

**Question:** A company stores 500 TB in S3 Standard. Analysis shows 80% of data hasn't been accessed in 90 days. Monthly storage bill is $11,500. How to optimize?

**Answer:** Implement **S3 Intelligent-Tiering** or **Lifecycle Policies**.

```
Current: 500 TB × $0.023/GB = $11,500/month

With Lifecycle:
100 TB S3 Standard (active):     100 × $0.023 = $2,300
200 TB S3 Standard-IA:           200 × $0.0125 = $2,500
200 TB S3 Glacier Instant:       200 × $0.004 = $800

New total: $5,600/month
Savings: $5,900/month (51%)
```

---

### Scenario 4: Network Cost Reduction

**Question:** A company processes 50 TB/month of data from EC2 to S3, routed through a NAT Gateway. The NAT Gateway bill is $2,250/month. How to reduce?

**Answer:** Deploy an **S3 Gateway VPC Endpoint** (free).

```
Current: EC2 → NAT GW → S3
NAT processing: 50 TB × $0.045/GB = $2,304
NAT hourly: $0.045 × 730 = $32.85 per AZ

With S3 Gateway Endpoint:
EC2 → Gateway Endpoint → S3
Cost: $0

Savings: $2,336.85/month = $28,042/year
```

---

> **Key Exam Tips Summary:**
> 1. **Right-size BEFORE committing** to RIs or Savings Plans
> 2. **Compute Savings Plans** = most flexible (EC2, Fargate, Lambda)
> 3. **Spot instances** = fault-tolerant workloads, use diversification
> 4. **S3 Lifecycle policies** = automatic tier transition for known patterns
> 5. **S3 Intelligent-Tiering** = automatic for unknown access patterns
> 6. **gp2 → gp3** = almost always saves money with better performance
> 7. **VPC Gateway Endpoints** (S3/DynamoDB) = FREE, replaces NAT costs
> 8. **Aurora Serverless v2** = variable workloads, can save 40-80%
> 9. **DynamoDB Provisioned** = 85% cheaper than On-Demand for steady traffic
> 10. **Lambda Power Tuning** = find optimal memory for cost/performance balance
> 11. **Serverless** = cheapest for low-traffic, EC2 = cheapest for high-traffic steady state
> 12. **Mixed instance ASG** = On-Demand base + Spot for scaling
