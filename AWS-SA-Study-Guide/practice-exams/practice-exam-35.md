# Practice Exam 35 - AWS Solutions Architect Associate (SAA-C03) - Networking & Connectivity Mastery

## Ultra-Hard Networking Deep Dive

### Instructions
- **65 questions** | **130 minutes**
- This exam is **SIGNIFICANTLY HARDER** than the real SAA-C03
- Focuses on advanced networking, connectivity, and multi-VPC architectures
- Mix of multiple choice (single answer) and multiple response (select 2-3)
- Passing score: 720/1000

### Domain Distribution
| Domain | Questions |
|--------|-----------|
| Security | ~20 |
| Resilient Architecture | ~17 |
| High-Performing Architecture | ~16 |
| Cost-Optimized Architecture | ~12 |

---

### Question 1
A global enterprise has 55 VPCs spread across 4 AWS regions (us-east-1, eu-west-1, ap-southeast-1, ap-northeast-1). Each region has a Transit Gateway. The security team requires full mesh connectivity between all regions but mandates that VPCs in the Development OU (tagged `Env:Dev`) in any region CANNOT communicate with VPCs in the Production OU (tagged `Env:Prod`) in any other region, while Production VPCs must have full inter-region connectivity. Dev VPCs within the same region may communicate with each other. How should the solutions architect configure this?

A) Create inter-region Transit Gateway peering between all four Transit Gateways. On each Transit Gateway, create two route tables: one for Production attachments that includes routes to all peered TGWs, and one for Development attachments that only includes routes to local Dev VPC attachments. Associate Production VPC attachments with the Production route table and Development VPC attachments with the Development route table.  
B) Use a single global Transit Gateway with a flat route table and use Security Groups to restrict cross-environment traffic between regions  
C) Deploy AWS Network Firewall in each region to filter traffic between Dev and Prod VPCs at the packet level using stateful rules based on VPC CIDR ranges  
D) Use VPC peering for Production-to-Production connectivity across regions and Transit Gateway only for intra-region Dev-to-Dev connectivity  

---

### Question 2
A financial institution has a 100 Gbps Dedicated Direct Connect connection at a colocation facility. The CISO mandates that all data traversing this connection must be encrypted with MACsec (IEEE 802.1AE). The network team discovers that their on-premises router supports MACsec but uses a Connectivity Key Name (CKN) and Connectivity Association Key (CAK) pair. Which combination of steps is required to enable MACsec on this connection? **(Select TWO)**

A) Create a MACsec secret key in AWS Secrets Manager and associate it with the Direct Connect connection  
B) Associate a CKN/CAK pair with the Direct Connect connection using the Direct Connect console or API, ensuring the connection is hosted on a MACsec-capable port at a supported Direct Connect location  
C) Enable MACsec at the virtual interface level for each VIF on the connection  
D) Configure the on-premises router with the matching CKN/CAK pair and set the cipher suite to GCM-AES-256 or GCM-AES-XPN-256  
E) Create an IPsec VPN tunnel over the Direct Connect connection since MACsec only encrypts Layer 2 within the colocation facility, not across the AWS backbone  

---

### Question 3
A company acquired another organization whose AWS accounts use overlapping CIDR ranges (10.0.0.0/16) with the acquirer's existing VPCs. Both organizations have workloads that must communicate during a 12-month migration period. The acquired company has 200+ services running in their VPCs, making re-IP impractical in the short term. What is the MOST operationally efficient solution?

A) Deploy a Transit Gateway and attach all VPCs. Use Transit Gateway route tables with longest prefix matching to route traffic correctly between overlapping CIDRs  
B) Deploy NAT instances in intermediary VPCs on both sides. Configure the Transit Gateway with separate route tables for each organization. Use destination NAT to translate the acquired company's 10.0.0.0/16 to a non-overlapping range (e.g., 100.64.0.0/16) and source NAT for return traffic  
C) Use AWS PrivateLink to expose only the specific services that need cross-organization communication, creating VPC endpoint services in the acquired company's VPCs and interface VPC endpoints in the acquirer's VPCs  
D) Immediately re-IP all of the acquired company's VPCs using a Lambda function to update ENI configurations, then establish Transit Gateway connectivity  

---

### Question 4
A SaaS provider needs to expose an internal NLB-backed service to 300+ customer AWS accounts without exposing the service to the public internet. Customer VPCs use unpredictable CIDR ranges. The provider also needs to control which customer accounts can access the service and must log all connection attempts. Which architecture satisfies all requirements?

A) Create a VPC endpoint service powered by the NLB. Enable acceptance required so the provider must approve each customer's endpoint connection. Enable access logging on the NLB. Provide customers the service name to create interface VPC endpoints in their accounts. Use VPC endpoint policies on the customer side for additional control.  
B) Create a public-facing NLB with security groups that whitelist each customer's public IP ranges  
C) Deploy the service behind an API Gateway with resource policies restricting access to the 300+ customer account IDs  
D) Set up VPC peering between the provider VPC and all 300+ customer VPCs  

---

### Question 5
A company runs a DNS-based service on EC2 instances in an Auto Scaling Group behind a Network Load Balancer. The DNS service processes UDP queries on port 53 and TCP queries on port 53. The NLB must preserve the client source IP address for both protocols. The security team requires that the NLB only accepts traffic from specific IP ranges. Which configuration is correct?

A) Create two target groups — one for UDP:53 and one for TCP:53. Register EC2 instances in both target groups. Enable client IP preservation on both target groups (enabled by default for instance-type targets). Associate a security group with the NLB to restrict source IP ranges.  
B) Create a single target group with both UDP and TCP listeners on port 53. Enable Proxy Protocol v2 on the target group to preserve source IPs. Use NACLs on the NLB subnet to restrict source IPs.  
C) NLB does not support UDP — use a Gateway Load Balancer instead for UDP traffic and an NLB for TCP traffic  
D) Enable cross-zone load balancing and configure the NLB with an Elastic IP per AZ. Use the EC2 instance security groups to filter traffic since NLB cannot have security groups.  

---

### Question 6
**(Select THREE)** A company is designing a multi-region active-active architecture. They use Route 53 for DNS and CloudFront for content delivery. The application behind CloudFront consists of dynamic APIs (no caching) and static assets (cacheable). They need: (1) failover within 30 seconds, (2) static content served from the nearest edge, (3) dynamic API requests routed to the healthiest region. Which THREE configurations should the solutions architect implement?

A) Configure Route 53 health checks with a 10-second request interval and 2 failure threshold on the ALB endpoints in each region. Use failover routing policy with the primary region and secondary region.  
B) Configure CloudFront with an origin group containing two origins (one per region). Set the primary origin to the nearest region's ALB and configure failover to the other region's ALB on 5xx errors or connection timeouts.  
C) Configure CloudFront with cache behaviors: static assets with a long TTL pointing to S3 origins (with S3 cross-region replication), and dynamic API path patterns with TTL=0 forwarding all headers to the origin group with regional ALB failover.  
D) Use Route 53 latency-based routing to point CloudFront's origin to the lowest-latency regional ALB  
E) Deploy Global Accelerator endpoints in front of each regional ALB and configure CloudFront to use the Global Accelerator endpoint as its origin  
F) Use CloudFront Functions to implement client-side retry logic by returning JavaScript that redirects to an alternate region endpoint on failure  

---

### Question 7
A company has a 10 Gbps Direct Connect connection with a private VIF associated to a Direct Connect Gateway, which is in turn associated with Transit Gateways in 3 regions. The company needs to route traffic from on-premises to a specific VPC (VPC-A in us-east-1) through an inspection VPC running AWS Network Firewall before reaching VPC-A. All other VPCs should be reachable directly without inspection. How should the solutions architect configure this?

A) On the us-east-1 Transit Gateway, create an appliance-mode route table associated with the Direct Connect Gateway attachment. Add a route for VPC-A's CIDR pointing to the Network Firewall VPC attachment. In the Network Firewall route table, add a route for VPC-A's CIDR pointing to VPC-A's attachment. Enable appliance mode on the Network Firewall VPC attachment.  
B) Configure the Direct Connect Gateway to route VPC-A's CIDR to the Network Firewall's ENI directly  
C) Deploy a NAT Gateway in the Network Firewall VPC and configure all traffic to VPC-A through the NAT Gateway  
D) Use AWS PrivateLink to expose VPC-A's services through the Network Firewall VPC, eliminating the need for Transit Gateway routing  

---

### Question 8
A company's VPC uses the CIDR block 10.1.0.0/16. They need to create exactly 8 subnets of equal size across 2 Availability Zones (4 subnets per AZ). What is the correct subnet mask, and how many usable IP addresses does each subnet provide?

A) /19 subnet mask — 8,187 usable IPs per subnet  
B) /19 subnet mask — 8,192 usable IPs per subnet  
C) /20 subnet mask — 4,091 usable IPs per subnet  
D) /18 subnet mask — 16,379 usable IPs per subnet  

---

### Question 9
A gaming company operates UDP-based game servers on EC2 instances behind a Network Load Balancer. Players connect from around the world. The company reports that players in Asia experience 300ms+ latency connecting to the us-east-1 NLB. The company cannot deploy infrastructure in Asian regions due to data sovereignty requirements but needs to reduce latency below 100ms. What should the solutions architect recommend?

A) Deploy AWS Global Accelerator with UDP listeners pointing to the NLB. Global Accelerator uses the AWS global network to route traffic from the nearest edge location to us-east-1, reducing latency compared to public internet routing.  
B) Use CloudFront with UDP support to cache game state closer to Asian players  
C) Set up a Site-to-Site VPN from an Asian colocation facility directly to the VPC to provide a dedicated path  
D) Enable cross-region NLB with anycast IP addresses to serve traffic from the nearest AWS region automatically  

---

### Question 10
**(Select TWO)** A company uses AWS Network Firewall to inspect all traffic entering and leaving their VPC. They have configured stateful rules for IDS/IPS. The security team notices that encrypted TLS traffic (HTTPS) is passing through uninspected because the Network Firewall cannot decrypt it. The team needs to inspect TLS traffic content for data exfiltration patterns. Which TWO actions should the solutions architect recommend?

A) Enable TLS inspection on AWS Network Firewall by configuring an SSL/TLS certificate from ACM. Configure the Network Firewall rule group with TLS inspection enabled to decrypt, inspect, and re-encrypt traffic.  
B) Deploy a third-party proxy appliance (e.g., Squid) that performs TLS termination and inspection, then forwards traffic to the Network Firewall for stateful rule evaluation  
C) Configure the Network Firewall to use the SNI (Server Name Indication) field in TLS handshakes to make allow/deny decisions on encrypted traffic without decryption, supplementing content inspection where full decryption is not possible  
D) Use VPC Traffic Mirroring to copy all traffic to a separate inspection instance that performs TLS decryption and deep packet inspection  
E) Configure CloudFront in front of all outbound traffic to terminate TLS at the edge and forward decrypted traffic to the Network Firewall  

---

### Question 11
A company needs to deploy a third-party network appliance (Palo Alto VM-Series) to inspect all traffic entering their VPC from the internet. The appliance must scale horizontally and the solution must not require changing application configurations. Incoming traffic arrives via an internet-facing ALB. Which architecture should the solutions architect implement?

A) Deploy a Gateway Load Balancer (GWLB) with Palo Alto instances as targets. Create a GWLB endpoint in the application VPC. Configure the internet gateway route table to route ingress traffic for the ALB subnets to the GWLB endpoint. Configure the GWLB endpoint subnet route table to route traffic to the ALB.  
B) Place the Palo Alto instances between the internet gateway and the ALB by configuring them as transparent bridges in the same subnet  
C) Deploy the Palo Alto instances in an Auto Scaling Group behind a separate NLB, and configure Route 53 to direct traffic to the NLB first, which then forwards to the ALB  
D) Use AWS Network Firewall instead of Palo Alto since third-party appliances cannot be integrated with VPC routing  

