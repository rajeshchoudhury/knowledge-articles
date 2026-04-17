# Networking and Connectivity

## AWS Solutions Architect Professional (SAP-C02) — Domain 1: Design Solutions for Organizational Complexity

---

## Table of Contents

1. [Introduction](#introduction)
2. [VPC Design for Multi-Account](#vpc-design-for-multi-account)
3. [Amazon VPC IP Address Manager (IPAM)](#amazon-vpc-ip-address-manager-ipam)
4. [Transit Gateway Architecture](#transit-gateway-architecture)
5. [AWS Direct Connect](#aws-direct-connect)
6. [Site-to-Site VPN](#site-to-site-vpn)
7. [Central Egress Patterns](#central-egress-patterns)
8. [Central Ingress Patterns](#central-ingress-patterns)
9. [Hybrid DNS](#hybrid-dns)
10. [AWS Network Firewall](#aws-network-firewall)
11. [Gateway Load Balancer](#gateway-load-balancer)
12. [VPC Endpoint Strategies](#vpc-endpoint-strategies)
13. [IP Addressing Strategies and BYOIP](#ip-addressing-strategies-and-byoip)
14. [Network Segmentation Patterns](#network-segmentation-patterns)
15. [Traffic Inspection Architectures](#traffic-inspection-architectures)
16. [Exam Scenarios — Comparing Connectivity Options](#exam-scenarios--comparing-connectivity-options)
17. [Exam Tips Summary](#exam-tips-summary)

---

## Introduction

Networking is the backbone of any multi-account AWS architecture. The SAP-C02 exam heavily tests your ability to design complex network topologies that span multiple accounts, regions, and hybrid environments. This article covers every networking concept you need to master, from CIDR planning to Transit Gateway routing, Direct Connect architectures, and traffic inspection patterns.

---

## VPC Design for Multi-Account

### CIDR Planning Fundamentals

Proper CIDR planning prevents the most painful networking problems: overlapping IP ranges that prevent peering, routing conflicts, and IP exhaustion.

**Non-Overlapping CIDR Strategy**:
```
Organization CIDR Allocation: 10.0.0.0/8

Management & Security:    10.0.0.0/16   (65,536 IPs)
  ├── Management:         10.0.0.0/20
  ├── Log Archive:        10.0.16.0/20
  └── Security:           10.0.32.0/20

Shared Services:          10.1.0.0/16   (65,536 IPs)
  ├── Network:            10.1.0.0/20
  ├── Shared Services:    10.1.16.0/20
  └── Identity:           10.1.32.0/20

Production:               10.10.0.0/16 – 10.19.0.0/16
  ├── App-A Prod:         10.10.0.0/16
  ├── App-B Prod:         10.11.0.0/16
  └── App-C Prod:         10.12.0.0/16

Staging:                  10.20.0.0/16 – 10.29.0.0/16
  ├── App-A Staging:      10.20.0.0/16
  └── App-B Staging:      10.21.0.0/16

Development:              10.30.0.0/16 – 10.39.0.0/16
  ├── App-A Dev:          10.30.0.0/16
  └── App-B Dev:          10.31.0.0/16

Sandbox:                  10.40.0.0/16 – 10.49.0.0/16
  └── Developer sandboxes

On-Premises:              172.16.0.0/12
  ├── Data Center 1:      172.16.0.0/16
  └── Data Center 2:      172.17.0.0/16
```

### Subnet Design Best Practices

```
VPC: 10.10.0.0/16 (Production App-A)

Public Subnets (Internet-facing):
  ├── pub-1a: 10.10.0.0/24  (AZ-a, 254 IPs)
  ├── pub-1b: 10.10.1.0/24  (AZ-b, 254 IPs)
  └── pub-1c: 10.10.2.0/24  (AZ-c, 254 IPs)

Private Subnets (Application tier):
  ├── priv-1a: 10.10.10.0/24 (AZ-a, 254 IPs)
  ├── priv-1b: 10.10.11.0/24 (AZ-b, 254 IPs)
  └── priv-1c: 10.10.12.0/24 (AZ-c, 254 IPs)

Database Subnets (Data tier):
  ├── db-1a: 10.10.20.0/24  (AZ-a, 254 IPs)
  ├── db-1b: 10.10.21.0/24  (AZ-b, 254 IPs)
  └── db-1c: 10.10.22.0/24  (AZ-c, 254 IPs)

TGW Subnets (Transit Gateway attachments):
  ├── tgw-1a: 10.10.30.0/28 (AZ-a, 14 IPs)
  ├── tgw-1b: 10.10.30.16/28 (AZ-b, 14 IPs)
  └── tgw-1c: 10.10.30.32/28 (AZ-c, 14 IPs)

Reserved:
  └── 10.10.100.0/24 – 10.10.255.0/24 (future growth)
```

### VPC Secondary CIDRs

VPCs support multiple CIDR blocks (up to 5 IPv4 CIDRs):
```bash
aws ec2 associate-vpc-cidr-block \
  --vpc-id vpc-abc123 \
  --cidr-block 100.64.0.0/16
```

Use cases for secondary CIDRs:
- IP address exhaustion in original CIDR
- Non-routable ranges for internal services (100.64.0.0/10)
- Container networking requiring additional IPs

> **Exam Tip**: When a question mentions "running out of IP addresses," secondary CIDRs or larger subnets are often the answer. Non-overlapping CIDRs are critical for VPC peering and Transit Gateway. Always plan CIDR allocation at the organization level.

---

## Amazon VPC IP Address Manager (IPAM)

### What is IPAM?

IPAM is a VPC feature that helps you plan, track, and monitor IP addresses for your AWS workloads. It integrates with AWS Organizations for multi-account IP management.

### IPAM Architecture

```
Management Account / Delegated Admin
  │
  └── IPAM
      ├── IPAM Scope (Public)
      │   └── Public IP pools
      │
      └── IPAM Scope (Private)
          └── Top-level Pool: 10.0.0.0/8
              ├── Regional Pool: us-east-1 (10.0.0.0/12)
              │   ├── Production Pool: 10.0.0.0/14
              │   │   ├── Account-A-Prod: 10.0.0.0/16 (allocated)
              │   │   └── Account-B-Prod: 10.1.0.0/16 (allocated)
              │   └── Development Pool: 10.4.0.0/14
              │       ├── Account-A-Dev: 10.4.0.0/16 (allocated)
              │       └── Account-B-Dev: 10.5.0.0/16 (allocated)
              │
              └── Regional Pool: eu-west-1 (10.16.0.0/12)
                  └── Production Pool: 10.16.0.0/14
                      └── Account-C-Prod: 10.16.0.0/16 (allocated)
```

### IPAM Features

| Feature | Description |
|---|---|
| **Pool hierarchy** | Nested pools for delegation |
| **Auto-allocation** | Automatic CIDR allocation for VPCs |
| **Compliance monitoring** | Detect overlapping CIDRs |
| **Organization integration** | Multi-account IP management |
| **RAM sharing** | Share IPAM pools with member accounts |
| **IP history** | Track IP assignments over time |

### IPAM Pool Sharing with RAM

```bash
# Share IPAM pool with Production OU
aws ram create-resource-share \
  --name "ProdIPAMPool" \
  --resource-arns "arn:aws:ec2::111111111111:ipam-pool/ipam-pool-abc123" \
  --principals "arn:aws:organizations::111111111111:ou/o-org123/ou-prod"
```

Member accounts can then create VPCs using the shared pool:
```bash
aws ec2 create-vpc \
  --ipv4-ipam-pool-id ipam-pool-abc123 \
  --ipv4-netmask-length 16
```

> **Exam Tip**: IPAM is the answer when questions mention "prevent overlapping CIDRs," "centralized IP management," or "automated IP allocation across accounts."

---

## Transit Gateway Architecture

### Core Concepts

```
┌────────────────────────────────────────────────────────────┐
│                    Transit Gateway                          │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Attachments (connection points):                     │  │
│  │  ├── VPC Attachment (connects a VPC)                  │  │
│  │  ├── VPN Attachment (connects a VPN tunnel)           │  │
│  │  ├── Direct Connect Gateway Attachment                │  │
│  │  ├── TGW Peering Attachment (inter-region)            │  │
│  │  └── Connect Attachment (SD-WAN / third-party)        │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Route Tables:                                        │  │
│  │  ├── Association: Which attachment uses this RT       │  │
│  │  ├── Propagation: Automatically add routes from       │  │
│  │  │   attached networks                                │  │
│  │  └── Static Routes: Manually configured routes        │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  Properties:                                                 │
│  ├── ASN: 64512 (default) or custom                        │
│  ├── DNS support: Enabled/Disabled                          │
│  ├── ECMP: Equal-cost multi-path routing                   │
│  ├── Multicast: Optional                                    │
│  └── Auto-accept shared attachments: Optional               │
└────────────────────────────────────────────────────────────┘
```

### TGW Route Table Design

**Flat Routing (All-to-All)**:
```
Single Route Table:
  ├── 10.0.0.0/16 → VPC-A attachment (propagated)
  ├── 10.1.0.0/16 → VPC-B attachment (propagated)
  ├── 10.2.0.0/16 → VPC-C attachment (propagated)
  └── 172.16.0.0/12 → VPN attachment (propagated)

All VPCs can communicate with each other and on-premises.
```

**Segmented Routing (Isolation)**:
```
Prod Route Table:
  ├── 10.10.0.0/16 → Prod-VPC-A (propagated)
  ├── 10.11.0.0/16 → Prod-VPC-B (propagated)
  ├── 10.1.0.0/16  → Shared-Services-VPC (propagated)
  └── 172.16.0.0/12 → VPN (propagated)
  (No dev VPC routes → prod cannot reach dev)

Dev Route Table:
  ├── 10.30.0.0/16 → Dev-VPC-A (propagated)
  ├── 10.31.0.0/16 → Dev-VPC-B (propagated)
  ├── 10.1.0.0/16  → Shared-Services-VPC (propagated)
  └── 172.16.0.0/12 → VPN (propagated)
  (No prod VPC routes → dev cannot reach prod)

Shared Services Route Table:
  ├── 10.10.0.0/16 → Prod-VPC-A (propagated)
  ├── 10.11.0.0/16 → Prod-VPC-B (propagated)
  ├── 10.30.0.0/16 → Dev-VPC-A (propagated)
  ├── 10.31.0.0/16 → Dev-VPC-B (propagated)
  └── 172.16.0.0/12 → VPN (propagated)
  (Shared services can reach all VPCs)
```

### TGW with Network Segmentation

```
Transit Gateway Route Tables:
┌──────────────────────────────────────────────────────┐
│                                                        │
│  ┌──────────┐   ┌──────────┐   ┌──────────────────┐ │
│  │ Prod RT  │   │ Dev RT   │   │ Shared Svc RT    │ │
│  │          │   │          │   │                    │ │
│  │ Assoc:   │   │ Assoc:   │   │ Assoc:            │ │
│  │ VPC-Prod │   │ VPC-Dev  │   │ VPC-Shared        │ │
│  │          │   │          │   │ VPN                │ │
│  │ Prop:    │   │ Prop:    │   │                    │ │
│  │ VPC-Prod │   │ VPC-Dev  │   │ Prop:              │ │
│  │ VPC-Shared│  │ VPC-Shared│  │ VPC-Prod           │ │
│  │ VPN      │   │ VPN      │   │ VPC-Dev            │ │
│  └──────────┘   └──────────┘   │ VPN                │ │
│                                  └──────────────────┘ │
└──────────────────────────────────────────────────────┘

Result:
  Prod VPCs ↔ Shared Services ✓
  Dev VPCs ↔ Shared Services ✓
  Prod VPCs ↔ Dev VPCs ✗ (isolated)
  All ↔ On-premises (via VPN) ✓
```

### TGW Inter-Region Peering

```
Region: us-east-1                      Region: eu-west-1
┌─────────────────────┐               ┌─────────────────────┐
│  TGW-East           │   Peering     │  TGW-West           │
│  ├── VPC-Prod-East  │<────────────> │  ├── VPC-Prod-West  │
│  ├── VPC-Dev-East   │  Attachment   │  ├── VPC-Dev-West   │
│  └── VPN-East       │               │  └── DX-West        │
│                     │               │                     │
│  Static route:      │               │  Static route:      │
│  10.100.0.0/16 →    │               │  10.10.0.0/16 →     │
│  peering attachment  │               │  peering attachment  │
└─────────────────────┘               └─────────────────────┘
```

**Important**: TGW peering routes must be static (propagation is not supported across peering connections).

### TGW Multicast

Transit Gateway supports multicast for applications like:
- Video streaming
- Financial data feeds
- Software updates

```
TGW Multicast Domain
  ├── Multicast group: 239.1.1.1
  ├── Source: EC2 in VPC-A (registered as source)
  └── Members: EC2 instances in VPC-B, VPC-C (registered as members)
```

> **Exam Tip**: Know TGW route table design for network segmentation. The exam tests: (1) Prod/Dev isolation via separate route tables, (2) Shared services accessible from all segments, (3) Centralized egress/inspection via blackhole routes + static routes. Inter-region peering requires static routes only.

---

## AWS Direct Connect

### Physical Architecture

```
Customer                  AWS Direct          AWS
Data Center               Connect Location    Region
┌───────────┐            ┌──────────────┐    ┌──────────────┐
│           │            │              │    │              │
│  Customer │  Cross     │  Customer    │    │  AWS         │
│  Router   │──Connect──>│  Router/     │    │  Router      │
│           │  (Fiber)   │  Device      │    │              │
│           │            │      │       │    │              │
│           │            │      │       │    │              │
│           │            │  AWS │Cage   │    │              │
│           │            │      │       │    │              │
│           │            │      ▼       │    │              │
│           │            │  AWS Direct  │───>│  Direct      │
│           │            │  Connect     │    │  Connect     │
│           │            │  Endpoint    │    │  Location    │
└───────────┘            └──────────────┘    └──────────────┘
```

### Connection Types

| Type | Bandwidth | Lead Time | Use Case |
|---|---|---|---|
| **Dedicated Connection** | 1, 10, 100 Gbps | Weeks-months | High bandwidth, consistent |
| **Hosted Connection** | 50 Mbps – 10 Gbps | Days-weeks | Flexible, partner-delivered |
| **Hosted VIF** | Shared bandwidth | Days | Quick, partner VLAN |

### Virtual Interfaces (VIFs)

| VIF Type | Purpose | Connects To |
|---|---|---|
| **Private VIF** | Access VPC resources | Virtual Private Gateway or Direct Connect Gateway |
| **Public VIF** | Access AWS public services | AWS public endpoints (S3, DynamoDB, etc.) |
| **Transit VIF** | Access multiple VPCs | Transit Gateway (via DX Gateway) |

### Direct Connect Gateway

```
                        ┌─────────────────────┐
                        │  DX Gateway          │
                        │  (Global resource)   │
                        │                       │
On-Prem ── DX ─── Private VIF ──┤              │
                        │        │              │
                        │        ├── VGW (VPC-1, us-east-1)
                        │        ├── VGW (VPC-2, us-west-2)
                        │        └── VGW (VPC-3, eu-west-1)
                        │                       │
                        └─────────────────────┘

OR with Transit Gateway:

On-Prem ── DX ─── Transit VIF ──┤ DX Gateway ├── TGW (us-east-1)
                                  │             ├── TGW (us-west-2)
                                  │             └── TGW (eu-west-1)
                                  └─────────────┘
```

### DX Gateway Allowed Prefixes

When associating a DX Gateway with a TGW, you must configure **allowed prefixes** to control which routes are advertised to on-premises:

```bash
aws directconnect create-transit-gateway-association \
  --direct-connect-gateway-id dxgw-abc123 \
  --gateway-id tgw-xyz789 \
  --add-allowed-prefixes-to-direct-connect-gateway \
    cidr=10.0.0.0/8 cidr=172.16.0.0/12
```

Without allowed prefixes, only the TGW's directly attached VPC CIDRs are advertised. To advertise summary routes, you must explicitly specify them.

### Direct Connect Resiliency Models

**Maximum Resiliency** (two locations, two connections each):
```
DC Location A                    DC Location B
┌──────────────┐                ┌──────────────┐
│ Connection 1 │──── DX GW ────│ Connection 3 │
│ Connection 2 │──── DX GW ────│ Connection 4 │
└──────────────┘                └──────────────┘
```

**High Resiliency** (two locations, one connection each):
```
DC Location A                    DC Location B
┌──────────────┐                ┌──────────────┐
│ Connection 1 │──── DX GW ────│ Connection 2 │
└──────────────┘                └──────────────┘
```

**Development/Test** (single location, single connection + VPN backup):
```
DC Location A
┌──────────────┐
│ Connection 1 │──── DX GW
│ VPN (backup) │──── TGW/VGW
└──────────────┘
```

### LAG (Link Aggregation Group)

LAG bundles multiple DX connections at the same location:
- All connections must be the same bandwidth
- Maximum 4 connections per LAG
- All connections must terminate at the same DX location
- Uses LACP (Link Aggregation Control Protocol)
- Provides increased bandwidth and failover

### MACsec Encryption

MACsec provides Layer 2 encryption for Direct Connect:
- Available on 10 Gbps and 100 Gbps dedicated connections
- Encrypts data at the Ethernet frame level
- Must be supported at both ends (customer device + AWS)
- Point-to-point encryption between customer and AWS

> **Exam Tip**: Know the DX resiliency models. Maximum resiliency = 2 locations × 2 connections. Transit VIF is required to connect DX to Transit Gateway (Private VIF connects to VGW only). DX Gateway is a global resource but operates regionally for VIFs. Allowed prefixes control route advertisements from TGW to on-premises.

---

## Site-to-Site VPN

### VPN Architecture

```
Customer Data Center                      AWS
┌──────────────────┐                    ┌──────────────────┐
│                  │                    │                  │
│  Customer        │   IPSec Tunnel 1  │  Virtual Private │
│  Gateway         │<═══════════════>  │  Gateway (VGW)   │
│  (CGW)           │                    │  OR               │
│  Public IP:      │   IPSec Tunnel 2  │  Transit Gateway  │
│  203.0.113.1     │<═══════════════>  │                  │
│                  │                    │                  │
└──────────────────┘                    └──────────────────┘

Each VPN connection = 2 tunnels (for redundancy)
Each tunnel = max 1.25 Gbps throughput
```

### VPN Types

| Feature | VGW-based VPN | TGW-based VPN |
|---|---|---|
| Target | Virtual Private Gateway | Transit Gateway |
| Scale | Single VPC | Multiple VPCs via TGW |
| ECMP | Not supported | Supported |
| Bandwidth | 1.25 Gbps (per tunnel) | Scale with ECMP (n × 1.25 Gbps) |
| Failover | Active/Passive tunnels | Active/Active with ECMP |

### Accelerated VPN

Uses AWS Global Accelerator to route VPN traffic to the nearest AWS edge location:

```
Customer ── Internet ── AWS Edge Location ── AWS Backbone ── TGW/VGW
                         (Global Accelerator)
```

Benefits:
- Lower latency (AWS backbone vs public internet)
- More consistent performance
- Available for TGW-based VPN connections
- Additional cost for Global Accelerator

### VPN over Direct Connect (Public VIF)

```
Customer ── DX (Public VIF) ── AWS Public Endpoints
                                └── VPN Endpoint (public IP)
                                    └── IPSec tunnel over DX
                                        └── VGW/TGW
```

Use case: Add encryption on top of DX connection (DX itself is not encrypted at the IP level).

### VPN CloudHub

```
                    ┌─────────────┐
                    │    VGW      │
                    │  (Hub)     │
                    └──────┬──────┘
                       ┌───┼───┐
                       │   │   │
              VPN-1    │   │   │  VPN-3
           ┌───────────┘   │   └───────────┐
           │           VPN-2│               │
           ▼               ▼               ▼
     ┌──────────┐   ┌──────────┐   ┌──────────┐
     │  Site 1  │   │  Site 2  │   │  Site 3  │
     │  (CGW-1) │   │  (CGW-2) │   │  (CGW-3) │
     └──────────┘   └──────────┘   └──────────┘

Sites can communicate with each other through the VGW hub.
Each site uses a different BGP ASN.
```

> **Exam Tip**: VPN CloudHub enables spoke-to-spoke communication through VGW. For higher bandwidth, use TGW with ECMP-enabled VPN connections (multiple tunnels = more bandwidth). Accelerated VPN uses Global Accelerator for better performance.

---

## Central Egress Patterns

### Pattern 1: NAT Gateway in Egress VPC

```
Spoke VPCs (Workload Accounts)
  │
  │ Route: 0.0.0.0/0 → TGW
  │
  ▼
Transit Gateway
  │
  │ Route: 0.0.0.0/0 → Egress VPC attachment
  │
  ▼
Egress VPC (Network Account)
  ├── TGW Subnet: Receives traffic from TGW
  │   Route: 0.0.0.0/0 → NAT Gateway
  │
  ├── Public Subnet: NAT Gateway + IGW
  │   Route: 10.0.0.0/8 → TGW (return traffic)
  │   Route: 0.0.0.0/0 → IGW
  │
  └── Internet Gateway
```

**Route Table Configuration**:

| Route Table | Destination | Target |
|---|---|---|
| Spoke VPC Private RT | 0.0.0.0/0 | TGW |
| TGW Default RT | 0.0.0.0/0 | Egress VPC Attachment |
| Egress VPC TGW Subnet RT | 0.0.0.0/0 | NAT Gateway |
| Egress VPC Public Subnet RT | 10.0.0.0/8 | TGW |
| Egress VPC Public Subnet RT | 0.0.0.0/0 | IGW |

### Pattern 2: Egress with Inspection (Network Firewall)

```
Spoke VPCs → TGW → Inspection VPC (Network Firewall) → TGW → Egress VPC → Internet

Spoke VPC → TGW
              │
              ▼ (Inspection RT: route to Inspection VPC)
         Inspection VPC
         ┌─────────────────────────────────────┐
         │  TGW Subnet → Network Firewall      │
         │  Firewall Subnet → TGW (return)     │
         └─────────────────────────────────────┘
              │
              ▼ (Post-inspection RT: route to Egress VPC)
         Egress VPC
         ┌─────────────────────────────────────┐
         │  TGW Subnet → NAT GW → IGW         │
         └─────────────────────────────────────┘
              │
              ▼
         Internet
```

### Cost Analysis: Central vs Distributed NAT

| Model | Cost Components |
|---|---|
| **Distributed** (NAT GW per VPC) | NAT GW hourly ($0.045/hr × VPCs) + data processing |
| **Centralized** (shared NAT GW) | NAT GW hourly (fewer) + TGW data processing ($0.02/GB) + NAT data processing |

Central egress saves on NAT Gateway hourly costs but adds TGW data processing. Break-even depends on number of VPCs and data volume.

---

## Central Ingress Patterns

### Pattern 1: Shared ALB in Network Account

```
Internet
  │
  ▼
Network Account
  ├── Application Load Balancer
  │   ├── WAF (Web ACL)
  │   ├── Shield Advanced
  │   ├── Listener Rules:
  │   │   ├── /app-a/* → Target Group (IP targets in App-A VPC)
  │   │   └── /app-b/* → Target Group (IP targets in App-B VPC)
  │   └── Connected to workload VPCs via TGW or peering
  │
  └── Traffic routes to workload accounts
```

### Pattern 2: CloudFront + ALB per Account

```
Internet → CloudFront (Edge) → Regional ALB (per workload account)
  ├── CloudFront in management/shared account
  ├── Origin: ALB in each workload account
  ├── WAF at CloudFront level (centralized)
  └── Each account manages own ALB
```

### Pattern 3: API Gateway

```
Internet → API Gateway (Regional/Edge) → Lambda/Service in workload accounts
  ├── Centralized API Gateway
  ├── VPC Link for private integration
  ├── Can route to NLB in workload accounts
  └── Authentication and throttling at API Gateway level
```

---

## Hybrid DNS

### Route 53 Resolver Architecture

```
On-Premises DNS                           AWS VPC DNS
┌─────────────────┐                      ┌─────────────────────────┐
│                 │                      │  VPC CIDR + 2           │
│  Corporate DNS  │                      │  (e.g., 10.0.0.2)      │
│  (AD DNS,       │                      │  = VPC DNS Resolver     │
│   BIND, etc.)   │                      │                         │
│                 │                      │  Route 53 Resolver      │
│                 │  ──── Inbound ────>  │  ┌─────────────────┐   │
│                 │  Endpoint            │  │ Inbound Endpoint│   │
│                 │  (on-prem → AWS)     │  │ ENI: 10.0.1.10  │   │
│                 │                      │  │ ENI: 10.0.2.10  │   │
│                 │                      │  └─────────────────┘   │
│                 │                      │                         │
│                 │  <── Outbound ─────  │  ┌─────────────────┐   │
│                 │  Endpoint            │  │ Outbound Endpt  │   │
│                 │  (AWS → on-prem)     │  │ ENI: 10.0.1.20  │   │
│                 │                      │  │ ENI: 10.0.2.20  │   │
│                 │                      │  └─────────────────┘   │
└─────────────────┘                      └─────────────────────────┘
```

### DNS Resolution Flow

**AWS → On-Premises** (Outbound):
```
EC2 in VPC queries: db.corp.example.com
  → VPC DNS Resolver (10.0.0.2)
    → Route 53 Resolver Forwarding Rule: *.corp.example.com → Outbound Endpoint
      → Outbound Endpoint → On-premises DNS (via DX/VPN)
        → Resolves to 172.16.1.100
```

**On-Premises → AWS** (Inbound):
```
On-prem server queries: api.internal.aws.example.com
  → On-premises DNS conditional forwarder: *.aws.example.com → Inbound Endpoint IPs
    → Inbound Endpoint (10.0.1.10) → Route 53 Resolver
      → Private Hosted Zone: api.internal.aws.example.com → 10.0.5.50
```

### Sharing Resolver Rules with RAM

```bash
aws ram create-resource-share \
  --name "DNS-Forwarding-Rules" \
  --resource-arns "arn:aws:route53resolver:us-east-1:NETWORK_ACCOUNT:resolver-rule/rslvr-rr-abc123" \
  --principals "arn:aws:organizations::MGMT_ACCOUNT:organization/o-org123"
```

---

## AWS Network Firewall

### Architecture

```
┌──────────────────────────────────────────────────────────┐
│  Inspection VPC                                            │
│                                                            │
│  ┌──────────────────────────────────────────────────┐    │
│  │  Firewall Subnet (AZ-a)                           │    │
│  │  ┌────────────────────────────────────────────┐  │    │
│  │  │  AWS Network Firewall Endpoint              │  │    │
│  │  │  (Gateway Load Balancer endpoint under hood)│  │    │
│  │  └────────────────────────────────────────────┘  │    │
│  └──────────────────────────────────────────────────┘    │
│                                                            │
│  ┌──────────────────────────────────────────────────┐    │
│  │  Firewall Subnet (AZ-b)                           │    │
│  │  ┌────────────────────────────────────────────┐  │    │
│  │  │  AWS Network Firewall Endpoint              │  │    │
│  │  └────────────────────────────────────────────┘  │    │
│  └──────────────────────────────────────────────────┘    │
│                                                            │
│  Firewall Policy:                                          │
│  ├── Stateless Rule Groups (processed first)              │
│  │   ├── Priority-based evaluation                        │
│  │   └── Actions: Pass, Drop, Forward to stateful        │
│  │                                                         │
│  └── Stateful Rule Groups (processed second)              │
│      ├── 5-tuple rules                                     │
│      ├── Domain list rules (DNS/TLS filtering)            │
│      └── Suricata-compatible IPS rules                    │
└──────────────────────────────────────────────────────────┘
```

### Stateless vs Stateful Rules

| Feature | Stateless | Stateful |
|---|---|---|
| Processing | Before stateful | After stateless |
| Connection tracking | No | Yes |
| Direction | Must define both directions | Handles return traffic |
| Rule format | 5-tuple + protocol | 5-tuple, domain, Suricata |
| Actions | Pass, Drop, Forward to stateful | Pass, Drop, Alert |
| Performance | Higher throughput | Lower throughput |

### Network Firewall Rule Examples

**Stateless Rule (drop specific IPs)**:
```json
{
  "RulesSource": {
    "StatelessRulesAndCustomActions": {
      "StatelessRules": [
        {
          "Priority": 1,
          "RuleDefinition": {
            "Actions": ["aws:drop"],
            "MatchAttributes": {
              "Sources": [{"AddressDefinition": "198.51.100.0/24"}],
              "Destinations": [{"AddressDefinition": "0.0.0.0/0"}],
              "Protocols": [6]
            }
          }
        }
      ]
    }
  }
}
```

**Stateful Domain Block Rule**:
```
# Block access to specific domains
pass tls any any -> any any (tls.sni; content:"allowed-domain.com"; nocase; endswith; sid:100; rev:1;)
drop tls any any -> any any (tls.sni; content:"."; nocase; sid:200; rev:1;)
```

### Deployment Models

**Distributed Model**: Firewall in each VPC
```
VPC-A: Network Firewall (inspects VPC-A traffic)
VPC-B: Network Firewall (inspects VPC-B traffic)
```

**Centralized Model**: Firewall in inspection VPC
```
All VPCs → TGW → Inspection VPC (Network Firewall) → TGW → Destination
```

**Combined Model**: Centralized for east-west, distributed for north-south
```
East-West: VPC → TGW → Inspection VPC → TGW → VPC
North-South: Each VPC has local firewall for internet traffic
```

> **Exam Tip**: Network Firewall is the answer when questions mention "deep packet inspection," "IDS/IPS," "domain filtering," or "Suricata rules." It's managed AWS infrastructure — you don't manage EC2 instances. For third-party appliances, use Gateway Load Balancer instead.

---

## Gateway Load Balancer

### Architecture

```
┌──────────────────────────────────────────────────────┐
│  Security VPC (Appliance Account)                      │
│                                                        │
│  ┌──────────────────────────────────────────────┐    │
│  │  Gateway Load Balancer                        │    │
│  │  ├── Listens on all ports (Layer 3)           │    │
│  │  ├── GENEVE encapsulation (port 6081)         │    │
│  │  └── Target Group:                            │    │
│  │      ├── Firewall appliance EC2-1 (AZ-a)     │    │
│  │      ├── Firewall appliance EC2-2 (AZ-b)     │    │
│  │      └── Auto Scaling Group                   │    │
│  └──────────────────────────────────────────────┘    │
│                                                        │
│  Creates: VPC Endpoint Service (GWLB type)            │
└──────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────┐
│  Application VPC (Workload Account)                    │
│                                                        │
│  ┌──────────────────────────────────────────────┐    │
│  │  Gateway Load Balancer Endpoint (GWLBe)       │    │
│  │  ├── Routes traffic to GWLB via PrivateLink   │    │
│  │  └── Inserted via route table entries         │    │
│  └──────────────────────────────────────────────┘    │
│                                                        │
│  Route table: 0.0.0.0/0 → GWLBe (before IGW)        │
└──────────────────────────────────────────────────────┘
```

### GENEVE Encapsulation

GWLB uses GENEVE protocol to:
- Preserve original packet headers (source/destination IP)
- Pass metadata to appliances
- Enable transparent insertion of security appliances
- Appliances see the original traffic, inspect/modify, and return

### Use Cases

- Third-party firewall appliances (Palo Alto, Fortinet, Check Point)
- IDS/IPS systems
- Deep packet inspection
- Network traffic analytics
- Data loss prevention (DLP)

---

## VPC Endpoint Strategies

### Endpoint Types

| Type | Services | Cost | DNS |
|---|---|---|---|
| **Gateway Endpoint** | S3, DynamoDB | Free | Route table entry |
| **Interface Endpoint** | Most services | Per-hour + data | Private DNS (optional) |
| **Gateway LB Endpoint** | GWLB services | Per-hour + data | Route table entry |

### Centralized vs Distributed Endpoints

**Distributed Model** (endpoint per VPC):
```
VPC-A: Interface Endpoint for STS, KMS, S3 (interface)
VPC-B: Interface Endpoint for STS, KMS, S3 (interface)
VPC-C: Interface Endpoint for STS, KMS, S3 (interface)

Cost: N endpoints × M services × hourly rate
```

**Centralized Model** (endpoints in shared VPC):
```
Shared Services VPC: All Interface Endpoints
  ├── STS endpoint
  ├── KMS endpoint
  ├── EC2 endpoint
  ├── SSM endpoint
  └── etc.

Spoke VPCs → TGW → Shared VPC → Endpoints
Route 53 PHZ: *.amazonaws.com → Endpoint ENI IPs
PHZ associated with all VPCs

Cost: 1 set of endpoints × hourly rate + TGW data processing
```

### Centralized Endpoints with Route 53

```
1. Create Interface Endpoints in Shared VPC (Private DNS disabled)
2. Create Route 53 Private Hosted Zone:
   - Zone: ec2.us-east-1.amazonaws.com
   - Record: Alias → VPC Endpoint
3. Associate PHZ with all spoke VPCs
4. Spoke VPCs resolve service DNS to endpoint IPs in Shared VPC
5. Traffic flows: Spoke VPC → TGW → Shared VPC → Endpoint → AWS Service
```

> **Exam Tip**: Centralized endpoints save cost when you have many VPCs but add TGW data processing charges and latency. Distributed endpoints are simpler but more expensive at scale. Gateway endpoints (S3, DynamoDB) are free — always use them. For PrivateLink, centralized is usually the exam answer for cost optimization.

---

## IP Addressing Strategies and BYOIP

### BYOIP (Bring Your Own IP)

Bring your own public IPv4 or IPv6 address ranges to AWS:

```bash
# Provision BYOIP CIDR
aws ec2 provision-byoip-cidr \
  --cidr 203.0.113.0/24 \
  --cidr-authorization-context \
    Message="...",Signature="..."

# Advertise the range
aws ec2 advertise-byoip-cidr --cidr 203.0.113.0/24
```

**Requirements**:
- Range must be registered in RIR (ARIN, RIPE, APNIC)
- Minimum /24 for IPv4
- Must create ROA (Route Origin Authorization)
- Range cannot be shared with other AWS accounts

### IPv6 in AWS

| Feature | IPv4 | IPv6 |
|---|---|---|
| Address space | Limited (CIDR blocks) | Virtually unlimited (/56 per VPC) |
| NAT | NAT Gateway needed | Egress-only Internet Gateway |
| Private addresses | Yes (RFC 1918) | No concept of private (all globally routable) |
| Dual-stack | Supported | Supported |
| VPC support | Required | Optional |

---

## Network Segmentation Patterns

### Micro-Segmentation with Security Groups

```
Web Tier SG:
  Inbound: Port 443 from ALB SG
  Outbound: Port 8080 to App SG

App Tier SG:
  Inbound: Port 8080 from Web SG
  Outbound: Port 5432 to DB SG

DB Tier SG:
  Inbound: Port 5432 from App SG
  Outbound: None (stateful return only)
```

### Network-Level Segmentation with NACLs

NACLs provide subnet-level stateless filtering:
- Evaluated before security groups
- Stateless (must allow return traffic explicitly)
- Rules processed in order (lowest number first)
- Default NACL allows all traffic

### TGW Routing Domain Segmentation

```
Routing Domains via TGW Route Tables:

Domain 1 (Production):
  VPCs: Prod-A, Prod-B, Prod-C
  Can reach: Shared Services, On-premises
  Cannot reach: Dev, Staging

Domain 2 (Development):
  VPCs: Dev-A, Dev-B
  Can reach: Shared Services
  Cannot reach: Production, On-premises

Domain 3 (Shared Services):
  VPCs: DNS, AD, CI/CD
  Can reach: All domains
```

### Blackhole Routes for Isolation

```
In Production TGW Route Table:
  10.10.0.0/16 → Prod-VPC-A (propagated)
  10.11.0.0/16 → Prod-VPC-B (propagated)
  10.1.0.0/16  → Shared-Services (propagated)
  10.30.0.0/8  → Blackhole (blocks all dev CIDRs)
```

---

## Traffic Inspection Architectures

### East-West Traffic Inspection

```
VPC-A → TGW (Inspection RT) → Inspection VPC → TGW (Post-Inspection RT) → VPC-B

TGW Route Tables:
  Spoke RT (associated with VPC-A, VPC-B):
    0.0.0.0/0 → Inspection VPC attachment

  Inspection RT (associated with Inspection VPC):
    10.0.0.0/16 → VPC-A attachment
    10.1.0.0/16 → VPC-B attachment
```

### North-South Traffic Inspection

```
Internet → IGW → ALB → Inspection VPC (Network Firewall) → Backend VPC

OR

Spoke VPC → TGW → Inspection VPC (Network Firewall) → TGW → Egress VPC → Internet
```

### Full Inspection Architecture

```
                          Internet
                             │
                    ┌────────┴────────┐
                    │   Egress VPC    │
                    │   NAT GW + IGW  │
                    └────────┬────────┘
                             │
                    ┌────────┴────────┐
                    │  Transit Gateway │
                    └────────┬────────┘
                             │
                    ┌────────┴────────┐
                    │  Inspection VPC  │
                    │  Network Firewall│
                    └────────┬────────┘
                             │
                    ┌────────┴────────┐
                    │  Transit Gateway │
                    └───┬────┬────┬───┘
                        │    │    │
                    ┌───┘    │    └───┐
                    │        │        │
               ┌────┴───┐ ┌─┴──┐ ┌──┴────┐
               │ VPC-A  │ │VPC-B│ │VPC-C  │
               │ Prod   │ │Dev  │ │Shared │
               └────────┘ └────┘ └───────┘
```

---

## Exam Scenarios — Comparing Connectivity Options

### Scenario 1: When to Choose Each Option

| Requirement | Best Solution |
|---|---|
| Connect 2 VPCs | VPC Peering |
| Connect 5+ VPCs | Transit Gateway |
| Connect VPC to on-premises (low bandwidth) | Site-to-Site VPN |
| Connect VPC to on-premises (high bandwidth) | Direct Connect |
| Connect VPC to on-premises (encrypted, high bandwidth) | DX + VPN over DX |
| Multiple remote sites connecting to AWS | VPN CloudHub or TGW with VPN |
| Expose service to specific accounts | PrivateLink |
| Share subnets across accounts | RAM + VPC Sharing |
| Inspect all traffic between VPCs | TGW + Network Firewall |
| Third-party security appliances | Gateway Load Balancer |
| Centralized internet egress | TGW + Egress VPC + NAT GW |
| Multi-region connectivity | TGW inter-region peering |
| DX to multiple regions | DX Gateway + Transit VIF |

### Scenario 2: High Availability

**Question**: Design a highly available hybrid connection.

```
Primary: Direct Connect (Dedicated, 10 Gbps)
  ├── Location A: Connection 1
  └── Location B: Connection 2

Backup: Site-to-Site VPN (over internet)
  ├── Active when DX fails (BGP failover)
  └── Lower bandwidth but always available

DX Gateway → TGW (with DX and VPN attachments)
  ├── DX path: Higher BGP local preference
  └── VPN path: Lower BGP local preference (backup)
```

### Scenario 3: Encryption Requirement

**Question**: Company requires ALL data in transit to be encrypted, including DX.

```
Option A: VPN over DX (Public VIF)
  ├── IPSec encryption over DX
  └── Uses DX bandwidth with VPN overhead

Option B: MACsec on DX
  ├── Layer 2 encryption
  ├── Requires 10/100 Gbps dedicated connection
  └── Higher performance than IPSec

Option C: Application-level TLS
  ├── Encrypt at application layer
  └── Works with any transport
```

### Scenario 4: Cost Optimization

**Question**: 20 VPCs each with NAT Gateway for internet access. Optimize costs.

```
Current: 20 NAT Gateways × $32.40/month = $648/month (hourly only)

Solution: Central egress via TGW
  ├── 2 NAT Gateways (multi-AZ) = $64.80/month
  ├── TGW data processing: $0.02/GB
  ├── TGW hourly: TGW attachment per VPC × $0.05/hr
  └── Break-even analysis needed based on data volume
```

---

## Exam Tips Summary

### Must-Know Networking Facts

1. **Transit Gateway**: Up to 5,000 attachments, 50 Gbps burst bandwidth per VPC attachment
2. **VPC Peering**: No transitive routing, no overlapping CIDRs, no edge-to-edge routing
3. **Direct Connect**: Not encrypted by default. Use VPN over DX or MACsec for encryption
4. **Site-to-Site VPN**: 1.25 Gbps per tunnel, 2 tunnels per connection
5. **ECMP**: Only supported on TGW-based VPN (not VGW)
6. **DX Gateway**: Global resource, connects DX to multiple VGWs or TGWs across regions
7. **Transit VIF**: Required for DX → TGW connectivity (not Private VIF)
8. **Allowed Prefixes**: Must be configured on DX Gateway ↔ TGW association to advertise summary routes
9. **Network Firewall**: Managed service for IDS/IPS, domain filtering, Suricata rules
10. **Gateway Load Balancer**: For third-party appliances, uses GENEVE encapsulation
11. **VPC Endpoints**: Gateway (S3, DynamoDB) = free; Interface = per-hour cost
12. **IPAM**: Centralized IP management, prevents overlapping CIDRs
13. **TGW Peering**: Inter-region, static routes only (no propagation)
14. **RAM**: Share TGW, subnets, resolver rules across accounts/org

### Common Exam Traps

| Trap | Correct Answer |
|---|---|
| VPC peering is transitive | It is NOT transitive |
| DX is encrypted | DX is NOT encrypted by default |
| Private VIF connects to TGW | Transit VIF connects to TGW |
| TGW peering supports route propagation | Only static routes |
| Gateway Endpoints cost money | Gateway Endpoints (S3/DynamoDB) are free |
| Network Firewall needs EC2 management | It's a managed service |
| NAT Gateway per VPC is always best | Central egress can be cheaper |
| ECMP works with VGW VPN | ECMP only with TGW VPN |

---

## Advanced Networking Patterns

### Multi-Region Network Architecture

```
Region: us-east-1                           Region: eu-west-1
┌────────────────────────────────┐        ┌────────────────────────────────┐
│  TGW-East                      │        │  TGW-West                      │
│  ├── Prod VPCs (us-east-1)     │  TGW   │  ├── Prod VPCs (eu-west-1)     │
│  ├── Dev VPCs (us-east-1)      │ Peering│  ├── Dev VPCs (eu-west-1)      │
│  ├── Shared Services VPC       │<──────>│  ├── Shared Services VPC       │
│  ├── Egress VPC                │        │  ├── Egress VPC                │
│  ├── Inspection VPC            │        │  ├── Inspection VPC            │
│  └── DX Gateway (DX Location A)│        │  └── DX Gateway (DX Location B)│
└────────────────────────────────┘        └────────────────────────────────┘
         │                                          │
         └────────── On-Premises DC ────────────────┘
              (Dual DX for redundancy)
```

**Design Considerations**:
- TGW peering is static routes only — plan CIDR summarization
- Each region has independent egress and inspection VPCs
- DX Gateway connects to TGWs in multiple regions
- DNS resolution via Route 53 Resolver per region

### AWS Cloud WAN

Cloud WAN provides a managed global network:

```
Global Network (Cloud WAN)
  │
  ├── Core Network:
  │   ├── Segments:
  │   │   ├── Production Segment
  │   │   ├── Development Segment
  │   │   └── Shared Services Segment
  │   │
  │   ├── Segment Actions:
  │   │   ├── share (allow communication between segments)
  │   │   └── isolate (prevent communication)
  │   │
  │   └── Attachment Policies:
  │       ├── Tag-based: "Environment=Prod" → Production Segment
  │       └── Tag-based: "Environment=Dev" → Development Segment
  │
  ├── Edges:
  │   ├── us-east-1 (Core Network Edge)
  │   ├── eu-west-1 (Core Network Edge)
  │   └── ap-southeast-1 (Core Network Edge)
  │
  └── Attachments:
      ├── VPC attachments
      ├── Site-to-Site VPN attachments
      ├── Transit Gateway route table attachments
      └── Connect attachments (SD-WAN)
```

**Cloud WAN vs Transit Gateway**:

| Feature | Transit Gateway | Cloud WAN |
|---|---|---|
| Scope | Single region | Global |
| Segmentation | Route tables | Segments with policy |
| Inter-region | Manual peering | Automatic |
| Routing | Manual/propagation | Policy-based |
| Management | Per-region | Centralized global |
| Complexity | Medium | Lower for global |
| Cost | Per attachment | Per attachment + segment |

### Network Access Control Patterns

**AWS Verified Access** (Zero Trust):
```
Remote User → Verified Access Endpoint → Application
  ├── No VPN required
  ├── Identity verification (OIDC/IAM Identity Center)
  ├── Device posture check (trust provider)
  ├── Per-application access policies
  └── Continuous authorization
```

**AWS Client VPN**:
```
Remote User → Client VPN Endpoint → VPC
  ├── OpenVPN-based
  ├── Mutual TLS authentication
  ├── AD or SAML authentication
  ├── Authorization rules per CIDR
  ├── Split-tunnel or full-tunnel
  └── CloudWatch Logs for connection tracking
```

### IPv6 Networking Patterns

```
Dual-Stack VPC:
  ├── IPv4 CIDR: 10.0.0.0/16
  ├── IPv6 CIDR: 2600:1f18::/56 (Amazon-provided)
  │
  ├── Public Subnet:
  │   ├── IPv4: Internet via IGW
  │   └── IPv6: Internet via IGW
  │
  ├── Private Subnet:
  │   ├── IPv4: Internet via NAT Gateway
  │   └── IPv6: Internet via Egress-Only Internet Gateway
  │
  └── Egress-Only IGW:
      ├── Allows outbound IPv6
      ├── Blocks inbound IPv6 (stateful)
      └── No NAT needed (IPv6 has no private ranges)
```

### Network Performance Optimization

| Technique | Use Case | Benefit |
|---|---|---|
| **Placement Groups** (Cluster) | HPC, low latency | 10-25 Gbps between instances |
| **Enhanced Networking** (ENA) | General workloads | Up to 100 Gbps |
| **EFA** (Elastic Fabric Adapter) | HPC, ML training | OS-bypass, MPI |
| **Global Accelerator** | Global applications | Anycast IP, AWS backbone |
| **CloudFront** | Content delivery | Edge caching, low latency |
| **Transfer Acceleration** | S3 uploads | Edge-to-S3 via backbone |
| **Jumbo Frames** (9001 MTU) | VPC traffic | Reduce overhead for large payloads |

### AWS PrivateLink Architecture Patterns

**Centralized PrivateLink Hub**:
```
Shared Services VPC (endpoint services):
  ├── NLB → Internal API Service A
  │   └── VPC Endpoint Service → Consumer VPCs
  │
  ├── NLB → Internal API Service B
  │   └── VPC Endpoint Service → Consumer VPCs
  │
  └── Interface Endpoints for AWS services:
      ├── S3 (interface type)
      ├── STS
      ├── KMS
      ├── SSM
      └── ECR (api + dkr)
```

**Cross-Account Service Exposure**:
```
Provider Account:
  └── NLB + VPC Endpoint Service
      ├── Allowed principals: Consumer accounts
      └── Acceptance required: Yes

Consumer Account:
  └── Interface Endpoint → Provider's Endpoint Service
      ├── Private DNS name (if configured)
      └── Security group controlled
```

### Network Monitoring and Troubleshooting

| Tool | Purpose | Scope |
|---|---|---|
| **VPC Flow Logs** | IP traffic logging | VPC, Subnet, ENI |
| **Traffic Mirroring** | Packet-level capture | ENI → target (NLB/ENI) |
| **Reachability Analyzer** | Path analysis | Between resources |
| **Network Access Analyzer** | Unintended access | Network configuration |
| **Transit Gateway Network Manager** | Global view | TGW, SD-WAN |
| **CloudWatch Metrics** | Performance metrics | Per-resource |
| **VPC Lattice** | Service-to-service networking | Application layer |

### VPC Flow Logs — Advanced

```
VPC Flow Log Record (v5):
{
  version, account-id, interface-id, srcaddr, dstaddr,
  srcport, dstport, protocol, packets, bytes, start, end,
  action, log-status,
  vpc-id, subnet-id, instance-id, tcp-flags,
  type, pkt-srcaddr, pkt-dstaddr,
  region, az-id, sublocation-type, sublocation-id,
  pkt-src-aws-service, pkt-dst-aws-service,
  flow-direction, traffic-path
}
```

**Flow Log Destinations**:
- CloudWatch Logs (real-time analysis with metric filters)
- S3 (cost-effective long-term storage, Athena queries)
- Kinesis Data Firehose (real-time streaming to analytics)

**Athena Query Example**:
```sql
SELECT srcaddr, dstaddr, dstport, protocol, 
       SUM(bytes) as total_bytes, COUNT(*) as flow_count
FROM vpc_flow_logs
WHERE action = 'REJECT' 
  AND date = '2024/01/15'
GROUP BY srcaddr, dstaddr, dstport, protocol
ORDER BY flow_count DESC
LIMIT 20;
```

### Network Cost Optimization

| Data Transfer Type | Cost | Optimization |
|---|---|---|
| Same AZ (private IP) | Free | Use private IPs |
| Cross-AZ (same region) | $0.01/GB each way | Minimize cross-AZ |
| Cross-Region | $0.02/GB | Use regional endpoints |
| Internet egress | $0.09/GB (first 10TB) | Use CloudFront, S3 Transfer Acceleration |
| TGW data processing | $0.02/GB | Minimize via VPC sharing |
| NAT Gateway processing | $0.045/GB | Central egress, VPC endpoints |
| VPC Peering (cross-region) | $0.02/GB | Same as cross-region |
| DX data transfer out | $0.02/GB | Lower than internet egress |

**Key Optimization Strategies**:
1. Use **VPC Gateway Endpoints** for S3/DynamoDB (free)
2. Use **VPC sharing** instead of TGW where possible (saves data processing)
3. Use **CloudFront** for internet-facing content (lower egress costs)
4. Keep traffic in **same AZ** when possible
5. Use **S3 interface endpoints** to avoid NAT Gateway for S3 access
6. Consolidate **NAT Gateways** via central egress
7. Use **PrivateLink** instead of internet for service-to-service

### Exam Quick-Reference: Connectivity Decision Matrix

| From | To | Best Option | Alternative |
|---|---|---|---|
| VPC | VPC (same region, few) | VPC Peering | TGW |
| VPC | VPC (same region, many) | Transit Gateway | Cloud WAN |
| VPC | VPC (cross-region) | TGW Peering | Cloud WAN |
| VPC | On-premises (low BW) | Site-to-Site VPN | |
| VPC | On-premises (high BW) | Direct Connect | DX + VPN backup |
| VPC | On-premises (encrypted) | VPN over DX / MACsec | |
| VPC | Internet (egress) | NAT GW (central) | NAT instance |
| VPC | AWS Service | VPC Endpoint | NAT GW (expensive) |
| VPC | Third-party service | PrivateLink | TGW + VPN |
| Multiple sites | AWS (hub-spoke) | TGW + VPN | VPN CloudHub |
| VPC | VPC (service access) | PrivateLink | Peering/TGW |
| Global users | Application | Global Accelerator | CloudFront |
| VPC | VPC (shared networking) | RAM + VPC Sharing | TGW |

---

## AWS VPC Lattice

### What is VPC Lattice?

VPC Lattice is an application networking service that simplifies service-to-service connectivity, security, and monitoring:

```
VPC Lattice Service Network
  │
  ├── Service A (Account 1, VPC 1)
  │   ├── Listener (HTTP/HTTPS, port 443)
  │   ├── Rules (path-based routing)
  │   └── Target Groups:
  │       ├── EC2 instances
  │       ├── ECS tasks
  │       ├── Lambda functions
  │       └── ALB
  │
  ├── Service B (Account 2, VPC 2)
  │   └── Similar structure
  │
  └── Auth Policies:
      ├── Service-level auth policy
      ├── Network-level auth policy
      └── IAM-based (SigV4) or None
```

**VPC Lattice vs Other Connectivity**:

| Feature | VPC Lattice | Transit Gateway | PrivateLink | App Mesh |
|---|---|---|---|---|
| Layer | L7 (HTTP) | L3/L4 | L4 | L7 |
| Service discovery | Built-in | No | No | Yes |
| Auth policies | IAM-based | No | No | mTLS |
| Cross-account | Yes (RAM) | Yes (RAM) | Yes | Complex |
| Load balancing | Built-in | No | NLB needed | Envoy |
| Observability | Built-in | Flow Logs | No | X-Ray |

### VPC Lattice Cross-Account

```
Account A (Service Provider):
  └── VPC Lattice Service: "payment-service"
      ├── Shared via RAM to Service Network
      └── Auth policy: Allow Account B's role

Service Network (shared):
  ├── Service: payment-service (Account A)
  ├── Service: order-service (Account B)
  └── VPC associations: VPC-A, VPC-B

Account B (Service Consumer):
  └── VPC associated with Service Network
      └── Applications can reach payment-service
          via VPC Lattice DNS name
```

## Network Architecture Anti-Patterns

### Common Mistakes to Avoid

| Anti-Pattern | Problem | Correct Approach |
|---|---|---|
| VPC per application per AZ | Unmanageable VPC sprawl | Use shared VPCs or fewer larger VPCs |
| Peering mesh (10+ VPCs) | O(n²) peering connections | Use Transit Gateway |
| NAT Gateway in every VPC | High cost | Central egress VPC |
| Public subnets everywhere | Increased attack surface | Private subnets + ALB/NLB in public |
| Overlapping CIDRs | Cannot peer or transit | Use IPAM, plan CIDRs upfront |
| Single DX connection | No redundancy | Multiple connections, multiple locations |
| VPN as primary (high BW) | 1.25 Gbps limit | Use Direct Connect, VPN as backup |
| No traffic inspection | Blind to threats | Network Firewall or GWLB |
| Interface endpoints per VPC | Expensive at scale | Centralized endpoints via shared VPC |
| Flat network (no segmentation) | Large blast radius | TGW route tables for isolation |

### Network Troubleshooting Checklist

```
Connection failing between resources?
  1. Check Security Groups (stateful, both directions)
  2. Check NACLs (stateless, both directions, return traffic)
  3. Check Route Tables (routes exist to destination)
  4. Check VPC Peering/TGW routes
  5. Check DNS resolution (enableDnsHostnames, enableDnsSupport)
  6. Check IAM permissions (for VPC endpoint access)
  7. Check VPC endpoint policies
  8. Check Network Firewall rules (if applicable)
  9. Use VPC Reachability Analyzer
  10. Check VPC Flow Logs for REJECT entries
```

## Summary

Networking is the most technically deep topic in Domain 1 of the SAP-C02 exam. Key areas to master:

1. **CIDR planning**: Non-overlapping ranges planned at organization level using IPAM
2. **Transit Gateway**: Route table design for segmentation, inter-region peering, shared via RAM
3. **Direct Connect**: Physical architecture, VIF types, DX Gateway, resiliency models, allowed prefixes
4. **Site-to-Site VPN**: Tunnels, ECMP (TGW only), Accelerated VPN, VPN CloudHub
5. **Central egress/ingress**: NAT Gateway sharing, traffic inspection, cost optimization
6. **Network Firewall**: Managed IDS/IPS, stateful/stateless rules, Suricata
7. **Gateway Load Balancer**: Third-party appliances, GENEVE encapsulation
8. **VPC endpoints**: Gateway (free) vs Interface (paid), centralized vs distributed
9. **Cloud WAN**: Global managed network with policy-based segmentation
10. **VPC Lattice**: Application-layer service networking across accounts

---

*Previous Article: [← Cross-Account Access Patterns](./03-cross-account-access-patterns.md)*
*Next Article: [Hybrid DNS & Directory →](./05-hybrid-dns-and-directory.md)*
