# AWS Solutions Architect Professional (SAP-C02) — 30-Day Study Plan

> **Goal:** Pass the SAP-C02 exam in 30 days with a score of 800+.
> **Prerequisites:** You should already hold the Solutions Architect Associate (SAA-C03) or have equivalent experience.
> **Daily commitment:** 4–6 hours on weekdays, 6–8 hours on weekends.

---

## Exam Blueprint Weightings

| Domain | Weight |
|--------|--------|
| 1 — Design Solutions for Organizational Complexity | 26% |
| 2 — Design for New Solutions | 29% |
| 3 — Continuous Improvement for Existing Solutions | 25% |
| 4 — Accelerate Workload Migration and Modernization | 20% |

---

## Recommended Resources

| Resource | Type |
|----------|------|
| AWS Official Exam Guide & Sample Questions | Free |
| Stephane Maarek — SAP-C02 (Udemy) | Video course |
| Adrian Cantrill — SA Pro course | Video course |
| Neal Davis — SA Pro Practice Exams | Practice tests |
| Tutorials Dojo — SAP-C02 Practice Exams | Practice tests |
| AWS Well-Architected Framework (whitepaper) | Whitepaper |
| AWS Disaster Recovery Workloads (whitepaper) | Whitepaper |
| AWS re:Invent YouTube talks on networking/migrations | Videos |
| AWS Documentation (service FAQs) | Reference |
| This study guide's cheat sheets (in `../cheat-sheets/`) | Reference |

---

## Weekly Overview

| Week | Theme | Focus |
|------|-------|-------|
| **Week 1** | Foundation & Identity | IAM deep dive, Organizations, Security services, Networking foundations |
| **Week 2** | Data, Databases & Storage | All storage services, all database services, data migration |
| **Week 3** | Compute, Application Integration & Migration | Compute options, messaging, serverless, migration strategies |
| **Week 4** | Review, Weak Areas & Exam Simulation | Full practice exams, targeted review, exam-day preparation |

---

## WEEK 1 — Foundation, Identity & Networking

### Day 1 (Monday) — Exam Orientation & IAM Deep Dive

| Time Block | Activity | Duration |
|------------|----------|----------|
| **Morning (9–12)** | Read SAP-C02 exam guide. Take the free AWS official sample questions (untimed). Identify knowledge gaps. | 3 h |
| **Afternoon (1–3:30)** | IAM policies: identity-based vs resource-based, policy evaluation logic, permission boundaries, session policies. Read `security-cheat-sheet.md` IAM section. | 2.5 h |
| **Evening (7–8:30)** | STS deep dive: AssumeRole, cross-account access patterns, confused deputy problem. Do 20 practice questions on IAM. | 1.5 h |

**Key articles:** AWS IAM Policy Evaluation Logic docs, AWS STS API Reference.

---

### Day 2 (Tuesday) — Organizations, SCPs & Multi-Account Strategy

| Time Block | Activity | Duration |
|------------|----------|----------|
| **Morning (9–11:30)** | AWS Organizations: OU hierarchy design, SCP deny-list vs allow-list strategy, SCP inheritance, tag policies, backup policies. | 2.5 h |
| **Afternoon (1–3:30)** | Control Tower: Landing Zone, guardrails (preventive/detective), Account Factory, customizations. AWS Config aggregator in multi-account. | 2.5 h |
| **Evening (7–8:30)** | Identity Center (SSO): permission sets, ABAC, integration with external IdPs. 20 practice questions on Organizations/multi-account. | 1.5 h |

**Key articles:** AWS Organizations SCP documentation, Control Tower best practices whitepaper.

---

### Day 3 (Wednesday) — VPC Networking Fundamentals

| Time Block | Activity | Duration |
|------------|----------|----------|
| **Morning (9–12)** | VPC design: CIDR planning, subnet strategies (public/private/isolated), route tables, Internet Gateway, NAT Gateway vs NAT Instance, Egress-Only IGW. Read `networking-cheat-sheet.md` VPC section. | 3 h |
| **Afternoon (1–3:30)** | Security Groups vs NACLs (stateful/stateless), VPC Flow Logs, VPC Endpoints (Gateway vs Interface), PrivateLink architecture. | 2.5 h |
| **Evening (7–8:30)** | IPv6 strategy, dual-stack VPCs, Egress-Only IGW for IPv6. 20 networking practice questions. | 1.5 h |

