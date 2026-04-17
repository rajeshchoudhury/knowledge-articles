# AWS SAP-C02 Practice Test 36 — Advanced Networking

> **Theme:** Transit Gateway routing, BGP, Direct Connect resiliency, Network Firewall inspection, VPC Lattice  
> **Questions:** 75 | **Time Limit:** 180 minutes  
> **Domain Distribution:** D1 ≈ 20 | D2 ≈ 22 | D3 ≈ 11 | D4 ≈ 9 | D5 ≈ 13

---

### Question 1
A global financial services company operates in 12 AWS Regions. Each Region has 5–10 VPCs for different business units. The networking team needs to route traffic between any two VPCs across Regions while maintaining centralized packet inspection through AWS Network Firewall in the us-east-1 Region. They also need to enforce a default-deny policy for inter-Region traffic. How should the solutions architect design this?

A) Create a full mesh of VPC peering connections across all Regions and deploy Network Firewall in each VPC.  
B) Deploy an AWS Transit Gateway in each Region with inter-Region peering, use Transit Gateway route tables to route all inter-Region traffic through a centralized inspection VPC in us-east-1 that contains Network Firewall, and configure blackhole routes as the default.  
C) Use AWS PrivateLink to connect all VPCs across Regions and deploy a centralized proxy fleet for inspection.  
D) Deploy a single Transit Gateway in us-east-1, attach all VPCs from all Regions directly, and enable Network Firewall on the Transit Gateway.

**Correct Answer: B**
**Explanation:** Transit Gateway (TGW) inter-Region peering enables transitive routing between Regions. By deploying a TGW per Region and peering them, you can route all inter-Region traffic through a centralized inspection VPC in us-east-1 using TGW route table configurations. Blackhole routes serve as the default-deny policy — only explicitly allowed routes reach the inspection VPC. Option A doesn't scale (VPC peering is not transitive and has limits). Option C is for service-level connectivity, not network-level routing. Option D is wrong because a TGW cannot span Regions or have VPCs from other Regions attached directly.

---

### Question 2
A company has an on-premises data center connected to AWS via two AWS Direct Connect connections at different DX locations for redundancy. The primary connection is 10 Gbps and the secondary is 1 Gbps. They want to ensure that if the primary link fails, failover to the secondary happens within seconds, not minutes. Currently, BGP failover takes approximately 90 seconds. What should the architect recommend?

A) Enable BFD (Bidirectional Forwarding Detection) on both Direct Connect virtual interfaces and configure BFD on the on-premises routers to reduce the failover detection time to sub-second.  
B) Reduce the BGP hold timer to 10 seconds on both the AWS and on-premises routers.  
C) Configure ECMP (Equal-Cost Multi-Path) across both Direct Connect connections so traffic automatically uses both paths.  
D) Set up a Site-to-Site VPN as a third backup and use BGP MED values to prefer it over the 1 Gbps DX link.

**Correct Answer: A**
**Explanation:** BFD (Bidirectional Forwarding Detection) provides sub-second failure detection for Direct Connect links. When BFD detects link failure, it immediately notifies BGP to withdraw routes, triggering near-instant failover. AWS supports BFD on Direct Connect virtual interfaces. Option B reduces failover time but still takes 10+ seconds (3x hold timer = 30 seconds for detection). Option C doesn't address failover speed, and ECMP across DX connections of different bandwidths leads to asymmetric utilization. Option D adds unnecessary complexity and VPN throughput is much lower than DX.

---

### Question 3
A media company is deploying a content delivery architecture. They have a VPC with video transcoding instances that need to communicate with a shared services VPC containing authentication and logging services. Both VPCs are in the same Region but belong to different AWS accounts. The company wants to minimize the blast radius of network changes and ensure that only specific services are exposed between VPCs. What approach best meets these requirements?

A) Create a VPC peering connection between the two VPCs and use security groups to restrict access to specific services.  
B) Use AWS VPC Lattice to create a service network, register the authentication and logging services as target groups, and associate both VPCs with the service network using auth policies.  
C) Deploy a Transit Gateway, attach both VPCs, and create route table entries to allow traffic between specific CIDR ranges.  
D) Set up AWS PrivateLink with an NLB in the shared services VPC and create VPC endpoints in the media VPC.

**Correct Answer: B**
**Explanation:** VPC Lattice is purpose-built for service-to-service connectivity across VPCs and accounts. It allows you to define a service network, register specific services, and apply fine-grained auth policies (IAM-based) without exposing the entire VPC CIDR. This minimizes blast radius because only registered services are reachable. Option A exposes both full VPC CIDRs to each other. Option C provides network-level connectivity without service-level granularity. Option D works but requires managing NLBs and endpoint interfaces per service, adding operational overhead that VPC Lattice eliminates.

---

### Question 4
An enterprise runs a hybrid architecture with 50 VPCs connected through a Transit Gateway and an on-premises network connected via Direct Connect Gateway. They discover that instances in a development VPC can reach production databases because both VPCs are in the same Transit Gateway route table. They need to isolate development from production while still allowing both to reach shared services (DNS, logging, monitoring). What is the most scalable approach?

A) Create separate Transit Gateway route tables for production and development. Associate production VPCs with the production route table and development VPCs with the development route table. Create a shared-services route table and propagate shared-services VPC routes to both.  
B) Remove the development VPCs from the Transit Gateway and use VPC peering for development-to-shared-services connectivity.  
C) Implement network ACLs on the production VPC subnets to block all traffic from development VPC CIDRs.  
D) Deploy AWS Network Firewall in every VPC and create deny rules for cross-environment traffic.

**Correct Answer: A**
**Explanation:** Transit Gateway route table segmentation is the standard, scalable approach for network isolation. By creating separate route tables (production, development, shared-services), you control which VPCs can communicate. Production and development VPCs each get their own route table with routes only to shared services, not to each other. Option B breaks the centralized management model and doesn't scale. Option C is error-prone with 50 VPCs and requires constant CIDR management. Option D is expensive and operationally heavy for simple isolation.

---

### Question 5
A healthcare company must ensure that all traffic between their VPCs and on-premises data center is encrypted in transit, even over Direct Connect. They currently use a 10 Gbps dedicated Direct Connect connection. The solution must not significantly reduce throughput. What should the architect recommend?

A) Set up a Site-to-Site VPN over the Direct Connect public virtual interface using the internet as a backup path.  
B) Enable MACsec encryption on the Direct Connect connection at a MACsec-capable DX location, ensuring both the customer router and AWS port support MACsec.  
C) Use a transit VIF with a Direct Connect Gateway and enable IPsec on the Transit Gateway.  
D) Terminate the Direct Connect connection and replace it with multiple Site-to-Site VPN connections using ECMP.

**Correct Answer: B**
**Explanation:** MACsec (IEEE 802.1AE) provides Layer 2 encryption on Direct Connect at line rate with negligible throughput impact. It encrypts traffic between the customer router and the AWS DX device. This is the only option that encrypts Direct Connect traffic without reducing throughput. Option A provides encryption but VPN throughput is limited to ~1.25 Gbps per tunnel. Option C — Transit Gateway supports IPsec VPN but again with bandwidth limitations. Option D eliminates the 10 Gbps DX benefit entirely.

---

### Question 6
A SaaS provider needs to offer their application as a private service to hundreds of customers, each in their own AWS account. The provider wants to control which customers can access the service and ensure no data traverses the public internet. Customers should be able to access the service using private IP addresses within their VPCs. Which design meets these requirements with the LEAST operational overhead?

A) Create a VPC peering connection with each customer's VPC and use security groups to restrict access.  
B) Deploy the application behind a Network Load Balancer, create a VPC Endpoint Service (AWS PrivateLink), and manage customer access through endpoint service permissions (allowlisted AWS accounts).  
C) Deploy a Transit Gateway and share it with customer accounts using AWS RAM, then attach each customer VPC.  
D) Publish the application on a public ALB and restrict access using WAF rules with customer IP allowlists.

**Correct Answer: B**
**Explanation:** AWS PrivateLink (VPC Endpoint Services) is designed exactly for this use case — exposing a service to other AWS accounts privately. The provider deploys an NLB, creates an endpoint service, and allowlists customer account IDs. Customers create interface VPC endpoints in their VPCs to access the service via private IPs. Traffic stays on the AWS network. Option A doesn't scale to hundreds of customers (VPC peering limits and operational burden). Option C shares network infrastructure, which is a security concern for multi-tenant SaaS. Option D uses public internet, violating the requirement.

---

### Question 7
A company is migrating from a traditional hub-and-spoke network to AWS. They have 200 VPCs and need centralized egress through NAT Gateways for cost optimization and security monitoring. The egress VPC should inspect all outbound traffic using AWS Network Firewall before it reaches the internet. Traffic from spoke VPCs must not be able to bypass the inspection. How should this be designed?

A) Deploy a NAT Gateway in each spoke VPC and use VPC Flow Logs for monitoring.  
B) Create an egress VPC with Network Firewall and NAT Gateways. Attach all VPCs to a Transit Gateway. Use TGW appliance mode on the egress VPC attachment, configure TGW route tables to send 0.0.0.0/0 from spoke VPCs to the egress VPC, and use Network Firewall subnet route tables to route through the firewall endpoints before NAT.  
C) Use AWS Internet Gateway in each spoke VPC with VPC route table entries that force traffic through a central proxy server.  
D) Deploy a Gateway Load Balancer in the egress VPC and use Gateway Load Balancer endpoints in each of the 200 spoke VPCs.

**Correct Answer: B**
**Explanation:** The centralized egress pattern uses a dedicated egress VPC with Network Firewall for inspection and NAT Gateways for internet access. The Transit Gateway routes all 0.0.0.0/0 traffic from spoke VPCs to the egress VPC. Appliance mode ensures symmetric routing through the firewall. Spoke VPCs have no IGW or NAT Gateway, so traffic cannot bypass inspection. Option A decentralizes egress (no inspection, higher cost). Option C requires IGWs in spokes which allows bypass. Option D requires GWLB endpoints in all 200 VPCs, which is operationally heavy and expensive.

---

### Question 8
A multinational bank operates in AWS Regions across North America, Europe, and Asia-Pacific. They need a private network backbone that provides deterministic latency between Regions for their trading application. Inter-Region traffic must not traverse the public internet. They also need to connect their on-premises data centers in New York and London. What architecture should the architect design?

A) Use VPC peering between all VPCs across Regions and connect on-premises via Site-to-Site VPN.  
B) Deploy Transit Gateways in each Region with inter-Region peering, connect on-premises data centers via Direct Connect Gateway with transit VIFs to the Transit Gateways, and leverage the AWS global network for inter-Region traffic.  
C) Use AWS Cloud WAN with a global network policy to define segments and connect all Regions and on-premises sites, using Direct Connect Gateway for on-premises connectivity.  
D) Set up dedicated MPLS circuits between AWS Regions and connect on-premises via Direct Connect.

**Correct Answer: C**
**Explanation:** AWS Cloud WAN provides a centrally managed global network. It automates the creation and management of a backbone across Regions with network policies, segments for isolation (e.g., trading vs. corporate), and integrates with Direct Connect Gateway for on-premises connectivity. It uses the AWS global network backbone for deterministic latency. Option B works but requires manual TGW peering management across many Regions and lacks centralized policy management. Option A doesn't scale and VPC peering doesn't provide a network backbone. Option D — you cannot get MPLS circuits between AWS Regions.

---

### Question 9
A company has deployed AWS Network Firewall in their inspection VPC. They notice that stateful rule evaluation is causing asymmetric routing issues when traffic flows through different Availability Zones. Some connections are being dropped because the return path goes through a different firewall endpoint than the original request. What should the architect do to fix this? (Select TWO.)

A) Enable Transit Gateway appliance mode on the VPC attachment for the inspection VPC.  
B) Deploy a single Network Firewall endpoint in one AZ and route all traffic through it.  
C) Ensure that the Network Firewall subnet route tables direct return traffic back through the same AZ's firewall endpoint using specific route table entries per AZ.  
D) Disable stateful rule evaluation and use only stateless rules.  
E) Replace Network Firewall with security groups and NACLs.

