# Domain 1 — Cloud Concepts (24%)

> **Domain weight:** 24% of the exam (roughly **12 of 50 scored questions**).
> **Task statements in CLF-C02:**
> 1.1  Define the benefits of the AWS Cloud.
> 1.2  Identify design principles of the AWS Cloud.
> 1.3  Understand the benefits of and strategies for migration to the AWS Cloud.
> 1.4  Understand concepts of cloud economics.

Domain 1 is about *vocabulary and value*, not services. Expect questions like
"Which benefit of the cloud is demonstrated by shutting down a test
environment overnight?" (Answer: *elasticity / cost optimization via
pay-as-you-go*.) An architect typically over-thinks these and mis-answers by
applying a too-technical mental model. Read this article once carefully and
then memorize the vocabulary tables at the end.

---

## 1. What "the cloud" actually means

NIST (SP 800-145) defines cloud computing as having **five essential
characteristics**:

1. **On-demand self-service** — a consumer provisions resources without human
   interaction with a provider.
2. **Broad network access** — resources available over the network via
   standard mechanisms (HTTPS APIs, SDK, console, CLI).
3. **Resource pooling** — the provider's resources are pooled to serve
   multiple consumers with multi-tenancy; the consumer generally doesn't
   know nor control the exact physical location.
4. **Rapid elasticity** — capabilities can be scaled out and in
   (often automatically) to match demand.
5. **Measured service** — usage is monitored and metered, enabling
   pay-as-you-go billing.

▶ **Exam gotcha:** NIST itself isn't tested by name, but every benefit on
the exam maps to one of these five characteristics. If a scenario says
"developers no longer wait weeks for procurement", that's **on-demand
self-service**. If a scenario says "the workload bursts to 10× normal size
on Black Friday", that's **elasticity**. If "only paying for what you use",
that's **measured service**.

### 1.1 Cloud service models

The classic IaaS / PaaS / SaaS pyramid is still tested:

| Model | Customer manages | AWS manages | Example AWS services |
|---|---|---|---|
| **IaaS** — Infrastructure as a Service | OS, runtime, app, data, patching | Virtualization, hardware, networking, facilities | EC2, EBS, VPC |
| **PaaS** — Platform as a Service | App and data only | Runtime, OS, middleware, patching, infra | Elastic Beanstalk, App Runner, Amplify Hosting, RDS (managed DB) |
| **SaaS** — Software as a Service | Data / config only | Everything else | Amazon Chime, Amazon WorkMail, Amazon Connect, AWS IQ marketplace apps |

🧭 **Architect's perspective:** AWS rarely markets its services with these
labels. The exam expects you to categorize **by responsibility boundary**, not
by marketing. "Fully managed" and "serverless" usually imply PaaS-ish or
higher.

### 1.2 Cloud deployment models

| Model | Definition | Example |
|---|---|---|
| **Cloud (public)** | Infrastructure owned and run by a CSP; consumed over the internet | All standard AWS Regions |
| **Hybrid** | Mix of on-premises and cloud, typically integrated via VPN / Direct Connect and services like Outposts, Storage Gateway, DMS | Running DB on-prem, app tier on AWS |
| **On-premises ("private cloud")** | Fully owned and operated by the organization; can still use cloud-native tooling (e.g., OpenStack, VMware) | Traditional data center, VMware Cloud on AWS, AWS Outposts when all-in on a DC |

▶ **Gotcha:** AWS Outposts is considered **hybrid**, not on-premises,
because the hardware is AWS-managed and integrated with AWS Regions.

---

## 2. The six benefits of the AWS Cloud (must memorize)

AWS's official "Six Advantages of Cloud Computing" is a top-tested list.
Memorize the names **and** the contrast phrases.

