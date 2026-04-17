# 5.3 Migration Execution

The *planning* side of migration was covered in Domain 1. This chapter focuses on **executing** a migration — setting up tools, running waves, and validating.

---

## 1. Wave-based execution

### Sizing a wave

- 5–20 applications per wave typically.
- Balance complexity across waves (don't stack all crown jewels together).
- Include **dress rehearsal** days before cutover.
- Reserve post-cutover **hypercare** (24–72h intensive support).

### Pre-wave checklist

- Runbook written and peer-reviewed.
- Rollback plan documented.
- Comm plan (status page, stakeholders, on-call).
- Database freeze/thaw tested.
- Monitoring/alerts in place pre-cutover.
- DNS TTL lowered ahead of cutover (e.g., to 60s).

---

## 2. Migrate to Virtual Machines (VMs) — detailed flow

1. **Install connector** in source (VMware or physical agents).
2. **Add source** in Migration Center; discover VMs.
3. **Create migration plan** (target project, VPC, machine type, OS license).
4. **Start replication** — continuous background sync.
5. **Test-clone** — boot a test copy on GCE; validate.
6. **Cutover** — final sync, stop source, start target.
7. **Commit** — decommission replication.

### Tips

- Preserve IPs is usually impossible; update DNS + LB.
- Use **Cloud VPN/Interconnect** to keep internal IP access to legacy systems during transition.
- Post-cutover: run OS Config / Patch Management on migrated VMs.
- Where possible, **modernize** after rehost (move databases to Cloud SQL, switch LB to GCP LB).

---

## 3. Database Migration Service (DMS)

- Supports MySQL → Cloud SQL / AlloyDB; PG → Cloud SQL / AlloyDB; SQL Server → Cloud SQL; Oracle to PG (heterogeneous preview).
- **Continuous** mode: snapshot + CDC; minimal downtime.
- Source prerequisites: binlog (MySQL), WAL with replication (PG).
- Network: Private IP via VPN/Interconnect or public IP with allowlist.
- Validation: DMS reports row counts and diffs.

### Cutover steps

1. Stop writes on source (or use read-only flag).
2. Wait for DMS to catch up (lag = 0).
3. Promote target (DMS "migration job" finalize).
4. Point application to Cloud SQL / AlloyDB.
5. Decommission source or run in parallel for fallback.

---

## 4. Datastream (CDC)

- Real-time CDC to BigQuery (BQ direct mode) or GCS or Spanner.
- Source: MySQL, PG, Oracle, SQL Server.
- Use cases: analytics freshness, lambda architectures, cold-over-hot migration.

---

## 5. Storage Transfer Service (STS)

- Jobs definition: source (S3, Azure Blob, HTTP, on-prem via agent) → destination (GCS).
- Schedules, filters, bandwidth throttling.
- **Agents** for on-prem: run on multiple hosts; parallel transfers.
- Validation: checksums (CRC32C / MD5).

### Runbook

1. Plan bandwidth; test with small subset.
2. Deploy STS agents on filer/NFS hosts with sufficient IO.
3. Start job; monitor in console.
4. Post-transfer: re-run for delta; cutover with lock.
5. Checksum validation; quarantine orphans.

---

## 6. Transfer Appliance

- Order via Cloud Console (7 / 40 / 300 TB).
- Ship the appliance; copy data locally; ship back.
- ~5–7 days door-to-door.
- Encrypted in transit and at rest; keys managed by you or Google.
- **When to choose**: > 60 TB and network bandwidth insufficient.

---

## 7. BigQuery Data Transfer Service (BQDTS)

- Managed connectors:
  - Google Ads, Campaign Manager 360, Display & Video 360, Search Ads 360.
  - YouTube Analytics.
  - S3, Redshift, Azure Storage, Oracle, Teradata.
  - On-prem Teradata (via agent).
  - Salesforce (via partner connector).
- Scheduled recurrences, notifications, failure retry.

---

## 8. SAP migrations

- **SAP on Google Cloud**: certified VM families (M-series for HANA).
- **Google Cloud Migration Center** + **Migrate to VMs** for HANA / NetWeaver.
- **Bare Metal Solution** for largest HANA instances (>24 TB scale-out).
- **BigQuery Connector for SAP** for analytics.

---

## 9. Mainframe migrations

- **Dual Run / Google's G4 Mainframe**: on-prem emulation via Rocket or Micro Focus.
- Modernize via refactor to Java microservices on GKE with Pub/Sub bridging.
- Data offload to BigQuery for analytics; keep system of record until ready.

---

## 10. AWS / Azure → GCP

- **Cross-Cloud Interconnect** for private connectivity.
- **Storage Transfer Service** supports S3 and Azure Blob.
- **BigQuery Omni** can query data in S3/Azure without moving.
- **DMS** for RDS-based DBs → Cloud SQL.
- **Migrate to VMs** supports EC2 instances.

---

## 11. Validation and cutover techniques

- **Row counts + checksums** for DB migrations.
- **Dark launch** / **shadow traffic** (replay production traffic to new system; compare).
- **Canary** via global LB with weighted backends (old vs new).
- **DNS weighted / failover policies** for staged cutover.
- **Blue/green** at LB level with immediate rollback capability.

---

## 12. Post-migration optimization

- Cleanup: delete ephemeral staging resources, snapshots, leftover firewall rules.
- Rightsize: Active Assist recommendations.
- Modernize: move from GCE to Cloud SQL, GCS, Cloud Run as feasible.
- Observability: push Ops Agent to all VMs; establish SLOs.
- Cost reviews at Day 30 and Day 90.

---

## 13. Migration execution exam patterns

| Scenario | Tool |
| --- | --- |
| "Lift 300 VMware VMs to GCE" | Migrate to VMs |
| "Keep VMware stack as-is" | GCVE |
| "MySQL 8 to Cloud SQL near-zero downtime" | DMS continuous |
| "SQL Server on-prem → Cloud SQL" | DMS |
| "Oracle → BigQuery analytics" | Datastream |
| "Move 200 TB over a weekend, 1 Gbps" | Transfer Appliance (300 TB) |
| "Copy S3 bucket daily" | Storage Transfer Service job |
| "Oracle DB lift-and-shift" | BMS + VPN/Interconnect |
| "Mainframe data to analytics" | Mainframe connector → BigQuery |

Next: `04-cicd-pipelines.md`.