**Correct Answer: A, C**
**Explanation:** Asymmetric routing with Network Firewall occurs when request and response packets traverse different AZ firewall endpoints. Two fixes are needed: (1) Enable TGW appliance mode, which ensures that TGW sends traffic to the same AZ it came from for the VPC attachment, maintaining flow symmetry. (2) Configure AZ-specific route tables in the firewall subnets to route return traffic through the correct firewall endpoint. Option B creates a single point of failure. Option D defeats the purpose of stateful inspection. Option E removes deep packet inspection capability.

---

### Question 10
A retail company wants to deploy a multi-Region active-active architecture for their web application. They need DNS-based traffic routing with health checks, and they want to minimize the DNS resolution time for users globally. The architecture should automatically route users to the nearest healthy Region. Which combination of services should the architect use?

A) Amazon Route 53 with latency-based routing, health checks, and Amazon CloudFront with origin failover.  
B) AWS Global Accelerator with endpoint groups in each Region and health checks.  
C) Amazon Route 53 with geolocation routing and manual failover configuration.  
D) Third-party DNS provider with CNAME records pointing to Regional ALB endpoints.

**Correct Answer: A**
**Explanation:** Route 53 latency-based routing directs users to the Region with lowest latency. Health checks automatically remove unhealthy Regions from DNS responses. CloudFront with origin failover provides an additional layer — if the primary origin (Region) is unhealthy, CloudFront fails over to a secondary origin. This combination gives DNS-level and CDN-level resilience. Option B uses anycast IP (not DNS-based as required). Option C uses geolocation which doesn't optimize for latency and requires manual failover. Option D lacks integrated health checks and AWS-native failover.

---

### Question 11
A logistics company uses a Transit Gateway with 15 VPC attachments. They need to allow a partner company's VPC (in a different AWS account) to access only one specific VPC in their network — the API VPC. The partner should not be able to route to any other VPC. What is the correct Transit Gateway configuration?

A) Attach the partner's VPC to the Transit Gateway using AWS RAM sharing. Create a dedicated route table for the partner VPC attachment that only contains a route to the API VPC CIDR. Associate the partner attachment with this route table. Do not propagate the partner VPC routes to other route tables.  
B) Attach the partner's VPC to the Transit Gateway and use security groups on the API VPC instances to restrict access.  
C) Create a VPC peering connection directly between the partner VPC and the API VPC instead of using the Transit Gateway.  
D) Use a shared Transit Gateway route table for all attachments and add blackhole routes for all VPCs except the API VPC in a prefix list.

**Correct Answer: A**
**Explanation:** Transit Gateway route table isolation is the correct approach. By creating a dedicated route table for the partner attachment with only the API VPC CIDR, the partner can only route to the API VPC. Not propagating the partner's routes to other tables prevents other VPCs from routing to the partner. This is network-level isolation. Option B relies only on security groups (Layer 4) without network-level isolation. Option C bypasses the centralized TGW model and doesn't leverage existing infrastructure. Option D is error-prone — blackhole routes for many CIDRs are hard to maintain.

---

### Question 12
A company is deploying a third-party virtual firewall appliance from AWS Marketplace in an inspection VPC. They need to distribute traffic evenly across multiple firewall instances and ensure that traffic is returned to the original source after inspection. The solution must support any protocol and preserve the original source/destination IPs. Which service should they use?

A) Application Load Balancer with target groups pointing to firewall instances.  
B) Network Load Balancer with UDP/TCP listeners and cross-zone load balancing enabled.  
C) Gateway Load Balancer with Gateway Load Balancer Endpoints in the spoke VPCs, routing through the firewall appliances transparently.  
D) AWS Network Firewall deployed alongside the third-party appliances for traffic distribution.

**Correct Answer: C**
**Explanation:** Gateway Load Balancer (GWLB) is designed specifically for transparent inline inspection with third-party appliances. It uses GENEVE encapsulation to preserve original source/destination IPs and supports all protocols. GWLB endpoints in spoke VPCs route traffic through the inspection fleet transparently. After inspection, traffic is returned via the same GWLB path. Option A only supports HTTP/HTTPS and modifies headers. Option B doesn't preserve source IPs for all traffic flows and has protocol limitations. Option D — Network Firewall is a managed service, not a traffic distributor for third-party appliances.

---

### Question 13
An organization's network engineer notices that their Direct Connect BGP session keeps flapping, causing intermittent connectivity. The on-premises router shows the BGP hold timer expiring. The Direct Connect connection's physical metrics (light levels, CRC errors) are within normal range. What should the architect investigate first?

A) The on-premises router's CPU utilization — high CPU can prevent the router from processing BGP keepalive messages in time, causing the hold timer to expire.  
B) The AWS Direct Connect bandwidth utilization — congestion may be dropping BGP keepalive packets.  
C) The security group rules on the VGW — they may be blocking BGP (TCP port 179) packets.  
D) The VPC route table entries — incorrect routes may be causing BGP to reset.

**Correct Answer: A**
**Explanation:** When physical layer metrics are normal but BGP hold timers expire, the most common cause is the on-premises router being too busy to process BGP keepalives. High CPU utilization (from routing table churn, ACL processing, or other tasks) can delay keepalive processing past the hold timer threshold (default 90 seconds). Option B — AWS Direct Connect uses dedicated capacity, and BGP keepalives are small; congestion wouldn't selectively drop only keepalives. Option C — security groups don't apply to VGW/Direct Connect BGP sessions. Option D — VPC route tables don't affect the BGP control plane.

---

### Question 14
A company operates a three-tier application across multiple AZs. The web tier communicates with the application tier through an internal ALB. The security team requires that all east-west traffic between tiers be inspected by AWS Network Firewall. The architect must implement inspection without changing application code and with minimal latency impact. How should the traffic flow be designed?

A) Place Network Firewall between the web and application subnets using VPC route tables to force traffic through firewall endpoints, with separate route tables per subnet tier that route inter-tier traffic to the firewall.  
B) Deploy Network Firewall in a separate VPC and route all inter-tier traffic through a Transit Gateway to the inspection VPC and back.  
C) Use security groups and NACLs to filter east-west traffic, and enable VPC Flow Logs for monitoring.  
D) Deploy a host-based IDS/IPS agent on every EC2 instance for east-west traffic inspection.

**Correct Answer: A**
**Explanation:** Intra-VPC east-west inspection is achieved by deploying Network Firewall endpoints in dedicated subnets and using VPC route table entries to redirect inter-tier traffic through the firewall. The web tier subnet route table sends app-tier CIDR traffic to the firewall endpoint, and vice versa. This is transparent to applications and adds minimal latency (single-digit milliseconds). Option B adds significant latency by hair-pinning through a TGW and separate VPC. Option C provides filtering but not deep packet inspection. Option D requires agent installation and management on every instance.

---

### Question 15
A company has a Direct Connect connection with a public virtual interface used to access AWS public services (S3, DynamoDB). They want to restrict which AWS public IP prefixes are advertised over BGP to their on-premises router to reduce the routing table size. What should they do?

A) Use a BGP community tag to filter routes — AWS advertises public prefixes with specific BGP communities (e.g., 7224:8100 for same Region). Configure the on-premises router to filter incoming BGP routes based on these community values.  
B) Create an AWS prefix list and attach it to the Direct Connect public virtual interface.  
C) Modify the Direct Connect public VIF to specify which services should advertise their prefixes.  
D) Contact AWS Support to reduce the number of prefixes advertised to the Direct Connect connection.

**Correct Answer: A**
**Explanation:** AWS advertises public IP prefixes over Direct Connect public VIFs with BGP community tags indicating the Region and scope. For example, 7224:8100 means "routes from the same Region." On-premises routers can filter incoming BGP advertisements using these community values to accept only prefixes they need, reducing routing table size. Option B — prefix lists are for security groups and route tables, not Direct Connect BGP. Option C — you cannot selectively control which service prefixes are advertised on the AWS side. Option D — AWS doesn't offer per-customer prefix filtering for public VIFs.

---

### Question 16
A gaming company needs sub-millisecond latency between their game servers in a VPC and a Redis cluster. They want to use ElastiCache for Redis but are concerned about network latency introduced by traversing subnets and network interfaces. Which deployment configuration minimizes network latency?

A) Deploy ElastiCache in the same subnet as the game servers and enable cluster mode with multiple shards across AZs.  
B) Deploy ElastiCache in the same AZ as the game servers, use placement groups for the EC2 instances, and enable ElastiCache's data tiering feature.  
C) Use ElastiCache Serverless and rely on AWS to optimize placement.  
D) Deploy ElastiCache in a dedicated VPC with VPC peering to the game server VPC for network isolation.

**Correct Answer: B**
**Explanation:** To minimize network latency: (1) Same AZ eliminates cross-AZ network hops. (2) Placement groups (cluster placement group) position EC2 instances physically close together within the AZ, reducing network latency further. While ElastiCache nodes can't be placed in a placement group, the game server instances can be, and being in the same AZ as ElastiCache minimizes hops. Option A — cluster mode across AZs introduces cross-AZ latency for some operations. Option C — Serverless doesn't guarantee same-AZ placement. Option D — VPC peering adds an extra network hop.

---

### Question 17
A financial institution needs to connect four on-premises data centers to AWS. Each data center has its own Direct Connect connection. They want all data centers to be able to communicate through AWS (using AWS as a transit network) and also reach VPCs in three AWS Regions. What is the correct architecture?

A) Create a Direct Connect Gateway associated with a Virtual Private Gateway in each VPC. Attach each Direct Connect connection to the Direct Connect Gateway via private VIFs.  
B) Create a Direct Connect Gateway, associate it with Transit Gateways in each Region. Create transit VIFs from each Direct Connect connection to the Direct Connect Gateway. Enable inter-Region TGW peering for cross-Region VPC connectivity.  
C) Create four separate VPN connections, one from each data center to each Region's Transit Gateway.  
D) Use a single Direct Connect connection with four private VIFs, one per data center, and connect to each Region's VPC through the same VIF.

**Correct Answer: B**
**Explanation:** Direct Connect Gateway with Transit Gateway association is the correct architecture for multi-site, multi-Region connectivity. Transit VIFs connect each DX location to the DX Gateway, which routes to TGWs in each Region. TGW inter-Region peering enables cross-Region VPC communication. Critically, Direct Connect Gateway with TGW supports transitive routing, so on-premises data centers can communicate through AWS. Option A — VGW-based DX Gateway does NOT support transitive routing between on-premises sites. Option C — VPN has bandwidth limitations and doesn't leverage DX. Option D — you cannot share a single DX connection this way.

---

### Question 18
A company has deployed AWS Network Firewall with stateful rules that block access to known malicious domains. The security team wants to automatically update the domain blocklist whenever their threat intelligence feed publishes new indicators. The update must happen within 5 minutes of publication. What is the most operationally efficient solution?

A) Create an Amazon EventBridge rule that triggers a Lambda function every 5 minutes. The Lambda function polls the threat intelligence API, compares the results with the current Network Firewall rule group, and updates the domain list rule group using the AWS SDK.  
B) Manually update the Network Firewall rule group daily from the threat intelligence feed.  
C) Deploy a dedicated EC2 instance running a cron job that fetches the threat feed and updates Network Firewall rules via AWS CLI.  
D) Use AWS Config rules to monitor the Network Firewall configuration and trigger remediation when the domain list is outdated.

**Correct Answer: A**
**Explanation:** EventBridge scheduled rules with Lambda provide serverless, automated updates. Lambda polls the threat intelligence API, diffs against the current rule group, and uses the AWS SDK (UpdateRuleGroup API) to add new malicious domains. The 5-minute schedule meets the requirement. Option B is not automated. Option C uses EC2, which requires patching, monitoring, and is less operationally efficient than serverless. Option D — Config rules monitor configuration drift, not content freshness, and don't integrate with external threat feeds.

---

### Question 19
A company with a Transit Gateway peering setup between us-east-1 and eu-west-1 finds that traffic from an on-premises data center connected via Direct Connect in us-east-1 cannot reach VPCs in eu-west-1 through the TGW peering. The peering connection is active and VPCs in us-east-1 can reach VPCs in eu-west-1. What is the most likely issue?

