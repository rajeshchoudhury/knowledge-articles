# Service Deep Dive — Persistent Disks, Hyperdisk, Filestore

## Persistent Disks (PD)

- **Types**: PD-standard (HDD), PD-balanced (cost/perf SSD), PD-SSD, PD-Extreme (high IOPS).
- **Zonal** (one zone) vs **Regional** (sync replica in 2 zones).
- Max size: up to 64 TB (varies by type).
- **Snapshots**: incremental, global, encrypted.
- **Machine images**: boot + data + metadata.
- **Resize**: grow online, not shrink.
- **Attach** to multiple VMs in **read-only** mode possible.

## Hyperdisk

- Newer; decouples IOPS / throughput from size.
- Types: **Balanced**, **Throughput**, **Extreme**, **ML**.
- Available with C3, N4, Z3, A3, etc.
- Hyperdisk Throughput for analytics; ML for AI accelerators.

## Local SSD

- Ephemeral; 375 GB NVMe per disk.
- Max 9 TB per VM (24 × 375 GB on supported VM types).
- Data lost on stop/host maintenance.

## Filestore

- Managed NFSv3.
- Tiers: **Basic HDD / SSD**, **Zonal**, **Enterprise (regional)**, **High Scale**.
- Size: 1 TB – 100 TB (High Scale).
- Backups (GCS) + snapshots (built-in).
- CMEK supported.
- No SMB / NFSv4.

### Use cases
- Legacy apps expecting POSIX.
- Media rendering, HPC scratch.
- Shared config / assets for fleets.

## Storage for databases
- Use **PD-SSD** or **Hyperdisk Extreme** for high-IOPS DBs.
- Regional PD for HA single-instance DBs.
- Consider managed services (Cloud SQL / Spanner / Bigtable) before self-managing.

## Exam cues
- Regional PD for HA across 2 zones.
- Local SSD for scratch only.
- Filestore Enterprise for regional NFS HA.
- Hyperdisk when IOPS > PD-SSD capacity.
