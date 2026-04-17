# AWS Networking Cheat Sheet — SAP-C02

> Comprehensive networking reference covering VPC design through advanced hybrid connectivity, DNS, CDN, and security.

---

## Table of Contents

1. [VPC Design](#1-vpc-design)
2. [Route Tables](#2-route-tables)
3. [Security Groups vs NACLs](#3-security-groups-vs-nacls)
4. [NAT Gateway vs NAT Instance vs Egress-Only IGW](#4-nat-gateway-vs-nat-instance-vs-egress-only-igw)
5. [VPC Peering](#5-vpc-peering)
6. [Transit Gateway](#6-transit-gateway)
7. [Direct Connect](#7-direct-connect)
8. [Site-to-Site VPN](#8-site-to-site-vpn)
9. [VPC Endpoints](#9-vpc-endpoints)
10. [AWS PrivateLink](#10-aws-privatelink)
11. [Route 53](#11-route-53)
12. [CloudFront](#12-cloudfront)
13. [Global Accelerator vs CloudFront](#13-global-accelerator-vs-cloudfront)
14. [AWS Network Firewall, WAF, Shield](#14-aws-network-firewall-waf-shield)
15. [VPC Flow Logs & Traffic Mirroring](#15-vpc-flow-logs--traffic-mirroring)
16. [Network Analysis Tools](#16-network-analysis-tools)
17. [IPv6 Strategy](#17-ipv6-strategy)
18. [Important CIDR Ranges & Port Numbers](#18-important-cidr-ranges--port-numbers)

---

## 1. VPC Design

### CIDR Planning

- **VPC CIDR range:** /16 (65,536 IPs) to /28 (16 IPs)
- **Secondary CIDRs:** Up to 5 per VPC (soft limit, can be increased)
- **Best practice:** Use /16 for production VPCs to allow growth
- **Avoid overlapping CIDRs** if you plan to peer VPCs or connect via DX/VPN

#### Reserved IP Addresses per Subnet (5 reserved)

| Address | Purpose |
|---------|---------|
| x.x.x.**0** | Network address |
| x.x.x.**1** | VPC router |
| x.x.x.**2** | DNS server (VPC base + 2) |
| x.x.x.**3** | Reserved for future use |
| x.x.x.**255** | Broadcast (not supported, but reserved) |

**Example:** A /24 subnet (256 IPs) has 251 usable IPs.

#### RFC 1918 Private IP Ranges

| Range | CIDR | Addresses |
|-------|------|-----------|
| 10.0.0.0 – 10.255.255.255 | 10.0.0.0/8 | 16,777,216 |
| 172.16.0.0 – 172.31.255.255 | 172.16.0.0/12 | 1,048,576 |
| 192.168.0.0 – 192.168.255.255 | 192.168.0.0/16 | 65,536 |

AWS also allows 100.64.0.0/10 (CGNAT range) as secondary CIDR.

### Subnet Strategies

#### Three-Tier Subnet Architecture

```
VPC: 10.0.0.0/16
├── Public Subnets (10.0.0.0/20 per AZ)
│   ├── AZ-a: 10.0.0.0/20    (4,091 IPs)
│   ├── AZ-b: 10.0.16.0/20
│   └── AZ-c: 10.0.32.0/20
├── Private (Application) Subnets (10.0.48.0/20 per AZ)
│   ├── AZ-a: 10.0.48.0/20
│   ├── AZ-b: 10.0.64.0/20
│   └── AZ-c: 10.0.80.0/20
├── Private (Database) Subnets (10.0.96.0/20 per AZ)
│   ├── AZ-a: 10.0.96.0/20
│   ├── AZ-b: 10.0.112.0/20
│   └── AZ-c: 10.0.128.0/20
└── Spare space: 10.0.144.0/20+ (for future use)
```

#### Subnet Types

| Subnet Type | Route to Internet | NAT | Use Case |
|-------------|-------------------|-----|----------|
| **Public** | IGW (0.0.0.0/0 → igw) | N/A | ALB, bastion hosts, NAT Gateways |
| **Private with NAT** | NAT GW (0.0.0.0/0 → nat-gw) | Yes | App servers, containers needing outbound internet |
| **Isolated (no internet)** | No default route | No | Databases, internal services, VPC endpoints only |

### Multi-AZ Design

- Always use **at least 2 AZs** (3 recommended for production)
- Mirror subnet tiers across AZs
- Place NAT Gateways in each AZ for resilience
- Use AZ-specific route tables for proper NAT GW routing

### Multi-Region Design

- Separate VPCs per region (no VPC spanning regions)
- Use **Transit Gateway Inter-Region Peering** or **VPC Peering** for cross-region connectivity
- Non-overlapping CIDRs required for peering
- Use **Route 53** for DNS-based routing between regions
- Consider **Aurora Global Database** and **DynamoDB Global Tables** for data replication

---

## 2. Route Tables

### Main vs Custom Route Tables

| Feature | Main Route Table | Custom Route Table |
|---------|-----------------|-------------------|
| **Created** | Automatically with VPC | Manually |
| **Association** | Default for all subnets not explicitly associated | Explicitly associated with subnets |
| **Editable** | Yes | Yes |
| **Deletable** | No | Yes (if not associated) |

**Best practice:** Do NOT modify the main route table. Create custom route tables for each subnet tier.

### Route Priority — Longest Prefix Match

Routes are evaluated using **most specific route (longest prefix match)**:

```
10.0.0.0/16   → local     (VPC-internal traffic)
10.0.1.0/24   → pcx-123   (more specific → wins for 10.0.1.x)
0.0.0.0/0     → igw-456   (default route, least specific)
```

### Route Propagation

- **VGW (Virtual Private Gateway)** can propagate routes learned via BGP (from Direct Connect or VPN)
- **Transit Gateway** attachments can also propagate routes
- Propagated routes can be overridden by static routes
- Static routes always take priority over propagated routes with the same CIDR

### Common Route Table Entries

| Destination | Target | Purpose |
|-------------|--------|---------|
| 10.0.0.0/16 | local | Intra-VPC traffic |
| 0.0.0.0/0 | igw-xxx | Internet (public subnet) |
| 0.0.0.0/0 | nat-xxx | Internet via NAT (private subnet) |
| 10.1.0.0/16 | pcx-xxx | VPC peering |
| 10.2.0.0/16 | tgw-xxx | Transit Gateway |
| 172.16.0.0/12 | vgw-xxx | On-prem via DX/VPN |
| pl-xxx | vpce-xxx | S3/DynamoDB gateway endpoint |
| ::/0 | eigw-xxx | IPv6 egress-only |

---

## 3. Security Groups vs NACLs

### Comparison Table

| Feature | Security Groups | NACLs |
|---------|----------------|-------|
| **Level** | Instance/ENI level | Subnet level |
| **State** | **Stateful** (return traffic auto-allowed) | **Stateless** (must explicitly allow return traffic) |
| **Rules** | Allow rules only | Allow AND Deny rules |
| **Evaluation** | All rules evaluated together | Rules evaluated in order (lowest number first) |
| **Default** | Deny all inbound, allow all outbound | Allow all inbound and outbound (default NACL) |
| **Association** | Multiple SGs per ENI (up to 5) | One NACL per subnet |
| **Rule limit** | 60 inbound + 60 outbound per SG (default) | 20 rules per direction (default) |
| **Applies to** | Only instances assigned the SG | All instances in the subnet |
| **Self-referencing** | Yes (SG can reference itself) | No |

### Security Group Best Practices

- Use **SG referencing** instead of IP-based rules where possible (e.g., allow ALB SG → App SG)
- Create separate SGs per tier (ALB SG, App SG, DB SG)
- Minimize use of 0.0.0.0/0 in inbound rules
- Ephemeral ports NOT needed (stateful — return traffic automatic)

### NACL Best Practices

- Use NACLs as a **second layer of defense** (defense in depth)
- Must allow **ephemeral ports** (1024–65535) for return traffic
- Use numbered rules in increments of 100 (100, 200, 300...) for easy insertion
- Rule `*` (asterisk) is the default deny-all rule — evaluated last

### NACL Ephemeral Port Ranges

| OS/Client | Ephemeral Port Range |
|-----------|---------------------|
| Linux | 32768–60999 |
| Windows | 49152–65535 |
| ELB | 1024–65535 |
| NAT Gateway | 1024–65535 |
| Lambda | 1024–65535 |

**Safe rule:** Allow 1024–65535 for return traffic to cover all cases.

---

## 4. NAT Gateway vs NAT Instance vs Egress-Only IGW

| Feature | NAT Gateway | NAT Instance | Egress-Only IGW |
|---------|------------|-------------|-----------------|
| **Managed** | Yes (AWS managed) | No (you manage EC2) | Yes (AWS managed) |
| **Availability** | HA within AZ | Single instance (use ASG for HA) | HA (regional) |
| **Bandwidth** | 100 Gbps | Instance-type dependent | N/A |
| **Protocol** | IPv4 TCP, UDP, ICMP | IPv4 (can be configured for port forwarding) | IPv6 only |
| **Cost** | Per hour + per GB | EC2 instance cost | Free |
| **Security Groups** | No | Yes | No |
| **Bastion** | No | Yes (can combine) | No |
| **IP** | Elastic IP | Elastic IP | N/A |
| **Use case** | Production IPv4 NAT | Budget, port forwarding | IPv6 outbound from private subnets |

### NAT Gateway Architecture

- Deploy one NAT Gateway **per AZ** for high availability
- Each AZ's private route table points to its own NAT GW
- If a NAT GW's AZ goes down, instances in that AZ lose internet — no cross-AZ failover
- NAT GW uses an Elastic IP for outbound traffic

### NAT Gateway Limits

| Limit | Value |
|-------|-------|
| Bandwidth | 100 Gbps (scales from 5 Gbps) |
| Packets/second | 10 million |
| Connections to single destination | 55,000 (per destination IP:port) |
| Connections total | 900,000 |

---

## 5. VPC Peering

### Key Characteristics

- **Point-to-point** connection between exactly two VPCs
- **NO transitive routing** — if A peers with B and B peers with C, A cannot reach C through B
- Works **cross-account** and **cross-region**
- Traffic stays on AWS backbone (encrypted for cross-region)
- **No single point of failure, bandwidth bottleneck** — uses existing VPC infrastructure

### Limitations

| Limit | Value |
|-------|-------|
| Peering connections per VPC | 125 (soft limit, can request increase to 500+) |
| Outstanding peering requests | 25 |
| CIDR overlap | **Not allowed** (cannot peer VPCs with overlapping CIDRs) |

### Configuration Requirements

1. **Requester VPC** initiates peering request
2. **Accepter VPC** accepts the request
3. **Both VPCs** must update route tables to point to the peering connection
4. **Both VPCs** must update Security Groups/NACLs to allow traffic
5. **DNS resolution:** Enable "Allow DNS resolution from peer VPC" for private DNS

### VPC Peering vs Transit Gateway — When to Choose

| Scenario | Choice |
|----------|--------|
| 2–5 VPCs, simple connectivity | VPC Peering |
| 10+ VPCs, hub-and-spoke | Transit Gateway |
| Need transitive routing | Transit Gateway |
| Need lowest latency/highest throughput | VPC Peering |
| Need centralized routing control | Transit Gateway |
| Need on-prem connectivity hub | Transit Gateway |

---

## 6. Transit Gateway (TGW)

### Architecture

- **Regional** resource that acts as a hub for connecting VPCs and on-premises networks
- Supports **transitive routing** — any attachment can communicate with any other
- Supports up to **5,000 attachments** per TGW
- **50 Gbps** bandwidth per VPC attachment per AZ (per Availability Zone)

### TGW Attachment Types

| Attachment Type | Description |
|----------------|-------------|
| **VPC** | Connect a VPC to TGW |
| **VPN** | Connect Site-to-Site VPN to TGW |
| **Direct Connect Gateway** | Connect DX gateway to TGW (via transit VIF) |
| **TGW Peering** | Connect to another TGW (same or different region) |
| **Connect** | GRE tunnel for SD-WAN/third-party appliances |

### TGW Route Tables

- **Default route table:** Automatically associated with all attachments (if enabled)
- **Custom route tables:** Create separate routing domains (e.g., shared services, isolated workloads)
- **Associations:** Which attachments use which route table for outbound routing
- **Propagations:** Which attachments advertise their routes into which route table

#### Routing Domain Example: Shared Services Isolation

```
TGW Route Table: "shared-services"
├── Propagations: Shared VPC, VPN
├── Associations: All VPCs that need shared services
└── Routes: shared VPC CIDR, on-prem CIDR

TGW Route Table: "isolated"
├── Propagations: None (or only specific VPCs)
├── Associations: Isolated workload VPCs
└── Routes: Only shared VPC CIDR (no inter-VPC)
```

### TGW Advanced Features

| Feature | Description |
|---------|-------------|
| **Multicast** | TGW supports multicast routing (IGMP) — only networking service that does |
| **Inter-Region Peering** | Peer TGWs across regions (static routes, no route propagation) |
| **ECMP** | Equal-Cost Multi-Path routing over multiple VPN tunnels for aggregated bandwidth |
| **Appliance Mode** | Ensures symmetric routing through firewall appliances (flow stickiness to same AZ) |
| **Network Manager** | Centralized management and monitoring of TGW networks |
| **Route Analyzer** | Analyze and validate TGW routes |

### ECMP with VPN

- Each VPN connection has 2 tunnels (active/passive by default)
- With ECMP enabled on TGW, both tunnels become active-active
- Each tunnel supports ~1.25 Gbps → 2 tunnels = ~2.5 Gbps per VPN connection
- Multiple VPN connections can be aggregated: 4 VPN connections = ~10 Gbps

### TGW Limits

| Resource | Limit |
|----------|-------|
| TGWs per Region | 5 |
| Attachments per TGW | 5,000 |
| Route tables per TGW | 20 |
| Routes per route table | 10,000 (static), 5,000 (propagated) |
| Bandwidth per VPC attachment per AZ | 50 Gbps |
| Peered TGWs | 50 |

---

## 7. Direct Connect (DX)

### Connection Types

| Type | Bandwidth | Physical | Lead Time |
|------|-----------|----------|-----------|
| **Dedicated** | 1 Gbps, 10 Gbps, 100 Gbps | Your own port at DX location | Weeks–months |
| **Hosted** | 50 Mbps, 100 Mbps, 200 Mbps, 300 Mbps, 500 Mbps, 1 Gbps, 2 Gbps, 5 Gbps, 10 Gbps | Shared port via AWS Direct Connect Partner | Days–weeks |

### Virtual Interfaces (VIFs)

| VIF Type | Purpose | BGP | Connects To |
|----------|---------|-----|-------------|
| **Private VIF** | Access VPC resources | Private ASN | VGW (single VPC) or DX Gateway |
| **Public VIF** | Access AWS public services (S3, DynamoDB, etc.) | Public ASN | AWS public IP ranges |
| **Transit VIF** | Access VPCs via Transit Gateway | Private ASN | DX Gateway → TGW |

### DX Gateway

- **Regional resource** that can associate with VGWs or TGWs in **any region**
- A single DX Gateway can connect to up to **10 VGWs** or **3 Transit Gateways** (across regions)
- No data processing charge for DX Gateway
- Enables multi-region access from a single DX connection

### VIF Limits per Connection Type

| Connection | Private VIFs | Public VIFs | Transit VIFs |
|-----------|-------------|------------|-------------|
| **Dedicated (1/10/100 Gbps)** | 50 | 1 | 1 |
| **Hosted (sub-1G)** | 1 | 1 | 1 |
| **Hosted (1G+)** | 50 | 1 | 1 |

### LAG (Link Aggregation Group)

- Aggregate multiple DX connections into one logical connection
- All connections must be **same bandwidth** and terminate at **same DX location**
- Max **4 connections** per LAG (2 active minimum by default, configurable)
- Provides increased bandwidth and logical redundancy
- LACP (802.3ad) protocol

### MACsec Encryption

- Available on **10 Gbps and 100 Gbps dedicated connections**
- Layer 2 (hop-by-hop) encryption between your router and AWS DX device
- Uses AES-256-GCM (128-bit or 256-bit)
- Provides confidentiality, integrity, and authenticity
- **Alternative:** VPN overlay on public VIF for end-to-end encryption

### BGP for Direct Connect

- All DX connections require **BGP** (Border Gateway Protocol)
- **Private VIF:** Use private ASN (64512–65534 or 4200000000–4294967294)
- **Public VIF:** Must use public ASN (or AWS assigns one)
- BGP communities control route advertisement:
  - **7224:8100** — routes to same region as DX location
  - **7224:8200** — routes to same continent
  - **No community** — routes to all public regions

### DX Resiliency Models

| Level | Architecture | Description |
|-------|-------------|-------------|
| **Development** | 1 connection | Single DX, no redundancy |
| **Critical (Low)** | 2 connections at same DX location | Protects against device failure |
| **Critical (High)** | 2+ connections at **different DX locations** | Protects against location failure |
| **Maximum** | Dual connections at 2+ DX locations per DC | Protects against DC and location failures |

---

## 8. Site-to-Site VPN

### Architecture

```
On-Prem Router ──IPsec──> VPN Tunnel 1 ──> VGW / TGW
                ──IPsec──> VPN Tunnel 2 ──> VGW / TGW
```

- Each VPN connection = **2 tunnels** for redundancy (to different AZ endpoints on AWS side)
- Tunnels terminate at VGW (per VPC) or TGW (centralized)

### Static vs Dynamic (BGP)

| Feature | Static VPN | Dynamic (BGP) VPN |
|---------|-----------|-------------------|
| **Routing** | Static routes configured manually | BGP exchanges routes automatically |
| **Failover** | Manual route changes | Automatic BGP failover |
| **Redundancy** | Limited | Active/passive or active/active (with ECMP on TGW) |
| **Recommended** | Simple setups | Production environments |

### Accelerated VPN

- Uses **AWS Global Accelerator** network to route VPN traffic over the AWS backbone
- Reduces latency and jitter for VPN traffic
- Available for VPN connections to **Transit Gateway** only (not VGW)
- Additional cost for Global Accelerator

### VPN Bandwidth and Limits

| Metric | Value |
|--------|-------|
| Throughput per tunnel | Up to 1.25 Gbps |
| Tunnels per VPN connection | 2 |
| VPN connections per VGW | 10 |
| VPN connections per TGW | 5,000 (shared with other attachments) |

### Redundancy Patterns

1. **Single VPN:** 2 tunnels to one VGW (basic)
2. **Dual VPN:** 2 VPN connections from 2 customer gateways (HA)
3. **VPN + DX Backup:** DX primary, VPN failover via BGP preference
4. **VPN over DX Public VIF:** IPsec VPN tunneled over DX for encrypted private connection

### VPN CloudHub

- Hub-and-spoke model connecting multiple on-prem sites through AWS VGW
- Each site has its own VPN connection to the same VGW
- Sites can communicate through the VGW (transitive)
- Requires **BGP** and unique ASNs per site
- Low cost alternative to dedicated WAN

---

## 9. VPC Endpoints

### Gateway Endpoints

- **Services:** S3 and DynamoDB only
- **Mechanism:** Route table entry using prefix list
- **Cost:** Free (no hourly or data charges)
- **Endpoint policy:** Restrict which S3 buckets/DynamoDB tables can be accessed
- **Does NOT use PrivateLink**
- Cannot be extended out of VPC (not accessible from VPN, DX, or peered VPCs via TGW)

### Interface Endpoints

- **Services:** 100+ AWS services (and PrivateLink-powered third-party services)
- **Mechanism:** ENI with private IP placed in your subnet
- **Cost:** ~$0.01/hour per AZ + ~$0.01/GB processed
- **Endpoint policy:** Restrict API calls
- **Security Groups:** Can be attached to the endpoint ENI
- **Private DNS:** Optional — overrides public DNS to route through endpoint
- Can be accessed from on-prem via DX/VPN (when DNS is resolved properly)

### Endpoint Policies

```json
{
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::my-bucket/*"
    }
  ]
}
```

- Endpoint policies do **not** override IAM policies — both must allow the action
- Used for S3 gateway endpoints: restrict to specific buckets
- Used for interface endpoints: restrict which API calls are allowed

---

## 10. AWS PrivateLink

### Architecture

```
Consumer VPC                           Provider VPC
┌──────────────┐                    ┌──────────────────┐
│  Application  │                    │   NLB / GWLB     │
│      ↓        │                    │      ↓            │
│  Interface    │───PrivateLink────→│   Target Group    │
│  Endpoint     │    (AWS backbone)  │   (App instances) │
│  (ENI)        │                    │                   │
└──────────────┘                    └──────────────────┘
```

### Key Points

- Provider **must** expose service behind an **NLB** (or GWLB for appliances)
- Consumer creates an **Interface Endpoint** to connect
- Traffic flows over **AWS backbone** — never traverses public internet
- **Cross-account:** Yes (provider controls who can create endpoints via allow-listing)
- **Cross-region:** Yes (since 2022)
- **No CIDR overlap concerns** — uses ENI private IPs in consumer VPC
- **Unidirectional:** Consumer → Provider only

### PrivateLink vs VPC Peering

| Aspect | PrivateLink | VPC Peering |
|--------|------------|-------------|
| Direction | Unidirectional | Bidirectional |
| Scope | Specific service | Full VPC access |
| CIDR overlap | Allowed | Not allowed |
| Use case | SaaS, service exposure | Full network connectivity |

---

## 11. Route 53

### Routing Policies

| Policy | Description | Use Case | Health Check Support |
|--------|-------------|----------|---------------------|
| **Simple** | Single resource, random if multiple values | Default, single endpoint | No (multivalue answer for simple HA) |
| **Weighted** | Distribute traffic by weight (0–255) | A/B testing, gradual migration | Yes |
| **Latency** | Route to lowest-latency region | Multi-region deployments | Yes |
| **Failover** | Active/passive failover | DR, primary/secondary | Yes (required) |
| **Geolocation** | Route based on user's geographic location | Content localization, compliance | Yes |
| **Geoproximity** | Route based on proximity with bias | Shift traffic between regions with bias values | Yes |
| **Multivalue Answer** | Return up to 8 healthy records (random) | Simple load balancing with health checks | Yes |
| **IP-Based** | Route based on client's IP CIDR | ISP or enterprise-specific routing | Yes |

### Health Checks

| Type | What It Checks |
|------|---------------|
| **Endpoint** | HTTP/HTTPS/TCP to an IP or domain (every 10s or 30s) |
| **Calculated** | Combination of other health checks (AND/OR/threshold) |
| **CloudWatch Alarm** | Based on CloudWatch metric alarm state |

- Health checkers are globally distributed (~15 locations)
- Endpoint is considered healthy if ≥ 18% of checkers report healthy
- **String matching:** For HTTP/HTTPS, can check response body (first 5,120 bytes)
- Health checks can monitor **private resources** via CloudWatch Alarm health check

### DNSSEC

- Route 53 supports **DNSSEC signing** for public hosted zones
- Provides authentication that DNS responses haven't been tampered with
- Enable signing → Route 53 creates KSK (using KMS key) and ZSK
- You establish chain of trust by adding DS record in parent zone
- **Monitoring:** Use CloudWatch alarm on `DNSSECInternalFailure` and `DNSSECKeySigningKeysNeedingAction`

### Route 53 Resolver

| Component | Direction | Use Case |
|-----------|-----------|----------|
| **Inbound Endpoint** | On-prem → AWS | On-prem resolves AWS private hosted zones |
| **Outbound Endpoint** | AWS → On-prem | AWS resolves on-prem DNS names |
| **Resolver Rules** | Forward/System | Conditional forwarding (e.g., *.corp → on-prem DNS) |

- Endpoints require ENIs in VPC subnets (2 per endpoint minimum for HA)
- Rules can be shared across accounts via **RAM (Resource Access Manager)**
- **DNS Firewall:** Filter outbound DNS queries (allow/deny lists, managed domain lists)

### Route 53 Hosted Zones

| Type | Scope | Use Case |
|------|-------|----------|
| **Public** | Internet-facing | Public websites, APIs |
| **Private** | VPC-internal | Internal service discovery, split-horizon DNS |

- Private hosted zone can be associated with VPCs in **different accounts** (via CLI/API)
- Private hosted zone can be associated with VPCs in **different regions**

---

## 12. CloudFront

### Origins

| Origin Type | Description |
|-------------|-------------|
| **S3 bucket** | Static content, with OAC/OAI |
| **S3 website endpoint** | Static website hosting (HTTP only) |
| **ALB** | Dynamic content, web applications |
| **EC2** | Direct to instances (must be public) |
| **MediaStore / MediaPackage** | Video streaming |
| **Custom HTTP origin** | Any HTTP server (on-prem, other cloud) |
| **Lambda Function URL** | Serverless origin |
| **Origin Group** | Primary + failover origin (HA) |

### OAC vs OAI

| Feature | OAC (Origin Access Control) | OAI (Origin Access Identity) |
|---------|----------------------------|------------------------------|
| **Status** | Current recommended | Legacy |
| **SSE-KMS** | Supported | Not supported |
| **POST/PUT to S3** | Supported | Not supported |
| **All regions** | Yes | Yes |
| **S3 website endpoints** | No (use public access) | No |

### Cache Behaviors

- **Path patterns:** Match URL paths (e.g., `/images/*`, `/api/*`)
- **Default behavior:** Matches when no other path pattern matches
- **Per behavior settings:** TTL, caching policy, origin request policy, viewer protocol, allowed HTTP methods, Lambda@Edge/CF Functions

### Lambda@Edge vs CloudFront Functions

| Feature | Lambda@Edge | CloudFront Functions |
|---------|-------------|---------------------|
| **Runtime** | Node.js, Python | JavaScript only |
| **Execution location** | Regional edge caches (13 regions) | 200+ edge locations (closer to viewer) |
| **Triggers** | Viewer Request/Response, Origin Request/Response | Viewer Request, Viewer Response only |
| **Max execution time** | 5s (viewer), 30s (origin) | <1 ms |
| **Max memory** | 128 MB–10 GB | 2 MB |
| **Network access** | Yes | No |
| **File system** | Yes (/tmp 512 MB) | No |
| **Request body access** | Yes | No |
| **Cost** | Higher ($0.60/M requests + duration) | Lower ($0.10/M invocations) |
| **Scale** | 10,000s per second | Millions per second |
| **Use cases** | A/B testing, auth at origin, complex manipulation | URL rewrites, header manipulation, cache key normalization, simple auth (JWT validation) |

### CloudFront Signed URLs vs Signed Cookies

| Feature | Signed URL | Signed Cookie |
|---------|-----------|---------------|
| **Scope** | Single file | Multiple files (entire path/domain) |
| **Use case** | Individual file access (downloads, media) | Streaming site, premium content area |
| **Caching** | URL is unique per user → less cache hit | Same URL for all users → better caching |

### Field-Level Encryption

- Encrypt specific POST form fields at the edge
- Data stays encrypted through the application stack
- Only the final application with the private key can decrypt
- Up to 10 fields per request

---

## 13. Global Accelerator vs CloudFront

| Feature | Global Accelerator | CloudFront |
|---------|-------------------|------------|
| **Layer** | Layer 4 (TCP/UDP) | Layer 7 (HTTP/HTTPS) |
| **Protocols** | TCP, UDP | HTTP, HTTPS, WebSocket |
| **Static IPs** | 2 anycast IPs | No (use CNAME/alias) |
| **Caching** | No | Yes (edge caching) |
| **Content** | Non-HTTP (gaming, IoT, VoIP), or HTTP needing static IPs | HTTP content delivery, static/dynamic websites |
| **Health checks** | Endpoint health checks with instant failover | Origin health checks with origin failover |
| **DDoS protection** | Shield Standard (Shield Advanced available) | Shield Standard (Shield Advanced available) |
| **Edge processing** | No | Lambda@Edge, CloudFront Functions |
| **Pricing** | Fixed IP fee + per GB data transfer | Per request + per GB data transfer |
| **Use case** | Non-HTTP, multi-region TCP/UDP, static IPs, deterministic routing | Web apps, APIs, media streaming, static assets |

**Key insight for exam:** Use **CloudFront** for HTTP content delivery. Use **Global Accelerator** for non-HTTP protocols, static IPs, or TCP/UDP workloads with instant failover.

---

## 14. AWS Network Firewall, WAF, Shield

### AWS Network Firewall

- **VPC-level** stateful/stateless packet inspection
- Deployed in its own **firewall subnet** (one per AZ)
- Managed by **AWS Firewall Manager** across accounts

| Feature | Details |
|---------|---------|
| **Stateless rules** | 5-tuple match (src/dst IP, src/dst port, protocol), drop/allow/forward to stateful |
| **Stateful rules** | Suricata-compatible IPS rules, domain filtering, TLS/SNI inspection |
| **Domain filtering** | Allow/deny HTTP/HTTPS by domain name |
| **TLS inspection** | Decrypt and inspect TLS traffic (with certificate) |
| **Logging** | S3, CloudWatch Logs, Kinesis Data Firehose |
| **Use case** | VPC egress filtering, IDS/IPS, compliance, centralized firewall with TGW |

### Architecture with Transit Gateway

```
Internet → IGW → Firewall Subnet (Network Firewall) → TGW → Spoke VPCs
```

### WAF (Web Application Firewall)

- **Layer 7** protection for HTTP/HTTPS
- Attached to: CloudFront, ALB, API Gateway, AppSync, Cognito User Pool, App Runner, Verified Access
- **Web ACLs** contain rules evaluated in order (priority)
- **Rule types:** IP set, rate-based, regex, geo, SQL injection, XSS, size constraints, managed rules
- **Managed Rule Groups:** AWS-managed (Core Rule Set, Known Bad Inputs, SQL Database, etc.), Marketplace rules
- **Bot Control:** ML-based bot detection (targeted vs common)
- **Account Takeover Prevention (ATP):** Detects credential stuffing
- **Fraud Control:** Prevents fake account creation

### Shield

| Feature | Shield Standard | Shield Advanced |
|---------|----------------|-----------------|
| **Cost** | Free (automatic) | $3,000/month + DRT |
| **Protection** | Layer 3/4 DDoS | Layer 3/4/7 DDoS |
| **Resources** | All AWS resources | EC2, ELB, CloudFront, Global Accelerator, Route 53 |
| **Response Team** | No | AWS Shield Response Team (SRT) 24/7 |
| **Cost Protection** | No | DDoS cost protection (refund for scaling costs) |
| **Health-based** | No | Yes (health check-based detection for faster response) |
| **WAF included** | No | Yes (WAF charges waived for protected resources) |
| **Visibility** | Basic | Real-time metrics, attack forensics |
| **Proactive engagement** | No | Yes (SRT contacts you during attacks) |

---

## 15. VPC Flow Logs & Traffic Mirroring

### VPC Flow Logs

| Scope | Description |
|-------|-------------|
| **VPC** | All ENIs in the VPC |
| **Subnet** | All ENIs in the subnet |
| **ENI** | Single network interface |

- **Destinations:** CloudWatch Logs, S3, Kinesis Data Firehose
- **Default fields:** version, account-id, interface-id, srcaddr, dstaddr, srcport, dstport, protocol, packets, bytes, start, end, action, log-status
- **Custom fields:** vpc-id, subnet-id, instance-id, type, pkt-srcaddr, pkt-dstaddr, region, az-id, tcp-flags, traffic-path, flow-direction

### What Flow Logs Do NOT Capture

- DNS traffic to Amazon DNS (unless you use your own DNS server)
- Windows license activation traffic
- DHCP traffic
- Traffic to the reserved IP address for the default VPC router
- Traffic to/from 169.254.169.254 (instance metadata)
- Traffic to/from 169.254.169.123 (Amazon Time Sync Service)
- ARP traffic

### Traffic Mirroring

- Copy actual **packet-level data** from ENIs (not just metadata like Flow Logs)
- Mirror source → Filter → Mirror target (NLB, ENI, or GWLB)
- Use cases: network security monitoring, IDS/IPS, content inspection, troubleshooting
- **Supported instances:** Nitro-based instances only
- Can filter by direction (ingress/egress), protocol, port, CIDR

---

## 16. Network Analysis Tools

### Reachability Analyzer

- Analyzes network path between two endpoints (source → destination)
- Identifies reachable/unreachable and which component is blocking
- Checks: route tables, security groups, NACLs, VPC peering, Transit Gateway routes
- **Does NOT send actual packets** — performs configuration analysis
- Use case: "Why can't instance A reach instance B?" without sending test traffic

### Network Access Analyzer

- Identifies **unintended network access** (broader scope than Reachability Analyzer)
- Analyzes against Network Access Scope (defined trusted/untrusted paths)
- Finds: Internet access from private subnets, unexpected cross-VPC access, overly permissive SGs
- Use case: Compliance auditing, security posture assessment

### VPC Network Access Analyzer vs Reachability Analyzer

| Feature | Reachability Analyzer | Network Access Analyzer |
|---------|----------------------|------------------------|
| **Question** | "Can A reach B?" | "What can reach what?" |
| **Scope** | Single path | Entire VPC or Organization |
| **Use case** | Troubleshooting connectivity | Security/compliance auditing |
| **Method** | Path analysis | Network access scope analysis |

---

## 17. IPv6 Strategy

### IPv6 in AWS VPCs

- **Dual-stack:** VPC supports both IPv4 and IPv6 simultaneously
- IPv6 CIDR is assigned from Amazon's pool (or bring your own)
- All IPv6 addresses are **publicly routable** (no concept of "private" IPv6 in AWS)
- For IPv6-only subnets: instances get only IPv6 addresses + can use NAT64/DNS64

### Key IPv6 Components

| Component | IPv4 Equivalent | Purpose |
|-----------|-----------------|---------|
| **Internet Gateway** | Same | Bidirectional internet access (IPv4 + IPv6) |
| **Egress-Only IGW** | NAT Gateway (conceptually) | Outbound-only IPv6 internet access |
| **NAT64 / DNS64** | N/A | Enable IPv6-only instances to reach IPv4 services |

### IPv6 Exam Tips

- Security Groups and NACLs have **separate rules** for IPv4 and IPv6
- Route tables need **separate entries** for IPv6 (::/0 → igw or eigw)
- **S3, DynamoDB** support dual-stack endpoints
- **Not all AWS services** support IPv6 yet — check per service
- **Egress-Only IGW** = NAT Gateway equivalent for IPv6 (stateful, outbound only, free)

---

## 18. Important CIDR Ranges & Port Numbers

### AWS-Specific CIDR Ranges

| CIDR | Purpose |
|------|---------|
| 169.254.169.254/32 | Instance Metadata Service (IMDS) |
| 169.254.169.123/32 | Amazon Time Sync Service |
| 169.254.0.0/16 | Link-local addresses (general) |
| 100.64.0.0/10 | Carrier-grade NAT (usable as secondary VPC CIDR) |
| 10.0.0.0/8 | RFC 1918 private |
| 172.16.0.0/12 | RFC 1918 private |
| 192.168.0.0/16 | RFC 1918 private |
| fd00::/8 | IPv6 ULA (not used in AWS VPCs) |

### Common Port Numbers

| Port | Protocol/Service |
|------|-----------------|
| 22 | SSH |
| 25 | SMTP |
| 53 | DNS (TCP/UDP) |
| 80 | HTTP |
| 110 | POP3 |
| 143 | IMAP |
| 443 | HTTPS |
| 465 | SMTP over SSL |
| 587 | SMTP (submission) |
| 993 | IMAPS |
| 995 | POP3S |
| 1433 | Microsoft SQL Server |
| 1521 | Oracle |
| 2049 | NFS |
| 3306 | MySQL / Aurora |
| 3389 | RDP (Remote Desktop) |
| 5432 | PostgreSQL |
| 5439 | Redshift |
| 6379 | Redis |
| 8080 | HTTP alternative |
| 8443 | HTTPS alternative |
| 9092 | Apache Kafka |
| 11211 | Memcached |
| 27017 | MongoDB / DocumentDB |

### BGP ASN Ranges

| Range | Type |
|-------|------|
| 1–64511 | Public ASNs |
| 64512–65534 | 16-bit Private ASNs |
| 4200000000–4294967294 | 32-bit Private ASNs |
| AWS Default ASN (TGW) | 64512 |
| AWS Default ASN (VGW) | Assigned or configurable |

### Direct Connect Bandwidth Options

| Connection Type | Available Bandwidths |
|----------------|---------------------|
| Dedicated | 1 Gbps, 10 Gbps, 100 Gbps |
| Hosted | 50 Mbps, 100 Mbps, 200 Mbps, 300 Mbps, 500 Mbps, 1 Gbps, 2 Gbps, 5 Gbps, 10 Gbps |

### VPN Bandwidth

| Resource | Bandwidth |
|----------|-----------|
| Single VPN Tunnel | Up to 1.25 Gbps |
| VPN Connection (2 tunnels, ECMP on TGW) | Up to 2.5 Gbps |

---

## Networking Architecture Patterns (Exam Favorites)

### Pattern 1: Centralized Egress via Transit Gateway

```
Spoke VPCs → TGW → Egress VPC (NAT GW + Internet GW) → Internet
```
- Single point of egress for all VPCs
- Centralized firewall inspection possible

### Pattern 2: Centralized Ingress with GWLB

```
Internet → ALB → GWLB Endpoint → Security Appliances → GWLB → Application
```
- Third-party firewall/IDS inspection for inbound traffic

### Pattern 3: Hybrid DNS Resolution

```
On-prem DNS ←→ Route 53 Resolver (Inbound/Outbound Endpoints) ←→ Private Hosted Zones
```
- Bidirectional DNS resolution between on-prem and AWS

### Pattern 4: Multi-Region Active-Active

```
Users → Route 53 (Latency/Weighted) → Region A (ALB + App + Aurora Global Primary)
                                     → Region B (ALB + App + Aurora Global Secondary)
```
- Global Accelerator can replace Route 53 for static IP + faster failover

### Pattern 5: Highly Resilient Hybrid Connectivity

```
On-prem DC1 → DX Connection 1 (DX Location A) → DX Gateway → TGW
On-prem DC2 → DX Connection 2 (DX Location B) → DX Gateway → TGW
On-prem DC1 → VPN (backup) → TGW
```
- Maximum resiliency pattern per AWS DX best practices