---

### Question 12
A multinational corporation has VPCs across all commercial AWS regions. Their on-premises data center in Frankfurt connects to AWS via Direct Connect. Traffic from on-premises must reach any VPC in any region. The company currently has individual private VIFs to each regional VPC, consuming all 50 allowed VIFs on their connection. They are adding 5 more regions. What should the solutions architect recommend?

A) Replace all private VIFs with a single private VIF associated with a Direct Connect Gateway. Associate the Direct Connect Gateway with a Transit Gateway in each region. Use inter-region Transit Gateway peering to establish connectivity between all Transit Gateways.  
B) Purchase a second Direct Connect connection and create additional private VIFs for the new regions  
C) Use the existing private VIFs and add VPC peering between existing VPCs and the new region VPCs to create a hub-and-spoke topology  
D) Migrate to a public VIF and use Site-to-Site VPN over the internet for each new region  

---

### Question 13
**(Select TWO)** A company has a VPC in us-east-1 (CIDR: 172.16.0.0/16). They deployed an application in a private subnet (172.16.1.0/24). The application must communicate with a partner's API endpoint at a specific IPv4 address (203.0.113.50) over the internet, but the security team prohibits attaching an Internet Gateway to the VPC. Which TWO approaches allow the application to reach the partner endpoint without an Internet Gateway?

A) Deploy a NAT Gateway in a public subnet with an Internet Gateway — this violates the requirement since a NAT Gateway requires an Internet Gateway  
B) Create an AWS Site-to-Site VPN to the partner's network, routing traffic for 203.0.113.50/32 through the VPN tunnel  
C) Use AWS PrivateLink — the partner creates a VPC endpoint service, and the company creates an interface VPC endpoint to reach the partner's service  
D) Set up a Transit Gateway with a VPN attachment to a managed NAT appliance in another VPC that has an Internet Gateway  
E) Configure a VPC peering connection to the partner's VPC  

---

### Question 14
A company uses Amazon Route 53 for DNS. They have an application deployed across 4 regions. The company wants to implement IP-based routing so that traffic from their corporate offices (known IP ranges) always goes to the us-east-1 deployment, while traffic from a specific set of partner IP ranges goes to eu-west-1, and all other traffic goes to the region with the lowest latency. How should this be configured?

A) Create a Route 53 IP-based routing policy. Define two CIDR collections: one for corporate office IP ranges mapped to us-east-1, one for partner IP ranges mapped to eu-west-1. For the default (non-matching IPs), create additional records using latency-based routing policy for all 4 regions. Use a combination of IP-based and latency-based routing by setting the default CIDR location to "*" with latency routing.  
B) Create Route 53 geolocation routing records for each country where offices and partners are located  
C) Use CloudFront with Lambda@Edge to inspect the client IP and redirect to the appropriate regional endpoint  
D) Configure Route 53 weighted routing with 100% weight to each region for their respective IP ranges  

---

### Question 15
A solutions architect must use CloudFront to serve different origin content based on the device type (mobile vs desktop) and the viewer's country. Mobile users in Japan should be served from an S3 bucket in ap-northeast-1, desktop users in Japan from an ALB in ap-northeast-1, and all other users from an ALB in us-east-1. Which approach achieves this with the LEAST operational overhead?

A) Configure CloudFront to forward the CloudFront-Is-Mobile-Viewer and CloudFront-Viewer-Country headers. Write a Lambda@Edge function triggered on Origin Request that inspects these headers and dynamically sets the origin to the appropriate S3 bucket or ALB based on the combination of device type and country.  
B) Create three separate CloudFront distributions, each pointing to a different origin. Use Route 53 geolocation routing to direct users to the correct distribution.  
C) Use CloudFront Functions on Viewer Request to set a custom header, then use CloudFront origin groups to select the correct origin based on that header  
D) Create separate cache behaviors for each device type and country combination, each pointing to a different origin  

---

### Question 16
A company's VPC has the CIDR range 10.0.0.0/20. They have used the following subnets: 10.0.0.0/24, 10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24, and 10.0.4.0/24. The company needs to add a new subnet that holds at least 1,000 usable IP addresses. Which of the following CIDR blocks is valid and meets the requirement?

A) 10.0.5.0/22 — provides 1,019 usable IPs  
B) 10.0.8.0/22 — provides 1,019 usable IPs  
C) 10.0.5.0/22 — provides 1,021 usable IPs  
D) 10.0.8.0/22 — provides 1,021 usable IPs  

---

### Question 17
A healthcare company must ensure that all traffic between their on-premises data center and AWS is encrypted. They have a 10 Gbps Direct Connect connection with a private VIF. The company wants to use IPsec encryption WITHOUT routing traffic over the public internet. What is the correct approach?

A) Create a Site-to-Site VPN connection and route it over a Direct Connect public VIF. The VPN provides IPsec encryption while the public VIF provides connectivity to the AWS VPN endpoint's public IP addresses, keeping traffic on the Direct Connect link rather than the internet.  
B) Enable MACsec on the Direct Connect connection — this provides the same encryption as IPsec  
C) Create a Site-to-Site VPN over the existing private VIF by configuring the VPN endpoint with the private IP addresses of the Virtual Private Gateway  
D) Use AWS CloudHSM to encrypt all application-level traffic, eliminating the need for transport-layer encryption  

---

### Question 18
**(Select TWO)** A company is analyzing VPC Flow Logs using Amazon Athena. They need to identify the top 10 source IP addresses generating rejected traffic to their application over the past 24 hours, along with the destination ports being targeted. The flow logs are stored in S3 in the default v2 format with Parquet compression. Which TWO steps are required?

A) Create an Athena table with a schema matching the VPC Flow Log v2 format, partitioned by date and region. Use the `CREATE TABLE` statement with `ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'` and specify the S3 location.  
B) Run an Athena query: `SELECT srcaddr, dstport, COUNT(*) as cnt FROM vpc_flow_logs WHERE action = 'REJECT' AND date = 'YYYY/MM/DD' GROUP BY srcaddr, dstport ORDER BY cnt DESC LIMIT 10`  
C) Use CloudWatch Logs Insights with the query `stats count(*) by srcAddr | filter action = "REJECT"` since flow logs must go through CloudWatch first  
D) Create a Kinesis Data Firehose stream to transform flow logs into a queryable format before Athena can process them  
E) Configure AWS Config to analyze flow log data and generate a compliance report of rejected traffic patterns  

---

### Question 19
A company uses an ALB to distribute traffic to an Auto Scaling Group. They want to implement a canary deployment where 5% of production traffic goes to a new application version while 95% continues to the stable version. The new version runs on a separate target group. If the new version's error rate exceeds 2%, all traffic must automatically revert to the stable version. How should this be configured?

A) Configure ALB weighted target groups with a forward action: 95% weight to the stable target group and 5% weight to the canary target group. Use CloudWatch alarms monitoring the canary target group's HTTPCode_Target_5XX_Count metric. Configure an AWS Lambda function triggered by the alarm to update the ALB rule to 100%/0% weights.  
B) Use Route 53 weighted routing with 95/5 weight split between two ALBs  
C) Deploy the canary version using CodeDeploy with a linear deployment configuration that shifts 5% every 10 minutes  
D) Configure the ALB listener with two rules: one matching 5% of requests using a random header value, routing to the canary target group  

---

### Question 20
A company with on-premises infrastructure in three geographic locations (New York, London, Tokyo) needs to connect all locations to AWS with dedicated, low-latency links. Each location needs access to VPCs in the nearest AWS region (us-east-1, eu-west-2, ap-northeast-1). All three locations must also communicate with each other through AWS. The company wants to minimize the number of Direct Connect connections while maintaining redundancy. What is the MINIMUM architecture?

A) One Direct Connect connection per location (3 total), each with a private VIF to a Direct Connect Gateway. The Direct Connect Gateway is associated with Transit Gateways in each of the 3 regions. Configure inter-region Transit Gateway peering for full-mesh connectivity between regions. Add a second Direct Connect connection at each location for redundancy (6 total).  
B) One Direct Connect connection per location (3 total) with VPC peering between all regional VPCs  
C) A single Direct Connect connection in New York with VPN backup connections from London and Tokyo  
D) Three Direct Connect connections in New York (one per region) with VPN from London and Tokyo to the New York Transit Gateway  

---

### Question 21
A company runs a web application behind a CloudFront distribution. The origin is an ALB in a private subnet. The security team requires that the ALB only accepts traffic from CloudFront and not from any other source, even if someone discovers the ALB's DNS name. Which approach provides the STRONGEST security?

A) Configure the ALB in a private subnet with no internet gateway route. Use CloudFront with a VPC origin configuration to access the ALB through the private network. This eliminates any public access path to the ALB entirely.  
B) Add a custom HTTP header (X-Origin-Verify) with a secret value in CloudFront's origin custom headers. Configure the ALB listener rule to only forward requests containing this header with the correct value. Rotate the secret periodically using AWS Secrets Manager and Lambda.  
C) Restrict the ALB security group to only allow traffic from CloudFront's published IP ranges using the AWS-managed prefix list for CloudFront  
D) Use AWS WAF on the ALB to block all traffic that doesn't originate from CloudFront IP ranges  

---

### Question 22
**(Select TWO)** A company has 10 VPCs connected to a Transit Gateway. VPC-A (10.1.0.0/16) hosts a shared services platform. The company wants VPC-A accessible from all other VPCs, but no other VPC should be able to communicate with any other non-VPC-A VPC. Which TWO Transit Gateway configurations achieve this isolation?

A) Create two route tables on the Transit Gateway: a "Shared" route table with routes to all VPC CIDRs (associated with VPC-A's attachment) and an "Isolated" route table with only a route to VPC-A's CIDR (associated with all other VPC attachments). Propagate VPC-A's routes to the Isolated table and all VPC routes to the Shared table.  
B) Configure VPC-A's attachment to propagate its routes to the Isolated route table so all spoke VPCs can reach VPC-A  
C) Use Network ACLs on each VPC to block inter-VPC traffic except to VPC-A's CIDR range  
D) Enable Transit Gateway route table association for each spoke VPC to the Isolated route table, and associate VPC-A with the Shared route table  
E) Configure a single default route table with all VPC routes and use security groups to enforce isolation  

---

### Question 23
A company is using Reachability Analyzer to debug connectivity between an EC2 instance in a private subnet and an RDS instance in another private subnet within the same VPC. The analysis shows the path is "Not Reachable" and identifies the security group on the RDS instance as the blocking component. The EC2 instance's security group allows all outbound traffic. The RDS security group allows inbound MySQL (port 3306) from a security group ID that does not match the EC2 instance's security group. What is the FASTEST resolution?

A) Modify the RDS security group's inbound rule to reference the EC2 instance's security group ID instead of the incorrect one  
B) Add the EC2 instance to the security group referenced in the RDS inbound rule  
C) Create a new VPC peering connection between the two subnets  
D) Add a NACL rule allowing port 3306 between the two subnets  

---

### Question 24
A company operates a multi-tier application: web tier in public subnets, application tier in private subnets, and database tier in isolated subnets. The database tier must have NO internet access (inbound or outbound) but must be accessible from the application tier. The application tier needs outbound internet access for API calls. The web tier needs both inbound and outbound internet access. The VPC CIDR is 10.0.0.0/16. Which subnet and routing configuration is correct?

