# Service Deep Dive — Compute Engine (GCE)

## Overview
Google-managed IaaS offering custom / predefined VMs with per-second billing.

## Families (memorize)
- **E2** — cost-optimized, shared core available.
- **N1 / N2 / N2D / N4** — general.
- **C3 / C3D** — latest-gen general / CPU intensive (Intel Sapphire Rapids / AMD EPYC Genoa).
- **Tau T2A (Arm) / T2D (AMD)** — price-performance, scale-out web.
- **C2 / C2D** — compute optimized.
- **M1 / M2 / M3** — memory optimized (up to 12 TB RAM for SAP HANA).
- **A2 (A100) / A3 (H100)** — GPU.
- **G2 (L4)** — inference / graphics.
- **Z3** — storage-optimized (SSD).

## Disks
- **PD-standard / balanced / SSD / extreme**; **Hyperdisk** (decoupled IOPS/throughput).
- **Regional PD** (sync across 2 zones in region).
- **Local SSD** (ephemeral NVMe).
- Snapshots (global, incremental).
- Machine images (boot + data + metadata).

## Pricing levers
- Sustained-use discount (auto).
- Committed-use discount (1y/3y; resource or spend).
- Flex CUD (cross-region / family).
- Spot VMs (60–91% off).
- Sole-tenant (BYOL, compliance).
- Reservations (capacity guarantee).

## Managed Instance Groups (MIG)
- Template → MIG (zonal or regional).
- Autoscaling signals: CPU, HTTP LB serving capacity, Pub/Sub queue length, custom metric, schedule.
- Autohealing with health checks.
- Rolling updates (`maxSurge`, `maxUnavailable`), canary via **dual-version**.
- Stateful MIGs preserve names/disks.

## Identity & security
- Shielded VM (secure boot + vTPM + integrity).
- Confidential VMs (encrypted memory, AMD SEV/TDX).
- OS Login for SSH via IAM.
- IAP TCP tunneling instead of public IPs.
- Dedicated service account per workload; no default compute SA with Editor.

## Networking
- Primary + secondary IP ranges per subnet; alias IPs.
- Internal TCP/UDP LB / Internal HTTP(S) LB.
- External IP (ephemeral / static); egress tier (Premium / Standard).
- Cloud NAT for egress w/o external IP.

## Limits (typical; check docs)
- 128 vCPU on N2; 240 on C3/M3; 416 on M3 ultra.
- Up to 257 TB PD per VM (certain families).
- 64 network interfaces (nic0-7 by default; more with special quotas).

## Exam cues
- 99.5% SLA single-VM; 99.99% MIG cross-zone.
- Use MIG + regional for HA.
- Prefer Cloud Run / GKE before GCE unless legacy.
