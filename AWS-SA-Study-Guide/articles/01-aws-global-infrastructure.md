# AWS Global Infrastructure

## Table of Contents

- [Overview](#overview)
- [AWS Regions](#aws-regions)
  - [Current AWS Regions](#current-aws-regions)
  - [How to Choose a Region](#how-to-choose-a-region)
  - [Region Codes and Naming](#region-codes-and-naming)
- [Availability Zones (AZs)](#availability-zones-azs)
  - [Physical Separation](#physical-separation)
  - [AZ IDs vs AZ Names](#az-ids-vs-az-names)
  - [AZ Mapping Per Account](#az-mapping-per-account)
- [Edge Locations](#edge-locations)
  - [CloudFront Points of Presence](#cloudfront-points-of-presence)
  - [Regional Edge Caches](#regional-edge-caches)
- [Local Zones](#local-zones)
- [Wavelength Zones](#wavelength-zones)
- [AWS Outposts](#aws-outposts)
- [Global vs Regional vs AZ-Scoped Services](#global-vs-regional-vs-az-scoped-services)
- [Data Residency and Sovereignty](#data-residency-and-sovereignty)
- [AWS GovCloud Regions](#aws-govcloud-regions)
- [Pricing Differences Across Regions](#pricing-differences-across-regions)
- [Exam Tips](#exam-tips)

---

## Overview

AWS Global Infrastructure is the physical and logical foundation upon which all AWS services are built. Understanding how AWS structures its global presence is fundamental to designing resilient, performant, and compliant architectures. The SAA-C03 exam heavily tests your understanding of how to leverage this infrastructure for high availability, disaster recovery, and performance optimization.

As of 2026, AWS operates one of the largest cloud infrastructures in the world, spanning multiple continents with a continuously expanding footprint. The infrastructure is organized in a hierarchy: **Regions** contain **Availability Zones**, which contain one or more **data centers**. Supplementing this core structure are **Edge Locations**, **Local Zones**, **Wavelength Zones**, and **Outposts**.

---

## AWS Regions

An AWS Region is a geographic area that contains a cluster of data centers. Each Region is a separate geographic area, completely independent of other Regions. This design provides fault isolation — a failure in one Region does not affect another Region.

### Current AWS Regions

AWS has launched regions across the globe. Below is a comprehensive list:

#### North America
| Region Name | Region Code | AZs | Year Launched |
|---|---|---|---|
| US East (N. Virginia) | `us-east-1` | 6 | 2006 |
| US East (Ohio) | `us-east-2` | 3 | 2016 |
| US West (N. California) | `us-west-1` | 3 | 2009 |
| US West (Oregon) | `us-west-2` | 4 | 2011 |
| Canada (Central) | `ca-central-1` | 3 | 2016 |
| Canada West (Calgary) | `ca-west-1` | 3 | 2023 |
| GovCloud (US-East) | `us-gov-east-1` | 3 | 2018 |
| GovCloud (US-West) | `us-gov-west-1` | 3 | 2011 |

#### South America
| Region Name | Region Code | AZs | Year Launched |
|---|---|---|---|
| South America (São Paulo) | `sa-east-1` | 3 | 2011 |

#### Europe
| Region Name | Region Code | AZs | Year Launched |
|---|---|---|---|
| Europe (Ireland) | `eu-west-1` | 3 | 2007 |
| Europe (London) | `eu-west-2` | 3 | 2016 |
| Europe (Paris) | `eu-west-3` | 3 | 2017 |
| Europe (Frankfurt) | `eu-central-1` | 3 | 2014 |
| Europe (Stockholm) | `eu-north-1` | 3 | 2018 |
| Europe (Milan) | `eu-south-1` | 3 | 2020 |
| Europe (Spain) | `eu-south-2` | 3 | 2022 |
| Europe (Zurich) | `eu-central-2` | 3 | 2022 |

#### Asia Pacific
| Region Name | Region Code | AZs | Year Launched |
|---|---|---|---|
| Asia Pacific (Singapore) | `ap-southeast-1` | 3 | 2010 |
| Asia Pacific (Sydney) | `ap-southeast-2` | 3 | 2012 |
| Asia Pacific (Jakarta) | `ap-southeast-3` | 3 | 2021 |
| Asia Pacific (Melbourne) | `ap-southeast-4` | 3 | 2023 |
| Asia Pacific (Tokyo) | `ap-northeast-1` | 4 | 2011 |
| Asia Pacific (Seoul) | `ap-northeast-2` | 4 | 2016 |
| Asia Pacific (Osaka) | `ap-northeast-3` | 3 | 2021 |
| Asia Pacific (Mumbai) | `ap-south-1` | 3 | 2016 |
| Asia Pacific (Hyderabad) | `ap-south-2` | 3 | 2022 |
| Asia Pacific (Hong Kong) | `ap-east-1` | 3 | 2019 |
| Asia Pacific (Malaysia) | `ap-southeast-5` | 3 | 2024 |

#### Middle East
| Region Name | Region Code | AZs | Year Launched |
|---|---|---|---|
| Middle East (Bahrain) | `me-south-1` | 3 | 2019 |
| Middle East (UAE) | `me-central-1` | 3 | 2022 |
| Israel (Tel Aviv) | `il-central-1` | 3 | 2023 |

#### Africa
| Region Name | Region Code | AZs | Year Launched |
|---|---|---|---|
| Africa (Cape Town) | `af-south-1` | 3 | 2020 |

> **Note:** Some newer regions are opt-in by default (e.g., af-south-1, ap-east-1, eu-south-1, me-south-1). You must explicitly enable these in the AWS Management Console before you can use them. Opt-in regions require you to enable them in Account Settings. IAM is global, but STS endpoints in opt-in regions must be activated separately.

### How to Choose a Region

Choosing the right AWS Region is a critical architectural decision. The exam tests this frequently. Consider these four factors **in order of priority**:

#### 1. Compliance / Data Governance / Legal Requirements
- **This is always the first consideration.** If your data must remain within a specific country or jurisdiction, that requirement overrides all other factors.
- Example: A French company handling French citizens' data under GDPR might choose `eu-west-3` (Paris).
- Example: A US government workload requiring ITAR compliance must use GovCloud.
- Some industries (healthcare, financial services) have specific regulatory requirements about data location.

#### 2. Latency / Proximity to Users
- Deploy resources close to the majority of your end users to minimize latency.
- Use tools like [CloudPing](https://www.cloudping.info/) to measure latency from your location to various Regions.
- For global user bases, consider multi-region deployments with Route 53 latency-based routing.
- Typical inter-region latency ranges from 50ms to 300ms+ depending on distance.

#### 3. Service Availability
- Not all AWS services are available in every Region. New services typically launch first in `us-east-1` (N. Virginia).
- Always check the [AWS Regional Services List](https://aws.amazon.com/about-aws/global-infrastructure/regional-product-services/) before choosing a Region.
- `us-east-1` has the broadest service availability. It is also the default Region for many AWS services and the console.
- Some services are only available in specific Regions (e.g., certain AI/ML services).

#### 4. Pricing
- Pricing varies across Regions. For example, `sa-east-1` (São Paulo) and `ap-southeast-2` (Sydney) tend to be more expensive than `us-east-1`.
- Data transfer costs also vary between Regions.
- Use the AWS Pricing Calculator to compare costs across Regions.

> **Exam Tip:** If a question mentions "regulatory requirements" or "data must stay in [country]," compliance is the answer for Region selection — always.

### Region Codes and Naming

Region codes follow a consistent pattern:
```
<geographic-area>-<sub-area>-<number>
```

Examples:
- `us-east-1` = United States, East, first region
- `eu-west-3` = Europe, West, third region
- `ap-southeast-1` = Asia Pacific, Southeast, first region

The AWS Management Console displays friendly names (e.g., "US East (N. Virginia)"), while APIs and CLI use region codes (e.g., `us-east-1`).

---

## Availability Zones (AZs)

An Availability Zone is one or more discrete data centers with redundant power, networking, and connectivity within a Region. AZs are the fundamental building blocks for high availability in AWS.

### Physical Separation

- Each AZ is physically separated from other AZs within the same Region by a **meaningful distance** (typically miles/kilometers apart), enough to reduce the risk of a single event (fire, flood, tornado) affecting multiple AZs.
- Despite physical separation, AZs within a Region are connected through **high-bandwidth, low-latency private fiber-optic networking** (typically single-digit millisecond latency between AZs in the same Region).
- Each AZ has **independent power supply** from different utility grids or substations, with multiple tiers of backup power (UPS, generators).
- Each AZ has **independent networking connectivity** with multiple tier-1 transit providers.
- Each AZ has **independent cooling, physical security**, and fire suppression.
- A single AZ can consist of one or more physical data centers (buildings), but AWS abstracts this as a single logical unit.

### AZ IDs vs AZ Names

This is a subtle but important concept that AWS tests:

**AZ Names** (e.g., `us-east-1a`, `us-east-1b`) are mapped **differently for each AWS account**. This means:
- Account A's `us-east-1a` might be a physically different data center than Account B's `us-east-1a`.
- AWS does this to distribute load evenly across AZs. If every account's "a" zone was the same physical AZ, it would be disproportionately loaded.

**AZ IDs** (e.g., `use1-az1`, `use1-az2`) are **consistent physical identifiers** across all accounts. They map to the same physical AZ regardless of the account.

```
Account A:                    Account B:
us-east-1a → use1-az2        us-east-1a → use1-az1
us-east-1b → use1-az1        us-east-1b → use1-az3
us-east-1c → use1-az3        us-east-1c → use1-az2
```

### AZ Mapping Per Account

- When you create an AWS account, AZ name-to-physical-AZ mappings are randomly assigned.
- This mapping is **fixed for the lifetime of the account** — it does not change.
- Use AZ IDs (not AZ names) when coordinating resources across accounts (e.g., placing resources in the same physical AZ for low-latency communication in a multi-account setup).
- You can find your AZ ID mappings in the EC2 console or by calling the `describe-availability-zones` API.

### Key AZ Facts for the Exam
- Most Regions have **3 AZs** (minimum), some have **4 or 6**.
- You should always design for **multi-AZ** deployments for high availability.
- Services like RDS Multi-AZ, ELB, and Auto Scaling automatically distribute across AZs.
- Data transfer between AZs in the same Region incurs a small charge (typically $0.01/GB).
- Data transfer within the same AZ is free for private IP communication.
- Some services are AZ-scoped (EBS, EC2 instances, subnets), some are Regional (S3, DynamoDB, Lambda).

---

## Edge Locations

Edge Locations are AWS data centers designed to deliver content to end users with the lowest possible latency. They are separate from Regions and AZs.

### CloudFront Points of Presence

- AWS operates **600+ Points of Presence (PoPs)** globally, including 400+ Edge Locations and 13+ Regional Edge Caches in 100+ cities across 50+ countries.
- Edge Locations are used by:
  - **Amazon CloudFront** (CDN) — caches content close to users
  - **Amazon Route 53** (DNS) — answers DNS queries from the nearest location
  - **AWS Shield** — DDoS protection at the edge
  - **AWS WAF** — Web Application Firewall at the edge
  - **Lambda@Edge / CloudFront Functions** — run code at the edge

### Regional Edge Caches

Regional Edge Caches sit between your origin server and the Edge Locations. They are larger caches that:
- Have a **larger cache capacity** than individual Edge Locations
- Retain content **longer** than Edge Locations (because more cache space)
- Serve as a **middle tier** — when content expires from an Edge Location, it checks the Regional Edge Cache before going all the way back to the origin
- Reduce the load on your origin servers
- Are used automatically — no configuration needed

**Cache Hierarchy:**
```
User Request → Edge Location → Regional Edge Cache → Origin Server
```

If the content is found at any layer, it's served from there without going further back. This dramatically reduces origin load and improves performance for less-popular content that might not be cached at every Edge Location.

---

## Local Zones

AWS Local Zones are extensions of an AWS Region that place compute, storage, database, and other select AWS services closer to large population, industry, and IT centers.

### Purpose
- Deliver **single-digit millisecond latency** to end users in specific metropolitan areas
- Run **latency-sensitive workloads** closer to end users without deploying a full Region
- Extend your VPC into the Local Zone by creating a subnet in the Local Zone

### Use Cases
- Real-time gaming
- Live video streaming
- AR/VR applications
- Machine learning inference at the edge
- Media and entertainment content creation
- Electronic design automation
- Any workload requiring ultra-low latency to a specific metro area

### Available Services in Local Zones
- Amazon EC2 (select instance types)
- Amazon EBS
- Amazon FSx
- Amazon ECS / EKS
- Application Load Balancer
- Amazon RDS (select)
- Amazon ElastiCache

### Key Characteristics
- Local Zones appear as additional AZs in the Region they extend
- You create subnets in Local Zones just like in regular AZs
- They are **opt-in** — you must enable them before use
- Local Zones connect back to the parent Region via AWS's private high-bandwidth network
- Limited service availability compared to full Regions
- Internet access in Local Zones can use local ISP connections for reduced latency
- Available in many US cities (Los Angeles, Boston, Houston, Miami, etc.) and expanding internationally

### Architecture Pattern
```
Region (us-west-2)
├── AZ: us-west-2a (Oregon)
├── AZ: us-west-2b (Oregon)
├── AZ: us-west-2c (Oregon)
└── Local Zone: us-west-2-lax-1a (Los Angeles)
```

You can place resources in the Local Zone and they join your existing VPC, allowing private connectivity back to the Region.

---

## Wavelength Zones

AWS Wavelength embeds AWS compute and storage services within telecommunications providers' 5G networks, providing ultra-low latency to mobile devices and end users.

### Purpose
- Deliver **single-digit millisecond latency** to mobile devices connected to 5G networks
- Minimize the number of network hops between the device and the application
- Traffic from the device to the Wavelength Zone never leaves the carrier's network

### How It Works
1. AWS deploys infrastructure (Wavelength Zones) inside telecom provider data centers at the edge of 5G networks.
2. You create a **Wavelength subnet** within your VPC.
3. You launch EC2 instances and other resources in the Wavelength subnet.
4. 5G devices connect to your application through the carrier network, hitting the Wavelength Zone directly — never traversing the public internet.

### Use Cases
- Interactive live video streaming
- ML inference at the edge
- AR/VR for 5G users
- Connected vehicles and IoT
- Real-time gaming for mobile users
- Smart factory automation

### Key Characteristics
- Carrier partners include Verizon, Vodafone, KDDI, SK Telecom, Bell Canada
- Wavelength Zones appear as special AZs in your Region
- Limited services available: EC2, EBS, ECS, EKS, CloudWatch, CloudFormation, IAM, VPC
- **Carrier Gateway** provides connectivity between Wavelength Zone and the carrier network / internet
- Resources in Wavelength Zones can communicate with resources in the parent Region via the VPC
- Wavelength Zones have **carrier IP addresses** assigned from the carrier's IP pool

---

## AWS Outposts

AWS Outposts brings AWS infrastructure, services, APIs, and tools to virtually any data center, co-location space, or on-premises facility. It is essentially a piece of AWS hardware that lives in your data center.

### Purpose
- Run AWS services **on-premises** with the same APIs, tools, and hardware as in the cloud
- Support workloads that require **low-latency access to on-premises systems**
- Meet **data residency requirements** where data must remain in a specific physical location
- Support **local data processing** before transferring results to the cloud

### Form Factors

#### Outposts Rack
- **Full 42U rack** (or partial rack options: 1U, 2U servers)
- Installed in your data center by AWS
- Provides a wide range of AWS services (EC2, EBS, S3, RDS, ECS, EKS, EMR, ElastiCache)
- Connected to the nearest AWS Region via a **service link** (private, encrypted connection)
- Requires reliable network connection to the parent Region
- **AWS owns and manages** the hardware; you provide power, cooling, and network
- Minimum order: 1 rack (42U) with different configuration options

#### Outposts Servers
- **1U or 2U server form factor** for space-constrained environments
- Provides a subset of services (EC2, EBS, ECS, SageMaker Edge, IoT Greengrass)
- Good for retail stores, branch offices, factory floors
- Smaller footprint than a full rack

### Key Characteristics
- Outposts resources appear in your AWS console alongside cloud resources
- You manage Outposts through the same AWS APIs and console
- AWS is responsible for **monitoring, patching, updating, and maintaining** the Outposts hardware
- Outposts requires a **service link** — a connection back to the parent Region for management, control plane operations, and some API calls
- If connectivity to the Region is lost, some local operations continue (existing EC2 instances keep running), but you cannot launch new instances or make API calls that require the Region
- S3 on Outposts stores data locally and optionally replicates to S3 in the Region
- EBS snapshots on Outposts are stored on the Outpost's local storage (and can be copied to the Region)

### Common Exam Scenarios
- "Run AWS services on-premises" → **Outposts**
- "Data must not leave the premises but must use AWS services" → **Outposts**
- "Low-latency access to on-premises systems needed alongside AWS workloads" → **Outposts**
- "Small form factor for edge/retail locations" → **Outposts Servers**

---

## Global vs Regional vs AZ-Scoped Services

Understanding the scope of each AWS service is critical for the exam. It determines how you design for availability and what happens when an AZ or Region goes down.

### Global Services
These services operate across all Regions and are not tied to a single Region:

| Service | Notes |
|---|---|
| **IAM** | Users, groups, roles, policies are global |
| **Route 53** | DNS is global |
| **CloudFront** | CDN distributions are global |
| **WAF** (when used with CloudFront) | Global edge rules |
| **Shield Advanced** | Global DDoS protection |
| **AWS Organizations** | Global account management |
| **STS** | Global service with regional endpoints |
| **Artifact** | Compliance reports (global) |
| **Health Dashboard** (Service) | Global view of AWS service health |
| **Billing / Cost Explorer** | Global (always in us-east-1 context) |
| **Global Accelerator** | Anycast IPs are global |
| **AWS Identity Center (SSO)** | Global (deployed in a home Region) |

### Regional Services
These services operate within a single Region but span all AZs in that Region:

| Service | Notes |
|---|---|
| **S3** | Buckets are in a Region; bucket names are globally unique |
| **DynamoDB** | Tables are Regional (Global Tables replicate across Regions) |
| **Lambda** | Functions are Regional |
| **API Gateway** | APIs are Regional (or Edge-optimized) |
| **Step Functions** | Workflows are Regional |
| **SQS** | Queues are Regional |
| **SNS** | Topics are Regional |
| **KMS** | Keys are Regional (cannot be transferred across Regions) |
| **Secrets Manager** | Secrets are Regional |
| **CloudWatch** | Metrics/logs are Regional |
| **CloudTrail** | Trails can be single-Region or all-Regions |
| **VPC** | VPCs span a Region (subnets are AZ-scoped) |
| **ELB (ALB/NLB/GWLB)** | Load balancers are Regional (span AZs) |
| **Auto Scaling** | Groups are Regional (launch across AZs) |
| **RDS** | Multi-AZ is within a Region; Cross-Region Read Replicas span Regions |
| **Aurora** | Regional (Aurora Global Database spans Regions) |
| **ElastiCache** | Clusters are Regional |
| **ECS / EKS** | Clusters are Regional |
| **ECR** | Repositories are Regional |
| **CodePipeline / CodeBuild / CodeDeploy** | Regional |
| **CloudFormation** | Stacks are Regional (StackSets can span Regions) |
| **Config** | Regional (Aggregator can combine across Regions/accounts) |
| **GuardDuty** | Regional (must enable per Region) |
| **Inspector** | Regional |
| **Macie** | Regional |
| **Systems Manager** | Regional |

### AZ-Scoped Services
These are tied to a specific Availability Zone:

| Service | Notes |
|---|---|
| **EC2 Instances** | Run in a specific AZ |
| **EBS Volumes** | Exist in a specific AZ; snapshots are Regional |
| **Subnets** | Each subnet is in exactly one AZ |
| **ENI (Elastic Network Interface)** | Tied to a specific AZ/subnet |
| **RDS (Single-AZ)** | Primary DB is in one AZ |
| **ElastiCache Nodes** | Individual nodes are in specific AZs |
| **Redshift Nodes** | Cluster nodes in specific AZs |
| **EFS Mount Targets** | One per AZ (but EFS itself is Regional) |

> **Critical Exam Concept:** If an AZ fails:
> - AZ-scoped resources in that AZ are unavailable
> - Regional resources (S3, DynamoDB, Lambda) continue to function
> - Global services are unaffected
> - Multi-AZ deployments survive (RDS Multi-AZ, ALB across AZs)

---

## Data Residency and Sovereignty

### Key Concepts

**Data Residency** refers to the geographic location where data is stored and processed.

**Data Sovereignty** refers to the laws and governance that apply to data based on the country/region where it is collected or stored.

### AWS's Approach

- **AWS never moves your data out of a Region unless you explicitly configure it to do so** (e.g., cross-Region replication, CloudFront caching, etc.).
- You control which Region your data is stored in.
- Some services have global components (e.g., IAM, Route 53), but the underlying data for most services stays in the Region you choose.
- AWS provides tools and features to enforce data residency:
  - **SCPs (Service Control Policies):** Deny access to specific Regions using `aws:RequestedRegion` condition key
  - **IAM Policies:** Restrict users/roles to specific Regions
  - **AWS Config Rules:** Monitor and alert on resources outside approved Regions
  - **VPC Endpoints:** Keep data within the AWS network (no internet traversal)
  - **AWS CloudTrail:** Audit all API calls to ensure compliance

### Common Compliance Frameworks

| Framework | Region Relevance |
|---|---|
| **GDPR** (EU) | Data of EU residents; consider EU Regions |
| **HIPAA** (US) | Health data; AWS has BAA-eligible services |
| **SOC 1/2/3** | Available in most Regions |
| **PCI DSS** | Payment card data; available in most Regions |
| **FedRAMP** | US government; GovCloud or authorized Regions |
| **ITAR** | US military/defense; GovCloud only |
| **IRAP** (Australia) | Australian government; `ap-southeast-2` assessed |
| **C5** (Germany) | German government; `eu-central-1` assessed |

### SCP Example to Restrict Regions

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyAllOutsideEU",
      "Effect": "Deny",
      "NotAction": [
        "iam:*",
        "organizations:*",
        "sts:*",
        "support:*",
        "budgets:*"
      ],
      "Resource": "*",
      "Condition": {
        "StringNotEquals": {
          "aws:RequestedRegion": [
            "eu-west-1",
            "eu-west-2",
            "eu-central-1"
          ]
        }
      }
    }
  ]
}
```

> **Note:** You must exclude global services (IAM, STS, Organizations, Support, Billing) from Region restrictions because they operate from `us-east-1` regardless of where you access them.

---

## AWS GovCloud Regions

### Overview

AWS GovCloud (US) Regions are isolated AWS Regions designed to host sensitive data, regulated workloads, and workloads that must comply with strict US government compliance requirements.

### Key Characteristics

- **Two GovCloud Regions:** `us-gov-west-1` (Oregon) and `us-gov-east-1` (Ohio)
- Physically and logically isolated from commercial AWS Regions
- Operated by **US persons** (US citizens or permanent residents) on US soil
- Separate AWS accounts from commercial accounts
- Support compliance requirements including:
  - **FedRAMP High** baseline
  - **ITAR** (International Traffic in Arms Regulations)
  - **EAR** (Export Administration Regulations)
  - **DoD SRG** (Department of Defense Cloud Computing Security Requirements Guide)
  - **CJIS** (Criminal Justice Information Services)
  - **HIPAA**
- Access requires a separate sign-up process
- Not all AWS services are available in GovCloud (though coverage is broad and growing)
- Root account holder must pass a screening process
- Data and metadata never leave GovCloud Regions unless you explicitly transfer it

### Who Uses GovCloud?
- US federal, state, and local government agencies
- Government contractors
- Educational and healthcare organizations working with government data
- Companies subject to ITAR or EAR
- Any organization requiring FedRAMP High authorization

> **Exam Tip:** If a question mentions ITAR, EAR, or strict US government compliance, the answer usually involves GovCloud.

---

## Pricing Differences Across Regions

AWS service pricing varies across Regions. This is an important consideration for cost optimization.

### Why Prices Differ
- **Real estate costs** — data center land and construction costs vary
- **Power costs** — electricity prices differ by location
- **Labor costs** — local wages for data center operations
- **Taxes and regulatory costs** — local tax structures
- **Network costs** — connectivity infrastructure costs
- **Supply and demand** — usage patterns in different regions

### General Pricing Patterns

| Pricing Tier | Regions | Notes |
|---|---|---|
| **Lowest** | `us-east-1`, `us-east-2`, `us-west-2` | Oldest, largest, most competitive |
| **Low-Medium** | `eu-west-1`, `eu-central-1`, `ap-northeast-1` | Major established Regions |
| **Medium-High** | `ap-southeast-2`, `ap-south-1`, most EU | Established but smaller |
| **Highest** | `sa-east-1`, `af-south-1`, `ap-east-1` | Newer, smaller, or isolated markets |

### Example Price Comparisons (EC2 On-Demand, m5.xlarge)
- `us-east-1`: ~$0.192/hr (baseline)
- `eu-west-1`: ~$0.210/hr (~10% more)
- `ap-southeast-2`: ~$0.228/hr (~19% more)
- `sa-east-1`: ~$0.278/hr (~45% more)
- `af-south-1`: ~$0.252/hr (~31% more)

> **Note:** Exact prices change frequently. These are illustrative of the relative differences.

### Data Transfer Costs

Data transfer pricing is also critical:
- **Within the same AZ** (using private IP): Free
- **Between AZs in the same Region**: ~$0.01/GB (each direction)
- **Between Regions**: $0.02/GB or more depending on source/destination
- **Out to Internet**: Tiered pricing starting at ~$0.09/GB, decreasing with volume
- **In from Internet**: Free

### Cost Optimization Strategies Related to Infrastructure
1. **Choose the cheapest Region** that meets your compliance and latency requirements.
2. **Use multi-AZ only where needed** — cross-AZ data transfer adds cost.
3. **Consolidate workloads** in fewer Regions to maximize volume discounts.
4. **Use CloudFront** for content delivery instead of serving from distant Regions.
5. **Use VPC endpoints** to avoid NAT Gateway data processing charges.
6. **Monitor with Cost Explorer** and set Budgets for each Region.

---

## Exam Tips

### High-Frequency Exam Topics

1. **Region Selection:** The exam frequently asks "which Region should you choose?" The answer hierarchy is always: Compliance → Latency → Service Availability → Cost.

2. **Multi-AZ Architecture:** Almost every architecture question expects you to design for multi-AZ. If a solution only uses one AZ, it is almost certainly not the best answer.

3. **AZ IDs vs Names:** If a question involves cross-account AZ coordination, use AZ IDs, not AZ names.

4. **Edge Locations vs Regions:** CloudFront uses Edge Locations, not Regions. Lambda@Edge runs at Edge Locations. Route 53 answers DNS queries from Edge Locations.

5. **Local Zones vs Wavelength Zones vs Outposts:**
   - Need low latency to a metro area for general users? → **Local Zone**
   - Need low latency to 5G mobile users? → **Wavelength Zone**
   - Need AWS on-premises? → **Outposts**

6. **Data Residency:** If data must stay in a country, choose a Region in that country. Use SCPs to prevent use of other Regions.

7. **Service Scope:** Know which services are global (IAM, Route 53, CloudFront), Regional (S3, Lambda, DynamoDB), and AZ-scoped (EC2, EBS). This determines failover behavior.

### Common Exam Scenarios

**Scenario 1:** "A company must ensure all data stays within the EU."
→ Use EU Regions + SCP to deny actions outside EU Regions (exclude global services).

**Scenario 2:** "An application needs to serve users globally with low latency."
→ Multi-Region deployment with Route 53 latency-based routing, or single-Region with CloudFront.

**Scenario 3:** "A company needs to run AWS workloads on-premises for data sovereignty."
→ AWS Outposts.

**Scenario 4:** "A gaming company needs single-digit millisecond latency for users in Los Angeles."
→ AWS Local Zone in Los Angeles (us-west-2-lax-1a).

**Scenario 5:** "A mobile application on a 5G network needs ultra-low latency for AR features."
→ AWS Wavelength Zone.

**Scenario 6:** "Two AWS accounts need to coordinate resources in the same physical AZ."
→ Use AZ IDs (not AZ names) to identify the same physical AZ across accounts.

**Scenario 7:** "Which Region is cheapest for running EC2 instances?"
→ Generally `us-east-1` (N. Virginia) offers the lowest prices.

**Scenario 8:** "A company needs ITAR-compliant hosting for defense contractor workloads."
→ AWS GovCloud.

### Key Numbers to Remember
- **600+ Edge Locations** worldwide
- **13+ Regional Edge Caches**
- Most Regions have **3 AZs** (minimum)
- `us-east-1` has **6 AZs** (the most)
- **5 IP addresses** are reserved per subnet
- CIDR block range for VPC: **/16** (max) to **/28** (min)
- Data transfer between AZs: **~$0.01/GB**
- Data transfer between Regions: **$0.02+/GB**

---

## Summary

| Infrastructure Component | Purpose | Scope | Key Use Case |
|---|---|---|---|
| **Region** | Full AWS service deployment | Geographic area | Primary workload hosting |
| **Availability Zone** | Fault isolation within Region | Data center cluster | High availability |
| **Edge Location** | Content delivery and DNS | Global PoPs | CloudFront, Route 53 |
| **Regional Edge Cache** | Mid-tier cache | Between origin and edge | Reduced origin load |
| **Local Zone** | Low-latency metro extension | Specific cities | Latency-sensitive workloads |
| **Wavelength Zone** | 5G edge computing | Carrier network | Mobile ultra-low latency |
| **Outposts** | On-premises AWS | Your data center | Data residency, hybrid |
| **GovCloud** | US government compliance | Isolated US Regions | ITAR, FedRAMP, DoD |

Understanding AWS Global Infrastructure is the foundation for everything else in the SAA-C03 exam. Every architecture decision you make — from storage to compute to networking — builds on these concepts.
