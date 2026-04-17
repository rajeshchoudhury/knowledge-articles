# Overview and Timeline

## What a Google Cloud Architect is expected to do

The Professional Cloud Architect (PCA) is Google's flagship architecture certification. It validates the ability to:

- Translate business requirements into cloud-native system designs.
- Balance cost, performance, reliability, security, and compliance trade-offs.
- Design for multi-region HA, DR, and regulated workloads.
- Lead migrations (lift-and-shift, move-and-improve, rebuild) from on-prem or other clouds.
- Govern Google Cloud projects at scale (folders, policies, IAM, billing).
- Guide dev teams on CI/CD, container, serverless, and data architectures.
- Operate reliable systems with SRE practices.

Unlike the Associate Cloud Engineer, which is mostly operational, **PCA is design-first**. You must reason about trade-offs. The exam loves answers like "the one that meets all requirements with the lowest operational burden".

## Philosophy for answering PCA questions

The "GCP-preferred answer" usually satisfies all of these:

1. **Managed over self-managed.** Cloud SQL > self-hosted MySQL on GCE, unless portability demands it.
2. **Global over regional** for web-scale user-facing apps. Spanner > regional DB when multi-region consistency matters. Global HTTPS LB > regional LB for worldwide users.
3. **Least privilege by default.** Prefer service accounts with narrow roles, workload identity over keys, VPC SC for data perimeters.
4. **Decouple with Pub/Sub / Eventarc.** Event-driven is almost always scored above tightly coupled.
5. **BigQuery for analytics, Spanner for global OLTP, Cloud SQL for traditional RDBMS, Firestore for app data, Bigtable for high-throughput time-series.**
6. **IaC (Terraform) for repeatability.** Deployment Manager still appears but Terraform is preferred.
7. **Observability: Cloud Monitoring + Logging + Trace + Profiler + Error Reporting (Cloud Operations suite).**
8. **Hybrid: Anthos / GKE + Connect / Cloud Interconnect (Dedicated or Partner) + Cloud VPN (HA).**

## Timeline — 8 weeks (target)

```
Week 1: Foundations + Domain 1 (design/planning)
Week 2: Core services: Compute Engine, GKE, Cloud Run, App Engine
Week 3: Storage & databases: GCS, Cloud SQL, Spanner, Firestore, Bigtable
Week 4: Networking: VPC, Interconnect, LB, CDN, Armor, NAT; Domain 2
Week 5: Security & compliance (Domain 3) + IAM, KMS, Secret Manager, VPC-SC
Week 6: Data analytics (BigQuery, Dataflow, Dataproc, Pub/Sub, Composer) + Domain 4
Week 7: Implementation (Domain 5) + CI/CD (Cloud Build, Artifact Registry, GitOps)
Week 8: Reliability (Domain 6) + SRE + case studies + mock exams
```

For an accelerated 4-week plan, double up weeks (1+2, 3+4, 5+6, 7+8) and commit 2 hrs/day.

## Daily structure

1. **Read**: 30–40 minutes of a deep-dive article from the domain folders.
2. **Practice**: 30 minutes of flashcards + 1–2 code/lab snippets from `11-code-labs/`.
3. **Drill**: 10–15 practice questions from `13-practice-exams/` (start untimed, later timed).
4. **Review**: 10 minutes — re-read any missed concept.

## Preparing for exam day

- Take at least **3 full 60-question timed mocks** in the last 10 days.
- Last 3 days: switch to flashcards + cheat sheets; no new content.
- **Night before:** review `12-cheat-sheets/`, sleep.
- **Exam day:** flag & move on anything > 90 seconds; return after a first pass.

Next: `02-exam-blueprint.md`.