| # | Benefit | Contrast with on-premises |
|---|---|---|
| 1 | **Trade capital expense (CapEx) for variable expense (OpEx)** | Avoid large upfront server purchases; pay only for consumption. |
| 2 | **Benefit from massive economies of scale** | AWS's aggregate purchasing lowers per-unit costs which flow to you as lower prices. |
| 3 | **Stop guessing capacity** | Scale up and down on demand — no more over-provisioning "just in case" or under-provisioning and losing customers. |
| 4 | **Increase speed and agility** | Resources in minutes, not weeks. Experiment cheaply. |
| 5 | **Stop spending money running and maintaining data centers** | Focus engineering on customers, not on racking, stacking, cooling, HVAC, and security. |
| 6 | **Go global in minutes** | Deploy to multiple AWS Regions to serve customers worldwide with low latency. |

▶ **Gotcha — common phrasings:**
- "Replace variable operating costs with low variable costs" is WRONG
  (it's *replace capital with variable*).
- "Stop guessing capacity" is the **elasticity** benefit.
- "Go global in minutes" is the Region-level benefit, not CloudFront /
  edge; CloudFront is a service-level *implementation* of this benefit.

---

## 3. Cloud economics — CapEx vs OpEx, TCO, ROI

### 3.1 CapEx vs OpEx

- **CapEx (Capital Expenditure):** A large up-front purchase of assets (e.g.,
  buying a server). Depreciated over years. Requires forecasting.
- **OpEx (Operational Expenditure):** Ongoing, metered expense (e.g., paying
  monthly for EC2 + S3 usage). Scales with consumption.

The cloud converts CapEx to OpEx — this changes financial planning (no
multi-year capex requests) and risk (no stranded capacity).

### 3.2 Total Cost of Ownership (TCO)

On-prem TCO includes hardware, software licenses, data-center real estate,
power & cooling, networking, physical security, labor for racking/patching,
and the opportunity cost of **over-provisioning**. AWS TCO includes only the
metered usage, basic account administration, and whatever licensing you
bring.

AWS provides the **[AWS Pricing Calculator](https://calculator.aws)** (which
superseded the *Simple Monthly Calculator*) to model workload costs. It is
**not** a TCO calculator — for true TCO you combine it with your on-prem
numbers (the classic *AWS TCO Calculator* was retired; the Migration
Evaluator tool is now recommended for enterprise-scale TCO).

### 3.3 Elasticity vs scalability (both are tested)

- **Scalability** = ability to grow (or shrink) capacity to meet demand.
  *Vertical* (bigger instance) vs *horizontal* (more instances).
- **Elasticity** = scalability that happens **automatically** and quickly.

Most cloud benefits derive from *elastic* horizontal scaling: launch 10
EC2s at 8 AM, terminate them at 6 PM, pay for 10 instance-hours.

### 3.4 Other economic concepts

- **Reserve capacity** (Reserved Instances, Savings Plans) — commit to
  baseline usage for 1 or 3 years for up to ~72% savings.
- **Spot** — bid on spare capacity for up to 90% savings; workload must
  tolerate interruption.
- **Right-sizing** — continuously match instance size to actual utilization.
- **Economies of scale** — AWS passes bulk-buying and operational efficiency
  savings through in the form of ongoing price reductions
  (AWS has publicly cut prices 100+ times since launch).

---

## 4. The AWS Well-Architected Framework (WAF) — 6 pillars

The **AWS Well-Architected Framework** is AWS's opinionated collection of
best practices, expressed as **6 pillars** (originally 5; *Sustainability*
was added in December 2021).

| # | Pillar | One-line definition |
|---|---|---|
| 1 | **Operational Excellence** | Run and monitor systems to deliver business value and continuously improve processes and procedures. |
| 2 | **Security** | Protect information, systems, and assets while delivering business value through risk assessments and mitigation strategies. |
| 3 | **Reliability** | The ability of a workload to perform its intended function correctly and consistently, and recover quickly from failure. |
| 4 | **Performance Efficiency** | Use computing resources efficiently to meet requirements and maintain efficiency as demand changes and technologies evolve. |
| 5 | **Cost Optimization** | Avoid unnecessary costs; deliver value at the lowest price point. |
| 6 | **Sustainability** | Minimize environmental impact of running cloud workloads (carbon, water, energy, hardware). |

Mnemonic: **"OSRPCS"** — Oh, So Really Pretty Clean, Sustainably. Or *"OR'S
PC Sustainable"*.

### 4.1 Key design principles per pillar

**Operational Excellence**
- Perform operations as code.
- Make frequent, small, reversible changes.
- Refine operations procedures frequently.
- Anticipate failure.
- Learn from all operational failures.

**Security**
- Implement a strong identity foundation (least privilege, central identity).
- Enable traceability (logging + monitoring).
- Apply security at **all layers** (defense in depth).
- Automate security best practices.
- Protect data in transit and at rest.
- Keep people away from data (use automation).
- Prepare for security events (incident response plan, game days).

**Reliability**
- Automatically recover from failure.
- Test recovery procedures.
- Scale horizontally to increase aggregate workload availability.
- Stop guessing capacity (elasticity).
- Manage change through automation.

**Performance Efficiency**
- Democratize advanced technologies (consume as a service).
- Go global in minutes (multi-Region deployments).
- Use serverless architectures where possible.
- Experiment more often.
- Consider mechanical sympathy — pick the right service for the job.

**Cost Optimization**
- Implement cloud financial management (FinOps).
- Adopt a consumption model (pay for what you use).
- Measure overall efficiency (business outcome per dollar).
- Stop spending money on undifferentiated heavy lifting (use managed services).
- Analyze and attribute expenditure (tagging, cost allocation).

**Sustainability**
- Understand your impact.
- Establish sustainability goals.
- Maximize utilization (right-sizing, consolidation).
- Anticipate and adopt new, more efficient hardware and software offerings
  (e.g., Graviton).
- Use managed services that deliver efficiency at scale.
- Reduce the downstream impact of your cloud workloads.

▶ **Gotcha:** The CLF-C02 exam sometimes phrases these as *design principles*
(per pillar) distinct from the *pillars* themselves. If asked to match a
design principle to a pillar, the keywords above are your decoder ring.

### 4.2 WAF tooling

- **AWS Well-Architected Tool** — free console tool in which you document a
  workload and answer structured questions to identify high-risk issues.
- **AWS Well-Architected Lenses** — specialized views layered onto the
  general framework: Serverless, SaaS, Foundational Technical Review, Data
  Analytics, Machine Learning, IoT, Hybrid Networking, Games Industry,
  Healthcare, Financial Services, Streaming Media, Genomics, Sustainability,
  Generative AI.
- **AWS Well-Architected Reviews** — performed with an AWS Solutions
  Architect (free) or Partner.

---

## 5. AWS Cloud design principles (beyond WAF)

These appear in CLF-C02 as stand-alone testable items, although they overlap
with WAF's design principles.

1. **Design for failure** — "Everything fails, all the time." — Werner Vogels.
   Use redundancy, fault isolation (Availability Zones), health checks, auto
   healing, and graceful degradation.
2. **Loose coupling** — Decouple components using queues (SQS), topics (SNS),
   events (EventBridge), and well-defined APIs. Failures are contained.
3. **Scale horizontally** — Prefer many small instances over one huge one.
   Enables elasticity, HA, and cost optimization.
4. **Automate everything** — Infrastructure as Code (CloudFormation, CDK,
   Terraform), deployment pipelines (CodePipeline), remediation (Config +
   SSM Automation, Lambda).
5. **Treat servers as cattle, not pets** — Immutable infrastructure. Replace
   rather than repair. Enables blue/green and canary deployments.
6. **Measure everything** — Metrics, logs, traces (CloudWatch, X-Ray).
   Make decisions from data.
7. **Protect and encrypt data** — By default in transit (TLS) and at rest
   (KMS / AES-256). Rotate credentials.
8. **Go global** — Region selection by latency, data residency, features,
   price. Use CloudFront + Route 53 + Global Accelerator for global reach.

---

## 6. Elasticity, HA, DR, fault tolerance — the "ility" vocabulary

These terms are often confused. Memorize them.

| Term | Definition | AWS examples |
|---|---|---|
| **High Availability (HA)** | System continues to operate with minimal downtime during failures. Often defined in "nines" (99.99% = 52 min/year). | Multi-AZ RDS, ALB across AZs, S3 11×9's durability & 4×9 availability |
| **Fault Tolerance (FT)** | Zero-loss operation through failures; usually requires full redundancy. | Aurora (6 copies across 3 AZs), DynamoDB global tables |
| **Disaster Recovery (DR)** | Recovery from a Region-wide or larger event. Defined by RTO/RPO. | Multi-Region replication, Route 53 DNS failover, AWS Elastic Disaster Recovery |
| **Elasticity** | Automatic scaling up/down to match demand. | Auto Scaling Group, Lambda concurrency, DynamoDB On-Demand |
| **Scalability** | Capability to grow to handle more load (manual or automatic). | Adding more EC2 instances, read replicas |
| **Durability** | Probability that data is not lost over time. | S3 is "11 nines" (99.999999999%) of durability. |
| **Availability** | Probability a service responds successfully when called. | S3 Standard: 99.99% availability SLA. |
| **RTO** | Recovery Time Objective — how long can the system be down. | 4 hours, 1 hour, seconds |
| **RPO** | Recovery Point Objective — how much data you can lose (time). | 15 min, 5 min, zero |

▶ **Gotcha:** S3 durability ≠ availability. Durability is about **data loss**.
Availability is about **service responsiveness**. The exam frequently mixes
these up deliberately.

### DR strategies (increasing cost, decreasing RTO/RPO)

| Strategy | RTO / RPO | What runs in DR site |
|---|---|---|
| **Backup & Restore** | Hours | Only data backups; compute rebuilt from IaC on demand |
| **Pilot Light** | 10s of minutes | Core services (DB replicated, AMIs ready) but not user-facing tier |
| **Warm Standby** | Minutes | Scaled-down full stack, scale up on failover |
| **Multi-site active-active (hot)** | Seconds / zero | Full-scale stacks in multiple Regions, traffic actively split |

---

## 7. AWS global infrastructure

Memorize the numbers only as order-of-magnitude (AWS grows these every year).

- **Regions** — 30+ geographic areas worldwide. Each Region is fully
  isolated for fault containment and data-residency.
- **Availability Zones (AZs)** — Each Region has **≥ 3 AZs** (most have 3–6).
  An AZ is one or more discrete data centers with redundant power, network,
  and connectivity. AZs within a Region are physically separated but
  connected by low-latency fiber (sub-millisecond at p99 for most Regions).
- **Local Zones** — Extensions of a Region placed near large metros (LA,
  Miami, etc.) for single-digit-millisecond latency to end-users. Useful
  for media, gaming, live event processing.
- **Wavelength Zones** — AWS infrastructure embedded in telco 5G networks
  for ultra-low-latency mobile applications.
- **AWS Outposts** — Physical AWS racks shipped to your data center; managed
  by AWS and running a subset of AWS services on-prem.
- **Points of Presence (PoPs)** — **Edge Locations** (600+) + **Regional
  Edge Caches** (~13). Used by CloudFront, Route 53, Global Accelerator,
  WAF, Shield.

### 7.1 How to select a Region (4 classic factors)

1. **Compliance / data residency** — Does law require data to stay in
   country / region?
2. **Latency** — Choose the Region closest to your users.
3. **Service availability** — New services launch in us-east-1 first; not
   every Region has every service.
4. **Pricing** — Prices vary per Region (e.g., São Paulo is typically more
   expensive than N. Virginia).

🧭 **Architect's perspective:** In an exam scenario, if the company is in
Germany and has GDPR constraints, pick `eu-central-1` (Frankfurt) even if
Ireland is cheaper. If a hard data-sovereignty requirement exists, only
in-country Regions qualify.

### 7.2 "AWS GovCloud", "China Regions", and "Secret/Top Secret"

- **AWS GovCloud (US-East, US-West)** — Isolated Regions for US government
  and customers with sensitive data. ITAR/FedRAMP High compliant; accessed
  with a separate account and credentials.
- **AWS China (Beijing, Ningxia)** — Operated by Chinese partners (Sinnet,
  NWCD) due to Chinese law; separate account; not part of the global AWS
  partition.
- **AWS Secret / Top Secret Regions** — For US intelligence community.

▶ **Gotcha:** GovCloud, China, and Secret/Top Secret are **separate
partitions** — you need separate accounts, and global services like IAM
and S3 operate independently in each partition.

---

## 8. The 7 R's of cloud migration

CLF-C02 tests migration strategies. AWS's canonical list is **7 R's**
(originally 6 R's from Gartner's "5 R's"):

| # | Strategy | What it means |
|---|---|---|
| 1 | **Retire** | Decommission apps that are no longer useful. |
| 2 | **Retain (revisit)** | Keep on-prem for now — maybe due to licensing, latency, or non-cloud-ready tech. |
| 3 | **Rehost** ("lift and shift") | Move the app unchanged using tools like AWS Application Migration Service (MGN). Fastest migration, minimal optimization. |
| 4 | **Relocate** | Move VMware workloads to VMware Cloud on AWS with no changes. Faster than rehost but limited to VMware. |
| 5 | **Repurchase** ("drop and shop") | Replace with a SaaS equivalent (e.g., Siebel → Salesforce, on-prem Exchange → Microsoft 365). |
| 6 | **Replatform** ("lift, tinker, and shift") | Small cloud optimizations during migration (e.g., self-managed MySQL → RDS MySQL, or switch OS). |
| 7 | **Refactor / Re-architect** | Rewrite the app using cloud-native patterns (microservices, serverless). Highest cost & time; highest long-term benefit. |

▶ **Gotcha:** "Relocate" (VMware-specific) is sometimes omitted in older
study guides — CLF-C02 expects it.

### 8.1 AWS migration tools

| Tool | Purpose |
|---|---|
| **AWS Migration Hub** | Central console to track and coordinate migrations across multiple tools. |
| **AWS Application Migration Service (MGN)** | Block-level replication for rehost (replaces the older CloudEndure Migration and SMS). |
| **AWS Database Migration Service (DMS)** | Online DB migration with minimal downtime; supports homogeneous (Oracle→Oracle) and heterogeneous (Oracle→Aurora PostgreSQL). Used with **Schema Conversion Tool (SCT)** for heterogeneous schema conversion. |
| **AWS DataSync** | File-level data transfer (NFS, SMB, HDFS, object storage) to/from AWS storage services. |
| **AWS Transfer Family** | Fully managed SFTP / FTPS / FTP / AS2 gateways fronting S3/EFS. |
| **AWS Snowcone / Snowball Edge / Snowmobile** | Physical devices for offline, large-scale, or disconnected-environment data transfer. |
| **AWS Application Discovery Service** | Discovers on-prem servers, configs, performance; feeds Migration Hub. |
| **Migration Evaluator** (formerly TSO Logic) | Generates business-case / TCO reports for migration. |
| **AWS Mainframe Modernization** | Lift or refactor mainframe workloads. |
| **VM Import/Export** | Import/export VM images to/from AMIs. |

### 8.2 The **AWS Cloud Adoption Framework (CAF)**

AWS CAF organizes cloud-adoption guidance into **6 perspectives**, each with
*capabilities* that describe what to do.

| # | Perspective | Focus |
|---|---|---|
| 1 | **Business** | Ensure cloud investments accelerate business outcomes (value realization, business risk). |
| 2 | **People** | Culture, org design, training, hiring. |
| 3 | **Governance** | Program / portfolio / risk / cloud financial management, data curation. |
| 4 | **Platform** | Build, provision, operate an enterprise-grade cloud platform (IaC, CI/CD, observability). |
| 5 | **Security** | Identity, threat detection, vulnerability, incident response, application security, data protection. |
| 6 | **Operations** | Incident, problem, change, performance, availability, configuration. |

Mnemonic: **"B-PGPSO"** → "**B**e **P**repared, **G**overn **P**latform,
**S**ecurity, **O**perations." (or memorize as *Business, People, Governance,
Platform, Security, Operations*.)

