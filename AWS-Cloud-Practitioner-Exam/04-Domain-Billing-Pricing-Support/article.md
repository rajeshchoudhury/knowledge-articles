# Domain 4 — Billing, Pricing, and Support (12%)

> **Domain weight:** 12% (~**6 of 50 scored questions**) — smallest domain by
> weight but **often the easiest to boost your score** on because the
> question pool is narrow and predictable.
>
> **Task statements in CLF-C02:**
> 4.1 Compare AWS pricing models.
> 4.2 Understand resources for billing, budget, and cost management.
> 4.3 Identify AWS technical resources and AWS Support options.

Expect "which plan / tool / program?" questions. Memorize the tables.

---

## 1. AWS pricing fundamentals

AWS pricing follows three principles:

1. **Pay-as-you-go** — you only pay for what you consume; no long-term
   commitments (though commitments get you discounts).
2. **Pay less when you reserve** — long-term commitments (1 or 3 years)
   trade flexibility for up-to-72% savings (RIs, Savings Plans).
3. **Pay less per unit by using more** — tiered pricing reduces
   per-unit rates at higher consumption (e.g., S3 storage tiers, data
   transfer tiers).
4. **Pay even less as AWS grows** — AWS has cut prices 100+ times; you
   benefit automatically.

### 1.1 How AWS bills things (the 3 fundamental charge types)

- **Compute** — per second (Linux) or per hour (Windows, many commercial
  licenses), with 60-second minimums on most families.
- **Storage** — per GB-month, with tier + class variability.
- **Data transfer** — per GB (out to internet, cross-Region; *into* AWS is
  almost always **free**; within a Region between AZs is charged).

### 1.2 Always-free, tier-free, and commonly-misunderstood

Always free (no time limit, regardless of Free Tier):
- Data **into** AWS (inbound data transfer)
- Between EC2 and S3 **in the same Region** (inbound and outbound via S3
  endpoints or via public IP when S3 is in the same Region)
- IAM, Organizations, Consolidated Billing
- CloudFormation (itself; resources you create are billed)
- Elastic Beanstalk (itself), OpsWorks (itself)
- Auto Scaling (itself)
- AWS Cost Explorer UI
- VPC itself (subnets, route tables, ACLs, SGs, IGW)
- Amazon VPC Reachability Analyzer runs — not free (charged per probe)

Commonly-charged things people think are free:
- NAT Gateway ($/hour + $/GB processed)
- Public IPv4 addresses (as of Feb 2024, $0.005/hr for every public IPv4,
  assigned or not)
- Data transfer between AZs in the same Region (still charged)
- Elastic IPs **not associated** with a running instance
- CloudWatch **detailed** metrics and **custom** metrics
- CloudTrail **data events** (Management events free first trail only)

---

## 2. AWS Free Tier (three flavors)

| Type | Duration | Example offers |
|---|---|---|
| **Always Free** | Forever | Lambda: 1M requests + 400K GB-s / month; DynamoDB: 25 GB; S3 Glacier: 10 GB retrieval/month; CloudFront: 1 TB out/month; many more |
| **12-month Free Tier** | 12 months from account creation | EC2 t2.micro (or t3.micro in unsupported Regions): 750 hrs/month; S3 Standard: 5 GB; RDS: 750 hrs of db.t2/t3.micro; ELB: 750 hrs |
| **Trials / Free Credits** | Short period | SageMaker Studio: 2 months free; Lightsail: 3 months; Redshift: 2-month trial of DC2.large; many more |

▶ **Gotcha:** *Exceeding* Free Tier usage incurs normal charges — the
allowance doesn't renew across months for non-Always-Free items. Use
**AWS Budgets** to alert on Free Tier overrun.

---

## 3. EC2 purchase options (must memorize)

