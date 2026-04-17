# Networking Question Bank

**AWS Solutions Architect Associate (SAA-C03) — Topic-Wise Practice**
**Total Questions: 30**

---

### Question 1
A company has a VPC with public and private subnets in `us-east-1`. Instances in the private subnet need to download patches from the internet. The company wants a highly available solution. What should the solutions architect configure?

A) Deploy a single NAT gateway in one public subnet and update the private subnet route tables
B) Deploy a NAT gateway in each Availability Zone's public subnet and update the corresponding private subnet route tables
C) Deploy a NAT instance in a private subnet and update the route tables
D) Attach an internet gateway directly to the private subnet

**Answer: B**
**Explanation:** For high availability, NAT gateways should be deployed in each AZ. If one AZ fails, instances in other AZs still have internet access through their local NAT gateway. A single NAT gateway (A) creates a single point of failure. NAT instances (C) require manual management and are placed in public subnets, not private. Internet gateways (D) are attached at the VPC level and don't make private subnets public.

---

### Question 2
A solutions architect is designing a network for an application that requires instances in two different VPCs to communicate. VPC A has CIDR `10.0.0.0/16` and VPC B has CIDR `10.0.0.0/16`. What is the issue?

A) VPC peering cannot be established because the CIDR blocks overlap
B) VPC peering will work but only in one direction
C) VPC peering requires an internet gateway in both VPCs
D) VPC peering will work but requires a NAT gateway for address translation

**Answer: A**
**Explanation:** VPC peering requires non-overlapping CIDR blocks. If both VPCs have the same or overlapping CIDR ranges, peering cannot be established. There is no NAT capability in VPC peering to translate addresses. One VPC's CIDR would need to be changed, or an alternative like AWS PrivateLink could be used for specific service communication.

---

### Question 3
A company is running a multi-tier web application. The web tier is in a public subnet and the application tier is in a private subnet. The security team requires that the application tier only accepts traffic on port 8080 from the web tier. How should this be configured using security groups?

A) Configure the application tier's security group to allow inbound on port 8080 from `0.0.0.0/0`
B) Configure the application tier's security group to allow inbound on port 8080 from the web tier's security group ID
C) Configure a NACL on the application tier's subnet to allow port 8080 from the web tier's CIDR
D) Configure the web tier's security group to allow outbound on port 8080 only

**Answer: B**
**Explanation:** Security groups can reference other security groups as the source. By referencing the web tier's security group ID, only instances attached to that security group can access port 8080. This is more dynamic and secure than using CIDR blocks. Option A allows all traffic. Option C uses NACLs which are stateless and less precise. Option D only controls outbound and doesn't restrict what can reach the app tier.

---

### Question 4
A company needs to connect 15 VPCs that must communicate with each other. They also need a central point for VPN connections back to their on-premises data center. What architecture should the solutions architect recommend?

A) Create VPC peering connections between all 15 VPCs (full mesh) and a separate VPN per VPC
B) Use AWS Transit Gateway to connect all 15 VPCs and the on-premises VPN
C) Use AWS PrivateLink to connect the VPCs
D) Deploy a VPN appliance in one VPC and route all traffic through it

**Answer: B**
**Explanation:** Transit Gateway acts as a hub-and-spoke model, allowing thousands of VPCs and on-premises networks to connect through a single gateway. Full mesh peering (A) requires 105 connections (n*(n-1)/2) which is operationally complex. PrivateLink (C) is for service-to-service connectivity, not VPC-to-VPC routing. A VPN appliance (D) creates a bottleneck and single point of failure.

---

### Question 5
A company hosts a website on EC2 instances behind an Application Load Balancer. They need to route traffic based on the URL path: `/api/*` to one target group and `/static/*` to another. What type of routing rule should be configured?

A) Host-based routing
B) Path-based routing
C) Query string routing
D) HTTP header routing

