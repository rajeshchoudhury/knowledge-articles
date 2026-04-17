# Networking Flashcards

## AWS Solutions Architect Associate (SAA-C03) — Deck 2 of 9

---

### Card 1
**Q:** What is an Amazon VPC and what are its key characteristics?
**A:** A Virtual Private Cloud (VPC) is a logically isolated virtual network in AWS. Key characteristics: spans a single AWS Region, contains subnets in one or more AZs, has a CIDR block (IPv4 required, IPv6 optional), comes with a default route table, default security group, and default NACL. Maximum 5 VPCs per region (soft limit). Default VPC is created automatically with a /16 CIDR, public subnets in each AZ, an IGW, and a default route to the internet.

---

### Card 2
**Q:** What are the allowed CIDR block sizes for a VPC?
**A:** VPC CIDR blocks must be between **/16** (65,536 IPs) and **/28** (16 IPs). You can add up to 5 secondary CIDR blocks to a VPC. The CIDR ranges must not overlap with other VPCs you want to peer with. Private ranges recommended: `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`. AWS reserves 5 IPs in each subnet (first 4 + last 1).

---

### Card 3
**Q:** Which 5 IP addresses does AWS reserve in each subnet?
**A:** For a subnet `10.0.0.0/24`: **10.0.0.0** – Network address. **10.0.0.1** – VPC router. **10.0.0.2** – DNS server (VPC base +2). **10.0.0.3** – Reserved for future use. **10.0.0.255** – Broadcast address (AWS doesn't support broadcast, but reserves it). So a /24 subnet has 256 − 5 = **251 usable** IPs.

---

### Card 4
**Q:** What makes a subnet public vs. private?
**A:** A **public subnet** has a route table entry routing `0.0.0.0/0` to an **Internet Gateway (IGW)**. Instances in it also need a public or Elastic IP to communicate with the internet. A **private subnet** has no route to an IGW. To allow outbound internet access from a private subnet, route `0.0.0.0/0` to a **NAT Gateway** or NAT instance in a public subnet.

---

### Card 5
**Q:** What is an Internet Gateway (IGW)?
**A:** An IGW is a horizontally scaled, redundant, highly available VPC component that allows communication between instances in a VPC and the internet. It performs **NAT** for instances with public IPv4 addresses. One IGW per VPC. It does not impose bandwidth constraints. For an instance to reach the internet: it needs a public/Elastic IP, the subnet route table must route to the IGW, and NACLs/SGs must allow the traffic.

---

### Card 6
**Q:** What is a NAT Gateway and how does it differ from a NAT instance?
**A:** **NAT Gateway** – AWS-managed, highly available within an AZ, scales up to 100 Gbps, no security groups, uses an Elastic IP, no patching needed, no bastion access. **NAT Instance** – self-managed EC2 instance, must disable source/destination check, can use as a bastion, supports security groups, limited by instance bandwidth, requires manual HA setup. NAT Gateway is recommended. Deploy one NAT Gateway per AZ for multi-AZ resilience.

---

### Card 7
**Q:** What is the difference between Security Groups and NACLs?
**A:** **Security Groups**: stateful (return traffic auto-allowed), operate at the ENI/instance level, allow rules only (no deny), evaluate all rules before deciding, default denies all inbound/allows all outbound. **NACLs**: stateless (must explicitly allow return traffic), operate at the subnet level, support allow AND deny rules, rules evaluated in order (lowest number first), default allows all inbound and outbound. One NACL per subnet; multiple SGs per instance.

---

### Card 8
**Q:** How are NACL rules evaluated?
**A:** NACL rules are evaluated in **ascending numerical order**, starting from the lowest rule number. The first rule that matches the traffic is applied, and evaluation stops. Rule `*` (asterisk/default) is evaluated last and denies everything not explicitly allowed. Best practice: number rules in increments of 100 (100, 200, 300) to allow insertion of new rules. Both inbound and outbound rules must be configured since NACLs are stateless.

---

### Card 9
**Q:** What is VPC Peering?
**A:** VPC Peering creates a private network connection between two VPCs using AWS's backbone (no public internet). Can be within the same account, cross-account, or cross-region. CIDRs **must not overlap**. Peering is **not transitive** — if VPC-A peers with VPC-B and VPC-B peers with VPC-C, A cannot talk to C through B. You must create a separate peering connection. Route table entries must be added in both VPCs. Security groups can reference peer VPC SGs (same region only).

---

### Card 10
**Q:** What is AWS Transit Gateway?
**A:** Transit Gateway (TGW) is a regional network hub that connects VPCs, VPN connections, Direct Connect gateways, and peered Transit Gateways. It supports **transitive routing** — solving the VPC peering scalability problem. Supports thousands of connections, route tables for segmentation, multicast, and inter-region peering. It uses a hub-and-spoke model. Supports ECMP (Equal Cost Multi-Path) for increased VPN bandwidth. Single point of management for complex network topologies.

---

### Card 11
**Q:** What are VPC Endpoints and what are the two types?
**A:** VPC Endpoints allow private connectivity to AWS services without traversing the internet, NAT, or VPN. **Gateway Endpoints** – free, support only S3 and DynamoDB, use route table entries, no ENI needed. **Interface Endpoints (PrivateLink)** – use ENIs with private IPs in your subnet, support most AWS services, cost per hour + per GB, can use security groups, support DNS resolution via private hosted zones. Gateway endpoints are preferred for S3/DynamoDB due to cost.

---

### Card 12
**Q:** How does a Gateway VPC Endpoint for S3 work?
**A:** A gateway endpoint is created in the VPC and associated with specific route tables. AWS automatically adds a route to the prefix list for S3 (`pl-xxxxxxxx`) pointing to the endpoint. Traffic from associated subnets to S3 is routed through the VPC endpoint, staying on the AWS private network. You can attach an **endpoint policy** to restrict which S3 buckets or actions are allowed. The S3 bucket policy can also use `aws:sourceVpce` to restrict access to the endpoint.

---

### Card 13
**Q:** What is AWS PrivateLink?
**A:** AWS PrivateLink provides private connectivity between VPCs, AWS services, and on-premises networks without exposing traffic to the public internet. It uses Interface VPC Endpoints backed by ENIs. PrivateLink can also expose your own services to other VPCs (service provider model) — you create a **Network Load Balancer** in the provider VPC, then a **VPC Endpoint Service** that consumers connect to via an interface endpoint. Traffic stays within the AWS network. No VPC peering, route tables, or NAT required.

---

### Card 14
**Q:** What are the Route 53 routing policies?
**A:** **Simple** – single resource, no health checks (can return multiple values). **Weighted** – distribute traffic by percentage. **Latency-based** – route to lowest-latency region. **Failover** – active-passive with health checks. **Geolocation** – route based on user's location (continent/country/state). **Geoproximity** – route based on geographic distance with bias values (requires Traffic Flow). **Multi-value** – return multiple healthy records (up to 8) with health checks. **IP-based** – route based on client IP CIDR ranges.

---

### Card 15
**Q:** What is the difference between Route 53 Geolocation and Geoproximity routing?
**A:** **Geolocation** routes based on the user's geographic location (continent, country, or US state). Users in Germany → EU endpoint. It does NOT consider distance — it's a discrete mapping. A default record catches unmapped locations. **Geoproximity** routes based on the physical distance between user and resource, with adjustable **bias** values to expand or shrink a resource's catchment area. Bias range: -99 to +99. Requires Route 53 Traffic Flow.

---

### Card 16
**Q:** What is a Route 53 health check?
**A:** Route 53 health checks monitor endpoint health and can trigger DNS failover. Types: **Endpoint health check** (monitor IP/domain, protocol HTTP/HTTPS/TCP, threshold configurable), **Calculated health check** (combine multiple child checks with AND/OR/threshold logic), **CloudWatch alarm health check** (based on CloudWatch alarm state). Health checkers are distributed globally. For private resources, use CloudWatch alarms since health checkers can't access private IPs.

---

### Card 17
**Q:** What is Amazon CloudFront?
**A:** CloudFront is a global CDN with 400+ edge locations. It caches content at edge locations to reduce latency. Supports static (S3) and dynamic content, WebSocket, and HTTP methods. Origins: S3 bucket, ALB, EC2, custom HTTP server. Features: HTTPS, Origin Access Control (OAC) for S3, geo-restriction, field-level encryption, Lambda@Edge/CloudFront Functions, signed URLs/cookies, real-time logs. Default TTL is 24 hours. Integrates with Shield and WAF for DDoS protection.

---

### Card 18
**Q:** What is the difference between CloudFront Origin Access Control (OAC) and Origin Access Identity (OAI)?
**A:** Both restrict S3 access so content is served only through CloudFront. **OAI** (legacy) – creates a special CloudFront identity added to S3 bucket policy. Doesn't support KMS encryption, all S3 regions, or fine-grained permissions. **OAC** (recommended) – supports all S3 features including SSE-KMS, all regions, and granular permissions. OAC uses IAM service principal authorization. Migrate from OAI to OAC for new distributions.

---

### Card 19
**Q:** What is the difference between CloudFront signed URLs and signed cookies?
**A:** **Signed URLs** – provide access to individual files; the URL contains the policy. Use when clients don't support cookies or you want per-file access. **Signed cookies** – provide access to multiple restricted files; policy is in the cookie. Use for multiple files (e.g., all files under a path). Both support an expiration time, IP restrictions, and trusted key groups or signers. Don't confuse with S3 pre-signed URLs, which bypass CloudFront entirely.

---

### Card 20
**Q:** What is AWS Global Accelerator?
**A:** Global Accelerator provides two static anycast IP addresses that route traffic to optimal AWS endpoints globally via the AWS backbone network. It uses AWS edge locations as entry points. Supports ALB, NLB, EC2, and Elastic IPs. Benefits: consistent performance, instant regional failover, no caching (unlike CloudFront — it proxies TCP/UDP traffic). Use for non-HTTP use cases (gaming, IoT, VoIP) or when you need static IPs. Integrates with Shield for DDoS protection.

---

### Card 21
**Q:** What is the difference between CloudFront and Global Accelerator?
**A:** **CloudFront** – CDN that caches content at edge locations, ideal for HTTP/HTTPS static and dynamic content, reduces latency through caching. **Global Accelerator** – network layer service that proxies packets at the edge, no caching, uses the AWS global network for faster routing, provides static IP addresses, supports TCP/UDP. Use CloudFront for cacheable content; use Global Accelerator for non-HTTP, static IPs, deterministic failover, or gaming/VoIP.

---

### Card 22
**Q:** What is AWS VPN (Site-to-Site VPN)?
**A:** Site-to-Site VPN creates an encrypted IPsec tunnel between on-premises network and AWS VPC over the public internet. Components: **Virtual Private Gateway (VGW)** on the AWS side, **Customer Gateway (CGW)** on the on-premises side. Supports static and dynamic (BGP) routing. Each VPN connection has two tunnels for redundancy (across different AZs). Bandwidth: up to ~1.25 Gbps per tunnel. Quick to set up (minutes). Use ECMP with Transit Gateway for higher throughput.

---

### Card 23
**Q:** What is AWS Direct Connect?
**A:** Direct Connect (DX) provides a dedicated, private network connection from on-premises to AWS via a DX location (colocation facility). Benefits: consistent network performance, reduced bandwidth costs, private connectivity. Port speeds: 1 Gbps, 10 Gbps, or 100 Gbps (dedicated); 50 Mbps to 10 Gbps (hosted). Lead time: weeks to months. **Not encrypted by default** — add VPN over DX for encryption. Supports **Virtual Interfaces**: Public VIF (access public AWS services), Private VIF (access VPC), Transit VIF (access Transit Gateway).

---

### Card 24
**Q:** What are the types of Direct Connect virtual interfaces?
**A:** **Private VIF** – connects to a single VPC via Virtual Private Gateway. **Public VIF** – access all AWS public services (S3, DynamoDB, etc.) over DX instead of the internet. **Transit VIF** – connects to one or more VPCs via Transit Gateway, enabling transitive routing to many VPCs with a single DX connection. Each VIF type serves a different connectivity need. A single DX connection can host multiple VIFs.

---

### Card 25
**Q:** How do you achieve high availability with Direct Connect?
**A:** **Maximum resiliency** – separate DX connections at separate DX locations (two locations, two connections each = 4 connections). **High resiliency** – two DX connections at the same DX location. **Economy resiliency** – one DX connection with a Site-to-Site VPN backup. For critical workloads, AWS recommends at least two connections at different DX locations. DX itself is not redundant — you must design redundancy.

---

### Card 26
**Q:** What is a Direct Connect Gateway?
**A:** A Direct Connect Gateway is a globally available resource that enables you to connect your DX connection to VPCs in **multiple regions** (same or different accounts) through a single Private VIF or Transit VIF. Without a DX Gateway, a Private VIF can only connect to one VPC in one region. DX Gateway does not allow VPC-to-VPC traffic — it's for on-premises to VPC connectivity.

---

### Card 27
**Q:** What are VPC Flow Logs?
**A:** VPC Flow Logs capture IP traffic information for network interfaces in your VPC. Can be enabled at three levels: **VPC**, **Subnet**, or **ENI**. Logs include: source/dest IP, ports, protocol, packets, bytes, action (ACCEPT/REJECT), and timestamps. Destinations: CloudWatch Logs, S3, or Kinesis Data Firehose. Flow Logs do NOT capture: DNS traffic to Route 53 Resolver, DHCP, metadata (169.254.169.254), or AWS NTP traffic.

---

### Card 28
**Q:** What is an Elastic Network Interface (ENI)?
**A:** An ENI is a virtual network card attached to an EC2 instance. Attributes: primary private IPv4, one or more secondary IPv4s, one Elastic IP per private IP, one public IP, one or more security groups, a MAC address, source/destination check flag. ENIs can be moved between instances (same AZ) for failover. Each instance has a primary ENI (eth0) that cannot be detached. Additional ENIs can be in different subnets (same AZ).

---

### Card 29
**Q:** What is an Elastic IP address?
**A:** An Elastic IP (EIP) is a static, public IPv4 address that you own until you release it. It can be mapped to one instance or ENI. Use cases: mask instance failure by remapping the EIP to another instance. You are charged if the EIP is **not associated** with a running instance. Limit: 5 EIPs per region (soft limit). Best practice: use a DNS name (Route 53) or a load balancer instead of EIPs where possible.

---

### Card 30
**Q:** What are placement groups and their types?
**A:** **Cluster** – packs instances close together in a single AZ for low-latency, high-throughput (10 Gbps between instances). Good for HPC, big data jobs. **Spread** – places instances on distinct hardware (max 7 per AZ per group), reducing correlated failures. Good for critical instances. **Partition** – instances are spread across logical partitions (different racks); up to 7 partitions per AZ. Good for distributed workloads like HDFS, Cassandra, Kafka. Partitions don't share racks.

---

### Card 31
**Q:** What are Route 53 alias records?
**A:** Alias records are a Route 53 extension to DNS. They map a hostname to an AWS resource (ALB, CloudFront, S3 website, API Gateway, Elastic Beanstalk, VPC endpoint, Global Accelerator). Unlike CNAME records, alias records work at the **zone apex** (naked domain, e.g., `example.com`). They're free for queries to AWS resources, support health checks (except S3 website), and are always of type A or AAAA. You cannot create an alias to an EC2 DNS name.

---

### Card 32
**Q:** What is the difference between CNAME and Alias records in Route 53?
**A:** **CNAME** – maps one hostname to another hostname. Cannot be used at the zone apex (e.g., `example.com`). Costs per query. Works with any DNS provider. **Alias** – Route 53-specific, maps hostname to an AWS resource. Can be used at the zone apex. Free for AWS resource queries. Supports health checks. Automatically recognizes IP changes of the target resource. Always prefer Alias for AWS resource targets.

---

### Card 33
**Q:** What is the Route 53 TTL (Time to Live)?
**A:** TTL is the time (in seconds) that DNS resolvers cache a record before querying Route 53 again. **High TTL** (e.g., 86400 = 24h) – less DNS traffic, possibly stale records. **Low TTL** (e.g., 60s) – more DNS traffic/cost, records update quickly. TTL is mandatory for non-alias records. Alias records have TTL automatically set by Route 53 based on the target resource. Set low TTL before planned DNS changes, then increase after.

---

### Card 34
**Q:** How does Route 53 failover routing work?
**A:** Create two records: **Primary** (associated with a health check) and **Secondary** (failover target). Route 53 returns the primary record while the health check is healthy. When the primary fails, Route 53 automatically returns the secondary record. The secondary can be another AWS resource, a static S3 website (maintenance page), or another region's endpoint. Common pattern for active-passive disaster recovery setups.

---

### Card 35
**Q:** What is AWS Network Firewall?
**A:** AWS Network Firewall is a managed firewall service for VPCs. It provides fine-grained network traffic control using stateful and stateless rules. Supports protocol inspection, domain filtering (allow/deny specific FQDNs), IPS/IDS with Suricata-compatible rules, and deep packet inspection. Deployed in a dedicated firewall subnet. Use it for filtering traffic at the VPC perimeter (ingress, egress, east-west). Integrates with Firewall Manager for multi-account management. Supports centralized deployment via Transit Gateway.

---

### Card 36
**Q:** What is the difference between a public and private hosted zone in Route 53?
**A:** **Public hosted zone** – contains records for routing internet traffic to your domain (e.g., `example.com`). Accessible from the public internet. **Private hosted zone** – contains records for routing traffic within one or more VPCs (e.g., `internal.example.com`). Only accessible from associated VPCs. Requires `enableDnsHostnames` and `enableDnsSupport` on the VPC. You can have overlapping namespaces (private zone takes precedence within VPC).

---

### Card 37
**Q:** What are the types of Elastic Load Balancers?
**A:** **ALB (Application LB)** – Layer 7, HTTP/HTTPS/WebSocket, path/host/header routing, target groups. **NLB (Network LB)** – Layer 4, TCP/UDP/TLS, ultra-low latency, millions of requests/sec, static IP per AZ, preserves source IP. **GLB (Gateway LB)** – Layer 3 (IP protocol), for inline traffic inspection with third-party virtual appliances (GENEVE protocol, port 6081). **CLB (Classic LB)** – legacy, supports Layer 4 and basic Layer 7. Cross-zone load balancing is always on for ALB, optional for NLB.

---

### Card 38
**Q:** What is cross-zone load balancing?
**A:** Cross-zone load balancing distributes traffic evenly across all registered targets in all enabled AZs, regardless of which AZ the traffic enters. **Without it**: traffic is distributed evenly across AZs (not instances), leading to imbalances if AZs have different numbers of targets. **ALB**: always enabled, free. **NLB/GLB**: disabled by default, charges apply when enabled. **CLB**: disabled by default, free if enabled.

---

### Card 39
**Q:** What is connection draining (deregistration delay)?
**A:** When an instance is deregistered from a target group or fails health checks, connection draining allows in-flight requests to complete before the instance is fully removed. The default is **300 seconds** (configurable 0-3600). During this period, the ELB stops sending new requests to the deregistering instance but allows existing connections to finish. Set to 0 to disable (immediately close connections). Short values for short-lived requests.

---

### Card 40
**Q:** What is an ALB target group?
**A:** An ALB target group is a logical grouping of targets that receive traffic from the ALB. Target types: **instance** (EC2 instance ID), **IP** (private IP, including IPs outside the VPC), **Lambda** (Lambda function). ALB supports multiple target groups with rule-based routing (path-based, host-based, query string, HTTP header, source IP). Health checks are configured per target group. A single ALB can route to multiple target groups.

---

### Card 41
**Q:** How does path-based routing work with ALB?
**A:** ALB listener rules can route requests based on the URL path. Example: `/api/*` → API target group, `/images/*` → static content target group, default → web server target group. Rules are evaluated in priority order (lowest number first). Each rule has conditions (path, host, headers, etc.) and actions (forward, redirect, fixed response). This enables microservices architecture with a single ALB.

---

### Card 42
**Q:** What is a sticky session (session affinity) on ALB?
**A:** Sticky sessions ensure a client is always routed to the same target instance. ALB supports: **Duration-based cookies** (AWSALB cookie generated by ALB, configurable expiry) and **Application-based cookies** (custom cookie name, set by the application). Stickiness is configured at the target group level. Can cause uneven load distribution. For NLB, flow hash algorithm naturally provides stickiness for TCP connections.

---

### Card 43
**Q:** What is Server Name Indication (SNI) and which load balancers support it?
**A:** SNI allows multiple TLS certificates on a single IP/listener. The client specifies the target hostname in the TLS handshake, and the server selects the matching certificate. **ALB** and **NLB** support SNI — you can attach multiple certificates to a single HTTPS/TLS listener. **CLB** does not support SNI — you need one CLB per certificate. CloudFront also supports SNI for HTTPS.

---

### Card 44
**Q:** What is an Egress-Only Internet Gateway?
**A:** An Egress-Only IGW allows **IPv6-only outbound** traffic from a VPC to the internet while preventing inbound connections. It's the IPv6 equivalent of a NAT Gateway (which only works with IPv4). Since all IPv6 addresses are public, this gateway ensures private instances can initiate outbound IPv6 connections without being reachable from the internet. Free to use; must be added to route tables.

---

### Card 45
**Q:** What is VPC DNS resolution and the key settings?
**A:** Two VPC attributes control DNS: **enableDnsSupport** (default: true) – enables the Amazon-provided DNS server at VPC base +2 (e.g., 10.0.0.2). If true, instances can resolve DNS names. **enableDnsHostnames** (default: false for custom VPCs, true for default VPC) – assigns public DNS hostnames to instances with public IPs. Both must be true for Route 53 private hosted zones to work and for VPC endpoints to use private DNS names.

---

### Card 46
**Q:** What is Traffic Mirroring?
**A:** VPC Traffic Mirroring copies network traffic from an ENI of an EC2 instance to a target (another ENI or NLB) for content inspection, threat monitoring, or troubleshooting. Unlike Flow Logs (metadata only), mirroring captures **full packets**. You define mirror sessions, filters (accept/reject by protocol/port/CIDR), and targets. Works within the same VPC, across VPCs via peering/TGW. Supports truncation to capture only packet headers.

---

### Card 47
**Q:** How does IPv6 work in a VPC?
**A:** Every IPv6 address in AWS is publicly routable (no private IPv6). VPCs support dual-stack (IPv4 + IPv6). IPv6 CIDR is /56 from Amazon's pool. Subnets get /64. Instances get both IPv4 and IPv6 addresses. For IPv6 internet access: use IGW (public subnets) or Egress-Only IGW (private subnets, outbound only). NAT Gateway does NOT support IPv6. Security Groups and NACLs have separate rules for IPv6. IPv6 must be enabled explicitly on the VPC.

---

### Card 48
**Q:** What are Route 53 Resolver Endpoints?
**A:** Route 53 Resolver handles DNS for your VPC. **Inbound Endpoint** – allows on-premises DNS resolvers to forward queries to Route 53 Resolver (resolve AWS hostnames from on-premises). **Outbound Endpoint** – allows Route 53 Resolver to forward queries to on-premises DNS resolvers (resolve on-premises hostnames from VPC). Conditional forwarding rules define which domains are forwarded where. Each endpoint needs 2+ IPs across AZs. Works over VPN or Direct Connect.

---

### Card 49
**Q:** What is a Transit Gateway Route Table and how does segmentation work?
**A:** Transit Gateway uses route tables to control which attachments (VPCs, VPNs, DX) can communicate. Default: all attachments share one route table (full mesh). For segmentation: create multiple route tables and associate different attachments. Example: isolate production VPCs from development VPCs while both share access to a shared-services VPC. This enables network domains/segments without complex peering. Supports both static routes and BGP propagation.

---

### Card 50
**Q:** What is a VPC Reachability Analyzer?
**A:** VPC Reachability Analyzer is a network diagnostics tool that tests connectivity between a source and destination in your VPC without sending actual packets. It analyzes the VPC configuration (route tables, SGs, NACLs, peering, endpoints) and produces a hop-by-hop path analysis. If the path is not reachable, it identifies the blocking component. Useful for troubleshooting connectivity issues and verifying network intent. It's a configuration analysis tool, not a traffic testing tool.

---

*End of Deck 2 — 50 cards*
