# 6.5 Disaster Recovery and High Availability

DR and HA are frequent exam topics. You must know the tiers (backup/restore → pilot light → warm → hot), the RTO/RPO each provides, and how to configure each using GCP services.

---

## 1. Definitions

- **RTO** (Recovery Time Objective): how quickly systems must be back. Lower = more cost.
- **RPO** (Recovery Point Objective): how much data loss is acceptable. Lower = more cost.
- **MTTR** (Mean Time to Recovery): actual restore time.
- **MTBF** (Mean Time Between Failures): reliability metric.

---

## 2. DR tiers (and GCP mappings)

| Tier | RPO / RTO | Description | GCP pattern |
| --- | --- | --- | --- |
| **Backup & restore** | hours / days | Take backups to DR region; restore when needed | GCS snapshots, Cloud SQL exports |
| **Pilot light** | minutes / 1–2 h | Core infra (DB replicas) running in DR, compute idle | Cross-region Cloud SQL replica, TF templates ready |
| **Warm standby** | seconds / minutes | DR site scaled-down but running | Regional MIGs in DR minimum size, PubSub failover |
| **Hot / active-active** | ~0 / ~0 | Both regions serve live traffic | Spanner multi-region, global LB, Firestore multi-region |

---

## 3. Backup strategies

- **Cloud SQL**: automatic daily + PITR (7–35 days); **copy to another region** for DR; export to GCS for long-term retention.
- **Spanner**: backups in same or other region; schedule via Backup Schedules.
- **Firestore**: managed export to GCS (daily schedule).
- **BigQuery**: time travel (7d), table snapshots, cross-region copy (via dataset copy).
- **GCS**: versioning + dual-region Turbo replication; cross-region copy with STS.
- **GCE**: persistent disk snapshots (regional or global); schedule with snapshot schedules; machine images for boot + data + metadata.
- **Backup and DR Service** (Actifio-based): policy-based backups for GCE, VMware Engine, Cloud SQL, Oracle; app-consistent; immutable storage.

---

## 4. HA patterns by service

| Layer | HA pattern |
| --- | --- |
| Compute | Regional MIG across 3 zones; autoscaler |
| GKE | Regional cluster; 3-zone node pools |
| Cloud Run | Auto multi-zone; regional |
| App Engine | Regional; App Engine Standard serves across zones |
| Cloud SQL | Regional HA (primary + standby); cross-region replica for DR |
| Spanner | Regional (99.99%) or multi-region (99.999%) |
| Bigtable | Multi-cluster routing (active/active or failover) |
| Firestore | Multi-region location |
| GCS | Multi-region or dual-region |
| PD | Regional PD across 2 zones |
| Memorystore | Standard tier (HA) or Redis Cluster |

---

## 5. Global LB as DR enabler

- Single anycast VIP; routes to healthy backends based on health check.
- Failover policies with **failoverRatio** in backend service.
- **Global LB + Cloud DNS failover policy** backup for complete LB failure.

---

## 6. Cross-region networking

- **Interconnect** across 2 metros for 99.99% SLA.
- **HA VPN** across 2 regions for 99.99%.
- Cross-region traffic inside VPC routes automatically; watch egress cost.

---

## 7. Choosing DR tier by RPO/RTO

```
RPO 24h, RTO 24h → Backup & restore
RPO 1h, RTO 4h → Pilot light (cross-region replicas, scripted bring-up)
RPO 1min, RTO 5min → Warm standby (MIGs at min size + replica + scripted promote)
RPO 0, RTO 0 → Hot (Spanner multi-region, global LB, stateless multi-region)
```

---

## 8. Designing warm standby

- Primary region: full stack.
- DR region: same infra, scaled to minimum.
- Data: Cloud SQL cross-region replica (async) or Spanner multi-region; GCS dual-region for files.
- DNS / LB: Global LB handles failover automatically; Cloud DNS failover as fallback.
- Runbook: promote replica, scale up, update DNS (if needed), communicate.

---

## 9. Designing active-active

- Use **Spanner multi-region** or **Firestore multi-region** (strong consistency).
- Or design for eventual consistency (Pub/Sub CQRS, conflict resolution).
- Global LB routes closest healthy backend.
- Consider multi-region **Dataflow** pipelines (Pub/Sub replicated to both regions).

---

## 10. Testing DR

- Schedule semiannual or annual DR drills.
- Snapshot-restore test: restore backups to alternate region; validate.
- Game day: fail over prod to DR; fail back; document time and issues.
- Chaos drills: region failure simulation via traffic routing.

---

## 11. Common DR mistakes

- Relying on default Cloud SQL backups without cross-region copy.
- Nightly GCS snapshots when RPO says "minutes".
- Forgetting DNS TTLs too high → long failover.
- No runbook → humans freeze during incidents.
- Not testing backup restore procedures.

---

## 12. DR/HA exam patterns

| Scenario | Answer |
| --- | --- |
| "RPO=0 RTO=0 global" | Spanner multi-region + global LB |
| "RPO=15min RTO=1h" | Warm standby; Cloud SQL cross-region replica + MIG pre-provisioned |
| "Low-budget DR for analytics" | GCS dual-region + BigQuery cross-region copy |
| "Backup VMs with policy & immutability" | Backup & DR Service |
| "99.99% LB + API multi-region" | Global HTTPS LB + Spanner + regional MIGs in 3 regions |
| "Regional DB outage failover auto" | Cloud SQL HA (zone) + cross-region replica for region failures |

Next: `07-service-deep-dives/`.
