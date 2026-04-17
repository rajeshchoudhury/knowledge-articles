# 1.3c Designing Network Architecture

GCP networking questions dominate the exam. Master VPC topology, hybrid connectivity, load balancing, and edge security.

---

## 1. VPC fundamentals

- **VPC is global**; subnets are **regional**. Resources in different zones of the same subnet can communicate privately.
- **Auto mode** VPC: creates one subnet per region, /20 each. Convenient but inflexible.
- **Custom mode** VPC: you define subnets and CIDRs. **Preferred** for enterprise.
- **IP ranges:** RFC1918 (10/8, 172.16/12, 192.168/16) plus 100.64/10. You can use non-RFC1918 (overlap with internet) at your own risk.
- **Routes:** every VPC has default routes (to internet via default gateway, to subnet ranges). Add static routes or dynamic via Cloud Router.
- **Firewall rules:** stateful, applied at the VPC level but target instances/tags/service accounts. Priority 0–65534, lower = higher.
- **Hierarchical firewall policies**: defined at org or folder; applied before VPC rules.
- **Network tags** vs **service accounts**: prefer SA-based rules (stronger binding).
- **MTU:** default 1460; up to **8896 (jumbo)** for supported configurations.
- **Flow Logs**: VPC flow logs per subnet; sample rate configurable; stream to Logging + BigQuery.
- **Packet Mirroring**: mirror traffic to collectors (Suricata, Zeek) on GCE.

### Private connectivity features

- **Private Google Access**: instances without external IPs can reach Google APIs (googleapis.com) via Google-owned IPs (199.36.153.4/30, 199.36.153.8/30).
- **Private Service Access (PSA)**: Google-managed services (Cloud SQL, Memorystore, AlloyDB) connect via VPC peering using reserved range.
- **Private Service Connect (PSC)**: expose services (Google APIs, 3rd-party SaaS, your own) on private IPs in your VPC — uniquely one-directional, no peering.
- **Private IPv6 Google Access** for v6 workloads.

---

## 2. Connecting VPCs

### Shared VPC

- One **host project** owns the VPC; **service projects** share subnets.
- Billing and quotas split by service project; **central networking team** controls network.
- Strongly recommended for large orgs; aligns with landing zones.

### VPC Peering

- Non-transitive (A↔B and B↔C does **not** give A↔C).
- No overlapping CIDRs.
- Per-peer routing, dynamic routes shared via Cloud Router.
- No egress charges between peered VPCs in same region; cross-region is billed like interconnect.

### Network Connectivity Center (NCC)

- Hub-and-spoke for **site-to-site** connectivity at scale.
- Spokes can be Interconnect, VPN, SD-WAN VM appliances, or VPCs (VPC spokes).
- Solves transitive routing at enterprise scale.

### Private Service Connect

- PSC endpoints or backends expose services in consumer VPCs.
- No peering, no CIDR conflicts.
- Endpoints have regional scope (but backends can be global with global-access).

---

## 3. Hybrid connectivity

| Option | Bandwidth | SLA | Use case |
| --- | --- | --- | --- |
| **Cloud VPN (classic)** | 1.5-3 Gbps per tunnel | 99.9% | Temporary / small |
| **Cloud HA VPN** | 3 Gbps per tunnel × multiple | 99.99% | Prod VPN |
| **Partner Interconnect** | 50 Mbps–50 Gbps | 99.9% or 99.99% | Via partner DC |
| **Dedicated Interconnect** | 10 Gbps (up to 200 Gbps) | 99.9% or 99.99% | Colocated DC |
| **Cross-Cloud Interconnect** | 10/100 Gbps | — | AWS/Azure/Oracle/Alibaba to GCP |

- For **99.99%** availability: **two Interconnects in two metros**, or **HA VPN** in two regions.
- **BGP** via **Cloud Router** carries dynamic routes; advertises Google and custom prefixes to peer.
- Use **MACsec** on Dedicated Interconnect for link-level encryption.

### VPN specifics

- HA VPN uses two external IPs; redundant tunnels.
- BGP sessions per tunnel.
- **Route-based VPN** preferred; policy-based largely deprecated.

### Deciding VPN vs Interconnect

- Under ~3 Gbps + not latency-critical → HA VPN.
- 10 Gbps+, latency-sensitive, SLA 99.99% → Dedicated Interconnect.
- Connects through a service provider's data center → Partner Interconnect.
- Cross-cloud to AWS/Azure → Cross-Cloud Interconnect or Partner Interconnect, avoid internet.

---

## 4. Load Balancing (LB)

GCP has two planes:

- **Global external** (HTTPS, TCP SSL proxy, TCP proxy) — one anycast VIP worldwide.
- **Regional external** (Network LB, regional ALB, classic network LB for TCP/UDP pass-through).
- **Internal** (ILB L4 for TCP/UDP, Internal HTTP(S) for L7) — private RFC1918 VIP.

### Quick matrix