---

## 9. Summary tables (the ones the exam loves)

### 9.1 Six Benefits
```
CapEx → OpEx • Economies of scale • Stop guessing capacity
Speed & agility • No DC spend • Go global in minutes
```

### 9.2 Well-Architected Pillars
```
Operational Excellence • Security • Reliability
Performance Efficiency • Cost Optimization • Sustainability
```

### 9.3 Cloud deployment models
```
Cloud (public) • Hybrid (incl. Outposts, Storage Gateway) • On-Prem
```

### 9.4 Five NIST characteristics
```
On-demand self-service • Broad network access • Resource pooling
Rapid elasticity • Measured service
```

### 9.5 Seven migration strategies
```
Retire • Retain • Rehost • Relocate • Repurchase • Replatform • Refactor
```

### 9.6 Six CAF perspectives
```
Business • People • Governance • Platform • Security • Operations
```

### 9.7 Global infrastructure hierarchy
```
Region  ─ contains 3+ ─▶  Availability Zones  ─ contains 1+ ─▶  Data Centers
        ─ served by ──▶  Edge Locations / Regional Edge Caches (for CDN)
                    ──▶  Local Zones (metro edge)
                    ──▶  Wavelength Zones (5G telco edge)
                    ──▶  Outposts (on-prem AWS hardware)
```