**Answer: B**
**Explanation:** Application Load Balancer supports path-based routing, which routes requests to different target groups based on the URL path. `/api/*` and `/static/*` are path patterns. Host-based routing (A) routes based on the hostname in the request. Query string routing (C) and header routing (D) are also ALB features but not applicable here.

---

### Question 6
A company operates in `eu-west-1` and needs to connect their on-premises data center to AWS with a dedicated, consistent, low-latency connection that does not traverse the public internet. The connection must support 10 Gbps throughput. What should the architect recommend?

A) AWS Site-to-Site VPN with two tunnels
B) AWS Direct Connect with a 10 Gbps dedicated connection
C) AWS Client VPN
D) AWS Transit Gateway with VPN attachment

**Answer: B**
**Explanation:** AWS Direct Connect provides a dedicated physical connection between on-premises and AWS that does not traverse the public internet. It supports 1 Gbps and 10 Gbps dedicated connections. Site-to-Site VPN (A) traverses the public internet and has bandwidth limitations. Client VPN (C) is for individual user access. Transit Gateway (D) doesn't provide the physical connection.

---

### Question 7
A company has a Direct Connect link for their primary connection to AWS. They need a cost-effective backup connection for failover. What is the MOST cost-effective solution?

A) Set up a second Direct Connect link from a different location
B) Configure an AWS Site-to-Site VPN as a backup over the internet
C) Use VPC peering to another region as a backup
D) Set up AWS Global Accelerator as a failover mechanism

**Answer: B**
**Explanation:** A Site-to-Site VPN over the internet is the most cost-effective backup for Direct Connect. If the Direct Connect link fails, traffic fails over to the VPN. A second Direct Connect (A) provides the best redundancy but is expensive. VPC peering (C) doesn't provide connectivity to on-premises. Global Accelerator (D) is for improving performance to end users, not hybrid connectivity.

---

### Question 8
A company hosts a DNS domain in Route 53. They want to route traffic to the closest AWS region to reduce latency for global users. Which Route 53 routing policy should they use?

A) Simple routing
B) Weighted routing
C) Latency-based routing
D) Geolocation routing

**Answer: C**
**Explanation:** Latency-based routing directs users to the AWS region with the lowest network latency. Geolocation routing (D) routes based on user location but doesn't account for actual latency — a user might be geographically closer to one region but have lower latency to another. Simple routing (A) doesn't consider location. Weighted routing (B) distributes based on percentages, not latency.

---

### Question 9
A company wants to privately access S3 from their VPC without traffic going over the internet. They want the MOST cost-effective solution for transferring large amounts of data. What should they use?

A) S3 VPC gateway endpoint
B) S3 VPC interface endpoint (PrivateLink)
C) NAT gateway with a route to S3
D) VPN connection to S3

**Answer: A**
**Explanation:** S3 gateway endpoints are free (no data processing or hourly charges) and allow private access to S3 from within a VPC. They are ideal for large data transfers. Interface endpoints (B) using PrivateLink have hourly and data processing charges. NAT gateway (C) incurs data processing charges and traffic exits the VPC. VPN (D) adds unnecessary complexity.

---

### Question 10
A web application running behind a CloudFront distribution experiences intermittent 504 errors. The origin is an ALB in front of EC2 instances. What is the MOST likely cause?

A) CloudFront is caching error responses
B) The origin is taking too long to respond and CloudFront is timing out
C) The S3 origin is returning access denied errors
D) The CloudFront distribution's SSL certificate has expired

**Answer: B**
**Explanation:** A 504 error (Gateway Timeout) means CloudFront could not connect to or get a timely response from the origin. This typically happens when the ALB or backend instances are overloaded or taking too long to process requests. Cached errors (A) would typically be 4xx. The origin is ALB, not S3 (C). SSL issues (D) would cause 502 errors.

---

### Question 11
A company has a Network Load Balancer (NLB) that needs to route traffic to targets in different VPCs. How can this be achieved?

