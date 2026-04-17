# Networking & CDN — Deep Dive

## Amazon VPC

- **What it is:** Logically isolated virtual network in AWS.
- **Primitives:** CIDR, subnets (public/private, AZ-scoped), route
  tables, IGW, NAT GW/Instance, NACLs, SGs, VPC endpoints (Gateway,
  Interface / PrivateLink), peering, Transit Gateway.
- **CIDR rules:** /16 recommended, /28 minimum per subnet. First 4 and
  last IP of each subnet are reserved.
- **Public subnet** = has a route to an Internet Gateway. Private
  subnet = no IGW route (uses NAT GW for outbound).
- **Dual-stack** for IPv4 + IPv6; egress-only IGW for IPv6 outbound.

### VPC Endpoints

| Type | Service coverage | How it works |
|---|---|---|
| Gateway | S3, DynamoDB | Route table target; free |
| Interface (PrivateLink) | Most AWS services + SaaS partners + your own | ENIs with private IPs; $/hr + $/GB |

### Transit Gateway (TGW)

- Hub-and-spoke, transitive routing for many VPCs, VPNs, Direct Connect
  Gateways.
- One-to-many with route tables and attachments.
- Inter-Region peering supported.

### VPC Peering

- 1:1 between two VPCs (same/different accounts/Regions).
- **Non-transitive** (A↔B, B↔C does *not* imply A↔C).
- No overlapping CIDRs.

### PrivateLink

- Expose your service to other VPCs/accounts without peering.
- Consumer uses Interface endpoint; producer uses NLB or GWLB.

### VPN

- **Site-to-Site VPN** — IPsec tunnels from on-prem to VGW or TGW.
- **Client VPN** — OpenVPN-based end-user remote access.

### Direct Connect (DX)

- Dedicated fiber to AWS (1/10/100 Gbps).
- **VIFs** (Virtual Interfaces): Public (to AWS public services), Private
  (to a VPC via VGW), Transit (to a TGW).
- **DX Gateway** connects a DX to multiple VPCs across Regions.
- **MACsec** for encrypted L2 (requires 10/100 Gbps).
- Typical lead time: weeks/months. For quick deployment use a DX
  partner.

### AWS Cloud WAN

- Managed global WAN on AWS backbone; simpler than TGW mesh for global
  multi-site networks; uses policy-based intent.

### VPC Lattice

- Application-layer service network; identity-based policies; works
  across accounts/VPCs without TGW.

---

## Amazon Route 53

- **What it is:** Global authoritative DNS + domain registrar + health
  checks.
- **Routing policies:**
  - Simple
  - Weighted (A/B)
  - Latency
  - Failover (active/passive)
  - Geolocation (country)
  - Geoproximity (uses a bias)
  - Multivalue answer (up to 8 healthy)
  - IP-based (CIDR-based)
- **Features:** Private hosted zones, DNSSEC, Resolver endpoints for
  hybrid DNS, Resolver DNS Firewall, traffic-flow editor.
- **Pricing:** $0.50 per hosted zone per month (first 25), per-query
  rates, health-check rates.

---

## Amazon CloudFront

- **What it is:** Global Content Delivery Network.
- **600+ edge locations** in 100+ cities.
- **Features:**
  - Serve static and dynamic content from S3, ALB, EC2, Lambda,
    MediaStore, any HTTPS origin.
  - **Cache behaviors**, TTLs, query-string/header-based caching.
  - **Origin Access Control (OAC)** to protect S3 origin (replaces OAI).
  - **Origin Shield** extra cache tier.
  - Field-level encryption.
  - **CloudFront Functions** (JavaScript, lightweight, viewer req/resp).
  - **Lambda@Edge** (Node/Python; heavier logic at origin req/resp).
  - AWS WAF + Shield integration.
  - Signed URLs/cookies for private content.
  - Real-time logs.
- **Pricing:** Per GB egress (varies by geography), per request, plus
  invalidation requests (first 1,000 paths/month free).

---

## AWS Global Accelerator

- **What it is:** Static anycast IPs on AWS backbone that route users to
  closest healthy endpoint in an AWS Region.
- **Supports:** ALB, NLB, EC2, EIP.
- **Best for:** TCP/UDP (non-HTTP) workloads, gaming, IoT, VoIP; faster
  failover than DNS; stable IPs for allow-lists.
- **Pricing:** $0.025/hour per accelerator + $ per GB transferred.

---

## Comparison: CloudFront vs Global Accelerator

| Need | CloudFront | Global Accelerator |
|---|---|---|
| HTTP(S) caching | ✓ | ✗ |
| TCP/UDP (any) | ✗ | ✓ |
| Static anycast IPs | Partial (CloudFront has IPs per POP, not static) | ✓ |
| WAF / Shield | ✓ | via origin |
| Fast origin failover | Via origin groups | ✓ (within Regions) |
| Cache | ✓ | ✗ (no cache, just route) |

---

## Hybrid Networking Summary

```
Need                            Tool
-------------------------------  ----------------------------------
Encrypted internet tunnel        Site-to-Site VPN (to VGW / TGW)
Dedicated fiber, consistent perf Direct Connect (+ DX Gateway / TGW)
Many-to-many VPCs / on-prem      Transit Gateway
Few VPCs, non-transitive         VPC Peering
Private access to AWS svc        Gateway / Interface endpoints
Expose your service privately    PrivateLink (NLB/GWLB + endpoint svc)
Global WAN on AWS backbone       Cloud WAN
End-user VPN                     Client VPN
Zero-trust app access            AWS Verified Access
L7 service mesh across accounts  VPC Lattice
```