**Key articles:** AWS VPC documentation, VPC Endpoint docs, PrivateLink docs.

---

### Day 4 (Thursday) — Advanced Networking: Hybrid Connectivity

| Time Block | Activity | Duration |
|------------|----------|----------|
| **Morning (9–12)** | Direct Connect: dedicated vs hosted connections, Virtual Interfaces (private/public/transit), LAG groups, MACsec encryption, BGP communities, connection resiliency models. | 3 h |
| **Afternoon (1–3:30)** | Site-to-Site VPN: static vs dynamic (BGP), accelerated VPN, VPN over Direct Connect (public VIF), VPN as DX backup, redundancy patterns. | 2.5 h |
| **Evening (7–8:30)** | Transit Gateway: routing domains, route tables, multicast support, inter-region peering, ECMP over VPN. 20 practice questions on hybrid connectivity. | 1.5 h |

**Key articles:** Direct Connect resiliency recommendations, Transit Gateway docs, VPN CloudHub.

---

### Day 5 (Friday) — DNS, CDN & Edge

| Time Block | Activity | Duration |
|------------|----------|----------|
| **Morning (9–12)** | Route 53: routing policies (simple, weighted, latency, failover, geolocation, geoproximity, multivalue, IP-based), health checks, calculated health checks, DNSSEC, Route 53 Resolver (inbound/outbound endpoints, rules). | 3 h |
| **Afternoon (1–3:30)** | CloudFront: origins (S3, ALB, custom), behaviors, cache policies, origin request policies, Lambda@Edge vs CloudFront Functions, signed URLs/cookies, OAC/OAI, field-level encryption. | 2.5 h |
| **Evening (7–8:30)** | Global Accelerator vs CloudFront comparison. AWS Network Firewall, WAF, Shield, Shield Advanced. 20 practice questions on DNS/CDN. | 1.5 h |

**Key articles:** Route 53 routing policy docs, CloudFront developer guide, Global Accelerator docs.

---

### Day 6 (Saturday) — Security Services Deep Dive

| Time Block | Activity | Duration |
|------------|----------|----------|
| **Morning (9–12)** | KMS: symmetric vs asymmetric keys, key policies, grants, ViaService conditions, envelope encryption, multi-region keys, key rotation (automatic vs manual), imported key material, KMS request quotas. CloudHSM: use cases, HA architecture, custom key store integration. | 3 h |
| **Afternoon (1–4)** | Secrets Manager vs Parameter Store comparison. ACM: public vs private certs, DNS vs email validation, auto-renewal. Cognito: User Pools vs Identity Pools, federation (SAML 2.0, OIDC, social), custom auth flows, ALB integration. | 3 h |
| **Evening (5–7)** | GuardDuty, Inspector, Macie, Detective, Security Hub. AWS Config rules and auto-remediation with SSM. Read full `security-cheat-sheet.md`. 25 security practice questions. | 2 h |

**Key articles:** KMS developer guide, Cognito docs, GuardDuty docs.

---

### Day 7 (Sunday) — Week 1 Review & Checkpoint

| Time Block | Activity | Duration |
|------------|----------|----------|
| **Morning (9–12)** | Review all notes from Days 1–6. Re-read `networking-cheat-sheet.md` and `security-cheat-sheet.md`. Flash-card review of key concepts. | 3 h |
| **Afternoon (1–4)** | **Take a 75-question timed practice test** (Tutorials Dojo or Neal Davis — Set 1). Strict exam conditions: 180 minutes, no notes. | 3 h |
| **Evening (5–7:30)** | **Review every question** from the practice test — both correct and incorrect. Document weak areas in a "Weak Areas" notebook. Create action items for Week 2. | 2.5 h |

> **Week 1 Checkpoint Target:** Score ≥ 55% on first practice test. Identify top 3 weak domains.

**Week 1 Tips:**
- Don't rush through IAM — it's foundational for every other topic.
- Draw network diagrams by hand for each connectivity pattern.
- For every service, ask: "When would I use this INSTEAD of the alternative?"

---

## WEEK 2 — Storage, Databases & Data

### Day 8 (Monday) — S3 Deep Dive