| Option | Commitment | Discount vs OD | Notes |
|---|---|---|---|
| **On-Demand (OD)** | None | 0% | Flexibility. Per-second billing. |
| **Reserved Instances (Standard)** | 1 or 3 years | Up to **72%** | Must match instance attrs; can change AZ / size within family with limits. |
| **Reserved Instances (Convertible)** | 1 or 3 years | Up to **54%** | Can exchange for different family, OS, tenancy; must remain ≥ current value. |
| **Compute Savings Plans** | 1 or 3 years | Up to **66%** | Flexibility across EC2 family, Region, OS, tenancy, **Lambda, Fargate, SageMaker compute**. |
| **EC2 Instance Savings Plans** | 1 or 3 years | Up to **72%** | Locked to an instance family in a Region; can change size, OS, AZ, tenancy within family. |
| **SageMaker Savings Plan** | 1 or 3 years | Up to **64%** | SageMaker compute. |
| **Spot Instances** | None | Up to **90%** | Spare capacity; can be interrupted with 2-min notice. |
| **Spot Blocks** | 1–6 hours | Varies (deprecated — new accounts cannot use) | — |
| **Dedicated Hosts** | On-Demand, RI, SP-style | Pay for a **physical host** | BYOL (Windows, SQL Server, Oracle) and compliance requiring physical tenancy; visibility of sockets/cores. |
| **Dedicated Instances** | On-Demand, RI | Runs on HW dedicated to your account | Less visibility than Dedicated Host. |
| **Capacity Reservations** | No commit (pay OD rates while active) | 0% | Reserve capacity in an AZ; combine with Savings Plan / RI for discounts. |

### 3.1 Payment terms for RIs and Savings Plans

- **All Upfront (AURI)** — biggest discount.
- **Partial Upfront (PURI)** — middle.
- **No Upfront (NURI)** — smallest discount, monthly payments.

### 3.2 Selection rule

```
Short/unpredictable workload?                → On-Demand
Predictable steady-state (24×7 baseline)?    → Savings Plan (Compute for flexibility; EC2 Instance for max discount)
Long-term, instance-type stable workload?    → Reserved Instance
Want to change instance family freely?       → Convertible RI or Compute Savings Plan
Interrupt-tolerant batch / stateless web?    → Spot
Compliance / BYOL requiring physical host?   → Dedicated Host
Tenancy isolation w/o host-level controls?   → Dedicated Instances
Need capacity *reserved* without discount?   → Capacity Reservation (optionally combined w/ SP/RI)
```

### 3.3 Capacity Reservation vs RI (common confusion)

- **Capacity Reservation** — reserves **physical capacity** in an AZ. You
  still pay On-Demand while it exists. Guarantees the instance is available
  when you launch. Does **not** provide a discount by itself.
- **RI** — a **billing discount** commitment (and, if Zonal RI, provides
  capacity reservation also).
- **Savings Plan** — a billing discount commitment; does **not** reserve
  capacity.

---

## 4. Storage & data transfer pricing basics

Just memorize the relative directions:

- S3 cheaper → Standard > IT > Standard-IA ≈ One Zone-IA > Glacier IR >
  Glacier FR > Glacier DA (roughly decreasing $ per GB-month).
- EBS: io2 BX > io2/io1 > gp3 > gp2 > st1 > sc1 (roughly decreasing
  $/GB-month for SSDs then HDDs; IOPS costs extra on provisioned).
- RDS: single-AZ < Multi-AZ (2× compute) < Multi-AZ cluster w/ two readable
  standbys. Aurora storage is I/O + GB-month; Aurora I/O-Optimized
  available for I/O-heavy workloads.

### 4.1 Data transfer rules

- In **always free**.
- Within the same AZ over private IP: free.
- Between AZs in the same Region: **charged** both directions (typically
  $0.01/GB each way).
- Between Regions (including replication): charged by source Region rate.
- Out to internet: tiered, ~$0.09/GB for the first tier in us-east-1.
- CloudFront egress is typically cheaper than EC2 egress.
- Data transfer from AWS to the internet is the **biggest surprise** cost
  for new architects; design for CloudFront offload and VPC endpoints to
  S3/DynamoDB to avoid it.