A) Web subnets: route table with 0.0.0.0/0 → IGW. Application subnets: route table with 0.0.0.0/0 → NAT Gateway in web subnet. Database subnets: route table with only the local route (10.0.0.0/16 → local), no other routes. NACLs on database subnets deny all traffic except from application subnet CIDRs on the database port.  
B) All three tiers share the same route table with 0.0.0.0/0 → IGW. Security groups control access between tiers.  
C) Web subnets: route to IGW. Application subnets: route to IGW with security groups blocking inbound internet. Database subnets: route to NAT Gateway for software updates.  
D) Use three separate VPCs with VPC peering between application and database VPCs for maximum isolation.  

---

### Question 25
A company has an IPv6-enabled VPC. EC2 instances in a private subnet have IPv6 addresses and need to initiate outbound connections to IPv6 internet services, but must NOT be reachable from the internet on IPv6. The VPC has an Internet Gateway. What additional component is required?

A) An Egress-Only Internet Gateway — it allows outbound IPv6 traffic and blocks inbound IPv6 connection initiation, analogous to a NAT Gateway for IPv4  
B) A NAT Gateway with IPv6 support enabled  
C) No additional component — the Internet Gateway already handles this by default for IPv6 private subnets  
D) A NAT64 gateway to translate IPv6 requests to IPv4 for internet-bound traffic  

---

### Question 26
**(Select THREE)** A financial services company must implement a defense-in-depth network security architecture for a VPC hosting PCI DSS-compliant workloads. The architecture must include perimeter protection, microsegmentation, and network-level logging. Which THREE components should be implemented?

A) AWS Network Firewall deployed in a dedicated inspection subnet with stateful rules for IDS/IPS, positioned between the Internet Gateway and the application subnets using VPC ingress routing  
B) Security groups configured per application tier with rules referencing other security groups (not CIDR ranges) to implement microsegmentation that automatically adapts as instances scale  
C) VPC Flow Logs enabled at the VPC level, published to S3 in Parquet format with 1-minute aggregation, and analyzed using Athena with scheduled queries that alert on anomalous traffic patterns via SNS  
D) NACLs as the primary security mechanism with deny rules for all known malicious IP ranges  
E) AWS Shield Advanced on all public-facing elastic IP addresses  
F) AWS WAF deployed on every internal ALB for SQL injection protection between microservices  

---

### Question 27
A company wants to use a single CloudFront distribution to serve content from two different origins: an S3 bucket for static assets under the `/static/*` path and an ALB for dynamic API requests under `/api/*`. The S3 bucket has public access blocked. API responses must never be cached. Static assets should be cached for 24 hours. How should this be configured?

A) Create two cache behaviors: `/static/*` behavior with S3 origin using Origin Access Control (OAC), TTL set to 86400 seconds, and a cache policy that caches based on no headers/query strings. `/api/*` behavior with ALB origin, cache policy with TTL=0, and an origin request policy that forwards all headers, cookies, and query strings.  
B) Use a single default behavior with Lambda@Edge to route requests to different origins based on the path prefix  
C) Create two separate CloudFront distributions — one for static and one for API — and use Route 53 to direct traffic  
D) Configure the S3 bucket as the default origin with a cache behavior for `/api/*` pointing to the ALB. Make the S3 bucket public for CloudFront access.  

---

### Question 28
A company has a VPC (CIDR: 10.0.0.0/16) with a Transit Gateway. They add a new Direct Connect connection with a private VIF to the Transit Gateway through a Direct Connect Gateway. On-premises advertises the route 10.0.0.0/8 via BGP. The Transit Gateway also has a static route 10.0.0.0/16 pointing to the VPC attachment. When an on-premises host at 10.99.1.5 sends a packet to 10.0.1.50 (an instance in the VPC), what happens?

A) The packet is delivered to the VPC instance at 10.0.1.50 because the Transit Gateway uses longest prefix match routing — the /16 route to the VPC is more specific than the /8 route to on-premises  
B) The packet loops indefinitely between the Transit Gateway and Direct Connect because of overlapping routes  
C) The packet is dropped because Transit Gateway cannot have overlapping routes  
D) The packet is sent back to on-premises because the 10.0.0.0/8 route was learned first via BGP  

---

### Question 29
A media company uses CloudFront to stream live video. They discovered that viewers are sharing the streaming URL, resulting in unauthorized access. The company needs to restrict access so that only authenticated users from their application can view the stream, and each URL should expire after 4 hours. What is the MOST secure approach?

A) Use CloudFront signed URLs with a custom policy that includes an expiration time of 4 hours and an IP address condition matching the viewer's IP at the time of authentication. Create the signed URLs server-side using a CloudFront key pair associated with a trusted key group.  
B) Use CloudFront signed cookies with an expiration time so all resources under the streaming path are accessible to authenticated users without per-URL signing  
C) Configure the CloudFront distribution with AWS WAF and create a rule that blocks requests without a valid JWT token in the Authorization header  
D) Use S3 presigned URLs directly, bypassing CloudFront, with a 4-hour expiration  

---

### Question 30
**(Select TWO)** A company has a hybrid DNS architecture. On-premises DNS servers need to resolve AWS private hosted zone records (e.g., internal.example.com), and EC2 instances in AWS need to resolve on-premises DNS records (e.g., corp.example.local). The VPC CIDR is 10.0.0.0/16. Which TWO components are required?

A) Create Route 53 Resolver inbound endpoints in the VPC. Configure on-premises DNS servers to forward queries for internal.example.com to the inbound endpoint IP addresses.  
B) Create Route 53 Resolver outbound endpoints in the VPC. Create a Resolver rule that forwards queries for corp.example.local to the on-premises DNS server IP addresses.  
C) Configure the VPC DHCP options set with the on-premises DNS server IP addresses as custom DNS servers  
D) Enable DNS hostnames and DNS resolution on the VPC and configure the on-premises servers to query the VPC's .2 resolver address directly  
E) Use AWS Directory Service Simple AD to bridge DNS resolution between on-premises and AWS  

---

### Question 31
A company has a Transit Gateway in us-east-1 connected to 20 VPCs. They need to add a VPN connection to an on-premises data center. The VPN must support ECMP (Equal Cost Multi-Path) routing for higher throughput. The on-premises router supports BGP. What configuration maximizes VPN throughput?

A) Create multiple Site-to-Site VPN connections (each with 2 tunnels) attached to the Transit Gateway. Enable ECMP on the Transit Gateway. Configure BGP on the on-premises router to advertise the same prefixes over all tunnels with equal AS path lengths. Each VPN tunnel provides up to 1.25 Gbps, and ECMP distributes traffic across all active tunnels.  
B) Create a single VPN connection with 2 tunnels attached to the Transit Gateway. Enable ECMP to double the throughput to 2.5 Gbps.  
C) Attach the VPN to a Virtual Private Gateway instead of the Transit Gateway for better ECMP support  
D) Use AWS Direct Connect instead — VPN connections do not support ECMP with Transit Gateway  

---

### Question 32
A company's security team needs to implement centralized traffic inspection for all east-west traffic (VPC-to-VPC) traversing a Transit Gateway. The inspection must be performed by AWS Network Firewall. There are 8 production VPCs and traffic between any two VPCs must pass through the firewall. What is the correct architecture?

A) Create a dedicated inspection VPC with AWS Network Firewall. On the Transit Gateway, create two route tables: a "Spoke" table associated with all 8 VPC attachments with a default route (0.0.0.0/0) pointing to the inspection VPC attachment, and a "Firewall" table associated with the inspection VPC attachment with routes to all 8 VPC CIDRs. Enable appliance mode on the inspection VPC attachment.  
B) Deploy Network Firewall in each of the 8 VPCs and configure local route tables to direct inter-VPC traffic through the local firewall  
C) Configure Transit Gateway flow logs and use a Lambda function to analyze and block traffic patterns  
D) Use Security Groups on the Transit Gateway attachments to control east-west traffic  

---

### Question 33
A company operates a multi-account AWS environment. Account A hosts a database in VPC-A (10.1.0.0/16). Account B hosts an application in VPC-B (10.2.0.0/16). The application in Account B needs to access the database in Account A on port 5432 only. The company wants the MOST restrictive connectivity — no broader network connectivity between the VPCs. Which solution achieves this?

A) In Account A, create a VPC endpoint service backed by an NLB pointing to the database. In Account B, create an interface VPC endpoint connecting to the endpoint service. The endpoint service can restrict access to Account B using an allow-list. Traffic only flows for the specific NLB port (5432).  
B) Create a VPC peering connection between VPC-A and VPC-B. Use security groups to restrict traffic to port 5432 only.  
C) Connect both VPCs to a Transit Gateway and use Transit Gateway route table segmentation to limit traffic to port 5432  
D) Deploy an AWS PrivateLink-backed API Gateway in Account A and have Account B access the database through API Gateway  

---

### Question 34
A company has a VPC with a /16 CIDR block. They deployed 6 subnets, each with a /24 CIDR. The company needs to add a new application that requires 2,000 IP addresses in a single subnet. The VPC's initial CIDR is 10.0.0.0/16, and subnets 10.0.0.0/24 through 10.0.5.0/24 are in use. Can they create a /21 subnet (2,048 total, 2,043 usable IPs) starting at 10.0.8.0?

A) Yes — 10.0.8.0/21 does not overlap with any existing subnet (10.0.0.0/24 through 10.0.5.0/24), falls within the VPC CIDR (10.0.0.0/16), and is correctly aligned (10.0.8.0 is a valid start for a /21 block)  
B) No — 10.0.8.0/21 overlaps with 10.0.5.0/24  
C) No — a /21 subnet cannot exist within a /16 VPC  
D) Yes, but it only provides 1,024 usable IPs  

---

### Question 35
A company runs a SaaS application that must serve traffic from a single static IP address per Availability Zone for customers who need to whitelist IPs in their firewalls. The application requires Layer 7 routing (path-based, host-based). Currently, they use an ALB which does not provide static IPs. What architecture provides both static IPs and Layer 7 routing?

A) Deploy an NLB with Elastic IPs (one per AZ) with the ALB as a target of the NLB using ALB-type target groups. The NLB provides static IPs while the ALB handles Layer 7 routing.  
B) Assign Elastic IPs directly to the ALB using the ALB's network interface  
C) Use Global Accelerator in front of the ALB — Global Accelerator provides 2 static anycast IPs  
D) Replace the ALB with an NLB and implement path-based routing using Lambda functions as targets  

---

### Question 36
**(Select TWO)** A company discovers unauthorized SSH connections to their EC2 instances originating from within the VPC. The security team needs to: (1) immediately identify all instances making these connections, and (2) set up continuous monitoring to detect similar activity in the future. Which TWO actions should the solutions architect take?

A) Query VPC Flow Logs in Athena filtering for accepted TCP traffic on destination port 22, grouped by source IP, over the last 7 days to identify the source instances  
B) Enable Amazon GuardDuty to continuously monitor for unauthorized access patterns, including unusual SSH activity, using VPC Flow Logs, DNS logs, and CloudTrail events  
C) Review CloudTrail logs for ec2:ConnectInstance API calls to identify SSH sessions  
D) Enable AWS Config rules to detect instances with port 22 open in their security groups  
E) Use AWS Inspector to scan all instances for SSH vulnerabilities  

---

### Question 37
A company needs to design a VPC architecture for a workload that requires communication with exactly 3 AWS services (S3, DynamoDB, and SQS) from instances in a private subnet with no internet access. The solution must be cost-optimized. Which combination of VPC endpoints should be used?