| Time Block | Activity | Duration |
|------------|----------|----------|
| **Morning (9–12)** | S3 storage classes: Standard, IA, One Zone-IA, Intelligent-Tiering (archive tiers), Glacier Instant Retrieval, Glacier Flexible Retrieval, Glacier Deep Archive. Lifecycle policies. Read `storage-cheat-sheet.md` S3 section. | 3 h |
| **Afternoon (1–3:30)** | S3 advanced: versioning, replication (CRR/SRR, RTC, bi-directional), Object Lock (governance/compliance), access points, Multi-Region Access Points, S3 Select, Batch Operations. | 2.5 h |
| **Evening (7–8:30)** | S3 security: bucket policies, ACLs (legacy), block public access, encryption (SSE-S3, SSE-KMS, SSE-C, CSE), presigned URLs, VPC endpoints for S3. 20 S3 practice questions. | 1.5 h |

---

### Day 9 (Tuesday) — Block & File Storage

| Time Block | Activity | Duration |
|------------|----------|----------|
| **Morning (9–12)** | EBS volume types: gp3, gp2, io2, io2 Block Express, st1, sc1 — IOPS, throughput, max sizes. Snapshots, encryption, multi-attach, fast snapshot restore. Instance Store. | 3 h |
| **Afternoon (1–3:30)** | EFS: performance modes (General Purpose, Max I/O), throughput modes (Bursting, Provisioned, Elastic), storage classes (Standard, IA), lifecycle management, cross-region replication, access points, IAM-based mount. | 2.5 h |
| **Evening (7–8:30)** | FSx: Windows File Server (AD integration, DFS), Lustre (scratch vs persistent, S3 integration), NetApp ONTAP (multi-protocol, tiering), OpenZFS. 20 storage practice questions. | 1.5 h |

---

### Day 10 (Wednesday) — Data Transfer & Hybrid Storage

| Time Block | Activity | Duration |
|------------|----------|----------|
| **Morning (9–12)** | Storage Gateway: S3 File Gateway, FSx File Gateway, Volume Gateway (cached/stored mode), Tape Gateway. Architecture and use cases for each. | 3 h |
| **Afternoon (1–3:30)** | DataSync: architecture, agents, task scheduling, filtering, bandwidth throttling. Transfer Family (SFTP/FTPS/FTP/AS2). Snow Family: Snowcone, Snowball Edge (Compute/Storage Optimized), Snowmobile — capacity and decision criteria. | 2.5 h |
| **Evening (7–8:30)** | AWS Backup: vault, vault lock, cross-account backup, cross-region, organization-level policies. Read full `storage-cheat-sheet.md`. 20 practice questions on storage. | 1.5 h |

---

### Day 11 (Thursday) — Relational Databases

| Time Block | Activity | Duration |
|------------|----------|----------|
| **Morning (9–12)** | RDS: engines, Multi-AZ (instance vs cluster), Read Replicas (same-region, cross-region), storage types (gp3, io1), encryption (at-rest, in-transit), IAM auth, RDS Proxy, custom RDS (Oracle, SQL Server). | 3 h |
| **Afternoon (1–3:30)** | Aurora: architecture (shared storage, 6 copies across 3 AZs), Aurora Serverless v2, Global Database (write forwarding), Aurora ML, Parallel Query, Blue/Green deployments, cloning, backtrack. Read `database-cheat-sheet.md` RDS/Aurora sections. | 2.5 h |
| **Evening (7–8:30)** | Redshift: architecture, node types (RA3, DC2, DS2), Spectrum, Concurrency Scaling, AQUA, data sharing, Redshift Serverless, Redshift ML. 20 database practice questions. | 1.5 h |

---

### Day 12 (Friday) — NoSQL & Purpose-Built Databases

| Time Block | Activity | Duration |
|------------|----------|----------|
| **Morning (9–12)** | DynamoDB: partition keys, sort keys, LSI vs GSI, capacity modes (provisioned vs on-demand), auto-scaling, DAX, DynamoDB Streams, Global Tables, transactions, TTL, backups (on-demand, PITR), PartiQL. | 3 h |
| **Afternoon (1–3:30)** | ElastiCache: Redis vs Memcached comparison, cluster mode enabled/disabled, Global Datastore, caching strategies (lazy loading, write-through, write-behind), MemoryDB for Redis. | 2.5 h |
| **Evening (7–8:30)** | Purpose-built databases: Neptune (graph), DocumentDB (MongoDB), Keyspaces (Cassandra), QLDB (ledger), Timestream (time-series). When to use each. Read full `database-cheat-sheet.md`. 20 practice questions. | 1.5 h |

---