---

## 5. AWS Organizations and consolidated billing

- One **payer (management) account** pays for all member accounts.
- **Volume discounts pool** across the org (S3, data transfer tiers).
- **Reserved Instance and Savings Plan sharing** by default (can disable
  per account).
- **Single invoice** summarizing all accounts; detail per account.
- **Free** (no extra cost for Organizations).

🧭 **Architect's perspective:** Consolidated billing is a massive cost lever.
Moving independent accounts into one org often saves 5–15% immediately due
to tier aggregation.

### 5.1 Pricing governance artifacts

- **Tags** — apply `CostCenter`, `Environment`, `Owner`, etc. Activate
  **cost-allocation tags** in Billing console.
- **Cost categories** — user-defined buckets for spend aggregation.
- **Billing permissions** — IAM + "Activate IAM Access to Billing" on root.

---

## 6. AWS cost management tools

### 6.1 AWS Cost Explorer

- Free UI for browsing up to 13 months history (+ 12-month forecast).
- Filter / group by service, linked account, tag, usage type, region, AZ.
- Reservation / Savings Plan utilization and coverage reports.
- Rightsizing recommendations (EC2, ASG, Lambda).
- Reserved Instance / Savings Plan recommendations.
- **Cost Explorer API** for programmatic access.

### 6.2 AWS Budgets

- Create budgets for cost, usage, RI utilization/coverage, SP
  utilization/coverage.
- Alerts via SNS + email when actual or forecasted amounts cross
  thresholds.
- **Budget Actions** — auto-apply IAM policies or stop EC2/RDS instances
  when a budget is breached.

### 6.3 AWS Cost and Usage Report (CUR)

- Granular, hourly or daily cost data — the authoritative record of your
  bill.
- Delivered to S3 as parquet or CSV.
- Can be integrated with Athena, Redshift, QuickSight, or third-party FinOps
  tools.
- **CUR 2.0** format (since 2023) uses a Data Exports pipeline with
  improved schema.

### 6.4 AWS Pricing Calculator

- Estimate architecture costs before deploying.
- Shareable URL; export to Excel or PDF.
- Supports most services; good for RFPs and customer quotes.

### 6.5 AWS Cost Anomaly Detection

- ML-based detection of unusual spend patterns per service, account, or
  cost category.
- Daily / weekly / individual anomaly alerts via SNS or email.
- **Free** for AWS customers.

### 6.6 AWS Billing Conductor

- Build custom **pro-forma billing** for chargeback / resale scenarios.
- Used by MSPs and enterprises with internal cost-allocation needs.

### 6.7 AWS Marketplace

- Storefront for third-party software with AWS-billed procurement.
- Consolidates third-party costs on your AWS invoice.
- Supports private offers, professional-services engagements, containers,
  machine learning models.

### 6.8 AWS Trusted Advisor — Cost checks

- Idle load balancers.
- Low-utilization EC2.
- Underutilized EBS volumes.
- Unassociated Elastic IPs.
- Reserved Instance / Savings Plan recommendations.
- RDS idle instances.
- S3 bucket not using lifecycle.

(Business and Enterprise plans get the full set; Developer and Basic get
only the 7 core Security checks plus limited Service Limits.)

### 6.9 Compute Optimizer

- ML-driven right-sizing recommendations for EC2, ASG, EBS, Lambda, ECS on
  Fargate, and RDS (preview).
- **Free**.

### 6.10 Selection rule (cost management)

```
"How much will this architecture cost?"            → Pricing Calculator
"Show me where spend went last month by tag/svc."  → Cost Explorer
"Alert me if I exceed $500 this month."            → Budgets
"Auto-stop EC2 when budget exceeded."              → Budgets Actions
"Give me hourly bill data for Athena/analytics."   → Cost & Usage Report (CUR)
"Spot unusual spikes I didn't notice."             → Cost Anomaly Detection
"Right-size EC2/EBS/Lambda/ECS/ASG."               → Compute Optimizer
"General best practice + cost checks."             → Trusted Advisor
"Custom chargeback / reseller billing."            → Billing Conductor
"Tax calculations / invoice PDFs / My Bill."       → Billing Console
```

