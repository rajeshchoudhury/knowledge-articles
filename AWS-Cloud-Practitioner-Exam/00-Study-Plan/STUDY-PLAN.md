# Study Plan — AWS Certified Cloud Practitioner (CLF-C02)

This file contains four study plans. Pick the one that fits your time budget
and learning style. All plans map to the material in this repository.

- [Track A — 6-week deep track (architect / thorough)](#track-a--6-week-deep-track)
- [Track B — 4-week balanced track (working professional)](#track-b--4-week-balanced-track)
- [Track C — 2-week sprint (experienced cloud practitioner)](#track-c--2-week-sprint)
- [Track D — 24-hour emergency plan](#track-d--24-hour-emergency-plan)
- [Meta: study techniques that actually work](#meta-study-techniques-that-actually-work)
- [Daily session template](#daily-session-template)
- [Readiness checklist (gate before booking the exam)](#readiness-checklist)

---

## Track A — 6-week deep track

Best if you have ~6–8 hours per week and want to retain the material as a
long-term reference. This track builds architect-level understanding.

### Week 1 — Foundations and Cloud Concepts (Domain 1, 24%)

| Day | Focus | Deliverables |
|---|---|---|
| 1 | Read `README.md` + `01-Domain-Cloud-Concepts/article.md` §1–3 (benefits of cloud, deployment models, cloud economics) | Notes on CapEx vs OpEx, 6 benefits of cloud |
| 2 | `01-…/article.md` §4–6 (Well-Architected framework, 6 pillars) | Diagram the 6 pillars from memory |
| 3 | `01-…/article.md` §7–9 (design principles, migration strategies, global infrastructure) | Draw the 7 R's of migration |
| 4 | `06-Architecture-Diagrams/01-global-infrastructure.md` + `09-Cheat-Sheets/01-global-infrastructure.md` | Be able to explain AZ vs Region vs Edge |
| 5 | Flashcards: `08-Flashcards/01-cloud-concepts.md` | ≥ 85% recall |
| 6 | Lab: `07-Code-Labs/01-first-account-and-cli.md` | Account created, CLI works |
| 7 | Review + weekly self-quiz (Practice Exam 1, Domain 1 questions only) | Identify weak sub-topics |

### Week 2 — Security (Domain 2 part 1)

| Day | Focus |
|---|---|
| 1 | `02-Domain-Security-Compliance/article.md` §1–2 (Shared Responsibility Model) |
| 2 | `02-…/article.md` §3 (IAM deep dive — users, groups, roles, policies) |
| 3 | `02-…/article.md` §4 (Identity federation, IAM Identity Center, MFA, Cognito) |
| 4 | Lab: `07-Code-Labs/02-iam-lab.md` (create users, groups, roles, policies) |
| 5 | Diagrams: `06-Architecture-Diagrams/02-iam-and-sts.md` |
| 6 | Flashcards: `08-Flashcards/02-security-iam.md` |
| 7 | Review + Practice Exam 1, Domain 2 subset |

### Week 3 — Security (Domain 2 part 2) + Compliance

| Day | Focus |
|---|---|
| 1 | `02-…/article.md` §5 (Data protection — encryption at rest/in transit, KMS, CloudHSM, Secrets Manager, Certificate Manager) |
| 2 | `02-…/article.md` §6 (Network security — SG, NACL, WAF, Shield, Firewall Manager, Network Firewall) |
| 3 | `02-…/article.md` §7 (Detective controls — CloudTrail, Config, GuardDuty, Inspector, Security Hub, Macie, Detective) |
| 4 | `02-…/article.md` §8 (Compliance programs — Artifact, Audit Manager, HIPAA, PCI, SOC, FedRAMP, GDPR) |
| 5 | Diagrams: encryption patterns, detective controls map |
| 6 | Flashcards: `08-Flashcards/03-security-data-network.md` |
| 7 | Practice Exam 1, Domain 2 subset (target ≥ 80%) |

### Week 4 — Compute, Storage, Databases (Domain 3 part 1)

| Day | Focus |
|---|---|
| 1 | `03-Domain-Technology-Services/article.md` §1–2 (global infra refresher, compute: EC2, ECS, EKS, Fargate, Lambda, Batch, Lightsail, Elastic Beanstalk) |
| 2 | Compute continued: instance families, purchase options, auto scaling |
| 3 | `03-…/article.md` §3 (Storage: S3 classes, EBS, EFS, FSx, Storage Gateway, Snow family, AWS Backup) |
| 4 | `03-…/article.md` §4 (Databases: RDS, Aurora, DynamoDB, ElastiCache, Neptune, DocumentDB, Redshift, Timestream, Keyspaces, QLDB, MemoryDB) |
| 5 | Lab: `07-Code-Labs/03-ec2-and-s3-lab.md` |
| 6 | Lab: `07-Code-Labs/04-rds-and-dynamodb-lab.md` |
| 7 | Flashcards: compute, storage, database + Practice Exam 2 Domain 3 subset |

### Week 5 — Networking, Integration, Ops, Dev (Domain 3 part 2)

| Day | Focus |
|---|---|
| 1 | `03-…/article.md` §5 (Networking: VPC, subnets, route tables, IGW, NAT, VPN, Direct Connect, Transit Gateway, PrivateLink, Route 53, CloudFront, Global Accelerator) |
| 2 | `03-…/article.md` §6 (Integration: SQS, SNS, EventBridge, Step Functions, API Gateway, AppSync, MQ) |
| 3 | `03-…/article.md` §7 (Management & governance: CloudWatch, CloudTrail, Config, Organizations, Control Tower, Systems Manager, Trusted Advisor, Health, License Manager) |
| 4 | `03-…/article.md` §8 (Developer tools & DevOps: CodeCommit, CodeBuild, CodeDeploy, CodePipeline, CodeArtifact, Cloud9, X-Ray, CodeStar, Amplify, App Runner) |
| 5 | `03-…/article.md` §9 (Analytics, ML, AI, IoT, media, migration, end-user) |
| 6 | Diagrams: VPC, hybrid, event-driven |
| 7 | Practice Exam 2 full + review |

### Week 6 — Billing, Pricing, Support, Final prep (Domain 4, 12%)

| Day | Focus |
|---|---|
| 1 | `04-Domain-Billing-Pricing-Support/article.md` §1–3 (pricing fundamentals, free tier, savings plans, RIs, Spot) |
| 2 | `04-…/article.md` §4–6 (Organizations consolidated billing, AWS Budgets, Cost Explorer, CUR, Cost Anomaly Detection) |
| 3 | `04-…/article.md` §7–8 (Support plans, TAM, AWS Abuse, IQ, Professional Services, APN) |
| 4 | Cheat sheets: all of `09-Cheat-Sheets/` |
| 5 | Practice Exam 3 full |
| 6 | Practice Exam 4 full; review weak areas |
| 7 | Light re-read of `11-Scenarios-and-Glossary/EXAM-DAY.md`. **Sleep.** |

---

## Track B — 4-week balanced track

Best if you have ~10 hours per week.

- **Week 1** — Domains 1 + 2 (Cloud Concepts + Security). Cover articles,
  flashcards, cheat sheets, diagrams for both. Practice Exam 1 at end.
- **Week 2** — Domain 3 part 1 (compute, storage, databases). Labs 3–4.
- **Week 3** — Domain 3 part 2 (networking, integration, ops, dev, analytics
  & ML overview). Practice Exam 2.
- **Week 4** — Domain 4 + Practice Exams 3 & 4 + final cheat-sheet sweep.

Daily rhythm: 1.5 h new content → 30 min flashcards → every other evening
20-question mini-quiz from the practice exam pool.

---

## Track C — 2-week sprint

Best if you have prior hands-on AWS experience.

- **Days 1–2** — `01-…/article.md` + `02-…/article.md` + flashcards.
- **Day 3** — Practice Exam 1. Review every miss.
- **Days 4–7** — `03-…/article.md` broken into the 9 sections; one per day
  with matching flashcards.
- **Day 8** — Practice Exam 2.
- **Days 9–10** — `04-…/article.md` + all cheat sheets.
- **Day 11** — Practice Exam 3.
- **Day 12** — Re-read weak-domain articles.
- **Day 13** — Practice Exam 4.
- **Day 14** — Light review + `EXAM-DAY.md`. Sleep.

---

## Track D — 24-hour emergency plan

You have ~8 productive hours before the exam. This plan prioritizes
**breadth** over depth.

| Time | Activity |
|---|---|
| 00:00–00:30 | `09-Cheat-Sheets/00-ONE-PAGE-CHEAT-SHEET.md` |
| 00:30–02:00 | Domain 1 article, skim §1–3 + §7–9 carefully. Read all tables. |
| 02:00–03:30 | Domain 2 article: §1 (Shared Responsibility), §3 (IAM), §8 (Compliance). Skim the rest. |
| 03:30–05:00 | Domain 3 article: read tables at end of every section; skip long prose. Learn *selection rules* (when to pick which service). |
| 05:00–05:45 | Domain 4 article in full — it's short. |
| 05:45–07:00 | Practice Exam 1 under timed conditions. Review mistakes. |
| 07:00–07:45 | Flashcards labeled "Must-Know" across all files. |
| 07:45–08:00 | Read `EXAM-DAY.md`. Stop studying. Sleep. |

---

## Meta: study techniques that actually work

1. **Active recall > passive reading.** After each section, close the file and
   write in your own words what you just read. If you can't, re-read.
2. **Spaced repetition.** Flashcards are split into 3 decks per topic:
   *Must-Know* (daily), *Should-Know* (every 2 days), *Nice-to-Know* (weekly).
3. **Teach it.** Explain CloudTrail vs Config to someone (or to a rubber duck)
   as if they're new to AWS. If you stumble, go back.
4. **Mini-quizzes every day**, full exams every 2–3 days in the last week.
5. **Lab anything you're hand-wavy about.** Even 15 minutes of clicking in the
   console beats 3 hours of re-reading.
6. **Don't chase 100%.** Target 85% on mocks. The passing bar is 70%.

---

## Daily session template

```
┌────────────────────────────────────────────────────────────────┐
│ 0:00 – 0:05    Warm-up: yesterday's flashcards (10 cards)      │
│ 0:05 – 0:45    New material: one article section               │
│ 0:45 – 0:55    Active recall: 1-page summary from memory       │
│ 0:55 – 1:10    10 practice questions on today's topic          │
│ 1:10 – 1:25    Review misses, create flashcards for each       │
│ 1:25 – 1:30    Log progress in PROGRESS-TRACKER.md             │
└────────────────────────────────────────────────────────────────┘
```

---

## Readiness checklist

You are ready to book the exam when **all** of the following are true:

- [ ] You can explain the Shared Responsibility Model in 60 seconds with an
      example on either side of the line for compute **and** managed DB.
- [ ] You can list the **6 pillars** of the Well-Architected Framework and
      one design principle per pillar, from memory.
- [ ] Given a workload description, you can pick **compute** (EC2 family,
      Lambda, Fargate, Beanstalk, Lightsail, Batch), **storage** (S3 class,
      EBS type, EFS, FSx), and **database** (RDS engine, Aurora, DynamoDB,
      Redshift, ElastiCache, Neptune, DocumentDB) without looking anything up.
- [ ] You can differentiate Security Group vs NACL in one sentence.
- [ ] You can differentiate CloudTrail vs Config vs CloudWatch Logs vs
      CloudWatch Metrics in one sentence each.
- [ ] You can list **every** EC2 purchasing option and when to use it.
- [ ] You can name the **4 AWS Support plans** and the one feature that
      distinguishes each (Basic, Developer, Business, Enterprise/On-Ramp,
      Enterprise).
- [ ] You scored ≥ 85% on at least **two** of the four practice exams.
- [ ] You have slept well the night before. (Seriously.)

When all boxes are checked — book the exam and pass.
