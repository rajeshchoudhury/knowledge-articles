# Practice Exam 21 - AWS Solutions Architect Associate (SAA-C03)

## Networking Deep Dive

### Exam Details
- **Total Questions:** 65
- **Time Limit:** 130 minutes
- **Question Types:** Multiple choice and multiple response
- **Passing Score:** 720/1000

### Domain Distribution
| Domain | Questions |
|--------|-----------|
| Security | ~20 |
| Resilient Architecture | ~17 |
| High-Performing Technology | ~16 |
| Cost-Optimized Architecture | ~12 |

---

### Question 1
A company operates a three-tier web application in a single VPC across two Availability Zones. The architecture consists of public-facing ALBs, application servers in private subnets, and RDS databases in isolated subnets. A security audit reveals that the application servers are initiating outbound connections to the internet through NAT Gateways to download OS patches. The security team requires that all outbound traffic be inspected for data exfiltration before leaving the VPC, while maintaining the ability to download patches.

Which solution meets these requirements with the LEAST operational overhead?

A) Deploy AWS Network Firewall in a dedicated firewall subnet in each AZ. Update route tables so that traffic from private subnets routes through the Network Firewall endpoints before reaching the NAT Gateways. Create stateful rules to inspect and allow patch-related traffic while blocking unauthorized data transfers.

B) Deploy a fleet of third-party firewall EC2 instances in an Auto Scaling group behind a Gateway Load Balancer. Configure route tables to send traffic through the GWLB endpoints. Manage firewall rules on the EC2 instances to inspect outbound traffic.

C) Replace the NAT Gateways with NAT instances that have iptables rules configured to inspect and filter outbound traffic. Enable VPC Flow Logs to monitor all traffic patterns.

D) Configure VPC Security Groups on the application servers to only allow outbound connections to known patch repository IP ranges. Use VPC Flow Logs with CloudWatch alarms to detect unexpected outbound traffic.

---

### Question 2
A multinational corporation has 15 VPCs across three AWS Regions (us-east-1, eu-west-1, ap-southeast-1). Each region has 5 VPCs. The company needs full mesh connectivity between all VPCs within each region, and also needs inter-region connectivity between specific VPCs. The company's network team wants centralized route management and the ability to segment traffic between production and development VPCs.

Which architecture provides the MOST scalable and manageable solution?

A) Create a Transit Gateway in each region. Attach all VPCs in each region to their respective Transit Gateway. Create Transit Gateway peering connections between the three regions. Use Transit Gateway route tables to segment production and development traffic.

B) Create VPC peering connections between all VPCs within each region and across regions. Use route table entries to control traffic flow between production and development VPCs.

C) Deploy a hub-and-spoke VPN architecture with a central VPN server in each region. Connect all VPCs through VPN tunnels to the central server. Use the VPN server to route and filter traffic.

D) Create a single Transit Gateway in us-east-1 and attach all 15 VPCs from all three regions directly to it. Use a single route table for all traffic management.

---

### Question 3
A company is planning its VPC CIDR allocation strategy for a new multi-account AWS environment. The company expects to create up to 50 VPCs over the next 3 years. Their on-premises network uses the 10.0.0.0/8 address space with 10.0.0.0/16 through 10.20.0.0/16 already allocated. Each VPC needs to support at least 4 subnets across 3 Availability Zones with a minimum of 250 usable IP addresses per subnet.

What is the MINIMUM VPC CIDR block size that meets these requirements, and which CIDR range should be used?

A) /22 VPC CIDR from the 10.21.0.0/8 range, allowing 12 /26 subnets per VPC

B) /20 VPC CIDR from the 10.21.0.0/8 range, allowing 12 /24 subnets per VPC

C) /21 VPC CIDR from the 10.21.0.0/8 range, allowing 12 /25 subnets per VPC

D) /16 VPC CIDR from the 10.21.0.0/8 range, allowing 12 /20 subnets per VPC

---

### Question 4
A company has established an AWS Direct Connect connection with a 10 Gbps dedicated connection at a colocation facility. They need to access resources in three separate VPCs (Production, Staging, and Development) across two AWS Regions (us-east-1 and eu-west-1). The Production VPC is in us-east-1, while Staging and Development are in eu-west-1. The company wants to minimize the number of Direct Connect connections while maintaining network isolation between environments.

Which configuration achieves these requirements?

A) Create one private virtual interface (VIF) associated with a Direct Connect Gateway. Associate the Direct Connect Gateway with a Transit Gateway in each region. Attach all three VPCs to their respective Transit Gateway. Use Transit Gateway route tables for environment isolation.

B) Create three private VIFs on the existing connection, one for each VPC. Associate each VIF directly with the respective VPC's virtual private gateway.

C) Create one public VIF for all VPCs and use VPN connections over the public VIF to each VPC for isolation.

D) Create two private VIFs, one per region. Associate each VIF with a Direct Connect Gateway connected to all VPCs in that region. Use security groups for environment isolation.

---

### Question 5
A company is deploying a microservices application using Amazon ECS with AWS Fargate. The application consists of 12 microservices that communicate with each other. The security team requires that all inter-service communication stays within the AWS network and never traverses the public internet. Some services need to access Amazon S3, DynamoDB, and Amazon ECR. The company also needs to access third-party APIs over HTTPS.

Which combination of steps meets these requirements? (Choose THREE)

A) Create a VPC endpoint gateway for Amazon S3 and DynamoDB

B) Create VPC endpoint interfaces for Amazon ECR (ecr.api, ecr.dkr, and logs endpoints)

C) Deploy all ECS services in public subnets with public IP addresses and use security groups to restrict traffic

D) Deploy a NAT Gateway in a public subnet for third-party API access

E) Use AWS PrivateLink to connect all 12 microservices through Network Load Balancers

F) Create VPC endpoint interfaces for S3 and DynamoDB instead of gateway endpoints for better security

---

### Question 6
A financial services company hosts a trading platform that requires the lowest possible latency between their application servers in us-east-1 and a disaster recovery site in us-west-2. The application handles real-time market data and requires consistent network performance. The company has an existing 10 Gbps Direct Connect connection in us-east-1.

Which solution provides the LOWEST and MOST consistent latency for cross-region traffic?

A) Use the existing Direct Connect connection with a transit VIF to a Direct Connect Gateway, then peer the Transit Gateways in both regions for cross-region routing over the AWS backbone.

B) Create a VPC peering connection between the VPCs in us-east-1 and us-west-2. Traffic will route over the AWS global backbone.

C) Set up a Site-to-Site VPN connection between the two regions over the public internet with accelerated VPN using AWS Global Accelerator.

D) Deploy a second Direct Connect connection in us-west-2 and use Direct Connect Gateway to route traffic between the two connections through the AWS backbone.

---

### Question 7
A company is migrating to AWS and needs to design a VPC that supports 6 subnets per Availability Zone across 3 AZs (public, private application, private database, management, shared services, and reserved for future use). Each subnet requires at least 500 usable IP addresses. The VPC CIDR must leave room for future expansion using secondary CIDR blocks.

What is the MOST efficient primary VPC CIDR allocation?

A) 10.0.0.0/16 with /22 subnets (1,019 usable IPs each)

B) 10.0.0.0/18 with /23 subnets (507 usable IPs each)

C) 10.0.0.0/20 with /24 subnets (251 usable IPs each)

D) 10.0.0.0/19 with /23 subnets (507 usable IPs each)

---

### Question 8
A company runs a hybrid application with components on-premises and in AWS. The on-premises DNS servers resolve internal domains (corp.example.com), and Route 53 resolves AWS-hosted domains (aws.example.com). Currently, on-premises servers cannot resolve AWS-hosted domain names, and AWS resources cannot resolve on-premises domain names. The company needs bidirectional DNS resolution between on-premises and AWS without modifying the on-premises DNS infrastructure significantly.

Which solution provides bidirectional DNS resolution with the LEAST operational overhead?

A) Create Route 53 Resolver inbound endpoints for on-premises to resolve AWS domains, and Route 53 Resolver outbound endpoints with forwarding rules to forward queries for corp.example.com to on-premises DNS servers.

B) Deploy EC2-based DNS servers in AWS that act as forwarders. Configure them to forward corp.example.com queries to on-premises and aws.example.com queries to Route 53. Update on-premises DNS to forward aws.example.com to these EC2 DNS servers.

C) Configure Route 53 public hosted zones for both domains and update on-premises DNS to use Route 53 public DNS endpoints for resolution.

D) Use Route 53 Private Hosted Zones associated with the VPC and configure DHCP option sets to point to on-premises DNS servers for all resolution.

---

