# Service Deep Dive — VPC Networking

## Core concepts
- **Global** VPC; **regional** subnets.
- **Auto** (1 /20 subnet per region) vs **custom** (preferred).
- **Primary + secondary** IP ranges (for alias IPs / GKE pods/services).
- **Private Google Access** per subnet.
- **Flow logs** per subnet.
- **MTU 1460 / 1500 / 8896** (jumbo).

## Routes
- Default local route per subnet.
- Default 0.0.0.0/0 → Internet gateway.
- Static routes; dynamic via Cloud Router (BGP).

## Firewall rules
- Stateful; applied at VPC; targets by tag / SA / all.
- Priorities 0–65534 (lower first).
- **Hierarchical policies** at org/folder (enforced before VPC rules).
- **Network firewall policies** (global or regional) for easier management.

## Peering
- Non-transitive; no overlapping CIDRs.
- `import/export custom routes` toggles.

## Shared VPC
- Host project + service projects.
- Subnet-level `networkUser` for least privilege.
- Central network control.

## Private Service Access (PSA)
- VPC peering to producer tenant project (Google-managed).
- Used for Cloud SQL private IP, Memorystore, AlloyDB.

## Private Service Connect (PSC)
- Consumer endpoints / backends.
- Expose services without peering.
- Supports Google APIs (`*.googleapis.com` via PSC), published services.
- Global access option.

## Hybrid connectivity
- HA VPN (99.99% w/ two tunnels).
- Dedicated Interconnect (10 / 100 Gbps).
- Partner Interconnect (50 Mbps – 50 Gbps).
- Cross-Cloud Interconnect.
- **Network Connectivity Center** (hub-spoke at scale).

## Cloud NAT
- Managed SNAT for private VMs.
- Per region, auto-allocate or static IPs.
- `--min-ports-per-vm` tunable.

## Cloud Router
- BGP; advertises / learns routes for Interconnect & VPN.
- Custom advertisements.

## DNS (Cloud DNS)
- Public, private, forwarding, peering zones.
- DNSSEC.
- Inbound server policy (for on-prem to resolve private).
- Routing policies (geo / weighted / failover).

## IP addressing
- Ephemeral vs static; external vs internal.
- IPv6 supported in dual-stack subnets.

## Load balancers — see dedicated page.

## Limits
- 5 VPCs per project default (quota-raisable).
- 7000 VM instances per VPC default.
- 100 peerings per VPC.

## Exam cues
- VPC is global, subnet regional.
- Peering non-transitive → use NCC for hub-and-spoke.
- PSC replaces many peering use cases; better with VPC-SC.
- HA VPN needs two tunnels for 99.99%.