A) Use VPC peering between the VPCs and register the IP addresses as targets
B) NLBs can only route to targets within the same VPC
C) Use Transit Gateway and register the target group with DNS names
D) Create an NLB in each VPC and chain them together

**Answer: A**
**Explanation:** NLBs support IP address target type, which allows registering targets by IP address across peered VPCs, different AZs, or even on-premises networks (via Direct Connect/VPN). This requires VPC peering or Transit Gateway for network connectivity. Option B is incorrect as NLBs support cross-VPC targets via IP registration.

---

### Question 12
A company wants to protect their web application from common web exploits such as SQL injection and cross-site scripting (XSS). The application is fronted by an Application Load Balancer. What should the architect recommend?

A) Configure security group rules to block SQL injection patterns
B) Attach AWS WAF to the ALB with managed rule groups for SQL injection and XSS
C) Enable AWS Shield Advanced on the ALB
D) Use a Network Load Balancer instead, which has built-in security features

**Answer: B**
**Explanation:** AWS WAF can be attached to ALBs, CloudFront, and API Gateway. It provides managed rule groups that protect against SQL injection, XSS, and other OWASP top 10 vulnerabilities. Security groups (A) operate at L3/L4 and cannot inspect HTTP content. Shield Advanced (C) protects against DDoS, not application-layer exploits. NLBs (D) operate at L4 and don't inspect application-layer content.

---

### Question 13
A company needs their application to communicate with a third-party SaaS product hosted in another VPC (different AWS account) over a private connection. They only need access to a specific service endpoint, not the entire VPC network. What solution should the architect recommend?

A) VPC peering between the two VPCs
B) AWS PrivateLink (VPC endpoint service)
C) Transit Gateway attachment
D) Site-to-Site VPN between the VPCs

**Answer: B**
**Explanation:** AWS PrivateLink allows private connectivity between VPCs to specific services without exposing the entire VPC network. The SaaS provider creates an endpoint service (NLB-backed), and the consumer creates an interface VPC endpoint. This follows the principle of least privilege for network access. VPC peering (A) and Transit Gateway (C) expose the entire VPC. VPN (D) is unnecessary between AWS VPCs.

---

### Question 14
A Network Access Control List (NACL) on a private subnet has the following rules:
- Rule 100: Allow inbound TCP port 443 from `10.0.1.0/24`
- Rule 200: Deny all inbound traffic
- Rule *: Deny all inbound traffic

An outbound response on an ephemeral port to `10.0.1.0/24` is failing. What is the MOST likely cause?

A) NACLs are stateful, so the return traffic should be automatically allowed
B) The outbound rules of the NACL do not allow traffic on ephemeral ports to `10.0.1.0/24`
C) The security group is blocking outbound traffic
D) The route table doesn't have a route to `10.0.1.0/24`

**Answer: B**
**Explanation:** NACLs are stateless, meaning return traffic must be explicitly allowed by outbound rules. Even though inbound port 443 is allowed, the outbound NACL rules must explicitly allow traffic on the ephemeral port range (1024-65535) for the response. Security groups (C) are stateful and allow return traffic automatically, but NACLs are evaluated separately.

---

### Question 15
A company needs to serve content from an S3 bucket through CloudFront. The S3 bucket should NOT be publicly accessible, and only CloudFront should be able to access it. What should the architect configure?

A) Make the S3 bucket public and use CloudFront to cache the content
B) Use an Origin Access Control (OAC) with a CloudFront distribution and update the S3 bucket policy to allow only the OAC
C) Use a VPC endpoint for S3 and route CloudFront through the VPC
D) Use a pre-signed URL for every CloudFront request

**Answer: B**
**Explanation:** Origin Access Control (OAC) is the recommended method (replacing the older Origin Access Identity/OAI) to restrict S3 access to only CloudFront. The bucket policy is updated to allow access only from the specific OAC. Making the bucket public (A) violates the requirement. CloudFront doesn't run in a VPC (C). Pre-signed URLs (D) are unnecessary and complex for this use case.

---