---

## 7. AWS Support plans

Five tiers. **Memorize which features appear at which tier.**

| Plan | Monthly price | Case severity SLA | Access to … |
|---|---|---|---|
| **Basic** | $0 | — | Account/billing support; documentation, whitepapers, forums; Trusted Advisor core checks; AWS Health |
| **Developer** | From **$29** or 3% of usage | General guidance < 24 business h; System impaired < 12 business h | Business-hours email to Cloud Support Associate; best practices advice |
| **Business** | From **$100** or 10%/7%/5%/3% tiered of usage | Prod system impaired < 4 h; Prod system down < 1 h | 24×7 phone/chat/email to Cloud Support Engineers; **Full Trusted Advisor**; **AWS Support API**; third-party software support (Microsoft AD, IIS; common OSS); Infrastructure Event Management (additional cost) |
| **Enterprise On-Ramp** | From **$5,500** or 10% tiered | Business-critical down < 30 min | Business plan features + *pool* of TAMs (not dedicated); Cost Optimization workshop; Concierge (billing) support; WAR annually; IEM included |
| **Enterprise** | From **$15,000** or 10% tiered | Business-critical down < 15 min | Enterprise On-Ramp features + **dedicated Technical Account Manager (TAM)**; proactive reviews; training credits; IEM; Infrastructure Event Management; AWS Countdown; Concierge; Operations Reviews; Well-Architected Reviews on demand |

### 7.1 Key distinguishing features (exam tips)

- **Trusted Advisor full checks** → **Business** and above.
- **24×7 phone/chat** → **Business** and above.
- **Third-party software support** → **Business** and above.
- **Dedicated TAM** → **Enterprise** only.
- **Pool of TAMs** → **Enterprise On-Ramp**.
- **Well-Architected Reviews** guided by AWS → **Enterprise On-Ramp /
  Enterprise**.
- **Infrastructure Event Management (IEM)** — included in Enterprise and
  Enterprise On-Ramp; add-on purchase in Business.
- **Concierge (billing expert)** → **Enterprise On-Ramp** and **Enterprise**.

### 7.2 Severity levels (Business and above)

| Severity | Description | First-response SLA |
|---|---|---|
| **Critical** (Enterprise/On-Ramp) | Business critical system down | 15 min (Ent) / 30 min (On-Ramp) |
| **Urgent** | Production system down | < 1 h (Business) |
| **High** | Production impaired | < 4 h |
| **Normal** | Non-production impaired | < 12 business h |
| **Low** | General guidance | < 24 business h |

---

## 8. Other AWS technical resources and programs

### 8.1 AWS Professional Services

Global team that delivers architectural, advisory, and implementation
services. Paid engagements.

### 8.2 AWS Partner Network (APN)

- **Consulting Partners** (now "Services Partners") — SIs, MSPs,
  resellers, VARs.
- **Technology Partners** (ISVs) — build software on AWS.
- **Competencies** — industry or workload specializations (SAP, DevOps,
  ML, Security, Financial Services, Healthcare, etc.).
- **Programs**:
  - **AWS Managed Service Provider (MSP)** — validated ops partners.
  - **AWS Marketplace Seller** — list ISV software in Marketplace.
  - **AWS Solution Provider / Distribution** — resell.
- **AWS Partner Central** — partner console.

### 8.3 AWS IQ

Connects AWS customers with **AWS-certified freelancers** for on-demand
project-based help. Ideal for SMBs needing one-off work.

### 8.4 AWS Managed Services (AMS)

AWS operates your AWS environment for you (infrastructure ops, security
baseline, incident management). Two offerings:
- **AMS Accelerate** — opt-in operations on your existing accounts.
- **AMS Advanced** — stricter landing zone, full-ops delivery.

### 8.5 AWS Support Center (console)

