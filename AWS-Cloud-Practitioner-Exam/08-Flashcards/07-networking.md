# Flashcards — Domain 3 (Networking)

Q: What is a VPC?
A: Logically isolated virtual network in AWS, scoped to a Region. #must-know

Q: VPC CIDR recommended size?
A: /16 (or smaller like /20/24 if your org enforces conservation). #must-know

Q: Minimum subnet CIDR size?
A: /28. #must-know

Q: How many IPs per subnet are reserved by AWS?
A: 5 (first 4 + broadcast). #must-know

Q: Public subnet =?
A: A subnet whose route table has a route 0.0.0.0/0 → IGW. #must-know

Q: Private subnet =?
A: No direct IGW route; uses NAT Gateway for egress. #must-know

Q: NAT Gateway vs NAT Instance?
A: NAT GW is managed, AZ-scoped, highly available within AZ, auto-scales. NAT Instance is self-managed EC2. #must-know

Q: Which service lets you privately reach S3 without internet?
A: S3 Gateway VPC Endpoint (free). #must-know

Q: Which service lets you privately reach most AWS services via an ENI?
A: Interface VPC Endpoint (PrivateLink) — $ per hr + per GB. #must-know

Q: VPC Peering property to remember?
A: Non-transitive (A-B + B-C doesn't imply A-C). #must-know

Q: Transit Gateway purpose?
A: Hub-and-spoke connectivity for many VPCs, VPNs, DX. #must-know

Q: Is TGW transitive?
A: Yes (through route tables on the TGW). #must-know

Q: PrivateLink provider side uses what LB?
A: NLB (most common) or GWLB. #must-know

Q: Site-to-Site VPN uses what protocol?
A: IPsec. #must-know

Q: Direct Connect VIF types?
A: Public, Private, Transit. #must-know

Q: DX Gateway purpose?
A: Connect a DX to multiple VPCs (potentially in multiple Regions) via VGW/TGW. #must-know

Q: MACsec needs which DX speeds?
A: 10 or 100 Gbps. #must-know

Q: Cloud WAN?
A: Managed global WAN on AWS backbone; simplifies global network management. #must-know

Q: VPC Lattice?
A: Application-layer service network with identity-based policies across VPCs/accounts. #must-know

Q: Client VPN?
A: End-user OpenVPN-based VPN to AWS. #must-know

Q: Route 53 routing policies?
A: Simple, Weighted, Latency, Failover, Geolocation, Geoproximity, Multivalue answer, IP-based. #must-know

Q: Private hosted zone?
A: DNS namespace for a VPC (internal). #must-know

Q: Route 53 Resolver purpose?
A: Hybrid DNS: forward queries between VPC and on-prem. #must-know

Q: CloudFront purpose?
A: Global CDN to cache static/dynamic content at 600+ POPs. #must-know

Q: CloudFront integrates with what security?
A: WAF, Shield, Signed URLs/cookies, Field-level encryption, Origin Access Control. #must-know

Q: CloudFront edge compute options?
A: CloudFront Functions (lightweight) and Lambda@Edge (heavier). #must-know

Q: Global Accelerator purpose?
A: TCP/UDP anycast acceleration with static IPs, routing users to closest healthy AWS endpoint. #must-know

Q: CloudFront vs Global Accelerator?
A: CF = HTTP caching. GA = TCP/UDP routing on AWS backbone (no caching). #must-know

Q: Typical use for NLB?
A: High perf, static IPs, non-HTTP workloads (gaming, IoT, VoIP). #must-know

Q: Gateway Load Balancer purpose?
A: Insert 3rd-party virtual appliances (firewalls/IDS/IPS) into traffic using GENEVE. #must-know

Q: What SG rule by default is applied on a new SG?
A: Deny all inbound; allow all outbound. #must-know

Q: What happens to return traffic in SGs vs NACLs?
A: SG (stateful): return allowed automatically. NACL (stateless): return must be explicitly allowed. #must-know

Q: What's an Egress-Only IGW?
A: IPv6 outbound-only gateway (no inbound). #must-know

Q: Max VPCs per Region by default?
A: 5 (soft limit). #must-know

Q: Public IPv4 pricing change recently?
A: Since Feb 2024, every public IPv4 (assigned or not) costs $0.005/hr. #must-know

Q: How to reduce NAT GW data-processing costs?
A: VPC Endpoints (S3 gateway, DDB gateway) — traffic bypasses NAT. #must-know

Q: What is VPC Flow Logs?
A: Capture IP traffic metadata (5-tuple + action) for a VPC/subnet/ENI; send to CW Logs, S3, or Firehose. #must-know

Q: Default VPC exists by default?
A: Yes, one per Region with default subnets and an IGW. #must-know

Q: What is VPC reachability analyzer?
A: Tool that traces whether a source → dest connection is possible in VPC (diagnostic). #must-know

Q: What is Network Access Analyzer?
A: Reviews VPC configuration for unintended network paths matching scopes. #must-know

Q: Can you connect two VPCs in different accounts via peering?
A: Yes, if owner of each accepts. #must-know

Q: How to share a subnet with another account?
A: Use AWS RAM to share the subnet; the owner controls the network, the consumer places resources. #must-know
