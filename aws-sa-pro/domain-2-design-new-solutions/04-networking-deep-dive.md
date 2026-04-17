# Domain 2 – Design for New Solutions: Networking Deep Dive

## AWS Certified Solutions Architect – Professional (SAP-C02)

---

## Table of Contents

1. [VPC Architecture Patterns](#1-vpc-architecture-patterns)
2. [Advanced VPC Design](#2-advanced-vpc-design)
3. [Subnet Design Strategies](#3-subnet-design-strategies)
4. [Advanced Routing](#4-advanced-routing)
5. [Transit Gateway Advanced](#5-transit-gateway-advanced)
6. [Direct Connect Advanced](#6-direct-connect-advanced)
7. [VPN Advanced](#7-vpn-advanced)
8. [AWS PrivateLink](#8-aws-privatelink)
9. [VPC Endpoints](#9-vpc-endpoints)
10. [Route 53 Advanced](#10-route-53-advanced)
11. [CloudFront Advanced](#11-cloudfront-advanced)
12. [Global Accelerator](#12-global-accelerator)
13. [Network Firewall Advanced](#13-network-firewall-advanced)
14. [WAF Advanced](#14-waf-advanced)
15. [Shield Advanced](#15-shield-advanced)
16. [Traffic Mirroring](#16-traffic-mirroring)
17. [Reachability Analyzer and Network Access Analyzer](#17-reachability-analyzer-and-network-access-analyzer)
18. [VPC Lattice](#18-vpc-lattice)
19. [Exam Scenarios](#19-exam-scenarios)

---

## 1. VPC Architecture Patterns

### Multi-Tier Architecture

```
Internet
    │
    ▼
┌─────────────────────────────────────────────────┐
│ Public Subnet (Web Tier)                         │
│ [ALB] → [Web Servers in ASG]                     │
│ NAT Gateway                                      │
├─────────────────────────────────────────────────┤
│ Private Subnet (Application Tier)                │
│ [App Servers in ASG]                             │
├─────────────────────────────────────────────────┤
│ Private Subnet (Database Tier)                   │
│ [RDS Multi-AZ] [ElastiCache]                     │
├─────────────────────────────────────────────────┤
│ Isolated Subnet (no internet access)             │
│ [Sensitive workloads, batch processing]          │
└─────────────────────────────────────────────────┘
```

### Multi-AZ Architecture

- Deploy resources across at least 2 AZs (3 recommended)
- Each AZ has its own public, private, and isolated subnets
- ALB/NLB spans AZs automatically
- NAT Gateway per AZ for high availability

```
AZ-1                          AZ-2                          AZ-3
┌──────────────┐             ┌──────────────┐             ┌──────────────┐
│Public Subnet │             │Public Subnet │             │Public Subnet │
│ NAT-GW-1     │             │ NAT-GW-2     │             │ NAT-GW-3     │
├──────────────┤             ├──────────────┤             ├──────────────┤
│Private Subnet│             │Private Subnet│             │Private Subnet│
│ App Servers  │             │ App Servers  │             │ App Servers  │
├──────────────┤             ├──────────────┤             ├──────────────┤
│Data Subnet   │             │Data Subnet   │             │Data Subnet   │
│ RDS Primary  │             │ RDS Standby  │             │ Aurora Replica│
└──────────────┘             └──────────────┘             └──────────────┘
         └──────────────────ALB spans all AZs──────────────────┘
```

### Multi-Region Architecture

- Active-Active: Traffic served from multiple regions simultaneously
- Active-Passive: Primary region handles traffic, secondary for DR
- Use Route 53 for global routing (latency, failover, geolocation)
- Data replication: Aurora Global DB, DynamoDB Global Tables, S3 CRR

---

## 2. Advanced VPC Design

### Secondary CIDRs

- Add up to 5 IPv4 CIDR blocks per VPC (soft limit, extendable)
- Use case: Expand VPC address space without recreating
- CIDRs cannot overlap with existing CIDRs or peered VPCs
- Can associate IPv6 CIDR blocks

### Amazon VPC IPAM (IP Address Manager)

- Plan, track, and monitor IP addresses across AWS and on-premises
- Features:
  - **Pools:** Define IP address ranges hierarchically
  - **Scopes:** Public and private scopes for organization
  - **Automatic allocation:** Allocate CIDRs to VPCs from pools
  - **Compliance monitoring:** Detect overlapping CIDRs, unused allocations
  - **Integration with Organizations:** Manage IP addresses across all accounts

```
IPAM Hierarchy:
  Regional Pool (10.0.0.0/8)
  ├── Production Pool (10.1.0.0/16)
  │   ├── VPC-Prod-East (10.1.0.0/20) — auto-allocated
  │   └── VPC-Prod-West (10.1.16.0/20) — auto-allocated
  └── Development Pool (10.2.0.0/16)
      └── VPC-Dev-East (10.2.0.0/20)
```

### BYOIPv4 and IPv6

**Bring Your Own IP (BYOIP):**
- Use your own public IPv4/IPv6 addresses in AWS
- Must be registered with Regional Internet Registry (RIR)
- Create Route Origin Authorization (ROA)
- Minimum /24 for IPv4, /48 for IPv6
- Use case: IP reputation, established firewall rules, customer whitelisting

### IPv6 in VPC

- Dual-stack: IPv4 + IPv6 simultaneously
- IPv6 CIDRs are public by default (but controlled by security groups/NACLs)
- Egress-only Internet Gateway: Allows IPv6 outbound only (equivalent of NAT for IPv6)
- Not all services support IPv6 (check per service)

---

## 3. Subnet Design Strategies

### Subnet Types

| Type | Internet Access | Route | Use Case |
|------|----------------|-------|----------|
| Public | Inbound + Outbound | Route to IGW | ALB, NAT GW, bastion hosts |
| Private | Outbound only (via NAT) | Route to NAT GW | App servers, databases |
| Isolated | None | No internet route | Sensitive data processing |
| VPN-only | On-premises only | Route to VGW | Hybrid workloads |

### CIDR Planning Best Practices

- Use /16 for VPC (65,536 IPs) for maximum flexibility
- Use /24 for subnets (251 usable IPs after AWS-reserved 5)
- Reserve spare subnets for future use
- Avoid overlapping with on-premises or other VPCs
- Plan for Transit Gateway (non-overlapping across all connected VPCs)

**AWS reserves 5 IPs per subnet:**
- .0: Network address
- .1: VPC router
- .2: DNS server
- .3: Reserved for future use
- .255: Broadcast (not supported, but reserved)

### Subnet Sizing for Common Services

| Service | Recommendation |
|---------|---------------|
| NAT Gateway | Small subnet (/28), one per AZ |
| ELB | At least /27 per AZ (8+ free IPs) |
| Lambda (VPC) | Large subnet (/19 or bigger) — ENIs scale with concurrency |
| EKS | Large subnets for pods (/18 or bigger with custom CNI) |

---

## 4. Advanced Routing

### Route Table Evaluation

1. **Longest prefix match:** Most specific route wins
2. **Local route:** VPC CIDR always takes precedence (highest priority)
3. **Propagated routes vs static routes:** Static routes take precedence
4. **Same prefix length:** Static > Propagated; then DX > Static VPN > BGP VPN

```
Route Table Evaluation Order:
1. Local route (VPC CIDR) — always highest priority
2. Most specific route (longest prefix match)
3. Static routes over propagated routes
4. For propagated routes with same prefix:
   Direct Connect BGP > Static VPN > Dynamic VPN (BGP)
```

### Route Priority Example

```
Destination     Target          Type          Wins?
10.0.0.0/16     local           Local         ✓ (VPC traffic, always wins)
10.1.0.0/24     pcx-123         Static        ✓ (more specific than /16 below)
10.1.0.0/16     vgw-456         Propagated    Only for 10.1.x.x not matching /24
0.0.0.0/0       nat-789         Static        Default route for everything else
```

### More Specific Routes

- Use more specific routes to override less specific ones
- Example: Route specific prefixes through VPN, everything else through NAT

```
0.0.0.0/0       → NAT Gateway (internet access)
10.0.0.0/8      → Transit Gateway (on-premises networks)
10.1.2.0/24     → VPC Peering (specific VPC)
```

### Ingress Routing

- Route table associated with IGW or VGW
- Inspect inbound traffic before it reaches instances
- Use with Gateway Load Balancer for inline inspection

```
Internet → IGW → Ingress Route Table → GWLB Endpoint → Firewall → Application
```

---

## 5. Transit Gateway Advanced

### Overview

- Regional hub for connecting VPCs, VPN, and Direct Connect
- Supports transitive routing (VPC-A → TGW → VPC-B)
- Scales to thousands of connections
- Up to 5,000 attachments per TGW

### Architecture

```
                        ┌─────────────────┐
                        │ Transit Gateway  │
                        │  (Regional Hub)  │
                        └────────┬────────┘
              ┌──────────────────┼──────────────────┐
              ▼                  ▼                   ▼
        ┌──────────┐     ┌──────────┐        ┌──────────┐
        │  VPC-A   │     │  VPC-B   │        │ VPN/DX   │
        │ 10.1.0/16│     │ 10.2.0/16│        │ On-prem  │
        └──────────┘     └──────────┘        └──────────┘
```

### Routing Domains (Route Tables)

- Multiple route tables for network segmentation
- Each attachment associated with ONE route table
- Route propagation: Attachments propagate routes to associated route table
- Route association: Determines which route table is used for routing

**Shared Services Pattern:**

```
TGW Route Table: "Shared"
  Associations: Shared-VPC
  Propagations: All VPCs

TGW Route Table: "Prod"
  Associations: Prod-VPC-1, Prod-VPC-2
  Propagations: Shared-VPC, On-Premises
  (Prod VPCs can reach shared and on-prem, but NOT dev)

TGW Route Table: "Dev"
  Associations: Dev-VPC-1, Dev-VPC-2
  Propagations: Shared-VPC
  (Dev VPCs can reach shared, but NOT prod or on-prem)
```

### Blackhole Routes

- Drop traffic matching specific prefixes
- Use case: Prevent routing between isolated segments

```
TGW Route Table: "Isolated"
  10.1.0.0/16 → blackhole  (block traffic to VPC-A)
  10.2.0.0/16 → Attachment-B (allow traffic to VPC-B)
```

### Multicast

- TGW supports multicast routing (only AWS service that does)
- Create multicast domains
- Register sources and group members
- Use case: Financial trading, video distribution, multiplayer gaming

### Connect Attachments

- GRE tunnel from SD-WAN/third-party appliance to Transit Gateway
- Higher bandwidth than VPN (up to 20 Gbps per Connect attachment)
- Supports BGP for dynamic routing
- Use case: Connect SD-WAN appliances, third-party networking equipment

### Transit Gateway Peering

- Connect TGWs across regions (inter-region peering)
- Static routing between peered TGWs
- Encrypted over AWS backbone
- Use case: Multi-region transit architecture

```
US-EAST-1 TGW ←── Inter-Region Peering ──→ EU-WEST-1 TGW
    │                                            │
    ├── VPC-A                                    ├── VPC-C
    ├── VPC-B                                    ├── VPC-D
    └── On-Prem (DX)                             └── On-Prem (DX)
```

### Transit Gateway vs VPC Peering

| Feature | Transit Gateway | VPC Peering |
|---------|----------------|-------------|
| Transitive routing | Yes | No |
| Max connections | 5,000 per TGW | 125 per VPC |
| Bandwidth | Up to 50 Gbps per AZ | No limit (within VPC limits) |
| Cost | Per attachment + per GB | Per GB (no attachment fee) |
| Cross-region | Yes (peering) | Yes |
| Use case | Hub-spoke, complex routing | Simple point-to-point |

> **Exam Tip:** TGW for complex, multi-VPC architectures with transitive routing. VPC Peering for simple, high-bandwidth point-to-point connections. TGW route tables for network segmentation. TGW peering for multi-region.

---

## 6. Direct Connect Advanced

### Resiliency Models

**Maximum Resiliency (recommended for critical workloads):**
- Separate connections at separate DX locations
- Each location has redundant connections
- Protects against: Device failure, connectivity failure, complete location failure

```
On-Premises
    ├── DX Location 1 ── Connection A ──→ AWS
    ├── DX Location 1 ── Connection B ──→ AWS
    ├── DX Location 2 ── Connection C ──→ AWS
    └── DX Location 2 ── Connection D ──→ AWS
```

**High Resiliency:**
- Redundant connections at a single DX location
- Protects against: Device failure, connectivity failure
- Does NOT protect against: Complete location failure

```
On-Premises
    ├── DX Location 1 ── Connection A ──→ AWS
    └── DX Location 1 ── Connection B ──→ AWS
```

**Development/Test (non-critical):**
- Single connection at one location
- No redundancy

### Link Aggregation Groups (LAG)

- Bundle multiple DX connections into a single logical connection
- All connections must be same bandwidth and terminate at same DX location
- Uses LACP (Link Aggregation Control Protocol)
- Max 4 connections per LAG
- Minimum links threshold: Set minimum active connections before LAG goes down

### Bidirectional Forwarding Detection (BFD)

- Rapid failure detection on DX connections
- Detects link failures in milliseconds (vs BGP which takes 90 seconds)
- Recommended for all DX connections
- Enable BFD on both AWS and on-premises router

### MACsec (Media Access Control Security)

- Layer 2 encryption on DX connections
- Point-to-point encryption between your router and AWS DX device
- Available on 10 Gbps and 100 Gbps dedicated connections
- No bandwidth overhead (unlike IPsec VPN over DX)
- Requires MACsec-capable router

### Jumbo Frames

- MTU up to 9001 bytes (vs standard 1500 bytes)
- Supported on: Private VIF (VPC), Transit VIF (TGW)
- NOT supported on: Public VIF
- Reduces overhead for large data transfers

### Direct Connect Gateway

- Global resource that connects DX to multiple VPCs in any Region
- One DX Gateway can connect to:
  - Up to 10 Virtual Private Gateways (VGWs) — any Region
  - Up to 3 Transit Gateways — different Regions

```
On-Premises ── DX Connection ── DX Gateway ──┬── VGW (us-east-1 VPC)
                                              ├── VGW (eu-west-1 VPC)
                                              └── TGW (ap-southeast-1)
```

### DX Gateway + Transit Gateway Association

- Connect DX to TGW via DX Gateway
- Allows DX to reach all VPCs connected to TGW
- Transit VIF → DX Gateway → TGW → VPCs

**Allowed Prefixes:**
- You MUST configure allowed prefixes on the DX Gateway → TGW association
- Controls which routes are advertised from AWS to on-premises
- Without allowed prefixes, NO routes are advertised

### Virtual Interfaces (VIFs)

| VIF Type | Purpose | Connection To |
|----------|---------|--------------|
| Private VIF | Access VPC private IPs | VGW or DX Gateway |
| Public VIF | Access AWS public services (S3, DynamoDB, etc.) | AWS public endpoints |
| Transit VIF | Access VPCs via Transit Gateway | DX Gateway → TGW |

### DX Connection Types

| Type | Bandwidth | Lead Time |
|------|-----------|-----------|
| Dedicated | 1, 10, 100 Gbps | Weeks-months |
| Hosted | 50 Mbps to 10 Gbps | Days-weeks (via partner) |

> **Exam Tip:** Maximum resiliency = 2 DX locations × 2 connections each. LAG for bundling connections at same location. MACsec for Layer 2 encryption (no bandwidth overhead). DX Gateway for multi-region access. Transit VIF for TGW integration. Always configure allowed prefixes on DX Gateway → TGW.

---

## 7. VPN Advanced

### Site-to-Site VPN

- Encrypted IPsec tunnels over the public internet
- Each VPN connection has 2 tunnels (for redundancy, in different AZs)
- Bandwidth: Up to 1.25 Gbps per tunnel
- Terminates on VGW or TGW

### Dual Tunnel Architecture

```
On-Premises Router ──── Tunnel 1 (AZ-1) ──→ VGW/TGW
                   └─── Tunnel 2 (AZ-2) ──→ VGW/TGW

Both tunnels active: ECMP (Equal-Cost Multi-Path) on TGW
                     Active/Passive on VGW
```

**With TGW:** ECMP enabled — traffic load-balanced across tunnels (up to 2.5 Gbps per VPN connection)
**With VGW:** Only one tunnel active at a time (1.25 Gbps max)

### Accelerated VPN

- VPN tunnels route through AWS Global Accelerator network
- Traffic enters the nearest AWS edge location and travels the AWS backbone
- Improves performance for long-distance VPN connections
- Only available with Transit Gateway (not VGW)

```
Standard VPN:    On-Prem ──── Public Internet ────→ AWS TGW
Accelerated VPN: On-Prem ──── Internet ──→ Edge Location ── AWS Backbone ──→ AWS TGW
```

### VPN CloudHub

- Hub-and-spoke VPN architecture
- Multiple customer gateways connected to a single VGW
- Sites communicate through AWS VPN hub
- Low cost but limited to VPN bandwidth

```
Branch 1 (CGW) ──VPN──→         ┌─────┐
Branch 2 (CGW) ──VPN──→         │ VGW │
Branch 3 (CGW) ──VPN──→         └─────┘
(All branches can communicate through VGW hub)
```

### Certificate-Based Authentication

- Use private certificates from ACM Private CA
- Alternative to pre-shared keys (PSK)
- More secure for large-scale deployments
- Certificates rotated via ACM

### VPN over Direct Connect

- Use public VIF to access AWS VPN endpoints
- Adds encryption to DX connection (DX is not encrypted by default)
- Use case: Compliance requiring encryption in transit
- Bandwidth limited to VPN throughput (1.25 Gbps per tunnel)

> **Exam Tip:** TGW + VPN enables ECMP (2.5 Gbps). Accelerated VPN for long-distance performance. VPN CloudHub for branch office connectivity. VPN over DX for encryption on DX.

---

## 8. AWS PrivateLink

### Overview

- Private connectivity between VPCs and services without public internet
- Traffic stays on the AWS network
- No VPC peering, VPN, TGW, or internet gateway needed

### Endpoint Services (Provider Side)

- Service provider creates an endpoint service backed by NLB or GWLB
- Provider approves/rejects connection requests from consumers
- Provider can restrict by AWS account or Organization

### VPC Endpoints (Consumer Side)

- Consumer creates an interface VPC endpoint (ENI) in their VPC
- Private IP address assigned in consumer's subnet
- DNS name provided for the endpoint

### Architecture

```
Service Provider Account            Service Consumer Account
┌─────────────────────┐            ┌─────────────────────┐
│  Application Fleet  │            │  Client Application │
│       │              │            │       │              │
│  ┌────▼────┐        │            │  ┌────▼────────┐    │
│  │   NLB   │        │◄──────────►│  │VPC Endpoint │    │
│  └─────────┘        │ PrivateLink│  │  (ENI)       │    │
│  (Endpoint Service) │            │  └──────────────┘    │
└─────────────────────┘            └─────────────────────┘
```

### Cross-Account Access

- Provider whitelists consumer account IDs
- Consumer creates VPC endpoint and requests connection
- Provider approves the connection

### Cross-Region via TGW Peering

- PrivateLink endpoints are regional
- For cross-region access: Create proxy in each region or use TGW peering
- TGW peering allows routing to PrivateLink endpoint in another region

### Key Characteristics

- Scales automatically (no bandwidth limit)
- Security group on VPC endpoint ENI
- Private DNS names (optional, requires domain verification)
- Supports TCP only (not UDP)
- Up to 1,000 endpoint services per Region

> **Exam Tip:** "Expose service to other VPCs/accounts without peering" → PrivateLink (NLB + Endpoint Service). "Access AWS services privately" → Interface VPC Endpoint (PrivateLink). PrivateLink is TCP only.

---

## 9. VPC Endpoints

### Gateway Endpoints

- For S3 and DynamoDB only
- Route table entry (prefix list)
- Free of charge
- Cannot be accessed from on-premises (from outside the VPC)
- Endpoint policies to control access

```
Private Subnet → Route Table
  pl-12345 (S3 prefix list) → vpce-gateway-xxx
```

### Interface Endpoints

- For 100+ AWS services
- ENI in your subnet with private IP
- Powered by AWS PrivateLink
- Costs: Per hour + per GB
- Security group attached
- Can be accessed from on-premises via DX/VPN

```
Private Subnet → ENI (10.0.1.50) → PrivateLink → AWS Service
On-Premises → DX/VPN → ENI (10.0.1.50) → PrivateLink → AWS Service
```

### Endpoint Policies

- IAM resource policy attached to the endpoint
- Controls which AWS resources can be accessed through the endpoint
- Works with both Gateway and Interface endpoints

```json
{
  "Statement": [
    {
      "Sid": "AllowSpecificBucket",
      "Effect": "Allow",
      "Principal": "*",
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Resource": "arn:aws:s3:::my-approved-bucket/*"
    }
  ]
}
```

### Gateway vs Interface Endpoint for S3

| Feature | Gateway Endpoint | Interface Endpoint |
|---------|-----------------|-------------------|
| Cost | Free | Per hour + per GB |
| Access from on-prem | No | Yes (via DX/VPN) |
| DNS | No change | Private DNS available |
| Security | Endpoint policy + route table | Endpoint policy + security group |
| Use case | Standard S3 access from VPC | S3 from on-premises, need private DNS |

> **Exam Tip:** Use Gateway Endpoint for S3/DynamoDB access within VPC (free). Use Interface Endpoint when you need on-premises access to S3 via DX/VPN, or need security group control.

---

## 10. Route 53 Advanced

### Routing Policies

| Policy | Description | Use Case |
|--------|-------------|----------|
| Simple | Single resource, no health check | Basic routing |
| Weighted | Distribute traffic by weight (0-255) | A/B testing, gradual migration |
| Latency | Route to lowest-latency region | Global applications |
| Failover | Active-passive DR | Disaster recovery |
| Geolocation | Route by user's geographic location | Content localization, compliance |
| Geoproximity | Route by geographic proximity with bias | Shift traffic between regions |
| Multivalue Answer | Return multiple healthy records | Basic load balancing |
| IP-based | Route by source IP (CIDR blocks) | Specific ISP/network routing |

### Health Checks

**Endpoint health checks:**
- Monitor an endpoint (IP or domain)
- HTTP, HTTPS, TCP
- Configure: Interval (10 or 30 sec), failure threshold (1-10), regions

**Calculated health checks:**
- Combine multiple health checks with AND, OR, or threshold logic
- Example: Healthy if 2 out of 3 child checks are healthy

**CloudWatch alarm health checks:**
- Health check status based on CloudWatch alarm state
- Use case: Monitor custom metrics (DynamoDB throttles, Lambda errors)
- Useful for private resources (health checkers can't reach private IPs)

### Alias Records

- Route 53 extension to DNS
- Map domain name to AWS resources (ALB, CloudFront, S3 website, API Gateway, etc.)
- Free of charge (no query charges for alias to AWS resources)
- Native health check integration
- Cannot set TTL (uses resource's TTL)

**Alias targets:**
- CloudFront distribution
- Elastic Load Balancer
- API Gateway
- S3 website endpoint
- VPC endpoint
- Another Route 53 record in the same hosted zone
- Global Accelerator
- Elastic Beanstalk environment
- NOT: EC2 instance IP, RDS endpoint

### Traffic Flow

- Visual editor for complex routing configurations
- Create traffic policies with combinations of routing rules
- Versioned policies (rollback capability)
- Reusable across hosted zones

### DNSSEC

- DNS Security Extensions
- Cryptographic signing of DNS records
- Protects against DNS spoofing/cache poisoning
- Route 53 supports DNSSEC signing for public hosted zones
- Uses KMS asymmetric key for signing

### Route 53 Resolver

**DNS resolution between VPC and on-premises:**

**Inbound Endpoint:**
- On-premises DNS resolvers forward queries to Route 53 Resolver
- Resolves AWS-hosted private DNS names from on-premises

**Outbound Endpoint:**
- Route 53 Resolver forwards queries to on-premises DNS
- Conditional forwarding rules (forward specific domains)

```
On-Premises DNS ──→ Inbound Endpoint ──→ Route 53 Resolver (resolve AWS names)
Route 53 Resolver ──→ Outbound Endpoint ──→ On-Premises DNS (resolve corp names)
```

### DNS Firewall

- Filter and regulate outbound DNS traffic from VPC
- Block domains (malware, phishing, data exfiltration prevention)
- Allow lists and deny lists
- Managed domain lists (AWS-curated threat intelligence)
- Action: ALLOW, BLOCK (return NXDOMAIN, NODATA, or custom response), ALERT

### Resolver Query Logging

- Log all DNS queries from VPCs
- Send to: CloudWatch Logs, S3, Kinesis Data Firehose
- Use case: Security investigation, compliance, troubleshooting

### Route 53 Application Recovery Controller (ARC)

- Manage application recovery across Regions and AZs
- **Readiness checks:** Verify resources are ready for failover
- **Routing controls:** Manual switches for DNS failover
- **Safety rules:** Prevent misconfiguration (e.g., don't disable all cells)

```
ARC Architecture:
┌─────────────────┐     ┌──────────────────┐
│ US-East-1 Cell  │     │ EU-West-1 Cell   │
│ (Active)        │     │ (Standby)        │
│                 │     │                  │
│ Readiness Check │     │ Readiness Check  │
│ ✓ RDS           │     │ ✓ RDS            │
│ ✓ ASG           │     │ ✓ ASG            │
│ ✓ ALB           │     │ ✓ ALB            │
└────────┬────────┘     └────────┬─────────┘
         │ Routing Control: ON   │ Routing Control: OFF
         └───────┬───────────────┘
                 │
         Route 53 Health Checks
```

> **Exam Tip:** Geolocation = legal/compliance (serve specific content by country). Geoproximity = shift traffic with bias values. Latency = best performance. Failover = active-passive DR. ARC for multi-region recovery management. DNS Firewall for domain filtering.

---

## 11. CloudFront Advanced

### Origins

| Origin Type | Configuration |
|-------------|---------------|
| S3 bucket | OAC (recommended) or OAI for private access |
| ALB/NLB | Public DNS name, custom headers for security |
| EC2 | Public IP required |
| API Gateway | Regional or edge-optimized endpoint |
| MediaStore | Container endpoint |
| Custom HTTP server | Any publicly accessible HTTP endpoint |
| Lambda Function URL | Direct Lambda invocation |

### Origin Access Control (OAC) vs Origin Access Identity (OAI)

| Feature | OAC (Recommended) | OAI (Legacy) |
|---------|-------------------|-------------|
| SSE-KMS support | Yes | No |
| Dynamic requests (PUT/DELETE) | Yes | No |
| S3 Object Lambda | Yes | No |
| All S3 regions | Yes | Limited |
| Signed requests | SigV4 | Custom |

### Behaviors

- Match URL path patterns to origin configurations
- Precedence: More specific paths take priority
- Configure per behavior: Cache policy, origin request policy, response headers policy, function associations

```
CloudFront Distribution:
  Behavior 1: /api/*      → ALB Origin (no cache, forward all headers)
  Behavior 2: /images/*   → S3 Origin (cache 1 year, compress)
  Behavior 3: /static/*   → S3 Origin (cache 1 day, compress)
  Behavior 4: /*  (default)→ ALB Origin (cache based on query strings)
```

### Cache Policies

- Control what's included in the cache key
- Headers, cookies, query strings included in cache key create more cache variations
- Minimize cache key components for better hit ratio

**Managed cache policies:**
- CachingOptimized: Minimum TTL 1 day, no headers/cookies/query strings
- CachingDisabled: TTL 0, pass everything through
- CachingOptimizedForUncompressedObjects: Like optimized without compression

### Origin Request Policies

- Control what's forwarded to origin (independent of cache key)
- Forward headers, cookies, query strings that origin needs but shouldn't be in cache key

### Lambda@Edge vs CloudFront Functions

| Feature | Lambda@Edge | CloudFront Functions |
|---------|------------|---------------------|
| Runtime | Node.js, Python | JavaScript only |
| Execution time | Up to 30 sec (origin) / 5 sec (viewer) | < 1 ms |
| Memory | 128–10,240 MB | 2 MB |
| Network access | Yes | No |
| File system access | Yes | No |
| Request body access | Yes | No |
| Triggers | Viewer request/response, Origin request/response | Viewer request/response only |
| Price | Higher | 1/6th of Lambda@Edge |
| Scale | Thousands/sec | Millions/sec |

**Use cases for Lambda@Edge:**
- Complex logic, external API calls
- Modify request body
- Access to origin request/response events
- A/B testing with backend calls

**Use cases for CloudFront Functions:**
- Header manipulation
- URL rewrite/redirect
- Cache key normalization
- JWT token validation (lightweight)
- Geo-based routing

### Field-Level Encryption

- Encrypt specific POST fields at the edge
- Data encrypted at edge, decrypted only by authorized services
- Adds encryption layer on top of HTTPS
- Use case: Protect sensitive fields (credit card, SSN) across the entire stack

### Signed URLs vs Signed Cookies

| Feature | Signed URLs | Signed Cookies |
|---------|------------|----------------|
| Scope | Single file | Multiple files |
| URL change | Yes (new URL) | No (same URL) |
| Use case | Individual file downloads | Entire website/streaming |
| RTMP | Supported (legacy) | Not supported |

**Choosing between them:**
- One file → Signed URL
- Multiple files / entire directory → Signed Cookies
- Need to maintain existing URLs → Signed Cookies

### Real-Time Logs

- Log every request in real-time to Kinesis Data Streams
- Sampling rate configurable (1-100%)
- Use for: Real-time monitoring, anomaly detection, custom dashboards

### WebSocket Support

- Native WebSocket support
- Persistent connections routed to origin
- Use case: Chat, real-time collaboration, live updates

> **Exam Tip:** OAC is the recommended origin access method for S3 (not OAI). CloudFront Functions for simple viewer-side logic (lightweight, fast, cheap). Lambda@Edge for complex logic needing network access or origin-side processing. Signed URLs for individual files, Signed Cookies for multiple files.

---

## 12. Global Accelerator

### Architecture

- Routes traffic through AWS global network via 2 static anycast IPs
- Traffic enters the nearest edge location and travels the AWS backbone
- Improves availability and performance for global applications

```
User (Tokyo) ──→ AWS Edge (Tokyo) ══ AWS Backbone ══→ ALB (us-east-1)
                                                    → ALB (eu-west-1)
User (NYC) ───→ AWS Edge (NYC) ════ AWS Backbone ══→ ALB (us-east-1)
```

### Endpoint Groups

- One endpoint group per Region
- Traffic dial: Control percentage of traffic to each Region (0-100%)
- Health checks per endpoint group

### Endpoints

- ALB, NLB, EC2 instances, Elastic IP addresses
- Weights per endpoint (0-255)
- Health checks at endpoint level

### Client Affinity

- None (default): Round-robin across healthy endpoints
- Source IP: Same client always routed to same endpoint

### Custom Routing Accelerator

- Map users to specific EC2 instances/ports
- Deterministic routing based on client IP/port
- Use case: Gaming (map players to specific game servers), VoIP

### Global Accelerator vs CloudFront

| Feature | Global Accelerator | CloudFront |
|---------|-------------------|------------|
| Layer | Layer 4 (TCP/UDP) | Layer 7 (HTTP/HTTPS) |
| Static IPs | Yes (2 anycast) | No |
| Caching | No | Yes |
| Protocol | TCP, UDP | HTTP, HTTPS, WebSocket |
| Use case | Non-HTTP (gaming, IoT, VoIP), static IPs needed | HTTP content delivery, caching |
| DDoS protection | Shield Standard included | Shield Standard included |
| Health checks | Yes (automatic failover) | Origin health checks |

> **Exam Tip:** Need static IPs for global app → Global Accelerator. Need caching → CloudFront. Non-HTTP protocols → Global Accelerator. Both use AWS edge network. Often used together: Global Accelerator → ALB → backend.

---

## 13. Network Firewall Advanced

### Overview

- Managed network firewall for VPC
- Stateful and stateless inspection
- Intrusion prevention (IPS), deep packet inspection

### Rule Types

**Stateless rules:**
- Evaluate each packet independently (no connection tracking)
- 5-tuple matching (source/dest IP, source/dest port, protocol)
- Actions: Pass, Drop, Forward to stateful rule engine
- Evaluated in priority order

**Stateful rules:**
- Track connections (like security groups)
- Suricata-compatible rules (IPS signatures)
- Domain name filtering (allow/deny lists)
- Five rule group types:
  - **5-tuple:** Match based on protocol, source/dest IP, source/dest port, direction
  - **Domain list:** Allow/block specific domains (HTTP Host, TLS SNI)
  - **Suricata-compatible IPS rules:** Full IPS signature support

### TLS Inspection

- Decrypt, inspect, and re-encrypt TLS traffic
- Uses ACM certificate for decryption
- Inspects encrypted traffic for threats
- Re-encrypts before forwarding to destination

### Centralized Deployment Model

```
                    ┌───────────────────────┐
                    │  Inspection VPC        │
                    │  ┌─────────────────┐  │
                    │  │Network Firewall │  │
                    │  │  Endpoints      │  │
                    │  └────────┬────────┘  │
                    │           │            │
                    └───────────┼────────────┘
                    ┌───────────┼────────────┐
                    │   Transit Gateway      │
                    └───────────┼────────────┘
              ┌─────────────────┼─────────────────┐
         ┌────┴────┐      ┌────┴────┐       ┌────┴────┐
         │ VPC-A   │      │ VPC-B   │       │ VPC-C   │
         │(Spoke)  │      │(Spoke)  │       │(Spoke)  │
         └─────────┘      └─────────┘       └─────────┘
```

- All inter-VPC and internet traffic routed through Inspection VPC
- Network Firewall inspects all traffic
- TGW route tables direct traffic through firewall endpoints

### Logging

- Flow logs: Metadata about accepted/dropped traffic
- Alert logs: Events matching stateful rules
- Destinations: S3, CloudWatch Logs, Kinesis Data Firehose

> **Exam Tip:** Network Firewall for deep packet inspection, IPS, domain filtering. Centralize with TGW + Inspection VPC. Suricata rules for IPS. TLS inspection for encrypted traffic. Different from NACL/Security Groups — operates at VPC perimeter with DPI.

---

## 14. WAF Advanced

### Overview

- Web Application Firewall for Layer 7 protection
- Protects: ALB, API Gateway, CloudFront, AppSync, Cognito, App Runner, Verified Access

### Rule Types

**Managed Rules (AWS and Marketplace):**
- AWS Managed Rules: AmazonIPReputationList, CommonRuleSet, SQLiRuleSet, etc.
- Marketplace rules: Fortinet, F5, Trend Micro
- Updated automatically by providers

**Custom Rules:**
- Match conditions: IP set, string match, size constraint, geo match, regex, SQL injection, XSS
- Logical operators: AND, OR, NOT
- Actions: Allow, Block, Count, CAPTCHA, Challenge

**Rate-Based Rules:**
- Count requests from a single IP over 5 minutes
- Threshold: 100-20,000,000 requests
- Auto-blocks IPs exceeding threshold
- Use case: DDoS protection, brute force prevention, API rate limiting

### Bot Control

- Managed rule group for bot management
- Common bot protection: Block known bots, verify good bots
- Targeted bot protection: ML-based detection of advanced bots
- Challenge actions: CAPTCHA, silent challenge

### Fraud Control — Account Takeover Prevention (ATP)

- Detect and prevent credential stuffing and account takeover
- Inspects login requests
- Checks stolen credential databases
- Anomaly detection for login patterns

### Fraud Control — Account Creation Fraud Prevention (ACFP)

- Detect and prevent fake account creation
- Inspect registration requests
- Check for known fraud patterns

### Cross-Account Management

- AWS Firewall Manager for centralized WAF management across Organization
- Deploy WAF rules to all accounts/resources automatically
- Ensure compliance (audit non-compliant resources)

### Web ACL Capacity Units (WCU)

- Each rule consumes WCU based on complexity
- Default maximum: 5,000 WCU per Web ACL
- Simple rules: 1 WCU; Regex: 25 WCU; Rate-based: 2 WCU

> **Exam Tip:** WAF for L7 protection (SQL injection, XSS, bots). Rate-based rules for API throttling. Firewall Manager for org-wide WAF deployment. Bot Control for bot management. WAF attached to ALB, CloudFront, API Gateway.

---

## 15. Shield Advanced

### Overview

- Enhanced DDoS protection (Layer 3, 4, and 7)
- $3,000/month per organization (committed annually)
- Protects: EC2, ELB, CloudFront, Global Accelerator, Route 53

### Key Features

**DDoS Response Team (DRT):**
- 24/7 access to AWS DDoS experts
- DRT can create WAF rules on your behalf during attacks
- Proactive engagement: DRT contacts you during detected events

**Cost Protection:**
- AWS credits for charges resulting from DDoS attacks
- Covers: EC2 scaling, CloudFront, ALB, Route 53, Global Accelerator
- Must file within 15 days of billing cycle

**Proactive Engagement:**
- DRT proactively contacts you when health checks indicate impact
- Requires Route 53 health checks associated with Shield Advanced protections
- DRT engages before you even know there's an attack

**Health-Based Detection:**
- Uses Route 53 health check status to improve detection
- More accurate DDoS detection based on application health
- Reduces false positives

**Automatic Application Layer DDoS Mitigation:**
- Automatically creates, evaluates, and deploys WAF rules
- Responds to detected L7 DDoS attacks
- Rules automatically removed when attack subsides

### Shield Advanced vs Shield Standard

| Feature | Shield Standard | Shield Advanced |
|---------|----------------|----------------|
| Cost | Free | $3,000/month |
| DDoS protection | L3/L4 | L3/L4/L7 |
| DRT access | No | Yes |
| Cost protection | No | Yes |
| Attack visibility | Basic | Advanced metrics/reports |
| WAF integration | Manual | Automatic L7 mitigation |
| Proactive engagement | No | Yes |

> **Exam Tip:** Shield Advanced when you need DRT support, cost protection, or automated L7 DDoS mitigation. Always associate Route 53 health checks for health-based detection. WAF is separate but complementary.

---

## 16. Traffic Mirroring

### Overview

- Copy network traffic from ENI of EC2 instances
- Send to security/monitoring appliances for analysis
- Non-intrusive (doesn't affect source instance performance meaningfully)

### Architecture

```
Source (EC2 ENI) ──mirror──→ Traffic Mirror Target
                              ├── ENI (single instance)
                              ├── NLB (fleet of analyzers)
                              └── GWLB endpoint

Filter: Source/dest IP, port, protocol, direction (in/out)
```

### Components

- **Mirror Source:** ENI of an EC2 instance (Nitro-based)
- **Mirror Target:** ENI, NLB, or GWLB endpoint
- **Mirror Filter:** Define which traffic to capture (like VPC Flow Log filters)
- **Mirror Session:** Links source to target with filter and optional packet truncation

### Use Cases

- Network security monitoring (IDS)
- Threat detection and forensics
- Application performance analysis
- Compliance monitoring

---

## 17. Reachability Analyzer and Network Access Analyzer

### VPC Reachability Analyzer

- Analyzes network path between two resources
- Identifies connectivity issues without sending packets
- Checks: Route tables, NACLs, security groups, VPC peering, TGW routes, etc.
- Produces hop-by-hop analysis showing where connectivity fails

**Use cases:**
- Troubleshoot connectivity issues
- Verify security configurations
- Validate network changes before deployment

### Network Access Analyzer

- Identifies unintended network access
- Analyzes network access scope (what CAN be reached)
- Predefined or custom access scopes
- Highlights: Internet access, cross-VPC access, resources accessible from on-premises

**Use cases:**
- Security audit
- Compliance verification
- Identify overly permissive security group rules

---

## 18. VPC Lattice

### Overview

- Application networking service for service-to-service communication
- Simplifies service discovery, connectivity, traffic management, and access control
- Works across VPCs and accounts

### Architecture

```
┌──────────────────────────────────────────┐
│              Service Network              │
│   (Logical boundary for services)         │
│                                          │
│  ┌────────┐  ┌────────┐  ┌────────┐    │
│  │Service │  │Service │  │Service │    │
│  │  A     │  │  B     │  │  C     │    │
│  │(Lambda)│  │(ECS)   │  │(EC2)   │    │
│  └────────┘  └────────┘  └────────┘    │
│                                          │
│  Routing: Path-based, weighted           │
│  Auth: IAM, None                         │
└──────────────────────────────────────────┘
```

### Components

- **Service Network:** Logical boundary grouping services
- **Service:** Represents an application (Lambda, ECS, EKS, EC2 instances)
- **Target Group:** Group of compute targets (instances, IPs, Lambda, ALB)
- **Listener:** Entry point with protocol/port
- **Rules:** Routing rules (path-based, header-based)

### Key Features

- **Cross-VPC/Cross-Account:** Services in different VPCs and accounts can communicate
- **Weighted routing:** Traffic splitting for canary/blue-green deployments
- **IAM auth policies:** Control which services can communicate
- **Observability:** Built-in access logs to S3, CloudWatch, Firehose
- **No VPC peering or TGW required:** Lattice handles connectivity

### Use Cases

- Microservices communication across VPCs
- Service mesh alternative (without sidecar proxies)
- Multi-account service-to-service connectivity
- Gradual traffic shifting between service versions

> **Exam Tip:** VPC Lattice simplifies service-to-service networking across VPCs/accounts. Replaces complex TGW/peering setups for application networking. Think of it as "ALB for microservices across VPCs."

---

## 19. Exam Scenarios

### Network Design Decision Framework

```
Connectivity Requirement → Solution
│
├─ VPC to VPC (few) → VPC Peering
├─ VPC to VPC (many, transitive) → Transit Gateway
├─ VPC to On-Premises → Site-to-Site VPN or Direct Connect
├─ VPC to AWS Service (private) → VPC Endpoint (Gateway or Interface)
├─ Service to Service (cross-VPC) → VPC Lattice or PrivateLink
├─ Expose service to consumers → PrivateLink (NLB + Endpoint Service)
├─ Global content delivery → CloudFront
├─ Global TCP/UDP performance → Global Accelerator
├─ DNS routing → Route 53
├─ DDoS protection → Shield + WAF + CloudFront
├─ Network inspection → Network Firewall + GWLB
└─ Traffic analysis → Traffic Mirroring + VPC Flow Logs
```

### Common Exam Scenarios

**Scenario 1: "Company has 200 VPCs across 5 accounts that need to communicate with each other and on-premises."**
→ Transit Gateway with multiple route tables for segmentation. DX with Transit VIF through DX Gateway for on-premises connectivity.

**Scenario 2: "Application needs to be served globally with lowest latency for HTTP content."**
→ CloudFront with multiple origins. Route 53 latency routing to regional ALBs as failover.

**Scenario 3: "On-premises application needs private access to S3 without internet."**
→ DX or VPN → Interface VPC Endpoint for S3 (not Gateway Endpoint, which can't be accessed from on-premises).

**Scenario 4: "SaaS provider needs to expose API to customers' VPCs without peering."**
→ NLB + VPC Endpoint Service (PrivateLink). Customers create Interface VPC Endpoints.

**Scenario 5: "Need DDoS protection with automated response and cost protection."**
→ Shield Advanced + WAF + CloudFront. Associate Route 53 health checks for proactive engagement.

**Scenario 6: "All inter-VPC traffic must be inspected by IDS/IPS appliances."**
→ Centralized Inspection VPC with Network Firewall. TGW routing all traffic through inspection VPC.

**Scenario 7: "Need maximum resiliency for Direct Connect to production workloads."**
→ 4 connections across 2 DX locations. Each location has 2 connections to separate devices.

**Scenario 8: "Application requires static IPs for partner firewall whitelisting and global performance."**
→ Global Accelerator (2 static anycast IPs) → ALB endpoints in multiple Regions.

**Scenario 9: "DNS resolution between AWS VPCs and on-premises Active Directory."**
→ Route 53 Resolver with Inbound Endpoints (on-prem → AWS) and Outbound Endpoints with conditional forwarding (AWS → on-prem).

**Scenario 10: "Need to block specific domains for data exfiltration prevention across all VPCs."**
→ Route 53 DNS Firewall with deny-list rules applied to all VPCs. Or Network Firewall with domain filtering.

### Key Numbers to Remember

| Metric | Value |
|--------|-------|
| VPC max CIDRs | 5 IPv4 (soft limit) |
| Subnets per VPC | 200 (soft limit) |
| Route tables per VPC | 200 (soft limit) |
| Routes per route table | 50 static + 100 propagated |
| VPC peering per VPC | 125 |
| TGW attachments | 5,000 |
| TGW routes per route table | 10,000 |
| DX dedicated speeds | 1, 10, 100 Gbps |
| VPN tunnel bandwidth | 1.25 Gbps |
| VPN + TGW ECMP | 2.5 Gbps per connection (50 Gbps total with 20 connections) |
| Security group rules | 60 inbound + 60 outbound per SG |
| NACLs per VPC | 200 |
| Global Accelerator IPs | 2 static anycast |
| Shield Advanced cost | $3,000/month |

---

*This document covers the networking knowledge required for the SAP-C02 exam Domain 2. Networking is one of the most heavily tested areas. Focus on Transit Gateway architectures, Direct Connect resiliency models, PrivateLink patterns, and the security stack (WAF + Shield + Network Firewall).*