A) Gateway endpoints for S3 and DynamoDB (free), and an interface endpoint for SQS (charged per hour and per GB processed). This is the most cost-effective because gateway endpoints have no additional charge.  
B) Interface endpoints for all three services for consistent configuration  
C) A NAT Gateway for all three services since it handles all AWS service traffic  
D) Gateway endpoints for all three services — S3, DynamoDB, and SQS all support gateway endpoints  

---

### Question 38
A company with a Transit Gateway receives a BGP advertisement from their on-premises Direct Connect for the route 192.168.0.0/16. The Transit Gateway also has a static route 192.168.1.0/24 pointing to a VPC attachment for a security inspection VPC. An EC2 instance in a spoke VPC sends a packet to 192.168.1.50. Where is the packet routed?

A) To the security inspection VPC — the static route 192.168.1.0/24 is more specific than the BGP-learned 192.168.0.0/16, and Transit Gateway uses longest prefix match  
B) To on-premises via Direct Connect — BGP-learned routes take priority over static routes  
C) The packet is dropped due to conflicting routes  
D) To both destinations simultaneously via ECMP  

---

### Question 39
**(Select TWO)** A company has a CloudFront distribution with an S3 origin. They want to restrict access to content based on the viewer's geographic location (blocking specific countries) and also ensure that only CloudFront can access the S3 bucket. Which TWO configurations are needed?

A) Enable CloudFront geographic restrictions (geo-restriction) and specify the denied countries using a blocklist  
B) Configure an S3 bucket policy that only allows access from the CloudFront distribution using an Origin Access Control (OAC) condition  
C) Use Route 53 geolocation routing to prevent DNS resolution for blocked countries  
D) Configure S3 Block Public Access and rely on bucket ACLs for geographic filtering  
E) Deploy AWS WAF on the CloudFront distribution with a geo-match rule for country blocking  

---

### Question 40
A company runs a latency-sensitive application that communicates between two VPCs (VPC-A in us-east-1 and VPC-B in us-west-2). They currently use VPC peering. The network team measures 65ms latency and wants to reduce it. Both VPCs also connect to a Transit Gateway in their respective regions. What should the solutions architect recommend?

A) The latency is determined by the physical distance between us-east-1 and us-west-2 and the AWS backbone network. VPC peering already uses the AWS backbone and provides the lowest latency path between regions. Transit Gateway peering would add marginally higher latency due to extra hop processing. The current architecture is already optimal — no networking change can reduce cross-region latency below the physical distance limitation.  
B) Replace VPC peering with inter-region Transit Gateway peering for lower latency  
C) Set up a Direct Connect connection between us-east-1 and us-west-2 for dedicated bandwidth  
D) Deploy AWS Global Accelerator to route traffic between the two VPCs over the AWS global network  

---

### Question 41
A company is migrating from an on-premises architecture where traffic flows through a centralized firewall. In AWS, they have 15 VPCs in a single region connected to a Transit Gateway. They want ALL internet-bound traffic from all VPCs to pass through a centralized NAT and inspection layer in a shared services VPC. How should the route tables be configured?

A) On the Transit Gateway, associate all spoke VPC attachments with a route table that has a default route (0.0.0.0/0) pointing to the shared services VPC attachment. In the shared services VPC, route traffic through the Network Firewall, then to a NAT Gateway, then to the Internet Gateway. The shared services VPC attachment should be in a separate TGW route table with routes back to each spoke VPC CIDR.  
B) Add a NAT Gateway in every spoke VPC and route internet traffic locally, with VPC Flow Logs sent to the shared services VPC for inspection  
C) Configure an Internet Gateway in the shared services VPC and add a default route pointing to the Transit Gateway in each spoke VPC's route table (without TGW route table changes)  
D) Use AWS PrivateLink for all internet-bound traffic from spoke VPCs to the shared services VPC  

---

### Question 42
A company has an NLB receiving TCP traffic on port 443. The target group uses TLS termination on the NLB with a certificate from ACM. The NLB forwards decrypted traffic to instances on port 80. The security team now requires end-to-end encryption where the NLB does NOT terminate TLS — the instances should handle TLS termination. How should this be reconfigured?

A) Change the NLB listener to a TCP listener on port 443 (not TLS). Change the target group protocol to TCP on port 443. Configure TLS certificates on the EC2 instances. The NLB passes encrypted traffic through without terminating TLS.  
B) Change the target group protocol to TLS on port 443 while keeping the NLB TLS listener  
C) Use an ALB instead since NLB cannot pass through TLS without termination  
D) Enable Proxy Protocol v2 on the NLB to preserve the TLS session through to the instances  

---

### Question 43
**(Select TWO)** A company has a multi-region application using Route 53. The primary region is us-east-1 and the DR region is eu-west-1. They need Route 53 to automatically failover to eu-west-1 when us-east-1 is unhealthy, but they also want to be notified before failover occurs. Which TWO configurations achieve this?

A) Create Route 53 health checks for the us-east-1 endpoint with SNS notifications enabled. When the health check transitions to unhealthy, SNS sends a notification before Route 53 updates DNS.  
B) Configure Route 53 failover routing policy with primary (us-east-1) and secondary (eu-west-1) records. Associate the health check with the primary record.  
C) Use Route 53 latency-based routing — it automatically fails over when a region is unhealthy  
D) Configure CloudWatch Events to monitor Route 53 health check status changes and trigger a Lambda function that manually updates DNS records  
E) Create an Application Recovery Controller routing control to manage failover  

---

### Question 44
A company has multiple AWS accounts within an Organization. They need to share a Transit Gateway from the networking account with all member accounts so that each account can attach their VPCs to the shared Transit Gateway. What service is used to share the Transit Gateway?

A) AWS Resource Access Manager (RAM) — share the Transit Gateway from the networking account with the Organization or specific OUs. Member accounts can then create Transit Gateway attachments for their VPCs.  
B) AWS Service Catalog — create a Transit Gateway product that member accounts can provision  
C) AWS CloudFormation StackSets — deploy Transit Gateway attachments across all accounts  
D) IAM cross-account roles — grant each account permission to create attachments on the Transit Gateway  

---

### Question 45
A company needs to connect 4 on-premises branch offices to their AWS VPCs. Each branch has a low-bandwidth internet connection (50 Mbps). The company wants a managed solution that provides encrypted connectivity with centralized management and monitoring. They do not want to manage VPN software on-premises beyond the customer gateway devices. Which AWS service simplifies this deployment?

A) AWS Cloud WAN — create a global network with a core network policy that defines connectivity between all branch offices and AWS VPCs. Use Site-to-Site VPN connections for each branch to the Cloud WAN core network. Cloud WAN provides centralized management, monitoring, and routing policies.  
B) Deploy individual Site-to-Site VPN connections from each branch to a Virtual Private Gateway in the VPC  
C) Set up Direct Connect at each branch office for reliable connectivity  
D) Use AWS Client VPN with each branch establishing an OpenVPN connection to AWS  

---

### Question 46
**(Select TWO)** An e-commerce company experiences intermittent connectivity issues between their EC2 instances in a private subnet and an RDS database in another private subnet within the same VPC. The application logs show connection timeouts occurring approximately every 350 seconds of idle time. The database shows no performance issues. Which TWO configurations are most likely causing the issue and should be checked?

A) The NAT Gateway's idle timeout — NAT Gateways drop idle TCP connections after 350 seconds. If application traffic to RDS traverses a NAT Gateway, idle connections are being terminated.  
B) The security group's connection tracking — verify that the security group has not been configured with a reduced timeout for tracked connections  
C) The Network ACL's stateless nature — NACLs do not track connections, and if ephemeral port ranges are not properly configured, return traffic may be blocked intermittently  
D) The application's TCP keep-alive settings — configure the application or OS to send TCP keep-alive packets with an interval shorter than 350 seconds to prevent idle connection termination  
E) The RDS instance class is too small and dropping connections under load  

---

### Question 47
A company has a VPC with a CIDR block of 172.31.0.0/16. They need to add more IP addresses because the VPC is running out. They cannot modify the existing CIDR. What should they do?

A) Add a secondary CIDR block to the VPC from a non-overlapping range (e.g., 100.64.0.0/16). Create new subnets in the secondary CIDR range. A VPC can have up to 5 CIDR blocks (extendable to 50 via quota increase).  
B) Create a new VPC with a larger CIDR and migrate all resources  
C) Contact AWS support to extend the existing CIDR from /16 to /12  
D) Use IPv6 addresses exclusively since IPv6 has unlimited address space  

---

### Question 48
A company uses an Application Load Balancer with a HTTPS listener. The ALB must present different TLS certificates based on the hostname in the client request (e.g., app1.example.com and app2.example.com). Both hostnames resolve to the same ALB. How should this be configured?

A) Use SNI (Server Name Indication) on the ALB by adding multiple certificates to the HTTPS listener. The ALB automatically selects the correct certificate based on the hostname in the TLS ClientHello. Configure host-based routing rules to direct traffic to different target groups.  
B) Create two separate ALB listeners on different ports, each with a different certificate  
C) Use a wildcard certificate (*.example.com) — SNI is not supported on ALB  
D) Deploy two ALBs, each with its own certificate, and use Route 53 to direct traffic  

---

### Question 49
A solutions architect is troubleshooting a connectivity issue. An EC2 instance in VPC-A (attached to Transit Gateway) cannot reach an on-premises host at 10.99.1.5. The Transit Gateway has a route for 10.99.0.0/16 pointing to the VPN attachment. The VPN tunnel is UP and BGP session is established. The on-premises router shows the VPC CIDR in its routing table. What should the architect check FIRST?

A) Check the Transit Gateway route table associated with VPC-A's attachment to confirm it has the 10.99.0.0/16 route. Then check VPC-A's subnet route table to confirm it has a route pointing to the Transit Gateway for the 10.99.0.0/16 destination. A common issue is that the VPC route table is missing the TGW route.  
B) Check if the EC2 instance has a public IP address  
C) Verify that the Internet Gateway is attached to VPC-A  
D) Check if the EC2 instance has an Elastic IP  

---

### Question 50
**(Select TWO)** A company wants to implement a highly available DNS architecture for their Route 53 private hosted zone that serves a VPC in us-east-1 and a VPC in eu-west-1. The hosted zone must be resolvable from both VPCs. Which TWO actions are required?

A) Create the private hosted zone and associate it with the VPC in us-east-1  
B) Associate the same private hosted zone with the VPC in eu-west-1 by adding a second VPC association (cross-region association is supported for private hosted zones)  
C) Create a separate private hosted zone in eu-west-1 and use Route 53 Resolver rules to forward queries between regions  
D) Deploy Route 53 Resolver endpoints in both VPCs to forward queries to each other  
E) Enable VPC peering between the two VPCs — this is required for cross-region private hosted zone resolution  

---

### Question 51
A gaming company uses a Network Load Balancer with UDP listeners for their real-time multiplayer game servers. They notice that all traffic from a single player session is not consistently going to the same target. This causes players to desynchronize. What should the solutions architect configure?

A) Enable sticky sessions (source IP affinity) on the NLB target group. NLB supports stickiness for UDP by routing packets from the same source IP and port to the same target for the duration of the flow.  
B) Switch to an ALB with WebSocket support for real-time gaming  
C) Enable cross-zone load balancing to ensure consistent routing  
D) Use Proxy Protocol v2 to maintain session affinity  

---

### Question 52
A company needs to troubleshoot a suspected routing issue where traffic from on-premises (arriving via Transit Gateway VPN attachment) is not reaching an EC2 instance in a specific subnet. The instance is in a VPC attached to the same Transit Gateway. Instead of manually checking every route table and NACL, which AWS feature provides an automated analysis of the entire path?