A) Transit Gateway peering does not support transitive routing from Direct Connect through a TGW peer to a remote Region. The on-premises data center needs a separate Direct Connect or VPN connection in eu-west-1.  
B) The TGW route table in eu-west-1 is missing a route back to the on-premises CIDR via the peering attachment.  
C) The Direct Connect Gateway is not associated with the Transit Gateway in eu-west-1.  
D) BGP is not configured correctly on the on-premises router to advertise routes to eu-west-1.

**Correct Answer: B**
**Explanation:** Transit Gateway inter-Region peering DOES support transitive routing — traffic from Direct Connect can traverse the local TGW, cross the peering, and reach remote VPCs. However, both TGW route tables must have the correct static routes. The eu-west-1 TGW route table must have a route for the on-premises CIDR pointing to the peering attachment (routes are NOT automatically propagated across peering). Since VPC-to-VPC works, the peering is functional — the missing piece is the return/forward route for the on-premises CIDR in eu-west-1. Option A is incorrect — transitive routing IS supported. Options C and D are not relevant to the described symptom.

---

### Question 20
A healthcare organization needs to ensure that DNS resolution for private hosted zones works across 20 VPCs in multiple accounts. They also need on-premises DNS servers to resolve AWS private hosted zone records and vice versa. VPCs are connected via Transit Gateway. What is the correct DNS architecture?

A) Associate the private hosted zone with all 20 VPCs using cross-account authorization. Deploy Route 53 Resolver inbound and outbound endpoints in a shared-services VPC. Configure on-premises DNS to forward AWS domain queries to the inbound endpoint IPs. Create Resolver rules to forward on-premises domain queries to the on-premises DNS servers via the outbound endpoint.  
B) Deploy a custom DNS server (BIND) in each VPC that replicates zone data from the on-premises DNS.  
C) Enable DNS hostnames and DNS support in all VPCs and rely on the default VPC DNS resolver (AmazonProvidedDNS) for all resolution.  
D) Use Route 53 public hosted zones with restrictive IAM policies to simulate private DNS.

**Correct Answer: A**
**Explanation:** This is the standard hybrid DNS architecture. Private hosted zone multi-VPC association (with cross-account authorization) allows all VPCs to resolve private DNS records. Route 53 Resolver endpoints enable bidirectional DNS resolution between on-premises and AWS: inbound endpoints accept queries from on-premises DNS forwarders, and outbound endpoints forward queries to on-premises DNS servers. Option B is operationally complex and error-prone. Option C doesn't solve on-premises resolution of AWS private DNS. Option D uses public DNS, which is insecure for private resources.

---

### Question 21
A company wants to migrate their on-premises MPLS WAN to AWS Cloud WAN. They have offices in 6 countries connected to 3 data centers. The network must support segmentation (corporate, guest, IoT), centralized security policy, and integration with existing Direct Connect connections. What is the correct approach?

A) Deploy Transit Gateways manually in each Region, create separate route tables for each segment, and manage peering connections individually.  
B) Create an AWS Cloud WAN global network with a core network policy that defines three segments (corporate, guest, IoT). Create core network edge locations in the required Regions. Attach existing TGWs to Cloud WAN using TGW route table attachments. Connect Direct Connect Gateways to the core network.  
C) Use multiple Site-to-Site VPN connections to replace MPLS, terminating at Regional VPCs.  
D) Deploy SD-WAN appliances in AWS and manage the network through the SD-WAN controller.

**Correct Answer: B**
**Explanation:** AWS Cloud WAN provides centralized WAN management with policy-based segmentation. The core network policy defines segments (corporate, guest, IoT) with isolation rules. Existing Transit Gateways can be attached to Cloud WAN for gradual migration. Direct Connect integrates through DX Gateway to core network attachments. This replaces the MPLS WAN functionality with AWS-managed global backbone. Option A works but lacks centralized policy management and automation. Option C replaces dedicated bandwidth with VPN (lower reliability/throughput). Option D adds third-party complexity.

---

### Question 22
A company runs workloads in a VPC with a CIDR block of 10.0.0.0/16. They've exhausted all available IP addresses and cannot add a secondary CIDR from the same RFC 1918 range due to routing conflicts with their on-premises network (which uses 10.0.0.0/8). The workloads need to communicate with both on-premises resources and other VPCs. What should the architect do?

A) Create a new VPC with a non-overlapping CIDR (e.g., 100.64.0.0/16) and migrate all workloads.  
B) Add a secondary CIDR block from a different RFC 1918 range (e.g., 172.16.0.0/16) to the existing VPC, deploy new workloads in subnets using the secondary CIDR, and update route tables accordingly.  
C) Enable IPv6 on the VPC and migrate all workloads to use IPv6 addressing exclusively.  
D) Use AWS PrivateLink for all communication to eliminate the need for routable IP addresses.

**Correct Answer: B**
**Explanation:** VPCs support multiple CIDR blocks (up to 5 by default, extendable). Adding a secondary CIDR from a different range (172.16.0.0/16) that doesn't conflict with on-premises routing provides additional addresses without migration. New subnets use the secondary CIDR. Route tables in the VPC, Transit Gateway, and on-premises routers must be updated to include the new CIDR. Option A requires a full migration, which is disruptive. Option C — IPv6-only breaks compatibility with many services and on-premises systems. Option D — PrivateLink doesn't solve internal VPC addressing.

---

### Question 23
A financial services company has a Direct Connect connection using a private virtual interface to access their VPCs. They are planning to also access AWS public services (S3, DynamoDB) over Direct Connect instead of the internet. They want to keep the public and private traffic paths separate. What should they configure?

A) Create a public virtual interface on the same Direct Connect connection and configure BGP to advertise/receive AWS public IP prefixes for the desired Region.  
B) Use VPC endpoints (Gateway endpoints for S3 and DynamoDB) to route traffic through the existing private VIF.  
C) Create a new Direct Connect connection dedicated to public service access.  
D) Use a transit virtual interface to access both VPCs and public services through a Transit Gateway.

**Correct Answer: A**
**Explanation:** A single Direct Connect connection supports multiple virtual interfaces — you can have both private VIFs (for VPC access) and public VIFs (for AWS public services) simultaneously. The public VIF establishes a BGP session that advertises AWS public IP prefixes, allowing you to route S3/DynamoDB traffic over DX instead of the internet. Traffic paths are logically separated by VLAN (each VIF has its own VLAN tag). Option B — Gateway endpoints use the VPC's route to S3, not the DX public path directly. Option C — unnecessary; one DX supports multiple VIFs. Option D — transit VIFs access VPCs through TGW, not public services directly.

---

### Question 24
A company is implementing a zero-trust network architecture on AWS. They want to ensure that every service-to-service communication is authenticated and authorized, regardless of network location. They use ECS Fargate for their microservices. Which approach best implements zero-trust networking for these services?

A) Deploy all services in private subnets with restrictive security groups and NACLs.  
B) Use AWS VPC Lattice with IAM-based auth policies for service-to-service communication. Configure each service with a Lattice target group and define auth policies that require SigV4 authentication from specific IAM roles.  
C) Deploy an API Gateway in front of every microservice with API key validation.  
D) Use a third-party service mesh (Istio) on ECS for mTLS between all services.

**Correct Answer: B**
**Explanation:** VPC Lattice implements zero-trust for service-to-service communication by requiring IAM-based authentication (SigV4) on every request, regardless of network position. Auth policies define which IAM principals can access which services, enforcing identity-based access control. This is cloud-native and integrates with ECS Fargate. Option A is network-based security, not zero-trust (no identity verification). Option C adds API Gateway overhead for east-west traffic and uses API keys (not strong identity). Option D works but adds significant operational overhead with a third-party tool.

---

### Question 25
A media company streams live video from 50 global locations to an origin server in us-east-1. They use AWS Global Accelerator for the ingestion path. Users report intermittent quality drops during peak hours. The network team observes that some edge locations have higher packet loss than others. How should the architect improve reliability?

A) Add a secondary Global Accelerator with a different set of anycast IPs and implement client-side failover logic.  
B) Enable flow logs on Global Accelerator and use the data to identify and avoid problematic edge locations by configuring endpoint weights.  
C) Replace Global Accelerator with CloudFront for live video ingestion.  
D) Deploy regional NLBs in multiple AWS Regions as intermediary hops before the origin in us-east-1.

**Correct Answer: B**
**Explanation:** Global Accelerator flow logs identify edge locations with high packet loss. Endpoint group weights can be adjusted to shift traffic away from problematic paths. Additionally, Global Accelerator automatically routes around network issues on the AWS network, but edge-location-level issues may require endpoint weight tuning. Option A adds complexity without addressing the root cause. Option C — CloudFront is optimized for delivery (egress), not ingestion. Option D adds unnecessary network hops and latency.

---

### Question 26
A company has implemented centralized VPC egress through a shared egress VPC with NAT Gateways. They have 100 spoke VPCs connected via Transit Gateway. The finance team reports that NAT Gateway data processing charges are extremely high. The architect needs to reduce costs while maintaining the centralized egress model. Which actions should they take? (Select TWO.)

A) Analyze VPC Flow Logs to identify the top traffic consumers and evaluate whether S3 and DynamoDB traffic can be shifted to Gateway VPC endpoints in each spoke VPC, bypassing NAT Gateway.  
B) Replace NAT Gateways with NAT instances on smaller EC2 instance types.  
C) Implement VPC endpoints (Interface endpoints) for frequently accessed AWS services (STS, CloudWatch, ECR, etc.) in spoke VPCs to avoid routing that traffic through NAT Gateway.  
D) Increase the number of NAT Gateways to distribute the data processing charges.  
E) Disable NAT Gateway and use IPv6 egress-only internet gateways exclusively.

**Correct Answer: A, C**
**Explanation:** The biggest NAT Gateway cost driver is data processing charges per GB. Reducing the volume of traffic through NAT Gateway is the key strategy. (A) Gateway VPC endpoints for S3 and DynamoDB are free and bypass NAT entirely — these are typically the largest traffic volumes. (C) Interface VPC endpoints for frequently used AWS services (STS, CloudWatch, ECR, SSM, etc.) also bypass NAT Gateway, keeping traffic on the AWS network. Option B — NAT instances sacrifice availability and throughput. Option D — more NAT Gateways don't reduce per-GB charges. Option E — IPv6 migration is a major effort and many services/endpoints don't fully support IPv6-only.

---

### Question 27
An organization operates a hybrid network with Direct Connect and Site-to-Site VPN as backup. The VPN connection should only be used when Direct Connect fails. Currently, both paths are active, and traffic sometimes takes the VPN path. How should the architect ensure Direct Connect is always preferred when available?

A) Configure the on-premises router to advertise more specific routes (longer prefix lengths) over Direct Connect and less specific routes over VPN.  
B) On the on-premises router, set a higher local preference for routes received over Direct Connect than over VPN. On the AWS side, use longer AS path prepending on VPN-advertised routes.  
C) Remove the VPN connection and rely solely on Direct Connect with a second DX connection as backup.  
D) Use static routes on the VPN connection with lower priority than the BGP routes from Direct Connect.

**Correct Answer: B**
**Explanation:** AWS route preference follows: longest prefix match > static routes > BGP routes. For BGP-based selection between DX and VPN: local preference (on-premises) and AS path length (AWS side) control path selection. Setting higher local preference for DX routes on the on-premises router ensures outbound traffic prefers DX. On the AWS side, AS path prepending on VPN makes the VPN path appear longer/less preferred. Option A — more specific routes always win, but this creates an operational burden and doesn't allow proper failover. Option C removes the backup requirement. Option D — static routes actually take precedence over BGP in AWS route evaluation.

---

### Question 28
A company is deploying a multi-account architecture using AWS Organizations. They want to ensure that all VPCs across member accounts automatically get DNS resolution for a central set of private hosted zones managed by the networking account. New VPCs should be automatically associated without manual intervention. What should the architect implement?