---

## 10. 30 rapid-fire check questions

Answer these out loud before moving to Domain 2.

1. Name the six benefits of the cloud.
2. Name the six pillars of WAF.
3. Name the five design principles for Operational Excellence.
4. Is Outposts hybrid or on-premises?
5. Which two AWS DR strategies are most cost-efficient and which two most
   available?
6. What's the difference between HA and FT?
7. What's the difference between durability and availability?
8. Order the 4 DR strategies by RTO: Pilot Light, Backup & Restore,
   Warm Standby, Multi-Site.
9. What does "Stop guessing capacity" correspond to in WAF?
10. Which AWS tool generates a migration business case?
11. Which AWS service provides block-level server replication for
    rehost migrations?
12. Which CAF perspective owns FinOps?
13. Is a Region composed of AZs or Edge Locations?
14. How many AZs does a "typical" AWS Region have at minimum?
15. What does RPO = 0 imply about your replication strategy?
16. Which strategy is "drop and shop"?
17. Which strategy includes switching from self-managed MySQL to RDS?
18. What is the difference between Region and Local Zone latency?
19. In CapEx → OpEx, which side is the cloud?
20. Give an example of "economies of scale" from an AWS customer POV.
21. What's the difference between scalability and elasticity?
22. Which Well-Architected pillar was added in 2021?
23. Name the 3 types of AWS Free Tier (tested in Domain 4, but good to know
    now): always free, 12-month free, trials.
24. What's the purpose of AWS Artifact? (Domain 2 — but know the name.)
25. If the scenario demands *zero* data loss during a Region outage, which
    DR strategy is appropriate?
26. Multi-AZ RDS is an example of HA or FT?
27. Why do new AWS services typically launch in us-east-1 first?
28. Name the WAF lens dedicated to serverless workloads.
29. What is the difference between AWS Migration Hub and AWS MGN?
30. What CAF perspective owns the operating model and training?

*Answers are embedded in the article. If you missed > 5, re-read the section
containing the question.*

---

Continue to **Domain 2 — Security and Compliance**.