### Day 13 (Saturday) — Database Migration & Data Strategy

| Time Block | Activity | Duration |
|------------|----------|----------|
| **Morning (9–12)** | DMS: homogeneous vs heterogeneous migrations, SCT (Schema Conversion Tool), continuous replication, multi-AZ. Migration patterns: re-platform, re-host, re-architect. | 3 h |
| **Afternoon (1–4)** | Read `services-comparison.md` — study database comparison tables. Build a decision tree: "Given scenario X, which database?" Practice with 30 scenario-based questions. | 3 h |
| **Evening (5–7)** | Read `limits-and-quotas.md` for storage and database limits. Flash-card review of all Week 2 material. | 2 h |

---

### Day 14 (Sunday) — Week 2 Review & Checkpoint

| Time Block | Activity | Duration |
|------------|----------|----------|
| **Morning (9–12)** | Review all notes from Days 8–13. Re-read all cheat sheets created so far. Focus on weak areas identified in Week 1. | 3 h |
| **Afternoon (1–4)** | **Take a 75-question timed practice test** (Set 2). Strict exam conditions. | 3 h |
| **Evening (5–7:30)** | Review every question from the practice test. Update "Weak Areas" notebook. Compare score with Week 1 — you should see improvement. | 2.5 h |

> **Week 2 Checkpoint Target:** Score ≥ 65%. Storage and database questions should be near 70%+.

**Week 2 Tips:**
- Build comparison tables between similar services (e.g., EFS vs FSx vs EBS).
- For every storage service, memorize: max size, throughput, IOPS, encryption options, access patterns.
- DynamoDB and Aurora are **heavily tested** — know them cold.

---

## WEEK 3 — Compute, Integration, Migration & Modernization

### Day 15 (Monday) — Compute Services

| Time Block | Activity | Duration |
|------------|----------|----------|
| **Morning (9–12)** | EC2: purchase options (On-Demand, Reserved, Savings Plans, Spot, Dedicated Host, Dedicated Instance, Capacity Reservations), placement groups (cluster, spread, partition), instance store, hibernation, AMI management. | 3 h |
| **Afternoon (1–3:30)** | Auto Scaling: launch templates, scaling policies (target tracking, step, simple, scheduled, predictive), instance refresh, warm pools, lifecycle hooks. ELB: ALB vs NLB vs GWLB, cross-zone load balancing, slow start, deregistration delay, connection draining. | 2.5 h |
| **Evening (7–8:30)** | Containers: ECS (EC2 vs Fargate launch types, task definitions, service auto-scaling), EKS (managed node groups, Fargate profile, Karpenter). AWS Batch. Read `services-comparison.md` compute section. 20 practice questions. | 1.5 h |

---

### Day 16 (Tuesday) — Serverless & Application Integration

| Time Block | Activity | Duration |
|------------|----------|----------|
| **Morning (9–12)** | Lambda: concurrency (reserved, provisioned), Layers, Destinations, event source mappings, VPC configuration, Lambda@Edge, SnapStart, ephemeral storage, Lambda URLs. API Gateway: REST vs HTTP vs WebSocket, caching, throttling, usage plans, custom authorizers, mutual TLS. | 3 h |
| **Afternoon (1–3:30)** | Step Functions (Standard vs Express), SQS (Standard vs FIFO, dead-letter queues, delay queues, long polling), SNS (fan-out, filtering, FIFO topics), EventBridge (rules, event buses, cross-account/region, schema registry, pipes). | 2.5 h |
| **Evening (7–8:30)** | Kinesis Data Streams (shards, KCL, enhanced fan-out), Kinesis Data Firehose (delivery destinations, transformations), Amazon MQ (ActiveMQ vs RabbitMQ), MSK (Apache Kafka). 20 practice questions on integration. | 1.5 h |

---

### Day 17 (Wednesday) — Migration Strategies & Tools

| Time Block | Activity | Duration |
|------------|----------|----------|
| **Morning (9–12)** | 7 R's of Migration: Rehost, Replatform, Repurchase, Refactor, Retire, Retain, Relocate. AWS Migration Hub. Application Discovery Service (agent-based vs agentless). Migration Evaluator. | 3 h |
| **Afternoon (1–3:30)** | AWS Application Migration Service (MGN): architecture, replication agent, test/cutover. AWS DMS and SCT (review from Day 13). Server Migration Service (legacy — know it exists). Mainframe modernization. | 2.5 h |
| **Evening (7–8:30)** | Large-scale data migration strategies: online (DataSync, DMS, Transfer Family) vs offline (Snow Family). Calculating transfer times. Hybrid approaches. 20 migration practice questions. | 1.5 h |