| LB | OSI | Scope | Protocols | Backends | Key features |
| --- | --- | --- | --- | --- | --- |
| **Global External ALB (HTTPS LB)** | L7 | Global | HTTP/S, HTTP/2, gRPC | MIG, NEG, Cloud Run/App Engine/Functions, hybrid | URL maps, Armor, CDN, IAP |
| **Classic Application LB** | L7 | Global/regional | HTTP/S | — | legacy |
| **Regional External ALB** | L7 | Regional | HTTP/S | MIG, NEG | regional |
| **External Proxy Network LB** | L4 (proxy) | Global | TCP, SSL | — | TLS offload |
| **External passthrough Network LB** | L4 | Regional | TCP/UDP/ESP | MIG | source IP preserved |
| **Internal passthrough NLB** | L4 | Regional | TCP/UDP | MIG, unmanaged | RFC1918 VIP |
| **Internal ALB** | L7 | Regional or cross-region (preview) | HTTP/S | MIG, NEG, serverless NEG | routing / IAP for internal |

### Backend types (NEGs)

- **Instance group NEG** — GCE-based.
- **Zonal NEG** — IP:port targets, often used for GKE.
- **Serverless NEG** — Cloud Run / App Engine / Functions / API Gateway.
- **Internet NEG** — FQDN + port outside GCP.
- **Hybrid NEG** — on-prem via Interconnect/VPN; used with ALB to front hybrid services.

### Features to remember

- **Cloud CDN**: enabled per backend; key on URL + headers + cookies; pays via cache egress.
- **Cloud Armor**: WAF, OWASP rules, reCAPTCHA Enterprise, adaptive protection.
- **IAP**: authenticate users at LB level (Google Identity or external identity via Identity Platform).
- **Session affinity**: none / client IP / generated cookie / header field.
- **Connection draining** + health checks.
- **SSL policies**: min TLS, profile.
- **Traffic Director** for service-mesh data plane across VMs/GKE.

---

## 5. DNS — Cloud DNS

- **Public zones**: resolved on internet.
- **Private zones**: visible in specified VPCs.
- **Forwarding zones**: forward queries to on-prem or other networks.
- **Split-horizon**: public + private zone same name; internal clients get private IPs.
- **DNSSEC** for public zones.
- **Peering zones** for DNS across peered VPCs.
- **Cloud DNS** SLA 100% (the famous outlier).

---

## 6. Egress, NAT, and firewalls

- **Cloud NAT**: managed SNAT for private instances; per-region.
- **Firewall Insights**, **Network Intelligence Center** (Connectivity Tests, Performance Dashboard, Flow Analyzer).
- **Packet Mirroring** for IDS, compliance.
- **Cloud IDS**: managed Palo Alto-based threat detection via Packet Mirroring.

---

## 7. Organization-scope networking designs

### Hub-and-spoke via Shared VPC

- One **Host project** in an org with Shared VPC for prod, another for non-prod.
- BUs have **service projects** attached.
- Central security + networking team controls firewall policies and routing.

### Hub-and-spoke via NCC

- Multiple VPCs + hybrid sites as spokes.
- Solves need for transitive traffic across VPCs.

### Landing zone reference

- **Common** folder: shared services (DNS, monitoring, secrets).
- **Prod / Non-prod** folders with Shared VPCs.
- **Security** folder: logging sinks, SCC notifications.
- **Sandbox** folder: individual projects with quotas.

---

## 8. Security overlays

- **VPC Service Controls (VPC-SC)**: data perimeter around managed services (BQ, GCS, Spanner…). Prevents exfiltration across projects. Ingress/egress rules; dry-run mode.
- **Private Google Access** + **VPC-SC** + **DNS FQDNs** combined hide GCP APIs from public net.
- **Cloud Armor** at edge; **Cloud IDS** for east-west.
- **Firewall policies**: hierarchical (org/folder), network/regional-level, or VPC-level.
- **Network tags** still work but **service accounts** are preferred for identity-based rules.

---

## 9. Practical design patterns

### Internet-facing global web app

- Global External HTTPS LB + Cloud CDN + Cloud Armor + Managed TLS certs.
- Backends: regional MIGs or GKE zonal NEGs in 3 regions.
- DB: Spanner multi-region.
- DNS: Cloud DNS geo-routing (policy with record sets).

### Private internal API (org-wide)

- Internal Application LB + ILB-friendly MIG / zonal NEGs.
- Backed services via Private Service Connect.
- Service accounts for client identity.
- IAP for employee access if needed.

### Hybrid migration

- HA VPN pair for Day 1; Dedicated Interconnect 10 Gbps for production.
- Shared VPC host project; service projects per BU.
- Cloud Router advertises on-prem prefixes into VPC.
- Private DNS forwarding for on-prem domains.

### Multi-region DR

- Warm: regional MIGs in primary region; regional PD replicated to DR region via snapshots.
- Spanner multi-region (automatic) or Cloud SQL cross-region replica + promotion runbook.
- Global LB automatically shifts traffic; Cloud DNS policies as backup.

Next: `06-migration-planning.md`.
