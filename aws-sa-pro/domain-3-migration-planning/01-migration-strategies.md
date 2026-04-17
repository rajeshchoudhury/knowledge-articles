# Migration Strategies — AWS SAP-C02 Domain 3 Deep Dive

## Table of Contents
1. [Cloud Adoption Framework (CAF)](#1-cloud-adoption-framework-caf)
2. [Migration Readiness Assessment](#2-migration-readiness-assessment)
3. [The 7 Rs of Migration](#3-the-7-rs-of-migration)
4. [Decision Framework — When to Use Each R](#4-decision-framework--when-to-use-each-r)
5. [Migration Phases](#5-migration-phases)
6. [Portfolio Assessment and Prioritization](#6-portfolio-assessment-and-prioritization)
7. [Wave Planning](#7-wave-planning)
8. [Large-Scale Migration Patterns](#8-large-scale-migration-patterns)
9. [Migration Project Planning and Governance](#9-migration-project-planning-and-governance)
10. [Exam Scenarios](#10-exam-scenarios)

---

## 1. Cloud Adoption Framework (CAF)

The **AWS Cloud Adoption Framework (CAF)** provides a structured approach to cloud migration through six interdependent perspectives. Each perspective covers distinct responsibilities and is owned by functionally related stakeholders.

### 1.1 Business Perspective

**Owner:** CEO, CFO, COO, CIO, BDM (Business Development Manager)

**Purpose:** Ensures IT aligns with business needs and IT investments link to key business results.

| Capability | Description |
|---|---|
| Strategy Management | Define and document cloud business case, articulate desired outcomes |
| Portfolio Management | Prioritize workloads, establish migration waves |
| Innovation Management | Identify new products/services enabled by cloud |
| Product Management | Manage cloud products through lifecycle |
| Data Monetization | Use data analytics to generate new revenue |
| Business Insight | Real-time data-driven decisions |

**Real-World Scenario:** A retail company moving to AWS creates a business case showing:
- Current on-premises data center costs: $4.2M/year
- Projected AWS costs (after optimization): $2.1M/year
- Revenue gain from faster time-to-market: $1.5M/year
- Total benefit: $3.6M/year improvement

> **Exam Tip:** When questions mention "business case," "cost-benefit analysis," or "executive stakeholders," think Business Perspective.

### 1.2 People Perspective

**Owner:** CIO, COO, CTO, Cloud Director, HR

**Purpose:** Bridge between technology and business. Focuses on culture, organizational structure, skills, and competencies.

| Capability | Description |
|---|---|
| Culture Evolution | Move from siloed to collaborative culture |
| Transformational Leadership | Align leadership to cloud-first mindset |
| Cloud Fluency | Training and certification programs |
| Workforce Transformation | Reskilling, hiring cloud-native talent |
| Change Acceleration | Communication, training, and engagement |
| Organization Design | Cloud Center of Excellence (CCoE) |

**Real-World Scenario:** An insurance company creates a Cloud Center of Excellence (CCoE) with:
- 2 Solutions Architects (AWS certified)
- 1 Security Engineer
- 1 Cloud Financial Analyst (FinOps)
- 1 DevOps Lead
- Training plan: All 200 developers get AWS Cloud Practitioner cert in 6 months

> **Exam Tip:** Questions about organizational readiness, skills gaps, or change management → People Perspective.

### 1.3 Governance Perspective

**Owner:** CTO, CIO, CFO, CDO (Chief Data Officer), Enterprise Architect

**Purpose:** Orchestrate cloud initiatives while maximizing organizational benefits and minimizing transformation-related risks.

| Capability | Description |
|---|---|
| Program & Project Management | Manage cloud programs with agile delivery |
| Benefits Management | Measure and track cloud ROI |
| Risk Management | Identify and mitigate cloud risks |
| Cloud Financial Management | FinOps, budget management, cost optimization |
| Application Portfolio Management | Rationalize application portfolio |
| Data Governance | Data classification, lineage, quality |
| Data Curation | Catalog, enrich, and manage data assets |

**Real-World Scenario:** A financial services firm establishes:
- Cloud governance board meeting monthly
- Automated budget alerts at 50%, 75%, 90% thresholds
- Mandatory tagging policy (CostCenter, Environment, Owner, Application)
- Quarterly portfolio review of all cloud workloads

### 1.4 Platform Perspective

**Owner:** CTO, Technology Leaders, Solutions Architects, Engineers

**Purpose:** Build an enterprise-grade, scalable, hybrid cloud platform, modernize existing workloads, and implement new cloud-native solutions.

| Capability | Description |
|---|---|
| Platform Architecture | Design landing zone, multi-account strategy |
| Data Architecture | Data lake, data mesh, analytics platform |
| Platform Engineering | CI/CD, IaC, automation pipelines |
| Data Engineering | ETL/ELT pipelines, streaming data |
| Provisioning & Orchestration | Self-service infrastructure provisioning |
| Modern App Development | Microservices, serverless, containers |
| Continuous Integration/Delivery | Automated build, test, deploy pipelines |

**Real-World Scenario:** Deploying an AWS Landing Zone using AWS Control Tower:
- Management account for billing and organization
- Security account for centralized logging (CloudTrail, Config)
- Shared Services account for networking (Transit Gateway hub)
- Sandbox, Dev, Staging, Prod OU structure
- Service Control Policies (SCPs) restricting regions and services

### 1.5 Security Perspective

**Owner:** CISO, CCO (Chief Compliance Officer), Security Engineers

**Purpose:** Achieve the confidentiality, integrity, and availability of data and cloud workloads.

| Capability | Description |
|---|---|
| Security Governance | Security policies, standards, and procedures |
| Security Assurance | Compliance frameworks (SOC2, PCI-DSS, HIPAA) |
| Identity & Access Management | Federation, SSO, least-privilege IAM |
| Threat Detection | GuardDuty, Security Hub, Detective |
| Vulnerability Management | Inspector, patch management |
| Infrastructure Protection | WAF, Shield, security groups, NACLs |
| Data Protection | KMS, CloudHSM, encryption at rest/transit |
| Application Security | Code analysis, WAF, API security |
| Incident Response | Automated response playbooks |

### 1.6 Operations Perspective

**Owner:** IT Operations Managers, SREs, IT Service Managers

**Purpose:** Ensure cloud services are delivered at a level that meets business needs.

| Capability | Description |
|---|---|
| Observability | CloudWatch, X-Ray, Managed Grafana |
| Event Management | EventBridge, SNS, PagerDuty integration |
| Incident & Problem Management | Systems Manager OpsCenter, Incident Manager |
| Change & Release Management | Systems Manager Change Manager |
| Performance & Capacity Management | Auto Scaling, Compute Optimizer |
| Configuration Management | Config, Systems Manager State Manager |
| Patch Management | Systems Manager Patch Manager |
| Availability & Continuity | DR strategies, backup automation |
| Application Management | Proton, Service Catalog |

### CAF Perspective Summary Table

```
┌──────────────────────────────────────────────────────────────┐
│                    AWS Cloud Adoption Framework                │
├──────────────┬──────────────┬──────────────┬─────────────────┤
│   BUSINESS   │    PEOPLE    │  GOVERNANCE  │    PLATFORM     │
│ (Why migrate)│ (Who changes)│ (How govern) │ (What to build) │
├──────────────┼──────────────┼──────────────┼─────────────────┤
│   SECURITY   │  OPERATIONS  │              │                 │
│ (How secure) │ (How operate)│              │                 │
└──────────────┴──────────────┴──────────────┴─────────────────┘

Business Capabilities:  Strategy, Portfolio, Innovation, Product
People Capabilities:    Culture, Leadership, Fluency, Change
Governance:             Programs, Benefits, Risk, FinOps, Data
Platform:               Architecture, Engineering, CI/CD, Data
Security:               IAM, Threat Detection, Data Protection
Operations:             Observability, Incident, Change, Patch
```

> **Exam Tip:** The exam tests whether you know which perspective addresses which concern. A question about "skills gap assessment" is People. "Compliance requirements during migration" is Security or Governance. "Cost tracking" is Governance (Cloud Financial Management).

---

## 2. Migration Readiness Assessment

### 2.1 What Is MRA?

The **Migration Readiness Assessment (MRA)** evaluates an organization's readiness to migrate to AWS across the six CAF perspectives. It identifies gaps and produces an actionable migration readiness plan.

### 2.2 MRA Process

```
┌─────────────┐    ┌──────────────┐    ┌───────────────┐    ┌─────────────┐
│  Discovery   │───▶│  Assessment  │───▶│ Gap Analysis  │───▶│  Readiness  │
│  Workshops   │    │  Scoring     │    │               │    │    Plan     │
└─────────────┘    └──────────────┘    └───────────────┘    └─────────────┘
```

**Step 1 — Discovery Workshops:**
- Stakeholder interviews across all six CAF perspectives
- Assess current IT landscape, applications, infrastructure
- Identify business drivers and constraints

**Step 2 — Assessment Scoring:**
- Each CAF perspective scored 1-5 (Initial → Optimized)
- Score across all capabilities within each perspective

| Score | Level | Description |
|---|---|---|
| 1 | Initial | Ad-hoc processes, no cloud awareness |
| 2 | Foundational | Basic cloud understanding, pilot underway |
| 3 | Intermediate | Defined processes, multiple workloads in cloud |
| 4 | Advanced | Automated, optimized cloud operations |
| 5 | Optimized | Continuous improvement, cloud-native |

**Step 3 — Gap Analysis:**
- Identify capabilities scoring below 3
- Prioritize gaps by business impact
- Map gaps to remediation activities

**Step 4 — Readiness Plan:**
- Specific actions to close each gap
- Timeline and ownership assignments
- Dependencies and risk mitigation

### 2.3 MRA Output Example

```
Perspective       Current  Target  Gap  Priority
─────────────────────────────────────────────────
Business            3        4      1    Medium
People              2        4      2    HIGH
Governance          2        4      2    HIGH
Platform            3        4      1    Medium
Security            2        5      3    CRITICAL
Operations          2        4      2    HIGH
```

**Key Gaps Identified:**
1. **Security** — No centralized identity federation, no encryption standards
2. **People** — Only 3 of 50 engineers have AWS certifications
3. **Governance** — No cloud financial management process
4. **Operations** — No automated monitoring or incident management

> **Exam Tip:** MRA questions often ask about "readiness" or "before starting migration." The answer usually involves assessing across all CAF perspectives and creating a readiness plan.

---

## 3. The 7 Rs of Migration

### 3.1 Overview

```
┌──────────────────────────────────────────────────────────────────────┐
│                        7 Rs of Migration                              │
├───────────┬───────────┬──────────┬───────────┬────────────┬──────────┤
│  RETIRE   │  RETAIN   │ REHOST   │ RELOCATE  │REPURCHASE  │REPLATFORM│
│ (Remove)  │  (Keep)   │(Lift &   │(Hypervisor│(Drop &     │(Lift,    │
│           │           │ Shift)   │  Move)    │ Shop)      │ Tinker & │
│           │           │          │           │            │ Shift)   │
├───────────┴───────────┴──────────┴───────────┴────────────┴──────────┤
│                        REFACTOR / RE-ARCHITECT                        │
│                    (Rebuild with cloud-native)                        │
└──────────────────────────────────────────────────────────────────────┘
```

### 3.2 Retire (Decommission)

**What:** Identify and turn off applications that are no longer needed.

**When to Use:**
- Application has no active users
- Functionality duplicated by another system
- Application end-of-life already planned
- Cost of migration exceeds business value

**Real-World Example:**
- A company discovers 30% of its 500 applications have fewer than 10 users
- Legacy reporting tool replaced by a modern BI solution 2 years ago but servers still running
- Old dev/test environments from completed projects

**Impact:**
- Typical enterprises retire 10-20% of their portfolio
- Immediate cost savings (licenses, hardware, support)
- Reduces migration scope and complexity

> **Exam Tip:** "Which applications should NOT be migrated?" → Retire candidates.

### 3.3 Retain (Revisit / Do Nothing)

**What:** Keep applications in their current environment (for now). Plan to revisit later.

**When to Use:**
- Recently purchased or upgraded hardware (remaining depreciation)
- Compliance/regulatory restrictions on data location
- Application requires OS or hardware not available in cloud
- Application has unresolvable dependencies on-premises
- High risk, low business value → not worth migrating now
- Application near end-of-life (12-18 months)

**Real-World Example:**
- Mainframe application with COBOL code — no team expertise to refactor, planned decommission in 18 months
- Medical imaging system requiring specialized GPU hardware with vendor-locked drivers
- Application with 2 years remaining on a hardware lease

### 3.4 Rehost (Lift and Shift)

**What:** Move the application as-is to AWS with no code changes. Same OS, same app, different infrastructure.

**When to Use:**
- Large-scale migrations needing speed (data center exit)
- Application has no cloud-native optimization opportunity in short term
- Quick wins to build momentum
- Application will be retired in 1-2 years but data center closes sooner
- Compliance requires rapid data center exit

**How It Works:**
```
On-Premises                         AWS
┌────────────┐                    ┌────────────┐
│  App Server │  ──── MGN ────▶   │  EC2        │
│  (Physical  │  (Continuous      │  Instance   │
│   or VM)    │   Replication)    │  (Same OS,  │
│             │                   │   Same App) │
└────────────┘                    └────────────┘
```

**Tools:** AWS Application Migration Service (MGN), VM Import/Export

**Benefits:**
- Fastest migration strategy
- Minimal risk (no code changes)
- Automated with MGN (continuous block-level replication)
- Can optimize later (right-sizing, reserved instances)

**Limitations:**
- Doesn't leverage cloud-native capabilities
- May carry technical debt
- May be over-provisioned

**Real-World Example:**
- Company migrating 5,000 servers to AWS in 18 months for data center lease expiry
- Each server rehosted using MGN with right-sizing during cutover
- Post-migration optimization planned in waves

### 3.5 Relocate (Hypervisor-Level Lift and Shift)

**What:** Move infrastructure to cloud at the hypervisor level without purchasing new hardware, changing applications, or modifying operations.

**When to Use:**
- VMware environment → VMware Cloud on AWS
- Need to quickly vacate a data center
- Want to maintain existing VMware operational model
- Large VMware estate with existing tooling (vCenter, vSAN, NSX)

**How It Works:**
```
On-Premises VMware              VMware Cloud on AWS
┌────────────────┐              ┌────────────────┐
│  vCenter       │              │  vCenter       │
│  ┌──────────┐  │   vMotion    │  ┌──────────┐  │
│  │    VM    │  │ ──────────▶  │  │    VM    │  │
│  └──────────┘  │              │  └──────────┘  │
│  ESXi hosts    │              │  ESXi on AWS   │
│  vSAN          │              │  bare metal    │
└────────────────┘              └────────────────┘
```

**Real-World Example:**
- Financial services firm with 2,000 VMware VMs
- Existing VMware Enterprise License Agreement
- Uses vMotion to live-migrate VMs to VMware Cloud on AWS
- Zero downtime, no application changes

### 3.6 Repurchase (Drop and Shop)

**What:** Replace existing application with a different product, typically a SaaS solution.

**When to Use:**
- Current application is heavily customized COTS (commercial off-the-shelf)
- SaaS alternative provides better functionality
- Licensing costs make cloud hosting expensive
- Application maintenance is unsustainable

**Examples:**

| Current System | Repurchase To |
|---|---|
| On-premises CRM (Siebel) | Salesforce |
| Self-hosted email (Exchange) | Microsoft 365 / Amazon WorkMail |
| On-premises HR system | Workday |
| Self-hosted CMS | WordPress SaaS / Contentful |
| On-premises data warehouse | Amazon Redshift Serverless |
| Custom ticketing system | ServiceNow / Jira Service Management |

**Considerations:**
- Data migration from old system to new SaaS
- User retraining
- Integration points with other systems
- Vendor lock-in assessment
- Total cost of ownership (TCO) comparison

### 3.7 Replatform (Lift, Tinker, and Shift)

**What:** Make targeted optimizations during migration without changing the core architecture. Move to managed services where possible.

**When to Use:**
- Want some cloud benefits without full re-architecture
- Database can move to RDS/Aurora with minimal changes
- Application can use Elastic Beanstalk instead of manual EC2 management
- Want to reduce operational overhead without code rewrites

**Examples:**

| Before | After (Replatformed) |
|---|---|
| Self-managed MySQL on VM | Amazon RDS MySQL or Aurora MySQL |
| Self-managed Redis | Amazon ElastiCache for Redis |
| Apache on VMs with manual scaling | Elastic Beanstalk |
| Self-managed Kafka | Amazon MSK |
| Self-managed Elasticsearch | Amazon OpenSearch Service |
| On-premises file server | Amazon EFS |
| IIS on Windows with SQL Server | Elastic Beanstalk + RDS SQL Server |
| Self-managed RabbitMQ | Amazon MQ |

**Real-World Example:**
- E-commerce application with self-managed MySQL on bare metal
- During migration: move MySQL to Amazon Aurora MySQL
- Benefit: Automated backups, Multi-AZ, read replicas, auto-scaling storage
- Application connection string change only — no code rewrite

### 3.8 Refactor / Re-Architect

**What:** Reimagine how the application is architected and developed using cloud-native features. Typically the most expensive and time-consuming option but provides the greatest long-term benefits.

**When to Use:**
- Strong business need for new features/scale that the current architecture can't provide
- Application needs to become multi-tenant
- Need extreme scalability (millions of users)
- Want to move to microservices, serverless, or event-driven
- Current architecture has significant technical debt
- Competitive pressure requires rapid innovation

**Examples:**

| Before | After (Refactored) |
|---|---|
| Monolithic Java app on VMs | Microservices on ECS/EKS + API Gateway |
| Batch processing on VMs | Lambda + Step Functions + EventBridge |
| Traditional web app | Serverless (API Gateway + Lambda + DynamoDB) |
| On-premises data warehouse | S3 data lake + Athena + Glue |
| File-based integrations | Event-driven with SNS/SQS/EventBridge |
| Session-based stateful app | Stateless containers + ElastiCache |

**Real-World Example:**
- Monolithic e-commerce platform (1M lines of Java)
- Strangler fig pattern: Gradually decompose into microservices
  1. Extract product catalog → ECS service + DynamoDB
  2. Extract search → OpenSearch Service
  3. Extract checkout → Lambda + Step Functions
  4. Extract notifications → SNS + SES + Lambda
  5. Legacy monolith shrinks over 18 months

---

## 4. Decision Framework — When to Use Each R

### 4.1 Decision Tree

```
                        ┌──────────────────┐
                        │ Is the application│
                        │ still needed?     │
                        └────────┬─────────┘
                           No ───┤──── Yes
                                 │        │
                          ┌──────▼──┐  ┌──▼─────────────────┐
                          │ RETIRE  │  │ Can it stay         │
                          └─────────┘  │ on-premises?        │
                                       └──────┬──────────────┘
                                    Yes ──────┤────── No
                                              │         │
                                       ┌──────▼──┐  ┌──▼─────────────────┐
                                       │ RETAIN  │  │ Is there a SaaS    │
                                       └─────────┘  │ replacement?       │
                                                     └──────┬─────────────┘
                                                  Yes ──────┤────── No
                                                            │         │
                                                     ┌──────▼────┐ ┌──▼────────────┐
                                                     │REPURCHASE │ │ VMware env?   │
                                                     └───────────┘ └──────┬────────┘
                                                                Yes ─────┤──── No
                                                                         │       │
                                                                  ┌──────▼───┐ ┌─▼──────────────┐
                                                                  │ RELOCATE │ │ Need cloud-     │
                                                                  └──────────┘ │ native benefits?│
                                                                               └──────┬─────────┘
                                                                         Yes ─────────┤───── No
                                                                                      │        │
                                                                  ┌───────────────┐ ┌─▼──────────────────┐
                                                                  │ Can achieve    │ │ Can use managed    │
                                                                  │ with minor     │ │ services with      │
                                                                  │ changes?       │ │ no code changes?   │
                                                                  └───────┬───────┘ └──────┬─────────────┘
                                                                  Yes ────┤── No    Yes ───┤── No
                                                                          │    │           │      │
                                                                   ┌──────▼─┐ ┌▼────────┐ ┌▼──────▼──┐
                                                                   │REPLATFM│ │REFACTOR │ │ REHOST   │
                                                                   └────────┘ └─────────┘ └──────────┘
```

### 4.2 Strategy Selection Matrix

| Factor | Retire | Retain | Rehost | Relocate | Repurchase | Replatform | Refactor |
|---|---|---|---|---|---|---|---|
| **Speed** | Instant | N/A | Fast | Fast | Medium | Medium | Slow |
| **Cost** | Savings | None | Low | Medium | Medium-High | Medium | High |
| **Risk** | Low | Low | Low | Low | Medium | Medium | High |
| **Cloud Benefits** | N/A | None | Minimal | Minimal | High (SaaS) | Medium | Maximum |
| **Code Changes** | None | None | None | None | N/A | Minimal | Significant |
| **Team Skill Needed** | Low | Low | Low-Medium | Medium | Low | Medium | High |
| **Downtime** | N/A | N/A | Minutes | Zero* | Hours-Days | Hours | Weeks |

*With VMware vMotion

### 4.3 Typical Portfolio Distribution

For a typical enterprise with 500 applications:

```
┌──────────────────────────────────────────────────────┐
│ Retire:     10-20%  ████████░░░░░░░░░░░░░░░░░░░░░░░ │
│ Retain:     10-15%  ██████░░░░░░░░░░░░░░░░░░░░░░░░░ │
│ Rehost:     25-35%  ████████████████░░░░░░░░░░░░░░░░ │
│ Relocate:    5-10%  ███░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│ Repurchase:  5-10%  ███░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│ Replatform: 15-25%  ██████████░░░░░░░░░░░░░░░░░░░░░ │
│ Refactor:    5-15%  ██████░░░░░░░░░░░░░░░░░░░░░░░░░ │
└──────────────────────────────────────────────────────┘
```

> **Exam Tip:** In large-scale migrations, the majority (60%+) of workloads are rehosted or replatformed for speed. Refactoring is reserved for the highest-value applications.

---

## 5. Migration Phases

AWS defines three major migration phases: **Assess**, **Mobilize**, and **Migrate & Modernize**.

### 5.1 Assess Phase

**Duration:** 2-4 weeks typically

**Purpose:** Build a business case, identify readiness gaps, develop migration strategy.

**Activities:**
1. **Migration Readiness Assessment (MRA)**
   - Evaluate across six CAF perspectives
   - Identify gaps and remediation actions
   
2. **Portfolio Discovery**
   - Use AWS Application Discovery Service
   - Agent-based or agentless discovery
   - Collect server configurations, utilization, network dependencies
   
3. **Business Case Development**
   - Current on-premises TCO
   - Projected AWS costs (using AWS Pricing Calculator)
   - Migration costs (tools, people, time)
   - Business value (agility, innovation, reduced risk)
   
4. **Directional Business Case Example:**
   ```
   Category                      On-Prem (5yr)    AWS (5yr)
   ─────────────────────────────────────────────────────────
   Compute                       $5,000,000       $2,800,000
   Storage                       $1,200,000       $600,000
   Network                       $800,000         $400,000
   Facilities                    $1,500,000       $0
   Staff (Operations)            $3,000,000       $1,500,000
   Licenses                      $2,000,000       $1,200,000
   Migration Cost (one-time)     N/A              $800,000
   ─────────────────────────────────────────────────────────
   Total                         $13,500,000      $7,300,000
   Savings                                        $6,200,000 (46%)
   ```

**Tools Used:**
- AWS Migration Hub
- AWS Application Discovery Service
- Migration Evaluator (formerly TSO Logic)

### 5.2 Mobilize Phase

**Duration:** 2-6 months

**Purpose:** Build the operational foundation — landing zone, cloud team, tools, processes.

**Activities:**

1. **Landing Zone Setup**
   ```
   AWS Organizations
   ├── Management Account
   │   ├── AWS Control Tower
   │   ├── AWS SSO / IAM Identity Center
   │   └── Consolidated Billing
   ├── Security OU
   │   ├── Log Archive Account (CloudTrail, Config, VPC Flow Logs)
   │   └── Audit Account (Security Hub, GuardDuty delegated admin)
   ├── Infrastructure OU
   │   ├── Network Account (Transit Gateway, Direct Connect, DNS)
   │   └── Shared Services Account (AD, CI/CD, container registry)
   ├── Sandbox OU
   │   └── Developer Sandbox Accounts
   ├── Workloads OU
   │   ├── Dev Account
   │   ├── Staging Account
   │   └── Production Account
   └── Policy Staging OU
       └── SCP Testing Account
   ```

2. **Operating Model Design**
   - CCoE formation and training
   - Runbook creation for cloud operations
   - Incident management process
   - Change management process

3. **Migration Tooling Setup**
   - AWS Migration Hub configured
   - MGN replication agents tested
   - DMS replication instances provisioned
   - CI/CD pipelines established

4. **Security & Compliance**
   - IAM policies and roles defined
   - SCPs applied
   - Encryption standards established
   - Compliance controls mapped (Config rules, Security Hub standards)

5. **Pilot Migrations**
   - Migrate 3-5 representative applications
   - Validate tools, processes, and runbooks
   - Measure performance and identify issues
   - Refine migration factory processes

### 5.3 Migrate & Modernize Phase

**Duration:** Varies (12-36 months for large enterprises)

**Purpose:** Execute the migration at scale and modernize workloads.

**Activities:**

1. **Migration Factory Setup**
   ```
   ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
   │   Discovery   │───▶│    Design     │───▶│   Build &    │
   │   & Planning  │    │ & Validation  │    │  Migrate     │
   └──────────────┘    └──────────────┘    └──────────────┘
          │                    │                    │
          ▼                    ▼                    ▼
   ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
   │   Cutover     │◀──│   Testing     │◀──│  Integrate   │
   │   & Go-Live   │    │              │    │              │
   └──────────────┘    └──────────────┘    └──────────────┘
   ```

2. **Wave Execution** (see Section 7)
3. **Post-Migration Optimization**
   - Right-sizing
   - Reserved Instances / Savings Plans
   - Storage tiering
   - Architecture optimization

---

## 6. Portfolio Assessment and Prioritization

### 6.1 Application Discovery

**Data to Collect:**

| Category | Data Points |
|---|---|
| **Server Inventory** | Hostname, OS, CPU, RAM, disk, IP |
| **Utilization** | CPU avg/peak, memory avg/peak, disk I/O, network I/O |
| **Dependencies** | Inbound/outbound connections, ports, protocols |
| **Application** | App name, version, language, framework |
| **Business** | Owner, criticality (1-5), users, revenue impact |
| **Licensing** | Vendor, license model, BYOL possibility |
| **Compliance** | Data classification, regulatory requirements |

### 6.2 Prioritization Framework

**Criteria for Prioritization (weighted scoring):**

| Criterion | Weight | Score 1-5 |
|---|---|---|
| Business Value | 25% | 1=low → 5=critical |
| Migration Complexity | 20% | 1=complex → 5=simple |
| Technical Risk | 20% | 1=high risk → 5=low risk |
| Dependencies | 15% | 1=many → 5=standalone |
| Compliance Requirements | 10% | 1=heavy → 5=none |
| Business Urgency | 10% | 1=low → 5=urgent |

**Prioritization Matrix:**

```
                    High Business Value
                          │
           ┌──────────────┼──────────────┐
           │   QUICK WINS │  STRATEGIC   │
           │  (Wave 1-2)  │  (Wave 3-5)  │
Low  ──────┼──────────────┼──────────────┼────── High
Complexity │   RETIRE OR  │  LONG-TERM   │  Complexity
           │   RETAIN     │  MODERNIZE   │
           │  (Evaluate)  │  (Wave 5+)   │
           └──────────────┼──────────────┘
                          │
                    Low Business Value
```

### 6.3 Disposition Categories

After assessment, applications fall into disposition groups:

1. **Easy Wins:** Low complexity, low dependency, good for early waves
2. **Core Business:** High value, may need replatform/refactor
3. **Complex Legacy:** High dependency, may need retain initially
4. **Retire Candidates:** No business value, decommission

> **Exam Tip:** Questions asking "which application to migrate first" → Choose the one with highest business value and lowest complexity (easy win / quick win).

---

## 7. Wave Planning

### 7.1 What Is Wave Planning?

Wave planning groups applications into ordered migration batches (waves), considering dependencies, risk, and resource constraints.

### 7.2 Wave Design Principles

1. **Start small:** Wave 1 = 3-5 low-risk applications
2. **Group dependencies:** Apps that communicate frequently go together
3. **Maintain business operations:** Don't migrate interdependent apps in different waves without a connectivity plan
4. **Increase velocity:** Each wave should be larger and faster
5. **Include buffer time:** Plan for rollbacks and issues

### 7.3 Example Wave Plan

```
Wave 0 (Pilot):        2 weeks    |  3 applications
├── Static website (S3 + CloudFront)
├── Internal wiki (rehost)
└── Dev environment (rehost)

Wave 1 (Foundation):   3 weeks    |  8 applications
├── Active Directory → AWS Managed AD
├── DNS → Route 53
├── Monitoring → CloudWatch
├── Shared databases (replatform to RDS)
└── CI/CD pipelines

Wave 2 (Quick Wins):   4 weeks    | 15 applications
├── Stateless web applications (rehost)
├── Batch processing jobs (rehost)
└── Reporting servers (replatform)

Wave 3 (Core Business): 6 weeks   | 25 applications
├── E-commerce platform (replatform)
├── Customer portal (replatform)
├── API gateway services (replatform)
└── Associated databases

Wave 4 (Complex):      8 weeks    | 20 applications
├── ERP system (rehost + plan refactor)
├── Legacy billing (rehost)
├── Mainframe integration (hybrid)
└── High-security financial apps

Wave 5 (Optimization): Ongoing    | All applications
├── Right-sizing
├── Reserved capacity
├── Refactoring high-value apps
└── Decommission on-premises
```

### 7.4 Wave Execution Timeline

```
Week:  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20
       ├──┤
       Wave 0 (Pilot)
          ├────┤
          Wave 1 (Foundation)
                ├──────┤
                Wave 2 (Quick Wins)
                      ├────────────┤
                      Wave 3 (Core)
                                   ├──────────────┤
                                   Wave 4 (Complex)
                                                   ├──────────────
                                                   Wave 5 (Optimize)
```

### 7.5 Dependencies Management

```
Application A ──depends on──▶ Database X
Application B ──depends on──▶ Database X
Application C ──depends on──▶ Application A

Migration Order:
1. Database X (migrate first, set up connectivity)
2. Application A (depends on Database X)
3. Application B (depends on Database X, parallel with A)
4. Application C (depends on Application A, after A is validated)
```

> **Exam Tip:** When dependencies exist between on-premises and cloud during migration, ensure network connectivity (Direct Connect, VPN) and consider latency impact. Applications with tight coupling should be migrated together.

---

## 8. Large-Scale Migration Patterns

### 8.1 What Constitutes Large-Scale?

- 1,000+ servers
- Multiple data centers
- Multiple applications with complex dependencies
- Tight deadline (data center lease expiry)

### 8.2 Migration Factory Model

A **migration factory** is a cross-functional team and process designed to migrate workloads at scale using standardized, repeatable processes.

```
┌─────────────────────────────────────────────────────────────┐
│                    MIGRATION FACTORY                         │
├─────────────┬──────────────┬──────────────┬─────────────────┤
│  DISCOVER   │    DESIGN    │   MIGRATE    │    OPERATE      │
│             │              │              │                  │
│ • App disc  │ • Target     │ • Rehost     │ • Monitoring     │
│ • Dependency│   architecture│ • Replatform │ • Optimization   │
│   mapping   │ • Sizing     │ • Cutover    │ • Incident mgmt  │
│ • 7R assign │ • Security   │ • Validation │ • Cost mgmt      │
│ • Wave plan │ • Network    │ • DNS switch │ • Compliance      │
└─────────────┴──────────────┴──────────────┴─────────────────┘
```

**Scaling the Factory:**

| Migration Size | Team Size | Velocity | Duration |
|---|---|---|---|
| 100 servers | 5-8 people | 20-30/month | 3-5 months |
| 1,000 servers | 15-25 people | 100-200/month | 6-12 months |
| 5,000 servers | 40-60 people | 300-500/month | 12-18 months |
| 10,000+ servers | 80-120 people | 500-1000/month | 18-36 months |

### 8.3 Automation at Scale

**Key Automation Points:**
1. **Discovery automation:** Application Discovery Service agents on all servers
2. **Replication automation:** MGN with auto-launch templates
3. **Testing automation:** Automated smoke tests post-migration
4. **Cutover automation:** Scripted DNS changes, load balancer updates
5. **Validation automation:** Automated connectivity and functionality checks

### 8.4 Key Success Factors

1. **Executive sponsorship** — Strong C-level champion
2. **Dedicated migration team** — Full-time, not part-time
3. **Migration factory model** — Standardized, repeatable processes
4. **Automation** — Minimize manual steps
5. **Wave-based approach** — Start small, increase velocity
6. **Clear communication** — Regular stakeholder updates
7. **Rollback planning** — Every migration has a rollback plan
8. **Network readiness** — Direct Connect with sufficient bandwidth

> **Exam Tip:** Large-scale migration questions focus on velocity, automation, and the migration factory model. The key enabler is always automation and repeatable processes.

---

## 9. Migration Project Planning and Governance

### 9.1 Governance Structure

```
┌─────────────────────────────────────────┐
│        Steering Committee                │
│  (C-suite, monthly meetings)             │
├─────────────────────────────────────────┤
│        Migration Program Manager         │
│  (Overall accountability)                │
├──────────┬──────────┬───────────────────┤
│  Cloud   │ Security │ Application       │
│  Platform│ Team     │ Teams (per wave)  │
│  Team    │          │                   │
├──────────┼──────────┼───────────────────┤
│  Network │  FinOps  │ Operations        │
│  Team    │  Team    │ Team              │
└──────────┴──────────┴───────────────────┘
```

### 9.2 RACI Matrix

| Activity | Program Mgr | Cloud Arch | App Team | Security | Operations |
|---|---|---|---|---|---|
| Wave Planning | A | R | C | C | C |
| Landing Zone | C | A/R | I | R | C |
| App Assessment | C | R | A | C | C |
| Migration Execution | A | C | R | C | C |
| Security Review | C | C | C | A/R | C |
| Cutover Decision | A | R | R | R | R |
| Post-Migration | I | C | R | C | A |

*R=Responsible, A=Accountable, C=Consulted, I=Informed*

### 9.3 Risk Management

| Risk | Probability | Impact | Mitigation |
|---|---|---|---|
| Data loss during migration | Low | Critical | Continuous replication, validation scripts |
| Extended downtime | Medium | High | Rehearsals, rollback plan, cutover window |
| Performance degradation | Medium | High | Right-sizing, load testing, monitoring |
| Dependency not identified | High | Medium | Thorough discovery, dependency mapping |
| Skills gap | High | Medium | Training, AWS partner support |
| Cost overrun | Medium | Medium | FinOps, regular cost reviews |
| Compliance violation | Low | Critical | Security review gates, automated compliance |

### 9.4 Migration Metrics (KPIs)

| Metric | Target | Measurement |
|---|---|---|
| Migration Velocity | 50 servers/week | Migration Hub tracking |
| Success Rate | >98% | Successful cutovers / Total cutovers |
| Rollback Rate | <5% | Rollbacks / Total cutovers |
| Mean Cutover Time | <4 hours | Time from cutover start to validation |
| Post-Migration Issues | <3 per app | ServiceNow tickets within 7 days |
| Cost vs Budget | ±10% | Actual vs planned AWS costs |

---

## 10. Exam Scenarios

### Scenario 1: Data Center Exit

**Question:** A company must vacate its data center in 12 months. It has 3,000 servers running a mix of Windows and Linux workloads. Most applications are standard 3-tier web apps. The company has limited cloud experience. What migration strategy should they prioritize?

**Answer:** **Rehost (Lift and Shift)** using AWS Application Migration Service (MGN).

**Reasoning:**
- 12-month deadline requires speed → Rehost is fastest
- Limited cloud experience → Rehost has lowest risk
- Standard architectures → Good rehost candidates
- Can optimize (replatform/refactor) after migration
- MGN provides continuous replication with minimal downtime cutovers

---

### Scenario 2: Legacy Oracle Database

**Question:** A company runs a critical Oracle database (15TB) with Oracle-specific features (PL/SQL, materialized views, Oracle Text). The licensing cost is $2M/year and the contract expires in 6 months. They want to move to AWS and reduce costs. What strategy?

**Answer:** **Replatform to Amazon Aurora PostgreSQL** using AWS Schema Conversion Tool (SCT) + Database Migration Service (DMS).

**Reasoning:**
- Oracle licensing cost is the driver → Need to move away from Oracle
- 6-month timeline → Replatform is achievable
- SCT converts Oracle PL/SQL to PostgreSQL PL/pgSQL
- DMS handles data migration with CDC for minimal downtime
- Aurora PostgreSQL is compatible with most Oracle features
- Cost reduction: Aurora vs Oracle = ~80% savings

---

### Scenario 3: Which Application to Migrate First?

**Question:** An enterprise has the following applications. Which should be in Wave 1?

| App | Users | Complexity | Dependencies | Business Criticality |
|---|---|---|---|---|
| Internal wiki | 50 | Low | None | Low |
| E-commerce | 100K | High | 12 services | Critical |
| HR portal | 200 | Medium | AD, SMTP | Medium |
| Batch reports | 5 | Low | Database | Low |

**Answer:** **Internal wiki** and **Batch reports** — low complexity, few/no dependencies, low risk, good for building team confidence.

---

### Scenario 4: Modernization Candidate Selection

**Question:** Which migration strategy for an application experiencing scalability issues with 10x growth projected, currently a monolithic Java application?

**Answer:** **Refactor/Re-architect** to microservices on ECS/EKS or serverless.

**Reasoning:**
- 10x growth requires scalability → Cloud-native architecture
- Monolithic architecture is the bottleneck → Decompose to microservices
- Long-term strategic application → Worth the refactoring investment
- Use strangler fig pattern for gradual migration

---

### Scenario 5: VMware Environment

**Question:** A company has 1,500 VMs on VMware with significant investment in VMware tooling (vCenter, NSX, vSAN). They want to move to AWS quickly. What approach?

**Answer:** **Relocate** to VMware Cloud on AWS.

**Reasoning:**
- Existing VMware investment → Leverage VMware Cloud on AWS
- 1,500 VMs → vMotion enables zero-downtime migration
- Maintain existing operational model and tools
- No application changes required
- Can selectively modernize to native AWS services over time

---

### Scenario 6: SaaS Replacement

**Question:** A company hosts an on-premises email server (Exchange) with 50,000 mailboxes. The hardware is end-of-life and they don't want to manage email infrastructure. What strategy?

**Answer:** **Repurchase** — Move to Microsoft 365 or Amazon WorkMail.

**Reasoning:**
- Don't want to manage infrastructure → SaaS is ideal
- Email is commodity → No competitive advantage in self-hosting
- 50,000 mailboxes → SaaS scales easily
- Hardware end-of-life → Must act regardless
- Repurchase to SaaS eliminates operational burden

---

> **Key Exam Tips Summary:**
> 1. **Speed required?** → Rehost or Relocate
> 2. **Cost reduction on licensing?** → Replatform or Repurchase
> 3. **Scalability/innovation needed?** → Refactor
> 4. **VMware environment?** → Relocate to VMware Cloud on AWS
> 5. **No longer needed?** → Retire
> 6. **Can't move yet?** → Retain
> 7. **COTS with SaaS alternative?** → Repurchase
> 8. **Large-scale migration?** → Migration factory + Rehost majority
> 9. **Wave 1 candidates?** → Low complexity, low dependency, low risk
> 10. **Always start with** the Assess phase (MRA + portfolio discovery)
