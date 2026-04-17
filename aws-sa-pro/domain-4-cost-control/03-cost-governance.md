# Cost Governance — AWS SAP-C02 Domain 4

## Table of Contents
1. [AWS Cost Explorer](#1-aws-cost-explorer)
2. [AWS Budgets](#2-aws-budgets)
3. [AWS Cost and Usage Report (CUR)](#3-aws-cost-and-usage-report-cur)
4. [AWS Billing Conductor](#4-aws-billing-conductor)
5. [Cost Allocation Tags](#5-cost-allocation-tags)
6. [AWS Organizations Consolidated Billing](#6-aws-organizations-consolidated-billing)
7. [Chargeback and Showback Models](#7-chargeback-and-showback-models)
8. [FinOps Practices on AWS](#8-finops-practices-on-aws)
9. [Exam Scenarios](#9-exam-scenarios)

---

## 1. AWS Cost Explorer

### 1.1 Overview

AWS Cost Explorer is a tool for visualizing, understanding, and managing AWS costs and usage over time.

### 1.2 Key Features

| Feature | Description |
|---|---|
| **Cost & Usage Reports** | Visualize spending over time (daily, monthly) |
| **Filters & Groups** | Filter by service, account, tag, region, instance type |
| **RI Utilization** | Track how well Reserved Instances are being used |
| **RI Coverage** | Track what % of usage is covered by RIs |
| **Savings Plans Utilization** | Track Savings Plan usage |
| **Savings Plans Coverage** | Track coverage percentage |
| **Forecasting** | 12-month cost forecast based on historical data |
| **Rightsizing Recommendations** | EC2 instance right-sizing suggestions |
| **Cost Anomaly Detection** | ML-based anomaly detection and alerts |

### 1.3 Usage Reports

```
Cost Explorer Dashboard Example:
┌─────────────────────────────────────────────────────────┐
│  Monthly Costs (Last 6 Months)                           │
│                                                          │
│  $50K ┤                                          ██     │
│  $40K ┤                              ██    ██    ██     │
│  $30K ┤              ██    ██    ██  ██    ██    ██     │
│  $20K ┤    ██    ██  ██    ██    ██  ██    ██    ██     │
│  $10K ┤    ██    ██  ██    ██    ██  ██    ██    ██     │
│   $0K ┤────██────██──██────██────██──██────██────██──── │
│        Oct  Nov  Dec  Jan  Feb  Mar  Apr  May  Jun      │
│                                                          │
│  Top Services:                                           │
│  ├── EC2:        $18,000 (40%)                          │
│  ├── RDS:        $8,000 (18%)                           │
│  ├── S3:         $5,000 (11%)                           │
│  ├── Data Transfer: $4,000 (9%)                         │
│  ├── Lambda:     $2,000 (4%)                            │
│  └── Other:      $8,000 (18%)                           │
└─────────────────────────────────────────────────────────┘
```

### 1.4 RI Utilization and Coverage

```
RI Utilization Report:
┌────────────────────────────────────────────────────────┐
│ Instance Type    Purchased  Used    Utilization  Action │
│ ────────────────────────────────────────────────────── │
│ m5.xlarge (10)   7,300 hrs  6,935   95.0%        OK   │
│ r5.large (5)     3,650 hrs  2,555   70.0%        ⚠    │
│ c5.2xlarge (3)   2,190 hrs  1,314   60.0%        ❌   │
│                                                        │
│ Recommendations:                                       │
│ - r5.large: Consider selling 1-2 RIs on Marketplace   │
│ - c5.2xlarge: Sell 1 RI or consolidate workloads      │
└────────────────────────────────────────────────────────┘

RI Coverage Report:
┌────────────────────────────────────────────────────────┐
│ Instance Type    Total Hrs   Covered    Coverage       │
│ ────────────────────────────────────────────────────── │
│ m5.xlarge        9,000 hrs   7,300      81.1%   ✓    │
│ r5.large         4,500 hrs   3,650      81.1%   ✓    │
│ c5.2xlarge       3,800 hrs   2,190      57.6%   ⚠    │
│ t3.medium        5,000 hrs   0          0.0%    ❌    │
│                                                        │
│ Recommendation: Purchase RIs for t3.medium to          │
│ improve coverage from 0% to ~80%                       │
└────────────────────────────────────────────────────────┘
```

### 1.5 Cost Anomaly Detection

```
Configuration:
┌──────────────────────────────────────────────────┐
│ Cost Anomaly Detection                            │
│                                                   │
│ Monitors:                                         │
│ ├── AWS Service monitor (all services)           │
│ ├── Linked Account monitor (each account)        │
│ ├── Cost Category monitor (by business unit)     │
│ └── Cost Allocation Tag monitor (by project)     │
│                                                   │
│ Alert preferences:                                │
│ ├── Threshold: >$100 anomaly or >10% increase   │
│ ├── Frequency: Individual alerts or daily digest │
│ └── Recipients: SNS topic → email/Slack          │
│                                                   │
│ Example Alert:                                    │
│ "Anomaly detected: EC2 spend increased by $500   │
│  (35%) in us-east-1 on 2024-03-15.              │
│  Root cause: 20 new c5.4xlarge instances launched │
│  in account 123456789012."                        │
└──────────────────────────────────────────────────┘
```

### 1.6 Forecasting

- Uses ML on historical spending patterns
- 12-month cost forecast
- Confidence intervals (80% and 95%)
- Can filter by service, account, tag
- Used for budget planning

> **Exam Tip:** Cost Explorer = visualization and analysis. For automated actions based on costs, use AWS Budgets. Cost Anomaly Detection uses ML to alert on unexpected spending spikes.

---

## 2. AWS Budgets

### 2.1 Budget Types

| Budget Type | What It Tracks |
|---|---|
| **Cost Budget** | Actual and forecasted spending vs. budget amount |
| **Usage Budget** | Service usage (e.g., EC2 hours, S3 GB) |
| **Reservation Budget** | RI utilization and coverage targets |
| **Savings Plans Budget** | Savings Plans utilization and coverage targets |

### 2.2 Budget Configuration

```
Example: Monthly Cost Budget
┌──────────────────────────────────────────────────┐
│ Budget Name: Production-Monthly                   │
│ Period: Monthly                                   │
│ Budget Amount: $50,000                            │
│                                                   │
│ Alerts:                                           │
│ ├── Alert 1: Actual > 50% ($25,000)             │
│ │   → Email to team@company.com                  │
│ │                                                │
│ ├── Alert 2: Actual > 80% ($40,000)             │
│ │   → Email to manager@company.com               │
│ │   → SNS topic → Slack notification             │
│ │                                                │
│ ├── Alert 3: Forecasted > 100% ($50,000)        │
│ │   → Email to director@company.com              │
│ │   → Budget Action: Apply restrictive SCP       │
│ │                                                │
│ └── Alert 4: Actual > 100% ($50,000)            │
│     → Email to vp@company.com                    │
│     → Budget Action: Stop non-critical instances │
│                                                   │
│ Filters:                                          │
│ ├── Account: 123456789012 (Production)           │
│ └── Tag: Environment=Production                  │
└──────────────────────────────────────────────────┘
```

### 2.3 Budget Actions

Budget Actions can automatically respond when thresholds are breached:

| Action Type | What It Does |
|---|---|
| **Apply IAM Policy** | Attach restrictive IAM policy to users/roles |
| **Apply SCP** | Attach restrictive SCP to OU/account |
| **Stop EC2 Instances** | Stop specific tagged instances |

```
Budget Action Flow:
                  Alert Threshold Breached
                           │
                           ▼
               ┌───────────────────────┐
               │ Budget Action         │
               │ (requires approval    │
               │  or auto-execute)     │
               └───────────┬───────────┘
                           │
              ┌────────────┼────────────┐
              ▼            ▼            ▼
      ┌────────────┐ ┌──────────┐ ┌──────────┐
      │Apply SCP:  │ │Apply IAM:│ │Stop EC2: │
      │Deny new    │ │Deny ec2: │ │Tag=dev   │
      │EC2 launches│ │RunInst*  │ │instances │
      └────────────┘ └──────────┘ └──────────┘
```

### 2.4 Budget Reports

- Weekly or monthly email summaries
- Delivered to up to 50 email addresses
- Include cost/usage vs budget comparison
- Can be configured for multiple budgets in one report

> **Exam Tip:** Budgets = proactive cost control (alerts + automated actions). Cost Explorer = reactive analysis (what happened). Use Budget Actions to automatically restrict spending when thresholds are exceeded.

---

## 3. AWS Cost and Usage Report (CUR)

### 3.1 Overview

The most comprehensive cost and usage dataset. Delivered as CSV/Parquet files to an S3 bucket.

### 3.2 CUR Contents

| Column Category | Example Columns |
|---|---|
| **Identity** | line_item_id, time_interval |
| **Bill** | payer_account_id, billing_period_start/end |
| **Line Item** | usage_type, operation, usage_amount, unblended_cost, blended_cost |
| **Product** | product_name, product_family, product_region |
| **Pricing** | public_on_demand_cost, public_on_demand_rate |
| **Reservation** | reservation_arn, amortized_upfront_cost, reservation_effective_cost |
| **Savings Plan** | savings_plan_arn, savings_plan_rate, savings_plan_effective_cost |
| **Resource** | resource_id (individual resource ARN) |
| **Cost Category** | cost_category values |
| **Tags** | user-defined and AWS-generated tags |

### 3.3 CUR + Athena Integration

```
CUR → S3 (Parquet)
         │
         ▼
┌──────────────────────────────────────────────────┐
│ AWS Athena                                        │
│                                                   │
│ CREATE EXTERNAL TABLE cost_and_usage (            │
│   line_item_id STRING,                           │
│   line_item_usage_type STRING,                   │
│   line_item_operation STRING,                    │
│   line_item_usage_amount DOUBLE,                 │
│   line_item_unblended_cost DOUBLE,               │
│   line_item_resource_id STRING,                  │
│   product_product_name STRING,                   │
│   ...                                             │
│ )                                                 │
│ STORED AS PARQUET                                │
│ LOCATION 's3://my-cur-bucket/cur-report/';       │
│                                                   │
│ -- Top 10 most expensive resources               │
│ SELECT                                            │
│   line_item_resource_id,                         │
│   SUM(line_item_unblended_cost) as total_cost    │
│ FROM cost_and_usage                              │
│ WHERE billing_period = '2024-03'                 │
│ GROUP BY line_item_resource_id                   │
│ ORDER BY total_cost DESC                         │
│ LIMIT 10;                                        │
└──────────────────────────────────────────────────┘
```

### 3.4 CUR + QuickSight Dashboard

```
Architecture:
S3 (CUR) → Glue Crawler → Athena → QuickSight Dashboard

Dashboard Views:
┌─────────────────────────────────────────────────────┐
│  Cost Dashboard                                      │
│  ┌─────────────────┐  ┌──────────────────────────┐  │
│  │ Monthly Trend    │  │ Cost by Account           │  │
│  │ (line chart)     │  │ (bar chart)               │  │
│  └─────────────────┘  └──────────────────────────┘  │
│  ┌─────────────────┐  ┌──────────────────────────┐  │
│  │ Cost by Service  │  │ Top 20 Resources         │  │
│  │ (pie chart)      │  │ (table)                  │  │
│  └─────────────────┘  └──────────────────────────┘  │
│  ┌─────────────────┐  ┌──────────────────────────┐  │
│  │ RI Utilization   │  │ Cost by Tag (Project)    │  │
│  │ (gauge chart)    │  │ (stacked bar)            │  │
│  └─────────────────┘  └──────────────────────────┘  │
└─────────────────────────────────────────────────────┘
```

### 3.5 Key CUR Queries

**Unblended vs Blended vs Amortized Costs:**

| Cost Type | Description | When to Use |
|---|---|---|
| **Unblended** | Actual rate for each line item | Per-account actual costs |
| **Blended** | Average rate across Organization | Simplified view (less useful) |
| **Amortized** | Spreads RI/SP upfront across term | True cost of resources over time |
| **Net Unblended** | After discounts (EDP, PPA) | Final billed cost |

> **Exam Tip:** CUR is the most detailed cost data source. Use Athena for ad-hoc queries. Use QuickSight for executive dashboards. CUR + Athena is the standard pattern for custom cost analysis.

---

## 4. AWS Billing Conductor

### 4.1 Overview

AWS Billing Conductor lets you customize billing data, create pricing rules, and generate custom billing reports for your organization.

### 4.2 Key Concepts

| Concept | Description |
|---|---|
| **Billing Group** | Collection of accounts that share a custom bill |
| **Pricing Rule** | Custom pricing applied to a billing group |
| **Pricing Plan** | Collection of pricing rules applied to a billing group |
| **Custom Line Item** | Additional charges or credits |

### 4.3 Use Cases

```
Scenario: MSP (Managed Service Provider) with 50 customers

AWS Actual Cost:        $100,000/month (consolidated)

Customer A (20 accounts):
├── Actual AWS cost:    $30,000
├── MSP margin (20%):   $6,000
├── Support fee:         $2,000
└── Customer bill:      $38,000

Customer B (10 accounts):
├── Actual AWS cost:    $15,000
├── MSP margin (15%):   $2,250
├── Discount (loyalty): -$500
└── Customer bill:      $16,750

Billing Conductor Configuration:
├── Billing Group A:    Accounts for Customer A
│   ├── Pricing Rule:   20% markup on all services
│   └── Custom Line Item: $2,000 support fee
│
└── Billing Group B:    Accounts for Customer B
    ├── Pricing Rule:   15% markup
    └── Custom Line Item: -$500 loyalty discount
```

### 4.4 Pricing Rule Types

| Rule Type | Description |
|---|---|
| **Markup** | Percentage markup on AWS costs |
| **Discount** | Percentage discount on AWS costs |
| **Tiering** | Different rates based on usage volume |
| **Fixed** | Fixed rate per unit |
| **Free Tier** | Custom free tier for specific services |

---

## 5. Cost Allocation Tags

### 5.1 Tag Types

| Type | Created By | Activation | Example |
|---|---|---|---|
| **AWS-Generated** | AWS automatically | Must activate in Billing Console | `aws:createdBy`, `aws:cloudformation:stack-name` |
| **User-Defined** | You apply to resources | Must activate in Billing Console | `Environment`, `CostCenter`, `Project`, `Owner` |

### 5.2 Tagging Strategy

```
Recommended Tag Schema:
┌──────────────────────────────────────────────────┐
│ Tag Key          │ Required │ Example Values      │
├──────────────────┼──────────┼─────────────────────┤
│ Environment      │ Yes      │ prod, staging, dev  │
│ CostCenter       │ Yes      │ CC-1234, CC-5678    │
│ Project          │ Yes      │ ProjectX, MigrationY│
│ Owner            │ Yes      │ team-platform,      │
│                  │          │ john.doe@company.com │
│ Application      │ Yes      │ ecommerce, analytics│
│ Compliance       │ No       │ PCI, HIPAA, SOC2    │
│ DataClassification│ No      │ public, confidential│
│ AutomationOpt    │ No       │ start-9am, stop-6pm │
└──────────────────┴──────────┴─────────────────────┘
```

### 5.3 Tag Enforcement

**Method 1: SCP (Service Control Policy)**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "RequireTags",
      "Effect": "Deny",
      "Action": [
        "ec2:RunInstances",
        "rds:CreateDBInstance",
        "s3:CreateBucket"
      ],
      "Resource": "*",
      "Condition": {
        "Null": {
          "aws:RequestTag/CostCenter": "true",
          "aws:RequestTag/Environment": "true",
          "aws:RequestTag/Owner": "true"
        }
      }
    }
  ]
}
```

**Method 2: AWS Config Rule**
```
Config Rule: required-tags
Trigger: Configuration change
Resources: EC2, RDS, S3, Lambda, ECS
Required Tags: CostCenter, Environment, Owner
Action: Non-compliant → SNS notification → remediation
```

**Method 3: Tag Policies (AWS Organizations)**
- Define standardized tag keys and allowed values
- Enforce consistent capitalization
- Report on compliance

### 5.4 Cost Allocation Report

After tags are activated (takes up to 24 hours), they appear in:
- Cost Explorer (filter and group by tag)
- CUR (as columns: `resourceTags/user:TagKey`)
- AWS Budgets (filter by tag)

---

## 6. AWS Organizations Consolidated Billing

### 6.1 How Consolidated Billing Works

```
Management Account (Payer)
┌─────────────────────────────────────────────────┐
│  Consolidated Bill for Organization              │
│                                                  │
│  Member Account A:  $10,000                     │
│  Member Account B:  $15,000                     │
│  Member Account C:  $8,000                      │
│  Member Account D:  $12,000                     │
│  ──────────────────────────                     │
│  Subtotal:          $45,000                     │
│  Volume Discounts:  -$2,000                     │
│  RI Sharing:        -$5,000                     │
│  SP Sharing:        -$3,000                     │
│  ──────────────────────────                     │
│  Total Bill:        $35,000                     │
└─────────────────────────────────────────────────┘
```

### 6.2 Volume Discounts

S3 and Data Transfer have tiered pricing. Consolidated billing combines usage across all accounts for higher tier discounts.

```
Without Consolidation:
Account A: 50 TB S3 → $0.023/GB = $1,150
Account B: 50 TB S3 → $0.023/GB = $1,150
Account C: 50 TB S3 → $0.023/GB = $1,150
Total: $3,450

With Consolidation:
Combined: 150 TB S3
First 50 TB:  $0.023/GB = $1,150
Next 100 TB:  $0.022/GB = $2,200
Total: $3,350 (saves $100/month)

Data Transfer is more impactful:
First 10 TB:   $0.09/GB
Next 40 TB:    $0.085/GB
Next 100 TB:   $0.07/GB
Over 150 TB:   $0.05/GB

Aggregating 200 TB across accounts gets lower tiers
```

### 6.3 RI Sharing

```
RI Sharing Across Accounts (Default: ON):

Account A purchased: 10 × m5.xlarge RI (us-east-1)
Account A uses:      7 × m5.xlarge

Account B uses:      3 × m5.xlarge (no RI purchased)

Result: Account B's 3 instances benefit from Account A's unused RIs
Account A: 7 instances at RI rate
Account B: 3 instances at RI rate (shared from A's excess)

To disable: Turn off RI sharing at the payer account level
Use case for disabling: Chargeback where each account must own their RIs
```

### 6.4 Savings Plans Sharing

Same concept as RI sharing:
- Savings Plans purchased in one account apply to usage in any account in the Organization
- Can be disabled at the payer level
- Compute Savings Plans have the broadest sharing scope

### 6.5 Blended vs Unblended Rates

| Cost Type | Calculation | Use Case |
|---|---|---|
| **Unblended** | Each line item at its actual rate | Accurate per-resource costing |
| **Blended** | Weighted average across all usage | Simplified org-wide view |
| **Net Unblended** | After credits, discounts, EDP | What you actually pay |
| **Net Amortized** | Upfront costs spread + net rates | True resource cost over time |

```
Example:
Account A: 10 m5.xlarge (RI rate: $0.097/hr)
Account B: 5 m5.xlarge (On-Demand: $0.192/hr)

Unblended:
Account A: $0.097/hr per instance
Account B: $0.192/hr per instance

Blended:
Average: (10 × $0.097 + 5 × $0.192) / 15 = $0.129/hr
All instances show $0.129/hr

For chargeback: Use UNBLENDED (each account pays their actual rate)
```

---

## 7. Chargeback and Showback Models

### 7.1 Chargeback vs Showback

| Model | What | Billing Impact |
|---|---|---|
| **Chargeback** | Business units pay for actual AWS costs | Real cost allocation to P&L |
| **Showback** | Business units see costs but don't pay directly | Awareness without financial impact |

### 7.2 Chargeback Implementation

```
Architecture:
CUR (S3) → Athena → Chargeback Engine → Per-Team Reports

Chargeback Report Example:
┌─────────────────────────────────────────────────────┐
│ Team: Platform Engineering                           │
│ Period: March 2024                                   │
│                                                      │
│ Service          Resources       Cost    % of Total  │
│ ─────────────────────────────────────────────────── │
│ EC2              45 instances    $12,000    60%      │
│ RDS              3 databases    $4,000     20%      │
│ S3               15 TB         $1,500     7.5%     │
│ Data Transfer    2 TB          $1,000     5%       │
│ Lambda           50M invocations $500     2.5%     │
│ Other                          $1,000     5%       │
│ ─────────────────────────────────────────────────── │
│ Total                          $20,000    100%     │
│                                                      │
│ Shared Services Allocation:                          │
│ ├── Networking (Transit GW):   $500 (per-account)   │
│ ├── Security (GuardDuty):      $200 (per-account)   │
│ └── Logging (CloudTrail):      $100 (per-account)   │
│                                                      │
│ Grand Total:                   $20,800               │
└─────────────────────────────────────────────────────┘
```

### 7.3 Shared Cost Allocation Methods

| Method | Description | Best For |
|---|---|---|
| **Proportional** | Allocate based on proportion of usage | Fair when usage correlates with benefit |
| **Even split** | Divide equally among teams | Simple shared infrastructure |
| **Fixed percentage** | Pre-agreed percentages | Stable allocations |
| **Direct allocation** | Tag-based direct attribution | Resources clearly owned by one team |

### 7.4 Implementation Using Cost Categories

```
AWS Cost Categories Configuration:

Category: Team
├── Rule: If tag "Owner" = "platform-team" → "Platform Engineering"
├── Rule: If tag "Owner" = "data-team" → "Data Analytics"
├── Rule: If account = "123456789012" → "Security"
├── Rule: If tag "Owner" = "frontend-team" → "Frontend"
└── Default: "Unallocated"

Category: Environment
├── Rule: If tag "Environment" = "production" → "Production"
├── Rule: If tag "Environment" = "staging" → "Staging"
├── Rule: If tag "Environment" = "development" → "Development"
└── Default: "Untagged"

Use in Cost Explorer: Group by "Team" cost category
Use in Budgets: Create per-team budgets using cost categories
Use in CUR: cost_category/Team column
```

---

## 8. FinOps Practices on AWS

### 8.1 FinOps Framework

```
FinOps Lifecycle:
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│   INFORM     │───▶│   OPTIMIZE   │───▶│   OPERATE    │
│              │    │              │    │              │
│ • Visibility │    │ • Right-size │    │ • Governance │
│ • Allocation │    │ • Commitment │    │ • Automation │
│ • Showback   │    │ • Architect  │    │ • Continuous │
│ • Benchmarks │    │ • Spot/SL    │    │   improvement│
└──────────────┘    └──────────────┘    └──────────────┘
         ▲                                      │
         └──────────── Repeat ──────────────────┘
```

### 8.2 FinOps Team Structure

```
FinOps Team (Cloud Financial Management):
┌──────────────────────────────────────────────┐
│  FinOps Lead (1)                              │
│  ├── Reports to: CFO or CTO                  │
│  ├── Responsibilities:                        │
│  │   • Cloud cost strategy                    │
│  │   • Executive reporting                    │
│  │   • Commitment decisions (RI/SP)          │
│  │                                            │
│  Cloud Financial Analyst (1-2)               │
│  ├── Responsibilities:                        │
│  │   • Daily cost monitoring                  │
│  │   • Anomaly investigation                  │
│  │   • Chargeback reports                     │
│  │   • Optimization recommendations          │
│  │                                            │
│  Embedded in Each Team:                       │
│  ├── Cloud Cost Champion (volunteer)          │
│  │   • Tag compliance                         │
│  │   • Right-sizing reviews                   │
│  │   • Architecture cost reviews              │
└──────────────────────────────────────────────┘
```

### 8.3 FinOps Maturity Model

| Stage | Characteristics | AWS Tools |
|---|---|---|
| **Crawl** | Basic cost visibility, reactive | Cost Explorer, free-tier Trusted Advisor |
| **Walk** | Tagging, budgets, some optimization | Budgets, CUR, basic RIs |
| **Run** | Automated, proactive, culture of cost awareness | Full CUR analysis, Compute Optimizer, automated actions, SP/RI optimization |

### 8.4 Key FinOps Metrics

| Metric | Target | How to Measure |
|---|---|---|
| **RI/SP Coverage** | 70-80% | Cost Explorer RI/SP reports |
| **RI/SP Utilization** | >90% | Cost Explorer RI/SP reports |
| **Tag Compliance** | >95% | AWS Config, Tag Editor |
| **Cost per Transaction** | Decreasing trend | CUR + application metrics |
| **Waste (idle resources)** | <5% | Trusted Advisor, Compute Optimizer |
| **Forecast Accuracy** | ±10% | Budget vs actual comparison |

### 8.5 FinOps Automation

```
Automated Cost Optimization Pipeline:

EventBridge (scheduled, daily at 6 AM)
  │
  ├──▶ Lambda: Check for unattached EBS volumes
  │    └──▶ If found → SNS alert → owner has 7 days to respond
  │         └──▶ If no response → snapshot + delete
  │
  ├──▶ Lambda: Check for idle EC2 instances (CPU <5% for 7 days)
  │    └──▶ Create Jira ticket for team → right-size or terminate
  │
  ├──▶ Lambda: Check for unused Elastic IPs
  │    └──▶ Auto-release after 3-day warning
  │
  ├──▶ Lambda: Check for dev/test resources running outside business hours
  │    └──▶ Auto-stop tagged instances (AutomationOpt=stop-6pm)
  │
  └──▶ Lambda: Check tag compliance
       └──▶ Non-compliant resources → SNS alert → owner
```

---

## 9. Exam Scenarios

### Scenario 1: Multi-Account Cost Visibility

**Question:** A company with 50 AWS accounts in an Organization needs to track costs by business unit, project, and environment. They need monthly reports for each business unit. What approach?

**Answer:**
1. **Cost Allocation Tags:** Enforce `BusinessUnit`, `Project`, `Environment` tags via SCP and AWS Config
2. **Cost Categories:** Create cost category rules mapping tags to business units
3. **CUR:** Enable CUR delivery to S3 with resource IDs and tags
4. **Athena + QuickSight:** Build dashboards per business unit
5. **AWS Budgets:** Create per-business-unit budgets with alerts

---

### Scenario 2: Cost Anomaly

**Question:** A company's AWS bill unexpectedly increased by 40% in one month. How should they investigate?

**Answer:**
1. **Cost Explorer:** Filter by service, account, region to identify the spike
2. **Cost Anomaly Detection:** Review ML-detected anomalies
3. **CUR + Athena:** Query for top cost increases by resource
4. **Investigation:**
   ```sql
   SELECT line_item_resource_id,
          SUM(line_item_unblended_cost) as cost
   FROM cur_table
   WHERE billing_period = '2024-03'
   GROUP BY line_item_resource_id
   ORDER BY cost DESC
   LIMIT 20;
   ```
5. **Prevention:** Set up Budget alerts and Cost Anomaly Detection alerts

---

### Scenario 3: RI vs Savings Plans

**Question:** A company runs 50 m5.xlarge and 30 c5.2xlarge instances 24/7 in us-east-1. They also run Fargate tasks and Lambda functions. They want the best pricing commitment. What should they purchase?

**Answer:** A combination:
1. **EC2 Instance Savings Plan** for m5 family in us-east-1 (deepest discount for known workload)
2. **Compute Savings Plan** for the rest (covers c5, Fargate, Lambda with flexibility)
3. Commitment = sum of hourly On-Demand equivalent at SP discount rate
4. Leave ~20% uncovered for flexibility

---

### Scenario 4: Chargeback Implementation

**Question:** A company needs to charge each development team for their AWS usage. Teams use shared networking and security infrastructure. How to implement?

**Answer:**
1. **Tagging:** Require `Owner` tag on all resources → direct attribution
2. **Cost Categories:** Map `Owner` tag to team names
3. **Shared costs:** Allocate networking/security proportionally (by each team's percentage of total compute spend)
4. **CUR + Athena:** Generate per-team cost reports
5. **Automation:** Monthly Lambda generates team reports, sends via SES

```
Team A direct costs:    $10,000
Team B direct costs:    $15,000
Team C direct costs:    $5,000
Total direct:           $30,000

Shared infrastructure:  $6,000
Team A share (33.3%):   $2,000
Team B share (50%):     $3,000
Team C share (16.7%):   $1,000

Team A total: $12,000
Team B total: $18,000
Team C total: $6,000
```

---

> **Key Exam Tips Summary:**
> 1. **Cost Explorer** = visualization, analysis, forecasting, anomaly detection
> 2. **Budgets** = proactive alerts + automated actions (SCPs, IAM policies, stop instances)
> 3. **CUR** = most detailed cost data, analyze with Athena, visualize with QuickSight
> 4. **Billing Conductor** = custom billing for MSPs or internal showback
> 5. **Cost Allocation Tags** = must be ACTIVATED before they appear in billing
> 6. **Consolidated Billing** = volume discounts, RI sharing, SP sharing
> 7. **RI Sharing** = enabled by default, can be disabled at payer level
> 8. **Unblended costs** = actual per-resource rate (use for chargeback)
> 9. **Amortized costs** = upfront spread over term (use for true resource cost)
> 10. **Cost Categories** = group costs by custom business dimensions
> 11. **Tag Enforcement** = SCPs + Config Rules + Tag Policies
> 12. **FinOps** = Inform → Optimize → Operate (continuous cycle)