A) VPC Reachability Analyzer — create an analysis path with the Transit Gateway attachment as the source and the EC2 instance ENI as the destination. Reachability Analyzer evaluates security groups, NACLs, route tables, and Transit Gateway route tables along the path and identifies the blocking component.  
B) VPC Flow Logs — enable flow logs and search for REJECT entries for the specific traffic  
C) CloudWatch Network Monitor — it provides end-to-end path visualization  
D) AWS X-Ray — trace the network request from source to destination  

---

### Question 53
A company has a /22 VPC CIDR (10.10.0.0/22 = 1,024 total IPs). They need to create subnets in 2 AZs with the following requirements: 2 public subnets (at least 50 IPs each), 2 private application subnets (at least 100 IPs each), and 2 private database subnets (at least 20 IPs each). What is the most IP-efficient subnet design?

A) Public: 2x /26 (59 usable each, 128 total). Private app: 2x /25 (123 usable each, 256 total). Private DB: 2x /27 (27 usable each, 64 total). Total used: 448 IPs. Remaining: 576 IPs for future use.  
B) All subnets: 6x /24 (251 usable each) — this exceeds the VPC CIDR (6 × 256 = 1,536 > 1,024)  
C) Public: 2x /25. Private app: 2x /24. Private DB: 2x /26. Total used: 768 IPs.  
D) Public: 2x /28. Private app: 2x /26. Private DB: 2x /28. Total used: 192 IPs. But /28 only gives 11 usable IPs, which is less than the 50 IP requirement for public subnets.  

---

### Question 54
A company has a Direct Connect connection terminated at a partner location. They notice that their Direct Connect BGP session is flapping, causing intermittent connectivity. They have already verified that the on-premises router is stable. What feature should be enabled on the Direct Connect virtual interface to quickly detect link failures and reduce convergence time?

A) Enable Bidirectional Forwarding Detection (BFD) on the Direct Connect virtual interface. BFD provides sub-second failure detection, which causes BGP to converge much faster when a link failure occurs compared to relying on BGP hold timer expiration alone.  
B) Enable TCP keep-alives on the BGP session with a 1-second interval  
C) Configure multiple BGP sessions over the same VIF for redundancy  
D) Enable Direct Connect Auto-Recovery which automatically re-establishes failed connections  

---

### Question 55
**(Select TWO)** A company is implementing a centralized outbound internet access architecture using AWS Transit Gateway and a shared services VPC with NAT Gateways. The company has 50 spoke VPCs. The NAT Gateways in the shared services VPC are in 3 AZs, each with 45 Gbps capacity. The company expects peak internet-bound traffic of 120 Gbps. Which TWO design considerations are critical?

A) Deploy additional NAT Gateways in the shared services VPC — a single NAT Gateway supports up to 45 Gbps. With 3 NAT Gateways (one per AZ), the total capacity is 135 Gbps, which exceeds the 120 Gbps requirement. Ensure traffic is distributed across AZs by routing each AZ's traffic to its local NAT Gateway using separate route tables.  
B) Enable Transit Gateway ECMP across the NAT Gateways to distribute traffic evenly  
C) Consider Transit Gateway bandwidth limits — a single Transit Gateway supports up to 50 Gbps per VPC attachment. With 120 Gbps aggregate, ensure the traffic is distributed across multiple attachments or consider using multiple Transit Gateways.  
D) Deploy NAT Instances instead of NAT Gateways for higher throughput  
E) Use a single NAT Gateway since it auto-scales to handle any bandwidth  

---

### Question 56
A company has an ALB with path-based routing. The rule `/api/v1/*` routes to Target Group A and `/api/v2/*` routes to Target Group B. The default rule routes to a static error page. A new requirement states that requests with a custom header `X-Debug: true` should always go to Target Group C regardless of the path. How should the ALB rules be configured?

A) Add a new rule with the HIGHEST priority (lowest number) that matches on the HTTP header condition `X-Debug: true` and forwards to Target Group C. This rule is evaluated before the path-based rules because ALB evaluates rules in priority order.  
B) Modify the existing path-based rules to add a header condition using AND logic  
C) Create a separate ALB listener for debug traffic on a different port  
D) Use Lambda@Edge to inspect the header and redirect to Target Group C  

---

### Question 57
A company needs to connect a VPC (10.0.0.0/16) to their on-premises network (192.168.0.0/16) using a Site-to-Site VPN. The VPN must support IPv4 and IPv6, use BGP for dynamic routing, and accelerated VPN for performance. Which configuration is correct?

A) Create a Transit Gateway with a VPN attachment (not a Virtual Private Gateway) because accelerated VPN uses Global Accelerator endpoints and requires Transit Gateway attachment. Enable the acceleration option when creating the VPN connection. Configure BGP on the customer gateway with both IPv4 and IPv6 BGP sessions inside the IPsec tunnels.  
B) Attach the VPN to a Virtual Private Gateway with acceleration enabled  
C) Create a standard VPN connection and use Global Accelerator separately to accelerate the traffic  
D) Use Direct Connect instead — Site-to-Site VPN does not support IPv6 or acceleration  

---

### Question 58
A company has 3 VPCs (VPC-A: 10.1.0.0/16, VPC-B: 10.2.0.0/16, VPC-C: 10.3.0.0/16) connected via VPC peering in a full mesh (A↔B, B↔C, A↔C). An instance in VPC-A (10.1.1.10) needs to reach an instance in VPC-C (10.3.1.10). The VPC-A route table has a route for 10.3.0.0/16 pointing to the A↔C peering connection. However, the instance in VPC-A cannot reach the instance in VPC-C. VPC-C's security group allows all traffic from 10.1.0.0/16. What is the MOST likely cause?

A) The VPC-C route table does not have a return route for 10.1.0.0/16 pointing to the C↔A peering connection. VPC peering requires route table entries on both sides.  
B) VPC peering does not support transitive routing, so traffic from A to C must go through B  
C) The NACL on VPC-C's subnet is blocking the inbound traffic  
D) The DNS resolution for the peering connection is not enabled  

---

### Question 59
A company wants to use CloudFront to accelerate an API Gateway (Regional endpoint) backend. The API Gateway processes requests in us-east-1. The company wants CloudFront to add HTTPS, caching for GET requests, and DDoS protection. However, they notice that after deploying CloudFront, requests receive duplicate rate limiting because both CloudFront and API Gateway apply throttling. What is the recommended approach?

A) Use an API Gateway Edge-Optimized endpoint instead of Regional. Edge-Optimized API Gateway automatically deploys a CloudFront distribution that is integrated with API Gateway, avoiding duplicate CloudFront configurations and throttling conflicts.  
B) Remove the CloudFront distribution and rely solely on API Gateway's built-in edge caching  
C) Keep the CloudFront distribution in front of the Regional API Gateway but increase the API Gateway throttling limits to account for CloudFront's retry behavior. Use CloudFront cache behaviors to reduce origin requests.  
D) Replace CloudFront with Global Accelerator for API acceleration  

---

### Question 60
**(Select THREE)** A company is building a hub-and-spoke network architecture with AWS Transit Gateway. The hub VPC contains shared services (DNS, monitoring, logging). 20 spoke VPCs contain application workloads. Requirements: (1) All spokes can reach the hub, (2) spokes cannot communicate with each other, (3) all internet traffic from spokes must be inspected before leaving the hub, (4) new spoke VPCs must be automatically connected without manual route updates. Which THREE configurations are necessary?

A) Create two Transit Gateway route tables: a "Spoke" route table with a default route (0.0.0.0/0) to the hub VPC attachment and a static route for the hub VPC CIDR, and a "Hub" route table with propagated routes from all spoke attachments  
B) Enable Transit Gateway auto-accept shared attachments and configure automatic route propagation from new spoke VPC attachments to the Hub route table  
C) Deploy AWS Network Firewall in the hub VPC between the Transit Gateway attachment subnet and the NAT Gateway/Internet Gateway, with route tables directing all egress traffic through the firewall endpoints  
D) Configure VPC peering between each spoke and the hub VPC for lower latency  
E) Use AWS RAM to share the Transit Gateway with spoke accounts and configure an SCP requiring all VPCs to have a Transit Gateway attachment  
F) Create individual route tables for each spoke VPC on the Transit Gateway  

---

### Question 61
A company runs a legacy application that requires a fixed set of 5 specific IP addresses for outbound internet traffic (partner API firewalls whitelist these IPs). The application runs on multiple EC2 instances in a private subnet across 2 AZs. NAT Gateways only provide 1 Elastic IP each. How should the architect provide exactly 5 outbound IP addresses?

A) Deploy 5 NAT Gateways, each with a different Elastic IP. Distribute traffic across the NAT Gateways using multiple route tables or by placing instances in subnets with routes to different NAT Gateways. Alternatively, use 2 NAT Gateways for HA (one per AZ) and assign additional Elastic IPs — a NAT Gateway supports up to 8 Elastic IPs by associating secondary EIPs. The partner whitelist all assigned IPs.  
B) Attach 5 Elastic IPs to each EC2 instance — each instance can have multiple public IPs  
C) Use a single NAT Gateway with 5 Elastic IPs — NAT Gateways only support 1 Elastic IP  
D) Deploy an internet-facing NLB with 5 Elastic IPs for outbound traffic  

---

### Question 62
A company operates a VPC with a CIDR of 10.0.0.0/16. They need to create a subnet that starts at 10.0.128.0. What is the largest subnet they can create starting at this address that still fits within the VPC CIDR?

A) 10.0.128.0/17 — this covers 10.0.128.0 to 10.0.255.255 (32,768 IPs), which is the largest power-of-2-aligned block starting at 10.0.128.0 within 10.0.0.0/16  
B) 10.0.128.0/16 — same size as the VPC  
C) 10.0.128.0/18 — covers 10.0.128.0 to 10.0.191.255  
D) 10.0.128.0/24 — 256 IPs  

---

### Question 63
**(Select TWO)** A company is migrating to AWS and needs to ensure that their on-premises Active Directory can authenticate AWS Workloads. They also need EC2 instances in private subnets to resolve on-premises DNS names. The VPC uses a Direct Connect connection to the on-premises data center. Which TWO services/configurations should be implemented?

A) AWS Managed Microsoft AD with a trust relationship to the on-premises Active Directory domain for seamless authentication  
B) Route 53 Resolver outbound endpoints with forwarding rules for the on-premises DNS domain (e.g., corp.local) pointing to the on-premises DNS servers  
C) Deploy a standalone Active Directory on EC2 instances with no connection to on-premises AD  
D) Configure the VPC DHCP options set to point to the on-premises DNS servers as the only DNS resolvers — this replaces the Amazon-provided DNS entirely  
E) Use AWS SSO with SAML federation to on-premises AD for all EC2 instance authentication  

---

### Question 64
A company has a CloudFront distribution with a custom domain (cdn.example.com). They use ACM to manage the TLS certificate. After deploying the distribution, users report SSL errors when accessing cdn.example.com. The ACM certificate is verified and issued. What is the MOST likely cause?

A) The ACM certificate was created in a region other than us-east-1. CloudFront requires certificates to be in the us-east-1 (N. Virginia) region. The certificate must be re-created or imported in us-east-1.  
B) The CloudFront distribution is using the default CloudFront certificate instead of the custom ACM certificate — the certificate needs to be associated with the distribution  
C) The DNS CNAME record for cdn.example.com is not pointing to the CloudFront distribution domain name  
D) The ACM certificate needs to be a wildcard certificate (*.example.com), not a single-domain certificate  

---