A) Create a Lambda function triggered by AWS CloudTrail events for VPC creation. The function uses cross-account IAM roles to associate new VPCs with the private hosted zones in the networking account.  
B) Use AWS RAM to share the private hosted zones with the entire Organization.  
C) Create Route 53 Resolver rules in the networking account and share them via AWS RAM with the Organization. The rules forward DNS queries for the private domains to Route 53 Resolver inbound endpoints in the networking account.  
D) Deploy custom DNS servers in every account that replicate zone data from the central account.

**Correct Answer: C**
**Explanation:** Route 53 Resolver rules can be shared via AWS RAM with an entire Organization. When shared, new VPCs in member accounts automatically use these forwarding rules. The rules forward DNS queries for specific private domains to the inbound endpoints in the networking account, where the private hosted zones are resolved. This is fully automated. Option A works but requires custom automation. Option B — Route 53 private hosted zones cannot be shared directly via AWS RAM (only Resolver rules can be). Option D is operationally complex and not scalable.

---

### Question 29
A company has a VPC with a CIDR of 10.1.0.0/16 that overlaps with a recently acquired subsidiary's on-premises network (10.1.0.0/24). They must enable communication between the VPC and the subsidiary's network without re-addressing either side. What is the best approach?

A) Deploy a NAT instance in the VPC that translates the VPC CIDR to a non-overlapping range. Configure routing on both sides to use the translated addresses.  
B) Use AWS PrivateLink to expose specific services between the overlapping networks, bypassing the need for routable IP addresses.  
C) Deploy a Transit Gateway with a VPN attachment to the subsidiary's network and use NAT on the subsidiary's router.  
D) Assign an additional non-overlapping secondary CIDR to the VPC and configure the subsidiary to only communicate with the secondary CIDR range.

**Correct Answer: B**
**Explanation:** AWS PrivateLink enables service-level connectivity without requiring routable, non-overlapping IP addresses. The VPC deploys an NLB with the service, creates an endpoint service, and the subsidiary (once connected to AWS) creates an interface endpoint with a private IP from its own non-overlapping range. This avoids any re-addressing. Option A requires complex NAT configurations and doesn't scale. Option C still faces the overlapping CIDR routing issue even with a TGW. Option D only works if the subsidiary doesn't need to reach resources on the original 10.1.0.0/16 CIDR.

---

### Question 30
A large enterprise uses AWS Network Firewall to inspect traffic in their centralized inspection VPC. They have over 10,000 stateful rules for IDS/IPS. Performance has degraded, and connections are timing out. What should the architect recommend to improve performance?

A) Split the rules into multiple rule groups ordered by priority and use strict rule order evaluation to enable early exit when a match is found, reducing the number of rules evaluated per packet.  
B) Increase the Network Firewall capacity by deploying more firewall endpoints.  
C) Replace stateful rules with stateless rules for all traffic.  
D) Move to a third-party firewall appliance with higher throughput.

**Correct Answer: A**
**Explanation:** Network Firewall supports strict rule order evaluation, where rules are processed in priority order and evaluation stops at the first match (pass, drop, or alert). This significantly reduces per-packet processing compared to default action order (where all rules are evaluated). Organizing 10,000 rules into prioritized rule groups with the most common matches having higher priority ensures fast processing. Option B — adding endpoints helps with throughput but doesn't reduce per-packet rule evaluation time. Option C loses IDS/IPS capability. Option D doesn't solve the architectural issue of rule organization.

---

### Question 31
A company is planning to deploy a hybrid DNS architecture. Their on-premises DNS servers need to resolve AWS private hosted zone records, and AWS workloads need to resolve on-premises Active Directory DNS records. They have multiple VPCs connected to on-premises via Direct Connect and Transit Gateway. Where should the Route 53 Resolver endpoints be deployed?

A) Deploy inbound and outbound Resolver endpoints in every VPC to ensure DNS resolution availability.  
B) Deploy inbound and outbound Resolver endpoints in a centralized shared-services VPC connected to the Transit Gateway. Share Resolver rules with all accounts via AWS RAM.  
C) Deploy only inbound endpoints in the shared-services VPC and configure all VPCs to use on-premises DNS as their primary resolver.  
D) Use the default VPC DNS resolver (AmazonProvidedDNS) for all resolution without any Resolver endpoints.

**Correct Answer: B**
**Explanation:** Centralizing Resolver endpoints in a shared-services VPC avoids deploying and managing endpoints in every VPC. The shared-services VPC is connected to the Transit Gateway, providing reachability from all VPCs and on-premises. Inbound endpoints receive queries from on-premises DNS forwarders. Outbound endpoints forward queries from AWS to on-premises DNS. Sharing Resolver rules via RAM ensures all VPCs forward on-premises domain queries to the centralized outbound endpoints. Option A wastes resources. Option C makes AWS workloads dependent on on-premises DNS availability. Option D doesn't solve hybrid DNS requirements.

---

### Question 32
A company uses AWS Transit Gateway with a centralized inspection VPC containing AWS Network Firewall. They observe that during failover events, some flows are dropped because the firewall loses state information. The inspection VPC spans two AZs. What should the architect do to minimize connection drops during AZ failover?

A) Deploy active-active firewall endpoints in both AZs and enable cross-AZ state synchronization by using a Network Firewall policy with stream exception policy set to "continue."  
B) Deploy firewall endpoints in only one AZ to avoid state synchronization issues.  
C) Use a single large firewall endpoint with enhanced capacity in one AZ.  
D) Replace Network Firewall with stateless security groups for inspection.

**Correct Answer: A**
**Explanation:** AWS Network Firewall's stream exception policy setting determines behavior when a flow is handled by a firewall endpoint that doesn't have the flow state (e.g., after AZ failover). Setting it to "continue" allows mid-stream packets to pass through rather than being dropped, preventing connection resets during failover. Active-active endpoints in both AZs ensure traffic is always inspected. Option B creates a single point of failure. Option C — same single AZ failure problem. Option D loses stateful inspection capability.

---

### Question 33
A company wants to implement a hub-and-spoke network topology where all inter-VPC traffic is inspected. They have 50 spoke VPCs and want the inspection to happen in a centralized hub VPC. They use Transit Gateway. The architecture must ensure that traffic between any two spoke VPCs always traverses the inspection VPC. What routing configuration achieves this?

A) Create a single Transit Gateway route table and add all VPC attachments with route propagation enabled.  
B) Create two TGW route tables: a "spoke" route table with a default route (0.0.0.0/0) pointing to the inspection VPC attachment, and an "inspection" route table with routes propagated from all spoke VPC attachments. Associate spoke VPCs with the spoke route table and the inspection VPC with the inspection route table.  
C) Use VPC peering between each spoke VPC and the inspection VPC, and rely on VPC peering routes.  
D) Use Network Firewall in each spoke VPC instead of centralized inspection.

**Correct Answer: B**
**Explanation:** The dual-route-table pattern forces all inter-spoke traffic through the inspection VPC. The spoke route table has only a default route to the inspection VPC, so spoke VPCs send all traffic to the hub. The inspection route table has specific routes to each spoke VPC, so after inspection, traffic can reach its destination. This ensures no direct spoke-to-spoke routing exists. Option A enables direct spoke-to-spoke routing, bypassing inspection. Option C doesn't scale to 50 VPCs and VPC peering isn't transitive. Option D is expensive and operationally complex at scale.

---

### Question 34
A company running a multi-Region active-active application uses AWS Global Accelerator. They need to perform a blue-green deployment, gradually shifting traffic from the current (blue) environment in us-east-1 to the new (green) environment in us-west-2. How should they implement this?

A) Create two endpoint groups (one per Region) and use traffic dial settings to gradually shift traffic from the blue Region (starting at 100%) to the green Region (starting at 0%), incrementally adjusting the dial percentages.  
B) Update Route 53 weighted routing records to shift DNS-based traffic.  
C) Modify the Global Accelerator listener to remove the blue endpoint group and add the green one.  
D) Use CloudFront with origin failover to switch between Regions.

**Correct Answer: A**
**Explanation:** Global Accelerator traffic dials allow fine-grained control of traffic distribution across endpoint groups. By gradually reducing the blue Region's dial from 100% to 0% and increasing the green Region's dial from 0% to 100%, you achieve a controlled blue-green deployment. This is instantaneous (no DNS TTL wait) since Global Accelerator uses anycast IPs. Option B works but is slower due to DNS caching/TTL. Option C is an abrupt cutover, not gradual. Option D doesn't support traffic shifting between origins.

---

### Question 35
A company discovers that their cross-AZ data transfer costs within a single Region are unexpectedly high. They have an application with web servers, application servers, and databases distributed across three AZs for high availability. Which strategies should the architect recommend to reduce cross-AZ data transfer costs while maintaining high availability? (Select TWO.)

A) Consolidate all resources into a single AZ to eliminate cross-AZ charges.  
B) Enable cross-zone load balancing on the ALB and use AZ affinity (availability zone affinity feature) to prefer routing requests to targets in the same AZ as the receiving load balancer node.  
C) Use VPC endpoints for AWS service calls (S3, DynamoDB, SQS) to keep traffic within the AZ and avoid cross-AZ hops.  
D) Implement caching layers (ElastiCache) in each AZ to reduce cross-AZ database reads.  
E) Move the database to a single AZ and remove the Multi-AZ replica.

**Correct Answer: B, D**
**Explanation:** (B) ALB AZ affinity routes requests to targets in the same AZ as the receiving ALB node, reducing cross-AZ traffic between web and app tiers. (D) Caching in each AZ reduces the need for cross-AZ database queries — reads are served from the local cache. Both strategies reduce cross-AZ data transfer while maintaining multi-AZ high availability. Option A eliminates HA. Option C — Gateway VPC endpoints for S3/DynamoDB are free but don't address the main cross-AZ cost between tiers. Option E sacrifices database HA.

---

### Question 36
A large enterprise is transitioning from a legacy hub-and-spoke network using a third-party virtual router in a VPC to AWS Transit Gateway. They have 80 VPCs and need to perform the migration without downtime. What is the recommended migration approach?

A) Create the Transit Gateway and attach all 80 VPCs simultaneously, then remove the legacy routing.  
B) Deploy the Transit Gateway alongside the existing network. Migrate VPCs in batches by attaching them to the TGW, updating route tables to prefer TGW routes, verifying connectivity, then removing the legacy VPC peering or virtual router routes. Use blackhole routes on the TGW for VPCs not yet migrated.  
C) Create a new set of 80 VPCs with Transit Gateway from scratch and migrate workloads one at a time.  
D) Replace the virtual router with AWS Network Firewall and continue using the hub-and-spoke VPC peering model.

**Correct Answer: B**
**Explanation:** A phased migration with coexistence is the safest approach. Deploying TGW alongside the existing network allows parallel operation. Migrating VPCs in batches (attach to TGW, update routes, verify, remove legacy routes) limits blast radius. Blackhole routes on the TGW for not-yet-migrated VPCs prevent routing loops. This approach ensures zero downtime. Option A is risky — simultaneous cutover of 80 VPCs. Option C requires full workload migration, which is far more disruptive. Option D doesn't achieve the goal of migrating to Transit Gateway.

---

### Question 37
A company uses Direct Connect with a LAG (Link Aggregation Group) consisting of four 10 Gbps connections. They notice that one member link has significantly lower throughput than the others. What is the most likely cause and remediation?

A) The LAG hashing algorithm is distributing flows unevenly. The remediation is to use more, smaller flows to improve distribution across member links.  
B) One member link has physical layer issues (CRC errors, light level degradation). The remediation is to work with the DX location provider to check the fiber and optics on the affected member link.  
C) The LAG is exceeding its aggregate throughput. Add additional member links to the LAG.  
D) AWS is throttling one member link due to burst policies. Contact AWS Support to increase the burst limit.

**Correct Answer: B**
**Explanation:** When a single LAG member has lower throughput while others perform normally, it typically indicates physical layer problems on that specific link. CRC errors, optical signal degradation, or fiber issues on one member link reduce its effective throughput. The remediation is to check the physical infrastructure: fiber patch cables, SFP optics, and cross-connects at the DX location. Option A would affect all links equally, not just one. Option C — if aggregate was exceeded, all links would show high utilization. Option D — AWS doesn't throttle individual LAG members.

---

