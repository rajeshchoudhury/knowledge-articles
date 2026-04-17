# Google Professional Cloud Architect (PCA) — Complete Study Package

This repository is a complete, self-contained study system for the **Google Cloud Certified — Professional Cloud Architect** exam. It is designed so that a working architect can read it end-to-end, practice, and pass the exam with confidence.

---

## How this package is organized

| Folder | Purpose |
| --- | --- |
| `00-study-plan/` | 8-week plan, exam blueprint, resources, how to study |
| `01-domain-design-planning/` | Domain 1 — Designing and planning a cloud solution architecture |
| `02-domain-manage-provision/` | Domain 2 — Managing and provisioning a solution infrastructure |
| `03-domain-security-compliance/` | Domain 3 — Designing for security and compliance |
| `04-domain-analyze-optimize/` | Domain 4 — Analyzing and optimizing technical and business processes |
| `05-domain-implementation/` | Domain 5 — Managing implementation |
| `06-domain-reliability/` | Domain 6 — Ensuring solution and operations reliability |
| `07-service-deep-dives/` | Per-service deep dives (Compute Engine, GKE, BigQuery, Spanner, VPC, IAM, etc.) |
| `08-case-studies/` | Official case studies + strategies (EHR Healthcare, HRL, Mountkirk Games, TerramEarth) |
| `09-flashcards/` | Flashcards grouped by topic |
| `10-diagrams/` | Reference architectures and decision diagrams |
| `11-code-labs/` | Hands-on labs (`gcloud`, Terraform, YAML, Cloud Build) |
| `12-cheat-sheets/` | Quick references, decision trees, limits, SLAs, pricing |
| `13-practice-exams/` | 500+ practice questions organized in full mock exams |

---

## Exam at a glance

- **Exam code:** Professional Cloud Architect
- **Length:** 2 hours
- **Questions:** ~50–60 multiple choice / multiple select
- **Passing:** Not published; target ~75–80% on mocks
- **Prerequisites:** None (3+ years industry / 1+ year GCP recommended)
- **Registration:** Via Kryterion / PSI through Google's exam portal
- **Languages:** English, Japanese
- **Cost:** $200 USD
- **Validity:** 2 years; recertification required

### Exam domains and weights (2024+ blueprint)

| # | Domain | Weight |
| --- | --- | --- |
| 1 | Designing and planning a cloud solution architecture | ~24% |
| 2 | Managing and provisioning a solution infrastructure | ~15% |
| 3 | Designing for security and compliance | ~18% |
| 4 | Analyzing and optimizing technical and business processes | ~18% |
| 5 | Managing implementation | ~11% |
| 6 | Ensuring solution and operations reliability | ~14% |

Case studies are used to frame scenario questions; they are **not** a separate domain but are threaded across all six.

---

## Recommended order of study

1. Read `00-study-plan/01-overview-and-timeline.md` for the big picture.
2. Read all six domain folders in order (they form the backbone of the exam).
3. Read each case study in `08-case-studies/`, then re-answer questions with each case study as context.
4. Drill `07-service-deep-dives/` for any service you feel shaky on.
5. Memorize with `09-flashcards/` and `12-cheat-sheets/`.
6. Practice with `13-practice-exams/` one full exam per day in the last week.
7. Review misses; re-read the corresponding deep dive; repeat.

---

## How to pass (high-level strategy)

1. **Think like an architect, not an operator.** The exam rarely asks "what command?"; it asks "which design fits these constraints?".
2. **Anchor to case studies.** When two answers look equally good, pick the one that aligns with the case study's **business**, **technical**, and **executive** statements.
3. **Trust Google-preferred services.** In a tie between a self-managed option and a managed Google product, the managed product usually wins — unless requirements explicitly demand portability (then Anthos / GKE / OSS).
4. **Honor non-functional requirements.** Latency, RPO/RTO, compliance, cost, and developer velocity often drive the "best" answer.
5. **Eliminate aggressively.** Most questions have 2 clearly wrong options; focus effort on the 2 remaining.

---

## Study time estimate

- **Experienced cloud architect (AWS/Azure background):** 4–6 weeks, ~1 hr/day + weekends.
- **GCP operator with little architecture work:** 8–10 weeks.
- **New to cloud:** 12+ weeks; pair with **Associate Cloud Engineer** first.

Continue to `00-study-plan/01-overview-and-timeline.md`.