---

### Day 18 (Thursday) — Cost Optimization & Well-Architected

| Time Block | Activity | Duration |
|------------|----------|----------|
| **Morning (9–12)** | AWS Well-Architected Framework: all 6 pillars deep dive (Operational Excellence, Security, Reliability, Performance Efficiency, Cost Optimization, Sustainability). Well-Architected Tool. | 3 h |
| **Afternoon (1–3:30)** | Cost optimization: AWS Cost Explorer, Budgets, Cost Anomaly Detection, Savings Plans vs Reserved Instances, Spot strategies, S3 storage class optimization, right-sizing with Compute Optimizer, Trusted Advisor. | 2.5 h |
| **Evening (7–8:30)** | Billing: Consolidated billing, Cost Allocation Tags, AWS Pricing Calculator. Organizations billing best practices. 20 cost optimization practice questions. | 1.5 h |

---

### Day 19 (Friday) — Resilience, DR & Business Continuity

| Time Block | Activity | Duration |
|------------|----------|----------|
| **Morning (9–12)** | DR strategies: Backup & Restore, Pilot Light, Warm Standby, Multi-Site Active/Active. RPO and RTO definitions and calculations. Read AWS Disaster Recovery whitepaper. | 3 h |
| **Afternoon (1–3:30)** | Multi-region architecture patterns: Route 53 failover, Aurora Global Database, DynamoDB Global Tables, S3 CRR, CloudFront with multiple origins, Global Accelerator failover. Elastic Disaster Recovery (DRS). | 2.5 h |
| **Evening (7–8:30)** | Chaos engineering with AWS Fault Injection Simulator. Resilience Hub. AWS Backup for DR. 20 DR/resilience practice questions. | 1.5 h |

---

### Day 20 (Saturday) — DevOps, CI/CD & Infrastructure as Code

| Time Block | Activity | Duration |
|------------|----------|----------|
| **Morning (9–12)** | CloudFormation: stack sets (multi-account/multi-region), nested stacks, drift detection, change sets, custom resources, DeletionPolicy, UpdatePolicy, CreationPolicy, cfn-init, cfn-signal, cfn-hup. | 3 h |
| **Afternoon (1–4)** | CI/CD: CodeCommit, CodeBuild, CodeDeploy (in-place vs blue/green, deployment groups, hooks), CodePipeline (cross-account, cross-region). CDK. SAM. Proton. Service Catalog. | 3 h |
| **Evening (5–7)** | Systems Manager: Session Manager, Patch Manager, State Manager, Parameter Store, Run Command, Automation, OpsCenter, Inventory. 20 practice questions on DevOps topics. | 2 h |

---

### Day 21 (Sunday) — Week 3 Review & Checkpoint

| Time Block | Activity | Duration |
|------------|----------|----------|
| **Morning (9–12)** | Review all notes from Days 15–20. Re-read all cheat sheets. Focus on weak areas from Week 2 checkpoint. | 3 h |
| **Afternoon (1–4)** | **Take a 75-question timed practice test** (Set 3). Strict exam conditions. | 3 h |
| **Evening (5–7:30)** | Review every question. Update "Weak Areas" notebook. Build a priority list for Week 4 review. | 2.5 h |

> **Week 3 Checkpoint Target:** Score ≥ 72%. Migration and serverless questions improving.

**Week 3 Tips:**
- Migration questions are scenario-heavy — practice extracting requirements from long question stems.
- For DR questions, always map back to RPO/RTO requirements.
- Know the difference between similar services (e.g., CloudFormation vs CDK vs SAM vs Terraform).

---

## WEEK 4 — Review, Practice Exams & Exam Preparation

### Day 22 (Monday) — Targeted Weak Area Review #1

| Time Block | Activity | Duration |
|------------|----------|----------|
| **Morning (9–12)** | Review your top 3 weakest topics from practice tests. Re-read relevant cheat sheet sections. Watch targeted video lectures on these topics. | 3 h |
| **Afternoon (1–3:30)** | Do 40 practice questions ONLY on your weak topics. Use Tutorials Dojo topic-based practice mode. | 2.5 h |
| **Evening (7–8:30)** | Review incorrect answers. Create one-page summary for each weak topic. | 1.5 h |