### Question 38
A company wants to deploy a service mesh for microservices running in Amazon ECS across multiple VPCs. They need encryption in transit between services, traffic management (retries, timeouts), and observability (distributed tracing). They want to minimize operational overhead. What should the architect recommend?

A) Deploy Istio service mesh on self-managed EC2 instances with manual sidecar injection.  
B) Use AWS App Mesh with Envoy sidecar proxies for traffic management, enable TLS using ACM-managed certificates, and integrate with AWS X-Ray for distributed tracing.  
C) Implement mTLS at the application level in each microservice code and use custom logging for tracing.  
D) Use VPC Lattice for all service-to-service communication with IAM auth policies.

**Correct Answer: B**
**Explanation:** AWS App Mesh with Envoy proxies provides traffic management (retries, timeouts, circuit breaking), mTLS for encryption in transit using ACM certificates (no manual certificate management), and integrates with X-Ray for distributed tracing. It works natively with ECS and requires minimal operational overhead compared to self-managed alternatives. Option A has high operational overhead (self-managed Istio). Option C requires code changes in every service. Option D provides auth and routing but doesn't include traffic management features like retries/timeouts or distributed tracing integration.

---

### Question 39
A company has VPCs in us-east-1 and eu-west-1 connected via Transit Gateway inter-Region peering. They want to enable private DNS resolution across Regions — services in eu-west-1 need to resolve private hosted zone records that are associated with VPCs in us-east-1. What should the architect configure?

A) Associate the private hosted zone with VPCs in both Regions (cross-Region VPC association is supported) so that Route 53 directly resolves the records in eu-west-1.  
B) Deploy Route 53 Resolver outbound endpoints in eu-west-1 and inbound endpoints in us-east-1. Create a forwarding rule in eu-west-1 that forwards the private domain queries to the inbound endpoints in us-east-1 over the Transit Gateway peering.  
C) Replicate the private hosted zone records into a new private hosted zone in eu-west-1.  
D) Use a custom DNS server in us-east-1 and configure all eu-west-1 VPCs to use it as their DNS resolver.

**Correct Answer: A**
**Explanation:** Route 53 private hosted zones support cross-Region VPC association. You can associate a private hosted zone with VPCs in any Region, not just the Region where the hosted zone was created. Once associated, the AmazonProvidedDNS in the eu-west-1 VPCs will resolve the private hosted zone records directly — no Resolver endpoints needed. Option B works but adds unnecessary complexity when cross-Region association solves the problem. Option C creates operational overhead of keeping two zones in sync. Option D creates a single point of failure and cross-Region DNS latency.

---

### Question 40
A streaming media company has a 100 Gbps Direct Connect connection using a hosted connection from a DX partner. They want to ensure resiliency against DX location failure. The maximum acceptable failover time is 30 seconds. The backup path must also use Direct Connect (not VPN). What should the architect recommend?

A) Order a second 100 Gbps Direct Connect hosted connection at the same DX location for local redundancy.  
B) Order a second 100 Gbps Direct Connect connection at a different DX location, configure both connections with the same Direct Connect Gateway, use BFD on both connections for sub-second failure detection, and configure BGP to prefer the primary with automatic failover.  
C) Use a LAG with four 25 Gbps connections at the primary DX location for redundancy.  
D) Order a 10 Gbps connection at a second DX location and use it as warm standby with manual failover.

**Correct Answer: B**
**Explanation:** To protect against DX location failure, the second connection must be at a different DX location. Both connections terminate on the same DX Gateway for unified routing. BFD provides sub-second failure detection (within the 30-second requirement). BGP configuration (local preference/AS path prepending) ensures the primary path is preferred while enabling automatic failover. Option A — same DX location doesn't protect against location failure. Option C — a LAG at the same location has the same single-location risk. Option D — 10 Gbps is insufficient backup for 100 Gbps, and manual failover exceeds 30 seconds.

---

### Question 41
A company has deployed an application that uses both IPv4 and IPv6 in a dual-stack VPC. They need to allow IPv6-only clients on the internet to access an internal service that only supports IPv4. The service runs on EC2 instances behind an NLB. What solution allows IPv6 internet clients to reach the IPv4-only service?

A) Deploy a NAT64/DNS64 solution using a NAT Gateway with DNS64 enabled and Route 53 Resolver.  
B) Deploy a dual-stack ALB or NLB with a dualstack internet-facing configuration. The load balancer accepts IPv6 traffic from clients and translates it to IPv4 when forwarding to the IPv4-only targets.  
C) Require all clients to use IPv4 — do not support IPv6 clients.  
D) Deploy a CloudFront distribution with IPv6 enabled that connects to the NLB origin via IPv4.

**Correct Answer: B**
**Explanation:** A dualstack-enabled internet-facing ALB/NLB accepts connections over both IPv4 and IPv6. It translates IPv6 client connections to IPv4 when communicating with IPv4-only backend targets. This is the simplest and most native solution. Option A — NAT64/DNS64 is for outbound connectivity from IPv6 VPC resources to IPv4 internet services, not inbound. Option C doesn't meet the requirement. Option D works but adds unnecessary CDN infrastructure for what is a protocol translation problem.

---

### Question 42
A company with a Transit Gateway network discovers that adding a new VPC attachment causes brief connectivity disruptions across all existing VPC attachments for 10-20 seconds. This is unacceptable for their real-time trading application. What should the architect recommend?

A) Migrate from Transit Gateway to full-mesh VPC peering to avoid the TGW control plane disruption.  
B) Use Transit Gateway Connect attachments instead of VPC attachments to reduce control plane impact.  
C) Schedule TGW changes during maintenance windows and notify application teams in advance. Ensure applications implement connection retry logic to handle the brief disruption gracefully.  
D) Deploy multiple Transit Gateways — one for production (no changes) and one for development/new attachments. Peer the two TGWs for connectivity.

**Correct Answer: D**
**Explanation:** Separating production from development/dynamic TGW operations prevents control plane activities from affecting production traffic. The production TGW remains stable with no attachment changes, while new VPCs are added to the development/staging TGW. TGW peering provides connectivity between the two. Option A doesn't scale and loses TGW benefits. Option B — Connect attachments have the same control plane behavior. Option C is a workaround, not a solution, and doesn't prevent disruption for real-time trading.

---

### Question 43
A company uses AWS Network Firewall with TLS inspection enabled to decrypt and inspect HTTPS traffic from their VPCs. They find that some SaaS applications (using certificate pinning) break when TLS inspection is active. How should the architect handle this?

A) Disable TLS inspection entirely to avoid breaking SaaS applications.  
B) Create a Network Firewall TLS inspection configuration with bypass rules for the specific domains that use certificate pinning, while continuing to inspect all other HTTPS traffic.  
C) Replace Network Firewall with a transparent proxy that doesn't perform TLS inspection.  
D) Ask the SaaS providers to disable certificate pinning for the company's traffic.

**Correct Answer: B**
**Explanation:** Network Firewall TLS inspection supports exception/bypass rules based on Server Name Indication (SNI). By adding bypass rules for domains that use certificate pinning (e.g., certain banking or SaaS application domains), those connections pass through without TLS termination, preserving the original certificate chain. All other HTTPS traffic continues to be inspected. Option A sacrifices all TLS inspection capability. Option C eliminates deep inspection. Option D is impractical — SaaS providers won't change their security for one customer.

---

### Question 44
A company's networking team wants to monitor and alert on all changes to their Transit Gateway route tables, VPC route tables, and security groups across 30 AWS accounts. They need real-time alerting when unauthorized changes occur. What should the architect implement?

A) Enable AWS CloudTrail in all accounts with an Organization trail. Create EventBridge rules that match API calls for route table and security group modifications. Route events to an SNS topic for alerting and a Lambda function for automated remediation.  
B) Use VPC Flow Logs to detect routing changes by analyzing traffic pattern changes.  
C) Deploy a custom monitoring agent on EC2 instances that periodically checks route table configurations.  
D) Use AWS Config rules to evaluate compliance and alert on non-compliant resources, checking every 24 hours.

**Correct Answer: A**
**Explanation:** CloudTrail captures all API calls (CreateRoute, ReplaceRoute, AuthorizeSecurityGroupIngress, etc.) across all accounts via an Organization trail. EventBridge rules provide real-time event matching — when a modification API is detected, events trigger SNS (alerting) and Lambda (remediation). This is real-time, serverless, and Organization-wide. Option B — Flow Logs show traffic, not configuration changes. Option C is not real-time and doesn't cover managed services. Option D — Config rules have evaluation delays and are periodic, not real-time.

---

### Question 45
A company uses a Transit Gateway with multiple VPC attachments. They need to ensure that EC2 instances in a specific VPC can only communicate with specific ports (443, 8443) on services in other VPCs. The Transit Gateway route tables currently allow full connectivity. Where should the architect implement the port-level restrictions?

A) On the Transit Gateway route tables — configure port-level filtering.  
B) Using security groups on the EC2 instances in the source VPC (outbound rules) and on the target service instances (inbound rules) to restrict to ports 443 and 8443.  
C) Using Network ACLs on the Transit Gateway subnets in the source VPC to allow only ports 443 and 8443.  
D) Deploy AWS Network Firewall in the inspection VPC with stateful rules allowing only ports 443 and 8443.

**Correct Answer: B**
**Explanation:** Transit Gateway operates at Layer 3 (IP routing) — it cannot filter by port. Security groups are the most straightforward way to enforce port-level restrictions. Outbound security group rules on the source instances restrict which ports they can connect to, and inbound rules on the target instances restrict which ports they accept connections on. Option A — TGW route tables don't support port filtering. Option C — NACLs on TGW subnets would affect all traffic, not just specific VPC-to-VPC flows, and are harder to manage. Option D works but adds complexity and cost for simple port restrictions.

---

### Question 46
A company is deploying a new Region for disaster recovery. They need their existing Direct Connect connection in us-east-1 to also provide connectivity to VPCs in us-west-2. The Direct Connect is already connected to a Transit Gateway in us-east-1 via a Direct Connect Gateway. What is the most efficient way to extend connectivity to us-west-2?

A) Order a new Direct Connect connection in a us-west-2 DX location.  
B) Associate the existing Direct Connect Gateway with a Transit Gateway in us-west-2. Establish Transit Gateway inter-Region peering between us-east-1 and us-west-2 TGWs. Traffic from on-premises can reach us-west-2 VPCs through the DX Gateway association.  
C) Create a VPN connection from on-premises to a VGW in us-west-2 as the DR connectivity path.  
D) Use VPC peering between us-east-1 and us-west-2 VPCs and route all traffic through us-east-1.

**Correct Answer: B**
**Explanation:** A Direct Connect Gateway can be associated with Transit Gateways in multiple Regions (up to 3 TGWs per DX Gateway). By associating the existing DX Gateway with a new TGW in us-west-2, on-premises traffic can reach us-west-2 VPCs directly through the DX Gateway — no additional physical connection needed. TGW inter-Region peering additionally enables VPC-to-VPC communication across Regions. Option A is unnecessary and expensive. Option C — VPN has lower bandwidth and reliability than DX. Option D doesn't provide direct on-premises to us-west-2 connectivity.

---

### Question 47
A company's application generates 5 TB of daily logs that are sent to a centralized logging VPC containing Elasticsearch. The log sources are in 40 spoke VPCs connected via Transit Gateway. The cross-AZ and cross-VPC data transfer costs are significant. How should the architect reduce these costs?

A) Deploy Elasticsearch nodes in every spoke VPC to eliminate cross-VPC data transfer.  
B) Deploy VPC endpoints (Interface endpoints) for the centralized logging service using AWS PrivateLink. Use a log aggregation agent (Fluentd/Fluent Bit) that compresses logs before sending. Co-locate log aggregation buffers in each spoke VPC to batch and compress data before transmission.  
C) Send all logs directly to Amazon S3 using Gateway VPC endpoints (free data transfer) and use Amazon OpenSearch Service with S3 as a data source for near-real-time analysis.  
D) Increase Transit Gateway bandwidth to reduce throttling-related retransmissions.

