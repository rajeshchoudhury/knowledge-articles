# AWS Certified Cloud Practitioner (CLF-C02) — Complete Mastery Guide

> **Audience:** Architects, engineers, managers, and aspirants preparing for the
> AWS Certified Cloud Practitioner exam (exam code **CLF-C02**, effective
> September 2023 onward). This guide goes well beyond the foundational level —
> it is deliberately written so that an architect-level reader can use it to
> pass the exam with ease and also use the same content as a reference for
> downstream Associate and Professional certifications.

---

## 1. Why this guide exists

Most CCP materials are either too shallow (a collection of one-liners about
services) or too unfocused (pages of AWS marketing text). This guide is built
to be **exhaustive but exam-aligned**. Every topic in the official
[CLF-C02 Exam Guide](https://d1.awsstatic.com/training-and-certification/docs-cloud-practitioner/AWS-Certified-Cloud-Practitioner_Exam-Guide.pdf)
is covered, with the depth an architect expects, plus:

- Long-form domain articles (deep dives, not bullet lists)
- Architecture diagrams (Mermaid + ASCII) for every major pattern
- Code examples (AWS CLI, Boto3/SDK, CloudFormation, Terraform)
- Flashcards (600+ cards) for spaced-repetition review
- Cheat sheets / comparison tables for rapid last-week revision
- 4 × full-length 65-question practice exams with detailed explanations
- Scenario-based deep dives, a complete glossary, and an exam-day playbook

---

## 2. Exam at a glance (CLF-C02)

| Attribute                  | Value                                                 |
|----------------------------|-------------------------------------------------------|
| Exam code                  | **CLF-C02**                                           |
| Level                      | Foundational                                          |
| Duration                   | 90 minutes                                            |
| Number of questions        | 65 (50 scored + 15 unscored)                          |
| Question types             | Multiple choice, multiple response                    |
| Passing score              | 700 / 1000 (scaled)                                   |
| Cost (USD)                 | $100 (plus taxes)                                     |
| Delivery                   | Pearson VUE test center **or** online proctored       |
| Recommended experience     | Up to 6 months of exposure to AWS cloud               |
| Validity                   | 3 years                                               |
| Languages                  | EN, JP, KR, ZH-CN, ZH-TW, FR, DE, IT, PT-BR, ES (LA/ES), ID |

### Exam domains (CLF-C02)

| # | Domain                                    | Weight |
|---|-------------------------------------------|-------:|
| 1 | Cloud Concepts                            | **24%** |
| 2 | Security and Compliance                   | **30%** |
| 3 | Cloud Technology and Services             | **34%** |
| 4 | Billing, Pricing, and Support             | **12%** |

> Compared with the legacy **CLF-C01**, CLF-C02 moved all "Technology" content
> into a single domain (now 34%) and folded the old "Billing & Pricing" and
> "Support" content into Domain 4. Net effect: more emphasis on service
> *selection* and *cost governance*, and a slight reduction of trivia-style
> questions about the AWS global infrastructure.

---

## 3. How this guide is organized

```
AWS-Cloud-Practitioner-Exam/
├── README.md                                 ← you are here
├── 00-Study-Plan/                            ← 2, 4, 6 week and 24-hour plans
├── 01-Domain-Cloud-Concepts/                 ← Domain 1 deep article (24%)
├── 02-Domain-Security-Compliance/            ← Domain 2 deep article (30%)
├── 03-Domain-Technology-Services/            ← Domain 3 deep article (34%)
├── 04-Domain-Billing-Pricing-Support/        ← Domain 4 deep article (12%)
├── 05-Services-Deep-Dive/                    ← Per-service reference
├── 06-Architecture-Diagrams/                 ← Mermaid + ASCII diagrams
├── 07-Code-Labs/                             ← CLI, SDK, IaC hands-on
├── 08-Flashcards/                            ← 600+ spaced-repetition cards
├── 09-Cheat-Sheets/                          ← Fast comparison tables
├── 10-Practice-Exams/                        ← 4 full mocks + answer keys
└── 11-Scenarios-and-Glossary/                ← Case studies, glossary, exam-day
```

### Recommended reading order

1. **`00-Study-Plan/STUDY-PLAN.md`** — pick a track (2 / 4 / 6 weeks).
2. **Domain 1 → 4 articles** in `01-…/` through `04-…/`. Do one domain per
   session, then do the corresponding flashcards in `08-Flashcards/`.
3. **`05-Services-Deep-Dive/`** — skim first; return for specific services as
   they come up. Architects can treat this as their reference manual.
4. **`06-Architecture-Diagrams/`** + **`07-Code-Labs/`** — optional but highly
   recommended. Architects will breeze through these.
5. **`09-Cheat-Sheets/`** — use daily in the final week as a quick refresher.
6. **`10-Practice-Exams/`** — take one every 2–3 days in the last stretch.
   Aim for ≥ 85% on each before sitting the real exam.
7. **`11-Scenarios-and-Glossary/EXAM-DAY.md`** — read the night before.

---

## 4. What an architect will gain beyond the certification

- A durable mental map of AWS's 200+ services grouped by capability.
- Canonical patterns (Well-Architected pillars, Shared Responsibility,
  Landing Zone, cost governance, HA vs DR, etc.) explained once, in depth.
- A reusable reference of IaC snippets (CloudFormation + Terraform) for
  common foundational constructs.
- A vocabulary toolkit: every term that shows up on CCP also shows up on SAA,
  SAP, DOP, SCS, DBS, ANS, and ML exams.

---

## 5. Quick-start: "I have 24 hours" path

If you've been given the exam tomorrow:

1. Read `09-Cheat-Sheets/00-ONE-PAGE-CHEAT-SHEET.md` (≈ 30 min).
2. Read `01-Domain-Cloud-Concepts/article.md` sections 1–6, then skim rest.
3. Read `02-Domain-Security-Compliance/article.md` sections 1–4 fully
   (Shared Responsibility, IAM, Data protection, Compliance).
4. Skim `03-Domain-Technology-Services/article.md` — focus on the tables.
5. Read `04-Domain-Billing-Pricing-Support/article.md` entirely (it's shorter
   and heavily-tested per-question).
6. Take **Practice Exam 1**. Review every wrong answer.
7. Skim flashcards categorized "Must-Know" in `08-Flashcards/`.

Confidence check: if you consistently answer ≥ 40/50 on Practice Exam 1 under
90 minutes, you are ready.

---

## 6. Conventions used in this guide

- **Bold** on first mention of an exam term.
- ▶ at the start of a "**gotcha**" — something the exam tests that people
  routinely get wrong.
- 🧭 at the start of an "**architect's perspective**" — insight that helps you
  reason about scenario-based questions.
- 🧪 at the start of a "**hands-on**" — lab you can run in a sandbox account.
- All prices in USD, us-east-1, On-Demand, at the time of writing. Prices
  change — *never* memorize specific dollar amounts for the exam; memorize
  **relative** cost behavior (e.g., "Spot is up to 90% cheaper than OD").

---

## 7. Author's meta-advice

- The CCP exam is **foundational**, not trivial. It tests whether you can
  *choose* services and *reason* about them, not whether you can configure
  them. Every question can be mapped to one of three lenses:
  - *"Which service solves this problem?"* — Domain 3 tech knowledge.
  - *"Who is responsible / what is compliant / what is secure?"* — Domain 2.
  - *"What is the most cost-optimal way to do X?"* — Domain 4.
- Read every question twice. CCP questions are short; the trap is almost
  always in a single qualifying word (*managed*, *serverless*, *global*,
  *private*, *in transit*, *at rest*, *multi-AZ*, *multi-Region*).
- Eliminate the obviously wrong answers first. On CCP two of the four options
  are usually obvious distractors; the real decision is between the remaining
  two.

Good luck. Let's begin.