---

### Day 23 (Tuesday) — Targeted Weak Area Review #2

| Time Block | Activity | Duration |
|------------|----------|----------|
| **Morning (9–12)** | Review next 3 weakest topics. Focus on services you keep confusing (e.g., Storage Gateway modes, Direct Connect virtual interfaces, STS API calls). | 3 h |
| **Afternoon (1–3:30)** | Do 40 topic-specific practice questions. | 2.5 h |
| **Evening (7–8:30)** | Read `limits-and-quotas.md` end to end. These details win you points on tricky questions. | 1.5 h |

---

### Day 24 (Wednesday) — Full Practice Exam #1

| Time Block | Activity | Duration |
|------------|----------|----------|
| **Morning (9–12)** | **Full 75-question timed practice exam** (Set 4) under strict exam conditions. No breaks, no notes, 180 minutes. | 3 h |
| **Afternoon (1–4)** | **Detailed review of every single question.** For each wrong answer: write why the correct answer is correct AND why each distractor is wrong. | 3 h |
| **Evening (7–8:30)** | Update weak area list. Re-read relevant cheat sheet sections for any topics where you scored below 70%. | 1.5 h |

---

### Day 25 (Thursday) — Full Practice Exam #2

| Time Block | Activity | Duration |
|------------|----------|----------|
| **Morning (9–12)** | **Full 75-question timed practice exam** (Set 5). Different provider than Day 24 if possible. | 3 h |
| **Afternoon (1–4)** | Detailed question review. Focus on question patterns: what does AWS consider "most cost-effective"? What does "least operational overhead" mean? | 3 h |
| **Evening (7–8:30)** | Read AWS whitepapers: Well-Architected Framework (skim), Disaster Recovery (focus sections). | 1.5 h |

---

### Day 26 (Friday) — Scenario-Based Deep Dive

| Time Block | Activity | Duration |
|------------|----------|----------|
| **Morning (9–12)** | Practice complex multi-service architecture scenarios. Draw architectures for: multi-region active-active, hybrid cloud with DX + VPN, large-scale migration with minimal downtime, multi-account security baseline. | 3 h |
| **Afternoon (1–3:30)** | Review `services-comparison.md` end to end. For each comparison, verify you can explain when to use Service A vs Service B. | 2.5 h |
| **Evening (7–8:30)** | Do 30 "hardest" practice questions you've bookmarked from all previous practice tests. | 1.5 h |

---

### Day 27 (Saturday) — Final Full Practice Exam

| Time Block | Activity | Duration |
|------------|----------|----------|
| **Morning (9–12)** | **Full 75-question timed practice exam** (Set 6 — final). This should be the hardest set you have. | 3 h |
| **Afternoon (1–4)** | Detailed review. Focus on any remaining gaps. Your score should be 78%+ at this point. | 3 h |
| **Evening (5–7)** | Speed round: go through all cheat sheets one final time, highlighting anything you're still unsure about. | 2 h |

> **Day 27 Target:** Score ≥ 78% on practice exam.

---

### Day 28 (Sunday) — Final Review Day

| Time Block | Activity | Duration |
|------------|----------|----------|
| **Morning (9–12)** | Final read-through of ALL cheat sheets: `networking-cheat-sheet.md`, `security-cheat-sheet.md`, `database-cheat-sheet.md`, `storage-cheat-sheet.md`, `services-comparison.md`, `limits-and-quotas.md`. | 3 h |
| **Afternoon (1–4)** | Review your "Weak Areas" notebook. Do 20–30 targeted questions on any remaining weak spots. | 3 h |
| **Evening (5–6:30)** | Create a one-page "exam day" cheat sheet of things you keep forgetting. Review it 3 times. | 1.5 h |

---

### Day 29 (Monday) — Light Review & Rest

| Time Block | Activity | Duration |
|------------|----------|----------|
| **Morning (9–11)** | Light review: skim your one-page cheat sheet. Quick flash-card session. | 2 h |
| **Afternoon** | **REST.** Do something relaxing. Your brain needs consolidation time. Go for a walk, exercise, watch a movie. | — |
| **Evening (7–8)** | Review your one-page cheat sheet one last time. Prepare exam logistics: ID, test center location/online proctoring setup, snacks, water. Set alarm. | 1 h |

---

### Day 30 (Tuesday) — EXAM DAY