**Correct Answer: C**
**Explanation:** S3 Gateway VPC endpoints are free (no data processing charges), and sending logs to S3 eliminates the cross-VPC data transfer costs through Transit Gateway. Amazon OpenSearch Service can ingest from S3 for near-real-time analysis. At 5 TB/day, this saves significant TGW data processing fees ($0.02/GB). Option A is operationally impractical. Option B reduces some costs through compression but still incurs TGW data processing charges. Option D — bandwidth isn't the issue; cost is.

---

### Question 48
A company has a multi-account setup with VPCs in each account. They want to centralize IPv4 address management and prevent CIDR overlap across all accounts. They use AWS Organizations. What is the most operationally efficient approach?

A) Maintain a spreadsheet of CIDR allocations and require teams to check it before creating VPCs.  
B) Use Amazon VPC IP Address Manager (IPAM) with a delegated IPAM administrator in the networking account. Create IPAM pools for each organizational unit with non-overlapping CIDR ranges. Set up IPAM to enforce allocations so that VPCs can only be created with CIDRs from the appropriate pool.  
C) Use AWS Service Control Policies (SCPs) to restrict VPC creation to specific CIDR ranges.  
D) Deploy a custom API Gateway + Lambda solution that validates CIDR allocations before approving VPC creation.

**Correct Answer: B**
**Explanation:** Amazon VPC IPAM provides centralized IP address management integrated with AWS Organizations. IPAM pools define CIDR ranges per OU or account, and enforcement ensures VPCs can only be created with CIDRs allocated from the pool — preventing overlaps automatically. The delegated administrator model allows the networking team to manage IP space without root account access. Option A is manual and error-prone. Option C — SCPs don't support CIDR-based conditions for VPC creation. Option D works but duplicates IPAM functionality with custom code.

---

### Question 49
A gaming company uses AWS Global Accelerator for their game servers. Players report latency spikes during specific hours. The network team suspects congestion at certain AWS edge locations. How should they diagnose and resolve this?

A) Enable Global Accelerator flow logs and analyze them to identify which edge locations have elevated latency. Use custom routing accelerators to direct traffic away from congested edge locations.  
B) Replace Global Accelerator with CloudFront.  
C) Deploy game servers in more Regions to reduce load on individual edge locations.  
D) Contact AWS Support to provision dedicated edge location capacity.

**Correct Answer: A**
**Explanation:** Global Accelerator flow logs provide per-flow data including edge location, latency, and packet loss. Analysis reveals which edge locations experience congestion during peak hours. Custom routing accelerators allow you to map specific user IP ranges to specific endpoints, bypassing congested edge paths. Combined with endpoint weights, you can shift traffic distribution. Option B — CloudFront is for content delivery, not real-time gaming connections. Option C doesn't address edge location congestion (GA still routes through the same edge locations). Option D — AWS doesn't offer dedicated edge capacity.

---

### Question 50
A company needs to inspect all inbound traffic from the internet before it reaches their ALBs. They want to use AWS Network Firewall for this inspection. The ALBs are in public subnets. How should the traffic flow be designed?

A) Deploy Network Firewall endpoints in the ALB subnets and configure VPC ingress routing on the Internet Gateway to route traffic through the firewall endpoints before reaching the ALBs.  
B) Deploy Network Firewall in a separate inspection VPC and route all inbound traffic through the Transit Gateway.  
C) Deploy Network Firewall behind the ALB and inspect traffic after the ALB processes it.  
D) Use AWS WAF on the ALB instead of Network Firewall.

**Correct Answer: A**
**Explanation:** VPC ingress routing (edge association) on the Internet Gateway allows you to redirect inbound internet traffic to Network Firewall endpoints before it reaches the ALBs. The IGW route table sends destination subnet traffic to the firewall endpoint. After inspection, the firewall forwards traffic to the ALB. This is inline, transparent inspection. Option B adds complexity and latency with cross-VPC routing. Option C — Network Firewall can't be placed behind an ALB in the standard architecture. Option D — WAF provides Layer 7 filtering but not the deep packet inspection of Network Firewall.

---

### Question 51
A multinational company has AWS Direct Connect connections at three global locations: Ashburn, London, and Tokyo. They want any on-premises site to communicate with any other through the AWS network (transit routing). Currently, each Direct Connect connects to a separate VGW in the closest Region. What must they change?

A) Replace the Virtual Private Gateways with Transit Gateways in each Region. Connect the Direct Connect connections to a Direct Connect Gateway via transit VIFs. Associate the DX Gateway with all three Transit Gateways. Establish inter-Region TGW peering.  
B) Create VPN connections between each pair of on-premises sites using AWS as a transit network.  
C) Keep the VGWs and create a full mesh of VPC peering across Regions.  
D) Use a single Direct Connect Gateway with private VIFs to enable transit routing between on-premises sites.

**Correct Answer: A**
**Explanation:** Transit VIFs with Transit Gateways support transitive routing — traffic from one on-premises site can traverse the DX Gateway, through a TGW, across TGW inter-Region peering, to another TGW, and out to another on-premises site. This enables any-to-any on-premises connectivity through AWS. Option D with private VIFs to VGWs does NOT support transit routing between on-premises sites (VGWs block transitive routing). Option B uses VPN which has lower bandwidth. Option C — VPC peering doesn't enable on-premises transit routing.

---

### Question 52
A company runs a containerized application on EKS that communicates with multiple backend services across different VPCs. They want to simplify service discovery and load balancing without managing DNS records or load balancers manually. Services are added and removed frequently. What should the architect recommend?

A) Use Route 53 with auto-naming (Cloud Map) and ALBs in each VPC.  
B) Use AWS VPC Lattice to create a service network. Register backend services as Lattice services with target groups. Associate all VPCs with the service network. EKS pods access services using the Lattice-generated DNS names.  
C) Deploy Consul service mesh alongside EKS for cross-VPC service discovery.  
D) Hardcode service endpoints in application configuration and update during deployments.

**Correct Answer: B**
**Explanation:** VPC Lattice provides automatic service discovery, load balancing, and cross-VPC connectivity in one managed service. When services are registered, Lattice generates DNS names that pods can use. Adding/removing services updates the Lattice configuration — no manual DNS or LB management. It natively supports EKS through the Lattice controller. Option A requires managing Route 53 records and ALBs per service. Option C adds third-party complexity. Option D is not scalable and error-prone with frequent changes.

---

### Question 53
A company operates in a highly regulated industry and must ensure that no VPC traffic ever traverses the public internet, even for AWS API calls (ec2.amazonaws.com, s3.amazonaws.com, etc.). They have 30 VPCs. What is the most comprehensive and maintainable approach?

A) Remove all Internet Gateways and NAT Gateways from VPCs. Deploy Interface VPC endpoints for all required AWS services in a centralized shared-services VPC. Use Route 53 Resolver rules (shared via RAM) to resolve AWS service DNS to private endpoint IPs. Access the endpoints through the Transit Gateway.  
B) Deploy Interface VPC endpoints for every AWS service in every VPC.  
C) Use a proxy fleet in a single VPC that intercepts all AWS API calls and routes them through PrivateLink.  
D) Allow NAT Gateways but configure NACLs to block all non-AWS IP ranges.

**Correct Answer: A**
**Explanation:** Centralizing VPC endpoints in a shared-services VPC avoids deploying endpoints in all 30 VPCs (which would be ~30 × N endpoints). Shared Route 53 Resolver rules ensure all VPCs resolve AWS service DNS names to the private endpoint IPs in the shared-services VPC. Traffic flows through TGW to the centralized endpoints. Removing IGWs and NAT Gateways ensures no public internet path exists. Option B works but is extremely expensive (interface endpoints cost per AZ per VPC per service). Option C adds operational burden. Option D — NACLs can't reliably identify all AWS IP ranges.

---

### Question 54
A company has an application that requires extremely high network throughput between EC2 instances (100 Gbps+). The instances run computational workloads that exchange large datasets. What should the architect recommend?

A) Use instances with Elastic Fabric Adapter (EFA) in a cluster placement group. EFA provides high-bandwidth, low-latency networking using OS-bypass for inter-instance communication.  
B) Use instances with enhanced networking (ENA) and deploy them in a spread placement group.  
C) Deploy instances across multiple AZs with a high-bandwidth Transit Gateway attachment.  
D) Use AWS Direct Connect between instances for dedicated bandwidth.

**Correct Answer: A**
**Explanation:** Elastic Fabric Adapter (EFA) supports up to 100+ Gbps of bandwidth with OS-bypass capabilities, ideal for HPC and large-dataset workloads. Cluster placement groups ensure instances are physically close, maximizing network throughput and minimizing latency. Option B — ENA supports enhanced networking but doesn't provide OS-bypass; spread placement groups distribute instances across hardware, increasing latency. Option C — TGW adds network overhead and cross-AZ latency. Option D — Direct Connect is for on-premises to AWS, not instance-to-instance.

---

### Question 55
A company wants to use AWS Network Firewall to block traffic to specific countries based on source IP geolocation. The security team maintains a list of blocked country IP ranges. How should this be implemented?

A) Create Network Firewall stateless rules with source IP address lists for each blocked country's CIDR ranges, and update them regularly using a Lambda function that queries a geolocation database.  
B) Use Network Firewall's built-in Suricata rule engine with a rule that uses the GeoIP feature: create stateful rules with Suricata-compatible rules that reference IP lists for blocked countries.  
C) Use AWS WAF with geographic match conditions instead of Network Firewall.  
D) Configure security groups to block IP ranges for specific countries.

**Correct Answer: B**
**Explanation:** AWS Network Firewall uses the Suricata rule engine, which supports IP reputation lists and custom rule sets. You can create Suricata-compatible stateful rules that reference IP lists for blocked countries. The rules are updated by refreshing the IP reference sets in the Network Firewall rule variables. Option A works but managing raw CIDR lists for countries is operationally heavy. Option C — WAF only inspects HTTP/HTTPS traffic at Layer 7, not all network traffic. Option D — security groups don't support geolocation-based blocking and have rule count limits.

---

### Question 56
A company is designing a disaster recovery network topology. Their primary Region (us-east-1) has 20 VPCs connected to a Transit Gateway and Direct Connect. The DR Region (us-west-2) should mirror the network topology but remain passive (no traffic flowing) until activated. What is the most cost-effective approach?

A) Fully deploy the Transit Gateway, VPC attachments, and Direct Connect connection in us-west-2, keeping everything active but with no workloads running.  
B) Deploy the Transit Gateway in us-west-2 and pre-create VPC attachments but do not associate the DX Gateway with the us-west-2 TGW until DR activation. Use automation (CloudFormation/Terraform) to associate the DX Gateway and update route tables during failover.  
C) Do not deploy any networking infrastructure in us-west-2 until a DR event occurs.  
D) Use a warm standby in us-west-2 with full networking but scaled-down compute.

**Correct Answer: B**
**Explanation:** Pre-deploying the TGW and VPC attachments in us-west-2 is low cost (TGW has per-attachment per-hour charges, but no data processing if no traffic flows). Not associating the DX Gateway until DR activation avoids DX Gateway charges and prevents accidental traffic routing. Automation templates enable rapid activation (minutes, not hours). Option A incurs unnecessary DX costs for an idle DR Region. Option C means slow recovery — building networking from scratch takes time. Option D is more expensive for a passive DR.

---

### Question 57
A company has deployed a Transit Gateway with 100 VPC attachments. They want to identify which VPC-to-VPC traffic flows are active and measure the volume of traffic between each pair. This data will be used for cost allocation. What should they use?

A) Enable VPC Flow Logs on all 100 VPCs and aggregate them in a central S3 bucket for analysis.  
B) Enable Transit Gateway Flow Logs, which capture traffic at the TGW level with source/destination attachment information. Analyze the flow logs to identify VPC pairs and traffic volumes.  
C) Use CloudWatch metrics for each Transit Gateway attachment to see bytes in/out per attachment.  
D) Deploy packet capture agents on EC2 instances in each VPC.

**Correct Answer: B**
**Explanation:** Transit Gateway Flow Logs capture traffic flowing through the TGW with metadata including source/destination attachment IDs, allowing you to identify which VPC pairs communicate and the data volume between them. This directly answers the cost allocation question. Option A captures per-VPC flows but doesn't directly map to TGW attachment pairs without complex correlation. Option C shows per-attachment totals but not VPC pair specifics. Option D is invasive and doesn't capture all traffic.