One-stop place for technical cases, service-limit cases, account/billing
cases, premium support features.

### 8.6 AWS re:Post (community Q&A), AWS Knowledge Center

Free, community-supported Q&A site (replaced the old AWS Forums). AWS
Knowledge Center has articles by AWS Support for common issues.

### 8.7 AWS Training and Certification

- **AWS Skill Builder** — self-paced digital learning (free and subscription).
- **Classroom training** — instructor-led via AWS or Authorized Training
  Partners.
- **AWS Academy** — for higher education.
- **AWS Educate** — for K-12 / cloud learners of all ages (revamped 2023).
- **Certifications:**
  - Foundational: Cloud Practitioner (CLF-C02), AI Practitioner.
  - Associate: Solutions Architect (SAA-C03), Developer (DVA-C02),
    SysOps Admin (SOA-C02), Data Engineer (DEA-C01), Machine Learning
    Engineer, Machine Learning – Associate (beta/new).
  - Professional: Solutions Architect (SAP-C02), DevOps Engineer (DOP-C02).
  - Specialty: Advanced Networking (ANS-C01), Security (SCS-C02),
    Machine Learning (MLS-C01).
  - Most Specialty certs are being reorganized; always check the
    official list.

### 8.8 Whitepapers and reference architectures

- **AWS Architecture Center**.
- **AWS Well-Architected Labs**.
- **AWS Prescriptive Guidance**.
- **AWS Security Reference Architecture (AWS SRA)**.
- **AWS Global Infrastructure** page.

---

## 9. Exam-angles on Domain 4

Every Domain 4 question maps to one of **5 archetypes**:

1. **"Which plan / tier?"** — e.g., *"Customer needs a dedicated TAM"* →
   Enterprise.
2. **"Which tool?"** — Budgets vs Cost Explorer vs CUR vs Pricing Calculator
   vs Cost Anomaly Detection.
3. **"Which purchase option?"** — OD vs RI vs SP vs Spot.
4. **"Which partner program?"** — APN Consulting/Tech, MSP, IQ, AMS,
   Professional Services.
5. **"What's free vs charged?"** — identifying charges (data transfer,
   NAT Gateway, public IPv4) and freebies (IAM, Organizations, CloudFormation
   itself, Inbound data transfer).

---

## 10. 30 rapid-fire check questions

1. Which principle converts CapEx to OpEx?
2. What's the largest discount percentage Spot can provide?
3. What's the max discount for a 3-year All-Upfront EC2 Instance Savings
   Plan?
4. What Savings Plan also covers Lambda and Fargate?
5. RI or Savings Plan — which reserves actual capacity?
6. What provides capacity reservation without a discount commitment?
7. Which plan gives you a dedicated TAM?
8. Which plan first unlocks 24×7 phone support?
9. Which plan first unlocks full Trusted Advisor?
10. Which plan offers Concierge billing support?
11. When is Infrastructure Event Management included (not add-on)?
12. Which tool provides hourly billing data for analytics?
13. Which tool forecasts next month's spend in the UI?
14. Which alerts on unusual spend via ML?
15. Which tool estimates a project's cost before deploying?
16. Which service delivers CUR files into S3?
17. What is the cost of AWS Organizations itself?
18. Are NAT Gateways free?
19. Is data transferred *into* AWS charged?
20. Is data between AZs in the same Region charged?
21. Is Amazon VPC charged?
22. What does AMS Accelerate do?
23. What is AWS IQ?
24. What is the MSP competency?
25. Which program finds a certified freelancer for a 2-week project?
26. What is AWS re:Post?
27. Which category of partner resells AWS to customers?
28. What is the basic AWS Free Tier allowance for Lambda?
29. Can Free Tier unused hours roll over to next month?
30. Which category of Trusted Advisor is available at Basic/Developer plans?

*All answers are in the article.*

---

Continue to the **Services Deep Dive** for per-service reference cards,
or jump to **Practice Exams** when you're ready.