### Question 65
A company has a complex hybrid network: on-premises data center → Direct Connect → Transit Gateway → 30 VPCs. They need to implement end-to-end observability for network traffic across this entire path. The solution must provide: real-time traffic visibility, anomaly detection, and historical analysis for compliance. Which combination of services provides the MOST comprehensive solution?

A) Enable VPC Flow Logs (all 30 VPCs) published to S3 in Parquet format with 1-minute aggregation. Enable Transit Gateway Flow Logs. Use Amazon Athena for historical query analysis. Enable Amazon GuardDuty for anomaly detection across Flow Logs, DNS logs, and CloudTrail. Use CloudWatch contributor insights for real-time top-talker analysis. For the Direct Connect segment, use CloudWatch metrics for connection monitoring.  
B) Use VPC Traffic Mirroring on all instances to copy 100% of traffic to a centralized analysis cluster  
C) Deploy third-party network monitoring agents on every EC2 instance  
D) Rely solely on CloudTrail for network traffic analysis since it captures all API calls  

---

## Answer Key

### Question 1
**Correct Answer: A**

Transit Gateway route table segmentation is the correct approach for controlling inter-VPC connectivity in a multi-region architecture. By creating separate route tables for Production and Development:
- The Production route table includes routes to peered TGWs, allowing cross-region Prod-to-Prod traffic.
- The Development route table only includes local VPC routes, preventing cross-region Dev communication while allowing intra-region Dev-to-Dev.
- Option B is wrong because Security Groups operate at the instance level, not TGW level, and cannot control TGW routing.
- Option C is wrong because SCPs (allow policies) at the TGW don't grant traffic flow — routes do.
- Option D doesn't scale and creates management overhead with individual peering connections.

### Question 2
**Correct Answer: B, D**

MACsec on Direct Connect requires:
1. The connection must be on a MACsec-capable port at a supported location (100 Gbps connections support MACsec).
2. A CKN/CAK pair is associated with the Direct Connect connection (not Secrets Manager — option A is wrong).
3. The on-premises router must be configured with the matching CKN/CAK and a compatible cipher suite.
- Option C is wrong because MACsec is configured at the connection level, not per-VIF.
- Option E is wrong because MACsec encrypts Layer 2 frames end-to-end between the customer router and the AWS Direct Connect endpoint.

### Question 3
**Correct Answer: C**

AWS PrivateLink is the most operationally efficient solution for overlapping CIDRs because:
- It does not require re-addressing any network.
- Traffic flows through private endpoints without routing overlap issues.
- Only specific services that need communication are exposed.
- Option A is wrong because Transit Gateway cannot route correctly with identical CIDRs — longest prefix match doesn't help when both are 10.0.0.0/16.
- Option B would work technically but is very complex operationally with 200+ services.
- Option D is impractical as stated in the question.

### Question 4
**Correct Answer: A**

AWS PrivateLink (VPC Endpoint Services) is designed for this exact use case:
- NLB-backed service exposed to other accounts without public internet exposure.
- Acceptance required provides per-account access control.
- Works regardless of customer CIDR ranges (no routing conflicts).
- NLB access logging captures connection attempts.
- Option B exposes the service to the public internet.
- Option C uses API Gateway which is a public service (not purely private).
- Option D doesn't scale to 300+ accounts and exposes full network connectivity.

### Question 5
**Correct Answer: A**

NLB supports both TCP and UDP listeners. Key points:
- Separate target groups are needed for different protocols.
- Client IP preservation is enabled by default for instance-type targets.
- NLB now supports security groups (added in 2023), allowing source IP restriction at the NLB level.
- Option B is wrong because you can't combine UDP and TCP in a single target group.
- Option C is wrong — NLB does support UDP.
- Option D is wrong — NLB does support security groups.

### Question 6
**Correct Answer: B, C, E (Note: Select THREE — A is close but uses failover policy for a single region pair; B, C together provide the CloudFront-level failover)**

Actually, **Correct Answer: A, B, C** — Wait, re-evaluating:
- A provides Route 53 health check monitoring with fast detection (10s × 2 = 20s failover detection < 30s requirement) — but failover routing is for primary/secondary, not active-active.

**Correct Answer: B, C** plus one more. Re-reading: The question asks for active-active with failover within 30s.

**Correct Answer: B, C (and a third)** — Let me reconsider:
- B: CloudFront origin groups provide automatic origin failover on 5xx/timeout.
- C: Separate cache behaviors for static (S3 with CRR) and dynamic (origin group with ALB failover, TTL=0).
- A: Route 53 health checks enable monitoring, but with CloudFront origin groups handling failover, Route 53's role is to point to CloudFront. However, the health check + SNS notification is useful for awareness.

**Correct Answer: A, B, C**
- A: Route 53 health checks with 10s interval × 2 threshold = 20 second detection (under 30s). Failover routing for Route 53 records pointing to CloudFront.
- B: CloudFront origin groups for dynamic API failover at the origin level.
- C: Separate cache behaviors — static with long TTL + S3/CRR, dynamic with TTL=0 to origin groups.
- D is wrong because latency-based routing doesn't provide failover.
- E is redundant — Global Accelerator + CloudFront is over-engineering.
- F is impractical — client-side JavaScript retry for API origin failover.

### Question 7
**Correct Answer: A**

This is the Transit Gateway inspection architecture pattern:
- The TGW route table for the Direct Connect attachment has a specific route for VPC-A's CIDR pointing to the inspection VPC.
- The inspection VPC's route table forwards inspected traffic to VPC-A.
- Appliance mode ensures symmetric routing for stateful inspection.
- Other VPCs' CIDRs go directly to their attachments (default propagated routes).
- Option B is wrong because Direct Connect Gateway doesn't route to individual ENIs.
- Option C doesn't provide inspection.
- Option D changes the architecture model unnecessarily.

### Question 8
**Correct Answer: A**

CIDR math: 10.1.0.0/16 = 65,536 IPs total. Dividing into 8 equal subnets: 65,536 / 8 = 8,192 IPs per subnet. The subnet mask for 8,192 IPs is /19 (2^(32-19) = 2^13 = 8,192). AWS reserves 5 IPs per subnet: 8,192 - 5 = 8,187 usable IPs.
- Option B is wrong because it doesn't account for the 5 reserved IPs.
- Option C is /20 which gives 4,096 IPs (16 subnets, not 8).
- Option D is /18 which gives 16,384 IPs (4 subnets, not 8).

### Question 9
**Correct Answer: A**

AWS Global Accelerator supports UDP and routes traffic through the AWS global network from the nearest edge location. This significantly reduces latency compared to routing over the public internet. Global Accelerator provides two static anycast IPs.
- Option B is wrong — CloudFront does not support UDP.
- Option C is wrong — VPN doesn't reduce latency significantly and adds encryption overhead.
- Option D is wrong — NLB doesn't have cross-region or anycast capability.

### Question 10
**Correct Answer: A, C**

AWS Network Firewall supports TLS inspection (added capability) to decrypt, inspect, and re-encrypt traffic. For traffic where full decryption is not possible or desired, SNI-based filtering makes allow/deny decisions based on the domain name in the TLS handshake without decrypting content.
- Option B works but adds operational complexity with third-party software management.
- Option D: Traffic Mirroring has bandwidth limitations and adds significant overhead.
- Option E: CloudFront cannot intercept outbound traffic.

### Question 11
**Correct Answer: A**

Gateway Load Balancer is specifically designed for transparent inline inspection with third-party appliances:
- Uses GENEVE protocol to encapsulate traffic.
- GWLB endpoints in the application VPC route tables intercept traffic transparently.
- Ingress routing on the IGW route table directs incoming traffic to the GWLB endpoint.
- The appliance inspects traffic and returns it via GWLB.
- Option B doesn't work — transparent bridging isn't supported in VPC.
- Option C creates a complex non-transparent architecture.
- Option D is wrong — third-party appliances integrate via GWLB.

### Question 12
**Correct Answer: A**

Direct Connect Gateway consolidates connectivity:
- A single private VIF to a Direct Connect Gateway replaces all 50 individual VIFs.
- The Direct Connect Gateway can associate with Transit Gateways in any region.
- Inter-region Transit Gateway peering provides the full mesh connectivity.
- This architecture scales without adding VIFs.
- Option B doesn't solve the VIF limit problem fundamentally.
- Option C creates a complex hub-and-spoke without simplifying the connection.
- Option D downgrades to VPN-level connectivity.

### Question 13
**Correct Answer: B, C**

Without an Internet Gateway, the options to reach an internet IP are:
- B: Site-to-Site VPN creates a direct encrypted tunnel to the partner — traffic goes through VPN, not internet.
- C: PrivateLink allows the partner to expose their service as a VPC endpoint service — completely private.
- A correctly identifies that NAT Gateway requires an IGW — this is a trap answer that explains why a common solution won't work.
- D is technically possible but overly complex for reaching a single IP.
- E: VPC peering requires both accounts to be on AWS and doesn't reach external IPs.

### Question 14
**Correct Answer: A**

Route 53 IP-based routing uses CIDR collections to route specific IP ranges to specific endpoints. For non-matching IPs, a default record with latency-based routing provides optimal routing.
- Option B: Geolocation routing is based on country/region, not IP ranges.
- Option C: Lambda@Edge can do this but is not a DNS-level solution and adds latency.
- Option D: Weighted routing distributes to all regions regardless of source IP.

### Question 15
**Correct Answer: A**

Lambda@Edge on Origin Request can dynamically select origins based on any request attribute:
- CloudFront adds device detection and geolocation headers automatically.
- Lambda@Edge inspects these and modifies the origin dynamically.
- This is a single distribution with a single cache behavior — least operational overhead.
- Option B requires managing 3 distributions and complex DNS.
- Option C: CloudFront Functions don't have origin modification capability.
- Option D requires maintaining many cache behaviors for each combination.

### Question 16
**Correct Answer: D**

CIDR analysis: VPC is 10.0.0.0/20 (10.0.0.0 - 10.0.15.255). Subnets 10.0.0.0/24 through 10.0.5.0/24 are in use. A /22 = 1,024 total IPs, 1,019 usable (1,024 - 5). 
- 10.0.5.0/22 would cover 10.0.4.0 - 10.0.7.255 (must start at a /22 boundary: 10.0.4.0, not 10.0.5.0) — actually 10.0.5.0 is NOT a valid /22 start. /22 blocks must start at multiples of 4 in the third octet.
- 10.0.8.0/22 covers 10.0.8.0 - 10.0.11.255. This is within the VPC CIDR, properly aligned, and doesn't overlap existing subnets.
- 1,024 - 5 = 1,019 usable, not 1,021. Wait — AWS reserves 5 IPs. So 1,024 - 5 = 1,019.

Options A and C: 10.0.5.0/22 is not properly aligned (invalid). Options B and D both use 10.0.8.0/22 but differ in usable IPs: B says 1,019, D says 1,021. AWS reserves 5 IPs per subnet: network, VPC router, DNS, future, broadcast = 5 reserved. 1,024 - 5 = 1,019. **Answer: B** (10.0.8.0/22, 1,019 usable).

Actually, re-reading: A says "10.0.5.0/22 — provides 1,019 usable IPs" and B says "10.0.8.0/22 — provides 1,019 usable IPs". The key difference is the starting CIDR. 10.0.5.0 is NOT a valid /22 boundary. A /22 must start at .0, .4, .8, or .12 (multiples of 4 in the third octet). So 10.0.5.0/22 is invalid. **Answer: B**.

### Question 17
**Correct Answer: A**