| Time Block | Activity |
|------------|----------|
| **Morning** | Light breakfast. Review one-page cheat sheet for 15 minutes. Do NOT cram. |
| **Before exam** | Arrive 15 minutes early. Deep breathing. You are prepared. |
| **During exam** | Read every question twice. Eliminate obviously wrong answers first. Flag uncertain questions — come back later. Manage your time: ~2.4 min per question. |
| **After exam** | Celebrate regardless of outcome! You invested 30 days of focused study. |

---

## Exam Day Strategies

### Time Management
- **75 questions in 180 minutes = 2.4 minutes per question**
- Flag and skip questions taking more than 3 minutes — come back later
- First pass: answer all "easy" and "medium" questions (aim: 50 min for 50 questions)
- Second pass: tackle flagged hard questions (aim: remaining time)
- Leave 10 minutes for final review

### Answer Elimination
- SAP-C02 questions have 2 or 4/5 correct answers
- Eliminate answers that: mention non-existent services, violate stated constraints, add unnecessary complexity
- "Least operational overhead" = managed services, serverless, automation
- "Most cost-effective" = right-size, use appropriate pricing model, avoid over-provisioning
- "Minimize downtime" = blue/green, canary, multi-AZ/region

### Common Question Patterns
| Pattern | What They're Really Asking |
|---------|---------------------------|
| "Company is migrating..." | Which migration strategy + which tools? |
| "Minimize operational overhead" | Use managed/serverless services |
| "Most cost-effective" | Right pricing model, avoid waste |
| "Meet compliance requirements" | Encryption, audit trail, access control |
| "Disaster recovery with RPO/RTO" | Match DR strategy to requirements |
| "Multi-account strategy" | Organizations + SCPs + Control Tower |
| "Hybrid connectivity" | Direct Connect + VPN patterns |

---

## Progress Tracking

| Checkpoint | Target Score | Date | Actual Score | Notes |
|-----------|-------------|------|-------------|-------|
| Week 1 Practice Test | ≥ 55% | Day 7 | ___ | |
| Week 2 Practice Test | ≥ 65% | Day 14 | ___ | |
| Week 3 Practice Test | ≥ 72% | Day 21 | ___ | |
| Full Exam #1 | ≥ 70% | Day 24 | ___ | |
| Full Exam #2 | ≥ 75% | Day 25 | ___ | |
| Final Practice Exam | ≥ 78% | Day 27 | ___ | |

---

## Weak Area Tracker

| Topic | Initial Confidence (1-5) | After Week 2 | After Week 3 | Final |
|-------|-------------------------|-------------|-------------|-------|
| IAM / STS / Federation | | | | |
| Organizations / SCPs | | | | |
| VPC / Subnets / Routing | | | | |
| Direct Connect / VPN | | | | |
| Transit Gateway | | | | |
| Route 53 | | | | |
| CloudFront / Edge | | | | |
| S3 Advanced Features | | | | |
| EBS / EFS / FSx | | | | |
| Storage Gateway / DataSync | | | | |
| RDS / Aurora | | | | |
| DynamoDB | | | | |
| Redshift / Analytics | | | | |
| ElastiCache / MemoryDB | | | | |
| Lambda / Serverless | | | | |
| Containers (ECS/EKS) | | | | |
| SQS / SNS / EventBridge | | | | |
| Kinesis / MSK | | | | |
| Migration (7Rs, MGN, DMS) | | | | |
| DR Strategies | | | | |
| CloudFormation / IaC | | | | |
| Cost Optimization | | | | |
| Well-Architected Framework | | | | |

---

## Final Tips by Week

### Week 1
- Build a strong foundation — don't skip fundamentals even if you think you know them.
- Draw every network topology by hand. Muscle memory helps.
- Create flash cards for IAM policy evaluation logic.

### Week 2
- Storage and database services have the most options — comparison tables are your best friend.
- Know the IOPS and throughput numbers for EBS volume types.
- DynamoDB partition key design is a frequent exam topic.

### Week 3
- Migration questions are the most scenario-heavy — practice reading long question stems.
- Always map DR strategies to RPO/RTO numbers.
- Serverless questions often test Lambda limits and API Gateway features.

### Week 4
- Trust your preparation — don't try to learn new topics this week.
- Focus on reinforcing what you already know and fixing weak spots.
- Practice under timed conditions as much as possible.
- The night before: light review only, get good sleep.