### Question 9
A media company uses Amazon CloudFront to distribute video content globally. They have three origin types: an S3 bucket for static assets, an Application Load Balancer for dynamic API responses, and a MediaPackage endpoint for live streaming. The company needs to route requests based on URL path patterns: /static/* to S3, /api/* to the ALB, and /live/* to MediaPackage. Additionally, static assets should be cached for 30 days, API responses for 60 seconds, and live streams should not be cached.

Which CloudFront configuration achieves this?

A) Create a single CloudFront distribution with three origins. Configure three cache behaviors: /static/* with a 30-day TTL pointing to S3, /api/* with a 60-second TTL pointing to the ALB, and /live/* with TTL of 0 and all headers forwarded pointing to MediaPackage.

B) Create three separate CloudFront distributions, one for each origin. Use Route 53 with weighted routing to distribute traffic among the three distributions based on URL path.

C) Create a single CloudFront distribution with the S3 origin as default. Use Lambda@Edge to inspect the URL path and redirect requests to the appropriate origin.

D) Create a single CloudFront distribution with the ALB as the only origin. Configure the ALB to route requests to S3 and MediaPackage based on path patterns.

---

### Question 10
A company's application in a private subnet needs to call AWS services including Amazon S3, DynamoDB, SQS, SNS, and Kinesis Data Streams. The security team mandates that no traffic should traverse the public internet. The company wants to minimize costs while ensuring all five services are accessible.

Which approach minimizes costs while meeting the security requirement?

A) Create VPC gateway endpoints for S3 and DynamoDB (free), and VPC interface endpoints for SQS, SNS, and Kinesis Data Streams.

B) Create VPC interface endpoints for all five services to maintain consistency in the architecture.

C) Deploy a NAT Gateway and configure it with a restrictive security group that only allows traffic to AWS service endpoints.

D) Create a single VPC interface endpoint with AWS PrivateLink that provides access to all five services through a unified endpoint.

---

### Question 11
A company operates a SaaS platform that needs to be exposed to customers in other AWS accounts without exposing the service to the public internet. The platform runs behind a Network Load Balancer in the provider's VPC. Customers have varying security requirements — some need to access the service from specific subnets, and others need DNS-based access.

Which approach allows the company to expose the service securely to multiple customer AWS accounts? (Choose TWO)

A) Create a VPC endpoint service (AWS PrivateLink) powered by the NLB. Allow specific customer AWS account IDs to create interface VPC endpoints to the service.

B) Create VPC peering connections between the provider VPC and each customer VPC. Use security groups to control access.

C) Configure the NLB as public-facing with IP-based access control lists to restrict access to known customer IP ranges.

D) Enable customers to create interface VPC endpoints in their VPCs, which automatically creates ENIs in their specified subnets with private DNS names.

E) Share the provider VPC with customer accounts using AWS RAM (Resource Access Manager) to allow direct network access.

---

### Question 12
A company is designing a disaster recovery solution that requires their application to failover from the primary region (us-east-1) to a secondary region (eu-west-1) within 60 seconds. The application uses an Application Load Balancer and is accessed via app.example.com. The company needs health checks that verify the application's /health endpoint returns HTTP 200.

Which Route 53 configuration provides automatic failover within the required timeframe?

A) Create a Route 53 failover routing policy with health checks. Set the primary record to the us-east-1 ALB and the secondary to eu-west-1 ALB. Configure the health check with a 10-second interval, 3 failure threshold, and fast health check recovery (10-second interval).

B) Create a Route 53 weighted routing policy with 100% weight on the primary and 0% on the secondary. Use a CloudWatch alarm to trigger a Lambda function that updates the weights during failover.

C) Create Route 53 latency-based routing records for both regions. Configure health checks with "Evaluate Target Health" enabled. Set the TTL to 300 seconds.

D) Create a Route 53 simple routing policy with multiple values. List both ALB endpoints and let Route 53 automatically remove unhealthy endpoints.

---

### Question 13
A gaming company needs to provide the lowest possible latency for players connecting from anywhere in the world to their game servers running on EC2 instances in us-east-1 and eu-west-1. The game uses UDP for real-time game traffic on port 9000. The company wants traffic to automatically route to the nearest healthy endpoint.

Which solution provides the LOWEST latency for global players?

A) Deploy AWS Global Accelerator with endpoint groups in both regions. Configure the accelerator to listen on UDP port 9000. Add EC2 instance endpoints in each region with health checks.

B) Deploy Amazon CloudFront with custom origins pointing to the game servers. Configure CloudFront to forward UDP traffic on port 9000.

C) Configure Route 53 with latency-based routing pointing to Elastic IPs attached to the game servers in each region. Set the TTL to 10 seconds.

D) Deploy Network Load Balancers in each region with cross-region load balancing. Use Route 53 geolocation routing to direct players to the nearest NLB.

---

### Question 14
A company has a VPC (10.0.0.0/16) with an application that needs to communicate with a partner company's overlapping CIDR range (10.0.0.0/16). Both companies refuse to re-IP their networks. The connection must be private and not traverse the public internet.

Which solution allows communication between the overlapping CIDR ranges?

A) Use AWS PrivateLink. The partner exposes their application through an NLB-backed VPC endpoint service. The company creates an interface VPC endpoint which receives a unique private IP from the company's VPC CIDR, avoiding the overlap issue.

B) Create a VPC peering connection and use the overlapping CIDR with more specific routes in the route table to direct traffic.

C) Deploy a Transit Gateway and use NAT on the Transit Gateway to translate between the overlapping address spaces.

D) Configure a Site-to-Site VPN with NAT-Traversal to handle the overlapping CIDR ranges automatically.

---

### Question 15
A company is deploying AWS Network Firewall to inspect all traffic entering and leaving their VPC. The VPC has public subnets with an Internet Gateway, private subnets with application servers, and the application is fronted by an ALB in the public subnets. The company wants to inspect both ingress traffic from the internet to the ALB and egress traffic from private subnets to the internet.

Which deployment model correctly positions the Network Firewall? (Choose TWO)

A) Create dedicated firewall subnets between the Internet Gateway and the public subnets. Configure the IGW route table (ingress routing) to route traffic destined for public subnets through the firewall endpoints.

B) Place the Network Firewall endpoints in the same subnets as the ALB to minimize latency and simplify routing.

C) Configure the private subnet route table to route 0.0.0.0/0 traffic through the Network Firewall endpoints instead of directly to the NAT Gateway. Route traffic from the firewall subnets to the NAT Gateway.

D) Deploy the Network Firewall in a separate VPC and route all traffic through a Transit Gateway to the firewall VPC for inspection.

E) Configure the ALB security group to only allow traffic from the Network Firewall security group, and place the firewall in the private subnets.

---

### Question 16
A company's application uses an Application Load Balancer that must route traffic based on the following rules:
- api.example.com/v1/* → Target Group A (legacy API servers)
- api.example.com/v2/* → Target Group B (new API servers)  
- www.example.com/* → Target Group C (web servers)
- Any request with header "X-Debug: true" → Target Group D (debug servers)
- Default → Target Group E (catch-all)

How should the ALB listener rules be configured?

A) Create five listener rules in the following priority order: (1) host=api.example.com AND path=/v1/*, (2) host=api.example.com AND path=/v2/*, (3) host=www.example.com, (4) HTTP header X-Debug=true, (5) default action to Target Group E.

B) Create three separate ALBs — one for api.example.com, one for www.example.com, and one for debug traffic. Use Route 53 to direct traffic to the appropriate ALB.

C) Create a single listener rule with a Lambda function that inspects the request and forwards to the appropriate target group based on host, path, and headers.

D) Create separate listeners on different ports for each routing requirement and use client-side logic to connect to the correct port.

---

### Question 17
A company runs a high-performance computing (HPC) application on a cluster of 100 EC2 instances that requires inter-node communication with latency under 25 microseconds. The instances need to exchange large datasets (up to 100 GB) between nodes during computation phases. The application uses MPI (Message Passing Interface) for communication.

Which combination of features optimizes network performance for this workload? (Choose THREE)

A) Enable Elastic Fabric Adapter (EFA) on instances that support it

B) Use placement groups with cluster strategy to place all instances in the same AZ

C) Enable enhanced networking with Elastic Network Adapter (ENA) and jumbo frames (9001 MTU)

D) Deploy instances across multiple AZs for high availability with Transit Gateway for inter-AZ communication

E) Use io2 Block Express EBS volumes for faster network throughput

F) Enable EBS-optimized instances with gp3 volumes for better network bandwidth

---

### Question 18
A company has a Site-to-Site VPN connection to AWS that is experiencing intermittent connectivity issues. The connection uses a single VPN tunnel to a virtual private gateway. The company needs to improve the VPN reliability and ensure that their application can tolerate the loss of a single tunnel or endpoint.

Which design provides the HIGHEST availability for the VPN connection?

A) Create two Site-to-Site VPN connections to the virtual private gateway, each from a different customer gateway device at the on-premises location. This provides four tunnels total (two per VPN connection) across two AWS endpoints and two customer endpoints.

B) Create a single Site-to-Site VPN connection with both tunnels active (active/active) using BGP for dynamic routing and configure the customer gateway to use Equal-Cost Multi-Path (ECMP) routing.

C) Replace the VPN with a single AWS Direct Connect connection for improved reliability. Configure a backup VPN connection that activates when Direct Connect fails.

D) Create a single VPN connection and enable VPN CloudWatch monitoring to automatically restart the tunnel when it goes down.

---

### Question 19
A company needs to design a network architecture for a new application that will be deployed across three VPCs: a Shared Services VPC (10.1.0.0/16), a Production VPC (10.2.0.0/16), and a Development VPC (10.3.0.0/16). Requirements include: Production and Development VPCs must be able to access Shared Services but NOT communicate with each other. All VPCs are in the same region.

Which architecture enforces this isolation?

A) Create a Transit Gateway with two route tables: one for Production (with routes to Shared Services only) and one for Development (with routes to Shared Services only). Associate Production VPC attachment with the Production route table and Development VPC attachment with the Development route table. Associate Shared Services with both route tables with routes to both VPCs.

B) Create VPC peering between Production and Shared Services, and between Development and Shared Services. Do not create a peering between Production and Development.

C) Create a Transit Gateway with a single route table containing routes to all three VPCs. Use security groups and NACLs to block traffic between Production and Development.

D) Deploy the Shared Services in a separate AWS account and use AWS PrivateLink to expose each service individually to Production and Development VPCs.

---

### Question 20
A company operates an e-commerce platform with the following architecture: CloudFront → ALB → EC2 Auto Scaling Group. During a recent DDoS attack, the ALB was overwhelmed by a large volume of HTTP flood requests. The company wants to implement multiple layers of protection while maintaining application performance.

Which combination of services provides comprehensive DDoS protection? (Choose THREE)

A) Enable AWS Shield Advanced on the ALB and CloudFront distribution for enhanced DDoS protection and DDoS response team access

B) Configure AWS WAF on the CloudFront distribution with rate-based rules to limit requests per IP address

C) Configure the ALB security group to only accept traffic from CloudFront IP ranges, preventing direct access to the ALB

D) Deploy a fleet of EC2 instances running open-source DDoS mitigation software in front of the ALB

E) Enable VPC Flow Logs on the ALB subnets and create CloudWatch alarms for high traffic volumes

F) Disable the ALB public IP and make it internal-only, accessible only through CloudFront using a VPN connection

---

### Question 21
A healthcare company must ensure all data in transit between their on-premises data center and AWS is encrypted. They are using a 1 Gbps Direct Connect connection. The data includes PHI (Protected Health Information) subject to HIPAA regulations. The company needs encryption without significantly reducing throughput.

Which solution provides encryption for Direct Connect traffic while maintaining the BEST throughput?

A) Create a Site-to-Site VPN connection over the Direct Connect public VIF using the Direct Connect connection as the transport layer. This provides IPsec encryption while leveraging the dedicated bandwidth.

B) Enable MACsec encryption on the Direct Connect connection at the physical layer, providing line-rate encryption without throughput reduction (requires MACsec-capable hardware).

C) Use application-level TLS encryption for all data transfers over the Direct Connect private VIF. Configure all applications to use HTTPS/TLS 1.3.

D) Create a transit VIF on the Direct Connect connection and configure a VPN over the transit VIF through a Transit Gateway for encrypted connectivity.

---

### Question 22
A company has an application hosted in a VPC that needs to be accessed by thousands of consumer devices over the internet. The application runs on EC2 instances behind a Network Load Balancer and handles TCP connections on port 443. The application must support static IP addresses for firewall whitelisting by consumers. The company also needs to absorb sudden traffic spikes during product launches.

Which architecture satisfies these requirements?

A) Deploy an NLB with Elastic IP addresses assigned to each AZ. Enable cross-zone load balancing. The NLB provides static IPs and can handle sudden traffic spikes with its ability to scale to millions of requests.

B) Deploy an ALB with AWS Global Accelerator in front of it. Global Accelerator provides two static anycast IP addresses that consumers can whitelist.

C) Deploy an ALB with Elastic IP addresses attached directly to the ALB for static IP support.

D) Deploy EC2 instances with Elastic IP addresses behind a Route 53 multivalue routing policy for distributing traffic.

---

### Question 23
A company is designing a multi-region active-active architecture. They need to route users to the closest region while also being able to shift traffic away from a region during maintenance windows. The application is hosted behind ALBs in us-east-1, eu-west-1, and ap-southeast-1.

Which Route 53 routing configuration provides this capability?

A) Use latency-based routing with health checks for normal operation. During maintenance, set the health check for the region under maintenance to "invert health check" status to force failover to other regions.

B) Use geolocation routing with a default record. During maintenance, delete the geolocation record for the region under maintenance to fail over to the default.

C) Use weighted routing with equal weights across all regions. During maintenance, set the weight to 0 for the region under maintenance.

D) Use latency-based routing as alias records pointing to each regional ALB. During maintenance, disable the record for the region to trigger failover.

---

### Question 24
A company needs to connect 25 branch offices to their AWS environment. Each branch has a small router capable of IPsec VPN. The company wants to manage all branch connections centrally and needs branches to communicate with each other through AWS. The total aggregate bandwidth from all branches is approximately 5 Gbps.

Which solution provides centralized management and branch-to-branch communication?

A) Create a Transit Gateway and configure AWS Site-to-Site VPN connections from each branch to the Transit Gateway. Enable ECMP (Equal-Cost Multi-Path) routing on the Transit Gateway to aggregate VPN bandwidth. Configure the Transit Gateway route table to allow branch-to-branch routing.

B) Create a virtual private gateway and establish 25 individual Site-to-Site VPN connections. Configure static routes for each branch-to-branch communication path.

C) Deploy AWS Client VPN endpoints for each branch office. Configure the Client VPN to allow branch-to-branch communication through the VPN endpoint.

D) Deploy a software VPN hub on a large EC2 instance and configure IPsec tunnels from each branch to the EC2 instance. Manage routing centrally on the EC2 instance.

---

### Question 25
A company uses Amazon CloudFront to serve a web application. The application backend runs on EC2 instances behind an ALB in a private subnet. The company wants CloudFront to communicate with the ALB using HTTPS, and the ALB's domain name is internal-app-alb-123456.us-east-1.elb.amazonaws.com. The security team requires end-to-end encryption with valid certificates.

Which configuration establishes secure communication between CloudFront and the ALB?

A) Configure the CloudFront origin with HTTPS only protocol. Install an ACM public certificate on the ALB that matches the ALB's DNS name or a custom domain. Configure CloudFront to use the ALB's DNS name as the origin and set the origin protocol policy to "HTTPS Only."

B) Install a self-signed certificate on the ALB and configure CloudFront to trust the self-signed certificate by uploading the CA certificate to CloudFront.

C) Use CloudFront's origin access identity (OAI) to authenticate requests to the ALB, which automatically enables encrypted communication.

D) Configure CloudFront to use HTTP to communicate with the ALB since traffic between CloudFront and the ALB stays on the AWS network and is already encrypted by default.

---

### Question 26
A company is using VPC Flow Logs to monitor traffic patterns. They notice a large number of rejected connection attempts from a specific CIDR range (203.0.113.0/24) targeting their public-facing instances. The company wants to block this CIDR range at the earliest possible point in the network stack to reduce the load on their instances.

Where should the block be applied for MAXIMUM effectiveness?

A) Create a Network ACL rule on the public subnet to deny all inbound traffic from 203.0.113.0/24. NACLs are stateless and are evaluated before security groups, providing the earliest VPC-level block.

B) Update the security groups on the public-facing instances to add a deny rule for 203.0.113.0/24.

C) Configure AWS WAF with an IP set rule to block 203.0.113.0/24 and attach it to the ALB or CloudFront distribution.

D) Add a blackhole route in the VPC route table for 203.0.113.0/24 to drop traffic before it reaches any instance.

---

### Question 27
A company operates a multi-tier application with the following requirements for NLB configuration:
- Backend servers are in two AZs
- The application is stateful and requires session persistence
- Health checks must verify application-level health (not just TCP connectivity)
- The NLB must support TLS termination

Which combination of NLB features should be configured? (Choose THREE)

A) Enable sticky sessions (source IP affinity) on the target group for session persistence

B) Configure HTTP health checks on the target group with a specific path (e.g., /health) to verify application health

C) Configure a TLS listener on the NLB with an ACM certificate for TLS termination

D) Enable cookie-based stickiness on the NLB target group for session persistence

E) Configure TCP health checks since NLB only supports TCP-level health checks

F) Deploy an ALB behind the NLB for TLS termination since NLB cannot terminate TLS

---

### Question 28
A company is planning to deploy a centralized egress architecture for 20 VPCs connected through a Transit Gateway. All VPCs need internet access through a shared set of NAT Gateways in a central egress VPC. The total expected egress traffic is 15 Gbps.

Which architecture provides a cost-effective and resilient centralized egress solution?

A) Create an Egress VPC with NAT Gateways in multiple AZs. Attach all 20 VPCs and the Egress VPC to the Transit Gateway. Configure the Transit Gateway route table for spoke VPCs to route 0.0.0.0/0 to the Egress VPC attachment. In the Egress VPC, route traffic from the Transit Gateway subnets to the NAT Gateways.

B) Deploy NAT Gateways in each of the 20 VPCs individually for maximum availability. Use the Transit Gateway only for inter-VPC communication.

C) Deploy a fleet of NAT instances in an Auto Scaling group in the Egress VPC behind a Gateway Load Balancer. Route all egress traffic through the GWLB endpoint.

D) Configure a proxy server fleet in the Egress VPC and configure all applications across the 20 VPCs to use the proxy for internet access.

---

### Question 29
A company is migrating an application that requires multicast networking capabilities for a stock market data distribution system. The application uses UDP multicast to distribute real-time market data to multiple subscribers simultaneously. The application currently runs on-premises.

Which AWS networking feature supports this requirement?

A) Enable multicast on a Transit Gateway by creating a Transit Gateway multicast domain. Register the multicast sources and group members. Associate the subnets containing the sources and receivers with the multicast domain.

B) Configure an Application Load Balancer to replicate UDP packets to multiple targets simultaneously, simulating multicast behavior.

C) Use Amazon SNS to distribute the market data to multiple subscribers, replacing the UDP multicast with a pub/sub messaging model.

D) Deploy the application on EC2 instances in a placement group with cluster strategy and configure the instances to use standard IP multicast within the VPC.

---

### Question 30
A company has an existing application that uses hardcoded IP addresses 10.0.1.100 and 10.0.1.101 to communicate with two backend database servers. The company is migrating to AWS and wants to use Amazon RDS Multi-AZ for the database. However, the application code cannot be modified to use DNS-based endpoints.

Which solution allows the application to continue using the hardcoded IP addresses?

A) Deploy the application in a VPC and create two secondary private IP addresses (10.0.1.100 and 10.0.1.101) on an ENI attached to an EC2 instance running HAProxy or a similar proxy. Configure the proxy to forward traffic to the RDS endpoint.

B) Assign the specific IP addresses 10.0.1.100 and 10.0.1.101 directly to the RDS instance by specifying them during creation.

C) Create a Route 53 private hosted zone with A records mapping 10.0.1.100 and 10.0.1.101 to the RDS endpoint, then configure the application instances to use the Route 53 resolver.

D) Launch the RDS instance and use Elastic IP addresses 10.0.1.100 and 10.0.1.101 attached to the RDS endpoints.

---

### Question 31
A company runs an application across two AZs behind an Application Load Balancer. The application performs differently in each AZ — AZ-a instances handle 70% more requests per second than AZ-b instances because AZ-a uses newer instance types. The company notices that AZ-b instances are becoming overloaded while AZ-a instances have spare capacity.

Which ALB configuration addresses this imbalance?

A) Disable cross-zone load balancing on the ALB (it is enabled by default for ALBs) so that traffic is distributed based on AZ health, then use target group weights to route more traffic to the AZ-a target group.

B) ALBs have cross-zone load balancing enabled by default, which distributes requests evenly across all registered targets regardless of AZ. Replace the AZ-b instances with the same instance type as AZ-a to ensure uniform performance.

C) Configure weighted target groups. Create two target groups (one per AZ) and use ALB listener rules with forward actions that specify weights — 70% to the AZ-a target group and 30% to the AZ-b target group.

D) Enable connection draining with a long timeout on AZ-b instances so they have more time to process requests.

---

### Question 32
A company needs to implement split-horizon DNS for their domain example.com. Internal users on the corporate network should resolve app.example.com to private IP addresses (10.0.1.50), while external users on the internet should resolve the same domain to a public CloudFront distribution (d123.cloudfront.net).

Which configuration implements split-horizon DNS?

A) Create a Route 53 public hosted zone for example.com with a CNAME record for app.example.com pointing to d123.cloudfront.net. Create a Route 53 private hosted zone for example.com associated with the VPC, with an A record for app.example.com pointing to 10.0.1.50. The private hosted zone takes precedence for queries originating from the VPC.

B) Create a single Route 53 public hosted zone with a geolocation routing policy that routes corporate IP ranges to the private IP and all other traffic to CloudFront.

C) Configure the VPC DHCP option set with a custom DNS server that resolves app.example.com to 10.0.1.50. Use the public Route 53 hosted zone for external resolution.

D) Create two Route 53 public hosted zones for example.com — one with the private IP and one with the CloudFront CNAME. Use Route 53 traffic flow to route based on source IP.

---

### Question 33
A company has a VPC with the CIDR block 10.0.0.0/24 (256 total IPs). They have used all available IP addresses, and new instances cannot be launched. The company cannot change the existing CIDR block and needs to add more IP addresses to the VPC immediately.

Which solution adds more IP addresses to the existing VPC?

A) Add a secondary CIDR block to the VPC (e.g., 10.1.0.0/24) and create new subnets in the secondary CIDR range. AWS allows adding secondary CIDR blocks to an existing VPC.

B) Create a new larger VPC and migrate all resources using AWS Application Migration Service.

C) Enable IPv6 for the VPC, which automatically provides a /56 CIDR block with significantly more addresses. Launch new instances as dual-stack.

D) Request a VPC CIDR block expansion from AWS Support to increase the /24 to a /16 in-place.

---

### Question 34
A company is deploying a three-tier application and needs to configure security groups and NACLs. The web tier is in public subnets, the application tier in private subnets, and the database tier in isolated subnets. The security team requires that:
- Only the web tier can receive traffic from the internet
- Only the application tier can communicate with the database tier
- The database tier should have no internet access (not even outbound)
- Each tier should only accept traffic from the tier directly above it

Which combination of configurations enforces these requirements? (Choose THREE)

A) Configure the web tier security group to allow inbound HTTP/HTTPS from 0.0.0.0/0 and outbound to the application tier security group on the application port

B) Configure the application tier security group to allow inbound from the web tier security group on the application port and outbound to the database tier security group on the database port

C) Configure the database tier subnet NACL to deny all outbound traffic to 0.0.0.0/0 and only allow outbound to the application tier subnet CIDR on ephemeral ports

D) Configure the database tier security group to allow inbound from the application tier security group on the database port, with no outbound rules to the internet

E) Place a NAT Gateway in the database tier subnet to allow outbound-only internet access for patching

F) Configure the web tier NACL to allow all inbound and outbound traffic for simplicity since security groups provide sufficient protection

---

### Question 35
A company is setting up AWS Direct Connect with the following requirements: They need to access VPCs in three different AWS Regions from their on-premises data center through a single physical Direct Connect connection. They also need to access public AWS services (like S3) over the Direct Connect connection.

What is the MINIMUM number of virtual interfaces (VIFs) required?

A) Two VIFs — one transit VIF connected to a Direct Connect Gateway (associated with Transit Gateways in all three regions) and one public VIF for access to public AWS services.

B) Four VIFs — three private VIFs (one per region) and one public VIF for public services.

C) One VIF — a single transit VIF can provide access to both VPCs and public AWS services.

D) Three VIFs — one private VIF per region, using the private VIF to also access public AWS services.

---

### Question 36
A company has deployed an application across multiple AWS accounts using AWS Organizations. Each account has its own VPC. The company wants to share a common set of subnets from a central networking account with application accounts so that resources launched in application accounts use the central VPC's IP address space.

Which service enables this subnet sharing?

A) Use AWS Resource Access Manager (RAM) to share subnets from the central networking account with application accounts within the AWS Organization. Application accounts can launch resources into the shared subnets.

B) Create VPC peering connections between the central networking VPC and each application account VPC. Configure routing to allow resources to communicate.

C) Deploy a Transit Gateway and attach VPCs from all accounts. Use the Transit Gateway to share network address space.

D) Use AWS CloudFormation StackSets to deploy identical VPC configurations across all accounts for consistent networking.

---

### Question 37
A company needs to connect their on-premises network to AWS with the following requirements:
- Minimum 500 Mbps bandwidth
- Connection must be established within 48 hours
- Encrypted traffic
- The connection will be used for 2 months during a data migration project

Which connection type is MOST appropriate?

A) AWS Site-to-Site VPN over the internet. VPN connections can be established in minutes, provide IPsec encryption, and can deliver adequate throughput for the 2-month project without long-term commitments.

B) AWS Direct Connect with a 1 Gbps dedicated connection. Direct Connect provides reliable bandwidth and can be provisioned within 48 hours.

C) AWS Direct Connect with a hosted connection through a Direct Connect Partner. Partners can provision connections faster than dedicated connections.

D) AWS Site-to-Site VPN with accelerated VPN option using AWS Global Accelerator for improved performance over the internet.

---

### Question 38
A company wants to route traffic differently based on client geographic location using Route 53. European users should be routed to eu-west-1, Asian users to ap-southeast-1, and all other users to us-east-1. If the closest region becomes unhealthy, traffic should fail over to us-east-1.

Which Route 53 configuration achieves this? (Choose TWO)

A) Create geolocation routing records: Europe → eu-west-1 ALB, Asia → ap-southeast-1 ALB, and Default → us-east-1 ALB

B) Create health checks for the ALBs in eu-west-1 and ap-southeast-1. Associate the health checks with the geolocation routing records. Traffic will fail over to the default record (us-east-1) when health checks fail.

C) Create latency-based routing records for all three regions with health checks to automatically route to the lowest-latency healthy region.

D) Create geoproximity routing records with bias values to shift traffic boundaries between regions.

E) Create a failover routing policy with primary records for each geographic region and secondary records pointing to us-east-1.

---

### Question 39
A company needs to design a VPC that supports IPv6 for a new IoT application. Millions of IoT devices will connect to the application, and each device needs a unique IP address. The application servers run in private subnets and must initiate outbound connections to the IoT devices but should not be directly reachable from the internet.

Which configuration supports IPv6 for private subnets with outbound-only internet access?

A) Enable IPv6 on the VPC to receive a /56 CIDR block. Create subnets with /64 IPv6 CIDR blocks. Create an Egress-Only Internet Gateway and add a route for ::/0 pointing to it in the private subnet route table. The Egress-Only IGW allows outbound IPv6 traffic but blocks inbound-initiated connections.

B) Enable IPv6 on the VPC and assign IPv6 addresses to instances in private subnets. Create a NAT Gateway that supports IPv6 and route ::/0 through it.

C) Enable IPv6 on the VPC and create public subnets with IPv6. Use security groups to block inbound IPv6 traffic from the internet while allowing outbound.

D) Deploy a dual-stack ALB in public subnets to handle IPv6 traffic and translate it to IPv4 for backend instances in private subnets.

---

### Question 40
A company has migrated to AWS and uses a Transit Gateway to connect 10 VPCs. They notice that DNS resolution is not working correctly between VPCs — instances in one VPC cannot resolve private hosted zone records associated with other VPCs. Each VPC has its own Route 53 private hosted zone.

Which solution enables cross-VPC DNS resolution? (Choose TWO)

A) Associate each Route 53 private hosted zone with all VPCs that need to resolve its records, even VPCs in different accounts (using cross-account authorization).

B) Enable DNS support on the Transit Gateway by setting the "DNS support" attribute to "enable" on each VPC attachment.

C) Create Route 53 Resolver rules to forward DNS queries for each private domain to the Route 53 Resolver inbound endpoint in the VPC that owns the hosted zone.

D) Deploy a centralized DNS server on EC2 and configure all VPCs to use it via DHCP option sets.

E) Enable "enableDnsHostnames" and "enableDnsSupport" on each VPC to allow DNS resolution across peered networks.

---

### Question 41
A company operates a microservices architecture with 50 services running on Amazon EKS across three AZs. The services communicate with each other extensively. The company notices high inter-AZ data transfer costs on their AWS bill. A significant portion of traffic is between services that could be co-located in the same AZ.

Which strategy MOST effectively reduces inter-AZ data transfer costs while maintaining availability?

A) Implement topology-aware routing in Kubernetes (topology awareness hints) to prefer same-AZ endpoints when available, while still allowing cross-AZ communication when needed for availability.

B) Deploy all services in a single AZ to eliminate inter-AZ data transfer costs and rely on EKS pod-level health checks for availability.

C) Enable VPC endpoints for all inter-service communication to keep traffic within the AWS network and eliminate data transfer charges.

D) Migrate from EKS to AWS App Mesh with Envoy proxies that compress traffic between AZs to reduce data transfer costs.

---

### Question 42
A company has a VPC with a NAT Gateway in a single AZ. When that AZ experienced an outage, instances in private subnets across all AZs lost internet connectivity. The company needs to redesign for high availability while being cost-conscious.

Which architecture improves NAT Gateway availability?

A) Deploy a NAT Gateway in each AZ that has private subnets. Configure each AZ's private subnet route table to point to the NAT Gateway in the same AZ. This ensures that an AZ failure only impacts instances in that AZ.

B) Deploy two NAT Gateways in different AZs and configure health checks with Route 53 to failover between them.

C) Replace the NAT Gateway with a NAT instance in an Auto Scaling group that spans multiple AZs. The ASG will automatically replace a failed NAT instance.

D) Deploy a single NAT Gateway and configure a CloudWatch alarm that triggers a Lambda function to create a new NAT Gateway in a different AZ if the primary fails.

---

### Question 43
A company is implementing a Gateway Load Balancer (GWLB) architecture for network traffic inspection. The company wants to inspect all traffic entering the VPC from the internet and also traffic between application tiers. Third-party firewall appliances run as EC2 instances in a separate security VPC.

Which statements about Gateway Load Balancer are correct? (Choose TWO)

A) GWLB operates at Layer 3 (Network Layer) and uses the GENEVE protocol to encapsulate traffic, preserving the original source and destination IP addresses for inspection by the firewall appliances.

B) GWLB endpoints (GWLBe) are deployed in the application VPC and act as route targets. Traffic is routed to GWLBe in the route table, which sends it to the GWLB in the security VPC for inspection.

C) GWLB operates at Layer 7 (Application Layer) and can inspect HTTP headers and payloads before forwarding to the firewall appliances.

D) GWLB replaces the need for Network ACLs and security groups since all traffic is inspected by the firewall appliances.

E) GWLB can only inspect ingress traffic from the internet and cannot be used for east-west (inter-tier) traffic inspection.

---

### Question 44
A company is planning their IP addressing for a new AWS environment. They need to support:
- 8 VPCs in us-east-1
- 4 VPCs in eu-west-1
- Each VPC needs at least 4,000 usable IP addresses
- VPCs must not have overlapping CIDR ranges
- The address space must be contiguous per region for route summarization

Which CIDR allocation plan meets these requirements?

A) Allocate 10.0.0.0/17 for us-east-1 (subdivided into eight /20 blocks) and 10.0.128.0/18 for eu-west-1 (subdivided into four /20 blocks). Each /20 provides 4,091 usable addresses.

B) Allocate 10.0.0.0/16 for us-east-1 (subdivided into eight /19 blocks) and 10.1.0.0/16 for eu-west-1 (subdivided into four /18 blocks). Each block provides over 4,000 addresses.

C) Allocate 10.0.0.0/21 for all VPCs and use secondary CIDR blocks if more addresses are needed.

D) Allocate 10.0.0.0/8 for the entire environment and create /16 VPCs for maximum flexibility.

---

### Question 45
A company's security team requires that all API calls to AWS services from EC2 instances in private subnets go through VPC endpoints and NEVER traverse the public internet, even if a NAT Gateway is available. The team needs to enforce this policy across all accounts in the AWS Organization.

Which approach enforces this requirement?

A) Create a Service Control Policy (SCP) that denies API calls to AWS services unless the request comes through a VPC endpoint by using the aws:sourceVpce or aws:sourceVpc condition key in the SCP. Attach the SCP to the Organization root.

B) Remove NAT Gateways from all VPCs to prevent any internet-bound traffic, forcing all traffic through VPC endpoints.

C) Configure VPC endpoint policies on each endpoint to allow traffic only from specific VPCs and deny all other access paths to the AWS services.

D) Use AWS Config rules to detect any EC2 instances making API calls not through VPC endpoints and automatically terminate those instances.

---

### Question 46
A company runs a real-time bidding platform that receives 1 million requests per second at peak. The platform needs to serve responses within 5 milliseconds. The application runs on EC2 instances behind a Network Load Balancer. The company wants to optimize network performance between the NLB and the target instances.

Which NLB configurations optimize performance for this use case? (Choose TWO)

A) Disable cross-zone load balancing to reduce latency by keeping traffic within the same AZ as the NLB node that received the request

B) Enable the NLB with UDP protocol support for faster processing since UDP has lower overhead than TCP

C) Use IP-based targets instead of instance-based targets to reduce the additional network hop and enable direct communication

D) Enable proxy protocol v2 on the NLB to preserve client source IP information while maintaining low latency

E) Enable connection idle timeout to the minimum value to rapidly recycle connections and improve throughput

---

### Question 47
A company has an application that needs to access Amazon S3 from instances in a private subnet. The company currently uses a NAT Gateway for this purpose. The S3 requests are generating significant data transfer costs because large datasets (10 TB daily) are being downloaded from S3.

Which change reduces data transfer costs for S3 access?

A) Replace the NAT Gateway with an S3 Gateway VPC endpoint. Gateway endpoints are free, and traffic to S3 through the endpoint does not incur NAT Gateway data processing charges.

B) Move the EC2 instances to a public subnet with public IPs to access S3 directly, avoiding NAT Gateway charges.

C) Create an S3 interface endpoint (PrivateLink) to replace the NAT Gateway, which eliminates all data transfer costs.

D) Enable S3 Transfer Acceleration to reduce the amount of data transferred by compressing it automatically.

---

### Question 48
A company operates a global application with users in North America, Europe, and Asia. They use Amazon CloudFront for content delivery. The security team requires that users in certain countries (Country X, Country Y, Country Z) are completely blocked from accessing the application. Additionally, users from Country A should only be able to access specific URL paths (/public/*).

Which combination of features implements these restrictions? (Choose TWO)

A) Enable CloudFront geo-restriction to block access from Country X, Country Y, and Country Z

B) Create a CloudFront function or Lambda@Edge function that inspects the CloudFront-Viewer-Country header and returns a 403 for Country A on non-/public/* paths

C) Configure Route 53 geolocation routing to return NXDOMAIN for blocked countries

D) Use AWS WAF geo-match conditions on the CloudFront distribution to block all three countries and create a separate rule for Country A with a URL path condition

E) Configure the origin server to check the X-Forwarded-For header and block requests from the blocked countries' IP ranges

---

### Question 49
A company is evaluating whether to use AWS Global Accelerator or Amazon CloudFront for their application. The application is a TCP-based financial trading platform that requires persistent connections, ultra-low latency, and does not benefit from caching.

Which service should the company choose and why?

A) AWS Global Accelerator — it provides static anycast IP addresses, supports TCP/UDP protocols, maintains persistent connections, routes traffic over the AWS global network to the optimal endpoint, and does not cache content. It is designed for non-HTTP use cases requiring low-latency.

B) Amazon CloudFront — configure it with no caching behavior for dynamic content. CloudFront's edge locations are closer to users and provide lower latency than Global Accelerator.

C) Use both services together — CloudFront for content that can be cached and Global Accelerator for the TCP trading connections, to optimize both latency and cost.

D) Neither — deploy the application across multiple regions and use Route 53 latency-based routing for direct connections to regional endpoints.

---

### Question 50
A company has a hybrid network with Direct Connect. They need to ensure that if the Direct Connect connection fails, traffic automatically fails over to a Site-to-Site VPN backup connection. The failover should happen without manual intervention.

Which configuration ensures automatic failover from Direct Connect to VPN?

A) Advertise the same prefixes over both Direct Connect (via BGP on the private VIF) and the Site-to-Site VPN (via BGP). AWS will prefer the Direct Connect path due to its shorter AS path. If Direct Connect fails, BGP will automatically converge and route traffic over the VPN.

B) Configure Route 53 health checks on the Direct Connect connection and create a failover routing policy that switches to the VPN connection when Direct Connect is unhealthy.

C) Use a Transit Gateway with two attachments — one for Direct Connect and one for VPN. Configure static routes with the Direct Connect route having a higher priority (lower metric). Manually update routes if Direct Connect fails.

D) Configure two Direct Connect connections in active/passive mode as the primary failover, with VPN as a third-level backup triggered by CloudWatch alarms.

---

### Question 51
A company has deployed an application in a VPC with instances spread across subnets in three AZs. The instances need to communicate with Amazon DynamoDB and Amazon S3 frequently. The company wants to ensure the MOST cost-effective connectivity to these services without internet exposure.

Which VPC endpoint configuration is correct for both services?

A) Create a Gateway VPC endpoint for both S3 and DynamoDB. Update the route tables for the subnets to include routes to the endpoints. Gateway endpoints are free to use and appear as route table entries.

B) Create Interface VPC endpoints for both S3 and DynamoDB. Interface endpoints create ENIs in the subnets and provide private DNS resolution.

C) Create a Gateway endpoint for S3 and an Interface endpoint for DynamoDB. DynamoDB requires an Interface endpoint for private connectivity.

D) Create a single Gateway endpoint that serves both S3 and DynamoDB by specifying both service names in the endpoint configuration.

---

### Question 52
A company is designing a network architecture where traffic between two VPCs (VPC-A: 10.1.0.0/16 and VPC-B: 10.2.0.0/16) must be inspected by a centralized firewall. The firewall appliances run in a Security VPC (10.3.0.0/16). All three VPCs are connected via a Transit Gateway.

Which Transit Gateway route table configuration ensures ALL traffic between VPC-A and VPC-B passes through the Security VPC?

A) Create two route tables: (1) Spoke route table — associated with VPC-A and VPC-B attachments, with a default route (0.0.0.0/0) pointing to the Security VPC attachment. (2) Security route table — associated with the Security VPC attachment, with specific routes to 10.1.0.0/16 (VPC-A attachment) and 10.2.0.0/16 (VPC-B attachment). Remove direct routes between VPC-A and VPC-B from the spoke route table.

B) Create a single route table with routes to all three VPCs. Configure the firewall appliances to advertise more specific routes via BGP to attract traffic from VPC-A and VPC-B.

C) Create three route tables (one per VPC) and add static routes in VPC-A's table pointing to VPC-B through the Security VPC, and vice versa. The Security VPC table routes to both VPCs directly.

D) Use blackhole routes in the Transit Gateway to block direct communication between VPC-A and VPC-B, forcing traffic to be manually routed through a VPN to the Security VPC.

---

### Question 53
A company wants to migrate from their on-premises load balancer to AWS. The on-premises load balancer currently handles:
- TCP connections on port 3306 (MySQL) with hundreds of thousands of connections per second
- Must preserve the client's source IP address as seen by the backend servers
- Must support static IP addresses for DNS-independent access
- Must distribute traffic across two AZs

Which AWS load balancer type and configuration meets ALL requirements?

A) Network Load Balancer with instance-based targets. NLB natively preserves the client source IP address when using instance-based targets, supports static IPs via Elastic IPs, handles TCP at Layer 4 with high connection throughput, and distributes across multiple AZs.

B) Application Load Balancer configured with a TCP listener on port 3306. Enable the X-Forwarded-For header to preserve the client source IP.

C) Network Load Balancer with IP-based targets and proxy protocol v2 enabled. This preserves the client source IP in the proxy protocol header.

D) Classic Load Balancer in TCP mode with proxy protocol enabled for source IP preservation.

---

### Question 44 (renumbered: 54)
A company has a VPC in us-east-1 that needs to access S3 buckets in both us-east-1 and eu-west-1. The company uses an S3 Gateway VPC endpoint for accessing S3.

Which statement about cross-region S3 access through the Gateway endpoint is correct?

A) The S3 Gateway VPC endpoint only provides access to S3 buckets in the same region as the VPC. For cross-region S3 access, traffic will route through the NAT Gateway or Internet Gateway as S3 Gateway endpoints are regional.

B) The S3 Gateway VPC endpoint provides access to S3 buckets in all AWS regions automatically through the AWS global network.

C) Cross-region S3 access is not possible; the company must replicate the S3 buckets to us-east-1 using S3 Cross-Region Replication.

D) The company can create S3 Gateway endpoints in multiple regions within the same VPC for cross-region access.

---

### Question 55
A company is implementing a zero-trust network architecture on AWS. They need to ensure that every network connection between services is authenticated and encrypted, regardless of whether the services are in the same VPC or different VPCs. The solution must work with both containerized workloads on ECS and EC2-based services.

Which approach BEST implements zero-trust networking? (Choose TWO)

A) Deploy Amazon VPC Lattice to manage service-to-service connectivity. VPC Lattice provides built-in authentication using IAM auth policies and automatic mTLS encryption for cross-VPC communication.

B) Configure security groups to reference other security groups for authorized communication, ensuring only known services can communicate. Security group references provide zero-trust authentication.

C) Implement AWS App Mesh with Envoy proxy sidecars for mutual TLS (mTLS) between all services. Configure App Mesh to require mTLS for all virtual services.

D) Deploy AWS Network Firewall in every VPC with rules that only allow traffic from known service IP addresses.

E) Use VPC peering with encrypted peering option to ensure all inter-VPC traffic is encrypted and authenticated.

---

### Question 56
A company operates an application behind a CloudFront distribution. They want to ensure that users always access the application through CloudFront and cannot bypass it to access the Application Load Balancer origin directly. The ALB is in a public subnet.

Which combination of measures prevents direct access to the ALB? (Choose TWO)

A) Configure the ALB security group to only allow inbound traffic from the CloudFront managed prefix list (com.amazonaws.global.cloudfront.origin-facing)

B) Add a custom HTTP header (e.g., X-Custom-Header with a secret value) in the CloudFront origin configuration. Configure the ALB to only forward requests that contain this header with the correct value using ALB listener rules.

C) Make the ALB internal (private) so it has no public IP address. CloudFront cannot connect to internal ALBs.

D) Use Origin Access Identity (OAI) to restrict ALB access to CloudFront only.

E) Configure CloudFront with a VPN connection to the ALB to ensure encrypted private access.

---

### Question 57
A company has multiple AWS accounts and wants to allow DNS resolution of Route 53 private hosted zones across accounts. Account A hosts a private hosted zone for internal.example.com. Account B, C, and D need to resolve records in this hosted zone. All accounts have VPCs in the same region.

What is the CORRECT approach to enable cross-account private hosted zone resolution?

A) In Account A, create an authorization for each VPC in Accounts B, C, and D to be associated with the private hosted zone (using CreateVPCAssociationAuthorization). In each target account, associate their VPC with the private hosted zone in Account A (using AssociateVPCWithHostedZone).

B) Create VPC peering connections between Account A's VPC and the VPCs in Accounts B, C, and D. Private hosted zone records automatically resolve across peered VPCs.

C) Export the private hosted zone records from Account A and import them into private hosted zones in each target account. Keep them synchronized with Lambda functions.

D) Share the private hosted zone using AWS Resource Access Manager (RAM) with the other accounts in the Organization.

---

### Question 58
A company needs to design a multi-VPC architecture where a central inspection VPC examines all traffic between spoke VPCs and the internet. The architecture must support:
- North-south traffic inspection (to/from internet)
- East-west traffic inspection (between spoke VPCs)
- Centralized logging of all inspected traffic
- Auto-scaling of inspection capacity

Which architecture BEST meets these requirements?

A) Deploy AWS Network Firewall in the inspection VPC with firewall endpoints in each AZ. Connect all spoke VPCs and the inspection VPC via Transit Gateway. Configure TGW route tables to route all spoke-to-spoke and spoke-to-internet traffic through the inspection VPC. Enable Network Firewall logging to S3 and CloudWatch. Network Firewall automatically scales with traffic.

B) Deploy third-party firewall appliances in an Auto Scaling group in the inspection VPC behind a Gateway Load Balancer. Route all traffic through the GWLB via Transit Gateway. Configure the firewalls to log to a centralized SIEM.

C) Deploy AWS Network Firewall directly in each spoke VPC for east-west inspection and in the inspection VPC for north-south inspection. This requires multiple Network Firewall deployments.

D) Use Transit Gateway with security group references to control traffic between spoke VPCs. Deploy a NAT Gateway in the inspection VPC for north-south traffic with VPC Flow Logs for logging.

---

### Question 59
A company is troubleshooting connectivity issues between an EC2 instance in a private subnet and an on-premises server connected via VPN through a Transit Gateway. Packets are leaving the EC2 instance but not arriving at the on-premises server.

Which combination of tools helps diagnose the issue? (Choose THREE)

A) VPC Reachability Analyzer — to analyze the path between the EC2 instance and the Transit Gateway attachment and identify configuration issues like missing routes or restrictive NACLs

B) Transit Gateway Network Manager Route Analyzer — to verify that the Transit Gateway route tables have correct routes for the on-premises CIDR

C) VPC Flow Logs — to confirm that packets are leaving the EC2 instance's ENI and identify if they are being rejected at any point in the VPC

D) AWS X-Ray — to trace the network packets as they traverse the Transit Gateway and VPN tunnel

E) CloudWatch Internet Monitor — to monitor internet connectivity between AWS and the on-premises data center

F) Amazon Detective — to investigate the security implications of the connectivity failure

---

### Question 60
A company wants to use Amazon Route 53 to distribute traffic to application endpoints in multiple regions. They need a routing policy that considers both the user's geographic location and the health of the endpoints, with the ability to shift traffic by adjusting a bias value.

Which Route 53 routing policy provides this capability?

A) Geoproximity routing with Route 53 Traffic Flow. Geoproximity routing lets you route based on the geographic location of users and resources, and you can shift traffic by increasing or decreasing the bias. Combined with health checks, unhealthy endpoints are automatically excluded.

B) Geolocation routing with health checks. Geolocation routing routes based on the user's location, and health checks ensure only healthy endpoints receive traffic.

C) Latency-based routing with health checks. Latency routing automatically selects the lowest-latency endpoint, and bias can be adjusted by modifying the region's published latency.

D) Multivalue answer routing with health checks. Multivalue returns multiple healthy endpoints and lets the client choose, effectively providing bias through the number of records returned per region.

---

### Question 61
A company has a complex application with microservices deployed across three VPCs. They are using VPC peering between all three VPCs (full mesh). Each VPC has grown to need connections to two more VPCs for new services, bringing the total to five VPCs. The company is concerned about the complexity of managing VPC peering connections as they scale.

At what point should the company consider migrating to Transit Gateway, and what is the key limitation of VPC peering that Transit Gateway addresses?

A) The company should consider Transit Gateway now. VPC peering does not support transitive routing — traffic from VPC-A cannot reach VPC-C through VPC-B even if both peering connections exist. With five VPCs, full mesh peering requires 10 connections. Transit Gateway centralizes routing and supports transitive connectivity through a hub-and-spoke model.

B) VPC peering supports up to 125 peering connections per VPC, so the company should continue with peering until they approach this limit. Migrate to Transit Gateway only when the number of connections exceeds the limit.

C) The company should continue using VPC peering because Transit Gateway adds latency compared to VPC peering. Migrate only when they exceed 25 VPCs.

D) Transit Gateway is only beneficial when connecting VPCs across different AWS Regions. For same-region VPCs, VPC peering remains the better option regardless of the number of VPCs.

---

### Question 62
A company needs to set up DNS failover for a critical application. The application has a primary endpoint in us-east-1 and a secondary endpoint in us-west-2. The health check for the primary endpoint should verify:
1. The ALB is responding on HTTPS
2. The response body contains the string "SERVICE_OK"
3. The backend database is accessible (verified by an API endpoint /db-health)

Which Route 53 health check configuration monitors all three conditions?

A) Create a calculated health check that combines three child health checks: (1) HTTPS health check on the ALB with string matching for "SERVICE_OK", (2) HTTPS health check on the /db-health endpoint. Configure the calculated health check with a threshold of 2 (both checks must pass). Use this calculated health check with the failover routing policy.

B) Create a single HTTPS health check that points to a custom /health endpoint that internally checks all three conditions and returns "SERVICE_OK" in the response body. Use string matching to verify the response.

C) Create three separate health checks and attach all three to the primary failover record. Route 53 will automatically require all three to pass before considering the record healthy.

D) Create a CloudWatch alarm that monitors all three conditions and create a Route 53 health check based on the CloudWatch alarm state.

---

### Question 63
A company runs a content delivery network using CloudFront and needs to implement the following security controls:
- Block requests from specific IP ranges known for abuse
- Rate limit requests to prevent abuse (max 2000 requests per 5 minutes per IP)
- Require all requests to include a valid API key in the header
- Block SQL injection attempts in query strings

Which service and configuration implements ALL of these controls?

A) AWS WAF associated with the CloudFront distribution with the following rules: (1) IP set rule to block abusive IP ranges, (2) Rate-based rule with a threshold of 2000 per 5 minutes, (3) Custom rule to check for the presence and validity of the API key header, (4) AWS Managed Rules for SQL injection detection (SQLi rule group).

B) CloudFront Functions that inspect each request for all four conditions — IP validation, rate limiting, API key verification, and SQL injection detection.

C) AWS Shield Advanced with custom mitigations for IP blocking and rate limiting, combined with CloudFront field-level encryption for API key validation.

D) An origin-level Lambda function that processes all incoming requests, checks each condition, and returns 403 for violations.

---

### Question 64
A company is deploying a hybrid DNS architecture. Their on-premises DNS servers forward specific queries to AWS, and Route 53 Resolver forwards other queries to on-premises. The company notices that DNS queries from on-premises to AWS are failing intermittently. The Route 53 Resolver inbound endpoints are deployed in a single AZ.

What changes improve the reliability of the DNS resolution? (Choose TWO)

A) Deploy Route 53 Resolver inbound endpoints in at least two Availability Zones for high availability

B) Configure the on-premises DNS servers to send queries to the IP addresses of inbound endpoints in both AZs, using the secondary endpoint as a fallback

C) Increase the size of the Route 53 Resolver inbound endpoint instances for better throughput

D) Deploy a caching DNS server on EC2 in front of the Route 53 Resolver inbound endpoints

E) Enable DNS over HTTPS (DoH) on the Route 53 Resolver inbound endpoints for more reliable transport

---

### Question 65
A company is architect a global serverless application using API Gateway, Lambda, and DynamoDB Global Tables. Users access the API from all continents. The company needs the LOWEST possible latency for API responses worldwide.

Which architecture provides the lowest global latency?

A) Deploy API Gateway regional endpoints in multiple regions, each backed by Lambda functions that read/write to the local DynamoDB Global Tables replica. Use Route 53 latency-based routing to direct users to the nearest regional API Gateway endpoint. CloudFront is not needed since API Gateway has its own edge-optimized option, but regional endpoints with Route 53 latency routing give more control.

B) Deploy a single edge-optimized API Gateway endpoint in us-east-1 with Lambda and DynamoDB. The edge-optimized endpoint uses CloudFront to cache responses at edge locations globally.

C) Deploy API Gateway in a single region with CloudFront in front of it, configured to cache all responses for 60 seconds. Use DynamoDB Global Tables but only read from the local replica.

D) Deploy the application in every AWS Region using CloudFormation StackSets. Use Route 53 geolocation routing to send users to the closest region.

---

## Answer Key

### Answer 1
**Correct Answer: A**

AWS Network Firewall in a dedicated firewall subnet is the correct approach. Network Firewall is a managed service that scales automatically and supports stateful inspection rules. By placing it between private subnets and NAT Gateways, all outbound traffic is inspected before leaving the VPC. This provides the least operational overhead compared to managing third-party firewall EC2 instances (B), NAT instances with iptables (C — NAT instances are deprecated and not recommended), or relying solely on security groups and Flow Logs (D — security groups cannot inspect traffic content and don't provide deep packet inspection).

**Why other options are wrong:**
- **B:** Gateway Load Balancer with third-party firewalls requires managing EC2 instances, patching, scaling — much more operational overhead.
- **C:** NAT instances with iptables require managing instances, they're single points of failure, and iptables provides limited inspection compared to Network Firewall.
- **D:** Security groups are stateful firewalls but cannot deny specific traffic patterns (only allow rules), cannot inspect payload content, and cannot detect data exfiltration.

---

### Answer 2
**Correct Answer: A**

Transit Gateway is the correct solution for connecting multiple VPCs at scale. Creating a TGW in each region and using TGW peering for cross-region connectivity provides centralized route management. TGW route tables enable network segmentation between production and development traffic by associating VPC attachments with specific route tables.

**Why other options are wrong:**
- **B:** Full mesh VPC peering among 15 VPCs would require (15×14)/2 = 105 peering connections. Peering doesn't support transitive routing and becomes unmanageable at scale.
- **C:** Hub-and-spoke VPN on custom servers is complex to manage and scale, requires managing VPN server instances.
- **D:** Transit Gateway is regional; you cannot attach VPCs from other regions directly to a single TGW.

---

### Answer 3
**Correct Answer: B**

The requirement is 4 subnets × 3 AZs = 12 subnets minimum per VPC, each with at least 250 usable IPs. A /24 subnet provides 251 usable addresses (256 - 5 AWS reserved). A /20 VPC (4,096 addresses) can accommodate 12 /24 subnets (12 × 256 = 3,072 addresses), fitting within the /20. A /22 VPC with /26 subnets (A) only gives 59 usable addresses per subnet — insufficient. A /21 with /25 subnets (C) provides 123 usable addresses per subnet — insufficient.

**Why other options are wrong:**
- **A:** /26 subnets provide only 59 usable IPs (64 - 5), far fewer than the required 250.
- **C:** /25 subnets provide only 123 usable IPs (128 - 5), still below the 250 requirement.
- **D:** /16 per VPC is wasteful; with 50 VPCs, you'd need 50 /16 blocks, exhausting the 10.0.0.0/8 space.

---

### Answer 4
**Correct Answer: A**

A single private VIF connected to a Direct Connect Gateway, which is then associated with Transit Gateways in each region, is the most efficient solution. The Direct Connect Gateway enables connectivity to multiple regions through a single VIF. Transit Gateways in each region provide the attachment point for VPCs and enable environment isolation through TGW route tables.

**Why other options are wrong:**
- **B:** Three private VIFs are unnecessary and consume VIF capacity. Also, private VIFs to VGWs are limited to a single region per VIF.
- **C:** A public VIF provides access to public AWS endpoints only, not private VPC resources. VPN over public VIF adds unnecessary complexity.
- **D:** Two private VIFs could work but don't provide environment isolation as effectively as TGW route tables.

---

### Answer 5
**Correct Answer: A, B, D**

Gateway endpoints for S3 and DynamoDB (A) are free and keep traffic within the AWS network. Interface endpoints for ECR services (B) are necessary for Fargate tasks to pull container images from ECR without internet access. A NAT Gateway (D) is needed for the third-party API access over HTTPS, as VPC endpoints only work with AWS services.

**Why other options are wrong:**
- **C:** Public subnets with public IPs violate the requirement to keep traffic off the public internet.
- **E:** PrivateLink with NLBs for all 12 microservices is unnecessary since they're in the same VPC and can communicate using private IPs and security groups.
- **F:** Interface endpoints for S3 and DynamoDB cost more than gateway endpoints with no additional security benefit for this use case.

---

### Answer 6
**Correct Answer: A**

Using Direct Connect with a transit VIF to a Direct Connect Gateway, then peering Transit Gateways across regions, routes traffic over the AWS backbone network. This provides the most consistent latency since it uses dedicated infrastructure and the AWS private backbone, avoiding internet variability.

**Why other options are wrong:**
- **B:** VPC peering also uses the AWS backbone and provides good latency, but Direct Connect provides more consistent performance for traffic originating from on-premises or the existing DC connection context. However, for purely AWS-to-AWS cross-region traffic, VPC peering is comparable. The key is the existing Direct Connect provides a more controlled path.
- **C:** VPN over the public internet has variable latency and is not suitable for ultra-low-latency requirements.
- **D:** A second Direct Connect connection is expensive and takes weeks to provision, which is unnecessary when TGW peering can route cross-region traffic over the AWS backbone.

---

### Answer 7
**Correct Answer: B**

With 6 subnets × 3 AZs = 18 subnets needed, each requiring 500+ usable IPs. A /23 subnet provides 507 usable IPs (512 - 5). 18 × /23 = 18 × 512 = 9,216 IPs needed. A /18 VPC provides 16,384 addresses, which accommodates 18 /23 subnets with room to spare, making it the most efficient primary CIDR.

**Why other options are wrong:**
- **A:** /16 is much larger than needed (65,536 IPs) and leaves less room for secondary CIDR blocks in the same address space.
- **C:** /24 provides only 251 usable IPs per subnet, below the 500 requirement.
- **D:** /19 provides 8,192 IPs, and 18 × 512 = 9,216 IPs needed for 18 /23 subnets, which doesn't fit in a /19.

---

### Answer 8
**Correct Answer: A**

Route 53 Resolver endpoints are the managed solution for hybrid DNS. Inbound endpoints allow on-premises DNS to forward queries to Route 53, while outbound endpoints with forwarding rules allow Route 53 to forward queries to on-premises DNS. This provides bidirectional resolution with minimal operational overhead.

**Why other options are wrong:**
- **B:** EC2-based DNS servers require managing instances, patching, scaling, and monitoring — higher operational overhead.
- **C:** Public hosted zones would expose internal DNS records to the internet and don't resolve to private IPs for internal resources.
- **D:** Private hosted zones alone don't enable on-premises resolution of AWS names, and pointing DHCP to on-premises DNS means AWS resources can only resolve on-premises names, not AWS private DNS names.

---

### Answer 9
**Correct Answer: A**

CloudFront supports multiple origins in a single distribution with path-based cache behaviors. Each behavior can point to a different origin and have its own caching configuration (TTL). The /static/* behavior with 30-day TTL routes to S3, /api/* with 60-second TTL to ALB, and /live/* with TTL 0 (forwarding all headers disables caching) to MediaPackage.

**Why other options are wrong:**
- **B:** Three distributions cannot share a single domain name, and Route 53 cannot route based on URL path — it routes based on DNS name.
- **C:** Lambda@Edge can redirect/rewrite requests but using cache behaviors is the native, simpler approach for path-based routing.
- **D:** ALB cannot proxy requests to S3 or MediaPackage natively.

---

### Answer 10
**Correct Answer: A**

S3 and DynamoDB both support Gateway VPC endpoints, which are free (no hourly or data processing charges). SQS, SNS, and Kinesis require Interface endpoints (which have hourly and data processing charges). This mixed approach minimizes cost by using free gateway endpoints where available.

**Why other options are wrong:**
- **B:** Interface endpoints for S3 and DynamoDB incur unnecessary costs when free gateway endpoints are available.
- **C:** NAT Gateway charges $0.045/GB for data processing, and security groups cannot restrict to specific AWS service endpoints (which use public IP ranges). Also, NAT Gateway traffic goes over the internet.
- **D:** There's no single unified PrivateLink endpoint for multiple AWS services; each service requires its own endpoint.

---

### Answer 11
**Correct Answer: A, D**

AWS PrivateLink (A) allows the provider to create a VPC endpoint service backed by the NLB. The provider controls which accounts can connect by allowing specific AWS account IDs. Customers create interface VPC endpoints (D) in their VPCs, which creates ENIs in their chosen subnets with private IP addresses and optional private DNS names, enabling subnet-level access control.

**Why other options are wrong:**
- **B:** VPC peering exposes the entire VPC to each other, not just the specific service. It doesn't scale well for many customers.
- **C:** Public-facing NLB with IP-based ACLs exposes the service to the internet and doesn't provide the same level of security.
- **E:** RAM shares resources within an organization; it doesn't provide the same security isolation as PrivateLink for external customers.

---

### Answer 12
**Correct Answer: A**

Failover routing with health checks is the native Route 53 mechanism for DR failover. A 10-second health check interval with a 3-failure threshold means failover triggers in approximately 30 seconds (3 × 10s). With fast health check enabled, DNS TTL of 60 seconds is the maximum delay, but since failover is detected within 30 seconds, the total failover time can be within the 60-second requirement.

**Why other options are wrong:**
- **B:** Weighted routing with Lambda to update weights introduces delay (Lambda trigger, API call to Route 53, DNS propagation) and doesn't meet the 60-second requirement reliably.
- **C:** Latency-based routing sends traffic to the lowest-latency region, not the primary. A 300-second TTL would cause up to 5 minutes of cached DNS pointing to the failed region.
- **D:** Simple routing with multiple values doesn't support designating a primary and secondary endpoint.

---

### Answer 13
**Correct Answer: A**

AWS Global Accelerator provides static anycast IP addresses and routes traffic over the AWS global network to the nearest healthy endpoint. It supports UDP traffic (essential for real-time gaming) and provides automatic failover with health checks.

**Why other options are wrong:**
- **B:** CloudFront does not support UDP traffic. CloudFront is a CDN for HTTP/HTTPS content delivery.
- **C:** Route 53 latency-based routing sends traffic to the closest region but relies on DNS resolution. DNS caching and TTL delays mean failover is slower. It also doesn't provide the AWS backbone routing advantage.
- **D:** Cross-region NLB load balancing doesn't exist as a feature. NLBs are regional resources.

---

### Answer 14
**Correct Answer: A**

AWS PrivateLink (VPC endpoint services) solves the overlapping CIDR problem because the interface VPC endpoint creates ENIs with IP addresses from the consumer's VPC CIDR range. The consumer's application connects to the endpoint ENI's private IP, and PrivateLink handles the routing to the provider's NLB without requiring any CIDR overlap resolution.

**Why other options are wrong:**
- **B:** VPC peering cannot be created between VPCs with overlapping CIDR ranges. AWS blocks this.
- **C:** Transit Gateway does not provide NAT functionality. It cannot translate between overlapping address spaces.
- **D:** Site-to-Site VPN does not handle overlapping CIDRs. VPN routing requires non-overlapping IP ranges.

---

### Answer 15
**Correct Answer: A, C**

For ingress inspection (A), the Network Firewall endpoints must be in subnets between the IGW and the public subnets. The IGW ingress routing table routes traffic destined for the public subnet CIDR through the firewall endpoint. For egress inspection (C), private subnet route tables point 0.0.0.0/0 to the firewall endpoints, and the firewall subnet routes to the NAT Gateway.

**Why other options are wrong:**
- **B:** Placing firewall endpoints in the same subnet as the ALB doesn't allow traffic to be routed through them — you need separate subnets for proper routing.
- **D:** A separate VPC with Transit Gateway adds unnecessary complexity and latency for single-VPC deployments.
- **E:** The ALB security group approach doesn't enable traffic inspection; it just restricts sources. The firewall needs to be in the traffic path.

---

### Answer 16
**Correct Answer: A**

ALB supports multiple listener rules with conditions based on host header, path pattern, HTTP headers, HTTP methods, query strings, and source IP. Rules are evaluated in priority order. Creating five rules with the specified conditions and priorities correctly routes traffic to the appropriate target groups.

**Why other options are wrong:**
- **B:** Three ALBs is unnecessary; a single ALB handles host-based, path-based, and header-based routing natively.
- **C:** Lambda functions for routing add latency and complexity. ALB rules handle this natively.
- **D:** Different ports require client changes and don't support host/path-based routing.

---

### Answer 17
**Correct Answer: A, B, C**

EFA (A) provides OS-bypass capabilities for HPC workloads, enabling ultra-low-latency inter-node communication required for MPI. Cluster placement groups (B) place instances in the same underlying hardware for the lowest latency. Enhanced networking with ENA and jumbo frames (C) maximizes throughput by allowing 9001 MTU instead of the default 1500 MTU.

**Why other options are wrong:**
- **D:** Spreading across multiple AZs increases latency between nodes, which is opposite to the requirement.
- **E:** EBS volume types don't affect network throughput between instances.
- **F:** EBS optimization is about storage I/O, not inter-instance network throughput.

---

### Answer 18
**Correct Answer: A**

Two VPN connections from different customer gateways provide maximum redundancy. Each VPN connection has two tunnels (to different AWS endpoints), giving four tunnels total. With two customer gateway devices, you're protected against: single tunnel failure, single AWS endpoint failure, and single customer gateway failure.

**Why other options are wrong:**
- **B:** A single VPN connection with both tunnels active provides resilience against a tunnel failure but not against a customer gateway device failure.
- **C:** A single Direct Connect connection is less resilient than a dual VPN setup (single point of failure at the physical layer). Provisioning takes weeks, not solving the immediate reliability issue.
- **D:** Monitoring and restarting doesn't prevent the downtime — it only reduces the recovery time.

---

### Answer 19
**Correct Answer: A**

Transit Gateway with separate route tables provides network-level isolation. The Production route table only has routes to Shared Services (and no route to Development), and vice versa. This prevents Production and Development from communicating while both can reach Shared Services.

**Why other options are wrong:**
- **B:** VPC peering would work for connectivity, but VPC peering is non-transitive, so Production and Development can't communicate through Shared Services anyway. However, this approach becomes harder to manage at scale and doesn't provide the same flexibility as TGW route tables.
- **C:** A single route table with routes to all VPCs would allow direct communication between Production and Development. Security groups are not reliable for inter-VPC isolation at the network layer.
- **D:** PrivateLink is a service-level solution, not a network-level solution. It requires exposing each service individually and doesn't provide general network connectivity.

---

### Answer 20
**Correct Answer: A, B, C**

Shield Advanced (A) provides enhanced DDoS protection with 24/7 DDoS response team access. WAF with rate-based rules (B) limits requests per IP, mitigating HTTP flood attacks. Restricting the ALB security group to CloudFront IP ranges (C) prevents attackers from bypassing CloudFront and hitting the ALB directly.

**Why other options are wrong:**
- **D:** Managing EC2-based DDoS mitigation adds operational overhead and is less effective than AWS-native services.
- **E:** Flow Logs and alarms are monitoring tools, not protection mechanisms. They detect but don't prevent attacks.
- **F:** Making the ALB internal-only would prevent CloudFront from reaching it since CloudFront connects to origins over the public internet (unless using Origin Shield or other mechanisms, but the ALB still needs to be reachable).

---

### Answer 21
**Correct Answer: B**

MACsec provides Layer 2 encryption at line rate on the Direct Connect connection. It encrypts all traffic at the physical layer without any throughput reduction. This is the best solution when MACsec-capable hardware is available at both the customer and AWS end.

**Why other options are wrong:**
- **A:** VPN over Direct Connect public VIF provides encryption but is limited to ~1.25 Gbps per VPN tunnel due to IPsec overhead, significantly less than the 1 Gbps connection speed.
- **C:** Application-level TLS requires modifying all applications and doesn't encrypt non-application traffic (DNS, NTP, etc.).
- **D:** VPN over transit VIF has the same throughput limitation as option A.

---

### Answer 22
**Correct Answer: A**

NLB natively supports Elastic IP addresses (one per AZ), providing static IPs for firewall whitelisting. NLB operates at Layer 4 (TCP) and can handle millions of connections per second with ultra-low latency. Cross-zone load balancing distributes traffic evenly.

**Why other options are wrong:**
- **B:** Global Accelerator provides static IPs but adds unnecessary cost and complexity when static IPs on the NLB suffice. Global Accelerator is better for multi-region deployments.
- **C:** ALBs do not support Elastic IP addresses directly.
- **D:** Individual EC2 instances with Elastic IPs don't provide automatic scaling or health-check-based failover comparable to NLB.

---

### Answer 23
**Correct Answer: C**

Weighted routing allows precise traffic control. Setting weight to 0 for a region removes it from DNS responses immediately (at next DNS resolution). This is the simplest method to shift traffic during maintenance. Combined with health checks, it also handles unexpected failures.

**Why other options are wrong:**
- **A:** Inverting a health check is not the standard approach for planned maintenance. It adds confusion to health monitoring. However, it would work.
- **B:** Deleting geolocation records risks routing users to the wrong region based on geographic proximity rather than the preferred maintenance failover target.
- **D:** Disabling a latency-based record works, but the "best" answer is C because weighted routing gives more granular control (you can do gradual traffic shifting, e.g., 90/10 before full cutover).

---

### Answer 24
**Correct Answer: A**

Transit Gateway with VPN supports ECMP, which aggregates bandwidth across multiple VPN tunnels. Each VPN connection provides up to 1.25 Gbps per tunnel (two tunnels per connection), and ECMP can combine multiple connections for higher aggregate throughput. TGW provides centralized management and hub-and-spoke routing that enables branch-to-branch communication.

**Why other options are wrong:**
- **B:** Virtual Private Gateway VPN doesn't support ECMP and is limited to a single VPN's bandwidth. Managing 25 individual VPN connections without centralization is complex.
- **C:** Client VPN is designed for individual user access, not site-to-site connectivity.
- **D:** Software VPN on EC2 requires managing instances, doesn't auto-scale, and the EC2 instance becomes a single point of failure and bottleneck.

---

### Answer 25
**Correct Answer: A**

CloudFront requires valid SSL/TLS certificates on the origin for HTTPS communication. ACM public certificates installed on the ALB match the ALB's DNS name. CloudFront's origin protocol policy set to "HTTPS Only" ensures encrypted communication.

**Why other options are wrong:**
- **B:** CloudFront does not trust self-signed certificates for origin connections. The origin must present a certificate signed by a trusted certificate authority.
- **C:** Origin Access Identity (OAI) is used for S3 origins, not ALB origins.
- **D:** Traffic between CloudFront and ALB is NOT encrypted by default. You must explicitly configure HTTPS on the origin connection.

---

### Answer 26
**Correct Answer: A**

Network ACLs are evaluated at the subnet level before traffic reaches instances or security groups. They are stateless and can explicitly deny traffic. This provides the earliest VPC-level block point.

**Why other options are wrong:**
- **B:** Security groups only support allow rules; you cannot add explicit deny rules to a security group.
- **C:** AWS WAF works at Layer 7 (application layer) and requires an ALB or CloudFront. It blocks traffic later in the stack than NACLs.
- **D:** You cannot add blackhole routes for internet IP ranges in a VPC route table. Route tables route traffic destined for specific CIDRs; you can't "drop" traffic via route tables for external IPs.

---

### Answer 27
**Correct Answer: A, B, C**

NLB supports sticky sessions based on source IP affinity (A). NLB target groups support HTTP health checks (B) to verify application health, not just TCP connectivity. NLB supports TLS listeners with ACM certificates (C) for TLS termination.

**Why other options are wrong:**
- **D:** NLB does not support cookie-based stickiness. Cookie-based stickiness is an ALB feature.
- **E:** NLB supports TCP, HTTP, and HTTPS health checks, not just TCP.
- **F:** NLB natively supports TLS termination. An ALB behind NLB is unnecessary for this purpose.

---

### Answer 28
**Correct Answer: A**

A centralized Egress VPC with NAT Gateways shared across spoke VPCs via Transit Gateway is the standard centralized egress pattern. It reduces costs by consolidating NAT Gateways (instead of deploying them in each VPC) and simplifies management.

**Why other options are wrong:**
- **B:** NAT Gateways in each of 20 VPCs (at least one per AZ) is more expensive than centralized NAT Gateways in a single Egress VPC.
- **C:** NAT instances in an ASG behind GWLB add operational overhead (managing instances, patching) compared to managed NAT Gateways.
- **D:** Proxy servers require application-level configuration and don't support all types of internet traffic transparently.

---

### Answer 29
**Correct Answer: A**

Transit Gateway supports multicast as a native feature. You create a multicast domain, register sources and group members, and associate subnets. This enables standard IP multicast within and across VPCs.

**Why other options are wrong:**
- **B:** ALB doesn't support UDP or multicast traffic replication.
- **C:** SNS is a messaging service, not a network-level multicast solution. It would require significant application re-architecture.
- **D:** Standard IP multicast within a VPC is not supported. VPCs don't support multicast at the network layer — only Transit Gateway supports it.

---

### Answer 30
**Correct Answer: A**

Creating an ENI with the specific secondary private IP addresses and running a proxy (HAProxy/NLB) on an EC2 instance allows the application to continue using hardcoded IPs. The proxy forwards traffic to the RDS endpoint using DNS resolution.

**Why other options are wrong:**
- **B:** You cannot assign specific private IP addresses to RDS instances. RDS manages its own IP addressing.
- **C:** Route 53 A records map domain names to IPs, not IPs to other IPs or endpoints. The application uses IP addresses directly, not DNS names.
- **D:** Elastic IPs are public IP addresses and cannot be attached to RDS instances. Also, 10.0.1.x addresses are private, not Elastic IPs.

---

### Answer 31
**Correct Answer: C**

ALB supports weighted target group routing through forward actions in listener rules. By creating separate target groups for each AZ and assigning weights (70% to AZ-a, 30% to AZ-b), traffic is distributed according to each AZ's capacity.

**Why other options are wrong:**
- **A:** You cannot disable cross-zone load balancing for ALBs through the console in the traditional sense (it's always enabled), and "target group weights" are set through listener rules, not through the cross-zone setting.
- **B:** While replacing instances is a valid long-term solution, it doesn't address the immediate imbalance and incurs cost for replacing functional hardware.
- **D:** Connection draining (deregistration delay) is for gracefully removing targets, not for load distribution.

---

### Answer 32
**Correct Answer: A**

Split-horizon DNS in AWS is implemented using a public hosted zone for external resolution and a private hosted zone (associated with the VPC) for internal resolution. Route 53 automatically returns private hosted zone responses for queries originating from associated VPCs, while returning public hosted zone responses for external queries.

**Why other options are wrong:**
- **B:** You cannot route based on corporate IP ranges with geolocation; geolocation uses country/continent-level location, not specific IP ranges.
- **C:** DHCP option sets with custom DNS servers require managing DNS infrastructure and don't use Route 53's native split-horizon capability.
- **D:** You cannot have two public hosted zones for the same domain with different records and route between them based on source IP.

---

### Answer 33
**Correct Answer: A**

AWS allows adding secondary CIDR blocks to an existing VPC (up to 5 CIDR blocks). This immediately adds IP addresses without any service interruption or migration.

**Why other options are wrong:**
- **B:** Migrating to a new VPC is disruptive and time-consuming, not an immediate solution.
- **C:** IPv6 addresses don't help with IPv4 address exhaustion. Applications and services may not support IPv6, and IPv6 doesn't resolve the IPv4 shortage directly.
- **D:** AWS does not offer in-place CIDR expansion. The original CIDR cannot be changed.

---

### Answer 34
**Correct Answer: A, B, D**

Web tier SG (A) allows internet traffic in and limits outbound to the app tier. App tier SG (B) allows traffic from web tier only and limits outbound to database tier. Database tier SG (D) allows inbound from app tier only and has no outbound internet rules (SGs are stateful, so return traffic for allowed inbound connections is automatically permitted).

**Why other options are wrong:**
- **C:** NACL deny for all outbound would also block return traffic to the application tier (NACLs are stateless). You'd need to allow ephemeral ports to the app tier CIDR, making this partially correct but overly complex compared to SG-only approach.
- **E:** NAT Gateway in the database tier contradicts the "no internet access" requirement.
- **F:** Allowing all traffic in the web tier NACL reduces defense-in-depth. While security groups provide protection, NACLs add an important secondary layer.

---

### Answer 35
**Correct Answer: A**

A transit VIF connects to a Direct Connect Gateway, which can be associated with Transit Gateways in multiple regions (up to 3 by default). One transit VIF provides access to VPCs in all three regions. A public VIF is needed separately for accessing public AWS services (S3, DynamoDB public endpoints, etc.) over Direct Connect. Total: 2 VIFs.

**Why other options are wrong:**
- **B:** Four VIFs are more than the minimum. A single transit VIF replaces three private VIFs when using Direct Connect Gateway with Transit Gateways.
- **C:** A transit VIF alone cannot provide access to public AWS services. Public services require a public VIF.
- **D:** Private VIFs cannot access public AWS services. Each private VIF connects to a single VGW.

---

### Answer 36
**Correct Answer: A**

AWS Resource Access Manager (RAM) enables sharing subnets across accounts within an AWS Organization. Application accounts can launch resources (EC2, RDS, Lambda in VPC, etc.) into shared subnets, using the central VPC's IP address space.

**Why other options are wrong:**
- **B:** VPC peering provides network connectivity but each account still has its own VPC with its own CIDR. It doesn't share the central VPC's address space.
- **C:** Transit Gateway provides routing between VPCs but doesn't share subnets or address space.
- **D:** StackSets deploy identical configurations but create separate VPCs in each account, not shared networking.

---

### Answer 37
**Correct Answer: A**

Site-to-Site VPN can be established in minutes over the existing internet connection. It provides IPsec encryption (meeting the encryption requirement), can handle 500 Mbps (each VPN tunnel supports up to 1.25 Gbps), and has no long-term commitment — ideal for a 2-month project.

**Why other options are wrong:**
- **B:** Dedicated Direct Connect connections typically take 2-4 weeks to provision, not within 48 hours.
- **C:** Hosted connections through partners can be faster but still often take days to weeks and involve contracts with minimum terms.
- **D:** Accelerated VPN is a valid enhancement but adds cost. Standard VPN already meets the requirements.

---

### Answer 38
**Correct Answer: A, B**

Geolocation routing (A) routes users based on their geographic location — Europe to eu-west-1, Asia to ap-southeast-1, with a default record for all other locations. Health checks (B) associated with the geolocation records ensure that if a regional endpoint becomes unhealthy, traffic falls through to the default record (us-east-1).

**Why other options are wrong:**
- **C:** Latency-based routing doesn't guarantee geographic-based routing; a European user might be routed to us-east-1 if it has lower latency.
- **D:** Geoproximity routing uses location and bias but doesn't provide the strict geographic boundaries requested.
- **E:** Failover routing only supports one primary and one secondary, not geographic distribution.

---

### Answer 39
**Correct Answer: A**

An Egress-Only Internet Gateway is the IPv6 equivalent of a NAT Gateway for IPv4. It allows outbound IPv6 traffic from instances in private subnets while blocking inbound-initiated IPv6 connections from the internet. The /56 CIDR block provides more than enough addresses for millions of IoT devices.

**Why other options are wrong:**
- **B:** NAT Gateways don't support IPv6. NAT is an IPv4 concept; IPv6 uses Egress-Only IGW instead.
- **C:** Public subnets with security groups blocking inbound would still expose instance IPv6 addresses publicly, which may not meet security requirements.
- **D:** A dual-stack ALB handles HTTP/HTTPS, not arbitrary IoT protocols. It also doesn't solve the private subnet IPv6 outbound requirement.

---

### Answer 40
**Correct Answer: A, B**

Associating each private hosted zone with all VPCs that need resolution (A) is the primary mechanism for cross-VPC DNS resolution. For cross-account scenarios, VPCAssociationAuthorization is needed. Enabling DNS support on Transit Gateway VPC attachments (B) ensures that DNS queries can traverse the TGW between VPCs.

**Why other options are wrong:**
- **C:** Resolver rules with inbound endpoints add complexity and are typically for hybrid (on-premises) DNS scenarios, not VPC-to-VPC within AWS.
- **D:** A centralized DNS server on EC2 adds operational overhead and is a single point of failure.
- **E:** enableDnsHostnames and enableDnsSupport are VPC-level settings that enable DNS within the VPC but don't automatically enable cross-VPC resolution.

---

### Answer 41
**Correct Answer: A**

Kubernetes topology-aware routing (topology awareness hints) prefers routing traffic to endpoints in the same AZ, reducing inter-AZ data transfer while maintaining the ability to fall back to cross-AZ endpoints for availability. This is the most effective balance between cost and availability.

**Why other options are wrong:**
- **B:** Single-AZ deployment eliminates inter-AZ costs but creates a single point of failure, violating availability requirements.
- **C:** VPC endpoints are for accessing AWS services, not for inter-service communication within a VPC. They don't eliminate inter-AZ charges.
- **D:** App Mesh with Envoy doesn't compress traffic or eliminate inter-AZ data transfer charges.

---

### Answer 42
**Correct Answer: A**

Deploying a NAT Gateway per AZ ensures that an AZ failure only affects instances in that specific AZ. Each AZ's route table points to its local NAT Gateway, creating AZ-independent internet access.

**Why other options are wrong:**
- **B:** Route 53 doesn't support health checking and failover for NAT Gateways. NAT Gateways don't have DNS names or health check endpoints.
- **C:** NAT instances are less reliable than NAT Gateways and require managing instances. ASG failover introduces downtime during instance replacement.
- **D:** This reactive approach introduces downtime between failure detection and new NAT Gateway creation.

---

### Answer 43
**Correct Answer: A, B**

GWLB operates at Layer 3 and uses the GENEVE protocol (A) to encapsulate and forward traffic while preserving original source/destination IPs. GWLB endpoints (B) are deployed in the application VPC as route table targets, routing traffic to the GWLB in the security VPC transparently.

**Why other options are wrong:**
- **C:** GWLB operates at Layer 3, not Layer 7. It doesn't inspect HTTP content.
- **D:** GWLB doesn't replace NACLs and security groups. These are complementary security controls.
- **E:** GWLB can be used for both ingress/egress (north-south) and east-west traffic through proper routing configuration.

---

### Answer 44
**Correct Answer: A**

For us-east-1: 8 VPCs × /20 = 8 × 4,096 = 32,768 IPs. A /17 provides 32,768 addresses, fitting exactly. For eu-west-1: 4 VPCs × /20 = 4 × 4,096 = 16,384 IPs. A /18 provides 16,384 addresses. Each /20 provides 4,091 usable addresses (4,096 - 5), meeting the 4,000 requirement. Both allocations are contiguous for route summarization.

**Why other options are wrong:**
- **B:** /16 per region is larger than necessary. /19 blocks provide 8,187 usable IPs each — more than needed and wastes address space.
- **C:** A single /21 (2,048 addresses) is far too small for all VPCs. Secondary CIDR blocks would break contiguity.
- **D:** /16 per VPC is massively oversized and would quickly exhaust the 10.0.0.0/8 address space.

---

### Answer 45
**Correct Answer: A**

SCPs with the aws:sourceVpce or aws:sourceVpc condition key can deny API calls that don't originate from a specified VPC endpoint. Applied at the Organization root, this policy enforces the requirement across all accounts.

**Why other options are wrong:**
- **B:** Removing NAT Gateways breaks other internet-dependent functionality (downloading patches, accessing third-party APIs) and doesn't prevent API calls through other internet paths.
- **C:** VPC endpoint policies control what the endpoint allows, but they don't prevent instances from using alternative paths (NAT Gateway) to reach the same service.
- **D:** AWS Config detection and instance termination is reactive, not preventative. It also causes service disruption.

---

### Answer 46
**Correct Answer: A, D**

Disabling cross-zone load balancing (A) keeps traffic within the same AZ, eliminating the additional latency of cross-AZ hops. For ultra-low-latency applications, this is significant. Proxy Protocol v2 (D) preserves client source IP information, which is often required for trading platforms, with minimal overhead as it's a simple header addition.

**Why other options are wrong:**
- **B:** Changing to UDP is not appropriate for a trading platform that requires reliable, ordered delivery (TCP characteristics).
- **C:** IP-based targets don't reduce network hops — in fact, when targets are in different VPCs, they may add hops.
- **E:** Connection idle timeout affects when idle connections are closed, not throughput or latency optimization.

---

### Answer 47
**Correct Answer: A**

S3 Gateway VPC endpoints are free to create and use. They eliminate NAT Gateway data processing charges ($0.045/GB). With 10 TB daily, the savings are significant: 10,000 GB × $0.045 = $450/day saved on NAT Gateway data processing charges alone.

**Why other options are wrong:**
- **B:** Public subnets require public IPs and expose instances to the internet, creating security risks.
- **C:** S3 Interface endpoints (PrivateLink) have hourly charges (~$0.01/hour per AZ) and data processing charges ($0.01/GB), which would still cost ~$100/day for 10 TB. Gateway endpoints are free.
- **D:** Transfer Acceleration doesn't compress data and actually increases costs. It's designed for faster uploads, not cost reduction.

---

### Answer 48
**Correct Answer: A, D**

CloudFront geo-restriction (A) can block entire countries at the CDN level. AWS WAF (D) provides more granular control — it can block countries AND create URL path-based rules for Country A. Using WAF geo-match with URL conditions allows the complex Country A rule.

Alternatively, A and B together also work, but D alone covers both the country blocking and the Country A path restriction.

**Why other options are wrong:**
- **C:** Route 53 geolocation routing controls which endpoint users reach but doesn't block access or return 403 errors.
- **E:** Checking X-Forwarded-For at the origin adds latency and load on the origin server. The origin may not have accurate geo-IP mapping.

---

### Answer 49
**Correct Answer: A**

AWS Global Accelerator is designed for non-HTTP/HTTPS use cases that need persistent TCP/UDP connections, static IPs, and the AWS global network for consistent low latency. It doesn't cache content (which isn't needed here). It routes traffic to the optimal regional endpoint based on health, geography, and routing policies.

**Why other options are wrong:**
- **B:** CloudFront is primarily a CDN for HTTP/HTTPS content. While it supports dynamic content, it doesn't support arbitrary TCP connections.
- **C:** Using both services adds unnecessary complexity and cost for a purely TCP-based application.
- **D:** Route 53 latency-based routing doesn't provide the AWS backbone routing benefit. Traffic still traverses the public internet from the user to the regional endpoint.

---

### Answer 50
**Correct Answer: A**

BGP-based failover is automatic. When both Direct Connect and VPN advertise the same prefixes via BGP, AWS prefers Direct Connect (due to route preference: Direct Connect > VPN). If Direct Connect fails, BGP convergence automatically shifts traffic to the VPN tunnel.

**Why other options are wrong:**
- **B:** Route 53 operates at the DNS layer and cannot directly monitor or failover network connections like Direct Connect and VPN.
- **C:** Static routes require manual updates and don't provide automatic failover.
- **D:** Two Direct Connect connections are expensive and don't address the VPN backup requirement.

---

### Answer 51
**Correct Answer: A**

Both S3 and DynamoDB support Gateway VPC endpoints. Gateway endpoints are free (no hourly or data processing charges), appear as route table entries, and keep traffic within the AWS network. Each service requires its own endpoint, but both are gateway type.

**Why other options are wrong:**
- **B:** While Interface endpoints work for both services, they incur charges and are unnecessary when free Gateway endpoints are available.
- **C:** DynamoDB supports Gateway endpoints, not only Interface endpoints.
- **D:** Each Gateway endpoint serves a single AWS service; you cannot combine S3 and DynamoDB into one endpoint.

---

### Answer 52
**Correct Answer: A**

The two-route-table approach ensures traffic inspection. The spoke route table (for VPC-A and VPC-B attachments) has no direct routes between the spokes — only a default route to the Security VPC. This forces all traffic through the inspection VPC. The security route table has specific routes back to each spoke VPC for return traffic.

**Why other options are wrong:**
- **B:** A single route table with direct routes would allow VPC-A and VPC-B to communicate without inspection. BGP on Transit Gateway doesn't support the described approach.
- **C:** Three route tables add unnecessary complexity. The two-table model (spoke + security) is the standard and cleaner design.
- **D:** Blackhole routes would drop traffic entirely rather than redirect it for inspection.

---

### Answer 53
**Correct Answer: A**

NLB with instance-based targets natively preserves the client's source IP address (the target sees the original client IP). NLB supports Elastic IPs for static IP addresses, handles TCP traffic at Layer 4 with millions of connections per second, and distributes across multiple AZs.

**Why other options are wrong:**
- **B:** ALB doesn't support TCP listeners on arbitrary ports like 3306. ALB operates at Layer 7 (HTTP/HTTPS). Also, ALB doesn't support static IPs directly.
- **C:** With IP-based targets, client source IP is not preserved natively — Proxy Protocol is needed. While this works, instance-based targets preserve source IP without additional configuration.
- **D:** Classic Load Balancer is deprecated for new deployments and doesn't support static IPs.

---

### Answer 54
**Correct Answer: A**

S3 Gateway VPC endpoints are regional and only route traffic to S3 in the same region. Cross-region S3 requests will be routed through the NAT Gateway or Internet Gateway, not the Gateway endpoint. The prefix list in the route table only contains IP ranges for S3 in the local region.

**Why other options are wrong:**
- **B:** Gateway endpoints do not provide cross-region access. They are strictly regional.
- **C:** Cross-region S3 access is possible through NAT Gateway or IGW; replication is not required.
- **D:** Gateway endpoints are VPC-level resources in a specific region; you cannot create endpoints "in multiple regions" within a single VPC.

---

### Answer 55
**Correct Answer: A, C**

Amazon VPC Lattice (A) provides service-to-service connectivity with built-in IAM-based authentication and encryption, working across VPCs and compute types (EC2, ECS, EKS, Lambda). AWS App Mesh with mTLS (C) provides mutual authentication and encryption between services using Envoy sidecars, implementing zero-trust at the application level.

**Why other options are wrong:**
- **B:** Security groups provide network-level access control but don't authenticate connections or encrypt traffic. They're not a zero-trust mechanism.
- **D:** Network Firewall inspects traffic but doesn't authenticate individual service connections or provide encryption.
- **E:** VPC peering doesn't have an "encrypted peering option." VPC peering traffic within a region stays on the AWS network but isn't encrypted at the VPC level.

---

### Answer 56
**Correct Answer: A, B**

The CloudFront managed prefix list (A) restricts ALB inbound traffic to CloudFront's IP ranges at the network level. A custom header with a secret value (B) adds application-level verification — only CloudFront knows the secret header value, and the ALB rejects requests without it. This two-layer approach provides defense-in-depth.

**Why other options are wrong:**
- **C:** CloudFront CAN connect to internal ALBs only if they have a public DNS name (which internal ALBs don't). This would break connectivity.
- **D:** OAI only works with S3 origins, not ALB origins.
- **E:** CloudFront doesn't support VPN connections to origins.

---

### Answer 57
**Correct Answer: A**

Cross-account private hosted zone association requires a two-step process: the hosted zone owner (Account A) creates an authorization, and the target account associates its VPC with the hosted zone. This uses the CreateVPCAssociationAuthorization and AssociateVPCWithHostedZone APIs.

**Why other options are wrong:**
- **B:** VPC peering doesn't automatically enable private hosted zone resolution across VPCs. You still need to explicitly associate VPCs with the hosted zone.
- **C:** Exporting and importing records creates duplicate zones that can become out of sync. This is operationally complex and error-prone.
- **D:** Route 53 private hosted zones cannot be shared through AWS RAM.

---

### Answer 58
**Correct Answer: A**

AWS Network Firewall in a centralized inspection VPC with Transit Gateway is the standard architecture. TGW route tables direct all traffic (north-south and east-west) through the inspection VPC. Network Firewall provides managed auto-scaling, native logging to S3 and CloudWatch, and supports both stateful and stateless rules.

**Why other options are wrong:**
- **B:** Third-party firewalls require managing EC2 instances, patching, and scaling configuration — higher operational overhead.
- **C:** Deploying Network Firewall in every spoke VPC is expensive and doesn't centralize management or logging.
- **D:** Security groups can't be referenced across VPCs via Transit Gateway. VPC Flow Logs provide monitoring but not active inspection/blocking.

---

### Answer 59
**Correct Answer: A, B, C**

VPC Reachability Analyzer (A) performs path analysis to identify configuration issues (missing routes, NACLs, security groups). Transit Gateway Route Analyzer (B) verifies TGW route tables have correct routes for the destination CIDR. VPC Flow Logs (C) confirm packet-level behavior — whether traffic is being accepted or rejected.

**Why other options are wrong:**
- **D:** X-Ray traces application requests and service calls, not network packets. It doesn't operate at the network layer.
- **E:** Internet Monitor monitors internet path performance, not VPN or Direct Connect connectivity.
- **F:** Detective is for security investigation, not network troubleshooting.

---

### Answer 60
**Correct Answer: A**

Geoproximity routing with Route 53 Traffic Flow considers user location and resource location, with a configurable bias to shift traffic boundaries. Positive bias attracts more traffic; negative bias repels it. Combined with health checks, unhealthy endpoints are excluded.

**Why other options are wrong:**
- **B:** Geolocation routing uses strict geographic boundaries (country/continent) without bias adjustment capability.
- **C:** Latency-based routing doesn't have a bias mechanism. You can't manually adjust "latency" values.
- **D:** Multivalue answer routing returns multiple records randomly and doesn't support geographic awareness or bias.

---

### Answer 61
**Correct Answer: A**

VPC peering's key limitation is no transitive routing. With 5 VPCs in full mesh, you need 10 peering connections. Each new VPC requires a peering connection to every existing VPC. Transit Gateway provides transitive routing through a central hub, requiring only one attachment per VPC regardless of how many other VPCs exist.

**Why other options are wrong:**
- **B:** While the peering limit is 125, the management complexity grows quadratically (n×(n-1)/2 connections), making it impractical well before reaching the limit.
- **C:** Transit Gateway does add slight latency compared to VPC peering, but the management benefits outweigh this for most use cases. The threshold isn't 25 VPCs specifically.
- **D:** Transit Gateway provides significant benefits for same-region multi-VPC architectures, including centralized routing, network segmentation, and simplified management.

---

### Answer 62
**Correct Answer: B**

A single health check pointing to a custom /health endpoint that checks all conditions internally is the simplest and most reliable approach. The application's /health endpoint can verify HTTPS connectivity, return "SERVICE_OK" in the body (string matching verifies this), and check database health internally. This reduces the number of health checks and ensures atomic checking.

**Why other options are wrong:**
- **A:** The approach works but only includes two child checks. Also, with string matching on the first check, the /health approach is simpler.
- **C:** You cannot attach multiple health checks to a single Route 53 record. Only one health check per record is supported.
- **D:** CloudWatch-based health checks add delay (alarm evaluation periods) and complexity compared to direct endpoint checks.

---

### Answer 63
**Correct Answer: A**

AWS WAF on CloudFront supports all four requirements: IP set rules for blocking specific IPs, rate-based rules for request throttling, custom rules with header inspection for API key validation, and managed rule groups for SQL injection detection.

**Why other options are wrong:**
- **B:** CloudFront Functions have limited execution time and cannot perform complex operations like rate limiting (which requires state tracking) or comprehensive SQL injection detection.
- **C:** Shield Advanced provides DDoS protection but doesn't offer fine-grained controls like API key validation or SQL injection detection.
- **D:** Origin-level processing means malicious traffic has already reached the origin, consuming resources. WAF at CloudFront blocks traffic at the edge.

---

### Answer 64
**Correct Answer: A, B**

Deploying inbound endpoints in multiple AZs (A) ensures that if one AZ fails, the endpoints in the other AZ continue to handle queries. Configuring on-premises DNS to use both endpoint IPs (B) with failover ensures queries are sent to available endpoints.

**Why other options are wrong:**
- **C:** Route 53 Resolver endpoints don't have configurable "instance sizes." They scale automatically.
- **D:** Adding a caching DNS server adds complexity and another potential failure point.
- **E:** Route 53 Resolver inbound endpoints don't support DNS over HTTPS.

---

### Answer 65
**Correct Answer: A**

Regional API Gateway endpoints in multiple regions, each with local Lambda and DynamoDB Global Tables replicas, provide the lowest latency. Route 53 latency-based routing directs users to the nearest region. This architecture ensures that API calls, Lambda execution, and database reads/writes all happen in the region closest to the user.

**Why other options are wrong:**
- **B:** A single edge-optimized endpoint only optimizes the initial connection. Lambda and DynamoDB are still in a single region (us-east-1), causing high latency for users far from that region.
- **C:** Caching all responses for 60 seconds doesn't work for dynamic/transactional applications and causes stale data.
- **D:** Deploying in "every" region is excessive and expensive. Latency-based routing with strategic regional deployments is more practical than geolocation routing for latency optimization.

---

## Summary

| Question | Answer | Domain |
|----------|--------|--------|
| 1 | A | Security |
| 2 | A | Resilient Architecture |
| 3 | B | High-Performing Technology |
| 4 | A | High-Performing Technology |
| 5 | A, B, D | Security |
| 6 | A | High-Performing Technology |
| 7 | B | High-Performing Technology |
| 8 | A | Resilient Architecture |
| 9 | A | High-Performing Technology |
| 10 | A | Cost-Optimized Architecture |
| 11 | A, D | Security |
| 12 | A | Resilient Architecture |
| 13 | A | High-Performing Technology |
| 14 | A | Resilient Architecture |
| 15 | A, C | Security |
| 16 | A | High-Performing Technology |
| 17 | A, B, C | High-Performing Technology |
| 18 | A | Resilient Architecture |
| 19 | A | Security |
| 20 | A, B, C | Security |
| 21 | B | Security |
| 22 | A | High-Performing Technology |
| 23 | C | Resilient Architecture |
| 24 | A | Resilient Architecture |
| 25 | A | Security |
| 26 | A | Security |
| 27 | A, B, C | High-Performing Technology |
| 28 | A | Cost-Optimized Architecture |
| 29 | A | High-Performing Technology |
| 30 | A | Resilient Architecture |
| 31 | C | High-Performing Technology |
| 32 | A | Security |
| 33 | A | Resilient Architecture |
| 34 | A, B, D | Security |
| 35 | A | High-Performing Technology |
| 36 | A | Security |
| 37 | A | Cost-Optimized Architecture |
| 38 | A, B | Resilient Architecture |
| 39 | A | Security |
| 40 | A, B | Resilient Architecture |
| 41 | A | Cost-Optimized Architecture |
| 42 | A | Resilient Architecture |
| 43 | A, B | Security |
| 44 | A | Cost-Optimized Architecture |
| 45 | A | Security |
| 46 | A, D | High-Performing Technology |
| 47 | A | Cost-Optimized Architecture |
| 48 | A, D | Security |
| 49 | A | High-Performing Technology |
| 50 | A | Resilient Architecture |
| 51 | A | Cost-Optimized Architecture |
| 52 | A | Security |
| 53 | A | High-Performing Technology |
| 54 | A | Cost-Optimized Architecture |
| 55 | A, C | Security |
| 56 | A, B | Security |
| 57 | A | Security |
| 58 | A | Resilient Architecture |
| 59 | A, B, C | Resilient Architecture |
| 60 | A | Resilient Architecture |
| 61 | A | Cost-Optimized Architecture |
| 62 | B | Resilient Architecture |
| 63 | A | Security |
| 64 | A, B | Resilient Architecture |
| 65 | A | High-Performing Technology |
