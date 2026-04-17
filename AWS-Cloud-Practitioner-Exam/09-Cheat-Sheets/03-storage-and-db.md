# Storage & Database Comparison

## S3 storage classes

| Class | Access | Min | Min size | Best for |
|---|---|---|---|---|
| Standard | frequent | — | — | Active data |
| Intelligent-Tiering | mixed | 30 d | — | Unknown / changing |
| Standard-IA | infrequent | 30 d | 128 KB | Backups |
| One Zone-IA | infrequent, 1 AZ | 30 d | 128 KB | Re-creatable infrequent |
| Glacier Instant Retrieval | rare, immediate | 90 d | 128 KB | Archives needing occasional ms access |
| Glacier Flexible Retrieval | archive | 90 d | 40 KB | Backup / compliance |
| Glacier Deep Archive | long archive | 180 d | 40 KB | 7–10 yr retention |

## EBS types

| Type | Media | Typical use |
|---|---|---|
| gp3 | SSD | Default general purpose |
| gp2 | SSD | Legacy; IOPS tied to size |
| io2 / io2 BX | SSD prov. IOPS | Critical DB (BX for SAP HANA) |
| st1 | HDD throughput | Big sequential (logs, DW) |
| sc1 | HDD cold | Infrequent archive |

## File / hybrid

| Service | Protocol | Use |
|---|---|---|
| EFS | NFS | Linux shared file storage |
| FSx for Windows | SMB | Windows + AD |
| FSx for Lustre | Lustre | HPC/ML |
| FSx for NetApp ONTAP | NFS/SMB/iSCSI | Drop-in NetApp |
| FSx for OpenZFS | NFS | ZFS features |
| Storage Gateway (File/Vol/Tape) | NFS/SMB/iSCSI | Hybrid to S3/Glacier |

## Snow Family

| Device | Capacity | Compute |
|---|---|---|
| Snowcone | 8/14 TB | 2 vCPU |
| Snowball Edge Storage | 80 TB | 40 vCPU |
| Snowball Edge Compute | 42 TB + GPU | 104 vCPU + GPU |
| Snowmobile (retiring) | 100 PB | — |

## Database selection

| Need | Service |
|---|---|
| Managed relational (MySQL/PG/SQL/Oracle/MariaDB/Db2) | RDS |
| High-perf cloud-native relational | Aurora |
| Autoscaling relational | Aurora Serverless v2 |
| Multi-Region active relational | Aurora Global DB |
| KV/doc NoSQL any scale | DynamoDB (+DAX, Streams, PITR, Global Tables) |
| Cache in front of DB | ElastiCache (Redis/Memcached) |
| Durable in-memory primary | MemoryDB |
| Graph | Neptune |
| MongoDB | DocumentDB |
| Cassandra | Keyspaces |
| Time-series | Timestream |
| Ledger / verifiable | QLDB (deprecating) → Aurora PG w/ append-only |
| Data warehouse (PB-scale) | Redshift / Redshift Serverless |
| Ad-hoc SQL on S3 | Athena |
