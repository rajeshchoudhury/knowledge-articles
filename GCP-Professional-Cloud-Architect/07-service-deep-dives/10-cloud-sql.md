# Service Deep Dive — Cloud SQL & AlloyDB

## Cloud SQL
- MySQL, PostgreSQL, SQL Server.
- Up to ~128 vCPU, 864 GB RAM, 64 TB storage.
- **HA** (regional): primary + standby in separate zones with sync replication; 99.95% SLA.
- **Read replicas**: async; in-region or cross-region.
- **Backups**: automatic daily + on-demand; PITR up to 35d (default 7d).
- **Maintenance windows** required.
- **Private IP** via Private Service Access (producer VPC peering).
- **Cloud SQL Auth Proxy** for IAM/TLS auth.
- **Connection** via language connectors (Java, Python, Go, Node).
- **IAM database authentication** for MySQL/PG.
- **Query Insights** / slow query log / pg_stat_statements.
- **CMEK** + TLS default.
- **External replicas** (on-prem Postgres → Cloud SQL).
- **Database Migration Service** integration.

### Exam cues
- HA = regional; read replicas != HA by themselves (promote is manual).
- Use cross-region replica for DR.
- Enforce `require-ssl`, disable public IP via org policy.

## AlloyDB (for PostgreSQL)
- Enterprise Postgres with columnar accelerator.
- **Clusters** → **primary** instance + **read-pool** instances.
- Up to 96 vCPU, 768 GB; cross-region replication.
- Up to 100× faster analytics, 4× transaction vs stock PG.
- CMEK, Private Service Connect.
- **AlloyDB Omni** runs anywhere (on-prem / other clouds).

### Compared to Cloud SQL PG
| Feature | Cloud SQL | AlloyDB |
| --- | --- | --- |
| Analytics | moderate | fast (columnar) |
| HA SLA | 99.95% | 99.99% |
| Scale reads | replicas | read pool clusters |
| Price | $ | $$ |

## Spanner vs Cloud SQL vs AlloyDB
- **Cloud SQL**: small/medium OLTP, classic Postgres features.
- **AlloyDB**: large Postgres / modernizing Oracle workloads, HTAP.
- **Spanner**: global, horizontally scalable, mission-critical.