### Question 16
A company's application requires sticky sessions on their load balancer. The application stores session data in memory on each EC2 instance. They are using an Application Load Balancer. How should sticky sessions be configured?

A) Enable session affinity (sticky sessions) on the ALB target group using application-based cookies
B) Use a Network Load Balancer instead, which automatically supports sticky sessions
C) Configure Route 53 with weighted routing to direct users to specific instances
D) Store sessions in the ALB's built-in session storage

**Answer: A**
**Explanation:** ALB supports sticky sessions (session affinity) using either duration-based cookies or application-based cookies. This ensures a user's requests go to the same target during a session. NLB (B) supports sticky sessions at the TCP level but uses a different mechanism. Route 53 (C) doesn't provide session-level stickiness. ALBs (D) don't have built-in session storage.

---

### Question 17
A company needs to host a DNS record that points to an ALB. They want the record to be recognized as an alias and avoid additional DNS query charges. What type of Route 53 record should they create?

A) CNAME record pointing to the ALB DNS name
B) A record with Alias enabled pointing to the ALB
C) TXT record with the ALB IP address
D) MX record pointing to the ALB

**Answer: B**
**Explanation:** Route 53 Alias records can point to AWS resources like ALBs, CloudFront distributions, and S3 buckets. Alias records are free (no DNS query charges) and can be used at the zone apex (unlike CNAME). CNAME records (A) incur charges and cannot be used at the zone apex. TXT (C) and MX (D) records are for different purposes.

---

### Question 18
A company has multiple microservices running on ECS behind separate ALBs. They want to expose all services through a single domain using different paths (e.g., `/orders`, `/inventory`). API Gateway is not suitable due to payload size limits. What should the architect recommend?

A) Use a single ALB with path-based routing rules directing to different target groups
B) Use Route 53 with weighted routing
C) Deploy a reverse proxy on EC2
D) Use CloudFront with multiple origins and behaviors

**Answer: A**
**Explanation:** A single ALB with path-based routing can direct different URL paths to different target groups (each running a microservice). This consolidates the ALBs into one and provides a single entry point. Route 53 weighted routing (B) isn't path-aware. A reverse proxy (C) adds operational overhead. CloudFront (D) works but is primarily a CDN, and ALB path-based routing is simpler.

---

### Question 19
A company wants to accelerate the performance of their TCP-based application for global users. The application is hosted in `us-east-1`. Users in Asia and Europe experience high latency. What should the architect recommend?

A) Deploy the application in multiple regions with Route 53 latency routing
B) Use AWS Global Accelerator with an endpoint in `us-east-1`
C) Use Amazon CloudFront to cache the application content
D) Increase the instance size to improve response time

**Answer: B**
**Explanation:** AWS Global Accelerator provides static anycast IP addresses and routes traffic over the AWS global network to the optimal endpoint. This reduces latency for TCP/UDP applications without needing multi-region deployment. CloudFront (C) is primarily for HTTP/HTTPS content and caching. Multi-region deployment (A) is more complex and expensive. Instance size (D) doesn't address network latency.

---

### Question 20
A company has a VPC with CIDR `10.0.0.0/16`. They need to add more IP addresses because the existing address space is running out. What should the architect do?

A) Modify the existing CIDR block to a larger range
B) Associate a secondary CIDR block with the VPC
C) Delete the VPC and recreate it with a larger CIDR
D) Use Elastic IP addresses to extend the address space

**Answer: B**
**Explanation:** VPCs support adding secondary CIDR blocks (up to 5 by default, extendable). The primary CIDR cannot be modified (A). Deleting and recreating (C) would cause downtime and is unnecessary. Elastic IPs (D) are public IPs and don't extend the private address space.

---

### Question 21
A company needs to connect two VPCs where resources in VPC A need to access a specific service in VPC B. VPC B has CIDR `10.1.0.0/16` and the service runs on port 443. The company wants to minimize the exposure of VPC B's network. What should the architect use?