A Site-to-Site VPN over Direct Connect public VIF provides:
- IPsec encryption (unlike MACsec which is Layer 2 only).
- Traffic stays on the Direct Connect link (doesn't traverse public internet).
- The public VIF provides access to AWS public endpoints (including VPN endpoints).
- Option B: MACsec is Layer 2 encryption, different from IPsec.
- Option C: VPN cannot run over a private VIF because VPN endpoints have public IPs.
- Option D: CloudHSM provides application-level encryption, not transport-layer.

### Question 18
**Correct Answer: A, B**

To analyze flow logs with Athena:
1. Create an Athena table that maps to the flow log schema in S3 with Parquet format.
2. Query the table filtering for rejected traffic, grouping by source IP and destination port.
- Option C: Flow logs can be sent directly to S3 — CloudWatch Logs is not required.
- Option D: Flow logs in Parquet format are already queryable by Athena — no transformation needed.
- Option E: AWS Config doesn't analyze flow log traffic data.

### Question 19
**Correct Answer: A**

ALB supports weighted target group forwarding in a single rule:
- Configure percentage-based traffic split (95/5).
- CloudWatch alarms on the canary target group metrics detect issues.
- Lambda updates the weights to roll back.
- Option B: Route 53 weighted routing operates at DNS level — too coarse and slow for canary rollback.
- Option C: CodeDeploy linear deployment is different from weighted ALB routing.
- Option D: ALB can't match on percentage of requests via rules alone.

### Question 20
**Correct Answer: A**

Minimum architecture with redundancy:
- 3 locations × 2 connections each = 6 Direct Connect connections for redundancy.
- A Direct Connect Gateway associated with Transit Gateways provides regional connectivity.
- Inter-region TGW peering enables cross-region and cross-location communication through AWS.
- Option B: VPC peering doesn't help on-premises locations communicate through AWS.
- Option C: Single connection has no redundancy and VPN adds latency.
- Option D: Concentrating all connections in one location creates a single point of failure.

### Question 21
**Correct Answer: A**

CloudFront VPC origins (launched 2024) allow CloudFront to access origins in private subnets without any public internet path:
- The ALB has no public IP and no internet route.
- CloudFront connects through the AWS private network.
- This is the strongest security posture — no public exposure at all.
- Option B works but relies on a shared secret that could be discovered.
- Option C: CloudFront IP ranges change frequently and the prefix list allows any CloudFront distribution, not just yours.
- Option D: WAF IP filtering has the same limitation as C.

### Question 22
**Correct Answer: A, D**

Transit Gateway route table segmentation for hub-and-spoke isolation:
- A: Describes the correct route table architecture — Shared table (for VPC-A) has all routes; Isolated table (for spoke VPCs) only routes to VPC-A.
- D: Confirms the association — spoke VPCs are associated with the Isolated table, VPC-A with the Shared table.
- B: Route propagation is a mechanism detail — VPC-A propagates to the Isolated table so spokes can reach it. This is correct and is part of A's description.
- C: NACLs are not the right tool for TGW-level isolation.
- E: A single route table with all routes would allow spoke-to-spoke traffic.

### Question 23
**Correct Answer: A**

The Reachability Analyzer identified the RDS security group as the blocking component. The RDS security group references a security group ID that doesn't match the EC2 instance's security group. The simplest fix is to update the RDS security group to reference the correct EC2 security group.
- Option B would work but modifies the EC2 instance's group membership, which could have unintended side effects.
- Option C: Peering is irrelevant — both are in the same VPC.
- Option D: NACLs are not the identified issue.

### Question 24
**Correct Answer: A**

This is the standard three-tier subnet architecture:
- Web (public): IGW route for internet access.
- Application (private): NAT Gateway for outbound internet only.
- Database (isolated): Only local route — no internet path.
- NACLs on database subnets add defense-in-depth.
- Option B: Shared route table with IGW gives all tiers internet access.
- Option C: Database tier should not have internet access.
- Option D: Over-engineering with separate VPCs for what subnets can achieve.

### Question 25
**Correct Answer: A**

Egress-Only Internet Gateway is the IPv6 equivalent of a NAT Gateway:
- Allows outbound IPv6 connections.
- Blocks inbound IPv6 connection initiation.
- IPv6 addresses are globally unique — no NAT is needed, just access control.
- Option B: NAT Gateway doesn't support IPv6 NAT (IPv6 doesn't need NAT).
- Option C: IGW allows both inbound and outbound — doesn't provide the protection needed.
- Option D: NAT64 is for IPv6-only networks accessing IPv4 services.

### Question 26
**Correct Answer: A, B, C**

Defense-in-depth for PCI DSS requires:
- A: Network Firewall for perimeter IDS/IPS with stateful inspection.
- B: Security group microsegmentation using SG references for dynamic scaling.
- C: VPC Flow Logs for audit logging and anomaly detection.
- D: NACLs are too coarse for primary security and don't track connections.
- E: Shield Advanced is for DDoS, not general defense-in-depth.
- F: WAF between internal microservices is unnecessary overhead.

### Question 27
**Correct Answer: A**

CloudFront cache behaviors allow different origins and caching policies per path pattern:
- `/static/*` uses S3 with OAC (secure, no public access needed) and long TTL.
- `/api/*` uses ALB with TTL=0 (no caching) and forwards all dynamic content.
- OAC is the current best practice (replacing OAI).
- Option B: Lambda@Edge for origin selection is over-engineering for simple path-based routing.
- Option C: Separate distributions add DNS complexity.
- Option D: Making S3 public violates security best practices.

### Question 28
**Correct Answer: A**

Transit Gateway uses longest prefix match for routing:
- /16 is more specific than /8.
- The static route for 10.0.0.0/16 → VPC attachment wins over the BGP route 10.0.0.0/8 → Direct Connect.
- The packet reaches the VPC instance.
- Option B: No loop — routes are deterministic with longest prefix match.
- Option C: Overlapping routes are handled by prefix length.
- Option D: BGP route priority doesn't override longer prefix matches.

### Question 29
**Correct Answer: A**

CloudFront signed URLs with custom policy provide:
- Per-URL expiration (4 hours).
- IP address restriction (prevents URL sharing to different IPs).
- Trusted key groups for key management.
- Option B: Signed cookies work for multiple resources but don't restrict by IP.
- Option C: WAF JWT inspection adds complexity and latency.
- Option D: S3 presigned URLs bypass CloudFront benefits (caching, DDoS protection, edge delivery).

### Question 30
**Correct Answer: A, B**

Hybrid DNS with Route 53 Resolver:
- Inbound endpoints: On-premises DNS forwards AWS queries to these endpoints.
- Outbound endpoints: AWS instances forward on-premises domain queries through these endpoints to on-premises DNS.
- Option C: Replacing VPC DNS entirely breaks AWS service DNS resolution.
- Option D: On-premises can't reach the VPC .2 resolver directly.
- Option E: Simple AD doesn't solve general DNS forwarding.

### Question 31
**Correct Answer: A**

Transit Gateway VPN supports ECMP:
- Multiple VPN connections can be created to the same Transit Gateway.
- Each VPN has 2 tunnels (1.25 Gbps each).
- ECMP distributes traffic across all tunnels with equal-cost routes.
- For example, 4 VPN connections = 8 tunnels × 1.25 Gbps = 10 Gbps maximum.
- Option B: A single VPN connection only has 2 tunnels — limited to 2.5 Gbps total.
- Option C: VGW doesn't support ECMP.
- Option D: VPN does support ECMP with TGW.

### Question 32
**Correct Answer: A**

Centralized inspection VPC pattern:
- Spoke route table: default route to inspection VPC — all traffic from spokes goes to firewall first.
- Firewall route table: specific routes back to each spoke VPC.
- Appliance mode: ensures symmetric routing for stateful inspection.
- Option B: Distributed firewalls don't centralize inspection.
- Option C: Flow logs are passive — they don't block traffic.
- Option D: TGW attachments don't have security groups.

### Question 33
**Correct Answer: A**

AWS PrivateLink provides the most restrictive connectivity:
- Only exposes a specific service (port 5432) through an NLB.
- No broader network connectivity between VPCs.
- Account-level access control via allow-list.
- Option B: VPC peering provides full network connectivity (security groups add filtering but not isolation).
- Option C: Transit Gateway provides network-level routing — broader than needed.
- Option D: API Gateway adds unnecessary complexity for database connectivity.

### Question 34
**Correct Answer: A**

CIDR analysis:
- VPC: 10.0.0.0/16 (10.0.0.0 - 10.0.255.255).
- Existing subnets: 10.0.0.0/24 through 10.0.5.0/24 (10.0.0.0 - 10.0.5.255).
- 10.0.8.0/21 covers 10.0.8.0 - 10.0.15.255 (2,048 IPs, 2,043 usable).
- No overlap with existing subnets.
- 10.0.8.0 is correctly aligned for /21 (8 is a multiple of 8, which is 2^(24-21)).
- Option B: 10.0.8.0/21 ends at 10.0.15.255, well clear of 10.0.5.255.
- Option C: /21 can exist in /16.
- Option D: /21 = 2,048 total, 2,043 usable (not 1,024).

### Question 35
**Correct Answer: A**

NLB supports ALB as a target type:
- NLB provides static Elastic IPs (one per AZ).
- ALB provides Layer 7 routing (path-based, host-based).
- This combination provides both capabilities.
- Option B: You cannot assign Elastic IPs to an ALB.
- Option C: Global Accelerator provides 2 IPs (not per-AZ) — close but not static per AZ.
- Option D: NLB doesn't support path-based routing natively.

### Question 36
**Correct Answer: A, B**

For immediate identification and continuous monitoring:
- A: VPC Flow Logs + Athena query identifies the source IPs of SSH connections immediately.
- B: GuardDuty provides ongoing anomaly detection for unauthorized access patterns.
- Option C: CloudTrail logs API calls, not network connections.
- Option D: Config rules check security group configurations, not actual traffic.
- Option E: Inspector checks for vulnerabilities, not active connections.

### Question 37
**Correct Answer: A**

VPC endpoint types:
- S3 and DynamoDB support gateway endpoints (free of charge).
- SQS only supports interface endpoints (charged per hour per AZ + per GB).
- Option B: Using interface endpoints for S3 and DynamoDB is not cost-optimized.
- Option C: NAT Gateway is more expensive than gateway endpoints.
- Option D: SQS does not support gateway endpoints.

### Question 38
**Correct Answer: A**

Transit Gateway uses longest prefix match:
- 192.168.1.0/24 (static) is more specific than 192.168.0.0/16 (BGP).
- Traffic to 192.168.1.50 matches the /24 route → inspection VPC.
- Route type (static vs BGP) doesn't matter — prefix length wins.
- Option B: BGP routes don't take priority over longer prefix matches.
- Option C: Overlapping prefixes are resolved by longest match.
- Option D: ECMP only applies to equal-length prefixes.

### Question 39
**Correct Answer: A, B**

Two-layer protection:
- A: CloudFront geo-restriction blocks access from specified countries at the CDN level.
- B: OAC ensures only this specific CloudFront distribution can access S3 — prevents direct S3 access.
- Option C: Route 53 geolocation doesn't affect CloudFront distribution access.
- Option D: S3 Block Public Access doesn't provide geographic filtering.
- Option E: WAF geo-match works but adds cost — CloudFront's built-in geo-restriction is simpler.

### Question 40
**Correct Answer: A**

Cross-region latency is primarily determined by physical distance:
- VPC peering uses the AWS backbone — already the optimal path.
- Transit Gateway peering adds an extra hop (slightly higher latency).
- No networking change can overcome physics (speed of light through fiber).
- Option B: TGW peering would increase latency.
- Option C: Direct Connect is for on-premises to AWS, not region-to-region.
- Option D: Global Accelerator helps public internet traffic, not VPC-to-VPC.