---

### Question 58
A company's network engineer is configuring a Direct Connect connection with a private virtual interface. They need the on-premises network to advertise routes to AWS via BGP. AWS should learn the routes and populate the VGW/TGW routing table. What is the maximum number of routes that can be advertised from on-premises to AWS over a single BGP session on a private VIF?

A) 100 routes  
B) 1,000 routes  
C) 200 routes  
D) Unlimited routes

**Correct Answer: A**
**Explanation:** AWS enforces a limit of 100 BGP route advertisements from on-premises to AWS on a private virtual interface. If the on-premises router advertises more than 100 prefixes, the BGP session will be reset. To stay within this limit, organizations should summarize routes on the on-premises router before advertising to AWS. Option B, C, and D are incorrect — the documented limit is 100 prefixes per BGP session on a private VIF.

---

### Question 59
A company needs to implement centralized outbound DNS filtering to prevent data exfiltration through DNS tunneling. All VPCs (40 total) should have their DNS queries inspected. What is the most operationally efficient architecture?

A) Deploy Route 53 Resolver DNS Firewall with domain list rules. Associate the DNS Firewall rule groups with all 40 VPCs using AWS RAM sharing. Configure rules to block known DNS tunneling domains and alert on suspicious query patterns.  
B) Deploy a custom DNS server in each VPC that inspects and filters DNS queries.  
C) Use AWS Network Firewall with DNS domain-based stateful rules in every VPC.  
D) Block all outbound DNS (port 53) traffic using NACLs and force all DNS through an on-premises DNS server.

**Correct Answer: A**
**Explanation:** Route 53 Resolver DNS Firewall provides managed DNS filtering. Domain list rules can block known malicious domains and DNS tunneling patterns. Rule groups are shared via RAM, providing consistent policy across all 40 VPCs without deploying infrastructure in each VPC. DNS Firewall integrates with the VPC DNS resolver (AmazonProvidedDNS), so it's transparent to workloads. Option B requires deploying and managing custom DNS in every VPC. Option C is expensive at scale. Option D breaks AWS service DNS resolution.

---

### Question 60
A company is designing an architecture where on-premises applications must access AWS services (S3, DynamoDB, SQS) without using the public internet. They have a Direct Connect connection with a transit VIF connected to a Transit Gateway. VPC endpoints are deployed in a shared-services VPC attached to the Transit Gateway. On-premises applications currently cannot resolve the VPC endpoint DNS names. What additional configuration is needed?

A) Configure on-premises DNS servers to forward queries for AWS service endpoints (e.g., *.amazonaws.com) to Route 53 Resolver inbound endpoints in the shared-services VPC. Enable private DNS for the VPC endpoints.  
B) Manually add DNS records on on-premises DNS servers for each VPC endpoint IP address.  
C) Configure on-premises applications to use the VPC endpoint IPs directly instead of DNS names.  
D) Enable public DNS resolution for the VPC endpoints.

**Correct Answer: A**
**Explanation:** Interface VPC endpoints with private DNS enabled override the public AWS service DNS names within the VPC. For on-premises access, the Route 53 Resolver inbound endpoints accept DNS queries forwarded from on-premises DNS servers. When on-premises DNS forwards *.amazonaws.com queries to the Resolver inbound endpoints, they resolve to the private VPC endpoint IPs. On-premises traffic then routes over DX → TGW → shared-services VPC → VPC endpoint. Option B is manual and doesn't scale. Option C bypasses DNS-level health checking. Option D defeats the purpose of private access.

---

### Question 61
A company is implementing Network Firewall for east-west inspection between VPCs. They have a centralized inspection VPC with a firewall endpoint in each AZ. During testing, they notice that traffic from VPC-A to VPC-B is being inspected, but return traffic from VPC-B to VPC-A bypasses the firewall. The Transit Gateway has appliance mode enabled. What is the issue?

A) The TGW route table for the inspection VPC has a route directly to VPC-A's CIDR, and the inspection VPC subnet route table does not have a return route through the firewall endpoint.  
B) The Network Firewall stateful rules are not tracking return traffic.  
C) Appliance mode is not properly configured.  
D) VPC-B has a direct route to VPC-A in its local route table.

**Correct Answer: A**
**Explanation:** Even with appliance mode enabled on the TGW, the inspection VPC's internal routing must be correctly configured. If the inspection VPC subnet route table has a direct route to VPC-A's CIDR (bypassing the firewall endpoint), return traffic will skip inspection. The correct configuration requires that the TGW attachment subnet route table in the inspection VPC routes all VPC CIDRs to the firewall endpoint, and the firewall endpoint subnet routes to the TGW attachment. Option B — stateful tracking would drop traffic if return traffic went through a different endpoint, not bypass it. Option C — appliance mode is working (forward path is inspected). Option D — VPC local routes only apply within the VPC CIDR.

---

### Question 62
A company has a large VPC with 500+ EC2 instances across 20 subnets. They need to migrate to a new CIDR range (from 10.0.0.0/16 to 172.16.0.0/16) due to an acquisition creating IP conflicts. They cannot afford significant downtime. What is the recommended migration strategy?

A) Add 172.16.0.0/16 as a secondary CIDR to the existing VPC. Create new subnets in the secondary CIDR range. Migrate instances to the new subnets in phases (using AMIs or blue-green deployment). Update DNS records and service discovery. Once all instances are migrated, remove the subnets using the old CIDR.  
B) Create a completely new VPC with 172.16.0.0/16 and migrate all instances in a single cutover window.  
C) Use VPC peering to connect the old and new VPCs during migration, with dual-stack addressing.  
D) Ask AWS to re-IP the VPC directly.

**Correct Answer: A**
**Explanation:** Adding a secondary CIDR allows phased migration within the same VPC, maintaining security group relationships, route tables, and other VPC-level configurations. Instances are migrated to new subnets incrementally, reducing risk and downtime. DNS-based service discovery enables seamless cutover as instances move. Option B requires big-bang migration with significant downtime risk. Option C works but adds complexity of managing two VPCs. Option D — AWS does not offer VPC re-IP functionality.

---

### Question 63
A company uses a shared Transit Gateway across 50 AWS accounts using AWS RAM. A developer in one account accidentally propagates routes from a test VPC that conflict with production CIDR ranges, causing routing issues across the network. How should the architect prevent this from happening again?

A) Remove RAM sharing and create separate Transit Gateways per account.  
B) Implement a preventive control: use Transit Gateway route table association and propagation controls managed centrally by the networking team. Do not auto-accept attachments — require manual approval. Use AWS Organizations SCP to restrict which accounts can modify TGW route table associations.  
C) Enable AWS Config rules to detect and automatically remove conflicting routes after they are added.  
D) Send email reminders to all developers about proper TGW usage.

**Correct Answer: B**
**Explanation:** Centralized control over TGW operations prevents unauthorized route changes. Disabling auto-accept means the networking team reviews every VPC attachment before activation. Controlling route table association/propagation centrally prevents developers from propagating routes to incorrect route tables. SCPs can restrict which IAM actions developers can perform on TGW resources. This is a preventive control. Option A breaks the shared network model. Option C is reactive (detects after the fact). Option D is not a technical control.

---

### Question 64
A company uses Direct Connect with a transit VIF for their primary connectivity and a Site-to-Site VPN as a backup. They want to test their failover process without disconnecting the Direct Connect. How can they simulate a DX failure?

A) On the on-premises router, shut down the BGP session to the Direct Connect virtual interface. This causes AWS to detect the peer as down and traffic will failover to the VPN path.  
B) Physically unplug the Direct Connect cable at the DX location.  
C) Delete the Direct Connect virtual interface in the AWS console.  
D) Modify the TGW route table to remove the DX-related routes temporarily.

**Correct Answer: A**
**Explanation:** Shutting down the BGP session on the on-premises router simulates a DX failure cleanly. AWS detects the BGP peer as down, withdraws the DX routes, and the VPN routes become active. This is reversible (re-enable BGP to restore), non-destructive, and accurately simulates the failover path. Option B is destructive and requires physical access. Option C permanently deletes the VIF requiring recreation. Option D only affects one direction and doesn't simulate a real failure.

---

### Question 65
A company deploying an application in ap-southeast-1 wants their users in Europe to experience low latency. The application data cannot leave the Asia-Pacific Region due to data residency requirements, but static assets (images, CSS, JS) have no such restriction. How should the architect design the network for optimal performance?

A) Deploy the entire application in both ap-southeast-1 and eu-west-1 with database replication.  
B) Use Amazon CloudFront with edge locations in Europe to cache and serve static assets from European edge locations. Dynamic API requests route to the ap-southeast-1 origin via CloudFront's optimized network path. Enable Origin Shield in ap-southeast-1 for cache efficiency.  
C) Deploy a VPN from European users' networks directly to ap-southeast-1.  
D) Use AWS Global Accelerator to route European users to ap-southeast-1 with optimized routing.

**Correct Answer: B**
**Explanation:** CloudFront caches static assets at European edge locations, eliminating cross-continent latency for those requests. Dynamic API requests still go to ap-southeast-1 but benefit from CloudFront's optimized backbone routing (lower latency than public internet). Origin Shield reduces origin load. Data stays in ap-southeast-1 (compliance met) while static content is cached globally. Option A violates data residency requirements. Option C doesn't improve performance meaningfully. Option D optimizes routing but doesn't cache static content, providing less improvement.

---

### Question 66
A company has a complex VPC architecture with multiple route tables. After a change, instances in a private subnet can no longer reach the internet through the NAT Gateway. The NAT Gateway is running and has an Elastic IP. The private subnet's route table has 0.0.0.0/0 pointing to the NAT Gateway. What are the most likely causes? (Select TWO.)

A) The NAT Gateway's subnet route table is missing a route to the Internet Gateway (0.0.0.0/0 → IGW).  
B) The security group on the NAT Gateway is blocking outbound traffic.  
C) The Network ACL on the NAT Gateway's subnet or the private subnet is denying the traffic.  
D) The NAT Gateway has run out of available ports for connection tracking.  
E) The NAT Gateway's Elastic IP has been disassociated.

**Correct Answer: A, C**
**Explanation:** (A) The NAT Gateway must be in a public subnet with a route table entry for 0.0.0.0/0 → IGW. If this route is missing or was removed during the change, NAT Gateway cannot forward traffic to the internet. (C) NACLs are stateless and applied at the subnet level — if the NACL on either the NAT Gateway's subnet or the private subnet denies the traffic, connectivity breaks. Option B — NAT Gateways don't have security groups. Option D — NAT Gateway supports millions of connections; port exhaustion is extremely rare. Option E — the scenario states the NAT Gateway has an EIP.

---

### Question 67
A company has a hybrid architecture using Direct Connect. They plan to use AWS Outposts at their on-premises location for low-latency workloads. The Outposts rack needs to communicate with VPCs in the Region and with on-premises systems. How does Outposts networking integrate with the existing architecture?

A) Outposts extend the VPC to the on-premises location. Subnets created on Outposts are part of the regional VPC. Communication between Outposts and the Region uses the service link (a private connection over Direct Connect or internet). Local communication between Outposts and on-premises uses the local gateway (LGW).  
B) Outposts creates a separate VPC at the on-premises location that must be peered with the regional VPC.  
C) Outposts uses a VPN tunnel to communicate with the Region, independent of Direct Connect.  
D) Outposts only supports local workloads and cannot communicate with regional VPCs.

**Correct Answer: A**
**Explanation:** AWS Outposts extends a VPC's subnets to on-premises hardware. The service link provides the data path between Outposts and the AWS Region (over DX or internet). The local gateway (LGW) enables communication between Outposts workloads and the on-premises network directly, providing low-latency local access. This integration leverages the existing Direct Connect for the service link path. Option B — Outposts doesn't create separate VPCs. Option C — the service link can use DX, not necessarily VPN. Option D — Outposts is designed for hybrid Regional-local communication.

---