A) VPC peering with security groups restricting access to port 443
B) AWS PrivateLink to expose only the specific service
C) Transit Gateway with route table restrictions
D) Site-to-Site VPN between the two VPCs

**Answer: B**
**Explanation:** PrivateLink exposes only specific services (via NLB) rather than the entire VPC network. This follows the principle of least privilege. VPC peering (A) with security groups can restrict ports but still exposes the routing table to the entire CIDR. Transit Gateway (C) also provides full VPC routing. VPN (D) is more suitable for on-premises connections.

---

### Question 22
A company has an ALB in a public subnet. The EC2 instances behind the ALB are in a private subnet. Users report they can access the website but the instances cannot download updates from the internet. What is missing?

A) An internet gateway in the VPC
B) A NAT gateway in a public subnet with a route in the private subnet's route table
C) A public IP assigned to each EC2 instance
D) An Elastic IP attached to the ALB

**Answer: B**
**Explanation:** Instances in a private subnet need a NAT gateway (in a public subnet) to reach the internet for outbound connections like downloading updates. The ALB handles inbound web traffic, but outbound from instances requires NAT. An internet gateway (A) already exists (the ALB is public). Public IPs on instances (C) would make them public. ALBs (D) already have public DNS names.

---

### Question 23
A company wants to implement a hub-and-spoke network model where the hub VPC runs shared services (AD, DNS, monitoring) and spoke VPCs host application workloads. Spoke VPCs should NOT communicate with each other directly. What should the architect configure?

A) Transit Gateway with separate route tables for hub and spoke, ensuring spoke route tables only have routes to the hub
B) VPC peering between each spoke and the hub VPC
C) Transit Gateway with a single route table allowing all VPC-to-VPC traffic
D) AWS PrivateLink between each spoke and the hub

**Answer: A**
**Explanation:** Transit Gateway with multiple route tables allows granular routing control. By creating separate route tables, spoke VPCs can be configured to only route traffic to the hub VPC, preventing direct spoke-to-spoke communication. VPC peering (B) also works but doesn't scale well. A single Transit Gateway route table (C) would allow spoke-to-spoke traffic. PrivateLink (D) is for specific services, not general VPC connectivity.

---

### Question 24
An application requires client IP addresses to be preserved when traffic passes through a load balancer. The application uses TCP protocol. Which load balancer type preserves client IP addresses by default?

A) Application Load Balancer
B) Network Load Balancer with instance targets
C) Classic Load Balancer
D) Gateway Load Balancer

**Answer: B**
**Explanation:** NLB preserves the client source IP address when using instance-type targets by default (via DSR - Direct Server Return for TCP). ALB (A) uses the `X-Forwarded-For` header to pass client IP but modifies the source. Classic LB (C) uses the `X-Forwarded-For` header. Note: NLB with IP targets does NOT preserve client IP by default — proxy protocol v2 must be enabled.

---

### Question 25
A company's security team requires that all traffic between their VPCs and S3 must not traverse the public internet. They also need to apply a policy that restricts which S3 buckets can be accessed from the VPC. What should the architect configure?

A) S3 gateway endpoint with a VPC endpoint policy restricting access to specific buckets
B) S3 interface endpoint with a security group
C) NAT gateway with S3 bucket policies restricting access by NAT gateway IP
D) AWS PrivateLink for S3 with an endpoint policy

**Answer: A**
**Explanation:** An S3 gateway endpoint keeps traffic within the AWS network and supports endpoint policies to restrict which S3 buckets can be accessed from the VPC. This is the simplest and most cost-effective solution. Interface endpoints (B) work but are more expensive and are needed only for on-premises access scenarios. NAT gateway (C) traffic exits the VPC. PrivateLink for S3 (D) is essentially an interface endpoint and is costlier.

---

### Question 26
A company runs a latency-sensitive application in `eu-west-1`. They need to replicate data to `us-east-1` for disaster recovery. Cross-region traffic must use the AWS backbone, not the public internet. What should the architect configure?