### Question 41
**Correct Answer: A**

Centralized egress architecture:
- Spoke TGW route table: 0.0.0.0/0 → shared services VPC attachment.
- Traffic flow: Spoke → TGW → Shared Services VPC → Network Firewall → NAT Gateway → IGW.
- Shared services TGW route table needs return routes to spoke VPC CIDRs.
- Option B: Decentralized NAT doesn't centralize inspection.
- Option C: Missing TGW route table configuration means traffic won't route correctly.
- Option D: PrivateLink is not for internet egress.

### Question 42
**Correct Answer: A**

For TLS passthrough on NLB:
- Use a TCP listener (not TLS listener) — NLB doesn't decrypt.
- Target group protocol is TCP — NLB forwards encrypted packets as-is.
- EC2 instances handle TLS termination.
- Option B: Keeping TLS listener means NLB still terminates TLS.
- Option C: NLB supports TCP passthrough for TLS.
- Option D: Proxy Protocol preserves metadata, not TLS sessions.

### Question 43
**Correct Answer: A, B**

Automatic failover with notification:
- A: Route 53 health checks with SNS notifications alert the team when health status changes.
- B: Failover routing policy automatically switches DNS to the secondary when the primary is unhealthy.
- Option C: Latency-based routing doesn't automatically failover on health.
- Option D: Manual DNS updates are slower than automatic failover routing.
- Option E: ARC provides additional control but isn't required for basic failover.

### Question 44
**Correct Answer: A**

AWS RAM shares Transit Gateway across accounts:
- Share with the entire Organization or specific OUs.
- Member accounts create their own VPC attachments.
- Centralized routing management stays in the networking account.
- Option B: Service Catalog distributes products, not network resources.
- Option C: StackSets deploy resources but don't share existing ones.
- Option D: Cross-account roles provide access but not Transit Gateway sharing.

### Question 45
**Correct Answer: A**

AWS Cloud WAN provides centralized management:
- Global network with policy-based connectivity.
- Manages VPN connections to branch offices.
- Centralized monitoring and routing.
- Option B: Individual VPN connections lack centralized management.
- Option C: Direct Connect at branch offices is expensive for 50 Mbps.
- Option D: Client VPN is for individual users, not site-to-site.

### Question 46
**Correct Answer: A, D**

350-second timeout matches NAT Gateway behavior:
- A: NAT Gateway drops idle TCP connections after 350 seconds. If the traffic path includes a NAT Gateway, this is the likely cause. However, in same-VPC private-to-private communication, NAT Gateway shouldn't be in the path. Check if traffic is incorrectly routing through a NAT Gateway.
- D: TCP keep-alive settings on the application or OS should be configured with intervals shorter than any intermediate timeout. This is the most common resolution.
- Option B: Security group connection tracking timeout is 5 days for established connections.
- Option C: NACLs don't have idle timeouts.
- Option E: RDS performance issues would show in monitoring metrics.

### Question 47
**Correct Answer: A**

VPCs support secondary CIDR blocks:
- Up to 5 CIDR blocks by default, extendable to 50.
- New subnets created in the secondary CIDR.
- No disruption to existing workloads.
- Option B: Migration is extremely disruptive and unnecessary.
- Option C: Existing CIDR blocks cannot be modified.
- Option D: IPv6 doesn't replace IPv4 requirements.

### Question 48
**Correct Answer: A**

ALB supports SNI:
- Multiple certificates on a single HTTPS listener.
- ALB selects the correct certificate based on the hostname.
- Combined with host-based routing rules for different target groups.
- Option B: Multiple ports is unnecessary with SNI.
- Option C: ALB supports SNI — wildcard certificate is optional.
- Option D: Multiple ALBs is unnecessary with SNI.

### Question 49
**Correct Answer: A**

Common connectivity troubleshooting order:
1. TGW route table for the VPC attachment must have the destination route.
2. VPC subnet route table must have a route to the TGW for the destination.
- Missing VPC route table entries is the most common oversight.
- Options B, C, D: Public IP and IGW are irrelevant for private TGW connectivity.

### Question 50
**Correct Answer: A, B**

Private hosted zone cross-region association:
- Create the hosted zone with one VPC association.
- Add additional VPC associations from other regions.
- Cross-region VPC association is supported for private hosted zones.
- Option C: Separate hosted zones create management overhead and inconsistency.
- Option D: Resolver endpoints are for hybrid DNS, not cross-region PHZ.
- Option E: VPC peering is not required for private hosted zone resolution.

### Question 51
**Correct Answer: A**

NLB sticky sessions for UDP:
- Source IP affinity (stickiness) ensures all packets from the same source go to the same target.
- Critical for stateful UDP protocols like gaming.
- Option B: ALB doesn't support UDP.
- Option C: Cross-zone load balancing distributes traffic but doesn't ensure stickiness.
- Option D: Proxy Protocol is for metadata, not session affinity.

### Question 52
**Correct Answer: A**

VPC Reachability Analyzer:
- Automated path analysis from source to destination.
- Evaluates all components: route tables, NACLs, security groups, TGW routes.
- Identifies the specific blocking component.
- Option B: Flow Logs show what happened but don't diagnose why.
- Option C: Network Monitor is for performance, not path analysis.
- Option D: X-Ray is for application tracing, not network paths.

### Question 53
**Correct Answer: A**

IP-efficient subnet design:
- Public: /26 = 64 IPs, 59 usable (≥50 ✓). 2 subnets = 128 IPs.
- Private app: /25 = 128 IPs, 123 usable (≥100 ✓). 2 subnets = 256 IPs.
- Private DB: /27 = 32 IPs, 27 usable (≥20 ✓). 2 subnets = 64 IPs.
- Total: 448 IPs used, leaving 576 for future.
- Option B: Exceeds VPC CIDR.
- Option C: Uses more IPs than necessary.
- Option D: /28 doesn't meet the 50 IP requirement for public subnets.

### Question 54
**Correct Answer: A**

BFD on Direct Connect:
- Sub-second failure detection.
- Triggers rapid BGP convergence.
- Much faster than BGP hold timer (default 90 seconds).
- Option B: TCP keep-alives are slower than BFD.
- Option C: Multiple BGP sessions on one VIF don't add link failure detection.
- Option D: Auto-Recovery doesn't exist as a Direct Connect feature.

### Question 55
**Correct Answer: A, C**

Bandwidth considerations for centralized egress:
- A: 3 NAT Gateways × 45 Gbps = 135 Gbps capacity. Traffic must be distributed by routing each AZ to its local NAT Gateway.
- C: Transit Gateway has a per-attachment bandwidth limit of 50 Gbps. Total aggregate of 120 Gbps requires careful distribution across attachments.
- Option B: TGW doesn't ECMP across NAT Gateways.
- Option D: NAT Instances have lower throughput than NAT Gateways.
- Option E: Single NAT Gateway caps at 45 Gbps.

### Question 56
**Correct Answer: A**

ALB rule evaluation:
- Rules are evaluated in priority order (lowest number first).
- A header-based rule with the highest priority (lowest number) is evaluated before path-based rules.
- If X-Debug: true matches, traffic goes to Target Group C regardless of path.
- Option B: AND logic would require both header and path to match.
- Option C: Separate listeners are unnecessary.
- Option D: Lambda@Edge is a CloudFront feature, not ALB.

### Question 57
**Correct Answer: A**

Accelerated VPN requirements:
- Must use Transit Gateway attachment (not Virtual Private Gateway).
- Acceleration uses Global Accelerator endpoints.
- Supports both IPv4 and IPv6 BGP within IPsec tunnels.
- Option B: VGW doesn't support accelerated VPN.
- Option C: Global Accelerator can't be added separately to VPN.
- Option D: VPN supports both IPv6 and acceleration with TGW.

### Question 58
**Correct Answer: A**

VPC peering requires bidirectional route table entries:
- VPC-A has a route to VPC-C ✓.
- VPC-C needs a return route to VPC-A — this is likely missing.
- Option B: A↔C peering exists — traffic doesn't need to transit through B.
- Option C: Possible but the question states SG allows traffic from 10.1.0.0/16.
- Option D: DNS resolution is for hostname resolution, not IP connectivity.

### Question 59
**Correct Answer: C**

When using CloudFront with a Regional API Gateway:
- Keep the Regional endpoint for control over caching behavior.
- Adjust API Gateway throttling to account for CloudFront retry behavior.
- Use cache behaviors to reduce origin requests.
- Option A: Edge-Optimized creates its own CloudFront distribution — you lose control over caching configuration.
- Option B: API Gateway doesn't have built-in edge caching.
- Option D: Global Accelerator doesn't provide caching.

### Question 60
**Correct Answer: A, B, C**

Hub-and-spoke with isolation and inspection:
- A: Two route tables enforce spoke-to-hub only routing (no spoke-to-spoke).
- B: Auto-accept and auto-propagation ensures new spokes are connected automatically.
- C: Network Firewall in the hub inspects all egress traffic.
- Option D: VPC peering bypasses the Transit Gateway architecture.
- Option E: RAM sharing and SCPs are for governance, not routing.
- Option F: Individual spoke route tables with the same config is unnecessary — one shared table works.

### Question 61
**Correct Answer: A**

NAT Gateway supports multiple Elastic IPs:
- A single NAT Gateway can have up to 8 EIPs (secondary EIPs were added).
- This allows a NAT Gateway to use multiple outbound IPs.
- 5 NAT Gateways or fewer NAT Gateways with secondary EIPs both work.
- Option B: EC2 instances in private subnets don't use public IPs for outbound.
- Option C: NAT Gateways support more than 1 EIP via secondary EIPs.
- Option D: NLB is for inbound, not outbound NAT.

### Question 62
**Correct Answer: A**

CIDR alignment:
- 10.0.128.0 in binary: 00001010.00000000.10000000.00000000.
- /17 mask covers the upper half: 10.0.128.0 - 10.0.255.255.
- This fits within 10.0.0.0/16 (10.0.0.0 - 10.0.255.255).
- /17 = 32,768 IPs — the largest aligned block from 10.0.128.0.
- Option B: /16 from 10.0.128.0 would exceed the VPC CIDR.
- Option C: /18 is smaller than /17 — not the largest possible.
- Option D: /24 is much smaller than the maximum.

### Question 63
**Correct Answer: A, B**

Hybrid Active Directory and DNS:
- A: AWS Managed Microsoft AD with trust to on-premises AD enables seamless authentication.
- B: Route 53 Resolver outbound endpoints forward on-premises domain queries to on-premises DNS.
- Option C: Standalone AD doesn't integrate with on-premises.
- Option D: Replacing VPC DNS entirely breaks AWS service resolution.
- Option E: AWS SSO doesn't authenticate EC2 instances.

### Question 64
**Correct Answer: A**

CloudFront ACM certificate region requirement:
- CloudFront REQUIRES ACM certificates in us-east-1.
- This is the most common cause of SSL errors with CloudFront.
- Option B: If the certificate isn't associated, CloudFront uses the default certificate.
- Option C: CNAME issues cause resolution failures, not SSL errors.
- Option D: Single-domain certificates work fine — wildcard is not required.

### Question 65
**Correct Answer: A**

Comprehensive network observability requires multiple services:
- VPC Flow Logs: Traffic visibility across all VPCs.
- Transit Gateway Flow Logs: TGW traffic visibility.
- Athena: Historical analysis and compliance queries.
- GuardDuty: Automated anomaly detection.
- CloudWatch: Real-time metrics and contributor insights.
- Option B: 100% traffic mirroring is expensive and doesn't scale.
- Option C: Third-party agents add management overhead.
- Option D: CloudTrail captures API calls, not network traffic.