### Question 68
A company operates a SaaS platform with 500 tenants, each with their own VPC in separate AWS accounts. The SaaS platform VPC needs to communicate with each tenant VPC. They find that Transit Gateway attachment limits (5,000 per TGW) may be reached as they grow. What scalable design should the architect use?

A) Use multiple Transit Gateways with inter-TGW peering to scale beyond 5,000 attachments.  
B) Use AWS PrivateLink — deploy the SaaS platform behind an NLB, create a VPC Endpoint Service, and have each tenant create an interface VPC endpoint. This requires no TGW attachment per tenant and scales to thousands of tenants.  
C) Use VPC peering between the SaaS VPC and each tenant VPC.  
D) Deploy the SaaS platform as a public service with WAF protection.

**Correct Answer: B**
**Explanation:** PrivateLink scales independently of TGW attachment limits. Each tenant creates an interface endpoint in their VPC, which establishes a private connection to the SaaS NLB without requiring TGW attachments. There's no practical limit on the number of endpoints connecting to an endpoint service. Option A adds complexity with multiple TGWs. Option C — VPC peering has a 125-connection limit per VPC. Option D doesn't meet private connectivity requirements.

---

### Question 69
A company wants to deploy AWS Network Firewall to inspect traffic but is concerned about the single point of failure if a firewall endpoint becomes unhealthy. How does Network Firewall handle endpoint availability, and what should the architect do to maximize resilience?

A) Network Firewall endpoints are single-AZ resources. Deploy endpoints in multiple AZs, and configure health checks. If an endpoint becomes unhealthy, use Route 53 health checks to reroute traffic.  
B) Network Firewall endpoints are highly available within an AZ (managed by AWS with automatic scaling and failover). Deploy endpoints in every AZ where inspected subnets exist. The VPC route table entries direct traffic to the local AZ's endpoint, so if an AZ fails, the entire AZ fails (not just the firewall).  
C) Deploy multiple Network Firewall endpoints in the same AZ for redundancy.  
D) Use a Gateway Load Balancer in front of Network Firewall for health checking and failover.

**Correct Answer: B**
**Explanation:** Network Firewall endpoints are managed, highly available resources within an AZ. AWS handles scaling and redundancy within the AZ. The architect should deploy endpoints in every AZ where traffic originates. Since VPC route tables direct traffic to the AZ-local endpoint, an AZ failure takes out both the workloads and the firewall endpoint together (acceptable failure mode). Option A — endpoints don't have external health checks because AWS manages them. Option C — you can't deploy multiple endpoints in the same AZ (and don't need to). Option D — GWLB is for third-party appliances, not Network Firewall.

---

### Question 70
A company needs to connect 15 branch offices to AWS. Each branch has a commodity internet connection but no dedicated connectivity. They need encrypted connectivity to AWS VPCs with centralized management. What is the most cost-effective solution?

A) Order Direct Connect connections for all 15 branches.  
B) Deploy AWS Site-to-Site VPN connections from each branch router to a Transit Gateway, using the TGW as the VPN hub. Use accelerated VPN for improved internet-based performance.  
C) Deploy SD-WAN appliances at each branch with a third-party controller.  
D) Use AWS Client VPN for all branch office users.

**Correct Answer: B**
**Explanation:** Site-to-Site VPN to Transit Gateway provides encrypted connectivity over existing internet connections (cost-effective). TGW serves as a hub, centralizing management of all 15 VPN connections. Accelerated VPN routes traffic through the AWS global network after the nearest edge location, improving performance over commodity internet. Option A is expensive for 15 branches. Option C adds third-party complexity and cost. Option D is for individual users, not site-to-site connectivity.

---

### Question 71
A company is designing a network architecture for a PCI-DSS compliant environment. The cardholder data environment (CDE) VPC must be completely isolated from all other VPCs and accessible only through a jump box in a management VPC. No internet access is permitted for the CDE VPC. All administrative traffic must be logged. What network controls should be implemented?

A) Deploy the CDE VPC without an Internet Gateway or NAT Gateway. Connect it to the management VPC through a Transit Gateway with a dedicated route table containing only the management VPC route. Deploy Interface VPC endpoints for required AWS services. Enable VPC Flow Logs with all-traffic logging. Use Network Firewall between the management and CDE VPCs for stateful inspection. Configure NACLs and security groups with least-privilege rules.  
B) Deploy the CDE VPC with a NAT Gateway for patching and use security groups for isolation.  
C) Place the CDE in the same VPC as other workloads but in dedicated subnets with NACLs.  
D) Use VPC peering between CDE and management VPCs with default security group rules.

**Correct Answer: A**
**Explanation:** PCI-DSS requires strict CDE isolation with comprehensive logging. No IGW/NAT ensures no internet path. TGW with a dedicated route table limits connectivity to the management VPC only. VPC endpoints provide AWS service access privately. Flow Logs capture all traffic for audit. Network Firewall provides stateful inspection of management traffic. NACLs + security groups implement defense-in-depth. Option B allows internet access (violates CDE isolation). Option C lacks proper network segmentation. Option D provides insufficient control and logging.

---

### Question 72
A company's Direct Connect connection in us-east-1 currently connects to a VGW associated with a single VPC. They want to migrate to a Transit Gateway architecture to support multiple VPCs. The migration must not cause connectivity loss to the existing VPC. What is the correct migration sequence?

A) Create the Transit Gateway, attach the existing VPC, create a transit VIF on the Direct Connect, delete the private VIF and VGW, then associate the DX Gateway with the TGW.  
B) Create the Transit Gateway and attach the existing VPC. Create a Direct Connect Gateway. Create a new transit VIF on the existing DX connection and associate the DX Gateway with the TGW. Verify connectivity through the new path. Then delete the old private VIF and disassociate the VGW. Keep both paths active during the transition.  
C) Delete the existing VGW and private VIF first, then create the Transit Gateway and transit VIF.  
D) Create a new Direct Connect connection for the Transit Gateway and decommission the old one.

**Correct Answer: B**
**Explanation:** The key to zero-downtime migration is running both paths in parallel. The existing private VIF + VGW continues to work while the new transit VIF + DX Gateway + TGW is configured and tested. A single DX connection supports multiple VIFs (different VLAN tags), so both can coexist. Once the new path is verified, the old VIF and VGW are removed. Option A has a gap between deleting the private VIF and completing the TGW setup. Option C causes downtime during the transition. Option D is unnecessarily expensive.

---

### Question 73
A company needs to enforce that all inter-VPC traffic within their AWS environment goes through centralized Network Firewall inspection. A developer creates a VPC peering connection between two spoke VPCs, bypassing the Transit Gateway and inspection VPC. How should the architect prevent this?

A) Use an AWS Organizations SCP to deny the ec2:CreateVpcPeeringConnection and ec2:AcceptVpcPeeringConnection actions for all accounts except the networking account.  
B) Monitor VPC peering connections with AWS Config rules and alert when new ones are created.  
C) Disable VPC peering at the service level for the Organization.  
D) Rely on security groups to block direct VPC peering traffic.

**Correct Answer: A**
**Explanation:** SCPs are preventive controls that deny specific API actions across all accounts in the Organization. Denying VPC peering creation and acceptance prevents anyone from bypassing the Transit Gateway inspection path. The networking account is excluded so it can still manage peering if legitimately needed. Option B is detective, not preventive (the bypass already happened). Option C — VPC peering can't be disabled at the service level. Option D — security groups don't prevent the peering connection from being established.

---

### Question 74
A company has deployed Transit Gateway in us-east-1 with 80 VPC attachments. They need to implement IP multicast for a financial market data distribution application. Which Transit Gateway feature supports this, and what are the limitations?

A) Enable multicast on the Transit Gateway and create multicast domains. Associate VPC subnets with multicast domains as sources or group members. Limitation: multicast is supported only within a single Transit Gateway (not across TGW peering), and only with IGMPv2. ENIs must be registered as multicast group members.  
B) Transit Gateway does not support multicast. Use Application-level multicast emulation over unicast.  
C) Use a third-party multicast router in a VPC and route multicast traffic through it.  
D) Enable multicast at the VPC level and use security groups to manage multicast group membership.

**Correct Answer: A**
**Explanation:** Transit Gateway supports IP multicast natively. You enable multicast when creating the TGW, create multicast domains, associate source/member subnets, and register ENIs. It supports IGMPv2 for dynamic group membership. Limitations: no cross-TGW peering multicast, no IGMPv3, and member ENIs must be explicitly registered or discovered via IGMP. Option B is incorrect — TGW does support multicast. Option C adds unnecessary complexity. Option D — VPCs don't have native multicast support without TGW.

---

### Question 75
A company is designing a multi-Region, multi-account network using AWS Cloud WAN. They need to enforce that the production segment can never communicate directly with the development segment, even if a misconfiguration occurs. IoT segment traffic should be inspected by Network Firewall before reaching any other segment. How should the network policy be configured?

A) Create three segments in the Cloud WAN policy: production, development, and IoT. Define segment actions that deny sharing between production and development segments. For IoT, define a service insertion policy that routes all inter-segment traffic through a Network Firewall in the inspection VPC. Use segment edge associations to attach VPCs to the correct segments based on tags.  
B) Use a single segment for all traffic and rely on security groups for isolation.  
C) Create separate Transit Gateways for each segment and do not peer them.  
D) Use IAM policies to prevent cross-segment communication.

**Correct Answer: A**
**Explanation:** Cloud WAN network policies define segment isolation rules declaratively. Denying segment sharing between production and development prevents direct communication regardless of individual account misconfigurations. Service insertion for the IoT segment routes traffic through a firewall inspection VPC before reaching other segments. Tag-based segment association automates VPC placement. Option B has no segment isolation. Option C doesn't leverage Cloud WAN and loses centralized management. Option D — IAM policies control API access, not network traffic.

---

## Answer Key

| # | Answer | # | Answer | # | Answer | # | Answer | # | Answer |
|---|--------|---|--------|---|--------|---|--------|---|--------|
| 1 | B | 16 | B | 31 | B | 46 | B | 61 | A |
| 2 | A | 17 | B | 32 | A | 47 | C | 62 | A |
| 3 | B | 18 | A | 33 | B | 48 | B | 63 | B |
| 4 | A | 19 | B | 34 | A | 49 | A | 64 | A |
| 5 | B | 20 | A | 35 | B,D | 50 | A | 65 | B |
| 6 | B | 21 | B | 36 | B | 51 | A | 66 | A,C |
| 7 | B | 22 | B | 37 | B | 52 | B | 67 | A |
| 8 | C | 23 | A | 38 | B | 53 | A | 68 | B |
| 9 | A,C | 24 | B | 39 | A | 54 | A | 69 | B |
| 10 | A | 25 | B | 40 | B | 55 | B | 70 | B |
| 11 | A | 26 | A,C | 41 | B | 56 | B | 71 | A |
| 12 | C | 27 | B | 42 | D | 57 | B | 72 | B |
| 13 | A | 28 | C | 43 | B | 58 | A | 73 | A |
| 14 | A | 29 | B | 44 | A | 59 | A | 74 | A |
| 15 | A | 30 | A | 45 | B | 60 | A | 75 | A |

---

### Domain Distribution
- **Domain 1 — Organizational Complexity:** Q4, Q6, Q11, Q17, Q20, Q21, Q28, Q36, Q42, Q44, Q48, Q51, Q53, Q56, Q57, Q63, Q68, Q72, Q73, Q75 (20)
- **Domain 2 — New Solutions:** Q1, Q2, Q5, Q7, Q8, Q10, Q12, Q14, Q24, Q30, Q31, Q33, Q38, Q39, Q50, Q54, Q55, Q59, Q67, Q70, Q71, Q74 (22)
- **Domain 3 — Continuous Improvement:** Q9, Q13, Q18, Q19, Q25, Q32, Q37, Q43, Q61, Q62, Q66 (11)
- **Domain 4 — Migration & Modernization:** Q3, Q22, Q29, Q34, Q41, Q46, Q52, Q64, Q65 (9)
- **Domain 5 — Cost Optimization:** Q15, Q16, Q23, Q26, Q27, Q35, Q40, Q45, Q47, Q49, Q58, Q60, Q69 (13)