A) VPC peering between the two regions — peering traffic automatically uses the AWS backbone
B) A Site-to-Site VPN between the VPCs in both regions
C) AWS Direct Connect with a cross-connect to both regions
D) Internet-based transfer with HTTPS encryption

**Answer: A**
**Explanation:** Inter-region VPC peering traffic is routed through the AWS backbone network and never traverses the public internet. This provides encrypted, low-latency, high-bandwidth connectivity. VPN (B) can work but adds overhead. Direct Connect (C) requires physical connections. Internet-based (D) traverses the public internet, violating the requirement.

---

### Question 27
A company runs an application behind a Network Load Balancer. They need to implement TLS termination at the load balancer. The TLS certificate must be automatically renewed. What should the architect configure?

A) Import a self-signed certificate into the NLB
B) Use AWS Certificate Manager (ACM) to provision a certificate and attach it to the NLB TLS listener
C) Install the TLS certificate directly on the backend instances
D) Use a third-party certificate stored in AWS Secrets Manager

**Answer: B**
**Explanation:** ACM provides free TLS certificates that are automatically renewed. NLB supports TLS listeners for TLS termination and integrates directly with ACM. Self-signed certificates (A) are not trusted by browsers. Installing on instances (C) doesn't terminate at the load balancer. Secrets Manager (D) doesn't integrate directly with NLB for TLS termination.

---

### Question 28
A company's CloudFront distribution serves content to users globally. They need to restrict access to content so that only users in the United States and Canada can view it. What should the architect configure?

A) S3 bucket policy with an IP-based condition
B) CloudFront geo restriction (geographic restrictions) to allow only US and CA
C) Route 53 geolocation routing to direct non-US/CA users to a "blocked" page
D) WAF rule attached to CloudFront that blocks non-US/CA IP ranges

**Answer: B**
**Explanation:** CloudFront geo restriction natively supports allowlisting or denylisting countries. Configuring it to allow only US and CA will return a 403 for users in other countries. S3 bucket policies (A) work for direct S3 access but CloudFront caches content. Route 53 (C) could work but adds complexity. WAF (D) can do this but is more expensive than built-in geo restriction.

---

### Question 29
A company has a hybrid architecture with an on-premises DNS server and Route 53. They need on-premises servers to resolve DNS records in a Route 53 private hosted zone. What should the architect configure?

A) Configure on-premises DNS to forward queries directly to Route 53
B) Create Route 53 Resolver inbound endpoints in the VPC and configure on-premises DNS to forward queries to the endpoint IP addresses
C) Replicate all Route 53 records to the on-premises DNS server
D) Use a VPN to allow direct DNS queries to the Route 53 service endpoint

**Answer: B**
**Explanation:** Route 53 Resolver inbound endpoints receive DNS queries from on-premises networks (via Direct Connect or VPN) and resolve them against Route 53 private hosted zones. On-premises DNS servers are configured to forward specific domains to the inbound endpoint IP addresses. Direct forwarding to Route 53 (A) doesn't work for private hosted zones. Manual replication (C) is unmaintainable. VPN (D) alone doesn't provide DNS resolution.

---

### Question 30
A company wants to deploy a third-party network appliance (firewall) to inspect all traffic entering and leaving their VPC. Traffic must be transparently redirected through the appliance without changing application configurations. What should the architect use?

A) Application Load Balancer with the appliance as a target
B) Network Load Balancer in front of the appliance
C) Gateway Load Balancer with the appliance as a target
D) Transit Gateway with a VPN attachment to the appliance

**Answer: C**
**Explanation:** Gateway Load Balancer (GWLB) is specifically designed for deploying, scaling, and managing third-party virtual network appliances. It operates at Layer 3 and uses the GENEVE protocol to transparently redirect traffic through appliances for inspection. ALB (A) and NLB (B) are not designed for transparent traffic inspection. Transit Gateway (D) doesn't provide the transparent inline inspection capability.

---

*End of Networking Question Bank*
